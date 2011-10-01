object frmProgressDownload: TfrmProgressDownload
  Left = 226
  Top = 306
  BorderStyle = bsSizeToolWin
  Caption = 'Please wait...'
  ClientHeight = 219
  ClientWidth = 328
  Color = clBtnFace
  Constraints.MinHeight = 243
  Constraints.MinWidth = 336
  ParentFont = True
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  ScreenSnap = True
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 328
    Height = 219
    Align = alClient
    TabOrder = 0
    OnResize = Panel1Resize
    DesignSize = (
      328
      219)
    object LabelValue0: TLabel
      Left = 315
      Top = 90
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      BiDiMode = bdLeftToRight
      Caption = '  '
      ParentBiDiMode = False
      Layout = tlCenter
      ExplicitTop = 119
    end
    object LabelValue1: TLabel
      Left = 315
      Top = 109
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      BiDiMode = bdLeftToRight
      Caption = '  '
      ParentBiDiMode = False
      Layout = tlCenter
      ExplicitTop = 138
    end
    object LabelValue2: TLabel
      Left = 315
      Top = 121
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      BiDiMode = bdLeftToRight
      Caption = '  '
      ParentBiDiMode = False
      Layout = tlCenter
      ExplicitTop = 150
    end
    object LabelValue3: TLabel
      Left = 315
      Top = 140
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      BiDiMode = bdLeftToRight
      Caption = '  '
      ParentBiDiMode = False
      Layout = tlCenter
      ExplicitTop = 169
    end
    object LabelName0: TLabel
      Left = 8
      Top = 92
      Width = 112
      Height = 13
      Anchors = [akLeft, akBottom]
      BiDiMode = bdLeftToRight
      Caption = 'Process not more than:'
      ParentBiDiMode = False
      Layout = tlCenter
    end
    object LabelName1: TLabel
      Left = 8
      Top = 108
      Width = 78
      Height = 13
      Anchors = [akLeft, akBottom]
      BiDiMode = bdLeftToRight
      Caption = 'Processed total:'
      ParentBiDiMode = False
      Layout = tlCenter
    end
    object LabelName2: TLabel
      Left = 8
      Top = 124
      Width = 88
      Height = 13
      Anchors = [akLeft, akBottom]
      BiDiMode = bdLeftToRight
      Caption = 'Downloaded total:'
      ParentBiDiMode = False
      Layout = tlCenter
    end
    object LabelName3: TLabel
      Left = 8
      Top = 140
      Width = 75
      Height = 13
      Anchors = [akLeft, akBottom]
      BiDiMode = bdLeftToRight
      Caption = 'Time remaining:'
      ParentBiDiMode = False
      Layout = tlCenter
    end
    object LabelName4: TLabel
      Left = 8
      Top = 156
      Width = 105
      Height = 13
      Anchors = [akLeft, akBottom]
      BiDiMode = bdLeftToRight
      Caption = 'Approx. to download:'
      ParentBiDiMode = False
      Layout = tlCenter
    end
    object LabelValue4: TLabel
      Left = 315
      Top = 156
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      BiDiMode = bdLeftToRight
      Caption = '  '
      ParentBiDiMode = False
      Layout = tlCenter
      ExplicitTop = 185
    end
    object Memo1: TMemo
      Left = 8
      Top = 8
      Width = 313
      Height = 76
      Anchors = [akLeft, akTop, akRight, akBottom]
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object pnlBottom: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 189
      Width = 320
      Height = 26
      Margins.Top = 0
      Align = alBottom
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 2
      object Button2: TButton
        AlignWithMargins = True
        Left = 242
        Top = 3
        Width = 75
        Height = 20
        Align = alRight
        Caption = 'Quit'
        TabOrder = 0
        OnClick = Button2Click
      end
      object Button1: TButton
        AlignWithMargins = True
        Left = 161
        Top = 3
        Width = 75
        Height = 20
        Align = alRight
        Caption = 'Pause'
        TabOrder = 1
        OnClick = Button1Click
      end
      object ButtonSave: TButton
        AlignWithMargins = True
        Left = 80
        Top = 3
        Width = 75
        Height = 20
        Hint = 'Save current session'
        Align = alRight
        Caption = 'Save'
        TabOrder = 2
        OnClick = ButtonSaveClick
      end
      object Button3: TButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 75
        Height = 20
        Align = alLeft
        Caption = 'Minimize'
        TabOrder = 3
        OnClick = Button3Click
      end
    end
    object pnlProgress: TPanel
      AlignWithMargins = True
      Left = 6
      Top = 172
      Width = 316
      Height = 17
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      ExplicitTop = 169
    end
  end
  object SaveSessionDialog: TSaveDialog
    DefaultExt = '*.sls'
    Filter = 'Download session (*.sls)|*.sls'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 280
    Top = 184
  end
  object UpdateTimer: TTimer
    OnTimer = UpdateTimerTimer
    Left = 240
    Top = 184
  end
end
