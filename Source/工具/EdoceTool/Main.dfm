object frmMain: TfrmMain
  Left = 479
  Top = 240
  BorderStyle = bsDialog
  Caption = 'frmMain'
  ClientHeight = 103
  ClientWidth = 605
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 12
  object Button1: TButton
    Left = 88
    Top = 41
    Width = 75
    Height = 25
    Caption = #21152#23494
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 250
    Top = 41
    Width = 75
    Height = 25
    Caption = #35299#23494
    TabOrder = 1
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 593
    Height = 20
    TabOrder = 2
  end
  object Edit2: TEdit
    Left = 8
    Top = 72
    Width = 593
    Height = 20
    TabOrder = 3
  end
  object Button3: TButton
    Left = 169
    Top = 41
    Width = 75
    Height = 25
    Caption = #36895#24230#27979#35797
    TabOrder = 4
    Visible = False
    OnClick = Button3Click
  end
  object RadioButton1: TRadioButton
    Left = 8
    Top = 34
    Width = 65
    Height = 17
    Caption = 'Mir'#21152#23494
    TabOrder = 5
  end
  object RadioButton2: TRadioButton
    Left = 8
    Top = 49
    Width = 45
    Height = 17
    Caption = #21152#23494
    Checked = True
    TabOrder = 6
    TabStop = True
  end
  object Button4: TButton
    Left = 331
    Top = 41
    Width = 75
    Height = 25
    Caption = 'Hash'
    TabOrder = 7
    Visible = False
    OnClick = Button4Click
  end
  object Edit3: TEdit
    Left = 476
    Top = 46
    Width = 121
    Height = 20
    TabOrder = 8
    Text = 'Edit3'
    Visible = False
  end
  object Button5: TButton
    Left = 416
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Button5'
    TabOrder = 9
    OnClick = Button5Click
  end
end
