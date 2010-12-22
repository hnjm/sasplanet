unit i_ICoordConverter;

interface

uses
  Types,
  t_GeoTypes;

type
  ICoordConverterSimple = interface
    ['{3EE2987F-7681-425A-8EFE-B676C506CDD4}']

    // ����������� ������� ����� �� �������� ���� � ������������ ���������� ��� �������� ������ ����
    function Pos2LonLat(const XY: TPoint; Azoom: byte): TDoublePoint; stdcall;
    // ����������� ������������� ���������� � ������� ����� �� �������� ���� ������������ ������ ����������
    function LonLat2Pos(const Ll: TDoublePoint; Azoom: byte): Tpoint; stdcall;
    // ?????????
    function LonLat2Metr(const Ll: TDoublePoint): TDoublePoint; stdcall;

    // ���������� ���������� ������ � �������� ����
    function TilesAtZoom(AZoom: byte): Longint; stdcall;
    // ���������� ����� ���������� �������� �� �������� ����
    function PixelsAtZoom(AZoom: byte): Longint; stdcall;

    // ����������� ������� ����� ��������� ���� � ���������� ������� ��� ������ �������� ����
    function TilePos2PixelPos(const XY: TPoint; Azoom: byte): TPoint; stdcall;
    // ����������� ������� ����� ��������� ���� � ������ �������� ��� ����� �� �������� ����
    function TilePos2PixelRect(const XY: TPoint; Azoom: byte): TRect; stdcall;
  end;

  ICoordConverter = interface
    ['{E8884111-C538-424F-92BC-1BC9843EA6BB}']
    // ���������� ���������� ������ � �������� ����
    function TilesAtZoom(AZoom: byte): Longint; stdcall;
    function TilesAtZoomFloat(AZoom: byte): Double; stdcall;
    // ���������� ����� ���������� �������� �� �������� ����
    function PixelsAtZoom(AZoom: byte): Longint; stdcall;
    function PixelsAtZoomFloat(AZoom: byte): Double; stdcall;

    // ����������� ���������� ������� �  ���������� ����� c���������� �������
    function PixelPos2TilePos(const XY: TPoint; Azoom: byte): TPoint; stdcall;
    // ����������� ���������� ������� � ������������� ���������� �� ����� (x/PixelsAtZoom)
    function PixelPos2Relative(const XY: TPoint; Azoom: byte): TDoublePoint; stdcall;
    // ����������� ���������� ������� � �������������� ����������
    function PixelPos2LonLat(const XY: TPoint; Azoom: byte): TDoublePoint; stdcall;//TODO: ��������
    function PixelPos2TilePosFloat(const XY: TPoint; Azoom: byte): TDoublePoint; stdcall;//TODO: ��������

    function PixelPosFloat2PixelPos(const XY: TDoublePoint; Azoom: byte): TPoint; stdcall;//TODO: ��������
    function PixelPosFloat2TilePos(const XY: TDoublePoint; Azoom: byte): TPoint; stdcall;//TODO: ��������
    function PixelPosFloat2TilePosFloat(const XY: TDoublePoint; Azoom: byte): TDoublePoint; stdcall;//TODO: ��������
    function PixelPosFloat2Relative(const XY: TDoublePoint; Azoom: byte): TDoublePoint; stdcall;//TODO: ��������
    function PixelPosFloat2LonLat(const XY: TDoublePoint; Azoom: byte): TDoublePoint; stdcall;//TODO: ��������

    // ��������� ������������� ������ ����������� ������������� ��������
    function PixelRect2TileRect(const XY: TRect; AZoom: byte): TRect; stdcall;
    // ����������� ���������� �������������� �������� � ������������� ���������� �� ����� (x/PixelsAtZoom)
    function PixelRect2RelativeRect(const XY: TRect; AZoom: byte): TDoubleRect; stdcall;
    // ����������� ���������� �������������� �������� � �������������� ���������� �� �����
    function PixelRect2LonLatRect(const XY: TRect; AZoom: byte): TDoubleRect; stdcall;
    function PixelRect2TileRectFloat(const XY: TRect; AZoom: byte): TDoubleRect; stdcall;//TODO: ��������

    function PixelRectFloat2PixelRect(const XY: TDoubleRect; AZoom: byte): TRect; stdcall;//TODO: ��������
    function PixelRectFloat2TileRect(const XY: TDoubleRect; AZoom: byte): TRect; stdcall;//TODO: ��������
    function PixelRectFloat2TileRectFloat(const XY: TDoubleRect; AZoom: byte): TDoubleRect; stdcall;//TODO: ��������
    function PixelRectFloat2RelativeRect(const XY: TDoubleRect; AZoom: byte): TDoubleRect; stdcall;//TODO: ��������
    function PixelRectFloat2LonLatRect(const XY: TDoubleRect; AZoom: byte): TDoubleRect; stdcall;//TODO: ��������

    // ����������� ������� ����� ��������� ���� � ���������� ������� ��� ������ �������� ����
    function TilePos2PixelPos(const XY: TPoint; Azoom: byte): TPoint; stdcall;
    // ����������� ������� ����� ��������� ���� � ������ �������� ��� ����� �� �������� ����
    function TilePos2PixelRect(const XY: TPoint; Azoom: byte): TRect; stdcall;
    // ����������� ���������� ����� � ������������� ���������� �� ����� (x/PixelsAtZoom)
    function TilePos2Relative(const XY: TPoint; Azoom: byte): TDoublePoint; stdcall;
    // ����������� ������� ����� ��������� ���� � ������ �������� ��� ����� �� �������� ����
    function TilePos2RelativeRect(const XY: TPoint; Azoom: byte): TDoubleRect; stdcall;
    // ����������� ���������� ����� � �������������� ����������
    function TilePos2LonLat(const XY: TPoint; Azoom: byte): TDoublePoint; stdcall;//TODO: ��������
    // ����������� ������� ����� ��������� ���� � �������������� ���������� ��� �����
    function TilePos2LonLatRect(const XY: TPoint; Azoom: byte): TDoubleRect; stdcall;//TODO: ��������

    function TilePosFloat2TilePos(const XY: TDoublePoint; Azoom: byte): TPoint; stdcall;//TODO: ��������
    function TilePosFloat2PixelPos(const XY: TDoublePoint; Azoom: byte): TPoint; stdcall;//TODO: ��������
    function TilePosFloat2PixelPosFloat(const XY: TDoublePoint; Azoom: byte): TDoublePoint; stdcall;//TODO: ��������
    function TilePosFloat2Relative(const XY: TDoublePoint; Azoom: byte): TDoublePoint; stdcall;//TODO: ��������
    function TilePosFloat2LonLat(const XY: TDoublePoint; Azoom: byte): TDoublePoint; stdcall;//TODO: ��������

    // ��������� ��������� �������� ������ �������������� ������
    function TileRect2PixelRect(const XY: TRect; AZoom: byte): TRect; stdcall;//TODO: ��������
    // ��������� ������������� ��������� ������ �������������� ������
    function TileRect2RelativeRect(const XY: TRect; AZoom: byte): TDoubleRect; stdcall;//TODO: ��������
    // ����������� ������������� ������ ��������� ���� � �������������� ���������� ��� �����
    function TileRect2LonLatRect(const XY: TRect; Azoom: byte): TDoubleRect; stdcall;//TODO: ��������

    function TileRectFloat2TileRect(const XY: TDoubleRect; AZoom: byte): TRect; stdcall;//TODO: ��������
    function TileRectFloat2PixelRect(const XY: TDoubleRect; AZoom: byte): TRect; stdcall;//TODO: ��������
    function TileRectFloat2PixelRectFloat(const XY: TDoubleRect; AZoom: byte): TDoubleRect; stdcall;//TODO: ��������
    function TileRectFloat2RelativeRect(const XY: TDoubleRect; AZoom: byte): TDoubleRect; stdcall;//TODO: ��������
    function TileRectFloat2LonLatRect(const XY: TDoubleRect; Azoom: byte): TDoubleRect; stdcall;//TODO: ��������

    // ����������� ������������� ���������� �� ����� � ���������� �������
    function Relative2Pixel(const XY: TDoublePoint; Azoom: byte): TPoint; stdcall;
    function Relative2PixelPosFloat(const XY: TDoublePoint; Azoom: byte): TDoublePoint; stdcall;//TODO: ��������
    // ����������� ������������� ���������� �� ����� � ���������� �����
    function Relative2Tile(const XY: TDoublePoint; Azoom: byte): TPoint; stdcall;
    function Relative2TilePosFloat(const XY: TDoublePoint; Azoom: byte): TDoublePoint; stdcall;
    // ����������� ������������� ���������� �� ����� � ��������������
    function Relative2LonLat(const XY: TDoublePoint): TDoublePoint; stdcall;//TODO: ��������

    // ����������� ������������� � �������������� ������������ � ������������� ��������
    function RelativeRect2PixelRect(const XY: TDoubleRect; Azoom: byte): TRect; stdcall;
    function RelativeRect2PixelRectFloat(const XY: TDoubleRect; Azoom: byte): TDoubleRect; stdcall;
    // ����������� ������������� � �������������� ������������ � ������������� ������
    function RelativeRect2TileRect(const XY: TDoubleRect; Azoom: byte): TRect; stdcall;
    function RelativeRect2TileRectFloat(const XY: TDoubleRect; Azoom: byte): TDoubleRect; stdcall;
    // ����������� ������������� � �������������� ������������ �� ����� � ��������������
    function RelativeRect2LonLatRect(const XY: TDoubleRect): TDoubleRect; stdcall;//TODO: ��������

    // ����������� ������������� ���������� � ���������� ������� �� �������� ���� ������������ ������ ����������
    function LonLat2PixelPos(const Ll: TDoublePoint; Azoom: byte): Tpoint; stdcall;//TODO: ��������
    function LonLat2PixelPosFloat(const Ll: TDoublePoint; Azoom: byte): TDoublePoint; stdcall;
    // ����������� ������������� ���������� � ������� ����� �� �������� ���� ������������ ������ ����������
    function LonLat2TilePos(const Ll: TDoublePoint; Azoom: byte): Tpoint; stdcall;//TODO: ��������
    function LonLat2TilePosFloat(const Ll: TDoublePoint; Azoom: byte): TDoublePoint; stdcall;
    // ����������� �������������� ��������� � ������������� ���������� �� �����
    function LonLat2Relative(const XY: TDoublePoint): TDoublePoint; stdcall;//TODO: ��������

    // ����������� ������������� � �������������� ���������� � ������������� ���������� �� �����
    function LonLatRect2RelativeRect(const XY: TDoubleRect): TDoubleRect; stdcall;//TODO: ��������
    function LonLatRect2PixelRect(const XY: TDoubleRect; Azoom: byte): TRect; stdcall;//TODO: ��������
    function LonLatRect2PixelRectFloat(const XY: TDoubleRect; Azoom: byte): TDoubleRect; stdcall;//TODO: ��������
    function LonLatRect2TileRect(const XY: TDoubleRect; Azoom: byte): TRect; stdcall;//TODO: ��������
    function LonLatRect2TileRectFloat(const XY: TDoubleRect; Azoom: byte): TDoubleRect; stdcall;//TODO: ��������

    function LonLatArray2PixelArray(APolyg: TDoublePointArray; AZoom: byte): TPointArray; stdcall;
    function LonLatArray2PixelArrayFloat(APolyg: TDoublePointArray; AZoom: byte): TDoublePointArray; stdcall;

    function GetTileSize(const XY: TPoint; Azoom: byte): TPoint; stdcall;
    function PixelPos2OtherMap(XY: TPoint; Azoom: byte; AOtherMapCoordConv: ICoordConverter): TPoint; stdcall;
    function CalcPoligonArea(polygon: TDoublePointArray): Double;
    function CalcDist(AStart: TDoublePoint; AFinish: TDoublePoint): Double;

    function CheckZoom(var AZoom: Byte): boolean; stdcall;
    function CheckTilePos(var XY: TPoint; var Azoom: byte; ACicleMap: Boolean): boolean; stdcall;
    function CheckTilePosStrict(var XY: TPoint; var Azoom: byte; ACicleMap: Boolean): boolean; stdcall;
    function CheckTileRect(var XY: TRect; var Azoom: byte): boolean; stdcall;

    function CheckPixelPos(var XY: TPoint; var Azoom: byte; ACicleMap: Boolean): boolean; stdcall;
    function CheckPixelPosFloat(var XY: TDoublePoint; var Azoom: byte; ACicleMap: Boolean): boolean; stdcall;
    function CheckPixelPosStrict(var XY: TPoint; var Azoom: byte; ACicleMap: Boolean): boolean; stdcall;
    function CheckPixelPosFloatStrict(var XY: TDoublePoint; var Azoom: byte; ACicleMap: Boolean): boolean; stdcall;
    function CheckPixelRect(var XY: TRect; var Azoom: byte): boolean; stdcall;
    function CheckPixelRectFloat(var XY: TDoubleRect; var Azoom: byte): boolean; stdcall;

    function CheckRelativePos(var XY: TDoublePoint): boolean; stdcall;
    function CheckRelativeRect(var XY: TDoubleRect): boolean; stdcall;

    function CheckLonLatPos(var XY: TDoublePoint): boolean; stdcall;
    function CheckLonLatRect(var XY: TDoubleRect): boolean; stdcall;

    // ���������� ��� EPSG ��� ���� ��������. ��� ������������� �������� � ��������� ����� ���������� 0
    function GetProjectionEPSG: Integer; stdcall;
    // ���������� ��� EPSG ��� ����� ������. ��� ������������� �������� � ��������� ����� ���������� 0
    function GetDatumEPSG: integer; stdcall;
    // ���������� ������ ��������.
    function GetSpheroidRadius: Double; stdcall;
    // ���������� ������� ��������� ������������ � ��������������� �����
    function GetCellSizeUnits: TCellSizeUnits; stdcall;
    // ���������� ��� ���� ������� �� ����� (�� �������, ����� �������� ������������ ������ ������)
    function GetTileSplitCode: Integer; stdcall;
    // ���������� �������� �� ������ ��������� ������������� ��������
    function IsSameConverter(AOtherMapCoordConv: ICoordConverter): Boolean; stdcall;


    // ?????????
    function LonLat2Metr(const Ll: TDoublePoint): TDoublePoint; stdcall;
  end;

implementation

end.

