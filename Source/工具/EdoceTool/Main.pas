unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TEngineOption = record
    Mode: PInteger;
    UserLicense: PInteger;
    Version: PInteger;
  end;
  pTEngineOption = ^TEngineOption;

  TfrmMain = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Button3: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Button4: TButton;
    Edit3: TEdit;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation
uses EncryptUnit; //EncryptUnit EDcode
{$R *.dfm}

procedure TfrmMain.Button1Click(Sender: TObject);
var
  s1, s2: string;
begin
  s1 := Trim(Edit1.Text);
  if RadioButton2.Checked then begin
    s2 := EncryptString(s1);
  end else begin
    s2 := EncodeString(s1);
  end;
  Edit2.Text := s2;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var
  s1, s2: string;
begin
  s1 := Trim(Edit2.Text);
  if RadioButton2.Checked then begin
    s2 := DecryptString(s1);
  end else begin
    s2 := DeCodeString(s1);
  end;
  Edit1.Text := s2;
end;

procedure TfrmMain.Button3Click(Sender: TObject);
const
  B64: array[0..63] of byte = (65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80,
    81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108,
    109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 48, 49, 50, 51, 52, 53,
    54, 55, 56, 57, 43, 47);

var
  I: Integer;
  dwTick: LongWord;
  Str: string;
  P: PChar;
begin
  SetLength(Str, 100000);
  P := PChar(Str);
  for I := 1 to 100000 - 1 do begin
    P^ := Chr(B64[Random(63)]);
    Inc(P);
  end;
  dwTick := GetTickCount;
  Str := EncryptString(Str);
  //Edit2.Text:=_EncryptString(Str);
  Showmessage(IntToStr(GetTickCount - dwTick));

end;

procedure TfrmMain.Button4Click(Sender: TObject);
begin
  Edit3.Text := IntToStr(HashPJW(Edit2.Text));
end;

procedure TfrmMain.Button5Click(Sender: TObject);
var
  s1, s2: string;
  I: Integer;
begin
  for I := 1 to 10000 do begin
    s1 := Trim(Edit1.Text);
    s2 := EncryptString(s1);
    Edit2.Text := s2;
    s2 := Trim(Edit2.Text);
    Edit1.Text := DecryptString(s2);
  end;
end;

end.

