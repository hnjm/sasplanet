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

unit u_MarksSQLDb;

interface

uses
  Windows,
  SysUtils,
  Classes,
  SQLite3Handler,
  t_GeoTypes,
  t_MarksSQLDb,
  i_IDList,
  i_SimpleFlag,
  i_Notifier,
  i_ConfigDataElement,
  i_InternalPerformanceCounter,
  i_LanguageManager,
  i_PathConfig,
  i_VectorItemsFactory,
  i_MarkPicture,
  i_MarksFactoryConfig,
  i_HtmlToHintTextConverter,
  i_MarkCategoryDBSmlInternal,
  i_MarkCategory,
  i_MarksSimple,
  i_MarkFactory,
  i_MarksDb,
  i_MarksDbSmlInternal,
  i_MarkFactorySmlInternal,
  i_MarkCategoryFactory,
  i_MarkCategoryFactoryDbInternal,
  i_MarkCategoryFactoryConfig,
  i_MarkCategoryDB,
  i_ReadWriteStateInternal,
  u_MarkCategoryList,
  u_ConfigDataElementBase;

type
  TMarksSQLDb = class(TConfigDataElementBaseEmptySaveLoad, IMarksDb, IMarksDbSmlInternal
                                                         , IMarkCategoryDB, IMarkCategoryDBSmlInternal)
  private
    FBasePath: IPathConfig;
    FLanguageManager: ILanguageManager;
    FMarkPictureList: IMarkPictureList;
    FStateInternal: IReadWriteStateInternal;
    FPerfCounterList: IInternalPerformanceCounterList;
    FCategoryFactoryConfig: IMarkCategoryFactoryConfig;
    FMarksFactoryConfig: IMarksFactoryConfig;
    FMarkFactoryDbInternal: IMarkFactorySmlInternal;
    FCategoryFactoryDbInternal: IMarkCategoryFactoryDbInternal;
    FCategoryFactory: IMarkCategoryFactory;
    FMarkFactory: IMarkFactory;

    FSQLite3DbHandler: TSQLite3DbHandler;
    FMarksSQLOptions: TMarksSQLiteOptions;

    // ��� ��������� (�������� �������� ���� IMarkCategory)
    FCategoryCache: TMarkCategoryList;

    // ��� PolygonShowId � ������ ����� �� ����������
    FCachePolygonShowId: TIdShowCache1;
    FCachePolylineShowIdLine: TIdShowCache2;
    FCachePolylineShowIdPoly: TIdShowCache2;
    FCachePointShowId: TIdShowCache4;
    FCachePointImageId: TIdShowCacheStr;

    // ��������
    FLookupImageCounter, FLookupPointShowCounter,
    FLookupPolylineShowCounter,
    FLookupPolygonShowCounter: IInternalPerformanceCounter;

    FUpdateMarkCounter, FUpdateMarksListCounter,
    FImportMarksCounter, FSelectMarkByIdCounter,
    FSelectAllMarksCounter, FSelectMarksByCategoryCounter,
    FSetMarksInCategoryVisibleCounter,
    FGetMarksSubsetByCategoryCounter,
    FGetMarksSubsetByListCounter: IInternalPerformanceCounter;

    FSelectAllCategoriesCounter, FSelectCategoryByIDCounter,
    FSelectCategoryByNameCounter: IInternalPerformanceCounter;
  private
    procedure MakePerfCounters; inline;
    procedure KillPerfCounters; inline;
  private
    function GetCategorySQLText: AnsiString;
    function GetMarksSQLText(const AMarkTypeSQL: TMarkType; const AWhere: AnsiString): AnsiString;
    function GetSelectMarkItems(const AItemsTable: AnsiString; const AIdMark: Integer): AnsiString;

    procedure CallbackReadSingleId(
      const AHandler: PSQLite3DbHandler;
      const ACallbackPtr: Pointer;
      const AStmtData: PSQLite3StmtData
    );
    procedure CallbackReadOptions(
      const AHandler: PSQLite3DbHandler;
      const ACallbackPtr: Pointer;
      const AStmtData: PSQLite3StmtData
    );
    procedure CallbackSelectCategory(
      const AHandler: PSQLite3DbHandler;
      const ACallbackPtr: Pointer;
      const AStmtData: PSQLite3StmtData
    );
    procedure CallbackSelectMark(
      const AHandler: PSQLite3DbHandler;
      const ACallbackPtr: Pointer;
      const AStmtData: PSQLite3StmtData
    );
    procedure CallbackSelectPolyItems(
      const AHandler: PSQLite3DbHandler;
      const ACallbackPtr: Pointer;
      const AStmtData: PSQLite3StmtData
    );

    // ��������� ������������ ����� �������
    procedure ParserFoundProc_SQL(
      const ASender: TObject;
      const ACommandIndex: Integer;
      const ACommandText, AErrors: TStrings
    );

    // ��������������� ��������� ��� ������ ������ � �����������
    // � ������� ������ ���� ��� �� �������
    function InternalGetShowId(
      const ASelectSQL, AInsertSQL: AnsiString;
      const AWithStringOptional: Boolean = FALSE;
      const AWideStrOptional: PWideChar = nil;
      const AWideStrLength: Integer = 0
    ): Integer;
    // � ��� - � ����������
    function GetImageIdByName(const AImageName: String): Integer;
    function GetPointShowId(const AMarkPoint: IMarkPoint): Integer;
    function GetPolygonShowId(const AMarkPoly: IMarkPoly; out AIdShowPL: Integer): Integer;
    function GetPolylineShowId(const AMarkLine: IMarkLine): Integer;
    function GetPolylineShowIdInternal(const AIdShowData2: PIdShowData2): Integer;

    function CoordToDB(const ACoord: Double): String;

    procedure CheckCategoryCacheActual(const ACacheAlreadyLocked: Boolean);

    procedure InternalSelectAllCategories(const ACacheAlreadyLocked: Boolean);
    function InternalSelectCategoryByID(const ACacheAlreadyLocked: Boolean; const id: integer): IMarkCategory;
    function InternalSelectCategoryByName(const ACacheAlreadyLocked: Boolean; const AName: string): IMarkCategory;
    function InternalImportCategoryByMark(const ANewMark: IMark): Integer;

    procedure InternalDeleteCategory(const AOldCategory: IMarkCategory);
    procedure InternalInsertCategory(const ANewCategory: IMarkCategory);
    function InternalUpdateCategory(const AOldCategory, ANewCategory: IMarkCategory): IMarkCategory;

    procedure InternalDeleteMarkSubExceptMarkType(const AMarkType: TMarkType; const AWhere: AnsiString);
    procedure InternalDeleteMark(const AOldMark: IInterface);
    function InternalInsertMark(
      const ANewMark: IInterface;
      const AImporting: Boolean;
      const AMarksImportOptions: TMarksImportOptions = []
    ): IMark;
    function InternalUpdateMark(const AOldMark, ANewMark: IInterface): IMark;

    function InternalInsertMarkPointSub(const ANewMarkPoint: IMarkPoint; const AIdMark: Integer): IMark;
    function InternalUpdateMarkPointSub(const AOldMarkPoint, ANewMarkPoint: IMarkPoint; const AIdMark: Integer): IMark;

    function InternalInsertMarkPolylineSub(const ANewMarkLine: IMarkLine; const AIdMark: Integer): IMark;
    function InternalUpdateMarkPolylineSub(const AOldMarkLine, ANewMarkLine: IMarkLine; const AIdMark: Integer): IMark;

    function InternalInsertMarkPolygonSub(const ANewMarkPoly: IMarkPoly; const AIdMark: Integer): IMark;
    function InternalUpdateMarkPolygonSub(const AOldMarkPoly, ANewMarkPoly: IMarkPoly; const AIdMark: Integer): IMark;

    function MakeCloneWithNewId(const AMark: IMark; const AIdValue: Integer): IMark;

    function InternalMarkToId(const AMark: IMark): IMarkId;

    // ����� ����� �� (�����)����������� �����
    // ����� 1 - ����� �� id (AIdCategoryPtr=nil - �� ����� ����� ������)
    // ����� 2 - ����� �� IdCategory+Name(AIdCategoryPtr<>nil - ����� ���� �����)
    function InternalReadMark(
      const AIdValue: Integer;
      const AIdCategoryPtr: PInteger = nil;
      const AWideNameBuffer: PWideChar = nil;
      const AWideNameLength: Integer = 0
    ): IMark;

    procedure InternalSetMarksVisible(
      const AIdMarkList: AnsiString;
      const ANewVisiblePtr: PBoolean
    );
    procedure InternalSetMarkVisibleByIDList(
      const AMarkList: IInterfaceList;
      const ANewVisiblePtr: PBoolean
    );

    procedure InternalSelectMarksToList(
      const AMarkList: IInterfaceList;
      const AIdCategoryPtr: PInteger;
      const AIdCategoryList: AnsiString;
      const ARectPtr: PDoubleRect;
      const AIgnoreVisible: Boolean;
      const AConvertToMarkId: Boolean
    );

  private
    function GetCurrentUserUniqueName: WideString;
    function GetCurrentUserId(const ACreateIfNotExists: Boolean): Integer;
    function SelectIdUserByName(const AName: WideString): Integer;

    function InternalCheckStructure: Boolean;
    function InternalIncrementVersion: Boolean;
    function InternalReadOptions: Boolean;
    procedure InternalReadVersion;
  private
    function GetCategoryID(const ACategory: ICategory): Integer;
    function _UpdateMark(const AOldMark, ANewMark: IInterface): IMark;
  private
    procedure SetSessionParams;
  protected
    procedure LockWrite; override;
    procedure UnlockWrite; override;
  private
    { IMarkCategoryDBSmlInternal }
    function SaveCategory2File: boolean;
    procedure LoadCategoriesFromFile;
    function GetCategoryByID(id: integer): IMarkCategory;

  private
    { IMarkCategoryDB }
    function GetCategoryByName(const AName: string): IMarkCategory;
    function UpdateCategory(
      const AOldCategory: IMarkCategory;
      const ANewCategory: IMarkCategory
    ): IMarkCategory;
    function ImportCategoriesList(
      const ACategoriesList: IInterfaceList
    ): IInterfaceList;

    function GetCategoriesList: IInterfaceList;
    procedure SetAllCategoriesVisible(ANewVisible: Boolean);

    function IMarkCategoryDB_GetFactory: IMarkCategoryFactory;
    function IMarkCategoryDB.GetFactory = IMarkCategoryDB_GetFactory;

    function IMarkCategoryDB_GetChangeNotifier: INotifier;
    function IMarkCategoryDB.GetChangeNotifier = IMarkCategoryDB_GetChangeNotifier;

  private
    { IMarksDbSmlInternal }
    function GetById(AId: Integer): IMarkSMLInternal;
    function SaveMarks2File: boolean;
    procedure LoadMarksFromFile;

  private
    { IMarksDb }
    function UpdateMark(
      const AOldMark: IInterface;
      const ANewMark: IMark
    ): IMark;
    function UpdateMarksList(
      const AOldMarkList: IInterfaceList;
      const ANewMarkList: IInterfaceList
    ): IInterfaceList;
    function ImportMarksList(
      const ANewMarkList: IInterfaceList;
      const AMarksImportOptions: TMarksImportOptions
    ): IInterfaceList;
    
    function GetMarkByID(const AMarkId: IMarkId): IMark;

    function GetAllMarksIdList: IInterfaceList;
    function GetMarksIdListByCategory(const ACategory: ICategory): IInterfaceList;

    procedure SetMarkVisibleByID(
      const AMark: IMarkId;
      AVisible: Boolean
    );
    procedure SetMarkVisibleByIDList(
      const AMarkList: IInterfaceList;
      AVisible: Boolean
    );
    procedure ToggleMarkVisibleByIDList(
      const AMarkList: IInterfaceList
    );

    function GetMarkVisible(const AMark: IMarkId): Boolean; overload;
    function GetMarkVisible(const AMark: IMark): Boolean; overload;

    procedure SetAllMarksInCategoryVisible(
      const ACategory: ICategory;
      ANewVisible: Boolean
    );

    function GetMarksSubset(
      const ARect: TDoubleRect;
      const ACategoryList: IInterfaceList;
      AIgnoreVisible: Boolean
    ): IMarksSubset; overload;
    function GetMarksSubset(
      const ARect: TDoubleRect;
      const ACategory: ICategory;
      AIgnoreVisible: Boolean
    ): IMarksSubset; overload;

    function IMarksDb_GetFactory: IMarkFactory;
    function IMarksDb.GetFactory = IMarksDb_GetFactory;

  public
    constructor Create(
      const AStateInternal: IReadWriteStateInternal;
      const ABasePath: IPathConfig;
      const ADBFilename: String;
      const ALanguageManager: ILanguageManager;
      const AMarkPictureList: IMarkPictureList;
      const APerfCounterList: IInternalPerformanceCounterList;
      const AVectorItemsFactory: IVectorItemsFactory;
      const AHintConverter: IHtmlToHintTextConverter;
      const ACategoryFactoryConfig: IMarkCategoryFactoryConfig
    );
    destructor Destroy; override;

    property MarksFactoryConfig: IMarksFactoryConfig read FMarksFactoryConfig;
  end;

  EMarksSQLiteError = class(Exception);

implementation

uses
  u_ResStrings,
  t_CommonTypes,
  u_IDInterfaceList,
  i_DoublePointsAggregator,
  i_VectorItemLonLat,
  u_MarkFactory,
  u_GeoFun,
  u_GeoToStr,
  u_SQLScriptParser,
  u_MarksFactoryConfig,
  u_MarkCategoryFactory,
  u_MarksSubset;

type
  PIMarkCategory = ^IMarkCategory;
  PIMarkSMLInternal = ^IMarkSMLInternal;
  PDoublePoint = ^TDoublePoint;

type
  // ��������� ��� ���� d_type ������� m_descript - ������ ���� �������� �����
  TMarkDescript_Type = (
    // ������ ������� ��������
    mdt_Description = 0
  );
  
const
  c_MarkTypeTBL: array [TMarkType] of AnsiString = ('', 'm_point',   'm_polyline', 'm_polygon');
  c_MarkShowTBL: array [TMarkType] of AnsiString = ('', 'm_show_pt', 'm_show_pl',  'm_show_pg');

  // ������������ ����� ��������� � ������ id IN (id1,id2,...,idN)
  c_MaxListCount=128;
  
type
  PSelectCategoryData = ^TSelectCategoryData;
  TSelectCategoryData = record
    AddToCache: Boolean;
    CacheAlreadyLocked: Boolean;
    SingleRow: Boolean;
    IdCategory: Integer;
    SingleCategory: IMarkCategory;
  private
    procedure Init;
  end;

  PSelectMarksData = ^TSelectMarksData;
  TSelectMarksData = record
    // ��� ����� (�� ����� ������� ���� � SELECT)
    MarkType: TMarkType;
    // ��������� �� Result
    SingleMark: IMark; // IMarkSMLInternal
    // ��������� �� ������ (���� ����)
    AllMarksList: IInterfaceList;
    // ����� ���������� ������ � ������, Id ��� ������
    // ������ ���� ����� ���� IMarkId(Pointer) - ��� �����
    ConvertToMarkId: Boolean;
    // ���������� ��� ������� �����
    AllPoints: PDoublePointArray;
    // �������� ������ (� ������)
    AllocCount: Integer;
    // ��� ������������ ��� ������� ����� (����������� �������)
    UsedCount: Integer;
    // ����� ����� � ��������� �����
    // PartCount: Integer;
  private
    // ��������� ������ ��� ���������� ����� ���������
    procedure InternalAllocForUsedCount(const ANewUsedCount: Integer);
    // ����� ��������� ��������� ��� ������ ����� �����
    procedure InitNewMarkPoints; inline;
    // ��������� ���� ����� � ����������
    procedure AppendOnePoint(const APoint: TDoublePoint);
    // ��������� ������ �� ����� � ����������
    procedure AppendArrayOfPoints(const APointArray: Pointer; const APointCount: Integer);
  private
    procedure Init;
    procedure Uninit;
  end;

function VisibleToSQL(const ABoolValue: Boolean): AnsiString;
begin
  if ABoolValue then
    Result := '1'
  else
    Result := '0';
end;

{ TMarksSQLDb }

procedure TMarksSQLDb.CallbackReadOptions(
  const AHandler: PSQLite3DbHandler;
  const ACallbackPtr: Pointer;
  const AStmtData: PSQLite3StmtData
);
var
  Vid_option, Voption_value: Integer;
begin
  // ������� ��� �����
  with AStmtData^ do begin
    Vid_option    := ColumnInt(0);
    Voption_value := ColumnInt(1);
  end;

  case Vid_option of
    Ord(mgo_MonitoringMode): begin
      // monitoring mode: only 0 or 3
      if (3=Voption_value) then begin
        FMarksSQLOptions.MonitoringModeValue := 3;
      end;
    end;
    (*
    2: begin
      // referential integrity - ignore (always use FK)
    end;
    3: begin
      // monitoring timeout - ignore
    end;
    *)
    Ord(mgo_MultiuserMode): begin
      // multiuser mode
      FMarksSQLOptions.MultiuserModeValue := Voption_value;
    end;
    Ord(mgo_CoordStorageMode): begin
      // coordinates storage mode
      FMarksSQLOptions.CoordStorageModeValue := Voption_value;
    end;
  end;
end;

procedure TMarksSQLDb.CallbackReadSingleId(
  const AHandler: PSQLite3DbHandler;
  const ACallbackPtr: Pointer;
  const AStmtData: PSQLite3StmtData
);
begin
  // ������ ���� ���� ���� INT
  PInteger(ACallbackPtr)^ := AStmtData^.ColumnInt(0);
  AStmtData^.Cancelled := TRUE;
end;

procedure TMarksSQLDb.CallbackSelectCategory(
  const AHandler: PSQLite3DbHandler;
  const ACallbackPtr: Pointer;
  const AStmtData: PSQLite3StmtData
);
var
  Vmin_zoom: Integer;
  Vmax_zoom: Integer;
  Vv_visible: Boolean;
  Vc_name: String;
begin
  with AStmtData^ do begin
    // ������������� ���������
    PSelectCategoryData(ACallbackPtr)^.IdCategory := ColumnInt(0);
    // ������ ����
    Vmin_zoom  := ColumnIntDef(1, FCategoryFactoryConfig.AfterScale);
    Vmax_zoom  := ColumnIntDef(2, FCategoryFactoryConfig.BeforeScale);
    Vv_visible := (ColumnIntDef(3,1)=1);
    Vc_name    := ColumnAsWideString(4);
  end;

  with PSelectCategoryData(ACallbackPtr)^ do begin
    // ������ ���������
    SingleCategory := FCategoryFactoryDbInternal.CreateCategory(
      IdCategory,
      Vc_name,
      Vv_visible,
      Vmin_zoom,
      Vmax_zoom
    );

    // ������� � ���
    if AddToCache then begin
      if (not CacheAlreadyLocked) then
        FCategoryCache.CategoryNotifier.LockWrite;
      try
        // ���� ����� ��� ���� - ������� ������ �� ����
        SingleCategory := FCategoryCache.AddCategory(IdCategory, SingleCategory);
      finally
        if (not CacheAlreadyLocked) then
          FCategoryCache.CategoryNotifier.UnlockWrite;
      end;
    end;

    if SingleRow then begin
      // ������ �� ������
      AStmtData^.Cancelled := TRUE;
    end;
  end;
end;

procedure TMarksSQLDb.CallbackSelectMark(
  const AHandler: PSQLite3DbHandler;
  const ACallbackPtr: Pointer;
  const AStmtData: PSQLite3StmtData
);
var
  VIdMark, VIdCategory: Integer;
  VName, VPicName, VDescript: String;
  VVisible: Boolean;
  VColor1,VColor2,VScale1,VScale2: Integer;
  VFirstPointCount: Integer;
  VPointCoords: TDoublePoint;
begin
  // ������ ����� ���� �����
  // 'm.id_mark,m.id_category,m.o_name,v.m_visible,d.d_text';
  VIdMark     := AStmtData^.ColumnInt(0);
  VIdCategory := AStmtData^.ColumnIntDef(1, 0);
  VName       := AStmtData^.ColumnAsWideString(2);
  VVisible    := (AStmtData^.ColumnIntDef(3,1)=1);
  VDescript   := AStmtData^.ColumnAsWideString(4);

  VColor1 := 0;
  VColor2 := 0;
  VScale1 := 0;
  VScale2 := 0;

  // ���������� ������������� ������� ��������� ��� ������ ����� �����
  PSelectMarksData(ACallbackPtr)^.InitNewMarkPoints;

  case PSelectMarksData(ACallbackPtr)^.MarkType of
    mt_Point: begin
      // ��� ����� �������������
      // ',i.i_name,h.text_color,h.shadow_color,h.font_size,h.icon_size,p.m_lon,p.m_lat';
      VPicName := AStmtData^.ColumnAsWideString(5);

      // ��������� �����������
      VColor1 := AStmtData^.ColumnIntDef(6, 0);
      VColor2 := AStmtData^.ColumnIntDef(7, 0);
      VScale1 := AStmtData^.ColumnIntDef(8, 16);
      VScale2 := AStmtData^.ColumnIntDef(9, 16);

      with VPointCoords do
      case FMarksSQLOptions.CoordStorageModeValue of
        0: begin
          // as DOUBLE
          X := AStmtData^.ColumnDouble(10);
          Y := AStmtData^.ColumnDouble(11);
        end;
        1: begin
          // as INT using default fraction
          X := AStmtData^.ColumnInt(10)/c_COORD_to_INT;
          Y := AStmtData^.ColumnInt(11)/c_COORD_to_INT;
        end;
        else begin
          // as INT using specified fraction
          X := AStmtData^.ColumnInt(10)/FMarksSQLOptions.CoordStorageModeValue;
          Y := AStmtData^.ColumnInt(11)/FMarksSQLOptions.CoordStorageModeValue;
        end;
      end;

      // ��������� ����� � �����
      PSelectMarksData(ACallbackPtr)^.AppendOnePoint(VPointCoords);

      // ����� ��� �����
    end;
    mt_Polyline: begin
      // ��� ��������� ������������� (���� 5-8)
      // ',p.sub_count,y.lonlat_list'+
      // ',h.line_color,h.line_width';

      // ����� ������ ����� (�� ���� �� ���� ������)
      // ��������� ��� � �����
      VFirstPointCount := AStmtData^.ColumnBlobSize(6) div SizeOf(TDoublePoint);
      PSelectMarksData(ACallbackPtr)^.AppendArrayOfPoints(
        AStmtData^.ColumnBlobData(6),
        VFirstPointCount
      );

      // ��������� �����������
      VColor1 := AStmtData^.ColumnIntDef(7, 0);
      //VColor2 := 0;
      VScale1 := AStmtData^.ColumnIntDef(8, 2);
      //VScale2 := 0;

      // ��������� �������� ������� ��� ������������ ��������� ������ ���������
      // ������ ���� ������ ������ ��� 1
      if (AStmtData^.ColumnIntDef(5, 0)>1) then begin
        FSQLite3DbHandler.OpenSQL(
          GetSelectMarkItems('i_polyline', VIdMark),
          CallbackSelectPolyItems,
          ACallbackPtr
        );
      end;
      // ����� ��� ���������
    end;
    mt_Polygon: begin
      // ��� ��������� ������������� (���� 5-9)
      // ',p.sub_count,y.lonlat_list'+
      // ',h.fill_color,j.line_color,j.line_width';

      // ����� ������ ����� (�� ���� �� ���� ������)
      // ��������� ��� � �����
      VFirstPointCount := AStmtData^.ColumnBlobSize(6) div SizeOf(TDoublePoint);
      PSelectMarksData(ACallbackPtr)^.AppendArrayOfPoints(
        AStmtData^.ColumnBlobData(6),
        VFirstPointCount
      );

      // ��������� �����������
      VColor2 := AStmtData^.ColumnIntDef(7, 0);
      VColor1 := AStmtData^.ColumnIntDef(8, 0);
      VScale1 := AStmtData^.ColumnIntDef(9, 2);
      //VScale2 := 0;

      // ��������� �������� ������� ��� ������������ ��������� ������ ���������
      // ������ ���� ������ ������ ��� 1
      if (AStmtData^.ColumnIntDef(5, 0)>1) then begin
        FSQLite3DbHandler.OpenSQL(
          GetSelectMarkItems('m_polyouter', VIdMark),
          CallbackSelectPolyItems,
          ACallbackPtr
        );
      end;
      // ����� ��� ���������
    end;
  end;

  // ���� �������� ��� �����, ��� ��� ������ ����� � �������� ��� �������� �� �����������
  PSelectMarksData(ACallbackPtr)^.SingleMark := FMarkFactoryDbInternal.CreateMark(
    VIdMark,
    VName,
    VVisible,
    VPicName,
    VIdCategory,
    VDescript,
    PSelectMarksData(ACallbackPtr)^.AllPoints,
    PSelectMarksData(ACallbackPtr)^.UsedCount,
    VColor1,
    VColor2,
    VScale1,
    VScale2,
    PSelectMarksData(ACallbackPtr)^.MarkType
  );

  if (PSelectMarksData(ACallbackPtr)^.AllMarksList<>nil) then begin
    // ���������� � ������ - ������ ��������� � ������ ��������� �����
    with PSelectMarksData(ACallbackPtr)^ do begin
      if ConvertToMarkId then begin
        // ��������� MarkId
        AllMarksList.Add(InternalMarkToId(SingleMark));
      end else begin
        // ��������� ���� �����
        AllMarksList.Add(SingleMark);
      end;
    end;
  end else begin
    // ���������� �� � ������ - ������ ���������� ����� ������
    AStmtData^.Cancelled := TRUE;
  end;
end;

procedure TMarksSQLDb.CallbackSelectPolyItems(
  const AHandler: PSQLite3DbHandler;
  const ACallbackPtr: Pointer;
  const AStmtData: PSQLite3StmtData
);
var
(*
  VNPP: Integer;
  VRect: TRect;
*)
  VPointCount: Integer;
  VPointBuffer: Pointer;
begin
  // ������ ������� ������� �������� ��� ����� ���������
  (*
  with AStmtData^ do begin
    VNPP := ColumnInt(0);
    // bounds ��� ������-�� ������ �� ���������� (���� 1-4)
    with VRect do begin
      Left   := ColumnInt(1);
      Bottom := ColumnInt(2);
      Right  := ColumnInt(3);
      Top    := ColumnInt(4);
    end;
  end;
  *)

  // lonlat_type (���� 5) ���� ��� �� ���������� - ���� ��� ��� ������ 0

  // ������ (���� 6) � ������������ - ���� �����
  // ������ ����� �������� � ������
  VPointCount := AStmtData^.ColumnBlobSize(6) div SizeOf(TDoublePoint);
  VPointBuffer := AStmtData^.ColumnBlobData(6);

  // ��������� � ������������ ����� ��, ��� ���������
  PSelectMarksData(ACallbackPtr)^.AppendArrayOfPoints(
    VPointBuffer,
    VPointCount
  );

  // TODO: ���������� ����� ������� ��� ������� ���� ��� � ���� �� �����������
  // ��� ����� - ��� ���� ����� ����������� ���������� ������� ��� �������� ����� (�� NPP)
end;

procedure TMarksSQLDb.CheckCategoryCacheActual(const ACacheAlreadyLocked: Boolean);
begin
  if not FCategoryCache.Actual then begin
    InternalSelectAllCategories(ACacheAlreadyLocked);
  end;
end;

function TMarksSQLDb.CoordToDB(const ACoord: Double): String;
begin
  case FMarksSQLOptions.CoordStorageModeValue of
    0: begin
      // as DOUBLE
      Result := R2StrPoint(ACoord);
    end;
    1: begin
      // as INT using default fraction
      Result := IntToStr(Round(ACoord*c_COORD_to_INT));
    end;
    else begin
      // as INT using specified fraction
      Result := IntToStr(Round(ACoord*FMarksSQLOptions.CoordStorageModeValue));
    end;
  end;
end;

constructor TMarksSQLDb.Create(
  const AStateInternal: IReadWriteStateInternal;
  const ABasePath: IPathConfig;
  const ADBFilename: String;
  const ALanguageManager: ILanguageManager;
  const AMarkPictureList: IMarkPictureList;
  const APerfCounterList: IInternalPerformanceCounterList;
  const AVectorItemsFactory: IVectorItemsFactory;
  const AHintConverter: IHtmlToHintTextConverter;
  const ACategoryFactoryConfig: IMarkCategoryFactoryConfig
);
var
  VMarkFactory: TMarkFactory;
  VCategoryFactory: TMarkCategoryFactory;
  VDBFilename: WideString;
begin
  inherited Create;
  FBasePath := ABasePath;
  FLanguageManager := ALanguageManager;
  FMarkPictureList := AMarkPictureList;
  FStateInternal := AStateInternal;
  FPerfCounterList := APerfCounterList;
  FCategoryFactoryConfig := ACategoryFactoryConfig;

  FCategoryCache := TMarkCategoryList.Create;

  MakePerfCounters;

  FMarksSQLOptions.Clear;
  FCachePolygonShowId.Init;
  FCachePolylineShowIdLine.Init;
  FCachePolylineShowIdPoly.Init;
  FCachePointShowId.Init;
  FCachePointImageId.Init;

  if FSQLite3DbHandler.Init then begin
    // ������������������ - ��������� ��
    try
      VDBFilename :=  IncludeTrailingPathDelimiter(ABasePath.FullPath) + ADBFilename;
      FSQLite3DbHandler.OpenW(VDBFilename);
      SetSessionParams;
      // ����� �������� ��������� ��������� ��, ���� ���� - ���������
      if InternalCheckStructure then begin
        // OK
        InternalReadOptions;
      end else begin
        // ����������
        AStateInternal.ReadAccess  := asDisabled;
        AStateInternal.WriteAccess := asDisabled;
      end;
    except on E: Exception do begin
      // ����������
      AStateInternal.ReadAccess  := asDisabled;
      AStateInternal.WriteAccess := asDisabled;
      if Assigned(ApplicationShowException) then
        ApplicationShowException(E);
    end;
    end;
  end else begin
    // ����������
    AStateInternal.ReadAccess  := asDisabled;
    AStateInternal.WriteAccess := asDisabled;
  end;

  VCategoryFactory := TMarkCategoryFactory.Create(ACategoryFactoryConfig);
  FCategoryFactoryDbInternal := VCategoryFactory;
  FCategoryFactory := VCategoryFactory;  

  FMarksFactoryConfig := TMarksFactoryConfig.Create(
    FLanguageManager,
    Self,
    FMarkPictureList
  );
      
  VMarkFactory := TMarkFactory.Create(
      FMarksFactoryConfig,
      AVectorItemsFactory,
      AHintConverter,
      Self
    );
  FMarkFactory := VMarkFactory;
  FMarkFactoryDbInternal := VMarkFactory;
  
  // FMarksList := TIDInterfaceList.Create;
  // FByCategoryList := TIDInterfaceList.Create;
  // FNeedSaveFlag := TSimpleFlagWithInterlock.Create;
  // FLoadDbCounter := FPerfCounterList.CreateAndAddNewCounter('LoadDb');
  // FSaveDbCounter := FPerfCounterList.CreateAndAddNewCounter('SaveDb');
end;

destructor TMarksSQLDb.Destroy;
begin
  FMarkFactory := nil;
  FMarkFactoryDbInternal := nil;
  FCategoryFactory := nil;
  FCategoryFactoryDbInternal := nil;
  FMarksFactoryConfig := nil;
  FCategoryFactoryConfig := nil;

  FreeAndNil(FCategoryCache);

  FSQLite3DbHandler.Close;

  KillPerfCounters;

  FPerfCounterList := nil;
  FStateInternal := nil;
  FMarkPictureList := nil;
  FLanguageManager := nil;
  FBasePath := nil;

  inherited;
end;

function TMarksSQLDb._UpdateMark(const AOldMark, ANewMark: IInterface): IMark;
begin
  if (nil=ANewMark) then begin
    // ������� ������ �����
    InternalDeleteMark(AOldMark);
    Result := nil;
  end else if (nil=AOldMark) then begin
    // ��������� ����� ����� (� ���������� �)
    Result := InternalInsertMark(ANewMark, FALSE);
  end else begin
    // ��������� ������������ ����� (� ���������� �����)
    Result := InternalUpdateMark(AOldMark, ANewMark);
  end;
end;

procedure TMarksSQLDb.UnlockWrite;
begin
  if ExceptObject<>nil then
    FSQLite3DbHandler.Rollback
  else
    FSQLite3DbHandler.Commit;
  inherited UnlockWrite;
end;

function TMarksSQLDb.UpdateCategory(const AOldCategory, ANewCategory: IMarkCategory): IMarkCategory;
begin
  Assert((AOldCategory <> nil) or (ANewCategory <> nil));

  // ��������� ��� �� �� �����
  FCategoryCache.CategoryNotifier.LockWrite;
  try
    // ������������� ���
    CheckCategoryCacheActual(TRUE);
    // ������� ���� ���������
    if (nil=AOldCategory) then begin
      // ��������� ����� ��������� (� �� � � ���)
      try
        InternalInsertCategory(ANewCategory);
      except
        // ���������� - ������ ����� ��-�� �������������� �����
        // ���-�� ����������� ����� ���������� ���� ������
      end;
      // ������� �� �� � ������� � ��� (SetChanged ����� ������)
      // ���� �� �����, ��� ��� ��� ���������� ��� �������, ��� �� �� ��������
      Result := InternalSelectCategoryByName(TRUE, ANewCategory.Name);
    end else if (nil=ANewCategory) then begin
      // ������� ������������ ��������� �� �� � �� ����
      InternalDeleteCategory(AOldCategory);
      Result := nil;
    end else begin
      // �������� ���������
      if AOldCategory.IsEqual(ANewCategory) then begin
        // ��� ���������
        Result := AOldCategory;
        Exit;
      end;
    
      if AOldCategory.IsSame(ANewCategory) then begin
        // ��������� ���������
        Result := InternalUpdateCategory(AOldCategory, ANewCategory);
      end else begin
        // ������� ������ � ������ �����
        InternalDeleteCategory(AOldCategory);
        try
          // ��������� � ��
          InternalInsertCategory(ANewCategory);
        except
          // ���������� - ������ ����� ��-�� �������������� �����
          // ���-�� ����������� ����� ���������� ���� ������
        end;
        // ������ � ���
        Result := InternalSelectCategoryByName(TRUE, ANewCategory.Name);
      end;
    end;
  finally
    FCategoryCache.CategoryNotifier.UnlockWrite;
  end;
end;

function TMarksSQLDb.UpdateMark(
  const AOldMark: IInterface;
  const ANewMark: IMark
): IMark;
var
  VCounterContext: TInternalPerformanceCounterContext;
begin
  Assert((AOldMark <> nil) or (ANewMark <> nil));
  VCounterContext := FUpdateMarkCounter.StartOperation;
  try
    LockWrite;
    try
      Result := _UpdateMark(AOldMark, ANewMark);
    finally
      UnlockWrite;
    end;
  finally
    FUpdateMarkCounter.FinishOperation(VCounterContext);
  end;
end;

function TMarksSQLDb.UpdateMarksList(
  const AOldMarkList, ANewMarkList: IInterfaceList
): IInterfaceList;
var
  i: Integer;
  VNew: IInterface;
  VOld: IInterface;
  VResult: IMark;
  VMinCount: Integer;
  VMaxCount: Integer;
  VCounterContext: TInternalPerformanceCounterContext;
begin
  VCounterContext := FUpdateMarksListCounter.StartOperation;
  try
  Result := nil;
  if ANewMarkList <> nil then begin
    // ���� ����� ������
    Result := TInterfaceList.Create;
    Result.Capacity := ANewMarkList.Count;

    LockWrite;
    try
      if (AOldMarkList <> nil) then begin
        if AOldMarkList.Count < ANewMarkList.Count then begin
          VMinCount := AOldMarkList.Count;
          VMaxCount := ANewMarkList.Count;
        end else begin
          VMinCount := ANewMarkList.Count;
          VMaxCount := AOldMarkList.Count;
        end;
      end else begin
        VMinCount := 0;
        VMaxCount := ANewMarkList.Count;
      end;
      for i := 0 to VMinCount - 1 do begin
        // ����� ��� ����� ������� ����� - ���������
        VOld := AOldMarkList[i];
        VNew := ANewMarkList[i];
        VResult := _UpdateMark(VOld, VNew);
        Result.Add(VResult);
      end;
      for i := VMinCount to VMaxCount - 1 do begin
        VOld := nil;
        if (AOldMarkList <> nil) and (i < AOldMarkList.Count) then begin
          VOld := AOldMarkList[i];
        end;
        VNew := nil;
        if (i < ANewMarkList.Count) then begin
          VNew := ANewMarkList[i];
        end;
        VResult := _UpdateMark(VOld, VNew);
        if i < Result.Capacity then begin
          Result.Add(VResult);
        end;
      end;
    finally
      UnlockWrite;
    end;
    //SaveMarks2File;
  end else begin
    // ������ ������ ��� - ������ ������� �����
    LockWrite;
    try
      for i := 0 to AOldMarkList.Count - 1 do begin
        InternalDeleteMark(AOldMarkList[i]);
      end;
    finally
      UnlockWrite;
    end;
    //SaveMarks2File;
  end;
  finally
    FUpdateMarksListCounter.FinishOperation(VCounterContext);
  end;
end;

function TMarksSQLDb.GetMarkByID(const AMarkId: IMarkId): IMark;
var
  VMarkSMLInternal: IMarkSMLInternal;
begin
  if AMarkId <> nil then begin
    // ����� ���� ����� ��������
    if Supports(AMarkId, IMark, Result) then
      Exit;
    if Supports(AMarkId, IMarkSMLInternal, VMarkSMLInternal) then begin
      // ������ ����� � ������ �
      LockRead;
      try
        Result := InternalReadMark(VMarkSMLInternal.Id);
      finally
        UnlockRead;
      end;
    end else begin
      Result := nil;
    end;
  end else begin
    Result := nil;
  end;
end;

function TMarksSQLDb.GetMarkVisible(const AMark: IMark): Boolean;
var
  VMarkVisible: IMarkSMLInternal;
begin
  Result := True;
  if AMark <> nil then begin
    if Supports(AMark, IMarkSMLInternal, VMarkVisible) then begin
      Result := VMarkVisible.Visible;
    end;
  end;
end;

function TMarksSQLDb.GetMarkVisible(const AMark: IMarkId): Boolean;
var
  VMarkInternal: IMarkSMLInternal;
begin
  Result := True;
  if AMark <> nil then begin
    if Supports(AMark, IMarkSMLInternal, VMarkInternal) then begin
      Result := VMarkInternal.Visible;
    end;
  end;
end;

function TMarksSQLDb.SelectIdUserByName(const AName: WideString): Integer;
begin
  Result := 0;
  FSQLite3DbHandler.OpenSQLWithTEXTW(
    'SELECT id_user FROM g_user WHERE u_name=?',
    CallbackReadSingleId,
    @Result,
    FALSE,
    TRUE,
    PWideChar(AName),
    Length(AName)
  );
end;

procedure TMarksSQLDb.SetAllCategoriesVisible(ANewVisible: Boolean);
var
  VVisibleStr: String;
begin
  // ���������� ��� ������������� ��������� ��� ���� ���������
  VVisibleStr := VisibleToSQL(ANewVisible);

  // ����������� �� ��
  with FSQLite3DbHandler do begin
    // ���������� ������������ �������
    ExecSQL(
      'UPDATE v_category SET v_visible='+VVisibleStr+
      ' WHERE id_user='+FMarksSQLOptions.IdUserStr+
        ' AND coalesce(v_visible,'+VisibleToSQL(TRUE)+')<>'+VVisibleStr
    );
    if (not ANewVisible) then begin
      // �������� ����� ������� - ������ ��� ���������� ���������
      ExecSQL(
        'INSERT INTO v_category (id_user,id_category,v_visible)'+
       ' SELECT '+FMarksSQLOptions.IdUserStr+',g.id_category,'+VVisibleStr+
         ' FROM g_category g'+
        ' WHERE not exists(SELECT 1 FROM v_category x'+
                          ' WHERE x.id_user='+FMarksSQLOptions.IdUserStr+
                            ' AND x.id_category=g.id_category)'
      );
    end;
  end;

  if FCategoryCache.Actual then begin
    // ��������� ������������� ��� ��������� ���������
    // � ���������� ���� ����������� ������
    FCategoryCache.SetAllCategoriesVisible(FCategoryFactoryDbInternal, ANewVisible);
  end else begin
    // ��� �� �������� - ������ ������������ �� �� ��
    // CheckCategoryCacheActual(FALSE);
    InternalSelectAllCategories(FALSE);
  end;
end;

procedure TMarksSQLDb.SetAllMarksInCategoryVisible(
  const ACategory: ICategory;
  ANewVisible: Boolean
);
var
  VIdCategoryStr, VVisibleStr: AnsiString;
  VCounterContext: TInternalPerformanceCounterContext;
begin
  VCounterContext := FSetMarksInCategoryVisibleCounter.StartOperation;
  try
    VIdCategoryStr := IntToStr(GetCategoryID(ACategory));
    VVisibleStr    := VisibleToSQL(ANewVisible);

    LockWrite;
    try
      // ������������� ��������� ���� ������ � ���������
      FSQLite3DbHandler.ExecSQL(
        'INSERT OR REPLACE INTO v_mark (id_user,id_mark,m_visible)'+
       ' SELECT '+FMarksSQLOptions.IdUserStr+',m.id_mark,'+VVisibleStr+
         ' FROM m_mark m'+
        ' WHERE m.id_category='+VIdCategoryStr
      );
      SetChanged;
    finally
      UnlockWrite;
    end;
  finally
    FSetMarksInCategoryVisibleCounter.FinishOperation(VCounterContext);
  end;
end;

procedure TMarksSQLDb.SetMarkVisibleByID(
  const AMark: IMarkId;
  AVisible: Boolean
);
var
  VMarkInternal: IMarkSMLInternal;
begin
  if (nil=AMark) then
    Exit;
  if not Supports(AMark, IMarkSMLInternal, VMarkInternal) then
    Exit;
  
  LockWrite;
  try
    InternalSetMarksVisible('('+IntToStr(VMarkInternal.Id)+')', @AVisible);
    SetChanged;
  finally
    UnlockWrite;
  end;
end;

procedure TMarksSQLDb.SetMarkVisibleByIDList(
  const AMarkList: IInterfaceList;
  AVisible: Boolean
);
begin
  LockWrite;
  try
    InternalSetMarkVisibleByIDList(AMarkList, @AVisible);
    SetChanged;
  finally
    UnlockWrite;
  end;
end;

procedure TMarksSQLDb.SetSessionParams;
begin
  // ������������� ��������� ������
  FSQLite3DbHandler.ExecSQL('PRAGMA cache_size=100000'); // 2000 pages by default
  FSQLite3DbHandler.ExecSQL('PRAGMA recursive_triggers=ON'); // OFF by default
  FSQLite3DbHandler.ExecSQL('PRAGMA foreign_keys=ON'); // OFF by default
  FSQLite3DbHandler.ExecSQL('PRAGMA main.journal_mode=WAL'); // DELETE by default // WAL // PERSIST
  FSQLite3DbHandler.ExecSQL('PRAGMA synchronous=NORMAL'); // FULL by default
end;

procedure TMarksSQLDb.ToggleMarkVisibleByIDList(const AMarkList: IInterfaceList);
begin
  LockWrite;
  try
    InternalSetMarkVisibleByIDList(AMarkList, nil);
    SetChanged;
  finally
    UnlockWrite;
  end;
end;

function TMarksSQLDb.GetAllMarksIdList: IInterfaceList;
var
  VCounterContext: TInternalPerformanceCounterContext;
begin
  VCounterContext := FSelectAllMarksCounter.StartOperation;
  try
    Result := TInterfaceList.Create;
    LockRead;
    try
      InternalSelectMarksToList(Result, nil, '', nil, TRUE, TRUE);
    finally
      UnlockRead;
    end;
  finally
    FSelectAllMarksCounter.FinishOperation(VCounterContext);
  end;
end;

function TMarksSQLDb.GetById(AId: Integer): IMarkSMLInternal;
var
  VMark: IMark;
begin
  LockRead;
  try
    VMark := InternalReadMark(AId);
  finally
    UnlockRead;
  end;

  if (VMark<>nil) then
    Supports(VMark, IMarkSMLInternal, Result)
  else
    Result := nil;
end;

function TMarksSQLDb.GetCategoriesList: IInterfaceList;
begin
  // ������������ � TfrmMarksExplorer ��� ������ (UpdateCategoryTree) � �������� (btnExportClick)
  // ������������ � TfrMarkCategorySelectOrAdd.Init ��� ������ ���������
  // ������������ � TMarksSystem ��� GetVisibleCategories � GetVisibleCategoriesIgnoreZoom
  // �� � ��� ������������ ��� �������� �� ������ �� ����� � ����� �� �����

  // ������� ������ ������
  Result := TInterfaceList.Create;
  // ��������� ������������
  CheckCategoryCacheActual(FALSE);
  // �������� �� ����
  with FCategoryCache do begin
    CategoryNotifier.LockRead;
    try
      CopyToList(Result);
    finally
      CategoryNotifier.UnlockRead;
    end;
  end;
end;

function TMarksSQLDb.GetCategoryByID(id: integer): IMarkCategory;
begin
  // ������ �� TMarkFactory ��� reatePoint, CreateLine, CreatePoly
  // � �� TMarkTemplateBase.GetCategory (�� TfrmMarksExplorer.btnEditMarkClick)

  // ��������� ������������
  CheckCategoryCacheActual(FALSE);

  // ����� ��������� �� ����
  with FCategoryCache do begin
    CategoryNotifier.LockRead;
    try
      Result := GetCategoryByID(id);
      // ����� - �����
      if (Result<>nil) then
        Exit;
    finally
      CategoryNotifier.UnlockRead;
    end;
  end;

  // ���� � ��� - ����� �� �� � ����� �� ������ ��� � ���
  Result := InternalSelectCategoryByID(FALSE, id);
end;

function TMarksSQLDb.GetCategoryByName(const AName: string): IMarkCategory;
begin
  // ������ �� TfrMarkCategorySelectOrAdd.GetCategory ������ ����
  // ��� �������� ������������� ��������� ����� ��������

  CheckCategoryCacheActual(FALSE);

  with FCategoryCache do begin
    CategoryNotifier.LockRead;
    try
      Result := GetCategoryByName(AName);
      // ������� � ����
      if (Result<>nil) then
        Exit;
    finally
      CategoryNotifier.UnlockRead;
    end;
  end;

  // ��� ���� ��������� �� ������� � ����
  // � ��� �� ������� ����������
  // ��������� ������������� � ���� - �������� ��������� �� ����� � ��
  // ���� ��������� ���� - ����� � ������� � ��� � �����
  Result := InternalSelectCategoryByName(FALSE, AName);
end;

function TMarksSQLDb.GetCategoryID(const ACategory: ICategory): Integer;
var
  VCategoryInternal: IMarkCategorySMLInternal;
begin
  Assert(ACategory <> nil);
  Result := CNotExistCategoryID;
  if Supports(ACategory, IMarkCategorySMLInternal, VCategoryInternal) then begin
    Result := VCategoryInternal.Id;
  end;
end;

function TMarksSQLDb.GetCategorySQLText: AnsiString;
begin
  Result := 'SELECT g.id_category,v.min_zoom,v.max_zoom,v.v_visible,g.c_name'+
             ' FROM g_category g LEFT OUTER JOIN v_category v ON v.id_user='+FMarksSQLOptions.IdUserStr+
                                                           ' AND g.id_category=v.id_category';
end;

function TMarksSQLDb.GetCurrentUserId(const ACreateIfNotExists: Boolean): Integer;
var
  VUserName: WideString;
begin
  VUserName := GetCurrentUserUniqueName;

  Result := 0;
  if (0=Length(VUserName)) then
    Exit;

  // ������ id_user
  Result := SelectIdUserByName(VUserName);

  // ���� ����������� - �����
  if (Result<>0) then
    Exit;

  // ���� �� ��������� ������� ������ - �����
  if not ACreateIfNotExists then
    Exit;

  // ������ ������
  FSQLite3DbHandler.ExecSQLWithTEXTW(
    'INSERT OR IGNORE INTO g_user (u_name) VALUES (?)',
    TRUE,
    PWideChar(VUserName),
    Length(VUserName)
  );
  
  // ������
  Result := SelectIdUserByName(VUserName);
end;

function TMarksSQLDb.GetCurrentUserUniqueName: WideString;
type
  USHORT = Word;
  PWSTR = PWideChar;
  PUNICODE_STRING = ^UNICODE_STRING;
  UNICODE_STRING = packed record
    Length_: USHORT; // in bytes
    MaximumLength: USHORT; // in bytes
    Buffer: PWSTR;
  end;
  TRtlFormatCurrentUserKeyPath = function(
    Path: PUNICODE_STRING
  ): Integer; stdcall; // external 'ntdll.dll'; // documented!
  TRtlFreeUnicodeString = procedure(
    UnicodeString: PUNICODE_STRING
  ); stdcall; // external 'ntdll.dll'; // documented!
var
  VFunc: Pointer;
  VResult: Integer;
  VRegName: UNICODE_STRING;
begin
  Result := '';

  VFunc := GetProcAddress(GetModuleHandle('ntdll.dll'), 'RtlFormatCurrentUserKeyPath');
  if (nil=VFunc) then
    Exit;

  FillChar(VRegName, SizeOf(VRegName), 0);
  if (0=TRtlFormatCurrentUserKeyPath(VFunc)(@VRegName)) then
  try
    SetString(Result, VRegName.Buffer, VRegName.Length_ div 2);
    while (0<Length(Result)) do begin
      VResult := Pos('\',Result);
      if (VResult>0) then
        System.Delete(Result, 1, VResult)
      else
        break;
    end;
    // ��������� '\REGISTRY\USER\S-1-5-21-542808039-2109243029-4146833331-1012'
    // ��������� 'S-1-5-21-542808039-2109243029-4146833331-1012'
  finally
    VFunc := GetProcAddress(GetModuleHandle('ntdll.dll'), 'RtlFreeUnicodeString');
    TRtlFreeUnicodeString(VFunc)(@VRegName);
  end;
end;

function TMarksSQLDb.GetMarksIdListByCategory(const ACategory: ICategory): IInterfaceList;
var
  VIdCategory: Integer;
  VCounterContext: TInternalPerformanceCounterContext;
begin
  VCounterContext := FSelectMarksByCategoryCounter.StartOperation;
  try
    Result := TInterfaceList.Create;
    VIdCategory := GetCategoryID(ACategory);
    InternalSelectMarksToList(Result, @VIdCategory, '', nil, TRUE, TRUE);
  finally
    FSelectMarksByCategoryCounter.FinishOperation(VCounterContext);
  end;
end;

function TMarksSQLDb.GetPointShowId(const AMarkPoint: IMarkPoint): Integer;
var
  VIdShowData4: TIdShowData4;
  VTextColorStr, VTextBgColorStr, VFontSizeStr, VMarkerSizeStr: AnsiString;
  VCounterContext: TInternalPerformanceCounterContext;
begin
  VCounterContext := FLookupPointShowCounter.StartOperation;
  try
    with AMarkPoint do begin
      VIdShowData4[0] := TextColor;
      VIdShowData4[1] := TextBgColor;
      VIdShowData4[2] := FontSize;
      VIdShowData4[3] := MarkerSize;
    end;

    // ��������� ���
    if FCachePointShowId.GetInCache(@VIdShowData4, Result) then
      Exit;

    VTextColorStr   := IntToStr(VIdShowData4[0]);
    VTextBgColorStr := IntToStr(VIdShowData4[1]);
    VFontSizeStr    := IntToStr(VIdShowData4[2]);
    VMarkerSizeStr  := IntToStr(VIdShowData4[3]);

    Result := InternalGetShowId(
      'SELECT id_show_pt FROM g_show_pt WHERE text_color='+VTextColorStr+
        ' AND shadow_color='+VTextBgColorStr+
        ' AND font_size='+VFontSizeStr+
        ' AND icon_size='+VMarkerSizeStr,

      'INSERT INTO g_show_pt (text_color,shadow_color,font_size,icon_size) VALUES ('+
          VTextColorStr+','+VTextBgColorStr+','+VFontSizeStr+','+VMarkerSizeStr+')'
    );

    FCachePointShowId.SetInCache(@VIdShowData4, Result);
  finally
    FLookupPointShowCounter.FinishOperation(VCounterContext);
  end;
end;

function TMarksSQLDb.GetPolygonShowId(const AMarkPoly: IMarkPoly; out AIdShowPL: Integer): Integer;
var
  VIdShowData2: TIdShowData2;
  VFillColorStr: AnsiString;
  VCounterContext: TInternalPerformanceCounterContext;
begin
  VCounterContext := FLookupPolygonShowCounter.StartOperation;
  try
    // ����������� ��� ������� ��� ���������� ����� - ������ � 1 �����
    VIdShowData2[0] := AMarkPoly.FillColor;
    // id_show_pg
    if not FCachePolygonShowId.GetInCache(VIdShowData2[0], Result) then begin
      VFillColorStr := IntToStr(VIdShowData2[0]);
      Result := InternalGetShowId(
        'SELECT id_show_pg FROM g_show_pg WHERE fill_color='+VFillColorStr,
        'INSERT INTO g_show_pg (fill_color) VALUES ('+VFillColorStr+')'
      );
      FCachePolygonShowId.SetInCache(VIdShowData2[0], Result);
    end;
    // id_show_pl
    VIdShowData2[0] := AMarkPoly.BorderColor;
    VIdShowData2[1] := AMarkPoly.LineWidth;
    if not FCachePolylineShowIdPoly.GetInCache(@VIdShowData2, AIdShowPL) then begin
      AIdShowPL := GetPolylineShowIdInternal(@VIdShowData2);
      FCachePolylineShowIdPoly.SetInCache(@VIdShowData2, AIdShowPL);
    end;
  finally
    FLookupPolygonShowCounter.FinishOperation(VCounterContext);
  end;
end;

function TMarksSQLDb.GetPolylineShowId(const AMarkLine: IMarkLine): Integer;
var
  VIdShowData2: TIdShowData2;
  VCounterContext: TInternalPerformanceCounterContext;
begin
  VCounterContext := FLookupPolylineShowCounter.StartOperation;
  try
    VIdShowData2[0] := AMarkLine.LineColor;
    VIdShowData2[1] := AMarkLine.LineWidth;
    if FCachePolylineShowIdLine.GetInCache(@VIdShowData2, Result) then
      Exit;
    Result := GetPolylineShowIdInternal(@VIdShowData2);
    FCachePolylineShowIdLine.SetInCache(@VIdShowData2, Result);
  finally
    FLookupPolylineShowCounter.FinishOperation(VCounterContext);
  end;
end;

function TMarksSQLDb.GetPolylineShowIdInternal(const AIdShowData2: PIdShowData2): Integer;
var
  VLineColor, VLineWidth: AnsiString;
begin
  VLineColor := IntToStr(AIdShowData2^[0]);
  VLineWidth := IntToStr(AIdShowData2^[1]);
  Result := InternalGetShowId(
    'SELECT id_show_pl FROM g_show_pl WHERE line_color='+VLineColor+' AND line_width='+VLineWidth,
    'INSERT INTO g_show_pl (line_color,line_width) VALUES ('+VLineColor+','+VLineWidth+')'
  );
end;

function TMarksSQLDb.GetSelectMarkItems(const AItemsTable: AnsiString; const AIdMark: Integer): AnsiString;
begin
  Result := 'SELECT npp,min_lon,min_lat,max_lon,max_lat,lonlat_type,lonlat_list'+
             ' FROM '+AItemsTable+
            ' WHERE id_mark='+IntToStr(AIdMark)+
              ' AND npp>=1'+
            ' ORDER BY npp';
end;

function TMarksSQLDb.IMarkCategoryDB_GetChangeNotifier: INotifier;
begin
  Result := FCategoryCache.CategoryNotifier.ChangeNotifier;
end;

function TMarksSQLDb.IMarkCategoryDB_GetFactory: IMarkCategoryFactory;
begin
  Result := FCategoryFactory;
end;

function TMarksSQLDb.IMarksDb_GetFactory: IMarkFactory;
begin
  Result := FMarkFactory;
end;

function TMarksSQLDb.ImportCategoriesList(const ACategoriesList: IInterfaceList): IInterfaceList;
var
  i: Integer;
  VImportingCategory: IMarkCategory;
  VExistingCategory: IMarkCategory;
begin
  Result := nil;
  if ACategoriesList <> nil then begin
    Result := TInterfaceList.Create;
    if ACategoriesList.Count>0 then begin
      Result.Capacity := ACategoriesList.Count;
      // ��������� ��� �� �� �����
      FCategoryCache.CategoryNotifier.LockWrite;
      try
        // ��� ���� ����������
        CheckCategoryCacheActual(TRUE);

        // ��������� ������������ �� �����, ��� ��� �� ID ����� (���� ������ ����)
        // ���� ��������� ��� ���� - ������������ ������� �� ���������
        for i := 0 to ACategoriesList.Count - 1 do
        if Supports(ACategoriesList[i], IMarkCategory, VImportingCategory) then begin
          // ������� ���� �� ��������� � ����� ������ � ����
          VExistingCategory := FCategoryCache.GetCategoryByName(VImportingCategory.Name);
          // ���� ����
          if (VExistingCategory<>nil) then begin
            // � � ����� (��� �� ��������)
            Result.Add(VExistingCategory);
          end else begin
            // � ���� ����� ��� - ������� �������
            try
              InternalInsertCategory(VImportingCategory);
            except
              // �� ����� ����������:
              // �) ���� ���-�� ����������� ������� ���������;
              // �) ���� ��� ��� ������������, � �� �� ���� �� �����
              // �) ������ ��������� ������
              // VIdCategory := CNotExistCategoryID;
            end;

            // ������ �� �� � ������� � ��� (SetChanged ����� ������)
            VExistingCategory := InternalSelectCategoryByName(TRUE, VImportingCategory.Name);
            if (VExistingCategory<>nil) then begin
              Result.Add(VExistingCategory);
            end;
          end;
        end;
      finally
        FCategoryCache.CategoryNotifier.UnlockWrite;
      end;
    end;
  end;
end;

function TMarksSQLDb.ImportMarksList(
  const ANewMarkList: IInterfaceList;
  const AMarksImportOptions: TMarksImportOptions
): IInterfaceList;
var
  i: Integer;
  VMark: IMark;
  VCounterContext: TInternalPerformanceCounterContext;
begin
  VCounterContext := FImportMarksCounter.StartOperation;
  try
    Result := nil;
    if ANewMarkList <> nil then begin
      Result := TInterfaceList.Create;
      Result.Capacity := ANewMarkList.Count;
      LockWrite;
      try
        for i := 0 to ANewMarkList.Count - 1 do begin
          VMark := InternalInsertMark(ANewMarkList[i], TRUE, AMarksImportOptions);
          Result.Add(VMark);
        end;
        //SetChanged;
      finally
        UnlockWrite;
      end;
    end;
  finally
    FImportMarksCounter.FinishOperation(VCounterContext);
  end;
end;

function TMarksSQLDb.InternalCheckStructure: Boolean;
begin
  // ������ ������
  InternalReadVersion;

  if FMarksSQLOptions.ActualVersion then begin
    // �� � ������� �� ����������
    Result := TRUE;
    Exit;
  end;

  with FMarksSQLOptions do
  if (c_Current_Version < IdVersion) then begin
    // ������ EXE-�� ����� ������, ��� ������ ��
    raise EMarksSQLiteError.CreateFmt(SAS_ERR_MarksSQLite_OldExeVersion, [IdVersion]);
    //Result := FALSE;
    //Exit;
  end;

  // ���� ��������� ������ ��������� ��

  // ��� �������� ������, ���� � �.�. ��� �����
  FSQLite3DbHandler.SetExclusiveLockingMode;
  try
    // ��������� ������ �����������
    while (not FMarksSQLOptions.ActualVersion) do begin
      if not InternalIncrementVersion then begin
        Result := FALSE;
        Exit;
      end;
    end;
    Result := TRUE;
  finally
    FSQLite3DbHandler.SetNormalLockingMode;
  end;
end;

procedure TMarksSQLDb.InternalDeleteCategory(const AOldCategory: IMarkCategory);
var
  VCategoryInternal: IMarkCategorySMLInternal;
  VIdCategory: Integer;
  VCategoryName: String;
  VWideParam: WideString;
begin
  VCategoryName := AOldCategory.Name;
  if Supports(AOldCategory, IMarkCategorySMLInternal, VCategoryInternal) then begin
    // ����� ������� �� id
    VIdCategory := VCategoryInternal.Id;
    FSQLite3DbHandler.ExecSQL('DELETE FROM g_category WHERE id_category='+IntToStr(VIdCategory));
    FCategoryCache.DeleteCategory(VIdCategory, VCategoryName);
  end else begin
    // ������� �� �����
    VWideParam := VCategoryName;
    FSQLite3DbHandler.ExecSQLWithTEXTW(
      'DELETE FROM g_category WHERE c_name=?',
      TRUE,
      PWideChar(VWideParam),
      Length(VWideParam)
    );
    FCategoryCache.DeleteCategory(CNotExistCategoryID, VCategoryName);
  end;
end;

procedure TMarksSQLDb.InternalDeleteMark(const AOldMark: IInterface);
var
  VMarkInternal: IMarkSMLInternal;
begin
  if Supports(AOldMark, IMarkSMLInternal, VMarkInternal) then begin
    FSQLite3DbHandler.ExecSQL(
      'DELETE FROM m_mark WHERE id_mark='+IntToStr(VMarkInternal.Id)
    );
    SetChanged;
  end;
end;

procedure TMarksSQLDb.InternalDeleteMarkSubExceptMarkType(const AMarkType: TMarkType; const AWhere: AnsiString);
var
  i: TMarkType;
  s: AnsiString;
begin
  for i := Low(i) to High(i) do
  if (i<>AMarkType) then begin
    s := c_MarkTypeTBL[i];
    if (0<Length(s)) then begin
      FSQLite3DbHandler.ExecSQL('DELETE FROM '+s+' WHERE '+AWhere);
    end;
  end;
end;

function TMarksSQLDb.InternalGetShowId(
  const ASelectSQL, AInsertSQL: AnsiString;
  const AWithStringOptional: Boolean;
  const AWideStrOptional: PWideChar;
  const AWideStrLength: Integer
): Integer;
var VStep: Byte;
begin
  VStep := 0;
  repeat
    Result := 0;
    
    // ���� id
    FSQLite3DbHandler.OpenSQLWithTEXTW(
      ASelectSQL,
      CallbackReadSingleId,
      @Result,
      TRUE,
      AWithStringOptional,
      AWideStrOptional,
      AWideStrLength
    );

    if (Result <> 0) then begin
      // ��� ����
      Exit;
    end;

    // �� ��� ���� - ������� (�������� ��������� ����������� - ������� ������)
    try
      FSQLite3DbHandler.ExecSQLWithTEXTW(
        AInsertSQL,
        AWithStringOptional,
        AWideStrOptional,
        AWideStrLength
      );
    except
    end;

    if (0<>VStep) then begin
      // ���������� - ��� ����������
      Result := 0;
      Exit;
    end;

    Inc(VStep);
  until FALSE;
end;

function TMarksSQLDb.InternalImportCategoryByMark(const ANewMark: IMark): Integer;
var
  VCategoryName: String;
  VMarkCategory: IMarkCategory;
begin
  // ��������� ��� �� �� �����
  FCategoryCache.CategoryNotifier.LockWrite;
  try
    // ������������� ���
    CheckCategoryCacheActual(TRUE);

    // ���� ��������� �� �����
    VCategoryName := ANewMark.Category.Name;
    Result := FCategoryCache.GetCategoryIdByName(VCategoryName);

    // ���� ������� - �����
    if (Result<>CNotExistCategoryID) then
      Exit;

    // ��������� �� ������� - ������� �������
    if not Supports(ANewMark.Category, IMarkCategory, VMarkCategory) then
      Exit;

    // ��������� � ��
    try
      InternalInsertCategory(VMarkCategory);
    except
      // �������� ���������� ��-�� �������������� �����
    end;

    // ������ �� �� (� ����� �������� � ���)
    VMarkCategory := InternalSelectCategoryByName(TRUE, VCategoryName);

    Result := GetCategoryID(VMarkCategory);
  finally
    FCategoryCache.CategoryNotifier.UnlockWrite;
  end;
end;

function TMarksSQLDb.InternalIncrementVersion: Boolean;
var
  VScriptFileName: String;
  VSQLScriptParser: TSQLScriptParser;
  VErrors: TStringList;
begin
  // �������������� ������ �� ������� �� ���������
  VScriptFileName := IncludeTrailingPathDelimiter(FBasePath.FullPath) +
                     'Marks.SLT.' +
                     // ������ � ����� - ��� ��������� ��������� ���������� ����� ��������� ������
                     IntToStr(FMarksSQLOptions.IdVersion) + '.' + IntToStr(FMarksSQLOptions.IdVersion+1) +
                     '.sql';

  Result := FileExists(VScriptFileName);

  if (not Result) then
    raise EMarksSQLiteError.CreateFmt(SAS_ERR_MarksSQLite_ScriptNotFound,
      [FMarksSQLOptions.IdVersion, VScriptFileName]);

  // �������� ������ �������
  VErrors := nil;
  VSQLScriptParser:=TSQLScriptParser.Create;
  try
    // ���������
    VSQLScriptParser.LoadFromFile(VScriptFileName);
    // ������ � ���������
    VErrors := TStringList.Create;
    VSQLScriptParser.ParseSQL(ParserFoundProc_SQL, VErrors);
  finally
    VSQLScriptParser.Free;

    // ��������� ������
    if (VErrors<>nil) then begin
      if VErrors.Count>0 then begin
        VErrors.SaveToFile(VScriptFileName+'.out');
      end;
      VErrors.Free;
    end;

    // ������ ������
    InternalReadVersion;
  end;
end;

procedure TMarksSQLDb.InternalInsertCategory(const ANewCategory: IMarkCategory);
var
  VSQLText, VFieldEx: String;
  VWideParam: WideString;
  VNewId, VScale: Integer;
begin
  // ������� ���������
  VWideParam := ANewCategory.Name;
  VSQLText := 'INSERT INTO g_category (id_owner,c_name) VALUES ('+FMarksSQLOptions.IdUserStr+',?)';
  FSQLite3DbHandler.ExecSQLWithTEXTW(
    VSQLText,
    TRUE,
    PWideChar(VWideParam),
    Length(VWideParam)
  );

  // Integer ��� ����������
  VNewId := FSQLite3DbHandler.LastInsertedRowId;

  // ������� ��������� ��������� - ������ ���� ���� ������� �� �������� �� ���������
  // ��������� ��� ����������, ��� �� ��������� - ����� NULL
  VFieldEx := '';
  VSQLText := '';

  if (not ANewCategory.Visible) then begin
    // ��������� ������� �����������
    VFieldEx := ',v_visible';
    VSQLText := ','+VisibleToSQL(FALSE);
  end;

  VScale := ANewCategory.AfterScale;
  if (VScale<>FCategoryFactoryConfig.AfterScale) then begin
    VFieldEx := VFieldEx + ',min_zoom';
    VSQLText := VSQLText + ',' + IntToStr(VScale);
  end;

  VScale := ANewCategory.BeforeScale;
  if (VScale<>FCategoryFactoryConfig.BeforeScale) then begin
    VFieldEx := VFieldEx + ',max_zoom';
    VSQLText := VSQLText + ',' + IntToStr(VScale);
  end;

  if (0<Length(VFieldEx)) then begin
    VSQLText := 'INSERT OR REPLACE INTO v_category (id_user,id_category'+VFieldEx+') VALUES ('+
                FMarksSQLOptions.IdUserStr+','+IntToStr(VNewId)+VSQLText+')';
    FSQLite3DbHandler.ExecSQL(VSQLText);
  end;
end;

function TMarksSQLDb.InternalInsertMark(
  const ANewMark: IInterface;
  const AImporting: Boolean;
  const AMarksImportOptions: TMarksImportOptions
): IMark;
var
  VNewMark: IMark;
  Vid_category: Integer;
  VNewIdMark: Integer;
  VWideParam: WideString;
  VMarkVisible: Boolean;
  VMarkPoint: IMarkPoint;
  VMarkLine: IMarkLine;
  VMarkPoly: IMarkPoly;
begin
  Result := nil;
  
  if not Supports(ANewMark, IMark, VNewMark) then
    Exit;

  // ��������� ���������
  // ��������� �� �������� ��������� ��� ������� ����� ���� �� ����
  // �������������� ��� ����� SELECT � �������� ������������� ���������
  if AImporting then begin
    // ����� ���� ��� ��������� ����� � ��� ��� ��� (� ����� � ����)
    Vid_category := InternalImportCategoryByMark(VNewMark);
  end else begin
    // ������������ ��� ��������� ����
    Vid_category := GetCategoryID(VNewMark.Category);
  end;

  // ��������� � ��������� �����
  VWideParam := VNewMark.Name;

  // ������ �������� ����� �������
  if (mio_DontCreateIfNameExists in AMarksImportOptions) then begin
    // ���� � ��������� ���� ����� � ����� ������ - �� ������ �, � �����
    Result := InternalReadMark(0, @Vid_category, PWideChar(VWideParam), Length(VWideParam));
    if (Result<>nil) then
      Exit;
  end;

  FSQLite3DbHandler.ExecSQLWithTEXTW(
    'INSERT INTO m_mark (id_owner,o_name,id_category) VALUES ('+
    FMarksSQLOptions.IdUserStr+',?,'+
    IntToStr(Vid_category)+')',
    TRUE,
    PWideChar(VWideParam),
    Length(VWideParam)
  );

  VNewIdMark := FSQLite3DbHandler.LastInsertedRowId;

  Assert(VNewIdMark<>0);

  // �������� ����� (������ ���� �� ������)
  VWideParam := VNewMark.Desc;
  if (0<Length(VWideParam)) then begin
    FSQLite3DbHandler.ExecSQLWithTEXTW(
      'INSERT OR REPLACE INTO m_descript (id_mark,d_type,d_text) VALUES ('+
      IntToStr(VNewIdMark)+','+
      IntToStr(Ord(mdt_Description))+',?)',
      TRUE,
      PWideChar(VWideParam),
      Length(VWideParam)
    );
  end;

  // ��������� ����� - ����� � v_mark (������ ���� ��������)
  VMarkVisible := GetMarkVisible(VNewMark);
  if (not VMarkVisible) then begin
    FSQLite3DbHandler.ExecSQL(
      'INSERT OR REPLACE INTO v_mark(id_user,id_mark,m_visible) VALUES ('+
      FMarksSQLOptions.IdUserStr+','+
      IntToStr(VNewIdMark)+','+
      VisibleToSQL(FALSE)+')'
    );
  end;

  if Supports(VNewMark, IMarkPoint, VMarkPoint) then begin
    // �����
    Result := InternalInsertMarkPointSub(VMarkPoint, VNewIdMark);
    SetChanged;
    // ����� ������� ��� �����
  end else if Supports(VNewMark, IMarkLine, VMarkLine) then begin
    // ���������
    Result := InternalInsertMarkPolylineSub(VMarkLine, VNewIdMark);
    SetChanged;
    // ����� ��� ���������
  end else if Supports(VNewMark, IMarkPoly, VMarkPoly) then begin
    // �������
    Result := InternalInsertMarkPolygonSub(VMarkPoly, VNewIdMark);
    SetChanged;
    // ����� ��� ��������
  end else begin
    // ��������� �����-�� ������
    Assert(FALSE);
  end;
end;

function TMarksSQLDb.InternalInsertMarkPointSub(const ANewMarkPoint: IMarkPoint; const AIdMark: Integer): IMark;
var
  VDoubleRect: TDoubleRect;
  Vid_image: Integer;
begin
  VDoubleRect.TopLeft := ANewMarkPoint.Point;
  Vid_image := GetImageIdByName(ANewMarkPoint.Pic.GetName);

  FSQLite3DbHandler.ExecSQL(
    'INSERT INTO m_point(id_mark,id_image,m_lon,m_lat) VALUES ('+
    IntToStr(AIdMark)+','+
    IntToStr(Vid_image)+','+
    CoordToDB(VDoubleRect.TopLeft.X)+','+
    CoordToDB(VDoubleRect.TopLeft.Y)+')'
  );

  // ��������� ��������� �����������
  Vid_image := GetPointShowId(ANewMarkPoint);

  FSQLite3DbHandler.ExecSQL(
    'INSERT INTO m_show_pt(id_user,id_mark,id_show_pt) VALUES ('+
    FMarksSQLOptions.IdUserStr+','+
    IntToStr(AIdMark)+','+
    IntToStr(Vid_image)+')'
  );

  // ������
  Result := MakeCloneWithNewId(ANewMarkPoint, AIdMark);
end;

function TMarksSQLDb.InternalInsertMarkPolygonSub(const ANewMarkPoly: IMarkPoly; const AIdMark: Integer): IMark;
var
  VDoubleRect: TDoubleRect;
  Vid_image: Integer;
  VPolyIndex, VPolyCount: Integer;
  VLonLatPolygonLine: ILonLatPolygonLine;
begin
  VDoubleRect := ANewMarkPoly.Line.Bounds.Rect;
  VPolyCount := ANewMarkPoly.Line.Count;
  
  // ����� �������������
  FSQLite3DbHandler.ExecSQL(
    'INSERT INTO m_polygon(id_mark,min_lon,min_lat,max_lon,max_lat,sub_count) VALUES ('+
    IntToStr(AIdMark)+','+
    CoordToDB(VDoubleRect.Left)+','+
    CoordToDB(VDoubleRect.Bottom)+','+
    CoordToDB(VDoubleRect.Right)+','+
    CoordToDB(VDoubleRect.Top)+','+
    IntToStr(VPolyCount)+')'
  );

  // ��������� ��������� �����������
  VPolyIndex := GetPolygonShowId(ANewMarkPoly, Vid_image);
  FSQLite3DbHandler.ExecSQL(
    'INSERT INTO m_show_pg(id_user,id_mark,id_show_pg,id_show_pl) VALUES ('+
    FMarksSQLOptions.IdUserStr+','+
    IntToStr(AIdMark)+','+
    IntToStr(VPolyIndex)+','+
    IntToStr(Vid_image)+')'
  );

  // ��������� ����������
  for VPolyIndex := 0 to VPolyCount-1 do begin
    // �����
    VLonLatPolygonLine := ANewMarkPoly.Line.Item[VPolyIndex];

    // ����������� �������
    VDoubleRect := VLonLatPolygonLine.Bounds.Rect;

    // ��������� ���������� ����� (������� �������)
    FSQLite3DbHandler.ExecSQLWithBLOB(
      'INSERT INTO m_polyouter(id_mark,npp,min_lon,min_lat,max_lon,max_lat,lonlat_type,lonlat_list) VALUES ('+
      IntToStr(AIdMark)+','+
      IntToStr(VPolyIndex)+','+
      CoordToDB(VDoubleRect.Left)+','+
      CoordToDB(VDoubleRect.Bottom)+','+
      CoordToDB(VDoubleRect.Right)+','+
      CoordToDB(VDoubleRect.Top)+',0,?)',
      VLonLatPolygonLine.Points,
      VLonLatPolygonLine.Count*SizeOf(TDoublePoint)
    );

    // TODO: ���������� ����� ������� ��� ������� ���� ��� � ���� �� �����������
    // ��� ����� - ��� ���� ����� ��������� ���������� ������������� � m_polyinner
  end;

  // ������
  Result := MakeCloneWithNewId(ANewMarkPoly, AIdMark);
end;

function TMarksSQLDb.InternalInsertMarkPolylineSub(const ANewMarkLine: IMarkLine; const AIdMark: Integer): IMark;
var
  VDoubleRect: TDoubleRect;
  Vid_image: Integer;
  VPolyIndex, VPolyCount: Integer;
  VLonLatPathLine: ILonLatPathLine;
begin
  VDoubleRect := ANewMarkLine.Line.Bounds.Rect;
  VPolyCount := ANewMarkLine.Line.Count;

  // ����� �������������
  FSQLite3DbHandler.ExecSQL(
    'INSERT INTO m_polyline(id_mark,min_lon,min_lat,max_lon,max_lat,sub_count) VALUES ('+
    IntToStr(AIdMark)+','+
    CoordToDB(VDoubleRect.Left)+','+
    CoordToDB(VDoubleRect.Bottom)+','+
    CoordToDB(VDoubleRect.Right)+','+
    CoordToDB(VDoubleRect.Top)+','+
    IntToStr(VPolyCount)+')'
  );

  // ��������� ��������� �����������
  Vid_image := GetPolylineShowId(ANewMarkLine);
  FSQLite3DbHandler.ExecSQL(
    'INSERT INTO m_show_pl(id_user,id_mark,id_show_pl) VALUES ('+
    FMarksSQLOptions.IdUserStr+','+
    IntToStr(AIdMark)+','+
    IntToStr(Vid_image)+')'
  );

  // ��������� ����������
  // ������ ������� ��������� ���� - ��� ��� 0
  // ��������� ������� ����� ��������� �������� �� ����
  for VPolyIndex := 0 to VPolyCount-1 do begin
    // �����
    VLonLatPathLine := ANewMarkLine.Line.Item[VPolyIndex];
    // ����������� �������
    VDoubleRect := VLonLatPathLine.Bounds.Rect;
    // ��������� ���������� �����
    FSQLite3DbHandler.ExecSQLWithBLOB(
      'INSERT INTO i_polyline(id_mark,npp,min_lon,min_lat,max_lon,max_lat,lonlat_type,lonlat_list) VALUES ('+
      IntToStr(AIdMark)+','+
      IntToStr(VPolyIndex)+','+
      CoordToDB(VDoubleRect.Left)+','+
      CoordToDB(VDoubleRect.Bottom)+','+
      CoordToDB(VDoubleRect.Right)+','+
      CoordToDB(VDoubleRect.Top)+',0,?)',
      VLonLatPathLine.Points,
      VLonLatPathLine.Count*SizeOf(TDoublePoint)
    );
  end;

  // ������
  Result := MakeCloneWithNewId(ANewMarkLine, AIdMark);
end;

function TMarksSQLDb.InternalMarkToId(const AMark: IMark): IMarkId;
begin
  if (AMark<>nil) then
    Supports(AMark, IMarkId, Result)
  else
    Result := nil;
end;

function TMarksSQLDb.InternalReadMark(
  const AIdValue: Integer;
  const AIdCategoryPtr: PInteger;
  const AWideNameBuffer: PWideChar;
  const AWideNameLength: Integer
): IMark;
var
  VWhere: AnsiString;
  VSelectMarksData: TSelectMarksData;
  VCounterContext: TInternalPerformanceCounterContext;
  //VWideParam: WideString;
begin
  VCounterContext := FSelectMarkByIdCounter.StartOperation;
  try
    if (AIdCategoryPtr<>nil) then begin
      // ����� �� ��������� � �����
      VWhere := 'm.id_category='+IntToStr(AIdCategoryPtr^)+' AND m.o_name=? AND p.id_mark=m.id_mark';
    end else begin
      // ����� �� ��������������
      VWhere := IntToStr(AIdValue);
      VWhere := 'm.id_mark='+VWhere+' AND p.id_mark='+VWhere;
    end;

    VSelectMarksData.Init;
    try
      // �������� ����� �� ��������������
      VSelectMarksData.MarkType := mt_Point;
      FSQLite3DbHandler.OpenSQLWithTEXTW(
        GetMarksSQLText(mt_Point, VWhere),
        CallbackSelectMark,
        (@VSelectMarksData),
        TRUE,
        (AIdCategoryPtr<>nil),
        AWideNameBuffer,
        AWideNameLength
      );

      // ��� ����� ���� ������ ���� �����
      if (VSelectMarksData.SingleMark<>nil) then
        Exit;

      // �������� ��������� �� ��������������
      VSelectMarksData.MarkType := mt_Polyline;
      FSQLite3DbHandler.OpenSQLWithTEXTW(
        GetMarksSQLText(mt_Polyline, VWhere),
        CallbackSelectMark,
        (@VSelectMarksData),
        TRUE,
        (AIdCategoryPtr<>nil),
        AWideNameBuffer,
        AWideNameLength
      );

      // ��� ����� ���� ������ ���� �����
      if (VSelectMarksData.SingleMark<>nil) then
        Exit;

      // �������� ������� �� ��������������
      VSelectMarksData.MarkType := mt_Polygon;
      FSQLite3DbHandler.OpenSQLWithTEXTW(
        GetMarksSQLText(mt_Polygon, VWhere),
        CallbackSelectMark,
        (@VSelectMarksData),
        TRUE,
        (AIdCategoryPtr<>nil),
        AWideNameBuffer,
        AWideNameLength
      );
    finally
      Result := VSelectMarksData.SingleMark;
      VSelectMarksData.Uninit;
    end;
  finally
    FSelectMarkByIdCounter.FinishOperation(VCounterContext);
  end;
end;

function TMarksSQLDb.InternalReadOptions: Boolean;
begin
  // ������ ����� ������ �� ���������� ������
  Result := FMarksSQLOptions.ActualVersion;

  if not Result then
    Exit;

  FMarksSQLOptions.Clear;

  // ������ �����
  FSQLite3DbHandler.OpenSQL(
    'SELECT id_option,option_value FROM g_option',
    CallbackReadOptions,
    nil,
    FALSE
  );

  // ������������
  // FMarksSQLOptions.MultiuserModeValue := 1;

  // ������ id_user - ������ ���� �������� ��������������
  if (FMarksSQLOptions.MultiuserModeValue<>0) then begin
    // ��������� ������������ �������� ������������
    // ���� ��� - ������ ������
    FMarksSQLOptions.IdUserStr := IntToStr(GetCurrentUserId(TRUE));
  end else begin
    // ������ ���� ���� 0
    FMarksSQLOptions.IdUserStr := IntToStr(0);
  end;
end;

procedure TMarksSQLDb.InternalReadVersion;
begin
  FMarksSQLOptions.IdVersion := 0;
  try
    FSQLite3DbHandler.OpenSQL(
      'SELECT id_version FROM g_version',
      CallbackReadSingleId,
      @(FMarksSQLOptions.IdVersion),
      FALSE
    );
  except
(*
Exception class ESQLite3ErrorWithCode with message 'no such table: g_version ( error code: 1)'
*)
  end;
end;

procedure TMarksSQLDb.InternalSelectAllCategories(const ACacheAlreadyLocked: Boolean);
var
  VSelectCategoryData: TSelectCategoryData;
  VCounterContext: TInternalPerformanceCounterContext;
begin
  VCounterContext := FSelectAllCategoriesCounter.StartOperation;
  try
    // ���� ��� �� ���������� - ��������� ��� ���
    if (not ACacheAlreadyLocked) then
      FCategoryCache.CategoryNotifier.LockWrite;
    try
      // �������� ��� ��������� � ���
      with VSelectCategoryData do begin
        Init;
        CacheAlreadyLocked := TRUE;
      end;
      // ������ ���
      FCategoryCache.Clear;
      // ����� � ���� ��������� �� ��
      FSQLite3DbHandler.OpenSQL(
        GetCategorySQLText,
        CallbackSelectCategory,
        @VSelectCategoryData,
        FALSE
      );
      // ������ ��� ��������������
      FCategoryCache.Actual := TRUE;
    finally
      if (not ACacheAlreadyLocked) then
        FCategoryCache.CategoryNotifier.UnlockWrite;
    end;
  finally
    FSelectAllCategoriesCounter.FinishOperation(VCounterContext);
  end;
end;

function TMarksSQLDb.InternalSelectCategoryByID(const ACacheAlreadyLocked: Boolean; const id: integer): IMarkCategory;
var
  VSelectCategoryData: TSelectCategoryData;
  VCounterContext: TInternalPerformanceCounterContext;
begin
  VCounterContext := FSelectCategoryByIDCounter.StartOperation;
  try
    // �������� ���� ��������� �� �������������� - � ������ �
    with VSelectCategoryData do begin
      Init;
      CacheAlreadyLocked := ACacheAlreadyLocked;
      SingleRow := TRUE;
    end;
    FSQLite3DbHandler.OpenSQL(
      GetCategorySQLText+' WHERE g.id_category='+IntToStr(id),
      CallbackSelectCategory,
      @VSelectCategoryData,
      FALSE
    );
    Result := VSelectCategoryData.SingleCategory;
  finally
    FSelectCategoryByIDCounter.FinishOperation(VCounterContext);
  end;
end;

function TMarksSQLDb.InternalSelectCategoryByName(const ACacheAlreadyLocked: Boolean; const AName: string): IMarkCategory;
var
  VWideParam: WideString;
  VSelectCategoryData: TSelectCategoryData;
  VCounterContext: TInternalPerformanceCounterContext;
begin
  VCounterContext := FSelectCategoryByNameCounter.StartOperation;
  try
    // �������� ���� ��������� �� �������������� - � ������ �
    with VSelectCategoryData do begin
      Init;
      CacheAlreadyLocked := ACacheAlreadyLocked;
      SingleRow := TRUE;
    end;
    VWideParam := AName;
    FSQLite3DbHandler.OpenSQLWithTEXTW(
      GetCategorySQLText+' WHERE g.c_name=?',
      CallbackSelectCategory,
      @VSelectCategoryData,
      FALSE,
      TRUE,
      PWideChar(VWideParam),
      Length(VWideParam)
    );
    Result := VSelectCategoryData.SingleCategory;
  finally
    FSelectCategoryByNameCounter.FinishOperation(VCounterContext);
  end;
end;

procedure TMarksSQLDb.InternalSelectMarksToList(
  const AMarkList: IInterfaceList;
  const AIdCategoryPtr: PInteger;
  const AIdCategoryList: AnsiString;
  const ARectPtr: PDoubleRect;
  const AIgnoreVisible: Boolean;
  const AConvertToMarkId: Boolean
);
var
  VWhere, VRectSQL: AnsiString;
  VSelectMarksData: TSelectMarksData;
begin
  VWhere := 'm.id_mark=p.id_mark';

  if (AIdCategoryPtr<>nil) then begin
    VWhere := VWhere + ' AND m.id_category='+IntToStr(AIdCategoryPtr^);
  end;

  if (0<Length(AIdCategoryList)) then begin
    VWhere := VWhere + ' AND m.id_category in '+AIdCategoryList;
  end;

  if not AIgnoreVisible then begin
    // ��������� ������ ������� �����
    VWhere := VWhere + ' AND coalesce(v.m_visible,1)=1';
  end;

  VRectSQL := '';
  if (ARectPtr<>nil) then begin
    // ������� ��������� ����� � �������
    VRectSQL := ' AND p.m_lon<='+CoordToDB(ARectPtr^.Right)+
                ' AND p.m_lon>='+CoordToDB(ARectPtr^.Left)+
                ' AND p.m_lat<='+CoordToDB(ARectPtr^.Top)+
                ' AND p.m_lat>='+CoordToDB(ARectPtr^.Bottom);
  end;

  VSelectMarksData.Init;
  try
    VSelectMarksData.AllMarksList    := AMarkList;
    VSelectMarksData.ConvertToMarkId := AConvertToMarkId;

    // ��������� �����
    VSelectMarksData.MarkType := mt_Point;
    FSQLite3DbHandler.OpenSQL(
      GetMarksSQLText(mt_Point, VWhere+VRectSQL),
      CallbackSelectMark,
      (@VSelectMarksData)
    );

    // ���� ��������� � ���������
  
    if (ARectPtr<>nil) then begin
      // ������� ����������� ��������
      VRectSQL := ' AND p.min_lon<='+CoordToDB(ARectPtr^.Right)+
                  ' AND p.max_lon>='+CoordToDB(ARectPtr^.Left)+
                  ' AND p.min_lat<='+CoordToDB(ARectPtr^.Top)+
                  ' AND p.max_lat>='+CoordToDB(ARectPtr^.Bottom);
    end;

    // ��������� ���������
    VSelectMarksData.MarkType := mt_Polyline;
    FSQLite3DbHandler.OpenSQL(
      GetMarksSQLText(mt_Polyline, VWhere+VRectSQL),
      CallbackSelectMark,
      (@VSelectMarksData)
    );

    // ��������� ��������
    VSelectMarksData.MarkType := mt_Polygon;
    FSQLite3DbHandler.OpenSQL(
      GetMarksSQLText(mt_Polygon, VWhere+VRectSQL),
      CallbackSelectMark,
      (@VSelectMarksData)
    );
  finally
    VSelectMarksData.Uninit;
  end;
end;

procedure TMarksSQLDb.InternalSetMarksVisible(
  const AIdMarkList: AnsiString;
  const ANewVisiblePtr: PBoolean
);
var VSQLText, VValue: AnsiString;
begin
  // �� ������ (�� ��������� ��� � �������) ��������� ������� id_mark in LIST � ������ ���������

  // ����� 1 - ��� �����, � ������� ��� ���� ��������� ���������
  if (nil=ANewVisiblePtr) then begin
    // ����� �������� �� ������� - ����������� ������ ��������
    VValue := VisibleToSQL(FALSE);
    VSQLText := '1-m_visible';
  end else begin
    // ����� �������� ������� - �� ���� � ������
    VValue := VisibleToSQL(ANewVisiblePtr^);
    VSQLText := VValue;
  end;

  VSQLText := 'UPDATE v_mark'+
                ' SET m_visible='+VSQLText+
              ' WHERE id_user='+FMarksSQLOptions.IdUserStr+
                ' AND id_mark in ' + AIdMarkList;

  if (nil<>ANewVisiblePtr) then begin
    VSQLText := VSQLText+' AND coalesce(m_visible,'+VisibleToSQL(TRUE)+')<>'+VValue;
  end;
      
  FSQLite3DbHandler.ExecSQL(VSQLText);

  // ����� 2 - ��� ����� ��� ���������
  // ���� ����������� - ��������� ������� �����������
  // ���� ������������� ��������� - ���� ����� �������� � �������
  FSQLite3DbHandler.ExecSQL(
    'INSERT INTO v_mark (id_user,id_mark,m_visible)'+
   ' SELECT '+FMarksSQLOptions.IdUserStr+',m.id_mark,'+VValue+
     ' FROM m_mark m'+
    ' WHERE id_mark in '+AIdMarkList+
      ' AND not exists(SELECT 1 FROM v_mark x'+
                      ' WHERE x.id_user='+FMarksSQLOptions.IdUserStr+
                        ' AND x.id_mark=m.id_mark)'
  );
end;

procedure TMarksSQLDb.InternalSetMarkVisibleByIDList(
  const AMarkList: IInterfaceList;
  const ANewVisiblePtr: PBoolean
);
var
  i: Integer;
  VMarkSMLInternal: IMarkSMLInternal;
  VIdCount: Byte;
  VIdList: AnsiString;
begin
  // ������ ��������� ������ � ������
  // ��� ����� ����� ����������� ������ �� ID
  VIdList := '';
  VIdCount := 0;
  if (AMarkList <> nil) and (AMarkList.Count > 0) then
  for i := 0 to AMarkList.Count-1 do
  if Supports(AMarkList.Items[i], IMarkSMLInternal, VMarkSMLInternal) then begin
    // ��������� ID � ������
    VIdList := VIdList + ',' + IntToStr(VMarkSMLInternal.Id);
    Inc(VIdCount);
    // ���� ���������� ���������� - ��������� ��������� �� ������
    if (VIdCount>=c_MaxListCount) then begin
      // ��������� � ���������� ������
      VIdList[1] := '(';
      VIdList := VIdList + ')';
      InternalSetMarksVisible(VIdList, ANewVisiblePtr);
      VIdList := '';
      VIdCount := 0;
    end;
  end;

  // ���� ��� �������� - ���� �������� ���������
  if (0<Length(VIdList)) then begin
    // ��������� � ���������� ������
    VIdList[1] := '(';
    VIdList := VIdList + ')';
    InternalSetMarksVisible(VIdList, ANewVisiblePtr);
  end;
end;

function TMarksSQLDb.InternalUpdateCategory(const AOldCategory, ANewCategory: IMarkCategory): IMarkCategory;
var
  VMarkCategorySMLInternal: IMarkCategorySMLInternal;
  VWideParam: WideString;
  VSQLFields, VSQLValues: AnsiString;
  VNewVisible, VAllowDelete: Boolean;
  VIdCategory, VNewZoom: Integer;
begin
  // ���������� ��������� � ��� �� ��������� id
  Result := nil;
  if not Supports(ANewCategory, IMarkCategorySMLInternal, VMarkCategorySMLInternal) then
    Exit;

  // �������� id
  VIdCategory := VMarkCategorySMLInternal.Id;

  // ���� ���������� ��� ���������
  if not SameText(AOldCategory.Name, ANewCategory.Name) then begin
    VWideParam := ANewCategory.Name;
    // ��� ������ ����� �������� �� �������������� ����� ���������
    // � ���� ������ ������� ������ � ���� ����������
    FSQLite3DbHandler.ExecSQLWithTEXTW(
      'UPDATE g_category SET c_name=? WHERE id_category='+IntToStr(VIdCategory),
      TRUE,
      PWideChar(VWideParam),
      Length(VWideParam)
    );
  end;

  VSQLFields := '';
  VSQLValues := '';
  VAllowDelete := TRUE;
  
  // ���� ���������� ����
  VNewZoom := ANewCategory.AfterScale;
  if AOldCategory.AfterScale <> VNewZoom then begin
    VSQLFields := VSQLFields + ',min_zoom';
    if (VNewZoom = FCategoryFactoryConfig.AfterScale) then begin
      // ��� �� ���������
      VSQLValues := VSQLValues + ',NULL';
    end else begin
      // ���� ����������� ���������
      VAllowDelete := FALSE;
      VSQLValues := VSQLValues + ',' + IntToStr(VNewZoom);
    end;
  end;
  VNewZoom := ANewCategory.BeforeScale;
  if AOldCategory.BeforeScale <> VNewZoom then begin
    VSQLFields := VSQLFields + ',max_zoom';
    if (VNewZoom = FCategoryFactoryConfig.BeforeScale) then begin
      // ��� �� ���������
      VSQLValues := VSQLValues + ',NULL';
    end else begin
      // ���� ����������� ���������
      VAllowDelete := FALSE;
      VSQLValues := VSQLValues + ',' + IntToStr(VNewZoom);
    end;
  end;

  // ���� ���������� ���������
  VNewVisible := ANewCategory.Visible;
  if AOldCategory.Visible <> VNewVisible then begin
    VSQLFields := VSQLFields + ',v_visible';
    VSQLValues := VSQLValues + ',' + VisibleToSQL(VNewVisible);
    if (not VNewVisible) then begin
      // ���� ����������� ���������
      VAllowDelete := FALSE;
    end;
  end;

  if (0<Length(VSQLFields)) then begin
    // ���-�� ����������
    if VAllowDelete then begin
      // �� ���������� ���, ��� ����� ������ ������� ������
      FSQLite3DbHandler.ExecSQL(
        'DELETE FROM v_category WHERE id_user='+
        FMarksSQLOptions.IdUserStr+
        ' AND id_category='+
        IntToStr(VIdCategory)
      );
    end else begin
      // ��������� ��� ��������� ������
      FSQLite3DbHandler.ExecSQL(
        'INSERT OR REPLACE INTO v_category (id_user,id_category'+
        VSQLFields+
        ') VALUES ('+
        FMarksSQLOptions.IdUserStr+','+
        IntToStr(VIdCategory)+VSQLValues+')'
      );
    end;
  end;

  // �������� ����� ������ � ������� ��� � ���
  // ����� ��� ������ ������������
  Result := FCategoryFactoryDbInternal.CreateCategory(
    VIdCategory,
    ANewCategory.Name,
    ANewCategory.Visible,
    ANewCategory.AfterScale,
    ANewCategory.BeforeScale
  );
  FCategoryCache.ReplaceCategory(VIdCategory, Result);
end;

function TMarksSQLDb.InternalUpdateMark(const AOldMark, ANewMark: IInterface): IMark;
var
  VOldMark, VNewMark: IMark;
  VOldMarkInternal, VNewMarkInternal: IMarkSMLInternal;
  VIdMarkInt, VIdCategory: Integer;
  VSQLText, VIdMarkEq, VIdMarkStr: AnsiString;
  VWideParam: WideString;
  VWithTEXTW: Boolean;
  VOldMarkPoint, VNewMarkPoint: IMarkPoint;
  VOldMarkLine, VNewMarkLine: IMarkLine;
  VOldMarkPoly, VNewMarkPoly: IMarkPoly;
begin
  Result := nil;

  if not Supports(AOldMark, IMark, VOldMark) then
    Exit;
  if not Supports(ANewMark, IMark, VNewMark) then
    Exit;

  if VOldMark.IsEqual(VNewMark) then begin
    // ��� ���������
    Result := VOldMark;
    Exit;
  end;

  if not Supports(AOldMark, IMarkSMLInternal, VOldMarkInternal) then
    Exit;
  if not Supports(ANewMark, IMarkSMLInternal, VNewMarkInternal) then
    Exit;

  // �������� �������� id
  if (VOldMarkInternal.Id<>VNewMarkInternal.Id) then begin
    // ������� ������ � ������ �����
    InternalDeleteMark(AOldMark);
    // ������������ �������������� �������� - ��� ��� ��� TRUE
    Result := InternalInsertMark(ANewMark, TRUE);
    Exit;
  end;
  
  // ��������� ��������� ��� �� ����� ����� � ��� �� �������� id
  VIdMarkInt := VOldMarkInternal.Id;
  VIdMarkStr := IntToStr(VIdMarkInt);
  VIdMarkEq  := 'id_mark='+VIdMarkStr;

  // ��������� � ������� m_mark
  VSQLText := '';
  VWideParam := '';
  VWithTEXTW := FALSE;
  // �������� ��������� ���������
  VIdCategory := GetCategoryID(VNewMark.Category);
  if (GetCategoryID(VOldMark.Category) <> VIdCategory) then begin
    VSQLText := VSQLText + ',id_category=' + IntToStr(VIdCategory);
  end;
  // �������� ��������� ���
  if not SameText(VOldMark.Name, VNewMark.Name) then begin
    VSQLText := VSQLText + ',o_name=?';
    VWideParam := VNewMark.Name;
    VWithTEXTW := TRUE;
  end;
  // ���� ���-�� ��������� - ���������
  if (0<Length(VSQLText)) then begin
    VSQLText[1] := ' ';
    VSQLText := 'UPDATE m_mark SET' + VSQLText + ' WHERE ' + VIdMarkEq;
    FSQLite3DbHandler.ExecSQLWithTEXTW(
      VSQLText,
      VWithTEXTW,
      PWideChar(VWideParam),
      Length(VWideParam)
    );
  end;

  // �������� ��������� ��������� �����
  VWithTEXTW := VNewMarkInternal.Visible;
  if (VOldMarkInternal.Visible<>VWithTEXTW) then begin
    // �������� ����� �������� ��������� �����
    InternalSetMarksVisible('('+VIdMarkStr+')', @VWithTEXTW);
  end;

  // �������� ��������� �������� �����
  if not SameText(VOldMark.Desc, VNewMark.Desc) then begin
    VWideParam := VNewMark.Desc;
    if (0=Length(VWideParam)) then begin
      // ������� ������ � ��������� - �� ����� ��� ������
      FSQLite3DbHandler.ExecSQL(
        'DELETE FROM m_descript WHERE '+VIdMarkEq+' AND d_type='+IntToStr(Ord(mdt_Description))
      );
    end else begin
      // ��������� ��� ��������� ������ � ���������
      FSQLite3DbHandler.ExecSQLWithTEXTW(
        'INSERT OR REPLACE INTO m_descript (id_mark,d_type,d_text) VALUES ('+
        VIdMarkStr+','+IntToStr(Ord(mdt_Description))+',?)',
        TRUE,
        PWideChar(VWideParam),
        Length(VWideParam)
      );
    end;
  end;

  // ����� ������� ��� �����
  if Supports(VNewMark, IMarkPoint, VNewMarkPoint) then begin
    // �����
    if Supports(VOldMark, IMarkPoint, VOldMarkPoint) then begin
      // ������ ���� ���� �����
      Result := InternalUpdateMarkPointSub(VOldMarkPoint, VNewMarkPoint, VIdMarkInt);
    end else begin
      // ������ ���� �� ����� - ���� ��������� ������
      InternalDeleteMarkSubExceptMarkType(mt_Point, VIdMarkEq);
      // � �������� ���������
      Result := InternalInsertMarkPointSub(VNewMarkPoint, VIdMarkInt);
    end;
    SetChanged;
    // ����� ��� �����
  end else if Supports(VNewMark, IMarkLine, VNewMarkLine) then begin
    // ���������
    if Supports(VOldMark, IMarkLine, VOldMarkLine) then begin
      // ������ ���� ���� ���������
      Result := InternalUpdateMarkPolylineSub(VOldMarkLine, VNewMarkLine, VIdMarkInt);
    end else begin
      // ������ ���� �� ��������� - ���� ��������� ������
      InternalDeleteMarkSubExceptMarkType(mt_Polyline, VIdMarkEq);
      // � �������� ���������
      Result := InternalInsertMarkPolylineSub(VNewMarkLine, VIdMarkInt);
    end;
    SetChanged;
    // ����� ��� ���������
  end else if Supports(VNewMark, IMarkPoly, VNewMarkPoly) then begin
    // �������
    if Supports(VOldMark, IMarkPoly, VOldMarkPoly) then begin
      // ������ ���� ���� ���������
      Result := InternalUpdateMarkPolygonSub(VOldMarkPoly, VNewMarkPoly, VIdMarkInt);
    end else begin
      // ������ ���� �� ��������� - ���� ��������� ������
      InternalDeleteMarkSubExceptMarkType(mt_Polygon, VIdMarkEq);
      // � �������� ���������
      Result := InternalInsertMarkPolygonSub(VNewMarkPoly, VIdMarkInt);
    end;
    SetChanged;
    // ����� ��� ��������
  end else begin
    // ��������� �����-�� ������
    Assert(FALSE);
  end;
end;

function TMarksSQLDb.InternalUpdateMarkPointSub(const AOldMarkPoint, ANewMarkPoint: IMarkPoint; const AIdMark: Integer): IMark;
var
  VSQLText: AnsiString;
  VNewPicName: String;
  VNewPt: TDoublePoint;
begin
  // m_point
  VSQLText := '';

  VNewPicName := ANewMarkPoint.Pic.GetName;
  if not SameText(AOldMarkPoint.Pic.GetName, VNewPicName) then begin
    if (0=Length(VNewPicName)) then
      VNewPicName := 'NULL'
    else
      VNewPicName := IntToStr(GetImageIdByName(VNewPicName));
    VSQLText := VSQLText + ',id_image=' + VNewPicName;
  end;

  VNewPt := ANewMarkPoint.Point;
  with AOldMarkPoint.Point do begin
    if (X <> VNewPt.X) then begin
      VSQLText := VSQLText + ',m_lon=' + CoordToDB(VNewPt.X);
    end;
    if (Y <> VNewPt.Y) then begin
      VSQLText := VSQLText + ',m_lat=' + CoordToDB(VNewPt.Y);
    end;
  end;

  if (0<Length(VSQLText)) then begin
    VSQLText[1]:=' ';
    FSQLite3DbHandler.ExecSQL(
      'UPDATE m_point SET' + VSQLText + ' WHERE id_mark='+IntToStr(AIdMark)
    );
  end;

  // m_show_pt
  if (AOldMarkPoint.TextColor<>ANewMarkPoint.TextColor) OR
     (AOldMarkPoint.TextBgColor<>ANewMarkPoint.TextBgColor) OR
     (AOldMarkPoint.FontSize<>ANewMarkPoint.FontSize) OR
     (AOldMarkPoint.MarkerSize<>ANewMarkPoint.MarkerSize) then begin
    // ���-�� ����������
    FSQLite3DbHandler.ExecSQL(
      'INSERT OR REPLACE INTO m_show_pt (id_user,id_mark,id_show_pt) VALUES ('+
      FMarksSQLOptions.IdUserStr+','+
      IntToStr(AIdMark)+','+
      IntToStr(GetPointShowId(ANewMarkPoint))+')'
    );
  end;

  // ������
  Result := MakeCloneWithNewId(ANewMarkPoint, AIdMark);
end;

function TMarksSQLDb.InternalUpdateMarkPolygonSub(const AOldMarkPoly, ANewMarkPoly: IMarkPoly; const AIdMark: Integer): IMark;
var
  VDoubleRect: TDoubleRect;
  VOldCount, VNewCount, VPolyIndex: Integer;
  VStrIdMark: String;
  VLonLatPolygonLine: ILonLatPolygonLine;
begin
  VStrIdMark := IntToStr(AIdMark);

  if not ANewMarkPoly.Line.IsSame(AOldMarkPoly.Line) then begin
    // ���������� �����-�� ����������
    VNewCount := ANewMarkPoly.Line.Count;
    VDoubleRect := ANewMarkPoly.Line.Bounds.Rect;

    if not AOldMarkPoly.Line.Bounds.IsEqual(VDoubleRect) then begin
      // ���������� �������������� ����������
      FSQLite3DbHandler.ExecSQL(
        'UPDATE m_polygon SET min_lon='+CoordToDB(VDoubleRect.Left)+
        ',min_lat='+CoordToDB(VDoubleRect.Bottom)+
        ',max_lon='+CoordToDB(VDoubleRect.Right)+
        ',max_lat='+CoordToDB(VDoubleRect.Top)+
        ',sub_count='+IntToStr(VNewCount)+
        ' WHERE id_mark='+VStrIdMark
      );
    end;

    // ����� ������� ������ ���������
    VOldCount := AOldMarkPoly.Line.Count;
    if VOldCount>VNewCount then begin
      // ����� ������ ����������� - ������� ������
      FSQLite3DbHandler.ExecSQL(
        'DELETE FROM m_polyouter WHERE id_mark='+VStrIdMark+' AND npp>='+IntToStr(VNewCount)
      );
    end;

    // ����������� ����� ����������
    for VPolyIndex := 0 to VNewCount-1 do begin
      VLonLatPolygonLine := ANewMarkPoly.Line.Item[VPolyIndex];
      // ����������� �������
      VDoubleRect := VLonLatPolygonLine.Bounds.Rect;
      // ��������� ��� ��������� ���������� �����
      if (VPolyIndex>=VOldCount) or (not AOldMarkPoly.Line.Item[VPolyIndex].IsSame(VLonLatPolygonLine)) then begin
        FSQLite3DbHandler.ExecSQLWithBLOB(
          'INSERT OR REPLACE INTO m_polyouter(id_mark,npp,min_lon,min_lat,max_lon,max_lat,lonlat_type,lonlat_list) VALUES ('+
          VStrIdMark+','+
          IntToStr(VPolyIndex)+','+
          CoordToDB(VDoubleRect.Left)+','+
          CoordToDB(VDoubleRect.Bottom)+','+
          CoordToDB(VDoubleRect.Right)+','+
          CoordToDB(VDoubleRect.Top)+',0,?)',
          VLonLatPolygonLine.Points,
          VLonLatPolygonLine.Count*SizeOf(TDoublePoint)
        );
      end;
    end;
  end;

  // ��������� �����������
  if (AOldMarkPoly.FillColor<>ANewMarkPoly.FillColor) OR
     (AOldMarkPoly.BorderColor<>ANewMarkPoly.BorderColor) OR
     (AOldMarkPoly.LineWidth<>ANewMarkPoly.LineWidth) then begin
    // ��������� ���������
    VPolyIndex := GetPolygonShowId(ANewMarkPoly, VOldCount);
    FSQLite3DbHandler.ExecSQL(
      'INSERT OR REPLACE INTO m_show_pg (id_user,id_mark,id_show_pg,id_show_pl) VALUES ('+
      FMarksSQLOptions.IdUserStr+','+
      VStrIdMark+','+
      IntToStr(VPolyIndex)+','+
      IntToStr(VOldCount)+')'
    );
  end;

  // ������
  Result := MakeCloneWithNewId(ANewMarkPoly, AIdMark);
end;

function TMarksSQLDb.InternalUpdateMarkPolylineSub(const AOldMarkLine, ANewMarkLine: IMarkLine; const AIdMark: Integer): IMark;
var
  VDoubleRect: TDoubleRect;
  VOldCount, VNewCount, VPolyIndex: Integer;
  VStrIdMark: String;
  VLonLatPathLine: ILonLatPathLine;
begin
  VStrIdMark := IntToStr(AIdMark);

  if not ANewMarkLine.Line.IsSame(AOldMarkLine.Line) then begin
    // ���������� �����-�� ����������
    VDoubleRect := ANewMarkLine.Line.Bounds.Rect;
    VNewCount := ANewMarkLine.Line.Count;

    if not AOldMarkLine.Line.Bounds.IsEqual(VDoubleRect) then begin
      // ���������� �������������� ����������
      FSQLite3DbHandler.ExecSQL(
        'UPDATE m_polyline SET min_lon='+CoordToDB(VDoubleRect.Left)+
        ',min_lat='+CoordToDB(VDoubleRect.Bottom)+
        ',max_lon='+CoordToDB(VDoubleRect.Right)+
        ',max_lat='+CoordToDB(VDoubleRect.Top)+
        ',sub_count='+IntToStr(VNewCount)+
        ' WHERE id_mark='+VStrIdMark
      );
    end;

    // ����� ���������
    VOldCount := AOldMarkLine.Line.Count;
    if VOldCount>VNewCount then begin
      // ����� ������ ����������� - ������� ������
      FSQLite3DbHandler.ExecSQL(
        'DELETE FROM i_polyline WHERE id_mark='+VStrIdMark+' AND npp>='+IntToStr(VNewCount)
      );
    end;

    // ����������� ����� ����������
    for VPolyIndex := 0 to VNewCount-1 do begin
      VLonLatPathLine := ANewMarkLine.Line.Item[VPolyIndex];
      // ����������� �������
      VDoubleRect := VLonLatPathLine.Bounds.Rect;
      // ��������� ��� ��������� ���������� �����
      if (VPolyIndex>=VOldCount) or (not AOldMarkLine.Line.Item[VPolyIndex].IsSame(VLonLatPathLine)) then begin
        FSQLite3DbHandler.ExecSQLWithBLOB(
          'INSERT OR REPLACE INTO i_polyline(id_mark,npp,min_lon,min_lat,max_lon,max_lat,lonlat_type,lonlat_list) VALUES ('+
          VStrIdMark+','+
          IntToStr(VPolyIndex)+','+
          CoordToDB(VDoubleRect.Left)+','+
          CoordToDB(VDoubleRect.Bottom)+','+
          CoordToDB(VDoubleRect.Right)+','+
          CoordToDB(VDoubleRect.Top)+',0,?)',
          VLonLatPathLine.Points,
          VLonLatPathLine.Count*SizeOf(TDoublePoint)
        );
      end;
    end;
  end;

  // ��������� �����������
  if (AOldMarkLine.LineColor<>ANewMarkLine.LineColor) OR
     (AOldMarkLine.LineWidth<>ANewMarkLine.LineWidth) then begin
    // ��������� ���������
    FSQLite3DbHandler.ExecSQL(
      'INSERT OR REPLACE INTO m_show_pl (id_user,id_mark,id_show_pl) VALUES ('+
      FMarksSQLOptions.IdUserStr+','+
      VStrIdMark+','+
      IntToStr(GetPolylineShowId(ANewMarkLine))+')'
    );
  end;

  // ������
  Result := MakeCloneWithNewId(ANewMarkLine, AIdMark);
end;

procedure TMarksSQLDb.KillPerfCounters;
begin
  // ���� �����
end;

function TMarksSQLDb.GetImageIdByName(const AImageName: String): Integer;
var
  VWideParam: WideString;
  VCounterContext: TInternalPerformanceCounterContext;
begin
  VCounterContext := FLookupImageCounter.StartOperation;
  try
    if FCachePointImageId.GetInCache(AImageName, Result) then
      Exit;
    VWideParam := AImageName;
    Result := InternalGetShowId(
      'SELECT id_image FROM g_image WHERE i_name=?',
      'INSERT OR IGNORE INTO g_image (i_name) VALUES (?)',
      TRUE,
      PWideChar(VWideParam),
      Length(VWideParam)
    );
    FCachePointImageId.SetInCache(AImageName, Result);
  finally
    FLookupImageCounter.FinishOperation(VCounterContext);
  end;
end;

function TMarksSQLDb.GetMarksSubset(
  const ARect: TDoubleRect;
  const ACategoryList: IInterfaceList;
  AIgnoreVisible: Boolean
): IMarksSubset;
var
  VResultList: IInterfaceList;
  VMarkCategorySMLInternal: IMarkCategorySMLInternal;
  VIdCount: Byte;
  VIdList: AnsiString;
  i: Integer;
  VCounterContext: TInternalPerformanceCounterContext;
begin
  // ��� �������� ����� ����������� DoubleRect(-180, 90, 180, -90)
  // �� ���� ��������� ������� ��� �������� ����������
  VCounterContext := FGetMarksSubsetByListCounter.StartOperation;
  try
    VResultList := TInterfaceList.Create;
    Result := TMarksSubset.Create(VResultList);
    VResultList.Lock;
    try
      if (ACategoryList<>nil) then begin
        // ���� ������ ���������
        VIdList := '';
        VIdCount := 0;
        LockRead;
        try
          // ���� �� ����������
          for i := 0 to ACategoryList.Count-1 do
          if Supports(ACategoryList[i], IMarkCategorySMLInternal, VMarkCategorySMLInternal) then begin
            // ��������� ID � ������
            VIdList := VIdList + ',' + IntToStr(VMarkCategorySMLInternal.Id);
            Inc(VIdCount);
            // ���� ���������� ���������� - ��������� ��������� �� ������
            if (VIdCount>=c_MaxListCount) then begin
              // ��������� � ���������� ������
              VIdList[1] := '(';
              VIdList := VIdList + ')';
              InternalSelectMarksToList(VResultList, nil, VIdList, @ARect, AIgnoreVisible, FALSE);
              VIdList := '';
              VIdCount := 0;
            end;
          end;

          // ���� ���� ������� - � ��� ����������
          if (0<Length(VIdList)) then begin
            VIdList[1] := '(';
            VIdList := VIdList + ')';
            InternalSelectMarksToList(VResultList, nil, VIdList, @ARect, AIgnoreVisible, FALSE);
          end;
        finally
          UnlockRead;
        end;
        // ����� ��������� ������ ���������
      end else begin
        // ��� ������ ���������
        LockRead;
        try
          InternalSelectMarksToList(VResultList, nil, '', @ARect, AIgnoreVisible, FALSE);
        finally
          UnlockRead;
        end;
      end;
    finally
      VResultList.Unlock;
    end;
  finally
    FGetMarksSubsetByListCounter.FinishOperation(VCounterContext);
  end;
end;

function TMarksSQLDb.GetMarksSQLText(const AMarkTypeSQL: TMarkType; const AWhere: AnsiString): AnsiString;
begin
  // ���� �������� ����� ���� - ����� ��� ������ ����� (� d_text)
  Result := 'SELECT m.id_mark,m.id_category,m.o_name,v.m_visible,d.d_text';

  case AMarkTypeSQL of
    mt_Point: begin
      Result := Result +
                // ��� ��������
                ',i.i_name'+
                // ��������� �����������
                ',h.text_color,h.shadow_color,h.font_size,h.icon_size'+
                // ���������� �����
                ',p.m_lon,p.m_lat';
    end;
    mt_Polyline: begin
      Result := Result +
                // ����� �������������� �������������
                // ',p.min_lon,p.min_lat,p.max_lon,p.max_lat'+
                // ����� ����� ������ � ������ ����� ���������
                ',p.sub_count,y.lonlat_list'+
                // ��������� �����������
                ',h.line_color,h.line_width';

    end;
    mt_Polygon: begin
      Result := Result +
                // ����� �������������� �������������
                // ',p.min_lon,p.min_lat,p.max_lon,p.max_lat'+
                // ����� ����� ������ � ������ ����� ���������
                ',p.sub_count,y.lonlat_list'+
                // ��������� �����������
                ',h.fill_color,j.line_color,j.line_width';
    end;
  end;

  Result := Result + ' FROM m_mark m INNER JOIN '+c_MarkTypeTBL[AMarkTypeSQL]+' p ON m.id_mark=p.id_mark'+
                              ' LEFT OUTER JOIN v_mark v ON v.id_user='+FMarksSQLOptions.IdUserStr+
                                                      ' AND m.id_mark=v.id_mark'+
                              ' LEFT OUTER JOIN m_descript d ON d.d_type='+IntToStr(Ord(mdt_Description))+
                                                          ' AND m.id_mark=d.id_mark'+
                              ' LEFT OUTER JOIN '+c_MarkShowTBL[AMarkTypeSQL]+' s ON s.id_user='+FMarksSQLOptions.IdUserStr+
                                                                               ' AND p.id_mark=s.id_mark';
  
  case AMarkTypeSQL of
    mt_Point: begin
      Result := Result + ' LEFT OUTER JOIN g_show_pt h ON s.id_show_pt=h.id_show_pt'+
                         ' LEFT OUTER JOIN g_image i ON p.id_image=i.id_image';
    end;
    mt_Polyline: begin
      Result := Result + ' LEFT OUTER JOIN i_polyline y ON p.id_mark=y.id_mark AND y.npp=0'+
                         ' LEFT OUTER JOIN g_show_pl h ON s.id_show_pl=h.id_show_pl';
    end;
    mt_Polygon: begin
      Result := Result + ' LEFT OUTER JOIN m_polyouter y ON p.id_mark=y.id_mark AND y.npp=0'+
                         ' LEFT OUTER JOIN g_show_pg h ON s.id_show_pg=h.id_show_pg'+
                         ' LEFT OUTER JOIN g_show_pl j ON s.id_show_pl=j.id_show_pl';
    end;
  end;

  // ���� ����� ����������� ��������� ����������� ��� ��������� - ���� �����
  // �������� ��� � ������ + ���� ����������� ������� ����� coalesce
  //' LEFT OUTER JOIN m_show_cg f ON f.id_user='+FMarksSQLOptions.StrIdUser+
  //                           ' AND m.id_category=f.id_category';

  Result := Result + ' WHERE '+ AWhere;
end;

function TMarksSQLDb.GetMarksSubset(
  const ARect: TDoubleRect;
  const ACategory: ICategory;
  AIgnoreVisible: Boolean
): IMarksSubset;
var
  VResultList: IInterfaceList;
  VIdCategory: Integer;
  VIdCategoryPtr: PInteger;
  VCounterContext: TInternalPerformanceCounterContext;
begin
  // ��� �������� ����� ����������� DoubleRect(-180, 90, 180, -90)
  // �� ���� ��������� ������� ��� �������� ����������
  VCounterContext := FGetMarksSubsetByCategoryCounter.StartOperation;
  try
  VResultList := TInterfaceList.Create;
  Result := TMarksSubset.Create(VResultList);

  if (ACategory<>nil) then begin
    // ���� ���������
    VIdCategory := GetCategoryID(ACategory);
    VIdCategoryPtr := @VIdCategory;
  end else begin
    // ��� ���������
    VIdCategoryPtr := nil;
  end;

  // ���� �����
  VResultList.Lock;
  try
    LockRead;
    try
      InternalSelectMarksToList(VResultList, VIdCategoryPtr, '', @ARect, AIgnoreVisible, FALSE);
    finally
      UnlockRead;
    end;
  finally
    VResultList.Unlock;
  end;
  finally
    FGetMarksSubsetByCategoryCounter.FinishOperation(VCounterContext);
  end;
end;

procedure TMarksSQLDb.LoadCategoriesFromFile;
begin
  // ��� �����!
end;

procedure TMarksSQLDb.LoadMarksFromFile;
begin
  // ��� �����!
end;

procedure TMarksSQLDb.LockWrite;
begin
  inherited LockWrite;
  FSQLite3DbHandler.BeginTran;
end;

function TMarksSQLDb.MakeCloneWithNewId(const AMark: IMark; const AIdValue: Integer): IMark;
var
  VMarkSMLInternal: IMarkSMLInternal;
  VInterface: IInterface;
begin
  Result := nil;
  if Supports(AMark, IMarkSMLInternal, VMarkSMLInternal) then begin
    VInterface := VMarkSMLInternal.CloneWithNewId(AIdValue);
    if Supports(VInterface, IMark, Result) then begin
      // OK
    end else begin
      // failed
      Assert(FALSE);
    end;
  end else begin
    // failed
    Assert(FALSE);
  end;
end;

procedure TMarksSQLDb.MakePerfCounters;
begin
  FImportMarksCounter      := FPerfCounterList.CreateAndAddNewCounter('ImportMarks');

  FUpdateMarkCounter       := FPerfCounterList.CreateAndAddNewCounter('UpdateMark');
  FUpdateMarksListCounter  := FPerfCounterList.CreateAndAddNewCounter('UpdateMarksList');

  FSetMarksInCategoryVisibleCounter := FPerfCounterList.CreateAndAddNewCounter('SetMarksInCategoryVisible');

  FSelectAllMarksCounter        := FPerfCounterList.CreateAndAddNewCounter('SelectAllMarks');
  FSelectMarkByIdCounter        := FPerfCounterList.CreateAndAddNewCounter('SelectMarkById');
  FSelectMarksByCategoryCounter := FPerfCounterList.CreateAndAddNewCounter('SelectMarksByCategory');

  FGetMarksSubsetByCategoryCounter := FPerfCounterList.CreateAndAddNewCounter('GetMarksSubsetByCategory');
  FGetMarksSubsetByListCounter     := FPerfCounterList.CreateAndAddNewCounter('GetMarksSubsetByList');

  FSelectAllCategoriesCounter  := FPerfCounterList.CreateAndAddNewCounter('SelectAllCategories');
  FSelectCategoryByIDCounter   := FPerfCounterList.CreateAndAddNewCounter('SelectCategoryByID');
  FSelectCategoryByNameCounter := FPerfCounterList.CreateAndAddNewCounter('SelectCategoryByName');

  FLookupImageCounter        := FPerfCounterList.CreateAndAddNewCounter('LookupImage');
  FLookupPointShowCounter    := FPerfCounterList.CreateAndAddNewCounter('LookupPointShow');
  FLookupPolylineShowCounter := FPerfCounterList.CreateAndAddNewCounter('LookupPolylineShow');
  FLookupPolygonShowCounter  := FPerfCounterList.CreateAndAddNewCounter('LookupPolygonShow');
end;

procedure TMarksSQLDb.ParserFoundProc_SQL(
  const ASender: TObject;
  const ACommandIndex: Integer;
  const ACommandText, AErrors: TStrings
);
begin
  if (0<ACommandText.Count) then
  try
    // ��������� (��� �� ����� - ��� Ansi)
    FSQLite3DbHandler.ExecSQL(ACommandText.Text);
  except on E: Exception do
    TSQLScriptParser.AddExceptionToErrors(AErrors, E);
  end;
end;

function TMarksSQLDb.SaveCategory2File: boolean;
begin
  // ��� �����!
  Result := TRUE;
end;

function TMarksSQLDb.SaveMarks2File: boolean;
begin
  // ��� �����!
  Result := TRUE;
end;

{ TSelectMarksData }

procedure TSelectMarksData.AppendArrayOfPoints(const APointArray: Pointer; const APointCount: Integer);
var
  VNeedEmptyPoint: Boolean;
  VNewUsedCount: Integer;
  VWriteFirstIndex: Integer;
begin
  if (0=APointCount) or (nil=APointArray) then
    Exit;

  // ���� ��������� ��� ��� - ��������� ������ ����������
  // ���� ���������� ��� ���� - ��������� ������� EmptyPoint, ����� ����������
  VNeedEmptyPoint := (UsedCount>0);
  VWriteFirstIndex := UsedCount + Ord(VNeedEmptyPoint);
  VNewUsedCount := VWriteFirstIndex + APointCount;

  // ��� ������������� ������� ������ (������ ����������� UsedCount)
  InternalAllocForUsedCount(VNewUsedCount);

  // ��������� ����������
  CopyMemory(
    @(AllPoints[VWriteFirstIndex]),
    APointArray,
    APointCount*SizeOf(TDoublePoint)
  );

  if VNeedEmptyPoint then begin
    // ������� ����������� ������
    AllPoints[VWriteFirstIndex-1] := CEmptyDoublePoint;
  end;
end;

procedure TSelectMarksData.AppendOnePoint(const APoint: TDoublePoint);
var
  VNeedEmptyPoint: Boolean;
  VNewUsedCount: Integer;
begin
  // ���� ��������� ��� ��� - ��������� ����
  // ���� ���������� ��� ���� - ��������� ���, ������� EmptyPoint ����� ������
  VNeedEmptyPoint := (UsedCount>0);
  VNewUsedCount := UsedCount + 1 + Ord(VNeedEmptyPoint);

  // ��� ������������� ������� ������ (������ ����������� UsedCount)
  InternalAllocForUsedCount(VNewUsedCount);

  // ������� ����������
  AllPoints[VNewUsedCount-1] := APoint;

  if VNeedEmptyPoint then begin
    // ������� ����������� ������
    AllPoints[VNewUsedCount-2] := CEmptyDoublePoint;
  end;
end;

procedure TSelectMarksData.Init;
begin
  FillChar(Self, SizeOf(Self), 0);
end;

procedure TSelectMarksData.InitNewMarkPoints;
begin
  UsedCount := 0;
end;

procedure TSelectMarksData.InternalAllocForUsedCount(const ANewUsedCount: Integer);
begin
  UsedCount := ANewUsedCount;

  // ���� ����� ���������� - �����
  if (AllocCount>=ANewUsedCount) then
    Exit;

  AllocCount := ANewUsedCount;
  
  // ����������� ������, ����� ��-�� ����� ������ ����������
  // � ��������� ��� �� �������� � ��������������
  if (AllocCount<16) then
    AllocCount:=16
  else if (AllocCount<64) then
    AllocCount:=64 // ���� 16 �����, �� ������ ���� - �� ��������� ������
  else if (AllocCount<256) then
    AllocCount:=256
  else if (AllocCount<1024) then
    AllocCount:=1024
  else if (AllocCount<4096) then
    AllocCount:=4096
  else
    AllocCount:=((AllocCount div 4096)+1)*4096; // ��� �� ���� ���������� (AllocCount-1) - �� ��������� ������

  if (nil=AllPoints) then begin
    // �������� ������ ������ ���
    AllPoints := HeapAlloc(GetProcessHeap, 0, AllocCount*SizeOf(TDoublePoint));
  end else begin
    // ������������ ������
    AllPoints := HeapReAlloc(GetProcessHeap, 0, AllPoints, AllocCount*SizeOf(TDoublePoint));
  end;
end;

procedure TSelectMarksData.Uninit;
begin
  SingleMark := nil;
  AllMarksList := nil;
  // free
  if (AllPoints<>nil) then begin
    HeapFree(GetProcessHeap, 0, AllPoints);
    AllPoints := nil;
  end;
  AllocCount := 0;
  UsedCount  := 0;
  //PartCount  := 0;
end;

{ TSelectCategoryData }

procedure TSelectCategoryData.Init;
begin
  FillChar(Self, SizeOf(Self), 0);
  AddToCache := TRUE;
end;

end.
