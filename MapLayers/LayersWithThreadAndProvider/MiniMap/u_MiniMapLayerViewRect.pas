{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2014, SAS.Planet development team.                      *}
{* This program is free software: you can redistribute it and/or modify       *}
{* it under the terms of the GNU General Public License as published by       *}
{* the Free Software Foundation, either version 3 of the License, or          *}
{* (at your option) any later version.                                        *}
{*                                                                            *}
{* This program is distributed in the hope that it will be useful,            *}
{* but WITHOUT ANY WARRANTY; without even the implied warranty of             *}
{* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *}
{* GNU General Public License for more details.                               *}
{*                                                                            *}
{* You should have received a copy of the GNU General Public License          *}
{* along with this program.  If not, see <http://www.gnu.org/licenses/>.      *}
{*                                                                            *}
{* http://sasgis.org                                                          *}
{* info@sasgis.org                                                            *}
{******************************************************************************}

unit u_MiniMapLayerViewRect;

interface

uses
  Types,
  Classes,
  Controls,
  GR32,
  GR32_Image,
  GR32_Layers,
  TBX,
  TB2Item,
  t_GeoTypes,
  i_NotifierTime,
  i_NotifierOperation,
  i_InternalPerformanceCounter,
  i_SimpleFlag,
  i_LocalCoordConverter,
  i_LocalCoordConverterChangeable,
  i_MiniMapLayerConfig,
  i_ActiveMapsConfig,
  i_MapTypeIconsList,
  i_ViewPortState,
  i_MapTypeGUIConfigList,
  u_WindowLayerWithPos;

type
  TMiniMapLayerViewRect = class(TWindowLayerWithLocationBase)
  private
    FParentMap: TImage32;
    FMapsConfig: IActivMapWithLayers;
    FLocationConfig: IMiniMapLayerLocationConfig;
    FPosition: ILocalCoordConverterChangeable;
    FViewPortState: IViewPortState;
    FGUIConfigList: IMapTypeGUIConfigList;
    FPopup: TTBXPopupMenu;
    FIconsList: IMapTypeIconsList;

    FPosMoved: Boolean;
    FViewRectMoveDelta: TDoublePoint;
    FLayerChangeFlag: ISimpleFlag;

    procedure OnTimer;
    procedure OnConfigChange;
    procedure OnViewChange;
    procedure OnPosChange;
    procedure DrawMainViewRect(
      ABuffer: TBitmap32;
      const AConfig: IMiniMapLayerLocationConfigStatic;
      const AMiniMapConverter: ILocalCoordConverter;
      const AViewConverter: ILocalCoordConverter
    );

    procedure LayerMouseDown(
      Sender: TObject;
      Button: TMouseButton;
      Shift: TShiftState;
      X, Y: Integer
    );
    procedure LayerMouseUP(
      Sender: TObject;
      Button: TMouseButton;
      Shift: TShiftState;
      X, Y: Integer
    );
    procedure LayerMouseMove(
      Sender: TObject;
      Shift: TShiftState;
      X, Y: Integer
    );
    procedure BuildPopUpMenu;
    procedure BuildMapsListUI(AMapssSubMenu, ALayersSubMenu: TTBCustomItem);
    procedure OnClickMapItem(Sender: TObject);
    procedure OnClickLayerItem(Sender: TObject);
  protected
    procedure DoUpdateLayerVisibility; override;
    function GetNewLayerLocation: TFloatRect; override;
    procedure PaintLayer(ABuffer: TBitmap32); override;
    procedure StartThreads; override;
  public
    constructor Create(
      const APerfList: IInternalPerformanceCounterList;
      const AAppStartedNotifier: INotifierOneOperation;
      const AAppClosingNotifier: INotifierOneOperation;
      AParentMap: TImage32;
      const AViewPortState: IViewPortState;
      const AGUIConfigList: IMapTypeGUIConfigList;
      const AIconsList: IMapTypeIconsList;
      const APosition: ILocalCoordConverterChangeable;
      const ATimerNoifier: INotifierTime;
      const AMapsConfig: IActivMapWithLayers;
      const ALocationConfig: IMiniMapLayerLocationConfig
    );
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  c_ZeroGUID,
  i_CoordConverter,
  i_MapTypes,
  u_ListenerByEvent,
  u_SimpleFlagWithInterlock,
  u_ListenerTime,
  u_MapTypeMenuItemsGeneratorBasic,
  u_ActiveMapTBXItem,
  u_GeoFunc,
  u_ResStrings;

{ TMiniMapLayerTopBorder }

constructor TMiniMapLayerViewRect.Create(
  const APerfList: IInternalPerformanceCounterList;
  const AAppStartedNotifier, AAppClosingNotifier: INotifierOneOperation;
  AParentMap: TImage32;
  const AViewPortState: IViewPortState;
  const AGUIConfigList: IMapTypeGUIConfigList;
  const AIconsList: IMapTypeIconsList;
  const APosition: ILocalCoordConverterChangeable;
  const ATimerNoifier: INotifierTime;
  const AMapsConfig: IActivMapWithLayers;
  const ALocationConfig: IMiniMapLayerLocationConfig
);
begin
  inherited Create(
    APerfList,
    AAppStartedNotifier,
    AAppClosingNotifier,
    TPositionedLayer.Create(AParentMap.Layers)
  );
  FMapsConfig := AMapsConfig;
  FLocationConfig := ALocationConfig;
  FParentMap := AParentMap;
  FPosition := APosition;
  FViewPortState := AViewPortState;
  FGUIConfigList := AGUIConfigList;
  FIconsList := AIconsList;

  Layer.OnMouseDown := LayerMouseDown;
  Layer.OnMouseUp := LayerMouseUP;
  Layer.OnMouseMove := LayerMouseMove;

  FLayerChangeFlag := TSimpleFlagWithInterlock.Create;

  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnConfigChange),
    FLocationConfig.ChangeNotifier
  );
  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnPosChange),
    FPosition.ChangeNotifier
  );
  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnViewChange),
    FViewPortState.View.ChangeNotifier
  );
  LinksList.Add(
    TListenerTimeCheck.Create(Self.OnTimer, 100),
    ATimerNoifier
  );

  BuildPopUpMenu;
end;

destructor TMiniMapLayerViewRect.Destroy;
begin
  FreeAndNil(FPopup);
  inherited;
end;

procedure TMiniMapLayerViewRect.BuildMapsListUI(
  AMapssSubMenu, ALayersSubMenu: TTBCustomItem
);
var
  VGenerator: TMapMenuGeneratorBasic;
begin
  VGenerator := TMapMenuGeneratorBasic.Create(
    FGUIConfigList,
    FMapsConfig.GetMapsSet,
    FMapsConfig.GetActiveMap,
    nil,
    AMapssSubMenu,
    Self.OnClickMapItem,
    FIconsList
  );
  try
    VGenerator.BuildControls;
  finally
    VGenerator.Free;
  end;
  VGenerator := TMapMenuGeneratorBasic.Create(
    FGUIConfigList,
    FMapsConfig.GetLayersSet,
    nil,
    FMapsConfig.GetActiveLayersSet,
    ALayersSubMenu,
    Self.OnClickLayerItem,
    FIconsList
  );
  try
    VGenerator.BuildControls;
  finally
    VGenerator.Free;
  end;
end;

procedure TMiniMapLayerViewRect.BuildPopUpMenu;
var
  VSubMenuItem: TTBXSubmenuItem;
  VLayersSubMenu: TTBXSubmenuItem;
  VMenuItemAsMainMap: TTBXCustomItem;
begin
  FPopup := TTBXPopupMenu.Create(nil);
  FPopup.Name := 'PopupMiniMap';
  FPopup.Images := FIconsList.GetImageList;

  VSubMenuItem := TTBXSubmenuItem.Create(FPopup);
  VSubMenuItem.Name := 'MiniMapLayers';
  VSubMenuItem.Caption := SAS_STR_Layers;
  VSubMenuItem.Hint := '';
  VSubMenuItem.SubMenuImages := FPopup.Images;
  FPopup.Items.Add(VSubMenuItem);
  VLayersSubMenu := VSubMenuItem;

  VMenuItemAsMainMap := TActiveMapTBXItem.Create(FPopup, nil, FMapsConfig.GetActiveMap);
  VMenuItemAsMainMap.Name := 'MapAsMainLayer';
  VMenuItemAsMainMap.Caption := SAS_STR_MiniMapAsMainMap;
  VMenuItemAsMainMap.Hint := '';
  VMenuItemAsMainMap.OnClick := Self.OnClickMapItem;
  FPopup.Items.Add(VMenuItemAsMainMap);

  BuildMapsListUI(FPopup.Items, VLayersSubMenu);
end;

procedure TMiniMapLayerViewRect.DoUpdateLayerVisibility;
begin
  inherited;
  Layer.MouseEvents := Visible;
end;

procedure TMiniMapLayerViewRect.DrawMainViewRect(
  ABuffer: TBitmap32;
  const AConfig: IMiniMapLayerLocationConfigStatic;
  const AMiniMapConverter: ILocalCoordConverter;
  const AViewConverter: ILocalCoordConverter
);
var
  VViewMapSourceRect: TDoubleRect;
  VZoomSource: Byte;
  VMiniMapRect: TDoubleRect;
  VBitmapRect: TDoubleRect;
  VLonLatRect: TDoubleRect;
  VGeoConvertSource: ICoordConverter;
  VGeoConvertMiniMap: ICoordConverter;
  VZoomDelta: Integer;
  VSize: TPoint;
  VViewSize: TPoint;
  VWidth: Integer;
  VFillColor: TColor32;
  VBorderColor: TColor32;
  VDrawRect: TRect;
begin
  VWidth := AConfig.Width;
  VSize.X := VWidth;
  VSize.Y := VWidth;
  VViewSize := AViewConverter.GetLocalRectSize;

  if (AViewConverter <> nil) and (AMiniMapConverter <> nil) then begin
    VZoomDelta := AConfig.ZoomDelta;
    if VZoomDelta > 0 then begin
      VViewMapSourceRect := AViewConverter.GetRectInMapPixelFloat;
      VZoomSource := AViewConverter.GetZoom;
      VGeoConvertSource := AViewConverter.GetGeoConverter;
      VGeoConvertSource.CheckPixelRectFloat(VViewMapSourceRect, VZoomSource);
      VLonLatRect := VGeoConvertSource.PixelRectFloat2LonLatRect(VViewMapSourceRect, VZoomSource);
      VGeoConvertMiniMap := AMiniMapConverter.GeoConverter;
      VGeoConvertMiniMap.CheckLonLatRect(VLonLatRect);
      VBitmapRect := AMiniMapConverter.LonLatRect2LocalRectFloat(VLonLatRect);

      VBitmapRect.Left := VBitmapRect.Left + FViewRectMoveDelta.X;
      VBitmapRect.Top := VBitmapRect.Top + FViewRectMoveDelta.Y;
      VBitmapRect.Right := VBitmapRect.Right + FViewRectMoveDelta.X;
      VBitmapRect.Bottom := VBitmapRect.Bottom + FViewRectMoveDelta.Y;

      VMiniMapRect := DoubleRect(AMiniMapConverter.GetLocalRect);
      if IsIntersecProjectedRect(VBitmapRect, VMiniMapRect) then begin
        if
          (VMiniMapRect.Left < VBitmapRect.Left) or
          (VMiniMapRect.Top < VBitmapRect.Top) or
          (VMiniMapRect.Right > VBitmapRect.Right) or
          (VMiniMapRect.Bottom > VBitmapRect.Bottom)
        then begin
          VFillColor := SetAlpha(clWhite32, (VZoomDelta) * 35);
          VBorderColor := SetAlpha(clNavy32, (VZoomDelta) * 43);
          VDrawRect := RectFromDoubleRect(VBitmapRect, rrClosest);
          ABuffer.FillRectTS(VDrawRect, VFillColor);
          ABuffer.FrameRectTS(VDrawRect, VBorderColor);
          ABuffer.FrameRectTS(
            VDrawRect.Left - 1,
            VDrawRect.Top + 1,
            VDrawRect.Right + 1,
            VDrawRect.Bottom - 1,
            VBorderColor
          );
          ABuffer.FrameRectTS(
            VDrawRect.Left + 1,
            VDrawRect.Top - 1,
            VDrawRect.Right - 1,
            VDrawRect.Bottom + 1,
            VBorderColor
          );
        end;
      end;
    end;
  end;
end;

function TMiniMapLayerViewRect.GetNewLayerLocation: TFloatRect;
var
  VLocalConverter: ILocalCoordConverter;
begin
  VLocalConverter := FPosition.GetStatic;
  if Visible and (VLocalConverter <> nil) then begin
    Result := FloatRect(VLocalConverter.GetLocalRect);
  end else begin
    Result := FloatRect(0, 0, 0, 0);
  end;
end;

procedure TMiniMapLayerViewRect.LayerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  VVisibleCenter: TDoublePoint;
  VLocalConverter: ILocalCoordConverter;
begin
  FParentMap.PopupMenu := nil;
  case Button of
    mbRight: begin
      FParentMap.PopupMenu := FPopup;
    end;
    mbLeft: begin
      VLocalConverter := FPosition.GetStatic;
      VVisibleCenter := RectCenter(VLocalConverter.GetLocalRect);
      FPosMoved := True;
      FViewRectMoveDelta := DoublePoint(X - VVisibleCenter.X, Y - VVisibleCenter.Y);
      Layer.Changed;
    end;
  end;
end;

procedure TMiniMapLayerViewRect.LayerMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  VVisibleCenter: TDoublePoint;
  VLocalRect: TRect;
  VLocalConverter: ILocalCoordConverter;
begin
  if FPosMoved then begin
    VLocalConverter := FPosition.GetStatic;
    VLocalRect := VLocalConverter.GetLocalRect;
    VVisibleCenter := RectCenter(VLocalRect);

    if X < VLocalRect.Left then begin
      FViewRectMoveDelta.X := VLocalRect.Left - VVisibleCenter.X;
    end else if X > VLocalRect.Right then begin
      FViewRectMoveDelta.X := VLocalRect.Right - VVisibleCenter.X;
    end else begin
      FViewRectMoveDelta.X := X - VVisibleCenter.X;
    end;
    if Y < VLocalRect.Top then begin
      FViewRectMoveDelta.Y := VLocalRect.Top - VVisibleCenter.Y;
    end else if Y > VLocalRect.Bottom then begin
      FViewRectMoveDelta.Y := VLocalRect.Bottom - VVisibleCenter.Y;
    end else begin
      FViewRectMoveDelta.Y := Y - VVisibleCenter.Y;
    end;

    Layer.Changed;
  end;
end;

procedure TMiniMapLayerViewRect.LayerMouseUP(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  VLocalConverter: ILocalCoordConverter;
  VConverter: ICoordConverter;
  VZoom: Byte;
  VMapPoint: TDoublePoint;
  VLonLat: TDoublePoint;
begin
  if FPosMoved then begin
    if Layer.HitTest(X, Y) then begin
      VLocalConverter := FPosition.GetStatic;
      VConverter := VLocalConverter.GetGeoConverter;
      VZoom := VLocalConverter.GetZoom;

      VMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(Point(X, Y));
      VConverter.CheckPixelPosFloatStrict(VMapPoint, VZoom, False);
      VLonLat := VConverter.PixelPosFloat2LonLat(VMapPoint, VZoom);
      FViewRectMoveDelta := DoublePoint(0, 0);

      FViewPortState.ChangeLonLat(VLonLat);
    end else begin
      FViewRectMoveDelta := DoublePoint(0, 0);
      Layer.Changed;
    end;
  end;
  FPosMoved := False;
end;

procedure TMiniMapLayerViewRect.OnClickLayerItem(Sender: TObject);
var
  VSender: TTBCustomItem;
  VMapType: IMapType;
begin
  if Sender is TTBCustomItem then begin
    VSender := TTBCustomItem(Sender);
    VMapType := IMapType(VSender.Tag);
    if VMapType <> nil then begin
      FMapsConfig.InvertLayerSelectionByGUID(VMapType.GUID);
    end;
  end;
end;

procedure TMiniMapLayerViewRect.OnClickMapItem(Sender: TObject);
var
  VSender: TComponent;
  VMapType: IMapType;
  VGUID: TGUID;
begin
  if Sender is TComponent then begin
    VGUID := CGUID_Zero;
    VSender := TComponent(Sender);
    VMapType := IMapType(VSender.Tag);
    if VMapType <> nil then begin
      VGUID := VMapType.GUID;
    end;
    FMapsConfig.SelectMainByGUID(VGUID);
  end;
end;

procedure TMiniMapLayerViewRect.OnConfigChange;
begin
  FLayerChangeFlag.SetFlag;
end;

procedure TMiniMapLayerViewRect.OnPosChange;
begin
  FLayerChangeFlag.SetFlag;
end;

procedure TMiniMapLayerViewRect.OnTimer;
var
  VConfig: IMiniMapLayerLocationConfigStatic;
begin
  if FLayerChangeFlag.CheckFlagAndReset then begin
    ViewUpdateLock;
    try
      VConfig := FLocationConfig.GetStatic;
      if Visible <> VConfig.Visible then begin
        Visible := VConfig.Visible;
      end;
      SetNeedUpdateLayerLocation;
      SetNeedFullRepaintLayer;
    finally
      ViewUpdateUnlock;
    end;
  end;
end;

procedure TMiniMapLayerViewRect.OnViewChange;
begin
  FLayerChangeFlag.SetFlag;
end;

procedure TMiniMapLayerViewRect.PaintLayer(ABuffer: TBitmap32);
var
  VMiniMapConverter: ILocalCoordConverter;
  VViewConverter: ILocalCoordConverter;
begin
  VMiniMapConverter := FPosition.GetStatic;
  VViewConverter := FViewPortState.View.GetStatic;
  if (VMiniMapConverter <> nil) and (VViewConverter <> nil) then begin
    DrawMainViewRect(ABuffer, FLocationConfig.GetStatic, VMiniMapConverter, VViewConverter);
  end;
end;

procedure TMiniMapLayerViewRect.StartThreads;
begin
  inherited;
  OnConfigChange;
end;

end.
