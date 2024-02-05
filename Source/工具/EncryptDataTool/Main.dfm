object FrmMain: TFrmMain
  Left = 829
  Top = 220
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MakeGM Data'#36164#28304#21387#32553#24037#20855
  ClientHeight = 140
  ClientWidth = 411
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object RzLabel1: TRzLabel
    Left = 8
    Top = 16
    Width = 54
    Height = 12
    Caption = 'Data'#25991#20214':'
    BlinkIntervalOff = 1
    BlinkIntervalOn = 1
  end
  object RzURLLabel1: TRzURLLabel
    Left = 144
    Top = 96
    Width = 125
    Height = 13
    Caption = 'http://www.MakeGM.com'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    BlinkIntervalOff = 1
    BlinkIntervalOn = 1
    URL = 'http://www.MakeGM.com'
  end
  object EditDataFile: TRzButtonEdit
    Left = 64
    Top = 12
    Width = 339
    Height = 20
    TabOrder = 0
    AltBtnWidth = 15
    ButtonWidth = 15
    OnButtonClick = EditDataFileButtonClick
  end
  object ButtonStart: TRzButton
    Left = 8
    Top = 91
    Caption = #21387#32553
    TabOrder = 1
    OnClick = ButtonStartClick
  end
  object RadioGroup: TRzRadioGroup
    Left = 8
    Top = 40
    Width = 395
    Height = 41
    Caption = #21387#32553#26041#24335
    Columns = 3
    ItemHotTrack = True
    ItemIndex = 0
    Items.Strings = (
      #21387#32553#26041#24335'1'
      #21387#32553#26041#24335'2'
      #21387#32553#26041#24335'3')
    TabOrder = 2
  end
  object ButtonClose: TRzButton
    Left = 328
    Top = 91
    Caption = #20851#38381
    TabOrder = 3
    OnClick = ButtonCloseClick
  end
  object ProgressBar: TProgressBar
    Left = 0
    Top = 123
    Width = 411
    Height = 17
    Align = alBottom
    TabOrder = 4
  end
  object OpenDialog: TOpenDialog
    Filter = #30495#24425#22270#29255#36164#28304#25991#20214'|*.Data'
    Left = 48
    Top = 72
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'Data'
    Filter = #30495#24425#22270#29255#36164#28304#25991#20214'|*.Data|*.Data'
    Title = #21019#24314'Data'#25991#20214
    Left = 88
    Top = 72
  end
end
