unit u_MiniMapLayer;

interface

uses
  GR32_Image,
  i_Notifier,
  i_NotifierTime,
  i_NotifierOperation,
  i_TileError,
  i_BitmapPostProcessing,
  i_LocalCoordConverter,
  i_LocalCoordConverterChangeable,
  i_LocalCoordConverterFactorySimpe,
  i_BitmapLayerProvider,
  i_UseTilePrevZoomConfig,
  i_ThreadConfig,
  i_MapTypes,
  i_MapTypeListChangeable,
  i_Bitmap32StaticFactory,
  i_InternalPerformanceCounter,
  i_MiniMapLayerConfig,
  i_ImageResamplerConfig,
  u_TiledLayerWithThreadBase;

type
  TMiniMapLayer = class(TTiledLayerWithThreadBase)
  public
    constructor Create(
      const APerfList: IInternalPerformanceCounterList;
      const AAppStartedNotifier: INotifierOneOperation;
      const AAppClosingNotifier: INotifierOneOperation;
      AParentMap: TImage32;
      const APosition: ILocalCoordConverterChangeable;
      const AView: ILocalCoordConverterChangeable;
      const ATileMatrixDraftResamplerConfig: IImageResamplerConfig;
      const AConverterFactory: ILocalCoordConverterFactorySimpe;
      const AConfig: IMiniMapLayerConfig;
      const AMainMap: IMapTypeChangeable;
      const ALayesList: IMapTypeListChangeable;
      const APostProcessing: IBitmapPostProcessingChangeable;
      const AUseTilePrevZoomConfig: IUseTilePrevZoomConfig;
      const AThreadConfig: IThreadConfig;
      const ABitmapFactory: IBitmap32StaticFactory;
      const AErrorLogger: ITileErrorLogger;
      const ATimerNoifier: INotifierTime
    );
  end;

implementation

uses
  i_TileMatrix,
  i_MapTypeListStatic,
  i_BitmapLayerProviderChangeable,
  u_TileMatrixFactory,
  u_ListenerByEvent,
  u_BitmapLayerProviderChangeableForMainLayer;

{ TMapMainLayer }

constructor TMiniMapLayer.Create(
  const APerfList: IInternalPerformanceCounterList;
  const AAppStartedNotifier: INotifierOneOperation;
  const AAppClosingNotifier: INotifierOneOperation;
  AParentMap: TImage32;
  const APosition: ILocalCoordConverterChangeable;
  const AView: ILocalCoordConverterChangeable;
  const ATileMatrixDraftResamplerConfig: IImageResamplerConfig;
  const AConverterFactory: ILocalCoordConverterFactorySimpe;
  const AConfig: IMiniMapLayerConfig;
  const AMainMap: IMapTypeChangeable;
  const ALayesList: IMapTypeListChangeable;
  const APostProcessing: IBitmapPostProcessingChangeable;
  const AUseTilePrevZoomConfig: IUseTilePrevZoomConfig;
  const AThreadConfig: IThreadConfig;
  const ABitmapFactory: IBitmap32StaticFactory;
  const AErrorLogger: ITileErrorLogger;
  const ATimerNoifier: INotifierTime
);
var
  VTileMatrixFactory: ITileMatrixFactory;
  VProvider: IBitmapLayerProviderChangeable;
begin
  VTileMatrixFactory :=
    TTileMatrixFactory.Create(
      ATileMatrixDraftResamplerConfig,
      ABitmapFactory,
      AConverterFactory
    );
  VProvider :=
    TBitmapLayerProviderChangeableForMainLayer.Create(
      AMainMap,
      ALayesList,
      APostProcessing,
      AConfig.UseTilePrevZoomConfig,
      ABitmapFactory,
      AErrorLogger
    );
  inherited Create(
    APerfList,
    AAppStartedNotifier,
    AAppClosingNotifier,
    AParentMap,
    APosition,
    AView,
    VTileMatrixFactory,
    VProvider,
    nil,
    ATimerNoifier,
    AThreadConfig
  );
end;

end.
