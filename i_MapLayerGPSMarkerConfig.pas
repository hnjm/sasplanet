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

unit i_MapLayerGPSMarkerConfig;

interface

uses
  i_ConfigDataElement,
  i_BitmapMarkerProviderSimpleConfig;

type
  IMapLayerGPSMarkerConfig = interface(IConfigDataElement)
    ['{A8E08D39-7805-4A4C-AD78-F8CAD66919C7}']
    function GetMinMoveSpeed: Double;
    procedure SetMinMoveSpeed(AValue: Double);
    property MinMoveSpeed: Double read GetMinMoveSpeed write SetMinMoveSpeed;

    function GetMovedMarkerConfig: IBitmapMarkerProviderSimpleConfig;
    property MovedMarkerConfig: IBitmapMarkerProviderSimpleConfig read GetMovedMarkerConfig;

    function GetStopedMarkerConfig: IBitmapMarkerProviderSimpleConfig;
    property StopedMarkerConfig: IBitmapMarkerProviderSimpleConfig read GetStopedMarkerConfig;
  end;

implementation

end.
