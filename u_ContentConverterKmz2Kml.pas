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

unit u_ContentConverterKmz2Kml;

interface

uses
  Classes,
  u_ContentConverterBase;

type
  TContentConverterKmz2Kml = class(TContentConverterBase)
  protected
    procedure ConvertStream(ASource, ATarget: TStream); override;
  end;

implementation

uses
  KAZip;

{ TContentConverterKmz2Kml }

procedure TContentConverterKmz2Kml.ConvertStream(ASource, ATarget: TStream);
var
  UnZip:TKAZip;
begin
  inherited;
  UnZip:=TKAZip.Create(nil);
  try
    UnZip.Open(ASource);
    UnZip.Entries.Items[0].ExtractToStream(ATarget);
  finally
    UnZip.Free;
  end;
end;

end.
