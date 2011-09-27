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

unit i_KmlLayerConfig;

interface

uses
  GR32,
  i_ConfigDataElement;

type
  IKmlLayerConfig = interface(IConfigDataElement)
    ['{6EA3D5D6-3D9D-40DB-AD53-989920190477}']
    function GetMainColor: TColor32;
    procedure SetMainColor(AValue: TColor32);
    property MainColor: TColor32 read GetMainColor write SetMainColor;

    function GetPointColor: TColor32;
    procedure SetPointColor(AValue: TColor32);
    property PointColor: TColor32 read GetPointColor write SetPointColor;

    function GetShadowColor: TColor32;
    procedure SetShadowColor(AValue: TColor32);
    property ShadowColor: TColor32 read GetShadowColor write SetShadowColor;
  end;

implementation

end.
