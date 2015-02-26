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

unit u_VectorItemSubsetChangeableForVectorLayers;

interface

uses
  SysUtils,
  t_GeoTypes,
  i_VectorItemSubsetBuilder,
  i_VectorItemSubset,
  i_VectorItemSubsetChangeable,
  i_Listener,
  i_InterfaceListSimple,
  i_TileRect,
  i_TileRectChangeable,
  i_ThreadConfig,
  i_BackgroundTask,
  i_MapVersionRequest,
  i_MapType,
  i_MapTypeSet,
  i_MapTypeSetChangeable,
  i_SimpleFlag,
  i_NotifierOperation,
  i_VectorDataItemSimple,
  i_InterfaceListStatic,
  i_InternalPerformanceCounter,
  i_ListenerNotifierLinksList,
  i_TileError,
  u_ChangeableBase;

type
  TVectorItemSubsetChangeableForVectorLayers = class(TChangeableWithSimpleLockBase, IVectorItemSubsetChangeable)
  private
    FLayersSet: IMapTypeSetChangeable;
    FErrorLogger: ITileErrorLogger;
    FVectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory;
    FTileRect: ITileRectChangeable;
    FAppStartedNotifier: INotifierOneOperation;
    FAppClosingNotifier: INotifierOneOperation;

    FAppStartedListener: IListener;
    FAppClosingListener: IListener;

    FPrepareResultTask: IBackgroundTask;
    FLinksList: IListenerNotifierLinksList;
    FSubsetPrepareCounter: IInternalPerformanceCounter;
    FOneTilePrepareCounter: IInternalPerformanceCounter;

    FPrevLayerSet: IMapTypeSet;
    FPrevTileRect: ITileRect;
    FLayerListeners: IInterfaceListStatic;
    FVersionListener: IListener;

    FDelicateUpdateFlag: ISimpleFlag;

    FResult: IVectorItemSubset;

    procedure OnAppStarted;
    procedure OnAppClosing;

    procedure OnPosChange;
    procedure OnLayerSetChange;

    procedure OnMapVersionChange;
    procedure OnTileUpdate(const AMsg: IInterface);
    procedure OnPrepareSubset(
      AOperationID: Integer;
      const ACancelNotifier: INotifierOperation
    );
    function PrepareSubset(
      AOperationID: Integer;
      const ACancelNotifier: INotifierOperation;
      const ATileRect: ITileRect;
      const ALayerSet: IMapTypeSet
    ): IVectorItemSubset;
    procedure AddWikiElement(
      const AElments: IVectorItemSubsetBuilder;
      const AData: IVectorDataItem;
      const ATileRect: ITileRect
    );
    procedure AddElementsFromMap(
      AOperationID: Integer;
      const ACancelNotifier: INotifierOperation;
      const AElments: IVectorItemSubsetBuilder;
      const AAlayer: IMapType;
      const AVersion: IMapVersionRequest;
      const ATileRect: ITileRect
    );

    procedure RemoveLayerListeners(
      const ALayerSet: IMapTypeSet
    );
    procedure AddLayerListeners(
      const ATileRect: ITileRect;
      const ALayerSet: IMapTypeSet
    );
    procedure RemoveVersionListener(
      const ALayerSet: IMapTypeSet
    );
    procedure AddVersionListener(
      const ALayerSet: IMapTypeSet
    );
  private
    function GetStatic: IVectorItemSubset;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  public
    constructor Create(
      const APerfList: IInternalPerformanceCounterList;
      const AAppStartedNotifier: INotifierOneOperation;
      const AAppClosingNotifier: INotifierOneOperation;
      const ATileRect: ITileRectChangeable;
      const ALayersSet: IMapTypeSetChangeable;
      const AErrorLogger: ITileErrorLogger;
      const AVectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory;
      const AThreadConfig: IThreadConfig
    );
    destructor Destroy; override;
  end;

implementation

uses
  Types,
  i_NotifierTilePyramidUpdate,
  i_CoordConverter,
  i_TileIterator,
  i_LonLatRect,
  u_InterfaceListSimple,
  u_SimpleFlagWithInterlock,
  u_ListenerNotifierLinksList,
  u_BackgroundTask,
  u_TileUpdateListenerToLonLat,
  u_ListenerByEvent,
  u_TileIteratorByRect,
  u_TileErrorInfo,
  u_ResStrings,
  u_GeoFunc;

{ TVectorItemSubsetChangeableForVectorLayers }

constructor TVectorItemSubsetChangeableForVectorLayers.Create(
  const APerfList: IInternalPerformanceCounterList;
  const AAppStartedNotifier: INotifierOneOperation;
  const AAppClosingNotifier: INotifierOneOperation;
  const ATileRect: ITileRectChangeable;
  const ALayersSet: IMapTypeSetChangeable;
  const AErrorLogger: ITileErrorLogger;
  const AVectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory;
  const AThreadConfig: IThreadConfig
);
begin
  Assert(Assigned(ATileRect));
  Assert(Assigned(ALayersSet));
  Assert(Assigned(AErrorLogger));
  Assert(Assigned(AVectorItemSubsetBuilderFactory));
  inherited Create;
  FTileRect := ATileRect;
  FLayersSet := ALayersSet;
  FErrorLogger := AErrorLogger;
  FVectorItemSubsetBuilderFactory := AVectorItemSubsetBuilderFactory;

  FSubsetPrepareCounter := APerfList.CreateAndAddNewCounter('SubsetPrepare');
  FOneTilePrepareCounter := APerfList.CreateAndAddNewCounter('OneTilePrepare');

  FAppStartedNotifier := AAppStartedNotifier;
  FAppClosingNotifier := AAppClosingNotifier;

  FDelicateUpdateFlag := TSimpleFlagWithInterlock.Create;
  FLinksList := TListenerNotifierLinksList.Create;
  FAppStartedListener := TNotifyNoMmgEventListener.Create(Self.OnAppStarted);
  FAppClosingListener := TNotifyNoMmgEventListener.Create(Self.OnAppClosing);

  FVersionListener := TNotifyNoMmgEventListener.Create(Self.OnMapVersionChange);

  FLinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnPosChange),
    FTileRect.ChangeNotifier
  );

  FLinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnLayerSetChange),
    FLayersSet.ChangeNotifier
  );
  FPrepareResultTask :=
    TBackgroundTask.Create(
      AAppClosingNotifier,
      OnPrepareSubset,
      AThreadConfig,
      Self.ClassName
    );

end;

destructor TVectorItemSubsetChangeableForVectorLayers.Destroy;
begin
  RemoveLayerListeners(FPrevLayerSet);
  RemoveVersionListener(FPrevLayerSet);

  FLinksList := nil;

  if Assigned(FAppStartedNotifier) and Assigned(FAppStartedListener) then begin
    FAppStartedNotifier.Remove(FAppStartedListener);
    FAppStartedNotifier := nil;
  end;
  if Assigned(FAppClosingNotifier) and Assigned(FAppClosingListener) then begin
    FAppClosingNotifier.Remove(FAppClosingListener);
    FAppClosingNotifier := nil;
  end;

  inherited;
end;

procedure TVectorItemSubsetChangeableForVectorLayers.AfterConstruction;
begin
  inherited;
  FAppStartedNotifier.Add(FAppStartedListener);
  if FAppStartedNotifier.IsExecuted then begin
    OnAppStarted;
  end;
  FAppClosingNotifier.Add(FAppClosingListener);
  if FAppClosingNotifier.IsExecuted then begin
    OnAppClosing;
  end;
end;

procedure TVectorItemSubsetChangeableForVectorLayers.BeforeDestruction;
begin
  inherited;
  OnAppClosing;
end;

function TVectorItemSubsetChangeableForVectorLayers.GetStatic: IVectorItemSubset;
begin
  CS.BeginRead;
  try
    Result := FResult;
  finally
    CS.EndRead;
  end;
end;

procedure TVectorItemSubsetChangeableForVectorLayers.OnAppClosing;
begin
  FLinksList.DeactivateLinks;
  FPrepareResultTask.Terminate;
end;

procedure TVectorItemSubsetChangeableForVectorLayers.OnAppStarted;
begin
  FLinksList.ActivateLinks;
  FPrepareResultTask.Start;
  FPrepareResultTask.StartExecute;
end;

procedure TVectorItemSubsetChangeableForVectorLayers.OnLayerSetChange;
begin
  FPrepareResultTask.StopExecute;
  FPrepareResultTask.StartExecute;
end;

procedure TVectorItemSubsetChangeableForVectorLayers.OnMapVersionChange;
begin
  FPrepareResultTask.StopExecute;
  FPrepareResultTask.StartExecute;
end;

procedure TVectorItemSubsetChangeableForVectorLayers.OnPosChange;
begin
  FPrepareResultTask.StopExecute;
  FPrepareResultTask.StartExecute;
end;

procedure TVectorItemSubsetChangeableForVectorLayers.AddVersionListener(
  const ALayerSet: IMapTypeSet
);
var
  VMap: IMapType;
  i: Integer;
begin
  if Assigned(ALayerSet) then begin
    for i := 0 to ALayerSet.Count - 1 do begin
      VMap := ALayerSet.Items[i];
      Assert(Assigned(VMap));
      VMap.VersionRequestConfig.ChangeNotifier.Add(FVersionListener);
    end;
  end;
end;

procedure TVectorItemSubsetChangeableForVectorLayers.AddLayerListeners(
  const ATileRect: ITileRect;
  const ALayerSet: IMapTypeSet
);
var
  VListeners: IInterfaceListSimple;
  VListener: IListener;
  VMap: IMapType;
  i: Integer;
  VNotifier: INotifierTilePyramidUpdate;
  VZoom: Byte;
  VConverter: ICoordConverter;
  VLonLatRect: TDoubleRect;
  VMapLonLatRect: TDoubleRect;
  VTileRect: TRect;
begin
  if ALayerSet <> nil then begin
    if ALayerSet.GetCount > 0 then begin
      if FLayerListeners = nil then begin
        VListeners := TInterfaceListSimple.Create;
        VListeners.Capacity := ALayerSet.GetCount;
        for i := 0 to ALayerSet.Count - 1 do begin
          VMap := ALayerSet.Items[i];
          Assert(Assigned(VMap));
          VListener := TTileUpdateListenerToLonLat.Create(VMap.GeoConvert, Self.OnTileUpdate);
          VListeners.Add(VListener);
        end;
        FLayerListeners := VListeners.MakeStaticAndClear;
      end;
      VZoom := ATileRect.ProjectionInfo.Zoom;
      VConverter := ATileRect.ProjectionInfo.GeoConverter;
      VLonLatRect := VConverter.TileRect2LonLatRect(ATileRect.Rect, VZoom);
      for i := 0 to ALayerSet.Count - 1 do begin
        VMap := ALayerSet.Items[i];
        VNotifier := VMap.TileStorage.TileNotifier;
        if VNotifier <> nil then begin
          VConverter := VMap.GeoConvert;
          VMapLonLatRect := VLonLatRect;
          VConverter.ValidateLonLatRect(VMapLonLatRect);
          VTileRect :=
            RectFromDoubleRect(
              VConverter.LonLatRect2TileRectFloat(VMapLonLatRect, VZoom),
              rrToTopLeft
            );
          VNotifier.AddListenerByRect(IListener(FLayerListeners[i]), VZoom, VTileRect);
        end;
      end;
    end;
  end;
end;

procedure TVectorItemSubsetChangeableForVectorLayers.RemoveLayerListeners(
  const ALayerSet: IMapTypeSet
);
var
  VNotifier: INotifierTilePyramidUpdate;
  i: Integer;
  VMap: IMapType;
begin
  if Assigned(ALayerSet) then begin
    for i := 0 to ALayerSet.Count - 1 do begin
      VMap := ALayerSet.Items[i];
      VNotifier := VMap.TileStorage.TileNotifier;
      if VNotifier <> nil then begin
        VNotifier.Remove(IListener(FLayerListeners.Items[i]));
      end;
    end;
  end;
end;

procedure TVectorItemSubsetChangeableForVectorLayers.RemoveVersionListener(
  const ALayerSet: IMapTypeSet);
var
  VMap: IMapType;
  i: Integer;
begin
  if Assigned(ALayerSet) then begin
    for i := 0 to ALayerSet.Count - 1 do begin
      VMap := ALayerSet.Items[i];
      VMap.VersionRequestConfig.ChangeNotifier.Remove(FVersionListener);
    end;
  end;
end;

procedure TVectorItemSubsetChangeableForVectorLayers.OnPrepareSubset(
  AOperationID: Integer;
  const ACancelNotifier: INotifierOperation
);
var
  VNeedRedraw: Boolean;
  VTileRect: ITileRect;
  VLayerSet: IMapTypeSet;
  VCounterContext: TInternalPerformanceCounterContext;
  VResult: IVectorItemSubset;
  VNeedNotify: Boolean;
begin
  FDelicateUpdateFlag.CheckFlagAndReset;
  VNeedRedraw := True;
  while VNeedRedraw do begin
    if ACancelNotifier.IsOperationCanceled(AOperationID) then begin
      Exit;
    end;
    VTileRect := FTileRect.GetStatic;
    VLayerSet := FLayersSet.GetStatic;
    if Assigned(FPrevLayerSet) and not FPrevLayerSet.IsEqual(VLayerSet) then begin
      RemoveLayerListeners(FPrevLayerSet);
      RemoveVersionListener(FPrevLayerSet);
      FLayerListeners := nil;
      FPrevLayerSet := nil;
    end;
    VResult := nil;
    if Assigned(VLayerSet) then begin
      if not VLayerSet.IsEqual(FPrevLayerSet) then begin
        AddVersionListener(VLayerSet);
        AddLayerListeners(VTileRect, VLayerSet);
        FPrevLayerSet := VLayerSet;
        FPrevTileRect := VTileRect;
      end else if not VTileRect.IsEqual(FPrevTileRect) then begin
        RemoveLayerListeners(FPrevLayerSet);
        AddLayerListeners(VTileRect, VLayerSet);
        FPrevTileRect := VTileRect;
      end;

      if ACancelNotifier.IsOperationCanceled(AOperationID) then begin
        Exit;
      end;
      VCounterContext := FSubsetPrepareCounter.StartOperation;
      try
        VResult := PrepareSubset(AOperationID, ACancelNotifier, VTileRect, VLayerSet);
      finally
        FSubsetPrepareCounter.FinishOperation(VCounterContext);
      end;
    end;
    CS.BeginWrite;
    try
      if FResult = nil then begin
        VNeedNotify := (VResult <> nil) and (not VResult.IsEmpty);
      end else begin
        VNeedNotify := not FResult.IsEqual(VResult);
      end;
      FResult := VResult;
    finally
      CS.EndWrite;
    end;
    if VNeedNotify then begin
      DoChangeNotify;
    end;
    VNeedRedraw := FDelicateUpdateFlag.CheckFlagAndReset;
  end;
end;

procedure TVectorItemSubsetChangeableForVectorLayers.OnTileUpdate(
  const AMsg: IInterface
);
begin
  FDelicateUpdateFlag.SetFlag;
  FPrepareResultTask.StartExecute;
end;

procedure TVectorItemSubsetChangeableForVectorLayers.AddElementsFromMap(
  AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  const AElments: IVectorItemSubsetBuilder;
  const AAlayer: IMapType;
  const AVersion: IMapVersionRequest;
  const ATileRect: ITileRect
);
var
  i: integer;
  VItems: IVectorItemSubset;
  VTileIterator: ITileIterator;
  VZoom: Byte;
  VSourceGeoConvert: ICoordConverter;
  VGeoConvert: ICoordConverter;
  VSourceLonLatRect: TDoubleRect;
  VTileSourceRect: TRect;
  VTile: TPoint;
  VErrorString: string;
  VError: ITileErrorInfo;
begin
  VZoom := ATileRect.ProjectionInfo.Zoom;
  VSourceGeoConvert := AAlayer.GeoConvert;
  VGeoConvert := ATileRect.ProjectionInfo.GeoConverter;

  VSourceLonLatRect := VGeoConvert.TileRect2LonLatRect(ATileRect.Rect, VZoom);
  VTileSourceRect :=
    RectFromDoubleRect(
      VSourceGeoConvert.LonLatRect2TileRectFloat(VSourceLonLatRect, VZoom),
      rrToTopLeft
    );
  VTileIterator := TTileIteratorByRect.Create(VTileSourceRect);

  while VTileIterator.Next(VTile) do begin
    VErrorString := '';
    try
      VItems := AAlayer.LoadTileVector(VTile, VZoom, AVersion, False, AAlayer.CacheVector);
      if VItems <> nil then begin
        if ACancelNotifier.IsOperationCanceled(AOperationID) then begin
          Break;
        end else begin
          for i := 0 to VItems.Count - 1 do begin
            AddWikiElement(AElments, VItems.GetItem(i), ATileRect);
          end;
        end;
      end;
    except
      on E: Exception do begin
        VErrorString := E.Message;
      end;
      else
        VErrorString := SAS_ERR_TileDownloadUnexpectedError;
    end;
    if VErrorString <> '' then begin
      VError :=
        TTileErrorInfo.Create(
          AAlayer.Zmp.GUID,
          VZoom,
          VTile,
          VErrorString
        );
      FErrorLogger.LogError(VError);
    end;
    VItems := nil;
  end;
end;

procedure TVectorItemSubsetChangeableForVectorLayers.AddWikiElement(
  const AElments: IVectorItemSubsetBuilder;
  const AData: IVectorDataItem;
  const ATileRect: ITileRect
);
var
  VRect: ILonLatRect;
begin
  if AData <> nil then begin
    VRect := AData.Geometry.Bounds;
    if VRect <> nil then begin
      AElments.Add(AData);
    end;
  end;
end;

function TVectorItemSubsetChangeableForVectorLayers.PrepareSubset(
  AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  const ATileRect: ITileRect;
  const ALayerSet: IMapTypeSet
): IVectorItemSubset;
var
  i: Integer;
  VMapType: IMapType;
  VElements: IVectorItemSubsetBuilder;
begin
  VElements := FVectorItemSubsetBuilderFactory.Build;
  if ALayerSet <> nil then begin
    for i := 0 to ALayerSet.Count - 1 do begin
      VMapType := ALayerSet.Items[i];
      if VMapType.IsKmlTiles then begin
        AddElementsFromMap(
          AOperationID,
          ACancelNotifier,
          VElements,
          VMapType,
          VMapType.VersionRequestConfig.GetStatic,
          ATileRect
        );
        if ACancelNotifier.IsOperationCanceled(AOperationID) then begin
          Break;
        end;
      end;
    end;
  end;
  VElements.RemoveDuplicates;
  Result := VElements.MakeStaticAndClear;
end;

end.
