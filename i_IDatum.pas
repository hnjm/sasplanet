unit i_IDatum;

interface

uses
  t_GeoTypes;

type
  IDatum = interface
    ['{FF96E41C-41EC-4D87-BD1B-42F8E7CA3E15}']
    // ���������� ��� EPSG ��� ����� ������. ��� ������������� �������� � ��������� ����� ���������� 0
    function GetEPSG: integer; stdcall;
    property EPSG: Integer read GetEPSG;

    // ���������� ������ ��������.
    function GetSpheroidRadiusA: Double; stdcall;
    function GetSpheroidRadiusB: Double; stdcall;

    // ���������� �������� �� ������ ��������� ������������� ��������
    function IsSameDatum(ADatum: IDatum): Boolean; stdcall;

    function CalcPoligonArea(polygon: TArrayOfDoublePoint): Double;
    function CalcDist(AStart: TDoublePoint; AFinish: TDoublePoint): Double;
  end;

implementation

end.

