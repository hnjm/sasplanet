{******************************************************************************}
{* SAS.������� (SAS.Planet)                                                   *}
{* Copyright (C) 2007-2011, ������ ��������� SAS.������� (SAS.Planet).        *}
{* ��� ��������� �������� ��������� ����������� ������������. �� ������       *}
{* �������������� �/��� �������������� � �������� �������� �����������       *}
{* ������������ �������� GNU, �������������� ������ ���������� ������������   *}
{* �����������, ������ 3. ��� ��������� ���������������� � �������, ��� ���   *}
{* ����� ��������, �� ��� ������ ��������, � ��� ����� ���������������        *}
{* �������� ��������� ��������� ��� ������� � �������� ��� ������˨�����      *}
{* ����������. �������� ����������� ������������ �������� GNU ������ 3, ���   *}
{* ��������� �������������� ����������. �� ������ ���� �������� �����         *}
{* ����������� ������������ �������� GNU ������ � ����������. � ������ �     *}
{* ����������, ���������� http://www.gnu.org/licenses/.                       *}
{*                                                                            *}
{* http://sasgis.ru/sasplanet                                                 *}
{* az@sasgis.ru                                                               *}
{******************************************************************************}

unit i_TileStorage;

interface

uses
  Types,
  Classes,
  GR32,
  i_TileInfoBasic,
  i_TileStorageInfo;

type
  ITileStorage = interface
    ['{80A0246E-68E0-4EA0-9B0F-3338472FDB3C}']
    function GetInfo: ITileStorageInfo;

    function GetTileFileName(AXY: TPoint; Azoom: byte; AVersion: Variant): string;
    function GetTileInfo(AXY: TPoint; Azoom: byte; AVersion: Variant): ITileInfoBasic;

    function LoadTile(AXY: TPoint; Azoom: byte; AVersion: Variant; AStream: TStream; out ATileInfo: ITileInfoBasic): Boolean;
    function DeleteTile(AXY: TPoint; Azoom: byte; AVersion: Variant): Boolean;
    function DeleteTNE(AXY: TPoint; Azoom: byte; AVersion: Variant): Boolean;
    procedure SaveTile(AXY: TPoint; Azoom: byte; AVersion: Variant; AStream: TStream);
    procedure SaveTNE(AXY: TPoint; Azoom: byte; AVersion: Variant);

    function LoadFillingMap(
      btm: TCustomBitmap32;
      AXY: TPoint;
      Azoom: byte;
      ASourceZoom: byte;
      AVersion: Variant;
      IsStop: PBoolean
    ): boolean;
  end;


implementation

end.
