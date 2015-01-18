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

unit u_TiledMapLayer;

interface

uses
  Types,
  GR32,
  GR32_Image,
  GR32_Layers,
  i_Notifier,
  i_NotifierTime,
  i_NotifierOperation,
  i_LocalCoordConverter,
  i_LocalCoordConverterChangeable,
  i_SimpleFlag,
  i_TileMatrix,
  i_TileMatrixChangeable,
  i_InternalPerformanceCounter,
  i_HashMatrix,
  u_WindowLayerBasic;

type
  TTiledMapLayer = class(TWindowLayerAbstract)
  private
    FLayer: TPositionedLayer;
    FTileMatrix: ITileMatrixChangeable;
    FView: ILocalCoordConverterChangeable;

    FShownIdMatrix: IHashMatrix;
    FOnPaintCounter: IInternalPerformanceCounter;
    FOneTilePaintSimpleCounter: IInternalPerformanceCounter;
    FOneTilePaintResizeCounter: IInternalPerformanceCounter;

    FTileMatrixChangeFlag: ISimpleFlag;

    FLastPaintConverter: ILocalCoordConverter;
    procedure OnPaintLayer(
      Sender: TObject;
      Buffer: TBitmap32
    );
    procedure PaintLayerFromTileMatrix(
      ABuffer: TBitmap32;
      const ALocalConverter: ILocalCoordConverter;
      const ATileMatrix: ITileMatrix
    );
    procedure OnTimer;

    procedure OnScaleChange;
    procedure OnTileMatrixChange;
  protected
    procedure StartThreads; override;
  public
    constructor Create(
      const APerfList: IInternalPerformanceCounterList;
      const AAppStartedNotifier: INotifierOneOperation;
      const AAppClosingNotifier: INotifierOneOperation;
      AParentMap: TImage32;
      const AView: ILocalCoordConverterChangeable;
      const ATileMatrix: ITileMatrixChangeable;
      const ATimerNoifier: INotifierTime
    );
  end;

implementation

uses
  GR32_Resamplers,
  t_GeoTypes,
  t_Hash,
  i_TileIterator,
  i_CoordConverter,
  i_Bitmap32Static,
  u_SimpleFlagWithInterlock,
  u_ListenerByEvent,
  u_ListenerTime,
  u_TileIteratorByRect,
  u_HashMatrix,
  u_GeoFunc,
  u_BitmapFunc;


{ TTiledLayerWithThreadBase }

constructor TTiledMapLayer.Create(
  const APerfList: IInternalPerformanceCounterList;
  const AAppStartedNotifier: INotifierOneOperation;
  const AAppClosingNotifier: INotifierOneOperation;
  AParentMap: TImage32;
  const AView: ILocalCoordConverterChangeable;
  const ATileMatrix: ITileMatrixChangeable;
  const ATimerNoifier: INotifierTime
);
begin
  inherited Create(
    AAppStartedNotifier,
    AAppClosingNotifier
  );
  FLayer := TPositionedLayer.Create(AParentMap.Layers);
  FLayer.Visible := False;
  FLayer.MouseEvents := False;
  FView := AView;
  FTileMatrix := ATileMatrix;

  FOnPaintCounter := APerfList.CreateAndAddNewCounter('OnPaint');
  FOneTilePaintSimpleCounter := APerfList.CreateAndAddNewCounter('OneTilePaintSimple');
  FOneTilePaintResizeCounter := APerfList.CreateAndAddNewCounter('OneTilePaintResize');

  FShownIdMatrix := THashMatrix.Create;
  FTileMatrixChangeFlag := TSimpleFlagWithInterlock.Create;

  LinksList.Add(
    TListenerTimeCheck.Create(Self.OnTimer, 10),
    ATimerNoifier
  );
  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnScaleChange),
    FView.ChangeNotifier
  );
  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnTileMatrixChange),
    FTileMatrix.ChangeNotifier
  );
end;

procedure TTiledMapLayer.OnPaintLayer(
  Sender: TObject;
  Buffer: TBitmap32
);
var
  VTileMatrix: ITileMatrix;
  VLocalConverter: ILocalCoordConverter;
  VCounterContext: TInternalPerformanceCounterContext;
  VOldClipRect: TRect;
  VNewClipRect: TRect;
begin
  VLocalConverter := FView.GetStatic;
  VTileMatrix := FTileMatrix.GetStatic;
  if (VLocalConverter <> nil) and (VTileMatrix <> nil) then begin
    VCounterContext := FOnPaintCounter.StartOperation;
    try
      VOldClipRect := Buffer.ClipRect;
      if Types.IntersectRect(VNewClipRect, VOldClipRect, VLocalConverter.GetLocalRect) then begin
        Buffer.ClipRect := VNewClipRect;
        try
          PaintLayerFromTileMatrix(Buffer, VLocalConverter, VTileMatrix);
        finally
          Buffer.ClipRect := VOldClipRect;
        end;
      end;
    finally
      FOnPaintCounter.FinishOperation(VCounterContext);
    end;
  end;
end;

procedure TTiledMapLayer.OnScaleChange;
begin
  FTileMatrixChangeFlag.SetFlag;
end;

procedure TTiledMapLayer.OnTileMatrixChange;
begin
  FTileMatrixChangeFlag.SetFlag;
end;

procedure TTiledMapLayer.OnTimer;
var
  VLocalConverter: ILocalCoordConverter;
  VTileMatrix: ITileMatrix;
  VElement: ITileMatrixElement;
  VTileIterator: ITileIterator;
  VTile: TPoint;
  VDstRect: TRect;
  VShownId: THashValue;
  VMapRect: TRect;
begin
  if FTileMatrixChangeFlag.CheckFlagAndReset then begin
    VTileMatrix := FTileMatrix.GetStatic;
    if FLayer.Visible <> Assigned(VTileMatrix) then begin
      FLayer.Visible := Assigned(VTileMatrix);
    end;
    VLocalConverter := FView.GetStatic;
    if (VLocalConverter <> nil) and (VTileMatrix <> nil) then begin
      if not VLocalConverter.GetIsSameConverter(FLastPaintConverter) then begin
        FLayer.Location := FloatRect(VLocalConverter.GetLocalRect);
        FLayer.Changed(VLocalConverter.GetLocalRect);
        FShownIdMatrix.Reset(VTileMatrix.TileRect.Rect);
      end else begin
        if VLocalConverter.ProjectionInfo.GetIsSameProjectionInfo(VTileMatrix.TileRect.ProjectionInfo) then begin
          VTileIterator := TTileIteratorByRect.Create(VTileMatrix.TileRect.Rect);
          while VTileIterator.Next(VTile) do begin
            VShownId := FShownIdMatrix.GetHash(VTile);
            VElement := VTileMatrix.GetElementByTile(VTile);
            if VElement <> nil then begin
              if VElement.ReadyID <> VShownId then begin
                VMapRect :=
                  VLocalConverter.GeoConverter.TilePos2PixelRect(
                    VTile,
                    VLocalConverter.Zoom
                  );
                VDstRect := VLocalConverter.MapRect2LocalRect(VMapRect, rrClosest);
                FShownIdMatrix.SetHash(VTile, VElement.ReadyID);
                FLayer.Changed(VDstRect);
              end;
            end;
          end;
        end;
      end;
      FLastPaintConverter := VLocalConverter;
    end;
  end;
end;

procedure TTiledMapLayer.PaintLayerFromTileMatrix(
  ABuffer: TBitmap32;
  const ALocalConverter: ILocalCoordConverter;
  const ATileMatrix: ITileMatrix
);
var
  VTileRectInClipRect: TRect;
  VConverter: ICoordConverter;
  VZoomDst: Byte;
  VZoomSrc: Byte;
  VTileIterator: ITileIterator;
  VTile: TPoint;
  VElement: ITileMatrixElement;
  VBitmap: IBitmap32Static;
  VResampler: TCustomResampler;
  VDstRect: TRect;
  VDstSize: TPoint;
  VCounterContext: TInternalPerformanceCounterContext;
  VMapPixelRect: TDoubleRect;
  VClipedDstRect: TRect;
  VRelativeRect: TDoubleRect;
begin
  inherited;
  VConverter := ALocalConverter.GeoConverter;
  if not VConverter.IsSameConverter(ATileMatrix.TileRect.ProjectionInfo.GeoConverter) then begin
    Exit;
  end;
  VZoomDst := ALocalConverter.Zoom;
  VZoomSrc := ATileMatrix.TileRect.ProjectionInfo.Zoom;
  if VZoomDst <> VZoomSrc then begin
    VMapPixelRect := ALocalConverter.LocalRect2MapRectFloat(ABuffer.ClipRect);
    VConverter.ValidatePixelRectFloat(VMapPixelRect, VZoomDst);
    VRelativeRect := VConverter.PixelRectFloat2RelativeRect(VMapPixelRect, VZoomDst);
    VTileRectInClipRect := RectFromDoubleRect(VConverter.RelativeRect2TileRectFloat(VRelativeRect, VZoomSrc), rrOutside);
  end else begin
    VMapPixelRect := ALocalConverter.LocalRect2MapRectFloat(ABuffer.ClipRect);
    VConverter.ValidatePixelRectFloat(VMapPixelRect, VZoomDst);
    VTileRectInClipRect := RectFromDoubleRect(VConverter.PixelRectFloat2TileRectFloat(VMapPixelRect, VZoomSrc), rrOutside);
  end;
  if Types.IntersectRect(VTileRectInClipRect, VTileRectInClipRect, ATileMatrix.TileRect.Rect) then begin
    VResampler := nil;
    try
      VTileIterator := TTileIteratorByRect.Create(VTileRectInClipRect);
      while VTileIterator.Next(VTile) do begin
        VElement := ATileMatrix.GetElementByTile(VTile);
        if VElement <> nil then begin
          if VZoomDst <> VZoomSrc then begin
            VRelativeRect := VConverter.TilePos2RelativeRect(VTile, VZoomSrc);
            VDstRect :=
              RectFromDoubleRect(
                ALocalConverter.MapRectFloat2LocalRectFloat(VConverter.RelativeRect2PixelRectFloat(VRelativeRect, VZoomDst)),
                rrClosest
              );
          end else begin
            VDstRect :=
              ALocalConverter.MapRect2LocalRect(
                VConverter.TilePos2PixelRect(VTile, VZoomSrc),
                rrClosest
              );
          end;

          Types.IntersectRect(VClipedDstRect, VDstRect, ABuffer.ClipRect);

          VBitmap := VElement.GetBitmap;
          if VBitmap <> nil then begin
            if not ABuffer.MeasuringMode then begin
              VDstSize := Types.Point(VDstRect.Right - VDstRect.Left, VDstRect.Bottom - VDstRect.Top);
              if (VDstSize.X = VBitmap.Size.X) and (VDstSize.Y = VBitmap.Size.Y) then begin
                VCounterContext := FOneTilePaintSimpleCounter.StartOperation;
                try
                  BlockTransferFull(
                    ABuffer,
                    VDstRect.Left,
                    VDstRect.Top,
                    VBitmap,
                    dmBlend,
                    cmBlend
                  );
                finally
                  FOneTilePaintSimpleCounter.FinishOperation(VCounterContext);
                end;
              end else begin
                if VResampler = nil then begin
                  VResampler := TNearestResampler.Create;
                end;
                Assert(VResampler <> nil);
                VCounterContext := FOneTilePaintResizeCounter.StartOperation;
                try
                  StretchTransferFull(
                    ABuffer,
                    VDstRect,
                    VBitmap,
                    VResampler,
                    dmBlend,
                    cmBlend
                  );
                finally
                  FOneTilePaintResizeCounter.FinishOperation(VCounterContext);
                end;
              end;
            end else begin
              ABuffer.Changed(VDstRect);
            end;
          end else begin
            ABuffer.Changed(VDstRect);
          end;
        end;
      end;
    finally
      VResampler.Free;
    end;
  end;
end;

procedure TTiledMapLayer.StartThreads;
begin
  inherited;
  FLayer.OnPaint := OnPaintLayer;
end;

end.
