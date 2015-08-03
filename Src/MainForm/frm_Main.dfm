object frmMain: TfrmMain
  Left = 488
  Top = 165
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'SAS.Planet'
  ClientHeight = 639
  ClientWidth = 842
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poDefault
  ShowHint = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseWheel = FormMouseWheel
  OnShortCut = FormShortCut
  PixelsPerInch = 96
  TextHeight = 13
  object map: TImage32
    Left = 413
    Top = 59
    Width = 265
    Height = 571
    Align = alClient
    Bitmap.CombineMode = cmMerge
    Bitmap.ResamplerClassName = 'TLinearResampler'
    BitmapAlign = baTopLeft
    Color = clSilver
    ParentColor = False
    RepaintMode = rmOptimizer
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 0
    OnDblClick = mapDblClick
    OnMouseLeave = mapMouseLeave
  end
  object TBDock: TTBXDock
    Left = 0
    Top = 0
    Width = 842
    Height = 59
    PopupMenu = TBXPopupPanels
    object TBMainToolBar: TTBXToolbar
      Left = 0
      Top = 25
      DockPos = -6
      DockRow = 1
      Images = PanelsImageList
      Stretch = True
      TabOrder = 0
      Caption = 'Main'
      object TBmove: TTBXItem
        Checked = True
        ImageIndex = 8
        Images = PanelsImageList
        Options = [tboDefault]
        OnClick = TBmoveClick
        Caption = ''
        Hint = 'Move'
      end
      object TBRectSave: TTBXSubmenuItem
        DropdownCombo = True
        ImageIndex = 10
        Images = PanelsImageList
        LinkSubitems = NRectSave
        Options = [tboShowHint]
        OnClick = TBRectSaveClick
        Caption = ''
        Hint = 'Selection manager'
      end
      object TBCalcRas: TTBXItem
        AutoCheck = True
        ImageIndex = 9
        Images = PanelsImageList
        OnClick = TBCalcRasClick
        Caption = ''
        Hint = 'Distance calculation'
      end
      object TBXSeparatorItem4: TTBXSeparatorItem
        Caption = ''
        Hint = ''
      end
      object TBMapZap: TTBXSubmenuItem
        DisplayMode = nbdmImageAndText
        ImageIndex = 7
        Images = PanelsImageList
        LinkSubitems = NFillMap
        Options = [tboDropdownArrow, tboShowHint]
        Caption = ''
        Hint = 'Cached tiles map'
      end
      object TBGoTo: TTBXSubmenuItem
        DropdownCombo = True
        ImageIndex = 11
        Images = PanelsImageList
        Options = [tboShowHint]
        OnClick = TBSubmenuItem1Click
        Caption = ''
        Hint = 'Go to'
      end
      object TBXSeparatorItem5: TTBXSeparatorItem
        Caption = ''
        Hint = ''
      end
      object TBFullSize: TTBXItem
        AutoCheck = True
        ImageIndex = 4
        Images = PanelsImageList
        OnClick = TBFullSizeClick
        Caption = ''
        Hint = 'Full screen (F11)'
      end
    end
    object SrcToolbar: TTBXToolbar
      Left = 242
      Top = 25
      DockPos = 224
      DockRow = 1
      Stretch = True
      TabOrder = 1
      Caption = 'Sources'
      object TBSrc: TTBXSubmenuItem
        ImageIndex = 0
        Images = PanelsImageList
        LinkSubitems = NSources
        Options = [tboDropdownArrow]
        Caption = ''
        Hint = 'Select data source'
      end
      object TBSMB: TTBXSubmenuItem
        DisplayMode = nbdmImageAndText
        ImageIndex = 3
        Images = PanelsImageList
        Options = [tboDropdownArrow]
        Caption = ''
        Hint = 'Selected basemap'
      end
      object TBLayerSel: TTBXSubmenuItem
        ImageIndex = 3
        Images = PanelsImageList
        Options = [tboDropdownArrow]
        Caption = ''
        Hint = 'Select overlay layers'
        object btnHideAll: TTBXItem
          OnClick = btnHideAllClick
          Caption = 'Hide All'
          Hint = ''
        end
        object HideSeparator: TTBSeparatorItem
          Caption = ''
          Hint = ''
        end
      end
    end
    object TBMarksToolbar: TTBXToolbar
      Left = 369
      Top = 25
      DockPos = 363
      DockRow = 1
      Images = PanelsImageList
      LinkSubitems = NMarksGroup
      Stretch = True
      TabOrder = 2
      Caption = 'Placemarks'
    end
    object GPSToolbar: TTBXToolbar
      Left = 540
      Top = 25
      DockPos = 504
      DockRow = 1
      Images = PanelsImageList
      Stretch = True
      TabOrder = 3
      Caption = 'GPS'
      object TBGPSconn: TTBXItem
        AutoCheck = True
        ImageIndex = 14
        Images = PanelsImageList
        OnClick = TBGPSconnClick
        Caption = ''
        Hint = 'Connect to GPS receiver'
      end
      object TBGPSPath: TTBXSubmenuItem
        AutoCheck = True
        DropdownCombo = True
        ImageIndex = 6
        Images = PanelsImageList
        OnClick = TBGPSPathClick
        Caption = ''
        Hint = 'Show GPS track'
        object tbitmSaveCurrentPositionToolbar: TTBXItem
          ImageIndex = 15
          Images = MenusImageList
          OnClick = tbitmSaveCurrentPositionClick
          Caption = 'Add Placemark'
          Hint = ''
        end
        object TBXSeparatorItem16: TTBXSeparatorItem
          Caption = ''
          Hint = ''
        end
        object tbitmGPSTrackSaveToMarks: TTBXItem
          ImageIndex = 25
          Images = MenusImageList
          OnClick = tbitmGPSTrackSaveToMarksClick
          Caption = 'Add Track to Database'
          Hint = ''
        end
        object TBXSeparatorItem17: TTBXSeparatorItem
          Caption = ''
          Hint = ''
        end
        object TBItemDelTrack: TTBXItem
          ImageIndex = 35
          Images = MenusImageList
          OnClick = TBItemDelTrackClick
          Caption = 'Delete Track'
          Hint = ''
        end
      end
      object TBGPSToPoint: TTBXSubmenuItem
        AutoCheck = True
        DropdownCombo = True
        ImageIndex = 5
        Images = PanelsImageList
        OnClick = TBGPSToPointClick
        Caption = ''
        Hint = 'Follow GPS Position'
        object TBGPSToPointCenter: TTBXItem
          AutoCheck = True
          OnClick = TBGPSToPointCenterClick
          Caption = 'Centered GPS Position'
          Hint = ''
        end
      end
    end
    object TBExit: TTBXToolbar
      Left = 807
      Top = 25
      DockPos = 807
      DockRow = 1
      TabOrder = 4
      Visible = False
      object TBXExit: TTBXItem
        ImageIndex = 29
        Images = MenusImageList
        OnClick = TrayItemQuitClick
        Caption = ''
        Hint = 'Quit'
      end
    end
    object TBXMainMenu: TTBXToolbar
      Left = 0
      Top = 0
      CloseButton = False
      DockPos = -6
      MenuBar = True
      ProcessShortCuts = True
      ShrinkMode = tbsmWrap
      Stretch = True
      TabOrder = 5
      Caption = 'Main Menu'
      object NOperations: TTBXSubmenuItem
        Caption = '&Operations'
        Hint = ''
        object tbitmCreateShortcut: TTBXItem
          Images = MenusImageList
          OnClick = tbitmCreateShortcutClick
          Caption = 'Create Shortcut'
          Hint = ''
        end
        object tbitmOpenFile: TTBXItem
          ImageIndex = 34
          Images = MenusImageList
          OnClick = tbitmOpenFileClick
          Caption = 'Open...'
          Hint = ''
        end
        object TBXSeparatorItem6: TTBXSeparatorItem
          Caption = ''
          Hint = ''
        end
        object NZoomIn: TTBXItem
          ImageIndex = 23
          Images = MenusImageList
          ShortCut = 33
          OnClick = NzoomInClick
          Caption = 'Zoom In'
          Hint = ''
        end
        object NZoomOut: TTBXItem
          ImageIndex = 24
          Images = MenusImageList
          ShortCut = 34
          OnClick = NZoomOutClick
          Caption = 'Zoom Out'
          Hint = ''
        end
        object TBXSeparatorItem7: TTBXSeparatorItem
          Caption = ''
          Hint = ''
        end
        object tbitmGoToModal: TTBXItem
          ImageIndex = 11
          Images = MenusImageList
          ShortCut = 16455
          OnClick = TBSubmenuItem1Click
          Caption = 'Go to...'
          Hint = ''
        end
        object NCalcRast: TTBXItem
          ImageIndex = 9
          Images = MenusImageList
          ShortCut = 16460
          OnClick = NCalcRastClick
          Caption = 'Distance Calculation'
          Hint = ''
        end
        object TBXSeparatorItem8: TTBXSeparatorItem
          Caption = ''
          Hint = ''
        end
        object NRectSave: TTBXSubmenuItem
          Images = MenusImageList
          Caption = 'Selection Manager'
          Hint = ''
          object TBRECT: TTBXItem
            ImageIndex = 10
            Images = PanelsImageList
            Options = [tboShowHint]
            ShortCut = 32850
            OnClick = TBRECTClick
            Caption = 'Rectangular Selection'
            Hint = 
              'Alt - snap to Lat/Lon grid (if enabled)'#13#10'Ctrl - snap to tile bou' +
              'ndaries'#13#10'Shift - snap to GenShtab boundaries (if enabled)'
          end
          object TBREGION: TTBXItem
            ImageIndex = 13
            Images = PanelsImageList
            ShortCut = 32848
            OnClick = TBREGIONClick
            Caption = 'Polygonal Selection'
            Hint = ''
          end
          object TBPolylineSelect: TTBXItem
            ImageIndex = 21
            Images = PanelsImageList
            OnClick = TBPolylineSelectClick
            Caption = 'Polyline Selection'
            Hint = ''
          end
          object TBCOORD: TTBXItem
            ImageIndex = 12
            Images = PanelsImageList
            OnClick = TBCOORDClick
            Caption = 'By Coordinates'
            Hint = ''
          end
          object TBScreenSelect: TTBXItem
            ImageIndex = 20
            Images = PanelsImageList
            ShortCut = 16449
            OnClick = TBScreenSelectClick
            Caption = 'Visible Area'
            Hint = ''
          end
          object TBXSeparatorItem13: TTBXSeparatorItem
            Caption = ''
            Hint = ''
          end
          object TBPrevious: TTBXItem
            ImageIndex = 44
            Images = MenusImageList
            ShortCut = 16450
            OnClick = TBPreviousClick
            Caption = 'Last Selection'
            Hint = ''
          end
          object tbitmEditLastSelection: TTBXItem
            ImageIndex = 31
            Images = MenusImageList
            OnClick = tbitmEditLastSelectionClick
            Caption = 'Edit Last Selection'
            Hint = ''
          end
          object TBLoadSelFromFile: TTBXItem
            ImageIndex = 34
            Images = MenusImageList
            OnClick = TBLoadSelFromFileClick
            Caption = 'Load from File'
            Hint = ''
          end
        end
        object TBXSeparatorItem9: TTBXSeparatorItem
          Caption = ''
          Hint = ''
        end
        object tbitmCacheManager: TTBXItem
          Images = MenusImageList
          OnClick = tbitmCacheManagerClick
          Caption = 'Cache Manager'
          Hint = ''
        end
        object TBXSeparatorCacheManager: TTBXSeparatorItem
          Caption = ''
          Hint = ''
        end
        object tbitmQuit: TTBXItem
          ImageIndex = 29
          Images = MenusImageList
          OnClick = tbitmQuitClick
          Caption = 'Quit'
          Hint = ''
        end
      end
      object NView: TTBXSubmenuItem
        Caption = '&View'
        Hint = ''
        object NPanels: TTBXSubmenuItem
          Images = MenusImageList
          Caption = 'Toolbars'
          Hint = ''
          object NMainToolBarShow: TTBXVisibilityToggleItem
            Control = TBMainToolBar
            Images = MenusImageList
            Caption = 'Main'
            Hint = ''
          end
          object NZoomToolBarShow: TTBXVisibilityToggleItem
            Control = ZoomToolBar
            Images = MenusImageList
            Caption = 'Zoom'
            Hint = ''
          end
          object NsrcToolBarShow: TTBXVisibilityToggleItem
            Control = SrcToolbar
            Images = MenusImageList
            Caption = 'Sources'
            Hint = ''
          end
          object NGPSToolBarShow: TTBXVisibilityToggleItem
            Control = GPSToolbar
            Images = MenusImageList
            Caption = 'GPS'
            Hint = ''
          end
          object TBXVisibilityToggleItem1: TTBXVisibilityToggleItem
            Control = TBMarksToolbar
            Images = MenusImageList
            Caption = 'Placemarks'
            Hint = ''
          end
          object TBXVisibilityToggleItem2: TTBXVisibilityToggleItem
            Control = TBXToolBarSearch
            Images = MenusImageList
            Caption = 'Search'
            Hint = ''
          end
          object NSearchResults: TTBXVisibilityToggleItem
            Control = TBSearchWindow
            Images = MenusImageList
            Caption = 'Search Results'
            Hint = ''
          end
          object tbxMergePolygonsShow: TTBXVisibilityToggleItem
            Control = tbMergePolygons
            Images = MenusImageList
            Caption = 'Merge Polygons'
            Hint = ''
          end
          object TBXVisibilityToggleItem3: TTBXVisibilityToggleItem
            Control = FillDates
            Images = MenusImageList
            Caption = 'Time Interval'
            Hint = ''
          end
          object NSensors: TTBXSubmenuItem
            AutoCheck = True
            DropdownCombo = True
            Images = MenusImageList
            OnClick = NSensorsClick
            Caption = 'Sensors'
            Hint = ''
          end
          object TBXSeparatorItem18: TTBXSeparatorItem
            Caption = ''
            Hint = ''
          end
          object NBlock_toolbars: TTBXItem
            AutoCheck = True
            Images = MenusImageList
            OnClick = NBlock_toolbarsClick
            Caption = 'Lock Toolbars'
            Hint = ''
          end
        end
        object tbsbmInterface: TTBXSubmenuItem
          Images = MenusImageList
          Caption = 'Interface'
          Hint = ''
          object Showstatus: TTBXItem
            AutoCheck = True
            Images = MenusImageList
            ShortCut = 32851
            OnClick = ShowstatusClick
            Caption = 'Status Bar'
            Hint = ''
          end
          object ShowMiniMap: TTBXItem
            AutoCheck = True
            Images = MenusImageList
            ShortCut = 32845
            OnClick = ShowMiniMapClick
            Caption = 'Overview Map'
            Hint = ''
          end
          object ShowLine: TTBXItem
            AutoCheck = True
            Images = MenusImageList
            ShortCut = 32844
            OnClick = ShowLineClick
            Caption = 'Scale Legend'
            Hint = ''
          end
        end
        object NFillMap: TTBXSubmenuItem
          ImageIndex = 7
          Images = MenusImageList
          OnClick = NFillMapClick
          Caption = 'Cached Tiles Map'
          Hint = ''
          object TBFillingTypeMap: TTBXSubmenuItem
            Images = MenusImageList
            Options = [tboDropdownArrow]
            Caption = 'Show for...'
            Hint = ''
            object tbitmFillingMapAsMain: TTBXItem
              OnAdjustFont = AdjustFont
              OnClick = TBfillMapAsMainClick
              Caption = 'Displayed Main Map'
              Hint = ''
            end
          end
          object TBXSeparatorItem11: TTBXSeparatorItem
            Caption = ''
            Hint = ''
          end
          object TBXToolPalette1: TTBXToolPalette
            ColCount = 5
            Images = ScalesImageList
            PaletteOptions = []
            RowCount = 7
            OnCellClick = TBXToolPalette1CellClick
            Caption = ''
            Hint = ''
          end
          object TBXSeparatorItem20: TTBXSeparatorItem
            Caption = ''
            Hint = ''
          end
          object NFillMode1: TTBXItem
            Tag = 99
            Checked = True
            GroupIndex = 2
            Images = MenusImageList
            RadioItem = True
            OnClick = NFillMode1Click
            Caption = 'Mark Nonexistent Tiles'
            Hint = ''
          end
          object NFillMode2: TTBXItem
            Tag = 99
            GroupIndex = 2
            Images = MenusImageList
            RadioItem = True
            OnClick = NFillMode2Click
            Caption = 'Mark Existing Tiles'
            Hint = ''
          end
          object NFillMode3: TTBXItem
            Tag = 99
            GroupIndex = 2
            Images = MenusImageList
            RadioItem = True
            OnClick = NFillMode3Click
            Caption = 'Use Age Gradient'
            Hint = ''
          end
          object TBXSeparatorItem21: TTBXSeparatorItem
            Caption = ''
            Hint = ''
          end
          object NShowFillDates: TTBXItem
            Tag = 99
            GroupIndex = 1
            Images = MenusImageList
            OnClick = NShowFillDatesClick
            Caption = 'Within Time Interval'
            Hint = ''
          end
        end
        object NShowGran: TTBXSubmenuItem
          ImageIndex = 3
          Images = MenusImageList
          OnClick = NShowGranClick
          Caption = 'Tile Boundaries'
          Hint = ''
          object N000: TTBXItem
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = N000Click
            Caption = 'No'
            Hint = ''
          end
          object N001: TTBXItem
            Tag = 100
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = N000Click
            Caption = 'Current Zoom'
            Hint = ''
          end
          object N002: TTBXItem
            Tag = 2
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = N000Click
            Caption = '2'
            Hint = ''
          end
          object N003: TTBXItem
            Tag = 3
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = N000Click
            Caption = '3'
            Hint = ''
          end
          object N004: TTBXItem
            Tag = 4
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = N000Click
            Caption = '4'
            Hint = ''
          end
          object N005: TTBXItem
            Tag = 5
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = N000Click
            Caption = '5'
            Hint = ''
          end
          object N006: TTBXItem
            Tag = 6
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = N000Click
            Caption = '6'
            Hint = ''
          end
          object N007: TTBXItem
            Tag = 7
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = N000Click
            Caption = '7'
            Hint = ''
          end
          object tbitmTileGrid1p: TTBXItem
            Tag = 101
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = N000Click
            Caption = 'Current Zoom + 1'
            Hint = ''
          end
          object tbitmTileGrid2p: TTBXItem
            Tag = 102
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = N000Click
            Caption = 'Current Zoom + 2'
            Hint = ''
          end
          object tbitmTileGrid3p: TTBXItem
            Tag = 103
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = N000Click
            Caption = 'Current Zoom + 3'
            Hint = ''
          end
          object tbitmTileGrid4p: TTBXItem
            Tag = 104
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = N000Click
            Caption = 'Current Zoom + 4'
            Hint = ''
          end
          object tbitmTileGrid5p: TTBXItem
            Tag = 105
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = N000Click
            Caption = 'Current Zoom + 5'
            Hint = ''
          end
        end
        object tbsbmGenShtabScale: TTBXSubmenuItem
          Images = MenusImageList
          Caption = 'GenShtab Maps Boundaries'
          Hint = ''
          object NGShScale0: TTBXItem
            AutoCheck = True
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = NGShScale01Click
            Caption = 'No'
            Hint = ''
          end
          object NGShScale1000000: TTBXItem
            Tag = 1000000
            AutoCheck = True
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = NGShScale01Click
            Caption = '1:1 000 000 (10 km)'
            Hint = ''
          end
          object NGShScale500000: TTBXItem
            Tag = 500000
            AutoCheck = True
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = NGShScale01Click
            Caption = '1:500 000 (5 km)'
            Hint = ''
          end
          object NGShScale200000: TTBXItem
            Tag = 200000
            AutoCheck = True
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = NGShScale01Click
            Caption = '1:200 000 (2 km)'
            Hint = ''
          end
          object NGShScale100000: TTBXItem
            Tag = 100000
            AutoCheck = True
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = NGShScale01Click
            Caption = '1:100 000 (1 km)'
            Hint = ''
          end
          object NGShScale50000: TTBXItem
            Tag = 50000
            AutoCheck = True
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = NGShScale01Click
            Caption = '1:50 000 (500 m)'
            Hint = ''
          end
          object NGShScale25000: TTBXItem
            Tag = 25000
            AutoCheck = True
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = NGShScale01Click
            Caption = '1:25 000 (250 m)'
            Hint = ''
          end
          object NGShScale10000: TTBXItem
            Tag = 10000
            AutoCheck = True
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = NGShScale01Click
            Caption = '1:10 000 (100 m)'
            Hint = ''
          end
          object NGShScale5000: TTBXItem
            Tag = 5000
            AutoCheck = True
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = NGShScale01Click
            Caption = '1:5 000 (50 m)'
            Hint = ''
          end
          object NGShScale2500: TTBXItem
            Tag = 2500
            AutoCheck = True
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = NGShScale01Click
            Caption = '1:2 500 (25 m)'
            Hint = ''
          end
          object TBSeparatorItem3: TTBSeparatorItem
            Caption = ''
            Hint = ''
          end
          object NGShauto: TTBXItem
            Tag = -1
            AutoCheck = True
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = NGShScale01Click
            Caption = 'Auto'
            Hint = ''
          end
        end
        object DegreedLinesSubMenu: TTBXSubmenuItem
          Images = MenusImageList
          Caption = 'Lat/Lon Grid'
          Hint = ''
          object NDegScale0: TTBXItem
            AutoCheck = True
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = NDegScale0Click
            Caption = 'No'
            Hint = ''
          end
          object NDegScale1000000: TTBXItem
            Tag = 1000000000
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = NDegScale0Click
            Caption = '10'#176
            Hint = ''
          end
          object NDegScale500000: TTBXItem
            Tag = 500000000
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = NDegScale0Click
            Caption = '5'#176
            Hint = ''
          end
          object NDegScale200000: TTBXItem
            Tag = 200000000
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = NDegScale0Click
            Caption = '2'#176
            Hint = ''
          end
          object NDegScale100000: TTBXItem
            Tag = 100000000
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = NDegScale0Click
            Caption = '1'#176
            Hint = ''
          end
          object NDegScale50000: TTBXItem
            Tag = 50000000
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = NDegScale0Click
            Caption = '0.5'#176
            Hint = ''
          end
          object NDegScale25000: TTBXItem
            Tag = 25000000
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = NDegScale0Click
            Caption = '0.25'#176
            Hint = ''
          end
          object NDegScale10000: TTBXItem
            Tag = 12500000
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = NDegScale0Click
            Caption = '0.125'#176
            Hint = ''
          end
          object TBXSeparatorItem22: TTBXSeparatorItem
            Caption = ''
            Hint = ''
          end
          object NDegScaleUser: TTBXItem
            Tag = 1
            GroupIndex = 1
            RadioItem = True
            OnClick = NDegScale0Click
            Caption = 'User defined'
            Hint = ''
          end
          object NDegValue: TTBXEditItem
            OnAcceptText = NDegValueAcceptText
            Caption = ''
            Hint = ''
          end
          object TBSeparatorItem2: TTBSeparatorItem
            Caption = ''
            Hint = ''
          end
          object NDegScaleAuto: TTBXItem
            Tag = -100000000
            GroupIndex = 1
            Images = MenusImageList
            RadioItem = True
            OnClick = NDegScale0Click
            Caption = 'Auto'
            Hint = ''
          end
        end
        object tbxsbmProjection: TTBXSubmenuItem
          Images = MenusImageList
          Caption = 'Projection'
          Hint = ''
        end
        object TBXSubmenuMap: TTBXSubmenuItem
          Images = MenusImageList
          Caption = 'Maps'
          Hint = ''
          object tbxnxtmap: TTBXItem
            OnClick = tbxnxtmapClick
            Caption = 'Next map with tile'
            Hint = ''
          end
          object tbxprevmap: TTBXItem
            OnClick = tbxprevmapClick
            Caption = 'Previous map with tile'
            Hint = ''
          end
        end
        object TBXSubmnMapVer: TTBXSubmenuItem
          Images = MenusImageList
          Caption = 'Versions'
          Hint = ''
          object TBXNextVer: TTBXItem
            OnClick = TBXNextVerClick
            Caption = 'Next version'
            Hint = ''
          end
          object TBXPrevVer: TTBXItem
            OnClick = TBXPrevVerClick
            Caption = 'Previous version'
            Hint = ''
          end
        end
        object TBXSeparatorItem10: TTBXSeparatorItem
          Caption = ''
          Hint = ''
        end
        object NFoolSize: TTBXItem
          AutoCheck = True
          ImageIndex = 4
          Images = MenusImageList
          ShortCut = 122
          OnClick = TBFullSizeClick
          Caption = 'Full Screen'
          Hint = ''
        end
        object NGoToCur: TTBXItem
          AutoCheck = True
          Checked = True
          Images = MenusImageList
          OnClick = NGoToCurClick
          Caption = 'Zoom to Cursor'
          Hint = ''
        end
        object Nbackload: TTBXItem
          AutoCheck = True
          Checked = True
          Images = MenusImageList
          OnClick = NbackloadClick
          Caption = 'Use Maps from Lower Zooms'
          Hint = ''
        end
        object NbackloadLayer: TTBXItem
          AutoCheck = True
          Checked = True
          Images = MenusImageList
          OnClick = NbackloadLayerClick
          Caption = 'Use Layers from Lower Zooms'
          Hint = ''
        end
        object Nanimate: TTBXItem
          AutoCheck = True
          Checked = True
          Images = MenusImageList
          OnClick = NanimateClick
          Caption = 'Zoom Animation'
          Hint = ''
        end
        object NAnimateMove: TTBXItem
          AutoCheck = True
          Checked = True
          Images = MenusImageList
          OnClick = NAnimateMoveClick
          Caption = 'Inertial Movement'
          Hint = ''
        end
        object tbitmGauge: TTBXItem
          AutoCheck = True
          Images = MenusImageList
          OnClick = tbitmGaugeClick
          Caption = 'Azimuth Circle'
          Hint = ''
        end
        object Ninvertcolor: TTBXItem
          AutoCheck = True
          Images = MenusImageList
          ShortCut = 32846
          OnClick = NinvertcolorClick
          Caption = 'Night Mode (Color Inversion)'
          Hint = ''
        end
        object NShowSelection: TTBXItem
          AutoCheck = True
          Images = MenusImageList
          OnClick = NShowSelectionClick
          Caption = 'Previous Selection'
          Hint = ''
        end
        object tbitmNavigationArrow: TTBXItem
          Images = MenusImageList
          OnClick = tbitmNavigationArrowClick
          Caption = 'Navigation Arrow'
          Hint = ''
        end
        object tbitmShowDebugInfo: TTBXItem
          Images = MenusImageList
          Visible = False
          OnClick = tbitmShowDebugInfoClick
          Caption = 'Debug Info'
          Hint = ''
        end
      end
      object NSources: TTBXSubmenuItem
        Caption = '&Source'
        Hint = ''
        object NSRCesh: TTBXItem
          Tag = 1
          AutoCheck = True
          GroupIndex = 1
          ImageIndex = 1
          Images = PanelsImageList
          RadioItem = True
          ShortCut = 32835
          OnAdjustFont = AdjustFont
          OnClick = NSRCinetClick
          Caption = 'Cache'
          Hint = ''
        end
        object NSRCinet: TTBXItem
          AutoCheck = True
          GroupIndex = 1
          ImageIndex = 0
          Images = PanelsImageList
          RadioItem = True
          ShortCut = 32841
          OnAdjustFont = AdjustFont
          OnClick = NSRCinetClick
          Caption = 'Internet'
          Hint = ''
        end
        object NSRCic: TTBXItem
          Tag = 2
          AutoCheck = True
          GroupIndex = 1
          ImageIndex = 2
          Images = PanelsImageList
          RadioItem = True
          ShortCut = 32834
          OnAdjustFont = AdjustFont
          OnClick = NSRCinetClick
          Caption = 'Internet && Cache'
          Hint = ''
        end
      end
      object NSMB: TTBXSubmenuItem
        LinkSubitems = TBSMB
        Caption = '&Maps'
        Hint = ''
      end
      object NLayerSel: TTBXSubmenuItem
        LinkSubitems = TBLayerSel
        Caption = 'Layers'
        Hint = ''
      end
      object NMarks: TTBXSubmenuItem
        Caption = 'Placemarks'
        Hint = ''
        object NMarksGroup: TTBGroupItem
          Caption = ''
          Hint = ''
          object TBAdd_Point: TTBXItem
            GroupIndex = 1
            ImageIndex = 15
            Images = PanelsImageList
            Options = [tboShowHint]
            Stretch = True
            OnClick = TBAdd_PointClick
            Caption = 'Add Placemark'
            Hint = 'Add new placemark'
          end
          object TBAdd_Line: TTBXItem
            ImageIndex = 16
            Images = PanelsImageList
            MaskOptions = [tboShowHint]
            OnClick = TBAdd_LineClick
            Caption = 'Add Path'
            Hint = 'Add new path'
          end
          object TBAdd_Poly: TTBXItem
            ImageIndex = 17
            Images = PanelsImageList
            Options = [tboShowHint]
            OnClick = TBAdd_PolyClick
            Caption = 'Add Polygon'
            Hint = 'Add polygon'
          end
          object TBXSeparatorItem12: TTBXSeparatorItem
            Caption = ''
            Hint = ''
          end
          object tbitmPlacemarkManager: TTBXItem
            ImageIndex = 18
            Images = PanelsImageList
            Options = [tboShowHint]
            OnClick = tbitmPlacemarkManagerClick
            Caption = 'Placemark Manager'
            Hint = 'Placemark manager'
          end
          object TBHideMarks: TTBXItem
            AutoCheck = True
            ImageIndex = 19
            Images = PanelsImageList
            OnClick = TBHideMarksClick
            Caption = 'Hide All Placemarks'
            Hint = 'Hide all placemarks'
          end
        end
        object tbitmShowMarkCaption: TTBXItem
          AutoCheck = True
          Checked = True
          Images = PanelsImageList
          OnClick = tbitmShowMarkCaptionClick
          Caption = 'Placemark Names'
          Hint = ''
        end
        object tbitmPointProject: TTBXItem
          Images = PanelsImageList
          OnClick = tbitmPointProjectClick
          Caption = 'Project Point'
          Hint = ''
        end
        object tbxMergePolygonsShow1: TTBXVisibilityToggleItem
          Control = tbMergePolygons
          Images = PanelsImageList
          Caption = 'Merge Polygons'
          Hint = ''
        end
      end
      object tbsbmGPS: TTBXSubmenuItem
        Caption = 'GPS'
        Hint = ''
        object tbitmGPSConnect: TTBXItem
          AutoCheck = True
          ImageIndex = 14
          Images = MenusImageList
          ShortCut = 49223
          OnClick = TBGPSconnClick
          Caption = 'Connect to GPS Receiver'
          Hint = ''
        end
        object tbitmGPSTrackShow: TTBXItem
          AutoCheck = True
          ImageIndex = 6
          Images = MenusImageList
          ShortCut = 49236
          OnClick = TBGPSPathClick
          Caption = 'Show GPS Track'
          Hint = ''
        end
        object tbitmGPSCenterMap: TTBXItem
          AutoCheck = True
          ImageIndex = 5
          Images = MenusImageList
          OnClick = TBGPSToPointClick
          Caption = 'Follow GPS Position'
          Hint = ''
        end
        object tbitmGPSToPointCenter: TTBXItem
          AutoCheck = True
          Images = MenusImageList
          OnClick = TBGPSToPointCenterClick
          Caption = 'Centered GPS Position'
          Hint = ''
        end
        object tbsprtGPS1: TTBXSeparatorItem
          Caption = ''
          Hint = ''
        end
        object tbitmSaveCurrentPosition: TTBXItem
          ImageIndex = 15
          Images = MenusImageList
          ShortCut = 49235
          OnClick = tbitmSaveCurrentPositionClick
          Caption = 'Add Placemark'
          Hint = ''
        end
        object tbitmGPSTrackSaveToDb: TTBXItem
          ImageIndex = 25
          Images = MenusImageList
          OnClick = tbitmGPSTrackSaveToMarksClick
          Caption = 'Add Track to Database'
          Hint = ''
        end
        object tbitmGPSTrackClear: TTBXItem
          ImageIndex = 35
          Images = MenusImageList
          OnClick = TBItemDelTrackClick
          Caption = 'Delete Track'
          Hint = ''
        end
        object tbsprtGPS2: TTBXSeparatorItem
          Caption = ''
          Hint = ''
        end
        object tbitmPositionByGSM: TTBXItem
          Images = MenusImageList
          OnClick = tbitmPositionByGSMClick
          Caption = 'Get Locaton from GSM (Google Query)'
          Hint = ''
        end
        object TBXSeparatorItem19: TTBXSeparatorItem
          Caption = ''
          Hint = ''
        end
        object tbitmGPSOptions: TTBXItem
          ImageIndex = 20
          Images = MenusImageList
          OnClick = tbitmGPSOptionsClick
          Caption = 'Options'
          Hint = ''
        end
      end
      object NParams: TTBXSubmenuItem
        OnPopup = NParamsPopup
        Caption = 'Settings'
        Hint = ''
        object NMapParams: TTBXItem
          Images = MenusImageList
          ShortCut = 49232
          OnClick = NMapParamsClick
          Caption = 'Map Settings'
          Hint = ''
        end
        object NLayerParams: TTBXSubmenuItem
          Images = MenusImageList
          Caption = 'Layer Settings'
          Hint = ''
        end
        object TBXSeparatorItem14: TTBXSeparatorItem
          Caption = ''
          Hint = ''
        end
        object tbitmOptions: TTBXItem
          ImageIndex = 20
          Images = MenusImageList
          OnClick = tbitmOptionsClick
          Caption = 'Options'
          Hint = ''
        end
        object tbitmInterfaceOptions: TTBXItem
          Images = MenusImageList
          OnClick = tbitmOnInterfaceOptionsClick
          Caption = 'Interface Options'
          Hint = ''
        end
        object TBLang: TTBXSubmenuItem
          Images = MenusImageList
          Caption = 'Language'
          Hint = ''
        end
      end
      object tbsbmHelp: TTBXSubmenuItem
        Caption = '&Help'
        Hint = ''
        object tbitmOnlineHelp: TTBXItem
          ImageIndex = 26
          Images = MenusImageList
          ShortCut = 112
          OnClick = tbitmOnlineHelpClick
          Caption = 'Online Help (http://sasgis.org/wikisasiya)'
          Hint = ''
        end
        object tbitmAbout: TTBXItem
          ImageIndex = 27
          Images = MenusImageList
          OnClick = tbitmAboutClick
          Caption = 'About'
          Hint = ''
        end
        object tbsprtHelp01: TTBXSeparatorItem
          Caption = ''
          Hint = ''
        end
        object tbitmOnlineHome: TTBXItem
          Images = MenusImageList
          OnClick = tbitmOnlineHomeClick
          Caption = 'Web Site (http://www.sasgis.org)'
          Hint = ''
        end
        object tbtmHelpBugTrack: TTBXItem
          Images = MenusImageList
          OnClick = tbtmHelpBugTrackClick
          Caption = 'Issue Tracker (http://sasgis.org/mantis)'
          Hint = ''
        end
        object tbitmOnlineForum: TTBXItem
          Images = MenusImageList
          OnClick = tbitmOnlineForumClick
          Caption = 'Community  (http://www.sasgis.org/forum)'
          Hint = ''
        end
        object tbxSep1: TTBXSeparatorItem
          Caption = ''
          Hint = ''
        end
        object tbxtmPascalScriptIDE: TTBXItem
          Images = MenusImageList
          OnClick = tbxtmPascalScriptIDEClick
          Caption = 'PascalScript IDE'
          Hint = ''
        end
        object tbxSep2: TTBXSeparatorItem
          Caption = ''
          Hint = ''
        end
        object tbitmCheckUpdate: TTBXItem
          Images = MenusImageList
          OnClick = tbitmCheckUpdateClick
          Caption = 'Check for updates...'
          Hint = ''
        end
      end
    end
    object TBXToolBarSearch: TTBXToolbar
      Left = 399
      Top = 0
      DockPos = 413
      Options = [tboNoRotation]
      Stretch = True
      TabOrder = 6
      Caption = 'Search'
      object TBXSelectSrchType: TTBXSubmenuItem
        Options = [tboDropdownArrow, tboNoRotation]
        Caption = 'Google'
        Hint = ''
      end
      object tbiSearch: TTBXComboBoxItem
        EditCaption = 'Search'
        EditWidth = 150
        Options = [tboNoRotation]
        OnAcceptText = TBXSearchEditAcceptText
        AutoComplete = False
        MaxVisibleItems = 20
        MinListWidth = 150
        Caption = ''
        Hint = ''
        EditCaption = 'Search'
      end
    end
    object FillDates: TTBXToolbar
      Left = 610
      Top = 0
      DefaultDock = TBDock
      DockPos = 643
      TabOrder = 7
      Visible = False
      Caption = 'FillDates'
      object TBControlItem7: TTBControlItem
        Control = Label1
        Caption = ''
        Hint = ''
      end
      object TBControlItem6: TTBControlItem
        Control = DateTimePicker1
        Caption = ''
        Hint = ''
      end
      object TBControlItem8: TTBControlItem
        Control = Label2
        Caption = ''
        Hint = ''
      end
      object TBControlItem9: TTBControlItem
        Control = DateTimePicker2
        Caption = ''
        Hint = ''
      end
      object Label1: TLabel
        Left = 0
        Top = 4
        Width = 42
        Height = 13
        Caption = 'Fill From '
      end
      object Label2: TLabel
        Left = 123
        Top = 4
        Width = 18
        Height = 13
        Caption = ' To '
      end
      object DateTimePicker1: TDateTimePicker
        Left = 42
        Top = 0
        Width = 81
        Height = 21
        Date = 40830.496065717590000000
        Time = 40830.496065717590000000
        TabOrder = 0
        OnChange = DateTimePicker1Change
      end
      object DateTimePicker2: TDateTimePicker
        Left = 141
        Top = 0
        Width = 81
        Height = 21
        Date = 40830.496065717590000000
        Time = 40830.496065717590000000
        TabOrder = 1
        OnChange = DateTimePicker2Change
      end
    end
  end
  object TBDockBottom: TTBXDock
    Left = 0
    Top = 630
    Width = 842
    Height = 9
    PopupMenu = TBXPopupPanels
    Position = dpBottom
  end
  object TBDockLeft: TTBXDock
    Left = 0
    Top = 59
    Width = 413
    Height = 571
    PopupMenu = TBXPopupPanels
    Position = dpLeft
    object ZoomToolBar: TTBXToolbar
      Left = 0
      Top = 0
      DockPos = -6
      Stretch = True
      TabOrder = 0
      OnDockChanging = ZoomToolBarDockChanging
      Caption = 'Zoom'
      object TBZoomIn: TTBXItem
        ImageIndex = 23
        Images = MenusImageList
        MinHeight = 29
        MinWidth = 29
        OnClick = NzoomInClick
        Caption = ''
        Hint = 'Zoom In'
      end
      object TBXSeparatorItem1: TTBXSeparatorItem
        Blank = True
        Size = 3
        Caption = ''
        Hint = ''
      end
      object TBControlItem1: TTBControlItem
        Control = ZSlider
        Caption = ''
        Hint = ''
      end
      object TBXSeparatorItem3: TTBXSeparatorItem
        Blank = True
        Size = 3
        Caption = ''
        Hint = ''
      end
      object TBZoom_out: TTBXItem
        ImageIndex = 24
        Images = MenusImageList
        MinHeight = 29
        MinWidth = 29
        OnClick = NZoomOutClick
        Caption = ''
        Hint = 'Zoom Out'
      end
      object TBXSeparatorItem2: TTBXSeparatorItem
        Blank = True
        Size = 4
        Caption = ''
        Hint = ''
      end
      object TBControlItem2: TTBControlItem
        Control = labZoom
        Caption = ''
        Hint = ''
      end
      object labZoom: TLabel
        Left = 24
        Top = 221
        Width = 14
        Height = 13
        Hint = 'Current Zoom'
        Alignment = taCenter
        Caption = 'z1'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Transparent = True
      end
      object ZSlider: TImage32
        Left = 18
        Top = 32
        Width = 25
        Height = 153
        AutoSize = True
        Bitmap.ResamplerClassName = 'TNearestResampler'
        BitmapAlign = baTopLeft
        Scale = 1.000000000000000000
        ScaleMode = smNormal
        TabOrder = 0
        OnMouseMove = ZSliderMouseMove
        OnMouseUp = ZSliderMouseUp
      end
    end
    object TBSearchWindow: TTBXDockablePanel
      Left = 65
      Top = 0
      DockedWidth = 170
      DockPos = -6
      DockRow = 2
      TabOrder = 1
      Visible = False
      OnClose = TBSearchWindowClose
      Caption = 'Search Results'
      object PanelSearch: TPanel
        Left = 0
        Top = 0
        Width = 170
        Height = 549
        Align = alClient
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object TBXDockForSearch: TTBXDock
          Left = 0
          Top = 0
          Width = 170
          Height = 9
        end
        object ScrollBoxSearchWindow: TScrollBox
          Left = 0
          Top = 9
          Width = 170
          Height = 540
          HorzScrollBar.Visible = False
          VertScrollBar.Smooth = True
          VertScrollBar.Tracking = True
          Align = alClient
          Color = clWhite
          ParentColor = False
          TabOrder = 1
        end
      end
    end
    object TBEditPath: TTBXToolbar
      Left = 0
      Top = 244
      DockPos = 240
      TabOrder = 2
      OnClose = TBEditPathClose
      object TBEditPathDel: TTBXItem
        ImageIndex = 36
        Images = MenusImageList
        OnClick = TBEditPathDelClick
        Caption = ''
        Hint = 'Delete Point'
      end
      object TBEditPathLabelVisible: TTBSubmenuItem
        AutoCheck = True
        Checked = True
        DropdownCombo = True
        ImageIndex = 37
        Images = MenusImageList
        OnClick = TBEditPathLabelClick
        Caption = ''
        Hint = 'Show/Hide Captions'
        object TBEditPathLabelLastOnly: TTBXItem
          AutoCheck = True
          Checked = True
          OnClick = TBEditPathLabelLastOnlyClick
          Caption = 'Show only final distance'
          Hint = 'Show only final distance'
        end
        object TBEditPathLabelShowAzimuth: TTBXItem
          AutoCheck = True
          Checked = True
          OnClick = TBEditPathLabelShowAzimuthClick
          Caption = 'Show azimuth'
          Hint = 'Show azimuth'
        end
      end
      object TBEditMagnetDraw: TTBXItem
        AutoCheck = True
        ImageIndex = 41
        Images = MenusImageList
        OnClick = TBEditMagnetDrawClick
        Caption = ''
        Hint = 'Snap to Existing Markers'
      end
      object tbitmFitEditToScreen: TTBXItem
        ImageIndex = 43
        Images = MenusImageList
        OnClick = tbitmFitEditToScreenClick
        Caption = ''
        Hint = 'Fit to screen'
      end
      object TBEditSelectPolylineRadiusCap1: TTBXLabelItem
        Margin = 2
        Caption = 'Radius'
        Hint = ''
      end
      object TBControlItem4: TTBControlItem
        Control = TBEditSelectPolylineRadius
        Caption = ''
        Hint = ''
      end
      object TBEditSelectPolylineRadiusCap2: TTBXLabelItem
        Margin = 2
        Caption = 'm'
        Hint = ''
      end
      object TBEditPathMarsh: TTBXSubmenuItem
        ImageIndex = 39
        Images = MenusImageList
        Options = [tboDropdownArrow]
        Caption = ''
        Hint = 'Route Calculation'
      end
      object TBEditPathOk: TTBXItem
        FontSettings.Bold = tsTrue
        FontSettings.Color = clNavy
        FontSettings.Name = 'Arial'
        ImageIndex = 38
        Images = MenusImageList
        Options = [tboImageAboveCaption, tboNoRotation, tboSameWidth]
        OnClick = TBEditPathOkClick
        Caption = ''
        Hint = 'Manage Selection'
      end
      object tbitmSaveMark: TTBXSubmenuItem
        DropdownCombo = True
        ImageIndex = 25
        Images = MenusImageList
        OnClick = TBEditPathSaveClick
        Caption = ''
        Hint = 'Save'
        object tbitmSaveMarkAsNew: TTBXItem
          ImageIndex = 25
          OnClick = tbitmSaveMarkAsNewClick
          Caption = 'Save as...'
          Hint = 'Save as...'
        end
      end
      object TBEditSelectPolylineRadius: TSpinEdit
        Left = 0
        Top = 136
        Width = 61
        Height = 22
        MaxValue = 100000
        MinValue = 1
        TabOrder = 0
        Value = 100000
        OnChange = TBEditSelectPolylineRadiusChange
      end
    end
    object tbMergePolygons: TTBXDockablePanel
      Left = 239
      Top = 0
      DockedWidth = 170
      DockPos = 6
      DockRow = 2
      FloatingWidth = 128
      FloatingHeight = 128
      TabOrder = 3
      Visible = False
      OnClose = tbMergePolygonsClose
      Caption = 'Merge Polygons'
      object mmoMergePolyHint: TMemo
        Left = 0
        Top = 0
        Width = 170
        Height = 549
        Align = alClient
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
  object TBDockRight: TTBXDock
    Left = 678
    Top = 59
    Width = 164
    Height = 571
    PopupMenu = TBXPopupPanels
    Position = dpRight
    object TBXSensorsBar: TTBXToolWindow
      Left = 0
      Top = 0
      ClientAreaHeight = 561
      ClientAreaWidth = 160
      DockPos = -6
      PopupMenu = TBXPopupMenuSensors
      Stretch = True
      TabOrder = 0
      Visible = False
      OnVisibleChanged = TBXSensorsBarVisibleChanged
      Caption = 'Sensors'
      object ScrollBox1: TScrollBox
        Left = 0
        Top = 0
        Width = 160
        Height = 561
        Align = alClient
        AutoScroll = False
        AutoSize = True
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        TabOrder = 0
        object TBXDock1: TTBXDock
          Left = 0
          Top = 0
          Width = 160
          Height = 9
        end
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.hlg'
    Filter = 'Selections|*.hlg'
    Left = 161
    Top = 84
  end
  object SaveLink: TSaveDialog
    DefaultExt = 'lnk'
    Filter = 'Shortcut|*.lnk'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 113
    Top = 212
  end
  object TBXPopupMenuSensors: TTBXPopupMenu
    LinkSubitems = NSensors
    Left = 778
    Top = 297
  end
  object OpenSessionDialog: TOpenDialog
    DefaultExt = '*.sls'
    Filter = 
      'All compatible formats (*.kml,*.plt,*.kmz,*.sls,*.hlg,*.gpx,*.jp' +
      'g)|*.kml;*.plt;*.kmz;*.sls;*.hlg;*.gpx;*.jpg|Google KML files (*' +
      '.kml)|*.kml|OziExplorer Track Point File Version 2.1 (*.plt)|*.p' +
      'lt|Google KMZ files (*.kmz)|*.kmz|Download session (*.sls)|*.sls' +
      '|Selection (*.hlg)|*.hlg|GPS Exchange files (*.gpx)|*.gpx|JPEG I' +
      'mage with Exif (*.jpg)|*.jpg'
    Options = [ofAllowMultiSelect, ofEnableSizing]
    Left = 208
    Top = 208
  end
  object PanelsImageList: TTBXImageList
    Height = 24
    Width = 24
    Left = 48
    Top = 176
    PngDIB = {
      1600000089504E470D0A1A0A0000000D49484452000000180000021008060000
      009BBBAEBC0000522D494441547801EC7D07745545D4EE3EE7F69BDB526E7AEF
      2194D021F42ABD0948538A5451401044B0A020A0A2888A8A8882A2A2A0200414
      114541E91D9426BD0502E9E5D6F3BE7D5248484200F9D75BEFFDDE35DF997266
      F69ED953CFB42BD05DFC9A4E5AA386B770220A00585DC1E3ECB6377BD8A1DF51
      09777A0BC2B1783F13E80B54A4BE81E30B6074027A854AACD0158E4D26AC7A0D
      DA71A06FA8D540633A57A379231AD3C4EE71D4A25610F998B47845CCF83822C2
      91607B3954C80001BE1614CA29213E3A9A31B0264DEE9B446D93FC492BE592A7
      878A1A2504D2F0CEB5E89541B528CCAA67A2CF731836DC8E720C9A4D5C3D079E
      FA36ADE647CFF46B4875A37DC9E4A1A78C02B8EAAD64F0845D2B9055E7242DD9
      69C1C806D4A6A62F5E525F30299792320CE021561284A9D101269A33AC11D50A
      D6D3F56BA95450904B1E2623193DB4242A14A4510A941062A6C649B1E4ED69A6
      273A4452988F2C324E09E71B3394A1949FB71E720C5E19DC804872D13FE7AF50
      9E60248BC98B5C4E78120482223F8B8EF69FBC02666914EA6B240FB582C67608
      A529CBE5BC661A8FC0B7AC4A5280D8ABE1D2373AC048215E6A3A7AEA22A59385
      7CFCAC70164992889C2E89EC0E37D9ED760A0FF627BBA4A48DFBAFD03F57B228
      C0A4A4604F15FCCAA2625A6CA6D2290827FC6A849968F9AFA7C8623693AF9F1E
      E271934214C8E17253769E9D0C081A1BCC4C09B13751EBA460DA7EE0045DBD91
      474126375D4C0711A270229293539A41001C2932D0426EF0BD5920922B2D8BF2
      3D3464D022A1480233080DD2B137A44882B80472BB1CE402F32B6939A413B824
      C8A9605AE518C801FFB99A473590B916E499975949272E6752AA42496AF0C829
      70908F0791D5A491894B6E376564E690BF5945572EE5D1FE7F32881485A99389
      E12100B2421EC4C2703C21D48BAC5E069AD02596AC160F3A7B3593361EBA41F9
      0E8944A4CDE97291BFCE41793627F54C8EA082FC1CCACDCEA203474FD0A22DE9
      64D778810CC515D7EED2223A4BF85DBA9E4D0156934C1C560AF737531F14CF5F
      0E5DA68367B2C8E596E8D8B97CCAC8B5515CA007059B24CACECAA06F7E3F4B2E
      651007619CA5A25F490AD88E547C0DBD6F42B80F3DDD398A5877BA88944A257D
      FBCB01FAF1480EA95107F26D0EBA869AD7B38E891A84AAE87A5A1ACD5F738232
      74E184DF37887D4931BD9D812C260F8D92FCBCB4F442CF68F2819844C949B3BE
      394417B25424A07EE4DB9D949665A3FEF5F4543748A05F769FA04D17BCC9A1D0
      82FE2DF1B0A50C0376402AB8A23C6FD4A96860230BB5AFE1459F6D3E493F1E77
      9356A3223B9264B73B282B3B9F1A8610754A20FA68878BD2DD660E3E0BB17F81
      0DC528C7805F80C9D7D0FBFA1995D435C14D4B7E4F239B682295E020B7D3496E
      7B0139F2F3C81B254A61F1A71C9706DEA98C68D88181C2C75A5920162CC359A9
      D94E5ABCDD4EC13A2DBDD13B9E9E6C1C441DFD25F2B79D46A3E749F9C6B062E2
      1C730E5396106C1532803B810927350ECDF6370A9D85E2E323282EAE210505D5
      245B819DEC6E39F1DFC02F1749F60B6379A528EF443462C488294949492D2CB9
      7F556B9790D4AF7DA318A55BA5509EBC984BE7AE5EA74675AB49493E1AE795DD
      CBF7D2A5AD01E1E1E1F5CF9C39B31FB4B84984764B559882FAF5EBBF3A7AF4E8
      57C78E1DFB6A5494CE37222C44E3A5F7A63A317EF468F786F4508BC682B717A9
      9E7B6EE2D059F8B56FDF7E0611B5A40A7EA52B5AC9EBF5EBD7D38E1D3B64BB5A
      6DA6BCBC5052A0B9901DF0100481B66DDB4E191967897FA74F9F66CDC08FBB82
      9797D73C93C9B4DA6834AE79FCF1A957A64F5F963D7DFA27D9CF3DB7247BEAD4
      C5D9CF3EBB28FBC9275FCAB6583C37A954AA95C09720DC0EB86BA5824F8E1123
      1AE63640BB0A50076E2600059654D0FF53F72E01C5ED41BEFBEE3B75DFBE7D63
      1F79E49166BD7AF5EAD9A74F9F9103070E7CEED1471F9DD5A953A72EB56BD7CE
      BB72E5CAA9B4B434D7ED612BB22B7EFDF5D71620F4387E63468D1AF5A2C16078
      DDC7C7679CD56A7DC4CFCFAF8DC562A9A5D7EB833CF0F3F6F60E837BAFEAD5AB
      F7A951A38664369B8F9D3871C25E11E16237C5F8F1E3B7D4AA55AB3388D50061
      5F3050A9D56A147541703A9D028F20D8331C640DEF4430B1FAFAFA76040657AB
      56CD10121272ECE8D1A3B9ECE176882EFC10398546A321AD564B6EF4B30C1027
      060760E2C5603BBB33A3888888A0060D1ACC68DCB8F131D4FA777AF7EECD455A
      6EA4D81F43BC7AF56A2A0C8284510313D6E974845410EBDC932930921345115E
      48766737F6C7FE9911DE0941414196E6CD9B3F09464720E62FBA77EF5E0F01E4
      400AC87F006A6204522114141410CC74EDDA35CACACA2287C3017F858A09DA6C
      36B9FBE494E6E4E4C8EF21007984C18C905FCAE8E8E8EAD01F474B10F0D75F7F
      6D1611E83262EB3C7EFCB83CD6C9C8C820E4874C88C55248BEF0C94C98F08D1B
      370804E414B11F0618C8612011E1E2C58B626E6E6E0B848A52B46CD9320D6DCE
      63C830058A9F1C2833339390E1727E14673213679170AA189C424E31524E376F
      DEA47FFEF98776EDDA45172E5CA0ECEC6C0152388FDF77CA71E3C6FDF1D24B2F
      4D1F3060C06BC1C1C122DA75427124C4849054E2CCBF7EFDBACC8C19701EB088
      F8FDA54B97885B527667704A1888B98494E643BFA9C4C3FDF2CB2FBF0342E128
      054F04040408E7CE9D23B4A83213CE703046D39C41A9A9A932C1B3673106C200
      8C89B2688A8812C40D72850AA9F807A66C66009DECAFBDF6DA5494985094802E
      CC04C92354246279B3874D9B36C9C5B698289724766711B21BC2CAFE217B42EC
      2588EF06DEBB8B1910E49EF3C5175F0C474A36A087AA035108680E08F9230FD7
      4BC7944B0EC79689720AD98C18CB2900618CC80B2444EC0A1894EB42A95DBB76
      31EFBFFFFE99949414F7B66DDBA4AFBFFE5AFAE38F3FA437DF7C537AE59557A4
      D9B3674BAFBEFAAA3473E64C69D2A449D2934F3E290D1F3E5C425BE546917737
      6FDEFC0C6AF66A106F0F94A974B017AAAE5DBB36FEE8A38FD2502ADCBFFDF69B
      B461C30669C18205D23BEFBC233399366D9A3471E24409B5571A32640813CEA9
      57AFDE5E148E77416130100FA8814A95D0AD5BB7873FFDF4D35C66F0D34F3F49
      6FBCF1863463C60C69EAD4A9D2840913DCC3860D7375EEDCF99FB8B8B81454CE
      6741A9156005CAB5D070AB50291E7EF8E1091F7FFCB183C5C4C4116B269CDDB4
      69D33D68F01620D420200ED001F7A5545DBA7479FEA9A79E3A893EE22F34D1DF
      23B69341A92511F900771D5BF8AD5469F0A616D01A8806B4C07FEAC149A05C26
      A1D3D72243EBA0D3EF898A3306E689A844D3070F1E3C139DFE4094770D1AB983
      A8E5CEBB8946459DFE6B68AA47A1187642BF9084F6281CADA717FA0C2D1A402B
      2A533B74FABD51A2FEEBF4757217C82D26B7A42C6F6E39D1CACA9D4F710F8777
      FF75FA8523C3629138309461FCD7E90BFF75FAA837ED010128AFFEBFEEF4258C
      262474FA7BD1DA3ED84E1F832CC7DCB973244C9248688FA640B056A05C7F02B7
      324A2C632B6F716084F78646536B49B76E439561614DA857AF89D4B3E7B046F0
      9A0FB8803BAAAA1870605B4040D4CDD2F345F9F90E9E78BDABD14585492C9E2F
      AA59B366B3C71F9FBBAA4E9DC81E56AB41999929D0E5CBA9D4AC59DDC0F6ED1F
      795AA17044868606550FFFB7F3452121415A9B4D87E1B99ADAB74F22CC278916
      8BA4FE6FBE88E78A183C5C6C83DC6E5701FE1F9A2F7A75F66CE5175F7ED560C3
      0F1B872CFDECF3066FCC7BD3E7D967A72A90AA3BAA2A3D4C7FFE7961C890A111
      8989D59F890B0999ED9B9DD5DF3320B0B73524B4ABAF9F7FBD0E1D3B793FD4A1
      83909C9C6C432DB76FDFBE5D2ACDF18E0CDE7FFF034FCCC40CAA592BE9ADA0E0
      E09E625696D97DE890489E5E7AAD9F5F80D160AC6DF1F2EC62365B7A7B797B77
      F6B5FA253DD4A993679B366D25302CA8DFA0BEA3C29AFCC6BC799A155F7FDDAE
      7172F29775EBD65B80E1620D224121F9F892BBFD4324868490E4746179C585F6
      5E50AA351A6B80DDDEB04666C698B890B04FAAD7ACF5636C7CC27CA3D1540D1E
      6E25085F9162704848426464E4D8B0A0E03E7AA7D35B341A053BE64CB3730BB0
      EAE1C0272DD66CD26F92D7EF3F530666E1D3929B921D1FE502266DD437D32447
      74ACDD46EE0D69D752675EBC70FE90B298FC7BEF2DF40F090D793422226224A6
      1022C573E745C76F5B282F38941C8D9B52565E01E5E4D9C004F3D699799499E7
      A01C1229279F178A24923CCC9253A54BCF3A77F1ADBCDC8C0F5E7E71FA4DA6AD
      983973A611D3699D1312AABDCD0C743ABD8F2088A253A9A24C958672BDAD944B
      02E5632AC78D4912677E01158822650684528E7F2015081ACA768974AE4043C7
      9561F957C5D08CEB62AC477CC301393E1E8D6EF26C8B19328ED768B401589FD1
      A3AD373ADDA4C8C12A87CD68E659282CD0B9C8852547FFF5AB49B16B07A547C6
      90134C780096E756D1D16C159DD1450A827FA45EE7175043A3D74638D2D2B7E6
      5C483D579207C39F58A00F890AEB5DAD66D01C72E505AA44894C4623E9B41A79
      8AC09E9B4FAEFD7B291F72CFAB9644F9583BBB743D838EDA3D29C3B706A9CC3E
      84993E977833FD37FB8953930B4E9DD9FFF3F2FE92CCE089A9ABFD126B058FF2
      F5538F169592BF4EEF21280437156467526E563A89A2A20858E8129490BB8D8E
      61F9EB648181B2551692ACB1E422758178FDC60A3A75F2A55FE6B73ACFF26728
      9F9CBE3EB9561DFFF1FE81FA6E6A4457A1D208F9793964F0F020C1612395D287
      D2726C942369E8E2997F48A5F5A04B3772E8629E404AAC73669C3F2BD9537333
      1439AEB73D0AA405DBDE6F9BC9848BA1A859BF6F0E91EA2F49D09E55EB8C4ABD
      C96CD479786833D2AE1256FA0451E341BC4E938F15A69B36A26B6E3D32DF936E
      5CBF4A6957AF925D6171E5A6657D6B4B4DFFF8C8D1DD37054B43A774FDCF62FA
      A4FCF8AD1EE9B0ED650C19BFFAC3E0086B82D9DBD8D6C74FF3A8D15317E71695
      425A761EDD2820CA16D474E9EADF94E1409DF031514EEE0514DD2D8A7C4BC7DE
      F946EFA61AFFC6C714B905BB851A9FED72A6671ECEBF70F152493D00035ABAA0
      6776DCF00D47036252638DA6BFC42B57B791F68A3F45F834238DD99F6EB8B594
      E9E94905128AE9B5DD58BF5C4681413D841CBB458FA9C74851A58E501B3D3A88
      79862B52C6E55715997B97315D191EEDBE14AA8DDD98F0F027479674FCF9D52C
      FFAF13DDAA77CD52ADC5DDA4A92923A4615F7595DA2E1C2DD59AFFB614346D94
      A479DC2A894F1AA480577B4BE6691B24E5D3EB25FDC41FDDC631AB2FEA5B3D3B
      45E313E387AF53140990F7E9FB9D2138D6FA7054A2DF64ABD59420D023A213A5
      E38CF7CFD4C06B38A9353632282F518C693765FFBD90326F5C23A7C6490A931A
      85C14279E94E926C6EB733EBC6DFCE63BFBF261C5FB7D6969D2A67B6C2A7FF9A
      DAA149FE2F04C5FB4CD1685441925B1245CCB459D50114EBAD412972527AB685
      72D2E3C95B1D497EBA33446216A5BB502FCC447A550DCABE12EE745CB9BC4D38
      FCC374F1E4DA1F6DB9375170107328C1ABEBA268EF105D0B73807F6754E97A46
      93C15FAB562AB5AA2C2157F7195DB15DA6F4EBE914A3E9447AA92EB508FE9B6E
      667E4E3FA3665FB23791B2CFB52AB87AF8F25AE1D80FAF2952771EB11560D119
      848B95506410F5315D8D9698DAD19E6131CDCD0101ED4D9EA624BD07F99875A2
      22539122EC4E5F41D1CA31D4C23B9E5A44ACA69F2E28A555BF24679EDDFBD752
      3A96F2AE22F3D8594C08BA8BE855AE690C568531B18F5748979793AB8D5C3AAD
      C98B29BF76F9E893EB8DBF1AE56AB4E073A9F68C9FA4B9EB3E770F7A7FC60553
      B309CFA8BDA2E5CCAC9CE21DDE68F466A5B17A7F6B64F7575BD61AF3C9CC8091
      2BFE340C5D75C367D0A7873C1B0D1EA031781BEF10FCDE5EA94D412A55C2C000
      55F2F36D9589831A6A74A6BB1A9BDE1B9742DF9C6F8C425B154F615DCA9A4789
      84F7D0B69BAAF07B4FAF31799885ED254FA2A910DEEBD2B9DB03255E141353CA
      FAB5EF298B63DE6AEEAD16B0C84389E6A972D29251F5C8D3A097DD32D0F9F47B
      6F0FDDB4553EEAD9F56232AF90989002390CA5E715EAB73FF56A81DE1B51AB84
      38BFB778E8E88B27EA50B7770F536EC19D8BBEC801EE842F86C752A037DA84DB
      3C791B3DE8EB11F1B7B996B756C9E0C79D27CA872A72F971D771326AEF5CA02A
      65209044F19E0EBA9C5E403FED3E5E44F296B6F5F0698C956C94E45D409E8559
      73EB652953850C4441A26ADE0E8AF17253B0978E726D0E3A7539AD24D8B58C1C
      4CAB49109D89A2BC9554CBCB4656BD54F2BEB4A10C03CED06F47C7D2909A1245
      5B081B9974E4EF65A0002F2389024670D8D7C281F5D8C011E463A620EC810944
      D719E98D4D1E491AFA7142F572222B61C0C4578FAD4E51813E34EEE1A6D420CE
      4F26EE0BE27E9E06F2F704136C646206069D468E7DA0B78982C0A05E5C100DE9
      500FFE4D94323EA90C931206DF3F5583FC408409303A374AA084303F99903F08
      E9B56A762E01DB03918AF8505F4AAE1E51E26E46115E3FA17689BDA41E58CD86
      12C762434CD156AB62FBEDBA4EAD22C6EDEE26BDB6C4A92405252E0FD8509202
      9BC3491A5589556693936F231D32548181AEEC70DB83F776E514D888C552FA55
      9ECD4E7A4DA1484B28767A7327FDF04C4342772CFBDD7BE2A2BC392C00F26728
      156513EBC017CE951B59C4E095C00609A1723826FED09B7B69EBB4C6B25DF86E
      F52AA9678F8729E9C53FC91B65F9FB71F568DDF6BF2823BB8002D06131B8B404
      20438B99D8915A267CE566361800695964D06BA873A378EAB1F01065174874E0
      95645ABDE65B2AC340668987BF878B6A783B291CC396620671A156F2341656D9
      CC9C7CFAEB5C2A5D49CBA6CB48C5991B763A724345A979B75259CCA04444A05B
      A2AEE62AB0B68C8A25D9A0633F112A5B3171F66436E8E48A77312D934EDF70D0
      E19B6ABA81D136BFBB1DB758DEF6866373E0865ACEE4D2E5BCD85BC36A61C85C
      2D1DBCA1A99438FBAD9401BFE458F56E51838D15A24BE3044AE779AF0ADF163A
      5628A2C25785CF5EEFEDA39F2637C6F69FB271C92BB0CB195AE8ABF267950C38
      159DDEF8937E78B6892C7726C545B4F73B3BC9E654A058B34BE5C047A512BD3F
      9938D72BF756F68D4AA9A00D539A9575ACC006E2D9C2D2659F8CF5F4F49C8B45
      E8F28D510581EED6094B2FB9A9A9575EACD2BFEF7CA9299058A5C74A3C94CDB9
      8A3DF198690198F404EE7959F76E189C04DF186029117D08267580CA0744F054
      5ADD0D83CB0870121439258360FE0E6803DC95AA92C1B5A7855C50DAEDC24053
      818F27980381F2032538226502B432AA4A0645BE7740B701ACEC78A401048222
      2013F5794B8A855B0FD823A19728B1C454CA004FD140E90CFD0BAFAF03ACB871
      C8C1FB78580602A3610EC578A019CC638091B0FB439755850CF0261998058F7E
      D009A395CBD04F00ACEC7834011E072601F380F9C060A02DD00FE012A7828E29
      2B7E96C751380D0096804935C42E0FE6752E22AEF530527F3C9E5010D504B893
      E80C3B5E533AF4106024100754CAE01FBC3C09740426230509D09DC0D7C02520
      BC88B02C7F9835704B004E01ECC64D706B982B6600829978F90AB08588E29082
      8ED07B006A6037A0026E57BE450E17A0DB0113503183B4898284E2F9333C3C02
      BC05F8004D81AE0067AE167A19A5C077181C0CC050A017B00CC06C1F3FAB00F2
      A10DBCAC0458DE17A0730C13148544612D542EA28B30B542E44E419795527E56
      FD3804B1AD81A8EAC06B1CB003380982D5A18780910AE63C983703D781122594
      982A3020E62CEB08BCAA0D1880E78130E024187E0DBD3598726A44983F01D620
      F659D04B14BF902DD87AF312C0B193ED209E08C353403CB085883E0316010580
      15840D802FCC8D012360062C0827422F51A52D3388E858292636D82F023F2256
      A98003668EF55AE8679082B344C4F5450311710ADF847D03300D4CBCA0CB4A29
      3FCB3E9849BCF0B4701CCEA780D28A3339140ECB818F812D4414E822AA0F262C
      CE4498A7C06D0B116D032A2EA678C14C4AC4057BB1CA82C1179808F144235587
      607E023800C21274564A3C7480AC4A8B487628F528C70462C9C5FB74C01FA80F
      1098EC853E063852C484696A6197155B6443258F324C10EB4CF8FB14C8059A41
      D61C5B66B213F631C0DF00D3D44197155B64C31D1EFD8ADF21B688242D817D0E
      1007700D8726AB3FF164719D845EC24080E59E1562CE049E84C87E47B3B2B398
      00DC995E4B22D220323F42BF7F15F6D137BE611FAEA8713B05B82B00AE94B7BF
      2A6F478CFED598882956950726785A00463D011DCCF7ACAA62C0191603AA4BE9
      3EC64408536945E3778CCB78DCF7980861EFCC002581CBFB6ED77D8E89AA64C0
      1E801D800D60C54D731A1B9027158E89D058CA958FFD30B8DCB25E02048C86E5
      12629F0F9D07579C079BD1988520254CBC13DCB381FA8001585FCB7979B04310
      47253BCF794CB06DB55871B40FEEBF0229156572325EDCD598089BB5DF6CE03C
      FF878E1CAFFC2DFA056D54C55936A812C85928F956A0F366450C8EE2C5006009
      5253F99848926A610E49775011188C8F5E52636DEC8260969ED5763A986C185B
      0FE1EB0063053CCA2810B5C0612DD004F80CCDC11B68E45AC15C0B4802C2202E
      6EB2612C546E49BA86B3846709FD02E0062642C4EF402F4C0B1B8A0182DC62BE
      02FB16AA604CA4931C5CF9F0EA9602716B91ED02743B50E24784A58C42E355E9
      9828C675BD2B3C6B81324A51387CE10C1F8A17BD806580AC04F979870744D606
      AF572A259739C49D2942D6745CF42105E6F0E05EA250C22EC252664C043B0EFF
      F1F3CE38D4C4713A3543D47BFEC384C9B50B4B5A5740B03A828528B0CA07731E
      CC9B81EB4019A52C632B6541CC556AC919392D7FE362B3648B9FAF6D4E050472
      82D2827CDA08AF3EC8FCF3AEC2AF9E4F602F3726825BF94C6647104FD44A8E89
      6FE6AFFBB6B7E370B3BE8E83A4905C6F22E65CF9EE7A4CC4B42ACC83CF5E5D3B
      D048B64F3B3BFE56A9C87D111EEBF9995FD2439F03C42005CB10FB563077479A
      B0128BBA55780E7305DCDE4711BD095D564AB41D4FC074023803D4018693635F
      7BE8AC52F07844983123CF77FE4B89308702CB81BB1A13C19F9CC90BD950017A
      82F09A52EE5930FB023C26DA8C581E822839728B910F49488980774AA04CC7C4
      F5601C1C1703BB814F819644A4BD8D387FA7E5C23D1DF007EA033C5CD90B7D0C
      50E19808EE77F77DC01E115B449246C13C1BE0940D472A9C30738BDB04FA4700
      B7BC83E0FE0DCCB2E214C886AA1E080449DCDB988869DE3503F60C2636E8EF00
      DFA12485419715DC25187E079E0452817FA730EEA9704CC454F1EEEEC7451CE0
      DF8233AE421ADBB76FB73EFFFCF37DA64F9F3E0B07195E1F3468D0ABFDFAF57B
      F9B1C71E9BF1C4D8B1D39F993265D2B8F1E307757FA46F4272C78E19010FB5BB
      B66F2D7FAB9725C7E5B68CCB679F7DA64C4C4C6C69B55A9FBB72E54AF2C68D1B
      3538AA41972E5D120AB0FD046D3FA9743A953528D05CB77E7D53CBE42609B141
      81BD540AC527DEEF2F7C6FEE1363CBE481589AFAFAF5EBD5616161C330D9BDF4
      8B2FBE68F5C4134F68972E5D2A607FAF1011114175EAD4A1BAF5EA51745C1C39
      3023BF66DB3661EAA20FC555DBB60560527D7288D9F2F6D8850BC34AD32C61B0
      62C50A34F1C2A3389132FB830F3E085CB46811E1C41661E324458D1E4DE6DEBD
      49DDA91379809135369612C0AC71E346640A0CA0D5470E0BDF1CD8AFCE73397B
      052A95B3867CB4886BBCCCA784018835C9CBCB7BF1DB6FBFF5DAB46993101313
      2324242460CB498997C2009AC2E3DB36B59A9C58328F888EA648F8DB6DB709BB
      3233554A8DBA57B4200E1E366BA62C7E3934CE7858706067F2D1A34783415C3E
      48E51718484EA592446C419129173D5C202C190CA431994889CB016C7A3DF904
      879021288876489270531475068D665880C9CCB59A7B10A2FEFDFB77C47AFC84
      B56BD76A70704AF0F7F727358ED17B3011AD9614E7CF93077645E972B24905A6
      6E8D9A0A544AD98FDB60A4740536D7E01CDB0D851207A4B106A7D35B10F34B17
      1A37DC2EE0BC8D01C701DEC769AC81903D22EC417C422B283616D71798480441
      23C4E2400962C22E6C09C2A647393D0EB389F6B56C2D9BF991B3772FA9727369
      B44E2BE9ED8E5FD69C3B3B50C481C2444C01D7C5012BF9FC1F8E2A611F979D34
      CD9A91B3562DB22726624F919D5C387187A3C4841DF7E4B8ADC367E20C1D529B
      83D4F0B8C7A0D745061245E16E05457D4C03FBA1CC232C9288C0BC639F0314C3
      E172C9EF428202C900B1491045F1BBD23AE7AA0BE1F31019BD466B322B9421A0
      2D862005BAFCFCFC921203C7D2E1C88D774A04F454A9C947A3A300C0C3D307B7
      3F58A8CEEEFD5473FF110ADF739082F39C1481FD5E7AEC8BD2AAD50AD1E1D00B
      5F7DF5D53C9CA61BF3EEBBEFEA0E1E3C28A006CBCB2AC817AC1928C884CC4667
      4F1A94162D4A4F0156A3B84975421412323AD36E270709946DC7720CB66565E1
      C8DF88D6ADA53A91513756FFF4D3139CC99371B6F2B9CF3FFFDCF2C3C68D4248
      9F3E25B1F7387E1CF75178920A496631892A15B944919C488D1ECCAE63D79A03
      EFD27120DD21B9B1D7288F1468C75F193D46F23199FEF978C557FD8559B366B5
      6FD5AAD5C2DDBB7747BDB76489E0D7A1430903AFD3A78950EE0DEC02A27C44C0
      0D5DC090221F8B719CF1B905F9949691494A30BF72FD3AD546A1983575AAFBCC
      99D31BDFFCE8C347059C7DF51B366CD887284DDD66CC9D2BDAAB576772320C48
      01729770C04F3E4EA94091C53A835CCA24F8409B45372112971BB147F12C80B8
      268C1D2BF5E8DAD5F1EDEAD5D35E797DEEDB02088B73E6CC198254BCBB362545
      F7D9CA958207926F4091CBC5D94B2D62E6817AC019EF8699C59369B5827CA152
      9C38416E9CE7C45149B9DDC20146F7F56BD78E7DF4F1E23E5F7FB5E22F1E6A10
      DAF960E0736470739CA613B66EDD2A7065E343251C63160D175D052A99332F8F
      2488A1903C51C191239481D38DD1515134E1E90952644464FEAA55AB5E5EBE7C
      F9FCB367CF3A640638D023A2B9E8D6B163C785689302BEFCF24B4287030908F2
      99403484323D09CD018B4344732D3BE071E3CF3F292E3494D02149681C5D88DC
      9A6FBEF9661C0EB15FC1EB5B2A2E2E4EF71CF639AF5BB72E0D6D927BCA9429EE
      860D1B4A38DF27E1ECAB141E1E2E4544464A21111152604888140CBD2EDEA3B7
      9340D0FDCB2FBFD8E7CD9BB7B165CB96D5217639E24CBDA4CBC42944270E731E
      816326F63E568B8D8D35A367A3E0E060818FA972138280E4EBE343F14841D3E4
      646ADFB62DEF85E71D203948F16A6C637F1E31FF0B52E0320052841A226BB71E
      38EFA46DD2A449731CAA1A09E2CD7106CACBED768B7CF6123AF6718A28584A6C
      041325744E7CDAFAE8A1438796EFDCB973154EA572775942FC16D5F22611C47D
      71A8B0338EEBBD8E93A71B5F7FFDF5833878780C07448FC0FEFBB871E316E3CC
      E010883646A5421B529EC65DB9B02C51A03CC2D047D4457E34090A0A6A880DAF
      DC995840A144C430FF6F54384927211F6A23ED2AE0BE9458552894AA7D1D3A74
      E8077FF7C5A44A0693274F2634219FDD2F932A19E0EC1FFD1B2655328068E8DF
      30B92B06FF86C95D33B85F26F7C4E07E98DC33837B65725F0C6E6702BB1F50A6
      9EE00C0FB763154F86C073A56ACD9A3584CF2819685D657FA8F1176028C3044D
      B8DC6CF3680FEFEEAC0E1F3E4C4C0CFD3585A27B64DF1847F5869E0B38003BE0
      01A801B6432B54558AA898380EF81FC12755E16754DDBA8458AF02896BC0F122
      7067C38C60BDA5AA64C031C787C96C1C2B7E82839D3C7992EFD6612337215E30
      E400D7800CA04CEC61AF3A0F4E9D3A3565DFBE7D3FC2F319A4623A0E4410F7CD
      384A4F689F36C1DD132893C1B0DFB5B2C0671C100C3011154423E1330B432589
      6F179070B3C014BC637FD0CAABAA44C4997811C158BE0EE88EF4F4F44EF89686
      110B0A1F7E48F8EC7D0D964A5351150326CA4C58071D220C4D7E66032E089045
      C566C017E05204ADAC922B4359A7AA6DB8E92406A38913C53E5164DBC27C18E0
      CC86F6EF15E74730C83404DA0075804AF301EFEE4B311326CAE2619DEDF745E8
      FF6EA049DDA3958BC7D68EAE2C165595A2CAC295B8B7695BBB73C741DDFEF876
      46EB16258EA50CF7CDA0431D3FF1FBF90F77AFD7A0DA675E5AC1B779C7A66B7E
      79AFD7E0456392CAE4C57D310071C584C75B0E6FD3BEFE9ACCD46BA6DD7F1E22
      312FDB52A34EC2D2B8EAB1934A33B9670645C41F6FDAB2F622D1968FEF05133E
      750D948FEFB982D4CB14111D312722266A40B194EE9901625E42DC89AF4A86D5
      CB83D2B1A9F2E6CD2CBA7EFA38F98746BDFDE984468D98C93D315830BE798D26
      2DEA2C126C79E4C2717A2766605C761C822BE0234D0ACACCB653FACD4C3AF3F7
      61DBA73F9D2C9317CCAC52402C7286DED8FF5ADAEE6503A5ACED53A59BBF4D94
      52378E91CE7F37583AF2E9C3D2AFAFB7957E9AD95C5AF97CD3ABDD1A070D0231
      2D50FE138A1D4B03C439438BC4924787F61F9767B142833CC98EC36F69691974
      FCE465DC16AAA34B59F6F30B56FDF5CCBED399EB40A300B8738703E2E22D99E7
      11CB3B2ADC8F0270DD657646362E2BCCA59CAC3C32EBD57431B384F806109689
      43BFB34A59D0BB7BCED1B952DEBE17A5AC1D4562F971B47461F51069E7C22ED2
      B6F90F49DF3F9F2C7D39ADE9B93A91E63EA05661930DF7F26AC1B8E41A37F6CD
      4C2B4DFCDA4F4FC8C4FF5AD647DABDB0B394F252539679EA9D8897EB0F209612
      995F3F7F81B07519F79B6AC9692B90657EFE7C2AE42AE19EA94C7228D5E75F59
      BA7FF8A17359BF228A4EA09C2A534C4B13175114BDCC1EA4568A7225E20CCDCE
      CA2511F343972EDF9489CFFEFCC03320BE15542B240E77790D877502F17219CA
      99AAC47597D938F3710315092702E9DAF54C2CC0E8CE337194967F97A1D750CE
      394359E69CA1EB21F3552FB5B8A70C5576ACEBAF1C3DA849E7A62D923EFBE730
      4FA17960A7B21232B7913D0FB35928E7F938B69A95914B792E4A9DB91C323F9B
      C562B9BBA208F9187EFB6CD84FB9288A27568F90F62EED27A51615C5A3A8A19B
      66B7927E98D1542A157325C2DCB5923DB778EC9317767D392C202AC0585DAF94
      E8E8D1B314E063A434C85DC07459BA9DCECF5B71806B28CBBCD20CBD13578FE4
      44DF2E7FAF1A769D657E60714F69E5738DA45F66B7BCBF4A540927AF56B5FCFA
      EFFDB4EFF5DDEF7546C3D542FA7C72C33B56A24AE8DCD1D9AB51BC7797D52FB7
      3ABCFAA5E6655AC53B86BAC797DC9E344C0836764238B9C985FEC0950E1419D0
      FE9D126811EA7E318D5142B9B6A9F8D53DE9A5689665504CA59851B1C77BB517
      D3815EA6B12326C4C00B59C1EC6716947E2BC803D0C35C8815A4677B45FE6537
      3970E1432C7100B142A70A9F06B8D6029A014D81188019572CD2625AD0CBA600
      A12A506EB8A9806A000FD7EB438F0028B51F8E7CB1E10E2864004EC57EF035A9
      C45A5AF017AB96272F5DF1C92373E9936726ABE63C575FD9AC73A0145ADDC369
      0C2487C0459953A081A858178AC397E8453445DC4C59FDFBEFBF1FB869D3A667
      B166F91EE6B1578487872F0C88F07BCE1C651CA40D5536577A0AA139CA4C9556
      A3D387EBA2C31A51CBCE8D2FB7EFA9CDF48807C1408019422BAF44DC7235A1FB
      D56ECB719142537C16E19B2E4C83F30838A7EFA0D305C76967F6EF74B060B71C
      D2ACB0A0875393DBEC349AC30D3D1AA89B4FAB7DA959DFE053B156D943E94751
      09E49B2959C6F2E58438B08C836C6E191E7C53B7E04D76094DA9E30CE94503E9
      15E84271F03FCF954B57E8020EC385E8DB85746ED1D7386C0E26C947E24EC280
      D23CD8CC375366D886D853F0E12B13C65CB57CF562802188120C3528521B4B2A
      9C0DD7887C56594D2A6C9F51838956D051B8104BC18A70DC911DE581EFE52EB8
      9972216EA67C06F71246A3748ACC806FA66C8EB9673FCC1F97BB99527062225C
      5452A62B9D72DD39B8710027A9717EDFA034522845519C5493942E1516A9045E
      221330E5ACC0CD9461D0DB61C6DE0B37531EE49B296F26FC1EDFB5B29B297D95
      01D4D0A339052883911215A9DD384DE70EA5669E6DC9DBE02313C74A0633E059
      79BEAA51BE997265DB6F162205FE22164737C2C0131B741E8BA2EC19B74ACAD7
      5FF2128B9A34E48F7BACAD4A7F0A548492AF18485E9295E8266E7AC8C2850158
      EFC1358B84D8F247BA7C3B25EE7F2C2EB6928869FABF5FBA3CA317D607DC98D2
      E7A575395658AC20CE742C56908E3C285219879BEB75E4A70AA404734D0CC804
      E285A11F7FFC91F6ECD953128E2388084B491FD47E1D7A36F7C912D603D66185
      C317A5A073400537538607879331C340972F5CA0822B763A70FA30067C2EF922
      495E9D2A222A5FDA00A2B2C23D8F5761C867068426DBF1DA148B0E2B4D569480
      06CC84C5853A527233E5CF9B36E3E2770D299DD8F426E25A6A0C064080B09C22
      334258AC029B09533EF2CD94FF4C39F5164AD2C24206F0899B290BB051E05DA4
      64066EA68CC202EABFBA99122459B9F85106EDDAB50BC0DCDCC79855598BA663
      1D96E3D7E166CA75B899721DEE1459879B29D7E166CA753367CE5C3769D2A475
      B89972DDF0E1C3D7611E696DAF5EBDD6A23E7C8C959269205A1BA858E192AA78
      AC947FB16BD7AEB5B838721D6EA65C879B29D7E1664A99096EA65C873B1ED7A1
      F6AE1B3264C8DA5EBD7AADC4A2D27C148851A0D81A08064AA4C37920C1A18CC2
      CD94C9B899722533C0CD94EB3077B76EC68C19EB7033E53A4CA7ADC5FAE7F758
      BC588CF6EB4554D48711B806600244E0369A450D93FCE2D643C42A53374C3CAD
      61313171C49A097F83BD16F3B1A630025E5B125110C0D399D04AA9129A6C2846
      A9F74546056EA67C044B5D8B7079E1FB98E67F1EB1ED8577D5815BB185A58C2A
      A6075D40112D271E14AFC29A080F72C05142047413FC1E844E15BC1764F762FF
      B2A5F0512A23E050D40BC154A8EED75E8A5121E7427277F56CFCF9B1241FB5F8
      A8AF56D1DAA8168D82249C744AF4B55312D67CD0252CE376228ADB1D2AB3575B
      72D414D7E7A991757D342F350FD2B7ABEBAB0F8CF3D25A42CDEA506FADA2A942
      A09A8D063C7DF9F7CFE75F284D4351DA529939E8FD7DBEA17AF1EDFE31E6891D
      23CD81119E5AC1DB43E5F2D2ABDC7E06B51864D218028DAA1A289F0FD57B647C
      5AF3C7261DD9F2D95B72DE96CD830A38C4BFFD87D6A275CF1C5ECD6B501D7F93
      03753FB7C0E17669D0CAB9211F1BC26894A2C26A50B98C1A45905621CC3F9556
      9005E7EF01AA320FACAFFFD2637CBD902F7AC6FB2BED4E77BECD293914D889A4
      14053117F70A61D3882428483469952A4F9D529D99EFD21EB894B3FB7A4E7EAF
      49AD232EDE31054153D7A8E37CF48F3609B6E8B0AF370BB1772895825BAD1014
      0E97E4C62734F680A06BC0382133DF69D7E020B341A370F89B344969E9795D91
      820FEE9807D98DFB04B68FF59DDA32CCC780FD180588B51B5B2A4889656BC29E
      68F44CB8C1051FFE9083E4262C620B82562588B83D487333CF9E3764E2B41F90
      2FE05399D288DE5E5A9545A9101C2ADCD6A3529080D80BD87D22A94551500924
      405C12EF7B811F41056A9CB242BF62E8BEAD47FCEE98026AD2C7AF69A8CF6375
      03CD0AFC17880312007150458C4591900EF465282B22F244AB1495B8FF085708
      406412A92FDFCC4FCBBD99B5FECE0C6A7753C604981F490EF5F6847CED60C29B
      894115BBED21234E38122280A5E8800C6D4EB74BAB5428721D6ECDD96B397FBB
      33B356DD91418B5EC30B2EB9DC0D9283BD927C0D1AE401B939E64800149820F6
      4E8CD8F82F549C6EC98D84881A95427B3EB340BC7839FDC715F3267E0FA9713C
      2AC66F533B398E5FCF59FED33F3C0322E990C90220017CD217291104480ABA9C
      C1FCA72FAA6CBB4B73E65ACE55776EEECF470E6CCBBD633165B6F959996797EE
      3A7623D4A28DEC5D2D9037E714A0B822EE50F2E701FE800442F250899A7CA7A4
      DF7B31CB967E2DFD7BBDD3FE3B87BFA38868D482487776DAC2ECCC9B75F6A4E1
      EE2B954E1D62D6A9354A14279451441DF559E0B1A3FE4A8E43BFED6C4641EAA5
      1B29FA82FCD7A70E6D768119C8B26443393CFE462465DF58846997B6A4379360
      F4921223A22ED40D0F70C6FB998282F03F1E1A94D13C64C2D52C5BC18D8CBCF3
      AAEC9CB566B7E393A9439A1C2FA65731833E5323293F7B11D972DA928719ED80
      8F543D32F664B7B0A0370A5CC2C1CB92D8081BC91254225A088C208D6ED7298B
      E4DC89EB45F63F3BA409AFAB15D3AF40EFF77C04B51BB289927B48D476B024F6
      7EC65D63FAD2E3D33EDDF6F8EBCBFE2CF9384FF962AB76E967BF1B172DFB5D3F
      6FE91F8A0A28C94E6553D07D1CC4727311655E6B4B3ADC4F61B64AD5136B9FEA
      1C5FED352F85E28BC98393EF7A124AA68EC7AD5234F0C508BA761EC4AFB725B5
      8E44BD49AA1E5FE36497F86AAF5B14CA2F270F6E7CCFC441BF48F59E12435DC6
      FE4CC93D256ADA5B121F1AEAAE39E9BD13D33EF97D589336BDB445BEEE4B13E9
      B15989F8727897ECB96DB0B99104B30F55AF5EEF54E76A355FB328555FFDB1F9
      BB7F1173DEDA6FF2E9828FB3C65C1415165FA956629D635DAAD598F3E7CA0FBE
      9CF258E3FCFB8A76A9400ACF76839C68C46AAA7406DF9A11317F778C8A46CC95
      2B3E9EF7F4BF8A79310FB9140D7A7F731794E9C1A11AF5160F51F874CAE0E4BC
      620FFF562F3BB2BB7DA075BFD4CB0CBC4A594AE815332A7E77AFF612429CC9A5
      2CF298B39818BBC3ECF7DF7C114B42168D6C20FA6FBEA8481025DF684A6CF774
      B323BE8F69D8B0615DD85C1E026EF28F2DE39C2BDB3CC8401E7D0DE4F74644EF
      9AB20B3FB01D54AEC06C56E06BB2D9D287C3D3315741D8A5198BCDDD291D3B76
      3CD1B265CB13351A269E906A169C3816BFE784A2B6E384AA9EFB84BB66DE89BC
      EA374E508D82132D6BB739D1B05AA31335126B9CC0BEE1E39819F80BF31709D8
      37FFC5F179FD273003115BD26DF8AB0D5C80282744DEA9BC6CD9B2D823478E18
      AE9FBB61B8B1353B365A134FE27643ACFD8ACBE04E2383718F6F6C942281FCA4
      20DABFFB40ECDEBD7B63376DDA948CF93815136DD1A2C53C6CF51D03B3BACC7C
      111CE4BFE368DBB6ED656CCE6889ED0C2DEBD5AC7F99E78B7CE22D9715A77481
      8A144B4BDF689FCBC5F345D89A128B6B794FE01F50BC31FDC024781646AC70BE
      88DF622842984362A30C25FECB88E78B2C0A6FA2E3EA58EF2E1E5B02BC03738A
      E78BD813CF17B18EE907D6F8FF428AF340E27F32F9FBA5976E60BE68C010C20F
      473168FFFEFD8143870EDDC21352D82E1DD8C8AFD109D7099C2EECE6B3C5C7CF
      2727415793BE7CE7AB2E1005FFFFC40DECB2ED82D8DFE0C881042B79BEE800AE
      82146193E78B3019BB0166C2540E61DEE104B67DE6E0A33B07332F2778BEE8D1
      DE8F9E08B006E6B8AE101DF8F930610A2105194A818181DB81144C856EC70657
      2621A378BEA830296835CD982FC24CCBBFEEC1983A76D6AEFDEEA16FBBA185D0
      700AD88DFFC9A400FF2F64C13CC4DB3C6D3366CC9814CCA4A4601A2105132029
      D8A69B823D2D29F8D3A314EC4E4E89888848C10C630A8A640AB665710A52B0EF
      280563C914944C1EB8325D0C63592B05A4E2BFF9A242B1235F6F09A68CA5C4F9
      BFF9225914B706BF6C4527CF5A09EED75E4AE48515AD84622943294FA83015FB
      BB0B3F6553508A7E192313E2D4B0CE2F4A9BD97E071416A9D21E164971A5AD6C
      C6D8C8E0C76B6766E1D63A9A595E28E2D7B75041D8B20C0A3D1C9343702C0110
      E7541AE0567E1DCD8CCF64F82925C26398382C13C15B0C6E118F07B1D28ABB3A
      EEA9AAC1B121501F88002A5A47E3B0E598B0DF12DC3E2EFA74C52793E77D3B67
      619755CDBEABFD55E8D791CB8DEFF97D2E0C84C8BC000D50F13A5A1145114992
      8A81C9F007B38EC685A108B744048EE844D06F3FA07534D0635586012FA9A0B3
      C017959B1ED83ADABAC09437985366BFAC1426FE40D6D136F488619A5CBAE471
      D1DFCD8FAD63E27C648C974A70A2455E5A51D85414A98E25795C847D5176871D
      3B5D5C64517B52F1B84881BFD7E5CE1EE104C857853EBC390603F3FAFCDC772C
      98941D17616E491E1761C1145FB68587DF4AAFA3ADBEBCB9CBEA4BBF7409FC9F
      5A47438C64F53FB68E3635647CCAACF01752EE7D1D2D70C6779A6FE78C7E90EB
      6807C6EC9F824C7EB1B0A221E1D3BC9FFB70F5EAD5BB70A9ADC4832F2C17CAEB
      939CE13C94FC79E366A2435847BB848912519EA9432892D7D110461E3463742D
      E7DD17CD97F3AC2F7F23147043267BE4C7835A47635AC528C3001BE23371C2F7
      751C0F9B89C1942F966D051EABF21A2717630CA8E4187285841FB9C4F17091DD
      A14BBC0A883FA4BA564CBC52FDC1AFA3312B6EAE0B1B28B93DC7974FF23DAFA3
      4DDE5AB7A8E1946930D9B2286652E87AEFE3A252112C2451D19399B07BA167B9
      29C700B8E275B4527E3808625F2EE682FCA2A207072EED3E4AA80502076527EE
      26CBBFAF905699E65A0E5CD18309A216A0E20832D84FA11B9BFE1D7047C2BFBA
      C3E86E526042141780514F4007F33DA9BB61701214B903594A3872002675804A
      677AE1A78CBA1B069711E2BEEF30AA92016E72C80583FBBEC3A84A0620CE6A07
      1E3680951D8F34802FC2A8F00E237E578C0A1940C6D140E90CFD0B01AE03ACF2
      F1F8DF7AAF23EE70E1320F09D03F7870F1EC08FD5FDDEB58D2E180787310FB0D
      3A962528136B96AFC0FE1C507CAF6307982F01BB8168E076E50B8773C005C00A
      C89115612010D540FF0D1825CC989175A73B8CE0271ED002659482E4A563031C
      8702BD806580ECC80C46C1F20C88C7402FA750A2DAC07125A0072E005C54EFE9
      5EC72710682EC0CC6A43DF076602F46275DFF73A2A8B28D484BE0B60F5321E6F
      025C9154D02380DAC8933FA0B702344020D646B742AFF20E23390FE091958B1F
      4023E067882511FA53403CB085883E03160105C05DDF6124C233ABD378304168
      B4038FB6800DB8083C907B1D3F06A1F1C04AE065604F6AE6CB47A0AF00F8767D
      CE5418498F4728B01CE0305BE82EEF75FC101E9BA0B87640E6EE85B913F00190
      0F64C2DD049D55161E5CDEF90EA368B4B487607F02B8F3BD8E209A0E4F8F023F
      805813D87F0074B0333133CC5930DFD71D46C5794020C2C91E0D42DBC0642110
      033333CE85594E815A7D34076E9F02B9403314042574BE286927F431C0DF00D3
      D44197155B64033FC06411F438C01F3801380027208BE9F293D5ED302F01E600
      71800F50ACFE8481C575127AC50CF0825372028C1E8659058400D14089982077
      1BECEF00FFEA0E234E99002295AAB08F2ABED7B1D20055BCE0D478604ED4C480
      5F0F80DDA0DD59714CEFE48353E1A351AB5B5A7D7C9E8E8C8C7C9D810D6493B0
      A0D10601ADC01D69DCE9A588EFDF087CD24EECD6BDFBDBB89563E2E28F3E1AB4
      78F1E241AFCD9DFB748FEEDDE7E3DD64F889BA13934A1920EAFEF8567BF2C9B1
      6387CC9D332776C0C081E6264D9BEA31C5ACEFD7BFBF090CA3C73DF5D4A34181
      81E3C024084C1004CFDB54650CB47A0F8FF68865CFC183075BC3232214986210
      301B2F83CD61E1E18AC7F08EF7E261B76D07D0D500E554850C3823F15DD61E81
      AD4806F6CCA0B12EECB18A0960E38C28404422FE41D807DF73ED11C65CFCB2B4
      5E110301F30EC6F0B0B088A8E8685C0DA528EDBF8C19FB64282A325215111E1E
      CA61F0B29C982A6400992A30558F82A281B15C18D02952D87282BF8FE333B26A
      78E49894F3CC8E45BE6F69F06CC205185D70FE38109FB2D874034AB75E979878
      F2049FAD2EAC9B9D3F73F6ECB7F8D44D2F79596428C791DDC1C01B227AEDED05
      0B1E79E8A187F4480AFB63F0EB6248769B4DDABC7973DE53E3C67D87A5B24960
      9856FCB258BF3D50B1BB1A1FDB5D7AF6E8316BC6CB2FE3CE9728881B5BF58ADF
      42476CA533A74F3BB15FF8F4CA55AB5EC4C7F81A38736308ED96AA8C01FBC0FE
      54EF9143870C19357EFC78AC19052904512E4D7CFD90840B95DCEFBEF3CEE58F
      972C590C317D8000E5620F37BA1303484A080A0C0878FA99679E198C754E4FA3
      C924FBC79481B4FCF3E599B3E7CCFE122B51AF433417404C02CA29394039D75B
      0E7C0554F5DA49496FCC9F3FBF59A3C68DB5E04A870E1EB42355BBB7EFD83111
      6BA0FBE0DD0554A8AA62C08174F83BB901D834FFCAB4E9D3FD519BE9BDF7DEBB
      897B5C5EC3F2E287F09003FC2BC5152FA67EBD7A3FEFDDB3A7E0D8B16376AC75
      EEC6CA1F8F002BAA47F7C58CEFFA7A79D1871F66AC5AB9323B3424E44388CAEB
      BE2855120837CCE93A8F78FCF17353264FBE8A35CEA1F05761E306F7FB52B89F
      4A55BD75AB567B3A75ECF81726A39A808A0278608AF32128363A7A7D5C4CCCAF
      68D8A24059001EA8B26A359A15C06A50F5071EB8B28022D7D84FA17B030F5C69
      41F11160105032B082F9812A66724FC4ABAA285C7AB4E873BDD02F04E37EB500
      C09FCD70F341AD668677A451E94B542401C55181BE40A7D36A7D2C6673184619
      D10C2CAF87A339F7E67760526987C4B2AB90011347401513C14D7135DAB66B57
      173BF7635F9E312314ED7FE8A4891363DAC30DEF6A6184E1CD7E390C13BC1D15
      32400011B13361D4903068E0C0F009E3C71BBAF7E8A14C6ED24481FF835574ED
      D64D8933081E383511E6EFE79708BF66B44D8ADB89B3BD1C030C3FB852E1FA3A
      7D70DB366D8230AAD3607421A0F7E1934204F9139B23A3A284EEDDBAA9D1A506
      6280108248A9392C132D8D720C504B05C446035907A2D5D4604B837CAF1A6229
      CF5BE39D7C300B994C01818142EB366DD4E8EE02E0AEE5B0A589B359C98FD280
      2CB9E4683024D487868509C80799306257E20D7E6437D46A4A53867867C50F8E
      CC4E8C4F96B49E11D8CB7C0E1E1917A16F2C9702747FF25E58649E02A5485E43
      80C772EAD0A57C63BF65A99D67FE2E0CBCA24BEC20A93C1AC09319A80E740646
      01EDCA650C92CAE34F1D86E8C118E8EA58DEB7339AB5E16AE28B6BAFF4B891E3
      F4C4FE24D266FCB5253FEDDC4752EEF585640CFA09847701C7804D402935728F
      4EAC374A69341A2DD82FD41EBB7386A1531F814E7E2456394682D8C8219F9EFE
      3C7AFAA14351D30E1E1AB3F4EF0F962D5F31A27AF5EA1D380C32BA9C444A512F
      3442BE2C772D6A6CE2C0810307FCF9E79FC3AF5FBF3E12E39E918F7C746A854C
      1C0C3EDF7AFE45DCFC367CF0638F0DC0C749758854CB1F148554AA7822260AF4
      5A96F0F0F0E467264D7AF4E0810323FA2F3ABE9C8933B6FD9D3AE9F0E1C323A6
      3EFBEC639111114D117B4F0E5305D932AF05144B159A045FEC6369DDF099B51F
      853FBBEF5024C4B2E5C8B5C967CF9E1DF1CE82778642346DBD3C3DF9FF32F97B
      4D2843A12A0B8A255FE4A951F6F96AA466E84F7B029FDE71F0BBED67A762756A
      E42F9B370F4705EB8DA62202F541CB7EABA257F1FBE13B87D0E3DB7F1087FCB2
      B5DBB8B7A660DFD7080C5B4660F7CE90F0F0F0C658D632552D9A917B5434724F
      2720A884CBC83DC1B0CF07D6D1885DEB35ED67376DDEAC59AFF52929C37177E0
      F04E9D3AF545210843C6F2774115A22924BE4E263672CFEDFA521ABC39049968
      C270BE193E06877DF0FEFBC3B0B0DD0EB1BFCB8C2D4C412F30F8002866B00CE6
      4E9C22B9D8E2DF9B51E112060E18F0E8E851A306A312D646ECF5F72E7B543410
      2E575970EDAB0AE3D3E026C9C97D3136EA8F221C09D9AB11812AC4031F77A994
      682E7C22C3C3BB454544F484D91F2953DE65D8BBF2C695D482D6B303D019C479
      5C5A2EA57745A9124F2C0A03DEB502DA0226E08133D080683C500DD00202F040
      15C79899307136DF15F1BBF1C8FD83124D8206FDB106154C07986136C14D8FD2
      A404A74A5353290364248F8B54289216B3C9148926B90ECE5B36445F5D0F152F
      11FD6F00FC681C3DBE08A4E13B9AA1788F04E6019380FE402B00A745C0FE7685
      801C6B795C844A55AD59F3E6713874E8875184A555AB56E61AD5AB7BE5690222
      4F470CEFE33404752151591D732501E86BB96EF0C0389C88E086750818CA2924
      FB8EE3A26B7E6D13CE860F1EE4E9175C4BE5CCF2147253778FEE9A243CD1BD2E
      15A388E880727D32AA3FC75E0BD14474EED429BAFF80015A5C9CCA779CF27DB4
      F4C286F47ABF9CB225414454375875B269AD28FFC4A8C040855A671344052EF4
      2ECC8EDDC7AFC83CCAE50102563A2E1AB7F24AE31D67F2E351EBA86FCB44AA5E
      A3469CC96810C965D7BB5D0E25A60064A2A51FE51840FE2244546E5C3469D5E5
      FAFBCFE74771E0DE2D12206E6C9CC7F607341B84A362F8830717EE8C7117469F
      3D15A11C838AC645D3BFBF92B4FD746E1C87E9DD229EB522081867E1003A6205
      8772C4E1862D37FC2C85DBC7454B0F8A893F9FC8AB055254963861B25CE2FB65
      293B3BC7452A7D8EA8543B31612231B9E23C50B0A53410191EFC72E5B11ED2B5
      6AB1F79A2A09190FE2856261BF7C8506A7D485CB9BF3709374766E4181526FCE
      11152ADC465D98906206025706046A021CA38FEAA53203EAFE4998A8B33C6DD2
      6BAAFBFBFA28073D94C44C51D40B03736632718C95A46B69379C9F7CFBCB4687
      253A9794BA4864CE65D062B424FC1454776433E8038056307705BA90DEDA4252
      68F5AE82CCBCDE2DE28C1AB506B32E22C2163270E37C386F665AB9F6A7B33F1F
      BD213A3D028DA4D4FA224378F8525CD14092BE6406D3D8045C050C00ABCCD1DD
      EBA96BC684286CF9B94A4172A9341AEEDF458E3C39F18FAB4BD6EE725FC874AA
      9C2A53061CBF05F7EF4954AC44E03F8143C069E00F963574E21AE82F1B0A1F26
      EC5597946A9D5D729B32B37232D4F84ED378E088CB8573678E6D399611979195
      ED907252BFD61C9AF7ADFDCCD67CA4CA5D1894F2A0A702B2E214746553FDF840
      D64A80BC8019221104C9E9748892D3A63D73E6FCE97D171DB199995912FDB5EA
      7DC5CEF91BEC69A7F331282E268E306555490ACA3A17DAB8C871C9506A0C79AB
      567D71D6145EA72E4A94147971F967C78EAFDB8333FA0598F1AA943853A93405
      FCB2188B576FDB56A030266B14A4ED1FF8CF777B7EFAEA1F5CF87F065B7E0AEE
      147B0E5FAE26B363697CF0FD9E2D92C694EC12540589191B56DD3CB93D033BA6
      D2107B1B88CB95AAB4FFDBCD7714D1FBDFEFDD8292D192DC4EB7F2DCAFF3739D
      DB434E68340AECC7CB84689CC8D8FB6700E2E7109B96C43F5BD66BC28EB732AE
      04065A91F90AC43E0F0C58F65532E09ADC0234060015A97438CE470DBF0EC226
      2CB534825D61B3DBB7A3A9C880999940AB5C310316536B78E1E6C21F3AAB4C3C
      D683F06FD05909787800F5016EBF7641E7E9CC2A19C05F2935728F066D13132B
      E5281BD94D03533C500DD002EC06EDC12911A49809136733AC55ABAA62C1FD33
      7F90A39353A9263F333113DF6E949B8FDBF60581941AF07270CB5009231C1E67
      F957F81699CAC479546DC080D78A418055A5D6D2D8279F228C67E463B72E8454
      487854A216BEB3E0D65D6AA5FD1411071DAD978F8F4F2C4E4E042563629CEF54
      632657AFA10145ECEC6855993E060AF22E5BD6D12312FA0979C2844FB754284B
      C8A3C27191CBE9249C0FC7558B16C048017E160A054270435F882FFE7ADDC740
      56935676F331EAE4389713111A33EEBDCACC176127AC804F261C7A8650106555
      71B44AE52033962972218641251696E0720C90CC0AC7454815A94484C6D53693
      A74CA33163C652604830BDFCFCB3E86F0A3B7F2E00689F0834087F7B803E48A8
      7054C1AB7EA66A0909519846D3E1639BE72EE440BF6FDBDA1517F05087871E22
      1DFE301E9D28B56ED5825AB46841B8DE43D65BB76E4D6DDAB421B7424D7F6EDB
      5A3E93D1043067160917CF32F34538684E0AA59A9E7F7E1AFF77887C6BF12B33
      E7E03F1870A7911BD70D009C0294389A3E7D3A044515A6808B6785F345DBB6EF
      ECDABC6953C2520B190D26CC7A29A87DABE694DCA83EB568964C6D919A36B0D7
      AF9B84C53B2D6DFBE3CFF28B4428662232D4846F8106F83781600CD7159814E1
      6F057AEBADB716E15F05E4D835C2D5992C0ADCE1225F7383C281C1805336737E
      CD9D3B9770C74BF914148988476C5C007CF055AFC25D449C2AC2DE78390F701D
      14611686B89CE32218C254A72CFF66CD9AC9F2C7DF1A20057AC27F21944F010B
      0E31E0195F232A59B5DE0F3F1C85F9512D17D585EFBFBF68DAB4693463C60CAA
      857F3961C2B8308683C8401F211706D6DF78E38D8A53C03ED1537146E3CF1ADC
      F95890D3E1BF408C11E1E122EE28EA8AB3525417B745436C722C5954FC473C9C
      1206DB31D727FF9F4BA52960269029E705AFDDF8554F4CAC8BBBDFBD0E1E3AF4
      31E7C1D4E7A657590F66CF794D4E41A9BAC864CB82331CB3BA7AE441DC237DFB
      267A7A792D2B2E7EDCDE88B85F4AC01F8B71D1E4F955160DE72122271767CEE4
      3B32607608A8C2E7AA35B15AB5463D7AF6FC168B73F27F8280B95C6A9818FBAB
      086AFC494945EE65DC4048C467EBBF982F2A43AEBC859B6EF407DA07335F549E
      BEECF2DF7C912C862A1E5CDA0CF0D30A680BFC375F04214085180CAA59E1E15E
      EFF8F824BDE7E9D9F36D1F9FA1737C7C86BC6834F69CACD5D619AE54E29F5988
      3FFCE0BB6255DC7D97791B171626FEF8C61B5EDF8C1BD7B0439B3623EA75EDFA
      6CDD61C39E6A386EDCB0A64F3D35ACE9F0E1E31B74EB36A5619D3A239EB65A1B
      BDA0567B872A71934E192A8596720CE28282544B5E7925AE61E3C623629A369D
      1ADCB3E78098C71EAB9FF0C823A135BA75B32675ED6A6DD0A74F70D3A143EBB5
      1A3DBA7FC7A143A7766CD366E4FCDAB513633D3DD585646F3DCB30883699544B
      FAF6AD9564368F56D9EDDD307A8AD67A7A1A0D9E9EA4F3F070A06D29C010BE40
      A7D73B2C70F3090E3604D7AD1B15D7BD7BD7165DBB8EF969FAF47A7BDF7E9BC7
      AF251C94C5A650954A313B22222E5AAB7D14D7BAD577E4E498D14FAA44A53217
      B7425F2A70BBAF2AB4DA1C7414126ECF3578B8DD7E98D6F113888C684E2C1AA3
      B1B687D5AAC0C0C61EEFEF7FE0D8D5AB4EA68DF7AC11BD6DB5FAB56EDA744468
      CB96ED9456AB294F140D0A954ACACFC8388E3F4ADBA9898E4E57A9D5F2680A5F
      38A2D26E57E79E3DEB8FFF67AA265CBA146CB2D9242C6AE6B995CADFF71F38F0
      418B6FBEB9C094651105E1FF6CF05740F53CA3A31BE1D355EFC0048764B7E3BA
      205185C352C1593B76844A19192A83D1E86278797B3B3C7C7D7315919167533D
      3DB79EBA7CE5A03D372FD79199A9715CBC58479F9DDD381C13EACC4016D108F4
      28A14141CDD06A7AE27FB8708F932DD5AEC5BD875AADC960B59AED972FD7BBB4
      76AD44DDBAFDED151555325EC7362D973A24247D43EAD5DD41265396974A5517
      E14D1E2E5793F11E1EDB9EB6D92E2B2D4AA5222A20201893A0D16ECCCA38886E
      9CBD79F3BBEB7A7D52B2C1900CA6164F1F1F8B949A5AFF464A0AA97AF4F8DB18
      162633E19E0CDFCAD2E18C8CB4DD6969975B070585A317F2532A959181DEDE61
      96CCCC6BB83C4950983D3C82152E97C5999323397273CFEF3E7E7CFBCFF9F919
      81A1A1AA280F8F060A22B3A7C96429C8CBABEFDAB94BC8D36AFFC29596982ACA
      974EFFF38FFBE2A54B993B6DB67F1A190CA7B067CB4770B98C98DB0847E6EF27
      244BBBA17EFDA1C7BB75FBEDF48001DB8EF4E933FDF1A8288C587C129F183468
      C4316CACBBFEDE7BFB6F2E5870FAE63BEF9CCE5CBA745FEEAE5D1F5D3D7B7642
      E975345F9DCE734BB3664F9DEAD061EBB156ADB66EA8516382A752A9273C74EB
      6BD51A73B875EBAD7F75EEBC7573EBD64F46E874F8F72C83BC8EF6D2F8F1A34F
      2C5AB4F8EADCB9FBAFCE9C793A75F6ECD3694B96ECBBF0FDF78B663EFDF498E2
      753403886DAC5367F091E6CD7F3BD4B8F1B6F50909CF82B607792A14DA35B1B1
      C377D7AFFFFBBE66CDB6FD5ABFFEE4A7341AFC519EA6641D6DC12BAF3C710A4C
      CE4D9BB6FFEC534F9D3E3D7AF4E9C32347ED59DCACD9AC8E9E9EB13C30F05328
      746B121246EFA957EFF7DD4949DBD644454D046D3D594451F3756868CFDF1212
      36FF9194B47D53AD5A6FBF89C5378C16E47534C82AB4658B163D53BEF8E2A993
      EFBCB3F8D8B061FB0F3DFCF0E93FDBB73FF94BC3863F2CF3F51D385114BD6669
      B5DE1B6262666FAB5EFD8FDFE3E2B680E663A0AD6506CA657E7EF57F080B5BB3
      292666C7A66AD5D67C1A1EDE344CA34161508A28C1066CEAAB8B75FCC7F66EDE
      3C7EDF4B2F2DDED2B6EDDE2D0D1B1EDD56AFDE9E757171DF7E6036F75BE4E9D9
      322532F29B9FA3A377FC1816B6E1337FFF96602057037AC3D333E03B3FBFB7D7
      0605FDB9213272DBAFB56BCFF8AE76EDC0184F4FFEF85061441158BC8EB671C5
      8A71F31B355AB03E31F1C7CD8989BB36C6C5ED5C1916B6EEF38080A56B4343B7
      AD0B0EDEBEDADF7FD1226FEF70338A1157360A423E7CE8E9F9C8D73E3E1BBF0D
      08D8F55352D28F27860D1BBEE3A597FCAC26132FFF961917358989E9F94978F8
      F0B5E1E16BD68587EF5C1D12B273156E1C58E5EFBFFB6BABF5E72FBCBD87BD6A
      36EB65E2C50F38842DB358DEF8DCD373DB5701013B7FEDDC79FDC5850B271C99
      3BB7DA330D1AF8F87879D5E8DFAFDFE091C3870FF5F5F6AE3FC1DB3B1AF29FF4
      959FDFAF5F5AADBB417437C2FEB1D46C7E77A6D1181358B4A3AD983E052A14CA
      F99E9EC98B4DA64F161B8D7F22F0AE75C9C95BF6F4EBB7E4CFE6CD9F7CC1DBBB
      4FFFE8E8C9FD50FC06AAD5FDE6EA7463169ACDCB96582C7F2E319B777F6C346E
      FFC8C363F91B0643EB00512CD72FC88C5EB65A751FFAF8B45D68302C59A8D36D
      FBC060D8B5C46ADD8142F03B64FACB5C4FCF9DB32C969DF38CC65FDE31187E7B
      DFC363C7FB3ADD6EF6FB9E4EF7F9BB06439769FC812653ABE4F1A29F9F6E8EC5
      D2688187C79CB7359A1F803FE66B34BBDED468F6CDD6688ECF02E6A9D5FBDE52
      AB77C37DFB3C8D66D3EB5AED5B6F190CCD9F351A79CAA712CAA59CFD21AE2946
      63F00CBDBEFB6B5AEDDCB92AD5AAD92AD52F2FAA54075F005E419B3F43A95CFF
      AC4AB578944A35EA71AD366182C954A6272B45AE72A32F6439D6C3C33A5EA3A9
      355AA5EAF6B04231A98742F15C1F517CAC9D28764810C59A1881F961CEA56299
      574EBAEC1BA45B01225A8C4FCC8037A819002D5A59AE4825BD62D95085B6FFEE
      2FBA75848F25320AD3600C3697C1ED0708CBBCBC4F4B114D7954719F24EE2A58
      B912306BD1B76BDC6EA93B7F8EE252BFF244302155C61152E146134DCFF7CF8F
      7AB8479977B0A0A4E1594A35EFD8FBAB31433B50C3A4086A543B8A1A329222A9
      415214D5AF1555A81799EB42AF03B7A49AD1B467FFC9F82D1B56A680D415A044
      15A680E55594392FBCF3A5347AF04354EBC53364362849AF53931A255EABC2DC
      3EA0C63423EED2240DA6CC3424C8FFE8F07C170F5AB66233CD1C37A01E28EF05
      F86CB2C46738CBE5810411D8EC0E32EA556431ABC9622A84D9A8C63F4FAAC864
      D4E0CF505564F050935EAF248D564936BB535E539309DFF6286450147B7E87B5
      1BB21538B162C531574357619E54754B0741A50657F6A801A44C01BDC086712E
      66BB387C098A6816322871E56C9528CFE6C0ACAE8238B00C34124A0D9830D4D0
      415481E5100596A315F8EE6006381B558ACA2D632103CE8322379ECAC92F0003
      1011554A30424C992813477E6800AD4E493AB869D90DF962733830F3280FBC8B
      A8402BA259C800F612854CC803038512C4C14005E463EEF0BA4B49A7F315B42B
      83E8D7AB12FD78DE416B4EE6D3EA6379E4401E80430989D286420645F2E2176E
      DC239A6F7361155D41B92E814EE70874215FA0EBB8FA3B53A1212CD911FEC315
      D389F8EB6344028BD4C4FE391C872F4111CDC2628A2078819C227AE6B58FA55A
      F5EAD09727D5649330B10A311032155F3B24203584CB4B253B8EE23870FF38F2
      CA6173D3F06A363AB0673FCD7B76F8AD620A82ACB83DE732EBE032CB0E12CA76
      2E027D35349C2437A692093F880D4F2A1403E224F0888475AC9FE2A369C5CFC7
      301B0FBBECA9E8C1798054288BAC255A7E4ED66FC70EEC6BF1C2DE3DA0878C43
      BD909B0DD6653220C40A4D04E282F96C91444C5CDBF3737F2B2152CA20943217
      1BA360B000B21A30767AFFD0F89AFD4F5CBC11D8A34D1D5AB3791FC5067B5F3E
      7FECD0575F2E7CF52BD9D3AD472A8C17811255118392976C183FFB23A9DB43CD
      C8C368906B2BBE2C29373B87D66EDC4A0BA68DAC327CA187227931C1DBF1D8C4
      99CB8C16EFFEC80674C79013E402E938B2336E7CF5D95B2F0CBEDD7F897D1142
      549407251E8A0C20321DC605406164608092806B4095EA7F41A75F5C3F645940
      A6F764472025F0E01547A4886A615B5464F99FD0AA4C012EDF518031468EA8C6
      682C6066259728FC8B86FCC5CF0E95E1D6FF801035ADCC13DC79C6B116F46600
      FB8B817EC75B7FF05E56C5220A866D1B6E7380564EA14192E7E5AAE14D438097
      7C23A057747F113B9741318334B8F605026FBFBFE8BEFF0704C45815FE0F88FF
      DADEB3FC0F347EC2EFEC27565FBFAFC31FF4FF80602DA6DFC8C6C1B1EFA7863F
      74C51863C5F2C9BFFF1F108E3E50F23F205AAD463ADE23F7A7BE3BACCD7EBEA6
      F5D2612ACE22783F98FF01C174013A1789FCB52EFBE9AE377EC811F4EA1DD971
      BE46657DDD7DFF0F083A3B248084952B57CEC4EEE35A38412760F64A5E36BC70
      F98AB0EBBA681C7122BE397BEA13F0CA161BED2B5008D94EBE475B2BEAC8DF19
      420DA596A474FC9FB18294C031B021FCFFE1C387FF80B772EF029A3D077CAE23
      703C9411F91E106909F1FF26023F3E1D3338B36DB6DA8503828C8EDC1F7F068B
      C1CE2FE2FFADC36623E0C288EF1E10A88DF8EF0111E0E5FEA7CFFDFB4BA8E8F7
      9736FCB75FC64834EEF7109A7EE2E9775B91E0EB21DE67DEB2F202975E318366
      0481736C28F78000A72A3D809640EE01019E42390F384585F71E100D36A5BF32
      ACEFBEDAF03D7B1327F9F3F904C13DFB2ADFDBDB4F3CF5417CE7E5A75C4F9F3E
      6500060F18830C06AE6EBE0EA4C9BB07E4F2BD4BFF81238EDFCAFFECD9F28249
      986BA16AA593D7DDA947455E9C7A0F34148C60E73AC272F21FE005E40BC939BF
      88EFCBE36F49978B776C53CEB6FE23A6C1051CC562002EAE018EEBFEE204DA04
      3CC20A48821025F780B0FEFCF927F86AE3FE3B1C0A0232DFAEFE04CE12FE0599
      09C4301AC884224ACE75041696FF0D0233560323B80A689C21106347E49E5F04
      B280216C4211D05450E98CBFAE21EBFCA2D495EA0CD3FF84032D200A91737E11
      07D81733FFB31365035011E9F780800C07B5EAA0981168083148818181013834
      C4700948134620C3A1AAF047045411907AC0402600002FABF8BEB76738440000
      000049454E4400000000}
  end
  object TBXPopupPanels: TTBXPopupMenu
    LinkSubitems = NPanels
    Left = 208
    Top = 136
  end
  object MenusImageList: TTBXImageList
    Height = 18
    Width = 18
    Left = 48
    Top = 144
    PngDIB = {
      3F00000089504E470D0A1A0A0000000D49484452000000120000046E08060000
      00DE6167FE000096B9494441547801ECBD757C1457FB3E7CCFCCBAEFC636EE1E
      088104777768A1B8BB94529C9602C1A5A5A548B1BA60C5A1688B6B7177082440
      DC75B3BBF35E67216952E479BEDFDFEF9FF7FDBCF99C6BCE9923D7DCC7EE3D36
      138EDEF0577FC20E05BCA38108C00D108054E02170E9E492CED9B02B19BED21D
      6EEA7DBCC55514C5DE3C475F9B8DCAEFAB07392F88F4D1CF356AE46B059ED620
      CA283CC81B76255389A8FEF8ED26E2F9CFB44AC9E296D53D6AF56F1E42FD1AFB
      51A75A5ED4BAA61FB58DF30E321B14D3C030076441B0CB4D391148241C47E302
      DDF54306B78E30756F1840A13E4EA4D468C9643252355F1D35AFE242E33A85AB
      A27C743D20F14C90B930A6D3A74F4358E662E0B858BD5A3E6050CB5065EB1837
      B25B4B89974849A95293422E27A35A2057A39AC27D4DD4ADAE87DCCD20FB00C9
      DA002493C9E40E89C0CCC1A3B3AFABDA35CA5B4B89E985444A1D88E464B78B24
      2290E778F817D0E507A9E4A693528859298554DD9096CFCECE16596D904FDD1E
      3AC4ED5B3DC0185D4A025978152915ACE2442A2C2925B594233F370DB91935A4
      554A29392583D2B272B984744B91D5CEFD1EED5C50C22421B0BA83686DB706FE
      EDBDDDF42457A88813242497F06429B552A85941BE2E2A426D524E6E2E5DBEF9
      908E5C7E42A79FD26D8B5D683FA44AF6D332221323AA11ECD2A5511533D50C75
      A3C48C22BA955448A5361B99541C99353C7939AB48CE95D0A3C74FE997238FE8
      76A6E2BAC84B5AA15DBD908080991C5C929FA4E4D96C51EE82AB1E85AB91112F
      DAE9D88D647AF4AC84B2F38AA856A0966AF948E94E42322566DA4491B84CA44B
      07C8211173207B2D2402F773CD1017739F46BE14E8AEA5BB8999F4EBB1A79459
      60A5ECFC128A749750D3409E0E5F49A2934F652536897222A459C1D2572452C2
      63954A26F46D53CDC4B7AA62A45DE75FD0B98412B2586D9457504281463BD5F3
      B5D31FB74AC5348BFA04717C3F103D41BA7F246237902A04F65267B5D028DA5D
      545D7D5244BC20A382FC7CCAC9CB23A58C279D515F9A69919F15899F8EB82740
      64875D99887980CC07B5334846F6EEED225DC26A04B8D399BFAFD3E1DBF7A848
      EFFF9C93C87723DED720B80DBBDC381A64D9DDC89123B5550A0F540FB39C7DD0
      C053911D1EE06E95A84DA431798AB52382EDA1B2F407FAE4C397E457964B91A6
      52DA4A375E5E5E9E515151AB5B358C5D1AE52DA9EEE5E42AA86572AA13134A0D
      6342B9A6D1AEB15D9BC7CCF1F4F41C0D2267E0CDA67EFDFA818D1A35BADABC79
      8B07A3464DCB59B5EA44C9AA55274BBEF9E644C9BC79EB4BBA74E99DD2A04183
      BBFEFEFEDF80C103F8C7ECDEB343BA63E736E5B6ED5B5455AA543185840437F7
      F70FE8D8B163DF8F7AF61CBBA07BF7310BBB751BBDB04B97C10BAB558B9BE0EE
      6E7ECFDBC7BB4EB56AD14E2C0D4BCB38FE61FC3F701D397284AB5446FF5B2E15
      FE1CBD7FEFDEBDDCB061C338E447D9AD5B37FF2E5DBA5487DDAC4F9F3EEF75EE
      DCB956CD9A35F36D365BDAE3C78F994679ED7923468CD009274F9EECAC542A87
      2A148A917ABD7E829393D36093C9D44DA3D1B4855F23AD565B1FFEAD020202C2
      4158885ACDF3F3F32BBE79F36639211EA6E09168727878F858D444273737B76A
      9032401004779EE70D52A9540EEDA7361A8D21201A1E1212B235303070457070
      70D74183067974EDDA95636CB9B9B976BEA8A8A8100978894442B01DE0388ECA
      C0FC40CA741107290D66B3B99B9F9FDFD7205DEEE2E2D2F3BDF7DE33E5E7E75B
      04B0768614A160E6D035280F7DAAB8B89825841741D5DA1DA476BB9DE0CFC1E6
      E472B906D90D85A48D4B4B4B6B9E3A75EAAAC462B1DCCCC9C9E98027F3884028
      17B25AAD545252E22043213BDCCC8F498D6C13B2C2414F0BC9C9C94E2F5EBC88
      7DFAF4698824212161874EA76BEDEAEA5A1DD27088CC9E889F379E0A0A0A1CA4
      4C343C995253531DC8CACAA2CCCC4C42B130520B1E9ACF0D1E3C58121616D6B2
      56AD5AF30C064395C2C24281950F938C65F5F9F3E7F4ECD93307014BC8C891D0
      2125722342A2ABF7EEDD1B2AF9EEBBEFACC8EFFEB163C72A1B376EFCB95AADF6
      43E171884419191974F7EE5D626E944FB9744C4256012CBB7870367292CFFC1C
      78FFFDF7555F7CF1C5845DBB76651F3C78D0BE7FFF7EFBEFBFFF2E2E58B0409C
      3B77AE3873E64C71F2E4C9F68F3EFAC88E5CD8D0602DCD9A354B4073F812E566
      7690945DFAF7EF6F5AB468D1BC3D7BF664FEF9E79FB65F7FFD55FCFCF3CFC599
      3367DA274D9A64470B2EEEDEBD7B1A08FE46DB5BEEECECDC038DD91FE91D3D04
      F63FA67DFBF6AEF3E6CD5BBE75EBD6826FBFFD56FCECB3CFECA3468D2A40B7B9
      0F35B3D5C7C7672CB2551329D84F1807FBEDA64D9B3641C8C6AF4002082EC4C5
      C57DE3EDEDDD03AD3C0CA934C0BB0910C1619090439FF2029AB9BBBBD704810B
      0264C07F478088FFF78DEB57E2FFE8E902AAD9BD57AF5E21C3870F8F40AD351C
      3060406FFC4DE8EC74FF33DCCF422D8D402D79D6A953270759CD3E77EE5CE99B
      C4E6518523F0EBB104EAE43B602DF4D104A89396B043A08B4CB0FD50531FFAFA
      FA2E41810F9C32654A18C8CBC60CE59C3C227746A4861E1E1EBE68E1285719CF
      7A38BA077A0AC7FA1C87D6AE84FAA8079D350F2AE41BA8900903070E0C84E628
      57D53C7A721E681D89C042E8B40EB5010F87CDFCD072999B75662D246C1C1A1A
      FA594C4CCC0E28BBD920ACDEBA756B9904EA20272D2D4D442775142EEB98AC5F
      31223CC0D139211D313234440E60AA46831C44E22111E8979D804142CF9E3DC3
      140A457DA80946C4412FB1F48E0ECA08983E62E4ACE33237B2ED5021503FDC93
      274F9866B0262626FE2540CC17501FBED0760150113C23644F6784AC77330206
      3C959080A03288A916E482981F74532AB4C426C98C19331E7CF6D96733F1241D
      6AAF0102254C1248E950B3D0378E844C91E1210E65C61EE0101B17E8A634A892
      743889476DF1206B833675F7CC9933F643870ED94F9C38216ED9B24584361067
      CF9E2D7EFAE9A74C8D88E3C68D13D189EDF815B17FF0C1073674A7BDEE1EFE81
      8CC801744E397A7DEF0D1B363C662A64DFBE7DF6F5EBD73BF4D19C397344482E
      4E983081A9123B7E388BA12592A1558FA02F7EA837988D0E92B24B870E1D94D3
      A74F1FBE7DFBF6677FFDF597FDA79F7E7248346DDA343B34A81D2D3D1B557DB3
      468D1AEBA1E387205D554003BC6EDAB56B67C0D3E743B2BC55AB56D9A74E9DCA
      34625E8B162DCE60B4B204ADBE139A00CB8A0AA9594DC37A8B69D5AA95FBA851
      6317CE9C39F7D9AC59F3ECCD9BB779E0E313D00D8D952933C9BF9339F7DCF176
      C229537E0A3C70E0DAC103076E8BB366FD92D2B66DEF7E2028EF1270971BA7AE
      1BA442F91D1C1843BAD6AC59B365BD7A4D62222262078487FBD554289CF48585
      36C16C76F2C26FBEC1D3D305DDCE6C4783CC4412875106B6142B3D01ED28B26A
      D5AAABEBD4895D6134F27D89D45EC80EC5C444C82323236AD7AF5F6326D4F04A
      14F46030680187C9DC3DBCF27007CABD0E7EDBAEB76AD5E6D1B8710BF3D9F891
      818D2167CDFAA1A463C72ECFEBD6AD7B1B6A6511182A57393CCA0DBA8A0E6AA5
      9EB39B779BD66DFA8C7EFFFD51333A771E31A353A76133DAB5EB33C3D3D37730
      246C8E5A8B4422364486F50E131F1F5F59D40A71DF1656A98C2AC4A7A3478FBE
      95EC4D616F25AA48FADFB8FFAF11395AE4DBF2FDDF48C2E2203DE720623715F3
      0D37C5D34CE6FD1AE26916356EDC98FEFD2729F3406039299E2096F9BFCDAE18
      9FC5E1D9E5FF06FE3F4CE428E0FFA670DF558E48FFF6EA47ADBC312D6B1A6F0A
      7B67F5238143E28A8C78BAA369FC3BECFF25B506F15FCB5259F6DE155616E7FF
      C8E60E1EDAFF9552A96A8941041BFEB2A9159386C34041C030865506BB773C84
      E739BB449058304812317E72143AFC4A8B8B8BF6488C06E328A34FA4ECD2931C
      47E4B20B472205B92828CADB483C5AC9BDE45CBA9A984FB67F0D76C3DCD5A4CC
      B8EF2661925C799A478BF72650C53F7F27194D6BEF8721DF4B5F09CFD1D13B19
      F4F7E37C48FDD28F5D7BD771A786CE7629139DB0B0872530E6FD122C2F3DE39C
      29CAC74402FFB28504B869695803777A90F298D2F2AD2F23E22A3A3248F43216
      3CFE3122A924764A78968655ACA272EF82620B3D7E9E42465909610DAFDCBFCC
      E190A8EC46863BA560A360831D4F10E8C1B30C52CAA52493482835338F50F814
      855989DD6EA5E44209155418BA974BE46392D2F4B65EF4419492A23DE4E4EFA6
      23B5424A761B96E4F024AD5A41016613857BEAA97DA486E675F6A55AFE9AF232
      741005B92A685A077F6A5BDD8B7A3789A4DAE19E14E061222F17031636A5181A
      F3E4A45591BFBB89AA0599A9631DAC27457AD0A7ED0329D64F8BC7BC2AA3AA5E
      3A8AF57F59B0469D8AAA60392CC0C389742A4579610B024F7A8D92FCCC4E64D2
      A9210947DE4E2AAA1FC2864C442815B0A16A1DB4AF2E3289E0888846F7CAE7A5
      C5DA130AEFE5CDAB6B591C07D1FD6436491629D8AC75ACCD66E616905625279D
      5AE9688C2C8D1DF55C585442997985A457AB1026A7949C627A9A59EC58F17310
      5D7F5640BB2FBDA08F5BF8D0D317A98EDAF1331B50262FB3C762E6171653525A
      0E3D7A9E4525A5A8591F37FAED7C3A569215D4C099883B77EE8CF884F3A3F9BB
      1F92935A42AE0A0B8523200CB5532DC81D65824577749167E93974EDE10BBA9D
      9845D7526C945A2CA78C421BF5A8E54E8D5CD2F21C1211FE5825A717D828BB88
      A7423CD1DD584A4E287829CA0BC16444415BD105AE80E45EA640A5761BF32E87
      A3FACBEFE0C0FA343DCB17C8DFD34C465439BC1C4683320BF53113564541C239
      FC2A5ECA25AAE8596A275A7F3E8D42BD0CE46962C369A25414EC2FE7528949FD
      3A0DAA1FD5570A55201DDCD0B32297A3961351236544E9F916F27356D2C0062F
      89CB224763699FCB4DB7727BF7FDB1D1C9646A84EAFDCF63C2B2D4156C08624B
      4F4FFB93B018A9ABE0EF7062AACE03D58108C0A1391D01EFB8F0369BDDF88670
      560C81F05F08F400992BEC771A36A37EADE652C771AC6E9F2165143007980AB2
      CA4B3BF0AC685E23A9109804F74380D54223D806C0619CBF1405972F452DC8CB
      B35D8908010250562D59487503792C85CD54A51D61814030FC02E1D707A8877B
      296C472D33BB0C4CB9B4436055F4D152E03602D8BA80047613602AF0057ACC68
      6018DC238050C4E72A49044F0B1002CC036A01B745A29BB059B6C622724F8EA8
      35EEDB01CCAF29EC0F002D8F4B4553849BB30093AC1FEC2AC03DE019087C0035
      12C8607BC1AF18108038C0087F58AF0C6A0B02D019DC4E83E8D781A670370014
      08100018A80C2219FC98FB6BD8BF02D9125C2A19901522CF8CEC1ECA88ED29D5
      05214BF802295D10B9AC3298445B717F0F692CAF1121A0CC70487819D9A8098F
      48909EC33DEB055E204E83DFAFC0134602FBA5CE16E3E32370A3052EBBE967B2
      A7C7C06D832ABF087B1F100C48010B003EBA0DFB3C60051C86775C899AC2DE04
      74AA657DC21214C17D1B7800EC064E013780CB904603FB7D60253002C5A08120
      BC0437CCC871F105BEDA55F0E358D8BBB8F878D610091199AD841F23FE0B3693
      7810B21C231295E07E1B80DD385C2B184FB897003C9EB2136416944D21EEB590
      A439EC7DC0324009926EB0A50023B6F170FCDBF8C28391D581CD4C262E3B0067
      C0034820A205C04680D51C232AC06F1EAB1C3A07CFF915F003DCA500A58DE78A
      21CD2F70EF86744ED0FF1C6A2A818816013B013B2417E9B7F53F9B70F31F8D79
      D933B3C7F2EBE17ECB8E4AD68D8EE150769CDBD799CEE6AF5374B4E65FC3B857
      6C9CCBE2A248A7592F6A6B7B7C6B12DC2254F057BE820CF69B8A83FD8622E85F
      064FAB0BAF29C0618089FF14D9B1C3FD56F34676C47E0EB802D380794028F04E
      F3362256534CA939217523C00C380CB423FF4A3B2A1C1EAF2EC22B9B353C4EDD
      3A5E0D58E1C7B2E18946D714EE1CE077F8F380A7B33D5F0BF46A52FAA0F91F0D
      0262BF685C2F2CBE7163BE9C08916448C0129A51CDC9706334452D60DB80448C
      89DB4844DB800031B30586A3EFE3F7AC45983DB5999798530F0F0CAE48847BAA
      8144930026C513B49F60B85959554160138EE3426CC40562D8CF3FE29DB8E392
      80C372D1363D844F65C580A8AF0C6A2B0ACE45908865EF0F104543126F9EC406
      1CC71B10865B910D0D9E6048A7C57D1230E22BD7F5B724705434F770C3B4635D
      D8B148D5D8642F2C2AE4A44A0B49911672711C4BA346F84FC003E039565299FA
      85B38281541C6EB56A7BC900CC47E6AA458BDC467C7106AF46CE38D63839D4C4
      0BC419041C032C5FBAFC66E0E078CDB45C9CE81A614B1EFB42D08D3D2FF8488A
      38C9792B49F2103108D92D84BD0B588D46FA1C362D5BB64C5389286A49AE5221
      96C60E2839DFA3B1F561E7E392C0E7F314CD9C2D9C900A959F8444D540741DF6
      2AE00C900732B6EC2AE1A077987A2886A7FC94E05B054F9F186E4BADEA26E66F
      99236FFEE36A799D9118164A11FE10242C3B6E703F0398544B40848760A0058F
      798005D0D7B33D6900BB00980FFCBC5A5157015B89A9DB23D83F125129309127
      0AB5137583FB77A09C280F3731403EB01438055C838EB1387F399358DE214953
      F86D067E02342019099BB541396C8791E01A4F44ECC908A77C46807B87E1888A
      E0D80DB08461B07702DF0036E07DA09C08EE771B340725D00B1DB53F3AAC82C5
      C6BD11F808A8C7EE5F628D68808633014CBA977EFFBA9A9725E9DD97DDAAEAB9
      E28CB22C08247AED8A0237C59A6417A47DBD1D61859DC70E83110B972E58CF57
      A6A7A70B688964301AEDD8B52D4978919C7E3F2539736CF71EA565A4CCAE2405
      B673D4581DAD85C43D1F3C78D018BB9DEE205310E6E47A93A9D4C3C73BCD6834
      9D71D56A772CFEE5E77D93FBF6CB62240CE5445851D76173A0CF8D1B3786C01D
      7EF7DE3DB9D56E278954CAD9516DA53C2F170C7ACF90B0B0CE514141714A41E2
      3B6EE5CA555F8D1E9DCD887876C1EE9E023B367D21D127EBD6ADAB7AFBF66D39
      36FE39F37BEF716E6DDA90577434F9444592CEC383BB9C9E26D97AF3864F625E
      EE68A3543A68D2DA357AC621DC58B14292A254D6C7FAF44C6C64FA97582C828F
      9F1F27737121CEC3034763049260F397944AE2F4382EE3EACABD9049B92CAC51
      0728953E6AA27BB5716281CF532A3D90A5AE57AE5CF1C74609A731184850AB49
      82DD6379420229D3D258F68853A948301A4874762695A7273DD368F864411220
      972B3AC8950A3D9FAA568763FFA8C1C3870FE5A82912E572B221110A98643939
      C4E5E690C87398200B64C7039E55AF414535E2C8E6EA464F2512992093D52BC1
      E493B74AA5B1D885F1C2760F0705C571EEEE640F0D258B9313B1C256E12013B6
      B108EA954D7EC9AA501076AC482A9773D982C0F172998754B447B04DA8414F9F
      3EAD76E7CE1D549094537B79910224D8C8262976DA3DCC66E2513E2495112793
      93B4B8841499D990368FB4A516AAA252D92DB9B97F4BD0D8402EE7200E713A1D
      153D7F4E126C3D6B90C512547BD293042AC1112B0B669225020E39A1EC0A1940
      E86CD093A64E5D6B9AD59ACF6DDBB66D0176CD477FBF699346A8568DE3B17CA1
      494C241D1249F12B60E77962106117582C98AA1652016A31BFA8889AD7A92376
      6CDC24E1F28D6B0339EC0F75C526D4A2EF7FFFDDEFB95E8F1F0B9E532525110E
      0290140D9249CA4E1A95C26D83243928FC82A26292C864E2D811236CDE1E1EFB
      4E9F3B3B92C346B85F7474F4A2CBD7AF77FEFD8F3FA45848E158D54B912DB6B8
      822361548202B6A00D8990C8FAF02115E2785593264DEC7D7AF77EF1F8D1A339
      C74F9EF891EBD1A38704C7603AA1A32EC6AEBADFF1E3C73946866D41B4009E38
      14B45D83C514B41D1BB25372EB164504068AD8922D42FBDB70FAF4E939CB972F
      7F02DD453478F060436C6CEC789C441879F5EA55230279B6A387A6CF1A10D950
      6E02DA9693D128560349CDD8D85254D2D1F3E7CF7F76E1C285CB67CF9EB53175
      49972F5F2EC6D6E13DA552598ACD1333B676B4388121A0ECC8802CF9A0AB540D
      0EC6A99F186B5060602A34C241102CBA7FFFFE456CE8316D89675630CD9B37D7
      8F1A35AA350E0BAC82B81756AE5C9908A402CF717F73E1C2859BC78C1933A865
      CB96BEFEFEFE8E0E5F21796527F68F0494992BB6A16B0D1C38F0830183870EEE
      3774E4C05EC3C776EA326242D58E13179BFAAE3B5AAE7ECA52739B366F30A060
      55D8C074945759C08913270D5959D91E58372A75717649AA592B8EFD10940557
      B4459C6129ACE851EEC68E96124D6230F6187FC766E5CFB86F521EF816C7DBF2
      E98E828EC3BEA3884D4B2524AE0332F95B381CDE6F2352A3D6B46DDBB675C1BE
      632E76AF8C886D00D96B65037F87791B1141A5F08004246CE3D71BB1FB02AD40
      E60768000EF7E5E66D443616E35505886857129C13A985F300BD90CD495080A3
      101E0532473B84BBF2741D011C030B00D813D167053B0A3C19ED8B6595860E1D
      AAC33E6D2D847F000494C52F97081EEC57B406026B03CE00232248C3D7AB57CF
      8E96AF40BB92F7EBD7CF057BB916C4AF8AD3417D11CF097829113CA5B869AE56
      AB07A1B606A06CBA633D5B0F3F1E44C190800D525538F6E08DACA91A376EACC6
      76B4157DD38C382EC04B223858A2EAD8A3367CF3CD37EA860D1B62735D512495
      4AAD286C35887588C3A4C72DAFC4C39CB0AB8E67594BE09F07941315E3260D3F
      8C12FC646BB09F4D1F7EF86136D8D8500741E5866597A1183DBE105BFAC90849
      031CE32842D658A00FC4EE131111118C822D825A098024ACFD304958DC328818
      1B244E9C38310FBF853BAF5EBDBA8D053002669791614ECF75C1C67704F6F715
      E8BC8108FC778BB660B7E611A486A2CCFDFADAB56B3711E7A544CC510648C76A
      EC3D9C2BAABF74E95223F49313C264007BA808AD980B95F2005BF82FE0B71C44
      19B05F27629E207343360757AB562D047BFD323F3FBF00F8B3EE2142A9658C19
      33E6E1F5EBD7FF86DF4610B1027F331122B0AC46806C3C4E40C9B0358D9F174E
      80BF9892925282834DB9382BB109F78740F4EF0A81770503A9DC811FB1DBBE0D
      65F56B19D0383742C56C475873802F4BC261FCE7F9EA268B8673E50A0A9158B9
      04224C05FCDB58E1F1F476BF7D05A55A0F17B8455AB376252B44B8DF6D7CD76E
      E6BE5B3E48BA6355DFC0533FF68DD91ADF9495D9CB446B44677EF8B0D1E2CBBB
      775F9F0CEB26FAC88A7DA243CC73FC02BC967B077835DBB3A88DF4552A2CE4BF
      72BDCBDAB1E47DFEF0BA3E55C2C27C168A25C59D8B73B26B7BB83B7DEEE2E2DC
      69C7ECD68C2CABBCB0DE46B47F65774E6F50478784F92C36A8659D54325E692F
      2E122C3959915A8D7A86C1D9A5D10FB7EBD8FEC9E75B9870A2D71C12EA3D4BAF
      92B6B6E2279B17310DC42C27333D972F2ACE0CCD299675BA9F66BBF8D682DE8E
      ECE8F4AA605F5F8F099CB5A88F49A3509616634893934719E9D9949D55509A92
      5574E9C2C39C59B5BB7E7AE68D441BE777E0DCDC8C3121A15E73D532BEE9B3C7
      493205C6FF02D9E8C50B9C164FCD2E4DCBB7FC7DE852F2DC1B4F728FACFA650F
      6B2AAFE769DFCAEE81CF4E7CBA3BFFD24C31FBD4643165FF48F1FE865EE2C5D5
      1DC5FD731B97AE1B1B77BA6723EFB62E3A9982A5DEBE7DBB9AD9E560D9D9F1E5
      FB5E094726AFCE39FF5951F6A94962EAA10FC5842DFDC4CBEB3A8B87E637B1FC
      38BED6E95E4D7CDB7839E17CFAAB94BFFDF69BF29593E8B7B9EDB923DFF58B79
      76F2D33DC9C7271625ED1F6D4F39304A7CBCB59F7876793BF1C0DC46961F27D6
      3AD9BBA96FE3003715ABF2F2B4D0AAFFD4FEBE953D221CD9B93843CC3A39517C
      BE77B8780FD961921C9CDBD8F2DDB89AA7FB36F36BE761C428B59CA28263FDBC
      0EDC916FFB063F3D367533B253F2323BA3C5C75BFA39CA8465E7A789B54FF469
      8AEC98E46FEA772FD97E9DDFC9FDFEC1F13F3EDA37A630E18F1162EAC1518E32
      39FF4D07F14F94C9CF136A9D01491348F2E69A79494334E7A3A6FE87BFEFB7F9
      E9BED1457736F5136FFFDA43BCB4A6A3A34C7E40C1F66BE6D73ED0AC7A37C92B
      32D9B0F7AAD63DFD7DCF43F736F62E39B6A4152329FD7142ED533D1BFBB4F1AE
      503BAFE2BFDDD2ABA58A816D429BEC5DDCE6D05F0B9BE5FF34A1E6F95E8DBDDB
      38EB3067787BB27F42D688FF48AC5349E5DD1BF9D6593C3466F1F076811DAA05
      1AE4FFC4FC0FAE35A21B41430A15A2C9E4BD9606A8FB7C1D485F65B25F930A41
      70AE119D10DF13D0E1EE1F03C5C654ED25F83075B910F609A8DB6B88580D6E1B
      DCD75FBA6D365F71CBAD447A2FDACE61A376387713FE3144620BC4FB88887BC2
      5AA43B6EBC803A00238045D5898A63DC3612D44C712D2C89542F36F4E0EC9CBD
      0602AB02CCC482200E603ADFCC8896C0F757602C24F81936C1FEDE4DAFDC0437
      DEFA505E82FB3ADCCEB0BF43D806B8599C75B0C7005B81C53C2E4780838890B1
      75EB567EC396F5EA1F37FEE0F21EF5F5F1E742E254A2A6356F17EA939D5C108F
      C587F5CA0CE792E13A041CE3F7FB1E78BED77BDF2D4C665AE01057373777D741
      6A57D587B186BAE3AA2A62BBBA091ED19E9C4F6460514415B72C6F2FB7F5A445
      96FF211CCEAD811077F833F6A08FF60B35E7F9FAFA0EC6E0A1875AAF6E91ABC8
      ACFE48B8E39DC9A729D552B5DC49E16A366B3DDA052BC387D74C6FD2BCFAA346
      CE18BDBDACED35E260147C28AF94886EAE06B52B064F6A4C6A04B554C369781D
      65D93229DF9E471A890EBBE912BE4092A7F3D2FA443431B6EEDE58D1F6233CB4
      E9800103DC056B911C59E3F87ACAE4E4E101F94998A31146682411A5E42DF5A5
      00790869049060B550C6CBC8C09BC84F08E13D95BE6A7F2FFFAA38803A1C63A9
      31A3EF4E7DD27A7B9B67FCCF092A5A74C9EA89250DC7396CCCC348629751A83C
      8AC2E455482E2A4923EA285A1E47BEF200C2BA0404200EA33919066291E7DCDA
      7D7A3C70703541D2EC43AD59AFAC5E55955B525A5ACA86C30EC9A490CC6EC301
      785B31193827F2B505119F2F751CEF4CC29C17C3448ED90F052F3D363AFF1206
      C4981263B4050538C0E76FB158A438C1EA385DAF5440128986720AB349922327
      3E5D4A2F9292292121C171F814C73B1D0754B9FBC76E592F6CD92F99E73D3BCC
      9099E9B4ECD2BE139877348154729C5AE53036A2BCEC02121F4AA934D742C9F9
      2984306265C9F286D1BFE3A8ECE3AA83AB2736A862609DB63AADB6F71A3D7AB4
      DBCF3FFFFCC9912347B61D387060D7E1C387776FDEBC7937668DBB7166743746
      6EBB715E7B37CE8CEEC639E55D9818EEC4CC69A3FB985FF7D0C2C448465E8EF1
      E3C707AC59B3663E16A2B6E320EAAE5F7FFD75F7E2C58BCB8930EDDA3568D0A0
      1D38EFBE1EA3B82F30981F8C66130D020993A8061A545FDC10CE8CF2185F57C1
      40F32B48B5F3871F7ED88D83A7BB707E7D07DEDEF81D04AB31829BEAEFEFDF09
      E3F150A4D1D38AA251B4DA16CE882682E817C0090184573DF8214386D4F9FAEB
      AF572E58B06033087EC60316610437105388DA2A95CA154D846944A682CC48B7
      8556148C85483401046680051CDC359CFB5933FF76D5FD59E9D6E8F30B779F0E
      1BD13ADBC9A540DC5D7B0B2D2FE84932953FFAD606100C459A96401712A4F559
      E77B819B24E00C7005A00253D8B96786985F0E3DB46DCFF269F8A5E8576B1BFC
      F340721EF63580990BB8FC0D24112779C4A450E109E5835004380CAA9F736DD2
      4D1AD0E5435F1FA3B6AD9B5ADEDCA0903A61E9E956894DDC83F5FAE3F35BFA64
      3A22E3C2246280B3B271597A96F7E939B96A1D7FD759ED429C3E691B6C6CD6CC
      5F57BD818FA6474D0FF5970106D9E4F98793986675246424450E57858BF717C7
      381F852DBA81877256731F5DFB50A352EDAC94966AA542895129A10093DC3DCA
      5539CC5B2799B4E448A2274B2A41B66CCC51110A89A80DD3CBFAD6F7D4367452
      48AC36BB6815B1C266C1A29BD54EA24CC20B0685A0F435C8BBD9ACF6FB4B0E3E
      5A2BA94850E6362B0573B051D9D44323276C3D94B2D33D18DAD9B1F8674716B8
      E252BB5521E12D7AA5C4A49109ED0A65C2F6975AAE8CE195EDDF6160784D4FC3
      8000939A07890D83680E233F0E64100CD4882745A90B3C27C92B2AE53232728F
      BC91C8B75D7FEF2A66DD074138482211A0FAB12F08222C4CA129723CC7484491
      38ECFE09189316A5A5E6EC7F2391679BBE0A4FBDB24DB88BC649291120111306
      F2C040240E6A8A18302D923DCB2C7CF2EC69D2C63712F18D7A94A20C02FD0CCA
      EAEE5A851DD943660807BD0088818318D0E3BC3425CF624F4CCDFD233F3B77E7
      1B0B3B29F189E460666A81A5B890FBA87EB82AD049830D4D8E15B4237BBCC849
      53F32DFCDD67D967F2B2F37FD7CA14B910D6F1B07F2E833F575251EE200CEE3F
      91199D3D3AC6C5E475AAEA6B336B95723976D10A71D405AAB538292DFF5C6166
      EE5265A9E5E82703EA955426EAFCB19E4A2D3DF0C6E9144EA3F77136FBA6D4F4
      0FF8C5C7DD2549A5904728048913F4708EBDA4F4365F5C72586DB7DE0609DB53
      A93015ED38464F053903A9A4E0634EA5F374F30D4EAA1118FA6394B3CBDA2C51
      C8D00A9C0227EA646847562CF216E1854FCBB481F550F6FF6486A8F70C2535EF
      378A6A7548A2FA5DECAEBD3E49EC347FF327D3BE3FC1D44BC598EF707F30D540
      1D3E1C418DBA3FE41A76B7BAF498F8BC6DFCCFD387CCFAC1ED1DA95E0BE249A1
      EE01DF49BC5AEF83EC24C68545AF8930BBAFFB76E6C014F8FFD78697EA5CFC25
      7A27AD9B775052CDB0AAAB235D5CD67C31A2051BAEFCD7242C221FE617B9B96E
      58D40F8D422357557533FFF8F9E8D6954858A7606091DF05A621D35F45F81EF6
      1EA895E3D0C755E1D6C37D026EF673A385FB24DCD5E0AF79E5C61892EAE37E26
      908FDA2427381802618700CC78119584614025C586560010F1CAED8BC0208019
      1F5CC20096D6C4C33113D8098CC693BE85CDC6877BDDF48A1F89C8D34DAF4A06
      98C27783FD07E2FC48EC6F38C7D24C817305B08811FD09C77E44486663C88D5B
      36687EDAF4835B0F1A1610C1C5D4D491A195C42E6D8831A419F1587C58AFCC70
      2E1FAE43C0517E9FCFFE677F78EDBD78F4E8D1561843F6327B9A8768CDDAD131
      A6B8B15594D5BBB808EE553D78EFF0E0E2A86A3EE9C1FE6EBF7206645340E297
      6638B70B8EF3FC117BD8CC5FECF5BEC41AE3700C9CFA969414B74BCE7F56E776
      CEF5E0B4DC1493BA40AB752A76F772B37B76F4B5074D8C79D8B06795E30DC2F0
      AA900FE0860AE806A256BC516A33FA9B143ABC6812BD7BF7EE2A27FF3A1DFAF8
      645268DAD99CD0E2F314AABB620E555D710AB55F9755533E30B6F44B0B9B184C
      515BF0DBBF1FCDE2574969812D509A532CCC1ADEAD41BB603561D9DDBD69D3A6
      8FF1464A56685848729E262B2FC3F379AADDD5922D7A5AD2A4CE42769588AA49
      AE120FAB5AA9B66360968945298F2625E78E37E2EF5E94AC7AA4E5852C3ED01B
      AB0C580F14B1FCEE82C52573749D2A77234CD1963BB7EE98C44C5E17161BFC30
      5016CA9D797CCE0BA3DF428CEEA0C639DD797D838FAEE518E582BCE9288D8B5A
      1E664CB9684061E762454F89619DDCDBDD3B47ABD659521FA7B938051B9EBB70
      66D19641D2C4A789AE18B57178071203BB224DB2E09C995C2CFCCDB74BDFFA47
      838CBD4B21663693C8DFDF3F152FEA5C71377B14061882ECA131C14F9DB52E39
      3909F992C78F1E33299EE32DC33C944F0E0A995CEFEEBCEDB177E26D363E6AAA
      5991390BAFFE2CC7225C02964E9330BC4BC23AA303C33E1C96346068FF24ACD1
      26F5EDDB3709ABA749D81349C21B63CFF0C0A488B1DF9D12163EE92E50877837
      0BAF50BA5F5CBB0CA3B1BCB8B83815960CD3030202525C5C5C52ECA5F6149D5A
      978201568A52A94CC1F83A05D2A4207B29D84A7B9C24F5C8CDD2875C60D29503
      AFC2B8AD58B1E2B383070F6E3F8001E9A64D9B76634B880DFF76E305273610DD
      85CD989D18026EC04BCC5FE275AC61680631D470A4D6913534AAC98C0D433CF6
      A66F00962866A25D6D6783D1B973E7EEC268968D2137A301AEC186C2545F5FDF
      0E58960EC30A30C690C57D90BE1923FA128E83400023C31892C31BBBC18B162D
      5A8831E426368684DF22BC96D70FADBF965C2E67634809E232156442BA9F80CF
      395C447832C33ADF2174DECF259F3FEB61B4A4B6883B35EDE0D9B0112DB395EE
      C5F67971533182ED4C528533E27C85747D90A80DD00B709C197D0007337FE2B2
      1720ABCEE36C5A89EE26CAE9A1BDD697D748EF26C32278612E89A7118EB10EAE
      44CC5D0A574DA08049E483273CC5CD4BB3461C03C74CE02E3008D00250709406
      7B35C0B4E41748B310EE9706C786585E05C71D6E606B000500AD67F78496645A
      106EC779001991CC8B4860F72A648DC52D00A1C8C023D10B78B29FEE48B83F04
      36008D24FCB50FA0111F024F80DBC003817FD09D8501DF01C3811A48CB38B054
      3F9C2B86871268A220EBFE0D4E1BB37FD2FF786FB476557E2857B59696F4AD04
      BB84CDB25D9DB561B7F0F4E3C013C4DF033400585A10AD1127E2E6B3D16E8FF3
      0F459C8D72F7701BA231AB47471B633F8A52567BCF453057F5E47CC3838BA2A2
      3D33FD7DDD7E23BD43430EE7581932ED380D527DCAC41A09A24FCC4E86A1D045
      5D30CB6E9A27CFAA769FBFE995C6252B5512B5D4A4707675D1B9B50ED4848DAE
      97D5AA7D9D47ADCC83070F969228FA11D127C018DE53C84F7657DA0B429C6436
      F423C72CDB80F22CB417509E3DC731CB96F252AE50C853BB69DC031B9A9ABFD7
      40DD623C1EDACEB9E8A99AB7953C04D1457EB2F3D5A3F111D9579BB91667B359
      21869EE4267852A03C149BBED869E7049262966D149CC9970FE2DC65DE721F0F
      DFE0A0A0A07ED3687BA35A594777B9A5FC3D83BF9949C51753AC5ABCE4ED9865
      A3FF60CA2EA1607904452962E86AD6A7619733E7465695C752A02284249C94ED
      6EB1F7B7D93B024124DA6BE7E6E47A088AFAFDA56693BE460D1D36982DECED04
      9E30A1011912E020FCCD02573D3E7C213696156470B91262D37A36BBBE73E70E
      C75EB07C2A3A29D20BED273897AF13439B1AB2264F8B2139DE42D09562CACEB2
      C8C8F2ADB9742EF514E567E49326CB48F959050455EC981443CFB2C9B278535B
      5D7D47193E4B92A6F05AB6BDC8B5269DBFB6755234C75EA4502392E39DD1DCBC
      5C2ABD8721318608A9F9692CA163968D7D37C7DA40A236DC703368506C89443D
      9F7591200B2733ECC9F73BDDFCF20E15346353E86EEC895BB8FCBC7C2A65AF2B
      9472A89897063FA2ECAD7A11FB4694C5F35422D3291112C8F4D16034A8F1B4DA
      1A8C3D104F28B578BCE2E9D090D879DF8D17BC1DB36CA6213FFEF86336CBDEF9
      DE7BEFADC7B6C617DE2DFA4FC0547D1A7D631901329835A21A6413252BF21BE0
      6DF0E0B56BD7CE8386DC81D93653B365B3ECCD50B1AB6263632743A7B7930EDF
      D88396A4CEA7E957F460806124B040E40B4CE05659C22267FF356BD0EA3F0FCD
      9F3F7F13B60A7FC40EDF02ACCCF4910DFC7E1C37F9E468AC0856A355B6B15878
      08614919581771658E571D71B5C84B3BDC746B3AE3577B9DDAEB7223B3B7E8DE
      13F6C5CC96DDEA7F28DF52B3DF476260BD15A432BE8FB9C43A4CB8EE3BD2E2C2
      149B174892E07E69D68843E09802DCA1E43B1F91D2A02095E3304F0E49644B89
      E399625B81345F234EB9614406DC31C9721168859B9DFB631AB136DC85C08DD4
      71F8100B1CAF99974BAB1AF8DBFFA957DC95199C2D92C0DD1BE809FC0EEC0659
      2AECB71A26C99B026DF07C0A04037380E9207787FD56C3BF29044F17E1FF1478
      0CB802D1801A70181CB192E1A89513C8E50E0F5C5819695036F97097958D0CEE
      42400FCC43DE078944C7E0FE089002AC87F0B05B61827A09F6493CB89479943F
      099E2C7177D8B198FC5A801B70E701AC1B74863D1758018289C030B847039190
      8C6344C5B8219CB0E325A2AD086E3F2262096AC3BE0B69AEC376054621721BA0
      3EDC0D0196AD26B0BB001A1ED9CA0189013783EEE62E6681C7E16659E80EBB3A
      F01848E6885C003920053CE05704F040154023ECEFD3471664320DC58DA78C6C
      C7BE50344E20A2CB101DC320C751CF58DCB35A3483400060889D1E7F06FFCF81
      43C03D497D1F1F3F228A0256032E2939B3E438A37D19EE04945120ECEA20654F
      4E1489581635F0632617973F804414B65DA290483C716301528021C003E03EA0
      46C2EB78FC13B883417ACA4EC4B288610D25C1EF3B208591C026FE8ACCB1AB89
      386C359DFC2EF11E4F11D014306351E518A4D90E770920E1B0360F5B013C0718
      9994D518DCC43F15F4057048013590EC26E6556F5F7A2BC7C59E7F1B4F4B84DF
      01E034701638016215ECAEC05A6024E0C8AA2487975FC14D4B2012D8E329E68D
      FCAEF0F750B8AF507CFC3A3738608CC00BE008A003FA43BA1091A819DC1B803C
      DC43DEF8F87AB81906AC079201139001DC70D5CDF025E27E81244F703F1E5000
      1F03FD806BC06048FE8887839933B8FC007403DE07BC8128A08A8932D3606F04
      4C0013F029ECC5C0AF40092003FE598940A3E4E0E10B3426222F4002FC099C42
      736059EB899ABB2E129D4C1FCFB137350210D616D80F891EC07ECDB003A91210
      CB8E0F1ECCCF9D33CB73F682CF83DA2FDE55BBED975B5A7658F24BF0FC797302
      472CF82578D882DFAA0D5DB02162FEBC793ED4F09B6B7CFF55879593BE3D21AF
      4889DF2FB556A309C031A21A387615834FCDF8615CA0A818E73FBA315570C587
      4986F4EDD367FDEC59B34EE27DFFE3987BFCECE7E7D71564DA3711F0FFF69408
      82BE5A7474FF8FC68C99848F04741E317264CD51A346D5FEE4934FBA0C193C78
      4A604040278C0D34FF4E578988C3F93AA3C914D7BE4387EEEF77E9E28FAFC728
      B0622CC13C4E8291BFB25BF7EE512D5BB5EA83F94724E2B2CA29E7AB4404B165
      F8F046749DDAB57D305DC0B2A5C0E23B8032E3BC3C3DA5988B84224E28E2B25A
      7D331152483059D1E90D0619DCE591CA1C8244C2998C46254E926940544908A1
      2C12B391989D64A98A233175F05425A47078B30B20E2188C78F9D2A58C23478F
      1EC4218BEB184FD9E1EF3095F2091FC1C5D9B9D9F8091316E1373F0AD2E1C54C
      E800042091886F67947CB964C9C98D9B36CDC080EB2CBCD13E7185F93711A146
      8CF8DAC9A85123478E68DDBAB559A7D73BA4C69CD7B6FEB7DFEE61D8F3F98387
      0FB7610C958BF4EF36D859F06BDFAEDDCAFDFBF6A563F466C5A0CABA7DDBF634
      CC1AA76348C8BACBBB09CA42515682BBD9DC64C2F8F1C730E02CB97BF76EF187
      A347FF856650AD2CCE7F6D6367CB54B366CD78CCD9D2F18D9F6464770AA47963
      ABFE4FA4020ABBC5ACF8F81BD33EFDF4ACD9CDAD2924AD54E5FF89A03C1C12F8
      77EAD8717FC70E1D36607A11501EF03F75A01D19424342D68504052D60EEFF69
      FA8AF15532A97401301E9E4AE07F6D981AED8FD4EF0195FA16EE2B1B8C5C5F6B
      942CC61766B3305FAF5761A2EF172D93790F512894A3A55247E364E1AF638DC8
      26BA0CE54F4479B0AFE7A89D9D9CBC31A60EC7CA4304D649FC70CE4D8F96CF97
      93AC11790CA959DAD7B38D9A62242AE8A20868C5569F4C9DDA65FA679F75EDD7
      B76FDB986AD56A40BDB08398AFE5E21FF6578FC19285D2DFDF3F10C76423C77C
      F8A1D7C041838CFD070C306047D01DEEB0A8C8C87034050D7BE0AB240EAB1291
      52A9E4D1CF9CB09B17806D415D54952A3CD409876FD471E111117C9BD6AD952D
      5AB6F4414335A3E5572AAFF27261B4281BC1D5C5450FB5AAC19C1587A0958EED
      56160645462627673204D4702E8D16EB17E8E2E248E98C03DC8E8DF107952442
      17605F3893621D04E7B765C412C30FE7B489BB9458AC9DB12FB3C6EA1BA68E59
      C6D8B624D53626516C8D87F4051AFD5368C32E70EAAD9DA5213E2EC1D8A38EC6
      5A113B6DC873BC409BCE677A7C7B32A3764EA145292D4E4D48BA7E626F6AA9FA
      84CDA791155FA3348188FDACC36266D8055EEE1224E0C7D00B3B9F1DFFFEFBEF
      4198BF0E5B7F36754683C5B70ED49E7FFDCFCFD65F9D3F79DAEC5E28B7202C95
      552A16465109F8948A1253AAC8E9F1737B2CDA767D56FD85370F345C7473DF2F
      87EF4E5EB5E6DB7E8D1A36AC8DAC57AEB561172A15BC8310D5CFE95D3C359E1D
      E2BBF98D3D72B0D6DCAB07B79E4E98B26DEBB6011D3B746C0A85E78CEAAF54B6
      34EC02EB4A8EF4952E5CF7EDC15CBF3FBF721EBA77CF8C9F4F4DBF78F9EAD029
      932777C5D67C302466A3BB4AF1418471C3B00B8170340602005FA0230DF97B19
      0D3AF9A54FDB299DBEF87269BF8D1B370EC03A6E437C1F4A8FB2F9A782CAE886
      5D70107540E26F802DC076E05B1A7AFE63EAB3DF07A70CBC060E18D069F2A449
      3DD1E7C2D0D75E978691BD22D2207114D00A680DD400D42C1CC31A43C3060D9A
      E1EB399D51C0EEE81695CB864562701031C75B809EAEF2F1F6AEEDEFE7D7422A
      95EAD1405FCF164BFBB6C26661AF20C330A71A501FF7AFAB0A783A0C1AB3C37E
      C785B58F008447026F2E1F04FCB74681882AE0CDD942003302341C477B6631F7
      4BAC11255C6C37A5CCC94BE59C715D8B9AC35B30262D0A5A65AB3F42616D3E5B
      478D3E75A12A03BDA8C630032007FEB5E3072A24604739341884FA4657ADEA05
      25A7C6061D773FE145C9E1DC2045BAA1A633C9B546CCFF9DB08050822439C011
      1E974A06CD5F8565AFA0DEBD7A457E38668C67FF01038D355AF7F129AC3AA4A3
      D63FAEB7939AEAC605190D5D1A856ABA360A738AF0750E00019B59C27A65A021
      058C0F5D70D0D4AF5DFBF65A2838FE69A9C9B4E186105720750E691813C8776D
      10E212E5A3F772D62A3917AC75B14F402039A6A2B8961987867475D5E3D88706
      DB15DCCD14BBEE8733D9D119459C7B6C880717ECE7A5D769D4325EB4C945BB8D
      2F4BC76C1EADB8BC5A5983436B966AB53AFE5AB24DBFE258464C4ABEE8111BE6
      CE3BE9F1720E472460031B6FDA3112DC318A97A874A3D168A4E8E1E14D7B8D6F
      90A0A8563BB354EE1317EAC119B578FD45C41299CD2AE6E4E6D932F34BB20495
      53962095D92EDC7D41E7EFBEC8E520116BB106F0A6F10FF6A2C6E4F55DBD827B
      BAF90404D58F0E90B818D408621F9C14D9229D3DE9454ADED5C79937AD722701
      EFCE1424A5E74993330B648CA81562B2F99A85EC364ECEDB0CF88287B945753F
      D7201F378C1FD8EC9C23BC6C229EBF7A37FB724276415A91F43149F0F9060EEF
      0D721C536A570434A6FE26ADD2E067D66B9DF52A5D74B087101BE1C3E3BB0BD8
      E6B7C9A41229E5E417149DBA9620FC7D3B3129B7A0E4882851EEC14FCC21E285
      8B10E20E709D90B5B9D51625AE19F587E8C0C83DF635237695AE19BC29F39711
      EB13F78FFAEDE9AEFAF32EED310FDEFEA3A6F59C66B25A23589741DACA86957E
      251FF63BC661A58393288AEE3C4E4E3C72F9A13D373335CB90B477B3F4E6FA0B
      FCD51F596BAE94E6E5CDB00B952462920DDF6D5BD568D9F3595CDF83CBBC876C
      F9B1E798D943F01314F2560DE9607A0351ABB51933A5232ECEA13E076647B5FF
      68203E19D649AFD79BD10F5FCB8183C3711976E1D3B0398FD7F4D858E840BD65
      C95FC9465D5E4843FF1EC7B55B19E2E3EBDFD0DFD7B72934A48E3558479A375E
      865D884581CF065602AB8079400FFC003821BE1CDA3116A803376B6FB0DE6C38
      2462EDC08F5E2EA0C0A20C5C1ED1DAD812D8EC67D9FF95FD007629F0BF364C92
      FFA821B937D1E3671B6F93C914502BDA71E33EDE181C121287510726AA9851DA
      7128E25F89B09D98C0236B956A023583979F945A5F3FBF60BC3E545DADD13937
      6EDA42DDB8594B55BD86CD94751BB752D76DD24A5DAF696B75FD666D1CB6CE68
      523212267AF93398860C0F0F0FC6E0331CE7B53C940A85947DBC442197924A21
      25A6C854CC0D2865124228BAA88D586132320711B2C234A41B5EE0F26BDBAE1D
      D3DBDCBD7B77B1409EEBF88E3666DCF4F0FE3DB2DAAC50D72F4BC5C3C39D9061
      079183845DF0CB2AC12CC8000DA9C2DC0C2A851DCCE07082AE948AF1AA99C552
      8AEFD9E662B9FE25115B902C717626022793887138C01A1C1BB6006CBB021D9C
      2776F0A8081FC24D4F4F252D3EAD9298F48C6C561BCEA740D32195938B19570E
      87096B0C93D3C5B516DCB16D0C5E833D707CD6D205CB1712D41E77F3F69DBA21
      C1214ED89D20BD4E4F1CCEB06BB56A321AF4B8D7929B9B0B3D79FA348B35482D
      1A5F1E2362658491BD37F66163F1C1443DA60E024E834FC05C3684BD86862133
      E11D5264CDC6A263508BAF360505D1C913271E33222988CA5B2CB2A58E8C8C0C
      EBD5B367287E9254274E9C98846968C8FDFBF709AF7E105E374399591D248C0D
      EFDBD0B5AB571FF31549580036BB8B1EE16FF79E3D4FCF9C3E8D6F95DB44484A
      5E5EDEA43718C9D3D3833CF13E9B9FAF2FF9F8C04FCF96DCF0EBC21257047684
      4528372B08ED689C267CB1B4595818FBB60E915E6FA0ACAC74C22F12D60704F6
      D3444E980D24243CC946C555A4F9C78DF9863A243838AA63A74E8B506E4120C7
      6B90820536DEF87C998CD51BEE09AF8826BDF4F9277DB90B834E01DF2FF4E9D2
      A54B1C7E81B93D7FFC7159A9543EC1E744AD2C71794438D0FE18275C6F30F81D
      E240E4D4AC69D3762D5AB4680B0DE90AE556DE0BDE90E4ED5E48A8F1F3F1690C
      34825BFBF698FF398469C85AD0903511F58D3F43F0FFAF0CEB426188190A940F
      36E0FE1F1B56194CCD300DF9CEC43CB6E35F8E125E45DBFFF9E7C2B68103DDF6
      B66BD76867CB96C3B6B46FFFC92F6DDA4C5EDBA8D190251111B5261A0CC671D2
      D7A7EDAC16D8531D34EB172C50864546C6C4B6683138AC53A7F1517DFA0C891D
      38F0FD3A030776A9D3ABD7D0BA5DBA8C6BDDB265EF66356B46C68787B31F0D47
      3A76615F836536FDD2B9B3B68E46D3D248F4A1DAC5A58B292222D42D2A4AE11A
      1252EA1E1262F5AB5A55155CB366D5F066CD7AD768D366CCC0BE7DEBDD5AB346
      EE488C0B938866393949C224923A3ABBBD97BDA0205A2C2E56D98A8A128B39EE
      64B142718001EF1A9F84A67BC426BB72A532C6A4D1F4D6E7E757DDD0AE1DAB10
      921417167241987F1ADDDC5AE0ED5E1F106033C2C6152427E7E3DC7092292020
      1D3B9B642F2DE57378FE49E6FDFB41BA8C8C40BDDD1ECCE7E7B730592CCF20D0
      7389F4C50B99BFA76775854A155E9A9F5F58505A5AA87576F65048244139376E
      5873A5D28B4ED5AB67E1BD6C9BD46CCE782893E5A9718CA58A545AD39A9B5B5D
      53547471B18B4BAAC4989EAED3299591F8A2AD3A2F39F9E299BCBC47713131AD
      DD349A10BD2044165FB9C2156934E7E54141ECA48B3DB1B030E7E1FDFB0F03DD
      DD9D51C061128E8B2495EA2CAD6DD5AACAE5B66D973EEAD3E7D0959E3D87B489
      8AAAFAC39429939EAD5E7D2863E5CABBE9CB975FCFDEB1637DF6A347532E9E3F
      3F04EB931D63BCBD832F346F3EF141EBD6C7CFD6A9B37881BFBF99D6366C58E3
      5CFDFAABAFB76EBDEFAF264D3AFBA077B66ED4A8EED659B3A6257CF5D5DEE479
      F36EA72C5972FDD94F3FFDFEFDB4691FE223AD550D6AB5EE485CDCC0EBF5EA1D
      3B1113B362B6B7B717ADAC5327FA4854D4F2B37171070E56ABD66BA45AADC44F
      9253A7366D9AEDFAFCF3A90FE2E3F7DE1F36ECEEB53E7D6FEE68DC78D91467E7
      B02E12897A5F78F898B3D1D1C70E85862E996D36BBD392FAF583FEF0F38BFF2B
      2CECF0DEF0F04F977A7A3A436F4BA19F033E1E3DBACBB955AB665F1C30E0CF93
      4D9BDE3C5CA3C65F1BBCBD3F5CA1D355DF1310F0E55FC1C14777FBFA4E5DE0EC
      6CA4C55DBB3A6D7475EDB9D3D373DFDEA0A04D076BD468FD478B162A68456DDD
      3A75EAFCBC6EDDE04DE3C6CDD858ADDACF0723228EED0A08D8BFDEC363DD364F
      CF033B3D3C766E7675EDBCC209DFEE8B7176E6BED4EB437E3599BED9E2E979FC
      70FDFAEB6E4C9EDC64F5800126348B60ACB4F7183D6448F70FBDBDDB6EF6F2FA
      1A714E6D72733BBBD1D9F904D2CC5B6B34FAA31DBD3413B55AC51ABDBEDBF77A
      FDAEF5BEBE27FE6AD7EEFBB3DDBA0D5C101CDCA2578D1A433EC0D2FD28A5B2ED
      2A8361F18F46E3C91FF4FA73DF69B51B976934CD3E56ABCBBB89836DA9C9E4BC
      52A71BF08D5ABD69ADC974EC270F8F436B9C9C76CC35180ECCD2E9F67DA152ED
      58AE541E59A1541E07D62F57A9DE8F57AB5F5BFB7790C51B0CFAC56A75F32FE4
      F2855FC8643B17CB6427E6C864D7664BA557164AA527E74BA5BB66C964F3E72A
      954D676B3495D48F83A0E265AC46239BAC50042041FBCFA4D2B11F4A24CB470A
      C2F2D18230ADBF20F4EC2C08E15DE472A6EC2A267BB3BB2E3EE9D0552693B611
      045D1CC779C7709C6F0D8E73092252E317C0A131DE9CF295EF945D22C79C2E53
      8A058FE9E224D327E23876EF40C3A5EF24A814B8A82327B6C5467DB059DE70E9
      FB347D681DFA989AAD0B6544EDFB8CDDD26E8D78563349ACC5EE3B7F2B564A5B
      E9267A91A8DA3B82B35B6CA4C227FEB4BD6B904FB7DE83B6F6FE593C32A436BD
      D7AB06D52A7C7C740623DA31047335E6780561E95151D27E50BCE8DA3C3EBE43
      24ADF46C155FB59E3FF5097426B7F402B2477B716E41CEE48771686906361977
      1D387E71EBEF9B8E6CFEF3962F8574CFA667471D3FD7928F1B73561A5DECBD71
      B07C46CB50E29A8550706E31D1C30C12B5721264025959C1A5E793440D753F7E
      64BF8E871F52E3AED3B69AB7FCBEF96308B4BCFD1A9B2050AFCB92A12DBD2CE7
      12A8367B324E4D97DE4F232EC24C9C468EB78F4A4970D5128FC78A0516E2BD8C
      24F3339136D495B8DD89FE4129C3FFDA3074E8B002F63090C2345AD6EAF31963
      F6804030E0732EA9F9C40FDD4862466E4942A350B9764C037246D9894518DB01
      B6EFCE92E4D2893D8F685787D6487D5F42839E767AAFAEF7A07A01D428D69BF8
      943C12FD9D88E61E247BFA3721DF53F6FDAF6BEFB488BF5F91AEEA5885EAB389
      2E120A97FE3E9D497BBB2D80FB3E173918734E9B65E8FBD1D4B17315D2C3D3B1
      9C5A8831AE971E3B8E12D57EF8DD58D849761359B98FFFE7C28E9D8B28371ADE
      B5AE4E3232A327450E0E156F7E27727CD7A3BD27F66DB4061F1564B30332225B
      F841C6F08FF85FCED3835ABEF403EE03740A1A8033FEBC4242226A93C307084B
      B75F23D9CE6FC62FA3CB5F8D7594916468E2229BA0EEE4ED66F05CD195536715
      A12FA086900D2E2DDF31B0779C5F67B596594874E03651AB702210D1D105F5BF
      A2E7A7C64BA8D132C1BACE7B0A450CD81838F2FB831C476A258E1EB11AC253EC
      CC8D4C9204634F64594CCD236EEFE9FBF97B775EBA4185299920F903D947CD8C
      1C2369B642E434ED7EE839B836E79C857FDF83EAE7593994DA8807247925243C
      487364C9C6D65AF8D2EC44DAD7A33B1D1BDB9124CAC38C88739B6693A7CC134A
      F8C14F874FECE8BDFACF7B44971E6451AFBA46AA1FF0F23323DF9F250EB54953
      9BE3933B52B24DD945F6B425C61654927D0C241C8066E6518F39883E3829A5F7
      FFFA9E3AEC7A2A891E3E9562C6C54FDA29DA27EF14ADD4FD6C2EF9B4F88E1F9E
      7E62C06FC868E7033692E9DE03013395FA2BF360609E21CC414D569A43E78956
      FD14240CEFB75F2C2D52C25F43D5272E2543F03464C9D15CE0F70EE3DB9AA3D8
      A93C355DBD806A7E768C64FAAEEF88FD9620A52B93EACD81023BA481A9196B11
      12FC37A537C77AE9DBE76C350751CF53553E1E71AD415AE7636109717F18BEF6
      DEC8FBBC8CF1E6AB2351C5204FEC197DF2A40D6F767571F3F7F274AE1711E7DE
      36BCE5E09AE62AC7CC43144D58DC98EFD9C90FE6FA2F30EA568339F3D2DEB77F
      99D7B3F8CBB4C1B6667B0245A776F2892CA947BFCA1FA9627EE5187AB58E43BA
      21D76A8EF9E84ED3E3236ED64F98F5A293B828B38B35FE698FD2E8CD669B5333
      C50896C0A50DDED0618E37A1EFB918B6524CAD77F9CF9E91D8515C92DE57FC2C
      B1AD7D415A67FBE4075DAC6E3FA8EC866E92296F4ACBFC1C8999E3DAB7C9689D
      4481439CCEE4E5E675552A0467B420BB28E2A54E5EC1F9985C44FF38635D9701
      AA56C2704EA6182DB994B7C6C2923AC039AEAF2EED8F844BC552B2A63D2F6C5B
      A59AEB76B3DEC4E3ED204E8ACD70834A27EA1446FED0956BB475F1A9B30BA74F
      6F3131764EFEABA4E55625C263E74E7A74DB5FE7CEB8FB0D91ADE6D6F8C4F6F6
      E949ED6C75F6F85BA82EFD34B5F734CF5729CB7354EE4000F7F9A2CF9B4E9EFC
      E9748DA05A2ACF74F6B8C21F235F6717FE595E3A5DBA97CEF511C68BED4DED0B
      03A2FCD37CBD7D9F9CFEFB7431D2398C8308EFAB85E25CF691E62D9A4F4A4878
      14F3F7E5B3AA8C5BB97CBA35877BACBFC7E53D3572F1BE5F53F380667C60F540
      1FB956DE45A955F6C58242FE25FC6DDBB64D9030BA8888082FCCF5A3B0045D8A
      D7ED28E95992902E3EE18293AB53DEB960AAA9A94D8281A72C5D263E5FACB215
      17165B535352BDB0E3DE1BE9D76115DEEE289B59B36635C00ACD31A3D168C5D8
      51C01E08FFE0C17DF1DAD5EB64C9B5707A379D1810148857842474E1E205F64F
      70AC5860C14ACEBDC3F81C542B90393A20E13B3472CC9C87633746860302B6FC
      FC7C8E6D1786848690D1CD88C5032FEED1C3471CDE4824CC1E44994C2660BF5F
      C07F64BA8AC3049B4F9F3ECD0978AB909B3A756A064E189EBA7AF56A38D63FBC
      D9A238F6F96D32A90C2F50F1DC86F51B084B1AF87A114F0216B45353538BB1FF
      B60D044B20CD33FC1B1FB6F203E72BD3B97367369C1B8BB9FDA4060D1A18406A
      07B9B87EFD7AB6E5CAFE851CCBD605BCDEB812E7237E47B202A0B2419E1D7D8D
      F9A2F0AAC4C7C76FC34955F1D6AD5B224ED88BFDFBF77F161212B200E1414099
      719471D9CDBFED72C2BA75EBF6C51B99D7EAD5ABB713919A02EF4C88F0CA66F3
      E6CD3C7C1860911C978AC3E0327F78FF07933333C2D150D37A9BA3D306989F9F
      EDE8FC3D4B223E6DF15689DEC8CE4776B6A7CD8E93CAA3FDBF32F56A66F6F250
      775CDEC12396F339246E68667A23D96B44D93F7414B4DDE68BB2829C65AA20EF
      26BC019F4FAB11E6149E5D38FFE9B2704995A65EFF99A86056146F18B8CB96B7
      A0CA287574E408819797DA1333A49C8FB7B5664DFF162BA7DFEE1F35ED9AFD5E
      0797D7C8CA2512BFA9CDA967DEB05BBF8E6EA3F6F05B21C8B4563BFEAF165760
      E5EC79259C362250ECDFD07BD6BC20A957C8EE34871264E5568672E6C4793578
      EF6917ED4FE2C3E22572FD441793592D91C844C727D159328DD2567A3D49F2FB
      8EBFBFED73BB60E8ED79515CF8B41B2CC4C1552E112341A314B8EA31B3ADA1DD
      639EDEB9B78F8AB14C5864B751898DB8420B2F0BF2B2358F0D1B30C643D59A91
      1CACFF4F16CB881C92A1E3DA7C3A6EB06B922E66288CEE2C6B2496222833930A
      8E9CE5D21F3D15F5323B5F4B523C5CDCF1BD50B77D74597A9238E42262227238
      68D124B26ECB3E6754EA4E5117979A84943B76BB4485C19E88FFC868179F44F5
      1712849B85BFFA2A73AA36EB6BACDA7950FAABF42F899886843EDA8263535157
      2F5DA4AB771FD0E302BBD8C8CEF1A1B66451A62E248949CEB9C435123DDAF750
      55E9F7BCFFD5BD5B9B8E1A3664CE376BBF5DC734A443B48A1A322024B454AF55
      D96F156AE9375943F177B70674A6D497AE460E1139BCAB2D29C8C1A1BDB4D2F4
      8C4CEF948C2CA621B15EEBF6760DF9101AF2EAD56B945150CCB97A7889E121C1
      C45B0AE9E2C58B4C95FCF71AD2C3D393C3AB2EE4E16C225FB30BF7E0CE4DEEC8
      D163FF3B0D8925436C23F1DCFA0D1BE9FE8307FFBF862C6B59B0FF571AF2D0E1
      23E80344F367CFE67FF9E1FB114B977DFDC7E2A55F5D99BB68D1D9E99F4C5D37
      67E68C5870137ED21DF198FB4DE05B346D221EDCBBD7D5DDCBEB70B15AB7CCAB
      7AE31AFE75BBE83C6B7775D7D768DECB22551F1DD2AFF7474B962C11BB74E9FA
      5632FE976FD7495FA4A6FD2AF7F6ADD3A879EBC716D333DB99DC1F74C7B2BE93
      DA5D5C1F6BEA764E730DABFE7593DA357A6FDDBA05FFD86DDA1BC978855CD6B5
      40A16E1259B56642B04EEDF424F79681824F39DDB36F34E7A7E5CAD572B77C5D
      F55669C155E3A6B76B58D76DEEDC79AC83BF963BFE69466667B54B60EEC594E3
      EA2FFE5EAE7898734F70D5388B0A99CA7E3563ABE1AFFB8B5C2D3279814B6875
      DFF3972F36610C182370CCAE08A171CB961F69BC6A684E676E5196061ED3FBF8
      4905ABA5847377D672E69014F5F9C4BD6A776BC7020D27C89FDD3C7333392DF3
      047B49A52289C33D67D1A23F971FB8FFA2F7D6692F1A6D0FB736DD1369FDEC49
      7B7BDB3FC36DB57EF3B7067EE16399FEC7A567F16BB715057838CF74247AC385
      9B3665D297CA6A2D47599C5D1F956614CA2EE7AC37C6B5BD63DA7BFCAECDFDD9
      C26751FEFE82B3D95BF274DFF78A65F3670C01C716E035C37385D9DF173FBE62
      259B42A575092D91081ADB816377EC99CF457BA8AFAFE0EE5BD55A9AFC5873EB
      E481D490F0F022FF5A0D1571D5AB3BF458453647A10DEDD7EB637D50CC57F298
      B62F8A7849717E76BA548B7FC2EA6CC2D72B531E6B6D770E6BB03353929B53C8
      5FD9B571D6B77F1E9FF7D5EA9FF97123FAD9CBC8789C79E0D6FDBC7E29979130
      3C7DEF3716D99D13AEE6926CAD3AED9932F9CF9FE57F2E9FFCDCC9682868DAA1
      ABB48AF689F453E7BB9F1EF6A62E8CE4FC8AE0D7242B230E88F0F3185DBB7A95
      655141BE5F2AF042AC87BB77BD798B97661EF8F65331FF58778BB8B3AB983FC8
      AFF8742CDF8D25BAE6F972F8C8DC0EE037AD123BEE1DD94E0CF3E03EEDD868D2
      C5F6AEB9E2A68EA2F5EAC8127177575BC1B0A09253F80F198EC46FB87078D5C5
      41C0C2305C2E771F08A76619DDDCD3C5F5ED45EBB5511671CFFB62EAA830EB37
      B3FA2EFE6E429CFEFF69EF3D00AB28BAF6F1B3B7DFF45E492040E8FDD26B0202
      A17704A54897A6280A1694A0202A8A05014355AA541B1D84489162E8BD438010
      20094948BD6DFFCF999B7B4925A0BEBFCFEFFBBFC93C7366CE9C39776676F6EC
      ECECCEAC43903396843BEDDC14C13BD2AD5BDDA9B9A195E706DFDE8DFCE46AC1
      C6AB7217D5828D67B267CD9CD2AEA4BC45F84953EB8BAA9FEE5CBBE9EDAE1E77
      CE6D9A23C7FE794A7EA15FDFF3B8BE8614C9F024C6CCE8F7C548EEBD9143074C
      7A6B4AFAF3CFF73D1E1E1E3E0B977AE7C2F914B8EA7A1666E68F3B37EFA0E8DB
      AF9F0F78AD807244C4F30144052CE492C52F7FF5F59CCD9F7D35E7F8479FCE3A
      F8972C64002C64AE8BE7D73EB51BD4F7AEDF0AEBC75A87B8D56BFD8251F30C16
      320116D22934AC49D3562D6ED4A9149655DEC7D58C6F883CD20594BBE6D2A8EB
      03FFA7B2903A4DEF6CAD73647943E31B5E7E3EBE5810AF4B77F6349B3C7D29DB
      C95595E5E69DE96AE850BA85BCF320A5BB145421DD352ED6593DFF238DD3B24F
      9C7DBFFBD8B3CCCA4FBDCBADFCDCDB7FC94C3F59A1C9F4AE020B79EC68241A97
      8AB390D2AC599FED55443C1FD661EB67FAAA97B779931647323D95B0410D904C
      672E5A68FDD77FDE91B2EF7AFCF2C9EB338F9DBF32839515C1C71F7FB2EBC3BD
      97EFC6464FBEFBA06D79737CC72AA6EB91E5CC971A079ACED77033FF5ACECBF8
      D14F2712DE5BB421BB42E0132CE41458486DDD7663949E4157A5A40427AB8264
      3C3C978C08A4E0D6D7DB49A3F12A5B5E7163DB62FDD7339E6021293B7589F1EA
      0973B6A4754AF509CBCDF00CB56679855872BC82AD7E6543156EE135CCB9306E
      E7F63D8385D4D5E970D7A871C9569155A9D7A8955AB54669BA7BD1D57A618F0B
      9EB43FBD857CB075BE91CEECF097E34F7A645F3CE87A7BFB2258C8B712BCFEAA
      856CF25F0BF9BFCB421639850A33D842BAFAF9B3C96D81B47264B79008FCBB9C
      642F4ED4F42D32875784F567522A065C5F2D64B64DE92874A8440C9ED582EF1B
      95AF432E1570CA235E9AF3B456A7E46B271C62421BC79E7B6FBDEC5DA10E7DD1
      BD02474BC56B3F5DA5E4AB2768D787B621B34351EBB757C9DE28D1371D134B55
      C202E3B6048812ED9EF982D0213C4E8878F37BD92BAC367DF97C6D8E968A096B
      4E52CAF593143B6BB0D0213CCED572E212D93BAC16CDEF9EC1D15231FA27174A
      BE7E8AF67E3E54E8101EE76AF1DA2294A8267DD1BF01474BC56BABFF44894ED3
      BE2F860B1DC2E35CCD5F8D81A25A1C7C6AA4A044FBBF1A2574088F73361B3F1F
      8A6A729032EEC70B5AD80B2A53C6C14A372A44890ECC192D74088F539B8EFD46
      28CA4CBA432BDEEDC2AC623160C6AF82CF4AAF9F3F457FCC1D2774383A24A69B
      B10CDD36DA3559AD3436E61865A5DCA5A56F7712198BF3388F9DEF508495ED78
      5DCAA628178AEC421CB60B17A190B3F344B138D278D46CD923A42AE5663CA42F
      DE6847AF7DB683D9222C02799E9DCF55BB7A3A8E0EC5BC2E74080F323E8D467E
      3E1EF47D80A25F2FB93AD1B337B3880387174CF44524C9A1081176BCAE81E9B3
      2005C249C03FE3EC252AA00D03D210309E039A00A1003BEE5C0711D8B568D1A2
      5BA0451D320A85C3870F530C1B3EFC1DE0167077F8B0A13F8C1A32E023068799
      0770DA3B2CCB9AEC79392C0001D761C3476C1D316CC8BD9143070D4466EDE091
      E378364B80C3CCE334966159CE2332C393A0919F0AEB105EAFB66479A7E9433B
      5CF38AC8BDE2D37E848A4C83485256451A06F796F366522FAB98B47D61F99458
      AD7B76FC5693D22919696CD98CF62ABDAB309A875F09685B3FD1AD9657A26BCD
      550AA2FAD8058E72CDD00169AD92889F4B5A89E2021E9D7E2120FD544AC5C49D
      71568D6A119E92CD510D1F3EBC1C9EC88CCC0C701F16EFD9303DC939FC67B52C
      D7CF31536E390F49DDBF1A495E28EFDAF324FF7957364161FD04B79A4B8D4A5D
      64201D19A14BCE5A8C27A92B94F5EAD5EB83A7BB9596CD99FF8EA5FBD743F172
      FAD82C93945BD95BD2C4BE408A166588CAB9E311651552C4C64BCA5B8FC8A893
      E4B0473A9FF83FA7745C5FD760E82F11A5A006D4426935FF86D293C66CEE87CD
      8071599254D82242FAEE34C92D5692346C0B49BED881AB9A0F4966ABA4C23BFE
      B216B29C272F6F042BF29164F37566CA4455F0D449C2B6B6D28D5492276C23A9
      7908D1A7914478A22EDD4C235929918456935896F320EF55D00015BC020EF525
      3CF3272D5274689B490D89025CF0C8790DD1A1043C9A56430DB414C884089728
      4996546108F34F5DC011603119CAB0BD1CC9EFED271AB98DE8C06D6C7A876F29
      4248469BCA12D105CE83BC15401359D13E8B42D5061132AA543F90953F0222F3
      4704F971BCD42614ED54467CF502AFF7632A5696312F6D95842C32E5E58DE5A3
      9682E4F1D5DA363FF35059F1E70CAD4F6BF4D0305411BBEF498A31F548724675
      569E2359ADC0D33722AD59A938E09B79F9B50E06A9B53ACBF42264DF57E26154
      AAC150D7599B961D6D51E9BE475BEE78A4F5C7C92A852A10597196A4D5E748C2
      737EC42415AA1517F8E8F4A0E0B463D680C4739BF04069219AE3F7279E224A19
      A78822EF14B15ACE5BA4924F11D4D2E6860D1FFEB74E5AA105A7090E02119B06
      282C6C4666E0AC9F519A19110A84B67C1E14E3C4A0D660B500C20076D7E1ED03
      762F5AB4E8366801A72A107B1C91105402326006D87198799CC6F1A240094462
      0955FBDF692173EC55FA5B1672D1A2C53394681F5848E99B6C3FD7E1E73C7B5C
      BAE75AF54715C98D6162F1091649756410A6B5EA102D3E45841330572D51689A
      CEBF9E49A95FE0A73A754A9565FEC060A8B74181A66F8B6E9FB8F2D3AF773D70
      091FAC91ADCDB24C940BBE70153C48F6C66B3222022F0B26586DB5366359CEC3
      79C16ECB8A8AB590481486DF6E21B11F241F7E94EA192D245EB9D7B0B2EF309E
      600BC961464916924BC4E90E48687E1835620BC94CBE82C0567390DFEDD7B049
      C155079647B01C1E2B7AA285744822A0798285E453842DE470C8090BA9365BDB
      48122E16B2A41019390160DB8462A09D602165599BDF4262F222A6540BD9B102
      DE207B48548A859CF28F584874C84DFF9485CC41ED6D6ED8FF390B69ABD73FE0
      2B5947BBB70EAEADDB61F4DB35DA8E9C5CEDB911E3AA3F37EA951A6D46BC52B1
      D58861418D066982AB753F79EBE80F7693CB598A807B36B9BA282BAD7BC7E03A
      675C5D9A3BAE1E5E10ADA3FC7C746DE5B713EAB8B56B5D79426068E837CD5FFE
      D5A948EE7C0CA14821494E2959B2F2329E2C5F4DB6D2C5FB163A71DB442E38E1
      9A57F1A096CD435A3BFBB84FCA97AF48502842BFE79107E9553C4E94488B535C
      A751D0FDD46CAA8229E0218DDD2924C0794091DCF9184211C7F9AC57A3C55438
      FB55AC087BCBEEB99819B6F6CFA4B0257BEF85D5ACE45F61ECD29399E3169FC8
      1A3437EE52E45BFBDE6F36F2673DE76508452811863D5860A350E0553C05A9F1
      921F970A3B73D3680C39FB3509A4FEC07BBDAA3B4DEE594DFFC9C05AE168BB69
      68BBB5683B0CC3886C8AA0C9CA6A853A19EB88504594C86291E961964C4F68BB
      CE68BB999C354F1136E8450C7945696C2552C26A60890BAAFAA4B673C62B4DC8
      6A2B11C663D8A3D7CCF12228AEEDAEA648B4EF5A2EA565CBA4E65F472E512249
      562A73CD45270E50635159ECCC51A0EDF418B5BB62E485D76344A9A1C7562293
      313753AD7025771DFA8EC6441E3A33793BA384D0545CDBE9D4D8B30D2FC0C292
      12DB6F56849E830B9F454E183423CED76826770C7EB33194439A4CAED8D86348
      CB608CEE7054F07A295F14D033082F6EE168604E0CB9F14407B24408126DFDB8
      497B112BE4F5F820CE64B19A210357288DA3D8321A8B48713410116D045AAC43
      DBA98A6B3BBB30A7611363A1A9F89FCA93CCC29748D0765EDC76DC163827716D
      B325726EA5C20D770966237338CEB45844BEBEFF77AC7A0A476F0A40DB65DADB
      8E8579AC8CAA65B83B6BF41B3F6888B665EE3F80924AE40BDD0F80521D8E9A33
      848C38DF410A392C91AABE70E1E237070F7EA9FDA04103DBE36DA828D0A87EFD
      FA47619385A8EEDD7B4675EAD4B55DA74EDD3A604FBB403737D7E3C52AC2CAC3
      EA1F7D346B6E7878E526C1C1214D0283CA340E0C2CD33820A04CE3B265C304CA
      952BDF243CBC5263BCF895FED24B83D6172A0BCE081BA7D36FBF1DCA9A3B7791
      71D4A851B96FBE31C9F8FAEB138D9327BF65C4BA02A39B9BBB3134B46CD6E1C3
      678CAFBDF6D6F79CA5D812E130571A3860D80B8F1E3D5455AB5659D9AC793365
      D52A9595B5EBD4527EF7DD5225D6FBE1F45352BF7E83D467CE9C3A75E8D0811F
      0B774889B55B15D8F51B6652ABD34B81FEFE7248682885940DC56ABA100AC0D2
      90909010F2F2F212B2B62E81538833DA71352F30D7626DA75F12A3CCE1758A78
      17927F4DC2B986350484F5917873C58FB03A11D2B063E85008D8CE7E0E302AA0
      D731ADAB563729FF2041725BB6D4AA42A9946A350C9E92EEDCB983B5D946F2F1
      F1252C9BC0992F14711652A4E2C4FD0D277259405EBD5A27CF9AE566C41A234D
      5839B9A91A1F075CB040E621AE02763CF16E220D1D361477EB12E12B7142119F
      3AAC497582689A8F9BDB6B9B0303E9EA94298486A6B2152B6A8C376E48FAE032
      4AE5E9D352FA071F90F7F41978D9DB4ABB76ECA0F2E5CB53EAC334CEEF38F714
      0F887CB481817ADF8E1DF5AE6DDBEA5DDBB7D7BBB56FAFE42F0BD2850B920E6B
      41DDF6EDA58C69D184B782A86AB56A54BD5A752CF77445895897CC1E491B89E6
      57F6F21AAEAF58515266659112EB425539390A95C5224946A38CEF1B4A1A94FF
      6E703029D6AEA53FE2E2085B3ED0FE0307CCAD5B7755FDF8E39A15B3677F3C50
      850BBA93EBA3472ADDD9B3A486224CB0108C2C767016875442BA7CDDC3832E8E
      194335F17140775757F2F3F7271717572E0AC093126868B4D1814326931F1AD8
      438995F7987CB07623AA192E49EE506ABD1B1AAA3CFDCA2B54A64573BA7F3B9E
      7CA12410ED89B739B1C255CD5BAD4099AD3779A0927E6835D79A98C53C4DE414
      87EA1A886A5CD0EBA5F57DFA9067EBD696B228959B9727050505E3B39A1ACBA6
      5F372B6AD6ACAFDEB061CDDA8F3EFA603074147121C7F4FA9337B55AB9A552B9
      1DA9AF013D811E00D32EA06D8197810F80F14065A088538CF2F21AD3CBCD6D06
      52C28127393421A94B124053890FB4AB57E8747C3EF115886D7B7EB00C83D305
      24360725697C5A7E7CFC4D3FFE15DABE7D9B18E7A4E31396D817CA91FFDAB56B
      A2173B188502789395FAF4E98B0B2A790B459CAE1BDB9E7408DCA0C77F0A046F
      D013FE66AEB327BA391431276DE4342C072ECF4181DB58F1ECE7C7D701112DE0
      A5BF37AC405C5120F63722FF98A20255735F309592F2958ADB2C3D5FFC494187
      A2E44F37F266ADD4B06143873CDE3726B6CF0E46A1C0FDF3E71D1C872207A750
      2063FE34CADDEE383A8E546DFB3E44117D1DF152DB889584FC789242B75F1199
      42379DA3A0C5BB8A282F5511E796F0B15B854A4D65D6FE896FD53A93CA3F88D9
      0520AAC63D18EF63E39A1500EB7AC1218045DEC467657CFB8AC4A55279FB9139
      F93EDDEEDB40C8DCB87183EC7FA2446CCCF1181E3658266C7BE500C600428EAB
      A374F3C00280446265A15B2FD9F8B8708A003C5122D0273AD964C21B00B974BB
      5F2362A5E67B0945E44B55A46DD7876EF5A8EDC818DFB99A08335F817B171181
      2714F1597FF7EE5DC21B99C461BC102F761BE0FD8D2D1D30EDDF71B0588A8F71
      1371BB219F700F121305654F28EA6333051CFFAB10E37A17E42E4744D5819ACF
      881A90E77CE554B090F711F95BEE3F6321AB7E91895229312B771434BF2B1C7F
      9C767898235CD0420E8A3250C77047229DBC4754DBFF713C7FA8DF9C823F207A
      767E81BF1AFEC714897E642FC5B26D4769D9367BECD9A84351DC48AC79C4D8A8
      E13358487C3BCBF16B0E450E4EA1C0B85DAE2865C18665113E306383396443A9
      8AB8BA36519B1F67A82F02F5B7C5D1D8C7879F9EA9B1E598A225135AE189123D
      C942424638BB12C3C8189246611806EE335B48BB12E47528E130DE1E6322F054
      5593A45142D85E121129E495AA888F0E8D8C2B5012D6C1FC67B290132B58E88D
      719A622CE451BC18FF80750A88C6EEF35F0B291A239F57EC18B2EADEAA369113
      36F234FEE13A87ED62052DE4D891E5A9163D674FA453B4AB40DC9180C0A8050B
      E03F76A5F6A3C7A24F0EFD638A54F97F67EE826B88162C3251E138448A710E45
      7186B8671E433E93857CDBB50ED94A5AB0187C6006D16A07B3D436B22B196930
      903C5226A69CDBCEE730A354452C64CFCC6146E138F3441B95662163D07E2CCC
      B08717E0F3BFF92DA450C46348AC34148DCD6348CEC0B874E912131A75D466F0
      E7866EA2B1F19D058FBD67B6900BB0B28733AA7C0398903D2E22795EA96DC447
      876539B3B4407228617E7E0B296E45D7AD5BABB78F21B11A0A8FFCAD620CC9DB
      38F13D3ECFC9620125151E436271258D1933361B03AD46A28DFE551692AB5F04
      98A77EE6FDC58B3436B66FC22E3C95FA63B9E7F49123467C85E7B85F75EAD4E9
      031CEACE685CD722BF9AC728A0081B26FDA5FDC559570145BCBF78C74E9DFA3D
      EBFEE24514E1B6F32FED2F5E4411E684DCFECAFEE2AC48C99E1D98A434B468D1
      A2091A568F23C76C9E4061FAC4FDC559C02EC8614C09FAB49BF0DA6B9F627EB6
      3A4A8769548548B7EE5A498ADD8F8D98107EEC454B33374F1382761E4E8162F7
      174FBB7ACEEAB9F4AD02A5B7E7019D0D45130B2802131B93B9976BD1BCF99BE3
      C68D7BBE554484073631A39D3B763EFC7DE957ABBEA8E1FC0ACBE4035F4E7B40
      D18D228A70822AB149504B6CEE168D6A36C6E7C1E4395F7F7D60EDBA7513EF0D
      6B900D251700BB3B01257539524411337127E955B76EDD573EFCF0C371B8A334
      CF9E3DFB8B83070F7EC269F2DB9D2A83DA9571697E42BC4457647FF1FC92AC0C
      989A9F5762188BB8FFBBBF7889AD43F419F68A78B6FDC59FA0EC7F2CA9D80E99
      BF344B162D7B03E7604D2A248907148998FA98326CC46013CB8BCB11074A026C
      789B88C816515A9DC621C28F367E8FDD7729E94132774A9BA29F7EDC74DE2151
      428095C0F03B52B14B2329B1ED2B9E6439785C226C0A5745ECF9E8E02220E3C1
      298A4E3A9D96CC2633388F1D3F53315B2C78DA273B982A5C39F0BCDF85727273
      1C4C0EB0B0BD5D78DA8C79A204C86BC65A193C54109776E633A4756B36CA952A
      5514439A34B386AEE5B8A1D87818A05488672478D2037DFC9A1F89A933AB150F
      153001B52BC1790A2BB043D9AB67EF687E7C939563A40BB91E446582C9D91F9F
      02737725A5032E08BB90C20DFB1779E01AE9E64261C19AD615CB6A5AFBB849AD
      EFA598EB2A7BF6E81DEDEDED45C9D944D7247FCC1EBB910AAF18A9D0986A3C1D
      C676D5E2B91187B919F8A2A0C4B63AD8E181B49880BF959843890F72074B2B97
      FF2087570AA7BD096A52868591A7BB0B998D28BF6C4515F1E227FA0FB717081E
      F9C800E19909F6E7C1C3F00CECF479F27C6A6C4A9AF90569F9B2D5B24FD92AF4
      7B9A3B798695C11EA2789BD668427B98F084C3F6BCC3DE0E4CF136001E906B48
      A396E9467C4AD68D9B19133C9DD58BA4854B56CAB97EB5E9AA36905CBD3C280B
      5534633903FF2E672C0C7CFF97B41A15594CD974FA54C2CFD9399621B113AB3C
      94A67DB95C7E18DC9874A165F0F33A7403A840CD0A2BB0C7D16CA4D7115DBF9A
      9072FD5ACAF8436FD75CC569D2E0991B6563988182CBFA50AE51C287C8985D3C
      2434148E3C99D0E7CE9EBE73303D2DA7DDE9E90D32585A6AFECE8EEF532477E2
      E76ACC407F63522CA047F0F1708B3BE3BCF3331B1F168CFFDB9EA8761C4E23D1
      69FE4A5DD160F571BCD98C804864888DA5BFF277342202C5C06356C21F97C8B0
      7B37D1B32A8392A3AD5BD3E31241198E273DB113B14C61B04DC9E3D9AAC61158
      3C87A25AB588060E24FAF557A2BD7B3995A8654BC217DE89962F273A75CAC6E3
      3CB61029F26841C24A98D3A50BFB36D8C3F6341BD7E13B8E9A61CB16A26DDB6C
      09CF3D67FB755BACA0CFA5DCB5CBC68B8AA2A31D3B8A367AAC68D326A2CD9B6D
      02767FDE3C7BC846F1ACD616C8F33B75A2A39D3B0B45AA3C169ED05A4A6F6C93
      B88439B260735F47F871897EFC91E8A79F6C09BD7A3DB96A1B36D8E4BA77A7A3
      3D7A3CA144F68665F1175F649F68E54A1BE5B41F7EB0854B3D6A7C8859941B96
      29C31EB6A7312F1F1E570D4FCE69DDBA7C494F11ECD3878EF6EDFB84AA3D850E
      2192AF6A8F8F1A77F7DEBD45FA537B9C274FD8A1E8A8BD51F312FE7F48CE75EB
      70317FB5ED71657E666961CE64C55B2343AAD79CBC70C2B9663B5D6E2C4B30CB
      FA01E1E1AF8B7E549A02477A8C5C766BECB06B32BF8D02664A6E2E7CA2016DBF
      A7A75714235743AEB300FDB67B50969B2933556D35E5D6E9F0CB70F0AA3C9DA2
      18590BE1DB80CFDE5D2FA4CAE989F77D79310918ECAAFDBCB572F11692530BE2
      5B447D76ED1E9CC54A1026CECCF4011ECAFCDE3EF262E98A6264BED57C89F0F7
      5CEBEF8341A8D5F63D9599DA9571BCF4AAC5C8179089330EA651D232848B754F
      5614230F42AEEF818B505205B444A728312546F6401A2B01A1FEEC3D09252B22
      5A9B97F13B94E6785EB84452BCA218F973E4680B24012F03A53AFEF8E6184871
      835E03AD0E8C053A00ECAAA334E738501A5410980B14762960D483929BA04FE5
      B86AAF4072097002D8087069829E4509F2FCD73D450B484F21535024465683D1
      10E8099401CE03179F4D518C1C884C6B0077A080CBAF488B141780BB04C63862
      D3164EE7B0825E981746F57A2F453ABE109E7198926F6E248DFE2C8535F205AF
      1CE5FDF145603AC2A38181C02880693FD011A4D20DA117E69FA3DE9FDFA6E623
      3680C7697C46701ECE0B96CD39818C04D855630FA80ED8AEE1E3B77E4B23D65C
      C79788BE058F5D6DF600FE41275087734668305007980970F55A8036A7E05A1F
      D26BBF5DA1810BE3C9A30C2BAE04FE22801DD740CF013B38323A2F32288F32E9
      48B39337A32427A9C9E04FC1E8037C002C0458E110502E0488CD39818C00FC80
      8F018EBF4B1DDE7D9B665C3F47E3B7EC03AF0130146099CF40BD00CEC3B208DA
      1C6B65EDDE880E04485463C08278FAF0F2796A37A923787D00BB2B47B6BF5120
      4E80C32911FA081806703B0CA31E1FEFA2414B6E52FBC93F833700E80B700946
      82F28F71537C84B01228E0F488F90301F4FEE9687CBEFA1CCDBCF90795A9130C
      9E3F1000F801BE005306E74114375868C8BE08DD20A2DB4005A01FD01C60D703
      76E91A074A830A02EF02855D1A18CF43C95DD0A772AC888F52654857056E036C
      258F408909E1FFBA7F430BB459D3260288A6BC3F451E7D2602051144B407980A
      082709FF19BC885511110425EDA3DAD3F66DDB29F68558A1437848782AD77C59
      F30882924E9D3B89772458D1FE41FB850EE121911A2D6E144D9842383CEC702C
      15F387F4088292EE3DBAE3830DD908621F6D9408F24287F0985BEFDB7A325320
      F2D8CBC76229DF1FD222084AFAF4ED43F6BDD8766CDF011639641D8A6A7C5D43
      7E71C08BB472C54A2170E69533B1843FF023084A380DEFF423887DA576EC641A
      6997E1884351E5CF2BCB6D9E6B23DEC8FC6EE97784BF4880DD9E9786BC44B76E
      DDE230FDB6EB37A69117275E8CA57C7F923D1C36334C6EDDA6B58856AC589116
      C42C10E191A3468ACFEE7064F76FBB99445E7FFB7A2C15FA73282AF341990842
      15B073250851B5EAD5043D77F69CA07BF6EC611A79FBFDDBB154CC9F4311A7F9
      BFE71F41F994212C9C5DC9BD0FEFC552097F0514B18CF7DBDE11944F995D49F2
      CCE4587AD63FCF499E11809C8708FAEFDF53B5804552AAB248E19C4F783CC235
      0176450E1A339F086F22ED2EBDD3FB2382CBDC856067801DE6E3993C05B235BA
      A057AC7287F12AD5BCF0BAF5065DF1F474D9D9F4CD307A654B08757C3748F114
      3A8488CED36B809F87C79A3FCDA666270382640D5ED8254FDF6024F6208572F2
      532B6AFAD6AEEDF5E69FB89DDE757C5A0D05491E2E4E30039FCF80A211F8B818
      0F26102CCDF19038468EC538E1243071528D9A515DCB579091AD2FC0EE290B14
      237F20C5C8A7E8F3A4C5C8A501D8B1A2173059AC44046BECE03FD1C5C855903E
      05C0E237A7BEF82C66B6129F2594487A079AD6837F1AB0289EA27F7C02417653
      30B06881C03C8B2CC75AB18905C2B38055C060C0E6BC8BEB1F7373BBA14DB85D
      7EB649F1741A7543B815500F680C74042214DC3FEE49CABE9794AA9DCD6BD59E
      165EB66C0012F450800745AA0F116637993D200E60A5BF831E030E015B805885
      BD7F1CB6985B5CF2F5C9D4B9B959C8DF0F69348B2426F433AA7441849EE029F6
      0C19F4EDE4F5EB8634A953775DB85AAD7773715152E3315D90A709F010B0970A
      C1929DA275D8CCA84FAF449EF31C7D6C424F55B5C91B8FA1C4EEA1DC0678AD35
      63184A632A39FBE314A5D4257A3565A777076BC095F0B6B52E2E7FD59FAAB54B
      24F7A0287AC38F4F4C0BD24A752A996826E9DD2A43B22A19B3EEE289670D79FD
      1B1FD2EAB13C9E04FBE99CAD3989F8107646963A00B7CD2DD0FDC076E07BE0A9
      5D7D4876035A0105FA07E2FF9893A08901F217DCB4DF938BCDDCE52DDB78E8D9
      55CAB2428E1BA32A2DA3B238013CD875726FFE7C8B5EA33FECD9FC58CAF3EB2F
      D7EB5CADE590C64155DB04B6ED32E8E1C5DDAB3372F1A0C79EF7C220E2B549B6
      688F0F63A43B174E2A2BB4EAD2C0D5B3CC38A5AC6D6A35AACAA5A6131E9F1A29
      E5EE7D52598C8F9CB5CA0B9229FDFB232B5E5ADEB95B5F6385FABD3ADEBA976E
      7B77C6A68AA8EBBBF35C151A5D54F2C3CC4AEE64CD4ACB923D14CE81B5B3D401
      8647399A604B760E7647301136A5C8F1D459E68785F826A7662B5FB6A45D9E2B
      454E9BD3DBA35CD3E79C9C3DB2BC9CE9AC3139E16AED60D75B6322EB3CA056AD
      B2E8F7DFDD829B0E6B21FBD419A80FAADC41A1D2EBE52CECDD289B8D6A955656
      2AD40A6FF9E2182968D2D2193AF79A63D54E1EEE7A1745AE4AAB4CD53B29EEE1
      AB39775C33EFED5FDBAFFE7294F856D3F11B8293EEDF43866AAF5849E92467E5
      926C92149E7A4DA6AF7C65BC5466DCF79F299DAA0C94D5CE3E562D2CB033BE01
      E9AC26953931F1EADEED5F8FEDD7EF9BB93D2B3D7AFEDB44854E7175E4F187BA
      0F33B2642F457636BE332B2BDCD5AA1C3FE3A5A14AF7DA7DFB28ACDE7524545D
      329BADB0BDA432A5DD956FFCF1DED5C513E7F5AEE69B3362D60FBE696EA6C957
      DDCABE97AED478925625915A8995C44A59A753642BD2AFAE93CA8C58B9584DE1
      BD64ABDA4D56C1626855B2DA45CA0EF2B2CE5A33B1CE57819232B5FAE08F2B28
      BC3C873F50395757EA5C83957AB70085A4C1C721B5CE9E2A455A50CEB53E52E8
      D00DAB948AB2DD2C390F94BC0DBC52EBA723AD5A767297729CF4D2D61A41F2A2
      EF86D7DE1A1860503C4A3C8A7DC21B7A2BFC8283955EC1214AF7809AEE9E5E1A
      1FF3DD6FA5B243D76CC1BB0A65B2EF1D596E3259429DFDDA0C54E983DDAD0A35
      B97A3B615DBF3E31D49B4EFABAAB4FEAB5D2EDF487B7B4B7AF5DB8B66ACAA08D
      3A22750E1624BF7D5DCE95827A8F1D674A4EB83970F7C62DB3F5928B7B9D0143
      5DFD5BF7563905D754EADC9D7C033D9521816AF272B598646B7A42FA83AB3B73
      93EF2FDEF8C9B8E378248D0E8E639AE7A0382F94475C836B869769FCF2C0CA1D
      3F99D964C0375F771E1733ABE7D899131B44F5690E110F008FF16525D36781FA
      5984FF33B21EE1CF291A4DBA8E11065A41FC0428DE026BD173A8C2CBC7AF583B
      25C4FE23DE52A2A0234AF5CBC0E70C8E3FCD0FA1F88FC590F1652F6C9BA56A1D
      F995B671C357153AF5AB75BCBDEEAC50297F6E4754F6B164D19043112B49B198
      DA54888C7CB162F76E527099327268B972146236C9F55D5CBAF693A4E9FD88BC
      31B850ABE6999A837E0EAC01A281FEA22F2C4575D0DB5E2EDBA2459FB0B163E5
      7BD33F545EDBB75FA1A95A55E15ABFBEC5EDD62D29C0595F1B1F3FACB4BBD9D0
      F1269D6B7774A40AB0153E285B55A0B930EAD595EAAE52C3FADD43478F3626CE
      9EAD3E79F5DAE50A0AC5D2B4DBB73BF98C1FDF4CE3EE6EF659BB46EAEBA2E97E
      6EEDEBB4B9C5A8D577AC9655581C7DC1543E02AD41B66D9AA1315C5BBDBA52E9
      E4A448397B56BAA850ACAD63B5CE7C293373D0913E7D8EE4346EA252B78B527A
      B8BAD3A8669ED4987EA09FBE883C64FA24F20A06193C45344F546D8442D95E55
      AD6A13F74A952863D32685323BDBB3B3249DFF3623E3F837972F6FD93EF58BC1
      219D9F73BADEB5BD9CD331CA5AD3CFAFD6C69A152B687D5D0EDC3E7DF9110A62
      7BBA7ED662FADC9C9AAAC02B8B4ABD97A7B9B24435F56AF5373144CDDD7757F4
      1FD779BECF322C7DB913E82BE92D568B8B8B0B95494FAF7468D5162756C21025
      C258EE519F4B9742348181F53C2323A5DCD8584BA0561390653435DA59B1C54B
      4921B5DD4FF987BD5E2D65AFAB5292CA1D3CFC479CD1A818B66FEF81B3ACA408
      B6E9F4B36F4E9B262745BF6FBAA95098AFFAF9CA5FB6E921EBA30FC7B3F08733
      DFAAF8CEFB13623A75695B9FE33DFA464A4C0B600D5E82FA1C46EA475797D9F1
      1F7F22DF7F63A2E9CFAF66C9B147F7CA33BEFEECF29091FD230B64281451D8E3
      9E5052119761EDA38C4989EF4E997D2D244095D1A13D7938B9CB8D6A56ADA855
      A9C77FF4E9BBFABEFDBBA97AF6EE2CD9F3154BF7625E72CEE8414AF5BCEC2F3B
      BDFBBDFCD3A635F29E7DDBE58F3F8B3E327EC2D046C8A4008A752A74EF3148B9
      005C6B2996E7C9E3A02F6A6BE88B54EBFCEC752ED6D315E7CF5B38F2F6CD7B27
      2053A25321652E90CFE12E43B63EB44ACABA33DF9C7413097C642D7DF171C2B5
      AB7F2A7160CA0FA1C643B80E500FB8062C04F6A0C7E682FEBF7752E19FC42A44
      398F979D474B24F1F1379DEC89DC46F6B0A0BCD074F9F265BCD257CF2B127831
      814880C76B68F02D248488DAB78F2AF0434514E5E4E4B0805E1A75546420B253
      8E72BB67D2F9D79C395200451421550F08F7C37883A0766FCB65CABF28CE21C7
      E90E45F9DB06EFFD532852276D8357C8319F5EB32D51CF9FE450F417DA869BC0
      A1CBA1E82FB44DF155836A4742696D8337A4215ED0F1EA5547BF79DAB6193060
      60412D88A9FE4ADB5CBE7CC9D111A14338EC2DF1CCFDC6D10442439EC78DED48
      7852DB447C79435FF50B74CEA80D9CD5DE1CC44BF496F594F04E27B3F3507869
      6B1E5B90272DAC6401D1461C48FFAC92988FC5A707382AC0E716B7A188E4F378
      39E3D105F918082A9D9D5DA2FB627A195FC895C68C19831751BDC1B6395E4E8D
      F78EF97BEC34F7904930590907820C5D2878413489BFA30BA649D83246FEE28B
      D962D6F82ED666E3BB10C46FF8F22BC2870F1FC6AB6D260AC4DE198D1663ABA7
      98A3221F7B05D6442EA82FF1E21C7BC365E39D623D46782C27C00AEDF1CB91AB
      B070AC3E06218F97780A21F65811D3A7C1A08DB25CB8C1399FE3A8E1B693E3D4
      B75F6FB696A310E901B0FDE638D7E547C463BEEF41D2F73D0C081674F6128BEB
      1494042379774868E8B0B1AFBE9D3663D6B707667CF6EDDE31AFBEFD28A46CF9
      D11850C5E6C940AC78878F458892AC6C1FD5F9DEC857A7DD7A20FB9FF9E968D2
      CF3F1F4D5A97A50DFAEDB549D1716DA3BAE2939BD26A28E35216AB894B340C4B
      605C5AB6EBA95CB0F36A8F839792A6D509D5D56D53CDB5E3CC1F2ECCEBFFC9E1
      A11DBBF4BA1B1252CE0B1A8603C53A56D4B747CFE7CF1CBA9472EFC8B987D4B1
      B6C70ABD5AE989B7862D5F0EABB484735DB89D71A073B7DEE74852F4E3787150
      81593728A47C4AECC1E4BB43DB057F939E635169949249A9B09AB56AC9FC6EDF
      B0C9E76EA7DEED542BCC82635F1BF2C53A56849773F9256759999261CA34633A
      4FA3B418554A8551A5A09CCB893997DD9CB5DC368C62953093151DBB137F2D37
      D437C06DD196EBA322EBF94E5492D5A854499959B972DABE93C93FBFFF62B5A1
      F8E2A01A47EF04672A0E529FE77B0D0D2913F2CA2B93A79F1C308B37BA246A58
      CD6BA82453D6E1F3293F70A61F26375A3CFB93F79BDE8ABFF1D9DA1FD68B7663
      3EC3D18F38E1D6ED5BC93B7F5DA55F36B1C1EA71DD2A7CE4E7A1D1FA7B6AF493
      FB569EB06A52C3659B7E5E5BE656FCCD4496E5CCC5818F1AF307EED8B1DDFB9B
      59EFE183B909E57A19BCDA74ABEBD9D52927BEC5979F4CADFFDB8E4DEAC6A139
      F2D257CA3DF86690EE55CE5018DC46845F4A40421B74B8A173E77CF63CC2F500
      769802A4CF91BE64F1B89007CD3A8FF439772CF6E33903758AF1CB73BE60013B
      24FBB966679444E70CD4BC1A5CA9F1CC86AD7AE8E3F66FCEB97561FF5BE397E5
      7CE568A3923216E68F5F6EFCEACEA543D1877FDF985DBF79279D7770958FBF1E
      A0196197B3B7913DFE440A659F265C3AFCE1DE2D8BB3DABC10AD532A55B3ED19
      441BD9234F43A16CE69C815ACBDA4FFB4D5528A5454F93E77F468647B5C2667F
      D3CC5680713524E99B33787B1B510E07AFB0CA655D24FAA37B41BE43E60004E1
      4A6DA33B99BCA922244B71D2AC93B2ACC7D0907FBD14D96293ED257BA6C35FAC
      A67F9A59A061FF8AF27F71D5F2F793BF52357B7ED5D3F693927EE4EFE62FA2F7
      FFF251FBD79D6B52991536DBF3561DDB81602B60EFF61CB6F79367B247D9169B
      B2FCFED3F693A7BEAEE5579E3FFCCCD7B5FC998B0BFF6386EDDFA748D57DD27C
      AEF24C78A30177C0EE5210E0445C1AA8A4B42990118EAB36A341B5B0B7E6BCF9
      82FBA2292F911D5F4DECEF55AF72E8BB65FC3C4B4C83864980707C5D1BDDAE49
      759AB73E96CE5FE76192E017F0C6CF5A55205E21C48FDA36AE49C72EC673493F
      E54405FA816756AE85AEDEBE4F9999197552531F96E5848FC7F7A1778776A1D7
      5FEC20C03C4E03CA5FBD753FC3763E9017F31952B737E7250DE8D8DC7BE7E133
      742F399579A5222CD8971AD6A8486BB61F8CFF79D618F1C30A8CD8BEDF052515
      4202A96FBBA6F462C716026D1BD7225F4F37C2A7C1A8699DAA05D22A4276F791
      B37C83F81DE5FD49AD46CC707675757B13778C0351CDF2797C0CF2E5A3168B79
      35BEEBE0A552AB319D2D1548B35AADDF3F7A94BEE4F785EF66721E56A4404007
      B8005A8047F856509E63CBC6D424829213BCC269AC20078A5896FE0F9FB4A8FA
      BFCCFD638DCDE71A25F0BACD27D7B039925F8549FFFA21D1BE44446EE11C1906
      20281CF7211128C57B3568F5EADEE8581365A256C5C93E9522F43805B686A5B0
      AFBFEE861EFAB64CD4A6B03251B5C24C8E4338EF6D0F6A6EC27A65E3A3479478
      FC38F9F6EAD53E7EFD7A17A473DEED2CCBE008D39220DA266CE1C2EEC9BFFF8E
      CF1F6690BB5E4FEDFAF66DB67AEDDA19C854A2A26948AC0660793729500D65C5
      850BBBB1921CAC0C3BF1DB6F079967C4F30194680ACBD9214A74E971EB778AF8
      E10703252490252787B25253C9AE64F3AA557166A20F90611B94D8F33B28F858
      1A9C1785C094EDFDFA4D6FB770A1211D8B2653EEDD23FEB8D499EDDB0F40C974
      886D038A752AE62E630F80A26DE82B81B923468C6DFAFAEB86F473E7C8C9D999
      1EE1C1AE84559210E12A33290205739649120910B9AEC4EB4ADEFBF71B7E9B3D
      FBA89B2F36017673A3BC36114AF0439CA50884A23C2E1E0B4951D8D3E8CB56AD
      5A4D59A7502CDEBF79F351EC172114E4C9944884229858CC56482D57AD5A35A9
      66CD9AAF223E0FD59C8F5F9FB26EDD3A9ED56294A88413EC8A6A76ECD871C0C0
      8103A781B918C029258C2C1F217EE0340ABC273AD1D828C1806DDBB67D03C9E3
      C05F72FF9819F94BBFFE1FCDF48F554D3476F50F8F9146AB2515A0D66888277A
      952AD500546102F025364E58C1FB1F998C4632E7E6921138FB5E3D243D7642D1
      E3A823340099270CE8146458B139819571C20AF64A82AA48822C0F309BCD1306
      750935C4C7E752FFA820C3F24DF113301860D115EC15075501269460FFF00943
      7A54309C3B87531589E9E946EAD7BE8C61F9AFD79EA8CCA108C39B0166A371C2
      D03E550D274FA642C56377F66C1A8635650DAB7EBD3401729CB082BDFC507104
      8903D0901346F4AF6D48C4760DDEDE5A6C5C9A434949E9687819DB6028E8ECD9
      87D4BEA9BFE1D73DF1C52A138A2C46630B28A3794B0F3B4ECEE686004372F243
      CCAE7BD0DE3FEFE6F1F98A86479D92D402055801389C8A4350320A03270EA24D
      B11784D91C976D95F0711735E5E05AC2871BDD01F3F19290C1A04CD0FC9E5064
      675861E073B2B244345D81EA69ACA493B46484FD66A6CEC98914BC2D03470AC1
      A1C86C3251665A9A233959A5A7147C1042A9C60614E8809C600275C6AEDEDC79
      399E1F4251CABE2594F9289D34357B39D252A028157B8D2831F3CB55B327A4AE
      1C4FE6C4B3443360FAEC4C50A12879DF6204B1E23CE10C6923DF16E134A59632
      3478520E09740BC1CBDD33932CF7CF8B70610F628F592C94B3FB2352367F0317
      69899CD4B092685F740DB2ECFF8CAC0F2E3C162E1412673F2C24B3B5F0C20067
      45D38913C93BBC12C236977CF992F58FCF3F47041714BA069A89230D22BA82A0
      F94B640127094847261409A1A28E6530A6289AF0EFE38836FA3BC5CA6B5FDBB7
      332296DC2BA00B8931601800BB3B8AC61D658F308D1DEACFC401D1D87C6A3838
      B680E1F97641069349C6D92FD1DA9D0936EE137CA10816B1884866A605A6C48C
      EDF65562B54A1181420CA1282D29899C30EAC89F9693638622234A241377C8FC
      6959D8669DC4D3EEC75CD1D8E5DED8431A9C57CE6EEEF694B84E2DC30C0F1EE4
      928F8F96B6ECBB7E1409F501CA4C4F8335C8A51B9F457294071F828A1271887F
      F551EA43D2EA9D388AAD9BCDC4CB5E24492D2E3FCCCCCDCEC26642660E168143
      11A7E0124439991984297898D924620BA9D1789009F60877937CEBC962C54254
      ADECC4DD3138E4F90F3735695CCE9070EF11F9FBBAD0912337B96A0E05E80A47
      6F7EDE5A7407E4137C313E8299D8C756B04B4F83A1668BAA861ACDAB18EEE42A
      295DE34C09F8E047A5C6950CE18D2A191AB4AE6E60399617B9F379A26AF88515
      48A41F96EE9ED07AD073864337D9DC2AF1A5081DF1BC060C3785FB68287643EC
      5194E04B9546B3229F0E1154091F1E2BE306DFB670F3843AC37A184E3C78DCA8
      15DC95F4E7F29F84128C0D5640BC88533127E3CF95381A16927C2AAD20AF708A
      9BBF6642E8CB030C97D289CAE1858C8B0B57082594727945D6E98D64BA7B86E8
      9B82A6565C7E58991D0ABF2AA46A316980BAC7A2B8A09DB2CC94E3CCB7CB3045
      0D0AE66506270030AC14025A0F3028EA0D7B43D1E5DB38A61CCF4379501D2094
      E4CB6BBBEF4703721A5A975C10E01E298116E7B2C17C0498ED4AF2F282F56F73
      A267FF9D42D9ABA6F83B4AF2E715FD6835EE8EB875D1DA51489C0E4CB1E0B6CA
      DE255560144EE35ED4FFF10D23E52F5114324FEF3379B28129F2B25210E1445A
      D709138A4B1302421132127E7DFAF3932619CEE23B23BD70D3C77148B0B2280E
      B7193AD470E5CA156A31608081E39C07E90EC7A526AB2D3A65D9A79F4EEF366A
      9461FFFEFDD466D020C38E65CBA67352A36EDD0C67CE9CE17D1169D70A9C2E44
      53989F1F2A7B0475DE6646647D4CCCF4885EBD0C274F9CA04A2D5A18788FD643
      7FFC41D8E08DAE1E3972146D390599B68142FAB103EF7184957191776DD8303D
      243CDC70256F5D9F06A3B487F1F142091A7DDBE31C8F4342D11DC4F91734A0CC
      E0B009B7EA7CAE8025B6EBE191037E88DB92EF718BDC9E8AC616C2F020281AB6
      92A7A7416F368B138F4F3E06F350F5E92C03D1228E0B606746E157A7B780123B
      63DFC387C256DB798D9006DEF4BCF40255543113BFC4647A57087280F10B94A0
      8A5338BCFBE143475A07C8206D3AF8051409BB120AEEF34451AFE38BC1173C3D
      65A61C2F47B090008799973F8DF3D84D09443046B475F3328854AA8FAFA60E86
      B206444310AF088400C1405843A297388D6510AF0C94294E911B12BC81C03CF8
      817A017C0DE7344F847D017BBA0FC26EF915FD6366048AFF65EE1FAB5A819EFD
      772AF95F45A5B79E2AEF0A122311194A177F2C21E3655260949DA3EC84909928
      BAD3C89186802A558218BEE1E141DE152A0479942B17E41916262887DDCB960D
      6230EFEE8D1B6CE416FC8CFCC285C3FF0227EADDC183E54B3D7BCA673A77968F
      B56B271F8E8C94FF68D9523ED0A285BCBF7973795FB366F2DEA64DE5DF9B3411
      94F3705E64170E35A23203893EC2295E4D709ED2BB43746E39D13B10BF0D08C7
      67379FE9FE88053D255896F3705E64C19D647E532038CFE8FDE38388FFC3A7C8
      3336EDFF03F1FF8C85E4BBEDC8A5F76380012D162650937937A9FE1797A8F6C7
      A7A96AF49F4FAC972A7F2A56677094AD0083C32BD87B1AA8F20BF16414C78774
      2F6B58FAD3CD274E17B25C7E1450C433569CF8F0A19906772D6B58B4EED2532B
      2B565176B699E2E3B36860D78A8625EBCE163B5DC83F981F0514F16D26279A4C
      56EC4E9143070FA650CFB6650D3FFC7AB15465050E7F85B7F6B19EB8E75A5430
      5CBB764F0C799851A37A10FDBAF3F2D1AB1FB7A8CFF1FCB09FFD054B949D2D64
      EE1B654AD53A8B708DF29EB4E197E3B63B48C129DE2BA808F7F72C764FED4CF7
      9C35543350475BD6EC114AD45AED0A4E2B09AAFC09F669C244B50BF9C3F6FEF1
      DD8F3625B8ABCEBD7D0AA2ED80E25D0145F6C3AFD2AAE87C0C46F892F425DF10
      679CDA60BB21A6378AD7026E0145B9A7D693A24A57BA3967C95139E9E297D60B
      BFAEE02945C895EA0A28329FFB59A7F0A8788E72524F598F2D3E83DC55809C3C
      3C04CD058A75051441C29C3775C87C2BC7F3C1827089AE403F2A51EA0909F67E
      F40491FFA9242E5A21F42D1417D35F25F1ECE52EEEBAD6CF9EF82C9415F54786
      1900531052C2E3D18A3DCE347F1CC9C5B8BC22BF08BA09E06AE4A7B5C0B3C739
      CD861A1AECFA873B8A1F803C9DDC5F3E457825C061102A89729A80FC9EBBA0F9
      3DAE5A3D30EA00F915EC427C35700A60CAF1C10863FB18B520453C14DD565C9E
      8D7832D42C4BAB519D35C05A205FD5B84407A03D10288DC6523535C4C4A03506
      77C71B118136F8ECF8578AA09B53D1525645032FF7C176B33E7143EEBD2E479D
      EFFF8856FA8C641D02059474D19334D195689117D142E05B4F923AEA88406989
      9781BEF78EEB7F738CFCFCF597650E032D8512F684A2CA78CF9D15C47812C578
      FA42C9465AE0150305069A8323F4ADA701BCB82E6707C91D4FBD2873183F1645
      4BF163AC0410474A7EC566E8C92C83453D221B47B6F574F574D9B873035FBA17
      E0E5FD91752BD4355CBB718DCEDE38739424CC8DA815DB58D801690C94CC7623
      7A8C9608C7353ED241AE7BA0B5CCE14ABB1AC961DBEB89307DE11645733DB086
      5FEFD0517CA09D96E863D7289AE91A57FE88410E39584B0E3C504DE6B8E0B747
      7AF1390B70B9AA2822DEBD1AACEB4D539CE2BCCF549499D2605D2F487A03283E
      7171589607FC601575FC73DC372A22A90E7556F6A161AA3841F1CD5AF0C28132
      00B7320E67811931B0FF4D4E497CDEF441B3F4710E1E3FE7759FD0D195BD0C93
      9B7B9E6A74CD89FA383F0248DA905DB4A7E79D978F2BB30ADDDE86A6A36FBD15
      D5F5DCE00EE8BD1D68954F3380A4DECE7625CDD179D7014C434139CC374179BA
      BEC781B061E4F06B13A7B63DDAF7FDDE5746BC8FEE3F0220A9A7E3BC5B8FCCAC
      343F7528C2934AD19B596B0D7C59381C4BF4B0AF810E7BCDCB9799498F2F8BF6
      435D980A31A279E8A5366CEB7FFAE5BB0D77B7BF1B75A2FF5DF0B7032475C689
      6C6B8F9628D18F00D3B2A01CAE9BA705E40B9C9436C4F53D395236EC7C4E7E2E
      AE8F4C5FB8C701C44026AE52B180863CF709CC860D717D8E0F178A5A1FE925D3
      27AE7100496D79F3082C8D95A4A650F80BC00A5B8172B8559E1690294E788707
      87FF03E7B86E4706C915D737906B6D692513E200492F3A140523F3AF002B7250
      68C8736FA0A74FC6A9F38E535CD34D1D64CF98F24219214ECC47BA14AAE4CC65
      A06433C06107CDD302325117436FE8E26884EA50E3ADED65CFEFCACB613FC264
      202EF848979AAA38737328D90A940322000E4750DE9F42C2AAFBF6FDBA1ADA8E
      ECD1285D9D81F77D8874CE5A6A35A463A3163D9E3390D16A900D7C8DA0FDC8D3
      01B84144B144C4E15872FCBDAC1E40A3D471D5FF6C2E7BEE2AEF40F8C18632F3
      09E9520351B5D628C50E80699824491C664B90A76A949A68A872000D51C6553C
      DD40F6FC13553B85AA212EF85D44B508197F030AD3903C2D7924009DB5AD6200
      0D50C495BD5447664A1C677E9E08C83E805D7E1ACA0C3B50242A473C5BD3447A
      83FA4971C494F09D3BA2F2E0B3A163ABD815E1C300D39AA01C8EA07C7F4A8471
      9E109F80F9E10FBE27804E466C394B0244FE8DEE1F1B1EABB8768AED9932D367
      85B5BDB364CF231491C56A8FFF656A5364B63834CBDDF8403DA53EF971456C8A
      4C1607475A9F54AC16B9B78FF8B1B7F679CD83C068603E300610CEA6C8681691
      A7F1AC5679F41BCDD6D26707FAB2B2C28A4CE2D75891FC52A1D38799F9004574
      3D771E1E473B2A2152C5E1572CBC51908B247964984339A20EF7FA2E37B96783
      E6B4F1CFFDF4799B349CC73631513529D7E410B407EC9A5FDDE6E26893AFA232
      C658B050D264CEC173DD82475A9448F9F9797B7EB2BE51CD111EB7D94928991C
      B99A3ED9D39FBEE99425812777A95F977E8D3B4E733A663A4A645334F3B4BD00
      4289F59D5AD2E89FF542C95B6D56D0A9D4E9B4E5E80591C65E474315119FD735
      CBA148548DB0C29405F2C362B18E7EABED728A4B7A4FB0DF6CFDBDA0EC1D4F8E
      C627210A562D4F9159620186F5A3464C2837D3BA64C6D61787B6AD1B22E2080B
      6AF78C99F4BD3DCCD456B549070B566D56530989BAE7E72B97387950FF88BA01
      147B3C9196F6B78481CF2E075E2A665573503704F17A91F0CD16410A79396B46
      5B86F69DABA0DD47EFF637668912DCA012FE6C55B3E0CDAE3C01EBD7ADF24282
      E4AC1D6B1D8AD018804B01F2BFC589C6FE3B85B537B6E2EF28C99FF71F53C497
      60813CED6EA05D816F802DC0A13C7098799CE6069EC863AF16C7ED259210E986
      D5F4ABBA74E9F2E99A356B5E78FFFDF7DBB46EDDBA1183C3CCE33496615980F3
      80D81CF7231D82A31B3468D067EEDCB9D5F0B53C77BC262CD6FB676666218968
      C78E1D1A7C2654B371E346CFE3C78F078C1D3BD62B2E2EAE3C12E703A27FE145
      424544DBB66DBB6CDAB4C950A3460D77BCA149FEFEFE347CF870602461F34172
      73F3A12D5BB6884D03588665390F324750DE1F97A85FE3C68DBD50648D116FA9
      32FFA38F3E227E236ACE1CFE41A20A156AD0EDDBE7F02A919193896539CF6FBF
      FDD60F8C6D809875F81E9B2678625B8BCAD83881AB4961616184D7D5A94993B6
      2C833734B5285998431106F539C8731389DF03C27189FED8B56B5760BF7EFD32
      3EFBECB3C8B0B0B0C0962D5BD2CE9D7BA972E5A642E8E2C53FA86DDB9634F1C2
      543A9C72D4947A2AF976CAAE9B6B90F807209CC43EEA8A232935C633FDF65151
      5135FAF6ED5B233E3E3EF0D4A953AE9C5EAB56AD47F846E4DDE1A96FFAF7EDDD
      D763D1C62517159B72AA5ABB68651A96C222C48AECE3236F68F382521E4F8722
      15B70424AA6A19A96F2F5754FA904A32F6E9DFA7FCBAF5EBCE925232E3FEF108
      0D4F190959A148810067D0836A00560E92CF7DEDBE35B24F9B5AF93822B867E3
      EE633436D5C091A299989B1F7C57DD4ECB732122438DBEB50D67D69E3C2A4424
      3A4A13D3478970A91E2BFACC8D6FE1893E74890BBA5E5D668A5B777C3910FC52
      15D805EC8A5ED3128DD7C4D068759CA01CE71FB0CBFDEBA834FCA3A4681CF6A9
      B22C4F03A2097FC7D38E13780815EFEABAD78D46FA54197916BDE3134DF89306
      4527C82F76F0BCB972EBC3B21CBF6FBA4F0C083E87B81F50C455D7575F69CFB3
      2C3A481C79DE9365DAA28D77A66213CE6992246186C7768DC3AF05EC7CAFD59B
      668B9C5B58D3AFBFA727204F59CE634F93FA4CBE82EBB805EFF729295761A478
      53BC3D6DD0D6772346E7982CE976869DEAD44AB70E3362E77B495ECB76CF6A28
      D82AF6D314699443B99463CD111F01669B04BED264B19A8D26F1C13AC230D3F8
      28C79489D577196E4E6AFE70A9F2013D8098CDA9AECAD788AB648B9208F35BF5
      B04D4AA3D96A7E9463C94A7E94FB303DDBC4CBF16496C36614CE780D9BCF518E
      0A881221F41CE00708871397ABDA78C3A15B6E775272725C742AA97A885B0612
      B17D0461588EBD162D96028AA47A9376209D06146ED8E447397EAE4E1A571C12
      EB8C8DE78F360AF7BAC0828C204FBDFFD86F0FEC4378DEE5F9BD40301A411139
      A0309AE5ACFC0D9B9291EBA652299D342A85C2036D12E8A10F64414046095DF0
      C2AA1A6187936ABEB699234336BF1B39343BD79CC6116ED80BB7537D121F6669
      BD5DB5BAF7561DBBFCE8D1A3639C6607DAF5A624492BEF2E1F2C58AABC12156D
      58525CF3F3C4131B0F9D1F8CFD5E7C1576110E80C8C41E7F3C118A3828205519
      F71307462D7FAD65E72B8919573020B7328321C30BF2D4F98FF9F620B7470CBF
      8CCA5DC34B0A21ADEC4A4E92071D5E5D0D5238DAB587EEA52CED83317347376B
      9190927D4F70F379F91BF6CE2F5329EBCE196AD4FF1C46FE16F439A54391429F
      E317ED955A75EEF6DDD935B9410B21000DEBCA0D7BFBE7F78512FE0D9C1AD10A
      855266CA7106D64AEAA74E19E37773FABCFBD557FCB97515330BC374FF625676
      C2D94AE01B19B8FADAF34C453C9AF8AFF5F07BD1AD87DF975BBD74FD43C4830A
      810F790078DC59BD413D00D7C8A177A6711ECE8BF8BFD4499A1003956B35815A
      548D721411FD231A982AC302C25A4653A1BF622D6483E777E21D6C572A532624
      BF38ACA617AC664AD9B3D9E75ECC9FC0E1EAFA6AB090B6F465D1C1381DD18F58
      119FEDE8BD1410C06D2B5E008B9665EBD4A866EE095D5AB9DFE1CCF9F1EBEF69
      C1DB0EA405E1F04F5BF749C568C29F6457C4A78A364C4F5AAB8650254A911F3E
      8585F484856C043538FB859FE765CBD994857F93D9C49CA7B0908FEFC8A5FA7D
      77381A560E93A2097F5C3A9CA0C37F7E3BF2C5A5EBAF07ECD89758A55E1DCF83
      6D5AF9FF8164F2C7893C26E6D05E84179DFDAA0B08DAA846D79FE5CFDF6D7773
      E28C1D65B5559D5E145C7838395BBFD832ACEEF22597EA7DF6EE73E96FCCD8E5
      F6F69B7566CB48CB7F225FF8A63B385054296A4334DA64EAA01EE10923FB55BE
      23B8F0EC1672C9BA4BDA153F5E716ED0C0FF70BBE7CA1C4212D94F643985E65D
      59D38B597869DE571DADF1D75C1BFE7CE5D15946DBA52735DDE895989CE5ECE7
      65550CEE85796057C59988EA7E3791830FABBC61D38D1A96CB723F94834F9D68
      C25FB116F2D28D47153C3D5C42F69FBC955AB68C5372610BE9FAC07BC6DC0FDB
      DE1CFBDECEB257767495A0878AB590B71FE6649DBC9A9EE2E9A9BB15E4E36A44
      1F2B6021552ABD66C20707A6824E63258CBF64217D1F952349C24E5FB285CE6F
      E62B1991F4B416D229D777DEE5ED63847173F6AE434E4056F209CA0444891ABF
      700147CD3AB57923FDD97611FAB3CCCC0779476C768DFD87B3ABF3E970685595
      682AE1AF540B5949D5FAF90F2684B1059D0A1DDF118997587340194650DB9C11
      5B39B676255948E6737AC490F80F90C9037005F4801A5000FF5227E1F4F85B45
      832515F9FFB13AAAEABCB18DD84242B33B5015EAFD012720CB4FEB2783D2FDDC
      FB12A8E081DE432DCE03696C6E1017CE5EA2503F376DD749DDAA0CDAF846B3D1
      DBDE6DF9E6EB6D0D6F06EB03973338CC3C4E63199645EE50C0E15408B9FBB86A
      223F1F5CA78BAB5EE5854184F9527CB671736C4AAD6675BD1E229D385C2E4071
      2ED84FAD6852C9AB4A8D1037BF094B8F29EEA7E5FC84743114E293B6D6A08872
      8D9CB42A770CB672550A49BD76DB6D7F5F4F6D96879B2A1382D85441D632EFB5
      4161192CC3B29CE7D31FCF5D43FA3E80A46AAFFCD26FC3A48801A231C0C1D0D7
      B9DF84BDF57A77AA9DA0D56B92B372ADD95919D91EDB769F0B9F3AA9F6F2D44C
      53BA5EA3D406C2DC0E9FFBC796735F77FD01D948AA3CF6C7919BDF6BFB62468E
      3985193AB5C2B9F3D0EDAD470F8B3890F2C8248AEDE9AA76FB76716CF32F3F6A
      B6283E392B81F0A5DD727ECEC1AF2D3A1477716E8F059C4FAA306ADDA0B593DB
      F4345B653332A6E6625CFDD6B43F5FE8D2A1F645A54E738F852C3946FF5FB79E
      ACFCE114C3F23B29D9497CDF19E2A5F79DB4F4D0E1AB317D96B18C5476D8EA76
      137BD4EE5DD6DF5D71F96E4602C643BA6D5BEF77D7685C74E195BDCFB2D0E58B
      C9D58DC68C9CA80E7E3FA5679BB3B1A9BBF641EA23CDD29D17B6DD5CDC7F07CB
      48C183977B7BBA6807BFD9DB10969461CEC8CC35E73A93B6EAFA9F323B366FE2
      CD8D49FB0F2697EFDDDD794B26E59E77D6AAB43E2E2A974FD6C55D4BCB342EBB
      F3FDC064A1C8B5760F52F956AAE25BBE56971E4D2B86540EF551BB3969F4878F
      E6861C39A669C8420DEB198F3432686F3DCA32665F884F32FDF8C7955B0FAE9D
      FAD5FCE0D28547277F641101257C1F4D60CDFAEE6D260DF2EE3DF775EFE7174E
      F1EE33FFB5C0C8A92F33382C7848631996E53C00E705B1390508777F1FD02080
      2F39BEA01E805B1E3C41FD004E631996E53C9C176CD86C9C3322F0573D9C9F22
      AB43A388FD9FF2FE8516B2DB6BE7083B7BF27A902AB09493D0DE914030704726
      796F7C56FCBA14530AF7173EDC59E0B3853C87A39D5EC44262E0D93337377B4F
      A08FB543A31A2A4B87A6BA447F2FB32A3B3BB397AB4ED1EBE3176AF5286421BB
      416128E070CAB07A23AA582CA6B54DEA7866950FD165A9B19563726AAEE2E0B1
      44AF21DDBCAE746FEE4D5F6DBE70BC71651F5FEC6DA008F5D1FB61AC5476EFB9
      FB469C9737EE1D5C99CBDA14E9E9699342033514E0ABCBB55864BEFC4A7FC4DD
      76AB5B4575B75A45A72417BD5AD5B6967FC50D076E5C4206BE65CDB55B4854AD
      1678C24935BAFE727D48BFFA266F2F27BE9613EE61B59FC71C089DFA6ACD3F9C
      DDD5D7D2B24CE930762E9FAC3F7EE7CDDE757D4BB49015DBAD33BEF7FA73374D
      16CA60D5ACE8C3D93BABCC9AD664E1DDF4EC04E695F575F61F3FEFF75B5FBDDC
      B26C8916B2FC731BAE8F18D828D7D3D3293333C7928D476D96A52B0E361C35A4
      D28FA453707530F8D4FACFDE70ECC1C4DEF5BD4AB29018D638EF397B2925AA56
      4DCD83A474539A56AD508796F14B3F75E651957A8D3CE2B94427AEDCB3D40AF3
      764B7E64CCC25544620B79FA46522EEE2C13399D81BD01DC3E3D7731BBA39777
      B68B93AB2A232BD76CAC5923F056ECBEBB952B84516260B07477E7B19BF7C776
      ADE7159F9293CA16D2452B39CFDD7BE91A14C5B1128612F7A6496A95F3B58799
      01FD3057E0E5E2AC242F0FB55996358AC3474D35F69EBD7EBB77EB50C2A0548B
      990DEDCDC414E582ADA76EDDBB726253F6B5FDB78DF72EB01E01EEB53EFE157B
      B76BD4FB8F751143EFDC8C1C76D7183934E14693FEC7D6F9B57A6754010BD97A
      D2204D600D0372FA009C17C4E61420DCFD392108E140E0BF16128DF04FBBFF65
      1612D5DF07B06B014F584DD03D301F9F6667675FC8CCCC40D4E6A4AE13CE9293
      93534FA55231B77C889E420334995E6E2ACDA5DBD9C967AF67721FA3EA61CED6
      4A65F4DE29E966637CA2D1F9DAAD6CCC5D5AC762726AE32F5F56179AA4A831C7
      ABA8D5CA3D118D02B282FC75263CE7B65AACB2BCE754D2A596D5BDC3596AEFD9
      E4CB91B57C2A2915B8AE4AA448B897A38E3D9CE864325922B7CDAB2BCE91622D
      E4D99BE9F7CA07E8FDD438F9181C661E944A6C45D99AB25565EB0A9E70C55AC8
      4D87EF5C6A5D3BA04C66AE0533A1D66C6CCCA03D723129B541255F97EC5C6B8E
      5A25A9B05D88DF9A1F8FBB9FF9A56B186B928AB3906B7EBF71B1759D202F0C05
      D35888C7907B4E243C8CAC1DE4F530C336AE7473527A2D5CBAB7E1951D7D342C
      231567210F5F48CC30E0D7D3B36C77DDC8E476F4D2838CFA95FC9D60C3C5A1B2
      E41AFD36FC78CCEFDAAE5EA244C55A485F771DC688D956279D9607F4F42035DB
      CA3C4CF81AAD566CF483AA5DBD91E6AF563BEFE6D2308AB59041DECEEEC7AF3C
      C8AC5BD1D78D85CE25A6A723EC9C96654E43E3AB1EA59A02AE5ECFC5CDB7DBA7
      9CCE503DB8F4DD05CFC0E6638E1EF798573E4CE7E51FA0BA87D9614B90879B6F
      ECE1872E2C54B5829B163C93C22AFBDF8937FB5FBB9EA3CD797871CCC3BBFBC5
      A1671986125EB116B269FFE36B1911B0966C35D97A368215656BCA7900CE0B62
      73DC7B9D10F401FE6B21D108FF29F7BFCC42629CB88D9B0256280AF4D92DA48F
      874A13772E43BA7E2797FB1685056B93EA57739193529FD142A6A61B75DBF725
      F8BCF262F0659484BE5E7927BC7D8BA0240F370D5EA678060B691F43960FD5A5
      30783CC93C287D360B59780C999C94133CFFBBCB5DFBF7AE7FE8891672DAA4F6
      37B26156F18B6230CA63C8AF67368BB9919499C83C1E43BEFAD68197470D6DB5
      CF6E21BD5CD51EF317C5367EA2852C3C86C463AE4A314B2FF518F442E343CF64
      210B8F218F613CC9BC67B690F63164F5AAD21DAEDAA97396F088168117797CF9
      4C16D2D74763AC52C92F69FD2FC676AC08E1045F1F9D3129C5FCD72C64EDA835
      DF31FE6B21B939FF45F8175AC827CD43A2E5C4490B1A00F045D47E97FDF4F390
      7C671DE0A16BCCE070A1BBECAE501C0A381C0F5B8ACC43A664E63E58FCDBE54B
      1FBF50338A25676C38B36F5AFF5A815A8C584B9A875460A85B601E1219157C47
      CD77D67C87CDE030F3380D7790C5DF6517370F397ADEBEDF3F1EDCA84E4AA6F1
      01ECCFD3DD65173B0F396DCB9E392FB70ACD6F214BBDCB2E6E1EF2E335471EBC
      DEAB9E6FC2C35C310F19E459FA5D76B1F390C72EDDD1F8B8E954417E9E196817
      4AB8FFD025293DC75CAF52B0B1A4794815EE948F2ED87AA606CF43E29508F5FD
      F49CACA6D582DDE7FE722C6574172F3F56F484BBECA39CCE50A59FD8989CE55B
      69CB8CD526FB3C24BEF3ABD1766F5AD17BC6AA8377596868FB1A7E2E4E1A4D08
      913FCF43C6FC7A251EF3905B310F99CCE976F038D0471354D3E0DE6672FE79C8
      096E2D5FE9C3B0DF657B8979C8C9835816997D00CE0B6273FF1D43DADAE13FEE
      FF7F2F07A52CAABC5FDD0000000049454E4400000000}
  end
  object ScalesImageList: TTBXImageList
    Left = 48
    Top = 240
    PngDIB = {
      2300000089504E470D0A1A0A0000000D49484452000000100000023002030000
      00F2AE03ED0000000C504C5445000000000000FF0000808080E6239CB1000000
      0174524E530040E6D8660000026F494441547801AD966B6EE3300C848780F45F
      01E2FB30400EE002D621774FD19B75BF911B24C56E1772525519EB418F872269
      57FAAE45EF52FCFEF5FE09BDBF4B1F1F800EB562EBB314DB9551294033241032
      6C00AB937DC32E42AA2BA0664808424D2A4A36DE10AEE9B6D832137D4A18AA04
      538A096B4A601B269A6C162458623B714731B40BA3EC5029C483001626FB92B2
      226E4BA1AF034DF9BCBE45B4CC2F7C4CF19435908D6182D54C8F6E2B02505740
      8D28288150A2D65057469A6E8B2D132D1BA0E269F3280148BDE1355B4DFD86B1
      EFDDF918A9F94C5350298163F1F543436461250BFB09089A8AA119D2D087896D
      677EA30EAACEEA275D0565818F6C26BB4969EFC2E7E39D21C3663C7CD747C6C1
      0705DDD542EE708AEAB1070EE389FE17DFD9FA28B9803E7FC0DF2B7C51D087AA
      B4D2697F439D9257727494155236A8F48AB47B68A54F3E4EF0E9D0E211AF8382
      3E026A22EB6BB88AE6DC43C1682208BBC9432820A3DB5F2E4FEBFB572A73A6A4
      1EE2F09F54B1C9FEF449ACC921B69363038480A28B831290522AEACB8AC9249D
      6A92FCAD511F6AD4875A1175E17CD9AF9CEEB26232CFC7C3777DC34FE0C6477D
      3044DF91AFC883BF50E1E7D9BAB88EFAF8017FAFF05DEC2FD9944547FCAD29BE
      1FBC919BDFCD86E8B711AF6B36385E4C663B55E68283737CDA9806C5CA9491B3
      1A1E8FB8CCF5C5669952F2474FD5CD04E978FA4B22757635DBEEFE0ADF5AA438
      338FC6D49E1FF31749122C245DE26549F89A47CBCA74ECEEA0B956B94DF66D48
      F1A7E8357D777F1B02763E533BD2CFC4771CF608C00094D6F10F5A9A7E803CE2
      5973FD411FF735A6AFE51F049CBBA96E5E46F799F24AF53A1BFF8BEF1FBADD59
      9D6BF277E30000000049454E4400000000}
  end
  object MainPopupMenu: TTBXPopupMenu
    Images = MenusImageList
    OnPopup = MainPopupMenuPopup
    Left = 208
    Top = 168
    object tbitmProperties: TTBXItem
      ImageIndex = 31
      OnClick = tbitmPropertiesClick
      Caption = 'Properties'
      Hint = ''
    end
    object NMarkEdit: TTBXItem
      ImageIndex = 31
      OnClick = NMarkEditClick
      Caption = 'Edit'
      Hint = ''
    end
    object NMarkDel: TTBXItem
      ImageIndex = 30
      OnClick = NMarkDelClick
      Caption = 'Delete'
      Hint = ''
    end
    object NMarkOper: TTBXItem
      ImageIndex = 10
      OnClick = NMarkOperClick
      Caption = 'Selection Manager'
      Hint = ''
    end
    object NMarkNav: TTBXItem
      ImageIndex = 33
      OnClick = NMarkNavClick
      Caption = 'Navigate to Placemark'
      Hint = ''
    end
    object NMarkExport: TTBXItem
      ImageIndex = 25
      OnClick = NMarkExportClick
      Caption = 'Placemark Export'
      Hint = ''
    end
    object NMarkPlay: TTBXItem
      OnClick = NMarkPlayClick
      Caption = 'Play'
      Hint = ''
    end
    object tbitmMarkInfo: TTBXItem
      ImageIndex = 27
      OnClick = tbitmMarkInfoClick
      Caption = 'Placemark Info'
      Hint = ''
    end
    object tbitmFitMarkToScreen: TTBXItem
      ImageIndex = 43
      OnClick = tbitmFitMarkToScreenClick
      Caption = 'Fit to Screen'
      Hint = ''
    end
    object tbxtmAddToMergePolygons: TTBXItem
      ImageIndex = 62
      OnClick = tbxtmAddToMergePolygonsClick
      Caption = 'Add to Merge Polygons (Ctrl+MLeft)'
      Hint = ''
    end
    object tbxFillingMap: TTBXSubmenuItem
      ImageIndex = 7
      Images = MenusImageList
      LinkSubitems = NFillMap
      OnClick = tbxFillingMapClick
      Caption = 'Cached Tiles Map'
      Hint = ''
    end
    object tbitmHideThisMark: TTBXItem
      ImageIndex = 19
      OnClick = tbitmHideThisMarkClick
      Caption = 'Hide'
      Hint = ''
    end
    object tbsprtMainPopUp0: TTBXSeparatorItem
      Caption = ''
      Hint = ''
    end
    object NaddPoint: TTBXItem
      ImageIndex = 15
      OnClick = NaddPointClick
      Caption = 'Add Placemark'
      Hint = ''
    end
    object tbsprtMainPopUp1: TTBXSeparatorItem
      Caption = ''
      Hint = ''
    end
    object tbitmCenterWithZoom: TTBXSubmenuItem
      Caption = 'Center With Zoom'
      Hint = ''
      object tbtpltCenterWithZoom: TTBXToolPalette
        ColCount = 5
        Images = ScalesImageList
        PaletteOptions = []
        RowCount = 5
        OnCellClick = tbtpltCenterWithZoomCellClick
        Caption = ''
        Hint = ''
      end
    end
    object tbsprtMainPopUp2: TTBXSeparatorItem
      Caption = ''
      Hint = ''
    end
    object tbitmCopyToClipboard: TTBXSubmenuItem
      ImageIndex = 28
      Images = MenusImageList
      Caption = 'Copy to Clipboard'
      Hint = ''
      object Google1: TTBXItem
        OnClick = Google1Click
        Caption = 'URL to Google Maps'
        Hint = ''
      end
      object YaLink: TTBXItem
        OnClick = YaLinkClick
        Caption = 'URL to Yandex.Maps'
        Hint = ''
      end
      object kosmosnimkiru1: TTBXItem
        OnClick = kosmosnimkiru1Click
        Caption = 'URL to kosmosnimki.ru'
        Hint = ''
      end
      object livecom1: TTBXItem
        OnClick = livecom1Click
        Caption = 'URL to Bing Maps'
        Hint = ''
      end
      object osmorg1: TTBXItem
        OnClick = osmorg1Click
        Caption = 'URL to osm.org'
        Hint = ''
      end
      object nokiamapcreator1: TTBXItem
        OnClick = nokiamapcreator1Click
        Caption = 'URL to Nokia Map Creator'
        Hint = ''
      end
      object terraserver1: TTBXItem
        OnClick = terraserver1Click
        Caption = 'URL to Terraserver'
        Hint = ''
      end
      object Rosreestr: TTBXItem
        OnClick = RosreestrClick
        Caption = 'URL to Rosreestr'
        Hint = ''
      end
      object tbsprtCopyToClipboard0: TTBXSeparatorItem
        Caption = ''
        Hint = ''
      end
      object tbitmCopyToClipboardMainMapUrl: TTBXItem
        ImageIndex = 45
        OnClick = tbitmCopyToClipboardMainMapUrlClick
        Caption = 'URL to Primary Map Tile'
        Hint = ''
      end
      object TBCopyLinkLayer: TTBXSubmenuItem
        ImageIndex = 45
        Images = MenusImageList
        Caption = 'URL to Layer Tile'
        Hint = ''
      end
      object tbitmCopyToClipboardCoordinates: TTBXItem
        OnClick = tbitmCopyToClipboardCoordinatesClick
        Caption = 'Coordinates'
        Hint = ''
      end
      object tbitmCopyToClipboardMainMapTile: TTBXItem
        OnClick = tbitmCopyToClipboardMainMapTileClick
        Caption = 'Primary Map Tile'
        Hint = ''
      end
      object tbitmCopyToClipboardMainMapTileFileName: TTBXItem
        OnClick = tbitmCopyToClipboardMainMapTileFileNameClick
        Caption = 'Pathname to Tile in Cache'
        Hint = ''
      end
      object tbitmCopyToClipboardGenshtabName: TTBXItem
        OnClick = tbitmCopyToClipboardGenshtabNameClick
        Caption = 'Genshtab boundary name'
        Hint = ''
      end
    end
    object Nopendir: TTBXItem
      OnClick = NopendirClick
      Caption = 'Show Primary Map Tile'
      Hint = ''
    end
    object tbitmOpenFolderMainMapTile: TTBXItem
      ImageIndex = 34
      OnClick = tbitmOpenFolderMainMapTileClick
      Caption = 'Open Primary Map Tile Folder'
      Hint = ''
    end
    object TBOpenDirLayer: TTBXSubmenuItem
      ImageIndex = 34
      Caption = 'Open Overlay Layer Tile Folder'
      Hint = ''
    end
    object tbsprtMainPopUp3: TTBXSeparatorItem
      Caption = ''
      Hint = ''
    end
    object tbitmAdditionalOperations: TTBXSubmenuItem
      Caption = 'Additional Operations'
      Hint = ''
      object NGTOPO30: TTBXItem
        OnClick = NGTOPO30Click
        Caption = 'Current Altitude by GTOPO30 (~1 km accuracy)'
        Hint = ''
      end
      object NSRTM3: TTBXItem
        OnClick = NSRTM3Click
        Caption = 'Current Altitude by SRTM3 (~90 m accuracy)'
        Hint = ''
      end
      object tbsprtAdditionalOperations1: TTBXSeparatorItem
        Caption = ''
        Hint = ''
      end
      object DigitalGlobe1: TTBXItem
        ImageIndex = 11
        Images = MenusImageList
        OnClick = DigitalGlobe1Click
        Caption = 'Images available (F6+MLeft)'
        Hint = ''
      end
      object TBXMakeRosreestrPolygon: TTBXItem
        OnClick = TBXMakeRosreestrPolygonClick
        Caption = 'Make Polygon by RosReestr (F8+MLeft)'
        Hint = ''
      end
      object tbsprtAdditionalOperations0: TTBXSeparatorItem
        Caption = ''
        Hint = ''
      end
      object NoaaForecastMeteorology1: TTBXItem
        OnClick = NoaaForecastMeteorology1Click
        Caption = 'Current and Forecast Meteorology'
        Hint = ''
      end
    end
    object tbpmiVersions: TTBXSubmenuItem
      OnPopup = tbpmiVersionsPopup
      Caption = 'Version'
      Hint = ''
      object tbitmSelectVersionByMark: TTBXItem
        OnClick = tbitmSelectVersionByMarkClick
        Caption = 'Select by Placemark'
        Hint = ''
      end
      object tbitmMakeVersionByMark: TTBXItem
        OnClick = tbitmMakeVersionByMarkClick
        Caption = 'Make by Placemark'
        Hint = ''
      end
      object tbpmiShowPrevVersion: TTBXItem
        AutoCheck = True
        OnClick = tbpmiShowPrevVersionClick
        Caption = 'Show previous Version'
        Hint = ''
      end
      object tbpmiClearVersion: TTBXItem
        OnClick = tbpmiClearVersionClick
        Caption = 'Reset'
        Hint = ''
      end
    end
    object tbsprtMainPopUp4: TTBXSeparatorItem
      Caption = ''
      Hint = ''
    end
    object tbitmDownloadMainMapTile: TTBXItem
      ImageIndex = 21
      OnClick = tbitmDownloadMainMapTileClick
      Caption = 'Download Primary Map Tile to Cache (Ins+MLeft)'
      Hint = ''
    end
    object NDel: TTBXItem
      ImageIndex = 22
      OnClick = NDelClick
      Caption = 'Delete Primary Map Tile from Cache (Del+MLeft)'
      Hint = ''
    end
    object ldm: TTBXSubmenuItem
      ImageIndex = 21
      Caption = 'Download Overlay Layer Tile to Cache'
      Hint = ''
    end
    object dlm: TTBXSubmenuItem
      ImageIndex = 22
      Caption = 'Delete Overlay Layer Tile from Cache'
      Hint = ''
    end
    object tbsprtMainPopUp5: TTBXSeparatorItem
      Caption = ''
      Hint = ''
    end
    object NMapInfo: TTBXItem
      ImageIndex = 27
      OnClick = NMapInfoClick
      Caption = 'Map Info'
      Hint = ''
    end
    object NMapStorageInfo: TTBXItem
      ImageIndex = 27
      OnClick = NMapStorageInfoClick
      Caption = 'Map Storage Info'
      Hint = ''
    end
    object TBLayerInfo: TTBXSubmenuItem
      ImageIndex = 27
      Caption = 'Layer Info'
      Hint = ''
    end
  end
  object TrayIcon: TTrayIcon
    PopupMenu = TrayPopupMenu
    OnClick = TrayItemRestoreClick
    OnDblClick = TrayItemRestoreClick
    Left = 520
    Top = 112
  end
  object TrayPopupMenu: TTBXPopupMenu
    Left = 520
    Top = 144
    object TrayItemRestore: TTBItem
      OnClick = TrayItemRestoreClick
      Caption = 'Restore'
      Hint = ''
    end
    object TBSeparatorItem1: TTBSeparatorItem
      Caption = ''
      Hint = ''
    end
    object TrayItemQuit: TTBItem
      OnClick = TrayItemQuitClick
      Caption = 'Quit'
      Hint = ''
    end
  end
  object tbxpmnSearchResult: TTBXPopupMenu
    Left = 160
    Top = 264
    object tbitmCopySearchResultCoordinates: TTBXItem
      OnClick = tbitmCopySearchResultCoordinatesClick
      Caption = 'Copy coordinates'
      Hint = ''
    end
    object tbitmCopySearchResultDescription: TTBXItem
      OnClick = tbitmCopySearchResultDescriptionClick
      Caption = 'Copy description'
      Hint = ''
    end
    object tbitmCreatePlaceMarkBySearchResult: TTBXItem
      OnClick = tbitmCreatePlaceMarkBySearchResultClick
      Caption = 'Create placemark'
      Hint = ''
    end
  end
end
