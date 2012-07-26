object frmCacheManager: TfrmCacheManager
  Left = 0
  Top = 0
  Caption = 'Cache Manager'
  ClientHeight = 316
  ClientWidth = 572
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  PopupMode = pmExplicit
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 572
    Height = 279
    ActivePage = tsConverter
    Align = alClient
    TabOrder = 0
    object tsConverter: TTabSheet
      Caption = 'Convert Cache Format'
      object grpSrc: TGroupBox
        Left = 2
        Top = 0
        Width = 559
        Height = 113
        Align = alCustom
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Source Cache'
        TabOrder = 0
        object lblPath: TLabel
          Left = 16
          Top = 16
          Width = 26
          Height = 13
          Caption = 'Path:'
        end
        object lblCacheType: TLabel
          Left = 16
          Top = 62
          Width = 38
          Height = 13
          Caption = 'Format:'
        end
        object lblDefExtention: TLabel
          Left = 175
          Top = 62
          Width = 50
          Height = 13
          Caption = 'Extention:'
        end
        object edtPath: TEdit
          Left = 16
          Top = 35
          Width = 510
          Height = 21
          Align = alCustom
          Anchors = [akLeft, akRight]
          TabOrder = 0
        end
        object cbbCacheTypes: TComboBox
          Left = 16
          Top = 81
          Width = 153
          Height = 21
          ItemHeight = 13
          TabOrder = 1
          Text = 'SAS.Planet'
          Items.Strings = (
            'GoogleMV'
            'SAS.Planet'
            'EarthSlicer 1.95'
            'GlobalMapper Tiles'
            'GlobalMapper Aux'
            'BerkeleyDB')
        end
        object chkIgnoreTNE: TCheckBox
          Left = 279
          Top = 81
          Width = 130
          Height = 17
          Caption = 'Ignore *.tne'
          TabOrder = 2
        end
        object chkRemove: TCheckBox
          Left = 415
          Top = 81
          Width = 141
          Height = 17
          Caption = 'Remove tiles'
          TabOrder = 3
        end
        object edtDefExtention: TEdit
          Left = 175
          Top = 81
          Width = 98
          Height = 21
          TabOrder = 4
          Text = '*.jpg'
        end
        object btnSelectSrcPath: TButton
          Left = 532
          Top = 35
          Width = 21
          Height = 19
          Align = alCustom
          Anchors = [akRight]
          Caption = '...'
          TabOrder = 5
          OnClick = btnSelectSrcPathClick
        end
      end
      object grpDestCache: TGroupBox
        Left = 3
        Top = 119
        Width = 559
        Height = 113
        Align = alCustom
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Dest Cache'
        TabOrder = 1
        object lblDestPath: TLabel
          Left = 16
          Top = 16
          Width = 26
          Height = 13
          Caption = 'Path:'
        end
        object lblDestFormat: TLabel
          Left = 16
          Top = 62
          Width = 38
          Height = 13
          Caption = 'Format:'
        end
        object edtDestPath: TEdit
          Left = 16
          Top = 35
          Width = 509
          Height = 21
          Align = alCustom
          Anchors = [akLeft, akRight]
          TabOrder = 0
        end
        object cbbDestCacheTypes: TComboBox
          Left = 16
          Top = 81
          Width = 153
          Height = 21
          ItemHeight = 13
          TabOrder = 1
          Text = 'BerkeleyDB'
          Items.Strings = (
            'GoogleMV'
            'SAS.Planet'
            'EarthSlicer 1.95'
            'GlobalMapper Tiles'
            'GlobalMapper Aux'
            'BerkeleyDB')
        end
        object chkOverwrite: TCheckBox
          Left = 175
          Top = 81
          Width = 381
          Height = 17
          Caption = 'Overwrite exist tiles'
          TabOrder = 2
        end
        object btnSelectDestPath: TButton
          Left = 532
          Top = 35
          Width = 21
          Height = 19
          Align = alCustom
          Anchors = [akRight]
          Caption = '...'
          TabOrder = 3
          OnClick = btnSelectDestPathClick
        end
      end
    end
  end
  object pnlBottomButtons: TPanel
    Left = 0
    Top = 279
    Width = 572
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 1
    object btnStart: TButton
      AlignWithMargins = True
      Left = 491
      Top = 6
      Width = 75
      Height = 25
      Align = alRight
      Caption = 'Start'
      Default = True
      TabOrder = 0
      OnClick = btnStartClick
    end
    object btnCansel: TButton
      AlignWithMargins = True
      Left = 410
      Top = 6
      Width = 75
      Height = 25
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCanselClick
    end
    object chkCloseWithStart: TCheckBox
      AlignWithMargins = True
      Left = 6
      Top = 6
      Width = 398
      Height = 25
      Align = alClient
      Caption = 'Close this window after start'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
end
