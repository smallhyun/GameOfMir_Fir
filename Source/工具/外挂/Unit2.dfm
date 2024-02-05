object Form1: TForm1
  Left = 934
  Top = 246
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 427
  ClientWidth = 364
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
    Top = 380
    Width = 364
    Height = 47
    Align = alBottom
    TabOrder = 0
    object Label1: TLabel
      Left = 104
      Top = 19
      Width = 54
      Height = 12
      Caption = #22806#25346#21628#20986':'
    end
    object ButtonStart: TButton
      Left = 16
      Top = 10
      Width = 75
      Height = 25
      Caption = #21551#21160
      TabOrder = 0
      OnClick = ButtonStartClick
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
  object ProgressBar: TProgressBar
    Left = 0
    Top = 363
    Width = 364
    Height = 17
    Align = alBottom
    TabOrder = 1
    Visible = False
  end
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 364
    Height = 363
    Align = alClient
    Caption = 'Panel'
    TabOrder = 2
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 362
      Height = 361
      Align = alClient
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object IdHTTPDownLoad: TIdHTTP
    AuthRetries = 0
    AuthProxyRetries = 0
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentRangeInstanceLength = 0
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 56
    Top = 272
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    Left = 200
    Top = 272
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 232
    Top = 272
  end
  object TimerStart: TTimer
    Enabled = False
    Left = 264
    Top = 272
  end
end
