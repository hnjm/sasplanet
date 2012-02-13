unit u_LayerScaleLine;

interface

uses
  Types,
  GR32,
  GR32_Image,
  i_LocalCoordConverter,
  i_InternalPerformanceCounter,
  i_ViewPortState,
  i_ScaleLineConfig,
  u_WindowLayerWithPos;

type
  TLayerScaleLine = class(TWindowLayerFixedSizeWithBitmap)
  private
    FConfig: IScaleLineConfig;
    procedure OnConfigChange;
  protected
    procedure SetLayerCoordConverter(AValue: ILocalCoordConverter); override;
    function GetMapLayerLocationRect: TFloatRect; override;
    procedure DoRedraw; override;
  public
    procedure StartThreads; override;
  public
    constructor Create(
      APerfList: IInternalPerformanceCounterList;
      AParentMap: TImage32;
      AViewPortState: IViewPortState;
      AConfig: IScaleLineConfig
    );
  end;

implementation

uses
  Math,
  SysUtils,
  i_CoordConverter,
  u_NotifyEventListener,
  u_ResStrings,
  t_GeoTypes;

const
  D2R: Double = 0.017453292519943295769236907684886;// ��������� ��� �������������� �������� � �������

{ TLayerScaleLine }

constructor TLayerScaleLine.Create(
  APerfList: IInternalPerformanceCounterList;
  AParentMap: TImage32;
  AViewPortState: IViewPortState;
  AConfig: IScaleLineConfig
);
var
  VSize: TPoint;
begin
  inherited Create(APerfList, AParentMap, AViewPortState);
  FConfig := AConfig;
  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnConfigChange),
    FConfig.GetChangeNotifier
  );

  FLayer.Bitmap.Font.Name := 'arial';
  FLayer.Bitmap.Font.Size := 8;
  VSize.X := 400;
  VSize.Y := 40;
  FLayer.Bitmap.SetSize(VSize.X, VSize.Y);
  DoUpdateLayerSize(VSize);
end;

procedure TLayerScaleLine.DoRedraw;
var
  rnum: integer;
  se: string;
  LL: TDoublePoint;
  num: real;
  VBitmapSize: TPoint;
  VRad: Extended;
  VConverter: ICoordConverter;
  VPixelsAtZoom: Double;
  VZoom: Byte;
  VVisualCoordConverter: ILocalCoordConverter;
  I: Integer;
  VStartX, VStartY: Integer;
begin
  inherited;
  VVisualCoordConverter := LayerCoordConverter;
  VBitmapSize := Point(FLayer.Bitmap.Width, FLayer.Bitmap.Height);
  VConverter := VVisualCoordConverter.GetGeoConverter;
  VZoom := VVisualCoordConverter.GetZoom;
  LL := VVisualCoordConverter.GetCenterLonLat;

  VRad := VConverter.Datum.GetSpheroidRadiusA;
  VPixelsAtZoom := VConverter.PixelsAtZoomFloat(VZoom);

  num := 300 / ((VPixelsAtZoom / (2 * PI)) / (VRad * cos(LL.y * D2R)));

  if num > 10000 then begin
    num := num / 1000;
    se := ' ' + SAS_UNITS_km + ' ';
  end else if num < 10 then begin
    num := num * 100;
    se := ' ' + SAS_UNITS_sm + ' ';
  end else begin
    se := ' ' + SAS_UNITS_m + ' ';
  end;
  rnum := round(num);

  FLayer.Bitmap.Clear(SetAlpha(clWhite32, 0));
  // ������� ����������� �����
  FLayer.Bitmap.Line(0, VBitmapSize.Y - 1, 300, VBitmapSize.Y - 1, SetAlpha(clBlack32, 90));
  FLayer.Bitmap.Line(0, VBitmapSize.Y - 2, 300, VBitmapSize.Y - 2, SetAlpha(clWhite32, 255));
  FLayer.Bitmap.Line(0, VBitmapSize.Y - 3, 300, VBitmapSize.Y - 3, SetAlpha(clBlack32, 90));
  // ��������: �������/�������� ���������
  for I := 0 to 4 do begin
    VStartX := 1 + I*75;
    if (I = 1) or (I = 3) then begin
      VStartY := VBitmapSize.Y - 10; // �������� ���������
    end else begin
      VStartY := VBitmapSize.Y - 20; // ������� ���������
    end;
    // ���������
    FLayer.Bitmap.Line(VStartX - 1, VStartY, VStartX - 1, VBitmapSize.Y - 1, SetAlpha(clBlack32, 90));
    FLayer.Bitmap.Line(VStartX,     VStartY, VStartX,     VBitmapSize.Y - 1, SetAlpha(clWhite32, 255));
    FLayer.Bitmap.Line(VStartX + 1, VStartY, VStartX + 1, VBitmapSize.Y - 1, SetAlpha(clBlack32, 90));
    // "�����"
    FLayer.Bitmap.Line(VStartX - 1, VStartY, VStartX + 1, VStartY, SetAlpha(clBlack32, 90));
  end;
  FLayer.Bitmap.Line(0, VBitmapSize.Y - 1, 302, VBitmapSize.Y - 1, SetAlpha(clBlack32, 90));
  FLayer.Bitmap.Line(1, VBitmapSize.Y - 2, 301, VBitmapSize.Y - 2, SetAlpha(clWhite32, 255));

  FLayer.bitmap.RenderText(0, 5, '0 ' + se, 0, SetAlpha(clWhite32, 255));
  FLayer.bitmap.RenderText(150, 5, IntToStr(rnum div 2) + ' ' + se, 0, SetAlpha(clWhite32, 255));
  FLayer.bitmap.RenderText(300, 5, IntToStr(rnum) + ' ' + se, 0, SetAlpha(clWhite32, 255));
end;

function TLayerScaleLine.GetMapLayerLocationRect: TFloatRect;
var
  VSize: TPoint;
begin
  VSize := Point(FLayer.Bitmap.Width, FLayer.Bitmap.Height);
  Result.Left := 6;
  Result.Bottom := ViewCoordConverter.GetLocalRectSize.Y - 6 - FConfig.BottomMargin;
  Result.Right := Result.Left + VSize.X;
  Result.Top := Result.Bottom - VSize.Y;
end;

procedure TLayerScaleLine.OnConfigChange;
begin
  ViewUpdateLock;
  try
    SetVisible(FConfig.Visible);
    SetNeedRedraw;
    SetNeedUpdateLocation;
  finally
    ViewUpdateUnlock;
  end;
  ViewUpdate;
end;

procedure TLayerScaleLine.SetLayerCoordConverter(AValue: ILocalCoordConverter);
begin
  inherited;
  SetNeedRedraw;
end;

procedure TLayerScaleLine.StartThreads;
begin
  inherited;
  OnConfigChange;
end;

end.
