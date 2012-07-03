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

unit u_TileErrorLogProviedrStuped;

interface

uses
  SysUtils,
  i_Notifier,
  i_TileError,
  i_TileErrorLogProviedrStuped;

type
  TTileErrorLogProviedrStuped = class(TInterfacedObject, ITileErrorLogProviedrStuped, ITileErrorLogger)
  private
    FLastErrorInfo: ITileErrorInfo;
    FNotifier: INotifierInternal;
    FCS: IReadWriteSync;
  protected
    function GetLastErrorInfo: ITileErrorInfo;
    function GetNotifier: INotifier;
  protected
    procedure LogError(const AValue: ITileErrorInfo);
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  u_Synchronizer,
  u_Notifier;

{ TTileErrorLogProviedrStuped }

constructor TTileErrorLogProviedrStuped.Create;
begin
  inherited Create;
  FCS := MakeSyncRW_Var(Self, False);
  FNotifier := TNotifierBase.Create;
end;

destructor TTileErrorLogProviedrStuped.Destroy;
begin
  FNotifier := nil;
  FCS := nil;
  inherited;
end;

function TTileErrorLogProviedrStuped.GetLastErrorInfo: ITileErrorInfo;
begin
  FCS.BeginRead;
  try
    Result := FLastErrorInfo;
  finally
    FCS.EndRead;
  end;
end;

function TTileErrorLogProviedrStuped.GetNotifier: INotifier;
begin
  Result := FNotifier;
end;

procedure TTileErrorLogProviedrStuped.LogError(const AValue: ITileErrorInfo);
begin
  FCS.BeginWrite;
  try
    FLastErrorInfo := AValue;
  finally
    FCS.EndWrite;
  end;
  FNotifier.Notify(nil);
end;

end.
