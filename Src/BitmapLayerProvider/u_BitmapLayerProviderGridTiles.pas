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
{* http://sasgis.org                                                          *}
{* info@sasgis.org                                                            *}
{******************************************************************************}

unit u_BitmapLayerProviderGridTiles;

interface

uses
  Types,
  SysUtils,
  GR32,
  i_SimpleFlag,
  i_NotifierOperation,
  i_ProjectionInfo,
  i_LocalCoordConverter,
  i_Bitmap32Static,
  i_Bitmap32BufferFactory,
  i_BitmapLayerProvider,
  u_BaseInterfacedObject;

type
  TBitmapLayerProviderGridTiles = class(TBaseInterfacedObject, IBitmapLayerProvider)
  private
    FColor: TColor32;
    FUseRelativeZoom: Boolean;
    FZoom: Integer;
    FShowText: Boolean;
    FShowLines: Boolean;
    FBitmapFactory: IBitmap32StaticFactory;
    FCS: IReadWriteSync;
    FBitmap: TBitmap32;
    FBitmapChangeFlag: ISimpleFlag;
    procedure OnBitmapChange(Sender: TObject);
    procedure InitBitmap(const ASize: TPoint);
    procedure DrawLines(
      AGridZoom: Byte;
      const AProjection: IProjectionInfo;
      const AMapRect: TRect
    );
    procedure DrawCaptions(
      AOperationID: Integer;
      const ACancelNotifier: INotifierOperation;
      AGridZoom: Byte;
      const AProjection: IProjectionInfo;
      const AMapRect: TRect
    );
  private
    function GetBitmapRect(
      AOperationID: Integer;
      const ACancelNotifier: INotifierOperation;
      const ALocalConverter: ILocalCoordConverter
    ): IBitmap32Static;
    function GetTile(
      AOperationID: Integer;
      const ACancelNotifier: INotifierOperation;
      const AProjectionInfo: IProjectionInfo;
      const ATile: TPoint
    ): IBitmap32Static;
  public
    constructor Create(
      const ABitmapFactory: IBitmap32StaticFactory;
      AColor: TColor32;
      AUseRelativeZoom: Boolean;
      AZoom: Integer;
      AShowText: Boolean;
      AShowLines: Boolean
    );
    destructor Destroy; override;
  end;

implementation

uses
  t_GeoTypes,
  i_CoordConverter,
  u_SimpleFlagWithInterlock,
  u_TileIteratorByRect,
  u_GeoFunc,
  u_Synchronizer;

{ TBitmapLayerProviderGridTiles }

constructor TBitmapLayerProviderGridTiles.Create(
  const ABitmapFactory: IBitmap32StaticFactory;
  AColor: TColor32;
  AUseRelativeZoom: Boolean;
  AZoom: Integer;
  AShowText, AShowLines: Boolean
);
begin
  inherited Create;
  FBitmapFactory := ABitmapFactory;
  FColor := AColor;
  FUseRelativeZoom := AUseRelativeZoom;
  FZoom := AZoom;
  FShowText := AShowText;
  FShowLines := AShowLines;

  FCS := GSync.SyncVariable.Make(Self.ClassName);
  FBitmapChangeFlag := TSimpleFlagWithInterlock.Create;
  FBitmap := TBitmap32.Create;
  FBitmap.SetSize(256, 256);
  FBitmap.OnChange := Self.OnBitmapChange;
end;

destructor TBitmapLayerProviderGridTiles.Destroy;
begin
  FreeAndNil(FBitmap);
  inherited;
end;

procedure TBitmapLayerProviderGridTiles.DrawCaptions(
  AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  AGridZoom: Byte;
  const AProjection: IProjectionInfo;
  const AMapRect: TRect
);
var
  VGeoConvert: ICoordConverter;
  VCurrentZoom: Byte;
  VLoadedRelativeRect: TDoubleRect;
  VTilesRect: TRect;
  VIterator: TTileIteratorByRectRecord;
  VTileIndex: TPoint;
  VTileRelativeRect: TDoubleRect;
  VPixelRectOfTile: TDoubleRect;
  VLocalRectOfTile: TDoubleRect;
  VTileSize: TDoublePoint;
  VTileCenter: TDoublePoint;
  textoutx: string;
  textouty: string;
  Sz1, Sz2: TSize;
  VOutPoint: TPoint;
begin
  VGeoConvert := AProjection.GeoConverter;
  VCurrentZoom := AProjection.Zoom;

  VLoadedRelativeRect := VGeoConvert.PixelRect2RelativeRect(AMapRect, VCurrentZoom);
  VTilesRect :=
    RectFromDoubleRect(
      VGeoConvert.RelativeRect2TileRectFloat(VLoadedRelativeRect, AGridZoom),
      rrOutside
    );
  VIterator.Init(VTilesRect);
  while VIterator.Next(VTileIndex) do begin
      VTileRelativeRect := VGeoConvert.TilePos2RelativeRect(VTileIndex, AGridZoom);
      VPixelRectOfTile := VGeoConvert.RelativeRect2PixelRectFloat(VTileRelativeRect, VCurrentZoom);
      VLocalRectOfTile.Left := VPixelRectOfTile.Left - AMapRect.Left;
      VLocalRectOfTile.Top := VPixelRectOfTile.Top - AMapRect.Top;
      VLocalRectOfTile.Right := VPixelRectOfTile.Right - AMapRect.Left;
      VLocalRectOfTile.Bottom := VPixelRectOfTile.Bottom - AMapRect.Top;
      VTileSize.X := VPixelRectOfTile.Right - VPixelRectOfTile.Left;
      VTileSize.Y := VPixelRectOfTile.Bottom - VPixelRectOfTile.Top;
      VTileCenter.X := VLocalRectOfTile.Left + VTileSize.X / 2;
      VTileCenter.Y := VLocalRectOfTile.Top + VTileSize.Y / 2;
      textoutx := 'x=' + inttostr(VTileIndex.X);
      textouty := 'y=' + inttostr(VTileIndex.Y);
      Sz1 := FBitmap.TextExtent(textoutx);
      Sz2 := FBitmap.TextExtent(textouty);
      if (Sz1.cx < VTileSize.X) and (Sz2.cx < VTileSize.X) then begin
        VOutPoint := Types.Point(Trunc(VTileCenter.X - Sz1.cx / 2), Trunc(VTileCenter.Y - Sz1.cy));
        FBitmap.RenderText(VOutPoint.X, VOutPoint.Y, textoutx, 0, FColor);
        VOutPoint := Types.Point(Trunc(VTileCenter.X - Sz2.cx / 2), Trunc(VTileCenter.Y));
        FBitmap.RenderText(VOutPoint.X, VOutPoint.Y, textouty, 0, FColor);
      end;
  end;
end;

procedure TBitmapLayerProviderGridTiles.DrawLines(
  AGridZoom: Byte;
  const AProjection: IProjectionInfo;
  const AMapRect: TRect
);
var
  VGeoConvert: ICoordConverter;
  VCurrentZoom: Byte;
  VLocalRect: TRect;
  VRelativeRect: TDoubleRect;
  VTilesRect: TRect;
  VTilesLineRect: TRect;
  i, j: integer;
  VRelativeRectOfTilesLine: TDoubleRect;
  VMapPixelRectOfTilesLine: TDoubleRect;
  VLocalRectOfTilesLine: TRect;
begin
  VGeoConvert := AProjection.GeoConverter;
  VCurrentZoom := AProjection.Zoom;
  VLocalRect := Rect(0, 0, AMapRect.Right - AMapRect.Left, AMapRect.Bottom - AMapRect.Top);

  VRelativeRect := VGeoConvert.PixelRect2RelativeRect(AMapRect, VCurrentZoom);
  VTilesRect :=
    RectFromDoubleRect(
      VGeoConvert.RelativeRect2TileRectFloat(VRelativeRect, AGridZoom),
      rrOutside
    );

  VTilesLineRect.Left := VTilesRect.Left;
  VTilesLineRect.Right := VTilesRect.Right;
  for i := VTilesRect.Top to VTilesRect.Bottom do begin
    VTilesLineRect.Top := i;
    VTilesLineRect.Bottom := i;

    VRelativeRectOfTilesLine := VGeoConvert.TileRect2RelativeRect(VTilesLineRect, AGridZoom);
    VMapPixelRectOfTilesLine := VGeoConvert.RelativeRect2PixelRectFloat(VRelativeRectOfTilesLine, VCurrentZoom);

    VLocalRectOfTilesLine.Left := VLocalRect.Left;
    VLocalRectOfTilesLine.Top := Trunc(VMapPixelRectOfTilesLine.Top - AMapRect.Top);

    VLocalRectOfTilesLine.Right := VLocalRect.Right;
    VLocalRectOfTilesLine.Bottom := Trunc(VMapPixelRectOfTilesLine.Bottom - AMapRect.Top);

    if (VLocalRectOfTilesLine.Top >= VLocalRect.Top) and
      (VLocalRectOfTilesLine.Top < VLocalRect.Bottom) then begin
      FBitmap.HorzLineTS(
        VLocalRectOfTilesLine.Left,
        VLocalRectOfTilesLine.Top,
        VLocalRectOfTilesLine.Right,
        FColor
      );
    end;
  end;

  VTilesLineRect.Top := VTilesRect.Top;
  VTilesLineRect.Bottom := VTilesRect.Bottom;
  for j := VTilesRect.Left to VTilesRect.Right do begin
    VTilesLineRect.Left := j;
    VTilesLineRect.Right := j;

    VRelativeRectOfTilesLine := VGeoConvert.TileRect2RelativeRect(VTilesLineRect, AGridZoom);
    VMapPixelRectOfTilesLine := VGeoConvert.RelativeRect2PixelRectFloat(VRelativeRectOfTilesLine, VCurrentZoom);

    VLocalRectOfTilesLine.Left := Trunc(VMapPixelRectOfTilesLine.Left - AMapRect.Left);
    VLocalRectOfTilesLine.Top := VLocalRect.Top;

    VLocalRectOfTilesLine.Right := Trunc(VMapPixelRectOfTilesLine.Right - AMapRect.Left);
    VLocalRectOfTilesLine.Bottom := VLocalRect.Bottom;

    if (VLocalRectOfTilesLine.Left >= VLocalRect.Left) and
      (VLocalRectOfTilesLine.Left < VLocalRect.Right) then begin
      FBitmap.VertLineTS(
        VLocalRectOfTilesLine.Left,
        VLocalRectOfTilesLine.Top,
        VLocalRectOfTilesLine.Bottom,
        FColor
      );
    end;
  end;
end;

function TBitmapLayerProviderGridTiles.GetBitmapRect(
  AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  const ALocalConverter: ILocalCoordConverter
): IBitmap32Static;
var
  VCurrentZoom: Byte;
  VGridZoom: Byte;
  VGeoConvert: ICoordConverter;
  VMapRect: TRect;
begin
  Result := nil;
  VCurrentZoom := ALocalConverter.GetZoom;
  if FUseRelativeZoom then begin
    VGridZoom := VCurrentZoom + FZoom;
  end else begin
    VGridZoom := FZoom;
  end;
  VGeoConvert := ALocalConverter.GetGeoConverter;
  if not VGeoConvert.CheckZoom(VGridZoom) then begin
    Exit;
  end;
  if VGridZoom > VCurrentZoom + 5 then begin
    Exit;
  end;
  VMapRect := ALocalConverter.GetRectInMapPixel;

  FCS.BeginWrite;
  try
    InitBitmap(ALocalConverter.GetLocalRectSize);
    FBitmapChangeFlag.CheckFlagAndReset;
    if FShowLines then begin
      DrawLines(VGridZoom, ALocalConverter.ProjectionInfo, VMapRect);
    end;

    if FShowText then begin
      if (VGridZoom >= VCurrentZoom - 2) and (VGridZoom <= VCurrentZoom + 3) then begin
        DrawCaptions(AOperationID, ACancelNotifier, VGridZoom, ALocalConverter.ProjectionInfo, VMapRect);
      end;
    end;
    if FBitmapChangeFlag.CheckFlagAndReset then begin
      Result := FBitmapFactory.Build(Types.Point(FBitmap.Width, FBitmap.Height), FBitmap.Bits);
    end;
  finally
    FCS.EndWrite;
  end;
end;

function TBitmapLayerProviderGridTiles.GetTile(
  AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  const AProjectionInfo: IProjectionInfo;
  const ATile: TPoint
): IBitmap32Static;
var
  VCurrentZoom: Byte;
  VGridZoom: Byte;
  VGeoConvert: ICoordConverter;
  VMapRect: TRect;
begin
  Result := nil;
  VCurrentZoom := AProjectionInfo.Zoom;
  if FUseRelativeZoom then begin
    VGridZoom := VCurrentZoom + FZoom;
  end else begin
    VGridZoom := FZoom;
  end;
  VGeoConvert := AProjectionInfo.GeoConverter;
  if not VGeoConvert.CheckZoom(VGridZoom) then begin
    Exit;
  end;
  if VGridZoom > VCurrentZoom + 5 then begin
    Exit;
  end;
  VMapRect := VGeoConvert.TilePos2PixelRect(ATile, VCurrentZoom);

  FCS.BeginWrite;
  try
    InitBitmap(RectSize(VMapRect));
    FBitmapChangeFlag.CheckFlagAndReset;
    if FShowLines then begin
      DrawLines(VGridZoom, AProjectionInfo, VMapRect);
    end;

    if FShowText then begin
      if (VGridZoom >= VCurrentZoom - 2) and (VGridZoom <= VCurrentZoom + 3) then begin
        DrawCaptions(AOperationID, ACancelNotifier, VGridZoom, AProjectionInfo, VMapRect);
      end;
    end;
    if FBitmapChangeFlag.CheckFlagAndReset then begin
      Result := FBitmapFactory.Build(Types.Point(FBitmap.Width, FBitmap.Height), FBitmap.Bits);
    end;
  finally
    FCS.EndWrite;
  end;
end;

procedure TBitmapLayerProviderGridTiles.InitBitmap(
  const ASize: TPoint
);
begin
  FBitmap.SetSize(ASize.X, ASize.Y);
  FBitmap.Clear(0);
end;

procedure TBitmapLayerProviderGridTiles.OnBitmapChange(Sender: TObject);
begin
  FBitmapChangeFlag.SetFlag;
end;

end.
