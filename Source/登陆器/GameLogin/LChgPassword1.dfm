object frmChangePassword: TfrmChangePassword
  Left = 994
  Top = 274
  BorderStyle = bsDialog
  Caption = #20462#25913#30331#24405#23494#30721
  ClientHeight = 186
  ClientWidth = 265
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object Label14: TLabel
    Left = 8
    Top = 166
    Width = 66
    Height = 12
    Caption = #26381#21153#22120#29366#24577':'
    Transparent = True
  end
  object LabelStatus: TLabel
    Left = 76
    Top = 166
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
    Top = 6
    Width = 249
    Height = 154
    Caption = #20462#25913#24080#21495#23494#30721
    TabOrder = 0
    object Label9: TLabel
      Left = 8
      Top = 28
      Width = 54
      Height = 12
      Caption = #30331#24405#24080#21495':'
      Transparent = True
    end
    object Label10: TLabel
      Left = 8
      Top = 52
      Width = 42
      Height = 12
      Caption = #26087#23494#30721':'
      Transparent = True
    end
    object Label2: TLabel
      Left = 8
      Top = 76
      Width = 42
      Height = 12
      Caption = #26032#23494#30721':'
      Transparent = True
    end
    object Label1: TLabel
      Left = 8
      Top = 100
      Width = 54
      Height = 12
      Caption = #30830#35748#23494#30721':'
      Transparent = True
    end
    object EditAccount: TEdit
      Left = 72
      Top = 28
      Width = 121
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      TabOrder = 0
    end
    object EditPassword: TEdit
      Left = 72
      Top = 50
      Width = 121
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 1
    end
    object EditNewPassword: TEdit
      Left = 72
      Top = 74
      Width = 121
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 2
    end
    object EditConfirm: TEdit
      Left = 72
      Top = 96
      Width = 121
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 3
    end
    object ButtonOK: TButton
      Left = 168
      Top = 120
      Width = 75
      Height = 25
      Caption = #30830#23450'(&O)'
      TabOrder = 4
      OnClick = ButtonOKClick
    end
  end
end
