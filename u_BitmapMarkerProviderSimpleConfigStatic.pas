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

unit u_BitmapMarkerProviderSimpleConfigStatic;

interface

uses
  GR32,
  i_BitmapMarkerProviderSimpleConfig;

type
  TBitmapMarkerProviderSimpleConfigStatic = class(TInterfacedObject, IBitmapMarkerProviderSimpleConfigStatic)
  private
    FMarkerSize: Integer;
    FMarkerColor: TColor32;
    FBorderColor: TColor32;
  protected
    function GetMarkerSize: Integer;
    function GetMarkerColor: TColor32;
    function GetBorderColor: TColor32;
  public
    constructor Create(
      AMarkerSize: Integer;
      AMarkerColor: TColor32;
      ABorderColor: TColor32
    );
  end;

implementation

{ TBitmapMarkerProviderSimpleConfigStatic }

constructor TBitmapMarkerProviderSimpleConfigStatic.Create(
  AMarkerSize: Integer; AMarkerColor, ABorderColor: TColor32);
begin
  FMarkerSize :=  AMarkerSize;
  FMarkerColor := AMarkerColor;
  FBorderColor := ABorderColor;
end;

function TBitmapMarkerProviderSimpleConfigStatic.GetBorderColor: TColor32;
begin
  Result := FBorderColor;
end;

function TBitmapMarkerProviderSimpleConfigStatic.GetMarkerColor: TColor32;
begin
  Result := FMarkerColor;
end;

function TBitmapMarkerProviderSimpleConfigStatic.GetMarkerSize: Integer;
begin
  Result := FMarkerSize;
end;

end.
