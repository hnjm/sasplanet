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

unit u_MapTypeGUIConfigList;

interface

uses
  i_Notifier,
  i_Listener,
  i_GUIDListStatic,
  i_MapTypeHotKeyListStatic,
  i_MapTypeGUIConfigList,
  i_MapTypeSet,
  i_LanguageManager,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  u_ConfigDataElementComplexBase;

type
  TMapTypeGUIConfigList = class(TConfigDataElementComplexBase, IMapTypeGUIConfigList)
  private
    FLanguageManager: ILanguageManager;
    FMapsSet: IMapTypeSet;
    FOrderedMapGUIDList: IGUIDListStatic;
    FHotKeyList: IMapTypeHotKeyListStatic;
    FBeforeLangChangeListener: IListener;
    FAfterLangChangeListener: IListener;
    FSortOrder: TMapTypeGUIConfigListSortOrder;
    procedure OnBeforeLangChange;
    procedure OnAfterLangChange;
    function CreateHotKeyList: IMapTypeHotKeyListStatic;
    function CreateOrderedList: IGUIDListStatic;
  protected
    procedure DoBeforeChangeNotify; override;
    procedure DoReadConfig(const AConfigData: IConfigDataProvider); override;
    procedure DoWriteConfig(const AConfigData: IConfigDataWriteProvider); override;
  private
    function GetSortOrder: TMapTypeGUIConfigListSortOrder;
    procedure SetSortOrder(const AValue: TMapTypeGUIConfigListSortOrder);
    function GetOrderedMapGUIDList: IGUIDListStatic;
    function GetHotKeyList: IMapTypeHotKeyListStatic;
  public
    constructor Create(
      const ALanguageManager: ILanguageManager;
      const AMapsSet: IMapTypeSet
    );
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  i_InterfaceListSimple,
  i_MapType,
  u_ListenerByEvent,
  u_InterfaceListSimple,
  u_SortFunc,
  u_GUIDListStatic,
  u_MapTypeHotKeyListStatic;

{ TMapTypeGUIConfigList }

constructor TMapTypeGUIConfigList.Create(
  const ALanguageManager: ILanguageManager;
  const AMapsSet: IMapTypeSet
);
var
  i: Integer;
  VMap: IMapType;
begin
  inherited Create;
  FSortOrder := soByMapNumber;
  FLanguageManager := ALanguageManager;
  FMapsSet := AMapsSet;
  FOrderedMapGUIDList := CreateOrderedList;
  FHotKeyList := CreateHotKeyList;
  for i := 0 to FMapsSet.Count - 1 do begin
    VMap := FMapsSet.Items[i];
    Add(VMap.GUIConfig, nil);
  end;
  FBeforeLangChangeListener := TNotifyNoMmgEventListener.Create(Self.OnBeforeLangChange);
  FLanguageManager.BeforeChangeNotifier.Add(FBeforeLangChangeListener);
  FAfterLangChangeListener := TNotifyNoMmgEventListener.Create(Self.OnAfterLangChange);
  FLanguageManager.AfterChangeNotifier.Add(FAfterLangChangeListener);

  FOrderedMapGUIDList := CreateOrderedList;
  FHotKeyList := CreateHotKeyList;
end;

destructor TMapTypeGUIConfigList.Destroy;
begin
  if Assigned(FLanguageManager) and Assigned(FBeforeLangChangeListener) then begin
    FLanguageManager.BeforeChangeNotifier.Remove(FBeforeLangChangeListener);
    FBeforeLangChangeListener := nil;
  end;
  if Assigned(FLanguageManager) and Assigned(FAfterLangChangeListener) then begin
    FLanguageManager.AfterChangeNotifier.Remove(FAfterLangChangeListener);
    FAfterLangChangeListener := nil;
  end;
  FLanguageManager := nil;

  inherited;
end;

function TMapTypeGUIConfigList.CreateHotKeyList: IMapTypeHotKeyListStatic;
begin
  Result := TMapTypeHotKeyListStatic.Create(FMapsSet);
end;

function TMapTypeGUIConfigList.CreateOrderedList: IGUIDListStatic;
var
  I: Integer;
  VCount: Integer;
  VSubMenu, VSep: string;
  VIndexList: array of Integer;
  VStrIndexList: array of string;
  VGUIDList: array of TGUID;
  VMap: IMapType;
  VList: IInterfaceListSimple;
begin
  Result := nil;
  if Assigned(FMapsSet) then begin
    VCount := FMapsSet.GetCount;
    VList := TInterfaceListSimple.Create;
    VList.Capacity := VCount;
    for I := 0 to FMapsSet.Count - 1 do begin
      VMap := FMapsSet.Items[I];
      VList.Add(VMap);
    end;
    VCount := VList.GetCount;
    if VCount > 1 then begin
      case FSortOrder of
        soByMapNumber: begin
          SetLength(VIndexList, VCount);
          for I := 0 to VCount - 1 do begin
            VIndexList[I] := IMapType(VList[I]).GUIConfig.SortIndex;
          end;
          SortInterfaceListByIntegerMeasure(VList, VIndexList);
        end;
        soByMapName: begin
          SetLength(VStrIndexList, VCount);
          for I := 0 to VCount - 1 do begin
            VSubMenu := IMapType(VList[I]).GUIConfig.ParentSubMenu.Value;
            if (VSubMenu <> '') and (VSubMenu[Length(VSubMenu)] <> '\') then begin
              VSep := '\';
            end else begin
              VSep := '';
            end;
            VStrIndexList[I] := VSubMenu + VSep + IMapType(VList[I]).GUIConfig.Name.Value;
          end;
          SortInterfaceListByStringMeasure(VList, VStrIndexList);
        end;
        soByZmpName: begin
          // Do nothing (already sorted)
        end;
      else
        raise Exception.CreateFmt('Unexpected SortOrder type: %d', [Integer(FSortOrder)]);
      end;
    end;
    if VCount > 0 then begin
      SetLength(VGUIDList, VCount);
      for I := 0 to VCount - 1 do begin
        VGUIDList[I] := IMapType(VList[I]).Zmp.GUID;
      end;
      Result := TGUIDListStatic.Create(VGUIDList, VCount);
    end;
  end;
end;

procedure TMapTypeGUIConfigList.DoBeforeChangeNotify;
begin
  inherited;
  LockWrite;
  try
    FOrderedMapGUIDList := CreateOrderedList;
    FHotKeyList := CreateHotKeyList;
  finally
    UnlockWrite;
  end;
end;

procedure TMapTypeGUIConfigList.DoReadConfig(const AConfigData: IConfigDataProvider);
begin
  inherited;
  if AConfigData <> nil then begin
    FSortOrder := TMapTypeGUIConfigListSortOrder(
      AConfigData.ReadInteger('SortOrder', Integer(FSortOrder))
    );
    SetChanged;
  end;
end;

procedure TMapTypeGUIConfigList.DoWriteConfig(
  const AConfigData: IConfigDataWriteProvider
);
begin
  inherited;
  if AConfigData <> nil then begin
    AConfigData.WriteInteger('SortOrder', Integer(FSortOrder))
  end;
end;

function TMapTypeGUIConfigList.GetHotKeyList: IMapTypeHotKeyListStatic;
begin
  Result := FHotKeyList;
end;

function TMapTypeGUIConfigList.GetOrderedMapGUIDList: IGUIDListStatic;
begin
  Result := FOrderedMapGUIDList;
end;

function TMapTypeGUIConfigList.GetSortOrder: TMapTypeGUIConfigListSortOrder;
begin
  LockRead;
  try
    Result := FSortOrder;
  finally
    UnlockRead;
  end;
end;

procedure TMapTypeGUIConfigList.OnAfterLangChange;
begin
  StartNotify;
end;

procedure TMapTypeGUIConfigList.OnBeforeLangChange;
begin
  StopNotify;
end;

procedure TMapTypeGUIConfigList.SetSortOrder(
  const AValue: TMapTypeGUIConfigListSortOrder
);
begin
  LockWrite;
  try
    if AValue <> FSortOrder then begin
      FSortOrder := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

end.
