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

unit u_MapLayerBitmapMaps;

interface

uses
  GR32_Image,
  i_NotifierTime,
  i_NotifierOperation,
  i_TileError,
  i_BitmapPostProcessing,
  i_LocalCoordConverterChangeable,
  i_LocalCoordConverterFactorySimpe,
  i_UseTilePrevZoomConfig,
  i_Bitmap32StaticFactory,
  i_ThreadConfig,
  i_MapTypes,
  i_MapTypeSetChangeable,
  i_MapTypeListChangeable,
  i_InternalPerformanceCounter,
  i_ImageResamplerConfig,
  u_TiledLayerWithThreadBase;

type
  TMapLayerBitmapMaps = class(TTiledLayerWithThreadBase)
  public
    constructor Create(
      const APerfList: IInternalPerformanceCounterList;
      const AAppStartedNotifier: INotifierOneOperation;
      const AAppClosingNotifier: INotifierOneOperation;
      AParentMap: TImage32;
      const APosition: ILocalCoordConverterChangeable;
      const AView: ILocalCoordConverterChangeable;
      const ATileMatrixDraftResamplerConfig: IImageResamplerConfig;
      const AConverterFactory: ILocalCoordConverterFactorySimpe;
      const AMainMap: IMapTypeChangeable;
      const ALayesList: IMapTypeListChangeable;
      const AAllActiveMapsSet: IMapTypeSetChangeable;
      const APostProcessing: IBitmapPostProcessingChangeable;
      const AUseTilePrevZoomConfig: IUseTilePrevZoomConfig;
      const AThreadConfig: IThreadConfig;
      const ABitmapFactory: IBitmap32StaticFactory;
      const AErrorLogger: ITileErrorLogger;
      const ATimerNoifier: INotifierTime
    );
  end;

implementation

uses
  i_TileMatrix,
  i_BitmapLayerProviderChangeable,
  i_ObjectWithListener,
  u_TileMatrixFactory,
  u_SourceDataUpdateInRectByMapsSet,
  u_BitmapLayerProviderChangeableForMainLayer;

{ TMapLayerBitmapMaps }

constructor TMapLayerBitmapMaps.Create(
  const APerfList: IInternalPerformanceCounterList;
  const AAppStartedNotifier: INotifierOneOperation;
  const AAppClosingNotifier: INotifierOneOperation;
  AParentMap: TImage32;
  const APosition: ILocalCoordConverterChangeable;
  const AView: ILocalCoordConverterChangeable;
  const ATileMatrixDraftResamplerConfig: IImageResamplerConfig;
  const AConverterFactory: ILocalCoordConverterFactorySimpe;
  const AMainMap: IMapTypeChangeable;
  const ALayesList: IMapTypeListChangeable;
  const AAllActiveMapsSet: IMapTypeSetChangeable;
  const APostProcessing: IBitmapPostProcessingChangeable;
  const AUseTilePrevZoomConfig: IUseTilePrevZoomConfig;
  const AThreadConfig: IThreadConfig;
  const ABitmapFactory: IBitmap32StaticFactory;
  const AErrorLogger: ITileErrorLogger;
  const ATimerNoifier: INotifierTime
);
var
  VTileMatrixFactory: ITileMatrixFactory;
  VProvider: IBitmapLayerProviderChangeable;
  VSourceChangeNotifier: IObjectWithListener;
begin
  VTileMatrixFactory :=
    TTileMatrixFactory.Create(
      ATileMatrixDraftResamplerConfig,
      ABitmapFactory,
      AConverterFactory
    );
  VProvider :=
    TBitmapLayerProviderChangeableForMainLayer.Create(
      AMainMap,
      ALayesList,
      APostProcessing,
      AUseTilePrevZoomConfig,
      ABitmapFactory,
      AErrorLogger
    );

  VSourceChangeNotifier :=
    TSourceDataUpdateInRectByMapsSet.Create(AAllActiveMapsSet);
  inherited Create(
    APerfList,
    AAppStartedNotifier,
    AAppClosingNotifier,
    AParentMap,
    APosition,
    AView,
    VTileMatrixFactory,
    VProvider,
    VSourceChangeNotifier,
    ATimerNoifier,
    AThreadConfig,
    Self.ClassName
  );
end;

end.
