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

unit i_ConfigDataProvider;

interface

uses
  Classes;

type
  IConfigDataProvider = interface
    ['{FB657238-6D8F-463D-B56F-3FB4C74EE352}']
    function GetSubItem(const AIdent: string): IConfigDataProvider;
    function ReadBinaryStream(const AIdent: string; AValue: TStream): Integer;
    function ReadString(const AIdent: string; const ADefault: string): string;
    function ReadInteger(const AIdent: string; const ADefault: Longint): Longint;
    function ReadBool(const AIdent: string; const ADefault: Boolean): Boolean;
    function ReadDate(const AIdent: string; const ADefault: TDateTime): TDateTime;
    function ReadDateTime(const AIdent: string; const ADefault: TDateTime): TDateTime;
    function ReadFloat(const AIdent: string; const ADefault: Double): Double;
    function ReadTime(const AIdent: string; const ADefault: TDateTime): TDateTime;

    procedure ReadSubItemsList(AList: TStrings);
    procedure ReadValuesList(AList: TStrings);
  end;

implementation

end.
