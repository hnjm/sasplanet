unit i_IMainFormBehaviourByGPSConfig;

interface

uses
  i_IConfigDataElement;

type
  IMainFormBehaviourByGPSConfig = interface(IConfigDataElement)
    ['{2236C930-B6F6-4A6D-A8EB-FC83999973EA}']
    // ������� ����� ��� ��������� gps-���������
    function GetMapMove: Boolean;
    procedure SetMapMove(AValue: Boolean);
    property MapMove: Boolean read GetMapMove write SetMapMove;

    // ������������ ����� �� GPS �������
    function GetMapMoveCentered: Boolean;
    procedure SetMapMoveCentered(AValue: Boolean);
    property MapMoveCentered: Boolean read GetMapMoveCentered write SetMapMoveCentered;

    // ����������, �� ������� ������� ���������� ��������� GPS ��� �� ������� ���� �����
    function GetMinMoveDelta: Double;
    procedure SetMinMoveDelta(AValue: Double);
    property MinMoveDelta: Double read GetMinMoveDelta write SetMinMoveDelta;

    // ��������/���������� ������ �������� ��� �����������/���������� GPS
    function GetSensorsAutoShow: Boolean;
    procedure SetSensorsAutoShow(AValue: Boolean);
    property SensorsAutoShow: Boolean read GetSensorsAutoShow write SetSensorsAutoShow;

    // ������� ����� � �������������� ���� ������ ���� ������� ���� �������
    function GetProcessGPSIfActive: Boolean;
    procedure SetProcessGPSIfActive(AValue: Boolean);
    property ProcessGPSIfActive: Boolean read GetProcessGPSIfActive write SetProcessGPSIfActive;
  end;

implementation

end.
