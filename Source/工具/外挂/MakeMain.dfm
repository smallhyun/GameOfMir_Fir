object FrmMain: TFrmMain
  Left = 917
  Top = 236
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #39134#23572#19990#30028#22806#25346#37197#32622#22120
  ClientHeight = 488
  ClientWidth = 458
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
    Width = 442
    Height = 161
    Caption = #37197#21046#25991#20214
    TabOrder = 0
    object Label4: TLabel
      Left = 8
      Top = 16
      Width = 60
      Height = 12
      Caption = 'Cqfir.dll:'
    end
    object Label5: TLabel
      Left = 8
      Top = 40
      Width = 54
      Height = 12
      Caption = 'Hook.dll:'
    end
    object Label1: TLabel
      Left = 8
      Top = 64
      Width = 54
      Height = 12
      Caption = #22806#25346#25991#20214':'
    end
    object Label2: TLabel
      Left = 8
      Top = 88
      Width = 54
      Height = 12
      Caption = #23448#26041#32593#31449':'
    end
    object Label3: TLabel
      Left = 8
      Top = 112
      Width = 54
      Height = 12
      Caption = #22806#25346#26631#39064':'
    end
    object Label6: TLabel
      Left = 8
      Top = 136
      Width = 54
      Height = 12
      Caption = #24555#25463#26041#24335':'
    end
    object EditLinkName: TEdit
      Left = 72
      Top = 134
      Width = 359
      Height = 20
      TabOrder = 0
      Text = #39134#23572#19990#30028#33521#38596#22806#25346
    end
    object EditCaption: TEdit
      Left = 72
      Top = 108
      Width = 359
      Height = 20
      TabOrder = 1
      Text = #39134#23572#19990#30028#33521#38596#22806#25346
    end
    object EditHomePage: TEdit
      Left = 72
      Top = 84
      Width = 359
      Height = 20
      TabOrder = 2
      Text = 'http://www.941sf.com'
    end
    object EditCqfirDllFile: TRzButtonEdit
      Left = 72
      Top = 12
      Width = 359
      Height = 20
      TabOrder = 3
      AltBtnWidth = 15
      ButtonWidth = 15
      OnButtonClick = ButtonOpenCqfirDllFileClick
    end
    object EditHookDllFile: TRzButtonEdit
      Left = 72
      Top = 36
      Width = 359
      Height = 20
      TabOrder = 4
      AltBtnWidth = 15
      ButtonWidth = 15
      OnButtonClick = ButtonOpenHookDllFileClick
    end
    object EditCqfirFile: TRzButtonEdit
      Left = 72
      Top = 60
      Width = 359
      Height = 20
      TabOrder = 5
      AltBtnWidth = 15
      ButtonWidth = 15
      OnButtonClick = ButtonOpenClick
    end
  end
  object ButtonOK: TButton
    Left = 8
    Top = 457
    Width = 75
    Height = 25
    Caption = #21019#24314
    TabOrder = 1
    OnClick = ButtonOKClick
  end
  object ButtonClose: TButton
    Left = 375
    Top = 457
    Width = 75
    Height = 25
    Caption = #20851#38381
    TabOrder = 2
    OnClick = ButtonCloseClick
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 175
    Width = 442
    Height = 276
    ActivePage = TabSheet1
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = #22320#22336#36807#28388
      object EditHost: TEdit
        Left = 3
        Top = 226
        Width = 318
        Height = 20
        TabOrder = 0
        Text = 'http://www.cqfir.com'
      end
      object ListBoxHosts: TListBox
        Left = 3
        Top = 3
        Width = 428
        Height = 212
        ItemHeight = 12
        Items.Strings = (
          'http://www.cqfir.com'
          'http://www.941sf.com'
          'http://www.941yx.com'
          'http://www.xundiancq.cn')
        TabOrder = 1
        OnClick = ListBoxHostsClick
      end
      object RzButtonAddHost: TButton
        Left = 327
        Top = 221
        Width = 49
        Height = 25
        Caption = #22686#21152
        TabOrder = 2
        OnClick = RzButtonAddHostClick
      end
      object RzButtonDelHost: TButton
        Left = 382
        Top = 221
        Width = 49
        Height = 25
        Caption = #21024#38500
        TabOrder = 3
        OnClick = RzButtonDelHostClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = #32531#23384#35774#32622
      ImageIndex = 1
      object Memo: TMemo
        Left = 3
        Top = 3
        Width = 414
        Height = 243
        Lines.Strings = (
          #27492#22495#21517#24050#34987'www.941sf.com'#25910#36141#12290#12290#12290
          '<meta http-equiv="refresh" content="2;url=http://www.941sf.com">')
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
  object SaveDialog: TSaveDialog
    Filter = 'CqFirSupPort|*.exe'
    Left = 240
    Top = 72
  end
  object OpenDialog: TOpenDialog
    Filter = 'CqFirSupPort|(*.exe)'
    Left = 272
    Top = 72
  end
end
