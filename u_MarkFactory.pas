{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2011, SAS.Planet development team.                      *}
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

unit u_MarkFactory;

interface

uses
  GR32,
  t_GeoTypes,
  i_VectorItemLonLat,
  i_VectorItmesFactory,
  i_MarkPicture,
  i_MarksFactoryConfig,
  i_MarkCategory,
  i_MarkCategoryDBSmlInternal,
  i_MarksSimple,
  i_MarkTemplate,
  i_HtmlToHintTextConverter,
  i_MarkFactory,
  i_MarkFactorySmlInternal;

type

  TMarkFactory =  class(TInterfacedObject, IMarkFactory, IMarkFactorySmlInternal)
  private
    FConfig: IMarksFactoryConfig;
    FFactory: IVectorItmesFactory;
    FDbCode: Integer;
    FCategoryDB: IMarkCategoryDBSmlInternal;
    FHintConverter: IHtmlToHintTextConverter;

    FMarkPictureList: IMarkPictureList;

    function CreatePoint(
      AID: Integer;
      AName: string;
      AVisible: Boolean;
      APicName: string;
      APic: IMarkPicture;
      ACategoryId: Integer;
      ACategory: ICategory;
      ADesc: string;
      APoint: TDoublePoint;
      ATextColor, ATextBgColor: TColor32;
      AFontSize, AMarkerSize: Integer
    ): IMarkPoint;
    function CreateLine(
      AID: Integer;
      AName: string;
      AVisible: Boolean;
      ACategoryId: Integer;
      ACategory: ICategory;
      ADesc: string;
      ARect: TDoubleRect;
      ALine: ILonLatPath;
      ALineColor: TColor32;
      ALineWidth: Integer
    ): IMarkLine;
    function CreatePoly(
      AID: Integer;
      AName: string;
      AVisible: Boolean;
      ACategoryId: Integer;
      ACategory: ICategory;
      ADesc: string;
      ARect: TDoubleRect;
      ALine: ILonLatPolygon;
      ABorderColor, AFillColor: TColor32;
      ALineWidth: Integer
    ): IMarkPoly;
  protected
    function CreateNewPoint(
      APoint: TDoublePoint;
      AName: string;
      ADesc: string;
      ATemplate: IMarkTemplatePoint = nil
    ): IMarkPoint;
    function CreateNewLine(
      ALine: ILonLatPath;
      AName: string;
      ADesc: string;
      ATemplate: IMarkTemplateLine = nil
    ): IMarkLine;
    function CreateNewPoly(
      ALine: ILonLatPolygon;
      AName: string;
      ADesc: string;
      ATemplate: IMarkTemplatePoly = nil
    ): IMarkPoly;

    function ModifyPoint(
      ASource: IMarkPoint;
      AName: string;
      AVisible: Boolean;
      APic: IMarkPicture;
      ACategory: ICategory;
      ADesc: string;
      APoint: TDoublePoint;
      ATextColor: TColor32;
      ATextBgColor: TColor32;
      AFontSize: Integer;
      AMarkerSize: Integer
    ): IMarkPoint;
    function ModifyLine(
      ASource: IMarkLine;
      AName: string;
      AVisible: Boolean;
      ACategory: ICategory;
      ADesc: string;
      ALine: ILonLatPath;
      ALineColor: TColor32;
      ALineWidth: Integer
    ): IMarkLine;
    function ModifyPoly(
      ASource: IMarkPoly;
      AName: string;
      AVisible: Boolean;
      ACategory: ICategory;
      ADesc: string;
      ALine: ILonLatPolygon;
      ABorderColor: TColor32;
      AFillColor: TColor32;
      ALineWidth: Integer
    ): IMarkPoly;

    function SimpleModifyLine(
      ASource: IMarkLine;
      ALine: ILonLatPath;
      ADesc: string
    ): IMarkLine;
    function SimpleModifyPoly(
      ASource: IMarkPoly;
      ALine: ILonLatPolygon
    ): IMarkPoly;

    function GetMarkPictureList: IMarkPictureList;
    function GetConfig: IMarksFactoryConfig;
  protected
    function CreateMark(
      AID: Integer;
      AName: string;
      AVisible: Boolean;
      APicName: string;
      ACategoryId: Integer;
      ADesc: string;
      ARect: TDoubleRect;
      APoints: TArrayOfDoublePoint;
      AColor1: TColor32;
      AColor2: TColor32;
      AScale1: Integer;
      AScale2: Integer
    ): IMark;
    function CreateMarkId(
      AName: string;
      AId: Integer;
      ACategoryId: Integer;
      AVisible: Boolean
    ): IMarkID;
  public
    constructor Create(
      ADbCode: Integer;
      AConfig: IMarksFactoryConfig;
      AFactory: IVectorItmesFactory;
      AHintConverter: IHtmlToHintTextConverter;
      ACategoryDB: IMarkCategoryDBSmlInternal
    );
  end;

implementation

uses
  SysUtils,
  i_MarksDbSmlInternal,
  u_GeoFun,
  u_MarkId,
  u_MarkPoint,
  u_MarkLine,
  u_MarkPoly;

{ TMarkFactory }

constructor TMarkFactory.Create(
  ADbCode: Integer;
  AConfig: IMarksFactoryConfig;
  AFactory: IVectorItmesFactory;
  AHintConverter: IHtmlToHintTextConverter;
  ACategoryDB: IMarkCategoryDBSmlInternal
);
begin
  FDbCode := ADbCode;
  FConfig := AConfig;
  FFactory := AFactory;
  FHintConverter := AHintConverter;
  FCategoryDB := ACategoryDB;
  FMarkPictureList := FConfig.PointTemplateConfig.MarkPictureList;
end;

function TMarkFactory.CreateNewLine(
  ALine: ILonLatPath;
  AName, ADesc: string;
  ATemplate: IMarkTemplateLine
): IMarkLine;
var
  VTemplate: IMarkTemplateLine;
  VTemplateSML: IMarkTemplateSMLInternal;
  VCategory: ICategory;
  VCategoryID: Integer;
  VName: string;
begin
  VTemplate := ATemplate;
  if VTemplate = nil then begin
    VTemplate := FConfig.LineTemplateConfig.DefaultTemplate;
  end;

  VName := AName;
  if VName = '' then begin
    VName := VTemplate.GetNewName;
  end;

  VCategoryID := -1;
  if Supports(VTemplate, IMarkTemplateSMLInternal, VTemplateSML) then begin
    VCategoryID := VTemplateSML.CategoryId;
  end;

  Result := CreateLine(
    -1,
    VName,
    True,
    VCategoryId,
    VCategory,
    ADesc,
    ALine.Bounds,
    ALine,
    VTemplate.LineColor,
    VTemplate.LineWidth
  );
end;

function TMarkFactory.CreateNewPoint(APoint: TDoublePoint; AName, ADesc: string;
  ATemplate: IMarkTemplatePoint): IMarkPoint;
var
  VTemplate: IMarkTemplatePoint;
  VTemplateSML: IMarkTemplateSMLInternal;
  VName: string;
  VCategory: ICategory;
  VCategoryID: Integer;
begin
  VTemplate := ATemplate;
  if VTemplate = nil then begin
    VTemplate := FConfig.PointTemplateConfig.DefaultTemplate;
  end;

  VName := AName;
  if VName = '' then begin
    VName := VTemplate.GetNewName;
  end;

  VCategoryID := -1;
  if Supports(VTemplate, IMarkTemplateSMLInternal, VTemplateSML) then begin
    VCategoryID := VTemplateSML.CategoryId;
  end;

  Result := CreatePoint(
    -1,
    VName,
    True,
    '',
    VTemplate.Pic,
    VCategoryId,
    VCategory,
    ADesc,
    APoint,
    VTemplate.TextColor,
    VTemplate.TextBgColor,
    VTemplate.FontSize,
    VTemplate.MarkerSize
  );
end;

function TMarkFactory.CreateNewPoly(
  ALine: ILonLatPolygon;
  AName, ADesc: string;
  ATemplate: IMarkTemplatePoly
): IMarkPoly;
var
  VTemplate: IMarkTemplatePoly;
  VTemplateSML: IMarkTemplateSMLInternal;
  VName: string;
  VCategory: ICategory;
  VCategoryID: Integer;
begin
  VTemplate := ATemplate;
  if VTemplate = nil then begin
    VTemplate := FConfig.PolyTemplateConfig.TemplateDefault;
  end;

  VName := AName;
  if VName = '' then begin
    VName := VTemplate.GetNewName;
  end;

  VCategoryID := -1;
  if Supports(VTemplate, IMarkTemplateSMLInternal, VTemplateSML) then begin
    VCategoryID := VTemplateSML.CategoryId;
  end;

  Result := CreatePoly(
    -1,
    VName,
    True,
    VCategoryId,
    VCategory,
    ADesc,
    ALine.Bounds,
    ALine,
    VTemplate.BorderColor,
    VTemplate.FillColor,
    VTemplate.LineWidth
  );
end;

function TMarkFactory.CreatePoint(
  AID: Integer;
  AName: string;
  AVisible: Boolean;
  APicName: string;
  APic: IMarkPicture;
  ACategoryId: Integer;
  ACategory: ICategory;
  ADesc: string;
  APoint: TDoublePoint;
  ATextColor, ATextBgColor: TColor32;
  AFontSize, AMarkerSize: Integer
): IMarkPoint;
var
  VPicIndex: Integer;
  VPic: IMarkPicture;
  VPicName: string;
  VCategory: ICategory;
begin
  VPic := APic;
  if VPic = nil then begin
    VPicName := APicName;
    VPicIndex := FMarkPictureList.GetIndexByName(APicName);
    if VPicIndex < 0 then begin
      VPic := nil;
    end else begin
      VPic := FMarkPictureList.Get(VPicIndex);
    end;
  end else begin
    VPicName := VPic.GetName;
  end;

  VCategory := ACategory;
  if VCategory = nil then begin
    VCategory := FCategoryDB.GetCategoryByID(ACategoryId);
  end;

  Result := TMarkPoint.Create(
    FHintConverter,
    FDbCode,
    AName,
    AID,
    AVisible,
    VPicName,
    VPic,
    VCategory,
    ADesc,
    APoint,
    ATextColor,
    ATextBgColor,
    AFontSize,
    AMarkerSize
  );
end;

function TMarkFactory.CreateLine(
  AID: Integer;
  AName: string;
  AVisible: Boolean;
  ACategoryId: Integer;
  ACategory: ICategory;
  ADesc: string;
  ARect: TDoubleRect;
  ALine: ILonLatPath;
  ALineColor: TColor32;
  ALineWidth: Integer
): IMarkLine;
var
  VCategory: ICategory;
begin
  VCategory := ACategory;
  if VCategory = nil then begin
    VCategory := FCategoryDB.GetCategoryByID(ACategoryId);
  end;

  Result := TMarkLine.Create(
    FHintConverter,
    FDbCode,
    AName,
    AId,
    AVisible,
    VCategory,
    ADesc,
    ARect,
    ALine,
    ALineColor,
    ALineWidth
  );
end;

function TMarkFactory.CreatePoly(
  AID: Integer;
  AName: string;
  AVisible: Boolean;
  ACategoryId: Integer;
  ACategory: ICategory;
  ADesc: string;
  ARect: TDoubleRect;
  ALine: ILonLatPolygon;
  ABorderColor, AFillColor: TColor32;
  ALineWidth: Integer
): IMarkPoly;
var
  VCategory: ICategory;
begin
  VCategory := ACategory;
  if VCategory = nil then begin
    VCategory := FCategoryDB.GetCategoryByID(ACategoryId);
  end;

  Result := TMarkPoly.Create(
    FHintConverter,
    FDbCode,
    AName,
    AID,
    AVisible,
    VCategory,
    ADesc,
    ARect,
    ALine,
    ABorderColor,
    AFillColor,
    ALineWidth
  );
end;

function TMarkFactory.CreateMark(
  AID: Integer;
  AName: string;
  AVisible: Boolean;
  APicName: string;
  ACategoryId: Integer;
  ADesc: string;
  ARect: TDoubleRect;
  APoints: TArrayOfDoublePoint;
  AColor1, AColor2: TColor32;
  AScale1, AScale2: Integer
): IMark;
var
  VPointCount: Integer;
  VPolygon: ILonLatPolygon;
  VPath: ILonLatPath;
begin
  VPointCount := Length(APoints);
  if VPointCount > 0 then begin
    if VPointCount = 1 then begin
      Result := CreatePoint(AId, AName, AVisible, APicName, nil, ACategoryId, nil, ADesc, APoints[0], AColor1, AColor2, AScale1, AScale2)
    end else begin
      if DoublePointsEqual(APoints[0], APoints[VPointCount - 1]) then begin
        VPolygon := FFactory.CreateLonLatPolygon(@APoints[0], VPointCount);
        Result := CreatePoly(AId, AName, AVisible, ACategoryId, nil, ADesc, VPolygon.Bounds, VPolygon, AColor1, AColor2, AScale1);
      end else begin
        VPath := FFactory.CreateLonLatPath(@APoints[0], VPointCount);
        Result := CreateLine(AId, AName, AVisible, ACategoryId, nil, ADesc, VPath.Bounds, VPath, AColor1, AScale1);
      end;
    end;
  end;
end;

function TMarkFactory.CreateMarkId(
  AName: string;
  AId: Integer;
  ACategoryId: Integer;
  AVisible: Boolean
): IMarkID;
var
  VCategory: ICategory;
begin
  VCategory := FCategoryDB.GetCategoryByID(ACategoryId);
  Result := TMarkId.Create(FDbCode, AName, AId, VCategory, AVisible);
end;

function TMarkFactory.SimpleModifyLine(
  ASource: IMarkLine;
  ALine: ILonLatPath;
  ADesc: string
): IMarkLine;
var
  VId: Integer;
  VCategoryId: Integer;
  VDesc: string;
  VVisible: Boolean;
  VMarkInternal: IMarkSMLInternal;
begin
  VVisible := True;
  VId := -1;
  VCategoryId := -1;
  if Supports(ASource, IMarkSMLInternal, VMarkInternal) then begin
    VVisible := VMarkInternal.Visible;
    VId := VMarkInternal.Id;
    VCategoryId := VMarkInternal.CategoryId;
  end;
  VDesc := ADesc;
  if ADesc = '' then begin
    VDesc := ASource.Desc;
  end;

  Result := CreateLine(
    VId,
    ASource.Name,
    VVisible,
    VCategoryId,
    ASource.Category,
    VDesc,
    ALine.Bounds,
    ALine,
    ASource.LineColor,
    ASource.LineWidth
  );
end;

function TMarkFactory.SimpleModifyPoly(
  ASource: IMarkPoly;
  ALine: ILonLatPolygon
): IMarkPoly;
var
  VVisible: Boolean;
  VId: Integer;
  VCategoryId: Integer;
  VMarkInternal: IMarkSMLInternal;
begin
  VVisible := True;
  VId := -1;
  VCategoryId := -1;
  if Supports(ASource, IMarkSMLInternal, VMarkInternal) then begin
    VVisible := VMarkInternal.Visible;
    VId := VMarkInternal.Id;
    VCategoryId := VMarkInternal.CategoryId;
  end;

  Result := CreatePoly(
    VId,
    ASource.Name,
    VVisible,
    VCategoryId,
    ASource.Category,
    ASource.Desc,
    ALine.Bounds,
    ALine,
    ASource.BorderColor,
    ASource.FillColor,
    ASource.LineWidth
  );
end;

function TMarkFactory.ModifyPoint(
  ASource: IMarkPoint;
  AName: string;
  AVisible: Boolean;
  APic: IMarkPicture;
  ACategory: ICategory;
  ADesc: string;
  APoint: TDoublePoint;
  ATextColor: TColor32;
  ATextBgColor: TColor32;
  AFontSize: Integer;
  AMarkerSize: Integer
): IMarkPoint;
var
  VID: Integer;
  VCategoryId: Integer;
  VPicName: string;
  VCategoryInternal: IMarkCategorySMLInternal;
  VMarkInternal: IMarkSMLInternal;
  VMarkPointInternal: IMarkPointSMLInternal;
begin
  VID := -1;
  if ASource <> nil then begin
    if Supports(ASource, IMarkSMLInternal, VMarkInternal) then begin
      VID := VMarkInternal.Id;
    end;
    if Supports(ASource, IMarkPointSMLInternal, VMarkPointInternal) then begin
      VPicName := VMarkPointInternal.PicName;
    end;
  end;
  VCategoryId := -1;
  if ACategory <> nil then begin
    if Supports(ACategory, IMarkCategorySMLInternal, VCategoryInternal) then begin
      VCategoryId := VCategoryInternal.Id;
    end;
  end;

  Result := CreatePoint(
    VID,
    AName,
    AVisible,
    VPicName,
    APic,
    VCategoryId,
    ACategory,
    ADesc,
    APoint,
    ATextColor,
    ATextBgColor,
    AFontSize,
    AMarkerSize
  );
end;

function TMarkFactory.ModifyLine(
  ASource: IMarkLine;
  AName: string;
  AVisible: Boolean;
  ACategory: ICategory;
  ADesc: string;
  ALine: ILonLatPath;
  ALineColor: TColor32;
  ALineWidth: Integer
): IMarkLine;
var
  VID: Integer;
  VCategoryId: Integer;
  VCategoryInternal: IMarkCategorySMLInternal;
  VMarkInternal: IMarkSMLInternal;
begin
  VID := -1;
  if ASource <> nil then begin
    if Supports(ASource, IMarkSMLInternal, VMarkInternal) then begin
      VID := VMarkInternal.Id;
    end;
  end;
  VCategoryId := -1;
  if ACategory <> nil then begin
    if Supports(ACategory, IMarkCategorySMLInternal, VCategoryInternal) then begin
      VCategoryId := VCategoryInternal.Id;
    end;
  end;

  Result := CreateLine(
    VId,
    AName,
    AVisible,
    VCategoryId,
    ACategory,
    ADesc,
    ALine.Bounds,
    ALine,
    ALineColor,
    ALineWidth
  );
end;

function TMarkFactory.ModifyPoly(
  ASource: IMarkPoly;
  AName: string;
  AVisible: Boolean;
  ACategory: ICategory;
  ADesc: string;
  ALine: ILonLatPolygon;
  ABorderColor: TColor32;
  AFillColor: TColor32;
  ALineWidth: Integer
): IMarkPoly;
var
  VID: Integer;
  VCategoryId: Integer;
  VCategoryInternal: IMarkCategorySMLInternal;
  VMarkInternal: IMarkSMLInternal;
begin
  VID := -1;
  if ASource <> nil then begin
    if Supports(ASource, IMarkSMLInternal, VMarkInternal) then begin
      VID := VMarkInternal.Id;
    end;
  end;
  VCategoryId := -1;
  if ACategory <> nil then begin
    if Supports(ACategory, IMarkCategorySMLInternal, VCategoryInternal) then begin
      VCategoryId := VCategoryInternal.Id;
    end;
  end;

  Result := CreatePoly(
    VID,
    AName,
    AVisible,
    VCategoryId,
    ACategory,
    ADesc,
    ALine.Bounds,
    ALine,
    ABorderColor,
    AFillColor,
    ALineWidth
  );
end;

function TMarkFactory.GetConfig: IMarksFactoryConfig;
begin
  Result := FConfig;
end;

function TMarkFactory.GetMarkPictureList: IMarkPictureList;
begin
  Result := FMarkPictureList;
end;

end.
