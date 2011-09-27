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

unit i_MouseState;

interface

uses
  Types,
  Classes,
  Controls,
  t_GeoTypes;

type
  IMouseState = interface
    ['{10305260-821C-4867-9446-6EF3B6655AE5}']
    function GetCurentPos: TPoint;
    property CurentPos: TPoint read GetCurentPos;

    function GetCurentSpeed: TDoublePoint;
    property CurentSpeed: TDoublePoint read GetCurentSpeed;

    function GetCurrentShift: TShiftState;
    property CurrentShift: TShiftState read GetCurrentShift;

    function GetLastDownShift(AButton: TMouseButton): TShiftState;
    function GetLastDownPos(AButton: TMouseButton): TPoint;
    function GetLastUpShift(AButton: TMouseButton): TShiftState;
    function GetLastUpPos(AButton: TMouseButton): TPoint;
  end;

implementation

end.
