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

unit i_GeoCoder;

interface

uses
  ActiveX,
  t_GeoTypes,
  i_LocalCoordConverter;

type
  IGeoCodeResult = interface
    ['{C90929AD-3A6C-4906-A554-E1DA363ED060}']
    function GetSearchText: WideString; safecall;
    function GetResultCode: Integer; safecall;
    function GetMessage: WideString; safecall;
    function GetPlacemarks: IEnumUnknown; safecall;
    function GetPlacemarksCount: integer; safecall;
  end;

  IGeoCodePlacemark = interface
    ['{744CAB70-0466-433A-AF57-00BD5AFD9F45}']
    function GetPoint: TDoublePoint; safecall;
    function GetAddress: WideString; safecall;
    function GetDesc: WideString; safecall;
    function GetFullDesc: WideString; safecall;
    function GetAccuracy: Integer; safecall;
  end;

  IGeoCoder = interface
    ['{D9293293-080A-44B7-92F8-3093D35A551B}']
    function GetLocations(const ASearch: WideString; const ALocalConverter: ILocalCoordConverter): IGeoCodeResult; safecall;
  end;

implementation

end.
