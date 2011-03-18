unit UaddLine;

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
  UResStrings,
  i_MarksSimple,
  u_MarksSimple,
  u_MarksDbGUIHelper,
  fr_MarkDescription,
  t_GeoTypes;

type
  TFaddLine = class(TCommonFormParent)
    lblName: TLabel;
    lblLineColor: TLabel;
    lblWidth: TLabel;
    edtName: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    chkVisible: TCheckBox;
    clrbxLineColor: TColorBox;
    seWidth: TSpinEdit;
    OpenDialog1: TOpenDialog;
    SEtransp: TSpinEdit;
    lblTransp: TLabel;
    ColorDialog1: TColorDialog;
    btnLineColor: TSpeedButton;
    lblCategory: TLabel;
    CBKateg: TComboBox;
    pnlCategory: TPanel;
    pnlName: TPanel;
    pnlDescription: TPanel;
    flwpnlStyle: TFlowPanel;
    pnlBottomButtons: TPanel;
    procedure btnOkClick(Sender: TObject);
    procedure btnLineColorClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    frMarkDescription: TfrMarkDescription;
    FMarkDBGUI: TMarksDbGUIHelper;
    FCategoryList: TList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function EditMark(AMark: IMarkFull; AMarkDBGUI: TMarksDbGUIHelper): IMarkFull;
    procedure RefreshTranslation; override;
  end;

var
  FaddLine: TFaddLine;

implementation

{$R *.dfm}

function TFaddLine.EditMark(AMark: IMarkFull; AMarkDBGUI: TMarksDbGUIHelper): IMarkFull;
var
  VLastUsedCategoryName: string;
  i: Integer;
  VCategory: TCategoryId;
  VId: integer;
  VIndex: Integer;
begin
  FMarkDBGUI := AMarkDBGUI;
  VLastUsedCategoryName:=CBKateg.Text;
  FCategoryList := FMarkDBGUI.MarksDB.CategoryDB.GetCategoriesList;
  try
    FMarkDBGUI.CategoryListToStrings(FCategoryList, CBKateg.Items);
    CBKateg.Sorted:=true;
    CBKateg.Text:=VLastUsedCategoryName;
    edtName.Text:=AMark.name;
    frMarkDescription.Description := AMark.Desc;
    SEtransp.Value:=100-round(AlphaComponent(AMark.Color1)/255*100);
    seWidth.Value:=AMark.Scale1;
    clrbxLineColor.Selected:=WinColor(AMark.Color1);
    chkVisible.Checked:= FMarkDBGUI.MarksDB.MarksDb.GetMarkVisible(AMark);
    VId := AMark.CategoryId;
    for i := 0 to CBKateg.Items.Count - 1 do begin
      VCategory := TCategoryId(CBKateg.Items.Objects[i]);
      if VCategory <> nil then begin
        if VCategory.id = VId then begin
          CBKateg.ItemIndex := i;
          Break;
        end;
      end;
    end;
    if AMark.id < 0 then begin
      Caption:=SAS_STR_AddNewPath;
      btnOk.Caption:=SAS_STR_Add;
    end else begin
      Caption:=SAS_STR_EditPath;
      btnOk.Caption:=SAS_STR_Edit;
    end;
    if ShowModal=mrOk then begin
      VCategory := nil;
      VIndex := CBKateg.ItemIndex;
      if VIndex < 0 then begin
        VIndex:= CBKateg.Items.IndexOf(CBKateg.Text);
      end;
      if VIndex >= 0 then begin
        VCategory := TCategoryId(CBKateg.Items.Objects[VIndex]);
      end;
      if VCategory <> nil then begin
        VId := VCategory.id;
      end else begin
        VId := -1;
      end;
      Result := AMarkDBGUI.MarksDB.MarksDb.Factory.CreateLine(
        edtName.Text,
        chkVisible.Checked,
        VId,
        frMarkDescription.Description,
        AMark.Points,
        SetAlpha(Color32(clrbxLineColor.Selected),round(((100-SEtransp.Value)/100)*256)),
        seWidth.Value,
        AMark
      );
    end else begin
      Result := nil;
    end;
  finally
    FreeAndNil(FCategoryList);
  end;
end;

procedure TFaddLine.FormShow(Sender: TObject);
begin
  frMarkDescription.Parent := pnlDescription;
  edtName.SetFocus;
end;

procedure TFaddLine.RefreshTranslation;
begin
  inherited;
  frMarkDescription.RefreshTranslation;
end;

procedure TFaddLine.btnOkClick(Sender: TObject);
var
  VCategory: TCategoryId;
  VIndex: Integer;
begin

  VCategory := nil;
  VIndex := CBKateg.ItemIndex;
  if VIndex < 0 then begin
    VIndex:= CBKateg.Items.IndexOf(CBKateg.Text);
  end;
  if VIndex >= 0 then begin
    VCategory := TCategoryId(CBKateg.Items.Objects[VIndex]);
  end;
  if VCategory = nil then begin
    VCategory := FMarkDBGUI.AddKategory(CBKateg.Text);
    if VCategory <> nil then begin
      FCategoryList.Add(VCategory);
      FMarkDBGUI.CategoryListToStrings(FCategoryList, CBKateg.Items);
      CBKateg.Text := VCategory.name;
    end;
  end;
  ModalResult:=mrOk;
end;

constructor TFaddLine.Create(AOwner: TComponent);
begin
  inherited;
  frMarkDescription := TfrMarkDescription.Create(nil);
end;

destructor TFaddLine.Destroy;
begin
  FreeAndNil(frMarkDescription);
  inherited;
end;

procedure TFaddLine.btnLineColorClick(Sender: TObject);
begin
 if ColorDialog1.Execute then clrbxLineColor.Selected:=ColorDialog1.Color;
end;

end.
