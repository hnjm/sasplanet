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
  GR32,
  i_LanguageManager,
  i_MapTypeSet,
  i_CoordConverterFactory,
  i_CoordConverterList,
  i_GeometryLonLat,
  i_GeometryProjectedFactory,
  i_ActiveMapsConfig,
  i_MapTypeGUIConfigList,
  i_MapCalibration,
  i_UseTilePrevZoomConfig,
  i_GlobalViewMainConfig,
  i_RegionProcessParamsFrame,
  i_ProjectionInfo,
  i_BitmapLayerProvider,
  i_Bitmap32StaticFactory,
  u_MapType,
  fr_MapSelect,
  u_CommonFormAndFrameParents;

type
  IRegionProcessParamsFrameMapCombine = interface(IRegionProcessParamsFrameBase)
    ['{6771DEDD-F33C-4152-B4AB-47E6A0B032E1}']
    function GetUseMarks: Boolean;
    property UseMarks: Boolean read GetUseMarks;

    function GetUseRecolor: Boolean;
    property UseRecolor: Boolean read GetUseRecolor;

    function GetSplitCount: TPoint;
    property SplitCount: TPoint read GetSplitCount;

    function GetBGColor: TColor32;
    property BGColor: TColor32 read GetBGColor;
  end;

  IRegionProcessParamsFrameMapCombineJpg = interface(IRegionProcessParamsFrameBase)
    ['{C9A0712B-4456-4F34-8A06-9BA57F21D40A}']
    function GetQuality: Integer;
    property Quality: Integer read GetQuality;

    function GetIsSaveGeoRefInfoToExif: Boolean;
    property IsSaveGeoRefInfoToExif: Boolean read GetIsSaveGeoRefInfoToExif;
  end;

  IRegionProcessParamsFrameMapCombineWithAlfa = interface(IRegionProcessParamsFrameBase)
    ['{45043DE9-9950-40C9-92E2-0D28FEC341C7}']
    function GetIsSaveAlfa: Boolean;
    property IsSaveAlfa: Boolean read GetIsSaveAlfa;
  end;

type
  TfrMapCombine = class(
      TFrame,
      IRegionProcessParamsFrameBase,
      IRegionProcessParamsFrameImageProvider,
      IRegionProcessParamsFrameMapCalibrationList,
      IRegionProcessParamsFrameTargetProjection,
      IRegionProcessParamsFrameTargetPath,
      IRegionProcessParamsFrameMapCombine,
      IRegionProcessParamsFrameMapCombineJpg,
      IRegionProcessParamsFrameMapCombineWithAlfa
    )
    pnlTargetFile: TPanel;
    lblTargetFile: TLabel;
    edtTargetFile: TEdit;
    btnSelectTargetFile: TButton;
    dlgSaveTargetFile: TSaveDialog;
    pnlSplit: TPanel;
    grpSplit: TGroupBox;
    lblSplitHor: TLabel;
    lblSplitVert: TLabel;
    seSplitHor: TSpinEdit;
    seSplitVert: TSpinEdit;
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
    chkPngWithAlpha: TCheckBox;
    pnlProjection: TPanel;
    lblProjection: TLabel;
    cbbProjection: TComboBox;
    pnlMapSelect: TPanel;
    pnlZoom: TPanel;
    Labelzoom: TLabel;
    cbbZoom: TComboBox;
    pnlMapFrame: TPanel;
    lblMapCaption: TLabel;
    pnlLayerFrame: TPanel;
    lblLayerCaption: TLabel;
    chkSaveGeoRefInfoToJpegExif: TCheckBox;
    procedure cbbZoomChange(Sender: TObject);
    procedure btnSelectTargetFileClick(Sender: TObject);
  private
    FVectorGeometryProjectedFactory: IGeometryProjectedFactory;
    FBitmapFactory: IBitmap32StaticFactory;
    FProjectionFactory: IProjectionInfoFactory;
    FCoordConverterList: ICoordConverterList;
    FMainMapsConfig: IMainMapsConfig;
    FFullMapsSet: IMapTypeSet;
    FGUIConfigList: IMapTypeGUIConfigList;
    FMapCalibrationList: IMapCalibrationList;
    FUseTilePrevZoomConfig: IUseTilePrevZoomConfig;
    FPolygLL: IGeometryLonLatMultiPolygon;
    FViewConfig: IGlobalViewMainConfig;
    FUseQuality: Boolean;
    FUseExif: Boolean;
    FUseAlfa: Boolean;
    FDefaultExt: string;
    FFormatName: string;
    FfrMapSelect: TfrMapSelect;
    FfrLayerSelect: TfrMapSelect;
    procedure UpdateProjectionsList(Sender: TObject);
  private
    procedure Init(
      const AZoom: byte;
      const APolygon: IGeometryLonLatMultiPolygon
    );
    function Validate: Boolean;
  private
    function GetProvider: IBitmapLayerProvider;
    function GetPath: string;
    function GetProjection: IProjectionInfo;
    function GetMapCalibrationList: IMapCalibrationList;
  private
    function GetUseMarks: Boolean;
    function GetUseRecolor: Boolean;
    function GetSplitCount: TPoint;
    function GetQuality: Integer;
    function GetIsSaveGeoRefInfoToExif: Boolean;
    function GetIsSaveAlfa: Boolean;
    function GetBGColor: TColor32;
    function GetAllowWrite(AMapType: TMapType): boolean;
  public
    constructor Create(
      const ALanguageManager: ILanguageManager;
      const AProjectionFactory: IProjectionInfoFactory;
      const ACoordConverterList: ICoordConverterList;
      const AVectorGeometryProjectedFactory: IGeometryProjectedFactory;
      const ABitmapFactory: IBitmap32StaticFactory;
      const AMainMapsConfig: IMainMapsConfig;
      const AFullMapsSet: IMapTypeSet;
      const AGUIConfigList: IMapTypeGUIConfigList;
      const AViewConfig: IGlobalViewMainConfig;
      const AUseTilePrevZoomConfig: IUseTilePrevZoomConfig;
      const AMapCalibrationList: IMapCalibrationList;
      const AUseQuality: Boolean;
      const AUseExif: Boolean;
      const AUseAlfa: Boolean;
      const ADefaultExt: string;
      const AFormatName: string
    ); reintroduce;
    procedure RefreshTranslation; override;
    destructor Destroy; override;
  end;

implementation

uses
  gnugettext,
  t_GeoTypes,
  i_MapTypes,
  i_MapVersionRequest,
  i_InterfaceListSimple,
  i_GeometryProjected,
  i_CoordConverter,
  u_InterfaceListSimple,
  u_GeoFunc,
  u_BitmapLayerProviderMapWithLayer,
  u_MapCalibrationListBasic,
  u_ResStrings;

{$R *.dfm}

{ TfrMapCombine }

constructor TfrMapCombine.Create(
  const ALanguageManager: ILanguageManager;
  const AProjectionFactory: IProjectionInfoFactory;
  const ACoordConverterList: ICoordConverterList;
  const AVectorGeometryProjectedFactory: IGeometryProjectedFactory;
  const ABitmapFactory: IBitmap32StaticFactory;
  const AMainMapsConfig: IMainMapsConfig;
  const AFullMapsSet: IMapTypeSet;
  const AGUIConfigList: IMapTypeGUIConfigList;
  const AViewConfig: IGlobalViewMainConfig;
  const AUseTilePrevZoomConfig: IUseTilePrevZoomConfig;
  const AMapCalibrationList: IMapCalibrationList;
  const AUseQuality: Boolean;
  const AUseExif: Boolean;
  const AUseAlfa: Boolean;
  const ADefaultExt: string;
  const AFormatName: string
);
begin
  inherited Create(ALanguageManager);
  FProjectionFactory := AProjectionFactory;
  FCoordConverterList := ACoordConverterList;
  FVectorGeometryProjectedFactory := AVectorGeometryProjectedFactory;
  FBitmapFactory := ABitmapFactory;
  FMainMapsConfig := AMainMapsConfig;
  FFullMapsSet := AFullMapsSet;
  FGUIConfigList := AGUIConfigList;
  FMapCalibrationList := AMapCalibrationList;
  FViewConfig := AViewConfig;
  FUseTilePrevZoomConfig := AUseTilePrevZoomConfig;
  FUseQuality := AUseQuality;
  FUseExif := AUseExif;
  FUseAlfa := AUseAlfa;
  FDefaultExt := ADefaultExt;
  FFormatName := AFormatName;
  chkPngWithAlpha.Visible := FUseAlfa;
  flwpnlJpegQuality.Visible := FUseQuality;
  chkSaveGeoRefInfoToJpegExif.Visible := FUseExif;
  FfrMapSelect :=
    TfrMapSelect.Create(
      ALanguageManager,
      AMainMapsConfig,
      AGUIConfigList,
      AFullMapsSet,
      mfMaps,    // show Maps
      True,      // add -NO- to combobox
      False,     // show disabled maps
      GetAllowWrite
    );
  FfrLayerSelect :=
    TfrMapSelect.Create(
      ALanguageManager,
      AMainMapsConfig,
      AGUIConfigList,
      AFullMapsSet,
      mfLayers,  // show Layers
      True,      // add -NO- to combobox
      False,     // show disabled maps
      GetAllowWrite
    );
  UpdateProjectionsList(Self);
  FfrMapSelect.OnMapChange := Self.UpdateProjectionsList;
  FfrLayerSelect.OnMapChange := Self.UpdateProjectionsList;
end;

destructor TfrMapCombine.Destroy;
begin
  FreeAndNil(FfrMapSelect);
  FreeAndNil(FfrLayerSelect);
  inherited;
end;

function TfrMapCombine.GetAllowWrite(AMapType: TMapType): boolean;
begin
  Result := AMapType.IsBitmapTiles;
end;

procedure TfrMapCombine.btnSelectTargetFileClick(Sender: TObject);
begin
  dlgSaveTargetFile.DefaultExt := FDefaultExt;
  dlgSaveTargetFile.Filter := _(FFormatName) + ' | *.' + FDefaultExt;
  if dlgSaveTargetFile.Execute then begin
    edtTargetFile.Text := dlgSaveTargetFile.FileName;
  end;
end;

procedure TfrMapCombine.cbbZoomChange(Sender: TObject);
var
  numd: int64 ;
  Vmt: TMapType;
  VZoom: byte;
  VPolyLL: IGeometryLonLatMultiPolygon;
  VProjected: IGeometryProjectedMultiPolygon;
  VLine: IGeometryProjectedPolygon;
  VBounds: TDoubleRect;
  VPixelRect: TRect;
  VTileRect: TRect;
begin
  Vmt := FfrMapSelect.GetSelectedMapType;
  if (Vmt = nil) then Vmt := FfrLayerSelect.GetSelectedMapType; //calc for layer if map is not selected
  if Vmt <> nil then begin
    VZoom := cbbZoom.ItemIndex;
    Vmt.GeoConvert.CheckZoom(VZoom);
    VPolyLL := FPolygLL;
    if VPolyLL <> nil then begin
      VProjected :=
        FVectorGeometryProjectedFactory.CreateProjectedPolygonByLonLatPolygon(
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
          SAS_STR_filesnum + ': ' +
          inttostr(VTileRect.Right - VTileRect.Left) + 'x' +
          inttostr(VTileRect.Bottom - VTileRect.Top) +
          '('+inttostr(numd)+')' +
          ', '+SAS_STR_Resolution + ' ' +
          inttostr(VPixelRect.Right - VPixelRect.Left) + 'x' +
          inttostr(VPixelRect.Bottom - VPixelRect.Top);
      end;
    end;
  end;
end;

function TfrMapCombine.GetBGColor: TColor32;
var
  VMap: TMapType;
begin
  VMap := FfrMapSelect.GetSelectedMapType;
  if VMap = nil then begin
    Result := SetAlpha(FViewConfig.BackGroundColor, 0);
  end else begin
    Result := SetAlpha(FViewConfig.BackGroundColor, 255);
  end;
end;

function TfrMapCombine.GetIsSaveAlfa: Boolean;
begin
  Result := chkPngWithAlpha.Checked;
end;

function TfrMapCombine.GetMapCalibrationList: IMapCalibrationList;
var
  i: Integer;
  VList: IInterfaceListSimple;
begin
  VList := TInterfaceListSimple.Create;
  for i := 0 to chklstPrTypes.Items.Count - 1 do begin
    if chklstPrTypes.Checked[i] then begin
      VList.Add(IMapCalibration(Pointer(chklstPrTypes.Items.Objects[i])));
    end;
  end;
  Result := TMapCalibrationListByInterfaceList.Create(VList.MakeStaticAndClear);
end;

function TfrMapCombine.GetPath: string;
begin
  Result := edtTargetFile.Text;
end;

function TfrMapCombine.GetProjection: IProjectionInfo;
var
  VMap: TMapType;
  VLayer: TMapType;
  VMainMapType: TMapType;
  VZoom: Byte;
  VGeoConverter: ICoordConverter;
  VIndex: Integer;
begin
  Result := nil;
  VGeoConverter := nil;
  VIndex := cbbProjection.ItemIndex;
  if VIndex < 0 then begin
    VIndex := 0;
  end;
  if VIndex >= 2 then begin
    VIndex := VIndex - 2;
    if VIndex < FCoordConverterList.Count then begin
      VGeoConverter := FCoordConverterList.Items[VIndex];
    end;
    VIndex := 0;
  end;
  if VGeoConverter = nil then begin
    VMainMapType := nil;
    VMap := FfrMapSelect.GetSelectedMapType;
    VLayer := FfrLayerSelect.GetSelectedMapType;
    if VIndex = 0 then begin
      if VMap <> nil then begin
        VMainMapType := VMap;
      end else if VLayer <> nil then begin
        VMainMapType := VLayer;
      end;
    end else begin
      if VLayer <> nil then begin
        VMainMapType := VLayer;
      end else if VMap <> nil then begin
        VMainMapType := VMap;
      end;
    end;
    if VMainMapType <> nil then begin
      VGeoConverter := VMainMapType.GeoConvert;
    end;
  end;
  VZoom := cbbZoom.ItemIndex;
  if VGeoConverter <> nil then begin
    Result := FProjectionFactory.GetByConverterAndZoom(VGeoConverter, VZoom);
  end;
end;

function TfrMapCombine.GetProvider: IBitmapLayerProvider;
var
  VMap: TMapType;
  VMapVersion: IMapVersionRequest;
  VLayer: TMapType;
  VLayerVersion: IMapVersionRequest;
begin
  VMap := FfrMapSelect.GetSelectedMapType;
  if Assigned(VMap) then begin
    VMapVersion := VMap.VersionRequestConfig.GetStatic;
  end else begin
    VMapVersion := nil;
  end;
  VLayer := FfrLayerSelect.GetSelectedMapType;
  if Assigned(VLayer) then begin
    VLayerVersion := VLayer.VersionRequestConfig.GetStatic;
  end else begin
    VLayerVersion := nil;
  end;
  Result :=
    TBitmapLayerProviderMapWithLayer.Create(
      FBitmapFactory,
      VMap,
      VMapVersion,
      VLayer,
      VLayerVersion,
      FUseTilePrevZoomConfig.UsePrevZoomAtMap,
      FUseTilePrevZoomConfig.UsePrevZoomAtLayer
    );
end;

function TfrMapCombine.GetQuality: Integer;
begin
  Result := seJpgQuality.Value;
end;

function TfrMapCombine.GetIsSaveGeoRefInfoToExif: Boolean;
begin
  Result := chkSaveGeoRefInfoToJpegExif.Checked;
end;

function TfrMapCombine.GetSplitCount: TPoint;
begin
  Result.X := seSplitHor.Value;
  Result.Y := seSplitVert.Value;
end;

function TfrMapCombine.GetUseMarks: Boolean;
begin
  Result := chkUseMapMarks.Checked;
end;

function TfrMapCombine.GetUseRecolor: Boolean;
begin
  Result := chkUseRecolor.Checked;
end;

procedure TfrMapCombine.Init(
  const AZoom: byte;
  const APolygon: IGeometryLonLatMultiPolygon
);
var
  i: Integer;
  VMapCalibration: IMapCalibration;
begin
  FPolygLL := APolygon;
  cbbZoom.Items.Clear;
  for i := 1 to 24 do begin
    cbbZoom.Items.Add(inttostr(i));
  end;
  cbbZoom.ItemIndex := AZoom;
  chklstPrTypes.Clear;
  for i := 0 to FMapCalibrationList.Count - 1 do begin
    VMapCalibration := FMapCalibrationList.Get(i);
    chklstPrTypes.AddItem(VMapCalibration.GetName, Pointer(VMapCalibration));
  end;
  cbbZoomChange(nil);
  FfrMapSelect.Show(pnlMapFrame);
  FfrLayerSelect.Show(pnlLayerFrame);
  UpdateProjectionsList(Self);
end;

procedure TfrMapCombine.RefreshTranslation;
var
  VProjectionIndex: Integer;
begin
  VProjectionIndex := cbbProjection.ItemIndex;
  inherited;
  UpdateProjectionsList(Self);
  if VProjectionIndex >= 0 then begin
    cbbProjection.ItemIndex := VProjectionIndex;
  end;
end;

procedure TfrMapCombine.UpdateProjectionsList(Sender: TObject);

  procedure AddProj(const AMapType: IMapType; const ACaption: string);
  var
    I: Integer;
    VProj: string;
    VConverter: ICoordConverter;
  begin
    VProj := ACaption;
    if Assigned(AMapType) then begin
      VConverter := AMapType.MapType.GeoConvert;
      for I := 0 to FCoordConverterList.Count - 1 do begin
        if FCoordConverterList.Items[I].IsSameConverter(VConverter) then begin
          VProj := VProj + ' - ' + FCoordConverterList.Captions[I];
          Break;
        end;
      end;
    end;
    cbbProjection.Items.Add(VProj);
  end;

var
  I: Integer;
  VPrevIndex, VPrevCount: Integer;
begin
  VPrevIndex := cbbProjection.ItemIndex;
  VPrevCount := cbbProjection.Items.Count;

  cbbProjection.Items.Clear;
  AddProj(FfrMapSelect.GetSelectedIMapType, _('Projection of map'));
  AddProj(FfrLayerSelect.GetSelectedIMapType, _('Projection of layer'));

  for I := 0 to FCoordConverterList.Count - 1 do begin
    cbbProjection.Items.Add(FCoordConverterList.Captions[I]);
  end;

  if (VPrevIndex >= 0) and
     (cbbProjection.Items.Count > VPrevIndex) and
     (cbbProjection.Items.Count = VPrevCount)
  then begin
    cbbProjection.ItemIndex := VPrevIndex;
  end else begin
    cbbProjection.ItemIndex := 0;
  end;
end;

function TfrMapCombine.Validate: Boolean;
var
  VPath: string;
  VMsg: string;
begin
  if (FfrMapSelect.GetSelectedMapType = nil) and (FfrLayerSelect.GetSelectedMapType = nil) then begin
    ShowMessage(_('Please select map or layer'));
    Result := False;
    Exit;
  end;
  VPath := GetPath;
  if VPath = '' then begin
    ShowMessage(_('Please, select output file first!'));
    Result := False;
    Exit;
  end;
  if FileExists(VPath) then begin
    VMsg := Format(SAS_MSG_FileExists, [VPath]);
    if (Application.MessageBox(pchar(VMsg), pchar(SAS_MSG_coution), 36) <> IDYES) then begin
      Result := False;
      Exit;
    end;
  end;
  Result := True;
end;

end.
