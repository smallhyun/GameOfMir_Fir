object FrmOption: TFrmOption
  Left = 777
  Top = 284
  BorderStyle = bsDialog
  Caption = #39640#32423#37197#21046
  ClientHeight = 563
  ClientWidth = 458
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object RzGroupBox1: TRzGroupBox
    Left = 8
    Top = 8
    Width = 441
    Height = 545
    Caption = #36164#28304#35835#21462#35268#21017
    TabOrder = 0
    object RzListBox: TRzListBox
      Left = 8
      Top = 16
      Width = 121
      Height = 521
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
      Top = 16
      Width = 297
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
    object RzButtonSaveOption: TRzButton
      Left = 336
      Top = 127
      Width = 89
      FrameColor = 7617536
      Caption = #20445#23384#37197#21046#20449#24687
      Enabled = False
      HotTrack = True
      TabOrder = 2
      OnClick = RzButtonSaveOptionClick
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
    object RzButtonBackOption: TRzButton
      Left = 142
      Top = 127
      Width = 91
      FrameColor = 7617536
      Caption = #40664#35748#37197#21046
      HotTrack = True
      TabOrder = 4
      OnClick = RzButtonBackOptionClick
    end
  end
end
