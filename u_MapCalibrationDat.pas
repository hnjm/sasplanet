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

unit u_MapCalibrationDat;

interface

uses
  Types,
  i_CoordConverter,
  i_MapCalibration;

type
  TMapCalibrationDat = class(TInterfacedObject, IMapCalibration)
  public
    // ��� ��� ������ � ��������� ��� ������ ��� ��������.
    function GetName: WideString; safecall;
    // ����� ��������� �������� ��������
    function GetDescription: WideString; safecall;
    // ���������� �������� ��� ��������� �����.
    procedure SaveCalibrationInfo(AFileName: WideString; xy1, xy2: TPoint; Azoom: byte; AConverter: ICoordConverter); safecall;
  end;

implementation

uses
  SysUtils,
  t_GeoTypes,
  u_GeoToStr;

{ TMapCalibrationDat }

function TMapCalibrationDat.GetDescription: WideString;
begin
  Result := '�������� *.dat ��� ��������� Radio Mobile';
end;

function TMapCalibrationDat.GetName: WideString;
begin
  Result := '.dat';
end;

procedure TMapCalibrationDat.SaveCalibrationInfo(AFileName: WideString;
  xy1, xy2: TPoint; Azoom: byte; AConverter: ICoordConverter);
var
  f: TextFile;
  LL1, LL2: TDoublePoint;
begin
  assignfile(f, ChangeFileExt(AFileName, '.dat'));
  rewrite(f);
  writeln(f, '2');
  LL1 := AConverter.PixelPos2LonLat(xy1, Azoom);
  LL2 := AConverter.PixelPos2LonLat(xy2, Azoom);
  writeln(f, R2StrPoint(LL1.x) + ',' + R2StrPoint(LL1.y));
  writeln(f, R2StrPoint(LL2.x) + ',' + R2StrPoint(LL1.y));
  writeln(f, R2StrPoint(LL2.x) + ',' + R2StrPoint(LL2.y));
  writeln(f, R2StrPoint(LL1.x) + ',' + R2StrPoint(LL2.y));
  writeln(f, '(SASPlanet)');
  closefile(f);
end;

end.
 