unit u_MapLayerGPSMarker;

interface

uses
  SysUtils,
  GR32,
  GR32_Image,
  t_GeoTypes,
  i_Notifier,
  i_NotifierOperation,
  i_LocalCoordConverter,
  i_InternalPerformanceCounter,
  i_SimpleFlag,
  i_MarkerDrawable,
  i_MapLayerGPSMarkerConfig,
  i_GPSRecorder,
  i_ViewPortState,
  u_MapLayerBasic;

type
  TMapLayerGPSMarker = class(TMapLayerBasicNoBitmap)
  private
    FConfig: IMapLayerGPSMarkerConfig;
    FGPSRecorder: IGPSRecorder;
    FArrowMarkerChangeable: IMarkerDrawableWithDirectionChangeable;
    FStopedMarkerChangeable: IMarkerDrawableChangeable;

    FGpsPosChangeFlag: ISimpleFlag;

    FPositionCS: IReadWriteSync;
    FPositionLonLat: TDoublePoint;
    FStopped: Boolean;
    FDirectionAngle: Double;

    procedure GPSReceiverReceive;
    procedure OnConfigChange;
    procedure OnTimer;
  protected
    procedure PaintLayer(
      ABuffer: TBitmap32;
      const ALocalConverter: ILocalCoordConverter
    ); override;
    procedure StartThreads; override;
  public
    constructor Create(
      const APerfList: IInternalPerformanceCounterList;
      const AAppStartedNotifier: INotifierOneOperation;
      const AAppClosingNotifier: INotifierOneOperation;
      AParentMap: TImage32;
      const AViewPortState: IViewPortState;
      const ATimerNoifier: INotifier;
      const AConfig: IMapLayerGPSMarkerConfig;
      const AArrowMarkerChangeable: IMarkerDrawableWithDirectionChangeable;
      const AStopedMarkerChangeable: IMarkerDrawableChangeable;
      const AGPSRecorder: IGPSRecorder
    );
  end;

implementation

uses
  vsagps_public_base,
  vsagps_public_position,
  i_GPS,
  u_GeoFun,
  u_Synchronizer,
  u_SimpleFlagWithInterlock,
  u_ListenerByEvent;

{ TMapLayerGPSMarker }

constructor TMapLayerGPSMarker.Create(
  const APerfList: IInternalPerformanceCounterList;
  const AAppStartedNotifier: INotifierOneOperation;
  const AAppClosingNotifier: INotifierOneOperation;
  AParentMap: TImage32;
  const AViewPortState: IViewPortState;
  const ATimerNoifier: INotifier;
  const AConfig: IMapLayerGPSMarkerConfig;
  const AArrowMarkerChangeable: IMarkerDrawableWithDirectionChangeable;
  const AStopedMarkerChangeable: IMarkerDrawableChangeable;
  const AGPSRecorder: IGPSRecorder
);
begin
  inherited Create(
    APerfList,
    AAppStartedNotifier,
    AAppClosingNotifier,
    AParentMap,
    AViewPortState
  );
  FConfig := AConfig;
  FGPSRecorder := AGPSRecorder;
  FArrowMarkerChangeable := AArrowMarkerChangeable;
  FStopedMarkerChangeable := AStopedMarkerChangeable;

  FGpsPosChangeFlag := TSimpleFlagWithInterlock.Create;
  FPositionCS := MakeSyncRW_Var(Self, False);

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
    FArrowMarkerChangeable.GetChangeNotifier
  );
  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnConfigChange),
    FStopedMarkerChangeable.GetChangeNotifier
  );
  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.GPSReceiverReceive),
    FGPSRecorder.GetChangeNotifier
  );
end;

procedure TMapLayerGPSMarker.GPSReceiverReceive;
begin
  FGpsPosChangeFlag.SetFlag;
end;

procedure TMapLayerGPSMarker.OnConfigChange;
begin
  ViewUpdateLock;
  try
    SetNeedRedraw;
  finally
    ViewUpdateUnlock;
  end;
end;

procedure TMapLayerGPSMarker.OnTimer;
var
  VGPSPosition: IGPSPosition;
  VpPos: PSingleGPSData;
begin
  if FGpsPosChangeFlag.CheckFlagAndReset then begin
    ViewUpdateLock;
    try
      VGPSPosition := FGPSRecorder.CurrentPosition;
      VpPos := VGPSPosition.GetPosParams;
      if (not VpPos^.PositionOK) then begin
        // no position
        Hide;
      end else begin
        // ok
        FPositionCS.BeginWrite;
        try
          FPositionLonLat.X := VpPos^.PositionLon;
          FPositionLonLat.Y := VpPos^.PositionLat;
          FStopped := ((not VpPos^.AllowCalcStats) or NoData_Float64(VpPos^.Speed_KMH) or NoData_Float64(VpPos^.Heading));
          if not FStopped then begin
            FStopped := VpPos^.Speed_KMH <= FConfig.MinMoveSpeed;
          end;
          FDirectionAngle := VpPos^.Heading;
        finally
          FPositionCS.EndWrite;
        end;
        Show;
        SetNeedRedraw;
      end;
    finally
      ViewUpdateUnlock;
    end;
  end;
end;

procedure TMapLayerGPSMarker.PaintLayer(
  ABuffer: TBitmap32;
  const ALocalConverter: ILocalCoordConverter
);
var
  VFixedOnView: TDoublePoint;
  VPositionLonLat: TDoublePoint;
  VStopped: Boolean;
  VDirection: Double;
begin
  FPositionCS.BeginRead;
  try
    VPositionLonLat := FPositionLonLat;
    VStopped := FStopped;
    VDirection := FDirectionAngle;
  finally
    FPositionCS.EndRead;
  end;
  if not PointIsEmpty(FPositionLonLat) then begin
    VFixedOnView := ALocalConverter.LonLat2LocalPixelFloat(FPositionLonLat);
    if VStopped then begin
      FStopedMarkerChangeable.GetStatic.DrawToBitmap(ABuffer, VFixedOnView);
    end else begin
      FArrowMarkerChangeable.GetStatic.DrawToBitmapWithDirection(ABuffer, VFixedOnView, VDirection);
    end;
  end;
end;

procedure TMapLayerGPSMarker.StartThreads;
begin
  inherited;
  OnConfigChange;
end;

end.
