unit u_MapLayerGPSMarker;

interface

uses
  Windows,
  
  GR32,
  GR32_Image,
  i_JclNotify,
  t_GeoTypes,
  i_LocalCoordConverter,
  i_InternalPerformanceCounter,
  i_MapLayerGPSMarkerConfig,
  i_GPSRecorder,
  i_BitmapMarker,
  i_ViewPortState,
  u_MapLayerBasic;


type
  TMapLayerGPSMarker = class(TMapLayerBasicNoBitmap)
  private
    FConfig: IMapLayerGPSMarkerConfig;
    FGPSRecorder: IGPSRecorder;
    FMovedMarkerProvider: IBitmapMarkerProviderChangeable;
    FMovedMarkerProviderStatic: IBitmapMarkerProvider;
    FStopedMarkerProvider: IBitmapMarkerProviderChangeable;
    FStopedMarkerProviderStatic: IBitmapMarkerProvider;

    FGpsPosChangeCounter: Integer;
    FStopedMarker: IBitmapMarker;
    FMarker: IBitmapMarker;

    FFixedLonLat: TDoublePoint;

    procedure GPSReceiverReceive;
    procedure OnConfigChange;
    procedure OnTimer;
    procedure PrepareMarker(ASpeed, AAngle: Double; AForceStopped: Boolean);
  protected
    procedure PaintLayer(ABuffer: TBitmap32; ALocalConverter: ILocalCoordConverter); override;
  public
    procedure StartThreads; override;
  public
    constructor Create(
      APerfList: IInternalPerformanceCounterList;
      AParentMap: TImage32;
      AViewPortState: IViewPortState;
      ATimerNoifier: IJclNotifier;
      AConfig: IMapLayerGPSMarkerConfig;
      AMovedMarkerProvider: IBitmapMarkerProviderChangeable;
      AStopedMarkerProvider: IBitmapMarkerProviderChangeable;
      AGPSRecorder: IGPSRecorder
    );
  end;

implementation

uses
  SysUtils,
  u_GeoFun,
  i_GPS,
  vsagps_public_base,
  vsagps_public_position,
  u_NotifyEventListener;

{ TMapLayerGPSMarker }

constructor TMapLayerGPSMarker.Create(
  APerfList: IInternalPerformanceCounterList;
  AParentMap: TImage32;
  AViewPortState: IViewPortState;
  ATimerNoifier: IJclNotifier;
  AConfig: IMapLayerGPSMarkerConfig;
  AMovedMarkerProvider: IBitmapMarkerProviderChangeable;
  AStopedMarkerProvider: IBitmapMarkerProviderChangeable;
  AGPSRecorder: IGPSRecorder
);
begin
  inherited Create(APerfList, AParentMap, AViewPortState);
  FConfig := AConfig;
  FGPSRecorder := AGPSRecorder;
  FMovedMarkerProvider := AMovedMarkerProvider;
  FStopedMarkerProvider := AStopedMarkerProvider;

  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnTimer),
    ATimerNoifier
  );
  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnConfigChange),
    FConfig.GetChangeNotifier
  );
  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnConfigChange),
    FMovedMarkerProvider.GetChangeNotifier
  );
  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnConfigChange),
    FStopedMarkerProvider.GetChangeNotifier
  );
  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.GPSReceiverReceive),
    FGPSRecorder.GetChangeNotifier
  );

  FGpsPosChangeCounter := 0;
end;

procedure TMapLayerGPSMarker.GPSReceiverReceive;
begin
  InterlockedIncrement(FGpsPosChangeCounter);
end;

procedure TMapLayerGPSMarker.OnConfigChange;
begin
  FMovedMarkerProviderStatic := FMovedMarkerProvider.GetStatic;
  FStopedMarkerProviderStatic := FStopedMarkerProvider.GetStatic;
  FStopedMarker := FStopedMarkerProviderStatic.GetMarker;
  GPSReceiverReceive;
end;

procedure TMapLayerGPSMarker.OnTimer;
var
  VGPSPosition: IGPSPosition;
  VpPos: PSingleGPSData;
  VForceStoppedMarker: Boolean;  
begin
  if InterlockedExchange(FGpsPosChangeCounter, 0) > 0 then begin
    ViewUpdateLock;
    try
      VGPSPosition := FGPSRecorder.CurrentPosition;
      VpPos := VGPSPosition.GetPosParams;
      if (not VpPos^.PositionOK) then begin
        // no position
        Hide;
      end else begin
        // ok
        FFixedLonLat.X := VpPos^.PositionLon;
        FFixedLonLat.Y := VpPos^.PositionLat;
        VForceStoppedMarker:=((not VpPos^.AllowCalcStats) or NoData_Float64(VpPos^.Speed_KMH) or NoData_Float64(VpPos^.Heading));
        PrepareMarker(VpPos^.Speed_KMH, VpPos^.Heading, VForceStoppedMarker);
        Show;
        SetNeedRedraw;
      end;
    finally
      ViewUpdateUnlock;
    end;
    ViewUpdate;
  end;
end;

procedure TMapLayerGPSMarker.PaintLayer(ABuffer: TBitmap32; ALocalConverter: ILocalCoordConverter);
var
  VTargetPoint: TDoublePoint;
  VMarker: IBitmapMarker;
begin
  VMarker := FMarker;
  if VMarker <> nil then begin
    VTargetPoint := ALocalConverter.LonLat2LocalPixelFloat(FFixedLonLat);
    VTargetPoint.X := VTargetPoint.X - VMarker.AnchorPoint.X;
    VTargetPoint.Y := VTargetPoint.Y - VMarker.AnchorPoint.Y;
    if PixelPointInRect(VTargetPoint, DoubleRect(ALocalConverter.GetLocalRect)) then begin
      ABuffer.Draw(Trunc(VTargetPoint.X), Trunc(VTargetPoint.Y), VMarker.Bitmap);
    end;
  end;
end;

procedure TMapLayerGPSMarker.PrepareMarker(ASpeed, AAngle: Double; AForceStopped: Boolean);
var
  VMarker: IBitmapMarker;
  VMarkerProvider: IBitmapMarkerProvider;
  VMarkerWithDirectionProvider: IBitmapMarkerWithDirectionProvider;
begin
  if (not AForceStopped) and (ASpeed > FConfig.MinMoveSpeed) then begin
    VMarkerProvider := FMovedMarkerProviderStatic;
    if Supports(VMarkerProvider, IBitmapMarkerWithDirectionProvider, VMarkerWithDirectionProvider) then begin
      VMarker := VMarkerWithDirectionProvider.GetMarkerWithRotation(AAngle);
    end else begin
      VMarker := VMarkerProvider.GetMarker;
    end;
  end else begin
    VMarker := FStopedMarker;
  end;
  FMarker := VMarker;
end;

procedure TMapLayerGPSMarker.StartThreads;
begin
  inherited;
  OnConfigChange;
end;

end.
