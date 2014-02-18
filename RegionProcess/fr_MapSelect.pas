unit fr_MapSelect;

interface

uses
  Classes,
  Controls,
  StdCtrls,
  SysUtils,
  StrUtils,
  TB2ExtItems,
  TBXExtItems,
  TB2Item,
  TBX,
  Menus,
  i_LanguageManager,
  i_MapTypes,
  i_MapTypeSet,
  i_ActiveMapsConfig,
  i_MapTypeGUIConfigList,
  u_CommonFormAndFrameParents;

type
  TMapSelectFilter = (mfAll=0, mfMaps=1, mfLayers=2);
  TMapSelectPredicate =  function(const AMapType: IMapType): boolean of object;
  TfrMapSelect = class(TFrame)
    cbbMap: TComboBox;
    FilterPopupMenu: TTBXPopupMenu;
    TBX_All: TTBXItem;
    TBX_Maps: TTBXItem;
    TBX_Layers: TTBXItem;
    TBX_Active: TTBXItem;
    TBSeparatorItem1: TTBSeparatorItem;
    TBX_Filter: TTBXItem;
    TBX_AFilter: TTBXEditItem;

    procedure RefreshList(Sender: TObject);
    procedure ApplyFilter(Sender: TObject);
    procedure cbbMapChange(Sender: TObject);

  private
    FMainMapsConfig: IMainMapsConfig;
    FGUIConfigList: IMapTypeGUIConfigList;
    FFullMapsSet: IMapTypeSet;
    FMapSelectFilter: TMapSelectFilter;
    FMapSelectPredicate: TMapSelectPredicate;
    FOnMapChange: TNotifyEvent;
    FNoItemAdd: boolean;
    FShowDisabled: boolean;

  public
    constructor Create(
      const ALanguageManager: ILanguageManager;
      const AMainMapsConfig: IMainMapsConfig;
      const AGUIConfigList: IMapTypeGUIConfigList;
      const AFullMapsSet: IMapTypeSet;
      const AMapSelectFilter : TMapSelectFilter;
      const ANoItemAdd: boolean;
      const AShowDisabled: boolean;
      AMapSelectPredicate: TMapSelectPredicate
    ); reintroduce;
    function GetSelectedMapType: IMapType;
    function Text: TCaption;
    procedure SetEnabled(Amode: boolean);reintroduce;
    procedure Show(AParent: TWinControl);
    property OnMapChange: TNotifyEvent read FOnMapChange write FOnMapChange;
  end;

implementation

uses
  i_GUIDListStatic,
  u_ResStrings,
  gnugettext;

{$R *.dfm}

{ TfrMapSelect }

constructor TfrMapSelect.Create(
  const ALanguageManager: ILanguageManager;
  const AMainMapsConfig: IMainMapsConfig;
  const AGUIConfigList: IMapTypeGUIConfigList;
  const AFullMapsSet: IMapTypeSet;
  const AMapSelectFilter : TMapSelectFilter;
  const ANoItemAdd: boolean;
  const AShowDisabled: boolean;
  AMapSelectPredicate: TMapSelectPredicate
);
begin
  Assert(Assigned(AMainMapsConfig));
  Assert(Assigned(AMainMapsConfig));
  Assert(Assigned(AGUIConfigList));
  Assert(Assigned(AFullMapsSet));
  Assert(Assigned(AMapSelectPredicate));

  inherited Create(ALanguageManager);
  FGUIConfigList := AGUIConfigList;
  FFullMapsSet := AFullMapsSet;
  FMainMapsConfig := AMainMapsConfig;
  FMapSelectFilter := AMapSelectFilter;
  FNoItemAdd := ANoItemAdd;
  FShowDisabled := AShowDisabled;
  FMapSelectPredicate := AMapSelectPredicate;

  TBX_All.Visible := FMapSelectFilter = mfAll;
  TBX_Maps.Visible := FMapSelectFilter <> mfLayers;
  TBX_Layers.Visible := FMapSelectFilter <> mfMaps;
  TBX_Active.Visible := FMapSelectFilter <> mfMaps;
end;

procedure TfrMapSelect.cbbMapChange(Sender: TObject);
begin
  if Assigned(FOnMapChange) then begin
    FOnMapChange(Self);
  end;
end;

function TfrMapSelect.Text: TCaption;
begin
  Result := cbbMap.Text;
end;

function TfrMapSelect.GetSelectedMapType: IMapType;
begin
  Result := nil;
  if cbbMap.ItemIndex >= 0 then begin
    Result := IMapType(Pointer(cbbMap.Items.Objects[cbbMap.ItemIndex]));
  end;
end;

procedure TfrMapSelect.SetEnabled(Amode: boolean);
begin
  cbbMap.Enabled := Amode;
end;

procedure TfrMapSelect.Show(AParent: TWinControl);
begin
  Parent := AParent;
  RefreshList(nil);
end;

procedure TfrMapSelect.ApplyFilter(Sender: TObject);
begin
 RefreshList(TBX_Filter);
end;

procedure TfrMapSelect.RefreshList(Sender: TObject);
var
  VMode: Integer; // 1 All  2 Maps  3 Layers  4 Active   5 Filter
  VDefaultIndex: Integer;
  VActiveMapGUID: TGUID;
  i: integer;
  VCurMapType: IMapType;
  VAddedIndex: Integer;
  VGUIDList: IGUIDListStatic;
  VGUID: TGUID;
  VAdd: Boolean;
  VLayers: IMapTypeSet;
  VMapName: string;
  VFilter: string;
  VHint: string;
  VMapCount: integer;
  VOrigFilter: string;
begin
  VMode := 0;
  if Assigned(Sender) then begin // �������� �� ������ ����
    VMode := TTBXItem(Sender).Tag;
    TTBXItem(Sender).checked := True;
  end else begin // ������ �� �������� - ����� ���� �� �������
    case FMapSelectFilter of  // �������� ����� � ����������� �� ���� ��� � ������ ����
      mfAll: begin
        VMode := 1;
        TBX_All.Checked := true;
      end;
      mfMaps: begin
        VMode := 2;
        TBX_Maps.Checked := true;
      end;
      mfLayers: begin
        VMode := 3;
        TBX_Layers.Checked := true;
      end;
    end;
  end;

  VDefaultIndex := -1;

  VLayers := nil;
  VFilter := AnsiUpperCase(TBX_AFilter.Text);

  // get active map
  VActiveMapGUID := FMainMapsConfig.GetActiveMap.GetStatic.GUID;
  VLayers := FMainMapsConfig.GetActiveLayersSet.GetStatic;

  // refresh list
  cbbMap.Items.BeginUpdate;
  try
    cbbMap.Items.Clear;
    if FNoItemAdd then cbbMap.Items.AddObject(SAS_STR_No,nil);
    VGUIDList := FGUIConfigList.OrderedMapGUIDList;
    for i := 0 to VGUIDList.Count-1 do begin
      VGUID := VGUIDList.Items[i];
      VAdd := false;
      VCurMapType := FFullMapsSet.GetMapTypeByGUID(VGUID);
        // check if allow to add map to list
      if VCurMapType.GUIConfig.Enabled or FShowDisabled then begin
        if (FMapSelectFilter = mfAll) or // ����� � ����
          ((FMapSelectFilter = mfMaps) and (not VCurMapType.Zmp.IsLayer)) or //����� � ������� - �����
          ((FMapSelectFilter = mfLayers) and (VCurMapType.Zmp.IsLayer)) // ���� � ������� - ����
        then begin
          case VMode of
            1: VAdd := True;  // all maps
            2: VAdd := (not VCurMapType.Zmp.IsLayer); // only maps
            3: VAdd := (VCurMapType.Zmp.IsLayer);// only layers
            4: if (VCurMapType.Zmp.IsLayer) then // only visible items: main map or visible layer
                 VAdd := VLayers.GetMapTypeByGUID(VGUID) <> nil
               else
                 VAdd := IsEqualGUID(VActiveMapGUID, VGUID);
            5: begin // Filter by name
              if VFilter <> '' then begin //���������
                VMapName := AnsiUpperCase(VCurMapType.GUIConfig.Name.Value);
                if posex(VFilter, VMapName) <> 0 then begin
                  VAdd := True
                end else begin
                  VAdd := False
                end
              end else begin
                VAdd := true;
              end;
            end;
          end; //case
          if VAdd then begin
            if not FMapSelectPredicate(VCurMapType) then begin
              VAdd := false
            end;
          end;
          if VAdd then begin
            VAddedIndex := cbbMap.Items.AddObject(VCurMapType.GUIConfig.Name.Value, TObject(VCurMapType));
            if IsEqualGUID(VCurMapType.Zmp.GUID, VActiveMapGUID) then begin
              // select active map as default
              VDefaultIndex := VAddedIndex;
            end;
            if (VDefaultIndex = -1) then begin
              if VCurMapType.Zmp.IsLayer then begin
                if (VLayers.GetMapTypeByGUID(VGUID) <> nil) then begin
                  // select first active layer as default
                  VDefaultIndex := VAddedIndex;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    cbbMap.Items.EndUpdate;
  end;

  if (cbbMap.Items.Count > 0) then begin
    if (VDefaultIndex >= 0) then begin
      cbbMap.ItemIndex := VDefaultIndex;
    end else begin
      cbbMap.ItemIndex := 0;
    end;
  end;

  VMapCount := cbbMap.Items.Count;
  if FNoItemAdd then dec(VMapCount);

  case VMode of
    1: VHint := Format(_('All (%d)'), [VMapCount]);
    2: VHint := Format(_('Maps (%d)'), [VMapCount]);
    3: VHint := Format(_('Layers (%d)'), [VMapCount]);
    4: begin
      case FMapSelectFilter of
        mfAll: VHint := Format(_('Active Maps + Layers (%d)'), [VMapCount]);
        mfMaps: VHint := Format(_('Active Maps (%d)'), [VMapCount]);
        mfLayers: VHint := Format(_('Active Layers (%d)'), [VMapCount]);
      end;
    end;
    5: begin
      if VFilter <> '' then begin
        VOrigFilter := TBX_AFilter.Text
      end else begin
        VOrigFilter := '*'
      end;
      VHint := Format(_('Filter: "%s" (%d)'), [VOrigFilter, VMapCount]);
    end;
  end;
  cbbMap.Hint := VHint;
end;
end.
