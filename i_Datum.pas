{******************************************************************************}
{* SAS.������� (SAS.Planet)                                                   *}
{* Copyright (C) 2007-2011, ������ ��������� SAS.������� (SAS.Planet).        *}
{* ��� ��������� �������� ��������� ����������� ������������. �� ������       *}
{* �������������� �/��� �������������� � �������� �������� �����������       *}
{* ������������ �������� GNU, �������������� ������ ���������� ������������   *}
{* �����������, ������ 3. ��� ��������� ���������������� � �������, ��� ���   *}
{* ����� ��������, �� ��� ������ ��������, � ��� ����� ���������������        *}
{* �������� ��������� ��������� ��� ������� � �������� ��� ������˨�����      *}
{* ����������. �������� ����������� ������������ �������� GNU ������ 3, ���   *}
{* ��������� �������������� ����������. �� ������ ���� �������� �����         *}
{* ����������� ������������ �������� GNU ������ � ����������. � ������ �     *}
{* ����������, ���������� http://www.gnu.org/licenses/.                       *}
{*                                                                            *}
{* http://sasgis.ru/sasplanet                                                 *}
{* az@sasgis.ru                                                               *}
{******************************************************************************}

unit i_Datum;

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

    function CalcPoligonArea(const polygon: TArrayOfDoublePoint): Double;
    function CalcDist(const AStart: TDoublePoint; const AFinish: TDoublePoint): Double;
  end;

implementation

end.

