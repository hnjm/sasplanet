unit u_TileDownloaderList;

interface

uses
  Windows,
  i_JclNotify,
  i_TileDownloaderConfig,
  i_TileDownloader,
  i_DownloadResultFactory,
  i_TileDownloadResultSaver,
  i_TileDownloaderState,
  i_TTLCheckNotifier,
  i_TileDownloadRequestBuilderFactory,
  i_TileDownloaderList;

type
  TTileDownloaderList = class(TInterfacedObject, ITileDownloaderList)
  private
    FGCList: ITTLCheckNotifier;
    FAppClosingNotifier: IJclNotifier;
    FResultFactory: IDownloadResultFactory;
    FDownloadSystemState: ITileDownloaderStateChangeble;
    FTileDownloaderConfig: ITileDownloaderConfig;
    FResultSaver: ITileDownloadResultSaver;
    FRequestBuilderFactory: ITileDownloadRequestBuilderFactory;

    FChangeCounter: Integer;
    FChangeNotifier: IJclNotifier;
    FStatic: ITileDownloaderListStatic;
    FConfigListener: IJclListener;

    procedure OnConfigChange;
    function CreateDownloader: ITileDownloader;
  protected
    function GetStatic: ITileDownloaderListStatic;
    function GetChangeNotifier: IJclNotifier;
  public
    constructor Create(
      AGCList: ITTLCheckNotifier;
      AAppClosingNotifier: IJclNotifier;
      AResultFactory: IDownloadResultFactory;
      ADownloadSystemState: ITileDownloaderStateChangeble;
      ATileDownloaderConfig: ITileDownloaderConfig;
      AResultSaver: ITileDownloadResultSaver;
      ARequestBuilderFactory: ITileDownloadRequestBuilderFactory
    );
    destructor Destroy; override;
  end;

implementation

uses
  i_Downloader,
  u_JclNotify,
  u_NotifyEventListener,
  u_LastResponseInfo,
  u_TileDownloadRequestBuilderLazy,
  u_DownloaderHttpWithTTL,
  u_TileDownloaderSimple,
  u_TileDownloaderListStatic;

{ TTileDownloaderList }

constructor TTileDownloaderList.Create(
  AGCList: ITTLCheckNotifier;
  AAppClosingNotifier: IJclNotifier;
  AResultFactory: IDownloadResultFactory;
  ADownloadSystemState: ITileDownloaderStateChangeble;
  ATileDownloaderConfig: ITileDownloaderConfig;
  AResultSaver: ITileDownloadResultSaver;
  ARequestBuilderFactory: ITileDownloadRequestBuilderFactory
);
begin
  FGCList := AGCList;
  FAppClosingNotifier := AAppClosingNotifier;
  FResultFactory := AResultFactory;
  FDownloadSystemState := ADownloadSystemState;
  FTileDownloaderConfig := ATileDownloaderConfig;
  FResultSaver := AResultSaver;
  FRequestBuilderFactory := ARequestBuilderFactory;

  FChangeNotifier := TJclBaseNotifier.Create;

  FConfigListener := TNotifyNoMmgEventListener.Create(Self.OnConfigChange);

  FTileDownloaderConfig.ChangeNotifier.Add(FConfigListener);
  FDownloadSystemState.ChangeNotifier.Add(FConfigListener);

  OnConfigChange;
end;

destructor TTileDownloaderList.Destroy;
begin
  FTileDownloaderConfig.ChangeNotifier.Remove(FConfigListener);
  FDownloadSystemState.ChangeNotifier.Remove(FConfigListener);

  FConfigListener := nil;
  FTileDownloaderConfig := nil;
  FRequestBuilderFactory := nil;
  FDownloadSystemState := nil;

  inherited;
end;

function TTileDownloaderList.CreateDownloader: ITileDownloader;
var
  VDownloader: IDownloader;
begin
  VDownloader :=
    TDownloaderHttpWithTTL.Create(
      FGCList,
      FResultFactory
    );
  Result :=
    TTileDownloaderSimple.Create(
      FAppClosingNotifier,
      TTileDownloadRequestBuilderLazy.Create(
        VDownloader,
        FRequestBuilderFactory
      ),
      FTileDownloaderConfig,
      VDownloader,
      FResultSaver,
      TLastResponseInfo.Create
    );
end;

function TTileDownloaderList.GetChangeNotifier: IJclNotifier;
begin
  Result := FChangeNotifier;
end;

function TTileDownloaderList.GetStatic: ITileDownloaderListStatic;
begin
  Result := FStatic;
end;

procedure TTileDownloaderList.OnConfigChange;
var
  VStatic: ITileDownloaderListStatic;
  VList: array of ITileDownloader;
  VCount: Integer;
  VOldCount: Integer;
  VCountForCopy: Integer;
  i: Integer;
  VState: ITileDownloaderStateStatic;
  VCounter: Integer;
begin
  VCounter := InterlockedIncrement(FChangeCounter);
  VStatic := FStatic;
  VCount := FTileDownloaderConfig.MaxConnectToServerCount;
  VState := FDownloadSystemState.GetStatic;
  if not VState.Enabled then begin
    VCount := 0;
  end;

  VOldCount := 0;
  if VStatic <> nil then begin
    VOldCount := VStatic.Count;
  end;

  if VOldCount <> VCount then begin
    SetLength(VList, VCount);
    if InterlockedCompareExchange(FChangeCounter, VCounter, VCounter) <> VCounter then begin
      Exit;
    end;
    VCountForCopy := VOldCount;
    if VCount < VCountForCopy then begin
      VCountForCopy := VCount;
    end;
    for i := 0 to VCountForCopy - 1 do begin
      VList[i] := VStatic.Item[i];
    end;
    for i := VCountForCopy to VCount - 1 do begin
      VList[i] := CreateDownloader;
      if InterlockedCompareExchange(FChangeCounter, VCounter, VCounter) <> VCounter then begin
        Exit;
      end;
    end;
    FStatic := TTileDownloaderListStatic.Create(VList);
    FChangeNotifier.Notify(nil);
  end else if FStatic = nil then begin
    SetLength(VList, 0);
    if InterlockedCompareExchange(FChangeCounter, VCounter, VCounter) <> VCounter then begin
      Exit;
    end;
    FStatic := TTileDownloaderListStatic.Create(VList);
  end;
end;

end.
