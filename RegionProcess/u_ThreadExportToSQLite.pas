unit u_ThreadExportToSQLite;

interface

uses
  Windows,
  Types,
  SysUtils,
  Classes,
  SQLite3Handler,
  i_NotifierOperation,
  i_RegionProcessProgressInfo,
  i_CoordConverterFactory,
  i_VectorItemsFactory,
  i_VectorItemLonLat,
  i_TileInfoBasic,
  i_TileStorage,
  i_MapVersionInfo,
  i_MapTypes,
  u_MapType,
  u_ResStrings,
  u_ThreadExportEnumerator;

type
  TThreadExportToSQLite = class(TThreadExportEnumerator)
  protected
    FSQLiteAvailable: Boolean;
  protected
    procedure CloseTargetStorage(const AEEData: PExportEnumeratorData); virtual;
  protected
    procedure InitializeExportEnumeratorData(out AEEData: PExportEnumeratorData); override;
    procedure UninitializeExportEnumeratorData(var AEEData: PExportEnumeratorData); override;
    procedure CreateTargetStorage(
      const ASourceMapType: TMapType;
      const AEEData: PExportEnumeratorData
    ); override;
  end;

  TThreadExportRMapsSQLite = class(TThreadExportToSQLite)
  private
    FInsertSQLText: AnsiString;
  protected
    procedure CloseTargetStorage(const AEEData: PExportEnumeratorData); override;
  protected
    procedure CreateTargetStorage(
      const ASourceMapType: TMapType;
      const AEEData: PExportEnumeratorData
    ); override;
    procedure SaveTileToTargetStorage(
      const ASourceMapType: TMapType;
      const AEEData: PExportEnumeratorData;
      const AEETile: PExportEnumeratorTile;
      const ATileInfo: ITileInfoWithData
    ); override;
  end;

implementation

uses
  ALSqlite3Wrapper,
  i_VectorItemProjected,
  i_CoordConverter,
  i_TileIterator,
  u_TileIteratorByPolygon;

type
  PEEToSQLiteData = ^TEEToSQLiteData;
  TEEToSQLiteData = record
    Base: TExportEnumeratorData;
    SQLite3Db: TSQLite3DbHandler;
    CreateNewDB: Boolean;
  end;
  
{ TThreadExportToSQLite }

procedure TThreadExportToSQLite.CloseTargetStorage(const AEEData: PExportEnumeratorData);
begin
  if (AEEData<>nil) then
  with PEEToSQLiteData(AEEData)^ do
  if SQLite3Db.Opened then begin
    SQLite3Db.Commit;
    SQLite3Db.Close;
  end;
end;

procedure TThreadExportToSQLite.CreateTargetStorage(
  const ASourceMapType: TMapType;
  const AEEData: PExportEnumeratorData
);
begin
  // check library
  if (not FSQLiteAvailable) then
    raise ESQLite3SimpleError.Create('SQLite not available');

  // ��������� ���������� (���� ����)
  CloseTargetStorage(AEEData);

  // make sqlite database
  if FileExists(FExportPath) then begin
    // ���� ��� ���� - ����� ���������� ��� �������
    if FForceDropTarget then begin
      DeleteFile(FExportPath);
      PEEToSQLiteData(AEEData)^.CreateNewDB := TRUE;
    end else begin
      PEEToSQLiteData(AEEData)^.CreateNewDB := FALSE;
    end;
  end else begin
    // ���� ��� ���
    PEEToSQLiteData(AEEData)^.CreateNewDB := TRUE;
  end;

  with PEEToSQLiteData(AEEData)^ do begin
    // ������ ����� ��� ��������� ������������
    SQLite3Db.OpenW(FExportPath);
  end;
end;

procedure TThreadExportToSQLite.InitializeExportEnumeratorData(out AEEData: PExportEnumeratorData);
begin
  AEEData := HeapAlloc(GetProcessHeap, HEAP_ZERO_MEMORY, SizeOf(TEEToSQLiteData));
  FSQLiteAvailable := PEEToSQLiteData(AEEData)^.SQLite3Db.Init;
end;

procedure TThreadExportToSQLite.UninitializeExportEnumeratorData(var AEEData: PExportEnumeratorData);
begin
  if (nil=AEEData) then
    Exit;

  // ��������� ����
  CloseTargetStorage(AEEData);

  // ������� �������
  with PEEToSQLiteData(AEEData)^ do begin
    Base.Uninit;
  end;

  // ����������� ������
  HeapFree(GetProcessHeap, 0, AEEData);
  AEEData := nil;
end;

{ TThreadExportRMapsSQLite }

procedure TThreadExportRMapsSQLite.CloseTargetStorage(const AEEData: PExportEnumeratorData);
begin
  // ����� ��������� ���� �������� ����
  if (AEEData<>nil) then
  with PEEToSQLiteData(AEEData)^ do
  if SQLite3Db.Opened then begin
    SQLite3Db.ExecSQL('UPDATE info SET minzoom = (SELECT DISTINCT z FROM tiles ORDER BY z ASC LIMIT 1)');
    SQLite3Db.ExecSQL('UPDATE info SET maxzoom = (SELECT DISTINCT z FROM tiles ORDER BY z DESC LIMIT 1)');
  end;
  
  // ��������
  inherited;
end;

procedure TThreadExportRMapsSQLite.CreateTargetStorage(
  const ASourceMapType: TMapType;
  const AEEData: PExportEnumeratorData
);
begin
  // ������ ��� ��������� ��
  inherited;

  // ����������� ����� SQL
  if FIsReplace then
    FInsertSQLText := 'REPLACE'
  else
    FInsertSQLText := 'IGNORE';

  FInsertSQLText := 'INSERT OR '+FInsertSQLText+' INTO tiles (x,y,z,s,image) VALUES (';

  // ���� ����� - �������� ���������
  with PEEToSQLiteData(AEEData)^ do begin
    if CreateNewDB then begin
      SQLite3Db.ExecSQL('CREATE TABLE IF NOT EXISTS tiles (x int, y int, z int, s int, image blob, PRIMARY KEY (x,y,z,s))');
      SQLite3Db.ExecSQL('CREATE TABLE IF NOT EXISTS info (maxzoom Int, minzoom Int)');
      SQLite3Db.ExecSQL('INSERT OR REPLACE INTO info (maxzoom, minzoom) VALUES (0,0)');
    end;

    SQLite3Db.SetExclusiveLockingMode;
    SQLite3Db.ExecSQL('PRAGMA synchronous=OFF');

    // ��������� ���������� ��� ����� ��������
    SQLite3Db.BeginTran;
  end;

(*
��� ����
CREATE TABLE android_metadata (
  locale  text
);
� ����� �������
'en_US'
*)
end;

procedure TThreadExportRMapsSQLite.SaveTileToTargetStorage(
  const ASourceMapType: TMapType;
  const AEEData: PExportEnumeratorData;
  const AEETile: PExportEnumeratorTile;
  const ATileInfo: ITileInfoWithData
);
var
  VSQLText: AnsiString;
begin

  VSQLText := FInsertSQLText+
              IntToStr(AEETile^.Tile.X)+','+
              IntToStr(AEETile^.Tile.Y)+','+
              IntToStr(17-AEETile^.Zoom)+
              ',0,?)';

  PEEToSQLiteData(AEEData)^.SQLite3Db.ExecSQLWithBLOB(
    VSQLText,
    ATileInfo.TileData.Buffer,
    ATileInfo.TileData.Size
  );
end;

end.


