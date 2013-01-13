unit u_MapLayerShowError;

interface

uses
  Windows,
  SysUtils,
  GR32,
  GR32_Image,
  t_GeoTypes,
  i_NotifierTime,
  i_NotifierOperation,
  i_LocalCoordConverter,
  i_LocalCoordConverterChangeable,
  i_InternalPerformanceCounter,
  i_Bitmap32StaticFactory,
  i_ViewPortState,
  i_TileError,
  i_SimpleFlag,
  i_MarkerDrawable,
  i_TileErrorLogProviedrStuped,
  u_MapType,
  u_MapLayerBasic;

type
  TTileErrorInfoLayer = class(TMapLayerBasicNoBitmap)
  private
    FLogProvider: ITileErrorLogProviedrStuped;
    FBitmapFactory: IBitmap32StaticFactory;
    FNeedUpdateFlag: ISimpleFlag;

    FErrorInfo: ITileErrorInfo;
    FErrorInfoCS: IReadWriteSync;
    FHideAfterTime: Cardinal;
    FMarker: IMarkerDrawable;

    procedure OnTimer;
    procedure OnErrorRecive;
    function CreateMarkerByError(const AErrorInfo: ITileErrorInfo): IMarkerDrawable;
  protected
    procedure PaintLayer(
      ABuffer: TBitmap32;
      const ALocalConverter: ILocalCoordConverter
    ); override;
    procedure DoHide; override;
  public
    constructor Create(
      const APerfList: IInternalPerformanceCounterList;
      const AAppStartedNotifier: INotifierOneOperation;
      const AAppClosingNotifier: INotifierOneOperation;
      AParentMap: TImage32;
      const AView: ILocalCoordConverterChangeable;
      const ABitmapFactory: IBitmap32StaticFactory;
      const ALogProvider: ITileErrorLogProviedrStuped;
      const ATimerNoifier: INotifierTime
    );
  end;

implementation

uses
  Types,
  i_CoordConverter,
  i_Bitmap32Static,
  u_ListenerByEvent,
  u_ListenerTime,
  u_SimpleFlagWithInterlock,
  u_MarkerDrawableByBitmap32Static,
  u_Synchronizer,
  u_GeoFun;


{ TTileErrorInfoLayer }

constructor TTileErrorInfoLayer.Create(
  const APerfList: IInternalPerformanceCounterList;
  const AAppStartedNotifier: INotifierOneOperation;
  const AAppClosingNotifier: INotifierOneOperation;
  AParentMap: TImage32;
  const AView: ILocalCoordConverterChangeable;
  const ABitmapFactory: IBitmap32StaticFactory;
  const ALogProvider: ITileErrorLogProviedrStuped;
  const ATimerNoifier: INotifierTime
);
begin
  inherited Create(
    APerfList,
    AAppStartedNotifier,
    AAppClosingNotifier,
    AParentMap,
    AView
  );
  FLogProvider := ALogProvider;
  FBitmapFactory := ABitmapFactory;
  FErrorInfo := nil;
  FNeedUpdateFlag := TSimpleFlagWithInterlock.Create;
  FErrorInfoCS := MakeSyncRW_Var(Self, False);

  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnErrorRecive),
    FLogProvider.GetNotifier
  );
  LinksList.Add(
    TListenerTimeCheck.Create(Self.OnTimer, 1000),
    ATimerNoifier
  );
end;

function TTileErrorInfoLayer.CreateMarkerByError(
  const AErrorInfo: ITileErrorInfo
): IMarkerDrawable;
var
  VText: string;
  VSize: TPoint;
  VMapNameSize: TSize;
  VMessageSize: TSize;
  VBitmap: TBitmap32;
  VBitmapStatic: IBitmap32Static;
begin
  inherited;
  Result := nil;
  if AErrorInfo <> nil then begin
    VBitmap := TBitmap32.Create;
    try
      VBitmap.CombineMode := cmMerge;
      if AErrorInfo.MapType <> nil then begin
        VText := AErrorInfo.MapType.GUIConfig.Name.Value;
        VMapNameSize := VBitmap.TextExtent(VText);
        VSize.X := VMapNameSize.cx;
        VSize.Y := VMapNameSize.cy + 20;
        VMessageSize := VBitmap.TextExtent(AErrorInfo.ErrorText);
        if VSize.X < VMessageSize.cx then begin
          VSize.X := VMessageSize.cx;
        end;
        Inc(VSize.Y, VMessageSize.cy + 20);
        Inc(VSize.X, 20);
        VBitmap.SetSize(VSize.X, VSize.Y);
        VBitmap.Clear(0);

        VBitmap.RenderText((VSize.X - VMapNameSize.cx) div 2, 10, VText, 0, clBlack32);
        VBitmap.RenderText((VSize.X - VMessageSize.cx) div 2, 30 + VMapNameSize.cy, AErrorInfo.ErrorText, 0, clBlack32);
      end else begin
        VMessageSize := VBitmap.TextExtent(AErrorInfo.ErrorText);
        VSize.X := VMessageSize.cx + 20;
        VSize.Y := VMessageSize.cy + 20;

        VBitmap.SetSize(VSize.X, VSize.Y);
        VBitmap.Clear(0);

        VBitmap.RenderText((VSize.X - VMessageSize.cx) div 2, 10, AErrorInfo.ErrorText, 0, clBlack32);
      end;
      VBitmapStatic := FBitmapFactory.Build(VSize, VBitmap.Bits);
    finally
      VBitmap.Free;
    end;
    Result := TMarkerDrawableByBitmap32Static.Create(VBitmapStatic, DoublePoint(VSize.X / 2, VSize.Y / 2));
  end;
end;

procedure TTileErrorInfoLayer.DoHide;
begin
  inherited;
  FHideAfterTime := 0;
  FErrorInfo := nil;
  FMarker := nil;
end;

procedure TTileErrorInfoLayer.OnErrorRecive;
begin
  FNeedUpdateFlag.SetFlag;
end;

procedure TTileErrorInfoLayer.OnTimer;
var
  VCurrTime: Cardinal;
  VNeedHide: Boolean;
  VErrorInfo: ITileErrorInfo;
begin
  VErrorInfo := nil;
  if FNeedUpdateFlag.CheckFlagAndReset then begin
    VErrorInfo := FLogProvider.GetLastErrorInfo;
  end;
  if VErrorInfo <> nil then begin
    VCurrTime := GetTickCount;
    ViewUpdateLock;
    try
      FErrorInfoCS.BeginWrite;
      try
        FErrorInfo := VErrorInfo;
        FHideAfterTime := VCurrTime + 10000;
      finally
        FErrorInfoCS.EndWrite;
      end;
      SetNeedRedraw;
      Show;
    finally
      ViewUpdateUnlock;
    end;
  end else begin
    VCurrTime := GetTickCount;
    VNeedHide := False;
    ViewUpdateLock;
    try
      FErrorInfoCS.BeginWrite;
      try
        if (FHideAfterTime = 0) or (FErrorInfo = nil) or (VCurrTime >= FHideAfterTime) then begin
          VNeedHide := True;
          FHideAfterTime := 0;
          FErrorInfo := nil;
        end;
      finally
        FErrorInfoCS.EndWrite;
      end;
      if VNeedHide then begin
        FMarker := nil;
        Hide;
      end;
    finally
      ViewUpdateUnlock;
    end;
  end;

end;

procedure TTileErrorInfoLayer.PaintLayer(
  ABuffer: TBitmap32;
  const ALocalConverter: ILocalCoordConverter
);
var
  VMarker: IMarkerDrawable;
  VFixedOnView: TDoublePoint;
  VErrorInfo: ITileErrorInfo;
  VConverter: ICoordConverter;
  VMapType: TMapType;
  VZoom: Byte;
  VTile: TPoint;
  VFixedLonLat: TDoublePoint;
begin
  FErrorInfoCS.BeginRead;
  try
    VErrorInfo := FErrorInfo;
  finally
    FErrorInfoCS.EndRead;
  end;
  if FErrorInfo <> nil then begin
    VMapType := VErrorInfo.MapType;
    VConverter := VMapType.GeoConvert;
    VZoom := VErrorInfo.Zoom;
    VTile := VErrorInfo.Tile;
    VConverter.CheckTilePosStrict(VTile, VZoom, True);
    VFixedLonLat := VConverter.PixelPosFloat2LonLat(RectCenter(VConverter.TilePos2PixelRect(VTile, VZoom)), VZoom);
    ALocalConverter.GeoConverter.CheckLonLatPos(VFixedLonLat);
    VFixedOnView := ALocalConverter.LonLat2LocalPixelFloat(VFixedLonLat);
    if PixelPointInRect(VFixedOnView, DoubleRect(ALocalConverter.GetLocalRect)) then begin
      VMarker := FMarker;
      if VMarker = nil then begin
        VMarker := CreateMarkerByError(FErrorInfo);
      end;
      FMarker := VMarker;
      if VMarker <> nil then begin
        VFixedOnView := ALocalConverter.LonLat2LocalPixelFloat(VFixedLonLat);
        VMarker.DrawToBitmap(ABuffer, VFixedOnView);
      end;
    end;
  end;
end;

end.
