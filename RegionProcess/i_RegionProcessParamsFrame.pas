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

unit i_RegionProcessParamsFrame;

interface

uses
  Types,
  i_GeometryLonLat,
  i_BitmapLayerProvider,
  i_MapCalibration,
  i_ProjectionInfo,
  i_PredicateByTileInfo,
  i_MapTypes;

type
  TDeleteSrc = (dmNone=-1, dmTiles=0, dmMarks=1);
  IRegionProcessParamsFrameBase = interface
    ['{F5346D9B-766C-4B3B-AC4B-9AC71FF62F05}']
    procedure Init(
      const AZoom: byte;
      const APolygon: IGeometryLonLatPolygon
    );
    function Validate: Boolean;
  end;

  IRegionProcessParamsFrameOneMap = interface(IRegionProcessParamsFrameBase)
    ['{240B7587-DDC0-4471-BDF4-AD2EE0040526}']
    function GetMapType: IMapType;
    property MapType: IMapType read GetMapType;
  end;

  IRegionProcessParamsFrameMarksState = interface(IRegionProcessParamsFrameBase)
    ['{97F8B47B-44D4-473A-B841-F23FCBFBC4D5}']
    function MarksState: Byte;
    property GetMarksState: Byte read MarksState;

    function DeleteHiddenMarks: Boolean;
    property GetDeleteHiddenMarks: Boolean read DeleteHiddenMarks;

    function DeleteMode: TDeleteSrc;
    property GetDeleteMode: TDeleteSrc read DeleteMode;

  end;

  IRegionProcessParamsFrameOneZoom = interface(IRegionProcessParamsFrameBase)
    ['{A1A9D2C3-4C9F-4205-B19C-5A768E938808}']
    function GetZoom: Byte;
    property Zoom: Byte read GetZoom;
  end;

  IRegionProcessParamsFrameZoomArray = interface(IRegionProcessParamsFrameBase)
    ['{9DB542F9-7F4E-4DFF-8957-E0E81B8A9096}']
    function GetZoomArray: TByteDynArray;
    property ZoomArray: TByteDynArray read GetZoomArray;
  end;

  IRegionProcessParamsFrameTargetProjection = interface(IRegionProcessParamsFrameBase)
    ['{F0FACC2E-C686-4282-99A1-E5E2F1F5CE2D}']
    function GetProjection: IProjectionInfo;
    property Projection: IProjectionInfo read GetProjection;
  end;

  IRegionProcessParamsFrameMapCalibrationList = interface(IRegionProcessParamsFrameBase)
    ['{41A9899D-D431-4D12-8DC4-1F65B36A8CAB}']
    function GetMapCalibrationList: IMapCalibrationList;
    property MapCalibrationList: IMapCalibrationList read GetMapCalibrationList;
  end;

  IRegionProcessParamsFrameImageProvider = interface(IRegionProcessParamsFrameBase)
    ['{98A4BE9B-AF50-45F5-8E26-0DBF0F094C0B}']
    function GetProvider: IBitmapLayerProvider;
    property Provider: IBitmapLayerProvider read GetProvider;
  end;

  IRegionProcessParamsFrameProcessPredicate = interface(IRegionProcessParamsFrameBase)
    ['{DF8D4BBB-BA83-412A-BA70-3A1E454AD3C3}']
    function GetPredicate: IPredicateByTileInfo;
    property Predicate: IPredicateByTileInfo read GetPredicate;
  end;

  IRegionProcessParamsFrameTargetPath = interface(IRegionProcessParamsFrameBase)
    ['{A0510824-7E26-430F-9C04-AE71EBAD65FF}']
    function GetPath: string;
    property Path: string read GetPath;
  end;

implementation

end.
