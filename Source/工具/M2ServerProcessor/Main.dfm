object FrmMain: TFrmMain
  Left = 529
  Top = 116
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'M2Server'#37197#32622#22120
  ClientHeight = 364
  ClientWidth = 776
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
  object ButtonClose: TButton
    Left = 290
    Top = 333
    Width = 89
    Height = 25
    Caption = #36864#20986
    TabOrder = 0
    OnClick = ButtonCloseClick
  end
  object ButtonM2Server: TButton
    Left = 5
    Top = 333
    Width = 89
    Height = 25
    Caption = #37197#21046'M2Server'
    TabOrder = 1
    OnClick = ButtonM2ServerClick
  end
  object ButtonSave: TButton
    Left = 100
    Top = 333
    Width = 89
    Height = 25
    Caption = #20445#23384#29992#25143#20449#24687
    TabOrder = 2
    OnClick = ButtonSaveClick
  end
  object GroupBox1: TGroupBox
    Left = 391
    Top = 8
    Width = 377
    Height = 76
    Caption = #29992#25143#20449#24687
    TabOrder = 3
    object Label2: TLabel
      Left = 8
      Top = 16
      Width = 42
      Height = 12
      Caption = #29992#25143'QQ:'
    end
    object Label9: TLabel
      Left = 8
      Top = 40
      Width = 42
      Height = 12
      Caption = #26426#22120#30721':'
    end
    object ComboBoxQQ: TComboBox
      Left = 64
      Top = 16
      Width = 305
      Height = 20
      ItemHeight = 12
      TabOrder = 0
      Text = '1037527564'
      OnChange = ComboBoxQQChange
    end
    object EditSerialNumber: TEdit
      Left = 64
      Top = 42
      Width = 305
      Height = 20
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 90
    Width = 377
    Height = 235
    Caption = #29256#26412#20449#24687
    TabOrder = 4
    object Label3: TLabel
      Left = 8
      Top = 22
      Width = 54
      Height = 12
      Caption = #36719#20214#21517#31216':'
    end
    object Label4: TLabel
      Left = 8
      Top = 46
      Width = 54
      Height = 12
      Caption = #36719#20214#29256#26412':'
    end
    object Label5: TLabel
      Left = 8
      Top = 72
      Width = 54
      Height = 12
      Caption = #26356#26032#26085#26399':'
    end
    object Label6: TLabel
      Left = 8
      Top = 98
      Width = 54
      Height = 12
      Caption = #31243#24207#21046#20316':'
    end
    object Label7: TLabel
      Left = 8
      Top = 124
      Width = 54
      Height = 12
      Caption = #31243#24207#32593#31449':'
    end
    object Label8: TLabel
      Left = 8
      Top = 150
      Width = 54
      Height = 12
      Caption = #31243#24207#35770#22363':'
    end
    object Label1: TLabel
      Left = 8
      Top = 202
      Width = 54
      Height = 12
      Caption = #38144#21806#20449#24687':'
    end
    object Label12: TLabel
      Left = 8
      Top = 176
      Width = 54
      Height = 12
      Caption = #27426#36814#20449#24687':'
    end
    object EditProductName: TEdit
      Left = 64
      Top = 18
      Width = 305
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkTile
      BorderStyle = bsNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
      Text = 'MakeGM'#21453#22806#25346#38450#25915#20987#25968#25454#24341#25806'('#21830#19994#29256') '
    end
    object EditVersion: TEdit
      Left = 64
      Top = 44
      Width = 305
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 1
      Text = #24341#25806#29256#26412': 2.00 Build 201009010%d'
    end
    object EditUpDateTime: TEdit
      Left = 64
      Top = 70
      Width = 305
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 2
      Text = #26356#26032#26085#26399': 2010/09/01'
    end
    object EditProgram: TEdit
      Left = 64
      Top = 96
      Width = 305
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 3
      Text = 'MakeGM QQ:1037527564'
    end
    object EditWebSite: TEdit
      Left = 64
      Top = 122
      Width = 305
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 4
      Text = 'http://www.MakeGM.com'
    end
    object EditBbsSite: TEdit
      Left = 64
      Top = 148
      Width = 305
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 5
      Text = 'http://bbs.MakeGM.com'
    end
    object EditSellInfo: TEdit
      Left = 64
      Top = 200
      Width = 305
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 6
      Text = #38144#21806'QQ:1037527564'
    end
    object EditProductInfo: TEdit
      Left = 64
      Top = 174
      Width = 305
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 7
      Text = #27426#36814#20351#29992'MakeGM'#31995#21015#36719#20214':'
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 8
    Width = 377
    Height = 76
    Caption = #37197#21046#25991#20214
    TabOrder = 5
    object Label10: TLabel
      Left = 8
      Top = 16
      Width = 78
      Height = 12
      Caption = 'M2Server.exe:'
    end
    object Label11: TLabel
      Left = 8
      Top = 42
      Width = 78
      Height = 12
      Caption = 'M2Server.Dll:'
    end
    object EditM2ServerExe: TRzButtonEdit
      Left = 88
      Top = 16
      Width = 281
      Height = 20
      TabOrder = 0
      AltBtnWidth = 15
      ButtonWidth = 15
      OnButtonClick = EditM2ServerExeButtonClick
    end
    object EditM2ServerDll: TRzButtonEdit
      Left = 88
      Top = 42
      Width = 281
      Height = 20
      TabOrder = 1
      AltBtnWidth = 15
      ButtonWidth = 15
    end
  end
  object RadioGroup: TRadioGroup
    Left = 391
    Top = 277
    Width = 378
    Height = 48
    Caption = #36873#25321#29256#26412
    Color = clBtnFace
    Columns = 2
    Enabled = False
    ItemIndex = 1
    Items.Strings = (
      #20998#36523#29256
      #33521#38596#29256)
    ParentColor = False
    TabOrder = 6
  end
  object ButtonDel: TButton
    Left = 195
    Top = 333
    Width = 89
    Height = 25
    Caption = #21024#38500#29992#25143#20449#24687
    TabOrder = 7
  end
  object GroupBox4: TGroupBox
    Left = 391
    Top = 90
    Width = 378
    Height = 184
    Caption = #24191#21578#20449#24687
    TabOrder = 8
    object Label13: TLabel
      Left = 8
      Top = 22
      Width = 36
      Height = 12
      Caption = #24191#21578'1:'
    end
    object Label14: TLabel
      Left = 8
      Top = 46
      Width = 36
      Height = 12
      Caption = #24191#21578'2:'
    end
    object Label15: TLabel
      Left = 8
      Top = 120
      Width = 54
      Height = 12
      Caption = #24191#21578#36895#24230':'
    end
    object Label18: TLabel
      Left = 8
      Top = 147
      Width = 54
      Height = 12
      Caption = #20844#21578#36895#24230':'
    end
    object Label20: TLabel
      Left = 8
      Top = 70
      Width = 36
      Height = 12
      Caption = #20844#21578'1:'
    end
    object Label21: TLabel
      Left = 8
      Top = 94
      Width = 36
      Height = 12
      Caption = #20844#21578'2:'
    end
    object EditNoticeInfo1: TEdit
      Left = 64
      Top = 18
      Width = 305
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkTile
      BorderStyle = bsNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
      Text = 'MakeGM'#26368#26435#23041#26368#19987#19994#30340#20256#22855#26381#21153'.'#36731#26494#20570'GM!'
    end
    object EditNoticeInfo2: TEdit
      Left = 64
      Top = 44
      Width = 305
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 1
      Text = 'Www.51pao.Com.'#23601#26159#35201#33298#26381'.'#23547#25214#26032#24320#28216#25103'.'#36824#26377'MM'#38506#20320#28216#25103'!'
    end
    object EditTime1: TSpinEdit
      Left = 64
      Top = 118
      Width = 121
      Height = 21
      Hint = #21333#20301#20998
      MaxValue = 255
      MinValue = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Value = 60
    end
    object EditTime2: TSpinEdit
      Left = 64
      Top = 145
      Width = 121
      Height = 21
      Hint = #21333#20301#20998
      MaxValue = 255
      MinValue = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Value = 60
    end
    object EditNoticeInfo3: TEdit
      Left = 64
      Top = 66
      Width = 305
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkTile
      BorderStyle = bsNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 4
      Text = 'M(251,73)MakeGM'#26368#26435#23041#26368#19987#19994#30340#20256#22855#26381#21153'.'#36731#26494#20570'GM!'
    end
    object EditNoticeInfo4: TEdit
      Left = 64
      Top = 92
      Width = 305
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 5
      Text = 'C(254,73)Www.MakeGM.Com.'#23601#26159#35201#33298#26381'.'#23547#25214#26032#24320#28216#25103'.'#36824#26377'MM'#38506#20320#28216#25103'!'
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 'M2Server|(*.exe)'
    Left = 272
    Top = 72
  end
  object SaveDialog: TSaveDialog
    Filter = 'M2Server|*.exe'
    Left = 240
    Top = 72
  end
  object TimerStart: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerStartTimer
    Left = 272
    Top = 152
  end
end
