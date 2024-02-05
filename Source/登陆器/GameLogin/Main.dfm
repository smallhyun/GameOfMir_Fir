object frmMain: TfrmMain
  Left = 332
  Top = 136
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'frmMain'
  ClientHeight = 570
  ClientWidth = 830
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
  object Image: TRzFormShape
    Left = 0
    Top = 0
    Width = 830
    Height = 570
  end
  object LabelStatus: TLabel
    Left = 76
    Top = 480
    Width = 126
    Height = 12
    Caption = #27491#22312#27979#35797#26381#21153#22120#29366#24577'...'
    Font.Charset = GB2312_CHARSET
    Font.Color = clFuchsia
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    Transparent = True
    OnMouseDown = ImageMouseDown
  end
  object RzBmpButtonHomePage: TRzBmpButton
    Left = 511
    Top = 455
    Width = 86
    Height = 29
    Bitmaps.TransparentColor = clOlive
    Color = clBtnFace
    TabOrder = 0
    OnClick = RzBmpButtonHomePageClick
  end
  object RzBmpButtonEditGameList: TRzBmpButton
    Left = 419
    Top = 455
    Width = 86
    Height = 29
    Bitmaps.TransparentColor = clOlive
    Color = clBtnFace
    TabOrder = 1
    OnClick = RzBmpButtonEditGameListClick
  end
  object RzBmpButtonNewAccount: TRzBmpButton
    Left = 419
    Top = 490
    Width = 86
    Height = 29
    Bitmaps.TransparentColor = clOlive
    Color = clBtnFace
    TabOrder = 2
    OnClick = RzBmpButtonNewAccountClick
  end
  object RzBmpButtonGetBakPassWord: TRzBmpButton
    Left = 511
    Top = 490
    Width = 86
    Height = 29
    Bitmaps.TransparentColor = clOlive
    Color = clBtnFace
    TabOrder = 3
    OnClick = RzBmpButtonGetBakPassWordClick
  end
  object RzBmpButtonChgPassWord: TRzBmpButton
    Left = 603
    Top = 490
    Width = 86
    Height = 29
    Bitmaps.TransparentColor = clOlive
    Color = clBtnFace
    TabOrder = 4
    OnClick = RzBmpButtonChgPassWordClick
  end
  object RzBmpButtonAutoLogin: TRzBmpButton
    Left = 603
    Top = 455
    Width = 86
    Height = 29
    Bitmaps.TransparentColor = clOlive
    Color = clBtnFace
    TabOrder = 5
    OnClick = RzBmpButtonAutoLoginClick
  end
  object RzBmpButtonFullScreenStart: TRzBmpButton
    Left = 327
    Top = 455
    Width = 86
    Height = 29
    Bitmaps.TransparentColor = clOlive
    Color = clBtnFace
    TabOrder = 6
    OnClick = RzBmpButtonFullScreenStartClick
  end
  object RzBmpButtonClose: TRzBmpButton
    Left = 786
    Top = 24
    Width = 17
    Height = 17
    Bitmaps.TransparentColor = clOlive
    Color = clBtnFace
    TabOrder = 7
    OnClick = RzBmpButtonCloseClick
  end
  object RzBmpButtonMin: TRzBmpButton
    Left = 763
    Top = 24
    Width = 17
    Height = 17
    Bitmaps.TransparentColor = clOlive
    Color = clBtnFace
    TabOrder = 8
    OnClick = RzBmpButtonMinClick
  end
  object TreeView: TTreeView
    Left = 97
    Top = 82
    Width = 192
    Height = 319
    Color = clBlack
    Ctl3D = False
    Font.Charset = GB2312_CHARSET
    Font.Color = 4227327
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    Indent = 19
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 9
    OnClick = TreeViewClick
  end
  object RzBmpButtonStart: TRzBmpButton
    Left = 327
    Top = 490
    Width = 86
    Height = 29
    Bitmaps.TransparentColor = clOlive
    Color = clBtnFace
    TabOrder = 10
    OnClick = RzBmpButtonFullScreenStartClick
  end
  object RzBmpButtonExitGame: TRzBmpButton
    Left = 695
    Top = 490
    Width = 86
    Height = 29
    Bitmaps.TransparentColor = clOlive
    Color = clBtnFace
    TabOrder = 11
    OnClick = RzBmpButtonCloseClick
  end
  object RzBmpButtonUpgrade: TRzBmpButton
    Left = 695
    Top = 455
    Width = 86
    Height = 29
    Bitmaps.TransparentColor = clOlive
    Color = clBtnFace
    TabOrder = 12
  end
  object ComboBox: TComboBox
    Left = 80
    Top = 448
    Width = 105
    Height = 20
    Style = csDropDownList
    ItemHeight = 12
    ItemIndex = 0
    TabOrder = 13
    Text = '800*600'
    Items.Strings = (
      '800*600'
      '1024*768')
  end
  object Timer: TTimer
    Enabled = False
    Interval = 10
    OnTimer = TimerTimer
    Left = 296
    Top = 216
  end
  object ClientSocket: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnecting = ClientSocketConnecting
    OnConnect = ClientSocketConnect
    OnDisconnect = ClientSocketDisconnect
    OnRead = ClientSocketRead
    OnError = ClientSocketError
    Left = 328
    Top = 216
  end
  object TimerStart: TTimer
    Enabled = False
    OnTimer = TimerStartTimer
    Left = 232
    Top = 216
  end
  object CloseTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = CloseTimerTimer
    Left = 264
    Top = 216
  end
  object TimerReakSkin: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerReakSkinTimer
    Left = 360
    Top = 216
  end
  object SpeedHackTimer: TTimer
    Interval = 200
    OnTimer = SpeedHackTimerTimer
    Left = 400
    Top = 224
  end
end
