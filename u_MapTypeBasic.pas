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

unit u_MapTypeBasic;

interface

uses
  u_MapType,
  i_MapTypes;

type
  TMapTypeBasic = class(TInterfacedObject, IMapType)
  private
    FMapType: TMapType;
  protected
    function GetMapType: TMapType;
    function GetGUID: TGUID;
  public
    constructor Create(AMapType: TMapType);
  end;

implementation

uses
  c_ZeroGUID;

{ TMapTypeBasic }

constructor TMapTypeBasic.Create(AMapType: TMapType);
begin
  FMapType := AMapType;
end;

function TMapTypeBasic.GetGUID: TGUID;
begin
  if FMapType <> nil then begin
    Result := FMapType.Zmp.GUID;
  end else begin
    Result := CGUID_Zero;
  end;
end;

function TMapTypeBasic.GetMapType: TMapType;
begin
  Result := FMapType;
end;

end.
 