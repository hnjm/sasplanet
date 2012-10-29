object frmSettings: TfrmSettings
  Left = 293
  Top = 114
  Caption = 'Options'
  ClientHeight = 441
  ClientWidth = 652
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
    Width = 652
    Height = 410
    ActivePage = tsView
    Align = alClient
    TabOrder = 0
    object tsMaps: TTabSheet
      BorderWidth = 3
      Caption = 'Maps'
      ImageIndex = 8
    end
    object tsCache: TTabSheet
      Caption = 'Cache'
      ImageIndex = 1
      object flwpnlMemCache: TFlowPanel
        AlignWithMargins = True
        Left = 3
        Top = 220
        Width = 638
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
        Width = 644
        Height = 217
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
            Control = lblBDBCachePath
            Row = 5
          end
          item
            Column = 1
            Control = edtBDBCachePath
            Row = 5
          end
          item
            Column = 2
            Control = btnSetDefBDBCachePath
            Row = 5
          end
          item
            Column = 3
            Control = btnSetBDBCachePath
            Row = 5
          end
          item
            Column = 0
            Control = Label37
            Row = 7
          end
          item
            Column = 1
            Control = CBCacheType
            Row = 7
          end
          item
            Column = 0
            Control = lbGCCachePath
            Row = 6
          end
          item
            Column = 1
            Control = edtGCCachePath
            Row = 6
          end
          item
            Column = 2
            Control = btnSetDefGCCachePath
            Row = 6
          end
          item
            Column = 3
            Control = btnSetGCCachePath
            Row = 6
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
          644
          217)
        object Label15: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 194
          Height = 24
          Align = alClient
          Caption = 'Native cache folder:'
          Layout = tlCenter
        end
        object NewCpath: TEdit
          AlignWithMargins = True
          Left = 203
          Top = 3
          Width = 398
          Height = 21
          Align = alClient
          TabOrder = 0
        end
        object Button6: TButton
          Tag = 2
          Left = 604
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
          Left = 624
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
          Height = 24
          Align = alClient
          Caption = 'GoogleMV cache folder:'
          Layout = tlCenter
        end
        object OldCpath: TEdit
          AlignWithMargins = True
          Left = 203
          Top = 30
          Width = 398
          Height = 21
          Align = alClient
          TabOrder = 3
        end
        object Button4: TButton
          Tag = 1
          Left = 604
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
          Left = 624
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
          Height = 24
          Align = alClient
          Caption = 'EarthSlicer cache folder:'
          Layout = tlCenter
        end
        object EScPath: TEdit
          AlignWithMargins = True
          Left = 203
          Top = 57
          Width = 398
          Height = 21
          Align = alClient
          TabOrder = 6
        end
        object Button8: TButton
          Tag = 3
          Left = 604
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
          Left = 624
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
          Height = 24
          Align = alClient
          Caption = 'GlobalMapper Tiles (GMT) cache folder:'
          Layout = tlCenter
        end
        object GMTilesPath: TEdit
          AlignWithMargins = True
          Left = 203
          Top = 84
          Width = 398
          Height = 21
          Align = alClient
          TabOrder = 9
        end
        object Button13: TButton
          Tag = 4
          Left = 604
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
          Left = 624
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
          Height = 24
          Align = alClient
          Caption = 'GoogleEarth cache folder:'
          Layout = tlCenter
        end
        object GECachePath: TEdit
          AlignWithMargins = True
          Left = 203
          Top = 111
          Width = 398
          Height = 21
          Align = alClient
          TabOrder = 12
        end
        object Button10: TButton
          Tag = 5
          Left = 604
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
          Left = 624
          Top = 111
          Width = 20
          Height = 21
          Anchors = []
          Caption = '...'
          TabOrder = 14
          OnClick = Button5Click
        end
        object lblBDBCachePath: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 138
          Width = 194
          Height = 24
          Align = alClient
          Caption = 'BerkeleyDB cache folder:'
          Layout = tlCenter
        end
        object edtBDBCachePath: TEdit
          AlignWithMargins = True
          Left = 203
          Top = 138
          Width = 398
          Height = 21
          Align = alClient
          TabOrder = 15
        end
        object btnSetDefBDBCachePath: TButton
          Tag = 6
          Left = 604
          Top = 138
          Width = 20
          Height = 21
          Anchors = []
          Caption = '<>'
          TabOrder = 16
          OnClick = Button4Click
        end
        object btnSetBDBCachePath: TButton
          Tag = 6
          Left = 624
          Top = 138
          Width = 20
          Height = 21
          Anchors = []
          Caption = '...'
          TabOrder = 17
          OnClick = Button5Click
        end
        object Label37: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 192
          Width = 194
          Height = 25
          Align = alClient
          Caption = 'Default cache type'
          Layout = tlCenter
        end
        object CBCacheType: TComboBox
          AlignWithMargins = True
          Left = 203
          Top = 192
          Width = 398
          Height = 21
          Align = alClient
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 1
          TabOrder = 21
          Text = 'SAS.Planet'
          Items.Strings = (
            'GoogleMV'
            'SAS.Planet'
            'EarthSlicer 1.95'
            'GlobalMapper Tiles'
            'BerkeleyDB')
        end
        object lbGCCachePath: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 165
          Width = 194
          Height = 24
          Align = alClient
          Caption = 'GeoCacher root folder:'
          Layout = tlCenter
        end
        object edtGCCachePath: TEdit
          AlignWithMargins = True
          Left = 203
          Top = 165
          Width = 398
          Height = 21
          Align = alClient
          TabOrder = 18
        end
        object btnSetDefGCCachePath: TButton
          Tag = 7
          Left = 604
          Top = 163
          Width = 20
          Height = 25
          Anchors = []
          Caption = '<>'
          TabOrder = 19
          OnClick = Button4Click
        end
        object btnSetGCCachePath: TButton
          Tag = 7
          Left = 624
          Top = 163
          Width = 20
          Height = 25
          Anchors = []
          Caption = '...'
          TabOrder = 20
          OnClick = Button5Click
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
        Width = 638
        Height = 376
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 3
        TabOrder = 0
        object CBDblDwnl: TCheckBox
          AlignWithMargins = True
          Left = 6
          Top = 114
          Width = 626
          Height = 17
          Align = alTop
          Caption = 'Retry download if tile not found'
          TabOrder = 0
        end
        object CkBGoNextTile: TCheckBox
          AlignWithMargins = True
          Left = 6
          Top = 137
          Width = 626
          Height = 17
          Align = alTop
          Caption = 'Download next tile if no response'
          TabOrder = 1
        end
        object CBSaveTileNotExists: TCheckBox
          AlignWithMargins = True
          Left = 6
          Top = 160
          Width = 626
          Height = 17
          Align = alTop
          Caption = 'Store info about not found tiles'
          TabOrder = 2
        end
        object flwpnlDownloadTimeOut: TFlowPanel
          Left = 3
          Top = 180
          Width = 632
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
          Width = 626
          Height = 17
          Align = alTop
          Caption = 'Restore download from last successful tile'
          TabOrder = 4
        end
        object GroupBox4: TGroupBox
          Left = 3
          Top = 3
          Width = 632
          Height = 108
          Align = alTop
          Caption = 'Connection settings'
          TabOrder = 5
          object pnlProxyUrl: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 47
            Width = 622
            Height = 23
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object lblUseProxy: TLabel
              AlignWithMargins = True
              Left = 24
              Top = 3
              Width = 94
              Height = 20
              Align = alLeft
              Caption = 'Use proxy (IP:port)'
              Layout = tlCenter
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
              Width = 501
              Height = 23
              Align = alClient
              TabOrder = 1
            end
          end
          object flwpnlProxyAuth: TFlowPanel
            AlignWithMargins = True
            Left = 5
            Top = 76
            Width = 622
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
            Width = 622
            Height = 23
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            TabOrder = 2
            object chkUseIEProxy: TCheckBox
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 616
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
        Width = 644
        Height = 42
        Align = alTop
        Caption = 'Mouse wheel'
        TabOrder = 0
        object ScrolInvert: TCheckBox
          AlignWithMargins = True
          Left = 5
          Top = 18
          Width = 634
          Height = 17
          Align = alTop
          Caption = 'Roll backward to zoom in'
          TabOrder = 0
        end
      end
      object GroupBox5: TGroupBox
        Left = 0
        Top = 42
        Width = 644
        Height = 340
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
        Width = 644
        Height = 382
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
          Width = 322
          Height = 382
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 3
          TabOrder = 0
          object pnlDistFormat: TPanel
            Left = 3
            Top = 70
            Width = 316
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
            end
            object ComboBox1: TComboBox
              AlignWithMargins = True
              Left = 121
              Top = 6
              Width = 189
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
            Top = 102
            Width = 316
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
            end
            object CB_llstrType: TComboBox
              AlignWithMargins = True
              Left = 138
              Top = 6
              Width = 172
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
            Width = 316
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
              Height = 26
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'Language'
              Layout = tlCenter
            end
            object CBoxLocal: TComboBox
              AlignWithMargins = True
              Left = 59
              Top = 6
              Width = 251
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
            Top = 136
            Width = 316
            Height = 91
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 3
            object CBShowmapname: TCheckBox
              Left = 3
              Top = 37
              Width = 310
              Height = 17
              Align = alTop
              Caption = 'Show map name on toolbar'
              TabOrder = 0
            end
            object ChBoxFirstLat: TCheckBox
              Left = 3
              Top = 3
              Width = 310
              Height = 17
              Align = alTop
              Caption = 'Latitude-Longitude order'
              TabOrder = 1
            end
            object CBlock_toolbars: TCheckBox
              Left = 3
              Top = 54
              Width = 310
              Height = 17
              Align = alTop
              Caption = 'Lock toolbars'
              TabOrder = 2
            end
            object CBShowHintOnMarks: TCheckBox
              Left = 3
              Top = 20
              Width = 310
              Height = 17
              Align = alTop
              Caption = 'Show tooltips'
              TabOrder = 3
            end
            object CBMinimizeToTray: TCheckBox
              Left = 3
              Top = 71
              Width = 310
              Height = 17
              Align = alTop
              Caption = 'Minimize to tray'
              TabOrder = 4
            end
          end
          object flwpnlTileBorder: TFlowPanel
            Left = 3
            Top = 227
            Width = 316
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
            Top = 255
            Width = 316
            Height = 125
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 5
            object LabelGamma: TLabel
              Left = 3
              Top = 23
              Width = 310
              Height = 13
              Align = alTop
              Caption = '_'
            end
            object LabelContrast: TLabel
              Left = 3
              Top = 61
              Width = 310
              Height = 13
              Align = alTop
              Caption = '_'
            end
            object TrBarGamma: TTrackBar
              Left = 3
              Top = 36
              Width = 310
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
              Top = 74
              Width = 310
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
              Top = 102
              Width = 304
              Height = 17
              Align = alTop
              Caption = 'Night mode (color inversion)'
              TabOrder = 2
            end
            object pnlImageProcessTop: TPanel
              Left = 3
              Top = 3
              Width = 310
              Height = 20
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 3
              object lblImageProcessCaption: TLabel
                Left = 0
                Top = 0
                Width = 105
                Height = 20
                Align = alLeft
                Caption = 'Image postprocessing'
              end
              object btnImageProcessReset: TButton
                Left = 289
                Top = 0
                Width = 21
                Height = 20
                Hint = 'Reset to default'
                Align = alRight
                Caption = '<>'
                TabOrder = 0
                OnClick = btnImageProcessResetClick
              end
            end
          end
          object pnlAreaFormat: TPanel
            Left = 3
            Top = 38
            Width = 316
            Height = 32
            Align = alTop
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 6
            object lblAreaFormat: TLabel
              Left = 3
              Top = 3
              Width = 97
              Height = 26
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'Area representation'
              Layout = tlCenter
            end
            object cbbAreaFormat: TComboBox
              AlignWithMargins = True
              Left = 103
              Top = 6
              Width = 207
              Height = 21
              Align = alClient
              Style = csDropDownList
              ItemHeight = 13
              ItemIndex = 0
              TabOrder = 0
              Text = 'Auto'
              Items.Strings = (
                'Auto'
                '2066339 m2'
                '2,07 km2'
                '206,63 ha')
            end
          end
        end
        object pnlUIRight: TPanel
          Left = 322
          Top = 0
          Width = 322
          Height = 382
          Align = alClient
          BevelEdges = [beLeft]
          BevelKind = bkTile
          BevelOuter = bvNone
          BorderWidth = 3
          TabOrder = 1
          object lblResize: TLabel
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 308
            Height = 13
            Align = alTop
            Caption = 'Resize Algorithm:'
          end
          object flwpnlMiniMapAlfa: TFlowPanel
            Left = 3
            Top = 217
            Width = 314
            Height = 30
            Align = alTop
            AutoSize = True
            BevelEdges = [beTop]
            BevelKind = bkTile
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 0
            object lblMiniMapAlfa: TLabel
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
            Top = 283
            Width = 314
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
              Width = 302
              Height = 13
              Align = alTop
              Caption = 'Cached tiles map:'
            end
            object flwpnlFillMap: TFlowPanel
              Left = 3
              Top = 19
              Width = 308
              Height = 27
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
                Width = 135
                Height = 22
                Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
                ItemHeight = 16
                TabOrder = 0
              end
              object Label29: TLabel
                AlignWithMargins = True
                Left = 169
                Top = 3
                Width = 37
                Height = 13
                Alignment = taRightJustify
                Caption = 'Opacity'
              end
              object MapZapAlphaEdit: TSpinEdit
                Left = 209
                Top = 0
                Width = 42
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
            Top = 247
            Width = 314
            Height = 36
            Align = alTop
            AutoSize = True
            BevelEdges = [beBottom]
            BevelKind = bkTile
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 2
            object lblBGColor: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 82
              Height = 25
              Align = alLeft
              Caption = 'Background color'
              Layout = tlCenter
            end
            object ColorBoxBackGround: TColorBox
              AlignWithMargins = True
              Left = 94
              Top = 6
              Width = 214
              Height = 22
              Align = alClient
              Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
              ItemHeight = 16
              TabOrder = 0
            end
          end
          object pnlResize: TPanel
            Left = 3
            Top = 184
            Width = 314
            Height = 33
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 3
            object lblResizeMethod: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 28
              Height = 24
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'Other'
              Layout = tlCenter
            end
            object cbbResizeMethod: TComboBox
              AlignWithMargins = True
              Left = 40
              Top = 6
              Width = 268
              Height = 21
              Align = alClient
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              Items.Strings = (
                '')
            end
          end
          object pnlResizeOnload: TPanel
            Left = 3
            Top = 19
            Width = 314
            Height = 33
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 4
            object lblResizeOnLoad: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 93
              Height = 24
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'On load from cache'
              Layout = tlCenter
            end
            object cbbResizeOnLoad: TComboBox
              AlignWithMargins = True
              Left = 105
              Top = 6
              Width = 203
              Height = 21
              Align = alClient
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              Items.Strings = (
                '')
            end
          end
          object pnlResizeGetPre: TPanel
            Left = 3
            Top = 52
            Width = 314
            Height = 33
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 5
            object lblResizeGetPre: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 115
              Height = 24
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'On get from lower zoom'
              Layout = tlCenter
            end
            object cbbResizeGetPre: TComboBox
              AlignWithMargins = True
              Left = 127
              Top = 6
              Width = 181
              Height = 21
              Align = alClient
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              Items.Strings = (
                '')
            end
          end
          object pnlProjectionChange: TPanel
            Left = 3
            Top = 85
            Width = 314
            Height = 33
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 6
            object lblProjectionChange: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 103
              Height = 24
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'On projection change'
              Layout = tlCenter
            end
            object cbbProjectionChange: TComboBox
              AlignWithMargins = True
              Left = 115
              Top = 6
              Width = 193
              Height = 21
              Align = alClient
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              Items.Strings = (
                '')
            end
          end
          object pnlDownloadResize: TPanel
            Left = 3
            Top = 118
            Width = 314
            Height = 33
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 7
            object lblDownloadResize: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 63
              Height = 24
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'On download'
              Layout = tlCenter
            end
            object cbbDownloadResize: TComboBox
              AlignWithMargins = True
              Left = 75
              Top = 6
              Width = 233
              Height = 21
              Align = alClient
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              Items.Strings = (
                '')
            end
          end
          object pnlResizeTileMatrixDraft: TPanel
            Left = 3
            Top = 151
            Width = 314
            Height = 33
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 8
            object lblResizeTileMatrixDraft: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 107
              Height = 24
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'On change zoom draft'
              Layout = tlCenter
            end
            object cbbResizeTileMatrixDraft: TComboBox
              AlignWithMargins = True
              Left = 119
              Top = 6
              Width = 189
              Height = 21
              Align = alClient
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              Items.Strings = (
                '')
            end
          end
        end
      end
    end
    object tsGrids: TTabSheet
      Caption = 'Grids'
      ImageIndex = 8
      object pnlTileBorders: TPanel
        Left = 0
        Top = 0
        Width = 644
        Height = 68
        Align = alTop
        AutoSize = True
        BevelEdges = [beBottom]
        BevelKind = bkTile
        BevelOuter = bvNone
        BorderWidth = 3
        TabOrder = 0
        object Label23: TLabel
          Left = 3
          Top = 3
          Width = 638
          Height = 13
          Align = alTop
          Caption = 'Tile borders:'
        end
        object flwpnlTileBorders: TFlowPanel
          Left = 3
          Top = 16
          Width = 638
          Height = 25
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
            Width = 135
            Height = 22
            Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
            ItemHeight = 16
            TabOrder = 0
          end
          object Label28: TLabel
            AlignWithMargins = True
            Left = 169
            Top = 6
            Width = 37
            Height = 13
            Caption = 'Opacity'
          end
          object SpinEditBorderAlpha: TSpinEdit
            Left = 209
            Top = 3
            Width = 42
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 1
            Value = 255
          end
        end
        object CBBorderText: TCheckBox
          AlignWithMargins = True
          Left = 6
          Top = 44
          Width = 286
          Height = 16
          Align = alLeft
          Caption = 'Tile coordinates'
          TabOrder = 1
        end
      end
      object pnlGenshtabBorders: TPanel
        Left = 0
        Top = 68
        Width = 644
        Height = 68
        Align = alTop
        AutoSize = True
        BevelEdges = [beBottom]
        BevelKind = bkTile
        BevelOuter = bvNone
        BorderWidth = 3
        TabOrder = 1
        object LabelGsh1: TLabel
          Left = 3
          Top = 3
          Width = 638
          Height = 13
          Align = alTop
          Caption = 'Genshtab Map boundaries:'
        end
        object flwpnlGenshtabBorders: TFlowPanel
          Left = 3
          Top = 16
          Width = 638
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
            Width = 135
            Height = 22
            Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
            ItemHeight = 16
            TabOrder = 0
          end
          object LabelGsh3: TLabel
            AlignWithMargins = True
            Left = 169
            Top = 6
            Width = 37
            Height = 13
            Caption = 'Opacity'
          end
          object SpinEditGenshtabBorderAlpha: TSpinEdit
            Left = 209
            Top = 3
            Width = 42
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
        Left = 0
        Top = 136
        Width = 644
        Height = 68
        Align = alTop
        AutoSize = True
        BevelEdges = [beBottom]
        BevelKind = bkTile
        BevelOuter = bvNone
        BorderWidth = 3
        TabOrder = 2
        object LabelDeg1: TLabel
          Left = 3
          Top = 3
          Width = 638
          Height = 13
          Align = alTop
          Caption = 'Lat/Lon grid:'
        end
        object flwpnlDegreeBorders: TFlowPanel
          Left = 3
          Top = 16
          Width = 638
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
            Width = 135
            Height = 22
            Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
            ItemHeight = 16
            TabOrder = 0
          end
          object LabelDeg3: TLabel
            AlignWithMargins = True
            Left = 169
            Top = 6
            Width = 37
            Height = 13
            Caption = 'Opacity'
          end
          object SpinEditDegreeBorderAlpha: TSpinEdit
            Left = 209
            Top = 3
            Width = 42
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
    object tsGPS: TTabSheet
      Caption = 'GPS'
      ImageIndex = 4
      object pnlGPSLeft: TPanel
        Left = 0
        Top = 0
        Width = 394
        Height = 382
        Align = alClient
        BevelOuter = bvNone
        Padding.Right = 3
        TabOrder = 0
        object flwpnlGpsPort: TFlowPanel
          Left = 0
          Top = 0
          Width = 391
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
            Left = 3
            Top = 24
            Width = 94
            Height = 21
            Hint = 'Disable or enable GPS'
            Caption = 'GPS On/Off'
            TabOrder = 3
            OnClick = btnGPSSwitchClick
          end
          object CB_GPSAutodetectCOMOnConnect: TCheckBox
            AlignWithMargins = True
            Left = 100
            Top = 27
            Width = 80
            Height = 17
            Hint = 'Autodetect COM port on connect'
            Caption = 'Autodetect:'
            TabOrder = 4
          end
          object CB_GPSAutodetectCOMSerial: TCheckBox
            AlignWithMargins = True
            Left = 186
            Top = 27
            Width = 48
            Height = 17
            Caption = 'Serial'
            TabOrder = 5
          end
          object CB_GPSAutodetectCOMVirtual: TCheckBox
            AlignWithMargins = True
            Left = 240
            Top = 27
            Width = 50
            Height = 17
            Caption = 'Virtual'
            TabOrder = 6
          end
          object CB_GPSAutodetectCOMBluetooth: TCheckBox
            AlignWithMargins = True
            Left = 296
            Top = 27
            Width = 67
            Height = 17
            Caption = 'Bluetooth'
            TabOrder = 7
          end
          object CB_GPSAutodetectCOMUSBSer: TCheckBox
            AlignWithMargins = True
            Left = 6
            Top = 50
            Width = 56
            Height = 17
            Caption = 'USBSer'
            TabOrder = 8
          end
          object CB_GPSAutodetectCOMOthers: TCheckBox
            AlignWithMargins = True
            Left = 68
            Top = 50
            Width = 60
            Height = 17
            Caption = 'Others'
            TabOrder = 9
          end
          object CB_USBGarmin: TCheckBox
            AlignWithMargins = True
            Left = 134
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
          Width = 391
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
          Width = 391
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
          Width = 391
          Height = 31
          Align = alTop
          AutoSize = True
          BevelEdges = [beBottom]
          BevelKind = bkTile
          BevelOuter = bvNone
          BorderWidth = 3
          TabOrder = 3
          object CBSensorsBarAutoShow: TCheckBox
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 379
            Height = 17
            Align = alTop
            Caption = 'Auto show/hide sensors toolbar'
            TabOrder = 0
          end
        end
      end
      object pnlGpsRight: TPanel
        Left = 394
        Top = 0
        Width = 250
        Height = 382
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        object GroupBox3: TGroupBox
          Left = 0
          Top = 0
          Width = 250
          Height = 382
          Align = alClient
          Caption = 'Satellites'
          TabOrder = 0
        end
      end
    end
    object tsWiki: TTabSheet
      Caption = 'Wikimapia'
      ImageIndex = 7
      object grdpnlWiki: TGridPanel
        Left = 0
        Top = 0
        Width = 644
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
          644
          57)
        object lblWikiMainColor: TLabel
          Left = 44
          Top = 7
          Width = 62
          Height = 13
          Anchors = []
          Caption = 'Primary color'
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
        Width = 644
        Height = 382
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 3
        TabOrder = 0
        object chkPosFromGSM: TCheckBox
          Left = 3
          Top = 3
          Width = 638
          Height = 17
          Align = alTop
          Caption = 'Automatically detect location using GSM phone (Google query)'
          TabOrder = 0
          OnClick = chkPosFromGSMClick
        end
        object flwpnlGSM: TFlowPanel
          Left = 3
          Top = 20
          Width = 638
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
    Top = 410
    Width = 652
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 574
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
      Left = 493
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
      Left = 412
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
