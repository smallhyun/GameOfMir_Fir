unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, OleCtrls, SHDocVw, EmbeddedWB, ComCtrls, CShare;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    ButtonStart: TButton;
    ButtonStop: TButton;
    Panel: TPanel;
    ComboBoxShowOption: TComboBox;
    EmbeddedWB1: TEmbeddedWB;
    ProgressBar: TProgressBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  FHandle :Integer;
  FormData : pTFormData;
implementation

{$R *.dfm}
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
