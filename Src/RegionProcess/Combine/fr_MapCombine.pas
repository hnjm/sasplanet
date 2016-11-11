{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2014, SAS.Planet development team.                      *}
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
{* http://sasgis.org                                                          *}
{* info@sasgis.org                                                            *}
{******************************************************************************}

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
  t_Bitmap32,
  t_CommonTypes,
  t_MapCombineOptions,
  i_LanguageManager,
  i_MapType,
  i_MapTypeListChangeable,
  i_ProjectionSetList,
  i_GeometryLonLat,
  i_GeometryProjectedFactory,
  i_MapCalibration,
  i_UseTilePrevZoomConfig,
  i_GlobalViewMainConfig,
  i_RegionProcessParamsFrame,
  i_Projection,
  i_BitmapLayerProvider,
  i_Bitmap32BufferFactory,
  fr_MapSelect,
  fr_MapCombineOptions,
  u_CommonFormAndFrameParents;

type
  IRegionProcessParamsFrameMapCombine = interface(IRegionProcessParamsFrameBase)
    ['{6771DEDD-F33C-4152-B4AB-47E6A0B032E1}']
    function GetUseMarks: Boolean;
    property UseMarks: Boolean read GetUseMarks;

    function GetUseGrids: Boolean;
    property UseGrids: Boolean read GetUseGrids;

    function GetUseFillingMap: Boolean;
    property UseFillingMap: Boolean read GetUseFillingMap;

    function GetUseRecolor: Boolean;
    property UseRecolor: Boolean read GetUseRecolor;

    function GetSplitCount: TPoint;
    property SplitCount: TPoint read GetSplitCount;

    function GetSkipExistingFiles: Boolean;
    property SkipExistingFiles: Boolean read GetSkipExistingFiles;

    function GetBGColor: TColor32;
    property BGColor: TColor32 read GetBGColor;

    function GetCustomOptions: IMapCombineCustomOptions;
    property CustomOptions: IMapCombineCustomOptions read GetCustomOptions;
  end;

type
  TfrMapCombine = class(
      TFrame,
      IRegionProcessParamsFrameBase,
      IRegionProcessParamsFrameImageProvider,
      IRegionProcessParamsFrameMapCalibrationList,
      IRegionProcessParamsFrameTargetProjection,
      IRegionProcessParamsFrameTargetPath,
      IRegionProcessParamsFrameMapCombine
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
    pnlPrTypes: TPanel;
    lblPrTypes: TLabel;
    chklstPrTypes: TCheckListBox;
    lblStat: TLabel;
    pnlBottom: TPanel;
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
    chkUseMapGrids: TCheckBox;
    pnlMaps: TPanel;
    chkAddVisibleLayers: TCheckBox;
    chkUseFillingMap: TCheckBox;
    pnlCustomOpt: TPanel;
    chkSkipExistingFiles: TCheckBox;
    procedure cbbZoomChange(Sender: TObject);
    procedure btnSelectTargetFileClick(Sender: TObject);
    procedure chkAddVisibleLayersClick(Sender: TObject);
  private
    FVectorGeometryProjectedFactory: IGeometryProjectedFactory;
    FBitmapFactory: IBitmap32StaticFactory;
    FProjectionSetList: IProjectionSetList;
    FActiveMapsList: IMapTypeListChangeable;
    FMapCalibrationList: IMapCalibrationList;
    FUseTilePrevZoomConfig: IUseTilePrevZoomConfig;
    FPolygLL: IGeometryLonLatPolygon;
    FViewConfig: IGlobalViewMainConfig;
    FDefaultExt: string;
    FFormatName: string;
    FfrMapSelect: TfrMapSelect;
    FfrLayerSelect: TfrMapSelect;
    FfrMapCombineOptions: TfrMapCombineCustomOptions;
    FMinPartSize: TPoint;
    FMaxPartSize: TPoint;
    FCombinePathStringTypeSupport: TStringTypeSupport;
    procedure UpdateProjectionsList(Sender: TObject);
  private
    procedure Init(
      const AZoom: byte;
      const APolygon: IGeometryLonLatPolygon
    );
    function Validate: Boolean;
  private
    function GetProvider: IBitmapTileUniProvider;
    function GetPath: string;
    function GetProjection: IProjection;
    function GetMapCalibrationList: IMapCalibrationList;
  private
    function GetUseMarks: Boolean;
    function GetUseGrids: Boolean;
    function GetUseFillingMap: Boolean;
    function GetUseRecolor: Boolean;
    function GetSplitCount: TPoint;
    function GetSkipExistingFiles: Boolean;
    function GetBGColor: TColor32;
    function GetCustomOptions: IMapCombineCustomOptions;
    function GetAllowWrite(const AMapType: IMapType): boolean;
  public
    constructor Create(
      const ALanguageManager: ILanguageManager;
      const AProjectionSetList: IProjectionSetList;
      const AVectorGeometryProjectedFactory: IGeometryProjectedFactory;
      const ABitmapFactory: IBitmap32StaticFactory;
      const AMapSelectFrameBuilder: IMapSelectFrameBuilder;
      const AActiveMapsList: IMapTypeListChangeable;
      const AViewConfig: IGlobalViewMainConfig;
      const AUseTilePrevZoomConfig: IUseTilePrevZoomConfig;
      const AMapCalibrationList: IMapCalibrationList;
      const AMinPartSize: TPoint;
      const AMaxPartSize: TPoint;
      const AOptionsSet: TMapCombineOptionsSet;
      const ACombinePathStringTypeSupport: TStringTypeSupport;
      const ADefaultExt: string;
      const AFormatName: string
    ); reintroduce;
    procedure RefreshTranslation; override;
    destructor Destroy; override;
  end;

implementation

uses
  Types,
  Math,
  GR32,
  gnugettext,
  t_GeoTypes,
  i_MapVersionRequest,
  i_MapTypeListStatic,
  i_InterfaceListSimple,
  i_GeometryProjected,
  i_ProjectionSet,
  u_InterfaceListSimple,
  u_StrFunc,
  u_GeoFunc,
  u_GeometryFunc,
  u_BitmapLayerProviderMapWithLayer,
  u_MapCalibrationListBasic,
  u_ResStrings;

{$R *.dfm}

{ TfrMapCombine }

constructor TfrMapCombine.Create(
  const ALanguageManager: ILanguageManager;
  const AProjectionSetList: IProjectionSetList;
  const AVectorGeometryProjectedFactory: IGeometryProjectedFactory;
  const ABitmapFactory: IBitmap32StaticFactory;
  const AMapSelectFrameBuilder: IMapSelectFrameBuilder;
  const AActiveMapsList: IMapTypeListChangeable;
  const AViewConfig: IGlobalViewMainConfig;
  const AUseTilePrevZoomConfig: IUseTilePrevZoomConfig;
  const AMapCalibrationList: IMapCalibrationList;
  const AMinPartSize: TPoint;
  const AMaxPartSize: TPoint;
  const AOptionsSet: TMapCombineOptionsSet;
  const ACombinePathStringTypeSupport: TStringTypeSupport;
  const ADefaultExt: string;
  const AFormatName: string
);
begin
  Assert(AMinPartSize.X <= AMaxPartSize.X);
  Assert(AMinPartSize.Y <= AMaxPartSize.Y);
  inherited Create(ALanguageManager);
  FProjectionSetList := AProjectionSetList;
  FVectorGeometryProjectedFactory := AVectorGeometryProjectedFactory;
  FBitmapFactory := ABitmapFactory;
  FActiveMapsList := AActiveMapsList;
  FMapCalibrationList := AMapCalibrationList;
  FMinPartSize := AMinPartSize;
  FMaxPartSize := AMaxPartSize;
  FViewConfig := AViewConfig;
  FUseTilePrevZoomConfig := AUseTilePrevZoomConfig;
  FCombinePathStringTypeSupport := ACombinePathStringTypeSupport;
  FDefaultExt := ADefaultExt;
  FFormatName := AFormatName;

  FfrMapCombineOptions :=
    TfrMapCombineCustomOptions.Create(ALanguageManager, AOptionsSet);

  FfrMapSelect :=
    AMapSelectFrameBuilder.Build(
      mfMaps,    // show Maps
      True,      // add -NO- to combobox
      False,     // show disabled maps
      GetAllowWrite
    );
  FfrLayerSelect :=
    AMapSelectFrameBuilder.Build(
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
  FreeAndNil(FfrMapCombineOptions);
  FreeAndNil(FfrMapSelect);
  FreeAndNil(FfrLayerSelect);
  inherited;
end;

function TfrMapCombine.GetAllowWrite(const AMapType: IMapType): boolean;
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
  numd: int64;
  VMapType: IMapType;
  VProjection: IProjection;
  VPolyLL: IGeometryLonLatPolygon;
  VProjected: IGeometryProjectedPolygon;
  VLine: IGeometryProjectedSinglePolygon;
  VBounds: TDoubleRect;
  VPixelRect: TRect;
  VTileRect: TRect;
  VPixelSize: TPoint;
  VTileSize: TPoint;
begin
  VMapType := FfrMapSelect.GetSelectedMapType;
  if (VMapType = nil) then begin
    VMapType := FfrLayerSelect.GetSelectedMapType;
  end; //calc for layer if map is not selected
  if VMapType <> nil then begin
    VProjection := GetProjection;
    VPolyLL := FPolygLL;
    if VPolyLL <> nil then begin
      VProjected :=
        FVectorGeometryProjectedFactory.CreateProjectedPolygonByLonLatPolygon(
          VProjection,
          VPolyLL
        );
      VLine := GetProjectedSinglePolygonByProjectedPolygon(VProjected);
      if Assigned(VLine) then begin
        VBounds := VLine.Bounds;
        VPixelRect := RectFromDoubleRect(VBounds, rrOutside);
        VPixelSize := RectSize(VPixelRect);
        VTileRect := VProjection.PixelRect2TileRect(VPixelRect);
        VTileSize := RectSize(VTileRect);

        numd := VTileSize.X;
        numd := numd * VTileSize.Y;
        lblStat.Caption :=
          Format(
            _('Number of tiles: %0:sx%1:s (%2:s), size: %3:sx%4:s'),
            [
              IntToStr(VTileSize.X),
              IntToStr(VTileSize.Y),
              IntToStr(numd),
              IntToStr(VPixelSize.X),
              IntToStr(VPixelSize.Y)
            ]
          );
      end;
    end;
  end;
end;

procedure TfrMapCombine.chkAddVisibleLayersClick(Sender: TObject);
begin
  FfrLayerSelect.SetEnabled(not chkAddVisibleLayers.Checked);
end;

function TfrMapCombine.GetBGColor: TColor32;
begin
  if GetCustomOptions.IsSaveAlfa then begin
    Result := 0;
  end else begin
    Result := SetAlpha(FViewConfig.BackGroundColor, 255);
  end;
end;

function TfrMapCombine.GetCustomOptions: IMapCombineCustomOptions;
begin
  Result := (FfrMapCombineOptions as IMapCombineCustomOptions);
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

function TfrMapCombine.GetProjection: IProjection;
var
  VMap: IMapType;
  VLayer: IMapType;
  VMainMapType: IMapType;
  VZoom: Byte;
  VProjectionSet: IProjectionSet;
  VIndex: Integer;
begin
  Result := nil;
  VProjectionSet := nil;
  VIndex := cbbProjection.ItemIndex;
  if VIndex < 0 then begin
    VIndex := 0;
  end;
  if VIndex >= 2 then begin
    VIndex := VIndex - 2;
    if VIndex < FProjectionSetList.Count then begin
      VProjectionSet := FProjectionSetList.Items[VIndex];
    end;
    VIndex := 0;
  end;
  if VProjectionSet = nil then begin
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
      VProjectionSet := VMainMapType.ProjectionSet;
    end;
  end;
  VZoom := cbbZoom.ItemIndex;
  if VProjectionSet <> nil then begin
    VProjectionSet.ValidateZoom(VZoom);
    Result := VProjectionSet[VZoom];
  end;
end;

function TfrMapCombine.GetProvider: IBitmapTileUniProvider;
var
  VMap: IMapType;
  VMapVersion: IMapVersionRequest;
  VLayer: IMapType;
  VLayerVersion: IMapVersionRequest;
  VActiveMapsSet: IMapTypeListStatic;
begin
  VMap := FfrMapSelect.GetSelectedMapType;
  if Assigned(VMap) then begin
    VMapVersion := VMap.VersionRequest.GetStatic;
  end else begin
    VMapVersion := nil;
  end;

  VLayer := FfrLayerSelect.GetSelectedMapType;
  if Assigned(VLayer) then begin
    VLayerVersion := VLayer.VersionRequest.GetStatic;
  end else begin
    VLayerVersion := nil;
  end;

  if chkAddVisibleLayers.Checked then begin
    VLayer := nil;
    VLayerVersion := nil;
    VActiveMapsSet := FActiveMapsList.List;
  end else begin
    VActiveMapsSet := nil;
  end;

  Result :=
    TBitmapLayerProviderMapWithLayer.Create(
      FBitmapFactory,
      VMap,
      VMapVersion,
      VLayer,
      VLayerVersion,
      VActiveMapsSet,
      FUseTilePrevZoomConfig.UsePrevZoomAtMap,
      FUseTilePrevZoomConfig.UsePrevZoomAtLayer
    );
end;

function TfrMapCombine.GetSkipExistingFiles: Boolean;
begin
  Result := chkSkipExistingFiles.Checked;
end;

function TfrMapCombine.GetSplitCount: TPoint;
begin
  Result.X := seSplitHor.Value;
  Result.Y := seSplitVert.Value;
end;

function TfrMapCombine.GetUseFillingMap: Boolean;
begin
  Result := chkUseFillingMap.Checked;
end;

function TfrMapCombine.GetUseGrids: Boolean;
begin
  Result := chkUseMapGrids.Checked;
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
  const APolygon: IGeometryLonLatPolygon
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
  FfrMapCombineOptions.Show(pnlCustomOpt);
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
    VProjectionSet: IProjectionSet;
  begin
    VProj := ACaption;
    if Assigned(AMapType) then begin
      VProjectionSet := AMapType.ProjectionSet;
      for I := 0 to FProjectionSetList.Count - 1 do begin
        if FProjectionSetList.Items[I].IsSame(VProjectionSet) then begin
          VProj := VProj + ' - ' + FProjectionSetList.Captions[I];
          Break;
        end;
      end;
    end;
    if VProj = ACaption then begin
      VProj := VProj + ' - ' + '<UNKNOWN>';
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
  AddProj(FfrMapSelect.GetSelectedMapType, _('Projection of map'));
  AddProj(FfrLayerSelect.GetSelectedMapType, _('Projection of layer'));

  for I := 0 to FProjectionSetList.Count - 1 do begin
    cbbProjection.Items.Add(FProjectionSetList.Captions[I]);
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
  VFileName: string;
  VCalibrationStringSupport: TStringTypeSupport;
  VCalibrationList: IMapCalibrationList;
  VCalibration: IMapCalibration;
  VMsg: string;
  VEPSG: Integer;
  VProjection: IProjection;
  VLonLatRect: TDoubleRect;
  VPixelRect: TRect;
  VSplitCount: TPoint;
  VPixelSize: TPoint;
  i: Integer;
begin
  if (FfrMapSelect.GetSelectedMapType = nil) and (FfrLayerSelect.GetSelectedMapType = nil) then begin
    ShowMessage(_('Please select map or layer'));
    Result := False;
    Exit;
  end;
  VProjection := GetProjection;
  VEPSG := VProjection.ProjectionType.ProjectionEPSG;
  if VEPSG <= 0 then begin
    VMsg := Format(_('Map has unknown projection (EPSG=%d).'#13#10 + 'Do you want to set the projection manually?'), [VEPSG]);
    if (Application.MessageBox(pchar(VMsg), pchar(SAS_MSG_coution), 36) = IDYES) then begin
      Result := False;
      Exit;
    end;
  end;
  VLonLatRect := FPolygLL.Bounds.Rect;
  VProjection.ProjectionType.ValidateLonLatRect(VLonLatRect);
  VPixelRect :=
    RectFromDoubleRect(
      VProjection.LonLatRect2PixelRectFloat(VLonLatRect),
      rrOutside
    );
  VSplitCount := GetSplitCount;
  VPixelSize := RectSize(VPixelRect);
  VPixelSize.X := Trunc(VPixelSize.X / VSplitCount.X);
  VPixelSize.Y := Trunc(VPixelSize.Y / VSplitCount.Y);
  if VPixelSize.X < FMinPartSize.X then begin
    ShowMessageFmt(_('Every map part must have width more than %0:d but exist %1:d'), [FMinPartSize.X, VPixelSize.X]);
    Result := False;
    Exit;
  end;
  if VPixelSize.Y < FMinPartSize.Y then begin
    ShowMessageFmt(_('Every map part must have height more than %0:d but exist %1:d'), [FMinPartSize.Y, VPixelSize.Y]);
    Result := False;
    Exit;
  end;

  if VPixelSize.X > FMaxPartSize.X then begin
    ShowMessageFmt(_('Every map part must have width less than %0:d but exist %1:d'), [FMaxPartSize.X, VPixelSize.X]);
    Result := False;
    Exit;
  end;
  if VPixelSize.Y > FMaxPartSize.Y then begin
    ShowMessageFmt(_('Every map part must have height less than %0:d but exist %1:d'), [FMaxPartSize.Y, VPixelSize.Y]);
    Result := False;
    Exit;
  end;

  VPath := GetPath;
  if VPath = '' then begin
    ShowMessage(_('Please, select output file first!'));
    Result := False;
    Exit;
  end;
  case FCombinePathStringTypeSupport of
    stsAscii: begin
      if not IsAscii(VPath) then begin
        ShowMessage(_('This format supports file name with ASCII characters only!'));
        Result := False;
        Exit;
      end;
    end;
    stsAnsi: begin
      if not IsAnsi(VPath) then begin
        ShowMessage(_('This format doesn''t support file name with characters not from current locale!'));
        Result := False;
        Exit;
      end;
    end;
  end;
  if FileExists(VPath) then begin
    VMsg := Format(SAS_MSG_FileExists, [VPath]);
    if (Application.MessageBox(pchar(VMsg), pchar(SAS_MSG_coution), 36) <> IDYES) then begin
      Result := False;
      Exit;
    end;
  end;
  VCalibrationList := GetMapCalibrationList;
  if Assigned(VCalibrationList) and (VCalibrationList.Count > 0) then begin
    VCalibrationStringSupport := stsUnicode;
    for i := 0 to VCalibrationList.Count - 1 do begin
      VCalibration := VCalibrationList.Items[i];
      case VCalibration.StringSupport of
        stsAscii: begin
          VCalibrationStringSupport := stsAscii;
          break;
        end;
        stsAnsi: begin
          if VCalibrationStringSupport <> stsAscii then begin
            VCalibrationStringSupport := stsAnsi;
          end;
        end;
      end;
    end;
    if VCalibrationStringSupport <> stsUnicode then begin
      VFileName := ExtractFileName(VPath);
      case VCalibrationStringSupport of
        stsAscii: begin
          if not IsAscii(VFileName) then begin
            ShowMessage(_('At least one calibration type supports file name with ASCII characters only!'));
            Result := False;
            Exit;
          end;
        end;
        stsAnsi: begin
          if not IsAnsi(VFileName) then begin
            ShowMessage(_('At least one calibration type doesn''t support file name with characters not from current locale!'));
            Result := False;
            Exit;
          end;
        end;
      end;
    end;
  end;

  Result := True;
end;

end.
