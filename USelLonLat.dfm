object FSelLonLat: TFSelLonLat
  Left = 192
  Top = 289
  BorderStyle = bsSizeToolWin
  Caption = #1042#1099#1076#1077#1083#1077#1085#1080#1077' '#1087#1086' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1072#1084
  ClientHeight = 174
  ClientWidth = 252
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 260
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottomButtons: TPanel
    Left = 0
    Top = 143
    Width = 252
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 238
    ExplicitWidth = 383
    object Button2: TButton
      AlignWithMargins = True
      Left = 174
      Top = 3
      Width = 75
      Height = 25
      Align = alRight
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      ModalResult = 2
      TabOrder = 0
      ExplicitTop = 6
    end
    object Button1: TButton
      AlignWithMargins = True
      Left = 93
      Top = 3
      Width = 75
      Height = 25
      Align = alRight
      Caption = #1055#1088#1080#1085#1103#1090#1100
      Default = True
      ModalResult = 1
      TabOrder = 1
      ExplicitLeft = 96
      ExplicitTop = 6
    end
  end
  object grdpnlMain: TGridPanel
    Left = 0
    Top = 0
    Width = 252
    Height = 143
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
    ExplicitLeft = 32
    ExplicitTop = 151
    ExplicitWidth = 281
    ExplicitHeight = 151
    object grpTopLeft: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 246
      Height = 65
      Align = alClient
      Caption = ' '#1051#1077#1074#1099#1081' '#1074#1077#1088#1093#1085#1080#1081' '#1091#1075#1086#1083' '
      TabOrder = 0
      ExplicitLeft = 8
      ExplicitTop = 5
      ExplicitWidth = 241
      ExplicitHeight = 68
    end
    object grpBottomRight: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 74
      Width = 246
      Height = 66
      Align = alClient
      Caption = ' '#1055#1088#1072#1074#1099#1081' '#1085#1080#1078#1085#1080#1081' '#1091#1075#1086#1083' '
      TabOrder = 1
      ExplicitLeft = 8
      ExplicitTop = 77
      ExplicitWidth = 241
      ExplicitHeight = 68
    end
  end
end
