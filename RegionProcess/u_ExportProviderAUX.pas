unit u_ExportProviderAUX;

interface

uses
  Forms,
  i_Notifier,
  i_LanguageManager,
  i_MapTypes,
  i_ActiveMapsConfig,
  i_CoordConverterFactory,
  i_VectorItmesFactory,
  i_MapTypeGUIConfigList,
  i_VectorItemLonLat,
  u_ExportProviderAbstract;

type
  TExportProviderAUX = class(TExportProviderAbstract)
  private
    FProjectionFactory: IProjectionInfoFactory;
    FVectorItmesFactory: IVectorItmesFactory;
    FAppClosingNotifier: INotifier;
    FTimerNoifier: INotifier;
  protected
    function CreateFrame: TFrame; override;
  public
    constructor Create(
      const ALanguageManager: ILanguageManager;
      const AAppClosingNotifier: INotifier;
      const ATimerNoifier: INotifier;
      const AMainMapsConfig: IMainMapsConfig;
      const AFullMapsSet: IMapTypeSet;
      const AGUIConfigList: IMapTypeGUIConfigList;
      const AProjectionFactory: IProjectionInfoFactory;
      const AVectorItmesFactory: IVectorItmesFactory
    );
    function GetCaption: string; override;
    procedure StartProcess(const APolygon: ILonLatPolygon); override;
  end;


implementation

uses
  SysUtils,
  i_RegionProcessParamsFrame,
  u_NotifierOperation,
  u_RegionProcessProgressInfo,
  i_VectorItemProjected,
  u_ThreadExportToAUX,
  u_ResStrings,
  u_MapType,
  fr_ExportAUX,
  frm_ProgressSimple;

{ TExportProviderKml }

constructor TExportProviderAUX.Create(
  const ALanguageManager: ILanguageManager;
  const AAppClosingNotifier: INotifier;
  const ATimerNoifier: INotifier;
  const AMainMapsConfig: IMainMapsConfig;
  const AFullMapsSet: IMapTypeSet;
  const AGUIConfigList: IMapTypeGUIConfigList;
  const AProjectionFactory: IProjectionInfoFactory;
  const AVectorItmesFactory: IVectorItmesFactory
);
begin
  inherited Create(
    ALanguageManager,
    AMainMapsConfig,
    AFullMapsSet,
    AGUIConfigList
  );
  FProjectionFactory := AProjectionFactory;
  FVectorItmesFactory := AVectorItmesFactory;
  FAppClosingNotifier := AAppClosingNotifier;
  FTimerNoifier := ATimerNoifier;
end;

function TExportProviderAUX.CreateFrame: TFrame;
begin
  Result :=
    TfrExportAUX.Create(
      Self.LanguageManager,
      Self.MainMapsConfig,
      Self.FullMapsSet,
      Self.GUIConfigList
    );
  Assert(Supports(Result, IRegionProcessParamsFrameOneMap));
  Assert(Supports(Result, IRegionProcessParamsFrameOneZoom));
  Assert(Supports(Result, IRegionProcessParamsFrameTargetPath));
end;

function TExportProviderAUX.GetCaption: string;
begin
  Result := SAS_STR_ExportAUXGeoServerCaption;
end;

procedure TExportProviderAUX.StartProcess(const APolygon: ILonLatPolygon);
var
  VPath: string;
  VMapType: TMapType;
  VZoom: byte;
  VProjectedPolygon: IProjectedPolygon;
  VCancelNotifierInternal: INotifierOperationInternal;
  VOperationID: Integer;
  VProgressInfo: TRegionProcessProgressInfo;
begin
  inherited;
  VMapType := (ParamsFrame as IRegionProcessParamsFrameOneMap).MapType;
  VZoom := (ParamsFrame as IRegionProcessParamsFrameOneZoom).Zoom;
  VPath := (ParamsFrame as IRegionProcessParamsFrameTargetPath).Path;

  VProjectedPolygon :=
    FVectorItmesFactory.CreateProjectedPolygonByLonLatPolygon(
      FProjectionFactory.GetByConverterAndZoom(VMapType.GeoConvert, VZoom),
      APolygon
    );

  VCancelNotifierInternal := TNotifierOperation.Create;
  VOperationID := VCancelNotifierInternal.CurrentOperation;
  VProgressInfo := TRegionProcessProgressInfo.Create;

  TfrmProgressSimple.Create(
    Application,
    FAppClosingNotifier,
    FTimerNoifier,
    VCancelNotifierInternal,
    VProgressInfo
  );

  TThreadExportToAUX.Create(
    VCancelNotifierInternal,
    VOperationID,
    VProgressInfo,
    APolygon,
    VProjectedPolygon,
    VZoom,
    VMapType,
    VPath
  );
end;

end.
