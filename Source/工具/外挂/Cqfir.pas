unit Cqfir;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JSocket, RzButton, RzPanel, RzStatus, StdCtrls, RzLstBox, ExtCtrls,
  RzSplit, Menus, ComCtrls, ImgList, Grobal2, SShare, CShare, HUtil32, EDcode, EncryptUnit, QQWry;
const
  cOsUnknown = -1;
  cOsWin95 = 0;
  cOsWin98 = 1;
  cOsWin98SE = 2;
  cOsWinME = 3;
  cOsWinNT = 4;
  cOsWin2000 = 5;
  cOsWXP = 6;
  cOsWin2003 = 7;
  cOsWVista = 8;
type
  TFrmMain = class(TForm)
    DecodeTime: TTimer;
    imlMain: TImageList;
    PopupMenu: TPopupMenu;
    PopupMenu_AddUser: TMenuItem;
    PopupMenu_DelUser: TMenuItem;
    PopupMenu_EditUser: TMenuItem;
    PopupMenu_Clear: TMenuItem;
    RzStatusBar1: TRzStatusBar;
    StatusPane1: TRzStatusPane;
    StatusPane2: TRzStatusPane;
    RzToolbar1: TRzToolbar;
    ButtonStart: TRzToolButton;
    ButtonStop: TRzToolButton;
    ServerSocket: TServerSocket;
    Timer: TTimer;
    TimerStart: TTimer;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    MemoLog: TMemo;
    ListBox: TListBox;
    ListBoxAddr: TListBox;
    PopupMenu1: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    CheckBoxShowLog: TCheckBox;
    StatusPane3: TRzStatusPane;
    procedure ServerSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure DecodeTimeTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerStartTimer(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TimerTimer(Sender: TObject);
    procedure ListBoxClick(Sender: TObject);
    procedure PopupMenu_AddUserClick(Sender: TObject);
    procedure PopupMenu_DelUserClick(Sender: TObject);
    procedure PopupMenu_EditUserClick(Sender: TObject);
    procedure PopupMenu_ClearClick(Sender: TObject);
    procedure MemoLogChange(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure ListBoxDblClick(Sender: TObject);
    procedure CheckBoxShowLogClick(Sender: TObject);
    procedure ListViewOnData(Sender: TObject; Item: TListItem);
  private
    { Private declarations }
    procedure SendSocket(Socket: TCustomWinSocket; DefMsg: TDefaultMessage; sMsg: string);
    procedure SendAddress(Session: pTSession);

    procedure SendUserLiense(Session: pTSession);
    procedure ProcessClientPacket(Session: pTSession);

    procedure ClientGetBadAddress(Session: pTSession; sData: string);
    procedure ClientGetUserLiense(Session: pTSession; sData: string);

    procedure StartService;
    procedure StopService;
    procedure RefListBox;
    procedure RefListBoxAddr;
    procedure InitializeSession();
    procedure ShowMainMessage();
    procedure RefUserIP(sConfig: string);
    procedure OnProgramException(Sender: TObject; E: Exception);
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;
  SelUserConfig: pTUserConfig;
  g_Today: TDate;
implementation

uses UserManage;

{$R *.dfm}

function SearchIPLocal(sIPaddr: string): string;
var
  IPRecordID: int64;
  IPData: TStringlist;
begin
  IPData := TStringlist.Create;
  try
    IPRecordID := g_QQWry.GetIPDataID(sIPaddr);
    g_QQWry.GetIPDataByIPRecordID(IPRecordID, IPData);
    if IPData.Count >= 3 then
      Result := Trim(IPData.Strings[2]);
    if IPData.Count >= 4 then
      Result := Result + Trim(IPData.Strings[3]);
  except
    Result := '未知';
  end;
  IPData.Free;
end;

function GetOSVersion(nVersion: Integer): string; //获取系统版本
begin
  case nVersion of
    cOsUnknown: Result := '未知';
    cOsWin95: Result := 'Windows 95';
    cOsWin98: Result := 'Windows 98';
    cOsWin98SE: Result := 'Windows 98 SE';
    cOsWinME: Result := 'Windows ME';
    cOsWinNT: Result := 'Windows NT';
    cOsWin2000: Result := 'Windows 2000';
    cOsWXP: Result := 'Windows XP';
    cOsWin2003: Result := 'Windows 2003';
    cOsWVista: Result := 'Windows Vista';
  end;
end;

function GetWebAddr(sAddr: string): string;
begin
  Result := sAddr;
  if Pos('://', sAddr) > 0 then begin //http    uppercase
    if (UpperCase(sAddr[1]) = 'H') and (UpperCase(sAddr[2]) = 'T') and (UpperCase(sAddr[3]) = 'T') and (UpperCase(sAddr[4]) = 'P') then begin
      sAddr := Copy(sAddr, 8, Length(sAddr));
    end else begin
      sAddr := Copy(sAddr, Pos('://', sAddr) + 1, Length(sAddr));
    end;
  end;
  if Pos('/', sAddr) > 0 then sAddr := Copy(sAddr, 1, Pos('/', sAddr) - 1);
  Result := sAddr;
end;

function GetWebSubAddr(sAddr: string): string;
begin
  Result := sAddr;
  sAddr := GetWebAddr(sAddr);
  if Pos('.', sAddr) > 0 then sAddr := Copy(sAddr, Pos('.', sAddr) + 1, Length(sAddr));
  Result := sAddr;
end;

procedure TfrmMain.RefListBox;
var
  I: Integer;
  Index: Integer;
begin
  SelUserConfig := nil;
  Index := ListBox.ItemIndex;
  ListBox.Items.Clear;
  ListBox.Items.AddStrings(g_UserSession.m_ConfigList);
  if (Index >= 0) and (Index < ListBox.Items.Count) then begin
    ListBox.ItemIndex := Index;
  end;
end;

procedure TfrmMain.RefListBoxAddr;
var
  I: Integer;
  Index: Integer;
  sAddress: string;
begin
  g_sAddress := '';
  g_nAddressHash := 0;
  Index := ListBox.ItemIndex;
  ListBoxAddr.Items.Clear;
  try
    ListBoxAddr.Items.LoadFromFile('黑名单.txt');
  except
    ListBoxAddr.Items.Add('http://www.haosf.com');
    ListBoxAddr.Items.Add('http://www.922gg.com');
    ListBoxAddr.Items.Add('http://www.sf400.com');
    ListBoxAddr.Items.SaveToFile('黑名单.txt');
  end;

  if (Index >= 0) and (Index < ListBoxAddr.Items.Count) then begin
    ListBoxAddr.ItemIndex := Index;
  end;

  for I := 0 to ListBoxAddr.Items.Count - 1 do begin
    sAddress := ListBoxAddr.Items.Strings[I];
    if (sAddress = '') or (sAddress[1] = ';') then Continue;
    g_sAddress := g_sAddress + EncryptString(sAddress) + '|';
  end;

  g_nAddressHash := HashPJW(g_sAddress);
end;

procedure TFrmMain.ButtonStartClick(Sender: TObject);
begin
  StartService;
end;

procedure TFrmMain.ButtonStopClick(Sender: TObject);
begin
  StopService;
end;

procedure TFrmMain.CheckBoxShowLogClick(Sender: TObject);
begin
  g_boShowLog := CheckBoxShowLog.Checked;
end;

procedure TFrmMain.DecodeTimeTimer(Sender: TObject);
var
  I: Integer;
  Session: pTSession;
begin
  try
    ShowMainMessage();
  except
    MainOutMessage('ShowMainMessage');
  end;

  for I := Low(g_SessionArray) to High(g_SessionArray) do begin
    Session := @g_SessionArray[I];
    if (Session.Socket <> nil) then begin
      if (GetTickCount - Session.dwStartTick > 1000 * 20) {or (Session.CheckStep = c_CheckOver)} then begin
        try
          Session.Socket.Close;
        except
          MainOutMessage('Session.Socket.Close');
        end;
        Continue;
      end;
      if (Session.sReviceMsg <> '') then begin
        try
          ProcessClientPacket(Session);
          Continue;
        except
          MainOutMessage('ProcessClientPacket');
        end;
      end;
    {  if (Session.CheckStep = c_SendLicense) and (GetTickCount - Session.dwSendUserLienseTick > 100) then begin
        SendUserLienseNew(Session);
      end;  }
      {if (Session.Status = s_Finished) and (GetTickCount - Session.dwSendLicTick > 10 * 1000) then begin
        Session.Socket.Close;
        Session.Status := s_NoUse;
      end;}
    end;
  end;
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Application.MessageBox('是否确认退出服务器？',
    '提示信息',
    MB_YESNO + MB_ICONQUESTION) = IDYES then begin
    StopService;
    g_UserSession.Free;
    //g_MemoryStream.Free;
  end else CanClose := False;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  Randomize;
  g_Today := Date;
  Application.OnException := OnProgramException;
  PageControl.ActivePageIndex := 0;
  //TabSheet2.TabVisible := False;
  g_UserSession := TUserSession.Create('.\UserConfig.txt');
  //g_MemoryStream:= TMemoryStream.Create;
  TimerStart.Enabled := True;
end;

procedure TfrmMain.InitializeSession();
var
  I: Integer;
begin
  for I := 0 to Length(g_SessionArray) - 1 do begin
    if g_SessionArray[I].Socket <> nil then g_SessionArray[I].Socket.Close;
    g_SessionArray[I].Socket := nil;
    g_SessionArray[I].sReviceMsg := '';
    g_SessionArray[I].nRemoteAddr := 0;
    SafeFillChar(g_SessionArray[I].ClientInfo, SizeOf(TClientInfo), #0);
    g_SessionArray[I].CheckStep := c_None;
  end;
end;

procedure TFrmMain.ListBoxClick(Sender: TObject);
var
  Index: Integer;
  NewColumn: TListColumn;
begin
  Index := ListBox.ItemIndex;
  if (Index >= 0) and (Index < ListBox.Items.Count) then begin
    PopupMenu_DelUser.Enabled := True;
    PopupMenu_EditUser.Enabled := True;
    PopupMenu_Clear.Enabled := True;
    SelUserConfig := pTUserConfig(ListBox.Items.Objects[Index]);
    if SelUserConfig.TabSheet = nil then begin
      SelUserConfig.TabSheet := TTabSheet.Create(PageControl);
      SelUserConfig.TabSheet.PageControl := PageControl;
      SelUserConfig.TabSheet.Caption := SelUserConfig.ServerConfig.sUserLiense;
    end;
    if SelUserConfig.ListView = nil then begin
      SelUserConfig.ListView := TListViewA.Create(SelUserConfig.TabSheet);
      SelUserConfig.ListView.UserConfig := SelUserConfig;
      SelUserConfig.ListView.Parent := SelUserConfig.TabSheet;
      SelUserConfig.ListView.Align := alClient;
      SelUserConfig.ListView.RowSelect := True;
      SelUserConfig.ListView.ViewStyle := vsReport;
      SelUserConfig.ListView.GridLines := True;
      SelUserConfig.ListView.OwnerData := True;
      SelUserConfig.ListView.OnData := ListViewOnData;

      NewColumn := SelUserConfig.ListView.Columns.Add;
      NewColumn.Width := 50;
      NewColumn.Caption := '序号';

      NewColumn := SelUserConfig.ListView.Columns.Add;
      NewColumn.Width := 90;
      NewColumn.Caption := 'IP地址';

      NewColumn := SelUserConfig.ListView.Columns.Add;
      NewColumn.Width := 120;
      NewColumn.Caption := '所在地区';

      NewColumn := SelUserConfig.ListView.Columns.Add;
      NewColumn.Width := 90;
      NewColumn.Caption := '用户系统';

      NewColumn := SelUserConfig.ListView.Columns.Add;
      NewColumn.Width := 65;
      NewColumn.Caption := '外挂版本';

      NewColumn := SelUserConfig.ListView.Columns.Add;
      NewColumn.Width := 120;
      NewColumn.Caption := '连接时间';

      NewColumn := SelUserConfig.ListView.Columns.Add;
      NewColumn.Width := 65;
      NewColumn.Caption := '连接次数';

      NewColumn := SelUserConfig.ListView.Columns.Add;
      NewColumn.Width := 180;
      NewColumn.Caption := '状态';
    end;
    PageControl.ActivePage := SelUserConfig.TabSheet;
  end else begin
    SelUserConfig := nil;
    PopupMenu_DelUser.Enabled := False;
    PopupMenu_EditUser.Enabled := False;
    PopupMenu_Clear.Enabled := False;
  end;
end;

procedure TFrmMain.ListBoxDblClick(Sender: TObject);
var
  Index: Integer;
  NewColumn: TListColumn;
begin
  Index := ListBox.ItemIndex;
  if (Index >= 0) and (Index < ListBox.Items.Count) then begin
    PopupMenu_DelUser.Enabled := True;
    PopupMenu_EditUser.Enabled := True;
    PopupMenu_Clear.Enabled := True;
    SelUserConfig := pTUserConfig(ListBox.Items.Objects[Index]);
    if SelUserConfig.TabSheet = nil then begin
      SelUserConfig.TabSheet := TTabSheet.Create(PageControl);
      SelUserConfig.TabSheet.PageControl := PageControl;
      SelUserConfig.TabSheet.Caption := SelUserConfig.ServerConfig.sUserLiense;
    end;
    if SelUserConfig.ListView = nil then begin
      SelUserConfig.ListView := TListViewA.Create(SelUserConfig.TabSheet);
      SelUserConfig.ListView.UserConfig := SelUserConfig;
      SelUserConfig.ListView.Parent := SelUserConfig.TabSheet;
      SelUserConfig.ListView.Align := alClient;
      SelUserConfig.ListView.RowSelect := True;
      SelUserConfig.ListView.ViewStyle := vsReport;
      SelUserConfig.ListView.GridLines := True;
      SelUserConfig.ListView.OwnerData := True;
      SelUserConfig.ListView.OnData := ListViewOnData;
      NewColumn := SelUserConfig.ListView.Columns.Add;
      NewColumn.Width := 50;
      NewColumn.Caption := '序号';

      NewColumn := SelUserConfig.ListView.Columns.Add;
      NewColumn.Width := 90;
      NewColumn.Caption := 'IP地址';

      NewColumn := SelUserConfig.ListView.Columns.Add;
      NewColumn.Width := 120;
      NewColumn.Caption := '所在地区';

      NewColumn := SelUserConfig.ListView.Columns.Add;
      NewColumn.Width := 90;
      NewColumn.Caption := '用户系统';

      NewColumn := SelUserConfig.ListView.Columns.Add;
      NewColumn.Width := 65;
      NewColumn.Caption := '外挂版本';

      NewColumn := SelUserConfig.ListView.Columns.Add;
      NewColumn.Width := 120;
      NewColumn.Caption := '连接时间';

      NewColumn := SelUserConfig.ListView.Columns.Add;
      NewColumn.Width := 65;
      NewColumn.Caption := '连接次数';

      NewColumn := SelUserConfig.ListView.Columns.Add;
      NewColumn.Width := 180;
      NewColumn.Caption := '状态';
    end;
    //PageControl.ActivePage := SelUserConfig.TabSheet;
    RefUserIP(SelUserConfig.ServerConfig.sUserLiense);
  end else begin
    SelUserConfig := nil;
    PopupMenu_DelUser.Enabled := False;
    PopupMenu_EditUser.Enabled := False;
    PopupMenu_Clear.Enabled := False;
  end;
end;

procedure TFrmMain.MemoLogChange(Sender: TObject);
begin
  if MemoLog.Lines.Count > 200 then MemoLog.Clear;
end;

procedure TFrmMain.MenuItem1Click(Sender: TObject);
var
  I: Integer;
  sAddress: string;
begin
  if not InputQuery('增加黑名单', '输入网址:', sAddress) then Exit;
  for I := 0 to ListBoxAddr.Items.Count - 1 do begin
    if sAddress = ListBoxAddr.Items.Strings[I] then begin
      Application.MessageBox('该地址已经存在 ！！！', '提示信息', MB_ICONQUESTION);
      Exit;
    end;
  end;
  ListBoxAddr.Items.Add(sAddress);
  try
    ListBoxAddr.Items.SaveToFile('黑名单.txt');
  except

  end;

  g_sAddress := '';
  g_nAddressHash := 0;
  for I := 0 to ListBoxAddr.Items.Count - 1 do begin
    sAddress := ListBoxAddr.Items.Strings[I];
    if (sAddress = '') or (sAddress[1] = ';') then Continue;
    g_sAddress := g_sAddress + EncryptString(sAddress) + '|';
  end;
  g_nAddressHash := HashPJW(g_sAddress);
end;

procedure TFrmMain.MenuItem2Click(Sender: TObject);
var
  I: Integer;
  sAddress: string;
begin
  if (ListBoxAddr.ItemIndex >= 0) and (ListBoxAddr.ItemIndex < ListBoxAddr.Count) then begin

    if Application.MessageBox(PChar('是否确认删除 ' + ListBoxAddr.Items.Strings[ListBoxAddr.ItemIndex] + ' ？'),
      '提示信息',
      MB_YESNO + MB_ICONQUESTION) = IDYES then begin

      ListBoxAddr.DeleteSelected;
      try
        ListBoxAddr.Items.SaveToFile('黑名单.txt');
      except

      end;
      g_sAddress := '';
      g_nAddressHash := 0;
      for I := 0 to ListBoxAddr.Items.Count - 1 do begin
        sAddress := ListBoxAddr.Items.Strings[I];
        if (sAddress = '') or (sAddress[1] = ';') then Continue;
        g_sAddress := g_sAddress + EncryptString(sAddress) + '|';
      end;
      g_nAddressHash := HashPJW(g_sAddress);
    end;
  end;
end;

procedure TFrmMain.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  I: Integer;
  Session: pTSession;

  UserConfig: pTUserConfig;
  SessionP: pTSession;
  boAllowIP: Boolean;
begin
  Socket.nIndex := -1;
  {if not g_boNoCheck then begin
    boAllowIP:=False;
    for I := 0 to g_IPList.Count - 1 do begin
      if Socket.RemoteAddress = g_IPList.Strings[I] then begin
        boAllowIP:=True;
        break;
      end;
    end;
    if not boAllowIP then begin
      Socket.Close;
      exit;
    end;
  end;}

  for I := Low(g_SessionArray) to High(g_SessionArray) do begin
    Session := @g_SessionArray[I];
    if Session.Socket = nil then begin
      Session.Socket := Socket;
      Session.sRemoteAddress := Socket.RemoteAddress;
      Session.CheckStep := c_None;
      Session.SessionStatus := s_NoUse;
      SafeFillChar(Session.ClientInfo, SizeOf(TClientInfo), #0);
      Session.sReviceMsg := '';
      Session.dwStartTick := GetTickCount;
      Session.dwClientTick := 0;
      Session.dwServerTick := 0;
      Session.dwSendUserLienseTick := GetTickCount;
      Session.dDateTime := Now;
      Session.nCount := 1;
      Socket.nIndex := I;
      if g_boShowLog then MainOutMessage('[' + Session.sRemoteAddress + '] 连接');
      Break;
    end;
  end;
  if Socket.nIndex < 0 then begin
    MainOutMessage('Kick ' + Socket.RemoteAddress);
    Socket.Close;
  end;
end;

procedure TFrmMain.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  Session: pTSession;
begin
  if (Socket.nIndex >= 0) and (Socket.nIndex < MAXSESSION) then begin
    Session := @g_SessionArray[Socket.nIndex];
    Session.Socket := nil;
    Session.sReviceMsg := '';
    Session.nRemoteAddr := 0;
    Session.dwStartTick := 0;
    if g_boShowLog then MainOutMessage('[' + Session.sRemoteAddress + '] 断开');
  end;
end;

procedure TFrmMain.ServerSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmMain.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  Session: pTSession;
begin
  if (Socket.nIndex >= 0) and (Socket.nIndex < MAXSESSION) then begin
    Session := @g_SessionArray[Socket.nIndex];
    Session.sReviceMsg := Session.sReviceMsg + Socket.ReceiveText;
  end;

//  MemoLog.Lines.Add(Session.sReviceMsg)
end;

procedure TfrmMain.ShowMainMessage();
var
  I: Integer;
begin
  LogMsgList.Clear;
  MainLogMsgList.Lock;
  try
    LogMsgList.AddStrings(MainLogMsgList);
    MainLogMsgList.Clear;
  finally
    MainLogMsgList.UnLock;
  end;
  for I := 0 to LogMsgList.Count - 1 do begin
    MemoLog.Lines.Add(LogMsgList.Strings[I]);
  end;
  LogMsgList.Clear;
end;

procedure TFrmMain.PopupMenu_AddUserClick(Sender: TObject);
var
  UserConfig: pTUserConfig;
  ServerConfig: TServerConfig;
  sUserLiense: string;
  sConfigAddr: string;
  CheckNoticeUrl: Boolean;
  NeedDecrypt: Boolean;
  CheckHash: Boolean;
  HashValue: Integer;
  DownFail: Boolean;
  WriteHosts: Boolean;
  HostsAddress: string;
  WriteUrlEntry: Boolean;

begin
  frmUserManage.Caption := '增加用户';
  frmUserManage.ButtonOK.ModalResult := mrNone;

  frmUserManage.ShowModal;
  if frmUserManage.ButtonOK.ModalResult = mrOk then begin
    //Showmessage('增加用户');
    with frmUserManage do begin
      ServerConfig.sUserLiense := Trim(EditUserLiense.Text);

      ServerConfig.boAllowUpData := RzCheckBoxAllowUpData.Checked;
      ServerConfig.boCompulsiveUpdata := RzRadioButtonCompulsiveUpdata.Checked;
      //ServerConfig.boCompulsiveUpdata := not RzRadioButtonHintUpData.Checked;

      ServerConfig.sMD5 := Trim(RzEditMD5.Text);
      ServerConfig.sUpdataAddr := Trim(RzEditUpdataAddr.Text);

      ServerConfig.sHomePage := Trim(RzEditHomePage.Text);
      ServerConfig.sOpenPage1 := Trim(RzEditOpenPage1.Text);
      ServerConfig.sOpenPage2 := Trim(RzEditOpenPage2.Text);
      ServerConfig.sClosePage1 := Trim(RzEditClosePage1.Text);
      ServerConfig.sClosePage2 := Trim(RzEditClosePage2.Text);
      ServerConfig.sSayMessage1 := Trim(RzEditSayMessage1.Text);
      ServerConfig.sSayMessage2 := Trim(RzEditSayMessage2.Text);
      ServerConfig.nSayMsgTime := RzSpinEditSayMessageTime.IntValue;

      ServerConfig.boOpenPage1 := RzCheckBoxOpenPage1.Checked;
      ServerConfig.boOpenPage2 := RzCheckBoxOpenPage2.Checked;
      ServerConfig.boClosePage1 := RzCheckBoxClosePage1.Checked;
      ServerConfig.boClosePage2 := RzCheckBoxClosePage2.Checked;

      ServerConfig.boCheckNoticeUrl := CheckBoxCheckNoticeUrl.Checked;
      ServerConfig.boWriteHosts := CheckBoxWriteHosts.Checked;
      ServerConfig.nHostsAddress := MakeIPToInt(Trim(EditHostsAddress.Text));
      ServerConfig.boWriteUrlEntry := CheckBoxWriteUrlEntry.Checked;

      ServerConfig.boCheckOpenPage := CheckBoxCheckOpenPage.Checked;
      ServerConfig.boCheckConnectPage := CheckBoxCheckConnectPage.Checked;

      ServerConfig.boCheckParent := CheckBoxCheckParent.Checked;

      ServerConfig.boCheck1 := CheckBox1.Checked;
      ServerConfig.boCheck2 := CheckBox2.Checked;
      ServerConfig.boCheck3 := CheckBox3.Checked;
      ServerConfig.boCheck4 := CheckBox4.Checked;
      ServerConfig.boCheck5 := CheckBox5.Checked;
      ServerConfig.boCheck6 := CheckBox6.Checked;
      ServerConfig.boCheck7 := CheckBox7.Checked;
      ServerConfig.boCheck8 := CheckBox8.Checked;
      ServerConfig.boCheck9 := CheckBox9.Checked;
      ServerConfig.boCheck10 := CheckBox10.Checked;
    end;

    if ServerConfig.sUserLiense = '' then begin
      Application.MessageBox('请输入官方网站地址 ！！！', '提示信息', MB_ICONQUESTION);
      Exit;
    end;

    if g_UserSession.Find(ServerConfig.sUserLiense) then begin
      Application.MessageBox('该地址已经存在 ！！！', '提示信息', MB_ICONQUESTION);
      Exit;
    end;
    if g_UserSession.Add(@ServerConfig) then Application.MessageBox('增加成功 ！！！', '提示信息', MB_ICONQUESTION)
    else Application.MessageBox('增加失败 ！！！', '提示信息', MB_ICONQUESTION);
    RefListBox;
  end;
end;

procedure TFrmMain.PopupMenu_ClearClick(Sender: TObject);
begin
  if SelUserConfig <> nil then begin
    SelUserConfig.SessionList.Free;
    SelUserConfig.SessionList := TUserList.Create;
  end;
end;

procedure TFrmMain.PopupMenu_DelUserClick(Sender: TObject);
begin
  if (SelUserConfig <> nil) then begin
    if Application.MessageBox(PChar('是否确认要删除' + string(SelUserConfig.ServerConfig.sUserLiense) + '？'),
      '提示信息',
      MB_YESNO + MB_ICONQUESTION) <> IDYES then Exit;
    g_UserSession.Delete(SelUserConfig.ServerConfig.sUserLiense);
    g_UserSession.SaveToFile(g_UserSession.Name);
    RefListBox;
  end;
end;

procedure TFrmMain.PopupMenu_EditUserClick(Sender: TObject);
var
  UserConfig: pTUserConfig;
  sUserLiense: string;
  sConfigAddr: string;
  CheckNoticeUrl: Boolean;
  NeedDecrypt: Boolean;
  CheckHash: Boolean;
  HashValue: Integer;
  DownFail: Boolean;
  WriteHosts: Boolean;
  HostsAddress: string;

  Index: Integer;
begin
  frmUserManage.Caption := '编辑用户';
  if (SelUserConfig <> nil) then begin
    with frmUserManage do begin
      EditUserLiense.Text := SelUserConfig.ServerConfig.sUserLiense;

      RzCheckBoxAllowUpData.Checked := SelUserConfig.ServerConfig.boAllowUpData;
      RzRadioButtonCompulsiveUpdata.Checked := SelUserConfig.ServerConfig.boCompulsiveUpdata;
      RzRadioButtonHintUpData.Checked := not SelUserConfig.ServerConfig.boCompulsiveUpdata;

      RzEditMD5.Text := SelUserConfig.ServerConfig.sMD5;

      RzEditUpdataAddr.Text := SelUserConfig.ServerConfig.sUpdataAddr;

      RzEditHomePage.Text := SelUserConfig.ServerConfig.sHomePage;
      RzEditOpenPage1.Text := SelUserConfig.ServerConfig.sOpenPage1;
      RzEditOpenPage2.Text := SelUserConfig.ServerConfig.sOpenPage2;
      RzEditClosePage1.Text := SelUserConfig.ServerConfig.sClosePage1;
      RzEditClosePage2.Text := SelUserConfig.ServerConfig.sClosePage2;
      RzEditSayMessage1.Text := SelUserConfig.ServerConfig.sSayMessage1;
      RzEditSayMessage2.Text := SelUserConfig.ServerConfig.sSayMessage2;
      RzSpinEditSayMessageTime.IntValue := SelUserConfig.ServerConfig.nSayMsgTime;

      RzCheckBoxOpenPage1.Checked := SelUserConfig.ServerConfig.boOpenPage1;
      RzCheckBoxOpenPage2.Checked := SelUserConfig.ServerConfig.boOpenPage2;
      RzCheckBoxClosePage1.Checked := SelUserConfig.ServerConfig.boClosePage1;
      RzCheckBoxClosePage2.Checked := SelUserConfig.ServerConfig.boClosePage2;

      CheckBoxCheckNoticeUrl.Checked := SelUserConfig.ServerConfig.boCheckNoticeUrl;
      CheckBoxWriteHosts.Checked := SelUserConfig.ServerConfig.boWriteHosts;
      EditHostsAddress.Text := MakeIntToIP(SelUserConfig.ServerConfig.nHostsAddress);
      CheckBoxWriteUrlEntry.Checked := SelUserConfig.ServerConfig.boWriteUrlEntry;

      CheckBoxCheckOpenPage.Checked := SelUserConfig.ServerConfig.boCheckOpenPage;
      CheckBoxCheckConnectPage.Checked := SelUserConfig.ServerConfig.boCheckConnectPage;
      CheckBoxCheckParent.Checked := SelUserConfig.ServerConfig.boCheckParent;

      CheckBox1.Checked := SelUserConfig.ServerConfig.boCheck1;
      CheckBox2.Checked := SelUserConfig.ServerConfig.boCheck2;
      CheckBox3.Checked := SelUserConfig.ServerConfig.boCheck3;
      CheckBox4.Checked := SelUserConfig.ServerConfig.boCheck4;
      CheckBox5.Checked := SelUserConfig.ServerConfig.boCheck5;
      CheckBox6.Checked := SelUserConfig.ServerConfig.boCheck6;
      CheckBox7.Checked := SelUserConfig.ServerConfig.boCheck7;
      CheckBox8.Checked := SelUserConfig.ServerConfig.boCheck8;
      CheckBox9.Checked := SelUserConfig.ServerConfig.boCheck9;
      CheckBox10.Checked := SelUserConfig.ServerConfig.boCheck10;
    end;

    if (frmUserManage.ShowModal = 2) then begin
      sUserLiense := Trim(frmUserManage.EditUserLiense.Text);

      if sUserLiense = '' then begin
        Application.MessageBox('请输入官方网站地址 ！！！', '提示信息', MB_ICONQUESTION);
        Exit;
      end;

      with frmUserManage do begin
        SelUserConfig.ServerConfig.sUserLiense := Trim(EditUserLiense.Text);

        SelUserConfig.ServerConfig.boAllowUpData := RzCheckBoxAllowUpData.Checked;
        SelUserConfig.ServerConfig.boCompulsiveUpdata := RzRadioButtonCompulsiveUpdata.Checked;
        SelUserConfig.ServerConfig.sMD5 := Trim(RzEditMD5.Text);
        SelUserConfig.ServerConfig.sUpdataAddr := Trim(RzEditUpdataAddr.Text);

        SelUserConfig.ServerConfig.sHomePage := Trim(RzEditHomePage.Text);
        SelUserConfig.ServerConfig.sOpenPage1 := Trim(RzEditOpenPage1.Text);
        SelUserConfig.ServerConfig.sOpenPage2 := Trim(RzEditOpenPage2.Text);
        SelUserConfig.ServerConfig.sClosePage1 := Trim(RzEditClosePage1.Text);
        SelUserConfig.ServerConfig.sClosePage2 := Trim(RzEditClosePage2.Text);
        SelUserConfig.ServerConfig.sSayMessage1 := Trim(RzEditSayMessage1.Text);
        SelUserConfig.ServerConfig.sSayMessage2 := Trim(RzEditSayMessage2.Text);
        SelUserConfig.ServerConfig.nSayMsgTime := RzSpinEditSayMessageTime.IntValue;

        SelUserConfig.ServerConfig.boOpenPage1 := RzCheckBoxOpenPage1.Checked;
        SelUserConfig.ServerConfig.boOpenPage2 := RzCheckBoxOpenPage2.Checked;
        SelUserConfig.ServerConfig.boClosePage1 := RzCheckBoxClosePage1.Checked;
        SelUserConfig.ServerConfig.boClosePage2 := RzCheckBoxClosePage2.Checked;

        SelUserConfig.ServerConfig.boCheckNoticeUrl := CheckBoxCheckNoticeUrl.Checked;
        SelUserConfig.ServerConfig.boWriteHosts := CheckBoxWriteHosts.Checked;
        SelUserConfig.ServerConfig.nHostsAddress := MakeIPToInt(Trim(EditHostsAddress.Text));
        SelUserConfig.ServerConfig.boWriteUrlEntry := CheckBoxWriteUrlEntry.Checked;
        SelUserConfig.ServerConfig.boCheckOpenPage := CheckBoxCheckOpenPage.Checked;
        SelUserConfig.ServerConfig.boCheckConnectPage := CheckBoxCheckConnectPage.Checked;
        SelUserConfig.ServerConfig.boCheckParent := CheckBoxCheckParent.Checked;

        SelUserConfig.ServerConfig.boCheck1 := CheckBox1.Checked;
        SelUserConfig.ServerConfig.boCheck2 := CheckBox2.Checked;
        SelUserConfig.ServerConfig.boCheck3 := CheckBox3.Checked;
        SelUserConfig.ServerConfig.boCheck4 := CheckBox4.Checked;
        SelUserConfig.ServerConfig.boCheck5 := CheckBox5.Checked;
        SelUserConfig.ServerConfig.boCheck6 := CheckBox6.Checked;
        SelUserConfig.ServerConfig.boCheck7 := CheckBox7.Checked;
        SelUserConfig.ServerConfig.boCheck8 := CheckBox8.Checked;
        SelUserConfig.ServerConfig.boCheck9 := CheckBox9.Checked;
        SelUserConfig.ServerConfig.boCheck10 := CheckBox10.Checked;
      end;
      {
      New(UserConfig);
      UserConfig^ := SelUserConfig^;
      Index := GetUserConfigIndex(SelUserConfig.sUserLiense);
      DelConfig(SelUserConfig.sUserLiense);
      if GetUserConfig(sUserLiense) then begin
        SelUserConfig^ := UserConfig^;
        g_ConfigList.InsertObject(Index, UserConfig.sUserLiense, TObject(UserConfig));
        Application.MessageBox('该地址已经存在 ！！！', '提示信息', MB_ICONQUESTION);
        Exit;
      end;
      UserConfig.sUserLiense := sUserLiense;
      UserConfig.sConfigAddr := sConfigAddr;
      g_ConfigList.InsertObject(Index, UserConfig.sUserLiense, TObject(UserConfig));
      }


      g_UserSession.SaveToFile(g_UserSession.Name);
      RefListBox;
    end;
  end;
end;

procedure TfrmMain.ClientGetBadAddress(Session: pTSession; sData: string);
begin
  if (sData <> '') and (Session.CheckStep = c_None) then begin
    DecryptBuffer(sData, @(Session.ClientInfo), SizeOf(TClientInfo));
    SendAddress(Session);
  end else Session.CheckStep := c_CheckOver;
end;

procedure TfrmMain.ClientGetUserLiense(Session: pTSession; sData: string);
begin
  if (sData <> '') and (Session.CheckStep = c_SendAddress) then begin
    DecryptBuffer(sData, @(Session.ClientInfo), SizeOf(TClientInfo));
    SendUserLiense(Session);
  end else Session.CheckStep := c_CheckOver;
end;

procedure TfrmMain.ProcessClientPacket(Session: pTSession);
var
  sData: string;
  sDefMsg: string;
  sDataMsg: string;
  sBlockMsg: string;
  DefMsg: TDefaultMessage;
  sProcessMsg: string;
  nDataLen: Integer;
begin
  sProcessMsg := Session.sReviceMsg;
  Session.sReviceMsg := '';
  while (True) do begin
    if (Pos('!', sProcessMsg) <= 0) or (Session.Socket = nil) then Break;
    sProcessMsg := ArrestStringEx(sProcessMsg, '#', '!', sData);
    nDataLen := Length(sData);
    if (sData <> '') and (nDataLen >= DEFBLOCKSIZE + 12) then begin
      sDefMsg := Copy(sData, 1, DEFBLOCKSIZE + 12);
      sDataMsg := Copy(sData, DEFBLOCKSIZE + 12 + 1, Length(sData) - (DEFBLOCKSIZE + 12));
      //DefMsg := DecodeMessage(sDefMsg);
      DecryptBuffer(sDefMsg, @DefMsg, SizeOf(TDefaultMessage));
      case DefMsg.Ident of
        CM_GETBADADDRESS: ClientGetBadAddress(Session, sDataMsg);
        CM_GETCLIENTCONFIG: ClientGetUserLiense(Session, sDataMsg);
      else begin
          if (Session.Socket <> nil) then begin
            try
              Session.Socket.Close;
            except
              MainOutMessage('Session.Socket.Close::[2]');
            end;
          end;
        end;
      end;
    end;
  end;
  if sProcessMsg <> '' then
    Session.sReviceMsg := sProcessMsg;
end;

procedure TfrmMain.SendSocket(Socket: TCustomWinSocket; DefMsg: TDefaultMessage; sMsg: string);
var
  sSendMsg: string;
begin
  sSendMsg := '#' + EncryptBuffer(@DefMsg, SizeOf(TDefaultMessage)) + sMsg + '!';
  if (Socket <> nil) and Socket.Connected then
    Socket.SendText(sSendMsg);
end;

procedure TfrmMain.SendAddress(Session: pTSession);
var
  DefMsg: TDefaultMessage;
  ServerInfo: TServerInfo;
  UserConfig: pTUserConfig;
  SessionP: pTSession;
  sConfig: string;
  Buff: PChar;
begin
  Session.CheckStep := c_SendLicense;
  Session.dwStartTick := GetTickCount;

  sConfig := DecryptString(Session.ClientInfo.sConfig);
  if (HashPJW(Session.ClientInfo.sConfig) = Session.ClientInfo.nCode) and
    g_UserSession.Find(sConfig) and
    (Session.ClientInfo.Address = IPADDRESS) then begin
    Session.CheckStep := c_SendAddress;
    Session.SessionStatus := s_SendAddress;

    DefMsg.Ident := SM_BADADDRESS;
    DefMsg.Recog := 0;
    DefMsg.Param := 0;
    DefMsg.Tag := 0;
    DefMsg.Series := 0;
    SendSocket(Session.Socket, DefMsg, g_sAddress);
    if g_boShowLog then MainOutMessage('[' + Session.sRemoteAddress + '] 黑名单发送成功...');
  end;
end;

procedure TfrmMain.SendUserLiense(Session: pTSession);
var
  DefMsg: TDefaultMessage;
  ServerInfo: TServerInfo;
  UserConfig: pTUserConfig;
  SessionP: pTSession;
  sConfig: string;
  Buff: PChar;
begin
  Session.CheckStep := c_CheckOver;
  {
  MainOutMessage('Session.ClientInfo.Random1:' + IntToStr(Session.ClientInfo.Random1));
  MainOutMessage('Session.ClientInfo.Random2:' + IntToStr(Session.ClientInfo.Random2));
  MainOutMessage('Session.ClientInfo.nCode:' + IntToStr(Session.ClientInfo.nCode));
  MainOutMessage('GetUniCode(Session.ClientInfo.sConfig):' + IntToStr(GetUniCode(Session.ClientInfo.sConfig)));
  MainOutMessage('Session.ClientInfo.sConfig:' + Session.ClientInfo.sConfig);
  }
  sConfig := DecryptString(Session.ClientInfo.sConfig);
  if (HashPJW(Session.ClientInfo.sConfig) = Session.ClientInfo.nCode) and
    g_UserSession.Find(sConfig) and
    (Session.ClientInfo.Address = IPADDRESS) then begin
    Session.CheckStep := c_SendLicense;
    Session.SessionStatus := s_SendLic;


    UserConfig := g_UserSession.Get(sConfig);
    if UserConfig <> nil then begin
      SessionP := UserConfig.SessionList.Get(Session.sRemoteAddress);
      if SessionP = nil then begin
        New(SessionP);
        SessionP^ := Session^;
        UserConfig.SessionList.Add(SessionP);
      end else begin
        SessionP^ := Session^;
        Inc(SessionP.nCount);
      end;
    end;
    if UserConfig <> nil then begin
      DefMsg.Ident := SM_CLIENTCONFIG;
      DefMsg.Recog := 0;
      DefMsg.Param := 1;
      DefMsg.Tag := 0;
      DefMsg.Series := 0;
      ServerInfo.Address := IPADDRESS; //MakeIPToInt('127.0.0.1');
      ServerInfo.SocketHandle := Session.ClientInfo.nSocketHandle;
      ServerInfo.AddressHash := g_nAddressHash;
      ServerInfo.ServerConfig := UserConfig.ServerConfig;

      SendSocket(Session.Socket, DefMsg, EncryptBuffer(@ServerInfo, SizeOf(TServerInfo)));
      if g_boShowLog then MainOutMessage('[' + Session.sRemoteAddress + '] 外挂配制信息发送成功...');
    end;
  end;
end;

procedure TfrmMain.OnProgramException(Sender: TObject; E: Exception);
begin
  MainOutMessage(E.Message);
end;

procedure TfrmMain.StartService;
begin
  try
    InitializeSession();
(*    ServerSocket.Address := '0.0.0.0';
{$IF USERVERSION = 0}
    ServerSocket.Port := 23456;
{$IFEND}

{$IF USERVERSION = 1}
    ServerSocket.Port := 23456;
{$IFEND}

{$IF USERVERSION = 2}
    ServerSocket.Port := 23456;
{$IFEND}

{$IF USERVERSION = 3}
    ServerSocket.Port := 23456;
{$IFEND}
  *)
    g_QQWry := TQQWry.Create('IPList.db');
    //g_MemoryStream.LoadFromFile('');
    ServerSocket.Active := True;
    g_UserSession.LoadFromFile(g_UserSession.Name);
    RefListBox;
    RefListBoxAddr;
    DecodeTime.Enabled := True;
    MainOutMessage('启动服务完成...');
    ButtonStart.Enabled := False;
    PopupMenu_Clear.Enabled := False;
    ButtonStop.Enabled := True;
  except
    on E: Exception do begin
      ButtonStart.Enabled := True;
      ButtonStop.Enabled := False;
      PopupMenu_Clear.Enabled := False;
      MainOutMessage(E.Message);
    end;
  end;
end;

procedure TfrmMain.StopService;
begin
  MainOutMessage('正在停止服务...');
  InitializeSession();
  ServerSocket.Active := False;
  ButtonStart.Enabled := True;
  ButtonStop.Enabled := False;
  g_QQWry.Free;
  MainOutMessage('服务器已停止...');
end;


procedure TFrmMain.TimerStartTimer(Sender: TObject);
begin
  TimerStart.Enabled := False;
  StartService;
end;

procedure TFrmMain.TimerTimer(Sender: TObject);
const
  sFormat = '%d' + #9 + '%s' + #9 + '%s' + #9 + '%d' + #9 + '%s' + #9 + '%d';
  procedure Inc_(S: string; List: TStringList; Count: Integer);
  var
    I, nCount: Integer;
  begin
    for I := 0 to List.Count - 1 do begin
      if List.Strings[I] = S then begin
        nCount := Integer(List.Objects[I]);
        Inc(nCount, Count);
        List.Objects[I] := TObject(nCount);
        Exit;
      end;
    end;
    List.AddObject(S, TObject(Count));
  end;
var
  I, II: Integer;
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
  UserConfig: pTUserConfig;
  SaveList: TStringList;
  Session: pTSession;
  sFileName: string;
  sDir: string;
  List1: TStringList;
  List2: TStringList;
  List3: TStringList;
  List4: TStringList;
  IPCount, nInsert: Integer;
begin
  if g_Today <> Date then begin
  //DecodeTime(Now, Hour, Min, Sec, MSec);
    if not DirectoryExists('Log') then begin
      CreateDir('Log');
    end;
    DecodeDate(g_Today, Year, Month, Day);
    sDir := 'Log\' + IntToStr(Year) + IntToStr(Month) + IntToStr(Day) + '\';
    if not DirectoryExists(sDir) then begin
      CreateDir(sDir);
    end;
    g_Today := Date;

    SaveList := TStringList.Create;
    List1 := TStringList.Create;
    List2 := TStringList.Create;
    List3 := TStringList.Create;
    List4 := TStringList.Create;
    for I := 0 to g_UserSession.m_ConfigList.Count - 1 do begin
      UserConfig := pTUserConfig(g_UserSession.m_ConfigList.Objects[I]);
      sFileName := ExtractFilePath(Application.ExeName) + sDir + GetWebAddr(UserConfig.ServerConfig.sUserLiense) + '.txt';

      IPCount := 0;
      SaveList.Clear;
      List1.Clear;
      List2.Clear;
      List3.Clear;
      List4.Clear;

      SaveList.Add(';序号'#9'IP地址'#9'用户系统'#9'外挂版本'#9'连接时间'#9'连接次数');
      for II := 0 to UserConfig.SessionList.Count - 1 do begin
        Session := pTSession(UserConfig.SessionList.Objects[II]);
        SaveList.Add(Format(sFormat, [II,
          Session.sRemoteAddress,
            GetOSVersion(Session.ClientInfo.nVersion),
            Session.ClientInfo.nEXEVersion,
            DateTimeToStr(Session.dDateTime),
            Session.nCount]));
        Inc(IPCount, Session.nCount);
        Inc_(GetOSVersion(Session.ClientInfo.nVersion), List1, Session.nCount);
        Inc_(IntToStr(Session.ClientInfo.nEXEVersion), List2, Session.nCount);
      end;

      nInsert := 1;
      SaveList.Insert(nInsert, '');
      Inc(nInsert);
      SaveList.Insert(nInsert, '统计: ');
      Inc(nInsert);
      SaveList.Insert(nInsert, #9'IP统计: ');
      Inc(nInsert);
      SaveList.Insert(nInsert, #9#9'独立IP: ' + IntToStr(UserConfig.SessionList.Count));
      Inc(nInsert);
      SaveList.Insert(nInsert, #9#9'IP总数: ' + IntToStr(IPCount));
      Inc(nInsert);
      SaveList.Insert(nInsert, #9'用户系统: ');
      for II := 0 to List1.Count - 1 do begin
        Inc(nInsert);
        SaveList.Insert(nInsert, #9#9 + List1.Strings[II] + ': ' + IntToStr(Integer(List1.Objects[II])));
      end;
      Inc(nInsert);
      SaveList.Insert(nInsert, #9'外挂版本: ');
      for II := 0 to List2.Count - 1 do begin
        Inc(nInsert);
        SaveList.Insert(nInsert, #9#9 + List2.Strings[II] + ': ' + IntToStr(Integer(List2.Objects[II])));
      end;

      UserConfig.SessionList.Free;
      UserConfig.SessionList := TUserList.Create;
      try
        SaveList.SaveToFile(sFileName);
      except

      end;
    end;
    SaveList.Free;
    List1.Free;
    List2.Free;
    List3.Free;
    List4.Free;
  end;

  if ServerSocket.Active then begin
    StatusPane1.Caption := Format('(%s:%d)启动中...', [ServerSocket.Address, ServerSocket.Port]);
    StatusPane2.Caption := '用户数:' + IntToStr(ServerSocket.Socket.ActiveConnections);
  end else begin
    StatusPane1.Caption := '已停止';
    StatusPane2.Caption := '用户数:0'
  end;
  if SelUserConfig <> nil then begin
    StatusPane3.Caption := SelUserConfig.ServerConfig.sUserLiense + ' : ' + IntTOStr(SelUserConfig.SessionList.Count);
  end;
end;

procedure TFrmMain.ListViewOnData(Sender: TObject; Item: TListItem);
var
  ListView: TListViewA;
  UserConfig: pTUserConfig;
  Session: pTSession;
begin
  ListView := TListViewA(Sender);
  UserConfig := ListView.UserConfig;
  Session := pTSession(UserConfig.SessionList.Objects[Item.Index]);
  Item.Caption := IntToStr(Item.Index);
  Item.SubItems.AddObject(Session.sRemoteAddress, UserConfig.SessionList.Objects[Item.Index]);
  Item.SubItems.Add(SearchIPLocal(Session.sRemoteAddress));
  Item.SubItems.Add(GetOSVersion(Session.ClientInfo.nVersion));
  Item.SubItems.Add(IntToStr(Session.ClientInfo.nEXEVersion));
  Item.SubItems.Add(DateTimeToStr(Session.dDateTime));
  Item.SubItems.Add(IntToStr(Session.nCount));
  if Session.SessionStatus = s_SendLic then begin
    Item.SubItems.Add('外挂配制信息已发送');
  end else
    if Session.SessionStatus = s_SendAddress then begin
    Item.SubItems.Add('黑名单已发送');
  end else
    if Session.SessionStatus = s_GetLic then begin
    Item.SubItems.Add('请求发送外挂配制信息');
  end else begin
    Item.SubItems.Add('连接成功');
  end;
end;

procedure TfrmMain.RefUserIP(sConfig: string);
var
  //I: Integer;
  //ListItem: TListItem;
  UserConfig: pTUserConfig;
  //Session: pTSession;
begin
  //Sleep(100);
  UserConfig := g_UserSession.Get(sConfig);
  if UserConfig <> nil then begin
    PageControl.ActivePage := UserConfig.TabSheet;
    //UserConfig.TabSheet.Caption := '(' + sConfig + ')'; //连接信息
    //UserConfig.TabSheet.Caption := sConfig; //连接信息
    UserConfig.ListView.UserConfig := UserConfig;
    UserConfig.ListView.Items.Count := UserConfig.SessionList.Count;
    UserConfig.ListView.Repaint;
   { UserConfig.ListView.Items.Clear;
    for I := 0 to UserConfig.SessionList.Count - 1 do begin
      Session := pTSession(UserConfig.SessionList.Objects[I]);
      Application.ProcessMessages;
      ListItem := UserConfig.ListView.Items.Add;
      ListItem.Caption := IntToStr(I);
      ListItem.SubItems.AddObject(Session.sRemoteAddress, UserConfig.SessionList.Objects[I]);
      ListItem.SubItems.Add(SearchIPLocal(Session.sRemoteAddress));
      ListItem.SubItems.Add(GetOSVersion(Session.ClientInfo.nVersion));
      ListItem.SubItems.Add(IntToStr(Session.ClientInfo.nEXEVersion));
      ListItem.SubItems.Add(DateTimeToStr(Session.dDateTime));
      ListItem.SubItems.Add(IntToStr(Session.nCount));
      if Session.SessionStatus = s_SendLic then begin
        ListItem.SubItems.Add('外挂配制信息已发送');
      end else
        if Session.SessionStatus = s_SendAddress then begin
        ListItem.SubItems.Add('黑名单已发送');
      end else
        if Session.SessionStatus = s_GetLic then begin
        ListItem.SubItems.Add('请求发送外挂配制信息');
      end else begin
        ListItem.SubItems.Add('连接成功');
      end;
      //UserConfig.TabSheet.Caption := '连接信息(' + sConfig + ') [' + IntToStr(UserConfig.ListView.Items.Count) + ']';
      UserConfig.TabSheet.Caption := sConfig + ' [' + IntToStr(UserConfig.ListView.Items.Count) + ']';
    end; }
    UserConfig.TabSheet.Caption := sConfig + ' [' + IntToStr(UserConfig.SessionList.Count) + ']';
    UserConfig.TabSheet.TabVisible := True;
  end;
end;

end.

