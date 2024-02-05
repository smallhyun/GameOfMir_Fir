object frmNPC: TfrmNPC
  Left = 507
  Top = 332
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'frmNPC'
  ClientHeight = 152
  ClientWidth = 403
  Color = clGray
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 136
    Top = 72
  end
end
