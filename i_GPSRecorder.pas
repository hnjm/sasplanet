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

unit i_GPSRecorder;

interface

uses
  t_GeoTypes,
  i_GPS,
  i_ConfigDataElement;

type
  TGPSTrackPoint = record
    Point: TDoublePoint;
    Speed: Double;
    Time: TDateTime;
  end;

  TGPSTrackPointArray = array of TGPSTrackPoint;

  IGPSRecorder = interface(IConfigDataElement)
    ['{E8525CFD-243B-4454-82AA-C66108A74B8F}']
    procedure AddPoint(APosition: IGPSPosition);
    procedure AddEmptyPoint;
    procedure ClearTrack;
    function IsEmpty: Boolean;
    function LastPoints(const AMaxCount: Integer; var APoints: TGPSTrackPointArray): Integer;
    function GetAllPoints: TArrayOfDoublePoint;
    function GetAllTracPoints: TGPSTrackPointArray;

    function GetOdometer1: Double;
    property Odometer1: Double read GetOdometer1;
    procedure ResetOdometer1;

    function GetOdometer2: Double;
    property Odometer2: Double read GetOdometer2;
    procedure ResetOdometer2;

    function GetDist: Double;
    property Dist: Double read GetDist;
    procedure ResetDist;

    function GetMaxSpeed: Double;
    property MaxSpeed: Double read GetMaxSpeed;
    procedure ResetMaxSpeed;

    function GetAvgSpeed: Double;
    property AvgSpeed: Double read GetAvgSpeed;
    procedure ResetAvgSpeed;

    function GetLastSpeed: Double;
    property LastSpeed: Double read GetLastSpeed;

    function GetLastAltitude: Double;
    property LastAltitude: Double read GetLastAltitude;

    function GetLastHeading: Double;
    property LastHeading: Double read GetLastHeading;

    function GetLastPosition: TDoublePoint;
    property LastPosition: TDoublePoint read GetLastPosition;

    function GetCurrentPosition: IGPSPosition;
    property CurrentPosition: IGPSPosition read GetCurrentPosition;
  end;

implementation

end.
