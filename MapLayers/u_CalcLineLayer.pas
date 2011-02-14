unit u_CalcLineLayer;

interface

uses
  Types,
  GR32,
  GR32_Polygons,
  GR32_Image,
  t_GeoTypes,
  i_IViewPortState,
  i_ILocalCoordConverter,
  i_ICalcLineLayerConfig,
  u_ClipPolygonByRect,
  u_MapLayerBasic;

type
  TCalcLineLayer = class(TMapLayerBasicFullView)
  private
    FConfig: ICalcLineLayerConfig;

    FSourcePolygon: TDoublePointArray;
    FDistArray: TDoubleDynArray;
    FPolyActivePointIndex: integer;
    FBitmapSize: TPoint;
    FPointsOnBitmap: TDoublePointArray;
    FPolygon: TPolygon32;


    procedure PaintLayer(Sender: TObject; Buffer: TBitmap32);
    function LonLatArrayToVisualFloatArray(ALocalConverter: ILocalCoordConverter; APolygon: TDoublePointArray): TDoublePointArray;
    procedure OnConfigChange(Sender: TObject);

    procedure DrawPolyPoint(
      ABuffer: TBitmap32;
      const ABitmapSize: TPoint;
      const APosOnBitmap: TDoublePoint;
      const ASize: Integer;
      const AFillColor: TColor32;
      const ARectColor: TColor32
    );
    procedure PreparePolygon;
  protected
    procedure DoRedraw; override;
    procedure DoScaleChange(ANewVisualCoordConverter: ILocalCoordConverter); override;
    procedure DoPosChange(ANewVisualCoordConverter: ILocalCoordConverter); override;
  public
    constructor Create(AParentMap: TImage32; AViewPortState: IViewPortState; AConfig: ICalcLineLayerConfig);
    destructor Destroy; override;
    procedure DrawLineCalc(APathLonLat: TDoublePointArray; AActiveIndex: Integer);
    procedure DrawNothing;
  end;

implementation

uses
  SysUtils,
  GR32_Layers,
  i_ICoordConverter,
  i_IValueToStringConverter,
  i_IDatum,
  u_NotifyEventListener,
  u_GlobalState,
  UResStrings;

{ TCalcLineLayer }

constructor TCalcLineLayer.Create(AParentMap: TImage32;
  AViewPortState: IViewPortState; AConfig: ICalcLineLayerConfig);
begin
  inherited Create(TPositionedLayer.Create(AParentMap.Layers), AViewPortState);
  FConfig := AConfig;
  LayerPositioned.OnPaint := PaintLayer;
  LinksList.Add(
    TNotifyEventListener.Create(Self.OnConfigChange),
    FConfig.GetChangeNotifier
  );
end;

destructor TCalcLineLayer.Destroy;
begin
  FreeAndNil(FPolygon);
  inherited;
end;

procedure TCalcLineLayer.DoPosChange(
  ANewVisualCoordConverter: ILocalCoordConverter);
begin
  inherited;
  Redraw;
end;

procedure TCalcLineLayer.DoRedraw;
begin
  inherited;
  PreparePolygon;
  LayerPositioned.Changed;
end;

procedure TCalcLineLayer.DoScaleChange(
  ANewVisualCoordConverter: ILocalCoordConverter);
begin
  inherited;
  Redraw;
end;

procedure TCalcLineLayer.DrawLineCalc(APathLonLat: TDoublePointArray;
  AActiveIndex: Integer);
var
  VPointsCount: Integer;
begin
  FSourcePolygon := Copy(APathLonLat);
  FPolyActivePointIndex := AActiveIndex;

  VPointsCount := Length(FSourcePolygon);
  if VPointsCount > 0 then begin
    Redraw;
    Show;
  end else begin
    Hide;
  end;
end;

procedure TCalcLineLayer.DrawNothing;
begin
  Hide;
end;

procedure TCalcLineLayer.DrawPolyPoint(
  ABuffer: TBitmap32;
  const ABitmapSize: TPoint;
  const APosOnBitmap: TDoublePoint;
  const ASize: Integer;
  const AFillColor, ARectColor: TColor32
);
var
  VHalfSize: Double;
  VRect: TRect;
  VRectFloat: TDoubleRect;
begin
  VHalfSize := ASize / 2;
  VRectFloat.Left := APosOnBitmap.X - VHalfSize;
  VRectFloat.Top := APosOnBitmap.Y - VHalfSize;
  VRectFloat.Right := VRectFloat.Left + ASize;
  VRectFloat.Bottom := VRectFloat.Top + ASize;
  if
    (VRectFloat.Left > 0) and
    (VRectFloat.Top > 0) and
    (VRectFloat.Right < ABitmapSize.X) and
    (VRectFloat.Bottom < ABitmapSize.Y)
  then begin
    VRect.Left := Trunc(VRectFloat.Left);
    VRect.Top := Trunc(VRectFloat.Top);
    VRect.Right := Trunc(VRectFloat.Right);
    VRect.Bottom := Trunc(VRectFloat.Bottom);
    ABuffer.FillRectS(VRect, ARectColor);
    if AFillColor <> ARectColor then begin
      Inc(VRect.Left);
      Inc(VRect.Top);
      Dec(VRect.Right);
      Dec(VRect.Bottom);
      ABuffer.FillRectS(VRect, AFillColor);
    end;
  end;
end;

function TCalcLineLayer.LonLatArrayToVisualFloatArray(
  ALocalConverter: ILocalCoordConverter;
  APolygon: TDoublePointArray
): TDoublePointArray;
var
  i: Integer;
  VPointsCount: Integer;
  VLonLat: TDoublePoint;
  VGeoConvert: ICoordConverter;
begin
  VPointsCount := Length(APolygon);
  SetLength(Result, VPointsCount);

  VGeoConvert := ALocalConverter.GetGeoConverter;
  for i := 0 to VPointsCount - 1 do begin
    VLonLat := APolygon[i];
    VGeoConvert.CheckLonLatPos(VLonLat);
    Result[i] := ALocalConverter.LonLat2LocalPixelFloat(VLonLat);
  end;
end;

procedure TCalcLineLayer.OnConfigChange(Sender: TObject);
begin
  Redraw;
end;

procedure TCalcLineLayer.PaintLayer(Sender: TObject; Buffer: TBitmap32);
var
  i, textW: integer;
  k1: TDoublePoint;
  len: Double;
  text: string;
  VPointsCount: Integer;
  VValueConverter: IValueToStringConverter;

  VLenShow: Boolean;
  VLineColor: TColor32;
  VPointFillColor: TColor32;
  VPointRectColor: TColor32;
  VPointFirstColor: TColor32;
  VPointActiveColor: TColor32;
  VPointSize: integer;
  VTextColor: TColor32;
  VTextBGColor: TColor32;
begin
  VPointsCount := Length(FSourcePolygon);
  if VPointsCount > 0 then begin
    FConfig.LockRead;
    try
      VLenShow := FConfig.LenShow;
      VLineColor := FConfig.LineColor;
      VPointFillColor := FConfig.PointFillColor;
      VPointRectColor := FConfig.PointRectColor;
      VPointFirstColor := FConfig.PointFirstColor;
      VPointActiveColor := FConfig.PointActiveColor;
      VPointSize := FConfig.PointSize;
      VTextColor := FConfig.TextColor;
      VTextBGColor := FConfig.TextBGColor;
    finally
      FConfig.UnlockRead;
    end;

    VValueConverter := GState.ValueToStringConverterConfig.GetStaticConverter;
    FPolygon.DrawFill(Buffer, VLineColor);


    for i := 0 to VPointsCount - 2 do begin
      k1 := FPointsOnBitmap[i + 1];
      if ((k1.x > 0) and (k1.y > 0)) and ((k1.x < FBitmapSize.X) and (k1.y < FBitmapSize.Y)) then begin
        if i = VPointsCount - 2 then begin
          len := FDistArray[VPointsCount - 1];
          text := SAS_STR_Whole + ': ' + VValueConverter.DistConvert(len);
          Buffer.Font.Size := 9;
          textW := Buffer.TextWidth(text) + 11;
          Buffer.FillRectS(
            Trunc(k1.x + 12),
            Trunc(k1.y),
            Trunc(k1.X + textW),
            Trunc(k1.y + 15),
            VTextBGColor
          );
          Buffer.RenderText(
            Trunc(k1.X + 15),
            Trunc(k1.y),
            text,
            3,
            VTextColor
          );
        end else begin
          if VLenShow then begin
            text := VValueConverter.DistConvert(FDistArray[i + 1] - FDistArray[i]);
            Buffer.Font.Size := 7;
            textW := Buffer.TextWidth(text) + 11;
            Buffer.FillRectS(
              Trunc(k1.x + 5),
              Trunc(k1.y + 5),
              Trunc(k1.X + textW),
              Trunc(k1.y + 16),
              VTextBGColor
            );
            Buffer.RenderText(
              Trunc(k1.X + 8),
              Trunc(k1.y + 5),
              text,
              0,
              VTextColor
            );
          end;
        end;
        DrawPolyPoint(Buffer, FBitmapSize, k1, VPointSize, VPointFillColor, VPointRectColor);
      end;
    end;
    k1 := FPointsOnBitmap[0];
    DrawPolyPoint(Buffer, FBitmapSize, k1, VPointSize, VPointFirstColor, VPointFirstColor);
    k1 := FPointsOnBitmap[FPolyActivePointIndex];
    DrawPolyPoint(Buffer, FBitmapSize, k1, VPointSize, VPointActiveColor, VPointActiveColor);
  end;
end;

procedure TCalcLineLayer.PreparePolygon;
var
  VPointsCount: Integer;
  VLocalConverter: ILocalCoordConverter;
  VPolygon: TPolygon32;
  i: Integer;
  VPathFixedPoints: TArrayOfFixedPoint;
  VBitmapClip: IPolyClip;
  VPointsProcessedCount: Integer;
  VPointsOnBitmapPrepared: TDoublePointArray;
  VDatum: IDatum;
begin
  VPointsCount := Length(FSourcePolygon);
  if VPointsCount > 0 then begin
    VLocalConverter := FVisualCoordConverter;
    VBitmapClip := TPolyClipByRect.Create(VLocalConverter.GetLocalRect);

    VDatum := VLocalConverter.GetGeoConverter.Datum;
    SetLength(FDistArray, VPointsCount);
    FDistArray[0] := 0;
    for i := 1 to VPointsCount - 1 do begin
      FDistArray[i] := FDistArray[i - 1] + VDatum.CalcDist(FSourcePolygon[i - 1], FSourcePolygon[i]);
    end;

    FPointsOnBitmap := LonLatArrayToVisualFloatArray(VLocalConverter, FSourcePolygon);
    FBitmapSize := VLocalConverter.GetLocalRectSize;

    VPointsProcessedCount := VBitmapClip.Clip(FPointsOnBitmap, VPointsCount, VPointsOnBitmapPrepared);
    if VPointsProcessedCount > 0 then begin
      SetLength(VPathFixedPoints, VPointsProcessedCount);
      for i := 0 to VPointsProcessedCount - 1 do begin
        VPathFixedPoints[i] := FixedPoint(VPointsOnBitmapPrepared[i].X, VPointsOnBitmapPrepared[i].Y);
      end;
      VPolygon := TPolygon32.Create;
      try
        VPolygon.Antialiased := true;
        VPolygon.AntialiasMode := am4times;
        VPolygon.Closed := False;
        VPolygon.AddPoints(VPathFixedPoints[0], VPointsProcessedCount);
        with VPolygon.Outline do try
          FreeAndNil(FPolygon);
          FPolygon := Grow(Fixed(FConfig.LineWidth / 2), 0.5);
        finally
          free;
        end;
      finally
        VPolygon.Free;
      end;
    end;
  end;
end;

end.
