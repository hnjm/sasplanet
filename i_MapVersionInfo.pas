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

unit i_MapVersionInfo;

interface

type
  IMapVersionInfo = interface
    ['{CC157D46-11DA-4035-963B-2F0BEAEA265A}']
    function GetUrlString: string;
    property UrlString: string read GetUrlString;

    function GetStoreString: string;
    property StoreString: string read GetStoreString;

    function GetCaption: string;
    property Caption: string read GetCaption;

    function IsSame(const AValue: IMapVersionInfo): Boolean;
  end;

  IMapVersionListStatic = interface
    ['{6F7FA14E-6DC8-43B8-86FA-10541B204D77}']
    function GetCount: Integer;
    property Count: Integer read GetCount;

    function GetItem(AIndex: Integer): IMapVersionInfo;
    property Item[AIndex: Integer]: IMapVersionInfo read GetItem;
  end;

implementation

end.
