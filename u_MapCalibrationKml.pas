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

unit u_MapCalibrationKml;

interface

uses
  Types,
  i_CoordConverter,
  i_MapCalibration;

type
  TMapCalibrationKml = class(TInterfacedObject, IMapCalibration)
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

{ TMapCalibrationKml }

function TMapCalibrationKml.GetDescription: WideString;
begin
  Result := '�������� *.kml ��� ��������� Google Earth';
end;

function TMapCalibrationKml.GetName: WideString;
begin
  Result := '.kml';
end;

procedure TMapCalibrationKml.SaveCalibrationInfo(AFileName: WideString;
  xy1, xy2: TPoint; Azoom: byte; AConverter: ICoordConverter);
var
  f: TextFile;
  LL1, LL2: TDoublePoint;
  str: UTF8String;
  VFileName: String;
begin
  assignfile(f, ChangeFileExt(AFileName, '.kml'));
  rewrite(f);
  VFileName := ExtractFileName(AFileName);
  str := ansiToUTF8('<?xml version="1.0" encoding="UTF-8"?>' + #13#10);
  str := str + ansiToUTF8('<kml><GroundOverlay><name>' + VFileName + '</name><color>88ffffff</color><Icon>' + #13#10);
  str := str + ansiToUTF8('<href>' + VFileName + '</href>' + #13#10);
  str := str + ansiToUTF8('<viewBoundScale>0.75</viewBoundScale></Icon><LatLonBox>' + #13#10);
  LL1 := AConverter.PixelPos2LonLat(xy1, Azoom);
  LL2 := AConverter.PixelPos2LonLat(xy2, Azoom);
  str := str + ansiToUTF8('<north>' + R2StrPoint(LL1.y) + '</north>' + #13#10);
  str := str + ansiToUTF8('<south>' + R2StrPoint(LL2.y) + '</south>' + #13#10);
  str := str + ansiToUTF8('<east>' + R2StrPoint(LL2.x) + '</east>' + #13#10);
  str := str + ansiToUTF8('<west>' + R2StrPoint(LL1.x) + '</west>' + #13#10);
  str := str + ansiToUTF8('</LatLonBox></GroundOverlay></kml>');
  writeln(f, str);
  closefile(f);
end;

end.
 