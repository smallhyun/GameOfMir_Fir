object FrmMain: TFrmMain
  Left = 599
  Top = 177
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'FrmMain'
  ClientHeight = 354
  ClientWidth = 436
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 209
    Height = 97
    Caption = #26381#21153#22120#20449#24687
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 22
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#21517#31216':'
    end
    object Label2: TLabel
      Left = 8
      Top = 42
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#22320#22336':'
    end
    object Label3: TLabel
      Left = 8
      Top = 64
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#31471#21475':'
    end
    object EditServerName: TEdit
      Left = 80
      Top = 18
      Width = 121
      Height = 20
      Hint = #28216#25103#26381#21153#22120#21517#31216
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = #32511#33394#20256#22855
    end
    object EditGameAddr: TEdit
      Left = 80
      Top = 40
      Width = 121
      Height = 20
      Hint = #28216#25103#26381#21153#22120'IP'#22320#22336
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = '127.0.0.1'
    end
    object EditGamePort: TEdit
      Left = 80
      Top = 62
      Width = 121
      Height = 20
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = '7000'
    end
  end
  object GroupBox2: TGroupBox
    Left = 224
    Top = 8
    Width = 201
    Height = 97
    Caption = #24080#21495#35774#32622
    TabOrder = 1
    object RadioButton1: TRadioButton
      Left = 8
      Top = 16
      Width = 81
      Height = 17
      Caption = #25353#39034#24207#29983#25104
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 8
      Top = 40
      Width = 73
      Height = 17
      Caption = #38543#26426#20135#29983
      TabOrder = 1
    end
    object EditAccount: TEdit
      Left = 96
      Top = 16
      Width = 89
      Height = 20
      MaxLength = 10
      TabOrder = 2
      Text = 'abcd'
    end
    object CheckBoxNewAccount: TCheckBox
      Left = 8
      Top = 64
      Width = 73
      Height = 17
      Caption = #21019#24314#24080#21495
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 112
    Width = 209
    Height = 73
    Caption = #30331#24405#35774#32622
    TabOrder = 2
    object Label4: TLabel
      Left = 8
      Top = 40
      Width = 66
      Height = 12
      Caption = #30331#24405#24635#20154#25968':'
    end
    object Label5: TLabel
      Left = 8
      Top = 20
      Width = 78
      Height = 12
      Caption = #21516#26102#30331#24405#20154#25968':'
    end
    object EditTotalChrCount: TEdit
      Left = 88
      Top = 40
      Width = 113
      Height = 20
      TabOrder = 0
      Text = '200'
    end
    object EditChrCount: TEdit
      Left = 88
      Top = 16
      Width = 113
      Height = 20
      TabOrder = 1
      Text = '10'
    end
  end
  object ButtonStart: TButton
    Left = 224
    Top = 160
    Width = 75
    Height = 25
    Caption = #30331#24405
    TabOrder = 3
    OnClick = ButtonStartClick
  end
  object MemoLog: TMemo
    Left = 8
    Top = 192
    Width = 417
    Height = 153
    Lines.Strings = (
      '')
    ScrollBars = ssBoth
    TabOrder = 4
  end
  object ButtonStop: TButton
    Left = 304
    Top = 160
    Width = 75
    Height = 25
    Caption = #20572#27490
    TabOrder = 5
    OnClick = ButtonStopClick
  end
  object TimerRun: TTimer
    Enabled = False
    Interval = 1
    OnTimer = TimerRunTimer
    Left = 336
    Top = 96
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 376
    Top = 96
  end
end
