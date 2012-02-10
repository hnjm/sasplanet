unit u_MapLayerSearchResults;

interface

uses
  Windows,
  ActiveX,
  GR32,
  GR32_Image,
  i_JclNotify,
  t_GeoTypes,
  i_LocalCoordConverter,
  i_InternalPerformanceCounter,
  i_LastSearchResultConfig,
  i_BitmapMarker,
  i_ViewPortState,
  i_VectorDataItemSimple,
  i_GeoCoder,
  u_VectorDataItemPoint,
  u_HtmlToHintTextConverterStuped,
  u_MapLayerBasic;

type
  TSearchResultsLayer = class(TMapLayerBasicNoBitmap)
  private
    FLastSearchResults: ILastSearchResultConfig;
    FMarkerProvider: IBitmapMarkerProviderChangeable;
    FMarkerProviderStatic: IBitmapMarkerProvider;
    procedure OnLastSearchResultsChange;
    procedure OnConfigChange;
  protected
    procedure PaintLayer(ABuffer: TBitmap32; ALocalConverter: ILocalCoordConverter); override;
  public
    procedure StartThreads; override;
  public
    procedure MouseOnReg(xy: TPoint; out AItem: IVectorDataItemSimple; out AItemS: Double);
    constructor Create(
      APerfList: IInternalPerformanceCounterList;
      AParentMap: TImage32;
      AViewPortState: IViewPortState;
      ALastSearchResults: ILastSearchResultConfig;
      AMarkerProvider: IBitmapMarkerProviderChangeable
    );
    destructor Destroy; override;
  end;

implementation

uses
  i_CoordConverter,
  u_NotifyEventListener,
  u_GeoFun;

{ TSearchResultsLayer }

constructor TSearchResultsLayer.Create(
  APerfList: IInternalPerformanceCounterList;
  AParentMap: TImage32;
  AViewPortState: IViewPortState;
  ALastSearchResults: ILastSearchResultConfig;
  AMarkerProvider: IBitmapMarkerProviderChangeable
);
begin
  inherited Create(APerfList, AParentMap, AViewPortState);
  FLastSearchResults:=ALastSearchResults;
  FMarkerProvider := AMarkerProvider;

  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnConfigChange),
    FMarkerProvider.GetChangeNotifier
  );
  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnLastSearchResultsChange),
    FLastSearchResults.GetChangeNotifier
  );
end;

destructor TSearchResultsLayer.Destroy;
begin
  inherited;
end;

procedure TSearchResultsLayer.OnConfigChange;
begin
  ViewUpdateLock;
  try
    FMarkerProviderStatic := FMarkerProvider.GetStatic;
    SetNeedRedraw;
  finally
    ViewUpdateUnlock;
  end;
  ViewUpdate;
end;

procedure TSearchResultsLayer.OnLastSearchResultsChange;
begin
  ViewUpdateLock;
  try
    SetNeedRedraw;
    SetVisible(FLastSearchResults.IsActive);
  finally
    ViewUpdateUnlock;
  end;
  ViewUpdate;
end;

procedure TSearchResultsLayer.PaintLayer(ABuffer: TBitmap32;
  ALocalConverter: ILocalCoordConverter);
var
  VConverter: ICoordConverter;
  VEnum: IEnumUnknown;
  VPlacemark: IGeoCodePlacemark;
  VVisualConverter: ILocalCoordConverter;
  VTargetPoint: TPoint;
  VFixedOnView: TDoublePoint;
  VMarker: IBitmapMarker;
  i:integer;
  VSearchResults: IGeoCodeResult;
begin
  VVisualConverter := ViewCoordConverter;
  VConverter := VVisualConverter.GetGeoConverter;
  VMarker := FMarkerProviderStatic.GetMarker;
  VSearchResults := FLastSearchResults.GeoCodeResult;
  if VSearchResults <> nil then begin
    VEnum := VSearchResults.GetPlacemarks;
    while VEnum.Next(1, VPlacemark, @i) = S_OK do begin
      VFixedOnView :=  VVisualConverter.LonLat2LocalPixelFloat(VPlacemark.GetPoint);
      VTargetPoint :=
        PointFromDoublePoint(
          DoublePoint(
            VFixedOnView.X - VMarker.AnchorPoint.X,
            VFixedOnView.Y - VMarker.AnchorPoint.Y
          ),
          prToTopLeft
        );
      ABuffer.Draw(VTargetPoint.X, VTargetPoint.Y, VMarker.Bitmap);
    end;
  end;
end;

procedure TSearchResultsLayer.MouseOnReg(xy: TPoint; out AItem: IVectorDataItemSimple;
  out AItemS: Double);
var
  VLonLatRect: TDoubleRect;
  VRect: TRect;
  VConverter: ICoordConverter;
  VPixelPos: TDoublePoint;
  VZoom: Byte;
  VMapRect: TDoubleRect;
  VLocalConverter: ILocalCoordConverter;
  VVisualConverter: ILocalCoordConverter;
  i: integer;
  VEnum: IEnumUnknown;
  VPlacemark: IGeoCodePlacemark;
  VMarker: IBitmapMarker;
  VSearchResults: IGeoCodeResult;
begin
  AItem := nil;
  AItemS := 0;
  VSearchResults := FLastSearchResults.GeoCodeResult;
  if VSearchResults <> nil then begin
    VMarker := FMarkerProviderStatic.GetMarker;
    VRect.Left := xy.X - (VMarker.Bitmap.Width div 2);
    VRect.Top := xy.Y - (VMarker.Bitmap.Height div 2);
    VRect.Right := xy.X + (VMarker.Bitmap.Width div 2);
    VRect.Bottom := xy.Y + (VMarker.Bitmap.Height div 2);
    VLocalConverter := LayerCoordConverter;
    VConverter := VLocalConverter.GetGeoConverter;
    VZoom := VLocalConverter.GetZoom;
    VVisualConverter := ViewCoordConverter;
    VMapRect := VVisualConverter.LocalRect2MapRectFloat(VRect);
    VConverter.CheckPixelRectFloat(VMapRect, VZoom);
    VLonLatRect := VConverter.PixelRectFloat2LonLatRect(VMapRect, VZoom);
    VPixelPos := VVisualConverter.LocalPixel2MapPixelFloat(xy);
    VEnum := VSearchResults.GetPlacemarks;
    while VEnum.Next(1, VPlacemark, @i) = S_OK do begin
      if((VLonLatRect.Right>VPlacemark.GetPoint.X)and(VLonLatRect.Left<VPlacemark.GetPoint.X)and
        (VLonLatRect.Bottom<VPlacemark.GetPoint.Y)and(VLonLatRect.Top>VPlacemark.GetPoint.Y))then begin
         AItem := TVectorDataItemPoint.Create(THtmlToHintTextConverterStuped.Create,VPlacemark.GetAddress+#13#10+VPlacemark.GetDesc,VPlacemark.GetFullDesc,VPlacemark.GetPoint);
         AItemS := 0;
         exit;
      end;
    end;
  end;
end;

procedure TSearchResultsLayer.StartThreads;
begin
  inherited;
  OnLastSearchResultsChange;
  OnConfigChange;
end;

end.
