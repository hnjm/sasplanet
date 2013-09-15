unit u_ThreadExportEnumerator;

interface

uses
  Types,
  SysUtils,
  Classes,
  i_NotifierOperation,
  i_RegionProcessProgressInfo,
  i_CoordConverterFactory,
  i_VectorItemsFactory,
  i_VectorItemLonLat,
  i_TileInfoBasic,
  i_TileStorage,
  i_MapTypes,
  u_MapType,
  u_ResStrings,
  u_ThreadExportAbstract;

type
  PExportEnumeratorData = ^TExportEnumeratorData;
  TExportEnumeratorData = record
  public
    procedure Uninit;
  end;
  
  PExportEnumeratorTile = ^TExportEnumeratorTile;
  TExportEnumeratorTile = packed record
    Tile: TPoint;
    Zoom: Byte;
    DelSrc: Boolean; // output
  end;

  TThreadExportEnumerator = class(TThreadExportAbstract)
  protected
    FMapTypeArr: IMapTypeListStatic;
    FProjectionFactory: IProjectionInfoFactory;
    FVectorGeometryProjectedFactory: IVectorGeometryProjectedFactory;
    FConfigPath, FExportPath: string;
    FParamAuxValue: String;
    FParamAuxEnabled: Boolean;
    FForceDropTarget: Boolean;
    FIsMove: boolean;
    FIsReplace: boolean;
  protected
    // enum source tiles
    procedure ProcessRegion; override;
    // init and uninit ExportEnumerator data
    procedure InitializeExportEnumeratorData(out AEEData: PExportEnumeratorData); virtual; abstract;
    procedure UninitializeExportEnumeratorData(var AEEData: PExportEnumeratorData); virtual; abstract;
    // create storage
    procedure CreateTargetStorage(
      const ASourceMapType: TMapType;
      const AEEData: PExportEnumeratorData
    ); virtual; abstract;
    // put tile to storage
    procedure SaveTileToTargetStorage(
      const ASourceMapType: TMapType;
      const AEEData: PExportEnumeratorData;
      const AEETile: PExportEnumeratorTile;
      const ATileInfo: ITileInfoWithData
    ); virtual; abstract;
  public
    constructor Create(
      const AProgressInfo: IRegionProcessProgressInfoInternal;
      const AConfigPath, AExportPath: string;
      const AProjectionFactory: IProjectionInfoFactory;
      const AVectorGeometryProjectedFactory: IVectorGeometryProjectedFactory;
      const APolygon: ILonLatPolygon;
      const AZoomArr: TByteDynArray;
      const AMapTypeArr: IMapTypeListStatic;
      const AParamAuxEnabled: Boolean;
      const AParamAuxValue: String;
      const AForceDropTarget: Boolean;
      const AMove, AReplace: boolean
    );
  end;

implementation

uses
  i_VectorItemProjected,
  i_CoordConverter,
  i_MapVersionInfo,
  i_TileIterator,
  u_TileIteratorByPolygon;

constructor TThreadExportEnumerator.Create(
  const AProgressInfo: IRegionProcessProgressInfoInternal;
  const AConfigPath, AExportPath: string;
  const AProjectionFactory: IProjectionInfoFactory;
  const AVectorGeometryProjectedFactory: IVectorGeometryProjectedFactory;
  const APolygon: ILonLatPolygon;
  const AZoomArr: TByteDynArray;
  const AMapTypeArr: IMapTypeListStatic;
  const AParamAuxEnabled: Boolean;
  const AParamAuxValue: String;
  const AForceDropTarget: Boolean;
  const AMove, AReplace: boolean
);
begin
  inherited Create(
    AProgressInfo,
    APolygon,
    AZoomArr,
    Self.ClassName
  );
  FProjectionFactory := AProjectionFactory;
  FVectorGeometryProjectedFactory := AVectorGeometryProjectedFactory;
  FConfigPath := AConfigPath;
  FExportPath := AExportPath;
  FParamAuxValue := AParamAuxValue;
  FParamAuxEnabled := AParamAuxEnabled;
  FForceDropTarget := AForceDropTarget;
  FIsMove := AMove;
  FIsReplace := AReplace;
  FMapTypeArr := AMapTypeArr;
end;

procedure TThreadExportEnumerator.ProcessRegion;
var
  i, j: integer;
  VMapType: TMapType;
  VGeoConvert: ICoordConverter;
  VTileIterators: array of array of ITileIterator;
  VTileIterator: ITileIterator;
  VProjectedPolygon: IProjectedPolygon;
  VTilesToProcess: Int64;
  VTilesProcessed: Int64;
  VTileInfo: ITileInfoWithData;
  VSourceVersion: IMapVersionInfo;
  VEEData: PExportEnumeratorData;
  VEETile: TExportEnumeratorTile;
begin
  inherited;
  SetLength(VTileIterators, FMapTypeArr.Count, Length(FZooms));
  VTilesToProcess := 0;

  for j := 0 to FMapTypeArr.Count - 1 do begin
    for i := 0 to Length(FZooms) - 1 do begin
      VEETile.Zoom := FZooms[i];
      VMapType := FMapTypeArr.Items[j].MapType;
      // ����� ����������
      VGeoConvert := VMapType.GeoConvert;
      VProjectedPolygon := FVectorGeometryProjectedFactory.CreateProjectedPolygonByLonLatPolygon(
        FProjectionFactory.GetByConverterAndZoom(VGeoConvert, VEETile.Zoom),
        PolygLL
      );
      VTileIterators[j, i] := TTileIteratorByPolygon.Create(VProjectedPolygon);
      VTilesToProcess := VTilesToProcess + VTileIterators[j, i].TilesTotal;
    end;
  end;
  
  VEEData := nil;
  InitializeExportEnumeratorData(VEEData);
  try
    ProgressInfo.SetCaption(SAS_STR_ExportTiles);
    ProgressInfo.SetFirstLine(
      SAS_STR_AllSaves + ' ' + inttostr(VTilesToProcess) + ' ' + SAS_STR_Files
    );
    VTilesProcessed := 0;
    ProgressFormUpdateOnProgress(VTilesProcessed, VTilesToProcess);
    for j := 0 to FMapTypeArr.Count - 1 do begin
      // source map
      VMapType := FMapTypeArr.Items[j].MapType;
      // source version
      VSourceVersion := VMapType.VersionConfig.Version;

      // build storage
      CreateTargetStorage(VMapType, VEEData);

      // loop through zooms
      for i := 0 to Length(FZooms) - 1 do begin
        VEETile.Zoom := FZooms[i];
        VTileIterator := VTileIterators[j, i];
        if (VTileIterator<>nil) then
        while VTileIterator.Next(VEETile.Tile) do begin
          if CancelNotifier.IsOperationCanceled(OperationID) then begin
            exit;
          end;
          if Supports(VMapType.TileStorage.GetTileInfo(VEETile.Tile, VEETile.Zoom, VSourceVersion, gtimWithData), ITileInfoWithData, VTileInfo) then begin
            // ����� ���� � ������� ���������
            SaveTileToTargetStorage(VMapType, VEEData, @VEETile, VTileInfo);
            // ��������� ����� ���� ������� ��������
            if (VEETile.DelSrc) then begin
              VEETile.DelSrc := FALSE;
              VMapType.TileStorage.DeleteTile(VEETile.Tile, VEETile.Zoom, VSourceVersion);
            end;
          end;
          inc(VTilesProcessed);
          if VTilesProcessed mod 100 = 0 then begin
            ProgressFormUpdateOnProgress(VTilesProcessed, VTilesToProcess);
          end;
        end;
      end;
    end;
  finally
    UninitializeExportEnumeratorData(VEEData);
    for j := 0 to FMapTypeArr.Count - 1 do begin
      for i := 0 to Length(FZooms) - 1 do begin
        VTileIterators[j, i] := nil;
      end;
    end;
    VTileIterators := nil;
  end;
end;

{ TExportEnumeratorData }

procedure TExportEnumeratorData.Uninit;
begin

end;

end.


