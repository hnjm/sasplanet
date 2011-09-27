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

unit u_GPSModuleFactoryByZylGPS;

interface

uses
  i_GPSPositionFactory,
  i_GPSModuleByCOM,
  i_GPSModuleByCOMFactory;

type
  TGPSModuleFactoryByZylGPS = class(TInterfacedObject, IGPSModuleByCOMFactory)
  private
    FGPSPositionFactory: IGPSPositionFactory;
  protected
    function CreateGPSModule: IGPSModuleByCOM;
  public
    constructor Create(AGPSPositionFactory: IGPSPositionFactory);
  end;

implementation

uses
  u_GPSModuleByZylGPS;

{ TGPSModuleFactoryByZylGPS }

constructor TGPSModuleFactoryByZylGPS.Create(
  AGPSPositionFactory: IGPSPositionFactory);
begin
  FGPSPositionFactory := AGPSPositionFactory;
end;

function TGPSModuleFactoryByZylGPS.CreateGPSModule: IGPSModuleByCOM;
begin
  Result := TGPSModuleByZylGPS.Create(FGPSPositionFactory);
end;

end.
