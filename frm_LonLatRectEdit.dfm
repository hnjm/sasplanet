object frmLonLatRectEdit: TfrmLonLatRectEdit
  Left = 192
  Top = 289
  Caption = 'Selection by coordinates'
  ClientHeight = 214
  ClientWidth = 291
  Color = clBtnFace
  Constraints.MinHeight = 198
  Constraints.MinWidth = 260
  ParentFont = True
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottomButtons: TPanel
    Left = 0
    Top = 183
    Width = 291
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 186
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 213
      Top = 3
      Width = 75
      Height = 25
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
    end
    object btnOk: TButton
      AlignWithMargins = True
      Left = 132
      Top = 3
      Width = 75
      Height = 25
      Align = alRight
      Caption = 'Apply'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
  end
  object grdpnlMain: TGridPanel
    Left = 0
    Top = 0
    Width = 291
    Height = 183
    Align = alClient
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = grpTopLeft
        Row = 0
      end
      item
        Column = 0
        Control = grpBottomRight
        Row = 1
      end>
    RowCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    TabOrder = 1
    ExplicitHeight = 186
    object grpTopLeft: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 285
      Height = 85
      Align = alClient
      Caption = 'Upper left point'
      TabOrder = 0
      ExplicitHeight = 87
    end
    object grpBottomRight: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 94
      Width = 285
      Height = 86
      Align = alClient
      Caption = 'Lower right point'
      TabOrder = 1
      ExplicitTop = 96
      ExplicitHeight = 87
    end
  end
end
