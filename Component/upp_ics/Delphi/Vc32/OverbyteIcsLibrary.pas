{*_* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       François PIETTE
Description:
Creation:     April 2004
Version:      1.00
EMail:        francois.piette@overbyte.be  http://www.overbyte.be
Support:      Use the mailing list twsocket@elists.org
              Follow "support" link at http://www.overbyte.be for subscription.
Legal issues: Copyright (C) 2004-2006 by François PIETTE
              Rue de Grady 24, 4053 Embourg, Belgium. Fax: +32-4-365.74.56
              <francois.piette@overbyte.be>

              This software is provided 'as-is', without any express or
              implied warranty.  In no event will the author be held liable
              for any  damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.

              4. You must register this software by sending a picture postcard
                 to the author. Use a nice stamp and mention your name, street
                 address, EMail address and any comment you like to say.

History:


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit OverbyteIcsLibrary;

interface

{$B-}             { Enable partial boolean evaluation   }
{$T-}             { Untyped pointers                    }
{$X+}             { Enable extended syntax              }
{$I OverbyteIcsDefs.inc}

uses
{$IFDEF CLR}
  System.Collections,
  System.IO,
  System.Threading,
  System.Runtime.InteropServices,
  System.Reflection,
{$ENDIF}
{$IFDEF WIN32}
  Windows, Classes, Messages,
{$IFNDEF NOFORMS}
  Forms,
{$ENDIF}
  SysUtils,
{$ENDIF}
  OverbyteIcsTypes;

const
  OverbyteIcsLibraryVersion = 100;
  CopyRight : String        = ' OverbyteIcsLibrary (c) 2004-2006 F. Piette V1.00 ';

{$IFDEF CLR}
type
  TRTLCriticalSection = class
  end;

  TList = class(ArrayList)
    function  GetItems(Index: Integer): TObject;
    procedure SetItems(Index: Integer; const Value: TObject);
  public
    procedure Delete(Index : Integer);
    function  First: TObject;
    function  Last: TObject;
    procedure Pack;
    property Items[Index : Integer] : TObject read  GetItems
                                              write SetItems;
  end;
  TStrings = class
  public
    procedure SetStrings(nIndex: Integer; const Value: String); virtual; abstract;
    function  GetStrings(nIndex: Integer): String; virtual; abstract;
  public
    procedure Clear; virtual; abstract;
    procedure Add(const S: String); virtual; abstract;
    function  Count : Integer; virtual; abstract;
    property Strings[nIndex : Integer] : String read  GetStrings
                                                write SetStrings;
  end;
  TStringList = class(TStrings)
  protected
    FStrings : TList;
  public
    procedure SetStrings(nIndex: Integer; const Value: String); override;
    function  GetStrings(nIndex: Integer): String; override;
  public
    constructor Create;
    procedure Clear; override;
    procedure Add(const S: String); override;
    function  Count : Integer; override;
  end;
{$ENDIF}

{$IFDEF CLR}
const
  WM_CREATE           = 1;
  WM_DESTROY          = 2;
  WM_CLOSE            = 16;
  WM_NCCREATE         = 129;
  WM_QUIT             = $0012;
  WS_POPUP            = DWORD($80000000);
  WS_CAPTION          = $C00000;      { WS_BORDER or WS_DLGFRAME  }
  WS_CLIPSIBLINGS     = $4000000;
  WS_SYSMENU          = $80000;
  WS_MAXIMIZEBOX      = $10000;
  WS_MINIMIZEBOX      = $20000;
  WS_EX_TOOLWINDOW    = $80;
  WM_USER             = $0400;
  PM_NOREMOVE         = 0;
  PM_REMOVE           = 1;
  PM_NOYIELD          = 2;
  //WM_MY_MSG           = WM_USER + 1;
  //GWL_WNDPROC         = -4;

function DefWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
function SetWindowLong(hWnd: HWND; nIndex: Integer; dwNewLong: IntPtr): IntPtr; overload;
function GetWindowLongIntPtr(hWnd: HWND; nIndex: Integer): IntPtr;
function GetMessage(out lpMsg: TMsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax: UINT): BOOL;
function PostMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): BOOL;
function TranslateMessage(const lpMsg: TMsg): BOOL;
function DispatchMessage(const lpMsg: TMsg): Longint;
function PeekMessage(out lpMsg: TMsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax, wRemoveMsg: UINT): BOOL;
function RegisterClass(const lpWndClass: TWndClass): ATOM; overload;
function RegisterClass(const lpWndClassInfo: TWndClassInfo): ATOM; overload;
function UnregisterClass(lpClassName: string; hInstance: HINST): BOOL;
function GetClassInfo(hInstance: HINST; lpClassName: string;out lpWndClass: TWndClassInfo): BOOL;
function CreateWindowEx(dwExStyle: DWORD; lpClassName: string;
  lpWindowName: string; dwStyle: DWORD; X, Y, nWidth, nHeight: Integer;
  hWndParent: HWND; hMenu: HMENU; hInstance: HINST; lpParam: IntPtr): HWND; overload;
function DestroyWindow(hWnd: HWND): BOOL;

function  HInstance: HINST;
function  GetCurrentThreadId: DWORD;
procedure Sleep(dwMilliseconds: DWORD);
function  GetTickCount: DWORD;

procedure EnterCriticalSection(var lpCriticalSection: TRTLCriticalSection);
procedure LeaveCriticalSection(var lpCriticalSection: TRTLCriticalSection);
procedure InitializeCriticalSection(var lpCriticalSection: TRTLCriticalSection);
procedure DeleteCriticalSection(var lpCriticalSection: TRTLCriticalSection);

function  IntToStr(N : Integer) : String;
function  Trim(const S: String): String;
function  LowerCase(const S: String): String;
function  UpperCase(const S: String): String;
function  CompareText(const S1, S2 : String) : Integer;

{$ENDIF}

{$IFDEF WIN32}
const
  fmOpenRead       = SysUtils.fmOpenRead;
  fmShareDenyWrite = SysUtils.fmShareDenyWrite;
  faAnyFile        = SysUtils.faAnyFile;
  faDirectory      = SysUtils.faDirectory;
  faVolumeID       = SysUtils.faVolumeID;
  faReadOnly       = SysUtils.faReadOnly;
  faSysFile        = SysUtils.faSysFile;
  faHidden         = SysUtils.faHidden;
  opRemove         = Classes.opRemove;
  csDesigning      = Classes.csDesigning;
  csDestroying     = Classes.csDestroying;
  WM_QUIT          = Messages.WM_QUIT;
  WM_USER          = Messages.WM_USER;
  PM_REMOVE        = Windows.PM_REMOVE;
  WS_EX_TOOLWINDOW = Windows.WS_EX_TOOLWINDOW;
  WS_POPUP         = Windows.WS_POPUP;

function  IntToStr(const N : Integer) : String;
function  IntToHex(Value: Integer; Digits: Integer): String;
function  StrToInt(const S: String): Integer;
function  StrPas(const P : PChar) : String;
function  StrLen(const P : PChar) : Integer;
function  StrCopy(Dest: PChar; const Source: PChar): PChar;
function  FloatToStr(Value: Extended): String;
function  Trim(const S: String): String;
function  StrPCopy(Dest: PChar; const Source: string): PChar;
function  StrComp(const Str1, Str2 : PChar): Integer;
function  StrLComp(const Str1, Str2: PChar; MaxLen: Cardinal): Integer;
function  StrLIComp(const Str1, Str2: PChar; MaxLen: Cardinal): Integer;
function  LowerCase(const S: String): String;
function  UpperCase(const S: String): String;
function  CompareText(const S1, S2: String): Integer;
function  FileExists(const FileName: String): Boolean;
function  DeleteFile(const FileName: String): Boolean;
function  ExtractFileExt(const FileName: String): String;
function  ExtractFilePath(const FileName: String): String;
procedure DecodeDate(Date: TDateTime; var Year, Month, Day: Word);
procedure DecodeTime(Time: TDateTime; var Hour, Min, Sec, MSec: Word);
function  Format(const Fmt: String; const Args: array of const): String;
function  FindFirst(const Path: String; Attr: Integer; var F: TSearchRec): Integer;
function  FindNext(var F: TSearchRec): Integer;
procedure FindClose(var F: TSearchRec);
function  FileDateToDateTime(FileDate: Integer): TDateTime;
function  Date : TDateTime;
function  GetWindowLong(H: HWND; nIndex: Integer): Longint; stdcall;
function  DefWindowProc(H: HWND; Msg: UINT; ParamW: WPARAM; ParamL: LPARAM): LRESULT; stdcall;
function  GetCurrentThreadId: DWORD; stdcall;
function  GetMessage(var lpMsg: TMsg; H: HWND;
                     wMsgFilterMin, wMsgFilterMax: UINT): BOOL; stdcall;
function  TranslateMessage(const lpMsg: TMsg): BOOL; stdcall;
function  DispatchMessage(const lpMsg: TMsg): LongInt; stdcall;
function  PeekMessage(var lpMsg: TMsg; H: HWND;
               wMsgFilterMin, wMsgFilterMax, wRemoveMsg: UINT): BOOL; stdcall;
function  PostMessage(H: HWND; Msg: UINT; ParamW: WPARAM; ParamL: LPARAM): BOOL; stdcall;
procedure EnterCriticalSection(var lpCriticalSection: TRTLCriticalSection); stdcall;
procedure LeaveCriticalSection(var lpCriticalSection: TRTLCriticalSection); stdcall;
procedure InitializeCriticalSection(var lpCriticalSection: TRTLCriticalSection); stdcall;
procedure DeleteCriticalSection(var lpCriticalSection: TRTLCriticalSection); stdcall;
function  GetClassInfo(hInstance: HINST; lpClassName: PChar;
                       var lpWndClass: TWndClass): BOOL; stdcall;
function RegisterClass(const lpWndClass: TWndClass): ATOM; stdcall;
function UnregisterClass(lpClassName: PChar; hInstance: HINST): BOOL; stdcall;
function CreateWindowEx(dwExStyle: DWORD; lpClassName: PChar;
  lpWindowName: PChar; dwStyle: DWORD; X, Y, nWidth, nHeight: Integer;
  hWndParent: HWND; h_Menu: HMENU; hInstance: HINST; lpParam: Pointer): HWND;
function DestroyWindow(H: HWND): BOOL; stdcall;
function SetWindowLong(H: HWND; nIndex: Integer; dwNewLong: Longint): Longint; stdcall;
function LoadLibrary(lpLibFileName: PChar): HMODULE; stdcall;
function FreeLibrary(hLibModule: HMODULE): BOOL; stdcall;
function GetProcAddress(hModule: HMODULE; lpProcName: LPCSTR): FARPROC; stdcall;
function GetTickCount: DWORD; stdcall;
procedure Sleep(dwMilliseconds: DWORD); stdcall;

{$IFNDEF NOFORMS}
function Application : TApplication;
{$ENDIF}
{$ENDIF}

function MakeWord(a, b: Byte): Word;
function MakeLong(a, b: Word): Longint;
function HiWord(L: DWORD): Word;

implementation

{$IFDEF CLR}
const
    user32   = 'user32.dll';
    kernel32 = 'kernel32.dll';

[DllImport(user32, CharSet = CharSet.Auto, SetLastError = False, EntryPoint = 'DefWindowProc')]
function DefWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; external;
[DllImport(user32, CharSet = CharSet.Auto, SetLastError = True, EntryPoint = 'SetWindowLong')]
function SetWindowLong(hWnd: HWND; nIndex: Integer; dwNewLong: IntPtr): IntPtr; external;
[DllImport(user32, CharSet = CharSet.Auto, SetLastError = True, EntryPoint = 'GetWindowLong')]
function GetWindowLongIntPtr(hWnd: HWND; nIndex: Integer): IntPtr; external;
[DllImport(user32, CharSet = CharSet.Auto, SetLastError = True, EntryPoint = 'GetMessage')]
function GetMessage; external;
[DllImport(user32, CharSet = CharSet.Ansi, SetLastError = True, EntryPoint = 'TranslateMessage')]
function TranslateMessage; external;
[DllImport(user32, CharSet = CharSet.Auto, SetLastError = True, EntryPoint = 'DispatchMessage')]
function DispatchMessage; external;
[DllImport(user32, CharSet = CharSet.Auto, SetLastError = True, EntryPoint = 'PeekMessage')]
function PeekMessage; external;
[DllImport(user32, CharSet = CharSet.Auto, SetLastError = True, EntryPoint = 'PostMessage')]
function PostMessage; external;
[DllImport(user32, CharSet = CharSet.Auto, SetLastError = True, EntryPoint = 'RegisterClass')]
function RegisterClass(const lpWndClass: TWndClass): ATOM; external;
[DllImport(user32, CharSet = CharSet.Auto, SetLastError = True, EntryPoint = 'RegisterClass')]
function RegisterClass(const lpWndClassInfo: TWndClassInfo): ATOM; external;
[DllImport(user32, CharSet = CharSet.Auto, SetLastError = True, EntryPoint = 'UnregisterClass')]
function UnregisterClass; external;
[DllImport(user32, CharSet = CharSet.Auto, SetLastError = True, EntryPoint = 'GetClassInfo')]
function GetClassInfo; external;
[DllImport(user32, CharSet = CharSet.Auto, SetLastError = True, EntryPoint = 'CreateWindowEx')]
function CreateWindowEx(dwExStyle: DWORD; lpClassName: string;
  lpWindowName: string; dwStyle: DWORD; X, Y, nWidth, nHeight: Integer;
  hWndParent: HWND; hMenu: HMENU; hInstance: HINST; lpParam: IntPtr): HWND; external;
[DllImport(user32, CharSet = CharSet.Ansi, SetLastError = True, EntryPoint = 'DestroyWindow')]
function DestroyWindow; external;

[DllImport(kernel32, CharSet = CharSet.Ansi, SetLastError = True, EntryPoint = 'GetTickCount')]
function GetTickCount; external;
[DllImport(kernel32, CharSet = CharSet.Ansi, SetLastError = True, EntryPoint = 'Sleep')]
procedure Sleep; external;

function  GetCurrentThreadId: DWORD;
begin
    Result := Thread.CurrentThread.GetHashCode;
end;

function HInstance: HINST;
begin
    Result := HINST(Marshal.GetHInstance(Assembly.GetCallingAssembly.GetModules[0]));
end;

procedure EnterCriticalSection(var lpCriticalSection: TRTLCriticalSection);
begin
    Monitor.Enter(lpCriticalSection);
end;

procedure LeaveCriticalSection(var lpCriticalSection: TRTLCriticalSection);
begin
    Monitor.Exit(lpCriticalSection);
end;

procedure InitializeCriticalSection(var lpCriticalSection: TRTLCriticalSection);
begin
    lpCriticalSection := TRTLCriticalSection.Create;
end;

procedure DeleteCriticalSection(var lpCriticalSection: TRTLCriticalSection);
begin
    lpCriticalSection.Free;
end;

function TList.GetItems(Index: Integer): TObject;
begin
    Result := Item[Index];
end;

procedure TList.SetItems(Index: Integer; const Value: TObject);
begin
    Item[Index] := Value;
end;

procedure TList.Delete(Index : Integer);
begin
    RemoveAt(Index);
end;

function TList.First: TObject;
begin
    Result := Item[0];
end;

function TList.Last: TObject;
begin
    Result := Item[Count - 1];
end;

procedure TList.Pack;
begin

end;

constructor TStringList.Create;
begin
    inherited Create;
    FStrings := TList.Create;
end;

procedure TStringList.Clear;
begin
    FStrings.Clear;
end;

procedure TStringList.Add(const S: String);
begin
    FStrings.Add(S);
end;

function TStringList.Count : Integer;
begin
    Result := FStrings.Count;
end;

procedure TStringList.SetStrings(nIndex: Integer; const Value: String);
begin
    FStrings.Items[nIndex] := Value;
end;

function TStringList.GetStrings(nIndex: Integer): String;
begin
    Result := String(FStrings.Items[nIndex]);
end;

function IntToStr(N : Integer) : String;
begin
    Result := N.ToString;
end;

function Trim(const S: string): string;
begin
    Result := S.Trim;
end;

function LowerCase(const S: string): string;
begin
    Result := S.ToLower;
end;

function UpperCase(const S: string): string;
begin
    Result := S.ToUpper;
end;

function CompareText(const S1, S2 : String) : Integer;
begin
    if S1.ToUpper = S2.ToUpper then
        Result := 0
    else if S1.ToUpper < S2.ToUpper then
        Result := -1
    else
        Result := 1;
end;

{$ENDIF}

{$IFDEF WIN32}
function IntToStr(const N : Integer) : String;
begin
    Result := SysUtils.IntToStr(N);
end;

function StrToInt(const S: String): Integer;
begin
    Result := SysUtils.StrToInt(S);
end;

function StrPas(const P : PChar) : String;
begin
    Result := SysUtils.StrPas(P);
end;

function StrLen(const P : PChar) : Integer;
begin
    Result := SysUtils.StrLen(P);
end;

function StrCopy(Dest: PChar; const Source: PChar): PChar;
begin
    Result := SysUtils.StrCopy(Dest, Source);
end;

function Trim(const S: String): String;
begin
    Result := SysUtils.Trim(S);
end;

function StrPCopy(Dest: PChar; const Source: string): PChar;
begin
    Result := SysUtils.StrPCopy(Dest, Source);
end;

function StrComp(const Str1, Str2 : PChar): Integer;
begin
    Result := SysUtils.StrComp(Str1, Str2);
end;

function StrLComp(const Str1, Str2: PChar; MaxLen: Cardinal): Integer;
begin
    Result := SysUtils.StrLComp(Str1, Str2, MaxLen);
end;

function StrLIComp(const Str1, Str2: PChar; MaxLen: Cardinal): Integer;
begin
    Result := SysUtils.StrLIComp(Str1, Str2, MaxLen);
end;

function LowerCase(const S: String): String;
begin
    Result := SysUtils.LowerCase(S);
end;

function UpperCase(const S: String): String;
begin
    Result := SysUtils.UpperCase(S);
end;

function CompareText(const S1, S2: String): Integer;
begin
    Result := SysUtils.CompareText(S1, S2);
end;

function FileExists(const FileName: String): Boolean;
begin
    Result := SysUtils.FileExists(FileName);
end;

function DeleteFile(const FileName: String): Boolean;
begin
    Result := SysUtils.DeleteFile(FileName);
end;

function ExtractFileExt(const FileName: String): String;
begin
    Result := SysUtils.ExtractFileExt(FileName);
end;

procedure DecodeDate(Date: TDateTime; var Year, Month, Day: Word);
begin
    SysUtils.DecodeDate(Date, Year, Month, Day);
end;

procedure DecodeTime(Time: TDateTime; var Hour, Min, Sec, MSec: Word);
begin
    SysUtils.DecodeTime(Time, Hour, Min, Sec, MSec);
end;

function  Format(const Fmt: String; const Args: array of const): String;
begin
    Result := SysUtils.Format(Fmt, Args);
end;

function FindFirst(const Path: String; Attr: Integer; var F: TSearchRec): Integer;
begin
    Result := SysUtils.FindFirst(Path, Attr, F);
end;

function FindNext(var F: TSearchRec): Integer;
begin
    Result := SysUtils.FindNext(F);
end;

procedure FindClose(var F: TSearchRec);
begin
    SysUtils.FindClose(F);
end;

function FileDateToDateTime(FileDate: Integer): TDateTime;
begin
    Result := SysUtils.FileDateToDateTime(FileDate);
end;

function ExtractFilePath(const FileName: String): String;
begin
    Result := SysUtils.ExtractFilePath(FileName);
end;

function  Date : TDateTime;
begin
    Result := SysUtils.Date;
end;

function IntToHex(Value: Integer; Digits: Integer): String;
begin
    Result := SysUtils.IntToHex(Value, Digits);
end;

function FloatToStr(Value: Extended): String;
begin
    Result := SysUtils.FloatToStr(Value);
end;

function GetWindowLong(H: HWND; nIndex: Integer): Longint;
begin
    Result := Windows.GetWindowLong(H, nIndex);
end;

function DefWindowProc(H: HWND; Msg: UINT; ParamW: WPARAM; ParamL: LPARAM): LRESULT;
begin
    Result := Windows.DefWindowProc(H, Msg, ParamW, ParamL);
end;

function GetCurrentThreadId: DWORD;
begin
    Result := Windows.GetCurrentThreadId;
end;

function GetMessage(
    var lpMsg: TMsg; H: HWND;
    wMsgFilterMin, wMsgFilterMax: UINT): BOOL;
begin
    Result := Windows.GetMessage(lpMsg, H, wMsgFilterMin, wMsgFilterMax);
end;

function TranslateMessage(const lpMsg: TMsg): BOOL;
begin
    Result := Windows.TranslateMessage(lpMsg);
end;

function DispatchMessage(const lpMsg: TMsg): LongInt;
begin
    Result := Windows.DispatchMessage(lpMsg);
end;

function PeekMessage(
    var lpMsg: TMsg; H: HWND;
    wMsgFilterMin, wMsgFilterMax, wRemoveMsg: UINT): BOOL;
begin
    Result := Windows.PeekMessage(lpMsg, H,
                                  wMsgFilterMin, wMsgFilterMax, wRemoveMsg);
end;

function PostMessage(H: HWND; Msg: UINT; ParamW: WPARAM; ParamL: LPARAM): BOOL;
begin
    Result := Windows.PostMessage(H, Msg, ParamW, ParamL);
end;

procedure EnterCriticalSection(var lpCriticalSection: TRTLCriticalSection);
begin
    Windows.EnterCriticalSection(lpCriticalSection);
end;

procedure LeaveCriticalSection(var lpCriticalSection: TRTLCriticalSection);
begin
    Windows.LeaveCriticalSection(lpCriticalSection);
end;

procedure InitializeCriticalSection(var lpCriticalSection: TRTLCriticalSection);
begin
    Windows.InitializeCriticalSection(lpCriticalSection);
end;

procedure DeleteCriticalSection(var lpCriticalSection: TRTLCriticalSection);
begin
    Windows.DeleteCriticalSection(lpCriticalSection);
end;

function GetClassInfo(
    hInstance: HINST; lpClassName: PChar;
    var lpWndClass: TWndClass): BOOL;
begin
    Result := Windows.GetClassInfo(hInstance, lpClassName, lpWndClass);
end;

function RegisterClass(const lpWndClass: TWndClass): ATOM; stdcall;
begin
    Result := Windows.RegisterClass(lpWndClass);
end;

function CreateWindowEx(dwExStyle: DWORD; lpClassName: PChar;
  lpWindowName: PChar; dwStyle: DWORD; X, Y, nWidth, nHeight: Integer;
  hWndParent: HWND; h_Menu: HMENU; hInstance: HINST; lpParam: Pointer): HWND;
begin
    Result := Windows.CreateWindowEx(dwExStyle, lpClassName,
  lpWindowName, dwStyle, X, Y, nWidth, nHeight, hWndParent, h_Menu, hInstance,
  lpParam);
end;

function DestroyWindow(H: HWND): BOOL;
begin
    Result := Windows.DestroyWindow(H);
end;

function SetWindowLong(H: HWND; nIndex: Integer; dwNewLong: Longint): LongInt;
begin
    Result := Windows.SetWindowLong(H, nIndex, dwNewLong);
end;

function UnregisterClass(lpClassName: PChar; hInstance: HINST): BOOL;
begin
    Result := Windows.UnregisterClass(lpClassName, hInstance);
end;

function FreeLibrary(hLibModule: HMODULE): BOOL;
begin
    Result := Windows.FreeLibrary(hLibModule);
end;

function LoadLibrary(lpLibFileName: PChar): HMODULE;
begin
    Result := Windows.LoadLibrary(lpLibFileName);
end;

function GetProcAddress(hModule: HMODULE; lpProcName: LPCSTR): FARPROC;
begin
    Result := Windows.GetProcAddress(hModule, lpProcName);
end;

function GetTickCount: DWORD;
begin
    Result := Windows.GetTickCount;
end;

procedure Sleep(dwMilliseconds: DWORD);
begin
    Windows.Sleep(dwMilliseconds);
end;

{$IFNDEF NOFORMS}
function Application : TApplication;
begin
     Result := Forms.Application;
end;
{$ENDIF}
{$ENDIF}

function MakeWord(a, b: Byte): Word;
begin
    Result := A or B shl 8;
end;

function MakeLong(a, b: Word): Longint;
begin
    Result := A or B shl 16;
end;

function HiWord(L: DWORD): Word;
begin
  Result := L shr 16;
end;

end.
