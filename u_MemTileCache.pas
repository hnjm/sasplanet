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

unit u_MemTileCache;

interface

uses
  Types,
  Classes,
  SysUtils,
  i_Notifier,
  i_Listener,
  i_InternalPerformanceCounter,
  i_MainMemCacheConfig,
  i_Bitmap32Static,
  i_VectorDataItemSimple,
  i_ListenerTTLCheck,
  i_NotifierTTLCheck,
  i_TileObjCache,
  i_CoordConverter,
  i_TileStorage;

type
  TMemTileCacheBase = class(TInterfacedObject)
  private
    FConfig: IMainMemCacheConfig;
    FGCList: INotifierTTLCheck;
    FConfigListener: IListener;
    FTileStorage: ITileStorage;
    FCoordConverter: ICoordConverter;
    FStorageChangeListener: IListener;
    FTTLListener: IListenerTTLCheck;

    FCacheList: TStringList;
    FSync: IReadWriteSync;

    FClearCounter: IInternalPerformanceCounter;
    FAddItemCounter: IInternalPerformanceCounter;
    FDeleteItemCounter: IInternalPerformanceCounter;
    FCacheHitCounter: IInternalPerformanceCounter;
    FCacheMissCounter: IInternalPerformanceCounter;
    procedure OnChangeConfig;
    procedure OnTileStorageChange(const AMsg: IInterface);
    function GetMemCacheKey(
      const AXY: TPoint;
      const AZoom: byte
    ): string;
    procedure OnTTLTrim(Sender: TObject);
  protected
    procedure ItemFree(AIndex: Integer);
    procedure IncUpdateCounter;
  protected
    procedure Clear;
    procedure DeleteTileFromCache(
      const AXY: TPoint;
      const AZoom: Byte
    );
    procedure DeleteTileRectFromCache(
      const ARect: TRect;
      const AZoom: Byte
    );
    procedure AddObjectToCache(
      const AObj: IInterface;
      const AXY: TPoint;
      const AZoom: Byte
    );
    function TryLoadObjectFromCache(
      const AXY: TPoint;
      const AZoom: Byte;
      const AIID: TGUID;
      out AResult
    ): Boolean;
  public
    constructor Create(
      const AGCList: INotifierTTLCheck;
      const ATileStorage: ITileStorage;
      const ACoordConverter: ICoordConverter;
      const AConfig: IMainMemCacheConfig;
      const APerfList: IInternalPerformanceCounterList
    );
    destructor Destroy; override;
  end;

  TMemTileCacheVector = class(TMemTileCacheBase, ITileObjCacheVector)
  protected
    procedure AddTileToCache(
      const AObj: IVectorDataItemList;
      const AXY: TPoint;
      const AZoom: Byte
    );
    function TryLoadTileFromCache(
      const AXY: TPoint;
      const AZoom: Byte
    ): IVectorDataItemList;
  end;

  TMemTileCacheBitmap = class(TMemTileCacheBase, ITileObjCacheBitmap)
  protected
    procedure AddTileToCache(
      const AObj: IBitmap32Static;
      const AXY: TPoint;
      const AZoom: Byte
    );
    function TryLoadTileFromCache(
      const AXY: TPoint;
      const AZoom: Byte
    ): IBitmap32Static;
  end;

implementation

uses
  i_TileKey,
  i_TileRect,
  i_NotifierTileRectUpdate,
  u_ListenerTTLCheck,
  u_Synchronizer,
  u_ListenerByEvent;

{ TTileCacheBase }

constructor TMemTileCacheBase.Create(
  const AGCList: INotifierTTLCheck;
  const ATileStorage: ITileStorage;
  const ACoordConverter: ICoordConverter;
  const AConfig: IMainMemCacheConfig;
  const APerfList: IInternalPerformanceCounterList
);
var
  VNotifier: INotifierTileRectUpdate;
begin
  inherited Create;
  FConfig := AConfig;
  FGCList := AGCList;
  FConfigListener := TNotifyNoMmgEventListener.Create(Self.OnChangeConfig);
  FConfig.GetChangeNotifier.Add(FConfigListener);

  if ATileStorage <> nil then begin
    FTileStorage := ATileStorage;
    FCoordConverter := ACoordConverter;
    FStorageChangeListener := TNotifyEventListener.Create(Self.OnTileStorageChange);
    VNotifier := FTileStorage.TileNotifier;
    if VNotifier <> nil then begin
      VNotifier.AddListener(FStorageChangeListener);
    end;
  end;
  FCacheList := TStringList.Create;
  FCacheList.Capacity := FConfig.MaxSize;
  FSync := MakeSyncRW_Big(Self, False);
  FTTLListener := TListenerTTLCheck.Create(Self.OnTTLTrim, 40000, 1000);
  FGCList.Add(FTTLListener);

  FAddItemCounter := APerfList.CreateAndAddNewCounter('Add');
  FDeleteItemCounter := APerfList.CreateAndAddNewCounter('Delete');
  FClearCounter := APerfList.CreateAndAddNewCounter('Clear');
  FCacheHitCounter := APerfList.CreateAndAddNewCounter('CacheHit');
  FCacheMissCounter := APerfList.CreateAndAddNewCounter('CacheMiss');
end;

destructor TMemTileCacheBase.Destroy;
var
  VNotifier: INotifierTileRectUpdate;
begin
  FConfig.GetChangeNotifier.Remove(FConfigListener);
  FConfigListener := nil;
  FConfig := nil;

  FGCList.Remove(FTTLListener);
  FTTLListener := nil;
  FGCList := nil;

  if FTileStorage <> nil then begin
    VNotifier := FTileStorage.TileNotifier;
    if VNotifier <> nil then begin
      VNotifier.Remove(FStorageChangeListener);
    end;
    FTileStorage := nil;
  end;
  FStorageChangeListener := nil;
  FCoordConverter := nil;

  Clear;
  FreeAndNil(FCacheList);
  inherited;
end;

procedure TMemTileCacheBase.AddObjectToCache(
  const AObj: IInterface;
  const AXY: TPoint;
  const AZoom: Byte
);
var
  VKey: string;
  i: integer;
  VContext: TInternalPerformanceCounterContext;
begin
  VKey := GetMemCacheKey(AXY, AZoom);

  VContext := FAddItemCounter.StartOperation;
  try
    FSync.BeginWrite;
    try
      i := FCacheList.IndexOf(VKey);
      if (i < 0) and (FCacheList.Capacity > 0) then begin
        if (FCacheList.Count >= FCacheList.Capacity) and (FCacheList.Count > 0) then begin
          ItemFree(0);
          FCacheList.Delete(0);
        end;
        AObj._AddRef;
        FCacheList.AddObject(VKey, Pointer(AObj));
      end;
    finally
      FSync.EndWrite;
    end;
  finally
    FAddItemCounter.FinishOperation(VContext);
  end;
end;

procedure TMemTileCacheBase.Clear;
var
  i: integer;
  VContext: TInternalPerformanceCounterContext;
begin
  VContext := FClearCounter.StartOperation;
  try
    FSync.BeginWrite;
    try
      for i := FCacheList.Count - 1 downto 0 do begin
        ItemFree(i);
        FCacheList.Delete(i);
      end;
    finally
      FSync.EndWrite;
    end;
  finally
    FClearCounter.FinishOperation(VContext);
  end;
end;

procedure TMemTileCacheBase.DeleteTileFromCache(
  const AXY: TPoint;
  const AZoom: Byte
);
var
  i: Integer;
  VKey: string;
  VContext: TInternalPerformanceCounterContext;
begin
  VKey := GetMemCacheKey(AXY, AZoom);
  VContext := FDeleteItemCounter.StartOperation;
  try
    FSync.BeginWrite;
    try
      i := FCacheList.IndexOf(VKey);
      if i >= 0 then begin
        ItemFree(i);
        FCacheList.Delete(i);
      end;
    finally
      FSync.EndWrite;
    end;
  finally
    FDeleteItemCounter.FinishOperation(VContext);
  end;
end;

procedure TMemTileCacheBase.DeleteTileRectFromCache(
  const ARect: TRect;
  const AZoom: Byte
);
var
  VSize: TPoint;
  VTile: TPoint;
  i, j: Integer;
  VKey: string;
  VIndex: Integer;
begin
  VSize.X := ARect.Right - ARect.Left;
  VSize.Y := ARect.Bottom - ARect.Top;
  if (VSize.X > 0) and (VSize.Y > 0) then begin
    if (VSize.X > 2) or (VSize.Y > 2) then begin
      Clear;
    end else begin
      FSync.BeginWrite;
      try
        for j := ARect.Left to ARect.Right - 1 do begin
          VTile.X := j;
          for i := ARect.Top to ARect.Bottom - 1 do begin
            VTile.Y := i;
            VKey := GetMemCacheKey(VTile, AZoom);
            VIndex := FCacheList.IndexOf(VKey);
            if VIndex >= 0 then begin
              ItemFree(VIndex);
              FCacheList.Delete(VIndex);
            end;
          end;
        end;
      finally
        FSync.EndWrite;
      end;
    end;
  end;
end;

function TMemTileCacheBase.GetMemCacheKey(
  const AXY: TPoint;
  const AZoom: byte
): string;
begin
  Result := inttostr(AZoom) + '_' + inttostr(AXY.X) + '_' + inttostr(AXY.Y);
end;

procedure TMemTileCacheBase.IncUpdateCounter;
begin
  FTTLListener.UpdateUseTime;
end;

procedure TMemTileCacheBase.ItemFree(AIndex: Integer);
begin
  IInterface(Pointer(FCacheList.Objects[AIndex]))._Release;
end;

procedure TMemTileCacheBase.OnChangeConfig;
var
  VNewSize: Integer;
  i: Integer;
begin
  VNewSize := FConfig.MaxSize;
  FSync.BeginWrite;
  try
    if VNewSize <> FCacheList.Capacity then begin
      if VNewSize < FCacheList.Count then begin
        for i := 0 to (FCacheList.Count - VNewSize) - 1 do begin
          ItemFree(0);
          FCacheList.Delete(0);
        end;
      end;
      FCacheList.Capacity := VNewSize;
    end;
  finally
    FSync.EndWrite;
  end;
end;

procedure TMemTileCacheBase.OnTileStorageChange(const AMsg: IInterface);
var
  VTileKey: ITileKey;
  VTileRect: ITileRect;
begin
  if Supports(AMsg, ITileKey, VTileKey) then begin
    DeleteTileFromCache(VTileKey.Tile, VTileKey.Zoom);
  end else if Supports(AMsg, ITileRect, VTileRect) then begin
    DeleteTileRectFromCache(VTileRect.Rect, VTileRect.Zoom);
  end else begin
    Clear;
  end;
end;

procedure TMemTileCacheBase.OnTTLTrim(Sender: TObject);
begin
  Clear;
end;

function TMemTileCacheBase.TryLoadObjectFromCache(
  const AXY: TPoint;
  const AZoom: Byte;
  const AIID: TGUID;
  out AResult
): Boolean;
var
  i: integer;
  VKey: string;
  VContext: TInternalPerformanceCounterContext;
begin
  Result := False;
  VKey := GetMemCacheKey(AXY, AZoom);
  VContext := FCacheHitCounter.StartOperation;
  try
    FSync.BeginRead;
    try
      i := FCacheList.IndexOf(VKey);
      if i >= 0 then begin
        Result :=
          Supports(
            IInterface(Pointer(FCacheList.Objects[i])),
            AIID,
            AResult
          );
      end;
    finally
      FSync.EndRead;
    end;
  finally
    if Result then begin
      FCacheHitCounter.FinishOperation(VContext);
    end else begin
      FCacheMissCounter.FinishOperation(VContext);
    end;
  end;
  if Result then begin
    IncUpdateCounter;
  end;
end;

{ TMemTileCacheVector }

procedure TMemTileCacheVector.AddTileToCache(
  const AObj: IVectorDataItemList;
  const AXY: TPoint;
  const AZoom: Byte
);
var
  VKey: string;
  i: integer;
begin
  VKey := GetMemCacheKey(AXY, AZoom);
  FSync.BeginWrite;
  try
    i := FCacheList.IndexOf(VKey);
    if (i < 0) and (FCacheList.Capacity > 0) then begin
      if (FCacheList.Count >= FCacheList.Capacity) and (FCacheList.Count > 0) then begin
        ItemFree(0);
        FCacheList.Delete(0);
      end;
      AObj._AddRef;
      FCacheList.AddObject(VKey, Pointer(AObj));
    end;
  finally
    FSync.EndWrite;
  end;
end;

function TMemTileCacheVector.TryLoadTileFromCache(
  const AXY: TPoint;
  const AZoom: Byte
): IVectorDataItemList;
begin
  if not TryLoadObjectFromCache(AXY, AZoom, IVectorDataItemList, Result) then begin
    Result := nil;
  end;
end;

{ TMemTileCacheBitmap }

procedure TMemTileCacheBitmap.AddTileToCache(
  const AObj: IBitmap32Static;
  const AXY: TPoint;
  const AZoom: Byte
);
begin
  AddObjectToCache(AObj, AXY, AZoom);
end;

function TMemTileCacheBitmap.TryLoadTileFromCache(
  const AXY: TPoint;
  const AZoom: Byte
): IBitmap32Static;
begin
  if not TryLoadObjectFromCache(AXY, AZoom, IBitmap32Static, Result) then begin
    Result := nil;
  end;
end;

end.
