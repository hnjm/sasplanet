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

unit u_MarksDb;

interface

uses
  Windows,
  DBClient,
  SysUtils,
  Classes,
  t_GeoTypes,
  i_IDList,
  i_PathConfig,
  i_VectorItmesFactory,
  i_MarksFactoryConfig,
  i_HtmlToHintTextConverter,
  i_MarkCategoryDBSmlInternal,
  i_MarkCategory,
  i_MarksSimple,
  i_MarkFactory,
  i_MarksDb,
  i_MarksDbSmlInternal,
  i_MarkFactorySmlInternal,
  i_ReadWriteStateInternal,
  u_ConfigDataElementBase;

type
  TMarksDb = class(TConfigDataElementBaseEmptySaveLoad, IMarksDb, IMarksDbSmlInternal)
  private
    FBasePath: IPathConfig;
    FStateInternal: IReadWriteStateInternal;

    FStream: TStream;
    FCdsMarks: TClientDataSet;
    FFactoryDbInternal: IMarkFactorySmlInternal;
    FFactory: IMarkFactory;
    FMarksList: IIDInterfaceList;
    FByCategoryList: IIDInterfaceList;

    function ReadCurrentMark: IMark;
    procedure WriteCurrentMarkId(const AMark: IMarkId);
    procedure WriteCurrentMark(const AMark: IMark);

    function GetMarksFileName: string;
    function GetMarksBackUpFileName: string;
    procedure InitEmptyDS(ACdsMarks: TClientDataSet);
    function GetCategoryID(const ACategory: ICategory): Integer;
    function GetFilterTextByCategory(const ACategory: ICategory): string;
    function _UpdateMark(
      const AOldMark: IInterface;
      const ANewMark: IInterface
    ): IMark;
    procedure _AddMarksToList(
      const ASourceList: IIDInterfaceList;
      const ARect: TDoubleRect;
      AIgnoreVisible: Boolean;
      const AResultList: IInterfaceList
    );
  private
    function SaveMarks2File: boolean;
    procedure LoadMarksFromFile;
  private
    function UpdateMark(
      const AOldMark: IInterface;
      const ANewMark: IMark
    ): IMark;
    function UpdateMarksList(
      const AOldMarkList: IInterfaceList;
      const ANewMarkList: IInterfaceList
    ): IInterfaceList;

    function GetMarkByID(const AMarkId: IMarkId): IMark;
    procedure SetMarkVisibleByID(
      const AMark: IMarkId;
      AVisible: Boolean
    );
    function GetMarkVisible(const AMark: IMarkId): Boolean; overload;
    function GetMarkVisible(const AMark: IMark): Boolean; overload;
    function GetFactory: IMarkFactory;
    function GetAllMarskIdList: IInterfaceList;
    function GetMarskIdListByCategory(const ACategory: ICategory): IInterfaceList;

    procedure SetAllMarksInCategoryVisible(
      const ACategory: ICategory;
      ANewVisible: Boolean
    );

    function GetMarksSubset(
      const ARect: TDoubleRect;
      const ACategoryList: IInterfaceList;
      AIgnoreVisible: Boolean
    ): IMarksSubset; overload;
    function GetMarksSubset(
      const ARect: TDoubleRect;
      const ACategory: ICategory;
      AIgnoreVisible: Boolean
    ): IMarksSubset; overload;
  public
    constructor Create(
      const AStateInternal: IReadWriteStateInternal;
      const ABasePath: IPathConfig;
      const ACategoryDB: IMarkCategoryDBSmlInternal;
      const AVectorItmesFactory: IVectorItmesFactory;
      const AHintConverter: IHtmlToHintTextConverter;
      const AFactoryConfig: IMarksFactoryConfig
    );
    destructor Destroy; override;
  end;

implementation

uses
  DB,
  Math,
  GR32,
  t_CommonTypes,
  i_EnumID,
  i_EnumDoublePoint,
  i_MarkCategoryFactoryDbInternal,
  u_IDInterfaceList,
  i_DoublePointsAggregator,
  i_VectorItemLonLat,
  u_DoublePointsAggregator,
  u_MarkFactory,
  u_GeoFun,
  u_MarksSubset;

type
  TExtendedPoint = record
    X, Y: Extended;
  end;


procedure Blob2ExtArr(
  Blobfield: Tfield;
  const AAggregator: IDoublePointsAggregator
);
const
  CMaxDegres: Extended = 360;
  CMinDegres: Extended = -360;
var
  VSize: Integer;
  VPointsCount: Integer;
  VField: TBlobfield;
  VStream: TStream;
  i: Integer;
  VPoint: TExtendedPoint;
  VDoublePoint: TDoublePoint;
begin
  VField := TBlobfield(BlobField);
  VStream := VField.DataSet.CreateBlobStream(VField, bmRead);
  try
    VSize := VStream.Size;
    VPointsCount := VSize div SizeOf(TExtendedPoint);
    for i := 0 to VPointsCount - 1 do begin
      VStream.ReadBuffer(VPoint, SizeOf(TExtendedPoint));
      try
        if IsNan(VPoint.X) or IsNan(VPoint.Y) then begin
          VDoublePoint := CEmptyDoublePoint;
        end else if (VPoint.X >= CMaxDegres) or (VPoint.X <= CMinDegres) or (VPoint.Y >= CMaxDegres) or (VPoint.Y <= CMinDegres) then begin
          VDoublePoint := CEmptyDoublePoint;
        end else begin
          VDoublePoint := DoublePoint(VPoint.X, VPoint.Y);
        end;
      except
        VDoublePoint := CEmptyDoublePoint;
      end;
      AAggregator.Add(VDoublePoint);
    end;
  finally
    VStream.Free;
  end;
end;

procedure BlobFromPoint(
  const APoint: TDoublePoint;
  Blobfield: Tfield
);
var
  VField: TBlobfield;
  VStream: TStream;
  VPoint: TExtendedPoint;
begin
  VField := TBlobfield(BlobField);
  VStream := VField.DataSet.CreateBlobStream(VField, bmWrite);
  try
    VPoint.X := APoint.X;
    VPoint.Y := APoint.Y;
    VStream.Write(VPoint, SizeOf(VPoint));
  finally
    VStream.Free;
  end;
end;

procedure BlobFromPath(
  const APath: ILonLatPath;
  Blobfield: Tfield
);
var
  VField: TBlobfield;
  VStream: TStream;
  i: Integer;
  VPoint: TExtendedPoint;
  VEnum: IEnumDoublePoint;
  VFirstPoint: TDoublePoint;
  VCurrPoint: TDoublePoint;
  VPrevPoint: TDoublePoint;
begin
  VField := TBlobfield(BlobField);
  VStream := VField.DataSet.CreateBlobStream(VField, bmWrite);
  try
    VEnum := APath.GetEnum;
    i := 0;
    if VEnum.Next(VFirstPoint) then begin
      VCurrPoint := VFirstPoint;
      VPrevPoint := VCurrPoint;
      VPoint.X := VCurrPoint.X;
      VPoint.Y := VCurrPoint.Y;
      VStream.Write(VPoint, SizeOf(VPoint));
      Inc(i);
      while VEnum.Next(VCurrPoint) do begin
        VPoint.X := VCurrPoint.X;
        VPoint.Y := VCurrPoint.Y;
        VStream.Write(VPoint, SizeOf(VPoint));
        VPrevPoint := VCurrPoint;
        Inc(i);
      end;
    end;
    if (i = 1) or ((i > 1) and DoublePointsEqual(VFirstPoint, VPrevPoint)) then begin
      VPoint.X := CEmptyDoublePoint.X;
      VPoint.Y := CEmptyDoublePoint.Y;
      VStream.Write(VPoint, SizeOf(VPoint));
    end;
  finally
    VStream.Free;
  end;
end;

procedure BlobFromPolygon(
  const APolygon: ILonLatPolygon;
  Blobfield: Tfield
);
var
  VField: TBlobfield;
  VStream: TStream;
  VPoint: TExtendedPoint;
  VEnum: IEnumDoublePoint;
  VCurrPoint: TDoublePoint;
  VLine: ILonLatPolygonLine;
begin
  VField := TBlobfield(BlobField);
  VStream := VField.DataSet.CreateBlobStream(VField, bmWrite);
  try
    if APolygon.Count > 0 then begin
      VLine := APolygon.Item[0];
      if VLine.Count = 1 then begin
        VPoint.X := VLine.Points[0].X;
        VPoint.Y := VLine.Points[0].Y;
        VStream.Write(VPoint, SizeOf(VPoint));
        VStream.Write(VPoint, SizeOf(VPoint));
      end else begin
        VEnum := VLine.GetEnum;
        while VEnum.Next(VCurrPoint) do begin
          VPoint.X := VCurrPoint.X;
          VPoint.Y := VCurrPoint.Y;
          VStream.Write(VPoint, SizeOf(VPoint));
        end;
      end;
    end;
  finally
    VStream.Free;
  end;
end;

constructor TMarksDb.Create(
  const AStateInternal: IReadWriteStateInternal;
  const ABasePath: IPathConfig;
  const ACategoryDB: IMarkCategoryDBSmlInternal;
  const AVectorItmesFactory: IVectorItmesFactory;
  const AHintConverter: IHtmlToHintTextConverter;
  const AFactoryConfig: IMarksFactoryConfig
);
var
  VFactory: TMarkFactory;
begin
  inherited Create;
  FBasePath := ABasePath;
  FStateInternal := AStateInternal;
  VFactory :=
    TMarkFactory.Create(
      AFactoryConfig,
      AVectorItmesFactory,
      AHintConverter,
      ACategoryDB
    );
  FFactory := VFactory;
  FFactoryDbInternal := VFactory;
  FMarksList := TIDInterfaceList.Create;
  FByCategoryList := TIDInterfaceList.Create;
  FCdsMarks := TClientDataSet.Create(nil);
  FCdsMarks.Name := 'CDSmarks';
  FCdsMarks.DisableControls;
  InitEmptyDS(FCdsMarks);
end;

destructor TMarksDb.Destroy;
begin
  FreeAndNil(FStream);
  FreeAndNil(FCdsMarks);
  FByCategoryList := nil;
  FMarksList := nil;
  FFactory := nil;
  FFactoryDbInternal := nil;
  inherited;
end;

function TMarksDb._UpdateMark(
  const AOldMark: IInterface;
  const ANewMark: IInterface
): IMark;
var
  VIdOld: Integer;
  VIdNew: Integer;
  VMarkInternal: IMarkSMLInternal;
  VLocated: Boolean;
  VMark: IMark;
  VOldMark: IMark;
  VCategoryOld: IMarkCategorySMLInternal;
  VCategoryNew: IMarkCategorySMLInternal;
  VList: IIDInterfaceList;
  VCategoryIdOld: Integer;
  VCategoryIdNew: Integer;
begin
  Result := nil;
  VIdOld := CNotExistMarkID;
  if Supports(AOldMark, IMarkSMLInternal, VMarkInternal) then begin
    VIdOld := VMarkInternal.Id;
  end;
  VLocated := False;
  VOldMark := nil;
  if VIdOld >= 0 then begin
    VOldMark := IMark(FMarksList.GetByID(VIdOld));
    if Supports(ANewMark, IMark, VMark) then begin
      if (VOldMark <> nil) and VOldMark.IsEqual(VMark) then begin
        Result := VOldMark;
        Exit;
      end;
    end;

    FCdsMarks.Filtered := false;
    if FCdsMarks.Locate('id', VIdOld, []) then begin
      VLocated := True;
    end;
  end;
  if VLocated then begin
    if Supports(ANewMark, IMark, VMark) then begin
      FCdsMarks.Edit;
      WriteCurrentMark(VMark);
      FCdsMarks.Post;
      Result := ReadCurrentMark;
    end else begin
      FCdsMarks.Delete;
    end;
    SetChanged;
  end else begin
    if Supports(ANewMark, IMark, VMark) then begin
      FCdsMarks.Insert;
      WriteCurrentMark(VMark);
      FCdsMarks.Post;
      Result := ReadCurrentMark;
      SetChanged;
    end;
  end;

  VIdNew := CNotExistMarkID;
  if Supports(Result, IMarkSMLInternal, VMarkInternal) then begin
    VIdNew := VMarkInternal.Id;
  end;

  VCategoryIdOld := CNotExistCategoryID;
  if VOldMark <> nil then begin
    if Supports(VOldMark.Category, IMarkCategorySMLInternal, VCategoryOld) then begin
      VCategoryIdOld := VCategoryOld.Id;
    end;
  end;

  VCategoryIdNew := CNotExistCategoryID;
  if Result <> nil then begin
    if Supports(Result.Category, IMarkCategorySMLInternal, VCategoryNew) then begin
      VCategoryIdNew := VCategoryNew.Id;
    end;
  end;
  if VIdOld = VIdNew then begin
    if VOldMark <> nil then begin
      if Result <> nil then begin
        FMarksList.Replace(VIdOld, Result);
        if VCategoryIdOld <> VCategoryIdNew then begin
          VList := IIDInterfaceList(FByCategoryList.GetByID(VCategoryIdOld));
          if VList <> nil then begin
            VList.Remove(VIdOld);
          end;
          VList := IIDInterfaceList(FByCategoryList.GetByID(VCategoryIdNew));
          if VList = nil then begin
            VList := TIDInterfaceList.Create;
            FByCategoryList.Add(VCategoryIdNew, VList);
          end;
          VList.Add(VIdNew, Result);
        end else begin
          VList := IIDInterfaceList(FByCategoryList.GetByID(VCategoryIdOld));
          if VList <> nil then begin
            VList.Replace(VIdNew, Result);
          end;
        end;
      end else begin
        FMarksList.Remove(VIdOld);
        VList := IIDInterfaceList(FByCategoryList.GetByID(VCategoryIdOld));
        if VList <> nil then begin
          VList.Remove(VIdOld);
        end;
      end;
    end else begin
      if Result <> nil then begin
        FMarksList.Add(VIdNew, Result);
        VList := IIDInterfaceList(FByCategoryList.GetByID(VCategoryIdNew));
        if VList = nil then begin
          VList := TIDInterfaceList.Create;
          FByCategoryList.Add(VCategoryIdNew, VList);
        end;
        VList.Add(VIdNew, Result);
      end;
    end;
  end else begin
    if VOldMark <> nil then begin
      FMarksList.Remove(VIdOld);
      VList := IIDInterfaceList(FByCategoryList.GetByID(VCategoryIdOld));
      if VList <> nil then begin
        VList.Remove(VIdOld);
      end;
    end;
    if Result <> nil then begin
      FMarksList.Add(VIdNew, Result);
      VList := IIDInterfaceList(FByCategoryList.GetByID(VCategoryIdNew));
      if VList = nil then begin
        VList := TIDInterfaceList.Create;
        FByCategoryList.Add(VCategoryIdNew, VList);
      end;
      VList.Add(VIdNew, Result);
    end;
  end;
end;

function TMarksDb.UpdateMark(
  const AOldMark: IInterface;
  const ANewMark: IMark
): IMark;
begin
  Assert((AOldMark <> nil) or (ANewMark <> nil));
  LockWrite;
  try
    Result := _UpdateMark(AOldMark, ANewMark);
  finally
    UnlockWrite;
  end;
  SaveMarks2File;
end;

function TMarksDb.UpdateMarksList(
  const AOldMarkList, ANewMarkList: IInterfaceList
): IInterfaceList;
var
  i: Integer;
  VNew: IInterface;
  VOld: IInterface;
  VResult: IMark;
  VMinCount: Integer;
  VMaxCount: Integer;
begin
  Result := nil;
  if ANewMarkList <> nil then begin
    Result := TInterfaceList.Create;
    Result.Capacity := ANewMarkList.Count;

    LockWrite;
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
      for i := 0 to VMinCount - 1 do begin
        VOld := AOldMarkList[i];
        VNew := ANewMarkList[i];
        VResult := _UpdateMark(VOld, VNew);
        Result.Add(VResult);
      end;
      for i := VMinCount to VMaxCount - 1 do begin
        VOld := nil;
        if (AOldMarkList <> nil) and (i < AOldMarkList.Count) then begin
          VOld := AOldMarkList[i];
        end;
        VNew := nil;
        if (i < ANewMarkList.Count) then begin
          VNew := ANewMarkList[i];
        end;
        VResult := _UpdateMark(VOld, VNew);
        if i < Result.Capacity then begin
          Result.Add(VResult);
        end;
      end;
    finally
      UnlockWrite;
    end;
    SaveMarks2File;
  end else begin
    LockWrite;
    try
      for i := 0 to AOldMarkList.Count - 1 do begin
        _UpdateMark(AOldMarkList[i], nil);
      end;
    finally
      UnlockWrite;
    end;
    SaveMarks2File;
  end;
end;

function TMarksDb.ReadCurrentMark: IMark;
var
  VPicName: string;
  VId: Integer;
  VName: string;
  VVisible: Boolean;
  VPoints: IDoublePointsAggregator;
  VCategoryId: Integer;
  VDesc: string;
  VColor1: TColor32;
  VColor2: TColor32;
  VScale1: Integer;
  VScale2: Integer;
begin
  VPoints := TDoublePointsAggregator.Create;
  VId := FCdsMarks.fieldbyname('id').AsInteger;
  VName := FCdsMarks.FieldByName('name').AsString;
  VVisible := FCdsMarks.FieldByName('Visible').AsBoolean;
  Blob2ExtArr(FCdsMarks.FieldByName('LonLatArr'), VPoints);
  VCategoryId := FCdsMarks.FieldByName('categoryid').AsInteger;
  VDesc := FCdsMarks.FieldByName('descr').AsString;
  VPicName := FCdsMarks.FieldByName('PicName').AsString;
  VColor1 := TColor32(FCdsMarks.FieldByName('Color1').AsInteger);
  VColor2 := TColor32(FCdsMarks.FieldByName('Color2').AsInteger);
  VScale1 := FCdsMarks.FieldByName('Scale1').AsInteger;
  VScale2 := FCdsMarks.FieldByName('Scale2').AsInteger;

  Result :=
    FFactoryDbInternal.CreateMark(
      VId,
      VName,
      VVisible,
      VPicName,
      VCategoryId,
      VDesc,
      VPoints.Points,
      VPoints.Count,
      VColor1,
      VColor2,
      VScale1,
      VScale2
    );
end;

procedure TMarksDb.WriteCurrentMarkId(const AMark: IMarkId);
begin
  FCdsMarks.FieldByName('name').AsString := AMark.name;
  FCdsMarks.FieldByName('Visible').AsBoolean := GetMarkVisible(AMark);
end;

procedure TMarksDb.WriteCurrentMark(const AMark: IMark);
var
  VMarkVisible: IMarkSMLInternal;
  VMarkPointSml: IMarkPointSMLInternal;
  VPicName: string;
  VCategoryId: Integer;
  VVisible: Boolean;
  VMarkPoint: IMarkPoint;
  VMarkLine: IMarkLine;
  VMarkPoly: IMarkPoly;
  VPoint: TDoublePoint;
begin
  VVisible := True;
  VCategoryId := CNotExistCategoryID;
  if Supports(AMark, IMarkSMLInternal, VMarkVisible) then begin
    VVisible := VMarkVisible.Visible;
    VCategoryId := VMarkVisible.CategoryId;
  end;

  FCdsMarks.FieldByName('Visible').AsBoolean := VVisible;
  FCdsMarks.FieldByName('name').AsString := AMark.name;
  FCdsMarks.FieldByName('categoryid').AsInteger := VCategoryId;
  FCdsMarks.FieldByName('descr').AsString := AMark.Desc;
  FCdsMarks.FieldByName('LonL').AsFloat := AMark.LLRect.Left;
  FCdsMarks.FieldByName('LatT').AsFloat := AMark.LLRect.Top;
  FCdsMarks.FieldByName('LonR').AsFloat := AMark.LLRect.Right;
  FCdsMarks.FieldByName('LatB').AsFloat := AMark.LLRect.Bottom;

  if Supports(AMark, IMarkPoint, VMarkPoint) then begin
    VPicName := '';
    if Supports(AMark, IMarkPointSMLInternal, VMarkPointSml) then begin
      VPicName := VMarkPointSml.PicName;
    end;
    FCdsMarks.FieldByName('PicName').AsString := VPicName;
    VPoint := VMarkPoint.Point;
    BlobFromPoint(VPoint, FCdsMarks.FieldByName('LonLatArr'));
    FCdsMarks.FieldByName('Color1').AsInteger := VMarkPoint.TextColor;
    FCdsMarks.FieldByName('Color2').AsInteger := VMarkPoint.TextBgColor;
    FCdsMarks.FieldByName('Scale1').AsInteger := VMarkPoint.FontSize;
    FCdsMarks.FieldByName('Scale2').AsInteger := VMarkPoint.MarkerSize;
  end else if Supports(AMark, IMarkLine, VMarkLine) then begin
    FCdsMarks.FieldByName('PicName').AsString := '';
    BlobFromPath(VMarkLine.Line, FCdsMarks.FieldByName('LonLatArr'));
    FCdsMarks.FieldByName('Color1').AsInteger := VMarkLine.LineColor;
    FCdsMarks.FieldByName('Color2').AsInteger := 0;
    FCdsMarks.FieldByName('Scale1').AsInteger := VMarkLine.LineWidth;
    FCdsMarks.FieldByName('Scale2').AsInteger := 0;
  end else if Supports(AMark, IMarkPoly, VMarkPoly) then begin
    FCdsMarks.FieldByName('PicName').AsString := '';
    BlobFromPolygon(VMarkPoly.Line, FCdsMarks.FieldByName('LonLatArr'));
    FCdsMarks.FieldByName('Color1').AsInteger := VMarkPoly.BorderColor;
    FCdsMarks.FieldByName('Color2').AsInteger := VMarkPoly.FillColor;
    FCdsMarks.FieldByName('Scale1').AsInteger := VMarkPoly.LineWidth;
    FCdsMarks.FieldByName('Scale2').AsInteger := 0;
  end;
end;

function TMarksDb.GetMarkByID(const AMarkId: IMarkId): IMark;
var
  VId: Integer;
  VMarkVisible: IMarkSMLInternal;
begin
  Result := nil;
  if AMarkId <> nil then begin
    VId := CNotExistMarkID;
    if Supports(AMarkId, IMarkSMLInternal, VMarkVisible) then begin
      VId := VMarkVisible.Id;
    end;
    if VId >= 0 then begin
      LockRead;
      try
        Result := IMark(FMarksList.GetByID(VId));
      finally
        UnlockRead;
      end;
    end;
  end;
end;

function TMarksDb.GetMarkVisible(const AMark: IMark): Boolean;
var
  VMarkVisible: IMarkSMLInternal;
begin
  Result := True;
  if AMark <> nil then begin
    if Supports(AMark, IMarkSMLInternal, VMarkVisible) then begin
      Result := VMarkVisible.Visible;
    end;
  end;
end;

function TMarksDb.GetMarkVisible(const AMark: IMarkId): Boolean;
var
  VMarkInternal: IMarkSMLInternal;
begin
  Result := True;
  if AMark <> nil then begin
    if Supports(AMark, IMarkSMLInternal, VMarkInternal) then begin
      Result := VMarkInternal.Visible;
    end;
  end;
end;

procedure TMarksDb.SetAllMarksInCategoryVisible(
  const ACategory: ICategory;
  ANewVisible: Boolean
);
var
  VVisible: Boolean;
  VFilter: string;
  VCategoryId: Integer;
  VList: IIDInterfaceList;
  VEnumId: IEnumID;
  VId: Integer;
  VCnt: Cardinal;
  VMarkInternal: IMarkSMLInternal;
begin
  VFilter := GetFilterTextByCategory(ACategory);
  if VFilter <> '' then begin
    LockWrite;
    try
      FCdsMarks.Filtered := false;
      FCdsMarks.Filter := VFilter;
      FCdsMarks.Filtered := true;
      FCdsMarks.First;
      while not (FCdsMarks.Eof) do begin
        VVisible := FCdsMarks.FieldByName('Visible').AsBoolean;
        if VVisible <> ANewVisible then begin
          FCdsMarks.Edit;
          FCdsMarks.FieldByName('Visible').AsBoolean := ANewVisible;
          FCdsMarks.Post;
          SetChanged;
        end;
        FCdsMarks.Next;
      end;
      VCategoryId := GetCategoryID(ACategory);
      VList := IIDInterfaceList(FByCategoryList.GetByID(VCategoryId));
      if VList <> nil then begin
        VEnumId := VList.GetIDEnum;
        while VEnumId.Next(1, VId, VCnt) = S_OK do begin
          if Supports(VList.GetByID(VId), IMarkSMLInternal, VMarkInternal) then begin
            VMarkInternal.Visible := ANewVisible;
          end;
        end;
      end;
    finally
      UnlockWrite;
    end;
  end;
end;

procedure TMarksDb.SetMarkVisibleByID(
  const AMark: IMarkId;
  AVisible: Boolean
);
var
  VMarkVisible: IMarkSMLInternal;
  VId: Integer;
  VMarkInternal: IMarkSMLInternal;
begin
  if AMark <> nil then begin
    VId := CNotExistMarkID;
    if Supports(AMark, IMarkSMLInternal, VMarkVisible) then begin
      VId := VMarkVisible.Id;
      VMarkVisible.Visible := AVisible;
    end;
    if VId >= 0 then begin
      LockWrite;
      try
        FCdsMarks.Filtered := false;
        if FCdsMarks.Locate('id', VId, []) then begin
          FCdsMarks.Edit;
          WriteCurrentMarkId(AMark);
          FCdsMarks.Post;
          SetChanged;
        end;
        if Supports(FMarksList.GetByID(VId), IMarkSMLInternal, VMarkInternal) then begin
          VMarkInternal.Visible := AVisible;
        end;
      finally
        UnlockWrite;
      end;
    end;
  end;
end;

function TMarksDb.GetAllMarskIdList: IInterfaceList;
var
  VEnumId: IEnumID;
  VId: Integer;
  VCnt: Cardinal;
  VMarkId: IMarkId;
begin
  Result := TInterfaceList.Create;
  LockRead;
  try
    VEnumId := FMarksList.GetIDEnum;
    while VEnumId.Next(1, VId, VCnt) = S_OK do begin
      if Supports(FMarksList.GetByID(VId), IMarkId, VMarkId) then begin
        Result.Add(VMarkId);
      end;
    end;
  finally
    UnlockRead;
  end;
end;

function TMarksDb.GetFactory: IMarkFactory;
begin
  Result := FFactory;
end;

function TMarksDb.GetCategoryID(const ACategory: ICategory): Integer;
var
  VCategoryInternal: IMarkCategorySMLInternal;
begin
  Assert(ACategory <> nil);
  Result := CNotExistCategoryID;
  if Supports(ACategory, IMarkCategorySMLInternal, VCategoryInternal) then begin
    Result := VCategoryInternal.Id;
  end;
end;

function TMarksDb.GetMarskIdListByCategory(const ACategory: ICategory): IInterfaceList;
var
  VMarkId: IMarkId;
  VCategoryId: Integer;
  VList: IIDInterfaceList;
  VEnumId: IEnumID;
  VId: Integer;
  VCnt: Cardinal;
begin
  Result := TInterfaceList.Create;
  VCategoryId := GetCategoryID(ACategory);
  if Supports(FByCategoryList.GetByID(VCategoryId), IIDInterfaceList, VList) then begin
    VEnumId := VList.GetIDEnum;
    while VEnumId.Next(1, VId, VCnt) = S_OK do begin
      if Supports(VList.GetByID(VId), IMarkId, VMarkId) then begin
        Result.Add(VMarkId);
      end;
    end;
  end;
end;

procedure TMarksDb.InitEmptyDS(ACdsMarks: TClientDataSet);
begin
  ACdsMarks.Close;
  ACdsMarks.XMLData :=
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
    '<DATAPACKET Version="2.0">' +
    '	<METADATA>' +
    '		<FIELDS>' +
    '			<FIELD attrname="id" fieldtype="i4" readonly="true" SUBTYPE="Autoinc"/>' +
    '			<FIELD attrname="name" fieldtype="string" WIDTH="255"/>' +
    '			<FIELD attrname="descr" fieldtype="bin.hex" SUBTYPE="Text"/>' +
    '			<FIELD attrname="scale1" fieldtype="i4"/>' +
    ' 		<FIELD attrname="scale2" fieldtype="i4"/>' +
    '			<FIELD attrname="lonlatarr" fieldtype="bin.hex" SUBTYPE="Binary"/>' +
    '			<FIELD attrname="lonL" fieldtype="r8"/>' +
    '			<FIELD attrname="latT" fieldtype="r8"/>' +
    '			<FIELD attrname="LonR" fieldtype="r8"/>' +
    '			<FIELD attrname="LatB" fieldtype="r8"/>' +
    '			<FIELD attrname="color1" fieldtype="i4"/>' +
    '			<FIELD attrname="color2" fieldtype="i4"/>' +
    '			<FIELD attrname="visible" fieldtype="boolean"/>' +
    '			<FIELD attrname="picname" fieldtype="string" WIDTH="20"/>' +
    '			<FIELD attrname="categoryid" fieldtype="i4"/>' +
    '		</FIELDS>' +
    '		<PARAMS AUTOINCVALUE="1"/>' +
    '	</METADATA>' +
    '	<ROWDATA/>' +
    '</DATAPACKET>';
  ACdsMarks.IndexFieldNames := 'categoryid;LonR;LonL;LatT;LatB;visible';
  ACdsMarks.Open;
end;

function TMarksDb.GetFilterTextByCategory(const ACategory: ICategory): string;
var
  VCategoryID: Integer;
begin
  Result := '';
  if (ACategory <> nil) then begin
    VCategoryID := GetCategoryID(ACategory);
    if VCategoryID >= 0 then begin
      Result := '(categoryid = ' + IntToStr(VCategoryID) + ')';
    end;
  end;
end;

procedure TMarksDb._AddMarksToList(
  const ASourceList: IIDInterfaceList;
  const ARect: TDoubleRect;
  AIgnoreVisible: Boolean;
  const AResultList: IInterfaceList
);
var
  VMark: IMark;
  VEnumId: IEnumID;
  VId: Integer;
  VCnt: Cardinal;
  VMarkInternal: IMarkSMLInternal;
begin
  VEnumId := ASourceList.GetIDEnum;
  while VEnumId.Next(1, VId, VCnt) = S_OK do begin
    VMark := IMark(ASourceList.GetByID(VId));
    if VMark.LLRect.IsIntersecWithRect(ARect) then begin
      if not AIgnoreVisible then begin
        if Supports(VMark, IMarkSMLInternal, VMarkInternal) then begin
          if VMarkInternal.Visible then begin
            AResultList.Add(VMark);
          end;
        end;
      end else begin
        AResultList.Add(VMark);
      end;
    end;
  end;
end;

function TMarksDb.GetMarksSubset(
  const ARect: TDoubleRect;
  const ACategoryList: IInterfaceList;
  AIgnoreVisible: Boolean
): IMarksSubset;
var
  VResultList: IInterfaceList;
  i: Integer;
  VCategoryID: Integer;
  VList: IIDInterfaceList;
begin
  VResultList := TInterfaceList.Create;
  Result := TMarksSubset.Create(VResultList);
  VResultList.Lock;
  try
    LockRead;
    try
      if (ACategoryList = nil) then begin
        _AddMarksToList(FMarksList, ARect, AIgnoreVisible, VResultList);
      end else begin
        for i := 0 to ACategoryList.Count - 1 do begin
          VCategoryID := GetCategoryID(ICategory(ACategoryList[i]));
          VList := IIDInterfaceList(FByCategoryList.GetByID(VCategoryID));
          if VList <> nil then begin
            _AddMarksToList(VList, ARect, AIgnoreVisible, VResultList);
          end;
        end;
      end;
    finally
      UnlockRead;
    end;
  finally
    VResultList.Unlock;
  end;
end;

function TMarksDb.GetMarksSubset(
  const ARect: TDoubleRect;
  const ACategory: ICategory;
  AIgnoreVisible: Boolean
): IMarksSubset;
var
  VResultList: IInterfaceList;
  VCategoryId: Integer;
  VList: IIDInterfaceList;
begin
  VResultList := TInterfaceList.Create;
  Result := TMarksSubset.Create(VResultList);
  VResultList.Lock;
  try
    if ACategory = nil then begin
      VList := FMarksList;
    end else begin
      VCategoryId := GetCategoryID(ACategory);
      VList := IIDInterfaceList(FByCategoryList.GetByID(VCategoryId));
    end;
    if VList <> nil then begin
      LockRead;
      try
        _AddMarksToList(VList, ARect, AIgnoreVisible, VResultList);
      finally
        UnlockRead;
      end;
    end;
  finally
    VResultList.Unlock;
  end;
end;

function TMarksDb.GetMarksBackUpFileName: string;
begin
  Result := IncludeTrailingPathDelimiter(FBasePath.FullPath) + 'marks.~sml';
end;

function TMarksDb.GetMarksFileName: string;
begin
  Result := IncludeTrailingPathDelimiter(FBasePath.FullPath) + 'marks.sml';
end;

procedure TMarksDb.LoadMarksFromFile;
var
  VFileName: string;
  VMark: IMark;
  VIdNew: Integer;
  VCategoryIdNew: Integer;
  VList: IIDInterfaceList;
  VMarkInternal: IMarkSMLInternal;
  VStream: TStream;
  XML: string;
begin
  VFileName := GetMarksFileName;
  FStateInternal.LockWrite;
  try
    LockWrite;
    try
      InitEmptyDS(FCdsMarks);
      FMarksList.Clear;
      FByCategoryList.Clear;
      if FStateInternal.ReadAccess <> asDisabled then begin
        VStream := nil;
        try
          if FileExists(VFileName) then begin
            if FStateInternal.WriteAccess <> asDisabled then begin
              try
                VStream := TFileStream.Create(VFileName, fmOpenReadWrite + fmShareDenyWrite);
                FStateInternal.WriteAccess := asEnabled;
              except
                VStream := nil;
                FStateInternal.WriteAccess := asDisabled;
              end;
            end;
            if VStream = nil then begin
              try
                VStream := TFileStream.Create(VFileName, fmOpenRead + fmShareDenyNone);
                FStateInternal.ReadAccess := asEnabled;
              except
                FStateInternal.ReadAccess := asDisabled;
                VStream := nil;
              end;
            end;
            if VStream <> nil then begin
              try
                SetLength(XML, VStream.Size);
                VStream.ReadBuffer(XML[1], length(XML));
              except
                FStateInternal.ReadAccess := asDisabled;
                VStream.Free;
                VStream := nil;
              end;
            end;

            if length(XML) > 0 then begin
              try
                FCdsMarks.XMLData := XML;
              except
                InitEmptyDS(FCdsMarks);
              end;
            end;

            if FCdsMarks.RecordCount > 0 then begin
              if FStateInternal.WriteAccess = asEnabled then begin
                CopyFile(PChar(VFileName), PChar(GetMarksBackUpFileName), false);
              end;
            end;

            FCdsMarks.Filtered := False;
            FCdsMarks.First;
            while not FCdsMarks.Eof do begin
              VMark := ReadCurrentMark;
              if Supports(VMark, IMarkSMLInternal, VMarkInternal) then begin
                VIdNew := VMarkInternal.Id;
                if VMark.Category = nil then begin
                  VCategoryIdNew := CNotExistCategoryID;
                end else begin
                  VCategoryIdNew := VMarkInternal.CategoryId;
                end;
                FMarksList.Add(VIdNew, VMark);
                VList := IIDInterfaceList(FByCategoryList.GetByID(VCategoryIdNew));
                if VList = nil then begin
                  VList := TIDInterfaceList.Create;
                  FByCategoryList.Add(VCategoryIdNew, VList);
                end;
                VList.Add(VIdNew, VMark);
              end;
              FCdsMarks.Next;
            end;
          end else begin
            if FStateInternal.WriteAccess <> asDisabled then begin
              try
                VStream := TFileStream.Create(VFileName, fmCreate);
                VStream.Free;
                VStream := nil;
              except
                FStateInternal.WriteAccess := asDisabled;
                VStream := nil;
              end;
              if FStateInternal.WriteAccess <> asDisabled then begin
                try
                  VStream := TFileStream.Create(VFileName, fmOpenReadWrite + fmShareDenyWrite);
                  FStateInternal.WriteAccess := asEnabled;
                except
                  VStream := nil;
                  FStateInternal.WriteAccess := asDisabled;
                end;
              end;
            end;
          end;
          if FStream <> nil then begin
            FreeAndNil(FStream);
          end;
          if FStateInternal.WriteAccess = asEnabled then begin
            FStream := VStream;
            VStream := nil;
          end;
        finally
          VStream.Free;
        end;
      end;
    finally
      UnlockWrite
    end;
  finally
    FStateInternal.UnlockWrite;
  end;
end;

function TMarksDb.SaveMarks2File: boolean;
var
  XML: string;
begin
  result := true;
  try
    FStateInternal.LockRead;
    try
      if FStateInternal.WriteAccess = asEnabled then begin
        LockRead;
        try
          if FStream <> nil then begin
            FCdsMarks.MergeChangeLog;
            XML := FCdsMarks.XMLData;
            FStream.Size := length(XML);
            FStream.Position := 0;
            FStream.WriteBuffer(XML[1], length(XML));
          end;
        finally
          UnlockRead;
        end;
      end;
    finally
      FStateInternal.UnlockRead;
    end;
  except
    result := false;
  end;
end;

end.
