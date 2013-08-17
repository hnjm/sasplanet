unit u_MapLayerSearchResults;

interface

uses
  Windows,
  ActiveX,
  GR32,
  GR32_Image,
  t_GeoTypes,
  i_Notifier,
  i_NotifierOperation,
  i_LocalCoordConverter,
  i_LocalCoordConverterChangeable,
  i_InternalPerformanceCounter,
  i_LastSearchResultConfig,
  i_MarkerDrawable,
  i_VectorDataItemSimple,
  i_VectorItemSubsetBuilder,
  i_FindVectorItems,
  i_GeoCoder,
  i_VectorItemSubset,
  u_MapLayerBasic;

type
  TSearchResultsLayer = class(TMapLayerBasicNoBitmap, IFindVectorItems)
  private
    FLastSearchResults: ILastSearchResultConfig;
    FVectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory;
    FMarker: IMarkerDrawableChangeable;
    procedure OnLastSearchResultsChange;
    procedure OnConfigChange;
  protected
    procedure PaintLayer(
      ABuffer: TBitmap32;
      const ALocalConverter: ILocalCoordConverter
    ); override;
    procedure StartThreads; override;
  private
    function FindItems(
      const AVisualConverter: ILocalCoordConverter;
      const ALocalPoint: TPoint
    ): IVectorItemSubset;
  public
    constructor Create(
      const APerfList: IInternalPerformanceCounterList;
      const AAppStartedNotifier: INotifierOneOperation;
      const AAppClosingNotifier: INotifierOneOperation;
      AParentMap: TImage32;
      const AView: ILocalCoordConverterChangeable;
      const AVectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory;
      const ALastSearchResults: ILastSearchResultConfig;
      const AMarker: IMarkerDrawableChangeable
    );
  end;

implementation

uses
  SysUtils,
  c_InternalBrowser,
  i_CoordConverter,
  u_ListenerByEvent,
  u_GeoCodePlacemarkWithUrlDecorator,
  u_GeoFun;

{ TSearchResultsLayer }

constructor TSearchResultsLayer.Create(
  const APerfList: IInternalPerformanceCounterList;
  const AAppStartedNotifier: INotifierOneOperation;
  const AAppClosingNotifier: INotifierOneOperation;
  AParentMap: TImage32;
  const AView: ILocalCoordConverterChangeable;
  const AVectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory;
  const ALastSearchResults: ILastSearchResultConfig;
  const AMarker: IMarkerDrawableChangeable
);
begin
  inherited Create(
    APerfList,
    AAppStartedNotifier,
    AAppClosingNotifier,
    AParentMap,
    AView
  );
  FLastSearchResults := ALastSearchResults;
  FMarker := AMarker;
  FVectorItemSubsetBuilderFactory := AVectorItemSubsetBuilderFactory;

  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnConfigChange),
    FMarker.GetChangeNotifier
  );
  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnLastSearchResultsChange),
    FLastSearchResults.GetChangeNotifier
  );
end;

procedure TSearchResultsLayer.OnConfigChange;
begin
  ViewUpdateLock;
  try
    SetNeedRedraw;
  finally
    ViewUpdateUnlock;
  end;
end;

procedure TSearchResultsLayer.OnLastSearchResultsChange;
begin
  ViewUpdateLock;
  try
    SetNeedRedraw;
    Visible := FLastSearchResults.IsActive;
  finally
    ViewUpdateUnlock;
  end;
end;

procedure TSearchResultsLayer.PaintLayer(
  ABuffer: TBitmap32;
  const ALocalConverter: ILocalCoordConverter
);
var
  VConverter: ICoordConverter;
  VEnum: IEnumUnknown;
  VPlacemark: IGeoCodePlacemark;
  VFixedOnView: TDoublePoint;
  VMarker: IMarkerDrawable;
  i: integer;
  VSearchResults: IGeoCodeResult;
begin
  VSearchResults := FLastSearchResults.GeoCodeResult;
  if VSearchResults <> nil then begin
    VMarker := FMarker.GetStatic;
    VConverter := ALocalConverter.GetGeoConverter;
    VEnum := VSearchResults.GetPlacemarks;
    while VEnum.Next(1, VPlacemark, @i) = S_OK do begin
      VFixedOnView := ALocalConverter.LonLat2LocalPixelFloat(VPlacemark.GetPoint);
      VMarker.DrawToBitmap(ABuffer, VFixedOnView);
    end;
  end;
end;

function TSearchResultsLayer.FindItems(
  const AVisualConverter: ILocalCoordConverter;
  const ALocalPoint: TPoint
): IVectorItemSubset;
var
  VLonLatRect: TDoubleRect;
  VRect: TRect;
  VConverter: ICoordConverter;
  VPixelPos: TDoublePoint;
  VZoom: Byte;
  VMapRect: TDoubleRect;
  i: integer;
  VEnum: IEnumUnknown;
  VPlacemark: IGeoCodePlacemark;
  VSearchResults: IGeoCodeResult;
  VIndex: Integer;
  Vtmp: IVectorItemSubsetBuilder;
  VTempItem: IGeoCodePlacemark;
begin
  Result := nil;
  Vtmp := FVectorItemSubsetBuilderFactory.Build;
  VSearchResults := FLastSearchResults.GeoCodeResult;
  if VSearchResults <> nil then begin
    VRect.Left := ALocalPoint.X - 5;
    VRect.Top := ALocalPoint.Y - 5;
    VRect.Right := ALocalPoint.X + 5;
    VRect.Bottom := ALocalPoint.Y + 5;
    VConverter := AVisualConverter.GetGeoConverter;
    VZoom := AVisualConverter.GetZoom;
    VMapRect := AVisualConverter.LocalRect2MapRectFloat(VRect);
    VConverter.CheckPixelRectFloat(VMapRect, VZoom);
    VLonLatRect := VConverter.PixelRectFloat2LonLatRect(VMapRect, VZoom);
    VPixelPos := AVisualConverter.LocalPixel2MapPixelFloat(ALocalPoint);
    VIndex := 0;
    VEnum := VSearchResults.GetPlacemarks;
    while VEnum.Next(1, VPlacemark, @i) = S_OK do begin
      if LonLatPointInRect(VPlacemark.GetPoint, VLonLatRect) then begin
        VTempItem := TGeoCodePlacemarkWithUrlDecorator.Create(
            VPlacemark,
            CLastSearchResultsInternalURL + IntToStr(VIndex) + '/'
          );
        Vtmp.add(VTempItem);
      end;
      Inc(VIndex);
    end;
  end;
  Result := Vtmp.MakeStaticAndClear;
end;

procedure TSearchResultsLayer.StartThreads;
begin
  inherited;
  OnLastSearchResultsChange;
  OnConfigChange;
end;

end.
