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

unit i_MarkDb;

interface

uses
  Classes,
  i_Notifier,
  t_GeoTypes,
  i_Category,
  i_MarkFactory,
  i_VectorItemSubset,
  i_MarkId,
  i_Mark;

type
  IMarkDb = interface
    ['{66181215-0260-42A3-9CEA-549329D85F74}']
    function GetMarkByName(
      const AName: string;
      const ACategory: ICategory
    ): IMark;

    function GetMarkSubsetByCategoryList(
      const ACategoryList: IInterfaceList;
      const AIncludeHiddenMarks: Boolean
    ): IVectorItemSubset;
    function GetMarkSubsetByCategory(
      const ACategory: ICategory;
      const AIncludeHiddenMarks: Boolean
    ): IVectorItemSubset;
    function GetMarkSubsetByCategoryListInRect(
      const ARect: TDoubleRect;
      const ACategoryList: IInterfaceList;
      const AIncludeHiddenMarks: Boolean
    ): IVectorItemSubset;
    function GetMarkSubsetByCategoryInRect(
      const ARect: TDoubleRect;
      const ACategory: ICategory;
      const AIncludeHiddenMarks: Boolean
    ): IVectorItemSubset;

    function UpdateMark(
      const AOldMark: IMark;
      const ANewMark: IMark
    ): IMark;
    function UpdateMarkList(
      const AOldMarkList: IInterfaceList;
      const ANewMarkList: IInterfaceList
    ): IInterfaceList;

    function GetAllMarkIdList: IInterfaceList;
    function GetMarkIdListByCategory(const ACategory: ICategory): IInterfaceList;

    function GetMarkByID(const AMarkId: IMarkId): IMark;

    procedure SetMarkVisibleByID(const AMark: IMarkId; AVisible: Boolean);
    procedure SetMarkVisible(const AMark: IMark; AVisible: Boolean);

    procedure SetMarkVisibleByIDList(const AMarkList: IInterfaceList; AVisible: Boolean);
    procedure ToggleMarkVisibleByIDList(const AMarkList: IInterfaceList);

    function GetMarkVisibleByID(const AMark: IMarkId): Boolean;
    function GetMarkVisible(const AMark: IMark): Boolean;
    procedure SetAllMarksInCategoryVisible(
      const ACategory: ICategory;
      ANewVisible: Boolean
    );

    function GetFactory: IMarkFactory;
    property Factory: IMarkFactory read GetFactory;

    function GetChangeNotifier: INotifier;
    property ChangeNotifier: INotifier read GetChangeNotifier;
  end;

implementation

end.
