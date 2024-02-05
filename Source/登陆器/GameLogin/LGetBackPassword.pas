unit LGetBackPassword;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzButton,Mask, RzBmpBtn, jpeg, ExtCtrls;

type
  TfrmGetBackPassword = class(TForm)
    LabelStatus: TLabel;
    Image: TImage;
    EditAccount: TEdit;
    EditBirthDay: TEdit;
    EditPassword: TEdit;
    EditQuiz1: TEdit;
    EditAnswer1: TEdit;
    EditQuiz2: TEdit;
    EditAnswer2: TEdit;
    ButtonOK: TRzBmpButton;
    ButtonClose: TRzBmpButton;
    procedure ButtonOKClick(Sender: TObject);
    procedure Open();
    procedure FormPaint(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public

    { Public declarations }
  end;

var
  frmGetBackPassword: TfrmGetBackPassword;

implementation

uses Main;
var
  dwOKTick: LongWord;
{$R *.dfm}

{ TfrmGetBackPassword }

procedure TfrmGetBackPassword.Open();
begin
  ButtonOK.Enabled := True;
  EditPassword.Text := '';
  EditAccount.Text := '';
  EditQuiz1.Text := '';
  EditAnswer1.Text := '';
  EditQuiz2.Text := '';
  EditAnswer2.Text := '';
  EditBirthDay.Text := '';
  OnPaint := FormPaint;
  ShowModal;
end;
procedure TfrmGetBackPassword.ButtonOKClick(Sender: TObject);
var
  sAccount, sQuest1, sAnswer1, sQuest2, sAnswer2, sBirthDay: string;
begin
  if GetTickCount - dwOKTick < 10000 then begin
    Application.MessageBox('请稍候10秒后再点确定！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  dwOKTick := GetTickCount();
  sAccount := Trim(EditAccount.Text);
  sQuest1 := Trim(EditQuiz1.Text);
  sAnswer1 := Trim(EditAnswer1.Text);
  sQuest2 := Trim(EditQuiz2.Text);
  sAnswer2 := Trim(EditAnswer2.Text);
  sBirthDay := Trim(EditBirthDay.Text);
  if sAccount = '' then begin
    Application.MessageBox('帐号输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditAccount.SetFocus;
    Exit;
  end;
  if (sQuest1 = '') and (sAnswer1 = '') and (sQuest2 = '') and (sAnswer2 = '') then begin
    Application.MessageBox('密码问答输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  if (sQuest1 = '') and (sAnswer1 = '') and (sQuest2 = '') and (sAnswer2 = '') then begin
    Application.MessageBox('密码问答输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  if (sBirthDay = '') then begin
    Application.MessageBox('出生日期输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditBirthDay.SetFocus;
    Exit;
  end;

  if sQuest1 = '' then sQuest1 := 'test';
  if sAnswer1 = '' then sAnswer1 := 'test';
  if sQuest2 = '' then sQuest2 := 'test';
  if sAnswer2 = '' then sAnswer2 := 'test';

  frmMain.SendGetBackPassword(sAccount, sQuest1, sAnswer1, sQuest2, sAnswer2, sBirthDay);
  ButtonOK.Enabled := False;
end;

procedure TfrmGetBackPassword.FormPaint(Sender: TObject);
begin
  frmMain.Image.Refresh;
end;

procedure TfrmGetBackPassword.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmGetBackPassword.ImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;

end.
