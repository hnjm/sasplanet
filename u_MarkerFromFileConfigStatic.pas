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

unit u_MarkerFromFileConfigStatic;

interface

uses
  t_GeoTypes,
  i_MarkerFromFileConfig;

type
  TMarkerFromFileConfigStatic = class(TInterfacedObject, IMarkerFromFileConfigStatic)
  private
    FFileName: string;
    FAnchorType: TAnchorType;
    FFixedPoint: TDoublePoint;
  private
    function GetFileName: string;
    function GetAnchorType: TAnchorType;
    function GetFixedPoint: TDoublePoint;
  public
    constructor Create(
      AFileName: string;
      AAnchorType: TAnchorType;
      AFixedPoint: TDoublePoint
    );
  end;


implementation

{ TMarkerFromFileConfigStatic }

constructor TMarkerFromFileConfigStatic.Create(AFileName: string;
  AAnchorType: TAnchorType; AFixedPoint: TDoublePoint);
begin
  inherited Create;
  FFileName := AFileName;
  FAnchorType := AAnchorType;
  FFixedPoint := AFixedPoint;
end;

function TMarkerFromFileConfigStatic.GetAnchorType: TAnchorType;
begin
  Result := FAnchorType;
end;

function TMarkerFromFileConfigStatic.GetFileName: string;
begin
  Result := FFileName;
end;

function TMarkerFromFileConfigStatic.GetFixedPoint: TDoublePoint;
begin
  Result := FFixedPoint;
end;

end.
