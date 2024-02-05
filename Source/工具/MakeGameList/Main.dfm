object FrmMain: TFrmMain
  Left = 731
  Top = 177
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'FrmMain'
  ClientHeight = 294
  ClientWidth = 466
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object TreeView: TTreeView
    Left = 8
    Top = 8
    Width = 178
    Height = 275
    Indent = 19
    TabOrder = 0
    OnClick = TreeViewClick
  end
  object GroupBox: TGroupBox
    Left = 192
    Top = 8
    Width = 265
    Height = 275
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 48
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#21517#31216':'
      Transparent = True
    end
    object Label2: TLabel
      Left = 8
      Top = 74
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#22320#22336':'
      Transparent = True
    end
    object Label3: TLabel
      Left = 8
      Top = 100
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#31471#21475':'
      Transparent = True
    end
    object Label4: TLabel
      Left = 8
      Top = 124
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#20844#21578':'
      Transparent = True
    end
    object Label5: TLabel
      Left = 8
      Top = 150
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#19987#21306':'
      Transparent = True
    end
    object Label6: TLabel
      Left = 8
      Top = 174
      Width = 54
      Height = 12
      Caption = #23448#26041#32593#31449':'
      Transparent = True
    end
    object Label7: TLabel
      Left = 8
      Top = 21
      Width = 54
      Height = 12
      Caption = #26174#31034#21517#31216':'
      Transparent = True
    end
    object EditServerName: TEdit
      Left = 80
      Top = 44
      Width = 177
      Height = 20
      Hint = #28216#25103#26381#21153#22120#21517#31216
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'MakeGM'
    end
    object EditGameAddr: TEdit
      Left = 80
      Top = 70
      Width = 177
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
      Top = 96
      Width = 177
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
    object EditNotice: TEdit
      Left = 80
      Top = 122
      Width = 177
      Height = 20
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Text = 'http://www.MakeGM.com'
    end
    object ButtonGameAdd: TButton
      Left = 8
      Top = 237
      Width = 57
      Height = 25
      Caption = #22686#21152
      TabOrder = 4
      OnClick = ButtonGameAddClick
    end
    object ButtonGameDel: TButton
      Left = 71
      Top = 237
      Width = 57
      Height = 25
      Caption = #21024#38500
      TabOrder = 5
      OnClick = ButtonGameDelClick
    end
    object ButtonGameSave: TButton
      Left = 197
      Top = 237
      Width = 57
      Height = 25
      Caption = #20445#23384
      TabOrder = 6
      OnClick = ButtonGameSaveClick
    end
    object EditAbil: TEdit
      Left = 80
      Top = 148
      Width = 177
      Height = 20
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      Text = 'MakeGM'#19987#21306
    end
    object ButtonChg: TButton
      Left = 134
      Top = 237
      Width = 57
      Height = 25
      Caption = #20462#25913
      TabOrder = 8
      OnClick = ButtonChgClick
    end
    object EditHomePage: TEdit
      Left = 80
      Top = 174
      Width = 177
      Height = 20
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      Text = 'http://www.MakeGM.com'
    end
    object CheckBoxEncrypt: TCheckBox
      Left = 8
      Top = 208
      Width = 41
      Height = 17
      Caption = #21152#23494
      TabOrder = 10
    end
    object CheckBoxExpand: TCheckBox
      Left = 71
      Top = 208
      Width = 65
      Height = 17
      Caption = #33258#21160#23637#24320
      TabOrder = 11
    end
    object EditCaption: TEdit
      Left = 80
      Top = 18
      Width = 177
      Height = 20
      Hint = #28216#25103#26381#21153#22120#21517#31216
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 12
      Text = 'MakeGM'
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerTimer
    Left = 232
    Top = 96
  end
end
