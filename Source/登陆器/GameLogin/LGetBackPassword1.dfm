object frmGetBackPassword: TfrmGetBackPassword
  Left = 652
  Top = 334
  BorderStyle = bsDialog
  Caption = #25214#22238#23494#30721
  ClientHeight = 177
  ClientWidth = 335
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 12
  object Label14: TLabel
    Left = 8
    Top = 157
    Width = 66
    Height = 12
    Caption = #26381#21153#22120#29366#24577':'
    Transparent = True
  end
  object LabelStatus: TLabel
    Left = 78
    Top = 158
    Width = 6
    Height = 12
    Font.Charset = GB2312_CHARSET
    Font.Color = clGreen
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object GroupBox: TGroupBox
    Left = 8
    Top = 1
    Width = 321
    Height = 150
    Caption = #23494#30721#20445#25252#20449#24687
    TabOrder = 0
    object Label9: TLabel
      Left = 9
      Top = 26
      Width = 54
      Height = 12
      Caption = #30331#24405#24080#21495':'
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label5: TLabel
      Left = 8
      Top = 50
      Width = 42
      Height = 12
      Caption = #38382#39064#19968':'
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label6: TLabel
      Left = 8
      Top = 74
      Width = 42
      Height = 12
      Caption = #31572#26696#19968':'
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label8: TLabel
      Left = 8
      Top = 98
      Width = 42
      Height = 12
      Caption = #38382#39064#20108':'
      Transparent = True
    end
    object Label7: TLabel
      Left = 8
      Top = 122
      Width = 42
      Height = 12
      Caption = #31572#26696#20108':'
      Transparent = True
    end
    object Label1: TLabel
      Left = 160
      Top = 26
      Width = 54
      Height = 12
      Caption = #30331#24405#23494#30721':'
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label2: TLabel
      Left = 216
      Top = 50
      Width = 54
      Height = 12
      Caption = #20986#29983#24180#26376':'
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object EditAccount: TEdit
      Left = 64
      Top = 24
      Width = 89
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      TabOrder = 0
      Text = 'EditAccount'
    end
    object EditQuiz1: TEdit
      Left = 64
      Top = 48
      Width = 145
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object EditAnswer1: TEdit
      Left = 64
      Top = 72
      Width = 145
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object EditQuiz2: TEdit
      Left = 64
      Top = 96
      Width = 145
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object EditAnswer2: TEdit
      Left = 64
      Top = 120
      Width = 145
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object EditPassword: TEdit
      Left = 216
      Top = 24
      Width = 89
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object EditBirthDay: TEdit
      Left = 216
      Top = 72
      Width = 89
      Height = 20
      Hint = #36755#20837#27880#20876#26102#22635#20889#30340#20986#29983#26085#26399'('#26684#24335#20363#22914':1980/01/01)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object ButtonOK: TButton
      Left = 224
      Top = 112
      Width = 75
      Height = 25
      Caption = #30830#23450'(&O)'
      TabOrder = 7
      OnClick = ButtonOKClick
    end
  end
end
