unit u_MarkerProviderForVectorItemForMarkPoints;

interface

uses
  GR32,
  i_MarkerDrawable,
  i_VectorDataItemSimple,
  i_MarksDrawConfig,
  i_Bitmap32Static,
  i_Bitmap32StaticFactory,
  i_BitmapMarker,
  i_MarkerProviderForVectorItem,
  u_BaseInterfacedObject;

type
  TMarkerProviderForVectorItemForMarkPoints = class(TBaseInterfacedObject, IMarkerProviderForVectorItem)
  private
    FBitmapFactory: IBitmap32StaticFactory;
    FConfig: IMarksDrawConfigStatic;
    FMarkerDefault: IMarkerDrawableChangeable;

    FBitmapWithText: TBitmap32;

    function GetCaptionBitmap(
      const ACaption: string;
      AFontSize: Integer;
      ATextColor: TColor32;
      ATextBgColor: TColor32;
      ASolidBgDraw: Boolean
    ): IBitmap32Static;
    function GetCaptionMarker(
      const ACaption: string;
      AFontSize: Integer;
      ATextColor: TColor32;
      ATextBgColor: TColor32;
      ASolidBgDraw: Boolean;
      AMarkSize: Integer
    ): IMarkerDrawable;


    function GetIconMarker(
      const ASourceMarker: IBitmapMarker;
      ASize: Integer
    ): IMarkerDrawable;
    function ModifyMarkerWithResize(
      const ASourceMarker: IBitmapMarker;
      ASize: Integer
    ): IBitmapMarker;
  private
    function GetMarker(const AItem: IVectorDataItemSimple): IMarkerDrawable;
  public
    constructor Create(
      const ABitmapFactory: IBitmap32StaticFactory;
      const AMarkerDefault: IMarkerDrawableChangeable;
      const AConfig: IMarksDrawConfigStatic
    );
    destructor Destroy; override;
  end;

implementation

uses
  Types,
  SysUtils,
  GR32_Resamplers,
  t_GeoTypes,
  i_MarksSimple,
  u_Bitmap32ByStaticBitmap,
  u_BitmapMarker,
  u_BitmapFunc,
  u_MarkerDrawableByBitmapMarker,
  u_MarkerDrawableByBitmap32Static,
  u_MarkerDrawableComplex,
  u_GeoFun;

{ TMarkerProviderForVectorItemForMarkPoints }

constructor TMarkerProviderForVectorItemForMarkPoints.Create(
  const ABitmapFactory: IBitmap32StaticFactory;
  const AMarkerDefault: IMarkerDrawableChangeable;
  const AConfig: IMarksDrawConfigStatic
);
begin
  inherited Create;
  FBitmapFactory := ABitmapFactory;
  FConfig := AConfig;
  FMarkerDefault := AMarkerDefault;

  FBitmapWithText := TBitmap32.Create;
  FBitmapWithText.Font.Name := 'Tahoma';
  FBitmapWithText.Font.Style := [];
  FBitmapWithText.DrawMode := dmBlend;
  FBitmapWithText.CombineMode := cmMerge;
  FBitmapWithText.Resampler := TLinearResampler.Create;
end;

destructor TMarkerProviderForVectorItemForMarkPoints.Destroy;
begin
  FreeAndNil(FBitmapWithText);
  inherited;
end;

function TMarkerProviderForVectorItemForMarkPoints.GetCaptionBitmap(
  const ACaption: string; AFontSize: Integer; ATextColor, ATextBgColor: TColor32;
  ASolidBgDraw: Boolean): IBitmap32Static;
var
  VTextSize: TSize;
  VBitmap: TBitmap32ByStaticBitmap;
begin
  Result := nil;
  if (AFontSize > 0) and (ACaption <> '') then begin
    FBitmapWithText.MasterAlpha:=AlphaComponent(ATextColor);
    FBitmapWithText.Font.Size := AFontSize;
    VTextSize := FBitmapWithText.TextExtent(ACaption);
    VTextSize.cx:=VTextSize.cx+2;
    VTextSize.cy:=VTextSize.cy+2;
    FBitmapWithText.SetSize(VTextSize.cx + 2,VTextSize.cy + 2);
    if FConfig.UseSolidCaptionBackground then begin
      FBitmapWithText.Clear(ATextBgColor);
      FBitmapWithText.RenderText(2, 2, ACaption, 1, SetAlpha(ATextColor,255));
    end else begin
      FBitmapWithText.Clear(0);
      FBitmapWithText.RenderText(2, 2, ACaption, 1, SetAlpha(ATextBgColor,255));
      FBitmapWithText.RenderText(1, 1, ACaption, 1, SetAlpha(ATextColor,255));
    end;
    VBitmap := TBitmap32ByStaticBitmap.Create(FBitmapFactory);
    try
      VBitmap.SetSizeFrom(FBitmapWithText);
      VBitmap.Clear(0);
      VBitmap.Draw(0, 0, FBitmapWithText);
      Result := VBitmap.BitmapStatic;
    finally
      VBitmap.Free;
    end;
  end;
end;

function TMarkerProviderForVectorItemForMarkPoints.GetCaptionMarker(
  const ACaption: string;
  AFontSize: Integer;
  ATextColor, ATextBgColor: TColor32;
  ASolidBgDraw: Boolean;
  AMarkSize: Integer
): IMarkerDrawable;
var
  VBitmapStatic: IBitmap32Static;
  VAnchorPoint: TDoublePoint;
begin
  Result := nil;
  VBitmapStatic := GetCaptionBitmap(ACaption, AFontSize, ATextColor, ATextBgColor, ASolidBgDraw);
  if VBitmapStatic <> nil then begin
    VAnchorPoint := DoublePoint(- AMarkSize / 2, AMarkSize / 2 + VBitmapStatic.Size.Y / 2);
    Result := TMarkerDrawableByBitmap32Static.Create(VBitmapStatic, VAnchorPoint);
  end;
end;

function TMarkerProviderForVectorItemForMarkPoints.GetIconMarker(
  const ASourceMarker: IBitmapMarker;
  ASize: Integer
): IMarkerDrawable;
var
  VMarker: IBitmapMarker;
begin
  Result := nil;
  if ASourceMarker = nil then begin
    if FMarkerDefault <> nil then begin
      Result := FMarkerDefault.GetStatic;
    end;
  end else begin
    VMarker := ASourceMarker;
    if ASize <> VMarker.Size.X then begin
      VMarker := ModifyMarkerWithResize(VMarker, ASize);
    end;
    Result := TMarkerDrawableByBitmapMarker.Create(VMarker);
  end;
end;

function TMarkerProviderForVectorItemForMarkPoints.GetMarker(
  const AItem: IVectorDataItemSimple): IMarkerDrawable;
var
  VMarker: IBitmapMarker;
  VMarkPoint: IMarkPoint;
  VMarkerIcon: IMarkerDrawable;
  VMarkerCaption: IMarkerDrawable;
begin
  Result := nil;
  if not Supports(AItem, IMarkPoint, VMarkPoint) then begin
    Exit;
  end;

  VMarker := nil;
  if (VMarkPoint.Pic <> nil) then begin
    VMarker := VMarkPoint.Pic.GetMarker;
  end;
  VMarkerIcon := GetIconMarker(VMarker, VMarkPoint.MarkerSize);

  VMarkerCaption := nil;
  if FConfig.ShowPointCaption then begin
    VMarkerCaption :=
      GetCaptionMarker(
        VMarkPoint.Name,
        VMarkPoint.FontSize,
        VMarkPoint.TextColor,
        VMarkPoint.TextBgColor,
        FConfig.UseSolidCaptionBackground,
        VMarkPoint.MarkerSize
      );
  end;

  if (VMarkerCaption <> nil) and (VMarkerIcon <> nil) then begin
    Result := TMarkerDrawableComplex.Create(VMarkerIcon, VMarkerCaption);
  end else if VMarkerCaption <> nil then begin
    Result := VMarkerCaption;
  end else if VMarkerIcon <> nil then begin
    Result := VMarkerIcon;
  end;
end;

function TMarkerProviderForVectorItemForMarkPoints.ModifyMarkerWithResize(
  const ASourceMarker: IBitmapMarker; ASize: Integer): IBitmapMarker;
var
  VSizeSource: TPoint;
  VSizeTarget: TPoint;
  VBitmap: TBitmap32ByStaticBitmap;
  VFixedOnBitmap: TDoublePoint;
  VScale: Double;
  VSampler: TCustomResampler;
  VBitmapStatic: IBitmap32Static;
begin
  Result := nil;
  VSizeSource := ASourceMarker.Size;
  if VSizeSource.X > 0 then begin
    VScale := ASize / VSizeSource.X;
    VSizeTarget.X := Trunc(VSizeSource.X * VScale + 0.5);
    VSizeTarget.Y := Trunc(VSizeSource.Y * VScale + 0.5);
    VBitmap := TBitmap32ByStaticBitmap.Create(FBitmapFactory);
    try
      VBitmap.SetSize(VSizeTarget.X, VSizeTarget.Y);
      VSampler := TLinearResampler.Create;
      try
        StretchTransferFull(
          VBitmap,
          VBitmap.BoundsRect,
          ASourceMarker,
          VSampler,
          dmOpaque
        );
      finally
        VSampler.Free;
      end;
      VBitmapStatic := VBitmap.BitmapStatic;
    finally
      VBitmap.Free;
    end;
    VFixedOnBitmap := DoublePoint(ASourceMarker.AnchorPoint.X * VScale, ASourceMarker.AnchorPoint.Y * VScale);
    Result := TBitmapMarker.Create(VBitmapStatic, VFixedOnBitmap);
  end;
end;

end.
