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

unit u_BitmapMarkerProviderSimpleCross;

interface

uses
  Types,
  GR32,
  i_BitmapMarker,
  i_BitmapMarkerProviderSimpleConfig,
  u_BitmapMarkerProviderSimpleBase;

type
  TBitmapMarkerProviderSimpleCross = class(TBitmapMarkerProviderSimpleBase)
  protected
    function CreateMarker(ASize: Integer; ADirection: Double): IBitmapMarker; override;
  public
    constructor CreateProvider(
      AConfig: IBitmapMarkerProviderSimpleConfigStatic
    ); override;
  end;

implementation

uses
  GR32_Polygons,
  t_GeoTypes,
  u_BitmapMarker;

{ TBitmapMarkerProviderSimpleCross }

constructor TBitmapMarkerProviderSimpleCross.CreateProvider(
  AConfig: IBitmapMarkerProviderSimpleConfigStatic);
begin
  inherited Create(0, AConfig);
end;

function TBitmapMarkerProviderSimpleCross.CreateMarker(ASize: Integer; ADirection: Double): IBitmapMarker;
var
  VConfig: IBitmapMarkerProviderSimpleConfigStatic;
  VMarkerBitmap: TCustomBitmap32;
  VSize: TPoint;
  VPolygon: TPolygon32;
  VCenterPoint: TDoublePoint;
  VCrossHalfWidth: Double;
begin
  VMarkerBitmap := TCustomBitmap32.Create;
  try
    VConfig := Config;
    VSize := Point(ASize, ASize);

    VCenterPoint.X := VSize.X / 2;
    VCenterPoint.Y := VSize.Y / 2;

    VCrossHalfWidth := ASize / 10;

    VMarkerBitmap.SetSize(VSize.Y, VSize.Y);
    VMarkerBitmap.Clear(0);
    VPolygon := TPolygon32.Create;
    try
      VPolygon.Antialiased := true;
      VPolygon.Closed := True;
      VPolygon.AntialiasMode := am32times;
      VPolygon.Add(FixedPoint(VCenterPoint.X - VCrossHalfWidth, 0));
      VPolygon.Add(FixedPoint(VCenterPoint.X + VCrossHalfWidth, 0));
      VPolygon.Add(FixedPoint(VCenterPoint.X + VCrossHalfWidth, VCenterPoint.Y - VCrossHalfWidth));
      VPolygon.Add(FixedPoint(VSize.X - 1, VCenterPoint.Y - VCrossHalfWidth));
      VPolygon.Add(FixedPoint(VSize.X - 1, VCenterPoint.Y + VCrossHalfWidth));
      VPolygon.Add(FixedPoint(VCenterPoint.X + VCrossHalfWidth, VCenterPoint.Y + VCrossHalfWidth));
      VPolygon.Add(FixedPoint(VCenterPoint.X + VCrossHalfWidth, VSize.Y - 1));
      VPolygon.Add(FixedPoint(VCenterPoint.X - VCrossHalfWidth, VSize.Y - 1));
      VPolygon.Add(FixedPoint(VCenterPoint.X - VCrossHalfWidth, VCenterPoint.Y + VCrossHalfWidth));
      VPolygon.Add(FixedPoint(0, VCenterPoint.Y + VCrossHalfWidth));
      VPolygon.Add(FixedPoint(0, VCenterPoint.Y - VCrossHalfWidth));
      VPolygon.Add(FixedPoint(VCenterPoint.X - VCrossHalfWidth, VCenterPoint.Y - VCrossHalfWidth));
      VPolygon.DrawFill(VMarkerBitmap, VConfig.MarkerColor);
      VPolygon.DrawEdge(VMarkerBitmap, VConfig.BorderColor);
    finally
      VPolygon.Free;
    end;
    Result :=
      TBitmapMarker.Create(
        VMarkerBitmap,
        VCenterPoint
      );
  finally
    VMarkerBitmap.Free;
  end;
end;

end.
