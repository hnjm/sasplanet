{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2012, SAS.Planet development team.                      *}
{* This program is free software: you can redistribute it and/or modify       *}
{* it under the terms of the GNU General Public License as published by       *}
{* the Free Software Foundation, either version 3 of the License, or          *}
{* (at your option) any later version.                                        *}
{*                                                                            *}
{* This program is distributed in the hope that it will be useful,            *}
{* but WITHOUT ANY WARRANTY; without even the implied warranty of             *}
{* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *}
{* GNU General Public License for more details.                               *}
{*                                                                            *}
{* You should have received a copy of the GNU General Public License          *}
{* along with this program.  If not, see <http://www.gnu.org/licenses/>.      *}
{*                                                                            *}
{* http://sasgis.ru                                                           *}
{* az@sasgis.ru                                                               *}
{******************************************************************************}

unit u_MapCalibrationTab;

interface

uses
  Types,
  i_CoordConverter,
  i_MapCalibration;

type
  TMapCalibrationTab = class(TInterfacedObject, IMapCalibration)
  private
    // ��� ��� ������ � ��������� ��� ������ ��� ��������.
    function GetName: WideString; safecall;
    // ����� ��������� �������� ��������
    function GetDescription: WideString; safecall;
    // ���������� �������� ��� ��������� �����.
    procedure SaveCalibrationInfo(
      const AFileName: WideString;
      const xy1, xy2: TPoint;
      AZoom: byte;
      const AConverter: ICoordConverter
    ); safecall;
  end;

implementation

uses
  Classes,
  SysUtils,
  t_GeoTypes,
  u_GeoToStr;

{ TMapCalibrationTab }

function TMapCalibrationTab.GetDescription: WideString;
begin
  Result := '�������� *.tab';
end;

function TMapCalibrationTab.GetName: WideString;
begin
  Result := '.tab';
end;

procedure TMapCalibrationTab.SaveCalibrationInfo(
  const AFileName: WideString;
  const xy1, xy2: TPoint;
  AZoom: byte;
  const AConverter: ICoordConverter
);
var
  xy: TPoint;
  lat, lon: array[1..3] of Double;
  VLL1, VLL2: TDoublePoint;
  VLL: TDoublePoint;
  VLocalRect: TRect;
  VFileName: string;
  VFileStream: TFileStream;
  VText: AnsiString;
begin
  VFileName := ChangeFileExt(AFileName, '.tab');
  VFileStream := TFileStream.Create(VFileName, fmCreate);
  try
    VText := '';
    VText := VText + '!table' + #13#10;
    VText := VText + '!version 300' + #13#10;
    VText := VText + '!charset WindowsCyrillic' + #13#10 + #13#10;
    VText := VText + 'Definition Table' + #13#10;
    VText := VText + 'File "' + ExtractFileName(AFileName) + '"' + #13#10;
    VText := VText + 'Type "RASTER"' + #13#10;

    VLL1 := AConverter.PixelPos2LonLat(xy1, AZoom);
    VLL2 := AConverter.PixelPos2LonLat(xy2, AZoom);
    xy.Y := (xy2.y - ((xy2.Y - xy1.Y) div 2));
    xy.X := (xy2.x - ((xy2.x - xy1.x) div 2));
    VLL := AConverter.PixelPos2LonLat(xy, AZoom);

    lon[1] := VLL1.X;
    lat[1] := VLL1.Y;
    lon[2] := VLL.X;
    lat[2] := VLL.Y;
    lon[3] := VLL2.X;
    lat[3] := VLL2.Y;

    VLocalRect.TopLeft := Point(0, 0);
    VLocalRect.BottomRight := Point(xy2.X - xy1.X, xy2.y - xy1.y);

    VText := VText + '(' + R2StrPoint(lon[1]) + ',' + R2StrPoint(lat[1]) + ') (' + inttostr(VLocalRect.Left) + ', ' + inttostr(VLocalRect.Top) + ') Label "����� 1",' + #13#10;
    VText := VText + '(' + R2StrPoint(lon[3]) + ',' + R2StrPoint(lat[3]) + ') (' + inttostr(VLocalRect.Right) + ', ' + inttostr(VLocalRect.Bottom) + ') Label "����� 2",' + #13#10;
    VText := VText + '(' + R2StrPoint(lon[1]) + ',' + R2StrPoint(lat[3]) + ') (' + inttostr(VLocalRect.Left) + ', ' + inttostr(VLocalRect.Bottom) + ') Label "����� 3",' + #13#10;
    VText := VText + '(' + R2StrPoint(lon[3]) + ',' + R2StrPoint(lat[1]) + ') (' + inttostr(VLocalRect.Right) + ', ' + inttostr(VLocalRect.Top) + ') Label "����� 4",' + #13#10;
    VText := VText + '(' + R2StrPoint(lon[2]) + ',' + R2StrPoint(lat[2]) + ') (' + inttostr((VLocalRect.Right - VLocalRect.Left) div 2) + ', ' + inttostr((VLocalRect.Bottom - VLocalRect.Top) div 2) + ') Label "����� 5",' + #13#10;
    VText := VText + '(' + R2StrPoint(lon[2]) + ',' + R2StrPoint(lat[1]) + ') (' + inttostr((VLocalRect.Right - VLocalRect.Left) div 2) + ', ' + inttostr(VLocalRect.Top) + ') Label "����� 6",' + #13#10;
    VText := VText + '(' + R2StrPoint(lon[1]) + ',' + R2StrPoint(lat[2]) + ') (' + inttostr(VLocalRect.Left) + ', ' + inttostr((VLocalRect.Bottom - VLocalRect.Top) div 2) + ') Label "����� 7",' + #13#10;
    VText := VText + '(' + R2StrPoint(lon[3]) + ',' + R2StrPoint(lat[2]) + ') (' + inttostr(VLocalRect.Right) + ', ' + inttostr((VLocalRect.Bottom - VLocalRect.Top) div 2) + ') Label "����� 8",' + #13#10;
    VText := VText + '(' + R2StrPoint(lon[2]) + ',' + R2StrPoint(lat[3]) + ') (' + inttostr((VLocalRect.Right - VLocalRect.Left) div 2) + ', ' + inttostr(VLocalRect.Bottom) + ') Label "����� 9"' + #13#10;

    VText := VText + 'CoordSys Earth Projection 1, 104' + #13#10;
    VText := VText + 'Units "degree"' + #13#10;

    VFileStream.WriteBuffer(VText[1], Length(VText));
  finally
    VFileStream.Free;
  end;
end;

end.
