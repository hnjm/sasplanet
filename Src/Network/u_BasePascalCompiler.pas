{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2014, SAS.Planet development team.                      *}
{* This program is free software: you can redistribute it and/or modify       *}
{* it under the terms of the GNU General Public License as published by       *}
{* the Free Software Foundation, either version 3 of the License, or          *}
{* (at your option) any later version.                                        *}
{*                                                                            *}
{* This program is distributed in the hope that it will be useful,            *}
{* but WITHOUT ANY WARRANTY; without even the implied warranty of             *}
{* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *}
{* GNU General Public License for more details.                               *}
{*                                                                            *}
{* You should have received a copy of the GNU General Public License          *}
{* along with this program.  If not, see <http://www.gnu.org/licenses/>.      *}
{*                                                                            *}
{* http://sasgis.org                                                          *}
{* info@sasgis.org                                                            *}
{******************************************************************************}

unit u_BasePascalCompiler;

interface

{.$DEFINE DO_DUMP_PASCAL_SCRIPT_ENV} // out file: '.\PascalScriptEnv.txt'

uses
  SysUtils,
  uPSC_dll,
  uPSR_dll,
  uPSRuntime,
  uPSCompiler,
  uPSUtils,
  u_BaseInterfacedObject;

type
  EPascalScriptEmptyScript = class(Exception);
  EPascalScriptCompileError = class(Exception);
  EPascalScriptRunError = class(Exception);

  TBasePascalScriptExec = class(TPSExec)
  public
    procedure RegisterAppCommonRoutines;
  end;

  TBasePascalCompiler = class;

  TOnBasePascalCompilerUsesProc =
    function(
      ACompiler: TBasePascalCompiler;
      const AName: tbtString
    ): Boolean of object;

  TBasePascalCompiler = class(TPSPascalCompiler)
  private
    FOnAuxUses: TOnBasePascalCompilerUsesProc;
    FScriptText: AnsiString;
  public
    constructor Create(const AScriptText: AnsiString);
    function CompileAndGetOutput(var AData: TbtString): Boolean;
    {$IFDEF DO_DUMP_PASCAL_SCRIPT_ENV}
    function KnownVarsToString: string;
    function KnownProcsToString(const AWikiFormat: Boolean = True): string;
    function KnownConstsToString: string;
    function KnownTypesToString: string;
    procedure EnvToLog(const AFileName: string);
    {$ENDIF}
    property OnAuxUses: TOnBasePascalCompilerUsesProc read FOnAuxUses write FOnAuxUses;
  end;

  TBaseFactoryPascalScript = class(TBaseInterfacedObject)
  private
    FScriptText: AnsiString;
    FCompiledData: TbtString;
  protected
    property CompiledData: TbtString read FCompiledData;
    function DoCompilerOnAuxUses(
      ACompiler: TBasePascalCompiler;
      const AName: tbtString
    ): Boolean; virtual;
    function PreparePascalScript: Boolean;
  public
    constructor Create(const AScriptText: AnsiString);
  end;

  TBasePascalScriptCompiled = class(TBaseInterfacedObject)
  protected
    FExec: TBasePascalScriptExec;
  protected
    procedure PrepareCompiledScript(const ACompiledData: TbtString);
    procedure RegisterAppRoutines; virtual;
    procedure RegisterAppVars; virtual; abstract;
  end;

implementation

uses
  {$IFDEF DO_DUMP_PASCAL_SCRIPT_ENV}
  Classes,
  {$ENDIF}
  Math,
  ALString,
  RegExprUtils,
  i_SimpleHttpDownloader,
  i_ProjConverter,
  i_CoordConverter,
  u_ResStrings,
  u_GeoToStrFunc,
  u_TileRequestBuilderHelpers;

function CommonAppScriptOnUses(
  Sender: TPSPascalCompiler;
  const AName: tbtString
): Boolean;
var
  VType: TPSType;
  RecT: TPSRecordType;
begin
  // common types
  if ALSameText(AName, 'SYSTEM') then begin
    // TPoint
    VType := Sender.FindType('integer');
    RecT := TPSRecordType(Sender.AddType('TPoint', btRecord));
    with RecT.AddRecVal do begin
      FieldOrgName := 'x';
      aType := VType;
    end;

    with RecT.AddRecVal do begin
      FieldOrgName := 'y';
      aType := VType;
    end;

    // TDoublePoint
    VType := Sender.FindType('Double');
    RecT := TPSRecordType(Sender.AddType('TDoublePoint', btRecord));
    with RecT.AddRecVal do begin
      FieldOrgName := 'x';
      aType := VType;
    end;

    with RecT.AddRecVal do begin
      FieldOrgName := 'y';
      aType := VType;
    end;

    with Sender.AddInterface(Sender.FindInterface('IUNKNOWN'), IProjConverter, 'IProjConverter') do begin
      RegisterMethod('Function LonLat2XY( const AProjLP : TDoublePoint) : TDoublePoint', cdRegister);
      RegisterMethod('Function XY2LonLat( const AProjXY : TDoublePoint) : TDoublePoint', cdRegister);
    end;

    with Sender.AddInterface(Sender.FindInterface('IUNKNOWN'), IProjConverterFactory, 'IProjConverterFactory') do begin
      RegisterMethod('Function GetByEPSG( const AEPSG : Integer) : IProjConverter', cdRegister);
      RegisterMethod('Function GetByInitString( const AArgs : AnsiString) : IProjConverter', cdRegister);
    end;

    // ICoordConverter
    with Sender.AddInterface(Sender.FindInterface('IUnknown'), ICoordConverterSimple, 'ICoordConverter') do begin
      RegisterMethod('function Pos2LonLat(const XY : TPoint; Azoom : byte) : TDoublePoint', cdStdCall);
      RegisterMethod('function LonLat2Pos(const Ll : TDoublePoint; Azoom : byte) : Tpoint', cdStdCall);
      RegisterMethod('function LonLat2Metr(const Ll : TDoublePoint) : TDoublePoint', cdStdCall);
      RegisterMethod('function Metr2LonLat(const Mm : TDoublePoint) : TDoublePoint', cdStdCall);

      RegisterMethod('function TilesAtZoom(AZoom: byte): Longint', cdStdCall);
      RegisterMethod('function PixelsAtZoom(AZoom: byte): Longint', cdStdCall);

      RegisterMethod('function TilePos2PixelPos(const XY : TPoint; Azoom : byte): TPoint', cdStdCall);
      RegisterMethod('function TilePos2PixelRect(const XY : TPoint; Azoom : byte): TRect', cdStdCall);

      RegisterMethod('function GetProj4Converter: IProj4Converter', cdStdCall);
    end;

    //ISimpleHttpDownloader
    with Sender.AddInterface(Sender.FindInterface('IUNKNOWN'), ISimpleHttpDownloader, 'ISimpleHttpDownloader') do begin
      RegisterMethod('function DoHttpRequest(const ARequestUrl, ARequestHeader, APostData : AnsiString; out AResponseHeader, AResponseData : AnsiString) : Cardinal', cdRegister);
    end;

  end;

  // custom vars and functions
  if (Sender is TBasePascalCompiler) then begin
    if Assigned(TBasePascalCompiler(Sender).OnAuxUses) then begin
      TBasePascalCompiler(Sender).OnAuxUses(TBasePascalCompiler(Sender), AName);
    end;
  end;

  // common functions
  if ALSameText(AName, 'SYSTEM') then begin
    // numeric routines
    Sender.AddDelphiFunction('function Random(const X: Integer): Integer');
    Sender.AddDelphiFunction('function RandomRange(const AFrom, ATo: Integer): Integer');
    Sender.AddDelphiFunction('function RoundEx(const chislo: Double; const Precision: Integer): String');
    Sender.AddDelphiFunction('function Power(const Base, Exponent: Extended): Extended');
    Sender.AddDelphiFunction('function IntPower(const Base: Extended; const Exponent: Integer): Extended register');
    Sender.AddDelphiFunction('function IntToHex(Value: Integer; Digits: Integer): String');
    Sender.AddDelphiFunction('function Ceil(const X: Extended): Integer;');
    Sender.AddDelphiFunction('function Floor(const X: Extended): Integer;');
    Sender.AddDelphiFunction('function Log2(const X: Extended): Extended;');
    Sender.AddDelphiFunction('function Ln(const X: Extended): Extended;');
    Sender.AddDelphiFunction('function Max(const A, B: Integer): Integer;');
    Sender.AddDelphiFunction('function MaxExt(const A, B: Extended): Extended;');
    Sender.AddDelphiFunction('function Min(const A, B: Integer): Integer;');
    Sender.AddDelphiFunction('function MinExt(const A, B: Extended): Extended;');

    // string routines
    Sender.AddDelphiFunction('function Length(Str: AnsiString): integer');
    Sender.AddDelphiFunction('function GetAfter(SubStr, Str: AnsiString): AnsiString');
    Sender.AddDelphiFunction('function GetBefore(SubStr, Str: AnsiString): AnsiString');
    Sender.AddDelphiFunction('function GetBetween(Str, After, Before: AnsiString): AnsiString');
    Sender.AddDelphiFunction('function SubStrPos(const Str, SubStr: AnsiString; FromPos: integer): integer');
    Sender.AddDelphiFunction('function RegExprGetMatchSubStr(const Str, MatchExpr: AnsiString; AMatchID: Integer): AnsiString');
    Sender.AddDelphiFunction('function RegExprReplaceMatchSubStr(const Str, MatchExpr, Replace: AnsiString): AnsiString');
    Sender.AddDelphiFunction('function GetNumberAfter(const ASubStr, AText: AnsiString): AnsiString');
    Sender.AddDelphiFunction('function GetDiv3Path(const ANumber: AnsiString): AnsiString');
    Sender.AddDelphiFunction('function StringReplace(const S, OldPattern, NewPattern: AnsiString; const ReplaceAll, IgnoreCase: Boolean): AnsiString;');

    // system routines
    Sender.AddDelphiFunction('function GetUnixTime:int64');
    Sender.AddDelphiFunction('function SetHeaderValue(AHeaders, AName, AValue: AnsiString): AnsiString');
    Sender.AddDelphiFunction('function GetHeaderValue(AHeaders, AName: AnsiString): AnsiString');
    Sender.AddDelphiFunction('function SaveToLocalFile(const AFullLocalFilename, AData: AnsiString): Integer');
    Sender.AddDelphiFunction('function FileExists(const FileName: AnsiString): Boolean');

    // Base64 routines
    Sender.AddDelphiFunction('function Base64Encode(const Data: AnsiString): AnsiString');
    Sender.AddDelphiFunction('function Base64UrlEncode(const Data: AnsiString): AnsiString');
    Sender.AddDelphiFunction('function Base64Decode(const Data: AnsiString): AnsiString');

    Result := True;
  end else begin
    Result := False;
  end;

  {$IFDEF DO_DUMP_PASCAL_SCRIPT_ENV}
  if (Sender is TBasePascalCompiler) then begin
    (Sender as TBasePascalCompiler).EnvToLog('.\PascalScriptEnv.txt');
  end;
  {$ENDIF}
end;


{ TBasePascalCompiler }

function TBasePascalCompiler.CompileAndGetOutput(var AData: TbtString): Boolean;
var
  i: Integer;
  VCompilerMsg: AnsiString;
begin
  if (not Self.Compile(FScriptText)) then begin
    VCompilerMsg := '';
    if (0 < Self.MsgCount) then begin
      for i := 0 to Self.MsgCount - 1 do begin
        VCompilerMsg := VCompilerMsg + Self.Msg[i].MessageToString + #13#10;
      end;
    end;
    raise EPascalScriptCompileError.CreateFmt(SAS_ERR_UrlScriptCompileError, [VCompilerMsg]);
  end;
  Result := Self.GetOutput(AData);
end;

constructor TBasePascalCompiler.Create(const AScriptText: AnsiString);
begin
  inherited Create;
  FOnAuxUses := nil;
  FScriptText := AScriptText;
  OnExternalProc := DllExternalProc;
  OnUses := CommonAppScriptOnUses;
end;

{$IFDEF DO_DUMP_PASCAL_SCRIPT_ENV}
function TBasePascalCompiler.KnownVarsToString: string;
var
  I: Integer;
  VVar: TPSVar;
begin
  Result := '';
  for I := 0 to Self.GetVarCount - 1 do begin
    VVar := Self.GetVar(I);
    if I > 0 then begin
      Result := Result + #13#10;
    end;                   
    Result := Result + VVar.OrgName;
    if Assigned(VVar.aType) then begin
      Result := Result + ': ' + VVar.aType.OriginalName;
    end;
  end;
end;

function TBasePascalCompiler.KnownProcsToString(const AWikiFormat: Boolean = True): string;
var
  I, J: Integer;
  VProc: TPSRegProc;
  VListIdent: string;
  VBoldIdent: string;
begin
  Result := '';
  if AWikiFormat then begin
    VListIdent := '  * ';
    VBoldIdent := '**';
  end else begin
    VListIdent := '';
    VBoldIdent := '';
  end;
  for I := 0 to Self.GetRegProcCount - 1 do begin
    VProc := Self.GetRegProc(I);
    if I > 0 then begin
      Result := Result + #13#10;
    end;
    if Assigned(VProc.Decl.Result) then begin
      Result := Result + VListIdent + 'function ';
    end else begin
      Result := Result + VListIdent + 'procedure ';
    end;
    Result := Result + VBoldIdent + VProc.OrgName + VBoldIdent;
    if VProc.Decl.ParamCount > 0 then begin
      Result := Result + '(';
      for J := 0 to VProc.Decl.ParamCount - 1 do begin
        if J > 0 then begin
          Result := Result + '; ';
        end;
        case VProc.Decl.Params[J].Mode of
          pmIn: Result := Result + 'const ';
          pmOut: Result := Result + 'out ';
          pmInOut: Result := Result + 'var ';
        end;
        Result := Result + VProc.Decl.Params[J].OrgName;
        if Assigned(VProc.Decl.Params[J].aType) then begin
          Result := Result + ': ' + VProc.Decl.Params[J].aType.OriginalName;
        end;
      end;
      Result := Result + ')';
    end;
    if Assigned(VProc.Decl.Result) then begin
      Result := Result + ': ' + VProc.Decl.Result.OriginalName + ';';
    end else begin
      Result := Result + ';';
    end;
  end;
end;

function TBasePascalCompiler.KnownConstsToString: string;
var
  I: Integer;
  VConst: TPSConstant;
begin
  Result := '';
  for I := 0 to Self.GetConstCount - 1 do begin
    VConst := Self.GetConst(I);
    if I > 0 then begin
      Result := Result + #13#10;
    end;
    Result := Result + VConst.OrgName;
  end;
end;
function TBasePascalCompiler.KnownTypesToString: string;
var
  I: Integer;
  VType: TPSType;
begin
  for I := 0 to Self.GetTypeCount - 1 do begin
    VType := GetType(I);
    if I > 0 then begin
      Result := Result + #13#10;
    end;
    Result := Result + VType.OriginalName;
  end;
end;

procedure TBasePascalCompiler.EnvToLog(const AFileName: string);
const
  CRLF = #13#10#13#10;
var
  VStream: TMemoryStream;
  VText: string;
begin
  VStream := TMemoryStream.Create;
  try
    VText :=
      'PascalScript ' + PSCurrentversion + CRLF +
      'Types (' + IntToStr(Self.GetTypeCount) + '):' + CRLF + KnownTypesToString + CRLF +
      'Const (' + IntToStr(Self.GetConstCount) + '):' + CRLF + KnownConstsToString + CRLF +
      'Var (' + IntToStr(Self.GetVarCount) + '):' + CRLF + KnownVarsToString + CRLF +
      'Proc (' + IntToStr(Self.GetRegProcCount) + '):' + CRLF + KnownProcsToString;
    VStream.WriteBuffer(VText[1], Length(VText)*SizeOf(VText[1]));
    VStream.SaveToFile(AFileName);
  finally
    VStream.Free;
  end;
end;
{$ENDIF}

{ TBasePascalScriptExec }

procedure TBasePascalScriptExec.RegisterAppCommonRoutines;
begin
  RegisterDLLRuntime(Self);

  // numeric routines
  Self.RegisterDelphiFunction(@RoundEx, 'RoundEx', cdRegister);
  Self.RegisterDelphiFunction(@Power, 'Power', cdRegister);
  Self.RegisterDelphiFunction(@IntPower, 'IntPower', cdRegister);
  Self.RegisterDelphiFunction(@RandomInt, 'Random', cdRegister);
  Self.RegisterDelphiFunction(@RandomRange, 'RandomRange', cdRegister);
  Self.RegisterDelphiFunction(@IntToHex, 'IntToHex', cdRegister);
  Self.RegisterDelphiFunction(@Ceil, 'Ceil', cdRegister);
  Self.RegisterDelphiFunction(@Floor, 'Floor', cdRegister);
  Self.RegisterDelphiFunction(@Log2, 'Log2', cdRegister);
  Self.RegisterDelphiFunction(@Ln, 'Ln', cdRegister);
  Self.RegisterDelphiFunction(@MaxInt, 'Max', cdRegister);
  Self.RegisterDelphiFunction(@MaxExt, 'MaxExt', cdRegister);
  Self.RegisterDelphiFunction(@MinInt, 'Min', cdRegister);
  Self.RegisterDelphiFunction(@MinExt, 'MinExt', cdRegister);

  // string routines
  Self.RegisterDelphiFunction(@StrLength, 'Length', cdRegister);
  Self.RegisterDelphiFunction(@GetAfter, 'GetAfter', cdRegister);
  Self.RegisterDelphiFunction(@GetBefore, 'GetBefore', cdRegister);
  Self.RegisterDelphiFunction(@GetBetween, 'GetBetween', cdRegister);
  Self.RegisterDelphiFunction(@SubStrPos, 'SubStrPos', cdRegister);
  Self.RegisterDelphiFunction(@RegExprGetMatchSubStr, 'RegExprGetMatchSubStr', cdRegister);
  Self.RegisterDelphiFunction(@RegExprReplaceMatchSubStr, 'RegExprReplaceMatchSubStr', cdRegister);
  Self.RegisterDelphiFunction(@GetNumberAfter, 'GetNumberAfter', cdRegister);
  Self.RegisterDelphiFunction(@StringReplaceAnsi, 'StringReplace', cdRegister);

  // system routines
  Self.RegisterDelphiFunction(@GetUnixTime, 'GetUnixTime', cdRegister);
  Self.RegisterDelphiFunction(@SetHeaderValue, 'SetHeaderValue', cdRegister);
  Self.RegisterDelphiFunction(@GetHeaderValue, 'GetHeaderValue', cdRegister);
  Self.RegisterDelphiFunction(@GetDiv3Path, 'GetDiv3Path', cdRegister);
  Self.RegisterDelphiFunction(@SaveToLocalFile, 'SaveToLocalFile', cdRegister);
  Self.RegisterDelphiFunction(@FileExists, 'FileExists', cdRegister);

  // Base64 routines
  Self.RegisterDelphiFunction(@Base64EncodeStr, 'Base64Encode', cdRegister);
  Self.RegisterDelphiFunction(@Base64UrlEncodeStr, 'Base64UrlEncode', cdRegister);
  Self.RegisterDelphiFunction(@Base64DecodeStr, 'Base64Decode', cdRegister);
end;

{ TBaseFactoryPascalScript }

constructor TBaseFactoryPascalScript.Create(const AScriptText: AnsiString);
begin
  inherited Create;
  FCompiledData := '';
  FScriptText := AScriptText;
end;

function TBaseFactoryPascalScript.DoCompilerOnAuxUses(
  ACompiler: TBasePascalCompiler;
  const AName: tbtString
): Boolean;
begin
  // common routines linked to object (based on TPSPascalCompiler)
  Result := FALSE;
end;

function TBaseFactoryPascalScript.PreparePascalScript: Boolean;
var
  VCompiler: TBasePascalCompiler;
begin
  FCompiledData := '';
  if FScriptText = '' then begin
    raise EPascalScriptEmptyScript.Create('Empty script');
  end;
  try
    VCompiler := TBasePascalCompiler.Create(FScriptText);
    try
      VCompiler.OnExternalProc := DllExternalProc;
      VCompiler.OnAuxUses := DoCompilerOnAuxUses;
      VCompiler.OnUses := CommonAppScriptOnUses;
      Result := VCompiler.CompileAndGetOutput(FCompiledData);
    finally
      FreeAndNil(VCompiler);
    end;
  except
    FCompiledData := '';
    raise;
  end;
end;

{ TBasePascalScriptCompiled }

procedure TBasePascalScriptCompiled.PrepareCompiledScript(const ACompiledData: TbtString);
begin
  // create
  FExec := TBasePascalScriptExec.Create;

  // init by common
  FExec.RegisterAppCommonRoutines;

  // init by self
  Self.RegisterAppRoutines;

  // load
  if not FExec.LoadData(ACompiledData) then begin
    raise Exception.Create(
      SAS_ERR_UrlScriptByteCodeLoad + #13#10 +
      string(TIFErrorToString(FExec.ExceptionCode, FExec.ExceptionString))
    );
  end;

  // loaded - add variables
  Self.RegisterAppVars;
end;

procedure TBasePascalScriptCompiled.RegisterAppRoutines;
begin
  // empty
end;

end.
