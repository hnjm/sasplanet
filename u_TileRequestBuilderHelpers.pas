{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2012, SAS.Planet development team.                      *}
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
{* http://sasgis.ru                                                           *}
{* az@sasgis.ru                                                               *}
{******************************************************************************}

unit u_TileRequestBuilderHelpers;

interface

function Rand(X: Integer): Integer;
function GetUnixTime: Int64;
function StrLength (const Str: string): Integer;
function GetAfter(const SubStr, Str: string): string;
function GetBefore(const SubStr, Str: string): string;
function GetBetween(const Str, After, Before: string): string;
function SubStrPos(const Str, SubStr: AnsiString; FromPos: Integer): Integer;
function SetHeaderValue(const AHeaders, AName, AValue: string): string;
function GetHeaderValue(const AHeaders, AName: string): string;
function GetNumberAfter(const ASubStr, AText: String): String;
function GetDiv3Path(const ASource: String): String;
function SaveToLocalFile(const AFullLocalFilename, AData: String): Integer;

implementation

uses
  SysUtils,
  Classes,
  DateUtils,
  RegExpr;

function Rand(X: Integer): Integer;
begin
  Result := Random(X);
end;

function GetUnixTime: Int64;
begin
  Result := DateTimeToUnix(now);
end;

function StrLength (const Str: string): Integer;
begin
  Result := Length(Str);
end;

function GetAfter(const SubStr, Str: string): string;
begin
  if pos(substr,str) > 0 then
    result := copy(str,pos(substr,str)+length(substr),length(str))
  else
    result := '';
end;

function GetBefore(const SubStr, Str: string): string;
begin
  if pos(substr,str)>0 then
    result := copy(str,1,pos(substr,str)-1)
  else
    result := '';
end;

function GetBetween(const Str, After, Before: string): string;
begin
  result := GetBefore(Before,GetAfter(After,str));
end;

function SubStrPos(const Str, SubStr: AnsiString; FromPos: Integer): Integer; assembler;
asm
      PUSH EDI
      PUSH ESI
      PUSH EBX
      PUSH EAX
      OR EAX,EAX
      JE @@2
      OR EDX,EDX
      JE @@2
      DEC ECX
      JS @@2

      MOV EBX,[EAX-4]
      SUB EBX,ECX
      JLE @@2
      SUB EBX,[EDX-4]
      JL @@2
      INC EBX

      ADD EAX,ECX
      MOV ECX,EBX
      MOV EBX,[EDX-4]
      DEC EBX
      MOV EDI,EAX
 @@1: MOV ESI,EDX
      LODSB
      REPNE SCASB
      JNE @@2
      MOV EAX,ECX
      PUSH EDI
      MOV ECX,EBX
      REPE CMPSB
      POP EDI
      MOV ECX,EAX
      JNE @@1
      LEA EAX,[EDI-1]
      POP EDX
      SUB EAX,EDX
      INC EAX
      JMP @@3
 @@2: POP EAX
      XOR EAX,EAX
 @@3: POP EBX
      POP ESI
      POP EDI
end;

function SetHeaderValue(const AHeaders, AName, AValue: string): string;
var
  VRegExpr: TRegExpr;
begin
  if AHeaders <> '' then
  begin
      VRegExpr  := TRegExpr.Create;
    try
      VRegExpr.Expression := '(?i)' + AName + ':(\s+|)(.*?)(\r\n|$)';
      if VRegExpr.Exec(AHeaders) then
        Result := StringReplace(AHeaders, VRegExpr.Match[2], AValue, [rfIgnoreCase])
      else
        Result := AName + ': ' + AValue + #13#10 + AHeaders;
    finally
      FreeAndNil(VRegExpr);
    end;
  end
  else
    Result := AName + ': ' + AValue + #13#10;
end;

function GetHeaderValue(const AHeaders, AName: string): string;
var
  VRegExpr: TRegExpr;
begin
  if AHeaders <> '' then
  begin
      VRegExpr  := TRegExpr.Create;
    try
      VRegExpr.Expression := '(?i)' + AName + ':(\s+|)(.*?)(\r\n|$)';
      if VRegExpr.Exec(AHeaders) then
        Result := VRegExpr.Match[2]
      else
        Result := '';
    finally
      FreeAndNil(VRegExpr);
    end;
  end
  else
    Result := '';
end;

function SaveToLocalFile(const AFullLocalFilename, AData: String): Integer;
var
  VPath: String;
  VStream: TFileStream;
  VSize: Integer;
begin
  try
    VPath := ExtractFilePath(AFullLocalFilename);
    if (not DirectoryExists(VPath)) then
      ForceDirectories(VPath);
    VStream := TFileStream.Create(AFullLocalFilename, fmCreate);
    try
      VSize := Length(AData);
      if VSize > 0 then begin
        VStream.WriteBuffer(AData[1], VSize);
      end;
      Result := VSize;
    finally
      VStream.Free;
    end;
  except
    Result := 0;
  end;
end;

function GetNumberAfter(const ASubStr, AText: String): String;
var VPos: Integer;
begin
  Result := '';
  VPos:=SYstem.Pos(ASubStr,AText);
  if (VPos>0) then begin
    VPos := VPos + Length(ASubStr);
    while ((VPos<=System.Length(AText)) and (AText[VPos] in ['0','1'..'9'])) do begin
      Result := Result + AText[VPos];
      Inc(VPos);
    end;
  end;
end;

function GetDiv3Path(const ASource: String): String;
var i: Integer;
begin
  Result:='';

  if (0<Length(ASource)) then
  for i := Length(ASource) downto 1 do begin
    if (0 = ((Length(ASource)-i) mod 3)) then
      Result := '\' + Result;
    Result := ASource[i] + Result;
  end;

  if (Length(Result)>0) then
    if ('\'=Result[1]) then
      System.Delete(Result,1,1);

  i := System.Pos('\',Result);
  if (i<4) then
    System.Delete(Result, 1, i);
end;

end.
