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

unit i_MarkCategoryFactoryConfig;

interface

uses
  i_StringConfigDataElement,
  i_ConfigDataElement;

type
  IMarkCategoryFactoryConfig = interface(IConfigDataElement)
    ['{5F3F4E37-FF16-4DC6-8A37-ADB30868C2DA}']
    function GetDefaultName: IStringConfigDataElement;
    property DefaultName: IStringConfigDataElement read GetDefaultName;

    function GetAfterScale: Integer;
    procedure SetAfterScale(AValue: Integer);
    property AfterScale: Integer read GetAfterScale write SetAfterScale;

    function GetBeforeScale: Integer;
    procedure SetBeforeScale(AValue: Integer);
    property BeforeScale: Integer read GetBeforeScale write SetBeforeScale;
  end;

implementation

end.
