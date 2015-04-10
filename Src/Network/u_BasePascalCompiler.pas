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

uses
  SysUtils,
  uPSR_dll,
  uPSRuntime,  
  uPSUtils,
  u_BaseInterfacedObject;

type
  EPascalScriptEmptyScript = class(Exception);
  EPascalScriptRunError = class(Exception);

  TBasePascalScriptExec = class(TPSExec)
  public
    procedure RegisterAppCommonRoutines;
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
  u_ResStrings,
  u_PascalScriptBase64,
  u_PascalScriptRegExpr,
  u_PascalScriptMath,
  u_PascalScriptUtils;

{ TBasePascalScriptExec }

procedure TBasePascalScriptExec.RegisterAppCommonRoutines;
begin
  RegisterDLLRuntime(Self);
  
  ExecTimeReg_Math(Self);
  ExecTimeReg_RegExpr(Self);
  ExecTimeReg_Base64(Self);
  ExecTimeReg_Utils(Self);
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
      SAS_ERR_PascalScriptByteCodeLoad + #13#10 +
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
