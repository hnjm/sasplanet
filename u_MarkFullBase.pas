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

unit u_MarkFullBase;

interface

uses
  t_GeoTypes,
  i_HtmlToHintTextConverter,
  i_MarkCategory,
  i_MarksSimple,
  u_MarkId;

type
  TMarkFullBase = class(TMarkId, IMark)
  private
    FHintConverter: IHtmlToHintTextConverter;
    FDesc: string;
  protected
    function GetDesc: string;
    function GetLLRect: TDoubleRect; virtual; abstract;
    function GetHintText: string;
    function GetInfoHTML: string;
    function GetGoToLonLat: TDoublePoint; virtual; abstract;
    function IsEqual(const AMark: IMark): Boolean; virtual;
  public
    constructor Create(
      const AHintConverter: IHtmlToHintTextConverter;
      const AName: string;
      AId: Integer;
      const ACategory: ICategory;
      const ADesc: string;
      AVisible: Boolean
    );
  end;

implementation

uses
  SysUtils,
  i_MarksDbSmlInternal,
  u_GeoFun;

{ TMarkFullBase }

constructor TMarkFullBase.Create(
  const AHintConverter: IHtmlToHintTextConverter;
  const AName: string;
  AId: Integer;
  const ACategory: ICategory;
  const ADesc: string;
  AVisible: Boolean
);
begin
  inherited Create(AName, AId, ACategory, AVisible);
  FHintConverter := AHintConverter;
  FDesc := ADesc;
end;

function TMarkFullBase.GetDesc: string;
begin
  Result := FDesc;
end;

function TMarkFullBase.GetHintText: string;
begin
  Result := FHintConverter.Convert(GetName, FDesc);
end;

function TMarkFullBase.GetInfoHTML: string;
begin
  Result := '';
  if Fdesc <> '' then begin
    Result := '<HTML><BODY>';
    Result := Result + Fdesc;
    Result := Result + '</BODY></HTML>';
  end;
end;

function TMarkFullBase.IsEqual(const AMark: IMark): Boolean;
var
  VMarkInternal: IMarkSMLInternal;
begin
  Result := False;
  if Supports(AMark, IMarkSMLInternal, VMarkInternal) then begin
    if IsEqualInternal(VMarkInternal) then begin
      if FDesc = AMark.Desc then begin
        Result := True;
      end;
    end;
  end;
end;

end.
