unit u_ThreadExportYaMobileV4;

interface

uses
  Windows,
  Types,
  SysUtils,
  Classes,
  GR32,
  YaMobileCache,
  i_BinaryData,
  i_VectorItemLonLat,
  i_NotifierOperation,
  i_BitmapTileSaveLoad,
  i_RegionProcessProgressInfo,
  i_BitmapLayerProvider,
  i_CoordConverterFactory,
  i_LocalCoordConverterFactorySimpe,
  i_VectorItmesFactory,
  u_MapType,
  u_ResStrings,
  u_ThreadExportAbstract;

type
  TExportTaskYaMobileV4 = record
    FMapId: Integer;
    FMapName: string;
    FSaver: IBitmapTileSaver;
    FImageProvider: IBitmapLayerProvider;
  end;

  TThreadExportYaMobileV4 = class(TThreadExportAbstract)
  private
    FTasks: array of TExportTaskYaMobileV4;
    FIsReplace: Boolean;
    FExportPath: string;
    FCoordConverterFactory: ICoordConverterFactory;
    FLocalConverterFactory: ILocalCoordConverterFactorySimpe;
    FProjectionFactory: IProjectionInfoFactory;
    FVectorItmesFactory: IVectorItmesFactory;
    FCacheFile: array [0..7] of TYaMobileCacheFile;
    FCacheCount: Byte;
    procedure GenUserXml(const AMapID, AMapName: string);
    function OpenCacheFile(
      const ACachePath: string;
      out ACacheFile: TYaMobileCacheFile
    ): Boolean;
    procedure CloseCacheFiles;
    procedure AddTileToCache(
      const AData: IBinaryData;
      const ATilePoint: TPoint;
      AZoom: Byte;
      AMapID: Integer
    );
  protected
    procedure ProcessRegion; override;
  public
    constructor Create(
      const ACancelNotifier: INotifierOperation;
      AOperationID: Integer;
      const AProgressInfo: IRegionProcessProgressInfoInternal;
      const ACoordConverterFactory: ICoordConverterFactory;
      const ALocalConverterFactory: ILocalCoordConverterFactorySimpe;
      const AProjectionFactory: IProjectionInfoFactory;
      const AVectorItmesFactory: IVectorItmesFactory;
      const APath: string;
      const APolygon: ILonLatPolygon;
      const Azoomarr: TByteDynArray;
      const Atypemaparr: array of TMapType;
      Areplace: boolean;
      Acsat: byte;
      Acmap: byte
    );
    destructor Destroy; override;
  end;

implementation

uses
  GR32_Resamplers,
  c_CoordConverter,
  i_CoordConverter,
  i_Bitmap32Static,
  i_VectorItemProjected,
  i_TileIterator,
  u_Bitmap32Static,
  u_TileIteratorByPolygon,
  u_BitmapLayerProviderMapWithLayer,
  u_ARGBToPaletteConverter,
  u_BitmapTileVampyreSaver;

{ TThreadExportYaMobileV4 }

constructor TThreadExportYaMobileV4.Create(
  const ACancelNotifier: INotifierOperation;
  AOperationID: Integer;
  const AProgressInfo: IRegionProcessProgressInfoInternal;
  const ACoordConverterFactory: ICoordConverterFactory;
  const ALocalConverterFactory: ILocalCoordConverterFactorySimpe;
  const AProjectionFactory: IProjectionInfoFactory;
  const AVectorItmesFactory: IVectorItmesFactory;
  const APath: string;
  const APolygon: ILonLatPolygon;
  const Azoomarr: TByteDynArray;
  const Atypemaparr: array of TMapType;
  Areplace: boolean;
  Acsat, Acmap: byte
);
var
  i: integer;
  VTaskIndex: Integer;
begin
  inherited Create(
    ACancelNotifier,
    AOperationID,
    AProgressInfo,
    APolygon,
    Azoomarr
  );
  FCoordConverterFactory := ACoordConverterFactory;
  FLocalConverterFactory := ALocalConverterFactory;
  FProjectionFactory := AProjectionFactory;
  FVectorItmesFactory := AVectorItmesFactory;
  FExportPath := APath;
  FIsReplace := AReplace;
  if (length(Atypemaparr) <> 3) then begin
    raise Exception.Create('Not expected maps count');
  end;
  if (Atypemaparr[0] = nil) and
    (Atypemaparr[1] = nil) and
    (Atypemaparr[2] = nil) then begin
    raise Exception.Create('Maps are not selected');
  end;

  VTaskIndex := -1;
  if (Atypemaparr[0] <> nil) or (Atypemaparr[2] <> nil) then begin
    Inc(VTaskIndex);
    SetLength(FTasks, VTaskIndex + 1);
    if Atypemaparr[2] <> nil then begin
      FTasks[VTaskIndex].FMapId := 12;
      FTasks[VTaskIndex].FMapName := Atypemaparr[2].GUIConfig.Name.Value;
    end else begin
      FTasks[VTaskIndex].FMapId := 10;
      FTasks[VTaskIndex].FMapName := Atypemaparr[0].GUIConfig.Name.Value;
    end;
    FTasks[VTaskIndex].FSaver := TVampyreBasicBitmapTileSaverJPG.create(Acsat);
    FTasks[VTaskIndex].FImageProvider :=
      TBitmapLayerProviderMapWithLayer.Create(
        Atypemaparr[0],
        Atypemaparr[2],
        False,
        False
      );
  end;
  if Atypemaparr[1] <> nil then begin
    Inc(VTaskIndex);
    SetLength(FTasks, VTaskIndex + 1);
    FTasks[VTaskIndex].FMapId := 11;
    FTasks[VTaskIndex].FMapName := Atypemaparr[1].GUIConfig.Name.Value;
    FTasks[VTaskIndex].FSaver := TVampyreBasicBitmapTileSaverPNGPalette.create(TARGBToPaletteConverter.Create, Acmap);
    FTasks[VTaskIndex].FImageProvider :=
      TBitmapLayerProviderMapWithLayer.Create(
        Atypemaparr[1],
        nil,
        False,
        False
      );
  end;

  for I := 0 to Length(FCacheFile) - 1 do begin
    FCacheFile[I] := nil;
  end;
  FCacheCount := 0;
end;

destructor TThreadExportYaMobileV4.Destroy;
var
  i: Integer;
begin
  for i := 0 to Length(FTasks) - 1 do begin
    FTasks[i].FMapName := '';
    FTasks[i].FSaver := nil;
    FTasks[i].FImageProvider := nil;
  end;
  inherited;
end;

function TThreadExportYaMobileV4.OpenCacheFile(
  const ACachePath: string;
  out ACacheFile: TYaMobileCacheFile
): Boolean;
var
  I: Integer;
begin
  for I := 0 to Length(FCacheFile) - 1 do begin
    if Assigned(FCacheFile[I]) then begin
      if ACachePath = FCacheFile[I].FilePath then begin
        ACacheFile := FCacheFile[I];
        Result := True;
        Exit;
      end;
    end;
  end;
  if Assigned(FCacheFile[FCacheCount]) then begin
    FreeAndNil(FCacheFile[FCacheCount]);
  end;
  FCacheFile[FCacheCount] := TYaMobileCacheFile.Create(ACachePath, FIsReplace);
  FCacheCount := FCacheCount + 1;
  if FCacheCount > Length(FCacheFile) - 1 then begin
    FCacheCount := 0;
  end;
  Result := Assigned(ACacheFile);
end;

procedure TThreadExportYaMobileV4.CloseCacheFiles;
var
  I: Integer;
begin
  for I := 0 to Length(FCacheFile) - 1 do begin
    if Assigned(FCacheFile[I]) then begin
      FreeAndNil(FCacheFile[I]);
    end;
  end;
end;

procedure TThreadExportYaMobileV4.AddTileToCache(
  const AData: IBinaryData;
  const ATilePoint: TPoint;
  AZoom: Byte;
  AMapID: Integer
);
var
  VCacheFilePath: string;
  VCacheFile: TYaMobileCacheFile;
  VTileData: TTileStream;
begin
  if Assigned(AData) then begin
    VCacheFile := nil;
    VCacheFilePath := GetFilePath(FExportPath, ATilePoint, AZoom, AMapID);
    if OpenCacheFile(VCacheFilePath, VCacheFile) then begin
      VTileData.Data := AData;
      VTileData.Point := Types.Point(ATilePoint.X mod 128, ATilePoint.Y mod 128);
      VTileData.Zoom := AZoom;
      VTileData.MapVersion := 1;
      VCacheFile.AddTile(VTileData);
      VTileData.Data := nil;
    end;
  end;
end;

procedure TThreadExportYaMobileV4.GenUserXml(const AMapID, AMapName: string);
var
  VUserXml: string;
  VUserXmlPath: string;
  VStream: TMemoryStream;
  VAddStr: string;
  BOM: array[0..2] of Byte;
  VSize: Integer;
begin
  VStream := TMemoryStream.Create;
  try
    VUserXmlPath := FExportPath + 'config' + PathDelim + 'user.xml';
    if ForceDirectories(ExtractFilePath(VUserXmlPath)) then begin
      VAddStr := '    <l id="' + AMapID + '" request="" name="' + AMapName + '" service="0" size_in_pixels="128" ver="1" />' + #10 + '</map_layers>' + #10;
      if not FileExists(VUserXmlPath) then begin
        VUserXml := '<?xml version="1.0" encoding="utf-8" ?>' + #10 + '<map_layers>' + #10 + VAddStr;
      end else begin
        VStream.LoadFromFile(VUserXmlPath);
        VStream.Position := 0;
        VStream.Read(BOM[0], 3);
        if (BOM[0] = $EF) and (BOM[1] = $BB) and (BOM[2] = $BF) then begin
          VSize := VStream.Size - 3;
          VStream.Position := 3;
        end else begin
          VSize := VStream.Size;
          VStream.Position := 0;
        end;
        SetLength(VUserXml, VSize);
        VStream.Read(Pointer(VUserXml)^, Length(VUserXml));
        VUserXml := Utf8ToAnsi(VUserXml);
        VUserXml := StringReplace(VUserXml, '</map_layers>'#10, '', [rfIgnoreCase, rfReplaceAll]);
        if VUserXml <> '' then begin
          VUserXml := VUserXml + VAddStr;
        end;
      end;
      if VUserXml <> '' then begin
        VUserXml := #239#187#191 + AnsiToUtf8(VUserXml);
        VStream.Clear;
        VStream.Position := 0;
        VStream.Write(Pointer(VUserXml)^, Length(VUserXml));
        VStream.SaveToFile(VUserXmlPath);
      end;
    end;
  finally
    FreeAndNil(VStream);
  end;
end;

procedure TThreadExportYaMobileV4.ProcessRegion;
var
  i, j, xi, yi, hxyi, sizeim: integer;
  VZoom: Byte;
  VBitmapTile: IBitmap32Static;
  bmp32crop: TCustomBitmap32;
  tc: cardinal;
  VGeoConvert: ICoordConverter;
  VTile: TPoint;
  VTileIterators: array of ITileIterator;
  VProjectedPolygon: IProjectedPolygon;
  VTilesToProcess: Int64;
  VTilesProcessed: Int64;
  VStaticBitmapCrop: IBitmap32Static;
  VDataToSave: IBinaryData;
begin
  inherited;
  hxyi := 1;
  sizeim := 128;
    bmp32crop := TCustomBitmap32.Create;
    try
      bmp32crop.Width := sizeim;
      bmp32crop.Height := sizeim;
      VGeoConvert := FCoordConverterFactory.GetCoordConverterByCode(CYandexProjectionEPSG, CTileSplitQuadrate256x256);
      VTilesToProcess := 0;
      SetLength(VTileIterators, Length(FZooms));

      for i := 0 to Length(FZooms) - 1 do begin
        VZoom := FZooms[i];
        VProjectedPolygon :=
          FVectorItmesFactory.CreateProjectedPolygonByLonLatPolygon(
            FProjectionFactory.GetByConverterAndZoom(VGeoConvert, VZoom),
            PolygLL
          );
        VTileIterators[i] := TTileIteratorByPolygon.Create(VProjectedPolygon);
        VTilesToProcess := VTilesToProcess + VTileIterators[i].TilesTotal * Length(FTasks);
      end;
      try
        VTilesProcessed := 0;

        ProgressInfo.SetCaption(SAS_STR_ExportTiles);
        ProgressInfo.SetFirstLine(
          SAS_STR_AllSaves + ' ' + inttostr(VTilesToProcess) + ' ' + SAS_STR_Files
        );
        ProgressFormUpdateOnProgress(VTilesProcessed, VTilesToProcess);

        tc := GetTickCount;
        try
          for j := 0 to length(FTasks) - 1 do begin
            GenUserXml(IntToStr(FTasks[j].FMapId), FTasks[j].FMapName);
            for i := 0 to Length(FZooms) - 1 do begin
              VZoom := FZooms[i];
              VTileIterators[i].Reset;
              while VTileIterators[i].Next(VTile) do begin
                if CancelNotifier.IsOperationCanceled(OperationID) then begin
                  exit;
                end;
                VBitmapTile :=
                  FTasks[j].FImageProvider.GetBitmapRect(
                    OperationID, CancelNotifier,
                    FLocalConverterFactory.CreateForTile(VTile, VZoom, VGeoConvert)
                  );
                if VBitmapTile <> nil then begin
                  for xi := 0 to hxyi do begin
                    for yi := 0 to hxyi do begin
                      bmp32crop.Clear;
                      BlockTransfer(
                        bmp32crop,
                        0,
                        0,
                        bmp32crop.ClipRect,
                        VBitmapTile.Bitmap,
                        bounds(sizeim * xi, sizeim * yi, sizeim, sizeim),
                        dmOpaque
                      );
                      VStaticBitmapCrop := TBitmap32Static.CreateWithCopy(bmp32crop);
                      VDataToSave := FTasks[j].FSaver.Save(VStaticBitmapCrop);
                      AddTileToCache(
                        VDataToSave,
                        Types.Point(2 * VTile.X + Xi, 2 * VTile.Y + Yi),
                        VZoom,
                        FTasks[j].FMapId
                      );
                    end;
                  end;
                end;
                inc(VTilesProcessed);
                if (GetTickCount - tc > 1000) then begin
                  tc := GetTickCount;
                  ProgressFormUpdateOnProgress(VTilesProcessed, VTilesToProcess);
                end;
              end;
            end;
          end;
        finally
          CloseCacheFiles;
        end;
      finally
        for i := 0 to Length(FZooms) - 1 do begin
          VTileIterators[i] := nil;
        end;
      end;
      ProgressFormUpdateOnProgress(VTilesProcessed, VTilesToProcess);
    finally
      bmp32crop.Free;
    end;
end;

end.
