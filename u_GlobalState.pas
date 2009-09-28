unit u_GlobalState;

interface

uses
  Graphics,
  t_GeoTypes,
  u_GeoToStr,
  Uimgfun;
type
  TInetConnect = record
    proxyused,userwinset,uselogin:boolean;
    proxystr,loginstr,passstr:string;
  end;

  TMarksShowType = (mshAll = 1, mshChecked = 2, mshNone = 3);

  TGlobalState = class
  private

  public
    // ��������� ���������

    // �������� �� ���� ������ ��� ������ ���������
    WebReportToAuthor: Boolean;

    // ������ ����������� ����������, � � ��������� ��������
    num_format: TDistStrFormat;
    // ������ ����������� ��������� � ��������
    llStrType: TDegrShowFormat;
    // ���������� �������� ������ � ����������
    All_Dwn_Kb: Currency;

    InetConnect:TInetConnect;

    // ������ ����������� ��������
    Resampling: TTileResamplingType;
    //������ ������� ���� ��-���������.
    DefCache: byte;

    GPS_enab: Boolean;
    //�������� GPS COM �����
    GPS_BaudRate: Integer;
    //COM-����, � �������� ��������� GPS
    GPS_COM: string;
    //�������� GPS
    GPS_Correction: TExtendedPoint;
    //������ ��������� ����������� ��� GPS-���������
    GPS_ArrowSize: Integer;
    //���� ��������� ����������� ��� ���������
    GPS_ArrowColor: TColor;
    //���������� GPS ����
    GPS_ShowPath: Boolean;
    //������������ ����� �� GPS �������
    GPS_MapMove: Boolean;
    //��������� GPS ���� � ����
    GPS_WriteLog: boolean;
    //���� ��� ������ GPS ����� (����� ����� �������� ��������� ��������)
    GPS_LogFile: TextFile;
    //������ �� ��������� ��������� ����������� �� GPS
    GPS_ArrayOfSpeed: array of Real;
    //����� GPS �����
    GPS_TrackPoints: TExtendedPointArray;

    BorderColor: TColor;
    BorderAlpha: byte;

    MapZapColor:TColor;
    MapZapAlpha:byte;

    InvertColor: boolean;

    show_point: TMarksShowType;
    FirstLat: Boolean;
    ShowMapName: Boolean;

    //����������� ����� �� �����������
    CiclMap: Boolean;

    //������������ ����� ���������� ������� ��� �����������
    UsePrevZoom: Boolean;
    //������������� ����������� ��� ���� ������� �����
    MouseWheelInv: Boolean;
    //������������� ���
    AnimateZoom: Boolean;
    //��� ����������� ����� ������ �������� �������
    ShowBorderText: Boolean;


    //���� � ����� ������ �����
    NewCPath_: string;
    OldCPath_: string;
    ESCpath_: string;
    GMTilespath_: string;
    GECachepath_: string;

    //????
    ShowHintOnMarks: Boolean;

    // �������� ���������� ������ �������� ����

    FullScrean: Boolean;

    // ������� ����
    zoom_size: byte;

    // ��� ����� ���������
    zoom_mapzap: byte;


    constructor Create;

  end;

var
  GState: TGlobalState;
implementation

{ TGlobalState }

constructor TGlobalState.Create;
begin
  All_Dwn_Kb := 0;
end;

end.
