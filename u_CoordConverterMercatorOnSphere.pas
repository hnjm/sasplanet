{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2011, SAS.Planet development team.                      *}
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

unit u_CoordConverterMercatorOnSphere;

interface

uses
  Types,
  Math,
  t_GeoTypes,
  u_CoordConverterBasic;

type
  TCoordConverterMercatorOnSphere = class(TCoordConverterBasic)
  protected
    function LonLat2MetrInternal(const ALl: TDoublePoint): TDoublePoint; override;
    function LonLat2RelativeInternal(const XY: TDoublePoint): TDoublePoint; override; stdcall;
    function Relative2LonLatInternal(const XY: TDoublePoint): TDoublePoint; override; stdcall;
  public
    constructor Create(Aradiusa: Double);
  end;

implementation

uses
  u_Datum;

{ TCoordConverterMercatorOnSphere }

constructor TCoordConverterMercatorOnSphere.Create(Aradiusa: Double);
begin
  ARadiusa := Aradiusa;
  if Abs(ARadiusa - 6378137) < 1 then begin
    inherited Create(TDatum.Create(7059, Aradiusa));
    FProjEPSG := 3785;
    FCellSizeUnits := CELL_UNITS_METERS;
  end else if Abs(ARadiusa - 6371000) < 1 then begin
    inherited Create(TDatum.Create(53004, Aradiusa));
    FProjEPSG := 53004;
    FCellSizeUnits := CELL_UNITS_METERS;
  end else begin
    inherited Create(TDatum.Create(0, Aradiusa));
    FProjEPSG := 0;
    FCellSizeUnits := CELL_UNITS_UNKNOWN;
  end;

end;

function TCoordConverterMercatorOnSphere.LonLat2MetrInternal(const ALl: TDoublePoint): TDoublePoint;
var
  VLl: TDoublePoint;
begin
  VLl := ALl;
  Vll.x := Vll.x * (Pi / 180);
  Vll.y := Vll.y * (Pi / 180);
  result.x := FDatum.GetSpheroidRadiusA * Vll.x;
  result.y := FDatum.GetSpheroidRadiusA * Ln(Tan(PI / 4 + Vll.y / 2));
end;

function TCoordConverterMercatorOnSphere.LonLat2RelativeInternal(const XY: TDoublePoint): TDoublePoint;
var
  z, c: Extended;
begin
  Result.x := 0.5 + XY.x / 360;
  z := sin(XY.y * Pi / 180);
  c := 1 / (2 * Pi);
  Result.y := 0.5 - 0.5 * ln((1 + z) / (1 - z)) * c;
end;

function TCoordConverterMercatorOnSphere.Relative2LonLatInternal(
  const XY: TDoublePoint): TDoublePoint;
begin
  Result.X := (XY.x - 0.5) * 360;
  Result.Y := -(XY.y - 0.5) * (2 * PI);
  Result.Y := (2 * arctan(exp(Result.Y)) - PI / 2) * 180 / PI;
end;

end.
