object FrmMain: TFrmMain
  Left = 789
  Top = 282
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MirClient'#37197#21046#24037#20855
  ClientHeight = 191
  ClientWidth = 482
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
  object GroupBox3: TGroupBox
    Left = 8
    Top = 8
    Width = 465
    Height = 57
    Caption = #37197#21046#25991#20214
    TabOrder = 0
    object Label11: TLabel
      Left = 8
      Top = 22
      Width = 84
      Height = 12
      Caption = 'MirClient.exe:'
    end
    object EditMirClient: TRzButtonEdit
      Left = 98
      Top = 19
      Width = 359
      Height = 20
      TabOrder = 0
      AltBtnWidth = 15
      ButtonWidth = 15
      OnButtonClick = EditMirClientButtonClick
    end
  end
  object GroupBox: TGroupBox
    Left = 8
    Top = 71
    Width = 466
    Height = 82
    Caption = #20851#38381#24377#20986#24191#21578
    TabOrder = 1
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
    object EditNoticeInfo1: TEdit
      Left = 64
      Top = 18
      Width = 393
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkTile
      BorderStyle = bsNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
      Text = 'http://www.MakeGM.com'
    end
    object EditNoticeInfo2: TEdit
      Left = 64
      Top = 44
      Width = 393
      Height = 20
      BevelInner = bvLowered
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 1
      Text = 'http://www.51pao.com'
    end
  end
  object ButtonOK: TButton
    Left = 8
    Top = 159
    Width = 89
    Height = 25
    Caption = #37197#21046'MirClient'
    TabOrder = 2
    OnClick = ButtonOKClick
  end
  object ButtonClose: TButton
    Left = 385
    Top = 159
    Width = 89
    Height = 25
    Caption = #36864#20986
    TabOrder = 3
    OnClick = ButtonCloseClick
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
end
