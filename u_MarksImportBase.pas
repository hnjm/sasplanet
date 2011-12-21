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

unit u_MarksImportBase;

interface

uses
  Classes,
  i_ImportFile,
  i_ImportConfig;

type
  TMarksImportBase = class(TInterfacedObject, IImportFile)
  protected
    function DoImport(AFileName: string; AConfig: IImportConfig): IInterfaceList; virtual; abstract;
  protected
    function ProcessImport(AFileName: string; AConfig: IImportConfig): Boolean;
  end;
  
implementation

{ TMarksImportBase }

function TMarksImportBase.ProcessImport(AFileName: string;
  AConfig: IImportConfig): Boolean;
var
  VList: IInterfaceList;
begin
  Result := False;
  VList := DoImport(AFileName, AConfig);
  if VList <> nil then begin
    if VList.Count > 0 then begin
      AConfig.MarkDB.UpdateMarksList(nil, VList);
      Result := True;
    end;
  end;
end;

end.
