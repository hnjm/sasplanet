{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2012, SAS.Planet development team.                      *}
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
{* http://sasgis.ru                                                           *}
{* az@sasgis.ru                                                               *}
{******************************************************************************}

unit u_BitmapLayerProviderByMarksSubset;

interface

uses
  GR32,
  WinTypes,
  t_GeoTypes,
  i_ProjectionInfo,
  i_MarkerProviderForVectorItem,
  i_IdCacheSimple,
  i_LocalCoordConverter,
  i_NotifierOperation,
  i_Bitmap32Static,
  i_MarksDrawConfig,
  i_MarksSimple,
  i_VectorItemProjected,
  i_VectorItmesFactory,
  i_DoublePointsAggregator,
  i_BitmapLayerProvider,
  u_BaseInterfacedObject;

type
  TBitmapLayerProviderByMarksSubset = class(TBaseInterfacedObject, IBitmapLayerProvider)
  private
    FConfig: IMarksDrawConfigStatic;
    FVectorItmesFactory: IVectorItmesFactory;
    FMarkerProviderForVectorItem: IMarkerProviderForVectorItem;
    FMarksSubset: IMarksSubset;
    FProjectionInfo: IProjectionInfo;
    FProjectedCache: IIdCacheSimple;
    FLinesClipRect: TDoubleRect;

    FPreparedPointsAggreagtor: IDoublePointsAggregator;
    FFixedPointArray: TArrayOfFixedPoint;
    function GetProjectedPath(
      const AMarkPath: IMarkLine;
      const AProjectionInfo: IProjectionInfo
    ): IProjectedPath;
    function GetProjectedPolygon(
      const AMarkPoly: IMarkPoly;
      const AProjectionInfo: IProjectionInfo
    ): IProjectedPolygon;

    function DrawSubset(
      AOperationID: Integer;
      const ACancelNotifier: INotifierOperation;
      const AMarksSubset: IMarksSubset;
      ATargetBmp: TCustomBitmap32;
      const ALocalConverter: ILocalCoordConverter
    ): Boolean;
    function DrawPath(
      var ABitmapInited: Boolean;
      ATargetBmp: TCustomBitmap32;
      const ALocalConverter: ILocalCoordConverter;
      const AMarkLine: IMarkLine
    ): Boolean;
    function DrawPoly(
      var ABitmapInited: Boolean;
      ATargetBmp: TCustomBitmap32;
      const ALocalConverter: ILocalCoordConverter;
      const AMarkPoly: IMarkPoly
    ): Boolean;
    function DrawPoint(
      var ABitmapInited: Boolean;
      ATargetBmp: TCustomBitmap32;
      const ALocalConverter: ILocalCoordConverter;
      const AMarkPoint: IMarkPoint
    ): Boolean;
    procedure InitBitmap(
      ATargetBmp: TCustomBitmap32;
      const ALocalConverter: ILocalCoordConverter
    );
  private
    function GetBitmapRect(
      AOperationID: Integer;
      const ACancelNotifier: INotifierOperation;
      const ALocalConverter: ILocalCoordConverter
    ): IBitmap32Static;
  public
    constructor Create(
      const AConfig: IMarksDrawConfigStatic;
      const AVectorItmesFactory: IVectorItmesFactory;
      const AProjectionInfo: IProjectionInfo;
      const AProjectedCache: IIdCacheSimple;
      const AMarkerProviderForVectorItem: IMarkerProviderForVectorItem;
      const ALinesClipRect: TDoubleRect;
      const AMarksSubset: IMarksSubset
    );
  end;

implementation

uses
  ActiveX,
  SysUtils,
  GR32_Polygons,
  i_MarkerDrawable,
  i_CoordConverter,
  i_EnumDoublePoint,
  u_Bitmap32Static,
  u_DoublePointsAggregator,
  u_EnumDoublePointClosePoly,
  u_EnumDoublePointMapPixelToLocalPixel,
  u_EnumDoublePointWithClip,
  u_EnumDoublePointFilterEqual,
  u_GeoFun;

const
  CMaxFontSize = 20;

{ TMapMarksBitmapLayerProviderByMarksSubset }

constructor TBitmapLayerProviderByMarksSubset.Create(
  const AConfig: IMarksDrawConfigStatic;
  const AVectorItmesFactory: IVectorItmesFactory;
  const AProjectionInfo: IProjectionInfo;
  const AProjectedCache: IIdCacheSimple;
  const AMarkerProviderForVectorItem: IMarkerProviderForVectorItem;
  const ALinesClipRect: TDoubleRect;
  const AMarksSubset: IMarksSubset
);
begin
  inherited Create;
  FConfig := AConfig;
  FVectorItmesFactory := AVectorItmesFactory;
  FProjectionInfo := AProjectionInfo;
  FMarksSubset := AMarksSubset;
  FProjectedCache := AProjectedCache;
  FMarkerProviderForVectorItem := AMarkerProviderForVectorItem;
  FLinesClipRect := ALinesClipRect;

  FPreparedPointsAggreagtor := TDoublePointsAggregator.Create;
end;

function TBitmapLayerProviderByMarksSubset.DrawPath(
  var ABitmapInited: Boolean;
  ATargetBmp: TCustomBitmap32;
  const ALocalConverter: ILocalCoordConverter;
  const AMarkLine: IMarkLine
): Boolean;
var
  VPolygon: TPolygon32;
  i: Integer;
  VPointsProcessedCount: Integer;
  VEnum: IEnumLocalPoint;
  VRectWithDelta: TDoubleRect;
  VLocalRect: TDoubleRect;
  VPoint: TDoublePoint;
  VProjected: IProjectedPath;
  VMapRect: TDoubleRect;
  VLineIndex: Integer;
  VLine: IProjectedPathLine;
  VIndex: Integer;
begin
  Result := False;
  VProjected := GetProjectedPath(AMarkLine, FProjectionInfo);
  if VProjected <> nil then begin
    if VProjected.Count > 0 then begin
      VMapRect := ALocalConverter.GetRectInMapPixelFloat;
      if IsIntersecProjectedRect(VMapRect, VProjected.Bounds) then begin
        VLocalRect := DoubleRect(ALocalConverter.GetLocalRect);
        VRectWithDelta.Left := VLocalRect.Left - 10;
        VRectWithDelta.Top := VLocalRect.Top - 10;
        VRectWithDelta.Right := VLocalRect.Right + 10;
        VRectWithDelta.Bottom := VLocalRect.Bottom + 10;
        VPolygon := nil;
        try
          for VLineIndex := 0 to VProjected.Count - 1 do begin
            VLine := VProjected.Item[VLineIndex];
            if IsIntersecProjectedRect(VMapRect, VLine.Bounds) then begin
              FPreparedPointsAggreagtor.Clear;
              VEnum :=
                TEnumDoublePointMapPixelToLocalPixel.Create(
                  ALocalConverter,
                  VLine.GetEnum
                );
              VEnum :=
                TEnumLocalPointClipByRect.Create(
                  False,
                  VRectWithDelta,
                  VEnum
                );
              VEnum := TEnumLocalPointFilterEqual.Create(VEnum);
              while VEnum.Next(VPoint) do begin
                FPreparedPointsAggreagtor.Add(VPoint);
              end;
              VPointsProcessedCount := FPreparedPointsAggreagtor.Count;
              if VPointsProcessedCount > 0 then begin
                if VPolygon = nil then begin
                  VPolygon := TPolygon32.Create;
                  VPolygon.Antialiased := true;
                  VPolygon.AntialiasMode := am4times;
                  VPolygon.Closed := False;
                end else begin
                  VPolygon.NewLine;
                end;
                if Length(FFixedPointArray) < VPointsProcessedCount then begin
                  SetLength(FFixedPointArray, VPointsProcessedCount);
                end;
                VIndex := 0;
                for i := 0 to VPointsProcessedCount - 1 do begin
                  VPoint := FPreparedPointsAggreagtor.Points[i];
                  if PointIsEmpty(VPoint) then begin
                    VPolygon.AddPoints(FFixedPointArray[0], VIndex);
                    VPolygon.NewLine;
                    VIndex := 0;
                  end else begin
                    FFixedPointArray[VIndex] := FixedPoint(VPoint.X, VPoint.Y);
                    Inc(VIndex);
                  end;
                end;
                VPolygon.AddPoints(FFixedPointArray[0], VIndex);
              end;
            end;
          end;
          if VPolygon <> nil then begin
            if not ABitmapInited then begin
              InitBitmap(ATargetBmp, ALocalConverter);
              ABitmapInited := True;
            end;

            with VPolygon.Outline do try
              with Grow(GR32.Fixed(AMarkLine.LineWidth / 2), 0.5) do try
                FillMode := pfWinding;
                DrawFill(ATargetBmp, AMarkLine.LineColor);
              finally
                free;
              end;
            finally
              free;
            end;
            Result := True;
          end;
        finally
          VPolygon.Free;
        end;
      end;
    end;
  end;
end;

function TBitmapLayerProviderByMarksSubset.DrawPoly(
  var ABitmapInited: Boolean;
  ATargetBmp: TCustomBitmap32;
  const ALocalConverter: ILocalCoordConverter;
  const AMarkPoly: IMarkPoly
): Boolean;
var
  VPolygon: TPolygon32;
  i: Integer;
  VPointsProcessedCount: Integer;
  VEnum: IEnumLocalPoint;
  VRectWithDelta: TDoubleRect;
  VLocalRect: TDoubleRect;
  VPoint: TDoublePoint;
  VProjected: IProjectedPolygon;
  VMapRect: TDoubleRect;
  VLineIndex: Integer;
  VLine: IProjectedPolygonLine;
begin
  Result := False;
  VProjected := GetProjectedPolygon(AMarkPoly, FProjectionInfo);
  if VProjected <> nil then begin
    if VProjected.Count > 0 then begin
      VMapRect := ALocalConverter.GetRectInMapPixelFloat;
      if IsIntersecProjectedRect(VMapRect, VProjected.Bounds) then begin
        VLocalRect := DoubleRect(ALocalConverter.GetLocalRect);
        VRectWithDelta.Left := VLocalRect.Left - 10;
        VRectWithDelta.Top := VLocalRect.Top - 10;
        VRectWithDelta.Right := VLocalRect.Right + 10;
        VRectWithDelta.Bottom := VLocalRect.Bottom + 10;
        VPolygon := nil;
        try
          for VLineIndex := 0 to VProjected.Count - 1 do begin
            VLine := VProjected.Item[VLineIndex];
            if IsIntersecProjectedRect(VMapRect, VLine.Bounds) then begin
              FPreparedPointsAggreagtor.Clear;
              VEnum :=
                TEnumDoublePointMapPixelToLocalPixel.Create(
                  ALocalConverter,
                  VLine.GetEnum
                );
              VEnum :=
                TEnumLocalPointClipByRect.Create(
                  True,
                  VRectWithDelta,
                  VEnum
                );
              VEnum := TEnumLocalPointFilterEqual.Create(VEnum);
              VEnum := TEnumLocalPointClosePoly.Create(VEnum);
              while VEnum.Next(VPoint) do begin
                FPreparedPointsAggreagtor.Add(VPoint);
              end;
              VPointsProcessedCount := FPreparedPointsAggreagtor.Count;
              if VPointsProcessedCount > 0 then begin
                if VPolygon = nil then begin
                  VPolygon := TPolygon32.Create;
                  VPolygon.Antialiased := true;
                  VPolygon.AntialiasMode := am4times;
                  VPolygon.Closed := True;
                end else begin
                  VPolygon.NewLine;
                end;
                if Length(FFixedPointArray) < VPointsProcessedCount then begin
                  SetLength(FFixedPointArray, VPointsProcessedCount);
                end;
                for i := 0 to VPointsProcessedCount - 1 do begin
                  VPoint := FPreparedPointsAggreagtor.Points[i];
                  FFixedPointArray[i] := FixedPoint(VPoint.X, VPoint.Y);
                end;
                VPolygon.AddPoints(FFixedPointArray[0], VPointsProcessedCount);
              end;
            end;
          end;
          if VPolygon <> nil then begin
            if not ABitmapInited then begin
              InitBitmap(ATargetBmp, ALocalConverter);
              ABitmapInited := True;
            end;
            VPolygon.DrawFill(ATargetBmp, AMarkPoly.FillColor);
            with VPolygon.Outline do try
              with Grow(GR32.Fixed(AMarkPoly.LineWidth / 2), 0.5) do try
                FillMode := pfWinding;
                DrawFill(ATargetBmp, AMarkPoly.BorderColor);
              finally
                free;
              end;
            finally
              free;
            end;
            Result := True;
          end;
        finally
          VPolygon.Free;
        end;
      end;
    end;
  end;
end;

function TBitmapLayerProviderByMarksSubset.DrawPoint(
  var ABitmapInited: Boolean;
  ATargetBmp: TCustomBitmap32;
  const ALocalConverter: ILocalCoordConverter;
  const AMarkPoint: IMarkPoint
): Boolean;
var
  VLocalPoint: TDoublePoint;
  VLonLat: TDoublePoint;
  VMarker: IMarkerDrawable;
begin
  Result := False;
  VMarker := FMarkerProviderForVectorItem.GetMarker(AMarkPoint);
  if VMarker <> nil then begin
    VLonLat := AMarkPoint.Point;
    ALocalConverter.GeoConverter.CheckLonLatPos(VLonLat);
    VLocalPoint := ALocalConverter.LonLat2LocalPixelFloat(VLonLat);
    if not ABitmapInited then begin
      InitBitmap(ATargetBmp, ALocalConverter);
      ABitmapInited := True;
    end;
    Result := VMarker.DrawToBitmap(ATargetBmp, VLocalPoint);
  end;
end;

function TBitmapLayerProviderByMarksSubset.DrawSubset(
  AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  const AMarksSubset: IMarksSubset;
  ATargetBmp: TCustomBitmap32;
  const ALocalConverter: ILocalCoordConverter
): Boolean;
var
  VEnumMarks: IEnumUnknown;
  VMark: IMark;
  i: Cardinal;
  VMarkPoint: IMarkPoint;
  VMarkLine: IMarkLine;
  VMarkPoly: IMarkPoly;
  VBitmapInited: Boolean;
begin
  Result := False;
  VBitmapInited := False;
  VEnumMarks := AMarksSubset.GetEnum;
  if FConfig.UseSimpleDrawOrder then begin
    while (VEnumMarks.Next(1, VMark, @i) = S_OK) do begin
      if ACancelNotifier.IsOperationCanceled(AOperationID) then begin
        Break;
      end;
      if Supports(VMark, IMarkPoint, VMarkPoint) then begin
        if DrawPoint(VBitmapInited, ATargetBmp, ALocalConverter, VMarkPoint) then begin
          Result := True;
        end;
      end else if Supports(VMark, IMarkLine, VMarkLine) then begin
        if DrawPath(VBitmapInited, ATargetBmp, ALocalConverter, VMarkLine) then begin
          Result := True;
        end;
      end else if Supports(VMark, IMarkPoly, VMarkPoly) then begin
        if DrawPoly(VBitmapInited, ATargetBmp, ALocalConverter, VMarkPoly) then begin
          Result := True;
        end;
      end;
    end;
  end else begin
    while (VEnumMarks.Next(1, VMark, @i) = S_OK) do begin
      if ACancelNotifier.IsOperationCanceled(AOperationID) then begin
        Break;
      end;
      if Supports(VMark, IMarkPoly, VMarkPoly) then begin
        if DrawPoly(VBitmapInited, ATargetBmp, ALocalConverter, VMarkPoly) then begin
          Result := True;
        end;
      end;
    end;
    VEnumMarks.Reset;
    while (VEnumMarks.Next(1, VMark, @i) = S_OK) do begin
      if ACancelNotifier.IsOperationCanceled(AOperationID) then begin
        Break;
      end;
      if Supports(VMark, IMarkLine, VMarkLine) then begin
        if DrawPath(VBitmapInited, ATargetBmp, ALocalConverter, VMarkLine) then begin
          Result := True;
        end;
      end;
    end;
    VEnumMarks.Reset;
    while (VEnumMarks.Next(1, VMark, @i) = S_OK) do begin
      if ACancelNotifier.IsOperationCanceled(AOperationID) then begin
        Break;
      end;
      if Supports(VMark, IMarkPoint, VMarkPoint) then begin
        if DrawPoint(VBitmapInited, ATargetBmp, ALocalConverter, VMarkPoint) then begin
          Result := True;
        end;
      end;
    end;
  end;
end;

function TBitmapLayerProviderByMarksSubset.GetBitmapRect(
  AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  const ALocalConverter: ILocalCoordConverter
): IBitmap32Static;
var
  VRectWithDelta: TRect;
  VLocalRect: TRect;
  VTargetRect: TDoubleRect;
  VLonLatRect: TDoubleRect;
  VConverter: ICoordConverter;
  VZoom: Byte;
  VMarksSubset: IMarksSubset;
  VDeltaSizeInPixel: TRect;
  VBitmap: TCustomBitmap32;
begin
  VLocalRect := ALocalConverter.GetLocalRect;
  VDeltaSizeInPixel := FConfig.OverSizeRect;
  VRectWithDelta.Left := VLocalRect.Left - VDeltaSizeInPixel.Left;
  VRectWithDelta.Top := VLocalRect.Top - VDeltaSizeInPixel.Top;
  VRectWithDelta.Right := VLocalRect.Right + VDeltaSizeInPixel.Right;
  VRectWithDelta.Bottom := VLocalRect.Bottom + VDeltaSizeInPixel.Bottom;
  VTargetRect := ALocalConverter.LocalRect2MapRectFloat(VRectWithDelta);
  VZoom := ALocalConverter.GetZoom;
  VConverter := ALocalConverter.GetGeoConverter;
  VConverter.CheckPixelRectFloat(VTargetRect, VZoom);
  VLonLatRect := VConverter.PixelRectFloat2LonLatRect(VTargetRect, VZoom);
  VMarksSubset := FMarksSubset.GetSubsetByLonLatRect(VLonLatRect);
  Result := nil;
  if not VMarksSubset.IsEmpty then begin
    VBitmap := TCustomBitmap32.Create;
    try
      if DrawSubset(AOperationID, ACancelNotifier, VMarksSubset, VBitmap, ALocalConverter) then begin
        Result := TBitmap32Static.CreateWithOwn(VBitmap);
        VBitmap := nil;
      end;
    finally
      VBitmap.Free;
    end;
  end;
end;

function TBitmapLayerProviderByMarksSubset.GetProjectedPath(
  const AMarkPath: IMarkLine;
  const AProjectionInfo: IProjectionInfo
): IProjectedPath;
var
  VID: Integer;
  VLineWidth: Integer;
  VTestArrLenLonLatRect: TDoubleRect;
  VTestArrLenPixelRect: TDoubleRect;
  VGeoConverter: ICoordConverter;
begin
  VID := Integer(AMarkPath);
  if not Supports(FProjectedCache.GetByID(VID), IProjectedPath, Result) then begin
    VLineWidth := AMarkPath.LineWidth;
    VTestArrLenLonLatRect := AMarkPath.LLRect.Rect;
    VGeoConverter := AProjectionInfo.GeoConverter;
    VGeoConverter.CheckLonLatRect(VTestArrLenLonLatRect);
    VTestArrLenPixelRect := VGeoConverter.LonLatRect2PixelRectFloat(VTestArrLenLonLatRect, AProjectionInfo.Zoom);
    if
      (abs(VTestArrLenPixelRect.Left - VTestArrLenPixelRect.Right) > VLineWidth + 2) or
      (abs(VTestArrLenPixelRect.Top - VTestArrLenPixelRect.Bottom) > VLineWidth + 2)
    then begin
      Result :=
        FVectorItmesFactory.CreateProjectedPathWithClipByLonLatPath(
          AProjectionInfo,
          AMarkPath.Line,
          FLinesClipRect,
          FPreparedPointsAggreagtor
        );
    end else begin
      Result :=
        FVectorItmesFactory.CreateProjectedPath(
          AProjectionInfo,
          nil,
          0
        );
    end;
    FProjectedCache.Add(VID, Result);
  end;
end;

function TBitmapLayerProviderByMarksSubset.GetProjectedPolygon(
  const AMarkPoly: IMarkPoly;
  const AProjectionInfo: IProjectionInfo
): IProjectedPolygon;
var
  VID: Integer;
  VLineWidth: Integer;
  VTestArrLenLonLatRect: TDoubleRect;
  VTestArrLenPixelRect: TDoubleRect;
  VGeoConverter: ICoordConverter;
begin
  VID := Integer(AMarkPoly);
  if not Supports(FProjectedCache.GetByID(VID), IProjectedPath, Result) then begin
    VLineWidth := AMarkPoly.LineWidth;
    VTestArrLenLonLatRect := AMarkPoly.LLRect.Rect;
    VGeoConverter := AProjectionInfo.GeoConverter;
    VGeoConverter.CheckLonLatRect(VTestArrLenLonLatRect);
    VTestArrLenPixelRect := VGeoConverter.LonLatRect2PixelRectFloat(VTestArrLenLonLatRect, AProjectionInfo.Zoom);
    if
      (abs(VTestArrLenPixelRect.Left - VTestArrLenPixelRect.Right) > VLineWidth + 2) or
      (abs(VTestArrLenPixelRect.Top - VTestArrLenPixelRect.Bottom) > VLineWidth + 2)
    then begin
      Result :=
        FVectorItmesFactory.CreateProjectedPolygonWithClipByLonLatPolygon(
          AProjectionInfo,
          AMarkPoly.Line,
          FLinesClipRect,
          FPreparedPointsAggreagtor
        );
    end else begin
      Result :=
        FVectorItmesFactory.CreateProjectedPolygon(
          AProjectionInfo,
          nil,
          0
        );
    end;
    FProjectedCache.Add(VID, Result);
  end;
end;

procedure TBitmapLayerProviderByMarksSubset.InitBitmap(
  ATargetBmp: TCustomBitmap32;
  const ALocalConverter: ILocalCoordConverter
);
var
  VSize: TPoint;
begin
  VSize := ALocalConverter.GetLocalRectSize;
  ATargetBmp.SetSize(VSize.X, VSize.Y);
  ATargetBmp.Clear(0);
  ATargetBmp.CombineMode := cmMerge;
end;

end.

