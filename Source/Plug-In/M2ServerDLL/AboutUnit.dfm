object FrmAbout: TFrmAbout
  Left = 587
  Top = 347
  BorderStyle = bsDialog
  Caption = #24110#21161
  ClientHeight = 330
  ClientWidth = 408
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 393
    Height = 281
    TabOrder = 0
    object Image: TImage
      Left = 24
      Top = 32
      Width = 41
      Height = 57
      AutoSize = True
    end
    object Label1: TLabel
      Left = 88
      Top = 40
      Width = 36
      Height = 12
      Caption = 'Label1'
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 88
      Top = 88
      Width = 36
      Height = 12
      Caption = 'Label1'
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 88
      Top = 136
      Width = 36
      Height = 12
      Caption = 'Label1'
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 88
      Top = 184
      Width = 78
      Height = 12
      Caption = #23548#20837#25480#26435#25991#20214':'
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object EditDomainName: TRzButtonEdit
      Left = 168
      Top = 180
      Width = 217
      Height = 20
      Text = ''
      TabOrder = 0
      Visible = False
      AltBtnWidth = 15
      ButtonWidth = 15
      OnButtonClick = EditDomainNameButtonClick
    end
  end
  object ButtonOK: TButton
    Left = 320
    Top = 296
    Width = 75
    Height = 25
    Caption = #30830#23450'(&O)'
    TabOrder = 1
    OnClick = ButtonOKClick
  end
  object OpenDialog: TOpenDialog
    Filter = '*.key|*.key'
    Left = 224
    Top = 128
  end
end
