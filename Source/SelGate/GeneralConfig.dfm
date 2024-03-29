object frmGeneralConfig: TfrmGeneralConfig
  Left = 475
  Top = 286
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #22522#26412#35774#32622
  ClientHeight = 158
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBoxNet: TGroupBox
    Left = 8
    Top = 8
    Width = 185
    Height = 113
    Caption = #32593#32476#35774#32622
    TabOrder = 0
    object LabelGateIPaddr: TLabel
      Left = 8
      Top = 20
      Width = 54
      Height = 12
      Caption = #32593#20851#22320#22336':'
    end
    object LabelGatePort: TLabel
      Left = 8
      Top = 44
      Width = 54
      Height = 12
      Caption = #32593#20851#31471#21475':'
    end
    object LabelServerPort: TLabel
      Left = 8
      Top = 92
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#31471#21475':'
    end
    object LabelServerIPaddr: TLabel
      Left = 8
      Top = 68
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#22320#22336':'
    end
    object EditGateIPaddr: TEdit
      Left = 80
      Top = 16
      Width = 97
      Height = 20
      TabOrder = 0
      Text = '127.0.0.1'
    end
    object EditGatePort: TEdit
      Left = 80
      Top = 40
      Width = 41
      Height = 20
      TabOrder = 1
      Text = '7200'
    end
    object EditServerPort: TEdit
      Left = 80
      Top = 88
      Width = 41
      Height = 20
      TabOrder = 2
      Text = '5000'
    end
    object EditServerIPaddr: TEdit
      Left = 80
      Top = 64
      Width = 97
      Height = 20
      TabOrder = 3
      Text = '127.0.0.1'
    end
  end
  object GroupBoxInfo: TGroupBox
    Left = 200
    Top = 8
    Width = 161
    Height = 113
    Caption = #22522#26412#21442#25968
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 20
      Width = 30
      Height = 12
      Caption = #26631#39064':'
    end
    object Label2: TLabel
      Left = 8
      Top = 44
      Width = 78
      Height = 12
      Caption = #20801#35768#21516#26102#22312#32447':'
    end
    object EditTitle: TEdit
      Left = 40
      Top = 16
      Width = 105
      Height = 20
      TabOrder = 0
      Text = #39134#23572#19990#30028
    end
    object CheckBoxMinimize: TCheckBox
      Left = 8
      Top = 64
      Width = 137
      Height = 17
      Caption = #21551#21160#25104#21151#21518#26368#23567#21270
      TabOrder = 1
      OnClick = CheckBoxMinimizeClick
    end
    object EditMaxCount: TSpinEdit
      Left = 88
      Top = 40
      Width = 57
      Height = 21
      MaxValue = 5000
      MinValue = 1
      TabOrder = 2
      Value = 2000
    end
  end
  object ButtonOK: TButton
    Left = 296
    Top = 128
    Width = 65
    Height = 25
    Caption = #30830#23450'(&O)'
    TabOrder = 2
    OnClick = ButtonOKClick
  end
end
