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

unit i_CoordConverter;

interface

uses
  Types,
  t_GeoTypes,
  i_Datum;

type
  ICoordConverterSimple = interface
    ['{3EE2987F-7681-425A-8EFE-B676C506CDD4}']

    // ����������� ������� ����� �� �������� ���� � ������������ ���������� ��� �������� ������ ����
    function Pos2LonLat(const XY: TPoint; Azoom: byte): TDoublePoint; stdcall;
    // ����������� ������������� ���������� � ������� ����� �� �������� ���� ������������ ������ ����������
    function LonLat2Pos(const Ll: TDoublePoint; Azoom: byte): Tpoint; stdcall;
    // ?????????
    function LonLat2Metr(const Ll: TDoublePoint): TDoublePoint; stdcall;

    // ���������� ���������� ������ � �������� ����
    function TilesAtZoom(const AZoom: byte): Longint; stdcall;
    // ���������� ����� ���������� �������� �� �������� ����
    function PixelsAtZoom(const AZoom: byte): Longint; stdcall;

    // ����������� ������� ����� ��������� ���� � ���������� ������� ��� ������ �������� ����
    function TilePos2PixelPos(const XY: TPoint; const Azoom: byte): TPoint; stdcall;
    // ����������� ������� ����� ��������� ���� � ������ �������� ��� ����� �� �������� ����
    function TilePos2PixelRect(const XY: TPoint; const Azoom: byte): TRect; stdcall;
  end;

  ICoordConverter = interface
    ['{E8884111-C538-424F-92BC-1BC9843EA6BB}']
    function GetDatum: IDatum; stdcall;
    property Datum: IDatum read GetDatum;

    // ����������� � ������������ ���� ������ � 0 �� 23
    function GetMinZoom: Byte; stdcall;
    property MinZoom: Byte read GetMinZoom;

    function GetMaxZoom: Byte; stdcall;
    property MaxZoom: Byte read GetMaxZoom;

    // ���������� ������������� ������ ���������� � �������� ����
    function TileRectAtZoom(const AZoom: byte): TRect; stdcall;
    // ���������� ������������� �������� ���������� � �������� ����
    function PixelRectAtZoom(const AZoom: byte): TRect; stdcall;

    // ���������� ���������� ������ � �������� ����
    function TilesAtZoom(const AZoom: byte): Longint; stdcall;
    function TilesAtZoomFloat(const AZoom: byte): Double; stdcall;
    // ���������� ����� ���������� �������� �� �������� ����
    function PixelsAtZoom(const AZoom: byte): Longint; stdcall;
    function PixelsAtZoomFloat(const AZoom: byte): Double; stdcall;

    // ����������� ���������� ������� �  ���������� ����� c���������� �������
    function PixelPos2TilePos(const XY: TPoint; const Azoom: byte): TPoint; stdcall;
    // ����������� ���������� ������� � ������������� ���������� �� ����� (x/PixelsAtZoom)
    function PixelPos2Relative(const XY: TPoint; const Azoom: byte): TDoublePoint; stdcall;
    // ����������� ���������� ������� � �������������� ����������
    function PixelPos2LonLat(const XY: TPoint; const Azoom: byte): TDoublePoint; stdcall;//TODO: ��������
    function PixelPos2TilePosFloat(const XY: TPoint; const Azoom: byte): TDoublePoint; stdcall;//TODO: ��������

    function PixelPosFloat2PixelPos(const XY: TDoublePoint; const Azoom: byte): TPoint; stdcall;//TODO: ��������
    function PixelPosFloat2TilePos(const XY: TDoublePoint; const Azoom: byte): TPoint; stdcall;//TODO: ��������
    function PixelPosFloat2TilePosFloat(const XY: TDoublePoint; const Azoom: byte): TDoublePoint; stdcall;//TODO: ��������
    function PixelPosFloat2Relative(const XY: TDoublePoint; const Azoom: byte): TDoublePoint; stdcall;//TODO: ��������
    function PixelPosFloat2LonLat(const XY: TDoublePoint; const Azoom: byte): TDoublePoint; stdcall;//TODO: ��������

    // ��������� ������������� ������ ����������� ������������� ��������
    function PixelRect2TileRect(const XY: TRect; const AZoom: byte): TRect; stdcall;
    // ����������� ���������� �������������� �������� � ������������� ���������� �� ����� (x/PixelsAtZoom)
    function PixelRect2RelativeRect(const XY: TRect; const AZoom: byte): TDoubleRect; stdcall;
    // ����������� ���������� �������������� �������� � �������������� ���������� �� �����
    function PixelRect2LonLatRect(const XY: TRect; const AZoom: byte): TDoubleRect; stdcall;
    function PixelRect2TileRectFloat(const XY: TRect; const AZoom: byte): TDoubleRect; stdcall;//TODO: ��������

    function PixelRectFloat2PixelRect(const XY: TDoubleRect; const AZoom: byte): TRect; stdcall;//TODO: ��������
    function PixelRectFloat2TileRect(const XY: TDoubleRect; const AZoom: byte): TRect; stdcall;//TODO: ��������
    function PixelRectFloat2TileRectFloat(const XY: TDoubleRect; const AZoom: byte): TDoubleRect; stdcall;//TODO: ��������
    function PixelRectFloat2RelativeRect(const XY: TDoubleRect; const AZoom: byte): TDoubleRect; stdcall;//TODO: ��������
    function PixelRectFloat2LonLatRect(const XY: TDoubleRect; const AZoom: byte): TDoubleRect; stdcall;//TODO: ��������

    // ����������� ������� ����� ��������� ���� � ���������� ������� ��� ������ �������� ����
    function TilePos2PixelPos(const XY: TPoint; const Azoom: byte): TPoint; stdcall;
    // ����������� ������� ����� ��������� ���� � ������ �������� ��� ����� �� �������� ����
    function TilePos2PixelRect(const XY: TPoint; const Azoom: byte): TRect; stdcall;
    // ����������� ���������� ����� � ������������� ���������� �� ����� (x/PixelsAtZoom)
    function TilePos2Relative(const XY: TPoint; const Azoom: byte): TDoublePoint; stdcall;
    // ����������� ������� ����� ��������� ���� � ������ �������� ��� ����� �� �������� ����
    function TilePos2RelativeRect(const XY: TPoint; const Azoom: byte): TDoubleRect; stdcall;
    // ����������� ���������� ����� � �������������� ����������
    function TilePos2LonLat(const XY: TPoint; const Azoom: byte): TDoublePoint; stdcall;//TODO: ��������
    // ����������� ������� ����� ��������� ���� � �������������� ���������� ��� �����
    function TilePos2LonLatRect(const XY: TPoint; const Azoom: byte): TDoubleRect; stdcall;//TODO: ��������

    function TilePosFloat2TilePos(const XY: TDoublePoint; const Azoom: byte): TPoint; stdcall;//TODO: ��������
    function TilePosFloat2PixelPos(const XY: TDoublePoint; const Azoom: byte): TPoint; stdcall;//TODO: ��������
    function TilePosFloat2PixelPosFloat(const XY: TDoublePoint; const Azoom: byte): TDoublePoint; stdcall;//TODO: ��������
    function TilePosFloat2Relative(const XY: TDoublePoint; const Azoom: byte): TDoublePoint; stdcall;//TODO: ��������
    function TilePosFloat2LonLat(const XY: TDoublePoint; const Azoom: byte): TDoublePoint; stdcall;//TODO: ��������

    // ��������� ��������� �������� ������ �������������� ������
    function TileRect2PixelRect(const XY: TRect; const AZoom: byte): TRect; stdcall;//TODO: ��������
    // ��������� ������������� ��������� ������ �������������� ������
    function TileRect2RelativeRect(const XY: TRect; const AZoom: byte): TDoubleRect; stdcall;//TODO: ��������
    // ����������� ������������� ������ ��������� ���� � �������������� ���������� ��� �����
    function TileRect2LonLatRect(const XY: TRect; const Azoom: byte): TDoubleRect; stdcall;//TODO: ��������

    function TileRectFloat2TileRect(const XY: TDoubleRect; const AZoom: byte): TRect; stdcall;//TODO: ��������
    function TileRectFloat2PixelRect(const XY: TDoubleRect; const AZoom: byte): TRect; stdcall;//TODO: ��������
    function TileRectFloat2PixelRectFloat(const XY: TDoubleRect; const AZoom: byte): TDoubleRect; stdcall;//TODO: ��������
    function TileRectFloat2RelativeRect(const XY: TDoubleRect; const AZoom: byte): TDoubleRect; stdcall;//TODO: ��������
    function TileRectFloat2LonLatRect(const XY: TDoubleRect; const Azoom: byte): TDoubleRect; stdcall;//TODO: ��������

    // ����������� ������������� ���������� �� ����� � ���������� �������
    function Relative2Pixel(const XY: TDoublePoint; const Azoom: byte): TPoint; stdcall;
    function Relative2PixelPosFloat(const XY: TDoublePoint; const Azoom: byte): TDoublePoint; stdcall;//TODO: ��������
    // ����������� ������������� ���������� �� ����� � ���������� �����
    function Relative2Tile(const XY: TDoublePoint; const Azoom: byte): TPoint; stdcall;
    function Relative2TilePosFloat(const XY: TDoublePoint; const Azoom: byte): TDoublePoint; stdcall;
    // ����������� ������������� ���������� �� ����� � ��������������
    function Relative2LonLat(const XY: TDoublePoint): TDoublePoint; stdcall;//TODO: ��������

    // ����������� ������������� � �������������� ������������ � ������������� ��������
    function RelativeRect2PixelRect(const XY: TDoubleRect; const Azoom: byte): TRect; stdcall;
    function RelativeRect2PixelRectFloat(const XY: TDoubleRect; const Azoom: byte): TDoubleRect; stdcall;
    // ����������� ������������� � �������������� ������������ � ������������� ������
    function RelativeRect2TileRect(const XY: TDoubleRect; const Azoom: byte): TRect; stdcall;
    function RelativeRect2TileRectFloat(const XY: TDoubleRect; const Azoom: byte): TDoubleRect; stdcall;
    // ����������� ������������� � �������������� ������������ �� ����� � ��������������
    function RelativeRect2LonLatRect(const XY: TDoubleRect): TDoubleRect; stdcall;//TODO: ��������

    // ����������� ������������� ���������� � ���������� ������� �� �������� ���� ������������ ������ ����������
    function LonLat2PixelPos(const Ll: TDoublePoint; const Azoom: byte): Tpoint; stdcall;//TODO: ��������
    function LonLat2PixelPosFloat(const Ll: TDoublePoint; const Azoom: byte): TDoublePoint; stdcall;
    // ����������� ������������� ���������� � ������� ����� �� �������� ���� ������������ ������ ����������
    function LonLat2TilePos(const Ll: TDoublePoint; const Azoom: byte): Tpoint; stdcall;//TODO: ��������
    function LonLat2TilePosFloat(const Ll: TDoublePoint; const Azoom: byte): TDoublePoint; stdcall;
    // ����������� �������������� ��������� � ������������� ���������� �� �����
    function LonLat2Relative(const XY: TDoublePoint): TDoublePoint; stdcall;//TODO: ��������

    // ����������� ������������� � �������������� ���������� � ������������� ���������� �� �����
    function LonLatRect2RelativeRect(const XY: TDoubleRect): TDoubleRect; stdcall;//TODO: ��������
    function LonLatRect2PixelRect(const XY: TDoubleRect; const Azoom: byte): TRect; stdcall;//TODO: ��������
    function LonLatRect2PixelRectFloat(const XY: TDoubleRect; const Azoom: byte): TDoubleRect; stdcall;//TODO: ��������
    function LonLatRect2TileRect(const XY: TDoubleRect; const Azoom: byte): TRect; stdcall;//TODO: ��������
    function LonLatRect2TileRectFloat(const XY: TDoubleRect; const Azoom: byte): TDoubleRect; stdcall;//TODO: ��������

    procedure LonLatArray2PixelArray(
      const ASourcePoints: PDoublePointArray;
      const ACount: Integer;
      const AResultPoints: PPointArray;
      const AZoom: byte
    ); stdcall;
    procedure LonLatArray2PixelArrayFloat(
      const ASourcePoints: PDoublePointArray;
      const ACount: Integer;
      const AResultPoints: PDoublePointArray;
      const AZoom: byte
    ); stdcall;

    function GetTileSize(const XY: TPoint; const Azoom: byte): TPoint; stdcall;
    function PixelPos2OtherMap(const XY: TPoint; const Azoom: byte; AOtherMapCoordConv: ICoordConverter): TPoint; stdcall;

    function CheckZoom(var AZoom: Byte): boolean; stdcall;
    function CheckTilePos(var XY: TPoint; var Azoom: byte; ACicleMap: Boolean): boolean; stdcall;
    function CheckTilePosStrict(var XY: TPoint; var Azoom: byte; ACicleMap: Boolean): boolean; stdcall;
    function CheckTileRect(var XY: TRect; var Azoom: byte): boolean; stdcall;

    function CheckPixelPos(var XY: TPoint; var Azoom: byte; ACicleMap: Boolean): boolean; stdcall;
    function CheckPixelPosFloat(var XY: TDoublePoint; var Azoom: byte; ACicleMap: Boolean): boolean; stdcall;
    function CheckPixelPosStrict(var XY: TPoint; var Azoom: byte; ACicleMap: Boolean): boolean; stdcall;
    function CheckPixelPosFloatStrict(var XY: TDoublePoint; var Azoom: byte; ACicleMap: Boolean): boolean; stdcall;
    function CheckPixelRect(var XY: TRect; var Azoom: byte): boolean; stdcall;
    function CheckPixelRectFloat(var XY: TDoubleRect; var Azoom: byte): boolean; stdcall;

    function CheckRelativePos(var XY: TDoublePoint): boolean; stdcall;
    function CheckRelativeRect(var XY: TDoubleRect): boolean; stdcall;

    function CheckLonLatPos(var XY: TDoublePoint): boolean; stdcall;
    function CheckLonLatRect(var XY: TDoubleRect): boolean; stdcall;
    function CheckLonLatArray(
      const ASourcePoints: PDoublePointArray;
      const ACount: Integer
    ): boolean; stdcall;
    function CheckAndCorrectLonLatArray(
      const ASourcePoints: PDoublePointArray;
      const ACount: Integer
    ): boolean; stdcall;

    // ���������� ��� EPSG ��� ���� ��������. ��� ������������� �������� � ��������� ����� ���������� 0
    function GetProjectionEPSG: Integer; stdcall;
    // ���������� ������� ��������� ������������ � ��������������� �����
    function GetCellSizeUnits: TCellSizeUnits; stdcall;
    // ���������� ��� ���� ������� �� ����� (�� �������, ����� �������� ������������ ������ ������)
    function GetTileSplitCode: Integer; stdcall;
    // ���������� �������� �� ������ ��������� ������������� ��������
    function IsSameConverter(AOtherMapCoordConv: ICoordConverter): Boolean; stdcall;


    // ?????????
    function LonLat2Metr(const Ll: TDoublePoint): TDoublePoint; stdcall;
  end;

implementation

end.

