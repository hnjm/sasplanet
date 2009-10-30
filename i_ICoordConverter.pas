unit i_ICoordConverter;

interface

uses
  Types,
  t_GeoTypes;

type
  ICoordConverter = interface
  ['{3EE2987F-7681-425A-8EFE-B676C506CDD4}']
    // ����������� ������� ����� �� �������� ���� � ������������ ���������� ��� �������� ������ ����
    function Pos2LonLat(const XY: TPoint; Azoom: byte): TExtendedPoint; stdcall;
    // ����������� ������������� ���������� � ������� ����� �� �������� ���� ������������ ������ ����������
    function LonLat2Pos(const Ll: TExtendedPoint; Azoom: byte): Tpoint; stdcall;
    // ?????????
    function LonLat2Metr(const Ll: TExtendedPoint): TExtendedPoint; stdcall;

    // ���������� ���������� ������ � �������� ����
    function TilesAtZoom(AZoom: byte): Longint; stdcall;
    // ���������� ����� ���������� �������� �� �������� ����
    function PixelsAtZoom(AZoom: byte): Longint; stdcall;

    // ����������� ������� ����� ��������� ���� � ���������� ������� ��� ������ �������� ����
    function TilePos2PixelPos(const XY: TPoint; Azoom: byte): TPoint; stdcall;
    // ����������� ������� ����� ��������� ���� � ������ �������� ��� ����� �� �������� ����
    function TilePos2PixelRect(const XY: TPoint; Azoom: byte): TRect; stdcall;
    // ����������� ���������� ����� � ������������� ���������� �� ����� (x/PixelsAtZoom)
    function TilePos2Relative(const XY: TPoint; Azoom: byte): TExtendedPoint; stdcall;
    // ����������� ������� ����� ��������� ���� � ������ �������� ��� ����� �� �������� ����
    function TilePos2RelativeRect(const XY: TPoint; Azoom: byte): TExtendedRect; stdcall;
    // ��������� ��������� �������� ������ �������������� ������
    function TileRect2PixelRect(const XY: TRect; AZoom: byte): TRect; stdcall;//TODO: ��������
    // ����������� ���������� ����� � �������������� ����������
    function TilePos2LonLat(const XY: TPoint; Azoom: byte): TExtendedPoint; stdcall;//TODO: ��������
    // ����������� ������� ����� ��������� ���� � �������������� ���������� ��� �����
    function TilePos2LonLatRect(const XY: TPoint; Azoom: byte): TExtendedRect; stdcall;//TODO: ��������

    // ����������� ���������� ������� �  ���������� ����� c���������� �������
    function PixelPos2TilePos(const XY: TPoint; Azoom: byte): TPoint; stdcall;
    // ����������� ���������� ������� � ������������� ���������� �� ����� (x/PixelsAtZoom)
    function PixelPos2Relative(const XY: TPoint; Azoom: byte): TExtendedPoint; stdcall;
    // ����������� ���������� ������� � �������������� ����������
    function PixelPos2LonLat(const XY: TPoint; Azoom: byte): TExtendedPoint; stdcall;//TODO: ��������
    // ��������� ������������� ������ ����������� ������������� ��������
    function PixelRect2TileRect(const XY: TRect; AZoom: byte): TRect; stdcall;
    // ����������� ���������� �������������� �������� � ������������� ���������� �� ����� (x/PixelsAtZoom)
    function PixelRect2RelativeRect(const XY: TRect; AZoom: byte): TExtendedRect; stdcall;
    // ����������� ���������� �������������� �������� � �������������� ���������� �� �����
    function PixelRect2LonLatRect(const XY: TRect; AZoom: byte): TExtendedRect; stdcall;

    // ����������� ������������� ���������� �� ����� � ���������� �������
    function Relative2Pixel(const XY: TExtendedPoint; Azoom: byte): TPoint; stdcall;
    // ����������� ������������� ���������� �� ����� � ���������� �����
    function Relative2Tile(const XY: TExtendedPoint; Azoom: byte): TPoint; stdcall;
    // ����������� ������������� ���������� �� ����� � ��������������
    function Relative2LonLat(const XY: TExtendedPoint): TExtendedPoint; stdcall;//TODO: ��������
    // ����������� ������������� � �������������� ������������ � ������������� ��������
    function RelativeRect2PixelRect(const XY: TExtendedRect; Azoom: byte): TRect; stdcall;
    // ����������� ������������� � �������������� ������������ � ������������� ������
    function RelativeRect2TileRect(const XY: TExtendedRect; Azoom: byte): TRect; stdcall;
    // ����������� ������������� � �������������� ������������ �� ����� � ��������������
    function RelativeRect2LonLatRect(const XY: TExtendedRect): TExtendedRect; stdcall;//TODO: ��������

    // ����������� ������������� ���������� � ���������� ������� �� �������� ���� ������������ ������ ����������
    function LonLat2PixelPos(const Ll: TExtendedPoint; Azoom: byte): Tpoint; stdcall;//TODO: ��������
    function LonLat2PixelPosf(const Ll: TExtendedPoint; Azoom: byte): TExtendedPoint; stdcall;
    // ����������� ������������� ���������� � ������� ����� �� �������� ���� ������������ ������ ����������
    function LonLat2TilePos(const Ll: TExtendedPoint; Azoom: byte): Tpoint; stdcall;//TODO: ��������
    function LonLat2TilePosf(const Ll: TExtendedPoint; Azoom: byte): TExtendedPoint; stdcall;
    // ����������� �������������� ��������� � ������������� ���������� �� �����
    function LonLat2Relative(const XY: TExtendedPoint): TExtendedPoint; stdcall;//TODO: ��������
    // ����������� ������������� � �������������� ���������� � ������������� ���������� �� �����
    function LonLatRect2RelativeRect(const XY: TExtendedRect): TExtendedRect; stdcall;//TODO: ��������

    function Pos2OtherMap(XY: TPoint; Azoom: byte; AOtherMapCoordConv: ICoordConverter):TPoint;
    function CalcPoligonArea(polygon:TExtendedPointArray): Extended;
    function PoligonProject(AZoom:byte; APolyg: TExtendedPointArray): TPointArray;
    function CalcDist(AStart: TExtendedPoint; AFinish: TExtendedPoint): Extended;
  end;

implementation

end.
