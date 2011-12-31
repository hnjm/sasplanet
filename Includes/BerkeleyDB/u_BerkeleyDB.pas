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

unit u_BerkeleyDB;

interface

{.$DEFINE DB_THREAD}  //Open DB handle as free-threaded

uses
  SysUtils,
  SyncObjs,
  db_h;

const
  BDB_MIN_PAGE_SIZE : Cardinal  = $200;  //512 b
  BDB_MAX_PAGE_SIZE : Cardinal  = $10000;  //64 Kb

  BDB_MIN_CACHE_SIZE : Cardinal = $5000;  //20k
  BDB_MAX_CACHE_SIZE : Cardinal = $FFFFFFFF;  //4G for 32-bit OS

  BDB_DEF_CACHE_SIZE = $40000; //256k
  BDB_DEF_PAGE_SIZE  = 0;      //auto-selected based on the underlying
                               //filesystem I/O block size (512b - 16k)
type
  TBerkeleyDB = class(TObject)
  private
    FDB: PDB;
    FFileName: string;
    FDBEnabled: Boolean;
    FCS: TCriticalSection;
  public
    constructor Create;

    destructor Destroy; override;

    function Open(
      const AFileName: string;
      APageSize: Cardinal = BDB_DEF_PAGE_SIZE;
      AMemCacheSize: Cardinal = BDB_DEF_CACHE_SIZE;
      ADBType: DBTYPE = DB_BTREE;
      AFlags: Cardinal = DB_CREATE_
    ): Boolean;

    procedure Close;

    function Write(
      AKey: Pointer;
      AKeySize: Cardinal;
      AData: Pointer;
      ADataSize: Cardinal;
      AFlags: Cardinal = 0
    ): Boolean;

    function Read(
      AKey: Pointer;
      AKeySize: Cardinal;
      out AData: Pointer;
      out ADataSize: Cardinal;
      AFlags: Cardinal = 0
    ): Boolean;

    function Exists(
      AKey: Pointer;
      AKeySize: Cardinal;
      AFlags: Cardinal = 0
    ): Boolean;

    function Del(
      AKey: Pointer;
      AKeySize: Cardinal;
      AFlags: Cardinal = 0
    ): Boolean;

    property FileName: string read FFileName write FFileName;
  end;

implementation

var
  LibInitCS: TCriticalSection = nil;

{ TBerkeleyDB }

constructor TBerkeleyDB.Create;
begin
  inherited Create;
  FCS := TCriticalSection.Create;
  FFileName := '';
  FDB := nil;
  FDBEnabled := False;
  LibInitCS.Acquire;
  try
    InitBerkeleyDB;
  finally
    LibInitCS.Release;
  end;
end;

destructor TBerkeleyDB.Destroy;
begin
  Close;
  FCS.Free;
  inherited Destroy;
end;

function TBerkeleyDB.Open(
  const AFileName: string;
  APageSize: Cardinal = BDB_DEF_PAGE_SIZE;
  AMemCacheSize: Cardinal = BDB_DEF_CACHE_SIZE;
  ADBType: DBTYPE = DB_BTREE;
  AFlags: Cardinal = DB_CREATE_
): Boolean;
begin
  FCS.Acquire;
  try
    if (FDB <> nil) then begin
      if (FFileName <> '') and (AFileName = FFileName) then begin
        Result := FDBEnabled;
      end else begin
        Result := False;
      end;
    end else begin
      FDBEnabled := False;
      CheckBDB(db_create(FDB, nil, 0));
      CheckBDB(FDB.set_alloc(FDB, @GetMemory, @ReallocMemory, @FreeMemory));
      if not FileExists(FFileName) and
         (APageSize <> Cardinal(BDB_DEF_PAGE_SIZE)) then
      begin
        CheckBDB(FDB.set_pagesize(FDB, APageSize));
      end;
      if AMemCacheSize <> Cardinal(BDB_DEF_CACHE_SIZE) then begin
        CheckBDB(FDB.set_cachesize(FDB, 0, AMemCacheSize, 0));
      end;
      {$IFDEF DB_THREAD}
      AFlags := AFlags or DB_THREAD;
      {$ENDIF}
      CheckBDB(FDB.open(FDB, nil, PAnsiChar(AFileName), '', ADBType, AFlags, 0));
      FDBEnabled := True;
      Result := FDBEnabled;
    end;
  finally
    FCS.Release;
  end;
end;

procedure TBerkeleyDB.Close;
begin
  FCS.Acquire;
  try
    if Assigned(FDB) then begin
      CheckBDBandNil(FDB.close(FDB, 0), FDB);
    end;
  finally
    FCS.Release;
  end;
end;

function TBerkeleyDB.Read(
  AKey: Pointer;
  AKeySize: Cardinal;
  out AData: Pointer;
  out ADataSize: Cardinal;
  AFlags: Cardinal = 0
): Boolean;
var
  dbtKey, dbtData: DBT;
begin
  {$IFNDEF DB_THREAD}
  FCS.Acquire;
  try
  {$ENDIF}
    Result := False;
    if FDBEnabled then begin
      FillChar(dbtKey, Sizeof(DBT), 0);
      FillChar(dbtData, Sizeof(DBT), 0);
      dbtKey.data := AKey;
      dbtKey.size := AKeySize;
      if (FDB.open_flags and DB_THREAD = DB_THREAD) then begin
        dbtData.flags := DB_DBT_MALLOC;
      end;
      Result := CheckAndFoundBDB(FDB.get(FDB, nil, @dbtKey, @dbtData, AFlags));
      if Result then begin
        AData := dbtData.data;
        ADataSize := dbtData.size;
      end;
    end;
  {$IFNDEF DB_THREAD}
  finally
    FCS.Release;
  end;
  {$ENDIF}
end;

function TBerkeleyDB.Write(
  AKey: Pointer;
  AKeySize: Cardinal;
  AData: Pointer;
  ADataSize: Cardinal;
  AFlags: Cardinal = 0
): Boolean;
var
  dbtKey, dbtData: DBT;
begin
  {$IFNDEF DB_THREAD}
  FCS.Acquire;
  try
  {$ENDIF}
    Result := False;
    if FDBEnabled then begin
      FillChar(dbtKey, Sizeof(DBT), 0);
      FillChar(dbtData, Sizeof(DBT), 0);
      dbtKey.data := AKey;
      dbtKey.size := AKeySize;
      dbtData.data := AData;
      dbtData.size := ADataSize;
      Result := CheckAndNotExistsBDB(FDB.put(FDB, nil, @dbtKey, @dbtData, AFlags));
    end;
  {$IFNDEF DB_THREAD}
  finally
    FCS.Release;
  end;
  {$ENDIF}
end;

function TBerkeleyDB.Exists(
  AKey: Pointer;
  AKeySize: Cardinal;
  AFlags: Cardinal = 0
): Boolean;
var
  dbtKey: DBT;
begin
  {$IFNDEF DB_THREAD}
  FCS.Acquire;
  try
  {$ENDIF}
    Result := False;
    if FDBEnabled then begin
      FillChar(dbtKey, Sizeof(DBT), 0);
      dbtKey.data := AKey;
      dbtKey.size := AKeySize;
      Result := CheckAndFoundBDB(FDB.exists(FDB, nil, @dbtKey, AFlags));
    end;
  {$IFNDEF DB_THREAD}
  finally
    FCS.Release;
  end;
  {$ENDIF}
end;

function TBerkeleyDB.Del(
  AKey: Pointer;
  AKeySize: Cardinal;
  AFlags: Cardinal = 0
): Boolean;
var
  dbtKey: DBT;
begin
  {$IFNDEF DB_THREAD}
  FCS.Acquire;
  try
  {$ENDIF}
    Result := False;
    if FDBEnabled then begin
      FillChar(dbtKey, Sizeof(DBT), 0);
      dbtKey.data := AKey;
      dbtKey.size := AKeySize;
      Result := CheckAndFoundBDB(FDB.del(FDB, nil, @dbtKey, AFlags));
    end;
  {$IFNDEF DB_THREAD}
  finally
    FCS.Release;
  end;
  {$ENDIF}
end;

initialization
  LibInitCS := TCriticalSection.Create;

finalization
  LibInitCS.Free;

end.

