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

unit u_ViewPortState;

interface

uses
  Types,
  SysUtils,
  t_GeoTypes,
  i_Notifier,
  i_Listener,
  i_ProjectionSet,
  i_LocalCoordConverter,
  i_LocalCoordConverterChangeable,
  i_InternalPerformanceCounter,
  i_ProjectionSetChangeable,
  i_ViewPortState,
  i_LocalCoordConverterFactorySimpe,
  u_BaseInterfacedObject;

type
  TViewPortState = class(TBaseInterfacedObject, IViewPortState)
  private
    FVisibleCoordConverterFactory: ILocalCoordConverterFactorySimpe;
    FProjectionSet: IProjectionSetChangeable;
    FBaseScale: Double;
    FCS: IReadWriteSync;

    FView: ILocalCoordConverterChangeableInternal;
    FProjectionSetListener: IListener;

    procedure OnProjectionSetChange;
  private
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
      const ACoordConverterFactory: ILocalCoordConverterFactorySimpe;
      const AProjectionSet: IProjectionSetChangeable;
      const APerfCounterList: IInternalPerformanceCounterList
    );
    destructor Destroy; override;
  end;

implementation

uses
  i_Projection,
  u_ListenerByEvent,
  u_LocalCoordConverterChangeable,
  u_Synchronizer,
  u_GeoFunc;

{ TViewPortStateNew }

constructor TViewPortState.Create(
  const ACoordConverterFactory: ILocalCoordConverterFactorySimpe;
  const AProjectionSet: IProjectionSetChangeable;
  const APerfCounterList: IInternalPerformanceCounterList
);
var
  VProjectionSet: IProjectionSet;
  VProjection: IProjection;
  VLocalConverter: ILocalCoordConverter;
  VCenterPoint: TDoublePoint;
  VLocalRect: TRect;
  VLocalCenter: TDoublePoint;
begin
  inherited Create;

  FVisibleCoordConverterFactory := ACoordConverterFactory;
  FProjectionSet := AProjectionSet;

  FCS := GSync.SyncVariable.Make(Self.ClassName);
  FProjectionSetListener := TNotifyNoMmgEventListener.Create(Self.OnProjectionSetChange);
  FBaseScale := 1;

  VProjectionSet := FProjectionSet.GetStatic;
  VProjection := VProjectionSet[0];

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
  FProjectionSet.ChangeNotifier.Add(FProjectionSetListener);
end;

destructor TViewPortState.Destroy;
begin
  if Assigned(FProjectionSet) and Assigned(FProjectionSetListener) then begin
    FProjectionSet.ChangeNotifier.Remove(FProjectionSetListener);
    FProjectionSetListener := nil;
    FProjectionSet := nil;
  end;
  inherited;
end;

procedure TViewPortState.ChangeLonLat(const ALonLat: TDoublePoint);
var
  VLocalConverter: ILocalCoordConverter;
  VLocalConverterNew: ILocalCoordConverter;
begin
  FCS.BeginWrite;
  try
    VLocalConverter := FView.GetStatic;
    VLocalConverterNew :=
      FVisibleCoordConverterFactory.ChangeCenterLonLat(
        VLocalConverter,
        ALonLat
      );
    FView.SetConverter(VLocalConverterNew);
  finally
    FCS.EndWrite;
  end;
end;

procedure TViewPortState.ChangeLonLatAndZoom(
  const AZoom: Byte;
  const ALonLat: TDoublePoint
);
var
  VLocalConverter: ILocalCoordConverter;
  VLocalConverterNew: ILocalCoordConverter;
  VProjectionSet: IProjectionSet;
  VZoom: Byte;
  VProjection: IProjection;
  VLonLat: TDoublePoint;
  VMapPixelCenter: TDoublePoint;
  VMapTopLeft: TDoublePoint;
  VLocalRect: TRect;
  VLocalCenter: TDoublePoint;
begin
  FCS.BeginWrite;
  try
    VLocalConverter := FView.GetStatic;
    VProjectionSet := FProjectionSet.GetStatic;
    VZoom := AZoom;
    VProjectionSet.ValidateZoom(VZoom);
    VProjection := VProjectionSet.Zooms[VZoom];
    VLonLat := ALonLat;
    VProjection.ProjectionType.ValidateLonLatPos(VLonLat);
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
    FCS.EndWrite;
  end;
end;

procedure TViewPortState.ChangeMapPixelByLocalDelta(const ADelta: TDoublePoint);
var
  VLocalConverter: ILocalCoordConverter;
  VLocalConverterNew: ILocalCoordConverter;
begin
  if (Abs(ADelta.X) > 0.001) or (Abs(ADelta.Y) > 0.001) then begin
    FCS.BeginWrite;
    try
      VLocalConverter := FView.GetStatic;
      VLocalConverterNew :=
        FVisibleCoordConverterFactory.ChangeByLocalDelta(
          VLocalConverter,
          ADelta
        );
      FView.SetConverter(VLocalConverterNew);
    finally
      FCS.EndWrite;
    end;
  end;
end;

procedure TViewPortState.ChangeMapPixelToVisualPoint(
  const AVisualPoint: TPoint
);
var
  VLocalConverter: ILocalCoordConverter;
  VLocalConverterNew: ILocalCoordConverter;
begin
  FCS.BeginWrite;
  try
    VLocalConverter := FView.GetStatic;
    VLocalConverterNew :=
      FVisibleCoordConverterFactory.ChangeCenterToLocalPoint(
        VLocalConverter,
        AVisualPoint
      );
    FView.SetConverter(VLocalConverterNew);
  finally
    FCS.EndWrite;
  end;
end;

procedure TViewPortState.ChangeViewSize(const ANewSize: TPoint);
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
  FCS.BeginWrite;
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
          VLocalConverter.Projection,
          VScale,
          VTopLeftMapPixel
        );
      FView.SetConverter(VLocalConverterNew);
    end;
  finally
    FCS.EndWrite;
  end;
end;

procedure TViewPortState.ChangeZoomWithFreezeAtCenter(const AZoom: Byte);
var
  VLocalConverter: ILocalCoordConverter;
  VProjectionSet: IProjectionSet;
  VZoom: Byte;
  VProjection: IProjection;
  VLocalConverterNew: ILocalCoordConverter;
begin
  FCS.BeginWrite;
  try
    VLocalConverter := FView.GetStatic;
    VProjectionSet := FProjectionSet.GetStatic;
    VZoom := AZoom;
    VProjectionSet.ValidateZoom(VZoom);
    VProjection := VProjectionSet.Zooms[VZoom];

    VLocalConverterNew :=
      FVisibleCoordConverterFactory.ChangeProjectionWithFreezeAtCenter(
        VLocalConverter,
        VProjection
      );
    FView.SetConverter(VLocalConverterNew);
  finally
    FCS.EndWrite;
  end;
end;

procedure TViewPortState.ChangeZoomWithFreezeAtVisualPoint(
  const AZoom: Byte;
  const AFreezePoint: TPoint
);
var
  VLocalConverter: ILocalCoordConverter;
  VProjectionSet: IProjectionSet;
  VZoom: Byte;
  VProjection: IProjection;
  VLocalConverterNew: ILocalCoordConverter;
begin
  FCS.BeginWrite;
  try
    VLocalConverter := FView.GetStatic;
    VProjectionSet := FProjectionSet.GetStatic;
    VZoom := AZoom;
    VProjectionSet.ValidateZoom(VZoom);
    VProjection := VProjectionSet.Zooms[VZoom];
    VLocalConverterNew :=
      FVisibleCoordConverterFactory.ChangeProjectionWithFreezeAtVisualPoint(
        VLocalConverter,
        VProjection,
        AFreezePoint
      );
    FView.SetConverter(VLocalConverterNew);
  finally
    FCS.EndWrite;
  end;
end;

procedure TViewPortState.ChangeZoomWithFreezeAtVisualPointWithScale(
  const AZoom: Byte;
  const AFreezePoint: TPoint
);
var
  VLocalConverter: ILocalCoordConverter;
  VProjectionSet: IProjectionSet;
  VZoom: Byte;
  VProjection: IProjection;
  VLocalConverterNew: ILocalCoordConverter;
begin
  FCS.BeginWrite;
  try
    VLocalConverter := FView.GetStatic;
    VProjectionSet := FProjectionSet.GetStatic;
    VZoom := AZoom;
    VProjectionSet.ValidateZoom(VZoom);
    VProjection := VProjectionSet.Zooms[VZoom];
    VLocalConverterNew :=
      FVisibleCoordConverterFactory.ChangeProjectionWithScaleUpdate(
        VLocalConverter,
        VProjection
      );
    FView.SetConverter(VLocalConverterNew);
  finally
    FCS.EndWrite;
  end;
end;

function TViewPortState.GetView: ILocalCoordConverterChangeable;
begin
  Result := FView;
end;

procedure TViewPortState.OnProjectionSetChange;
var
  VLocalConverter: ILocalCoordConverter;
  VProjectionSet: IProjectionSet;
  VProjection: IProjection;
  VLocalConverterNew: ILocalCoordConverter;
begin
  FCS.BeginWrite;
  try
    VLocalConverter := FView.GetStatic;
    VProjectionSet := FProjectionSet.GetStatic;
    VProjection := VProjectionSet.GetSuitableProjection(VLocalConverter.Projection);
    VLocalConverterNew :=
      FVisibleCoordConverterFactory.ChangeProjectionWithFreezeAtCenter(
        VLocalConverter,
        VProjection
      );
    FView.SetConverter(VLocalConverterNew);
  finally
    FCS.EndWrite;
  end;
end;

procedure TViewPortState.ScaleTo(
  const AScale: Double;
  const AFreezePoint: TPoint
);
var
  VVisiblePointFixed: TDoublePoint;
  VMapPointFixed: TDoublePoint;
  VNewMapScale: Double;
  VLocalConverter: ILocalCoordConverter;
  VLocalConverterNew: ILocalCoordConverter;
  VProjection: IProjection;
  VTopLeftMapPosNew: TDoublePoint;
  VLocalRect: TRect;
begin
  FCS.BeginWrite;
  try
    VLocalConverter := FView.GetStatic;
    if Abs(AScale - 1) < 0.001 then begin
      VNewMapScale := FBaseScale;
    end else begin
      VNewMapScale := FBaseScale * AScale;
    end;
    VProjection := VLocalConverter.Projection;
    VMapPointFixed := VLocalConverter.LocalPixel2MapPixelFloat(AFreezePoint);
    VProjection.ValidatePixelPosFloatStrict(VMapPointFixed, False);
    VVisiblePointFixed := VLocalConverter.MapPixelFloat2LocalPixelFloat(VMapPointFixed);

    VLocalRect := VLocalConverter.GetLocalRect;
    VTopLeftMapPosNew.X := VMapPointFixed.X - VVisiblePointFixed.X / VNewMapScale;
    VTopLeftMapPosNew.Y := VMapPointFixed.Y - VVisiblePointFixed.Y / VNewMapScale;

    VLocalConverterNew :=
      FVisibleCoordConverterFactory.CreateConverter(
        VLocalRect,
        VProjection,
        VNewMapScale,
        VTopLeftMapPosNew
      );
    FView.SetConverter(VLocalConverterNew);
  finally
    FCS.EndWrite;
  end;
end;

end.
