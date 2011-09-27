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

unit u_ConfigSaveLoadStrategyBasicUseProvider;

interface

uses
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_ConfigDataElement,
  i_ConfigSaveLoadStrategy;

type
  TConfigSaveLoadStrategyBasicUseProvider = class(TInterfacedObject, IConfigSaveLoadStrategy)
  protected
    procedure WriteConfig(
      AProvider: IConfigDataWriteProvider;
      AElement: IConfigDataElement
    );
    procedure ReadConfig(
      AProvider: IConfigDataProvider;
      AElement: IConfigDataElement
    );
  end;

implementation

{ TConfigSaveLoadStrategyBasicUseProvider }

procedure TConfigSaveLoadStrategyBasicUseProvider.ReadConfig(
  AProvider: IConfigDataProvider; AElement: IConfigDataElement);
begin
  AElement.ReadConfig(AProvider);
end;

procedure TConfigSaveLoadStrategyBasicUseProvider.WriteConfig(
  AProvider: IConfigDataWriteProvider; AElement: IConfigDataElement);
begin
  AElement.WriteConfig(AProvider);
end;

end.
