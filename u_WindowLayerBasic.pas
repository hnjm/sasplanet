unit u_WindowLayerBasic;

interface

uses
  Windows,
  GR32,
  GR32_Image,
  GR32_Layers,
  i_JclNotify,
  t_GeoTypes,
  i_IConfigDataProvider,
  i_IConfigDataWriteProvider,
  u_MapViewPortState;

type
  TWindowLayerBasic = class
  protected
    FParentMap: TImage32;
    FLayerPositioned: TPositionedLayer;
    FViewPortState: TMapViewPortState;
    FMapPosChangeListener: IJclListener;
    FVisibleChangeNotifier: IJclNotifier;

    function GetVisible: Boolean; virtual;
    procedure SetVisible(const Value: Boolean); virtual;

{
 ������������ ������� ���������:
 VisualPixel - ���������� � �������� ���������� ParentMap
 BitmapPixel - ���������� � �������� ������� �������� ����
}

    // �������� ������ ������������� �����������. �� ���� ���������� �������� � ������� VisualPixel
    function GetVisibleSizeInPixel: TPoint; virtual;
    // ������� �������� �������� ����. �� ���� ���������� ������� ������� ���� �������� � ������� BitmapPixel
    function GetBitmapSizeInPixel: TPoint; virtual; abstract;

    // ����������� ���������������
    function GetScale: double; virtual;

    // ���������� ��������������� ����� � ������� VisualPixel
    function GetFreezePointInVisualPixel: TPoint; virtual; abstract;
    // ���������� ��������������� ����� � ������� BitmapPixel
    function GetFreezePointInBitmapPixel: TPoint; virtual; abstract;

    function BitmapPixel2VisiblePixel(Pnt: TPoint): TPoint; overload; virtual;
    function BitmapPixel2VisiblePixel(Pnt: TExtendedPoint): TExtendedPoint; overload; virtual;
    function VisiblePixel2BitmapPixel(Pnt: TPoint): TPoint; overload; virtual;
    function VisiblePixel2BitmapPixel(Pnt: TExtendedPoint): TExtendedPoint; overload; virtual;

    // ��������� ���������� �������������� �������� � ���������� VisualPixel
    function GetMapLayerLocationRect: TRect; virtual;

    procedure DoResizeBitmap; virtual;
    procedure DoRedraw; virtual; abstract;
    procedure DoResize; virtual;
    function CreateLayer(ALayerCollection: TLayerCollection): TPositionedLayer; virtual;
  public
    constructor Create(AParentMap: TImage32; AViewPortState: TMapViewPortState);
    destructor Destroy; override;
    procedure LoadConfig(AConfigProvider: IConfigDataProvider); virtual;
    procedure StartThreads; virtual;
    procedure SendTerminateToThreads; virtual;
    procedure SaveConfig(AConfigProvider: IConfigDataWriteProvider); virtual;
    procedure Resize; virtual;
    procedure Show; virtual;
    procedure Hide; virtual;
    procedure Redraw; virtual;
    property Visible: Boolean read GetVisible write SetVisible;
    property VisibleChangeNotifier: IJclNotifier read FVisibleChangeNotifier;
  end;

  TWindowLayerBasicWithBitmap = class(TWindowLayerBasic)
  protected
    FLayer: TBitmapLayer;
    function CreateLayer(ALayerCollection: TLayerCollection): TPositionedLayer; override;
    procedure DoResizeBitmap; override;
  public
    constructor Create(AParentMap: TImage32; AViewPortState: TMapViewPortState);
    procedure Hide; override;
  end;

implementation

uses
  Forms,
  Types,
  u_JclNotify;

constructor TWindowLayerBasic.Create(AParentMap: TImage32; AViewPortState: TMapViewPortState);
begin
  FParentMap := AParentMap;
  FViewPortState := AViewPortState;

  FLayerPositioned := TBitmapLayer.Create(FParentMap.Layers);

  FLayerPositioned.MouseEvents := false;
  FLayerPositioned.Visible := false;

  FVisibleChangeNotifier := TJclBaseNotifier.Create;
end;

function TWindowLayerBasic.CreateLayer(
  ALayerCollection: TLayerCollection): TPositionedLayer;
begin
  Result := TPositionedLayer.Create(ALayerCollection);
end;

destructor TWindowLayerBasic.Destroy;
begin
  FMapPosChangeListener := nil;
  FViewPortState := nil;
  FParentMap := nil;
  FLayerPositioned := nil;
  FVisibleChangeNotifier := nil;
  inherited;
end;

function TWindowLayerBasic.GetVisible: Boolean;
begin
  Result := FLayerPositioned.Visible;
end;

procedure TWindowLayerBasic.Hide;
begin
  FLayerPositioned.Visible := False;
  FVisibleChangeNotifier.Notify(nil);
end;

procedure TWindowLayerBasic.LoadConfig(AConfigProvider: IConfigDataProvider);
begin
  // �� ��������� ������ �� ������
end;

procedure TWindowLayerBasic.Resize;
begin
  if FLayerPositioned.Visible then begin
    DoResize;
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
  if not FLayerPositioned.Visible then begin
    FLayerPositioned.Visible := True;
    FVisibleChangeNotifier.Notify(nil);
    Resize;
    Redraw;
  end;
end;

procedure TWindowLayerBasic.StartThreads;
begin
  // �� ��������� ������ �� ������
end;

function TWindowLayerBasic.GetScale: double;
begin
  Result := 1;
end;

procedure TWindowLayerBasic.Redraw;
begin
  if Visible then begin
    DoResizeBitmap;
    DoRedraw;
  end;
end;

procedure TWindowLayerBasic.DoResizeBitmap;
begin
end;

procedure TWindowLayerBasic.DoResize;
begin
  FLayerPositioned.Location := floatrect(GetMapLayerLocationRect);
end;

function TWindowLayerBasic.GetVisibleSizeInPixel: TPoint;
begin
  Result.X := FParentMap.Width;
  Result.Y := FParentMap.Height;
end;

function TWindowLayerBasic.GetMapLayerLocationRect: TRect;
var
  VBitmapSize: TPoint;
begin
  VBitmapSize := GetBitmapSizeInPixel;
  Result.TopLeft := BitmapPixel2VisiblePixel(Point(0, 0));
  Result.BottomRight := BitmapPixel2VisiblePixel(VBitmapSize);
end;


function TWindowLayerBasic.VisiblePixel2BitmapPixel(
  Pnt: TExtendedPoint): TExtendedPoint;
var
  VFreezePointInVisualPixel: TPoint;
  VFreezePointInBitmapPixel: TPoint;
  VScale: double;
begin
  VFreezePointInVisualPixel := GetFreezePointInVisualPixel;
  VFreezePointInBitmapPixel := GetFreezePointInBitmapPixel;
  VScale := GetScale;

  Result.X := (Pnt.X - VFreezePointInVisualPixel.X) / VScale + VFreezePointInBitmapPixel.X;
  Result.Y := (Pnt.Y - VFreezePointInVisualPixel.Y) / VScale + VFreezePointInBitmapPixel.Y;
end;

function TWindowLayerBasic.VisiblePixel2BitmapPixel(Pnt: TPoint): TPoint;
var
  VFreezePointInVisualPixel: TPoint;
  VFreezePointInBitmapPixel: TPoint;
  VScale: double;
begin
  VFreezePointInVisualPixel := GetFreezePointInVisualPixel;
  VFreezePointInBitmapPixel := GetFreezePointInBitmapPixel;
  VScale := GetScale;

  Result.X := Trunc((Pnt.X - VFreezePointInVisualPixel.X) / VScale + VFreezePointInBitmapPixel.X);
  Result.Y := Trunc((Pnt.Y - VFreezePointInVisualPixel.Y) / VScale + VFreezePointInBitmapPixel.Y);
end;


function TWindowLayerBasic.BitmapPixel2VisiblePixel(Pnt: TPoint): TPoint;
var
  VFreezePointInVisualPixel: TPoint;
  VFreezePointInBitmapPixel: TPoint;
  VScale: double;
begin
  VFreezePointInVisualPixel := GetFreezePointInVisualPixel;
  VFreezePointInBitmapPixel := GetFreezePointInBitmapPixel;
  VScale := GetScale;

  Result.X := Trunc((Pnt.X - VFreezePointInBitmapPixel.X) * VScale + VFreezePointInVisualPixel.X);
  Result.Y := Trunc((Pnt.Y - VFreezePointInBitmapPixel.Y) * VScale + VFreezePointInVisualPixel.Y);
end;

function TWindowLayerBasic.BitmapPixel2VisiblePixel(
  Pnt: TExtendedPoint): TExtendedPoint;
var
  VFreezePointInVisualPixel: TPoint;
  VFreezePointInBitmapPixel: TPoint;
  VScale: double;
begin
  VFreezePointInVisualPixel := GetFreezePointInVisualPixel;
  VFreezePointInBitmapPixel := GetFreezePointInBitmapPixel;
  VScale := GetScale;

  Result.X := (Pnt.X - VFreezePointInBitmapPixel.X) * VScale + VFreezePointInVisualPixel.X;
  Result.Y := (Pnt.Y - VFreezePointInBitmapPixel.Y) * VScale + VFreezePointInVisualPixel.Y;
end;

constructor TWindowLayerBasicWithBitmap.Create(AParentMap: TImage32;
  AViewPortState: TMapViewPortState);
begin
  inherited;
  FLayer := TBitmapLayer(FLayerPositioned);

  FLayer.Bitmap.DrawMode := dmBlend;
  FLayer.Bitmap.CombineMode := cmMerge;
  FLayer.bitmap.Font.Charset := RUSSIAN_CHARSET;
end;

function TWindowLayerBasicWithBitmap.CreateLayer(ALayerCollection: TLayerCollection): TPositionedLayer;
begin
  Result := TBitmapLayer.Create(ALayerCollection);
end;

procedure TWindowLayerBasicWithBitmap.DoResizeBitmap;
var
  VBitmapSizeInPixel: TPoint;
begin
  inherited;
  VBitmapSizeInPixel := GetBitmapSizeInPixel;
  if (FLayer.Bitmap.Width <> VBitmapSizeInPixel.X) or (FLayer.Bitmap.Height <> VBitmapSizeInPixel.Y) then begin
    FLayer.Bitmap.Lock;
    try
      FLayer.Bitmap.SetSize(VBitmapSizeInPixel.X, VBitmapSizeInPixel.Y);
    finally
      FLayer.Bitmap.Unlock;
    end;
  end;
end;

procedure TWindowLayerBasicWithBitmap.Hide;
begin
  inherited;
  FLayer.Bitmap.Lock;
  try
    FLayer.Bitmap.SetSize(0, 0);
  finally
    FLayer.Bitmap.Unlock;
  end;
end;

end.
