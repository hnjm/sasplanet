object frmProgressDownload: TfrmProgressDownload
  Left = 226
  Top = 306
  BorderStyle = bsSizeToolWin
  Caption = 'Please wait...'
  ClientHeight = 241
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
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 322
    Height = 235
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    OnResize = Panel1Resize
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 328
    ExplicitHeight = 219
    object mmoLog: TMemo
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 316
      Height = 84
      Align = alClient
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      ExplicitLeft = 0
      ExplicitTop = -13
      ExplicitWidth = 326
      ExplicitHeight = 72
    end
    object pnlBottom: TPanel
      Left = 0
      Top = 209
      Width = 322
      Height = 26
      Margins.Top = 0
      Align = alBottom
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 4
      ExplicitTop = 189
      ExplicitWidth = 320
      object btnClose: TButton
        AlignWithMargins = True
        Left = 244
        Top = 3
        Width = 75
        Height = 20
        Align = alRight
        Caption = 'Quit'
        TabOrder = 0
        OnClick = btnCloseClick
        ExplicitLeft = 242
      end
      object btnPause: TButton
        AlignWithMargins = True
        Left = 163
        Top = 3
        Width = 75
        Height = 20
        Align = alRight
        Caption = 'Pause'
        TabOrder = 1
        OnClick = btnPauseClick
        ExplicitLeft = 161
      end
      object btnSave: TButton
        AlignWithMargins = True
        Left = 82
        Top = 3
        Width = 75
        Height = 20
        Hint = 'Save current session'
        Align = alRight
        Caption = 'Save'
        TabOrder = 2
        OnClick = btnSaveClick
        ExplicitLeft = 80
      end
      object btnMinimize: TButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 75
        Height = 20
        Align = alLeft
        Caption = 'Minimize'
        TabOrder = 3
        OnClick = btnMinimizeClick
      end
    end
    object pnlProgress: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 175
      Width = 312
      Height = 17
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      ExplicitTop = 199
      ExplicitWidth = 316
    end
    object chkAutoCloseWhenFinish: TCheckBox
      Left = 0
      Top = 192
      Width = 322
      Height = 17
      Align = alBottom
      Caption = 'Auto close window after finish'
      TabOrder = 3
      ExplicitLeft = 2
      ExplicitTop = 237
      ExplicitWidth = 326
    end
    object pnlToProcess: TPanel
      Left = 0
      Top = 90
      Width = 322
      Height = 17
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 4
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 326
      object lblToProcess: TLabel
        Left = 0
        Top = 0
        Width = 112
        Height = 13
        Align = alLeft
        BiDiMode = bdLeftToRight
        Caption = 'Process not more than:'
        ParentBiDiMode = False
        Layout = tlCenter
      end
      object lblToProcessValue: TLabel
        Left = 316
        Top = 0
        Width = 6
        Height = 13
        Align = alRight
        Alignment = taRightJustify
        BiDiMode = bdLeftToRight
        Caption = '  '
        ParentBiDiMode = False
        Layout = tlCenter
      end
    end
    object pnlProcessed: TPanel
      Left = 0
      Top = 107
      Width = 322
      Height = 17
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 5
      ExplicitTop = 31
      ExplicitWidth = 326
      object lblProcessed: TLabel
        Left = 0
        Top = 0
        Width = 78
        Height = 13
        Align = alLeft
        BiDiMode = bdLeftToRight
        Caption = 'Processed total:'
        ParentBiDiMode = False
        Layout = tlCenter
      end
      object lblProcessedValue: TLabel
        Left = 316
        Top = 0
        Width = 6
        Height = 13
        Align = alRight
        Alignment = taRightJustify
        BiDiMode = bdLeftToRight
        Caption = '  '
        ParentBiDiMode = False
        Layout = tlCenter
      end
    end
    object pnlDownloaded: TPanel
      Left = 0
      Top = 124
      Width = 322
      Height = 17
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 6
      ExplicitLeft = 1
      ExplicitTop = 122
      ExplicitWidth = 326
      object lblDownloaded: TLabel
        Left = 0
        Top = 0
        Width = 88
        Height = 13
        Align = alLeft
        BiDiMode = bdLeftToRight
        Caption = 'Downloaded total:'
        ParentBiDiMode = False
        Layout = tlCenter
      end
      object lblDownloadedValue: TLabel
        Left = 316
        Top = 0
        Width = 6
        Height = 13
        Align = alRight
        Alignment = taRightJustify
        BiDiMode = bdLeftToRight
        Caption = '  '
        ParentBiDiMode = False
        Layout = tlCenter
      end
    end
    object pnlSizeToFinish: TPanel
      Left = 0
      Top = 158
      Width = 322
      Height = 17
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 7
      ExplicitLeft = -2
      ExplicitTop = 150
      ExplicitWidth = 326
      object lblSizeToFinish: TLabel
        Left = 0
        Top = 0
        Width = 105
        Height = 13
        Align = alLeft
        BiDiMode = bdLeftToRight
        Caption = 'Approx. to download:'
        ParentBiDiMode = False
        Layout = tlCenter
      end
      object lblSizeToFinishValue: TLabel
        Left = 316
        Top = 0
        Width = 6
        Height = 13
        Align = alRight
        Alignment = taRightJustify
        BiDiMode = bdLeftToRight
        Caption = '  '
        ParentBiDiMode = False
        Layout = tlCenter
      end
    end
    object pnlTimeToFinish: TPanel
      Left = 0
      Top = 141
      Width = 322
      Height = 17
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 8
      ExplicitLeft = -2
      ExplicitTop = 150
      ExplicitWidth = 326
      object lblTimeToFinish: TLabel
        Left = 0
        Top = 0
        Width = 75
        Height = 13
        Align = alLeft
        BiDiMode = bdLeftToRight
        Caption = 'Time remaining:'
        ParentBiDiMode = False
        Layout = tlCenter
      end
      object lblTimeToFinishValue: TLabel
        Left = 316
        Top = 0
        Width = 6
        Height = 13
        Align = alRight
        Alignment = taRightJustify
        BiDiMode = bdLeftToRight
        Caption = '  '
        ParentBiDiMode = False
        Layout = tlCenter
      end
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
