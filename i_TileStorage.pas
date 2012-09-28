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

unit i_TileStorage;

interface

uses
  Types,
  i_BinaryData,
  i_CoordConverter,
  i_NotifierTileRectUpdate,
  i_MapVersionInfo,
  i_StorageState,
  i_TileInfoBasic;

type
  TGetTileInfoMode = (gtimWithData = 1, gtimWithoutData = -1, gtimAsIs = 0);

  ITileStorage = interface
    ['{80A0246E-68E0-4EA0-9B0F-3338472FDB3C}']
    function GetTileNotifier: INotifierTileRectUpdate;
    property TileNotifier: INotifierTileRectUpdate read GetTileNotifier;

    function GetState: IStorageStateChangeble;
    property State: IStorageStateChangeble read GetState;

    function GetCoordConverter: ICoordConverter;
    property CoordConverter: ICoordConverter read GetCoordConverter;

    function GetTileFileName(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersion: IMapVersionInfo
    ): string;
    function GetTileInfo(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersionInfo: IMapVersionInfo;
      const AMode: TGetTileInfoMode
    ): ITileInfoBasic;
    function DeleteTile(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersion: IMapVersionInfo
    ): Boolean;
    procedure SaveTile(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersion: IMapVersionInfo;
      const AData: IBinaryData
    );
    procedure SaveTNE(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersion: IMapVersionInfo
    );
    function GetListOfTileVersions(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersionInfo: IMapVersionInfo
    ): IMapVersionListStatic;

    function GetTileRectInfo(
      const ARect: TRect;
      const AZoom: byte;
      const AVersionInfo: IMapVersionInfo
    ): ITileRectInfo;

    function ScanTiles(
      const AIgnoreTNE: Boolean
    ): IEnumTileInfo;
  end;

implementation

end.
