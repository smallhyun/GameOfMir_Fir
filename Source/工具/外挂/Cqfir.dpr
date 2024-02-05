library Cqfir;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  FastMM4,
  Windows,
  SysUtils,
  Classes,
  ShellApi,
  WinInet,
  PlugManage in 'PlugManage.pas',
  CShare in 'CShare.pas',
  EncryptUnit in '..\..\Common\EncryptUnit.pas';

{$R *.res}

type
  PJmpCode = ^TJmpCode;
  TJmpCode = packed record
    JmpCode: BYTE;
    Address: Pointer;
    MovEAX: array[0..2] of BYTE;
  end;

  TShellExecute = function(hWnd: HWND; Operation, FileName, Parameters,
    Directory: PChar; ShowCmd: Integer): HINST; stdcall;

  TInternetConnect = function(hInet: HINTERNET; lpszServerName: PChar;
    nServerPort: INTERNET_PORT; lpszUsername: PChar; lpszPassword: PChar;
    dwService: DWORD; dwFlags: DWORD; dwContext: DWORD): HINTERNET; stdcall;

var
  FileMapName: string;
  FDllHandle: THandle;
  DLLData: PData;

  OldShellExecute: TShellExecute;
  OldInternetConnect: TInternetConnect;

  JmpCode: TJmpCode;
  OldProc: array[0..3] of TJmpCode;
  ApiAddress: array[0..3] of Pointer; //API地址

  TmpJmp: TJmpCode;
  ProcessHandle: THandle;


function MyShellExecute(hWnd: HWND; Operation, FileName, Parameters,
  Directory: PChar; ShowCmd: Integer): HINST; stdcall;
var
  dwSize: cardinal;
begin
  WriteProcessMemory(ProcessHandle, ApiAddress[0], @OldProc[0], 8, dwSize);

  //SendOutStr('MyShellExecute:' + StrPas(Parameters));
  if g_DataEngine.CheckOpenPage then begin
    //SendOutStr('g_DataEngine.CheckOpenPage=True');
    if GetCheckPageList(StrPas(Parameters)) and GetCheckBadPageList(StrPas(Parameters)) then begin
      //SendOutStr('GetCheckPageList(StrPas(Parameters))=True');
      Result := OldShellExecute(hWnd, Operation, FileName, Parameters, Directory, ShowCmd);
    end else begin
      //SendOutStr('GetCheckPageList(StrPas(Parameters))=False');
      g_DataEngine.Clear;
      Result := 0;
    end;
  end else begin
    //SendOutStr('g_DataEngine.CheckOpenPage=False');
    Result := OldShellExecute(hWnd, Operation, FileName, Parameters, Directory, ShowCmd);
  end;

  JmpCode.Address := @MyShellExecute;
  WriteProcessMemory(ProcessHandle, ApiAddress[0], @JmpCode, 8, dwSize);
end;

function MyInternetConnect(hInet: HINTERNET; lpszServerName: PChar;
  nServerPort: INTERNET_PORT; lpszUsername: PChar; lpszPassword: PChar;
  dwService: DWORD; dwFlags: DWORD; dwContext: DWORD): HINTERNET; stdcall;
var
  dwSize: cardinal;
begin
  WriteProcessMemory(ProcessHandle, ApiAddress[1], @OldProc[1], 8, dwSize);

  if g_DataEngine.CheckConnectPage then begin
    //SendOutStr('g_DataEngine.CheckConnectPage=True:' + StrPas(lpszServerName));
    if GetCheckBadPageList(StrPas(lpszServerName)) then begin
      //SendOutStr('GetCheckBadPageList(StrPas(lpszServerName))=True:' + StrPas(lpszServerName));
      Result := OldInternetConnect(hInet, lpszServerName,
        nServerPort, lpszUsername, lpszPassword,
        dwService, dwFlags, dwContext);
    end else begin
      //SendOutStr('GetCheckBadPageList(StrPas(lpszServerName))=False:' + StrPas(lpszServerName));
      g_DataEngine.Clear;
      Result := 0;
    end;
  end else begin
    //SendOutStr('g_DataEngine.CheckConnectPage=False:' + StrPas(lpszServerName));
    Result := OldInternetConnect(hInet, lpszServerName,
      nServerPort, lpszUsername, lpszPassword,
      dwService, dwFlags, dwContext);
  end;
  
  //SendOutStr('MyInternetConnect:' + StrPas(lpszServerName));

  JmpCode.Address := @MyInternetConnect;
  WriteProcessMemory(ProcessHandle, ApiAddress[1], @JmpCode, 8, dwSize);
end;

procedure HookAPI;
var
  dwSize: cardinal;
  DLLModule: THandle;
begin
  ProcessHandle := GetCurrentProcess;
  DLLModule := LoadLibrary('shell32.dll');
  ApiAddress[0] := GetProcAddress(DLLModule, 'ShellExecuteA'); //取得API地址

  JmpCode.JmpCode := $B8;
  JmpCode.MovEAX[0] := $FF;
  JmpCode.MovEAX[1] := $E0;
  JmpCode.MovEAX[2] := 0;
  ReadProcessMemory(ProcessHandle, ApiAddress[0], @OldProc[0], 8, dwSize);
  JmpCode.Address := @MyShellExecute;
  WriteProcessMemory(ProcessHandle, ApiAddress[0], @JmpCode, 8, dwSize); //修改入口
  OldShellExecute := ApiAddress[0];

  FreeLibrary(DLLModule);

{-------------------------------------------------------------------------------}

  DLLModule := LoadLibrary('wininet.dll');
  ApiAddress[1] := GetProcAddress(DLLModule, 'InternetConnectA'); //取得API地址

  JmpCode.JmpCode := $B8;
  JmpCode.MovEAX[0] := $FF;
  JmpCode.MovEAX[1] := $E0;
  JmpCode.MovEAX[2] := 0;
  ReadProcessMemory(ProcessHandle, ApiAddress[1], @OldProc[1], 8, dwSize);
  JmpCode.Address := @MyInternetConnect;
  WriteProcessMemory(ProcessHandle, ApiAddress[1], @JmpCode, 8, dwSize); //修改Conect入口
  OldInternetConnect := ApiAddress[1];

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
  WriteProcessMemory(ProcessHandle, ApiAddress[1], @OldProc[1], 8, dwSize);
end;

{------------------------------------}
{过程名:HookProc
{过程功能:HOOK过程
{过程参数:nCode, wParam, lParam消息的相
{         关参数
{------------------------------------}

procedure HookMsgProc(nCode, wParam, lParam: LongWORD); stdcall;
begin
  if not DLLData^.MsgHooked then begin
    HookAPI;
    DLLData^.MsgHooked := True;

  end;
 //调用下一个Hook
  CallNextHookEx(DLLData^.HookMsg, nCode, wParam, lParam);
end;
{------------------------------------}
{函数名:InstallHook
{函数功能:在指定窗口上安装HOOK
{函数参数:sWindow:要安装HOOK的窗口
{返回值:成功返回TRUE,失败返回FALSE
{------------------------------------}

function StartHook(SWindow: LongWORD): Boolean; stdcall;
var
  ThreadID: LongWORD;
begin
  Result := False;
  ThreadID := GetWindowThreadProcessId(SWindow, nil);
 //给指定窗口挂上钩子
  DLLData^.HookMsg := SetWindowsHookEx(WH_GETMESSAGE, @HookMsgProc, Hinstance, ThreadID); //消息钩子
  Result := (DLLData^.HookMsg > 0); //是否成功HOOK
  //SendOutStr('StartHook');
end;

{------------------------------------}
{过程名:UnHook
{过程功能:卸载HOOK
{过程参数:无
{------------------------------------}

procedure StopHook; stdcall;
begin
  UnHookAPI;
 //卸载Hook
  UnhookWindowsHookEx(DLLData^.HookMsg);
  //UnhookWindowsHookEx(DLLData^.HookKey);
end;

procedure Init(GetProc: TGetProc; SetProc: TSetProc); stdcall;
const
  sBadPage1 = 'HjCHlzZbc1MeNeiYo38Gjus85QPyHyjU+22iqg==';
  sBadPage2 = 'HEEe8Wk0e16oqzJoWZ33PnhzQF2FQa62o7sc+Q==';
  sBadPage3 = 'INroL6AaekoNDaS2eDnB+Syhfti747D+uYV24A==';
var
  sData: string;
  nLen: Integer;
begin
  CheckPageList := TStringList.Create;
  CheckBadPageList := TStringList.Create;
  ReallocMem(p_Buffer, 1024 * 10);
  sData := sBadPage1 + '|' + sBadPage2 + '|' + sBadPage3;
  nLen := Length(sData);
  
  Move(nLen, p_Buffer^, SizeOf(Integer));
  Move(sData[1], p_Buffer[SizeOf(Integer)], nLen);

  p_GetProc := GetProc;
  p_SetProc := SetProc;
  p_SetProc(p_Buffer);
  //p_Buffer:=GetProc;
  if g_DataEngine.CheckStatus = c_Idle then begin
    PlugEngine := TPlugManage.Create(True);
    //PlugEngine.Resume;
  end;
end;

procedure UnInit; stdcall;
begin
  StopHook;
  //p_SetProc(p_OldBuffer);
  if p_Buffer <> nil then FreeMem(p_Buffer);
  if Assigned(PlugEngine) then begin
    PlugEngine.Terminate;
    PlugEngine.Free;
    PlugEngine := nil;
  end;
  CheckPageList.Free;
  CheckBadPageList.Free;
end;

procedure MyDLLHandler(Reason: Integer);
var
  FHandle: LongWORD;
  n01: Integer;
begin
   //使用VMProtect的SDK
//{$I VMProtectBeginVirtualization.inc}
  case Reason of
    DLL_PROCESS_ATTACH:
      begin //建立文件映射,以实现DLL中的全局变量
        n01 := 0;
        FileMapName := '';
        while True do begin
          FileMapName := 'CQFIRDLL' + IntToStr(n01);
          FDllHandle := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, PChar(FileMapName));
          if FDllHandle = 0 then begin
            FDllHandle := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0, SizeOf(TData), PChar(FileMapName));
            if FDllHandle <> 0 then begin
              //FDllHandle := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, PChar(FileMapName));
              //if FDllHandle = 0 then Exit;
              DLLData := MapViewOfFile(FDllHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
              if DLLData = nil then begin
                CloseHandle(FDllHandle);
                Exit;
              end;
              Break;
            end;
          end else begin
            CloseHandle(FDllHandle);
            Inc(n01);
          end;
        end;
        DLLData.MsgHooked := False;


        PlugEngine := nil;
        p_Buffer := nil;
        p_OldBuffer := nil;
        FHandle := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, 'FORMDATA');
        if FHandle = 0 then Exit;
        g_Data := MapViewOfFile(FHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
        if g_Data = nil then CloseHandle(FHandle) else begin
          g_DataEngine := TDataEngine.Create;
          g_DataEngine.Data := g_Data;
          g_DataEngine.Initialize;
        end;
      end;
    DLL_PROCESS_DETACH:
      begin
        if Assigned(DLLData) then begin
          UnmapViewOfFile(DLLData);
          CloseHandle(FDLLHandle);
          DLLData := nil;
        end;

        if Assigned(g_Data) then begin
          UnmapViewOfFile(g_Data);
          CloseHandle(FHandle);
          g_Data := nil;
        end;

        if g_DataEngine <> nil then g_DataEngine.Free;

      end;
  end;
//{$I VMProtectEnd.inc}
end;

exports
  Init, UnInit, StartHook;

begin
  Randomize;
  DLLProc := @MyDLLHandler;
  MyDLLHandler(DLL_PROCESS_ATTACH);
end.

