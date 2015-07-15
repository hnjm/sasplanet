{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2015, SAS.Planet development team.                      *}
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

unit u_MarkDbImplORM;

interface

uses
  Windows,
  SysUtils,
  mORMot,
  SynCommons,
  t_MarkSystemORM,
  t_GeoTypes,
  i_GeometryLonLat,
  i_GeometryToStream,
  i_GeometryFromStream,
  i_VectorItemSubsetBuilder,
  i_InterfaceListStatic,
  i_InterfaceListSimple,
  i_Category,
  i_VectorDataItemSimple,
  i_MarkId,
  i_VectorItemSubset,
  i_MarkCategoryList,
  i_MarkDbImpl,
  i_MarkDbInternalORM,
  i_MarkCategoryInternalORM,
  i_MarkFactoryDbInternalORM,
  u_MarkDbImplORMCache,
  u_ConfigDataElementBase;

type
  TMarkDbImplORM = class(
    TConfigDataElementBaseEmptySaveLoad,
    IMarkDbInternalORM,
    IMarkDbImpl
  )
  private
    FDbId: Integer;
    FUserID: TID;
    FClient: TSQLRestClient;
    FCache: TSQLMarkDbCache;
    FFactoryDbInternal: IMarkFactoryDbInternalORM;
    FGeometryReader: IGeometryFromStream;
    FGeometryWriter: IGeometryToStream;
    FVectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory;
  private
    function _GetMarkSQL(
      const ID: TID = 0;
      const AName: string = '';
      const ACategoryID: TID = 0
    ): IVectorDataItem;

    procedure _SQLMarkRecFromMark(
      const AMark: IVectorDataItem;
      out AMarkRec: TSQLMarkRec
    );

    function _GetMarkIdList(
      const ACategoryId: TID = 0
    ): IInterfaceListStatic;

    procedure _GetMarkSubset(
      const ACategoryID: TID;
      const AIncludeHiddenMarks: Boolean;
      const AResultList: IVectorItemSubsetBuilder
    );

    procedure _GetMarkSubsetByRect(
      const ACategoryIDArray: TIDDynArray;
      const ARect: TDoubleRect;
      const AIncludeHiddenMarks: Boolean;
      const ALonLatSize: TDoublePoint;
      const AResultList: IVectorItemSubsetBuilder
    );

    function _UpdateMark(
      const AOldMark: IInterface;
      const ANewMark: IInterface;
      out AIsChanged: Boolean
    ): IVectorDataItem;

    function _GetCategoryID(const ACategory: ICategory): TID;
  private
    { IMarkDbInternalORM }
    function GetById(const AId: TID): IVectorDataItem;
  private
    { IMarkDbImpl }
    function UpdateMark(
      const AOldMark: IVectorDataItem;
      const ANewMark: IVectorDataItem
    ): IVectorDataItem;

    function UpdateMarkList(
      const AOldMarkList: IInterfaceListStatic;
      const ANewMarkList: IInterfaceListStatic
    ): IInterfaceListStatic;

    function GetMarkByID(const AMarkId: IMarkId): IVectorDataItem;

    function GetMarkByName(
      const AName: string;
      const ACategory: ICategory
    ): IVectorDataItem;

    procedure SetMarkVisibleByID(
      const AMark: IMarkId;
      AVisible: Boolean
    );

    procedure SetMarkVisible(
      const AMark: IVectorDataItem;
      AVisible: Boolean
    );

    procedure SetMarkVisibleByIDList(
      const AMarkList: IInterfaceListStatic;
      AVisible: Boolean
    );

    procedure ToggleMarkVisibleByIDList(
      const AMarkList: IInterfaceListStatic
    );

    function GetMarkVisibleByID(const AMark: IMarkId): Boolean;

    function GetMarkVisible(const AMark: IVectorDataItem): Boolean;

    function GetAllMarkIdList: IInterfaceListStatic;

    function GetMarkIdListByCategory(const ACategory: ICategory): IInterfaceListStatic;

    procedure SetAllMarksInCategoryVisible(
      const ACategory: ICategory;
      ANewVisible: Boolean
    );

    function GetMarkSubsetByCategoryList(
      const ACategoryList: IMarkCategoryList;
      const AIncludeHiddenMarks: Boolean
    ): IVectorItemSubset;

    function GetMarkSubsetByCategory(
      const ACategory: ICategory;
      const AIncludeHiddenMarks: Boolean
    ): IVectorItemSubset;

    function GetMarkSubsetByCategoryListInRect(
      const ARect: TDoubleRect;
      const ACategoryList: IMarkCategoryList;
      const AIncludeHiddenMarks: Boolean;
      const ALonLatSize: TDoublePoint
    ): IVectorItemSubset;

    function GetMarkSubsetByCategoryInRect(
      const ARect: TDoubleRect;
      const ACategory: ICategory;
      const AIncludeHiddenMarks: Boolean;
      const ALonLatSize: TDoublePoint
    ): IVectorItemSubset;

    function FindMarks(
      const ASearch: string;
      const AMaxCount: Integer;
      const AIncludeHiddenMarks: Boolean;
      const ASearchInDescription: Boolean
    ): IVectorItemSubset;
  public
    constructor Create(
      const ADbId: Integer;
      const AUserID: TID;
      const AClient: TSQLRestClient;
      const AFactoryDbInternal: IMarkFactoryDbInternalORM;
      const AGeometryReader: IGeometryFromStream;
      const AGeometryWriter: IGeometryToStream;
      const AVectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory
    );
    destructor Destroy; override;
  end;

implementation

uses
  t_Bitmap32,
  i_AppearanceOfVectorItem,
  u_InterfaceListSimple,
  u_MarkSystemORMTools,
  u_MarkSystemORMModel,
  u_MarkDbImplORMHelper;

constructor TMarkDbImplORM.Create(
  const ADbId: Integer;
  const AUserID: TID;
  const AClient: TSQLRestClient;
  const AFactoryDbInternal: IMarkFactoryDbInternalORM;
  const AGeometryReader: IGeometryFromStream;
  const AGeometryWriter: IGeometryToStream;
  const AVectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory
);
begin
  Assert(ADbId <> 0);
  Assert(AUserID > 0);
  Assert(Assigned(AClient));
  Assert(Assigned(AGeometryReader));
  Assert(Assigned(AGeometryWriter));

  inherited Create;

  FDbId := ADbId;
  FUserID := AUserID;
  FClient := AClient;
  FFactoryDbInternal := AFactoryDbInternal;
  FGeometryReader := AGeometryReader;
  FGeometryWriter := AGeometryWriter;
  FVectorItemSubsetBuilderFactory := AVectorItemSubsetBuilderFactory;

  FCache.Init;
end;

destructor TMarkDbImplORM.Destroy;
begin
  FCache.Done;
  FFactoryDbInternal := nil;
  inherited;
end;

function TMarkDbImplORM._GetCategoryID(const ACategory: ICategory): TID;
var
  VCategoryInternal: IMarkCategoryInternalORM;
begin
  Assert(ACategory <> nil);
  Result := 0;
  if Supports(ACategory, IMarkCategoryInternalORM, VCategoryInternal) then begin
    Result := VCategoryInternal.Id;
  end;
end;

// =============================================================================

// Get single Mark by ID/Name

function TMarkDbImplORM._GetMarkSQL(
  const ID: TID;
  const AName: string;
  const ACategoryID: TID
): IVectorDataItem;
var
  VMarkRec: TSQLMarkRec;
begin
  if ReadMarkSQL(VMarkRec, FUserID, ID, ACategoryID, AName, FClient, FCache, FGeometryReader) then begin
    Result := FFactoryDbInternal.CreateMark(VMarkRec);
  end else begin
    Result := nil;
  end;
end;

function TMarkDbImplORM.GetById(const AId: TID): IVectorDataItem;
begin
  Result := nil;
  if AId > 0 then begin
    LockRead;
    try
      Result := _GetMarkSQL(AId);
    finally
      UnlockRead;
    end;
  end;
end;

function TMarkDbImplORM.GetMarkByID(const AMarkId: IMarkId): IVectorDataItem;
var
  VId: TID;
  VMarkInternal: IMarkInternalORM;
begin
  Result := nil;
  if AMarkId <> nil then begin
    VId := 0;
    if Supports(AMarkId, IMarkInternalORM, VMarkInternal) then begin
      VId := VMarkInternal.Id;
    end;
    if VId > 0 then begin
      LockRead;
      try
        Result := _GetMarkSQL(VId);
      finally
        UnlockRead;
      end;
    end;
  end;
end;

function TMarkDbImplORM.GetMarkByName(
  const AName: string;
  const ACategory: ICategory
): IVectorDataItem;
var
  VCategory: IMarkCategoryInternalORM;
begin
  Result := nil;

  if not Supports(ACategory, IMarkCategoryInternalORM, VCategory) then begin
    VCategory := nil;
  end;

  if VCategory <> nil then begin
    if (VCategory.DbId <> FDbId) or (VCategory.Id = 0) then begin
      VCategory := nil;
    end;
  end;

  LockRead;
  try
    if VCategory <> nil then begin
      Result := _GetMarkSQL(0, AName, VCategory.Id);
    end else begin
      Result := _GetMarkSQL(0, AName, 0);
    end;
  finally
    UnlockRead;
  end;
end;

// =============================================================================

// INSERT/DELETE/UPDATE Marks

procedure TMarkDbImplORM._SQLMarkRecFromMark(
  const AMark: IVectorDataItem;
  out AMarkRec: TSQLMarkRec
);
var
  VPoint: IGeometryLonLatPoint;
  VLine: IGeometryLonLatLine;
  VPoly: IGeometryLonLatPolygon;
  VMarkInternalORM: IMarkInternalORM;
  VAppearanceIcon: IAppearancePointIcon;
  VAppearanceCaption: IAppearancePointCaption;
  VAppearanceLine: IAppearanceLine;
  VAppearanceBorder: IAppearancePolygonBorder;
  VAppearanceFill: IAppearancePolygonFill;
  VTextColor: TColor32;
  VTextBgColor: TColor32;
  VFontSize: Integer;
  VMarkerSize: Integer;
  VLineColor: TColor32;
  VLineWidth: Integer;
  VFillColor: TColor32;
  VMarkWithCategory: IVectorDataItemWithCategory;
  VCategory: IMarkCategoryInternalORM;
begin
  Assert(Assigned(AMark));

  AMarkRec := cEmptySQLMarkRec;

  if Supports(AMark.MainInfo, IMarkInternalORM, VMarkInternalORM) then begin
    AMarkRec.FMarkId := VMarkInternalORM.Id;
    AMarkRec.FCategoryId := VMarkInternalORM.CategoryId;
    AMarkRec.FVisible := VMarkInternalORM.Visible;
  end else begin
    if Supports(AMark.MainInfo, IVectorDataItemWithCategory, VMarkWithCategory) then begin
      if Supports(VMarkWithCategory.Category, IMarkCategoryInternalORM, VCategory) then begin
        AMarkRec.FCategoryId := VCategory.Id;
      end;
    end;
  end;

  if AMarkRec.FCategoryId = 0 then begin
    Assert(False);
    Exit;
  end;

  if not Assigned(AMark.Geometry.Bounds) then begin
    Assert(False);
    Exit;
  end;

  AMarkRec.FName := AMark.Name;
  AMarkRec.FDesc := AMark.Desc;
  AMarkRec.FGeometry := AMark.Geometry;

  if Supports(AMark.Geometry, IGeometryLonLatPoint, VPoint) then begin
    VTextColor := 0;
    VTextBgColor := 0;
    VFontSize := 0;
    VMarkerSize := 0;

    if Supports(AMark.Appearance, IAppearancePointCaption, VAppearanceCaption) then begin
      VTextColor := VAppearanceCaption.TextColor;
      VTextBgColor := VAppearanceCaption.TextBgColor;
      VFontSize := VAppearanceCaption.FontSize;
    end;

    if Supports(AMark.Appearance, IAppearancePointIcon, VAppearanceIcon) then begin
      VMarkerSize := VAppearanceIcon.MarkerSize;
      AMarkRec.FPicName := VAppearanceIcon.PicName;
    end;

    AMarkRec.FColor1 := VTextColor;
    AMarkRec.FColor2 := VTextBgColor;
    AMarkRec.FScale1 := VFontSize;
    AMarkRec.FScale2 := VMarkerSize;

    AMarkRec.FGeoType := gtPoint;
    AMarkRec.FGeoCount := 1;

  end else if Supports(AMark.Geometry, IGeometryLonLatLine, VLine) then begin
    VLineColor := 0;
    VLineWidth := 0;

    if Supports(AMark.Appearance, IAppearanceLine, VAppearanceLine) then begin
      VLineColor := VAppearanceLine.LineColor;
      VLineWidth := VAppearanceLine.LineWidth;
    end;

    AMarkRec.FColor1 := VLineColor;
    AMarkRec.FColor2 := 0;
    AMarkRec.FScale1 := VLineWidth;
    AMarkRec.FScale2 := 0;

    AMarkRec.FGeoType := gtLine;
    AMarkRec.FGeoCount := CalcMultiGeometryCount(VLine);

  end else if Supports(AMark.Geometry, IGeometryLonLatPolygon, VPoly) then begin
    VLineColor := 0;
    VLineWidth := 0;
    VFillColor := 0;

    if Supports(AMark.Appearance, IAppearancePolygonBorder, VAppearanceBorder) then begin
      VLineColor := VAppearanceBorder.LineColor;
      VLineWidth := VAppearanceBorder.LineWidth;
    end;

    if Supports(AMark.Appearance, IAppearancePolygonFill, VAppearanceFill) then begin
      VFillColor := VAppearanceFill.FillColor;
    end;

    AMarkRec.FColor1 := VLineColor;
    AMarkRec.FColor2 := VFillColor;
    AMarkRec.FScale1 := VLineWidth;
    AMarkRec.FScale2 := 0;

    AMarkRec.FGeoType := gtPoly;
    AMarkRec.FGeoCount := CalcMultiGeometryCount(VPoly);
  end else begin
    raise EMarkSystemORMError.Create('MarkSystemORM: Unknown geometry type!');
  end;
end;

function TMarkDbImplORM._UpdateMark(
  const AOldMark: IInterface;
  const ANewMark: IInterface;
  out AIsChanged: Boolean
): IVectorDataItem;
var
  VIdOld: TID;
  VMarkInternal: IMarkInternalORM;
  VOldMark: IVectorDataItem;
  VNewMark: IVectorDataItem;
  VSQLMarkRecNew: TSQLMarkRec;
  VSQLMarkRecOld: TSQLMarkRec;
begin
  Result := nil;
  AIsChanged := False;

  VIdOld := 0;

  if Supports(AOldMark, IMarkInternalORM, VMarkInternal) then begin
    if VMarkInternal.DbId = FDbId then begin
      VIdOld := VMarkInternal.Id;
    end else begin
      Assert(False);
      Exit;
    end;
  end else if Supports(AOldMark, IVectorDataItem, VOldMark) then begin
    if Supports(VOldMark.MainInfo, IMarkInternalORM, VMarkInternal) then begin
      if VMarkInternal.DbId = FDbId then begin
        VIdOld := VMarkInternal.Id;
      end else begin
        Assert(False);
        Exit;
      end;
    end;
  end else begin
    Assert(not Assigned(AOldMark));
    if Assigned(AOldMark) then begin
      Exit;
    end;
  end;

  if Supports(ANewMark, IVectorDataItem, VNewMark) then begin
    VNewMark := FFactoryDbInternal.CreateInternalMark(VNewMark);
    Assert(Assigned(VNewMark));
    if not Assigned(VNewMark) then begin
      Exit;
    end;
  end else begin
    Assert(not Assigned(ANewMark));
    if Assigned(ANewMark) then begin
      Exit;
    end;
    VNewMark := nil;
  end;

  VOldMark := nil;
  if VIdOld > 0 then begin
    VOldMark := _GetMarkSQL(VIdOld);
    if (VOldMark <> nil) and (VNewMark <> nil) then begin
      if VOldMark.IsEqual(VNewMark) then begin
        Result := VOldMark;
        Exit;
      end;
    end;
  end;

  if VOldMark <> nil then begin
    if VNewMark <> nil then begin
      // UPDATE
      _SQLMarkRecFromMark(VOldMark, VSQLMarkRecOld);
      _SQLMarkRecFromMark(VNewMark, VSQLMarkRecNew);
      UpdateMarkSQL(VSQLMarkRecOld, VSQLMarkRecNew, FUserID, FClient, FCache, FGeometryWriter);
      Result := FFactoryDbInternal.CreateMark(VSQLMarkRecNew);
      AIsChanged := True;
    end else begin
      // DELETE
      DeleteMarkSQL(VIdOld, FClient, FCache);
      AIsChanged := True;
    end;
  end else begin
    // INSERT
    if VNewMark <> nil then begin
      _SQLMarkRecFromMark(VNewMark, VSQLMarkRecNew);
      InsertMarkSQL(VSQLMarkRecNew, FUserID, FClient, FCache, FGeometryWriter);
      Result := FFactoryDbInternal.CreateMark(VSQLMarkRecNew);
      AIsChanged := True;
    end;
  end;
end;

function TMarkDbImplORM.UpdateMark(
  const AOldMark: IVectorDataItem;
  const ANewMark: IVectorDataItem
): IVectorDataItem;
var
  VIsChanged: Boolean;
begin
  Assert((AOldMark <> nil) or (ANewMark <> nil));

  LockWrite;
  try
    Result := _UpdateMark(AOldMark, ANewMark, VIsChanged);
    if VIsChanged then begin
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

function TMarkDbImplORM.UpdateMarkList(
  const AOldMarkList, ANewMarkList: IInterfaceListStatic
): IInterfaceListStatic;
var
  I: Integer;
  VNew: IInterface;
  VOld: IInterface;
  VResult: IVectorDataItem;
  VMinCount: Integer;
  VMaxCount: Integer;
  VTemp: IInterfaceListSimple;
  VIsChanged: Boolean;
  VDoNotify: Boolean;
  VTransaction: TTransactionRec;
begin
  Result := nil;
  VDoNotify := False;

  if ANewMarkList <> nil then begin
    VTemp := TInterfaceListSimple.Create;
    VTemp.Capacity := ANewMarkList.Count;

    LockWrite;
    try
      StartTransaction(FClient, VTransaction, TSQLMark);
      try
        if (AOldMarkList <> nil) then begin
          if AOldMarkList.Count < ANewMarkList.Count then begin
            VMinCount := AOldMarkList.Count;
            VMaxCount := ANewMarkList.Count;
          end else begin
            VMinCount := ANewMarkList.Count;
            VMaxCount := AOldMarkList.Count;
          end;
        end else begin
          VMinCount := 0;
          VMaxCount := ANewMarkList.Count;
        end;
        for I := 0 to VMinCount - 1 do begin
          VOld := AOldMarkList[I];
          VNew := ANewMarkList[I];
          VResult := _UpdateMark(VOld, VNew, VIsChanged);
          VDoNotify := VDoNotify or VIsChanged;
          VTemp.Add(VResult);
        end;
        for I := VMinCount to VMaxCount - 1 do begin
          VOld := nil;
          if (AOldMarkList <> nil) and (I < AOldMarkList.Count) then begin
            VOld := AOldMarkList[I];
          end;
          VNew := nil;
          if (I < ANewMarkList.Count) then begin
            VNew := ANewMarkList[I];
          end;
          VResult := _UpdateMark(VOld, VNew, VIsChanged);
          VDoNotify := VDoNotify or VIsChanged;
          if I < VTemp.Capacity then begin
            VTemp.Add(VResult);
          end;
        end;
        CommitTransaction(FClient, VTransaction);
      except
        RollBackTransaction(FClient, VTransaction);
        raise;
      end;

      if VDoNotify then begin
        SetChanged;
      end;
    finally
      UnlockWrite;
    end;
    Result := VTemp.MakeStaticAndClear;
  end else begin
    LockWrite;
    try
      StartTransaction(FClient, VTransaction, TSQLMark);
      try
        for I := 0 to AOldMarkList.Count - 1 do begin
          _UpdateMark(AOldMarkList[I], nil, VIsChanged);
          VDoNotify := VDoNotify or VIsChanged;
        end;
        CommitTransaction(FClient, VTransaction);
      except
        RollBackTransaction(FClient, VTransaction);
        raise;
      end;
      if VDoNotify then begin
        SetChanged;
      end;
    finally
      UnlockWrite;
    end;
  end;
end;

// =============================================================================

// Get Lite MarkId list by Categories

function TMarkDbImplORM._GetMarkIdList(
  const ACategoryId: TID
): IInterfaceListStatic;
var
  I: Integer;
  VCount: Integer;
  VMarkId: IMarkId;
  VTemp: IInterfaceListSimple;
  VArray: TSQLMarkRecDynArray;
begin
  VTemp := TInterfaceListSimple.Create;
  LockWrite;
  try
    VCount :=
      GetMarkRecArray(
        FUserID,
        ACategoryId,
        FClient,
        FGeometryReader,
        FCache,
        True, // include hidden marks
        False, // without geometry
        VArray
      );
  finally
    UnlockWrite;
  end;
  if VCount > 0 then begin
    VTemp.Capacity := VCount;
    LockRead;
    try
      for I := 0 to VCount - 1 do begin
        VMarkId := FFactoryDbInternal.CreateMarkId(VArray[I]);
        VTemp.Add(VMarkId);
      end;
    finally
      UnlockRead;
    end;
  end;
  Result := VTemp.MakeStaticAndClear;
end;

function TMarkDbImplORM.GetAllMarkIdList: IInterfaceListStatic;
begin
  Result := _GetMarkIdList;
end;

function TMarkDbImplORM.GetMarkIdListByCategory(const ACategory: ICategory): IInterfaceListStatic;
var
  VCategoryId: TID;
begin
  Result := nil;
  VCategoryId := _GetCategoryID(ACategory);
  if VCategoryId > 0 then begin
    Result := _GetMarkIdList(VCategoryId);
  end;
end;

// =============================================================================

// Get Full Marks list by Categories

procedure TMarkDbImplORM._GetMarkSubset(
  const ACategoryID: TID;
  const AIncludeHiddenMarks: Boolean;
  const AResultList: IVectorItemSubsetBuilder
);
var
  I: Integer;
  VCount: Integer;
  VItem: IVectorDataItem;
  VArray: TSQLMarkRecDynArray;
begin
  LockWrite;
  try
    VCount :=
      GetMarkRecArray(
        FUserID,
        ACategoryId,
        FClient,
        FGeometryReader,
        FCache,
        AIncludeHiddenMarks,
        True, // read geometry
        VArray
      );
  finally
    UnlockWrite;
  end;
  if VCount > 0 then begin
    AResultList.Capacity := VCount;
    LockRead;
    try
      for I := 0 to VCount - 1 do begin
        VItem := FFactoryDbInternal.CreateMark(VArray[I]);
        AResultList.Add(VItem);
      end;
    finally
      UnlockRead;
    end;
  end;
end;

function TMarkDbImplORM.GetMarkSubsetByCategory(
  const ACategory: ICategory;
  const AIncludeHiddenMarks: Boolean
): IVectorItemSubset;
var
  VCategoryId: TID;
  VResultList: IVectorItemSubsetBuilder;
begin
  VResultList := FVectorItemSubsetBuilderFactory.Build;
  if ACategory <> nil then begin
    VCategoryId := _GetCategoryID(ACategory);
  end else begin
    VCategoryId := 0;
  end;
  _GetMarkSubset(VCategoryId, AIncludeHiddenMarks, VResultList);
  Result := VResultList.MakeStaticAndClear;
end;

function TMarkDbImplORM.GetMarkSubsetByCategoryList(
  const ACategoryList: IMarkCategoryList;
  const AIncludeHiddenMarks: Boolean
): IVectorItemSubset;
var
  I: Integer;
  VCategoryID: TID;
  VResultList: IVectorItemSubsetBuilder;
begin
  VResultList := FVectorItemSubsetBuilderFactory.Build;
  if (ACategoryList = nil) then begin
    _GetMarkSubset(0, AIncludeHiddenMarks, VResultList);
  end else begin
    for I := 0 to ACategoryList.Count - 1 do begin
      VCategoryID := _GetCategoryID(ICategory(ACategoryList[I]));
      _GetMarkSubset(VCategoryId, AIncludeHiddenMarks, VResultList);
    end;
  end;
  Result := VResultList.MakeStaticAndClear;
end;

// =============================================================================

// Get Marks list by Rect

procedure TMarkDbImplORM._GetMarkSubsetByRect(
  const ACategoryIDArray: TIDDynArray;
  const ARect: TDoubleRect;
  const AIncludeHiddenMarks: Boolean;
  const ALonLatSize: TDoublePoint;
  const AResultList: IVectorItemSubsetBuilder
);
var
  VItem: IVectorDataItem;
  VMarkInternal: IMarkInternalORM;
  VLen: Integer;
  VMarkId: TID;
  VCategoryId: TID;
  VCategoris: TDynArray;
  VCategoryIDArray: TIDDynArray;
  VSQLSelect: RawUTF8;
  VIDList: TSQLTableJSON;
  VFilterByCategories: Boolean;
  VFilterByOneCategory: Boolean;
  VLonSize, VLatSize: Cardinal;
begin
  VLen := Length(ACategoryIDArray);
  Assert(VLen > 0);

  LonLatSizeToInternalSize(ALonLatSize, VLonSize, VLatSize);

  VFilterByCategories := (VLen > 1);
  VFilterByOneCategory := (VLen = 1) and (ACategoryIDArray[0] > 0);

  if VFilterByOneCategory then begin
    VSQLSelect := FormatUTF8(
      'SELECT Mark.ID FROM Mark, MarkRTree ' +
      'WHERE Mark.RowID = MarkRTree.RowID AND Mark.Category = ? ' +
      'AND Left <= ? AND Right >= ? AND Bottom <= ? AND Top >= ? ' +
      'AND (Mark.GeoType = ? OR Mark.GeoLonSize >= ? OR Mark.GeoLatSize >= ?);',
      [],
      [
        ACategoryIDArray[0],
        ARect.Right, ARect.Left, ARect.Top, ARect.Bottom,
        Integer(gtPoint), VLonSize, VLatSize
      ]
    );
  end else if VFilterByCategories then begin
    VSQLSelect := FormatUTF8(
      'SELECT Mark.ID, Mark.Category FROM Mark, MarkRTree ' +
      'WHERE Mark.RowID = MarkRTree.RowID ' +
      'AND Left <= ? AND Right >= ? AND Bottom <= ? AND Top >= ? ' +
      'AND (Mark.GeoType = ? OR Mark.GeoLonSize >= ? OR Mark.GeoLatSize >= ?);',
      [], [ARect.Right, ARect.Left, ARect.Top, ARect.Bottom, Integer(gtPoint), VLonSize, VLatSize]
    );
  end else begin
    VSQLSelect := FormatUTF8(
      'SELECT Mark.ID FROM Mark, MarkRTree ' +
      'WHERE Mark.RowID = MarkRTree.RowID ' +
      'AND Left <= ? AND Right >= ? AND Bottom <= ? AND Top >= ? ' +
      'AND (Mark.GeoType = ? OR Mark.GeoLonSize >= ? OR Mark.GeoLatSize >= ?);',
      [], [ARect.Right, ARect.Left, ARect.Top, ARect.Bottom, Integer(gtPoint), VLonSize, VLatSize]
    );
  end;

  VIDList := FClient.ExecuteList([TSQLMark, TSQLMarkRTree], VSQLSelect);
  if Assigned(VIDList) then
  try
    if VFilterByCategories then begin
      VCategoris.Init(TypeInfo(TIDDynArray), VCategoryIDArray);
      VCategoris.CopyFrom(ACategoryIDArray, VLen);
      VCategoris.Compare := SortDynArrayInt64;
      VCategoris.Sort;
    end;

    while VIDList.Step do begin
      VMarkId := VIDList.Field(0);

      if VFilterByCategories then begin
        VCategoryId := VIDList.Field(1);
        if VCategoris.Find(VCategoryId) = -1 then begin
          Continue;
        end;
      end;

      if VMarkId > 0 then begin
        VItem := _GetMarkSQL(VMarkId);

        if not Assigned(VItem) then begin
          Continue;
        end;

        if Assigned(VItem.Geometry.Bounds) and VItem.Geometry.Bounds.IsIntersecWithRect(ARect) then begin
          if AIncludeHiddenMarks then begin
            AResultList.Add(VItem);
          end else begin
            if Supports(VItem.MainInfo, IMarkInternalORM, VMarkInternal) then begin
              if VMarkInternal.Visible then begin
                AResultList.Add(VItem);
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    VIDList.Free;
  end;
end;

function TMarkDbImplORM.GetMarkSubsetByCategoryInRect(
  const ARect: TDoubleRect;
  const ACategory: ICategory;
  const AIncludeHiddenMarks: Boolean;
  const ALonLatSize: TDoublePoint
): IVectorItemSubset;
var
  VIdArray: TIDDynArray;
  VResultList: IVectorItemSubsetBuilder;
begin
  VResultList := FVectorItemSubsetBuilderFactory.Build;

  SetLength(VIdArray, 1);
  if ACategory <> nil then begin
    VIdArray[0] := _GetCategoryID(ACategory);
  end else begin
    VIdArray[0] := 0;
  end;

  LockRead;
  try
    _GetMarkSubsetByRect(VIdArray, ARect, AIncludeHiddenMarks, ALonLatSize, VResultList);
  finally
    UnlockRead;
  end;

  Result := VResultList.MakeStaticAndClear;
end;

function TMarkDbImplORM.GetMarkSubsetByCategoryListInRect(
  const ARect: TDoubleRect;
  const ACategoryList: IMarkCategoryList;
  const AIncludeHiddenMarks: Boolean;
  const ALonLatSize: TDoublePoint
): IVectorItemSubset;
var
  I: Integer;
  VIdArray: TIDDynArray;
  VResultList: IVectorItemSubsetBuilder;
begin
  VResultList := FVectorItemSubsetBuilderFactory.Build;

  LockRead;
  try
    if ACategoryList <> nil then begin
      SetLength(VIdArray, ACategoryList.Count);
      for I := 0 to ACategoryList.Count - 1 do begin
        VIdArray[I] := _GetCategoryID(ICategory(ACategoryList[I]));
      end;
    end;
    if Length(VIdArray) = 0 then begin
      SetLength(VIdArray, 1);
      VIdArray[0] := 0;
    end;
    _GetMarkSubsetByRect(VIdArray, ARect, AIncludeHiddenMarks, ALonLatSize, VResultList);
  finally
    UnlockRead;
  end;

  Result := VResultList.MakeStaticAndClear;
end;

// =============================================================================

// Get/Set Visible

function TMarkDbImplORM.GetMarkVisible(const AMark: IVectorDataItem): Boolean;
var
  VMarkVisible: IMarkInternalORM;
begin
  Result := True;
  if AMark <> nil then begin
    if Supports(AMark.MainInfo, IMarkInternalORM, VMarkVisible) then begin
      Result := VMarkVisible.Visible;
    end;
  end;
end;

function TMarkDbImplORM.GetMarkVisibleByID(const AMark: IMarkId): Boolean;
var
  VMarkInternal: IMarkInternalORM;
begin
  Result := True;
  if AMark <> nil then begin
    if Supports(AMark, IMarkInternalORM, VMarkInternal) then begin
      Result := VMarkInternal.Visible;
    end;
  end;
end;

procedure TMarkDbImplORM.SetAllMarksInCategoryVisible(
  const ACategory: ICategory;
  ANewVisible: Boolean
);
var
  VCategoryId: TID;
begin
  VCategoryId := _GetCategoryID(ACategory);
  if VCategoryId > 0 then begin
    LockWrite;
    try
      if SetMarksInCategoryVisibleSQL(FUserID, VCategoryId, ANewVisible, FClient, FCache) then begin
        SetChanged;
      end;
    finally
      UnlockWrite;
    end;
  end;
end;

procedure TMarkDbImplORM.SetMarkVisible(
  const AMark: IVectorDataItem;
  AVisible: Boolean
);
var
  VId: TID;
  VMarkInternal: IMarkInternalORM;
begin
  if AMark <> nil then begin
    VId := 0;
    if Supports(AMark.MainInfo, IMarkInternalORM, VMarkInternal) then begin
      VId := VMarkInternal.Id;
      if VMarkInternal.Visible = AVisible then begin
        Exit;
      end;
      VMarkInternal.Visible := AVisible;
    end;
    if VId > 0 then begin
      LockWrite;
      try
        if SetMarkVisibleSQL(VId, FUserID, AVisible, FClient, FCache, True) then begin
          SetChanged;
        end;
      finally
        UnlockWrite;
      end;
    end;
  end;
end;

procedure TMarkDbImplORM.SetMarkVisibleByID(
  const AMark: IMarkId;
  AVisible: Boolean
);
var
  VId: TID;
  VMarkInternal: IMarkInternalORM;
begin
  if AMark <> nil then begin
    VId := 0;
    if Supports(AMark, IMarkInternalORM, VMarkInternal) then begin
      VId := VMarkInternal.Id;
      if VMarkInternal.Visible = AVisible then begin
        Exit;
      end;
      VMarkInternal.Visible := AVisible;
    end;
    if VId > 0 then begin
      LockWrite;
      try
        if SetMarkVisibleSQL(VId, FUserID, AVisible, FClient, FCache, True) then begin
          SetChanged;
        end;
      finally
        UnlockWrite;
      end;
    end;
  end;
end;

procedure TMarkDbImplORM.SetMarkVisibleByIDList(
  const AMarkList: IInterfaceListStatic;
  AVisible: Boolean
);
var
  I: Integer;
  VId: TID;
  VIsChanged: Boolean;
  VMarkInternal: IMarkInternalORM;
  VTransaction: TTransactionRec;
begin
  if (AMarkList <> nil) and (AMarkList.Count > 0) then begin
    LockWrite;
    try
      StartTransaction(FClient, VTransaction, TSQLMarkView);
      try
        VIsChanged := False;
        for I := 0 to AMarkList.Count - 1 do begin
          VId := 0;
          if Supports(AMarkList.Items[I], IMarkInternalORM, VMarkInternal) then begin
            VId := VMarkInternal.Id;
            if VMarkInternal.Visible = AVisible then begin
              Continue;
            end;
            VMarkInternal.Visible := AVisible;
          end;
          if VId > 0 then begin
            if SetMarkVisibleSQL(VId, FUserID, AVisible, FClient, FCache, False) then begin
              VIsChanged := True;
            end;
          end;
        end;
        CommitTransaction(FClient, VTransaction);
      except
        RollBackTransaction(FClient, VTransaction);
        raise;
      end;

      if VIsChanged then begin
        SetChanged;
      end;
    finally
      UnlockWrite;
    end;
  end;
end;

procedure TMarkDbImplORM.ToggleMarkVisibleByIDList(
  const AMarkList: IInterfaceListStatic
);
var
  I: Integer;
  VMarkInternal: IMarkInternalORM;
  VVisible: Boolean;
  VVisibleCount: Integer;
  VInvisibleCount: Integer;
begin
  if (AMarkList <> nil) and (AMarkList.Count > 0) then begin
    VVisibleCount := 0;
    VInvisibleCount := 0;
    for I := 0 to AMarkList.Count - 1 do begin
      if Supports(AMarkList.Items[I], IMarkInternalORM, VMarkInternal) then begin
        if VMarkInternal.Visible then begin
          Inc(VVisibleCount);
        end else begin
          Inc(VInvisibleCount);
        end;
      end;
    end;
    VVisible := VVisibleCount < VInvisibleCount;
    SetMarkVisibleByIDList(AMarkList, VVisible);
  end;
end;

// =============================================================================

// Text Search

function TMarkDbImplORM.FindMarks(
  const ASearch: string;
  const AMaxCount: Integer;
  const AIncludeHiddenMarks: Boolean;
  const ASearchInDescription: Boolean
): IVectorItemSubset;
var
  I, J: Integer;
  VLen: Integer;
  VLimit: RawUTF8;
  VSearch: RawUTF8;
  VMark: IVectorDataItem;
  VMarkInternal: IMarkInternalORM;
  VSQLWhere: RawUTF8;
  VIDArray: TIDDynArray;
  VNameIDArray: TIDDynArray;
  VDescIDArray: TIDDynArray;
  VSkipDescSearch: Boolean;
  VResultList: IVectorItemSubsetBuilder;
begin
  VResultList := FVectorItemSubsetBuilderFactory.Build;

  LockRead;
  try
    if AMaxCount > 0 then begin
      VLimit := StringToUTF8(' LIMIT ' + IntToStr(AMaxCount));
    end else begin
      VLimit := '';
    end;

    VSearch := StringToUTF8('''' + SysUtils.AnsiLowerCase(ASearch) + '''');

    VSQLWhere := RawUTF8('Name MATCH ') + VSearch + VLimit;
    if FClient.FTSMatch(TSQLMarkFTS, VSQLWhere, VNameIDArray) then begin
      VSkipDescSearch := (AMaxCount > 0) and (Length(VNameIDArray) >= AMaxCount);
    end else begin
      VSkipDescSearch := False;
    end;

    if ASearchInDescription and not VSkipDescSearch then begin
      VSQLWhere := RawUTF8('Desc MATCH ') + VSearch + VLimit;
      FClient.FTSMatch(TSQLMarkFTS, VSQLWhere, VDescIDArray);
    end;

    I := Length(VNameIDArray);
    J := Length(VDescIDArray);

    if (I > 0) and (J > 0) then begin
      VLen := I + J;
      SetLength(VIDArray, VLen);
      Move(VNameIDArray[0], VIDArray[0], I);
      Move(VDescIDArray[0], VIDArray[I], J);
      VLen := MergeSortRemoveDuplicates(VIDArray);
      SetLength(VIDArray, VLen);
    end else if I > 0 then begin
      VIDArray := VNameIDArray;
    end else if J > 0 then begin
      VIDArray := VDescIDArray;
    end;

    if (AMaxCount > 0) and (Length(VIDArray) > AMaxCount) then begin
      SetLength(VIDArray, AMaxCount);
    end;

    for I := Low(VIDArray) to High(VIDArray) do begin
      VMark := _GetMarkSQL(VIDArray[I]);
      if Assigned(VMark) then begin
        if AIncludeHiddenMarks then begin
          VResultList.Add(VMark);
        end else begin
          if Supports(VMark.MainInfo, IMarkInternalORM, VMarkInternal) then begin
            if VMarkInternal.Visible then begin
              VResultList.Add(VMark);
            end;
          end;
        end;
      end;
    end;
  finally
    UnlockRead;
  end;

  Result := VResultList.MakeStaticAndClear;
end;

end.
