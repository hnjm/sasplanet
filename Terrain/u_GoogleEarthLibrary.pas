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

unit u_GoogleEarthLibrary;

interface

type
  TGoogleEarthLibrary = class(TObject)
  private
    type
      PCreateObjectProc = function(const AObjectID: TGUID): IInterface; stdcall;
  private
    FAvailable: Boolean;
    FLibHandle: THandle;
    FCreateObject: PCreateObjectProc;
    function InitLib(const ALibName: string): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function CreateObject(const AObjectID: TGUID): IInterface;
    property Available: Boolean read FAvailable;
  end;

implementation

uses
  Windows;

const
  cGoogleEarthLibraryName = 'f1ct.dll';

{ TGoogleEarthLibrary }

constructor TGoogleEarthLibrary.Create;
begin
  inherited Create;
  FLibHandle := 0;
  FCreateObject := nil;
  FAvailable := InitLib(cGoogleEarthLibraryName);
end;

destructor TGoogleEarthLibrary.Destroy;
begin
  FAvailable := False;
  if FLibHandle > 0 then begin
    FreeLibrary(FLibHandle);
  end;
  FLibHandle := 0;
  FCreateObject := nil;
  inherited Destroy;
end;

function TGoogleEarthLibrary.InitLib(const ALibName: string): Boolean;
begin
  FLibHandle := LoadLibrary(PChar(ALibName));
  if FLibHandle > 0 then begin
    FCreateObject := GetProcAddress(FLibHandle, 'CreateObject');
  end;
  Result := (FLibHandle > 0) and (Addr(FCreateObject) <> nil);
end;

function TGoogleEarthLibrary.CreateObject(const AObjectID: TGUID): IInterface;
begin
  if FAvailable then begin
    Result := FCreateObject(AObjectID);
  end else begin
    Result := nil;
  end;
end;

end.
