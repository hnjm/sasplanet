unit fr_ExportRMapsSQLite;

interface

uses
  Types,
  SysUtils,
  Classes,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  CheckLst,
  ExtCtrls,
  i_LanguageManager,
  i_MapTypeSet,
  i_MapTypeListStatic,
  i_MapTypeListBuilder,
  i_ActiveMapsConfig,
  i_MapTypeGUIConfigList,
  i_VectorItemLonLat,
  i_RegionProcessParamsFrame,
  u_MapType,
  fr_MapSelect,
  u_CommonFormAndFrameParents;

type
  IRegionProcessParamsFrameSQLiteExport = interface(IRegionProcessParamsFrameBase)
    ['{0EB563D9-555A-4BB0-BAA6-B32F0E15E942}']
    function GetForceDropTarget: Boolean;
    property ForceDropTarget: Boolean read GetForceDropTarget;

    function GetReplaceExistingTiles: Boolean;
    property ReplaceExistingTiles: Boolean read GetReplaceExistingTiles;

    function GetMapTypeList: IMapTypeListStatic;
    property MapTypeList: IMapTypeListStatic read GetMapTypeList;
  end;

type
  TfrExportRMapsSQLite = class(
      TFrame,
      IRegionProcessParamsFrameBase,
      IRegionProcessParamsFrameZoomArray,
      IRegionProcessParamsFrameTargetPath,
      IRegionProcessParamsFrameSQLiteExport
    )
    pnlCenter: TPanel;
    lblZooms: TLabel;
    chkAllZooms: TCheckBox;
    chklstZooms: TCheckListBox;
    pnlTop: TPanel;
    lblTargetFile: TLabel;
    edtTargetFile: TEdit;
    btnSelectTargetFile: TButton;
    pnlRight: TPanel;
    pnlMain: TPanel;
    chkReplaceExistingTiles: TCheckBox;
    chkForceDropTarget: TCheckBox;
    lblMap: TLabel;
    dlgSaveSQLite: TSaveDialog;
    pnlMap: TPanel;
    procedure btnSelectTargetFileClick(Sender: TObject);
    procedure chkAllZoomsClick(Sender: TObject);
    procedure chklstZoomsDblClick(Sender: TObject);
    procedure chklstZoomsClick(Sender: TObject);
  private
    FMapTypeListBuilderFactory: IMapTypeListBuilderFactory;
    FMainMapsConfig: IMainMapsConfig;
    FFullMapsSet: IMapTypeSet;
    FGUIConfigList: IMapTypeGUIConfigList;
    FfrMapSelect: TfrMapSelect;
  private
    procedure Init(
      const AZoom: byte;
      const APolygon: ILonLatPolygon
    );
    function Validate: Boolean;
  private
    function GetMapType: TMapType;
    function GetMapTypeList: IMapTypeListStatic;
    function GetZoomArray: TByteDynArray;
    function GetPath: string;
    function GetForceDropTarget: Boolean;
    function GetReplaceExistingTiles: Boolean;
    function GetAllowExport(AMapType: TMapType): boolean;
  public
    constructor Create(
      const ALanguageManager: ILanguageManager;
      const AMapTypeListBuilderFactory: IMapTypeListBuilderFactory;
      const AMainMapsConfig: IMainMapsConfig;
      const AFullMapsSet: IMapTypeSet;
      const AGUIConfigList: IMapTypeGUIConfigList
    ); reintroduce;
    destructor Destroy; override;
  end;

implementation

uses
  gnugettext;
  
{$R *.dfm}

constructor TfrExportRMapsSQLite.Create(
  const ALanguageManager: ILanguageManager;
  const AMapTypeListBuilderFactory: IMapTypeListBuilderFactory;
  const AMainMapsConfig: IMainMapsConfig;
  const AFullMapsSet: IMapTypeSet;
  const AGUIConfigList: IMapTypeGUIConfigList
);
begin
  inherited Create(ALanguageManager);
  FMainMapsConfig := AMainMapsConfig;
  FMapTypeListBuilderFactory := AMapTypeListBuilderFactory;
  FFullMapsSet := AFullMapsSet;
  FGUIConfigList := AGUIConfigList;
  FfrMapSelect :=
    TfrMapSelect.Create(
      ALanguageManager,
      AMainMapsConfig,
      AGUIConfigList,
      AFullMapsSet,
      mfAll, // show maps and layers
      False,  // add -NO- to combobox
      False,  // show disabled map
      GetAllowExport
    );
end;

destructor TfrExportRMapsSQLite.Destroy;
begin
  FreeAndNil(FfrMapSelect);
  inherited;
end;

procedure TfrExportRMapsSQLite.btnSelectTargetFileClick(Sender: TObject);
begin
 if dlgSaveSQLite.Execute then
  edtTargetFile.Text := dlgSaveSQLite.FileName;
end;

function TfrExportRMapsSQLite.GetAllowExport(AMapType: TMapType): boolean;
begin
  Result := AMapType.IsBitmapTiles;
end;

procedure TfrExportRMapsSQLite.chkAllZoomsClick(Sender: TObject);
var
  i: byte;
begin
  if chkAllZooms.state <> cbGrayed then begin
    for i:=0 to chklstZooms.Count-1 do begin
      chklstZooms.Checked[i] := TCheckBox(Sender).Checked;
    end;
  end;
end;


procedure TfrExportRMapsSQLite.chklstZoomsClick(Sender: TObject);
var
  i, VCountChecked: Integer;
begin
  VCountChecked := 0;
  for i := 0 to chklstZooms.Count - 1 do if chklstZooms.Checked[i] = true then inc(VCountChecked);
  if chkAllZooms.state <> cbGrayed then begin
    if (VCountChecked > 0) and (VCountChecked < chklstZooms.Count) then chkAllZooms.state := cbGrayed;
  end else begin
    if VCountChecked = chklstZooms.Count then chkAllZooms.State := cbChecked;
    if VCountChecked = 0 then chkAllZooms.State := cbUnchecked;
  end;
end;



procedure TfrExportRMapsSQLite.chklstZoomsDblClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to chklstZooms.ItemIndex do chklstZooms.Checked[i] := true;
  if chklstZooms.ItemIndex < chklstZooms.count-1 then begin
    for i := chklstZooms.ItemIndex + 1 to chklstZooms.count - 1 do begin
      chklstZooms.Checked[i] := false;
    end;
  end;
  if chklstZooms.ItemIndex = chklstZooms.count-1 then begin
    chkAllZooms.state := cbChecked
  end else begin
    chkAllZooms.state := cbGrayed;
  end;
end;

function TfrExportRMapsSQLite.GetMapType: TMapType;
begin
  Result :=  FfrMapSelect.GetSelectedMapType;
end;

function TfrExportRMapsSQLite.GetMapTypeList: IMapTypeListStatic;
var
  VMaps: IMapTypeListBuilder;
begin
  VMaps := FMapTypeListBuilderFactory.Build;
  VMaps.Add(FFullMapsSet.GetMapTypeByGUID(GetMapType.Zmp.GUID));
  Result := VMaps.MakeAndClear;
end;

function TfrExportRMapsSQLite.GetForceDropTarget: Boolean;
begin
  Result := chkForceDropTarget.Checked;
end;

function TfrExportRMapsSQLite.GetPath: string;
begin
  Result := edtTargetFile.Text;
end;

function TfrExportRMapsSQLite.GetReplaceExistingTiles: Boolean;
begin
  Result := chkReplaceExistingTiles.Checked;
end;

function TfrExportRMapsSQLite.GetZoomArray: TByteDynArray;
var
  i: Integer;
  VCount: Integer;
begin
  Result := nil;
  VCount := 0;
  for i := 0 to 23 do begin
    if chklstZooms.Checked[i] then begin
      SetLength(Result, VCount + 1);
      Result[VCount] := i;
      Inc(VCount);
    end;
  end;
end;

procedure TfrExportRMapsSQLite.Init;
var
  i: integer;
begin
  chklstZooms.Items.Clear;
  for i := 1 to 24 do begin
    chklstZooms.Items.Add(inttostr(i));
  end;
  FfrMapSelect.Show(pnlMap);
end;

function TfrExportRMapsSQLite.Validate: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to chklstZooms.Count - 1 do begin
    if chklstZooms.Checked[i] then begin
      Result := True;
      Break;
    end;
  end;
  if not Result then begin
    ShowMessage(_('Please select at least one zoom'));
  end;
end;

end.
