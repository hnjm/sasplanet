unit u_WindowLayerBasic;

interface

uses
  Windows,
  GR32,
  GR32_Image,
  GR32_Layers,
  t_GeoTypes,
  u_BitmapLayerWithSortIndex;

type
  TWindowLayerBasic = class
  protected
    FParentMap: TImage32;
    FLayer: TBitmapLayerWithSortIndex;
{
 ������������ ������� ���������:
 VisualPixel - ���������� � �������� ���������� ParentMap
 BitmapPixel - ���������� � �������� ������� �������� ����
}
    function GetVisible: Boolean; virtual;
    procedure SetVisible(const Value: Boolean); virtual;

    // � ����������� ����� ����������� ���� ������� ���� ���� ��� ���������.
    function GetSortIndexForLayer: Integer; virtual;

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
  public
    constructor Create(AParentMap: TImage32);
    procedure Resize; virtual;
    procedure Show; virtual;
    procedure Hide; virtual;
    procedure Redraw; virtual;
    property Visible: Boolean read GetVisible write SetVisible;
  end;


implementation

uses
  Forms,
  Types;

constructor TWindowLayerBasic.Create(AParentMap: TImage32);
begin
  FParentMap := AParentMap;
  FLayer := TBitmapLayerWithSortIndex.Create(FParentMap.Layers, GetSortIndexForLayer);

  FLayer.Bitmap.DrawMode := dmBlend;
  FLayer.Bitmap.CombineMode := cmMerge;
  FLayer.bitmap.Font.Charset := RUSSIAN_CHARSET;
  FLayer.Visible := false;
end;

function TWindowLayerBasic.GetVisible: Boolean;
begin
  Result := FLayer.Visible;
end;

procedure TWindowLayerBasic.Hide;
begin
  FLayer.Visible := False;
  FLayer.Bitmap.Lock;
  try
    FLayer.Bitmap.SetSize(0, 0);
  finally
    FLayer.Bitmap.Unlock;
  end;
end;

procedure TWindowLayerBasic.Resize;
begin
  if FLayer.Visible then begin
    DoResize;
  end;
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
  if not FLayer.Visible then begin
    FLayer.Visible := True;
    Resize;
    Redraw;
  end;
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
var
  VBitmapSizeInPixel: TPoint;
begin
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


procedure TWindowLayerBasic.DoResize;
begin
  FLayer.Location := floatrect(GetMapLayerLocationRect);
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

function TWindowLayerBasic.GetSortIndexForLayer: Integer;
begin
  Result := 0;
end;

end.
