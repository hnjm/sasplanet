{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2014, SAS.Planet development team.                      *}
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
{* http://sasgis.org                                                          *}
{* info@sasgis.org                                                            *}
{******************************************************************************}

unit u_CoordConverterSimpleLonLat;

interface

uses
  t_Hash,
  t_GeoTypes,
  i_Datum,
  u_CoordConverterBasic;

type
  TCoordConverterSimpleLonLat = class(TCoordConverterBasic)
  private
    FExct: Double;
  protected
    function LonLat2MetrInternal(const ALl: TDoublePoint): TDoublePoint; override;
    function Metr2LonLatInternal(const AMm: TDoublePoint): TDoublePoint; override;
    function LonLat2RelativeInternal(const XY: TDoublePoint): TDoublePoint; override; stdcall;
    function Relative2LonLatInternal(const XY: TDoublePoint): TDoublePoint; override; stdcall;
  public
    constructor Create(
      const AHash: THashValue;
      const ADatum: IDatum;
      const AProjEPSG: integer;
      const ACellSizeUnits: TCellSizeUnits
    );
  end;

implementation

uses
  u_CoordConverterRoutines;

{ TCoordConverterSimpleLonLat }

constructor TCoordConverterSimpleLonLat.Create(
  const AHash: THashValue;
  const ADatum: IDatum;
  const AProjEPSG: integer;
  const ACellSizeUnits: TCellSizeUnits
);
var
  VRadiusA, VRadiusB: Double;
begin
  Assert(ADatum <> nil);
  inherited;
  VRadiusA := ADatum.GetSpheroidRadiusA;
  VRadiusB := ADatum.GetSpheroidRadiusB;
  FExct := sqrt(VRadiusA * VRadiusA - VRadiusB * VRadiusB) / VRadiusA;
end;

function TCoordConverterSimpleLonLat.LonLat2MetrInternal(const ALl: TDoublePoint): TDoublePoint;
begin
  Result := Ellipsoid_LonLat2Metr(Datum.GetSpheroidRadiusA, FExct, ALl);
end;

function TCoordConverterSimpleLonLat.LonLat2RelativeInternal(
  const XY: TDoublePoint): TDoublePoint;
begin
  Result.x := (0.5 + XY.x / 360);
  Result.y := (0.5 - XY.y / 360);
end;

function TCoordConverterSimpleLonLat.Metr2LonLatInternal(const AMm: TDoublePoint): TDoublePoint;
begin
  Result := Ellipsoid_Metr2LonLat(Datum.GetSpheroidRadiusA, FExct, AMm);
end;

function TCoordConverterSimpleLonLat.Relative2LonLatInternal(
  const XY: TDoublePoint): TDoublePoint;
begin
  Result.X := (XY.x - 0.5) * 360;
  Result.y := -(XY.y - 0.5) * 360;
end;

end.
