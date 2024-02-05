object Form1: TForm1
  Left = 350
  Top = 338
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 410
  ClientWidth = 351
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
  object Panel1: TPanel
    Left = 0
    Top = 363
    Width = 351
    Height = 47
    Align = alBottom
    TabOrder = 0
    object ButtonStart: TButton
      Left = 16
      Top = 10
      Width = 75
      Height = 25
      Caption = #21551#21160
      TabOrder = 0
    end
    object ButtonStop: TButton
      Left = 272
      Top = 10
      Width = 75
      Height = 25
      Caption = #20572#27490
      Enabled = False
      TabOrder = 1
    end
    object ComboBoxShowOption: TComboBox
      Left = 161
      Top = 14
      Width = 96
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 2
      Items.Strings = (
        ''
        'Esc'
        'F1'
        'F2'
        'F3'
        'F4'
        'F5'
        'F6'
        'F7'
        'F8'
        'F9'
        'F10'
        'F11'
        'F12'
        '0'
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7'
        '8'
        '9'
        '-'
        '='
        'Backspace'
        'Tab'
        'A'
        'B'
        'C'
        'D'
        'E'
        'F'
        'G'
        'H'
        'I'
        'J'
        'K'
        'L'
        'M'
        'N'
        'O'
        'P'
        'Q'
        'R'
        'S'
        'T'
        'U'
        'V'
        'W'
        'X'
        'Y'
        'Z'
        'CapsLock'
        'LeftShift'
        'LeftCtrl'
        'LeftAlt'
        'RightShift'
        'RightCtrl'
        'RightAlt'
        'Insert'
        'Delete'
        'Home'
        'End'
        'PageUp'
        'PageDown'
        #8593
        #8595
        #8592
        #8594
        '*'
        '~')
    end
  end
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 351
    Height = 363
    Align = alClient
    Caption = 'Panel'
    TabOrder = 1
    object EmbeddedWB1: TEmbeddedWB
      Left = 1
      Top = 1
      Width = 349
      Height = 344
      Align = alClient
      TabOrder = 0
      DownloadOptions = [DLCTL_DLIMAGES, DLCTL_VIDEOS, DLCTL_BGSOUNDS]
      UserInterfaceOptions = []
      PrintOptions.HTMLHeader.Strings = (
        '<HTML></HTML>')
      PrintOptions.Orientation = poPortrait
      ReplaceCaption = False
      HideBorders = False
      HideScrollBars = False
      DisableRightClickMenu = False
      EnableDDE = False
      fpExceptions = True
      ControlData = {
        4C000000021F0000810F00000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
    object ProgressBar: TProgressBar
      Left = 1
      Top = 345
      Width = 349
      Height = 17
      Align = alBottom
      TabOrder = 1
      Visible = False
    end
  end
end
