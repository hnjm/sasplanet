object frTilesDownload: TfrTilesDownload
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  ParentShowHint = False
  ShowHint = True
  TabOrder = 0
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 451
    Height = 22
    Align = alTop
    Alignment = taLeftJustify
    BevelEdges = [beBottom]
    BevelKind = bkTile
    BevelOuter = bvNone
    BorderWidth = 3
    Caption = '��������� ����������� �� ���������'
    TabOrder = 0
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 22
    Width = 451
    Height = 282
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pnlRight: TPanel
      Left = 392
      Top = 0
      Width = 59
      Height = 282
      Align = alRight
      BevelOuter = bvNone
      BorderWidth = 5
      TabOrder = 0
      object lblZoom: TLabel
        AlignWithMargins = True
        Left = 5
        Top = 5
        Width = 49
        Height = 13
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Align = alTop
        Caption = '�������:'
      end
      object cbbZoom: TComboBox
        Left = 5
        Top = 21
        Width = 49
        Height = 21
        Align = alTop
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = cbbZoomChange
      end
    end
    object pnlMain: TPanel
      Left = 0
      Top = 0
      Width = 392
      Height = 282
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 5
      TabOrder = 1
      object lblStat: TLabel
        AlignWithMargins = True
        Left = 5
        Top = 45
        Width = 382
        Height = 13
        Margins.Left = 0
        Margins.Right = 0
        Align = alTop
        Caption = '_'
        ExplicitWidth = 6
      end
      object lblMap: TLabel
        AlignWithMargins = True
        Left = 5
        Top = 5
        Width = 382
        Height = 13
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Align = alTop
        Caption = '��� �����:'
        ExplicitWidth = 57
      end
      object Bevel1: TBevel
        Left = 5
        Top = 61
        Width = 382
        Height = 5
        Align = alTop
        Shape = bsTopLine
        ExplicitLeft = 3
        ExplicitTop = 54
        ExplicitWidth = 386
      end
      object cbbMap: TComboBox
        Left = 5
        Top = 21
        Width = 382
        Height = 21
        Align = alTop
        Style = csDropDownList
        DropDownCount = 16
        ItemHeight = 13
        TabOrder = 0
      end
      object chkReplace: TCheckBox
        Left = 5
        Top = 82
        Width = 382
        Height = 16
        Align = alTop
        Caption = '�������� ������ �����'
        TabOrder = 1
        OnClick = chkReplaceClick
      end
      object chkTryLoadIfTNE: TCheckBox
        Left = 5
        Top = 66
        Width = 382
        Height = 16
        Align = alTop
        Caption = '�������� ��������� ������������� �����'
        TabOrder = 2
      end
      object pnlTileReplaceCondition: TPanel
        Left = 5
        Top = 98
        Width = 382
        Height = 40
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        BorderWidth = 3
        Padding.Left = 15
        TabOrder = 3
        object chkReplaceIfDifSize: TCheckBox
          Left = 18
          Top = 3
          Width = 361
          Height = 13
          Align = alTop
          Caption = '������ ��� �� ��������'
          Enabled = False
          TabOrder = 0
        end
        object pnlReplaceOlder: TPanel
          Left = 18
          Top = 16
          Width = 361
          Height = 21
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object lblReplaceOlder: TLabel
            Left = 16
            Top = 0
            Width = 113
            Height = 21
            Align = alLeft
            Caption = '������ ��������� �� '
            Layout = tlCenter
            ExplicitHeight = 13
          end
          object chkReplaceOlder: TCheckBox
            Left = 0
            Top = 0
            Width = 16
            Height = 21
            Align = alLeft
            Enabled = False
            TabOrder = 0
            OnClick = chkReplaceOlderClick
          end
          object dtpReplaceOlderDate: TDateTimePicker
            Left = 129
            Top = 0
            Width = 81
            Height = 21
            Align = alLeft
            Date = 39513.436381111110000000
            Time = 39513.436381111110000000
            Enabled = False
            TabOrder = 1
          end
        end
      end
    end
  end
end
