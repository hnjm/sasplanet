{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2013, SAS.Planet development team.                      *}
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

unit i_BerkeleyDB;

interface

uses
  Classes,
  i_BinaryData,
  i_BerkeleyDBEnv;

type
  TExistsKeyArrayElement = record
    KeySize: Integer;
    KeyData: TList;
  end;

  TExistsKeyArray = array of TExistsKeyArrayElement;

  IBerkeleyDB = interface
    ['{7B7EFD37-ADAF-4A83-A3D8-CA3AAD6A300E}']
    procedure Open(const ADatabaseFileName: string);
    procedure Close;

    function Read(const AKey: IBinaryData): IBinaryData; overload;
    function Write(const AKey, AValue: IBinaryData): Boolean; overload;
    function Exists(const AKey: IBinaryData): Boolean; overload;
    function Del(const AKey: IBinaryData): Boolean; overload;

    function Read(const AKey: IBinaryData;  const ATxn: PBerkeleyTxn; out AIsDeadLock: Boolean; const AFlag: Cardinal = 0): IBinaryData; overload;
    function Write(const AKey, AValue: IBinaryData; const ATxn: PBerkeleyTxn; out AIsDeadLock: Boolean): Boolean; overload;
    function Exists(const AKey: IBinaryData; const ATxn: PBerkeleyTxn; out AIsDeadLock: Boolean): Boolean; overload;
    function Del(const AKey: IBinaryData; const ATxn: PBerkeleyTxn; out AIsDeadLock: Boolean): Boolean; overload;

    function CreateExistsKeyArray(out AKeyArray: TExistsKeyArray): Boolean;
    procedure ReleaseExistsKeyArray(var AKeyArray: TExistsKeyArray);

    procedure Sync;

    function GetFileName: string;
    property FileName: string read GetFileName;
  end;

implementation

end.
