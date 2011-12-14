unit u_TileDownloaderSimple;

interface
uses
  Windows,
  SyncObjs,
  Classes,
  i_JclNotify,
  i_OperationNotifier,
  i_LastResponseInfo,
  i_Downloader,
  i_TileRequest,
  i_TileDownloadResultSaver,
  i_TileDownloaderConfig,
  i_TileDownloader,
  i_TileDownloadRequestBuilder,
  u_OperationNotifier;

type
  TTileDownloaderSimple = class(TInterfacedObject, ITileDownloader)
  private
    FTileDownloadRequestBuilder: ITileDownloadRequestBuilder;
    FTileDownloaderConfig: ITileDownloaderConfig;
    FHttpDownloader: IDownloader;
    FResultSaver: ITileDownloadResultSaver;
    FAppClosingNotifier: IJclNotifier;
    FLastResponseInfo: ILastResponseInfo;

    FDestroyNotifierInternal: IOperationNotifierInternal;
    FDestroyNotifier: IOperationNotifier;
    FDestroyOperationID: Integer;

    FAppClosingListener: IJclListener;
    FCS: TCriticalSection;
    FCancelListener: IJclListener;
    FConfigChangeListener: IJclListener;
    FCancelEvent: TEvent;
    FWasConnectError: Boolean;
    FLastDownloadTime: Cardinal;

    FDownloadTryCount: Integer;
    FSleepOnResetConnection: Cardinal;
    FSleepAfterDownload: Cardinal;
    procedure OnConfigChange;
    procedure OnCancelEvent;
    procedure OnAppClosing;
    procedure SleepCancelable(ATime: Cardinal);
    procedure SleepIfConnectErrorOrWaitInterval;
  protected
    procedure Download(
      ATileRequest: ITileRequest
    );
  public
    constructor Create(
      AAppClosingNotifier: IJclNotifier;
      ATileDownloadRequestBuilder: ITileDownloadRequestBuilder;
      ATileDownloaderConfig: ITileDownloaderConfig;
      AHttpDownloader: IDownloader;
      AResultSaver: ITileDownloadResultSaver;
      ALastResponseInfo: ILastResponseInfo
    );
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  i_InetConfig,
  i_DownloadResult,
  i_TileDownloadRequest,
  i_TileRequestResult,
  u_NotifyEventListener,
  u_TileRequestResult;

{ TITileDownloaderSimple }

constructor TTileDownloaderSimple.Create(
  AAppClosingNotifier: IJclNotifier;
  ATileDownloadRequestBuilder: ITileDownloadRequestBuilder;
  ATileDownloaderConfig: ITileDownloaderConfig;
  AHttpDownloader: IDownloader;
  AResultSaver: ITileDownloadResultSaver;
  ALastResponseInfo: ILastResponseInfo
);
var
  VOperationNotifier: TOperationNotifier;
begin
  FAppClosingNotifier := AAppClosingNotifier;
  FTileDownloadRequestBuilder := ATileDownloadRequestBuilder;
  FTileDownloaderConfig := ATileDownloaderConfig;
  FHttpDownloader := AHttpDownloader;
  FResultSaver := AResultSaver;
  FLastResponseInfo := ALastResponseInfo;
  Assert(FResultSaver<>nil);

  VOperationNotifier := TOperationNotifier.Create;
  FDestroyNotifierInternal := VOperationNotifier;
  FDestroyNotifier := VOperationNotifier;
  FDestroyOperationID := FDestroyNotifier.CurrentOperation;

  FAppClosingListener := TNotifyNoMmgEventListener.Create(Self.OnAppClosing);
  FAppClosingNotifier.Add(FAppClosingListener);

  FCS := TCriticalSection.Create;
  FCancelEvent := TEvent.Create;
  FCancelListener := TNotifyNoMmgEventListener.Create(Self.OnCancelEvent);
  FConfigChangeListener := TNotifyNoMmgEventListener.Create(Self.OnConfigChange);
  FTileDownloaderConfig.ChangeNotifier.Add(FConfigChangeListener);
  FWasConnectError := False;
end;

destructor TTileDownloaderSimple.Destroy;
begin
  FDestroyNotifierInternal.NextOperation;
  FAppClosingNotifier.Remove(FAppClosingListener);
  FAppClosingListener := nil;
  FAppClosingNotifier := nil;

  FTileDownloaderConfig.ChangeNotifier.Remove(FConfigChangeListener);
  FConfigChangeListener := nil;
  FTileDownloaderConfig := nil;

  FreeAndNil(FCS);
  FreeAndNil(FCancelEvent);
  inherited;
end;

procedure TTileDownloaderSimple.Download(
  ATileRequest: ITileRequest
);
var
  VDownloadRequest: ITileDownloadRequest;
  VTileRequestResult: ITileRequestResult;
  VDownloadResult: IDownloadResult;
  VCount: Integer;
  VTryCount: Integer;
  VResultWithRespond: IDownloadResultWithServerRespond;
begin
  ATileRequest.StartNotifier.Notify(ATileRequest);
  try
    if not ATileRequest.CancelNotifier.IsOperationCanceled(ATileRequest.OperationID) then begin
      FCS.Acquire;
      try
        if not ATileRequest.CancelNotifier.IsOperationCanceled(ATileRequest.OperationID) then begin
          FCancelEvent.ResetEvent;
          ATileRequest.CancelNotifier.AddListener(FCancelListener);
          try
            if not ATileRequest.CancelNotifier.IsOperationCanceled(ATileRequest.OperationID) then begin
              VTileRequestResult := nil;
              VCount := 0;
              VTryCount := FDownloadTryCount;
              repeat
                SleepIfConnectErrorOrWaitInterval;
                if ATileRequest.CancelNotifier.IsOperationCanceled(ATileRequest.OperationID) then begin
                  VTileRequestResult := TTileRequestResultCanceledBeforBuildDownloadRequest.Create(ATileRequest);
                  Break;
                end;
                try
                  VDownloadRequest := FTileDownloadRequestBuilder.BuildRequest(
                    ATileRequest,
                    FLastResponseInfo
                  );
                except
                  on E: Exception do begin
                    VTileRequestResult :=
                      TTileRequestResultErrorBeforBuildDownloadRequest.Create(
                        ATileRequest,
                        E.Message
                      );
                    Break;
                  end;
                end;
                if VDownloadRequest = nil then begin
                  VTileRequestResult :=
                    TTileRequestResultErrorBeforBuildDownloadRequest.Create(
                      ATileRequest,
                      'Tile not exists'
                    );
                  Break;
                end;
                if ATileRequest.CancelNotifier.IsOperationCanceled(ATileRequest.OperationID) then begin
                  VTileRequestResult := TTileRequestResultCanceledAfterBuildDownloadRequest.Create(VDownloadRequest);
                  Break;
                end;
                VDownloadResult :=
                  FHttpDownloader.DoRequest(
                    VDownloadRequest,
                    FDestroyNotifier,
                    FDestroyOperationID
                  );
                Inc(VCount);
                FLastDownloadTime := GetTickCount;
                if VDownloadResult <> nil then begin
                  if VDownloadResult.IsServerExists then begin
                    FWasConnectError := False;
                    if Supports(VDownloadResult, IDownloadResultWithServerRespond, VResultWithRespond) then begin
                      FLastResponseInfo.ResponseHead := VResultWithRespond.RawResponseHeader;
                    end;
                  end else begin
                    FWasConnectError := True;
                  end;
                end;
                try
                  FResultSaver.SaveDownloadResult(VDownloadResult);
                  VTileRequestResult := TTileRequestResultOk.Create(VDownloadResult);
                except
                  on E: Exception do begin
                    VTileRequestResult := TTileRequestResultErrorAfterDownloadRequest.Create(
                      VDownloadResult,
                      E.Message
                    );
                  end;
                end;
              until (not FWasConnectError) or (VCount >= VTryCount);
            end else begin
              VTileRequestResult := TTileRequestResultCanceledBeforBuildDownloadRequest.Create(ATileRequest);
            end;
          finally
            ATileRequest.CancelNotifier.RemoveListener(FCancelListener);
          end;
        end else begin
          VTileRequestResult := TTileRequestResultCanceledBeforBuildDownloadRequest.Create(ATileRequest);
        end;
      finally
        FCS.Release;
      end;
    end else begin
      VTileRequestResult := TTileRequestResultCanceledBeforBuildDownloadRequest.Create(ATileRequest);
    end;
  finally
    ATileRequest.FinishNotifier.Notify(VTileRequestResult);
  end;
end;

procedure TTileDownloaderSimple.OnAppClosing;
begin
  FDestroyNotifierInternal.NextOperation;
  FCancelEvent.SetEvent;
end;

procedure TTileDownloaderSimple.OnCancelEvent;
begin
  FCancelEvent.SetEvent;
end;

procedure TTileDownloaderSimple.OnConfigChange;
var
  VTileDownloaderConfigStatic: ITileDownloaderConfigStatic;
begin
  VTileDownloaderConfigStatic := FTileDownloaderConfig.GetStatic;
  FDownloadTryCount := VTileDownloaderConfigStatic.InetConfigStatic.DownloadTryCount;
  FSleepOnResetConnection := VTileDownloaderConfigStatic.InetConfigStatic.SleepOnResetConnection;
  FSleepAfterDownload := VTileDownloaderConfigStatic.WaitInterval;
end;

procedure TTileDownloaderSimple.SleepCancelable(ATime: Cardinal);
begin
  if ATime > 0 then begin
    FCancelEvent.WaitFor(ATime);
  end;
end;

procedure TTileDownloaderSimple.SleepIfConnectErrorOrWaitInterval;
var
  VNow: Cardinal;
  VTimeFromLastDownload: Cardinal;
  VSleepTime: Cardinal;
  VInterval: Cardinal;
begin
  VNow := GetTickCount;

  if VNow >= FLastDownloadTime then begin
    VTimeFromLastDownload := VNow - FLastDownloadTime;
  end else begin
    VTimeFromLastDownload := MaxInt;
  end;

  if FWasConnectError then begin
    VInterval := FSleepOnResetConnection;
  end else begin
    VInterval := FSleepAfterDownload;
  end;

  if VTimeFromLastDownload < VInterval then begin
    VSleepTime := VInterval - VTimeFromLastDownload;
    SleepCancelable(VSleepTime);
  end;
end;

end.
