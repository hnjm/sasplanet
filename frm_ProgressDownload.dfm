object frmProgressDownload: TfrmProgressDownload
  Left = 226
  Top = 306
  Caption = 'Please wait...'
  ClientHeight = 233
  ClientWidth = 328
  Color = clBtnFace
  Constraints.MinHeight = 243
  Constraints.MinWidth = 336
  ParentFont = True
  OldCreateOrder = False
  PopupMode = pmExplicit
  Position = poMainFormCenter
  ShowHint = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 322
    Height = 227
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    OnResize = Panel1Resize
    object mmoLog: TMemo
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 316
      Height = 76
      Align = alClient
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object pnlBottom: TPanel
      Left = 0
      Top = 201
      Width = 322
      Height = 26
      Margins.Top = 0
      Align = alBottom
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 1
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
      Top = 167
      Width = 312
      Height = 17
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
    end
    object chkAutoCloseWhenFinish: TCheckBox
      Left = 0
      Top = 184
      Width = 322
      Height = 17
      Align = alBottom
      Caption = 'Auto close window after finish'
      TabOrder = 3
    end
    object pnlToProcess: TPanel
      Left = 0
      Top = 82
      Width = 322
      Height = 17
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 4
      object lblToProcess: TLabel
        Left = 0
        Top = 0
        Width = 112
        Height = 17
        Align = alLeft
        BiDiMode = bdLeftToRight
        Caption = 'Process not more than:'
        ParentBiDiMode = False
        Layout = tlCenter
        ExplicitHeight = 13
      end
      object lblToProcessValue: TLabel
        Left = 316
        Top = 0
        Width = 6
        Height = 17
        Align = alRight
        Alignment = taRightJustify
        BiDiMode = bdLeftToRight
        Caption = '  '
        ParentBiDiMode = False
        Layout = tlCenter
        ExplicitHeight = 13
      end
    end
    object pnlProcessed: TPanel
      Left = 0
      Top = 99
      Width = 322
      Height = 17
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 5
      object lblProcessed: TLabel
        Left = 0
        Top = 0
        Width = 78
        Height = 17
        Align = alLeft
        BiDiMode = bdLeftToRight
        Caption = 'Processed total:'
        ParentBiDiMode = False
        Layout = tlCenter
        ExplicitHeight = 13
      end
      object lblProcessedValue: TLabel
        Left = 316
        Top = 0
        Width = 6
        Height = 17
        Align = alRight
        Alignment = taRightJustify
        BiDiMode = bdLeftToRight
        Caption = '  '
        ParentBiDiMode = False
        Layout = tlCenter
        ExplicitHeight = 13
      end
    end
    object pnlDownloaded: TPanel
      Left = 0
      Top = 116
      Width = 322
      Height = 17
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 6
      object lblDownloaded: TLabel
        Left = 0
        Top = 0
        Width = 88
        Height = 17
        Align = alLeft
        BiDiMode = bdLeftToRight
        Caption = 'Downloaded total:'
        ParentBiDiMode = False
        Layout = tlCenter
        ExplicitHeight = 13
      end
      object lblDownloadedValue: TLabel
        Left = 316
        Top = 0
        Width = 6
        Height = 17
        Align = alRight
        Alignment = taRightJustify
        BiDiMode = bdLeftToRight
        Caption = '  '
        ParentBiDiMode = False
        Layout = tlCenter
        ExplicitHeight = 13
      end
    end
    object pnlSizeToFinish: TPanel
      Left = 0
      Top = 150
      Width = 322
      Height = 17
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 7
      object lblSizeToFinish: TLabel
        Left = 0
        Top = 0
        Width = 105
        Height = 17
        Align = alLeft
        BiDiMode = bdLeftToRight
        Caption = 'Approx. to download:'
        ParentBiDiMode = False
        Layout = tlCenter
        ExplicitHeight = 13
      end
      object lblSizeToFinishValue: TLabel
        Left = 316
        Top = 0
        Width = 6
        Height = 17
        Align = alRight
        Alignment = taRightJustify
        BiDiMode = bdLeftToRight
        Caption = '  '
        ParentBiDiMode = False
        Layout = tlCenter
        ExplicitHeight = 13
      end
    end
    object pnlTimeToFinish: TPanel
      Left = 0
      Top = 133
      Width = 322
      Height = 17
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 8
      object lblTimeToFinish: TLabel
        Left = 0
        Top = 0
        Width = 75
        Height = 17
        Align = alLeft
        BiDiMode = bdLeftToRight
        Caption = 'Time remaining:'
        ParentBiDiMode = False
        Layout = tlCenter
        ExplicitHeight = 13
      end
      object lblTimeToFinishValue: TLabel
        Left = 316
        Top = 0
        Width = 6
        Height = 17
        Align = alRight
        Alignment = taRightJustify
        BiDiMode = bdLeftToRight
        Caption = '  '
        ParentBiDiMode = False
        Layout = tlCenter
        ExplicitHeight = 13
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
