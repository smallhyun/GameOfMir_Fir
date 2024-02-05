unit HashMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EncryptUnit,MD5EncodeStr, StdCtrls, Mask, RzEdit, RzBtnEdt;

type
  TFrmMain = class(TForm)
    Edit1: TEdit;
    RzButtonEdit1: TRzButtonEdit;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    Edit3: TEdit;
    Button2: TButton;
    Edit4: TEdit;
    procedure RzButtonEdit1ButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

procedure TFrmMain.Button1Click(Sender: TObject);
var
  List: TStringList;
  sFileName:string;
  sMD5:string;
begin
  sFileName:=RzButtonEdit1.Text;
  if not FileExists(sFileName) then begin
    Application.MessageBox(PChar('没有发现' + sFileName + ' ！！！'), '提示信息', MB_ICONQUESTION);
    RzButtonEdit1.SetFocus;
    Exit;
  end;
  sMD5:=RivestFile(sFileName);
  Edit2.Text := sMD5;
  List := TStringList.Create;
  List.LoadFromFile(sFileName);
  //Showmessage(List.Text);
  Edit1.Text := IntToStr(HashPJW(List.Text));
  //Edit1.Text := IntToStr(CalcBufferCRC(PChar(List.Text),Length(List.Text)));
  //Edit2.Text := RivestStr(List.Text);
  List.Free;


end;

procedure TFrmMain.Button2Click(Sender: TObject);
begin
  Edit4.Text := IntToStr(HashPJW(Edit3.Text));
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  RzButtonEdit1.Text := ExtractFilePath(Application.ExeName) + 'CqFirSupPort.txt';
end;

procedure TFrmMain.RzButtonEdit1ButtonClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    RzButtonEdit1.Text := OpenDialog1.FileName;
end;

end.

