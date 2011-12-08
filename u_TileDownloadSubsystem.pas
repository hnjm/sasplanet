unit u_TileDownloadSubsystem;

interface

uses
  Types,
  i_JclNotify,
  i_OperationNotifier,
  i_CoordConverterFactory,
  i_CoordConverter,
  i_TTLCheckNotifier,
  i_ConfigDataProvider,
  i_ContentTypeManager,
  i_ContentTypeSubst,
  i_TilePostDownloadCropConfig,
  i_SimpleTileStorageConfig,
  i_DownloadResultFactory,
  i_LanguageManager,
  i_GlobalDownloadConfig,
  i_TileRequest,
  i_TileDownloaderState,
  i_TileDownloaderConfig,
  i_TileDownloadRequestBuilderConfig,
  i_TileDownloadRequestBuilder,
  i_TileDownloadRequestBuilderFactory,
  i_TileDownloader,
  i_TileDownloadResultSaver,
  i_MapAbilitiesConfig,
  i_MapVersionConfig,
  i_InvisibleBrowser,
  i_TileDownloadSubsystem,
  u_TileStorageAbstract;

type
  TTileDownloadSubsystem = class(TInterfacedObject, ITileDownloadSubsystem)
  private
    FTileDownloaderConfig: ITileDownloaderConfig;
    FTileDownloadRequestBuilderConfig: ITileDownloadRequestBuilderConfig;
    FCoordConverter : ICoordConverter;
    FVersionConfig: IMapVersionConfig;

    FZmpDownloadEnabled: Boolean;
    FState: ITileDownloaderStateChangeble;
    FDownloadResultSaver: ITileDownloadResultSaver;
    FTileDownloader: ITileDownloader;
    FTileDownloadRequestBuilder: ITileDownloadRequestBuilder;
    FTileDownloadRequestBuilderFactory: ITileDownloadRequestBuilderFactory;
  protected
    function GetRequest(
      ACancelNotifier: IOperationNotifier;
      AOperationID: Integer;
      AXY: TPoint;
      Azoom: byte;
      ACheckTileSize: Boolean
    ): ITileRequest;
    function GetLink(AXY: TPoint; Azoom: byte): string;
    procedure Download(
      ATileRequest: ITileRequest
    );

    function GetState: ITileDownloaderStateChangeble;
  public
    constructor Create(
      AGCList: ITTLCheckNotifier;
      AAppClosingNotifier: IJclNotifier;
      ACoordConverter : ICoordConverter;
      ACoordConverterFactory: ICoordConverterFactory;
      ALanguageManager: ILanguageManager;
      AGlobalDownloadConfig: IGlobalDownloadConfig;
      AInvisibleBrowser: IInvisibleBrowser;
      ADownloadResultFactory: IDownloadResultFactory;
      AZmpTileDownloaderConfig: ITileDownloaderConfigStatic;
      AVersionConfig: IMapVersionConfig;
      ATileDownloaderConfig: ITileDownloaderConfig;
      ATileDownloadRequestBuilderConfig: ITileDownloadRequestBuilderConfig;
      AContentTypeManager: IContentTypeManager;
      AContentTypeSubst: IContentTypeSubst;
      ATilePostDownloadCropConfig: ITilePostDownloadCropConfigStatic;
      AMapAbilitiesConfig: IMapAbilitiesConfig;
      AZmpData: IConfigDataProvider;
      AStorageConfig: ISimpleTileStorageConfig;
      AStorage: TTileStorageAbstract
    );
  end;

implementation

uses
  Classes,
  i_TileDownloadRequest,
  i_TileDownloaderList,
  i_DownloadChecker,
  u_TileRequest,
  u_TileDownloaderList,
  u_AntiBanStuped,
  u_DownloadCheckerStuped,
  u_TileDownloadSubsystemState,
  u_TileDownloadResultSaverStuped,
  u_TileDownloaderWithQueue,
  u_TileDownloadRequestBuilderFactoryPascalScript;

{ TTileDownloadSubsystem }

constructor TTileDownloadSubsystem.Create(
  AGCList: ITTLCheckNotifier;
  AAppClosingNotifier: IJclNotifier;
  ACoordConverter : ICoordConverter;
  ACoordConverterFactory: ICoordConverterFactory;
  ALanguageManager: ILanguageManager;
  AGlobalDownloadConfig: IGlobalDownloadConfig;
  AInvisibleBrowser: IInvisibleBrowser;
  ADownloadResultFactory: IDownloadResultFactory;
  AZmpTileDownloaderConfig: ITileDownloaderConfigStatic;
  AVersionConfig: IMapVersionConfig;
  ATileDownloaderConfig: ITileDownloaderConfig;
  ATileDownloadRequestBuilderConfig: ITileDownloadRequestBuilderConfig;
  AContentTypeManager: IContentTypeManager;
  AContentTypeSubst: IContentTypeSubst;
  ATilePostDownloadCropConfig: ITilePostDownloadCropConfigStatic;
  AMapAbilitiesConfig: IMapAbilitiesConfig;
  AZmpData: IConfigDataProvider;
  AStorageConfig: ISimpleTileStorageConfig;
  AStorage: TTileStorageAbstract
);
var
  VDownloaderList: ITileDownloaderList;
  VDownloadChecker: IDownloadChecker;
begin
  FCoordConverter := ACoordConverter;
  FVersionConfig := AVersionConfig;
  FTileDownloaderConfig := ATileDownloaderConfig;
  FTileDownloadRequestBuilderConfig := ATileDownloadRequestBuilderConfig;

  FZmpDownloadEnabled := AZmpTileDownloaderConfig.Enabled;

  if FZmpDownloadEnabled then begin
    VDownloadChecker := TDownloadCheckerStuped.Create(
      TAntiBanStuped.Create(AInvisibleBrowser, AZmpData),
      FTileDownloaderConfig,
      AStorage
    );
    FTileDownloadRequestBuilderFactory :=
      TTileDownloadRequestBuilderFactoryPascalScript.Create(
        AZmpData,
        FTileDownloadRequestBuilderConfig,
        FTileDownloaderConfig,
        VDownloadChecker,
        ALanguageManager
      );
    FDownloadResultSaver :=
      TTileDownloadResultSaverStuped.Create(
        AGlobalDownloadConfig,
        AContentTypeManager,
        AContentTypeSubst,
        ATilePostDownloadCropConfig,
        AStorageConfig,
        AStorage
      );

    FState :=
      TTileDownloadSubsystemState.Create(
        FZmpDownloadEnabled,
        FTileDownloadRequestBuilderFactory.State,
        FDownloadResultSaver.State,
        AMapAbilitiesConfig
      );

    VDownloaderList :=
      TTileDownloaderList.Create(
        AGCList,
        AAppClosingNotifier,
        ADownloadResultFactory,
        FState,
        FTileDownloaderConfig,
        FDownloadResultSaver,
        FTileDownloadRequestBuilderFactory
      );
    FTileDownloader := TTileDownloaderWithQueue.Create(
      VDownloaderList,
      AGCList,
      tpLower,
      AAppClosingNotifier,
      256
    );
  end else begin
    FState :=
      TTileDownloadSubsystemState.Create(
        FZmpDownloadEnabled,
        nil,
        nil,
        nil
      );

  end;

end;

procedure TTileDownloadSubsystem.Download(ATileRequest: ITileRequest);
begin
  if FZmpDownloadEnabled then begin
    if FState.GetStatic.Enabled then begin
      FTileDownloader.Download(ATileRequest);
    end;
  end;
end;

function TTileDownloadSubsystem.GetLink(AXY: TPoint; Azoom: byte): string;
var
  VBuilder: ITileDownloadRequestBuilder;
  VRequest: ITileRequest;
  VDownloadRequest: ITileDownloadRequest;
begin
  Result := '';
  if FZmpDownloadEnabled then begin
    if FTileDownloadRequestBuilderFactory.State.GetStatic.Enabled then begin
      VBuilder := FTileDownloadRequestBuilder;
      if VBuilder = nil then begin
        FTileDownloadRequestBuilder := FTileDownloadRequestBuilderFactory.BuildRequestBuilder;
        VBuilder := FTileDownloadRequestBuilder;
      end;
      if FTileDownloadRequestBuilderFactory.State.GetStatic.Enabled then begin
        VRequest :=
          GetRequest(
            nil,
            0,
            AXY,
            Azoom,
            False
          );
        VDownloadRequest:= nil;
        if VRequest <> nil then begin
          VDownloadRequest := FTileDownloadRequestBuilder.BuildRequest(VRequest, nil);
        end;
        if VDownloadRequest <> nil then begin
          Result := VDownloadRequest.Url;
        end;
      end;
    end;
  end;
end;

function TTileDownloadSubsystem.GetRequest(ACancelNotifier: IOperationNotifier;
  AOperationID: Integer; AXY: TPoint; Azoom: byte;
  ACheckTileSize: Boolean): ITileRequest;
begin
  Result := nil;
  if FZmpDownloadEnabled then begin
    if FCoordConverter.CheckTilePosStrict(AXY, Azoom, False) then begin
      if ACheckTileSize then begin
        Result :=
          TTileRequestWithSizeCheck.Create(
            AXY,
            Azoom,
            FVersionConfig.GetStatic,
            ACancelNotifier,
            AOperationID
          );
      end else begin
        Result :=
          TTileRequest.Create(
            AXY,
            Azoom,
            FVersionConfig.GetStatic,
            ACancelNotifier,
            AOperationID
          );
      end;
    end;
  end;
end;

function TTileDownloadSubsystem.GetState: ITileDownloaderStateChangeble;
begin
  Result := FState;
end;

end.
