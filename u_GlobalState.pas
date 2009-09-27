unit u_GlobalState;

interface

uses
  Graphics,
  u_GeoToStr,
  Uimgfun;
type
  TGlobalState = class
  private

  public
    // ������ ����������� ����������, � � ��������� ��������
    num_format: TDistStrFormat;
    // ������ ����������� ��������� � ��������
    llStrType: TDegrShowFormat;
    // ���������� �������� ������ � ����������
    All_Dwn_Kb: Currency;
    // ������ ����������� ��������
    Resampling: TTileResamplingType;
    //������ ������� ���� ��-���������.
    DefCache: byte;

    GPS_enab: Boolean;

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
