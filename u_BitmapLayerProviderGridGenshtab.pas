unit u_BitmapLayerProviderGridGenshtab;

interface

uses
  Types,
  SysUtils,
  GR32,
  i_SimpleFlag,
  i_NotifierOperation,
  i_LocalCoordConverter,
  i_Bitmap32Static,
  i_BitmapLayerProvider;

type
  TBitmapLayerProviderGridGenshtab = class(TInterfacedObject, IBitmapLayerProvider)
  private
    FColor: TColor32;
    FShowText: Boolean;
    FShowLines: Boolean;
    FScale: Integer;

    FCS: IReadWriteSync;
    FBitmap: TBitmap32;
    FBitmapChangeFlag: ISimpleFlag;
    procedure OnBitmapChange(Sender: TObject);
    procedure InitBitmap(const ALocalConverter: ILocalCoordConverter);
    procedure DrawLines(
      const ALocalConverter: ILocalCoordConverter
    );
    procedure DrawCaptions(
      AOperationID: Integer;
      const ACancelNotifier: INotifierOperation;
      const ALocalConverter: ILocalCoordConverter
    );
  private
    function GetBitmapRect(
      AOperationID: Integer;
      const ACancelNotifier: INotifierOperation;
      const ALocalConverter: ILocalCoordConverter
    ): IBitmap32Static;
  public
    constructor Create(
      AColor: TColor32;
      AScale: Integer;
      AShowText: Boolean;
      AShowLines: Boolean
    );
    destructor Destroy; override;
  end;

implementation

uses
  Math,
  t_GeoTypes,
  i_CoordConverter,
  u_SimpleFlagWithInterlock,
  u_Bitmap32Static,
  u_GeoFun,
  u_GeoToStr,
  u_Synchronizer;

{ TBitmapLayerProviderGridGenshtab }

constructor TBitmapLayerProviderGridGenshtab.Create(AColor: TColor32;
  AScale: Integer; AShowText, AShowLines: Boolean);
begin
  inherited Create;
  FColor := AColor;
  FScale := AScale;
  FShowText := AShowText;
  FShowLines := AShowLines;

  FCS := MakeSyncRW_Var(Self, False);
  FBitmapChangeFlag := TSimpleFlagWithInterlock.Create;
  FBitmap := TBitmap32.Create;
  FBitmap.SetSize(256, 256);
  FBitmap.OnChange := Self.OnBitmapChange;
end;

destructor TBitmapLayerProviderGridGenshtab.Destroy;
begin
  FreeAndNil(FBitmap);
  inherited;
end;

procedure TBitmapLayerProviderGridGenshtab.DrawCaptions(AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  const ALocalConverter: ILocalCoordConverter
);
var
  VLocalRect: TRect;
  z: TDoublePoint;
  VZoom: Byte;
  VLoadedRect: TDoubleRect;
  VLoadedLonLatRect: TDoubleRect;
  VGridLonLatRect: TDoubleRect;
  VLonLatRectOfCell: TDoubleRect;
  VLocalRectOfCell: TDoubleRect;
  VGeoConvert: ICoordConverter;
  VGridRect: TRect;
  i, j: Integer;
  VTextSize: TSize;
  VListName: String;
  VLonLatCenter: TDoublePoint;
  VLocalCellCenter: TDoublePoint;
  VOutPoint: TPoint;
begin
  z := GetGhBordersStepByScale(FScale);
  VGeoConvert := ALocalConverter.GetGeoConverter;
  VZoom := ALocalConverter.GetZoom;
  VLocalRect := ALocalConverter.GetLocalRect;
  VLoadedRect := ALocalConverter.GetRectInMapPixelFloat;

  VGeoConvert.CheckPixelRectFloat(VLoadedRect, VZoom);

  VLoadedLonLatRect := VGeoConvert.PixelRectFloat2LonLatRect(VLoadedRect, VZoom);
  if VLoadedLonLatRect.Top > 90 then begin
    VLoadedLonLatRect.Top := 90;
  end;
  if VLoadedLonLatRect.Bottom < -90 then begin
    VLoadedLonLatRect.Bottom := -90;
  end;
  VGridRect.Left := Floor(VLoadedLonLatRect.Left / z.X);
  VGridRect.Top := Ceil(VLoadedLonLatRect.Top / z.Y);
  VGridRect.Right := Ceil(VLoadedLonLatRect.Right / z.X);
  VGridRect.Bottom := Floor(VLoadedLonLatRect.Bottom / z.Y);

  VGridLonLatRect.Left := VGridRect.Left * z.X;
  VGridLonLatRect.Top := VGridRect.Top * z.Y;
  VGridLonLatRect.Right := VGridRect.Right * z.X;
  VGridLonLatRect.Bottom := VGridRect.Bottom * z.Y;

  VLonLatRectOfCell.TopLeft := VGridLonLatRect.TopLeft;
  VLonLatRectOfCell.BottomRight := DoublePoint(VGridLonLatRect.Left + z.X, VGridLonLatRect.Top - z.Y);
  VGeoConvert.CheckLonLatRect(VLonLatRectOfCell);
  VLocalRectOfCell := ALocalConverter.LonLatRect2LocalRectFloat(VLonLatRectOfCell);
  if abs(VLocalRectOfCell.Right - VLocalRectOfCell.Left) < 30 then begin
    exit;
  end;
  VLonLatRectOfCell.Right := VGridLonLatRect.Left;
  for i := VGridRect.Left + 1 to VGridRect.Right do begin
    VLonLatRectOfCell.Left := VLonLatRectOfCell.Right;
    VLonLatRectOfCell.Right := i * z.X;
    VLonLatRectOfCell.Top := VGridLonLatRect.Bottom;
    for j := VGridRect.Bottom + 1 to VGridRect.Top do begin
      VLonLatRectOfCell.Bottom := VLonLatRectOfCell.Top;
      VLonLatRectOfCell.Top := j * z.Y;
      VGeoConvert.CheckLonLatRect(VLonLatRectOfCell);

      VLonLatCenter := RectCenter(VLonLatRectOfCell);
      VListName := LonLat2GShListName(VLonLatCenter, FScale, 100000000);

      VTextSize := FBitmap.TextExtent(VListName);

      VLocalRectOfCell := ALocalConverter.LonLatRect2LocalRectFloat(VLonLatRectOfCell);
      VLocalCellCenter := RectCenter(VLocalRectOfCell);
      VOutPoint := Point(Trunc(VLocalCellCenter.X - VTextSize.cx / 2), Trunc(VLocalCellCenter.Y - VTextSize.cy));
      FBitmap.RenderText(VOutPoint.X, VOutPoint.Y, VListName, 0, FColor);
    end;
  end;
end;

procedure TBitmapLayerProviderGridGenshtab.DrawLines(
  const ALocalConverter: ILocalCoordConverter
);
var
  VLocalRect: TRect;
  z: TDoublePoint;
  VZoom: Byte;
  VLoadedRect: TDoubleRect;
  VLoadedLonLatRect: TDoubleRect;
  VGridLonLatRect: TDoubleRect;
  VLonLatRectOfCellsLine: TDoubleRect;
  VLocalRectOfCellsLine: TRect;
  VGeoConvert: ICoordConverter;
  VGridRect: TRect;
  i: Integer;
begin
  z := GetGhBordersStepByScale(FScale);
  VGeoConvert := ALocalConverter.GetGeoConverter;
  VZoom := ALocalConverter.GetZoom;
  VLocalRect := ALocalConverter.GetLocalRect;
  VLoadedRect := ALocalConverter.GetRectInMapPixelFloat;

  VGeoConvert.CheckPixelRectFloat(VLoadedRect, VZoom);

  VLoadedLonLatRect := VGeoConvert.PixelRectFloat2LonLatRect(VLoadedRect, VZoom);
  if VLoadedLonLatRect.Top > 90 then begin
    VLoadedLonLatRect.Top := 90;
  end;
  if VLoadedLonLatRect.Bottom < -90 then begin
    VLoadedLonLatRect.Bottom := -90;
  end;
  VGridRect.Left := Floor(VLoadedLonLatRect.Left / z.X);
  VGridRect.Top := Ceil(VLoadedLonLatRect.Top / z.Y);
  VGridRect.Right := Ceil(VLoadedLonLatRect.Right / z.X);
  VGridRect.Bottom := Floor(VLoadedLonLatRect.Bottom / z.Y);

  VGridLonLatRect.Left := VGridRect.Left * z.X;
  VGridLonLatRect.Top := VGridRect.Top * z.Y;
  VGridLonLatRect.Right := VGridRect.Right * z.X;
  VGridLonLatRect.Bottom := VGridRect.Bottom * z.Y;

  VLonLatRectOfCellsLine.TopLeft := VGridLonLatRect.TopLeft;
  VLonLatRectOfCellsLine.BottomRight := DoublePoint(VGridLonLatRect.Left + z.X, VGridLonLatRect.Top - z.Y);
  VGeoConvert.CheckLonLatRect(VLonLatRectOfCellsLine);
  VLocalRectOfCellsLine :=
    RectFromDoubleRect(
      ALocalConverter.LonLatRect2LocalRectFloat(VLonLatRectOfCellsLine),
      rrToTopLeft
    );
  if abs(VLocalRectOfCellsLine.Right - VLocalRectOfCellsLine.Left) < 4 then begin
    exit;
  end;

  for i := VGridRect.Left to VGridRect.Right do begin
    VLonLatRectOfCellsLine.Left := i * z.X;
    VLonLatRectOfCellsLine.Top := VGridLonLatRect.Top;
    VLonLatRectOfCellsLine.Right := VLonLatRectOfCellsLine.Left;
    VLonLatRectOfCellsLine.Bottom := VGridLonLatRect.Bottom;
    VGeoConvert.CheckLonLatRect(VLonLatRectOfCellsLine);
    VLocalRectOfCellsLine :=
      RectFromDoubleRect(
        ALocalConverter.LonLatRect2LocalRectFloat(VLonLatRectOfCellsLine),
        rrToTopLeft
      );
    VLocalRectOfCellsLine.Top := VLocalRect.Top;
    VLocalRectOfCellsLine.Bottom := VLocalRect.Bottom;

    if (VLocalRectOfCellsLine.Left >= VLocalRect.Left) and
      (VLocalRectOfCellsLine.Left < VLocalRect.Right) then begin
      FBitmap.VertLineTS(
        VLocalRectOfCellsLine.Left,
        VLocalRectOfCellsLine.Top,
        VLocalRectOfCellsLine.Bottom,
        FColor
      );
    end;
  end;

  for i := VGridRect.Bottom to VGridRect.Top do begin
    VLonLatRectOfCellsLine.Left := VGridLonLatRect.Left;
    VLonLatRectOfCellsLine.Top := i * z.Y;
    VLonLatRectOfCellsLine.Right := VGridLonLatRect.Right;
    VLonLatRectOfCellsLine.Bottom := VLonLatRectOfCellsLine.Top;

    VGeoConvert.CheckLonLatRect(VLonLatRectOfCellsLine);
    VLocalRectOfCellsLine :=
      RectFromDoubleRect(
        ALocalConverter.LonLatRect2LocalRectFloat(VLonLatRectOfCellsLine),
        rrToTopLeft
      );
    VLocalRectOfCellsLine.Left := VLocalRect.Left;
    VLocalRectOfCellsLine.Right := VLocalRect.Right;

    if (VLocalRectOfCellsLine.Top >= VLocalRect.Top) and
      (VLocalRectOfCellsLine.Bottom < VLocalRect.Bottom) then begin
      FBitmap.HorzLineTS(
        VLocalRectOfCellsLine.Left,
        VLocalRectOfCellsLine.Top,
        VLocalRectOfCellsLine.Right,
        FColor
      );
    end;
  end;
end;

function TBitmapLayerProviderGridGenshtab.GetBitmapRect(AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  const ALocalConverter: ILocalCoordConverter): IBitmap32Static;
begin
  Result := nil;
  FCS.BeginWrite;
  try
    InitBitmap(ALocalConverter);
    FBitmapChangeFlag.CheckFlagAndReset;
    if FShowLines then begin
      DrawLines(ALocalConverter);
    end;

    if FShowText then begin
      DrawCaptions(AOperationID, ACancelNotifier, ALocalConverter);
    end;
    if FBitmapChangeFlag.CheckFlagAndReset then begin
      Result := TBitmap32Static.CreateWithCopy(FBitmap);
    end;
  finally
    FCS.EndWrite;
  end;
end;

procedure TBitmapLayerProviderGridGenshtab.InitBitmap(
  const ALocalConverter: ILocalCoordConverter);
var
  VSize: TPoint;
begin
  VSize := ALocalConverter.GetLocalRectSize;
  FBitmap.SetSize(VSize.X, VSize.Y);
  FBitmap.Clear(0);
end;

procedure TBitmapLayerProviderGridGenshtab.OnBitmapChange(Sender: TObject);
begin
  FBitmapChangeFlag.SetFlag;
end;

end.
