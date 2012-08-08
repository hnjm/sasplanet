unit u_BitmapLayerProviderGridTiles;

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
  TBitmapLayerProviderGridTiles = class(TInterfacedObject, IBitmapLayerProvider)
  private
    FColor: TColor32;
    FUseRelativeZoom: Boolean;
    FZoom: Integer;
    FShowText: Boolean;
    FShowLines: Boolean;
    FCS: IReadWriteSync;
    FBitmap: TBitmap32;
    FBitmapChangeFlag: ISimpleFlag;
    procedure OnBitmapChange(Sender: TObject);
    procedure InitBitmap(const ALocalConverter: ILocalCoordConverter);
    procedure DrawLines(
      AGridZoom: Byte;
      const ALocalConverter: ILocalCoordConverter
    );
    procedure DrawCaptions(
      AOperationID: Integer;
      const ACancelNotifier: INotifierOperation;
      AGridZoom: Byte;
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
      AUseRelativeZoom: Boolean;
      AZoom: Integer;
      AShowText: Boolean;
      AShowLines: Boolean
    );
    destructor Destroy; override;
  end;

implementation

uses
  t_GeoTypes,
  i_CoordConverter,
  u_SimpleFlagWithInterlock,
  u_Bitmap32Static,
  u_GeoFun,
  u_Synchronizer;

{ TBitmapLayerProviderGridTiles }

constructor TBitmapLayerProviderGridTiles.Create(AColor: TColor32;
  AUseRelativeZoom: Boolean; AZoom: Integer; AShowText, AShowLines: Boolean);
begin
  inherited Create;
  FColor := AColor;
  FUseRelativeZoom := AUseRelativeZoom;
  FZoom := AZoom;
  FShowText := AShowText;
  FShowLines := AShowLines;

  FCS := MakeSyncRW_Var(Self, False);
  FBitmapChangeFlag := TSimpleFlagWithInterlock.Create;
  FBitmap := TBitmap32.Create;
  FBitmap.SetSize(256, 256);
  FBitmap.OnChange := Self.OnBitmapChange;
end;

destructor TBitmapLayerProviderGridTiles.Destroy;
begin
  FreeAndNil(FBitmap);
  inherited;
end;

procedure TBitmapLayerProviderGridTiles.DrawCaptions(AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  AGridZoom: Byte;
  const ALocalConverter: ILocalCoordConverter);
var
  VLoadedRect: TDoubleRect;
  VGeoConvert: ICoordConverter;
  VCurrentZoom: Byte;
  VLoadedRelativeRect: TDoubleRect;
  VTilesRect: TRect;
  i, j: integer;
  VTileIndex: TPoint;
  VTileRelativeRect: TDoubleRect;
  VPixelRectOfTile: TDoubleRect;
  VLocalRectOfTile: TDoubleRect;
  VTileSize: TDoublePoint;
  VTileCenter: TDoublePoint;
  textoutx: string;
  textouty: string;
  Sz1, Sz2: TSize;
  VOutPoint: TPoint;
begin
  VGeoConvert := ALocalConverter.GeoConverter;
  VCurrentZoom := ALocalConverter.Zoom;
  VLoadedRect := ALocalConverter.GetRectInMapPixelFloat;
  VGeoConvert.CheckPixelRectFloat(VLoadedRect, VCurrentZoom);

  VLoadedRelativeRect := VGeoConvert.PixelRectFloat2RelativeRect(VLoadedRect, VCurrentZoom);
  VTilesRect :=
    RectFromDoubleRect(
      VGeoConvert.RelativeRect2TileRectFloat(VLoadedRelativeRect, AGridZoom),
      rrOutside
    );
  for i := VTilesRect.Top to VTilesRect.Bottom - 1 do begin
    VTileIndex.Y := i;
    for j := VTilesRect.Left to VTilesRect.Right - 1 do begin
      VTileIndex.X := j;
      VTileRelativeRect := VGeoConvert.TilePos2RelativeRect(VTileIndex, AGridZoom);
      VPixelRectOfTile := VGeoConvert.RelativeRect2PixelRectFloat(VTileRelativeRect, VCurrentZoom);
      VLocalRectOfTile := ALocalConverter.MapRectFloat2LocalRectFloat(VPixelRectOfTile);
      VTileSize.X := VPixelRectOfTile.Right - VPixelRectOfTile.Left;
      VTileSize.Y := VPixelRectOfTile.Bottom - VPixelRectOfTile.Top;
      VTileCenter.X := VLocalRectOfTile.Left + VTileSize.X / 2;
      VTileCenter.Y := VLocalRectOfTile.Top + VTileSize.Y / 2;
      textoutx := 'x=' + inttostr(VTileIndex.X);
      textouty := 'y=' + inttostr(VTileIndex.Y);
      Sz1 := FBitmap.TextExtent(textoutx);
      Sz2 := FBitmap.TextExtent(textouty);
      if (Sz1.cx < VTileSize.X) and (Sz2.cx < VTileSize.X) then begin
        VOutPoint := Point(Trunc(VTileCenter.X - Sz1.cx / 2), Trunc(VTileCenter.Y - Sz1.cy));
        FBitmap.RenderText(VOutPoint.X, VOutPoint.Y, textoutx, 0, FColor);
        VOutPoint := Point(Trunc(VTileCenter.X - Sz2.cx / 2), Trunc(VTileCenter.Y));
        FBitmap.RenderText(VOutPoint.X, VOutPoint.Y, textouty, 0, FColor);
      end;
    end;
  end;
end;

procedure TBitmapLayerProviderGridTiles.DrawLines(
  AGridZoom: Byte;
  const ALocalConverter: ILocalCoordConverter);
var
  VLocalRect: TRect;
  VMapRect: TDoubleRect;
  VGeoConvert: ICoordConverter;
  VCurrentZoom: Byte;
  VRelativeRect: TDoubleRect;
  VTilesRect: TRect;
  VTilesLineRect: TRect;
  i, j: integer;
  VRelativeRectOfTilesLine: TDoubleRect;
  VMapPixelRectOfTilesLine: TDoubleRect;
  VLocalRectOfTilesLine: TRect;
begin
  VGeoConvert := ALocalConverter.GeoConverter;
  VCurrentZoom := ALocalConverter.Zoom;
  VLocalRect := ALocalConverter.GetLocalRect;
  VMapRect := ALocalConverter.GetRectInMapPixelFloat;
  VGeoConvert.CheckPixelRectFloat(VMapRect, VCurrentZoom);

  VRelativeRect := VGeoConvert.PixelRectFloat2RelativeRect(VMapRect, VCurrentZoom);
  VTilesRect :=
    RectFromDoubleRect(
      VGeoConvert.RelativeRect2TileRectFloat(VRelativeRect, AGridZoom),
      rrOutside
    );

  VTilesLineRect.Left := VTilesRect.Left;
  VTilesLineRect.Right := VTilesRect.Right;
  for i := VTilesRect.Top to VTilesRect.Bottom do begin
    VTilesLineRect.Top := i;
    VTilesLineRect.Bottom := i;

    VRelativeRectOfTilesLine := VGeoConvert.TileRect2RelativeRect(VTilesLineRect, AGridZoom);
    VMapPixelRectOfTilesLine := VGeoConvert.RelativeRect2PixelRectFloat(VRelativeRectOfTilesLine, VCurrentZoom);
    VLocalRectOfTilesLine :=
      RectFromDoubleRect(
        ALocalConverter.MapRectFloat2LocalRectFloat(VMapPixelRectOfTilesLine),
        rrToTopLeft
      );

    VLocalRectOfTilesLine.Left := VLocalRect.Left;
    VLocalRectOfTilesLine.Right := VLocalRect.Right;

    if (VLocalRectOfTilesLine.Top >= VLocalRect.Top) and
      (VLocalRectOfTilesLine.Top < VLocalRect.Bottom) then begin
      FBitmap.HorzLineTS(
        VLocalRectOfTilesLine.Left,
        VLocalRectOfTilesLine.Top,
        VLocalRectOfTilesLine.Right,
        FColor
      );
    end;
  end;

  VTilesLineRect.Top := VTilesRect.Top;
  VTilesLineRect.Bottom := VTilesRect.Bottom;
  for j := VTilesRect.Left to VTilesRect.Right do begin
    VTilesLineRect.Left := j;
    VTilesLineRect.Right := j;

    VRelativeRectOfTilesLine := VGeoConvert.TileRect2RelativeRect(VTilesLineRect, AGridZoom);
    VMapPixelRectOfTilesLine := VGeoConvert.RelativeRect2PixelRectFloat(VRelativeRectOfTilesLine, VCurrentZoom);
    VLocalRectOfTilesLine :=
      RectFromDoubleRect(
        ALocalConverter.MapRectFloat2LocalRectFloat(VMapPixelRectOfTilesLine),
        rrToTopLeft
      );

    VLocalRectOfTilesLine.Top := VLocalRect.Top;
    VLocalRectOfTilesLine.Bottom := VLocalRect.Bottom;

    if (VLocalRectOfTilesLine.Left >= VLocalRect.Left) and
      (VLocalRectOfTilesLine.Left < VLocalRect.Right) then begin
      FBitmap.VertLineTS(
        VLocalRectOfTilesLine.Left,
        VLocalRectOfTilesLine.Top,
        VLocalRectOfTilesLine.Bottom,
        FColor
      );
    end;
  end;
end;

function TBitmapLayerProviderGridTiles.GetBitmapRect(
  AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  const ALocalConverter: ILocalCoordConverter
): IBitmap32Static;
var
  VCurrentZoom: Byte;
  VGridZoom: Byte;
  VGeoConvert: ICoordConverter;
begin
  Result := nil;
  VCurrentZoom := ALocalConverter.GetZoom;
  if FUseRelativeZoom then begin
    VGridZoom := VCurrentZoom + FZoom;
  end else begin
    VGridZoom := FZoom;
  end;
  VGeoConvert := ALocalConverter.GetGeoConverter;
  if not VGeoConvert.CheckZoom(VGridZoom) then begin
    Exit;
  end;
  FCS.BeginWrite;
  try
    InitBitmap(ALocalConverter);
    FBitmapChangeFlag.CheckFlagAndReset;
    if FShowLines then begin
      DrawLines(VGridZoom, ALocalConverter);
    end;

    if FShowText then begin
      if (VGridZoom >= VCurrentZoom - 2) and (VGridZoom <= VCurrentZoom + 3) then begin
        DrawCaptions(AOperationID, ACancelNotifier, VGridZoom, ALocalConverter);
      end;
    end;
    if FBitmapChangeFlag.CheckFlagAndReset then begin
      Result := TBitmap32Static.CreateWithCopy(FBitmap);
    end;
  finally
    FCS.EndWrite;
  end;
end;

procedure TBitmapLayerProviderGridTiles.InitBitmap(
  const ALocalConverter: ILocalCoordConverter);
var
  VSize: TPoint;
begin
  VSize := ALocalConverter.GetLocalRectSize;
  FBitmap.SetSize(VSize.X, VSize.Y);
  FBitmap.Clear(0);
end;

procedure TBitmapLayerProviderGridTiles.OnBitmapChange(Sender: TObject);
begin
  FBitmapChangeFlag.SetFlag;
end;

end.
