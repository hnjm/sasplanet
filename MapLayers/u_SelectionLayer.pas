unit u_SelectionLayer;

interface

uses
  Windows,
  GR32,
  GR32_Polygons,
  GR32_Image,
  i_JclNotify,
  t_GeoTypes,
  i_ViewPortState,
  i_LocalCoordConverter,
  i_DoublePointsAggregator,
  i_InternalPerformanceCounter,
  i_LastSelectionLayerConfig,
  i_LastSelectionInfo,
  i_VectorItemLonLat,
  i_VectorItemProjected,
  i_VectorItmesFactory,
  u_PolyLineLayerBase;

type
  TSelectionLayer = class(TPolygonLayerBase)
  private
    FConfig: ILastSelectionLayerConfig;
    FLastSelectionInfo: ILastSelectionInfo;

    FLine: ILonLatPolygon;
    FVisible: Boolean;

    procedure OnChangeSelection;
  protected
    function GetLine(ALocalConverter: ILocalCoordConverter): ILonLatPolygon; override;
    procedure DoConfigChange; override;
  public
    procedure StartThreads; override;
  public
    constructor Create(
      APerfList: IInternalPerformanceCounterList;
      AParentMap: TImage32;
      AViewPortState: IViewPortState;
      AVectorItmesFactory: IVectorItmesFactory;
      AConfig: ILastSelectionLayerConfig;
      ALastSelectionInfo: ILastSelectionInfo
    );
  end;


implementation

uses
  SysUtils,
  u_NotifyEventListener,
  i_EnumDoublePoint,
  i_ProjectionInfo,
  u_GeoFun,
  u_DoublePointsAggregator,
  u_EnumDoublePointMapPixelToLocalPixel,
  u_EnumDoublePointWithClip,
  u_EnumDoublePointFilterEqual;

{ TSelectionLayer }

constructor TSelectionLayer.Create(
  APerfList: IInternalPerformanceCounterList;
  AParentMap: TImage32;
  AViewPortState: IViewPortState;
  AVectorItmesFactory: IVectorItmesFactory;
  AConfig: ILastSelectionLayerConfig;
  ALastSelectionInfo: ILastSelectionInfo
);
begin
  inherited Create(
    APerfList,
    AParentMap,
    AViewPortState,
    AVectorItmesFactory,
    AConfig
  );
  FConfig := AConfig;
  FLastSelectionInfo := ALastSelectionInfo;

  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnChangeSelection),
    FLastSelectionInfo.GetChangeNotifier
  );
end;

procedure TSelectionLayer.DoConfigChange;
begin
  inherited;
  FVisible := FConfig.Visible;
  SetVisible(FVisible);
end;

function TSelectionLayer.GetLine(
  ALocalConverter: ILocalCoordConverter): ILonLatPolygon;
begin
  if FVisible then begin
    Result := FLine;
  end else begin
    Result := nil;
  end;
end;

procedure TSelectionLayer.OnChangeSelection;
begin
  ViewUpdateLock;
  try
    FLine := FLastSelectionInfo.Polygon;
    if FLine.Count > 0 then begin
      SetNeedRedraw;
      Show;
    end else begin
      Hide;
    end;
    ChangedSource;
  finally
    ViewUpdateUnlock;
  end;
  ViewUpdate;
end;

procedure TSelectionLayer.StartThreads;
begin
  inherited;
  OnChangeSelection;
end;

end.
