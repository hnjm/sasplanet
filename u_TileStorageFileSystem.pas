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

unit u_TileStorageFileSystem;

interface

uses
  Windows,
  Classes,
  SysUtils,
  GR32,
  i_BinaryData,
  i_SimpleTileStorageConfig,
  i_CoordConverter,
  i_MapVersionInfo,
  i_ContentTypeInfo,
  i_MapVersionConfig,
  i_TileInfoBasic,
  i_TileStorage,
  i_TileFileNameParsersList,
  i_TileFileNameGeneratorsList,
  i_ContentTypeManager,
  i_InternalPerformanceCounter,
  i_TileFileNameGenerator,
  i_TileFileNameParser,
  u_GlobalCahceConfig,
  u_MapTypeCacheConfig,
  u_TileStorageAbstract;

type
  TTileStorageFileSystem = class(TTileStorageAbstract)
  private
    FMainContentType: IContentTypeInfoBasic;
    FFileExt: string;
    FTileFileNameParser: ITileFileNameParser;
    FFileNameGenerator: ITileFileNameGenerator;

    FFormatSettings: TFormatSettings;
    FTileNotExistsTileInfo: ITileInfoBasic;

    procedure CreateDirIfNotExists(const APath: string);
    function GetTileInfoByPath(
      const APath: string;
      const AVersionInfo: IMapVersionInfo;
      AIsLoadIfExists: Boolean
    ): ITileInfoBasic;
  protected
    function GetTileFileName(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersionInfo: IMapVersionInfo
    ): string; override;
    function GetTileInfo(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersionInfo: IMapVersionInfo;
      const AMode: TGetTileInfoMode
    ): ITileInfoBasic; override;
    function GetTileRectInfo(
      const ARect: TRect;
      const AZoom: byte;
      const AVersionInfo: IMapVersionInfo
    ): ITileRectInfo; override;

    function DeleteTile(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersionInfo: IMapVersionInfo
    ): Boolean; override;
    function DeleteTNE(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersionInfo: IMapVersionInfo
    ): Boolean; override;

    procedure SaveTile(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersionInfo: IMapVersionInfo;
      const AData: IBinaryData
    ); override;
    procedure SaveTNE(
      const AXY: TPoint;
      const AZoom: byte;
      const AVersionInfo: IMapVersionInfo
    ); override;

    function ScanTiles(
      const AIgnoreTNE: Boolean
    ): IEnumTileInfo; override;
  public
    constructor Create(
      const AGeoConverter: ICoordConverter;
      const AStoragePath: string;
      const AFileExt: string;
      const AMainContentType: IContentTypeInfoBasic;
      const AMapVersionFactory: IMapVersionFactory;
      const ATileNameGenerator: ITileFileNameGenerator;
      const ATileNameParser: ITileFileNameParser
    );

  end;

implementation

uses
  WideStrings,
  t_CommonTypes,
  c_CacheTypeCodes,
  i_TileIterator,
  i_FileNameIterator,
  i_StorageState,
  u_TileRectInfoShort,
  u_BinaryDataByMemStream,
  u_MapVersionFactorySimpleString,
  u_TileStorageTypeAbilities,
  u_TileIteratorByRect,
  u_FileNameIteratorFolderWithSubfolders,
  u_FoldersIteratorRecursiveByLevels,
  u_FileNameIteratorInFolderByMaskList,
  u_TreeFolderRemover,
  u_Synchronizer,
  u_TileInfoBasic;

const
  CTneFileExt = '.tne';

{ TTileStorageFileSystem }

constructor TTileStorageFileSystem.Create(
  const AGeoConverter: ICoordConverter;
  const AStoragePath: string;
  const AFileExt: string;
  const AMainContentType: IContentTypeInfoBasic;
  const AMapVersionFactory: IMapVersionFactory;
  const ATileNameGenerator: ITileFileNameGenerator;
  const ATileNameParser: ITileFileNameParser
);
begin
  Assert(AGeoConverter <> nil);
  Assert(AStoragePath <> '');
  Assert(AFileExt <> '');
  Assert(AMainContentType <> nil);
  Assert(ATileNameGenerator <> nil);
  Assert(ATileNameParser <> nil);
  inherited Create(
    TTileStorageTypeAbilitiesFileFolder.Create,
    AMapVersionFactory,
    AGeoConverter,
    AStoragePath
  );
  FFileExt := AFileExt;
  FMainContentType := AMainContentType;
  FTileFileNameParser := ATileNameParser;
  FFileNameGenerator := ATileNameGenerator;


  FFormatSettings.DecimalSeparator := '.';
  FFormatSettings.DateSeparator := '-';
  FFormatSettings.ShortDateFormat := 'yyyy-MM-dd';
  FFormatSettings.TimeSeparator := '-';
  FFormatSettings.LongTimeFormat := 'HH-mm-ss';
  FFormatSettings.ShortTimeFormat := 'HH-mm-ss';
  FFormatSettings.ListSeparator := ';';
  FFormatSettings.TwoDigitYearCenturyWindow := 50;
  FTileNotExistsTileInfo := TTileInfoBasicNotExists.Create(0, nil);
end;

procedure TTileStorageFileSystem.CreateDirIfNotExists(const APath: string);
var
  i: integer;
  VPath: string;
begin
  i := LastDelimiter(PathDelim, APath);
  VPath := copy(APath, 1, i);
  if not (DirectoryExists(VPath)) then begin
    ForceDirectories(VPath);
  end;
end;

function TTileStorageFileSystem.DeleteTile(
  const AXY: TPoint;
  const AZoom: byte;
  const AVersionInfo: IMapVersionInfo
): Boolean;
var
  VPath: string;
begin
  Result := false;
  if GetState.GetStatic.DeleteAccess <> asDisabled then begin
    try
      VPath :=
        StoragePath +
        FFileNameGenerator.GetTileFileName(AXY, AZoom) +
        FFileExt;

      Result := DeleteFile(VPath);
      DeleteTNE(AXY, AZoom, AVersionInfo);
    except
      Result := false;
    end;
    if Result then begin
      NotifyTileUpdate(AXY, AZoom, AVersionInfo);
    end;
  end;
end;

function TTileStorageFileSystem.DeleteTNE(
  const AXY: TPoint;
  const AZoom: byte;
  const AVersionInfo: IMapVersionInfo
): Boolean;
var
  VPath: string;
begin
  Result := False;
  if GetState.GetStatic.DeleteAccess <> asDisabled then begin
    try
      VPath :=
        StoragePath +
        FFileNameGenerator.GetTileFileName(AXY, AZoom) +
        CTneFileExt;
      Result := DeleteFile(VPath);
    except
      Result := false;
    end;
  end;
end;

function TTileStorageFileSystem.GetTileFileName(
  const AXY: TPoint;
  const AZoom: byte;
  const AVersionInfo: IMapVersionInfo
): string;
begin
  Result :=
    StoragePath +
    FFileNameGenerator.GetTileFileName(AXY, AZoom) +
    FFileExt;
end;

function _GetFileDateTime(var AInfo: WIN32_FILE_ATTRIBUTE_DATA): TDateTime;
var
  VSysTime: TSystemTime;
  VFileTimePtr: PFileTime;
begin
  Result := 0;
  VFileTimePtr := nil;

  // last modified time (if exists)
  if (AInfo.ftLastWriteTime.dwLowDateTime <> 0) and (AInfo.ftLastWriteTime.dwHighDateTime <> 0) then begin
    VFileTimePtr := @(AInfo.ftLastWriteTime);
  end;

  // created time (if exists and greater)
  if (AInfo.ftCreationTime.dwLowDateTime <> 0) and (AInfo.ftCreationTime.dwHighDateTime <> 0) then begin
    if (nil = VFileTimePtr) or (CompareFileTime(AInfo.ftCreationTime, VFileTimePtr^) > 0) then begin
      VFileTimePtr := @(AInfo.ftCreationTime);
    end;
  end;

  // convert max value
  if (nil <> VFileTimePtr) then begin
    if (FileTimeToSystemTime(VFileTimePtr^, VSysTime) <> FALSE) then begin
      try
        Result := SystemTimeToDateTime(VSysTime);
      except
      end;
    end;
  end;
end;

procedure UpdateTileInfoByFile(
  const AIsTneFile: Boolean;
  const AIsLoadData: Boolean;
  const AFileName: string;
  var ATileInfo: TTileInfo
);
var
  VInfo: WIN32_FILE_ATTRIBUTE_DATA;
  VMemStream: TMemoryStream;
begin
  if GetFileAttributesEx(PChar(AFileName), GetFileExInfoStandard, @VInfo) <> FALSE then begin
    if AIsTneFile then begin
      ATileInfo.FInfoType := titTneExists;
      ATileInfo.FLoadDate := _GetFileDateTime(VInfo);
      ATileInfo.FData := nil;
      ATileInfo.FSize := 0;
    end else begin
      ATileInfo.FInfoType := titExists;
      ATileInfo.FLoadDate := _GetFileDateTime(VInfo);
      if AIsLoadData then begin
        VMemStream := TMemoryStream.Create;
        try
          VMemStream.LoadFromFile(AFileName);
          ATileInfo.FData := TBinaryDataByMemStream.CreateWithOwn(VMemStream);
          VMemStream := nil;
        finally
          VMemStream.Free;
        end;
        ATileInfo.FSize := ATileInfo.FData.Size;
      end else begin
        ATileInfo.FData := nil;
        ATileInfo.FSize := VInfo.nFileSizeLow;
      end;
    end;
  end else begin
    ATileInfo.FInfoType := titNotExists;
    ATileInfo.FLoadDate := 0;
    ATileInfo.FData := nil;
    ATileInfo.FSize := 0;
  end;
end;

function TTileStorageFileSystem.GetTileInfoByPath(
  const APath: string;
  const AVersionInfo: IMapVersionInfo;
  AIsLoadIfExists: Boolean
): ITileInfoBasic;
var
  VTileInfo: TTileInfo;
begin
    UpdateTileInfoByFile(False, AIsLoadIfExists, APath, VTileInfo);
    if VTileInfo.FInfoType = titExists then begin
    // tile exists
    if AIsLoadIfExists then begin
        Result :=
          TTileInfoBasicExistsWithTile.Create(
            VTileInfo.FLoadDate,
            VTileInfo.FData,
          nil,
          FMainContentType
        );
    end else begin
      Result :=
        TTileInfoBasicExists.Create(
            VTileInfo.FLoadDate,
            VTileInfo.FSize,
          nil,
          FMainContentType
        );
    end;
    end else begin
      UpdateTileInfoByFile(True, AIsLoadIfExists, ChangeFileExt(APath, CTneFileExt), VTileInfo);
      if VTileInfo.FInfoType = titTneExists then begin
        // tne exists
        Result := TTileInfoBasicTNE.Create(VTileInfo.FLoadDate, nil);
      end else begin
        // neither tile nor tne
        Result := FTileNotExistsTileInfo;
      end;
    end;
end;

function TTileStorageFileSystem.GetTileRectInfo(
  const ARect: TRect;
  const AZoom: byte;
  const AVersionInfo: IMapVersionInfo
): ITileRectInfo;
var
  VTileInfo: TTileInfo;
  VFileName: string;
  VRect: TRect;
  VZoom: Byte;
  VCount: TPoint;
  VItems: TArrayOfTileInfoShortInternal;
  VIndex: Integer;
  VTile: TPoint;
  VIterator: ITileIterator;
  VFolderName: string;
  VPrevFolderName: string;
  VPrevFolderExist: Boolean;
  VFolderExists: Boolean;
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
        VPrevFolderName := '';
        VPrevFolderExist := False;
        VIterator := TTileIteratorByRect.Create(VRect);
        while VIterator.Next(VTile) do begin
          VIndex := (VTile.Y - VRect.Top) * VCount.X + (VTile.X - VRect.Left);
          VFileName := StoragePath + FFileNameGenerator.GetTileFileName(VTile, VZoom);
          VFolderName := ExtractFilePath(VFileName);

          if VFolderName = VPrevFolderName then begin
            VFolderExists := VPrevFolderExist;
          end else begin
            VFolderExists := DirectoryExists(VFolderName);
            VPrevFolderName := VFolderName;
            VPrevFolderExist := VFolderExists;
          end;
          if VFolderExists then begin
              UpdateTileInfoByFile(False, False, VFileName + FFileExt, VTileInfo);
              if VTileInfo.FInfoType = titExists then begin
              // tile exists
              VItems[VIndex].FInfoType := titExists;
                VItems[VIndex].FLoadDate := VTileInfo.FLoadDate;
                VItems[VIndex].FSize := VTileInfo.FSize;
              end else begin
                UpdateTileInfoByFile(True, False, VFileName + CTneFileExt, VTileInfo);
                if VTileInfo.FInfoType = titTneExists then begin
                  // tne exists
                  VItems[VIndex].FInfoType := titTneExists;
                  VItems[VIndex].FLoadDate := VTileInfo.FLoadDate;
                  VItems[VIndex].FSize := 0;
                end else begin
                  // neither tile nor tne
                  VItems[VIndex].FLoadDate := 0;
                  VItems[VIndex].FSize := 0;
                  VItems[VIndex].FInfoType := titNotExists;
                end;
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

function TTileStorageFileSystem.GetTileInfo(
  const AXY: TPoint;
  const AZoom: byte;
  const AVersionInfo: IMapVersionInfo;
  const AMode: TGetTileInfoMode
): ITileInfoBasic;
var
  VPath: String;
begin
  Result := nil;
  if GetState.GetStatic.ReadAccess <> asDisabled then begin
    VPath :=
      StoragePath +
      FFileNameGenerator.GetTileFileName(AXY, AZoom) +
      FFileExt;
      Result := GetTileInfoByPath(VPath, AVersionInfo, AMode = gtimWithData);
  end;
end;

procedure TTileStorageFileSystem.SaveTile(
  const AXY: TPoint;
  const AZoom: byte;
  const AVersionInfo: IMapVersionInfo;
  const AData: IBinaryData
);
var
  VPath: String;
  VFileStream: TFileStream;
begin
    if GetState.GetStatic.WriteAccess <> asDisabled then begin
      VPath :=
        StoragePath +
        FFileNameGenerator.GetTileFileName(AXY, AZoom) +
        FFileExt;
      CreateDirIfNotExists(VPath);
      VFileStream := TFileStream.Create(VPath, fmCreate);
      try
        VFileStream.Size := AData.Size;
        VFileStream.Position := 0;
        VFileStream.WriteBuffer(AData.Buffer^, AData.Size);
      finally
        VFileStream.Free;
      end;
      NotifyTileUpdate(AXY, AZoom, AVersionInfo);
    end;
end;

procedure TTileStorageFileSystem.SaveTNE(
  const AXY: TPoint;
  const AZoom: byte;
  const AVersionInfo: IMapVersionInfo
);
var
  VPath: String;
  VNow: TDateTime;
  VDateString: string;
  VFileStream: TFileStream;
begin
    if GetState.GetStatic.WriteAccess <> asDisabled then begin
      VPath :=
        StoragePath +
        FFileNameGenerator.GetTileFileName(AXY, AZoom) +
        CTneFileExt;
      if not FileExists(VPath) then begin
        CreateDirIfNotExists(VPath);
        VNow := Now;
        DateTimeToString(VDateString, 'yyyy-mm-dd-hh-nn-ss', VNow, FFormatSettings);
        VFileStream := TFileStream.Create(VPath, fmCreate);
        try
          VFileStream.WriteBuffer(VDateString[1], Length(VDateString) * SizeOf(VDateString[1]));
        finally
          VFileStream.Free;
        end;
      end;
    end;
end;

{ TEnumTileInfoByFileIterator }

type
  TEnumTileInfoByFileIterator = class(TInterfacedObject, IEnumTileInfo)
  private
    FFilesIterator: IFileNameIterator;
    FTileFileNameParser: ITileFileNameParser;
    FStorageState: IStorageStateChangeble;
    FMainContentType: IContentTypeInfoBasic;
    FLock: IReadWriteSync;
  private
    function Next(var ATileInfo: TTileInfo): Boolean;
  public
    constructor Create(
      const AFilesIterator: IFileNameIterator;
      const ATileFileNameParser: ITileFileNameParser;
      const AStorageState: IStorageStateChangeble;
      const AMainContentType: IContentTypeInfoBasic
    );
  end;

constructor TEnumTileInfoByFileIterator.Create(
  const AFilesIterator: IFileNameIterator;
  const ATileFileNameParser: ITileFileNameParser;
  const AStorageState: IStorageStateChangeble;
  const AMainContentType: IContentTypeInfoBasic);
begin
  inherited Create;
  FFilesIterator := AFilesIterator;
  FTileFileNameParser := ATileFileNameParser;
  FStorageState := AStorageState;
  FMainContentType := AMainContentType;
end;

function TEnumTileInfoByFileIterator.Next(var ATileInfo: TTileInfo): Boolean;
var
  VTileFileName: string;
  VTileFileNameW: WideString;
  VTileXY: TPoint;
  VTileZoom: Byte;
  VFullFileName: string;
begin
  Result := False;
  while FFilesIterator.Next(VTileFileNameW) do begin
    VTileFileName := VTileFileNameW;
    if FTileFileNameParser.GetTilePoint(VTileFileName, VTileXY, VTileZoom) then begin
      VFullFileName := FFilesIterator.GetRootFolderName + VTileFileNameW;
      if FStorageState.GetStatic.ReadAccess <> asDisabled then begin
        FLock.BeginRead;
        try
          UpdateTileInfoByFile(
            ExtractFileExt(VFullFileName) = CTneFileExt,
            True,
            VFullFileName,
            ATileInfo
          );
          ATileInfo.FTile := VTileXY;
          ATileInfo.FZoom := VTileZoom;
          ATileInfo.FVersionInfo := nil;
          ATileInfo.FContentType := FMainContentType;
          if ATileInfo.FInfoType <> titNotExists then begin
            Result := True;
            Break;
          end;
        finally
          FLock.EndRead;
        end;
      end;
    end;
  end;
end;

function TTileStorageFileSystem.ScanTiles(
  const AIgnoreTNE: Boolean): IEnumTileInfo;
const
  cMaxFolderDepth = 10;
var
  VProcessFileMasks: TWideStringList;
  VFilesIterator: IFileNameIterator;
  VFoldersIteratorFactory: IFileNameIteratorFactory;
  VFilesInFolderIteratorFactory: IFileNameIteratorFactory;
begin
  VProcessFileMasks := TWideStringList.Create;
  try
    VProcessFileMasks.Add('*' + FFileExt);
    if not AIgnoreTNE then begin
      VProcessFileMasks.Add('*' + CTneFileExt);
    end;

    VFoldersIteratorFactory :=
      TFoldersIteratorRecursiveByLevelsFactory.Create(cMaxFolderDepth);

    VFilesInFolderIteratorFactory :=
      TFileNameIteratorInFolderByMaskListFactory.Create(VProcessFileMasks, True);

    VFilesIterator := TFileNameIteratorFolderWithSubfolders.Create(
      StoragePath,
      '',
      VFoldersIteratorFactory,
      VFilesInFolderIteratorFactory
    );
    Result :=
      TEnumTileInfoByFileIterator.Create(
        VFilesIterator,
        FTileFileNameParser,
        GetState,
        FMainContentType
      );
  finally
    VProcessFileMasks.Free;
  end;
end;

end.
