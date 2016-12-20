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

unit frm_InvisibleBrowser;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Controls,
  Forms,
  OleCtrls,
  SHDocVw_EWB,
  EwbCore,
  EmbeddedWB,
  u_CommonFormAndFrameParents,
  i_LanguageManager,
  i_ProxySettings;

type
  TfrmInvisibleBrowser = class(TFormWitghLanguageManager)
    procedure FormCreate(Sender: TObject);
    procedure OnEmbeddedWBAuthenticate(
      Sender: TCustomEmbeddedWB;
      var hwnd: HWND;
      var szUserName, szPassWord: WideString;
      var Rezult: HRESULT
    );
  private
    FCS: IReadWriteSync;
    FProxyConfig: IProxyConfig;
    FEmbeddedWB: TEmbeddedWB;
  public
    constructor Create(
      const ALanguageManager: ILanguageManager;
      const AProxyConfig: IProxyConfig
    ); reintroduce;
    procedure NavigateAndWait(const AUrl: string);
  end;

implementation

uses
  u_Synchronizer;

{$R *.dfm}

{ TfrmInvisibleBrowser }

constructor TfrmInvisibleBrowser.Create(
  const ALanguageManager: ILanguageManager;
  const AProxyConfig: IProxyConfig
);
begin
  inherited Create(ALanguageManager);
  FProxyConfig := AProxyConfig;
  FCS := GSync.SyncBig.Make(Self.ClassName);

  FEmbeddedWB := TEmbeddedWB.Create(Self);
  FEmbeddedWB.Name := 'InvisibleBrowserEmbeddedWB';
  FEmbeddedWB.Parent := Self;
  FEmbeddedWB.Left := 0;
  FEmbeddedWB.Top := 0;
  FEmbeddedWB.Align := alClient;
  FEmbeddedWB.DisableCtrlShortcuts := 'N';
  FEmbeddedWB.DownloadOptions := [DownloadImages, DownloadVideos];
  FEmbeddedWB.UserInterfaceOptions := [EnablesFormsAutoComplete, EnableThemes];
  FEmbeddedWB.OnAuthenticate := OnEmbeddedWBAuthenticate;
  FEmbeddedWB.About := '';
  FEmbeddedWB.EnableMessageHandler := False;
  FEmbeddedWB.DisableErrors.EnableDDE := False;
  FEmbeddedWB.DisableErrors.fpExceptions := False;
  FEmbeddedWB.DisableErrors.ScriptErrorsSuppressed := False;
  FEmbeddedWB.DialogBoxes.ReplaceCaption := False;
  FEmbeddedWB.DialogBoxes.ReplaceIcon := False;
  FEmbeddedWB.PrintOptions.HTMLHeader.Clear;
  FEmbeddedWB.PrintOptions.HTMLHeader.Add('<HTML></HTML>');
  FEmbeddedWB.PrintOptions.Orientation := poPortrait;
  FEmbeddedWB.UserAgent := 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 2.0.50727)';
end;

procedure TfrmInvisibleBrowser.FormCreate(Sender: TObject);
begin
  FEmbeddedWB.Navigate('about:blank');
end;

procedure TfrmInvisibleBrowser.NavigateAndWait(const AUrl: string);
begin
  FCS.BeginWrite;
  try
    FEmbeddedWB.NavigateWait(AUrl, 10000);
  finally
    FCS.EndWrite;
  end;
end;

procedure TfrmInvisibleBrowser.OnEmbeddedWBAuthenticate(
  Sender: TCustomEmbeddedWB;
  var hwnd: HWND;
  var szUserName,
  szPassWord: WideString;
  var Rezult: HRESULT
);
var
  VUseLogin: Boolean;
  VProxyConfig: IProxyConfigStatic;
begin
  if FProxyConfig <> nil then begin
    VProxyConfig := FProxyConfig.GetStatic;
    VUseLogin := (not VProxyConfig.UseIESettings) and VProxyConfig.UseProxy and VProxyConfig.UseLogin;
    if VUseLogin then begin
      szUserName := VProxyConfig.Login;
      szPassWord := VProxyConfig.Password;
    end;
  end;
end;

end.
