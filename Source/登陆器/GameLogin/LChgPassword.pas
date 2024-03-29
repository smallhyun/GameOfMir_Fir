unit LChgPassword;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzButton, Mask, RzBmpBtn, jpeg, ExtCtrls;

type
  TfrmChangePassword = class(TForm)
    LabelStatus: TLabel;
    Image: TImage;
    EditAccount: TEdit;
    EditPassword: TEdit;
    EditNewPassword: TEdit;
    EditConfirm: TEdit;
    ButtonClose: TRzBmpButton;
    ButtonOK: TRzBmpButton;
    procedure ButtonOKClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ButtonCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmChangePassword: TfrmChangePassword;

implementation

uses Main;
var
  dwOKTick: LongWord;
{$R *.dfm}

{ TfrmChangePassword }

procedure TfrmChangePassword.Open;
begin
  ButtonOK.Enabled := True;
  EditAccount.Text := '';
  EditPassword.Text := '';
  EditNewPassword.Text := '';
  EditConfirm.Text := '';
  OnPaint := FormPaint;
  ShowModal;
end;

procedure TfrmChangePassword.ButtonOKClick(Sender: TObject);
var
  uid, passwd, newpasswd: string;
begin
  if GetTickCount - dwOKTick < 5000 then begin
    Application.MessageBox('请稍候再点确定！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  uid := Trim(EditAccount.Text);
  passwd := Trim(EditPassword.Text);
  newpasswd := Trim(EditNewPassword.Text);
  if uid = '' then begin
    Application.MessageBox('登录帐号输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditAccount.SetFocus;
    Exit;
  end;
  if passwd = '' then begin
    Application.MessageBox('旧密码输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditPassword.SetFocus;
    Exit;
  end;
  if Length(newpasswd) < 4 then begin
    Application.MessageBox('新密码位数小于四位！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditAccount.SetFocus;
    Exit;
  end;
  if newpasswd = '' then begin
    Application.MessageBox('新密码输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditNewPassword.SetFocus;
    Exit;
  end;
  if EditNewPassword.Text = EditConfirm.Text then begin
    frmMain.SendChgPw(uid, passwd, newpasswd);
    dwOKTick := GetTickCount();
    ButtonOK.Enabled := False;
  end else begin
    Application.MessageBox('二次输入的密码不匹配！！！。', '提示信息', MB_OK);
    EditNewPassword.SetFocus;
  end;
end;

procedure TfrmChangePassword.FormPaint(Sender: TObject);
begin
  frmMain.Image.Refresh;
end;

procedure TfrmChangePassword.ImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;

procedure TfrmChangePassword.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

end.
