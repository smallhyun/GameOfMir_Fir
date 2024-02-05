object frmOption: TfrmOption
  Left = 1286
  Top = 18
  BorderStyle = bsDialog
  Caption = #39134#23572#19990#30028
  ClientHeight = 354
  ClientWidth = 250
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 250
    Height = 335
    ActivePage = TabSheet1
    Align = alClient
    MultiLine = True
    TabOrder = 0
    OnMouseMove = PageControlMouseMove
    object TabSheet9: TTabSheet
      Caption = #22522#26412#35774#32622
      ImageIndex = 6
      object Label1: TLabel
        Left = 223
        Top = 15
        Width = 12
        Height = 12
        Caption = #31186
      end
      object Label11: TLabel
        Left = 159
        Top = 68
        Width = 12
        Height = 12
        Caption = #20998
      end
      object Label14: TLabel
        Left = 231
        Top = 132
        Width = 12
        Height = 12
        Caption = #31186
      end
      object CheckBoxHumUseMagic: TCheckBox
        Left = 3
        Top = 14
        Width = 73
        Height = 17
        Caption = #20154#29289#32451#21151
        TabOrder = 0
        OnClick = CheckBoxHumUseMagicClick
      end
      object ComboBoxHumMagic: TComboBox
        Left = 82
        Top = 12
        Width = 87
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        TabOrder = 1
        OnSelect = ComboBoxHumMagicSelect
        Items.Strings = (
          'F1'
          'F2'
          'F3'
          'F4'
          'F5'
          'F6'
          'F7'
          'F8'
          'F9'
          'F10'
          'F11'
          'F12')
      end
      object EditHumUseMagicTime: TSpinEdit
        Left = 175
        Top = 12
        Width = 42
        Height = 21
        MaxValue = 0
        MinValue = 0
        TabOrder = 2
        Value = 5
        OnChange = EditHumUseMagicTimeChange
      end
      object CheckBoxHeroStateChange: TCheckBox
        Left = 3
        Top = 38
        Width = 73
        Height = 17
        Caption = #33521#38596#21464#33394
        TabOrder = 3
        OnClick = CheckBoxHeroStateChangeClick
      end
      object ComboBoxHeroStateChange: TComboBox
        Left = 82
        Top = 39
        Width = 87
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        TabOrder = 4
        OnSelect = ComboBoxHeroStateChangeSelect
        Items.Strings = (
          #28784#10#33394
          #32043#33394
          #32418#33394
          #34013#33394
          #32511#33394)
      end
      object ButtonBaseSave: TButton
        Left = 176
        Top = 232
        Width = 56
        Height = 25
        Caption = #20445#23384
        TabOrder = 5
        OnClick = ButtonBaseSaveClick
      end
      object CheckBoxAutoQueryBagItem: TCheckBox
        Left = 3
        Top = 66
        Width = 102
        Height = 17
        Caption = #33258#21160#21047#26032#21253#35065
        TabOrder = 6
        OnClick = CheckBoxAutoQueryBagItemClick
      end
      object EditAutoQueryBagItem: TSpinEdit
        Left = 111
        Top = 64
        Width = 42
        Height = 21
        MaxValue = 60
        MinValue = 1
        TabOrder = 7
        Value = 5
        OnChange = EditAutoQueryBagItemChange
      end
      object CheckBoxFastEatItem: TCheckBox
        Left = 3
        Top = 96
        Width = 105
        Height = 17
        Caption = #24320#21551#21160#21452#37325#21917#33647
        TabOrder = 8
        OnClick = CheckBoxFastEatItemClick
      end
      object CheckBoxAutoUseItem: TCheckBox
        Left = 3
        Top = 126
        Width = 94
        Height = 17
        Caption = #33258#21160#20351#29992#29289#21697
        TabOrder = 9
        OnClick = CheckBoxAutoUseItemClick
      end
      object ComboBoxAutoUseItem: TComboBox
        Left = 98
        Top = 127
        Width = 79
        Height = 20
        ItemHeight = 0
        TabOrder = 10
        OnSelect = ComboBoxAutoUseItemSelect
      end
      object EditAutoUseItem: TSpinEdit
        Left = 183
        Top = 128
        Width = 42
        Height = 21
        MaxValue = 60
        MinValue = 1
        TabOrder = 11
        Value = 5
        OnChange = EditAutoUseItemChange
      end
    end
    object TabSheet1: TTabSheet
      Caption = #20154#29289#20445#25252
      object Label2: TLabel
        Left = 0
        Top = 224
        Width = 36
        Height = 12
        Caption = 'Label2'
      end
      object Label5: TLabel
        Left = 80
        Top = 160
        Width = 36
        Height = 12
        Caption = 'Label5'
        Visible = False
      end
      object CheckBoxHumUseHP: TCheckBox
        Left = 0
        Top = 9
        Width = 33
        Height = 17
        Caption = 'HP'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = CheckBoxHumUseHPClick
      end
      object EditHumMinHP: TSpinEdit
        Left = 32
        Top = 8
        Width = 57
        Height = 21
        AutoSize = False
        Ctl3D = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        MaxValue = 65535
        MinValue = 0
        ParentCtl3D = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 1
        Value = 100
        OnChange = EditHumMinHPChange
      end
      object EditHumHPTime: TSpinEdit
        Left = 192
        Top = 8
        Width = 49
        Height = 21
        AutoSize = False
        Ctl3D = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        MaxValue = 10000
        MinValue = 0
        ParentCtl3D = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 2
        Value = 1000
        OnChange = EditHumHPTimeChange
        OnMouseMove = EditHumHPTimeMouseMove
      end
      object CheckBoxHumUseMP: TCheckBox
        Left = 0
        Top = 32
        Width = 33
        Height = 17
        Caption = 'MP'
        Checked = True
        State = cbChecked
        TabOrder = 3
        OnClick = CheckBoxHumUseMPClick
      end
      object EditHumMinMP: TSpinEdit
        Left = 32
        Top = 32
        Width = 57
        Height = 21
        Ctl3D = False
        MaxValue = 65535
        MinValue = 0
        ParentCtl3D = False
        TabOrder = 4
        Value = 100
        OnChange = EditHumMinMPChange
      end
      object EditHumMPTime: TSpinEdit
        Left = 192
        Top = 32
        Width = 49
        Height = 21
        AutoSize = False
        Ctl3D = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        MaxValue = 10000
        MinValue = 0
        ParentCtl3D = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 5
        Value = 1000
        OnChange = EditHumMPTimeChange
        OnMouseMove = EditHumHPTimeMouseMove
      end
      object CheckBoxUseFlyItem: TCheckBox
        Left = 0
        Top = 113
        Width = 89
        Height = 17
        Caption = #20351#29992#38543#26426' HP<'
        Checked = True
        State = cbChecked
        TabOrder = 6
        OnClick = CheckBoxUseFlyItemClick
      end
      object EditUseflyItemMinHP: TSpinEdit
        Left = 96
        Top = 110
        Width = 57
        Height = 21
        Ctl3D = False
        MaxValue = 65535
        MinValue = 0
        ParentCtl3D = False
        TabOrder = 7
        Value = 80
        OnChange = EditUseflyItemMinHPChange
      end
      object CheckBoxExitGame: TCheckBox
        Left = 0
        Top = 94
        Width = 89
        Height = 17
        Caption = #23567#36864'     HP<'
        TabOrder = 8
        Visible = False
      end
      object EditExitGameMinHP: TSpinEdit
        Left = 96
        Top = 91
        Width = 57
        Height = 21
        Ctl3D = False
        MaxValue = 65535
        MinValue = 0
        ParentCtl3D = False
        TabOrder = 9
        Value = 30
        Visible = False
      end
      object CheckBoxUseReturnItem: TCheckBox
        Left = 0
        Top = 131
        Width = 89
        Height = 17
        Caption = #22238#22478'     HP<'
        Checked = True
        State = cbChecked
        TabOrder = 10
        OnClick = CheckBoxUseReturnItemClick
      end
      object EditUseReturnItemMinHP: TSpinEdit
        Left = 96
        Top = 128
        Width = 57
        Height = 21
        Ctl3D = False
        MaxValue = 65535
        MinValue = 0
        ParentCtl3D = False
        TabOrder = 11
        Value = 50
        OnChange = EditUseReturnItemMinHPChange
      end
      object CheckBoxNoRedReturn: TCheckBox
        Left = 152
        Top = 121
        Width = 97
        Height = 17
        Caption = #27809#32418#33647#26102#22238#22478
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 12
        Visible = False
      end
      object CheckBoxCreateGroupKey: TCheckBox
        Left = 0
        Top = 153
        Width = 73
        Height = 17
        Caption = #19968#38190#32452#38431
        Checked = True
        State = cbChecked
        TabOrder = 13
        OnClick = CheckBoxCreateGroupKeyClick
      end
      object ComboBoxCreateGroupKey: TComboBox
        Left = 137
        Top = 153
        Width = 97
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        TabOrder = 14
        OnChange = ComboBoxRecallHeroChange
      end
      object Button2: TButton
        Left = 79
        Top = 232
        Width = 75
        Height = 25
        Caption = 'TEST'
        TabOrder = 15
        Visible = False
        OnClick = Button2Click
      end
      object ButtonHumOptionSave: TButton
        Left = 176
        Top = 232
        Width = 56
        Height = 25
        Caption = #20445#23384
        TabOrder = 16
        OnClick = ButtonHumOptionSaveClick
      end
      object CheckBoxHumUseHP1: TCheckBox
        Left = 0
        Top = 57
        Width = 33
        Height = 17
        Caption = 'HP'
        Checked = True
        State = cbChecked
        TabOrder = 17
        OnClick = CheckBoxHumUseHP1Click
      end
      object CheckBoxHumUseMP1: TCheckBox
        Left = 0
        Top = 80
        Width = 33
        Height = 17
        Caption = 'MP'
        Checked = True
        State = cbChecked
        TabOrder = 18
        OnClick = CheckBoxHumUseMP1Click
      end
      object EditHumMinHP1: TSpinEdit
        Left = 32
        Top = 56
        Width = 57
        Height = 21
        AutoSize = False
        Ctl3D = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        MaxValue = 65535
        MinValue = 0
        ParentCtl3D = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 19
        Value = 100
        OnChange = EditHumMinHP1Change
      end
      object EditHumMinMP1: TSpinEdit
        Left = 32
        Top = 80
        Width = 57
        Height = 21
        Ctl3D = False
        MaxValue = 65535
        MinValue = 0
        ParentCtl3D = False
        TabOrder = 20
        Value = 100
        OnChange = EditHumMinMP1Change
      end
      object EditHumHPTime1: TSpinEdit
        Left = 192
        Top = 56
        Width = 49
        Height = 21
        AutoSize = False
        Ctl3D = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        MaxValue = 10000
        MinValue = 0
        ParentCtl3D = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 21
        Value = 1000
        OnChange = EditHumHPTime1Change
        OnMouseMove = EditHumHPTimeMouseMove
      end
      object EditHumMPTime1: TSpinEdit
        Left = 192
        Top = 80
        Width = 49
        Height = 21
        AutoSize = False
        Ctl3D = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        MaxValue = 10000
        MinValue = 0
        ParentCtl3D = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 22
        Value = 1000
        OnChange = EditHumMPTime1Change
        OnMouseMove = EditHumHPTimeMouseMove
      end
      object ComboBoxHumEatHPItem: TComboBox
        Left = 96
        Top = 8
        Width = 89
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        TabOrder = 23
        OnChange = ComboBoxHumEatHPItemChange
      end
      object ComboBoxHumEatMPItem: TComboBox
        Left = 96
        Top = 32
        Width = 89
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        TabOrder = 24
        OnChange = ComboBoxHumEatHPItemChange
      end
      object ComboBoxHumEatHPItem1: TComboBox
        Left = 96
        Top = 56
        Width = 89
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        TabOrder = 25
        OnChange = ComboBoxHumEatHPItemChange
      end
      object ComboBoxHumEatMPItem1: TComboBox
        Left = 96
        Top = 80
        Width = 89
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        TabOrder = 26
        OnChange = ComboBoxHumEatHPItemChange
      end
      object CheckBoxHumChangeState: TCheckBox
        Left = 0
        Top = 177
        Width = 97
        Height = 17
        Caption = #19968#38190#20999#25442#27169#24335
        Checked = True
        State = cbChecked
        TabOrder = 27
        OnClick = CheckBoxHumChangeStateClick
      end
      object ComboBoxHumChangeState: TComboBox
        Left = 137
        Top = 177
        Width = 97
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        TabOrder = 28
        OnChange = ComboBoxRecallHeroChange
      end
      object ComboBoxGetHumBagItems: TComboBox
        Left = 137
        Top = 203
        Width = 97
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        TabOrder = 29
        OnChange = ComboBoxRecallHeroChange
      end
      object CheckBoxGetHumBagItems: TCheckBox
        Left = 0
        Top = 201
        Width = 97
        Height = 17
        Caption = #19968#38190#21047#26032#21253#35065
        Checked = True
        State = cbChecked
        TabOrder = 30
        OnClick = CheckBoxGetHumBagItemsClick
      end
      object SpinEdit1: TSpinEdit
        Left = 16
        Top = 235
        Width = 57
        Height = 21
        Ctl3D = False
        MaxValue = 65535
        MinValue = 0
        ParentCtl3D = False
        TabOrder = 31
        Value = 1104
        Visible = False
      end
      object SpinEdit2: TSpinEdit
        Left = 74
        Top = 199
        Width = 57
        Height = 21
        Ctl3D = False
        MaxValue = 65535
        MinValue = 0
        ParentCtl3D = False
        TabOrder = 32
        Value = 1052
        Visible = False
      end
    end
    object TabSheet5: TTabSheet
      Caption = #33521#38596#20445#25252
      ImageIndex = 3
      object Label3: TLabel
        Left = 0
        Top = 232
        Width = 36
        Height = 12
        Caption = 'Label3'
      end
      object CheckBoxHeroUseHP: TCheckBox
        Left = 0
        Top = 9
        Width = 33
        Height = 17
        Caption = 'HP'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = CheckBoxHeroUseHPClick
      end
      object EditHeroMinHP: TSpinEdit
        Left = 32
        Top = 8
        Width = 57
        Height = 21
        AutoSize = False
        Ctl3D = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        MaxValue = 65535
        MinValue = 0
        ParentCtl3D = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 1
        Value = 100
        OnChange = EditHeroMinHPChange
      end
      object EditHeroHPTime: TSpinEdit
        Left = 192
        Top = 8
        Width = 49
        Height = 21
        AutoSize = False
        Ctl3D = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        MaxValue = 10000
        MinValue = 0
        ParentCtl3D = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 2
        Value = 1000
        OnChange = EditHeroHPTimeChange
        OnMouseMove = EditHumHPTimeMouseMove
      end
      object CheckBoxHeroUseMP: TCheckBox
        Left = 0
        Top = 32
        Width = 33
        Height = 17
        Caption = 'MP'
        Checked = True
        State = cbChecked
        TabOrder = 3
        OnClick = CheckBoxHeroUseMPClick
      end
      object EditHeroMinMP: TSpinEdit
        Left = 32
        Top = 32
        Width = 57
        Height = 18
        Ctl3D = False
        MaxValue = 65535
        MinValue = 0
        ParentCtl3D = False
        TabOrder = 4
        Value = 100
        OnChange = EditHeroMinMPChange
      end
      object EditHeroMPTime: TSpinEdit
        Left = 192
        Top = 32
        Width = 49
        Height = 21
        AutoSize = False
        Ctl3D = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        MaxValue = 10000
        MinValue = 0
        ParentCtl3D = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 5
        Value = 1000
        OnChange = EditHeroMPTimeChange
        OnMouseMove = EditHumHPTimeMouseMove
      end
      object CheckBoxHeroTakeback: TCheckBox
        Left = 0
        Top = 104
        Width = 97
        Height = 17
        Caption = #25910#22238#33521#38596' HP<'
        Checked = True
        State = cbChecked
        TabOrder = 6
        OnClick = CheckBoxHeroTakebackClick
      end
      object EditTakeBackHeroMinHP: TSpinEdit
        Left = 96
        Top = 102
        Width = 57
        Height = 18
        Ctl3D = False
        MaxValue = 65535
        MinValue = 0
        ParentCtl3D = False
        TabOrder = 7
        Value = 80
        OnChange = EditTakeBackHeroMinHPChange
      end
      object CheckBoxRecallHero: TCheckBox
        Left = 0
        Top = 125
        Width = 129
        Height = 17
        Caption = #19968#38190#21484#21796#25110#25910#22238#33521#38596
        Checked = True
        State = cbChecked
        TabOrder = 8
        OnClick = CheckBoxRecallHeroClick
      end
      object CheckBoxGroupMagic: TCheckBox
        Left = 0
        Top = 146
        Width = 73
        Height = 17
        Caption = #19968#38190#21512#20987
        Checked = True
        State = cbChecked
        TabOrder = 9
        OnClick = CheckBoxGroupMagicClick
      end
      object ComboBoxRecallHero: TComboBox
        Left = 137
        Top = 125
        Width = 97
        Height = 20
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 10
        OnChange = ComboBoxRecallHeroChange
      end
      object ComboBoxGroupMagic: TComboBox
        Left = 137
        Top = 146
        Width = 97
        Height = 20
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 11
        OnChange = ComboBoxRecallHeroChange
      end
      object ComboBoxTarget: TComboBox
        Left = 137
        Top = 167
        Width = 97
        Height = 20
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 12
        OnChange = ComboBoxRecallHeroChange
      end
      object ComboBoxGuard: TComboBox
        Left = 137
        Top = 188
        Width = 97
        Height = 20
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 13
        OnChange = ComboBoxRecallHeroChange
      end
      object ComboBoxChangeState: TComboBox
        Left = 137
        Top = 209
        Width = 97
        Height = 20
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 14
        OnChange = ComboBoxRecallHeroChange
      end
      object CheckBoxTarget: TCheckBox
        Left = 0
        Top = 167
        Width = 73
        Height = 17
        Caption = #19968#38190#38145#23450
        Checked = True
        State = cbChecked
        TabOrder = 15
        OnClick = CheckBoxTargetClick
      end
      object CheckBoxGuard: TCheckBox
        Left = 0
        Top = 188
        Width = 73
        Height = 17
        Caption = #19968#38190#23432#25252
        Checked = True
        State = cbChecked
        TabOrder = 16
        OnClick = CheckBoxGuardClick
      end
      object ButtonHeroOptionSave: TButton
        Left = 176
        Top = 232
        Width = 56
        Height = 25
        Caption = #20445#23384
        TabOrder = 17
        OnClick = ButtonHumOptionSaveClick
      end
      object CheckBoxHeroUseHP1: TCheckBox
        Left = 0
        Top = 57
        Width = 33
        Height = 17
        Caption = 'HP'
        Checked = True
        State = cbChecked
        TabOrder = 18
        OnClick = CheckBoxHeroUseHP1Click
      end
      object CheckBoxHeroUseMP1: TCheckBox
        Left = 0
        Top = 80
        Width = 33
        Height = 17
        Caption = 'MP'
        Checked = True
        State = cbChecked
        TabOrder = 19
        OnClick = CheckBoxHeroUseMP1Click
      end
      object EditHeroMinHP1: TSpinEdit
        Left = 32
        Top = 56
        Width = 57
        Height = 21
        AutoSize = False
        Ctl3D = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        MaxValue = 65535
        MinValue = 0
        ParentCtl3D = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 20
        Value = 100
        OnChange = EditHeroMinHP1Change
      end
      object EditHeroMinMP1: TSpinEdit
        Left = 32
        Top = 80
        Width = 57
        Height = 18
        Ctl3D = False
        MaxValue = 65535
        MinValue = 0
        ParentCtl3D = False
        TabOrder = 21
        Value = 100
        OnChange = EditHeroMinMP1Change
      end
      object EditHeroHPTime1: TSpinEdit
        Left = 192
        Top = 56
        Width = 49
        Height = 21
        AutoSize = False
        Ctl3D = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        MaxValue = 10000
        MinValue = 0
        ParentCtl3D = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 22
        Value = 1000
        OnChange = EditHeroHPTime1Change
        OnMouseMove = EditHumHPTimeMouseMove
      end
      object EditHeroMPTime1: TSpinEdit
        Left = 192
        Top = 80
        Width = 49
        Height = 21
        AutoSize = False
        Ctl3D = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        MaxValue = 10000
        MinValue = 0
        ParentCtl3D = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 23
        Value = 1000
        OnChange = EditHeroMPTime1Change
        OnMouseMove = EditHumHPTimeMouseMove
      end
      object ComboBoxHeroEatHPItem: TComboBox
        Left = 96
        Top = 8
        Width = 89
        Height = 20
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 24
        OnChange = ComboBoxHeroEatHPItemChange
      end
      object ComboBoxHeroEatMPItem: TComboBox
        Left = 96
        Top = 32
        Width = 89
        Height = 20
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 25
        OnChange = ComboBoxHeroEatHPItemChange
      end
      object ComboBoxHeroEatHPItem1: TComboBox
        Left = 96
        Top = 56
        Width = 89
        Height = 20
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 26
        OnChange = ComboBoxHeroEatHPItemChange
      end
      object ComboBoxHeroEatMPItem1: TComboBox
        Left = 96
        Top = 80
        Width = 89
        Height = 20
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 27
        OnChange = ComboBoxHeroEatHPItemChange
      end
      object CheckBoxChangeState: TCheckBox
        Left = 0
        Top = 209
        Width = 73
        Height = 17
        Caption = #19968#38190#20999#25442
        Checked = True
        State = cbChecked
        TabOrder = 28
        OnClick = CheckBoxChangeStateClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = #33647#21697#35774#32622
      ImageIndex = 2
      object Label16: TLabel
        Left = 4
        Top = 220
        Width = 30
        Height = 12
        Caption = #29289#21697':'
      end
      object Label4: TLabel
        Left = 4
        Top = 240
        Width = 42
        Height = 12
        Caption = #29289#21697#21253':'
      end
      object ListViewProtectItem: TListView
        Left = 0
        Top = 0
        Width = 241
        Height = 161
        Columns = <
          item
            Caption = #31867#22411
            Width = 40
          end
          item
            Caption = #29289#21697
            Width = 90
          end
          item
            Caption = #29289#21697#21253
            Width = 90
          end>
        GridLines = True
        RowSelect = True
        SortType = stBoth
        TabOrder = 0
        ViewStyle = vsReport
        OnClick = ListViewProtectItemClick
      end
      object ButtonProtectAddItem: TButton
        Left = 200
        Top = 168
        Width = 39
        Height = 20
        Caption = #22686#21152
        TabOrder = 1
        OnClick = ButtonProtectAddItemClick
      end
      object ButtonProtectChgItem: TButton
        Left = 200
        Top = 192
        Width = 39
        Height = 20
        Caption = #20462#25913
        TabOrder = 2
        OnClick = ButtonProtectChgItemClick
      end
      object ButtonProtectDelItem: TButton
        Left = 200
        Top = 216
        Width = 39
        Height = 20
        Caption = #21024#38500
        TabOrder = 3
        OnClick = ButtonProtectDelItemClick
      end
      object ButtonProtectSaveItem: TButton
        Left = 200
        Top = 240
        Width = 39
        Height = 20
        Caption = #20445#23384
        TabOrder = 4
        OnClick = ButtonProtectSaveItemClick
      end
      object GroupBox: TGroupBox
        Left = 0
        Top = 168
        Width = 177
        Height = 41
        Caption = #29289#21697#31867#22411
        TabOrder = 5
        object RadioButtonHP: TRadioButton
          Left = 8
          Top = 16
          Width = 33
          Height = 17
          Caption = 'HP'
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object RadioButtonMP: TRadioButton
          Left = 48
          Top = 16
          Width = 33
          Height = 17
          Caption = 'MP'
          TabOrder = 1
        end
        object RadioButtonHMP: TRadioButton
          Left = 88
          Top = 16
          Width = 41
          Height = 17
          Caption = 'HMP'
          TabOrder = 2
        end
        object RadioButtonOther: TRadioButton
          Left = 128
          Top = 16
          Width = 41
          Height = 17
          Caption = #20854#20182
          TabOrder = 3
        end
      end
      object EditProtectItemName: TComboBox
        Left = 48
        Top = 216
        Width = 145
        Height = 20
        ItemHeight = 12
        TabOrder = 6
      end
      object EditProtectUnbindItemName: TComboBox
        Left = 48
        Top = 234
        Width = 145
        Height = 20
        ItemHeight = 12
        TabOrder = 7
      end
    end
    object TabSheet4: TTabSheet
      Caption = #20854#20182#35774#32622
      ImageIndex = 3
      TabVisible = False
      object Label6: TLabel
        Left = 80
        Top = 192
        Width = 36
        Height = 12
        Caption = 'Label6'
      end
      object Label10: TLabel
        Left = 0
        Top = 192
        Width = 42
        Height = 12
        Caption = 'Label10'
      end
      object Button3: TButton
        Left = 160
        Top = 200
        Width = 75
        Height = 25
        Caption = 'Button3'
        TabOrder = 0
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 160
        Top = 232
        Width = 75
        Height = 25
        Caption = 'Button4'
        TabOrder = 1
        OnClick = Button4Click
      end
      object PageControl2: TPageControl
        Left = 0
        Top = 0
        Width = 242
        Height = 185
        ActivePage = TabSheet2
        Align = alTop
        TabOrder = 2
        object TabSheet2: TTabSheet
          Caption = 'TabSheet2'
          object Memo1: TMemo
            Left = 0
            Top = 0
            Width = 234
            Height = 158
            Align = alClient
            Lines.Strings = (
              'Memo1')
            ScrollBars = ssBoth
            TabOrder = 0
          end
        end
        object TabSheet7: TTabSheet
          Caption = 'TabSheet7'
          ImageIndex = 1
          object Memo2: TMemo
            Left = 0
            Top = 0
            Width = 234
            Height = 158
            Align = alClient
            Lines.Strings = (
              'Memo1')
            ScrollBars = ssBoth
            TabOrder = 0
          end
        end
      end
      object Button1: TButton
        Left = 80
        Top = 232
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 3
        OnClick = Button1Click
      end
      object Button5: TButton
        Left = 80
        Top = 208
        Width = 75
        Height = 25
        Caption = 'Button5'
        TabOrder = 4
        OnClick = Button5Click
      end
    end
    object TabSheet6: TTabSheet
      Caption = #24618#29289#25552#31034
      ImageIndex = 4
      object ButtonSaveBossMon: TSpeedButton
        Left = 200
        Top = 240
        Width = 41
        Height = 20
        Caption = #20445#23384
        OnClick = ButtonSaveBossMonClick
      end
      object ListViewBossList: TListView
        Left = 0
        Top = 0
        Width = 242
        Height = 209
        Align = alTop
        Columns = <
          item
            Caption = #24618#29289#21517#31216
            Width = 120
          end
          item
            Caption = #22352#26631#25552#31034
            Width = 60
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnClick = ListViewBossListClick
      end
      object CheckHintBossXY: TCheckBox
        Left = 8
        Top = 216
        Width = 73
        Height = 17
        Caption = #22352#26631#25552#31034
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = CheckHintBossXYClick
      end
      object EditBossMonName: TEdit
        Left = 0
        Top = 240
        Width = 113
        Height = 20
        AutoSelect = False
        TabOrder = 2
      end
      object ButtonAddBossMon: TButton
        Left = 120
        Top = 240
        Width = 41
        Height = 20
        Caption = #22686#21152
        TabOrder = 3
        OnClick = ButtonAddBossMonClick
      end
      object ButtonDelBossMon: TButton
        Left = 160
        Top = 240
        Width = 41
        Height = 20
        Caption = #21024#38500
        TabOrder = 4
        OnClick = ButtonDelBossMonClick
      end
    end
    object TabSheet8: TTabSheet
      Caption = #26497#21697#25552#31034
      ImageIndex = 5
      object ButtonSaveItems: TSpeedButton
        Left = 190
        Top = 238
        Width = 49
        Height = 21
        Caption = #20445#23384
        OnClick = ButtonSaveItemsClick
      end
      object Label7: TLabel
        Left = 74
        Top = 222
        Width = 54
        Height = 12
        Caption = #20256#36865#21629#20196':'
      end
      object Label9: TLabel
        Left = 144
        Top = 200
        Width = 54
        Height = 12
        Caption = #20256#36865#36895#24230':'
      end
      object ComboBoxItemType: TComboBox
        Left = 0
        Top = 0
        Width = 241
        Height = 20
        ItemHeight = 0
        TabOrder = 0
        Text = #36873#25321#29289#21697#31867#22411
        OnSelect = ComboBoxItemTypeSelect
      end
      object ListViewItemList: TListView
        Left = 0
        Top = 24
        Width = 241
        Height = 169
        Columns = <
          item
            Caption = #29289#21697#21517#31216
            Width = 80
          end
          item
            Caption = #33258#21160#25441#21462
            Width = 60
          end
          item
            Caption = #25552#31034
            Width = 40
          end
          item
            Caption = #20256#36865#25441#21462
            Width = 60
          end>
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        GridLines = True
        ReadOnly = True
        RowSelect = True
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 1
        ViewStyle = vsReport
        OnClick = ListViewItemListClick
      end
      object CheckPickUpItem: TCheckBox
        Left = 3
        Top = 199
        Width = 73
        Height = 17
        Caption = #33258#21160#25441#29289
        TabOrder = 2
        OnClick = CheckItemHintClick
      end
      object CheckItemHint: TCheckBox
        Left = 74
        Top = 199
        Width = 67
        Height = 17
        Caption = #22352#26631#25552#31034
        Checked = True
        State = cbChecked
        TabOrder = 3
        OnClick = CheckItemHintClick
      end
      object EditItemName: TEdit
        Left = 0
        Top = 240
        Width = 89
        Height = 20
        AutoSelect = False
        TabOrder = 4
      end
      object ButtonDelItem: TButton
        Left = 92
        Top = 240
        Width = 49
        Height = 20
        Caption = #21024#38500
        TabOrder = 5
        OnClick = ButtonDelItemClick
      end
      object ButtonAddItem: TButton
        Left = 142
        Top = 240
        Width = 49
        Height = 20
        Caption = #22686#21152
        TabOrder = 6
        OnClick = ButtonAddItemClick
      end
      object CheckBoxMovePick: TCheckBox
        Left = 3
        Top = 217
        Width = 73
        Height = 17
        Caption = #20256#36865#25441#21462
        TabOrder = 7
        OnClick = CheckItemHintClick
      end
      object EditMoveCmd: TEdit
        Left = 128
        Top = 218
        Width = 66
        Height = 20
        TabOrder = 8
        Text = '@Move'
        OnMouseMove = EditMoveCmdMouseMove
      end
      object EditMoveTime: TSpinEdit
        Left = 200
        Top = 199
        Width = 39
        Height = 21
        MaxValue = 60
        MinValue = 1
        TabOrder = 9
        Value = 5
        OnMouseMove = EditMoveTimeMouseMove
      end
    end
    object TabSheet10: TTabSheet
      Caption = #21507#33647#22320#22270
      ImageIndex = 7
      object Label8: TLabel
        Left = 3
        Top = 220
        Width = 54
        Height = 12
        Caption = #22320#22270#21517#31216':'
      end
      object ButtonMapFilterDel: TButton
        Left = 92
        Top = 240
        Width = 49
        Height = 20
        Caption = #21024#38500
        TabOrder = 0
        OnClick = ButtonMapFilterDelClick
      end
      object ButtonMapFilterAdd: TButton
        Left = 142
        Top = 240
        Width = 49
        Height = 20
        Caption = #22686#21152
        TabOrder = 1
        OnClick = ButtonMapFilterAddClick
      end
      object EditMapFilter: TEdit
        Left = 63
        Top = 216
        Width = 121
        Height = 20
        TabOrder = 2
      end
      object GroupBox1: TGroupBox
        Left = 3
        Top = 0
        Width = 236
        Height = 214
        Caption = #31105#27490#33258#21160#21507#33647#22320#22270#21015#34920
        TabOrder = 3
        object ListBoxMapFilter: TListBox
          Left = 2
          Top = 14
          Width = 232
          Height = 198
          Align = alClient
          ItemHeight = 12
          TabOrder = 0
          OnClick = ListBoxMapFilterClick
          OnMouseMove = ListBoxMapFilterMouseMove
        end
      end
      object ButtonMapFilterSave: TButton
        Left = 192
        Top = 240
        Width = 49
        Height = 20
        Caption = #20445#23384
        TabOrder = 4
        OnClick = ButtonMapFilterSaveClick
      end
    end
    object TabSheet11: TTabSheet
      Caption = #32842#22825#35774#32622
      ImageIndex = 8
      object Label12: TLabel
        Left = 79
        Top = 39
        Width = 24
        Height = 12
        Caption = #38388#38548
      end
      object Label13: TLabel
        Left = 174
        Top = 38
        Width = 12
        Height = 12
        Caption = #31186
      end
      object CheckBoxAutoAnswer: TCheckBox
        Left = 3
        Top = 9
        Width = 73
        Height = 17
        Caption = #33258#21160#22238#22797
        TabOrder = 0
        OnClick = CheckBoxAutoAnswerClick
      end
      object AutoAnswerMsg: TComboBox
        Tag = -1
        Left = 82
        Top = 10
        Width = 153
        Height = 20
        ImeName = #20013#25991' ('#31616#20307') - '#26234#33021' ABC'
        ItemHeight = 12
        MaxLength = 190
        TabOrder = 1
        Items.Strings = (
          #24744#22909#65292#25105#26377#20107#19981#22312
          #25105#21435#21507#39277#20102'....'
          #25346#26426#20013'....'
          #25346#26426#32451#21151' '#35831#21247#25171#25200)
      end
      object CheckboxAutoSay: TCheckBox
        Left = 3
        Top = 35
        Width = 65
        Height = 17
        Caption = #33258#21160#21457#35328
        TabOrder = 2
        OnClick = CheckboxAutoSayClick
      end
      object EditSayMsgTime: TSpinEdit
        Left = 112
        Top = 36
        Width = 56
        Height = 21
        AutoSize = False
        Ctl3D = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        MaxValue = 100
        MinValue = 0
        ParentCtl3D = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 3
        Value = 30
        OnChange = EditSayMsgTimeChange
      end
      object ButtonAddSayMsg: TButton
        Left = 3
        Top = 231
        Width = 56
        Height = 25
        Caption = #22686#21152
        TabOrder = 4
        OnClick = ButtonAddSayMsgClick
      end
      object EditSayMsg: TEdit
        Left = 4
        Top = 205
        Width = 231
        Height = 20
        TabOrder = 5
      end
      object ButtonDelSayMsg: TButton
        Left = 65
        Top = 231
        Width = 56
        Height = 25
        Caption = #21024#38500
        TabOrder = 6
        OnClick = ButtonDelSayMsgClick
      end
      object ButtonSaveSayMsg: TButton
        Left = 127
        Top = 231
        Width = 56
        Height = 25
        Caption = #20445#23384
        TabOrder = 7
        OnClick = ButtonSaveSayMsgClick
      end
      object ListBoxSayMsg: TListBox
        Left = 4
        Top = 63
        Width = 232
        Height = 136
        ItemHeight = 12
        TabOrder = 8
      end
    end
    object TabSheet12: TTabSheet
      Caption = #29289#21697#36807#28388
      ImageIndex = 9
      object MemoFilterItem: TMemo
        Left = 3
        Top = -1
        Width = 232
        Height = 233
        ScrollBars = ssVertical
        TabOrder = 0
        OnChange = MemoFilterItemChange
        OnMouseMove = MemoFilterItemMouseMove
      end
      object ButtonSaveFilterItem: TButton
        Left = 164
        Top = 238
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 1
        OnClick = ButtonSaveFilterItemClick
      end
      object CheckBoxFilterItem: TCheckBox
        Left = 3
        Top = 242
        Width = 97
        Height = 17
        Caption = #24320#21551#29289#21697#36807#28388
        TabOrder = 2
        OnClick = CheckBoxFilterItemClick
      end
    end
    object TabSheet13: TTabSheet
      Caption = #39764#27861#38145#23450
      ImageIndex = 10
      object CheckBoxMagicLock: TCheckBox
        Left = 142
        Top = 215
        Width = 97
        Height = 17
        Caption = #24320#21551#39764#27861#38145#23450
        TabOrder = 0
        OnClick = CheckBoxMagicLockClick
      end
      object ListBoxMagicLock: TListBox
        Left = 3
        Top = 2
        Width = 236
        Height = 207
        ItemHeight = 12
        TabOrder = 1
        OnMouseMove = ListBoxMagicLockMouseMove
      end
      object ComboBoxMagicLock: TComboBox
        Left = 3
        Top = 216
        Width = 133
        Height = 20
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 2
      end
      object ButtonAddMagicLock: TButton
        Left = 0
        Top = 240
        Width = 75
        Height = 25
        Caption = #22686#21152#39764#27861
        TabOrder = 3
        OnClick = ButtonAddMagicLockClick
      end
      object ButtonSaveMagicLock: TButton
        Left = 164
        Top = 240
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 4
        OnClick = ButtonSaveMagicLockClick
      end
      object ButtonDelMagicLock: TButton
        Left = 79
        Top = 240
        Width = 75
        Height = 25
        Caption = #21024#38500#39764#27861
        TabOrder = 5
        OnClick = ButtonDelMagicLockClick
      end
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 335
    Width = 250
    Height = 19
    Panels = <
      item
        Width = 220
      end
      item
        Width = 50
      end>
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 120
    Top = 224
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 84
    Top = 232
  end
end
