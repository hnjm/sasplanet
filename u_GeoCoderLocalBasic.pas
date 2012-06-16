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

unit u_GeoCoderLocalBasic;

interface

uses
  Classes,
  i_OperationNotifier,
  i_GeoCoder,
  i_LocalCoordConverter;

type
  TGeoCoderLocalBasic = class(TInterfacedObject, IGeoCoder)
  public
   FLocalConverter : ILocalCoordConverter;
  protected
    function DoSearch(
      const ACancelNotifier: IOperationNotifier;
      AOperationID: Integer;
      const ASearch: WideString
    ): IInterfaceList; virtual; abstract;
  protected
    function GetLocations(
      const ACancelNotifier: IOperationNotifier;
      AOperationID: Integer;
      const ASearch: WideString;
      const ALocalConverter: ILocalCoordConverter
    ): IGeoCodeResult; safecall;
  end;
implementation

uses
  u_GeoCodeResult;

{ TGeoCoderLocalBasic }

function TGeoCoderLocalBasic.GetLocations(
  const ACancelNotifier: IOperationNotifier;
  AOperationID: Integer;
  const ASearch: WideString;
  const ALocalConverter: ILocalCoordConverter
): IGeoCodeResult;
var
  VList: IInterfaceList;
  VResultCode: Integer;
begin
  VResultCode := 200;
  VList := nil;
  Result := nil;
  FLocalConverter := ALocalConverter;
  if ACancelNotifier.IsOperationCanceled(AOperationID) then begin
    Exit;
  end;
  VList :=
   DoSearch(
   ACancelNotifier,
   AOperationID,
   ASearch
   );
  if VList = nil then begin
    VList := TInterfaceList.Create;
  end;   
  Result := TGeoCodeResult.Create(ASearch, VResultCode,'', VList);
end;


end.
