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

unit i_ZmpInfo;

interface

uses
  Classes,
  i_Bitmap32Static,
  i_ConfigDataProvider,
  i_CoordConverter,
  i_ContentTypeSubst,
  i_TileDownloaderConfig,
  i_TilePostDownloadCropConfig,
  i_SimpleTileStorageConfig,
  i_MapAbilitiesConfig,
  i_MapAttachmentsInfo,
  i_StringByLanguage,
  i_MapVersionInfo,
  i_TileDownloadRequestBuilderConfig;

type
  IZmpInfoGUI = interface
    ['{60EC2C98-6197-47CE-99FD-C5D9BEA3E750}']
    function GetName: IStringByLanguage;
    property Name: IStringByLanguage read GetName;

    function GetSortIndex: Integer;
    property SortIndex: Integer read GetSortIndex;

    function GetHotKey: TShortCut;
    property HotKey: TShortCut read GetHotKey;

    function GetSeparator: Boolean;
    property Separator: Boolean read GetSeparator;

    function GetLayerZOrder: Integer;
    property LayerZOrder: Integer read GetLayerZOrder;

    function GetParentSubMenu: IStringByLanguage;
    property ParentSubMenu: IStringByLanguage read GetParentSubMenu;

    function GetEnabled: Boolean;
    property Enabled: Boolean read GetEnabled;

    function GetInfoUrl: IStringByLanguage;
    property InfoUrl: IStringByLanguage read GetInfoUrl;

    function GetBmp18: IBitmap32Static;
    property Bmp18: IBitmap32Static read GetBmp18;

    function GetBmp24: IBitmap32Static;
    property Bmp24: IBitmap32Static read GetBmp24;
  end;

  IZmpInfo = interface
    ['{4AD18200-DD3B-42E4-AC57-44C12634C0EB}']
    function GetGUID: TGUID;
    property GUID: TGUID read GetGUID;

    function GetFileName: string;
    property FileName: string read GetFileName;

    function GetLicense: IStringByLanguage;
    property License: IStringByLanguage read GetLicense;

    function GetGUI: IZmpInfoGUI;
    property GUI: IZmpInfoGUI read GetGUI;

    function GetVersionConfig: IMapVersionInfo;
    property VersionConfig: IMapVersionInfo read GetVersionConfig;

    function GetTileDownloadRequestBuilderConfig: ITileDownloadRequestBuilderConfigStatic;
    property TileDownloadRequestBuilderConfig: ITileDownloadRequestBuilderConfigStatic read GetTileDownloadRequestBuilderConfig;

    function GetTileDownloaderConfig: ITileDownloaderConfigStatic;
    property TileDownloaderConfig: ITileDownloaderConfigStatic read GetTileDownloaderConfig;

    function GetTilePostDownloadCropConfig: ITilePostDownloadCropConfigStatic;
    property TilePostDownloadCropConfig: ITilePostDownloadCropConfigStatic read GetTilePostDownloadCropConfig;

    function GetContentTypeSubst: IContentTypeSubst;
    property ContentTypeSubst: IContentTypeSubst read GetContentTypeSubst;

    function GetGeoConvert: ICoordConverter;
    property GeoConvert: ICoordConverter read GetGeoConvert;

    function GetViewGeoConvert: ICoordConverter;
    property ViewGeoConvert: ICoordConverter read GetViewGeoConvert;

    function GetAbilities: IMapAbilitiesConfigStatic;
    property Abilities: IMapAbilitiesConfigStatic read GetAbilities;

    function GetStorageConfig: ISimpleTileStorageConfigStatic;
    property StorageConfig: ISimpleTileStorageConfigStatic read GetStorageConfig;

    function GetDataProvider: IConfigDataProvider;
    property DataProvider: IConfigDataProvider read GetDataProvider;

    function GetMapAttachmentsInfo: IMapAttachmentsInfo;
    property MapAttachmentsInfo: IMapAttachmentsInfo read GetMapAttachmentsInfo;
  end;

implementation

end.
