unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, RzBmpBtn, StdCtrls, RzLstBox, RzButton, RzRadChk,
  OleCtrls, SHDocVw, ComCtrls, ShlObj, ComObj, ActiveX, Grobal2, JSocket,
  Registry, winsock, WinInet, ShellApi, IniFiles, GameShare, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, {ZLib,} tlHelp32, RzForms, dlltools;

type
  TSearchThread = class(TThread)
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
  end;

  TfrmMain = class(TForm)
    RzBmpButtonHomePage: TRzBmpButton;
    RzBmpButtonEditGameList: TRzBmpButton;
    RzBmpButtonNewAccount: TRzBmpButton;
    RzBmpButtonGetBakPassWord: TRzBmpButton;
    RzBmpButtonChgPassWord: TRzBmpButton;
    RzBmpButtonAutoLogin: TRzBmpButton;
    RzBmpButtonFullScreenStart: TRzBmpButton;
    RzBmpButtonClose: TRzBmpButton;
    Timer: TTimer;
    ClientSocket: TClientSocket;
    TimerStart: TTimer;
    CloseTimer: TTimer;
    RzBmpButtonMin: TRzBmpButton;
    TreeView: TTreeView;
    RzBmpButtonStart: TRzBmpButton;
    RzBmpButtonExitGame: TRzBmpButton;
    RzBmpButtonUpgrade: TRzBmpButton;
    Image: TRzFormShape;
    LabelStatus: TLabel;
    TimerReakSkin: TTimer;
    ComboBox: TComboBox;
    SpeedHackTimer: TTimer;
    procedure TimerTimer(Sender: TObject);
    procedure ClientSocketConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketConnecting(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormCreate(Sender: TObject);
    procedure RzBmpButtonCloseClick(Sender: TObject);
    procedure RzBmpButtonHomePageClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure RzBmpButtonFullScreenStartClick(Sender: TObject);
    procedure RzBmpButtonEditGameListClick(Sender: TObject);
    procedure TimerStartTimer(Sender: TObject);
    procedure RzBmpButtonNewAccountClick(Sender: TObject);
    procedure RzBmpButtonGetBakPassWordClick(Sender: TObject);
    procedure RzBmpButtonChgPassWordClick(Sender: TObject);
    procedure RzBmpButtonAutoLoginClick(Sender: TObject);
    procedure CloseTimerTimer(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzBmpButtonMinClick(Sender: TObject);
    procedure TreeViewClick(Sender: TObject);
    procedure TimerReakSkinTimer(Sender: TObject);
    procedure SpeedHackTimerTimer(Sender: TObject);
  private
    SelfProcessEntry: TProcessEntry32;
    FindModules: TStringList;
    SelfModules: TStringList;
    DLLNameList: TStringList;
    FilterModules: TStringList;
    procedure CreateUlr(sCreateUlrName: string);
    procedure DecodeMessagePacket(datablock: string);
    procedure ChgButtonStatus(btStatus: Byte);
    procedure ReleaseClient(sDirectory: string; GameZone: TGameZone);
//    function RunApp(AppName: string; I: Integer): Integer;
    procedure OnProgramException(Sender: TObject; E: Exception);
    function GetProcesses: Boolean;
    function GetModules(ProcessID: DWORD): Boolean;
    procedure ReadSkin;
    function SearchMirClient(Path: string): Boolean;

    procedure LoadUserConfig;
    procedure SaveUserConfig;
    procedure ConnectServer;

    procedure GetSelfProcesses(ModuleList: TStringList);
    function GetSelfModules(ProcessID: DWORD; ModuleList: TStringList): Boolean;
    function AddDLLName(const sName: string; ordinal: Integer;
      address: Pointer): Boolean;
  public
    { Public declarations }
    procedure SendGetRandomCode;
    procedure SendUpdateAccount(ue: TUserEntry; ua: TUserEntryAdd; nRandomCode: Integer);
    procedure SendGetBackPassword(sAccount, sQuest1, sAnswer1,
      sQuest2, sAnswer2, sBirthDay: string);
    procedure SendChgPw(sAccount, sPasswd, sNewPasswd: string);
    procedure SendCSocket(sendstr: string);
    procedure LoadListToBox();
    procedure ProcessMessage(var Msg: TMsg; var Handled: Boolean);
    procedure MyMessage(var MsgData: TWmCopyData); message WM_COPYDATA;
  end;

var
  frmMain: TfrmMain;
  MirClient: TMemoryStream;
  WebBrowser: TWebBrowser;
function CheckLegendPath(Path: string): Boolean;
function CheckMirPath(Path: string): Boolean;
function CheckFullPath(Path: string): Boolean;
procedure LoopFiles(Path, Mask: string; SubDir: TStrings);
function GetDrives: string;
function RunApp(AppName: string): Integer;
function SearchPath: Boolean;
implementation
uses EncryptUnit, HUtil32, LNewAccount, LChgPassword, LGetBackPassword {, SecrchInfoMain},
  LEditGame, LUpgrade, { CMain, NPCDialog, NPCMain,} CheckPrevious, ZLibEx;
const
  R_MyRootKey = HKEY_LOCAL_MACHINE; //注册表根键
  R_MySubKey = '\SOFTWARE\cqfir\Legend of mir'; //注册表子键
  R_SndaSubKey = '\SOFTWARE\snda\Legend of mir';
  R_Key = 'Path';
{$R *.dfm}

procedure TSearchThread.Execute;
var
  DriverList: string;
  I, Len: Integer;
begin
  DriverList := GetDrives; //得到可写的磁盘列表 //遍历每个磁盘驱动器
  Len := Length(DriverList);
  for I := 1 to Len do begin
    g_SearchList.Add(DriverList[I] + ':\');
  end;
  while (not Terminated) and (not SearchPath) and (not g_boClose) do begin

  end;
end;

constructor TSearchThread.Create(CreateSuspended: Boolean);
begin
  inherited;

end;

destructor TSearchThread.Destroy;
begin
  inherited;
end;

function ReadRegKey(const iMode: Integer; const sPath,
  sKeyName: string; var sResult: string): Boolean;
var
  rRegObject: TRegistry;
begin
  rRegObject := TRegistry.Create;
  Result := False;
  try
    with rRegObject do begin
      RootKey := R_MyRootKey;
      if OpenKey(sPath, True) then begin
        case iMode of
          1: sResult := Trim(ReadString(sKeyName));
          2: sResult := IntToStr(ReadInteger(sKeyName));
          //3: sResult := ReadBinaryData(sKeyName, Buffer, BufSize);
        end;
        if sResult = '' then Result := False else Result := True;
      end
      else
        Result := False;
      CloseKey;
    end;
  finally
    rRegObject.Free;
  end;
end;
//_____________________________________________________________________//

function WriteRegKey(const iMode: Integer; const sPath, sKeyName,
  sKeyValue: string): Boolean;
var
  rRegObject: TRegistry;
  bData: Byte;
begin
  rRegObject := TRegistry.Create;
  try
    with rRegObject do begin
      RootKey := R_MyRootKey;
      if OpenKey(sPath, True) then begin
        case iMode of
          1: WriteString(sKeyName, sKeyValue);
          2: WriteInteger(sKeyName, StrToInt(sKeyValue));
          3: WriteBinaryData(sKeyName, bData, 1);
        end;
        Result := True;
      end
      else
        Result := False;
      CloseKey;
    end;
  finally
    rRegObject.Free;
  end;
end;
//_____________________________________________________________________//

function SelectDirCB(Wnd: Hwnd; uMsg: UINT; LPARAM, lpData: LPARAM): Integer stdcall;
begin
  if (uMsg = BFFM_INITIALIZED) and (lpData <> 0) then
    SendMessage(Wnd, BFFM_SETSELECTION, Integer(True), lpData);
  Result := 0;
end;

function SelectDirectory(const Caption: string; const Root: WideString;
  var Directory: string; Owner: THandle): Boolean;
var
  WindowList: Pointer;
  BrowseInfo: TBrowseInfo;
  Buffer: PChar;
  RootItemIDList, ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
  IDesktopFolder: IShellFolder;
  Eaten, Flags: LongWord;
begin
  Result := False;
  if not DirectoryExists(Directory) then
    Directory := '';
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then begin
    Buffer := ShellMalloc.Alloc(MAX_PATH);
    try
      RootItemIDList := nil;
      if Root <> '' then begin
        SHGetDesktopFolder(IDesktopFolder);
        IDesktopFolder.ParseDisplayName(Application.Handle, nil,
          POleStr(Root), Eaten, RootItemIDList, Flags);
      end;
      with BrowseInfo do begin
        hwndOwner := Owner;
        pidlRoot := RootItemIDList;
        pszDisplayName := Buffer;
        lpszTitle := PChar(Caption);
        ulFlags := BIF_RETURNONLYFSDIRS;
        if Directory <> '' then begin
          lpfn := SelectDirCB;
          LPARAM := Integer(PChar(Directory));
        end;
      end;
      WindowList := DisableTaskWindows(0);
      try
        ItemIDList := ShBrowseForFolder(BrowseInfo);
      finally
        EnableTaskWindows(WindowList);
      end;
      Result := ItemIDList <> nil;
      if Result then begin
        ShGetPathFromIDList(ItemIDList, Buffer);
        ShellMalloc.Free(ItemIDList);
        Directory := Buffer;
      end;
    finally
      ShellMalloc.Free(Buffer);
    end;
  end;
end;
//_____________________________________________________________________//

function AddString(S: string): string;
begin
  Result := S;
  if S[Length(S)] <> '\' then Result := S + '\';
end;

//获取当前的硬盘所有的盘符
{

Lbl_DriveType:Tlabel;
　　DriveType:WORD; //定义驱动器类型变量
　　DriveType:=GetDriveType(RootPathName); //获得RootPathName所对应的磁盘驱动器信息
　　case DriveType of
　　DRIVE_REMOVABLE:Lbl_DriveType.Caption:= '软盘驱动器';
　　DRIVE_FIXED : Lbl_DriveType.Caption:= '硬盘驱动器';
　　DRIVE_REMOTE: Lbl_DriveType.Caption:= '网络驱动器';
　　DRIVE_CDROM: Lbl_DriveType.Caption:= '光盘驱动器';
　　DRIVE_RAMDISK: Lbl_DriveType.Caption:= '内存虚拟盘';
　　end; //将该磁盘信息显示在Lbl_DriveType中

}

function GetDrives: string;
var
  DiskType: Word;
  D: Char;
  Str: string;
  I: Integer;
begin
  for I := 0 to 25 do //遍历26个字母
  begin
    D := Chr(I + 65);
    Str := D + ':';
    DiskType := GetDriveType(PChar(Str));
    //得到本地磁盘和网络盘
    if (DiskType = DRIVE_FIXED) {or (DiskType = DRIVE_REMOTE)} then
      Result := Result + D;
  end;
end;

{ 遍历目录 }
{
procedure LoopFiles(Path, Mask: string);
var
  I, Count: Integer;
  Fn, Ext: string;
  SubDir: TStrings;
  SearchRec: TSearchRec;
  Msg: TMsg;
  function IsValidDir(SearchRec: TSearchRec): Integer;
  begin
    if (SearchRec.Attr <> 16) and (SearchRec.Name <> '.') and
      (SearchRec.Name <> '..') then
      Result := 0 //不是目录
    else if (SearchRec.Attr = 16) and (SearchRec.Name <> '.') and
      (SearchRec.Name <> '..') then
      Result := 1 //不是根目录
    else Result := 2; //是根目录
  end;
begin
  SubDir := TStringList.Create;
  if (FindFirst(Path + '*.*', faDirectory, SearchRec) = 0) then
  begin
    repeat
      if g_boClose then break;
      Application.ProcessMessages;
      if IsValidDir(SearchRec) = 1 then begin
        if not CheckMirPath(Path + SearchRec.Name + '\') then begin
          SubDir.Add(SearchRec.Name);
          FrmMain.LabelStatus.Caption := Path + SearchRec.Name;
        end else begin
          g_sMirPath := Path + SearchRec.Name + '\';
          WriteRegKey(1, R_MySubKey, R_Key, g_sMirPath);
          Break;
        end;
      end;
      Sleep(1);

    until (FindNext(SearchRec) <> 0);
  end;
  FindClose(SearchRec);

  if not CheckMirPath(g_sMirPath) then begin
    Count := SubDir.Count - 1;
    for I := 0 to Count do begin
      if g_boClose then break;
      LoopFiles(Path + SubDir.Strings[I] + '\', Mask);
    end;
  end;

  FreeAndNil(SubDir);
end;

}

//缩短显示不下的长路径名

function FormatPath(APath: string; Width: Integer): string;
var
  SLen: Integer;
  i, j: Integer;
  TString: string;
begin
  SLen := Length(APath);
  if (SLen <= Width) or (Width <= 6) then
  begin
    Result := APath;
    Exit
  end
  else
  begin
    i := SLen;
    TString := APath;
    for j := 1 to 2 do
    begin
      while (TString[i] <> '\') and (SLen - i < Width - 8) do
        i := i - 1;
      i := i - 1;
    end;
    for j := SLen - i - 1 downto 0 do
      TString[Width - j] := TString[SLen - j];
    for j := SLen - i to SLen - i + 2 do
      TString[Width - j] := '.';
    Delete(TString, Width + 1, 255);
    Result := TString;
  end;
end;

procedure LoopFiles(Path, Mask: string; SubDir: TStrings);
var
  I, Count: Integer;
  Fn, Ext, FullPath: string;
  SearchRec: TSearchRec;
  Msg: TMsg;
  function IsValidDir(SearchRec: TSearchRec): Integer;
  begin
    if (SearchRec.Attr <> 16) and (SearchRec.Name <> '.') and
      (SearchRec.Name <> '..') then
      Result := 0 //不是目录
    else if (SearchRec.Attr = 16) and (SearchRec.Name <> '.') and
      (SearchRec.Name <> '..') then
      Result := 1 //不是根目录
    else Result := 2; //是根目录
  end;
begin
  if (FindFirst(Path + '*.*', faDirectory, SearchRec) = 0) then begin
    repeat
      if g_boClose then break;
      Application.ProcessMessages;
      if IsValidDir(SearchRec) = 1 then begin
        FullPath := Path + SearchRec.Name + '\';
        if not CheckFullPath(FullPath) then begin
          //if CheckLegendPath(FullPath) then
          if CheckLegendPath(FullPath) then
            g_LegendPathList.Add(FullPath);

          SubDir.Add(FullPath);

          FrmMain.LabelStatus.Caption := FormatPath(FullPath, 40);
          {if Length(FullPath) > 30 then begin
            FrmMain.LabelStatus.Caption := ExtractShortPathName(FullPath);
          end else begin
            FrmMain.LabelStatus.Caption := FullPath;
          end; }
        end else begin
          g_sMirPath := FullPath;
          WriteRegKey(1, R_MySubKey, R_Key, g_sMirPath);
          Break;
        end;
      end;
      Sleep(1);

    until (FindNext(SearchRec) <> 0);
  end;
  FindClose(SearchRec);
end;

function CheckLegendPath(Path: string): Boolean;
begin
  Result := (DirectoryExists(Path + 'Data')) and
    (DirectoryExists(Path + 'Map')) and
    (DirectoryExists(Path + 'Wav'));
end;

function CheckFullPath(Path: string): Boolean;
begin
  Result := (DirectoryExists(Path + 'Data')) and
    (DirectoryExists(Path + 'Map')) and
    (DirectoryExists(Path + 'Wav')) and
    (not FileExists(Path + 'Data\ChrSel_16.wil')) and
    (not FileExists(Path + 'Data\Prguse_16.wil')) and
    (not FileExists(Path + 'Data\Prguse2_16.wil')) and
    (not FileExists(Path + 'Data\Prguse3_16.wil')) and

  (FileExists(Path + 'Data\Prguse.wil') and
    FileExists(Path + 'Data\Prguse2.wil') and
    FileExists(Path + 'Data\Prguse3.wil'))
    or
    (FileExists(Path + 'Data\Prguse.wzl') and
    FileExists(Path + 'Data\Prguse2.wzl') and
    FileExists(Path + 'Data\Prguse3.wzl'));
end;

function CheckMirPath(Path: string): Boolean;
var
  sKeyValue: string;
begin
  if CheckLegendPath(Path) then begin
    g_sMirPath := Path;
    Result := True;
  end else begin
    if ReadRegKey(1, R_MySubKey, R_Key, sKeyValue) then begin
      if CheckLegendPath(sKeyValue) then begin
        g_sMirPath := sKeyValue;
        Result := True;
        Exit;
      end;
    end;

    if ReadRegKey(1, R_SndaSubKey, R_Key, sKeyValue) then begin
      if CheckLegendPath(sKeyValue) then begin
        g_sMirPath := sKeyValue;
        WriteRegKey(1, R_MySubKey, R_Key, g_sMirPath);
        Result := True;
        Exit;
      end;
    end;
    Result := False;
  end;
end;

function SearchPath: Boolean;
var
  I: Integer;
  SubDir: TStrings;
begin
  Result := False;
  SubDir := TStringList.Create;
  for I := 0 to g_SearchList.Count - 1 do begin
    LoopFiles(g_SearchList[I], '*.*', SubDir);
    if g_boClose or CheckFullPath(g_sMirPath) then begin
      break;
    end;
  end;
  if not CheckFullPath(g_sMirPath) then begin
    g_SearchList.Clear;
    g_SearchList.AddStrings(SubDir);
  end else Result := True;
  FreeAndNil(SubDir);
end;

function TFrmMain.SearchMirClient(Path: string): Boolean;
var
  DriverList: string;
  sKeyValue: string;
  I, Len: Integer;
begin
  Result := False;
  if not CheckLegendPath(Path) then begin
    if ReadRegKey(1, R_MySubKey, R_Key, sKeyValue) then begin
      if CheckLegendPath(sKeyValue) then begin
        g_sMirPath := sKeyValue;
        Result := True;
        Exit;
      end;
    end;

    if ReadRegKey(1, R_SndaSubKey, R_Key, sKeyValue) then begin
      if CheckLegendPath(sKeyValue) then begin
        g_sMirPath := sKeyValue;
        WriteRegKey(1, R_MySubKey, R_Key, g_sMirPath);
        Result := True;
        Exit;
      end;
    end;

    DriverList := GetDrives; //得到可写的磁盘列表 //遍历每个磁盘驱动器
    Len := Length(DriverList);
    for I := 1 to Len do begin
      g_SearchList.Add(DriverList[I] + ':\');
    end;

    while (not SearchPath) and (not g_boClose) do begin
    end;

    if (not CheckMirPath(g_sMirPath)) and (g_LegendPathList.Count > 0) then begin
      g_sMirPath := g_LegendPathList.Strings[0];
    end;

    Result := CheckLegendPath(g_sMirPath);

    {DriverList := GetDrives; //得到可写的磁盘列表
    Len := Length(DriverList);
    for I := Len downto 1 do begin //遍历每个磁盘驱动器
      try
        LoopFiles(DriverList[I] + ':\', '*.*');
        if CheckMirPath(g_sMirPath) then begin
          Result := True;
          Break;
        end;
      except

      end;
      if g_boClose then break;
    end;
    }
  end else begin
    g_sMirPath := Path;
    if not ReadRegKey(1, R_MySubKey, R_Key, sKeyValue) then begin
      WriteRegKey(1, R_MySubKey, R_Key, g_sMirPath);
    end else begin
      if not CheckLegendPath(sKeyValue) then begin
        WriteRegKey(1, R_MySubKey, R_Key, g_sMirPath);
      end;
    end;
    Result := True;
  end;
end;

procedure TfrmMain.GetSelfProcesses(ModuleList: TStringList);
  function CheckModuleOwnerProcessID(ProcessID: DWORD): Boolean;
  var
    hSnap: THandle;
    ModuleEntry: TModuleEntry32;
    Proceed: Boolean;
  begin
    Result := False;
    hSnap := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, ProcessID);
    if hSnap <> -1 then
    begin
      ModuleEntry.dwSize := SizeOf(TModuleEntry32);
      Proceed := Module32First(hSnap, ModuleEntry);
      while Proceed do begin
        with ModuleEntry do
          if th32ProcessID <> ProcessID then begin
            Result := True;
            Break;
          end;
        Proceed := Module32Next(hSnap, ModuleEntry);
      end;
      CloseHandle(hSnap);
    end;
  end;

  function CheckThreadOwnerProcessID(ProcessID: DWORD): Boolean;
  var
    hSnap: THandle;
    ThreadEntry: TThreadEntry32;
    Proceed: Boolean;
  begin
    Result := False;
    hSnap := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, ProcessID);
    if hSnap <> -1 then
    begin
      ThreadEntry.dwSize := SizeOf(TThreadEntry32);
      Proceed := Thread32First(hSnap, ThreadEntry);
      while Proceed do begin
        with ThreadEntry do
          if th32OwnerProcessID <> ProcessID then begin
            Result := True;
            Break;
          end;
        Proceed := Thread32Next(hSnap, ThreadEntry);
      end;
      CloseHandle(hSnap);
    end;
  end;

var
  I: Integer;
  hSnap: THandle;
  ProcessEntry: TProcessEntry32;
  Proceed: Boolean;
  sExeName: string;
begin
  sExeName := Application.ExeName;
  //showmessage(sExeName);
  hSnap := CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0); //创建系统快照
  if hSnap <> -1 then
  begin
    ProcessEntry.dwSize := SizeOf(TProcessEntry32); //先初始化 FProcessEntry32 的大小
    Proceed := Process32First(hSnap, ProcessEntry);
    while Proceed do begin
      ModuleList.Clear;
      with ProcessEntry do begin
        //if CompareText(sExeName, StrPas(szEXEFile)) = 0 then begin
        //SelfProcessEntry := ProcessEntry;
        GetSelfModules(Th32ProcessID, ModuleList);
      end;
          //showmessage('ok');
          //Break;
       // end;
      if ModuleList.Count > 0 then begin
        for I := 0 to ModuleList.Count - 1 do begin
          if CompareText(sExeName, ModuleList.Strings[I]) = 0 then begin
            SelfProcessEntry := ProcessEntry;
            break;
          end;
        end;
      end;
      Proceed := Process32Next(hSnap, ProcessEntry);
    end;
    CloseHandle(hSnap);
  end;
end;

function TfrmMain.GetSelfModules(ProcessID: DWORD; ModuleList: TStringList): Boolean;
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
    while Proceed do begin
      ModuleList.Add(StrPas(ModuleEntry.szExePath));
      Proceed := Module32Next(hSnap, ModuleEntry);
    end;
    CloseHandle(hSnap);
  end;
end;

procedure TfrmMain.ProcessMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if Msg.message = WM_SENDPROCMSG then begin
    //    ShowMessage('asfd');
    Handled := True;
  end;
end;

procedure TfrmMain.MyMessage(var MsgData: TWmCopyData);
var
  I, nHandle: Integer;
  sData: string;
  wIdent, wRecog: Word;
begin
  if not g_boClose then begin
    wIdent := HiWord(MsgData.From);
    wRecog := LoWord(MsgData.From);
    sData := StrPas(MsgData.CopyDataStruct^.lpData);
    case wIdent of
      CM_Initialize: begin
          nHandle := Str_ToInt(sData, 0);
          for I := 0 to g_ClientHandleList.Count - 1 do begin
            if nHandle = Integer(g_ClientHandleList.Items[I]) then begin
              Exit;
            end;
          end;
          g_ClientHandleList.Add(Pointer(nHandle));
        end;
      CM_Finalize: begin
          nHandle := Str_ToInt(sData, 0);
          for I := 0 to g_ClientHandleList.Count - 1 do begin
            if nHandle = Integer(g_ClientHandleList.Items[I]) then begin
              g_ClientHandleList.Delete(I);
              Break;
            end;
          end;
        end;
      CM_QUIT: begin
          nHandle := Str_ToInt(sData, 0);
          for I := 0 to g_ClientHandleList.Count - 1 do begin
            if nHandle = Integer(g_ClientHandleList.Items[I]) then begin
              g_ClientHandleList.Delete(I);
              Break;
            end;
          end;
          if IsIconic(Application.Handle) then
            ShowWindow(Application.Handle, SW_RESTORE);
          SetForegroundWindow(Application.Handle);
        end;
    end;
  end;
end;

procedure TfrmMain.ConnectServer;
var
  sServerAddr: string;
  sServerPort: string;
begin
  if {(not ClientSocket.Socket.Connected) and }(g_SelGameZone <> nil) then begin
    if g_SelGameZone.Encrypt then begin
      sServerAddr := DecryptString256(g_SelGameZone.GameHost, GAME_PASSWORD);
      sServerPort := DecryptString256(g_SelGameZone.GameIPPort, GAME_PASSWORD);
    end else begin
      sServerAddr := g_SelGameZone.GameHost;
      sServerPort := g_SelGameZone.GameIPPort;
    end;
    if (not ClientSocket.Socket.Connected) or (ClientSocket.Socket.RemoteAddress <> g_SelGameZone.GameIPaddr) or (ClientSocket.Port <> Str_ToInt(sServerPort, 7000)) then begin
      ClientSocket.Active := False;
      if IsIpAddr(sServerAddr) then begin
        ClientSocket.Address := sServerAddr;
      end else begin
        ClientSocket.Host := sServerAddr;
      end;
      ClientSocket.Port := Str_ToInt(sServerPort, 7000);

      ClientSocket.Active := True;
    end;
  end;
end;

procedure TfrmMain.CreateUlr(sCreateUlrName: string); //创建快捷方式
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
    Reg.Free;
  end;
end;

procedure TfrmMain.SendCSocket(sendstr: string);
var
  sSendText: string;
begin
  if ClientSocket.Socket.Connected then begin
    sSendText := '#' + IntToStr(btCode) + sendstr + '!';
    ClientSocket.Socket.SendText('#' + IntToStr(btCode) + sendstr + '!');
    Inc(btCode);
    if btCode >= 10 then btCode := 1;
  end;
end;

procedure TfrmMain.SendChgPw(sAccount, sPasswd, sNewPasswd: string); //发送修改密码
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_CHANGEPASSWORD, 0, 0, 0, 0);
  SendCSocket(EncodeMessage(Msg) + EncodeString(sAccount + #9 + sPasswd + #9 + sNewPasswd));
end;

procedure TfrmMain.SendGetBackPassword(sAccount, sQuest1, sAnswer1,
  sQuest2, sAnswer2, sBirthDay: string); //发送找回密码
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_GETBACKPASSWORD, 0, 0, 0, 0);
  SendCSocket(EncodeMessage(Msg) + EncodeString(sAccount + #9 + sQuest1 + #9 + sAnswer1 + #9 + sQuest2 + #9 + sAnswer2 + #9 + sBirthDay));
end;

procedure TfrmMain.SendGetRandomCode;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_RANDOMCODE, 0, 0, 0, 0);
  SendCSocket(EncodeMessage(Msg));
end;

procedure TfrmMain.SendUpdateAccount(ue: TUserEntry; ua: TUserEntryAdd; nRandomCode: Integer); //发送新建账号
var
  Msg: TDefaultMessage;
begin
  sMakeNewAccount := ue.sAccount;
  Msg := MakeDefaultMsg(CM_ADDNEWUSER, nRandomCode, 0, 0, 0);
  SendCSocket(EncodeMessage(Msg) + EncodeBuffer(@ue, SizeOf(TUserEntry)) + EncodeBuffer(@ua, SizeOf(TUserEntryAdd))); //329
end;

procedure TfrmMain.TimerTimer(Sender: TObject);
var
  Str, data: string;
  len, I, n, mcnt: Integer;
begin
  if boBusy then Exit;
  boBusy := True;
  try
    sBufferStr := sBufferStr + sSocStr;
    sSocStr := '';
    if sBufferStr <> '' then begin
      mcnt := 0;
      while Length(sBufferStr) >= 2 do begin
        if Pos('!', sBufferStr) <= 0 then Break;
        sBufferStr := ArrestStringEx(sBufferStr, '#', '!', data);
        if data <> '' then begin
          DecodeMessagePacket(data);
        end else
          if Pos('!', sBufferStr) = 0 then
          Break;
      end;
    end;
    {if frmNewAccount.Visible then begin
      frmNewAccount.LabelRandomCode.Caption := g_sRandomCode;
    end;}
  finally
    boBusy := False;
  end;
end;

procedure TfrmMain.TreeViewClick(Sender: TObject);
var
  TreeNode: TTreeNode;
  GameZone: TGameZone;
  sServerAddr: string;
  sServerPort: string;
begin
  g_SelGameZone := nil;
  TreeNode := TreeView.Selected;
  if (TreeNode = nil) or (TreeNode.Parent = nil) then begin
    //Showmessage('TreeNode.Parent = nil');
    Exit;
  end;
  g_SelGameZone := TGameZone(TreeNode.Data);
  try
    if not g_SelGameZone.Connected then begin
      ClientSocket.Active := False;
      ClientSocket.Host := '';
      ClientSocket.Address := '';

      if g_SelGameZone.Encrypt then begin
        sServerAddr := DecryptString256(g_SelGameZone.GameHost, GAME_PASSWORD);
        sServerPort := DecryptString256(g_SelGameZone.GameIPPort, GAME_PASSWORD);
      end else begin
        sServerAddr := g_SelGameZone.GameHost;
        sServerPort := g_SelGameZone.GameIPPort;
      end;

      if IsIpAddr(sServerAddr) then begin
        ClientSocket.Address := sServerAddr;
      end else begin
        ClientSocket.Host := sServerAddr;
      end;
      ClientSocket.Port := Str_ToInt(sServerPort, 7000);

      ClientSocket.Active := True;
    end else begin
      g_boClientSocketConnect := True;
      LabelStatus.Font.Color := g_GameLoginConfig.LabelConnectColor;
      LabelStatus.Caption := sClientConnect;
      RzBmpButtonFullScreenStart.Enabled := True;
      RzBmpButtonStart.Enabled := True;
      RzBmpButtonAutoLogin.Enabled := True;
      RzBmpButtonNewAccount.Enabled := True;
      RzBmpButtonGetBakPassWord.Enabled := True;
      RzBmpButtonChgPassWord.Enabled := True;
    end;
    //WebBrowser.Height := g_nWebHeiht;
    //WebBrowser.Width := g_WebBrowser.Width;
    WebBrowser.Navigate(g_SelGameZone.NoticeUrl);
    //WebBrowser.Width := g_WebBrowser.Width;
    {Showmessage(IntToStr(WebBrowser.Width));
    Showmessage(IntToStr(WebBrowser.Height));}
  except

  end;
end;

procedure TfrmMain.DecodeMessagePacket(datablock: string);
var
  head, body, body2, tagstr, data, rdstr, Str: string;
  Msg: TDefaultMessage;
  smsg: TShortMessage;
  mbw: TMessageBodyW;
  desc: TCharDesc;
  wl: TMessageBodyWL;
  featureEx: word;
  L, I, j, n, BLKSize, param, sound, cltime, svtime: Integer;
  tempb: Boolean;
begin
  if datablock[1] = '+' then Exit;
  if Length(datablock) < DEFBLOCKSIZE then Exit;
  head := Copy(datablock, 1, DEFBLOCKSIZE);
  body := Copy(datablock, DEFBLOCKSIZE + 1, Length(datablock) - DEFBLOCKSIZE);
  Msg := DecodeMessage(head);
  case Msg.Ident of
    SM_NEWID_SUCCESS: begin
        Application.MessageBox('您的帐号创建成功。' + #13 +
          '请妥善保管您的帐号和密码，' + #13 + '并且不要因任何原因把帐号和密码告诉任何其他人。' + #13 +
          '如果忘记了密码,你可以通过我们的主页重新找回。', '提示信息', MB_OK);
        frmNewAccount.Close;
      end;
    SM_NEWID_FAIL: begin
        case Msg.Recog of
          0: begin
              Application.MessageBox(PChar('帐号 "' + sMakeNewAccount + '" 已被其他的玩家使用了。' + #13 +
                '请选择其它帐号名注册。'), '提示信息', MB_OK);
            end;
          1: begin
              Application.MessageBox('验证码输入错误，请重新输入！！！', '提示信息', MB_OK);
              //frmNewAccount.EditRandomCode.SetFocus;
            end;
          -2: Application.MessageBox('此帐号名被禁止使用！', '提示信息', MB_OK);
        else Application.MessageBox(PChar('帐号创建失败，请确认帐号是否包括空格、及非法字符！Code: ' + IntToStr(Msg.Recog)), '提示信息', MB_OK);
        end;
        frmNewAccount.ButtonOK.Enabled := True;
        Exit;
      end;
    SM_RANDOMCODE: begin
        g_sRandomCode := DecryptString256(DecodeString(body), IntToStr(Msg.Recog));
        {if Decode(DecodeString(body), g_sRandomCode) then begin
          //frmNewAccount.LabelRandomCode.Caption := g_sRandomCode;
        end else g_sRandomCode := '0'; }
      end;
    ////////////////////////////////////////////////////////////////////////////////
    SM_CHGPASSWD_SUCCESS: begin
        Application.MessageBox('密码修改成功。', '提示信息', MB_OK);
        {frmChangePassword.ChgEditAccount.Text:='';
        frmChangePassword.ChgEditPassword.Text:='';
        frmChangePassword.ChgEditConfirm.Text:='';
        frmChangePassword.ChgEditNewPassword.Text:='';}
        frmChangePassword.ButtonOK.Enabled := False;
        //frmNewAccount.Close;
        Exit;
      end;
    SM_CHGPASSWD_FAIL: begin
        case Msg.Recog of
          0: Application.MessageBox('输入的帐号不存在！！！', '提示信息', MB_OK);
          -1: Application.MessageBox('输入的原始密码不正确！', '提示信息', MB_OK);
          -2: Application.MessageBox('此帐号被锁定！', '提示信息', MB_OK);
        else Application.MessageBox('输入的新密码长度小于四位！', '提示信息', MB_OK);
        end;
        frmChangePassword.ButtonOK.Enabled := True;
        Exit;
      end;
    SM_GETBACKPASSWD_SUCCESS: begin
        frmGetBackPassword.EditPassword.Text := DecodeString(body);
        Application.MessageBox(PChar('密码找回成功。'), '提示信息', MB_OK);
        Exit;
      end;
    SM_GETBACKPASSWD_FAIL: begin
        case Msg.Recog of
          0: Application.MessageBox('输入的帐号不存在！！！', '提示信息', MB_OK + MB_ICONERROR);
          -1: Application.MessageBox('问题答案不正确！！！', '提示信息', MB_OK + MB_ICONERROR);
          -2: Application.MessageBox(PChar('此帐号被锁定！！！' + #13 + '请稍候三分钟再重新找回。'), '提示信息', MB_OK + MB_ICONERROR);
          -3: Application.MessageBox('答案输入不正确！！！', '提示信息', MB_OK + MB_ICONERROR);
        else Application.MessageBox('未知错误！', '提示信息', MB_OK + MB_ICONERROR);
        end;
        frmGetBackPassword.ButtonOK.Enabled := True;
        Exit;
      end;
  end;
end;

procedure TfrmMain.ClientSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if g_SelGameZone <> nil then begin
    g_SelGameZone.GameIPaddr := Socket.RemoteAddress;
    g_SelGameZone.Connected := True;
  end;
  //ChgButtonStatus(0);
  g_boClientSocketConnect := True;
  LabelStatus.Font.Color := g_GameLoginConfig.LabelConnectColor;
  //LabelStatus.Font.Color := clLime;
  LabelStatus.Caption := sClientConnect;
  //frmGetBackPassword.LabelStatus.Caption := sClientConnect;
  //frmNewAccount.LabelStatus.Caption := sClientConnect;
  //frmChangePassword.LabelStatus.Caption := sClientConnect;

  RzBmpButtonFullScreenStart.Enabled := True;
  RzBmpButtonStart.Enabled := True;
  RzBmpButtonAutoLogin.Enabled := True;
  RzBmpButtonNewAccount.Enabled := True;
  RzBmpButtonGetBakPassWord.Enabled := True;
  RzBmpButtonChgPassWord.Enabled := True;
end;

procedure TfrmMain.ClientSocketConnecting(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  //ChgButtonStatus(1);
  g_boClientSocketConnect := False;
  LabelStatus.Font.Color := g_GameLoginConfig.LabelConnectingColor; //clFuchsia;
  LabelStatus.Caption := sClientConnecting;
  frmGetBackPassword.LabelStatus.Caption := sClientConnecting;
  //frmNewAccount.LabelStatus.Caption := sClientConnecting;
  //frmChangePassword.LabelStatus.Caption := sClientConnecting;

  RzBmpButtonFullScreenStart.Enabled := False;
  RzBmpButtonStart.Enabled := False;
  RzBmpButtonAutoLogin.Enabled := False;
  RzBmpButtonNewAccount.Enabled := False;
  RzBmpButtonGetBakPassWord.Enabled := False;
  RzBmpButtonChgPassWord.Enabled := False;
end;

procedure TfrmMain.ClientSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  //ChgButtonStatus(2);
  g_boClientSocketConnect := False;
  if not g_SelGameZone.Connected then begin
    LabelStatus.Font.Color := g_GameLoginConfig.LabelDisconnectColor; //clYellow;
    LabelStatus.Caption := sClientDisconnect;

  //frmGetBackPassword.LabelStatus.Caption := sClientDisconnect;
  //frmNewAccount.LabelStatus.Caption := sClientDisconnect;
  //frmChangePassword.LabelStatus.Caption := sClientDisconnect;

    RzBmpButtonFullScreenStart.Enabled := False;
    RzBmpButtonStart.Enabled := False;
    RzBmpButtonAutoLogin.Enabled := False;
    RzBmpButtonNewAccount.Enabled := False;
    RzBmpButtonGetBakPassWord.Enabled := False;
    RzBmpButtonChgPassWord.Enabled := False;
  end;
end;

procedure TfrmMain.ClientSocketError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  //ChgButtonStatus(2);
  ErrorCode := 0;
  Socket.Close;
end;

procedure TfrmMain.ClientSocketRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  n: Integer;
  data, data2: string;
begin
  data := Socket.ReceiveText;
  n := Pos('*', data);
  if n > 0 then begin
    data2 := Copy(data, 1, n - 1);
    data := data2 + Copy(data, n + 1, Length(data));
    ClientSocket.Socket.SendText('*');
  end;
  sSocStr := sSocStr + data;
end;

procedure TfrmMain.OnProgramException(Sender: TObject; E: Exception);
begin
  DebugOutStr(E.Message);
end;

procedure TFrmMain.LoadUserConfig;
var
  Conf: TIniFile;
begin
  Conf := TIniFile.Create(g_sSelfFilePath + 'User.ini');
  //RzCheckBoxWindowMode.Checked := Conf.ReadBool('Settings', 'WindowMode', False);
  //ComboBoxScreenMode.ItemIndex := Conf.ReadInteger('Settings', 'ScreenMode', 0);
  ComboBox.ItemIndex := Conf.ReadInteger('Settings', 'ScreenMode', 0);
  Conf.Free;
end;

procedure TFrmMain.SaveUserConfig;
var
  Conf: TIniFile;
begin
  Conf := TIniFile.Create(g_sSelfFilePath + 'User.ini');
  //Conf.WriteBool('Settings', 'WindowMode', RzCheckBoxWindowMode.Checked);
  //Conf.WriteInteger('Settings', 'ScreenMode', ComboBoxScreenMode.ItemIndex);
  Conf.WriteInteger('Settings', 'ScreenMode', ComboBox.ItemIndex);
  Conf.Free;
end;


procedure TfrmMain.FormCreate(Sender: TObject);

var
  BatchFileName: string;
  sCopyFile: string;
  MemoryStream: TMemoryStream;
  //FileStream: TMemoryStream;
  PlugStream: TMemoryStream;
  Config: TConfig;
  sText: string;
  nCount: Integer;
  nCount1: Integer;
  Buffer: Pointer;
  OutBuf: Pointer;
  OutBytes: Integer;
  SrcP: Pointer;
  nLen: Integer;
  //JPE: TJpegImage;
  Bitmap: TBitmap;
 //// P: Pointer;
 // ReadBuffer: Pointer;
  I: Integer;
 { outBuffer: Pointer;
  outSize: Integer; }
begin
  Application.ShowMainForm := False;
  g_sSelfFileName := ExtractFileName(Application.ExeName);
  g_sSelfFilePath := ExtractFilePath(Application.ExeName);


  FillChar(SelfProcessEntry, SizeOf(TProcessEntry32), 0);
  FindModules := TStringList.Create;
  SelfModules := TStringList.Create;
  DLLNameList := TStringList.Create;
  FilterModules := TStringList.Create;

  g_SearchList := TStringList.Create;
  g_LegendPathList := TStringList.Create;
  g_ClientHandleList := TList.Create;
  g_PlugList := TStringList.Create;
  WebBrowser := TWebBrowser.Create(Self);
  g_ComponentList.Add(RzBmpButtonFullScreenStart);
  g_ComponentList.Add(RzBmpButtonEditGameList);
  g_ComponentList.Add(RzBmpButtonHomePage);
  g_ComponentList.Add(RzBmpButtonAutoLogin);
  g_ComponentList.Add(RzBmpButtonUpgrade);
  g_ComponentList.Add(RzBmpButtonStart);
  g_ComponentList.Add(RzBmpButtonNewAccount);
  g_ComponentList.Add(RzBmpButtonGetBakPassWord);
  g_ComponentList.Add(RzBmpButtonChgPassWord);
  g_ComponentList.Add(RzBmpButtonExitGame);
  g_ComponentList.Add(RzBmpButtonMin);
  g_ComponentList.Add(RzBmpButtonClose);
  g_ComponentList.Add(TreeView);
  g_ComponentList.Add(WebBrowser);
  g_ComponentList.Add(LabelStatus);
  g_ComponentList.Add(ComboBox);
  GetMem(g_DomainNameBuffer, SizeOf(Config.Buffer) + SizeOf(Integer));
  MirClient := nil;
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
  MirClient := TMemoryStream.Create;
  MemoryStream := TMemoryStream.Create;
  try
    nLen := SizeOf(TGameLoginConfig);
    MemoryStream.LoadFromFile(Application.ExeName);

    MemoryStream.Seek(-nLen, soFromEnd);
    MemoryStream.Read(g_GameLoginConfig, nLen);

    for I := 0 to Length(g_GameLoginConfig.ComponentImages) - 1 do begin
      Inc(nLen, g_GameLoginConfig.ComponentImages[I].UpSize);
      Inc(nLen, g_GameLoginConfig.ComponentImages[I].HotSize);
      Inc(nLen, g_GameLoginConfig.ComponentImages[I].DownSize);
      Inc(nLen, g_GameLoginConfig.ComponentImages[I].Disabled);
    end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
 //读取界面数据
    MemoryStream.Seek(-nLen, soFromEnd);
    GetMem(g_Buffer, nLen - SizeOf(TGameLoginConfig));
    MemoryStream.Read(g_Buffer^, nLen - SizeOf(TGameLoginConfig));
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
    MemoryStream.Seek(-(nLen + SizeOf(Integer)), soFromEnd);
    MemoryStream.Read(nCount, SizeOf(Integer));
    MemoryStream.Seek(-(nLen + SizeOf(Integer) + nCount), soFromEnd);

    GetMem(Buffer, nCount);
    try
      MemoryStream.Read(Buffer^, nCount);
      DecompressBuf(Buffer, nCount, 0, OutBuf, OutBytes);
    finally
      FreeMem(Buffer);
    end;
    Move(OutBuf^, Config, OutBytes);
    FreeMem(OutBuf);
    //Showmessage('nCount:' + IntToStr(nCount) + ' OutBytes:' + IntToStr(OutBytes) + ' SizeOf(TConfig):' + IntToStr(SizeOf(TConfig)));
    //Showmessage(Config.PlugConfig[0].Name);

    {
    nCount := nLen;

    nLen := Length(EncryptBuffer(@Config, SizeOf(TConfig)));
    SetLength(sText, nLen);
    MemoryStream.Seek(-(nLen + nCount), soFromEnd);
    MemoryStream.Read(sText[1], nLen);
    DecryptBuffer(sText, @Config, SizeOf(TConfig));

    }
    //Showmessage(Config.PlugConfig[0].Name);


    GetMem(Buffer, Config.nClientSize);
    try
      MemoryStream.Seek(Config.nClientPos, soFromBeginning);
      MemoryStream.Read(Buffer^, Config.nClientSize);
      MirClient.Write(Buffer^, Config.nClientSize);
    finally
      FreeMem(Buffer);
    end;

    //Showmessage(Config.PlugConfig[0].Name);

    for I := 0 to 10 - 1 do begin
      Application.ProcessMessages;
      if (Config.PlugConfig[I].Pos > 0) and (Config.PlugConfig[I].Size > 0) and (Config.PlugConfig[I].Name <> '') then begin
        PlugStream := TMemoryStream.Create;
        GetMem(Buffer, Config.PlugConfig[I].Size);
        try
          MemoryStream.Seek(Config.PlugConfig[I].Pos, soFromBeginning);
          MemoryStream.Read(Buffer^, Config.PlugConfig[I].Size);
          PlugStream.Write(Buffer^, Config.PlugConfig[I].Size);
          g_PlugList.AddObject(Config.PlugConfig[I].Name, PlugStream);
          PlugStream := nil;
        finally
          FreeMem(Buffer);
        end;
      end;
    end;
  except

  end;
  MemoryStream.Free;


{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
  g_CreateUlrName := EncryptString(Config.sUlrName);
  g_sHomePage := EncryptString(Config.sHomePage);
  g_sRemoteConfigAddress := EncryptString(Config.sConfigAddress);
  g_sGameRemoteAddress := EncryptString(Config.sGameAddress);
  nCount := SizeOf(Config.Buffer);
  Move(nCount, g_DomainNameBuffer^, SizeOf(Integer));
  Move(Config.Buffer, g_DomainNameBuffer[SizeOf(Integer)], SizeOf(Config.Buffer));
  g_boClose := False;
  CreateUlr(DecryptString(g_CreateUlrName));
  g_AllGameList := TGameZone.Create;
  g_GameList := TGameZone.Create();
  g_LocalGameList := TGameZone.Create();

  //g_MessageDlg := TMessageDlg.Create(Owner);
  //g_NpcDlg := TNpcDlg.Create(Owner);

  //TimerReakSkin.Enabled := TRUE;
  ReadSkin;

  if CheckMirPath(g_sSelfFilePath) then begin
   { g_MirsClient.sDirectory := g_sMirPath;
    g_MirsClient.sDirectory := g_sMirPath; }
    frmUpgradeDownload := TfrmUpgradeDownload.Create(Owner);
    frmUpgradeDownload.Open;
    frmUpgradeDownload.Free;
    {Self.Repaint;
    Self.Refresh; }
  end;

  LoadUserConfig;

  if g_boNeedUpgradeSelf then begin
    CloseTimer.Enabled := True;
  end else begin
    TimerStart.Enabled := True;
    Application.ShowMainForm := True;
  end;

  //Image.RecreateRegion;

  {if g_boClose then begin
    Application.ShowMainForm := False;
    CloseTimer.Enabled := True;
  end else begin
    TimerStart.Enabled := True;
  end;}
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  I: Integer;
  nHandle: Integer;
begin
  g_boClose := True;
  for I := 0 to g_ClientHandleList.Count - 1 do begin
    nHandle := Integer(g_ClientHandleList.Items[I]);
    SendProgramMsg(nHandle, GL_QUIT, '');
  end;

  try
    if not g_boClose then
      g_LocalGameList.SaveToFile(g_sLocalGameListFileName);
    FreeMem(g_DomainNameBuffer);

    g_GameList.Free;
    g_LocalGameList.Free;

    //g_MessageDlg.Free;
    //g_NpcDlg.Free;
    g_AllGameList.Free;
    WebBrowser.Free;
    g_ClientHandleList.Free;
    if MirClient <> nil then MirClient.Free;
    for I := 0 to g_PlugList.Count - 1 do begin
      TMemoryStream(g_PlugList.Objects[I]).Free;
    end;
    g_PlugList.Free;
    g_SearchList.Free;
    g_LegendPathList.Free;
    FindModules.Free;
    SelfModules.Free;
    DLLNameList.Free;
    FilterModules.Free;
  except

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
    while Proceed do begin
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

function RunProgram(GameZone: TGameZone; sDirectory, sProgramFile, sHandle: string; dwWaitTime: LongWord; nScreenWidth, nScreenHegiht: Integer): LongWord;
var
  StartupInfo: TStartupInfo;
  sCommandLine: string;
  sCurDirectory: string;
  ProcessInfo: TProcessInformation;
  dwTick: LongWord;
  MirServer: TMirServer;
begin
  Result := 0;
  FillChar(StartupInfo, SizeOf(TStartupInfo), #0);
  {
  StartupInfo.cb:=SizeOf(TStartupInfo);
  StartupInfo.lpReserved:=nil;
  StartupInfo.lpDesktop:=nil;
  StartupInfo.lpTitle:=nil;
  StartupInfo.dwFillAttribute:=0;
  StartupInfo.cbReserved2:=0;
  StartupInfo.lpReserved2:=nil;
  }

  if GameZone.Encrypt then begin
    MirServer.sServeraddr := DecryptString256(GameZone.GameHost, GAME_PASSWORD);
    MirServer.nServerPort := Str_ToInt(DecryptString256(GameZone.GameIPPort, GAME_PASSWORD), 0);
  end else begin
    MirServer.sServeraddr := GameZone.GameHost;
    MirServer.nServerPort := Str_ToInt(GameZone.GameIPPort, 0);
  end;
  MirServer.sServerName := GameZone.ServerName;
  MirServer.boFullScreen := g_boFullScreen;

  MirServer.nScreenWidth := nScreenWidth;
  MirServer.nScreenHegiht := nScreenHegiht;

  GetStartupInfo(StartupInfo);
  StartupInfo.wShowWindow := SW_SHOW;
  StartupInfo.dwFlags := STARTF_USEFILLATTRIBUTE;
  StartupInfo.dwFillAttribute := FOREGROUND_INTENSITY or BACKGROUND_BLUE;

  sCommandLine := Format('%s%s %s %s', [sDirectory, sProgramFile, sHandle, EncryptBuffer(@MirServer, SizeOf(TMirServer))]);

  dwTick := GetTickCount;
  sCurDirectory := sDirectory;
  if not CreateProcess(nil, //lpApplicationName,
    PChar(sCommandLine), //lpCommandLine,
    nil, //lpProcessAttributes,
    nil, //lpThreadAttributes,
    True, //bInheritHandles,
    0, //dwCreationFlags,
    nil, //lpEnvironment,
    PChar(sCurDirectory), //lpCurrentDirectory,
    StartupInfo, //lpStartupInfo,
    ProcessInfo) then begin //lpProcessInformation

    Result := GetLastError();
  end;
  //Sleep(dwWaitTime);
end;


procedure TfrmMain.RzBmpButtonFullScreenStartClick(Sender: TObject);
var
  I: Integer;
  nScreenWidth: Integer;
  nScreenHegiht: Integer;
begin
  if g_SelGameZone <> nil then begin
    g_boFullScreen := Sender = RzBmpButtonFullScreenStart;
    for I := 0 to g_PlugList.Count - 1 do begin
      //Showmessage(g_PlugList.Strings[I]);
      try
        TMemoryStream(g_PlugList.Objects[I]).SaveToFile(g_sMirPath + g_PlugList.Strings[I]);
      except

      end;
    end;
    FileSetAttr(g_sMirPath + g_sProgamFile, 0);
    try
      MirClient.SaveToFile(g_sMirPath + g_sProgamFile);
    except

    end;

    Application.Minimize; //最小化窗口
    //RunApp(g_sMirPath + g_sProgamFile); //启动客户端
    nScreenWidth := 800;
    nScreenHegiht := 600;
    case ComboBox.ItemIndex of
      0: begin
          nScreenWidth := 800;
          nScreenHegiht := 600;
        end;
      1: begin
          nScreenWidth := 1024;
          nScreenHegiht := 768;
        end;
    end;
    SaveUserConfig;
    RunProgram(g_SelGameZone, g_sMirPath, g_sProgamFile, IntToStr(Handle), 0, nScreenWidth, nScreenHegiht);
  end;
end;

procedure TfrmMain.ChgButtonStatus(btStatus: Byte);
begin
  //RzBmpButtonStatus.Bitmaps.Up.LoadFromResourceName(HInstance, 'Connect');
  {case btStatus of
    0: begin
        ConnectRes := TResourceStream.Create(HInstance, 'Connect', PChar('Bmp'));
        RzBmpButtonStatus.Bitmaps.Up.LoadFromStream(ConnectRes);
        ConnectRes.Free;
      end;
    1: begin
        ConnectingRes := TResourceStream.Create(HInstance, 'Connecting', PChar('Bmp'));
        RzBmpButtonStatus.Bitmaps.Up.LoadFromStream(ConnectingRes);
        ConnectingRes.Free;
      end;
    2: begin
        DisconnectRes := TResourceStream.Create(HInstance, 'Disconnect', PChar('Bmp'));
        RzBmpButtonStatus.Bitmaps.Up.LoadFromStream(DisconnectRes);
        DisconnectRes.Free;
      end;
  end;}
end;

procedure TfrmMain.RzBmpButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.RzBmpButtonHomePageClick(Sender: TObject);
begin
  if g_SelGameZone = nil then Exit;
  ShellExecute(0, 'Open', PChar(g_SelGameZone.HomePage), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmMain.RzBmpButtonNewAccountClick(Sender: TObject);
begin
  ConnectServer;
  frmMain.SendGetRandomCode;
  //frmNewAccount.LabelStatus.Caption := MsgLabel.Caption;
  frmNewAccount.Open;
end;

procedure TfrmMain.RzBmpButtonGetBakPassWordClick(Sender: TObject);
begin
  ConnectServer;
  //frmGetBackPassword.LabelStatus.Caption := MsgLabel.Caption;
  frmGetBackPassword.Open;
end;

procedure TfrmMain.RzBmpButtonChgPassWordClick(Sender: TObject);
begin
  ConnectServer;
  //frmChangePassword.LabelStatus.Caption := MsgLabel.Caption;
  frmChangePassword.Open;
end;

procedure TfrmMain.ReleaseClient(sDirectory: string; GameZone: TGameZone);
  {function HostToIP(Name: string; var Ip: string): Boolean;
  var
    wsdata: TWSAData;
    hostName: array[0..255] of char;
    hostEnt: PHostEnt;
    addr: PChar;
  begin
    WSAStartup($0101, wsdata);
    try
      gethostname(hostName, SizeOf(hostName));
      StrPCopy(hostName, Name);
      hostEnt := gethostbyname(hostName);
      if Assigned(hostEnt) then
        if Assigned(hostEnt^.h_addr_list) then begin
          addr := hostEnt^.h_addr_list^;
          if Assigned(addr) then begin
            Ip := Format('%d.%d.%d.%d', [Byte(addr[0]),
              Byte(addr[1]), Byte(addr[2]), Byte(addr[3])]);
            Result := True;
          end
          else
            Result := FALSE;
        end
        else
          Result := FALSE
      else begin
        Result := FALSE;
      end;
    finally
      WSACleanup;
    end
  end; }
var
  Res: TResourceStream;
  //sIpAddr: string;
  Myinifile: TIniFile;
  sServerAddr: string;
  sServerPort: string;
begin
  FileSetAttr(sDirectory + g_sProgamFile, 0);
  try
    MirClient.SaveToFile(sDirectory + g_sProgamFile);
  except

  end;
  {  Res := TResourceStream.Create(HInstance, 'MirClient', PChar('exe'));
  try
    FileSetAttr(sDirectory + g_sProgamFile, 0);
    Res.SaveToFile(sDirectory + g_sProgamFile);
  except

  end;
  Res.Free;}
 { FileSetAttr(sDirectory + g_sClientFile, 0);
  Res := TResourceStream.Create(HInstance, 'FirClient', PChar('dll'));
  try
    Res.SaveToFile(sDirectory + g_sClientFile);
    Res.Free;
    Res := nil;
  except
    Res.Free;
    Res := nil;
  end;  }

  if GameZone.Encrypt then begin
    sServerAddr := DecryptString256(GameZone.GameHost, GAME_PASSWORD);
    sServerPort := DecryptString256(GameZone.GameIPPort, GAME_PASSWORD);
  end else begin
    sServerAddr := GameZone.GameHost;
    sServerPort := GameZone.GameIPPort;
  end;
  FileSetAttr(sDirectory + 'mir.ini', 0);
  Myinifile := TIniFile.Create(sDirectory + 'mir.ini');
  if Myinifile <> nil then begin
    Myinifile.WriteString('Setup', 'FontName', '宋体');
    Myinifile.WriteBool('Setup', 'FullScreen', g_boFullScreen);
    Myinifile.WriteString('Setup', 'Serveraddr', GameZone.GameIPaddr); //IP地址
    Myinifile.WriteString('Setup', 'ServerPort', sServerPort); //端口
    Myinifile.Free;
  end;
 { FileSetAttr(sDirectory + 'ftp.ini', 0);
  Myinifile := TIniFile.Create(sDirectory + 'ftp.ini');
  if Myinifile <> nil then begin
    Myinifile.WriteInteger('Server', 'Servercount', 1);
    Myinifile.WriteString('Server', 'server1caption', GameZone.ServerName); //开门名称
    Myinifile.WriteString('Server', 'server1name', GameZone.ServerName); //服务器名称
    Myinifile.Free;
  end;   }

  {FileSetAttr(sDirectory + g_sProgamFile, 2);
  FileSetAttr(sDirectory + g_sClientFile, 2); }
end;

function RunApp(AppName: string): Integer;
var
  Sti: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  FillMemory(@Sti, SizeOf(Sti), 0);
  Sti.wShowWindow := SW_SHOW;
  Sti.dwFlags := STARTF_USEFILLATTRIBUTE;
  Sti.dwFillAttribute := FOREGROUND_INTENSITY or BACKGROUND_BLUE;
  if CreateProcess(PChar(AppName), nil,
    nil, nil, False,
    0, nil, PChar(ExtractFilePath(AppName)),
    Sti, ProcessInfo) then begin
    Result := ProcessInfo.dwProcessId;
  end else Result := -1;
end;

{procedure CopyFile(const Sour, Dest: string);
var
  FileOp: TSHFileOpStruct;
begin
  with FileOp do begin
    Wnd := FrmMain.HandLe;
    wFunc := FO_Copy; //更换此参数可实现拷贝和更名
    pFrom := PChar(Sour);
    pTo := PChar(Dest);
    fFlags := FOF_NoConfirmation;
    fAnyOperationsAborted := False;
    hNameMappings := nil;
    lpszProgressTitle := nil
  end;
  SHFileOperation(FileOp);
end;}

//判断文件是否正在使用

function IsFileInUse(FName: string): Boolean;
var
  HFileRes: HFILE;
begin
  Result := False;
  if not FileExists(FName) then
    Exit;
  HFileRes := CreateFile(PChar(FName), GENERIC_READ or GENERIC_WRITE, 0,
    nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  Result := (HFileRes = INVALID_HANDLE_VALUE);
  if not Result then
    CloseHandle(HFileRes);
end;


procedure TfrmMain.TimerStartTimer(Sender: TObject);
var
  I, n01: Integer;
  GameZone: TGameZone;
  TreeNode: TTreeNode;
  ChildTreeNode: TTreeNode;
  sFileName: string;
  //GameArea: pTGameArea;
begin
  TimerStart.Enabled := False;
  //ParamStr(1);

  if not CheckMirPath(g_sSelfFilePath) then begin
    if Application.MessageBox('目录不正确，是否自动搜索热血传奇客户端？',
      '提示信息',
      MB_YESNO + MB_ICONQUESTION) = IDYES then begin
      if SearchMirClient(g_sSelfFilePath) then begin

        if IsFileInUse(g_sMirPath + g_sSelfFileName) then begin
          if Pos('.', g_sSelfFileName) > 0 then begin
            g_sSelfFileName := Copy(g_sSelfFileName, 1, Pos('.', g_sSelfFileName) - 1);
          end;
          //g_sSelfFileName := Copy(g_sSelfFileName, 1, Length(g_sSelfFileName) - 4);
          //ChangeFileExt(ExtractFileName(sFileName),'');
          n01 := 0;
          while TRUE do begin
            sFileName := g_sMirPath + g_sSelfFileName + IntToStr(n01) + '.exe';
            if not FileExists(sFileName) then Break;
          end;
          g_sSelfFileName := g_sSelfFileName + IntToStr(n01) + '.exe';
        end else begin
          FileSetAttr(g_sMirPath + g_sSelfFileName, 0);
          DeleteFile(g_sMirPath + g_sSelfFileName);
        end;

        CopyFile(PChar(Application.ExeName), PChar(g_sMirPath + g_sSelfFileName), True); //复制自己
        RunApp(g_sMirPath + g_sSelfFileName); //启动
        Application.Terminate;
        Exit;
      end;
    end else begin
      if not SelectDirectory('请选择您的热血传奇客户端“Legend of mir2”目录', '', g_sMirPath, Handle) then begin
        Close;
        Exit;
      end;
      if (g_sMirPath <> '') and (g_sMirPath[Length(g_sMirPath)] <> '\') then g_sMirPath := g_sMirPath + '\';
      if not CheckMirPath(g_sMirPath) then begin
        Close;
        Exit;
      end else begin
        WriteRegKey(1, R_MySubKey, R_Key, g_sMirPath);

        if IsFileInUse(g_sMirPath + g_sSelfFileName) then begin
          if Pos('.', g_sSelfFileName) > 0 then begin
            g_sSelfFileName := Copy(g_sSelfFileName, 1, Pos('.', g_sSelfFileName) - 1);
          end;
          //g_sSelfFileName := Copy(g_sSelfFileName, 1, Length(g_sSelfFileName) - 4);
          //ChangeFileExt(ExtractFileName(sFileName),'');
          n01 := 0;
          while TRUE do begin
            sFileName := g_sMirPath + g_sSelfFileName + IntToStr(n01) + '.exe';
            if not FileExists(sFileName) then Break;
          end;
          g_sSelfFileName := g_sSelfFileName + IntToStr(n01) + '.exe';
        end else begin
          FileSetAttr(g_sMirPath + g_sSelfFileName, 0);
          DeleteFile(g_sMirPath + g_sSelfFileName);
        end;

        CopyFile(PChar(Application.ExeName), PChar(g_sMirPath + g_sSelfFileName), True); //复制自己
        RunApp(g_sMirPath + g_sSelfFileName); //启动
        Application.Terminate;
        Exit;
      end;
    end;
  end;

  g_sLocalGameListFileName := g_sMirPath + 'LocalCqfir.Dat';

  Timer.Enabled := True;

  //g_GameList.LoadFromFile(g_sGameListFileName);
  g_LocalGameList.LoadFromFile(g_sLocalGameListFileName);
  LoadListToBox();
  TreeNode := TreeView.Items.GetFirstNode;
  if TreeNode <> nil then begin
    ChildTreeNode := TreeNode.getFirstChild;
    if ChildTreeNode <> nil then begin
      TreeView.SetFocus;
      ChildTreeNode.Selected := True;
      ChildTreeNode.Focused := True;
      TreeViewClick(TreeView);
    end;
  end;
end;

procedure TfrmMain.LoadListToBox();
var
  I, II: Integer;
  GameZone: TGameZone;
  ChildGameZone: TGameZone;
  TreeNode: TTreeNode;
  ChildTreeNode: TTreeNode;
begin
  TreeView.Items.Clear;
  g_AllGameList.Clear;
  g_AllGameList.Strings.AddStrings(g_GameList.Strings);
  g_AllGameList.Strings.AddStrings(g_LocalGameList.Strings);
  if TreeView.Visible then begin
    TreeView.SetFocus;
    for I := 0 to g_AllGameList.Count - 1 do begin
      GameZone := g_AllGameList.Items[I];
      if GameZone.Count > 0 then begin
        TreeNode := TreeView.Items.AddObject(nil, GameZone.Caption, GameZone);
        TreeNode.HasChildren := True;

        TreeNode.Expand(GameZone.Expand);
        if GameZone.Expand then begin
          TreeView.SetFocus;
          TreeNode.Selected := True;
          TreeNode.Focused := True;
          TreeViewClick(TreeView);
          TreeNode.Selected := False;
          TreeNode.Focused := False;
        end;

        for II := 0 to GameZone.Count - 1 do begin
          ChildGameZone := GameZone.Items[II];
          ChildTreeNode := TreeView.Items.AddChildObject(TreeNode, ChildGameZone.Caption, ChildGameZone);
          ChildTreeNode.Expand(ChildGameZone.Expand);
          if ChildGameZone.Expand then begin
            TreeView.SetFocus;
            ChildTreeNode.Selected := True;
            ChildTreeNode.Focused := True;
            TreeViewClick(TreeView);
            ChildTreeNode.Selected := False;
            ChildTreeNode.Focused := False;
          end;
        end;

      end;
    end;
  end;
end;

procedure TfrmMain.RzBmpButtonEditGameListClick(Sender: TObject);
begin
  frmEditGame := TfrmEditGame.Create(Owner);
  frmEditGame.Open();
  frmEditGame.Free;
end;

procedure TfrmMain.RzBmpButtonAutoLoginClick(Sender: TObject);
begin
  {try
    if g_SelGameZone <> nil then begin
      frmCMain := TfrmCMain.Create(Application);
      frmCMain.Open;
      Application.Minimize;
    end;
  except
  end; }
end;

procedure TfrmMain.CloseTimerTimer(Sender: TObject);
var
  BatchFile: TextFile;
  BatchFileName: string;
  ProcessInfo: TProcessInformation;
  StartUpInfo: TStartupInfo;
begin
  CloseTimer.Enabled := False;
  BatchFileName := ExtractFilePath(ParamStr(0)) + '$$s$$.bat';
  FileSetAttr(BatchFileName, 0);
  DeleteFile(BatchFileName);
  AssignFile(BatchFile, BatchFileName);
  Rewrite(BatchFile);
  Writeln(BatchFile, ':tryn');
  Writeln(BatchFile, 'ren ' + g_sSelfFileName + ' ' + g_sSelfFileName + '.Del');
  Writeln(BatchFile, 'if exist "' + g_sSelfFileName + '.Del' + '"' + ' goto try');
  Writeln(BatchFile, 'if exist "' + g_sSelfFileName + '"' + ' goto tryn');
  Writeln(BatchFile, ':try');
  Writeln(BatchFile, 'del "' + g_sSelfFileName + '.Del' + '"');
  Writeln(BatchFile, 'if exist "' + g_sSelfFileName + '.Del' + '"' + ' goto try');

  Writeln(BatchFile, ':refren');
  Writeln(BatchFile, 'ren ' + g_sUpgradeSelfFileName + ' ' + g_sSelfFileName);
  Writeln(BatchFile, 'if not exist "' + g_sSelfFileName + '"' + ' goto refren');

  Writeln(BatchFile, 'start ' + g_sSelfFileName);
  Writeln(BatchFile, 'del %0');
  Writeln(BatchFile, 'exit');
  CloseFile(BatchFile);
    //FileSetAttr(BatchFileName, 2);
  FileSetAttr(ExtractFilePath(ParamStr(0)) + g_sSelfFileName, 0);
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

procedure TfrmMain.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;


procedure TfrmMain.RzBmpButtonMinClick(Sender: TObject);
begin
  Application.Minimize;
end;


procedure TfrmMain.ReadSkin;
  function IncPointer(Buffer: Pointer; Size: Integer): Pointer;
  begin
    Result := Pointer(Integer(Buffer) + Size);
  end;

var
  I: Integer;
  nLen: Integer;
  Buffer: Pointer;
  ReadBuffer: Pointer;
  OutBuf: Pointer;
  OutBytes: Integer;
  Bitmap: TBitmap;
  FileStream: TMemoryStream;
begin
  Buffer := g_Buffer;
  FileStream := TMemoryStream.Create;

  Application.ProcessMessages;
  if g_GameLoginConfig.ComponentImages[0].UpSize > 0 then begin
    DecompressBuf(Buffer, g_GameLoginConfig.ComponentImages[0].UpSize, 0, OutBuf, OutBytes);
    Buffer := IncPointer(Buffer, g_GameLoginConfig.ComponentImages[0].UpSize);

    FileStream.Clear;
    FileStream.Write(OutBuf^, OutBytes);
    FileStream.Position := 0;
    FreeMem(OutBuf);

    Bitmap := TBitmap.Create;
    Bitmap.LoadFromStream(FileStream);
    FileStream.Position := 0;
    //Bitmap.SaveToFile('Bitmap.bmp');
    ClientHeight := Bitmap.Height;
    ClientWidth := Bitmap.Width;
    Image.Picture.Bitmap.Assign(Bitmap);
    Image.Transparent := g_GameLoginConfig.Transparent;
    //Image.Picture.Bitmap.LoadFromStream(FileStream);
    //Image.Picture.Bitmap.TransparentColor := clBlack;
    //Image.Picture.Bitmap.Transparent := True;
    if Image.Transparent then
      Image.RecreateRegion;

    Bitmap.Free;
  end;
  Application.ProcessMessages;
{------------------------------------------------------------------------------}

  for I := 0 to Length(g_GameLoginConfig.ComponentConfigs) - 1 do begin
    Application.ProcessMessages;
    if WebBrowser = g_ComponentList.Items[I] then begin
      g_nWebHeiht := g_GameLoginConfig.ComponentConfigs[I].Height;
      g_WebBrowser := g_GameLoginConfig.ComponentConfigs[I];
    end else begin
      TWinControl(g_ComponentList.Items[I]).Left := g_GameLoginConfig.ComponentConfigs[I].Left;
      TWinControl(g_ComponentList.Items[I]).Top := g_GameLoginConfig.ComponentConfigs[I].Top;
      TWinControl(g_ComponentList.Items[I]).Width := g_GameLoginConfig.ComponentConfigs[I].Width;
      TWinControl(g_ComponentList.Items[I]).Height := g_GameLoginConfig.ComponentConfigs[I].Height;
      if TWinControl(g_ComponentList.Items[I]).Visible then
        with TWinControl(g_ComponentList.Items[I]) do
          SetBounds(Left, Top, Width, Height);
    end;
    TWinControl(g_ComponentList.Items[I]).Visible := g_GameLoginConfig.ComponentConfigs[I].Visible;
  end;

  WebBrowser.Left := g_WebBrowser.Left;
  WebBrowser.Top := g_WebBrowser.Top;
  WebBrowser.Width := g_WebBrowser.Width;
  WebBrowser.Height := g_WebBrowser.Height;

  WebBrowser.ParentWindow := Handle;
  with g_WebBrowser do
    WebBrowser.SetBounds(Left, Top, Width, Height);

  for I := 1 to Length(g_GameLoginConfig.ComponentImages) - 1 do begin
    Application.ProcessMessages;
    if TRzBmpButton(g_ComponentList.Items[I - 1]).Visible then begin
      if (g_GameLoginConfig.ComponentImages[I].UpSize > 0) and (TRzBmpButton(g_ComponentList.Items[I - 1]).Bitmaps.Up <> nil) then begin
        FileStream.Clear;
        FileStream.Write(Buffer^, g_GameLoginConfig.ComponentImages[I].UpSize);
        Buffer := IncPointer(Buffer, g_GameLoginConfig.ComponentImages[I].UpSize);
        FileStream.Position := 0;
        TRzBmpButton(g_ComponentList.Items[I - 1]).Bitmaps.Up.LoadFromStream(FileStream);
      end;
      if (g_GameLoginConfig.ComponentImages[I].HotSize > 0) and (TRzBmpButton(g_ComponentList.Items[I - 1]).Bitmaps.Hot <> nil) then begin
        FileStream.Clear;
        FileStream.Write(Buffer^, g_GameLoginConfig.ComponentImages[I].HotSize);
        Buffer := IncPointer(Buffer, g_GameLoginConfig.ComponentImages[I].HotSize);
        FileStream.Position := 0;
        TRzBmpButton(g_ComponentList.Items[I - 1]).Bitmaps.Hot.LoadFromStream(FileStream);
      end;
      if (g_GameLoginConfig.ComponentImages[I].DownSize > 0) and (TRzBmpButton(g_ComponentList.Items[I - 1]).Bitmaps.Down <> nil) then begin
        FileStream.Clear;
        FileStream.Write(Buffer^, g_GameLoginConfig.ComponentImages[I].DownSize);
        Buffer := IncPointer(Buffer, g_GameLoginConfig.ComponentImages[I].DownSize);
        FileStream.Position := 0;
        TRzBmpButton(g_ComponentList.Items[I - 1]).Bitmaps.Down.LoadFromStream(FileStream);
      end;
      if (g_GameLoginConfig.ComponentImages[I].Disabled > 0) and (TRzBmpButton(g_ComponentList.Items[I - 1]).Bitmaps.Disabled <> nil) then begin
        FileStream.Clear;
        FileStream.Write(Buffer^, g_GameLoginConfig.ComponentImages[I].Disabled);
        Buffer := IncPointer(Buffer, g_GameLoginConfig.ComponentImages[I].Disabled);
        FileStream.Position := 0;
        TRzBmpButton(g_ComponentList.Items[I - 1]).Bitmaps.Disabled.LoadFromStream(FileStream);
      end;
    end;
  end;
  FreeMem(g_Buffer);

  FileStream.Free;

  TreeView.Color := g_GameLoginConfig.ViewBColor;
  TreeView.Font.Color := g_GameLoginConfig.ViewFColor;
  g_boReadSkin := True;
end;

procedure TfrmMain.TimerReakSkinTimer(Sender: TObject);
begin
  TimerReakSkin.Enabled := False;
  ReadSkin;
end;

function TfrmMain.AddDLLName(const sName: string; ordinal: Integer;
  address: Pointer): Boolean;
begin
  Result := True;
  DLLNameList.AddObject(sName, TObject(address));
end;

procedure TfrmMain.SpeedHackTimerTimer(Sender: TObject);
var
  I, II, III: Integer;
 // TempList1: TStringList;
 // TempList2: TStringList;
  boFind: Boolean;
  nHandle: Integer;
const
  ExportList: array[0..8] of string = ('cshdll', 'cshid', 'getdz', 'getsd', 'tzdj', 'tzdz', 'tzdz2', 'tzsd', 'tzsd2');
begin
  if SelfProcessEntry.th32ProcessID = 0 then begin
    FindModules.Clear;
    SelfModules.Clear;
    GetSelfProcesses(FindModules);
    SelfModules.AddStrings(FindModules);
    //DebugOutStr(FindModules.Text);
  end;

  if SelfProcessEntry.th32ProcessID <> 0 then begin
    FindModules.Clear;
    GetSelfModules(SelfProcessEntry.th32ProcessID, FindModules);
    if FindModules.Count > 0 then begin
      for I := 0 to FindModules.Count - 1 do begin
        if FilterModules.IndexOf(FindModules.Strings[I]) < 0 then begin
          DLLNameList.Clear;
          try
            if IsDll(FindModules.Strings[I]) then
              ListDLLExports(FindModules.Strings[I], DLLNameList);
          except

          end;
          if DLLNameList.Count >= Length(ExportList) then begin
            boFind := True;
            for III := 0 to Length(ExportList) - 1 do begin
              if CompareText(ExportList[III], DLLNameList.Strings[III]) <> 0 then begin
                boFind := False;
                break;
              end;
            end;
            if boFind then begin
              SpeedHackTimer.Enabled := False;

              for II := 0 to g_ClientHandleList.Count - 1 do begin
                nHandle := Integer(g_ClientHandleList.Items[II]);
                SendProgramMsg(nHandle, GL_FILTERMODULE, '');
              end;
              Exit;
            end else FilterModules.Add(FindModules.Strings[I]);
          end else FilterModules.Add(FindModules.Strings[I]);
        end;
      end;
    end;
  end;
end;

initialization
  begin
    g_ComponentList := TList.Create;
  end;
finalization
  begin
    g_ComponentList.Free;
  end;
end.

