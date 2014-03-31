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

unit u_MapLayerMarks;

interface

uses
  GR32_Image,
  i_NotifierTime,
  i_NotifierOperation,
  i_LocalCoordConverterChangeable,
  i_LocalCoordConverterFactorySimpe,
  i_InternalPerformanceCounter,
  i_MarksLayerConfig,
  i_Bitmap32StaticFactory,
  i_ImageResamplerFactoryChangeable,
  i_MarkerProviderForVectorItem,
  i_VectorItemSubsetChangeable,
  i_GeometryProjectedProvider,
  u_TiledLayerWithThreadBase;

type
  TMapLayerMarks = class(TTiledLayerWithThreadBase)
  public
    constructor Create(
      const APerfList: IInternalPerformanceCounterList;
      const AAppStartedNotifier: INotifierOneOperation;
      const AAppClosingNotifier: INotifierOneOperation;
      AParentMap: TImage32;
      const APosition: ILocalCoordConverterChangeable;
      const AView: ILocalCoordConverterChangeable;
      const ATileMatrixDraftResampler: IImageResamplerFactoryChangeable;
      const AConverterFactory: ILocalCoordConverterFactorySimpe;
      const AProjectedCache: IGeometryProjectedProvider;
      const AMarkerProvider: IMarkerProviderForVectorItem;
      const ATimerNoifier: INotifierTime;
      const ABitmapFactory: IBitmap32BufferFactory;
      const AMarksSubset: IVectorItemSubsetChangeable;
      const AConfig: IMarksLayerConfig
    );
  end;

implementation

uses
  i_TileMatrix,
  i_BitmapLayerProviderChangeable,
  u_TileMatrixFactory,
  u_BitmapLayerProviderChangeableForMarksLayer;

{ TMapLayerMarks }

constructor TMapLayerMarks.Create(
  const APerfList: IInternalPerformanceCounterList;
  const AAppStartedNotifier, AAppClosingNotifier: INotifierOneOperation;
  AParentMap: TImage32;
  const APosition: ILocalCoordConverterChangeable;
  const AView: ILocalCoordConverterChangeable;
  const ATileMatrixDraftResampler: IImageResamplerFactoryChangeable;
  const AConverterFactory: ILocalCoordConverterFactorySimpe;
  const AProjectedCache: IGeometryProjectedProvider;
  const AMarkerProvider: IMarkerProviderForVectorItem;
  const ATimerNoifier: INotifierTime;
  const ABitmapFactory: IBitmap32BufferFactory;
  const AMarksSubset: IVectorItemSubsetChangeable;
  const AConfig: IMarksLayerConfig
);
var
  VTileMatrixFactory: ITileMatrixFactory;
  VProvider: IBitmapLayerProviderChangeable;
begin
  VTileMatrixFactory :=
    TTileMatrixFactory.Create(
      ATileMatrixDraftResampler,
      ABitmapFactory,
      AConverterFactory
    );
  VProvider :=
    TBitmapLayerProviderChangeableForMarksLayer.Create(
      AConfig.MarksDrawConfig,
      ABitmapFactory,
      AProjectedCache,
      AMarkerProvider,
      AMarksSubset
    );
  inherited Create(
    APerfList,
    AAppStartedNotifier,
    AAppClosingNotifier,
    AParentMap,
    APosition,
    AView,
    VTileMatrixFactory,
    VProvider,
    nil,
    ATimerNoifier,
    AConfig.ThreadConfig,
    Self.ClassName
  );
end;

end.
