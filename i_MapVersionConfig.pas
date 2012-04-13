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

unit i_MapVersionConfig;

interface

uses
  i_ConfigDataElement,
  i_MapVersionInfo;
  
type
  IMapVersionFactory = interface
    ['{4E03F54E-C11D-443C-BF0E-D9A2B0D1299C}']
    function CreateByStoreString(AValue: string): IMapVersionInfo;
    function CreateByMapVersion(AValue: IMapVersionInfo): IMapVersionInfo;
  end;

  IMapVersionConfig = interface(IConfigDataElement)
    ['{0D710534-C49F-43BC-8092-A0F5ABB5E107}']
    function GetVersionFactory: IMapVersionFactory;
    procedure SetVersionFactory(AValue: IMapVersionFactory);
    property VersionFactory: IMapVersionFactory read GetVersionFactory write SetVersionFactory;

    function GetVersion: IMapVersionInfo;
    procedure SetVersion(const AValue: IMapVersionInfo);
    property Version: IMapVersionInfo read GetVersion write SetVersion;
  end;

implementation

end.
