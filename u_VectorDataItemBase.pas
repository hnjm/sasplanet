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

unit u_VectorDataItemBase;

interface

uses
  t_GeoTypes,
  i_HtmlToHintTextConverter,
  i_VectorDataItemSimple;

type
  TVectorDataItemBase = class(TInterfacedObject, IVectorDataItemSimple)
  private
    FHintConverter: IHtmlToHintTextConverter;
    FName: string;
    FDesc: string;
  protected
    function GetName: string;
    function GetDesc: string;
    function GetLLRect: TDoubleRect;  virtual; abstract;
    function GetHintText: string;
    function GetHintTextWithoutDesc: string;
    function GetInfoCaption: string;
    function GetInfoHTML: string;
  public
    constructor Create(
      AHintConverter: IHtmlToHintTextConverter;
      AName: string;
      ADesc: string
    );
  end;

implementation

uses
  SysUtils;

{ TVectorDataItemBase }

constructor TVectorDataItemBase.Create(
  AHintConverter: IHtmlToHintTextConverter;
  AName, ADesc: string
);
begin
  FHintConverter := AHintConverter;
  FName := AName;
  FDesc := ADesc;
end;

function TVectorDataItemBase.GetDesc: string;
begin
  Result := FDesc;
end;

function TVectorDataItemBase.GetHintText: string;
begin
  Result := FHintConverter.Convert(FName, FDesc);
end;

function TVectorDataItemBase.GetHintTextWithoutDesc: string;
begin
  Result := FHintConverter.Convert(FName, '');
end;

function TVectorDataItemBase.GetInfoCaption: string;
begin
  Result := FName;
end;

function TVectorDataItemBase.GetInfoHTML: string;
begin
  Result := '';
  if Fdesc <> '' then begin
    Result:='<HTML><BODY>';
    Result:=Result+Fdesc;
    Result:=Result+'</BODY></HTML>';
  end;
end;

function TVectorDataItemBase.GetName: string;
begin
  Result := FName;
end;

end.
