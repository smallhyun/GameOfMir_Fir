object FrmMain: TFrmMain
  Left = 971
  Top = 239
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'M2'#27880#20876#26426'['#31243#24207#21046#20316#65306'MakeGM QQ:1037527564]'
  ClientHeight = 293
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 313
    Height = 89
    Caption = #27880#20876#20449#24687
    TabOrder = 0
    object Label3: TLabel
      Left = 8
      Top = 49
      Width = 54
      Height = 12
      Caption = #27880#20876#22825#25968':'
    end
    object Label2: TLabel
      Left = 8
      Top = 24
      Width = 54
      Height = 12
      Caption = #32465#23450#22495#21517':'
    end
    object LabelDate: TLabel
      Left = 8
      Top = 72
      Width = 54
      Height = 12
      Caption = #27880#20876#26085#26399':'
    end
    object EditDays: TSpinEdit
      Left = 68
      Top = 46
      Width = 233
      Height = 21
      MaxValue = 65535
      MinValue = 0
      TabOrder = 0
      Value = 365
      OnChange = EditDaysChange
    end
    object ComboBoxDomainName: TComboBox
      Left = 68
      Top = 20
      Width = 233
      Height = 20
      ItemHeight = 12
      TabOrder = 1
      Text = 'www.51pao.com'
    end
  end
  object RadioGroupUserMode: TRadioGroup
    Left = 328
    Top = 144
    Width = 89
    Height = 110
    Caption = #27880#20876#31867#22411
    ItemIndex = 0
    Items.Strings = (
      #26085#26399#38480#21046
      #26080#38480#21046)
    TabOrder = 1
    OnClick = RadioGroupUserModeClick
  end
  object RadioGroupLicDay: TRadioGroup
    Left = 328
    Top = 8
    Width = 89
    Height = 130
    Caption = #25480#26435#22825#25968
    ItemIndex = 0
    Items.Strings = (
      #19968#20010#26376
      #21322#24180
      #19968#24180)
    TabOrder = 2
    OnClick = RadioGroupLicDayClick
  end
  object ButtonOK: TButton
    Left = 8
    Top = 260
    Width = 98
    Height = 25
    Caption = #21019#24314#27880#20876#25991#20214'(&M)'
    TabOrder = 3
  end
  object ButtonExit: TButton
    Left = 318
    Top = 260
    Width = 99
    Height = 25
    Caption = #20851#38381'(&E)'
    TabOrder = 4
    OnClick = ButtonExitClick
  end
  object MemoKey: TMemo
    Left = 8
    Top = 104
    Width = 313
    Height = 150
    TabOrder = 5
  end
  object ButtonSave: TButton
    Left = 112
    Top = 260
    Width = 98
    Height = 25
    Caption = #20445#23384#29992#25143#20449#24687'(&S)'
    TabOrder = 6
    OnClick = ButtonSaveClick
  end
  object ButtonDel: TButton
    Left = 214
    Top = 260
    Width = 98
    Height = 25
    Caption = #21024#38500#29992#25143#20449#24687'(&D)'
    TabOrder = 7
    OnClick = ButtonDelClick
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    Left = 208
    Top = 112
  end
  object SaveDialog: TSaveDialog
    Filter = 'DomainName|*.Key'
    Left = 240
    Top = 72
  end
end
