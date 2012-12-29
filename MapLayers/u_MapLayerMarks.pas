unit u_MapLayerMarks;

interface

uses
  Types,
  SysUtils,
  GR32_Image,
  i_Notifier,
  i_NotifierOperation,
  i_LocalCoordConverter,
  i_LocalCoordConverterFactorySimpe,
  i_BitmapLayerProvider,
  i_InternalPerformanceCounter,
  i_ViewPortState,
  i_UsedMarksConfig,
  i_MarksDrawConfig,
  i_MarksLayerConfig,
  i_VectorDataItemSimple,
  i_VectorItemsFactory,
  i_Bitmap32StaticFactory,
  i_ImageResamplerConfig,
  i_IdCacheSimple,
  i_FindVectorItems,
  i_MarkerDrawable,
  i_MarksSimple,
  i_MarksSystem,
  u_TiledLayerWithThreadBase;

type
  TMapLayerMarks = class(TTiledLayerWithThreadBase, IFindVectorItems)
  private
    FConfig: IMarksLayerConfig;
    FVectorItemsFactory: IVectorItemsFactory;
    FMarkDB: IMarksSystem;
    FMarkIconDefault: IMarkerDrawableChangeable;

    FGetMarksCounter: IInternalPerformanceCounter;
    FMouseOnRegCounter: IInternalPerformanceCounter;

    FProjectedCache: IIdCacheSimple;
    FMarkerCache: IIdCacheSimple;

    FMarksSubset: IMarksSubset;
    FMarksSubsetCS: IReadWriteSync;

    procedure OnConfigChange;
    procedure OnMarksDbChange;
    function GetMarksSubset(
      const AConfig: IUsedMarksConfigStatic;
      const ALocalConverter: ILocalCoordConverter
    ): IMarksSubset;
  protected
    function CreateLayerProvider(
      AOperationID: Integer;
      const ACancelNotifier: INotifierOperation;
      const ALayerConverter: ILocalCoordConverter
    ): IBitmapLayerProvider; override;
    procedure StartThreads; override;
  private
    function FindItem(
      const AVisualConverter: ILocalCoordConverter;
      const ALocalPoint: TPoint;
      out AMarkS: Double
    ): IVectorDataItemSimple;
  public
    constructor Create(
      const APerfList: IInternalPerformanceCounterList;
      const AAppStartedNotifier: INotifierOneOperation;
      const AAppClosingNotifier: INotifierOneOperation;
      AParentMap: TImage32;
      const AViewPortState: IViewPortState;
      const ATileMatrixDraftResamplerConfig: IImageResamplerConfig;
      const AConverterFactory: ILocalCoordConverterFactorySimpe;
      const AVectorItemsFactory: IVectorItemsFactory;
      const AMarkIconDefault: IMarkerDrawableChangeable;
      const ATimerNoifier: INotifier;
      const ABitmapFactory: IBitmap32StaticFactory;
      const AConfig: IMarksLayerConfig;
      const AMarkDB: IMarksSystem
    );
  end;

implementation

uses
  ActiveX,
  Classes,
  t_GeoTypes,
  i_CoordConverter,
  i_TileMatrix,
  i_VectorItemProjected,
  i_MarkerProviderForVectorItem,
  u_TileMatrixFactory,
  u_ListenerByEvent,
  u_IdCacheSimpleThreadSafe,
  u_Synchronizer,
  u_MarkerProviderForVectorItemWithCache,
  u_MarkerProviderForVectorItemForMarkPoints,
  u_BitmapLayerProviderByMarksSubset;

{ TMapMarksLayerNew }

constructor TMapLayerMarks.Create(
  const APerfList: IInternalPerformanceCounterList;
  const AAppStartedNotifier, AAppClosingNotifier: INotifierOneOperation;
  AParentMap: TImage32;
  const AViewPortState: IViewPortState;
  const ATileMatrixDraftResamplerConfig: IImageResamplerConfig;
  const AConverterFactory: ILocalCoordConverterFactorySimpe;
  const AVectorItemsFactory: IVectorItemsFactory;
  const AMarkIconDefault: IMarkerDrawableChangeable;
  const ATimerNoifier: INotifier;
  const ABitmapFactory: IBitmap32StaticFactory;
  const AConfig: IMarksLayerConfig;
  const AMarkDB: IMarksSystem
);
var
  VTileMatrixFactory: ITileMatrixFactory;
begin
  VTileMatrixFactory :=
    TTileMatrixFactory.Create(
      ATileMatrixDraftResamplerConfig,
      ABitmapFactory,
      AConverterFactory
    );
  inherited Create(
    APerfList,
    AAppStartedNotifier,
    AAppClosingNotifier,
    AParentMap,
    AViewPortState.Position,
    AViewPortState.View,
    VTileMatrixFactory,
    ATimerNoifier,
    True,
    AConfig.ThreadConfig
  );
  FConfig := AConfig;
  FMarkDB := AMarkDB;
  FVectorItemsFactory := AVectorItemsFactory;
  FMarkIconDefault := AMarkIconDefault;


  FProjectedCache := TIdCacheSimpleThreadSafe.Create;
  FMarkerCache := TIdCacheSimpleThreadSafe.Create;

  FMarksSubsetCS := MakeSyncRW_Var(Self);
  FGetMarksCounter := PerfList.CreateAndAddNewCounter('GetMarks');
  FMouseOnRegCounter := PerfList.CreateAndAddNewCounter('MouseOnReg');

  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnConfigChange),
    FConfig.MarksShowConfig.GetChangeNotifier
  );
  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnConfigChange),
    FConfig.MarksDrawConfig.GetChangeNotifier
  );
  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnMarksDbChange),
    FMarkDB.MarksDb.ChangeNotifier
  );
  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnMarksDbChange),
    FMarkDB.CategoryDB.ChangeNotifier
  );
end;

function TMapLayerMarks.CreateLayerProvider(
  AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  const ALayerConverter: ILocalCoordConverter
): IBitmapLayerProvider;
var
  VCounterContext: TInternalPerformanceCounterContext;
  VMarksSubset: IMarksSubset;
  VMapRect: TDoubleRect;
  VLinesClipRect: TDoubleRect;
  VMarksDrawConfig: IMarksDrawConfigStatic;
  VMarkerProvider: IMarkerProviderForVectorItem;
begin
  Result := nil;
  VCounterContext := FGetMarksCounter.StartOperation;
  try
    VMarksSubset := GetMarksSubset(FConfig.MarksShowConfig.GetStatic, ALayerConverter);
    FMarksSubsetCS.BeginWrite;
    try
      FMarksSubset := VMarksSubset;
    finally
      FMarksSubsetCS.EndWrite;
    end;
  finally
    FGetMarksCounter.FinishOperation(VCounterContext);
  end;
  FProjectedCache.Clear;
  FMarkerCache.Clear;
  if (VMarksSubset <> nil) and (not VMarksSubset.IsEmpty) then begin
    VMapRect := ALayerConverter.GetRectInMapPixelFloat;
    VLinesClipRect.Left := VMapRect.Left - 10;
    VLinesClipRect.Top := VMapRect.Top - 10;
    VLinesClipRect.Right := VMapRect.Right + 10;
    VLinesClipRect.Bottom := VMapRect.Bottom + 10;
    VMarksDrawConfig := FConfig.MarksDrawConfig.GetStatic;
    VMarkerProvider :=
      TMarkerProviderForVectorItemWithCache.Create(
        FMarkerCache,
        TMarkerProviderForVectorItemForMarkPoints.Create(FMarkIconDefault, VMarksDrawConfig)
      );
    Result :=
      TBitmapLayerProviderByMarksSubset.Create(
        VMarksDrawConfig,
        FVectorItemsFactory,
        ALayerConverter.ProjectionInfo,
        FProjectedCache,
        VMarkerProvider,
        VLinesClipRect,
        VMarksSubset
      );
  end;
end;

function TMapLayerMarks.FindItem(
  const AVisualConverter: ILocalCoordConverter; const ALocalPoint: TPoint;
  out AMarkS: Double): IVectorDataItemSimple;
var
  VLonLatRect: TDoubleRect;
  VRect: TRect;
  VConverter: ICoordConverter;
  VPixelPos: TDoublePoint;
  VZoom: Byte;
  VMark: IMark;
  VMapRect: TDoubleRect;
  VLocalConverter: ILocalCoordConverter;
  VMarksSubset: IMarksSubset;
  VMarksEnum: IEnumUnknown;
  VSquare: Double;
  i: Cardinal;
  VCounterContext: TInternalPerformanceCounterContext;
  VMarkLine: IMarkLine;
  VMarkPoly: IMarkPoly;
  VProjectdPath: IProjectedPath;
  VProjectdPolygon: IProjectedPolygon;
begin
  Result := nil;
  VCounterContext := FMouseOnRegCounter.StartOperation;
  try
    AMarkS := 0;

    FMarksSubsetCS.BeginRead;
    try
      VMarksSubset := FMarksSubset;
    finally
      FMarksSubsetCS.EndRead;
    end;

    if VMarksSubset <> nil then begin
      if not VMarksSubset.IsEmpty then begin
        VRect.Left := ALocalPoint.X - 8;
        VRect.Top := ALocalPoint.Y - 16;
        VRect.Right := ALocalPoint.X + 8;
        VRect.Bottom := ALocalPoint.Y + 16;
        VLocalConverter := TileMatrix.LocalConverter;
        VConverter := VLocalConverter.GetGeoConverter;
        VZoom := VLocalConverter.GetZoom;
        VMapRect := AVisualConverter.LocalRect2MapRectFloat(VRect);
        VConverter.CheckPixelRectFloat(VMapRect, VZoom);
        VLonLatRect := VConverter.PixelRectFloat2LonLatRect(VMapRect, VZoom);
        VPixelPos := AVisualConverter.LocalPixel2MapPixelFloat(ALocalPoint);
        VMarksEnum := VMarksSubset.GetEnum;
        while VMarksEnum.Next(1, VMark, @i) = S_OK do begin
          if VMark.LLRect.IsIntersecWithRect(VLonLatRect) then begin
            if Supports(VMark, IMarkPoint) then begin
              Result := VMark;
              AMarkS := 0;
              exit;
            end else begin
              if Supports(VMark, IMarkLine, VMarkLine) then begin
                if Supports(FProjectedCache.GetByID(Integer(VMarkLine)), IProjectedPath, VProjectdPath) then begin
                  if VProjectdPath.IsPointOnPath(VPixelPos, 2) then begin
                    Result := VMark;
                    AMarkS := 0;
                    exit;
                  end;
                end;
              end else if Supports(VMark, IMarkPoly, VMarkPoly) then begin
                if Supports(FProjectedCache.GetByID(Integer(VMarkPoly)), IProjectedPolygon, VProjectdPolygon) then begin
                  if VProjectdPolygon.IsPointInPolygon(VPixelPos) or
                    VProjectdPolygon.IsPointOnBorder(VPixelPos, (VMarkPoly.LineWidth / 2) + 3) then begin
                    VSquare := VProjectdPolygon.CalcArea;
                    if (Result = nil) or (VSquare < AMarkS) then begin
                      Result := VMark;
                      AMarkS := VSquare;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    FMouseOnRegCounter.FinishOperation(VCounterContext);
  end;
end;

function TMapLayerMarks.GetMarksSubset(
  const AConfig: IUsedMarksConfigStatic;
  const ALocalConverter: ILocalCoordConverter
): IMarksSubset;
var
  VList: IInterfaceList;
  VZoom: Byte;
  VMapPixelRect: TDoubleRect;
  VLonLatRect: TDoubleRect;
  VGeoConverter: ICoordConverter;
begin
  VList := nil;
  Result := nil;
  if AConfig.IsUseMarks then begin
    VZoom := ALocalConverter.GetZoom;
    if not AConfig.IgnoreCategoriesVisible then begin
      VList := FMarkDB.GetVisibleCategories(VZoom);
    end;
    try
      if (VList <> nil) and (VList.Count = 0) then begin
        Result := nil;
      end else begin
        VGeoConverter := ALocalConverter.GetGeoConverter;
        VMapPixelRect := ALocalConverter.GetRectInMapPixelFloat;
        VGeoConverter.CheckPixelRectFloat(VMapPixelRect, VZoom);
        VLonLatRect := VGeoConverter.PixelRectFloat2LonLatRect(VMapPixelRect, VZoom);
        Result := FMarkDB.MarksDb.GetMarksSubset(VLonLatRect, VList, AConfig.IgnoreMarksVisible);
      end;
    finally
      VList := nil;
    end;
  end;
end;

procedure TMapLayerMarks.OnConfigChange;
begin
  ViewUpdateLock;
  try
    Visible := FConfig.MarksShowConfig.IsUseMarks;
    SetNeedUpdateLayerProvider;
  finally
    ViewUpdateUnlock;
  end;
end;

procedure TMapLayerMarks.OnMarksDbChange;
begin
  if Visible then begin
    ViewUpdateLock;
    try
      SetNeedUpdateLayerProvider;
    finally
      ViewUpdateUnlock;
    end;
  end;
end;

procedure TMapLayerMarks.StartThreads;
begin
  inherited;
  OnConfigChange;
end;

end.
