object FrmMain: TFrmMain
  Left = 691
  Top = 127
  Width = 550
  Height = 536
  Caption = 'FrmMain'
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
  object ButtonStart: TButton
    Left = 208
    Top = 464
    Width = 75
    Height = 25
    Caption = #24320#22987
    TabOrder = 0
    OnClick = ButtonStartClick
  end
  object Memo: TMemo
    Left = 0
    Top = 0
    Width = 534
    Height = 449
    Align = alTop
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object Timer: TTimer
    Interval = 100
    OnTimer = TimerTimer
    Left = 416
    Top = 456
  end
end
