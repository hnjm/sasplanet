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

unit u_TileDownloaderStateInternal;

interface

uses
  i_TileDownloaderState,
  i_ConfigDataElement,
  u_ConfigDataElementBase;

type
  ITileDownloaderStateInternal = interface(IConfigDataElement)
    ['{BD4A155B-92AC-4E61-8A1D-A0F8516E1340}']
    function GetEnabled: Boolean;
    property Enabled: Boolean read GetEnabled;

    function GetDisableReason: string;
    property DisableReason: string read GetDisableReason;

    procedure Disable(const AReason: string);
    procedure Enable;

    function GetStatic: ITileDownloaderStateStatic;
  end;

type
  TTileDownloaderStateInternal = class(TConfigDataElementWithStaticBaseEmptySaveLoad, ITileDownloaderStateInternal, ITileDownloaderStateChangeble)
  private
    FEnabled: Boolean;
    FReason: string;
  protected
    function CreateStatic: IInterface; override;
  private
    function GetEnabled: Boolean;
    function GetDisableReason: string;

    procedure Disable(const AReason: string);
    procedure Enable;

    function GetStatic: ITileDownloaderStateStatic;
  public
    constructor Create;
  end;


implementation

uses
  u_TileDownloaderStateStatic;

{ TTileDownloaderStateInternal }

constructor TTileDownloaderStateInternal.Create;
begin
  inherited Create;
  FEnabled := True;
end;

function TTileDownloaderStateInternal.CreateStatic: IInterface;
var
  VStatic: ITileDownloaderStateStatic;
begin
  VStatic :=
    TTileDownloaderStateStatic.Create(
      FEnabled,
      FReason
    );
  Result := VStatic;
end;

procedure TTileDownloaderStateInternal.Disable(const AReason: string);
begin
  LockWrite;
  try
    if FEnabled then begin
      FEnabled := False;
      FReason := AReason;
      SetChanged;
    end;
  finally
    UnlockWrite
  end;
end;

procedure TTileDownloaderStateInternal.Enable;
begin
  LockWrite;
  try
    if not FEnabled then begin
      FEnabled := True;
      FReason := '';
      SetChanged;
    end;
  finally
    UnlockWrite
  end;
end;

function TTileDownloaderStateInternal.GetDisableReason: string;
begin
  LockRead;
  try
    if FEnabled then begin
      Result := '';
    end else begin
      Result := FReason;
    end;
  finally
    UnlockRead;
  end;
end;

function TTileDownloaderStateInternal.GetEnabled: Boolean;
begin
  LockRead;
  try
    Result := FEnabled;
  finally
    UnlockRead;
  end;
end;

function TTileDownloaderStateInternal.GetStatic: ITileDownloaderStateStatic;
begin
  Result := ITileDownloaderStateStatic(GetStaticInternal);
end;

end.
