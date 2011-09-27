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

unit i_NavigationToPoint;

interface

uses
  t_GeoTypes,
  i_MarksSimple,
  i_ConfigDataElement;

type
  INavigationToPoint = interface(IConfigDataElement)
    ['{61EBB721-A3D9-402B-ACDC-FF3E2DA5C262}']
    function GetIsActive: Boolean;
    property IsActive: Boolean read GetIsActive;

    function GetMarkId: IMarkID;
    property MarkId: IMarkID read GetMarkId;

    function GetLonLat: TDoublePoint;
    property LonLat: TDoublePoint read GetLonLat;

    procedure StartNavToMark(AMarkId: IMarkID; APointLonLat: TDoublePoint);
    procedure StartNavLonLat(APointLonLat: TDoublePoint);
    procedure StopNav;
  end;
implementation

end.
