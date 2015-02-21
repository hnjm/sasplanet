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

unit u_PolyLineLayerBase;

interface

uses
  GR32,
  GR32_Polygons,
  GR32_Transforms,
  GR32_Image,
  i_NotifierOperation,
  i_LocalCoordConverter,
  i_LocalCoordConverterChangeable,
  i_InternalPerformanceCounter,
  i_LineOnMapEdit,
  i_ProjectionInfo,
  i_DoublePointsAggregator,
  i_GeometryProjectedFactory,
  i_GeometryLonLat,
  i_GeometryProjected,
  i_PolyLineLayerConfig,
  i_PolygonLayerConfig,
  u_MapLayerBasicNoBitmap;

type
  TLineLayerBase = class(TMapLayerBasicNoBitmap)
  private
    FVectorGeometryProjectedFactory: IGeometryProjectedFactory;
    FConfig: ILineLayerConfig;

    FLineVisible: Boolean;
    FLineColor: TColor32;
    FLineWidth: Integer;
    FSimpleLineDraw: Boolean;

    FPreparedPointsAggreagtor: IDoublePointsAggregator;
  protected
    property Factory: IGeometryProjectedFactory read FVectorGeometryProjectedFactory;
    property PreparedPointsAggreagtor: IDoublePointsAggregator read FPreparedPointsAggreagtor;
    procedure OnConfigChange;
    procedure DoConfigChange; virtual;
    procedure StartThreads; override;
  public
    constructor Create(
      const APerfList: IInternalPerformanceCounterList;
      const AAppStartedNotifier: INotifierOneOperation;
      const AAppClosingNotifier: INotifierOneOperation;
      AParentMap: TImage32;
      const AView: ILocalCoordConverterChangeable;
      const AVectorGeometryProjectedFactory: IGeometryProjectedFactory;
      const AConfig: ILineLayerConfig
    );
  end;

  IDrawablePolygon = interface
    ['{EB682EC5-9DD3-4B9C-84AD-44A5EED26FA6}']
    procedure DrawFill(
      Bitmap: TCustomBitmap32;
      Color: TColor32;
      Transformation: TTransformation = nil
    );
    procedure DrawEdge(
      Bitmap: TCustomBitmap32;
      Color: TColor32;
      Transformation: TTransformation = nil
    );
    procedure Draw(
      Bitmap: TCustomBitmap32;
      OutlineColor, FillColor: TColor32;
      Transformation: TTransformation = nil
    );
  end;

  TDrawablePolygon32 = class(TPolygon32, IDrawablePolygon)
  public
    constructor Create; override;
    constructor CreateFromSource(ASource: TPolygon32);
  end;

  TPathLayerBase = class(TLineLayerBase)
  private
    FLine: IGeometryLonLatLine;
    FProjection: IProjectionInfo;
    FProjectedLine: IGeometryProjectedLine;
    FLocalConverter: ILocalCoordConverter;
    FPolygon: IDrawablePolygon;
  protected
    procedure ChangedSource;
    function GetLine(const ALocalConverter: ILocalCoordConverter): IGeometryLonLatLine; virtual; abstract;
  protected
    procedure PaintLayer(
      ABuffer: TBitmap32;
      const ALocalConverter: ILocalCoordConverter
    ); override;
  end;

  TPolygonLayerBase = class(TLineLayerBase)
  private
    FConfig: IPolygonLayerConfig;
    FFillColor: TColor32;
    FFillVisible: Boolean;

    FLine: IGeometryLonLatPolygon;
    FProjection: IProjectionInfo;
    FProjectedLine: IGeometryProjectedPolygon;
    FLocalConverter: ILocalCoordConverter;
    FPolygonBorder: IDrawablePolygon;
    FPolygonFill: IDrawablePolygon;
  protected
    procedure ChangedSource;
    function GetLine(const ALocalConverter: ILocalCoordConverter): IGeometryLonLatPolygon; virtual; abstract;
  protected
    procedure DoConfigChange; override;
    procedure PaintLayer(
      ABuffer: TBitmap32;
      const ALocalConverter: ILocalCoordConverter
    ); override;
  public
    constructor Create(
      const APerfList: IInternalPerformanceCounterList;
      const AAppStartedNotifier: INotifierOneOperation;
      const AAppClosingNotifier: INotifierOneOperation;
      AParentMap: TImage32;
      const AView: ILocalCoordConverterChangeable;
      const AVectorGeometryProjectedFactory: IGeometryProjectedFactory;
      const AConfig: IPolygonLayerConfig
    );
  end;

  TPathEditLayer = class(TPathLayerBase)
  private
    FLineOnMapEdit: IPathOnMapEdit;
    FLine: ILonLatPathWithSelected;
    procedure OnLineChange;
  protected
    function GetLine(const ALocalConverter: ILocalCoordConverter): IGeometryLonLatLine; override;
  public
    constructor Create(
      const APerfList: IInternalPerformanceCounterList;
      const AAppStartedNotifier: INotifierOneOperation;
      const AAppClosingNotifier: INotifierOneOperation;
      AParentMap: TImage32;
      const AView: ILocalCoordConverterChangeable;
      const AVectorGeometryProjectedFactory: IGeometryProjectedFactory;
      const ALineOnMapEdit: IPathOnMapEdit;
      const AConfig: ILineLayerConfig
    );
  end;

  TPolygonEditLayer = class(TPolygonLayerBase)
  private
    FLineOnMapEdit: IPolygonOnMapEdit;
    FLine: ILonLatPolygonWithSelected;
    procedure OnLineChange;
  protected
    function GetLine(const ALocalConverter: ILocalCoordConverter): IGeometryLonLatPolygon; override;
  public
    constructor Create(
      const APerfList: IInternalPerformanceCounterList;
      const AAppStartedNotifier: INotifierOneOperation;
      const AAppClosingNotifier: INotifierOneOperation;
      AParentMap: TImage32;
      const AView: ILocalCoordConverterChangeable;
      const AVectorGeometryProjectedFactory: IGeometryProjectedFactory;
      const ALineOnMapEdit: IPolygonOnMapEdit;
      const AConfig: IPolygonLayerConfig
    );
  end;

implementation

uses
  SysUtils,
  u_DoublePointsAggregator,
  u_ListenerByEvent,
  u_GeometryFunc;

{ TLineLayerBase }

constructor TLineLayerBase.Create(
  const APerfList: IInternalPerformanceCounterList;
  const AAppStartedNotifier: INotifierOneOperation;
  const AAppClosingNotifier: INotifierOneOperation;
  AParentMap: TImage32;
  const AView: ILocalCoordConverterChangeable;
  const AVectorGeometryProjectedFactory: IGeometryProjectedFactory;
  const AConfig: ILineLayerConfig
);
begin
  inherited Create(
    APerfList,
    AAppStartedNotifier,
    AAppClosingNotifier,
    AParentMap,
    AView
  );
  FConfig := AConfig;
  FVectorGeometryProjectedFactory := AVectorGeometryProjectedFactory;

  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnConfigChange),
    FConfig.GetChangeNotifier
  );
  FPreparedPointsAggreagtor := TDoublePointsAggregator.Create;
end;

procedure TLineLayerBase.DoConfigChange;
begin
  FLineColor := FConfig.LineColor;
  FLineWidth := FConfig.LineWidth;
  FLineVisible := ((AlphaComponent(FLineColor) > 0) and (FLineWidth > 0));
  FSimpleLineDraw := (FLineWidth = 1);
end;

procedure TLineLayerBase.OnConfigChange;
begin
  ViewUpdateLock;
  try
    FConfig.LockRead;
    try
      DoConfigChange;
    finally
      FConfig.UnlockRead;
    end;
  finally
    ViewUpdateUnlock;
  end;
end;

procedure TLineLayerBase.StartThreads;
begin
  inherited;
  OnConfigChange;
end;

{ TDrawablePolygon32 }

constructor TDrawablePolygon32.Create;
begin
  inherited;
  RefCounted := True;
end;

constructor TDrawablePolygon32.CreateFromSource(ASource: TPolygon32);
begin
  Create;
  Assign(ASource);
end;

{ TPathLayerSimple }

procedure TPathLayerBase.ChangedSource;
begin
  FLine := nil;
end;

procedure TPathLayerBase.PaintLayer(
  ABuffer: TBitmap32;
  const ALocalConverter: ILocalCoordConverter
);
var
  VLonLatLine: IGeometryLonLatLine;
  VProjection: IProjectionInfo;
  VProjectedLine: IGeometryProjectedLine;
  VLocalConverter: ILocalCoordConverter;
  VDrawablePolygon: IDrawablePolygon;
  VPolygon: TPolygon32;
  VPolygonOutline: TPolygon32;
  VPolygonGrow: TPolygon32;
  VPathFixedPoints: TArrayOfFixedPoint;
begin
  if (AlphaComponent(FLineColor) = 0) or (FLineWidth < 1) then begin
    Exit;
  end;

  VLonLatLine := FLine;
  VProjection := FProjection;
  VProjectedLine := FProjectedLine;
  VLocalConverter := FLocalConverter;
  VDrawablePolygon := FPolygon;

  if VLonLatLine = nil then begin
    VLonLatLine := GetLine(ALocalConverter);
    FLine := VLonLatLine;
    VProjectedLine := nil;
    VProjection := nil;
  end;

  if VLonLatLine = nil then begin
    Exit;
  end;
  if VProjectedLine <> nil then begin
    if not ALocalConverter.ProjectionInfo.GetIsSameProjectionInfo(VProjection) then begin
      VProjectedLine := nil;
    end;
  end;

  if VProjectedLine = nil then begin
    VDrawablePolygon := nil;
    VLocalConverter := nil;
    VProjection := ALocalConverter.ProjectionInfo;
    VProjectedLine :=
      FVectorGeometryProjectedFactory.CreateProjectedPathByLonLatPath(
        VProjection,
        VLonLatLine,
        FPreparedPointsAggreagtor
      );
    FProjectedLine := VProjectedLine;
    FProjection := VProjection;
  end;

  if VProjectedLine = nil then begin
    Exit;
  end;

  if not ALocalConverter.GetIsSameConverter(VLocalConverter) then begin
    VDrawablePolygon := nil;
    VLocalConverter := nil;
  end;

  if VDrawablePolygon = nil then begin
    VPolygon := nil;
    try
      ProjectedLine2GR32Polygon(
        VProjectedLine,
        ALocalConverter,
        am4times,
        VPathFixedPoints,
        VPolygon
      );
      if Assigned(VPolygon) then begin
        if FLineWidth = 1 then begin
          VDrawablePolygon := TDrawablePolygon32.CreateFromSource(VPolygon);
        end else begin
          VPolygonOutline := VPolygon.Outline;
          try
            VPolygonGrow := VPolygonOutline.Grow(Fixed(FLineWidth / 2), 0.5);
            try
              VDrawablePolygon := TDrawablePolygon32.CreateFromSource(VPolygonGrow);
            finally
              VPolygonGrow.Free;
            end;
          finally
            VPolygonOutline.Free;
          end;
        end;
      end;
    finally
      VPolygon.Free;
    end;
    FPolygon := VDrawablePolygon;
    FLocalConverter := VLocalConverter;
  end;
  if VDrawablePolygon = nil then begin
    Exit;
  end;
  VDrawablePolygon.DrawFill(ABuffer, FLineColor);
end;

{ TPolygonLayerBase }

constructor TPolygonLayerBase.Create(
  const APerfList: IInternalPerformanceCounterList;
  const AAppStartedNotifier: INotifierOneOperation;
  const AAppClosingNotifier: INotifierOneOperation;
  AParentMap: TImage32;
  const AView: ILocalCoordConverterChangeable;
  const AVectorGeometryProjectedFactory: IGeometryProjectedFactory;
  const AConfig: IPolygonLayerConfig
);
begin
  inherited Create(
    APerfList,
    AAppStartedNotifier,
    AAppClosingNotifier,
    AParentMap,
    AView,
    AVectorGeometryProjectedFactory,
    AConfig
  );
  FConfig := AConfig;
end;

procedure TPolygonLayerBase.ChangedSource;
begin
  FLine := nil;
end;

procedure TPolygonLayerBase.DoConfigChange;
begin
  inherited;
  FFillColor := FConfig.FillColor;
  FFillVisible := (AlphaComponent(FFillColor) > 0);
end;

procedure TPolygonLayerBase.PaintLayer(
  ABuffer: TBitmap32;
  const ALocalConverter: ILocalCoordConverter
);
var
  VLonLatLine: IGeometryLonLatPolygon;
  VProjection: IProjectionInfo;
  VProjectedLine: IGeometryProjectedPolygon;
  VLocalConverter: ILocalCoordConverter;
  VDrawablePolygonFill: IDrawablePolygon;
  VDrawablePolygonBorder: IDrawablePolygon;
  VPolygon: TPolygon32;
  VPolygonOutline: TPolygon32;
  VPolygonGrow: TPolygon32;
  VPathFixedPoints: TArrayOfFixedPoint;
begin
  if not FFillVisible and not FLineVisible then begin
    Exit;
  end;

  VLonLatLine := FLine;
  VProjection := FProjection;
  VProjectedLine := FProjectedLine;
  VLocalConverter := FLocalConverter;
  VDrawablePolygonFill := FPolygonFill;
  VDrawablePolygonBorder := FPolygonBorder;
  if VLonLatLine = nil then begin
    VLonLatLine := GetLine(ALocalConverter);
    FLine := VLonLatLine;
    VProjectedLine := nil;
    VProjection := nil;
  end;

  if VLonLatLine = nil then begin
    Exit;
  end;

  if VProjectedLine <> nil then begin
    if not ALocalConverter.ProjectionInfo.GetIsSameProjectionInfo(VProjection) then begin
      VProjection := nil;
      VProjectedLine := nil;
    end;
  end;

  if VProjectedLine = nil then begin
    VDrawablePolygonFill := nil;
    VDrawablePolygonBorder := nil;
    VLocalConverter := nil;
    VProjection := ALocalConverter.ProjectionInfo;
    VProjectedLine :=
      FVectorGeometryProjectedFactory.CreateProjectedPolygonByLonLatPolygon(
        VProjection,
        VLonLatLine,
        FPreparedPointsAggreagtor
      );
    FProjection := VProjection;
    FProjectedLine := VProjectedLine;
  end;

  if VProjectedLine = nil then begin
    Exit;
  end;

  if not ALocalConverter.GetIsSameConverter(VLocalConverter) then begin
    VDrawablePolygonFill := nil;
    VDrawablePolygonBorder := nil;
    VLocalConverter := nil;
  end;

  if (VDrawablePolygonFill = nil) then begin
    VPolygon := nil;
    try
      ProjectedPolygon2GR32Polygon(
        VProjectedLine,
        ALocalConverter,
        am4times,
        VPathFixedPoints,
        VPolygon
      );
      if Assigned(VPolygon) then begin
        VDrawablePolygonFill := TDrawablePolygon32.CreateFromSource(VPolygon);
        VDrawablePolygonBorder := nil;
        if not FSimpleLineDraw then begin
          VPolygonOutline := VPolygon.Outline;
          try
            VPolygonGrow := VPolygonOutline.Grow(Fixed(FLineWidth / 2), 0.5);
            try
              VDrawablePolygonBorder := TDrawablePolygon32.CreateFromSource(VPolygonGrow);
            finally
              VPolygonGrow.Free;
            end;
          finally
            VPolygonOutline.Free;
          end;
        end;
      end;
    finally
      VPolygon.Free;
    end;
    FPolygonFill := VDrawablePolygonFill;
    FPolygonBorder := VDrawablePolygonBorder;
    FLocalConverter := VLocalConverter;
  end;
  if (VDrawablePolygonFill = nil) then begin
    Exit;
  end;
  if FFillVisible then begin
    if FLineVisible and FSimpleLineDraw then begin
      VDrawablePolygonFill.Draw(ABuffer, FLineColor, FFillColor);
    end else begin
      VDrawablePolygonFill.DrawFill(ABuffer, FFillColor);
    end;
  end else begin
    if FLineVisible and FSimpleLineDraw then begin
      VDrawablePolygonFill.DrawEdge(ABuffer, FLineColor);
    end;
  end;

  if VDrawablePolygonBorder <> nil then begin
    VDrawablePolygonBorder.DrawFill(ABuffer, FLineColor);
  end;
end;

{ TPathEditLayer }

constructor TPathEditLayer.Create(
  const APerfList: IInternalPerformanceCounterList;
  const AAppStartedNotifier: INotifierOneOperation;
  const AAppClosingNotifier: INotifierOneOperation;
  AParentMap: TImage32;
  const AView: ILocalCoordConverterChangeable;
  const AVectorGeometryProjectedFactory: IGeometryProjectedFactory;
  const ALineOnMapEdit: IPathOnMapEdit;
  const AConfig: ILineLayerConfig
);
begin
  inherited Create(
    APerfList,
    AAppStartedNotifier,
    AAppClosingNotifier,
    AParentMap,
    AView,
    AVectorGeometryProjectedFactory,
    AConfig
  );
  FLineOnMapEdit := ALineOnMapEdit;

  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnLineChange),
    FLineOnMapEdit.GetChangeNotifier
  );
end;

function TPathEditLayer.GetLine(
  const ALocalConverter: ILocalCoordConverter
): IGeometryLonLatLine;
begin
  Result := nil;
  if Assigned(FLine) then begin
    Result := FLine.Geometry;
  end;
end;

procedure TPathEditLayer.OnLineChange;
begin
  ViewUpdateLock;
  try
    FLine := FLineOnMapEdit.Path;
    if not FLine.Geometry.IsEmpty then begin
      SetNeedRedraw;
      Show;
    end else begin
      Hide;
    end;
    ChangedSource;
  finally
    ViewUpdateUnlock;
  end;
end;

{ TPolygonEditLayer }

constructor TPolygonEditLayer.Create(
  const APerfList: IInternalPerformanceCounterList;
  const AAppStartedNotifier: INotifierOneOperation;
  const AAppClosingNotifier: INotifierOneOperation;
  AParentMap: TImage32;
  const AView: ILocalCoordConverterChangeable;
  const AVectorGeometryProjectedFactory: IGeometryProjectedFactory;
  const ALineOnMapEdit: IPolygonOnMapEdit;
  const AConfig: IPolygonLayerConfig
);
begin
  inherited Create(
    APerfList,
    AAppStartedNotifier,
    AAppClosingNotifier,
    AParentMap,
    AView,
    AVectorGeometryProjectedFactory,
    AConfig
  );
  FLineOnMapEdit := ALineOnMapEdit;

  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnLineChange),
    FLineOnMapEdit.GetChangeNotifier
  );
end;

function TPolygonEditLayer.GetLine(
  const ALocalConverter: ILocalCoordConverter
): IGeometryLonLatPolygon;
begin
  Result := nil;
  if Assigned(FLine) then begin
    Result := FLine.Geometry;
  end;
end;

procedure TPolygonEditLayer.OnLineChange;
begin
  ViewUpdateLock;
  try
    FLine := FLineOnMapEdit.Polygon;
    if not FLine.Geometry.IsEmpty then begin
      SetNeedRedraw;
      Show;
    end else begin
      Hide;
    end;
    ChangedSource;
  finally
    ViewUpdateUnlock;
  end;
end;

end.
