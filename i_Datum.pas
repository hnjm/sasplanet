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
    function IsSameDatum(const ADatum: IDatum): Boolean; stdcall;

    function CalcPoligonArea(const APoints: PDoublePointArray; const ACount: Integer): Double;
    function CalcDist(const AStart: TDoublePoint; const AFinish: TDoublePoint): Double;
  end;

implementation

end.

