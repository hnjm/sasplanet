unit u_MapLayerFillingMap;

interface

uses
  Types,
  GR32,
  GR32_Image,
  i_BackgroundTaskLayerDraw,
  i_LocalCoordConverter,
  u_BackgroundTaskLayerDrawBase,
  i_ViewPortState,
  i_FillingMapLayerConfig,
  u_MapType,
  u_MapLayerWithThreadDraw;

type
  IBackgroundTaskFillingMap = interface(IBackgroundTaskLayerDraw)
    ['{3BE65F32-4F6F-41F0-83CC-5B4E6646B3FF}']
    procedure ChangeConfig(AConfig: IFillingMapLayerConfigStatic);
  end;

  TBackgroundTaskFillingMap = class(TBackgroundTaskLayerDrawBase, IBackgroundTaskFillingMap)
  private
    FConfig: IFillingMapLayerConfigStatic;
    function IsNeedStopExecute(): Boolean;
  protected
    procedure DrawBitmap; override;
    procedure ExecuteTask; override;
  protected
    procedure ChangeConfig(AConfig: IFillingMapLayerConfigStatic);
  end;

  TBackgroundTaskFillingMapFactory = class(TInterfacedObject, IBackgroundTaskLayerDrawFactory)
  protected
    function GetTask(ABitmap: TCustomBitmap32): IBackgroundTaskLayerDraw;
  end;

  TMapLayerFillingMap = class(TMapLayerWithThreadDraw)
  private
    FConfig: IFillingMapLayerConfig;
    FConfigStatic: IFillingMapLayerConfigStatic;
    FDrawTask: IBackgroundTaskFillingMap;
    procedure OnConfigChange(Sender: TObject);
  protected
    function GetVisibleForNewPos(ANewVisualCoordConverter: ILocalCoordConverter): Boolean; override;
  public
    constructor Create(AParentMap: TImage32; AViewPortState: IViewPortState; AConfig: IFillingMapLayerConfig);
    procedure StartThreads; override;
  end;

implementation

uses
  Graphics,
  SysUtils,
  t_GeoTypes,
  i_CoordConverter,
  i_TileIterator,
  u_NotifyEventListener,
  u_TileIteratorSpiralByRect;

{ TBackgroundTaskFillingMap }

procedure TBackgroundTaskFillingMap.ChangeConfig(
  AConfig: IFillingMapLayerConfigStatic);
begin
  StopExecute;
  try
    FConfig := AConfig;
  finally
    StartExecute;
  end;
end;

procedure TBackgroundTaskFillingMap.DrawBitmap;
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
begin
  inherited;

  Bitmap.Lock;
  try
    Bitmap.Clear(0);
  finally
    Bitmap.UnLock;
  end;

  VBmp := TCustomBitmap32.Create;
  try
    VConfig := FConfig;
    VLocalConverter := Converter;
    VZoom := VLocalConverter.GetZoom;
    VZoomSource := VConfig.SourceZoom;
    VSourceMapType := VConfig.SourceMap.MapType;
    VSourceGeoConvert := VSourceMapType.GeoConvert;
    VGeoConvert := VLocalConverter.GetGeoConverter;

    VBitmapOnMapPixelRect := VLocalConverter.GetRectInMapPixelFloat;
    if not NeedStopExecute then begin
      VGeoConvert.CheckPixelRectFloat(VBitmapOnMapPixelRect, VZoom);
      VSourceLonLatRect := VGeoConvert.PixelRectFloat2LonLatRect(VBitmapOnMapPixelRect, VZoom);
      VSourceGeoConvert.CheckLonLatRect(VSourceLonLatRect);
      VPixelSourceRect := VSourceGeoConvert.LonLatRect2PixelRect(VSourceLonLatRect, VZoom);
      VTileSourceRect := VSourceGeoConvert.PixelRect2TileRect(VPixelSourceRect, VZoom);
      VTileIterator := TTileIteratorSpiralByRect.Create(VTileSourceRect);
      while VTileIterator.Next(VTile) do begin
        if NeedStopExecute then begin
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

        VCurrTilePixelRect.TopLeft := VSourceGeoConvert.PixelPos2OtherMap(VCurrTilePixelRectSource.TopLeft, VZoom, VGeoConvert);
        VCurrTilePixelRect.BottomRight := VSourceGeoConvert.PixelPos2OtherMap(VCurrTilePixelRectSource.BottomRight, VZoom, VGeoConvert);

        if NeedStopExecute then begin
          break;
        end;
        VCurrTilePixelRectAtBitmap.TopLeft := VLocalConverter.MapPixel2LocalPixel(VCurrTilePixelRect.TopLeft);
        VCurrTilePixelRectAtBitmap.BottomRight := VLocalConverter.MapPixel2LocalPixel(VCurrTilePixelRect.BottomRight);
        if NeedStopExecute then begin
          break;
        end;
        if VSourceMapType.LoadFillingMap(VBmp, VTile, VZoom, VZoomSource, IsNeedStopExecute, VConfig.NoTileColor, VConfig.ShowTNE, VConfig.TNEColor) then begin
          Bitmap.Lock;
          try
            Bitmap.Draw(VCurrTilePixelRectAtBitmap, VTilePixelsToDraw, Vbmp);
          finally
            Bitmap.UnLock;
          end;
        end;
      end;
    end;
  finally
    VBmp.Free;
  end;
end;

procedure TBackgroundTaskFillingMap.ExecuteTask;
begin
  if FConfig <> nil then begin
    inherited;
  end;
end;

function TBackgroundTaskFillingMap.IsNeedStopExecute: Boolean;
begin
  Result := NeedStopExecute;
end;

{ TMapLayerFillingMap }

constructor TMapLayerFillingMap.Create(AParentMap: TImage32;
  AViewPortState: IViewPortState; AConfig: IFillingMapLayerConfig);
var
  VFactory: IBackgroundTaskLayerDrawFactory;
begin
  VFactory := TBackgroundTaskFillingMapFactory.Create;
  inherited Create(AParentMap, AViewPortState, VFactory);
  FConfig := AConfig;
  FDrawTask := (inherited DrawTask) as IBackgroundTaskFillingMap;

  LinksList.Add(
    TNotifyEventListener.Create(OnConfigChange),
    FConfig.GetChangeNotifier
  );
end;

procedure TMapLayerFillingMap.StartThreads;
begin
  inherited;
  OnConfigChange(nil);
end;

function TMapLayerFillingMap.GetVisibleForNewPos(
  ANewVisualCoordConverter: ILocalCoordConverter): Boolean;
begin
  Result := FConfigStatic.Visible;
  if Result then begin
    Result := ANewVisualCoordConverter.GetZoom <= FConfigStatic.SourceZoom;
  end;
end;

procedure TMapLayerFillingMap.OnConfigChange(Sender: TObject);
begin
  FConfigStatic := FConfig.GetStatic;
  SetVisible(GetVisibleForNewPos(ViewCoordConverter));
  if Visible then begin
    FDrawTask.StopExecute;
    try
      FDrawTask.ChangeConfig(FConfigStatic);
    finally
      FDrawTask.StartExecute;
    end;
  end;
end;

{ TBackgroundTaskFillingMapFactory }

function TBackgroundTaskFillingMapFactory.GetTask(
  ABitmap: TCustomBitmap32): IBackgroundTaskLayerDraw;
begin
  Result := TBackgroundTaskFillingMap.Create(ABitmap);
end;

end.
