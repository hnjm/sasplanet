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

unit u_TileInfoBasic;

interface

uses
  i_ContentTypeInfo,
  i_MapVersionInfo,
  i_TileInfoBasic;

type
  TTileInfoBasicBase = class(TInterfacedObject, ITileInfoBasic)
  private
    FDate: TDateTime;
    FVersionInfo: IMapVersionInfo;
  protected
    function GetIsExists: Boolean; virtual; abstract;
    function GetIsExistsTNE: Boolean; virtual; abstract;
    function GetLoadDate: TDateTime; virtual;
    function GetSize: Cardinal; virtual; abstract;
    function GetVersionInfo: IMapVersionInfo; virtual;
    function GetContentType: IContentTypeInfoBasic; virtual; abstract;
  public
    constructor Create(
      ADate: TDateTime;
      AVersionInfo: IMapVersionInfo
    );
  end;

  TTileInfoBasicNotExists = class(TTileInfoBasicBase)
  protected
    function GetIsExists: Boolean; override;
    function GetIsExistsTNE: Boolean; override;
    function GetSize: Cardinal; override;
    function GetContentType: IContentTypeInfoBasic; override;
  end;

  TTileInfoBasicTNE = class(TTileInfoBasicBase)
  protected
    function GetIsExists: Boolean; override;
    function GetIsExistsTNE: Boolean; override;
    function GetSize: Cardinal; override;
    function GetContentType: IContentTypeInfoBasic; override;
  end;

  TTileInfoBasicExists = class(TTileInfoBasicBase)
  private
    FSize: Cardinal;
    FContentType: IContentTypeInfoBasic;
  protected
    function GetIsExists: Boolean; override;
    function GetIsExistsTNE: Boolean; override;
    function GetSize: Cardinal; override;
    function GetContentType: IContentTypeInfoBasic; override;
  public
    constructor Create(
      ADate: TDateTime;
      ASize: Cardinal;
      AVersionInfo: IMapVersionInfo;
      AContentType: IContentTypeInfoBasic
    );
  end;

implementation

{ TTileInfoBasicBase }

constructor TTileInfoBasicBase.Create(
  ADate: TDateTime;
  AVersionInfo: IMapVersionInfo
);
begin
  FDate := ADate;
  FVersionInfo := AVersionInfo;
end;

function TTileInfoBasicBase.GetLoadDate: TDateTime;
begin
  Result := FDate;
end;

function TTileInfoBasicBase.GetVersionInfo: IMapVersionInfo;
begin
  Result := FVersionInfo;
end;

{ TTileInfoBasicTNE }

function TTileInfoBasicTNE.GetContentType: IContentTypeInfoBasic;
begin
  Result := nil;
end;

function TTileInfoBasicTNE.GetIsExists: Boolean;
begin
  Result := False;
end;

function TTileInfoBasicTNE.GetIsExistsTNE: Boolean;
begin
  Result := True;
end;

function TTileInfoBasicTNE.GetSize: Cardinal;
begin
  Result := 0;
end;

{ TTileInfoBasicExists }

constructor TTileInfoBasicExists.Create(
  ADate: TDateTime;
  ASize: Cardinal;
  AVersionInfo: IMapVersionInfo;
  AContentType: IContentTypeInfoBasic
);
begin
  inherited Create(ADate, AVersionInfo);
  FSize := ASize;
  FContentType := AContentType;
end;

function TTileInfoBasicExists.GetContentType: IContentTypeInfoBasic;
begin
  Result := FContentType;
end;

function TTileInfoBasicExists.GetIsExists: Boolean;
begin
  Result := True;
end;

function TTileInfoBasicExists.GetIsExistsTNE: Boolean;
begin
  Result := False;
end;

function TTileInfoBasicExists.GetSize: Cardinal;
begin
  Result := FSize;
end;

{ TTileInfoBasicNotExists }

function TTileInfoBasicNotExists.GetContentType: IContentTypeInfoBasic;
begin
  Result := nil;
end;

function TTileInfoBasicNotExists.GetIsExists: Boolean;
begin
  Result := False;
end;

function TTileInfoBasicNotExists.GetIsExistsTNE: Boolean;
begin
  Result := False;
end;

function TTileInfoBasicNotExists.GetSize: Cardinal;
begin
  Result := 0;
end;

end.
