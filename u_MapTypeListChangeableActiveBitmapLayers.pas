unit u_MapTypeListChangeableActiveBitmapLayers;

interface

uses
  i_Notifier,
  i_Listener,
  i_MapTypes,
  i_MapTypeListChangeable,
  u_ConfigDataElementBase;

type
  TMapTypeListChangeableByActiveMapsSet = class(TConfigDataElementWithStaticBaseEmptySaveLoad, IMapTypeListChangeable)
  private
    FMapTypeListBuilderFactory: IMapTypeListBuilderFactory;
    FSourceSet: IMapTypeSetChangeable;

    FZOrderListener: IListener;
    FLayerSetListener: IListener;
    FLayersSet: IMapTypeSet;
    procedure OnMapZOrderChanged;
    procedure OnLayerSetChanged;
  private
    function GetList: IMapTypeListStatic;
  protected
    function CreateStatic: IInterface; override;
  public
    constructor Create(
      const AMapTypeListBuilderFactory: IMapTypeListBuilderFactory;
      const ASourceSet: IMapTypeSetChangeable
    );
    destructor Destroy; override;
  end;

implementation

uses
  ActiveX,
  u_ListenerByEvent,
  u_MapTypeListStatic;

{ TMapTypeListChangeableByActiveMapsSet }

constructor TMapTypeListChangeableByActiveMapsSet.Create(
  const AMapTypeListBuilderFactory: IMapTypeListBuilderFactory;
  const ASourceSet: IMapTypeSetChangeable
);
begin
  inherited Create;
  FSourceSet := ASourceSet;
  FMapTypeListBuilderFactory := AMapTypeListBuilderFactory;

  FZOrderListener := TNotifyNoMmgEventListener.Create(Self.OnMapZOrderChanged);
  FLayerSetListener := TNotifyNoMmgEventListener.Create(Self.OnLayerSetChanged);
  FSourceSet.ChangeNotifier.Add(FLayerSetListener);
  OnLayerSetChanged;
end;

destructor TMapTypeListChangeableByActiveMapsSet.Destroy;
var
  VEnum: IEnumGUID;
  VGuid: TGUID;
  VCnt: Cardinal;
  VMapType: IMapType;
begin
  if Assigned(FSourceSet) and Assigned(FLayerSetListener)then begin
    FSourceSet.ChangeNotifier.Remove(FLayerSetListener);
    FLayerSetListener := nil;
    FSourceSet := nil;
  end;
  if Assigned(FLayersSet) and Assigned(FZOrderListener) then begin
    VEnum := FLayersSet.GetIterator;
    while VEnum.Next(1, VGuid, VCnt) = S_OK do begin
      VMapType := FLayersSet.GetMapTypeByGUID(VGuid);
      if VMapType <> nil then begin
        VMapType.MapType.LayerDrawConfig.ChangeNotifier.Remove(FZOrderListener);
      end;
    end;
    FLayersSet := nil;
  end;
  inherited;
end;

function TMapTypeListChangeableByActiveMapsSet.CreateStatic: IInterface;
  procedure QuickSort(
    var AMapsList: IMapTypeListBuilder;
    var AZList: array of Integer;
    L, R: Integer
  );
  var
    I, J: Integer;
    P: Integer;
    TI: Integer;
    TM: IMapType;
  begin
    repeat
      I := L;
      J := R;
      P := AZList[(L + R) shr 1];
      repeat
        while AZList[I] < P do begin
          Inc(I);
        end;
        while AZList[J] > P do begin
          Dec(J);
        end;
        if I <= J then begin
          TI := AZList[I];
          TM := AMapsList[I];

          AZList[I] := AZList[J];
          AMapsList[I] := AMapsList[J];
          AZList[J] := TI;
          AMapsList[J] := TM;
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then begin
        QuickSort(AMapsList, AZList, L, J);
      end;
      L := I;
    until I >= R;
  end;
var
  VLayers: IMapTypeListBuilder;
  VZArray: array of Integer;
  i: Integer;
  VEnum: IEnumUnknown;
  VCnt: Integer;
  VCount: Integer;
  VMapType: IMapType;
begin
  VLayers := FMapTypeListBuilderFactory.Build;
  if FLayersSet <> nil then begin
    VCount := FLayersSet.GetCount;
    VLayers.Capacity := VCount;
    VEnum := FLayersSet.GetMapTypeIterator;
    while VEnum.Next(1, VMapType, @VCnt) = S_OK do begin
      if Assigned(VMapType) then begin
        VLayers.Add(VMapType);
      end;
    end;
  end;
  VCount := VLayers.Count;
  SetLength(VZArray, VCount);
  for i := 0 to VCount - 1 do begin
    VZArray[i] := VLayers[i].MapType.LayerDrawConfig.LayerZOrder;
  end;
  if VCount > 1 then begin
    QuickSort(VLayers, VZArray, 0, VCount - 1);
  end;
  Result := VLayers.MakeAndClear;
end;

function TMapTypeListChangeableByActiveMapsSet.GetList: IMapTypeListStatic;
begin
  Result := IMapTypeListStatic(GetStaticInternal);
end;

procedure TMapTypeListChangeableByActiveMapsSet.OnLayerSetChanged;
var
  VNewSet: IMapTypeSet;
  VEnum: IEnumGUID;
  VGuid: TGUID;
  VCnt: Cardinal;
  VMapType: IMapType;
begin
  VNewSet := FSourceSet.GetStatic;
  LockWrite;
  try
    if (FLayersSet <> nil) and FLayersSet.IsEqual(VNewSet) then begin
      Exit;
    end;
    if FLayersSet <> nil then begin
      VEnum := FLayersSet.GetIterator;
      while VEnum.Next(1, VGuid, VCnt) = S_OK do begin
        if (VNewSet = nil) or (VNewSet.GetMapTypeByGUID(VGuid) = nil) then begin
          VMapType := FLayersSet.GetMapTypeByGUID(VGuid);
          if VMapType <> nil then begin
            VMapType.MapType.LayerDrawConfig.ChangeNotifier.Remove(FZOrderListener);
          end;
        end;
      end;
    end;
    if VNewSet <> nil then begin
      VEnum := VNewSet.GetIterator;
      while VEnum.Next(1, VGuid, VCnt) = S_OK do begin
        if (FLayersSet = nil) or (FLayersSet.GetMapTypeByGUID(VGuid) = nil) then begin
          VMapType := VNewSet.GetMapTypeByGUID(VGuid);
          if VMapType <> nil then begin
            VMapType.MapType.LayerDrawConfig.ChangeNotifier.Add(FZOrderListener);
          end;
        end;
      end;
    end;
    FLayersSet := VNewSet;
    SetChanged;
  finally
    UnlockWrite;
  end;
end;

procedure TMapTypeListChangeableByActiveMapsSet.OnMapZOrderChanged;
begin
  LockWrite;
  try
    SetChanged;
  finally
    UnlockWrite;
  end;
end;

end.


