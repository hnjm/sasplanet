object frTilesGenPrev: TfrTilesGenPrev
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  ParentShowHint = False
  ShowHint = True
  TabOrder = 0
  object pnlBottom: TPanel
    Left = 0
    Top = 22
    Width = 451
    Height = 282
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnlRight: TPanel
      Left = 337
      Top = 0
      Width = 114
      Height = 282
      Align = alRight
      BevelOuter = bvNone
      BorderWidth = 3
      TabOrder = 0
      object lblFromZoom: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 94
        Height = 13
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Align = alTop
        Caption = '�� ���� ��������:'
      end
      object lblZooms: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 43
        Width = 88
        Height = 13
        Margins.Left = 0
        Margins.Right = 0
        Align = alTop
        Caption = '� ���� ��������:'
      end
      object cbbFromZoom: TComboBox
        Left = 3
        Top = 19
        Width = 108
        Height = 21
        Align = alTop
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 0
        OnChange = cbbFromZoomChange
      end
      object chkAllZooms: TCheckBox
        Left = 3
        Top = 262
        Width = 108
        Height = 17
        Align = alBottom
        Caption = '���'
        TabOrder = 1
        OnClick = chkAllZoomsClick
      end
      object chklstZooms: TCheckListBox
        Left = 3
        Top = 59
        Width = 108
        Height = 203
        OnClickCheck = chklstZoomsClickCheck
        Align = alClient
        ItemHeight = 13
        TabOrder = 2
      end
    end
    object pnlCenter: TPanel
      Left = 0
      Top = 0
      Width = 337
      Height = 282
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 3
      TabOrder = 1
      DesignSize = (
        337
        282)
      object lblMap: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 331
        Height = 13
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Align = alTop
        AutoSize = False
        Caption = '��� �����:'
        ExplicitLeft = 7
        ExplicitTop = -1
        ExplicitWidth = 57
      end
      object lblStat: TLabel
        Left = 10
        Top = 100
        Width = 3
        Height = 13
        Anchors = [akLeft, akTop, akRight]
      end
      object lblResampler: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 43
        Width = 331
        Height = 13
        Margins.Left = 0
        Margins.Right = 0
        Align = alTop
        AutoSize = False
        Caption = '��������:'
        ExplicitLeft = 5
        ExplicitTop = 37
        ExplicitWidth = 52
      end
      object Bevel1: TBevel
        AlignWithMargins = True
        Left = 3
        Top = 85
        Width = 331
        Height = 3
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Shape = bsTopLine
        ExplicitTop = 83
      end
      object cbbMap: TComboBox
        Left = 3
        Top = 19
        Width = 331
        Height = 21
        Align = alTop
        Style = csDropDownList
        DropDownCount = 16
        ItemHeight = 0
        TabOrder = 0
      end
      object cbbResampler: TComboBox
        Left = 3
        Top = 59
        Width = 331
        Height = 21
        Align = alTop
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'Box'
        Items.Strings = (
          'Box'
          'Linear'
          'Cosine'
          'Spline'
          'Mitchell'
          'Cubic'
          'Hermite'
          'Lanczos'
          'Gaussian'
          'Blackman'
          'Hann'
          'Hamming'
          'Sinsh')
      end
      object chkReplace: TCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 91
        Width = 331
        Height = 17
        Margins.Left = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = '�������� ������������ �����'
        TabOrder = 2
      end
      object chkSaveFullOnly: TCheckBox
        Left = 3
        Top = 108
        Width = 331
        Height = 17
        Align = alTop
        Caption = '��������� ������ ��������� ����������� �����'
        TabOrder = 3
      end
      object chkFromPrevZoom: TCheckBox
        Left = 3
        Top = 125
        Width = 331
        Height = 17
        Align = alTop
        Caption = '����������� ������ ��������� ������� �� ����������� ����������'
        TabOrder = 4
        OnClick = chkFromPrevZoomClick
      end
    end
  end
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
    Caption = '������������ ���������� ���� ����������� �����'
    TabOrder = 1
  end
end
