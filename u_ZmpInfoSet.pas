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

unit u_ZmpInfoSet;

interface

uses
  ActiveX,
  i_GUIDSet,
  i_ZmpInfo,
  i_CoordConverterFactory,
  i_LanguageManager,
  i_FileNameIterator,
  i_ZmpConfig,
  i_ZmpInfoSet;

type
  TZmpInfoSet = class(TInterfacedObject, IZmpInfoSet)
  private
    FList: IGUIDInterfaceSet;
  protected
    function GetZmpByGUID(const AGUID: TGUID): IZmpInfo;
    function GetIterator: IEnumGUID;
  public
    constructor Create(
      const AZmpConfig: IZmpConfig;
      const ACoordConverterFactory: ICoordConverterFactory;
      const ALanguageManager: ILanguageManager;
      const AFilesIterator: IFileNameIterator
    );
  end;

implementation

uses
  SysUtils,
  Dialogs,
  i_ConfigDataProvider,
  u_GUIDInterfaceSet,
  u_ConfigDataProviderByFolder,
  u_ConfigDataProviderByKaZip,
  u_ZmpInfo,
  u_ResStrings;

{ TZmpInfoSet }

constructor TZmpInfoSet.Create(
  const AZmpConfig: IZmpConfig;
  const ACoordConverterFactory: ICoordConverterFactory;
  const ALanguageManager: ILanguageManager;
  const AFilesIterator: IFileNameIterator
);
var
  VFileName: WideString;
  VFullFileName: string;
  VZmp: IZmpInfo;
  VZmpExist: IZmpInfo;
  VZmpMapConfig: IConfigDataProvider;
  VMapTypeCount: integer;
begin
  FList := TGUIDInterfaceSet.Create;
  VMapTypeCount := 0;
  while AFilesIterator.Next(VFileName) do begin
    VFullFileName := AFilesIterator.GetRootFolderName + VFileName;
    try
      if FileExists(VFullFileName) then begin
        VZmpMapConfig := TConfigDataProviderByKaZip.Create(VFullFileName);
      end else begin
        VZmpMapConfig := TConfigDataProviderByFolder.Create(VFullFileName);
      end;
      try
        VZmp := TZmpInfo.Create(
          AZmpConfig,
          ALanguageManager,
          ACoordConverterFactory,
          VFileName,
          VZmpMapConfig,
          VMapTypeCount
        );
      except
        on E: EZmpError do begin
          raise Exception.CreateResFmt(@SAS_ERR_MapGUIDError, [VFileName, E.Message]);
        end;
      end;
      VZmpExist := IZmpInfo(FList.GetByGUID(VZmp.GUID));
      if VZmpExist <> nil then begin
        raise Exception.CreateFmt(SAS_ERR_MapGUIDDuplicate, [VZmpExist.FileName, VFullFileName]);
      end;
    except
      if ExceptObject <> nil then begin
        ShowMessage((ExceptObject as Exception).Message);
      end;
      VZmp := nil;
    end;
    if VZmp <> nil then begin
      FList.Add(VZmp.GUID, VZmp);
      inc(VMapTypeCount);
    end;
  end;
end;

function TZmpInfoSet.GetIterator: IEnumGUID;
begin
  Result := FList.GetGUIDEnum;
end;

function TZmpInfoSet.GetZmpByGUID(const AGUID: TGUID): IZmpInfo;
begin
  Result := IZmpInfo(FList.GetByGUID(AGUID));
end;

end.
