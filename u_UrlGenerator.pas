unit u_UrlGenerator;

interface

Uses
  Windows,
  SysUtils,
  DateUtils,
  uPSC_dll,
  uPSR_dll,
  uPSRuntime,
  uPSCompiler,
  i_IConfigDataProvider,
  i_ICoordConverter;

type
  EUrlGeneratorScriptCompileError = class(Exception);
  EUrlGeneratorScriptRunError = class(Exception);

  TUrlGeneratorBasic = class
  private
    FDefURLBase: string;
    FURLBase: String;
  protected
    procedure SetURLBase(const Value: string); virtual;
  public
    constructor Create(AConfig: IConfigDataProvider);

    function GenLink(Ax, Ay: longint; Azoom: byte): string; virtual;

    property URLBase: string read FURLBase write SetURLBase;
    property DefURLBase: string read FDefURLBase;
  end;

  TUrlGenerator = class(TUrlGeneratorBasic)
  protected
    FCoordConverter: ICoordConverterSimple;
    FGetURLScript: string;

    FCS: TRTLCriticalSection;
    FExec: TPSExec;
    FpResultUrl: PPSVariantAString;
    FpGetURLBase: PPSVariantAString;
    FpGetX: PPSVariantS32;
    FpGetY: PPSVariantS32;
    FpGetZ: PPSVariantS32;
    FpGetLlon: PPSVariantExtended;
    FpGetTLat: PPSVariantExtended;
    FpGetBLat: PPSVariantExtended;
    FpGetRLon: PPSVariantExtended;
    FpGetLMetr: PPSVariantExtended;
    FpGetRMetr: PPSVariantExtended;
    FpGetTMetr: PPSVariantExtended;
    FpGetBMetr: PPSVariantExtended;
    FpConverter: PPSVariantInterface;
    procedure SetVar(AXY: TPoint; AZoom: Byte);
    procedure SetURLBase(const Value: string); override;
  public
    constructor Create(
      AConfig: IConfigDataProvider;
      ACoordConverter: ICoordConverterSimple
    );
    destructor Destroy; override;
    function GenLink(Ax, Ay: longint; Azoom: byte): string; override;
  end;

implementation

uses
  Math,
  Classes,
  Types,
  uPSUtils,
  u_GeoToStr,
  t_GeoTypes;

{ TUrlGeneratorBasic }

constructor TUrlGeneratorBasic.Create(AConfig: IConfigDataProvider);
var
  VParams: IConfigDataProvider;
begin
  VParams := AConfig.GetSubItem('params.txt').GetSubItem('PARAMS');
  FURLBase := VParams.ReadString('DefURLBase','http://maps.google.com/');
  FDefUrlBase:=URLBase;
end;

function TUrlGeneratorBasic.GenLink(Ax, Ay: Integer; Azoom: byte): string;
begin
  Result := '';
end;

procedure TUrlGeneratorBasic.SetURLBase(const Value: string);
begin
  FURLBase := Value;
end;


function ScriptOnUses(Sender: TPSPascalCompiler; const Name: string): Boolean;
var
  T: TPSType;
  RecT: TPSRecordType;
begin
  if Name = 'SYSTEM' then begin
    T := Sender.FindType('integer');
    RecT := TPSRecordType(Sender.AddType('TPoint', btRecord));
    with RecT.AddRecVal do begin
      FieldOrgName := 'x';
      aType := t;
    end;

    with RecT.AddRecVal do begin
      FieldOrgName := 'y';
      aType := t;
    end;

    T := Sender.FindType('extended');
    RecT := TPSRecordType(Sender.AddType('TExtendedPoint', btRecord));
    with RecT.AddRecVal do begin
      FieldOrgName := 'x';
      aType := t;
    end;

    with RecT.AddRecVal do begin
      FieldOrgName := 'y';
      aType := t;
    end;

    with Sender.AddInterface(Sender.FindInterface('IUnknown'), ICoordConverter, 'ICoordConverter') do begin
      RegisterMethod('function Pos2LonLat(XY : TPoint; Azoom : byte) : TExtendedPoint', cdStdCall);
      RegisterMethod('function LonLat2Pos(Ll : TExtendedPoint; Azoom : byte) : Tpoint', cdStdCall);
      RegisterMethod('function LonLat2Metr(Ll : TExtendedPoint) : TExtendedPoint', cdStdCall);

      RegisterMethod('function TilesAtZoom(AZoom: byte): Longint', cdStdCall);
      RegisterMethod('function PixelsAtZoom(AZoom: byte): Longint', cdStdCall);

      RegisterMethod('function TilePos2PixelPos(const XY : TPoint; Azoom : byte): TPoint', cdStdCall);
      RegisterMethod('function TilePos2PixelRect(const XY : TPoint; Azoom : byte): TRect', cdStdCall);
    end;
    T := Sender.FindType('ICoordConverter');
    Sender.AddUsedVariable('Converter', t);

    T := Sender.FindType('string');
    Sender.AddUsedVariable('ResultURL', t);
    Sender.AddUsedVariable('GetURLBase', t);
    T := Sender.FindType('integer');
    Sender.AddUsedVariable('GetX', t);
    Sender.AddUsedVariable('GetY', t);
    Sender.AddUsedVariable('GetZ', t);
    Sender.AddUsedVariable('dLpix', t);
    Sender.AddUsedVariable('dTpix', t);
    Sender.AddUsedVariable('dBpix', t);
    Sender.AddUsedVariable('dRpix', t);
    T := Sender.FindType('extended');
    Sender.AddUsedVariable('GetLlon', t);
    Sender.AddUsedVariable('GetTLat', t);
    Sender.AddUsedVariable('GetBLat', t);
    Sender.AddUsedVariable('GetRLon', t);
    Sender.AddUsedVariable('GetLMetr', t);
    Sender.AddUsedVariable('GetRMetr', t);
    Sender.AddUsedVariable('GetTMetr', t);
    Sender.AddUsedVariable('GetBMetr', t);
    Sender.AddDelphiFunction('function Random(x:integer):integer');
    Sender.AddDelphiFunction('function GetUnixTime:int64');
    Sender.AddDelphiFunction('function RoundEx(chislo: Extended; Precision: Integer): string');
    Sender.AddDelphiFunction('function IntPower(const Base: Extended; const Exponent: Integer): Extended register');
    Sender.AddDelphiFunction('function IntToHex(Value: Integer; Digits: Integer): string');
    Result := True;
  end else begin
    Result := False;
  end;
end;

function Rand(x: integer): integer;
begin
  Result := Random(x);
end;

function GetUnixTime(x: integer): int64;
begin
  Result := DateTimeToUnix(now);
end;

{ TUrlGenerator }
constructor TUrlGenerator.Create(
  AConfig: IConfigDataProvider;
  ACoordConverter: ICoordConverterSimple
);
var
  i: integer;
  Msg: string;
  VCompiler: TPSPascalCompiler;
  VData: string;
begin
  inherited Create(AConfig);
  FCoordConverter := ACoordConverter;

  FGetURLScript := AConfig.ReadString('GetUrlScript.txt', '');

  VCompiler := TPSPascalCompiler.Create;       // create an instance of the compiler.
  VCompiler.OnExternalProc := DllExternalProc; // ��������� ����������� ���������� ������� DLL(��������� � ������ uPSC_dll)
  VCompiler.OnUses := ScriptOnUses;            // assign the OnUses event.
  if not VCompiler.Compile(FGetURLScript) then begin  // Compile the Pascal script into bytecode.
    Msg := '';
    For i := 0 to VCompiler.MsgCount - 1 do begin
      MSG := Msg + VCompiler.Msg[i].MessageToString + #13#10;
    end;
    raise EUrlGeneratorScriptCompileError.Create('������ � ������� ��� ����������'#13#10 + Msg);
  end;
  VCompiler.GetOutput(VData); // Save the output of the compiler in the string Data.
  VCompiler.Free;            // After compiling the script, there is no further need for the compiler.
  FExec := TPSExec.Create;   // Create an instance of the executer.
  RegisterDLLRuntime(FExec);

  FExec.RegisterDelphiFunction(@RoundEx, 'RoundEx', cdRegister);
  FExec.RegisterDelphiFunction(@IntPower, 'IntPower', cdRegister);
  FExec.RegisterDelphiFunction(@Rand, 'Random', cdRegister);
  FExec.RegisterDelphiFunction(@IntToHex, 'IntToHex', cdRegister);

  if not FExec.LoadData(VData) then begin // Load the data from the Data string.
    raise Exception.Create('������ ��� �������� ��������');
  end;
  FpResultUrl := PPSVariantAString(FExec.GetVar2('ResultURL'));
  FpGetURLBase := PPSVariantAString(FExec.GetVar2('GetURLBase'));
  FpGetURLBase.Data := FURLBase;
  FpGetX := PPSVariantS32(FExec.GetVar2('GetX'));
  FpGetY := PPSVariantS32(FExec.GetVar2('GetY'));
  FpGetZ := PPSVariantS32(FExec.GetVar2('GetZ'));
  FpGetLlon := PPSVariantExtended(FExec.GetVar2('GetLlon'));
  FpGetTLat := PPSVariantExtended(FExec.GetVar2('GetTLat'));
  FpGetBLat := PPSVariantExtended(FExec.GetVar2('GetBLat'));
  FpGetRLon := PPSVariantExtended(FExec.GetVar2('GetRLon'));
  FpGetLmetr := PPSVariantExtended(FExec.GetVar2('GetLmetr'));
  FpGetTmetr := PPSVariantExtended(FExec.GetVar2('GetTmetr'));
  FpGetBmetr := PPSVariantExtended(FExec.GetVar2('GetBmetr'));
  FpGetRmetr := PPSVariantExtended(FExec.GetVar2('GetRmetr'));
  FpConverter := PPSVariantInterface(FExec.GetVar2('Converter'));
  InitializeCriticalSection(FCS);
end;

destructor TUrlGenerator.Destroy;
begin
  DeleteCriticalSection(FCS);
  FreeAndNil(FExec);
  FCoordConverter := nil;
  inherited;
end;

procedure TUrlGenerator.SetVar(AXY: TPoint; AZoom: Byte);
var
  XY: TPoint;
  Ll: TExtendedPoint;
begin
  FpGetX.Data := AXY.X;
  FpGetY.Data := AXY.Y;
  FpGetZ.Data := AZoom + 1;
  Ll := FCoordConverter.Pos2LonLat(AXY, AZoom);
  FpGetLlon.Data := Ll.X;
  FpGetTLat.Data := Ll.Y;
  Ll := FCoordConverter.LonLat2Metr(LL);
  FpGetLMetr.Data := Ll.X;
  FpGetTMetr.Data := Ll.Y;
  XY := AXY;
  Inc(XY.X);
  Inc(XY.Y);
  Ll := FCoordConverter.Pos2LonLat(XY, AZoom);
  FpGetRLon.Data := Ll.X;
  FpGetBLat.Data := Ll.Y;
  Ll := FCoordConverter.LonLat2Metr(LL);
  FpGetRMetr.Data := Ll.X;
  FpGetBMetr.Data := Ll.Y;
  FpConverter.Data := FCoordConverter;
end;

function TUrlGenerator.GenLink(Ax, Ay: Integer; Azoom: byte): string;
begin
  EnterCriticalSection(FCS);
  try
    FpResultUrl.Data := '';
    SetVar(Point(Ax, Ay), Azoom);
    try
      FExec.RunScript; // Run the script.
    except
      on e: Exception do begin
        raise EUrlGeneratorScriptRunError.Create(e.Message);
      end;
    end;
    Result := FpResultUrl.Data;
  finally
    LeaveCriticalSection(FCS);
  end;
end;

procedure TUrlGenerator.SetURLBase(const Value: string);
begin
  inherited;
  FpGetURLBase.Data := Value;
end;

end.
