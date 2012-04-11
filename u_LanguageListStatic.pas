{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2011, SAS.Planet development team.                      *}
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

unit u_LanguageListStatic;

interface

uses
  Classes,
  i_LanguageListStatic;

type
  TLanguageListStatic = class(TInterfacedObject, ILanguageListStatic)
  private
    FSortedByCode: TStringList;
    FList: TStringList;
  protected
    function GetCount: Integer;
    property Count: Integer read GetCount;

    function GetCode(AIndex: Integer): string;
    function FindCode(const ACode: string; out AIndex: Integer): Boolean;
  public
    constructor Create(
      AList: TStrings
    );
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils;

{ TLanguageListStatic }

constructor TLanguageListStatic.Create(AList: TStrings);
var
  i: Integer;
  VCode: string;
begin
  FSortedByCode := TStringList.Create;
  FSortedByCode.Sorted := True;
  FSortedByCode.Duplicates := dupError;

  FList := TStringList.Create;

  for i := 0 to AList.Count - 1 do begin
    VCode := AList.Strings[i];
    FSortedByCode.AddObject(VCode, TObject(i));
    FList.Add(VCode);
  end;
end;

destructor TLanguageListStatic.Destroy;
begin
  FreeAndNil(FSortedByCode);
  FreeAndNil(FList);
  inherited;
end;

function TLanguageListStatic.FindCode(
  const ACode: string;
  out AIndex: Integer
): Boolean;
begin
  Result := FSortedByCode.Find(ACode, AIndex);
end;

function TLanguageListStatic.GetCode(AIndex: Integer): string;
begin
  Result := FList.Strings[AIndex];
end;

function TLanguageListStatic.GetCount: Integer;
begin
  Result := FList.Count;
end;

end.
