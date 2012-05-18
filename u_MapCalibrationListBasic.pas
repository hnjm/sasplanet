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

unit u_MapCalibrationListBasic;

interface

uses
  Classes,
  i_MapCalibration;

type
  TMapCalibrationListByInterfaceList = class(TInterfacedObject, IMapCalibrationList)
  private
    FList: IInterfaceList;
  protected
    function GetCount: Integer;
    function Get(AIndex: Integer): IMapCalibration;
  public
    constructor Create(AList: IInterfaceList);
  end;

  TMapCalibrationListBasic = class(TMapCalibrationListByInterfaceList)
  public
    constructor Create();
  end;

implementation

uses
  u_MapCalibrationOzi,
  u_MapCalibrationDat,
  u_MapCalibrationKml,
  u_MapCalibrationTab,
  u_MapCalibrationWorldFiles;

{ TMapCalibrationListByInterfaceList }

constructor TMapCalibrationListByInterfaceList.Create(AList: IInterfaceList);
begin
  inherited Create;
  FList := AList;
end;

function TMapCalibrationListByInterfaceList.Get(
  AIndex: Integer
): IMapCalibration;
begin
  Result := IMapCalibration(FList.Items[AIndex]);
end;

function TMapCalibrationListByInterfaceList.GetCount: Integer;
begin
  Result := FList.Count;
end;

{ TMapCalibrationListBasic }

constructor TMapCalibrationListBasic.Create;
var
  VList: IInterfaceList;
begin
  VList := TInterfaceList.Create;
  VList.Add(IMapCalibration(TMapCalibrationOzi.Create));
  VList.Add(IMapCalibration(TMapCalibrationDat.Create));
  VList.Add(IMapCalibration(TMapCalibrationKml.Create));
  VList.Add(IMapCalibration(TMapCalibrationTab.Create));
  VList.Add(IMapCalibration(TMapCalibrationWorldFiles.Create));
  inherited Create(VList);
end;

end.
