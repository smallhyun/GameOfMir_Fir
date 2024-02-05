object FrmMain: TFrmMain
  Left = 499
  Top = 178
  BorderStyle = bsDialog
  Caption = 'FrmMain'
  ClientHeight = 90
  ClientWidth = 543
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
  object Label1: TLabel
    Left = 16
    Top = 40
    Width = 24
    Height = 12
    Caption = 'Hash'
  end
  object Label2: TLabel
    Left = 288
    Top = 40
    Width = 18
    Height = 12
    Caption = 'MD5'
  end
  object Edit1: TEdit
    Left = 58
    Top = 34
    Width = 95
    Height = 20
    TabOrder = 0
  end
  object RzButtonEdit1: TRzButtonEdit
    Left = 16
    Top = 8
    Width = 513
    Height = 20
    TabOrder = 1
    AltBtnWidth = 15
    ButtonWidth = 15
    OnButtonClick = RzButtonEdit1ButtonClick
  end
  object Button1: TButton
    Left = 169
    Top = 34
    Width = 75
    Height = 25
    Caption = 'GET'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Edit2: TEdit
    Left = 312
    Top = 35
    Width = 217
    Height = 20
    TabOrder = 3
  end
  object Edit3: TEdit
    Left = 16
    Top = 60
    Width = 337
    Height = 20
    TabOrder = 4
    Text = '/PGieW4lKPb5n3jC2acwFrwKv2z3kClsR'
  end
  object Button2: TButton
    Left = 359
    Top = 61
    Width = 75
    Height = 25
    Caption = 'GETHash'
    TabOrder = 5
    OnClick = Button2Click
  end
  object Edit4: TEdit
    Left = 440
    Top = 61
    Width = 89
    Height = 20
    TabOrder = 6
    Text = 'Edit4'
  end
  object OpenDialog1: TOpenDialog
    Left = 248
    Top = 32
  end
end
