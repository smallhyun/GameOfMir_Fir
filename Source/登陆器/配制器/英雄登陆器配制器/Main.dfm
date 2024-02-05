object frmMain: TfrmMain
  Left = 843
  Top = 170
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MakeGM'#30331#38470#22120#37197#21046#22120' V2012/07/15'
  ClientHeight = 519
  ClientWidth = 473
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object RzPageControl: TRzPageControl
    Left = 0
    Top = 0
    Width = 473
    Height = 500
    ActivePage = TabSheet1
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    FixedDimension = 18
    object TabSheet1: TRzTabSheet
      Caption = #22522#26412#35774#32622
      object RzGroupBox1: TRzGroupBox
        Left = 8
        Top = 8
        Width = 457
        Height = 121
        Caption = #30331#38470#22120#25991#20214
        TabOrder = 0
        object RzLabel1: TRzLabel
          Left = 8
          Top = 20
          Width = 60
          Height = 12
          Caption = 'GameLogin:'
          BlinkIntervalOff = 1
          BlinkIntervalOn = 1
        end
        object RzLabel2: TRzLabel
          Left = 8
          Top = 44
          Width = 60
          Height = 12
          Caption = 'MirClient:'
          BlinkIntervalOff = 1
          BlinkIntervalOn = 1
        end
        object RzLabel8: TRzLabel
          Left = 8
          Top = 68
          Width = 54
          Height = 12
          Caption = #30028#38754#25991#20214':'
          BlinkIntervalOff = 1
          BlinkIntervalOn = 1
        end
        object RzLabel9: TRzLabel
          Left = 8
          Top = 92
          Width = 54
          Height = 12
          Caption = #32972#26223#22270#29255':'
          BlinkIntervalOff = 1
          BlinkIntervalOn = 1
        end
        object EditGameLoginFile: TRzButtonEdit
          Left = 72
          Top = 16
          Width = 377
          Height = 20
          FrameStyle = fsBump
          FrameVisible = True
          TabOrder = 0
          AltBtnWidth = 15
          ButtonWidth = 15
          OnButtonClick = EditGameLoginFileButtonClick
        end
        object EditMirClientFile: TRzButtonEdit
          Left = 72
          Top = 40
          Width = 377
          Height = 20
          FrameStyle = fsBump
          FrameVisible = True
          TabOrder = 1
          AltBtnWidth = 15
          ButtonWidth = 15
          OnButtonClick = EditMirClientFileButtonClick
        end
        object EditDataFile: TRzButtonEdit
          Left = 72
          Top = 64
          Width = 377
          Height = 20
          FrameStyle = fsBump
          FrameVisible = True
          TabOrder = 2
          AltBtnWidth = 15
          ButtonWidth = 15
          OnButtonClick = EditDataFileButtonClick
        end
        object EditBackImage: TRzButtonEdit
          Left = 72
          Top = 88
          Width = 377
          Height = 20
          Enabled = False
          FrameStyle = fsBump
          FrameVisible = True
          TabOrder = 3
          AltBtnWidth = 15
          ButtonWidth = 15
          OnButtonClick = EditBackImageButtonClick
        end
      end
      object RzGroupBox3: TRzGroupBox
        Left = 8
        Top = 136
        Width = 457
        Height = 89
        Caption = #25554#20214#21015#34920
        TabOrder = 1
        object ListBox: TListBox
          Left = 8
          Top = 14
          Width = 441
          Height = 67
          ItemHeight = 12
          TabOrder = 0
        end
      end
      object RzGroupBox2: TRzGroupBox
        Left = 8
        Top = 232
        Width = 457
        Height = 209
        Caption = #37197#21046#20449#24687
        TabOrder = 2
        object RzLabel3: TRzLabel
          Left = 8
          Top = 24
          Width = 54
          Height = 12
          Caption = #24555#25463#26041#24335':'
          BlinkIntervalOff = 1
          BlinkIntervalOn = 1
        end
        object RzLabel4: TRzLabel
          Left = 8
          Top = 48
          Width = 54
          Height = 12
          Caption = #23448#26041#32593#31449':'
          BlinkIntervalOff = 1
          BlinkIntervalOn = 1
        end
        object RzLabel5: TRzLabel
          Left = 8
          Top = 72
          Width = 54
          Height = 12
          Caption = #36828#31243#21015#34920':'
          BlinkIntervalOff = 1
          BlinkIntervalOn = 1
        end
        object RzLabel6: TRzLabel
          Left = 8
          Top = 96
          Width = 54
          Height = 12
          Caption = #37197#21046#25991#20214':'
          BlinkIntervalOff = 1
          BlinkIntervalOn = 1
        end
        object RzLabel7: TRzLabel
          Left = 8
          Top = 120
          Width = 54
          Height = 12
          Caption = #22806#25346#26816#27979':'
          BlinkIntervalOff = 1
          BlinkIntervalOn = 1
        end
        object RzLabel11: TRzLabel
          Left = 136
          Top = 208
          Width = 6
          Height = 12
          BlinkIntervalOff = 1
          BlinkIntervalOn = 1
        end
        object Label1: TLabel
          Left = 8
          Top = 184
          Width = 54
          Height = 12
          Caption = #36830#25509#23494#30721':'
        end
        object EditName: TRzEdit
          Left = 72
          Top = 20
          Width = 377
          Height = 20
          Text = #39134#23572#19990#30028#30495#24425#30331#38470#22120
          FrameStyle = fsBump
          FrameVisible = True
          TabOrder = 0
        end
        object EditHomePage: TRzEdit
          Left = 72
          Top = 44
          Width = 377
          Height = 20
          Text = 'http://www.cqfir.net'
          FrameStyle = fsBump
          FrameVisible = True
          TabOrder = 1
        end
        object EditGameList: TRzEdit
          Left = 72
          Top = 68
          Width = 377
          Height = 20
          Text = 'http://www.941sf.com/GameList.txt'
          FrameStyle = fsBump
          FrameVisible = True
          TabOrder = 2
        end
        object EditConfig: TRzEdit
          Left = 72
          Top = 92
          Width = 377
          Height = 20
          Text = 'http://www.941sf.com/UpDate.txt'
          FrameStyle = fsBump
          FrameVisible = True
          TabOrder = 3
        end
        object RadioGroup: TRzRadioGroup
          Left = 8
          Top = 138
          Width = 177
          Height = 41
          Columns = 2
          GradientDirection = gdVerticalBox
          ItemFrameColor = 8409372
          ItemHotTrack = True
          ItemHighlightColor = 2203937
          ItemIndex = 0
          Items.Strings = (
            #20223#30427#22823#30028#38754
            #20223#24449#36884#30028#38754)
          TabOrder = 4
        end
        object EditCheckProcesses: TRzEdit
          Left = 72
          Top = 118
          Width = 377
          Height = 20
          Text = 'http://www.941sf.com/CheckProcesses.txt'
          FrameStyle = fsBump
          FrameVisible = True
          TabOrder = 5
        end
        object RzButtonGameLoginOption: TRzButton
          Left = 352
          Top = 158
          Width = 97
          FrameColor = 7617536
          Caption = #30331#38470#22120#30028#38754#37197#21046
          HotTrack = True
          TabOrder = 6
          OnClick = RzButtonGameLoginOptionClick
        end
        object RzCheckBoxShowFullScreen: TRzCheckBox
          Left = 200
          Top = 152
          Width = 139
          Height = 15
          Caption = #26174#31034#31383#21475#20999#25442#25552#31034#20449#24687
          Checked = True
          State = cbChecked
          TabOrder = 7
          WordWrap = True
        end
        object EditPassword: TRzEdit
          Left = 72
          Top = 182
          Width = 273
          Height = 20
          Text = '123456'
          FrameStyle = fsBump
          FrameVisible = True
          TabOrder = 8
        end
      end
      object ButtonOK: TRzButton
        Left = 8
        Top = 446
        FrameColor = 7617536
        Caption = #21512#25104#30331#38470#22120
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        HotTrack = True
        ParentFont = False
        TabOrder = 3
        OnClick = ButtonOKClick
      end
      object RzButtonSaveConfig: TRzButton
        Left = 184
        Top = 446
        Width = 91
        FrameColor = 7617536
        Caption = #20445#23384#37197#21046#20449#24687
        HotTrack = True
        TabOrder = 4
        OnClick = RzButtonSaveConfigClick
      end
      object ButtonClose: TRzButton
        Left = 384
        Top = 446
        FrameColor = 7617536
        Caption = #36864#20986
        HotTrack = True
        TabOrder = 5
        OnClick = ButtonCloseClick
      end
    end
    object TabSheet2: TRzTabSheet
      Caption = #35299#21253#35774#32622
      object RzLabel10: TRzLabel
        Left = 8
        Top = 396
        Width = 54
        Height = 12
        Caption = #29289#21697#21517#31216':'
        BlinkIntervalOff = 1
        BlinkIntervalOn = 1
      end
      object RzLabel12: TRzLabel
        Left = 8
        Top = 420
        Width = 66
        Height = 12
        Caption = #29289#21697#21253#21517#31216':'
        BlinkIntervalOff = 1
        BlinkIntervalOn = 1
      end
      object ListViewBindItem: TRzListView
        Left = 0
        Top = 0
        Width = 469
        Height = 385
        Align = alTop
        Columns = <
          item
            Caption = #31867#22411
          end
          item
            Caption = #29289#21697#21517#31216
            Width = 100
          end
          item
            Caption = #29289#21697#21253#21517#31216
            Width = 298
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        SortType = stBoth
        TabOrder = 0
        ViewStyle = vsReport
        OnClick = ListViewBindItemClick
      end
      object RzRadioGroupItemType: TRzRadioGroup
        Left = 224
        Top = 392
        Width = 209
        Height = 41
        Caption = #29289#21697#31867#22411
        Columns = 4
        ItemHotTrack = True
        Items.Strings = (
          'HP'
          'MP'
          'HPMP'
          #29305#27530#33647#21697)
        TabOrder = 1
      end
      object EditItemName: TRzEdit
        Left = 80
        Top = 392
        Width = 137
        Height = 20
        TabOrder = 2
      end
      object EditBindItemName: TRzEdit
        Left = 80
        Top = 416
        Width = 137
        Height = 20
        TabOrder = 3
      end
      object ButtonBindAdd: TRzButton
        Left = 8
        Top = 446
        FrameColor = 7617536
        Caption = #22686#21152
        HotTrack = True
        TabOrder = 4
        OnClick = ButtonBindAddClick
      end
      object ButtonBindDel: TRzButton
        Left = 168
        Top = 446
        FrameColor = 7617536
        Caption = #21024#38500
        Enabled = False
        HotTrack = True
        TabOrder = 5
        OnClick = ButtonBindDelClick
      end
      object ButtonBindSave: TRzButton
        Left = 248
        Top = 446
        FrameColor = 7617536
        Caption = #20445#23384
        Enabled = False
        HotTrack = True
        TabOrder = 6
        OnClick = ButtonBindSaveClick
      end
      object ButtonBindChg: TRzButton
        Left = 88
        Top = 446
        FrameColor = 7617536
        Caption = #20462#25913
        Enabled = False
        HotTrack = True
        TabOrder = 7
        OnClick = ButtonBindChgClick
      end
    end
    object TabSheet3: TRzTabSheet
      Caption = #29289#21697#36807#28388
      object RzLabel13: TRzLabel
        Left = 8
        Top = 396
        Width = 54
        Height = 12
        Caption = #29289#21697#21517#31216':'
        BlinkIntervalOff = 1
        BlinkIntervalOn = 1
      end
      object RzLabel14: TRzLabel
        Left = 8
        Top = 420
        Width = 54
        Height = 12
        Caption = #29289#21697#31867#22411':'
        BlinkIntervalOff = 1
        BlinkIntervalOn = 1
      end
      object Label3: TLabel
        Left = 227
        Top = 424
        Width = 54
        Height = 12
        Caption = #21517#31216#39068#33394':'
      end
      object LabelItemNameColor: TLabel
        Left = 328
        Top = 422
        Width = 9
        Height = 17
        AutoSize = False
        Color = clBackground
        ParentColor = False
      end
      object ListViewFilterItem: TRzListView
        Left = 0
        Top = 0
        Width = 469
        Height = 377
        Align = alTop
        Columns = <
          item
            Caption = #29289#21697#31867#22411
            Width = 80
          end
          item
            Caption = #29289#21697#21517#31216
            Width = 100
          end
          item
            Caption = #26497#21697#25552#31034
            Width = 80
          end
          item
            Caption = #33258#21160#25441#21462
            Width = 80
          end
          item
            Caption = #26174#31034#21517#31216
            Width = 108
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        SortType = stBoth
        TabOrder = 0
        ViewStyle = vsReport
        OnClick = ListViewFilterItemClick
      end
      object EditFilterItemName: TRzEdit
        Left = 64
        Top = 392
        Width = 137
        Height = 20
        TabOrder = 1
      end
      object ButtonFilterAdd: TRzButton
        Left = 8
        Top = 446
        FrameColor = 7617536
        Caption = #22686#21152
        HotTrack = True
        TabOrder = 2
        OnClick = ButtonFilterAddClick
      end
      object ButtonFilterChg: TRzButton
        Left = 88
        Top = 446
        FrameColor = 7617536
        Caption = #20462#25913
        Enabled = False
        HotTrack = True
        TabOrder = 3
        OnClick = ButtonFilterChgClick
      end
      object ButtonFilterDel: TRzButton
        Left = 168
        Top = 446
        FrameColor = 7617536
        Caption = #21024#38500
        Enabled = False
        HotTrack = True
        TabOrder = 4
        OnClick = ButtonFilterDelClick
      end
      object ButtonFilterSave: TRzButton
        Left = 248
        Top = 446
        FrameColor = 7617536
        Caption = #20445#23384
        Enabled = False
        HotTrack = True
        TabOrder = 5
        OnClick = ButtonFilterSaveClick
      end
      object RzComboBoxItemFilter: TRzComboBox
        Left = 64
        Top = 416
        Width = 137
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        TabOrder = 6
        Text = '('#20840#37096#20998#31867')'
        OnChange = RzComboBoxItemFilterChange
        Items.Strings = (
          '('#20840#37096#20998#31867')'
          #20854#20182#31867
          #33647#21697#31867
          #26381#35013#31867
          #27494#22120#31867
          #39318#39280#31867
          #39280#21697#31867
          #35013#39280#31867)
        ItemIndex = 0
      end
      object RzCheckGroupItemFilter: TRzCheckGroup
        Left = 224
        Top = 376
        Width = 241
        Height = 41
        Columns = 3
        ItemFrameColor = 8409372
        ItemHighlightColor = 2203937
        ItemHotTrack = True
        Items.Strings = (
          #26497#21697#25552#31034
          #33258#21160#25441#21462
          #26174#31034#21517#31216)
        TabOrder = 7
        CheckStates = (
          0
          0
          0)
      end
      object RzButtonFromDB: TRzButton
        Left = 360
        Top = 446
        Width = 105
        FrameColor = 7617536
        Caption = #20174#25968#25454#24211#20013#23548#20837
        HotTrack = True
        TabOrder = 8
        OnClick = RzButtonFromDBClick
      end
      object EditItemNameColor: TSpinEdit
        Left = 280
        Top = 420
        Width = 41
        Height = 21
        Hint = #24403#20154#29289#25915#20987#20854#20182#20154#29289#26102#21517#23383#39068#33394#65292#40664#35748#20026'47'
        MaxValue = 255
        MinValue = 0
        TabOrder = 9
        Value = 8
        OnChange = EditItemNameColorChange
      end
    end
    object TabSheet4: TRzTabSheet
      Caption = #35835#21462#35268#21017
      object RzListBox: TRzListBox
        Left = 8
        Top = 8
        Width = 121
        Height = 465
        ItemHeight = 12
        Items.Strings = (
          'Effect'
          'Dragon'
          'Prguse'
          'Prguse2'
          'Prguse3'
          'ChrSel'
          'Map'
          'HumEffect'
          'HumEffect1'
          'HumEffect2'
          'BagItem'
          'StateItem'
          'DnItem'
          'Hum'
          'Hair'
          'Hair2'
          'Weapon'
          'MagIcon'
          'Npc'
          'F-Npc'
          'Magic'
          'Magic2'
          'Magic3'
          'Magic4'
          'Magic5'
          'Magic6'
          'Horse'
          'HumHorse'
          'HairHorse'
          'Mon'
          'Mon1'
          'Mon2'
          'Mon3'
          'Mon4'
          'Mon5'
          'Mon6'
          'Mon7'
          'Mon8'
          'Mon9'
          'Mon10'
          'Mon11'
          'Mon12'
          'Mon13'
          'Mon14'
          'Mon15'
          'Mon16'
          'Mon17'
          'Mon18'
          'Mon19'
          'Mon20'
          'Mon21'
          'Mon22'
          'Mon23'
          'Mon24'
          'Mon25'
          'Mon26'
          'Mon27'
          'Mon28'
          'Mon29')
        TabOrder = 0
        OnClick = RzListBoxClick
      end
      object RzRadioGroup: TRzRadioGroup
        Left = 136
        Top = 8
        Width = 329
        Height = 97
        Caption = 'RzRadioGroup'
        Items.Strings = (
          #21482#35835#21462'Wil'#25991#20214
          #21482#35835#21462'Data'#25991#20214
          #20248#20808#35835#21462'Wil'#25991#20214#65292'Wil'#25991#20214#19981#23384#22312#35835#21462'Data'#25991#20214
          #20248#20808#35835#21462'Data'#25991#20214#65292'Data'#25991#20214#19981#23384#22312#35835#21462'Wil'#25991#20214)
        TabOrder = 1
        OnClick = RzRadioGroupClick
      end
      object RzButtonBackOption: TRzButton
        Left = 142
        Top = 127
        Width = 91
        FrameColor = 7617536
        Caption = #40664#35748#37197#21046
        HotTrack = True
        TabOrder = 2
        OnClick = RzButtonBackOptionClick
      end
      object RzButtonLoadOption: TRzButton
        Left = 238
        Top = 127
        Width = 91
        FrameColor = 7617536
        Caption = #35835#21462#37197#21046#20449#24687
        HotTrack = True
        TabOrder = 3
        OnClick = RzButtonLoadOptionClick
      end
      object RzButtonSaveOption: TRzButton
        Left = 336
        Top = 127
        Width = 89
        FrameColor = 7617536
        Caption = #20445#23384#37197#21046#20449#24687
        Enabled = False
        HotTrack = True
        TabOrder = 4
        OnClick = RzButtonSaveOptionClick
      end
    end
    object TabSheet6: TRzTabSheet
      Caption = #26356#26032#20449#24687
      object Label11: TLabel
        Left = 112
        Top = 364
        Width = 90
        Height = 12
        Caption = #23458#25143#31471#23384#25918#30446#24405':'
        Transparent = True
      end
      object Label13: TLabel
        Left = 112
        Top = 388
        Width = 54
        Height = 12
        Caption = #19979#36733#22320#22336':'
        Transparent = True
      end
      object LabelMD5: TLabel
        Left = 112
        Top = 408
        Width = 48
        Height = 12
        Caption = #25991#20214'MD5:'
      end
      object Label14: TLabel
        Left = 112
        Top = 428
        Width = 246
        Height = 12
        Caption = #28857#20987#25171#24320#25991#20214#25110#25302#21160#25991#20214#25918#21040#30028#38754#19978#33719#21462'MD5'#20540
        Font.Charset = GB2312_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label12: TLabel
        Left = 296
        Top = 364
        Width = 54
        Height = 12
        Caption = #25991#20214#21517#31216':'
        Transparent = True
      end
      object MemoUpgrade: TMemo
        Left = 0
        Top = 0
        Width = 469
        Height = 353
        Align = alTop
        Lines.Strings = (
          ';'#25991#20214#31867#22411'(0='#26222#36890#25991#20214' 1='#30331#38470#22120' 2=ZIP'#21387#32553#25991#20214')'#9#30446#24405#9#25991#20214#21517#31216#9'MD5'#20540#9#19979#36733#22320#22336)
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object RadioGroup1: TRadioGroup
        Left = 0
        Top = 357
        Width = 105
        Height = 84
        Caption = #25991#20214#31867#22411
        ItemIndex = 0
        Items.Strings = (
          #26222#36890#25991#20214
          #30331#38470#22120#25991#20214
          'ZIP'#21387#32553#25991#20214)
        TabOrder = 1
      end
      object EditMD5: TEdit
        Left = 168
        Top = 405
        Width = 297
        Height = 20
        BevelInner = bvNone
        BevelOuter = bvNone
        Color = clWhite
        Font.Charset = GB2312_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
      end
      object EditDownLoadAddr: TEdit
        Left = 168
        Top = 384
        Width = 297
        Height = 20
        Font.Charset = GB2312_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object ComboBox: TComboBox
        Left = 208
        Top = 360
        Width = 81
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        TabOrder = 4
        Items.Strings = (
          'Data'
          'Map'
          'Wav'
          'UpDate'
          #30331#38470#22120#30446#24405)
      end
      object EditFileName: TEdit
        Left = 352
        Top = 360
        Width = 113
        Height = 20
        Font.Charset = GB2312_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 5
      end
      object ButtonUpgradeSave: TButton
        Left = 368
        Top = 448
        Width = 96
        Height = 25
        Caption = #20445#23384#32534#36753#25991#20214
        TabOrder = 6
        OnClick = ButtonUpgradeSaveClick
      end
      object ButtonUpgradeLoad: TButton
        Left = 248
        Top = 448
        Width = 89
        Height = 25
        Caption = #35835#21462#26356#26032#21015#34920
        TabOrder = 7
        OnClick = ButtonUpgradeLoadClick
      end
      object ButtonUpgradeCreate: TButton
        Left = 160
        Top = 448
        Width = 81
        Height = 25
        Caption = #29983#25104#26356#26032#21015#34920
        TabOrder = 8
        OnClick = ButtonUpgradeCreateClick
      end
      object ButtonUpgradeOpen: TButton
        Left = 80
        Top = 448
        Width = 73
        Height = 25
        Caption = #25171#24320#25991#20214
        TabOrder = 9
        OnClick = ButtonUpgradeOpenClick
      end
      object ButtonUpgradeAdd: TButton
        Left = 0
        Top = 448
        Width = 73
        Height = 25
        Caption = #28155#21152
        TabOrder = 10
        OnClick = ButtonUpgradeAddClick
      end
    end
    object TabSheet7: TRzTabSheet
      Caption = #29289#21697#22791#27880
      object RzLabel20: TRzLabel
        Left = 8
        Top = 396
        Width = 54
        Height = 12
        Caption = #29289#21697#21517#31216':'
        BlinkIntervalOff = 1
        BlinkIntervalOn = 1
      end
      object RzLabel21: TRzLabel
        Left = 8
        Top = 420
        Width = 54
        Height = 12
        Caption = #29289#21697#22791#27880':'
        BlinkIntervalOff = 1
        BlinkIntervalOn = 1
      end
      object EditItemDescName: TRzEdit
        Left = 64
        Top = 392
        Width = 137
        Height = 20
        TabOrder = 0
      end
      object ButtonItemDescFromDB: TRzButton
        Left = 368
        Top = 446
        Width = 97
        FrameColor = 7617536
        Caption = #20174#25968#25454#24211#20013#23548#20837
        HotTrack = True
        TabOrder = 1
        OnClick = ButtonItemDescFromDBClick
      end
      object ButtonItemDescAdd: TRzButton
        Left = 8
        Top = 446
        Width = 49
        FrameColor = 7617536
        Caption = #22686#21152
        HotTrack = True
        TabOrder = 2
        OnClick = ButtonItemDescAddClick
      end
      object ButtonItemDescChg: TRzButton
        Left = 64
        Top = 446
        Width = 49
        FrameColor = 7617536
        Caption = #20462#25913
        Enabled = False
        HotTrack = True
        TabOrder = 3
        OnClick = ButtonItemDescChgClick
      end
      object ButtonItemDescDel: TRzButton
        Left = 120
        Top = 446
        Width = 49
        FrameColor = 7617536
        Caption = #21024#38500
        Enabled = False
        HotTrack = True
        TabOrder = 4
        OnClick = ButtonItemDescDelClick
      end
      object ButtonItemDescSave: TRzButton
        Left = 176
        Top = 446
        Width = 49
        FrameColor = 7617536
        Caption = #20445#23384
        Enabled = False
        HotTrack = True
        TabOrder = 5
        OnClick = ButtonItemDescSaveClick
      end
      object EditItemDesc: TRzEdit
        Left = 64
        Top = 416
        Width = 401
        Height = 20
        TabOrder = 6
      end
      object ListViewItemDesc: TRzListView
        Left = 0
        Top = 0
        Width = 469
        Height = 385
        Align = alTop
        Columns = <
          item
            Caption = #29289#21697#21517#31216
            Width = 100
          end
          item
            Caption = #29289#21697#22791#27880
            Width = 348
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 7
        ViewStyle = vsReport
        OnClick = ListViewItemDescClick
      end
      object ButtonDelNotDescItem: TRzButton
        Left = 234
        Top = 446
        Width = 127
        FrameColor = 7617536
        Caption = #21024#38500#27809#26377#22791#27880#30340#29289#21697
        HotTrack = True
        TabOrder = 8
        OnClick = ButtonDelNotDescItemClick
      end
    end
  end
  object RzStatusBar: TRzStatusBar
    Left = 0
    Top = 500
    Width = 473
    Height = 19
    BorderInner = fsNone
    BorderOuter = fsNone
    BorderSides = [sdLeft, sdTop, sdRight, sdBottom]
    BorderWidth = 0
    TabOrder = 1
    object RzStatusPane1: TRzStatusPane
      Left = 0
      Top = 0
      Width = 241
      Height = 19
      Align = alLeft
      BlinkIntervalOff = 1
      BlinkIntervalOn = 1
    end
    object ProgressBar: TProgressBar
      Left = 264
      Top = 2
      Width = 150
      Height = 17
      TabOrder = 0
    end
  end
  object SaveDialog: TSaveDialog
    Filter = 'GameLogin|*.exe'
    Left = 240
    Top = 72
  end
  object OpenDialog: TOpenDialog
    Filter = 'GameLogin|(*.exe)'
    Left = 272
    Top = 72
  end
  object TimerStart: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerStartTimer
    Left = 304
    Top = 72
  end
end
