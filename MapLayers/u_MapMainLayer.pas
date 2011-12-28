unit u_MapMainLayer;

interface

uses
  Windows,
  
  GR32,
  GR32_Image,
  i_JclNotify,
  i_CoordConverter,
  i_LocalCoordConverterFactorySimpe,
  i_InternalPerformanceCounter,
  i_OperationNotifier,
  i_LayerBitmapClearStrategy,
  i_LocalCoordConverter,
  i_MapTypes,
  i_ActiveMapsConfig,
  i_ViewPortState,
  i_ImageResamplerConfig,
  i_GlobalViewMainConfig,
  i_BitmapPostProcessingConfig,
  i_TileError,
  u_MapType,
  u_MapLayerWithThreadDraw;

type
  TMapMainLayer = class(TMapLayerTiledWithThreadDraw)
  private
    FErrorLogger: ITileErrorLogger;
    FMapsConfig: IMainMapsConfig;
    FPostProcessingConfig:IBitmapPostProcessingConfig;
    FViewConfig: IGlobalViewMainConfig;
    FMainMap: IMapType;
    FLayersSet: IMapTypeSet;
    FUsePrevZoomAtMap: Boolean;
    FUsePrevZoomAtLayer: Boolean;

    FTileUpdateCounter: Integer;
    FTileChangeListener: IJclListener;
    procedure OnTileChange;
    procedure OnTimer;

    function DrawMap(
      ATargetBmp: TCustomBitmap32;
      AMapType: TMapType;
      AGeoConvert: ICoordConverter;
      AZoom: Byte;
      ATile: TPoint;
      ADrawMode: TDrawMode;
      AUsePre: Boolean;
      ARecolorConfig: IBitmapPostProcessingConfigStatic
    ): Boolean;
    procedure OnMainMapChange;
    procedure OnLayerSetChange;
    procedure OnConfigChange;
  protected
    procedure DrawBitmap(
      AOperationID: Integer;
      ACancelNotifier: IOperationNotifier
    ); override;
    procedure SetLayerCoordConverter(AValue: ILocalCoordConverter); override;
  public
    constructor Create(
      APerfList: IInternalPerformanceCounterList;
      AAppClosingNotifier: IJclNotifier;
      AParentMap: TImage32;
      AViewPortState: IViewPortState;
      AResamplerConfig: IImageResamplerConfig;
      AConverterFactory: ILocalCoordConverterFactorySimpe;
      AClearStrategyFactory: ILayerBitmapClearStrategyFactory;
      AMapsConfig: IMainMapsConfig;
      APostProcessingConfig:IBitmapPostProcessingConfig;
      AViewConfig: IGlobalViewMainConfig;
      AErrorLogger: ITileErrorLogger;
      ATimerNoifier: IJclNotifier
    );
    procedure StartThreads; override;
    procedure SendTerminateToThreads; override;
  end;

implementation

uses
  ActiveX,
  Classes,
  SysUtils,
  t_GeoTypes,
  i_TileIterator,
  i_TileRectUpdateNotifier,
  u_ResStrings,
  u_TileErrorInfo,
  u_NotifyEventListener,
  u_TileIteratorSpiralByRect;

{ TMapMainLayer }

constructor TMapMainLayer.Create(
  APerfList: IInternalPerformanceCounterList;
  AAppClosingNotifier: IJclNotifier;
  AParentMap: TImage32;
  AViewPortState: IViewPortState;
  AResamplerConfig: IImageResamplerConfig;
  AConverterFactory: ILocalCoordConverterFactorySimpe;
  AClearStrategyFactory: ILayerBitmapClearStrategyFactory;
  AMapsConfig: IMainMapsConfig;
  APostProcessingConfig: IBitmapPostProcessingConfig;
  AViewConfig: IGlobalViewMainConfig;
  AErrorLogger: ITileErrorLogger;
  ATimerNoifier: IJclNotifier
);
begin
  inherited Create(
    APerfList,
    AAppClosingNotifier,
    AParentMap,
    AViewPortState,
    AResamplerConfig,
    AConverterFactory,
    AClearStrategyFactory,
    ATimerNoifier,
    tpLower
  );
  FMapsConfig := AMapsConfig;
  FErrorLogger := AErrorLogger;
  FPostProcessingConfig := APostProcessingConfig;
  FViewConfig := AViewConfig;

  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnMainMapChange),
    FMapsConfig.GetActiveMap.GetChangeNotifier
  );

  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnLayerSetChange),
    FMapsConfig.GetActiveBitmapLayersSet.GetChangeNotifier
  );

  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnConfigChange),
    FViewConfig.GetChangeNotifier
  );

  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnConfigChange),
    FPostProcessingConfig.GetChangeNotifier
  );
  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnTimer),
    ATimerNoifier
  );
  FTileChangeListener := TNotifyNoMmgEventListener.Create(Self.OnTileChange);
  FTileUpdateCounter := 0;
end;

procedure TMapMainLayer.DrawBitmap(
  AOperationID: Integer;
  ACancelNotifier: IOperationNotifier
);
var
  i: Cardinal;
  VMapType: TMapType;
  VGUID: TGUID;
  VItem: IMapType;
  VEnum: IEnumGUID;
  VLayersSet: IMapTypeSet;
  VRecolorConfig: IBitmapPostProcessingConfigStatic;
  VTileToDrawBmp: TCustomBitmap32;

  VGeoConvert: ICoordConverter;
  VBitmapConverter: ILocalCoordConverter;
  VTileIterator: ITileIterator;
  VZoom: Byte;
  { ������������� �������� ������ � ����������� ��������� ���������� }
  VBitmapOnMapPixelRect: TRect;
  { ������������� ������ �������� ����, ����������� �����, � ������������
    ��������� ���������� }
  VTileSourceRect: TRect;
  { ������� ���� � ������������ ��������� ���������� }
  VTile: TPoint;
  { ������������� ������� �������� ����� � ������������ ��������� ���������� }
  VCurrTilePixelRect: TRect;
  { ������������� ����� ���������� ����������� �� ������� ����� }
  VTilePixelsToDraw: TRect;
  { ������������� �������� � ������� ����� ���������� ������� ���� }
  VCurrTileOnBitmapRect: TRect;
  VTileIsEmpty: Boolean;
begin
  VRecolorConfig := FPostProcessingConfig.GetStatic;

  VBitmapConverter := LayerCoordConverter;
  VGeoConvert := VBitmapConverter.GetGeoConverter;
  VZoom := VBitmapConverter.GetZoom;

  VBitmapOnMapPixelRect := VBitmapConverter.GetRectInMapPixel;
  VGeoConvert.CheckPixelRect(VBitmapOnMapPixelRect, VZoom);

  VTileSourceRect := VGeoConvert.PixelRect2TileRect(VBitmapOnMapPixelRect, VZoom);
  VTileIterator := TTileIteratorSpiralByRect.Create(VTileSourceRect);

  VTileToDrawBmp := TCustomBitmap32.Create;
  try
    if not ACancelNotifier.IsOperationCanceled(AOperationID) then begin
      while VTileIterator.Next(VTile) do begin
        if ACancelNotifier.IsOperationCanceled(AOperationID) then begin
          break;
        end;
        VCurrTilePixelRect := VGeoConvert.TilePos2PixelRect(VTile, VZoom);

        VTilePixelsToDraw.TopLeft := Point(0, 0);
        VTilePixelsToDraw.Right := VCurrTilePixelRect.Right - VCurrTilePixelRect.Left;
        VTilePixelsToDraw.Bottom := VCurrTilePixelRect.Bottom - VCurrTilePixelRect.Top;

        VCurrTileOnBitmapRect.TopLeft := VBitmapConverter.MapPixel2LocalPixel(VCurrTilePixelRect.TopLeft);
        VCurrTileOnBitmapRect.BottomRight := VBitmapConverter.MapPixel2LocalPixel(VCurrTilePixelRect.BottomRight);

        VTileToDrawBmp.SetSize(VTilePixelsToDraw.Right, VTilePixelsToDraw.Bottom);
        VTileIsEmpty := True;
        if FMainMap <> nil then begin
          if DrawMap(VTileToDrawBmp, FMainMap.MapType, VGeoConvert, VZoom, VTile, dmOpaque, FUsePrevZoomAtMap, VRecolorConfig) then begin
            VTileIsEmpty := False;
          end else begin
            VTileToDrawBmp.Clear(0);
          end;
        end;
        if ACancelNotifier.IsOperationCanceled(AOperationID) then begin
          break;
        end;

        VLayersSet := FLayersSet;
        if VLayersSet <> nil then begin
          VEnum := VLayersSet.GetIterator;
          while VEnum.Next(1, VGUID, i) = S_OK do begin
            VItem := VLayersSet.GetMapTypeByGUID(VGUID);
            VMapType := VItem.GetMapType;
            if VMapType.IsBitmapTiles then begin
              if DrawMap(VTileToDrawBmp, VMapType, VGeoConvert, VZoom, VTile, dmBlend, FUsePrevZoomAtLayer, VRecolorConfig) then begin
                VTileIsEmpty := False;
              end;
            end;
            if ACancelNotifier.IsOperationCanceled(AOperationID) then begin
              break;
            end;
          end;
        end;

        if not VTileIsEmpty then begin
          VRecolorConfig.ProcessBitmap(VTileToDrawBmp);
          if ACancelNotifier.IsOperationCanceled(AOperationID) then begin
            break;
          end;
        end;

        Layer.Bitmap.Lock;
        try
          if ACancelNotifier.IsOperationCanceled(AOperationID) then begin
            break;
          end;
          Layer.Bitmap.Draw(VCurrTileOnBitmapRect, VTilePixelsToDraw, VTileToDrawBmp);
          SetBitmapChanged;
        finally
          Layer.Bitmap.UnLock;
        end;
      end;
    end;
  finally
    VTileToDrawBmp.Free;
  end;
end;

function TMapMainLayer.DrawMap(
  ATargetBmp: TCustomBitmap32;
  AMapType: TMapType;
  AGeoConvert: ICoordConverter;
  AZoom: Byte;
  ATile: TPoint;
  ADrawMode: TDrawMode;
  AUsePre: Boolean;
  ARecolorConfig: IBitmapPostProcessingConfigStatic
): Boolean;
var
  VBmp: TCustomBitmap32;
  VErrorString: string;
begin
  Result := False;
  VBmp := TCustomBitmap32.Create;
  try
    VErrorString := '';
    try
      if AMapType.LoadTileUni(VBmp, ATile, AZoom, AGeoConvert, AUsePre, True, False, AMapType.CacheBitmap) then begin
        VBmp.DrawMode := ADrawMode;
        VBmp.DrawTo(ATargetBmp);
        Result := True;
      end;
    except
      on E: Exception do begin
        VErrorString := E.Message;
      end;
    else
      VErrorString := SAS_ERR_TileDownloadUnexpectedError;
    end;
    if VErrorString <> '' then begin
      FErrorLogger.LogError(
        TTileErrorInfo.Create(
          AMapType,
          AZoom,
          ATile,
          VErrorString
        )
      );
    end;
  finally
    VBmp.Free;
  end;
end;

procedure TMapMainLayer.OnConfigChange;
begin
  ViewUpdateLock;
  try
    FViewConfig.LockRead;
    try
      FUsePrevZoomAtMap := FViewConfig.UsePrevZoomAtMap;
      FUsePrevZoomAtLayer := FViewConfig.UsePrevZoomAtLayer;
    finally
      FViewConfig.UnlockRead;
    end;
    SetNeedRedraw;
  finally
    ViewUpdateUnlock;
  end;
  ViewUpdate;
end;

procedure TMapMainLayer.OnLayerSetChange;
var
  VOldLayersSet: IMapTypeSet;
  VNewLayersSet: IMapTypeSet;
  VEnum: IEnumGUID;
  VGUID: TGUID;
  cnt: Cardinal;
  VNotifier: ITileRectUpdateNotifier;
  VMap: IMapType;
  VLocalConverter: ILocalCoordConverter;
  VZoom: Byte;
  VMapPixelRect: TDoubleRect;
  VLonLatRect: TDoubleRect;
  VTileRect: TRect;
  VMapConverter: ICoordConverter;
begin
  ViewUpdateLock;
  try
    VOldLayersSet := FLayersSet;
    VNewLayersSet := FMapsConfig.GetActiveBitmapLayersSet.GetSelectedMapsSet;
    FLayersSet := VNewLayersSet;
    VLocalConverter := LayerCoordConverter;
    if VLocalConverter <> nil then begin
      VZoom := VLocalConverter.GetZoom;
      if VOldLayersSet <> nil then begin
        VEnum := VOldLayersSet.GetIterator;
        while VEnum.Next(1, VGUID, cnt) = S_OK do begin
          if (VNewLayersSet = nil) or (VNewLayersSet.GetMapTypeByGUID(VGUID) = nil) then begin
            VMap := VOldLayersSet.GetMapTypeByGUID(VGUID);
            if VMap <> nil then begin
              VNotifier := VMap.MapType.NotifierByZoom[VZoom];
              if VNotifier <> nil then begin
                VNotifier.Remove(FTileChangeListener);
              end;
            end;
          end;
        end;
      end;
      if VNewLayersSet <> nil then begin
        VMapPixelRect := VLocalConverter.GetRectInMapPixelFloat;
        VLocalConverter.GetGeoConverter.CheckPixelRectFloat(VMapPixelRect, VZoom);
        VLonLatRect := VLocalConverter.GetGeoConverter.PixelRectFloat2LonLatRect(VMapPixelRect, VZoom);
        VEnum := VNewLayersSet.GetIterator;
        while VEnum.Next(1, VGUID, cnt) = S_OK do begin
          if (VOldLayersSet = nil) or (VOldLayersSet.GetMapTypeByGUID(VGUID) = nil) then begin
            VMap := VNewLayersSet.GetMapTypeByGUID(VGUID);
            if VMap <> nil then begin
              VNotifier := VMap.MapType.NotifierByZoom[VZoom];
              if VNotifier <> nil then begin
                VMapConverter := VMap.MapType.GeoConvert;
                VMapConverter.CheckLonLatRect(VLonLatRect);
                VTileRect := VMapConverter.LonLatRect2TileRect(VLonLatRect, VZoom);
                VNotifier.Add(FTileChangeListener, VTileRect);
              end;
            end;
          end;
        end;
      end;
    end;
    SetNeedRedraw;
  finally
    ViewUpdateUnlock;
  end;
  ViewUpdate;
end;

procedure TMapMainLayer.OnMainMapChange;
var
  VOldMainMap: IMapType;
  VNewMainMap: IMapType;
  VZoom: Byte;
  VLocalConverter: ILocalCoordConverter;
  VNotifier: ITileRectUpdateNotifier;
  VMapPixelRect: TDoubleRect;
  VLonLatRect: TDoubleRect;
  VTileRect: TRect;
begin
  ViewUpdateLock;
  try
    VOldMainMap := FMainMap;
    VNewMainMap := FMapsConfig.GetSelectedMapType;
    FMainMap := VNewMainMap;
    if VOldMainMap <> VNewMainMap then begin
      VLocalConverter := LayerCoordConverter;
      VZoom := VLocalConverter.GetZoom;
      if VOldMainMap <> nil then begin
        VNotifier := VOldMainMap.MapType.NotifierByZoom[VZoom];
        if VNotifier <> nil then begin
          VNotifier.Remove(FTileChangeListener);
        end;
      end;
      if VNewMainMap <> nil then begin
        VNotifier := VNewMainMap.MapType.NotifierByZoom[VZoom];
        if VNotifier <> nil then begin
          VMapPixelRect := VLocalConverter.GetRectInMapPixelFloat;
          VLocalConverter.GetGeoConverter.CheckPixelRectFloat(VMapPixelRect, VZoom);
          VLonLatRect := VLocalConverter.GetGeoConverter.PixelRectFloat2LonLatRect(VMapPixelRect, VZoom);
          VNewMainMap.MapType.GeoConvert.CheckLonLatRect(VLonLatRect);
          VTileRect := VNewMainMap.MapType.GeoConvert.LonLatRect2TileRect(VLonLatRect, VZoom);
          VNotifier.Add(FTileChangeListener, VTileRect);
        end;
      end;
    end;
    SetNeedRedraw;
  finally
    ViewUpdateUnlock;
  end;
  ViewUpdate;
end;

procedure TMapMainLayer.OnTileChange;
begin
  InterlockedIncrement(FTileUpdateCounter);
end;

procedure TMapMainLayer.OnTimer;
begin
  if InterlockedExchange(FTileUpdateCounter, 0) > 0 then begin
    ViewUpdateLock;
    try
      SetNeedRedraw;
    finally
      ViewUpdateUnlock;
    end;
    ViewUpdate;
  end;
end;

procedure TMapMainLayer.SendTerminateToThreads;
var
  VZoom: Byte;
  VMap: IMapType;
  VNotifier: ITileRectUpdateNotifier;
  VLayersSet: IMapTypeSet;
  VEnum: IEnumGUID;
  VGUID: TGUID;
  cnt: Cardinal;
begin
  inherited;
  if LayerCoordConverter <> nil then begin
    VZoom := LayerCoordConverter.GetZoom;
    VMap := FMainMap;
    if VMap <> nil then begin
      VNotifier := VMap.MapType.NotifierByZoom[VZoom];
      if VNotifier <> nil then begin
        VNotifier.Remove(FTileChangeListener);
      end;
    end;
    VLayersSet := FLayersSet;
    if VLayersSet <> nil then begin
      VEnum := VLayersSet.GetIterator;
      while VEnum.Next(1, VGUID, cnt) = S_OK do begin
        VMap := VLayersSet.GetMapTypeByGUID(VGUID);
        if VMap <> nil then begin
          VNotifier := VMap.MapType.NotifierByZoom[VZoom];
          if VNotifier <> nil then begin
            VNotifier.Remove(FTileChangeListener);
          end;
        end;
      end;
    end;
  end;
end;

procedure TMapMainLayer.SetLayerCoordConverter(AValue: ILocalCoordConverter);
var
  VOldZoom: Byte;
  VZoom: Byte;
  VMap: IMapType;
  VNotifier: ITileRectUpdateNotifier;
  VLayersSet: IMapTypeSet;
  VEnum: IEnumGUID;
  VGUID: TGUID;
  cnt: Cardinal;
  VMapPixelRect: TDoubleRect;
  VLonLatRect: TDoubleRect;
  VTileRect: TRect;
begin
  VOldZoom := 255;
  if LayerCoordConverter <> nil then begin
    VOldZoom := LayerCoordConverter.GetZoom;
  end;
  inherited;
  VZoom := AValue.GetZoom;
  if VZoom <> VOldZoom then begin
    if VOldZoom <> 255 then begin
      VMap := FMainMap;
      if VMap <> nil then begin
        VNotifier := VMap.MapType.NotifierByZoom[VOldZoom];
        if VNotifier <> nil then begin
          VNotifier.Remove(FTileChangeListener);
        end;
      end;
      VLayersSet := FLayersSet;
      if VLayersSet <> nil then begin
        VEnum := VLayersSet.GetIterator;
        while VEnum.Next(1, VGUID, cnt) = S_OK do begin
          VMap := VLayersSet.GetMapTypeByGUID(VGUID);
          if VMap <> nil then begin
            VNotifier := VMap.MapType.NotifierByZoom[VOldZoom];
            if VNotifier <> nil then begin
              VNotifier.Remove(FTileChangeListener);
            end;
          end;
        end;
      end;
    end;
  end;
  VMapPixelRect := AValue.GetRectInMapPixelFloat;
  AValue.GetGeoConverter.CheckPixelRectFloat(VMapPixelRect, VZoom);
  VLonLatRect := AValue.GetGeoConverter.PixelRectFloat2LonLatRect(VMapPixelRect, VZoom);
  VMap := FMainMap;
  if VMap <> nil then begin
    VNotifier := VMap.MapType.NotifierByZoom[VZoom];
    if VNotifier <> nil then begin
      VMap.MapType.GeoConvert.CheckLonLatRect(VLonLatRect);
      VTileRect := VMap.MapType.GeoConvert.LonLatRect2TileRect(VLonLatRect, VZoom);
      VNotifier.Add(FTileChangeListener, VTileRect);
    end;
  end;
  VLayersSet := FLayersSet;
  if VLayersSet <> nil then begin
    VEnum := VLayersSet.GetIterator;
    while VEnum.Next(1, VGUID, cnt) = S_OK do begin
      VMap := VLayersSet.GetMapTypeByGUID(VGUID);
      if VMap <> nil then begin
        VNotifier := VMap.MapType.NotifierByZoom[VZoom];
        if VNotifier <> nil then begin
          VMap.MapType.GeoConvert.CheckLonLatRect(VLonLatRect);
          VTileRect := VMap.MapType.GeoConvert.LonLatRect2TileRect(VLonLatRect, VZoom);
          VNotifier.Add(FTileChangeListener, VTileRect);
        end;
      end;
    end;
  end;
end;

procedure TMapMainLayer.StartThreads;
begin
  inherited;
  OnConfigChange;
  OnMainMapChange;
  OnLayerSetChange;
  Visible := True;
end;

end.


