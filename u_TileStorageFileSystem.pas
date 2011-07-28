unit u_TileStorageFileSystem;

interface

uses
  Windows,
  Types,
  Classes,
  GR32,
  t_CommonTypes,
  i_ConfigDataProvider,
  i_CoordConverter,
  i_MapVersionInfo,
  i_ContentTypeInfo,
  i_TileInfoBasic,
  u_GlobalCahceConfig,
  u_MapTypeCacheConfig,
  u_TileStorageAbstract;

type
  TTileStorageFileSystem = class(TTileStorageAbstract)
  private
    FUseDel: boolean;
    FIsStoreReadOnly: Boolean;
    FUseSave: boolean;
    FTileFileExt: string;
    FCacheConfig: TMapTypeCacheConfigAbstract;
    FCoordConverter: ICoordConverter;
    FMainContentType: IContentTypeInfoBasic;
    procedure CreateDirIfNotExists(APath: string);
    function GetTileInfoByPath(
      APath: string;
      AVersionInfo: IMapVersionInfo
    ): ITileInfoBasic;
  public
    constructor Create(AGlobalCacheConfig: TGlobalCahceConfig; AConfig: IConfigDataProvider);
    destructor Destroy; override;

    function GetMainContentType: IContentTypeInfoBasic; override;
    function GetAllowDifferentContentTypes: Boolean; override;

    function GetIsStoreFileCache: Boolean; override;
    function GetUseDel: boolean; override;
    function GetUseSave: boolean; override;
    function GetIsStoreReadOnly: boolean; override;
    function GetTileFileExt: string; override;
    function GetCoordConverter: ICoordConverter; override;
    function GetCacheConfig: TMapTypeCacheConfigAbstract; override;

    function GetTileFileName(
      AXY: TPoint;
      Azoom: byte;
      AVersionInfo: IMapVersionInfo
    ): string; override;
    function GetTileInfo(
      AXY: TPoint;
      Azoom: byte;
      AVersionInfo: IMapVersionInfo
    ): ITileInfoBasic; override;

    function LoadTile(
      AXY: TPoint;
      Azoom: byte;
      AVersionInfo: IMapVersionInfo;
      AStream: TStream;
      out ATileInfo: ITileInfoBasic
    ): Boolean; override;

    function DeleteTile(
      AXY: TPoint;
      Azoom: byte;
      AVersionInfo: IMapVersionInfo
    ): Boolean; override;
    function DeleteTNE(
      AXY: TPoint;
      Azoom: byte;
      AVersionInfo: IMapVersionInfo
    ): Boolean; override;

    procedure SaveTile(
      AXY: TPoint;
      Azoom: byte;
      AVersionInfo: IMapVersionInfo;
      AStream: TStream
    ); override;
    procedure SaveTNE(
      AXY: TPoint;
      Azoom: byte;
      AVersionInfo: IMapVersionInfo
    ); override;

    function LoadFillingMap(
      btm: TCustomBitmap32;
      AXY: TPoint;
      Azoom: byte;
      ASourceZoom: byte;
      AVersionInfo: IMapVersionInfo;
      AIsStop: TIsCancelChecker;
      ANoTileColor: TColor32;
      AShowTNE: Boolean;
      ATNEColor: TColor32
    ): boolean; override;
  end;

implementation

uses
  SysUtils,
  t_GeoTypes,
  i_TileIterator,
  u_GlobalState,
  u_TileIteratorByRect,
  u_TileInfoBasic;

{ TTileStorageFileSystem }

constructor TTileStorageFileSystem.Create(AGlobalCacheConfig: TGlobalCahceConfig; AConfig: IConfigDataProvider);
var
  VParamsTXT: IConfigDataProvider;
  VParams: IConfigDataProvider;
begin
  VParamsTXT := AConfig.GetSubItem('params.txt');
  VParams := VParamsTXT.GetSubItem('Storage');
  if VParams = nil then begin
    VParams := VParamsTXT.GetSubItem('PARAMS');
  end;
  FUseDel:=VParams.ReadBool('Usedel',true);
  FIsStoreReadOnly:=VParams.ReadBool('ReadOnly', false);
  FUseSave:=VParams.ReadBool('Usesave',true);
  FTileFileExt:=LowerCase(VParams.ReadString('Ext','.jpg'));
  FCacheConfig := TMapTypeCacheConfig.Create(AGlobalCacheConfig, AConfig);
  FCoordConverter := GState.CoordConverterFactory.GetCoordConverterByConfig(VParams);
  FMainContentType := GState.ContentTypeManager.GetInfoByExt(FTileFileExt);
end;

procedure TTileStorageFileSystem.CreateDirIfNotExists(APath: string);
var
  i: integer;
begin
  i := LastDelimiter(PathDelim, Apath);
  Apath := copy(Apath, 1, i);
  if not(DirectoryExists(Apath)) then begin
    ForceDirectories(Apath);
  end;
end;

function TTileStorageFileSystem.DeleteTile(
  AXY: TPoint;
  Azoom: byte;
  AVersionInfo: IMapVersionInfo
): Boolean;
var
  VPath: string;
begin
  Result := false;
  if FUseDel then begin
    try
      VPath := FCacheConfig.GetTileFileName(AXY, Azoom);
      if FileExists(VPath) then begin
        result := DeleteFile(VPath);
      end;
      DeleteTNE(AXY, Azoom, AVersionInfo);
    except
      Result := false;
    end;
  end else begin
    Exception.Create('��� ���� ����� ��������� �������� ������.');
  end;
end;

function TTileStorageFileSystem.DeleteTNE(
  AXY: TPoint;
  Azoom: byte;
  AVersionInfo: IMapVersionInfo
): Boolean;
var
  VPath: string;
begin
  Result := False;
  if FUseDel then begin
    try
      VPath := FCacheConfig.GetTileFileName(AXY, Azoom);
      VPath := ChangeFileExt(VPath, '.tne');
      if FileExists(VPath) then begin
        result := DeleteFile(VPath);
      end;
    except
      Result := false;
    end;
  end else begin
    Exception.Create('��� ���� ����� ��������� �������� ������.');
  end;
end;

destructor TTileStorageFileSystem.Destroy;
begin
  FreeAndNil(FCacheConfig);
  inherited;
end;

function TTileStorageFileSystem.GetAllowDifferentContentTypes: Boolean;
begin
  Result := False;
end;

function TTileStorageFileSystem.GetCacheConfig: TMapTypeCacheConfigAbstract;
begin
  Result := FCacheConfig;
end;

function TTileStorageFileSystem.GetCoordConverter: ICoordConverter;
begin
  Result := FCoordConverter;
end;

function TTileStorageFileSystem.GetIsStoreFileCache: Boolean;
begin
  Result := True;
end;

function TTileStorageFileSystem.GetIsStoreReadOnly: boolean;
begin
  Result := FIsStoreReadOnly;
end;

function TTileStorageFileSystem.GetMainContentType: IContentTypeInfoBasic;
begin
  Result := FMainContentType;
end;

function TTileStorageFileSystem.GetTileFileExt: string;
begin
  Result := FTileFileExt;
end;

function TTileStorageFileSystem.GetTileFileName(
  AXY: TPoint;
  Azoom: byte;
  AVersionInfo: IMapVersionInfo
): string;
begin
  Result := FCacheConfig.GetTileFileName(AXY, Azoom);
end;

function TTileStorageFileSystem.GetTileInfoByPath(
  APath: string;
  AVersionInfo: IMapVersionInfo
): ITileInfoBasic;
var
  InfoFile: TSearchRec;
  VSearchResult: Integer;
begin
  VSearchResult := FindFirst(APath, faAnyFile, InfoFile);
  if VSearchResult <> 0 then begin
    APath := ChangeFileExt(APath, '.tne');
    VSearchResult := FindFirst(APath, faAnyFile, InfoFile);
    if VSearchResult <> 0 then begin
      Result := TTileInfoBasicNotExists.Create(0, nil);
    end else begin
      Result := TTileInfoBasicTNE.Create(FileDateToDateTime(InfoFile.Time), nil);
      FindClose(InfoFile);
    end;
  end else begin
    Result := TTileInfoBasicExists.Create(
      FileDateToDateTime(InfoFile.Time),
      InfoFile.Size,
      nil,
      FMainContentType
    );
    FindClose(InfoFile);
  end;
end;

function TTileStorageFileSystem.GetTileInfo(
  AXY: TPoint;
  Azoom: byte;
  AVersionInfo: IMapVersionInfo
): ITileInfoBasic;
var
  VPath: String;
begin
  VPath := FCacheConfig.GetTileFileName(AXY, Azoom);
  Result := GetTileInfoByPath(VPath, AVersionInfo);
end;

function TTileStorageFileSystem.GetUseDel: boolean;
begin
  Result := FUseDel;
end;

function TTileStorageFileSystem.GetUseSave: boolean;
begin
  Result := FUseSave;
end;

function TTileStorageFileSystem.LoadFillingMap(
  btm: TCustomBitmap32;
  AXY: TPoint;
  Azoom, ASourceZoom: byte;
  AVersionInfo: IMapVersionInfo;
  AIsStop: TIsCancelChecker;
  ANoTileColor: TColor32;
  AShowTNE: Boolean;
  ATNEColor: TColor32
): boolean;
var
  VPixelsRect: TRect;
  VRelativeRect: TDoubleRect;
  VSourceTilesRect: TRect;
  VCurrTile: TPoint;
  VTileSize: TPoint;
  VSourceTilePixels: TRect;
  VSolidDrow: Boolean;
  VIterator: ITileIterator;
  VFileName: string;
  VFolderName: string;
  VTileColor: TColor32;
  VPrevFolderName: string;
  VPrevFolderExist: Boolean;
  VFolderExists: Boolean;
  VFileExists: Boolean;
  VGeoConvert: ICoordConverter;
begin
  Result := true;
  try
    VGeoConvert := GetCoordConverter;
    VGeoConvert.CheckTilePosStrict(AXY, Azoom, True);
    VGeoConvert.CheckZoom(ASourceZoom);

    VPixelsRect := VGeoConvert.TilePos2PixelRect(AXY, Azoom);

    VTileSize := Point(VPixelsRect.Right - VPixelsRect.Left, VPixelsRect.Bottom - VPixelsRect.Top);

    btm.Width := VTileSize.X;
    btm.Height := VTileSize.Y;
    btm.Clear(0);

    VRelativeRect := VGeoConvert.TilePos2RelativeRect(AXY, Azoom);
    VSourceTilesRect := VGeoConvert.RelativeRect2TileRect(VRelativeRect, ASourceZoom);
    VPrevFolderName := '';
    VPrevFolderExist := False;
    begin
      VSolidDrow := (VTileSize.X <= 2 * (VSourceTilesRect.Right - VSourceTilesRect.Left))
        or (VTileSize.Y <= 2 * (VSourceTilesRect.Right - VSourceTilesRect.Left));
      VIterator := TTileIteratorByRect.Create(VSourceTilesRect);
      while VIterator.Next(VCurrTile) do begin
        if AIsStop then break;
        VFileName := FCacheConfig.GetTileFileName(VCurrTile, ASourceZoom);
        VFolderName := ExtractFilePath(VFileName);
        if VFolderName = VPrevFolderName then begin
          VFolderExists := VPrevFolderExist;
        end else begin
          VFolderExists := DirectoryExists(VFolderName);
          VPrevFolderName := VFolderName;
          VPrevFolderExist := VFolderExists;
        end;
        if VFolderExists then begin
          VFileExists := FileExists(VFileName);
        end else begin
          VFileExists := False;
        end;

        if not VFileExists then begin
          if AIsStop then break;
          VRelativeRect := VGeoConvert.TilePos2RelativeRect(VCurrTile, ASourceZoom);
          VSourceTilePixels := VGeoConvert.RelativeRect2PixelRect(VRelativeRect, Azoom);
          if VSourceTilePixels.Left < VPixelsRect.Left then begin
            VSourceTilePixels.Left := VPixelsRect.Left;
          end;
          if VSourceTilePixels.Top < VPixelsRect.Top then begin
            VSourceTilePixels.Top := VPixelsRect.Top;
          end;
          if VSourceTilePixels.Right > VPixelsRect.Right then begin
            VSourceTilePixels.Right := VPixelsRect.Right;
          end;
          if VSourceTilePixels.Bottom > VPixelsRect.Bottom then begin
            VSourceTilePixels.Bottom := VPixelsRect.Bottom;
          end;
          VSourceTilePixels.Left := VSourceTilePixels.Left - VPixelsRect.Left;
          VSourceTilePixels.Top := VSourceTilePixels.Top - VPixelsRect.Top;
          VSourceTilePixels.Right := VSourceTilePixels.Right - VPixelsRect.Left;
          VSourceTilePixels.Bottom := VSourceTilePixels.Bottom - VPixelsRect.Top;
          if not VSolidDrow then begin
            Dec(VSourceTilePixels.Right);
            Dec(VSourceTilePixels.Bottom);
          end;
          if AShowTNE then begin
            if VFolderExists then begin
              VFileName := ChangeFileExt(VFileName, '.tne');
              if FileExists(VFileName) then begin
                VTileColor := ATNEColor;
              end else begin
                VTileColor := ANoTileColor;
              end;
            end else begin
              VTileColor := ANoTileColor;
            end;
          end else begin
            VTileColor := ANoTileColor;
          end;
          if ((VSourceTilePixels.Right-VSourceTilePixels.Left)=1)and
             ((VSourceTilePixels.Bottom-VSourceTilePixels.Top)=1)then begin
            btm.Pixel[VSourceTilePixels.Left,VSourceTilePixels.Top]:=VTileColor;
          end else begin
            btm.FillRect(VSourceTilePixels.Left,VSourceTilePixels.Top,VSourceTilePixels.Right,VSourceTilePixels.Bottom, VTileColor);
          end;
        end;
      end;
    end;
    if AIsStop then begin
      Result := false;
    end;
  except
    Result := false;
  end;
end;

function TTileStorageFileSystem.LoadTile(
  AXY: TPoint;
  Azoom: byte;
  AVersionInfo: IMapVersionInfo;
  AStream: TStream;
  out ATileInfo: ITileInfoBasic
): Boolean;
var
  VPath: String;
  VMemStream: TMemoryStream;
begin
  VPath := FCacheConfig.GetTileFileName(AXY, Azoom);
  ATileInfo := GetTileInfoByPath(VPath, AVersionInfo);
  if ATileInfo.GetIsExists then begin
    if AStream is TMemoryStream then begin
      VMemStream := TMemoryStream(AStream);
      VMemStream.LoadFromFile(VPath);
      Result := True;
    end else begin
      VMemStream := TMemoryStream.Create;
      try
        VMemStream.LoadFromFile(VPath);
        VMemStream.SaveToStream(AStream);
        Result := True;
      finally
        VMemStream.Free;
      end;
    end;
  end else begin
    Result := False;
  end;
end;

procedure TTileStorageFileSystem.SaveTile(
  AXY: TPoint;
  Azoom: byte;
  AVersionInfo: IMapVersionInfo;
  AStream: TStream
);
var
  VPath: String;
  VMemStream: TMemoryStream;
begin
  if FUseSave then begin
    VPath := FCacheConfig.GetTileFileName(AXY, Azoom);
    CreateDirIfNotExists(VPath);
    if AStream is TMemoryStream then begin
      VMemStream := TMemoryStream(AStream);
      VMemStream.SaveToFile(VPath);
    end else begin
      VMemStream := TMemoryStream.Create;
      try
        VMemStream.LoadFromStream(AStream);
        VMemStream.SaveToFile(VPath);
      finally
        VMemStream.Free;
      end;
    end;
  end else begin
    raise Exception.Create('��� ���� ����� ��������� ���������� ������.');
  end;
end;

procedure TTileStorageFileSystem.SaveTNE(
  AXY: TPoint;
  Azoom: byte;
  AVersionInfo: IMapVersionInfo
);
var
  VPath: String;
  F:textfile;
begin
  if FUseSave then begin
    VPath := FCacheConfig.GetTileFileName(AXY, Azoom);
    VPath := ChangeFileExt(VPath, '.tne');
    if not FileExists(VPath) then begin
      CreateDirIfNotExists(VPath);
      AssignFile(f,VPath);
      Rewrite(F);
      Writeln(f, DateTimeToStr(now));
      CloseFile(f);
    end;
  end else begin
    raise Exception.Create('��� ���� ����� ��������� ���������� ������.');
  end;
end;

end.
