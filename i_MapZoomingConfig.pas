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

unit i_MapZoomingConfig;

interface

uses
  i_ConfigDataElement;

type
  IMapZoomingConfig = interface(IConfigDataElement)
    ['{A322104E-A247-4EB3-83F6-C897F64E764C}']
    // ����������� ����� ��������� �������� ��� �������� ����
    function GetZoomingAtMousePos: Boolean;
    procedure SetZoomingAtMousePos(AValue: Boolean);
    property ZoomingAtMousePos: Boolean read GetZoomingAtMousePos write SetZoomingAtMousePos;

    //������������� ���
    function GetAnimateZoom: Boolean;
    procedure SetAnimateZoom(AValue: Boolean);
    property AnimateZoom: Boolean read GetAnimateZoom write SetAnimateZoom;

    function GetAnimateZoomTime: Cardinal;
    procedure SetAnimateZoomTime(AValue: Cardinal);
    property AnimateZoomTime: Cardinal read GetAnimateZoomTime write SetAnimateZoomTime;
  end;

implementation

end.
