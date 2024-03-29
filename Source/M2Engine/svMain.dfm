object FrmMain: TFrmMain
  Left = 469
  Top = 164
  ClientHeight = 331
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object RzSplitter: TRzSplitter
    Left = 0
    Top = 0
    Width = 440
    Height = 331
    Orientation = orVertical
    Position = 159
    Percent = 48
    SplitterWidth = 2
    Align = alClient
    BorderShadow = clBtnFace
    Color = 15987699
    TabOrder = 0
    BarSize = (
      0
      159
      440
      161)
    UpperLeftControls = (
      MemoLog)
    LowerRightControls = (
      RzSplitter1)
    object MemoLog: TRzMemo
      Left = 0
      Top = 0
      Width = 440
      Height = 159
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
      OnChange = MemoLogChange
      OnDblClick = MemoLogDblClick
      FrameVisible = True
    end
    object RzSplitter1: TRzSplitter
      Left = 0
      Top = 0
      Width = 440
      Height = 170
      Orientation = orVertical
      Position = 79
      Percent = 46
      SplitterWidth = 0
      Align = alClient
      Color = 15987699
      TabOrder = 0
      BarSize = (
        0
        79
        440
        79)
      UpperLeftControls = (
        Panel)
      LowerRightControls = (
        GridGate)
      object Panel: TPanel
        Left = 0
        Top = 0
        Width = 440
        Height = 79
        Align = alClient
        TabOrder = 0
        DesignSize = (
          440
          79)
        object Label1: TLabel
          Left = 0
          Top = 16
          Width = 36
          Height = 12
          Caption = 'Lable1'
          Transparent = True
        end
        object Label2: TLabel
          Left = 0
          Top = 32
          Width = 36
          Height = 12
          Caption = 'Lable2'
          Transparent = True
        end
        object Lbcheck: TLabel
          Left = 48
          Top = 64
          Width = 42
          Height = 12
          Caption = 'Lbcheck'
          Transparent = True
          Visible = False
        end
        object LbRunSocketTime: TLabel
          Left = 0
          Top = 0
          Width = 78
          Height = 12
          Caption = 'RunSocketTime'
          Transparent = True
          Visible = False
        end
        object LbRunTime: TLabel
          Left = 204
          Top = 16
          Width = 42
          Height = 12
          Caption = 'RunTime'
          Transparent = True
        end
        object LbTimeCount: TLabel
          Left = 388
          Top = 16
          Width = 54
          Height = 12
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          BiDiMode = bdRightToLeft
          Caption = 'TimeCount'
          ParentBiDiMode = False
          Transparent = True
        end
        object LbUserCount: TLabel
          Left = 0
          Top = 0
          Width = 54
          Height = 12
          Caption = 'UserCount'
          Transparent = True
        end
        object MemStatus: TLabel
          Left = 280
          Top = 50
          Width = 36
          Height = 12
          Alignment = taRightJustify
          Caption = 'Status'
          Font.Charset = GB2312_CHARSET
          Font.Color = clRed
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          Transparent = True
          Visible = False
        end
        object LabelVersion: TLabel
          Left = 322
          Top = 16
          Width = 12
          Height = 12
          BiDiMode = bdLeftToRight
          Caption = 'LV'
          Font.Charset = GB2312_CHARSET
          Font.Color = clRed
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentBiDiMode = False
          ParentFont = False
          Transparent = True
        end
        object LTotalRAM: TLabel
          Left = 322
          Top = 32
          Width = 54
          Height = 12
          Caption = 'LTotalRAM'
          Font.Charset = GB2312_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object LFreeRAM: TLabel
          Left = 322
          Top = 48
          Width = 48
          Height = 12
          Caption = 'LFreeRAM'
          Font.Charset = GB2312_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object LTotalVirtual: TLabel
          Left = 234
          Top = 34
          Width = 78
          Height = 12
          Caption = 'LTotalVirtual'
          Font.Charset = GB2312_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          Transparent = True
          Visible = False
        end
        object LFreeVirtual: TLabel
          Left = 234
          Top = 50
          Width = 72
          Height = 12
          Caption = 'LFreeVirtual'
          Font.Charset = GB2312_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          Transparent = True
          Visible = False
        end
        object LMemoryLoad: TLabel
          Left = 322
          Top = 66
          Width = 66
          Height = 12
          Caption = 'LMemoryLoad'
          Font.Charset = GB2312_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object Label5: TLabel
          Left = 0
          Top = 48
          Width = 36
          Height = 12
          Caption = 'Label5'
        end
        object Label20: TLabel
          Left = 0
          Top = 64
          Width = 42
          Height = 12
          Caption = 'Label20'
        end
      end
      object GridGate: TStringGrid
        Left = 0
        Top = 0
        Width = 440
        Height = 91
        Align = alClient
        ColCount = 7
        DefaultColWidth = 60
        DefaultRowHeight = 18
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object CloseTimer: TTimer
    Enabled = False
    Interval = 100
    Left = 184
    Top = 16
  end
  object MainMenu: TMainMenu
    Left = 216
    Top = 16
    object MENU_CONTROL: TMenuItem
      Caption = #25511#21046'(&C)'
      object MENU_CONTROL_CLEARLOGMSG: TMenuItem
        Caption = #28165#38500#26085#24535'(&C)'
        OnClick = MENU_CONTROL_CLEARLOGMSGClick
      end
      object MENU_CONTROL_RELOAD: TMenuItem
        Caption = #37325#26032#21152#36733'(&R)'
        object MENU_CONTROL_RELOAD_ITEMDB: TMenuItem
          Caption = #29289#21697#25968#25454#24211'(&I)'
          OnClick = MENU_CONTROL_RELOAD_ITEMDBClick
        end
        object MENU_CONTROL_RELOAD_MAGICDB: TMenuItem
          Caption = #25216#33021#25968#25454#24211'(&S)'
          OnClick = MENU_CONTROL_RELOAD_MAGICDBClick
        end
        object MENU_CONTROL_RELOAD_MONSTERDB: TMenuItem
          Caption = #24618#29289#25968#25454#24211'(&M)'
          OnClick = MENU_CONTROL_RELOAD_MONSTERDBClick
        end
        object MENU_CONTROL_RELOAD_MONSTERSAY: TMenuItem
          Caption = #24618#29289#35828#35805#35774#32622'(&M)'
          OnClick = MENU_CONTROL_RELOAD_MONSTERSAYClick
        end
        object MENU_CONTROL_RELOAD_DISABLEMAKE: TMenuItem
          Caption = #25968#25454#21015#34920'(&D)'
          OnClick = MENU_CONTROL_RELOAD_DISABLEMAKEClick
        end
        object MENU_CONTROL_RELOAD_STARTPOINT: TMenuItem
          Caption = #22320#22270#23433#20840#21306'(&S)'
          OnClick = MENU_CONTROL_RELOAD_STARTPOINTClick
        end
        object MENU_CONTROL_RELOAD_CONF: TMenuItem
          Caption = #21442#25968#35774#32622'(&C)'
          OnClick = MENU_CONTROL_RELOAD_CONFClick
        end
        object MonItems: TMenuItem
          Caption = #24618#29289#29190#29575'(&M)'
          OnClick = MonItemsClick
        end
      end
      object MENU_CONTROL_GATE: TMenuItem
        Caption = #28216#25103#32593#20851'(&G)'
        object MENU_CONTROL_GATE_OPEN: TMenuItem
          Caption = #25171#24320'(&O)'
          OnClick = MENU_CONTROL_GATE_OPENClick
        end
        object MENU_CONTROL_GATE_CLOSE: TMenuItem
          Caption = #20851#38381'(&C)'
          OnClick = MENU_CONTROL_GATE_CLOSEClick
        end
      end
      object MENU_CONTROL_REFSERVERCONFIG: TMenuItem
        Caption = #21047#26032#23458#25143#31471#37197#21046#20449#24687'(&O)'
        Visible = False
        OnClick = MENU_CONTROL_REFSERVERCONFIGClick
      end
      object MENU_CONTROL_EXIT: TMenuItem
        Caption = #36864#20986'(&X)'
        OnClick = MENU_CONTROL_EXITClick
      end
    end
    object MENU_VIEW: TMenuItem
      Caption = #26597#30475'(&V)'
      object MENU_VIEW_ONLINEHUMAN: TMenuItem
        Caption = #22312#32447#20154#29289'(&O)'
        OnClick = MENU_VIEW_ONLINEHUMANClick
      end
      object MENU_VIEW_SESSION: TMenuItem
        Caption = #20840#23616#20250#35805'(&S)'
        OnClick = MENU_VIEW_SESSIONClick
      end
      object MENU_VIEW_LEVEL: TMenuItem
        Caption = #31561#32423#23646#24615'(&L)'
        OnClick = MENU_VIEW_LEVELClick
      end
      object MENU_VIEW_LIST: TMenuItem
        Caption = #21015#34920#20449#24687'(&L)'
        OnClick = MENU_VIEW_LISTClick
      end
      object MENU_VIEW_KERNELINFO: TMenuItem
        Caption = #20869#26680#25968#25454'(&K)'
        OnClick = MENU_VIEW_KERNELINFOClick
      end
    end
    object MENU_OPTION: TMenuItem
      Caption = #36873#39033'(&P)'
      object MENU_OPTION_GENERAL: TMenuItem
        Caption = #22522#26412#35774#32622'(&G)'
        OnClick = MENU_OPTION_GENERALClick
      end
      object MENU_OPTION_GAME: TMenuItem
        Caption = #21442#25968#35774#32622'(&O)'
        OnClick = MENU_OPTION_GAMEClick
      end
      object MENU_OPTION_ITEMFUNC: TMenuItem
        Caption = #29289#21697#35013#22791'(&I)'
        OnClick = MENU_OPTION_ITEMFUNCClick
      end
      object MENU_OPTION_FUNCTION: TMenuItem
        Caption = #21151#33021#35774#32622'(&F)'
        OnClick = MENU_OPTION_FUNCTIONClick
      end
      object G1: TMenuItem
        Caption = #28216#25103#21629#20196'(&C)'
        OnClick = G1Click
      end
      object MENU_OPTION_MONSTER: TMenuItem
        Caption = #24618#29289#35774#32622'(&M)'
        OnClick = MENU_OPTION_MONSTERClick
      end
      object MENU_OPTION_SERVERCONFIG: TMenuItem
        Caption = #24615#33021#21442#25968'(&P)'
        OnClick = MENU_OPTION_SERVERCONFIGClick
      end
      object MENU_OPTION_HERO: TMenuItem
        Caption = #33521#38596#35774#32622'(&H)'
        OnClick = MENU_OPTION_HEROClick
      end
    end
    object MENU_MANAGE: TMenuItem
      Caption = #31649#29702'(&M)'
      object MENU_MANAGE_ONLINEMSG: TMenuItem
        Caption = #22312#32447#28040#24687'(&S)'
        OnClick = MENU_MANAGE_ONLINEMSGClick
      end
      object MENU_MANAGE_PLUG: TMenuItem
        Caption = #21151#33021#25554#20214'(&P)'
        OnClick = MENU_MANAGE_PLUGClick
      end
      object MENU_MANAGE_CASTLE: TMenuItem
        Caption = #22478#22561#31649#29702'(&C)'
        OnClick = MENU_MANAGE_CASTLEClick
      end
      object MENU_MANAGE_SYS: TMenuItem
        Caption = #31995#32479#31649#29702'(&G)'
        OnClick = MENU_MANAGE_SYSClick
      end
    end
    object MENU_TOOLS: TMenuItem
      Caption = #24037#20855'(&T)'
      object MENU_TOOLS_IPSEARCH: TMenuItem
        Caption = #22320#21306#26597#35810'(&S)'
        OnClick = MENU_TOOLS_IPSEARCHClick
      end
    end
    object MENU_HELP: TMenuItem
      Caption = #24110#21161'(&H)'
      object MENU_HELP_REGKEY: TMenuItem
        Caption = #24110#21161'(&R)'
        OnClick = MENU_HELP_REGKEYClick
      end
      object MENU_HELP_ABOUT: TMenuItem
        Caption = #20851#20110'(&A)'
        OnClick = MENU_HELP_ABOUTClick
      end
    end
  end
  object RunTimer: TTimer
    Enabled = False
    Interval = 1
    Left = 88
    Top = 12
  end
  object SaveVariableTimer: TTimer
    Interval = 10000
    Left = 148
    Top = 12
  end
  object StartTimer: TTimer
    Enabled = False
    Interval = 100
    Left = 116
    Top = 12
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 2000
    Left = 60
    Top = 12
  end
  object IdUDPClientLog: TIdUDPClient
    Port = 0
    Left = 24
    Top = 16
  end
end
