unit u_MemFileCache;

interface

uses
  Windows,
  SysUtils,
  Classes,
  GR32,
  i_JclNotify,
  i_MemObjCache,
  i_MainMemCacheConfig,
  i_VectorDataItemSimple;

type
  TMemFileCacheVector = class(TInterfacedObject, IMemObjCacheVector)
  private
    FConfig: IMainMemCacheConfig;
    FConfigListener: IJclListener;
    FCacheVectorList: TStringList;
    FSync: TMultiReadExclusiveWriteSynchronizer;
    procedure OnChangeConfig(Sender: TObject);
  public
    constructor Create(AConfig: IMainMemCacheConfig);
    destructor Destroy; override;
    procedure Clear;
    procedure DeleteFileFromCache(path: string);
    procedure AddTileToCache(btm: IVectorDataItemList; APath: string);
    function TryLoadFileFromCache(var btm: IVectorDataItemList; APath: string): boolean;
  end;

  TMemFileCacheBitmap = class(TInterfacedObject, IMemObjCacheBitmap)
  private
    FConfig: IMainMemCacheConfig;
    FConfigListener: IJclListener;

    FCacheBmpList: TStringList;
    FSync: TMultiReadExclusiveWriteSynchronizer;
    procedure OnChangeConfig(Sender: TObject);
  public
    constructor Create(AConfig: IMainMemCacheConfig);
    destructor Destroy; override;
    procedure Clear;
    procedure DeleteFileFromCache(path: string);
    procedure AddTileToCache(btm: TCustomBitmap32; APath: string); overload;
    function TryLoadFileFromCache(btm: TCustomBitmap32; APath: string): boolean; overload;
  end;


implementation

uses
  u_NotifyEventListener;

{ TMemFileCache }

constructor TMemFileCacheVector.Create(AConfig: IMainMemCacheConfig);
begin
  FConfig := AConfig;
  FConfigListener := TNotifyEventListener.Create(Self.OnChangeConfig);
  FConfig.GetChangeNotifier.Add(FConfigListener);

  FCacheVectorList := TStringList.Create;
  FCacheVectorList.Capacity := FConfig.MaxSize;
  FSync := TMultiReadExclusiveWriteSynchronizer.Create;
end;

destructor TMemFileCacheVector.Destroy;
begin
  FConfig.GetChangeNotifier.Remove(FConfigListener);
  FConfigListener := nil;
  FConfig := nil;

  Clear;
  FreeAndNil(FSync);
  FreeAndNil(FCacheVectorList);
  inherited;
end;

procedure TMemFileCacheVector.OnChangeConfig(Sender: TObject);
var
  VNewSize: Integer;
  i: Integer;
begin
  VNewSize := FConfig.MaxSize;
  FSync.BeginWrite;
  try
    if VNewSize <> FCacheVectorList.Capacity then begin
      if VNewSize < FCacheVectorList.Count then begin
        for i := 0 to (FCacheVectorList.Count - VNewSize) - 1 do begin
          IInterface(Pointer(FCacheVectorList.Objects[0]))._Release;
          FCacheVectorList.Delete(0);
        end;
      end;
      FCacheVectorList.Capacity := VNewSize;
    end;
  finally
    FSync.EndWrite;
  end;
end;

procedure TMemFileCacheVector.Clear;
var
  i: integer;
begin
  FSync.BeginWrite;
  try
    for i := 0 to FCacheVectorList.Count - 1 do begin
      IInterface(Pointer(FCacheVectorList.Objects[i]))._Release;
    end;
    FCacheVectorList.Clear;
  finally
    FSync.EndWrite;
  end;
end;

procedure TMemFileCacheVector.DeleteFileFromCache(path: string);
var
  i: Integer;
begin
  FSync.BeginWrite;
  try
    i := FCacheVectorList.IndexOf(AnsiUpperCase(Path));
    if i >= 0 then begin
      IInterface(Pointer(FCacheVectorList.Objects[i]))._Release;
      FCacheVectorList.Delete(i);
    end;
  finally
    FSync.EndWrite;
  end;
end;

procedure TMemFileCacheVector.AddTileToCache(btm: IVectorDataItemList; APath: string);
var
  VPath: string;
  i: integer;
begin
  VPath := AnsiUpperCase(APath);
  FSync.BeginWrite;
  try
    i := FCacheVectorList.IndexOf(APath);
    if (i < 0)and(FCacheVectorList.Capacity>0) then begin
      if (FCacheVectorList.Count >= FCacheVectorList.Capacity)and(FCacheVectorList.Count>0) then begin
        IInterface(Pointer(FCacheVectorList.Objects[0]))._Release;
        FCacheVectorList.Delete(0);
      end;
      btm._AddRef;
      FCacheVectorList.AddObject(APath, Pointer(btm));
    end;
  finally
    FSync.EndWrite;
  end;
end;

function TMemFileCacheVector.TryLoadFileFromCache(var btm: IVectorDataItemList;
  APath: string): boolean;
var
  i: integer;
  VPath: string;
begin
  Result := false;
  VPath := AnsiUpperCase(APath);
  FSync.BeginRead;
  try
    i := FCacheVectorList.IndexOf(VPath);
    if i >= 0 then begin
      btm := IVectorDataItemList(Pointer(FCacheVectorList.Objects[i]));
      result := true;
    end;
  finally
    FSync.EndRead;
  end;
end;

{ TMemFileCacheBitmap }

constructor TMemFileCacheBitmap.Create(AConfig: IMainMemCacheConfig);
begin
  FConfig := AConfig;
  FConfigListener := TNotifyEventListener.Create(Self.OnChangeConfig);
  FConfig.GetChangeNotifier.Add(FConfigListener);

  FCacheBmpList := TStringList.Create;
  FCacheBmpList.Capacity := FConfig.MaxSize;
  FSync := TMultiReadExclusiveWriteSynchronizer.Create;
end;

destructor TMemFileCacheBitmap.Destroy;
begin
  FConfig.GetChangeNotifier.Remove(FConfigListener);
  FConfigListener := nil;
  FConfig := nil;

  Clear;
  FreeAndNil(FSync);
  FreeAndNil(FCacheBmpList);
  inherited;
end;

procedure TMemFileCacheBitmap.AddTileToCache(btm: TCustomBitmap32;
  APath: string);
var
  btmcache: TCustomBitmap32;
  VPath: string;
  i: integer;
begin
  VPath := AnsiUpperCase(APath);
  FSync.BeginWrite;
  try
    i := FCacheBmpList.IndexOf(APath);
    if (i < 0)and(FCacheBmpList.Capacity>0) then begin
      if (FCacheBmpList.Count >= FCacheBmpList.Capacity)and(FCacheBmpList.Count>0) then begin
        FCacheBmpList.Objects[0].Free;
        FCacheBmpList.Delete(0);
      end;
      btmcache := TCustomBitmap32.Create;
      btmcache.Assign(btm);
      FCacheBmpList.AddObject(APath, btmcache);
    end;
  finally
    FSync.EndWrite;
  end;
end;

procedure TMemFileCacheBitmap.Clear;
var
  i: integer;
begin
  FSync.BeginWrite;
  try
    for i := 0 to FCacheBmpList.Count - 1 do begin
      FCacheBmpList.Objects[i].Free;
    end;
    FCacheBmpList.Clear;
  finally
    FSync.EndWrite;
  end;
end;

procedure TMemFileCacheBitmap.DeleteFileFromCache(path: string);
var
  i: Integer;
begin
  FSync.BeginWrite;
  try
    i := FCacheBmpList.IndexOf(AnsiUpperCase(Path));
    if i >= 0 then begin
      FCacheBmpList.Objects[i].Free;
      FCacheBmpList.Delete(i);
    end;
  finally
    FSync.EndWrite;
  end;
end;

procedure TMemFileCacheBitmap.OnChangeConfig(Sender: TObject);
var
  VNewSize: Integer;
  i: Integer;
begin
  VNewSize := FConfig.MaxSize;
  FSync.BeginWrite;
  try
    if VNewSize <> FCacheBmpList.Capacity then begin
      if VNewSize < FCacheBmpList.Count then begin
        for i := 0 to (FCacheBmpList.Count - VNewSize) - 1 do begin
          FCacheBmpList.Objects[0].Free;
          FCacheBmpList.Delete(0);
        end;
      end;
      FCacheBmpList.Capacity := VNewSize;
    end;
  finally
    FSync.EndWrite;
  end;
end;

function TMemFileCacheBitmap.TryLoadFileFromCache(btm: TCustomBitmap32;
  APath: string): boolean;
var
  i: integer;
  VPath: string;
begin
  Result := false;
  VPath := AnsiUpperCase(APath);
  FSync.BeginRead;
  try
    i := FCacheBmpList.IndexOf(VPath);
    if i >= 0 then begin
      btm.Assign(TCustomBitmap32(FCacheBmpList.Objects[i]));
      result := true;
    end;
  finally
    FSync.EndRead;
  end;
end;

end.
