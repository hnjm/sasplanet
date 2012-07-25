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

unit u_ActiveMapConfig;

interface

uses
  Windows,
  SysUtils,
  i_Notifier,
  i_Listener,
  i_GUIDSet,
  i_MapTypes,
  i_ActiveMapsConfig,
  u_ConfigDataElementBase;

type
  TMapTypeChangeableByNotifier = class(TConfigDataElementBaseEmptySaveLoad, IMapTypeChangeable)
  private
    FMapsSet: IMapTypeSet;
    FStatic: IMapType;
  private
    FMainMapChangeNotyfier: INotifier;
    FMainMapListener: IListener;
    procedure OnMainMapChange(const AGUID: TGUID);
  private
    function GetStatic: IMapType;
  public
    constructor Create(
      const AMainMapChangeNotyfier: INotifier;
      const AMapsSet: IMapTypeSet
    );
    destructor Destroy; override;
  end;

implementation

uses
  ActiveX,
  c_ZeroGUID,
  u_NotifyWithGUIDEvent;

{ TActiveMapConfigNew }

constructor TMapTypeChangeableByNotifier.Create(
  const AMainMapChangeNotyfier: INotifier;
  const AMapsSet: IMapTypeSet
);
var
  i: Cardinal;
  VGUID: TGUID;
begin
  inherited Create;
  FMapsSet := AMapsSet;
  FMainMapChangeNotyfier := AMainMapChangeNotyfier;
  FMainMapListener := TNotifyWithGUIDEventListener.Create(Self.OnMainMapChange);
  FMainMapChangeNotyfier.Add(FMainMapListener);
  if FMapsSet.GetIterator.Next(1, VGUID, i) <> S_OK then begin
    raise Exception.Create('Empty maps list');
  end;
  FStatic := FMapsSet.GetMapTypeByGUID(VGUID);
end;

destructor TMapTypeChangeableByNotifier.Destroy;
begin
  FMainMapChangeNotyfier.Remove(FMainMapListener);
  FMainMapListener := nil;
  FMainMapChangeNotyfier := nil;
  FMapsSet := nil;
  inherited;
end;

function TMapTypeChangeableByNotifier.GetStatic: IMapType;
begin
  LockRead;
  try
    Result := FStatic;
  finally
    UnlockRead;
  end;
end;

procedure TMapTypeChangeableByNotifier.OnMainMapChange(const AGUID: TGUID);
var
  VGUID: TGUID;
  VMapType: IMapType;
begin
  LockWrite;
  try
    VGUID := FStatic.GUID;
    if not IsEqualGUID(VGUID, AGUID) then begin
      VMapType := FMapsSet.GetMapTypeByGUID(AGUID);
      if VMapType <> nil then begin
        FStatic := VMapType;
        SetChanged;
      end;
    end;
  finally
    UnlockWrite;
  end;
end;

end.
