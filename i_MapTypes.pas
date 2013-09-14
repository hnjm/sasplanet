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

unit i_MapTypes;

interface

uses
  ActiveX,
  t_Hash,
  i_Changeable,
  u_MapType;

type
  IMapType = interface
    ['{85957D2C-19D7-4F44-A183-F3679B2A5973}']
    function GetMapType: TMapType;
    property MapType: TMapType read GetMapType;

    function GetGUID: TGUID;
    property GUID: TGUID read GetGUID;
  end;

  IMapTypeChangeable = interface(IChangeable)
    ['{8B43402D-0D20-4A6B-8198-71DDAAADD2A9}']
    function GetStatic: IMapType;
  end;

  IMapTypeListStatic = interface
    ['{0A48D2E0-5C39-4E1A-A438-B50535E6D69B}']
    function GetHash: THashValue;
    property Hash: THashValue read GetHash;

    function GetCount: Integer;
    property Count: Integer read GetCount;

    function GetItem(AIndex: Integer): IMapType;
    property Items[AIndex: Integer]: IMapType read GetItem;

    function IsEqual(const AValue: IMapTypeListStatic): Boolean;
  end;

  IMapTypeListBuilder = interface
    ['{9349108A-1B0F-4920-B273-32710FE6659B}']
    function GetCount: Integer;
    property Count: Integer read GetCount;

    function GetCapacity: Integer;
    procedure SetCapacity(ANewCapacity: Integer);
    property Capacity: Integer read GetCapacity write SetCapacity;

    function GetItem(AIndex: Integer): IMapType;
    procedure SetItem(AIndex: Integer; const AItem: IMapType);
    property Items[Index: Integer]: IMapType read GetItem write SetItem; default;

    procedure Add(const AItem: IMapType);
    procedure Clear;
    procedure Delete(AIndex: Integer);
    procedure Exchange(AIndex1, AIndex2: Integer);
    function MakeCopy: IMapTypeListStatic;
    function MakeAndClear: IMapTypeListStatic;
  end;

  IMapTypeListBuilderFactory = interface
    ['{C5573186-2284-470D-B617-30F4C22898FF}']
    function Build: IMapTypeListBuilder;
  end;

  IMapTypeSet = interface
    ['{45EF5080-01DC-4FE1-92E1-E93574439718}']
    function GetHash: THashValue;
    property Hash: THashValue read GetHash;

    function GetCount: Integer;
    property Count: Integer read GetCount;

    function GetItem(AIndex: Integer): IMapType;
    property Items[AIndex: Integer]: IMapType read GetItem;

    function IsEqual(const AValue: IMapTypeSet): Boolean;
    function GetMapTypeByGUID(const AGUID: TGUID): IMapType;
    function GetIterator: IEnumGUID;
    function GetMapTypeIterator: IEnumUnknown;
  end;

  IMapTypeSetBuilder = interface
    ['{B41BE8B9-B70A-4E7D-B462-DA31513DB13A}']
    function GetCount: Integer;
    property Count: Integer read GetCount;

    function GetCapacity: Integer;
    procedure SetCapacity(ANewCapacity: Integer);
    property Capacity: Integer read GetCapacity write SetCapacity;

    procedure Add(const AItem: IMapType);
    procedure Clear;
    function MakeCopy: IMapTypeSet;
    function MakeAndClear: IMapTypeSet;
  end;

  IMapTypeSetBuilderFactory = interface
    ['{C5573186-2284-470D-B617-30F4C22898FF}']
    function Build(const AAllowNil: Boolean): IMapTypeSetBuilder;
  end;

  IMapTypeSetChangeable = interface(IChangeable)
    ['{F6548515-4FB4-45F1-A742-B886BBCB1024}']
    function GetStatic: IMapTypeSet;
  end;

implementation

end.
