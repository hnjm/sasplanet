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

unit u_TileRectChangeableByLocalConverter;

interface

uses
  SysUtils,
  i_TileRect,
  i_TileRectChangeable,
  i_CoordConverterFactory,
  i_LocalCoordConverter,
  i_LocalCoordConverterChangeable,
  i_Listener,
  u_ChangeableBase;

type
  TTileRectChangeableByLocalConverterAbstract = class(TChangeableBase, ITileRectChangeable)
  private
    FLocalCoordConverter: ILocalCoordConverterChangeable;
    FMainLock: IReadWriteSync;
    FResultLock: IReadWriteSync;
    FListener: IListener;

    FPrevLocalCoordConverter: ILocalCoordConverter;
    FResult: ITileRect;
    procedure OnConverterChanged;
    function BuildTileRect(const AConverter: ILocalCoordConverter): ITileRect; virtual; abstract;
  private
    function GetStatic: ITileRect;
  public
    constructor Create(
      const ALocalCoordConverter: ILocalCoordConverterChangeable;
      const AMainLock: IReadWriteSync;
      const AResultLock: IReadWriteSync
    );
    destructor Destroy; override;
    procedure AfterConstruction; override;
  end;

  TTileRectChangeableByLocalConverterSimple = class(TTileRectChangeableByLocalConverterAbstract)
  private
    function BuildTileRect(const AConverter: ILocalCoordConverter): ITileRect; override;
  public
    constructor Create(
      const ALocalCoordConverter: ILocalCoordConverterChangeable;
      const AMainLock: IReadWriteSync;
      const AResultLock: IReadWriteSync
    );
  end;

  TTileRectChangeableByLocalConverterSmart = class(TTileRectChangeableByLocalConverterAbstract)
  private
    FProjectionInfoFactory: IProjectionInfoFactory;
    function BuildTileRect(const AConverter: ILocalCoordConverter): ITileRect; override;
  public
    constructor Create(
      const AProjectionInfoFactory: IProjectionInfoFactory;
      const ALocalCoordConverter: ILocalCoordConverterChangeable;
      const AMainLock: IReadWriteSync;
      const AResultLock: IReadWriteSync
    );
  end;

implementation

uses
  Types,
  t_GeoTypes,
  i_CoordConverter,
  i_ProjectionInfo,
  u_GeoFunc,
  u_ListenerByEvent,
  u_TileRect;

{ TTileRectChangeableByLocalConverterAbstract }

constructor TTileRectChangeableByLocalConverterAbstract.Create(
  const ALocalCoordConverter: ILocalCoordConverterChangeable;
  const AMainLock: IReadWriteSync;
  const AResultLock: IReadWriteSync
);
begin
  Assert(Assigned(ALocalCoordConverter));
  Assert(Assigned(AMainLock));
  Assert(Assigned(AResultLock));
  inherited Create(AMainLock);
  FLocalCoordConverter := ALocalCoordConverter;
  FMainLock := AMainLock;
  FResultLock := AResultLock;
  FPrevLocalCoordConverter := nil;
  FListener := TNotifyNoMmgEventListener.Create(Self.OnConverterChanged);
end;

destructor TTileRectChangeableByLocalConverterAbstract.Destroy;
begin
  if Assigned(FLocalCoordConverter) and Assigned(FListener) then begin
    FLocalCoordConverter.ChangeNotifier.Remove(FListener);
    FListener := nil;
    FLocalCoordConverter := nil;
  end;
  inherited;
end;

procedure TTileRectChangeableByLocalConverterAbstract.AfterConstruction;
begin
  inherited;
  FLocalCoordConverter.ChangeNotifier.Add(FListener);
  OnConverterChanged;
end;

function TTileRectChangeableByLocalConverterAbstract.GetStatic: ITileRect;
begin
  FResultLock.BeginRead;
  try
    Result := FResult;
  finally
    FResultLock.EndRead;
  end;
end;

procedure TTileRectChangeableByLocalConverterAbstract.OnConverterChanged;
var
  VConverter: ILocalCoordConverter;
  VResult: ITileRect;
  VChanged: Boolean;
begin
  VChanged := False;
  FMainLock.BeginWrite;
  try
    VConverter := FLocalCoordConverter.GetStatic;
    if Assigned(VConverter) then begin
      if not VConverter.GetIsSameConverter(FPrevLocalCoordConverter) then begin
        VResult := BuildTileRect(VConverter);
        Assert(Assigned(VResult));
        if not VResult.IsEqual(FResult) then begin
          FResultLock.BeginWrite;
          try
            FResult := VResult;
            VChanged := True;
          finally
            FResultLock.EndWrite;
          end;
        end;
      end;
    end else begin
      if Assigned(FLocalCoordConverter) then begin
        FResultLock.BeginWrite;
        try
          FResult := nil;
          VChanged := True;
        finally
          FResultLock.EndWrite;
        end;
      end;
    end;
    FPrevLocalCoordConverter := VConverter;
  finally
    FMainLock.EndWrite;
  end;
  if VChanged then begin
    DoChangeNotify;
  end;
end;

{ TTileRectChangeableByLocalConverterSimple }

constructor TTileRectChangeableByLocalConverterSimple.Create(
  const ALocalCoordConverter: ILocalCoordConverterChangeable;
  const AMainLock, AResultLock: IReadWriteSync
);
begin
  inherited Create(ALocalCoordConverter, AMainLock, AResultLock);
end;

function TTileRectChangeableByLocalConverterSimple.BuildTileRect(
  const AConverter: ILocalCoordConverter
): ITileRect;
var
  VZoom: Byte;
  VPixelRect: TDoubleRect;
  VTileRectFloat: TDoubleRect;
  VTileRect: TRect;
  VConverter: ICoordConverter;
begin
  Assert(Assigned(AConverter));
  VZoom := AConverter.Zoom;
  VConverter := AConverter.GeoConverter;
  VPixelRect := AConverter.GetRectInMapPixelFloat;
  VConverter.ValidatePixelRectFloat(VPixelRect, VZoom);
  VTileRectFloat := VConverter.PixelRectFloat2TileRectFloat(VPixelRect, VZoom);
  VTileRect := RectFromDoubleRect(VTileRectFloat, rrOutside);
  Assert(VConverter.CheckTileRect(VTileRect, VZoom));
  Result := TTileRect.Create(AConverter.ProjectionInfo, VTileRect);
end;

{ TTileRectChangeableByLocalConverterSmart }

constructor TTileRectChangeableByLocalConverterSmart.Create(
  const AProjectionInfoFactory: IProjectionInfoFactory;
  const ALocalCoordConverter: ILocalCoordConverterChangeable;
  const AMainLock, AResultLock: IReadWriteSync
);
begin
  inherited Create(ALocalCoordConverter, AMainLock, AResultLock);
  FProjectionInfoFactory := AProjectionInfoFactory;
end;

function TTileRectChangeableByLocalConverterSmart.BuildTileRect(
  const AConverter: ILocalCoordConverter
): ITileRect;
var
  VZoom: Byte;
  VPixelRect: TDoubleRect;
  VRelativeRect: TDoubleRect;
  VTileRectFloat: TDoubleRect;
  VTileRect: TRect;
  VConverter: ICoordConverter;
  VScale: Double;
  VProjection: IProjectionInfo;
  VZoomMinus: Byte;
begin
  Assert(Assigned(AConverter));
  VZoom := AConverter.Zoom;
  VConverter := AConverter.GeoConverter;
  VPixelRect := AConverter.GetRectInMapPixelFloat;
  VConverter.ValidatePixelRectFloat(VPixelRect, VZoom);
  VScale := AConverter.GetScale;
  VZoomMinus := VZoom - 1;
  if (VScale > 0.9) or (not VConverter.CheckZoom(VZoomMinus)) then begin
    VProjection := AConverter.ProjectionInfo;
    VTileRectFloat := VConverter.PixelRectFloat2TileRectFloat(VPixelRect, VZoom);
    VTileRect := RectFromDoubleRect(VTileRectFloat, rrOutside);
    Assert(VConverter.CheckTileRect(VTileRect, VZoom));
  end else begin
    VRelativeRect := VConverter.PixelRectFloat2RelativeRect(VPixelRect, VZoom);
    VProjection := FProjectionInfoFactory.GetByConverterAndZoom(VConverter, VZoomMinus);
    VTileRectFloat := VConverter.RelativeRect2TileRectFloat(VRelativeRect, VZoomMinus);
    VTileRect := RectFromDoubleRect(VTileRectFloat, rrOutside);
    Assert(VConverter.CheckTileRect(VTileRect, VZoomMinus));
  end;
  Result := TTileRect.Create(VProjection, VTileRect);
end;

end.
