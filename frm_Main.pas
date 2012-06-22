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

unit frm_Main; 

interface

uses
  Windows,
  Types,
  Messages,
  SysUtils,
  Forms,
  ShellApi,
  Classes,
  Menus,
  Variants,
  ActiveX,
  ShlObj,
  ComObj,
  Graphics,
  StdCtrls,
  OleCtrls,
  Controls,
  ExtCtrls,
  Buttons,
  Dialogs,
  Spin,
  ImgList,
  ComCtrls,
  GR32,
  GR32_Layers,
  GR32_Image,
  TB2Item,
  TB2Dock,
  TB2Toolbar,
  TB2ExtItems,
  TB2ToolWindow,
  TBXToolPals,
  TBX,
  TBXDkPanels,
  TBXExtItems,
  TBXGraphics,
  TBXSASTheme,
  u_CommonFormAndFrameParents,
  i_JclNotify,
  i_GUIDSet,
  t_GeoTypes,
  t_FillingMapModes,
  i_JclListenerNotifierLinksList,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_TileError,
  i_TileErrorLogProviedrStuped,
  i_MapVersionInfo,
  u_GeoToStr,
  t_CommonTypes,
  i_GPS,
  i_GPSRecorder,
  i_GeoCoder,
  i_MapTypeConfigModalEdit,
  i_MapTypeHotKeyListStatic,
  i_MarksSimple,
  i_MainFormConfig,
  i_SearchResultPresenter,
  i_MainWindowPosition,
  i_SelectionRect,
  i_LineOnMapEdit,
  i_PointOnMapEdit,
  i_PathDetalizeProvider,
  i_MapTypeIconsList,
  i_MessageHandler,
  i_MouseState,
  i_MainFormState,
  i_MouseHandler,
  i_TreeChangeable,
  i_MapViewGoto,
  i_StaticTreeItem,
  i_MenuGeneratorByTree,
  u_WindowLayerBasicList,
  u_GeoFun,
  u_MapLayerWiki,
  u_MapType,
  u_ResStrings,
  u_ShortcutManager,
  u_MapMainLayer,
  u_MapMainLayerNew,
  u_LayerStatBar,
  u_LayerScaleLine,
  u_MapMarksLayer,
  u_MapGPSLayer,
  u_MapGPSLayerNew,
  u_MapLayerNavToMark,
  u_MapLayerSearchResults,
  u_MapLayerFillingMap,
  u_MapLayerFillingMapNew,
  u_MiniMapLayer,
  u_MapLayerGrids,
  u_MapLayerTileGrid,
  u_MapLayerGoto,
  u_MapLayerShowError,
  u_CenterScale,
  u_SelectionLayer,
  u_CalcLineLayer,
  u_SelectionPolylineLayer,
  u_SelectionRectLayer,
  u_MapLayerGPSMarker,
  u_MarksDbGUIHelper,
  frm_About,
  frm_Settings,
  frm_RegionProcess,
  frm_DGAvailablePic,
  frm_MarksExplorer,
  frm_CacheManager,
  frm_GoTo;

type
  TfrmMain = class(TCommonFormParent)
    map: TImage32;
    OpenDialog1: TOpenDialog;
    SaveLink: TSaveDialog;
    TBDock: TTBXDock;
    TBMainToolBar: TTBXToolbar;
    TBDockBottom: TTBXDock;
    TBDockLeft: TTBXDock;
    SrcToolbar: TTBXToolbar;
    TBMarksToolbar: TTBXToolbar;
    GPSToolbar: TTBXToolbar;
    TBExit: TTBXToolbar;
    ZoomToolBar: TTBXToolbar;
    TBControlItem2: TTBControlItem;
    labZoom: TLabel;
    TBDockRight: TTBXDock;
    TBXSeparatorItem1: TTBXSeparatorItem;
    TBXSeparatorItem2: TTBXSeparatorItem;
    TBXSeparatorItem3: TTBXSeparatorItem;
    TBXMainMenu: TTBXToolbar;
    NSMB: TTBXSubmenuItem;
    NLayerSel: TTBXSubmenuItem;
    NOperations: TTBXSubmenuItem;
    NView: TTBXSubmenuItem;
    NSources: TTBXSubmenuItem;
    NMarks: TTBXSubmenuItem;
    tbsbmGPS: TTBXSubmenuItem;
    NParams: TTBXSubmenuItem;
    NLayerParams: TTBXSubmenuItem;
    tbsbmHelp: TTBXSubmenuItem;
    NSRCic: TTBXItem;
    NSRCinet: TTBXItem;
    NSRCesh: TTBXItem;
    TBGPSconn: TTBXItem;
    TBGPSPath: TTBXSubmenuItem;
    TBSrc: TTBXSubmenuItem;
    TBSMB: TTBXSubmenuItem;
    TBLayerSel: TTBXSubmenuItem;
    TBFullSize: TTBXItem;
    TBmove: TTBXItem;
    TBCalcRas: TTBXItem;
    TBRectSave: TTBXSubmenuItem;
    TBMapZap: TTBXSubmenuItem;
    TBGoTo: TTBXSubmenuItem;
    TBZoomIn: TTBXItem;
    TBZoom_out: TTBXItem;
    tbitmCreateShortcut: TTBXItem;
    NZoomIn: TTBXItem;
    NZoomOut: TTBXItem;
    tbitmGoToModal: TTBXItem;
    NCalcRast: TTBXItem;
    tbitmCacheManager: TTBXItem;
    tbitmQuit: TTBXItem;
    tbitmGPSTrackSaveToMarks: TTBXItem;
    TBItemDelTrack: TTBXItem;
    NFoolSize: TTBXItem;
    NGoToCur: TTBXItem;
    Nbackload: TTBXItem;
    NbackloadLayer: TTBXItem;
    Nanimate: TTBXItem;
    tbitmGauge: TTBXItem;
    Ninvertcolor: TTBXItem;
    NPanels: TTBXSubmenuItem;
    tbsbmInterface: TTBXSubmenuItem;
    NFillMap: TTBXSubmenuItem;
    TBFillingTypeMap: TTBXSubmenuItem;
    TBXToolPalette1: TTBXToolPalette;
    NShowGran: TTBXSubmenuItem;
    tbsbmGenShtabScale: TTBXSubmenuItem;
    NGShScale0: TTBXItem;
    NGShScale1000000: TTBXItem;
    NGShScale500000: TTBXItem;
    NGShScale200000: TTBXItem;
    NGShScale100000: TTBXItem;
    NGShScale50000: TTBXItem;
    NGShScale25000: TTBXItem;
    NGShScale10000: TTBXItem;
    tbitmOnlineHelp: TTBXItem;
    tbitmAbout: TTBXItem;
    tbitmOnlineHome: TTBXItem;
    tbitmOnlineForum: TTBXItem;
    NMapParams: TTBXItem;
    tbitmOptions: TTBXItem;
    TBLang: TTBXSubmenuItem;
    tbitmGPSConnect: TTBXItem;
    tbitmGPSTrackShow: TTBXItem;
    tbitmGPSCenterMap: TTBXItem;
    tbitmSaveCurrentPosition: TTBXItem;
    tbitmGPSTrackSaveToDb: TTBXItem;
    tbitmGPSTrackClear: TTBXItem;
    Showstatus: TTBXItem;
    ShowMiniMap: TTBXItem;
    ShowLine: TTBXItem;
    N000: TTBXItem;
    N001: TTBXItem;
    N002: TTBXItem;
    N003: TTBXItem;
    N004: TTBXItem;
    N005: TTBXItem;
    N006: TTBXItem;
    N007: TTBXItem;
    TBXExit: TTBXItem;
    TBXSeparatorItem4: TTBXSeparatorItem;
    TBXSeparatorItem5: TTBXSeparatorItem;
    TBXSeparatorItem6: TTBXSeparatorItem;
    TBXSeparatorItem7: TTBXSeparatorItem;
    TBXSeparatorItem8: TTBXSeparatorItem;
    NRectSave: TTBXSubmenuItem;
    TBXSeparatorItem9: TTBXSeparatorItem;
    TBXSeparatorItem10: TTBXSeparatorItem;
    TBXSeparatorItem11: TTBXSeparatorItem;
    tbsprtGPS1: TTBXSeparatorItem;
    TBXSeparatorItem14: TTBXSeparatorItem;
    tbsprtHelp01: TTBXSeparatorItem;
    TBXSensorsBar: TTBXToolWindow;
    ScrollBox1: TScrollBox;
    TBXDock1: TTBXDock;
    NSensors: TTBXSubmenuItem;
    TBXPopupMenuSensors: TTBXPopupMenu;
    tbitmSaveCurrentPositionToolbar: TTBXItem;
    TBXSeparatorItem16: TTBXSeparatorItem;
    TBXSeparatorItem17: TTBXSeparatorItem;
    TBXToolBarSearch: TTBXToolbar;
    TBXSelectSrchType: TTBXSubmenuItem;
    tbsprtGPS2: TTBXSeparatorItem;
    tbitmPositionByGSM: TTBXItem;
    tbitmOpenFile: TTBXItem;
    OpenSessionDialog: TOpenDialog;
    NShowSelection: TTBXItem;
    TBRECT: TTBXItem;
    TBREGION: TTBXItem;
    TBCOORD: TTBXItem;
    TBPrevious: TTBXItem;
    TBLoadSelFromFile: TTBXItem;
    TBGPSToPoint: TTBXSubmenuItem;
    TBGPSToPointCenter: TTBXItem;
    tbitmGPSToPointCenter: TTBXItem;
    tbtmHelpBugTrack: TTBXItem;
    tbitmShowDebugInfo: TTBXItem;
    PanelsImageList: TTBXImageList;
    ZSlider: TImage32;
    TBControlItem1: TTBControlItem;
    TBXPopupPanels: TTBXPopupMenu;
    MenusImageList: TTBXImageList;
    ScalesImageList: TTBXImageList;
    MainPopupMenu: TTBXPopupMenu;
    NMarkEdit: TTBXItem;
    NMarkDel: TTBXItem;
    NMarkOper: TTBXItem;
    NMarkNav: TTBXItem;
    NMarkExport: TTBXItem;
    NMarksCalcs: TTBXSubmenuItem;
    NMarksCalcsLen: TTBXItem;
    NMarksCalcsPer: TTBXItem;
    NMarksCalcsSq: TTBXItem;
    tbsprtMainPopUp0: TTBXSeparatorItem;
    NaddPoint: TTBXItem;
    tbsprtMainPopUp1: TTBXSeparatorItem;
    tbitmCenterWithZoom: TTBXSubmenuItem;
    tbsprtMainPopUp2: TTBXSeparatorItem;
    tbitmCopyToClipboard: TTBXSubmenuItem;
    Google1: TTBXItem;
    YaLink: TTBXItem;
    kosmosnimkiru1: TTBXItem;
    livecom1: TTBXItem;
    tbsprtCopyToClipboard0: TTBXSeparatorItem;
    tbitmCopyToClipboardMainMapUrl: TTBXItem;
    tbitmCopyToClipboardCoordinates: TTBXItem;
    tbitmCopyToClipboardMainMapTile: TTBXItem;
    tbitmCopyToClipboardMainMapTileFileName: TTBXItem;
    Nopendir: TTBXItem;
    tbitmOpenFolderMainMapTile: TTBXItem;
    tbsprtMainPopUp3: TTBXSeparatorItem;
    tbitmAdditionalOperations: TTBXSubmenuItem;
    NGTOPO30: TTBXItem;
    NSRTM3: TTBXItem;
    tbsprtAdditionalOperations1: TTBXSeparatorItem;
    DigitalGlobe1: TTBXItem;
    tbsprtAdditionalOperations0: TTBXSeparatorItem;
    tbsprtMainPopUp4: TTBXSeparatorItem;
    tbitmDownloadMainMapTile: TTBXItem;
    NDel: TTBXItem;
    tbsprtMainPopUp5: TTBXSeparatorItem;
    NMapInfo: TTBXItem;
    ldm: TTBXSubmenuItem;
    dlm: TTBXSubmenuItem;
    tbtpltCenterWithZoom: TTBXToolPalette;
    TBOpenDirLayer: TTBXSubmenuItem;
    TBCopyLinkLayer: TTBXSubmenuItem;
    TBLayerInfo: TTBXSubmenuItem;
    TBScreenSelect: TTBXItem;
    NMainToolBarShow: TTBXVisibilityToggleItem;
    NZoomToolBarShow: TTBXVisibilityToggleItem;
    NsrcToolBarShow: TTBXVisibilityToggleItem;
    NGPSToolBarShow: TTBXVisibilityToggleItem;
    TBXVisibilityToggleItem1: TTBXVisibilityToggleItem;
    TBXVisibilityToggleItem2: TTBXVisibilityToggleItem;
    TBXSeparatorItem13: TTBXSeparatorItem;
    TBXSeparatorItem18: TTBXSeparatorItem;
    NBlock_toolbars: TTBXItem;
    TBXSeparatorItem19: TTBXSeparatorItem;
    tbitmGPSOptions: TTBXItem;
    TrayIcon: TTrayIcon;
    TrayPopupMenu: TTBXPopupMenu;
    TrayItemRestore: TTBItem;
    TBSeparatorItem1: TTBSeparatorItem;
    TrayItemQuit: TTBItem;
    NAnimateMove: TTBXItem;
    tbiSearch: TTBXComboBoxItem;
    NSearchResults: TTBXVisibilityToggleItem;
    TBSearchWindow: TTBXDockablePanel;
    PanelSearch: TPanel;
    TBXDockForSearch: TTBXDock;
    ScrollBoxSearchWindow: TScrollBox;
    TBPolylineSelect: TTBXItem;
    TBEditPath: TTBXToolbar;
    TBEditPathDel: TTBXItem;
    TBEditPathLabel: TTBXItem;
    TBEditMagnetDraw: TTBXItem;
    TBEditSelectPolylineRadiusCap1: TTBXLabelItem;
    TBControlItem4: TTBControlItem;
    TBEditSelectPolylineRadiusCap2: TTBXLabelItem;
    TBEditPathMarsh: TTBXSubmenuItem;
    TBEditPathOk: TTBXItem;
    TBEditSelectPolylineRadius: TSpinEdit;
    tbitmShowMarkCaption: TTBXItem;
    NMarksGroup: TTBGroupItem;
    TBAdd_Point: TTBXItem;
    TBAdd_Line: TTBXItem;
    TBAdd_Poly: TTBXItem;
    TBXSeparatorItem12: TTBXSeparatorItem;
    tbitmPlacemarkManager: TTBXItem;
    TBHideMarks: TTBXItem;
    osmorg1: TTBXItem;
    TBXSeparatorItem20: TTBXSeparatorItem;
    NFillMode3: TTBXItem;
    NFillMode2: TTBXItem;
    NFillMode1: TTBXItem;
    TBXSeparatorItem21: TTBXSeparatorItem;
    NShowFillDates: TTBXItem;
    FillDates: TTBXToolbar;
    TBControlItem7: TTBControlItem;
    TBControlItem6: TTBControlItem;
    TBControlItem8: TTBControlItem;
    TBControlItem9: TTBControlItem;
    Label1: TLabel;
    Label2: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    TBXVisibilityToggleItem3: TTBXVisibilityToggleItem;
    DegreedLinesSubMenu: TTBXSubmenuItem;
    NDegScale10000: TTBXItem;
    NDegScale25000: TTBXItem;
    NDegScale50000: TTBXItem;
    NDegScale100000: TTBXItem;
    NDegScale200000: TTBXItem;
    NDegScale500000: TTBXItem;
    NDegScale1000000: TTBXItem;
    NDegScale0: TTBXItem;
    TBXSeparatorItem22: TTBXSeparatorItem;
    NDegScaleUser: TTBXItem;
    NDegValue: TTBXEditItem;
    TBSeparatorItem2: TTBSeparatorItem;
    NDegScaleAuto: TTBXItem;
    nokiamapcreator1: TTBXItem;
    tbpmiVersions: TTBXSubmenuItem;
    tbpmiClearVersion: TTBXItem;
    tbitmTileGrid1p: TTBXItem;
    tbitmTileGrid2p: TTBXItem;
    tbitmTileGrid3p: TTBXItem;
    tbitmTileGrid4p: TTBXItem;
    tbitmTileGrid5p: TTBXItem;
    terraserver1: TTBXItem;
    tbitmNavigationArrow: TTBXItem;
    tbitmProperties: TTBXItem;
    tbitmFitToScreen: TTBXItem;
    tbitmEditLastSelection: TTBXItem;
    tbitmHideThisMark: TTBXItem;
    tbitmSaveMark: TTBXSubmenuItem;
    tbitmSaveMarkAsNew: TTBXItem;

    procedure FormActivate(Sender: TObject);
    procedure NzoomInClick(Sender: TObject);
    procedure NZoomOutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TBZoom_outClick(Sender: TObject);
    procedure TBZoomInClick(Sender: TObject);
    procedure TBmoveClick(Sender: TObject);
    procedure TBFullSizeClick(Sender: TObject);
    procedure NCalcRastClick(Sender: TObject);
    procedure tbitmQuitClick(Sender: TObject);
    procedure ZoomToolBarDockChanging(Sender: TObject; Floating: Boolean; DockingTo: TTBDock);
    procedure tbitmOptionsClick(Sender: TObject);
    procedure NbackloadClick(Sender: TObject);
    procedure NaddPointClick(Sender: TObject);
    procedure tbitmCopyToClipboardMainMapTileClick(Sender: TObject);
    procedure tbitmCopyToClipboardMainMapTileFileNameClick(Sender: TObject);
    procedure tbitmDownloadMainMapTileClick(Sender: TObject);
    procedure NopendirClick(Sender: TObject);
    procedure tbitmOpenFolderMainMapTileClick(Sender: TObject);
    procedure NDelClick(Sender: TObject);
    procedure TBREGIONClick(Sender: TObject);
    procedure NShowGranClick(Sender: TObject);
    procedure NFillMapClick(Sender: TObject);
    procedure NSRCinetClick(Sender: TObject);
    procedure tbitmAboutClick(Sender: TObject);
    procedure TBRECTClick(Sender: TObject);
    procedure TBRectSaveClick(Sender: TObject);
    procedure TBPreviousClick(Sender: TObject);
    procedure TBCalcRasClick(Sender: TObject);
    procedure tbitmOnlineHelpClick(Sender: TObject);
    procedure TBSubmenuItem1Click(Sender: TObject);
    procedure N000Click(Sender: TObject);
    procedure TrayItemQuitClick(Sender: TObject);
    procedure TBGPSconnClick(Sender: TObject);
    procedure TBGPSPathClick(Sender: TObject);
    procedure TBGPSToPointClick(Sender: TObject);
    procedure tbitmCopyToClipboardCoordinatesClick(Sender: TObject);
    procedure TBCOORDClick(Sender: TObject);
    procedure ShowstatusClick(Sender: TObject);
    procedure ShowMiniMapClick(Sender: TObject);
    procedure ShowLineClick(Sender: TObject);
    procedure tbitmGaugeClick(Sender: TObject);
    procedure Google1Click(Sender: TObject);
    procedure mapResize(Sender: TObject);
    procedure TBLoadSelFromFileClick(Sender: TObject);
    procedure YaLinkClick(Sender: TObject);
    procedure kosmosnimkiru1Click(Sender: TObject);
    procedure NinvertcolorClick(Sender: TObject);
    procedure mapDblClick(Sender: TObject);
    procedure TBAdd_PointClick(Sender: TObject);
    procedure TBAdd_LineClick(Sender: TObject);
    procedure TBAdd_PolyClick(Sender: TObject);
    procedure tbitmGPSTrackSaveToMarksClick(Sender: TObject);
    procedure NMarkEditClick(Sender: TObject);
    procedure NMarkDelClick(Sender: TObject);
    procedure NMarkOperClick(Sender: TObject);
    procedure livecom1Click(Sender: TObject);
    procedure tbitmCopyToClipboardMainMapUrlClick(Sender: TObject);
    procedure DigitalGlobe1Click(Sender: TObject);
    procedure mapMouseLeave(Sender: TObject);
    procedure NMapParamsClick(Sender: TObject);
    procedure mapMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure mapMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure mapMouseMove(Sender: TObject; Shift: TShiftState; AX, AY: Integer; Layer: TCustomLayer);
    procedure tbitmCreateShortcutClick(Sender: TObject);
    procedure TBItemDelTrackClick(Sender: TObject);
    procedure NGShScale01Click(Sender: TObject);
    procedure TBEditPathDelClick(Sender: TObject);
    procedure TBEditPathLabelClick(Sender: TObject);
    procedure TBEditPathSaveClick(Sender: TObject);
    procedure TBEditPathClose(Sender: TObject);
    procedure tbitmOnlineForumClick(Sender: TObject);
    procedure tbitmOnlineHomeClick(Sender: TObject);
    procedure tbitmPlacemarkManagerClick(Sender: TObject);
    procedure NSRTM3Click(Sender: TObject);
    procedure NGTOPO30Click(Sender: TObject);
    procedure NMarkNavClick(Sender: TObject);
    procedure AdjustFont(Item: TTBCustomItem; Viewer: TTBItemViewer; Font: TFont; StateFlags: Integer);
    procedure NMarksCalcsLenClick(Sender: TObject);
    procedure NMarksCalcsSqClick(Sender: TObject);
    procedure NMarksCalcsPerClick(Sender: TObject);
    procedure TBEditPathOkClick(Sender: TObject);
    procedure NMapInfoClick(Sender: TObject);
    procedure TBXToolPalette1CellClick(Sender: TTBXCustomToolPalette;var ACol, ARow: Integer; var AllowChange: Boolean);
    procedure NanimateClick(Sender: TObject);
    procedure NbackloadLayerClick(Sender: TObject);
    procedure TBXSensorsBarVisibleChanged(Sender: TObject);
    procedure tbitmSaveCurrentPositionClick(Sender: TObject);
    procedure TBXSearchEditAcceptText(Sender: TObject; var NewText: String;
      var Accept: Boolean);
    procedure tbitmPositionByGSMClick(Sender: TObject);
    procedure tbitmOpenFileClick(Sender: TObject);
    procedure NShowSelectionClick(Sender: TObject);
    procedure NGoToCurClick(Sender: TObject);
    procedure TBGPSToPointCenterClick(Sender: TObject);
    procedure tbtmHelpBugTrackClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure tbitmShowDebugInfoClick(Sender: TObject);
    procedure NMarkExportClick(Sender: TObject);
    procedure TBHideMarksClick(Sender: TObject);
    procedure ZSliderMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; Layer: TCustomLayer);
    procedure ZSliderMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure MainPopupMenuPopup(Sender: TObject);
    procedure tbtpltCenterWithZoomCellClick(Sender: TTBXCustomToolPalette; var ACol,
      ARow: Integer; var AllowChange: Boolean);
    procedure TBScreenSelectClick(Sender: TObject);
    procedure NSensorsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NBlock_toolbarsClick(Sender: TObject);
    procedure tbitmGPSOptionsClick(Sender: TObject);
    procedure TrayItemRestoreClick(Sender: TObject);
    procedure tbitmShowMarkCaptionClick(Sender: TObject);
    procedure NAnimateMoveClick(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure NParamsPopup(Sender: TTBCustomItem; FromLink: Boolean);
    procedure TBSearchWindowClose(Sender: TObject);
    procedure TBEditMagnetDrawClick(Sender: TObject);
    procedure TBPolylineSelectClick(Sender: TObject);
    procedure TBEditSelectPolylineRadiusChange(Sender: TObject);
    procedure osmorg1Click(Sender: TObject);
    procedure NFillMode1Click(Sender: TObject);
    procedure NFillMode2Click(Sender: TObject);
    procedure NFillMode3Click(Sender: TObject);
    procedure NShowFillDatesClick(Sender: TObject);
    procedure DateTimePicker1Change(Sender: TObject);
    procedure DateTimePicker2Change(Sender: TObject);
    procedure NDegScale0Click(Sender: TObject);
    procedure NDegValueAcceptText(Sender: TObject; var NewText: string;
      var Accept: Boolean);
    procedure nokiamapcreator1Click(Sender: TObject);
    procedure tbpmiVersionsPopup(Sender: TTBCustomItem; FromLink: Boolean);
    procedure tbpmiClearVersionClick(Sender: TObject);
    procedure terraserver1Click(Sender: TObject);
    procedure tbitmCacheManagerClick(Sender: TObject);
    procedure tbitmEditLastSelectionClick(Sender: TObject);
    procedure tbitmNavigationArrowClick(Sender: TObject);
    procedure tbitmPropertiesClick(Sender: TObject);
    procedure tbitmFitToScreenClick(Sender: TObject);
    procedure tbitmHideThisMarkClick(Sender: TObject);
    procedure tbitmSaveMarkAsNewClick(Sender: TObject);
  private
    FLinksList: IJclListenerNotifierLinksList;
    FConfig: IMainFormConfig;
    FGpsPosChangeCounter: Integer;
    FCenterToGPSDelta: TDoublePoint;
    FShowActivHint: boolean;
    FHintWindow: THintWindow;
    FKeyMovingHandler: IMessageHandler;
    FMouseHandler: IMouseHandler;
    FMouseState: IMouseState;
    FMarshrutComment: string;
    movepoint: boolean;

    FWikiLayer: TWikiLayer;
    FLayerMapMarks: TMapMarksLayer;
    FLayerSearchResults: TSearchResultsLayer;
    FUIDownload: IInterface;

    ProgramStart: Boolean;
    ProgramClose: Boolean;
    //FMapVersionList: IMapVersionListStatic;

    FMapTypeIcons18List: IMapTypeIconsList;
    FMapTypeIcons24List: IMapTypeIconsList;

    FNLayerParamsItemList: IGUIDObjectSet; //����� ������� ���� ���������/��������� ����
    FNDwnItemList: IGUIDObjectSet; //����� ������������ ���� ��������� ���� ����
    FNDelItemList: IGUIDObjectSet; //����� ������������ ���� ������� ���� ����
    FNOpenDirItemList: IGUIDObjectSet; //����� ������������ ���� ������� ����� ����
    FNCopyLinkItemList: IGUIDObjectSet; //����� ������������ ���� ���������� ������ �� ���� ����
    FNLayerInfoItemList: IGUIDObjectSet; //����� ������������ ���� ���������� � ����

    FShortCutManager: TShortcutManager;
    FLayersList: TWindowLayerBasicList;

    FSearchPresenter: ISearchResultPresenter;
    FMapMoving: Boolean;
    FMapMovingButton: TMouseButton;
    FMapZoomAnimtion: Boolean;
    FMapMoveAnimtion: Boolean;
    FEditMarkPoint: IMarkPoint;
    FEditMarkLine: IMarkLine;
    FEditMarkPoly: IMarkPoly;
    FState: IMainFormState;

    FWinPosition: IMainWindowPosition;

    FLineOnMapEdit: ILineOnMapEdit;
    FLineOnMapByOperation: array [TStateEnum] of ILineOnMapEdit;
    FPointOnMapEdit: IPointOnMapEdit;
    FSelectionRect: ISelectionRect;
    FMarkDBGUI: TMarksDbGUIHelper;

    FTileErrorLogger: ITileErrorLogger;
    FTileErrorLogProvider: ITileErrorLogProviedrStuped;

    FRuller:TBitmap32;
    FTumbler:TBitmap32;
    FSensorViewList: IGUIDInterfaceSet;
    FFormRegionProcess: TfrmRegionProcess;
    FfrmGoTo: TfrmGoTo;
    FfrmDGAvailablePic: TfrmDGAvailablePic;
    FfrmSettings: TfrmSettings;
    FfrmCacheManager: TfrmCacheManager;
    FfrmMarksExplorer: TfrmMarksExplorer;
    FfrmAbout: TfrmAbout;

    FPathProvidersTree: ITreeChangeable;
    FPathProvidersTreeStatic: IStaticTreeItem;
    FPathProvidersMenuBuilder: IMenuGeneratorByTree;
    FMapHotKeyList: IMapTypeHotKeyListStatic;
    FMapTypeEditor: IMapTypeConfigModalEdit;

    FMapGoto: IMapViewGoto;

    procedure InitSearchers;
    procedure LoadMapIconsList;
    procedure CreateMapUIMapsList;
    procedure CreateMapUILayersList;
    procedure CreateMapUIFillingList;
    procedure CreateMapUILayerSubMenu;
    procedure CreateLangMenu;

    procedure GPSReceiverDisconnect;
    procedure GPSReceiverStateChange;
    procedure GPSReceiverConnect;
    procedure GPSReceiverTimeout;
    procedure GPSReceiverConnectError;
    procedure GPSReceiverReceive;

    procedure OnMapGUIChange;
    procedure OnSearchhistoryChange;
    procedure OnWinPositionChange;
    procedure OnToolbarsLockChange;
    procedure OnLineOnMapEditChange;
    procedure OnPathProvidesChange;
    procedure OnNavToMarkChange;
    procedure DoMessageEvent(var Msg: TMsg; var Handled: Boolean);
    procedure WMGetMinMaxInfo(var msg: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
    procedure WMTIMECHANGE(var m: TMessage); message WM_TIMECHANGE;
    procedure zooming(ANewZoom: byte; const AMousePos: TPoint; move: boolean);
    procedure MapMoveAnimate(const AMouseMoveSpeed: TDoublePoint; const ALastTime:double; AZoom:byte; const AMousePos:TPoint);
    procedure ProcessPosChangeMessage;
    procedure CopyBtmToClipboard(btm: TBitmap);
    function GetIgnoredMenuItemsList: TList;
    procedure MapLayersVisibleChange;
    procedure OnMainFormMainConfigChange;
    procedure OnStateChange;

    procedure CopyStringToClipboard(const s: Widestring);
    procedure OnClickMapItem(Sender: TObject);
    procedure OnClickLayerItem(Sender: TObject);
    procedure OnMainMapChange;
    procedure OnFillingMapChange;
    

    procedure SafeCreateDGAvailablePic(const AVisualPoint: TPoint);

    procedure PaintZSlider(zoom:integer);
    procedure SetToolbarsLock(AValue: Boolean);

    Procedure FormMove(Var Msg: TWMMove); Message WM_MOVE;
    Procedure TrayControl(Var Msg: TMessage); Message WM_SYSCOMMAND;
    procedure OnBeforeViewChange;
    procedure OnAfterViewChange;
    procedure SaveWindowConfigToIni(const AProvider: IConfigDataWriteProvider);
    procedure DoSelectSpecialVersion(Sender: TObject);
    procedure TBEditPathMarshClick(Sender: TObject);
    procedure TBfillMapAsMainClick(Sender: TObject);
    procedure tbiEditSrchAcceptText(Sender: TObject; var NewText: String; var Accept: Boolean);
    procedure TBXSelectSrchClick(Sender: TObject);
    procedure OnMinimize(Sender: TObject);
    procedure SaveConfig(Sender: TObject);
    function ConvLatLon2Scale(const Astr:string):Double;
    function Deg2Strvalue(const aDeg:Double):string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  u_GUIDObjectSet,
  u_GlobalState,
  frm_LonLatRectEdit,
  i_OperationNotifier,
  c_ZeroGUID,
  c_SasVersion,
  c_InternalBrowser,
  u_JclListenerNotifierLinksList,
  u_TileDownloaderUIOneTile,
  u_NotifyEventListener,
  i_Bitmap32Static,
  i_MapTypes,
  i_GeoCoderList,
  i_CoordConverter,
  i_VectorItemLonLat,
  i_LocalCoordConverter,
  i_ValueToStringConverter,
  i_GUIDListStatic,
  i_ActiveMapsConfig,
  i_BitmapMarker,
  i_MapAttachmentsInfo,
  i_LanguageManager,
  i_VectorDataItemSimple,
  i_PathDetalizeProviderList,
  i_SensorViewListGenerator,
  u_SensorViewListGeneratorStuped,
  u_MainWindowPositionConfig,
  u_TileErrorLogProviedrStuped,
  u_FullMapMouseCursorLayer,
  u_PolyLineLayerBase,
  u_LineOnMapEdit,
  u_PointOnMapEdit,
  u_PointOnMapEditLayer,
  u_MapTypeIconsList,
  u_SelectionRect,
  u_KeyMovingHandler,
  u_MapViewGoto,
  u_LanguageTBXItem,
  u_MouseState,
  u_UITileDownloadList,
  u_MapTypeConfigModalEditByForm,
  i_ImportConfig,
  u_EnumDoublePointLine2Poly,
  u_BitmapMarkerProviderSimpleBase,
  u_BitmapMarkerProviderSimpleSquare,
  u_BitmapMarkerProviderSimpleArrow,
  u_BitmapMarkerProviderSimpleCross,
  u_BitmapMarkerProviderChangeableFaked,
  u_BitmapMarkerProviderStaticFromDataProvider,
  u_SaveLoadTBConfigByConfigProvider,
  u_MapTypeMenuItemsGeneratorBasic,
  u_TreeByPathDetalizeProviderList,
  u_MenuGeneratorByStaticTreeSimple,
  u_OperationNotifier,
  u_MainFormState,
  u_PosFromGSM,
  u_SearchResults,
  u_InetFunc,
  vsagps_public_base,
  vsagps_public_position,
  vsagps_public_time,
  frm_StartLogo,
  StrUtils;

type
  TTBXItemSelectMapVersion = class(TTBXItem)
  protected
    MapVersion: IMapVersionInfo;
  end;

{$R *.dfm}

constructor TfrmMain.Create(AOwner: TComponent);
var
  VLogger: TTileErrorLogProviedrStuped;
  VMouseState: TMouseState;
  VLineOnMapEditChangeListener: IJclListener;
  VBitmapStatic: IBitmap32Static;
begin
  inherited;

  FfrmDGAvailablePic := nil;

  FState := TMainFormState.Create;
  VMouseState := TMouseState.Create;
  FMouseHandler := VMouseState;
  FMouseState := VMouseState;
  FConfig := GState.MainFormConfig;
  FFormRegionProcess :=
    TfrmRegionProcess.Create(
      GState.LanguageManager,
      GState.AppClosingNotifier,
      GState.GUISyncronizedTimerNotifier,
      GState.LastSelectionInfo,
      FConfig.MainMapsConfig,
      GState.MapType.FullMapsSet,
      GState.MapType.GUIConfigList,
      GState.CoordConverterFactory,
      GState.TileNameGenerator,
      GState.ViewConfig,
      GState.ImageResamplerConfig,
      FConfig.LayersConfig.MarksLayerConfig.MarksShowConfig,
      FConfig.LayersConfig.MarksLayerConfig.MarksDrawConfig,
      GState.MarksDB,
      GState.LocalConverterFactory,
      GState.BitmapPostProcessingConfig,
      GState.ProjectionFactory,
      GState.VectorItmesFactory,
      GState.MapCalibrationList,
      GState.DownloadConfig,
      GState.DownloadInfo,
      GState.ValueToStringConverterConfig
    );
  FfrmGoTo :=
    TfrmGoTo.Create(
      GState.LanguageManager,
      GState.MarksDB.MarksDb,
      FConfig.MainGeoCoderConfig,
      FConfig.ViewPortState,
      GState.ValueToStringConverterConfig
    );

  FfrmCacheManager :=
    TfrmCacheManager.Create(
      GState.LanguageManager,
      GState.AppClosingNotifier,
      GState.GUISyncronizedTimerNotifier,
      GState.GCThread.List,
      GState.ContentTypeManager,
      GState.PerfCounterList,
      GState.ValueToStringConverterConfig
    );

  FMapTypeEditor := TMapTypeConfigModalEditByForm.Create(GState.LanguageManager);

  LoadMapIconsList;

  FLinksList := TJclListenerNotifierLinksList.Create;

  FLinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnStateChange),
    FState.ChangeNotifier
  );
  VLogger := TTileErrorLogProviedrStuped.Create;
  FTileErrorLogger := VLogger;
  FTileErrorLogProvider := VLogger;

  FGpsPosChangeCounter := 0;
  FCenterToGPSDelta := CEmptyDoublePoint;

  TBSMB.Images := FMapTypeIcons24List.GetImageList;
  TBSMB.SubMenuImages := FMapTypeIcons18List.GetImageList;
  TBLayerSel.SubMenuImages := FMapTypeIcons18List.GetImageList;
  TBFillingTypeMap.SubMenuImages := FMapTypeIcons18List.GetImageList;
  NSMB.SubMenuImages := FMapTypeIcons18List.GetImageList;
  NLayerSel.SubMenuImages := FMapTypeIcons18List.GetImageList;
  NLayerParams.SubMenuImages := FMapTypeIcons18List.GetImageList;
  ldm.SubMenuImages := FMapTypeIcons18List.GetImageList;
  dlm.SubMenuImages := FMapTypeIcons18List.GetImageList;
  TBOpenDirLayer.SubMenuImages := FMapTypeIcons18List.GetImageList;
  TBCopyLinkLayer.SubMenuImages := FMapTypeIcons18List.GetImageList;
  TBLayerInfo.SubMenuImages := FMapTypeIcons18List.GetImageList;

  FNLayerParamsItemList := TGUIDObjectSet.Create(False);
  FNDwnItemList := TGUIDObjectSet.Create(False);
  FNDelItemList := TGUIDObjectSet.Create(False);
  FNOpenDirItemList := TGUIDObjectSet.Create(False);
  FNCopyLinkItemList := TGUIDObjectSet.Create(False);
  FNLayerInfoItemList := TGUIDObjectSet.Create(False);

  FLayersList := TWindowLayerBasicList.Create(GState.PerfCounterList);
  FWinPosition := TMainWindowPositionConfig.Create(BoundsRect);
  FLinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnWinPositionChange),
    FWinPosition.GetChangeNotifier
  );

  FLinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnToolbarsLockChange),
    FConfig.ToolbarsLock.GetChangeNotifier
  );

  FLineOnMapByOperation[ao_movemap] := nil;
  FLineOnMapByOperation[ao_edit_point] := nil;
  FLineOnMapByOperation[ao_select_rect] := nil;
  FLineOnMapByOperation[ao_edit_line] := TPathOnMapEdit.Create(GState.VectorItmesFactory);
  FLineOnMapByOperation[ao_edit_poly] := TPolygonOnMapEdit.Create(GState.VectorItmesFactory);
  FLineOnMapByOperation[ao_calc_line] := TPathOnMapEdit.Create(GState.VectorItmesFactory);
  FLineOnMapByOperation[ao_select_poly] := TPolygonOnMapEdit.Create(GState.VectorItmesFactory);
  FLineOnMapByOperation[ao_select_line] := TPathOnMapEdit.Create(GState.VectorItmesFactory);

  FPointOnMapEdit := TPointOnMapEdit.Create;

  FSelectionRect :=
    TSelectionRect.Create(
      FConfig.ViewPortState,
      FConfig.LayersConfig.MapLayerGridsConfig.TileGrid,
      FConfig.LayersConfig.MapLayerGridsConfig.GenShtabGrid,
      FConfig.LayersConfig.MapLayerGridsConfig.DegreeGrid
    );

  VLineOnMapEditChangeListener := TNotifyNoMmgEventListener.Create(Self.OnLineOnMapEditChange);
  FLinksList.Add(
    VLineOnMapEditChangeListener,
    FLineOnMapByOperation[ao_edit_line].GetChangeNotifier
  );
  FLinksList.Add(
    VLineOnMapEditChangeListener,
    FLineOnMapByOperation[ao_edit_poly].GetChangeNotifier
  );
  FLinksList.Add(
    VLineOnMapEditChangeListener,
    FLineOnMapByOperation[ao_calc_line].GetChangeNotifier
  );
  FLinksList.Add(
    VLineOnMapEditChangeListener,
    FLineOnMapByOperation[ao_select_poly].GetChangeNotifier
  );
  FLinksList.Add(
    VLineOnMapEditChangeListener,
    FLineOnMapByOperation[ao_select_line].GetChangeNotifier
  );

  FRuller:=TBitmap32.Create;
  FTumbler:=TBitmap32.Create;
  VBitmapStatic := FConfig.MainConfig.Ruller;
  if VBitmapStatic <> nil then begin
    FRuller.Assign(VBitmapStatic.Bitmap);
  end;
  VBitmapStatic := FConfig.MainConfig.Tumbler;
  if VBitmapStatic <> nil then begin
    FTumbler.Assign(VBitmapStatic.Bitmap);
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  VProvider: IConfigDataProvider;
  VSensorViewGenerator: ISensorViewListGenerator;
begin
  SystemTimeChanged;
  ProgramStart:=true;
  Application.Title:=Caption;
  Application.OnMinimize := Self.OnMinimize;
  Caption:=Caption+' '+SASVersion;
  TBXSetTheme('SAStbxTheme');

  VProvider := GState.MainConfigProvider.GetSubItem('MainForm');
  FWinPosition.ReadConfig(VProvider);

  VProvider := GState.MainConfigProvider.GetSubItem('PANEL');

  TBEditPath.Floating:=true;
  TBEditPath.MoveOnScreen(true);
  TBEditPath.FloatingPosition:=Point(Left+map.Left+30,Top+map.Top+70);

  VSensorViewGenerator :=
    TSensorViewListGeneratorStuped.Create(
      GState.GUISyncronizedTimerNotifier,
      GState.ValueToStringConverterConfig,
      GState.LanguageManager,
      Self,
      TBXDock1,
      NSensors,
      MenusImageList,
      40
    );
  FSensorViewList := VSensorViewGenerator.CreateSensorViewList(GState.SensorList);
  TBConfigProviderLoadPositions(Self, VProvider);
  OnToolbarsLockChange;
  TBEditPath.Visible:=false;
  FMarkDBGUI :=
    TMarksDbGUIHelper.Create(
      GState.LanguageManager,
      GState.MediaDataPath,
      GState.MarksDB,
      FConfig.ViewPortState,
      GState.VectorItmesFactory,
      GState.ValueToStringConverterConfig,
      FFormRegionProcess
    );
  TrayIcon.Icon.LoadFromResourceName(Hinstance, 'MAINICON');
  FMapGoto := TMapViewGoto.Create(FConfig.ViewPortState);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FSensorViewList := nil;
end;

function TfrmMain.ConvLatLon2Scale(const Astr:string):Double;
var rest: boolean;
  res: Double;
  i,delitel:integer;
  gms:double;
  VText:string;
begin

  VText := Astr;
  rest := true;
  i:=1;
  while i<=length(VText) do begin
    if (not(VText[i] in ['0'..'9','-','+','.',',',' '])) then begin
      VText[i]:=' ';
      dec(i);
    end;
     if ((i=1)and(VText[i]=' '))or
       ((i=length(VText))and(VText[i]=' '))or
       ((i<length(VText)-1)and(VText[i]=' ')and(VText[i+1]=' '))or
       ((i>1) and (VText[i]=' ') and (not(VText[i-1] in ['0'..'9'])))or
       ((i<length(VText)-1)and(VText[i]=',')and(VText[i+1]=' ')) then begin
      Delete(VText,i,1);
      dec(i);
    end;
    inc(i);
  end;

  try
    res:=0;
    delitel:=1;
    repeat
     i:=posEx(' ',VText,1);
     if i=0 then begin
       gms:=str2r(VText);
     end else begin
       gms:=str2r(copy(VText,1,i-1));
       Delete(VText,1,i);
     end;
     if ((delitel>1)and(abs(gms)>60))or
        ((delitel=1)and(abs(gms)>180)) then begin
       Rest:=false;
     end;
     if res<0 then begin
       res:=res-gms/delitel;
     end else begin
       res:=res+gms/delitel;
     end;
     delitel:=delitel*60;
    until (i=0)or(delitel>3600)or(rest=false);
  except
    res := 0;
  end;
  result := res;
end;

function TfrmMain.deg2strvalue(const aDeg:Double):string;
var
  Vmin :integer;
  VDegScale : Double;
begin
   // convert to  � ' "
   VDegScale := abs(aDeg/100000000);
   result := IntToStr(Trunc(VDegScale)) + '�';
   VDegScale := Frac(VDegScale+0.0000000001) * 60;
   Vmin := Trunc(VDegScale);
   if Vmin < 10 then begin
     result := result + '0' + IntToStr(Vmin) + '''';
   end else begin
     result := result + IntToStr(Vmin) + '''';
   end;
   VDegScale := Frac(VDegScale) * 60;
   result := result + FormatFloat('00.00', VDegScale) + '"';
end;

procedure TfrmMain.FormActivate(Sender: TObject);
var
  param:string;
  VGUID: TGUID;
  VLonLat: TDoublePoint;
  VMapLayersVsibleChangeListener: IJclListener;
  VMainFormMainConfigChangeListener: IJclListener;
  VGPSReceiverStateChangeListener: IJclListener;
  VScale: Integer;
  VDegScale: Double;
  VZoom: Byte;
  VMarkerProvider: IBitmapMarkerProviderChangeable;
begin
  if not ProgramStart then exit;
  FConfig.ViewPortState.ChangeViewSize(Point(map.Width, map.Height));
  Enabled:=false;
  try
    OnWinPositionChange;

    movepoint:=false;

    Enabled:=true;
    Application.OnMessage := DoMessageEvent;
    Application.HelpFile := ExtractFilePath(Application.ExeName)+'help.hlp';
    Screen.Cursors[1]:=LoadCursor(HInstance, 'SEL');
    Screen.Cursors[2]:=LoadCursor(HInstance, 'LEN');
    Screen.Cursors[3]:=LoadCursor(HInstance, 'HAND');
    Screen.Cursors[4]:=LoadCursor(HInstance, 'SELPOINT');
    Map.Cursor:=crDefault;

    FMapZoomAnimtion:=False;
    FShortCutManager :=
      TShortcutManager.Create(
        TBXMainMenu.Items,
        GetIgnoredMenuItemsList
      );
    FShortCutManager.Load(GState.MainConfigProvider.GetSubItem('HOTKEY'));

    tbitmShowDebugInfo.Visible := GState.GlobalAppConfig.IsShowDebugInfo;
    if FConfig.MainConfig.UseNewMainLayer then begin
      FLayersList.Add(
        TMapMainLayerNew.Create(
          GState.PerfCounterList,
          GState.AppClosingNotifier,
          map,
          FConfig.ViewPortState,
          GState.ImageResamplerConfig,
          GState.LocalConverterFactory,
          FConfig.MainMapsConfig,
          GState.BitmapPostProcessingConfig,
          FConfig.LayersConfig.MainMapLayerConfig,
          FTileErrorLogger,
          GState.GUISyncronizedTimerNotifier
        )
      );
    end else begin
      FLayersList.Add(
        TMapMainLayer.Create(
          GState.PerfCounterList,
          GState.AppClosingNotifier,
          map,
          FConfig.ViewPortState,
          GState.ImageResamplerConfig,
          GState.LocalConverterFactory,
          GState.ClearStrategyFactory,
          FConfig.MainMapsConfig,
          GState.BitmapPostProcessingConfig,
          FConfig.LayersConfig.MainMapLayerConfig,
          FTileErrorLogger,
          GState.GUISyncronizedTimerNotifier
        )
      );
    end;
    FLayersList.Add(
      TMapLayerGrids.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        GState.ImageResamplerConfig,
        GState.LocalConverterFactory,
        FConfig.LayersConfig.MapLayerGridsConfig,
        GState.ValueToStringConverterConfig
      )
    );
    FLayersList.Add(
      TMapLayerTileGrid.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        FConfig.LayersConfig.MapLayerGridsConfig.TileGrid
      )
    );
    FWikiLayer :=
      TWikiLayer.Create(
        GState.PerfCounterList,
        GState.AppClosingNotifier,
        map,
        FConfig.ViewPortState,
        GState.VectorItmesFactory,
        GState.ImageResamplerConfig,
        GState.LocalConverterFactory,
        GState.ClearStrategyFactory,
        FTileErrorLogger,
        GState.GUISyncronizedTimerNotifier,
        FConfig.LayersConfig.KmlLayerConfig,
        FConfig.MainMapsConfig.GetActiveKmlLayersSet
      );
    FLayersList.Add(FWikiLayer);
    if FConfig.MainConfig.UseNewMainLayer then begin
      FLayersList.Add(
        TMapLayerFillingMapNew.Create(
          GState.PerfCounterList,
          GState.AppClosingNotifier,
          map,
          FConfig.ViewPortState,
          GState.ImageResamplerConfig,
          GState.LocalConverterFactory,
          GState.GUISyncronizedTimerNotifier,
          FConfig.LayersConfig.FillingMapLayerConfig
        )
      );
    end else begin
      FLayersList.Add(
        TMapLayerFillingMap.Create(
          GState.PerfCounterList,
          GState.AppClosingNotifier,
          map,
          FConfig.ViewPortState,
          GState.ImageResamplerConfig,
          GState.LocalConverterFactory,
          GState.GUISyncronizedTimerNotifier,
          FConfig.LayersConfig.FillingMapLayerConfig
        )
      );
    end;
    FLayerMapMarks:=
      TMapMarksLayer.Create(
        GState.PerfCounterList,
        GState.AppClosingNotifier,
        map,
        FConfig.ViewPortState,
        GState.VectorItmesFactory,
        GState.ImageResamplerConfig,
        GState.LocalConverterFactory,
        GState.ClearStrategyFactory,
        GState.GUISyncronizedTimerNotifier,
        FConfig.LayersConfig.MarksLayerConfig,
        FMarkDBGUI.MarksDB
      );
    FLayersList.Add(FLayerMapMarks);
    if FConfig.MainConfig.UseNewMainLayer then begin
      FLayersList.Add(
        TMapGPSLayerNew.Create(
          GState.PerfCounterList,
          GState.AppClosingNotifier,
          map,
          FConfig.ViewPortState,
          GState.ImageResamplerConfig,
          GState.LocalConverterFactory,
          GState.GUISyncronizedTimerNotifier,
          FConfig.LayersConfig.GPSTrackConfig,
          GState.GPSRecorder
        )
      );
    end else begin
      FLayersList.Add(
        TMapGPSLayer.Create(
          GState.PerfCounterList,
          GState.AppClosingNotifier,
          map,
          FConfig.ViewPortState,
          GState.ImageResamplerConfig,
          GState.LocalConverterFactory,
          GState.ClearStrategyFactory,
          GState.GUISyncronizedTimerNotifier,
          FConfig.LayersConfig.GPSTrackConfig,
          GState.GPSRecorder
        )
      );
    end;
    FLayersList.Add(
      TMapLayerGPSMarker.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        GState.GUISyncronizedTimerNotifier,
        FConfig.LayersConfig.GPSMarker,
        TBitmapMarkerProviderChangeableWithConfig.Create(
          TBitmapMarkerProviderSimpleArrow,
          FConfig.LayersConfig.GPSMarker.MovedMarkerConfig
        ),
        TBitmapMarkerProviderChangeableWithConfig.Create(
          TBitmapMarkerProviderSimpleSquare,
          FConfig.LayersConfig.GPSMarker.StopedMarkerConfig
        ),
        GState.GPSRecorder
      )
    );
    FLayersList.Add(
      TSelectionLayer.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        GState.VectorItmesFactory,
        FConfig.LayersConfig.LastSelectionLayerConfig,
        GState.LastSelectionInfo
      )
    );
    FLayersList.Add(
      TPathEditLayer.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        GState.VectorItmesFactory,
        FLineOnMapByOperation[ao_calc_line] as IPathOnMapEdit,
        FConfig.LayersConfig.CalcLineLayerConfig.LineConfig
      )
    );
    FLayersList.Add(
      TPathEditPointsSetLayer.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        GState.VectorItmesFactory,
        FLineOnMapByOperation[ao_calc_line] as IPathOnMapEdit,
        FConfig.LayersConfig.CalcLineLayerConfig.PointsConfig
      )
    );
    FLayersList.Add(
      TCalcLineLayer.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        FLineOnMapByOperation[ao_calc_line] as IPathOnMapEdit,
        FConfig.LayersConfig.CalcLineLayerConfig.CaptionConfig,
        GState.ValueToStringConverterConfig
      )
    );
    FLayersList.Add(
      TPathEditLayer.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        GState.VectorItmesFactory,
        FLineOnMapByOperation[ao_edit_line] as IPathOnMapEdit,
        FConfig.LayersConfig.MarkPolyLineLayerConfig.LineConfig
      )
    );
    FLayersList.Add(
      TPathEditPointsSetLayer.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        GState.VectorItmesFactory,
        FLineOnMapByOperation[ao_edit_line] as IPathOnMapEdit,
        FConfig.LayersConfig.MarkPolyLineLayerConfig.PointsConfig
      )
    );
    FLayersList.Add(
      TPolygonEditLayer.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        GState.VectorItmesFactory,
        FLineOnMapByOperation[ao_edit_poly] as IPolygonOnMapEdit,
        FConfig.LayersConfig.MarkPolygonLayerConfig.LineConfig
      )
    );
    FLayersList.Add(
      TPolygonEditPointsSetLayer.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        GState.VectorItmesFactory,
        FLineOnMapByOperation[ao_edit_poly] as IPolygonOnMapEdit,
        FConfig.LayersConfig.MarkPolygonLayerConfig.PointsConfig
      )
    );
    FLayersList.Add(
      TPolygonEditLayer.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        GState.VectorItmesFactory,
        FLineOnMapByOperation[ao_select_poly] as IPolygonOnMapEdit,
        FConfig.LayersConfig.SelectionPolygonLayerConfig.LineConfig
      )
    );
    FLayersList.Add(
      TPolygonEditPointsSetLayer.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        GState.VectorItmesFactory,
        FLineOnMapByOperation[ao_select_poly] as IPolygonOnMapEdit,
        FConfig.LayersConfig.SelectionPolygonLayerConfig.PointsConfig
      )
    );

    FLayersList.Add(
      TSelectionPolylineShadowLayer.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        GState.VectorItmesFactory,
        FLineOnMapByOperation[ao_select_line] as IPathOnMapEdit,
        FConfig.LayersConfig.SelectionPolylineLayerConfig.ShadowConfig
      )
    );
    FLayersList.Add(
      TPathEditLayer.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        GState.VectorItmesFactory,
        FLineOnMapByOperation[ao_select_line] as IPathOnMapEdit,
        FConfig.LayersConfig.SelectionPolylineLayerConfig.LineConfig
      )
    );
    FLayersList.Add(
      TPathEditPointsSetLayer.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        GState.VectorItmesFactory,
        FLineOnMapByOperation[ao_select_line] as IPathOnMapEdit,
        FConfig.LayersConfig.SelectionPolylineLayerConfig.PointsConfig
      )
    );

    FLayersList.Add(
      TSelectionRectLayer.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        FSelectionRect,
        FConfig.LayersConfig.SelectionRectLayerConfig
      )
    );
    FLayerSearchResults :=
      TSearchResultsLayer.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        FConfig.LastSearchResultConfig,
        TBitmapMarkerProviderChangeableFaked.Create(
          TBitmapMarkerProviderStaticFromDataProvider.Create(
            GState.ResourceProvider,
            GState.ContentTypeManager,
            'FOUNDPNT.png',
            DoublePoint(8, 8)
          )
        )
      );
    FLayersList.Add(FLayerSearchResults);
    VMarkerProvider := TBitmapMarkerProviderChangeableFaked.Create(
      TBitmapMarkerProviderStaticFromDataProvider.Create(
        GState.ResourceProvider,
        GState.ContentTypeManager,
        'ICONIII.png',
        DoublePoint(7, 6)
      )
    );
    FLayersList.Add(
      TGotoLayer.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        VMarkerProvider,
        FMapGoto,
        FConfig.LayersConfig.GotoLayerConfig
      )
    );
    FLayersList.Add(
      TNavToMarkLayer.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        FConfig.NavToPoint,
        TBitmapMarkerProviderChangeableWithConfig.Create(
          TBitmapMarkerProviderSimpleArrow,
          FConfig.LayersConfig.NavToPointMarkerConfig.ArrowMarkerConfig
        ),
        TBitmapMarkerProviderChangeableWithConfig.Create(
          TBitmapMarkerProviderSimpleCross,
          FConfig.LayersConfig.NavToPointMarkerConfig.ReachedMarkerConfig
        ),
        FConfig.LayersConfig.NavToPointMarkerConfig
      )
    );
    FLayersList.Add(
      TTileErrorInfoLayer.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        FTileErrorLogProvider,
        GState.GUISyncronizedTimerNotifier
      )
    );
    VMarkerProvider := TBitmapMarkerProviderChangeableFaked.Create(
      TBitmapMarkerProviderStaticFromDataProvider.Create(
        GState.ResourceProvider,
        GState.ContentTypeManager,
        'ICONIII.png',
        DoublePoint(7, 6)
      )
    );
    FLayersList.Add(
      TPointOnMapEditLayer.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        VMarkerProvider,
        FPointOnMapEdit
      )
    );
    FLayersList.Add(
      TFullMapMouseCursorLayer.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        FState,
        GState.GUISyncronizedTimerNotifier,
        FMouseState,
        FConfig.LayersConfig.FullMapMouseCursorLayerConfig
      )
    );
    FLayersList.Add(
      TCenterScale.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        FConfig.LayersConfig.CenterScaleConfig
      )
    );
    FLayersList.Add(
      TLayerScaleLine.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        FConfig.LayersConfig.ScaleLineConfig
      )
    );
    FLayersList.Add(
      TLayerStatBar.Create(
        GState.PerfCounterList,
        map,
        FConfig.ViewPortState,
        FConfig.LayersConfig.StatBar,
        GState.ValueToStringConverterConfig,
        FMouseState,
        GState.GUISyncronizedTimerNotifier,
        GState.TimeZoneDiffByLonLat,
        GState.DownloadInfo,
        GState.GlobalInternetState,
        FConfig.MainMapsConfig
      )
    );
    FLayersList.Add(
      TMiniMapLayer.Create(
        GState.PerfCounterList,
        GState.AppClosingNotifier,
        map,
        FConfig.ViewPortState,
        GState.LocalConverterFactory,
        GState.ClearStrategyFactory,
        FConfig.LayersConfig.MiniMapLayerConfig,
        GState.ViewConfig,
        GState.BitmapPostProcessingConfig,
        GState.MapType.GUIConfigList,
        FMapTypeIcons18List,
        FTileErrorLogger,
        GState.GUISyncronizedTimerNotifier
      )
    );

    FLinksList.Add(
      TNotifyNoMmgEventListener.Create(Self.OnMapGUIChange),
      GState.MapType.GUIConfigList.GetChangeNotifier
    );
    OnMapGUIChange;


    VScale := FConfig.LayersConfig.MapLayerGridsConfig.GenShtabGrid.Scale;
    if FConfig.LayersConfig.MapLayerGridsConfig.GenShtabGrid.Visible = True then begin
    NGShScale10000.Checked := VScale = 10000;
    NGShScale25000.Checked := VScale = 25000;
    NGShScale50000.Checked := VScale = 50000;
    NGShScale100000.Checked := VScale = 100000;
    NGShScale200000.Checked := VScale = 200000;
    NGShScale500000.Checked := VScale = 500000;
    NGShScale1000000.Checked := VScale = 1000000;
    NGShScale0.Checked := VScale = 0;
    end else
    NGShScale0.Checked := True;


    VDegScale := FConfig.LayersConfig.MapLayerGridsConfig.DegreeGrid.Scale;
    if FConfig.LayersConfig.MapLayerGridsConfig.DegreeGrid.Visible = True then begin
     if VDegScale = 12500000 then NDegScale10000.Checked := true else
     if VDegScale = 25000000 then NDegScale25000.Checked := true else
     if VDegScale = 50000000 then NDegScale50000.Checked := true else
     if VDegScale = 100000000 then NDegScale100000.Checked := true else
     if VDegScale = 200000000 then NDegScale200000.Checked := true else
     if VDegScale = 500000000 then NDegScale500000.Checked := true else
     if VDegScale = 1000000000 then NDegScale1000000.Checked := true else
     if VDegScale = 0 then NDegScale0.Checked := true else
     if VDegScale < 0 then NDegScaleAuto.Checked := true else
                           NDegScaleUser.Checked := true ;
     NDegValue.text := deg2strvalue(VDegScale);
    end else
    NDegScale0.Checked := True;

    FLinksList.Add(
      TNotifyNoMmgEventListener.Create(Self.OnBeforeViewChange),
      FConfig.ViewPortState.BeforeChangeNotifier
    );
    FLinksList.Add(
      TNotifyNoMmgEventListener.Create(Self.OnAfterViewChange),
      FConfig.ViewPortState.AfterChangeNotifier
    );

    FLinksList.Add(
      TNotifyNoMmgEventListener.Create(Self.ProcessPosChangeMessage),
      FConfig.ViewPortState.GetChangeNotifier
    );
    FLinksList.Add(
      TNotifyNoMmgEventListener.Create(Self.OnMainMapChange),
      FConfig.MainMapsConfig.GetActiveMap.GetChangeNotifier
    );

    VMapLayersVsibleChangeListener := TNotifyNoMmgEventListener.Create(Self.MapLayersVisibleChange);
    FLinksList.Add(
      VMapLayersVsibleChangeListener,
      FConfig.LayersConfig.StatBar.GetChangeNotifier
    );
    FLinksList.Add(
      VMapLayersVsibleChangeListener,
      FConfig.LayersConfig.MiniMapLayerConfig.GetChangeNotifier
    );
    FLinksList.Add(
      VMapLayersVsibleChangeListener,
      FConfig.LayersConfig.ScaleLineConfig.GetChangeNotifier
    );
    FLinksList.Add(
      VMapLayersVsibleChangeListener,
      FConfig.DownloadUIConfig.GetChangeNotifier
    );
    FLinksList.Add(
      VMapLayersVsibleChangeListener,
      FConfig.LayersConfig.GPSTrackConfig.GetChangeNotifier
    );

    VGPSReceiverStateChangeListener := TNotifyEventListenerSync.Create(Self.GPSReceiverStateChange);
    FLinksList.Add(
      VGPSReceiverStateChangeListener,
      GState.GPSpar.ConnectingNotifier
    );
    FLinksList.Add(
      VGPSReceiverStateChangeListener,
      GState.GPSpar.DisconnectedNotifier
    );

    FLinksList.Add(
      TNotifyEventListenerSync.Create(Self.GPSReceiverConnect),
      GState.GPSpar.ConnectedNotifier
    );
    FLinksList.Add(
      TNotifyEventListenerSync.Create(Self.GPSReceiverDisconnect),
      GState.GPSpar.DisconnectedNotifier
    );
    FLinksList.Add(
      TNotifyEventListenerSync.Create(Self.GPSReceiverConnectError),
      GState.GPSpar.ConnectErrorNotifier
    );
    FLinksList.Add(
      TNotifyEventListenerSync.Create(Self.GPSReceiverTimeout),
      GState.GPSpar.TimeOutNotifier
    );
    FLinksList.Add(
      TNotifyNoMmgEventListener.Create(Self.GPSReceiverReceive),
      GState.GPSpar.DataReciveNotifier
    );

    VMainFormMainConfigChangeListener := TNotifyEventListenerSync.Create(Self.OnMainFormMainConfigChange);
    FLinksList.Add(
      VMainFormMainConfigChangeListener,
      FConfig.MainConfig.GetChangeNotifier
    );
    FLinksList.Add(
      VMainFormMainConfigChangeListener,
      GState.BitmapPostProcessingConfig.GetChangeNotifier
    );
    FLinksList.Add(
      VMainFormMainConfigChangeListener,
      FConfig.GPSBehaviour.GetChangeNotifier
    );
    FLinksList.Add(
      VMainFormMainConfigChangeListener,
      FConfig.MainGeoCoderConfig.GetChangeNotifier
    );
    FLinksList.Add(
      VMainFormMainConfigChangeListener,
      GState.ViewConfig.GetChangeNotifier
    );
    FLinksList.Add(
      VMainFormMainConfigChangeListener,
      FConfig.LayersConfig.MarksLayerConfig.MarksShowConfig.GetChangeNotifier
    );
    FLinksList.Add(
      VMainFormMainConfigChangeListener,
      FConfig.LayersConfig.MarksLayerConfig.MarksDrawConfig.GetChangeNotifier
    );


    FLinksList.Add(
      TNotifyNoMmgEventListener.Create(Self.OnFillingMapChange),
      FConfig.LayersConfig.FillingMapLayerConfig.GetChangeNotifier
    );

    FLinksList.Add(
      TNotifyNoMmgEventListener.Create(Self.OnSearchhistoryChange),
      FConfig.MainGeoCoderConfig.SearchHistory.GetChangeNotifier
    );

    FLinksList.Add(
      TNotifyNoMmgEventListener.Create(Self.OnNavToMarkChange),
      FConfig.NavToPoint.ChangeNotifier
    );

    DateTimePicker1.DateTime := FConfig.LayersConfig.FillingMapLayerConfig.FillFirstDay;
    DateTimePicker2.DateTime := FConfig.LayersConfig.FillingMapLayerConfig.FillLastDay;

    ProgramStart:=false;

    if ParamCount > 1 then begin
      try
        param:=paramstr(1);
        if param<>'' then begin
          try
            VGUID := StringToGUID(param);
          except
            VGUID := CGUID_Zero;
          end;
          if not IsEqualGUID(VGUID, CGUID_Zero) then begin
            FConfig.MainMapsConfig.SelectMainByGUID(VGUID);
          end;
        end;
        if  (paramstr(2)<>'') and (paramstr(3)<>'')and(paramstr(4)<>'') then begin
          VZoom := strtoint(paramstr(2)) - 1;
          FConfig.ViewPortState.ChangeZoomWithFreezeAtCenter(VZoom);
          VLonLat.X := str2r(paramstr(3));
          VLonLat.Y := str2r(paramstr(4));
          FConfig.ViewPortState.ChangeLonLat(VLonLat);
        end else if paramstr(2)<>'' then begin
          VZoom := strtoint(paramstr(2)) - 1;
          FConfig.ViewPortState.ChangeZoomWithFreezeAtCenter(VZoom);
        end;
      except
      end;
    end;

    FPathProvidersTree := TTreeByPathDetalizeProviderList.Create(GState.PathDetalizeList);
    FPathProvidersMenuBuilder := TMenuGeneratorByStaticTreeSimple.Create(Self.TBEditPathMarshClick);

    FLinksList.Add(
      TNotifyNoMmgEventListener.Create(Self.OnPathProvidesChange),
      FPathProvidersTree.ChangeNotifier
    );

    InitSearchers;
    CreateLangMenu;
    FMapMoving:=false;

    FfrmSettings :=
      TfrmSettings.Create(
        GState.LanguageManager,
        FShortCutManager,
        FMapTypeEditor,
        Self.SaveConfig
      );

    FfrmSettings.SetProxy;

    FfrmMarksExplorer :=
      TfrmMarksExplorer.Create(
        GState.LanguageManager,
        GState.ImportFileByExt,
        FConfig.ViewPortState,
        FConfig.NavToPoint,
        FConfig.LayersConfig.MarksLayerConfig.MarksShowConfig,
        FMarkDBGUI,
        FMapGoto
      );

    FLinksList.ActivateLinks;
    FLayersList.StartThreads;
    GState.StartThreads;
    
    FUIDownload :=
      TUITileDownloadList.Create(
        GState.GCThread.List,
        GState.AppClosingNotifier,
        FConfig.DownloadUIConfig,
        GState.LocalConverterFactory,
        FConfig.ViewPortState,
        FConfig.MainMapsConfig.GetAllActiveMapsSet,
        GState.DownloadInfo,
        GState.GlobalInternetState,
        FTileErrorLogger
      );

    OnMainFormMainConfigChange;
    MapLayersVisibleChange;
    OnFillingMapChange;
    OnMainMapChange;
    ProcessPosChangeMessage;
    OnSearchhistoryChange;
    OnPathProvidesChange;
    OnNavToMarkChange;

    PaintZSlider(FConfig.ViewPortState.GetCurrentZoom);
    FKeyMovingHandler := TKeyMovingHandler.Create(map, FConfig.ViewPortState, FConfig.KeyMovingConfig);
  finally
    Enabled:=true;
    map.SetFocus;
    TfrmStartLogo.ReadyToHideLogo;
  end;
  TBXMainMenu.ProcessShortCuts:=true;
end;

procedure TfrmMain.InitSearchers;
var
  VItem: IGeoCoderListEntity;
  VTBXItem: TTBXItem;
  VTBEditItem: TTBEditItem;
  VEnum: IEnumGUID;
  Vcnt: Cardinal;
  VGUID: TGUID;
begin
  FSearchPresenter :=
    TSearchResultPresenterOnPanel.Create(
      GState.InternalBrowser,
      FMapGoto,
      ScrollBoxSearchWindow,
      TBSearchWindow,
      GState.ValueToStringConverterConfig,
      FConfig.LastSearchResultConfig,
      FConfig.ViewPortState
    );

  VEnum := FConfig.MainGeoCoderConfig.GetList.GetGUIDEnum;
  while VEnum.Next(1, VGUID, Vcnt) = S_OK do begin
    VItem := FConfig.MainGeoCoderConfig.GetList.Get(VGUID);

    VTBXItem := TTBXItem.Create(Self);
    VTBXItem.GroupIndex := 1;
    VTBXItem.RadioItem := True;
    VTBXItem.Tag := Integer(VItem);
    VTBXItem.OnClick := Self.TBXSelectSrchClick;
    VTBXItem.Caption := VItem.GetCaption;
    VTBXItem.Hint := '';
    TBXSelectSrchType.Add(VTBXItem);

    VTBEditItem := TTBEditItem.Create(Self);
    VTBEditItem.EditCaption := VItem.GetCaption;
    VTBEditItem.Caption := VItem.GetCaption;
    VTBEditItem.EditWidth := 150;
    VTBEditItem.Hint := '';
    VTBEditItem.Tag := Integer(VItem);
    VTBEditItem.OnAcceptText := Self.tbiEditSrchAcceptText;
    TBGoTo.Add(VTBEditItem);
  end;
end;

procedure TfrmMain.CreateLangMenu;
var
  i: Integer;
  VManager: ILanguageManager;
begin
  VManager := GState.LanguageManager;
  for i := 0 to VManager.LanguageList.Count - 1 do begin
    TLanguageTBXItem.Create(Self, TBLang, VManager, i);
  end;
end;

procedure TfrmMain.CreateMapUIFillingList;
var
  VGenerator: TMapMenuGeneratorBasic;
begin
  VGenerator := TMapMenuGeneratorBasic.Create(
    GState.MapType.GUIConfigList,
    FConfig.LayersConfig.FillingMapLayerConfig.GetSourceMap.GetActiveMapsSet,
    TBFillingTypeMap,
    Self.TBfillMapAsMainClick,
    FMapTypeIcons18List
  );
  try
    VGenerator.BuildControls;
  finally
    FreeAndNil(VGenerator);
  end;
end;

procedure TfrmMain.CreateMapUILayersList;
var
  VGenerator: TMapMenuGeneratorBasic;
begin
  VGenerator := TMapMenuGeneratorBasic.Create(
    GState.MapType.GUIConfigList,
    FConfig.MainMapsConfig.GetActiveLayersSet,
    TBLayerSel,
    Self.OnClickLayerItem,
    FMapTypeIcons18List
  );
  try
   VGenerator.BuildControls;
  finally
    FreeAndNil(VGenerator);
  end;
end;

procedure TfrmMain.CreateMapUILayerSubMenu;
var
  i: integer;
  VMapType: TMapType;

  NLayerParamsItem: TTBXItem; //����� ������� ���� ���������/��������� ����
  NDwnItem: TTBXItem; //����� ������������ ���� ��������� ���� ����
  NDelItem: TTBXItem; //����� ������������ ���� ������� ���� ����
  NOpenDirItem: TTBXItem;
  NCopyLinkItem: TTBXItem;
  NLayerInfoItem: TTBXItem;

  VIcon18Index: Integer;
  VGUIDList: IGUIDListStatic;
  VGUID: TGUID;
begin
  ldm.Clear;
  dlm.Clear;
  TBOpenDirLayer.Clear;
  NLayerParams.Clear;
  TBCopyLinkLayer.Clear;
  TBLayerInfo.Clear;

  FNLayerParamsItemList.Clear;
  FNLayerInfoItemList.Clear;
  FNDwnItemList.Clear;
  FNDelItemList.Clear;
  FNOpenDirItemList.Clear;
  FNCopyLinkItemList.Clear;

  VGUIDList := GState.MapType.GUIConfigList.OrderedMapGUIDList;
  for i := 0 to VGUIDList.Count - 1 do begin
    VGUID := VGUIDList.Items[i];
    VMapType := GState.MapType.FullMapsSet.GetMapTypeByGUID(VGUID).MapType;
    VIcon18Index := FMapTypeIcons18List.GetIconIndexByGUID(VGUID);
    if VMapType.Abilities.IsLayer then begin
      NDwnItem:=TTBXItem.Create(ldm);
      FNDwnItemList.Add(VGUID, NDwnItem);
      NDwnItem.Caption:=VMapType.GUIConfig.Name.Value;
      NDwnItem.ImageIndex:=VIcon18Index;
      NDwnItem.OnClick := tbitmDownloadMainMapTileClick;
      NDwnItem.Tag:=longint(VMapType);
      ldm.Add(NDwnItem);

      NDelItem:=TTBXItem.Create(dlm);
      FNDelItemList.Add(VGUID, NDelItem);
      NDelItem.Caption:=VMapType.GUIConfig.Name.Value;
      NDelItem.ImageIndex:=VIcon18Index;
      NDelItem.OnClick:=NDelClick;
      NDelItem.Tag:=longint(VMapType);
      dlm.Add(NDelItem);

      NOpenDirItem:=TTBXItem.Create(TBOpenDirLayer);
      FNOpenDirItemList.Add(VGUID, NOpenDirItem);
      NOpenDirItem.Caption:=VMapType.GUIConfig.Name.Value;
      NOpenDirItem.ImageIndex:=VIcon18Index;
      NOpenDirItem.OnClick := tbitmOpenFolderMainMapTileClick;
      NOpenDirItem.Tag:=longint(VMapType);
      TBOpenDirLayer.Add(NOpenDirItem);

      NCopyLinkItem:=TTBXItem.Create(TBCopyLinkLayer);
      FNCopyLinkItemList.Add(VGUID, NCopyLinkItem);
      NCopyLinkItem.Caption:=VMapType.GUIConfig.Name.Value;
      NCopyLinkItem.ImageIndex:=VIcon18Index;
      NCopyLinkItem.OnClick:=tbitmCopyToClipboardMainMapUrlClick;
      NCopyLinkItem.Tag:=longint(VMapType);
      TBCopyLinkLayer.Add(NCopyLinkItem);

      NLayerParamsItem:=TTBXItem.Create(NLayerParams);
      FNLayerParamsItemList.Add(VGUID, NLayerParamsItem);
      NLayerParamsItem.Caption:=VMapType.GUIConfig.Name.Value;
      NLayerParamsItem.ImageIndex:=VIcon18Index;
      NLayerParamsItem.OnClick:=NMapParamsClick;
      NLayerParamsItem.Tag:=longint(VMapType);
      NLayerParams.Add(NLayerParamsItem);

      NLayerInfoItem:=TTBXItem.Create(TBLayerInfo);
      FNLayerInfoItemList.Add(VGUID, NLayerInfoItem);
      NLayerInfoItem.Caption:=VMapType.GUIConfig.Name.Value;
      NLayerInfoItem.ImageIndex:=VIcon18Index;
      NLayerInfoItem.OnClick:=NMapInfoClick;
      NLayerInfoItem.Tag:=longint(VMapType);
      TBLayerInfo.Add(NLayerInfoItem);
    end;
  end;
end;

procedure TfrmMain.CreateMapUIMapsList;
var
  VGenerator: TMapMenuGeneratorBasic;
begin
  VGenerator := TMapMenuGeneratorBasic.Create(
    GState.MapType.GUIConfigList,
    FConfig.MainMapsConfig.GetActiveMapsSet,
    TBSMB,
    Self.OnClickMapItem,
    FMapTypeIcons18List
  );
  try
    VGenerator.BuildControls;
  finally
    FreeAndNil(VGenerator);
  end;
end;

function TfrmMain.GetIgnoredMenuItemsList: TList;
begin
  Result := TList.Create;
  Result.Add(NSMB);
  Result.Add(NLayerSel);
  Result.Add(TBFillingTypeMap);
  Result.Add(NLayerParams);
  Result.Add(TBLang);
  Result.Add(N002);
  Result.Add(N003);
  Result.Add(N004);
  Result.Add(N005);
  Result.Add(N006);
  Result.Add(N007);
  Result.Add(NFillMap);
  if not GState.GlobalAppConfig.IsShowDebugInfo then begin
    Result.Add(tbitmShowDebugInfo);
  end; 
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i:integer;
begin
  ProgramClose:=true;
  FLinksList.DeactivateLinks;
  GState.SendTerminateToThreads;
  FLayersList.SendTerminateToThreads;
  for i := 0 to Screen.FormCount - 1 do begin
    if (Screen.Forms[i]<>Application.MainForm)and(Screen.Forms[i].Visible) then begin
      Screen.Forms[i].Close;
    end;
  end;
  Application.ProcessMessages;
  SaveConfig(nil);
  Application.ProcessMessages;
  FreeAndNil(FLayersList);
  FreeAndNil(FShortCutManager);
  FreeAndNil(FMarkDBGUI);
end;

destructor TfrmMain.Destroy;
begin
  FreeAndNil(FfrmDGAvailablePic);
  FLineOnMapEdit := nil;
  FWinPosition := nil;
  FSearchPresenter := nil;
  FNLayerParamsItemList := nil;
  FNLayerInfoItemList := nil;
  FNDwnItemList := nil;
  FNDelItemList := nil;
  FNOpenDirItemList := nil;
  FNCopyLinkItemList := nil;
  FLinksList := nil;
  FreeAndNil(FfrmAbout);
  FreeAndNil(FTumbler);
  FreeAndNil(FRuller);
  FreeAndNil(FFormRegionProcess);
  FreeAndNil(FfrmGoTo);
  FreeAndNil(FfrmSettings);
  FreeAndNil(FfrmCacheManager);
  FreeAndNil(FfrmMarksExplorer);
  inherited;
end;

procedure TfrmMain.MapLayersVisibleChange;
var
  VUseDownload: TTileSource;
begin
  Showstatus.Checked := FConfig.LayersConfig.StatBar.Visible;
  if Showstatus.Checked then begin
    FConfig.LayersConfig.ScaleLineConfig.BottomMargin := FConfig.LayersConfig.StatBar.Height;
    FConfig.LayersConfig.MiniMapLayerConfig.BottomMargin := FConfig.LayersConfig.StatBar.Height;
  end else begin
    FConfig.LayersConfig.ScaleLineConfig.BottomMargin := 0;
    FConfig.LayersConfig.MiniMapLayerConfig.BottomMargin := 0;
  end;
  ShowMiniMap.Checked := FConfig.LayersConfig.MiniMapLayerConfig.Visible;
  ShowLine.Checked := FConfig.LayersConfig.ScaleLineConfig.Visible;
  NShowSelection.Checked := FConfig.LayersConfig.LastSelectionLayerConfig.Visible;
  tbitmGauge.Checked := FConfig.LayersConfig.CenterScaleConfig.Visible;

  TBGPSPath.Checked := FConfig.LayersConfig.GPSTrackConfig.Visible;
  tbitmGPSTrackShow.Checked := TBGPSPath.Checked;
  VUseDownload := FConfig.DownloadUIConfig.UseDownload;
  TBSrc.ImageIndex := integer(VUseDownload);
  case VUseDownload of
    tsInternet: NSRCinet.Checked:=true;
    tsCache: NSRCesh.Checked:=true;
    tsCacheInternet: NSRCic.Checked:=true;
  end;

  mapResize(nil);
end;

procedure TfrmMain.ProcessPosChangeMessage;
var
  VZoomCurr: Byte;
  VGPSLonLat: TDoublePoint;
  VGPSMapPoint: TDoublePoint;
  VCenterMapPoint: TDoublePoint;
  VConverter: ILocalCoordConverter;
  VPosition: IGPSPosition;
  VpPos: PSingleGPSData;
begin
  VConverter := FConfig.ViewPortState.GetVisualCoordConverter;
  VZoomCurr := VConverter.GetZoom;

  VPosition := GState.GPSRecorder.CurrentPosition;
  VpPos := VPosition.GetPosParams;
  if (not VpPos^.PositionOK) then begin
    // no position
    FCenterToGPSDelta := CEmptyDoublePoint;
  end else begin
    // ok
    VGPSLonLat.X := VpPos^.PositionLon;
    VGPSLonLat.Y := VpPos^.PositionLat;

    VGPSMapPoint := VConverter.GetGeoConverter.LonLat2PixelPosFloat(VGPSLonLat, VZoomCurr);

    VCenterMapPoint := VConverter.GetCenterMapPixelFloat;
    FCenterToGPSDelta.X := VGPSMapPoint.X - VCenterMapPoint.X;
    FCenterToGPSDelta.Y := VGPSMapPoint.Y - VCenterMapPoint.Y;
  end;

  if VZoomCurr>0 then begin
    TBZoom_Out.Enabled:=true;
    NZoomOut.Enabled:=true;
  end;
  if VZoomCurr<23 then begin
    TBZoomIn.Enabled:=true;
    NZoomIn.Enabled:=true;
  end;
  PaintZSlider(VZoomCurr);
  labZoom.caption:= 'z' + inttostr(VZoomCurr + 1);
end;

procedure TfrmMain.CopyBtmToClipboard(btm: TBitmap);
var hSourcDC, hDestDC, hBM, hbmOld: THandle;
begin
  hSourcDC := btm.Canvas.Handle;
  hDestDC := CreateCompatibleDC(hSourcDC);
  hBM := CreateCompatibleBitmap(hSourcDC, btm.width, btm.height);
  hbmold:= SelectObject(hDestDC, hBM);
  BitBlt(hDestDC, 0, 0, btm.width, btm.height, hSourcDC, 0, 0, SRCCopy);
  OpenClipBoard(handle);
  EmptyClipBoard;
  SetClipBoardData(CF_Bitmap, hBM);
  CloseClipBoard;
  SelectObject(hDestDC,hbmold);
  DeleteObject(hbm);
  DeleteDC(hDestDC);
  DeleteDC(hSourcDC);
end;

procedure TfrmMain.CopyStringToClipboard(const s: Widestring);
var hg: THandle;
    P: PChar;
begin
  if OpenClipboard(Handle) then
  begin
    try
      EmptyClipBoard;
      hg:=GlobalAlloc(GMEM_DDESHARE or GMEM_MOVEABLE, Length(S)+1);
      try
        P:=GlobalLock(hg);
        try
          StrPCopy(P, s);
          SetClipboardData(CF_TEXT, hg);
        finally
          GlobalUnlock(hg);
        end;
      except
        GlobalFree(hg);
        raise
      end;
    finally
      CloseClipboard;
    end;
  end
end;

procedure TfrmMain.OnStateChange;
var
  VNewState: TStateEnum;
begin
  VNewState := FState.State;
  if VNewState <> ao_select_rect then begin
    FSelectionRect.Reset;
  end;
  FMarshrutComment:='';
  TBmove.Checked := VNewState = ao_movemap;
  TBCalcRas.Checked := VNewState=ao_calc_line;
  TBRectSave.Checked :=
    (VNewState=ao_select_poly)or
    (VNewState=ao_select_rect)or
    (VNewState=ao_select_line);
  TBAdd_Point.Checked := VNewState=ao_edit_point;
  TBAdd_Line.Checked := VNewState=ao_edit_line;
  TBAdd_Poly.Checked := VNewState=ao_edit_Poly;
  TBEditPath.Visible := false;
  tbitmSaveMark.Visible :=
    (VNewState=ao_Edit_line)or
    (VNewState=ao_Edit_Poly);
  tbitmSaveMark.DropdownCombo :=
    ((VNewState=ao_Edit_line) and (FEditMarkLine <> nil))or
    ((VNewState=ao_Edit_Poly) and (FEditMarkPoly <> nil));
  tbitmSaveMarkAsNew.Visible := tbitmSaveMark.DropdownCombo;
  TBEditPathOk.Visible :=
    (VNewState=ao_select_poly)or
    (VNewState=ao_select_line);
  TBEditPathLabel.Visible := (VNewState=ao_calc_line);
  TBEditPathMarsh.Visible := (VNewState=ao_Edit_line);
  TBEditMagnetDraw.Visible :=
    (VNewState=ao_Edit_line)or
    (VNewState=ao_Edit_Poly)or
    (VNewState=ao_select_poly)or
    (VNewState=ao_select_line);
  TBEditSelectPolylineRadius.Visible:=VNewState=ao_select_line;
  TBEditSelectPolylineRadiusCap1.Visible:=VNewState=ao_select_line;
  TBEditSelectPolylineRadiusCap2.Visible:=VNewState=ao_select_line;
  if FLineOnMapEdit <> nil then begin
    FLineOnMapEdit.Clear;
  end;

  if VNewState <> ao_edit_point then begin
    FPointOnMapEdit.Clear;
  end;

  FLineOnMapEdit := FLineOnMapByOperation[VNewState];
  if VNewState=ao_select_line then begin
   TBEditSelectPolylineRadius.Value :=
    Round(FConfig.LayersConfig.SelectionPolylineLayerConfig.ShadowConfig.Radius);
  end;

  case VNewState of
    ao_movemap: map.Cursor:=crDefault;
    ao_calc_line: map.Cursor:=2;
    ao_select_poly,ao_select_rect,ao_select_line: map.Cursor:=crDrag;
    ao_edit_point,ao_edit_Line,ao_edit_poly: map.Cursor:=4;
  end;
  if VNewState <> ao_edit_line then begin
    FEditMarkLine := nil;
  end;
  if VNewState <> ao_edit_poly then begin
    FEditMarkPoly := nil;
  end;
  if VNewState <> ao_edit_point then begin
    FEditMarkPoint := nil;
  end;
end;

procedure TfrmMain.OnAfterViewChange;
begin
  map.EndUpdate;
  map.Changed;
end;

procedure TfrmMain.OnBeforeViewChange;
begin
  map.BeginUpdate;
end;

procedure TfrmMain.OnClickLayerItem(Sender: TObject);
var
  VSender: TTBCustomItem;
  VAtiveMap: IActiveMapSingle;
  VMapType: IMapType;
begin
  if Sender is TTBCustomItem then begin
    VSender := TTBCustomItem(Sender);
    VAtiveMap := IActiveMapSingle(VSender.Tag);
    if VAtiveMap <> nil then begin
      VMapType := VAtiveMap.GetMapType;
      if VMapType <> nil then begin
        FConfig.MainMapsConfig.LockWrite;
        try
          if not FConfig.MainMapsConfig.GetActiveLayersSet.IsGUIDSelected(VMapType.GUID) then begin
            FConfig.MainMapsConfig.SelectLayerByGUID(VMapType.GUID);
          end else begin
            FConfig.MainMapsConfig.UnSelectLayerByGUID(VMapType.GUID);
          end;
        finally
          FConfig.MainMapsConfig.UnlockWrite;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.OnClickMapItem(Sender: TObject);
var
  VSender: TComponent;
  VAtiveMap: IActiveMapSingle;
  VMapType: IMapType;
begin
  if Sender is TComponent then begin
    VSender := TComponent(Sender);
    VAtiveMap := IActiveMapSingle(VSender.Tag);
    if VAtiveMap <> nil then begin
      VMapType := VAtiveMap.GetMapType;
      if VMapType <> nil then begin
        FConfig.MainMapsConfig.SelectMainByGUID(VMapType.GUID);
      end;
    end;
  end;
end;

procedure TfrmMain.OnFillingMapChange;
var
  VVisible: Boolean;
  VRelative: Boolean;
  VZoom: Byte;
begin
  FConfig.LayersConfig.FillingMapLayerConfig.LockRead;
  try
    VVisible := FConfig.LayersConfig.FillingMapLayerConfig.Visible;
    VRelative := FConfig.LayersConfig.FillingMapLayerConfig.UseRelativeZoom;
    VZoom := FConfig.LayersConfig.FillingMapLayerConfig.Zoom;
  finally
    FConfig.LayersConfig.FillingMapLayerConfig.UnlockRead;
  end;
  if VVisible then begin
    if VRelative then begin
      TBMapZap.Caption:='+'+inttostr(VZoom);
    end else begin
      TBMapZap.Caption:='z'+inttostr(VZoom + 1);
    end;
  end else begin
    TBMapZap.Caption:='';
  end;
end;

procedure TfrmMain.OnLineOnMapEditChange;
var
  VLineOnMapEdit: ILineOnMapEdit;
  VPathOnMapEdit: IPathOnMapEdit;
  VPolygonOnMapEdit: IPolygonOnMapEdit;
  VSaveAviable: Boolean;
  VPath: ILonLatPath;
  VPoly: ILonLatPolygon;
begin
  VLineOnMapEdit := FLineOnMapEdit;
  if VLineOnMapEdit <> nil then begin
    VSaveAviable := False;
    if Supports(VLineOnMapEdit, IPathOnMapEdit, VPathOnMapEdit) then begin
      VPath := VPathOnMapEdit.Path;
      if VPath.Count > 0 then begin
        VSaveAviable := (VPath.Item[0].Count > 1) or (VPath.Count > 1);
      end;
    end else if Supports(VLineOnMapEdit, IPolygonOnMapEdit, VPolygonOnMapEdit) then begin
      VPoly := VPolygonOnMapEdit.Polygon;
      if VPoly.Count > 0 then begin
        VSaveAviable := (VPoly.Item[0].Count > 2) or (VPoly.Count > 1);
      end;
    end;
    TBEditPath.Visible := VSaveAviable;
  end;
end;

procedure TfrmMain.OnMainFormMainConfigChange;
var
  VGUID: TGUID;
  i: Integer;
  VToolbarItem: TTBCustomItem;
  VItem: IGeoCoderListEntity;
begin
  Nbackload.Checked := FConfig.LayersConfig.MainMapLayerConfig.UsePrevZoomAtMap;
  NbackloadLayer.Checked := FConfig.LayersConfig.MainMapLayerConfig.UsePrevZoomAtLayer;
  map.Color := GState.ViewConfig.BackGroundColor;

  NGoToCur.Checked := FConfig.MapZoomingConfig.ZoomingAtMousePos;
  Ninvertcolor.Checked:=GState.BitmapPostProcessingConfig.InvertColor;
  TBGPSToPoint.Checked:=FConfig.GPSBehaviour.MapMove;
  tbitmGPSCenterMap.Checked:=TBGPSToPoint.Checked;
  TBGPSToPointCenter.Checked:=FConfig.GPSBehaviour.MapMoveCentered;
  tbitmGPSToPointCenter.Checked:=TBGPSToPointCenter.Checked;
  NBlock_toolbars.Checked:=FConfig.ToolbarsLock.GetIsLock;
  tbitmShowMarkCaption.Checked := FConfig.LayersConfig.MarksLayerConfig.MarksDrawConfig.ShowPointCaption;

  TBHideMarks.Checked := not(FConfig.LayersConfig.MarksLayerConfig.MarksShowConfig.IsUseMarks);
  TBEditMagnetDraw.Checked := FConfig.LayersConfig.MarksLayerConfig.MarksDrawConfig.MagnetDraw;

  if FConfig.MainConfig.ShowMapName then begin
    TBSMB.Caption := FConfig.MainMapsConfig.GetSelectedMapType.MapType.GUIConfig.Name.Value;
  end else begin
    TBSMB.Caption := '';
  end;

  Nanimate.Checked := FConfig.MapZoomingConfig.AnimateZoom;

  NAnimateMove.Checked := FConfig.MapMovingConfig.AnimateMove;

  VGUID := FConfig.MainGeoCoderConfig.ActiveGeoCoderGUID;
  for i := 0 to TBXSelectSrchType.Count - 1 do begin
    VToolbarItem := TBXSelectSrchType.Items[i];
    VItem := IGeoCoderListEntity(VToolbarItem.Tag);
    if VItem <> nil then begin
      if IsEqualGUID(VGUID, VItem.GetGUID) then begin
        VToolbarItem.Checked := True;
        TBXSelectSrchType.Caption := VToolbarItem.Caption;
      end;
    end;
  end;
end;

procedure TfrmMain.OnMainMapChange;
var
  VGUID: TGUID;
  VMapType: IMapType;
begin
  VGUID := FConfig.MainMapsConfig.GetActiveMap.GetSelectedGUID;

  TBSMB.ImageIndex := FMapTypeIcons24List.GetIconIndexByGUID(VGUID);
  if FConfig.MainConfig.ShowMapName then begin
    VMapType := FConfig.MainMapsConfig.GetActiveMap.GetMapsSet.GetMapTypeByGUID(VGUID);
    TBSMB.Caption := VMapType.MapType.GUIConfig.Name.Value;
  end else begin
    TBSMB.Caption := '';
  end;
end;

procedure TfrmMain.OnMapGUIChange;
begin
  FMapHotKeyList := GState.MapType.GUIConfigList.HotKeyList;
  CreateMapUIMapsList;
  CreateMapUILayersList;
  CreateMapUIFillingList;
  CreateMapUILayerSubMenu;

  if FConfig.MainConfig.ShowMapName then begin
    TBSMB.Caption := FConfig.MainMapsConfig.GetSelectedMapType.MapType.GUIConfig.Name.Value;
  end else begin
    TBSMB.Caption := '';
  end;
end;

procedure TfrmMain.SetToolbarsLock(AValue: Boolean);
begin
  TBDock.AllowDrag := not AValue;
  TBDockLeft.AllowDrag := not AValue;
  TBDockRight.AllowDrag := not AValue;
  TBDockBottom.AllowDrag := not AValue;
  TBXDock1.AllowDrag := not AValue;
  TBXDockForSearch.AllowDrag := not AValue;
  NBlock_toolbars.Checked := AValue;
end;

procedure TfrmMain.OnToolbarsLockChange;
begin
  SetToolbarsLock(FConfig.ToolbarsLock.GetIsLock);
end;

procedure TfrmMain.OnWinPositionChange;
var
  VIsFullScreen: Boolean;
  VIsMaximized: Boolean;
  VRect: TRect;
begin
  FWinPosition.LockRead;
  try
    VIsFullScreen := FWinPosition.GetIsFullScreen;
    VIsMaximized := FWinPosition.GetIsMaximized;
    VRect := FWinPosition.GetBoundsRect;
  finally
    FWinPosition.UnlockRead;
  end;
  TBFullSize.Checked := VIsFullScreen;
  NFoolSize.Checked:=VIsFullScreen;
  TBexit.Visible:=VIsFullScreen;
  TBDock.Parent:=Self;
  TBDockLeft.Parent:=Self;
  TBDockBottom.Parent:=Self;
  TBDockRight.Parent:=Self;
  TBDock.Visible:=not(VIsFullScreen);
  TBDockLeft.Visible:=not(VIsFullScreen);
  TBDockBottom.Visible:=not(VIsFullScreen);
  TBDockRight.Visible:=not(VIsFullScreen);
  if VIsFullScreen then begin
    Self.WindowState := wsMaximized;
    SetBounds(
      Monitor.Left + Left - ClientOrigin.X,
      Monitor.Top + Top - ClientOrigin.Y,
      Monitor.Width + (Width - ClientWidth),
      Monitor.Height + (Height - ClientHeight)
    );
  end else begin
    if VIsMaximized then begin
      if Self.WindowState <> wsMaximized then begin
        if not EqualRect(BoundsRect, VRect) then begin
          Self.BoundsRect:= VRect;
        end;
      end;
      Self.WindowState := wsMaximized;
      SetBounds(
        Monitor.Left,
        Monitor.Top,
        Monitor.Width,
        Monitor.Height
      );
    end else begin
      Self.WindowState := wsNormal;
      Self.BoundsRect:= VRect;
    end;
  end;
end;

//��������� ������� ������� � ��������
procedure TfrmMain.DoMessageEvent(var Msg: TMsg; var Handled: Boolean);
var
  z: integer;
  VZoom: Byte;
  VNewZoom: integer;
begin
  if Active then begin
    if not FMapZoomAnimtion then begin
      FKeyMovingHandler.DoMessageEvent(Msg, Handled);
      if not Handled then begin
        case Msg.message of
          WM_MOUSEWHEEL: begin
            if FConfig.MainConfig.MouseScrollInvert then z:=-1 else z:=1;
            VZoom := FConfig.ViewPortState.GetCurrentZoom;
            if Msg.wParam<0 then begin
              VNewZoom := VZoom-z;
            end else begin
              VNewZoom := VZoom+z;
            end;
            if VNewZoom < 0 then VNewZoom := 0;
            zooming(
              VNewZoom,
              FMouseState.CurentPos,
              FConfig.MapZoomingConfig.ZoomingAtMousePos
            );
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.DoSelectSpecialVersion(Sender: TObject);
var
  VVersion: IMapVersionInfo;
  VMapType: TMapType;
begin
  if (nil<>Sender) and (Sender is TTBXItemSelectMapVersion) then begin
    if TTBXItemSelectMapVersion(Sender).Checked then begin
      VVersion := nil;
    end else begin
      VVersion := TTBXItemSelectMapVersion(Sender).MapVersion;
    end;
  end else begin
    // clear
    VVersion := nil;
  end;

  // for current map
  VMapType:=FConfig.MainMapsConfig.GetSelectedMapType.MapType;

  // apply this version or clear (uncheck) version
  VMapType.VersionConfig.Version := VVersion;
end;

procedure TfrmMain.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
var
  VShortCut: TShortCut;
  VMap: IMapType;
  VMapType: TMapType;
  VCancelSelection: Boolean;
  VLineOnMapEdit: ILineOnMapEdit;
begin
  if Self.Active then begin
    VShortCut := ShortCutFromMessage(Msg);
    case VShortCut of
      VK_BACK: begin
        if FLineOnMapEdit <> nil then begin
          FLineOnMapEdit.DeleteActivePoint;
          Handled := True;
        end;
      end;
      VK_ESCAPE: begin
        case FState.State of
          ao_select_rect: begin
            VCancelSelection := False;
            FSelectionRect.LockWrite;
            try
              if FSelectionRect.IsEmpty then begin
                VCancelSelection := True;
              end;
              FSelectionRect.Reset;
            finally
              FSelectionRect.UnlockWrite;
            end;
            if VCancelSelection then begin
              FState.State := ao_movemap;
            end;
            Handled := True;
          end;
          ao_edit_point: begin
            FState.State := ao_movemap;
            Handled := True;
          end;
          ao_select_poly,
          ao_select_line,
          ao_calc_line: begin
            VLineOnMapEdit := FLineOnMapEdit;
            if VLineOnMapEdit <> nil then begin
              if not VLineOnMapEdit.IsEmpty then begin
                VLineOnMapEdit.Clear;
              end else begin
                FState.State := ao_movemap;
              end;
              Handled := True;
            end;
          end;
          ao_edit_line: begin
            if FEditMarkLine = nil then begin
              VLineOnMapEdit := FLineOnMapEdit;
              if VLineOnMapEdit <> nil then begin
                if not VLineOnMapEdit.IsEmpty then begin
                  VLineOnMapEdit.Clear;
                end else begin
                  FState.State := ao_movemap;
                end;
                Handled := True;
              end;
            end else begin
              FState.State := ao_movemap;
              Handled := True;
            end;
          end;
          ao_edit_poly: begin
            if FEditMarkPoly = nil then begin
              VLineOnMapEdit := FLineOnMapEdit;
              if VLineOnMapEdit <> nil then begin
                if not VLineOnMapEdit.IsEmpty then begin
                  VLineOnMapEdit.Clear;
                end else begin
                  FState.State := ao_movemap;
                end;
                Handled := True;
              end;
            end else begin
              FState.State := ao_movemap;
              Handled := True;
            end;
          end;
        end;
      end;
      VK_RETURN: begin
        case FState.State of
          ao_edit_Poly: begin
            VLineOnMapEdit := FLineOnMapEdit;
            if VLineOnMapEdit <> nil then begin
              if VLineOnMapEdit.IsReady then begin
                TBEditPathSaveClick(Self);
                Handled := True;
              end;
            end;
          end;
          ao_edit_line,
          ao_select_line: begin
            VLineOnMapEdit := FLineOnMapEdit;
            if VLineOnMapEdit <> nil then begin
              if VLineOnMapEdit.IsReady then begin
                TBEditPathSaveClick(Self);
                Handled := True;
              end;
            end;
          end;
          ao_select_poly: begin
            VLineOnMapEdit := FLineOnMapEdit;
            if VLineOnMapEdit <> nil then begin
              if VLineOnMapEdit.IsReady then begin
                TBEditPathOkClick(Self);
                Handled := True;
              end;
            end;
          end;
        end;
      end;
      VK_F11: begin
        TBFullSizeClick(nil);
        Handled := True;
      end;
    else
      VMap := FMapHotKeyList.GetMapTypeGUIDByHotKey(VShortCut);
      if VMap <> nil then begin
        VMapType := VMap.MapType;
        if VMapType.Abilities.IsLayer then begin
          FConfig.MainMapsConfig.LockWrite;
          try
            if not FConfig.MainMapsConfig.GetActiveLayersSet.IsGUIDSelected(VMapType.Zmp.GUID) then begin
              FConfig.MainMapsConfig.SelectLayerByGUID(VMapType.Zmp.GUID);
            end else begin
              FConfig.MainMapsConfig.UnSelectLayerByGUID(VMapType.Zmp.GUID);
            end;
          finally
            FConfig.MainMapsConfig.UnlockWrite;
          end;
        end else begin
          FConfig.MainMapsConfig.SelectMainByGUID(VMapType.Zmp.GUID);
        end;
        Handled := True;
      end;
    end;
  end;
end;

procedure TfrmMain.zooming(ANewZoom:byte; const AMousePos: TPoint; move:boolean);
var
  ts1,ts2,ts3,fr:int64;
  Scale: Double;
  VZoom: Byte;
  VAlfa: Double;
  VTime: Double;
  VLastTime: Double;
  VMaxTime: Double;
  VUseAnimation: Boolean;
begin
  if (FMapZoomAnimtion)or(FMapMoving)or(ANewZoom>23) then exit;
  FMapZoomAnimtion:=True;
  try
    VZoom := FConfig.ViewPortState.GetCurrentZoom;
    if VZoom <> ANewZoom then begin
      VMaxTime := FConfig.MapZoomingConfig.AnimateZoomTime;
      VUseAnimation :=
        (FConfig.MapZoomingConfig.AnimateZoom) and
        (VMaxTime > 0);

      if move then begin
        FConfig.ViewPortState.ChangeZoomWithFreezeAtVisualPoint(ANewZoom, AMousePos);
      end else begin
        FConfig.ViewPortState.ChangeZoomWithFreezeAtCenter(ANewZoom);
      end;

      if VUseAnimation then begin
        VTime := 0;
        VLastTime := 0;
        QueryPerformanceCounter(ts1);
        ts3 := ts1;
        while (VTime + VLastTime < VMaxTime) do begin
          VAlfa := VTime/VMaxTime;
          if VZoom>ANewZoom then begin
            Scale := 2 - VAlfa;
          end else begin
            Scale := (1 + VAlfa)/2;
          end;
          if move then begin
            FConfig.ViewPortState.ScaleTo(Scale, AMousePos);
          end else begin
            FConfig.ViewPortState.ScaleTo(Scale);
          end;
          application.ProcessMessages;
          QueryPerformanceCounter(ts2);
          QueryPerformanceFrequency(fr);
          VLastTime := (ts2-ts3)/(fr/1000);
          VTime := (ts2-ts1)/(fr/1000);
          ts3 := ts2;
        end;
        Scale := 1;
        if move then begin
          FConfig.ViewPortState.ScaleTo(Scale, AMousePos);
        end else begin
          FConfig.ViewPortState.ScaleTo(Scale);
        end;
      end;
    end;
  finally
    FMapZoomAnimtion:=False;
  end;
end;

procedure TfrmMain.MapMoveAnimate(const AMouseMoveSpeed: TDoublePoint; const ALastTime:double; AZoom:byte; const AMousePos:TPoint);
var
  ts1,ts2,fr:int64;
  VTime: Double;
  VMaxTime: Double;
  Vk: Double;
  VMapDeltaXY:TDoublePoint;
  VMapDeltaXYmul:TDoublePoint;
  VLastDrawTime:double;
  VMousePPS: Double;
  VLastTime: double;
begin
  FMapMoveAnimtion:=True;
  try
    VMousePPS := sqrt(sqr(AMouseMoveSpeed.X)+sqr(AMouseMoveSpeed.Y));

    if (FConfig.MapMovingConfig.AnimateMove)and(VMousePPS>FConfig.MapMovingConfig.AnimateMinStartSpeed) then begin
      VMaxTime := FConfig.MapMovingConfig.AnimateMoveTime / 1000; // ������������ ����� ����������� �������
      VTime := 0; // ����� ��������� � ������ ��������

      VMapDeltaXYmul.X := AMouseMoveSpeed.X / VMousePPS;
      VMapDeltaXYmul.Y := AMouseMoveSpeed.Y / VMousePPS;

      if VMousePPS>FConfig.MapMovingConfig.AnimateMaxStartSpeed then begin
        VMousePPS:=FConfig.MapMovingConfig.AnimateMaxStartSpeed;
      end;
      VLastTime := ALastTime;

      repeat
        Vk:=VMousePPS * VMaxTime; //���������� � ��������, ������� �� ������� �� ��������� AMousePPS �� ����� VMaxTime
        Vk:=Vk*(VLastTime/VMaxTime); //�� ����� ���������� ��������� ��, ������� �� ������ �� ����� ALastTime (����� ����������� �� ��������� ChangeMapPixelByDelta)
        Vk:=Vk*(exp(-VTime/VMaxTime)-exp(-1)); //��������� ���������������, -exp(-1) ����� ��� ����, ���� � ��������� ������� VMaxTime � ��� �������� ���� =0
        VMapDeltaXY.x:=VMapDeltaXYmul.x*Vk;
        VMapDeltaXY.y:=VMapDeltaXYmul.y*Vk;

        QueryPerformanceCounter(ts1);
        FConfig.ViewPortState.ChangeMapPixelByDelta(VMapDeltaXY);
        application.ProcessMessages;
        QueryPerformanceCounter(ts2);
        QueryPerformanceFrequency(fr);

        VLastDrawTime := (ts2-ts1)/fr;
        VTime := VTime + VLastDrawTime;
        VLastTime:=VLastTime+0.3*(VLastDrawTime-VLastTime); //����� ��������� �������� ���������� � ����������� (���� �������� ���� ������ �� ����� ��������)
      until (VTime>=VMaxTime)or(AZoom<>FConfig.ViewPortState.GetCurrentZoom)or
            (AMousePos.X<>FMouseState.GetLastUpPos(FMapMovingButton).X)or
            (AMousePos.Y<>FMouseState.GetLastUpPos(FMapMovingButton).Y);
    end;
  finally
    FMapMoveAnimtion:=false;
  end;
end;

procedure TfrmMain.NzoomInClick(Sender: TObject);
begin
  zooming(
    FConfig.ViewPortState.GetCurrentZoom + 1,
    FMouseState.CurentPos,
    false
  );
end;

procedure TfrmMain.NZoomOutClick(Sender: TObject);
begin
  zooming(
    FConfig.ViewPortState.GetCurrentZoom - 1,
    FMouseState.CurentPos,
    false
  );
end;


Procedure TfrmMain.FormMove(Var Msg: TWMMove);
Begin
  Inherited;
  FormResize(self);
End;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  if FWinPosition <> nil then begin
    if not FWinPosition.GetIsFullScreen then begin
      if Self.WindowState = wsMaximized then begin
        FWinPosition.SetMaximized;
      end else if Self.WindowState = wsNormal then begin
        FWinPosition.SetWindowPosition(Self.BoundsRect);
      end;
    end;
  end;
end;

procedure TfrmMain.TBmoveClick(Sender: TObject);
begin
  FState.State := ao_movemap;
end;

procedure TfrmMain.tbpmiClearVersionClick(Sender: TObject);
begin
  DoSelectSpecialVersion(nil);
end;

procedure TfrmMain.tbpmiVersionsPopup(Sender: TTBCustomItem; FromLink: Boolean);
var
  VMapType: TMapType;
  VLocalConverter: ILocalCoordConverter;
  VConverter: ICoordConverter;
  VZoomCurr: Byte;
  VMousePos: TPoint;
  VMouseMapPoint: TDoublePoint;
  VLonLat: TDoublePoint;
  VMapTile: Tpoint;
  i: Integer;
  VMenuItem: TTBXItemSelectMapVersion;
  VCurrentVersion: String;
  VList: IMapVersionListStatic;
  VVersion: IMapVersionInfo;
  VNewIndex: Integer;
begin
  // remove all versions
  while (tbpmiVersions.Count>1) do begin
    tbpmiVersions.Delete(1);
  end;
  //FMapVersionList := nil;

  // and add view items
  VMapType:=FConfig.MainMapsConfig.GetSelectedMapType.MapType;
  if VMapType.AllowListOfTileVersions then begin
    // to lonlat
    VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
    VConverter := VLocalConverter.GetGeoConverter;
    VZoomCurr := VLocalConverter.GetZoom;
    VMousePos := MainPopupMenu.PopupPoint;
    VMouseMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(VMousePos);
    VConverter.CheckPixelPosFloatStrict(VMouseMapPoint, VZoomCurr, False);
    VLonLat := VConverter.PixelPosFloat2LonLat(VMouseMapPoint, VZoomCurr);

    // to map
    VMapTile := VMapType.GeoConvert.LonLat2TilePos(VLonLat, VZoomCurr);

    // get current version
    VVersion := VMapType.VersionConfig.Version;
    VCurrentVersion := VVersion.StoreString;
    VList := VMapType.TileStorage.GetListOfTileVersions(VMapTile, VZoomCurr, VVersion);
    VVersion := nil;
    // parse list
    if Assigned(VList) then
    for i := 0 to VList.Count-1 do begin
      VVersion := VList.Item[i];
      VMenuItem := TTBXItemSelectMapVersion.Create(tbpmiVersions);
      VMenuItem.MapVersion := VVersion;
      VMenuItem.Caption := VVersion.Caption;
      VMenuItem.Checked := ((0<Length(VCurrentVersion)) and (VCurrentVersion = VVersion.StoreString));
      VMenuItem.OnClick := DoSelectSpecialVersion;
      VMenuItem.Tag := Integer(VVersion);
      // get index (for sorting)
      VNewIndex := 1;
      repeat
        if (VNewIndex>=tbpmiVersions.Count) then
          Break;
        if CompareStr(VVersion.Caption, tbpmiVersions.Items[VNewIndex].Caption)>0 then begin
          break;
        end;
        Inc(VNewIndex);
      until FALSE;
      // insert it
      tbpmiVersions.Insert(VNewIndex, VMenuItem);
    end;
    //FMapVersionList := VList;
  end;
end;

procedure TfrmMain.TBZoom_outClick(Sender: TObject);
begin
  zooming(
    FConfig.ViewPortState.GetCurrentZoom - 1,
    FMouseState.CurentPos,
    false
  );
end;

procedure TfrmMain.terraserver1Click(Sender: TObject);
var
  VLocalConverter: ILocalCoordConverter;
  VConverter: ICoordConverter;
  VZoom: Byte;
  VMouseMapPoint: TDoublePoint;
  VLonLat:TDoublePoint;
begin
  VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
  VConverter := VLocalConverter.GetGeoConverter;
  VZoom := VLocalConverter.GetZoom;
  VMouseMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(FMouseState.GetLastDownPos(mbRight));
  VConverter.CheckPixelPosFloatStrict(VMouseMapPoint, VZoom, False);
  VLonLat := VConverter.PixelPosFloat2LonLat(VMouseMapPoint, VZoom);
  CopyStringToClipboard(
    'http://www.terraserver.com/view.asp?' +
    'cx=' + RoundEx(VLonLat.x, 4) +
    '&cy=' + RoundEx(VLonLat.y, 4) +
    // scale (by zoom and lat):
    // 10 (failed), 5 if (zoom <= 15), 2.5 if (zoom = 16), 1.5 if (zoom = 17), 1, 0.75 (zoom = 18), 0.5, 0.25, 0.15 (failed)
    // select from values above (round up to nearest) for another values
    '&mpp=5' +
    '&proj=4326&pic=img&prov=-1&stac=-1&ovrl=-1&vic='
  );
end;

procedure TfrmMain.TBZoomInClick(Sender: TObject);
begin
  zooming(
    FConfig.ViewPortState.GetCurrentZoom + 1,
    FMouseState.CurentPos,
    false
  );
end;

procedure TfrmMain.WMGetMinMaxInfo(var msg:TWMGetMinMaxInfo);
begin
 inherited;
 with msg.MinMaxInfo^.ptMaxTrackSize do begin
  X:=GetDeviceCaps(Canvas.handle,HORZRES)+(Width-ClientWidth);
  Y:=GetDeviceCaps(Canvas.handle,VERTRES)+(Height-ClientHeight);
 end;
end;

procedure TfrmMain.WMTIMECHANGE(var m: TMessage);
begin
  inherited;
  SystemTimeChanged;
  // notify track writer
  try
    if Assigned(GState.GPSRecorder) then
      GState.GPSRecorder.ExecuteGPSCommand(Self, cUnitIndex_Reserved, gpsc_LocalTimeChanged, nil);
  except
  end;
end;

procedure TfrmMain.TBFullSizeClick(Sender:TObject);
begin
  FWinPosition.LockWrite;
  try
    if FWinPosition.GetIsFullScreen then begin
      FWinPosition.SetNoFullScreen;
    end else begin
      FWinPosition.SetFullScreen;
    end;
  finally
    FWinPosition.UnlockWrite;
  end;
end;

procedure TfrmMain.ZoomToolBarDockChanging(Sender: TObject; Floating: Boolean; DockingTo: TTBDock);
begin
  if (DockingTo=TBDockLeft)or(DockingTo=TBDockRight) then begin
    if FRuller.Width>FRuller.Height then begin
        FRuller.Rotate270();
        FTumbler.Rotate270();
    end;
    ZoomToolBar.Items.Move(ZoomToolBar.Items.IndexOf(TBZoom_out),4);
    ZoomToolBar.Items.Move(ZoomToolBar.Items.IndexOf(TBZoomin),0);
  end else begin
    if FRuller.Width<FRuller.Height then begin
        FRuller.Rotate90();
        FTumbler.Rotate90();
    end;
    ZoomToolBar.Items.Move(ZoomToolBar.Items.IndexOf(TBZoom_out),0);
    ZoomToolBar.Items.Move(ZoomToolBar.Items.IndexOf(TBZoomin),4);
  end;
  PaintZSlider(FConfig.ViewPortState.GetCurrentZoom);
end;

procedure TfrmMain.NCalcRastClick(Sender: TObject);
begin
 TBCalcRas.Checked:=true;
 TBCalcRasClick(self);
end;

procedure TfrmMain.tbitmQuitClick(Sender: TObject);
begin
 close;
end;

procedure TfrmMain.tbitmOptionsClick(Sender: TObject);
begin
  FfrmSettings.ShowModal;
end;

procedure TfrmMain.NbackloadClick(Sender: TObject);
begin
  FConfig.LayersConfig.MainMapLayerConfig.UsePrevZoomAtMap := (Sender as TTBXItem).Checked;
end;

procedure TfrmMain.NbackloadLayerClick(Sender: TObject);
begin
  FConfig.LayersConfig.MainMapLayerConfig.UsePrevZoomAtLayer := (Sender as TTBXItem).Checked;
end;

procedure TfrmMain.NBlock_toolbarsClick(Sender: TObject);
begin
  FConfig.ToolbarsLock.SetLock(NBlock_toolbars.Checked);
end;

procedure TfrmMain.NaddPointClick(Sender: TObject);
var
  VLocalConverter: ILocalCoordConverter;
  VMouseMapPoint: TDoublePoint;
  VConverter: ICoordConverter;
  VZoomCurr: Byte;
  VMouseLonLat: TDoublePoint;
begin
  VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
  VZoomCurr := VLocalConverter.GetZoom;
  VConverter := VLocalConverter.GetGeoConverter;
  VMouseMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(FMouseState.GetLastDownPos(mbRight));
  VConverter.CheckPixelPosFloatStrict(VMouseMapPoint, VZoomCurr, True);
  VMouseLonLat := VConverter.PixelPosFloat2LonLat(VMouseMapPoint, VZoomCurr);
  if FMarkDBGUI.AddNewPointModal(VMouseLonLat) then begin
    FState.State := ao_movemap;
  end;
end;

procedure TfrmMain.tbitmCopyToClipboardMainMapTileClick(Sender: TObject);
var
  btm:TBitmap32;
  btm1:TBitmap;
  VMouseMapPoint: TDoublePoint;
  VZoomCurr: Byte;
  VConverter: ICoordConverter;
  VMapType: TMapType;
  VLocalConverter: ILocalCoordConverter;
  VTile: TPoint;
  VBitmapTile: IBitmap32Static;
begin
  VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
  VMouseMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(FMouseState.GetLastDownPos(mbRight));
  VZoomCurr := VLocalConverter.GetZoom;
  VConverter := VLocalConverter.GetGeoConverter;
  VMapType := FConfig.MainMapsConfig.GetSelectedMapType.MapType;

  VConverter.CheckPixelPosFloatStrict(VMouseMapPoint, VZoomCurr, True);
  VTile := VConverter.PixelPosFloat2TilePos(VMouseMapPoint, VZoomCurr);
  VBitmapTile := VMapType.LoadTileUni(VTile, VZoomCurr, VConverter, True, True, False);
  if VBitmapTile <> nil then begin
    btm := TBitmap32.Create;
    try
      btm.Assign(VBitmapTile.Bitmap);
      btm1:=TBitmap.Create;
      try
        btm1.Width:=btm.Width;
        btm1.Height:=btm.Height;
        btm.DrawTo(btm1.Canvas.Handle,0,0);
        CopyBtmToClipboard(btm1);
      finally
        btm1.Free;
      end;
    finally
      btm.Free;
    end;
  end;
end;

procedure TfrmMain.tbitmCopyToClipboardCoordinatesClick(Sender: TObject);
var
  VMouseLonLat: TDoublePoint;
  VStr: string;
  VLocalConverter: ILocalCoordConverter;
  VZoomCurr: Byte;
  VConverter: ICoordConverter;
  VMouseMapPoint: TDoublePoint;
begin
  VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
  VZoomCurr := VLocalConverter.GetZoom;
  VConverter := VLocalConverter.GetGeoConverter;
  VMouseMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(FMouseState.GetLastDownPos(mbRight));
  VConverter.CheckPixelPosFloatStrict(VMouseMapPoint, VZoomCurr, True);
  VMouseLonLat := VConverter.PixelPosFloat2LonLat(VMouseMapPoint, VZoomCurr);
  VStr := GState.ValueToStringConverterConfig.GetStatic.LonLatConvert(VMouseLonLat);
  CopyStringToClipboard(VStr);
end;

procedure TfrmMain.tbitmCopyToClipboardMainMapTileFileNameClick(Sender: TObject);
var
  VZoomCurr: Byte;
  VMapType: TMapType;
  VLocalConverter: ILocalCoordConverter;
  VConverter: ICoordConverter;
  VMouseMapPoint: TDoublePoint;
  VMouseLonLat: TDoublePoint;
  VTile: TPoint;
begin
  VMapType := FConfig.MainMapsConfig.GetSelectedMapType.MapType;
  if VMapType.StorageConfig.IsStoreFileCache then begin
    VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
    VMouseMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(FMouseState.GetLastDownPos(mbRight));
    VZoomCurr := VLocalConverter.GetZoom;
    VConverter := VLocalConverter.GetGeoConverter;
    VConverter.CheckPixelPosFloatStrict(VMouseMapPoint, VZoomCurr, True);
    VMouseLonLat := VConverter.PixelPosFloat2LonLat(VMouseMapPoint, VZoomCurr);
    VMapType.GeoConvert.CheckLonLatPos(VMouseLonLat);
    VTile := VMapType.GeoConvert.LonLat2TilePos(VMouseLonLat, VZoomCurr);

   // ����������� � ����� ����� � ������ ������. �������� �� ���������� ��� �����.
   CopyStringToClipboard(VMapType.GetTileFileName(VTile, VZoomCurr));
  end else begin
    ShowMessage(SAS_MSG_CantGetTileFileName);
  end;
end;

procedure TfrmMain.tbitmDownloadMainMapTileClick(Sender: TObject);
var
  path:string;
  VMapType:TMapType;
  VZoomCurr: Byte;
  VLocalConverter: ILocalCoordConverter;
  VConverter: ICoordConverter;
  VMouseMapPoint: TDoublePoint;
  VMouseLonLat: TDoublePoint;
  VTile: TPoint;
begin
  if TMenuItem(sender).Tag<>0 then begin
    VMapType := TMapType(TMenuItem(sender).Tag);
  end else begin
    VMapType := FConfig.MainMapsConfig.GetSelectedMapType.MapType;
  end;

  VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
  VMouseMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(FMouseState.GetLastDownPos(mbRight));
  VZoomCurr := VLocalConverter.GetZoom;
  VConverter := VLocalConverter.GetGeoConverter;
  if VConverter.CheckPixelPosFloatStrict(VMouseMapPoint, VZoomCurr, True) then begin
    VMouseLonLat := VConverter.PixelPosFloat2LonLat(VMouseMapPoint, VZoomCurr);
    if VMapType.GeoConvert.CheckLonLatPos(VMouseLonLat) then begin
      VTile := VMapType.GeoConvert.LonLat2TilePos(VMouseLonLat, VZoomCurr);

      path := VMapType.GetTileShowName(VTile, VZoomCurr);

      if ((not(VMapType.tileExists(VTile, VZoomCurr)))or
          (MessageBox(handle,pchar(Format(SAS_MSG_FileExists, [path])),pchar(SAS_MSG_coution),36)=IDYES))
      then begin
        TTileDownloaderUIOneTile.Create(
          GState.DownloaderThreadConfig,
          GState.AppClosingNotifier,
          VTile,
          VZoomCurr,
          VMapType,
          GState.DownloadInfo,
          GState.GlobalInternetState,
          FTileErrorLogger
        );
      end;
    end;
  end;
end;

procedure TfrmMain.tbitmHideThisMarkClick(Sender: TObject);
var
  VMark: IMark;
  VMarkId: IMarkID;
begin
  VMark := FLayerMapMarks.MouseOnReg(FMouseState.GetLastDownPos(mbRight));
  if Supports(VMark, IMarkID, VMarkId) then begin
    FMarkDBGUI.MarksDB.MarksDb.SetMarkVisibleByID(VMarkId, False);
  end;
end;

procedure TfrmMain.tbitmFitToScreenClick(Sender: TObject);
var
  VMark: IMark;
  VLLRect: TDoubleRect;
  VRelativeRect: TDoubleRect;
  VVisualConverter: ILocalCoordConverter;
  VCoordConverter: ICoordConverter;
  VTargetZoom: Byte;
  VCenterLonLat: TDoublePoint;
  VScreenSize: TPoint;
  VMarkMapRect: TRect;
  VMarkMapSize: TPoint;
  VZoom: Byte;
begin
  VMark := FLayerMapMarks.MouseOnReg(FMouseState.GetLastDownPos(mbRight));
  if VMark <> nil then begin
    VLLRect := VMark.LLRect.Rect;
    if not DoublePointsEqual(VLLRect.TopLeft, VLLRect.BottomRight) then begin
      VCenterLonLat.X := (VLLRect.Left + VLLRect.Right) / 2;
      VCenterLonLat.Y := (VLLRect.Top + VLLRect.Bottom) / 2;

      VVisualConverter := FConfig.ViewPortState.GetVisualCoordConverter;
      VCoordConverter := VVisualConverter.GeoConverter;
      VScreenSize := VVisualConverter.GetLocalRectSize;

      VCoordConverter.CheckLonLatRect(VLLRect);
      VRelativeRect := VCoordConverter.LonLatRect2RelativeRect(VLLRect);
      VTargetZoom := 23;
      for VZoom := 1 to 23 do begin
        VMarkMapRect := VCoordConverter.RelativeRect2PixelRect(VRelativeRect, VZoom);
        VMarkMapSize.X := VMarkMapRect.Right - VMarkMapRect.Left;
        VMarkMapSize.Y := VMarkMapRect.Bottom - VMarkMapRect.Top;
        if (VMarkMapSize.X > VScreenSize.X) or (VMarkMapSize.Y > VScreenSize.Y) then begin
          VTargetZoom := VZoom - 1;
          Break;
        end;
      end;
      FConfig.ViewPortState.LockWrite;
      try
        FConfig.ViewPortState.ChangeLonLat(VCenterLonLat);
        FConfig.ViewPortState.ChangeZoomWithFreezeAtCenter(VTargetZoom);
      finally
        FConfig.ViewPortState.UnlockWrite;
      end;
    end else begin
      VCenterLonLat := VLLRect.TopLeft;
      FConfig.ViewPortState.ChangeLonLat(VCenterLonLat);
    end;
  end;
end;

procedure TfrmMain.NopendirClick(Sender: TObject);
var
  VZoomCurr: Byte;
  VLocalConverter: ILocalCoordConverter;
  VConverter: ICoordConverter;
  VMouseMapPoint: TDoublePoint;
  VMouseLonLat: TDoublePoint;
  VTile: TPoint;
  VMapType: TMapType;
begin
  VMapType := FConfig.MainMapsConfig.GetSelectedMapType.MapType;
  if VMapType.StorageConfig.IsStoreFileCache then begin
    VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
    VMouseMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(FMouseState.GetLastDownPos(mbRight));
    VZoomCurr := VLocalConverter.GetZoom;
    VConverter := VLocalConverter.GetGeoConverter;
    VConverter.CheckPixelPosFloatStrict(VMouseMapPoint, VZoomCurr, True);
    VMouseLonLat := VConverter.PixelPosFloat2LonLat(VMouseMapPoint, VZoomCurr);
    VMapType.GeoConvert.CheckLonLatPos(VMouseLonLat);
    VTile := VMapType.GeoConvert.LonLat2TilePos(VMouseLonLat, VZoomCurr);
    // ������� ���� � ������������. �������� �� �������� ����������� ������� ��� ��� �������� ������� �� ��������� ����.
    ShellExecute(0,'open',PChar(VMapType.GetTileFileName(VTile, VZoomCurr)),nil,nil,SW_SHOWNORMAL);
  end else begin
    ShowMessage(SAS_MSG_CantGetTileFileName);
  end;
end;

procedure TfrmMain.tbitmOpenFolderMainMapTileClick(Sender: TObject);
var
  s:string;
  VZoomCurr: Byte;
  VLocalConverter: ILocalCoordConverter;
  VConverter: ICoordConverter;
  VMouseMapPoint: TDoublePoint;
  VMouseLonLat: TDoublePoint;
  VTile: TPoint;
  VMapType: TMapType;
begin
  if TMenuItem(sender).Tag<>0 then begin
    VMapType := TMapType(TMenuItem(sender).Tag);
  end else begin
    VMapType := FConfig.MainMapsConfig.GetSelectedMapType.MapType;
  end;

  if VMapType.StorageConfig.IsStoreFileCache then begin
    VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
    VMouseMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(FMouseState.GetLastDownPos(mbRight));
    VZoomCurr := VLocalConverter.GetZoom;
    VConverter := VLocalConverter.GetGeoConverter;
    VConverter.CheckPixelPosFloatStrict(VMouseMapPoint, VZoomCurr, True);
    VMouseLonLat := VConverter.PixelPosFloat2LonLat(VMouseMapPoint, VZoomCurr);
    VMapType.GeoConvert.CheckLonLatPos(VMouseLonLat);
    VTile := VMapType.GeoConvert.LonLat2TilePos(VMouseLonLat, VZoomCurr);
    s := VMapType.GetTileFileName(VTile, VZoomCurr);
    winexec(PChar('explorer /select,' + s), SW_SHOWNORMAL)
  end else begin
    ShowMessage(SAS_MSG_CantGetTileFileName);
  end;
end;

procedure TfrmMain.NDegScale0Click(Sender: TObject);
var
  VTag: Double;
begin
  TTBXItem(sender).checked := True;
  if NDegScaleUser.Checked = true then
    VTag := (ConvLatLon2Scale(NDegValue.text)*100000000)
  else
    VTag := TTBXItem(sender).Tag;
  NDegValue.text := deg2strvalue(VTag);
  FConfig.LayersConfig.MapLayerGridsConfig.DegreeGrid.LockWrite;
  try
    if VTag = 0 then begin
      FConfig.LayersConfig.MapLayerGridsConfig.DegreeGrid.Visible := False;
      FConfig.LayersConfig.MapLayerGridsConfig.DegreeGrid.Scale := VTag;
    end else begin
      FConfig.LayersConfig.MapLayerGridsConfig.DegreeGrid.Visible := True;
      FConfig.LayersConfig.MapLayerGridsConfig.DegreeGrid.Scale := VTag;
    end;
  finally
    FConfig.LayersConfig.MapLayerGridsConfig.DegreeGrid.UnlockWrite;
  end;
end;

procedure TfrmMain.NDegValueAcceptText(Sender: TObject; var NewText: string;
  var Accept: Boolean);
var
  VTag: Double;
begin
  NDegScaleUser.checked := True;
  VTag := (ConvLatLon2Scale(NewText)*100000000);
  NewText := deg2strvalue(VTag);
//  NDegScaleUser.tag := VTag;
  FConfig.LayersConfig.MapLayerGridsConfig.DegreeGrid.LockWrite;
  try
    if VTag = 0 then begin
      FConfig.LayersConfig.MapLayerGridsConfig.DegreeGrid.Visible := False;
      FConfig.LayersConfig.MapLayerGridsConfig.DegreeGrid.Scale := VTag;
    end else begin
      FConfig.LayersConfig.MapLayerGridsConfig.DegreeGrid.Visible := True;
      FConfig.LayersConfig.MapLayerGridsConfig.DegreeGrid.Scale := VTag;
    end;
  finally
    FConfig.LayersConfig.MapLayerGridsConfig.DegreeGrid.UnlockWrite;
  end;

end;

procedure TfrmMain.NDelClick(Sender: TObject);
var
  s:string;
  VMapType:TMapType;
  VZoomCurr: Byte;
  VLocalConverter: ILocalCoordConverter;
  VConverter: ICoordConverter;
  VMouseMapPoint: TDoublePoint;
  VMouseLonLat: TDoublePoint;
  VTile: TPoint;
begin
  if TMenuItem(sender).Tag<>0 then begin
    VMapType := TMapType(TMenuItem(sender).Tag);
  end else begin
    VMapType := FConfig.MainMapsConfig.GetSelectedMapType.MapType;
  end;

  VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
  VMouseMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(FMouseState.GetLastDownPos(mbRight));
  VZoomCurr := VLocalConverter.GetZoom;
  VConverter := VLocalConverter.GetGeoConverter;
  if VConverter.CheckPixelPosFloatStrict(VMouseMapPoint, VZoomCurr, True) then begin
    VMouseLonLat := VConverter.PixelPosFloat2LonLat(VMouseMapPoint, VZoomCurr);
    if VMapType.GeoConvert.CheckLonLatPos(VMouseLonLat) then begin
      VTile := VMapType.GeoConvert.LonLat2TilePos(VMouseLonLat, VZoomCurr);
      s:=VMapType.GetTileShowName(VTile, VZoomCurr);
      if (MessageBox(handle,pchar(SAS_MSG_youasure+' '+s+'?'),pchar(SAS_MSG_coution),36)=IDYES) then begin
        VMapType.DeleteTile(VTile, VZoomCurr);
      end;
    end;
  end;
end;

procedure TfrmMain.NSRCinetClick(Sender: TObject);
begin
  FConfig.DownloadUIConfig.UseDownload := TTileSource(TTBXItem(Sender).Tag);
end;

procedure TfrmMain.tbitmAboutClick(Sender: TObject);
begin
  if FfrmAbout = nil then begin
    FfrmAbout := TfrmAbout.Create(GState.LanguageManager);
  end;
  FfrmAbout.ShowModal;
end;

procedure TfrmMain.TBREGIONClick(Sender: TObject);
begin
  TBRectSave.ImageIndex:=13;
  if FState.State <> ao_select_poly then begin
    FState.State := ao_select_poly;
  end else begin
    FState.State := ao_movemap;
  end;
end;

procedure TfrmMain.TBRECTClick(Sender: TObject);
begin
  TBRectSave.ImageIndex:=10;
  if FState.State <> ao_select_rect then begin
    FState.State := ao_select_rect;
  end else begin
    FState.State := ao_movemap;
  end;
end;

procedure TfrmMain.TBRectSaveClick(Sender: TObject);
begin
  case TBRectSave.ImageIndex of
   10: begin
         TBRECTClick(Sender);
       end;
   13: begin
         TBREGIONClick(Sender);
       end;
   12: begin
         TBCOORDClick(sender);
       end;
   20: begin
         TBScreenSelectClick(sender);
       end;
   21: begin
         TBPolylineSelectClick(Sender);
       end;
  end;
end;

procedure TfrmMain.TBPolylineSelectClick(Sender: TObject);
begin
  TBRectSave.ImageIndex:=21;
  if FState.State <> ao_select_line then begin
    FState.State := ao_select_line;
  end else begin
    FState.State := ao_movemap;
  end;
end;

procedure TfrmMain.TBPreviousClick(Sender: TObject);
var
  VZoom: Byte;
  VPolygon: ILonLatPolygon;
begin
  GState.LastSelectionInfo.LockRead;
  try
    VZoom := GState.LastSelectionInfo.Zoom;
    VPolygon := GState.LastSelectionInfo.Polygon;
  finally
    GState.LastSelectionInfo.UnlockRead;
  end;
  if VPolygon.Count > 0 then begin
    FState.State := ao_movemap;
    FFormRegionProcess.Show_(VZoom, VPolygon);
  end else begin
    showmessage(SAS_MSG_NeedHL);
  end;
end;

//����� ���������� � �������� ����
procedure TfrmMain.NFillMapClick(Sender: TObject);
var
  VVisible: Boolean;
  VRelative: Boolean;
  VZoom: Byte;
  VSelectedCell: TPoint;
  VFillMode: TFillMode;
  VFilterMode: Boolean;
  VFillFirstDay: TDateTime;
  VFillLastDay: TDateTime;
begin
  FConfig.LayersConfig.FillingMapLayerConfig.LockRead;
  try
    VVisible := FConfig.LayersConfig.FillingMapLayerConfig.Visible;
    VRelative := FConfig.LayersConfig.FillingMapLayerConfig.UseRelativeZoom;
    VZoom := FConfig.LayersConfig.FillingMapLayerConfig.Zoom;
    VFillMode :=FConfig.LayersConfig.FillingMapLayerConfig.FillMode;
    VFilterMode := FConfig.LayersConfig.FillingMapLayerConfig.FilterMode;
    VFillFirstDay := FConfig.LayersConfig.FillingMapLayerConfig.FillFirstDay;
    VFillLastDay:= FConfig.LayersConfig.FillingMapLayerConfig.FillLastDay;
  finally
    FConfig.LayersConfig.FillingMapLayerConfig.UnlockRead;
  end;
  if VVisible then begin
    if VRelative then begin
      VSelectedCell.X := (VZoom + 25) mod 5;
      VSelectedCell.Y := (VZoom + 25) div 5;
    end else begin
      VSelectedCell.X := (VZoom + 1) mod 5;
      VSelectedCell.Y := (VZoom + 1) div 5;
    end;
  end else begin
    VSelectedCell := Point(0,0);
  end;
  TBXToolPalette1.SelectedCell := VSelectedCell;
  if(VFillMode=fmUnexisting) then begin
    NFillMode1.Checked :=True;
  end;
  if(VFillMode=fmExisting) then begin
    NFillMode2.Checked :=True;
  end;
  if(VFillMode=fmGradient) then begin
    NFillMode3.Checked :=True;
  end;
  NShowFillDates.Checked := VFilterMode;
  DateTimePicker1.DateTime := VFillFirstDay;
  DateTimePicker2.DateTime := VFillLastDay;
end;

procedure TfrmMain.NFillMode1Click(Sender: TObject);
begin
  FConfig.LayersConfig.FillingMapLayerConfig.LockWrite;
  try
    FConfig.LayersConfig.FillingMapLayerConfig.FillMode := fmUnexisting;
  finally
    FConfig.LayersConfig.FillingMapLayerConfig.UnlockWrite;
  end;
end;

procedure TfrmMain.NFillMode2Click(Sender: TObject);
begin
  FConfig.LayersConfig.FillingMapLayerConfig.LockWrite;
  try
    FConfig.LayersConfig.FillingMapLayerConfig.FillMode := fmExisting;
  finally
    FConfig.LayersConfig.FillingMapLayerConfig.UnlockWrite;
  end;
end;

procedure TfrmMain.NFillMode3Click(Sender: TObject);
begin
  FConfig.LayersConfig.FillingMapLayerConfig.LockWrite;
  try
    FConfig.LayersConfig.FillingMapLayerConfig.FillMode := fmGradient;
  finally
    FConfig.LayersConfig.FillingMapLayerConfig.UnlockWrite;
  end;
end;

procedure TfrmMain.NShowFillDatesClick(Sender: TObject);
var
  VFilter: Boolean;
begin
  VFilter := not NShowFillDates.Checked;
  FConfig.LayersConfig.FillingMapLayerConfig.LockWrite;
  try
    FConfig.LayersConfig.FillingMapLayerConfig.FilterMode :=  VFilter;
  finally
    FConfig.LayersConfig.FillingMapLayerConfig.UnlockWrite;
  end;
  NShowFillDates.Checked := VFilter;
end;

procedure TfrmMain.DateTimePicker1Change(Sender: TObject);
begin
  FConfig.LayersConfig.FillingMapLayerConfig.LockWrite;
  if(DateTimePicker2.DateTime<DateTimePicker1.DateTime) then DateTimePicker2.DateTime := DateTimePicker1.DateTime;
  try
    FConfig.LayersConfig.FillingMapLayerConfig.FillFirstDay := DateTimePicker1.DateTime;
    FConfig.LayersConfig.FillingMapLayerConfig.FillLastDay := DateTimePicker2.DateTime;
  finally
    FConfig.LayersConfig.FillingMapLayerConfig.UnlockWrite;
  end;
end;

procedure TfrmMain.DateTimePicker2Change(Sender: TObject);
begin
  FConfig.LayersConfig.FillingMapLayerConfig.LockWrite;
  if(DateTimePicker1.DateTime>DateTimePicker2.DateTime) then DateTimePicker1.DateTime := DateTimePicker2.DateTime;
  try
    FConfig.LayersConfig.FillingMapLayerConfig.FillFirstDay := DateTimePicker1.DateTime;
    FConfig.LayersConfig.FillingMapLayerConfig.FillLastDay := DateTimePicker2.DateTime;
  finally
    FConfig.LayersConfig.FillingMapLayerConfig.UnlockWrite;
  end;
end;

procedure TfrmMain.TBXToolPalette1CellClick(Sender: TTBXCustomToolPalette; var ACol, ARow: Integer; var AllowChange: Boolean);
var
  VZoom: Byte;
  VRelative: Boolean;
begin
  if (ACol = 0) and (ARow = 0) then begin
    FConfig.LayersConfig.FillingMapLayerConfig.Visible := False;
  end else begin
    if ARow < 5 then begin
      VZoom := 5 * ARow + ACol - 1;
      VRelative := False;
    end else begin
      VZoom := 5 * (ARow - 5) + ACol;
      VRelative := True;
    end;
    FConfig.LayersConfig.FillingMapLayerConfig.LockWrite;
    try
      FConfig.LayersConfig.FillingMapLayerConfig.Visible := True;
      FConfig.LayersConfig.FillingMapLayerConfig.UseRelativeZoom := VRelative;
      FConfig.LayersConfig.FillingMapLayerConfig.Zoom := VZoom;
    finally
      FConfig.LayersConfig.FillingMapLayerConfig.UnlockWrite;
    end;
  end;
end;

//X-����� ���������� � �������� ����

procedure TfrmMain.tbtpltCenterWithZoomCellClick(Sender: TTBXCustomToolPalette;
  var ACol, ARow: Integer; var AllowChange: Boolean);
var
  VZoom: Byte;
  VMouseDownPoint: TPoint;
begin
  AllowChange:=false;
  VZoom := ((5*ARow)+ACol)-1;
  VMouseDownPoint := FMouseState.GetLastDownPos(mbRight);
  zooming(VZoom,VMouseDownPoint,true);
end;

procedure TfrmMain.TBCalcRasClick(Sender: TObject);
begin
  if FState.State <> ao_calc_line then begin
    FState.State := ao_calc_line;
  end else begin
    FState.State := ao_movemap;
  end;
end;

procedure TfrmMain.tbitmOnlineHelpClick(Sender: TObject);
begin
  OpenUrlInBrowser('http://sasgis.ru/wikisasiya/');
end;

procedure TfrmMain.N000Click(Sender: TObject);
var
  VTag: Integer;
begin
  VTag := TMenuItem(Sender).Tag;
  if VTag = 0 then begin
    FConfig.LayersConfig.MapLayerGridsConfig.TileGrid.Visible := False;
  end else begin
    FConfig.LayersConfig.MapLayerGridsConfig.TileGrid.LockWrite;
    try
      FConfig.LayersConfig.MapLayerGridsConfig.TileGrid.Visible := True;
      if VTag >= 100 then begin
        FConfig.LayersConfig.MapLayerGridsConfig.TileGrid.UseRelativeZoom := True;
        FConfig.LayersConfig.MapLayerGridsConfig.TileGrid.Zoom := VTag - 100;
      end else begin
        FConfig.LayersConfig.MapLayerGridsConfig.TileGrid.UseRelativeZoom := False;
        FConfig.LayersConfig.MapLayerGridsConfig.TileGrid.Zoom := VTag - 1;
      end;
    finally
      FConfig.LayersConfig.MapLayerGridsConfig.TileGrid.UnlockWrite;
    end;
  end;
end;

procedure TfrmMain.NShowGranClick(Sender: TObject);
var
  i:integer;
  VZoom: Byte;
  VGridVisible: Boolean;
  VRelativeZoom: Boolean;
  VGridZoom: Byte;
  VZoomCurr: Byte;
begin
  FConfig.LayersConfig.MapLayerGridsConfig.TileGrid.LockRead;
  try
    VGridVisible := FConfig.LayersConfig.MapLayerGridsConfig.TileGrid.Visible;
    VRelativeZoom := FConfig.LayersConfig.MapLayerGridsConfig.TileGrid.UseRelativeZoom;
    VGridZoom := FConfig.LayersConfig.MapLayerGridsConfig.TileGrid.Zoom;
  finally
    FConfig.LayersConfig.MapLayerGridsConfig.TileGrid.UnlockRead;
  end;

  if not VGridVisible then begin
    NShowGran.Items[0].Checked:=true;
  end else begin
    if VRelativeZoom then begin
      case VGridZoom of
        1: NShowGran.Items[8].Checked:=true;
        2: NShowGran.Items[9].Checked:=true;
        3: NShowGran.Items[10].Checked:=true;
        4: NShowGran.Items[11].Checked:=true;
        5: NShowGran.Items[12].Checked:=true;
      else NShowGran.Items[1].Checked:=true;
      end;
    end;
  end;
  VZoomCurr := FConfig.ViewPortState.GetCurrentZoom;
  NShowGran.Items[1].Caption:=SAS_STR_activescale+' (z'+inttostr(VZoomCurr + 1)+')';
  for i:=2 to 7 do begin
    VZoom := VZoomCurr + i - 2;
    if VZoom < 24 then begin
      NShowGran.Items[i].Caption:=SAS_STR_for+' z'+inttostr(VZoom+1);
      NShowGran.Items[i].Visible:=true;
      NShowGran.Items[i].Tag:=VZoom+1;
      if VGridVisible and not VRelativeZoom and (VZoom = VGridZoom) then begin
        NShowGran.Items[i].Checked:=true
      end else begin
        NShowGran.Items[i].Checked:=false;
      end;
    end else begin
      NShowGran.Items[i].Visible:=false;
    end;
  end;
end;

procedure TfrmMain.TBGPSconnClick(Sender: TObject);
begin
  GState.GPSConfig.GPSEnabled := TTBXitem(sender).Checked;
end;

procedure TfrmMain.TBGPSPathClick(Sender: TObject);
begin
  FConfig.LayersConfig.GPSTrackConfig.Visible := TTBXitem(sender).Checked;
end;

procedure TfrmMain.TBGPSToPointClick(Sender: TObject);
begin
  FConfig.GPSBehaviour.MapMove := TTBXitem(sender).Checked;
end;

procedure TfrmMain.TBHideMarksClick(Sender: TObject);
begin
  FConfig.LayersConfig.MarksLayerConfig.MarksShowConfig.IsUseMarks := not(TBHideMarks.Checked);
end;

procedure TfrmMain.TBCOORDClick(Sender: TObject);
var
  Poly: ILonLatPolygon;
  VSelLonLat: TfrmLonLatRectEdit;
  VLonLatRect: TDoubleRect;
begin
  TBRectSave.ImageIndex:=12;
  VSelLonLat:=
    TfrmLonLatRectEdit.Create(
      GState.LanguageManager,
      FConfig.ViewPortState,
      GState.ValueToStringConverterConfig
    );
  Try
    Poly := GState.LastSelectionInfo.Polygon;
    if Poly.Count > 0 then begin
      VLonLatRect := Poly.Item[0].Bounds.Rect;
    end else begin
      VLonLatRect.TopLeft := FConfig.ViewPortState.GetVisualCoordConverter.GetCenterLonLat;
      VLonLatRect.BottomRight := VLonLatRect.TopLeft;
    end;
    if VSelLonLat.Execute(VLonLatRect) Then Begin
      Poly := GState.VectorItmesFactory.CreateLonLatPolygonByRect(VLonLatRect);
      FState.State := ao_movemap;
      FFormRegionProcess.Show_(FConfig.ViewPortState.GetCurrentZoom, Poly);
      Poly := nil;
    End;
  Finally
    VSelLonLat.Free;
  End;
end;

procedure TfrmMain.ShowstatusClick(Sender: TObject);
begin
  FConfig.LayersConfig.StatBar.Visible := TTBXItem(Sender).Checked;
end;

procedure TfrmMain.TBEditSelectPolylineRadiusChange(Sender: TObject);
begin
  FConfig.LayersConfig.SelectionPolylineLayerConfig.ShadowConfig.Radius := TBEditSelectPolylineRadius.Value;
end;

procedure TfrmMain.ShowMiniMapClick(Sender: TObject);
begin
  FConfig.LayersConfig.MiniMapLayerConfig.Visible := TTBXItem(Sender).Checked;
end;

procedure TfrmMain.ShowLineClick(Sender: TObject);
begin
  FConfig.LayersConfig.ScaleLineConfig.Visible := TTBXItem(Sender).Checked;
end;

procedure TfrmMain.tbitmGaugeClick(Sender: TObject);
begin
  FConfig.LayersConfig.CenterScaleConfig.Visible := TTBXItem(Sender).Checked;
end;

procedure TfrmMain.tbitmGPSTrackSaveToMarksClick(Sender: TObject);
var
  VAllPoints: ILonLatPath;
begin
  VAllPoints := GState.GPSRecorder.GetAllPoints;
  if VAllPoints.Count > 0 then begin
    if FMarkDBGUI.SaveLineModal(nil, VAllPoints, '') then begin
      FState.State := ao_movemap;
    end;
  end else begin
    ShowMessage(SAS_ERR_Nopoints);
  end;
end;

procedure TfrmMain.tbitmNavigationArrowClick(Sender: TObject);
var
  VPoint: TDoublePoint;
begin
  if FConfig.NavToPoint.IsActive then begin
    FConfig.NavToPoint.StopNav;
  end else begin
    VPoint := FConfig.NavToPoint.LonLat;
    if PointIsEmpty(VPoint) then begin
      ShowMessage('Use right-click on mark and choose Navigation to Mark');
    end else begin
      FConfig.NavToPoint.StartNavLonLat(VPoint);
    end;
  end;
end;

procedure TfrmMain.mapResize(Sender: TObject);
begin
  if (not ProgramClose)and(not ProgramStart)then begin
    FConfig.ViewPortState.ChangeViewSize(Point(map.Width, map.Height));
  end;
end;

procedure TfrmMain.TBLoadSelFromFileClick(Sender: TObject);
begin
  if (OpenDialog1.Execute) then begin
    FState.State := ao_movemap;
    FFormRegionProcess.LoadSelFromFile(OpenDialog1.FileName);
  end
end;

procedure TfrmMain.NinvertcolorClick(Sender: TObject);
begin
  GState.BitmapPostProcessingConfig.InvertColor := (Sender as TTBXItem).Checked;
end;

procedure TfrmMain.mapDblClick(Sender: TObject);
var
  r: TPoint;
  i: Integer;
  VLayer: TCustomLayer;
begin
  if FState.State = ao_movemap then begin
    r:=map.ScreenToClient(Mouse.CursorPos);
    for i := 0 to map.Layers.Count - 1 do begin
      VLayer := map.Layers[i];
      if VLayer.MouseEvents then begin
        if VLayer.HitTest(r.X, r.Y) then begin
          Exit;
        end;
      end;
    end;
    FMapMoving:=false;
    FConfig.ViewPortState.ChangeMapPixelToVisualPoint(r);
  end;
end;

procedure TfrmMain.TBAdd_PointClick(Sender: TObject);
begin
  FEditMarkPoint := nil;
  if FState.State <> ao_edit_point then begin
    FState.State := ao_edit_point;
  end else begin
    FState.State := ao_movemap;
  end;
end;

procedure TfrmMain.TBAdd_LineClick(Sender: TObject);
begin
  FEditMarkLine := nil;
  if FState.State <> ao_edit_line then begin
    FState.State := ao_edit_line;
  end else begin
    FState.State := ao_movemap;
  end;
end;

procedure TfrmMain.TBAdd_PolyClick(Sender: TObject);
begin
  FEditMarkPoly := nil;
  if FState.State <> ao_edit_poly then begin
    FState.State := ao_edit_poly;
  end else begin
    FState.State := ao_movemap;
  end;
end;

procedure TfrmMain.NMarkEditClick(Sender: TObject);
var
  VMark: IMark;
  VMarkPoint: IMarkPoint;
  VMarkLine: IMarkLine;
  VMarkPoly: IMarkPoly;
  VPathOnMapEdit: IPathOnMapEdit;
  VPolygonOnMapEdit: IPolygonOnMapEdit;
begin
  VMark := FLayerMapMarks.MouseOnReg(FMouseState.GetLastDownPos(mbRight));
  if VMark <> nil then begin
    if Supports(VMark, IMarkPoint, VMarkPoint) then begin
      FEditMarkPoint := VMarkPoint;
      FState.State := ao_edit_point;
      FPointOnMapEdit.Point := VMarkPoint.Point;
    end else if Supports(VMark, IMarkLine, VMarkLine) then begin
      FEditMarkLine := VMarkLine;
      FState.State := ao_edit_line;
      if Supports(FLineOnMapEdit, IPathOnMapEdit, VPathOnMapEdit) then begin
        VPathOnMapEdit.SetPath(VMarkLine.Line);
      end;
    end else if Supports(VMark, IMarkPoly, VMarkPoly) then begin
      FEditMarkPoly := VMarkPoly;
      FState.State := ao_edit_poly;
      if Supports(FLineOnMapEdit, IPolygonOnMapEdit, VPolygonOnMapEdit) then begin
        VPolygonOnMapEdit.SetPolygon(VMarkPoly.Line);
      end;
    end;
  end;
end;

procedure TfrmMain.NMarkExportClick(Sender: TObject);
var
  VMark: IMark;
begin
  VMark := FLayerMapMarks.MouseOnReg(FMouseState.GetLastDownPos(mbRight));
  if VMark <> nil then begin
    FfrmMarksExplorer.ExportMark(VMark);
  end;
end;

procedure TfrmMain.NMarkDelClick(Sender: TObject);
var
  VMark: IMark;
begin
  VMark := FLayerMapMarks.MouseOnReg(FMouseState.GetLastDownPos(mbRight));
  if VMark <> nil then begin
    if FMarkDBGUI.DeleteMarkModal(VMark as IMarkID, Handle) then
  end;
end;

procedure TfrmMain.NMarkOperClick(Sender: TObject);
var
  VMark: IMark;
begin
  VMark := FLayerMapMarks.MouseOnReg(FMouseState.GetLastDownPos(mbRight));
  if VMark <> nil then begin
    FMarkDBGUI.OperationMark(VMark, FConfig.ViewPortState.GetVisualCoordConverter.ProjectionInfo);
  end;
end;

procedure TfrmMain.tbitmCopyToClipboardMainMapUrlClick(Sender: TObject);
var
  VZoomCurr: Byte;
  VMapType: TMapType;
  VLocalConverter: ILocalCoordConverter;
  VConverter: ICoordConverter;
  VMouseMapPoint: TDoublePoint;
  VMouseLonLat: TDoublePoint;
  VTile: TPoint;
begin
  if TMenuItem(sender).Tag<>0 then begin
    VMapType := TMapType(TMenuItem(sender).Tag);
  end else begin
    VMapType := FConfig.MainMapsConfig.GetSelectedMapType.MapType;
  end;
  if VMapType.Zmp.TileDownloaderConfig.Enabled then begin
    VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
    VConverter := VLocalConverter.GetGeoConverter;
    VZoomCurr := VLocalConverter.GetZoom;
    VMouseMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(FMouseState.GetLastDownPos(mbRight));
    VConverter.CheckPixelPosFloatStrict(VMouseMapPoint, VZoomCurr, True);
    VMouseLonLat := VConverter.PixelPosFloat2LonLat(VMouseMapPoint, VZoomCurr);
    VMapType.GeoConvert.CheckLonLatPos(VMouseLonLat);
    VTile := VMapType.GeoConvert.LonLat2TilePos(VMouseLonLat, VZoomCurr);
    CopyStringToClipboard(VMapType.TileDownloadSubsystem.GetLink(VTile, VZoomCurr));
  end;
end;

procedure TfrmMain.DigitalGlobe1Click(Sender: TObject);
begin
  // MainPopupMenu.PopupPoint
  SafeCreateDGAvailablePic(FMouseState.GetLastDownPos(mbRight));
end;

procedure TfrmMain.mapMouseLeave(Sender: TObject);
begin
 if (FHintWindow<>nil) then
  begin
   FHintWindow.ReleaseHandle;
   FreeAndNil(FHintWindow);
  end;
end;

procedure TfrmMain.GPSReceiverDisconnect;
begin
  if FConfig.GPSBehaviour.SensorsAutoShow then TBXSensorsBar.Visible:=false;
  tbitmGPSConnect.Enabled := True;
  TBGPSconn.Enabled := True;
  tbitmGPSConnect.Checked:=false;
  TBGPSconn.Checked:=false;
end;

procedure TfrmMain.GPSReceiverReceive;
var
  VGPSNewPos: TDoublePoint;
  VCenterToGPSDelta: TDoublePoint;
  VPointDelta: TDoublePoint;
  VCenterMapPoint: TDoublePoint;
  VGPSMapPoint: TDoublePoint;
  VPosition: IGPSPosition;
  VpPos: PSingleGPSData;
  VConverter: ILocalCoordConverter;
  VMapMove: Boolean;
  VMapMoveCentred: Boolean;
  VMinDelta: Double;
  VProcessGPSIfActive: Boolean;
  VDelta: Double;
begin
  VPosition := GState.GPSRecorder.CurrentPosition;
  VpPos := VPosition.GetPosParams;

  // no position?
  if (not VpPos^.PositionOK) then
    Exit;
    
  if not((FMapMoving)or(FMapZoomAnimtion)) then begin
    FConfig.GPSBehaviour.LockRead;
    try
      VMapMove := FConfig.GPSBehaviour.MapMove;
      VMapMoveCentred := FConfig.GPSBehaviour.MapMoveCentered;
      VMinDelta := FConfig.GPSBehaviour.MinMoveDelta;
      VProcessGPSIfActive := FConfig.GPSBehaviour.ProcessGPSIfActive;
    finally
      FConfig.GPSBehaviour.UnlockRead;
    end;
    if (not VProcessGPSIfActive) or (Screen.ActiveForm=Self) then begin
      if (VMapMove) then begin
        VGPSNewPos.X := VpPos^.PositionLon;
        VGPSNewPos.Y := VpPos^.PositionLat;
        if VMapMoveCentred then begin
          VConverter := FConfig.ViewPortState.GetVisualCoordConverter;
          VCenterMapPoint := VConverter.GetCenterMapPixelFloat;
          VGPSMapPoint := VConverter.GetGeoConverter.LonLat2PixelPosFloat(VGPSNewPos, VConverter.GetZoom);
          VPointDelta.X := VCenterMapPoint.X - VGPSMapPoint.X;
          VPointDelta.Y := VCenterMapPoint.Y - VGPSMapPoint.Y;
          VDelta := Sqrt(Sqr(VPointDelta.X) + Sqr(VPointDelta.Y));
          if VDelta > VMinDelta then begin
            FConfig.ViewPortState.ChangeLonLat(VGPSNewPos);
          end;
        end else begin
          VConverter := FConfig.ViewPortState.GetVisualCoordConverter;
          VGPSMapPoint := VConverter.GetGeoConverter.LonLat2PixelPosFloat(VGPSNewPos, VConverter.GetZoom);
          if PixelPointInRect(VGPSMapPoint, VConverter.GetRectInMapPixelFloat) then  begin
            VCenterMapPoint := VConverter.GetCenterMapPixelFloat;
            VCenterToGPSDelta.X := VGPSMapPoint.X - VCenterMapPoint.X;
            VCenterToGPSDelta.Y := VGPSMapPoint.Y - VCenterMapPoint.Y;
            VPointDelta := FCenterToGPSDelta;
            if PointIsEmpty(VPointDelta) then begin
              FCenterToGPSDelta := VCenterToGPSDelta;
            end else begin
              VPointDelta.X := VCenterToGPSDelta.X - VPointDelta.X;
              VPointDelta.Y := VCenterToGPSDelta.Y - VPointDelta.Y;
              VDelta := Sqrt(Sqr(VPointDelta.X) + Sqr(VPointDelta.Y));
              if VDelta > VMinDelta then begin
                FConfig.ViewPortState.ChangeMapPixelByDelta(VPointDelta);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.GPSReceiverStateChange;
begin
  tbitmGPSConnect.Enabled := False;
  TBGPSconn.Enabled := False;
end;

procedure TfrmMain.GPSReceiverConnect;
begin
  tbitmGPSConnect.Enabled := True;
  TBGPSconn.Enabled := True;
  tbitmGPSConnect.Checked:=True;
  TBGPSconn.Checked:=True;
  if FConfig.GPSBehaviour.SensorsAutoShow then TBXSensorsBar.Visible:=true;
end;

procedure TfrmMain.GPSReceiverConnectError;
begin
  ShowMessage(SAS_ERR_PortOpen);
end;

procedure TfrmMain.GPSReceiverTimeout;
begin
  tbitmGPSConnect.Enabled := True;
  TBGPSconn.Enabled := True;
  ShowMessage(SAS_ERR_Communication);
end;

procedure TfrmMain.NMapParamsClick(Sender: TObject);
var
  VMapType: TMapType;
begin
  if TTBXItem(sender).Tag=0 then begin
    VMapType := FConfig.MainMapsConfig.GetSelectedMapType.MapType;
  end else begin
    VMapType := TMapType(TTBXItem(sender).Tag);
  end;
  FMapTypeEditor.EditMap(VMapType);
end;

procedure TfrmMain.mapMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
var
  VClickLonLat: TDoublePoint;
  VClickRect: TRect;
  VClickLonLatRect: TDoubleRect;
  VLocalConverter: ILocalCoordConverter;
  VConverter: ICoordConverter;
  VZoom: Byte;
  VMouseMapPoint: TDoublePoint;
  VClickMapRect: TDoubleRect;
  VIsClickInMap: Boolean;
  VMark: IMark;
  VMarkPoint: IMarkPoint;
  VMarkLine: IMarkLine;
  VMarkPoly: IMarkPoly;
begin
  if (FHintWindow<>nil) then begin
    FHintWindow.ReleaseHandle;
    FreeAndNil(FHintWindow);
  end;
  if (Layer <> nil) then begin
    exit;
  end;
  FMouseHandler.OnMouseDown(Button, Shift, Point(X, Y));
  if (FMapZoomAnimtion)or
     (ssDouble in Shift)or
     (button=mbMiddle)or
     (ssRight in Shift)and(ssLeft in Shift)or
     (HiWord(GetKeyState(VK_DELETE))<>0)or
     (HiWord(GetKeyState(VK_INSERT))<>0)or
     (HiWord(GetKeyState(VK_F6))<>0) then begin
    exit;
  end;
  Screen.ActiveForm.SetFocusedControl(map);
  VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
  VConverter := VLocalConverter.GetGeoConverter;
  VZoom := VLocalConverter.GetZoom;
  VMouseMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(Point(x, y));
  VIsClickInMap := VConverter.CheckPixelPosFloat(VMouseMapPoint, VZoom, False);
  VClickLonLat := VConverter.PixelPosFloat2LonLat(VMouseMapPoint, VZoom);

  if (Button=mbLeft)and(FState.State<>ao_movemap) then begin
    if (FLineOnMapEdit <> nil)then begin
      movepoint:=true;
      if VIsClickInMap then begin
        VClickRect.Left := X - 5;
        VClickRect.Top := Y - 5;
        VClickRect.Right := X + 5;
        VClickRect.Bottom := Y + 5;
        VClickMapRect := VLocalConverter.LocalRect2MapRectFloat(VClickRect);
        VConverter.CheckPixelRectFloat(VClickMapRect, VZoom);
        VClickLonLatRect := VConverter.PixelRectFloat2LonLatRect(VClickMapRect, VZoom);
        if not FLineOnMapEdit.SelectPointInLonLatRect(VClickLonLatRect) then begin
          VMark := nil;
          if (FConfig.LayersConfig.MarksLayerConfig.MarksShowConfig.IsUseMarks)and
             (FConfig.LayersConfig.MarksLayerConfig.MarksDrawConfig.MagnetDraw) then begin
            VMark := FLayerMapMarks.MouseOnReg(Point(x, y));
          end;
          if VMark <> nil then begin
            if Supports(VMark, IMarkPoint, VMarkPoint) then begin
              VClickLonLat := VMarkPoint.Point;
            end;
            if Supports(VMark, IMarkPoly, VMarkPoly) then begin
              FLayerMapMarks.GetIntersection(VClickLonLat,VClickLonLat, VMarkPoly, VLocalConverter.ProjectionInfo)
            end;
            if Supports(VMark, IMarkLine, VMarkLine) then begin
              FLayerMapMarks.GetIntersection(VClickLonLat,VClickLonLat, VMarkLine, VLocalConverter.ProjectionInfo)
            end;
          end;
          FLineOnMapEdit.InsertPoint(VClickLonLat);
        end;
      end;
    end;
    if (FState.State=ao_select_rect)then begin
      FSelectionRect.LockWrite;
      try
        if not FSelectionRect.IsEmpty then begin
          FSelectionRect.SetNextPoint(VClickLonLat, Shift);
        end;
      finally
        FSelectionRect.UnlockWrite;
      end;
    end;
    if (FState.State = ao_edit_point) then begin
      FPointOnMapEdit.Point := VClickLonLat;
      movepoint:=true;
    end;
    exit;
  end;
  if FMapMoving then exit;

  if (VIsClickInMap)and (Button=mbright)and(FState.State=ao_movemap) then begin
    VMark := nil;
    if FConfig.LayersConfig.MarksLayerConfig.MarksShowConfig.IsUseMarks then begin
      VMark := FLayerMapMarks.MouseOnReg(Point(x, y));
    end;
    NMarkEdit.Visible := VMark <> nil;
    tbitmFitToScreen.Visible := Supports(VMark, IMarkLine) or Supports(VMark, IMarkPoly);
    if VMark <> nil then begin
      tbitmHideThisMark.Visible := not FConfig.LayersConfig.MarksLayerConfig.MarksShowConfig.IgnoreMarksVisible;
    end else begin
      tbitmHideThisMark.Visible := False;
    end;

    tbitmProperties.Visible := VMark <> nil;
    NMarkExport.Visible := VMark <> nil;
    NMarkDel.Visible := VMark <> nil;
    tbsprtMainPopUp0.Visible := VMark <> nil;
    NMarkOper.Visible := VMark <> nil;
    NMarkNav.Visible := VMark <> nil;
    if (VMark <> nil) then begin
      if Supports(VMark, IMarkPoint, VMarkPoint) then begin
        NMarksCalcs.Visible := false;
      end else if Supports(VMark, IMarkLine, VMarkLine) then begin
        NMarksCalcsSq.Visible := False;
        NMarksCalcsPer.Visible := False;
        NMarksCalcsLen.Visible:= True;
        NMarksCalcs.Visible := True;
      end else if Supports(VMark, IMarkPoly, VMarkPoly) then begin
        NMarksCalcsSq.Visible := True;
        NMarksCalcsPer.Visible := True;
        NMarksCalcsLen.Visible:= False;
        NMarksCalcs.Visible := True;
      end;
      NMarksCalcs.Visible := true;
    end else begin
      NMarksCalcs.Visible := false;
    end;
    if (VMark <> nil) and (FConfig.NavToPoint.IsActive) and VMark.IsSameId(FConfig.NavToPoint.MarkId) then begin
      NMarkNav.Checked:=true
    end else begin
      NMarkNav.Checked:=false;
    end;
    map.PopupMenu:=MainPopupMenu;
  end else begin
    FMapMoving:=true;
    FMapMovingButton := Button;
    map.PopupMenu:=nil;
  end;
end;

procedure TfrmMain.mapMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
var
  VPWL:TResObj;
  VZoomCurr: Byte;
  VSelectionRect: TDoubleRect;
  VSelectionFinished: Boolean;
  VPoly: ILonLatPolygon;
  VMapMoving: Boolean;
  VMapType: TMapType;
  VValidPoint: Boolean;
  VConverter: ICoordConverter;
  VTile: TPoint;
  VLonLat: TDoublePoint;
  VLocalConverter: ILocalCoordConverter;
  VMouseMapPoint: TDoublePoint;
  VMouseDownPos: TPoint;
  VMouseMoveDelta: TPoint;
  VMouseMoveSpeed: TDoublePoint;
  VMark: IMark;
  VMarkS: Double;
  VWikiItem: IVectorDataItemSimple;
  VPrevTick, VCurrTick, VFr: int64;
  VWikiLayerGUID: TGUID;

  procedure _ShowInternalBrowser;
  var
    Vdescr: String;
    VMapType: IMapType;
    VDescrParserProc: TMapAttachmentsInfoParserProc;
  begin
    VDescrParserProc := nil;
    VMapType := GState.MapType.FullMapsSet.GetMapTypeByGUID(VWikiLayerGUID);
    if Assigned(VMapType) then
    if Assigned(VMapType.MapType) then
    if Assigned(VMapType.MapType.Zmp.MapAttachmentsInfo) then
      VDescrParserProc := VMapType.MapType.MapAttachmentsInfoParser ; // only for maps with attachments
    // show
    Vdescr:=VPWL.descr;
    GState.InternalBrowser.ShowHTMLDescrWithParser(VPWL.name, Vdescr, VDescrParserProc);
  end;
begin
  FMouseHandler.OnMouseUp(Button, Shift, Point(X, Y));

  if (FMapZoomAnimtion) then exit;

  if button=mbMiddle then begin
    TBFullSizeClick(nil);
    exit;
  end;

  if FMapMoving and (FMapMovingButton = Button) then begin
    FMapMoving:=false;
    VMapMoving := True;
  end else begin
    VMapMoving := False;
  end;
  if not VMapMoving then begin
    if (Layer <> nil) then begin
      exit;
    end;
  end;

  if not VMapMoving and (Button = mbLeft) then begin
    VMapType := FConfig.MainMapsConfig.GetSelectedMapType.MapType;
    VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
    VConverter := VLocalConverter.GetGeoConverter;
    VZoomCurr := VLocalConverter.GetZoom;
    VMouseMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(Point(x, y));
    VValidPoint := VConverter.CheckPixelPosFloat(VMouseMapPoint, VZoomCurr, False);
    VLonLat := VConverter.PixelPosFloat2LonLat(VMouseMapPoint, VZoomCurr);

    if VValidPoint then begin
      if VMapType.GeoConvert.CheckLonLatPos(VLonLat) then begin
        VTile := VMapType.GeoConvert.LonLat2TilePos(VLonLat, VZoomCurr);
        if HiWord(GetKeyState(VK_DELETE))<>0 then begin
          VMapType.DeleteTile(VTile, VZoomCurr);
          Exit;
        end;
        if HiWord(GetKeyState(VK_INSERT))<>0 then begin
          TTileDownloaderUIOneTile.Create(
            GState.DownloaderThreadConfig,
            GState.AppClosingNotifier,
            VTile,
            VZoomCurr,
            VMapType,
            GState.DownloadInfo,
            GState.GlobalInternetState,
            FTileErrorLogger
          );
          Exit;
        end;
      end;
      if HiWord(GetKeyState(VK_F6))<>0 then begin
        SafeCreateDGAvailablePic(Point(X, Y));
        Exit;
      end;
    end;
    if (FState.State = ao_edit_point) then begin
      FPointOnMapEdit.Point := VLonLat;
      if(FMarkDBGUI.SavePointModal(FEditMarkPoint, FPointOnMapEdit.Point)) then begin
        FState.State := ao_movemap;
      end;
      movepoint:=false;
      Exit;
    end;
    if FState.State=ao_select_rect then begin
      VSelectionFinished := False;
      FSelectionRect.LockWrite;
      try
        if not FSelectionRect.IsEmpty then begin
          VSelectionFinished := True;
        end;
        FSelectionRect.SetNextPoint(VLonLat, Shift);
        VSelectionRect := FSelectionRect.GetRect;
        if VSelectionFinished then begin
          FSelectionRect.Reset;
        end;
      finally
        FSelectionRect.UnlockWrite;
      end;
      if VSelectionFinished then begin
        VPoly := GState.VectorItmesFactory.CreateLonLatPolygonByRect(VSelectionRect);
        FState.State := ao_movemap;
        FFormRegionProcess.Show_(VZoomCurr, VPoly);
        VPoly := nil;
      end;
      Exit;
    end;
  end;

  movepoint:=false;
  
  if (((FState.State<>ao_movemap)and(Button=mbLeft))or
     ((FState.State=ao_movemap)and(Button=mbRight))) then exit;

  map.Enabled:=false;
  map.Enabled:=true;

  VMouseDownPos := FMouseState.GetLastDownPos(Button);
  VMouseMoveDelta := Point(VMouseDownPos.x-X, VMouseDownPos.y-y);

  if (VMapMoving)and((VMouseMoveDelta.X<>0)or(VMouseMoveDelta.Y<>0)) then begin
    VMouseMoveSpeed := FMouseState.CurentSpeed;
    QueryPerformanceCounter(VPrevTick);
    FConfig.ViewPortState.ChangeMapPixelByDelta(DoublePoint(VMouseMoveDelta));
    QueryPerformanceCounter(VCurrTick);
    QueryPerformanceFrequency(VFr);
    MapMoveAnimate(VMouseMoveSpeed,(VCurrTick-VPrevTick)/VFr,
                   FConfig.ViewPortState.GetCurrentZoom, FMouseState.GetLastUpPos(button));
  end;

  if (VMouseMoveDelta.X = 0)and(VMouseMoveDelta.Y = 0) then begin
    if (FState.State=ao_movemap)and(button=mbLeft) then begin
      VPWL.find := False;
      VPWL.name := '';
      VPWL.descr := '';
      VPWL.S := 0;

      VWikiLayerGUID:=GUID_NULL;

      VWikiItem := nil;
      VWikiItem := FWikiLayer.MouseOnRegWithGUID(Point(x,y), VMarkS, VWikiLayerGUID);
      if VWikiItem <> nil then begin
        VPWL.find := True;
        VPWL.name := VWikiItem.Name;
        VPWL.descr := VWikiItem.Desc;
        VPWL.S := VMarkS;
      end;

      VWikiItem := FLayerSearchResults.MouseOnReg(Point(x,y), VMarkS);
      if VWikiItem <> nil then begin
        VPWL.find := True;
        VPWL.name := VWikiItem.Name;
        VPWL.descr := VWikiItem.Desc;
        VPWL.S := VMarkS;
      end;

      VMark := nil;
      if (FConfig.LayersConfig.MarksLayerConfig.MarksShowConfig.IsUseMarks) then begin
        VMark := FLayerMapMarks.MouseOnReg(Point(x,y), VMarkS);
      end;

      if VMark <> nil then begin
        if (not VPWL.find) or (not Supports(VMark, IMarkPoly)) or (VPWL.S >= VMarkS) then begin
          VPWL.find := True;
          VPWL.name := VMark.Name;
          VPWL.descr := VMark.Desc;
          VPWL.S := VMarkS;
        end;
      end;

      if VPWL.find  then begin
        if VPWL.descr <> '' then begin
          _ShowInternalBrowser;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.mapMouseMove(Sender: TObject; Shift: TShiftState; AX, AY: Integer; Layer: TCustomLayer);
var
  hintrect:TRect;
  //CState: Integer;
  VZoomCurr: Byte;
  VConverter: ICoordConverter;
  VLonLat: TDoublePoint;
  VItemFound: Boolean;
  VItemS: Double;
  VItemHint: string;
  VLocalConverter: ILocalCoordConverter;
  VMouseMapPoint: TDoublePoint;
  VMouseMoveDelta: TPoint;
  VMouseDownPos: TPoint;
  VLastMouseMove: TPoint;
  VMousePos: TPoint;
  VMark: IMark;
  VMarkS: Double;
  VWikiItem: IVectorDataItemSimple;
  VMarkPoint: IMarkPoint;
  VMarkPoly: IMarkPoly;
  VMarkLine: IMarkLine;

  function _AllowShowHint: Boolean;
  var
    hf: HWND;
    dwProcessId: DWORD;
  begin
    // do not capture focus on mouse hovering
    hf:=GetForegroundWindow;
    if (Self.HandleAllocated and (Self.Handle=hf)) then begin
      // foreground
      Result:=TRUE
    end else begin
      // we have foreground window
      GetWindowThreadProcessId(hf,dwProcessId);
      Result:=(dwProcessId=GetCurrentProcessId);
    end;
  end;
  
begin
  if ProgramClose then begin
    exit;
  end;
  VLastMouseMove := FMouseState.CurentPos;
  FMouseHandler.OnMouseMove(Shift, Point(AX, AY));
  VMousePos := FMouseState.CurentPos;
  if not FMapMoving then begin
    if (Layer <> nil) then begin
      exit;
    end;
  end;
  if (FMapZoomAnimtion)or(ssDouble in Shift) then begin
    exit;
  end;
  VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
  VConverter := VLocalConverter.GetGeoConverter;
  VZoomCurr := VLocalConverter.GetZoom;
  VMouseMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(VMousePos);
  VConverter.CheckPixelPosFloatStrict(VMouseMapPoint, VZoomCurr, False);
  VLonLat := VConverter.PixelPosFloat2LonLat(VMouseMapPoint, VZoomCurr);
  if (FLineOnMapEdit <> nil) and (movepoint) then begin
    VMark := nil;
    if (FConfig.LayersConfig.MarksLayerConfig.MarksShowConfig.IsUseMarks)and
       (FConfig.LayersConfig.MarksLayerConfig.MarksDrawConfig.MagnetDraw)  then
      VMark := FLayerMapMarks.MouseOnReg(VMousePos);
    if VMark <> nil then begin
      if Supports(VMark, IMarkPoint, VMarkPoint) then begin
        VLonLat := VMarkPoint.Point;
      end;
      if Supports(VMark, IMarkPoly, VMarkPoly) then begin
        FLayerMapMarks.GetIntersection(VLonLat,VLonLat, VMarkPoly, VLocalConverter.ProjectionInfo)
      end;
      if Supports(VMark, IMarkLine, VMarkLine) then begin
        FLayerMapMarks.GetIntersection(VLonLat,VLonLat, VMarkLine, VLocalConverter.ProjectionInfo)
      end;
    end;
    FLineOnMapEdit.MoveActivePoint(VLonLat);
    exit;
  end;
  if (FState.State = ao_edit_point) and movepoint then begin
    FPointOnMapEdit.Point := VLonLat;
  end;
  if (FState.State=ao_select_rect) then begin
    FSelectionRect.LockWrite;
    try
      if not FSelectionRect.IsEmpty then begin
        FSelectionRect.SetNextPoint(VLonLat, Shift);
      end;
    finally
      FSelectionRect.UnlockWrite;
    end;
  end;

  if FWinPosition.GetIsFullScreen then begin
                       if VMousePos.y<10 then begin
                                     TBDock.Parent:=map;
                                     TBDock.Visible:=true;
                                    end
                               else begin
                                     TBDock.Visible:=false;
                                     TBDock.Parent:=Self;
                                    end;
                       if VMousePos.x<10 then begin
                                     TBDockLeft.Parent:=map;
                                     TBDockLeft.Visible:=true;
                                    end
                               else begin
                                     TBDockLeft.Visible:=false;
                                     TBDockLeft.Parent:=Self;
                                    end;
                       if VMousePos.y>Map.Height-10 then begin
                                     TBDockBottom.Parent:=map;
                                     TBDockBottom.Visible:=true;
                                    end
                               else begin
                                     TBDockBottom.Visible:=false;
                                     TBDockBottom.Parent:=Self;
                                    end;
                       if VMousePos.x>Map.Width-10 then begin
                                     TBDockRight.Parent:=map;
                                     TBDockRight.Visible:=true;
                                    end
                               else begin
                                     TBDockRight.Visible:=false;
                                     TBDockRight.Parent:=Self;
                                    end;
  end;

  if FMapZoomAnimtion then exit;

  if FMapMoving then begin
    VMouseDownPos := FMouseState.GetLastDownPos(FMapMovingButton);
    VMouseMoveDelta := Point(VMouseDownPos.X-VMousePos.X, VMouseDownPos.Y-VMousePos.Y);
    FConfig.ViewPortState.MoveTo(VMouseMoveDelta);
  end;

  if (not FShowActivHint) then begin
    if (FHintWindow<>nil) then begin
     FHintWindow.ReleaseHandle;
     FreeAndNil(FHintWindow);
    end;
  end;
  FShowActivHint:=false;
  if (not FMapMoveAnimtion) and
     (not FMapMoving) and
     ((VMousePos.x<>VLastMouseMove.X)or(VMousePos.y<>VLastMouseMove.y)) and
     (FConfig.MainConfig.ShowHintOnMarks)and
     _AllowShowHint then begin
    // show hint
    VItemFound := False;
    VItemS := 0;
    VWikiItem := nil;
    VWikiItem := FWikiLayer.MouseOnReg(VMousePos, VMarkS);
    if VWikiItem <> nil then begin
      VItemFound := True;
      VItemS := VMarkS;
      VItemHint := VWikiItem.GetHintText;
    end;

    VWikiItem := FLayerSearchResults.MouseOnReg(VMousePos, VMarkS);
    if VWikiItem <> nil then begin
      VItemFound := True;
      VItemS := VMarkS;
      VItemHint := VWikiItem.GetHintTextWithoutDesc;
    end;

    VMark := nil;
    if (FConfig.LayersConfig.MarksLayerConfig.MarksShowConfig.IsUseMarks) then
      VMark := FLayerMapMarks.MouseOnReg(VMousePos, VMarkS);
    if VMark <> nil then begin
      if (not VItemFound) or (not Supports(VMark, IMarkPoly)) or (VItemS >= VMarkS) then begin
        VItemFound := True;
        VItemHint := VMark.GetHintText;
      end;
    end;

    if (VItemFound) then begin
     if map.Cursor = crDefault then begin
       map.Cursor := crHandPoint;
     end;
     if FHintWindow<>nil then FHintWindow.ReleaseHandle;
     if VItemHint<>'' then begin
      if FHintWindow=nil then begin
        FHintWindow:=THintWindow.Create(Self);
        FHintWindow.Brush.Color:=clInfoBk;
      end;
      hintrect:=FHintWindow.CalcHintRect(Screen.Width, VItemHint, nil);
      FHintWindow.ActivateHint(Bounds(Mouse.CursorPos.x+13,Mouse.CursorPos.y-13,abs(hintrect.Right-hintrect.Left),abs(hintrect.Top-hintrect.Bottom)),VItemHint);
      FHintWindow.Repaint;
     end;
     FShowActivHint:=true;
    end else begin
      if map.Cursor = crHandPoint then begin
        map.Cursor := crDefault;
      end;
    end;
  end;
end;

procedure CreateLink(const PathObj,PathLink, Desc, Param: string);
var
  IObject: IUnknown;
  SLink: IShellLink;
  PFile: IPersistFile;
begin
  IObject := CreateComObject(CLSID_ShellLink);
  SLink := IObject as IShellLink;
  PFile := IObject as IPersistFile;
  with SLink do
  begin
    SetArguments(PChar(Param));
    SetDescription(PChar(Desc));
    SetPath(PChar(PathObj));
  end;
  PFile.Save(PWChar(WideString(PathLink)), FALSE);
end;

procedure TfrmMain.tbitmCreateShortcutClick(Sender: TObject);
var
  VLonLat:TDoublePoint;
  param:string;
  VZoomCurr: Byte;
  VMapType: TMapType;
  VLocalConverter: ILocalCoordConverter;
begin
  if SaveLink.Execute then begin
    VMapType := FConfig.MainMapsConfig.GetSelectedMapType.MapType;
    VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
    VZoomCurr := VLocalConverter.GetZoom;
    VLonLat := VLocalConverter.GetCenterLonLat;
    param:=' '+GUIDToString(VMapType.Zmp.GUID)+' '+IntToStr(VZoomCurr + 1)+' '+FloatToStr(VLonLat.x)+' '+FloatToStr(VLonLat.y);
    CreateLink(ParamStr(0), SaveLink.filename, '', param)
  end;
end;

procedure TfrmMain.TBItemDelTrackClick(Sender: TObject);
begin
  GState.GPSRecorder.LockWrite;
  try
    GState.GPSRecorder.ClearTrack;
    GState.GPSRecorder.ResetMaxSpeed;
  finally
    GState.GPSRecorder.UnlockWrite;
  end;
end;

procedure TfrmMain.NGShScale01Click(Sender: TObject);
var
  VTag: Integer;
begin
  VTag := TTBXItem(sender).Tag;
  TTBXItem(sender).checked := True;
  FConfig.LayersConfig.MapLayerGridsConfig.GenShtabGrid.LockWrite;
  try
    if VTag = 0 then begin
      FConfig.LayersConfig.MapLayerGridsConfig.GenShtabGrid.Visible := False;
      FConfig.LayersConfig.MapLayerGridsConfig.GenShtabGrid.Scale := VTag; // ������� ���������� Scale=0 - ������� ���� ��� ����� ���������  
    end else begin
      FConfig.LayersConfig.MapLayerGridsConfig.GenShtabGrid.Visible := True;
      FConfig.LayersConfig.MapLayerGridsConfig.GenShtabGrid.Scale := VTag;
    end;
  finally
    FConfig.LayersConfig.MapLayerGridsConfig.GenShtabGrid.UnlockWrite;
  end;
end;

procedure TfrmMain.TBEditPathDelClick(Sender: TObject);
begin
  if FLineOnMapEdit <> nil then begin
    FLineOnMapEdit.DeleteActivePoint;
  end;
end;

procedure TfrmMain.TBEditPathLabelClick(Sender: TObject);
begin
  if FState.State = ao_calc_line then begin
    FConfig.LayersConfig.CalcLineLayerConfig.LockWrite;
    try
      FConfig.LayersConfig.CalcLineLayerConfig.CaptionConfig.LenShow :=
        not FConfig.LayersConfig.CalcLineLayerConfig.CaptionConfig.LenShow;
    finally
      FConfig.LayersConfig.CalcLineLayerConfig.UnlockWrite;
    end;
  end;
end;

procedure TfrmMain.TBEditPathSaveClick(Sender: TObject);
var
  VResult: boolean;
  VPathEdit: IPathOnMapEdit;
  VPolygonEdit: IPolygonOnMapEdit;
begin
  VResult := false;
  case FState.State of
    ao_edit_poly: begin
      if Supports(FLineOnMapEdit, IPolygonOnMapEdit, VPolygonEdit) then begin
        VResult := FMarkDBGUI.SavePolyModal(FEditMarkPoly, VPolygonEdit.Polygon);
      end;
    end;
    ao_edit_line: begin
      if Supports(FLineOnMapEdit, IPathOnMapEdit, VPathEdit) then begin
        VResult := FMarkDBGUI.SaveLineModal(FEditMarkLine, VPathEdit.Path, FMarshrutComment);
      end;
    end;
  end;
  if VResult then begin
    FState.State := ao_movemap;
  end;
end;

procedure TfrmMain.tbitmSaveMarkAsNewClick(Sender: TObject);
var
  VResult: boolean;
  VPathEdit: IPathOnMapEdit;
  VPolygonEdit: IPolygonOnMapEdit;
begin
  VResult := false;
  case FState.State of
    ao_edit_poly: begin
      if Supports(FLineOnMapEdit, IPolygonOnMapEdit, VPolygonEdit) then begin
        VResult := FMarkDBGUI.SavePolyModal(FEditMarkPoly, VPolygonEdit.Polygon, True);
      end;
    end;
    ao_edit_line: begin
      if Supports(FLineOnMapEdit, IPathOnMapEdit, VPathEdit) then begin
        VResult := FMarkDBGUI.SaveLineModal(FEditMarkLine, VPathEdit.Path, FMarshrutComment, True);
      end;
    end;
  end;
  if VResult then begin
    FState.State := ao_movemap;
  end;
end;

procedure TfrmMain.TBEditMagnetDrawClick(Sender: TObject);
begin
  FConfig.LayersConfig.MarksLayerConfig.MarksDrawConfig.MagnetDraw := TBEditMagnetDraw.Checked;
end;

procedure TfrmMain.TBEditPathClose(Sender: TObject);
begin
  FState.State := ao_movemap;
end;

procedure TfrmMain.tbitmPlacemarkManagerClick(Sender: TObject);
begin
  FfrmMarksExplorer.EditMarks;
end;

procedure TfrmMain.NMarkNavClick(Sender: TObject);
var
  LL:TDoublePoint;
  VMark: IMark;
begin
  VMark := FLayerMapMarks.MouseOnReg(FMouseState.GetLastDownPos(mbRight));
  if VMark <> nil then begin
    if (not NMarkNav.Checked) then begin
      LL := VMark.GetGoToLonLat;
      FConfig.NavToPoint.StartNavToMark(VMark as IMarkID, ll);
    end else begin
      FConfig.NavToPoint.StopNav;
    end;
  end;
end;

procedure TfrmMain.AdjustFont(Item: TTBCustomItem;
  Viewer: TTBItemViewer; Font: TFont; StateFlags: Integer);
begin
 if TTBXItem(Item).Checked then TTBXItem(Item).FontSettings.Bold:=tsTrue
                           else TTBXItem(Item).FontSettings.Bold:=tsDefault;
end;

procedure TfrmMain.TBfillMapAsMainClick(Sender: TObject);
var
  VSender: TComponent;
  VAtiveMap: IActiveMapSingle;
  VMapType: IMapType;
  VGUID: TGUID;
begin
  if Sender is TComponent then begin
    VSender := TComponent(Sender);
    VAtiveMap := IActiveMapSingle(VSender.Tag);
    if VAtiveMap <> nil then begin
      VMapType := VAtiveMap.GetMapType;
      VGUID := CGUID_Zero;
      if VMapType <> nil then begin
        VGUID := VMapType.GUID;
      end;
      FConfig.LayersConfig.FillingMapLayerConfig.GetSourceMap.SelectMainByGUID(VGUID);
    end;
  end;
end;

procedure TfrmMain.NMarksCalcsLenClick(Sender: TObject);
var
  VMark: IMark;
  VMarkLine: IMarkLine;
begin
  VMark := FLayerMapMarks.MouseOnReg(FMouseState.GetLastDownPos(mbRight));
  if Supports(VMark, IMarkLine, VMarkLine) then begin
    FMarkDBGUI.ShowMarkLength(VMarkLine, FConfig.ViewPortState.GetCurrentCoordConverter, Self.Handle);
  end;
end;

procedure TfrmMain.NMarksCalcsSqClick(Sender: TObject);
var
  VMark: IMark;
  VMarkPoly: IMarkPoly;
begin
  VMark := FLayerMapMarks.MouseOnReg(FMouseState.GetLastDownPos(mbRight));
  if Supports(VMark, IMarkPoly, VMarkPoly) then begin
    FMarkDBGUI.ShowMarkSq(VMarkPoly, FConfig.ViewPortState.GetCurrentCoordConverter, Self.Handle);
  end;
end;

procedure TfrmMain.nokiamapcreator1Click(Sender: TObject);
var
  VLocalConverter: ILocalCoordConverter;
  VConverter: ICoordConverter;
  VZoom: Byte;
  VMouseMapPoint: TDoublePoint;
  VLonLat:TDoublePoint;
begin
  VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
  VConverter := VLocalConverter.GetGeoConverter;
  VZoom := VLocalConverter.GetZoom;
  VMouseMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(FMouseState.GetLastDownPos(mbRight));
  VConverter.CheckPixelPosFloatStrict(VMouseMapPoint, VZoom, False);
  VLonLat := VConverter.PixelPosFloat2LonLat(VMouseMapPoint, VZoom);
  CopyStringToClipboard(
    'http://maps.nokia.com/mapcreator/?ns=true#|' +
    R2StrPoint(VLonLat.y) + '|' +
    R2StrPoint(VLonLat.x) + '|' +
    IntToStr(VZoom) +
    '|0|0|'
  );
end;

procedure TfrmMain.NMarksCalcsPerClick(Sender: TObject);
var
  VMark: IMark;
  VMarkPoly: IMarkPoly;
begin
  VMark := FLayerMapMarks.MouseOnReg(FMouseState.GetLastDownPos(mbRight));
  if Supports(VMark, IMarkPoly, VMarkPoly) then begin
    FMarkDBGUI.ShowMarkLength(VMarkPoly, FConfig.ViewPortState.GetCurrentCoordConverter, Self.Handle);
  end;
end;

procedure TfrmMain.TBEditPathOkClick(Sender: TObject);
var
  VPoly: ILonLatPolygon;
  VPath: ILonLatPath;
  VLineOnMapEdit: ILineOnMapEdit;
  VPathLine: ILonLatPathLine;
begin
  VLineOnMapEdit := FLineOnMapEdit;
  if VLineOnMapEdit <> nil then begin
    case FState.State of
      ao_select_poly: begin
        VPoly := (VLineOnMapEdit as IPolygonOnMapEdit).Polygon;
        FState.State := ao_movemap;
        FFormRegionProcess.Show_(FConfig.ViewPortState.GetCurrentZoom, VPoly);
      end;
      ao_select_line: begin
        VPath := (VLineOnMapEdit as IPathOnMapEdit).Path;
        if VPath.Count > 0 then begin
          VPathLine := VPath.Item[0];
          if VPathLine.Count > 1 then begin
            VPoly :=
              GState.VectorItmesFactory.CreateLonLatPolygonByLonLatPathAndFilter(
                VPath,
                TLonLatPointFilterLine2Poly.Create(
                  FConfig.LayersConfig.SelectionPolylineLayerConfig.ShadowConfig.Radius,
                  FConfig.ViewPortState.GetVisualCoordConverter.ProjectionInfo
                )
              );
            FState.State := ao_movemap;
            FFormRegionProcess.Show_(FConfig.ViewPortState.GetCurrentZoom, VPoly);
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.NMapInfoClick(Sender: TObject);
var
  VMapType: TMapType;
  VUrl: string;
begin
  if TMenuItem(sender).Tag<>0 then begin
    VMapType := TMapType(TMenuItem(sender).Tag);
  end else begin
    VMapType := FConfig.MainMapsConfig.GetSelectedMapType.MapType;
  end;
  VUrl := VMapType.GUIConfig.InfoUrl.Value;
  if VUrl <> '' then begin
    VUrl := CZmpInfoInternalURL + GUIDToString(VMapType.Zmp.GUID) + VUrl;
    GState.InternalBrowser.Navigate(VMapType.Zmp.FileName, VUrl);
  end;
end;

procedure TfrmMain.NanimateClick(Sender: TObject);
begin
  FConfig.MapZoomingConfig.AnimateZoom := (Sender as TTBXItem).Checked;
end;

procedure TfrmMain.NAnimateMoveClick(Sender: TObject);
begin
  FConfig.MapMovingConfig.AnimateMove := (Sender as TTBXItem).Checked;
end;

procedure TfrmMain.SafeCreateDGAvailablePic(const AVisualPoint: TPoint);
begin
  // create
  if (nil=FfrmDGAvailablePic) then
    FfrmDGAvailablePic:=TfrmDGAvailablePic.Create(
      GState.LanguageManager,
      GState.InetConfig);
  // link to position    
  FfrmDGAvailablePic.ShowInfo(AVisualPoint, FConfig.ViewPortState.GetVisualCoordConverter);
end;

procedure TfrmMain.SaveConfig(Sender: TObject);
begin
  try
    GState.SaveMainParams;
    SaveWindowConfigToIni(GState.MainConfigProvider);
  except
  end;
end;

procedure TfrmMain.SaveWindowConfigToIni(const AProvider: IConfigDataWriteProvider);
var
  lock_tb_b:boolean;
  VProvider: IConfigDataWriteProvider;
begin
  VProvider := AProvider.GetOrCreateSubItem('HOTKEY');
  FShortCutManager.Save(VProvider);

  VProvider := AProvider.GetOrCreateSubItem('MainForm');
  FWinPosition.WriteConfig(VProvider);

  VProvider := AProvider.GetOrCreateSubItem('PANEL');
  lock_tb_b:=FConfig.ToolbarsLock.GetIsLock;
  SetToolbarsLock(False);
  TBConfigProviderSavePositions(Self, VProvider);
  SetToolbarsLock(lock_tb_b);
end;

procedure TfrmMain.TBXSensorsBarVisibleChanged(Sender: TObject);
begin
  NSensors.Checked := TTBXToolWindow(sender).Visible;
end;

procedure TfrmMain.NSensorsClick(Sender: TObject);
begin
  TBXSensorsBar.Visible := TTBXItem(sender).Checked;
end;

procedure TfrmMain.tbitmSaveCurrentPositionClick(Sender: TObject);
var
  VPosition: IGPSPosition;
  VpPos: PSingleGPSData;
  VLonLat: TDoublePoint;
begin
  VPosition := GState.GPSRecorder.CurrentPosition;
  VpPos := VPosition.GetPosParams;

  if (VpPos^.PositionOK) then begin
    VLonLat.X := VpPos^.PositionLon;
    VLonLat.Y := VpPos^.PositionLat;
  end else begin
    VLonLat := FConfig.ViewPortState.GetVisualCoordConverter.GetCenterLonLat;
  end;

  if FMarkDBGUI.AddNewPointModal(VLonLat) then begin
    FState.State := ao_movemap;
  end;
end;

procedure TfrmMain.tbitmPositionByGSMClick(Sender: TObject);
var
  PosFromGSM: TPosFromGSM;
begin
 PosFromGSM:=TPosFromGSM.Create(GState.GSMpar, FMapGoto);
 try
   PosFromGSM.GetPos(FConfig.ViewPortState.GetCurrentZoom);
 except
   PosFromGSM.Free;
 end;
end;

procedure TfrmMain.tbitmPropertiesClick(Sender: TObject);
var
  VMark: IMark;
  VMarkModifed: IMark;
begin
  VMark := FLayerMapMarks.MouseOnReg(FMouseState.GetLastDownPos(mbRight));
  if VMark <> nil then begin
    VMarkModifed := FMarkDBGUI.EditMarkModal(VMark, False);
    if VMarkModifed <> nil then begin
      GState.MarksDB.MarksDb.UpdateMark(VMark, VMarkModifed);
    end;
  end;
end;

procedure TfrmMain.tbitmShowDebugInfoClick(Sender: TObject);
begin
  GState.DebugInfoWindow.Show;
end;

procedure TfrmMain.tbitmShowMarkCaptionClick(Sender: TObject);
begin
  FConfig.LayersConfig.MarksLayerConfig.MarksDrawConfig.ShowPointCaption := (Sender as TTBXItem).Checked;
end;

procedure TfrmMain.osmorg1Click(Sender: TObject);
var
  VLocalConverter: ILocalCoordConverter;
  VConverter: ICoordConverter;
  VZoom: Byte;
  VMouseMapPoint: TDoublePoint;
  VLonLat:TDoublePoint;
begin
  VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
  VConverter := VLocalConverter.GetGeoConverter;
  VZoom := VLocalConverter.GetZoom;
  VMouseMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(FMouseState.GetLastDownPos(mbRight));
  VConverter.CheckPixelPosFloatStrict(VMouseMapPoint, VZoom, False);
  VLonLat := VConverter.PixelPosFloat2LonLat(VMouseMapPoint, VZoom);
  CopyStringToClipboard(
    'http://www.openstreetmap.org/?lat=' +
    R2StrPoint(VLonLat.y) +
    '&lon=' + R2StrPoint(VLonLat.x) +
    '&mlat=' + R2StrPoint(VLonLat.y) +
    '&mlon=' + R2StrPoint(VLonLat.x) +
    '&zoom=' + inttostr(VZoom)
  );
end;


procedure TfrmMain.tbitmOpenFileClick(Sender: TObject);
var
  VFileName: string;
  VImportConfig: IImportConfig;
begin
  if (OpenSessionDialog.Execute) then begin
    FState.State := ao_movemap;
    VFileName := OpenSessionDialog.FileName;
    if FileExists(VFileName) then begin
      if ExtractFileExt(VFileName)='.sls' then begin
        FFormRegionProcess.StartSlsFromFile(VFileName);
      end else if ExtractFileExt(VFileName)='.hlg' then begin
        FFormRegionProcess.LoadSelFromFile(VFileName);
      end else begin
        VImportConfig := FMarkDBGUI.EditModalImportConfig;
        if VImportConfig <> nil then begin
          GState.ImportFileByExt.ProcessImport(VFileName, VImportConfig);
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.tbitmGPSOptionsClick(Sender: TObject);
begin
  FfrmSettings.ShowGPSSettings;
end;

procedure TfrmMain.TBScreenSelectClick(Sender: TObject);
var
  VLocalConverter: ILocalCoordConverter;
  VConverter: ICoordConverter;
  VZoom: Byte;
  VMapRect: TDoubleRect;
  VLonLatRect: TDoubleRect;
  VPolygon: ILonLatPolygon;
begin
  TBRectSave.ImageIndex:=20;
  VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
  VConverter := VLocalConverter.GetGeoConverter;
  VZoom := VLocalConverter.GetZoom;
  VMapRect := VLocalConverter.GetRectInMapPixelFloat;
  VConverter.CheckPixelRectFloat(VMapRect, VZoom);
  VLonLatRect := VConverter.PixelRectFloat2LonLatRect(VMapRect, VZoom);

  VPolygon := GState.VectorItmesFactory.CreateLonLatPolygonByRect(VLonLatRect);
  FState.State := ao_movemap;
  FFormRegionProcess.Show_(VZoom, VPolygon);
end;

procedure TfrmMain.TBSearchWindowClose(Sender: TObject);
begin
  FConfig.LastSearchResultConfig.ClearGeoCodeResult;
end;

procedure TfrmMain.TBGPSToPointCenterClick(Sender: TObject);
begin
  FConfig.GPSBehaviour.MapMoveCentered := TTBXitem(sender).Checked;
end;

procedure TfrmMain.NShowSelectionClick(Sender: TObject);
begin
  FConfig.LayersConfig.LastSelectionLayerConfig.Visible := (Sender as TTBXItem).Checked;
end;

procedure TfrmMain.NGoToCurClick(Sender: TObject);
begin
  FConfig.MapZoomingConfig.ZoomingAtMousePos := (Sender as TTBXItem).Checked
end;

procedure TfrmMain.TBXSelectSrchClick(Sender: TObject);
var
  VToolbarItem: TTBXItem;
  VItem: IGeoCoderListEntity;
begin
  if Sender is TTBXItem then begin
    VToolbarItem := TTBXItem(Sender);
    VItem := IGeoCoderListEntity(VToolbarItem.tag);
    if VItem <> nil then begin
      FConfig.MainGeoCoderConfig.ActiveGeoCoderGUID := VItem.GetGUID;
    end;
  end;
end;

procedure TfrmMain.TBXSearchEditAcceptText(Sender: TObject;
  var NewText: String; var Accept: Boolean);
var
  VItem: IGeoCoderListEntity;
  VResult: IGeoCodeResult;
  VLocalConverter: ILocalCoordConverter;
  VText: string;
  VNotifier: IOperationNotifier;
begin
  VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
  VItem := FConfig.MainGeoCoderConfig.GetActiveGeoCoder;
  VText := Trim(NewText);
  VNotifier := TOperationNotifier.Create;
  VResult := VItem.GetGeoCoder.GetLocations(VNotifier, VNotifier.CurrentOperation, VText, VLocalConverter);
  FConfig.MainGeoCoderConfig.SearchHistory.AddItem(VText);
  FSearchPresenter.ShowSearchResults(VResult, VLocalConverter.GetZoom);
end;

procedure TfrmMain.tbiEditSrchAcceptText(Sender: TObject; var NewText: String; var Accept: Boolean);
var
  VResult: IGeoCodeResult;
  VToolbarItem: TTBCustomItem;
  VItem: IGeoCoderListEntity;
  VLocalConverter: ILocalCoordConverter;
  VText: string;
  VNotifier: IOperationNotifier;
begin
  if Sender is TTBCustomItem then begin
    VToolbarItem := TTBCustomItem(Sender);
    VItem := IGeoCoderListEntity(VToolbarItem.Tag);
    if VItem <> nil then begin
      VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
      VText := Trim(NewText);
      VNotifier := TOperationNotifier.Create;
      VResult := VItem.GetGeoCoder.GetLocations(VNotifier, VNotifier.CurrentOperation, VText, VLocalConverter);
      FConfig.MainGeoCoderConfig.SearchHistory.AddItem(VText);
      FSearchPresenter.ShowSearchResults(VResult, VLocalConverter.GetZoom);
    end;
  end;
end;

procedure TfrmMain.TBSubmenuItem1Click(Sender: TObject);
var
  VResult: IGeoCodeResult;
  VZoom: Byte;
begin
  if FfrmGoTo.ShowGeocodeModal(VResult, VZoom) then begin
    FSearchPresenter.ShowSearchResults(VResult, VZoom);
  end;
end;

procedure TfrmMain.NSRTM3Click(Sender: TObject);
var
  VLocalConverter: ILocalCoordConverter;
  VConverter: ICoordConverter;
  VZoom: Byte;
  VMouseMapPoint: TDoublePoint;
  VLonLat:TDoublePoint;
begin
  VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
  VConverter := VLocalConverter.GetGeoConverter;
  VZoom := VLocalConverter.GetZoom;
  VMouseMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(FMouseState.GetLastDownPos(mbRight));
  VConverter.CheckPixelPosFloatStrict(VMouseMapPoint, VZoom, False);
  VLonLat := VConverter.PixelPosFloat2LonLat(VMouseMapPoint, VZoom);
  GState.InternalBrowser.Navigate(
    'http://ws.geonames.org/srtm3',
    'http://ws.geonames.org/srtm3?lat=' +
    R2StrPoint(VLonLat.y) +
    '&lng='+R2StrPoint(VLonLat.x)
  );
end;

procedure TfrmMain.NGTOPO30Click(Sender: TObject);
var
  VLocalConverter: ILocalCoordConverter;
  VConverter: ICoordConverter;
  VZoom: Byte;
  VMouseMapPoint: TDoublePoint;
  VLonLat:TDoublePoint;
begin
  VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
  VConverter := VLocalConverter.GetGeoConverter;
  VZoom := VLocalConverter.GetZoom;
  VMouseMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(FMouseState.GetLastDownPos(mbRight));
  VConverter.CheckPixelPosFloatStrict(VMouseMapPoint, VZoom, False);
  VLonLat := VConverter.PixelPosFloat2LonLat(VMouseMapPoint, VZoom);
  GState.InternalBrowser.Navigate(
    'http://ws.geonames.org/gtopo30',
    'http://ws.geonames.org/gtopo30?lat=' +
    R2StrPoint(VLonLat.y) +
    '&lng='+R2StrPoint(VLonLat.x)
  );
end;

procedure TfrmMain.Google1Click(Sender: TObject);
var
  VLocalConverter: ILocalCoordConverter;
  VConverter: ICoordConverter;
  VZoom: Byte;
  VMouseMapPoint: TDoublePoint;
  VLonLat:TDoublePoint;
begin
  VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
  VConverter := VLocalConverter.GetGeoConverter;
  VZoom := VLocalConverter.GetZoom;
  VMouseMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(FMouseState.GetLastDownPos(mbRight));
  VConverter.CheckPixelPosFloatStrict(VMouseMapPoint, VZoom, False);
  VLonLat := VConverter.PixelPosFloat2LonLat(VMouseMapPoint, VZoom);
  CopyStringToClipboard(
    'http://maps.google.com/?ie=UTF8&ll=' +
    R2StrPoint(VLonLat.y) + ',' +
    R2StrPoint(VLonLat.x) +
    '&spn=57.249013,100.371094&t=h&z='+inttostr(VZoom)
  );
end;

procedure TfrmMain.YaLinkClick(Sender: TObject);
var
  VLocalConverter: ILocalCoordConverter;
  VConverter: ICoordConverter;
  VZoom: Byte;
  VMouseMapPoint: TDoublePoint;
  VLonLat:TDoublePoint;
begin
  VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
  VConverter := VLocalConverter.GetGeoConverter;
  VZoom := VLocalConverter.GetZoom;
  VMouseMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(FMouseState.GetLastDownPos(mbRight));
  VConverter.CheckPixelPosFloatStrict(VMouseMapPoint, VZoom, False);
  VLonLat := VConverter.PixelPosFloat2LonLat(VMouseMapPoint, VZoom);
  CopyStringToClipboard(
    'http://maps.yandex.ru/?ll='+
    R2StrPoint(round(VLonLat.x*100000)/100000)+'%2C'+
    R2StrPoint(round(VLonLat.y*100000)/100000)+
    '&z=' + IntToStr(VZoom) +
    '&l=sat'
  );
end;

procedure TfrmMain.kosmosnimkiru1Click(Sender: TObject);
var
  VLocalConverter: ILocalCoordConverter;
  VConverter: ICoordConverter;
  VZoom: Byte;
  VMouseMapPoint: TDoublePoint;
  VLonLat:TDoublePoint;
begin
  VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
  VConverter := VLocalConverter.GetGeoConverter;
  VZoom := VLocalConverter.GetZoom;
  VMouseMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(FMouseState.GetLastDownPos(mbRight));
  VConverter.CheckPixelPosFloatStrict(VMouseMapPoint, VZoom, False);
  VLonLat := VConverter.PixelPosFloat2LonLat(VMouseMapPoint, VZoom);
  CopyStringToClipboard(
    'http://kosmosnimki.ru/?x=' +
    R2StrPoint(VLonLat.x) +
    '&y=' + R2StrPoint(VLonLat.y) +
    '&z=' + inttostr(VZoom) +
    '&fullscreen=false&mode=satellite'
  );
end;

procedure TfrmMain.livecom1Click(Sender: TObject);
var
  VLocalConverter: ILocalCoordConverter;
  VConverter: ICoordConverter;
  VZoom: Byte;
  VMouseMapPoint: TDoublePoint;
  VLonLat:TDoublePoint;
begin
  VLocalConverter := FConfig.ViewPortState.GetVisualCoordConverter;
  VConverter := VLocalConverter.GetGeoConverter;
  VZoom := VLocalConverter.GetZoom;
  VMouseMapPoint := VLocalConverter.LocalPixel2MapPixelFloat(FMouseState.GetLastDownPos(mbRight));
  VConverter.CheckPixelPosFloatStrict(VMouseMapPoint, VZoom, False);
  VLonLat := VConverter.PixelPosFloat2LonLat(VMouseMapPoint, VZoom);
  CopyStringToClipboard(
    'http://www.bing.com/maps/default.aspx?v=2&cp=' +
    R2StrPoint(VLonLat.y) + '~' +
    R2StrPoint(VLonLat.x) +
    '&style=h&lvl=' + inttostr(VZoom)
  );
end;

procedure TfrmMain.LoadMapIconsList;
var
  VMapType: TMapType;
  VList18: TMapTypeIconsList;
  VList24: TMapTypeIconsList;
  VEnum: IEnumGUID;
  VGUID: TGUID;
  VGetCount: Cardinal;
begin
  VList18 := TMapTypeIconsList.Create(18, 18);
  FMapTypeIcons18List := VList18;

  VList24 := TMapTypeIconsList.Create(24, 24);
  FMapTypeIcons24List := VList24;

  VEnum := GState.MapType.FullMapsSet.GetIterator;
  while VEnum.Next(1, VGUID, VGetCount) = S_OK do begin
    VMapType := GState.MapType.FullMapsSet.GetMapTypeByGUID(VGUID).MapType;
    VList18.Add(VGUID, VMapType.GUIConfig.Bmp18);
    VList24.Add(VGUID, VMapType.GUIConfig.Bmp24);
  end;
end;

procedure TfrmMain.MainPopupMenuPopup(Sender: TObject);
var
  i:Integer;
  VMapType: TMapType;
  VLayerIsActive: Boolean;
  VActiveLayersSet: IMapTypeSet;
  VMenuItem: TTBXItem;
  VGUID: TGUID;
  VGUIDList: IGUIDListStatic;
begin
  ldm.Visible:=false;
  dlm.Visible:=false;
  TBOpenDirLayer.Visible:=false;
  TBCopyLinkLayer.Visible:=false;
  TBLayerInfo.Visible:=false;
  VActiveLayersSet := FConfig.MainMapsConfig.GetActiveLayersSet.GetSelectedMapsSet;
  VGUIDList := GState.MapType.GUIConfigList.OrderedMapGUIDList;
  for i := 0 to VGUIDList.Count - 1 do begin
    VGUID := VGUIDList.Items[i];
    VMapType := GState.MapType.FullMapsSet.GetMapTypeByGUID(VGUID).MapType;
    if (VMapType.Abilities.IsLayer) then begin
      VLayerIsActive := VActiveLayersSet.GetMapTypeByGUID(VGUID) <> nil;
      TTBXItem(FNDwnItemList.GetByGUID(VGUID)).Visible := VLayerIsActive;
      TTBXItem(FNDelItemList.GetByGUID(VGUID)).Visible := VLayerIsActive;
      TTBXItem(FNOpenDirItemList.GetByGUID(VGUID)).Visible := VLayerIsActive;
      TTBXItem(FNCopyLinkItemList.GetByGUID(VGUID)).Visible := VLayerIsActive;
      VMenuItem := TTBXItem(FNLayerInfoItemList.GetByGUID(VGUID));
      VMenuItem.Visible := VLayerIsActive;
      if VLayerIsActive then begin
        VMenuItem.Enabled := VMapType.GUIConfig.InfoUrl.Value <> '';
      end;
      if VLayerIsActive then begin
        ldm.Visible:=true;
        dlm.Visible:=true;
        TBCopyLinkLayer.Visible:=true;
        TBOpenDirLayer.Visible:=true;
        TBLayerInfo.Visible:=true;
      end
    end;
  end;
  // current map
  VMapType:=FConfig.MainMapsConfig.GetSelectedMapType.MapType;
  // allow to view map info
  NMapInfo.Enabled:=VMapType.GUIConfig.InfoUrl.Value<>'';
  // allow to clear or select versions
  tbpmiClearVersion.Visible := (0<Length(VMapType.VersionConfig.Version.StoreString));
  tbpmiVersions.Visible := VMapType.AllowListOfTileVersions or tbpmiClearVersion.Visible;
end;

procedure TfrmMain.tbitmOnlineForumClick(Sender: TObject);
begin
  OpenUrlInBrowser('http://sasgis.ru/forum');
end;

procedure TfrmMain.tbitmOnlineHomeClick(Sender: TObject);
begin
  OpenUrlInBrowser('http://sasgis.ru/');
end;

procedure TfrmMain.NParamsPopup(Sender: TTBCustomItem; FromLink: Boolean);
var
  i:Integer;
  VMapType: TMapType;
  VLayerIsActive: Boolean;
  VActiveLayersSet: IMapTypeSet;
  VGUIDList: IGUIDListStatic;
  VGUID: TGUID;
begin
  NLayerParams.Visible:=false;
  VActiveLayersSet := FConfig.MainMapsConfig.GetActiveLayersSet.GetSelectedMapsSet;
  VGUIDList := GState.MapType.GUIConfigList.OrderedMapGUIDList;
  for i := 0 to VGUIDList.Count - 1 do begin
    VGUID := VGUIDList.Items[i];
    VMapType := GState.MapType.FullMapsSet.GetMapTypeByGUID(VGUID).MapType;
    if (VMapType.Abilities.IsLayer) then begin
      VLayerIsActive := VActiveLayersSet.GetMapTypeByGUID(VGUID) <> nil;
      TTBXItem(FNLayerParamsItemList.GetByGUID(VGUID)).Visible := VLayerIsActive;
      if VLayerIsActive then begin
        NLayerParams.Visible:=true;
      end
    end;
  end;
end;

procedure TfrmMain.tbtmHelpBugTrackClick(Sender: TObject);
begin
  OpenUrlInBrowser('http://sasgis.ru/mantis/');
end;

procedure TfrmMain.TBEditPathMarshClick(Sender: TObject);
var
  VResult: ILonLatPath;
  VEntity: IPathDetalizeProviderListEntity;
  VProvider: IPathDetalizeProvider;
  VIsError: Boolean;
  VInterface: IInterface;
  VPathOnMapEdit: IPathOnMapEdit;
  VOperationNotifier: IOperationNotifier;
begin
  if Supports(FLineOnMapEdit, IPathOnMapEdit, VPathOnMapEdit) then begin
    VInterface := IInterface(TTBXItem(Sender).tag);
    if Supports(VInterface, IPathDetalizeProviderListEntity, VEntity) then begin
      VProvider := VEntity.GetProvider;
      VIsError := True;
      try
        VOperationNotifier := TOperationNotifier.Create;
        VResult :=
          VProvider.GetPath(
            VOperationNotifier,
            VOperationNotifier.CurrentOperation,
            VPathOnMapEdit.Path,
            FMarshrutComment
          );
        VIsError := (VResult = nil);
      except
        on E: Exception do begin
          ShowMessage(E.Message);
        end;
      end;
      if not VIsError then begin
        if VResult.Count > 0 then begin
          VPathOnMapEdit.SetPath(VResult);
        end;
      end else begin
        FMarshrutComment := '';
      end;
    end;
  end;
end;

procedure TfrmMain.ZSliderMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer; Layer: TCustomLayer);
var h,xy:integer;
begin
  if ssLeft in Shift then begin
    if FRuller.Width<FRuller.Height then begin
      XY:=ZSlider.Height-Y;
      h:=(ZSlider.Height div 24);
    end else begin
      XY:=X;
      h:=(ZSlider.Width div 24);
    end;
    if XY in [h..h*24] then begin
      ZSlider.Tag:=(XY div h)-1;
      PaintZSlider(ZSlider.Tag);
      labZoom.Caption:='z'+inttostr(ZSlider.Tag+1);
    end;
  end;
end;

procedure TfrmMain.ZSliderMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
  if Button=mbLeft then begin
    ZSliderMouseMove(Sender,[ssLeft],X,Y,Layer);
    zooming(
      ZSlider.Tag,
      FMouseState.CurentPos,
      false
    );
  end;
end;

procedure TfrmMain.PaintZSlider(zoom:integer);
var tumbpos:TPoint;
begin
  if FRuller.Height>FRuller.Width then begin
    tumbpos.Y:=FRuller.Height-((FRuller.Height div 24)*(zoom+1))-(FTumbler.Height div 2);
    tumbpos.X:=(FRuller.Width div 2) - (FTumbler.Width div 2);
  end else begin
    tumbpos.X:=(FRuller.Width div 24)*(zoom+1)-(FTumbler.Width div 2);
    tumbpos.Y:=(FRuller.Height div 2) - (FTumbler.Height div 2);
  end;
  ZSlider.Bitmap.Assign(FRuller);
  FTumbler.DrawTo(ZSlider.Bitmap,tumbpos.X,tumbpos.Y);
end;

// TrayIcon

Procedure TfrmMain.TrayControl(var Msg: TMessage);
begin
  if (Msg.WParam = SC_MINIMIZE) and GState.GlobalAppConfig.IsShowIconInTray then begin
    TrayIcon.Visible := True;
    ShowWindow(Self.Handle, SW_HIDE);
    ShowWindow(Application.Handle, SW_HIDE);
  end else inherited;
end;

procedure TfrmMain.OnMinimize(Sender: TObject);
begin
  PostMessage(Self.Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
end;

procedure TfrmMain.OnNavToMarkChange;
begin
  tbitmNavigationArrow.Checked := FConfig.NavToPoint.IsActive;
end;

procedure TfrmMain.OnPathProvidesChange;
var
  VTree: IStaticTreeItem;
begin
  VTree := FPathProvidersTree.GetStatic;
  FPathProvidersMenuBuilder.BuildMenu(TBEditPathMarsh, VTree);
  FPathProvidersTreeStatic := VTree;
end;

procedure TfrmMain.OnSearchhistoryChange;
var
  i: Integer;
begin
  tbiSearch.Lines.Clear;
  FConfig.MainGeoCoderConfig.SearchHistory.LockRead;
  try
    for i := 0 to FConfig.MainGeoCoderConfig.SearchHistory.Count - 1 do begin
      tbiSearch.Lines.Add(FConfig.MainGeoCoderConfig.SearchHistory.GetItem(i));
    end;
  finally
    FConfig.MainGeoCoderConfig.SearchHistory.UnlockRead;
  end;
end;

procedure TfrmMain.TrayItemRestoreClick(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_SHOW);
  ShowWindow(Self.Handle, SW_SHOW);
  TrayIcon.Visible := False;
end;

procedure TfrmMain.TrayItemQuitClick(Sender: TObject);
begin
  TrayIcon.Visible := False;
  Close;
end;

procedure TfrmMain.tbitmCacheManagerClick(Sender: TObject);
begin
  FfrmCacheManager.Show;
end;

procedure TfrmMain.tbitmEditLastSelectionClick(Sender: TObject);
var
  VPolygon: ILonLatPolygon;
  VLineOnMapEdit: ILineOnMapEdit;
  VPolygonOnMapEdit: IPolygonOnMapEdit;
begin
  VPolygon := GState.LastSelectionInfo.Polygon;
  FState.State := ao_select_poly;
  TBRectSave.ImageIndex:=13;
  if VPolygon <> nil then begin
    if VPolygon.Count > 0 then begin
      VLineOnMapEdit := FLineOnMapEdit;
      if Supports(VLineOnMapEdit, IPolygonOnMapEdit,  VPolygonOnMapEdit) then begin
        VPolygonOnMapEdit.SetPolygon(VPolygon);
      end;
    end;
  end;
end;

end.




