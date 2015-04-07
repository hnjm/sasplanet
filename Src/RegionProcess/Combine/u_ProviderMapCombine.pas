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

unit u_ProviderMapCombine;

interface

uses
  Windows,
  Forms,
  t_GeoTypes,
  i_LanguageManager,
  i_CoordConverter,
  i_CoordConverterFactory,
  i_CoordConverterList,
  i_BitmapLayerProvider,
  i_ProjectionInfo,
  i_GeometryProjected,
  i_GeometryLonLat,
  i_GeometryProjectedProvider,
  i_UseTilePrevZoomConfig,
  i_Bitmap32BufferFactory,
  i_BitmapPostProcessing,
  i_MapLayerGridsConfig,
  i_ValueToStringConverter,
  i_UsedMarksConfig,
  i_MarksDrawConfig,
  i_MarkSystem,
  i_MapCalibration,
  i_GeometryProjectedFactory,
  i_GlobalViewMainConfig,
  i_MapTypeListChangeable,
  i_RegionProcessProgressInfoInternalFactory,
  u_ExportProviderAbstract,
  fr_MapSelect,
  fr_MapCombine;

type
  TProviderMapCombineBase = class(TExportProviderAbstract)
  private
    FDefaultExt: string;
    FFormatName: string;
    FUseQuality: Boolean;
    FUseExif: Boolean;
    FUseAlfa: Boolean;
    FViewConfig: IGlobalViewMainConfig;
    FUseTilePrevZoomConfig: IUseTilePrevZoomConfig;
    FBitmapFactory: IBitmap32StaticFactory;
    FProjectionFactory: IProjectionInfoFactory;
    FCoordConverterList: ICoordConverterList;
    FVectorGeometryProjectedFactory: IGeometryProjectedFactory;
    FProjectedGeometryProvider: IGeometryProjectedProvider;
    FMarksDB: IMarkSystem;
    FMarksShowConfig: IUsedMarksConfig;
    FMarksDrawConfig: IMarksDrawConfig;
    FActiveMapsSet: IMapTypeListChangeable;
    FBitmapPostProcessing: IBitmapPostProcessingChangeable;
    FMapCalibrationList: IMapCalibrationList;
    FGridsConfig: IMapLayerGridsConfig;
    FValueToStringConverter: IValueToStringConverterChangeable;
  protected
    function PrepareTargetFileName: string;
    function PrepareTargetRect(
      const AProjection: IProjectionInfo;
      const APolygon: IGeometryProjectedPolygon
    ): TRect;
    function PrepareImageProvider(
      const APolygon: IGeometryLonLatPolygon;
      const AProjection: IProjectionInfo;
      const AProjectedPolygon: IGeometryProjectedPolygon
    ): IBitmapTileUniProvider;
    function PrepareGridsProvider: IBitmapTileUniProvider;
    function PrepareProjection: IProjectionInfo;
    function PreparePolygon(
      const AProjection: IProjectionInfo;
      const APolygon: IGeometryLonLatPolygon
    ): IGeometryProjectedPolygon;
  protected
    function CreateFrame: TFrame; override;
  protected
    function GetCaption: string; override;
  public
    constructor Create(
      const AProgressFactory: IRegionProcessProgressInfoInternalFactory;
      const ALanguageManager: ILanguageManager;
      const AMapSelectFrameBuilder: IMapSelectFrameBuilder;
      const AActiveMapsSet: IMapTypeListChangeable;
      const AViewConfig: IGlobalViewMainConfig;
      const AUseTilePrevZoomConfig: IUseTilePrevZoomConfig;
      const AProjectionFactory: IProjectionInfoFactory;
      const ACoordConverterList: ICoordConverterList;
      const AVectorGeometryProjectedFactory: IGeometryProjectedFactory;
      const AProjectedGeometryProvider: IGeometryProjectedProvider;
      const AMarksShowConfig: IUsedMarksConfig;
      const AMarksDrawConfig: IMarksDrawConfig;
      const AMarksDB: IMarkSystem;
      const ABitmapFactory: IBitmap32StaticFactory;
      const ABitmapPostProcessing: IBitmapPostProcessingChangeable;
      const AGridsConfig: IMapLayerGridsConfig;
      const AValueToStringConverter: IValueToStringConverterChangeable;
      const AMapCalibrationList: IMapCalibrationList;
      const AUseQuality: Boolean;
      const AUseExif: Boolean;
      const AUseAlfa: Boolean;
      const ADefaultExt: string;
      const AFormatName: string
    );
  end;

implementation

uses
  Classes,
  SysUtils,
  gnugettext,
  t_Bitmap32,
  i_LonLatRect,
  i_MarkCategoryList,
  i_MarkerProviderForVectorItem,
  i_VectorItemSubset,
  i_RegionProcessParamsFrame,
  u_GeoFunc,
  u_MarkerProviderForVectorItemForMarkPoints,
  u_BitmapLayerProviderByMarksSubset,
  u_BitmapLayerProviderSimpleForCombine,
  u_BitmapLayerProviderComplex,
  u_BitmapLayerProviderGridGenshtab,
  u_BitmapLayerProviderGridDegree,
  u_BitmapLayerProviderGridTiles,
  u_BitmapLayerProviderInPolygon,
  u_BitmapLayerProviderWithBGColor;

{ TProviderMapCombineBase }

constructor TProviderMapCombineBase.Create(
  const AProgressFactory: IRegionProcessProgressInfoInternalFactory;
  const ALanguageManager: ILanguageManager;
  const AMapSelectFrameBuilder: IMapSelectFrameBuilder;
  const AActiveMapsSet: IMapTypeListChangeable;
  const AViewConfig: IGlobalViewMainConfig;
  const AUseTilePrevZoomConfig: IUseTilePrevZoomConfig;
  const AProjectionFactory: IProjectionInfoFactory;
  const ACoordConverterList: ICoordConverterList;
  const AVectorGeometryProjectedFactory: IGeometryProjectedFactory;
  const AProjectedGeometryProvider: IGeometryProjectedProvider;
  const AMarksShowConfig: IUsedMarksConfig;
  const AMarksDrawConfig: IMarksDrawConfig;
  const AMarksDB: IMarkSystem;
  const ABitmapFactory: IBitmap32StaticFactory;
  const ABitmapPostProcessing: IBitmapPostProcessingChangeable;
  const AGridsConfig: IMapLayerGridsConfig;
  const AValueToStringConverter: IValueToStringConverterChangeable;
  const AMapCalibrationList: IMapCalibrationList;
  const AUseQuality: Boolean;
  const AUseExif: Boolean;
  const AUseAlfa: Boolean;
  const ADefaultExt: string;
  const AFormatName: string
);
begin
  inherited Create(
    AProgressFactory,
    ALanguageManager,
    AMapSelectFrameBuilder
  );
  FMapCalibrationList := AMapCalibrationList;
  FViewConfig := AViewConfig;
  FUseTilePrevZoomConfig := AUseTilePrevZoomConfig;
  FMarksShowConfig := AMarksShowConfig;
  FMarksDrawConfig := AMarksDrawConfig;
  FMarksDB := AMarksDB;
  FActiveMapsSet := AActiveMapsSet;
  FBitmapPostProcessing := ABitmapPostProcessing;
  FBitmapFactory := ABitmapFactory;
  FProjectionFactory := AProjectionFactory;
  FCoordConverterList := ACoordConverterList;
  FVectorGeometryProjectedFactory := AVectorGeometryProjectedFactory;
  FProjectedGeometryProvider := AProjectedGeometryProvider;
  FGridsConfig := AGridsConfig;
  FValueToStringConverter := AValueToStringConverter;
  FUseQuality := AUseQuality;
  FUseExif := AUseExif;
  FUseAlfa := AUseAlfa;
  FDefaultExt := ADefaultExt;
  FFormatName := AFormatName;
end;

function TProviderMapCombineBase.CreateFrame: TFrame;
begin
  Result :=
    TfrMapCombine.Create(
      Self.LanguageManager,
      FProjectionFactory,
      FCoordConverterList,
      FVectorGeometryProjectedFactory,
      FBitmapFactory,
      Self.MapSelectFrameBuilder,
      FActiveMapsSet,
      FViewConfig,
      FUseTilePrevZoomConfig,
      FMapCalibrationList,
      FUseQuality,
      FUseExif,
      FUseAlfa,
      FDefaultExt,
      FFormatName
    );
  Assert(Supports(Result, IRegionProcessParamsFrameImageProvider));
  Assert(Supports(Result, IRegionProcessParamsFrameMapCalibrationList));
  Assert(Supports(Result, IRegionProcessParamsFrameTargetProjection));
  Assert(Supports(Result, IRegionProcessParamsFrameTargetPath));
  Assert(Supports(Result, IRegionProcessParamsFrameMapCombine));
  Assert(Supports(Result, IRegionProcessParamsFrameMapCombineJpg));
  Assert(Supports(Result, IRegionProcessParamsFrameMapCombineWithAlfa));
end;

function TProviderMapCombineBase.GetCaption: string;
begin
  Result := _(FFormatName);
end;

function TProviderMapCombineBase.PrepareGridsProvider: IBitmapTileUniProvider;
var
  VVisible: Boolean;
  VColor: TColor32;
  VUseRelativeZoom: Boolean;
  VZoom: Integer;
  VShowText: Boolean;
  VShowLines: Boolean;
  VScale: Integer;
  VScaleDegree: Double;
  VProvider: IBitmapTileUniProvider;
  VResult: IBitmapTileUniProvider;
begin
  VResult := nil;
  FGridsConfig.TileGrid.LockRead;
  try
    VVisible := FGridsConfig.TileGrid.Visible;
    VColor := FGridsConfig.TileGrid.GridColor;
    VUseRelativeZoom := FGridsConfig.TileGrid.UseRelativeZoom;
    VZoom := FGridsConfig.TileGrid.Zoom;
    VShowText := FGridsConfig.TileGrid.ShowText;
    VShowLines := True;
  finally
    FGridsConfig.TileGrid.UnlockRead;
  end;
  if VVisible then begin
    VResult :=
      TBitmapLayerProviderGridTiles.Create(
        FBitmapFactory,
        VColor,
        VUseRelativeZoom,
        VZoom,
        VShowText,
        VShowLines
      );
  end;
  FGridsConfig.GenShtabGrid.LockRead;
  try
    VVisible := FGridsConfig.GenShtabGrid.Visible;
    VColor := FGridsConfig.GenShtabGrid.GridColor;
    VScale := FGridsConfig.GenShtabGrid.Scale;
    VShowText := FGridsConfig.GenShtabGrid.ShowText;
    VShowLines := True;
  finally
    FGridsConfig.GenShtabGrid.UnlockRead;
  end;
  if VVisible then begin
    VProvider :=
      TBitmapLayerProviderGridGenshtab.Create(
        FBitmapFactory,
        VColor,
        VScale,
        VShowText,
        VShowLines
      );

    if VResult <> nil then begin
      VResult :=
        TBitmapLayerProviderComplex.Create(
          FBitmapFactory,
          VResult,
          VProvider
        );
    end else begin
      VResult := VProvider;
    end;
  end;
  FGridsConfig.DegreeGrid.LockRead;
  try
    VVisible := FGridsConfig.DegreeGrid.Visible;
    VColor := FGridsConfig.DegreeGrid.GridColor;
    VScaleDegree := FGridsConfig.DegreeGrid.Scale;
    VShowText := FGridsConfig.DegreeGrid.ShowText;
    VShowLines := True;
  finally
    FGridsConfig.DegreeGrid.UnlockRead;
  end;
  if VVisible then begin
    VProvider :=
      TBitmapLayerProviderGridDegree.Create(
        FBitmapFactory,
        VColor,
        VScaleDegree,
        VShowText,
        VShowLines,
        FValueToStringConverter.GetStatic
      );
    if VResult <> nil then begin
      VResult :=
        TBitmapLayerProviderComplex.Create(
          FBitmapFactory,
          VResult,
          VProvider
        );
    end else begin
      VResult := VProvider;
    end;
  end;
  Result := VResult;
end;

function TProviderMapCombineBase.PrepareImageProvider(
  const APolygon: IGeometryLonLatPolygon;
  const AProjection: IProjectionInfo;
  const AProjectedPolygon: IGeometryProjectedPolygon
): IBitmapTileUniProvider;
var
  VRect: ILonLatRect;
  VLonLatRect: TDoubleRect;
  VZoom: Byte;
  VGeoConverter: ICoordConverter;
  VMarksSubset: IVectorItemSubset;
  VMarksConfigStatic: IUsedMarksConfigStatic;
  VList: IMarkCategoryList;
  VMarksImageProvider: IBitmapTileUniProvider;
  VRecolorConfig: IBitmapPostProcessing;
  VSourceProvider: IBitmapTileUniProvider;
  VUseMarks: Boolean;
  VUseGrids: Boolean;
  VUseRecolor: Boolean;
  VMarkerProvider: IMarkerProviderForVectorItem;
  VGridsProvider: IBitmapTileUniProvider;
begin
  VSourceProvider := (ParamsFrame as IRegionProcessParamsFrameImageProvider).Provider;
  VRect := APolygon.Bounds;
  VLonLatRect := VRect.Rect;
  VGeoConverter := AProjection.GeoConverter;
  VZoom := AProjection.Zoom;
  VGeoConverter.ValidateLonLatRect(VLonLatRect);

  VMarksSubset := nil;
  VUseMarks := (ParamsFrame as IRegionProcessParamsFrameMapCombine).UseMarks;
  if VUseMarks then begin
    VMarksConfigStatic := FMarksShowConfig.GetStatic;
    if VMarksConfigStatic.IsUseMarks then begin
      VList := nil;
      if not VMarksConfigStatic.IgnoreCategoriesVisible then begin
        VList := FMarksDB.CategoryDB.GetVisibleCategories(VZoom);
      end;
      try
        if (VList <> nil) and (VList.Count = 0) then begin
          VMarksSubset := nil;
        end else begin
          VMarksSubset :=
            FMarksDB.MarkDb.GetMarkSubsetByCategoryListInRect(
              VLonLatRect,
              VList,
              VMarksConfigStatic.IgnoreMarksVisible
            );
        end;
      finally
        VList := nil;
      end;
    end;
  end else begin
    VMarksSubset := nil;
  end;
  VMarksImageProvider := nil;
  if VMarksSubset <> nil then begin
    VMarkerProvider :=
      TMarkerProviderForVectorItemForMarkPoints.Create(
        FBitmapFactory,
        nil
      );
    VMarksImageProvider :=
      TBitmapLayerProviderByMarksSubset.Create(
        FMarksDrawConfig.DrawOrderConfig.GetStatic,
        FMarksDrawConfig.CaptionDrawConfig.GetStatic,
        FBitmapFactory,
        FProjectedGeometryProvider,
        VMarkerProvider,
        VMarksSubset
      );
  end;
  VRecolorConfig := nil;
  VUseRecolor := (ParamsFrame as IRegionProcessParamsFrameMapCombine).UseRecolor;
  if VUseRecolor then begin
    VRecolorConfig := FBitmapPostProcessing.GetStatic;
  end;
  Result :=
    TBitmapLayerProviderSimpleForCombine.Create(
      FBitmapFactory,
      VRecolorConfig,
      VSourceProvider,
      VMarksImageProvider
    );
  VUseGrids := (ParamsFrame as IRegionProcessParamsFrameMapCombine).UseGrids;
  VGridsProvider := nil;
  if VUseGrids then begin
    VGridsProvider := PrepareGridsProvider;
  end;
  if Assigned(VGridsProvider) then begin
    Result :=
      TBitmapLayerProviderComplex.Create(
        FBitmapFactory,
        Result,
        VGridsProvider
      );
  end;

  Result :=
    TBitmapLayerProviderInPolygon.Create(
      AProjectedPolygon,
      Result
    );
  Result :=
    TBitmapLayerProviderWithBGColor.Create(
      (ParamsFrame as IRegionProcessParamsFrameMapCombine).BGColor,
      FBitmapFactory,
      Result
    );
end;

function TProviderMapCombineBase.PreparePolygon(
  const AProjection: IProjectionInfo;
  const APolygon: IGeometryLonLatPolygon
): IGeometryProjectedPolygon;
begin
  Result :=
    FVectorGeometryProjectedFactory.CreateProjectedPolygonByLonLatPolygon(
      AProjection,
      APolygon
    );
end;

function TProviderMapCombineBase.PrepareProjection: IProjectionInfo;
begin
  Result := (ParamsFrame as IRegionProcessParamsFrameTargetProjection).Projection;
end;

function TProviderMapCombineBase.PrepareTargetRect(
  const AProjection: IProjectionInfo;
  const APolygon: IGeometryProjectedPolygon
): TRect;
begin
  Result := RectFromDoubleRect(APolygon.Bounds, rrOutside);
end;

function TProviderMapCombineBase.PrepareTargetFileName: string;
begin
  Result := (ParamsFrame as IRegionProcessParamsFrameTargetPath).Path;
  if Result = '' then begin
    raise Exception.Create(_('Please, select output file first!'));
  end;
end;

end.
