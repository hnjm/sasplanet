{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2013, SAS.Planet development team.                      *}
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

unit u_TileStorageGoogleEarth;

interface

uses
  Windows,
  SysUtils,
  libge,
  i_BinaryData,
  i_MapVersionInfo,
  i_ContentTypeInfo,
  i_TileInfoBasic,
  i_BasicMemCache,
  i_ContentTypeManager,
  i_CoordConverter,
  i_TileStorage,
  i_MapVersionConfig,
  i_TileInfoBasicMemCache,
  u_TileStorageAbstract;

type
  TTileStorageGoogleEarth = class(TTileStorageAbstract, IBasicMemCache, IEnumTileInfo)
  private
    FMainContentType: IContentTypeInfoBasic;
    FTileNotExistsTileInfo: ITileInfoBasic;
    FTileInfoMemCache: ITileInfoBasicMemCache;
    FCacheProvider: IGoogleEarthCacheProvider;
    FCacheTmProvider: IGoogleEarthCacheProvider;
  private
    function InternalGetTileInfo(
      const AXY: TPoint;
      const AZoom: Byte;
      const AVersionInfo: IMapVersionInfo;
      const AMode: TGetTileInfoMode
    ): ITileInfoBasic;
  protected
    procedure BuildProviders(
      const APath: string;
      const AName: string;
      const AIsTerrainStorage: Boolean
    ); virtual;
  protected
    { ITileStorage }
    function GetIsFileCache: Boolean; override;

    function GetIsCanSaveMultiVersionTiles: Boolean; override;

    function GetTileFileName(
      const AXY: TPoint;
      const AZoom: Byte;
      const AVersionInfo: IMapVersionInfo
    ): string; override;

    function GetTileInfo(
      const AXY: TPoint;
      const AZoom: Byte;
      const AVersionInfo: IMapVersionInfo;
      const AMode: TGetTileInfoMode
    ): ITileInfoBasic; override;

    function GetTileRectInfo(
      const ARect: TRect;
      const AZoom: Byte;
      const AVersionInfo: IMapVersionInfo
    ): ITileRectInfo; override;

    function DeleteTile(
      const AXY: TPoint;
      const AZoom: Byte;
      const AVersionInfo: IMapVersionInfo
    ): Boolean; override;

    procedure SaveTile(
      const AXY: TPoint;
      const AZoom: Byte;
      const AVersionInfo: IMapVersionInfo;
      const ALoadDate: TDateTime;
      const AContentType: IContentTypeInfoBasic;
      const AData: IBinaryData
    ); override;

    procedure SaveTNE(
      const AXY: TPoint;
      const AZoom: Byte;
      const AVersionInfo: IMapVersionInfo;
      const ALoadDate: TDateTime
    ); override;

    function GetListOfTileVersions(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersionInfo: IMapVersionInfo
    ): IMapVersionListStatic; override;

    function ScanTiles(
      const AIgnoreTNE: Boolean;
      const AIgnoreMultiVersionTiles: Boolean
    ): IEnumTileInfo; override;
  private
    { IBasicMemCache }
    procedure ClearMemCache;
    procedure IBasicMemCache.Clear = ClearMemCache;
  private
    { IEnumTileInfo }
    function Next(var ATileInfo: TTileInfo): Boolean;
  public
    constructor Create(
      const AGeoConverter: ICoordConverter;
      const AStoragePath: string;
      const ANameInCache: string;
      const AIsTerrainStorage: Boolean;
      const ATileInfoMemCache: ITileInfoBasicMemCache;
      const AMapVersionFactory: IMapVersionFactory;
      const AMainContentType: IContentTypeInfoBasic
    );
    destructor Destroy; override;
  end;

implementation

uses
  t_CommonTypes,
  i_TileIterator,
  i_InterfaceListSimple,
  u_InterfaceListSimple,
  u_MapVersionListStatic,
  u_TileRectInfoShort,
  u_TileIteratorByRect,
  u_TileStorageTypeAbilities,
  u_TileInfoBasic;

{ TTileStorageGoogleEarth }

constructor TTileStorageGoogleEarth.Create(
  const AGeoConverter: ICoordConverter;
  const AStoragePath: string;
  const ANameInCache: string;
  const AIsTerrainStorage: Boolean;
  const ATileInfoMemCache: ITileInfoBasicMemCache;
  const AMapVersionFactory: IMapVersionFactory;
  const AMainContentType: IContentTypeInfoBasic
);
begin
  inherited Create(
    TTileStorageTypeAbilitiesGE.Create,
    AMapVersionFactory,
    AGeoConverter,
    AStoragePath
  );

  FMainContentType := AMainContentType;
  FTileInfoMemCache := ATileInfoMemCache;
  FTileNotExistsTileInfo := TTileInfoBasicNotExists.Create(0, nil);

  BuildProviders(AStoragePath, ANameInCache, AIsTerrainStorage);
end;

destructor TTileStorageGoogleEarth.Destroy;
begin
  FCacheProvider := nil;
  FCacheTmProvider := nil;
  FTileInfoMemCache := nil;
  FMainContentType := nil;
  FTileNotExistsTileInfo := nil;
  inherited;
end;

procedure TTileStorageGoogleEarth.BuildProviders(
  const APath: string;
  const AName: string;
  const AIsTerrainStorage: Boolean
);
var
  VCachePath: PAnsiChar;
  VCacheFactory: IGoogleEarthCacheProviderFactory;
begin
  FCacheProvider := nil;
  FCacheTmProvider := nil;

  VCachePath := PAnsiChar(APath);
  VCacheFactory := libge.CreateGoogleEarthCacheProviderFactory;

  if VCacheFactory <> nil then begin
    if (AName = '') or SameText(AName, 'earth')  then begin
      if not AIsTerrainStorage then begin
        FCacheProvider := VCacheFactory.CreateEarthProvider(VCachePath);
        FCacheTmProvider := VCacheFactory.CreateEarthTmProvider(VCachePath);
      end else begin
        FCacheProvider := VCacheFactory.CreateEarthTerrainProvider(VCachePath);
      end;
    end else if SameText(AName, 'mars')  then begin
      if not AIsTerrainStorage then begin
        FCacheProvider := VCacheFactory.CreateMarsProvider(VCachePath);
      end else begin
        FCacheProvider := VCacheFactory.CreateMarsTerrainProvider(VCachePath);
      end;
    end else if SameText(AName, 'moon')  then begin
      if not AIsTerrainStorage then begin
        FCacheProvider := VCacheFactory.CreateMoonProvider(VCachePath);
      end else begin
        FCacheProvider := VCacheFactory.CreateMoonTerrainProvider(VCachePath);
      end;
    end else if SameText(AName, 'sky')  then begin
      if not AIsTerrainStorage then begin
        FCacheProvider := VCacheFactory.CreateSkyProvider(VCachePath);
      end;
    end;
  end;
end;

function TTileStorageGoogleEarth.GetIsFileCache: Boolean;
begin
  Result := False;
end;

function TTileStorageGoogleEarth.GetIsCanSaveMultiVersionTiles: Boolean;
begin
  Result := True;
end;

function TTileStorageGoogleEarth.GetTileFileName(
  const AXY: TPoint;
  const AZoom: Byte;
  const AVersionInfo: IMapVersionInfo
): string;
begin
  Result := StoragePath;
end;

procedure ParseVersionInfo(
  const AVersionInfo: IMapVersionInfo;
  out ATileVersion: Word;
  out ATileDate: TDateTime;
  out ASearchAnyVersion: Boolean;
  out ASearchAnyDate: Boolean;
  out AIsTmVersion: Boolean
);
var
  I: Integer;
  VStr: string;
begin
  ATileVersion := 0;
  ATileDate := 0;
  ASearchAnyVersion := True;
  ASearchAnyDate := True;
  AIsTmVersion := False;

  if Assigned(AVersionInfo) and (AVersionInfo.StoreString <> '') then begin
    I := Pos('::', AVersionInfo.StoreString);
    if I > 0 then begin
      AIsTmVersion := True;

      VStr := Copy(AVersionInfo.StoreString, I + 3, Length(AVersionInfo.StoreString) - I - 2);
      ATileDate := StrToDateDef(VStr, 0);

      VStr := Copy(AVersionInfo.StoreString, 1, I - 2);
      ATileVersion := StrToIntDef(VStr, 0);

      ASearchAnyVersion := AVersionInfo.ShowPrevVersion;
      ASearchAnyDate := AVersionInfo.ShowPrevVersion;
    end else if AVersionInfo.StoreString <> '' then begin
      ATileVersion := StrToIntDef(AVersionInfo.StoreString, 0);
      ASearchAnyVersion := AVersionInfo.ShowPrevVersion;
    end;
  end;
end;

function BuildVersionStr(
  const ATileVersion: Word;
  const ATileDate: TDateTime;
  const AIsTmVersion: Boolean
): string;
begin
  if AIsTmVersion then begin
    Result := IntToStr(ATileVersion) + ' :: ' + DateToStr(ATileDate);
  end else begin
    Result := IntToStr(ATileVersion);
  end;
end;

function TTileStorageGoogleEarth.InternalGetTileInfo(
  const AXY: TPoint;
  const AZoom: Byte;
  const AVersionInfo: IMapVersionInfo;
  const AMode: TGetTileInfoMode
): ITileInfoBasic;
var
  VResult: Boolean;
  VData: IInterface;
  VInTileVersion: Word;
  VInTileDate: TDateTime;
  VOutTileVersion: Word;
  VOutTileDate: TDateTime;
  VTileSize: Integer;
  VWithData: Boolean;
  VSearchAnyVersion: Boolean;
  VSearchAnyDate: Boolean;
  VIsTmVersion: Boolean;
  VBinData: IBinaryData;
  VTileVersionStr: string;
  VImageTileContentProvider: IGoogleEarthImageTileProvider;
  VTerrainTileContentProvider: IGoogleEarthTerrainTileProvider;
begin
  Result := nil;

  ParseVersionInfo(
    AVersionInfo,
    VInTileVersion,
    VInTileDate,
    VSearchAnyVersion,
    VSearchAnyDate,
    VIsTmVersion
  );

  VWithData := AMode in [gtimWithData];
  VResult := False;

  if VIsTmVersion then begin
    if (FCacheTmProvider <> nil) then begin
      VResult := FCacheTmProvider.GetTileInfo(
        AXY,
        AZoom,
        VInTileVersion,
        VInTileDate,
        VSearchAnyVersion,
        VSearchAnyDate,
        VWithData,
        VTileSize,
        VOutTileVersion,
        VOutTileDate,
        VData
      );
    end;
    if not VResult and VSearchAnyVersion and (FCacheProvider <> nil) then begin
      VResult := FCacheProvider.GetTileInfo(
        AXY,
        AZoom,
        0,
        0,
        True,
        True,
        VWithData,
        VTileSize,
        VOutTileVersion,
        VOutTileDate,
        VData
      );
    end;
  end else begin
    if (FCacheProvider <> nil) then begin
      VResult := FCacheProvider.GetTileInfo(
        AXY,
        AZoom,
        VInTileVersion,
        VInTileDate,
        VSearchAnyVersion,
        VSearchAnyDate,
        VWithData,
        VTileSize,
        VOutTileVersion,
        VOutTileDate,
        VData
      );
    end;
    if not VResult and VSearchAnyVersion and (FCacheTmProvider <> nil) then begin
      VResult := FCacheTmProvider.GetTileInfo(
        AXY,
        AZoom,
        0,
        0,
        True,
        True,
        VWithData,
        VTileSize,
        VOutTileVersion,
        VOutTileDate,
        VData
      );
    end;
  end; 

  if VResult then begin
    VTileVersionStr := BuildVersionStr(VOutTileVersion, VOutTileDate, VIsTmVersion);
    if VWithData then begin
      if Supports(VData, IGoogleEarthImageTileProvider, VImageTileContentProvider) then begin
        VBinData := VImageTileContentProvider.GetJPEG;
      end else if Supports(VData, IGoogleEarthTerrainTileProvider, VTerrainTileContentProvider) then begin
        VBinData := VTerrainTileContentProvider.GetKML;
      end else begin
        VBinData := nil;
      end;

      if Assigned(VBinData) then begin
        Result :=
          TTileInfoBasicExistsWithTile.Create(
            VOutTileDate,
            VBinData,
            MapVersionFactory.CreateByStoreString(VTileVersionStr, VSearchAnyVersion),
            FMainContentType
          );
      end;
    end else begin
      Result :=
        TTileInfoBasicExists.Create(
          VOutTileDate,
          VTileSize,
          MapVersionFactory.CreateByStoreString(VTileVersionStr, VSearchAnyVersion),
          FMainContentType
        );
    end;
  end; 
end;

function TTileStorageGoogleEarth.GetTileInfo(
  const AXY: TPoint;
  const AZoom: Byte;
  const AVersionInfo: IMapVersionInfo;
  const AMode: TGetTileInfoMode
): ITileInfoBasic;
begin
  if Assigned(FTileInfoMemCache) then begin
    Result := FTileInfoMemCache.Get(AXY, AZoom, AVersionInfo, AMode, True);
    if Result <> nil then begin
      Exit;
    end;
  end;

  Result := FTileNotExistsTileInfo;

  if GetState.GetStatic.ReadAccess <> asDisabled then begin
    Result := InternalGetTileInfo(AXY, AZoom, AVersionInfo, AMode);

    if not Assigned(Result) then begin
      Result := TTileInfoBasicNotExists.Create(0, AVersionInfo);
    end;
  end;

  if Assigned(FTileInfoMemCache) then begin
    FTileInfoMemCache.Add(AXY, AZoom, AVersionInfo, Result);
  end;
end;

function TTileStorageGoogleEarth.GetListOfTileVersions(
  const AXY: TPoint;
  const AZoom: byte;
  const AVersionInfo: IMapVersionInfo
): IMapVersionListStatic;
var
  I: Integer;
  VTileVersion: Word;
  VTileDate: TDateTime;
  VTileSize: Integer;
  VVersionStr: string;
  VShowPrevVersion: Boolean;
  VList: IGoogleEarthTileInfoList;
  VListSimple: IInterfaceListSimple;
  VMapVersionInfo: IMapVersionInfo;
begin
  Result := nil;
  if GetState.GetStatic.ReadAccess <> asDisabled then begin
    VShowPrevVersion := Assigned(AVersionInfo) and AVersionInfo.ShowPrevVersion;
    VListSimple := TInterfaceListSimple.Create;

    if FCacheProvider <> nil then begin
      VList := FCacheProvider.GetListOfTileVersions(AXY, AZoom, 0, 0);
      if Assigned(VList) then begin
        for I := 0 to VList.Count - 1 do begin
          if VList.Get(I, VTileSize, VTileVersion, VTileDate) then begin
            VVersionStr := BuildVersionStr(VTileVersion, VTileDate, False);
            VMapVersionInfo := MapVersionFactory.CreateByStoreString(VVersionStr, VShowPrevVersion);
            VListSimple.Add(VMapVersionInfo);
          end;
        end;
      end;
    end;

    if FCacheTmProvider <> nil then begin 
      VList := FCacheTmProvider.GetListOfTileVersions(AXY, AZoom, 0, 0);
      if Assigned(VList) then begin
        for I := 0 to VList.Count - 1 do begin
          if VList.Get(I, VTileSize, VTileVersion, VTileDate) then begin
            VVersionStr := BuildVersionStr(VTileVersion, VTileDate, True);
            VMapVersionInfo := MapVersionFactory.CreateByStoreString(VVersionStr, VShowPrevVersion);
            VListSimple.Add(VMapVersionInfo);
          end;
        end;
      end;
    end;

    if VListSimple.Count > 0 then begin
      Result := TMapVersionListStatic.Create(VListSimple.MakeStaticAndClear);
    end;
  end;
end;

function TTileStorageGoogleEarth.GetTileRectInfo(
  const ARect: TRect;
  const AZoom: Byte;
  const AVersionInfo: IMapVersionInfo
): ITileRectInfo;
var
  VRect: TRect;
  VZoom: Byte;
  VCount: TPoint;
  VItems: TArrayOfTileInfoShortInternal;
  VIndex: Integer;
  VTile: TPoint;
  VIterator: ITileIterator;
  VTileInfo: ITileInfoBasic;
begin
  Result := nil;
  if GetState.GetStatic.ReadAccess <> asDisabled then begin
    VRect := ARect;
    VZoom := AZoom;
    GeoConverter.CheckTileRect(VRect, VZoom);
    VCount.X := VRect.Right - VRect.Left;
    VCount.Y := VRect.Bottom - VRect.Top;
    if (VCount.X > 0) and (VCount.Y > 0) and (VCount.X <= 2048) and (VCount.Y <= 2048) then begin
      SetLength(VItems, VCount.X * VCount.Y);
      VIterator := TTileIteratorByRect.Create(VRect);
      while VIterator.Next(VTile) do begin
        VIndex := TTileRectInfoShort.TileInRectToIndex(VTile, VRect);
        Assert(VIndex >=0);
        if VIndex >= 0 then begin
          VTileInfo := InternalGetTileInfo(VTile, VZoom, AVersionInfo, gtimWithoutData);
          if Assigned(VTileInfo) then begin
            VItems[VIndex].FLoadDate := 0;
            VItems[VIndex].FSize := VTileInfo.Size;
            VItems[VIndex].FInfoType := titExists;
          end else begin
            VItems[VIndex].FLoadDate := 0;
            VItems[VIndex].FSize := 0;
            VItems[VIndex].FInfoType := titNotExists;
          end;
        end;
      end;
      Result :=
        TTileRectInfoShort.CreateWithOwn(
          VRect,
          VZoom,
          nil,
          FMainContentType,
          VItems
        );
      VItems := nil;
    end;
  end;
end;

procedure TTileStorageGoogleEarth.SaveTile(
  const AXY: TPoint;
  const AZoom: Byte;
  const AVersionInfo: IMapVersionInfo;
  const ALoadDate: TDateTime;
  const AContentType: IContentTypeInfoBasic;
  const AData: IBinaryData
);
begin
  Abort;
end;

procedure TTileStorageGoogleEarth.SaveTNE(
  const AXY: TPoint;
  const AZoom: Byte;
  const AVersionInfo: IMapVersionInfo;
  const ALoadDate: TDateTime
);
begin
  Abort;
end;

function TTileStorageGoogleEarth.DeleteTile(
  const AXY: TPoint;
  const AZoom: Byte;
  const AVersionInfo: IMapVersionInfo
): Boolean;
begin
  Result := False;
end;

function TTileStorageGoogleEarth.ScanTiles(
  const AIgnoreTNE: Boolean;
  const AIgnoreMultiVersionTiles: Boolean
): IEnumTileInfo;
begin
  // ToDo: Prepare tile iterator
  Result := Self as IEnumTileInfo;
end;

function TTileStorageGoogleEarth.Next(var ATileInfo: TTileInfo): Boolean;
begin
  Result := False; // ToDo
end;

procedure TTileStorageGoogleEarth.ClearMemCache;
begin
  if Assigned(FTileInfoMemCache) then begin
    FTileInfoMemCache.Clear;
  end;
end;

end.
