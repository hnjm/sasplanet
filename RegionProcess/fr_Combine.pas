unit fr_Combine;

interface

uses
  Classes,
  Controls,
  Forms,
  StdCtrls,
  ExtCtrls,
  i_LanguageManager,
  i_CoordConverterFactory,
  i_CoordConverterList,
  i_VectorItemLonLat,
  i_MapTypeSet,
  i_UseTilePrevZoomConfig,
  i_ActiveMapsConfig,
  i_MapTypeGUIConfigList,
  i_BitmapTileSaveLoadFactory,
  i_ArchiveReadWriteFactory,
  i_LocalCoordConverterFactorySimpe,
  i_BitmapPostProcessing,
  i_Bitmap32StaticFactory,
  i_UsedMarksConfig,
  i_MarksDrawConfig,
  i_MarkSystem,
  i_MapCalibration,
  i_VectorItemsFactory,
  i_ProjectedGeometryProvider,
  i_GlobalViewMainConfig,
  i_RegionProcessProgressInfoInternalFactory,
  u_CommonFormAndFrameParents;

type
  TfrCombine = class(TFrame)
    pnlTop: TPanel;
    pnlOutputFormat: TPanel;
    lblOutputFormat: TLabel;
    cbbOutputFormat: TComboBox;
    pnlExport: TPanel;
    procedure cbbOutputFormatChange(Sender: TObject);
  private
    FZoom: byte;
    FPolygon: ILonLatPolygon;
  public
    constructor Create(
      const AProgressFactory: IRegionProcessProgressInfoInternalFactory;
      const ALanguageManager: ILanguageManager;
      const AMainMapsConfig: IMainMapsConfig;
      const AFullMapsSet: IMapTypeSet;
      const AGUIConfigList: IMapTypeGUIConfigList;
      const AViewConfig: IGlobalViewMainConfig;
      const AUseTilePrevZoomConfig: IUseTilePrevZoomConfig;
      const AProjectionFactory: IProjectionInfoFactory;
      const ACoordConverterList: ICoordConverterList;
      const AVectorGeometryProjectedFactory: IVectorGeometryProjectedFactory;
      const AProjectedGeometryProvider: IProjectedGeometryProvider;
      const ABitmapTileSaveLoadFactory: IBitmapTileSaveLoadFactory;
      const AArchiveReadWriteFactory: IArchiveReadWriteFactory;
      const AMarksShowConfig: IUsedMarksConfig;
      const AMarksDrawConfig: IMarksDrawConfig;
      const AMarksDB: IMarkSystem;
      const ALocalConverterFactory: ILocalCoordConverterFactorySimpe;
      const ABitmapFactory: IBitmap32StaticFactory;
      const ABitmapPostProcessing: IBitmapPostProcessingChangeable;
      const AMapCalibrationList: IMapCalibrationList
    ); reintroduce;
    destructor Destroy; override;
    procedure RefreshTranslation; override;
    procedure StartProcess(const APolygon: ILonLatPolygon);
    procedure Show(
      AParent: TWinControl;
      AZoom: byte;
      const APolygon: ILonLatPolygon
    );
    function Validate: Boolean;
  end;

implementation

uses
  gnugettext,
  u_ExportProviderAbstract,
  u_ProviderMapCombineBMP,
  u_ProviderMapCombineJPG,
  u_ProviderMapCombinePNG,
  u_ProviderMapCombineKMZ,
  u_ProviderMapCombineECW,
  u_ProviderMapCombineJP2;

{$R *.dfm}

{ TfrCombine }

constructor TfrCombine.Create(
  const AProgressFactory: IRegionProcessProgressInfoInternalFactory;
  const ALanguageManager: ILanguageManager;
  const AMainMapsConfig: IMainMapsConfig;
  const AFullMapsSet: IMapTypeSet;
  const AGUIConfigList: IMapTypeGUIConfigList;
  const AViewConfig: IGlobalViewMainConfig;
  const AUseTilePrevZoomConfig: IUseTilePrevZoomConfig;
  const AProjectionFactory: IProjectionInfoFactory;
  const ACoordConverterList: ICoordConverterList;
  const AVectorGeometryProjectedFactory: IVectorGeometryProjectedFactory;
  const AProjectedGeometryProvider: IProjectedGeometryProvider;
  const ABitmapTileSaveLoadFactory: IBitmapTileSaveLoadFactory;
  const AArchiveReadWriteFactory: IArchiveReadWriteFactory;
  const AMarksShowConfig: IUsedMarksConfig;
  const AMarksDrawConfig: IMarksDrawConfig;
  const AMarksDB: IMarkSystem;
  const ALocalConverterFactory: ILocalCoordConverterFactorySimpe;
  const ABitmapFactory: IBitmap32StaticFactory;
  const ABitmapPostProcessing: IBitmapPostProcessingChangeable;
  const AMapCalibrationList: IMapCalibrationList
);
var
  VExportProvider: TExportProviderAbstract;
begin
  TP_Ignore(Self, 'cbbOutputFormat.Items');
  inherited Create(ALanguageManager);

  VExportProvider :=
    TProviderMapCombineJPG.Create(
      AProgressFactory,
      ALanguageManager,
      AMainMapsConfig,
      AFullMapsSet,
      AGUIConfigList,
      AViewConfig,
      AUseTilePrevZoomConfig,
      AProjectionFactory,
      ACoordConverterList,
      AVectorGeometryProjectedFactory,
      AProjectedGeometryProvider,
      AMarksShowConfig,
      AMarksDrawConfig,
      AMarksDB,
      ALocalConverterFactory,
      ABitmapFactory,
      ABitmapPostProcessing,
      AMapCalibrationList
    );
  cbbOutputFormat.Items.AddObject(VExportProvider.GetCaption, VExportProvider);

  VExportProvider :=
    TProviderMapCombinePNG.Create(
      AProgressFactory,
      ALanguageManager,
      AMainMapsConfig,
      AFullMapsSet,
      AGUIConfigList,
      AViewConfig,
      AUseTilePrevZoomConfig,
      AProjectionFactory,
      ACoordConverterList,
      AVectorGeometryProjectedFactory,
      AProjectedGeometryProvider,
      AMarksShowConfig,
      AMarksDrawConfig,
      AMarksDB,
      ALocalConverterFactory,
      ABitmapFactory,
      ABitmapPostProcessing,
      AMapCalibrationList
    );
  cbbOutputFormat.Items.AddObject(VExportProvider.GetCaption, VExportProvider);

  VExportProvider :=
    TProviderMapCombineBMP.Create(
      AProgressFactory,
      ALanguageManager,
      AMainMapsConfig,
      AFullMapsSet,
      AGUIConfigList,
      AViewConfig,
      AUseTilePrevZoomConfig,
      AProjectionFactory,
      ACoordConverterList,
      AVectorGeometryProjectedFactory,
      AProjectedGeometryProvider,
      AMarksShowConfig,
      AMarksDrawConfig,
      AMarksDB,
      ALocalConverterFactory,
      ABitmapFactory,
      ABitmapPostProcessing,
      AMapCalibrationList
    );
  cbbOutputFormat.Items.AddObject(VExportProvider.GetCaption, VExportProvider);

  VExportProvider :=
    TProviderMapCombineECW.Create(
      AProgressFactory,
      ALanguageManager,
      AMainMapsConfig,
      AFullMapsSet,
      AGUIConfigList,
      AViewConfig,
      AUseTilePrevZoomConfig,
      AProjectionFactory,
      ACoordConverterList,
      AVectorGeometryProjectedFactory,
      AProjectedGeometryProvider,
      AMarksShowConfig,
      AMarksDrawConfig,
      AMarksDB,
      ALocalConverterFactory,
      ABitmapFactory,
      ABitmapPostProcessing,
      AMapCalibrationList
    );
  cbbOutputFormat.Items.AddObject(VExportProvider.GetCaption, VExportProvider);

  VExportProvider :=
    TProviderMapCombineJP2.Create(
      AProgressFactory,
      ALanguageManager,
      AMainMapsConfig,
      AFullMapsSet,
      AGUIConfigList,
      AViewConfig,
      AUseTilePrevZoomConfig,
      AProjectionFactory,
      ACoordConverterList,
      AVectorGeometryProjectedFactory,
      AProjectedGeometryProvider,
      AMarksShowConfig,
      AMarksDrawConfig,
      AMarksDB,
      ALocalConverterFactory,
      ABitmapFactory,
      ABitmapPostProcessing,
      AMapCalibrationList
    );
  cbbOutputFormat.Items.AddObject(VExportProvider.GetCaption, VExportProvider);

  VExportProvider :=
    TProviderMapCombineKMZ.Create(
      AProgressFactory,
      ALanguageManager,
      AMainMapsConfig,
      AFullMapsSet,
      AGUIConfigList,
      AViewConfig,
      AUseTilePrevZoomConfig,
      AProjectionFactory,
      ACoordConverterList,
      AVectorGeometryProjectedFactory,
      AProjectedGeometryProvider,
      ABitmapTileSaveLoadFactory,
      AArchiveReadWriteFactory,
      AMarksShowConfig,
      AMarksDrawConfig,
      AMarksDB,
      ALocalConverterFactory,
      ABitmapFactory,
      ABitmapPostProcessing,
      AMapCalibrationList
    );
  cbbOutputFormat.Items.AddObject(VExportProvider.GetCaption, VExportProvider);

  cbbOutputFormat.ItemIndex := 0;
end;

destructor TfrCombine.Destroy;
var
  i: Integer;
begin
  if Assigned(cbbOutputFormat) then begin
    for i := 0 to cbbOutputFormat.Items.Count - 1 do begin
      cbbOutputFormat.Items.Objects[i].Free;
      cbbOutputFormat.Items.Objects[i] := nil;
    end;
  end;
  inherited;
end;

procedure TfrCombine.cbbOutputFormatChange(Sender: TObject);
var
  VExportProvider: TExportProviderAbstract;
  i: Integer;
begin
  for i := 0 to cbbOutputFormat.Items.Count - 1 do begin
    VExportProvider := TExportProviderAbstract(cbbOutputFormat.Items.Objects[i]);
    if VExportProvider <> nil then begin
      if i = cbbOutputFormat.ItemIndex then begin
        VExportProvider.Show(pnlExport, FZoom, FPolygon);
      end else begin
        VExportProvider.Hide;
      end;
    end;
  end;
end;

procedure TfrCombine.RefreshTranslation;
var
  i: Integer;
  VProvider: TExportProviderAbstract;
  VIndex: Integer;
begin
  inherited;
  VIndex := cbbOutputFormat.ItemIndex;
  for i := 0 to cbbOutputFormat.Items.Count - 1 do begin
    VProvider := TExportProviderAbstract(cbbOutputFormat.Items.Objects[i]);
    cbbOutputFormat.Items[i] := VProvider.GetCaption;
  end;
  cbbOutputFormat.ItemIndex := VIndex;
end;

procedure TfrCombine.Show(AParent: TWinControl; AZoom: byte;
  const APolygon: ILonLatPolygon);
var
  i:integer;
  VExportProvider: TExportProviderAbstract;
begin
  Parent := AParent;
  FZoom := AZoom;
  FPolygon := APolygon;
  for i := 0 to cbbOutputFormat.Items.Count - 1 do begin
    VExportProvider := TExportProviderAbstract(cbbOutputFormat.Items.Objects[i]);
    if VExportProvider <> nil then begin
      VExportProvider.Show(pnlExport, AZoom, APolygon);
    end;
  end;
  cbbOutputFormatChange(nil);
end;

procedure TfrCombine.StartProcess(const APolygon: ILonLatPolygon);
var
  VExportProvider: TExportProviderAbstract;
begin
  VExportProvider := TExportProviderAbstract(cbbOutputFormat.Items.Objects[cbbOutputFormat.ItemIndex]);
  if VExportProvider <> nil then begin
    VExportProvider.StartProcess(APolygon);
  end;
end;

function TfrCombine.Validate: Boolean;
var
  VExportProvider: TExportProviderAbstract;
begin
  Result := False;
  VExportProvider := TExportProviderAbstract(cbbOutputFormat.Items.Objects[cbbOutputFormat.ItemIndex]);
  if VExportProvider <> nil then begin
    Result := VExportProvider.Validate;
  end;
end;

end.
