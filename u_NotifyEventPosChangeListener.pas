{******************************************************************************}
{* SAS.������� (SAS.Planet)                                                   *}
{* Copyright (C) 2007-2011, ������ ��������� SAS.������� (SAS.Planet).        *}
{* ��� ��������� �������� ��������� ����������� ������������. �� ������       *}
{* �������������� �/��� �������������� � �������� �������� �����������       *}
{* ������������ �������� GNU, �������������� ������ ���������� ������������   *}
{* �����������, ������ 3. ��� ��������� ���������������� � �������, ��� ���   *}
{* ����� ��������, �� ��� ������ ��������, � ��� ����� ���������������        *}
{* �������� ��������� ��������� ��� ������� � �������� ��� ������˨�����      *}
{* ����������. �������� ����������� ������������ �������� GNU ������ 3, ���   *}
{* ��������� �������������� ����������. �� ������ ���� �������� �����         *}
{* ����������� ������������ �������� GNU ������ � ����������. � ������ �     *}
{* ����������, ���������� http://www.gnu.org/licenses/.                       *}
{*                                                                            *}
{* http://sasgis.ru/sasplanet                                                 *}
{* az@sasgis.ru                                                               *}
{******************************************************************************}

unit u_NotifyEventPosChangeListener;

interface

uses
  i_JclNotify,
  u_JclNotify,
  i_LocalCoordConverter,
  i_PosChangeMessage;

type
  TPosChangeNotifyEvent = procedure(ANewConverter: ILocalCoordConverter) of object;

  TPosChangeNotifyEventListener = class(TJclBaseListener)
  private
    FEvent: TPosChangeNotifyEvent;
  protected
    procedure DoEvent(AMessage: IPosChangeMessage); virtual;
    procedure Notification(msg: IJclNotificationMessage); override;
  public
    constructor Create(AEvent: TPosChangeNotifyEvent);
  end;

implementation

{ TPosChangeNotifyEventListener }

constructor TPosChangeNotifyEventListener.Create(AEvent: TPosChangeNotifyEvent);
begin
  FEvent := AEvent;
end;

procedure TPosChangeNotifyEventListener.DoEvent(AMessage: IPosChangeMessage);
begin
  if Assigned(FEvent) then begin
    FEvent(AMessage.GetVisualCoordConverter);
  end;
end;

procedure TPosChangeNotifyEventListener.Notification(
  msg: IJclNotificationMessage);
begin
  inherited;
  DoEvent(IPosChangeMessage(msg));
end;

end.
