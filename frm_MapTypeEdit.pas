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

unit frm_MapTypeEdit;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  ComCtrls,
  Spin,
  u_CommonFormAndFrameParents,
  u_MapType,
  u_ResStrings;

type
  TfrmMapTypeEdit = class(TFormWitghLanguageManager)
    EditNameinCache: TEdit;
    EditParSubMenu: TEdit;
    lblUrl: TLabel;
    lblFolder: TLabel;
    lblSubMenu: TLabel;
    CheckBox1: TCheckBox;
    EditHotKey: THotKey;
    btnOk: TButton;
    btnCancel: TButton;
    btnByDefault: TButton;
    btnResetUrl: TButton;
    btnResetFolder: TButton;
    btnResetSubMenu: TButton;
    btnResetHotKey: TButton;
    EditURL: TMemo;
    SESleep: TSpinEdit;
    lblPause: TLabel;
    btnResetPause: TButton;
    CBCacheType: TComboBox;
    lblCacheType: TLabel;
    btnResetCacheType: TButton;
    pnlBottomButtons: TPanel;
    pnlSeparator: TPanel;
    pnlCacheType: TPanel;
    grdpnlHotKey: TGridPanel;
    grdpnlSleep: TGridPanel;
    grdpnlSleepAndKey: TGridPanel;
    pnlParentItem: TPanel;
    pnlCacheName: TPanel;
    pnlUrl: TPanel;
    pnlUrlRight: TPanel;
    lblHotKey: TLabel;
    CheckEnabled: TCheckBox;
    pnlTop: TPanel;
    lblZmpName: TLabel;
    edtZmp: TEdit;
    pnlVersion: TPanel;
    btnResetVersion: TButton;
    edtVersion: TEdit;
    lblVersion: TLabel;
    pnlHeader: TPanel;
    lblHeader: TLabel;
    pnlHeaderReset: TPanel;
    btnResetHeader: TButton;
    mmoHeader: TMemo;
    pnlDownloaderState: TPanel;
    lblDownloaderState: TLabel;
    mmoDownloadState: TMemo;
    procedure btnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnByDefaultClick(Sender: TObject);
    procedure btnResetUrlClick(Sender: TObject);
    procedure btnResetFolderClick(Sender: TObject);
    procedure btnResetSubMenuClick(Sender: TObject);
    procedure btnResetHotKeyClick(Sender: TObject);
    procedure btnResetPauseClick(Sender: TObject);
    procedure btnResetCacheTypeClick(Sender: TObject);
    procedure btnResetVersionClick(Sender: TObject);
    procedure btnResetHeaderClick(Sender: TObject);
  private
    FMapType: TMapType;
  public
    function EditMapModadl(AMapType: TMapType): Boolean;
  end;

implementation

uses
  i_TileDownloaderState,
  u_GlobalState;

{$R *.dfm}

procedure TfrmMapTypeEdit.btnResetHeaderClick(Sender: TObject);
begin
  mmoHeader.Text := FMapType.Zmp.TileDownloadRequestBuilderConfig.RequestHeader;
end;

procedure TfrmMapTypeEdit.btnOkClick(Sender: TObject);
begin
  FmapType.TileDownloadRequestBuilderConfig.LockWrite;
  try
    FmapType.TileDownloadRequestBuilderConfig.UrlBase := EditURL.Text;
    FMapType.TileDownloadRequestBuilderConfig.RequestHeader := mmoHeader.Text;
  finally
    FmapType.TileDownloadRequestBuilderConfig.UnlockWrite;
  end;

  FMapType.GUIConfig.LockWrite;
  try
    FmapType.GUIConfig.ParentSubMenu.Value:=EditParSubMenu.Text;
    FmapType.GUIConfig.HotKey:=EditHotKey.HotKey;
    FMapType.GUIConfig.Enabled:=CheckEnabled.Checked;
    FmapType.GUIConfig.separator:=CheckBox1.Checked;
  finally
    FMapType.GUIConfig.UnlockWrite;
  end;

  FmapType.TileDownloaderConfig.WaitInterval:=SESleep.Value;
  FmapType.StorageConfig.LockWrite;
  try
    FmapType.StorageConfig.NameInCache := EditNameinCache.Text;
    if FMapType.StorageConfig.CacheTypeCode <> 5 then begin
      if CBCacheType.ItemIndex > 0 then begin
        if CBCacheType.ItemIndex = 5 then begin
          FMapType.StorageConfig.CacheTypeCode := CBCacheType.ItemIndex + 1;
        end else begin
          FMapType.StorageConfig.CacheTypeCode := CBCacheType.ItemIndex;
        end;
      end else begin
        FMapType.StorageConfig.CacheTypeCode := 0;
      end;
    end;
  finally
    FmapType.StorageConfig.UnlockWrite;
  end;
  FMapType.VersionConfig.Version := edtVersion.Text;

  ModalResult := mrOk;
end;

procedure TfrmMapTypeEdit.btnResetVersionClick(Sender: TObject);
begin
  edtVersion.Text := FMapType.Zmp.VersionConfig.Version;
end;

procedure TfrmMapTypeEdit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FmapType:=nil;
end;

procedure TfrmMapTypeEdit.btnByDefaultClick(Sender: TObject);
begin
  EditURL.Text := FmapType.Zmp.TileDownloadRequestBuilderConfig.UrlBase;
  mmoHeader.Text := FMapType.Zmp.TileDownloadRequestBuilderConfig.RequestHeader;

  EditNameinCache.Text := FMapType.Zmp.StorageConfig.NameInCache;
  SESleep.Value:=FmapType.Zmp.TileDownloaderConfig.WaitInterval;
  EditHotKey.HotKey:=FmapType.Zmp.GUI.HotKey;
  if FMapType.StorageConfig.CacheTypeCode <> 5 then begin
    if FmapType.Zmp.StorageConfig.CacheTypeCode = 6 then begin
      CBCacheType.ItemIndex := FmapType.Zmp.StorageConfig.CacheTypeCode - 1;
    end else begin
      CBCacheType.ItemIndex := FmapType.Zmp.StorageConfig.CacheTypeCode;
    end;
  end;

  EditParSubMenu.Text:=FmapType.GUIConfig.ParentSubMenu.GetDefaultValue;
  CheckBox1.Checked:=FmapType.Zmp.GUI.Separator;
  CheckEnabled.Checked:=FMapType.Zmp.GUI.Enabled;
  edtVersion.Text := FMapType.Zmp.VersionConfig.Version;
end;

procedure TfrmMapTypeEdit.btnResetUrlClick(Sender: TObject);
begin
 EditURL.Text := FMapType.Zmp.TileDownloadRequestBuilderConfig.UrlBase;
end;

procedure TfrmMapTypeEdit.btnResetFolderClick(Sender: TObject);
begin
  EditNameinCache.Text := FMapType.Zmp.StorageConfig.NameInCache;
end;

procedure TfrmMapTypeEdit.btnResetSubMenuClick(Sender: TObject);
begin
  EditParSubMenu.Text := FmapType.GUIConfig.ParentSubMenu.GetDefaultValue;
end;

procedure TfrmMapTypeEdit.btnResetHotKeyClick(Sender: TObject);
begin
 EditHotKey.HotKey := FMapType.Zmp.GUI.HotKey;
end;

procedure TfrmMapTypeEdit.btnResetPauseClick(Sender: TObject);
begin
  SESleep.Value := FMapType.TileDownloaderConfig.WaitInterval;
end;

procedure TfrmMapTypeEdit.btnResetCacheTypeClick(Sender: TObject);
begin
  if FMapType.StorageConfig.CacheTypeCode <> 5 then begin
    if FmapType.Zmp.StorageConfig.CacheTypeCode = 6 then begin
      CBCacheType.ItemIndex := FmapType.Zmp.StorageConfig.CacheTypeCode - 1;
    end else begin
      CBCacheType.ItemIndex := FmapType.Zmp.StorageConfig.CacheTypeCode;
    end;
  end;
end;

function TfrmMapTypeEdit.EditMapModadl(AMapType: TMapType): Boolean;
var
  VDownloadState: ITileDownloaderStateStatic;
begin
  FMapType := AMapType;

  Caption:=SAS_STR_EditMap+' '+FmapType.GUIConfig.Name.Value;
  edtZmp.Text := AMapType.Zmp.FileName;

  FMapType.TileDownloadRequestBuilderConfig.LockRead;
  try
    EditURL.Text := FMapType.TileDownloadRequestBuilderConfig.UrlBase;
    mmoHeader.Text := FMapType.TileDownloadRequestBuilderConfig.RequestHeader;
  finally
    FMapType.TileDownloadRequestBuilderConfig.UnlockRead;
  end;

  SESleep.Value:=FMapType.TileDownloaderConfig.WaitInterval;
  EditParSubMenu.Text := FMapType.GUIConfig.ParentSubMenu.Value;
  EditHotKey.HotKey:=FMapType.GUIConfig.HotKey;

  FMapType.StorageConfig.LockRead;
  try
    EditNameinCache.Text := FMapType.StorageConfig.NameInCache;
    if FMapType.StorageConfig.CacheTypeCode <> 5 then begin
      pnlCacheType.Visible := True;
      pnlCacheType.Enabled := True;
      if FMapType.StorageConfig.CacheTypeCode = 6 then begin
        CBCacheType.ItemIndex := FMapType.StorageConfig.CacheTypeCode - 1;
      end else begin
        CBCacheType.ItemIndex := FMapType.StorageConfig.CacheTypeCode;
      end;
    end else begin
      pnlCacheType.Visible := False;
      pnlCacheType.Enabled := False;
    end;
  finally
    FMapType.StorageConfig.UnlockRead;
  end;
  CheckBox1.Checked:=FMapType.GUIConfig.separator;
  CheckEnabled.Checked:=FMapType.GUIConfig.Enabled;
  edtVersion.Text := FMapType.VersionConfig.Version;
  pnlHeader.Visible := GState.GlobalAppConfig.IsShowDebugInfo;
  VDownloadState := FMapType.TileDownloadSubsystem.State.GetStatic;
  if VDownloadState.Enabled then begin
    mmoDownloadState.Text := SAS_STR_Yes;
  end else begin
    mmoDownloadState.Text := VDownloadState.DisableReason;
  end;

  Result := ShowModal = mrOk;
end;

end.
