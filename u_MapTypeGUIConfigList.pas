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

unit u_MapTypeGUIConfigList;

interface

uses
  ActiveX,
  i_Notifier,
  i_Listener,
  i_GUIDListStatic,
  i_MapTypeHotKeyListStatic,
  i_MapTypeGUIConfigList,
  i_MapTypeSet,
  i_LanguageManager,
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
    procedure OnBeforeLangChange;
    procedure OnAfterLangChange;
    function CreateHotKeyList: IMapTypeHotKeyListStatic;
    function CreateOrderedList: IGUIDListStatic;
  protected
    procedure DoBeforeChangeNotify; override;
  private
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
  i_InterfaceListSimple,
  i_MapTypes,
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
  VGUID: TGUID;
  VEnum: IEnumGUID;
  VGetCount: Cardinal;
  VMap: IMapType;
begin
  inherited Create;
  FLanguageManager := ALanguageManager;
  FMapsSet := AMapsSet;
  FOrderedMapGUIDList := CreateOrderedList;
  FHotKeyList := CreateHotKeyList;
  VEnum := FMapsSet.GetIterator;
  while VEnum.Next(1, VGUID, VGetCount) = S_OK do begin
    VMap := FMapsSet.GetMapTypeByGUID(VGUID);
    Add(VMap.MapType.GUIConfig, nil);
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
  VIndexList: array of Integer;
  VGUIDList: array of TGUID;
  VEnum: IEnumUnknown;
  VGetCount: Integer;
  VMap: IMapType;
  VCount: Integer;
  i: Integer;
  VList: IInterfaceListSimple;
begin
  Result := nil;
  if Assigned(FMapsSet)then begin
    VCount := FMapsSet.GetCount;
    VList := TInterfaceListSimple.Create;
    VList.Capacity := VCount;
    VEnum := FMapsSet.GetMapTypeIterator;
    while VEnum.Next(1, VMap, @VGetCount) = S_OK do begin
      if Assigned(VMap) then begin
        VList.Add(VMap);
      end;
    end;
    VCount := VList.GetCount;
    if VCount > 1 then begin
      SetLength(VIndexList, VCount);
      for i := 0 to VCount - 1 do begin
        VIndexList[i] := IMapType(VList[i]).MapType.GUIConfig.SortIndex;
      end;
      SortInterfaceListByIntegerMeasure(VList, VIndexList);
    end;
    if VCount > 0 then begin
      SetLength(VGUIDList, VCount);
      for i := 0 to VCount - 1 do begin
        VGUIDList[i] := IMapType(VList[i]).MapType.Zmp.GUID;
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

function TMapTypeGUIConfigList.GetHotKeyList: IMapTypeHotKeyListStatic;
begin
  Result := FHotKeyList;
end;

function TMapTypeGUIConfigList.GetOrderedMapGUIDList: IGUIDListStatic;
begin
  Result := FOrderedMapGUIDList;
end;

procedure TMapTypeGUIConfigList.OnAfterLangChange;
begin
  StartNotify;
end;

procedure TMapTypeGUIConfigList.OnBeforeLangChange;
begin
  StopNotify;
end;

end.
