object frmUserManage: TfrmUserManage
  Left = 877
  Top = 100
  BorderStyle = bsDialog
  Caption = 'frmUserManage'
  ClientHeight = 624
  ClientWidth = 360
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object RzLabel1: TLabel
    Left = 8
    Top = 16
    Width = 54
    Height = 12
    Caption = #23448#26041#32593#31449':'
    Transparent = False
  end
  object Label2: TLabel
    Left = 108
    Top = 415
    Width = 18
    Height = 12
    Caption = 'IP:'
  end
  object EditUserLiense: TEdit
    Left = 64
    Top = 12
    Width = 289
    Height = 20
    TabOrder = 0
  end
  object ButtonOK: TButton
    Left = 196
    Top = 594
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 1
    OnClick = ButtonOKClick
  end
  object ButtonCancel: TButton
    Left = 277
    Top = 594
    Width = 75
    Height = 25
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 2
    OnClick = ButtonCancelClick
  end
  object CheckBoxCheckNoticeUrl: TCheckBox
    Left = 8
    Top = 391
    Width = 145
    Height = 17
    Caption = #26816#27979#20844#21578#22320#22336#26159#21542#27491#30830
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object CheckBoxWriteHosts: TCheckBox
    Left = 8
    Top = 414
    Width = 73
    Height = 17
    Caption = #20889#20837'HOSTS'
    TabOrder = 4
  end
  object EditHostsAddress: TEdit
    Left = 128
    Top = 414
    Width = 143
    Height = 20
    TabOrder = 5
  end
  object CheckBoxWriteUrlEntry: TCheckBox
    Left = 8
    Top = 437
    Width = 73
    Height = 17
    Caption = #20889#20837#32531#23384
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object RzGroupBox1: TRzGroupBox
    Left = 9
    Top = 38
    Width = 343
    Height = 99
    Caption = #33258#21160#26356#26032
    TabOrder = 7
    object RzLabel2: TRzLabel
      Left = 15
      Top = 48
      Width = 24
      Height = 12
      Caption = 'MD5:'
      BlinkIntervalOff = 1
      BlinkIntervalOn = 1
    end
    object RzLabel3: TRzLabel
      Left = 14
      Top = 74
      Width = 54
      Height = 12
      Caption = #26356#26032#22320#22336':'
      BlinkIntervalOff = 1
      BlinkIntervalOn = 1
    end
    object RzLabel8: TRzLabel
      Left = 14
      Top = 120
      Width = 78
      Height = 12
      Caption = #26356#26032#25991#20214#21517#31216':'
      BlinkIntervalOff = 1
      BlinkIntervalOn = 1
    end
    object RzEditMD5: TRzEdit
      Left = 74
      Top = 42
      Width = 261
      Height = 20
      TabOrder = 0
    end
    object RzRadioButtonCompulsiveUpdata: TRzRadioButton
      Left = 95
      Top = 19
      Width = 74
      Height = 17
      Caption = #24378#21046#26356#26032
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object RzRadioButtonHintUpData: TRzRadioButton
      Left = 175
      Top = 19
      Width = 74
      Height = 17
      Caption = #26356#26032#25552#31034
      TabOrder = 2
    end
    object RzCheckBoxAllowUpData: TRzCheckBox
      Left = 15
      Top = 19
      Width = 74
      Height = 17
      Caption = #20801#35768#26356#26032
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object RzEditUpdataAddr: TRzEdit
      Left = 74
      Top = 68
      Width = 262
      Height = 20
      TabOrder = 4
    end
    object CheckBoxUseServerUpgrade: TCheckBox
      Left = 14
      Top = 94
      Width = 153
      Height = 17
      Caption = #20351#29992#39564#35777#22120#21457#36865#26356#26032#25991#20214
      TabOrder = 5
      Visible = False
      OnClick = CheckBoxUseServerUpgradeClick
    end
    object EditUpgradeFileName: TEdit
      Left = 98
      Top = 117
      Width = 237
      Height = 20
      TabOrder = 6
    end
    object ButtonRefUpgrade: TButton
      Left = 13
      Top = 143
      Width = 104
      Height = 25
      Caption = #37325#26032#21152#36733#26356#26032#25991#20214
      TabOrder = 7
    end
  end
  object RzGroupBox2: TRzGroupBox
    Left = 8
    Top = 143
    Width = 344
    Height = 138
    Caption = #24191#21578#35774#32622
    TabOrder = 8
    object RzLabel4: TRzLabel
      Left = 16
      Top = 16
      Width = 54
      Height = 12
      Caption = #20869#23884#24191#21578':'
      BlinkIntervalOff = 1
      BlinkIntervalOn = 1
    end
    object RzEditHomePage: TRzEdit
      Left = 98
      Top = 13
      Width = 238
      Height = 20
      TabOrder = 0
    end
    object RzCheckBoxOpenPage1: TRzCheckBox
      Left = 15
      Top = 39
      Width = 82
      Height = 17
      Caption = #21551#21160#24377#20986'1:'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object RzEditOpenPage1: TRzEdit
      Left = 98
      Top = 36
      Width = 238
      Height = 20
      TabOrder = 2
    end
    object RzCheckBoxOpenPage2: TRzCheckBox
      Left = 15
      Top = 62
      Width = 82
      Height = 17
      Caption = #21551#21160#24377#20986'2:'
      State = cbUnchecked
      TabOrder = 3
    end
    object RzEditOpenPage2: TRzEdit
      Left = 98
      Top = 59
      Width = 238
      Height = 20
      TabOrder = 4
    end
    object RzEditClosePage1: TRzEdit
      Left = 98
      Top = 82
      Width = 238
      Height = 20
      TabOrder = 5
    end
    object RzEditClosePage2: TRzEdit
      Left = 98
      Top = 105
      Width = 238
      Height = 20
      TabOrder = 6
    end
    object RzCheckBoxClosePage1: TRzCheckBox
      Left = 15
      Top = 85
      Width = 82
      Height = 17
      Caption = #20851#38381#24377#20986'1:'
      Checked = True
      State = cbChecked
      TabOrder = 7
    end
    object RzCheckBoxClosePage2: TRzCheckBox
      Left = 15
      Top = 108
      Width = 82
      Height = 17
      Caption = #20851#38381#24377#20986'2:'
      State = cbUnchecked
      TabOrder = 8
    end
  end
  object RzGroupBox3: TRzGroupBox
    Left = 8
    Top = 287
    Width = 344
    Height = 98
    Caption = #21898#35805#35774#32622
    TabOrder = 9
    object RzLabel5: TRzLabel
      Left = 16
      Top = 48
      Width = 60
      Height = 12
      Caption = #21898#35805#20869#23481'1:'
      BlinkIntervalOff = 1
      BlinkIntervalOn = 1
    end
    object RzLabel6: TRzLabel
      Left = 16
      Top = 71
      Width = 60
      Height = 12
      Caption = #21898#35805#20869#23481'2:'
      BlinkIntervalOff = 1
      BlinkIntervalOn = 1
    end
    object RzLabel7: TRzLabel
      Left = 16
      Top = 24
      Width = 54
      Height = 12
      Caption = #21898#35805#38388#38548':'
      BlinkIntervalOff = 1
      BlinkIntervalOn = 1
    end
    object RzEditSayMessage1: TRzEdit
      Left = 98
      Top = 45
      Width = 238
      Height = 20
      TabOrder = 0
    end
    object RzEditSayMessage2: TRzEdit
      Left = 98
      Top = 68
      Width = 238
      Height = 20
      TabOrder = 1
    end
    object RzSpinEditSayMessageTime: TRzSpinEdit
      Left = 98
      Top = 19
      Width = 111
      Height = 20
      AllowKeyEdit = True
      Increment = 100.000000000000000000
      TabOrder = 2
    end
  end
  object CheckBoxCheckOpenPage: TCheckBox
    Left = 8
    Top = 460
    Width = 89
    Height = 17
    Hint = #26816#27979#24377#20986#30340#22320#22336#26159#21542#22312#24191#21578#35774#32622#37324#30340#22320#22336','#22914#26524#19981#22312#21017#19981#24377#20986
    Caption = #26816#27979#24377#20986#22320#22336
    Checked = True
    ParentShowHint = False
    ShowHint = True
    State = cbChecked
    TabOrder = 10
  end
  object CheckBoxCheckConnectPage: TCheckBox
    Left = 8
    Top = 483
    Width = 89
    Height = 17
    Hint = #26816#27979#36830#25509#30340#22320#22336#26159#21542#22312#40657#21517#21333#20013','#22914#26524#22312#21017#19981#36830#25509
    Caption = #26816#27979#36830#25509#22320#22336
    Checked = True
    ParentShowHint = False
    ShowHint = True
    State = cbChecked
    TabOrder = 11
  end
  object CheckBoxCheckParent: TCheckBox
    Left = 8
    Top = 506
    Width = 89
    Height = 17
    Caption = #26816#27979'Parent'
    Checked = True
    ParentShowHint = False
    ShowHint = True
    State = cbChecked
    TabOrder = 12
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 529
    Width = 54
    Height = 17
    Caption = #26816#27979'1'
    Checked = True
    ParentShowHint = False
    ShowHint = True
    State = cbChecked
    TabOrder = 13
  end
  object CheckBox2: TCheckBox
    Left = 68
    Top = 529
    Width = 54
    Height = 17
    Hint = #26816#27979#36830#25509#30340#22320#22336#26159#21542#22312#40657#21517#21333#20013','#22914#26524#22312#21017#19981#36830#25509
    Caption = #26816#27979'2'
    Checked = True
    ParentShowHint = False
    ShowHint = True
    State = cbChecked
    TabOrder = 14
  end
  object CheckBox3: TCheckBox
    Left = 128
    Top = 529
    Width = 54
    Height = 17
    Hint = #26816#27979#36830#25509#30340#22320#22336#26159#21542#22312#40657#21517#21333#20013','#22914#26524#22312#21017#19981#36830#25509
    Caption = #26816#27979'3'
    Checked = True
    ParentShowHint = False
    ShowHint = True
    State = cbChecked
    TabOrder = 15
  end
  object CheckBox9: TCheckBox
    Left = 128
    Top = 575
    Width = 54
    Height = 17
    Hint = #26816#27979#36830#25509#30340#22320#22336#26159#21542#22312#40657#21517#21333#20013','#22914#26524#22312#21017#19981#36830#25509
    Caption = #26816#27979'9'
    Checked = True
    ParentShowHint = False
    ShowHint = True
    State = cbChecked
    TabOrder = 16
  end
  object CheckBox4: TCheckBox
    Left = 8
    Top = 552
    Width = 54
    Height = 17
    Hint = #26816#27979#36830#25509#30340#22320#22336#26159#21542#22312#40657#21517#21333#20013','#22914#26524#22312#21017#19981#36830#25509
    Caption = #26816#27979'4'
    Checked = True
    ParentShowHint = False
    ShowHint = True
    State = cbChecked
    TabOrder = 17
  end
  object CheckBox5: TCheckBox
    Left = 68
    Top = 552
    Width = 54
    Height = 17
    Hint = #26816#27979#36830#25509#30340#22320#22336#26159#21542#22312#40657#21517#21333#20013','#22914#26524#22312#21017#19981#36830#25509
    Caption = #26816#27979'5'
    Checked = True
    ParentShowHint = False
    ShowHint = True
    State = cbChecked
    TabOrder = 18
  end
  object CheckBox6: TCheckBox
    Left = 128
    Top = 552
    Width = 54
    Height = 17
    Hint = #26816#27979#36830#25509#30340#22320#22336#26159#21542#22312#40657#21517#21333#20013','#22914#26524#22312#21017#19981#36830#25509
    Caption = #26816#27979'6'
    Checked = True
    ParentShowHint = False
    ShowHint = True
    State = cbChecked
    TabOrder = 19
  end
  object CheckBox7: TCheckBox
    Left = 8
    Top = 575
    Width = 54
    Height = 17
    Hint = #26816#27979#36830#25509#30340#22320#22336#26159#21542#22312#40657#21517#21333#20013','#22914#26524#22312#21017#19981#36830#25509
    Caption = #26816#27979'7'
    Checked = True
    ParentShowHint = False
    ShowHint = True
    State = cbChecked
    TabOrder = 20
  end
  object CheckBox8: TCheckBox
    Left = 68
    Top = 575
    Width = 54
    Height = 17
    Hint = #26816#27979#36830#25509#30340#22320#22336#26159#21542#22312#40657#21517#21333#20013','#22914#26524#22312#21017#19981#36830#25509
    Caption = #26816#27979'8'
    Checked = True
    ParentShowHint = False
    ShowHint = True
    State = cbChecked
    TabOrder = 21
  end
  object CheckBox10: TCheckBox
    Left = 8
    Top = 598
    Width = 54
    Height = 17
    Hint = #26816#27979#36830#25509#30340#22320#22336#26159#21542#22312#40657#21517#21333#20013','#22914#26524#22312#21017#19981#36830#25509
    Caption = #26816#27979'10'
    Checked = True
    ParentShowHint = False
    ShowHint = True
    State = cbChecked
    TabOrder = 22
  end
end
