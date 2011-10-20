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

unit frm_MarkEditPoly;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Controls,
  Forms,
  Dialogs,
  Spin,
  StdCtrls,
  ExtCtrls,
  Buttons,
  GR32,
  t_GeoTypes,
  u_CommonFormAndFrameParents,
  i_LanguageManager,
  u_ResStrings,
  i_MarksSimple,
  i_MarkCategory,
  i_MarkCategoryDB,
  i_MarksDb,
  fr_MarkDescription,
  fr_MarkCategorySelectOrAdd;

type
  TfrmMarkEditPoly = class(TFormWitghLanguageManager)
    lblName: TLabel;
    edtName: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    chkVisible: TCheckBox;
    lblLineColor: TLabel;
    lblLineWidth: TLabel;
    clrbxLineColor: TColorBox;
    seLineWidth: TSpinEdit;
    seLineTransp: TSpinEdit;
    lblLineTransp: TLabel;
    btnLineColor: TSpeedButton;
    lblFillColor: TLabel;
    clrbxFillColor: TColorBox;
    seFillTransp: TSpinEdit;
    lblFillTransp: TLabel;
    btnFillColor: TSpeedButton;
    lblLine: TLabel;
    lblFill: TLabel;
    ColorDialog1: TColorDialog;
    lblCategory: TLabel;
    CBKateg: TComboBox;
    pnlBottomButtons: TPanel;
    flwpnlFill: TFlowPanel;
    pnlFill: TPanel;
    pnlLine: TPanel;
    flwpnlLine: TFlowPanel;
    pnlDescription: TPanel;
    pnlCategory: TPanel;
    pnlName: TPanel;
    procedure btnOkClick(Sender: TObject);
    procedure btnLineColorClick(Sender: TObject);
    procedure btnFillColorClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FCategoryDB: IMarkCategoryDB;
    FMarksDb: IMarksDb;
    frMarkDescription: TfrMarkDescription;
    frMarkCategory: TfrMarkCategorySelectOrAdd;
  public
    constructor Create(
      ALanguageManager: ILanguageManager;
      ACategoryDB: IMarkCategoryDB;
      AMarksDb: IMarksDb
    ); reintroduce;
    destructor Destroy; override;
    function EditMark(AMark: IMarkPoly): IMarkPoly;
    procedure RefreshTranslation; override;
  end;

implementation

{$R *.dfm}

constructor TfrmMarkEditPoly.Create(
  ALanguageManager: ILanguageManager;
  ACategoryDB: IMarkCategoryDB;
  AMarksDb: IMarksDb
);
begin
  inherited Create(ALanguageManager);
  FMarksDb := AMarksDb;
  FCategoryDB := ACategoryDB;

  frMarkDescription := TfrMarkDescription.Create(nil);
  frMarkCategory :=
    TfrMarkCategorySelectOrAdd.Create(
      nil,
      FCategoryDB
    );
end;

destructor TfrmMarkEditPoly.Destroy;
begin
  FreeAndNil(frMarkDescription);
  FreeAndNil(frMarkCategory);
  inherited;
end;

function TfrmMarkEditPoly.EditMark(AMark: IMarkPoly): IMarkPoly;
begin
  frMarkCategory.Init(AMark.Category);
  try
    edtName.Text:=AMark.name;
    frMarkDescription.Description:=AMark.Desc;
    seLineTransp.Value:=100-round(AlphaComponent(AMark.BorderColor)/255*100);
    seFillTransp.Value:=100-round(AlphaComponent(AMark.FillColor)/255*100);
    seLineWidth.Value:=AMark.LineWidth;
    clrbxLineColor.Selected:=WinColor(AMark.BorderColor);
    clrbxFillColor.Selected:=WinColor(AMark.FillColor);
    chkVisible.Checked:= FMarksDb.GetMarkVisible(AMark);
    if FMarksDb.GetMarkIsNew(AMark) then begin
      Caption:=SAS_STR_AddNewPoly;
    end else begin
      Caption:=SAS_STR_EditPoly;
    end;
    if ShowModal=mrOk then begin
      Result := FMarksDb.Factory.ModifyPoly(
        AMark,
        edtName.Text,
        chkVisible.Checked,
        frMarkCategory.GetCategory,
        frMarkDescription.Description,
        AMark.Points,
        SetAlpha(Color32(clrbxLineColor.Selected),round(((100-seLineTransp.Value)/100)*256)),
        SetAlpha(Color32(clrbxFillColor.Selected),round(((100-seFillTransp.Value)/100)*256)),
        seLineWidth.Value
      )
    end else begin
      Result := nil;
    end;
  finally
    frMarkCategory.Clear;
  end;
end;

procedure TfrmMarkEditPoly.FormShow(Sender: TObject);
begin
  frMarkCategory.Parent := pnlCategory;
  frMarkDescription.Parent := pnlDescription;
  edtName.SetFocus;
end;

procedure TfrmMarkEditPoly.RefreshTranslation;
begin
  inherited;
  frMarkDescription.RefreshTranslation;
  frMarkCategory.RefreshTranslation;
end;

procedure TfrmMarkEditPoly.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmMarkEditPoly.btnLineColorClick(Sender: TObject);
begin
 if ColorDialog1.Execute then clrbxLineColor.Selected:=ColorDialog1.Color;
end;

procedure TfrmMarkEditPoly.btnFillColorClick(Sender: TObject);
begin
 if ColorDialog1.Execute then clrbxFillColor.Selected:=ColorDialog1.Color;
end;

end.
