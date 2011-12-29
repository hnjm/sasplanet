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

unit u_LocalCoordConverter;

interface

uses
  Types,
  t_GeoTypes,
  i_CoordConverter,
  i_ProjectionInfo,
  i_LocalCoordConverter;

type
  TLocalCoordConverterBase = class(TInterfacedObject, ILocalCoordConverter, IProjectionInfo)
  private
    FLocalRect: TRect;
    FLocalSize: TPoint;
    FLocalCenter: TDoublePoint;
    FZoom: Byte;
    FGeoConverter: ICoordConverter;
    FLocalTopLeftAtMap: TDoublePoint;
  protected
    function GetIsSameConverter(AConverter: ILocalCoordConverter): Boolean;
    function GetIsSameProjectionInfo(AProjection: IProjectionInfo): Boolean;

    function GetLocalRect: TRect;
    function GetLocalRectSize: TPoint;

    function GetProjectionInfo: IProjectionInfo;
    function GetZoom: Byte;
    function GetGeoConverter: ICoordConverter;

    function LocalPixel2MapPixel(const APoint: TPoint): TPoint;
    function LocalPixel2MapPixelFloat(const APoint: TPoint): TDoublePoint;
    function LocalPixelFloat2MapPixelFloat(const APoint: TDoublePoint): TDoublePoint; virtual; abstract;
    function MapPixel2LocalPixel(const APoint: TPoint): TPoint;
    function MapPixel2LocalPixelFloat(const APoint: TPoint): TDoublePoint;
    function MapPixelFloat2LocalPixelFloat(const APoint: TDoublePoint): TDoublePoint; virtual; abstract;

    function LocalRect2MapRect(const ARect: TRect): TRect;
    function LocalRect2MapRectFloat(const ARect: TRect): TDoubleRect;
    function LocalRectFloat2MapRectFloat(const ARect: TDoubleRect): TDoubleRect;
    function MapRect2LocalRect(const ARect: TRect): TRect;
    function MapRect2LocalRectFloat(const ARect: TRect): TDoubleRect;
    function MapRectFloat2LocalRectFloat(const ARect: TDoubleRect): TDoubleRect;

    function LonLat2LocalPixel(const APoint: TDoublePoint): TPoint;
    function LonLat2LocalPixelFloat(const APoint: TDoublePoint): TDoublePoint;
    function LonLatRect2LocalRectFloat(const ARect: TDoubleRect): TDoubleRect;

    function GetCenterMapPixelFloat: TDoublePoint;
    function GetCenterLonLat: TDoublePoint;
    function GetRectInMapPixel: TRect;
    function GetRectInMapPixelFloat: TDoubleRect;
  public
    constructor Create(
      ALocalRect: TRect;
      AZoom: Byte;
      AGeoConverter: ICoordConverter;
      ALocalTopLeftAtMap: TDoublePoint
    );
  end;


  TLocalCoordConverter = class(TLocalCoordConverterBase)
  private
    FMapScale: TDoublePoint;
  protected
    function LocalPixelFloat2MapPixelFloat(const APoint: TDoublePoint): TDoublePoint; override;
    function MapPixelFloat2LocalPixelFloat(const APoint: TDoublePoint): TDoublePoint; override;
  public
    constructor Create(
      ALocalRect: TRect;
      AZoom: Byte;
      AGeoConverter: ICoordConverter;
      AMapScale: TDoublePoint;
      ALocalTopLeftAtMap: TDoublePoint
    );
  end;

  TLocalCoordConverterNoScale = class(TLocalCoordConverterBase)
  protected
    function LocalPixelFloat2MapPixelFloat(const APoint: TDoublePoint): TDoublePoint; override;
    function MapPixelFloat2LocalPixelFloat(const APoint: TDoublePoint): TDoublePoint; override;
  end;

implementation

constructor TLocalCoordConverterBase.Create(ALocalRect: TRect; AZoom: Byte;
  AGeoConverter: ICoordConverter; ALocalTopLeftAtMap: TDoublePoint);
begin
  FLocalRect := ALocalRect;
  FLocalSize.X := FLocalRect.Right - FLocalRect.Left;
  FLocalSize.Y := FLocalRect.Bottom - FLocalRect.Top;
  FLocalCenter.X := FLocalRect.Left + FLocalSize.X / 2;
  FLocalCenter.Y := FLocalRect.Left + FLocalSize.Y / 2;
  FZoom := AZoom;
  FGeoConverter := AGeoConverter;
  FLocalTopLeftAtMap := ALocalTopLeftAtMap;
end;

function TLocalCoordConverterBase.GetCenterLonLat: TDoublePoint;
var
  VMapPixel: TDoublePoint;
begin
  VMapPixel := LocalPixelFloat2MapPixelFloat(FLocalCenter);
  FGeoConverter.CheckPixelPosFloat(VMapPixel, FZoom, True);
  Result := FGeoConverter.PixelPosFloat2LonLat(VMapPixel, FZoom);
end;

function TLocalCoordConverterBase.GetCenterMapPixelFloat: TDoublePoint;
begin
  Result := LocalPixelFloat2MapPixelFloat(FLocalCenter);
end;

function TLocalCoordConverterBase.GetGeoConverter: ICoordConverter;
begin
  Result := FGeoConverter;
end;

function TLocalCoordConverterBase.GetIsSameConverter(
  AConverter: ILocalCoordConverter): Boolean;
var
  VSelf: ILocalCoordConverter;
begin
  VSelf := Self;
  if VSelf = AConverter then begin
    Result := True;
  end else begin
    Result := False;
    if FZoom = AConverter.GetZoom then begin
      if EqualRect(FLocalRect, AConverter.GetLocalRect) then begin
        if FGeoConverter.IsSameConverter(AConverter.GetGeoConverter) then begin
          if EqualRect(AConverter.GetRectInMapPixel, GetRectInMapPixel) then begin
            Result := True;
          end;
        end;
      end;
    end;
  end;
end;

function TLocalCoordConverterBase.GetIsSameProjectionInfo(
  AProjection: IProjectionInfo
): Boolean;
var
  VSelf: IProjectionInfo;
begin
  VSelf := Self;
  if VSelf = AProjection then begin
    Result := True;
  end else begin
    Result := False;
    if FZoom = AProjection.Zoom then begin
      if FGeoConverter.IsSameConverter(AProjection.GeoConverter) then begin
        Result := True;
      end;
    end;
  end;
end;

function TLocalCoordConverterBase.GetLocalRect: TRect;
begin
  Result := FLocalRect;
end;

function TLocalCoordConverterBase.GetLocalRectSize: TPoint;
begin
  Result := FLocalSize;
end;

function TLocalCoordConverterBase.GetProjectionInfo: IProjectionInfo;
begin
  Result := Self;
end;

function TLocalCoordConverterBase.GetRectInMapPixel: TRect;
begin
  Result := LocalRect2MapRect(GetLocalRect);
end;

function TLocalCoordConverterBase.GetRectInMapPixelFloat: TDoubleRect;
begin
  Result := LocalRect2MapRectFloat(GetLocalRect);
end;

function TLocalCoordConverterBase.GetZoom: Byte;
begin
  Result := FZoom;
end;

function TLocalCoordConverterBase.LocalPixel2MapPixel(const APoint: TPoint): TPoint;
var
  VResultPoint: TDoublePoint;
begin
  VResultPoint := LocalPixel2MapPixelFloat(APoint);
  Result := Point(Trunc(VResultPoint.X), Trunc(VResultPoint.Y));
end;

function TLocalCoordConverterBase.LocalPixel2MapPixelFloat(
  const APoint: TPoint): TDoublePoint;
var
  VSourcePoint: TDoublePoint;
begin
  VSourcePoint.X := APoint.X;
  VSourcePoint.Y := APoint.Y;
  Result := LocalPixelFloat2MapPixelFloat(VSourcePoint);
end;

function TLocalCoordConverterBase.LocalRect2MapRect(const ARect: TRect): TRect;
begin
  Result.TopLeft := LocalPixel2MapPixel(ARect.TopLeft);
  Result.BottomRight := LocalPixel2MapPixel(ARect.BottomRight);
end;

function TLocalCoordConverterBase.LocalRect2MapRectFloat(
  const ARect: TRect): TDoubleRect;
begin
  Result.TopLeft := LocalPixel2MapPixelFloat(ARect.TopLeft);
  Result.BottomRight := LocalPixel2MapPixelFloat(ARect.BottomRight);
end;

function TLocalCoordConverterBase.LocalRectFloat2MapRectFloat(
  const ARect: TDoubleRect): TDoubleRect;
begin
  Result.TopLeft := LocalPixelFloat2MapPixelFloat(ARect.TopLeft);
  Result.BottomRight := LocalPixelFloat2MapPixelFloat(ARect.BottomRight);
end;

function TLocalCoordConverterBase.LonLat2LocalPixel(
  const APoint: TDoublePoint): TPoint;
var
  VResultPoint: TDoublePoint;
begin
  VResultPoint := LonLat2LocalPixelFloat(APoint);
  Result := Point(Trunc(VResultPoint.X), Trunc(VResultPoint.Y));
end;

function TLocalCoordConverterBase.LonLat2LocalPixelFloat(
  const APoint: TDoublePoint): TDoublePoint;
begin
  Result :=
    MapPixelFloat2LocalPixelFloat(
      FGeoConverter.LonLat2PixelPosFloat(APoint, FZoom)
    );
end;

function TLocalCoordConverterBase.LonLatRect2LocalRectFloat(
  const ARect: TDoubleRect): TDoubleRect;
begin
  Result :=
    MapRectFloat2LocalRectFloat(
      FGeoConverter.LonLatRect2PixelRectFloat(ARect, FZoom)
    );
end;

function TLocalCoordConverterBase.MapPixel2LocalPixel(const APoint: TPoint): TPoint;
var
  VResultPoint: TDoublePoint;
begin
  VResultPoint := MapPixel2LocalPixelFloat(APoint);
  Result := Point(Trunc(VResultPoint.X), Trunc(VResultPoint.Y));
end;

function TLocalCoordConverterBase.MapPixel2LocalPixelFloat(
  const APoint: TPoint): TDoublePoint;
var
  VSourcePoint: TDoublePoint;
begin
  VSourcePoint.X := APoint.X;
  VSourcePoint.Y := APoint.Y;
  Result := MapPixelFloat2LocalPixelFloat(VSourcePoint);
end;

function TLocalCoordConverterBase.MapRect2LocalRect(const ARect: TRect): TRect;
begin
  Result.TopLeft := MapPixel2LocalPixel(ARect.TopLeft);
  Result.BottomRight := MapPixel2LocalPixel(ARect.BottomRight);
end;

function TLocalCoordConverterBase.MapRect2LocalRectFloat(
  const ARect: TRect): TDoubleRect;
begin
  Result.TopLeft := MapPixel2LocalPixelFloat(ARect.TopLeft);
  Result.BottomRight := MapPixel2LocalPixelFloat(ARect.BottomRight);
end;

function TLocalCoordConverterBase.MapRectFloat2LocalRectFloat(
  const ARect: TDoubleRect): TDoubleRect;
begin
  Result.TopLeft := MapPixelFloat2LocalPixelFloat(ARect.TopLeft);
  Result.BottomRight := MapPixelFloat2LocalPixelFloat(ARect.BottomRight);
end;

{ TLocalCoordConverter }

constructor TLocalCoordConverter.Create(
  ALocalRect: TRect;
  AZoom: Byte;
  AGeoConverter: ICoordConverter;
  AMapScale, ALocalTopLeftAtMap: TDoublePoint);
begin
  inherited Create(ALocalRect, AZoom, AGeoConverter, ALocalTopLeftAtMap);
  FMapScale := AMapScale;
end;

function TLocalCoordConverter.LocalPixelFloat2MapPixelFloat(
  const APoint: TDoublePoint): TDoublePoint;
begin
  Result.X := APoint.X  / FMapScale.X + FLocalTopLeftAtMap.X;
  Result.Y := APoint.Y  / FMapScale.Y + FLocalTopLeftAtMap.Y;
end;

function TLocalCoordConverter.MapPixelFloat2LocalPixelFloat(
  const APoint: TDoublePoint): TDoublePoint;
begin
  Result.X := (APoint.X - FLocalTopLeftAtMap.X) * FMapScale.X;
  Result.Y := (APoint.Y - FLocalTopLeftAtMap.Y) * FMapScale.Y;
end;

{ TLocalCoordConverterNoScale }

function TLocalCoordConverterNoScale.LocalPixelFloat2MapPixelFloat(
  const APoint: TDoublePoint): TDoublePoint;
begin
  Result.X := APoint.X + FLocalTopLeftAtMap.X;
  Result.Y := APoint.Y + FLocalTopLeftAtMap.Y;
end;

function TLocalCoordConverterNoScale.MapPixelFloat2LocalPixelFloat(
  const APoint: TDoublePoint): TDoublePoint;
begin
  Result.X := APoint.X - FLocalTopLeftAtMap.X;
  Result.Y := APoint.Y - FLocalTopLeftAtMap.Y;
end;

end.
