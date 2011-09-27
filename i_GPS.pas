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

unit i_GPS;

interface

uses
  t_GeoTypes;

type
  IGPSSatelliteInfo = interface
    ['{38C3C77F-DAC8-4187-B243-0F7001A7DF9B}']
    function GetPseudoRandomCode: Integer; stdcall;
    function GetElevation: Integer; stdcall;
    function GetAzimuth: Integer; stdcall;
    function GetSignalToNoiseRatio: Integer; stdcall;
    function GetIsFix: Boolean; stdcall;

    property PseudoRandomCode: Integer read GetPseudoRandomCode;
    property Elevation: Integer read GetElevation;
    property Azimuth: Integer read GetAzimuth;
    property SignalToNoiseRatio: Integer read GetSignalToNoiseRatio;
    property IsFix: Boolean read GetIsFix;
  end;

  IGPSSatellitesInView = interface
    ['{D8744967-74EB-47A1-A8FD-4626B5CD2B20}']
    function GetCount: Integer; stdcall;
    function GetFixCount: Integer; stdcall;
    function GetItem(AIndex: Integer): IGPSSatelliteInfo; stdcall;

    property Count: Integer read GetCount;
    property FixCount: Integer read GetFixCount;
    property Item[Idx: Integer]: IGPSSatelliteInfo read GetItem;
  end;

  IGPSPosition = interface
    ['{B2422759-9B8B-4CC5-AAA5-46A7240759D0}']
    function GetPosition: TDoublePoint; stdcall;
    function GetAltitude: Double; stdcall;
    function GetSpeed_KMH: Double; stdcall;
    function GetHeading: Double; stdcall;
    function GetUTCDateTime: TDateTime; stdcall;
    function GetLocalDateTime: TDateTime; stdcall;
    function GetIsFix: Word; stdcall;
    function GetHDOP: Double; stdcall;
    function GetVDOP: Double; stdcall;
    function GetPDOP: Double; stdcall;
    function GetSatellites: IGPSSatellitesInView; stdcall;

    property Position: TDoublePoint read GetPosition;
    property Altitude: Double read GetAltitude;
    property Speed_KMH: Double read GetSpeed_KMH;
    property Heading: Double read GetHeading;
    property UTCDateTime: TDateTime read GetUTCDateTime;
    property LocalDateTime: TDateTime read GetLocalDateTime;
    property IsFix: Word read GetIsFix;
    property HDOP: Double read GetHDOP;
    property VDOP: Double read GetVDOP;
    property PDOP: Double read GetPDOP;
    property Satellites: IGPSSatellitesInView  read GetSatellites;
  end;

implementation

end.
