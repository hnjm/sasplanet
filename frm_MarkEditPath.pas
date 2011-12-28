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

unit frm_MarkEditPath;

interface

uses
  Windows,
  SysUtils,
  Buttons,
  Classes,
  Controls,
  Forms,
  Dialogs,
  Spin,
  StdCtrls,
  ExtCtrls,
  GR32,
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
  TfrmMarkEditPath = class(TFormWitghLanguageManager)
    lblName: TLabel;
    lblLineColor: TLabel;
    lblWidth: TLabel;
    edtName: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    chkVisible: TCheckBox;
    clrbxLineColor: TColorBox;
    seWidth: TSpinEdit;
    SEtransp: TSpinEdit;
    lblTransp: TLabel;
    ColorDialog1: TColorDialog;
    btnLineColor: TSpeedButton;
    pnlCategory: TPanel;
    pnlName: TPanel;
    pnlDescription: TPanel;
    flwpnlStyle: TFlowPanel;
    pnlBottomButtons: TPanel;
    procedure btnOkClick(Sender: TObject);
    procedure btnLineColorClick(Sender: TObject);
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
    function EditMark(AMark: IMarkLine): IMarkLine;
    procedure RefreshTranslation; override;
  end;

implementation

{$R *.dfm}

constructor TfrmMarkEditPath.Create(
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

destructor TfrmMarkEditPath.Destroy;
begin
  FreeAndNil(frMarkDescription);
  FreeAndNil(frMarkCategory);
  inherited;
end;

function TfrmMarkEditPath.EditMark(AMark: IMarkLine): IMarkLine;
begin
  frMarkCategory.Init(AMark.Category);
  try
    edtName.Text:=AMark.name;
    frMarkDescription.Description := AMark.Desc;
    SEtransp.Value:=100-round(AlphaComponent(AMark.LineColor)/255*100);
    seWidth.Value:=AMark.LineWidth;
    clrbxLineColor.Selected:=WinColor(AMark.LineColor);
    chkVisible.Checked:= FMarksDb.GetMarkVisible(AMark);
    if FMarksDb.GetMarkIsNew(AMark) then begin
      Caption:=SAS_STR_AddNewPath;
    end else begin
      Caption:=SAS_STR_EditPath;
    end;
    if ShowModal=mrOk then begin
      Result := FMarksDb.Factory.ModifyLine(
        AMark,
        edtName.Text,
        chkVisible.Checked,
        frMarkCategory.GetCategory,
        frMarkDescription.Description,
        AMark.Points,
        SetAlpha(Color32(clrbxLineColor.Selected),round(((100-SEtransp.Value)/100)*256)),
        seWidth.Value
      );
    end else begin
      Result := nil;
    end;
  finally
    frMarkCategory.Clear;
  end;
end;

procedure TfrmMarkEditPath.FormShow(Sender: TObject);
begin
  frMarkCategory.Parent := pnlCategory;
  frMarkDescription.Parent := pnlDescription;
  edtName.SetFocus;
end;

procedure TfrmMarkEditPath.RefreshTranslation;
begin
  inherited;
  frMarkDescription.RefreshTranslation;
  frMarkCategory.RefreshTranslation;
end;

procedure TfrmMarkEditPath.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmMarkEditPath.btnLineColorClick(Sender: TObject);
begin
 if ColorDialog1.Execute then clrbxLineColor.Selected:=ColorDialog1.Color;
end;

end.
