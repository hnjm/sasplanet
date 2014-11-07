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

unit u_CmdLineArgProcessor;

interface

uses
  Classes,
  i_MarkSystem,
  i_MapViewGoto,
  i_RegionProcess,
  i_ViewPortState,
  i_MainFormConfig,
  i_GeometryLonLatFactory,
  i_AppearanceOfMarkFactory,
  i_VectorItemTreeImporterList,
  i_CmdLineArgProcessor,
  u_BaseInterfacedObject;

type
  TCmdLineArgProcessor = class(TBaseInterfacedObject, ICmdLineArgProcessor)
  private
    FMarkSystem: IMarkSystem;
    FMapGoTo: IMapViewGoto;
    FViewPortState: IViewPortState;
    FMainFormConfig: IMainFormConfig;
    FGeometryLonLatFactory: IGeometryLonLatFactory;
    FAppearanceOfMarkFactory: IAppearanceOfMarkFactory;
    FImporterList: IVectorItemTreeImporterListChangeable;
    function ProcessInternal(
      const AList: TStringList;
      const ARegionProcess: IRegionProcessFromFile
    ): Integer;
  private
    function Process(
      const ARegionProcess: IRegionProcessFromFile = nil
    ): Integer; overload;
    function Process(
      const AArgs: string;
      const ARegionProcess: IRegionProcessFromFile = nil
    ): Integer; overload;
    function GetArguments: string;
    function GetErrorFromCode(const ACode: Integer): string;
  public
    constructor Create(
      const AMarkSystem: IMarkSystem;
      const AMapGoto: IMapViewGoto;
      const AViewPortState: IViewPortState;
      const AMainFormConfig: IMainFormConfig;
      const AGeometryLonLatFactory: IGeometryLonLatFactory;
      const AAppearanceOfMarkFactory: IAppearanceOfMarkFactory;
      const AImporterList: IVectorItemTreeImporterListChangeable
    );
  end;

implementation

uses
  SysUtils,
  StrUtils,
  ArgumentParser,
  t_GeoTypes,
  i_MapType,
  i_CoordConverter,
  u_CmdLineArgProcessorAPI,
  u_CmdLineArgProcessorHelpers;

{ TCmdLineArgProcessor }

constructor TCmdLineArgProcessor.Create(
  const AMarkSystem: IMarkSystem;
  const AMapGoto: IMapViewGoto;
  const AViewPortState: IViewPortState;
  const AMainFormConfig: IMainFormConfig;
  const AGeometryLonLatFactory: IGeometryLonLatFactory;
  const AAppearanceOfMarkFactory: IAppearanceOfMarkFactory;
  const AImporterList: IVectorItemTreeImporterListChangeable
);
begin
  inherited Create;
  FMarkSystem := AMarkSystem;
  FMapGoTo := AMapGoto;
  FViewPortState := AViewPortState;
  FMainFormConfig := AMainFormConfig;
  FGeometryLonLatFactory := AGeometryLonLatFactory;
  FAppearanceOfMarkFactory := AAppearanceOfMarkFactory;
  FImporterList := AImporterList;
end;

function TCmdLineArgProcessor.GetArguments: string;
var
  VList: TStringList;
begin
  VList := GetParamStrAsList(False);
  try
    Result := VList.Text;
  finally
    VList.Free;
  end;
end;

function TCmdLineArgProcessor.Process(
  const ARegionProcess: IRegionProcessFromFile
): Integer;
var
  VList: TStringList;
begin
  VList := GetParamStrAsList(False);
  try
    Result := ProcessInternal(VList, ARegionProcess);
  finally
    VList.Free;
  end;
end;

function TCmdLineArgProcessor.Process(
  const AArgs: string;
  const ARegionProcess: IRegionProcessFromFile
): Integer;
var
  VList: TStringList;
begin
  VList := GetArgsAsList(AArgs);
  try
    Result := ProcessInternal(VList, ARegionProcess);
  finally
    VList.Free;
  end;
end;

function TCmdLineArgProcessor.ProcessInternal(
  const AList: TStringList;
  const ARegionProcess: IRegionProcessFromFile
): Integer;

var
  VGUID: TGUID;
  VZoom: Byte;
  VLonLat: TDoublePoint;
  VMap: IMapType;
  VStrValue: string;
  VParser: TArgumentParser;
  VParseResult: TParseResult;
  VGeoConverter: ICoordConverter;

  function _GetCoordConverter: ICoordConverter;
  begin
    if not Assigned(VGeoConverter) then begin
      VGeoConverter := FViewPortState.View.GetStatic.GetGeoConverter;
    end;
    Result := VGeoConverter;
  end;

begin
  Result := cCmdLineArgProcessorOk;

  VParser := TArgumentParser.Create;
  try
    VParser.AddArgument('--map', saStore);              // --map={GUID}
    VParser.AddArgument('--zoom', saStore);             // --zoom={value}
    VParser.AddArgument('--move', saStore);             // --move=({lon},{lat})
    VParser.AddArgument('--navigate', saStore);         // --navigate=({lon},{lat})
    VParser.AddArgument('--show-placemarks', saStore);  // --show-placemarks={0/1}
    VParser.AddArgument('--insert-placemark', saStore); // --insert-placemark="{name}";({lon},{lat});"{desc}"

    VParseResult := VParser.ParseArgs(AList);
    try
      if VParseResult.HasArgument('map') then begin
        VStrValue := VParseResult.GetValue('map');
        if GetGUID(VStrValue, VGUID, Result) then begin
          VMap := FMainFormConfig.MainMapsConfig.GetAllMapsSet.GetMapTypeByGUID(VGUID);
          if VMap <> nil then begin
            if VMap.Zmp.IsLayer then begin
              FMainFormConfig.MainMapsConfig.InvertLayerSelectionByGUID(VGUID);
            end else begin
              FMainFormConfig.MainMapsConfig.SelectMainByGUID(VGUID);
            end;
          end else begin
            Result := Result or cCmdLineArgProcessorUnknownGUID;
          end;
        end;
      end;

      if VParseResult.HasArgument('zoom') then begin
        VStrValue := VParseResult.GetValue('zoom');
        if GetZoom(VStrValue, _GetCoordConverter, VZoom, Result) then begin
          FViewPortState.ChangeZoomWithFreezeAtCenter(VZoom);
        end;
      end;

      if VParseResult.HasArgument('move') then begin
        VStrValue := VParseResult.GetValue('move');
        if GetCoords(VStrValue, _GetCoordConverter, VLonLat, Result) then begin
          FViewPortState.ChangeLonLat(VLonLat);
        end;
      end;

      if VParseResult.HasArgument('navigate') then begin
        VStrValue := VParseResult.GetValue('navigate');
        if GetCoords(VStrValue, _GetCoordConverter, VLonLat, Result) then begin
          FMainFormConfig.NavToPoint.StartNavLonLat(VLonLat);
        end;
      end;

      if VParseResult.HasArgument('show-placemarks') then begin
        VStrValue := VParseResult.GetValue('show-placemarks');
        if VStrValue = '1' then begin
          FMainFormConfig.LayersConfig.MarksLayerConfig.MarksShowConfig.IsUseMarks := True;
        end else if VStrValue = '0' then begin
          FMainFormConfig.LayersConfig.MarksLayerConfig.MarksShowConfig.IsUseMarks := False;
        end else begin
          Result := Result or cCmdLineArgProcessorShowMarksParserError;
        end;
      end;

      if VParseResult.HasArgument('insert-placemark') then begin
        VStrValue := VParseResult.GetValue('insert-placemark');
        ProcessImportPlacemark(VStrValue, FMarkSystem, FGeometryLonLatFactory);
      end;

      // unnamed arguments -> files: sls/hlg/kml/gpx/sml etc.
      if VParseResult.Args.Count > 0 then begin
        ProcessOpenFiles(
          VParseResult.Args,
          FMapGoTo,
          ARegionProcess,
          False, // import in silent mode
          nil,
          FMarkSystem,
          FImporterList,
          FAppearanceOfMarkFactory
        );
      end;

    finally
      VParseResult.Free;
    end;
  finally
    VParser.Free;
  end;
end;

function TCmdLineArgProcessor.GetErrorFromCode(const ACode: Integer): string;
begin
  Result := u_CmdLineArgProcessorAPI.GetErrorFromCode(ACode);
end;

end.
