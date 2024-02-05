object frmUpgradeDownload: TfrmUpgradeDownload
  Left = 809
  Top = 283
  BorderStyle = bsDialog
  Caption = #33258#21160#26356#26032
  ClientHeight = 136
  ClientWidth = 399
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object ButtonStop: TButton
    Left = 152
    Top = 103
    Width = 105
    Height = 25
    Caption = #20572#27490
    TabOrder = 0
    OnClick = ButtonStopClick
  end
  object GroupBox1: TGroupBox
    Left = 6
    Top = 8
    Width = 393
    Height = 89
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 40
      Width = 54
      Height = 12
      Caption = #24403#21069#36827#24230':'
    end
    object Label2: TLabel
      Left = 8
      Top = 64
      Width = 54
      Height = 12
      Caption = #24635#20307#36827#24230':'
    end
    object Label3: TLabel
      Left = 8
      Top = 16
      Width = 54
      Height = 12
      Caption = #24403#21069#29366#24577':'
    end
    object LabelStatus: TLabel
      Left = 72
      Top = 16
      Width = 313
      Height = 12
      AutoSize = False
      Caption = #27491#22312#21462#24471#26356#26032#20449#24687'...'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object ProgressBarCurDownload: TProgressBar
      Left = 72
      Top = 40
      Width = 313
      Height = 17
      TabOrder = 0
    end
    object ProgressBarAll: TProgressBar
      Left = 72
      Top = 64
      Width = 313
      Height = 17
      TabOrder = 1
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = TimerTimer
    Left = 16
    Top = 96
  end
end
