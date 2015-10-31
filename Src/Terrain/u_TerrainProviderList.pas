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

unit u_TerrainProviderList;

interface

uses
  SysUtils,
  ActiveX,
  i_GUIDSet,
  i_Notifier,
  i_ProjectionSetFactory,
  i_TerrainProviderList,
  i_TerrainProviderListElement,
  i_PathConfig,
  i_ProjConverter,
  u_BaseInterfacedObject;

type
  TTerrainProviderListBase = class(TBaseInterfacedObject, ITerrainProviderList)
  private
    FList: IGUIDInterfaceSet;
    FCS: IReadWriteSync;
    FAddNotifier: INotifierInternal;
  private
    function GetGUIDEnum: IEnumGUID;
    function Get(const AGUID: TGUID): ITerrainProviderListElement;
    function GetAddNotifier: INotifier;
  protected
    procedure Add(const AItem: ITerrainProviderListElement);
  public
    constructor Create;
  end;

  TTerrainProviderListSimple = class(TTerrainProviderListBase)
  private
    FProjConverterFactory: IProjConverterFactory;
    FTerrainDataPath: IPathConfig;
  private
    procedure LoadFromIni;
  public
    constructor Create(
      const AProjConverterFactory: IProjConverterFactory;
      const AProjectionSetFactory: IProjectionSetFactory;
      const ATerrainDataPath: IPathConfig;
      const AGECachePath: IPathConfig;
      const AGCCachePath: IPathConfig
    );
  end;

implementation

uses
  IniFiles,
  Classes,
  c_TerrainProviderGUID,
  c_ZeroGUID,
  i_ConfigDataProvider,
  i_StringListStatic,
  u_ConfigDataProviderByIniFile,
  u_ConfigProviderHelpers,
  u_TerrainProviderListElement,
  u_TerrainProviderByGE,
  u_TerrainProviderByGoogleEarth,
  u_ExternalTerrainsProvider,
  u_Notifier,
  u_Synchronizer,
  u_GUIDInterfaceSet;

{ TTerrainProviderListSimple }

constructor TTerrainProviderListSimple.Create(
  const AProjConverterFactory: IProjConverterFactory;
  const AProjectionSetFactory: IProjectionSetFactory;
  const ATerrainDataPath: IPathConfig;
  const AGECachePath: IPathConfig;
  const AGCCachePath: IPathConfig
);
var
  VItem: ITerrainProviderListElement;
begin
  inherited Create;
  FTerrainDataPath := ATerrainDataPath;

  FProjConverterFactory := AProjConverterFactory;

  VItem :=
    TTerrainProviderListElement.Create(
      cTerrainProviderGoogleEarthGUID,
      'GoogleEarth',
      TTerrainProviderByGoogleEarth.Create(AProjectionSetFactory, AGECachePath)
    );
  Add(VItem);

  VItem :=
    TTerrainProviderListElement.Create(
      cTerrainProviderGeoCacherGUID,
      'GeoCacher',
      TTerrainProviderByGeoCacher.Create(AProjectionSetFactory, AGCCachePath)
    );
  Add(VItem);

  // make external items
  LoadFromIni;
end;

procedure TTerrainProviderListSimple.LoadFromIni;
var
  VFileName: String;
  VIniFile: TMemIniFile;
  VTerrainConfig: IConfigDataProvider;
  VSectionData: IConfigDataProvider;
  VSections: IStringListStatic;
  VSection, VCaption: String;
  VGuid: TGUID;
  VItem: ITerrainProviderListElement;
  VProjInitString: AnsiString;
  VProjConverter: IProjConverter;
  i: Integer;
begin
  // check
  if (nil = FTerrainDataPath) then begin
    Exit;
  end;
  VFileName := FTerrainDataPath.FullPath + '\SASTerrain.ini';
  if (not FileExists(VFileName)) then begin
    Exit;
  end;

  // load
  VIniFile := TMemIniFile.Create(VFileName);
  try
    VTerrainConfig := TConfigDataProviderByIniFile.CreateWithOwn(VIniFile);
    VIniFile := nil;
    VSections := VTerrainConfig.ReadSubItemsList;
    if Assigned(VSections) and (0 < VSections.Count) then begin
      for i := 0 to VSections.Count - 1 do begin
        try
      // loop through terrains
          VSection := VSections.Items[i];
          VSectionData := VTerrainConfig.GetSubItem(VSection);

      // get guid
          VGuid := ReadGUID(VSectionData, 'GUID', CGUID_Zero);

      // get caption
          VCaption := VSectionData.ReadString('Caption', VSection);

      // get proj4 converter
          VProjInitString := VSectionData.ReadAnsiString('Proj', '');
          if (0 < Length(VProjInitString)) then begin
            VProjConverter := FProjConverterFactory.GetByInitString(VProjInitString);
          end else begin
        // no proj converter
            VProjConverter := nil;
          end;

      // make item
          VItem := TTerrainProviderListElement.Create(
            VGuid,
            VCaption,
            TTerrainProviderByExternal.Create(
              FTerrainDataPath.FullPath,
              VProjConverter,
              VSectionData
            )
          );

      // append to list
          Add(VItem);
        except
        end;
      end;
    end;
  finally
    VIniFile.Free;
  end;
end;

{ TTerrainProviderListBase }

constructor TTerrainProviderListBase.Create;
begin
  inherited Create;
  FCS := GSync.SyncStdRecursive.Make(Self.ClassName);
  FList := TGUIDInterfaceSet.Create(False);
  FAddNotifier :=
    TNotifierBase.Create(
      GSync.SyncVariable.Make(Self.ClassName + 'Notifier')
    );
end;

procedure TTerrainProviderListBase.Add(const AItem: ITerrainProviderListElement);
begin
  FCS.BeginWrite;
  try
    FList.Add(AItem.GetGUID, AItem);
  finally
    FCS.EndWrite;
  end;
  FAddNotifier.Notify(nil);
end;

function TTerrainProviderListBase.Get(const AGUID: TGUID): ITerrainProviderListElement;
begin
  FCS.BeginRead;
  try
    Result := ITerrainProviderListElement(FList.GetByGUID(AGUID));
  finally
    FCS.EndRead;
  end;
end;

function TTerrainProviderListBase.GetAddNotifier: INotifier;
begin
  Result := FAddNotifier;
end;

function TTerrainProviderListBase.GetGUIDEnum: IEnumGUID;
begin
  FCS.BeginRead;
  try
    Result := FList.GetGUIDEnum;
  finally
    FCS.EndRead;
  end;
end;

end.
