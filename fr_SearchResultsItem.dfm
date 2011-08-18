object frSearchResultsItem: TfrSearchResultsItem
  Left = 0
  Top = 0
  Width = 289
  Height = 87
  Align = alTop
  AutoSize = True
  Color = clWhite
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object Bevel1: TBevel
    AlignWithMargins = True
    Left = 3
    Top = 79
    Width = 283
    Height = 5
    Align = alTop
    Shape = bsTopLine
  end
  object PanelCaption: TPanel
    Left = 0
    Top = 0
    Width = 289
    Height = 22
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 0
    object LabelCaption: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 283
      Height = 16
      Cursor = crHandPoint
      Align = alTop
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1085#1072#1081#1076#1077#1085#1085#1086#1075#1086' '#1086#1073#1098#1077#1082#1090#1072
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
      OnClick = LabelCaptionClick
      ExplicitWidth = 203
    end
  end
  object PanelFullDesc: TPanel
    Left = 0
    Top = 56
    Width = 289
    Height = 20
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 63
    ExplicitWidth = 288
    object LabelFullDesc: TLabel
      AlignWithMargins = True
      Left = 214
      Top = 3
      Width = 72
      Height = 14
      Cursor = crHandPoint
      Align = alRight
      Alignment = taRightJustify
      Caption = 'Full Description'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
      OnMouseUp = LabelFullDescMouseUp
      ExplicitHeight = 13
    end
  end
  object PanelDesc: TPanel
    Left = 0
    Top = 22
    Width = 289
    Height = 34
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 2
    object LabelDesc: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 283
      Height = 28
      Align = alTop
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1085#1072#1081#1076#1077#1085#1085#1086#1075#1086' '#1086#1073#1098#1077#1082#1090#1072'.'#13#10#1052#1086#1078#1085#1086' '#1084#1085#1086#1075#1086#1089#1090#1088#1086#1095#1085#1086#1077'.'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      OnDblClick = LabelDescDblClick
      ExplicitWidth = 159
    end
  end
end
