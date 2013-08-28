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

unit u_VectorDataItemPolygon;

interface

uses
  t_Hash,
  t_GeoTypes,
  i_Appearance,
  i_LonLatRect,
  i_VectorDataItemSimple,
  i_VectorItemLonLat,
  i_HtmlToHintTextConverter,
  u_VectorDataItemBase;

type
  TVectorDataItemPolygon = class(TVectorDataItemBase)
  private
    FLLRect: ILonLatRect;
  protected
    function GetLLRect: ILonLatRect; override;
  public
    constructor Create(
      const AHash: THashValue;
      const AAppearance: IAppearance;
      const AHintConverter: IHtmlToHintTextConverter;
      const AName: string;
      const ADesc: string;
      const ALLRect: ILonLatRect
    );
  end;

  TVectorDataItemPath = class(TVectorDataItemPolygon, IVectorDataItemLine)
  private
    FLine: ILonLatPath;
  protected
    function GetLine: ILonLatPath;
    function GetGoToLonLat: TDoublePoint; override;
  public
    constructor Create(
      const AHash: THashValue;
      const AAppearance: IAppearance;
      const AHintConverter: IHtmlToHintTextConverter;
      const AName: string;
      const ADesc: string;
      const ALine: ILonLatPath
    );
  end;

  TVectorDataItemPoly = class(TVectorDataItemPolygon, IVectorDataItemPoly)
  private
    FLine: ILonLatPolygon;
  protected
    function GetLine: ILonLatPolygon;
    function GetGoToLonLat: TDoublePoint; override;
  public
    constructor Create(
      const AHash: THashValue;
      const AAppearance: IAppearance;
      const AHintConverter: IHtmlToHintTextConverter;
      const AName: string;
      const ADesc: string;
      const ALine: ILonLatPolygon
    );
  end;


implementation

uses
  u_GeoFun;
  
{ TVectorDataItemPolygon }

constructor TVectorDataItemPolygon.Create(
  const AHash: THashValue;
  const AAppearance: IAppearance;
  const AHintConverter: IHtmlToHintTextConverter;
  const AName, ADesc: string;
  const ALLRect: ILonLatRect
);
begin
  inherited Create(AHash, AAppearance, AHintConverter, AName, ADesc);
  FLLRect := ALLRect;
end;

function TVectorDataItemPolygon.GetLLRect: ILonLatRect;
begin
  Result := FLLRect;
end;

{ TVectorDataItemPath }

constructor TVectorDataItemPath.Create(
  const AHash: THashValue;
  const AAppearance: IAppearance;
  const AHintConverter: IHtmlToHintTextConverter;
  const AName, ADesc: string;
  const ALine: ILonLatPath
);
begin
  Assert(Assigned(ALine));
  inherited Create(AHash, AAppearance, AHintConverter, AName, ADesc, ALine.Bounds);
  FLine := ALine;
end;

function TVectorDataItemPath.GetGoToLonLat: TDoublePoint;
begin
  FLine.GetEnum.Next(Result);
end;

function TVectorDataItemPath.GetLine: ILonLatPath;
begin
  Result := FLine;
end;

{ TVectorDataItemPoly }

constructor TVectorDataItemPoly.Create(
  const AHash: THashValue;
  const AAppearance: IAppearance;
  const AHintConverter: IHtmlToHintTextConverter;
  const AName, ADesc: string;
  const ALine: ILonLatPolygon
);
begin
  Assert(Assigned(ALine));
  inherited Create(AHash, AAppearance, AHintConverter, AName, ADesc, ALine.Bounds);
  FLine := ALine;
end;

function TVectorDataItemPoly.GetGoToLonLat: TDoublePoint;
begin
  Result := RectCenter(FLine.Bounds.Rect);
end;

function TVectorDataItemPoly.GetLine: ILonLatPolygon;
begin
  Result := FLine;
end;

end.
