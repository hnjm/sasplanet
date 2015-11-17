{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2014, SAS.Planet development team.                      *}
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
{* http://sasgis.org                                                          *}
{* info@sasgis.org                                                            *}
{******************************************************************************}

unit frm_CacheManager;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  ComCtrls,
  TB2Item,
  TB2Dock,
  TB2Toolbar,
  TBX,
  fr_CacheTypeList,
  i_NotifierOperation,
  i_ProjectionSet,
  i_ProjectionSetFactory,
  i_TileStorage,
  i_LanguageManager,
  i_NotifierTime,
  i_ContentTypeManager,
  i_ArchiveReadWriteFactory,
  i_TileFileNameGeneratorsList,
  i_TileFileNameParsersList,
  i_TileStorageTypeList,
  i_ValueToStringConverter,
  i_MapVersionFactoryList,
  i_GlobalBerkeleyDBHelper,
  u_CommonFormAndFrameParents;

type
  TfrmCacheManager = class(TFormWitghLanguageManager)
    PageControl1: TPageControl;
    tsConverter: TTabSheet;
    pnlBottomButtons: TPanel;
    btnStart: TButton;
    btnCansel: TButton;
    grpSrc: TGroupBox;
    lblPath: TLabel;
    edtPath: TEdit;
    pnlCacheTypes: TPanel;
    lblCacheType: TLabel;
    chkIgnoreTNE: TCheckBox;
    chkRemove: TCheckBox;
    edtDefExtention: TEdit;
    lblDefExtention: TLabel;
    grpDestCache: TGroupBox;
    lblDestPath: TLabel;
    lblDestFormat: TLabel;
    edtDestPath: TEdit;
    pnlDestCacheTypes: TPanel;
    chkOverwrite: TCheckBox;
    btnSelectSrcPath: TButton;
    btnSelectDestPath: TButton;
    chkCheckSourceVersion: TCheckBox;
    edtSourceVersion: TEdit;
    chkReplaceDestVersion: TCheckBox;
    edtDestVersion: TEdit;
    TBXDontClose: TTBXToolbar;
    tbtmDontClose: TTBItem;
    procedure btnStartClick(Sender: TObject);
    procedure btnSelectSrcPathClick(Sender: TObject);
    procedure btnSelectDestPathClick(Sender: TObject);
    procedure btnCanselClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    type
      TTileCacheInArchiveType = (atNoArch = 0, atTar = 1, atZip = 2, atUnk = 3);
  private
    FLanguageManager: ILanguageManager;
    FAppClosingNotifier: INotifierOneOperation;
    FTimerNoifier: INotifierTime;
    FGCNotifier: INotifierTime;
    FMapVersionFactoryList: IMapVersionFactoryList;
    FGlobalBerkeleyDBHelper: IGlobalBerkeleyDBHelper;
    FContentTypeManager: IContentTypeManager;
    FProjectionSetFactory: IProjectionSetFactory;
    FArchiveReadWriteFactory: IArchiveReadWriteFactory;
    FTileStorageTypeList: ITileStorageTypeListStatic;
    FFileNameGeneratorsList: ITileFileNameGeneratorsList;
    FFileNameParsersList: ITileFileNameParsersList;
    FValueToStringConverter: IValueToStringConverterChangeable;
    FfrSrcCacheTypesList: TfrCacheTypeList;
    FfrDestCacheTypesList: TfrCacheTypeList;
    procedure ProcessCacheConverter;
    function CreateSimpleTileStorage(
      const ARootPath: string;
      const ADefExtention: AnsiString;
      const AArchiveType: TTileCacheInArchiveType;
      const AProjectionSet: IProjectionSet;
      const AFormatID: Byte
    ): ITileStorage;
  public
    constructor Create(
      const ALanguageManager: ILanguageManager;
      const AAppClosingNotifier: INotifierOneOperation;
      const ATimerNoifier: INotifierTime;
      const AGCNotifier: INotifierTime;
      const AMapVersionFactoryList: IMapVersionFactoryList;
      const AGlobalBerkeleyDBHelper: IGlobalBerkeleyDBHelper;
      const AContentTypeManager: IContentTypeManager;
      const AProjectionSetFactory: IProjectionSetFactory;
      const AArchiveReadWriteFactory: IArchiveReadWriteFactory;
      const ATileStorageTypeList: ITileStorageTypeListStatic;
      const AFileNameGeneratorsList: ITileFileNameGeneratorsList;
      const AFileNameParsersList: ITileFileNameParsersList;
      const AValueToStringConverter: IValueToStringConverterChangeable
    ); reintroduce;
    destructor Destroy; override;
  end;

implementation

uses
  {$WARN UNIT_PLATFORM OFF}
  FileCtrl,
  {$WARN UNIT_PLATFORM ON}
  ALString,
  c_CacheTypeCodes,
  c_CoordConverter,
  i_MapVersionInfo,
  i_ContentTypeInfo,
  i_TileStorageAbilities,
  i_TileFileNameGenerator,
  i_TileFileNameParser,
  i_TileStorageTypeListItem,
  i_CacheConverterProgressInfo,
  u_Notifier,
  u_NotifierOperation,
  u_ThreadCacheConverter,
  u_TileStorageTar,
  u_CacheConverterProgressInfo,
  u_Synchronizer,
  frm_ProgressCacheConvrter;

{$R *.dfm}

{TfrmCacheManager}

constructor TfrmCacheManager.Create(
  const ALanguageManager: ILanguageManager;
  const AAppClosingNotifier: INotifierOneOperation;
  const ATimerNoifier: INotifierTime;
  const AGCNotifier: INotifierTime;
  const AMapVersionFactoryList: IMapVersionFactoryList;
  const AGlobalBerkeleyDBHelper: IGlobalBerkeleyDBHelper;
  const AContentTypeManager: IContentTypeManager;
  const AProjectionSetFactory: IProjectionSetFactory;
  const AArchiveReadWriteFactory: IArchiveReadWriteFactory;
  const ATileStorageTypeList: ITileStorageTypeListStatic;
  const AFileNameGeneratorsList: ITileFileNameGeneratorsList;
  const AFileNameParsersList: ITileFileNameParsersList;
  const AValueToStringConverter: IValueToStringConverterChangeable
);
begin
  inherited Create(ALanguageManager);
  FLanguageManager := ALanguageManager;
  FAppClosingNotifier := AAppClosingNotifier;
  FTimerNoifier := ATimerNoifier;
  FGCNotifier := AGCNotifier;
  FMapVersionFactoryList := AMapVersionFactoryList;
  FGlobalBerkeleyDBHelper := AGlobalBerkeleyDBHelper;
  FArchiveReadWriteFactory := AArchiveReadWriteFactory;
  FFileNameGeneratorsList := AFileNameGeneratorsList;
  FFileNameParsersList := AFileNameParsersList;
  FContentTypeManager := AContentTypeManager;
  FProjectionSetFactory := AProjectionSetFactory;
  FValueToStringConverter := AValueToStringConverter;
  FTileStorageTypeList := ATileStorageTypeList;

  FfrSrcCacheTypesList :=
    TfrCacheTypeList.Create(
      ALanguageManager,
      ATileStorageTypeList,
      False,
      CTileStorageTypeClassAll - [tstcInMemory],
      [tsacScan]
    );
  FfrDestCacheTypesList :=
    TfrCacheTypeList.Create(
      ALanguageManager,
      ATileStorageTypeList,
      False,
      CTileStorageTypeClassAll - [tstcInMemory],
      [tsacAdd]
    );
end;

destructor TfrmCacheManager.Destroy;
begin
  FreeAndNil(FfrSrcCacheTypesList);
  FreeAndNil(FfrDestCacheTypesList);
  inherited;
end;

procedure TfrmCacheManager.FormShow(Sender: TObject);
begin
  FfrSrcCacheTypesList.Show(pnlCacheTypes);
  FfrDestCacheTypesList.Show(pnlDestCacheTypes);
  FfrSrcCacheTypesList.IntCode := c_File_Cache_Id_SAS;
  FfrDestCacheTypesList.IntCode := c_File_Cache_Id_BDB;
end;

function TfrmCacheManager.CreateSimpleTileStorage(
  const ARootPath: string;
  const ADefExtention: AnsiString;
  const AArchiveType: TTileCacheInArchiveType;
  const AProjectionSet: IProjectionSet;
  const AFormatID: Byte
): ITileStorage;
var
  VContentType: IContentTypeInfoBasic;
  VFileNameGenerator: ITileFileNameGenerator;
  VFileNameParser: ITileFileNameParser;
  VStorageType: ITileStorageTypeListItem;
begin
  Result := nil;

  VContentType := FContentTypeManager.GetInfoByExt(ADefExtention);
  if VContentType = nil then begin
    Exit;
  end;

  if AArchiveType <> atNoArch then begin
     if (AFormatID in [
      c_File_Cache_Id_BDB,
      c_File_Cache_Id_BDB_Versioned,
      c_File_Cache_Id_DBMS,
      c_File_Cache_Id_GE,
      c_File_Cache_Id_GC
    ]) then begin
      Exit;
    end;
    VFileNameGenerator := FFileNameGeneratorsList.GetGenerator(AFormatID);
    VFileNameParser := FFileNameParsersList.GetParser(AFormatID);
    case AArchiveType of
      atTar: begin
        Result :=
          TTileStorageTar.Create(
            nil,
            ARootPath,
            VContentType,
            FContentTypeManager,
            AProjectionSet,
            FArchiveReadWriteFactory.Tar.WriterFactory,
            VFileNameParser,
            VFileNameGenerator
          );
      end;
      atZip: begin
        // ToDo
        Assert(False);
      end;
    else
      // Error
      Assert(False);
    end;
  end else begin
    VStorageType := FTileStorageTypeList.GetItemByCode(AFormatID);
    if VStorageType <> nil then begin
      Result :=
        VStorageType.StorageType.BuildStorage(
          nil,
          AProjectionSet,
          VContentType,
          nil,
          ARootPath,
          nil
        );
    end;
  end;
end;

procedure TfrmCacheManager.btnSelectSrcPathClick(Sender: TObject);
var
  VPath: string;
begin
  VPath := edtPath.Text;
  if SelectDirectory('', '', VPath) then begin
    edtPath.Text := IncludeTrailingPathDelimiter(VPath);
  end;
end;

procedure TfrmCacheManager.btnCanselClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmCacheManager.btnSelectDestPathClick(Sender: TObject);
var
  VPath: string;
begin
  VPath := edtDestPath.Text;
  if SelectDirectory('', '', VPath) then begin
    edtDestPath.Text := IncludeTrailingPathDelimiter(VPath);
  end;
end;

procedure TfrmCacheManager.btnStartClick(Sender: TObject);
begin
  if PageControl1.ActivePageIndex = 0 then begin
    ProcessCacheConverter;
  end;
  if not tbtmDontClose.Checked then begin
    Self.Close;
  end;
end;

procedure TfrmCacheManager.ProcessCacheConverter;

  function IsTileCacheInArchive(const APath: string; out AArchType: TTileCacheInArchiveType): Boolean;
  begin
    if LowerCase(ExtractFileExt(APath)) = '.tar' then begin
      AArchType := atTar;
    end else if LowerCase(ExtractFileExt(APath)) = '.zip' then begin
      AArchType := atZip;
    end else if ExtractFileExt(APath) <> '' then begin
      AArchType := atUnk;
    end else begin
      AArchType := atNoArch;
    end;
    Result := not (AArchType in [atNoArch, atUnk]);
  end;

var
  VProgressInfo: ICacheConverterProgressInfo;
  VCancelNotifierInternal: INotifierOperationInternal;
  VOperationID: Integer;
  VConverterThread: TThreadCacheConverter;
  VProjectionSet: IProjectionSet;
  VSourceStorage: ITileStorage;
  VDestStorage: ITileStorage;
  VSourceVersion: IMapVersionInfo;
  VDestVersion: IMapVersionInfo;
  VSourcePath: string;
  VDestPath: string;
  VDefExtention: AnsiString;
  VDotPos: Integer;
  VArchType: TTileCacheInArchiveType;
begin
  VProgressInfo := TCacheConverterProgressInfo.Create;

  VCancelNotifierInternal :=
    TNotifierOperation.Create(
      TNotifierBase.Create(GSync.SyncVariable.Make(Self.ClassName + 'Notifier'))
    );
  VOperationID := VCancelNotifierInternal.CurrentOperation;

  VProjectionSet := FProjectionSetFactory.GetProjectionSetByCode(CGoogleProjectionEPSG, CTileSplitQuadrate256x256);

  VDefExtention := AnsiString(Trim(edtDefExtention.Text));
  VDotPos := ALPos('.', VDefExtention);
  if VDotPos > 0 then begin
    VDefExtention := ALCopyStr(VDefExtention, VDotPos, Length(VDefExtention) - VDotPos + 1);
  end else begin
    VDefExtention := '.' + VDefExtention;
  end;
  VDefExtention := AlLowerCase(VDefExtention);

  VSourcePath := Trim(edtPath.Text);
  if not IsTileCacheInArchive(VSourcePath, VArchType) then begin
    VSourcePath := IncludeTrailingPathDelimiter(VSourcePath);
  end;

  VSourceStorage :=
    CreateSimpleTileStorage(
      VSourcePath,
      VDefExtention,
      VArchType,
      VProjectionSet,
      FfrSrcCacheTypesList.IntCode
    );

  VDestPath := Trim(edtDestPath.Text);
  if not IsTileCacheInArchive(VDestPath, VArchType) then begin
    VDestPath := IncludeTrailingPathDelimiter(VDestPath);
    if FfrDestCacheTypesList.IntCode <> c_File_Cache_Id_DBMS then begin
      ForceDirectories(VDestPath);
    end;
  end;

  VDestStorage :=
    CreateSimpleTileStorage(
      VDestPath,
      VDefExtention,
      VArchType,
      VProjectionSet,
      FfrDestCacheTypesList.IntCode
    );

  VSourceVersion := nil;
  VDestVersion := nil;

  if chkCheckSourceVersion.Checked then begin
    VSourceVersion := FMapVersionFactoryList.GetSimpleVersionFactory.CreateByStoreString(Trim(edtSourceVersion.Text));
  end;

  if chkReplaceDestVersion.Checked then begin
    VDestVersion := FMapVersionFactoryList.GetSimpleVersionFactory.CreateByStoreString(Trim(edtDestVersion.Text));
  end;

  VConverterThread := TThreadCacheConverter.Create(
    VCancelNotifierInternal,
    VOperationID,
    VSourceStorage,
    VSourceVersion,
    VSourcePath,
    VDestStorage,
    VDestVersion,
    chkIgnoreTNE.Checked,
    chkRemove.Checked,
    chkOverwrite.Checked,
    VProgressInfo
  );

  TfrmProgressCacheConverter.Create(
    VConverterThread,
    FLanguageManager,
    FAppClosingNotifier,
    FTimerNoifier,
    VCancelNotifierInternal,
    VProgressInfo,
    FValueToStringConverter
  );
end;

end.


