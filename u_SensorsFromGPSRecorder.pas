unit u_SensorsFromGPSRecorder;

interface

uses
  i_GPSRecorder,
  i_ValueToStringConverter,
  i_LanguageManager,
  u_SensorTextFromGPSRecorder;

type
  TSensorFromGPSRecorderLastSpeed = class(TSensorTextFromGPSRecorder)
  protected
    function ValueToText(AValue: Double): string; override;
    function GetValue: Double; override;
  public
    constructor Create(
      ALanguageManager: ILanguageManager;
      AGPSRecorder: IGPSRecorder;
      AValueConverterConfig: IValueToStringConverterConfig
    );
  end;

  TSensorFromGPSRecorderAvgSpeed = class(TSensorTextFromGPSRecorder)
  protected
    function ValueToText(AValue: Double): string; override;
    function GetValue: Double; override;
    procedure Reset; override;
  public
    constructor Create(
      ALanguageManager: ILanguageManager;
      AGPSRecorder: IGPSRecorder;
      AValueConverterConfig: IValueToStringConverterConfig
    );
  end;

  TSensorFromGPSRecorderMaxSpeed = class(TSensorTextFromGPSRecorder)
  protected
    function ValueToText(AValue: Double): string; override;
    function GetValue: Double; override;
    procedure Reset; override;
  public
    constructor Create(
      ALanguageManager: ILanguageManager;
      AGPSRecorder: IGPSRecorder;
      AValueConverterConfig: IValueToStringConverterConfig
    );
  end;

  TSensorFromGPSRecorderDist = class(TSensorTextFromGPSRecorder)
  protected
    function ValueToText(AValue: Double): string; override;
    function GetValue: Double; override;
    procedure Reset; override;
  public
    constructor Create(
      ALanguageManager: ILanguageManager;
      AGPSRecorder: IGPSRecorder;
      AValueConverterConfig: IValueToStringConverterConfig
    );
  end;

  TSensorFromGPSRecorderOdometer1 = class(TSensorTextFromGPSRecorder)
  protected
    function ValueToText(AValue: Double): string; override;
    function GetValue: Double; override;
    procedure Reset; override;
  public
    constructor Create(
      ALanguageManager: ILanguageManager;
      AGPSRecorder: IGPSRecorder;
      AValueConverterConfig: IValueToStringConverterConfig
    );
  end;

  TSensorFromGPSRecorderOdometer2 = class(TSensorTextFromGPSRecorder)
  protected
    function ValueToText(AValue: Double): string; override;
    function GetValue: Double; override;
    procedure Reset; override;
  public
    constructor Create(
      ALanguageManager: ILanguageManager;
      AGPSRecorder: IGPSRecorder;
      AValueConverterConfig: IValueToStringConverterConfig
    );
  end;

  TSensorFromGPSRecorderAltitude = class(TSensorTextFromGPSRecorder)
  protected
    function ValueToText(AValue: Double): string; override;
    function GetValue: Double; override;
  public
    constructor Create(
      ALanguageManager: ILanguageManager;
      AGPSRecorder: IGPSRecorder;
      AValueConverterConfig: IValueToStringConverterConfig
    );
  end;

  TSensorFromGPSRecorderHeading = class(TSensorTextFromGPSRecorder)
  protected
    function ValueToText(AValue: Double): string; override;
    function GetValue: Double; override;
  public
    constructor Create(
      ALanguageManager: ILanguageManager;
      AGPSRecorder: IGPSRecorder;
      AValueConverterConfig: IValueToStringConverterConfig
    );
  end;

implementation

uses
  c_SensorsGUIDSimple,
  u_GeoToStr;

{ TSensorFromGPSRecorderLastSpeed }

constructor TSensorFromGPSRecorderLastSpeed.Create(
  ALanguageManager: ILanguageManager;
  AGPSRecorder: IGPSRecorder;
  AValueConverterConfig: IValueToStringConverterConfig
);
begin
  inherited Create(
    CSensorLastSpeedGUID,
    '��������, ��/�:',
    '���������� ������� �������� ��������',
    '��������',
    False,
    ALanguageManager,
    AGPSRecorder,
    AValueConverterConfig
  );
end;

function TSensorFromGPSRecorderLastSpeed.GetValue: Double;
begin
  Result := GPSRecorder.LastSpeed;
end;

function TSensorFromGPSRecorderLastSpeed.ValueToText(AValue: Double): string;
begin
  Result := RoundEx(AValue, 2);
end;

{ TSensorFromGPSRecorderAvgSpeed }

constructor TSensorFromGPSRecorderAvgSpeed.Create(
  ALanguageManager: ILanguageManager;
  AGPSRecorder: IGPSRecorder;
  AValueConverterConfig: IValueToStringConverterConfig
);
begin
  inherited Create(
    CSensorAvgSpeedGUID,
    '�������� ����., ��/�:',
    '���������� ������� �������� ��������',
    '�������� �������',
    True,
    ALanguageManager,
    AGPSRecorder,
    AValueConverterConfig
  );
end;

function TSensorFromGPSRecorderAvgSpeed.GetValue: Double;
begin
  Result := GPSRecorder.AvgSpeed;
end;

procedure TSensorFromGPSRecorderAvgSpeed.Reset;
begin
  inherited;
  GPSRecorder.ResetAvgSpeed;
end;

function TSensorFromGPSRecorderAvgSpeed.ValueToText(AValue: Double): string;
begin
  Result := RoundEx(AValue, 2);
end;

{ TSensorFromGPSRecorderMaxSpeed }

constructor TSensorFromGPSRecorderMaxSpeed.Create(
  ALanguageManager: ILanguageManager;
  AGPSRecorder: IGPSRecorder;
  AValueConverterConfig: IValueToStringConverterConfig
);
begin
  inherited Create(
    CSensorMaxSpeedGUID,
    '�������� ����., ��/�:',
    '���������� ������������ �������� ��������',
    '�������� ������������',
    True,
    ALanguageManager,
    AGPSRecorder,
    AValueConverterConfig
  );
end;

function TSensorFromGPSRecorderMaxSpeed.GetValue: Double;
begin
  Result := GPSRecorder.MaxSpeed;
end;

procedure TSensorFromGPSRecorderMaxSpeed.Reset;
begin
  inherited;
  GPSRecorder.ResetMaxSpeed;
end;

function TSensorFromGPSRecorderMaxSpeed.ValueToText(AValue: Double): string;
begin
  Result := RoundEx(AValue, 2);
end;

{ TSensorFromGPSRecorderDist }

constructor TSensorFromGPSRecorderDist.Create(
  ALanguageManager: ILanguageManager;
  AGPSRecorder: IGPSRecorder;
  AValueConverterConfig: IValueToStringConverterConfig
);
begin
  inherited Create(
    CSensorDistGUID,
    '���������� ����:',
    '���������� ���������� ���� ��������� �� ����������� � GPS-���������',
    '���������� ����',
    True,
    ALanguageManager,
    AGPSRecorder,
    AValueConverterConfig
  );
end;

function TSensorFromGPSRecorderDist.GetValue: Double;
begin
  Result := GPSRecorder.Dist;
end;

procedure TSensorFromGPSRecorderDist.Reset;
begin
  inherited;
  GPSRecorder.ResetDist;
end;

function TSensorFromGPSRecorderDist.ValueToText(AValue: Double): string;
begin
  Result := ValueConverter.DistConvert(AValue)
end;

{ TSensorFromGPSRecorderOdometer1 }

constructor TSensorFromGPSRecorderOdometer1.Create(
  ALanguageManager: ILanguageManager;
  AGPSRecorder: IGPSRecorder;
  AValueConverterConfig: IValueToStringConverterConfig
);
begin
  inherited Create(
    CSensorOdometer1GUID,
    '�������, ��:',
    '���������� ���� ���������� ����',
    '�������',
    True,
    ALanguageManager,
    AGPSRecorder,
    AValueConverterConfig
  );
end;

function TSensorFromGPSRecorderOdometer1.GetValue: Double;
begin
  Result := GPSRecorder.Odometer1;
end;

procedure TSensorFromGPSRecorderOdometer1.Reset;
begin
  inherited;
  GPSRecorder.ResetOdometer1;
end;

function TSensorFromGPSRecorderOdometer1.ValueToText(AValue: Double): string;
begin
  Result := ValueConverter.DistConvert(AValue)
end;

{ TSensorFromGPSRecorderOdometer2 }

constructor TSensorFromGPSRecorderOdometer2.Create(
  ALanguageManager: ILanguageManager;
  AGPSRecorder: IGPSRecorder;
  AValueConverterConfig: IValueToStringConverterConfig
);
begin
  inherited Create(
    CSensorOdometer2GUID,
    '������� �2, ��:',
    '���������� ���� ���������� ����',
    '������� �2',
    True,
    ALanguageManager,
    AGPSRecorder,
    AValueConverterConfig
  );
end;

function TSensorFromGPSRecorderOdometer2.GetValue: Double;
begin
  Result := GPSRecorder.Odometer2;
end;

procedure TSensorFromGPSRecorderOdometer2.Reset;
begin
  inherited;
  GPSRecorder.ResetOdometer2;
end;

function TSensorFromGPSRecorderOdometer2.ValueToText(AValue: Double): string;
begin
  Result := ValueConverter.DistConvert(AValue)
end;

{ TSensorFromGPSRecorderAltitude }

constructor TSensorFromGPSRecorderAltitude.Create(
  ALanguageManager: ILanguageManager;
  AGPSRecorder: IGPSRecorder;
  AValueConverterConfig: IValueToStringConverterConfig
);
begin
  inherited Create(
    CSensorLastAltitudeGUID,
    '������, �:',
    '���������� ������ ��� ������� ���� �� ������ GPS-���������',
    '������',
    False,
    ALanguageManager,
    AGPSRecorder,
    AValueConverterConfig
  );
end;

function TSensorFromGPSRecorderAltitude.GetValue: Double;
begin
  Result := GPSRecorder.LastAltitude;
end;

function TSensorFromGPSRecorderAltitude.ValueToText(AValue: Double): string;
begin
  Result := RoundEx(AValue, 2);
end;

{ TSensorFromGPSRecorderHeading }

constructor TSensorFromGPSRecorderHeading.Create(
  ALanguageManager: ILanguageManager;
  AGPSRecorder: IGPSRecorder;
  AValueConverterConfig: IValueToStringConverterConfig
);
begin
  inherited Create(
    CSensorHeadingGUID,
    '������:',
    '���������� ������ �����������',
    '������',
    False,
    ALanguageManager,
    AGPSRecorder,
    AValueConverterConfig
  );
end;

function TSensorFromGPSRecorderHeading.GetValue: Double;
begin
  Result := GPSRecorder.LastHeading;
end;

function TSensorFromGPSRecorderHeading.ValueToText(AValue: Double): string;
begin
  Result := RoundEx(AValue, 2) + '�';;
end;

end.
