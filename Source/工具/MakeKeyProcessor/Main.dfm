object FrmMain: TFrmMain
  Left = 840
  Top = 143
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MakeKey'#37197#21046#22120
  ClientHeight = 303
  ClientWidth = 390
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox3: TGroupBox
    Left = 8
    Top = 8
    Width = 374
    Height = 57
    Caption = #37197#21046#25991#20214
    TabOrder = 0
    object Label11: TLabel
      Left = 8
      Top = 22
      Width = 48
      Height = 12
      Caption = 'MakeKey:'
    end
    object EditMakeKey: TRzButtonEdit
      Left = 62
      Top = 19
      Width = 300
      Height = 20
      TabOrder = 0
      AltBtnWidth = 15
      ButtonWidth = 15
      OnButtonClick = EditMakeKeyButtonClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 71
    Width = 374
    Height = 100
    Caption = #29992#25143#20449#24687
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 18
      Width = 42
      Height = 12
      Caption = #29992#25143'QQ:'
    end
    object Label9: TLabel
      Left = 8
      Top = 44
      Width = 42
      Height = 12
      Caption = #26426#22120#30721':'
    end
    object LabelDate: TLabel
      Left = 8
      Top = 72
      Width = 54
      Height = 12
      Caption = #27880#20876#26085#26399':'
    end
    object ComboBoxQQ: TComboBox
      Left = 62
      Top = 14
      Width = 300
      Height = 20
      ItemHeight = 12
      TabOrder = 0
      OnChange = ComboBoxQQChange
    end
    object ComboBoxSerialNumber: TComboBox
      Left = 62
      Top = 40
      Width = 300
      Height = 20
      ItemHeight = 12
      TabOrder = 1
      OnChange = ComboBoxSerialNumberChange
    end
  end
  object RadioGroup: TRadioGroup
    Left = 8
    Top = 224
    Width = 374
    Height = 41
    Caption = #36873#25321#29256#26412
    Color = clBtnFace
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      #20998#36523#29256
      #33521#38596#29256)
    ParentColor = False
    TabOrder = 2
  end
  object ButtonMakeKey: TButton
    Left = 8
    Top = 271
    Width = 89
    Height = 25
    Caption = #37197#21046'MakeKey'
    TabOrder = 3
    OnClick = ButtonMakeKeyClick
  end
  object ButtonSave: TButton
    Left = 103
    Top = 271
    Width = 89
    Height = 25
    Caption = #20445#23384#29992#25143#20449#24687
    TabOrder = 4
    OnClick = ButtonSaveClick
  end
  object ButtonClose: TButton
    Left = 293
    Top = 271
    Width = 89
    Height = 25
    Caption = #36864#20986
    TabOrder = 5
    OnClick = ButtonCloseClick
  end
  object ButtonDel: TButton
    Left = 198
    Top = 271
    Width = 89
    Height = 25
    Caption = #21024#38500#29992#25143#20449#24687
    TabOrder = 6
    OnClick = ButtonDelClick
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 177
    Width = 374
    Height = 41
    Caption = #36719#20214#31867#22411
    Color = clBtnFace
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'M2Server'#27880#20876#26426
      'ScriptLoader'#27880#20876#26426)
    ParentColor = False
    TabOrder = 7
    OnClick = RadioGroup1Click
  end
  object OpenDialog: TOpenDialog
    Filter = 'M2Server|(*.exe)'
    Left = 272
    Top = 72
  end
  object SaveDialog: TSaveDialog
    Filter = 'M2Server|*.exe'
    Left = 240
    Top = 72
  end
  object TimerStart: TTimer
    Enabled = False
    OnTimer = TimerStartTimer
    Left = 208
    Top = 72
  end
end
