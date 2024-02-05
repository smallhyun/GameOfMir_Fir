unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFrmMain = class(TForm)
    ButtonStart: TButton;
    Memo: TMemo;
    Timer: TTimer;
    procedure ButtonStartClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;
  ForegroundWindow: THandle;
implementation

{$R *.dfm}

function GetWinClassName(Handle: HWND): string;
begin
  SetLength(Result, 256);
  SetLength(Result, GetClassName(Handle, PChar(Result), 256));
end;

function GetWinTitle(Handle: HWND): string;
begin
  SetLength(Result, 256);
  SetLength(Result, GetWindowText(Handle, PChar(Result), 256));
end;

function EnumChildWindowProc(HWND: HWND; lParam: LPARAM): BOOL; stdcall;
var
  sTitle: string;
begin
  // 枚举子窗口回调函数
  Result := True;
  sTitle := GetWinTitle(HWND);
  if sTitle <> '' then begin
    FrmMain.Memo.Lines.Add(sTitle);
  end;
  EnumChildWindows(HWND, @EnumChildWindowProc, lParam); // 递归枚举子窗口
end;


function EnumWindowsProc(HWND: HWND; lParam: LPARAM): BOOL; stdcall;
begin
  // 枚举所有顶层窗口
  if ForegroundWindow = HWND then begin
    Result := False;
    FrmMain.Memo.Lines.Add('-------------------------------------窗口标题----------------------------------------');
    FrmMain.Memo.Lines.Add( GetWinTitle(HWND));
    FrmMain.Memo.Lines.Add('-------------------------以下是检测名称，可以选择一个或多个--------------------------');
  //Form1.Memo1.Lines.Add('EnumWindowsProc: ' + GetWinTitle(HWND));
    EnumChildWindows(HWND, @EnumChildWindowProc, lParam); // 枚举所有子窗口
  end else Result := True;
end;

procedure TFrmMain.ButtonStartClick(Sender: TObject);
begin
  ButtonStart.Enabled := False;
  Timer.Enabled := True;
end;

procedure TFrmMain.TimerTimer(Sender: TObject);
var
  nHandle: HWND;
begin
  ForegroundWindow := GetForegroundWindow;
  if ForegroundWindow <> Handle then begin
    Timer.Enabled := False;
    Memo.Lines.Clear;
    EnumWindows(@EnumWindowsProc, 0);
    ButtonStart.Enabled := True;
  end;
end;

end.

