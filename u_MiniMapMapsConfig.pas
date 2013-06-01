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

unit u_MiniMapMapsConfig;

interface

uses
  i_Notifier,
  i_Listener,
  i_MapTypes,
  u_ActivMapWithLayers;

type
  TMiniMapMapsConfig = class(TActivMapWithLayers, IMapTypeChangeable)
  private
    FStatic: IMapType;
    FSelectedMapChangeListener: IListener;
    FMainMap: IMapTypeChangeable;
    FMainMapChangeListener: IListener;
    function CreateMiniMapMapsSet(const ASourceMapsSet: IMapTypeSet): IMapTypeSet;
    function CreateMiniMapLayersSet(const ASourceLayersSet: IMapTypeSet): IMapTypeSet;
    procedure OnMainMapChange;
    procedure OnSelectedChange(const AGUID: TGUID);
    procedure SetActiveMiniMap(const AValue: IMapType);
  private
    function GetStatic: IMapType;
  public
    constructor Create(
      const AMainMap: IMapTypeChangeable;
      const AMapsSet: IMapTypeSet;
      const ALayersSet: IMapTypeSet
    );
    destructor Destroy; override;
  end;

implementation

uses
  ActiveX,
  c_ZeroGUID,
  u_ListenerByEvent,
  u_NotifyWithGUIDEvent,
  u_MapTypeBasic,
  u_MapTypeSet;

{ TMiniMapMapsConfig }

constructor TMiniMapMapsConfig.Create(
  const AMainMap: IMapTypeChangeable;
  const AMapsSet: IMapTypeSet;
  const ALayersSet: IMapTypeSet
);
begin
  FMainMap := AMainMap;
  inherited Create(CreateMiniMapMapsSet(AMapsSet), CreateMiniMapLayersSet(ALayersSet));

  FMainMapChangeListener := TNotifyNoMmgEventListener.Create(Self.OnMainMapChange);
  FMainMap.ChangeNotifier.Add(FMainMapChangeListener);

  FSelectedMapChangeListener := TNotifyWithGUIDEventListener.Create(Self.OnSelectedChange);
  MainMapChangeNotyfier.Add(FSelectedMapChangeListener);

  OnSelectedChange(GetActiveMap.GetStatic.GUID);
end;

destructor TMiniMapMapsConfig.Destroy;
begin
  if Assigned(FMainMap) and Assigned(FMainMapChangeListener) then begin
    FMainMap.ChangeNotifier.Remove(FMainMapChangeListener);
    FMainMapChangeListener := nil;
  end;

  if Assigned(MainMapChangeNotyfier) and Assigned(FSelectedMapChangeListener) then begin
    MainMapChangeNotyfier.Remove(FSelectedMapChangeListener);
    FSelectedMapChangeListener := nil;
  end;

  FMainMap := nil;
  inherited;
end;

function TMiniMapMapsConfig.GetStatic: IMapType;
begin
  LockRead;
  try
    Result := FStatic;
  finally
    UnlockRead;
  end;
end;

function TMiniMapMapsConfig.CreateMiniMapLayersSet(const ASourceLayersSet: IMapTypeSet): IMapTypeSet;
var
  VMap: IMapType;
  VList: TMapTypeSet;
  VEnun: IEnumGUID;
  VGUID: TGUID;
  i: Cardinal;
begin
  VList := TMapTypeSet.Create(True);
  Result := VList;
  VEnun := ASourceLayersSet.GetIterator;
  while VEnun.Next(1, VGUID, i) = S_OK do begin
    VMap := ASourceLayersSet.GetMapTypeByGUID(VGUID);
    if VMap.MapType.Abilities.IsShowOnSmMap and VMap.MapType.IsBitmapTiles then begin
      VList.Add(VMap);
    end;
  end;
end;

function TMiniMapMapsConfig.CreateMiniMapMapsSet(const ASourceMapsSet: IMapTypeSet): IMapTypeSet;
var
  VMap: IMapType;
  VList: TMapTypeSet;
  VEnun: IEnumGUID;
  VGUID: TGUID;
  i: Cardinal;
begin
  VList := TMapTypeSet.Create(True);
  Result := VList;
  VList.Add(TMapTypeBasic.Create(nil));
  VEnun := ASourceMapsSet.GetIterator;
  while VEnun.Next(1, VGUID, i) = S_OK do begin
    VMap := ASourceMapsSet.GetMapTypeByGUID(VGUID);
    if VMap.MapType.Abilities.IsShowOnSmMap and VMap.MapType.IsBitmapTiles then begin
      VList.Add(VMap);
    end;
  end;
end;

procedure TMiniMapMapsConfig.OnMainMapChange;
var
  VMapType: IMapType;
begin
  VMapType := GetActiveMap.GetStatic;
  if IsEqualGUID(VMapType.GUID, CGUID_Zero) then begin
    SetActiveMiniMap(FMainMap.GetStatic);
  end;
end;

procedure TMiniMapMapsConfig.OnSelectedChange(const AGUID: TGUID);
begin
  if IsEqualGUID(AGUID, CGUID_Zero) then begin
    SetActiveMiniMap(FMainMap.GetStatic);
  end else begin
    SetActiveMiniMap(GetMapsSet.GetMapTypeByGUID(AGUID));
  end;
end;

procedure TMiniMapMapsConfig.SetActiveMiniMap(const AValue: IMapType);
begin
  LockWrite;
  try
    if FStatic <> AValue then begin
      FStatic := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

end.
