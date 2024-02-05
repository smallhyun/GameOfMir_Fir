unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, HUtil32, ClientObject;

type
  TFrmMain = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditServerName: TEdit;
    EditGameAddr: TEdit;
    EditGamePort: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    EditAccount: TEdit;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    EditTotalChrCount: TEdit;
    Label5: TLabel;
    EditChrCount: TEdit;
    CheckBoxNewAccount: TCheckBox;
    ButtonStart: TButton;
    MemoLog: TMemo;
    TimerRun: TTimer;
    Timer1: TTimer;
    ButtonStop: TButton;
    procedure FormCreate(Sender: TObject);
    procedure TimerRunTimer(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure FreeClientObjectList;
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;
  g_ClientObjectList: TList;
  g_dwProcessTimeMin: Integer;
  g_dwProcessTimeMax: Integer;
  g_nPosition: Integer;

  g_sServerName, g_sGameIPaddr, g_sGamePort, g_sAccount: string;
  g_nGamePort: Integer;
  g_nChrCount, g_nTotalChrCount: Integer;
  g_boNewAccount: Boolean;
  g_nLoginIndex: Integer;
  g_dwLogonTick: LongWord;
implementation
uses Share;
{$R *.dfm}

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  ButtonStop.Enabled := False;
  g_ClientObjectList := TList.Create;
end;

procedure TFrmMain.FreeClientObjectList;
var
  I: Integer;
begin
  for I := 0 to g_ClientObjectList.Count - 1 do begin
    TObjClient(g_ClientObjectList.Items[I]).Free;
  end;
  g_ClientObjectList.Clear;
end;

procedure TFrmMain.TimerRunTimer(Sender: TObject);
var
  dwRunTick, dwCurrTick: LongWord;
  ObjClient: TObjClient;
  boProcessLimit: Boolean;
  I: Integer;
begin
  if g_nTotalChrCount > 0 then begin
    if ((GetTickCount - g_dwLogonTick) > 1000 * g_nChrCount) then begin
      g_dwLogonTick := GetTickCount;
      if g_nTotalChrCount >= g_nChrCount then begin
        Dec(g_nTotalChrCount, g_nChrCount);
      end else begin
        g_nTotalChrCount := 0;
      end;
      for I := 0 to g_nChrCount - 1 do begin
        ObjClient := TObjClient.Create;
        ObjClient.m_boNewAccount := g_boNewAccount;
        ObjClient.m_sLoginAccount := g_sAccount + IntToStr(g_nLoginIndex);
        ObjClient.m_sLoginPasswd := ObjClient.m_sLoginAccount;
        ObjClient.m_sCharName := ObjClient.m_sLoginAccount;
        ObjClient.m_sServerName := g_sServerName;
        ObjClient.ClientSocket.Address := g_sGameIPaddr;
        ObjClient.ClientSocket.Port := g_nGamePort;
        ObjClient.m_dwConnectTick := GetTickCount + (I + 1) * 3000;
        g_ClientObjectList.Add(ObjClient);
        Inc(g_nLoginIndex);
      end;
    end;
  end;
  dwRunTick := GetTickCount();
  boProcessLimit := False;
  dwCurrTick := GetTickCount();
  for I := g_nPosition to g_ClientObjectList.Count - 1 do begin
    TObjClient(g_ClientObjectList.Items[I]).Run;
    if ((GetTickCount - dwRunTick) > 20) or (not TimerRun.Enabled) then begin
      g_nPosition := I;
      boProcessLimit := True;
      Break;
    end;
  end;
  if not boProcessLimit then begin
    g_nPosition := 0;
  end;
  g_dwProcessTimeMin := GetTickCount - dwRunTick;
  if g_dwProcessTimeMin > g_dwProcessTimeMax then g_dwProcessTimeMax := g_dwProcessTimeMin;
end;

procedure TFrmMain.ButtonStartClick(Sender: TObject);
var
  ObjClient: TObjClient;
begin
  g_sAccount := Trim(EditAccount.Text);
  g_sServerName := Trim(EditServerName.Text);
  g_sGameIPaddr := Trim(EditGameAddr.Text);
  g_sGamePort := Trim(EditGamePort.Text);
  g_nGamePort := Str_ToInt(g_sGamePort, -1);

  g_nChrCount := Str_ToInt(Trim(EditChrCount.Text), 0);
  g_nTotalChrCount := Str_ToInt(Trim(EditTotalChrCount.Text), 0);
  g_boNewAccount := CheckBoxNewAccount.Checked;

  if g_sServerName = '' then begin
    Application.MessageBox('服务器名称，输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditServerName.SetFocus;
    Exit;
  end;

  if g_sGameIPaddr = '' then begin
    Application.MessageBox('服务器地址，输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditGameAddr.SetFocus;
    Exit;
  end;
  if (g_nGamePort < 0) or (g_nGamePort > 65535) then begin
    Application.MessageBox('服务器端口，输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditGamePort.SetFocus;
    Exit;
  end;

  if RadioButton1.Checked and (g_sAccount = '') then begin
    Application.MessageBox('游戏帐号，输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditAccount.SetFocus;
    Exit;
  end;

  if g_nChrCount <= 0 then begin
    Application.MessageBox('同时登录人数，输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditChrCount.SetFocus;
    Exit;
  end;

  if g_nTotalChrCount <= 0 then begin
    Application.MessageBox('登录总人数，输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditTotalChrCount.SetFocus;
    Exit;
  end;

  g_nChrCount := _MIN(g_nChrCount, g_nTotalChrCount);

  g_dwLogonTick := GetTickCount - 1000 * g_nChrCount;
  TimerRun.Enabled := False;
  g_nPosition := 0;
  g_nLoginIndex := 0;
  FreeClientObjectList;
  TimerRun.Enabled := True;

  ButtonStart.Enabled := False;
  ButtonStop.Enabled := True;
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
var
  I: Integer;
begin
  g_MainLogMsgList.Lock;
  try
    if MemoLog.Lines.Count > 500 then MemoLog.Clear;
    for I := 0 to g_MainLogMsgList.Count - 1 do begin
      MemoLog.Lines.Add(g_MainLogMsgList.Strings[I]);
    end;
    g_MainLogMsgList.Clear;
  finally
    g_MainLogMsgList.UnLock;
  end;
end;

procedure TFrmMain.ButtonStopClick(Sender: TObject);
begin
  TimerRun.Enabled := False;
  g_nPosition := 0;
  g_nLoginIndex := 0;
  FreeClientObjectList;

  ButtonStart.Enabled := True;
  ButtonStop.Enabled := False;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  FreeClientObjectList;
  g_ClientObjectList.Free;
end;

end.

