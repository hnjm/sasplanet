unit i_ProjectionType;

interface

uses
  t_Hash,
  t_GeoTypes,
  i_Datum;

type
  IProjectionType = interface
    ['{843F645C-F485-4392-A809-8139430FC974}']
    function GetHash: THashValue;
    property Hash: THashValue read GetHash;

    function GetDatum: IDatum;
    property Datum: IDatum read GetDatum;

    // ���������� ��� EPSG ��� ���� ��������. ��� ������������� �������� � ��������� ����� ���������� 0
    function GetProjectionEPSG: Integer;
    property ProjectionEPSG: Integer read GetProjectionEPSG;

    // ����������� ������������� ���������� �� ����� � ��������������
    function Relative2LonLat(const APoint: TDoublePoint): TDoublePoint;
    // ����������� ������������� � �������������� ������������ �� ����� � ��������������
    function RelativeRect2LonLatRect(const ARect: TDoubleRect): TDoubleRect;

    // ����������� �������������� ��������� � ������������� ���������� �� �����
    function LonLat2Relative(const APoint: TDoublePoint): TDoublePoint;
    // ����������� ������������� � �������������� ���������� � ������������� ���������� �� �����
    function LonLatRect2RelativeRect(const ARect: TDoubleRect): TDoubleRect;

    // ����������� ������������� ���������� � �����������, � �������
    function LonLat2Metr(const APoint: TDoublePoint): TDoublePoint;
    function Metr2LonLat(const APoint: TDoublePoint): TDoublePoint;

    procedure ValidateRelativePos(var APoint: TDoublePoint);
    procedure ValidateRelativeRect(var ARect: TDoubleRect);

    procedure ValidateLonLatPos(var APoint: TDoublePoint);
    procedure ValidateLonLatRect(var ARect: TDoubleRect);

    function CheckRelativePos(const APoint: TDoublePoint): boolean;
    function CheckRelativeRect(const ARect: TDoubleRect): boolean;

    function CheckLonLatPos(const APoint: TDoublePoint): boolean;
    function CheckLonLatRect(const ARect: TDoubleRect): boolean;

    // ���������� �������� �� ������ ��� �������� ������������� ��������
    function IsSame(const AOther: IProjectionType): Boolean;
  end;

implementation

end.
