object frmIP: TfrmIP
  Left = 539
  Top = 307
  Width = 431
  Height = 77
  Caption = 'frmIP'
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object EditIP: TEdit
    Left = 16
    Top = 8
    Width = 137
    Height = 20
    TabOrder = 0
    Text = '127.0.0.1'
  end
  object Button1: TButton
    Left = 168
    Top = 8
    Width = 49
    Height = 25
    Caption = #8592
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 224
    Top = 8
    Width = 49
    Height = 25
    Caption = #8594
    TabOrder = 2
    OnClick = Button2Click
  end
  object SpinEditIP: TSpinEdit
    Left = 288
    Top = 8
    Width = 121
    Height = 21
    MaxValue = 0
    MinValue = 0
    TabOrder = 3
    Value = 0
  end
end
