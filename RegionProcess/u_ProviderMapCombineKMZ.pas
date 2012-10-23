unit u_ProviderMapCombineKMZ;

interface

uses
  GR32,
  i_Notifier,
  i_NotifierOperation,
  i_LanguageManager,
  i_LocalCoordConverter,
  i_CoordConverterFactory,
  i_CoordConverterList,
  i_BitmapLayerProvider,
  i_VectorItemProjected,
  i_VectorItemLonLat,
  i_RegionProcessProgressInfo,
  i_ArchiveReadWriteFactory,
  i_MapTypes,
  i_UseTilePrevZoomConfig,
  i_ActiveMapsConfig,
  i_MapTypeGUIConfigList,
  i_BitmapTileSaveLoadFactory,
  i_LocalCoordConverterFactorySimpe,
  i_BitmapPostProcessingConfig,
  i_UsedMarksConfig,
  i_MarksDrawConfig,
  i_MarksSystem,
  i_MapCalibration,
  i_VectorItmesFactory,
  i_GlobalViewMainConfig,
  u_ExportProviderAbstract,
  u_ProviderMapCombine;

type
  TProviderMapCombineKMZ = class(TProviderMapCombineBase)
  private
    FBitmapTileSaveLoadFactory: IBitmapTileSaveLoadFactory;
    FArchiveReadWriteFactory: IArchiveReadWriteFactory;
  public
    constructor Create(
      const ALanguageManager: ILanguageManager;
      const AMainMapsConfig: IMainMapsConfig;
      const AFullMapsSet: IMapTypeSet;
      const AGUIConfigList: IMapTypeGUIConfigList;
      const AViewConfig: IGlobalViewMainConfig;
      const AUseTilePrevZoomConfig: IUseTilePrevZoomConfig;
      const AAppClosingNotifier: INotifierOneOperation;
      const ATimerNoifier: INotifier;
      const AProjectionFactory: IProjectionInfoFactory;
      const ACoordConverterList: ICoordConverterList;
      const AVectorItmesFactory: IVectorItmesFactory;
      const ABitmapTileSaveLoadFactory: IBitmapTileSaveLoadFactory;
      const AArchiveReadWriteFactory: IArchiveReadWriteFactory;
      const AMarksShowConfig: IUsedMarksConfig;
      const AMarksDrawConfig: IMarksDrawConfig;
      const AMarksDB: IMarksSystem;
      const ALocalConverterFactory: ILocalCoordConverterFactorySimpe;
      const ABitmapPostProcessingConfig: IBitmapPostProcessingConfig;
      const AMapCalibrationList: IMapCalibrationList
    );
    procedure StartProcess(const APolygon: ILonLatPolygon); override;
  end;

implementation

uses
  Dialogs,
  gnugettext,
  i_RegionProcessParamsFrame,
  u_ThreadMapCombineKMZ,
  u_ResStrings,
  fr_MapCombine;

{ TProviderMapCombineKMZ }

constructor TProviderMapCombineKMZ.Create(
  const ALanguageManager: ILanguageManager;
  const AMainMapsConfig: IMainMapsConfig; const AFullMapsSet: IMapTypeSet;
  const AGUIConfigList: IMapTypeGUIConfigList;
  const AViewConfig: IGlobalViewMainConfig;
  const AUseTilePrevZoomConfig: IUseTilePrevZoomConfig;
  const AAppClosingNotifier: INotifierOneOperation;
  const ATimerNoifier: INotifier;
  const AProjectionFactory: IProjectionInfoFactory;
  const ACoordConverterList: ICoordConverterList;
  const AVectorItmesFactory: IVectorItmesFactory;
  const ABitmapTileSaveLoadFactory: IBitmapTileSaveLoadFactory;
  const AArchiveReadWriteFactory: IArchiveReadWriteFactory;
  const AMarksShowConfig: IUsedMarksConfig;
  const AMarksDrawConfig: IMarksDrawConfig; const AMarksDB: IMarksSystem;
  const ALocalConverterFactory: ILocalCoordConverterFactorySimpe;
  const ABitmapPostProcessingConfig: IBitmapPostProcessingConfig;
  const AMapCalibrationList: IMapCalibrationList);
begin
  inherited Create(
      ALanguageManager,
      AMainMapsConfig,
      AFullMapsSet,
      AGUIConfigList,
      AViewConfig,
      AUseTilePrevZoomConfig,
      AAppClosingNotifier,
      ATimerNoifier,
      AProjectionFactory,
      ACoordConverterList,
      AVectorItmesFactory,
      AMarksShowConfig,
      AMarksDrawConfig,
      AMarksDB,
      ALocalConverterFactory,
      ABitmapPostProcessingConfig,
      AMapCalibrationList,
      True,
      False,
      'kmz',
      gettext_NoExtract('KMZ for Garmin')
  );
  FBitmapTileSaveLoadFactory := ABitmapTileSaveLoadFactory;
  FArchiveReadWriteFactory := AArchiveReadWriteFactory;
end;

procedure TProviderMapCombineKMZ.StartProcess(const APolygon: ILonLatPolygon);
var
  VMapCalibrations: IMapCalibrationList;
  VFileName: string;
  VSplitCount: TPoint;
  VProjectedPolygon: IProjectedPolygon;
  VTargetConverter: ILocalCoordConverter;
  VImageProvider: IBitmapLayerProvider;
  VCancelNotifier: INotifierOperation;
  VOperationID: Integer;
  VProgressInfo: IRegionProcessProgressInfoInternal;
  VMapSize: TPoint;
  VMapPieceSize: TPoint;
  VKmzImgesCount: TPoint;
begin
  VProjectedPolygon := PreparePolygon(APolygon);
  VTargetConverter := PrepareTargetConverter(VProjectedPolygon);
  VImageProvider := PrepareImageProvider(APolygon, VProjectedPolygon);
  VMapCalibrations := (ParamsFrame as IRegionProcessParamsFrameMapCalibrationList).MapCalibrationList;
  VFileName := PrepareTargetFileName;
  VSplitCount := (ParamsFrame as IRegionProcessParamsFrameMapCombine).SplitCount;

  VMapSize := VTargetConverter.GetLocalRectSize;
  VMapPieceSize.X := VMapSize.X div VSplitCount.X;
  VMapPieceSize.Y := VMapSize.Y div VSplitCount.Y;
  VKmzImgesCount.X := ((VMapPieceSize.X - 1) div 1024) + 1;
  VKmzImgesCount.Y := ((VMapPieceSize.Y - 1) div 1024) + 1;
  if ((VKmzImgesCount.X * VKmzImgesCount.Y) > 100) then begin
    ShowMessage(SAS_MSG_GarminMax1Mp);
  end;

  PrepareProcessInfo(VCancelNotifier, VOperationID, VProgressInfo);
  TThreadMapCombineKMZ.Create(
    VCancelNotifier,
    VOperationID,
    VProgressInfo,
    APolygon,
    VTargetConverter,
    VImageProvider,
    LocalConverterFactory,
    VMapCalibrations,
    VFileName,
    VSplitCount,
    FBitmapTileSaveLoadFactory,
    FArchiveReadWriteFactory,
    (ParamsFrame as IRegionProcessParamsFrameMapCombineJpg).Quality
  );
end;

end.

