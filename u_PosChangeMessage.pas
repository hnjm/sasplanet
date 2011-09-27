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

unit u_PosChangeMessage;

interface

uses
  Types,
  u_JclNotify,
  i_LocalCoordConverter,
  i_PosChangeMessage;

type
  TPosChangeMessage = class(TJclBaseNotificationMessage, IPosChangeMessage)
  private
    FVisualCoordConverter: ILocalCoordConverter;
    function GetVisualCoordConverter: ILocalCoordConverter; stdcall;
  public
    constructor Create(
      AVisuzlCoordConverter: ILocalCoordConverter
    );
  end;

implementation

{ TPosChangeMessage }

constructor TPosChangeMessage.Create(
  AVisuzlCoordConverter: ILocalCoordConverter
);
begin
  FVisualCoordConverter := AVisuzlCoordConverter;
end;

function TPosChangeMessage.GetVisualCoordConverter: ILocalCoordConverter;
begin
  Result := FVisualCoordConverter;
end;

end.
 