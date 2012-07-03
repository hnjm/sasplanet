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

unit u_NotifyWithGUIDEvent;

interface

uses
  i_Notifier,
  i_Listener,
  u_Notifier;

type
  TNotifyWithGUIDEvent = procedure(const AGUID: TGUID) of object;

type
  INotificationMessageWithGUID = interface
    ['{1C88C4F8-5990-42DA-A841-CB9597C97AB6}']
    function GetGUID: TGUID;
  end;

type
  TNotificationMessageWithGUID = class(TInterfacedObject, INotificationMessageWithGUID)
  private
    FGUID: TGUID;
  protected
    function GetGUID: TGUID;
  public
    constructor Create(const AGUID: TGUID);
  end;

type
  TNotifyWithGUIDEventListener = class(TInterfacedObject, IListener)
  private
    FEvent: TNotifyWithGUIDEvent;
  protected
    procedure Notification(const msg: IInterface);
  public
    constructor Create(AEvent: TNotifyWithGUIDEvent);
  end;

type
  INotifierWithGUID = interface(INotifier)
    ['{7160ECC8-5A85-445C-8655-5E5574E60C88}']
    procedure NotifyByGUID(const AGUID: TGUID);
  end;

type
  TNotifierWithGUID = class(TNotifierBase, INotifierWithGUID)
  protected
    procedure NotifyByGUID(const AGUID: TGUID);
  end;

implementation

{ TNotificationMessageWithGUID }

constructor TNotificationMessageWithGUID.Create(const AGUID: TGUID);
begin
  inherited Create;
  FGUID := AGUID;
end;

function TNotificationMessageWithGUID.GetGUID: TGUID;
begin
  Result := FGUID;
end;

{ TNotifyWithGUIDEventListener }

constructor TNotifyWithGUIDEventListener.Create(AEvent: TNotifyWithGUIDEvent);
begin
  inherited Create;
  FEvent := AEvent;
end;

procedure TNotifyWithGUIDEventListener.Notification(
  const msg: IInterface
);
begin
  FEvent(INotificationMessageWithGUID(msg).GetGUID);
end;

{ TNotifierWithGUID }

procedure TNotifierWithGUID.NotifyByGUID(const AGUID: TGUID);
var
  msg: INotificationMessageWithGUID;
begin
  msg := TNotificationMessageWithGUID.Create(AGUID);
  Notify(msg);
end;

end.
