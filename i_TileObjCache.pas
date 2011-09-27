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

unit i_TileObjCache;

interface

uses
  GR32,
  i_VectorDataItemSimple;

type
  ITileObjCacheVector = interface
    ['{B52B38D1-C57C-424C-B85B-AC623A54E7B5}']
    procedure Clear;
    procedure DeleteTileFromCache(AXY: TPoint; AZoom: Byte);
    procedure AddTileToCache(AObj: IVectorDataItemList; AXY: TPoint; AZoom: Byte);
    function TryLoadTileFromCache(var AObj: IVectorDataItemList; AXY: TPoint; AZoom: Byte): boolean;
  end;

  ITileObjCacheBitmap = interface
    ['{B52B38D1-C57C-424C-B85B-AC623A54E7B5}']
    procedure Clear;
    procedure DeleteTileFromCache(AXY: TPoint; AZoom: Byte);
    procedure AddTileToCache(AObj: TCustomBitmap32; AXY: TPoint; AZoom: Byte);
    function TryLoadTileFromCache(AObj: TCustomBitmap32; AXY: TPoint; AZoom: Byte): boolean;
    procedure AddTilePreToCache(AObj: TCustomBitmap32; AXY: TPoint; AZoom: Byte);
    function TryLoadTilePreFromCache(AObj: TCustomBitmap32; AXY: TPoint; AZoom: Byte): boolean;
  end;


implementation

end.
 