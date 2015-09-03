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

unit u_MapViewPortState;

interface

uses
  Types,
  t_GeoTypes,
  i_Notifier,
  i_Listener,
  i_CoordConverter,
  i_ProjectionSet,
  i_CoordConverterFactory,
  i_LocalCoordConverter,
  i_LocalCoordConverterChangeable,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_InternalPerformanceCounter,
  i_ViewPortState,
  i_MapType,
  i_LocalCoordConverterFactorySimpe,
  u_ConfigDataElementBase;

type
  TMapViewPortState = class(TConfigDataElementBase, IViewPortState)
  private
    FProjectionFactory: IProjectionInfoFactory;
    FVisibleCoordConverterFactory: ILocalCoordConverterFactorySimpe;
    FMainMap: IMapTypeChangeable;
    FBaseScale: Double;

    FView: ILocalCoordConverterChangeableInternal;
    FMainMapChangeListener: IListener;

    FMainProjectionSet: IProjectionSet;

    function _GetActiveProjectionSet: IProjectionSet;
    procedure _SetActiveProjectionSet;
    procedure OnMainMapChange;
  protected
    procedure DoReadConfig(const AConfigData: IConfigDataProvider); override;
    procedure DoWriteConfig(const AConfigData: IConfigDataWriteProvider); override;
  private
    function GetMainProjectionSet: IProjectionSet;
    procedure SetMainProjectionSet(const AValue: IProjectionSet);

    function GetCurrentZoom: Byte;

    function GetView: ILocalCoordConverterChangeable;

    procedure ChangeViewSize(const ANewSize: TPoint);
    procedure ChangeMapPixelByLocalDelta(const ADelta: TDoublePoint);
    procedure ChangeMapPixelToVisualPoint(const AVisualPoint: TPoint);
    procedure ChangeZoomWithFreezeAtVisualPoint(
      const AZoom: Byte;
      const AFreezePoint: TPoint
    );
    procedure ChangeLonLat(const ALonLat: TDoublePoint);
    procedure ChangeLonLatAndZoom(
      const AZoom: Byte;
      const ALonLat: TDoublePoint
    );

    procedure ChangeZoomWithFreezeAtCenter(const AZoom: Byte);
    procedure ChangeZoomWithFreezeAtVisualPointWithScale(
      const AZoom: Byte;
      const AFreezePoint: TPoint
    );

    procedure ScaleTo(
      const AScale: Double;
      const AFreezePoint: TPoint
    );
  public
    constructor Create(
      const AProjectionFactory: IProjectionInfoFactory;
      const ACoordConverterFactory: ILocalCoordConverterFactorySimpe;
      const AMainMap: IMapTypeChangeable;
      const APerfCounterList: IInternalPerformanceCounterList
    );
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  i_ProjectionInfo,
  u_ListenerByEvent,
  u_LocalCoordConverterChangeable,
  u_GeoFunc;

{ TMapViewPortStateNew }

constructor TMapViewPortState.Create(
  const AProjectionFactory: IProjectionInfoFactory;
  const ACoordConverterFactory: ILocalCoordConverterFactorySimpe;
  const AMainMap: IMapTypeChangeable;
  const APerfCounterList: IInternalPerformanceCounterList
);
var
  VProjectionSet: IProjectionSet;
  VProjection: IProjectionInfo;
  VLocalConverter: ILocalCoordConverter;
  VCenterPoint: TDoublePoint;
  VLocalRect: TRect;
  VLocalCenter: TDoublePoint;
  VZoom: Byte;
begin
  inherited Create;

  FProjectionFactory := AProjectionFactory;
  FVisibleCoordConverterFactory := ACoordConverterFactory;
  FMainMap := AMainMap;
  FMainProjectionSet := nil;

  FMainMapChangeListener := TNotifyNoMmgEventListener.Create(Self.OnMainMapChange);
  FBaseScale := 1;

  VProjectionSet := _GetActiveProjectionSet;
  VZoom := 0;
  VProjectionSet.ValidateZoom(VZoom);
  VProjection := VProjectionSet[VZoom];

  VCenterPoint := RectCenter(VProjection.GetPixelRect);
  VLocalRect := Rect(0, 0, 1024, 768);
  VLocalCenter := RectCenter(VLocalRect);

  VLocalConverter :=
    FVisibleCoordConverterFactory.CreateConverter(
      VLocalRect,
      VProjection,
      FBaseScale,
      DoublePoint(VCenterPoint.X - VLocalCenter.X / FBaseScale, VCenterPoint.Y - VLocalCenter.Y / FBaseScale)
    );
  FView :=
    TLocalCoordConverterChangeable.Create(
      VLocalConverter,
      APerfCounterList.CreateAndAddNewCounter('ScaleChange')
    );
  FMainMap.ChangeNotifier.Add(FMainMapChangeListener);
end;

destructor TMapViewPortState.Destroy;
begin
  if Assigned(FMainMap) and Assigned(FMainMapChangeListener) then begin
    FMainMap.ChangeNotifier.Remove(FMainMapChangeListener);
    FMainMapChangeListener := nil;
    FMainMap := nil;
  end;
  FVisibleCoordConverterFactory := nil;
  inherited;
end;

procedure TMapViewPortState.ChangeLonLat(const ALonLat: TDoublePoint);
var
  VLocalConverter: ILocalCoordConverter;
  VLocalConverterNew: ILocalCoordConverter;
begin
  LockWrite;
  try
    VLocalConverter := FView.GetStatic;
    VLocalConverterNew :=
      FVisibleCoordConverterFactory.ChangeCenterLonLat(
        VLocalConverter,
        ALonLat
      );
    FView.SetConverter(VLocalConverterNew);
  finally
    UnlockWrite;
  end;
end;

procedure TMapViewPortState.ChangeLonLatAndZoom(
  const AZoom: Byte;
  const ALonLat: TDoublePoint
);
var
  VLocalConverter: ILocalCoordConverter;
  VLocalConverterNew: ILocalCoordConverter;
  VConverter: ICoordConverter;
  VZoom: Byte;
  VProjection: IProjectionInfo;
  VLonLat: TDoublePoint;
  VMapPixelCenter: TDoublePoint;
  VMapTopLeft: TDoublePoint;
  VLocalRect: TRect;
  VLocalCenter: TDoublePoint;
begin
  LockWrite;
  try
    VLocalConverter := FView.GetStatic;
    VConverter := VLocalConverter.GeoConverter;
    VZoom := AZoom;
    VConverter.ValidateZoom(VZoom);
    VProjection := FProjectionFactory.GetByConverterAndZoom(VConverter, VZoom);
    VLonLat := ALonLat;
    VConverter.ValidateLonLatPos(VLonLat);
    VMapPixelCenter := VProjection.LonLat2PixelPosFloat(VLonLat);
    VLocalRect := VLocalConverter.GetLocalRect;
    VLocalCenter := RectCenter(VLocalRect);
    VMapTopLeft.X := VMapPixelCenter.X - VLocalCenter.X;
    VMapTopLeft.Y := VMapPixelCenter.Y - VLocalCenter.Y;
    VLocalConverterNew :=
      FVisibleCoordConverterFactory.CreateConverter(
        VLocalConverter.GetLocalRect,
        VProjection,
        FBaseScale,
        VMapTopLeft
      );
    FView.SetConverter(VLocalConverterNew);
  finally
    UnlockWrite;
  end;
end;

procedure TMapViewPortState.ChangeMapPixelByLocalDelta(const ADelta: TDoublePoint);
var
  VLocalConverter: ILocalCoordConverter;
  VLocalConverterNew: ILocalCoordConverter;
begin
  if (Abs(ADelta.X) > 0.001) or (Abs(ADelta.Y) > 0.001) then begin
    LockWrite;
    try
      VLocalConverter := FView.GetStatic;
      VLocalConverterNew :=
        FVisibleCoordConverterFactory.ChangeByLocalDelta(
          VLocalConverter,
          ADelta
        );
      FView.SetConverter(VLocalConverterNew);
    finally
      UnlockWrite;
    end;
  end;
end;

procedure TMapViewPortState.ChangeMapPixelToVisualPoint(
  const AVisualPoint: TPoint
);
var
  VLocalConverter: ILocalCoordConverter;
  VLocalConverterNew: ILocalCoordConverter;
begin
  LockWrite;
  try
    VLocalConverter := FView.GetStatic;
    VLocalConverterNew :=
      FVisibleCoordConverterFactory.ChangeCenterToLocalPoint(
        VLocalConverter,
        AVisualPoint
      );
    FView.SetConverter(VLocalConverterNew);
  finally
    UnlockWrite;
  end;
end;

procedure TMapViewPortState.ChangeViewSize(const ANewSize: TPoint);
var
  VLocalConverter: ILocalCoordConverter;
  VLocalConverterNew: ILocalCoordConverter;
  VLocalRectNew: TRect;
  VLocalRectOld: TRect;
  VLocalCenterOld: TDoublePoint;
  VLocalCenterNew: TDoublePoint;
  VTopLeftMapPixel: TDoublePoint;
  VScale: Double;
begin
  if ANewSize.X <= 0 then begin
    raise Exception.Create('��������� ������ ������������ �����');
  end;
  if ANewSize.Y <= 0 then begin
    raise Exception.Create('��������� ������ ������������ �����');
  end;
  VLocalRectNew := Rect(0, 0, ANewSize.X, ANewSize.Y);
  LockWrite;
  try
    VLocalConverter := FView.GetStatic;
    VLocalRectOld := VLocalConverter.GetLocalRect;
    if not EqualRect(VLocalRectOld, VLocalRectNew) then begin
      VLocalCenterOld := RectCenter(VLocalRectOld);
      VLocalCenterNew := RectCenter(VLocalRectNew);
      VTopLeftMapPixel := VLocalConverter.GetRectInMapPixelFloat.TopLeft;
      VScale := VLocalConverter.GetScale;
      VTopLeftMapPixel.X := VTopLeftMapPixel.X + (VLocalCenterOld.X - VLocalCenterNew.X) / VScale;
      VTopLeftMapPixel.Y := VTopLeftMapPixel.Y + (VLocalCenterOld.Y - VLocalCenterNew.Y) / VScale;
      VLocalConverterNew :=
        FVisibleCoordConverterFactory.CreateConverter(
          VLocalRectNew,
          VLocalConverter.ProjectionInfo,
          VScale,
          VTopLeftMapPixel
        );
      FView.SetConverter(VLocalConverterNew);
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TMapViewPortState.ChangeZoomWithFreezeAtCenter(const AZoom: Byte);
var
  VLocalConverter: ILocalCoordConverter;
  VLocalConverterNew: ILocalCoordConverter;
begin
  LockWrite;
  try
    VLocalConverter := FView.GetStatic;
    VLocalConverterNew :=
      FVisibleCoordConverterFactory.ChangeZoomWithFreezeAtCenter(
        VLocalConverter,
        AZoom
      );
    FView.SetConverter(VLocalConverterNew);
  finally
    UnlockWrite;
  end;
end;

procedure TMapViewPortState.ChangeZoomWithFreezeAtVisualPoint(
  const AZoom: Byte;
  const AFreezePoint: TPoint
);
var
  VLocalConverter: ILocalCoordConverter;
  VLocalConverterNew: ILocalCoordConverter;
begin
  LockWrite;
  try
    VLocalConverter := FView.GetStatic;
    VLocalConverterNew :=
      FVisibleCoordConverterFactory.ChangeZoomWithFreezeAtVisualPoint(
        VLocalConverter,
        AZoom,
        AFreezePoint
      );
    FView.SetConverter(VLocalConverterNew);
  finally
    UnlockWrite;
  end;
end;

procedure TMapViewPortState.ChangeZoomWithFreezeAtVisualPointWithScale(
  const AZoom: Byte;
  const AFreezePoint: TPoint
);
var
  VLocalConverter: ILocalCoordConverter;
  VLocalViewConverterNew: ILocalCoordConverter;
  VZoomOld: Byte;
  VZoomNew: Byte;
  VConverter: ICoordConverter;
  VLocalRect: TRect;
  VScaleOld: Double;
  VScaleNew: Double;
  VTopLefAtMapView: TDoublePoint;
  VFreezePoint: TDoublePoint;
  VFreezeMapPoint: TDoublePoint;
  VRelativeFreezePoint: TDoublePoint;
  VMapFreezPointAtNewZoom: TDoublePoint;
  VProjectionNew: IProjectionInfo;
  VProjectionOld: IProjectionInfo;
begin
  LockWrite;
  try
    VLocalConverter := FView.GetStatic;
    VProjectionOld := VLocalConverter.ProjectionInfo;
    VZoomOld := VLocalConverter.Zoom;
    VZoomNew := AZoom;
    VConverter := VLocalConverter.GeoConverter;
    VConverter.ValidateZoom(VZoomNew);
    if VZoomOld = VZoomNew then begin
      Exit;
    end;
    VProjectionNew := FProjectionFactory.GetByConverterAndZoom(VConverter, VZoomNew);
    
    VFreezeMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(AFreezePoint);
    VProjectionOld.ValidatePixelPosFloatStrict(VFreezeMapPoint, False);
    VFreezePoint := VLocalConverter.MapPixelFloat2LocalPixelFloat(VFreezeMapPoint);
    VRelativeFreezePoint := VProjectionOld.PixelPosFloat2Relative(VFreezeMapPoint);
    VMapFreezPointAtNewZoom := VProjectionNew.Relative2PixelPosFloat(VRelativeFreezePoint);

    VLocalRect := VLocalConverter.GetLocalRect;
    VScaleOld := VLocalConverter.GetScale;

    VScaleNew := VScaleOld * (VProjectionOld.GetPixelsFloat / VProjectionNew.GetPixelsFloat);
    VTopLefAtMapView.X := VMapFreezPointAtNewZoom.X - VFreezePoint.X / VScaleNew;
    VTopLefAtMapView.Y := VMapFreezPointAtNewZoom.Y - VFreezePoint.Y / VScaleNew;
    VLocalViewConverterNew :=
      FVisibleCoordConverterFactory.CreateConverter(
        VLocalRect,
        VProjectionNew,
        VScaleNew,
        VTopLefAtMapView
      );
    FView.SetConverter(VLocalViewConverterNew);
  finally
    UnlockWrite;
  end;
end;

procedure TMapViewPortState.DoReadConfig(const AConfigData: IConfigDataProvider);
var
  VLonLat: TDoublePoint;
  VZoom: Byte;
  VLocalConverter: ILocalCoordConverter;
  VGeoConverter: ICoordConverter;
  VLocalConverterNew: ILocalCoordConverter;
begin
  inherited;
  if AConfigData <> nil then begin
    VLocalConverter := FView.GetStatic;
    VGeoConverter := VLocalConverter.GeoConverter;
    VZoom := AConfigData.ReadInteger('Zoom', VLocalConverter.Zoom);
    VGeoConverter.ValidateZoom(VZoom);
    VLonLat := VLocalConverter.GetCenterLonLat;
    VLonLat.X := AConfigData.ReadFloat('X', VLonLat.X);
    VLonLat.Y := AConfigData.ReadFloat('Y', VLonLat.Y);
    VGeoConverter.ValidateLonLatPos(VLonLat);

    VLocalConverterNew :=
      FVisibleCoordConverterFactory.ChangeCenterLonLatAndZoom(
        VLocalConverter,
        VZoom,
        VLonLat
      );
    FView.SetConverter(VLocalConverterNew);
  end;
end;

procedure TMapViewPortState.DoWriteConfig(
  const AConfigData: IConfigDataWriteProvider
);
var
  VLonLat: TDoublePoint;
  VLocalConverter: ILocalCoordConverter;
begin
  inherited;
  VLocalConverter := FView.GetStatic;
  VLonLat := VLocalConverter.GetCenterLonLat;
  AConfigData.WriteInteger('Zoom', VLocalConverter.Zoom);
  AConfigData.WriteFloat('X', VLonLat.X);
  AConfigData.WriteFloat('Y', VLonLat.Y);
end;

function TMapViewPortState._GetActiveProjectionSet: IProjectionSet;
var
  VMapType: IMapType;
begin
  Result := nil;
  if FMainProjectionSet <> nil then begin
    Result := FMainProjectionSet;
  end else begin
    VMapType := FMainMap.GetStatic;
    if VMapType <> nil then begin
      Result := VMapType.ViewProjectionSet;
    end;
  end;
end;

function TMapViewPortState.GetCurrentZoom: Byte;
begin
  LockRead;
  try
    Result := FView.GetStatic.Zoom;
  finally
    UnlockRead;
  end;
end;

function TMapViewPortState.GetMainProjectionSet: IProjectionSet;
begin
  LockRead;
  try
    Result := FMainProjectionSet;
  finally
    UnlockRead;
  end;
end;

function TMapViewPortState.GetView: ILocalCoordConverterChangeable;
begin
  Result := FView;
end;

procedure TMapViewPortState.OnMainMapChange;
begin
  LockWrite;
  try
    _SetActiveProjectionSet;
  finally
    UnlockWrite
  end;
end;

procedure TMapViewPortState.ScaleTo(
  const AScale: Double;
  const AFreezePoint: TPoint
);
var
  VVisiblePointFixed: TDoublePoint;
  VMapPointFixed: TDoublePoint;
  VNewMapScale: Double;
  VLocalConverter: ILocalCoordConverter;
  VLocalConverterNew: ILocalCoordConverter;
  VGeoConverter: ICoordConverter;
  VZoom: Byte;
  VTopLeftMapPosNew: TDoublePoint;
  VLocalRect: TRect;
begin
  LockWrite;
  try
    VLocalConverter := FView.GetStatic;
    if Abs(AScale - 1) < 0.001 then begin
      VNewMapScale := FBaseScale;
    end else begin
      VNewMapScale := FBaseScale * AScale;
    end;
    VZoom := VLocalConverter.Zoom;
    VGeoConverter := VLocalConverter.GeoConverter;
    VMapPointFixed := VLocalConverter.LocalPixel2MapPixelFloat(AFreezePoint);
    VGeoConverter.ValidatePixelPosFloatStrict(VMapPointFixed, VZoom, False);
    VVisiblePointFixed := VLocalConverter.MapPixelFloat2LocalPixelFloat(VMapPointFixed);

    VLocalRect := VLocalConverter.GetLocalRect;
    VTopLeftMapPosNew.X := VMapPointFixed.X - VVisiblePointFixed.X / VNewMapScale;
    VTopLeftMapPosNew.Y := VMapPointFixed.Y - VVisiblePointFixed.Y / VNewMapScale;

    VLocalConverterNew :=
      FVisibleCoordConverterFactory.CreateConverter(
        VLocalRect,
        VLocalConverter.ProjectionInfo,
        VNewMapScale,
        VTopLeftMapPosNew
      );
    FView.SetConverter(VLocalConverterNew);
  finally
    UnlockWrite;
  end;
end;

procedure TMapViewPortState._SetActiveProjectionSet;
var
  VLocalConverter: ILocalCoordConverter;
  VLocalConverterNew: ILocalCoordConverter;
  VProjectionSet: IProjectionSet;
  VProjection: IProjectionInfo;
begin
  VLocalConverter := FView.GetStatic;
  VProjectionSet := _GetActiveProjectionSet;
  VProjection := VProjectionSet.GetSuitableProjection(VLocalConverter.ProjectionInfo);
  if not VProjection.GetIsSameProjectionInfo(VLocalConverter.ProjectionInfo) then begin
    VLocalConverterNew :=
      FVisibleCoordConverterFactory.ChangeConverter(
        VLocalConverter,
        VProjection
      );
    FView.SetConverter(VLocalConverterNew);
  end;
end;

procedure TMapViewPortState.SetMainProjectionSet(const AValue: IProjectionSet);
begin
  LockWrite;
  try
    if FMainProjectionSet <> AValue then begin
      FMainProjectionSet := AValue;
      _SetActiveProjectionSet;
    end;
  finally
    UnlockWrite;
  end;
end;

end.
