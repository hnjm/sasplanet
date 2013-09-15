unit u_ThreadExportKML;

interface

uses
  Types,
  SysUtils,
  Classes,
  GR32,
  i_NotifierOperation,
  i_RegionProcessProgressInfo,
  i_CoordConverterFactory,
  i_VectorItemsFactory,
  i_VectorItemLonLat,
  u_MapType,
  u_ResStrings,
  t_GeoTypes,
  u_ThreadExportAbstract;

type
  TThreadExportKML = class(TThreadExportAbstract)
  private
    FMapType: TMapType;
    FProjectionFactory: IProjectionInfoFactory;
    FVectorGeometryProjectedFactory: IVectorGeometryProjectedFactory;
    FNotSaveNotExists: boolean;
    FPathExport: string;
    FRelativePath: boolean;
    FTilesToProcess: Int64;
    FTilesProcessed: Int64;
    procedure KmlFileWrite(
      AKmlStream: TStream;
      const ATile: TPoint;
      AZoom, level: byte
    );
  protected
    procedure ProcessRegion; override;
  public
    constructor Create(
      const AProgressInfo: IRegionProcessProgressInfoInternal;
      const APath: string;
      const AProjectionFactory: IProjectionInfoFactory;
      const AVectorGeometryProjectedFactory: IVectorGeometryProjectedFactory;
      const APolygon: ILonLatPolygon;
      const Azoomarr: TByteDynArray;
      AMapType: TMapType;
      ANotSaveNotExists: boolean;
      ARelativePath: boolean
    );
  end;

implementation

uses
  u_GeoToStr,
  i_TileIterator,
  u_TileIteratorByPolygon,
  u_GeoFun,
  i_VectorItemProjected,
  i_CoordConverter;

constructor TThreadExportKML.Create(
  const AProgressInfo: IRegionProcessProgressInfoInternal;
  const APath: string;
  const AProjectionFactory: IProjectionInfoFactory;
  const AVectorGeometryProjectedFactory: IVectorGeometryProjectedFactory;
  const APolygon: ILonLatPolygon;
  const Azoomarr: TByteDynArray;
  AMapType: TMapType;
  ANotSaveNotExists: boolean;
  ARelativePath: boolean
);
begin
  inherited Create(
    AProgressInfo,
    APolygon,
    Azoomarr,
    Self.ClassName
  );
  FProjectionFactory := AProjectionFactory;
  FVectorGeometryProjectedFactory := AVectorGeometryProjectedFactory;
  FPathExport := APath;
  FNotSaveNotExists := ANotSaveNotExists;
  FRelativePath := ARelativePath;
  FMapType := AMapType;
end;

procedure TThreadExportKML.KmlFileWrite(
  AKmlStream: TStream;
  const ATile: TPoint;
  AZoom, level: byte
);
var
  VZoom: Byte;
  xi, yi: integer;
  savepath, north, south, east, west: string;
  VText: UTF8String;
  VTileRect: TRect;
  VExtRect: TDoubleRect;
begin
  //TODO: ����� ������ �� ������ ����� ����� ����� � ���� ������
  if (FNotSaveNotExists) and (not (FMapType.TileExists(ATile, AZoom))) then begin
    exit;
  end;
  savepath := FMapType.GetTileFileName(ATile, AZoom);
  if FRelativePath then begin
    savepath := ExtractRelativePath(ExtractFilePath(FPathExport), savepath);
  end;
  VExtRect := FMapType.GeoConvert.TilePos2LonLatRect(ATile, AZoom);

  north := R2StrPoint(VExtRect.Top);
  south := R2StrPoint(VExtRect.Bottom);
  east := R2StrPoint(VExtRect.Right);
  west := R2StrPoint(VExtRect.Left);
  VText := #13#10;
  VText := VText + AnsiToUtf8('<Folder>') + #13#10;
  VText := VText + AnsiToUtf8('  <Region>') + #13#10;
  VText := VText + AnsiToUtf8('    <LatLonAltBox>') + #13#10;
  VText := VText + AnsiToUtf8('      <north>' + north + '</north>') + #13#10;
  VText := VText + AnsiToUtf8('      <south>' + south + '</south>') + #13#10;
  VText := VText + AnsiToUtf8('      <east>' + east + '</east>') + #13#10;
  VText := VText + AnsiToUtf8('      <west>' + west + '</west>') + #13#10;
  VText := VText + AnsiToUtf8('    </LatLonAltBox>') + #13#10;
  VText := VText + AnsiToUtf8('    <Lod>') + #13#10;
  if level > 1 then begin
    VText := VText + AnsiToUtf8('      <minLodPixels>128</minLodPixels>') + #13#10;
  end else begin
    VText := VText + AnsiToUtf8('      <minLodPixels>16</minLodPixels>') + #13#10;
  end;
  VText := VText + AnsiToUtf8('      <maxLodPixels>-1</maxLodPixels>') + #13#10;
  VText := VText + AnsiToUtf8('    </Lod>') + #13#10;
  VText := VText + AnsiToUtf8('  </Region>') + #13#10;
  VText := VText + AnsiToUtf8('  <GroundOverlay>') + #13#10;
  VText := VText + AnsiToUtf8('    <drawOrder>' + inttostr(level) + '</drawOrder>') + #13#10;
  VText := VText + AnsiToUtf8('    <Icon>') + #13#10;
  VText := VText + AnsiToUtf8('      <href>' + savepath + '</href>') + #13#10;
  VText := VText + AnsiToUtf8('    </Icon>') + #13#10;
  VText := VText + AnsiToUtf8('    <LatLonBox>') + #13#10;
  VText := VText + AnsiToUtf8('      <north>' + north + '</north>') + #13#10;
  VText := VText + AnsiToUtf8('      <south>' + south + '</south>') + #13#10;
  VText := VText + AnsiToUtf8('      <east>' + east + '</east>') + #13#10;
  VText := VText + AnsiToUtf8('      <west>' + west + '</west>') + #13#10;
  VText := VText + AnsiToUtf8('    </LatLonBox>') + #13#10;
  VText := VText + AnsiToUtf8('  </GroundOverlay>');
  AKmlStream.WriteBuffer(VText[1], Length(VText));
  inc(FTilesProcessed);
  if FTilesProcessed mod 100 = 0 then begin
    ProgressFormUpdateOnProgress(FTilesProcessed, FTilesToProcess);
  end;
  if level < Length(FZooms) then begin
    VZoom := FZooms[level];
    VTileRect :=
      RectFromDoubleRect(
        FMapType.GeoConvert.RelativeRect2TileRectFloat(FMapType.GeoConvert.TilePos2RelativeRect(ATile, AZoom), VZoom),
        rrClosest
      );
    for xi := VTileRect.Left to VTileRect.Right - 1 do begin
      for yi := VTileRect.Top to VTileRect.Bottom - 1 do begin
        KmlFileWrite(AKmlStream, Point(xi, yi), VZoom, level + 1);
      end;
    end;
  end;
  VText := #13#10;
  VText := VText + AnsiToUtf8('</Folder>');
  AKmlStream.WriteBuffer(VText[1], Length(VText));
end;

procedure TThreadExportKML.ProcessRegion;
var
  i: integer;
  VZoom: Byte;
  VText: UTF8String;
  VProjectedPolygon: IProjectedPolygon;
  VTempIterator: ITileIterator;
  VIterator: ITileIterator;
  VTile: TPoint;
  VKMLStream: TFileStream;
begin
  inherited;
  FTilesToProcess := 0;
  if Length(FZooms) > 0 then begin
    VZoom := FZooms[0];
    VProjectedPolygon :=
      FVectorGeometryProjectedFactory.CreateProjectedPolygonByLonLatPolygon(
        FProjectionFactory.GetByConverterAndZoom(FMapType.GeoConvert, VZoom),
        PolygLL
      );
    VIterator := TTileIteratorByPolygon.Create(VProjectedPolygon);
    FTilesToProcess := FTilesToProcess + VIterator.TilesTotal;
    for i := 0 to Length(FZooms) - 1 do begin
      VZoom := FZooms[i];
      VProjectedPolygon :=
        FVectorGeometryProjectedFactory.CreateProjectedPolygonByLonLatPolygon(
          FProjectionFactory.GetByConverterAndZoom(FMapType.GeoConvert, VZoom),
          PolygLL
        );
      VTempIterator := TTileIteratorByPolygon.Create(VProjectedPolygon);
      FTilesToProcess := FTilesToProcess + VTempIterator.TilesTotal;
    end;
  end;
  FTilesProcessed := 0;
  ProgressInfo.SetCaption(SAS_STR_ExportTiles);
  ProgressInfo.SetFirstLine(
    SAS_STR_AllSaves + ' ' + inttostr(FTilesToProcess) + ' ' + SAS_STR_Files
  );
  ProgressFormUpdateOnProgress(FTilesProcessed, FTilesToProcess);
  try
    VKMLStream := TFileStream.Create(FPathExport, fmCreate);
    try
      VText := '';
      VText := VText + AnsiToUtf8('<?xml version="1.0" encoding="UTF-8"?>') + #13#10;
      VText := VText + AnsiToUtf8('<kml xmlns="http://earth.google.com/kml/2.1">') + #13#10;
      VText := VText + AnsiToUtf8('<Document>') + #13#10;
      VText := VText + AnsiToUtf8('<name>' + ExtractFileName(FPathExport) + '</name>') + #13#10;
      VKMLStream.WriteBuffer(VText[1], Length(VText));

      VZoom := FZooms[0];
      while VIterator.Next(VTile) do begin
        if not CancelNotifier.IsOperationCanceled(OperationID) then begin
          KmlFileWrite(VKMLStream, VTile, VZoom, 1);
        end;
      end;
      VText := #13#10 + AnsiToUtf8('</Document>') + #13#10;
      VText := VText + AnsiToUtf8('</kml>') + #13#10;
      VKMLStream.WriteBuffer(VText[1], Length(VText));
    finally
      VKMLStream.Free;
    end;
  finally
    ProgressFormUpdateOnProgress(FTilesProcessed, FTilesToProcess);
  end;
end;

end.
