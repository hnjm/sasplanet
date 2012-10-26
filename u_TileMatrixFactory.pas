unit u_TileMatrixFactory;

interface

uses
  Types,
  GR32,
  i_LocalCoordConverter,
  i_LocalCoordConverterFactorySimpe,
  i_ImageResamplerConfig,
  i_TileMatrix;

type
  TTileMatrixFactory = class(TInterfacedObject, ITileMatrixFactory)
  private
    FLocalConverterFactory: ILocalCoordConverterFactorySimpe;
    FImageResamplerConfig: IImageResamplerConfig;
    function BuildEmpty(
      const ATileRect: TRect;
      const ANewConverter: ILocalCoordConverter
    ): ITileMatrix;
    function BuildSameProjection(
      const ASource: ITileMatrix;
      const ATileRect: TRect;
      const ANewConverter: ILocalCoordConverter
    ): ITileMatrix;
    function BuildZoomChange(
      const ASource: ITileMatrix;
      const ATileRect: TRect;
      const ANewConverter: ILocalCoordConverter
    ): ITileMatrix;

    procedure PrepareCopyRects(
      const ASourceConverter, ATargetConverter: ILocalCoordConverter;
      out ASourceRect, ATargetRect: TRect
    );
    function PrepareElementFromSource(
      const ASource: ITileMatrix;
      const ATile: TPoint;
      AZoom: Byte;
      var AResampler: TCustomResampler
    ): ITileMatrixElement;
  private
    function BuildNewMatrix(
      const ASource: ITileMatrix;
      const ANewConverter: ILocalCoordConverter
    ): ITileMatrix;
  public
    constructor Create(
      const AImageResamplerConfig: IImageResamplerConfig;
      const ALocalConverterFactory: ILocalCoordConverterFactorySimpe
    );
  end;


implementation

uses
  GR32_Resamplers,
  t_GeoTypes,
  i_Bitmap32Static,
  i_CoordConverter,
  u_Bitmap32Static,
  u_GeoFun,
  u_BitmapFunc,
  u_TileMatrixElement,
  u_TileMatrix;

{ TTileMatrixFactory }

constructor TTileMatrixFactory.Create(
  const AImageResamplerConfig: IImageResamplerConfig;
  const ALocalConverterFactory: ILocalCoordConverterFactorySimpe
);
begin
  inherited Create;
  FImageResamplerConfig := AImageResamplerConfig;
  FLocalConverterFactory := ALocalConverterFactory;
end;

procedure TTileMatrixFactory.PrepareCopyRects(
  const ASourceConverter, ATargetConverter: ILocalCoordConverter;
  out ASourceRect, ATargetRect: TRect
);
var
  VConverter: ICoordConverter;
  VSourceMapPixelRect: TRect;
  VTargetMapPixelRect: TRect;
  VTargetAtSourceMapPixelRect: TRect;
  VSourceZoom: Byte;
  VTargetZoom: Byte;
  VResultSourceMapPixelRect: TRect;
  VResultTargetMapPixelRect: TRect;
  VRelativeRect: TDoubleRect;
begin
  VConverter := ASourceConverter.GeoConverter;
  Assert(VConverter.IsSameConverter(ATargetConverter.GeoConverter));
  VSourceZoom := ASourceConverter.Zoom;
  VTargetZoom := ATargetConverter.Zoom;
  VTargetMapPixelRect := ATargetConverter.GetRectInMapPixel;
  VRelativeRect := VConverter.PixelRect2RelativeRect(VTargetMapPixelRect, VTargetZoom);
  VTargetAtSourceMapPixelRect :=
    RectFromDoubleRect(
      VConverter.RelativeRect2PixelRectFloat(VRelativeRect, VSourceZoom),
      rrToTopLeft
    );
  VSourceMapPixelRect := ASourceConverter.GetRectInMapPixel;
  VResultSourceMapPixelRect.Left := VSourceMapPixelRect.Left;
  if VResultSourceMapPixelRect.Left < VTargetAtSourceMapPixelRect.Left then begin
    VResultSourceMapPixelRect.Left := VTargetAtSourceMapPixelRect.Left;
  end;

  VResultSourceMapPixelRect.Top := VSourceMapPixelRect.Top;
  if VResultSourceMapPixelRect.Top < VTargetAtSourceMapPixelRect.Top then begin
    VResultSourceMapPixelRect.Top := VTargetAtSourceMapPixelRect.Top;
  end;

  VResultSourceMapPixelRect.Right := VSourceMapPixelRect.Right;
  if VResultSourceMapPixelRect.Right > VTargetAtSourceMapPixelRect.Right then begin
    VResultSourceMapPixelRect.Right := VTargetAtSourceMapPixelRect.Right;
  end;

  VResultSourceMapPixelRect.Bottom := VSourceMapPixelRect.Bottom;
  if VResultSourceMapPixelRect.Bottom > VTargetAtSourceMapPixelRect.Bottom then begin
    VResultSourceMapPixelRect.Bottom := VTargetAtSourceMapPixelRect.Bottom;
  end;

  VRelativeRect := VConverter.PixelRect2RelativeRect(VResultSourceMapPixelRect, VSourceZoom);
  VResultTargetMapPixelRect :=
    RectFromDoubleRect(
      VConverter.RelativeRect2PixelRectFloat(VRelativeRect, VTargetZoom),
      rrToTopLeft
    );
  ASourceRect := ASourceConverter.MapRect2LocalRect(VResultSourceMapPixelRect);
  ATargetRect := ATargetConverter.MapRect2LocalRect(VResultTargetMapPixelRect);
end;

function TTileMatrixFactory.PrepareElementFromSource(
  const ASource: ITileMatrix;
  const ATile: TPoint;
  AZoom: Byte;
  var AResampler: TCustomResampler
): ITileMatrixElement;
var
  VConverter: ICoordConverter;
  VRelativeRectTargetTile: TDoubleRect;
  VSourceZoom: Byte;
  VTileRectSource: TRect;
  VBitmap: TCustomBitmap32;
  VBitmapStatic: IBitmap32Static;
  VX, VY: Integer;
  VSourceTile: TPoint;
  VTargetTileCoordConverter: ILocalCoordConverter;
  VSourceElement: ITileMatrixElement;
  VSourceBitmap: IBitmap32Static;
  VTargetTileSize: TPoint;
  VSrcCopyRect: TRect;
  VDstCopyRect: TRect;
begin
  Result := nil;
  VSourceZoom := ASource.LocalConverter.Zoom;
  VConverter := ASource.LocalConverter.GeoConverter;
  VRelativeRectTargetTile := VConverter.TilePos2RelativeRect(ATile, AZoom);
  VTileRectSource := RectFromDoubleRect(VConverter.RelativeRect2TileRectFloat(VRelativeRectTargetTile, VSourceZoom), rrOutside);
  VBitmap := nil;
  VBitmapStatic := nil;
  VTargetTileCoordConverter := nil;
  try
    for VX := VTileRectSource.Left to VTileRectSource.Right - 1 do begin
      VSourceTile.X := VX;
      for VY := VTileRectSource.Top to VTileRectSource.Bottom - 1 do begin
        VSourceTile.Y := VY;
        VSourceElement := ASource.GetElementByTile(VSourceTile);
        if VSourceElement <> nil then begin
          VSourceBitmap := VSourceElement.GetBitmap;
          if VSourceBitmap <> nil then begin
            if VTargetTileCoordConverter = nil then begin
              VBitmap := TCustomBitmap32.Create;
              VTargetTileCoordConverter := FLocalConverterFactory.CreateForTile(ATile, AZoom, VConverter);
              VTargetTileSize := VTargetTileCoordConverter.GetLocalRectSize;
              VBitmap.SetSize(VTargetTileSize.X, VTargetTileSize.Y);
              VBitmap.Clear(0);
            end;
            PrepareCopyRects(
              VSourceElement.LocalConverter,
              VTargetTileCoordConverter,
              VSrcCopyRect,
              VDstCopyRect
            );
            if AResampler = nil then begin
              AResampler := TNearestResampler.Create;
            end;
            Assert(AResampler <> nil);

            StretchTransfer(
              VBitmap,
              VDstCopyRect,
              VSourceBitmap,
              VSrcCopyRect,
              AResampler,
              dmOpaque
            );
          end;
        end;
      end;
    end;
    if VBitmap <> nil then begin
      VBitmapStatic := TBitmap32Static.CreateWithOwn(VBitmap);
      VBitmap := nil;
    end;
    if VBitmapStatic <> nil then begin
      Result := TTileMatrixElement.Create(ATile, VTargetTileCoordConverter, VBitmapStatic);
    end;
  finally
    VBitmap.Free;
  end;
end;

function TTileMatrixFactory.BuildNewMatrix(
  const ASource: ITileMatrix;
  const ANewConverter: ILocalCoordConverter
): ITileMatrix;
var
  VLocalConverter: ILocalCoordConverter;
  VTileRect: TRect;
  VZoom: Byte;
  VConverter: ICoordConverter;
  VMapPixelRect: TDoubleRect;
begin
  VMapPixelRect := ANewConverter.GetRectInMapPixelFloat;
  VZoom := ANewConverter.Zoom;
  VConverter := ANewConverter.GeoConverter;
  VConverter.CheckPixelRectFloat(VMapPixelRect, VZoom);
  VTileRect := RectFromDoubleRect(VConverter.PixelRectFloat2TileRectFloat(VMapPixelRect, VZoom), rrOutside);
  if DoubleRectsEqual(VMapPixelRect, DoubleRect(VConverter.TileRect2PixelRect(VTileRect, VZoom))) then begin
    VLocalConverter := ANewConverter;
  end else begin
    VLocalConverter := FLocalConverterFactory.CreateBySourceWithTileRect(ANewConverter);
    VMapPixelRect := VLocalConverter.GetRectInMapPixelFloat;
    VTileRect := RectFromDoubleRect(VConverter.PixelRectFloat2TileRectFloat(VMapPixelRect, VZoom), rrOutside);
  end;

  if ASource = nil then begin
    Result := BuildEmpty(VTileRect, VLocalConverter);
  end else if VLocalConverter.GetIsSameConverter(ASource.LocalConverter) then begin
    Result := ASource;
  end else if not VLocalConverter.GeoConverter.IsSameConverter(ASource.LocalConverter.GeoConverter) then begin
    Result := BuildEmpty(VTileRect, VLocalConverter);
  end else if VLocalConverter.Zoom = ASource.LocalConverter.Zoom then begin
    Result := BuildSameProjection(ASource, VTileRect, VLocalConverter);
  end else if VLocalConverter.Zoom + 1 = ASource.LocalConverter.Zoom then begin
    Result := BuildZoomChange(ASource, VTileRect, VLocalConverter);
  end else if VLocalConverter.Zoom = ASource.LocalConverter.Zoom + 1 then begin
    Result := BuildZoomChange(ASource, VTileRect, VLocalConverter);
  end else begin
    Result := BuildEmpty(VTileRect, VLocalConverter);
  end;
end;

function TTileMatrixFactory.BuildEmpty(
  const ATileRect: TRect;
  const ANewConverter: ILocalCoordConverter
): ITileMatrix;
begin
  Result :=
    TTileMatrix.Create(
      FLocalConverterFactory,
      ANewConverter,
      ATileRect,
      []
    );
end;

function TTileMatrixFactory.BuildSameProjection(
  const ASource: ITileMatrix;
  const ATileRect: TRect;
  const ANewConverter: ILocalCoordConverter
): ITileMatrix;
var
  VIntersectRect: TRect;
  VTile: TPoint;
  VTileCount: TPoint;
  VElements: array of ITileMatrixElement;
  i: Integer;
  VIndex: Integer;
  VX, VY: Integer;
begin
  if not Types.IntersectRect(VIntersectRect, ATileRect, ASource.TileRect) then begin
    Result := BuildEmpty(ATileRect, ANewConverter);
  end else begin
    VTileCount := Types.Point(ATileRect.Right - ATileRect.Left, ATileRect.Bottom - ATileRect.Top);
    SetLength(VElements, VTileCount.X * VTileCount.Y);
    try
      for VX := VIntersectRect.Left to VIntersectRect.Right - 1 do begin
        VTile.X := VX;
        for VY := VIntersectRect.Top to VIntersectRect.Bottom - 1 do begin
          VTile.Y := VY;
          VIndex := (VTile.Y - ATileRect.Top) * VTileCount.X + (VTile.X - ATileRect.Left);
          VElements[VIndex] := ASource.GetElementByTile(VTile);
        end;
      end;

      Result :=
        TTileMatrix.Create(
          FLocalConverterFactory,
          ANewConverter,
          ATileRect,
          VElements
        );
    finally
      for i := 0 to Length(VElements) - 1 do begin
        VElements[i] := nil;
      end;
    end;
  end;
end;

function TTileMatrixFactory.BuildZoomChange(
  const ASource: ITileMatrix;
  const ATileRect: TRect;
  const ANewConverter: ILocalCoordConverter
): ITileMatrix;
var
  VConverter: ICoordConverter;
  VZoom: Byte;
  VZoomSource: Byte;
  VRelativeRectSource: TDoubleRect;
  VTileRectSourceAtTarget: TRect;
  VIntersectRect: TRect;
  VTile: TPoint;
  VTileCount: TPoint;
  VElements: array of ITileMatrixElement;
  i: Integer;
  VIndex: Integer;
  VX, VY: Integer;
  VResampler: TCustomResampler;
begin
  VConverter := ANewConverter.GeoConverter;
  VZoom := ANewConverter.Zoom;
  VZoomSource := ASource.LocalConverter.Zoom;
  VRelativeRectSource := VConverter.TileRect2RelativeRect(ASource.TileRect, VZoomSource);
  VTileRectSourceAtTarget :=
    RectFromDoubleRect(
      VConverter.RelativeRect2TileRectFloat(VRelativeRectSource, VZoom),
      rrToTopLeft
    );
  if not Types.IntersectRect(VIntersectRect, ATileRect, VTileRectSourceAtTarget) then begin
    Result := BuildEmpty(ATileRect, ANewConverter);
  end else begin
    VTileCount := Types.Point(ATileRect.Right - ATileRect.Left, ATileRect.Bottom - ATileRect.Top);
    SetLength(VElements, VTileCount.X * VTileCount.Y);
    try
      VResampler := nil;
      try
        for VX := VIntersectRect.Left to VIntersectRect.Right - 1 do begin
          VTile.X := VX;
          for VY := VIntersectRect.Top to VIntersectRect.Bottom - 1 do begin
            VTile.Y := VY;
            VIndex := (VTile.Y - ATileRect.Top) * VTileCount.X + (VTile.X - ATileRect.Left);

            VElements[VIndex] := PrepareElementFromSource(ASource, VTile, VZoom, VResampler);
          end;
        end;
      finally
        VResampler.Free;
      end;

      Result :=
        TTileMatrix.Create(
          FLocalConverterFactory,
          ANewConverter,
          ATileRect,
          VElements
        );
    finally
      for i := 0 to Length(VElements) - 1 do begin
        VElements[i] := nil;
      end;
    end;
  end;
end;

end.
