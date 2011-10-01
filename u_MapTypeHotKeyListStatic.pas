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

unit u_MapTypeHotKeyListStatic;

interface

uses
  Classes,
  i_MapTypes,
  i_MapTypeHotKeyListStatic,
  i_IDList;

type
  TMapTypeHotKeyListStatic = class(TInterfacedObject, IMapTypeHotKeyListStatic)
  private
    FList: IIDInterfaceList;
  protected
    function GetMapTypeGUIDByHotKey(AHotKey: TShortCut): IMapType;
  public
    constructor Create(
      AMapsSet: IMapTypeSet
    );
  end;

implementation

uses
  ActiveX,
  u_IDInterfaceList;

{ TMapTypeHotKeyListStatic }

constructor TMapTypeHotKeyListStatic.Create(AMapsSet: IMapTypeSet);
var
  VEnum: IEnumGUID;
  VGUID: TGUID;
  VGetCount: Cardinal;
  VMap: IMapType;
  VHotKey: TShortCut;
begin
  FList := TIDInterfaceList.Create(False);
  VEnum := AMapsSet.GetIterator;
  while VEnum.Next(1, VGUID, VGetCount) = S_OK do begin
    VMap := AMapsSet.GetMapTypeByGUID(VGUID);
    VHotKey := VMap.MapType.GUIConfig.HotKey;
    if VHotKey <> 0 then begin
      FList.Add(VHotKey, VMap);
    end;
  end;
end;

function TMapTypeHotKeyListStatic.GetMapTypeGUIDByHotKey(
  AHotKey: TShortCut): IMapType;
begin
  Result := IMapType(FList.GetByID(AHotKey));
end;

end.
