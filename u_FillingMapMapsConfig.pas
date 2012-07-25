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

unit u_FillingMapMapsConfig;

interface

uses
  i_Notifier,
  i_Listener,
  i_ActiveMapsConfig,
  i_MapTypes,
  i_FillingMapLayerConfig,
  u_MainActiveMap;

type
  TFillingMapMapsConfig = class(TMainActiveMap, IFillingMapMapsConfig)
  private
    FActualMap: IMapType;
    FSelectedMapChangeListener: IListener;
    FMainMap: IMapTypeChangeable;
    FMainMapChangeListener: IListener;
    function CreateMapsSet(const ASourceMapsSet: IMapTypeSet): IMapTypeSet;
    procedure OnMainMapChange;
    procedure OnSelectedChange(const AGUID: TGUID);
    procedure SetActualMap(const AValue: IMapType);
  private
    function GetActualMap: IMapType;
  public
    constructor Create(
      const AMainMap: IMapTypeChangeable;
      const AMapsSet: IMapTypeSet
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

{ TFillingMapMapsConfig }

constructor TFillingMapMapsConfig.Create(
  const AMainMap: IMapTypeChangeable;
  const AMapsSet: IMapTypeSet
);
begin
  FMainMap := AMainMap;
  inherited Create(CreateMapsSet(AMapsSet));

  FMainMapChangeListener := TNotifyNoMmgEventListener.Create(Self.OnMainMapChange);
  FMainMap.ChangeNotifier.Add(FMainMapChangeListener);

  FSelectedMapChangeListener := TNotifyWithGUIDEventListener.Create(Self.OnSelectedChange);
  MainMapChangeNotyfier.Add(FSelectedMapChangeListener);

  SetActualMap(FMainMap.GetStatic);
end;

destructor TFillingMapMapsConfig.Destroy;
begin
  FMainMap.ChangeNotifier.Remove(FMainMapChangeListener);
  FMainMapChangeListener := nil;

  MainMapChangeNotyfier.Remove(FSelectedMapChangeListener);
  FSelectedMapChangeListener := nil;

  FMainMap := nil;
  inherited;
end;

function TFillingMapMapsConfig.CreateMapsSet(const ASourceMapsSet: IMapTypeSet): IMapTypeSet;
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
    VList.Add(VMap);
  end;
end;

function TFillingMapMapsConfig.GetActualMap: IMapType;
begin
  LockRead;
  try
    Result := FActualMap;
  finally
    UnlockRead;
  end;
end;

procedure TFillingMapMapsConfig.OnMainMapChange;
var
  VMapType: IMapType;
begin
  VMapType := GetActiveMap.GetStatic;
  if IsEqualGUID(VMapType.GUID, CGUID_Zero) then begin
    SetActualMap(FMainMap.GetStatic);
  end;
end;

procedure TFillingMapMapsConfig.OnSelectedChange(const AGUID: TGUID);
begin
  if IsEqualGUID(AGUID, CGUID_Zero) then begin
    SetActualMap(FMainMap.GetStatic);
  end else begin
    SetActualMap(GetMapsSet.GetMapTypeByGUID(AGUID));
  end;
end;

procedure TFillingMapMapsConfig.SetActualMap(const AValue: IMapType);
begin
  LockWrite;
  try
    if FActualMap <> AValue then begin
      FActualMap := AValue;
      inherited SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

end.
