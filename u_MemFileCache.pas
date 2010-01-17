unit u_MemFileCache;

interface

uses
  SysUtils,
  Classes,
  GR32;

type
  TMemFileCache = class
  private
    FCacheElemensMaxCnt: integer;
    FCacheList:TStringList;
    FSync: TMultiReadExclusiveWriteSynchronizer;
    procedure SetCacheElemensMaxCnt(const Value: integer);
  public
    constructor Create();
    destructor Destroy; override;
    procedure Clear;
    procedure DeleteFileFromCache(path:string);
    procedure AddTileToCache(btm: TBitmap32; APath: string);
    function TryLoadFileFromCache(btm: TBitmap32; APath: string):boolean;

    property CacheElemensMaxCnt: integer read FCacheElemensMaxCnt write SetCacheElemensMaxCnt;
  end;

implementation

{ TMemFileCache }

constructor TMemFileCache.Create;
begin
  FCacheElemensMaxCnt := 100;
  FCacheList := TStringList.Create;
  FSync := TMultiReadExclusiveWriteSynchronizer.Create;
end;

destructor TMemFileCache.Destroy;
begin
  Clear;
  FreeAndNil(FSync);
  FreeAndNil(FCacheList);
  inherited;
end;

procedure TMemFileCache.Clear;
var
  i: integer;
begin
  FSync.BeginWrite;
  try
    for i:=0 to FCacheList.Count-1 do
      FCacheList.Objects[i].Free;
    FCacheList.Clear;
  finally
    FSync.EndWrite;
  end;
end;

procedure TMemFileCache.SetCacheElemensMaxCnt(const Value: integer);
var i:integer;
begin
  if Value<FCacheList.Count then begin
    for i:=0 to (FCacheList.Count-Value)-1 do begin
      FCacheList.Objects[0].Free;
      FCacheList.Delete(0);
    end;
  end;
  FCacheElemensMaxCnt := Value;
end;

procedure TMemFileCache.DeleteFileFromCache(path: string);
var
  i: Integer;
begin
  if FSync.BeginWrite then begin
    try
      i := FCacheList.IndexOf(AnsiUpperCase(Path));
      if i >= 0 then begin
        FCacheList.Objects[i].Free;
        FCacheList.Delete(i);
      end;
    finally
      FSync.EndWrite;
    end;
  end;

end;

procedure TMemFileCache.AddTileToCache(btm: TBitmap32; APath: string);
var
  btmcache:TBitmap32;
  i:integer;
  VPath: string;
begin
  VPath := AnsiUpperCase(APath);
  btmcache:=TBitmap32.Create;
  btmcache.Assign(btm);
  if FSync.BeginWrite then begin
    try
      i:=FCacheList.IndexOf(VPath);
      if i<0 then begin
        FCacheList.AddObject(VPath, btmcache);
        if FCacheList.Count > FCacheElemensMaxCnt then begin
          FCacheList.Objects[0].Free;
          FCacheList.Delete(0);
        end;
      end else begin
        FreeAndNil(btmcache);
      end;
    finally
      FSync.EndWrite;
    end;
  end;
end;

function TMemFileCache.TryLoadFileFromCache(btm: TBitmap32;
  APath: string): boolean;
var
  i: integer;
  VPath: string;
begin
  Result := false;
  VPath := AnsiUpperCase(APath);
  FSync.BeginRead;
  try
    i:=FCacheList.IndexOf(VPath);
    if i>=0 then begin
      btm.Assign(TBitmap32(FCacheList.Objects[i]));
      result:=true;
    end;
  finally
    FSync.EndRead;
  end;
end;

end.
