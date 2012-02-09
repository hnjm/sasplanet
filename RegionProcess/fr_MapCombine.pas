unit fr_MapCombine;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,
  StdCtrls,
  CheckLst,
  Spin,
  i_MapTypes,
  i_CoordConverterFactory,
  i_VectorItemLonLat,
  i_VectorItmesFactory,
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
    FVectorFactory: IVectorItmesFactory;
    FProjectionFactory: IProjectionInfoFactory;
    FMainMapsConfig: IMainMapsConfig;
    FFullMapsSet: IMapTypeSet;
    FGUIConfigList: IMapTypeGUIConfigList;
    FMapCalibrationList: IMapCalibrationList;
    FPolygLL: ILonLatPolygon;
    procedure UpdatePanelSizes;
  public
    constructor Create(
      AOwner : TComponent;
      AProjectionFactory: IProjectionInfoFactory;
      AVectorFactory: IVectorItmesFactory;
      AMainMapsConfig: IMainMapsConfig;
      AFullMapsSet: IMapTypeSet;
      AGUIConfigList: IMapTypeGUIConfigList;
      AMapCalibrationList: IMapCalibrationList
    ); reintroduce;
    procedure RefreshTranslation; override;
    procedure Init(AZoom: Byte; APolygLL: ILonLatPolygon);
  end;

implementation

uses
  i_GUIDListStatic,
  i_VectorItemProjected,
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
  numd:int64 ;
  Vmt: TMapType;
  VZoom: byte;
  VPolyLL: ILonLatPolygon;
  VProjected: IProjectedPolygon;
  VLine: IProjectedPolygonLine;
  VBounds: TDoubleRect;
  VPixelRect: TRect;
  VTileRect: TRect;
begin
  if cbbMap.ItemIndex >= 0 then begin
    Vmt := TMapType(cbbMap.Items.Objects[cbbMap.ItemIndex]);
  end else begin
    Vmt := nil;
  end;

  if Vmt <> nil then begin
    VZoom := cbbZoom.ItemIndex;
    Vmt.GeoConvert.CheckZoom(VZoom);
    VPolyLL := FPolygLL;
    if VPolyLL <> nil then begin
      VProjected :=
        FVectorFactory.CreateProjectedPolygonByLonLatPolygon(
          FProjectionFactory.GetByConverterAndZoom(Vmt.GeoConvert, VZoom),
          VPolyLL
        );
      if VProjected.Count > 0 then begin
        VLine := VProjected.Item[0];
        VBounds := VLine.Bounds;
        VPixelRect := RectFromDoubleRect(VBounds, rrOutside);
        VTileRect := Vmt.GeoConvert.PixelRect2TileRect(VPixelRect, VZoom);
        numd := (VTileRect.Right - VTileRect.Left);
        numd := numd * (VTileRect.Bottom - VTileRect.Top);
        lblStat.Caption :=
          SAS_STR_filesnum+': '+
          inttostr(VTileRect.Right - VTileRect.Left)+'x'+
          inttostr(VTileRect.Bottom - VTileRect.Top)+
          '('+inttostr(numd)+')' +
          ', '+SAS_STR_Resolution + ' ' +
          inttostr(VPixelRect.Right - VPixelRect.Left)+'x'+
          inttostr(VPixelRect.Bottom - VPixelRect.Top);
      end;
    end;
  end;
end;

constructor TfrMapCombine.Create(
  AOwner : TComponent;
  AProjectionFactory: IProjectionInfoFactory;
  AVectorFactory: IVectorItmesFactory;
  AMainMapsConfig: IMainMapsConfig;
  AFullMapsSet: IMapTypeSet;
  AGUIConfigList: IMapTypeGUIConfigList;
  AMapCalibrationList: IMapCalibrationList
);
begin
  inherited Create(AOwner);
  FProjectionFactory := AProjectionFactory;
  FVectorFactory := AVectorFactory;
  FMainMapsConfig := AMainMapsConfig;
  FFullMapsSet := AFullMapsSet;
  FGUIConfigList := AGUIConfigList;
  FMapCalibrationList := AMapCalibrationList;
  cbbOutputFormat.ItemIndex := 0;
  UpdatePanelSizes;
end;

procedure TfrMapCombine.Init(AZoom: Byte; APolygLL: ILonLatPolygon);
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
