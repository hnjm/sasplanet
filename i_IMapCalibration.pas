unit i_IMapCalibration;

interface

uses
  Types,
  i_ICoordConverter;

type
  IMapCalibration = interface
    ['{08085422-4267-49EC-913C-3A47866A46E9}']
    // ��� ��� ������ � ��������� ��� ������ ��� ��������.
    function GetName: WideString; safecall;
    // ����� ��������� �������� ��������
    function GetDescription: WideString; safecall;
    // ���������� �������� ��� ��������� �����.
    procedure SaveCalibrationInfo(AFileName: WideString; xy1, xy2: TPoint; Azoom: byte; AConverter: ICoordConverter); safecall;
  end;

implementation

end.
