object FrmMain: TFrmMain
  Left = 360
  Top = 126
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'FrmMain'
  ClientHeight = 663
  ClientWidth = 1060
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
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 1049
    Height = 20
    TabOrder = 0
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 8
    Top = 32
    Width = 1049
    Height = 20
    TabOrder = 1
    Text = 'Edit2'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 56
    Width = 145
    Height = 241
    Caption = 'TDefaultMessage'
    TabOrder = 2
    OnDblClick = GroupBox1DblClick
    object Label3: TLabel
      Left = 8
      Top = 24
      Width = 30
      Height = 12
      Caption = 'Ident'
    end
    object Label4: TLabel
      Left = 8
      Top = 48
      Width = 30
      Height = 12
      Caption = 'Recog'
    end
    object Label5: TLabel
      Left = 8
      Top = 72
      Width = 30
      Height = 12
      Caption = 'Param'
    end
    object Label6: TLabel
      Left = 8
      Top = 96
      Width = 18
      Height = 12
      Caption = 'Tag'
    end
    object Label7: TLabel
      Left = 8
      Top = 120
      Width = 36
      Height = 12
      Caption = 'Series'
    end
    object Label69: TLabel
      Left = 8
      Top = 144
      Width = 36
      Height = 12
      Caption = 'Param1'
    end
    object Label80: TLabel
      Left = 8
      Top = 168
      Width = 36
      Height = 12
      Caption = 'Param2'
    end
    object Label81: TLabel
      Left = 8
      Top = 192
      Width = 36
      Height = 12
      Caption = 'Param3'
    end
    object EditIdent: TEdit
      Left = 56
      Top = 24
      Width = 73
      Height = 20
      TabOrder = 0
    end
    object EditRecog: TEdit
      Left = 56
      Top = 48
      Width = 73
      Height = 20
      TabOrder = 1
    end
    object EditParam: TEdit
      Left = 56
      Top = 72
      Width = 73
      Height = 20
      TabOrder = 2
    end
    object EditTag: TEdit
      Left = 56
      Top = 96
      Width = 73
      Height = 20
      TabOrder = 3
    end
    object EditSeries: TEdit
      Left = 56
      Top = 120
      Width = 73
      Height = 20
      TabOrder = 4
    end
    object EditDefMsg_Param1: TEdit
      Left = 56
      Top = 144
      Width = 73
      Height = 20
      TabOrder = 5
    end
    object EditDefMsg_Param2: TEdit
      Left = 56
      Top = 168
      Width = 73
      Height = 20
      TabOrder = 6
    end
    object EditDefMsg_Param3: TEdit
      Left = 56
      Top = 192
      Width = 73
      Height = 20
      TabOrder = 7
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 304
    Width = 145
    Height = 129
    Caption = 'TMessageBodyW'
    TabOrder = 3
    OnDblClick = GroupBox2DblClick
    object Label8: TLabel
      Left = 8
      Top = 24
      Width = 36
      Height = 12
      Caption = 'Param1'
    end
    object Label9: TLabel
      Left = 8
      Top = 48
      Width = 36
      Height = 12
      Caption = 'Param2'
    end
    object Label10: TLabel
      Left = 8
      Top = 72
      Width = 24
      Height = 12
      Caption = 'Tag1'
    end
    object Label11: TLabel
      Left = 8
      Top = 96
      Width = 24
      Height = 12
      Caption = 'Tag2'
    end
    object EditParam1: TEdit
      Left = 56
      Top = 24
      Width = 73
      Height = 20
      TabOrder = 0
    end
    object EditParam2: TEdit
      Left = 56
      Top = 48
      Width = 73
      Height = 20
      TabOrder = 1
    end
    object EditTag2: TEdit
      Left = 56
      Top = 96
      Width = 73
      Height = 20
      TabOrder = 2
    end
    object EditTag1: TEdit
      Left = 56
      Top = 72
      Width = 73
      Height = 20
      TabOrder = 3
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 440
    Width = 145
    Height = 129
    Caption = 'TMessageBodyWL'
    TabOrder = 4
    OnDblClick = GroupBox3DblClick
    object Label12: TLabel
      Left = 8
      Top = 24
      Width = 42
      Height = 12
      Caption = 'lParam1'
    end
    object Label13: TLabel
      Left = 8
      Top = 48
      Width = 42
      Height = 12
      Caption = 'lParam2'
    end
    object Label14: TLabel
      Left = 8
      Top = 72
      Width = 30
      Height = 12
      Caption = 'lTag1'
    end
    object Label15: TLabel
      Left = 8
      Top = 96
      Width = 30
      Height = 12
      Caption = 'lTag2'
    end
    object EditlParam1: TEdit
      Left = 56
      Top = 24
      Width = 73
      Height = 20
      TabOrder = 0
    end
    object EditlParam2: TEdit
      Left = 56
      Top = 48
      Width = 73
      Height = 20
      TabOrder = 1
    end
    object EditlTag2: TEdit
      Left = 56
      Top = 96
      Width = 73
      Height = 20
      TabOrder = 2
    end
    object EditlTag1: TEdit
      Left = 56
      Top = 72
      Width = 73
      Height = 20
      TabOrder = 3
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 576
    Width = 145
    Height = 81
    Caption = 'TCharDesc'
    TabOrder = 5
    OnDblClick = GroupBox4DblClick
    object Label16: TLabel
      Left = 8
      Top = 24
      Width = 42
      Height = 12
      Caption = 'feature'
    end
    object Label17: TLabel
      Left = 8
      Top = 48
      Width = 36
      Height = 12
      Caption = 'Status'
    end
    object Editfeature: TEdit
      Left = 56
      Top = 24
      Width = 73
      Height = 20
      TabOrder = 0
    end
    object EditStatus: TEdit
      Left = 56
      Top = 48
      Width = 73
      Height = 20
      TabOrder = 1
    end
  end
  object GroupBox5: TGroupBox
    Left = 160
    Top = 88
    Width = 201
    Height = 177
    Caption = 'TClientItem'
    TabOrder = 6
    OnClick = GroupBox5Click
    object Label18: TLabel
      Left = 8
      Top = 24
      Width = 54
      Height = 12
      Caption = 'MakeIndex'
    end
    object Label19: TLabel
      Left = 8
      Top = 48
      Width = 24
      Height = 12
      Caption = 'Dura'
    end
    object Label20: TLabel
      Left = 8
      Top = 72
      Width = 42
      Height = 12
      Caption = 'DuraMax'
    end
    object Label21: TLabel
      Left = 8
      Top = 96
      Width = 24
      Height = 12
      Caption = 'Name'
    end
    object Label22: TLabel
      Left = 8
      Top = 120
      Width = 42
      Height = 12
      Caption = 'StdMode'
    end
    object Label23: TLabel
      Left = 8
      Top = 144
      Width = 30
      Height = 12
      Caption = 'Shape'
    end
    object EditMakeIndex: TEdit
      Left = 88
      Top = 24
      Width = 105
      Height = 20
      TabOrder = 0
    end
    object EditDura: TEdit
      Left = 88
      Top = 48
      Width = 105
      Height = 20
      TabOrder = 1
    end
    object EditDuraMax: TEdit
      Left = 88
      Top = 72
      Width = 105
      Height = 20
      TabOrder = 2
    end
    object EditName: TEdit
      Left = 88
      Top = 96
      Width = 105
      Height = 20
      TabOrder = 3
    end
    object EditStdMode: TEdit
      Left = 88
      Top = 120
      Width = 105
      Height = 20
      TabOrder = 4
    end
    object EditShape: TEdit
      Left = 88
      Top = 144
      Width = 105
      Height = 20
      TabOrder = 5
    end
  end
  object GroupBox6: TGroupBox
    Left = 160
    Top = 272
    Width = 201
    Height = 177
    Caption = 'TOClientItem'
    TabOrder = 7
    OnClick = GroupBox6Click
    object Label24: TLabel
      Left = 8
      Top = 24
      Width = 54
      Height = 12
      Caption = 'MakeIndex'
    end
    object Label25: TLabel
      Left = 8
      Top = 48
      Width = 24
      Height = 12
      Caption = 'Dura'
    end
    object Label26: TLabel
      Left = 8
      Top = 72
      Width = 42
      Height = 12
      Caption = 'DuraMax'
    end
    object Label27: TLabel
      Left = 8
      Top = 96
      Width = 24
      Height = 12
      Caption = 'Name'
    end
    object Label28: TLabel
      Left = 8
      Top = 120
      Width = 42
      Height = 12
      Caption = 'StdMode'
    end
    object Label29: TLabel
      Left = 8
      Top = 144
      Width = 30
      Height = 12
      Caption = 'Shape'
    end
    object EditOMakeIndex: TEdit
      Left = 88
      Top = 24
      Width = 105
      Height = 20
      TabOrder = 0
    end
    object EditODura: TEdit
      Left = 88
      Top = 48
      Width = 105
      Height = 20
      TabOrder = 1
    end
    object EditODuraMax: TEdit
      Left = 88
      Top = 72
      Width = 105
      Height = 20
      TabOrder = 2
    end
    object EditOName: TEdit
      Left = 88
      Top = 96
      Width = 105
      Height = 20
      TabOrder = 3
    end
    object EditOStdMode: TEdit
      Left = 88
      Top = 120
      Width = 105
      Height = 20
      TabOrder = 4
    end
    object EditOShape: TEdit
      Left = 88
      Top = 144
      Width = 105
      Height = 20
      TabOrder = 5
    end
  end
  object GroupBox7: TGroupBox
    Left = 160
    Top = 456
    Width = 201
    Height = 153
    Caption = 'TClientMagic'
    TabOrder = 8
    OnClick = GroupBox7Click
    object Label30: TLabel
      Left = 8
      Top = 24
      Width = 18
      Height = 12
      Caption = 'Key'
    end
    object Label31: TLabel
      Left = 8
      Top = 48
      Width = 30
      Height = 12
      Caption = 'Level'
    end
    object Label32: TLabel
      Left = 8
      Top = 72
      Width = 48
      Height = 12
      Caption = 'CurTrain'
    end
    object Label33: TLabel
      Left = 8
      Top = 96
      Width = 48
      Height = 12
      Caption = 'wMagicId'
    end
    object Label34: TLabel
      Left = 8
      Top = 120
      Width = 60
      Height = 12
      Caption = 'sMagicName'
    end
    object EditKey: TEdit
      Left = 88
      Top = 24
      Width = 105
      Height = 20
      TabOrder = 0
    end
    object EditLevel: TEdit
      Left = 88
      Top = 48
      Width = 105
      Height = 20
      TabOrder = 1
    end
    object EditCurTrain: TEdit
      Left = 88
      Top = 72
      Width = 105
      Height = 20
      TabOrder = 2
    end
    object EditwMagicId: TEdit
      Left = 88
      Top = 96
      Width = 105
      Height = 20
      TabOrder = 3
    end
    object EditsMagicName: TEdit
      Left = 88
      Top = 120
      Width = 105
      Height = 20
      TabOrder = 4
    end
  end
  object GroupBox8: TGroupBox
    Left = 368
    Top = 88
    Width = 177
    Height = 465
    Caption = 'TAbility'
    TabOrder = 9
    OnClick = GroupBox8Click
    object Label35: TLabel
      Left = 8
      Top = 24
      Width = 30
      Height = 12
      Caption = 'Level'
    end
    object Label36: TLabel
      Left = 8
      Top = 48
      Width = 12
      Height = 12
      Caption = 'AC'
    end
    object Label37: TLabel
      Left = 8
      Top = 72
      Width = 18
      Height = 12
      Caption = 'MAC'
    end
    object Label38: TLabel
      Left = 8
      Top = 96
      Width = 12
      Height = 12
      Caption = 'DC'
    end
    object Label39: TLabel
      Left = 8
      Top = 120
      Width = 12
      Height = 12
      Caption = 'MC'
    end
    object Label40: TLabel
      Left = 8
      Top = 144
      Width = 12
      Height = 12
      Caption = 'SC'
    end
    object Label41: TLabel
      Left = 8
      Top = 168
      Width = 12
      Height = 12
      Caption = 'HP'
    end
    object Label42: TLabel
      Left = 8
      Top = 192
      Width = 12
      Height = 12
      Caption = 'MP'
    end
    object Label43: TLabel
      Left = 8
      Top = 216
      Width = 30
      Height = 12
      Caption = 'MaxHP'
    end
    object Label44: TLabel
      Left = 8
      Top = 240
      Width = 30
      Height = 12
      Caption = 'MaxMP'
    end
    object Label45: TLabel
      Left = 8
      Top = 264
      Width = 18
      Height = 12
      Caption = 'Exp'
    end
    object Label46: TLabel
      Left = 8
      Top = 288
      Width = 36
      Height = 12
      Caption = 'MaxExp'
    end
    object Label47: TLabel
      Left = 8
      Top = 312
      Width = 36
      Height = 12
      Caption = 'Weight'
    end
    object Label48: TLabel
      Left = 8
      Top = 336
      Width = 54
      Height = 12
      Caption = 'MaxWeight'
    end
    object Label49: TLabel
      Left = 8
      Top = 360
      Width = 60
      Height = 12
      Caption = 'WearWeight'
    end
    object Label50: TLabel
      Left = 8
      Top = 384
      Width = 78
      Height = 12
      Caption = 'MaxWearWeight'
    end
    object Label51: TLabel
      Left = 8
      Top = 408
      Width = 60
      Height = 12
      Caption = 'HandWeight'
    end
    object Label52: TLabel
      Left = 8
      Top = 432
      Width = 78
      Height = 12
      Caption = 'MaxHandWeight'
    end
    object Edit_Abi_Level: TEdit
      Left = 96
      Top = 24
      Width = 73
      Height = 20
      TabOrder = 0
    end
    object Edit_Abi_AC: TEdit
      Left = 96
      Top = 48
      Width = 73
      Height = 20
      TabOrder = 1
    end
    object Edit_Abi_MAC: TEdit
      Left = 96
      Top = 72
      Width = 73
      Height = 20
      TabOrder = 2
    end
    object Edit_Abi_DC: TEdit
      Left = 96
      Top = 96
      Width = 73
      Height = 20
      TabOrder = 3
    end
    object Edit_Abi_MC: TEdit
      Left = 96
      Top = 120
      Width = 73
      Height = 20
      TabOrder = 4
    end
    object Edit_Abi_SC: TEdit
      Left = 96
      Top = 144
      Width = 73
      Height = 20
      TabOrder = 5
    end
    object Edit_Abi_HP: TEdit
      Left = 96
      Top = 168
      Width = 73
      Height = 20
      TabOrder = 6
    end
    object Edit_Abi_MP: TEdit
      Left = 96
      Top = 192
      Width = 73
      Height = 20
      TabOrder = 7
    end
    object Edit_Abi_MAXHP: TEdit
      Left = 96
      Top = 216
      Width = 73
      Height = 20
      TabOrder = 8
    end
    object Edit_Abi_MAXMP: TEdit
      Left = 96
      Top = 240
      Width = 73
      Height = 20
      TabOrder = 9
    end
    object Edit_Abi_Exp: TEdit
      Left = 96
      Top = 264
      Width = 73
      Height = 20
      TabOrder = 10
    end
    object Edit_Abi_MaxExp: TEdit
      Left = 96
      Top = 288
      Width = 73
      Height = 20
      TabOrder = 11
    end
    object Edit_Abi_Weight: TEdit
      Left = 96
      Top = 312
      Width = 73
      Height = 20
      TabOrder = 12
    end
    object Edit_Abi_MaxWeight: TEdit
      Left = 96
      Top = 336
      Width = 73
      Height = 20
      TabOrder = 13
    end
    object Edit_Abi_WearWeight: TEdit
      Left = 96
      Top = 360
      Width = 73
      Height = 20
      TabOrder = 14
    end
    object Edit_Abi_MaxWearWeight: TEdit
      Left = 96
      Top = 384
      Width = 73
      Height = 20
      TabOrder = 15
    end
    object Edit_Abi_HandWeight: TEdit
      Left = 96
      Top = 408
      Width = 73
      Height = 20
      TabOrder = 16
    end
    object Edit_Abi_MaxHandWeight: TEdit
      Left = 96
      Top = 432
      Width = 73
      Height = 20
      TabOrder = 17
    end
  end
  object GroupBox9: TGroupBox
    Left = 552
    Top = 88
    Width = 177
    Height = 465
    Caption = 'TOAbility'
    TabOrder = 10
    OnClick = GroupBox9Click
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 30
      Height = 12
      Caption = 'Level'
    end
    object Label2: TLabel
      Left = 8
      Top = 48
      Width = 12
      Height = 12
      Caption = 'AC'
    end
    object Label53: TLabel
      Left = 8
      Top = 72
      Width = 18
      Height = 12
      Caption = 'MAC'
    end
    object Label54: TLabel
      Left = 8
      Top = 96
      Width = 12
      Height = 12
      Caption = 'DC'
    end
    object Label55: TLabel
      Left = 8
      Top = 120
      Width = 12
      Height = 12
      Caption = 'MC'
    end
    object Label56: TLabel
      Left = 8
      Top = 144
      Width = 12
      Height = 12
      Caption = 'SC'
    end
    object Label57: TLabel
      Left = 8
      Top = 168
      Width = 12
      Height = 12
      Caption = 'HP'
    end
    object Label58: TLabel
      Left = 8
      Top = 192
      Width = 12
      Height = 12
      Caption = 'MP'
    end
    object Label59: TLabel
      Left = 8
      Top = 216
      Width = 30
      Height = 12
      Caption = 'MaxHP'
    end
    object Label60: TLabel
      Left = 8
      Top = 240
      Width = 30
      Height = 12
      Caption = 'MaxMP'
    end
    object Label61: TLabel
      Left = 8
      Top = 264
      Width = 18
      Height = 12
      Caption = 'Exp'
    end
    object Label62: TLabel
      Left = 8
      Top = 288
      Width = 36
      Height = 12
      Caption = 'MaxExp'
    end
    object Label63: TLabel
      Left = 8
      Top = 312
      Width = 36
      Height = 12
      Caption = 'Weight'
    end
    object Label64: TLabel
      Left = 8
      Top = 336
      Width = 54
      Height = 12
      Caption = 'MaxWeight'
    end
    object Label65: TLabel
      Left = 8
      Top = 360
      Width = 60
      Height = 12
      Caption = 'WearWeight'
    end
    object Label66: TLabel
      Left = 8
      Top = 384
      Width = 78
      Height = 12
      Caption = 'MaxWearWeight'
    end
    object Label67: TLabel
      Left = 8
      Top = 408
      Width = 60
      Height = 12
      Caption = 'HandWeight'
    end
    object Label68: TLabel
      Left = 8
      Top = 432
      Width = 78
      Height = 12
      Caption = 'MaxHandWeight'
    end
    object Edit_OAbi_Level: TEdit
      Left = 96
      Top = 24
      Width = 73
      Height = 20
      TabOrder = 0
    end
    object Edit_OAbi_AC: TEdit
      Left = 96
      Top = 48
      Width = 73
      Height = 20
      TabOrder = 1
    end
    object Edit_OAbi_MAC: TEdit
      Left = 96
      Top = 72
      Width = 73
      Height = 20
      TabOrder = 2
    end
    object Edit_OAbi_DC: TEdit
      Left = 96
      Top = 96
      Width = 73
      Height = 20
      TabOrder = 3
    end
    object Edit_OAbi_MC: TEdit
      Left = 96
      Top = 120
      Width = 73
      Height = 20
      TabOrder = 4
    end
    object Edit_OAbi_SC: TEdit
      Left = 96
      Top = 144
      Width = 73
      Height = 20
      TabOrder = 5
    end
    object Edit_OAbi_HP: TEdit
      Left = 96
      Top = 168
      Width = 73
      Height = 20
      TabOrder = 6
    end
    object Edit_OAbi_MP: TEdit
      Left = 96
      Top = 192
      Width = 73
      Height = 20
      TabOrder = 7
    end
    object Edit_OAbi_MAXHP: TEdit
      Left = 96
      Top = 216
      Width = 73
      Height = 20
      TabOrder = 8
    end
    object Edit_OAbi_MAXMP: TEdit
      Left = 96
      Top = 240
      Width = 73
      Height = 20
      TabOrder = 9
    end
    object Edit_OAbi_Exp: TEdit
      Left = 96
      Top = 264
      Width = 73
      Height = 20
      TabOrder = 10
    end
    object Edit_OAbi_MaxExp: TEdit
      Left = 96
      Top = 288
      Width = 73
      Height = 20
      TabOrder = 11
    end
    object Edit_OAbi_Weight: TEdit
      Left = 96
      Top = 312
      Width = 73
      Height = 20
      TabOrder = 12
    end
    object Edit_OAbi_MaxWeight: TEdit
      Left = 96
      Top = 336
      Width = 73
      Height = 20
      TabOrder = 13
    end
    object Edit_OAbi_WearWeight: TEdit
      Left = 96
      Top = 360
      Width = 73
      Height = 20
      TabOrder = 14
    end
    object Edit_OAbi_MaxWearWeight: TEdit
      Left = 96
      Top = 384
      Width = 73
      Height = 20
      TabOrder = 15
    end
    object Edit_OAbi_HandWeight: TEdit
      Left = 96
      Top = 408
      Width = 73
      Height = 20
      TabOrder = 16
    end
    object Edit_OAbi_MaxHandWeight: TEdit
      Left = 96
      Top = 432
      Width = 73
      Height = 20
      TabOrder = 17
    end
  end
  object CheckBox1: TCheckBox
    Left = 376
    Top = 576
    Width = 121
    Height = 17
    Caption = '-TDefaultMessage'
    TabOrder = 11
  end
  object Button1: TButton
    Left = 656
    Top = 568
    Width = 75
    Height = 25
    Caption = #35299#21253
    TabOrder = 12
    OnClick = Button1Click
  end
  object GroupBox10: TGroupBox
    Left = 736
    Top = 88
    Width = 177
    Height = 265
    Caption = 'TNakedAbility'
    TabOrder = 13
    OnClick = GroupBox10Click
    object Label70: TLabel
      Left = 8
      Top = 88
      Width = 12
      Height = 12
      Caption = 'AC'
    end
    object Label71: TLabel
      Left = 8
      Top = 112
      Width = 18
      Height = 12
      Caption = 'MAC'
    end
    object Label72: TLabel
      Left = 8
      Top = 16
      Width = 12
      Height = 12
      Caption = 'DC'
    end
    object Label73: TLabel
      Left = 8
      Top = 40
      Width = 12
      Height = 12
      Caption = 'MC'
    end
    object Label74: TLabel
      Left = 8
      Top = 64
      Width = 12
      Height = 12
      Caption = 'SC'
    end
    object Label75: TLabel
      Left = 8
      Top = 136
      Width = 12
      Height = 12
      Caption = 'HP'
    end
    object Label76: TLabel
      Left = 8
      Top = 160
      Width = 12
      Height = 12
      Caption = 'MP'
    end
    object Label77: TLabel
      Left = 8
      Top = 184
      Width = 18
      Height = 12
      Caption = 'Hit'
    end
    object Label78: TLabel
      Left = 8
      Top = 208
      Width = 30
      Height = 12
      Caption = 'Speed'
    end
    object Label79: TLabel
      Left = 8
      Top = 232
      Width = 12
      Height = 12
      Caption = 'X2'
    end
    object Edit4: TEdit
      Left = 96
      Top = 88
      Width = 73
      Height = 20
      TabOrder = 0
    end
    object Edit5: TEdit
      Left = 96
      Top = 112
      Width = 73
      Height = 20
      TabOrder = 1
    end
    object Edit6: TEdit
      Left = 96
      Top = 16
      Width = 73
      Height = 20
      TabOrder = 2
    end
    object Edit7: TEdit
      Left = 96
      Top = 40
      Width = 73
      Height = 20
      TabOrder = 3
    end
    object Edit8: TEdit
      Left = 96
      Top = 64
      Width = 73
      Height = 20
      TabOrder = 4
    end
    object Edit9: TEdit
      Left = 96
      Top = 136
      Width = 73
      Height = 20
      TabOrder = 5
    end
    object Edit10: TEdit
      Left = 96
      Top = 160
      Width = 73
      Height = 20
      TabOrder = 6
    end
    object Edit11: TEdit
      Left = 96
      Top = 184
      Width = 73
      Height = 20
      TabOrder = 7
    end
    object Edit12: TEdit
      Left = 96
      Top = 208
      Width = 73
      Height = 20
      TabOrder = 8
    end
    object Edit13: TEdit
      Left = 96
      Top = 232
      Width = 73
      Height = 20
      TabOrder = 9
    end
  end
  object Button2: TButton
    Left = 752
    Top = 568
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 14
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 840
    Top = 568
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 15
    OnClick = Button3Click
  end
  object SpinEdit1: TSpinEdit
    Left = 736
    Top = 376
    Width = 121
    Height = 21
    MaxValue = 0
    MinValue = 0
    TabOrder = 16
    Value = 0
  end
  object SpinEdit2: TSpinEdit
    Left = 736
    Top = 400
    Width = 121
    Height = 21
    MaxValue = 0
    MinValue = 0
    TabOrder = 17
    Value = 0
  end
  object SpinEdit3: TSpinEdit
    Left = 736
    Top = 424
    Width = 121
    Height = 21
    MaxValue = 0
    MinValue = 0
    TabOrder = 18
    Value = 0
  end
  object Button4: TButton
    Left = 736
    Top = 456
    Width = 75
    Height = 25
    Caption = 'MakeLong'
    TabOrder = 19
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 824
    Top = 456
    Width = 75
    Height = 25
    Caption = 'LoWord'
    TabOrder = 20
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 736
    Top = 488
    Width = 75
    Height = 25
    Caption = 'MakeWord'
    TabOrder = 21
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 824
    Top = 488
    Width = 75
    Height = 25
    Caption = 'LoByte'
    TabOrder = 22
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 656
    Top = 600
    Width = 75
    Height = 25
    Caption = #21152#23494
    TabOrder = 23
    OnClick = Button8Click
  end
end
