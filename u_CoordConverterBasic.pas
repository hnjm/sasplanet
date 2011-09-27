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

unit u_CoordConverterBasic;

interface

uses
  Types,
  i_CoordConverter,
  t_GeoTypes,
  u_CoordConverterAbstract;

type
  TCoordConverterBasic = class(TCoordConverterAbstract, ICoordConverterSimple)
  protected
    FValidLonLatRect: TDoubleRect;
    function GetValidLonLatRect: TDoubleRect; virtual;

    procedure CheckZoomInternal(var AZoom: Byte); override;

    procedure CheckPixelPosInternal(var XY: TPoint; var Azoom: byte); override;
    procedure CheckPixelPosStrictInternal(var XY: TPoint; var Azoom: byte); override;
    procedure CheckPixelPosFloatInternal(var XY: TDoublePoint; var Azoom: byte); override;
    procedure CheckPixelRectInternal(var XY: TRect; var Azoom: byte); override;
    procedure CheckPixelRectFloatInternal(var XY: TDoubleRect; var Azoom: byte); override;

    procedure CheckTilePosInternal(var XY: TPoint; var Azoom: byte); override;
    procedure CheckTilePosStrictInternal(var XY: TPoint; var Azoom: byte); override;
    procedure CheckTilePosFloatInternal(var XY: TDoublePoint; var Azoom: byte); override;
    procedure CheckTileRectInternal(var XY: TRect; var Azoom: byte); override;
    procedure CheckTileRectFloatInternal(var XY: TDoubleRect; var Azoom: byte); override;

    procedure CheckRelativePosInternal(var XY: TDoublePoint); override;
    procedure CheckRelativeRectInternal(var XY: TDoubleRect); override;

    procedure CheckLonLatPosInternal(var XY: TDoublePoint); override;
    procedure CheckLonLatRectInternal(var XY: TDoubleRect); override;

    function TilesAtZoomInternal(AZoom: byte): Longint; override;
    function TilesAtZoomFloatInternal(AZoom: byte): Double; override;
    function PixelsAtZoomInternal(AZoom: byte): Longint; override;
    function PixelsAtZoomFloatInternal(AZoom: byte): Double; override;


    function PixelPos2TilePosInternal(const XY: TPoint; Azoom: byte): TPoint; override;
    function PixelPos2TilePosFloatInternal(const XY: TPoint; Azoom: byte): TDoublePoint; override;
    function PixelPos2RelativeInternal(const XY: TPoint; Azoom: byte): TDoublePoint; override;
    function PixelPos2LonLatInternal(const XY: TPoint; Azoom: byte): TDoublePoint; override;

    function PixelPosFloat2PixelPosInternal(const XY: TDoublePoint; Azoom: byte): TPoint; override;
    function PixelPosFloat2TilePosInternal(const XY: TDoublePoint; Azoom: byte): TPoint; override;
    function PixelPosFloat2TilePosFloatInternal(const XY: TDoublePoint; Azoom: byte): TDoublePoint; override;
    function PixelPosFloat2RelativeInternal(const XY: TDoublePoint; Azoom: byte): TDoublePoint; override;
    function PixelPosFloat2LonLatInternal(const XY: TDoublePoint; Azoom: byte): TDoublePoint; override;

    function PixelRect2TileRectInternal(const XY: TRect; AZoom: byte): TRect; override;
    function PixelRect2TileRectFloatInternal(const XY: TRect; AZoom: byte): TDoubleRect; override;
    function PixelRect2RelativeRectInternal(const XY: TRect; AZoom: byte): TDoubleRect; override;
    function PixelRect2LonLatRectInternal(const XY: TRect; AZoom: byte): TDoubleRect; override;

    function PixelRectFloat2PixelRectInternal(const XY: TDoubleRect; AZoom: byte): TRect; override;
    function PixelRectFloat2TileRectInternal(const XY: TDoubleRect; AZoom: byte): TRect; override;
    function PixelRectFloat2TileRectFloatInternal(const XY: TDoubleRect; AZoom: byte): TDoubleRect; override;
    function PixelRectFloat2RelativeRectInternal(const XY: TDoubleRect; AZoom: byte): TDoubleRect; override;
    function PixelRectFloat2LonLatRectInternal(const XY: TDoubleRect; AZoom: byte): TDoubleRect; override;

    function TilePos2PixelPosInternal(const XY: TPoint; Azoom: byte): TPoint; override;
    function TilePos2PixelRectInternal(const XY: TPoint; Azoom: byte): TRect; override;
    function TilePos2LonLatRectInternal(const XY: TPoint; Azoom: byte): TDoubleRect; override;
    function TilePos2LonLatInternal(const XY: TPoint; Azoom: byte): TDoublePoint; override;
    function TilePos2RelativeInternal(const XY: TPoint; Azoom: byte): TDoublePoint; override;
    function TilePos2RelativeRectInternal(const XY: TPoint; Azoom: byte): TDoubleRect; override;

    function TilePosFloat2TilePosInternal(const XY: TDoublePoint; Azoom: byte): TPoint; override;
    function TilePosFloat2PixelPosInternal(const XY: TDoublePoint; Azoom: byte): TPoint; override;
    function TilePosFloat2PixelPosFloatInternal(const XY: TDoublePoint; Azoom: byte): TDoublePoint; override;
    function TilePosFloat2RelativeInternal(const XY: TDoublePoint; Azoom: byte): TDoublePoint; override;
    function TilePosFloat2LonLatInternal(const XY: TDoublePoint; Azoom: byte): TDoublePoint; override;

    function TileRect2PixelRectInternal(const XY: TRect; AZoom: byte): TRect; override;
    function TileRect2RelativeRectInternal(const XY: TRect; AZoom: byte): TDoubleRect; override;
    function TileRect2LonLatRectInternal(const XY: TRect; Azoom: byte): TDoubleRect; override;

    function TileRectFloat2TileRectInternal(const XY: TDoubleRect; AZoom: byte): TRect; override;
    function TileRectFloat2PixelRectInternal(const XY: TDoubleRect; AZoom: byte): TRect; override;
    function TileRectFloat2PixelRectFloatInternal(const XY: TDoubleRect; AZoom: byte): TDoubleRect; override;
    function TileRectFloat2RelativeRectInternal(const XY: TDoubleRect; AZoom: byte): TDoubleRect; override;
    function TileRectFloat2LonLatRectInternal(const XY: TDoubleRect; Azoom: byte): TDoubleRect; override;

    function Relative2PixelInternal(const XY: TDoublePoint; Azoom: byte): TPoint; override;
    function Relative2PixelPosFloatInternal(const XY: TDoublePoint; Azoom: byte): TDoublePoint; override;
    function Relative2TileInternal(const XY: TDoublePoint; Azoom: byte): TPoint; override;
    function Relative2TilePosFloatInternal(const XY: TDoublePoint; Azoom: byte): TDoublePoint; override;

    function RelativeRect2PixelRectInternal(const XY: TDoubleRect; Azoom: byte): TRect; override;
    function RelativeRect2PixelRectFloatInternal(const XY: TDoubleRect; Azoom: byte): TDoubleRect; override;
    function RelativeRect2TileRectInternal(const XY: TDoubleRect; Azoom: byte): TRect; override;
    function RelativeRect2TileRectFloatInternal(const XY: TDoubleRect; Azoom: byte): TDoubleRect; override;
    function RelativeRect2LonLatRectInternal(const XY: TDoubleRect): TDoubleRect; override;


    function LonLat2PixelPosInternal(const Ll: TDoublePoint; Azoom: byte): Tpoint; override;
    function LonLat2PixelPosFloatInternal(const Ll: TDoublePoint; Azoom: byte): TDoublePoint; override;
    function LonLat2TilePosInternal(const Ll: TDoublePoint; Azoom: byte): Tpoint; override;
    function LonLat2TilePosFloatInternal(const Ll: TDoublePoint; Azoom: byte): TDoublePoint; override;

    function LonLatRect2RelativeRectInternal(const XY: TDoubleRect): TDoubleRect; override;
    function LonLatRect2PixelRectInternal(const XY: TDoubleRect; Azoom: byte): TRect; override;
    function LonLatRect2PixelRectFloatInternal(const XY: TDoubleRect; Azoom: byte): TDoubleRect; override;
    function LonLatRect2TileRectInternal(const XY: TDoubleRect; Azoom: byte): TRect; override;
    function LonLatRect2TileRectFloatInternal(const XY: TDoubleRect; Azoom: byte): TDoubleRect; override;
  public
    function CheckZoom(var AZoom: Byte): boolean; override;
    function CheckTilePos(var XY: TPoint; var Azoom: byte; ACicleMap: Boolean): boolean; override;
    function CheckTilePosStrict(var XY: TPoint; var Azoom: byte; ACicleMap: Boolean): boolean; override;
    function CheckTileRect(var XY: TRect; var Azoom: byte): boolean; override;

    function CheckPixelPos(var XY: TPoint; var Azoom: byte; ACicleMap: Boolean): boolean; override;
    function CheckPixelPosFloat(var XY: TDoublePoint; var Azoom: byte; ACicleMap: Boolean): boolean; override;
    function CheckPixelPosStrict(var XY: TPoint; var Azoom: byte; ACicleMap: Boolean): boolean; override;
    function CheckPixelPosFloatStrict(var XY: TDoublePoint; var Azoom: byte; ACicleMap: Boolean): boolean; override;
    function CheckPixelRect(var XY: TRect; var Azoom: byte): boolean; override;
    function CheckPixelRectFloat(var XY: TDoubleRect; var Azoom: byte): boolean; override;

    function CheckRelativePos(var XY: TDoublePoint): boolean; override;
    function CheckRelativeRect(var XY: TDoubleRect): boolean; override;

    function CheckLonLatPos(var XY: TDoublePoint): boolean; override;
    function CheckLonLatRect(var XY: TDoubleRect): boolean; override;

    function Pos2LonLat(const AXY: TPoint; Azoom: byte): TDoublePoint; virtual; stdcall;
    function LonLat2Pos(const AXY: TDoublePoint; Azoom: byte): Tpoint; virtual; stdcall;
    function GetTileSplitCode: Integer; override;
    function GetTileSize(const XY: TPoint; const Azoom: byte): TPoint; override;
    procedure AfterConstruction; override;
  end;

const
  CTileRelativeEpsilon = (1 / (1 shl 30 + (1 shl 30 - 1))) / 2;

implementation

uses
  SysUtils,
  Math,
  c_CoordConverter;

function TCoordConverterBasic.GetValidLonLatRect: TDoubleRect;
begin
  Result := TilePos2LonLatRectInternal(Point(0, 0), 0);
end;

procedure TCoordConverterBasic.AfterConstruction;
begin
  inherited;
  FValidLonLatRect := GetValidLonLatRect;
end;

function TCoordConverterBasic.LonLat2Pos(const AXY: TDoublePoint;
  Azoom: byte): Tpoint;
var
  VXY: TDoublePoint;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckLonLatPosInternal(VXY);
  if Azoom > 23 then begin
    VZoom := VZoom - 8;
    CheckZoomInternal(VZoom);
    Result := LonLat2PixelPosInternal(VXY, Vzoom);
  end else begin
    CheckZoomInternal(VZoom);
    Result := LonLat2TilePosInternal(VXY, Vzoom);
  end;
end;

function TCoordConverterBasic.Pos2LonLat(const AXY: TPoint;
  Azoom: byte): TDoublePoint;
var
  VXY: TPoint;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  if Azoom > 23 then begin
    VZoom := VZoom - 8;
    CheckPixelPosInternal(VXY, VZoom);
    Result := PixelPos2LonLatInternal(VXY, Vzoom);
  end else begin
    CheckTilePosInternal(VXY, VZoom);
    Result := TilePos2LonLatInternal(VXY, Vzoom);
  end;
end;

function TCoordConverterBasic.GetTileSplitCode: Integer;
begin
  Result := CTileSplitQuadrate256x256;
end;

function TCoordConverterBasic.GetTileSize(const XY: TPoint;
  const Azoom: byte): TPoint;
begin
  Result := Point(256, 256);
end;

//------------------------------------------------------------------------------
procedure TCoordConverterBasic.CheckZoomInternal(var AZoom: Byte);
begin
  if AZoom > 23 then begin
    Assert(False, '������� ������� ��� ' + IntToStr(AZoom));
    AZoom := 23;
  end;
end;

procedure TCoordConverterBasic.CheckTilePosInternal(var XY: TPoint; var Azoom: byte);
var
  VTilesAtZoom: Integer;
begin
  if AZoom > 23 then begin
    Assert(False, '������� ������� ��� ' + IntToStr(AZoom));
    AZoom := 23;
  end;
  VTilesAtZoom := TilesAtZoomInternal(Azoom);
  if XY.X < 0 then begin
    Assert(False, '���������� X ����� �� ����� ���� ������ ����');
    XY.X := 0;
  end else begin
    if XY.X > VTilesAtZoom then begin
      Assert(False, '���������� X ����� �� ���� ���� �� ����� ���� ������ ' + IntToStr(VTilesAtZoom));
      XY.X := VTilesAtZoom;
    end;
  end;

  if XY.Y < 0 then begin
    Assert(False, '���������� Y ����� �� ����� ���� ������ ����');
    XY.Y := 0;
  end else begin
    if XY.Y > VTilesAtZoom then begin
      Assert(False, '���������� Y ����� �� ���� ���� �� ����� ���� ������ ' + IntToStr(VTilesAtZoom));
      XY.Y := VTilesAtZoom;
    end;
  end;
end;

procedure TCoordConverterBasic.CheckTileRectInternal(var XY: TRect; var Azoom: byte);
var
  VTilesAtZoom: Integer;
begin
  if AZoom > 23 then begin
    Assert(False, '������� ������� ��� ' + IntToStr(AZoom));
    AZoom := 23;
  end;
  VTilesAtZoom := TilesAtZoomInternal(Azoom);
  if XY.Left < 0 then begin
    Assert(False, '���������� X ����� �� ����� ���� ������ ����');
    XY.Left := 0;
  end else begin
    if XY.Left > VTilesAtZoom then begin
      Assert(False, '���������� X ����� �� ���� ���� �� ����� ���� ������ ' + IntToStr(VTilesAtZoom));
      XY.Left := VTilesAtZoom;
    end;
  end;
  if XY.Top < 0 then begin
    Assert(False, '���������� Y ����� �� ����� ���� ������ ����');
    XY.Top := 0;
  end else begin
    if XY.Top > VTilesAtZoom then begin
      Assert(False, '���������� Y ����� �� ���� ���� �� ����� ���� ������ ' + IntToStr(VTilesAtZoom));
      XY.Top := VTilesAtZoom;
    end;
  end;
  if XY.Right < 0 then begin
    Assert(False, '���������� X ����� �� ����� ���� ������ ����');
    XY.Right := 0;
  end else begin
    if XY.Right > VTilesAtZoom then begin
      Assert(False, '���������� X ����� �� ���� ���� �� ����� ���� ������ ' + IntToStr(VTilesAtZoom));
      XY.Right := VTilesAtZoom;
    end;
  end;
  if XY.Bottom < 0 then begin
    Assert(False, '���������� Y ����� �� ����� ���� ������ ����');
    XY.Bottom := 0;
  end else begin
    if XY.Bottom > VTilesAtZoom then begin
      Assert(False, '���������� Y ����� �� ���� ���� �� ����� ���� ������ ' + IntToStr(VTilesAtZoom));
      XY.Bottom := VTilesAtZoom;
    end;
  end;
end;

procedure TCoordConverterBasic.CheckTilePosStrictInternal(var XY: TPoint; var Azoom: byte);
var
  VTilesAtZoom: Integer;
begin
  if AZoom > 23 then begin
    Assert(False, '������� ������� ��� ' + IntToStr(AZoom));
    AZoom := 23;
  end;
  VTilesAtZoom := TilesAtZoomInternal(Azoom);
  if XY.X < 0 then begin
    Assert(False, '���������� X ����� �� ����� ���� ������ ����');
    XY.X := 0;
  end else begin
    if XY.X >= VTilesAtZoom then begin
      Assert(False, '���������� X ����� �� ���� ���� �� ����� ���� ������ ��� ������ ' + IntToStr(VTilesAtZoom));
      XY.X := VTilesAtZoom - 1;
    end;
  end;
  if XY.Y < 0 then begin
    Assert(False, '���������� Y ����� �� ����� ���� ������ ����');
    XY.Y := 0;
  end else begin
    if XY.Y >= VTilesAtZoom then begin
      Assert(False, '���������� Y ����� �� ���� ���� �� ����� ���� ������ ��� ������ ' + IntToStr(VTilesAtZoom));
      XY.Y := VTilesAtZoom - 1;
    end;
  end;
end;

procedure TCoordConverterBasic.CheckPixelPosInternal(var XY: TPoint; var Azoom: byte);
var
  VPixelsAtZoom: Integer;
begin
  if AZoom > 23 then begin
    Assert(False, '������� ������� ��� ' + IntToStr(AZoom));
    AZoom := 23;
  end;
  VPixelsAtZoom := PixelsAtZoomInternal(Azoom);

  if XY.X < 0 then begin
    if (Azoom < 23) or (XY.X <> VPixelsAtZoom) then begin
      Assert(False, '���������� X ������� �� ����� ���� ������ ����');
      XY.X := 0;
    end;
  end else begin
    if (Azoom < 23) and (XY.X > VPixelsAtZoom) then begin
      Assert(False, '���������� X ������� �� ���� ���� �� ����� ���� ������ ' + IntToStr(VPixelsAtZoom));
      XY.X := VPixelsAtZoom;
    end;
  end;

  if XY.Y < 0 then begin
    if (Azoom < 23) or (XY.Y <> VPixelsAtZoom) then begin
      Assert(False, '���������� Y ������� �� ����� ���� ������ ����');
      XY.Y := 0;
    end;
  end else begin
    if (Azoom < 23) and (XY.Y > VPixelsAtZoom) then begin
      Assert(False, '���������� Y ������� �� ���� ���� �� ����� ���� ������ ' + IntToStr(VPixelsAtZoom));
      XY.Y := VPixelsAtZoom;
    end;
  end;

end;

procedure TCoordConverterBasic.CheckPixelRectInternal(var XY: TRect; var Azoom: byte);
var
  VPixelsAtZoom: Integer;
begin
  if AZoom > 23 then begin
    Assert(False, '������� ������� ��� ' + IntToStr(AZoom));
    AZoom := 23;
  end;
  VPixelsAtZoom := PixelsAtZoomInternal(Azoom);

  if XY.Left < 0 then begin
    Assert(False, '���������� X ������� �� ����� ���� ������ ����');
    XY.Left := 0;
  end else begin
    if (Azoom < 23) and (XY.Left > VPixelsAtZoom) then begin
      Assert(False, '���������� X ������� �� ���� ���� �� ����� ���� ������ ' + IntToStr(VPixelsAtZoom));
      XY.Left := VPixelsAtZoom;
    end;
  end;

  if XY.Top < 0 then begin
    Assert(False, '���������� Y ������� �� ����� ���� ������ ����');
    XY.Top := 0;
  end else begin
    if (Azoom < 23) and (XY.Top > VPixelsAtZoom) then begin
      Assert(False, '���������� Y ������� �� ���� ���� �� ����� ���� ������ ' + IntToStr(VPixelsAtZoom));
      XY.Top := VPixelsAtZoom;
    end;
  end;

  if XY.Right < 0 then begin
    Assert(False, '���������� X ������� �� ����� ���� ������ ����');
    XY.Right := 0;
  end else begin
    if (Azoom < 23) and (XY.Right > VPixelsAtZoom) then begin
      Assert(False, '���������� X ������� �� ���� ���� �� ����� ���� ������ ' + IntToStr(VPixelsAtZoom));
      XY.Right := VPixelsAtZoom;
    end;
  end;

  if XY.Bottom < 0 then begin
    Assert(False, '���������� Y ������� �� ����� ���� ������ ����');
    XY.Bottom := 0;
  end else begin
    if (Azoom < 23) and (XY.Bottom > VPixelsAtZoom) then begin
      Assert(False, '���������� Y ������� �� ���� ���� �� ����� ���� ������ ' + IntToStr(VPixelsAtZoom));
      XY.Bottom := VPixelsAtZoom;
    end;
  end;
end;

procedure TCoordConverterBasic.CheckPixelPosStrictInternal(var XY: TPoint; var Azoom: byte);
var
  VPixelsAtZoom: Integer;
begin
  if AZoom > 23 then begin
    Assert(False, '������� ������� ��� ' + IntToStr(AZoom));
    AZoom := 23;
  end;
  VPixelsAtZoom := PixelsAtZoomInternal(Azoom);
  if XY.X < 0 then begin
    Assert(False, '���������� X ������� �� ����� ���� ������ ����');
    XY.X := 0;
  end else begin
    if (Azoom < 23) and (XY.X >= VPixelsAtZoom) then begin
      Assert(False, '���������� X ������� �� ���� ���� �� ����� ���� ������ ��� ����� ' + IntToStr(VPixelsAtZoom));
      XY.X := VPixelsAtZoom - 1;
    end;
  end;

  if XY.Y < 0 then begin
    Assert(False, '���������� Y ������� �� ����� ���� ������ ����');
    XY.Y := 0;
  end else begin
    if (Azoom < 23) and (XY.Y > VPixelsAtZoom) then begin
      Assert(False, '���������� Y ������� �� ���� ���� �� ����� ���� ������ ��� �����' + IntToStr(VPixelsAtZoom));
      XY.Y := VPixelsAtZoom - 1;
    end;
  end;
end;

procedure TCoordConverterBasic.CheckRelativePosInternal(var XY: TDoublePoint);
begin
  if XY.X < 0 then begin
    Assert(False, '������������� ���������� X �� ����� ���� ������ ����');
    XY.X := 0;
  end else begin
    if XY.X > 1 then begin
      Assert(False, '������������� ���������� X �� ����� ���� ������ �������');
      XY.X := 1;
    end;
  end;

  if XY.Y < 0 then begin
    Assert(False, '������������� ���������� Y �� ����� ���� ������ ����');
    XY.Y := 0;
  end else begin
    if XY.Y > 1 then begin
      Assert(False, '������������� ���������� Y �� ����� ���� ������ �������');
      XY.Y := 1;
    end;
  end;
end;

procedure TCoordConverterBasic.CheckRelativeRectInternal(var XY: TDoubleRect);
begin
  if XY.Left < 0 then begin
    Assert(False, '������������� ���������� X �� ����� ���� ������ ����');
    XY.Left := 0;
  end else begin
    if XY.Left > 1 then begin
      Assert(False, '������������� ���������� X �� ����� ���� ������ �������');
      XY.Left := 1;
    end;
  end;

  if XY.Top < 0 then begin
    Assert(False, '������������� ���������� Y �� ����� ���� ������ ����');
    XY.Top := 0;
  end else begin
    if XY.Top > 1 then begin
      Assert(False, '������������� ���������� Y �� ����� ���� ������ �������');
      XY.Top := 1;
    end;
  end;

  if XY.Right < 0 then begin
    Assert(False, '������������� ���������� X �� ����� ���� ������ ����');
    XY.Right := 0;
  end else begin
    if XY.Right > 1 then begin
      Assert(False, '������������� ���������� X �� ����� ���� ������ �������');
      XY.Right := 1;
    end;
  end;

  if XY.Bottom < 0 then begin
    Assert(False, '������������� ���������� Y �� ����� ���� ������ ����');
    XY.Bottom := 0;
  end else begin
    if XY.Bottom > 1 then begin
      Assert(False, '������������� ���������� Y �� ����� ���� ������ �������');
      XY.Bottom := 1;
    end;
  end;
end;

procedure TCoordConverterBasic.CheckLonLatPosInternal(var XY: TDoublePoint);
begin
  if XY.X < FValidLonLatRect.Left then begin
    Assert(False, '������� �� ����� ���� ������ ��� ' + FloatToStr(FValidLonLatRect.Left));
    XY.X := FValidLonLatRect.Left;
  end else begin
    if XY.X > FValidLonLatRect.Right then begin
      Assert(False, '������� �� ����� ���� ������ ��� ' + FloatToStr(FValidLonLatRect.Right));
      XY.X := FValidLonLatRect.Right;
    end;
  end;
  if XY.Y < FValidLonLatRect.Bottom then begin
    Assert(False, '������ �� ����� ���� ������ ��� ' + FloatToStr(FValidLonLatRect.Bottom));
    XY.Y := FValidLonLatRect.Bottom;
  end else begin
    if XY.Y > FValidLonLatRect.Top then begin
      Assert(False, '������ �� ����� ���� ������ ��� ' + FloatToStr(FValidLonLatRect.Top));
      XY.Y := FValidLonLatRect.Top;
    end;
  end;
end;

procedure TCoordConverterBasic.CheckLonLatRectInternal(var XY: TDoubleRect);
begin
  if XY.Left < FValidLonLatRect.Left then begin
    Assert(False, '������� �� ����� ���� ������ ��� ' + FloatToStr(FValidLonLatRect.Left));
    XY.Left := FValidLonLatRect.Left;
  end else begin
    if XY.Left > FValidLonLatRect.Right then begin
      Assert(False, '������� �� ����� ���� ������ ��� ' + FloatToStr(FValidLonLatRect.Right));
      XY.Left := FValidLonLatRect.Right;
    end;
  end;
  if XY.Bottom < FValidLonLatRect.Bottom then begin
    Assert(False, '������ �� ����� ���� ������ ��� ' + FloatToStr(FValidLonLatRect.Bottom));
    XY.Bottom := FValidLonLatRect.Bottom;
  end else begin
    if XY.Bottom > FValidLonLatRect.Top then begin
      Assert(False, '������ �� ����� ���� ������ ��� ' + FloatToStr(FValidLonLatRect.Top));
      XY.Bottom := FValidLonLatRect.Top;
    end;
  end;

  if XY.Right < FValidLonLatRect.Left then begin
    Assert(False, '������� �� ����� ���� ������ ��� ' + FloatToStr(FValidLonLatRect.Left));
    XY.Right := FValidLonLatRect.Left;
  end else begin
    if XY.Right > FValidLonLatRect.Right then begin
      Assert(False, '������� �� ����� ���� ������ ��� ' + FloatToStr(FValidLonLatRect.Right));
      XY.Right := FValidLonLatRect.Right;
    end;
  end;
  if XY.Top < FValidLonLatRect.Bottom then begin
    Assert(False, '������ �� ����� ���� ������ ��� ' + FloatToStr(FValidLonLatRect.Bottom));
    XY.Top := FValidLonLatRect.Bottom;
  end else begin
    if XY.Top > FValidLonLatRect.Top then begin
      Assert(False, '������ �� ����� ���� ������ ��� ' + FloatToStr(FValidLonLatRect.Top));
      XY.Top := FValidLonLatRect.Top;
    end;
  end;
end;

procedure TCoordConverterBasic.CheckTilePosFloatInternal(var XY: TDoublePoint;
  var Azoom: byte);
var
  VTilesAtZoom: Double;
begin
  if AZoom > 23 then begin
    Assert(False, '������� ������� ��� ' + FloatToStr(AZoom));
    AZoom := 23;
  end;
  VTilesAtZoom := TilesAtZoomFloatInternal(Azoom);
  if XY.X < 0 then begin
    Assert(False, '���������� X ����� �� ����� ���� ������ ����');
    XY.X := 0;
  end else begin
    if XY.X > VTilesAtZoom then begin
      Assert(False, '���������� X ����� �� ���� ���� �� ����� ���� ������ ' + FloatToStr(VTilesAtZoom));
      XY.X := VTilesAtZoom;
    end;
  end;
  if XY.Y < 0 then begin
    Assert(False, '���������� Y ����� �� ����� ���� ������ ����');
    XY.Y := 0;
  end else begin
    if XY.Y > VTilesAtZoom then begin
      Assert(False, '���������� Y ����� �� ���� ���� �� ����� ���� ������ ' + FloatToStr(VTilesAtZoom));
      XY.Y := VTilesAtZoom;
    end;
  end;
end;

procedure TCoordConverterBasic.CheckPixelRectFloatInternal(
  var XY: TDoubleRect; var Azoom: byte);
var
  VPixelsAtZoom: Double;
begin
  if AZoom > 23 then begin
    Assert(False, '������� ������� ��� ' + FloatToStr(AZoom));
    AZoom := 23;
  end;
  VPixelsAtZoom := PixelsAtZoomFloatInternal(Azoom);

  if XY.Left < 0 then begin
    Assert(False, '���������� X ������� �� ����� ���� ������ ����');
    XY.Left := 0;
  end else begin
    if (XY.Left > VPixelsAtZoom) then begin
      Assert(False, '���������� X ������� �� ���� ���� �� ����� ���� ������ ' + FloatToStr(VPixelsAtZoom));
      XY.Left := VPixelsAtZoom;
    end;
  end;

  if XY.Top < 0 then begin
    Assert(False, '���������� Y ������� �� ����� ���� ������ ����');
    XY.Top := 0;
  end else begin
    if (XY.Top > VPixelsAtZoom) then begin
      Assert(False, '���������� Y ������� �� ���� ���� �� ����� ���� ������ ' + FloatToStr(VPixelsAtZoom));
      XY.Top := VPixelsAtZoom;
    end;
  end;

  if XY.Right < 0 then begin
    Assert(False, '���������� X ������� �� ����� ���� ������ ����');
    XY.Right := 0;
  end else begin
    if (XY.Right > VPixelsAtZoom) then begin
      Assert(False, '���������� X ������� �� ���� ���� �� ����� ���� ������ ' + FloatToStr(VPixelsAtZoom));
      XY.Right := VPixelsAtZoom;
    end;
  end;

  if XY.Bottom < 0 then begin
    Assert(False, '���������� Y ������� �� ����� ���� ������ ����');
    XY.Bottom := 0;
  end else begin
    if (XY.Bottom > VPixelsAtZoom) then begin
      Assert(False, '���������� Y ������� �� ���� ���� �� ����� ���� ������ ' + FloatToStr(VPixelsAtZoom));
      XY.Bottom := VPixelsAtZoom;
    end;
  end;
end;

procedure TCoordConverterBasic.CheckPixelPosFloatInternal(
  var XY: TDoublePoint; var Azoom: byte);
var
  VPixelsAtZoom: Double;
begin
  if AZoom > 23 then begin
    Assert(False, '������� ������� ��� ' + IntToStr(AZoom));
    AZoom := 23;
  end;

  VPixelsAtZoom := PixelsAtZoomFloatInternal(Azoom);
  if XY.X < 0 then begin
    Assert(False, '���������� X ������� �� ����� ���� ������ ����');
    XY.X := 0;
  end else begin
    if XY.X > VPixelsAtZoom then begin
      Assert(False, '���������� X ������� �� ���� ���� �� ����� ���� ������ ' + FloatToStr(VPixelsAtZoom));
      XY.X := VPixelsAtZoom;
    end;
  end;

  if XY.Y < 0 then begin
    Assert(False, '���������� Y ������� �� ����� ���� ������ ����');
    XY.Y := 0;
  end else begin
    if XY.Y > VPixelsAtZoom then begin
      Assert(False, '���������� Y ������� �� ���� ���� �� ����� ���� ������ ' + FloatToStr(VPixelsAtZoom));
      XY.Y := VPixelsAtZoom;
    end;
  end;
end;

procedure TCoordConverterBasic.CheckTileRectFloatInternal(var XY: TDoubleRect;
  var Azoom: byte);
var
  VTilesAtZoom: Double;
begin
  if AZoom > 23 then begin
    Assert(False, '������� ������� ��� ' + FloatToStr(AZoom));
    AZoom := 23;
  end;
  VTilesAtZoom := TilesAtZoomFloatInternal(Azoom);
  if XY.Left < 0 then begin
    Assert(False, '���������� X ����� �� ����� ���� ������ ����');
    XY.Left := 0;
  end else begin
    if XY.Left > VTilesAtZoom then begin
      Assert(False, '���������� X ����� �� ���� ���� �� ����� ���� ������ ��� ����� ' + FloatToStr(VTilesAtZoom));
      XY.Left := VTilesAtZoom;
    end;
  end;
  if XY.Top < 0 then begin
    Assert(False, '���������� Y ����� �� ����� ���� ������ ����');
    XY.Top := 0;
  end else begin
    if XY.Top > VTilesAtZoom then begin
      Assert(False, '���������� Y ����� �� ���� ���� �� ����� ���� ������ ' + FloatToStr(VTilesAtZoom));
      XY.Top := VTilesAtZoom;
    end;
  end;
  if XY.Right < 0 then begin
    Assert(False, '���������� X ����� �� ����� ���� ������ ����');
    XY.Right := 0;
  end else begin
    if XY.Right > VTilesAtZoom then begin
      Assert(False, '���������� X ����� �� ���� ���� �� ����� ���� ������ ' + FloatToStr(VTilesAtZoom));
      XY.Right := VTilesAtZoom;
    end;
  end;
  if XY.Bottom < 0 then begin
    Assert(False, '���������� Y ����� �� ����� ���� ������ ����');
    XY.Bottom := 0;
  end else begin
    if XY.Bottom > VTilesAtZoom then begin
      Assert(False, '���������� Y ����� �� ���� ���� �� ����� ���� ������ ' + FloatToStr(VTilesAtZoom));
      XY.Bottom := VTilesAtZoom;
    end;
  end;
end;

//------------------------------------------------------------------------------
function TCoordConverterBasic.PixelsAtZoomInternal(AZoom: byte): Longint;
begin
  if AZoom < 23 then begin
    Result := 1 shl (AZoom + 8);
  end else begin
    Result := MaxInt;
  end;
end;

function TCoordConverterBasic.PixelsAtZoomFloatInternal(
  AZoom: byte): Double;
begin
  Result := 1 shl AZoom;
  Result := Result * 256;
end;

function TCoordConverterBasic.TilesAtZoomInternal(AZoom: byte): Longint;
begin
  Result := 1 shl AZoom;
end;

function TCoordConverterBasic.TilesAtZoomFloatInternal(
  AZoom: byte): Double;
begin
  Result := 1 shl AZoom;
end;

//------------------------------------------------------------------------------
// PixelPos
function TCoordConverterBasic.PixelPos2RelativeInternal(const XY: TPoint;
  Azoom: byte): TDoublePoint;
var
  VPixelsAtZoom: Double;
begin
  VPixelsAtZoom := PixelsAtZoomFloatInternal(Azoom);
  Result.X := XY.X / VPixelsAtZoom;
  Result.Y := XY.Y / VPixelsAtZoom;
end;

function TCoordConverterBasic.PixelPos2LonLatInternal(const XY: TPoint;
  Azoom: byte): TDoublePoint;
begin
  Result := Relative2LonLatInternal(PixelPos2RelativeInternal(XY, Azoom));
end;

function TCoordConverterBasic.PixelPos2TilePosFloatInternal(const XY: TPoint;
  Azoom: byte): TDoublePoint;
begin
  Result.X := XY.X / 256;
  Result.Y := XY.Y / 256;
end;

function TCoordConverterBasic.PixelPos2TilePosInternal(const XY: TPoint;
  Azoom: byte): TPoint;
begin
  Result.X := XY.X shr 8;
  Result.Y := XY.Y shr 8;
end;

//------------------------------------------------------------------------------
// PixelPosFloat
function TCoordConverterBasic.PixelPosFloat2LonLatInternal(
  const XY: TDoublePoint; Azoom: byte): TDoublePoint;
var
  VRelative: TDoublePoint;
begin
  VRelative := PixelPosFloat2RelativeInternal(XY, Azoom);
  Result := Relative2LonLatInternal(VRelative);
end;

function TCoordConverterBasic.PixelPosFloat2PixelPosInternal(
  const XY: TDoublePoint; Azoom: byte): TPoint;
begin
  Result.X := Trunc(RoundTo(XY.X, -2));
  Result.Y := Trunc(RoundTo(XY.Y, -2));
end;

function TCoordConverterBasic.PixelPosFloat2RelativeInternal(
  const XY: TDoublePoint; Azoom: byte): TDoublePoint;
var
  VPixelsAtZoom: Double;
begin
  VPixelsAtZoom := PixelsAtZoomFloatInternal(Azoom);
  Result.X := XY.X / VPixelsAtZoom;
  Result.Y := XY.Y / VPixelsAtZoom;
end;

function TCoordConverterBasic.PixelPosFloat2TilePosFloatInternal(
  const XY: TDoublePoint; Azoom: byte): TDoublePoint;
begin
  Result.X := XY.X / 256;
  Result.Y := XY.Y / 256;
end;

function TCoordConverterBasic.PixelPosFloat2TilePosInternal(
  const XY: TDoublePoint; Azoom: byte): TPoint;
var
  VTilePos: TDoublePoint;
begin
  VTilePos := PixelPosFloat2TilePosFloatInternal(XY, Azoom);
  Result := TilePosFloat2TilePosInternal(VTilePos, Azoom);
end;

//------------------------------------------------------------------------------
// PixelRect
function TCoordConverterBasic.PixelRect2TileRectFloatInternal(const XY: TRect;
  AZoom: byte): TDoubleRect;
begin
  Result.Left := XY.Left / 256;
  Result.Top := XY.Top / 256;
  Result.Right := XY.Right / 256;
  Result.Bottom := XY.Bottom / 256;
end;

function TCoordConverterBasic.PixelRect2TileRectInternal(const XY: TRect;
  AZoom: byte): TRect;
begin
  Result.Left := XY.Left shr 8;
  Result.Top := XY.Top shr 8;
  Result.Right := (XY.Right + 255) shr 8;
  Result.Bottom := (XY.Bottom + 255) shr 8;
end;

function TCoordConverterBasic.PixelRect2RelativeRectInternal(const XY: TRect;
  AZoom: byte): TDoubleRect;
begin
  Result.TopLeft := PixelPos2RelativeInternal(XY.TopLeft, AZoom);
  Result.BottomRight := PixelPos2RelativeInternal(XY.BottomRight, AZoom);
end;

function TCoordConverterBasic.PixelRect2LonLatRectInternal(
  const XY: TRect; AZoom: byte): TDoubleRect;
begin
  Result := RelativeRect2LonLatRectInternal(PixelRect2RelativeRectInternal(XY, AZoom));
end;

//------------------------------------------------------------------------------
// PixelRectFloat
function TCoordConverterBasic.PixelRectFloat2LonLatRectInternal(
  const XY: TDoubleRect; AZoom: byte): TDoubleRect;
var
  VRelativeRect: TDoubleRect;
begin
  VRelativeRect := PixelRectFloat2RelativeRectInternal(XY, AZoom);
  Result := RelativeRect2LonLatRect(VRelativeRect);
end;

function TCoordConverterBasic.PixelRectFloat2PixelRectInternal(
  const XY: TDoubleRect; AZoom: byte): TRect;
begin
  Result.Left := Trunc(RoundTo(XY.Left, -2));
  Result.Top := Trunc(RoundTo(XY.Top, -2));

  Result.Right := Ceil(RoundTo(XY.Right, -2));
  Result.Bottom := Ceil(RoundTo(XY.Bottom, -2));
end;

function TCoordConverterBasic.PixelRectFloat2RelativeRectInternal(
  const XY: TDoubleRect; AZoom: byte): TDoubleRect;
var
  VPixelsAtZoom: Double;
begin
  VPixelsAtZoom := PixelsAtZoomFloatInternal(Azoom);
  Result.Left := XY.Left / VPixelsAtZoom;
  Result.Top := XY.Top / VPixelsAtZoom;
  Result.Right := XY.Right / VPixelsAtZoom;
  Result.Bottom := XY.Bottom / VPixelsAtZoom;
end;

function TCoordConverterBasic.PixelRectFloat2TileRectFloatInternal(
  const XY: TDoubleRect; AZoom: byte): TDoubleRect;
begin
  Result.Left := XY.Left / 256;
  Result.Top := XY.Top / 256;
  Result.Right := XY.Right / 256;
  Result.Bottom := XY.Bottom / 256;
end;

function TCoordConverterBasic.PixelRectFloat2TileRectInternal(
  const XY: TDoubleRect; AZoom: byte): TRect;
begin
  Result.Left := Trunc(RoundTo(XY.Left / 256, -2));
  Result.Top := Trunc(RoundTo(XY.Top / 256, -2));

  Result.Right := Ceil(RoundTo(XY.Right / 256, -2));
  Result.Bottom := Ceil(RoundTo(XY.Bottom / 256, -2));
end;

//------------------------------------------------------------------------------
// TilePos
function TCoordConverterBasic.TilePos2LonLatInternal(const XY: TPoint;
  Azoom: byte): TDoublePoint;
begin
  Result := Relative2LonLatInternal(TilePos2RelativeInternal(XY, Azoom));
end;

function TCoordConverterBasic.TilePos2PixelRectInternal(const XY: TPoint;
  Azoom: byte): TRect;
begin
  Result.Left := XY.X shl 8;
  Result.Top := XY.Y shl 8;
  Result.Right := Result.Left + (1 shl 8);
  Result.Bottom := Result.Top + (1 shl 8);
end;

function TCoordConverterBasic.TilePos2LonLatRectInternal(const XY: TPoint;
  Azoom: byte): TDoubleRect;
begin
  Result := RelativeRect2LonLatRectInternal(TilePos2RelativeRectInternal(XY, Azoom));
end;

function TCoordConverterBasic.TilePos2RelativeInternal(const XY: TPoint;
  Azoom: byte): TDoublePoint;
var
  VTilesAtZoom: Double;
begin
  VTilesAtZoom := TilesAtZoomFloatInternal(Azoom);
  Result.X := XY.X / VTilesAtZoom;
  Result.Y := XY.Y / VTilesAtZoom;
end;

function TCoordConverterBasic.TilePos2RelativeRectInternal(const XY: TPoint;
  Azoom: byte): TDoubleRect;
var
  VTilesAtZoom: Double;
begin
  VTilesAtZoom := TilesAtZoomFloatInternal(Azoom);
  Result.Left := XY.X / VTilesAtZoom;
  Result.Top := XY.Y / VTilesAtZoom;
  Result.Right := (XY.X + 1) / VTilesAtZoom;
  Result.Bottom := (XY.Y + 1) / VTilesAtZoom;
end;

function TCoordConverterBasic.TilePos2PixelPosInternal(const XY: TPoint;
  Azoom: byte): TPoint;
begin
  Result.X := XY.X shl 8;
  Result.Y := XY.Y shl 8;
end;

//------------------------------------------------------------------------------
// TilePosFloat
function TCoordConverterBasic.TilePosFloat2LonLatInternal(
  const XY: TDoublePoint; Azoom: byte): TDoublePoint;
var
  VRelative: TDoublePoint;
begin
  VRelative := TilePosFloat2RelativeInternal(XY, Azoom);
  Result := Relative2LonLatInternal(VRelative);
end;

function TCoordConverterBasic.TilePosFloat2PixelPosFloatInternal(
  const XY: TDoublePoint; Azoom: byte): TDoublePoint;
begin
  Result.X := XY.X * 256;
  Result.Y := XY.Y * 256;
end;

function TCoordConverterBasic.TilePosFloat2PixelPosInternal(
  const XY: TDoublePoint; Azoom: byte): TPoint;
var
  VPixelPos: TDoublePoint;
begin
  VPixelPos := TilePosFloat2PixelPosFloatInternal(XY, Azoom);
  Result := PixelPosFloat2PixelPosInternal(VPixelPos, Azoom);
end;

function TCoordConverterBasic.TilePosFloat2RelativeInternal(
  const XY: TDoublePoint; Azoom: byte): TDoublePoint;
var
  VTilesAtZoom: Double;
begin
  VTilesAtZoom := TilesAtZoomFloatInternal(Azoom);
  Result.X := XY.X / VTilesAtZoom;
  Result.Y := XY.Y / VTilesAtZoom;
end;

function TCoordConverterBasic.TilePosFloat2TilePosInternal(
  const XY: TDoublePoint; Azoom: byte): TPoint;
begin
  Result.X := Trunc(RoundTo(XY.X, -2));
  Result.Y := Trunc(RoundTo(XY.Y, -2));
end;

//------------------------------------------------------------------------------
// TileRect
function TCoordConverterBasic.TileRect2PixelRectInternal(const XY: TRect;
  AZoom: byte): TRect;
begin
  Result.Left := XY.Left shl 8;
  Result.Top := XY.Top shl 8;
  Result.Right := XY.Right shl 8;
  Result.Bottom := XY.Bottom shl 8;
end;

function TCoordConverterBasic.TileRect2LonLatRectInternal(
  const XY: TRect; Azoom: byte): TDoubleRect;
begin
  Result := RelativeRect2LonLatRectInternal(TileRect2RelativeRectInternal(XY, Azoom));
end;

function TCoordConverterBasic.TileRect2RelativeRectInternal(
  const XY: TRect; AZoom: byte): TDoubleRect;
var
  VTilesAtZoom: Double;
begin
  VTilesAtZoom := TilesAtZoomFloatInternal(Azoom);
  Result.Left := XY.Left / VTilesAtZoom;
  Result.Top := XY.Top / VTilesAtZoom;
  Result.Right := XY.Right / VTilesAtZoom;
  Result.Bottom := XY.Bottom / VTilesAtZoom;
end;

//------------------------------------------------------------------------------
// TileRectFloat
function TCoordConverterBasic.TileRectFloat2LonLatRectInternal(
  const XY: TDoubleRect; Azoom: byte): TDoubleRect;
var
  VRelativeRect: TDoubleRect;
begin
  VRelativeRect := TileRectFloat2RelativeRectInternal(XY, Azoom);
  Result := RelativeRect2LonLatRectInternal(VRelativeRect);
end;

function TCoordConverterBasic.TileRectFloat2PixelRectFloatInternal(
  const XY: TDoubleRect; AZoom: byte): TDoubleRect;
begin
  Result.Left := XY.Left * 256;
  Result.Top := XY.Top * 256;
  Result.Right := XY.Right * 256;
  Result.Bottom := XY.Bottom * 256;
end;

function TCoordConverterBasic.TileRectFloat2PixelRectInternal(
  const XY: TDoubleRect; AZoom: byte): TRect;
var
  VPixelRect: TDoubleRect;
begin
  VPixelRect := TileRectFloat2PixelRectFloatInternal(XY, AZoom);
  Result := PixelRectFloat2PixelRectInternal(VPixelRect, AZoom);
end;

function TCoordConverterBasic.TileRectFloat2RelativeRectInternal(
  const XY: TDoubleRect; AZoom: byte): TDoubleRect;
var
  VTilesAtZoom: Double;
begin
  VTilesAtZoom := TilesAtZoomFloatInternal(Azoom);
  Result.Left := XY.Left / VTilesAtZoom;
  Result.Top := XY.Top / VTilesAtZoom;
  Result.Right := XY.Right / VTilesAtZoom;
  Result.Bottom := XY.Bottom / VTilesAtZoom;
end;

function TCoordConverterBasic.TileRectFloat2TileRectInternal(
  const XY: TDoubleRect; AZoom: byte): TRect;
begin
  Result.Left := Trunc(RoundTo(XY.Left / 256, -2));
  Result.Top := Trunc(RoundTo(XY.Top / 256, -2));

  Result.Right := Ceil(RoundTo(XY.Right / 256, -2));
  Result.Bottom := Ceil(RoundTo(XY.Bottom / 256, -2));
end;

//------------------------------------------------------------------------------
// RelativePos
function TCoordConverterBasic.Relative2PixelInternal(const XY: TDoublePoint;
  Azoom: byte): TPoint;
var
  VPixelsAtZoom: Double;
begin
  VPixelsAtZoom := PixelsAtZoomFloatInternal(Azoom);
  Result.X := Trunc(RoundTo(XY.X * VPixelsAtZoom, -2));
  Result.Y := Trunc(RoundTo(XY.Y * VPixelsAtZoom, -2));
end;

function TCoordConverterBasic.Relative2PixelPosFloatInternal(
  const XY: TDoublePoint; Azoom: byte): TDoublePoint;
var
  VPixelsAtZoom: Double;
begin
  VPixelsAtZoom := PixelsAtZoomFloatInternal(Azoom);
  Result.X := XY.X * VPixelsAtZoom;
  Result.Y := XY.Y * VPixelsAtZoom;
end;

function TCoordConverterBasic.Relative2TileInternal(const XY: TDoublePoint;
  Azoom: byte): TPoint;
var
  VTilesAtZoom: Double;
begin
  VTilesAtZoom := TilesAtZoomFloatInternal(Azoom);
  Result.X := Trunc(RoundTo(XY.X * VTilesAtZoom, -2));
  Result.Y := Trunc(RoundTo(XY.Y * VTilesAtZoom, -2));
end;

function TCoordConverterBasic.Relative2TilePosFloatInternal(
  const XY: TDoublePoint; Azoom: byte): TDoublePoint;
var
  VTilesAtZoom: Double;
begin
  VTilesAtZoom := TilesAtZoomFloatInternal(Azoom);
  Result.X := XY.X * VTilesAtZoom;
  Result.Y := XY.Y * VTilesAtZoom;
end;

//------------------------------------------------------------------------------
// RelativeRect
function TCoordConverterBasic.RelativeRect2LonLatRectInternal(
  const XY: TDoubleRect): TDoubleRect;
begin
  Result.TopLeft := Relative2LonLatInternal(XY.TopLeft);
  Result.BottomRight := Relative2LonLatInternal(XY.BottomRight);
end;

function TCoordConverterBasic.RelativeRect2PixelRectInternal(const XY: TDoubleRect;
  Azoom: byte): TRect;
var
  VPixelsAtZoom: Double;
begin
  VPixelsAtZoom := PixelsAtZoomFloatInternal(Azoom);

  Result.Left := Trunc(XY.Left * VPixelsAtZoom);
  Result.Top := Trunc(XY.Top * VPixelsAtZoom);

  Result.Right := Ceil(XY.Right * VPixelsAtZoom);
  Result.Bottom := Ceil(XY.Bottom * VPixelsAtZoom);
end;

function TCoordConverterBasic.RelativeRect2PixelRectFloatInternal(
  const XY: TDoubleRect; Azoom: byte): TDoubleRect;
var
  VPixelsAtZoom: Double;
begin
  VPixelsAtZoom := PixelsAtZoomFloatInternal(Azoom);

  Result.Left := XY.Left * VPixelsAtZoom;
  Result.Top := XY.Top * VPixelsAtZoom;

  Result.Right := XY.Right * VPixelsAtZoom;
  Result.Bottom := XY.Bottom * VPixelsAtZoom;
end;

function TCoordConverterBasic.RelativeRect2TileRectInternal(const XY: TDoubleRect;
  Azoom: byte): TRect;
var
  VTilesAtZoom: Double;
begin
  VTilesAtZoom := TilesAtZoomFloatInternal(Azoom);

  Result.Left := Trunc((XY.Left) * VTilesAtZoom);
  Result.Top := Trunc((XY.Top) * VTilesAtZoom);

  Result.Right := Ceil((XY.Right) * VTilesAtZoom);
  Result.Bottom := Ceil((XY.Bottom) * VTilesAtZoom);
end;

function TCoordConverterBasic.RelativeRect2TileRectFloatInternal(
  const XY: TDoubleRect; Azoom: byte): TDoubleRect;
var
  VTilesAtZoom: Double;
begin
  VTilesAtZoom := TilesAtZoomFloatInternal(Azoom);

  Result.Left := XY.Left * VTilesAtZoom;
  Result.Top := XY.Top * VTilesAtZoom;

  Result.Right := XY.Right * VTilesAtZoom;
  Result.Bottom := XY.Bottom * VTilesAtZoom;
end;

//------------------------------------------------------------------------------
// LonLatPos
function TCoordConverterBasic.LonLat2PixelPosInternal(const Ll: TDoublePoint;
  Azoom: byte): Tpoint;
begin
  Result := Relative2PixelInternal(LonLat2RelativeInternal(LL), AZoom);
end;

function TCoordConverterBasic.LonLat2PixelPosFloatInternal(const Ll: TDoublePoint;
  Azoom: byte): TDoublePoint;
var
  VPixelsAtZoom: Double;
begin
  VPixelsAtZoom := PixelsAtZoomFloatInternal(Azoom);

  Result := LonLat2RelativeInternal(LL);
  Result.X := Result.X * VPixelsAtZoom;
  Result.Y := Result.Y * VPixelsAtZoom;
end;

function TCoordConverterBasic.LonLat2TilePosInternal(const Ll: TDoublePoint;
  Azoom: byte): Tpoint;
begin
  Result := Relative2TileInternal(LonLat2RelativeInternal(LL), AZoom);
end;

function TCoordConverterBasic.LonLat2TilePosFloatInternal(const Ll: TDoublePoint;
  Azoom: byte): TDoublePoint;
var
  VTilesAtZoom: Double;
begin
  VTilesAtZoom := TilesAtZoomFloatInternal(Azoom);
  Result := LonLat2RelativeInternal(Ll);
  Result.X := Result.X * VTilesAtZoom;
  Result.Y := Result.Y * VTilesAtZoom;
end;

//------------------------------------------------------------------------------
// LonLatRect
function TCoordConverterBasic.LonLatRect2RelativeRectInternal(
  const XY: TDoubleRect): TDoubleRect;
begin
  Result.TopLeft := LonLat2RelativeInternal(XY.TopLeft);
  Result.BottomRight := LonLat2RelativeInternal(XY.BottomRight);
end;

function TCoordConverterBasic.LonLatRect2PixelRectFloatInternal(
  const XY: TDoubleRect; Azoom: byte): TDoubleRect;
var
  VRelativeRect: TDoubleRect;
begin
  VRelativeRect := LonLatRect2RelativeRectInternal(XY);
  Result := RelativeRect2PixelRectFloatInternal(VRelativeRect, Azoom);
end;

function TCoordConverterBasic.LonLatRect2PixelRectInternal(
  const XY: TDoubleRect; Azoom: byte): TRect;
begin
  Result := RelativeRect2PixelRectInternal(LonLatRect2RelativeRectInternal(XY), Azoom);
end;

function TCoordConverterBasic.LonLatRect2TileRectFloatInternal(
  const XY: TDoubleRect; Azoom: byte): TDoubleRect;
var
  VRelativeRect: TDoubleRect;
begin
  VRelativeRect := LonLatRect2RelativeRectInternal(XY);
  Result := RelativeRect2TileRectFloatInternal(VRelativeRect, Azoom);
end;

function TCoordConverterBasic.LonLatRect2TileRectInternal(
  const XY: TDoubleRect; Azoom: byte): TRect;
begin
  Result := RelativeRect2TileRectInternal(LonLatRect2RelativeRectInternal(XY), Azoom);
end;

//------------------------------------------------------------------------------
function TCoordConverterBasic.CheckZoom(var AZoom: Byte): boolean;
begin
  Result := True;
  if AZoom > 23 then begin
    AZoom := 23;
    Result := False;
  end;
end;

function TCoordConverterBasic.CheckTilePos(var XY: TPoint; var Azoom: byte; ACicleMap: Boolean): boolean;
var
  VTilesAtZoom: Integer;
begin
  Result := True;
  if AZoom > 23 then begin
    AZoom := 23;
    Result := False;
  end;
  VTilesAtZoom := TilesAtZoom(Azoom);

  if XY.X < 0 then begin
    Result := False;
    if ACicleMap then begin
      XY.X := XY.X mod VTilesAtZoom + VTilesAtZoom;
    end else begin
      XY.X := 0;
    end;
  end else begin
    if XY.X > VTilesAtZoom then begin
      Result := False;
      if ACicleMap then begin
        XY.X := XY.X mod VTilesAtZoom;
      end else begin
        XY.X := VTilesAtZoom;
      end;
    end;
  end;

  if XY.Y < 0 then begin
    Result := False;
    XY.Y := 0;
  end else begin
    if XY.Y > VTilesAtZoom then begin
      Result := False;
      XY.Y := VTilesAtZoom;
    end;
  end;
end;

function TCoordConverterBasic.CheckTileRect(var XY: TRect; var Azoom: byte): boolean;
var
  VTilesAtZoom: Integer;
begin
  Result := True;
  if AZoom > 23 then begin
    Result := False;
    AZoom := 23;
  end;
  VTilesAtZoom := TilesAtZoom(Azoom);

  if XY.Left < 0 then begin
    Result := False;
    XY.Left := 0;
  end else begin
    if XY.Left > VTilesAtZoom then begin
      Result := False;
      XY.Left := VTilesAtZoom;
    end;
  end;

  if XY.Top < 0 then begin
    Result := False;
    XY.Top := 0;
  end else begin
    if XY.Top > VTilesAtZoom then begin
      Result := False;
      XY.Top := VTilesAtZoom;
    end;
  end;

  if XY.Right < 0 then begin
    Result := False;
    XY.Right := 0;
  end else begin
    if XY.Right > VTilesAtZoom then begin
      Result := False;
      XY.Right := VTilesAtZoom;
    end;
  end;

  if XY.Bottom < 0 then begin
    Result := False;
    XY.Bottom := 0;
  end else begin
    if XY.Bottom > VTilesAtZoom then begin
      Result := False;
      XY.Bottom := VTilesAtZoom;
    end;
  end;
end;

function TCoordConverterBasic.CheckTilePosStrict(var XY: TPoint; var Azoom: byte; ACicleMap: Boolean): boolean;
var
  VTilesAtZoom: Integer;
begin
  Result := True;
  if AZoom > 23 then begin
    Result := False;
    AZoom := 23;
  end;
  VTilesAtZoom := TilesAtZoom(Azoom);

  if XY.X < 0 then begin
    Result := False;
    if ACicleMap then begin
      XY.X := XY.X mod VTilesAtZoom + VTilesAtZoom;
    end else begin
      XY.X := 0;
    end;
  end else begin
    if XY.X >= VTilesAtZoom then begin
      Result := False;
      if ACicleMap then begin
        XY.X := XY.X mod VTilesAtZoom;
      end else begin
        XY.X := VTilesAtZoom - 1;
      end;
    end;
  end;

  if XY.Y < 0 then begin
    Result := False;
    XY.Y := 0;
  end else begin
    if XY.Y >= VTilesAtZoom then begin
      Result := False;
      XY.Y := VTilesAtZoom - 1;
    end;
  end;
end;

function TCoordConverterBasic.CheckPixelPos(var XY: TPoint; var Azoom: byte; ACicleMap: Boolean): boolean;
var
  VPixelsAtZoom: Integer;
begin
  Result := True;
  if AZoom > 23 then begin
    Result := False;
    AZoom := 23;
  end;
  VPixelsAtZoom := PixelsAtZoom(Azoom);

  if XY.X < 0 then begin
    Result := False;
    if (Azoom < 23) then begin
      if ACicleMap then begin
        XY.X := XY.X mod VPixelsAtZoom + VPixelsAtZoom;
      end else begin
        XY.X := 0;
      end;
    end else begin
      if (XY.X <> VPixelsAtZoom) then begin
        if ACicleMap then begin
          XY.X := VPixelsAtZoom + XY.X;
        end else begin
          XY.X := 0;
        end;
      end;
    end;
  end else begin
    if (Azoom < 23) and (XY.X > VPixelsAtZoom) then begin
      Result := False;
      if ACicleMap then begin
        XY.X := XY.X mod VPixelsAtZoom;
      end else begin
        XY.X := VPixelsAtZoom;
      end;
    end;
  end;

  if XY.Y < 0 then begin
    Result := False;
    if (Azoom < 23) or (XY.Y <> VPixelsAtZoom) then begin
      XY.Y := 0;
    end;
  end else begin
    if (Azoom < 23) and (XY.Y > VPixelsAtZoom) then begin
      Result := False;
      XY.Y := VPixelsAtZoom;
    end;
  end;
end;

function TCoordConverterBasic.CheckPixelPosFloat(var XY: TDoublePoint;
  var Azoom: byte; ACicleMap: Boolean): boolean;
var
  VPixelsAtZoom: Double;
begin
  Result := True;
  if AZoom > 23 then begin
    Result := False;
    AZoom := 23;
  end;

  VPixelsAtZoom := PixelsAtZoomFloatInternal(Azoom);

  if XY.X < 0 then begin
    Result := False;
    if ACicleMap then begin
      XY.X := XY.X - Int(XY.X / VPixelsAtZoom) * VPixelsAtZoom + VPixelsAtZoom;
    end else begin
      XY.X := 0;
    end;
  end else begin
    if (XY.X > VPixelsAtZoom) then begin
      Result := False;
      if ACicleMap then begin
        XY.X := XY.X - Int(XY.X / VPixelsAtZoom) * VPixelsAtZoom;
      end else begin
        XY.X := VPixelsAtZoom;
      end;
    end;
  end;

  if XY.Y < 0 then begin
    Result := False;
    XY.Y := 0;
  end else begin
    if (XY.Y > VPixelsAtZoom) then begin
      Result := False;
      XY.Y := VPixelsAtZoom;
    end;
  end;
end;

function TCoordConverterBasic.CheckPixelRect(var XY: TRect; var Azoom: byte): boolean;
var
  VPixelsAtZoom: Integer;
begin
  Result := True;
  if AZoom > 23 then begin
    Result := False;
    AZoom := 23;
  end;
  VPixelsAtZoom := PixelsAtZoom(Azoom);

  if XY.Left < 0 then begin
    Result := False;
    XY.Left := 0;
  end else begin
    if (Azoom < 23) and (XY.Left > VPixelsAtZoom) then begin
      Result := False;
      XY.Left := VPixelsAtZoom;
    end;
  end;

  if XY.Top < 0 then begin
    Result := False;
    XY.Top := 0;
  end else begin
    if (Azoom < 23) and (XY.Top > VPixelsAtZoom) then begin
      Result := False;
      XY.Top := VPixelsAtZoom;
    end;
  end;

  if XY.Right < 0 then begin
    Result := False;
    XY.Right := 0;
  end else begin
    if (Azoom < 23) and (XY.Right > VPixelsAtZoom) then begin
      Result := False;
      XY.Right := VPixelsAtZoom;
    end;
  end;

  if XY.Bottom < 0 then begin
    Result := False;
    XY.Bottom := 0;
  end else begin
    if (Azoom < 23) and (XY.Bottom > VPixelsAtZoom) then begin
      Result := False;
      XY.Bottom := VPixelsAtZoom;
    end;
  end;
end;

function TCoordConverterBasic.CheckPixelRectFloat(var XY: TDoubleRect; var azoom: byte): boolean;
var
  VPixelsAtZoom: Double;
begin
  Result := True;
  if AZoom > 23 then begin
    Result := False;
    AZoom := 23;
  end;
  VPixelsAtZoom := PixelsAtZoomFloatInternal(Azoom);

  if XY.Left < 0 then begin
    Result := False;
    XY.Left := 0;
  end else begin
    if XY.Left > VPixelsAtZoom then begin
      Result := False;
      XY.Left := VPixelsAtZoom;
    end;
  end;

  if XY.Top < 0 then begin
    Result := False;
    XY.Top := 0;
  end else begin
    if XY.Top > VPixelsAtZoom then begin
      Result := False;
      XY.Top := VPixelsAtZoom;
    end;
  end;

  if XY.Right < 0 then begin
    Result := False;
    XY.Right := 0;
  end else begin
    if XY.Right > VPixelsAtZoom then begin
      Result := False;
      XY.Right := VPixelsAtZoom;
    end;
  end;

  if XY.Bottom < 0 then begin
    Result := False;
    XY.Bottom := 0;
  end else begin
    if XY.Bottom > VPixelsAtZoom then begin
      Result := False;
      XY.Bottom := VPixelsAtZoom;
    end;
  end;
end;

function TCoordConverterBasic.CheckPixelPosStrict(var XY: TPoint; var Azoom: byte; ACicleMap: Boolean): boolean;
var
  VPixelsAtZoom: Integer;
begin
  Result := True;
  if AZoom > 23 then begin
    Result := False;
    AZoom := 23;
  end;
  VPixelsAtZoom := PixelsAtZoom(Azoom);
  if XY.X < 0 then begin
    Result := False;
    if ACicleMap then begin
      XY.X := XY.X mod VPixelsAtZoom + VPixelsAtZoom;
    end else begin
      XY.X := 0;
    end;
  end else begin
    if (Azoom < 23) and (XY.X >= VPixelsAtZoom) then begin
      Result := False;
      if ACicleMap then begin
        XY.X := XY.X mod VPixelsAtZoom;
      end else begin
        XY.X := VPixelsAtZoom - 1;
      end;
    end;
  end;

  if XY.Y < 0 then begin
    Result := False;
    XY.Y := 0;
  end else begin
    if (Azoom < 23) and (XY.Y >= VPixelsAtZoom) then begin
      Result := False;
      XY.Y := VPixelsAtZoom - 1;
    end;
  end;
end;

function TCoordConverterBasic.CheckPixelPosFloatStrict(var XY: TDoublePoint;
  var Azoom: byte; ACicleMap: Boolean): boolean;
var
  VPixelsAtZoom: Double;
begin
  Result := True;
  if AZoom > 23 then begin
    Result := False;
    AZoom := 23;
  end;
  VPixelsAtZoom := PixelsAtZoomFloatInternal(Azoom);
  if XY.X < 0 then begin
    Result := False;
    if ACicleMap then begin
      XY.X := XY.X - Int(XY.X / VPixelsAtZoom) * VPixelsAtZoom + VPixelsAtZoom;
    end else begin
      XY.X := 0;
    end;
  end else begin
    if (XY.X >= VPixelsAtZoom) then begin
      Result := False;
      if ACicleMap then begin
        XY.X := XY.X - Int(XY.X / VPixelsAtZoom) * VPixelsAtZoom;
      end else begin
        XY.X := VPixelsAtZoom;
      end;
    end;
  end;

  if XY.Y < 0 then begin
    Result := False;
    XY.Y := 0;
  end else begin
    if (XY.Y >= VPixelsAtZoom) then begin
      Result := False;
      XY.Y := VPixelsAtZoom;
    end;
  end;
end;

function TCoordConverterBasic.CheckRelativePos(var XY: TDoublePoint): boolean;
begin
  Result := True;
  if XY.X < 0 then begin
    Result := False;
    XY.X := 0;
  end else begin
    if XY.X > 1 then begin
      Result := False;
      XY.X := 1;
    end;
  end;

  if XY.Y < 0 then begin
    Result := False;
    XY.Y := 0;
  end else begin
    if XY.Y > 1 then begin
      Result := False;
      XY.Y := 1;
    end;
  end;
end;

function TCoordConverterBasic.CheckRelativeRect(var XY: TDoubleRect): boolean;
begin
  Result := True;
  if XY.Left < 0 then begin
    Result := False;
    XY.Left := 0;
  end else begin
    if XY.Left > 1 then begin
      Result := False;
      XY.Left := 1;
    end;
  end;

  if XY.Top < 0 then begin
    Result := False;
    XY.Top := 0;
  end else begin
    if XY.Top > 1 then begin
      Result := False;
      XY.Top := 1;
    end;
  end;

  if XY.Right < 0 then begin
    Result := False;
    XY.Right := 0;
  end else begin
    if XY.Right > 1 then begin
      Result := False;
      XY.Right := 1;
    end;
  end;

  if XY.Bottom < 0 then begin
    Result := False;
    XY.Bottom := 0;
  end else begin
    if XY.Bottom > 1 then begin
      Result := False;
      XY.Bottom := 1;
    end;
  end;
end;

function TCoordConverterBasic.CheckLonLatPos(var XY: TDoublePoint): boolean;
begin
  Result := True;
  if XY.X < FValidLonLatRect.Left then begin
    Result := False;
    XY.X := FValidLonLatRect.Left;
  end else begin
    if XY.X > FValidLonLatRect.Right then begin
      Result := False;
      XY.X := FValidLonLatRect.Right;
    end;
  end;
  if XY.Y < FValidLonLatRect.Bottom then begin
    Result := False;
    XY.Y := FValidLonLatRect.Bottom;
  end else begin
    if XY.Y > FValidLonLatRect.Top then begin
      Result := False;
      XY.Y := FValidLonLatRect.Top;
    end;
  end;
end;

function TCoordConverterBasic.CheckLonLatRect(var XY: TDoubleRect): boolean;
begin
  Result := True;
  if XY.Left < FValidLonLatRect.Left then begin
    Result := False;
    XY.Left := FValidLonLatRect.Left;
  end else begin
    if XY.Left > FValidLonLatRect.Right then begin
      Result := False;
      XY.Left := FValidLonLatRect.Right;
    end;
  end;
  if XY.Bottom < FValidLonLatRect.Bottom then begin
    Result := False;
    XY.Bottom := FValidLonLatRect.Bottom;
  end else begin
    if XY.Bottom > FValidLonLatRect.Top then begin
      Result := False;
      XY.Bottom := FValidLonLatRect.Top;
    end;
  end;

  if XY.Right < FValidLonLatRect.Left then begin
    Result := False;
    XY.Right := FValidLonLatRect.Left;
  end else begin
    if XY.Right > FValidLonLatRect.Right then begin
      Result := False;
      XY.Right := FValidLonLatRect.Right;
    end;
  end;
  if XY.Top < FValidLonLatRect.Bottom then begin
    Result := False;
    XY.Top := FValidLonLatRect.Bottom;
  end else begin
    if XY.Top > FValidLonLatRect.Top then begin
      Result := False;
      XY.Top := FValidLonLatRect.Top;
    end;
  end;
end;


end.
