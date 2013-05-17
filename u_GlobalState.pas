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
  Windows,
  {$IFDEF SasDebugWithJcl}
  JclDebug,
  {$ENDIF SasDebugWithJcl}
  ExtCtrls,
  Classes,
  IniFiles,
  SysUtils,
  i_MapVersionFactoryList,
  i_NotifierOperation,
  i_GPSPositionFactory,
  i_Listener,
  i_BackgroundTask,
  i_ConfigDataWriteProvider,
  i_ConfigDataProvider,
  i_TileFileNameGeneratorsList,
  i_TileFileNameParsersList,
  i_ContentTypeManager,
  i_VectorDataLoader,
  i_CoordConverterFactory,
  i_CoordConverterList,
  i_ProjConverter,
  i_BatteryStatus,
  i_LocalCoordConverterFactorySimpe,
  i_GPSModule,
  i_MainFormConfig,
  i_DownloadInfoSimple,
  i_ImageResamplerConfig,
  i_GeoCoderList,
  i_MarkPicture,
  i_InternalPerformanceCounter,
  i_MarkSystem,
  i_ZmpInfoSet,
  i_Datum,
  i_PathConfig,
  i_NotifierTime,
  i_Bitmap32StaticFactory,
  i_VectorDataFactory,
  i_MapCalibration,
  i_ImportFile,
  i_PathDetalizeProviderList,
  i_GPSRecorder,
  i_SatellitesInViewMapDraw,
  i_SensorList,
  i_TerrainProviderList,
  i_VectorItemsFactory,
  i_InvisibleBrowser,
  i_InternalBrowser,
  i_DebugInfoWindow,
  i_GlobalInternetState,
  i_GlobalBerkeleyDBHelper,
  i_BitmapPostProcessing,
  i_BitmapTileSaveLoadFactory,
  i_ArchiveReadWriteFactory,
  i_SystemTimeProvider,
  i_MarkCategoryFactory,
  i_MarkFactory,
  i_GlobalConfig,
  i_GlobalCacheConfig,
  u_GarbageCollectorThread,
  u_MapTypesMainList,
  u_IeEmbeddedProtocolRegistration;

{$I vsagps_defines.inc}

type
  TGlobalState = class
  private
    FGlobalConfig: IGlobalConfig;
    FBaseConfigPath: IPathConfig;
    FBaseDataPath: IPathConfig;
    FBaseCahcePath: IPathConfig;
    FBaseApplicationPath: IPathConfig;

    FMainConfigProvider: IConfigDataWriteProvider;
    FZmpInfoSet: IZmpInfoSet;
    FResourceProvider: IConfigDataProvider;
    FTileNameGenerator: ITileFileNameGeneratorsList;
    FTileNameParser: ITileFileNameParsersList;
    FGCThread: TGarbageCollectorThread;
    FContentTypeManager: IContentTypeManager;
    FMapCalibrationList: IMapCalibrationList;
    FCacheConfig: IGlobalCacheConfig;
    FMarkSystem: IMarkSystem;
    FCoordConverterFactory: ICoordConverterFactory;
    FCoordConverterList: ICoordConverterList;
    FProjConverterFactory: IProjConverterFactory;
    FProjectionFactory: IProjectionInfoFactory;
    FLocalConverterFactory: ILocalCoordConverterFactorySimpe;
    FMainMapsList: TMapTypesMainList;
    FGPSPositionFactory: IGPSPositionFactory;
    FMainFormConfig: IMainFormConfig;
    FBitmapPostProcessing: IBitmapPostProcessingChangeable;
    FDownloadInfo: IDownloadInfoSimple;
    FGlobalInternetState: IGlobalInternetState;
    FGlobalBerkeleyDBHelper: IGlobalBerkeleyDBHelper;
    FGeoCoderList: IGeoCoderList;
    FMarkPictureList: IMarkPictureList;
    FGpsSystem: IGPSModule;
    FImportFileByExt: IImportFile;
    FGPSDatum: IDatum;
    FGPSRecorder: IGPSRecorder;
    FGPSRecorderInternal: IGPSRecorderInternal;
    FGpsTrackRecorder: IGpsTrackRecorder;
    FGpsTrackRecorderInternal: IGpsTrackRecorderInternal;
    FSkyMapDraw: ISatellitesInViewMapDraw;
    FSystemTime: ISystemTimeProvider;
    FSystemTimeInternal: ISystemTimeProviderInternal;
    FBGTimerNotifier: INotifierTime;
    FBGTimerNotifierInternal: INotifierTimeInternal;
    FGUISyncronizedTimer: TTimer;
    FGUISyncronizedTimerNotifierInternal: INotifierTimeInternal;
    FGUISyncronizedTimerNotifier: INotifierTime;
    FGUISyncronizedTimerCounter: IInternalPerformanceCounter;
    FSensorList: ISensorList;
    FPerfCounterList: IInternalPerformanceCounterList;
    FProtocol: TIeEmbeddedProtocolRegistration;
    FMapVersionFactoryList: IMapVersionFactoryList;
    FPathDetalizeList: IPathDetalizeProviderList;
    FInvisibleBrowser: IInvisibleBrowser;
    FInternalBrowser: IInternalBrowser;
    FDebugInfoWindow: IDebugInfoWindow;
    FAppStartedNotifier: INotifierOneOperation;
    FAppStartedNotifierInternal: INotifierOneOperationInternal;
    FAppClosingNotifier: INotifierOneOperation;
    FAppClosingNotifierInternal: INotifierOneOperationInternal;
    FVectorItemsFactory: IVectorItemsFactory;
    FBitmapFactory: IBitmap32StaticFactory;
    FBatteryStatus: IBatteryStatus;
    FTerrainProviderList: ITerrainProviderList;
    FBitmapTileSaveLoadFactory: IBitmapTileSaveLoadFactory;
    FArchiveReadWriteFactory: IArchiveReadWriteFactory;
    FLastSelectionSaver: IBackgroundTask;
    FMainThreadConfigListener: IListener;
    FVectorDataFactory: IVectorDataFactory;
    FMarkFactory: IMarkFactory;
    FMarkCategoryFactory: IMarkCategoryFactory;

    procedure OnMainThreadConfigChange;
    procedure InitProtocol;

    procedure OnGUISyncronizedTimer(Sender: TObject);
    {$IFDEF SasDebugWithJcl}
    procedure DoException(
      Sender: TObject;
      E: Exception
    );
    {$ENDIF SasDebugWithJcl}
  public
    property Config: IGlobalConfig read FGlobalConfig;

    property MapType: TMapTypesMainList read FMainMapsList;
    property CacheConfig: IGlobalCacheConfig read FCacheConfig;
    property MarksDb: IMarkSystem read FMarkSystem;
    property GpsSystem: IGPSModule read FGpsSystem;
    property GPSDatum: IDatum read FGPSDatum;

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

    property MainConfigProvider: IConfigDataWriteProvider read FMainConfigProvider;
    property ResourceProvider: IConfigDataProvider read FResourceProvider;
    property DownloadInfo: IDownloadInfoSimple read FDownloadInfo;
    property GlobalInternetState: IGlobalInternetState read FGlobalInternetState;
    property ImportFileByExt: IImportFile read FImportFileByExt;
    property SkyMapDraw: ISatellitesInViewMapDraw read FSkyMapDraw;
    property GUISyncronizedTimerNotifier: INotifierTime read FGUISyncronizedTimerNotifier;
    property BGTimerNotifier: INotifierTime read FBGTimerNotifier;
    property PerfCounterList: IInternalPerformanceCounterList read FPerfCounterList;
    property SystemTime: ISystemTimeProvider read FSystemTime;

    property MainFormConfig: IMainFormConfig read FMainFormConfig;
    property BitmapPostProcessing: IBitmapPostProcessingChangeable read FBitmapPostProcessing;
    property GPSRecorder: IGPSRecorder read FGPSRecorder;
    property GpsTrackRecorder: IGpsTrackRecorder read FGpsTrackRecorder;
    property PathDetalizeList: IPathDetalizeProviderList read FPathDetalizeList;
    property SensorList: ISensorList read FSensorList;
    property InternalBrowser: IInternalBrowser read FInternalBrowser;
    property DebugInfoWindow: IDebugInfoWindow read FDebugInfoWindow;
    property VectorItemsFactory: IVectorItemsFactory read FVectorItemsFactory;
    property BitmapFactory: IBitmap32StaticFactory read FBitmapFactory;
    property VectorDataFactory: IVectorDataFactory read FVectorDataFactory;
    property BitmapTileSaveLoadFactory: IBitmapTileSaveLoadFactory read FBitmapTileSaveLoadFactory;
    property ArchiveReadWriteFactory: IArchiveReadWriteFactory read FArchiveReadWriteFactory;
    property TerrainProviderList: ITerrainProviderList read FTerrainProviderList;
    property GlobalBerkeleyDBHelper: IGlobalBerkeleyDBHelper read FGlobalBerkeleyDBHelper;
    property MarkPictureList: IMarkPictureList read FMarkPictureList;
    property MapVersionFactoryList: IMapVersionFactoryList read FMapVersionFactoryList;

    constructor Create;
    destructor Destroy; override;
    procedure LoadConfig;
    procedure SaveMainParams;
    procedure StartThreads;
    procedure SendTerminateToThreads;
    procedure SystemTimeChanged;

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
  u_NotifierTime,
  i_FileNameIterator,
  u_ContentTypeManagerSimple,
  u_MarkSystem,
  u_MapCalibrationListBasic,
  u_XmlInfoSimpleParser,
  u_KmzInfoSimpleParser,
  u_KmlInfoSimpleParser,
  u_CoordConverterFactorySimple,
  u_CoordConverterListStaticSimple,
  u_DownloadInfoSimple,
  u_Datum,
  u_PLTSimpleParser,
  u_MapVersionFactoryList,
  u_GeoCoderListSimple,
  u_MarkPictureListSimple,
  u_ImageResamplerFactoryListStaticSimple,
  u_ImportByFileExt,
  u_GlobalBerkeleyDBHelper,
  u_GPSRecorder,
  u_GpsTrackRecorder,
  u_SatellitesInViewMapDrawSimple,
  u_GPSModuleFactoryByVSAGPS,
  u_GPSPositionFactory,
  u_ProjectionInfoFactory,
  u_LocalCoordConverterFactorySimpe,
  u_TerrainProviderList,
  u_MainFormConfig,
  u_ProjConverterFactory,
  u_PathConfig,
  u_BatteryStatus,
  u_ZmpInfoSet,
  u_ZmpFileNamesIteratorFactory,
  u_SensorListStuped,
  u_HtmlToHintTextConverterStuped,
  u_InvisibleBrowserByFormSynchronize,
  u_InternalBrowserByForm,
  u_DebugInfoWindow,
  u_BaseInterfacedObject,
  u_BaseInterfacedObjectDebug,
  u_InternalPerformanceCounter,
  u_InternalPerformanceCounterList,
  u_InternalPerformanceCounterFake,
  u_IeEmbeddedProtocolFactory,
  u_VectorItemsFactorySimple,
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
  u_Bitmap32StaticFactory,
  u_GpsSystem,
  u_LastSelectionInfoSaver,
  u_ListenerByEvent,
  u_Synchronizer,
  u_GlobalConfig,
  u_GlobalInternetState,
  u_GlobalCacheConfig,
  u_MarkFactory,
  u_MarkCategoryFactory,
  u_SystemTimeProvider,
  u_BitmapTileSaveLoadFactory,
  u_ArchiveReadWriteFactory,
  u_BitmapPostProcessingChangeableByConfig,
  u_TileFileNameParsersSimpleList,
  u_TileFileNameGeneratorsSimpleList;

{ TGlobalState }

constructor TGlobalState.Create;
var
  VViewCnonfig: IConfigDataProvider;
  VMarksKmlLoadCounterList: IInternalPerformanceCounterList;
  VXmlLoader: IVectorDataLoader;
  VKmlLoader: IVectorDataLoader;
  VKmzLoader: IVectorDataLoader;
  VFilesIteratorFactory: IFileNameIteratorFactory;
  VFilesIterator: IFileNameIterator;
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
  FBaseCahcePath := TPathConfig.Create('', VProgramPath, nil);

  FMapVersionFactoryList := TMapVersionFactoryList.Create;

  FGlobalConfig :=
    TGlobalConfig.Create(
      FBaseCahcePath,
      FBaseConfigPath,
      FBaseDataPath,
      FBaseApplicationPath
    );
  FBGTimerNotifierInternal := TNotifierTime.Create;
  FBGTimerNotifier := FBGTimerNotifierInternal;
  FBitmapFactory :=
    TBitmap32StaticFactory.Create(
      FBGTimerNotifier,
      MakeSyncRW_Var(Self, false)
    );
  FSystemTimeInternal := TSystemTimeProvider.Create;
  FSystemTime := FSystemTimeInternal;

  FBitmapTileSaveLoadFactory := TBitmapTileSaveLoadFactory.Create(FBitmapFactory);
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

  FGlobalConfig.ReadConfig(FMainConfigProvider);

  VSleepByClass := FMainConfigProvider.GetSubItem('SleepByClass');

  FResourceProvider := FMainConfigProvider.GetSubItem('sas:\Resource');
  FVectorItemsFactory := TVectorItemsFactorySimple.Create;

  FGlobalInternetState := TGlobalInternetState.Create;

  FProjConverterFactory := TProjConverterFactory.Create;

  FCoordConverterFactory := TCoordConverterFactorySimple.Create;
  FProjectionFactory := TProjectionInfoFactory.Create(MakeSyncRW_Var(Self, False));
  FCoordConverterList := TCoordConverterListStaticSimple.Create(FCoordConverterFactory);
  FLocalConverterFactory := TLocalCoordConverterFactorySimpe.Create(FProjectionFactory);

  FCacheConfig := TGlobalCacheConfig.Create(FBaseCahcePath);
  FDownloadInfo := TDownloadInfoSimple.Create(nil);
  VViewCnonfig := FMainConfigProvider.GetSubItem('VIEW');

  if FGlobalConfig.GlobalAppConfig.IsShowDebugInfo then begin
    FPerfCounterList := TInternalPerformanceCounterList.Create('Main', TInternalPerformanceCounterFactory.Create);
    if TBaseInterfacedObject = TBaseInterfacedObjectDebug then begin
      FPerfCounterList.AddSubList(TBaseInterfacedObjectDebug.GetCounters);
    end;
  end else begin
    FPerfCounterList := TInternalPerformanceCounterFake.Create;
  end;

  FGUISyncronizedTimer := TTimer.Create(nil);
  FGUISyncronizedTimer.Enabled := False;
  FGUISyncronizedTimer.Interval := VSleepByClass.ReadInteger('GUISyncronizedTimer', 200);
  FGUISyncronizedTimer.OnTimer := Self.OnGUISyncronizedTimer;

  FGUISyncronizedTimerNotifierInternal := TNotifierTime.Create;
  FGUISyncronizedTimerNotifier := FGUISyncronizedTimerNotifierInternal;
  FGUISyncronizedTimerCounter := FPerfCounterList.CreateAndAddNewCounter('GUITimer');

  FGlobalBerkeleyDBHelper := TGlobalBerkeleyDBHelper.Create(FCacheConfig.BDBCachePath);

  FTerrainProviderList := TTerrainProviderListSimple.Create(FProjConverterFactory, FGlobalConfig.TerrainDataPath, FCacheConfig);

  FMainThreadConfigListener := TNotifyEventListenerSync.Create(FGUISyncronizedTimerNotifier, 1000, Self.OnMainThreadConfigChange);
  FGlobalConfig.MainThreadConfig.ChangeNotifier.Add(FMainThreadConfigListener);
  OnMainThreadConfigChange;

  FGPSDatum := TDatum.Create(3395, 6378137, 6356752);

  VResamplerFactoryList := TImageResamplerFactoryListStaticSimple.Create;

  FGPSPositionFactory := TGPSPositionFactory.Create;
  FGPSRecorderInternal :=
    TGPSRecorder.Create(
      FGPSDatum,
      FGlobalConfig.GpsRecorderFileName,
      FGPSPositionFactory.BuildPositionEmpty
    );
  FGPSRecorder := FGPSRecorderInternal;

  FGpsTrackRecorderInternal :=
    TGpsTrackRecorder.Create(
      FVectorItemsFactory,
      FGlobalConfig.GpsTrackRecorderFileName
    );
  FGpsTrackRecorder := FGpsTrackRecorderInternal;

  FTileNameGenerator := TTileFileNameGeneratorsSimpleList.Create;
  FTileNameParser := TTileFileNameParsersSimpleList.Create;

  FContentTypeManager :=
    TContentTypeManagerSimple.Create(
      FVectorItemsFactory,
      FBitmapTileSaveLoadFactory,
      FArchiveReadWriteFactory,
      FPerfCounterList
    );

  FMapCalibrationList := TMapCalibrationListBasic.Create;
  VMarksKmlLoadCounterList := FPerfCounterList.CreateAndAddNewSubList('Import');

  // xml loaders
  VXmlLoader :=
    TXmlInfoSimpleParser.Create(
      FVectorItemsFactory,
      True,
      VMarksKmlLoadCounterList
    );
{$if defined(VSAGPS_ALLOW_IMPORT_KML)}
  VKmlLoader := VXmlLoader;
  VKmzLoader :=
    TKmzInfoSimpleParser.Create(
      TXmlInfoSimpleParser.Create(FVectorItemsFactory, True, nil),
      FArchiveReadWriteFactory,
      VMarksKmlLoadCounterList
    );
{$else}
  VKmlLoader :=
    TKmlInfoSimpleParser.Create(
      FVectorItemsFactory,
      VMarksKmlLoadCounterList
    );
  VKmzLoader :=
    TKmzInfoSimpleParser.Create(
      TKmlInfoSimpleParser.Create(FVectorItemsFactory, nil),
      FArchiveReadWriteFactory,
      VMarksKmlLoadCounterList
    );
{$ifend}
  FVectorDataFactory := TVectorDataFactorySimple.Create(THtmlToHintTextConverterStuped.Create);
  FImportFileByExt := TImportByFileExt.Create(
    FGlobalConfig.ValueToStringConverterConfig,
    FVectorDataFactory,
    FVectorItemsFactory,
    VXmlLoader,
    TPLTSimpleParser.Create(
      FVectorItemsFactory,
      VMarksKmlLoadCounterList
    ),
    VKmlLoader,
    VKmzLoader
  );
  FGCThread :=
    TGarbageCollectorThread.Create(
      FAppClosingNotifier,
      FPerfCounterList.CreateAndAddNewCounter('GCTimer'),
      FBGTimerNotifierInternal,
      VSleepByClass.ReadInteger(TGarbageCollectorThread.ClassName, 1000)
    );
  FBitmapPostProcessing :=
    TBitmapPostProcessingChangeableByConfig.Create(
      FGlobalConfig.BitmapPostProcessingConfig,
      FBitmapFactory
    );
  FGpsSystem :=
    TGpsSystem.Create(
      FAppStartedNotifier,
      FAppClosingNotifier,
      TGPSModuleFactoryByVSAGPS.Create(FSystemTime, FGPSPositionFactory),
      FGlobalConfig.GPSConfig,
      FGPSRecorderInternal,
      FGpsTrackRecorderInternal,
      GUISyncronizedTimerNotifier,
      FPerfCounterList
    );
  FGeoCoderList :=
    TGeoCoderListSimple.Create(
      FGlobalConfig.InetConfig,
      BGTimerNotifier,
      TDownloadResultFactory.Create,
      FGlobalConfig.ValueToStringConverterConfig
    );
  FMarkPictureList := TMarkPictureListSimple.Create(FGlobalConfig.MarksIconsPath, FContentTypeManager);

  FMarkCategoryFactory :=
    TMarkCategoryFactory.Create(
      FGlobalConfig.MarksCategoryFactoryConfig
    );
  FMarkFactory :=
    TMarkFactory.Create(
      FGlobalConfig.MarksFactoryConfig,
      FMarkPictureList,
      FVectorItemsFactory,
      THtmlToHintTextConverterStuped.Create
    );
  FMarkSystem :=
    TMarkSystem.Create(
      FGlobalConfig.MarksDbPath,
      FMarkPictureList,
      FMarkFactory,
      FMarkCategoryFactory,
      FVectorItemsFactory,
      FPerfCounterList.CreateAndAddNewSubList('MarksSystem'),
      FAppStartedNotifier,
      THtmlToHintTextConverterStuped.Create,
    );
  VFilesIteratorFactory := TZmpFileNamesIteratorFactory.Create;
  VFilesIterator := VFilesIteratorFactory.CreateIterator(FGlobalConfig.MapsPath.FullPath, '');
  FZmpInfoSet :=
    TZmpInfoSet.Create(
      FGlobalConfig.ZmpConfig,
      FCoordConverterFactory,
      FArchiveReadWriteFactory,
      FContentTypeManager,
      FBitmapFactory,
      FGlobalConfig.LanguageManager,
      VFilesIterator
    );

  FMainMapsList :=
    TMapTypesMainList.Create(
      FZmpInfoSet,
      FGlobalConfig.TileLoadResamplerConfig,
      FGlobalConfig.TileGetPrevResamplerConfig,
      FGlobalConfig.TileReprojectResamplerConfig,
      FGlobalConfig.TileDownloadResamplerConfig,
      FPerfCounterList.CreateAndAddNewSubList('MapType')
    );
  FSkyMapDraw := TSatellitesInViewMapDrawSimple.Create;
  FPathDetalizeList :=
    TPathDetalizeProviderListSimple.Create(
      FGlobalConfig.LanguageManager,
      FGlobalConfig.InetConfig,
      FBGTimerNotifier,
      TDownloadResultFactory.Create,
      FVectorDataFactory,
      FVectorItemsFactory,
      VKmlLoader
    );

  InitProtocol;

  FInvisibleBrowser :=
    TInvisibleBrowserByFormSynchronize.Create(
      FGlobalConfig.LanguageManager,
      FGlobalConfig.InetConfig.ProxyConfig
    );
  FInternalBrowser :=
    TInternalBrowserByForm.Create(
      FGlobalConfig.LanguageManager,
      FGlobalConfig.InternalBrowserConfig,
      FGlobalConfig.InetConfig.ProxyConfig,
      FContentTypeManager
    );
  FDebugInfoWindow :=
    TDebugInfoWindow.Create(
      FGlobalConfig.GlobalAppConfig,
      FPerfCounterList
    );
  FBatteryStatus := TBatteryStatus.Create;
  FLastSelectionSaver :=
    TLastSelectionInfoSaver.Create(
      FAppClosingNotifier,
      FVectorItemsFactory,
      FGlobalConfig.LastSelectionInfo,
      FGlobalConfig.LastSelectionFileName
    );
end;

destructor TGlobalState.Destroy;
begin
  FGCThread.Terminate;
  FGCThread.WaitFor;
  FreeAndNil(FGCThread);
  FTileNameGenerator := nil;
  FContentTypeManager := nil;
  FMapCalibrationList := nil;
  FMarkSystem := nil;
  FGPSRecorder := nil;
  FreeAndNil(FMainMapsList);
  FCoordConverterFactory := nil;
  FMainFormConfig := nil;
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
  FProjConverterFactory := nil;
  FGlobalBerkeleyDBHelper := nil;
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
      TConfigDataProviderByPathConfig.Create(FGlobalConfig.MediaDataPath),
      FContentTypeManager
    );
  VInternalDomainInfoProviderList.Add(
    CMediaDataInternalDomain,
    VInternalDomainInfoProvider
  );
  VTextProviderList := TStringList.Create;
  VTextProviderList.Sorted := True;
  VTextProviderList.Duplicates := dupError;
  VTextProivder := TTextByVectorItemHTMLByDescription.Create;

  VTextProviderList.AddObject(CVectorItemInfoSuffix, Pointer(VTextProivder));
  VTextProivder._AddRef;

  VTextProviderList.AddObject(CVectorItemDescriptionSuffix, Pointer(VTextProivder));
  VTextProivder._AddRef;

  VInternalDomainInfoProvider :=
    TInternalDomainInfoProviderByMarksSystem.Create(
      FMarkSystem,
      VTextProivder,
      VTextProviderList
    );
  VInternalDomainInfoProviderList.Add(
    CMarksSystemInternalDomain,
    VInternalDomainInfoProvider
  );

  VInternalDomainInfoProvider :=
    TInternalDomainInfoProviderByLastSearchResults.Create(
      FGlobalConfig.LastSearchResultConfig,
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
  if FGlobalConfig.GlobalAppConfig.IsSendStatistic then begin
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

procedure TGlobalState.SystemTimeChanged;
begin
  FSystemTimeInternal.SystemTimeChanged;
end;

procedure TGlobalState.LoadConfig;
var
  VLocalMapsConfig: IConfigDataProvider;
  VIniFile: TMeminifile;
  VMapsPath: String;
begin
  VMapsPath := IncludeTrailingPathDelimiter(FGlobalConfig.MapsPath.FullPath);
  ForceDirectories(VMapsPath);
  VIniFile := TMeminiFile.Create(VMapsPath + 'Maps.ini');
  try
    VLocalMapsConfig := TConfigDataProviderByIniFile.CreateWithOwn(VIniFile);
    VIniFile := nil;
  finally
    VIniFile.Free;
  end;

  FCacheConfig.ReadConfig(FMainConfigProvider);

  FMainMapsList.LoadMaps(
    FGlobalConfig.LanguageManager,
    FMapVersionFactoryList,
    FGlobalConfig.MainMemCacheConfig,
    FCacheConfig,
    FGlobalBerkeleyDBHelper,
    FTileNameGenerator,
    FTileNameParser,
    FBGTimerNotifier,
    FAppClosingNotifier,
    FGlobalConfig.InetConfig,
    FGlobalConfig.DownloadConfig,
    FGlobalConfig.DownloaderThreadConfig,
    FBitmapFactory,
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
      FGlobalConfig.LastSearchResultConfig,
      FMainMapsList.MapsSet,
      FMainMapsList.LayersSet,
      FMainMapsList.FirstMainMapGUID,
      FPerfCounterList.CreateAndAddNewSubList('ViewState')
    );

  FSensorList :=
    TSensorListStuped.Create(
      FGlobalConfig.LanguageManager,
      FMainFormConfig.ViewPortState.View,
      FMainFormConfig.NavToPoint,
      FSystemTime,
      FGPSRecorder,
      FGpsSystem,
      FBatteryStatus,
      FGlobalConfig.ValueToStringConverterConfig
    );
  FGPSRecorderInternal.Load;
  FGpsTrackRecorderInternal.Load;

  if (not ModuleIsLib) then begin
    FMainFormConfig.ReadConfig(MainConfigProvider);
    FMarkPictureList.ReadConfig(MainConfigProvider);
  end;
end;

procedure TGlobalState.OnGUISyncronizedTimer(Sender: TObject);
var
  VContext: TInternalPerformanceCounterContext;
  VNow: Cardinal;
begin
  VContext := FGUISyncronizedTimerCounter.StartOperation;
  try
    VNow := GetTickCount;
    FGUISyncronizedTimerNotifierInternal.Notify(VNow);
  finally
    FGUISyncronizedTimerCounter.FinishOperation(VContext);
  end;
end;

procedure TGlobalState.OnMainThreadConfigChange;
const
  Priorities: array [TThreadPriority] of Integer =
   (THREAD_PRIORITY_IDLE, THREAD_PRIORITY_LOWEST, THREAD_PRIORITY_BELOW_NORMAL,
    THREAD_PRIORITY_NORMAL, THREAD_PRIORITY_ABOVE_NORMAL,
    THREAD_PRIORITY_HIGHEST, THREAD_PRIORITY_TIME_CRITICAL);
begin
  SetThreadPriority(GetCurrentThread(), Priorities[FGlobalConfig.MainThreadConfig.Priority]);
end;

procedure TGlobalState.SaveMainParams;
var
  VIniFile: TMeminifile;
  VLocalMapsConfig: IConfigDataWriteProvider;
  VMapsPath: String;
begin
  if ModuleIsLib then begin
    Exit;
  end;
  VMapsPath := IncludeTrailingPathDelimiter(FGlobalConfig.MapsPath.FullPath);
  VIniFile := TMeminiFile.Create(VMapsPath + 'Maps.ini');
  try
    VLocalMapsConfig := TConfigDataWriteProviderByIniFile.CreateWithOwn(VIniFile);
    VIniFile := nil;
  finally
    VIniFile.Free;
  end;
  FMainMapsList.SaveMaps(VLocalMapsConfig);

  FGPSRecorderInternal.Save;
  FGpsTrackRecorderInternal.Save;
  FMainFormConfig.WriteConfig(MainConfigProvider);
  FCacheConfig.WriteConfig(FMainConfigProvider);
  FMarkPictureList.WriteConfig(MainConfigProvider);
  FGlobalConfig.WriteConfig(MainConfigProvider);
end;

procedure TGlobalState.SendTerminateToThreads;
begin
  if FGlobalConfig.MainThreadConfig <> nil then begin
    FGlobalConfig.MainThreadConfig.ChangeNotifier.Remove(FMainThreadConfigListener);
  end;

  FGUISyncronizedTimer.Enabled := False;
  FAppClosingNotifierInternal.ExecuteOperation;
  FGCThread.Terminate;
end;

end.

