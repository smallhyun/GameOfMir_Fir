unit PlugManage;

interface

uses
  Windows, Classes, SysUtils, ExtCtrls, JSocket, EncryptUnit, CShare, Grobal2, Forms;
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
  TPlugManage = class(TThread)
    ClientSocket: TClientSocket;
    SocketStream: TWinSocketStream;
    CheckStatus: TCheckStatus;
    CheckStep: TCheckLicenseStatus;
    m_ServerAddrIndex: Integer;
    m_nRemoteAddr: Integer;
    m_sReviceMsg: string;
    m_sBufferText: string;
  private
    Timer: TTimer;
    m_dwConnTick: LongWord;
    m_boGetFromIPArray: Boolean;
    m_boSendGetLicense: Boolean;
    m_nPortIndex: Integer;
    m_sUserIPAddr: string;
    m_nServerAddrIndex: Integer;
    m_sServerAddr: array[0..1] of string;
    m_nServerPort: Integer;
    m_nUsrEngnRunAddr: Integer;
    m_nRunSocketRunAddr: Integer;
    m_btCode: Byte;
    m_nCheckLicenseFail: Integer;
    m_nConnectCount: Integer;
    procedure OnTimer(Sender: TObject);
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket); //dynamic;
    procedure ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket); //dynamic;
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer); //dynamic;
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket); //dynamic;


    procedure ClientGetConfig(sData: string);
    procedure ClientGetBadAddr(sData: string);

    procedure ProcessServerPacket(); //dynamic;

    procedure SendLicenseMsg(); //dynamic;
    procedure SendGetBadAddress;
    procedure SendSocket(DefMsg: TDefaultMessage; sMsg: string); //dynamic;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean); //dynamic;
    destructor Destroy; override;
    procedure LoadUserLicense(); //virtual;
  end;
function DeleteHttp(sAddr: string): string;
function GetCheckPageList(sAddr: string): Boolean;
procedure AddCheckPageList(sAddr: string);

function GetCheckBadPageList(sAddr: string): Boolean;
procedure AddCheckBadPageList(sAddr: string);
var
  dwLocalTick: LongWord;
  dwServerTick: LongWord;
  PlugEngine: TPlugManage;
  p_Buffer: PChar;
  p_OldBuffer: PChar;
  p_SetProc: TSetProc;
  p_GetProc: TGetProc;
  CheckPageList: TStringList;
  CheckBadPageList: TStringList;
  //MainForm: pTFormData;
implementation
uses HUtil32;
const
  CM_GETCLIENTCONFIG = 1;
  CM_GETBADADDRESS = 2;

  SM_CLIENTCONFIG = 11;
  SM_BADADDRESS = 12;
var
  g_HashValue: Integer;
  g_ReviceHashValue: Integer;

function GetOSVersion: Integer; //获取系统版本
var
  osVerInfo: TOSVersionInfo;
  majorVer, minorVer: Integer;
begin
  Result := cOsUnknown;
  osVerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  if (GetVersionEx(osVerInfo)) then begin
    majorVer := osVerInfo.dwMajorVersion;
    minorVer := osVerInfo.dwMinorVersion;
    case (osVerInfo.dwPlatformId) of
      VER_PLATFORM_WIN32_NT: { Windows NT/2000 }
        begin
          if (majorVer <= 4) then
            Result := cOsWinNT
          else
            if ((majorVer = 5) and (minorVer = 0)) then
            Result := cOsWin2000
          else
            if ((majorVer = 5) and (minorVer = 1)) then
            Result := cOsWXP
          else
            if ((majorVer = 5) and (minorVer = 2)) then
            Result := cOsWin2003
          else
            if ((majorVer = 6) and (minorVer = 0)) then
            Result := cOsWVista
          else
            //Showmessage('majorVer:'+IntToStr(majorVer)+' minorVer:'+IntToStr(minorVer));
            Result := cOsUnknown;
        end;
      VER_PLATFORM_WIN32_WINDOWS: { Windows 9x/ME }
        begin
          if ((majorVer = 4) and (minorVer = 0)) then
            Result := cOsWin95
          else if ((majorVer = 4) and (minorVer = 10)) then begin
            if (osVerInfo.szCSDVersion[1] = 'A') then
              Result := cOsWin98SE
            else
              Result := cOsWin98;
          end else if ((majorVer = 4) and (minorVer = 90)) then
            Result := cOsWinME
          else
            Result := cOsUnknown;
        end;
    else
      Result := cOsUnknown;
    end;
  end else
    Result := cOsUnknown;
end;

function AnsiContainsText(const AText, ASubText: string): Boolean;
begin
  Result := AnsiPos(AnsiUpperCase(ASubText), AnsiUpperCase(AText)) > 0;
end;

function DeleteHttp(sAddr: string): string;
begin
  Result := sAddr;
  if Pos('://', sAddr) > 0 then begin //http    uppercase
    if (UpperCase(sAddr[1]) = 'H') and (UpperCase(sAddr[2]) = 'T') and (UpperCase(sAddr[3]) = 'T') and (UpperCase(sAddr[4]) = 'P') then begin
      sAddr := Copy(sAddr, 8, Length(sAddr));
    end else begin
      sAddr := Copy(sAddr, Pos('://', sAddr) + 1, Length(sAddr));
    end;
  end;
  while (sAddr <> '') and (sAddr[Length(sAddr)] = '/') do sAddr := Copy(sAddr, 1, Length(sAddr) - 1);
  Result := sAddr;
end;

procedure AddCheckPageList(sAddr: string);
var
  I: Integer;
  S: string;
begin
  S := DeleteHttp(sAddr);
  if S = '' then Exit;
  for I := 0 to CheckPageList.Count - 1 do begin
    if CompareText(CheckPageList.Strings[I], S) = 0 then Exit;
  end;
  CheckPageList.Add(S);
end;

procedure AddAllCheckPageList();
begin
  AddCheckPageList(DecryptString(g_DataEngine.sHomePage));
  AddCheckPageList(DecryptString(g_DataEngine.sOpenPage1));
  AddCheckPageList(DecryptString(g_DataEngine.sOpenPage2));
  AddCheckPageList(DecryptString(g_DataEngine.sClosePage1));
  AddCheckPageList(DecryptString(g_DataEngine.sClosePage2));
end;

function GetCheckPageList(sAddr: string): Boolean;
var
  I: Integer;
  S: string;
begin
  Result := True;
  S := DeleteHttp(sAddr);
  for I := 0 to CheckPageList.Count - 1 do begin
    if CompareText(CheckPageList.Strings[I], S) = 0 then Exit;
  end;
  Result := False;
end;


{------------------------------------------------------------------------------}

procedure AddCheckBadPageList(sAddr: string);
var
  I: Integer;
  S: string;
begin
  S := DeleteHttp(sAddr);
  if S = '' then Exit;
  for I := 0 to CheckBadPageList.Count - 1 do begin
    if AnsiContainsText(CheckBadPageList.Strings[I], S) or AnsiContainsText(S, CheckBadPageList.Strings[I]) then Exit;
  end;
  CheckBadPageList.Add(S);
end;

procedure AddAllCheckBadPageList();
var
  I: Integer;
  sData, sText: string;
  nLen: Integer;
  Buffers: TBuffers;
begin
  Move(p_Buffer^, nLen, SizeOf(Integer));
  if (nLen > 0) then begin
    SetLength(sText, nLen);
    Move(p_Buffer[SizeOf(Integer)], sText[1], nLen);
    while True do begin
      if sText = '' then Break;
      sText := GetValidStr3(sText, sData, ['|']);
      if sData <> '' then begin
        SetLength(Buffers, Length(Buffers) + 1);
        Buffers[Length(Buffers) - 1] := DecryptString(sData);
      end else break;
    end;

    for I := 0 to Length(Buffers) - 1 do begin
      if Buffers[I] <> '' then begin
        AddCheckBadPageList(Buffers[I]);
      end;
    end;
  end;
  //CheckBadPageList.SaveToFile('CheckBadPageList.txt');
end;

function GetCheckBadPageList(sAddr: string): Boolean;
var
  I: Integer;
  S: string;
begin
  Result := False;
  S := DeleteHttp(sAddr);
  for I := 0 to CheckBadPageList.Count - 1 do begin
    if AnsiContainsText(CheckBadPageList.Strings[I], S) or AnsiContainsText(S, CheckBadPageList.Strings[I]) then Exit;
  end;
  Result := True;
end;
{procedure SendOutStr(Msg: string);
var
  flname: string;
  FHandle: TextFile;
begin
  //Exit;
  flname := 'OutStr.txt'; //'D:\GameOfMir\工具\外挂\OutStr.txt';
  if FileExists(flname) then begin
    AssignFile(FHandle, flname);
    Append(FHandle);
  end else begin
    AssignFile(FHandle, flname);
    Rewrite(FHandle);
  end;
  Writeln(FHandle, TimeToStr(Time) + ' ' + Msg);
  CloseFile(FHandle);
end;}

{ ThreadPlug }

procedure TPlugManage.ClientSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  m_dwConnTick := GetTickCount;
  CheckStatus := c_Connected;
  //SendLicenseMsg;
  //SendOutStr(Socket.RemoteAddress + '  ClientSocketConnect m_sServerAddr[m_ServerAddrIndex]:' + m_sServerAddr[m_ServerAddrIndex] + ' ' + m_sServerAddr[m_ServerAddrIndex]);
end;

procedure TPlugManage.ClientSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if CheckStatus <> c_CheckOK then CheckStatus := c_CheckError;
  //SendOutStr(Socket.RemoteAddress + '  ClientSocketDisconnect Inc(m_ServerAddrIndex):' + m_sServerAddr[m_ServerAddrIndex] + ' ' + m_sServerAddr[m_ServerAddrIndex]);
{  if CheckStatus <> c_CheckOK then begin
    //SendOutStr('ClientSocketDisconnect Inc(m_ServerAddrIndex):'+IntToStr(m_ServerAddrIndex));
    if m_ServerAddrIndex < Length(m_sServerAddr) - 1 then begin
      Inc(m_ServerAddrIndex);
      CheckStatus := c_Idle;

    end else CheckStatus := c_CheckError;
  end;}
end;

procedure TPlugManage.ClientSocketError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
  if CheckStatus <> c_CheckOK then CheckStatus := c_CheckError;

  //SendOutStr('ClientSocketError Inc(m_ServerAddrIndex):' + IntToStr(m_ServerAddrIndex));

 { if CheckStatus <> c_CheckOK then begin
    if m_ServerAddrIndex < Length(m_sServerAddr) - 1 then begin
      Inc(m_ServerAddrIndex);
      CheckStatus := c_Idle;

    end else CheckStatus := c_CheckError;
  end;  }
end;

procedure TPlugManage.ClientSocketRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  //m_sReviceMsg := m_sReviceMsg + Socket.ReceiveText;
  m_sBufferText := m_sBufferText + Socket.ReceiveText;
  //SendOutStr(Socket.RemoteAddress + '  ' + m_sBufferText);
end;

procedure TPlugManage.OnTimer(Sender: TObject);
begin
  if (CheckStatus = c_Idle) then begin
    m_sReviceMsg := '';
    m_sBufferText := '';
    m_dwConnTick := GetTickCount;
    CheckStatus := c_Connect;
    ClientSocket.Active := False;
    ClientSocket.Address := m_sServerAddr[m_ServerAddrIndex]; //'219.153.7.78';
    ClientSocket.Port := m_nServerPort; //37000;
    CheckStep := cl_None;
    //SendOutStr('m_sServerAddr[m_ServerAddrIndex]:' + m_sServerAddr[m_ServerAddrIndex] + ' m_ServerAddrIndex:' + IntToStr(m_ServerAddrIndex));
    try
      ClientSocket.Active := True;
    except
      CheckStatus := c_CheckError;
    end;
  end else
    if (CheckStatus = c_CheckOK) or (CheckStatus = c_CheckFail) then begin
    //SendOutStr('(CheckStatus = c_CheckOK)');
    g_DataEngine.CheckStatus := CheckStatus;
    Timer.Enabled := False;
    ClientSocket.Active := False;
    AddAllCheckPageList();
    AddAllCheckBadPageList();
    Exit;
    //if (CheckStatus = c_CheckOK) then SendOutStr('(CheckStatus = c_CheckOK)');
  end else
  if CheckStatus = c_Connected then begin
    if ClientSocket.Socket.Connected then begin
{$IF USERVERSION <> 10}
      if ClientSocket.Socket.LocalAddress = ClientSocket.Socket.RemoteAddress then begin
        CheckStatus := c_CheckFail;
        Exit;
      end;
{$IFEND}
      if GetTickCount - m_dwConnTick > 1000 * 10 then begin
        ClientSocket.Active := False;
        Exit;
      end;
      case CheckStep of
        cl_None: begin
            m_dwConnTick := GetTickCount;
            CheckStep := cl_GetAddressing;
            SendGetBadAddress;

            //SendOutStr(ClientSocket.Socket.RemoteAddress + ' SendGetBadAddress;');
          end;
        cl_GetAddressing: ;

        cl_GetAddressOK: begin
            m_dwConnTick := GetTickCount;
            CheckStep := cl_GetLicenseing;
            SendLicenseMsg;
            //SendOutStr(ClientSocket.Socket.RemoteAddress + ' SendLicenseMsg');
            //SendOutStr('SendLicenseMsg;');
          end;

        cl_GetLicenseing: ;
        cl_GetLicenseOK: begin
          CheckStatus := c_CheckOK;
          //SendOutStr(ClientSocket.Socket.RemoteAddress + ' CheckStatus := c_CheckOK');
        end;
      end;
    end;
  end else
    if (CheckStatus = c_CheckError) then begin
    if m_ServerAddrIndex < Length(m_sServerAddr) - 1 then begin
      Inc(m_ServerAddrIndex);
      CheckStatus := c_Idle;
    end else CheckStatus := c_CheckFail;
  end;
  ProcessServerPacket;
end;

constructor TPlugManage.Create(CreateSuspended: Boolean);
begin
  inherited;
  LoadUserLicense();

  m_boGetFromIPArray := False;
  m_boSendGetLicense := False;
  m_sReviceMsg := '';
  m_sBufferText := '';
  m_nPortIndex := 0;
  CheckStatus := c_Idle;
  CheckStep := cl_None;
  //g_DataEngine.CheckStatus := CheckStatus;
  g_HashValue := Random(10000);
  g_ReviceHashValue := Random(10000);
  m_nConnectCount := 0;
  m_nServerAddrIndex := 0;
  m_dwConnTick := 0;

  ClientSocket := TClientSocket.Create(nil);
  ClientSocket.ClientType := ctNonBlocking; //ctNonBlocking;   ctBlocking;
  ClientSocket.OnConnect := ClientSocketConnect;
  ClientSocket.OnDisconnect := ClientSocketDisconnect;
  ClientSocket.OnError := ClientSocketError;
  ClientSocket.OnRead := ClientSocketRead;

  Timer := TTimer.Create(nil);
  Timer.Interval := 1;
  Timer.OnTimer := OnTimer;
  Timer.Enabled := True;
end;

destructor TPlugManage.Destroy;
begin
  Timer.Free;
  ClientSocket.Free;
  inherited;
end;

procedure TPlugManage.ClientGetConfig(sData: string);
var
  ServerInfo: TServerInfo;
  nCheck1: Integer;
  nCheck2: Integer;
  nCode: Integer;
begin
  DecryptBuffer(sData, @ServerInfo, SizeOf(TServerInfo));
  if (CheckStep = cl_GetLicenseing) and (ServerInfo.Address = MakeIPToInt(m_sServerAddr[m_ServerAddrIndex])) and (g_DataEngine.Error = 0) then begin
    //SendOutStr('(CheckStep = cl_GetLicenseing) and (ServerInfo.Address = MakeIPToInt(m_sServerAddr[m_ServerAddrIndex])) and (g_DataEngine.Error = 0)');

    nCode := 3;
    nCheck1 := g_DataEngine.Error;
    nCheck2 := nCheck1;

          //SendOutStr('Error3:' + IntToStr(nCheck1));
    nCheck1 := nCheck1 + abs(ServerInfo.AddressHash - g_HashValue);
          //SendOutStr('Error4:' + IntToStr(nCheck1));
          //if ServerInfo.Random1 <= 0 then nCheck1 := Random(1000);
          //SendOutStr('Error5:' + IntToStr(nCheck1));
    if nCheck2 <> nCheck1 then g_DataEngine.Error := nCheck1;

         { SendOutStr('ServerInfo.AddressTextHash:' + IntToStr(ServerInfo.AddressTextHash));
          SendOutStr('g_HashValue:' + IntToStr(g_HashValue));

          SendOutStr('ServerInfo.sConfig:' + ServerInfo.sConfig);
          SendOutStr('ServerInfo.Random1:' + IntToStr(ServerInfo.Random1));
          SendOutStr('ServerInfo.Random2:' + IntToStr(ServerInfo.Random2));
          SendOutStr('ServerInfo.nCode:' + IntToStr(ServerInfo.nCode));
          SendOutStr('HashPJW(ServerInfo.sConfig):' + IntToStr(HashPJW(ServerInfo.sConfig))); }

    if ClientSocket.Socket.SocketHandle = ServerInfo.SocketHandle then begin
      //SendOutStr('ClientSocket.Socket.SocketHandle = ServerInfo.SocketHandle');

      g_DataEngine.sHomePage := EncryptString(ServerInfo.ServerConfig.sHomePage);
      g_DataEngine.sOpenPage1 := EncryptString(ServerInfo.ServerConfig.sOpenPage1);
      g_DataEngine.sOpenPage2 := EncryptString(ServerInfo.ServerConfig.sOpenPage2);
      g_DataEngine.sClosePage1 := EncryptString(ServerInfo.ServerConfig.sClosePage1);
      g_DataEngine.sClosePage2 := EncryptString(ServerInfo.ServerConfig.sClosePage2);
      g_DataEngine.sSayMessage1 := EncryptString(ServerInfo.ServerConfig.sSayMessage1);
      g_DataEngine.sSayMessage2 := EncryptString(ServerInfo.ServerConfig.sSayMessage2);

      g_DataEngine.nHomePage := HashPJW(g_DataEngine.sHomePage);
      g_DataEngine.nOpenPage1 := HashPJW(g_DataEngine.sOpenPage1);
      g_DataEngine.nOpenPage2 := HashPJW(g_DataEngine.sOpenPage2);
      g_DataEngine.nClosePage1 := HashPJW(g_DataEngine.sClosePage1);
      g_DataEngine.nClosePage2 := HashPJW(g_DataEngine.sClosePage2);
      g_DataEngine.nSayMessage1 := HashPJW(g_DataEngine.sSayMessage1);
      g_DataEngine.nSayMessage2 := HashPJW(g_DataEngine.sSayMessage2);

      g_DataEngine.Data.SayMsgTime := ServerInfo.ServerConfig.nSayMsgTime;

      g_DataEngine.boOpenPage1 := ServerInfo.ServerConfig.boOpenPage1;
      g_DataEngine.boOpenPage2 := ServerInfo.ServerConfig.boOpenPage2;
      g_DataEngine.boClosePage1 := ServerInfo.ServerConfig.boClosePage1;
      g_DataEngine.boClosePage2 := ServerInfo.ServerConfig.boClosePage2;

      g_DataEngine.AllowUpData := ServerInfo.ServerConfig.boAllowUpData;
      g_DataEngine.CompulsiveUpdata := ServerInfo.ServerConfig.boCompulsiveUpdata;
      g_DataEngine.MD5 := ServerInfo.ServerConfig.sMD5;
      g_DataEngine.UpdataAddr := ServerInfo.ServerConfig.sUpdataAddr;

      g_DataEngine.CheckNoticeUrl := ServerInfo.ServerConfig.boCheckNoticeUrl;
      g_DataEngine.WriteHosts := ServerInfo.ServerConfig.boWriteHosts;
      g_DataEngine.HostsAddress := ServerInfo.ServerConfig.nHostsAddress;
      g_DataEngine.WriteUrlEntry := ServerInfo.ServerConfig.boWriteUrlEntry;

      g_DataEngine.CheckOpenPage := ServerInfo.ServerConfig.boCheckOpenPage;
      g_DataEngine.CheckConnectPage := ServerInfo.ServerConfig.boCheckConnectPage;


      g_DataEngine.CheckParent := ServerInfo.ServerConfig.boCheckParent;

      g_DataEngine.Check1 := ServerInfo.ServerConfig.boCheck1;
      g_DataEngine.Check2 := ServerInfo.ServerConfig.boCheck2;
      g_DataEngine.Check3 := ServerInfo.ServerConfig.boCheck3;
      g_DataEngine.Check4 := ServerInfo.ServerConfig.boCheck4;
      g_DataEngine.Check5 := ServerInfo.ServerConfig.boCheck5;
      g_DataEngine.Check6 := ServerInfo.ServerConfig.boCheck6;
      g_DataEngine.Check7 := ServerInfo.ServerConfig.boCheck7;
      g_DataEngine.Check8 := ServerInfo.ServerConfig.boCheck8;
      g_DataEngine.Check9 := ServerInfo.ServerConfig.boCheck9;
      g_DataEngine.Check10 := ServerInfo.ServerConfig.boCheck10;

      g_DataEngine.CqfirVersion := SysVersion;
      //CheckStatus := c_CheckOK;
      CheckStep := cl_GetLicenseOK;

      //SendOutStr('cl_GetLicenseOK:' + IntToStr(g_DataEngine.Error));
    end else begin
      g_DataEngine.CheckNoticeUrl := True;
      g_DataEngine.AllowUpData := True;
      g_DataEngine.CompulsiveUpdata := True;
      g_DataEngine.WriteHosts := True;
      g_DataEngine.WriteUrlEntry := True;
      //SendOutStr('GM_CHECKSERVER:3');
    end;
          {SendOutStr('ClientSocket.Socket.SocketHandle:'+IntToStr(ClientSocket.Socket.SocketHandle));
          SendOutStr('ServerInfo.SocketHandle:'+IntToStr(ServerInfo.SocketHandle));}
         { if ServerInfo.nVersion <> SysVersion then
            CheckStatus := c_Upgrade
          else CheckStatus := c_CheckOK; }

         { SendOutStr('TPlugManage.ProcessServerPacket OK');
          SendOutStr('g_DataEngine.CheckHash:'+BoolToStr(g_DataEngine.CheckHash));
          SendOutStr('g_DataEngine.CheckNoticeUrl:'+BoolToStr(g_DataEngine.CheckNoticeUrl));
          SendOutStr('g_DataEngine.NeedDecrypt:'+BoolToStr(g_DataEngine.NeedDecrypt));
          SendOutStr('g_DataEngine.WriteHosts:'+BoolToStr(g_DataEngine.WriteHosts));
          SendOutStr('g_DataEngine.WriteUrlEntry:'+BoolToStr(g_DataEngine.WriteUrlEntry));
          SendOutStr('g_DataEngine.HashValue:'+IntToStr(g_DataEngine.HashValue));
          SendOutStr('g_DataEngine.HostsAddress:'+IntToStr(g_DataEngine.HostsAddress)); }
  end else begin
          //SendOutStr('ServerInfo.Address:' + IntToStr(ServerInfo.Address));
    CheckStatus := c_CheckFail;
    g_DataEngine.Error := Random(1000);
  end;
end;

procedure TPlugManage.ClientGetBadAddr(sData: string);
var
  nDataLen: Integer;
begin
  if (CheckStep < cl_GetAddressOK) then begin
    g_HashValue := HashPJW(sData);
    nDataLen := Length(sData);
    ReallocMem(p_Buffer, nDataLen + SizeOf(Integer));

    Move(nDataLen, p_Buffer^, SizeOf(Integer));
    Move(sData[1], p_Buffer[SizeOf(Integer)], nDataLen);
    p_SetProc(p_Buffer);

    //SendOutStr('cl_GetAddressOK:' + IntToStr(g_DataEngine.Error));
    CheckStep := cl_GetAddressOK;
  end;
end;

procedure TPlugManage.ProcessServerPacket;
var
  nDataLen: Integer;
  sData: string;
  sDefMsg: string;
  sDataMsg: string;
  sSendMsg: string;
  DefMsg: TDefaultMessage;
  ServerInfo: TServerInfo;
  sConfigAddr: string;
  nCode: Integer;
  Buff: PChar; //使用VMProtect的SDK
  Buffers: TBuffers;
  P: Pointer;
  nCheck1: Integer;
  nCheck2: Integer;
  dwTimeTick: LongWord;
begin
  try
    nCode := 0;
    m_sReviceMsg := m_sReviceMsg + m_sBufferText;
    m_sBufferText := '';
    if Pos('!', m_sReviceMsg) <= 0 then Exit;
    m_sReviceMsg := ArrestStringEx(m_sReviceMsg, '#', '!', sData);
    nDataLen := Length(sData);
    //SendOutStr('ProcessServerPacket1');
//{$I VMProtectBeginVirtualization.inc}
    if nDataLen >= DEFBLOCKSIZE + 12 then begin
      nCode := 1;
      //SendOutStr('ProcessServerPacket2');
      sDefMsg := Copy(sData, 1, DEFBLOCKSIZE + 12);
      sDataMsg := Copy(sData, DEFBLOCKSIZE + 12 + 1, Length(sData) - (DEFBLOCKSIZE + 12));
      //DefMsg := DecodeMessage(sDefMsg);
      DecryptBuffer(sDefMsg, @DefMsg, SizeOf(TDefaultMessage));
      nCode := 2;
      case DefMsg.Ident of
        SM_CLIENTCONFIG: ClientGetConfig(sDataMsg);
        SM_BADADDRESS: ClientGetBadAddr(sDataMsg);
      else begin
          CheckStatus := c_CheckFail;
          g_DataEngine.Error := Random(1000);
        end;
      end;
    end else begin
      //SendOutStr('if nDataLen >= DEFBLOCKSIZE then begin');
      CheckStatus := c_CheckFail;
      g_DataEngine.Error := Random(1000);
    end;
//{$I VMProtectEnd.inc}
  except
    CheckStatus := c_CheckFail;
    g_DataEngine.Error := Random(1000);
  end;
  //m_sReviceMsg := '';
end;

procedure TPlugManage.Execute;
begin

end;

procedure TPlugManage.LoadUserLicense; //127.0.0.1   16777343
begin
  m_nServerPort := 5182;
{$IF USERVERSION = 0}
  m_sServerAddr[0] := MakeIntToIP(93851257); //121.14.152.5
  m_sServerAddr[1] := MakeIntToIP(-1595949508); //60.190.223.160
{$IFEND}

{$IF USERVERSION = 1}
  m_sServerAddr[0] := MakeIntToIP(-495973767); //121.10.112.226
  m_sServerAddr[1] := MakeIntToIP(-495973767); //121.10.112.226
{$IFEND}

{$IF USERVERSION = 2}
  m_sServerAddr[0] := MakeIntToIP(93851257); //121.14.152.5
  m_sServerAddr[1] := MakeIntToIP(-1595949508); //60.190.223.160
{$IFEND}

{$IF USERVERSION = 3}
  m_sServerAddr[0] := MakeIntToIP(1854803577); //121.14.142.110
  m_sServerAddr[1] := MakeIntToIP(1854803577); //121.14.142.110
  //m_nServerPort := 4561;
{$IFEND}

{$IF USERVERSION = 4}
  m_sServerAddr[0] := MakeIntToIP(-1323049670); //58.221.35.177
  m_sServerAddr[1] := MakeIntToIP(-1323049670); //58.221.35.177
  //m_nServerPort := 4561;
{$IFEND}

{$IF USERVERSION = 5}
  m_sServerAddr[0] := MakeIntToIP(-1945771910); //122.224.5.140
  m_sServerAddr[1] := MakeIntToIP(-1945771910); //122.224.5.140
  //m_nServerPort := 4561;
{$IFEND}

{$IF USERVERSION = 6}
  m_sServerAddr[0] := MakeIntToIP(-539685255); //121.14.213.223
  m_sServerAddr[1] := MakeIntToIP(-539685255); //121.14.213.223
  //m_nServerPort := 4561;
{$IFEND}

{$IF USERVERSION = 7}
  m_sServerAddr[0] := MakeIntToIP(74124409); //121.12.107.4
  m_sServerAddr[1] := MakeIntToIP(74124409); //121.12.107.4
  //m_nServerPort := 4561;
{$IFEND}

{$IF USERVERSION = 10}
  m_sServerAddr[0] := MakeIntToIP(16777343); //127.0.0.1
  m_sServerAddr[1] := MakeIntToIP(16777343); //127.0.0.1
  //m_nServerPort := 4561;
{$IFEND}
end;

procedure TPlugManage.SendLicenseMsg;
var
  DefMsg: TDefaultMessage;
  sSendMsg, sUserLiense: string;
  ClientInfo: TClientInfo;
  Buff: PChar;
begin
  dwServerTick := GetTickCount;
  DefMsg.Ident := CM_GETCLIENTCONFIG;
  DefMsg.Recog := MakeIPToInt(m_sServerAddr[m_ServerAddrIndex]);
  DefMsg.Param := 0;
  DefMsg.Tag := HiWord(SysVersion); //增加
  DefMsg.Series := LoWord(SysVersion); //增加
  ClientInfo.Address := MakeIPToInt(m_sServerAddr[m_ServerAddrIndex]);
  ClientInfo.nVersion := GetOSVersion;
  ClientInfo.nEXEVersion := SysVersion;
  ClientInfo.nSocketHandle := ClientSocket.Socket.SocketHandle;
  sUserLiense := g_DataEngine.sUserLiense;
  Buff := @ClientInfo.sConfig;
  Move(sUserLiense[1], Buff^, SizeOf(TText));
  ClientInfo.nCode := g_DataEngine.nUserLiense;
  SendSocket(DefMsg, EncryptBuffer(@ClientInfo, SizeOf(TClientInfo)));
end;

procedure TPlugManage.SendGetBadAddress;
var
  DefMsg: TDefaultMessage;
  sSendMsg, sUserLiense: string;
  ClientInfo: TClientInfo;
  Buff: PChar;
begin
  dwServerTick := GetTickCount;
  DefMsg.Ident := CM_GETBADADDRESS;
  DefMsg.Recog := MakeIPToInt(m_sServerAddr[m_ServerAddrIndex]);
  DefMsg.Param := 0;
  DefMsg.Tag := HiWord(SysVersion); //增加
  DefMsg.Series := LoWord(SysVersion); //增加
  ClientInfo.Address := MakeIPToInt(m_sServerAddr[m_ServerAddrIndex]);
  ClientInfo.nVersion := GetOSVersion;
  ClientInfo.nEXEVersion := SysVersion;
  ClientInfo.nSocketHandle := ClientSocket.Socket.SocketHandle;
  sUserLiense := g_DataEngine.sUserLiense;
  Buff := @ClientInfo.sConfig;
  Move(sUserLiense[1], Buff^, SizeOf(TText));
  ClientInfo.nCode := g_DataEngine.nUserLiense;
  SendSocket(DefMsg, EncryptBuffer(@ClientInfo, SizeOf(TClientInfo)));
end;

procedure TPlugManage.SendSocket(DefMsg: TDefaultMessage; sMsg: string);
var
  sSendMsg: string;
begin
  if ClientSocket.Socket.Connected then begin
    sSendMsg := '#' + EncryptBuffer(@DefMsg, SizeOf(TDefaultMessage)) + sMsg + '!';
    ClientSocket.Socket.SendText(sSendMsg);
  end;
end;

end.

