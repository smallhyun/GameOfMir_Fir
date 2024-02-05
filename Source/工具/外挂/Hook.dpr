library Hook;

uses
  FastMM4,
  SysUtils,
  windows,
  Messages,
  DiaLogs,
  APIHook in 'APIHook.pas',
  OptionMain in 'OptionMain.pas' {frmOption},
  GameEngn in 'GameEngn.pas',
  Common in 'Common.pas',
  ObjActor in 'ObjActor.pas',
  HUtil32 in '..\..\Common\HUtil32.pas',
  ClFunc in 'ClFunc.pas',
  Share in 'Share.pas',
  CShare in 'CShare.pas',
  EncryptUnit in '..\..\Common\EncryptUnit.pas',
  Grobal in 'Grobal.pas';
var
  FDllHandle: LongWORD;
  FFormHandle: LongWORD;
  FileMapName: string;
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

function HookKeyProc(iCode: Integer; wParam: wParam; lParam: lParam): LRESULT; stdcall;
  function IsMainHwnd(MainHwnd: Hwnd): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := 0 to 10 do begin
      //if FormData.MainHwnd[I] > 0 then SendOutStr('FormData.MainHwnd[I]:' + IntToStr(I) + ':' + IntToStr(FormData.MainHwnd[I]));
      if (g_DataEngine.Data.MainHwnd[I] = MainHwnd) then begin
        Result := True;
        Break;
      end;
    end;
  end;
var
  ActionKey: Word;
  //ClientMagic: pTClientMagic;
  MainHwnd: Hwnd;
  AppRect: TRect;
  PTitle: PChar;
  sTitle: string;
  flag: Boolean;
  IsMirHwnd: Boolean;
  P: TPoint;
  Pt: TPoint;
  R: TRect;
  EventMsg: pEventMsg;
  KSB: TKeyboardState; // 键盘状态
  Key: Word;
begin
  if not DLLData^.KeyHooked then begin
    //HookAPI;
    //SendOutStr('not DLLData^.KeyHooked');
    DLLData^.KeyHooked := True;
  end;
  //Result := 0;
  sTitle := '';
  if (iCode < 0) then begin
    Result := CallNextHookEx(DLLData^.HookKey, iCode, wParam, lParam);
    //Result := 0;
    Exit;
  end;

  MainHwnd := GetForegroundWindow;
  IsMirHwnd := IsMainHwnd(MainHwnd);
 { try
    GetMem(PTitle, 128);
    GetWindowText(FindWindow('TDXDraw', nil), PTitle, 120);
    sTitle := StrPas(PTitle);
  finally
    FreeMem(PTitle);
  end; }

  if ((lParam and $80000000) = 0) then begin
    //SHOWMESSAGE('m_boUserLogin:'+Booltostr(GameEngine.m_boUserLogin));
    if GameEngine.m_boUserLogin then begin
      if {(frmOption <> nil) and (frmOption.MainHwnd = MainHwnd) or}  IsMirHwnd then begin
        case wParam of
          VK_SHIFT: if GetKeyState(VK_LSHIFT) < 0 then Key := VK_LSHIFT else Key := VK_RSHIFT;
          VK_CONTROL: if GetKeyState(VK_LCONTROL) < 0 then Key := VK_LCONTROL else Key := VK_RCONTROL;
          VK_MENU: if GetKeyState(VK_LMENU) < 0 then Key := VK_LMENU else Key := VK_RMENU;
        else Key := wParam;
        end;
        //SendOutStr('Key:'+IntToStr(Key));
        GameEngine.KeyDown(MainHwnd, Key);
      end;
    end;

  end;
  Result := CallNextHookEx(DLLData^.HookKey, iCode, wParam, lParam);
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
  DLLData^.HookKey := SetWindowsHookEx(WH_KEYBOARD, @HookKeyProc, Hinstance, ThreadID); //键盘钩子
  Result := (DLLData^.HookMsg > 0) and (DLLData^.HookKey > 0); //是否成功HOOK
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
  UnhookWindowsHookEx(DLLData^.HookKey);
end;

{------------------------------------}
{过程名:DLL入口函数
{过程功能:进行DLL初始化,释放等
{过程参数:DLL状态
{------------------------------------}

procedure DeleteSelf(sFileName: string);
var
  BatchFile: TextFile;
  BatchFileName: string;
  ProcessInfo: TProcessInformation;
  StartUpInfo: TStartupInfo;
begin
  BatchFileName := ExtractFilePath(ParamStr(0)) + '$a$.bat';
  FileSetAttr(BatchFileName, 0);
  DeleteFile(PChar(BatchFileName));
  AssignFile(BatchFile, BatchFileName);
  Rewrite(BatchFile);
  Writeln(BatchFile, ':try');
  Writeln(BatchFile, 'attrib "' + sFileName + '" -s -h');
  Writeln(BatchFile, 'del "' + sFileName + '"');
  Writeln(BatchFile, 'if exist "' + sFileName + '"' + ' goto try');
  //Writeln(BatchFile, 'attrib "' + BatchFileName + '" -s -h');
  Writeln(BatchFile, 'del %0');
  Writeln(BatchFile, 'exit');
  CloseFile(BatchFile);
  //FileSetAttr(BatchFileName, 2);
  FillChar(StartUpInfo, SizeOf(StartUpInfo), $00);
  StartUpInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartUpInfo.wShowWindow := SW_Hide;
  if CreateProcess(nil, PChar(BatchFileName), nil, nil,
    False, IDLE_PRIORITY_CLASS, nil, nil, StartUpInfo,
    ProcessInfo) then begin
    CloseHandle(ProcessInfo.hThread);
    CloseHandle(ProcessInfo.hProcess);
  end;
end;

procedure MyDLLHandler(Reason: Integer);
var
  n01: Integer;
begin
  case Reason of
    DLL_PROCESS_ATTACH:
      begin //建立文件映射,以实现DLL中的全局变量
        n01 := 0;
        FileMapName := '';
        while True do begin
          FileMapName := 'DLLDATA' + IntToStr(n01);
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

        FFormHandle := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, 'FORMDATA');
        if FFormHandle = 0 then Exit;
        g_Data := MapViewOfFile(FFormHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
        if g_Data = nil then CloseHandle(FFormHandle) else begin
          g_DataEngine := TDataEngine.Create;
          g_DataEngine.Data := g_Data;
          g_DataEngine.Initialize;
          g_DataEngine.DLLVersion := SysVersion;
        end;
        {
        FHandle := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0, SizeOf(TData), 'MYDLLDATA');
        if FHandle = 0 then
          if GetLastError = ERROR_ALREADY_EXISTS then
          begin
            FHandle := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, 'MYDLLDATA');
            if FHandle = 0 then Exit;
          end else Exit;
        DLLData := MapViewOfFile(FHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
        if DLLData = nil then
          CloseHandle(FHandle);

        FHandle := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0, SizeOf(TFormData), 'FORMDATA');
        if FHandle = 0 then
          if GetLastError = ERROR_ALREADY_EXISTS then
          begin
            FHandle := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, 'FORMDATA');
            if FHandle = 0 then Exit;
          end else Exit;
        g_Data := MapViewOfFile(FHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
        if g_Data = nil then CloseHandle(FHandle) else begin
          g_DataEngine := TDataEngine.Create;
          g_DataEngine.Data := g_Data;
          g_DataEngine.Initialize;
        end;
        }
      end;
    DLL_PROCESS_DETACH:
      begin
        //DeleteSelf(string(g_DataEngine.Data.DllName));
        if Assigned(DLLData) then begin
          UnmapViewOfFile(DLLData);
          CloseHandle(FDLLHandle);
          DLLData := nil;
        end;
        if Assigned(g_Data) then begin
          UnmapViewOfFile(g_Data);
          CloseHandle(FFormHandle);
          g_Data := nil;
        end;
        if g_DataEngine <> nil then g_DataEngine.Free;
      end;
  end;
end;

exports
  StartHook, StopHook;

begin
  Randomize;
  DLLProc := @MyDLLHandler;
  MyDLLHandler(DLL_PROCESS_ATTACH);
  DLLData^.MsgHooked := False;
  DLLData^.KeyHooked := False;
end.

