unit u_GlobalState;

interface

uses
  Windows,
  Graphics,
  Classes,
  IniFiles,
  SyncObjs,
  GR32,
  t_GeoTypes,
  t_CommonTypes,
  i_IMemObjCache,
  i_ITileFileNameGeneratorsList,
  i_IBitmapTypeExtManager,
  i_IKmlInfoSimpleLoader,
  u_GarbageCollectorThread,
  u_GeoToStr,
  Uimgfun,
  UMapType,
  u_MemFileCache;

type
  TSrchType = (stGoogle,stYandex);

  TGlobalState = class
  private
    FMemFileCache: TMemFileCache;
    FScreenSize: TPoint;
    FDwnCS: TCriticalSection;
    FTileNameGenerator: ITileFileNameGeneratorsList;
    FGCThread: TGarbageCollectorThread;
    FBitmapTypeManager: IBitmapTypeExtManager;
    FMapCalibrationList: IInterfaceList;
    FKmlLoader: IKmlInfoSimpleLoader;
    FKmzLoader: IKmlInfoSimpleLoader;
    FCacheElemensMaxCnt: integer;
    function GetMarkIconsPath: string;
    function GetMarksFileName: string;
    function GetMarksBackUpFileName: string;
    function GetMarksCategoryBackUpFileName: string;
    function GetMarksCategoryFileName: string;
    function GetMapsPath: string;
    function GetTrackLogPath: string;
    function GetHelpFileName: string;
    function GetMainConfigFileName: string;
    procedure LoadMarkIcons;
    procedure LoadResources;
    procedure LoadMainParams;
    procedure FreeAllMaps;
    procedure FreeMarkIcons;
    procedure SetScreenSize(const Value: TPoint);
    procedure SetCacheElemensMaxCnt(const Value: integer);
  public

    MainFileCache: IMemObjCache;
    // Ini-���� � ��������� �����������
    MainIni: TMeminifile;
    // ��������� ���������
    ProgramPath: string;
    // ������ ��� �����
    MarkIcons: TStringList;
    // ������ ��� �������� �� ����� ���� �������� �������.
    GOToSelIcon: TBitmap32;

    // ���� ���������� ���������
    Localization: Integer;

    // �������� �� ���� ������ ��� ������ ���������
    WebReportToAuthor: Boolean;

    // ������ ����������� ����������, � � ��������� ��������
    num_format: TDistStrFormat;
    // ������ ����������� ��������� � ��������
    llStrType: TDegrShowFormat;
    // ���������� �������� ������ � ����������
    All_Dwn_Kb: Currency;
    // ���������� ��������� ������
    All_Dwn_Tiles: Cardinal;

    InetConnect: TInetConnect;
    //���������� ���������� � ������ ������������� �� �������
    SaveTileNotExists: Boolean;
    // ��������� ���� ��� ���� ���������� � ���������� ��� �� �������
    IgnoreTileNotExists: Boolean;
    // ������ ������ ������� ������� ���� ��� ������ ����������
    TwoDownloadAttempt: Boolean;
    // ���������� � ���������� ����� ���� ��������� ������ �������
    GoNextTileIfDownloadError: Boolean;

    // ������ ����������� ��������
    Resampling: TTileResamplingType;
    //������ ������� ���� ��-���������.
    DefCache: byte;

    GPS_enab: Boolean;

    //COM-����, � �������� ��������� GPS
    GPS_COM: string;
    //�������� GPS COM �����
    GPS_BaudRate: Integer;
    // ������������ ����� �������� ������ �� GPS
    GPS_TimeOut: integer;
    // �������� ����� ������� �� GPS
    GPS_Delay: Integer;
    //�������� GPS
    GPS_Correction: TExtendedPoint;
    //������ ��������� ����������� ��� GPS-���������
    GPS_ArrowSize: Integer;
    //���� ��������� ����������� ��� ���������
    GPS_ArrowColor: TColor;
    //���������� GPS ����
    GPS_ShowPath: Boolean;
    // ������� ������������ GPS �����
    GPS_TrackWidth: Integer;
    //������������ ����� �� GPS �������
    GPS_MapMove: Boolean;
    //��������� GPS ���� � ����
    GPS_WriteLog: boolean;
    //���� ��� ������ GPS ����� (����� ����� �������� ��������� ��������)
    GPS_LogFile: TextFile;
    //������ �� ��������� ��������� ����������� �� GPS
    GPS_ArrayOfSpeed: array of Real;
    //����� GPS �����
    GPS_TrackPoints: TExtendedPointArray;
    //��������/���������� ������ �������� ��� �����������/���������� GPS
    GPS_SensorsAutoShow: boolean;

    LastSelectionColor: TColor;
    LastSelectionAlfa: Byte;

    BorderColor: TColor;
    BorderAlpha: byte;

    // ���� ��� ������������� ������ � ���� ���������� �����
    MapZapColor:TColor;
    // ���������� tne �� ���� ���������� �����
    MapZapShowTNE: Boolean;
    // ���� ��� ������ ������������� �� ������� � ���� ���������� �����
    MapZapTneColor: TColor;
    // ������������ ���� ���������� �����
    MapZapAlpha:byte;

    WikiMapMainColor:TColor;
    WikiMapFonColor:TColor;

    InvertColor: boolean;
    // ����� ��� ����� �������������� ������ ����� ������������
    GammaN: Integer;
    // ����� ��� ��������� ������������� ������ ����� ������������
    ContrastN: Integer;

    // ����������� ����� ��������� �������� ��� �������� ����
    ZoomingAtMousePos: Boolean;

    show_point: TMarksShowType;
    FirstLat: Boolean;
    ShowMapName: Boolean;
    // ���������� ������ �������
    ShowStatusBar: Boolean;

    //����������� ����� �� �����������
    CiclMap: Boolean;

    // ���������� ������ ������������ �� �������� ������
    TilesOut: Integer;

    //������������ ����� ���������� ������� ��� �����������
    UsePrevZoom: Boolean;
    //������������ ����� ���������� ������� ��� ����������� (��� �����)
    UsePrevZoomLayer: Boolean;
    //������������� ����������� ��� ���� ������� �����
    MouseWheelInv: Boolean;
    //������������� ���
    AnimateZoom: Boolean;
    //��� ����������� ����� ������ �������� �������
    ShowBorderText: Boolean;
    // ������� ������������ ����� ��������
    GShScale: integer;


    //���� � ����� ������ �����
    NewCPath_: string;
    OldCPath_: string;
    ESCpath_: string;
    GMTilespath_: string;
    GECachepath_: string;

    // ���������� ����� ��� ���������� ���� ��� ������
    ShowHintOnMarks: Boolean;

    // �������� ���������� ������ �������� ����

    FullScrean: Boolean;

    // ������� ����
    zoom_size: byte;

    // ���������� ����� ������ ��� ��������� ����
    TileGridZoom: byte;

    //������ ������
    SrchType: TSrchType;

    //��������� ����������� ������� �� GSM
    GSMpar:TGSMpar;

    //���� ����
    BGround:TColor;

    //������ ����������� ������ �������� � ���������� ������ ������������ �����
    SessionLastSuccess:boolean;

    MapType: array of TMapType;
    sat_map_both: TMapType;

    // ������� ���������� ��������� ��� ��������� � ��������.
    LastSelectionPolygon: TExtendedPointArray;
    // �������, �� ������� ���� ��������� ���������
    poly_zoom_save: byte;

    // ���������� ��������� � ���� � ������
    property CacheElemensMaxCnt: integer read FCacheElemensMaxCnt write SetCacheElemensMaxCnt;

    // ������� ������, ��� �� �� ������� ������ ��� ������ TScreen
    property ScreenSize: TPoint read FScreenSize write SetScreenSize;

    // ������ ����������� ���� ������ � �������
    property TileNameGenerator: ITileFileNameGeneratorsList read FTileNameGenerator;
    // ���� � ������� �����
    property MarkIconsPath: string read GetMarkIconsPath;
    // ��� ����� � �������
    property MarksFileName: string read GetMarksFileName;
    // ��� ��������� ����� ����� � �������
    property MarksBackUpFileName: string read GetMarksBackUpFileName;

    // ��� ����� � ����������� �����
    property MarksCategoryFileName: string read GetMarksCategoryFileName;
    // ��� ��������� ����� ����� � ����������� �����
    property MarksCategoryBackUpFileName: string read GetMarksCategoryBackUpFileName;
    // ���� � ����� � �������
    property MapsPath: string read GetMapsPath;
    // ���� � ����� � �������
    property TrackLogPath: string read GetTrackLogPath;
    // ��� ����� �� �������� �� ���������
    property HelpFileName: string read GetHelpFileName;
    // ��� ��������� ����� ������������
    property MainConfigFileName: string read GetMainConfigFileName;
    // �������� ����� ��������� ������. ������������, ������ ����� ����� ����� ���� �����������.
    property BitmapTypeManager: IBitmapTypeExtManager read FBitmapTypeManager;
    property MapCalibrationList: IInterfaceList read FMapCalibrationList;
    property KmlLoader: IKmlInfoSimpleLoader read FKmlLoader;
    property KmzLoader: IKmlInfoSimpleLoader read FKmzLoader;

    property GCThread: TGarbageCollectorThread read FGCThread;
    constructor Create;
    destructor Destroy; override;
    procedure IncrementDownloaded(ADwnSize: Currency; ADwnCnt: Cardinal);
    procedure StopAllThreads;
  end;

const
  SASVersion='100222';
  CProgram_Lang_Default = LANG_RUSSIAN;

var
  GState: TGlobalState;
implementation

uses
  SysUtils,
  pngimage,
  i_IListOfObjectsWithTTL,
  u_ListOfObjectsWithTTL,
  u_BitmapTypeExtManagerSimple,
  u_MapCalibrationListBasic,
  u_KmlInfoSimpleParser,
  u_KmzInfoSimpleParser,
  u_TileFileNameGeneratorsSimpleList;

{ TGlobalState }

constructor TGlobalState.Create;
var
  VList: IListOfObjectsWithTTL;
begin
  FDwnCS := TCriticalSection.Create;
  All_Dwn_Kb := 0;
  All_Dwn_Tiles := 0;
  InetConnect := TInetConnect.Create;
  ProgramPath := ExtractFilePath(ParamStr(0));
  MainIni := TMeminifile.Create(MainConfigFileName);
  FMemFileCache := TMemFileCache.Create;
  MainFileCache := FMemFileCache;
  FTileNameGenerator := TTileFileNameGeneratorsSimpleList.Create;
  FBitmapTypeManager := TBitmapTypeExtManagerSimple.Create;
  FMapCalibrationList := TMapCalibrationListBasic.Create;
  FKmlLoader := TKmlInfoSimpleParser.Create;
  FKmzLoader := TKmzInfoSimpleParser.Create;
  VList := TListOfObjectsWithTTL.Create;
  FGCThread := TGarbageCollectorThread.Create(VList, 1000);
  LoadMainParams;
  LoadResources;
  LoadMarkIcons;
end;

destructor TGlobalState.Destroy;
begin
  FGCThread.Terminate;
  FGCThread.WaitFor;
  FreeAndNil(FGCThread);
  FreeAndNil(FDwnCS);
  MainIni.UpdateFile;
  FreeAndNil(MainIni);
  FreeMarkIcons;
  FreeAndNil(GOToSelIcon);
  FreeAndNil(InetConnect);
  FMemFileCache := nil;
  MainFileCache := nil;
  FTileNameGenerator := nil;
  FBitmapTypeManager := nil;
  FMapCalibrationList := nil;
  FKmlLoader := nil;
  FKmzLoader := nil;
  sat_map_both := nil;
  FreeAllMaps;
  inherited;
end;

function TGlobalState.GetMarkIconsPath: string;
begin
  Result := ProgramPath + 'marksicons\';
end;

function TGlobalState.GetMarksBackUpFileName: string;
begin
  Result := ProgramPath + 'marks.~sml';
end;
function TGlobalState.GetMarksFileName: string;
begin
  Result := ProgramPath + 'marks.sml';
end;


function TGlobalState.GetMarksCategoryBackUpFileName: string;
begin
  Result := ProgramPath + 'Categorymarks.~sml';
end;

function TGlobalState.GetMarksCategoryFileName: string;
begin
  Result := ProgramPath + 'Categorymarks.sml';
end;

function TGlobalState.GetMapsPath: string;
begin
  Result := ProgramPath + 'Maps\';
end;

function TGlobalState.GetTrackLogPath: string;
begin
  Result := ProgramPath + 'TrackLog\';
end;

function TGlobalState.GetHelpFileName: string;
begin
  Result := ProgramPath + 'help.chm';
end;

function TGlobalState.GetMainConfigFileName: string;
begin
  Result := ChangeFileExt(ParamStr(0), '.ini');
end;

procedure TGlobalState.LoadMarkIcons;
var
  SearchRec: TSearchRec;
  VPng: TPNGObject;
begin
  MarkIcons := TStringList.Create;
  if FindFirst(MarkIconsPath +'*.png', faAnyFile, SearchRec) = 0 then begin
    try
      repeat
        if (SearchRec.Attr and faDirectory) <> faDirectory then begin
          VPng := TPNGObject.Create;
          VPng.LoadFromFile(MarkIconsPath+SearchRec.Name);
          MarkIcons.AddObject(SearchRec.Name, VPng);
        end;
      until FindNext(SearchRec) <> 0;
    finally
      FindClose(SearchRec);
    end;
  end;
end;

procedure TGlobalState.IncrementDownloaded(ADwnSize: Currency;
  ADwnCnt: Cardinal);
begin
  FDwnCS.Acquire;
  try
    All_Dwn_Kb := All_Dwn_Kb + ADwnSize;
    All_Dwn_Tiles := All_Dwn_Tiles + ADwnCnt;
  finally
    FDwnCS.Release;
  end;
end;

procedure TGlobalState.LoadResources;
var
  b: TPNGObject;
begin
 b := TPNGObject.Create;
 try
   b.LoadFromResourceName(HInstance, 'ICONIII');
   GOToSelIcon := TBitmap32.Create;
   PNGintoBitmap32(GOToSelIcon, b);
   GOToSelIcon.DrawMode := dmBlend;
 finally
   FreeAndNil(b);
 end;
end;

procedure TGlobalState.FreeAllMaps;
var
  i: integer;
begin
  for i := 0 to Length(MapType) - 1 do begin
    FreeAndNil(MapType[i]);
  end;
  MapType := nil;
end;

procedure TGlobalState.FreeMarkIcons;
var
  i: integer;
begin
  for i := 0 to MarkIcons.Count - 1 do begin
    MarkIcons.Objects[i].Free;
  end;
  FreeAndNil(MarkIcons);
end;

procedure TGlobalState.LoadMainParams;
var
  loc:integer;
begin
  if SysLocale.PriLangID <> CProgram_Lang_Default then begin
    loc := LANG_ENGLISH;
  end else begin
    loc := CProgram_Lang_Default;
  end;
  Localization := MainIni.Readinteger('VIEW','localization',loc);
  WebReportToAuthor := MainIni.ReadBool('NPARAM','stat',true);
end;

procedure TGlobalState.SetScreenSize(const Value: TPoint);
begin
  FScreenSize := Value;
end;

procedure TGlobalState.SetCacheElemensMaxCnt(const Value: integer);
begin
  FCacheElemensMaxCnt := Value;
  FMemFileCache.CacheElemensMaxCnt:= FCacheElemensMaxCnt;
end;

procedure TGlobalState.StopAllThreads;
begin
  FGCThread.Terminate;
end;

end.
