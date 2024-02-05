object FrmMain: TFrmMain
  Left = 571
  Top = 136
  BorderStyle = bsDialog
  Caption = #26426#22120#30721#35835#21462#24037#20855
  ClientHeight = 266
  ClientWidth = 314
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 12
  object RadioGroup: TRadioGroup
    Left = 8
    Top = 121
    Width = 297
    Height = 41
    Caption = #36873#25321#29256#26412
    Color = clBtnFace
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      #20998#36523#29256
      #33521#38596#29256)
    ParentColor = False
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 10
    Width = 297
    Height = 55
    Caption = #29992#25143#20449#24687
    TabOrder = 1
    object Label2: TLabel
      Left = 12
      Top = 27
      Width = 42
      Height = 12
      Caption = #29992#25143'QQ:'
    end
    object EditQQ: TEdit
      Left = 64
      Top = 24
      Width = 225
      Height = 20
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 168
    Width = 297
    Height = 59
    Caption = #26426#22120#30721
    TabOrder = 2
    object Label1: TLabel
      Left = 12
      Top = 27
      Width = 42
      Height = 12
      Caption = #26426#22120#30721':'
    end
    object EditSerialNumber: TEdit
      Left = 64
      Top = 24
      Width = 225
      Height = 20
      ReadOnly = True
      TabOrder = 0
    end
  end
  object ButtonOK: TButton
    Left = 8
    Top = 233
    Width = 75
    Height = 25
    Caption = #33719#21462#26426#22120#30721
    TabOrder = 3
    OnClick = ButtonOKClick
  end
  object ButtonClose: TButton
    Left = 231
    Top = 233
    Width = 75
    Height = 25
    Caption = #20851#38381
    TabOrder = 4
    OnClick = ButtonCloseClick
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 74
    Width = 297
    Height = 41
    Caption = #36719#20214#31867#22411
    Color = clBtnFace
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'M2Server'#27880#20876#26426
      'ScriptLoader'#27880#20876#26426)
    ParentColor = False
    TabOrder = 5
    OnClick = RadioGroup1Click
  end
end
