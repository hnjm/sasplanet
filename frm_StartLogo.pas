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

unit frm_StartLogo;

interface

uses
  Forms,
  Classes,
  GR32_Image,
  Controls,
  ExtCtrls,
  StdCtrls,
  i_StartUpLogoConfig,
  u_CommonFormAndFrameParents;

type
  TfrmStartLogo = class(TCommonFormParent)
    tmrLogo: TTimer;
    imgLogo: TImage32;
    lblVersion: TLabel;
    lblWebSite: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tmrLogoTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgLogoClick(Sender: TObject);
  private
    FReadyToHide: Boolean;
    FConfig: IStartUpLogoConfig;
    constructor Create(AOwner: TComponent; AConfig: IStartUpLogoConfig); reintroduce;
  public
    destructor Destroy; override;

    class procedure ShowLogo(AConfig: IStartUpLogoConfig);
    class procedure ReadyToHideLogo;
  end;


implementation

uses
  Types,
  c_SasVersion;

var
  frmStartLogo: TfrmStartLogo;

{$R *.dfm}

constructor TfrmStartLogo.Create(AOwner: TComponent;
  AConfig: IStartUpLogoConfig);
begin
  inherited Create(AOwner);
  FConfig := AConfig;
end;

destructor TfrmStartLogo.Destroy;
begin
  frmStartLogo := nil;
  inherited;
end;

procedure TfrmStartLogo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmStartLogo.FormShow(Sender: TObject);
var
  VBitmapSize: TPoint;
begin
  imgLogo.Bitmap.Assign(FConfig.Logo);
  VBitmapSize.X := imgLogo.Bitmap.Width;
  VBitmapSize.Y := imgLogo.Bitmap.Height;

  if VBitmapSize.X < 100 then begin
    VBitmapSize.X := 480;
  end;
  if VBitmapSize.Y < 100 then begin
    VBitmapSize.Y := 276;
  end;
  imgLogo.Bitmap.SetSize(VBitmapSize.X, VBitmapSize.Y);
  lblVersion.Caption:='v '+SASVersion;
  FReadyToHide := False;
end;

procedure TfrmStartLogo.tmrLogoTimer(Sender: TObject);
begin
  tmrLogo.Enabled:=false;
  Self.Close;
end;

procedure TfrmStartLogo.imgLogoClick(Sender: TObject);
begin
  if FReadyToHide then begin
    tmrLogo.Enabled := false;
    Self.Close;
  end;
end;

class procedure TfrmStartLogo.ReadyToHideLogo;
begin
  if frmStartLogo <> nil then begin
    frmStartLogo.FReadyToHide := True;
    frmStartLogo.tmrLogo.Enabled := True;
  end;
end;

class procedure TfrmStartLogo.ShowLogo(AConfig: IStartUpLogoConfig);
begin
  if AConfig.IsShowLogo then begin
    frmStartLogo := TfrmStartLogo.Create(nil, AConfig);
    frmStartLogo.Show;
    Application.ProcessMessages;
  end;
end;

end.
