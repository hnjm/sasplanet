unit u_GlobalState;

interface

uses
  Graphics,
  t_GeoTypes,
  u_GeoToStr,
  Uimgfun,
  u_MemFileCache;
type
  TInetConnect = record
    proxyused,userwinset,uselogin:boolean;
    proxystr,loginstr,passstr:string;
  end;

  TMarksShowType = (mshAll = 1, mshChecked = 2, mshNone = 3);

  TGlobalState = class
  private
    function GetMarkIconsPath: string;
    function GetMarksFileName: string;
    function GetMarksBackUpFileName: string;
    function GetMarksCategoryBackUpFileName: string;
    function GetMarksCategoryFileName: string;
    function GetMapsPath: string;
    function GetTrackLogPath: string;
    function GetHelpFileName: string;

  public
    MainFileCache: TMemFileCache;

    // ��������� ���������
    ProgramPath: string;

    // �������� �� ���� ������ ��� ������ ���������
    WebReportToAuthor: Boolean;

    // ������ ����������� ����������, � � ��������� ��������
    num_format: TDistStrFormat;
    // ������ ����������� ��������� � ��������
    llStrType: TDegrShowFormat;
    // ���������� �������� ������ � ����������
    All_Dwn_Kb: Currency;
    // ���������� ��������� ������
    All_Dwn_Tiles: Cardinal;

    InetConnect:TInetConnect;
    //���������� ���������� � ������ ������������� �� �������
    SaveTileNotExists: Boolean;
    // ������ ������ ������� ������� ���� ��� ������ ����������
    TwoDownloadAttempt: Boolean;
    // ���������� � ���������� ����� ���� ��������� ������ �������
    GoNextTileIfDownloadError: Boolean;

    // ������ ����������� ��������
    Resampling: TTileResamplingType;
    //������ ������� ���� ��-���������.
    DefCache: byte;

    GPS_enab: Boolean;

    //COM-����, � �������� ��������� GPS
    GPS_COM: string;
    //�������� GPS COM �����
    GPS_BaudRate: Integer;
    // ������������ ����� �������� ������ �� GPS
    GPS_TimeOut: integer;
    // �������� ����� ������� �� GPS
    GPS_Delay: Integer;
    //�������� GPS
    GPS_Correction: TExtendedPoint;
    //������ ��������� ����������� ��� GPS-���������
    GPS_ArrowSize: Integer;
    //���� ��������� ����������� ��� ���������
    GPS_ArrowColor: TColor;
    //���������� GPS ����
    GPS_ShowPath: Boolean;
    // ������� ������������ GPS �����
    GPS_TrackWidth: Integer;
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

    // ���������� ������ ������������ �� �������� ������
    TilesOut: Integer;

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

    // ���������� ����� ��� ���������� ���� ��� ������
    ShowHintOnMarks: Boolean;

    // �������� ���������� ������ �������� ����

    FullScrean: Boolean;

    // ������� ����
    zoom_size: byte;

    // ��� ����� ���������
    zoom_mapzap: byte;

    // ���� � ������� �����
    property MarkIconsPath: string read GetMarkIconsPath;
    // ��� ����� � �������
    property MarksFileName: string read GetMarksFileName;
    // ��� ��������� ����� ����� � �������
    property MarksBackUpFileName: string read GetMarksBackUpFileName;

    // ��� ����� � ����������� �����
    property MarksCategoryFileName: string read GetMarksCategoryFileName;
    // ��� ��������� ����� ����� � ����������� �����
    property MarksCategoryBackUpFileName: string read GetMarksCategoryBackUpFileName;
    // ���� � ����� � �������
    property MapsPath: string read GetMapsPath;
    // ���� � ����� � �������
    property TrackLogPath: string read GetTrackLogPath;
    // ��� ����� �� �������� �� ���������
    property HelpFileName: string read GetHelpFileName; 

    constructor Create;
    destructor Destroy; override;
  end;

var
  GState: TGlobalState;
implementation

uses
  SysUtils;

{ TGlobalState }

constructor TGlobalState.Create;
begin
  All_Dwn_Kb := 0;
  All_Dwn_Tiles:=0;
  ProgramPath:=ExtractFilePath(ParamStr(0));
  MainFileCache := TMemFileCache.Create;
end;

destructor TGlobalState.Destroy;
begin
  FreeAndNil(MainFileCache);
  inherited;
end;

function TGlobalState.GetMarkIconsPath: string;
begin
  Result := ProgramPath + 'marksicons\';
end;

function TGlobalState.GetMarksBackUpFileName: string;
begin
  Result := ProgramPath + 'marks.~sml';
end;
function TGlobalState.GetMarksFileName: string;
begin
  Result := ProgramPath + 'marks.sml';
end;


function TGlobalState.GetMarksCategoryBackUpFileName: string;
begin
  Result := ProgramPath + 'Categorymarks.~sml';
end;

function TGlobalState.GetMarksCategoryFileName: string;
begin
  Result := ProgramPath + 'Categorymarks.sml';
end;

function TGlobalState.GetMapsPath: string;
begin
  Result := ProgramPath + 'Maps\';
end;

function TGlobalState.GetTrackLogPath: string;
begin
  Result := ProgramPath + 'TrackLog\';
end;

function TGlobalState.GetHelpFileName: string;
begin
  Result := ProgramPath + 'help.chm';
end;

end.
