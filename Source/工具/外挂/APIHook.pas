unit APIHook;

interface

uses
  Windows, SysUtils, WinSock, JSocket;

type
  WSABUF = packed record
    len: U_LONG; { the length of the buffer }
    buf: PChar; { the pointer to the buffer }
  end {WSABUF};
  PWSABUF = ^WSABUF;
  LPWSABUF = PWSABUF;

  TServiceType = LongInt;

  TFlowSpec = packed record
    TokenRate, // In Bytes/sec
      TokenBucketSize, // In Bytes
      PeakBandwidth, // In Bytes/sec
      Latency, // In microseconds
      DelayVariation: LongInt; // In microseconds
    ServiceType: TServiceType;
    MaxSduSize, MinimumPolicedSize: LongInt; // In Bytes
  end;
  PFlowSpec = ^TFLOWSPEC;

  QOS = packed record
    SendingFlowspec: TFlowSpec; { the flow spec for data sending }
    ReceivingFlowspec: TFlowSpec; { the flow spec for data receiving }
    ProviderSpecific: WSABUF; { additional provider specific stuff }
  end;
  TQualityOfService = QOS;
  PQOS = ^QOS;
  LPQOS = PQOS;

  WSAOVERLAPPED = TOverlapped;
  TWSAOverlapped = WSAOverlapped;
  PWSAOverlapped = ^WSAOverlapped;
  LPWSAOVERLAPPED = PWSAOverlapped;

  GROUP = DWORD;

  LPCONDITIONPROC = function(lpCallerId: LPWSABUF; lpCallerData: LPWSABUF;
    lpSQOS, lpGQOS: LPQOS; lpCalleeId, lpCalleeData: LPWSABUF;
    g: GROUP; dwCallbackData: DWORD): Integer; stdcall;
  LPWSAOVERLAPPED_COMPLETION_ROUTINE = procedure(const dwError, cbTransferred:
    DWORD; const lpOverlapped: LPWSAOVERLAPPED; const dwFlags: DWORD); stdcall;


 //要HOOK的API函数定义
  TSockProc = function(s: TSocket; var Buf; len, flags: Integer): Integer; stdcall;
  TConnect = function(const s: TSocket; const Name: PSockAddr; const namelen: Integer): Integer; stdcall;
  TGetTickCount = function: DWORD; stdcall;
  TWSioctlsocket = function(s: TSocket; cmd: DWORD; var arg: u_long): Integer; stdcall;
  TWSAAsyncSelect = function(s: TSocket; HWindow: HWND; wMsg: u_int; lEvent: Longint): Integer; stdcall;
  TWSARecv = function(s: TSocket; lpBuffers: LPWSABUF; dwBufferCount: DWORD; var
    lpNumberOfBytesRecvd: DWORD; var lpFlags: DWORD;
    lpOverlapped: LPWSAOVERLAPPED; lpCompletionRoutine:
    LPWSAOVERLAPPED_COMPLETION_ROUTINE): Integer; stdcall;

  PJmpCode = ^TJmpCode;
  TJmpCode = packed record
    JmpCode: BYTE;
    Address: Pointer;
    MovEAX: array[0..2] of BYTE;
  end;

 //--------------------函数声明---------------------------
procedure HookAPI;
procedure UnHookAPI;

function MyConnect(const s: TSocket; const Name: PSockAddr; const namelen: Integer): Integer; stdcall;


function MySend(s: TSocket; var Buf; len, flags: Integer): Integer; stdcall;
function MyRecv(s: TSocket; var Buf; len, flags: Integer): Integer; stdcall;
function MyWSioctlsocket(s: TSocket; cmd: DWORD; var arg: u_long): Integer; stdcall;
function MyWSAAsyncSelect(s: TSocket; HWindow: HWND; wMsg: u_int; lEvent: Longint): Integer; stdcall;



function MySend2(s: TSocket; var Buf; len, flags: Integer): Integer; stdcall;
function MyRecv2(s: TSocket; lpBuffers: LPWSABUF; dwBufferCount: DWORD; var
  lpNumberOfBytesRecvd: DWORD; var lpFlags: DWORD;
  lpOverlapped: LPWSAOVERLAPPED; lpCompletionRoutine:
  LPWSAOVERLAPPED_COMPLETION_ROUTINE): Integer; stdcall;
function MyWSioctlsocket2(s: TSocket; cmd: DWORD; var arg: u_long): Integer; stdcall;
function MyWSAAsyncSelect2(s: TSocket; HWindow: HWND; wMsg: u_int; lEvent: Longint): Integer; stdcall;

var
  OldSend, OldRecv: TSockProc;
  OldWSioctlsocket: TWSioctlsocket;
  //OldConnect: TConnect;
  OldWSAAsyncSelect: TWSAAsyncSelect;

  OldSend2: TSockProc;
  OldWSioctlsocket2: TWSioctlsocket;
  //OldConnect: TConnect;
  OldWSAAsyncSelect2: TWSAAsyncSelect;
  OldRecv2: TWSARecv;

  OldGetTickCount: TGetTickCount; //Pointer;
  JmpCode: TJmpCode;
  OldProc: array[0..8] of TJmpCode;
  ApiAddress: array[0..8] of Pointer; //API地址

  TmpJmp: TJmpCode;
  ProcessHandle: THandle;
  StartRecv: Boolean;
implementation
uses GameEngn, Common, CShare;

function MyConnect(const s: TSocket; const Name: PSockAddr; const namelen: Integer): Integer;
var
  dwSize: cardinal;
  CSocket: TSocket;
  NewName: TSockAddr; //PSockAddr;
begin
  {GameSocket.Socket := s;
  WriteProcessMemory(ProcessHandle, ApiAddress[0], @OldProc[0], 8, dwSize);
  SendOutStr('MyConnect1:'+IntToStr(ntohs(Name^.sin_port)));

  if GameSocket.HookConnect(s)  then begin
    GameSocket.ClientSocket.Port := ntohs(Name^.sin_port);
    GameSocket.ClientSocket.Address := string(inet_ntoa(Name^.sin_addr));
    SendOutStr('MyConnect2:'+IntToStr(ntohs(Name^.sin_port)));

    //New(NewName);
    NewName := Name^;
    NewName.sin_addr.S_addr := inet_Addr('127.0.0.1');
    NewName.sin_port := htons(GameSocket.ServerPort);
    Result := OldConnect(s, @NewName, namelen);
    //Dispose(NewName);

  end else begin
    Result := OldConnect(s, Name, namelen);
  end;

  JmpCode.Address := @MyConnect;
  WriteProcessMemory(ProcessHandle, ApiAddress[0], @JmpCode, 8, dwSize); }


end;

{---------------------------------------}
{函数功能:Send函数的HOOK
{函数参数:同Send
{函数返回值:integer
{---------------------------------------}

function MySend(s: TSocket; var Buf; len, flags: Integer): Integer;
var
  dwSize: cardinal;
  nLen: Integer;
  //sSendText:string;
begin
 //这儿进行发送的数据处理
{$IF TESTMODE = 1}
  SendOutStr('MySend');
{$IFEND}
  GameSocket.Socket := s;
  GameSocket.WinSend := OldSend;
  WriteProcessMemory(ProcessHandle, ApiAddress[1], @OldProc[1], 8, dwSize);

  nLen := len;
  GameSocket.Send(Buf, nLen);
  Result := OldSend(s, Pointer(GameSocket.SendText)^, nLen, flags);
  GameSocket.SendText := '';

  JmpCode.Address := @MySend;
  WriteProcessMemory(ProcessHandle, ApiAddress[1], @JmpCode, 8, dwSize);
end;

function MyWSioctlsocket(s: TSocket; cmd: DWORD; var arg: u_long): Integer; stdcall;
var
  dwSize: cardinal;
begin
{$IF TESTMODE = 1}
  SendOutStr('Myioctlsocket');
{$IFEND}
  WriteProcessMemory(ProcessHandle, ApiAddress[3], @OldProc[3], 8, dwSize);
  Result := OldWSioctlsocket(s, cmd, arg);
  if FIONREAD = cmd then begin
    if arg <= 0 then begin
      arg := Length(GameSocket.ReviceText);
      StartRecv := arg > 0;
      //SendOutStr('Myioctlsocket:' + GameSocket.ReviceText);
    end;
  end;
  JmpCode.Address := @MyWSioctlsocket;
  WriteProcessMemory(ProcessHandle, ApiAddress[3], @JmpCode, 8, dwSize);
end;

function MyWSAAsyncSelect(s: TSocket; HWindow: HWND; wMsg: u_int; lEvent: Longint): Integer; stdcall;
  function SetSocketHwnd(SocketHwnd: Hwnd): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := 0 to 10 do begin
      //if FormData.MainHwnd[I] > 0 then SendOutStr('FormData.MainHwnd[I]:' + IntToStr(I) + ':' + IntToStr(FormData.MainHwnd[I]));
      if (g_DataEngine.Data.MainHwnd[I] = GetForegroundWindow) then begin
        g_DataEngine.SocketHwnd[I] := SocketHwnd;
        Break;
      end;
    end;
  end;
var
  dwSize: cardinal;
begin
{$IF TESTMODE = 1}
  SendOutStr('MyWSAAsyncSelect');
{$IFEND}
  WriteProcessMemory(ProcessHandle, ApiAddress[4], @OldProc[4], 8, dwSize);
  g_HSocketHwnd := HWindow;
  g_CM_SOCKETMESSAGE := wMsg;
  SetSocketHwnd(HWindow);

  Result := OldWSAAsyncSelect(s, HWindow, wMsg, lEvent);
  JmpCode.Address := @MyWSAAsyncSelect;
  WriteProcessMemory(ProcessHandle, ApiAddress[4], @JmpCode, 8, dwSize);
 // SendOutStr('MyWSAAsyncSelect:' + IntToStr(HWindow));
end;
{---------------------------------------}
{函数功能:Recv函数的HOOK
{函数参数:同Recv
{函数返回值:integer
{---------------------------------------}

function MyRecv(s: TSocket; var Buf; len, flags: Integer): Integer;
var
  dwSize: cardinal;
  nLen: Integer;
  sReviceText: string;
begin
{$IF TESTMODE = 1}
  SendOutStr('MyRecv');
{$IFEND}
  GameSocket.Socket := s;
  WriteProcessMemory(ProcessHandle, ApiAddress[2], @OldProc[2], 8, dwSize);

  if StartRecv then begin
    //SendOutStr('StartRecv');
    try
      StartRecv := False;
      if len >= Length(GameSocket.ReviceText) then begin
        Move(GameSocket.ReviceText[1], Pointer(@Buf)^, Length(GameSocket.ReviceText));
        GameSocket.ReviceText := '';
      end else begin
        //sReviceText := Copy(GameSocket.ReviceText, 1, len);
        Move(GameSocket.ReviceText[1], Pointer(@Buf)^, len);
        GameSocket.ReviceText := Copy(GameSocket.ReviceText, len + 1, Length(GameSocket.ReviceText) - len);
        //SendOutStr('len <:' + IntToStr(len) + ' ' + sReviceText + '-----' + GameSocket.ReviceText);
      end;
      Result := INVALID_SOCKET;
    except
      //SendOutStr('StartRecv Error');
    end;

  end else begin
    Result := OldRecv(s, Buf, len, flags);
    if Result <> SOCKET_ERROR then begin
      nLen := len;
      GameSocket.Read(Buf, nLen);
    end;
  end;
  JmpCode.Address := @MyRecv;
  WriteProcessMemory(ProcessHandle, ApiAddress[2], @JmpCode, 8, dwSize);
end;
 //=============================================================================

function MySend2(s: TSocket; var Buf; len, flags: Integer): Integer;
var
  dwSize: cardinal;
  nLen: Integer;
  //sSendText:string;
begin
{$IF TESTMODE = 1}
  SendOutStr('MySend2');
{$IFEND}
  GameSocket.Socket := s;
  GameSocket.WinSend := OldSend2;
  WriteProcessMemory(ProcessHandle, ApiAddress[5], @OldProc[5], 8, dwSize);

  nLen := len;
  GameSocket.Send(Buf, nLen);
  Result := OldSend2(s, Pointer(GameSocket.SendText)^, nLen, flags);
  GameSocket.SendText := '';

  JmpCode.Address := @MySend2;
  WriteProcessMemory(ProcessHandle, ApiAddress[5], @JmpCode, 8, dwSize);
end;

function MyRecv2(s: TSocket; lpBuffers: LPWSABUF; dwBufferCount: DWORD; var
  lpNumberOfBytesRecvd: DWORD; var lpFlags: DWORD;
  lpOverlapped: LPWSAOVERLAPPED; lpCompletionRoutine:
  LPWSAOVERLAPPED_COMPLETION_ROUTINE): Integer;
var
  dwSize: cardinal;
  nLen: Integer;
  sReviceText: string;
  Buf: WSABUF;
begin
{$IF TESTMODE = 1}
  SendOutStr('MyRecv2');
{$IFEND}
  GameSocket.m_dwReviceTick := GetTickCount;
  GameSocket.Socket := s;
  WriteProcessMemory(ProcessHandle, ApiAddress[6], @OldProc[6], 8, dwSize);
  if StartRecv and (Length(GameSocket.ReviceText) = lpBuffers.len) then begin
    StartRecv := False;
    Result := INVALID_SOCKET;
    if GameSocket.ReviceText <> '' then begin
      Result := Length(GameSocket.ReviceText);
      Move(GameSocket.ReviceText[1], Pointer(lpBuffers.buf)^, Length(GameSocket.ReviceText));
      GameSocket.ReviceText := '';
    end;
  end else begin
    StartRecv := False;
    Result := OldRecv2(s, lpBuffers, dwBufferCount, lpNumberOfBytesRecvd, lpFlags, lpOverlapped, lpCompletionRoutine);
    if Result <> SOCKET_ERROR then begin
      nLen := lpBuffers.len;
      GameSocket.Read(lpBuffers.buf^, nLen);
    end;
  end;
  JmpCode.Address := @MyRecv2;
  WriteProcessMemory(ProcessHandle, ApiAddress[6], @JmpCode, 8, dwSize);
end;

function MyWSioctlsocket2(s: TSocket; cmd: DWORD; var arg: u_long): Integer;
var
  dwSize: cardinal;
begin
{$IF TESTMODE = 1}
  SendOutStr('MyWSioctlsocket2');
{$IFEND}
  WriteProcessMemory(ProcessHandle, ApiAddress[7], @OldProc[7], 8, dwSize);
  Result := OldWSioctlsocket2(s, cmd, arg);
  if FIONREAD = cmd then begin
    if arg <= 0 then begin
      arg := Length(GameSocket.ReviceText);
      StartRecv := arg > 0;
      //SendOutStr('Myioctlsocket:' + GameSocket.ReviceText);
    end;
  end;
  JmpCode.Address := @MyWSioctlsocket2;
  WriteProcessMemory(ProcessHandle, ApiAddress[7], @JmpCode, 8, dwSize);
end;

function MyWSAAsyncSelect2(s: TSocket; HWindow: HWND; wMsg: u_int; lEvent: Longint): Integer;
  function SetSocketHwnd(SocketHwnd: Hwnd): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := 0 to 10 do begin
      //if FormData.MainHwnd[I] > 0 then SendOutStr('FormData.MainHwnd[I]:' + IntToStr(I) + ':' + IntToStr(FormData.MainHwnd[I]));
      if (g_DataEngine.Data.MainHwnd[I] = GetForegroundWindow) then begin
        g_DataEngine.SocketHwnd[I] := SocketHwnd;
        Break;
      end;
    end;
  end;
var
  dwSize: cardinal;
begin
{$IF TESTMODE = 1}
  SendOutStr('MyWSAAsyncSelect2');
{$IFEND}
  WriteProcessMemory(ProcessHandle, ApiAddress[8], @OldProc[8], 8, dwSize);
  g_HSocketHwnd := HWindow;
  g_CM_SOCKETMESSAGE := wMsg;
  SetSocketHwnd(HWindow);

  Result := OldWSAAsyncSelect2(s, HWindow, wMsg, lEvent);
  JmpCode.Address := @MyWSAAsyncSelect2;
  WriteProcessMemory(ProcessHandle, ApiAddress[8], @JmpCode, 8, dwSize);
 // SendOutStr('MyWSAAsyncSelect:' + IntToStr(HWindow));
end;

function MyGetTickCount: DWORD; stdcall;
var
  dwSize: cardinal;
begin
  WriteProcessMemory(ProcessHandle, ApiAddress[3], @OldProc[3], 8, dwSize);
  Result := Round(GameEngine.m_Real * TGetTickCount(OldGetTickCount));
  JmpCode.Address := @MyGetTickCount;
  WriteProcessMemory(ProcessHandle, ApiAddress[3], @JmpCode, 8, dwSize);
end;

procedure HookAPI;
var
  dwSize: cardinal;
  DLLModule: THandle;
begin
  GameSocket := TGameSocket.Create();
  GameEngine := TGameEngine.Create(True);

  ProcessHandle := GetCurrentProcess;

 { DLLModule := LoadLibrary('wsock32.dll'); //ws2_32.dll  wsock32.dll

  //ApiAddress[0] := GetProcAddress(DLLModule, 'connect'); //取得API地址
  ApiAddress[1] := GetProcAddress(DLLModule, 'send'); //取得API地址
  ApiAddress[2] := GetProcAddress(DLLModule, 'recv');
  ApiAddress[3] := GetProcAddress(DLLModule, 'ioctlsocket');
  ApiAddress[4] := GetProcAddress(DLLModule, 'WSAAsyncSelect');

  JmpCode.JmpCode := $B8;
  JmpCode.MovEAX[0] := $FF;
  JmpCode.MovEAX[1] := $E0;
  JmpCode.MovEAX[2] := 0;

  ReadProcessMemory(ProcessHandle, ApiAddress[1], @OldProc[1], 8, dwSize);
  JmpCode.Address := @MySend;
  WriteProcessMemory(ProcessHandle, ApiAddress[1], @JmpCode, 8, dwSize); //修改Send入口

  JmpCode.JmpCode := $B8;
  JmpCode.MovEAX[0] := $FF;
  JmpCode.MovEAX[1] := $E0;
  JmpCode.MovEAX[2] := 0;
  ReadProcessMemory(ProcessHandle, ApiAddress[2], @OldProc[2], 8, dwSize);
  JmpCode.Address := @MyRecv;
  WriteProcessMemory(ProcessHandle, ApiAddress[2], @JmpCode, 8, dwSize); //修改Recv入口


  JmpCode.JmpCode := $B8;
  JmpCode.MovEAX[0] := $FF;
  JmpCode.MovEAX[1] := $E0;
  JmpCode.MovEAX[2] := 0;
  ReadProcessMemory(ProcessHandle, ApiAddress[3], @OldProc[3], 8, dwSize);
  JmpCode.Address := @MyWSioctlsocket;
  WriteProcessMemory(ProcessHandle, ApiAddress[3], @JmpCode, 8, dwSize); //修改ioctlsocket入口


  JmpCode.JmpCode := $B8;
  JmpCode.MovEAX[0] := $FF;
  JmpCode.MovEAX[1] := $E0;
  JmpCode.MovEAX[2] := 0;
  ReadProcessMemory(ProcessHandle, ApiAddress[4], @OldProc[4], 8, dwSize);
  JmpCode.Address := @MyWSAAsyncSelect;
  WriteProcessMemory(ProcessHandle, ApiAddress[4], @JmpCode, 8, dwSize); //修改ioctlsocket入口


  //OldConnect := ApiAddress[0];
  OldSend := ApiAddress[1];
  OldRecv := ApiAddress[2];
  OldWSioctlsocket := ApiAddress[3];
  OldWSAAsyncSelect := ApiAddress[4];
  FreeLibrary(DLLModule); }


//==============================================================================

  DLLModule := LoadLibrary('ws2_32.dll'); //ws2_32.dll  wsock32.dll

  //ApiAddress[0] := GetProcAddress(DLLModule, 'connect'); //取得API地址
  ApiAddress[5] := GetProcAddress(DLLModule, 'send'); //取得API地址
  ApiAddress[6] := GetProcAddress(DLLModule, 'WSARecv');
  ApiAddress[7] := GetProcAddress(DLLModule, 'ioctlsocket');
  ApiAddress[8] := GetProcAddress(DLLModule, 'WSAAsyncSelect');
  //JmpCode.JmpCode := $B8;
  //JmpCode.MovEAX[0] := $FF;
  //JmpCode.MovEAX[1] := $E0;
  //JmpCode.MovEAX[2] := 0;
  //ReadProcessMemory(ProcessHandle, ApiAddress[0], @OldProc[0], 8, dwSize);
  //JmpCode.Address := @MyConnect;
  //WriteProcessMemory(ProcessHandle, ApiAddress[0], @JmpCode, 8, dwSize); //修改Conect入口

  JmpCode.JmpCode := $B8;
  JmpCode.MovEAX[0] := $FF;
  JmpCode.MovEAX[1] := $E0;
  JmpCode.MovEAX[2] := 0;

  ReadProcessMemory(ProcessHandle, ApiAddress[5], @OldProc[5], 8, dwSize);
  JmpCode.Address := @MySend2;
  WriteProcessMemory(ProcessHandle, ApiAddress[5], @JmpCode, 8, dwSize); //修改Send入口

  JmpCode.JmpCode := $B8;
  JmpCode.MovEAX[0] := $FF;
  JmpCode.MovEAX[1] := $E0;
  JmpCode.MovEAX[2] := 0;
  ReadProcessMemory(ProcessHandle, ApiAddress[6], @OldProc[6], 8, dwSize);
  JmpCode.Address := @MyRecv2;
  WriteProcessMemory(ProcessHandle, ApiAddress[6], @JmpCode, 8, dwSize); //修改Recv入口


  JmpCode.JmpCode := $B8;
  JmpCode.MovEAX[0] := $FF;
  JmpCode.MovEAX[1] := $E0;
  JmpCode.MovEAX[2] := 0;
  ReadProcessMemory(ProcessHandle, ApiAddress[7], @OldProc[7], 8, dwSize);
  JmpCode.Address := @MyWSioctlsocket2;
  WriteProcessMemory(ProcessHandle, ApiAddress[7], @JmpCode, 8, dwSize); //修改ioctlsocket入口


  JmpCode.JmpCode := $B8;
  JmpCode.MovEAX[0] := $FF;
  JmpCode.MovEAX[1] := $E0;
  JmpCode.MovEAX[2] := 0;
  ReadProcessMemory(ProcessHandle, ApiAddress[8], @OldProc[8], 8, dwSize);
  JmpCode.Address := @MyWSAAsyncSelect2;
  WriteProcessMemory(ProcessHandle, ApiAddress[8], @JmpCode, 8, dwSize); //修改ioctlsocket入口



  OldSend2 := ApiAddress[5];
  OldRecv2 := ApiAddress[6];
  OldWSioctlsocket2 := ApiAddress[7];
  OldWSAAsyncSelect2 := ApiAddress[8];
  FreeLibrary(DLLModule);
end;
{------------------------------------}
{过程功能:取消HOOKAPI
{过程参数:无
{------------------------------------}

procedure UnHookAPI;
var
  dwSize: cardinal;
begin
  WriteProcessMemory(ProcessHandle, ApiAddress[0], @OldProc[0], 8, dwSize);
  //WriteProcessMemory(ProcessHandle, ApiAddress[1], @OldProc[1], 8, dwSize);
  //WriteProcessMemory(ProcessHandle, ApiAddress[2], @OldProc[2], 8, dwSize);
  WriteProcessMemory(ProcessHandle, ApiAddress[3], @OldProc[3], 8, dwSize);
  //FreeLibrary(DLLData^.DLLModule);

  GameSocket.Free;

  GameEngine.Terminate;
  GameEngine.Free;
end;

end.

