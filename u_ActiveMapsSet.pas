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

unit u_ActiveMapsSet;

interface

uses
  i_Notifier,
  i_Listener,
  i_MapTypes,
  u_ConfigDataElementBase;

type
  TLayerSetChangeable = class(TConfigDataElementBaseEmptySaveLoad, IMapTypeSetChangeable)
  private
    FMapsSet: IMapTypeSet;

    FStatic: IMapTypeSet;

    FLayerSetSelectNotyfier: INotifier;
    FLayerSetUnselectNotyfier: INotifier;

    FLayerSetSelectListener: IListener;
    FLayerSetUnselectListener: IListener;

    procedure OnLayerSetSelect(const AGUID: TGUID);
    procedure OnLayerSetUnselect(const AGUID: TGUID);
  private
    function GetStatic: IMapTypeSet;
  public
    constructor Create(
      const AMapsSet: IMapTypeSet;
      const ALayerSetSelectNotyfier: INotifier;
      const ALayerSetUnselectNotyfier: INotifier
    );
    destructor Destroy; override;
  end;

  TMapsSetChangeableByMainMapAndLayersSet = class(TConfigDataElementWithStaticBaseEmptySaveLoad, IMapTypeSetChangeable)
  private
    FMainMap: IMapTypeChangeable;
    FLayersSet: IMapTypeSetChangeable;

    FMainMapListener: IListener;
    FLayerSetListener: IListener;

    procedure OnMainMapChange;
    procedure OnLayersSetChange;
  protected
    function CreateStatic: IInterface; override;
  private
    function GetStatic: IMapTypeSet;
  public
    constructor Create(
      const AMainMap: IMapTypeChangeable;
      const ALayersSet: IMapTypeSetChangeable
    );
    destructor Destroy; override;
  end;

implementation

uses
  ActiveX,
  u_MapTypeSet,
  u_ListenerByEvent,
  u_NotifyWithGUIDEvent;

{ TActiveMapsSet }

constructor TLayerSetChangeable.Create(
  const AMapsSet: IMapTypeSet;
  const ALayerSetSelectNotyfier, ALayerSetUnselectNotyfier: INotifier
);
begin
  Assert(ALayerSetSelectNotyfier <> nil);
  Assert(ALayerSetUnselectNotyfier <> nil);
  inherited Create;
  FMapsSet := AMapsSet;
  FStatic := TMapTypeSet.Create(True);

  FLayerSetSelectNotyfier := ALayerSetSelectNotyfier;
  if FLayerSetSelectNotyfier <> nil then begin
    FLayerSetSelectListener := TNotifyWithGUIDEventListener.Create(Self.OnLayerSetSelect);
    FLayerSetSelectNotyfier.Add(FLayerSetSelectListener);
  end;

  FLayerSetUnselectNotyfier := ALayerSetUnselectNotyfier;
  if FLayerSetUnselectNotyfier <> nil then begin
    FLayerSetUnselectListener := TNotifyWithGUIDEventListener.Create(Self.OnLayerSetUnselect);
    FLayerSetUnselectNotyfier.Add(FLayerSetUnselectListener);
  end;
end;

destructor TLayerSetChangeable.Destroy;
begin
  if FLayerSetSelectNotyfier <> nil then begin
    FLayerSetSelectNotyfier.Remove(FLayerSetSelectListener);
  end;
  FLayerSetSelectListener := nil;
  FLayerSetSelectNotyfier := nil;

  if FLayerSetUnselectNotyfier <> nil then begin
    FLayerSetUnselectNotyfier.Remove(FLayerSetUnselectListener);
  end;
  FLayerSetUnselectListener := nil;
  FLayerSetUnselectNotyfier := nil;

  inherited;
end;

function TLayerSetChangeable.GetStatic: IMapTypeSet;
begin
  LockRead;
  try
    Result := FStatic;
  finally
    UnlockRead;
  end;
end;

procedure TLayerSetChangeable.OnLayerSetSelect(const AGUID: TGUID);
var
  VMapType: IMapType;
  VList: TMapTypeSet;
  VEnun: IEnumGUID;
  VGUID: TGUID;
  i: Cardinal;
begin
  VMapType := FMapsSet.GetMapTypeByGUID(AGUID);
  if VMapType <> nil then begin
    LockWrite;
    try
      if FStatic.GetMapTypeByGUID(AGUID) = nil then begin
        VList := TMapTypeSet.Create(True);
        VEnun := FStatic.GetIterator;
        while VEnun.Next(1, VGUID, i) = S_OK do begin
          VList.Add(FMapsSet.GetMapTypeByGUID(VGUID));
        end;
        VList.Add(VMapType);
        FStatic := VList;
        SetChanged;
      end;
    finally
      UnlockWrite;
    end;
  end;
end;

procedure TLayerSetChangeable.OnLayerSetUnselect(const AGUID: TGUID);
var
  VMapType: IMapType;
  VList: TMapTypeSet;
  VEnun: IEnumGUID;
  VGUID: TGUID;
  i: Cardinal;
begin
  VMapType := FMapsSet.GetMapTypeByGUID(AGUID);
  if VMapType <> nil then begin
    LockWrite;
    try
      if FStatic.GetMapTypeByGUID(AGUID) <> nil then begin
        VList := TMapTypeSet.Create(True);
        VEnun := FStatic.GetIterator;
        while VEnun.Next(1, VGUID, i) = S_OK do begin
          if not IsEqualGUID(VGUID, AGUID) then begin
            VList.Add(FMapsSet.GetMapTypeByGUID(VGUID));
          end;
        end;
        FStatic := VList;
        SetChanged;
      end;
    finally
      UnlockWrite;
    end;
  end;
end;

{ TMapsSetChangeableByMainMapAndLayersSet }

constructor TMapsSetChangeableByMainMapAndLayersSet.Create(
  const AMainMap: IMapTypeChangeable;
  const ALayersSet: IMapTypeSetChangeable
);
begin
  inherited Create;
  FMainMap := AMainMap;
  FLayersSet := ALayersSet;

  FMainMapListener := TNotifyNoMmgEventListener.Create(Self.OnMainMapChange);
  FMainMap.ChangeNotifier.Add(FMainMapListener);

  FLayerSetListener := TNotifyNoMmgEventListener.Create(Self.OnLayersSetChange);
  FLayersSet.ChangeNotifier.Add(FLayerSetListener);
end;

function TMapsSetChangeableByMainMapAndLayersSet.CreateStatic: IInterface;
var
  VLayersSet: IMapTypeSet;
  VList: TMapTypeSet;
  VEnun: IEnumGUID;
  VGUID: TGUID;
  i: Cardinal;
  VStatic: IMapTypeSet;
begin
  VLayersSet := FLayersSet.GetStatic;
  VList := TMapTypeSet.Create(True);
  VStatic := VList;
  VEnun := VLayersSet.GetIterator;
  while VEnun.Next(1, VGUID, i) = S_OK do begin
    VList.Add(VLayersSet.GetMapTypeByGUID(VGUID));
  end;
  VList.Add(FMainMap.GetStatic);
  Result := VStatic;
end;

destructor TMapsSetChangeableByMainMapAndLayersSet.Destroy;
begin
  if FMainMap <> nil then begin
    FMainMap.ChangeNotifier.Remove(FMainMapListener);
  end;
  FMainMap := nil;
  FMainMapListener := nil;

  if FLayersSet <> nil then begin
    FLayersSet.ChangeNotifier.Remove(FLayerSetListener);
  end;
  FLayersSet := nil;
  FLayerSetListener := nil;

  inherited;
end;

function TMapsSetChangeableByMainMapAndLayersSet.GetStatic: IMapTypeSet;
begin
  Result := IMapTypeSet(GetStaticInternal);
end;

procedure TMapsSetChangeableByMainMapAndLayersSet.OnLayersSetChange;
begin
  LockWrite;
  try
    SetChanged;
  finally
    UnlockWrite;
  end;
end;

procedure TMapsSetChangeableByMainMapAndLayersSet.OnMainMapChange;
begin
  LockWrite;
  try
    SetChanged;
  finally
    UnlockWrite;
  end;
end;

end.
