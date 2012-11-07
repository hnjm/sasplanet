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
  i_Notifier,
  i_NotifierOperation,
  i_CoordConverter,
  i_CoordConverterFactory,
  i_TileStorage,
  i_LanguageManager,
  i_NotifierTTLCheck,
  i_ContentTypeManager,
  i_TileFileNameGeneratorsList,
  i_TileFileNameParsersList,
  i_ValueToStringConverter,
  u_CommonFormAndFrameParents;

type
  TfrmCacheManager = class(TFormWitghLanguageManager)
    PageControl1: TPageControl;
    tsConverter: TTabSheet;
    pnlBottomButtons: TPanel;
    btnStart: TButton;
    btnCansel: TButton;
    chkCloseWithStart: TCheckBox;
    grpSrc: TGroupBox;
    lblPath: TLabel;
    edtPath: TEdit;
    cbbCacheTypes: TComboBox;
    lblCacheType: TLabel;
    chkIgnoreTNE: TCheckBox;
    chkRemove: TCheckBox;
    edtDefExtention: TEdit;
    lblDefExtention: TLabel;
    grpDestCache: TGroupBox;
    lblDestPath: TLabel;
    lblDestFormat: TLabel;
    edtDestPath: TEdit;
    cbbDestCacheTypes: TComboBox;
    chkOverwrite: TCheckBox;
    btnSelectSrcPath: TButton;
    btnSelectDestPath: TButton;
    procedure btnStartClick(Sender: TObject);
    procedure btnSelectSrcPathClick(Sender: TObject);
    procedure btnSelectDestPathClick(Sender: TObject);
    procedure btnCanselClick(Sender: TObject);
  private
    FLanguageManager: ILanguageManager;
    FAppClosingNotifier: INotifierOneOperation;
    FTimerNoifier: INotifier;
    FGCList: INotifierTTLCheck;
    FContentTypeManager: IContentTypeManager;
    FCoordConverterFactory: ICoordConverterFactory;
    FFileNameGeneratorsList: ITileFileNameGeneratorsList;
    FFileNameParsersList: ITileFileNameParsersList;
    FValueToStringConverterConfig: IValueToStringConverterConfig;
    procedure ProcessCacheConverter;
    function CreateSimpleTileStorage(
      const ARootPath: string;
      const ADefExtention: string;
      const ACoordConverter: ICoordConverter;
      const AFormatID: Byte
    ): ITileStorage;
  public
    constructor Create(
      const ALanguageManager: ILanguageManager;
      const AAppClosingNotifier: INotifierOneOperation;
      const ATimerNoifier: INotifier;
      const AGCList: INotifierTTLCheck;
      const AContentTypeManager: IContentTypeManager;
      const ACoordConverterFactory: ICoordConverterFactory;
      const AFileNameGeneratorsList: ITileFileNameGeneratorsList;
      const AFileNameParsersList: ITileFileNameParsersList;
      const AValueToStringConverterConfig: IValueToStringConverterConfig
    ); reintroduce;
    destructor Destroy; override;
  end;

implementation

uses
  {$WARN UNIT_PLATFORM OFF}
  FileCtrl,
  {$WARN UNIT_PLATFORM ON}
  c_CacheTypeCodes,
  c_CoordConverter,
  i_MapVersionConfig,
  i_ContentTypeInfo,
  i_TileFileNameGenerator,
  i_TileFileNameParser,
  i_CacheConverterProgressInfo,
  u_NotifierOperation,
  u_ThreadCacheConverter,
  u_MapVersionFactorySimpleString,
  u_TileStorageFileSystem,
  u_TileStorageBerkeleyDB,
  u_TileStorageGE,
  u_CacheConverterProgressInfo,
  frm_ProgressCacheConvrter;

{$R *.dfm}

{TfrmCacheManager}

constructor TfrmCacheManager.Create(
  const ALanguageManager: ILanguageManager;
  const AAppClosingNotifier: INotifierOneOperation;
  const ATimerNoifier: INotifier;
  const AGCList: INotifierTTLCheck;
  const AContentTypeManager: IContentTypeManager;
  const ACoordConverterFactory: ICoordConverterFactory;
  const AFileNameGeneratorsList: ITileFileNameGeneratorsList;
  const AFileNameParsersList: ITileFileNameParsersList;
  const AValueToStringConverterConfig: IValueToStringConverterConfig
);
begin
  inherited Create(ALanguageManager);
  FLanguageManager := ALanguageManager;
  FAppClosingNotifier := AAppClosingNotifier;
  FTimerNoifier := ATimerNoifier;
  FGCList := AGCList;
  FFileNameGeneratorsList := AFileNameGeneratorsList;
  FFileNameParsersList := AFileNameParsersList;
  FContentTypeManager := AContentTypeManager;
  FCoordConverterFactory := ACoordConverterFactory;
  FValueToStringConverterConfig := AValueToStringConverterConfig;

  cbbCacheTypes.ItemIndex := 1; // SAS.Planet
  cbbDestCacheTypes.ItemIndex := 5; // BerkeleyDB
end;

function TfrmCacheManager.CreateSimpleTileStorage(const ARootPath,
  ADefExtention: string; const ACoordConverter: ICoordConverter;
  const AFormatID: Byte): ITileStorage;
var
  VMapVersionFactory: IMapVersionFactory;
  VContentType: IContentTypeInfoBasic;
  VFileNameGenerator: ITileFileNameGenerator;
  VFileNameParser: ITileFileNameParser;
begin
  VContentType := FContentTypeManager.GetInfoByExt(ADefExtention);
  if AFormatID = c_File_Cache_Id_BDB then begin
    VMapVersionFactory := TMapVersionFactorySimpleString.Create;
    Result :=
      TTileStorageBerkeleyDB.Create(
        ACoordConverter,
        ARootPath,
        FGCList,
        False,
        FContentTypeManager,
        VMapVersionFactory,
        VContentType
      );
  end else if AFormatID = c_File_Cache_Id_GE then begin
//    Result :=
//      TTileStorageGE.Create(
//        VStorageConfig,
//        VGlobalCacheConfig,
//        FContentTypeManager
//      );
  end else if AFormatID = c_File_Cache_Id_GC then begin
//    Result :=
//      TTileStorageGC.Create(
//        VStorageConfig,
//        VGlobalCacheConfig,
//        FContentTypeManager
//      );
  end else if AFormatID in [c_File_Cache_Id_GMV, c_File_Cache_Id_SAS, c_File_Cache_Id_ES, c_File_Cache_Id_GM, c_File_Cache_Id_GM_Aux, c_File_Cache_Id_GM_Bing] then begin
    VMapVersionFactory := TMapVersionFactorySimpleString.Create;
    VFileNameGenerator := FFileNameGeneratorsList.GetGenerator(AFormatID);
    VFileNameParser := FFileNameParsersList.GetParser(AFormatID);
    Result :=
      TTileStorageFileSystem.Create(
        ACoordConverter,
        ARootPath,
        ADefExtention,
        VContentType,
        VMapVersionFactory,
        VFileNameGenerator,
        VFileNameParser
      );
  end;
end;

destructor TfrmCacheManager.Destroy;
begin
  FAppClosingNotifier := nil;
  inherited Destroy;
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
  if chkCloseWithStart.Checked then begin
    Self.Close;
  end;
end;

procedure TfrmCacheManager.ProcessCacheConverter;

  function GetCacheFormatFromIndex(const AIndex: Integer): Byte;
  begin
    case AIndex of
      0: Result := c_File_Cache_Id_GMV;
      1: Result := c_File_Cache_Id_SAS;
      2: Result := c_File_Cache_Id_ES;
      3: Result := c_File_Cache_Id_GM;
      4: Result := c_File_Cache_Id_GM_Aux;
      5: Result := c_File_Cache_Id_BDB;
    else
      Result := c_File_Cache_Id_SAS;
    end;
  end;
var
  VProgressInfo: ICacheConverterProgressInfo;
  VCancelNotifierInternal: INotifierOperationInternal;
  VOperationID: Integer;
  VConverterThread: TThreadCacheConverter;
  VCoordConverter: ICoordConverter;
  VSouurce: ITileStorage;
  VTarget: ITileStorage;
  VDestPath: string;
begin
  VProgressInfo := TCacheConverterProgressInfo.Create;

  VCancelNotifierInternal := TNotifierOperation.Create;
  VOperationID := VCancelNotifierInternal.CurrentOperation;

  VCoordConverter := FCoordConverterFactory.GetCoordConverterByCode(CGoogleProjectionEPSG, CTileSplitQuadrate256x256);
  VSouurce :=
    CreateSimpleTileStorage(
      IncludeTrailingPathDelimiter(Trim(edtPath.Text)),
      Trim(edtDefExtention.Text),
      VCoordConverter,
      GetCacheFormatFromIndex(cbbCacheTypes.ItemIndex)
    );
  VDestPath := IncludeTrailingPathDelimiter(Trim(edtDestPath.Text));

  ForceDirectories(VDestPath);
  VTarget :=
    CreateSimpleTileStorage(
      VDestPath,
      Trim(edtDefExtention.Text),
      VCoordConverter,
      GetCacheFormatFromIndex(cbbDestCacheTypes.ItemIndex)
    );

  VConverterThread := TThreadCacheConverter.Create(
    VCancelNotifierInternal,
    VOperationID,
    VSouurce,
    VTarget,
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
    FValueToStringConverterConfig
  );
end;

end.


