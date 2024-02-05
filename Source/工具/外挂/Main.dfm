object FrmMain: TFrmMain
  Left = 735
  Top = 174
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 408
  ClientWidth = 428
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Panel: TPanel
    Left = 0
    Top = 367
    Width = 428
    Height = 41
    Align = alBottom
    TabOrder = 0
    object Label1: TLabel
      Left = 96
      Top = 14
      Width = 54
      Height = 12
      Caption = #22806#25346#21628#20986':'
    end
    object ComboBox: TComboBox
      Left = 169
      Top = 10
      Width = 145
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 0
      OnChange = ComboBoxChange
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
    object ButtonStart: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = #21551#21160
      TabOrder = 1
      OnClick = ButtonStartClick
    end
    object ButtonStop: TButton
      Left = 344
      Top = 8
      Width = 75
      Height = 25
      Caption = #20572#27490
      TabOrder = 2
      OnClick = ButtonStopClick
    end
  end
  object ProgressBar: TProgressBar
    Left = 0
    Top = 350
    Width = 428
    Height = 17
    Align = alBottom
    TabOrder = 1
    Visible = False
  end
  object Web: TInternet_Server
    Left = 0
    Top = 0
    Width = 428
    Height = 350
    Align = alClient
    TabOrder = 2
    ControlData = {
      4C0000003C2C00002C2400000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
end
