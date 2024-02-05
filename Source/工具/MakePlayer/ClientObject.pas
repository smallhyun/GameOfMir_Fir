unit ClientObject;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, StdCtrls,
  JSocket, Grobal2, HUtil32, EncryptUnit;

const
  MAXBAGITEMCL = 40;

type
  TConnectionStep = (cnsConnect, cnsNewAccount, cnsQueryServer, cnsSelServer, cnsLogin, cnsNewChr, cnsQueryChr, cnsSelChr, cnsReSelChr, cnsPlay);
  TConnectionStatus = (cns_Success, cns_Failure);
  TUserCharacterInfo = record
    sName: string[19];
    btJob: Byte;
    btHair: Byte;
    wLevel: word;
    btSex: Byte;
  end;

  TSelChar = record
    boValid: Boolean;
    UserChr: TUserCharacterInfo;
    boSelected: Boolean;
    boFreezeState: Boolean; //TRUE:倔篮惑怕 FALSE:踌篮惑怕
    boUnfreezing: Boolean; //踌绊 乐绰 惑怕牢啊?
    boFreezing: Boolean; //倔绊 乐绰 惑怕?
    nAniIndex: Integer; //踌绰(绢绰) 局聪皋捞记
    nDarkLevel: Integer;
    nEffIndex: Integer; //瓤苞 局聪皋捞记
    dwStartTime: LongWord;
    dwMoretime: LongWord;
    dwStartefftime: LongWord;
  end;

  TObjClient = class
    m_dwConnectTick: LongWord;

    m_sSockText: string;
    m_sBufferText: string;
    m_sLoginAccount: string;
    m_sLoginPasswd: string;
    m_nCertification: Integer;
    //m_TimerCmd: TTimerCommand;
    m_sCharName: string;
    m_ConnectionStep: TConnectionStep; //当前游戏网络连接步骤
    m_ConnectionStatus: TConnectionStatus;
    m_sServerName: string;
    m_wAvailIDDay: word;
    m_wAvailIDHour: word;
    m_wAvailIPDay: word;
    m_wAvailIPHour: word;

    m_boDoFastFadeOut: Boolean;
    m_dwFirstServerTime: LongWord;
    m_dwFirstClientTime: LongWord;

    m_sSelChrAddr: string;
    m_nSelChrPort: Integer;
    m_sRunServerAddr: string;
    m_nRunServerPort: Integer;

    m_ChrArr: array[0..1] of TSelChar;
    m_ChangeFaceReadyList: TList;
    m_FreeActorList: TList;

    m_nTargetX: Integer;
    m_nTargetY: Integer;
    m_sMapTitle: string;
    m_sMapName: string;
    m_nMapMusic: Integer;
    m_MagicList: TList;
    m_UseItems: array[0..12] of TClientItem;
    m_ItemArr: array[0..MAXBAGITEMCL - 1] of TClientItem;

    m_boActionLock: Boolean;


    m_dwNotifyEventTick: LongWord;

    m_nReceiveCount: Integer;
    m_NewIdRetryUE: TUserEntry;
    m_NewIdRetryAdd: TUserEntryAdd;
    m_sMakeNewId: string;

    m_boTimerMainBusy: Boolean;
    m_boMapMovingWait: Boolean;
    m_btCode: Byte;
    m_boSendLogin: Boolean;

    m_boNewAccount: Boolean;

    m_nGold: Integer;
    m_btJob: Byte;
    m_nGameGold: Integer;
    m_Abil: TAbility;

  private
    FNotifyEvent: TNotifyEvent;
    procedure SocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure SocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure SocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure SocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure DecodeMessagePacket(sDataBlock: string);

    procedure ClientGetUserLogin(DefMsg: TDefaultMessage; sData: string);
    procedure ClientGetAbility(DefMsg: TDefaultMessage; sData: string);
    //procedure ClientGetSubAbility(DefMsg: TDefaultMessage);
    procedure ClientGetWinExp(DefMsg: TDefaultMessage);
    procedure ClientGetLevelUp(DefMsg: TDefaultMessage);

    procedure ClientNewIDSuccess();

    procedure ClientNewIDFail(nFailCode: Integer);
    procedure ClientLoginFail(nFailCode: Integer);
    procedure ClientGetServerName(DefMsg: pTDefaultMessage; sBody: string);
    procedure ClientGetPasswordOK(DefMsg: TDefaultMessage; sData: string);
    procedure ClientGetPasswdSuccess(sData: string);
    procedure ClientGetReceiveChrs(sData: string);
    procedure ClientQueryChrFail(nFailCode: Integer);
    procedure ClientNewChrFail(nFailCode: Integer);
    procedure ClientGetStartPlay(sData: string);
    procedure ClientStartPlayFail();
    procedure ClientVersionFail();
    procedure ClientGetSendNotice(sData: string);

    procedure DoNotifyEvent;
    procedure SetNotifyEvent(ANotifyEvent: TNotifyEvent; nTime: Integer);
    procedure NewAccount(Sender: TObject);
    procedure NewChr(Sender: TObject);
  public
    ClientSocket: TClientSocket;
    constructor Create;
    destructor Destroy; override;
    procedure Close;
    procedure Run;
    procedure SendSocket(sText: string);
    procedure SendClientMessage(nIdent, nRecog, nParam, nTag, nSeries: Integer);
    procedure SendNewAccount(sAccount, sPassword: string);
    procedure SendLogin(sAccount, sPassword: string);
    procedure SelectChrCreateNewChr(sCharName: string);
    procedure SendNewChr(sAccount, sChrName, sHair, sJob, sSex: string);


    procedure SendQueryChr();

    procedure SendSelectServer(sServerName: string);
    procedure SendSelChr(sCharName: string);

    procedure SendRunLogin();

    property OnNotifyEvent: TNotifyEvent read FNotifyEvent write FNotifyEvent;
    //procedure SendSay(smsg: string);
  end;
implementation
uses Share;

constructor TObjClient.Create;
begin
  inherited;
  ClientSocket := TClientSocket.Create(nil);
  ClientSocket.OnConnect := SocketConnect;
  ClientSocket.OnDisconnect := SocketDisconnect;
  ClientSocket.OnRead := SocketRead;
  ClientSocket.OnError := SocketError;
  m_btCode := 0;
  m_sSockText := '';
  m_sBufferText := '';
  m_sLoginAccount := '';
  m_sLoginPasswd := '';
  m_nCertification := 0;
  m_sCharName := '';
  m_ConnectionStep := cnsConnect;
  m_ConnectionStatus := cns_Success;
  m_boSendLogin := False;
  m_boNewAccount := False;
  m_dwConnectTick := GetTickCount;
  FNotifyEvent := nil;
  m_dwNotifyEventTick := GetTickCount;
end;

destructor TObjClient.Destroy;
begin
  ClientSocket.Free;
  inherited;
end;

procedure TObjClient.NewAccount(Sender: TObject);
begin
  m_ConnectionStep := cnsNewAccount;
  SendNewAccount(m_sLoginAccount, m_sLoginPasswd);
end;

procedure TObjClient.NewChr(Sender: TObject);
begin
  //m_ConnectionStep := cnsNewChr;
  SelectChrCreateNewChr(m_sCharName);
end;

procedure TObjClient.SocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  m_sSockText := '';
  m_sBufferText := '';
  if m_ConnectionStep = cnsConnect then begin
    if m_boNewAccount then begin
      SetNotifyEvent(NewAccount, 6000);
    end else begin
      m_ConnectionStep := cnsQueryServer;
      SendClientMessage(CM_QUERYSERVERNAME, 0, 0, 0, 0);
      MainOutMessage(Format('[%s] 查询服务器列表', [m_sLoginAccount]));
    end;
  end else
    if m_ConnectionStep = cnsQueryChr then begin
    SendQueryChr;
  end else
    if m_ConnectionStep = cnsPlay then begin
    SendRunLogin;
  end;
end;

procedure TObjClient.SocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin

end;

procedure TObjClient.SocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  nIdx: Integer;
  sData: string;
  sData2: string;
begin
  sData := Socket.ReceiveText;
  nIdx := Pos('*', sData);
  if nIdx > 0 then begin
    sData2 := Copy(sData, 1, nIdx - 1);
    sData := sData2 + Copy(sData, nIdx + 1, Length(sData));
    ClientSocket.Socket.SendText('*');
  end;
  m_sSockText := m_sSockText + sData;
end;

procedure TObjClient.SocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TObjClient.SendSocket(sText: string);
var
  sSendText: string;
begin
  if ClientSocket.Socket.Connected then begin
    sSendText := '#' + IntToStr(m_btCode) + sText + '!';
    ClientSocket.Socket.SendText('#' + IntToStr(m_btCode) + sText + '!');
    Inc(m_btCode);
    if m_btCode >= 10 then m_btCode := 1;
  end;
end;

procedure TObjClient.SendClientMessage(nIdent, nRecog, nParam, nTag, nSeries: Integer);
var
  DefMsg: TDefaultMessage;
begin
  DefMsg := MakeDefaultMsg(nIdent, nRecog, nParam, nTag, nSeries);
  SendSocket(EncodeMessage(DefMsg));
end;

procedure TObjClient.SendNewAccount(sAccount, sPassword: string); //发送新建账号
var
  Msg: TDefaultMessage;
  ue: TUserEntry; ua: TUserEntryAdd;
begin
  MainOutMessage(Format('[%s] 创建帐号', [m_sLoginAccount]));
  m_ConnectionStep := cnsNewAccount;
  FillChar(ue, SizeOf(TUserEntry), #0);
  FillChar(ua, SizeOf(TUserEntryAdd), #0);
  ue.sAccount := sAccount;
  ue.sPassword := sPassword;
  ue.sUserName := sAccount;
  ue.sSSNo := '650101-1455111';
  ue.sQuiz := sAccount;
  ue.sAnswer := sAccount;
  ue.sPhone := '';
  ue.sEMail := '';

  ua.sQuiz2 := sAccount;
  ua.sAnswer2 := sAccount;
  ua.sBirthDay := '1999/01/01';
  ua.sMobilePhone := '';

  {NewIdRetryUE := ue;
  NewIdRetryUE.sAccount := '';
  NewIdRetryUE.sPassword := '';
  NewIdRetryAdd := ua; }

  Msg := MakeDefaultMsg(CM_ADDNEWUSER, 0, 0, 0, 0);
  SendSocket(EncodeMessage(Msg) + EncodeBuffer(@ue, SizeOf(TUserEntry)) + EncodeBuffer(@ua, SizeOf(TUserEntryAdd))); //329
end;

procedure TObjClient.SelectChrCreateNewChr(sCharName: string);
var
  sHair: string;
  sJob: string;
  sSex: string;
begin
  case Random(1) of
    0: begin
        sHair := '2';
      end;
    1: begin
        case Random(1) of
          0: sHair := '1';
          1: sHair := '3';
        end;
      end;
  end;
  sJob := IntToStr(Random(2));
  sSex := IntToStr(Random(1));
  SendNewChr(m_sLoginAccount, sCharName, sHair, sJob, sSex);
end;

procedure TObjClient.SendSelChr(sCharName: string);
var
  DefMsg: TDefaultMessage;
begin
  MainOutMessage(Format('[%s] 选择人物：%s', [m_sLoginAccount, sCharName]));
  m_ConnectionStep := cnsSelChr;
  m_sCharName := sCharName;
  DefMsg := MakeDefaultMsg(CM_SELCHR, 0, 0, 0, 0);
  SendSocket(EncodeMessage(DefMsg) + EncodeString(m_sLoginAccount + '/' + sCharName));
end;

procedure TObjClient.SendLogin(sAccount, sPassword: string);
var
  DefMsg: TDefaultMessage;
begin
  MainOutMessage(Format('[%s] 开始登录', [m_sLoginAccount]));
  m_ConnectionStep := cnsLogin;
  DefMsg := MakeDefaultMsg(CM_IDPASSWORD, 0, 0, 0, 0);
  SendSocket(EncodeMessage(DefMsg) + EncodeString(sAccount + '/' + sPassword));
  m_boSendLogin := True;
end;

procedure TObjClient.SendNewChr(sAccount, sChrName, sHair, sJob, sSex: string);
var
  DefMsg: TDefaultMessage;
begin
  MainOutMessage(Format('[%s] 创建人物：%s', [m_sLoginAccount, sChrName]));
  m_ConnectionStep := cnsNewChr;
  DefMsg := MakeDefaultMsg(CM_NEWCHR, 0, 0, 0, 0);
  SendSocket(EncodeMessage(DefMsg) + EncodeString(sAccount + '/' + sChrName + '/' + sHair + '/' + sJob + '/' + sSex));
end;

procedure TObjClient.SendQueryChr;
var
  DefMsg: TDefaultMessage;
begin
  MainOutMessage(Format('[%s] 查询人物', [m_sLoginAccount]));
  m_ConnectionStep := cnsQueryChr;
  DefMsg := MakeDefaultMsg(CM_QUERYCHR, 0, 0, 0, 0);
  SendSocket(EncodeMessage(DefMsg) + EncodeString(m_sLoginAccount + '/' + IntToStr(m_nCertification)));
end;

procedure TObjClient.SendSelectServer(sServerName: string);
var
  DefMsg: TDefaultMessage;
begin
  MainOutMessage(Format('[%s] 选择服务器：%s', [m_sLoginAccount, sServerName]));
  m_ConnectionStep := cnsSelServer;
  DefMsg := MakeDefaultMsg(CM_SELECTSERVER, 0, 0, 0, 0);
  SendSocket(EncodeMessage(DefMsg) + EncodeString(sServerName));
end;

procedure TObjClient.SendRunLogin;
var
  sSendMsg: string;
begin
  MainOutMessage(Format('[%s] 进入游戏', [m_sLoginAccount]));
  m_ConnectionStep := cnsPlay;
  sSendMsg := Format('**%s/%s/%d/%d/%d/%d', [m_sLoginAccount, m_sCharName, m_nCertification xor $3EB2C5CC, m_nCertification xor $54B163FD, CLIENT_VERSION_NUMBER, 0]);
  SendSocket(EncodeString(sSendMsg));
end;

procedure TObjClient.DoNotifyEvent;
begin
  if Assigned(FNotifyEvent) then begin
    if GetTickCount > m_dwNotifyEventTick then begin
      FNotifyEvent(Self);
      FNotifyEvent := nil;
    end;
  end;
end;

procedure TObjClient.SetNotifyEvent(ANotifyEvent: TNotifyEvent; nTime: Integer);
begin
  m_dwNotifyEventTick := GetTickCount + nTime;
  FNotifyEvent := ANotifyEvent;
end;

procedure TObjClient.ClientGetStartPlay(sData: string);
var
  sText: string;
  sRunAddr: string;
  sRunPort: string;
begin
  sText := DecodeString(sData);
  sRunPort := GetValidStr3(sText, m_sRunServerAddr, ['/']);
  m_nRunServerPort := Str_ToInt(sRunPort, 0);
  ClientSocket.Active := False;
  ClientSocket.Host := '';
  ClientSocket.Port := 0;
  //WaitAndPass(500);
  m_ConnectionStep := cnsPlay;
  MainOutMessage(Format('[%s] 准备进入游戏', [m_sLoginAccount]));
  with ClientSocket do begin
    ClientType := ctNonBlocking;
    Address := m_sRunServerAddr;
    Port := m_nRunServerPort;
    Active := True;
  end;
end;

procedure TObjClient.ClientStartPlayFail;
begin
  MainOutMessage(Format('[%s] 此服务器满员！', [m_sLoginAccount]));
end;

procedure TObjClient.ClientVersionFail;
begin
  //MainOutMessage(Format('[%s] 游戏程序版本不正确，请下载最新版本游戏程序！', [m_sLoginAccount]));
end;

procedure TObjClient.ClientGetSendNotice(sData: string);
{var
  sLineText: string;
  smsg: string;
  sServerName: string;}
begin
  {g_boDoFastFadeOut := False;
  smsg := '';
  sData := DecodeString(sData);
  while True do begin
    if sData = '' then Break;
    sData := GetValidStr3(sData, sLineText, [#27]);
    smsg := smsg + sLineText + #13;
  end;}
  //sServerName := g_SelGameZone.ServerName;
  MainOutMessage(Format('[%s] 发送公告', [m_sLoginAccount]));
  SendClientMessage(CM_LOGINNOTICEOK, GetTickCount, 0, 0, 0);
end;

procedure TObjClient.ClientGetUserLogin(DefMsg: TDefaultMessage;
  sData: string);
var
  MsgWL: TMessageBodyWL;
begin
  m_ConnectionStep := cnsPlay;
  m_ConnectionStatus := cns_Success;
  MainOutMessage(Format('[%s] 成功进入游戏', [m_sLoginAccount]));
  MainOutMessage('-----------------------------------------------');
  (*g_dwFirstServerTime := 0;
  g_dwFirstClientTime := 0;
  DecodeBuffer(sData, @MsgWL, SizeOf(TMessageBodyWL));
  g_PlayScene.SendMsg(DefMsg.Ident, DefMsg.Recog, DefMsg.param {x}, DefMsg.Tag {y}, DefMsg.Series {dir}, MsgWL.lParam1 {desc.Feature}, MsgWL.lParam2 {desc.Status}, '');
  ChangeScene(stPlayGame);
  SendClientMessage(CM_QUERYBAGITEMS, 0, 0, 0, 0);
  if LoByte(LoWord(MsgWL.lTag1)) = 1 then g_boAllowGroup := True
  else g_boAllowGroup := False;
  g_boServerChanging := False;
  if g_wAvailIDDay > 0 then begin
    AddChatBoardString('您当前通过包月帐号充值。', clGreen, clWhite)
  end else if g_wAvailIPDay > 0 then begin
    AddChatBoardString('您当前通过包月IP 充值。', clGreen, clWhite)
  end else if g_wAvailIPHour > 0 then begin
    AddChatBoardString('您当前通过计时IP 充值。', clGreen, clWhite)
  end else if g_wAvailIDHour > 0 then begin
    AddChatBoardString('您当前通过计时帐号充值。', clGreen, clWhite)
  end;*)
end;

procedure TObjClient.ClientGetAbility(DefMsg: TDefaultMessage;
  sData: string);
begin
  m_nGold := DefMsg.Recog;
  m_btJob := DefMsg.param;
  m_nGameGold := MakeLong(DefMsg.Tag, DefMsg.Series);
  DecodeBuffer(sData, @m_Abil, SizeOf(TAbility));
end;

procedure TObjClient.ClientGetWinExp(DefMsg: TDefaultMessage);
begin
  m_Abil.Exp := LongWord(DefMsg.Recog);
end;

procedure TObjClient.ClientGetLevelUp(DefMsg: TDefaultMessage);
begin
  m_Abil.Level := MakeLong(DefMsg.param, DefMsg.tag);
end;

procedure TObjClient.ClientQueryChrFail(nFailCode: Integer);
begin
  m_ConnectionStatus := cns_Failure;
end;

procedure TObjClient.ClientNewChrFail(nFailCode: Integer);
begin
  m_ConnectionStatus := cns_Failure;
  Close;
  case nFailCode of
    0: MainOutMessage(Format('[%s] [错误信息] 输入的角色名称包含非法字符！ 错误代码 = 0', [m_sLoginAccount]));
    2: MainOutMessage(Format('[%s] [错误信息] 创建角色名称已被其他人使用！ 错误代码 = 2', [m_sLoginAccount]));
    3: MainOutMessage(Format('[%s] [错误信息] 您只能创建二个游戏角色！ 错误代码 = 3', [m_sLoginAccount]));
    4: MainOutMessage(Format('[%s] [错误信息] 创建角色时出现错误！ 错误代码 = 4', [m_sLoginAccount]));
  else MainOutMessage(Format('[%s] [错误信息] 创建角色时出现未知错误！', [m_sLoginAccount]));
  end;
end;

procedure TObjClient.ClientNewIDFail(nFailCode: Integer);
begin
  if nFailCode <> 0 then begin
    m_ConnectionStatus := cns_Failure;
    Close;
  end;
  case nFailCode of
    0: begin
        MainOutMessage(Format('[%s] 帐号 "' + m_sLoginAccount + '" 已被其他的玩家使用了。'#13'请选择其它帐号名注册。', [m_sLoginAccount]));
        ClientNewIDSuccess;
      end;
    1: begin
        MainOutMessage(Format('[%s] 验证码输入错误，请重新输入！！！', [m_sLoginAccount]));
      end;
    -2: begin
        MainOutMessage(Format('[%s] 此帐号名被禁止使用！', [m_sLoginAccount]));
      end;
  else begin
      MainOutMessage(Format('[%s] 帐号创建失败，请确认帐号是否包括空格、及非法字符！Code: ' + IntToStr(nFailCode), [m_sLoginAccount]));
    end;
  end;
end;

procedure TObjClient.ClientNewIDSuccess;
begin
  m_ConnectionStatus := cns_Success;
  m_ConnectionStep := cnsQueryServer;
  SendClientMessage(CM_QUERYSERVERNAME, 0, 0, 0, 0);
  MainOutMessage(Format('[%s] 帐号创建成功，查询服务器列表', [m_sLoginAccount]));
  //MainOutMessage(Format('[%s] 您的帐号创建成功。'#13'请妥善保管您的帐号和密码，'#13'并且不要因任何原因把帐号和密码告诉任何其他人。', [m_sLoginAccount]));
end;

procedure TObjClient.ClientGetPasswdSuccess(sData: string); //选择服务器 SM_SELECTSERVER_OK
{var
  sText: string;
  //sSelChrAddr: string;
  sSelChrPort: string;
  sCertification: string;    }
begin
  SendLogin(m_sLoginAccount, m_sLoginPasswd);
  {sText := DecodeString(sData);
  sText := GetValidStr3(sText, m_sSelChrAddr, ['/']);
  sText := GetValidStr3(sText, sSelChrPort, ['/']);
  sText := GetValidStr3(sText, sCertification, ['/']);
  m_nCertification := Str_ToInt(sCertification, 0);
  m_nSelChrPort := Str_ToInt(sSelChrPort, 0);

  ClientSocket.Active := False;
  ClientSocket.Host := '';
  ClientSocket.Port := 0;
  //WaitAndPass(500);
  m_ConnectionStep := cnsQueryChr;}
 { with CSocket do begin
    g_sSelChrAddr := sSelChrAddr;
    g_nSelChrPort := Str_ToInt(sSelChrPort, 0);
    Address := g_sSelChrAddr;
    Port := g_nSelChrPort;
    Active := True;
  end; }
end;

procedure TObjClient.ClientGetReceiveChrs(sData: string);
  procedure AddChr(sName: string; nJob, nHair, nLevel, nSex: Integer);
  var
    I: Integer;
  begin
    if not m_ChrArr[0].boValid then I := 0
    else if not m_ChrArr[1].boValid then I := 1
    else Exit;
    m_ChrArr[I].UserChr.sName := sName;
    m_ChrArr[I].UserChr.btJob := nJob;
    m_ChrArr[I].UserChr.btHair := nHair;
    m_ChrArr[I].UserChr.wLevel := nLevel;
    m_ChrArr[I].UserChr.btSex := nSex;
    m_ChrArr[I].boValid := True;
  end;
  function GetJobName(nJob: Integer): string;
  begin
    case nJob of
      0: Result := '武士';
      1: Result := '魔法师';
      2: Result := '道士'
    else Result := '未知';
    end;
  end;
  function GetSexName(nSex: Integer): string;
  begin
    case nSex of
      0: Result := '男';
      1: Result := '女';
    else Result := '未知';
    end;
  end;
var
  I: Integer;
  nSelect, nChrCount: Integer;
  sText: string;
  sName: string;
  sJob: string;
  sHair: string;
  sLevel: string;
  sSex: string;
begin
  FillChar(m_ChrArr, SizeOf(m_ChrArr), 0);
  nChrCount := 0;
  sText := DecodeString(sData);
  for I := Low(m_ChrArr) to High(m_ChrArr) do begin
    sText := GetValidStr3(sText, sName, ['/']);
    sText := GetValidStr3(sText, sJob, ['/']);
    sText := GetValidStr3(sText, sHair, ['/']);
    sText := GetValidStr3(sText, sLevel, ['/']);
    sText := GetValidStr3(sText, sSex, ['/']);
    nSelect := 0;
    if (sName <> '') and (sLevel <> '') and (sSex <> '') then begin
      if sName[1] = '*' then begin
        nSelect := I;
        sName := Copy(sName, 2, Length(sName) - 1);
        //EditSelectChrCurChr.Text := sName;
      end;
      AddChr(sName, Str_ToInt(sJob, 0), Str_ToInt(sHair, 0), Str_ToInt(sLevel, 0), Str_ToInt(sSex, 0));
      Inc(nChrCount);
    end;
    if nSelect = 0 then begin
      m_ChrArr[0].boFreezeState := False;
      m_ChrArr[0].boSelected := True;
      m_ChrArr[1].boFreezeState := True;
      m_ChrArr[1].boSelected := False;
    end else begin
      m_ChrArr[0].boFreezeState := True;
      m_ChrArr[0].boSelected := False;
      m_ChrArr[1].boFreezeState := False;
      m_ChrArr[1].boSelected := True;
    end;
  end;
  if nChrCount > 0 then begin
    SendSelChr(m_ChrArr[nSelect].UserChr.sName);
  end else begin
    SetNotifyEvent(NewChr, 3000);
  end;
 { EditSelectChrName1.Text := g_ChrArr[0].UserChr.sName;
  EditSelectChrLevel1.Text := IntToStr(g_ChrArr[0].UserChr.wLevel);
  EditSelectChrSex1.Text := GetSexName(g_ChrArr[0].UserChr.btSex);
  EditSelectChrJob1.Text := GetJobName(g_ChrArr[0].UserChr.btJob);

  EditSelectChrName2.Text := g_ChrArr[1].UserChr.sName;
  EditSelectChrLevel2.Text := IntToStr(g_ChrArr[1].UserChr.wLevel);
  EditSelectChrSex2.Text := GetSexName(g_ChrArr[1].UserChr.btSex);
  EditSelectChrJob2.Text := GetJobName(g_ChrArr[1].UserChr.btJob);
  ChangeScene(stSelectChr); }
end;

procedure TObjClient.ClientLoginFail(nFailCode: Integer);
begin
  if nFailCode = -3 then begin
    SendLogin(m_sLoginAccount, m_sLoginPasswd);
    MainOutMessage(Format('[%s] 此帐号已经登录或被异常锁定，请稍候再登录！', [m_sLoginAccount]));
  end else begin
    m_ConnectionStatus := cns_Failure;
    case nFailCode of
      -1: MainOutMessage(Format('[%s] 密码错误！！', [m_sLoginAccount]));
      -2: MainOutMessage(Format('[%s] 密码输入错误超过3次，此帐号被暂时锁定，请稍候再登录！', [m_sLoginAccount]));
      -3: MainOutMessage(Format('[%s] 此帐号已经登录或被异常锁定，请稍候再登录！', [m_sLoginAccount]));
      -4: MainOutMessage(Format('[%s] 这个帐号访问失败！\请使用其他帐号登录，\或者申请付费注册。', [m_sLoginAccount]));
      -5: MainOutMessage(Format('[%s] 这个帐号被锁定！', [m_sLoginAccount]));
    else MainOutMessage(Format('[%s] 此帐号不存在或出现未知错误！！', [m_sLoginAccount]));
    end;
    m_boSendLogin := False;
    Close;
  end;
end;

procedure TObjClient.ClientGetServerName(DefMsg: pTDefaultMessage;
  sBody: string);
var
  I: Integer;
  sServerName: string;
  sServerStatus: string;
  nCount: Integer;
begin
  sBody := DecodeString(sBody);
  //FrmDlg.DMessageDlg (sBody + '/' + IntToStr(Msg.Series), [mbOk]);
  nCount := _MIN(6, DefMsg.series);
  //g_ServerList.Clear;
  for I := 0 to nCount - 1 do begin
    sBody := GetValidStr3(sBody, sServerName, ['/']);
    sBody := GetValidStr3(sBody, sServerStatus, ['/']);
    if sServerName = m_sServerName then begin
      SendSelectServer(sServerName);
      Exit;
    end;
    //g_ServerList.AddObject(sServerName, TObject(Str_ToInt(sServerStatus, 0)));
  end;

  if nCount = 1 then begin
    m_sServerName := sServerName;
    SendSelectServer(sServerName);
  end;

  //ClientGetSelectServer;
end;

procedure TObjClient.ClientGetPasswordOK(DefMsg: TDefaultMessage;
  sData: string);
var
  sText: string;
  //sSelChrAddr: string;
  sSelChrPort: string;
  sCertification: string;
begin
  sText := DecodeString(sData);
  sText := GetValidStr3(sText, m_sSelChrAddr, ['/']);
  sText := GetValidStr3(sText, sSelChrPort, ['/']);
  sText := GetValidStr3(sText, sCertification, ['/']);
  m_nCertification := Str_ToInt(sCertification, 0);
  m_nSelChrPort := Str_ToInt(sSelChrPort, 0);

  ClientSocket.Active := False;
  ClientSocket.Host := '';
  ClientSocket.Port := 0;
  m_ConnectionStep := cnsQueryChr;

  with ClientSocket do begin
    ClientType := ctNonBlocking;
    Address := m_sSelChrAddr;
    Port := m_nSelChrPort;
    Active := True;
  end;

  {m_ConnectionStatus := cs_Success;
  sData := DecodeString(sData);
  //  FrmDlg.DMessageDlg (sBody + '/' + IntToStr(Msg.Series), [mbOk]);
  nCount := _MIN(6, DefMsg.Series);
  //g_ServerList.Clear;
  for I := 0 to nCount - 1 do begin
    sData := GetValidStr3(sData, sServerName, ['/']);
    sData := GetValidStr3(sData, sServerStatus, ['/']);
    //g_ServerList.AddObject(sServerName, TObject(Str_ToInt(sServerStatus, 0)));
  end;}
 { g_wAvailIDDay := LoWord(DefMsg.Recog);
  g_wAvailIDHour := HiWord(DefMsg.Recog);
  g_wAvailIPDay := DefMsg.param;
  g_wAvailIPHour := DefMsg.Tag;

  if g_wAvailIDDay > 0 then begin
    if g_wAvailIDDay = 1 then
      MessageDlg('您当前ID费用到今天为止。', [mbOK])
    else if g_wAvailIDDay <= 3 then
      MessageDlg('您当前IP费用还剩 ' + IntToStr(g_wAvailIDDay) + ' 天。', [mbOK]);
  end else if g_wAvailIPDay > 0 then begin
    if g_wAvailIPDay = 1 then
      MessageDlg('您当前IP费用到今天为止。', [mbOK])
    else if g_wAvailIPDay <= 3 then
      MessageDlg('您当前IP费用还剩 ' + IntToStr(g_wAvailIPDay) + ' 天。', [mbOK]);
  end else if g_wAvailIPHour > 0 then begin
    if g_wAvailIPHour <= 100 then
      MessageDlg('您当前IP费用还剩 ' + IntToStr(g_wAvailIPHour) + ' 小时。', [mbOK]);
  end else if g_wAvailIDHour > 0 then begin
    MessageDlg('您当前ID费用还剩 ' + IntToStr(g_wAvailIDHour) + ' 小时。', [mbOK]); ;
  end;
  ChangeScene(stSelectServer);}
end;

procedure TObjClient.Close;
begin
  ClientSocket.Close;
end;

procedure TObjClient.Run;
var
  sData: string;
  sServerAddr: string;
  sServerPort: string;
begin
  if (m_ConnectionStep = cnsConnect) and (not Assigned(FNotifyEvent)) then begin
    if (m_ConnectionStatus = cns_Success) and (GetTickCount > m_dwConnectTick) then begin
      m_dwConnectTick := GetTickCount;
      try
        ClientSocket.Active := True;
      except
        m_ConnectionStatus := cns_Failure;
      end;
    end;
    Exit;
  end;

  DoNotifyEvent;

  m_boTimerMainBusy := True;
  try
    m_sBufferText := m_sBufferText + m_sSockText;
    m_sSockText := '';
    if m_sBufferText <> '' then begin
      while Length(m_sBufferText) >= 2 do begin
        if m_boMapMovingWait then Break;
        if Pos('!', m_sBufferText) <= 0 then Break;
        m_sBufferText := ArrestStringEx(m_sBufferText, '#', '!', sData);
        if sData = '' then Break;
        DecodeMessagePacket(sData);
      end;
    end;
  finally
    m_boTimerMainBusy := False;
  end;
end;

procedure TObjClient.DecodeMessagePacket(sDataBlock: string);
var
  sData: string;
  sTagStr: string;
  sDefMsg: string;
  sBody: string;
  DefMsg: TDefaultMessage;
begin
  if sDataBlock[1] = '+' then begin //checkcode
   { sData := Copy(sDataBlock, 2, Length(sDataBlock) - 1);
    sData := GetValidStr3(sData, sTagStr, ['/']);
    if sTagStr = 'PWR' then g_boNextTimePowerHit := True; //打开攻杀
    if sTagStr = 'LNG' then g_boCanLongHit := True; //打开刺杀
    if sTagStr = 'ULNG' then g_boCanLongHit := False; //关闭刺杀
    if sTagStr = 'WID' then g_boCanWideHit := True; //打开半月
    if sTagStr = 'UWID' then g_boCanWideHit := False; //关闭半月
    if sTagStr = 'CRS' then g_boCanCrsHit := True;
    if sTagStr = 'UCRS' then g_boCanCrsHit := False;
    if sTagStr = 'TWN' then g_boCanTwnHit := True;
    if sTagStr = 'UTWN' then g_boCanTwnHit := False;
    if sTagStr = 'STN' then g_boCanStnHit := True;
    if sTagStr = 'USTN' then g_boCanStnHit := False;
    if sTagStr = 'FIR' then begin
      g_boNextTimeFireHit := True; //打开烈火
      g_dwLatestFireHitTick := GetTickCount;
      //Myself.SendMsg (SM_READYFIREHIT, Myself.XX, Myself.m_nCurrY, Myself.Dir, 0, 0, '', 0);
    end;
    if sTagStr = 'UFIR' then g_boNextTimeFireHit := False; //关闭烈火
    if sTagStr = 'GOOD' then begin
      g_boActionLock := False;
      Inc(m_nReceiveCount);
    end;
    if sTagStr = 'FAIL' then begin
      ActionFailed;
      m_boActionLock := False;
      Inc(m_nReceiveCount);
    end;
    if sData <> '' then begin
      CheckSpeedHack(Str_ToInt(sData, 0));
    end; }
    Exit;
  end;
  if Length(sDataBlock) < DEFBLOCKSIZE then begin
   { if sDataBlock[1] = '=' then begin
      sData := Copy(sDataBlock, 2, Length(sDataBlock) - 1);
      if sData = 'DIG' then begin
        g_PlayScene.m_MySelf.m_boDigFragment := True;
      end;
    end; }
    Exit;
  end;

  sDefMsg := Copy(sDataBlock, 1, DEFBLOCKSIZE);
  sBody := Copy(sDataBlock, DEFBLOCKSIZE + 1, Length(sDataBlock) - DEFBLOCKSIZE);
  DefMsg := DecodeMessage(sDefMsg);

  //if g_PlayScene.m_MySelf = nil then begin
  case DefMsg.Ident of
    SM_NEWID_SUCCESS: ClientNewIDSuccess();
    SM_NEWID_FAIL: ClientNewIDFail(DefMsg.Recog);
    SM_PASSWD_FAIL: ClientLoginFail(DefMsg.Recog);
    SM_SERVERNAME: ClientGetServerName(@DefMsg, sBody); //获取服务器列表
    SM_PASSOK_SELECTSERVER: ClientGetPasswordOK(DefMsg, sBody);
    SM_SELECTSERVER_OK: ClientGetPasswdSuccess(sBody);
    SM_QUERYCHR: ClientGetReceiveChrs(sBody);
    SM_QUERYCHR_FAIL: ClientQueryChrFail(DefMsg.Recog);
    SM_NEWCHR_SUCCESS: SendQueryChr();
    SM_NEWCHR_FAIL: ClientNewChrFail(DefMsg.Recog);
    SM_DELCHR_SUCCESS: SendQueryChr();

    SM_STARTPLAY: ClientGetStartPlay(sBody);
    SM_STARTFAIL: ClientStartPlayFail();
    SM_VERSION_FAIL: ClientVersionFail();

    SM_OUTOFCONNECTION,
      SM_NEWMAP,
      //SM_LOGON,
    SM_RECONNECT: ;
      //SM_SENDNOTICE: ;

    SM_ABILITY: ClientGetAbility(DefMsg, sBody);
    SM_WINEXP: ClientGetWinExp(DefMsg);
    SM_LEVELUP: ClientGetLevelUp(DefMsg);

    SM_SENDNOTICE: ClientGetSendNotice(sBody);
    SM_LOGON: ClientGetUserLogin(DefMsg, sBody);
  else Exit;
  end;
  //end;

  (*if g_boMapMoving then begin
    if DefMsg.Ident = SM_CHANGEMAP then begin
      g_WaitingMsg := DefMsg;
      g_sWaitingStr := DecodeString(sBody);
      g_boMapMovingWait := True;
      WaitMsgTimer.Enabled := True;
    end;
    Exit;
  end;

  case DefMsg.Ident of
    SM_NEWMAP: ClientGetNewMap(DefMsg, sBody);
    //SM_SERVERCONFIG    :;
    SM_RECONNECT: ClientGetReconnect(sBody);
    SM_TIMECHECK_MSG: CheckSpeedHack(DefMsg.Recog);
    SM_AREASTATE: ClientGetAreaState(DefMsg.Recog);
    SM_MAPDESCRIPTION: ClientGetMapDescription(DefMsg, sBody);
    //SM_GAMEGOLDNAME    :ClientGetGameGoldName(DefMsg,sBody);
    SM_ADJUST_BONUS: ClientGetAdjustBonus(DefMsg.Recog, sBody);
    SM_MYSTATUS: ClientGetMyStatus(DefMsg);
    SM_TURN: ClientGetObjTurn(DefMsg, sBody);
    SM_BACKSTEP: ClientGetBackStep(DefMsg, sBody);

    SM_ABILITY: ClientGetAbility(DefMsg, sBody);
    SM_SUBABILITY: ClientGetSubAbility(DefMsg);
    SM_DAYCHANGING: ClientGetDayChanging(DefMsg);
    SM_WINEXP: ClientGetWinExp(DefMsg);
    SM_LEVELUP: ClientGetLevelUp(DefMsg);
    SM_HEALTHSPELLCHANGED: CliengGetHealthSpellChaged(DefMsg);
    SM_STRUCK: ClientGetStruck(DefMsg, sBody);
    //SM_PASSWORD          :;
    SM_OPENHEALTH: ;
    SM_CLOSEHEALTH: ;
    SM_INSTANCEHEALGUAGE: ;
    SM_BREAKWEAPON: ;

    SM_SENDNOTICE: ClientGetSendNotice(sBody);
    SM_LOGON: ClientGetUserLogin(DefMsg, sBody);
    SM_CRY,
      SM_GROUPMESSAGE,
      SM_GUILDMESSAGE,
      SM_WHISPER,
      SM_SYSMESSAGE: ClientGetMessage(DefMsg, sBody);
    SM_HEAR: ClientHearMsg(DefMsg, sBody);
    SM_USERNAME: ClientGetUserName(DefMsg, sBody);
    SM_CHANGENAMECOLOR: ClientGetUserNameColor(DefMsg);
    SM_HIDE,
      SM_GHOST,
      SM_DISAPPEAR: ClientGetHideObject(DefMsg);
    SM_DIGUP: ClientObjDigup(DefMsg, sBody);
    SM_DIGDOWN: ClientObjDigDown(DefMsg);
    SM_SHOWEVENT: ;
    SM_HIDEEVENT: ;
    SM_ADDITEM: ClientGetAddItem(sBody);
    SM_BAGITEMS: ClientGetBagItmes(sBody);
    SM_UPDATEITEM: ClientGetUpdateItem(sBody);
    SM_DELITEM: ClientGetDelItem(sBody);
    SM_DELITEMS: ClientGetDelItems(sBody);
    SM_DROPITEM_SUCCESS: ClientDelDropItem(DefMsg.Recog, sBody);
    SM_DROPITEM_FAIL: ClientGetDropItemFail(DefMsg.Recog, sBody);
    SM_ITEMSHOW: ClientGetShowItem(DefMsg.Recog, DefMsg.param {x}, DefMsg.Tag {y}, DefMsg.Series {looks}, DecodeString(sBody));
    SM_ITEMHIDE: ClientGetHideItem(DefMsg.Recog, DefMsg.param, DefMsg.Tag);
    SM_OPENDOOR_OK: ; //Map.OpenDoor (msg.param, msg.tag);
    SM_OPENDOOR_LOCK: ; //DScreen.AddSysMsg ('此门被锁定！');
    SM_CLOSEDOOR: ; //Map.CloseDoor (msg.param, msg.tag);
    SM_TAKEON_OK: ClientGetTakeOnOK(DefMsg.Recog);
    SM_TAKEON_FAIL: ClientGetTakeOnFail();
    SM_TAKEOFF_OK: ClientGetTakeOffOK(DefMsg.Recog);
    SM_TAKEOFF_FAIL: ClientGetTakeOffFail();
    SM_EXCHGTAKEON_OK: ;
    SM_EXCHGTAKEON_FAIL: ;
    SM_SENDUSEITEMS: ClientGetSenduseItems(sBody);
    SM_WEIGHTCHANGED: ClientGetWeightChanged(DefMsg);
    SM_GOLDCHANGED: ClientGetGoldChanged(DefMsg);
    SM_FEATURECHANGED: ClientGetFeatureChange(DefMsg);
    SM_CHARSTATUSCHANGED: ClientGetCharStatusChange(DefMsg);
    SM_CLEAROBJECTS: ClientGetClearObjects();
    SM_EAT_OK: ClientGetEatItemOK();
    SM_EAT_FAIL: ClientGetEatItemFail();
    SM_ADDMAGIC: ClientGetAddMagic(sBody);
    SM_SENDMYMAGIC: ClientGetMyMagics(sBody);
    SM_DELMAGIC: ClientGetDelMagic(DefMsg.Recog);
    SM_MAGIC_LVEXP: ClientGetMagicLevelUp(DefMsg);
    SM_DURACHANGE: ClientGetDuraChange(DefMsg);
    SM_MERCHANTSAY: ClientGetMerchantSay(DefMsg, sBody);
    SM_MERCHANTDLGCLOSE: ClientGetMerchantClose();
    SM_SENDGOODSLIST: ClientGetSendGoodsList(DefMsg, sBody);
    SM_SENDUSERMAKEDRUGITEMLIST: ClientGetSendMakeDrugList(DefMsg, sBody);
    SM_SENDUSERSELL: ClientGetSendUserSell(DefMsg.Recog);
    SM_SENDUSERREPAIR: ClientGetSendUserRepair(DefMsg.Recog);
    SM_SENDBUYPRICE: ClientGetBuyPrice(DefMsg);
    SM_USERSELLITEM_OK: ClientGetUserSellItemOK();
    SM_SENDREPAIRCOST: ClientGetRepairCost(DefMsg);
    SM_USERREPAIRITEM_OK: ;
    SM_USERREPAIRITEM_FAIL: ;
    SM_STORAGE_OK,
      SM_STORAGE_FULL,
      SM_STORAGE_FAIL: ;
    SM_SAVEITEMLIST: ;
    SM_TAKEBACKSTORAGEITEM_OK,
      SM_TAKEBACKSTORAGEITEM_FAIL,
      SM_TAKEBACKSTORAGEITEM_FULLBAG: ;
    SM_DLGMSG, SM_MENU_OK: ClientMessageBox(sBody);
  end;*)
end;

end.

