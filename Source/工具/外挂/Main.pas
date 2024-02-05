unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, OleCtrls, SHDocVw, ComCtrls, ShlObj, ComObj, ActiveX,
  ShellApi, EncryptUnit, IniFiles, MD5EncodeStr, HUtil32, Registry, HttpProt,
  CShare, HTTPGet, Internet, IECache, WiniNet, tlHelp32, XPMan;
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
    Panel: TPanel;
    ComboBox: TComboBox;
    ButtonStart: TButton;
    ButtonStop: TButton;
    Label1: TLabel;
    ProgressBar: TProgressBar;
    Web: TInternet_Server;

    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ComboBoxChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    MemoryStream: TMemoryStream;
    HTTPGet: THTTPGet;
    HTTPDownLoad: THTTPGet;
    Timer: TTimer;
    TimerStart: TTimer;
    Timer1: TTimer;
    CloseTimer: TTimer;
    procedure CreateUlr(sCreateUlrName: string); //创建快捷方式
    procedure HTTPGetStringDoneString(Sender: TObject; Result: string);
    procedure HTTPGetStringError(Sender: TObject);

    procedure HTTPDownLoadDoneStream(Sender: TObject; Stream: TMemoryStream);
    procedure HTTPDownLoadProgress(Sender: TObject; TotalSize, Readed: Integer);
    procedure HTTPDownLoadError(Sender: TObject);

    function GetJumpText(CqfirData: pTCqfirData): string;
    procedure WriteUrlEntry(Hosts: TBuffers; Text: string);

    procedure DeleteUrlEntry(Hosts: TShortStrings); overload;
    procedure DeleteUrlEntry(Text: string); overload;
    procedure TimerTimer(Sender: TObject);
    procedure TimerStartTimer(Sender: TObject);
    procedure CloseTimerTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function GetProcesses: Boolean;
    function GetModules(ProcessID: DWORD): Boolean;
    procedure WebDocumentComplete(ASender: TObject; const pDisp: IDispatch;
      var URL: OleVariant);
  public
   { Public declarations }
  end;

var
  FrmMain: TFrmMain;
  ProcessList: TList;
  StartHook: function(SWindow: LongWORD): Boolean; stdcall;
  StopHook: procedure; stdcall;
  Init: procedure(GetProc: TGetProc; SetProc: TSetProc); stdcall;
  UnInit: procedure; stdcall;
  Start: function(SWindow: LongWORD): Boolean; stdcall;

  g_boStart: Boolean = False;

  CqfirModule: THandle;
//  FormData: pTFormData;
  TitleLen: Integer = 0;
  MappingName: string;
  MappingHandle: THandle;
  RemoveMe: Boolean = True;
{$IF USERVERSION = 0}
  //飞尔世界英雄外挂(http://www.941yx.com)
  g_sLinkName: string = 'VtuqMjSr4rqbGdSWDjYujyXBIWbE+VzIoGBGtIrPOnzz6ogTMjbvP22GIGV45A==';
  g_nLinkName: Integer = 5014365;

  //g_nConfigAddress: Integer = 12347495;
  //g_sConfigAddress: string = 'sWKCC+PnHMJVqBCrXwfvYt9WwVoNeySgy9SlQqYSM6APbgaksqPEuZGhaNrG'; //http://www.941sf.com/CqfirSupPort.txt
  g_sUserAddress: string = 'hWHdVHPqw43MHBMQP2vnhcr8RzaAOuO1IPaqHROPY8V2alz7WPXrO+yDg30y'; //http://www.941sf.com/CqfirSupPort.txt
{$IFEND}

{$IF USERVERSION = 1}
  //89945英雄合击外挂(http://www.89945.com)
  g_sLinkName: string = 'FdbdWuC5c5Fw5tahVYXxbB9sMNdTWGO+nSCvfxiLxXtVgr6gYDKvyjzFfCeDth4=';
  g_nLinkName: Integer = 84953997;

  //g_nConfigAddress: Integer = 261717745;
  //g_sConfigAddress: string = '8mHmAxR0mjKKB+XGLMuoathCTSqZfsYqyHOO9e9mdwS5s+WL4enG7tBCTP6A'; //http://www.89945.com/CqfirSupPort.txt
  g_sUserAddress: string = '6B1WECBiscgelxm1Z0oO6U0Lj4dR58Rztcx5opp4N6e0kmQVtFp9UCowgXca'; //http://www.89945.com/CqfirSupPort.txt
{$IFEND}

{$IF USERVERSION = 2}
  //飞尔世界英雄外挂(http://www.941yx.com)
  g_sLinkName: string = 'VtuqMjSr4rqbGdSWDjYujyXBIWbE+VzIoGBGtIrPOnzz6ogTMjbvP22GIGV45A==';
  g_nLinkName: Integer = 5014365;

  //g_nConfigAddress: Integer = 12347495;
  //g_sConfigAddress: string = 'sWKCC+PnHMJVqBCrXwfvYt9WwVoNeySgy9SlQqYSM6APbgaksqPEuZGhaNrG'; //http://www.941sf.com/CqfirSupPort.txt
  g_sUserAddress: string = 'hWHdVHPqw43MHBMQP2vnhcr8RzaAOuO1IPaqHROPY8V2alz7WPXrO+yDg30y'; //http://www.941sf.com/CqfirSupPort.txt
{$IFEND}

{$IF USERVERSION = 3}
  //飞速英雄合击外挂(http://www.sf898.com)
  g_sLinkName: string = 'iTDpQ4OqkoU81Dmrk29UgkXc0fQUK+2uDPGZYcTviX9ZWpYse7zX8RQZtIJ8aQ==';
  g_nLinkName: Integer = 138239981;

  //g_nConfigAddress: Integer = 232037462;
  //g_sConfigAddress: string = 'pgRNYFFzBDRd8zrIyaCTizBVXPjCw6DKlGpLgyzGVLdjqA+IdXXJDGRQU9Gf'; //http://www.sf898.com/CqfirSupPort.txt
  g_sUserAddress: string = 'bZyaMrXbpFjhPgRatCpGqBslU6tVXpzLotqcjg8czIaxE+4OV1MDRGej6mQT'; //http://www.sf898.com/CqfirSupPort.txt
{$IFEND}


{$IF USERVERSION = 4}
  //及时雨英雄外挂(http://www.17113.com)
  g_sLinkName: string = 'XyrfOPlJAy0hXzLOitvmbx04ISvnraNvaH+jiCY68S8zp1MTltNXlrnvQ+c=';
  g_nLinkName: Integer = 26086717;

  //g_nConfigAddress: Integer = 232037462;
  //g_sConfigAddress: string = 'pgRNYFFzBDRd8zrIyaCTizBVXPjCw6DKlGpLgyzGVLdjqA+IdXXJDGRQU9Gf'; //http://www.sf898.com/CqfirSupPort.txt
  g_sUserAddress: string = 'bZyaMrXbpFjhPgRatCpGqBslU6tVXpzLotqcjg8czIaxE+4OV1MDRGej6mQT'; //http://www.sf898.com/CqfirSupPort.txt
{$IFEND}


{$IF USERVERSION = 5}
  //及时雨英雄外挂(http://www.17113.com)
  g_sLinkName: string = 'uQjqfTFTClu7CIgGOhTTsZ4IQnZzukSybnO7AcHkv4SkWxEvIAbrxETt2IM=';
  g_nLinkName: Integer = 92317405;

  //g_nConfigAddress: Integer = 232037462;
  //g_sConfigAddress: string = 'pgRNYFFzBDRd8zrIyaCTizBVXPjCw6DKlGpLgyzGVLdjqA+IdXXJDGRQU9Gf'; //http://www.sf898.com/CqfirSupPort.txt
  g_sUserAddress: string = 'bZyaMrXbpFjhPgRatCpGqBslU6tVXpzLotqcjg8czIaxE+4OV1MDRGej6mQT'; //http://www.sf898.com/CqfirSupPort.txt
{$IFEND}

{$IF USERVERSION = 6}
  //及时雨英雄外挂(http://www.17113.com)
  g_sLinkName: string = 'NfN9sYEiwdyXlh0zvaUQ4RT1ObZzsEZP2s3pKIkPgFeX8P0rja527vMQGIZI';
  g_nLinkName: Integer = 240342217;

  //g_nConfigAddress: Integer = 232037462;
  //g_sConfigAddress: string = 'pgRNYFFzBDRd8zrIyaCTizBVXPjCw6DKlGpLgyzGVLdjqA+IdXXJDGRQU9Gf'; //http://www.sf898.com/CqfirSupPort.txt
  g_sUserAddress: string = 'KkLny2sctNH1fbpCGMXCQhxgcEYEx6w4k5IrOrBnluutg9QbeMFeoi++gbw='; //http://www.sf898.com/CqfirSupPort.txt
{$IFEND}

{$IF USERVERSION = 7}
//外挂名称：好传奇合击外挂
//IP地址是：121.12.107.4
//网站地址： www.haocq.com
  //好传奇合击外挂(http://www.haocq.com)
  g_sLinkName: string = 'ZnKU5tRhztan+J9+e3KzmNyIwXzL82mUUw3KdSN4PwF0uJmDcZ1eP0ynE1o=';
  g_nLinkName: Integer = 98359053;

  //g_nConfigAddress: Integer = 232037462;
  //g_sConfigAddress: string = 'pgRNYFFzBDRd8zrIyaCTizBVXPjCw6DKlGpLgyzGVLdjqA+IdXXJDGRQU9Gf'; //http://www.sf898.com/CqfirSupPort.txt
  g_sUserAddress: string = 'aNPGl6ufqRuZ607WAGUY9xooI0MqdvRUmrtszSBfsGxs+GRWnf9Cyvdq8Fxj'; //http://www.sf898.com/CqfirSupPort.txt
{$IFEND}

{$IF USERVERSION = 10}
  //飞尔世界英雄外挂(http://www.941yx.com)
  g_sLinkName: string = 'VtuqMjSr4rqbGdSWDjYujyXBIWbE+VzIoGBGtIrPOnzz6ogTMjbvP22GIGV45A==';
  g_nLinkName: Integer = 5014365;

  //g_nConfigAddress: Integer = 12347495;
  //g_sConfigAddress: string = 'sWKCC+PnHMJVqBCrXwfvYt9WwVoNeySgy9SlQqYSM6APbgaksqPEuZGhaNrG'; //http://www.941sf.com/CqfirSupPort.txt
  g_sUserAddress: string = 'hWHdVHPqw43MHBMQP2vnhcr8RzaAOuO1IPaqHROPY8V2alz7WPXrO+yDg30y'; //http://www.941sf.com/CqfirSupPort.txt
{$IFEND}





  g_sConfigFileName: string = 'W5qSiDgB6N2wxUypB7C9Q4HZd4jR3zeV'; //CqfirSupPort.txt


  g_sDllFileName: string;
  g_sCqfirDllFileName: string;

  g_nCaption: Integer;
  g_nUserLiense: Integer;


  g_sCheckFileName: string;
  g_sDownSelfFileName: string;
  g_sDownSelfAddress: string;

  g_sHosts: string = 'GZcrtu+2MIu1dKvnRszMiZZb8nZRVky9IeKkyVKimFjL';
  g_sHosts1: string = 'bKvFDkqCegMGbiaFJA=='; //Hosts
  g_sHosts2: string = 'Zqw9nQ1HJmBuHehFBdvYtcITXutxZU72palbj5qJwAet5w=='; //system32\drivers\etc\Hosts

  g_nHosts: Integer = 65496876; //Hosts
  g_nHosts1: Integer = 71847597; //Hosts
  g_nHosts2: Integer = 241237421; //Hosts

  g_sHostsFileName: string; //C:\Windows\system32\drivers\etc\Hosts
  g_nHostsFileName: Integer; //system32\drivers\etc\Hosts


  g_boFindDX: Boolean;

  //g_Hosts: TShortStrings;

  g_nSelfCrc: Integer;
  g_nCqfirCrc: Integer;
  g_nHookCrc: Integer;

  g_nSelfSize: Integer;
  g_nCqfirSize: Integer;
  g_nHookSize: Integer;

  g_boUpDate: Boolean;
  g_sUpDateMD5: string;
  //g_btClose: Byte;

  g_nCheckIndex: Integer;
  g_dwTimeTick: LongWord;
  g_boCheck: PBoolean;
  g_boReadHomePage: PBoolean;

  g_dwCheckHostsTimeTick: LongWord;
//-------------------------------//
//13. Get windows directory
//-------------------------------//
{
  Function:
    Get windows directory
  Parameter:
    Null
  Return value:
    Windows directory like 'C:\WINNT' or 'C:\Windows' etc.
  Example:
    myGetWindowsDirectory();
}
function myGetWindowsDirectory(): string;

//-------------------------------//
//14. Get windows system directory
//-------------------------------//
{
  Function:
    Get windows system directory
  Parameter:
    Null
  Return value:
    Windows system directory as 'C:\Winnt\System32'
  Example:
    myGetSystemDirectory()
}
function myGetSystemDirectory(): string;

function GetOSVersion: Integer; //获取系统版本
function GetWebAddr(sAddr: string): string;
function GetWebSubAddr(sAddr: string): string;
function RestoreIfRunning(const AppHandle: THandle; MaxInstances: Integer = 1): Boolean;
procedure ShowCrackMessage;
implementation

{$R *.dfm}

procedure ShowCrackMessage;
begin
  Application.MessageBox(PChar(DecryptString('NzftxY1KWZBWIV4sqTi6uELe1PSlfaVaQ5kVt5R3Sf40') + #13#10 +
    DecryptString('2C7ubt221y3b6UewxfX9VzVlkcytdDqEX817QpGy89HKI+70vy3CXIrFTYW0VKeJF80z1fEBVVNxsnx9eROhb0JrD4UFld9n') + #13#10 +
    DecryptString('LSQQQxfQ2KTQC58QCnNg8JGgN+b1btHDAKFwMOIV') + DecryptString(g_DataEngine.sOpenPage1) + DecryptString('Hs6yxPSkfU2gPPMiFzGksVE28AMsjMs=')), '提示信息', MB_ICONQUESTION);
end;

function GetPlugBuffer: PChar; stdcall;
begin
  Result := g_PlugBuffer;
end;

procedure SetPlugBuffer(Buffer: PChar); stdcall;
begin
  g_PlugBuffer := Buffer;
end;
//_____________________________________________________________________//

function myGetWindowsDirectory(): string; //获取Windows目录
var
  pcWindowsDirectory: PChar;
  dwWDSize: DWORD;
begin
  dwWDSize := MAX_PATH + 1;
  Result := '';
  GetMem(pcWindowsDirectory, dwWDSize);
  try
    if Windows.GetWindowsDirectory(pcWindowsDirectory, dwWDSize) <> 0 then
      Result := pcWindowsDirectory;
  finally
    FreeMem(pcWindowsDirectory);
  end;
end;

//_____________________________________________________________________//

function myGetSystemDirectory(): string; //获取系统目录
var
  pcSystemDirectory: PChar;
  dwSDSize: DWORD;
begin
  dwSDSize := MAX_PATH + 1;
  Result := '';
  GetMem(pcSystemDirectory, dwSDSize);
  try
    if Windows.GetSystemDirectory(pcSystemDirectory, dwSDSize) <> 0 then
      Result := pcSystemDirectory;
  finally
    FreeMem(pcSystemDirectory);
  end;
end;

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
      Result := Copy(sAddr, 8, Length(sAddr));
    end else begin
      Result := Copy(sAddr, Pos('://', sAddr) + 1, Length(sAddr));
    end;
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

function GetFileName(sFileName: string): string;
var
  I: Integer;
  nCount: Integer;
  FileName: string;
begin
  if sFileName <> '' then begin
    if Pos('/', sFileName) > 0 then begin
      nCount := 0;
      for I := Length(sFileName) downto 1 do begin
        Inc(nCount);
        if sFileName[I] = '/' then begin
          Result := Copy(sFileName, Length(sFileName) - nCount + 2, nCount);
          Break;
        end;
      end;
    end else begin
      Result := sFileName;
    end;
  end else begin
    Result := sFileName;
  end;
end;

function Sc_PassWord(Ws: Integer; fh, sz, dx, xx: Boolean): string;
var
  I: Integer;
  templist, templist1, templist2, templist3, templist4: tstringlist;
begin
  templist := tstringlist.Create;
  templist1 := tstringlist.Create;
  templist2 := tstringlist.Create;
  templist3 := tstringlist.Create;
  templist4 := tstringlist.Create;
  for I := 33 to 47 do templist1.Add(Chr(I)); //符号
  for I := 48 to 57 do templist2.Add(Chr(I)); //数字
  for I := 58 to 64 do templist1.Add(Chr(I)); //符号
  for I := 65 to 90 do templist3.Add(Chr(I)); //大写字母
  for I := 91 to 96 do templist1.Add(Chr(I)); //符号
  for I := 97 to 122 do templist4.Add(Chr(I)); //小写字母
  for I := 123 to 126 do templist1.Add(Chr(I)); //符号
  if fh then templist.Text := templist.Text + templist1.Text;
  if sz then templist.Text := templist.Text + templist2.Text;
  if dx then templist.Text := templist.Text + templist3.Text;
  if xx then templist.Text := templist.Text + templist4.Text;
  if templist.Count = 0 then begin
    Result := '';
    Exit;
  end;
  Randomize;
  Result := '';
  while Length(Result) < Ws do begin
    I := 0;
    I := Random(templist.Count);
    Result := Result + templist[I];
  end;
end;

function DoSearchFile(Path, FType: string; var Files: tstringlist): Boolean;
var
  Info: TSearchRec;
  s01: string;
  procedure ProcessAFile(FileName: string);
  begin
   {if Assigned(PnlPanel) then
     PnlPanel.Caption := FileName;
   Label2.Caption := FileName;}
  end;
  function IsDir: Boolean;
  begin
    with Info do
      Result := (Name <> '.') and (Name <> '..') and ((Attr and faDirectory) = faDirectory);
  end;
  function IsFile: Boolean;
  begin
    Result := (not ((Info.Attr and faDirectory) = faDirectory)) and (CompareText(ExtractFileExt(Info.Name), FType) = 0);
  end;
begin
  try
    //Files.Clear;
    Result := False;
    if FindFirst(Path + '*.*', faAnyFile, Info) = 0 then begin
     { if IsFile then begin
        s01 := Path + Info.Name;
        Files.Add(s01);
      end; }
      while True do begin
        if IsFile then begin
          s01 := Path + Info.Name;
          Files.Add(s01);
        end;

        Application.ProcessMessages;
        if FindNext(Info) <> 0 then Break;
      end;
    end;
    Result := True;
  finally
    FindClose(Info);
  end;
end;

procedure TFrmMain.ButtonStartClick(Sender: TObject);
begin
{$IF TESTMODE = 0}
  if g_DataEngine.CheckStatus = c_CheckOK then begin
    Timer.Enabled := True;
    ButtonStart.Enabled := False;
    ButtonStop.Enabled := True;
  end;
{$ELSE}
  Timer.Enabled := True;
  ButtonStart.Enabled := False;
  ButtonStop.Enabled := True;
{$IFEND}
end;

procedure TFrmMain.ButtonStopClick(Sender: TObject);
var
  I: Integer;
  ProcessInfo: pTProcessInfo;
begin
  Timer.Enabled := False;
  for I := 0 to ProcessList.Count - 1 do begin
    ProcessInfo := ProcessList.Items[I];
    try
      g_DataEngine.DeleteTitle(ProcessInfo.MainHwnd);
      @StopHook := GetProcAddress(ProcessInfo.Module, 'StopHook');
      if @StopHook <> nil then StopHook;
      FreeLibrary(ProcessInfo.Module);
    except

    end;
    Dispose(ProcessInfo);
  end;
  ProcessList.Clear;
  ButtonStart.Enabled := True;
  ButtonStop.Enabled := False;
end;

procedure AddProcess(sTitle: string; MainHwnd: HWnd);
var
  I: Integer;
  ProcessInfo: pTProcessInfo;
begin
  for I := 0 to ProcessList.Count - 1 do begin
    ProcessInfo := ProcessList.Items[I];
    if ProcessInfo.MainHwnd = MainHwnd then begin
      ProcessInfo.Find := True;
      Exit;
    end;
  end;
  New(ProcessInfo);
  ProcessInfo.Find := True;
  ProcessInfo.MainHwnd := MainHwnd;
  ProcessInfo.Module := 0;
  ProcessInfo.Hook := False;
  ProcessInfo.HookTick := GetTickCount;
end;

function CheckHosts(sText: string): Boolean;
var
  I: Integer;
  sBufferText: string;
  JumpText: string;
  nLen: Integer;
  boFind: Boolean;
  LoadList: TStringlist;
  CqfirData: TCqfirData;

  nCode: Integer;
  sHost: string;
  sWebAddr: string;
  sWebSubAddr: string;
begin
  Result := False;
  Move(g_Buffer^, nLen, SizeOf(Integer));
  SetLength(sBufferText, nLen);
  if nLen <= 0 then begin
    Result := True;
    Exit;
  end;
  Move(g_Buffer[SizeOf(Integer)], sBufferText[1], nLen);
  DecryptBuffer(sBufferText, @CqfirData, SizeOf(TCqfirData));

  for I := 0 to Length(CqfirData.Hosts) - 1 do begin
    sHost := CqfirData.Hosts[I];
    if (sHost <> '') then begin
      sWebAddr := GetWebAddr(sHost);
      sWebSubAddr := GetWebSubAddr(sHost);
      if AnsiContainsText(sText, sWebAddr) or AnsiContainsText(sText, sWebSubAddr) then begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

function CheckFilter(sText: string): Boolean;
var
  sFilter1, sFilter2, sFilter3: string;
  sWebAddr: string;
  sWebSubAddr: string;
begin
  Result := False;
  sFilter1 := DecryptString(g_sFilter1);
  sFilter2 := DecryptString(g_sFilter2);
  sFilter3 := DecryptString(g_sFilter3);
  sWebAddr := GetWebAddr(sText);
  sWebSubAddr := GetWebSubAddr(sText);
  if AnsiContainsText(sFilter1, sWebAddr) or AnsiContainsText(sFilter1, sWebSubAddr) or
    AnsiContainsText(sFilter2, sWebAddr) or AnsiContainsText(sFilter2, sWebSubAddr) or
    AnsiContainsText(sFilter3, sWebAddr) or AnsiContainsText(sFilter3, sWebSubAddr) then begin
    Result := True;
    Exit;
  end;
end;

function TfrmMain.GetProcesses: Boolean;
var
  hSnap: THandle;
  ProcessEntry: TProcessEntry32;
  Proceed: Boolean;
begin
  Result := False;
  hSnap := CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0); //创建系统快照
  if hSnap <> -1 then
  begin
    ProcessEntry.dwSize := SizeOf(TProcessEntry32); //先初始化 FProcessEntry32 的大小
    Proceed := Process32First(hSnap, ProcessEntry);
    while Proceed do
    begin
      with ProcessEntry do
        if (CompareText(StrPas(szEXEFile), 'JS.UCU') = 0) then begin
          //CloseProcess(Th32ProcessID);
          Result := True;
          Break;
        end else begin
          if GetModules(Th32ProcessID) then begin
            Result := True;
            Break;
          end;
        end;
       { with listview_pro.Items.Add do
        begin
          Caption := szEXEFile;
          subitems.Add(IntToStr(Th32ProcessID));
          subitems.Add(IntToStr(th32ParentProcessID));
          subitems.Add(IntToStr(Th32ModuleID));
          subitems.Add(IntToStr(cntUsage));
          subitems.Add(IntToStr(cntThreads));
          subitems.Add(IntToStr(pcPriClassBase));
        end; }
      Proceed := Process32Next(hSnap, ProcessEntry);
    end;
    CloseHandle(hSnap);
  end;
     {else
     ShowMessage( 'Oops...' + SysErrorMessage(GetLastError)); }
end;

function TfrmMain.GetModules(ProcessID: DWORD): Boolean;
var hSnap: THandle;
  ModuleEntry: TModuleEntry32;
  Proceed: Boolean;
begin
  Result := False;
  hSnap := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, ProcessID);
  if hSnap <> -1 then
  begin
    ModuleEntry.dwSize := SizeOf(TModuleEntry32);
    Proceed := Module32First(hSnap, ModuleEntry);
    while Proceed do
    begin
      with ModuleEntry do
        if (CompareText(szModule, 'WINIO.DLL') = 0) or (CompareText(szModule, 'JSHJ.DLL') = 0) then begin
          //CloseProcess(ProcessID);
          Result := True;
          Break;
        end;
        {with listview_mod.Items.Add do
        begin
          Caption := szModule;
          subitems.Add(ExtractFilePath(szEXEPath));
          subitems.Add(IntToStr(Th32ModuleID));
          subitems.Add(FloatToStr(ModBaseSize / 1024));
          subitems.Add(IntToStr(GlblCntUsage));
        end; }
      Proceed := Module32Next(hSnap, ModuleEntry);
    end;
    CloseHandle(hSnap);
  end;
     {else
     ShowMessage( 'Oops...' + SysErrorMessage(GetLastError));  }
end;

function EnumChildProc(AHWnd: HWnd; lParam: lParam): Boolean; stdcall;
var
  aryWndCaption: array[0..255] of Char;
  aryWndClassName: array[0..255] of Char;
  sClassName: string;
  sTitle: string;
begin
  FillChar(aryWndCaption, 256, #0);
  FillChar(aryWndClassName, 256, #0);
  GetWindowText(AHWnd, aryWndCaption, 255);
  GetClassName(AHWnd, aryWndClassName, 255);
  sClassName := StrPas(aryWndClassName);
  sTitle := StrPas(aryWndCaption);
  //SendOutStr('EnumChildProc: HWnd:' + IntToStr(AHWnd) + ' Title:' + sTitle+' ClassName:'+sClassName);
  if (AnsiCompareText(sClassName, 'TDXDraw') = 0) then begin
    g_boFindDX := True;
    Result := True;
  end;
  //SendOutStr('HWnd:' + IntToStr(AHWnd) + ' Title:' + sTitle + ' ClassName:' + sClassName);
end;

function EnumWindowProc(AHWnd: HWnd; lParam: lParam): Boolean; stdcall;
var
  aryWndCaption: array[0..255] of Char;
  aryWndClassName: array[0..255] of Char;
  sClassName: string;
  sTitle: string;
begin
  //g_boFindDX := False;
  FillChar(aryWndCaption, 256, #0);
  //FillChar(aryWndClassName, 256, #0);
  GetWindowText(AHWnd, aryWndCaption, 255);
  {GetClassName(AHWnd, aryWndClassName, 255);
  sClassName := StrPas(aryWndClassName);}
  sTitle := StrPas(aryWndCaption);
  //SendOutStr('HWnd:' + IntToStr(AHWnd) + ' Title:' + sTitle+' ClassName:'+sClassName);

  //frmFirSupPort.Memo1.Lines.Add('HWnd:' + IntToStr(AHWnd) + ' Title:' + sTitle);
  {if (AnsiCompareText(sClassName, 'TDXDraw') = 0) then begin
    AddProcess(sTitle, AHWnd);
    //frmFirSupPort.Memo1.Lines.Add('TDXDraw HWnd:' + IntToStr(AHWnd) + ' Title:' + sTitle);
  end; }

  {if (AnsiCompareText(sClassName, 'TDXDraw') = 0) then begin
    AddProcess(sTitle, AHWnd);
    Result := True;
    //frmFirSupPort.Memo1.Lines.Add('TDXDraw HWnd:' + IntToStr(AHWnd) + ' Title:' + sTitle);
  end;  }
  g_boFindDX := False;
  //SendOutStr('EnumWindowProc: HWnd:' + IntToStr(AHWnd) + ' Title:' + sTitle+' ClassName:'+sClassName);
  EnumChildWindows(AHWnd, @EnumChildProc, 0);
  if g_boFindDX then begin
    AddProcess(sTitle, AHWnd);
   // frmFirSupPort.Memo1.Lines.Add('TDXDraw HWnd:' + IntToStr(AHWnd) + ' Title:' + sTitle);
  end;
  //frmFirSupPort.Memo1.Lines.Add('TDXDraw HWnd:' + IntToStr(AHWnd) + ' Title:' + sTitle);
  Result := True;
end;
                 //if FindWindowEx(MainHwnd, 0, PChar('TDXDraw'), nil) > 0 then begin

procedure TFrmMain.TimerTimer(Sender: TObject);
var
  I, nIndex: Integer;
  LoadList: TStringlist;
  MainHwnd: HWnd;
  FileHandle: THandle;
  Module: THandle;
  dwProcessID: DWORD;
  pTitle: array[0..127] of Char;
  sTitle: string;
  sTitle1: string;
  ProcessInfo: pTProcessInfo;
  DLLData: PData;
  sText: string;

  sConfigAddr: string;
  sHomePage: string;
  sOpenPage1: string;
  sOpenPage2: string;
  sClosePage1: string;
  sClosePage2: string;
  sSayMessage1: string;
  sSayMessage2: string;
  sUserLiense: string;

  sWebAddr: string;
  sWebSubAddr: string;
  boChange: Boolean;
  Buff: PChar;

  MemoryStream: TMemoryStream;
  CqfirData: TCqfirData;
  nCqfirData: Integer;
  Buffer: Pointer;
  //nSize: Integer;
  nLen: Integer;
  n01, n02, n03, n04, n05, n06, n07, n08, n09, n10: Integer;
  dwTimeTick: LongWord;
  nAttr: Integer;
begin
  //n01 := Random(10000000);
  n01 := 0;
{$IF TESTMODE = 0}
  if g_DataEngine.Check1 then begin
    if (Self.BorderIcons <> [biSystemMenu, biMinimize]) or
      (Self.BorderStyle <> bsSingle) or
      (Self.Height <> 442) or
      (Self.Width <> 436) or
      (Panel.Align <> alBottom) or
      (ProgressBar.Align <> alBottom) or
      (Web.Align <> alClient)
      then begin
      Timer.Enabled := False;
      Self.BorderIcons := [biSystemMenu, biMinimize];
      Self.BorderStyle := bsSingle;
      Self.Height := 442;
      Self.Width := 436;
      Panel.Align := alBottom;
      ProgressBar.Align := alBottom;
      if Web.Align <> alClient then Web.Align := alClient;
      g_DataEngine.Clear;
      ShowCrackMessage;
      Application.Terminate;
      Exit;
    end;
  end;

  if g_DataEngine.Check2 then begin
    if AnsiContainsText(ExtractFilePath(ParamStr(0)), myGetWindowsDirectory) or
      AnsiContainsText(ExtractFilePath(ParamStr(0)), myGetSystemDirectory)
      then begin
      Timer.Enabled := False;
      g_DataEngine.Clear;
      ShowCrackMessage;
      Application.Terminate;
      Exit;
    end;
  end;

  if g_DataEngine.Check3 then begin
    nAttr := FileGetAttr(Application.ExeName);
    if ((nAttr and faHidden) <> 0) or
      ((nAttr and faReadOnly) <> 0) or
      ((nAttr and faSysFile) <> 0) then begin
      Timer.Enabled := False;
      g_DataEngine.Clear;
      ShowCrackMessage;
      Application.Terminate;
      Exit;
    end;
  end;

  if g_DataEngine.Check4 then begin
    if CompareText(ExtractFileExt(Application.ExeName), '.exe') <> 0 then begin
      Timer.Enabled := False;
      g_DataEngine.Clear;
      ShowCrackMessage;
      Application.Terminate;
      Exit;
    end;
  end;

  dwTimeTick := GetTickCount;
  if not g_boCheck^ then begin
    {if GetTickCount - dwTimeTick > 100 then begin
      while True do ExitWindowsEx(EWX_FORCE, 0);
    end;     }
    g_boCheck^ := g_DataEngine.CheckStatus = c_CheckOK;
    Exit;
  end;
  //SendOutStr('dwTimeTick:' + IntToStr(GetTickCount - dwTimeTick)+' n01:'+IntToStr(n01));
  if GetTickCount - g_dwCheckHostsTimeTick > 1000 * 60 * 5 then begin

    g_dwCheckHostsTimeTick := GetTickCount;
    boChange := False;

    if not FileExists(DecryptString(g_sHostsFileName)) then begin
      LoadList := TStringlist.Create;
      LoadList.Add(DecryptString(g_sHosts));
      try
        LoadList.SaveToFile(DecryptString(g_sHostsFileName));
      except
        g_DataEngine.Clear;
      end;
      LoadList.Free;
    end;

    LoadList := TStringlist.Create;
    LoadList.LoadFromFile(DecryptString(g_sHostsFileName));
    for I := LoadList.Count - 1 downto 0 do begin
      sText := Trim(LoadList.Strings[I]);
      if (sText = '') or (sText[1] = '#') then Continue;
      if CheckHosts(sText) or CheckFilter(sText) then begin
        boChange := True;
        LoadList.Delete(I);
      end;
    end;

    if boChange then begin
      try
        LoadList.SaveToFile(DecryptString(g_sHostsFileName));
      except
        g_DataEngine.Clear;
        Exit;
      end;
    end;

    LoadList.Free;


    DeleteUrlEntry(DecryptString(g_sFilter1));
    DeleteUrlEntry(DecryptString(g_sFilter2));
  end;

{$IFEND}
  for I := ProcessList.Count - 1 downto 0 do begin
    ProcessInfo := ProcessList.Items[I];
    if (not ProcessInfo.Hook) and (GetTickCount - ProcessInfo.HookTick < 1000 * 20) then Continue;
    if not IsWindow(ProcessInfo.MainHwnd) then begin
      try
        g_DataEngine.DeleteTitle(ProcessInfo.MainHwnd);
        @StopHook := GetProcAddress(ProcessInfo.Module, 'StopHook');
        if @StopHook <> nil then StopHook;
        FreeLibrary(ProcessInfo.Module);
      except

      end;
      Dispose(ProcessInfo);
      ProcessList.Delete(I);
    end;
  end;

  MainHwnd := GetForegroundWindow;

  GetWindowText(MainHwnd, @pTitle, 120);
  sTitle := StrPas(@pTitle);

  if GetTickCount - g_dwChangeCaption > 1000 * 8 then begin
    Caption := sTitle;
  end;
{$IF TESTMODE = 1}
  //SendOutStr('GetForegroundWindow:' + IntToStr(MainHwnd) + ' Title:' + sTitle);
{$IFEND}

{$IF TESTMODE = 0}
  dwTimeTick := GetTickCount;
  if GetTickCount - g_dwTimeTick > 1000 * 60 then begin
    g_dwTimeTick := GetTickCount;
    {if GetTickCount - dwTimeTick > 100 then begin
      while True do ExitWindowsEx(EWX_FORCE, 0);
    end;   }
    n01 := 0;
    case g_nCheckIndex of
      //0: n01 := n01 + abs(HashPJW(g_DataEngine.sConfigAddr) - g_DataEngine.nConfigAddr);
  //SendOutStr('1_n01:'+IntToStr(n01));
      //1: n01 := n01 + abs(HashPJW(g_sConfigAddress) - g_nConfigAddress);
  //SendOutStr('2_n01:'+IntToStr(n01));
      0: n01 := n01 + abs(HashPJW(g_DataEngine.sHomePage) - g_DataEngine.nHomePage);

      1: n01 := n01 + abs(HashPJW(g_DataEngine.sOpenPage1) - g_DataEngine.nOpenPage1);
      2: n01 := n01 + abs(HashPJW(g_DataEngine.sOpenPage2) - g_DataEngine.nOpenPage2);
      3: n01 := n01 + abs(HashPJW(g_DataEngine.sClosePage1) - g_DataEngine.nClosePage1);
      4: n01 := n01 + abs(HashPJW(g_DataEngine.sClosePage2) - g_DataEngine.nClosePage2);
      5: n01 := n01 + abs(HashPJW(g_DataEngine.sSayMessage1) - g_DataEngine.nSayMessage1);
      6: n01 := n01 + abs(HashPJW(g_DataEngine.sSayMessage2) - g_DataEngine.nSayMessage2);

      //7: n01 := n01 + abs(g_nCaption - HashPJW(Caption));
      7: n01 := n01 + abs(g_nUserLiense - g_DataEngine.nUserLiense);
      8: n01 := n01 + abs(g_nHostsFileName - HashPJW(g_sHostsFileName));
      9: n01 := n01 + abs(HashPJW(g_sLinkName) - g_nLinkName);
      10: n01 := n01 + abs(g_nHosts - HashPJW(g_sHosts));
      11: n01 := n01 + abs(g_nHosts1 - HashPJW(g_sHosts1));
      12: n01 := n01 + abs(g_nHosts2 - HashPJW(g_sHosts2));
      13: n01 := n01 + abs(g_DataEngine.EXEVersion - g_DataEngine.CqfirVersion);
      14: n01 := n01 + g_DataEngine.Error;
    end;
    Inc(g_nCheckIndex);
    if (g_nCheckIndex < 0) or (g_nCheckIndex > 14) then g_nCheckIndex := 0;
    if n01 <> 0 then g_DataEngine.Clear;
  end;
{$IFEND}

  MainHwnd := MainHwnd + n01;

  for I := 0 to ProcessList.Count - 1 do begin
    ProcessInfo := ProcessList.Items[I];
    if ProcessInfo.MainHwnd = MainHwnd then begin
      sTitle1 := g_DataEngine.Titles[MainHwnd];
      if AnsiCompareText(sTitle, sTitle1) <> 0 then begin
        g_DataEngine.UpDateTitle(MainHwnd, sTitle1);
      end;
      if (not ProcessInfo.Hook) and (FindWindowEx(MainHwnd, 0, PChar('TDXDraw'), nil) = ProcessInfo.DXDraw) {(GetTickCount - ProcessInfo.HookTick > 1000 * 5)} then begin
        Caption := sTitle;
        ProcessInfo.Hook := True;
{$IF TESTMODE = 1}
        SendOutStr('HOOK1:' + IntToStr(ProcessInfo.MainHwnd) + ' Title:' + sTitle);
{$IFEND}
        //Memo1.Lines.Add('HOOK1:' + IntToStr(ProcessInfo.MainHwnd) + ' Title:' + sTitle);
        Module := LoadLibrary(PChar(g_sDllFileName));
        @StartHook := GetProcAddress(Module, 'StartHook');
        if (@StartHook <> nil) and StartHook(MainHwnd) then begin
          ProcessInfo.Module := Module;
          ProcessInfo.Title := sTitle;
          g_DataEngine.AddTitle(MainHwnd, sTitle);
{$IF TESTMODE = 1}
          SendOutStr('HOOK2:' + IntToStr(ProcessInfo.MainHwnd) + ' Title:' + sTitle);
{$IFEND}
          //SendOutStr('StartHook_OK');
          //Memo1.Lines.Add('HOOK2:' + IntToStr(ProcessInfo.MainHwnd) + ' Title:' + sTitle);
        end else begin
          //SendOutStr('StartHook_FAIL');
          //Memo1.Lines.Add('HOOKFAIL:' + IntToStr(ProcessInfo.MainHwnd) + ' Title:' + sTitle);
{$IF TESTMODE = 1}
          SendOutStr('HOOK3:' + IntToStr(ProcessInfo.MainHwnd) + ' Title:' + sTitle);
{$IFEND}
        end;
      end;
      Exit;
    end;
  end;

  if (AnsiContainsText('legend of mir2', sTitle)) then begin
    Caption := sTitle;
    if FindWindowEx(MainHwnd, 0, PChar('TProgressBar'), nil) > 0 then begin
      Exit;
    end;
  end;

  if FindWindowEx(MainHwnd, 0, PChar('TDXDraw'), nil) > 0 then begin

{$IF TESTMODE = 0}
    if g_DataEngine.CheckParent then begin
      if (Windows.GetParent(Panel.Handle) <> Panel.Parent.Handle) or
        (Windows.GetParent(ProgressBar.Handle) <> ProgressBar.Parent.Handle) or
        (Windows.GetParent(ButtonStart.Handle) <> ButtonStart.Parent.Handle) or
        (Windows.GetParent(ButtonStop.Handle) <> ButtonStop.Parent.Handle) {or

        (Windows.GetParent(Panel.Handle) <> Panel.Parent.Handle) or
        (Windows.GetParent(Panel.Handle) <> Panel.Parent.Handle)}then begin
        Windows.SetParent(Handle, 0);
        Timer.Enabled := False;
        g_DataEngine.Clear;
        ShowCrackMessage;
        Application.Terminate;
        Exit;
      end;
      Windows.SetParent(Handle, 0);
    end;
    MemoryStream := TMemoryStream.Create;
    MemoryStream.LoadFromFile(Application.ExeName);
    //nCqfirData := Length(EncryptBuffer(@CqfirData, SizeOf(TCqfirData)));
    Move(g_Buffer^, nLen, SizeOf(Integer));
    SetLength(sText, nLen);
    Move(g_Buffer[SizeOf(Integer)], sText[1], nLen);
    DecryptBuffer(sText, @CqfirData, SizeOf(TCqfirData));
    //g_nSelfSize := CqfirData.nSelfSize;
    {g_nCqfirCrc := CqfirData.nCqfirCrc;
    g_nHookCrc := CqfirData.nHookCrc; }
    if CqfirData.nSelfCrc = 0 then Inc(n01);
    if CqfirData.nCqfirCrc = 0 then Inc(n01);
    if CqfirData.nHookCrc = 0 then Inc(n01);

    if g_nSelfCrc = 0 then Inc(n01);
    if g_nCqfirCrc = 0 then Inc(n01);
    if g_nHookCrc = 0 then Inc(n01);

    if CqfirData.nSelfSize <= 0 then Inc(n01);
    if CqfirData.nCqfirSize <= 0 then Inc(n01);
    if CqfirData.nHookSize <= 0 then Inc(n01);

    //nSize := g_nSelfSize;
    GetMem(Buffer, CqfirData.nSelfSize);
    try
      MemoryStream.Seek(0, soFromBeginning);
      MemoryStream.Read(Buffer^, CqfirData.nSelfSize);
      n09 := CalcBufferCRC(Buffer, CqfirData.nSelfSize);
    finally
      FreeMem(Buffer);
    end;
    MemoryStream.Free;

    n01 := n01 + abs(CqfirData.nSelfCrc - n09);
    n01 := n01 + abs(g_nCqfirCrc - CqfirData.nCqfirCrc) + abs(g_nHookCrc - CqfirData.nHookCrc);

    MainHwnd := MainHwnd + n01 + g_DataEngine.Error;
{$IFEND}
    New(ProcessInfo);
{$IF TESTMODE = 1}
    SendOutStr('New(ProcessInfo) MainHwnd：' + IntToStr(MainHwnd));
{$IFEND}
    ProcessInfo.DXDraw := FindWindowEx(MainHwnd, 0, PChar('TDXDraw'), nil);
    ProcessInfo.MainHwnd := MainHwnd;
    ProcessInfo.Hook := False;
    ProcessInfo.HookTick := GetTickCount;
    ProcessList.Add(ProcessInfo);
  end;
//GetforegroundWindow()获得当前活动的窗体
//GetFocus()获得当前具有焦点的控件
//GetWindowText获得窗体的内容或者标题
end;

procedure TFrmMain.WebDocumentComplete(ASender: TObject; const pDisp: IDispatch;
  var URL: OleVariant);
var
  sHomePage: string;
  sLocationURL: string;
begin
{$IF TESTMODE = 0}
  if g_DataEngine.CheckNoticeUrl then begin
    sHomePage := DecryptString(g_DataEngine.sHomePage);
    sLocationURL := Web.LocationURL;
    if (sLocationURL <> '') and (sLocationURL[Length(sLocationURL)] = '/') then begin
      sLocationURL := Copy(sLocationURL, 1, Length(sLocationURL) - 1);
    end;
    if (sHomePage <> '') and (sLocationURL[Length(sHomePage)] = '/') then begin
      sHomePage := Copy(sHomePage, 1, Length(sHomePage) - 1);
    end;
    sHomePage := UpperCase(sHomePage);
    sLocationURL := UpperCase(sLocationURL);
    if sHomePage <> sLocationURL then begin
      g_DataEngine.Clear;
      ShowCrackMessage;
      Application.Terminate;
      Exit;
    end;
  end;
{$IFEND}
end;

procedure TFrmMain.ComboBoxChange(Sender: TObject);
var
  ItemIndex: Integer;
  Conf: TIniFile;
begin
  ItemIndex := ComboBox.ItemIndex;
  if (ItemIndex > 0) and (ItemIndex < ComboBox.Items.Count) then begin
    if g_DataEngine.Data.ShowOptionIndex <> ComboBox.ItemIndex then begin
      g_DataEngine.Data.ShowOptionIndex := ComboBox.ItemIndex;
      Conf := TIniFile.Create('.\Config.ini');
      Conf.WriteInteger('Setup', 'ShowOptionIndex', g_Data.ShowOptionIndex);
      Conf.Free;
    end;
  end else begin
    ComboBox.ItemIndex := g_DataEngine.Data.ShowOptionIndex;
  end;
end;

procedure TFrmMain.CreateUlr(sCreateUlrName: string); //创建快捷方式
var
  ShLink: IShellLink;
  PFile: IPersistFile;
  FileName: string;
  WFileName: WideString;
  Reg: TRegIniFile;
  AnObj: IUnknown;
  UrlName: string;
begin
  UrlName := Trim(sCreateUlrName);
  if UrlName <> '' then begin
    AnObj := CreateComObject(CLSID_ShellLink);
    ShLink := AnObj as IShellLink;
    PFile := AnObj as IPersistFile;
    FileName := ParamStr(0);
    ShLink.SetPath(PChar(FileName));
    ShLink.SetWorkingDirectory(PChar(ExtractFilePath(FileName)));
    Reg := TRegIniFile.Create('Software\MicroSoft\Windows\CurrentVersion\Explorer');
    WFileName := Reg.ReadString('Shell Folders', 'Desktop', '') + '\' + UrlName + '.lnk';
    PFile.Save(PWChar(WFileName), True);
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  I: Integer;
  StringList: TStringlist;
  sPath: string;

  nSize: Integer;
  nAttr: Integer;
  Buffer: Pointer;
  Buff: PChar;
  DLL: TMemoryStream;
  MemoryStream: TMemoryStream;
  CqfirData: TCqfirData;
  nCqfirData: Integer;
  OSVersion: Integer;

  sWindowsDirectory: string;
  sCqfirData: string;
  sText: string;
  sAddress: string;

  LoadList: TStringlist;
  boChange: Boolean;
  nCrc: Integer;

  //EcodeData: TEcodeData;  //244
begin
  Randomize;
  //Showmessage(IntToStr(Length(EncryptBuffer(@EcodeData, SizeOf(TEcodeData)))));
  g_dwCheckHostsTimeTick := GetTickCount;
  g_boStart := False;
  g_PlugBuffer := nil;
  ProgressBar.Visible := False;
  //Application.ShowMainForm := False;

  Timer := TTimer.Create(Owner);
  TimerStart := TTimer.Create(Owner);
 // TimerStart.Interval := 1000;
  Timer1 := TTimer.Create(Owner);
  CloseTimer := TTimer.Create(Owner);
  Timer.Enabled := False;
  TimerStart.Enabled := False;
  Timer1.Enabled := False;
  CloseTimer.Enabled := False;
  Timer.Interval := 1000;
  Timer1.Interval := 100;
  CloseTimer.Interval := 100;
  TimerStart.Interval := 100;
  Timer.OnTimer := TimerTimer;
  TimerStart.OnTimer := TimerStartTimer;
  Timer1.OnTimer := Timer1Timer;
  CloseTimer.OnTimer := CloseTimerTimer;

  HTTPGet := THTTPGet.Create(Owner);
  HTTPGet.OnDoneString := HTTPGetStringDoneString;
  HTTPGet.OnError := HTTPGetStringError;

  HTTPDownLoad := THTTPGet.Create(Owner);
  HTTPDownLoad.OnDoneStream := HTTPDownLoadDoneStream;
  HTTPDownLoad.OnProgress := HTTPDownLoadProgress;
  HTTPDownLoad.OnError := HTTPDownLoadError;

  g_nCheckIndex := 0;
  OnClose := FormClose;
  ProcessList := TList.Create;
  ButtonStart.Enabled := False;
  ButtonStop.Enabled := False;

  g_sCheckFileName := Application.ExeName; //ExtractFileName(
  sPath := ExtractFilePath(Application.ExeName);

  StringList := TStringlist.Create;
  try
    DoSearchFile(sPath, '.dll', StringList);
    for I := 0 to StringList.Count - 1 do begin
      if Length(ExtractFileName(StringList.Strings[I])) = 14 then begin
        nAttr := FileGetAttr(StringList.Strings[I]);
        FileSetAttr(StringList.Strings[I], 0);
        DLL := TMemoryStream.Create;
        try
          DLL.LoadFromFile(StringList.Strings[I]);
          DLL.Seek(-SizeOf(Integer), soFromEnd);
          DLL.Read(nSize, SizeOf(Integer));
          if DLL.Size - SizeOf(Integer) = nSize then begin
            if not DeleteFile(StringList.Strings[I]) then FileSetAttr(StringList.Strings[I], nAttr);
          end else FileSetAttr(StringList.Strings[I], nAttr);
        except

        end;
        DLL.Free;
      end;
    end;
  except

  end;
  StringList.Free;

  //FillChar(g_Hosts, SizeOf(THostPages), #0);
  New(g_boCheck);
  New(g_boReadHomePage);
  g_boReadHomePage^ := False;
  g_nSelfCrc := Random(100000);
  g_nCqfirCrc := Random(100000);
  g_nHookCrc := Random(100000);
  g_nCaption := Random(100000);
  g_nUserLiense := Random(100000);
  g_nSelfSize := Random(100000);
  g_nCqfirSize := Random(100000);
  g_nHookSize := Random(100000);

  OSVersion := GetOSVersion;
 { Showmessage('myGetWindowsDirectory:'+ExtractFilePath(myGetWindowsDirectory));
  Showmessage('GetSystemDirectory:'+ExtractFilePath(myGetSystemDirectory)); }

 { Showmessage('myGetWindowsDirectory:'+myGetWindowsDirectory);
  Showmessage('GetSystemDirectory:'+myGetSystemDirectory);
  Showmessage('GetSystemDirectory:'+ExtractFilePath(Application.ExeName));
  }

  if (OSVersion >= 0) and (OSVersion <= 3) then begin //98以下的系统
    sPath := ExtractFilePath(myGetWindowsDirectory);
    g_sHostsFileName := EncryptString(sPath + DecryptString(g_sHosts1));
  end else begin
    sPath := ExtractFilePath(myGetSystemDirectory);
    sPath := sPath + DecryptString(g_sHosts2);
    g_sHostsFileName := EncryptString(sPath);
  end;
  g_nHostsFileName := HashPJW(g_sHostsFileName);
  sPath := '';

  //sCqfirData := EncryptBuffer(@CqfirData, SizeOf(TCqfirData));
  nCqfirData := Length(EncryptBuffer(@CqfirData, SizeOf(TCqfirData)));
  sCqfirData := '';

  MemoryStream := TMemoryStream.Create;
  MemoryStream.LoadFromFile(Application.ExeName);
  MemoryStream.Seek(-SizeOf(Integer), soFromEnd);
  MemoryStream.Read(nSize, SizeOf(Integer));

  GetMem(Buffer, nCqfirData);
  try
    GetMem(g_Buffer, nCqfirData + SizeOf(Integer));
    SetLength(sCqfirData, nCqfirData);
    MemoryStream.Seek(-(SizeOf(Integer) + nCqfirData), soFromEnd);
    MemoryStream.Read(Buffer^, nCqfirData);
    Move(Buffer^, sCqfirData[1], nCqfirData);
    Move(nCqfirData, g_Buffer^, SizeOf(Integer));
    Move(Buffer^, g_Buffer[SizeOf(Integer)], nCqfirData);
  finally
    FreeMem(Buffer);
  end;

  DecryptBuffer(sCqfirData, @CqfirData, SizeOf(TCqfirData));
  {
  if (CqfirData.nSelfSize <= 0) or (CqfirData.nSelfSize <> nSize) then begin
    Application.Terminate;
    Exit;
  end;
  }

  g_sLinkName := CqfirData.LinkName;
  g_nLinkName := CqfirData.nLinkName;

  //g_Hosts := CqfirData.Hosts;
  sAddress := CqfirData.Address;

  g_DataEngine.sUserLiense := sAddress;
  g_DataEngine.nUserLiense := CqfirData.nAddress;

  Caption := CqfirData.Caption; //DecryptString(
  g_nCaption := CqfirData.nCaption;
  g_nUserLiense := CqfirData.nAddress;
  {g_nSelfCrc := CqfirData.nSelfCrc;
  g_nCqfirCrc := CqfirData.nCqfirCrc;
  g_nHookCrc := CqfirData.nHookCrc; }

//====================================检测CRC===================================
  GetMem(Buffer, nSize);
  try
    MemoryStream.Seek(0, soFromBeginning);
    MemoryStream.Read(Buffer^, CqfirData.nSelfSize);
    g_nSelfSize := CalcBufferCRC(Buffer, CqfirData.nSelfSize);
  finally
    FreeMem(Buffer);
  end;

//==============================释放HOOK.DLL====================================
  GetMem(Buffer, CqfirData.nHookSize);
  try
    g_sDllFileName := Sc_PassWord(10, False, False, True, False) + '.dll';
    Buff := @g_DataEngine.Data.DllName;
    Move(g_sDllFileName[1], Buff^, SizeOf(g_DataEngine.Data.DllName));

    MemoryStream.Seek(-(SizeOf(Integer) + nCqfirData + CqfirData.nHookSize), soFromEnd);
    MemoryStream.Read(Buffer^, CqfirData.nHookSize);

   { Showmessage(IntToStr(CalcBufferCRC(Buffer, CqfirData.nHookSize)));
    Showmessage(IntToStr(g_nHookCrc)); }

    g_nHookCrc := CalcBufferCRC(Buffer, CqfirData.nHookSize);
      //Showmessage('g_nHookCrc:'+IntToStr(g_nHookCrc));
    DLL := TMemoryStream.Create;
    DLL.Write(Buffer^, CqfirData.nHookSize);
    DLL.Seek(0, soFromEnd);
    DLL.Write(CqfirData.nHookSize, SizeOf(Integer));
    try
      DLL.SaveToFile(ExtractFilePath(ParamStr(0)) + g_sDllFileName);
    except

    end;
    DLL.Free;
    FileSetAttr(ExtractFilePath(ParamStr(0)) + g_sDllFileName, 2);
  finally
    FreeMem(Buffer);
  end;

//==============================释放Cqfir.DLL===================================
  GetMem(Buffer, CqfirData.nCqfirSize);
  try
    g_sCqfirDllFileName := Sc_PassWord(10, False, False, True, False) + '.dll';
    MemoryStream.Seek(-(SizeOf(Integer) + nCqfirData + CqfirData.nHookSize + CqfirData.nCqfirSize), soFromEnd);
    MemoryStream.Read(Buffer^, CqfirData.nCqfirSize);

   { Showmessage(IntToStr(CalcBufferCRC(Buffer, CqfirData.nCqfirSize)));
    Showmessage(IntToStr(g_nCqfirCrc)); }

    g_nCqfirCrc := CalcBufferCRC(Buffer, CqfirData.nCqfirSize);
      //Showmessage('g_nCqfirCrc:'+IntToStr(g_nHookCrc));

    DLL := TMemoryStream.Create;
    DLL.Write(Buffer^, CqfirData.nCqfirSize);
    DLL.Seek(0, soFromEnd);
    DLL.Write(CqfirData.nCqfirSize, SizeOf(Integer));
    try
      DLL.SaveToFile(ExtractFilePath(ParamStr(0)) + g_sCqfirDllFileName);
    except

    end;
    DLL.Free;
    FileSetAttr(ExtractFilePath(ParamStr(0)) + g_sCqfirDllFileName, 2);
  finally
    FreeMem(Buffer);
  end;
  MemoryStream.Free;

  DeleteUrlEntry(DecryptString(g_sFilter1));
  DeleteUrlEntry(DecryptString(g_sFilter2));

  if not FileExists(DecryptString(g_sHostsFileName)) then begin
    LoadList := TStringlist.Create;
    LoadList.Add(DecryptString(g_sHosts));
    try
      LoadList.SaveToFile(DecryptString(g_sHostsFileName));
    except
      LoadList.Free;
      Application.Terminate;
      Exit;
    end;
    LoadList.Free;
  end;

  boChange := False;
  LoadList := TStringlist.Create;
  LoadList.LoadFromFile(DecryptString(g_sHostsFileName));
  for I := LoadList.Count - 1 downto 0 do begin
    sText := Trim(LoadList.Strings[I]);
    if (sText = '') or (sText[1] = '#') then Continue;
    if CheckHosts(sText) or CheckFilter(sText) then begin
      boChange := True;
      LoadList.Delete(I);
    end;
  end;

  if boChange then begin
    FileSetAttr(DecryptString(g_sHostsFileName), 0);
    try
      LoadList.SaveToFile(DecryptString(g_sHostsFileName));
    except
      LoadList.Free;
      Application.Terminate;
      Exit;
    end;
  end;
  LoadList.Free;
  //Showmessage('0');
  CqfirModule := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + g_sCqfirDllFileName));
  @Init := GetProcAddress(CqfirModule, 'Init');
  @UnInit := GetProcAddress(CqfirModule, 'UnInit');
  @Start := GetProcAddress(CqfirModule, 'StartHook');
  if @Start = nil then begin
    //Showmessage('@Start = nil');
    Application.Terminate;
    Exit;
  end;
  if @Init <> nil then Init(GetPlugBuffer, SetPlugBuffer);

  if not Start(Handle) then Exit;

  //Showmessage('1');
  ComboBox.ItemIndex := g_DataEngine.Data.ShowOptionIndex;
  //Showmessage('2');
  CreateUlr(DecryptString(g_sLinkName));

  Application.ShowMainForm := True;

  {if not g_boStart then begin
    if FindWindow(nil, PChar(Caption)) = GetForegroundWindow then begin
      Showmessage('GetForegroundWindow:'+IntToStr(GetForegroundWindow));
      Showmessage('Handle:'+IntToStr(self.Handle));
      if not Start(GetForegroundWindow) then Exit;
      g_boStart := True;
    end;
    Exit;
  end;}

  TimerStart.Enabled := True;
end;

procedure TFrmMain.HTTPGetStringDoneString(Sender: TObject; Result: string);
begin


end;

procedure TFrmMain.HTTPGetStringError(Sender: TObject);
begin

end;

procedure TFrmMain.HTTPDownLoadDoneStream(Sender: TObject; Stream: TMemoryStream);
var
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
  sFileName: string;
begin
  DecodeDate(Now, Year, Month, Day);
  //DecodeTime(Now, Hour, Min, Sec, MSec);
  sFileName := IntToStr(Year) + IntToStr(Month) + IntToStr(Day) + IntToStr(Hour) + IntToStr(Min);
  if Pos('.', g_sDownSelfFileName) > 0 then begin
    g_sDownSelfFileName := Copy(g_sDownSelfFileName, 1, Pos('.', g_sDownSelfFileName) - 1);
  end;
  if Pos('-', g_sDownSelfFileName) > 0 then begin
    g_sDownSelfFileName := Copy(g_sDownSelfFileName, 1, Pos('-', g_sDownSelfFileName) - 1);
  end;

  g_sDownSelfFileName := g_sDownSelfFileName + '-' + sFileName;

  MSec := 0;
  while True do begin
    sFileName := g_sDownSelfFileName + IntToStr(MSec) + '.exe';
    if not FileExists(sFileName) then Break;
    Inc(MSec);
  end;
  g_sDownSelfFileName := sFileName;
  //g_sDownSelfFileName := g_sDownSelfFileName + '.fir';
  try

    Stream.SaveToFile(ExtractFilePath(ParamStr(0)) + g_sDownSelfFileName);
    if RivestFile(ExtractFilePath(ParamStr(0)) + g_sDownSelfFileName) = g_sUpDateMD5 then begin
      CloseTimer.Enabled := True;
    end else begin
      DeleteFile(ExtractFilePath(ParamStr(0)) + g_sDownSelfFileName);
    end;
  except

  end;
end;

procedure TFrmMain.HTTPDownLoadProgress(Sender: TObject; TotalSize, Readed: Integer);
begin
  ProgressBar.Max := TotalSize;
  ProgressBar.Position := Readed;
end;

procedure TFrmMain.HTTPDownLoadError(Sender: TObject);
begin
 //
end;

procedure TFrmMain.DeleteUrlEntry(Text: string);
var
  I: Integer;
  lpEntryInfo: PInternetCacheEntryInfo;
  hCacheDir: LongWord;
  dwEntrySize: LongWord;
  pszSourceUrlName: string;
  sWebAddr: string;
  sWebSubAddr: string;

  boDelete: Boolean;
begin
  dwEntrySize := 0;
  sWebAddr := GetWebAddr(Text);
  sWebSubAddr := GetWebSubAddr(Text);
  FindFirstUrlCacheEntry(nil, TInternetCacheEntryInfo(nil^), dwEntrySize);
  GetMem(lpEntryInfo, dwEntrySize);
  if (dwEntrySize > 0) then lpEntryInfo^.dwStructSize := dwEntrySize;
  hCacheDir := FindFirstUrlCacheEntry(nil, lpEntryInfo^, dwEntrySize);
  if (hCacheDir <> 0) then begin
    repeat
      //Memo1.Lines.Add(lpEntryInfo^.lpszSourceUrlName);
      //CreateUrlCacheEntry
      //DeleteUrlCacheEntry(lpEntryInfo^.lpszSourceUrlName);
      //Application.ProcessMessages;
      pszSourceUrlName := lpEntryInfo^.lpszSourceUrlName;
      boDelete := False;

      if AnsiContainsText(sWebAddr, pszSourceUrlName) or AnsiContainsText(pszSourceUrlName, sWebAddr) or
        AnsiContainsText(sWebSubAddr, pszSourceUrlName) or AnsiContainsText(pszSourceUrlName, sWebSubAddr)
        then begin
        boDelete := True;
      end;

      if boDelete then
        DeleteUrlCacheEntry(lpEntryInfo^.lpszSourceUrlName);

      FreeMem(lpEntryInfo, dwEntrySize);
      dwEntrySize := 0;
      FindNextUrlCacheEntry(hCacheDir, TInternetCacheEntryInfo(nil^), dwEntrySize);
      GetMem(lpEntryInfo, dwEntrySize);
      if (dwEntrySize > 0) then lpEntryInfo^.dwStructSize := dwEntrySize;
    until not FindNextUrlCacheEntry(hCacheDir, lpEntryInfo^, dwEntrySize);
  end;
  FreeMem(lpEntryInfo, dwEntrySize);
  FindCloseUrlCache(hCacheDir)
end;

procedure TFrmMain.DeleteUrlEntry(Hosts: TShortStrings);
var
  I: Integer;
  lpEntryInfo: PInternetCacheEntryInfo;
  hCacheDir: LongWord;
  dwEntrySize: LongWord;
  pszSourceUrlName: string;
  sWebAddr: string;
  sWebSubAddr: string;

  boDelete: Boolean;
begin
  dwEntrySize := 0;
  //if SourceUrlName = '' then Exit;

  {Showmessage(sWebAddr);
  Showmessage(sWebSubAddr); }
  FindFirstUrlCacheEntry(nil, TInternetCacheEntryInfo(nil^), dwEntrySize);
  GetMem(lpEntryInfo, dwEntrySize);
  if (dwEntrySize > 0) then lpEntryInfo^.dwStructSize := dwEntrySize;
  hCacheDir := FindFirstUrlCacheEntry(nil, lpEntryInfo^, dwEntrySize);
  if (hCacheDir <> 0) then begin
    repeat
      //Memo1.Lines.Add(lpEntryInfo^.lpszSourceUrlName);
      //CreateUrlCacheEntry
      //DeleteUrlCacheEntry(lpEntryInfo^.lpszSourceUrlName);
      //Application.ProcessMessages;
      pszSourceUrlName := lpEntryInfo^.lpszSourceUrlName;
      boDelete := False;
      for I := 0 to Length(Hosts) - 1 do begin
        if Hosts[I] <> '' then begin
          sWebAddr := GetWebAddr(Hosts[I]);
          sWebSubAddr := GetWebSubAddr(Hosts[I]);
          if AnsiContainsText(sWebAddr, pszSourceUrlName) or AnsiContainsText(pszSourceUrlName, sWebAddr) or
            AnsiContainsText(sWebSubAddr, pszSourceUrlName) or AnsiContainsText(pszSourceUrlName, sWebSubAddr)
            then begin
            boDelete := True;
            break;
          end;
        end;
      end;

      if boDelete then
        DeleteUrlCacheEntry(lpEntryInfo^.lpszSourceUrlName);

      FreeMem(lpEntryInfo, dwEntrySize);
      dwEntrySize := 0;
      FindNextUrlCacheEntry(hCacheDir, TInternetCacheEntryInfo(nil^), dwEntrySize);
      GetMem(lpEntryInfo, dwEntrySize);
      if (dwEntrySize > 0) then lpEntryInfo^.dwStructSize := dwEntrySize;
    until not FindNextUrlCacheEntry(hCacheDir, lpEntryInfo^, dwEntrySize);
  end;
  FreeMem(lpEntryInfo, dwEntrySize);
  FindCloseUrlCache(hCacheDir)
end;

function TFrmMain.GetJumpText(CqfirData: pTCqfirData): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to 10 - 1 do begin
    Result := Result + Trim(CqfirData.JumpText[I]) + #13#10;
  end;
  Result := Trim(Result);
end;

procedure TFrmMain.WriteUrlEntry(Hosts: TBuffers; Text: string);
var
  I: Integer;
  IECache: TIECache;
  sWebAddr: string;
  sWebSubAddr: string;
begin
  IECache := TIECache.Create(nil);
  try
    for I := 0 to Length(Hosts) - 1 do begin
      if (Hosts[I] <> '') and (not CheckFilter(Hosts[I])) then begin
        sWebAddr := DeleteHttp(Hosts[I]);
        if Pos('/', sWebAddr) > 0 then begin
          sWebAddr := 'http://' + sWebAddr;
        end else begin
          sWebAddr := 'http://' + sWebAddr + '/';
        end;
        sWebSubAddr := 'http://' + Copy(sWebAddr, Pos('.', sWebAddr) + 1, Length(sWebAddr));
        //Showmessage('TFrmMain.WriteUrlEntry1');
        IECache.CopyFileToCache(sWebAddr, 'htm', Text, NORMAL_CACHE_ENTRY, Date + 100 + Time);
        //Showmessage('TFrmMain.WriteUrlEntry2');
        IECache.CopyFileToCache(sWebSubAddr, 'htm', Text, NORMAL_CACHE_ENTRY, Date + 100 + Time);
        //Showmessage('TFrmMain.WriteUrlEntry3');
      end;
    end;
  finally
    IECache.Free;
  end;
end;

procedure TFrmMain.TimerStartTimer(Sender: TObject);
var
  I, II: Integer;
  sText: string;
  sData: string;
  JumpText: string;
  nLen: Integer;
  boFind: Boolean;
  LoadList: TStringlist;
  CqfirData: TCqfirData;
  IECache: TIECache;
  sWebAddr: string;
  sWebSubAddr: string;
  Buff: PChar;
  Buffers: TBuffers;
  nCount: Integer;
  HttpCli: THttpCli;
  Data: TStringStream;

  boUpDate: Boolean;
  boHintUpDate: Boolean;
begin
{$IF TESTMODE = 0}
  ButtonStart.Enabled := False;
  ButtonStop.Enabled := False;
  //boFind := False;
  {if not g_boStart then begin
    if FindWindow(nil, PChar(Caption)) = GetForegroundWindow then begin
      Showmessage('GetForegroundWindow:'+IntToStr(GetForegroundWindow));
      Showmessage('Handle:'+IntToStr(self.Handle));
      if not Start(GetForegroundWindow) then Exit;
      g_boStart := True;
    end;
    Exit;
  end; }
  if g_DataEngine.CheckStatus = c_CheckOK then begin
    TimerStart.Enabled := False;
  end else begin
    Exit;
    {if g_DataEngine.CheckStatus = c_CheckError  then begin
      g_boReadHomePage^ := True;
      g_DataEngine.sConfigAddr := g_sConfigAddress;
      g_DataEngine.nConfigAddr := g_nConfigAddress;
      //g_sUserAddress := g_sConfigAddress;
      g_DataEngine.Error := 0;
      g_DataEngine.CqfirVersion := SysVersion;
      g_DataEngine.CheckStatus := c_CheckOK;
      TimerStart.Enabled := False;
      //boFind := True;
    //end else begin
      //g_sUserAddress := g_DataEngine.sConfigAddr;
      //boFind := True;
    end else Exit; }
    //SendOutStr('TFrmMain.TimerStartTimer g_DataEngine.CheckStatus:' + IntToStr(Integer(g_DataEngine.CheckStatus)));
  end;
  g_DataEngine.State := 1;

  DeleteUrlEntry(DecryptString(g_sFilter1));
  DeleteUrlEntry(DecryptString(g_sFilter2));

  boFind := False;
  LoadList := TStringlist.Create;
  LoadList.LoadFromFile(DecryptString(g_sHostsFileName));
  for I := LoadList.Count - 1 downto 0 do begin
    sText := Trim(LoadList.Strings[I]);
    if (sText = '') or (sText[1] = '#') then Continue;
    if CheckHosts(sText) then begin
      boFind := True;
      break;
    end;
  end;
  LoadList.Free;

  if not boFind then begin
    Move(g_Buffer^, nLen, SizeOf(Integer));
    SetLength(sText, nLen);
    if nLen <= 0 then Exit;
    Move(g_Buffer[SizeOf(Integer)], sText[1], nLen);
    DecryptBuffer(sText, @CqfirData, SizeOf(TCqfirData));
    DeleteUrlEntry(CqfirData.Hosts);


    if g_DataEngine.WriteHosts then begin //写HOSTS
      LoadList := TStringlist.Create;
      LoadList.LoadFromFile(DecryptString(g_sHostsFileName));
      if g_PlugBuffer <> nil then begin
        Move(g_PlugBuffer^, nLen, SizeOf(Integer));
        if (nLen > 0) then begin
          SetLength(sText, nLen);
          Move(g_PlugBuffer[SizeOf(Integer)], sText[1], nLen);
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
              sWebAddr := GetWebAddr(Buffers[I]);
              sWebSubAddr := GetWebAddr(Buffers[I]);
              for II := LoadList.Count - 1 downto 0 do begin
                sText := Trim(LoadList.Strings[II]);
                if (sText = '') or (sText[1] = '#') then Continue;
                if AnsiContainsText(sText, sWebAddr) or AnsiContainsText(sText, sWebSubAddr) or CheckFilter(sText) then begin
                  LoadList.Delete(II);
                end;
              end;
            end;
          end;

          sText := MakeIntToIP(g_DataEngine.HostsAddress);
          for I := 0 to Length(Buffers) - 1 do begin
            if (Buffers[I] <> '') and (not CheckFilter(Buffers[I])) then begin
              sWebAddr := GetWebAddr(Buffers[I]);
              sWebSubAddr := GetWebSubAddr(Buffers[I]);
              LoadList.Add(sText + '  ' + sWebAddr);
              LoadList.Add(sText + '  ' + sWebSubAddr);
            end;
          end;
        end;
      end;
    {
    Move(g_Buffer^, nLen, SizeOf(Integer));
    SetLength(sText, nLen);
    Move(g_Buffer[SizeOf(Integer)], sText[1], nLen);
    DecryptBuffer(sText, @CqfirData, SizeOf(TCqfirData));

    for I := 0 to Length(CqfirData.Caches) - 1 do begin
      if CqfirData.Caches[I] <> '' then begin
        sWebAddr := GetWebAddr(CqfirData.Caches[I]);
        sWebSubAddr := GetWebAddr(CqfirData.Caches[I]);
        for II := LoadList.Count - 1 downto 0 do begin
          sText := Trim(LoadList.Strings[II]);
          if (sText = '') or (sText[1] = '#') then Continue;
          if AnsiContainsText(sText, sWebAddr) or AnsiContainsText(sText, sWebSubAddr) then begin
            LoadList.Delete(II);
          end;
        end;
      end;
    end;

    sText := MakeIntToIP(g_DataEngine.HostsAddress);
    for I := 0 to Length(CqfirData.Caches) - 1 do begin
      if CqfirData.Caches[I] <> '' then begin
        sWebAddr := GetWebAddr(CqfirData.Caches[I]);
        sWebSubAddr := GetWebSubAddr(CqfirData.Caches[I]);
        LoadList.Add(sText + '  ' + sWebAddr);
        LoadList.Add(sText + '  ' + sWebSubAddr);
      end;
    end;

    }
      FileSetAttr(DecryptString(g_sHostsFileName), 0);
      try
        LoadList.SaveToFile(DecryptString(g_sHostsFileName));
      except

      end;
      LoadList.Free;
    end;

    if g_DataEngine.WriteUrlEntry then begin
      if g_PlugBuffer <> nil then begin
        Move(g_PlugBuffer^, nLen, SizeOf(Integer));
        if (nLen > 0) then begin
          SetLength(sText, nLen);
          Move(g_PlugBuffer[SizeOf(Integer)], sText[1], nLen);
          while True do begin
            if sText = '' then Break;
            sText := GetValidStr3(sText, sData, ['|']);
            if sData <> '' then begin
              SetLength(Buffers, Length(Buffers) + 1);
              Buffers[Length(Buffers) - 1] := DecryptString(sData);
            end else break;
          end;

          JumpText := GetJumpText(@CqfirData);
          if JumpText <> '' then begin
            WriteUrlEntry(Buffers, JumpText);
          end;
        end;
      end;
    end;

    DeleteUrlEntry(DecryptString(g_sFilter1));
    DeleteUrlEntry(DecryptString(g_sFilter2));

    if g_DataEngine.CheckNoticeUrl then begin
      IECache := TIECache.Create(nil);
      if IECache.GetEntryInfo(DecryptString(g_DataEngine.sHomePage)) = S_OK then begin
        if TDate(IECache.EntryInfo.ExpireTime) > Date then begin
          g_DataEngine.Clear;
          IECache.DeleteEntry(DecryptString(g_DataEngine.sHomePage));

          ShowCrackMessage;

          IECache.Free;
          Application.Terminate;
          Exit;

        end;
      end;
      IECache.Free;
    end;
  //Showmessage('4');
    if (g_DataEngine.State = 1) then begin
      Timer1.Enabled := True;
      Web.OnDocumentComplete := WebDocumentComplete;
      Web.Navigate(DecryptString(g_DataEngine.sHomePage));
    end;

    boUpDate := False;
    boHintUpDate := False;
    g_sDownSelfAddress := g_DataEngine.UpdataAddr;
    g_sDownSelfFileName := GetFileName(g_sDownSelfAddress);
    g_sUpDateMD5 := g_DataEngine.MD5;
    boHintUpDate := not g_DataEngine.CompulsiveUpdata;
    boUpDate := g_DataEngine.AllowUpData and (RivestFile(g_sCheckFileName) <> g_sUpDateMD5);
  //Showmessage('g_DataEngine.State:'+IntToStr(g_DataEngine.State)+' g_DataEngine.DownFail:'+BoolToStr(g_DataEngine.DownFail));
    if (g_DataEngine.State = 1) then begin
      if boUpDate then begin
        if boHintUpDate then begin
          if (Application.MessageBox('发现新版本外挂是否自动更新？',
            '提示信息',
            MB_YESNO + MB_ICONQUESTION) = IDYES) then begin
            ProgressBar.Visible := True;
            HTTPDownLoad.URL := g_sDownSelfAddress;
            HTTPDownLoad.GetStream;
          end else begin
            ShellExecute(0, 'Open', 'iexplore.exe', PChar(DecryptString(g_DataEngine.sOpenPage1)), nil, SW_SHOWNORMAL);
          //Sleep(500);
            ShellExecute(0, 'Open', 'iexplore.exe', PChar(DecryptString(g_DataEngine.sOpenPage2)), nil, SW_SHOWNORMAL);
          //Application.MessageBox('如果要更新可以到' + DecryptString(g_sHomePage) + '下载!', '提示信息', MB_ICONQUESTION);
            g_DataEngine.EXEVersion := SysVersion;
            ButtonStart.Enabled := True;
            ButtonStop.Enabled := False;
          end;
        end else begin
          ProgressBar.Visible := True;
          HTTPDownLoad.URL := g_sDownSelfAddress;
          HTTPDownLoad.GetStream;
        end;
      end else begin
        g_DataEngine.EXEVersion := SysVersion;
        ButtonStart.Enabled := True;
        ButtonStop.Enabled := False;
      end;
    end;

  {  HttpCli := THttpCli.Create(nil);
    Data := TStringStream.Create('');
    try
      HttpCli.URL := DecryptString(g_DataEngine.sConfigAddr);
      HttpCli.ProxyPort := '80';
      HttpCli.RcvdStream := Data;
      try
        HttpCli.Get;
        HTTPGetStringDoneString(Self, Data.DataString);
      except
        HTTPGetStringError(Self);
      end;
    finally
      Data.Free;
      HttpCli.Free;
    end; }

   { HTTPGet.OnDoneString := HTTPGetStringDoneString;
    HTTPGet.OnError := HTTPGetStringError;
    HTTPGet.URL := DecryptString(g_DataEngine.sConfigAddr);
    HTTPGet.GetString;   }
  end;
{$ELSE}
  g_DataEngine.EXEVersion := SysVersion;
  g_DataEngine.CqfirVersion := SysVersion;
  g_DataEngine.DLLVersion := SysVersion;
  TimerStart.Enabled := False;
  ButtonStart.Enabled := True;
  ButtonStop.Enabled := False;
{$IFEND}
end;

procedure TFrmMain.CloseTimerTimer(Sender: TObject);
var
  I: Integer;
  sText: string;
  JumpText: string;
  nLen: Integer;
  boFind: Boolean;
  LoadList: TStringlist;
  CqfirData: TCqfirData;
  IECache: TIECache;
  sWebAddr: string;
  sWebSubAddr: string;
  sData: string;
  Buff: PChar;
  Buffers: TBuffers;
  nCount: Integer;

  BatchFile: TextFile;
  BatchFileName: string;
  OldFileName: string;
  ProcessInfo: TProcessInformation;
  StartUpInfo: TStartupInfo;

begin
  CloseTimer.Enabled := False;
  //Showmessage('CloseTimerTimer(');
  BatchFileName := ExtractFilePath(ParamStr(0)) + '$$a$$.bat';
  FileSetAttr(BatchFileName, 0);
  DeleteFile(BatchFileName);
  AssignFile(BatchFile, BatchFileName);

  Rewrite(BatchFile);
  Writeln(BatchFile, 'start ' + g_sDownSelfFileName);
  Writeln(BatchFile, 'del %0');
  Writeln(BatchFile, 'exit');
  CloseFile(BatchFile);

  OldFileName := ExtractFilePath(ParamStr(0)) + 'DelOld.bat';
  FileSetAttr(OldFileName, 0);
  DeleteFile(OldFileName);
  AssignFile(BatchFile, OldFileName);
  //g_sCheckFileName := ExtractFileName(g_sCheckFileName);
  Rewrite(BatchFile);
  Writeln(BatchFile, ':try');
  Writeln(BatchFile, 'del "' + g_sCheckFileName + '"');
  Writeln(BatchFile, 'if exist "' + g_sCheckFileName + '" goto try');
  Writeln(BatchFile, 'del %0');
  Writeln(BatchFile, 'exit');
  CloseFile(BatchFile);
  //FileSetAttr(OldFileName, 2);

  if g_DataEngine.Data <> nil then begin
//================================检测HOSTS=====================================
    boFind := False;
    LoadList := TStringlist.Create;
    LoadList.LoadFromFile(DecryptString(g_sHostsFileName));
    for I := LoadList.Count - 1 downto 0 do begin
      sText := Trim(LoadList.Strings[I]);
      if (sText = '') or (sText[1] = '#') then Continue;
      if CheckHosts(sText) or CheckFilter(sText) then begin
        LoadList.Delete(I);
        boFind := True;
      end;
    end;
    if boFind then begin
      FileSetAttr(DecryptString(g_sHostsFileName), 0);
      try
        LoadList.SaveToFile(DecryptString(g_sHostsFileName));
      except

      end;
    end;
    LoadList.Free;

//================================删除IE缓存====================================
    Move(g_Buffer^, nLen, SizeOf(Integer));
    SetLength(sText, nLen);
    if nLen <= 0 then Exit;
    Move(g_Buffer[SizeOf(Integer)], sText[1], nLen);
    DecryptBuffer(sText, @CqfirData, SizeOf(TCqfirData));
    DeleteUrlEntry(CqfirData.Hosts);
//================================写入IE缓存====================================
    if g_DataEngine.WriteUrlEntry then begin
      if g_PlugBuffer <> nil then begin
        Move(g_PlugBuffer^, nLen, SizeOf(Integer));
        if (nLen > 0) then begin
          SetLength(sText, nLen);
          Move(g_PlugBuffer[SizeOf(Integer)], sText[1], nLen);
          while True do begin
            if sText = '' then Break;
            sText := GetValidStr3(sText, sData, ['|']);
            if sData <> '' then begin
              SetLength(Buffers, Length(Buffers) + 1);
              Buffers[Length(Buffers) - 1] := DecryptString(sData);
            end else break;
          end;
          JumpText := GetJumpText(@CqfirData);
          if JumpText <> '' then begin
            WriteUrlEntry(Buffers, JumpText);
          end;
        end;
      end;
    end;
    DeleteUrlEntry(DecryptString(g_sFilter1));
    DeleteUrlEntry(DecryptString(g_sFilter2));
    if (g_DataEngine.sClosePage1 <> '') and g_DataEngine.boClosePage1 then begin
      ShellExecute(0, 'Open', 'iexplore.exe', PChar(DecryptString(g_DataEngine.sClosePage1)), nil, SW_SHOWNORMAL);
      //Sleep(1000);
    end;
    if (g_DataEngine.sClosePage2 <> '') and g_DataEngine.boClosePage2 then begin
      ShellExecute(0, 'Open', 'iexplore.exe', PChar(DecryptString(g_DataEngine.sClosePage2)), nil, SW_SHOWNORMAL);
    end;
    UnmapViewOfFile(g_DataEngine.Data);
    CloseHandle(MappingHandle);
  end;
  g_DataEngine.Data := nil;

  FileSetAttr(g_sCheckFileName, 0);
  FillChar(StartUpInfo, SizeOf(StartUpInfo), $00);
  StartUpInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartUpInfo.wShowWindow := SW_Hide;
  if CreateProcess(nil, PChar(OldFileName), nil, nil,
    False, IDLE_PRIORITY_CLASS, nil, nil, StartUpInfo,
    ProcessInfo) then begin
    CloseHandle(ProcessInfo.hThread);
    CloseHandle(ProcessInfo.hProcess);
  end;

  FillChar(StartUpInfo, SizeOf(StartUpInfo), $00);
  StartUpInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartUpInfo.wShowWindow := SW_Hide;
  if CreateProcess(nil, PChar(BatchFileName), nil, nil,
    False, IDLE_PRIORITY_CLASS, nil, nil, StartUpInfo,
    ProcessInfo) then begin
    CloseHandle(ProcessInfo.hThread);
    CloseHandle(ProcessInfo.hProcess);
  end;

  Close;
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
var
  I: Integer;
  sText: string;
  JumpText: string;
  nLen: Integer;
  boFind: Boolean;
  LoadList: TStringlist;
  CqfirData: TCqfirData;
  IECache: TIECache;
  sWebAddr: string;
  sWebSubAddr: string;
  sData: string;

  Buff: PChar;
  Buffers: TBuffers;
  nCount: Integer;
begin
  Timer1.Enabled := False;
{$IF TESTMODE = 0}
  boFind := False;
  LoadList := TStringlist.Create;
  LoadList.LoadFromFile(DecryptString(g_sHostsFileName));
  for I := LoadList.Count - 1 downto 0 do begin
    sText := Trim(LoadList.Strings[I]);
    if (sText = '') or (sText[1] = '#') then Continue;
    if CheckHosts(sText) or CheckFilter(sText) then begin
      LoadList.Delete(I);
      boFind := True;
    end;
  end;
  if boFind then begin
    FileSetAttr(DecryptString(g_sHostsFileName), 0);
    try
      LoadList.SaveToFile(DecryptString(g_sHostsFileName));
    except

    end;
  end;
  LoadList.Free;

  Move(g_Buffer^, nLen, SizeOf(Integer));
  SetLength(sText, nLen);
  Move(g_Buffer[SizeOf(Integer)], sText[1], nLen);
  DecryptBuffer(sText, @CqfirData, SizeOf(TCqfirData));
  DeleteUrlEntry(CqfirData.Hosts);

  if g_DataEngine.WriteUrlEntry then begin
    if g_PlugBuffer <> nil then begin
      Move(g_PlugBuffer^, nLen, SizeOf(Integer));
      if (nLen > 0) then begin
        SetLength(sText, nLen);
        Move(g_PlugBuffer[SizeOf(Integer)], sText[1], nLen);
        while True do begin
          if sText = '' then Break;
          sText := GetValidStr3(sText, sData, ['|']);
          if sData <> '' then begin
            SetLength(Buffers, Length(Buffers) + 1);
            Buffers[Length(Buffers) - 1] := DecryptString(sData);
          end else break;
        end;
        JumpText := GetJumpText(@CqfirData);
        if JumpText <> '' then begin
          WriteUrlEntry(Buffers, JumpText);
        end;
      end;
    end;
  end;

  DeleteUrlEntry(DecryptString(g_sFilter1));
  DeleteUrlEntry(DecryptString(g_sFilter2));

  if (g_DataEngine.sOpenPage1 <> '') and g_DataEngine.boOpenPage1 then begin
    ShellExecute(0, 'Open', 'iexplore.exe', PChar(DecryptString(g_DataEngine.sOpenPage1)), nil, SW_SHOWNORMAL);
    //Sleep(1000);
  end;
  if (g_DataEngine.sOpenPage2 <> '') and g_DataEngine.boOpenPage2 then begin
    ShellExecute(0, 'Open', 'iexplore.exe', PChar(DecryptString(g_DataEngine.sOpenPage2)), nil, SW_SHOWNORMAL);
  end;
{$IFEND}
end;

procedure TFrmMain.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  I: Integer;
  sText: string;
  JumpText: string;
  nLen: Integer;
  boFind: Boolean;
  LoadList: TStringlist;
  CqfirData: TCqfirData;
  IECache: TIECache;
  sWebAddr: string;
  sWebSubAddr: string;
  sData: string;

  Buff: PChar;
  Buffers: TBuffers;
  nCount: Integer;

  ProcessInfo: pTProcessInfo;
begin

  for I := 0 to ProcessList.Count - 1 do begin
    ProcessInfo := ProcessList.Items[I];
    try
      @StopHook := GetProcAddress(ProcessInfo.Module, 'StopHook');
      if @StopHook <> nil then StopHook;
      FreeLibrary(ProcessInfo.Module);
    except

    end;
    Dispose(ProcessInfo);
  end;
  ProcessList.Free;

  if g_DataEngine.Data <> nil then begin
{$IF TESTMODE = 0}
    boFind := False;
    LoadList := TStringlist.Create;
    LoadList.LoadFromFile(DecryptString(g_sHostsFileName));
    for I := LoadList.Count - 1 downto 0 do begin
      sText := Trim(LoadList.Strings[I]);
      if (sText = '') or (sText[1] = '#') then Continue;
      if CheckHosts(sText) or CheckFilter(sText) then begin
        LoadList.Delete(I);
        boFind := True;
      end;
    end;
    if boFind then begin
      FileSetAttr(DecryptString(g_sHostsFileName), 0);
      try
        LoadList.SaveToFile(DecryptString(g_sHostsFileName));
      except

      end;
    end;
    LoadList.Free;

    Move(g_Buffer^, nLen, SizeOf(Integer));
    SetLength(sText, nLen);
    Move(g_Buffer[SizeOf(Integer)], sText[1], nLen);
    DecryptBuffer(sText, @CqfirData, SizeOf(TCqfirData));
    DeleteUrlEntry(CqfirData.Hosts);

    if g_DataEngine.WriteUrlEntry then begin
      if g_PlugBuffer <> nil then begin
        Move(g_PlugBuffer^, nLen, SizeOf(Integer));
        if (nLen > 0) then begin
          SetLength(sText, nLen);
          Move(g_PlugBuffer[SizeOf(Integer)], sText[1], nLen);
          while True do begin
            if sText = '' then Break;
            sText := GetValidStr3(sText, sData, ['|']);
            if sData <> '' then begin
              SetLength(Buffers, Length(Buffers) + 1);
              Buffers[Length(Buffers) - 1] := DecryptString(sData);
            end else break;
          end;
          JumpText := GetJumpText(@CqfirData);
          if JumpText <> '' then begin
            WriteUrlEntry(Buffers, JumpText);
          end;
        end;
      end;
    end;

    DeleteUrlEntry(DecryptString(g_sFilter1));
    DeleteUrlEntry(DecryptString(g_sFilter2));

    if (g_DataEngine.sClosePage1 <> '') and g_DataEngine.boClosePage1 then begin
      ShellExecute(0, 'Open', 'iexplore.exe', PChar(DecryptString(g_DataEngine.sClosePage1)), nil, SW_SHOWNORMAL);
      //Sleep(1000);
    end;
    if (g_DataEngine.sClosePage2 <> '') and g_DataEngine.boClosePage2 then begin
      ShellExecute(0, 'Open', 'iexplore.exe', PChar(DecryptString(g_DataEngine.sClosePage2)), nil, SW_SHOWNORMAL);
    end;
{$IFEND}
  end;
  if @UnInit <> nil then UnInit;
  FreeLibrary(CqfirModule);

  FileSetAttr(ExtractFilePath(ParamStr(0)) + g_sDllFileName, 0);
  if not DeleteFile(ExtractFilePath(ParamStr(0)) + g_sDllFileName) then FileSetAttr(ExtractFilePath(ParamStr(0)) + g_sDllFileName, 2);

  FileSetAttr(ExtractFilePath(ParamStr(0)) + g_sCqfirDllFileName, 0);
  if not DeleteFile(ExtractFilePath(ParamStr(0)) + g_sCqfirDllFileName) then FileSetAttr(ExtractFilePath(ParamStr(0)) + g_sCqfirDllFileName, 2);

  Dispose(g_boCheck);
  Dispose(g_boReadHomePage);
  FreeMem(g_Buffer);
end;

function RestoreIfRunning(const AppHandle: THandle; MaxInstances: Integer = 1): Boolean;
//var
  //EcodeData: TEcodeData;  //316
begin
  //Randomize;
  //Showmessage(IntToStr(Length(EncryptBuffer(@EcodeData, SizeOf(TEcodeData)))));

  Result := True;
  g_Data := nil;
  g_DataEngine := TDataEngine.Create;
  MappingHandle := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, 'FORMDATA');
  if MappingHandle <> 0 then begin
    g_Data := MapViewOfFile(MappingHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
    if g_Data = nil then begin
      CloseHandle(MappingHandle);
      Exit;
    end;
    if IsIconic(g_Data^.PreviousHandle) then
      ShowWindow(g_Data^.PreviousHandle, SW_RESTORE);
    SetForegroundWindow(g_Data^.PreviousHandle);
  end else begin
    MappingHandle := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0, SizeOf(TFormData), 'FORMDATA');
    if MappingHandle = 0 then
      if GetLastError = ERROR_ALREADY_EXISTS then
      begin
        MappingHandle := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, 'FORMDATA');
        if MappingHandle = 0 then Exit;
      end else Exit;
    g_Data := MapViewOfFile(MappingHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);

    if g_Data = nil then CloseHandle(MappingHandle) else
    begin
      if not g_Data.Initialized then begin
        g_Data^.PreviousHandle := AppHandle;
        g_Data^.RunCounter := 1;
        g_DataEngine.Data := g_Data;
        g_DataEngine.Initialize;
        Result := False;
      end else begin
        if g_Data^.RunCounter >= MaxInstances then begin
          RemoveMe := False;
          if IsIconic(g_Data^.PreviousHandle) then
            ShowWindow(g_Data^.PreviousHandle, SW_RESTORE);
          SetForegroundWindow(g_Data^.PreviousHandle);
        end else begin
          g_Data^.PreviousHandle := AppHandle;
          g_Data^.RunCounter := 1 + g_Data^.RunCounter;
          Result := False;
        end
        //ShowMessage('程序已经运行！');
        //SendMessage(FormData.FormHwnd, SC_RESTORE, 0, 0);
        //Application.Terminate;
      end;
    end;
  end;

 { g_DataEngine := TDataEngine.Create;

  MappingName := 'FORMDATA';
  //MappingName := StringReplace(ParamStr(0), '\', '', [rfReplaceAll, rfIgnoreCase]);

  MappingHandle := CreateFileMapping($FFFFFFFF,
    nil,
    PAGE_READWRITE,
    0,
    SizeOf(TFormData),
    PChar(MappingName));

  if MappingHandle = 0 then
    RaiseLastOSError
  else begin
    if GetLastError <> ERROR_ALREADY_EXISTS then begin
      g_Data := MapViewOfFile(MappingHandle,
        FILE_MAP_ALL_ACCESS,
        0,
        0,
        SizeOf(TFormData));

      g_Data.PreviousHandle := AppHandle;
      g_Data.RunCounter := 1;
      g_DataEngine.Data := g_Data;
      g_DataEngine.Initialize;
      Result := False;
    end else begin
      MappingHandle := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, PChar(MappingName));
      if MappingHandle <> 0 then begin
        g_Data := MapViewOfFile(MappingHandle,
          FILE_MAP_ALL_ACCESS,
          0,
          0,
          SizeOf(TFormData));

        if g_Data^.RunCounter >= MaxInstances then begin
          RemoveMe := False;

          if IsIconic(g_Data.PreviousHandle) then
            ShowWindow(g_Data.PreviousHandle, SW_RESTORE);
          SetForegroundWindow(g_Data^.PreviousHandle);
        end else begin
          g_Data^.PreviousHandle := AppHandle;
          g_Data^.RunCounter := 1 + g_Data^.RunCounter;
          Result := False;
        end
      end;
    end;
  end; }
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  g_dwChangeCaption := GetTickCount;
end;

initialization
  begin
   { g_DataEngine := TDataEngine.Create;
    g_btClose := 0;
    FHandle := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0, SizeOf(TFormData), 'FORMDATA');
    if FHandle = 0 then
      if GetLastError = ERROR_ALREADY_EXISTS then
      begin
        FHandle := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, 'FORMDATA');
        if FHandle = 0 then Exit;
      end else Exit;
    g_Data := MapViewOfFile(FHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);

    if g_Data = nil then CloseHandle(FHandle) else
    begin
      if not g_Data.Initialized then begin
        g_btClose := 2;
        g_DataEngine.Data := g_Data;
        g_DataEngine.Initialize;
      end else begin
        g_btClose := 1;
        ShowMessage('程序已经运行！');
        //SendMessage(FormData.FormHwnd, SC_RESTORE, 0, 0);
        //Application.Terminate;
      end;
    end; }
  end;
finalization
  {if RemoveMe then begin
    MappingHandle := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, PChar(MappingName));
    if MappingHandle <> 0 then begin
      g_Data := MapViewOfFile(MappingHandle,
        FILE_MAP_ALL_ACCESS,
        0,
        0,
        SizeOf(TFormData));

      g_Data^.RunCounter := -1 + g_Data^.RunCounter;
    end else RaiseLastOSError;
  end;
  }
  if g_Data <> nil then begin
    UnmapViewOfFile(g_Data);
    CloseHandle(MappingHandle);
  end;
  g_Data := nil;
  g_DataEngine.Free;
  {begin
    if g_Data <> nil then begin
      UnmapViewOfFile(g_Data);
      CloseHandle(FHandle);
    end;
    g_Data := nil;
    g_DataEngine.Free;
  end; }

end.

