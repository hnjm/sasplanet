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

unit frm_LonLatRectEdit;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  u_CommonFormAndFrameParents,
  t_GeoTypes,
  fr_LonLat;

type
  TfrmLonLatRectEdit = class(TCommonFormParent)
    btnOk: TButton;
    btnCancel: TButton;
    grpTopLeft: TGroupBox;
    grpBottomRight: TGroupBox;
    pnlBottomButtons: TPanel;
    grdpnlMain: TGridPanel;
    procedure FormShow(Sender: TObject);
  private
    FfrLonLatTopLeft: TfrLonLat;
    FfrLonLatBottomRight: TfrLonLat;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute(var ALonLatRect: TDoubleRect): Boolean;
    procedure RefreshTranslation; override;
  end;

implementation

uses
  u_ResStrings,
  u_GlobalState;

{$R *.dfm}

constructor TfrmLonLatRectEdit.Create(AOwner: TComponent);
begin
  inherited;
  FfrLonLatTopLeft :=
    TfrLonLat.Create(
      nil,
      GState.MainFormConfig.ViewPortState,
      GState.ValueToStringConverterConfig,
      tssTopLeft
    );
  FfrLonLatBottomRight :=
    TfrLonLat.Create(
      nil,
      GState.MainFormConfig.ViewPortState,
      GState.ValueToStringConverterConfig,
      tssBottomRight
    );
end;

destructor TfrmLonLatRectEdit.Destroy;
begin
  FreeAndNil(FfrLonLatTopLeft);
  FreeAndNil(FfrLonLatBottomRight);
  inherited;
end;

function TfrmLonLatRectEdit.Execute(var ALonLatRect: TDoubleRect): Boolean;
begin
  FfrLonLatTopLeft.LonLat := ALonLatRect.TopLeft;
  FfrLonLatBottomRight.LonLat := ALonLatRect.BottomRight;
  Result := ShowModal = mrOK;
  if Result then begin
    ALonLatRect.TopLeft := FfrLonLatTopLeft.LonLat;
    ALonLatRect.BottomRight := FfrLonLatBottomRight.LonLat;
    if (ALonLatRect.Left>ALonLatRect.Right)then begin
      ShowMessage(SAS_ERR_LonLat2);
      result:=false;
    end else if (ALonLatRect.Top < ALonLatRect.Bottom)then begin
      ShowMessage(SAS_ERR_LonLat1);
      result:=false;
    end;
  end;
end;

procedure TfrmLonLatRectEdit.FormShow(Sender: TObject);
begin
  FfrLonLatTopLeft.Parent := grpTopLeft;
  FfrLonLatBottomRight.Parent := grpBottomRight;
end;

procedure TfrmLonLatRectEdit.RefreshTranslation;
begin
  inherited;
  FfrLonLatTopLeft.RefreshTranslation;
  FfrLonLatBottomRight.RefreshTranslation;
end;

end.
