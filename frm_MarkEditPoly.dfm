object frmMarkEditPoly: TfrmMarkEditPoly
  Left = 360
  Top = 40
  Caption = 'Add New Polygon'
  ClientHeight = 348
  ClientWidth = 327
  Color = clBtnFace
  Constraints.MinHeight = 375
  Constraints.MinWidth = 335
  ParentFont = True
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object chkVisible: TCheckBox
    AlignWithMargins = True
    Left = 3
    Top = 297
    Width = 321
    Height = 17
    Align = alBottom
    Caption = 'Show on map'
    TabOrder = 5
  end
  object pnlBottomButtons: TPanel
    Left = 0
    Top = 317
    Width = 327
    Height = 31
    Align = alBottom
    BevelEdges = [beTop]
    BevelKind = bkTile
    BevelOuter = bvNone
    TabOrder = 6
    object btnOk: TButton
      AlignWithMargins = True
      Left = 172
      Top = 3
      Width = 73
      Height = 23
      Align = alRight
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOkClick
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 251
      Top = 3
      Width = 73
      Height = 23
      Hint = 'Cancel'
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object pnlFill: TPanel
    Left = 0
    Top = 251
    Width = 327
    Height = 43
    Align = alBottom
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 4
    ExplicitTop = 248
    object lblFill: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 0
      Width = 321
      Height = 13
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Fill:'
      ExplicitTop = 3
      ExplicitWidth = 16
    end
    object flwpnlFill: TFlowPanel
      Left = 0
      Top = 13
      Width = 327
      Height = 30
      Align = alTop
      AutoSize = True
      AutoWrap = False
      BevelEdges = [beBottom]
      BevelKind = bkTile
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitTop = 19
      object lblFillColor: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 6
        Width = 25
        Height = 13
        Margins.Top = 6
        Margins.Right = 0
        Caption = 'Color'
      end
      object clrbxFillColor: TColorBox
        AlignWithMargins = True
        Left = 31
        Top = 3
        Width = 38
        Height = 22
        Margins.Right = 0
        Selected = clWhite
        Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
        ItemHeight = 16
        TabOrder = 0
      end
      object btnFillColor: TSpeedButton
        AlignWithMargins = True
        Left = 69
        Top = 3
        Width = 17
        Height = 22
        Margins.Left = 0
        Caption = '...'
        OnClick = btnFillColorClick
      end
      object lblFillTransp: TLabel
        AlignWithMargins = True
        Left = 92
        Top = 6
        Width = 51
        Height = 13
        Margins.Top = 6
        Margins.Right = 0
        Caption = 'Opacity %'
      end
      object seFillTransp: TSpinEdit
        AlignWithMargins = True
        Left = 146
        Top = 3
        Width = 41
        Height = 22
        MaxValue = 100
        MinValue = 0
        TabOrder = 1
        Value = 80
      end
    end
  end
  object pnlLine: TPanel
    Left = 0
    Top = 210
    Width = 327
    Height = 41
    Align = alBottom
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitTop = 207
    object lblLine: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 0
      Width = 321
      Height = 13
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Line:'
      ExplicitTop = 3
      ExplicitWidth = 23
    end
    object flwpnlLine: TFlowPanel
      Left = 0
      Top = 13
      Width = 327
      Height = 28
      Align = alTop
      AutoSize = True
      AutoWrap = False
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitTop = 19
      object lblLineColor: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 6
        Width = 25
        Height = 13
        Margins.Top = 6
        Margins.Right = 0
        Caption = 'Color'
      end
      object clrbxLineColor: TColorBox
        AlignWithMargins = True
        Left = 31
        Top = 3
        Width = 38
        Height = 22
        Margins.Right = 0
        Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
        ItemHeight = 16
        TabOrder = 0
      end
      object btnLineColor: TSpeedButton
        AlignWithMargins = True
        Left = 69
        Top = 3
        Width = 17
        Height = 22
        Margins.Left = 0
        Caption = '...'
        OnClick = btnLineColorClick
      end
      object lblLineWidth: TLabel
        AlignWithMargins = True
        Left = 92
        Top = 6
        Width = 28
        Height = 13
        Margins.Top = 6
        Margins.Right = 0
        Caption = 'Width'
      end
      object seLineWidth: TSpinEdit
        AlignWithMargins = True
        Left = 123
        Top = 3
        Width = 41
        Height = 22
        MaxValue = 24
        MinValue = 1
        TabOrder = 1
        Value = 2
      end
      object lblLineTransp: TLabel
        AlignWithMargins = True
        Left = 170
        Top = 6
        Width = 51
        Height = 13
        Margins.Top = 6
        Margins.Right = 0
        Caption = 'Opacity %'
      end
      object seLineTransp: TSpinEdit
        AlignWithMargins = True
        Left = 224
        Top = 3
        Width = 41
        Height = 22
        MaxValue = 100
        MinValue = 0
        TabOrder = 2
        Value = 35
      end
    end
  end
  object pnlDescription: TPanel
    Left = 0
    Top = 52
    Width = 327
    Height = 158
    Align = alClient
    BevelEdges = [beTop, beBottom]
    BevelKind = bkTile
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitHeight = 146
  end
  object pnlCategory: TPanel
    Left = 0
    Top = 0
    Width = 327
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblCategory: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 49
      Height = 19
      Align = alLeft
      Caption = 'Category:'
      ExplicitHeight = 13
    end
    object CBKateg: TComboBox
      AlignWithMargins = True
      Left = 58
      Top = 3
      Width = 266
      Height = 21
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      Text = 'New Category'
    end
  end
  object pnlName: TPanel
    Left = 0
    Top = 25
    Width = 327
    Height = 27
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblName: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 31
      Height = 21
      Align = alLeft
      Caption = 'Name:'
      ExplicitHeight = 13
    end
    object edtName: TEdit
      AlignWithMargins = True
      Left = 40
      Top = 3
      Width = 284
      Height = 21
      Align = alClient
      TabOrder = 0
    end
  end
  object ColorDialog1: TColorDialog
    Left = 96
    Top = 288
  end
end
