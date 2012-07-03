unit u_TileRequestProcessorPool;

interface

uses
  SysUtils,
  i_Notifier,
  i_Listener,
  i_Thread,
  i_ThreadConfig,
  i_ListenerTTLCheck,
  i_NotifierTTLCheck,
  i_TileRequestQueue,
  i_TileDownloaderList,
  i_ITileRequestProcessorPool;

type
  TTileRequestProcessorPool = class(TInterfacedObject, ITileRequestProcessorPool)
  private
    type
    TArrayOfThread = array of IThread;
  private
    FThreadConfig: IThreadConfig;
    FDownloaderList: ITileDownloaderList;
    FGCList: INotifierTTLCheck;
    FAppClosingNotifier: INotifier;
    FTileRequestQueue: ITileRequestQueue;

    FTTLListener: IListenerTTLCheck;
    FDownloadersListListener: IListener;

    FThreadArray: TArrayOfThread;
    FThreadArrayCS: IReadWriteSync;

    procedure OnTTLTrim(Sender: TObject);
    procedure OnDownloadersListChange;
  private
    procedure InitThreadsIfNeed;
  public
    constructor Create(
      const AGCList: INotifierTTLCheck;
      const AThreadConfig: IThreadConfig;
      const AAppClosingNotifier: INotifier;
      const ATileRequestQueue: ITileRequestQueue;
      const ADownloaderList: ITileDownloaderList
    );
    destructor Destroy; override;
  end;

implementation

uses
  u_Synchronizer,
  i_TileDownloader,
  u_ListenerByEvent,
  u_ListenerTTLCheck,
  u_TileRequestQueueProcessorThread;

{ TTileRequestProcessorPool }

constructor TTileRequestProcessorPool.Create(
  const AGCList: INotifierTTLCheck;
  const AThreadConfig: IThreadConfig;
  const AAppClosingNotifier: INotifier;
  const ATileRequestQueue: ITileRequestQueue;
  const ADownloaderList: ITileDownloaderList
);
begin
  inherited Create;
  FGCList := AGCList;
  FThreadConfig := AThreadConfig;
  FAppClosingNotifier := AAppClosingNotifier;
  FTileRequestQueue := ATileRequestQueue;

  FThreadArrayCS := MakeSyncRW_Big(Self);

  FDownloaderList := ADownloaderList;

  FDownloadersListListener := TNotifyNoMmgEventListener.Create(Self.OnDownloadersListChange);
  FDownloaderList.ChangeNotifier.Add(FDownloadersListListener);

  FTTLListener := TListenerTTLCheck.Create(Self.OnTTLTrim, 60000, 1000);
  FGCList.Add(FTTLListener);

  OnDownloadersListChange;
end;

destructor TTileRequestProcessorPool.Destroy;
begin
  OnTTLTrim(nil);
  FDownloaderList.ChangeNotifier.Remove(FDownloadersListListener);
  FGCList.Remove(FTTLListener);
  FTTLListener := nil;
  FGCList := nil;
  FDownloadersListListener := nil;
  FDownloaderList := nil;

  FThreadArrayCS := nil;
  inherited;
end;

procedure TTileRequestProcessorPool.InitThreadsIfNeed;
var
  VThreadArray: TArrayOfThread;
  VDownloaderList: ITileDownloaderListStatic;
  i: Integer;
  VTileDownloaderSync: ITileDownloader;
begin
  FTTLListener.UpdateUseTime;

  FThreadArrayCS.BeginRead;
  try
    VThreadArray := FThreadArray;
  finally
    FThreadArrayCS.EndRead;
  end;

  if VThreadArray = nil then begin
    FThreadArrayCS.BeginWrite;
    try
      VThreadArray := FThreadArray;

      if VThreadArray = nil then begin
        VDownloaderList := FDownloaderList.GetStatic;
        if VDownloaderList <> nil then begin
          SetLength(VThreadArray, VDownloaderList.Count);
          for i := 0 to VDownloaderList.Count - 1 do begin
            VTileDownloaderSync := VDownloaderList.Item[i];
            if VTileDownloaderSync <> nil then begin
              VThreadArray[i] :=
                TTileRequestQueueProcessorThread.Create(
                  FThreadConfig,
                  FAppClosingNotifier,
                  FTileRequestQueue,
                  VTileDownloaderSync
                );
              VThreadArray[i].Start;
            end else begin
              VThreadArray[i] := nil;
            end;
          end;

          FThreadArray := VThreadArray;
        end;
      end;
    finally
      FThreadArrayCS.EndWrite;
    end;
  end;
end;

procedure TTileRequestProcessorPool.OnDownloadersListChange;
begin
  OnTTLTrim(nil);
end;

procedure TTileRequestProcessorPool.OnTTLTrim(Sender: TObject);
var
  VThreadArray: TArrayOfThread;
  i: Integer;
  VItem: IThread;
begin
  FThreadArrayCS.BeginWrite;
  try
    VThreadArray := FThreadArray;
    FThreadArray := nil;
  finally
    FThreadArrayCS.EndWrite;
  end;

  if VThreadArray <> nil then begin
    for i := 0 to Length(VThreadArray) - 1 do begin
      VItem := VThreadArray[i];
      VThreadArray[i] := nil;
      if VItem <> nil then begin
        VItem.Terminate;
        VItem := nil;
      end;
    end;
    VThreadArray := nil;
  end;
end;

end.
