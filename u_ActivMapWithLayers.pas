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

unit u_ActivMapWithLayers;

interface

uses
  i_GUIDSet,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_MapTypes,
  i_ActiveMapsConfig,
  u_NotifyWithGUIDEvent,
  u_MainActiveMap;

type
  TActivMapWithLayers = class(TMainActiveMap, IActivMapWithLayers)
  private
    FLayerSetSelectNotyfier: INotifierWithGUID;
    FLayerSetUnselectNotyfier: INotifierWithGUID;

    FAllMapsSet: IMapTypeSet;
    FAllMapsSingleList: IGUIDInterfaceSet;
    FActiveLayersSet: IActiveMapsSet;
    FAllActiveMapsSet: IActiveMapsSet;
  protected
    property LayerSetSelectNotyfier: INotifierWithGUID read FLayerSetSelectNotyfier;
    property LayerSetUnselectNotyfier: INotifierWithGUID read FLayerSetUnselectNotyfier;
    property AllMapsSingleList: IGUIDInterfaceSet read FAllMapsSingleList;
  protected
    procedure SelectLayerByGUID(const AMapGUID: TGUID);
    procedure UnSelectLayerByGUID(const AMapGUID: TGUID);

    function GetActiveLayersSet: IActiveMapsSet;
    function GetAllActiveMapsSet: IActiveMapsSet;
  protected
    procedure DoReadConfig(AConfigData: IConfigDataProvider); override;
    procedure DoWriteConfig(AConfigData: IConfigDataWriteProvider); override;
  public
    constructor Create(AMapsSet, ALayersSet: IMapTypeSet);
    destructor Destroy; override;
  end;

implementation

uses
  Classes,
  StrUtils,
  SysUtils,
  ActiveX,
  c_ZeroGUID,
  u_GUIDInterfaceSet,
  u_MapTypeSet,
  u_ActiveMapSingleAbstract,
  u_ActiveMapsSet;

const
  CKeyNameLayer = 'Layer';

{ TActivMapWithLayers }

constructor TActivMapWithLayers.Create(AMapsSet, ALayersSet: IMapTypeSet);
var
  VEnun: IEnumGUID;
  VGUID: TGUID;
  i: Cardinal;
  VMapType: IMapType;
  VSingleMap: IActiveMapSingle;
  VAllMapsList: TMapTypeSet;
begin
  inherited Create(AMapsSet);
  FLayerSetSelectNotyfier := TNotifierWithGUID.Create;
  FLayerSetUnselectNotyfier := TNotifierWithGUID.Create;

  FAllMapsSingleList := TGUIDInterfaceSet.Create(False);
  VAllMapsList := TMapTypeSet.Create(True);

  VEnun := AMapsSet.GetIterator;
  while VEnun.Next(1, VGUID, i) = S_OK do begin
    VMapType := AMapsSet.GetMapTypeByGUID(VGUID);
    VSingleMap := IActiveMapSingle(SingeMapsList.GetByGUID(VGUID));
    VAllMapsList.Add(VMapType);
    FAllMapsSingleList.Add(VGUID, VSingleMap);
  end;

  VEnun := ALayersSet.GetIterator;
  while VEnun.Next(1, VGUID, i) = S_OK do begin
    VMapType := ALayersSet.GetMapTypeByGUID(VGUID);
    VSingleMap := TActiveMapSingleLayer.Create(
      VMapType,
      FLayerSetSelectNotyfier,
      FLayerSetUnselectNotyfier
    );
    VAllMapsList.Add(VMapType);
    FAllMapsSingleList.Add(VGUID, VSingleMap);
    Add(VSingleMap, nil);
  end;


  FAllMapsSet := VAllMapsList;
  
  FActiveLayersSet := TActiveMapsSet.Create(
    ALayersSet,
    FAllMapsSingleList,
    nil,
    FLayerSetSelectNotyfier,
    FLayerSetUnselectNotyfier
  );
  Add(FActiveLayersSet, nil);

  FAllActiveMapsSet :=  TActiveMapsSet.Create(
    FAllMapsSet,
    FAllMapsSingleList,
    MainMapChangeNotyfier,
    FLayerSetSelectNotyfier,
    FLayerSetUnselectNotyfier
  );
  Add(FAllActiveMapsSet, nil);
end;

destructor TActivMapWithLayers.Destroy;
begin
  FLayerSetSelectNotyfier := nil;
  FLayerSetUnselectNotyfier := nil;

  FAllMapsSet := nil;
  FAllMapsSingleList := nil;
  FActiveLayersSet := nil;
  FAllActiveMapsSet := nil;
  inherited;
end;

procedure TActivMapWithLayers.DoReadConfig(AConfigData: IConfigDataProvider);
var
  VList: TStringList;
  i: Integer;
  VKeyName: string;
  VGUIDString: string;
  VGUID: TGUID;
  VMap: IMapType;
begin
  inherited;
  if AConfigData <> nil then begin
    VList := TStringList.Create;
    try
      AConfigData.ReadValuesList(VList);
      for i := 0 to VList.Count - 1 do begin
        VKeyName := VList.Strings[i];
        if SameText(LeftStr(VKeyName, length(CKeyNameLayer)), CKeyNameLayer) then begin
          VGUIDString := AConfigData.ReadString(VKeyName, '');
          if VGUIDString <> '' then begin
            try
              VGUID := StringToGUID(VGUIDString);
            except
              VGUID := CGUID_Zero;
            end;
          end else begin
            VGUID := CGUID_Zero;
          end;
          if not IsEqualGUID(VGUID, CGUID_Zero) then begin
            VMap := FActiveLayersSet.GetMapsSet.GetMapTypeByGUID(VGUID);
            if VMap <> nil then begin
              SelectLayerByGUID(VGUID)
            end;
          end;
        end;
      end;
    finally
      VList.Free;
    end;
  end;
end;

procedure TActivMapWithLayers.DoWriteConfig(
  AConfigData: IConfigDataWriteProvider);
var
  VList: TStringList;
  i: Cardinal;
  VKeyName: string;
  VGUIDString: string;
  VGUID: TGUID;
  VIndex: Integer;
  VEnum: IEnumGUID;
begin
  inherited;
  VList := TStringList.Create;
  try
    AConfigData.ReadValuesList(VList);
    for i := 0 to VList.Count - 1 do begin
      VKeyName := VList.Strings[i];
      if SameText(LeftStr(VKeyName, length(CKeyNameLayer)), CKeyNameLayer) then begin
        AConfigData.DeleteValue(VKeyName);
      end;
    end;
  finally
    VList.Free;
  end;

  VIndex := 0;
  VEnum := FActiveLayersSet.GetSelectedMapsSet.GetIterator;
  while VEnum.Next(1, VGUID, i) = S_OK do begin
    VGUIDString := GUIDToString(VGUID);
    AConfigData.WriteString(CKeyNameLayer + IntToStr(VIndex), VGUIDString);
    Inc(VIndex);
  end;
end;

function TActivMapWithLayers.GetAllActiveMapsSet: IActiveMapsSet;
begin
  Result := FAllActiveMapsSet;
end;

function TActivMapWithLayers.GetActiveLayersSet: IActiveMapsSet;
begin
  Result := FActiveLayersSet;
end;

procedure TActivMapWithLayers.SelectLayerByGUID(const AMapGUID: TGUID);
begin
  LockWrite;
  try
    FLayerSetSelectNotyfier.NotifyByGUID(AMapGUID);
  finally
    UnlockWrite;
  end;
end;

procedure TActivMapWithLayers.UnSelectLayerByGUID(const AMapGUID: TGUID);
begin
  LockWrite;
  try
    FLayerSetUnselectNotyfier.NotifyByGUID(AMapGUID);
  finally
    UnlockWrite;
  end;
end;

end.
