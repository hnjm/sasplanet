unit u_GlobalState;

interface

uses
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

    Resampling: TTileResamplingType;

//    PWL:TResObj;

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
