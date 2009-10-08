unit u_CoordConverterAbstract;

interface

uses
  Types,
  t_GeoTypes;

type
  ICoordConverter = interface
  ['{3EE2987F-7681-425A-8EFE-B676C506CDD4}']
    // ����������� ������� ����� �� �������� ���� � ������������ ���������� ��� �������� ������ ����
    function Pos2LonLat(const XY : TPoint; Azoom : byte) : TExtendedPoint; stdcall;
    // ����������� ������������� ���������� � ������� ����� �� �������� ���� ������������ ������ ����������
    function LonLat2Pos(const Ll : TExtendedPoint; Azoom : byte) : Tpoint; stdcall;
    // ?????????
    function LonLat2Metr(const Ll : TExtendedPoint) : TExtendedPoint; stdcall;

    // ���������� ���������� ������ � �������� ����
    function TilesAtZoom(AZoom: byte): Longint; stdcall;
    // ���������� ����� ���������� �������� �� �������� ����
    function PixelsAtZoom(AZoom: byte): Longint; stdcall;

    // ����������� ������� ����� ��������� ���� � ���������� ������� ��� ������ �������� ����
    function TilePos2PixelPos(const XY : TPoint; Azoom : byte): TPoint; stdcall;
    // ����������� ������� ����� ��������� ���� � ������ �������� ��� ����� �� �������� ����
    function TilePos2PixelRect(const XY : TPoint; Azoom : byte): TRect; stdcall;
    // ����������� ���������� ����� � ������������� ���������� �� ����� (x/PixelsAtZoom)
    function TilePos2Relative(const XY : TPoint; Azoom : byte) : TExtendedPoint; stdcall;
    // ����������� ������� ����� ��������� ���� � ������ �������� ��� ����� �� �������� ����
    function TilePos2RelativeRect(const XY : TPoint; Azoom : byte): TExtendedRect; stdcall;
    // ��������� ��������� �������� ������ �������������� ������
    function TileRect2PixelRect(const XY: TRect; AZoom: byte): TRect; stdcall;//TODO: ��������
    // ����������� ���������� ����� � �������������� ����������
    function TilePos2LonLat(const XY : TPoint; Azoom : byte) : TExtendedPoint; stdcall;//TODO: ��������
    // ����������� ������� ����� ��������� ���� � �������������� ���������� ��� �����
    function TilePos2LonLatRect(const XY : TPoint; Azoom : byte): TExtendedRect; stdcall;//TODO: ��������

    // ����������� ���������� ������� �  ���������� ����� c���������� �������
    function PixelPos2TilePos(const XY : TPoint; Azoom : byte) : TPoint; stdcall;
    // ����������� ���������� ������� � ������������� ���������� �� ����� (x/PixelsAtZoom)
    function PixelPos2Relative(const XY : TPoint; Azoom : byte) : TExtendedPoint; stdcall;
    // ��������� ������������� ������ ����������� ������������� ��������
    function PixelRect2TileRect(const XY: TRect; AZoom: byte): TRect; stdcall;
    // ����������� ���������� �������������� �������� � ������������� ���������� �� ����� (x/PixelsAtZoom)
    function PixelRect2RelativeRect(const XY: TRect; AZoom: byte): TExtendedRect; stdcall;
    // ����������� ���������� ������� � �������������� ����������
    function PixelPos2LonLat(const XY : TPoint; Azoom : byte) : TExtendedPoint; stdcall;//TODO: ��������

    // ����������� ������������� ���������� �� ����� � ���������� �������
    function Relative2Pixel(const XY : TExtendedPoint; Azoom : byte) : TPoint; stdcall;
    // ����������� ������������� ���������� �� ����� � ���������� �����
    function Relative2Tile(const XY : TExtendedPoint; Azoom : byte) : TPoint; stdcall;
    // ����������� ������������� ���������� �� ����� � ��������������
    function Relative2LonLat(const XY : TExtendedPoint): TExtendedPoint; stdcall;//TODO: ��������
    // ����������� ������������� � �������������� ������������ � ������������� ��������
    function RelativeRect2PixelRect(const XY : TExtendedRect; Azoom : byte) : TRect; stdcall;
    // ����������� ������������� � �������������� ������������ � ������������� ������
    function RelativeRect2TileRect(const XY : TExtendedRect; Azoom : byte) : TRect; stdcall;
    // ����������� ������������� � �������������� ������������ �� ����� � ��������������
    function RelativeRect2LonLatRect(const XY : TExtendedRect): TExtendedRect; stdcall;//TODO: ��������

    // ����������� ������������� ���������� � ���������� ������� �� �������� ���� ������������ ������ ����������
    function LonLat2PixelPos(const Ll : TExtendedPoint; Azoom : byte) : Tpoint; stdcall;//TODO: ��������
    // ����������� ������������� ���������� � ������� ����� �� �������� ���� ������������ ������ ����������
    function LonLat2TilePos(const Ll : TExtendedPoint; Azoom : byte) : Tpoint; stdcall;//TODO: ��������
    // ����������� �������������� ��������� � ������������� ���������� �� �����
    function LonLat2Relative(const XY : TExtendedPoint): TExtendedPoint; stdcall;//TODO: ��������
    // ����������� ������������� � �������������� ���������� � ������������� ���������� �� �����
    function LonLatRect2RelativeRect(const XY : TExtendedRect): TExtendedRect; stdcall;//TODO: ��������

    function Pos2OtherMap(XY : TPoint; Azoom : byte; AOtherMapCoordConv: ICoordConverter):TPoint;
    function CalcPoligonArea(polygon:TExtendedPointArray): Extended;
    function PoligonProject(AZoom:byte; APolyg: TExtendedPointArray): TPointArray;
    function CalcDist(AStart: TExtendedPoint; AFinish: TExtendedPoint): Extended;
  end;

  TCoordConverterAbstract = class(TInterfacedObject, ICoordConverter)
  public
    function Pos2LonLat(const XY : TPoint; Azoom : byte) : TExtendedPoint; virtual; stdcall; abstract;
    function LonLat2Pos(const Ll : TExtendedPoint; Azoom : byte) : Tpoint; virtual; stdcall; abstract;
    function LonLat2Metr(const Ll : TExtendedPoint) : TExtendedPoint; virtual; stdcall; abstract;

    function TilesAtZoom(AZoom: byte): Longint; virtual; stdcall;
    function PixelsAtZoom(AZoom: byte): Longint; virtual; stdcall;


    function TilePos2PixelPos(const XY : TPoint; Azoom : byte): TPoint; virtual; stdcall;
    function TilePos2PixelRect(const XY : TPoint; Azoom : byte): TRect; virtual; stdcall;
    function TilePos2LonLatRect(const XY : TPoint; Azoom : byte): TExtendedRect; virtual; stdcall;
    function TilePos2LonLat(const XY : TPoint; Azoom : byte) : TExtendedPoint; virtual; stdcall;
    function TileRect2PixelRect(const XY: TRect; AZoom: byte): TRect; virtual; stdcall;
    function TilePos2Relative(const XY : TPoint; Azoom : byte) : TExtendedPoint; virtual; stdcall;
    function TilePos2RelativeRect(const XY : TPoint; Azoom : byte): TExtendedRect; virtual; stdcall;

    function PixelPos2LonLat(const XY : TPoint; Azoom : byte) : TExtendedPoint; virtual; stdcall;
    function PixelPos2TilePos(const XY : TPoint; Azoom : byte) : TPoint; virtual; stdcall;
    function PixelPos2Relative(const XY : TPoint; Azoom : byte) : TExtendedPoint; virtual; stdcall;
    function PixelRect2TileRect(const XY: TRect; AZoom: byte): TRect; virtual; stdcall;
    function PixelRect2RelativeRect(const XY: TRect; AZoom: byte): TExtendedRect; virtual; stdcall;


    function LonLat2PixelPos(const Ll : TExtendedPoint; Azoom : byte) : Tpoint; virtual; stdcall;
    function LonLat2TilePos(const Ll : TExtendedPoint; Azoom : byte) : Tpoint; virtual; stdcall;
    function LonLat2Relative(const XY : TExtendedPoint): TExtendedPoint; virtual; stdcall; abstract;
    function LonLatRect2RelativeRect(const XY : TExtendedRect): TExtendedRect; virtual; stdcall;

    function Relative2Pixel(const XY : TExtendedPoint; Azoom : byte) : TPoint; virtual; stdcall;
    function Relative2Tile(const XY : TExtendedPoint; Azoom : byte) : TPoint; virtual; stdcall;
    function Relative2LonLat(const XY : TExtendedPoint): TExtendedPoint; virtual; stdcall; abstract;
    function RelativeRect2LonLatRect(const XY : TExtendedRect): TExtendedRect; virtual; stdcall;
    function RelativeRect2TileRect(const XY : TExtendedRect; Azoom : byte) : TRect; virtual; stdcall;
    function RelativeRect2PixelRect(const XY : TExtendedRect; Azoom : byte) : TRect; virtual; stdcall;

    function Pos2OtherMap(XY : TPoint; Azoom : byte; AOtherMapCoordConv: ICoordConverter):TPoint; virtual;
    function CalcPoligonArea(polygon:TExtendedPointArray): Extended; virtual;
    function PoligonProject(AZoom:byte; APolyg: TExtendedPointArray): TPointArray; virtual;
    function CalcDist(AStart: TExtendedPoint; AFinish: TExtendedPoint): Extended; virtual; abstract;
  end;

const
  CTileRelativeEpsilon = (1/(1 shl 30 + (1 shl 30 - 1)))/2;

implementation

{ TCoordConverterAbstract }

function TCoordConverterAbstract.CalcPoligonArea(
  polygon: TExtendedPointArray): extended;
var
  L,i:integer;
  LLPrev, LLCurr: TExtendedPoint;
begin
  result:=0;
  l:=length(polygon);
  LLPrev := LonLat2Metr(polygon[0]);
  for i:=1 to L-1 do begin
    LLCurr := LonLat2Metr(polygon[i]);
    result := result + (LLPrev.x + LLCurr.x)*(LLPrev.y - LLCurr.y);
    LLPrev := LLCurr;
  end;
  result := 0.5*abs(result)/1000000;
end;

function TCoordConverterAbstract.TilePos2PixelRect(const XY: TPoint;
  Azoom: byte): TRect;
begin
  Result.Left := XY.X shl 8;
  Result.Top := XY.Y shl 8;
  Result.Right := Result.Left + ((1 shl 8) - 1);
  Result.Bottom := Result.Top + ((1 shl 8) - 1);
end;

function TCoordConverterAbstract.PoligonProject(AZoom: byte;
  APolyg: TExtendedPointArray): TPointArray;
var
  i:integer;
  VTilesAtZoom: Integer;
begin
  VTilesAtZoom := 1 shl AZoom;
  SetLength(Result, length(APolyg));
  for i:=0 to length(APolyg)-1 do begin
    Result[i] := LonLat2Pos(Apolyg[i], AZoom);
    if Result[i].y < 0 then Result[i].y:=1;
    if Result[i].y > VTilesAtZoom then Result[i].y := VTilesAtZoom - 1;
  end;
end;

function TCoordConverterAbstract.Pos2OtherMap(XY: TPoint; Azoom: byte;
  AOtherMapCoordConv: ICoordConverter): TPoint;
begin
  if (Self = nil) or (AOtherMapCoordConv = nil) then begin
    Result := XY;
  end else begin
    Result := AOtherMapCoordConv.LonLat2Pos(Pos2LonLat(XY, Azoom), Azoom);
  end;
end;

function TCoordConverterAbstract.TilePos2LonLatRect(const XY: TPoint;
  Azoom: byte): TExtendedRect;
begin
  Result := RelativeRect2LonLatRect(TilePos2RelativeRect(XY, Azoom));
end;

function TCoordConverterAbstract.PixelsAtZoom(AZoom: byte): Longint;
begin
  Result := 1 shl (AZoom + 8);
end;

function TCoordConverterAbstract.TilesAtZoom(AZoom: byte): Longint;
begin
  Result := 1 shl AZoom;
end;

function TCoordConverterAbstract.PixelPos2Relative(const XY: TPoint;
  Azoom: byte): TExtendedPoint;
var
  VPixelsAtZoom: Longint;
begin
  VPixelsAtZoom := PixelsAtZoom(Azoom);
  if VPixelsAtZoom < 0 then begin
    Result.X := - XY.X / VPixelsAtZoom;
    Result.Y := - XY.Y / VPixelsAtZoom;
  end else begin
    Result.X := XY.X / VPixelsAtZoom;
    Result.Y := XY.Y / VPixelsAtZoom;
  end;
end;

function TCoordConverterAbstract.Relative2Pixel(const XY: TExtendedPoint;
  Azoom: byte): TPoint;
var
  VPixelsAtZoom: Longint;
begin
  VPixelsAtZoom := PixelsAtZoom(Azoom);
  if VPixelsAtZoom < 0 then begin
    Result.X := - Trunc(XY.X * VPixelsAtZoom);
    Result.Y := - Trunc(XY.Y * VPixelsAtZoom);
  end else begin
    Result.X := Trunc(XY.X * VPixelsAtZoom);
    Result.Y := Trunc(XY.Y * VPixelsAtZoom);
  end;
end;

function TCoordConverterAbstract.LonLat2PixelPos(const Ll: TExtendedPoint;
  Azoom: byte): Tpoint;
begin
  Result := Relative2Pixel(LonLat2Relative(LL), AZoom);
end;

function TCoordConverterAbstract.LonLat2TilePos(const Ll: TExtendedPoint;
  Azoom: byte): Tpoint;
begin
  Result := Relative2Tile(LonLat2Relative(LL), AZoom);
end;

function TCoordConverterAbstract.PixelPos2LonLat(const XY: TPoint;
  Azoom: byte): TExtendedPoint;
begin
  Result := Relative2LonLat(PixelPos2LonLat(XY, Azoom));
end;

function TCoordConverterAbstract.TilePos2LonLat(const XY: TPoint;
  Azoom: byte): TExtendedPoint;
begin
  Result := Relative2LonLat(TilePos2Relative(XY, Azoom));
end;

function TCoordConverterAbstract.TilePos2Relative(const XY: TPoint;
  Azoom: byte): TExtendedPoint;
var
  VTilesAtZoom: Longint;
begin
  VTilesAtZoom := TilesAtZoom(Azoom);
  Result.X := XY.X / VTilesAtZoom;
  Result.Y := XY.Y / VTilesAtZoom;
end;

function TCoordConverterAbstract.TilePos2RelativeRect(const XY: TPoint;
  Azoom: byte): TExtendedRect;
var
  VTilesAtZoom: Longint;
begin
  VTilesAtZoom := TilesAtZoom(Azoom);
  Result.Left := XY.X / VTilesAtZoom;
  Result.Top := XY.Y / VTilesAtZoom;
  Result.Right := (XY.X + 1) / VTilesAtZoom;
  Result.Bottom := (XY.Y + 1) / VTilesAtZoom;
end;

function TCoordConverterAbstract.LonLatRect2RelativeRect(
  const XY: TExtendedRect): TExtendedRect;
begin
  Result.TopLeft := LonLat2Relative(XY.TopLeft);
  Result.BottomRight := LonLat2Relative(XY.BottomRight);
end;

function TCoordConverterAbstract.Relative2Tile(const XY: TExtendedPoint;
  Azoom: byte): TPoint;
var
  VTilesAtZoom: Longint;
begin
  VTilesAtZoom := TilesAtZoom(Azoom);
  Result.X := Trunc(XY.X * VTilesAtZoom);
  Result.Y := Trunc(XY.Y * VTilesAtZoom);
end;

function TCoordConverterAbstract.RelativeRect2LonLatRect(
  const XY: TExtendedRect): TExtendedRect;
begin
  Result.TopLeft := Relative2LonLat(XY.TopLeft);
  Result.BottomRight := Relative2LonLat(XY.BottomRight);
end;

function TCoordConverterAbstract.RelativeRect2PixelRect(const XY: TExtendedRect;
  Azoom: byte): TRect;
var
  VPixelsAtZoom: Longint;
begin
  VPixelsAtZoom := PixelsAtZoom(Azoom);
  if VPixelsAtZoom < 0 then begin
    Result.Left := -Trunc(XY.Left * VPixelsAtZoom);
    Result.Top := -Trunc(XY.Top * VPixelsAtZoom);

    Result.Right := -Trunc((XY.Right - CTileRelativeEpsilon) * VPixelsAtZoom);
    Result.Bottom := -Trunc((XY.Bottom - CTileRelativeEpsilon) * VPixelsAtZoom);
  end else begin
    Result.Left := Trunc(XY.Left * VPixelsAtZoom);
    Result.Top := Trunc(XY.Top * VPixelsAtZoom);

    Result.Right := Trunc((XY.Right - CTileRelativeEpsilon) * VPixelsAtZoom);
    Result.Bottom := Trunc((XY.Bottom - CTileRelativeEpsilon) * VPixelsAtZoom);
  end;
end;

function TCoordConverterAbstract.RelativeRect2TileRect(const XY: TExtendedRect;
  Azoom: byte): TRect;
var
  VTilesAtZoom: Longint;
begin
  VTilesAtZoom := TilesAtZoom(Azoom);

  Result.Left := Trunc(XY.Left * VTilesAtZoom);
  Result.Top := Trunc(XY.Top * VTilesAtZoom);

  Result.Right := Trunc((XY.Right - CTileRelativeEpsilon) * VTilesAtZoom);
  Result.Bottom := Trunc((XY.Bottom - CTileRelativeEpsilon) * VTilesAtZoom);
end;

function TCoordConverterAbstract.PixelPos2TilePos(const XY: TPoint;
  Azoom: byte): TPoint;
begin
  Result.X := XY.X shr 8;
  Result.Y := XY.Y shr 8;
end;

function TCoordConverterAbstract.PixelRect2TileRect(const XY: TRect;
  AZoom: byte): TRect;
begin
  Result.Left := XY.Left shr 8;
  Result.Top := XY.Top shr 8;
  Result.Right := XY.Right shr 8;
  Result.Bottom := XY.Bottom shr 8;
end;

function TCoordConverterAbstract.TileRect2PixelRect(const XY: TRect;
  AZoom: byte): TRect;
begin
  Result.Left := XY.Left shl 8;
  Result.Top := XY.Top shl 8;
  Result.Right := (XY.Right + 1) shl 8 - 1;
  Result.Bottom := (XY.Bottom + 1) shl 8 - 1;
end;

function TCoordConverterAbstract.PixelRect2RelativeRect(const XY: TRect;
  AZoom: byte): TExtendedRect;
var
  VBottomRight: TPoint;
begin
  Result.TopLeft := PixelPos2Relative(XY.TopLeft, AZoom);
  VBottomRight.X := XY.Right + 1;
  VBottomRight.Y := XY.Bottom + 1;
  Result.BottomRight := PixelPos2Relative(VBottomRight, AZoom);
end;

function TCoordConverterAbstract.TilePos2PixelPos(const XY: TPoint;
  Azoom: byte): TPoint;
begin
  Result.X := XY.X shl 8;
  Result.Y := XY.Y shl 8;
end;

end.
