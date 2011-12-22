unit fr_MapCombine;

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
  ExtCtrls,
  StdCtrls,
  CheckLst,
  Spin,
  i_MapTypes,
  i_ActiveMapsConfig,
  i_MapTypeGUIConfigList,
  i_MapCalibration,
  u_CommonFormAndFrameParents,
  t_GeoTypes;

type
  TfrMapCombine = class(TFrame)
    pnlTop: TPanel;
    pnlTargetFile: TPanel;
    lblTargetFile: TLabel;
    edtTargetFile: TEdit;
    btnSelectTargetFile: TButton;
    pnlOutputFormat: TPanel;
    cbbOutputFormat: TComboBox;
    lblOutputFormat: TLabel;
    dlgSaveTargetFile: TSaveDialog;
    pnlSplit: TPanel;
    grpSplit: TGroupBox;
    lblSplitHor: TLabel;
    lblSplitVert: TLabel;
    seSplitHor: TSpinEdit;
    seSplitVert: TSpinEdit;
    pnlCenter: TPanel;
    pnlMapSource: TPanel;
    lblMap: TLabel;
    cbbMap: TComboBox;
    pnlZoom: TPanel;
    lblZoom: TLabel;
    cbbZoom: TComboBox;
    lblHybr: TLabel;
    cbbHybr: TComboBox;
    pnlOptions: TPanel;
    chkUseMapMarks: TCheckBox;
    chkUseRecolor: TCheckBox;
    flwpnlJpegQuality: TFlowPanel;
    lblJpgQulity: TLabel;
    pnlPrTypes: TPanel;
    lblPrTypes: TLabel;
    chklstPrTypes: TCheckListBox;
    seJpgQuality: TSpinEdit;
    lblStat: TLabel;
    pnlBottom: TPanel;
    pnlCenterMain: TPanel;
    chkPngWithAlpha: TCheckBox;
    procedure cbbOutputFormatChange(Sender: TObject);
    procedure cbbZoomChange(Sender: TObject);
    procedure btnSelectTargetFileClick(Sender: TObject);
  private
    FMainMapsConfig: IMainMapsConfig;
    FFullMapsSet: IMapTypeSet;
    FGUIConfigList: IMapTypeGUIConfigList;
    FMapCalibrationList: IMapCalibrationList;
    FPolygLL: TArrayOfDoublePoint;
    procedure UpdatePanelSizes;
  public
    constructor Create(
      AOwner : TComponent;
      AMainMapsConfig: IMainMapsConfig;
      AFullMapsSet: IMapTypeSet;
      AGUIConfigList: IMapTypeGUIConfigList;
      AMapCalibrationList: IMapCalibrationList
    ); reintroduce;
    procedure RefreshTranslation; override;
    procedure Init(AZoom: Byte; APolygLL: TArrayOfDoublePoint);
  end;

implementation

uses
  i_GUIDListStatic,
  u_GeoFun,
  u_ResStrings,
  u_MapType;

{$R *.dfm}

{ TfrMapCombine }

procedure TfrMapCombine.btnSelectTargetFileClick(Sender: TObject);
begin
  if dlgSaveTargetFile.Execute then begin
    edtTargetFile.Text := dlgSaveTargetFile.FileName;
  end;
end;

procedure TfrMapCombine.cbbOutputFormatChange(Sender: TObject);
var
  VNewExt: string;
  VFileName: string;
begin
  case cbbOutputFormat.ItemIndex of
    0: VNewExt := 'ecw';
    1: VNewExt := 'bmp';
    2: VNewExt := 'kmz';
    3: VNewExt := 'jpg';
    4: VNewExt := 'jp2';
    5: VNewExt := 'png';
  else
    VNewExt := '';
  end;
  VFileName := edtTargetFile.Text;
  if VFileName <> '' then begin
    VFileName := ChangeFileExt(VFileName, '.' + VNewExt);
  end;
  edtTargetFile.Text := VFileName;
  dlgSaveTargetFile.DefaultExt := VNewExt;
  dlgSaveTargetFile.Filter := cbbOutputFormat.Items[cbbOutputFormat.ItemIndex] + ' | *.' + VNewExt;
end;

procedure TfrMapCombine.cbbZoomChange(Sender: TObject);
var
  polyg:TArrayOfPoint;
  min,max:TPoint;
  numd:int64 ;
  Vmt: TMapType;
  VZoom: byte;
  VPolyLL: TArrayOfDoublePoint;
begin
  if cbbMap.ItemIndex >= 0 then begin
    Vmt := TMapType(cbbMap.Items.Objects[cbbMap.ItemIndex]);
    VZoom := cbbZoom.ItemIndex;
    VPolyLL := copy(FPolygLL);
    Vmt.GeoConvert.CheckZoom(VZoom);
    Vmt.GeoConvert.CheckLonLatArray(VPolyLL);
    polyg := Vmt.GeoConvert.LonLatArray2PixelArray(VPolyLL, VZoom);
    numd:=GetDwnlNum(min,max,polyg,true);
    lblStat.Caption:=SAS_STR_filesnum+': '+inttostr((max.x-min.x)div 256+1)+'x'
                    +inttostr((max.y-min.y)div 256+1)+'('+inttostr(numd)+')';
    GetMinMax(min,max,polyg,false);
    lblStat.Caption:=lblStat.Caption+', '+SAS_STR_Resolution+' '+inttostr(max.x-min.x)+'x'
                  +inttostr(max.y-min.y);
  end;
end;

constructor TfrMapCombine.Create(
  AOwner : TComponent;
  AMainMapsConfig: IMainMapsConfig;
  AFullMapsSet: IMapTypeSet;
  AGUIConfigList: IMapTypeGUIConfigList;
  AMapCalibrationList: IMapCalibrationList
);
begin
  inherited Create(AOwner);
  FMainMapsConfig := AMainMapsConfig;
  FFullMapsSet := AFullMapsSet;
  FGUIConfigList := AGUIConfigList;
  FMapCalibrationList := AMapCalibrationList;
  cbbOutputFormat.ItemIndex := 0;
  UpdatePanelSizes;
end;

procedure TfrMapCombine.Init(AZoom: Byte; APolygLL: TArrayOfDoublePoint);
var
  i: Integer;
  VMapType: TMapType;
  VActiveMapGUID: TGUID;
  VAddedIndex: Integer;
  VMapCalibration: IMapCalibration;
  VGUIDList: IGUIDListStatic;
  VGUID: TGUID;
begin
  FPolygLL := APolygLL;
  cbbZoom.Items.Clear;
  for i:=1 to 24 do begin
    cbbZoom.Items.Add(inttostr(i));
  end;
  cbbZoom.ItemIndex := AZoom;

  VActiveMapGUID := FMainMapsConfig.GetActiveMap.GetSelectedGUID;
  cbbMap.Items.Clear;
  cbbHybr.Items.Clear;
  cbbMap.Items.Add(SAS_STR_No);
  cbbHybr.Items.Add(SAS_STR_No);
  VGUIDList := FGUIConfigList.OrderedMapGUIDList;
  For i := 0 to VGUIDList.Count-1 do begin
    VGUID := VGUIDList.Items[i];
    VMapType := FFullMapsSet.GetMapTypeByGUID(VGUID).MapType;
    if (VMapType.Abilities.IsUseStick)and(VMapType.IsBitmapTiles)and(VMapType.GUIConfig.Enabled) then begin
      if not VMapType.Abilities.IsLayer then begin
        VAddedIndex := cbbMap.Items.AddObject(VMapType.GUIConfig.Name.Value, VMapType);
        if IsEqualGUID(VMapType.Zmp.GUID, VActiveMapGUID) then begin
          cbbMap.ItemIndex:=VAddedIndex;
        end;
      end else begin
        VAddedIndex := cbbHybr.Items.AddObject(VMapType.GUIConfig.Name.Value, VMapType);
        if (cbbHybr.ItemIndex=-1) then begin
          if FMainMapsConfig.GetActiveLayersSet.IsGUIDSelected(VGUID) then begin
            cbbHybr.ItemIndex:=VAddedIndex;
          end;
        end;
      end;
    end;
  end;
  if (cbbMap.Items.Count > 0) and (cbbMap.ItemIndex < 0) then begin
    cbbMap.ItemIndex := 0;
  end;
  if (cbbHybr.Items.Count > 0) and (cbbHybr.ItemIndex < 0) then begin
    cbbHybr.ItemIndex := 0;
  end;

  chklstPrTypes.Clear;
  for i := 0 to FMapCalibrationList.Count - 1 do begin
    VMapCalibration := FMapCalibrationList.Get(i);
    chklstPrTypes.AddItem(VMapCalibration.GetName, Pointer(VMapCalibration));
  end;
  cbbOutputFormatChange(cbbOutputFormat);
  cbbZoomChange(nil);
  UpdatePanelSizes;
end;

procedure TfrMapCombine.RefreshTranslation;
var
  i: Integer;
begin
  i := cbbOutputFormat.ItemIndex;
  inherited;
  cbbOutputFormat.ItemIndex := i;
  UpdatePanelSizes;
end;

procedure TfrMapCombine.UpdatePanelSizes;
begin
  pnlCenter.ClientHeight := pnlMapSource.Height;
end;

end.
