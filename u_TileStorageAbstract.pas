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
{* http://sasgis.ru                                                           *}
{* az@sasgis.ru                                                               *}
{******************************************************************************}

unit u_TileStorageAbstract;

interface

uses
  Types,
  i_BinaryData,
  i_CoordConverter,
  i_MapVersionInfo,
  i_MapVersionConfig,
  i_StorageTypeAbilities,
  i_StorageState,
  i_StorageStateInternal,
  i_TileInfoBasic,
  i_TileStorage,
  i_NotifierTileRectUpdate;

type
  TTileStorageAbstract = class(TInterfacedObject, ITileStorage)
  private
    FGeoConverter: ICoordConverter;
    FMapVersionFactory: IMapVersionFactory;
    FTileNotifier: INotifierTileRectUpdate;
    FStoragePath: string;
    FStorageState: IStorageStateChangeble;
    FStorageStateInternal: IStorageStateInternal;
    FTileNotifierInternal: INotifierTileRectUpdateInternal;
  protected
    procedure NotifyTileUpdate(
      const ATile: TPoint;
      const AZoom: Byte;
      const AVersion: IMapVersionInfo
    );
    property StorageStateInternal: IStorageStateInternal read FStorageStateInternal;
    property StoragePath: string read FStoragePath;
    property GeoConverter: ICoordConverter read FGeoConverter;
    property MapVersionFactory: IMapVersionFactory read FMapVersionFactory;
  protected
    function GetTileNotifier: INotifierTileRectUpdate;
    function GetState: IStorageStateChangeble;

    function GetTileFileName(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersionInfo: IMapVersionInfo
    ): string; virtual; abstract;
    function GetTileInfo(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersionInfo: IMapVersionInfo;
      const AMode: TGetTileInfoMode
    ): ITileInfoBasic; virtual; abstract;
    function GetTileRectInfo(
      const ARect: TRect;
      const AZoom: byte;
      const AVersionInfo: IMapVersionInfo
    ): ITileRectInfo; virtual; abstract;
    function DeleteTile(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersionInfo: IMapVersionInfo
    ): Boolean; virtual; abstract;
    function DeleteTNE(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersionInfo: IMapVersionInfo
    ): Boolean; virtual; abstract;
    procedure SaveTile(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersionInfo: IMapVersionInfo;
      const AData: IBinaryData
    ); virtual; abstract;
    procedure SaveTNE(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersionInfo: IMapVersionInfo
    ); virtual; abstract;

    function GetListOfTileVersions(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersionInfo: IMapVersionInfo
    ): IMapVersionListStatic; virtual;

    function ScanTiles(
      const AIgnoreTNE: Boolean
    ): IEnumTileInfo; virtual;
  public
    constructor Create(
      const AStorageTypeAbilities: IStorageTypeAbilities;
      const AMapVersionFactory: IMapVersionFactory;
      const AGeoConverter: ICoordConverter;
      const AStoragePath: string
    );
  end;

implementation

uses
  u_NotifierTileRectUpdate,
  u_StorageStateInternal;

{ TTileStorageAbstract }

constructor TTileStorageAbstract.Create(
  const AStorageTypeAbilities: IStorageTypeAbilities;
  const AMapVersionFactory: IMapVersionFactory;
  const AGeoConverter: ICoordConverter;
  const AStoragePath: string
);
var
  VNotifier: TNotifierTileRectUpdate;
  VState: TStorageStateInternal;
begin
  inherited Create;
  FMapVersionFactory := AMapVersionFactory;
  FStoragePath := AStoragePath;
  FGeoConverter := AGeoConverter;

  VState := TStorageStateInternal.Create(AStorageTypeAbilities);
  FStorageStateInternal := VState;
  FStorageState := VState;

  VNotifier := TNotifierTileRectUpdate.Create(AGeoConverter);
  FTileNotifier := VNotifier;
  FTileNotifierInternal := VNotifier;
end;

function TTileStorageAbstract.GetListOfTileVersions(
  const AXY: TPoint;
  const AZoom: byte;
  const AVersionInfo: IMapVersionInfo
): IMapVersionListStatic;
begin
  Result := nil;
end;

function TTileStorageAbstract.GetTileNotifier: INotifierTileRectUpdate;
begin
  Result := FTileNotifier;
end;

function TTileStorageAbstract.GetState: IStorageStateChangeble;
begin
  Result := FStorageState;
end;

procedure TTileStorageAbstract.NotifyTileUpdate(
  const ATile: TPoint;
  const AZoom: Byte;
  const AVersion: IMapVersionInfo
);
begin
  FTileNotifierInternal.TileUpdateNotify(ATile, AZoom);
end;

function TTileStorageAbstract.ScanTiles(
  const AIgnoreTNE: Boolean): IEnumTileInfo;
begin
  Result := nil;
end;

end.
