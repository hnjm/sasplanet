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

unit u_ImportByFileExt;

interface

uses
  i_ImportFile,
  i_VectorItmesFactory,
  i_VectorDataFactory,
  i_VectorDataLoader,
  i_ImportConfig,
  u_BaseInterfacedObject;

{$I vsagps_defines.inc}

type
  TImportByFileExt = class(TBaseInterfacedObject, IImportFile)
  private
    FImportXML: IImportFile;
    FImportXMLZ: IImportFile;
    FImportPLT: IImportFile;
    FImportCSV: IImportFile;
    FImportKML: IImportFile;
    FImportKMZ: IImportFile;
    FImportHLG: IImportFile;
    FImportMP: IImportFile;
    FImportSLS: IImportFile;
  private
    function ProcessImport(
      const AFileName: string;
      const AConfig: IImportConfig
    ): Boolean;
  public
    constructor Create(
      const AVectorDataFactory: IVectorDataFactory;
      const AFactory: IVectorItemsFactory;
      const AXmlLoader: IVectorDataLoader;
      const APltLoader: IVectorDataLoader;
      const AKmlLoader: IVectorDataLoader;
      const AKmzLoader: IVectorDataLoader;
      const AXmlZLoader: IVectorDataLoader
    );
  end;

implementation

uses
  SysUtils,
  u_ImportKML,
  u_ImportHLG,
  u_ImportCSV,
  u_ImportSLS,
  u_ImportMpSimple;

{ TImportByFileExt }

constructor TImportByFileExt.Create(
  const AVectorDataFactory: IVectorDataFactory;
  const AFactory: IVectorItemsFactory;
  const AXmlLoader: IVectorDataLoader;
  const APltLoader: IVectorDataLoader;
  const AKmlLoader: IVectorDataLoader;
  const AKmzLoader: IVectorDataLoader;
  const AXmlZLoader: IVectorDataLoader
);
begin
  inherited Create;
  FImportXML := TImportKML.Create(AVectorDataFactory, AXmlLoader);
  FImportXMLZ := TImportKML.Create(AVectorDataFactory, AXmlZLoader);
  FImportPLT := TImportKML.Create(AVectorDataFactory, APltLoader);
  FImportCSV := TImportCSV.Create(AFactory);
  FImportHLG := TImportHLG.Create(AFactory);
  FImportMP := TImportMpSimple.Create(AFactory);
  FImportKML := TImportKML.Create(AVectorDataFactory, AKmlLoader);
  FImportKMZ := TImportKML.Create(AVectorDataFactory, AKmzLoader);
  FImportSLS := TImportSLS.Create(AFactory);
end;

function TImportByFileExt.ProcessImport(
  const AFileName: string;
  const AConfig: IImportConfig
): Boolean;
var
  VExtLwr: String;
begin
  Result := False;
  VExtLwr := LowerCase(ExtractFileExt(AFileName));
  if ('.gpx' = VExtLwr) then begin
    Result := FImportXML.ProcessImport(AFileName, AConfig);
  end else if ('.kml' = VExtLwr) then begin
{$if defined(VSAGPS_ALLOW_IMPORT_KML)}
    Result := FImportXML.ProcessImport(AFileName, AConfig);
{$else}
    Result := FImportKML.ProcessImport(AFileName, AConfig);
{$ifend}
  end else if ('.kmz' = VExtLwr) then begin
{$if defined(VSAGPS_ALLOW_IMPORT_KML)}
    Result := FImportXMLZ.ProcessImport(AFileName, AConfig);
{$else}
    Result := FImportKMZ.ProcessImport(AFileName, AConfig);
{$ifend}
  end else if ('.plt' = VExtLwr) then begin
    Result := FImportPLT.ProcessImport(AFileName, AConfig);
  end else if ('.csv' = VExtLwr) then begin
    Result := FImportCSV.ProcessImport(AFileName, AConfig);
  end else if ('.hlg' = VExtLwr) then begin
    Result := FImportHLG.ProcessImport(AFileName, AConfig);
  end else if ('.mp' = VExtLwr) then begin
    Result := FImportMP.ProcessImport(AFileName, AConfig);
  end else if ('.sls' = VExtLwr) then begin
    Result := FImportSLS.ProcessImport(AFileName, AConfig);
  end;
end;

end.
