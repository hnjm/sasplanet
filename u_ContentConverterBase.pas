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

unit u_ContentConverterBase;

interface

uses
  Classes,
  i_ContentTypeInfo,
  i_ContentConverter;

type

  TContentConverterAbstract = class(TInterfacedObject, IContentConverter)
  private
    FSource: IContentTypeInfoBasic;
    FTarget: IContentTypeInfoBasic;
  protected
    function GetSource: IContentTypeInfoBasic;
    function GetTarget: IContentTypeInfoBasic;
    function GetIsSimpleCopy: Boolean; virtual; abstract;
    procedure ConvertStream(ASource, ATarget: TStream); virtual; abstract;
  public
    constructor Create(
      ASource: IContentTypeInfoBasic;
      ATarget: IContentTypeInfoBasic
    );
    destructor Destroy; override;
  end;

  TContentConverterBase = class(TContentConverterAbstract)
  protected
    function GetIsSimpleCopy: Boolean; override;
  end;

  TContentConverterSimpleCopy = class(TContentConverterAbstract)
  protected
    function GetIsSimpleCopy: Boolean; override;
    procedure ConvertStream(ASource, ATarget: TStream); override;
  end;

implementation

{ TContentConverterAbstract }

constructor TContentConverterAbstract.Create(ASource,
  ATarget: IContentTypeInfoBasic);
begin
  FSource := ASource;
  FTarget := ATarget;
end;

destructor TContentConverterAbstract.Destroy;
begin
  FSource := nil;
  FTarget := nil;
  inherited;
end;

function TContentConverterAbstract.GetSource: IContentTypeInfoBasic;
begin
  Result := FSource;
end;

function TContentConverterAbstract.GetTarget: IContentTypeInfoBasic;
begin
  Result := FTarget;
end;

{ TContentConverterBase }

function TContentConverterBase.GetIsSimpleCopy: Boolean;
begin
  Result := False;
end;

{ TContentConverterSimpleCopy }

procedure TContentConverterSimpleCopy.ConvertStream(ASource, ATarget: TStream);
begin
  ATarget.CopyFrom(ASource, ASource.Size);
end;

function TContentConverterSimpleCopy.GetIsSimpleCopy: Boolean;
begin
  Result := True;
end;

end.
