unit u_ExportProviderCE;

interface

uses
  Classes,
  Forms,
  i_GeometryLonLat,
  i_CoordConverterFactory,
  i_GeometryProjectedFactory,
  i_LanguageManager,
  i_MapTypeSet,
  i_ActiveMapsConfig,
  i_MapTypeGUIConfigList,
  i_RegionProcessProgressInfoInternalFactory,
  u_ExportProviderAbstract;

type
  TExportProviderCE = class(TExportProviderAbstract)
  private
    FCoordConverterFactory: ICoordConverterFactory;
    FProjectionFactory: IProjectionInfoFactory;
    FVectorGeometryProjectedFactory: IGeometryProjectedFactory;
  protected
    function CreateFrame: TFrame; override;
  public
    constructor Create(
      const AProgressFactory: IRegionProcessProgressInfoInternalFactory;
      const ALanguageManager: ILanguageManager;
      const AMainMapsConfig: IMainMapsConfig;
      const AFullMapsSet: IMapTypeSet;
      const AGUIConfigList: IMapTypeGUIConfigList;
      const AProjectionFactory: IProjectionInfoFactory;
      const AVectorGeometryProjectedFactory: IGeometryProjectedFactory;
      const ACoordConverterFactory: ICoordConverterFactory
    );
    function GetCaption: string; override;
    procedure StartProcess(const APolygon: IGeometryLonLatMultiPolygon); override;
  end;

implementation

uses
  Types,
  SysUtils,
  i_MapTypes,
  i_RegionProcessParamsFrame,
  i_RegionProcessProgressInfo,
  u_ThreadExportToCE,
  u_ResStrings,
  fr_ExportToCE;

{ TExportProviderCE }

constructor TExportProviderCE.Create(
  const AProgressFactory: IRegionProcessProgressInfoInternalFactory;
  const ALanguageManager: ILanguageManager;
  const AMainMapsConfig: IMainMapsConfig;
  const AFullMapsSet: IMapTypeSet;
  const AGUIConfigList: IMapTypeGUIConfigList;
  const AProjectionFactory: IProjectionInfoFactory;
  const AVectorGeometryProjectedFactory: IGeometryProjectedFactory;
  const ACoordConverterFactory: ICoordConverterFactory
);
begin
  inherited Create(
    AProgressFactory,
    ALanguageManager,
    AMainMapsConfig,
    AFullMapsSet,
    AGUIConfigList
  );
  FProjectionFactory := AProjectionFactory;
  FVectorGeometryProjectedFactory := AVectorGeometryProjectedFactory;
  FCoordConverterFactory := ACoordConverterFactory;
end;

function TExportProviderCE.CreateFrame: TFrame;
begin
  Result :=
    TfrExportToCE.Create(
      Self.LanguageManager,
      Self.MainMapsConfig,
      Self.FullMapsSet,
      Self.GUIConfigList,
      'd00 |*.d00',
      'd00'
    );
  Assert(Supports(Result, IRegionProcessParamsFrameZoomArray));
  Assert(Supports(Result, IRegionProcessParamsFrameOneMap));
  Assert(Supports(Result, IRegionProcessParamsFrameExportToCE));
  Assert(Supports(Result, IRegionProcessParamsFrameTargetPath));
end;

function TExportProviderCE.GetCaption: string;
begin
  Result := SAS_STR_ExportCEPackCaption;
end;

procedure TExportProviderCE.StartProcess(const APolygon: IGeometryLonLatMultiPolygon);
var
  VPath: string;
  Zoomarr: TByteDynArray;
  VMapType: IMapType;

  VMaxSize: integer;
  VComent: string;
  VRecoverInfo: boolean;

  VProgressInfo: IRegionProcessProgressInfoInternal;
  VThread: TThread;
begin
  Zoomarr := (ParamsFrame as IRegionProcessParamsFrameZoomArray).ZoomArray;
  VMapType := (ParamsFrame as IRegionProcessParamsFrameOneMap).MapType;
  VPath := (ParamsFrame as IRegionProcessParamsFrameTargetPath).Path;
  VMaxSize := (ParamsFrame as IRegionProcessParamsFrameExportToCE).MaxSize;
  VComent := (ParamsFrame as IRegionProcessParamsFrameExportToCE).Coment;
  VRecoverInfo := (ParamsFrame as IRegionProcessParamsFrameExportToCE).IsAddRecoverInfo;

  VProgressInfo := ProgressFactory.Build(APolygon);

  VThread :=
    TThreadExportToCE.Create(
      VProgressInfo,
      FCoordConverterFactory,
      FProjectionFactory,
      FVectorGeometryProjectedFactory,
      VPath,
      APolygon,
      Zoomarr,
      VMapType.TileStorage,
      VMapType.VersionRequestConfig.GetStatic,
      VMaxSize,
      VComent,
      VRecoverInfo
    );
  VThread.Resume;
end;

end.


