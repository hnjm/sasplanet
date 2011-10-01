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

unit u_ZmpInfo;

interface

uses
  SysUtils,
  Graphics,
  Classes,
  i_CoordConverter,
  i_ConfigDataProvider,
  i_LanguageListStatic,
  i_MapVersionInfo,
  i_ContentTypeSubst,
  i_TileRequestBuilderConfig,
  i_TileDownloaderConfig,
  i_TilePostDownloadCropConfig,
  i_LanguageManager,
  i_StringByLanguage,
  i_CoordConverterFactory,
  i_MapAbilitiesConfig,
  i_SimpleTileStorageConfig,
  i_ZmpInfo;

type
  TZmpInfoGUI = class(TInterfacedObject, IZmpInfoGUI)
  private
    FGUID: TGUID;
    FName: IStringByLanguage;
    FParentSubMenu: IStringByLanguage;

    FInfoUrl: IStringByLanguage;

    FSortIndex: Integer;
    FBmp18: TBitmap;
    FBmp24: TBitmap;
    FHotKey: TShortCut;
    FSeparator: Boolean;
    FEnabled: Boolean;
  private
    procedure LoadConfig(
      ALangList: ILanguageListStatic;
      AConfig: IConfigDataProvider;
      AConfigIni: IConfigDataProvider;
      AConfigIniParams: IConfigDataProvider;
      Apnum: Integer
    );
    procedure LoadIcons(
      AConfig : IConfigDataProvider;
      Apnum: Integer
    );
    procedure LoadUIParams(
      ALangList: ILanguageListStatic;
      AConfig : IConfigDataProvider;
      Apnum: Integer
    );
    procedure LoadInfo(
      ALangList: ILanguageListStatic;
      AConfig : IConfigDataProvider
    );
  protected
    function GetName: IStringByLanguage;
    function GetSortIndex: Integer;
    function GetInfoUrl: IStringByLanguage;
    function GetBmp18: TBitmap;
    function GetBmp24: TBitmap;
    function GetHotKey: TShortCut;
    function GetSeparator: Boolean;
    function GetParentSubMenu: IStringByLanguage;
    function GetEnabled: Boolean;
  public
    constructor Create(
      AGUID: TGUID;
      ALanguageManager: ILanguageManager;
      AConfig: IConfigDataProvider;
      AConfigIni: IConfigDataProvider;
      AConfigIniParams: IConfigDataProvider;
      Apnum: Integer
    );
    destructor Destroy; override;
  end;

  TZmpInfo = class(TInterfacedObject, IZmpInfo)
  private
    FGUID: TGUID;
    FFileName: string;
    FVersionConfig: IMapVersionInfo;
    FTileRequestBuilderConfig: ITileRequestBuilderConfigStatic;
    FTileDownloaderConfig: ITileDownloaderConfigStatic;
    FTilePostDownloadCropConfig: ITilePostDownloadCropConfigStatic;
    FContentTypeSubst: IContentTypeSubst;
    FGeoConvert: ICoordConverter;
    FViewGeoConvert: ICoordConverter;
    FGUI: IZmpInfoGUI;
    FAbilities: IMapAbilitiesConfigStatic;
    FStorageConfig: ISimpleTileStorageConfigStatic;

    FConfig: IConfigDataProvider;
    FConfigIni: IConfigDataProvider;
    FConfigIniParams: IConfigDataProvider;
  private
    procedure LoadConfig(
      ACoordConverterFactory: ICoordConverterFactory
    );
    procedure LoadCropConfig(AConfig : IConfigDataProvider);
    procedure LoadAbilities(AConfig : IConfigDataProvider);
    procedure LoadStorageConfig(AConfig : IConfigDataProvider);
    function LoadGUID(AConfig : IConfigDataProvider): TGUID;
    procedure LoadVersion(AConfig : IConfigDataProvider);
    procedure LoadProjectionInfo(
      AConfig : IConfigDataProvider;
      ACoordConverterFactory: ICoordConverterFactory
    );
    procedure LoadTileRequestBuilderConfig(AConfig : IConfigDataProvider);
    procedure LoadTileDownloaderConfig(AConfig: IConfigDataProvider);
  protected
    function GetGUID: TGUID;
    function GetGUI: IZmpInfoGUI;
    function GetFileName: string;
    function GetVersionConfig: IMapVersionInfo;
    function GetTileRequestBuilderConfig: ITileRequestBuilderConfigStatic;
    function GetTileDownloaderConfig: ITileDownloaderConfigStatic;
    function GetTilePostDownloadCropConfig: ITilePostDownloadCropConfigStatic;
    function GetContentTypeSubst: IContentTypeSubst;
    function GetGeoConvert: ICoordConverter;
    function GetViewGeoConvert: ICoordConverter;
    function GetAbilities: IMapAbilitiesConfigStatic;
    function GetStorageConfig: ISimpleTileStorageConfigStatic;
    function GetDataProvider: IConfigDataProvider;
  public
    constructor Create(
      ALanguageManager: ILanguageManager;
      ACoordConverterFactory: ICoordConverterFactory;
      AFileName: string;
      AConfig: IConfigDataProvider;
      Apnum: Integer
    );
  end;

  EZmpError = class(Exception);
  EZmpIniNotFound = class(EZmpError);
  EZmpParamsNotFound = class(EZmpError);
  EZmpGUIDError = class(EZmpError);

implementation

uses
  Types,
  gnugettext,
  u_StringByLanguageWithStaticList,
  u_TileRequestBuilderConfig,
  u_TileDownloaderConfigStatic,
  u_TilePostDownloadCropConfigStatic,
  u_ContentTypeSubstByList,
  u_MapAbilitiesConfigStatic,
  u_SimpleTileStorageConfigStatic,
  u_MapVersionInfo,
  u_ResStrings;

{ TZmpInfoGUI }

constructor TZmpInfoGUI.Create(
  AGUID: TGUID;
  ALanguageManager: ILanguageManager;
  AConfig: IConfigDataProvider;
  AConfigIni: IConfigDataProvider;
  AConfigIniParams: IConfigDataProvider;
  Apnum: Integer
);
var
  VCurrentLanguageCode: string;
  VLangList: ILanguageListStatic;
begin
  FGUID := AGUID;
  VLangList := ALanguageManager.LanguageList;
  VCurrentLanguageCode := ALanguageManager.GetCurrentLanguageCode;
  LoadConfig(VLangList, AConfig, AConfigIni, AConfigIniParams, Apnum);
end;

destructor TZmpInfoGUI.Destroy;
begin
  FreeAndNil(FBmp18);
  FreeAndNil(FBmp24);
  inherited;
end;

function TZmpInfoGUI.GetBmp18: TBitmap;
begin
  Result := FBmp18;
end;

function TZmpInfoGUI.GetBmp24: TBitmap;
begin
  Result := FBmp24;
end;

function TZmpInfoGUI.GetEnabled: Boolean;
begin
  Result := FEnabled;
end;

function TZmpInfoGUI.GetHotKey: TShortCut;
begin
  Result := FHotKey;
end;

function TZmpInfoGUI.GetInfoUrl: IStringByLanguage;
begin
  Result := FInfoUrl;
end;

function TZmpInfoGUI.GetName: IStringByLanguage;
begin
  Result := FName;
end;

function TZmpInfoGUI.GetParentSubMenu: IStringByLanguage;
begin
  Result := FParentSubMenu;
end;

function TZmpInfoGUI.GetSeparator: Boolean;
begin
  Result := FSeparator;
end;

function TZmpInfoGUI.GetSortIndex: Integer;
begin
  Result := FSortIndex;
end;

procedure TZmpInfoGUI.LoadConfig(
  ALangList: ILanguageListStatic;
  AConfig: IConfigDataProvider;
  AConfigIni: IConfigDataProvider;
  AConfigIniParams: IConfigDataProvider;
  Apnum: Integer
);
begin
  LoadUIParams(ALangList, AConfigIniParams, Apnum);
  LoadIcons(AConfig, Apnum);
  LoadInfo(ALangList, AConfig);
end;

procedure TZmpInfoGUI.LoadIcons(
  AConfig: IConfigDataProvider;
  Apnum: Integer
);
var
  VStream: TMemoryStream;
  VNameDef: string;
begin
  Fbmp24:=TBitmap.create;
  VStream:=TMemoryStream.Create;
  try
    try
      AConfig.ReadBinaryStream('24.bmp', VStream);
      VStream.Position:=0;
      Fbmp24.LoadFromStream(VStream);
    except
      VNameDef:=inttostr(Apnum);
      Fbmp24.Canvas.FillRect(Fbmp24.Canvas.ClipRect);
      Fbmp24.Width:=24;
      Fbmp24.Height:=24;
      Fbmp24.Canvas.TextOut(7,3,copy(VNameDef,1,1));
    end;
  finally
    FreeAndNil(VStream);
  end;
  Fbmp18:=TBitmap.create;
  VStream:=TMemoryStream.Create;
  try
    try
      AConfig.ReadBinaryStream('18.bmp', VStream);
      VStream.Position:=0;
      Fbmp18.LoadFromStream(VStream);
    except
      VNameDef:=inttostr(Apnum);
      Fbmp18.Canvas.FillRect(Fbmp18.Canvas.ClipRect);
      Fbmp18.Width:=18;
      Fbmp18.Height:=18;
      Fbmp18.Canvas.TextOut(3,2,copy(VNameDef,1,1));
    end;
  finally
    FreeAndNil(VStream);
  end;
end;

procedure TZmpInfoGUI.LoadInfo(
  ALangList: ILanguageListStatic;
  AConfig: IConfigDataProvider
);
var
  VDefValue: string;
  VFileName: string;
  i: Integer;
  VLanguageCode: string;
  VValueList: TStringList;
  VValue: string;
begin
  // 'sas://ZmpInfo/' + GUIDToString(FGUID)
  if AConfig.ReadString('index.html', '') <> '' then begin
    VDefValue := '/index.html';
  end else if AConfig.ReadString('info.txt', '') <> '' then begin
    VDefValue := '/info.txt';
  end else begin
    VDefValue := '';
  end;
  VValueList := TStringList.Create;
  try
    for i := 0 to ALangList.Count - 1 do begin
      VValue := VDefValue;
      VLanguageCode := ALangList.Code[i];
      VFileName := 'index_'+VLanguageCode+'.html';
      if AConfig.ReadString(VFileName, '') <> '' then begin
        VValue := '/' + VFileName;
      end else begin
        VFileName := 'info_'+VLanguageCode+'.txt';
        if AConfig.ReadString(VFileName, '') <> '' then begin
          VValue := '/' + VFileName;
        end;
      end;
      VValueList.Add(VValue);
    end;
    FInfoUrl := TStringByLanguageWithStaticList.Create(VValueList);
  finally
    VValueList.Free;
  end;
end;

procedure TZmpInfoGUI.LoadUIParams(
  ALangList: ILanguageListStatic;
  AConfig: IConfigDataProvider;
  Apnum: Integer
);
var
  VDefValue: string;
  i: Integer;
  VLanguageCode: string;
  VValueList: TStringList;
  VValue: string;
begin
  VDefValue := 'map#'+inttostr(Apnum);
  VDefValue := AConfig.ReadString('name', VDefValue);
  VValueList := TStringList.Create;
  try
    for i := 0 to ALangList.Count - 1 do begin
      VValue := VDefValue;
      VLanguageCode := ALangList.Code[i];
      VValue := AConfig.ReadString('name_' + VLanguageCode, VDefValue);
      VValueList.Add(VValue);
    end;
    FName := TStringByLanguageWithStaticList.Create(VValueList);
  finally
    VValueList.Free;
  end;

  VDefValue := '';
  VDefValue := AConfig.ReadString('ParentSubMenu', VDefValue);
  VValueList := TStringList.Create;
  try
    for i := 0 to ALangList.Count - 1 do begin
      VValue := VDefValue;
      VLanguageCode := ALangList.Code[i];
      VValue := AConfig.ReadString('ParentSubMenu_' + VLanguageCode, VDefValue);
      VValueList.Add(VValue);
    end;
    FParentSubMenu := TStringByLanguageWithStaticList.Create(VValueList);
  finally
    VValueList.Free;
  end;

  FHotKey :=AConfig.ReadInteger('DefHotKey', 0);
  FHotKey :=AConfig.ReadInteger('HotKey', FHotKey);
  FSeparator := AConfig.ReadBool('separator', false);
  FEnabled := AConfig.ReadBool('Enabled', true);
  FSortIndex := AConfig.ReadInteger('pnum', -1);
end;

{ TZmpInfo }

constructor TZmpInfo.Create(
  ALanguageManager: ILanguageManager;
  ACoordConverterFactory: ICoordConverterFactory;
  AFileName: string;
  AConfig: IConfigDataProvider;
  Apnum: Integer
);
begin
  FFileName := AFileName;
  FConfig := AConfig;
  FConfigIni := FConfig.GetSubItem('params.txt');
  if FConfigIni = nil then begin
    raise EZmpIniNotFound.Create(_('Not found "params.txt" in zmp'));
  end;
  FConfigIniParams := FConfigIni.GetSubItem('PARAMS');
  if FConfigIniParams = nil then begin
    raise EZmpParamsNotFound.Create(_('Not found PARAMS section in zmp'));
  end;
  LoadConfig(ACoordConverterFactory);
  FGUI := TZmpInfoGUI.Create(FGUID, ALanguageManager, FConfig, FConfigIni, FConfigIniParams, Apnum);
end;

function TZmpInfo.GetAbilities: IMapAbilitiesConfigStatic;
begin
  Result := FAbilities;
end;

function TZmpInfo.GetContentTypeSubst: IContentTypeSubst;
begin
  Result := FContentTypeSubst;
end;

function TZmpInfo.GetDataProvider: IConfigDataProvider;
begin
  Result := FConfig;
end;

function TZmpInfo.GetFileName: string;
begin
  Result := FFileName;
end;

function TZmpInfo.GetGeoConvert: ICoordConverter;
begin
  Result := FGeoConvert;
end;

function TZmpInfo.GetGUI: IZmpInfoGUI;
begin
  Result := FGUI;
end;

function TZmpInfo.GetGUID: TGUID;
begin
  Result := FGUID;
end;

function TZmpInfo.GetStorageConfig: ISimpleTileStorageConfigStatic;
begin
  Result := FStorageConfig;
end;

function TZmpInfo.GetViewGeoConvert: ICoordConverter;
begin
  Result := FViewGeoConvert;
end;

function TZmpInfo.GetTileDownloaderConfig: ITileDownloaderConfigStatic;
begin
  Result := FTileDownloaderConfig;
end;

function TZmpInfo.GetTilePostDownloadCropConfig: ITilePostDownloadCropConfigStatic;
begin
  Result := FTilePostDownloadCropConfig;
end;

function TZmpInfo.GetTileRequestBuilderConfig: ITileRequestBuilderConfigStatic;
begin
  Result := FTileRequestBuilderConfig;
end;

function TZmpInfo.GetVersionConfig: IMapVersionInfo;
begin
  Result := FVersionConfig;
end;

procedure TZmpInfo.LoadAbilities(AConfig: IConfigDataProvider);
var
  VIsLayer: Boolean;
  VIsShowOnSmMap: Boolean;
  VIsUseStick: Boolean;
  VIsUseGenPrevious: Boolean;
  VUseDownload: Boolean;
begin
  VIsLayer := AConfig.ReadBool('asLayer', False);
  VIsShowOnSmMap := AConfig.ReadBool('CanShowOnSmMap', True);
  VIsUseStick := AConfig.ReadBool('Usestick', True);
  VIsUseGenPrevious := AConfig.ReadBool('UseGenPrevious', True);
  VUseDownload := AConfig.ReadBool('UseDwn', True);

  FAbilities :=
    TMapAbilitiesConfigStatic.Create(
      VIsLayer,
      VIsShowOnSmMap,
      VIsUseStick,
      VIsUseGenPrevious,
      VUseDownload
    );
end;

procedure TZmpInfo.LoadConfig(ACoordConverterFactory: ICoordConverterFactory);
begin
  FGUID := LoadGUID(FConfigIniParams);
  LoadVersion(FConfigIniParams);
  LoadProjectionInfo(FConfigIni, ACoordConverterFactory);
  LoadTileRequestBuilderConfig(FConfigIniParams);
  LoadTileDownloaderConfig(FConfigIniParams);
  LoadCropConfig(FConfigIniParams);
  LoadStorageConfig(FConfigIniParams);
  LoadAbilities(FConfigIniParams);
  FContentTypeSubst := TContentTypeSubstByList.Create(FConfigIniParams);
end;

procedure TZmpInfo.LoadCropConfig(AConfig: IConfigDataProvider);
var
  VRect: TRect;
begin
  VRect.Left := AConfig.ReadInteger('TileRLeft',0);
  VRect.Top := AConfig.ReadInteger('TileRTop',0);
  VRect.Right := AConfig.ReadInteger('TileRRight',0);
  VRect.Bottom := AConfig.ReadInteger('TileRBottom',0);
  FTilePostDownloadCropConfig := TTilePostDownloadCropConfigStatic.Create(VRect);
end;

function TZmpInfo.LoadGUID(AConfig: IConfigDataProvider): TGUID;
var
  VGUIDStr: String;
begin
  VGUIDStr := AConfig.ReadString('GUID', '');
  if Length(VGUIDStr) > 0 then begin
    try
      Result := StringToGUID(VGUIDStr);
    except
      raise EZmpGUIDError.CreateResFmt(@SAS_ERR_MapGUIDBad, [VGUIDStr]);
    end;
  end else begin
    raise EZmpGUIDError.CreateRes(@SAS_ERR_MapGUIDEmpty);
  end;
end;

procedure TZmpInfo.LoadProjectionInfo(AConfig: IConfigDataProvider; ACoordConverterFactory: ICoordConverterFactory);
var
  VParams: IConfigDataProvider;
begin
  VParams := AConfig.GetSubItem('ViewInfo');
  if VParams <> nil then begin
    FViewGeoConvert := ACoordConverterFactory.GetCoordConverterByConfig(VParams);
  end;
  FGeoConvert := ACoordConverterFactory.GetCoordConverterByConfig(FConfigIniParams);
  if FViewGeoConvert = nil then begin
    FViewGeoConvert := FGeoConvert;
  end;
end;

procedure TZmpInfo.LoadStorageConfig(AConfig: IConfigDataProvider);
var
  VCacheTypeCode: Integer;
  VNameInCache: string;
  VTileFileExt: string;
  VIsStoreFileCache: Boolean;
  VIsReadOnly: boolean;
  VAllowDelete: boolean;
  VAllowAdd: boolean;
  VAllowReplace: boolean;
begin
  VNameInCache := AConfig.ReadString('NameInCache', '');
  VCacheTypeCode := AConfig.ReadInteger('CacheType', 0);
  if VCacheTypeCode = 5  then begin
    VTileFileExt := '.ge_image';
    VIsStoreFileCache := False;
    VIsReadOnly := True;
    VAllowDelete := False;
    VAllowAdd := False;
    VAllowReplace := False;
  end else begin
    VTileFileExt := LowerCase(AConfig.ReadString('Ext', '.jpg'));
    VIsStoreFileCache := True;
    VIsReadOnly := False;
    VAllowDelete := True;
    VAllowAdd := True;
    VAllowReplace := True;
  end;

  FStorageConfig :=
    TSimpleTileStorageConfigStatic.Create(
      FGeoConvert,
      VCacheTypeCode,
      VNameInCache,
      VTileFileExt,
      VIsStoreFileCache,
      VIsReadOnly,
      VAllowDelete,
      VAllowAdd,
      VAllowReplace
    );
end;

procedure TZmpInfo.LoadTileDownloaderConfig(AConfig: IConfigDataProvider);
var
  VIgnoreMIMEType: Boolean;
  VDefaultMIMEType: string;
  VExpectedMIMETypes: string;
  VWaitInterval: Cardinal;
  VMaxConnectToServerCount: Cardinal;
  VIteratorSubRectSize: TPoint;
  fL : TStringList;
begin
  VIgnoreMIMEType := AConfig.ReadBool('IgnoreContentType', False);
  VDefaultMIMEType := AConfig.ReadString('DefaultContentType', 'image/jpg');
  VExpectedMIMETypes := AConfig.ReadString('ContentType', 'image/jpg');
  VWaitInterval := AConfig.ReadInteger('Sleep', 0);
  VMaxConnectToServerCount := AConfig.ReadInteger('MaxConnectToServerCount', 1);
  fL := TStringList.Create;
  try
    fL.Delimiter := ',';
    fL.StrictDelimiter := True;
    fL.DelimitedText := AConfig.ReadString('IteratorSubRectSize', '1,1');
    VIteratorSubRectSize.x:=StrToInt(fL[0]);
    VIteratorSubRectSize.y:=StrToInt(fL[1]);
  finally
    fL.Free
  end;
  FTileDownloaderConfig :=
    TTileDownloaderConfigStatic.Create(
      nil,
      VWaitInterval,
      VMaxConnectToServerCount,
      VIgnoreMIMEType,
      VExpectedMIMETypes,
      VDefaultMIMEType,
      VIteratorSubRectSize
    );
end;

procedure TZmpInfo.LoadTileRequestBuilderConfig(AConfig: IConfigDataProvider);
var
  VUrlBase: string;
  VRequestHead: string;
begin
  VURLBase := AConfig.ReadString('DefURLBase', '');
  VURLBase := AConfig.ReadString('URLBase', VURLBase);
  VRequestHead := AConfig.ReadString('RequestHead', '');
  VRequestHead := StringReplace(VRequestHead, '\r\n', #13#10, [rfIgnoreCase, rfReplaceAll]);
  FTileRequestBuilderConfig := TTileRequestBuilderConfigStatic.Create(VUrlBase, VRequestHead);
end;

procedure TZmpInfo.LoadVersion(AConfig: IConfigDataProvider);
var
  VVersion: Variant;
begin
  VVersion := AConfig.ReadString('Version', '');
  FVersionConfig := TMapVersionInfo.Create(VVersion);
end;

end.
