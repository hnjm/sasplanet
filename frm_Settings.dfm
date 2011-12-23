object frmSettings: TfrmSettings
  Left = 293
  Top = 114
  Caption = 'Options'
  ClientHeight = 446
  ClientWidth = 658
  Color = clBtnFace
  Constraints.MinHeight = 473
  Constraints.MinWidth = 660
  ParentFont = True
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 658
    Height = 415
    ActivePage = tsMaps
    Align = alClient
    TabOrder = 0
    object tsMaps: TTabSheet
      BorderWidth = 3
      Caption = 'Maps'
      ImageIndex = 8
      object MapList: TListView
        Left = 0
        Top = 0
        Width = 547
        Height = 381
        Align = alClient
        Columns = <
          item
            Caption = 'Map Name'
            Width = 130
          end
          item
            Caption = 'Cache Folder'
            Width = 85
          end
          item
            Caption = 'Menu'
            Width = 110
          end
          item
            Caption = 'Hotkey'
            Width = 53
          end
          item
            Caption = 'ZMP Filename'
            Width = 100
          end
          item
            Caption = 'Enabled'
          end>
        FlatScrollBars = True
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnChange = MapListChange
        OnCustomDrawSubItem = MapListCustomDrawSubItem
        OnDblClick = Button15Click
      end
      object pnlMapsRightButtons: TPanel
        Left = 547
        Top = 0
        Width = 97
        Height = 381
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        object Button15: TButton
          AlignWithMargins = True
          Left = 3
          Top = 65
          Width = 91
          Height = 25
          Align = alTop
          Caption = 'Settings'
          TabOrder = 0
          OnClick = Button15Click
        end
        object Button11: TButton
          AlignWithMargins = True
          Left = 3
          Top = 34
          Width = 91
          Height = 25
          Align = alTop
          Caption = 'Down'
          TabOrder = 1
          OnClick = Button11Click
        end
        object Button12: TButton
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 91
          Height = 25
          Align = alTop
          Caption = 'Up'
          TabOrder = 2
          OnClick = Button12Click
        end
        object btnMapInfo: TButton
          AlignWithMargins = True
          Left = 3
          Top = 96
          Width = 91
          Height = 25
          Align = alTop
          Caption = 'Info'
          TabOrder = 3
          OnClick = btnMapInfoClick
        end
      end
    end
    object tsCache: TTabSheet
      Caption = 'Cache'
      ImageIndex = 1
      object flwpnlMemCache: TFlowPanel
        AlignWithMargins = True
        Left = 3
        Top = 163
        Width = 644
        Height = 25
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Label30: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 173
          Height = 13
          Align = alLeft
          Caption = 'Number of tiles to be cached in RAM'
          Layout = tlCenter
        end
        object SETilesOCache: TSpinEdit
          Left = 179
          Top = 0
          Width = 65
          Height = 22
          MaxValue = 10000
          MinValue = 0
          TabOrder = 0
          Value = 0
        end
      end
      object grdpnlCache: TGridPanel
        Left = 0
        Top = 0
        Width = 650
        Height = 160
        Align = alTop
        BevelOuter = bvNone
        ColumnCollection = <
          item
            SizeStyle = ssAbsolute
            Value = 200.000000000000000000
          end
          item
            Value = 100.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 20.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 20.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = Label15
            Row = 0
          end
          item
            Column = 1
            Control = NewCpath
            Row = 0
          end
          item
            Column = 2
            Control = Button6
            Row = 0
          end
          item
            Column = 3
            Control = Button7
            Row = 0
          end
          item
            Column = 0
            Control = Label2
            Row = 1
          end
          item
            Column = 1
            Control = OldCpath
            Row = 1
          end
          item
            Column = 2
            Control = Button4
            Row = 1
          end
          item
            Column = 3
            Control = Button5
            Row = 1
          end
          item
            Column = 0
            Control = Label1
            Row = 2
          end
          item
            Column = 1
            Control = EScPath
            Row = 2
          end
          item
            Column = 2
            Control = Button8
            Row = 2
          end
          item
            Column = 3
            Control = Button9
            Row = 2
          end
          item
            Column = 0
            Control = Label19
            Row = 3
          end
          item
            Column = 1
            Control = GMTilesPath
            Row = 3
          end
          item
            Column = 2
            Control = Button13
            Row = 3
          end
          item
            Column = 3
            Control = Button14
            Row = 3
          end
          item
            Column = 0
            Control = Label31
            Row = 4
          end
          item
            Column = 1
            Control = GECachePath
            Row = 4
          end
          item
            Column = 2
            Control = Button10
            Row = 4
          end
          item
            Column = 3
            Control = Button17
            Row = 4
          end
          item
            Column = 0
            Control = Label37
            Row = 5
          end
          item
            Column = 1
            Control = CBCacheType
            Row = 5
          end>
        RowCollection = <
          item
            SizeStyle = ssAbsolute
            Value = 27.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 27.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 27.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 27.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 27.000000000000000000
          end
          item
            Value = 100.000000000000000000
          end>
        TabOrder = 1
        DesignSize = (
          650
          160)
        object Label15: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 194
          Height = 21
          Align = alClient
          Caption = 'Native cache folder:'
          Layout = tlCenter
          ExplicitWidth = 97
          ExplicitHeight = 13
        end
        object NewCpath: TEdit
          AlignWithMargins = True
          Left = 203
          Top = 3
          Width = 404
          Height = 21
          Align = alClient
          TabOrder = 0
        end
        object Button6: TButton
          Tag = 2
          Left = 610
          Top = 3
          Width = 20
          Height = 21
          Anchors = []
          Caption = '<>'
          TabOrder = 1
          OnClick = Button4Click
        end
        object Button7: TButton
          Tag = 2
          Left = 630
          Top = 3
          Width = 20
          Height = 21
          Anchors = []
          Caption = '...'
          TabOrder = 2
          OnClick = Button5Click
        end
        object Label2: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 30
          Width = 194
          Height = 21
          Align = alClient
          Caption = 'GoogleMV cache folder:'
          Layout = tlCenter
          ExplicitWidth = 113
          ExplicitHeight = 13
        end
        object OldCpath: TEdit
          AlignWithMargins = True
          Left = 203
          Top = 30
          Width = 404
          Height = 21
          Align = alClient
          TabOrder = 3
        end
        object Button4: TButton
          Tag = 1
          Left = 610
          Top = 30
          Width = 20
          Height = 21
          Anchors = []
          Caption = '<>'
          TabOrder = 4
          OnClick = Button4Click
        end
        object Button5: TButton
          Tag = 1
          Left = 630
          Top = 30
          Width = 20
          Height = 21
          Anchors = []
          Caption = '...'
          TabOrder = 5
          OnClick = Button5Click
        end
        object Label1: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 57
          Width = 194
          Height = 21
          Align = alClient
          Caption = 'EarthSlicer cache folder:'
          Layout = tlCenter
          ExplicitWidth = 117
          ExplicitHeight = 13
        end
        object EScPath: TEdit
          AlignWithMargins = True
          Left = 203
          Top = 57
          Width = 404
          Height = 21
          Align = alClient
          TabOrder = 6
        end
        object Button8: TButton
          Tag = 3
          Left = 610
          Top = 57
          Width = 20
          Height = 21
          Anchors = []
          Caption = '<>'
          TabOrder = 7
          OnClick = Button4Click
        end
        object Button9: TButton
          Tag = 3
          Left = 630
          Top = 57
          Width = 20
          Height = 21
          Anchors = []
          Caption = '...'
          TabOrder = 8
          OnClick = Button5Click
        end
        object Label19: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 84
          Width = 194
          Height = 21
          Align = alClient
          Caption = 'GlobalMapper Tiles (GMT) cache folder:'
          Layout = tlCenter
          ExplicitWidth = 187
          ExplicitHeight = 13
        end
        object GMTilesPath: TEdit
          AlignWithMargins = True
          Left = 203
          Top = 84
          Width = 404
          Height = 21
          Align = alClient
          TabOrder = 9
        end
        object Button13: TButton
          Tag = 4
          Left = 610
          Top = 84
          Width = 20
          Height = 21
          Anchors = []
          Caption = '<>'
          TabOrder = 10
          OnClick = Button4Click
        end
        object Button14: TButton
          Tag = 4
          Left = 630
          Top = 84
          Width = 20
          Height = 21
          Anchors = []
          Caption = '...'
          TabOrder = 11
          OnClick = Button5Click
        end
        object Label31: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 111
          Width = 194
          Height = 21
          Align = alClient
          Caption = 'GoogleEarth cache folder:'
          Layout = tlCenter
          ExplicitWidth = 125
          ExplicitHeight = 13
        end
        object GECachePath: TEdit
          AlignWithMargins = True
          Left = 203
          Top = 111
          Width = 404
          Height = 21
          Align = alClient
          TabOrder = 12
        end
        object Button10: TButton
          Tag = 5
          Left = 610
          Top = 111
          Width = 20
          Height = 21
          Anchors = []
          Caption = '<>'
          TabOrder = 13
          OnClick = Button4Click
        end
        object Button17: TButton
          Tag = 5
          Left = 630
          Top = 111
          Width = 20
          Height = 21
          Anchors = []
          Caption = '...'
          TabOrder = 14
          OnClick = Button5Click
        end
        object Label37: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 138
          Width = 194
          Height = 19
          Align = alClient
          Caption = 'Default cache type'
          Layout = tlCenter
          ExplicitWidth = 91
          ExplicitHeight = 13
        end
        object CBCacheType: TComboBox
          AlignWithMargins = True
          Left = 203
          Top = 138
          Width = 404
          Height = 21
          Align = alClient
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 1
          TabOrder = 15
          Text = 'SAS.Planet'
          Items.Strings = (
            'GoogleMV'
            'SAS.Planet'
            'EarthSlicer 1.95'
            'GlobalMapper Tiles')
        end
      end
    end
    object tsInternet: TTabSheet
      BorderWidth = 3
      Caption = 'Internet'
      ImageIndex = 1
      object pnlDownloadParams: TPanel
        Left = 0
        Top = 0
        Width = 644
        Height = 381
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 3
        TabOrder = 0
        object CBDblDwnl: TCheckBox
          AlignWithMargins = True
          Left = 6
          Top = 114
          Width = 632
          Height = 17
          Align = alTop
          Caption = 'Retry download if tile not found'
          TabOrder = 0
        end
        object CkBGoNextTile: TCheckBox
          AlignWithMargins = True
          Left = 6
          Top = 137
          Width = 632
          Height = 17
          Align = alTop
          Caption = 'Download next tile if no response'
          TabOrder = 1
        end
        object CBSaveTileNotExists: TCheckBox
          AlignWithMargins = True
          Left = 6
          Top = 160
          Width = 632
          Height = 17
          Align = alTop
          Caption = 'Store info about not found tiles'
          TabOrder = 2
        end
        object flwpnlDownloadTimeOut: TFlowPanel
          Left = 3
          Top = 180
          Width = 638
          Height = 22
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          TabOrder = 3
          object Label32: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 91
            Height = 13
            Caption = 'Server timeout, ms'
          end
          object SETimeOut: TSpinEdit
            Left = 97
            Top = 0
            Width = 73
            Height = 22
            MaxValue = 0
            MinValue = 0
            TabOrder = 0
            Value = 0
          end
        end
        object CBLastSuccess: TCheckBox
          AlignWithMargins = True
          Left = 6
          Top = 205
          Width = 632
          Height = 17
          Align = alTop
          Caption = 'Restore download from last successful tile'
          TabOrder = 4
        end
        object GroupBox4: TGroupBox
          Left = 3
          Top = 3
          Width = 638
          Height = 108
          Align = alTop
          Caption = 'Connection settings'
          TabOrder = 5
          object pnlProxyUrl: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 47
            Width = 628
            Height = 23
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object lblUseProxy: TLabel
              AlignWithMargins = True
              Left = 24
              Top = 3
              Width = 94
              Height = 17
              Align = alLeft
              Caption = 'Use proxy (IP:port)'
              Layout = tlCenter
              ExplicitHeight = 13
            end
            object CBProxyused: TCheckBox
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 15
              Height = 17
              Align = alLeft
              TabOrder = 0
              OnClick = CBProxyusedClick
            end
            object EditIP: TEdit
              Left = 121
              Top = 0
              Width = 507
              Height = 23
              Align = alClient
              TabOrder = 1
              ExplicitHeight = 21
            end
          end
          object flwpnlProxyAuth: TFlowPanel
            AlignWithMargins = True
            Left = 5
            Top = 76
            Width = 628
            Height = 23
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            TabOrder = 1
            object CBLogin: TCheckBox
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 17
              Height = 17
              TabOrder = 0
              OnClick = CBLoginClick
            end
            object lblProxyLogin: TLabel
              AlignWithMargins = True
              Left = 26
              Top = 3
              Width = 57
              Height = 13
              Caption = 'Proxy login:'
            end
            object EditLogin: TEdit
              Left = 86
              Top = 0
              Width = 81
              Height = 21
              TabOrder = 1
            end
            object Label25: TLabel
              AlignWithMargins = True
              Left = 170
              Top = 3
              Width = 81
              Height = 13
              Caption = 'Proxy password:'
            end
            object EditPass: TEdit
              Left = 254
              Top = 0
              Width = 81
              Height = 21
              PasswordChar = '*'
              TabOrder = 2
            end
          end
          object pnlUseIEProxy: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 18
            Width = 628
            Height = 23
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            TabOrder = 2
            object chkUseIEProxy: TCheckBox
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 622
              Height = 17
              Align = alTop
              Caption = 'Use system proxy settings'
              TabOrder = 0
              OnClick = chkUseIEProxyClick
            end
          end
        end
      end
    end
    object tsControl: TTabSheet
      Caption = 'Control'
      ImageIndex = 2
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 650
        Height = 42
        Align = alTop
        Caption = 'Mouse wheel'
        TabOrder = 0
        object ScrolInvert: TCheckBox
          AlignWithMargins = True
          Left = 5
          Top = 18
          Width = 640
          Height = 17
          Align = alTop
          Caption = 'Roll backward to zoom in'
          TabOrder = 0
        end
      end
      object GroupBox5: TGroupBox
        Left = 0
        Top = 42
        Width = 650
        Height = 345
        Align = alClient
        Caption = 'Hotkeys'
        TabOrder = 1
      end
    end
    object tsView: TTabSheet
      Caption = 'View'
      ImageIndex = 3
      object grdpnlUI: TGridPanel
        Left = 0
        Top = 0
        Width = 650
        Height = 387
        Align = alClient
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = pnlUILeft
            Row = 0
          end
          item
            Column = 1
            Control = pnlUIRight
            Row = 0
          end>
        RowCollection = <
          item
            Value = 100.000000000000000000
          end>
        TabOrder = 0
        object pnlUILeft: TPanel
          Left = 0
          Top = 0
          Width = 325
          Height = 387
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 3
          TabOrder = 0
          object pnlDistFormat: TPanel
            Left = 3
            Top = 38
            Width = 319
            Height = 32
            Align = alTop
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 0
            object Label3: TLabel
              Left = 3
              Top = 3
              Width = 115
              Height = 26
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'Distance representation'
              Layout = tlCenter
              ExplicitHeight = 13
            end
            object ComboBox1: TComboBox
              AlignWithMargins = True
              Left = 121
              Top = 6
              Width = 192
              Height = 21
              Align = alClient
              Style = csDropDownList
              ItemHeight = 13
              ItemIndex = 0
              TabOrder = 0
              Text = '12 km 423 m'
              Items.Strings = (
                '12 km 423 m'
                '23.4 km')
            end
          end
          object pnlLonLatFormat: TPanel
            Left = 3
            Top = 70
            Width = 319
            Height = 34
            Align = alTop
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 1
            object Label84: TLabel
              Left = 3
              Top = 3
              Width = 132
              Height = 28
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'Coordinates representation'
              Layout = tlCenter
              ExplicitHeight = 13
            end
            object CB_llstrType: TComboBox
              AlignWithMargins = True
              Left = 138
              Top = 6
              Width = 175
              Height = 21
              Align = alClient
              Style = csDropDownList
              ItemHeight = 13
              ItemIndex = 0
              TabOrder = 0
              Text = 'WS deg.min.sec. (W12'#176'23"43.35'#39')'
              Items.Strings = (
                'WS deg.min.sec. (W12'#176'23"43.35'#39')'
                'WS deg.min. (W12'#176'23.454)'
                'WS deg. (W12.1233'#176')'
                '-- deg.min.sec. (-12'#176'23"43.35'#39')'
                '-- deg.min. (-12'#176'23.454)'
                '-- deg. (-12.1233'#176')')
            end
          end
          object pnlLang: TPanel
            Left = 3
            Top = 3
            Width = 319
            Height = 35
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 2
            object Label8: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 47
              Height = 23
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'Language'
              Layout = tlCenter
              ExplicitHeight = 13
            end
            object CBoxLocal: TComboBox
              AlignWithMargins = True
              Left = 59
              Top = 6
              Width = 254
              Height = 21
              Align = alClient
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              OnChange = CBoxLocalChange
            end
          end
          object pnlOptions: TPanel
            Left = 3
            Top = 104
            Width = 319
            Height = 91
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 3
            object CBShowmapname: TCheckBox
              Left = 3
              Top = 37
              Width = 313
              Height = 17
              Align = alTop
              Caption = 'Show map name on toolbar'
              TabOrder = 0
            end
            object ChBoxFirstLat: TCheckBox
              Left = 3
              Top = 3
              Width = 313
              Height = 17
              Align = alTop
              Caption = 'Latitude-Longitude order'
              TabOrder = 1
            end
            object CBlock_toolbars: TCheckBox
              Left = 3
              Top = 54
              Width = 313
              Height = 17
              Align = alTop
              Caption = 'Lock toolbars'
              TabOrder = 2
            end
            object CBShowHintOnMarks: TCheckBox
              Left = 3
              Top = 20
              Width = 313
              Height = 17
              Align = alTop
              Caption = 'Show tooltips'
              TabOrder = 3
            end
            object CBMinimizeToTray: TCheckBox
              Left = 3
              Top = 71
              Width = 313
              Height = 17
              Align = alTop
              Caption = 'Minimize to tray'
              TabOrder = 4
            end
          end
          object flwpnlTileBorder: TFlowPanel
            Left = 3
            Top = 195
            Width = 319
            Height = 28
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 4
            object Label69: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 122
              Height = 13
              Alignment = taRightJustify
              Caption = 'Download tiles off-screen'
            end
            object TilesOverScreenEdit: TSpinEdit
              Left = 131
              Top = 3
              Width = 37
              Height = 22
              MaxValue = 24
              MinValue = -2
              TabOrder = 0
              Value = 0
            end
          end
          object pnlImageProcess: TPanel
            Left = 3
            Top = 282
            Width = 317
            Height = 105
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 5
            object LabelGamma: TLabel
              Left = 3
              Top = 3
              Width = 311
              Height = 13
              Align = alTop
              Caption = '_'
              ExplicitWidth = 6
            end
            object LabelContrast: TLabel
              Left = 3
              Top = 41
              Width = 311
              Height = 13
              Align = alTop
              Caption = '_'
              ExplicitWidth = 6
            end
            object TrBarGamma: TTrackBar
              Left = 3
              Top = 16
              Width = 311
              Height = 25
              Align = alTop
              Max = 100
              Min = 1
              ParentShowHint = False
              Frequency = 5
              Position = 1
              ShowHint = False
              TabOrder = 0
              ThumbLength = 15
              TickMarks = tmTopLeft
              OnChange = TrBarGammaChange
            end
            object TrBarContrast: TTrackBar
              Left = 3
              Top = 54
              Width = 311
              Height = 25
              Align = alTop
              Max = 100
              Min = -100
              Frequency = 10
              TabOrder = 1
              ThumbLength = 15
              TickMarks = tmTopLeft
              OnChange = TrBarContrastChange
            end
            object CBinvertcolor: TCheckBox
              AlignWithMargins = True
              Left = 6
              Top = 82
              Width = 305
              Height = 17
              Align = alTop
              Caption = 'Night mode (color inversion)'
              TabOrder = 2
            end
          end
        end
        object pnlUIRight: TPanel
          Left = 325
          Top = 0
          Width = 325
          Height = 387
          Align = alClient
          BevelEdges = [beLeft]
          BevelKind = bkTile
          BevelOuter = bvNone
          BorderWidth = 3
          TabOrder = 1
          object flwpnlMiniMapAlfa: TFlowPanel
            Left = 3
            Top = 33
            Width = 317
            Height = 28
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 0
            object Label17: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 76
              Height = 13
              Alignment = taRightJustify
              Caption = 'Minimap opacity'
            end
            object MiniMapAlphaEdit: TSpinEdit
              Left = 85
              Top = 3
              Width = 57
              Height = 22
              MaxValue = 255
              MinValue = 0
              TabOrder = 0
              Value = 1
            end
          end
          object pnlFillMap: TPanel
            Left = 3
            Top = 94
            Width = 317
            Height = 51
            Align = alTop
            AutoSize = True
            BevelEdges = [beBottom]
            BevelKind = bkTile
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 1
            object Label24: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 305
              Height = 13
              Align = alTop
              Caption = 'Cached tiles map:'
              ExplicitWidth = 85
            end
            object flwpnlFillMap: TFlowPanel
              Left = 3
              Top = 22
              Width = 311
              Height = 24
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
              object Label26: TLabel
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 25
                Height = 13
                Caption = 'Color'
              end
              object MapZapColorBox: TColorBox
                Left = 31
                Top = 0
                Width = 78
                Height = 22
                Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
                ItemHeight = 16
                TabOrder = 0
              end
              object Label29: TLabel
                AlignWithMargins = True
                Left = 112
                Top = 3
                Width = 37
                Height = 13
                Alignment = taRightJustify
                Caption = 'Opacity'
              end
              object MapZapAlphaEdit: TSpinEdit
                Left = 152
                Top = 0
                Width = 41
                Height = 22
                MaxValue = 255
                MinValue = 0
                TabOrder = 1
                Value = 255
              end
            end
          end
          object pnlBgColor: TPanel
            Left = 3
            Top = 61
            Width = 317
            Height = 33
            Align = alTop
            AutoSize = True
            BevelEdges = [beBottom]
            BevelKind = bkTile
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 2
            object Label35: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 82
              Height = 19
              Align = alLeft
              Caption = 'Background color'
              Layout = tlCenter
              ExplicitHeight = 13
            end
            object ColorBoxBackGround: TColorBox
              AlignWithMargins = True
              Left = 94
              Top = 6
              Width = 217
              Height = 22
              Align = alClient
              Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
              ItemHeight = 16
              TabOrder = 0
            end
          end
          object pnlResize: TPanel
            Left = 3
            Top = 3
            Width = 317
            Height = 30
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 3
            object Label16: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 78
              Height = 18
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'Resize algorithm'
              Layout = tlCenter
              ExplicitHeight = 13
            end
            object ComboBox2: TComboBox
              AlignWithMargins = True
              Left = 90
              Top = 6
              Width = 221
              Height = 21
              Align = alClient
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              Items.Strings = (
                '')
            end
          end
          object pnlTileBorders: TPanel
            Left = 3
            Top = 145
            Width = 317
            Height = 69
            Align = alTop
            AutoSize = True
            BevelEdges = [beBottom]
            BevelKind = bkTile
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 6
            object Label23: TLabel
              Left = 3
              Top = 3
              Width = 311
              Height = 13
              Align = alTop
              Caption = 'Tile borders:'
              ExplicitWidth = 70
            end
            object flwpnlTileBorders: TFlowPanel
              Left = 3
              Top = 16
              Width = 311
              Height = 48
              Align = alTop
              AutoSize = True
              BevelEdges = [beBottom]
              BevelOuter = bvNone
              Padding.Top = 3
              TabOrder = 0
              object Label27: TLabel
                AlignWithMargins = True
                Left = 3
                Top = 6
                Width = 25
                Height = 13
                Caption = 'Color'
              end
              object ColorBoxBorder: TColorBox
                Left = 31
                Top = 3
                Width = 78
                Height = 22
                Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
                ItemHeight = 16
                TabOrder = 0
              end
              object Label28: TLabel
                AlignWithMargins = True
                Left = 112
                Top = 6
                Width = 37
                Height = 13
                Caption = 'Opacity'
              end
              object SpinEditBorderAlpha: TSpinEdit
                Left = 152
                Top = 3
                Width = 41
                Height = 22
                MaxValue = 255
                MinValue = 0
                TabOrder = 1
                Value = 255
              end
              object CBBorderText: TCheckBox
                AlignWithMargins = True
                Left = 3
                Top = 28
                Width = 286
                Height = 17
                Caption = 'Tile coordinates'
                TabOrder = 2
              end
            end
          end
         object pnlGenshtabBorders: TPanel
           Left = 3
           Top = 214
           Width = 317
           Height = 68
           Align = alTop
           AutoSize = True
           BevelEdges = [beBottom]
           BevelKind = bkTile
           BevelOuter = bvNone
           BorderWidth = 3
           TabOrder = 4
           object LabelGsh1: TLabel
             Left = 3
             Top = 3
             Width = 311
             Height = 13
             Align = alTop
             Caption = 'Genshtab Map boundaries:'
             ExplicitWidth = 119
           end
           object flwpnlGenshtabBorders: TFlowPanel
             Left = 3
             Top = 16
             Width = 311
             Height = 25
             Align = alTop
             AutoSize = True
             BevelEdges = [beBottom]
             BevelOuter = bvNone
             Padding.Top = 3
             TabOrder = 0
             object LabelGsh2: TLabel
               AlignWithMargins = True
               Left = 3
               Top = 6
               Width = 25
               Height = 13
               Caption = 'Color'
             end
             object GenshtabBoxBorder: TColorBox
               Left = 31
               Top = 3
               Width = 78
               Height = 22
               Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
               ItemHeight = 16
               TabOrder = 0
             end
             object LabelGsh3: TLabel
               AlignWithMargins = True
               Left = 112
               Top = 6
               Width = 37
               Height = 13
               Caption = 'Opacity'
             end
             object SpinEditGenshtabBorderAlpha: TSpinEdit
               Left = 152
               Top = 3
               Width = 41
               Height = 22
               MaxValue = 255
               MinValue = 0
               TabOrder = 1
               Value = 255
             end
           end
           object CBGenshtabBorderText: TCheckBox
             AlignWithMargins = True
             Left = 6
             Top = 44
             Width = 300
             Height = 16
             Align = alLeft
             Caption = 'Genshtab Map names'
             TabOrder = 1
           end
         end
          object pnlDegreeBorders: TPanel
            Left = 3
            Top = 214
            Width = 317
            Height = 68
            Align = alTop
            AutoSize = True
            BevelEdges = [beBottom]
            BevelKind = bkTile
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 4
            object LabelDeg1: TLabel
              Left = 3
              Top = 3
              Width = 311
              Height = 13
              Align = alTop
              Caption = 'Lat/Lon grid:'
              ExplicitWidth = 119
            end
            object flwpnlDegreeBorders: TFlowPanel
              Left = 3
              Top = 16
              Width = 311
              Height = 25
              Align = alTop
              AutoSize = True
              BevelEdges = [beBottom]
              BevelOuter = bvNone
              Padding.Top = 3
              TabOrder = 0
              object LabelDeg2: TLabel
                AlignWithMargins = True
                Left = 3
                Top = 6
                Width = 25
                Height = 13
                Caption = 'Color'
              end
              object DegreeBoxBorder: TColorBox
                Left = 31
                Top = 3
                Width = 78
                Height = 22
                Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
                ItemHeight = 16
                TabOrder = 0
              end
              object LabelDeg3: TLabel
                AlignWithMargins = True
                Left = 112
                Top = 6
                Width = 37
                Height = 13
                Caption = 'Opacity'
              end
              object SpinEditDegreeBorderAlpha: TSpinEdit
                Left = 152
                Top = 3
                Width = 41
                Height = 22
                MaxValue = 255
                MinValue = 0
                TabOrder = 1
                Value = 255
              end
            end
            object CBDegreeBorderText: TCheckBox
              AlignWithMargins = True
              Left = 6
              Top = 44
              Width = 300
              Height = 16
              Align = alLeft
              Caption = 'Grid line labels'
              TabOrder = 1
            end
          end


        end
      end
    end
    object tsGPS: TTabSheet
      Caption = 'GPS'
      ImageIndex = 4
      OnShow = tsGPSShow
      object pnlGPSLeft: TPanel
        Left = 0
        Top = 0
        Width = 400
        Height = 387
        Align = alClient
        BevelOuter = bvNone
        Padding.Right = 3
        TabOrder = 0
        object flwpnlGpsPort: TFlowPanel
          Left = 0
          Top = 0
          Width = 397
          Height = 75
          Align = alTop
          AutoSize = True
          BevelEdges = [beBottom]
          BevelKind = bkTile
          BevelOuter = bvNone
          BorderWidth = 3
          TabOrder = 0
          object Label4: TLabel
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 49
            Height = 13
            Caption = 'Serial port'
          end
          object ComboBoxCOM: TComboBox
            Left = 58
            Top = 3
            Width = 68
            Height = 21
            ItemHeight = 13
            TabOrder = 0
            Text = 'COM1'
          end
          object btnGPSAutodetectCOM: TButton
            Left = 126
            Top = 3
            Width = 21
            Height = 21
            Hint = 'Autodetect COM port'
            Caption = '?'
            TabOrder = 2
            OnClick = btnGPSAutodetectCOMClick
          end
          object Label65: TLabel
            AlignWithMargins = True
            Left = 150
            Top = 6
            Width = 73
            Height = 13
            Alignment = taRightJustify
            Caption = 'Bits per second'
          end
          object ComboBoxBoudRate: TComboBox
            Left = 226
            Top = 3
            Width = 63
            Height = 21
            ItemHeight = 13
            ItemIndex = 5
            TabOrder = 1
            Text = '4800'
            Items.Strings = (
              '110'
              '300'
              '600'
              '1200'
              '2400'
              '4800'
              '9600'
              '14400'
              '19200'
              '38400'
              '57600'
              '115200')
          end
          object lbGPSDelimiter1: TLabel
            AlignWithMargins = True
            Left = 292
            Top = 6
            Width = 8
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
          end
          object btnGPSSwitch: TButton
            Left = 303
            Top = 3
            Width = 75
            Height = 21
            Hint = 'Disable or enable GPS'
            Caption = 'GPS On/Off'
            TabOrder = 3
            OnClick = btnGPSSwitchClick
          end
          object CB_GPSAutodetectCOMOnConnect: TCheckBox
            AlignWithMargins = True
            Left = 6
            Top = 27
            Width = 80
            Height = 17
            Hint = 'Autodetect COM port on connect'
            Caption = 'Autodetect:'
            TabOrder = 4
          end
          object CB_GPSAutodetectCOMSerial: TCheckBox
            AlignWithMargins = True
            Left = 92
            Top = 27
            Width = 48
            Height = 17
            Caption = 'Serial'
            TabOrder = 5
          end
          object CB_GPSAutodetectCOMVirtual: TCheckBox
            AlignWithMargins = True
            Left = 146
            Top = 27
            Width = 50
            Height = 17
            Caption = 'Virtual'
            TabOrder = 6
          end
          object CB_GPSAutodetectCOMBluetooth: TCheckBox
            AlignWithMargins = True
            Left = 202
            Top = 27
            Width = 67
            Height = 17
            Caption = 'Bluetooth'
            TabOrder = 7
          end
          object CB_GPSAutodetectCOMUSBSer: TCheckBox
            AlignWithMargins = True
            Left = 275
            Top = 27
            Width = 56
            Height = 17
            Caption = 'USBSer'
            TabOrder = 8
          end
          object CB_GPSAutodetectCOMOthers: TCheckBox
            AlignWithMargins = True
            Left = 337
            Top = 27
            Width = 50
            Height = 17
            Caption = 'Others'
            TabOrder = 9
          end
          object CB_USBGarmin: TCheckBox
            AlignWithMargins = True
            Left = 6
            Top = 50
            Width = 82
            Height = 17
            Hint = 'Use Garmin via USB (overrides COM settings if checked)'
            Caption = 'USB Garmin'
            TabOrder = 10
          end
        end
        object flwpnlGpsParams: TFlowPanel
          Left = 0
          Top = 75
          Width = 397
          Height = 230
          Align = alTop
          BevelEdges = []
          BevelKind = bkTile
          BevelOuter = bvNone
          BorderWidth = 3
          FlowStyle = fsTopBottomLeftRight
          TabOrder = 1
          object Label6: TLabel
            Left = 3
            Top = 3
            Width = 98
            Height = 13
            Caption = 'Device timeout (sec)'
          end
          object SE_ConnectionTimeout: TSpinEdit
            Left = 3
            Top = 17
            Width = 57
            Height = 22
            MaxValue = 86400
            MinValue = 1
            TabOrder = 0
            Value = 1
          end
          object Label11: TLabel
            Left = 3
            Top = 40
            Width = 85
            Height = 13
            Caption = 'Refresh rate (ms)'
          end
          object SpinEdit1: TSpinEdit
            Left = 3
            Top = 54
            Width = 57
            Height = 22
            MaxValue = 3600000
            MinValue = 100
            TabOrder = 1
            Value = 100
          end
          object Label10: TLabel
            Left = 3
            Top = 77
            Width = 59
            Height = 13
            Caption = 'Pointer size:'
          end
          object SESizeStr: TSpinEdit
            Left = 3
            Top = 91
            Width = 57
            Height = 22
            MaxValue = 150
            MinValue = 10
            TabOrder = 2
            Value = 100
          end
          object Label20: TLabel
            Left = 3
            Top = 114
            Width = 59
            Height = 13
            Caption = 'Track width:'
          end
          object SESizeTrack: TSpinEdit
            Left = 3
            Top = 128
            Width = 57
            Height = 22
            MaxValue = 50
            MinValue = 1
            TabOrder = 3
            Value = 50
          end
          object Label12: TLabel
            Left = 3
            Top = 151
            Width = 59
            Height = 13
            Caption = 'Arrow color:'
          end
          object ColorBoxGPSstr: TColorBox
            Left = 3
            Top = 165
            Width = 105
            Height = 22
            Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
            ItemHeight = 16
            TabOrder = 4
          end
          object Label5: TLabel
            Left = 3
            Top = 188
            Width = 159
            Height = 13
            Caption = 'Maximum number of track points:'
          end
          object SE_NumTrackPoints: TSpinEdit
            Left = 3
            Top = 202
            Width = 73
            Height = 22
            MaxValue = 1000000
            MinValue = 10
            TabOrder = 5
            Value = 10000
          end
        end
        object GB_GpsTrackSave: TGroupBox
          Left = 0
          Top = 305
          Width = 397
          Height = 42
          Align = alTop
          Caption = 'Autosave track to:'
          TabOrder = 2
          object CB_GPSlogPLT: TCheckBox
            AlignWithMargins = True
            Left = 75
            Top = 16
            Width = 51
            Height = 17
            Caption = '.plt'
            TabOrder = 0
          end
          object CB_GPSlogNmea: TCheckBox
            AlignWithMargins = True
            Left = 132
            Top = 16
            Width = 99
            Height = 17
            Caption = '.nmea/.garmin'
            TabOrder = 1
          end
          object CB_GPSlogGPX: TCheckBox
            AlignWithMargins = True
            Left = 11
            Top = 16
            Width = 51
            Height = 17
            Caption = '.gpx'
            TabOrder = 2
          end
        end
        object pnlGpsSensors: TPanel
          Left = 0
          Top = 347
          Width = 397
          Height = 31
          Align = alTop
          AutoSize = True
          BevelEdges = [beBottom]
          BevelKind = bkTile
          BevelOuter = bvNone
          BorderWidth = 3
          TabOrder = 3
          ExplicitTop = 359
          object CBSensorsBarAutoShow: TCheckBox
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 385
            Height = 17
            Align = alTop
            Caption = 'Auto show/hide sensors toolbar'
            TabOrder = 0
          end
        end
      end
      object pnlGpsRight: TPanel
        Left = 400
        Top = 0
        Width = 250
        Height = 387
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        object GroupBox3: TGroupBox
          Left = 0
          Top = 0
          Width = 250
          Height = 387
          Align = alClient
          Caption = 'Satellites'
          TabOrder = 0
          object SatellitePaintBox: TImage32
            AlignWithMargins = True
            Left = 5
            Top = 18
            Width = 240
            Height = 302
            Align = alClient
            Bitmap.ResamplerClassName = 'TNearestResampler'
            BitmapAlign = baTopLeft
            Scale = 1.000000000000000000
            ScaleMode = smNormal
            TabOrder = 0
            OnResize = SatellitePaintBoxResize
          end
          object pnlSatInfoLegend: TPanel
            Left = 2
            Top = 323
            Width = 246
            Height = 62
            Align = alBottom
            AutoSize = True
            BevelEdges = [beTop]
            BevelKind = bkTile
            BevelOuter = bvNone
            TabOrder = 1
            object pnlSatInfoActive: TPanel
              Left = 0
              Top = 0
              Width = 246
              Height = 20
              Align = alTop
              BevelOuter = bvNone
              BorderWidth = 3
              TabOrder = 0
              object lblSatInfoActive: TLabel
                AlignWithMargins = True
                Left = 31
                Top = 3
                Width = 74
                Height = 11
                Margins.Left = 10
                Margins.Top = 0
                Margins.Right = 0
                Align = alLeft
                Caption = 'Satellites in use'
                ExplicitHeight = 13
              end
              object shpSatInfoActive: TShape
                AlignWithMargins = True
                Left = 6
                Top = 4
                Width = 12
                Height = 12
                Margins.Top = 1
                Margins.Bottom = 1
                Align = alLeft
                Brush.Color = clGreen
                ExplicitLeft = 5
                ExplicitTop = 1
              end
            end
            object pnlSatInfoVisible: TPanel
              Left = 0
              Top = 20
              Width = 246
              Height = 20
              Align = alTop
              BevelOuter = bvNone
              BorderWidth = 3
              TabOrder = 1
              object shpSatInfoVisible: TShape
                AlignWithMargins = True
                Left = 6
                Top = 4
                Width = 12
                Height = 12
                Margins.Top = 1
                Margins.Bottom = 1
                Align = alLeft
                Brush.Color = clYellow
                ExplicitLeft = -1
                ExplicitTop = 6
                ExplicitHeight = 55
              end
              object lblSatInfoVisible: TLabel
                AlignWithMargins = True
                Left = 31
                Top = 3
                Width = 85
                Height = 11
                Margins.Left = 10
                Margins.Top = 0
                Margins.Right = 0
                Align = alLeft
                Caption = 'Satellites in range'
                ExplicitHeight = 13
              end
            end
            object pnlSatInfoZeroSignal: TPanel
              Left = 0
              Top = 40
              Width = 246
              Height = 20
              Align = alTop
              BevelOuter = bvNone
              BorderWidth = 3
              TabOrder = 2
              object lblSatInfoZeroSignal: TLabel
                AlignWithMargins = True
                Left = 31
                Top = 3
                Width = 104
                Height = 11
                Margins.Left = 10
                Margins.Top = 0
                Margins.Right = 0
                Align = alLeft
                Caption = 'Satellites not in range'
                ExplicitHeight = 13
              end
              object shpSatInfoZeroSignal: TShape
                AlignWithMargins = True
                Left = 6
                Top = 4
                Width = 12
                Height = 12
                Margins.Top = 1
                Margins.Bottom = 1
                Align = alLeft
                Brush.Color = clRed
                ExplicitLeft = 5
                ExplicitTop = 8
              end
            end
          end
        end
      end
    end
    object tsWiki: TTabSheet
      Caption = 'Wikimapia'
      ImageIndex = 7
      object grdpnlWiki: TGridPanel
        Left = 0
        Top = 0
        Width = 650
        Height = 57
        Align = alTop
        BevelOuter = bvNone
        ColumnCollection = <
          item
            SizeStyle = ssAbsolute
            Value = 150.000000000000000000
          end
          item
            Value = 100.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = lblWikiMainColor
            Row = 0
          end
          item
            Column = 1
            Control = CBWMainColor
            Row = 0
          end
          item
            Column = 0
            Control = lblWikiBgColor
            Row = 1
          end
          item
            Column = 1
            Control = CBWFonColor
            Row = 1
          end>
        RowCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        TabOrder = 0
        DesignSize = (
          650
          57)
        object lblWikiMainColor: TLabel
          Left = 44
          Top = 7
          Width = 62
          Height = 13
          Anchors = []
          Caption = 'Primary color'
          ExplicitLeft = 37
          ExplicitTop = 9
        end
        object CBWMainColor: TColorBox
          Left = 150
          Top = 3
          Width = 159
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
          Anchors = [akLeft, akTop, akBottom]
          ItemHeight = 16
          TabOrder = 0
        end
        object lblWikiBgColor: TLabel
          Left = 46
          Top = 36
          Width = 58
          Height = 13
          Anchors = []
          Caption = 'Border color'
          ExplicitLeft = 30
          ExplicitTop = 40
        end
        object CBWFonColor: TColorBox
          Left = 150
          Top = 31
          Width = 159
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
          Anchors = [akLeft, akTop, akBottom]
          ItemHeight = 16
          TabOrder = 1
        end
      end
    end
    object tsGSM: TTabSheet
      Caption = 'GSM'
      ImageIndex = 7
      object pnlGSM: TPanel
        Left = 0
        Top = 0
        Width = 650
        Height = 387
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 3
        TabOrder = 0
        object chkPosFromGSM: TCheckBox
          Left = 3
          Top = 3
          Width = 644
          Height = 17
          Align = alTop
          Caption = 'Automatically detect location using GSM phone (Google query)'
          TabOrder = 0
          OnClick = chkPosFromGSMClick
        end
        object flwpnlGSM: TFlowPanel
          Left = 3
          Top = 20
          Width = 644
          Height = 28
          Align = alTop
          AutoSize = True
          BevelEdges = [beBottom]
          BevelOuter = bvNone
          BorderWidth = 3
          TabOrder = 1
          object Label33: TLabel
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 49
            Height = 13
            Caption = 'Serial port'
          end
          object CBGSMComPort: TComboBox
            Left = 58
            Top = 3
            Width = 89
            Height = 21
            ItemHeight = 13
            TabOrder = 0
            Text = 'COM1'
          end
          object Label34: TLabel
            AlignWithMargins = True
            Left = 150
            Top = 6
            Width = 73
            Height = 13
            Alignment = taRightJustify
            Caption = 'Bits per second'
          end
          object CBGSMBaundRate: TComboBox
            Left = 226
            Top = 3
            Width = 89
            Height = 21
            ItemHeight = 13
            ItemIndex = 5
            TabOrder = 1
            Text = '4800'
            Items.Strings = (
              '110'
              '300'
              '600'
              '1200'
              '2400'
              '4800'
              '9600'
              '14400'
              '19200'
              '38400'
              '57600'
              '115200')
          end
          object Label36: TLabel
            AlignWithMargins = True
            Left = 318
            Top = 6
            Width = 93
            Height = 13
            Alignment = taRightJustify
            BiDiMode = bdRightToLeft
            Caption = 'Connection timeout'
            ParentBiDiMode = False
          end
          object SEWaitingAnswer: TSpinEdit
            Left = 414
            Top = 3
            Width = 63
            Height = 22
            MaxValue = 0
            MinValue = 0
            TabOrder = 2
            Value = 200
          end
        end
      end
    end
  end
  object pnlBottomButtons: TPanel
    Left = 0
    Top = 415
    Width = 658
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 580
      Top = 3
      Width = 75
      Height = 25
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 0
      OnClick = btnCancelClick
    end
    object btnOk: TButton
      AlignWithMargins = True
      Left = 499
      Top = 3
      Width = 75
      Height = 25
      Align = alRight
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 1
      OnClick = btnApplyClick
    end
    object btnApply: TButton
      AlignWithMargins = True
      Left = 418
      Top = 3
      Width = 75
      Height = 25
      Align = alRight
      Caption = 'Apply'
      TabOrder = 2
      OnClick = btnApplyClick
    end
  end
end
