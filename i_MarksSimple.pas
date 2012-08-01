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

unit i_MarksSimple;

interface

uses
  ActiveX,
  GR32,
  t_GeoTypes,
  i_VectorItemLonLat,
  i_VectorDataItemSimple,
  i_MarkCategory,
  i_MarkPicture;

type
  IMarkId = interface
    ['{A3FE0170-8D32-4777-A3EA-53D678875B7B}']
    function GetCategory: ICategory;
    property Category: ICategory read GetCategory;

    function GetName: string;
    property Name: string read GetName;

    function GetMarkType: TGUID;
    property MarkType: TGUID read GetMarkType;
  end;

  IMark = interface(IVectorDataItemSimple)
    ['{52794019-3681-4C92-B50F-0853D5B070DE}']
    function GetCategory: ICategory;
    property Category: ICategory read GetCategory;

    function IsSameId(const AMarkId: IMarkId): Boolean;
    function IsEqual(const AMark: IMark): Boolean;
    function GetGoToLonLat: TDoublePoint;
  end;

  IMarkPoint = interface(IMark)
    ['{6E8C2BA9-4A1A-49A8-98FF-8F5BFCBDB00C}']
    function GetPoint: TDoublePoint;
    property Point: TDoublePoint read GetPoint;

    function GetTextColor: TColor32;
    property TextColor: TColor32 read GetTextColor;

    function GetTextBgColor: TColor32;
    property TextBgColor: TColor32 read GetTextBgColor;

    function GetFontSize: Integer;
    property FontSize: Integer read GetFontSize;

    function GetMarkerSize: Integer;
    property MarkerSize: Integer read GetMarkerSize;

    function GetPic: IMarkPicture;
    property Pic: IMarkPicture read GetPic;
  end;

  IMarkLine = interface(IMark)
    ['{3C400B96-90E1-4ADD-9AA2-56199AC1910F}']
    function GetLine: ILonLatPath;
    property Line: ILonLatPath read GetLine;

    function GetLineColor: TColor32;
    property LineColor: TColor32 read GetLineColor;

    function GetLineWidth: Integer;
    property LineWidth: Integer read GetLineWidth;
  end;

  IMarkPoly = interface(IMark)
    ['{5C66FCE6-F235-4E34-B32A-AB1DD5F0C5B1}']
    function GetLine: ILonLatPolygon;
    property Line: ILonLatPolygon read GetLine;

    function GetBorderColor: TColor32;
    property BorderColor: TColor32 read GetBorderColor;

    function GetFillColor: TColor32;
    property FillColor: TColor32 read GetFillColor;

    function GetLineWidth: Integer;
    property LineWidth: Integer read GetLineWidth;
  end;

  IMarksSubset = interface
    ['{D2DBC018-AAF5-44CB-A2B1-B5AC1C3341C5}']
    function GetSubsetByLonLatRect(const ARect: TDoubleRect): IMarksSubset;
    function GetSubsetByCategory(const ACategory: ICategory): IMarksSubset;
    function GetEnum: IEnumUnknown;
    function IsEmpty: Boolean;
  end;

implementation

end.
