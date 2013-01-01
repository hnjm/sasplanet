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

unit u_BerkeleyDBEnv;

interface

uses
  SyncObjs,
  libdb51,
  i_Listener,
  i_BerkeleyDBEnv,
  i_GlobalBerkeleyDBHelper,
  u_BaseInterfacedObject,
  u_BerkeleyDBPool;

type
  TBerkeleyDBEnvAppPrivate = record
    EnvRootPath: string;
    Helper: IGlobalBerkeleyDBHelper;
  end;
  PBerkeleyDBEnvAppPrivate = ^TBerkeleyDBEnvAppPrivate;

  TBerkeleyDBEnv = class(TBaseInterfacedObject, IBerkeleyDBEnvironment)
  private
    dbenv: PDB_ENV;
  private
    FAppPrivate: PBerkeleyDBEnvAppPrivate;
    FActive: Boolean;
    FLibInitOk: Boolean;
    FLastRemoveLogTime: Cardinal;
    FCS: TCriticalSection;
    FClientsCount: Integer;
    FListener: IListener;
    function Open: Boolean;
    procedure Sync;
  private
    { IBerkeleyDBEnvironment }
    function GetEnvironmentPointerForApi: Pointer;
    function GetRootPath: string;
    function GetClientsCount: Integer;
    procedure SetClientsCount(const AValue: Integer);
    procedure RemoveUnUsedLogs;
    procedure TransactionCheckPoint;
    function GetSyncCallListener: IListener;
  public
    constructor Create(
      const AGlobalBerkeleyDBHelper: IGlobalBerkeleyDBHelper;
      const AEnvRootPath: string
    );
    destructor Destroy; override;
  end;

implementation

uses
  Windows,
  SysUtils,
  u_ListenerByEvent,
  u_GlobalBerkeleyDBHelper;

const
  cBerkeleyDBEnvSubDir = 'env';
  cBerkeleyDBEnvErrPfx = 'BerkeleyDB Env';

{ TBerkeleyDBEnv }

constructor TBerkeleyDBEnv.Create(
  const AGlobalBerkeleyDBHelper: IGlobalBerkeleyDBHelper;
  const AEnvRootPath: string
);
begin
  inherited Create;
  dbenv := nil;
  New(FAppPrivate);
  FAppPrivate.EnvRootPath := AEnvRootPath;
  FAppPrivate.Helper := AGlobalBerkeleyDBHelper;
  FCS := TCriticalSection.Create;
  FActive := False;
  FLastRemoveLogTime := 0;
  FClientsCount := 1;
  FLibInitOk := InitBerkeleyDB;
  FListener := TNotifyNoMmgEventListener.Create(Self.Sync);
end;

destructor TBerkeleyDBEnv.Destroy;
begin
  try
    FListener := nil;
    if dbenv <> nil then begin
      TransactionCheckPoint;
      RemoveUnUsedLogs;
      CheckBDBandNil(dbenv.close(dbenv, 0), dbenv);
    end;
    FCS.Free;
  finally
    FAppPrivate.Helper := nil;
    Dispose(FAppPrivate);
    inherited Destroy;
  end;
end;

function TBerkeleyDBEnv.GetRootPath: string;
begin
  if Assigned(FAppPrivate) then begin
    Result := FAppPrivate.EnvRootPath;
  end else begin
    Result := '';
  end;
end;

function TBerkeleyDBEnv.Open: Boolean;
var
  I: Integer;
  VPath: AnsiString;
begin
  if not FActive and FLibInitOk then begin
    CheckBDB(db_env_create(dbenv, 0));

    dbenv.app_private := FAppPrivate;
    dbenv.set_errpfx(dbenv, CBerkeleyDBEnvErrPfx);
    dbenv.set_errcall(dbenv, BerkeleyDBErrCall);
    CheckBDB(dbenv.set_alloc(dbenv, @GetMemory, @ReallocMemory, @FreeMemory));
    CheckBDB(dbenv.set_flags(dbenv, DB_TXN_NOSYNC, 1));
    CheckBDB(dbenv.set_flags(dbenv, DB_TXN_WRITE_NOSYNC, 1));
    CheckBDB(dbenv.set_verbose(dbenv, DB_VERB_RECOVERY, 1));

    VPath := FAppPrivate.EnvRootPath + cBerkeleyDBEnvSubDir + PathDelim;
    I := LastDelimiter(PathDelim, VPath);
    VPath := copy(VPath, 1, I);
    CheckBDB(dbenv.set_data_dir(dbenv, '..'));

    if not DirectoryExists(VPath) then begin
      ForceDirectories(VPath);
    end;
    CheckBDB(dbenv.log_set_config(dbenv, DB_LOG_AUTO_REMOVE, 1));

    CheckBDB(
      dbenv.open(
        dbenv,
        Pointer(AnsiToUtf8(VPath)),
        DB_CREATE_ or
        DB_RECOVER or
        DB_INIT_LOCK or
        DB_INIT_LOG or
        DB_INIT_MPOOL or
        DB_INIT_TXN or
        DB_REGISTER or
        DB_THREAD,
        0
      )
    );
    FActive := True;
  end;
  Result := FActive and FLibInitOk;
end;

procedure TBerkeleyDBEnv.RemoveUnUsedLogs;
begin
  FCS.Acquire;
  try
    if FActive and FLibInitOk and (GetTickCount - FLastRemoveLogTime > 30000) then begin
      FLastRemoveLogTime := GetTickCount;
      CheckBDB(dbenv.log_archive(dbenv, nil, DB_ARCH_REMOVE));
    end;
  finally
    FCS.Release;
  end;
end;

procedure TBerkeleyDBEnv.TransactionCheckPoint;
begin
  FCS.Acquire;
  try
    if FActive and FLibInitOk then begin
      CheckBDB(dbenv.txn_checkpoint(dbenv, 0, 0, DB_FORCE));
    end;
  finally
    FCS.Release;
  end;
end;

procedure TBerkeleyDBEnv.Sync;
begin
  RemoveUnUsedLogs;
  //TransactionCheckPoint;
end;

function TBerkeleyDBEnv.GetEnvironmentPointerForApi: Pointer;
begin
  FCS.Acquire;
  try
    if Open then begin
      Result := dbenv;
    end else begin
      Result := nil;
    end;
  finally
    FCS.Release;
  end;
end;

function TBerkeleyDBEnv.GetClientsCount: Integer;
begin
  FCS.Acquire;
  try
    Result := FClientsCount;
  finally
    FCS.Release;
  end;
end;

procedure TBerkeleyDBEnv.SetClientsCount(const AValue: Integer);
begin
  FCS.Acquire;
  try
    FClientsCount := AValue;
  finally
    FCS.Release;
  end;
end;

function TBerkeleyDBEnv.GetSyncCallListener: IListener;
begin
  Result := FListener;
end;

end.

