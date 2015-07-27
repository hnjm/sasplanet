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

unit u_TileIteratorByPolygon;

interface

uses
  Types,
  t_GeoTypes,
  i_CoordConverter,
  i_ProjectionInfo,
  i_TileRect,
  i_TileIterator,
  i_GeometryProjected,
  u_BaseInterfacedObject;

type
  TTileIteratorByPolygon = class(TBaseInterfacedObject, ITileIterator)
  private
    FCurrent: TPoint;
    FTilesRect: TRect;
    FRect: ITileRect;
    FTilesTotal: Int64;
    // ��������������� ������ ���� ���� ����� (��� ��������)
    FSingleLine: IGeometryProjectedSinglePolygon;
    FMultiProjected: IGeometryProjectedMultiPolygon;
    // ��� �����
    FLastUsedLine: IGeometryProjectedSinglePolygon;
    FZoom: Byte;
    FGeoConverter: ICoordConverter;
  private
    function GetTilesTotal: Int64;
    function GetTilesRect: ITileRect;
    function Next(out ATile: TPoint): Boolean;
    procedure Reset;
  private
    function InternalIntersectPolygon(const ARect: TDoubleRect): Boolean;
  public
    constructor Create(
      const AProjection: IProjectionInfo;
      const AProjected: IGeometryProjectedPolygon
    );
  end;

implementation

uses
  SysUtils,
  Math,
  u_TileRect,
  u_GeoFunc;

{ TTileIteratorByPolygon }

constructor TTileIteratorByPolygon.Create(
  const AProjection: IProjectionInfo;
  const AProjected: IGeometryProjectedPolygon
);
var
  VBounds: TDoubleRect;
  VTile: TPoint;
begin
  inherited Create;
  FZoom := AProjection.Zoom;
  FGeoConverter := AProjection.GeoConverter;
  if not Assigned(AProjected) then begin
    FTilesTotal := 0;
    FTilesRect := Rect(0, 0, 0, 0);
    Assert(False);
    FRect := TTileRect.Create(AProjection, FTilesRect);
  end else begin
    if Supports(AProjected, IGeometryProjectedSinglePolygon, FSingleLine) then begin
      FMultiProjected := nil;
    end else if Supports(AProjected, IGeometryProjectedMultiPolygon, FMultiProjected) then begin
      // � ����������� �� ����� ���������...
      if (FMultiProjected.Count = 1) then begin
        // ...����� ������ �� ����� �������
        FSingleLine := FMultiProjected.Item[0];
      end else begin
        // ...����� ������ � �����
        FSingleLine := nil;
      end;
    end else begin
      Assert(False);
      FSingleLine := nil;
      FMultiProjected := nil;
      FTilesTotal := 0;
      FTilesRect := Rect(0, 0, 0, 0);
      FRect := TTileRect.Create(AProjection, FTilesRect);
      Exit;
    end;
    VBounds := AProjected.Bounds;

    FTilesRect :=
      RectFromDoubleRect(
        FGeoConverter.PixelRectFloat2TileRectFloat(VBounds, FZoom),
        rrOutside
      );
    FRect := TTileRect.Create(AProjection, FTilesRect);
    Reset;
    FTilesTotal := 0;
    while Next(VTile) do begin
      Inc(FTilesTotal);
    end;
    Reset;
  end;
end;

function TTileIteratorByPolygon.GetTilesRect: ITileRect;
begin
  Result := FRect;
end;

function TTileIteratorByPolygon.GetTilesTotal: Int64;
begin
  Result := FTilesTotal;
end;

function TTileIteratorByPolygon.InternalIntersectPolygon(const ARect: TDoubleRect): Boolean;
var
  i: Integer;
  VLine: IGeometryProjectedSinglePolygon;
begin
  if (FSingleLine <> nil) then begin
    // ���� ������� - ������ ��� � ���������
    Result := FSingleLine.IsRectIntersectPolygon(ARect);
    Exit;
  end;

  // ��� ��� �������� ����� ������������ ������
  // ��-������ ��� ��������� ����� � ������� ������� (� ���)
  // ��-������ �������� �������� ��������� � Bounds
  // Result := FProjected.IsRectIntersectPolygon(ARect);

  // ��������� ���
  if (FLastUsedLine <> nil) then begin
    Result := FLastUsedLine.IsRectIntersectPolygon(ARect);
    if Result then begin
      Exit;
    end;
  end;

  // ��������� �� � �����
  for i := 0 to FMultiProjected.Count - 1 do begin
    VLine := FMultiProjected.GetItem(i);
    if (Pointer(VLine) <> Pointer(FLastUsedLine)) then begin
      if VLine.IsRectIntersectPolygon(ARect) then begin
      // �������
        Result := TRUE;
        FLastUsedLine := VLine;
        Exit;
      end;
    end;
  end;

  Result := FALSE;
end;

function TTileIteratorByPolygon.Next(out ATile: TPoint): Boolean;
var
  VRect: TDoubleRect;
begin
  Result := False;
  while FCurrent.X < FTilesRect.Right do begin
    while FCurrent.Y < FTilesRect.Bottom do begin
      VRect := FGeoConverter.TilePos2PixelRectFloat(FCurrent, FZoom);
      if InternalIntersectPolygon(VRect) then begin
        ATile := FCurrent;
        Result := True;
      end;
      Inc(FCurrent.Y);
      if Result then begin
        Break;
      end;
    end;
    if Result then begin
      Break;
    end;
    if FCurrent.Y >= FTilesRect.Bottom then begin
      FCurrent.Y := FTilesRect.Top;
      Inc(FCurrent.X);
    end;
  end;
end;

procedure TTileIteratorByPolygon.Reset;
begin
  inherited;
  FCurrent := FTilesRect.TopLeft;
  FLastUsedLine := nil;
end;

end.
