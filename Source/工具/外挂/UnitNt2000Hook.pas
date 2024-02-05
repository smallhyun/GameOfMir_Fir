unit UnitNt2000Hook;

interface

uses Classes, Windows;

const
  cOsUnknown: Integer = -1;
  cOsWin95: Integer = 0;
  cOsWin98: Integer = 1;
  cOsWin98SE: Integer = 2;
  cOsWinME: Integer = 3;
  cOsWinNT: Integer = 4;
  cOsWin2000: Integer = 5;
  cOsWhistler: Integer = 6;

type
  TImportCode = packed record
    JumpInstruction: Word;
    AddressOfPointerToFunction: PPointer;
  end;
  PImage_Import_Entry = ^Image_Import_Entry;
  Image_Import_Entry = record
    Characteristics: DWORD;
    TimeDateStamp: DWORD;
    MajorVersion: Word;
    MinorVersion: Word;
    Name: DWORD;
    LookupTable: DWORD;
  end;
  PImportCode = ^TImportCode;
  TLongJmp = packed record
    JmpCode: ShortInt; {指令，用$E9来代替系统的指令}
    FuncAddr: DWORD; {函数地址}
  end;

  THookClass = class
  private
    Trap: boolean; {调用方式：True陷阱式，False改引入表式}
    hProcess: Cardinal; {进程句柄，只用于陷阱式}
    AlreadyHook: boolean; {是否已安装Hook，只用于陷阱式}
    AllowChange: boolean; {是否允许安装、卸载Hook，只用于改引入表式}
    Oldcode: array[0..4] of byte; {系统函数原来的前5个字节}
    Newcode: TLongJmp; {将要写在系统函数的前5个字节}
  private
  public
    OldFunction, NewFunction: Pointer; {被截函数、自定义函数}
    constructor Create(IsTrap: boolean; OldFun, NewFun: Pointer);
    constructor Destroy;
    procedure Restore;
    procedure Change;
  published
  end;
function GetOSVersion: Integer; //获取系统版本
function GetTrap: boolean;
implementation
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
            Result := cOsWhistler
          else
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

function GetTrap: boolean;
begin
  Result := GetOSVersion in [0..3];
end;

{取函数的实际地址。如果函数的第一个指令是Jmp，则取出它的跳转地址（实际地址），这往往是由于程序中含有Debug调试信息引起的}
function FinalFunctionAddress(code: Pointer): Pointer;
var
  func: PImportCode;
begin
  Result := code;
  if code = nil then Exit;
  try
    func := code;
    if (func.JumpInstruction = $25FF) then
      {指令二进制码FF 25  汇编指令jmp [...]}
      func := func.AddressOfPointerToFunction^;
    Result := func;
  except
    Result := nil;
  end;
end;

{更改引入表中指定函数的地址，只用于改引入表式}
function PatchAddressInModule(BeenDone: TList; hModule: THandle; OldFunc, NewFunc: Pointer): Integer;
const
  SIZE = 4;
var
  Dos: PImageDosHeader;
  NT: PImageNTHeaders;
  ImportDesc: PImage_Import_Entry;
  rva: DWORD;
  func: PPointer;
  DLL: string;
  f: Pointer;
  written: DWORD;
  mbi_thunk: TMemoryBasicInformation;
  dwOldProtect: DWORD;
begin
  Result := 0;
  if hModule = 0 then Exit;
  Dos := Pointer(hModule);
  {如果这个DLL模块已经处理过，则退出。BeenDone包含已处理的DLL模块}
  if BeenDone.IndexOf(Dos) >= 0 then Exit;
  BeenDone.Add(Dos); {把DLL模块名加入BeenDone}
  OldFunc := FinalFunctionAddress(OldFunc); {取函数的实际地址}

  {如果这个DLL模块的地址不能访问，则退出}
  if IsBadReadPtr(Dos, SizeOf(TImageDosHeader)) then Exit;
  {如果这个模块不是以'MZ'开头，表明不是DLL，则退出}
  if Dos.e_magic <> IMAGE_DOS_SIGNATURE then Exit; {IMAGE_DOS_SIGNATURE='MZ'}

  {定位至NT Header}
  NT := Pointer(Integer(Dos) + Dos._lfanew);
  {定位至引入函数表}
  rva := NT^.OptionalHeader.
    DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress;
  if rva = 0 then Exit; {如果引入函数表为空，则退出}
  {把函数引入表的相对地址RVA转换为绝对地址}
  ImportDesc := Pointer(DWORD(Dos) + rva); {Dos是此DLL模块的首地址}

  {遍历所有被引入的下级DLL模块}
  while (ImportDesc^.Name <> 0) do
  begin
    {被引入的下级DLL模块名字}
    DLL := pchar(DWORD(Dos) + ImportDesc^.Name);
    {把被导入的下级DLL模块当做当前模块，进行递归调用}
    PatchAddressInModule(BeenDone, GetModuleHandle(pchar(DLL)), OldFunc, NewFunc);

    {定位至被引入的下级DLL模块的函数表}
    func := Pointer(DWORD(Dos) + ImportDesc.LookupTable);
    {遍历被引入的下级DLL模块的所有函数}
    while func^ <> nil do
    begin
      f := FinalFunctionAddress(func^); {取实际地址}
      if f = OldFunc then {如果函数实际地址就是所要找的地址}
      begin
        VirtualQuery(func, mbi_thunk, SizeOf(TMemoryBasicInformation));
        VirtualProtect(func, SIZE, PAGE_EXECUTE_WRITECOPY, mbi_thunk.Protect); {更改内存属性}
        WriteProcessMemory(GetCurrentProcess, func, @NewFunc, SIZE, written); {把新函数地址覆盖它}
        VirtualProtect(func, SIZE, mbi_thunk.Protect, dwOldProtect); {恢复内存属性}
      end;
      if written = 4 then Inc(Result);
//      else showmessagefmt('error:%d',[Written]);
      Inc(func); {下一个功能函数}
    end;
    Inc(ImportDesc); {下一个被引入的下级DLL模块}
  end;
end;

{HOOK的入口，其中IsTrap表示是否采用陷阱式}
constructor THookClass.Create(IsTrap: boolean; OldFun, NewFun: Pointer);
begin
   {求被截函数、自定义函数的实际地址}
  OldFunction := FinalFunctionAddress(OldFun);
  NewFunction := FinalFunctionAddress(NewFun);

  Trap := IsTrap;
  if Trap then {如果是陷阱式}
  begin
      {以特权的方式来打开当前进程}
    hProcess := OpenProcess(PROCESS_ALL_ACCESS, False, GetCurrentProcessId);
      {生成jmp xxxx的代码，共5字节}
    Newcode.JmpCode := ShortInt($E9); {jmp指令的十六进制代码是E9}
    Newcode.FuncAddr := DWORD(NewFunction) - DWORD(OldFunction) - 5;
      {保存被截函数的前5个字节}
    Move(OldFunction^, Oldcode, 5);
      {设置为还没有开始HOOK}
    AlreadyHook := False;
  end;
   {如果是改引入表式，将允许HOOK}
  if not Trap then AllowChange := True;
  Change; {开始HOOK}
   {如果是改引入表式，将暂时不允许HOOK}
  if not Trap then AllowChange := False;
end;

{HOOK的出口}
constructor THookClass.Destroy;
begin
   {如果是改引入表式，将允许HOOK}
  if not Trap then AllowChange := True;
  Restore; {停止HOOK}
  if Trap then {如果是陷阱式}
    CloseHandle(hProcess);
end;

{开始HOOK}
procedure THookClass.Change;
var
  nCount: DWORD;
  BeenDone: TList;
begin
  if Trap then {如果是陷阱式}
  begin
    if (AlreadyHook) or (hProcess = 0) or (OldFunction = nil) or (NewFunction = nil) then
      Exit;
    AlreadyHook := True; {表示已经HOOK}
    WriteProcessMemory(hProcess, OldFunction, @(Newcode), 5, nCount);
  end
  else begin {如果是改引入表式}
    if (not AllowChange) or (OldFunction = nil) or (NewFunction = nil) then Exit;
    BeenDone := TList.Create; {用于存放当前进程所有DLL模块的名字}
    try
      PatchAddressInModule(BeenDone, GetModuleHandle(nil), OldFunction, NewFunction);
    finally
      BeenDone.Free;
    end;
  end;
end;

{恢复系统函数的调用}
procedure THookClass.Restore;
var
  nCount: DWORD;
  BeenDone: TList;
begin
  if Trap then {如果是陷阱式}
  begin
    if (not AlreadyHook) or (hProcess = 0) or (OldFunction = nil) or (NewFunction = nil) then
      Exit;
    WriteProcessMemory(hProcess, OldFunction, @(Oldcode), 5, nCount);
    AlreadyHook := False; {表示退出HOOK}
  end
  else begin {如果是改引入表式}
    if (not AllowChange) or (OldFunction = nil) or (NewFunction = nil) then Exit;
    BeenDone := TList.Create; {用于存放当前进程所有DLL模块的名字}
    try
      PatchAddressInModule(BeenDone, GetModuleHandle(nil), NewFunction, OldFunction);
    finally
      BeenDone.Free;
    end;
  end;
end;

end.

