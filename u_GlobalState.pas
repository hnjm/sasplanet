{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2012, SAS.Planet development team.                      *}
{* This program is free software: you can redistribute it and/or modify       *}
{* it under the terms of the GNU General Public License as published by       *}
{* the Free Software Foundation, either version 3 of the License, or          *}
{* (at your option) any later version.                                        *}
{*                                                                            *}
{* This program is distributed in the hope that it will be useful,            *}
{* but WITHOUT ANY WARRANTY; without even the implied warranty of             *}
{* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *}
{* GNU General Public License for more details.                               *}
{*                                                                            *}
{* You should have received a copy of the GNU General Public License          *}
{* along with this program.  If not, see <http://www.gnu.org/licenses/>.      *}
{*                                                                            *}
{* http://sasgis.ru                                                           *}
{* az@sasgis.ru                                                               *}
{******************************************************************************}

unit u_GlobalState;

interface

uses
  {$IFDEF SasDebugWithJcl}
  Windows,
  JclDebug,
  {$ENDIF SasDebugWithJcl}
  ExtCtrls,
  Classes,
  IniFiles,
  SysUtils,
  i_Notifier,
  i_NotifierOperation,
  i_GPSPositionFactory,
  i_LanguageManager,
  i_InetConfig,
  i_BackgroundTask,
  i_ConfigDataWriteProvider,
  i_ConfigDataProvider,
  i_LastSearchResultConfig,
  i_TileFileNameGeneratorsList,
  i_TileFileNameParsersList,
  i_ContentTypeManager,
  i_VectorDataLoader,
  i_CoordConverterFactory,
  i_CoordConverterList,
  i_ProjConverter,
  i_BatteryStatus,
  i_LocalCoordConverterFactorySimpe,
  i_ProxySettings,
  i_GPSModule,
  i_GSMGeoCodeConfig,
  i_MainFormConfig,
  i_WindowPositionConfig,
  i_GlobalAppConfig,
  i_BitmapPostProcessingConfig,
  i_ValueToStringConverter,
  u_GarbageCollectorThread,
  i_LastSelectionInfo,
  i_DownloadInfoSimple,
  i_ImageResamplerConfig,
  i_GeoCoderList,
  i_MainMemCacheConfig,
  i_MarkPicture,
  i_InternalPerformanceCounter,
  u_LastSelectionInfo,
  i_MarksSystem,
  u_MapTypesMainList,
  i_ThreadConfig,
  i_ZmpConfig,
  i_ZmpInfoSet,
  i_GPSConfig,
  i_PathConfig,
  i_MapCalibration,
  i_MarkCategoryFactoryConfig,
  i_GlobalViewMainConfig,
  i_GlobalDownloadConfig,
  i_StartUpLogoConfig,
  i_ImportFile,
  i_PathDetalizeProviderList,
  i_GPSRecorder,
  i_SatellitesInViewMapDraw,
  i_SensorList,
  i_TerrainProviderList,
  i_TerrainConfig,
  i_VectorItmesFactory,
  i_InvisibleBrowser,
  i_InternalBrowser,
  i_DebugInfoWindow,
  i_GlobalInternetState,
  i_BitmapTileSaveLoadFactory,
  i_ArchiveReadWriteFactory,
  u_IeEmbeddedProtocolRegistration,
  u_GlobalCahceConfig;

type
  TGlobalState = class
  private
    FBaseConfigPath: IPathConfig;
    FBaseDataPath: IPathConfig;
    FBaseCahcePath: IPathConfig;
    FBaseApplicationPath: IPathConfig;
    FMapsPath: IPathConfig;
    FTrackPath: IPathConfig;
    FMarksDbPath: IPathConfig;
    FMarksIconsPath: IPathConfig;
    FMediaDataPath: IPathConfig;
    FTerrainDataPath: IPathConfig;
    FLastSelectionFileName: IPathConfig;

    FMainConfigProvider: IConfigDataWriteProvider;
    FZmpConfig: IZmpConfig;
    FZmpInfoSet: IZmpInfoSet;
    FResourceProvider: IConfigDataProvider;
    FGlobalAppConfig: IGlobalAppConfig;
    FStartUpLogoConfig: IStartUpLogoConfig;
    FTileNameGenerator: ITileFileNameGeneratorsList;
    FTileNameParser: ITileFileNameParsersList;
    FGCThread: TGarbageCollectorThread;
    FContentTypeManager: IContentTypeManager;
    FMapCalibrationList: IMapCalibrationList;
    FCacheConfig: TGlobalCahceConfig;
    FLanguageManager: ILanguageManager;
    FLastSelectionInfo: ILastSelectionInfo;
    FMarksDb: IMarksSystem;
    FCoordConverterFactory: ICoordConverterFactory;
    FCoordConverterList: ICoordConverterList;
    FProjConverterFactory: IProjConverterFactory;
    FProjectionFactory: IProjectionInfoFactory;
    FLocalConverterFactory: ILocalCoordConverterFactorySimpe;
    FMainMapsList: TMapTypesMainList;
    FInetConfig: IInetConfig;
    FGPSConfig: IGPSConfig;
    FGSMpar: IGSMGeoCodeConfig;
    FGPSPositionFactory: IGPSPositionFactory;
    FMainFormConfig: IMainFormConfig;
    FBitmapPostProcessingConfig: IBitmapPostProcessingConfig;
    FValueToStringConverterConfig: IValueToStringConverterConfig;
    FDownloadInfo: IDownloadInfoSimple;
    FDownloadConfig: IGlobalDownloadConfig;
    FDownloaderThreadConfig: IThreadConfig;
    FGlobalInternetState: IGlobalInternetState;
    FImageResamplerConfig: IImageResamplerConfig;
    FTileMatrixDraftResamplerConfig: IImageResamplerConfig;
    FTileLoadResamplerConfig: IImageResamplerConfig;
    FTileGetPrevResamplerConfig: IImageResamplerConfig;
    FTileReprojectResamplerConfig: IImageResamplerConfig;
    FTileDownloadResamplerConfig: IImageResamplerConfig;
    FGeoCoderList: IGeoCoderList;
    FMainMemCacheConfig: IMainMemCacheConfig;
    FMarkPictureList: IMarkPictureList;
    FMarksCategoryFactoryConfig: IMarkCategoryFactoryConfig;
    FGpsSystem: IGPSModule;
    FImportFileByExt: IImportFile;
    FViewConfig: IGlobalViewMainConfig;
    FGPSRecorder: IGPSRecorder;
    FSkyMapDraw: ISatellitesInViewMapDraw;
    FGUISyncronizedTimer: TTimer;
    FGUISyncronizedTimerNotifierInternal: INotifierInternal;
    FGUISyncronizedTimerNotifier: INotifier;
    FSensorList: ISensorList;
    FPerfCounterList: IInternalPerformanceCounterList;
    FProtocol: TIeEmbeddedProtocolRegistration;
    FPathDetalizeList: IPathDetalizeProviderList;
    FInvisibleBrowser: IInvisibleBrowser;
    FInternalBrowserConfig: IWindowPositionConfig;
    FInternalBrowser: IInternalBrowser;
    FDebugInfoWindow: IDebugInfoWindow;
    FAppStartedNotifier: INotifierOneOperation;
    FAppStartedNotifierInternal: INotifierOneOperationInternal;
    FAppClosingNotifier: INotifierOneOperation;
    FAppClosingNotifierInternal: INotifierOneOperationInternal;
    FVectorItmesFactory: IVectorItmesFactory;
    FBatteryStatus: IBatteryStatus;
    FTerrainProviderList: ITerrainProviderList;
    FTerrainConfig: ITerrainConfig;
    FBitmapTileSaveLoadFactory: IBitmapTileSaveLoadFactory;
    FArchiveReadWriteFactory: IArchiveReadWriteFactory;
    FLastSelectionSaver: IBackgroundTask;
    FLastSearchResultConfig: ILastSearchResultConfig;
    procedure InitProtocol;

    procedure OnGUISyncronizedTimer(Sender: TObject);
    {$IFDEF SasDebugWithJcl}
    procedure DoException(
      Sender: TObject;
      E: Exception
    );
    {$ENDIF SasDebugWithJcl}
  public
    property MapType: TMapTypesMainList read FMainMapsList;
    property CacheConfig: TGlobalCahceConfig read FCacheConfig;
    property GCThread: TGarbageCollectorThread read FGCThread;
    property MarksDb: IMarksSystem read FMarksDb;
    property GpsSystem: IGPSModule read FGpsSystem;

    // ������ ����������� ���� ������ � �������
    property TileNameGenerator: ITileFileNameGeneratorsList read FTileNameGenerator;
    property TileNameParser: ITileFileNameParsersList read FTileNameParser;
    property ContentTypeManager: IContentTypeManager read FContentTypeManager;
    property CoordConverterFactory: ICoordConverterFactory read FCoordConverterFactory;
    property CoordConverterList: ICoordConverterList read FCoordConverterList;
    property ProjectionFactory: IProjectionInfoFactory read FProjectionFactory;
    property LocalConverterFactory: ILocalCoordConverterFactorySimpe read FLocalConverterFactory;
    property MapCalibrationList: IMapCalibrationList read FMapCalibrationList;
    property AppStartedNotifier: INotifierOneOperation read FAppStartedNotifier;
    property AppClosingNotifier: INotifierOneOperation read FAppClosingNotifier;
    property MediaDataPath: IPathConfig read FMediaDataPath;
    property TerrainDataPath: IPathConfig read FTerrainDataPath;

    property MainConfigProvider: IConfigDataWriteProvider read FMainConfigProvider;
    property ResourceProvider: IConfigDataProvider read FResourceProvider;
    property DownloadInfo: IDownloadInfoSimple read FDownloadInfo;
    property GlobalInternetState: IGlobalInternetState read FGlobalInternetState;
    property ImportFileByExt: IImportFile read FImportFileByExt;
    property SkyMapDraw: ISatellitesInViewMapDraw read FSkyMapDraw;
    property GUISyncronizedTimerNotifier: INotifier read FGUISyncronizedTimerNotifier;
    property PerfCounterList: IInternalPerformanceCounterList read FPerfCounterList;

    property GlobalAppConfig: IGlobalAppConfig read FGlobalAppConfig;
    property LastSelectionInfo: ILastSelectionInfo read FLastSelectionInfo;
    property LanguageManager: ILanguageManager read FLanguageManager;
    property GSMpar: IGSMGeoCodeConfig read FGSMpar;
    property InetConfig: IInetConfig read FInetConfig;
    property MainFormConfig: IMainFormConfig read FMainFormConfig;
    property BitmapPostProcessingConfig: IBitmapPostProcessingConfig read FBitmapPostProcessingConfig;
    property ValueToStringConverterConfig: IValueToStringConverterConfig read FValueToStringConverterConfig;
    property ImageResamplerConfig: IImageResamplerConfig read FImageResamplerConfig;
    property TileMatrixDraftResamplerConfig: IImageResamplerConfig read FTileMatrixDraftResamplerConfig;
    property MainMemCacheConfig: IMainMemCacheConfig read FMainMemCacheConfig;
    property GPSConfig: IGPSConfig read FGPSConfig;
    property MarksCategoryFactoryConfig: IMarkCategoryFactoryConfig read FMarksCategoryFactoryConfig;
    property ViewConfig: IGlobalViewMainConfig read FViewConfig;
    property GPSRecorder: IGPSRecorder read FGPSRecorder;
    property PathDetalizeList: IPathDetalizeProviderList read FPathDetalizeList;
    property SensorList: ISensorList read FSensorList;
    property DownloadConfig: IGlobalDownloadConfig read FDownloadConfig;
    property DownloaderThreadConfig: IThreadConfig read FDownloaderThreadConfig;
    property StartUpLogoConfig: IStartUpLogoConfig read FStartUpLogoConfig;
    property InternalBrowser: IInternalBrowser read FInternalBrowser;
    property DebugInfoWindow: IDebugInfoWindow read FDebugInfoWindow;
    property VectorItmesFactory: IVectorItmesFactory read FVectorItmesFactory;
    property BitmapTileSaveLoadFactory: IBitmapTileSaveLoadFactory read FBitmapTileSaveLoadFactory;
    property ArchiveReadWriteFactory: IArchiveReadWriteFactory read FArchiveReadWriteFactory;
    property TerrainProviderList: ITerrainProviderList read FTerrainProviderList;
    property TerrainConfig: ITerrainConfig read FTerrainConfig;

    constructor Create;
    destructor Destroy; override;
    procedure LoadConfig;
    procedure SaveMainParams;
    procedure StartThreads;
    procedure SendTerminateToThreads;

    procedure StartExceptionTracking;
    procedure StopExceptionTracking;
  end;

var
  GState: TGlobalState;

implementation

uses
  {$IFDEF SasDebugWithJcl}
  Forms,
  {$ENDIF}
  u_Notifier,
  u_NotifierOperation,
  c_InternalBrowser,
  u_SASMainConfigProvider,
  u_ConfigDataProviderByIniFile,
  u_ConfigDataWriteProviderByIniFile,
  u_ConfigDataProviderByPathConfig,
  i_InternalDomainInfoProvider,
  i_ImageResamplerFactory,
  i_TextByVectorItem,
  u_TextByVectorItemHTMLByDescription,
  u_TextByVectorItemMarkInfo,
  i_NotifierTTLCheck,
  u_NotifierTTLCheck,
  i_FileNameIterator,
  u_ContentTypeManagerSimple,
  u_MarksSystem,
  u_MapCalibrationListBasic,
  u_XmlInfoSimpleParser,
  u_KmlInfoSimpleParser,
  u_KmzInfoSimpleParser,
  u_CoordConverterFactorySimple,
  u_CoordConverterListStaticSimple,
  u_LanguageManager,
  u_DownloadInfoSimple,
  u_StartUpLogoConfig,
  u_InetConfig,
  u_Datum,
  u_PLTSimpleParser,
  u_GSMGeoCodeConfig,
  u_GPSConfig,
  u_MarkCategoryFactoryConfig,
  u_GeoCoderListSimple,
  u_BitmapPostProcessingConfig,
  u_ValueToStringConverterConfig,
  u_GlobalAppConfig,
  u_MainMemCacheConfig,
  u_MarkPictureListSimple,
  u_ImageResamplerConfig,
  u_ImageResamplerFactoryListStaticSimple,
  u_ImportByFileExt,
  u_GlobalViewMainConfig,
  u_GlobalDownloadConfig,
  u_GPSRecorder,
  u_SatellitesInViewMapDrawSimple,
  u_GPSModuleFactoryByVSAGPS,
  u_GPSPositionFactory,
  u_LocalCoordConverterFactorySimpe,
  u_TerrainProviderList,
  u_TerrainConfig,
  u_MainFormConfig,
  u_LastSearchResultConfig,
  u_ProjConverterFactory,
  u_PathConfig,
  u_ThreadConfig,
  u_BatteryStatus,
  u_ZmpConfig,
  u_ZmpInfoSet,
  u_ZmpFileNamesIteratorFactory,
  u_SensorListStuped,
  u_WindowPositionConfig,
  u_HtmlToHintTextConverterStuped,
  u_InvisibleBrowserByFormSynchronize,
  u_InternalBrowserByForm,
  u_DebugInfoWindow,
  u_InternalPerformanceCounterList,
  u_IeEmbeddedProtocolFactory,
  u_VectorItmesFactorySimple,
  u_VectorDataFactorySimple,
  u_DownloadResultFactory,
  u_PathDetalizeProviderListSimple,
  u_InternalDomainInfoProviderList,
  u_InternalDomainInfoProviderByMapTypeList,
  u_InternalDomainInfoProviderByDataProvider,
  u_InternalDomainInfoProviderByMarksSystem,
  u_InternalDomainInfoProviderByMapData,
  u_InternalDomainInfoProviderByLastSearchResults,
  u_InternalDomainInfoProviderByTileStorageOptions,
  u_GpsSystem,
  u_LastSelectionInfoSaver,
  u_GlobalInternetState,
  u_BitmapTileSaveLoadFactory,
  u_ArchiveReadWriteFactory,
  u_TileFileNameParsersSimpleList,
  u_TileFileNameGeneratorsSimpleList;

{ TGlobalState }

constructor TGlobalState.Create;
var
  VList: INotifierTTLCheckInternal;
  VViewCnonfig: IConfigDataProvider;
  VMarksKmlLoadCounterList: IInternalPerformanceCounterList;
  VXmlLoader: IVectorDataLoader;
  VXmlZLoader: IVectorDataLoader;
  VKmlLoader: IVectorDataLoader;
  VKmzLoader: IVectorDataLoader;
  VFilesIteratorFactory: IFileNameIteratorFactory;
  VFilesIterator: IFileNameIterator;
  VCoordConverterFactorySimple: TCoordConverterFactorySimple;
  VProgramPath: string;
  VSleepByClass: IConfigDataProvider;
  VResamplerFactoryList: IImageResamplerFactoryList;
begin
  inherited Create;
  if ModuleIsLib then begin
    // run as DLL or PACKAGE
    VProgramPath := GetModuleName(HInstance);
    VProgramPath := ExtractFilePath(VProgramPath);
  end else begin
    // run as EXE
    VProgramPath := ExtractFilePath(ParamStr(0));
  end;
  FBaseApplicationPath := TPathConfig.Create('', VProgramPath, nil);
  FBaseConfigPath := TPathConfig.Create('', VProgramPath, nil);
  FBaseDataPath := TPathConfig.Create('', VProgramPath, nil);
  FBaseCahcePath := TPathConfig.Create('PrimaryPath', VProgramPath, nil);
  FMapsPath := TPathConfig.Create('PrimaryPath', '.\Maps', FBaseConfigPath);
  FTrackPath := TPathConfig.Create('PrimaryPath', '.\TrackLog', FBaseDataPath);
  FMarksDbPath := TPathConfig.Create('PrimaryPath', '.', FBaseDataPath);
  FMarksIconsPath := TPathConfig.Create('', '.\MarksIcons', FBaseApplicationPath);
  FMediaDataPath := TPathConfig.Create('PrimaryPath', '.\MediaData', FBaseDataPath);
  FTerrainDataPath := TPathConfig.Create('PrimaryPath', '.\TerrainData', FBaseDataPath);
  FLastSelectionFileName := TPathConfig.Create('FileName', '.\LastSelection.hlg', FBaseDataPath);

  FBitmapTileSaveLoadFactory := TBitmapTileSaveLoadFactory.Create;
  FArchiveReadWriteFactory := TArchiveReadWriteFactory.Create;

  FAppStartedNotifierInternal := TNotifierOneOperation.Create(TNotifierBase.Create);
  FAppStartedNotifier := FAppStartedNotifierInternal;
  FAppClosingNotifierInternal := TNotifierOneOperation.Create(TNotifierBase.Create);
  FAppClosingNotifier := FAppClosingNotifierInternal;
  FMainConfigProvider :=
    TSASMainConfigProvider.Create(
      FBaseConfigPath.FullPath,
      ExtractFileName(ParamStr(0)),
      HInstance
    );

  // read directories
  FMapsPath.ReadConfig(FMainConfigProvider.GetSubItem('PATHtoMAPS'));
  FTrackPath.ReadConfig(FMainConfigProvider.GetSubItem('PATHtoTRACKS'));
  FMarksDbPath.ReadConfig(FMainConfigProvider.GetSubItem('PATHtoMARKS'));
  FMediaDataPath.ReadConfig(FMainConfigProvider.GetSubItem('PATHtoMediaData'));
  FTerrainDataPath.ReadConfig(FMainConfigProvider.GetSubItem('PATHtoTerrainData'));
  FLastSelectionFileName.ReadConfig(FMainConfigProvider.GetSubItem('LastSelection'));

  VSleepByClass := FMainConfigProvider.GetSubItem('SleepByClass');

  FResourceProvider := FMainConfigProvider.GetSubItem('sas:\Resource');
  FVectorItmesFactory := TVectorItmesFactorySimple.Create;
  FGUISyncronizedTimer := TTimer.Create(nil);
  FGUISyncronizedTimer.Enabled := False;
  FGUISyncronizedTimer.Interval := VSleepByClass.ReadInteger('GUISyncronizedTimer', 200);
  FGUISyncronizedTimer.OnTimer := Self.OnGUISyncronizedTimer;

  FGUISyncronizedTimerNotifierInternal := TNotifierBase.Create;
  FGUISyncronizedTimerNotifier := FGUISyncronizedTimerNotifierInternal;

  FGlobalAppConfig := TGlobalAppConfig.Create;
  FGlobalInternetState := TGlobalInternetState.Create;

  FProjConverterFactory := TProjConverterFactory.Create;

  VCoordConverterFactorySimple := TCoordConverterFactorySimple.Create;
  FCoordConverterFactory := VCoordConverterFactorySimple;
  FProjectionFactory := VCoordConverterFactorySimple;
  FCoordConverterList := TCoordConverterListStaticSimple.Create(FCoordConverterFactory);
  FLocalConverterFactory := TLocalCoordConverterFactorySimpe.Create(FProjectionFactory);

  FCacheConfig := TGlobalCahceConfig.Create(FBaseCahcePath);
  FDownloadInfo := TDownloadInfoSimple.Create(nil);
  VViewCnonfig := FMainConfigProvider.GetSubItem('VIEW');
  FLanguageManager := TLanguageManager.Create;
  FLanguageManager.ReadConfig(VViewCnonfig);
  if VViewCnonfig <> nil then begin
    FGlobalAppConfig.ReadConfig(VViewCnonfig);
  end;

  if FGlobalAppConfig.IsShowDebugInfo then begin
    FPerfCounterList := TInternalPerformanceCounterList.Create('Main');
  end else begin
    FPerfCounterList := TInternalPerformanceCounterFake.Create;
  end;

  FTerrainProviderList := TTerrainProviderListSimple.Create(FProjConverterFactory, FTerrainDataPath, FCacheConfig);
  FTerrainConfig := TTerrainConfig.Create;

  FDownloadConfig := TGlobalDownloadConfig.Create;
  FDownloaderThreadConfig := TThreadConfig.Create(tpLower);
  VResamplerFactoryList := TImageResamplerFactoryListStaticSimple.Create;
  FImageResamplerConfig := TImageResamplerConfig.Create(VResamplerFactoryList);
  FTileMatrixDraftResamplerConfig := TImageResamplerConfig.Create(VResamplerFactoryList);

  FInetConfig := TInetConfig.Create;
  FGPSConfig := TGPSConfig.Create(FTrackPath);
  FGPSPositionFactory := TGPSPositionFactory.Create;
  FGPSRecorder :=
    TGPSRecorder.Create(
      FVectorItmesFactory,
      TDatum.Create(3395, 6378137, 6356752),
      FGPSPositionFactory
    );
  FGSMpar := TGSMGeoCodeConfig.Create;
  FMainMemCacheConfig := TMainMemCacheConfig.Create;
  FViewConfig := TGlobalViewMainConfig.Create;

  FTileNameGenerator := TTileFileNameGeneratorsSimpleList.Create;
  FTileNameParser := TTileFileNameParsersSimpleList.Create;

  FContentTypeManager :=
    TContentTypeManagerSimple.Create(
      FVectorItmesFactory,
      FBitmapTileSaveLoadFactory,
      FArchiveReadWriteFactory,
      FPerfCounterList
    );

  if (not ModuleIsLib) then begin
    FStartUpLogoConfig := TStartUpLogoConfig.Create(FContentTypeManager);
    FStartUpLogoConfig.ReadConfig(FMainConfigProvider.GetSubItem('StartUpLogo'));
  end;

  FInternalBrowserConfig := TWindowPositionConfig.Create;

  FMapCalibrationList := TMapCalibrationListBasic.Create;
  VMarksKmlLoadCounterList := FPerfCounterList.CreateAndAddNewSubList('Import');

  // xml loaders
  VXmlLoader :=
    TXmlInfoSimpleParser.Create(
      FVectorItmesFactory,
      nil,
      VMarksKmlLoadCounterList
    );
  VXmlZLoader :=
    TXmlInfoSimpleParser.Create(
      FVectorItmesFactory,
      FArchiveReadWriteFactory,
      VMarksKmlLoadCounterList
    );
  VKmlLoader :=
    TKmlInfoSimpleParser.Create(
      FVectorItmesFactory,
      VMarksKmlLoadCounterList
    );
  VKmzLoader :=
    TKmzInfoSimpleParser.Create(
      FVectorItmesFactory,
      FArchiveReadWriteFactory,
      VMarksKmlLoadCounterList
    );

  FImportFileByExt := TImportByFileExt.Create(
    TVectorDataFactorySimple.Create(THtmlToHintTextConverterStuped.Create),
    FVectorItmesFactory,
    VXmlLoader,
    TPLTSimpleParser.Create(
      FVectorItmesFactory,
      VMarksKmlLoadCounterList
    ),
    VKmlLoader,
    VKmzLoader,
    VXmlZLoader
  );
  VList := TNotifierTTLCheck.Create;
  FGCThread := TGarbageCollectorThread.Create(VList, VSleepByClass.ReadInteger(TGarbageCollectorThread.ClassName, 1000));
  FBitmapPostProcessingConfig := TBitmapPostProcessingConfig.Create;
  FValueToStringConverterConfig := TValueToStringConverterConfig.Create(FLanguageManager);
  FGpsSystem :=
    TGpsSystem.Create(
      FAppStartedNotifier,
      FAppClosingNotifier,
      TGPSModuleFactoryByVSAGPS.Create(FGPSPositionFactory),
      FGPSConfig,
      FGPSRecorder,
      GUISyncronizedTimerNotifier,
      FPerfCounterList
    );
  FLastSelectionInfo := TLastSelectionInfo.Create(FVectorItmesFactory);
  FGeoCoderList :=
    TGeoCoderListSimple.Create(
      FInetConfig,
      FGCThread.List,
      TDownloadResultFactory.Create,
      FValueToStringConverterConfig
    );
  FMarkPictureList := TMarkPictureListSimple.Create(FMarksIconsPath, FContentTypeManager);
  FMarksCategoryFactoryConfig := TMarkCategoryFactoryConfig.Create(FLanguageManager);
  FMarksDb :=
    TMarksSystem.Create(
      FLanguageManager,
      FMarksDbPath,
      FMarkPictureList,
      FVectorItmesFactory,
      FPerfCounterList.CreateAndAddNewSubList('MarksSystem'),
      THtmlToHintTextConverterStuped.Create,
      FMarksCategoryFactoryConfig
    );
  VFilesIteratorFactory := TZmpFileNamesIteratorFactory.Create;
  VFilesIterator := VFilesIteratorFactory.CreateIterator(FMapsPath.FullPath, '');
  FZmpConfig := TZmpConfig.Create;
  FZmpConfig.ReadConfig(FMainConfigProvider.GetSubItem('ZmpDefaultParams'));
  FZmpInfoSet :=
    TZmpInfoSet.Create(
      FZmpConfig,
      FCoordConverterFactory,
      FArchiveReadWriteFactory,
      FContentTypeManager,
      FLanguageManager,
      VFilesIterator
    );

  FTileLoadResamplerConfig := TImageResamplerConfig.Create(VResamplerFactoryList);
  FTileGetPrevResamplerConfig := TImageResamplerConfig.Create(VResamplerFactoryList);
  FTileReprojectResamplerConfig := TImageResamplerConfig.Create(VResamplerFactoryList);
  FTileDownloadResamplerConfig := TImageResamplerConfig.Create(VResamplerFactoryList);

  FMainMapsList :=
    TMapTypesMainList.Create(
      FZmpInfoSet,
      FTileLoadResamplerConfig,
      FTileGetPrevResamplerConfig,
      FTileReprojectResamplerConfig,
      FTileDownloadResamplerConfig,
      FPerfCounterList.CreateAndAddNewSubList('MapType')
    );
  FSkyMapDraw := TSatellitesInViewMapDrawSimple.Create;
  FPathDetalizeList :=
    TPathDetalizeProviderListSimple.Create(
      FLanguageManager,
      FInetConfig,
      FGCThread.List,
      TDownloadResultFactory.Create,
      TVectorDataFactorySimple.Create(THtmlToHintTextConverterStuped.Create),
      FVectorItmesFactory,
      VKmlLoader
    );
  FLastSearchResultConfig := TLastSearchResultConfig.Create;

  InitProtocol;

  FInvisibleBrowser :=
    TInvisibleBrowserByFormSynchronize.Create(
      FLanguageManager,
      FInetConfig.ProxyConfig
    );
  FInternalBrowser :=
    TInternalBrowserByForm.Create(
      FLanguageManager,
      FInternalBrowserConfig,
      FInetConfig.ProxyConfig,
      FContentTypeManager
    );
  FDebugInfoWindow :=
    TDebugInfoWindow.Create(
      FGlobalAppConfig,
      FPerfCounterList
    );
  FBatteryStatus := TBatteryStatus.Create;
  FLastSelectionSaver :=
    TLastSelectionInfoSaver.Create(
      FAppClosingNotifier,
      FVectorItmesFactory,
      FLastSelectionInfo,
      FLastSelectionFileName
    );
end;

destructor TGlobalState.Destroy;
begin
  FGCThread.Terminate;
  FGCThread.WaitFor;
  FreeAndNil(FGCThread);
  FLanguageManager := nil;
  FTileNameGenerator := nil;
  FContentTypeManager := nil;
  FMapCalibrationList := nil;
  FMarksDb := nil;
  FLastSelectionInfo := nil;
  FGPSConfig := nil;
  FGPSRecorder := nil;
  FreeAndNil(FMainMapsList);
  FCoordConverterFactory := nil;
  FGSMpar := nil;
  FInetConfig := nil;
  FViewConfig := nil;
  FMainFormConfig := nil;
  FLastSearchResultConfig := nil;
  FImageResamplerConfig := nil;
  FTileMatrixDraftResamplerConfig := nil;
  FBitmapPostProcessingConfig := nil;
  FValueToStringConverterConfig := nil;
  FMainMemCacheConfig := nil;
  FMarksCategoryFactoryConfig := nil;
  FMarkPictureList := nil;
  FSkyMapDraw := nil;
  FreeAndNil(FProtocol);
  FreeAndNil(FGUISyncronizedTimer);
  FGUISyncronizedTimerNotifier := nil;
  FMainConfigProvider := nil;
  FGlobalInternetState := nil;
  FArchiveReadWriteFactory := nil;
  FBitmapTileSaveLoadFactory := nil;
  FTerrainProviderList := nil;
  FTerrainConfig := nil;
  FProjConverterFactory := nil;
  FreeAndNil(FCacheConfig);
  inherited;
end;

procedure TGlobalState.InitProtocol;
var
  VInternalDomainInfoProviderList: TInternalDomainInfoProviderList;
  VInternalDomainInfoProvider: IInternalDomainInfoProvider;
  VTextProivder: ITextByVectorItem;
  VTextProviderList: TStringList;
begin
  VInternalDomainInfoProviderList := TInternalDomainInfoProviderList.Create;

  VInternalDomainInfoProvider :=
    TInternalDomainInfoProviderByMapTypeList.Create(
      FZmpInfoSet,
      FContentTypeManager
    );

  VInternalDomainInfoProviderList.Add(
    CZmpInfoInternalDomain,
    VInternalDomainInfoProvider
  );

  VInternalDomainInfoProvider :=
    TInternalDomainInfoProviderByDataProvider.Create(
      TConfigDataProviderByPathConfig.Create(FMediaDataPath),
      FContentTypeManager
    );
  VInternalDomainInfoProviderList.Add(
    CMediaDataInternalDomain,
    VInternalDomainInfoProvider
  );
  VTextProviderList := TStringList.Create;
  VTextProviderList.Sorted := True;
  VTextProviderList.Duplicates := dupError;
  VTextProivder :=
    TTextByVectorItemMarkInfo.Create(
      FValueToStringConverterConfig,
      TDatum.Create(3395, 6378137, 6356752)
    );

  VTextProviderList.AddObject(CVectorItemInfoSuffix, Pointer(VTextProivder));
  VTextProivder._AddRef;

  VTextProivder := TTextByVectorItemHTMLByDescription.Create;
  VTextProviderList.AddObject(CVectorItemDescriptionSuffix, Pointer(VTextProivder));
  VTextProivder._AddRef;

  VInternalDomainInfoProvider :=
    TInternalDomainInfoProviderByMarksSystem.Create(
      FMarksDb,
      VTextProivder,
      VTextProviderList
    );
  VInternalDomainInfoProviderList.Add(
    CMarksSystemInternalDomain,
    VInternalDomainInfoProvider
  );

  VInternalDomainInfoProvider :=
    TInternalDomainInfoProviderByLastSearchResults.Create(
      FLastSearchResultConfig,
      VTextProivder,
      nil
    );
  VInternalDomainInfoProviderList.Add(
    CLastSearchResultsInternalDomain,
    VInternalDomainInfoProvider
  );

  VInternalDomainInfoProvider :=
    TInternalDomainInfoProviderByMapData.Create(
      FMainMapsList.FullMapsSetChangeable,
      VTextProivder,
      CVectorItemDescriptionSuffix
    );

  VInternalDomainInfoProviderList.Add(
    CMapDataInternalDomain,
    VInternalDomainInfoProvider
  );

  VInternalDomainInfoProvider :=
    TInternalDomainInfoProviderByTileStorageOptions.Create(
      FMainMapsList.FullMapsSetChangeable
    );

  VInternalDomainInfoProviderList.Add(
    CTileStorageOptionsInternalDomain,
    VInternalDomainInfoProvider
  );

  FProtocol :=
    TIeEmbeddedProtocolRegistration.Create(
      CSASProtocolName,
      TIeEmbeddedProtocolFactory.Create(VInternalDomainInfoProviderList)
    );
end;

{$IFDEF SasDebugWithJcl}
procedure TGlobalState.DoException(
  Sender: TObject;
  E: Exception
);
var
  VStr: TStringList;
begin
  VStr := TStringList.Create;
  try
    JclLastExceptStackListToStrings(VStr, True, True, True, True);
    VStr.Insert(0, E.Message);
    VStr.Insert(1, '');
    Application.MessageBox(PChar(VStr.Text), '������', MB_OK or MB_ICONSTOP);
  finally
    FreeAndNil(VStr);
  end;
end;

{$ENDIF SasDebugWithJcl}

procedure TGlobalState.StartExceptionTracking;
begin
  {$IFDEF SasDebugWithJcl}
  JclStackTrackingOptions := JclStackTrackingOptions + [stRAWMode];
  JclStartExceptionTracking;
  Application.OnException := DoException;
  {$ENDIF SasDebugWithJcl}
end;

procedure TGlobalState.StartThreads;
begin
  FAppStartedNotifierInternal.ExecuteOperation;
  if FGlobalAppConfig.IsSendStatistic then begin
    FInvisibleBrowser.NavigateAndWait('http://sasgis.ru/stat/index.html');
  end;
  FLastSelectionSaver.Start;
  FGUISyncronizedTimer.Enabled := True;
end;

procedure TGlobalState.StopExceptionTracking;
begin
  {$IFDEF SasDebugWithJcl}
  Application.OnException := nil;
  JclStopExceptionTracking;
  {$ENDIF SasDebugWithJcl}
end;

procedure TGlobalState.LoadConfig;
var
  VLocalMapsConfig: IConfigDataProvider;
  Ini: TMeminifile;
  VMapsPath: String;
begin
  VMapsPath := IncludeTrailingPathDelimiter(FMapsPath.FullPath);
  ForceDirectories(VMapsPath);
  Ini := TMeminiFile.Create(VMapsPath + 'Maps.ini');
  VLocalMapsConfig := TConfigDataProviderByIniFile.Create(Ini);

  FCacheConfig.LoadConfig(FMainConfigProvider);

  FTerrainConfig.ReadConfig(MainConfigProvider.GetSubItem('Terrain'));

  FMainMapsList.LoadMaps(
    FLanguageManager,
    FMainMemCacheConfig,
    FCacheConfig,
    FTileNameGenerator,
    FTileNameParser,
    FGCThread.List,
    FAppClosingNotifier,
    FInetConfig,
    FDownloadConfig,
    FDownloaderThreadConfig,
    FContentTypeManager,
    FCoordConverterFactory,
    FInvisibleBrowser,
    FProjConverterFactory,
    VLocalMapsConfig
  );
  FMainFormConfig :=
    TMainFormConfig.Create(
      FLocalConverterFactory,
      FContentTypeManager,
      FGeoCoderList,
      FLastSearchResultConfig,
      FMainMapsList.MapsSet,
      FMainMapsList.LayersSet,
      FMainMapsList.FirstMainMapGUID,
      FPerfCounterList.CreateAndAddNewSubList('ViewState')
    );

  FSensorList :=
    TSensorListStuped.Create(
      FLanguageManager,
      FMainFormConfig.ViewPortState.Position,
      FMainFormConfig.NavToPoint,
      FGPSRecorder,
      FBatteryStatus,
      FValueToStringConverterConfig
    );
  FInternalBrowserConfig.ReadConfig(MainConfigProvider.GetSubItem('InternalBrowser'));
  FViewConfig.ReadConfig(MainConfigProvider.GetSubItem('View'));
  FGPSRecorder.ReadConfig(MainConfigProvider.GetSubItem('GPS'));
  FGPSConfig.ReadConfig(MainConfigProvider.GetSubItem('GPS'));
  FInetConfig.ReadConfig(MainConfigProvider.GetSubItem('Internet'));
  FDownloadConfig.ReadConfig(MainConfigProvider.GetSubItem('Internet'));
  FDownloaderThreadConfig.ReadConfig(MainConfigProvider.GetSubItem('Internet'));
  FGSMpar.ReadConfig(MainConfigProvider.GetSubItem('GSM'));
  FBitmapPostProcessingConfig.ReadConfig(MainConfigProvider.GetSubItem('COLOR_LEVELS'));
  FValueToStringConverterConfig.ReadConfig(MainConfigProvider.GetSubItem('ValueFormats'));

  if (not ModuleIsLib) then begin
    FMainFormConfig.ReadConfig(MainConfigProvider);
    FImageResamplerConfig.ReadConfig(MainConfigProvider.GetSubItem('View'));
    FTileMatrixDraftResamplerConfig.ReadConfig(MainConfigProvider.GetSubItem('View_TilesDrafts'));
    FTileLoadResamplerConfig.ReadConfig(MainConfigProvider.GetSubItem('Maps_Load'));
    FTileGetPrevResamplerConfig.ReadConfig(MainConfigProvider.GetSubItem('Maps_GetPrev'));
    FTileReprojectResamplerConfig.ReadConfig(MainConfigProvider.GetSubItem('Maps_Reproject'));
    FTileDownloadResamplerConfig.ReadConfig(MainConfigProvider.GetSubItem('Maps_Download'));
    FMainMemCacheConfig.ReadConfig(MainConfigProvider.GetSubItem('View'));
    FMarkPictureList.ReadConfig(MainConfigProvider);
    FMarksCategoryFactoryConfig.ReadConfig(MainConfigProvider.GetSubItem('MarkNewCategory'));
    FMarksDb.ReadConfig(MainConfigProvider);
  end;
end;

procedure TGlobalState.OnGUISyncronizedTimer(Sender: TObject);
begin
  FGUISyncronizedTimerNotifierInternal.Notify(nil);
end;

procedure TGlobalState.SaveMainParams;
var
  Ini: TMeminifile;
  VLocalMapsConfig: IConfigDataWriteProvider;
  VMapsPath: String;
begin
  if ModuleIsLib then begin
    Exit;
  end;
  VMapsPath := IncludeTrailingPathDelimiter(FMapsPath.FullPath);
  Ini := TMeminiFile.Create(VMapsPath + 'Maps.ini');
  VLocalMapsConfig := TConfigDataWriteProviderByIniFile.Create(Ini);
  FMainMapsList.SaveMaps(VLocalMapsConfig);

  FGPSRecorder.WriteConfig(MainConfigProvider.GetOrCreateSubItem('GPS'));
  FGPSConfig.WriteConfig(MainConfigProvider.GetOrCreateSubItem('GPS'));
  FInetConfig.WriteConfig(MainConfigProvider.GetOrCreateSubItem('Internet'));
  FDownloadConfig.WriteConfig(MainConfigProvider.GetOrCreateSubItem('Internet'));
  FDownloaderThreadConfig.WriteConfig(MainConfigProvider.GetOrCreateSubItem('Internet'));
  FZmpConfig.WriteConfig(MainConfigProvider.GetOrCreateSubItem('ZmpDefaultParams'));
  FGSMpar.WriteConfig(MainConfigProvider.GetOrCreateSubItem('GSM'));
  FViewConfig.WriteConfig(MainConfigProvider.GetOrCreateSubItem('View'));
  FInternalBrowserConfig.WriteConfig(MainConfigProvider.GetOrCreateSubItem('InternalBrowser'));
  FLanguageManager.WriteConfig(FMainConfigProvider.GetOrCreateSubItem('VIEW'));
  FGlobalAppConfig.WriteConfig(FMainConfigProvider.GetOrCreateSubItem('VIEW'));
  FStartUpLogoConfig.WriteConfig(FMainConfigProvider.GetOrCreateSubItem('StartUpLogo'));
  FBitmapPostProcessingConfig.WriteConfig(MainConfigProvider.GetOrCreateSubItem('COLOR_LEVELS'));
  FValueToStringConverterConfig.WriteConfig(MainConfigProvider.GetOrCreateSubItem('ValueFormats'));
  FMainFormConfig.WriteConfig(MainConfigProvider);
  FCacheConfig.SaveConfig(FMainConfigProvider);
  FImageResamplerConfig.WriteConfig(MainConfigProvider.GetOrCreateSubItem('View'));
  FTileMatrixDraftResamplerConfig.WriteConfig(MainConfigProvider.GetOrCreateSubItem('View_TilesDrafts'));
  FTileLoadResamplerConfig.WriteConfig(MainConfigProvider.GetOrCreateSubItem('Maps_Load'));
  FTileGetPrevResamplerConfig.WriteConfig(MainConfigProvider.GetOrCreateSubItem('Maps_GetPrev'));
  FTileReprojectResamplerConfig.WriteConfig(MainConfigProvider.GetOrCreateSubItem('Maps_Reproject'));
  FTileDownloadResamplerConfig.WriteConfig(MainConfigProvider.GetOrCreateSubItem('Maps_Download'));
  FMainMemCacheConfig.WriteConfig(MainConfigProvider.GetOrCreateSubItem('View'));
  FMarkPictureList.WriteConfig(MainConfigProvider);
  FMarksCategoryFactoryConfig.WriteConfig(MainConfigProvider.GetOrCreateSubItem('MarkNewCategory'));
  FMarksDb.WriteConfig(MainConfigProvider);
  FTerrainConfig.WriteConfig(MainConfigProvider.GetOrCreateSubItem('Terrain'));

  FMapsPath.WriteConfig(FMainConfigProvider.GetOrCreateSubItem('PATHtoMAPS'));
  FTrackPath.WriteConfig(FMainConfigProvider.GetOrCreateSubItem('PATHtoTRACKS'));
  FMarksDbPath.WriteConfig(FMainConfigProvider.GetOrCreateSubItem('PATHtoMARKS'));
  FMediaDataPath.WriteConfig(FMainConfigProvider.GetOrCreateSubItem('PATHtoMediaData'));
  FTerrainDataPath.WriteConfig(FMainConfigProvider.GetOrCreateSubItem('PATHtoTerrainData'));
  FLastSelectionFileName.WriteConfig(FMainConfigProvider.GetOrCreateSubItem('LastSelection'));
end;

procedure TGlobalState.SendTerminateToThreads;
begin
  FGUISyncronizedTimer.Enabled := False;
  FAppClosingNotifierInternal.ExecuteOperation;
  FGCThread.Terminate;
end;

end.
