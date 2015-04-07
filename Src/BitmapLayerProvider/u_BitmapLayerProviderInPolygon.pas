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
{* http://sasgis.org                                                          *}
{* info@sasgis.org                                                            *}
{******************************************************************************}

unit u_BitmapLayerProviderInPolygon;

interface

uses
  Types,
  i_NotifierOperation,
  i_Bitmap32Static,
  i_ProjectionInfo,
  i_GeometryProjected,
  i_BitmapLayerProvider,
  u_BaseInterfacedObject;

type
  TBitmapLayerProviderInPolygon = class(TBaseInterfacedObject, IBitmapTileUniProvider)
  private
    FSourceProvider: IBitmapTileUniProvider;
    FLine: IGeometryProjectedSinglePolygon;
  private
    function GetTile(
      AOperationID: Integer;
      const ACancelNotifier: INotifierOperation;
      const AProjectionInfo: IProjectionInfo;
      const ATile: TPoint
    ): IBitmap32Static;
  public
    constructor Create(
      const APolyProjected: IGeometryProjectedPolygon;
      const ASourceProvider: IBitmapTileUniProvider
    );
  end;

implementation

uses
  SysUtils,
  t_GeoTypes;

{ TBitmapLayerProviderInPolygon }

constructor TBitmapLayerProviderInPolygon.Create(
  const APolyProjected: IGeometryProjectedPolygon;
  const ASourceProvider: IBitmapTileUniProvider
);
var
  VMultiPolygon: IGeometryProjectedMultiPolygon;
begin
  Assert(ASourceProvider <> nil);
  Assert(APolyProjected <> nil);
  Assert(not APolyProjected.IsEmpty);
  inherited Create;
  FSourceProvider := ASourceProvider;
  if not Supports(APolyProjected, IGeometryProjectedSinglePolygon, FLine) then begin
    if Supports(APolyProjected, IGeometryProjectedMultiPolygon, VMultiPolygon) then begin
      if VMultiPolygon.Count > 0 then begin
        FLine := VMultiPolygon.Item[0];
      end;
    end else begin
      Assert(False);
      FLine := nil;
    end;
  end;
end;

function TBitmapLayerProviderInPolygon.GetTile(
  AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  const AProjectionInfo: IProjectionInfo;
  const ATile: TPoint
): IBitmap32Static;
var
  VMapRect: TDoubleRect;
begin
  VMapRect := AProjectionInfo.GeoConverter.TilePos2PixelRectFloat(ATile, AProjectionInfo.Zoom);
  if FLine.IsRectIntersectPolygon(VMapRect) then begin
    Result :=
      FSourceProvider.GetTile(
        AOperationID,
        ACancelNotifier,
        AProjectionInfo,
        ATile
      );
  end else begin
    Result := nil;
  end;
end;

end.
