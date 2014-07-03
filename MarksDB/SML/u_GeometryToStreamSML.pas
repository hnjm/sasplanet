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

unit u_GeometryToStreamSML;

interface

uses
  Classes,
  i_GeometryLonLat,
  i_GeometryToStream,
  u_BaseInterfacedObject;

type
  TGeometryToStreamSML = class(TBaseInterfacedObject, IGeometryToStream)
  private
    procedure SavePoint(
      const AGeometry: IGeometryLonLatPoint;
      const AStream: TStream
    );
    procedure SaveSingleLine(
      const AGeometry: IGeometryLonLatSingleLine;
      const AStream: TStream
    );
    procedure SaveMultiLine(
      const AGeometry: IGeometryLonLatMultiLine;
      const AStream: TStream
    );
    procedure SaveSinglePolygon(
      const AGeometry: IGeometryLonLatSinglePolygon;
      const AStream: TStream
    );
    procedure SaveMultiPolygon(
      const AGeometry: IGeometryLonLatMultiPolygon;
      const AStream: TStream
    );
  private
    procedure Save(
      const AGeometry: IGeometryLonLat;
      const AStream: TStream
    );
  public
    constructor Create();
  end;

implementation

uses
  SysUtils,
  t_GeoTypes,
  i_EnumDoublePoint,
  u_GeoFunc;

type
  TExtendedPoint = record
    X, Y: Extended;
  end;

{ TGeometryToStreamSML }

constructor TGeometryToStreamSML.Create;
begin
  inherited Create;
end;

procedure TGeometryToStreamSML.Save(
  const AGeometry: IGeometryLonLat;
  const AStream: TStream
);
var
  VPoint: IGeometryLonLatPoint;
  VSingleLine: IGeometryLonLatSingleLine;
  VSinglePolygon: IGeometryLonLatSinglePolygon;
  VMultiLine: IGeometryLonLatMultiLine;
  VMultiPolygon: IGeometryLonLatMultiPolygon;
begin
  if Supports(AGeometry, IGeometryLonLatPoint, VPoint) then begin
    SavePoint(VPoint, AStream);
  end else if Supports(AGeometry, IGeometryLonLatSingleLine, VSingleLine) then begin
    SaveSingleLine(VSingleLine, AStream);
  end else if Supports(AGeometry, IGeometryLonLatSinglePolygon, VSinglePolygon) then begin
    SaveSinglePolygon(VSinglePolygon, AStream);
  end else if Supports(AGeometry, IGeometryLonLatMultiLine, VMultiLine) then begin
    SaveMultiLine(VMultiLine, AStream);
  end else if Supports(AGeometry, IGeometryLonLatMultiPolygon, VMultiPolygon) then begin
    SaveMultiPolygon(VMultiPolygon, AStream);
  end else begin
    Assert(False);
  end;
end;

procedure TGeometryToStreamSML.SavePoint(
  const AGeometry: IGeometryLonLatPoint;
  const AStream: TStream
);
var
  VPoint: TExtendedPoint;
begin
  VPoint.X := AGeometry.Point.X;
  VPoint.Y := AGeometry.Point.Y;
  AStream.Write(VPoint, SizeOf(VPoint));
end;

procedure TGeometryToStreamSML.SaveSingleLine(
  const AGeometry: IGeometryLonLatSingleLine;
  const AStream: TStream
);
var
  i: Integer;
  VPoint: TExtendedPoint;
  VEnum: IEnumLonLatPoint;
  VFirstPoint: TDoublePoint;
  VCurrPoint: TDoublePoint;
  VPrevPoint: TDoublePoint;
begin
  VEnum := AGeometry.GetEnum;
  i := 0;
  if VEnum.Next(VFirstPoint) then begin
    VCurrPoint := VFirstPoint;
    VPrevPoint := VCurrPoint;
    VPoint.X := VCurrPoint.X;
    VPoint.Y := VCurrPoint.Y;
    AStream.Write(VPoint, SizeOf(VPoint));
    Inc(i);
    while VEnum.Next(VCurrPoint) do begin
      VPoint.X := VCurrPoint.X;
      VPoint.Y := VCurrPoint.Y;
      AStream.Write(VPoint, SizeOf(VPoint));
      VPrevPoint := VCurrPoint;
      Inc(i);
    end;
  end;
  if (i = 1) or ((i > 1) and DoublePointsEqual(VFirstPoint, VPrevPoint)) then begin
    VPoint.X := CEmptyDoublePoint.X;
    VPoint.Y := CEmptyDoublePoint.Y;
    AStream.Write(VPoint, SizeOf(VPoint));
  end;
end;

procedure TGeometryToStreamSML.SaveMultiLine(
  const AGeometry: IGeometryLonLatMultiLine;
  const AStream: TStream
);
var
  i: Integer;
  VPoint: TExtendedPoint;
  VEnum: IEnumLonLatPoint;
  VFirstPoint: TDoublePoint;
  VCurrPoint: TDoublePoint;
  VPrevPoint: TDoublePoint;
begin
  VEnum := AGeometry.GetEnum;
  i := 0;
  if VEnum.Next(VFirstPoint) then begin
    VCurrPoint := VFirstPoint;
    VPrevPoint := VCurrPoint;
    VPoint.X := VCurrPoint.X;
    VPoint.Y := VCurrPoint.Y;
    AStream.Write(VPoint, SizeOf(VPoint));
    Inc(i);
    while VEnum.Next(VCurrPoint) do begin
      VPoint.X := VCurrPoint.X;
      VPoint.Y := VCurrPoint.Y;
      AStream.Write(VPoint, SizeOf(VPoint));
      VPrevPoint := VCurrPoint;
      Inc(i);
    end;
  end;
  if (i = 1) or ((i > 1) and DoublePointsEqual(VFirstPoint, VPrevPoint)) then begin
    VPoint.X := CEmptyDoublePoint.X;
    VPoint.Y := CEmptyDoublePoint.Y;
    AStream.Write(VPoint, SizeOf(VPoint));
  end;
end;

procedure TGeometryToStreamSML.SaveSinglePolygon(
  const AGeometry: IGeometryLonLatSinglePolygon;
  const AStream: TStream
);
var
  VPoint: TExtendedPoint;
  VEnum: IEnumLonLatPoint;
  VCurrPoint: TDoublePoint;
begin
  VEnum := AGeometry.GetEnum;
  while VEnum.Next(VCurrPoint) do begin
    VPoint.X := VCurrPoint.X;
    VPoint.Y := VCurrPoint.Y;
    AStream.Write(VPoint, SizeOf(VPoint));
  end;
end;

procedure TGeometryToStreamSML.SaveMultiPolygon(
  const AGeometry: IGeometryLonLatMultiPolygon;
  const AStream: TStream
);
var
  VPoint: TExtendedPoint;
  VEnum: IEnumLonLatPoint;
  VCurrPoint: TDoublePoint;
  VLine: IGeometryLonLatSinglePolygon;
begin
  if AGeometry.Count > 0 then begin
    VEnum := AGeometry.GetEnum;
    while VEnum.Next(VCurrPoint) do begin
      VPoint.X := VCurrPoint.X;
      VPoint.Y := VCurrPoint.Y;
      AStream.Write(VPoint, SizeOf(VPoint));
    end;
    VLine := AGeometry.Item[0];
    if VLine.Count > 1 then begin
      VCurrPoint := VLine.Points[0];
      VPoint.X := VCurrPoint.X;
      VPoint.Y := VCurrPoint.Y;
      AStream.Write(VPoint, SizeOf(VPoint));
    end;
  end;
end;

end.

