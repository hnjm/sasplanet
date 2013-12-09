unit u_ProjectedGeometryProvider;

interface

uses
  t_Hash,
  i_ProjectionInfo,
  i_VectorItemLonLat,
  i_VectorItemProjected,
  i_ProjectedGeometryProvider,
  i_HashFunction,
  i_VectorItemsFactory,
  u_HashCacheWithQueuesAbstract;

type
  TProjectedGeometryProvider = class(THashCacheWithQueuesAbstract, IProjectedGeometryProvider)
  private
    FHashFunction: IHashFunction;
    FVectorGeometryProjectedFactory: IVectorGeometryProjectedFactory;
  private
    function GetProjectedPath(
      const AProjectionInfo: IProjectionInfo;
      const ALine: IGeometryLonLatMultiLine
    ): IProjectedPath;
    function GetProjectedPolygon(
      const AProjectionInfo: IProjectionInfo;
      const ALine: IGeometryLonLatMultiPolygon
    ): IProjectedPolygon;
  protected
    function CreateByKey(
      const AKey: THashValue;
      AData: Pointer
    ): IInterface; override;
  public
    constructor Create(
      const AHashFunction: IHashFunction;
      const AVectorGeometryProjectedFactory: IVectorGeometryProjectedFactory
    );
  end;

implementation

uses
  t_GeoTypes,
  i_CoordConverter;

type
  PDataRecord = ^TDataRecord;
  TDataRecord = record
    Path: IGeometryLonLatMultiLine;
    Polygon: IGeometryLonLatMultiPolygon;
    ProjectionInfo: IProjectionInfo;
  end;


{ TProjectedGeometryProvider }

const
  CMinProjectedSize = 10;

constructor TProjectedGeometryProvider.Create(
  const AHashFunction: IHashFunction;
  const AVectorGeometryProjectedFactory: IVectorGeometryProjectedFactory
);
begin
  inherited Create(14, 1000, 4000, 1000); // 2^14 elements in hash-table
  FHashFunction := AHashFunction;
  FVectorGeometryProjectedFactory := AVectorGeometryProjectedFactory;
end;

function TProjectedGeometryProvider.CreateByKey(
  const AKey: THashValue;
  AData: Pointer
): IInterface;
var
  VData: PDataRecord;
  VResultPath: IProjectedPath;
  VResultPolygon: IProjectedPolygon;
  VGeoConverter: ICoordConverter;
  VTestArrLenLonLatRect: TDoubleRect;
  VTestArrLenPixelRect: TDoubleRect;
begin
  Result := nil;
  VData := PDataRecord(AData);
  VGeoConverter := VData^.ProjectionInfo.GeoConverter;
  if Assigned(VData^.Path) then begin
    VTestArrLenLonLatRect := VData^.Path.Bounds.Rect;
    VGeoConverter.CheckLonLatRect(VTestArrLenLonLatRect);
    VTestArrLenPixelRect :=
      VGeoConverter.LonLatRect2PixelRectFloat(
        VTestArrLenLonLatRect,
        VData^.ProjectionInfo.Zoom
      );
    if
      (abs(VTestArrLenPixelRect.Left - VTestArrLenPixelRect.Right) > CMinProjectedSize) or
      (abs(VTestArrLenPixelRect.Top - VTestArrLenPixelRect.Bottom) > CMinProjectedSize)
    then begin
      VResultPath :=
        FVectorGeometryProjectedFactory.CreateProjectedPathByLonLatPath(
          VData^.ProjectionInfo,
          VData^.Path
        );
    end else begin
      VResultPath :=
        FVectorGeometryProjectedFactory.CreateProjectedPath(
          VData^.ProjectionInfo,
          nil,
          0
        );
    end;
    Result := VResultPath;
  end else if Assigned(VData^.Polygon) then begin
    VTestArrLenLonLatRect := VData^.Polygon.Bounds.Rect;
    VGeoConverter.CheckLonLatRect(VTestArrLenLonLatRect);
    VTestArrLenPixelRect :=
      VGeoConverter.LonLatRect2PixelRectFloat(
        VTestArrLenLonLatRect,
        VData^.ProjectionInfo.Zoom
      );
    if
      (abs(VTestArrLenPixelRect.Left - VTestArrLenPixelRect.Right) > CMinProjectedSize) or
      (abs(VTestArrLenPixelRect.Top - VTestArrLenPixelRect.Bottom) > CMinProjectedSize)
    then begin
      VResultPolygon :=
        FVectorGeometryProjectedFactory.CreateProjectedPolygonByLonLatPolygon(
          VData^.ProjectionInfo,
          VData^.Polygon
        );
    end else begin
      VResultPolygon :=
        FVectorGeometryProjectedFactory.CreateProjectedPolygon(
          VData^.ProjectionInfo,
          nil,
          0
        );
    end;
    Result := VResultPolygon;
  end;
end;

function TProjectedGeometryProvider.GetProjectedPath(
  const AProjectionInfo: IProjectionInfo;
  const ALine: IGeometryLonLatMultiLine
): IProjectedPath;
var
  VHash: THashValue;
  VData: TDataRecord;
begin
  VHash := $fbcb5f3e1bef5742;
  FHashFunction.UpdateHashByHash(VHash, ALine.Hash);
  FHashFunction.UpdateHashByHash(VHash, AProjectionInfo.Hash);
  VData.Path := ALine;
  VData.Polygon := nil;
  VData.ProjectionInfo := AProjectionInfo;

  Result := IProjectedPath(GetOrCreateItem(VHash, @VData));
end;

function TProjectedGeometryProvider.GetProjectedPolygon(
  const AProjectionInfo: IProjectionInfo;
  const ALine: IGeometryLonLatMultiPolygon
): IProjectedPolygon;
var
  VHash: THashValue;
  VData: TDataRecord;
begin
  VHash := $5af2a0463bf6e921;
  FHashFunction.UpdateHashByHash(VHash, ALine.Hash);
  FHashFunction.UpdateHashByHash(VHash, AProjectionInfo.Hash);
  VData.Path := nil;
  VData.Polygon := ALine;
  VData.ProjectionInfo := AProjectionInfo;

  Result := IProjectedPolygon(GetOrCreateItem(VHash, @VData));
end;

end.
