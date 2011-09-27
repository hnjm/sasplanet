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

unit i_ProxySettings;

interface

uses
  i_ConfigDataElement;

type
  // ��������� ������
  IProxySettings = interface(IInterface)
    ['{17F31D40-FCA0-4525-9820-A14BB61AA08A}']
    function GetUseProxy(): boolean; safecall;
    property UseProxy: boolean read GetUseProxy;

    function GetHost(): WideString; safecall;
    property Host: WideString read GetHost;

    function GetUseLogin(): boolean; safecall;
    property UseLogin: boolean read GetUseLogin;

    function GetLogin(): WideString; safecall;
    property Login: WideString read GetLogin;

    function GetPassword(): WideString; safecall;
    property Password: WideString read GetPassword;
  end;

  IProxyConfigStatic = interface(IInterface)
    ['{DD723CA2-3A8F-4350-B04E-284B00AC47EA}']
    function GetUseIESettings: Boolean;
    property UseIESettings: Boolean read GetUseIESettings;

    function GetUseProxy(): boolean;
    property UseProxy: boolean read GetUseProxy;

    function GetHost(): WideString;
    property Host: WideString read GetHost;

    function GetUseLogin(): boolean;
    property UseLogin: boolean read GetUseLogin;

    function GetLogin(): WideString;
    property Login: WideString read GetLogin;

    function GetPassword(): WideString;
    property Password: WideString read GetPassword;
  end;

  IProxyConfig = interface(IConfigDataElement)
  ['{0CE5A97E-471D-4A3E-93E3-D130DD1F50F5}']
    function GetUseIESettings: Boolean; safecall;
    procedure SetUseIESettings(AValue: Boolean);
    property UseIESettings: Boolean read GetUseIESettings write SetUseIESettings;

    function GetUseProxy(): Boolean; safecall;
    procedure SetUseProxy(AValue: Boolean);
    property UseProxy: boolean read GetUseProxy write SetUseProxy;

    function GetHost(): WideString; safecall;
    procedure SetHost(AValue: WideString);
    property Host: WideString read GetHost write SetHost;

    function GetUseLogin(): boolean; safecall;
    procedure SetUseLogin(AValue: Boolean);
    property UseLogin: boolean read GetUseLogin write SetUseLogin;

    function GetLogin(): WideString; safecall;
    procedure SetLogin(AValue: WideString);
    property Login: WideString read GetLogin write SetLogin;

    function GetPassword(): WideString; safecall;
    procedure SetPassword(AValue: WideString);
    property Password: WideString read GetPassword write SetPassword;

    function GetStatic: IProxyConfigStatic;
  end;

implementation

end.
