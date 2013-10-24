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

unit u_MapType;

interface

uses
  SysUtils,
  GR32,
  t_GeoTypes,
  i_Bitmap32Static,
  i_Bitmap32StaticFactory,
  i_FillingMapColorer,
  i_ThreadConfig,
  i_ContentTypeInfo,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_NotifierOperation,
  i_LocalCoordConverter,
  i_LayerDrawConfig,
  i_TileObjCache,
  i_TileDownloaderConfig,
  i_LanguageManager,
  i_CoordConverter,
  i_MapVersionConfig,
  i_MapVersionFactoryList,
  i_TileDownloadRequestBuilderConfig,
  i_HashFunction,
  i_BitmapTileSaveLoad,
  i_VectorDataLoader,
  i_NotifierTime,
  i_DownloadResultFactory,
  i_InetConfig,
  i_ImageResamplerConfig,
  i_ContentTypeManager,
  i_GlobalDownloadConfig,
  i_MapAbilitiesConfig,
  i_Listener,
  i_MapAttachmentsFactory,
  i_MapVersionInfo,
  i_SimpleTileStorageConfig,
  i_ZmpInfo,
  i_InvisibleBrowser,
  i_MapTypeGUIConfig,
  i_CoordConverterFactory,
  i_MainMemCacheConfig,
  i_TileFileNameGeneratorsList,
  i_TileFileNameParsersList,
  i_VectorItemSubset,
  i_VectorDataFactory,
  i_ProjConverter,
  i_TileDownloadSubsystem,
  i_InternalPerformanceCounter,
  i_GlobalBerkeleyDBHelper,
  i_TileInfoBasicMemCache,
  i_GlobalCacheConfig,
  i_TileStorage;

type
  TMapType = class
  private
    FZmp: IZmpInfo;
    FMapDataUrlPrefix: string;
    FCacheTileInfo: ITileInfoBasicMemCache;
    FCacheBitmap: ITileObjCacheBitmap;
    FCacheVector: ITileObjCacheVector;
    FStorage: ITileStorage;
    FBitmapLoaderFromStorage: IBitmapTileLoader;
    FBitmapSaverToStorage: IBitmapTileSaver;
    FKmlLoaderFromStorage: IVectorDataLoader;
    FVectorDataFactory: IVectorDataFactory;
    FCoordConverter: ICoordConverter;
    FViewCoordConverter: ICoordConverter;
    FLoadPrevMaxZoomDelta: Integer;
    FContentType: IContentTypeInfoBasic;
    FLanguageManager: ILanguageManager;
    FVersionConfig: IMapVersionConfig;
    FTileDownloaderConfig: ITileDownloaderConfig;
    FTileDownloadRequestBuilderConfig: ITileDownloadRequestBuilderConfig;
    FDownloadResultFactory: IDownloadResultFactory;
    FResamplerConfigLoad: IImageResamplerConfig;
    FResamplerConfigGetPrev: IImageResamplerConfig;
    FResamplerConfigChangeProjection: IImageResamplerConfig;
    FBitmapFactory: IBitmap32StaticFactory;
    FContentTypeManager: IContentTypeManager;
    FGlobalDownloadConfig: IGlobalDownloadConfig;
    FGUIConfig: IMapTypeGUIConfig;
    FLayerDrawConfig: ILayerDrawConfig;
    FAbilitiesConfig: IMapAbilitiesConfig;
    FMapAttachmentsFactory: IMapAttachmentsFactory;
    FStorageConfig: ISimpleTileStorageConfig;
    FGlobalCacheConfig: IGlobalCacheConfig;
    FTileDownloadSubsystem: ITileDownloadSubsystem;
    FPerfCounterList: IInternalPerformanceCounterList;

    FVersionChangeListener: IListener;
    procedure OnVersionChange;

    function GetIsBitmapTiles: Boolean;
    function GetIsKmlTiles: Boolean;
    procedure SaveBitmapTileToStorage(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersion: IMapVersionInfo;
      const ABitmap: IBitmap32Static
    );
    function LoadBitmapTileFromStorage(
      const AXY: TPoint;
      const AZoom: Byte;
      const AVersion: IMapVersionInfo
    ): IBitmap32Static;
    function LoadKmlTileFromStorage(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersion: IMapVersionInfo
    ): IVectorItemSubset;
    function LoadTileFromPreZ(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersion: IMapVersionInfo;
      IgnoreError: Boolean;
      const ACache: ITileObjCacheBitmap = nil
    ): IBitmap32Static;
    function LoadTileOrPreZ(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersion: IMapVersionInfo;
      IgnoreError: Boolean;
      AUsePre: Boolean;
      const ACache: ITileObjCacheBitmap = nil
    ): IBitmap32Static;
  public
    procedure SaveConfig(const ALocalConfig: IConfigDataWriteProvider);
    procedure ClearMemCache;
    function GetTileShowName(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersion: IMapVersionInfo
    ): string;
    function LoadTile(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersion: IMapVersionInfo;
      IgnoreError: Boolean;
      const ACache: ITileObjCacheBitmap = nil
    ): IBitmap32Static;
    function LoadTileVector(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersion: IMapVersionInfo;
      IgnoreError: Boolean;
      const ACache: ITileObjCacheVector = nil
    ): IVectorItemSubset;
    function LoadTileUni(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersion: IMapVersionInfo;
      const ACoordConverterTarget: ICoordConverter;
      AUsePre, AAllowPartial, IgnoreError: Boolean;
      const ACache: ITileObjCacheBitmap = nil
    ): IBitmap32Static;
    function LoadBitmap(
      const APixelRectTarget: TRect;
      const AZoom: byte;
      const AVersion: IMapVersionInfo;
      AUsePre, AAllowPartial, IgnoreError: Boolean;
      const ACache: ITileObjCacheBitmap = nil
    ): IBitmap32Static;
    function LoadBitmapUni(
      const APixelRectTarget: TRect;
      const AZoom: byte;
      const AVersion: IMapVersionInfo;
      const ACoordConverterTarget: ICoordConverter;
      AUsePre, AAllowPartial, IgnoreError: Boolean;
      const ACache: ITileObjCacheBitmap = nil
    ): IBitmap32Static;
    procedure SaveTileSimple(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersion: IMapVersionInfo;
      const ABitmap: IBitmap32Static
    );
    function GetFillingMapBitmap(
      AOperationID: Integer;
      const ACancelNotifier: INotifierOperation;
      const ALocalConverter: ILocalCoordConverter;
      ASourceZoom: byte;
      const AVersion: IMapVersionInfo;
      const AColorer: IFillingMapColorer
    ): IBitmap32Static;

    function GetShortFolderName: string;

    property Zmp: IZmpInfo read FZmp;
    property GeoConvert: ICoordConverter read FCoordConverter;
    property ViewGeoConvert: ICoordConverter read FViewCoordConverter;
    property VersionConfig: IMapVersionConfig read FVersionConfig;
    property ContentType: IContentTypeInfoBasic read FContentType;

    property Abilities: IMapAbilitiesConfig read FAbilitiesConfig;
    property StorageConfig: ISimpleTileStorageConfig read FStorageConfig;
    property IsBitmapTiles: Boolean read GetIsBitmapTiles;
    property IsKmlTiles: Boolean read GetIsKmlTiles;

    property TileDownloadSubsystem: ITileDownloadSubsystem read FTileDownloadSubsystem;
    property TileStorage: ITileStorage read FStorage;
    property GUIConfig: IMapTypeGUIConfig read FGUIConfig;
    property LayerDrawConfig: ILayerDrawConfig read FLayerDrawConfig;
    property TileDownloaderConfig: ITileDownloaderConfig read FTileDownloaderConfig;
    property TileDownloadRequestBuilderConfig: ITileDownloadRequestBuilderConfig read FTileDownloadRequestBuilderConfig;
    property CacheBitmap: ITileObjCacheBitmap read FCacheBitmap;
    property CacheVector: ITileObjCacheVector read FCacheVector;

    constructor Create(
      const ALanguageManager: ILanguageManager;
      const AZmp: IZmpInfo;
      const AMapVersionFactoryList: IMapVersionFactoryList;
      const AMainMemCacheConfig: IMainMemCacheConfig;
      const AGlobalCacheConfig: IGlobalCacheConfig;
      const AGlobalBerkeleyDBHelper: IGlobalBerkeleyDBHelper;
      const ATileNameGeneratorList: ITileFileNameGeneratorsList;
      const ATileNameParserList: ITileFileNameParsersList;
      const AGCNotifier: INotifierTime;
      const AAppClosingNotifier: INotifierOneOperation;
      const AInetConfig: IInetConfig;
      const AResamplerConfigLoad: IImageResamplerConfig;
      const AResamplerConfigGetPrev: IImageResamplerConfig;
      const AResamplerConfigChangeProjection: IImageResamplerConfig;
      const AResamplerConfigDownload: IImageResamplerConfig;
      const ABitmapFactory: IBitmap32StaticFactory;
      const AHashFunction: IHashFunction;
      const ADownloadConfig: IGlobalDownloadConfig;
      const ADownloaderThreadConfig: IThreadConfig;
      const AContentTypeManager: IContentTypeManager;
      const ACoordConverterFactory: ICoordConverterFactory;
      const AInvisibleBrowser: IInvisibleBrowser;
      const AProjFactory: IProjConverterFactory;
      const AConfig: IConfigDataProvider;
      const APerfCounterList: IInternalPerformanceCounterList
    );
    destructor Destroy; override;
  end;

implementation

uses
  Types,
  c_CacheTypeCodes,
  c_InternalBrowser,
  i_BasicMemCache,
  i_BinaryData,
  i_TileInfoBasic,
  i_TileIterator,
  u_StringProviderForMapTileItem,
  u_LayerDrawConfig,
  u_TileDownloaderConfig,
  u_TileDownloadRequestBuilderConfig,
  u_DownloadResultFactory,
  u_MemTileCache,
  u_SimpleTileStorageConfig,
  u_MapAbilitiesConfig,
  u_TileIteratorByRect,
  u_VectorDataFactoryForMap,
  u_HtmlToHintTextConverterStuped,
  u_MapTypeGUIConfig,
  u_MapVersionConfig,
  u_TileDownloadSubsystem,
  u_Bitmap32ByStaticBitmap,
  u_GeoFun,
  u_BitmapFunc,
  u_TileStorageOfMapType,
  u_TileInfoBasicMemCache,
  u_ListenerByEvent;

procedure TMapType.ClearMemCache;
var
  VBasicMemCache: IBasicMemCache;
begin
  if FCacheTileInfo <> nil then begin
    FCacheTileInfo.Clear;
  end;
  if FCacheBitmap <> nil then begin
    FCacheBitmap.Clear;
  end;
  if FCacheVector <> nil then begin
    FCacheVector.Clear;
  end;
  // clear internal MemCache
  if Assigned(FStorage) then
  if Supports(FStorage, IBasicMemCache, VBasicMemCache) then begin
    VBasicMemCache.Clear;
  end;
end;

constructor TMapType.Create(
  const ALanguageManager: ILanguageManager;
  const AZmp: IZmpInfo;
  const AMapVersionFactoryList: IMapVersionFactoryList;
  const AMainMemCacheConfig: IMainMemCacheConfig;
  const AGlobalCacheConfig: IGlobalCacheConfig;
  const AGlobalBerkeleyDBHelper: IGlobalBerkeleyDBHelper;
  const ATileNameGeneratorList: ITileFileNameGeneratorsList;
  const ATileNameParserList: ITileFileNameParsersList;
  const AGCNotifier: INotifierTime;
  const AAppClosingNotifier: INotifierOneOperation;
  const AInetConfig: IInetConfig;
  const AResamplerConfigLoad: IImageResamplerConfig;
  const AResamplerConfigGetPrev: IImageResamplerConfig;
  const AResamplerConfigChangeProjection: IImageResamplerConfig;
  const AResamplerConfigDownload: IImageResamplerConfig;
  const ABitmapFactory: IBitmap32StaticFactory;
  const AHashFunction: IHashFunction;
  const ADownloadConfig: IGlobalDownloadConfig;
  const ADownloaderThreadConfig: IThreadConfig;
  const AContentTypeManager: IContentTypeManager;
  const ACoordConverterFactory: ICoordConverterFactory;
  const AInvisibleBrowser: IInvisibleBrowser;
  const AProjFactory: IProjConverterFactory;
  const AConfig: IConfigDataProvider;
  const APerfCounterList: IInternalPerformanceCounterList
);
var
  VTypeCode: Byte;
  VContentTypeBitmap: IContentTypeInfoBitmap;
  VContentTypeKml: IContentTypeInfoVectorData;
  VMapVersionChanger: IMapVersionChanger;
begin
  inherited Create;
  FZmp := AZmp;
  FPerfCounterList := APerfCounterList.CreateAndAddNewSubList(FZmp.GUI.Name.GetDefault);
  FGUIConfig :=
    TMapTypeGUIConfig.Create(
      ALanguageManager,
      FZmp.GUI
    );
  FLayerDrawConfig := TLayerDrawConfig.Create(FZmp);
  FMapAttachmentsFactory := nil;
  FLanguageManager := ALanguageManager;
  FResamplerConfigLoad := AResamplerConfigLoad;
  FResamplerConfigGetPrev := AResamplerConfigGetPrev;
  FResamplerConfigChangeProjection := AResamplerConfigChangeProjection;
  FGlobalCacheConfig := AGlobalCacheConfig;
  FGlobalDownloadConfig := ADownloadConfig;
  FBitmapFactory := ABitmapFactory;
  FContentTypeManager := AContentTypeManager;
  FTileDownloaderConfig := TTileDownloaderConfig.Create(AInetConfig, FZmp.TileDownloaderConfig);
  FTileDownloadRequestBuilderConfig := TTileDownloadRequestBuilderConfig.Create(FZmp.TileDownloadRequestBuilderConfig);

  VTypeCode := FZmp.StorageConfig.CacheTypeCode;
  if VTypeCode = c_File_Cache_Id_DEFAULT then begin
    VTypeCode := FGlobalCacheConfig.DefCache;
  end;

  FVersionConfig := TMapVersionConfig.Create(FZmp.VersionConfig, AMapVersionFactoryList.GetVersionFactoryByCode(VTypeCode));
  FVersionChangeListener := TNotifyNoMmgEventListener.Create(Self.OnVersionChange);
  FVersionConfig.ChangeNotifier.Add(FVersionChangeListener);

  FStorageConfig := TSimpleTileStorageConfig.Create(FZmp.StorageConfig);
  FAbilitiesConfig :=
    TMapAbilitiesConfig.Create(
      FZmp.Abilities,
      FStorageConfig
    );
  FDownloadResultFactory := TDownloadResultFactory.Create;

  FGUIConfig.ReadConfig(AConfig);
  FLayerDrawConfig.ReadConfig(AConfig);
  FStorageConfig.ReadConfig(AConfig);
  FAbilitiesConfig.ReadConfig(AConfig);
  FVersionConfig.ReadConfig(AConfig);
  FTileDownloaderConfig.ReadConfig(AConfig);
  FTileDownloadRequestBuilderConfig.ReadConfig(AConfig);
  FContentType := FContentTypeManager.GetInfoByExt(FStorageConfig.TileFileExt);
  FCoordConverter := FStorageConfig.CoordConverter;
  FViewCoordConverter := FZmp.ViewGeoConvert;

  if FStorageConfig.UseMemCache then begin
    FCacheTileInfo :=
      TTileInfoBasicMemCache.Create(
        FStorageConfig.MemCacheCapacity,
        FStorageConfig.MemCacheTTL,
        FStorageConfig.MemCacheClearStrategy,
        AGCNotifier,
        FPerfCounterList.CreateAndAddNewSubList('TileInfoInMem')
      );
  end else begin
    FCacheTileInfo := nil;
  end;

  FStorage :=
    TTileStorageOfMapType.Create(
      FGlobalCacheConfig,
      AGlobalBerkeleyDBHelper,
      FStorageConfig,
      FCacheTileInfo,
      FVersionConfig,
      AGCNotifier,
      AContentTypeManager,
      ATileNameGeneratorList,
      ATileNameParserList,
      FPerfCounterList
    );
  if Supports(FContentType, IContentTypeInfoBitmap, VContentTypeBitmap) then begin
    FBitmapLoaderFromStorage := VContentTypeBitmap.GetLoader;
    FBitmapSaverToStorage := VContentTypeBitmap.GetSaver;
    FCacheBitmap :=
      TMemTileCacheBitmap.Create(
        AGCNotifier,
        FStorage,
        FStorageConfig.CoordConverter,
        AMainMemCacheConfig,
        FPerfCounterList.CreateAndAddNewSubList('BmpInMem')
      );
  end else if Supports(FContentType, IContentTypeInfoVectorData, VContentTypeKml) then begin
    FKmlLoaderFromStorage := VContentTypeKml.GetLoader;
    FCacheVector :=
      TMemTileCacheVector.Create(
        AGCNotifier,
        FStorage,
        FStorageConfig.CoordConverter,
        AMainMemCacheConfig,
        FPerfCounterList.CreateAndAddNewSubList('VectorInMem')
      );
    FMapDataUrlPrefix := CMapDataInternalURL + GUIDToString(FZmp.GUID) + '/';
    FVectorDataFactory :=
      TVectorDataFactoryForMap.Create(
        AHashFunction,
        THtmlToHintTextConverterStuped.Create
      );
  end;

  if Supports(FStorage, IMapVersionChanger, VMapVersionChanger) then begin
    VMapVersionChanger.SetMapVersionConfig(FVersionConfig);
  end;

  FTileDownloadSubsystem :=
    TTileDownloadSubsystem.Create(
      AGCNotifier,
      AAppClosingNotifier,
      FCoordConverter,
      ACoordConverterFactory,
      FLanguageManager,
      FGlobalDownloadConfig,
      AInvisibleBrowser,
      FDownloadResultFactory,
      FZmp.TileDownloaderConfig,
      AResamplerConfigDownload,
      ABitmapFactory,
      FTileDownloaderConfig,
      ADownloaderThreadConfig,
      FTileDownloadRequestBuilderConfig,
      FContentTypeManager,
      FZmp.ContentTypeSubst,
      FContentType,
      FZmp.TilePostDownloadCropConfig,
      FZmp.EmptyTileSamples,
      FZmp.BanTileSamples,
      FAbilitiesConfig,
      FZmp.DataProvider,
      AProjFactory,
      FStorageConfig,
      FStorage
    );

  if FZmp.IsLayer then begin
    FLoadPrevMaxZoomDelta := 4;
  end else begin
    FLoadPrevMaxZoomDelta := 6;
  end;
end;

destructor TMapType.Destroy;
begin
  if Assigned(FVersionConfig) and Assigned(FVersionChangeListener) then begin
    FVersionConfig.ChangeNotifier.Remove(FVersionChangeListener);
    FVersionConfig := nil;
    FVersionChangeListener := nil;
  end;

  FCoordConverter := nil;
  FCacheBitmap := nil;
  FCacheVector := nil;
  FCacheTileInfo := nil;
  FTileDownloadSubsystem := nil;
  FBitmapLoaderFromStorage := nil;
  FBitmapSaverToStorage := nil;
  FKmlLoaderFromStorage := nil;
  FViewCoordConverter := nil;
  FContentType := nil;
  FLanguageManager := nil;
  FTileDownloaderConfig := nil;
  FTileDownloadRequestBuilderConfig := nil;
  FDownloadResultFactory := nil;
  FResamplerConfigLoad := nil;
  FResamplerConfigGetPrev := nil;
  FResamplerConfigChangeProjection := nil;
  FContentTypeManager := nil;
  FGlobalDownloadConfig := nil;
  FGUIConfig := nil;
  FMapAttachmentsFactory := nil;
  FAbilitiesConfig := nil;
  FGlobalCacheConfig := nil;
  FStorageConfig := nil;
  FStorage := nil;
  inherited;
end;

procedure TMapType.SaveBitmapTileToStorage(
  const AXY: TPoint;
  const AZoom: byte;
  const AVersion: IMapVersionInfo;
  const ABitmap: IBitmap32Static
);
var
  VData: IBinaryData;
begin
  VData := FBitmapSaverToStorage.Save(ABitmap);
  FStorage.SaveTile(AXY, AZoom, AVersion, Now, FContentType, VData);
end;

procedure TMapType.SaveConfig(const ALocalConfig: IConfigDataWriteProvider);
begin
  FGUIConfig.WriteConfig(ALocalConfig);
  FLayerDrawConfig.WriteConfig(ALocalConfig);
  FTileDownloadRequestBuilderConfig.WriteConfig(ALocalConfig);
  FTileDownloaderConfig.WriteConfig(ALocalConfig);
  FVersionConfig.WriteConfig(ALocalConfig);
  FStorageConfig.WriteConfig(ALocalConfig);
  FAbilitiesConfig.WriteConfig(ALocalConfig);
end;

function TMapType.LoadBitmapTileFromStorage(
  const AXY: TPoint;
  const AZoom: Byte;
  const AVersion: IMapVersionInfo
): IBitmap32Static;
var
  VTileInfoWithData: ITileInfoWithData;
begin
  Result := nil;
  if Supports(FStorage.GetTileInfo(AXY, AZoom, AVersion, gtimWithData), ITileInfoWithData, VTileInfoWithData) then begin
    Result := FBitmapLoaderFromStorage.Load(VTileInfoWithData.TileData);
  end;
end;

function TMapType.LoadKmlTileFromStorage(
  const AXY: TPoint;
  const AZoom: byte;
  const AVersion: IMapVersionInfo
): IVectorItemSubset;
var
  VTileInfoWithData: ITileInfoWithData;
  VIdData: TIdData;
begin
  Result := nil;
  if Supports(FStorage.GetTileInfo(AXY, AZoom, AVersion, gtimWithData), ITileInfoWithData, VTileInfoWithData) then begin
    VIdData.UrlPrefix := TStringProviderForMapTileItem.Create(FMapDataUrlPrefix, AXY, AZoom);
    try
      VIdData.NextIndex := 0;
      Result := FKmlLoaderFromStorage.Load(VTileInfoWithData.TileData, @VIdData, FVectorDataFactory);
    finally
      VIdData.UrlPrefix := nil;
    end;
  end;
end;

procedure TMapType.SaveTileSimple(
  const AXY: TPoint;
  const AZoom: byte;
  const AVersion: IMapVersionInfo;
  const ABitmap: IBitmap32Static
);
begin
  SaveBitmapTileToStorage(AXY, AZoom, AVersion, ABitmap);
end;

function TMapType.GetShortFolderName: string;
begin
  Result := ExtractFileName(ExtractFileDir(IncludeTrailingPathDelimiter(FStorageConfig.NameInCache)));
end;

function TMapType.GetTileShowName(
  const AXY: TPoint;
  const AZoom: byte;
  const AVersion: IMapVersionInfo
): string;
begin
  Result := FStorage.GetTileFileName(AXY, AZoom, AVersion);
  if not FStorage.IsFileCache then begin
    Result :=
      IncludeTrailingPathDelimiter(Result) +
      'z' + IntToStr(AZoom + 1) + PathDelim +
      'x' + IntToStr(AXY.X) + PathDelim +
      'y' + IntToStr(AXY.Y) + FContentType.GetDefaultExt;
  end;
  if FStorage.GetIsCanSaveMultiVersionTiles and (AVersion.StoreString <> '') then begin
    Result := Result + PathDelim + 'v' + AVersion.StoreString;
  end;
end;

function TMapType.GetFillingMapBitmap(
  AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  const ALocalConverter: ILocalCoordConverter;
  ASourceZoom: byte;
  const AVersion: IMapVersionInfo;
  const AColorer: IFillingMapColorer
): IBitmap32Static;
var
  VBitmap: TBitmap32ByStaticBitmap;
  VSize: TPoint;
  VTargetMapPixelRect: TDoubleRect;
  VSourceTileRect: TRect;
  VSourceRelativeRect: TDoubleRect;
  VSourceConverter: ICoordConverter;
  VTargetConverter: ICoordConverter;
  VSameSourceAndTarget: Boolean;
  VTargetZoom: Byte;
  VLonLatRect: TDoubleRect;
  VIterator: ITileIterator;
  VRelativeRectOfTile: TDoubleRect;
  VLonLatRectOfTile: TDoubleRect;
  VSolidDrow: Boolean;
  VTileRectInfo: ITileRectInfo;
  VEnumTileInfo: IEnumTileInfo;
  VTileInfo: TTileInfo;
  VMapPixelRectOfTile: TDoubleRect;
  VLocalPixelRectOfTile: TRect;
  VTileColor: TColor32;
begin
  VBitmap := TBitmap32ByStaticBitmap.Create(FBitmapFactory);
  try
    VSize := ALocalConverter.GetLocalRectSize;
    VBitmap.SetSize(VSize.X, VSize.Y);
    VBitmap.Clear(0);

    VSourceConverter := FCoordConverter;
    VTargetConverter := ALocalConverter.GeoConverter;
    VTargetZoom := ALocalConverter.Zoom;

    VTargetMapPixelRect := ALocalConverter.GetRectInMapPixelFloat;
    VTargetConverter.CheckPixelRectFloat(VTargetMapPixelRect, VTargetZoom);

    VSameSourceAndTarget := VSourceConverter.IsSameConverter(VTargetConverter);
    if VSameSourceAndTarget then begin
      VSourceRelativeRect := VSourceConverter.PixelRectFloat2RelativeRect(VTargetMapPixelRect, VTargetZoom);
    end else begin
      VLonLatRect := VTargetConverter.PixelRectFloat2LonLatRect(VTargetMapPixelRect, VTargetZoom);
      VSourceConverter.CheckLonLatRect(VLonLatRect);
      VSourceRelativeRect := VSourceConverter.LonLatRect2RelativeRect(VLonLatRect);
    end;
    VSourceTileRect :=
      RectFromDoubleRect(
        VSourceConverter.RelativeRect2TileRectFloat(VSourceRelativeRect, ASourceZoom),
        rrOutside
      );
    VSolidDrow :=
      (VSize.X <= (VSourceTileRect.Right - VSourceTileRect.Left) * 2) or
      (VSize.Y <= (VSourceTileRect.Bottom - VSourceTileRect.Top) * 2);
    VTileRectInfo := FStorage.GetTileRectInfo(VSourceTileRect, ASourceZoom, AVersion);
    if VTileRectInfo <> nil then begin
      VIterator := TTileIteratorByRect.Create(VSourceTileRect);
      VEnumTileInfo := VTileRectInfo.GetEnum(VIterator);
      while VEnumTileInfo.Next(VTileInfo) do begin
        VTileColor := AColorer.GetColor(VTileInfo);
        if VTileColor <> 0 then begin
          if VSameSourceAndTarget then begin
            VRelativeRectOfTile := VSourceConverter.TilePos2RelativeRect(VTileInfo.FTile, ASourceZoom);
          end else begin
            VLonLatRectOfTile := VSourceConverter.TilePos2LonLatRect(VTileInfo.FTile, ASourceZoom);
            VTargetConverter.CheckLonLatRect(VLonLatRectOfTile);
            VRelativeRectOfTile := VTargetConverter.LonLatRect2RelativeRect(VLonLatRectOfTile);
          end;
          VMapPixelRectOfTile := VTargetConverter.RelativeRect2PixelRectFloat(VRelativeRectOfTile, VTargetZoom);
          VLocalPixelRectOfTile := RectFromDoubleRect(ALocalConverter.MapRectFloat2LocalRectFloat(VMapPixelRectOfTile), rrToTopLeft);
          if not VSolidDrow then begin
            Dec(VLocalPixelRectOfTile.Right);
            Dec(VLocalPixelRectOfTile.Bottom);
          end;
          VBitmap.FillRectS(VLocalPixelRectOfTile, VTileColor);
        end;
      end;
    end;
    Result := VBitmap.BitmapStatic;
  finally
    VBitmap.Free;
  end;
end;

function TMapType.GetIsBitmapTiles: Boolean;
begin
  Result := FBitmapLoaderFromStorage <> nil;
end;

function TMapType.GetIsKmlTiles: Boolean;
begin
  Result := FKmlLoaderFromStorage <> nil;
end;

function TMapType.LoadTile(
  const AXY: TPoint;
  const AZoom: byte;
  const AVersion: IMapVersionInfo;
  IgnoreError: Boolean;
  const ACache: ITileObjCacheBitmap
): IBitmap32Static;
var
  VRect: TRect;
  VSize: TPoint;
  VBitmap: TBitmap32ByStaticBitmap;
  VResampler: TCustomResampler;
begin
  try
    Result := nil;
    if ACache = nil then begin
      Result := LoadBitmapTileFromStorage(AXY, AZoom, AVersion);
    end else begin
      Result := ACache.TryLoadTileFromCache(AXY, AZoom);
      if Result = nil then begin
        Result := LoadBitmapTileFromStorage(AXY, AZoom, AVersion);
        if Result <> nil then begin
          ACache.AddTileToCache(Result, AXY, AZoom);
        end;
      end;
    end;
    if Result <> nil then begin
      VRect := FCoordConverter.TilePos2PixelRect(AXY, AZoom);
      VSize := Types.Point(VRect.Right - VRect.Left, VRect.Bottom - VRect.Top);
      if (Result.Size.X <> VSize.X) or
        (Result.Size.Y <> VSize.Y) then begin
        VResampler := FResamplerConfigLoad.GetActiveFactory.CreateResampler;
        try
          VBitmap := TBitmap32ByStaticBitmap.Create(FBitmapFactory);
          try
            VBitmap.SetSize(VSize.X, VSize.Y);
            StretchTransferFull(
              VBitmap,
              VBitmap.BoundsRect,
              Result,
              VResampler,
              dmOpaque
            );
            Result := VBitmap.BitmapStatic;
          finally
            VBitmap.Free;
          end;
        finally
          VResampler.Free;
        end;
      end;
    end;
  except
    if not IgnoreError then begin
      raise;
    end else begin
      Result := nil;
    end;
  end;
end;

function TMapType.LoadTileVector(
  const AXY: TPoint;
  const AZoom: byte;
  const AVersion: IMapVersionInfo;
  IgnoreError: Boolean;
  const ACache: ITileObjCacheVector
): IVectorItemSubset;
begin
  Result := nil;
  try
    if ACache = nil then begin
      Result := LoadKmlTileFromStorage(AXY, AZoom, AVersion);
    end else begin
      Result := ACache.TryLoadTileFromCache(AXY, AZoom);
      if Result = nil then begin
        Result := LoadKmlTileFromStorage(AXY, AZoom, AVersion);
        if Result <> nil then begin
          ACache.AddTileToCache(Result, AXY, AZoom);
        end;
      end;
    end;
  except
    if not IgnoreError then begin
      raise;
    end;
  end;
end;

procedure TMapType.OnVersionChange;
begin
  ClearMemCache;
end;

function TMapType.LoadTileFromPreZ(
  const AXY: TPoint;
  const AZoom: byte;
  const AVersion: IMapVersionInfo;
  IgnoreError: Boolean;
  const ACache: ITileObjCacheBitmap
): IBitmap32Static;
var
  i: integer;
  VBmp: IBitmap32Static;
  VTileTargetBounds: TRect;
  VTileSourceBounds: TRect;
  VTileParent: TPoint;
  VTargetTilePixelRect: TRect;
  VSourceTilePixelRect: TRect;
  VRelative: TDoublePoint;
  VRelativeRect: TDoubleRect;
  VParentZoom: Byte;
  VMinZoom: Integer;
  VBitmap: TBitmap32ByStaticBitmap;
  VResampler: TCustomResampler;
begin
  Result := nil;
  VRelative := FCoordConverter.TilePos2Relative(AXY, AZoom);
  VMinZoom := AZoom - FLoadPrevMaxZoomDelta;
  if VMinZoom < 0 then begin
    VMinZoom := 0;
  end;
  if AZoom - 1 > VMinZoom then begin
    for i := AZoom - 1 downto VMinZoom do begin
      VParentZoom := i;
      VTileParent := PointFromDoublePoint(FCoordConverter.Relative2TilePosFloat(VRelative, i), prToTopLeft);
      VBmp := LoadTile(VTileParent, VParentZoom, AVersion, IgnoreError, ACache);
      if VBmp <> nil then begin
        VTargetTilePixelRect := FCoordConverter.TilePos2PixelRect(AXY, AZoom);
        VRelativeRect := FCoordConverter.PixelRect2RelativeRect(VTargetTilePixelRect, AZoom);
        VTileTargetBounds.Left := 0;
        VTileTargetBounds.Top := 0;
        VTileTargetBounds.Right := VTargetTilePixelRect.Right - VTargetTilePixelRect.Left;
        VTileTargetBounds.Bottom := VTargetTilePixelRect.Bottom - VTargetTilePixelRect.Top;

        VSourceTilePixelRect := FCoordConverter.TilePos2PixelRect(VTileParent, VParentZoom);
        VTargetTilePixelRect :=
          RectFromDoubleRect(
            FCoordConverter.RelativeRect2PixelRectFloat(VRelativeRect, VParentZoom),
            rrToTopLeft
          );
        VTileSourceBounds.Left := VTargetTilePixelRect.Left - VSourceTilePixelRect.Left;
        VTileSourceBounds.Top := VTargetTilePixelRect.Top - VSourceTilePixelRect.Top;
        VTileSourceBounds.Right := VTargetTilePixelRect.Right - VSourceTilePixelRect.Left;
        VTileSourceBounds.Bottom := VTargetTilePixelRect.Bottom - VSourceTilePixelRect.Top;
        VResampler := FResamplerConfigGetPrev.GetActiveFactory.CreateResampler;
        try
          try
            VBitmap := TBitmap32ByStaticBitmap.Create(FBitmapFactory);
            try
              VBitmap.SetSize(VTileTargetBounds.Right, VTileTargetBounds.Bottom);
              StretchTransfer(
                VBitmap,
                VTileTargetBounds,
                VBmp,
                VTileSourceBounds,
                VResampler,
                dmOpaque
              );
              Result := VBitmap.BitmapStatic;
            finally
              VBitmap.Free;
            end;
            Break;
          except
            if not IgnoreError then begin
              raise;
            end;
          end;
        finally
          VResampler.Free;
        end;
      end;
    end;
  end;
end;

function TMapType.LoadTileOrPreZ(
  const AXY: TPoint;
  const AZoom: byte;
  const AVersion: IMapVersionInfo;
  IgnoreError: Boolean;
  AUsePre: Boolean;
  const ACache: ITileObjCacheBitmap
): IBitmap32Static;
begin
  Result := LoadTile(AXY, AZoom, AVersion, IgnoreError, ACache);
  if Result = nil then begin
    if AUsePre then begin
      Result := LoadTileFromPreZ(AXY, AZoom, AVersion, IgnoreError, ACache);
    end;
  end;
end;

function TMapType.LoadBitmap(
  const APixelRectTarget: TRect;
  const AZoom: byte;
  const AVersion: IMapVersionInfo;
  AUsePre, AAllowPartial, IgnoreError: Boolean;
  const ACache: ITileObjCacheBitmap
): IBitmap32Static;
var
  VZoom: Byte;
  VPixelRectTarget: TRect;
  VTileRect: TRect;
  VTargetImageSize: TPoint;
  VPixelRectCurrTile: TRect;
  i, j: Integer;
  VTile: TPoint;
  VSpr: IBitmap32Static;
  VSourceBounds: TRect;
  VTargetBounds: TRect;
  VBitmap: TBitmap32ByStaticBitmap;
begin
  Result := nil;

  VTargetImageSize.X := APixelRectTarget.Right - APixelRectTarget.Left;
  VTargetImageSize.Y := APixelRectTarget.Bottom - APixelRectTarget.Top;

  VPixelRectTarget := APixelRectTarget;
  VZoom := AZoom;
  FCoordConverter.CheckPixelRect(VPixelRectTarget, VZoom);
  VTileRect := FCoordConverter.PixelRect2TileRect(VPixelRectTarget, VZoom);
  if (VTileRect.Left = VTileRect.Right - 1) and
    (VTileRect.Top = VTileRect.Bottom - 1) then begin
    VPixelRectCurrTile := FCoordConverter.TilePos2PixelRect(VTileRect.TopLeft, VZoom);
    if Types.EqualRect(VPixelRectCurrTile, APixelRectTarget) then begin
      Result := LoadTileOrPreZ(VTileRect.TopLeft, VZoom, AVersion, IgnoreError, AUsePre, ACache);
      Exit;
    end;
  end;
  VBitmap := TBitmap32ByStaticBitmap.Create(FBitmapFactory);
  try
    VBitmap.SetSize(VTargetImageSize.X, VTargetImageSize.Y);
    VBitmap.Clear(0);

    for i := VTileRect.Top to VTileRect.Bottom - 1 do begin
      VTile.Y := i;
      for j := VTileRect.Left to VTileRect.Right - 1 do begin
        VTile.X := j;
        VSpr := LoadTileOrPreZ(VTile, VZoom, AVersion, IgnoreError, AUsePre, ACache);
        if VSpr <> nil then begin
          VPixelRectCurrTile := FCoordConverter.TilePos2PixelRect(VTile, VZoom);

          if VPixelRectCurrTile.Top < APixelRectTarget.Top then begin
            VSourceBounds.Top := APixelRectTarget.Top - VPixelRectCurrTile.Top;
          end else begin
            VSourceBounds.Top := 0;
          end;

          if VPixelRectCurrTile.Left < APixelRectTarget.Left then begin
            VSourceBounds.Left := APixelRectTarget.Left - VPixelRectCurrTile.Left;
          end else begin
            VSourceBounds.Left := 0;
          end;

          if VPixelRectCurrTile.Bottom < APixelRectTarget.Bottom then begin
            VSourceBounds.Bottom := VPixelRectCurrTile.Bottom - VPixelRectCurrTile.Top;
          end else begin
            VSourceBounds.Bottom := APixelRectTarget.Bottom - VPixelRectCurrTile.Top;
          end;

          if VPixelRectCurrTile.Right < APixelRectTarget.Right then begin
            VSourceBounds.Right := VPixelRectCurrTile.Right - VPixelRectCurrTile.Left;
          end else begin
            VSourceBounds.Right := APixelRectTarget.Right - VPixelRectCurrTile.Left;
          end;

          if VPixelRectCurrTile.Top < APixelRectTarget.Top then begin
            VTargetBounds.Top := 0;
          end else begin
            VTargetBounds.Top := VPixelRectCurrTile.Top - APixelRectTarget.Top;
          end;

          if VPixelRectCurrTile.Left < APixelRectTarget.Left then begin
            VTargetBounds.Left := 0;
          end else begin
            VTargetBounds.Left := VPixelRectCurrTile.Left - APixelRectTarget.Left;
          end;

          if VPixelRectCurrTile.Bottom < APixelRectTarget.Bottom then begin
            VTargetBounds.Bottom := VPixelRectCurrTile.Bottom - APixelRectTarget.Top;
          end else begin
            VTargetBounds.Bottom := APixelRectTarget.Bottom - APixelRectTarget.Top;
          end;

          if VPixelRectCurrTile.Right < APixelRectTarget.Right then begin
            VTargetBounds.Right := VPixelRectCurrTile.Right - APixelRectTarget.Left;
          end else begin
            VTargetBounds.Right := APixelRectTarget.Right - APixelRectTarget.Left;
          end;

          BlockTransfer(
            VBitmap,
            VTargetBounds.Left,
            VTargetBounds.Top,
            VSpr,
            VSourceBounds,
            dmOpaque
          );
        end else begin
          if not AAllowPartial then begin
            Exit;
          end;
        end;
      end;
    end;
    Result := VBitmap.BitmapStatic;
  finally
    VBitmap.Free;
  end;
end;

function TMapType.LoadBitmapUni(
  const APixelRectTarget: TRect;
  const AZoom: byte;
  const AVersion: IMapVersionInfo;
  const ACoordConverterTarget: ICoordConverter;
  AUsePre, AAllowPartial, IgnoreError: Boolean;
  const ACache: ITileObjCacheBitmap
): IBitmap32Static;
var
  VPixelRectTarget: TRect;
  VZoom: Byte;
  VLonLatRectTarget: TDoubleRect;
  VTileRectInSource: TRect;
  VPixelRectOfTargetPixelRectInSource: TRect;
  VSpr: IBitmap32Static;
  VTargetImageSize: TPoint;
  VResampler: TCustomResampler;
  VBitmap: TBitmap32ByStaticBitmap;
begin
  Result := nil;

  if FCoordConverter.IsSameConverter(ACoordConverterTarget) then begin
    Result := LoadBitmap(APixelRectTarget, AZoom, AVersion, AUsePre, AAllowPartial, IgnoreError, ACache);
  end else begin
    VZoom := AZoom;
    VTargetImageSize.X := APixelRectTarget.Right - APixelRectTarget.Left;
    VTargetImageSize.Y := APixelRectTarget.Bottom - APixelRectTarget.Top;

    VPixelRectTarget := APixelRectTarget;
    ACoordConverterTarget.CheckPixelRect(VPixelRectTarget, VZoom);
    VLonLatRectTarget := ACoordConverterTarget.PixelRect2LonLatRect(VPixelRectTarget, VZoom);
    FCoordConverter.CheckLonLatRect(VLonLatRectTarget);
    VPixelRectOfTargetPixelRectInSource :=
      RectFromDoubleRect(
        FCoordConverter.LonLatRect2PixelRectFloat(VLonLatRectTarget, VZoom),
        rrToTopLeft
      );
    VTileRectInSource := FCoordConverter.PixelRect2TileRect(VPixelRectOfTargetPixelRectInSource, VZoom);
    VSpr := LoadBitmap(VPixelRectOfTargetPixelRectInSource, VZoom, AVersion, AUsePre, AAllowPartial, IgnoreError, ACache);
    if VSpr <> nil then begin
      VResampler := FResamplerConfigChangeProjection.GetActiveFactory.CreateResampler;
      try
        VBitmap := TBitmap32ByStaticBitmap.Create(FBitmapFactory);
        try
          VBitmap.SetSize(VTargetImageSize.X, VTargetImageSize.Y);
          VBitmap.Clear(0);
          StretchTransferFull(
            VBitmap,
            VBitmap.BoundsRect,
            VSpr,
            VResampler,
            dmOpaque
          );
          Result := VBitmap.BitmapStatic;
        finally
          VBitmap.Free;
        end;
      finally
        VResampler.Free;
      end;
    end;
  end;
end;

function TMapType.LoadTileUni(
  const AXY: TPoint;
  const AZoom: byte;
  const AVersion: IMapVersionInfo;
  const ACoordConverterTarget: ICoordConverter;
  AUsePre, AAllowPartial, IgnoreError: Boolean;
  const ACache: ITileObjCacheBitmap
): IBitmap32Static;
var
  VPixelRect: TRect;
begin
  VPixelRect := ACoordConverterTarget.TilePos2PixelRect(AXY, AZoom);
  Result := LoadBitmapUni(VPixelRect, AZoom, AVersion, ACoordConverterTarget, AUsePre, AAllowPartial, IgnoreError, ACache);
end;

end.
