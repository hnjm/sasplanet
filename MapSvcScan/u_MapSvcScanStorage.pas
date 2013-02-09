unit u_MapSvcScanStorage;

interface

uses
  SysUtils,
  Classes,
  SQLite3Handler,
  i_PathConfig,
  i_MapSvcScanStorage,
  u_BaseInterfacedObject;

type
  TMapSvcScanStorage = class(TBaseInterfacedObject, IMapSvcScanStorage)
  private
    FMapSvcScanPath: IPathConfig;
    FSync: IReadWriteSync;
    FDbHandler: TSQLite3DbHandler;
    FInitialized: Boolean;
    FServices: TStringList;
  private
    procedure CallbackReadSingleInt(
      const AHandler: PSQLite3DbHandler;
      const ACallbackPtr: Pointer;
      const AStmtData: PSQLite3StmtData
    );
    function GetServiceId(const AServiceName: String): Integer;
    // dont use unix seconds because of very big delta and Int64
    function DateTimeToDBSeconds(const AValue: TDateTime): Integer;
    function DBSecondsToDateTime(const AValue: Integer): TDateTime;
  private
    { IMapSvcScanStorage }
    function Available: Boolean;
    function ItemExists(
      const AServiceName: String;
      const AIdentifier: WideString;
      const AFetchedDate: PDateTime
    ): Boolean;
    function AddItem(
      const AServiceName: String;
      const AIdentifier: WideString;
      const AFetchedDate: TDateTime
    ): Boolean;
  public
    constructor Create(
      const AMapSvcScanPath: IPathConfig
    );
    destructor Destroy; override;
  end;

implementation

uses
  ALSqlite3Wrapper,
  u_Synchronizer;

const
  c_DBSecondsDateDelta = 40000;

{ TMapSvcScanStorage }

function TMapSvcScanStorage.AddItem(
  const AServiceName: String;
  const AIdentifier: WideString;
  const AFetchedDate: TDateTime
): Boolean;
var
  VId: Integer;
begin
  Result := Available;
  if (not Result) then
    Exit;

  // get service id
  VId := GetServiceId(AServiceName);
  Result := (VId<>0);
  if (not Result) then
    Exit;

  // insert one row
  try
    FDbHandler.ExecSQLWithTEXTW(
      'INSERT OR IGNORE INTO svcitem (id,itemname,itemdate) VALUES ('+IntToStr(VId)+',?,'+IntToStr(DateTimeToDBSeconds(AFetchedDate))+')',
      TRUE,
      PWideChar(AIdentifier),
      Length(AIdentifier)      
    );
    Result := TRUE;
  except
    Result := FALSE;
  end;
end;

function TMapSvcScanStorage.Available: Boolean;
begin
  Result := FInitialized and FDbHandler.Opened;
end;

procedure TMapSvcScanStorage.CallbackReadSingleInt(
  const AHandler: PSQLite3DbHandler; const ACallbackPtr: Pointer;
  const AStmtData: PSQLite3StmtData);
begin
  // ������ ���� ���� ���� INT
  PInteger(ACallbackPtr)^ := AStmtData^.ColumnInt(0);
  AStmtData^.Cancelled := TRUE;
end;

constructor TMapSvcScanStorage.Create(const AMapSvcScanPath: IPathConfig);
var
  VPath: String;
begin
  inherited Create;
  FMapSvcScanPath := AMapSvcScanPath;
  FSync := MakeSyncRW_Std(Self);

  FServices := TStringList.Create;
  FServices.Sorted := TRUE;
  FServices.Duplicates := dupIgnore;

  FInitialized := FDbHandler.Init;
  if FInitialized then
  try
    VPath := AMapSvcScanPath.FullPath;
    ForceDirectories(VPath);
    VPath := IncludeTrailingPathDelimiter(VPath) + 'FoundItems.sqlitedb';
    if FileExists(VPath) then begin
      // open existing
      FDbHandler.Open(VPath, SQLITE_OPEN_READWRITE);
    end else begin
      // create new database
      FDbHandler.Open(VPath, (SQLITE_OPEN_READWRITE or SQLITE_OPEN_CREATE));
      // generate structure
      FDbHandler.ExecSQL('create table IF NOT EXISTS svcinfo (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, svcname NVARCHAR NOT NULL)');
      FDbHandler.ExecSQL('create unique index IF NOT EXISTS svcinfo_uniq on svcinfo (svcname)');
      FDbHandler.ExecSQL('create table IF NOT EXISTS svcitem (id INTEGER NOT NULL CONSTRAINT svcinfo_fk REFERENCES svcinfo (id) ON DELETE CASCADE, itemname NVARCHAR NOT NULL, itemdate INT NOT NULL, constraint PK_SVCITEM primary key (id, itemname))');
    end;
    // apply config
    FDbHandler.ExecSQL('PRAGMA main.journal_mode=PERSIST'); // DELETE by default // WAL // PERSIST
    FDbHandler.ExecSQL('PRAGMA synchronous=NORMAL'); // FULL by default
    FDbHandler.ExecSQL('PRAGMA foreign_keys=ON'); // OFF by default
  except
    FDbHandler.Close;
  end;
end;

function TMapSvcScanStorage.DateTimeToDBSeconds(const AValue: TDateTime): Integer;
begin
  Result := Round((AValue - c_DBSecondsDateDelta) * SecsPerDay);
end;

function TMapSvcScanStorage.DBSecondsToDateTime(const AValue: Integer): TDateTime;
begin
  Result := AValue / SecsPerDay + c_DBSecondsDateDelta;
end;

destructor TMapSvcScanStorage.Destroy;
begin
  FInitialized := FALSE;
  FSync.BeginWrite;
  try
    FDbHandler.Close;
    FreeAndNil(FServices);
  finally
    FSync.EndWrite;
  end;
  inherited Destroy;
end;

function TMapSvcScanStorage.GetServiceId(const AServiceName: String): Integer;
var
  VServiceName: WideString;

  function _SelectId: Integer;
  begin
    Result := 0;
    FDbHandler.OpenSQLWithTEXTW(
      'SELECT id FROM svcinfo WHERE svcname=?',
      CallbackReadSingleInt,
      @Result,
      FALSE,
      TRUE,
      PWideChar(VServiceName),
      Length(VServiceName)
    );
  end;
  
begin
  FSync.BeginRead;
  try
    // get from list
    Result := FServices.IndexOf(AServiceName);
    if (Result>=0) then begin
      // found
      Result := Integer(Pointer(FServices.Objects[Result]));
      Exit;
    end;
  finally
    FSync.EndRead;
  end;

  // not found
  FSync.BeginWrite;
  try
    VServiceName := AServiceName;
    
    // select from database
    Result := _SelectId;

    // check row not found
    if (0=Result) then begin
      // insert row
      FDbHandler.ExecSQLWithTEXTW(
        'INSERT OR IGNORE INTO svcinfo(svcname) VALUES(?)',
        TRUE,
        PWideChar(VServiceName),
        Length(VServiceName)
      );
      // again
      Result := _SelectId;
    end;

    if (0<>Result) then begin
      FServices.AddObject(AServiceName, Pointer(Result));
    end;
  finally
    FSync.EndWrite;
  end;
end;

function TMapSvcScanStorage.ItemExists(
  const AServiceName: String;
  const AIdentifier: WideString;
  const AFetchedDate: PDateTime
): Boolean;
var
  VId: Integer;
  VDBSeconds: Integer;
begin
  Result := Available;
  if (not Result) then
    Exit;

  // get service id
  VId := GetServiceId(AServiceName);
  Result := (VId<>0);
  if (not Result) then
    Exit;

  try
    VDBSeconds := 0;
    FDbHandler.OpenSQLWithTEXTW(
      'SELECT itemdate FROM svcitem WHERE id='+IntToStr(VId)+' AND itemname=?',
      CallbackReadSingleInt,
      @VDBSeconds,
      TRUE,
      TRUE,
      PWideChar(AIdentifier),
      Length(AIdentifier)      
    );
    Result := (VDBSeconds<>0);
    if Result then begin
      if AFetchedDate<>nil then begin
        AFetchedDate^ := DBSecondsToDateTime(VDBSeconds);
      end;
    end;
  except
    Result := FALSE;
  end;
end;

end.
