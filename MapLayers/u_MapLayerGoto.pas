unit u_MapLayerGoto;

interface

uses
  GR32,
  GR32_Image,
  t_GeoTypes,
  i_InternalPerformanceCounter,
  i_BitmapMarker,
  i_ViewPortState,
  i_MapViewGoto,
  i_LocalCoordConverter,
  i_GotoLayerConfig,
  u_MapLayerBasic;

type
  TGotoLayer = class(TMapLayerBasicNoBitmap)
  private
    FConfig: IGotoLayerConfig;
    FMapGoto: IMapViewGoto;


    FMarkerProvider: IBitmapMarkerProviderChangeable;
    FMarkerProviderStatic: IBitmapMarkerProvider;
    FMarker: IBitmapMarker;

    FGotoPos: IGotoPosStatic;
    FShowTimeDelta: TDateTime;

    procedure OnConfigChange;
  protected
    function GetVisibleForNewPos(ANewVisualCoordConverter: ILocalCoordConverter): Boolean; override;
    procedure PaintLayer(ABuffer: TBitmap32; ALocalConverter: ILocalCoordConverter); override;
  public
    procedure StartThreads; override;
  public
    constructor Create(
      APerfList: IInternalPerformanceCounterList;
      AParentMap: TImage32;
      AViewPortState: IViewPortState;
      AMarkerProvider: IBitmapMarkerProviderChangeable;
      AMapGoto: IMapViewGoto;
      AConfig: IGotoLayerConfig
    );
  end;



implementation

uses
  Types,
  Math,
  SysUtils,
  i_JclNotify,
  i_CoordConverter,
  u_NotifyEventListener,
  u_GeoFun;

{ TGotoLayer }

constructor TGotoLayer.Create(
  APerfList: IInternalPerformanceCounterList;
  AParentMap: TImage32;
  AViewPortState: IViewPortState;
  AMarkerProvider: IBitmapMarkerProviderChangeable;
  AMapGoto: IMapViewGoto;
  AConfig: IGotoLayerConfig
);
var
  VListener: IJclListener;
begin
  inherited Create(APerfList, AParentMap, AViewPortState);
  FConfig := AConfig;
  FMarkerProvider := AMarkerProvider;
  FMapGoto := AMapGoto;

  VListener := TNotifyNoMmgEventListener.Create(Self.OnConfigChange);
  LinksList.Add(
    VListener,
    FConfig.GetChangeNotifier
  );

  LinksList.Add(
    VListener,
    FMarkerProvider.GetChangeNotifier
  );

  LinksList.Add(
    VListener,
    FMapGoto.GetChangeNotifier
  );
end;

function TGotoLayer.GetVisibleForNewPos(
  ANewVisualCoordConverter: ILocalCoordConverter): Boolean;
var
  VCurrTime: TDateTime;
  VGotoTime: TDateTime;
  VTimeDelta: Double;
  VGotoPos: IGotoPosStatic;
  VGotoLonLat: TDoublePoint;
  VFixedOnView: TDoublePoint;
begin
  VGotoPos := FGotoPos;
  Result :=  False;
  if VGotoPos <> nil then begin
    VGotoTime := VGotoPos.GotoTime;
    if not IsNan(VGotoTime) then begin
      VGotoLonLat := VGotoPos.LonLat;
      if not PointIsEmpty(VGotoLonLat) then begin
        VCurrTime := Now;
        if (VGotoTime <= VCurrTime) then begin
          VTimeDelta := VCurrTime - VGotoTime;
          if (VTimeDelta < FShowTimeDelta) then begin
            VFixedOnView :=  ANewVisualCoordConverter.LonLat2LocalPixelFloat(VGotoLonLat);
            if PixelPointInRect(VFixedOnView, DoubleRect(ANewVisualCoordConverter.GetLocalRect)) then begin
              Result := True;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TGotoLayer.OnConfigChange;
var
  VMarker: IBitmapMarker;
begin
  FGotoPos := FMapGoto.LastGotoPos;
  FMarkerProviderStatic := FMarkerProvider.GetStatic;
  VMarker := FMarkerProviderStatic.GetMarker;
  FMarker := VMarker;
  ViewUpdateLock;
  try
    FShowTimeDelta := (FConfig.ShowTickCount / 1000) / 60 / 60 / 24;
    SetVisible(GetVisibleForNewPos(LayerCoordConverter));
    SetNeedRedraw;
  finally
    ViewUpdateUnlock;
  end;
  ViewUpdate;
end;

procedure TGotoLayer.PaintLayer(ABuffer: TBitmap32;
  ALocalConverter: ILocalCoordConverter);
var
  VConverter: ICoordConverter;
  VVisualConverter: ILocalCoordConverter;
  VGotoPos: IGotoPosStatic;
  VMarker: IBitmapMarker;
  VGotoLonLat: TDoublePoint;
  VFixedOnView: TDoublePoint;
  VTargetPoint: TPoint;
begin
  inherited;
  VGotoPos := FGotoPos;
  VVisualConverter := ViewCoordConverter;
  VGotoLonLat := VGotoPos.LonLat;
  if not PointIsEmpty(VGotoLonLat) then begin
    VConverter := VVisualConverter.GetGeoConverter;
    VMarker := FMarker;
    VFixedOnView :=  VVisualConverter.LonLat2LocalPixelFloat(VGotoLonLat);
    VTargetPoint :=
      PointFromDoublePoint(
        DoublePoint(
          VFixedOnView.X - VMarker.AnchorPoint.X,
          VFixedOnView.Y - VMarker.AnchorPoint.Y
        )
      );
    if PtInRect(ALocalConverter.GetLocalRect, VTargetPoint) then begin
      ABuffer.Draw(VTargetPoint.X, VTargetPoint.Y, VMarker.Bitmap);
    end;
  end;
end;

procedure TGotoLayer.StartThreads;
begin
  inherited;
  OnConfigChange;
end;

end.
