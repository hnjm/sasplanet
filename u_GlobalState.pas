unit u_GlobalState;

interface

uses
  Graphics,
  u_GeoToStr,
  Uimgfun;
type
  TInetConnect = record
    proxyused,userwinset,uselogin:boolean;
    proxystr,loginstr,passstr:string;
  end;



  TGlobalState = class
  private

  public
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
    // ������� ����
    zoom_size: byte;

    BorderColor: TColor;
    BorderAlpha: byte;
    //????
    ShowHintOnMarks: Boolean;

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
