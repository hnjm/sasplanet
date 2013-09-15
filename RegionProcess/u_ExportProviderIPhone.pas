unit u_ExportProviderIPhone;

interface

uses
  Forms,
  i_LanguageManager,
  i_VectorItemLonLat,
  i_MapTypes,
  i_ActiveMapsConfig,
  i_Bitmap32StaticFactory,
  i_CoordConverterFactory,
  i_LocalCoordConverterFactorySimpe,
  i_VectorItemsFactory,
  i_MapTypeGUIConfigList,
  i_BitmapTileSaveLoadFactory,
  i_RegionProcessProgressInfoInternalFactory,
  u_ExportProviderAbstract,
  fr_ExportIPhone;

type
  TExportProviderIPhone = class(TExportProviderAbstract)
  private
    FFrame: TfrExportIPhone;
    FCoordConverterFactory: ICoordConverterFactory;
    FLocalConverterFactory: ILocalCoordConverterFactorySimpe;
    FProjectionFactory: IProjectionInfoFactory;
    FBitmapFactory: IBitmap32StaticFactory;
    FVectorGeometryProjectedFactory: IVectorGeometryProjectedFactory;
    FBitmapTileSaveLoadFactory: IBitmapTileSaveLoadFactory;
    FNewFormat: Boolean;
  protected
    function CreateFrame: TFrame; override;
  public
    constructor Create(
      const AProgressFactory: IRegionProcessProgressInfoInternalFactory;
      const ALanguageManager: ILanguageManager;
      const AMainMapsConfig: IMainMapsConfig;
      const AFullMapsSet: IMapTypeSet;
      const AGUIConfigList: IMapTypeGUIConfigList;
      const ACoordConverterFactory: ICoordConverterFactory;
      const ALocalConverterFactory: ILocalCoordConverterFactorySimpe;
      const AProjectionFactory: IProjectionInfoFactory;
      const AVectorGeometryProjectedFactory: IVectorGeometryProjectedFactory;
      const ABitmapFactory: IBitmap32StaticFactory;
      const ABitmapTileSaveLoadFactory: IBitmapTileSaveLoadFactory;
      ANewFormat: Boolean
    );
    function GetCaption: string; override;
    procedure StartProcess(const APolygon: ILonLatPolygon); override;
  end;


implementation

uses
  Types,
  SysUtils,
  i_RegionProcessParamsFrame,
  i_RegionProcessProgressInfo,
  u_ThreadExportIPhone,
  u_ResStrings,
  u_MapType;

{ TExportProviderIPhone }

constructor TExportProviderIPhone.Create(
  const AProgressFactory: IRegionProcessProgressInfoInternalFactory;
  const ALanguageManager: ILanguageManager;
  const AMainMapsConfig: IMainMapsConfig;
  const AFullMapsSet: IMapTypeSet;
  const AGUIConfigList: IMapTypeGUIConfigList;
  const ACoordConverterFactory: ICoordConverterFactory;
  const ALocalConverterFactory: ILocalCoordConverterFactorySimpe;
  const AProjectionFactory: IProjectionInfoFactory;
  const AVectorGeometryProjectedFactory: IVectorGeometryProjectedFactory;
  const ABitmapFactory: IBitmap32StaticFactory;
  const ABitmapTileSaveLoadFactory: IBitmapTileSaveLoadFactory;
  ANewFormat: Boolean
);
begin
  inherited Create(
    AProgressFactory,
    ALanguageManager,
    AMainMapsConfig,
    AFullMapsSet,
    AGUIConfigList
  );
  FCoordConverterFactory := ACoordConverterFactory;
  FLocalConverterFactory := ALocalConverterFactory;
  FProjectionFactory := AProjectionFactory;
  FVectorGeometryProjectedFactory := AVectorGeometryProjectedFactory;
  FBitmapTileSaveLoadFactory := ABitmapTileSaveLoadFactory;
  FBitmapFactory := ABitmapFactory;
  FNewFormat := ANewFormat;
end;

function TExportProviderIPhone.CreateFrame: TFrame;
begin
  FFrame :=
    TfrExportIPhone.Create(
      Self.LanguageManager,
      Self.MainMapsConfig,
      Self.FullMapsSet,
      Self.GUIConfigList
    );
  Result := FFrame;
  Assert(Supports(Result, IRegionProcessParamsFrameZoomArray));
  Assert(Supports(Result, IRegionProcessParamsFrameTargetPath));
end;

function TExportProviderIPhone.GetCaption: string;
begin
  if FNewFormat then begin
    Result := SAS_STR_ExportIPhone128Caption;
  end else begin
    Result := SAS_STR_ExportIPhone64Caption;
  end;
end;

procedure TExportProviderIPhone.StartProcess(const APolygon: ILonLatPolygon);
var
  VPath: string;
  VZoomArr: TByteDynArray;
  typemaparr: array of TMapType;
  comprSat, comprMap, comprHyb: byte;
  Replace: boolean;
  VActiveMapIndex: Integer;
  VProgressInfo: IRegionProcessProgressInfoInternal;
begin
  inherited;
  VZoomArr := (ParamsFrame as IRegionProcessParamsFrameZoomArray).ZoomArray;
  VPath := (ParamsFrame as IRegionProcessParamsFrameTargetPath).Path;
  setlength(typemaparr, 3);
  VActiveMapIndex := 0;
  typemaparr[0] := FFrame.GetMap;
  if typemaparr[0] <> nil then begin
    if FFrame.rbSat.Checked then begin
      VActiveMapIndex := 0;
    end;
  end;
  typemaparr[1] := FFrame.GetSat;
  if typemaparr[1] <> nil then begin
    if FFrame.rbMap.Checked then begin
      VActiveMapIndex := 1;
    end;
  end;
  typemaparr[2] := FFrame.GetHyb;
  if typemaparr[2] <> nil then begin
    if FFrame.rbHybr.Checked then begin
      VActiveMapIndex := 2;
    end;
  end;
  comprSat := FFrame.seSatCompress.Value;
  comprMap := FFrame.seMapCompress.Value;
  comprHyb := FFrame.seHybrCompress.Value;
  Replace := FFrame.chkAppendTilse.Checked;

  VProgressInfo := ProgressFactory.Build(APolygon);

  TThreadExportIPhone.Create(
    VProgressInfo,
    FCoordConverterFactory,
    FLocalConverterFactory,
    FProjectionFactory,
    FVectorGeometryProjectedFactory,
    FBitmapFactory,
    FBitmapTileSaveLoadFactory,
    VPath,
    APolygon,
    VZoomArr,
    typemaparr,
    VActiveMapIndex,
    Replace,
    FNewFormat,
    comprSat,
    comprMap,
    comprHyb
  );
end;

end.


