unit u_MapLayerFillingMap;

interface

uses  
  GR32,
  GR32_Image,
  i_JclNotify,
  i_OperationNotifier,
  i_LocalCoordConverter,
  i_LocalCoordConverterFactorySimpe,
  i_InternalPerformanceCounter,
  i_ImageResamplerConfig,
  i_ViewPortState,
  i_FillingMapLayerConfig,
  u_MapType,
  u_MapLayerWithThreadDraw;

type
  TMapLayerFillingMap = class(TMapLayerWithThreadDraw)
  private
    FConfig: IFillingMapLayerConfig;
    FConfigStatic: IFillingMapLayerConfigStatic;
    procedure OnConfigChange;
  protected
    procedure DrawBitmap(
      AOperationID: Integer;
      ACancelNotifier: IOperationNotifier
    ); override;
    function GetVisibleForNewPos(ANewVisualCoordConverter: ILocalCoordConverter): Boolean; override;
  public
    constructor Create(
      APerfList: IInternalPerformanceCounterList;
      AAppClosingNotifier: IJclNotifier;
      AParentMap: TImage32;
      AViewPortState: IViewPortState;
      AResamplerConfig: IImageResamplerConfig;
      AConverterFactory: ILocalCoordConverterFactorySimpe;
      ATimerNoifier: IJclNotifier;
      AConfig: IFillingMapLayerConfig
    );
    procedure StartThreads; override;
  end;

implementation

uses
  Classes,
  t_GeoTypes,
  i_CoordConverter,
  i_TileIterator,
  u_NotifyEventListener,
  u_TileIteratorSpiralByRect;

{ TMapLayerFillingMap }

constructor TMapLayerFillingMap.Create(
  APerfList: IInternalPerformanceCounterList;
  AAppClosingNotifier: IJclNotifier;
  AParentMap: TImage32;
  AViewPortState: IViewPortState;
  AResamplerConfig: IImageResamplerConfig;
  AConverterFactory: ILocalCoordConverterFactorySimpe;
  ATimerNoifier: IJclNotifier;
  AConfig: IFillingMapLayerConfig
);
begin
  inherited Create(
    APerfList,
    AAppClosingNotifier,
    AParentMap,
    AViewPortState,
    AResamplerConfig,
    AConverterFactory,
    ATimerNoifier,
    tpLowest
  );
  FConfig := AConfig;

  LinksList.Add(
    TNotifyNoMmgEventListener.Create(OnConfigChange),
    FConfig.GetChangeNotifier
  );
end;

procedure TMapLayerFillingMap.StartThreads;
begin
  inherited;
  OnConfigChange;
end;

procedure TMapLayerFillingMap.DrawBitmap(
  AOperationID: Integer;
  ACancelNotifier: IOperationNotifier
);
var
  VZoom: Byte;
  VZoomSource: Byte;
  VSourceMapType: TMapType;
  VBmp: TCustomBitmap32;

  {
    ������������� �������� ������ � ����������� ������� �������� �����
  }
  VBitmapOnMapPixelRect: TDoubleRect;

  {
    �������������� ���������� ������
  }
  VSourceLonLatRect: TDoubleRect;

  {
    ������������� �������� �������� ����, ����������� �����, � ������������
    ����� ��� ������� �������� ���� ����������
  }
  VPixelSourceRect: TRect;

  {
    ������������� ������ �������� ����, ����������� �����, � ������������
    �����, ��� ������� �������� ���� ����������
  }
  VTileSourceRect: TRect;
  {
    ������� ���� � ������������ �����, ��� ������� �������� ���� ����������
  }
  VTile: TPoint;
  {
    ������������� ������� �������� ����� � ������������ �����,
    ��� ������� �������� ���� ����������
  }
  VCurrTilePixelRectSource: TRect;
  {
    ������������� ������� �������� ����� � ������������ ������� �����
  }
  VCurrTilePixelRect: TRect;
  {
    ������������� ������� �������� ����� � ������������ �������� ������
  }
  VCurrTilePixelRectAtBitmap: TRect;

  {
    ������������� ����� ���������� ����������� �� ������� �����
  }
  VTilePixelsToDraw: TRect;

  VLocalConverter: ILocalCoordConverter;
  VSourceGeoConvert: ICoordConverter;
  VGeoConvert: ICoordConverter;
  VTileIterator: ITileIterator;
  VConfig: IFillingMapLayerConfigStatic;
  VLonLatRect: TDoubleRect;
begin
  inherited;

  VConfig := FConfigStatic;
  VLocalConverter := LayerCoordConverter;
  if (VConfig <> nil) and (VLocalConverter <> nil) then begin
    VBmp := TCustomBitmap32.Create;
    try
      VZoom := VLocalConverter.GetZoom;
      VZoomSource := VConfig.GetActualZoom(VLocalConverter);
      VSourceMapType := VConfig.SourceMap.MapType;
      VSourceGeoConvert := VSourceMapType.GeoConvert;
      VGeoConvert := VLocalConverter.GetGeoConverter;

      VBitmapOnMapPixelRect := VLocalConverter.GetRectInMapPixelFloat;
      if not ACancelNotifier.IsOperationCanceled(AOperationID) then begin
        VGeoConvert.CheckPixelRectFloat(VBitmapOnMapPixelRect, VZoom);
        VSourceLonLatRect := VGeoConvert.PixelRectFloat2LonLatRect(VBitmapOnMapPixelRect, VZoom);
        VSourceGeoConvert.CheckLonLatRect(VSourceLonLatRect);
        VPixelSourceRect := VSourceGeoConvert.LonLatRect2PixelRect(VSourceLonLatRect, VZoom);
        VTileSourceRect := VSourceGeoConvert.PixelRect2TileRect(VPixelSourceRect, VZoom);
        VTileIterator := TTileIteratorSpiralByRect.Create(VTileSourceRect);
        while VTileIterator.Next(VTile) do begin
          if ACancelNotifier.IsOperationCanceled(AOperationID) then begin
            break;
          end;
          VCurrTilePixelRectSource := VSourceGeoConvert.TilePos2PixelRect(VTile, VZoom);
          VTilePixelsToDraw.TopLeft := Point(0, 0);
          VTilePixelsToDraw.Right := VCurrTilePixelRectSource.Right - VCurrTilePixelRectSource.Left;
          VTilePixelsToDraw.Bottom := VCurrTilePixelRectSource.Bottom - VCurrTilePixelRectSource.Top;

          if VCurrTilePixelRectSource.Left < VPixelSourceRect.Left then begin
            VTilePixelsToDraw.Left := VPixelSourceRect.Left - VCurrTilePixelRectSource.Left;
            VCurrTilePixelRectSource.Left := VPixelSourceRect.Left;
          end;

          if VCurrTilePixelRectSource.Top < VPixelSourceRect.Top then begin
            VTilePixelsToDraw.Top := VPixelSourceRect.Top - VCurrTilePixelRectSource.Top;
            VCurrTilePixelRectSource.Top := VPixelSourceRect.Top;
          end;

          if VCurrTilePixelRectSource.Right > VPixelSourceRect.Right then begin
            VTilePixelsToDraw.Right := VPixelSourceRect.Right - VCurrTilePixelRectSource.Left;
            VCurrTilePixelRectSource.Right := VPixelSourceRect.Right;
          end;

          if VCurrTilePixelRectSource.Bottom > VPixelSourceRect.Bottom then begin
            VTilePixelsToDraw.Bottom := VPixelSourceRect.Bottom - VCurrTilePixelRectSource.Top;
            VCurrTilePixelRectSource.Bottom := VPixelSourceRect.Bottom;
          end;

          if VSourceGeoConvert.IsSameConverter(VGeoConvert) then begin
            VCurrTilePixelRect := VCurrTilePixelRectSource;
          end else begin
            VLonLatRect := VSourceGeoConvert.PixelRect2LonLatRect(VCurrTilePixelRectSource, VZoom);
            VGeoConvert.CheckLonLatRect(VLonLatRect);
            VCurrTilePixelRect := VGeoConvert.LonLatRect2PixelRect(VLonLatRect, VZoom);
          end;

          VCurrTilePixelRectAtBitmap.TopLeft := VLocalConverter.MapPixel2LocalPixel(VCurrTilePixelRect.TopLeft);
          VCurrTilePixelRectAtBitmap.BottomRight := VLocalConverter.MapPixel2LocalPixel(VCurrTilePixelRect.BottomRight);

          if ACancelNotifier.IsOperationCanceled(AOperationID) then begin
            break;
          end;
          if VSourceMapType.LoadFillingMap(AOperationID, ACancelNotifier, VBmp, VTile, VZoom, VZoomSource, VConfig.Colorer) then begin
            Layer.Bitmap.Lock;
            try
              if not ACancelNotifier.IsOperationCanceled(AOperationID) then begin
                Layer.Bitmap.Draw(VCurrTilePixelRectAtBitmap, VTilePixelsToDraw, Vbmp);
                SetBitmapChanged;
              end;
            finally
              Layer.Bitmap.UnLock;
            end;
          end;
        end;
      end;
    finally
      VBmp.Free;
    end;
  end;
end;

function TMapLayerFillingMap.GetVisibleForNewPos(
  ANewVisualCoordConverter: ILocalCoordConverter): Boolean;
var
  VConfig: IFillingMapLayerConfigStatic;
begin
  Result := False;
  VConfig := FConfigStatic;
  if VConfig <> nil then begin
    Result := VConfig.Visible;
    if Result then begin
      Result := ANewVisualCoordConverter.GetZoom <= VConfig.GetActualZoom(ANewVisualCoordConverter);
    end;
  end;
end;

procedure TMapLayerFillingMap.OnConfigChange;
begin
  ViewUpdateLock;
  try
    SetNeedRedraw;
    FConfigStatic := FConfig.GetStatic;
    SetVisible(GetVisibleForNewPos(ViewCoordConverter));
  finally
    ViewUpdateUnlock;
  end;
  ViewUpdate;
end;

end.
