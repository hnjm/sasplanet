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

unit u_MarkCategoryDbByImpl;

interface

uses
  i_Listener,
  i_Notifier,
  i_MarkCategory,
  i_MarkCategoryList,
  i_MarkCategoryTree,
  i_MarkCategoryFactory,
  i_MarkCategoryDB,
  i_MarkSystemImplChangeable,
  u_BaseInterfacedObject;

type
  TMarkCategoryDbByImpl = class(TBaseInterfacedObject, IMarkCategoryDB)
  private
    FMarkSystemImpl: IMarkSystemImplChangeable;
    FNotifier: INotifier;

    FMarkCategoryFactory: IMarkCategoryFactory;
    FChangeNotifier: INotifier;
    FChangeNotifierInternal: INotifierInternal;
    FImplChangeListener: IListener;
    FDbImplChangeListener: IListener;
  private
    procedure OnImplChange;
    procedure OnDBImplChange;
  private
    function GetCategoryByName(const AName: string): IMarkCategory;
    function GetCategoryWithSubCategories(const ACategory: IMarkCategory): IMarkCategoryList;
    function GetSubCategoryListForCategory(const ACategory: IMarkCategory): IMarkCategoryList;
    function GetCategoriesList: IMarkCategoryList;
    function GetVisibleCategories(AZoom: Byte): IMarkCategoryList;
    function GetVisibleCategoriesIgnoreZoom: IMarkCategoryList;
    function CategoryListToStaticTree(const AList: IMarkCategoryList): IMarkCategoryTree;
    function FilterVisibleCategories(const ASourceList: IMarkCategoryList): IMarkCategoryList;

    function UpdateCategory(
      const AOldCategory: IMarkCategory;
      const ANewCategory: IMarkCategory
    ): IMarkCategory;
    function UpdateCategoryList(
      const AOldCategory: IMarkCategoryList;
      const ANewCategory: IMarkCategoryList
    ): IMarkCategoryList;

    procedure SetAllCategoriesVisible(ANewVisible: Boolean);

    function GetFactory: IMarkCategoryFactory;
    function GetChangeNotifier: INotifier;
  public
    constructor Create(
      const AMarkSystemImpl: IMarkSystemImplChangeable;
      const AMarkCategoryFactory: IMarkCategoryFactory
    );
    destructor Destroy; override;
  end;

implementation

uses
  StrUtils,
  SysUtils,
  i_MarkSystemImpl,
  i_InterfaceListSimple,
  u_Notifier,
  u_InterfaceListSimple,
  u_MarkCategoryList,
  u_MarkSystemHelpers,
  u_Synchronizer,
  u_ListenerByEvent;

{ TMarkCategoryDbByImpl }

constructor TMarkCategoryDbByImpl.Create(
  const AMarkSystemImpl: IMarkSystemImplChangeable;
  const AMarkCategoryFactory: IMarkCategoryFactory
);
begin
  inherited Create;
  FMarkSystemImpl := AMarkSystemImpl;
  FMarkCategoryFactory := AMarkCategoryFactory;
  FChangeNotifierInternal :=
    TNotifierBase.Create(
      GSync.SyncVariable.Make(Self.ClassName + 'Notifier')
    );
  FChangeNotifier := FChangeNotifierInternal;
  FImplChangeListener := TNotifyNoMmgEventListener.Create(Self.OnImplChange);
  FDbImplChangeListener := TNotifyNoMmgEventListener.Create(Self.OnDbImplChange);
  
  FMarkSystemImpl.ChangeNotifier.Add(FImplChangeListener);
  OnDBImplChange;
end;

destructor TMarkCategoryDbByImpl.Destroy;
begin
  if Assigned(FNotifier) and Assigned(FDbImplChangeListener) then begin
    FNotifier.Remove(FDbImplChangeListener);
    FNotifier := nil;
  end;
  if Assigned(FMarkSystemImpl) and Assigned(FImplChangeListener) then begin
    FMarkSystemImpl.ChangeNotifier.Remove(FImplChangeListener);
    FMarkSystemImpl := nil;
  end;
  inherited;
end;

function TMarkCategoryDbByImpl.FilterVisibleCategories(
  const ASourceList: IMarkCategoryList
): IMarkCategoryList;
var
  VTmp: IInterfaceListSimple;
  VCategory: IMarkCategory;
  i: Integer;
begin
  Result := nil;
  if Assigned(ASourceList) and (ASourceList.Count > 0) then begin
    VTmp := TInterfaceListSimple.Create;
    for i := 0 to ASourceList.Count - 1 do begin
      if Supports(ASourceList[i], IMarkCategory, VCategory) then begin
        if VCategory.Visible then begin
          VTmp.Add(VCategory);
        end;
      end;
    end;
    Result := TMarkCategoryList.Build(VTmp.MakeStaticAndClear);
  end;
end;

function TMarkCategoryDbByImpl.CategoryListToStaticTree(
  const AList: IMarkCategoryList): IMarkCategoryTree;
begin
  Result := nil;
  if Assigned(AList) then begin
    Result := CategoryListToCategoryTree(AList);
  end;
end;

function TMarkCategoryDbByImpl.GetCategoriesList: IMarkCategoryList;
var
  VImpl: IMarkSystemImpl;
begin
  Result := nil;
  VImpl := FMarkSystemImpl.GetStatic;
  if VImpl <> nil then begin
    Result := VImpl.CategoryDB.GetCategoriesList;
  end;
end;

function TMarkCategoryDbByImpl.GetCategoryByName(
  const AName: string): IMarkCategory;
var
  VImpl: IMarkSystemImpl;
begin
  Result := nil;
  VImpl := FMarkSystemImpl.GetStatic;
  if VImpl <> nil then begin
    Result := VImpl.CategoryDB.GetCategoryByName(AName);
  end;
end;

function TMarkCategoryDbByImpl.GetChangeNotifier: INotifier;
begin
  Result := FChangeNotifier;
end;

function TMarkCategoryDbByImpl.GetFactory: IMarkCategoryFactory;
begin
  Result := FMarkCategoryFactory;
end;

function TMarkCategoryDbByImpl.GetCategoryWithSubCategories(
  const ACategory: IMarkCategory
): IMarkCategoryList;
var
  VTmp: IInterfaceListSimple;
  VList: IMarkCategoryList;
  VCategory: IMarkCategory;
  i: Integer;
  VNameStart: string;
  VImpl: IMarkSystemImpl;
begin
  Result := nil;
  VImpl := FMarkSystemImpl.GetStatic;
  if VImpl <> nil then begin
    VList := VImpl.CategoryDB.GetCategoriesList;
    if not Assigned(ACategory) then begin
      Result := VList;
      Exit;
    end;
    if Assigned(VList) and (VList.Count > 0) then begin
      VNameStart := ACategory.Name + '\';
      VTmp := TInterfaceListSimple.Create;
      VTmp.Add(ACategory);
      for i := 0 to VList.Count - 1 do begin
        VCategory := VList.Items[i];
        if StartsStr(VNameStart, VCategory.Name) then begin
          VTmp.Add(VCategory);
        end;
      end;
      Result := TMarkCategoryList.Build(VTmp.MakeStaticAndClear);
    end;
  end;
end;

function TMarkCategoryDbByImpl.GetSubCategoryListForCategory(
  const ACategory: IMarkCategory
): IMarkCategoryList;
var
  VTmp: IInterfaceListSimple;
  VList: IMarkCategoryList;
  VCategory: IMarkCategory;
  i: Integer;
  VNameStart: string;
  VImpl: IMarkSystemImpl;
begin
  Result := nil;
  VImpl := FMarkSystemImpl.GetStatic;
  if VImpl <> nil then begin
    VList := VImpl.CategoryDB.GetCategoriesList;
    if not Assigned(ACategory) then begin
      Result := VList;
      Exit;
    end;
    if Assigned(VList) and (VList.Count > 0) then begin
      VNameStart := ACategory.Name + '\';
      VTmp := TInterfaceListSimple.Create;
      for i := 0 to VList.Count - 1 do begin
        VCategory := IMarkCategory(VList[i]);
        if StartsStr(VNameStart, VCategory.Name) then begin
          VTmp.Add(VCategory);
        end;
      end;
      Result := TMarkCategoryList.Build(VTmp.MakeStaticAndClear);
    end;
  end;
end;

function TMarkCategoryDbByImpl.GetVisibleCategories(
  AZoom: Byte
): IMarkCategoryList;
var
  VTmp: IInterfaceListSimple;
  VList: IMarkCategoryList;
  VCategory: IMarkCategory;
  i: Integer;
  VImpl: IMarkSystemImpl;
begin
  Result := nil;
  VImpl := FMarkSystemImpl.GetStatic;
  if VImpl <> nil then begin
    VList := VImpl.CategoryDB.GetCategoriesList;
    if Assigned(VList) and (VList.Count > 0) then begin
      VTmp := TInterfaceListSimple.Create;
      for i := 0 to VList.Count - 1 do begin
        VCategory := IMarkCategory(VList[i]);
        if (VCategory.Visible) and
          (VCategory.AfterScale <= AZoom + 1) and
          (VCategory.BeforeScale >= AZoom + 1) then begin
          VTmp.Add(VCategory);
        end;
      end;
      Result := TMarkCategoryList.Build(VTmp.MakeStaticAndClear);
    end;
  end;
end;

function TMarkCategoryDbByImpl.GetVisibleCategoriesIgnoreZoom: IMarkCategoryList;
var
  VTmp: IInterfaceListSimple;
  VList: IMarkCategoryList;
  VCategory: IMarkCategory;
  i: Integer;
  VImpl: IMarkSystemImpl;
begin
  Result := nil;
  VImpl := FMarkSystemImpl.GetStatic;
  if VImpl <> nil then begin
    VList := VImpl.CategoryDB.GetCategoriesList;
    if Assigned(VList) and (VList.Count > 0) then begin
      VTmp := TInterfaceListSimple.Create;
      for i := 0 to VList.Count - 1 do begin
        VCategory := IMarkCategory(VList[i]);
        if VCategory.Visible then begin
          VTmp.Add(VCategory);
        end;
      end;
      Result := TMarkCategoryList.Build(VTmp.MakeStaticAndClear);
    end;
  end;
end;

procedure TMarkCategoryDbByImpl.OnImplChange;
var
  VImpl: IMarkSystemImpl;
begin
  if FNotifier <> nil then begin
    FNotifier.Remove(FDbImplChangeListener);
    FNotifier := nil;
  end;
  VImpl := FMarkSystemImpl.GetStatic;
  if VImpl <> nil then begin
    FNotifier := VImpl.CategoryDB.ChangeNotifier;
    FNotifier.Add(FDbImplChangeListener);
  end;
  OnDbImplChange;
end;

procedure TMarkCategoryDbByImpl.OnDbImplChange;
begin
  FChangeNotifierInternal.Notify(nil);
end;

procedure TMarkCategoryDbByImpl.SetAllCategoriesVisible(ANewVisible: Boolean);
var
  VImpl: IMarkSystemImpl;
begin
  VImpl := FMarkSystemImpl.GetStatic;
  if VImpl <> nil then begin
    VImpl.CategoryDB.SetAllCategoriesVisible(ANewVisible);
  end;
end;

function TMarkCategoryDbByImpl.UpdateCategory(const AOldCategory,
  ANewCategory: IMarkCategory): IMarkCategory;
var
  VImpl: IMarkSystemImpl;
begin
  Result := nil;
  VImpl := FMarkSystemImpl.GetStatic;
  if VImpl <> nil then begin
    Result := VImpl.CategoryDB.UpdateCategory(AOldCategory, ANewCategory);
  end;
end;

function TMarkCategoryDbByImpl.UpdateCategoryList(
  const AOldCategory, ANewCategory: IMarkCategoryList
): IMarkCategoryList;
var
  VImpl: IMarkSystemImpl;
begin
  Result := nil;
  VImpl := FMarkSystemImpl.GetStatic;
  if VImpl <> nil then begin
    Result := VImpl.CategoryDB.UpdateCategoryList(AOldCategory, ANewCategory);
  end;
end;

end.
