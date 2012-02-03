unit u_ThreadMapCombineECW;

interface

uses
  Types,
  SysUtils,
  Classes,
  GR32,
  i_OperationNotifier,
  i_GlobalViewMainConfig,
  i_BitmapLayerProvider,
  i_LocalCoordConverter,
  i_VectorItemLonLat,
  i_VectorItemProjected,
  i_ImageLineProvider,
  i_LocalCoordConverterFactorySimpe,
  u_ECWWrite,
  u_MapType,
  u_GeoFun,
  t_GeoTypes,
  i_BitmapPostProcessingConfig,
  u_ResStrings,
  u_ThreadMapCombineBase;

type
  TThreadMapCombineECW = class(TThreadMapCombineBase)
  private
    FImageLineProvider: IImageLineProvider;
    FQuality: Integer;
    function ReadLine(ALine: Integer; var LineR, LineG, LineB: PLineRGB): Boolean;
  protected
    procedure SaveRect(
      AOperationID: Integer;
      ACancelNotifier: IOperationNotifier;
      AFileName: string;
      AImageProvider: IBitmapLayerProvider;
      ALocalConverter: ILocalCoordConverter;
      AConverterFactory: ILocalCoordConverterFactorySimpe
    ); override;
  public
    constructor Create(
      APolygon: ILonLatPolygon;
      ATargetConverter: ILocalCoordConverter;
      AImageProvider: IBitmapLayerProvider;
      ALocalConverterFactory: ILocalCoordConverterFactorySimpe;
      AMapCalibrationList: IInterfaceList;
      AFileName: string;
      ASplitCount: TPoint;
      AQuality: Integer
    );
  end;

implementation

uses
  LibECW,
  i_CoordConverter,
  u_ImageLineProvider;

constructor TThreadMapCombineECW.Create(
  APolygon: ILonLatPolygon;
  ATargetConverter: ILocalCoordConverter;
  AImageProvider: IBitmapLayerProvider;
  ALocalConverterFactory: ILocalCoordConverterFactorySimpe;
  AMapCalibrationList: IInterfaceList;
  AFileName: string;
  ASplitCount: TPoint;
  AQuality: Integer
);
begin
  inherited Create(
    APolygon,
    ATargetConverter,
    AImageProvider,
    ALocalConverterFactory,
    AMapCalibrationList,
    AFileName,
    ASplitCount
  );
  FQuality := AQuality;
end;

function TThreadMapCombineECW.ReadLine(ALine: Integer; var LineR, LineG,
  LineB: PLineRGB): Boolean;
type
  TBGR = packed record
    B: Byte;
    G: Byte;
    R: Byte;
  end;
  PArrayBGR = ^TArrayBGR;
  TArrayBGR = array [0..0] of TBGR;
var
  VRGB: PArrayBGR;
  i: Integer;
  VWidth: Integer;
begin
  VWidth := FImageLineProvider.LocalConverter.GetLocalRectSize.X;
  VRGB := FImageLineProvider.GetLine(OperationID, CancelNotifier,ALine);
  for i := 0 to VWidth - 1 do begin
    LineR[i] := VRGB[i].R;
    LineG[i] := VRGB[i].G;
    LineB[i] := VRGB[i].B;
  end;
  if ALine mod 256 = 0 then begin
    FTilesProcessed := ALine;
    ProgressFormUpdateOnProgress;
  end;
  Result := True;
end;

procedure TThreadMapCombineECW.SaveRect(
  AOperationID: Integer;
  ACancelNotifier: IOperationNotifier;
  AFileName: string;
  AImageProvider: IBitmapLayerProvider;
  ALocalConverter: ILocalCoordConverter;
  AConverterFactory: ILocalCoordConverterFactorySimpe
);
var
  Datum, Proj: string;
  Units: TCellSizeUnits;
  CellIncrementX, CellIncrementY, OriginX, OriginY: Double;
  errecw: integer;
  VECWWriter: TECWWrite;
  VCurrentPieceRect: TRect;
  VGeoConverter: ICoordConverter;
  VMapPieceSize: TPoint;
begin
  VECWWriter := TECWWrite.Create;
  try
    FImageLineProvider :=
      TImageLineProviderBGR.Create(
        AImageProvider,
        ALocalConverter,
        AConverterFactory
      );
    VGeoConverter := ALocalConverter.GeoConverter;
    VCurrentPieceRect := ALocalConverter.GetRectInMapPixel;
    VMapPieceSize := ALocalConverter.GetLocalRectSize;
    FTilesProcessed := 0;
    FTilesToProcess := VMapPieceSize.Y;
    Datum := 'EPSG:' + IntToStr(VGeoConverter.Datum.EPSG);
    Proj := 'EPSG:' + IntToStr(VGeoConverter.GetProjectionEPSG);
    Units := VGeoConverter.GetCellSizeUnits;
    CalculateWFileParams(
      ALocalConverter.GeoConverter.PixelPos2LonLat(VCurrentPieceRect.TopLeft, ALocalConverter.Zoom),
      ALocalConverter.GeoConverter.PixelPos2LonLat(VCurrentPieceRect.BottomRight, ALocalConverter.Zoom),
      VMapPieceSize.X, VMapPieceSize.Y, VGeoConverter,
      CellIncrementX, CellIncrementY, OriginX, OriginY
      );
    errecw :=
      VECWWriter.Encode(
        OperationID,
        CancelNotifier,
        AFileName,
        VMapPieceSize.X,
        VMapPieceSize.Y,
        101 - FQuality,
        COMPRESS_HINT_BEST,
        ReadLine,
        Datum,
        Proj,
        Units,
        CellIncrementX,
        CellIncrementY,
        OriginX,
        OriginY
      );
    if (errecw > 0) and (errecw <> 52) then begin
      raise Exception.Create(SAS_ERR_Save + ' ' + SAS_ERR_Code + inttostr(errecw));
    end;
  finally
    FreeAndNil(VECWWriter);
  end;
end;

end.
