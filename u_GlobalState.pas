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
  i_ActiveMapsConfigSaveLoad,
  i_IBitmapLayerProvider,
  u_GarbageCollectorThread,
  u_GeoToStr,
  u_MapViewPortState,
  Uimgfun,
  UMapType,
  u_MemFileCache,
  u_GlobalCahceConfig;

type
  TSrchType = (stGoogle,stYandex);

  TGlobalState = class
  private
    FViewState: TMapViewPortState;
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
    FMapConfigSaver: IActiveMapsConfigSaver;
    FMapConfigLoader: IActiveMapsConfigLoader;
    FCacheConfig: TGlobalCahceConfig;
    FMarksBitmapProvider: IBitmapLayerProvider;

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
    //������������ ���������� ������������� ����� �����
    GPS_NumTrackPoints: integer;
    //��������/���������� ������ �������� ��� �����������/���������� GPS
    GPS_SensorsAutoShow: boolean;
    //������ ��� NMEA
    GPS_NMEALog:boolean;

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


    // ���������� ����� ��� ���������� ���� ��� ������
    ShowHintOnMarks: Boolean;

    // �������� ���������� ������ �������� ����

    FullScrean: Boolean;

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

    // ������� ���������� ��������� ��� ��������� � ��������.
    LastSelectionPolygon: TExtendedPointArray;
    // �������, �� ������� ���� ��������� ���������
    poly_zoom_save: byte;

    property CacheConfig: TGlobalCahceConfig read FCacheConfig;
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
    property MarksBitmapProvider: IBitmapLayerProvider read FMarksBitmapProvider;

    property GCThread: TGarbageCollectorThread read FGCThread;
    property ViewState: TMapViewPortState read FViewState;
    constructor Create;
    destructor Destroy; override;
    procedure IncrementDownloaded(ADwnSize: Currency; ADwnCnt: Cardinal);
    procedure StopAllThreads;
    procedure InitViewState(AMainMap: TMapType; AZoom: Byte; ACenterPos: TPoint; AScreenSize: TPoint);
    procedure LoadBitmapFromRes(const Name: String; Abmp: TCustomBitmap32);
    procedure LoadBitmapFromJpegRes(const Name: String; Abmp: TCustomBitmap32);
  end;

const
  SASVersion='100830.alfa';
  CProgram_Lang_Default = LANG_RUSSIAN;

var
  GState: TGlobalState;
implementation

uses
  SysUtils,
  i_MapTypes,
  i_BitmapTileSaveLoad,
  u_MapTypeBasic,
  u_MapTypeListGeneratorFromFullListBasic,
  u_MapsConfigInIniFileSection,
  i_IListOfObjectsWithTTL,
  u_ListOfObjectsWithTTL,
  u_BitmapTypeExtManagerSimple,
  u_MapCalibrationListBasic,
  u_KmlInfoSimpleParser,
  u_KmzInfoSimpleParser,
  u_MapMarksBitmapLayerProviderStuped,
  u_TileFileNameGeneratorsSimpleList;

{ TGlobalState }

constructor TGlobalState.Create;
var
  VList: IListOfObjectsWithTTL;
  VConfigLoadSave: TMapsConfigInIniFileSection;
begin
  FDwnCS := TCriticalSection.Create;
  FCacheConfig := TGlobalCahceConfig.Create;
  All_Dwn_Kb := 0;
  All_Dwn_Tiles := 0;
  InetConnect := TInetConnect.Create;
  ProgramPath := ExtractFilePath(ParamStr(0));
  MainIni := TMeminifile.Create(MainConfigFileName);

  VConfigLoadSave := TMapsConfigInIniFileSection.Create(MainIni, 'MainViewMaps');
  FMapConfigSaver := VConfigLoadSave;
  FMapConfigLoader := VConfigLoadSave;

  FMemFileCache := TMemFileCache.Create;
  MainFileCache := FMemFileCache;
  FTileNameGenerator := TTileFileNameGeneratorsSimpleList.Create;
  FBitmapTypeManager := TBitmapTypeExtManagerSimple.Create;
  FMapCalibrationList := TMapCalibrationListBasic.Create;
  FKmlLoader := TKmlInfoSimpleParser.Create;
  FKmzLoader := TKmzInfoSimpleParser.Create;
  VList := TListOfObjectsWithTTL.Create;
  FGCThread := TGarbageCollectorThread.Create(VList, 1000);
  FMarksBitmapProvider := TMapMarksBitmapLayerProviderStuped.Create;
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
  FMapConfigSaver := nil;
  FMapConfigLoader := nil;
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
  FMarksBitmapProvider := nil;
  FreeAndNil(FViewState);
  FreeAllMaps;
  FreeAndNil(FCacheConfig);
  inherited;
end;

function TGlobalState.GetMarkIconsPath: string;
begin
  Result := ProgramPath + 'marksicons' + PathDelim;
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
  Result := ProgramPath + 'Maps' + PathDelim;
end;

function TGlobalState.GetTrackLogPath: string;
begin
  Result := ProgramPath + 'TrackLog' + PathDelim;
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
  Vbmp: TCustomBitmap32;
  VLoader: IBitmapTileLoader;
begin
  MarkIcons := TStringList.Create;
  VLoader := FBitmapTypeManager.GetBitmapLoaderForExt('.png');
  if FindFirst(MarkIconsPath +'*.png', faAnyFile, SearchRec) = 0 then begin
    try
      repeat
        if (SearchRec.Attr and faDirectory) <> faDirectory then begin
          Vbmp := TCustomBitmap32.Create;
          VLoader.LoadFromFile(MarkIconsPath+SearchRec.Name, Vbmp);
          MarkIcons.AddObject(SearchRec.Name, Vbmp);
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
begin
  GOToSelIcon := TBitmap32.Create;
  GOToSelIcon.DrawMode := dmBlend;
  LoadBitmapFromRes('ICONIII', GOToSelIcon);
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

procedure TGlobalState.LoadBitmapFromRes(const Name: String; Abmp: TCustomBitmap32);
var
  ResStream: TResourceStream;
  VImageLoader: IBitmapTileLoader;
begin
  VImageLoader := FBitmapTypeManager.GetBitmapLoaderForExt('.png');
  {Creates an especial stream to load from the resource}
  ResStream := TResourceStream.Create(HInstance, Name, RT_RCDATA);

  {Loads the png image from the resource}
  try
    VImageLoader.LoadFromStream(ResStream, Abmp);
  finally
    ResStream.Free;
  end;
end;

procedure TGlobalState.LoadBitmapFromJpegRes(const Name: String; Abmp: TCustomBitmap32);
var
  ResStream: TResourceStream;
  VImageLoader: IBitmapTileLoader;
begin
  VImageLoader := FBitmapTypeManager.GetBitmapLoaderForExt('.jpg');
  {Creates an especial stream to load from the resource}
  ResStream := TResourceStream.Create(HInstance, Name, RT_RCDATA);

  {Loads the png image from the resource}
  try
    VImageLoader.LoadFromStream(ResStream, Abmp);
  finally
    ResStream.Free;
  end;
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

procedure TGlobalState.InitViewState(AMainMap: TMapType; AZoom: Byte;
  ACenterPos, AScreenSize: TPoint);
var
  VMapsList: IMapTypeList;
  VLayersList: IMapTypeList;
  VListFactory: IMapTypeListFactory;
  VItemFactory: IMapTypeFactory;
begin
  if FViewState = nil then begin
    VItemFactory := TMapTypeBasicFactory.Create;

    VListFactory := TMapTypeListGeneratorFromFullListBasic.Create(True, VItemFactory);
    VMapsList := VListFactory.CreateList;

    VListFactory := TMapTypeListGeneratorFromFullListBasic.Create(False, VItemFactory);
    VLayersList := VListFactory.CreateList;

    FViewState := TMapViewPortState.Create(VMapsList, VLayersList, AMainMap, AZoom, ACenterPos, AScreenSize, FMapConfigSaver, FMapConfigLoader);
  end else begin
    raise Exception.Create('��������� ������������� ������� ��������� ������������� ���� �����');
  end;
end;

end.
