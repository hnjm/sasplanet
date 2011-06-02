object frmMarksExplorer: TfrmMarksExplorer
  Left = 341
  Top = 186
  Caption = 'Placemark Manager'
  ClientHeight = 427
  ClientWidth = 577
  Color = clBtnFace
  Constraints.MinHeight = 309
  Constraints.MinWidth = 406
  ParentFont = True
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMainWithButtons: TPanel
    Left = 0
    Top = 0
    Width = 577
    Height = 352
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitHeight = 358
    object pnlButtons: TPanel
      AlignWithMargins = True
      Left = 497
      Top = 3
      Width = 77
      Height = 346
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitHeight = 352
      object btnExport: TTBXButton
        AlignWithMargins = True
        Left = 3
        Top = 30
        Width = 71
        Height = 21
        Align = alTop
        DropDownCombo = True
        DropDownMenu = PopupExport
        ImageIndex = 0
        TabOrder = 2
        OnClick = btnExportClick
        Caption = 'Export'
      end
      object btnAccept: TTBXButton
        AlignWithMargins = True
        Left = 3
        Top = 57
        Width = 71
        Height = 21
        Align = alTop
        ImageIndex = 0
        TabOrder = 1
        OnClick = btnAcceptClick
        Caption = 'Apply'
      end
      object btnOk: TTBXButton
        AlignWithMargins = True
        Left = 3
        Top = 84
        Width = 71
        Height = 21
        Align = alTop
        ImageIndex = 0
        TabOrder = 0
        OnClick = btnOkClick
        Caption = 'Ok'
      end
      object btnImport: TTBXButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 71
        Height = 21
        Align = alTop
        ImageIndex = 0
        TabOrder = 3
        OnClick = btnImportClick
        Caption = 'Import'
      end
    end
    object pnlMain: TPanel
      Left = 0
      Top = 0
      Width = 494
      Height = 352
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitHeight = 358
      object splCatMarks: TSplitter
        Left = 181
        Top = 0
        Height = 352
        ExplicitLeft = 237
        ExplicitTop = 14
        ExplicitHeight = 331
      end
      object grpMarks: TGroupBox
        Left = 184
        Top = 0
        Width = 310
        Height = 352
        Align = alClient
        Caption = 'Placemarks'
        TabOrder = 0
        ExplicitLeft = 181
        ExplicitWidth = 313
        ExplicitHeight = 358
        object MarksListBox: TCheckListBox
          AlignWithMargins = True
          Left = 5
          Top = 46
          Width = 300
          Height = 278
          OnClickCheck = MarksListBoxClickCheck
          Align = alClient
          ItemHeight = 13
          Sorted = True
          TabOrder = 0
          OnKeyUp = MarksListBoxKeyUp
          ExplicitWidth = 303
          ExplicitHeight = 284
        end
        object CheckBox1: TCheckBox
          AlignWithMargins = True
          Left = 5
          Top = 330
          Width = 300
          Height = 17
          Align = alBottom
          Caption = 'All'
          TabOrder = 1
          OnClick = CheckBox1Click
          ExplicitTop = 336
          ExplicitWidth = 303
        end
        object TBXDockMark: TTBXDock
          Left = 2
          Top = 15
          Width = 306
          Height = 28
          AllowDrag = False
          UseParentBackground = True
          ExplicitWidth = 309
          object TBXToolbar1: TTBXToolbar
            Left = 0
            Top = 0
            Align = alTop
            BorderStyle = bsNone
            CloseButton = False
            Images = frmMain.MenusImageList
            ParentBackground = True
            ParentColor = True
            Stretch = True
            TabOrder = 0
            UseThemeColor = False
            Caption = ''
            object btnEditMark: TTBXItem
              ImageIndex = 31
              OnClick = btnEditMarkClick
              Caption = ''
              Hint = 'Edit selected placemark'
            end
            object btnDelMark: TTBXItem
              ImageIndex = 30
              OnClick = btnDelMarkClick
              Caption = ''
              Hint = 'Delete selected placemark'
            end
            object TBXSeparatorItem1: TTBXSeparatorItem
              Caption = ''
              Hint = ''
            end
            object btnGoToMark: TTBXItem
              ImageIndex = 11
              OnClick = btnGoToMarkClick
              Caption = ''
              Hint = 'Go to selected object'
            end
            object btnOpSelectMark: TTBXItem
              ImageIndex = 10
              OnClick = btnOpSelectMarkClick
              Caption = ''
              Hint = 'Selection manager'
            end
            object btnNavOnMark: TTBXItem
              AutoCheck = True
              ImageIndex = 33
              OnClick = btnNavOnMarkClick
              Caption = ''
              Hint = 'Navigate to selected placemark'
            end
            object TBXSeparatorItem2: TTBXSeparatorItem
              Caption = ''
              Hint = ''
            end
            object btnSaveMark: TTBXItem
              ImageIndex = 25
              OnClick = btnSaveMarkClick
              Caption = ''
              Hint = 'Export selected placemark'
            end
          end
        end
      end
      object grpCategory: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 0
        Width = 178
        Height = 352
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = 'Placemark Categories'
        TabOrder = 1
        ExplicitLeft = 0
        ExplicitHeight = 358
        object CheckBox2: TCheckBox
          AlignWithMargins = True
          Left = 5
          Top = 330
          Width = 168
          Height = 17
          Align = alBottom
          Caption = 'All'
          TabOrder = 0
          OnClick = CheckBox2Click
          ExplicitTop = 336
        end
        object TreeView1: TTreeView
          AlignWithMargins = True
          Left = 5
          Top = 46
          Width = 168
          Height = 278
          Align = alClient
          Indent = 19
          ReadOnly = True
          StateImages = imlStates
          TabOrder = 1
          OnChange = TreeView1Change
          OnKeyUp = TreeView1KeyUp
          OnMouseUp = TreeView1MouseUp
          ExplicitHeight = 284
        end
        object TBXDockCategory: TTBXDock
          Left = 2
          Top = 15
          Width = 174
          Height = 28
          AllowDrag = False
          UseParentBackground = True
          object TBXToolbar2: TTBXToolbar
            Left = 0
            Top = 0
            Align = alTop
            BorderStyle = bsNone
            CloseButton = False
            Images = frmMain.MenusImageList
            ParentBackground = True
            ParentColor = True
            Stretch = True
            TabOrder = 0
            UseThemeColor = False
            Caption = ''
            object BtnAddCategory: TTBXItem
              ImageIndex = 32
              OnClick = TBXItem4Click
              Caption = ''
              Hint = 'Add'
            end
            object BtnEditCategory: TTBXItem
              ImageIndex = 31
              OnClick = BtnEditCategoryClick
              Caption = ''
              Hint = 'Edit'
            end
            object BtnDelKat: TTBXItem
              ImageIndex = 30
              OnClick = BtnDelKatClick
              Caption = ''
              Hint = 'Delete'
            end
            object TBXSeparatorItem3: TTBXSeparatorItem
              Caption = ''
              Hint = ''
            end
            object btnExportCategory: TTBXItem
              ImageIndex = 25
              OnClick = btnExportCategoryClick
              Caption = ''
              Hint = 'Export placemarks from selected category'
            end
          end
        end
      end
    end
  end
  object rgMarksShowMode: TRadioGroup
    AlignWithMargins = True
    Left = 3
    Top = 355
    Width = 571
    Height = 69
    Align = alBottom
    Ctl3D = True
    ItemIndex = 0
    Items.Strings = (
      'Show only selected placemarks'
      'Show all placemarks'
      'Hide placemarks')
    ParentCtl3D = False
    TabOrder = 1
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.kml'
    Filter = 
      'Google KML files (*.kml)|*.kml|OziExplorer Track Point File Vers' +
      'ion 2.1 (*.plt)|*.plt|Google KMZ files (*.kmz)|*.kmz|Selection' +
      ' (*.hlg)|*.hlg'
    Left = 352
    Top = 144
  end
  object imlStates: TImageList
    Height = 13
    Width = 13
    Left = 312
    Top = 144
    Bitmap = {
      494C01010300050004000D000D00FFFFFFFFFF00FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000340000000D0000000100200000000000900A
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A19D9D00A19D9D00A19D9D00A19D9D00A19D9D00A19D9D00A19D
      9D00A19D9D00A19D9D00A19D9D00A19D9D000000000000000000A19D9D00A19D
      9D00A19D9D00A19D9D00A19D9D00A19D9D00A19D9D00A19D9D00A19D9D00A19D
      9D00A19D9D000000000000000000A19D9D00A19D9D00A19D9D00A19D9D00A19D
      9D00A19D9D00A19D9D00A19D9D00A19D9D00A19D9D00A19D9D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A19D9D00F1F3F300F3F5
      F500F6F7F700F8F9F900F9FAFA00FBFCFC00FDFDFD00FEFEFE0000000000A19D
      9D000000000000000000A19D9D00F1F3F300F3F5F500F6F7F700F8F9F900F9FA
      FA00FBFCFC00FDFDFD00FEFEFE0000000000A19D9D000000000000000000A19D
      9D00EFF1F100F1F3F300F4F5F500F6F7F700F8F9F900FAFBFB00FCFDFD00FEFE
      FE0000000000A19D9D0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A19D9D00EFF1F100F1F3F300F3F5F50080808000F8F9F900F9FA
      FA00FBFCFC00FDFDFD00FEFEFE00A19D9D000000000000000000A19D9D00EFF1
      F100F1F3F300F3F5F50021A12100F8F9F900F9FAFA00FBFCFC00FDFDFD00FEFE
      FE00A19D9D000000000000000000A19D9D00ECEFEF00EFF1F100F1F3F300F4F5
      F500F6F7F700F8F9F900FAFBFB00FCFDFD00FEFEFE00A19D9D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A19D9D00ECEFEF00EFF1
      F100808080008080800080808000F8F9F900F9FAFA00FBFCFC00FDFDFD00A19D
      9D000000000000000000A19D9D00ECEFEF00EFF1F10021A1210021A1210021A1
      2100F8F9F900F9FAFA00FBFCFC00FDFDFD00A19D9D000000000000000000A19D
      9D00E9ECEC00ECEFEF00EFF1F100F1F3F300F4F5F500F6F7F700F8F9F900FAFB
      FB00FCFDFD00A19D9D0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A19D9D00E9ECEC00808080008080800080808000808080008080
      8000F8F9F900F9FAFA00FBFCFC00A19D9D000000000000000000A19D9D00E9EC
      EC0021A1210021A1210021A1210021A1210021A12100F8F9F900F9FAFA00FBFC
      FC00A19D9D000000000000000000A19D9D00E5E8E800E9ECEC00ECEFEF00EFF1
      F100F1F3F300F4F5F500F6F7F700F8F9F900FAFBFB00A19D9D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A19D9D00E6EAEA008080
      800080808000EFF1F100808080008080800080808000F8F9F900F9FAFA00A19D
      9D000000000000000000A19D9D00E6EAEA0021A1210021A12100EFF1F10021A1
      210021A1210021A12100F8F9F900F9FAFA00A19D9D000000000000000000A19D
      9D00E2E5E500E5E8E800E9ECEC00ECEFEF00EFF1F100F1F3F300F4F5F500F6F7
      F700F8F9F900A19D9D0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A19D9D00E3E7E70080808000E9ECEC00ECEFEF00EFF1F1008080
      80008080800080808000F8F9F900A19D9D000000000000000000A19D9D00E3E7
      E70021A12100E9ECEC00ECEFEF00EFF1F10021A1210021A1210021A12100F8F9
      F900A19D9D000000000000000000A19D9D00DEE2E200E2E5E500E5E8E800E9EC
      EC00ECEFEF00EFF1F100F1F3F300F4F5F500F6F7F700A19D9D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A19D9D00E1E5E500E3E7
      E700E6EAEA00E9ECEC00ECEFEF00EFF1F1008080800080808000F6F7F700A19D
      9D000000000000000000A19D9D00E1E5E500E3E7E700E6EAEA00E9ECEC00ECEF
      EF00EFF1F10021A1210021A12100F6F7F700A19D9D000000000000000000A19D
      9D00DBE0E000DEE2E200E2E5E500E5E8E800E9ECEC00ECEFEF00EFF1F100F1F3
      F300F4F5F500A19D9D0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A19D9D00DFE3E300E1E5E500E3E7E700E6EAEA00E9ECEC00ECEF
      EF00EFF1F10080808000F3F5F500A19D9D000000000000000000A19D9D00DFE3
      E300E1E5E500E3E7E700E6EAEA00E9ECEC00ECEFEF00EFF1F10021A12100F3F5
      F500A19D9D000000000000000000A19D9D00D9DEDE00DBE0E000DEE2E200E2E5
      E500E5E8E800E9ECEC00ECEFEF00EFF1F100F1F3F300A19D9D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A19D9D00DDE2E200DFE3
      E300E1E5E500E3E7E700E6EAEA00E9ECEC00ECEFEF00EFF1F100F1F3F300A19D
      9D000000000000000000A19D9D00DDE2E200DFE3E300E1E5E500E3E7E700E6EA
      EA00E9ECEC00ECEFEF00EFF1F100F1F3F300A19D9D000000000000000000A19D
      9D00D7DCDC00D9DEDE00DBE0E000DEE2E200E2E5E500E5E8E800E9ECEC00ECEF
      EF00EFF1F100A19D9D0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A19D9D00A19D9D00A19D9D00A19D9D00A19D9D00A19D9D00A19D
      9D00A19D9D00A19D9D00A19D9D00A19D9D000000000000000000A19D9D00A19D
      9D00A19D9D00A19D9D00A19D9D00A19D9D00A19D9D00A19D9D00A19D9D00A19D
      9D00A19D9D000000000000000000A19D9D00A19D9D00A19D9D00A19D9D00A19D
      9D00A19D9D00A19D9D00A19D9D00A19D9D00A19D9D00A19D9D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000424D3E000000000000003E00000028000000340000000D00000001000100
      00000000680000000000000000000000000000000000000000000000FFFFFF00
      FFFFFFFFFE000000800C006002000000802C01600A000000800C006002000000
      800C006002000000800C006002000000800C006002000000800C006002000000
      800C006002000000800C006002000000800C006002000000800C006002000000
      FFFFFFFFFE000000}
  end
  object ExportDialog: TSaveDialog
    DefaultExt = '.kmz'
    Filter = 
      'Compressed Keyhole Markup Language (kmz)|*.kmz|Keyhole Markup L' +
      'anguage (kml)|*.kml'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 256
    Top = 208
  end
  object PopupExport: TPopupMenu
    Left = 376
    Top = 224
    object NExportAll: TMenuItem
      Caption = 'Export all placemarks and all categories'
      OnClick = btnExportClick
    end
    object NExportVisible: TMenuItem
      Tag = 1
      Caption = 'Export visible placemarks'
      OnClick = btnExportClick
    end
  end
end
