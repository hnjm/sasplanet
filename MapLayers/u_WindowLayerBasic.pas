unit u_WindowLayerBasic;

interface

uses
  Windows,
  SyncObjs,
  GR32,
  GR32_Image,
  GR32_Layers,
  i_JclNotify,
  t_GeoTypes,
  i_IConfigDataProvider,
  i_IConfigDataWriteProvider,
  u_MapViewPortState;

type
  TWindowLayerAbstract = class
  private
    FCS: TCriticalSection;
    FRedrawCounter: Cardinal;
    FRedrawTime: TDateTime;
  protected
    procedure IncRedrawCounter(ATime: TDateTime);
    function GetVisible: Boolean; virtual; abstract;
  public
    constructor Create();
    destructor Destroy; override;
    procedure LoadConfig(AConfigProvider: IConfigDataProvider); virtual; abstract;
    procedure StartThreads; virtual; abstract;
    procedure SendTerminateToThreads; virtual; abstract;
    procedure SaveConfig(AConfigProvider: IConfigDataWriteProvider); virtual; abstract;
    procedure Redraw; virtual; abstract;
    property Visible: Boolean read GetVisible;
    property RedrawCounter: Cardinal read FRedrawCounter;
    property RedrawTime: TDateTime read FRedrawTime;
  end;



  TWindowLayerBasic = class(TWindowLayerAbstract)
  protected
    FLayerPositioned: TPositionedLayer;
    FViewPortState: TMapViewPortState;

    FVisible: Boolean;
    FVisibleChangeNotifier: IJclNotifier;

    FViewSizeChangeListener: IJclListener;
    FMapViewSize: TPoint;

    function GetVisible: Boolean; override;
    procedure SetVisible(const Value: Boolean); virtual;

    procedure OnViewSizeChange(Sender: TObject); virtual;
    procedure UpdateLayerSize(ANewSize: TPoint); virtual;
    procedure DoUpdateLayerSize(ANewSize: TPoint); virtual; abstract;
    function GetLayerSizeForViewSize(AViewSize: TPoint): TPoint; virtual; abstract;

    procedure UpdateLayerLocation(ANewLocation: TFloatRect); virtual;
    procedure DoUpdateLayerLocation(ANewLocation: TFloatRect); virtual;
    procedure DoShow; virtual;
    procedure DoHide; virtual;
    procedure DoRedraw; virtual; abstract;
    function GetMapLayerLocationRect: TFloatRect; virtual; abstract;
  public
    constructor Create(ALayer: TPositionedLayer; AViewPortState: TMapViewPortState);
    destructor Destroy; override;
    procedure LoadConfig(AConfigProvider: IConfigDataProvider); override;
    procedure StartThreads; override;
    procedure SendTerminateToThreads; override;
    procedure SaveConfig(AConfigProvider: IConfigDataWriteProvider); override;
    procedure Show; virtual;
    procedure Hide; virtual;
    procedure Redraw; override;
    property Visible: Boolean read GetVisible write SetVisible;
    property VisibleChangeNotifier: IJclNotifier read FVisibleChangeNotifier;
  end;

  TWindowLayerBasicFixedSizeWithBitmap = class(TWindowLayerBasic)
  protected
    FParentMap: TImage32;
    FLayer: TBitmapLayer;
    function GetBitmapSizeInPixel: TPoint; virtual; abstract;
    procedure DoRedraw; override;
  public
    constructor Create(AParentMap: TImage32; AViewPortState: TMapViewPortState);
  end;

  TWindowLayerBasicWithBitmap = class(TWindowLayerBasic)
  protected
    FParentMap: TImage32;
    FLayer: TBitmapLayer;
    procedure DoUpdateLayerSize(ANewSize: TPoint); override;
    procedure DoHide; override;
    procedure DoShow; override;
    function GetBitmapSizeInPixel: TPoint; virtual; abstract;
  public
    constructor Create(AParentMap: TImage32; AViewPortState: TMapViewPortState);
  end;

implementation

uses
  SysUtils,
  Forms,
  Types,
  u_NotifyEventListener,
  u_JclNotify;

{ TWindowLayerAbstract }

constructor TWindowLayerAbstract.Create;
begin
  FCS := TCriticalSection.Create;
  FRedrawCounter := 0;
  FRedrawTime  := 0;
end;

destructor TWindowLayerAbstract.Destroy;
begin
  FreeAndNil(FCS);
  inherited;
end;

procedure TWindowLayerAbstract.IncRedrawCounter(ATime: TDateTime);
begin
  FCS.Acquire;
  try
    Inc(FRedrawCounter);
    FRedrawTime := FRedrawTime + ATime;
  finally
    FCS.Release;
  end;
end;

{ TWindowLayerBasic }

constructor TWindowLayerBasic.Create(ALayer: TPositionedLayer; AViewPortState: TMapViewPortState);
begin
  inherited Create;
  FViewPortState := AViewPortState;

  FLayerPositioned := ALayer;

  FLayerPositioned.MouseEvents := false;
  FLayerPositioned.Visible := false;
  FVisible := False;

  FVisibleChangeNotifier := TJclBaseNotifier.Create;
  FViewSizeChangeListener := TNotifyEventListener.Create(Self.OnViewSizeChange);
  FViewPortState.ViewSizeChangeNotifier.Add(FViewSizeChangeListener);
end;

destructor TWindowLayerBasic.Destroy;
begin
  FViewPortState.ViewSizeChangeNotifier.Remove(FViewSizeChangeListener);
  FViewSizeChangeListener := nil;
  FViewPortState := nil;
  FLayerPositioned := nil;
  FVisibleChangeNotifier := nil;
  inherited;
end;

procedure TWindowLayerBasic.DoHide;
begin
  FVisible := False;
  FLayerPositioned.Visible := False;
end;

procedure TWindowLayerBasic.DoShow;
begin
  FVisible := True;
  FLayerPositioned.Visible := True;
end;

procedure TWindowLayerBasic.DoUpdateLayerLocation(ANewLocation: TFloatRect);
begin
  FLayerPositioned.Location := ANewLocation;
end;

function TWindowLayerBasic.GetVisible: Boolean;
begin
  Result := FVisible;
end;

procedure TWindowLayerBasic.Hide;
begin
  if FVisible then begin
    DoHide;
    FVisibleChangeNotifier.Notify(nil);
  end;
end;

procedure TWindowLayerBasic.LoadConfig(AConfigProvider: IConfigDataProvider);
begin
  // �� ��������� ������ �� ������
end;

procedure TWindowLayerBasic.OnViewSizeChange(Sender: TObject);
var
  VNewSize: TPoint;
begin
  VNewSize := FViewPortState.GetViewSizeInVisiblePixel;
  if (VNewSize.X <> FMapViewSize.X) or (VNewSize.Y <> FMapViewSize.Y) then begin
    FMapViewSize := VNewSize;
    UpdateLayerSize(GetLayerSizeForViewSize(FMapViewSize));
  end;
end;

procedure TWindowLayerBasic.UpdateLayerLocation(ANewLocation: TFloatRect);
begin
  if FVisible then begin
    DoUpdateLayerLocation(ANewLocation);
  end;
end;

procedure TWindowLayerBasic.UpdateLayerSize(ANewSize: TPoint);
begin
  if FVisible then begin
    DoUpdateLayerSize(ANewSize);
    UpdateLayerLocation(GetMapLayerLocationRect);
  end;
end;

procedure TWindowLayerBasic.Redraw;
var
  VPerformanceCounterBegin: Int64;
  VPerformanceCounterEnd: Int64;
  VPerformanceCounterFr: Int64;
  VUpdateTime: TDateTime;
begin
  if FVisible then begin
    try
      QueryPerformanceCounter(VPerformanceCounterBegin);
      DoRedraw;
    finally
      QueryPerformanceCounter(VPerformanceCounterEnd);
      QueryPerformanceFrequency(VPerformanceCounterFr);
      VUpdateTime := (VPerformanceCounterEnd - VPerformanceCounterBegin) / VPerformanceCounterFr;
      IncRedrawCounter(VUpdateTime);
    end;
  end;
end;

procedure TWindowLayerBasic.SaveConfig(
  AConfigProvider: IConfigDataWriteProvider);
begin
  // �� ��������� ������ �� ������
end;

procedure TWindowLayerBasic.SendTerminateToThreads;
begin
  // �� ��������� ������ �� ������
end;

procedure TWindowLayerBasic.SetVisible(const Value: Boolean);
begin
  if Value then begin
    Show;
  end else begin
    Hide;
  end;
end;

procedure TWindowLayerBasic.Show;
begin
  if not Visible then begin
    DoShow;
    FVisibleChangeNotifier.Notify(nil);
  end;
end;

procedure TWindowLayerBasic.StartThreads;
begin
  // �� ��������� ������ �� ������
end;

{ TWindowLayerBasicWithBitmap }

constructor TWindowLayerBasicWithBitmap.Create(AParentMap: TImage32;
  AViewPortState: TMapViewPortState);
begin
  FParentMap := AParentMap;
  FLayer := TBitmapLayer.Create(FParentMap.Layers);
  inherited Create(FLayer, AViewPortState);

  FLayer.Bitmap.DrawMode := dmBlend;
  FLayer.Bitmap.CombineMode := cmMerge;
  FLayer.bitmap.Font.Charset := RUSSIAN_CHARSET;
end;

procedure TWindowLayerBasicWithBitmap.DoHide;
begin
  inherited;
  FLayer.Bitmap.Lock;
  try
    FLayer.Bitmap.SetSize(0, 0);
  finally
    FLayer.Bitmap.Unlock;
  end;
end;

procedure TWindowLayerBasicWithBitmap.DoShow;
begin
  inherited;
  UpdateLayerSize(GetLayerSizeForViewSize(FMapViewSize));
  UpdateLayerLocation(GetMapLayerLocationRect);
  Redraw;
end;

procedure TWindowLayerBasicWithBitmap.DoUpdateLayerSize(ANewSize: TPoint);
var
  VBitmapSizeInPixel: TPoint;
begin
  inherited;
  VBitmapSizeInPixel := GetBitmapSizeInPixel;
  FLayer.Bitmap.Lock;
  try
    if (FLayer.Bitmap.Width <> VBitmapSizeInPixel.X) or (FLayer.Bitmap.Height <> VBitmapSizeInPixel.Y) then begin
      FLayer.Bitmap.SetSize(VBitmapSizeInPixel.X, VBitmapSizeInPixel.Y);
    end;
  finally
    FLayer.Bitmap.Unlock;
  end;
end;

{ TWindowLayerBasicFixedSizeWithBitmap }

constructor TWindowLayerBasicFixedSizeWithBitmap.Create(AParentMap: TImage32;
  AViewPortState: TMapViewPortState);
begin
  FParentMap := AParentMap;
  FLayer := TBitmapLayer.Create(FParentMap.Layers);
  inherited Create(FLayer, AViewPortState);

  FLayer.Bitmap.DrawMode := dmBlend;
  FLayer.Bitmap.CombineMode := cmMerge;
  FLayer.bitmap.Font.Charset := RUSSIAN_CHARSET;
end;

procedure TWindowLayerBasicFixedSizeWithBitmap.DoRedraw;
begin
end;

end.
