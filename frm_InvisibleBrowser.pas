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
    WebBrowser1: TEmbeddedWB;
    procedure FormCreate(Sender: TObject);
    procedure WebBrowser1Authenticate(Sender: TCustomEmbeddedWB; var hwnd: HWND; var szUserName, szPassWord: WideString; var Rezult: HRESULT);
  private
    FCS: IReadWriteSync;
    FProxyConfig: IProxyConfig;
  public
    constructor Create(
      const ALanguageManager: ILanguageManager;
      const AProxyConfig: IProxyConfig
    ); reintroduce;
    destructor Destroy; override;
    procedure NavigateAndWait(const AUrl: WideString);
  end;

implementation

uses
  u_Synchronizer;

{$R *.dfm}

constructor TfrmInvisibleBrowser.Create(
  const ALanguageManager: ILanguageManager;
  const AProxyConfig: IProxyConfig
);
begin
  inherited Create(ALanguageManager);
  FProxyConfig := AProxyConfig;
  FCS := MakeSyncObj(Self, FALSE);
end;

destructor TfrmInvisibleBrowser.Destroy;
begin
  FCS := nil;
  inherited;
end;

procedure TfrmInvisibleBrowser.FormCreate(Sender: TObject);
begin
  WebBrowser1.Navigate('about:blank');
end;

{ TfrmInvisibleBrowser }

procedure TfrmInvisibleBrowser.NavigateAndWait(const AUrl: WideString);
begin
  FCS.BeginWrite;
  try
    WebBrowser1.NavigateWait(AUrl, 10000);
  finally
    FCS.EndWrite;
  end;
end;

procedure TfrmInvisibleBrowser.WebBrowser1Authenticate(
  Sender: TCustomEmbeddedWB; var hwnd: HWND; var szUserName,
  szPassWord: WideString; var Rezult: HRESULT);
var
  VUseLogin: Boolean;
  VProxyConfig: IProxyConfigStatic;
begin
  if FProxyConfig <> nil then begin
    VProxyConfig := FProxyConfig.GetStatic;
    VUselogin := (not VProxyConfig.UseIESettings) and VProxyConfig.UseProxy and VProxyConfig.UseLogin;
    if VUselogin then begin
      szUserName := VProxyConfig.Login;
      szPassWord := VProxyConfig.Password;
    end;
  end;
end;

end.
