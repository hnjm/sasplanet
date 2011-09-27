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

unit i_MapLayerNavToPointMarkerConfig;

interface

uses
  i_ConfigDataElement,
  i_BitmapMarkerProviderSimpleConfig;

type
  IMapLayerNavToPointMarkerConfig = interface(IConfigDataElement)
    ['{7477526C-A086-41F6-9853-6992035DD10E}']
    function GetCrossDistInPixels: Double;
    procedure SetCrossDistInPixels(AValue: Double);
    property CrossDistInPixels: Double read GetCrossDistInPixels write SetCrossDistInPixels;

    function GetArrowMarkerConfig: IBitmapMarkerProviderSimpleConfig;
    property ArrowMarkerConfig: IBitmapMarkerProviderSimpleConfig read GetArrowMarkerConfig;

    function GetReachedMarkerConfig: IBitmapMarkerProviderSimpleConfig;
    property ReachedMarkerConfig: IBitmapMarkerProviderSimpleConfig read GetReachedMarkerConfig;
  end;

implementation

end.
