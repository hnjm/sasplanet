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

unit u_TileStorageInRAM;

interface

uses
  Types,
  SysUtils,
  i_BinaryData,
  i_MapVersionInfo,
  i_ContentTypeInfo,
  i_TileInfoBasic,
  i_BasicMemCache,
  i_CoordConverter,
  i_TileStorage,
  i_MapVersionConfig,
  i_TileInfoBasicMemCache,
  u_TileStorageAbstract;

type
  TTileStorageInRAM = class(TTileStorageAbstract, IBasicMemCache)
  private
    FMainContentType: IContentTypeInfoBasic;
    FTileNotExistsTileInfo: ITileInfoBasic;
    FTileInfoMemCache: ITileInfoBasicMemCache;
  protected
    function GetIsFileCache: Boolean; override;

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
  private
    { IBasicMemCache }
    procedure ClearMemCache;
    procedure IBasicMemCache.Clear = ClearMemCache;
  public
    constructor Create(
      const ATileInfoMemCache: ITileInfoBasicMemCache;
      const AGeoConverter: ICoordConverter;
      const AMapVersionFactory: IMapVersionFactory;
      const AMainContentType: IContentTypeInfoBasic
    );
    destructor Destroy; override;
  end;

implementation

uses
  t_CommonTypes,
  i_TileIterator,   
  u_TileRectInfoShort,
  u_TileIteratorByRect,
  u_TileStorageTypeAbilities,
  u_TileInfoBasic;

type
  ETileStorageInRAM = class(Exception);

resourcestring
  rsMemCacheNotAssigned =
    'Can''t initialize in-memory tile storage. Check your config!';

{ TTileStorageInRAM }

constructor TTileStorageInRAM.Create(
  const ATileInfoMemCache: ITileInfoBasicMemCache;
  const AGeoConverter: ICoordConverter;
  const AMapVersionFactory: IMapVersionFactory;
  const AMainContentType: IContentTypeInfoBasic
);
begin
  if not Assigned(ATileInfoMemCache) then begin
    raise ETileStorageInRAM.Create(rsMemCacheNotAssigned);
  end;

  inherited Create(
    TTileStorageTypeAbilitiesRAM.Create,
    AMapVersionFactory,
    AGeoConverter,
    ''
  );
  FTileInfoMemCache := ATileInfoMemCache;
  FMainContentType := AMainContentType;

  FTileNotExistsTileInfo := TTileInfoBasicNotExists.Create(0, nil);
end;

destructor TTileStorageInRAM.Destroy;
begin
  FTileInfoMemCache := nil;
  FMainContentType := nil;
  FTileNotExistsTileInfo := nil;
  inherited Destroy;
end;

function TTileStorageInRAM.GetIsFileCache: Boolean;
begin
  Result := False;
end;

function TTileStorageInRAM.GetTileFileName(
  const AXY: TPoint;
  const AZoom: Byte;
  const AVersionInfo: IMapVersionInfo
): string;
begin
  Result := ':: memory';
end;

function TTileStorageInRAM.GetTileInfo(
  const AXY: TPoint;
  const AZoom: Byte;
  const AVersionInfo: IMapVersionInfo;
  const AMode: TGetTileInfoMode
): ITileInfoBasic;
begin
  Result := FTileInfoMemCache.Get(AXY, AZoom, AVersionInfo, AMode, False);
  if Result = nil then begin
    Result := FTileNotExistsTileInfo;
    FTileInfoMemCache.Add(AXY, AZoom, AVersionInfo, FTileNotExistsTileInfo);
  end;
end;

function TTileStorageInRAM.GetTileRectInfo(
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
          VTileInfo := GetTileInfo(VTile, VZoom, AVersionInfo, gtimWithoutData);
          if VTileInfo.IsExists then begin
            // tile exists
            VItems[VIndex].FLoadDate := VTileInfo.LoadDate;
            VItems[VIndex].FSize := VTileInfo.Size;
            VItems[VIndex].FInfoType := titExists;
          end else if VTileInfo.IsExistsTNE then begin
            // tne exists
            VItems[VIndex].FLoadDate := VTileInfo.LoadDate;
            VItems[VIndex].FSize := 0;
            VItems[VIndex].FInfoType := titTneExists;
          end else begin
            // neither tile nor tne
            VItems[VIndex].FLoadDate := 0;
            VItems[VIndex].FSize := 0;
            VItems[VIndex].FInfoType := titNotExists;
          end;
        end else begin
          // neither tile nor tne
          VItems[VIndex].FLoadDate := 0;
          VItems[VIndex].FSize := 0;
          VItems[VIndex].FInfoType := titNotExists;
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

procedure TTileStorageInRAM.SaveTile(
  const AXY: TPoint;
  const AZoom: Byte;
  const AVersionInfo: IMapVersionInfo;
  const ALoadDate: TDateTime;
  const AContentType: IContentTypeInfoBasic;
  const AData: IBinaryData
);
var
  VTileInfo: ITileInfoBasic;
begin
  if GetState.GetStatic.WriteAccess <> asDisabled then begin
    if not FMainContentType.CheckOtherForSaveCompatible(AContentType) then begin
      raise ETileStorageInRAM.Create('Bad content type for this tile storage');
    end;
    VTileInfo :=
      TTileInfoBasicExistsWithTile.Create(
        ALoadDate,
        AData,
        AVersionInfo,
        FMainContentType
      );
    FTileInfoMemCache.Add(AXY, AZoom, AVersionInfo, VTileInfo);
    NotifyTileUpdate(AXY, AZoom, AVersionInfo);
  end;
end;

procedure TTileStorageInRAM.SaveTNE(
  const AXY: TPoint;
  const AZoom: Byte;
  const AVersionInfo: IMapVersionInfo;
  const ALoadDate: TDateTime
);
begin
  if GetState.GetStatic.WriteAccess <> asDisabled then begin
    FTileInfoMemCache.Add(
      AXY,
      AZoom,
      AVersionInfo,
      TTileInfoBasicTNE.Create(ALoadDate, AVersionInfo)
    );
    NotifyTileUpdate(AXY, AZoom, AVersionInfo);
  end;
end;

function TTileStorageInRAM.DeleteTile(
  const AXY: TPoint;
  const AZoom: Byte;
  const AVersionInfo: IMapVersionInfo
): Boolean;
begin
  Result := False;
  if GetState.GetStatic.DeleteAccess <> asDisabled then begin
    FTileInfoMemCache.Add(
      AXY,
      AZoom,
      AVersionInfo,
      TTileInfoBasicNotExists.Create(0, AVersionInfo)
    );
    NotifyTileUpdate(AXY, AZoom, AVersionInfo);
  end;
end;

procedure TTileStorageInRAM.ClearMemCache;
begin
  if Assigned(FTileInfoMemCache) then begin
    FTileInfoMemCache.Clear;
  end;
end;

end.
