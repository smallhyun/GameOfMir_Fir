unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, StdCtrls, ExtCtrls, CShare, ComCtrls,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    ButtonStart: TButton;
    ButtonStop: TButton;
    ComboBoxShowOption: TComboBox;
    ProgressBar: TProgressBar;
    Panel: TPanel;
    IdHTTPDownLoad: TIdHTTP;
    Timer1: TTimer;
    Timer: TTimer;
    TimerStart: TTimer;
    Memo1: TMemo;
    procedure TimerTimer(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  FHandle: Integer;
  FormData: pTFormData;
implementation

{$R *.dfm}

procedure TForm1.TimerTimer(Sender: TObject);
var
  MainHwnd: HWnd;
  FileHandle: THandle;
  Module: THandle;
  dwProcessID: DWORD;
  sTitle: string;
  pTitle: array[0..120] of CHAR;
begin
  MainHwnd := GetForegroundWindow;
  GetWindowText(MainHwnd, @pTitle, 120);
  sTitle := StrPas(@pTitle);
  Module := FindWindowEx(MainHwnd, 0, PChar('TDXDraw'), nil);

  Memo1.Lines.Add(sTitle + ' MainHwnd:' + IntToStr(MainHwnd) + ' TDXDraw:' + IntToStr(Module));
end;

procedure TForm1.ButtonStartClick(Sender: TObject);
begin
  Timer.Enabled := not Timer.Enabled;
end;

initialization
  begin
    g_DataEngine := TDataEngine.Create;
    FHandle := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0, SizeOf(TFormData), 'FORMDATA');
    if FHandle = 0 then
      if GetLastError = ERROR_ALREADY_EXISTS then
      begin
        FHandle := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, 'FORMDATA');
        if FHandle = 0 then Exit;
      end else Exit;
    g_Data := MapViewOfFile(FHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
    if g_Data = nil then CloseHandle(FHandle);
    g_DataEngine.data := g_Data;
    if g_Data.Initialized then begin
      g_DataEngine.Initialize;
    end;
  end;
finalization
  begin
    g_DataEngine.Free;
    if FormData <> nil then begin
      UnmapViewOfFile(FormData);
      CloseHandle(FHandle);
    end;
  end;

end.

