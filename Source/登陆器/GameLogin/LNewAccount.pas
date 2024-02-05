unit LNewAccount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzBmpBtn, jpeg, ExtCtrls, Grobal2, HUtil32, Main, StdCtrls;

type
  TFrmNewAccount = class(TForm)
    Image: TImage;
    ButtonOK: TRzBmpButton;
    ButtonClose: TRzBmpButton;
    EditAccount: TEdit;
    EditPassword: TEdit;
    EditConfirm: TEdit;
    EditBirthDay: TEdit;
    EditQuiz1: TEdit;
    EditAnswer1: TEdit;
    EditQuiz2: TEdit;
    EditAnswer2: TEdit;
    EditEMail: TEdit;
    EditYourName: TEdit;
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
  private
    function CheckUserEntrys(): Boolean;
    function NewIdCheckBirthDay(): Boolean;
    { Private declarations }

  public
    procedure Open();
    { Public declarations }
  end;

var
  FrmNewAccount: TFrmNewAccount;
  NewIdRetryUE: TUserEntry;
  NewIdRetryAdd: TUserEntryAdd;
implementation
var
  dwOKTick: LongWord;
{$R *.dfm}

procedure TFrmNewAccount.ImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;

function TfrmNewAccount.CheckUserEntrys: Boolean;
begin
  Result := False;
  EditAccount.Text := Trim(EditAccount.Text);
  EditQuiz1.Text := Trim(EditQuiz1.Text);
  if Length(EditAccount.Text) < 3 then begin
    Application.MessageBox('登录帐号的长度必须大于3位。', '提示信息', MB_OK + MB_ICONINFORMATION);
    Beep;
    EditAccount.SetFocus;
    Exit;
  end;
  if not NewIdCheckBirthDay then Exit;
  if Length(EditPassword.Text) < 3 then begin
    EditPassword.SetFocus;
    Exit;
  end;
  if EditPassword.Text <> EditConfirm.Text then begin
    EditConfirm.SetFocus;
    Exit;
  end;

  if Length(EditQuiz1.Text) < 1 then begin
    EditQuiz1.SetFocus;
    Exit;
  end;
  if Length(EditAnswer1.Text) < 1 then begin
    EditAnswer1.SetFocus;
    Exit;
  end;
  if Length(EditQuiz2.Text) < 1 then begin
    EditQuiz2.SetFocus;
    Exit;
  end;
  if Length(EditAnswer2.Text) < 1 then begin
    EditAnswer2.SetFocus;
    Exit;
  end;
  Result := True;
end;

function TfrmNewAccount.NewIdCheckBirthDay: Boolean;
var
  Str, t1, t2, t3, syear, smon, sday: string;
  ayear, amon, aday, sex: Integer;
  flag: Boolean;
begin
  Result := True;
  flag := True;
  Str := EditBirthDay.Text;
  Str := GetValidStr3(Str, syear, ['/']);
  Str := GetValidStr3(Str, smon, ['/']);
  Str := GetValidStr3(Str, sday, ['/']);
  ayear := Str_ToInt(syear, 0);
  amon := Str_ToInt(smon, 0);
  aday := Str_ToInt(sday, 0);
  if (ayear <= 1890) or (ayear > 2101) then flag := False;
  if (amon <= 0) or (amon > 12) then flag := False;
  if (aday <= 0) or (aday > 31) then flag := False;
  if not flag then begin
    Beep;
    EditBirthDay.SetFocus;
    Result := False;
  end;
end;

procedure TfrmNewAccount.Open;
begin
  ButtonOK.Enabled := True;
  EditAccount.Text := '';
  EditPassword.Text := '';
  EditConfirm.Text := '';
  EditYourName.Text := '';
  EditBirthDay.Text := '';
  EditQuiz1.Text := '';
  EditAnswer1.Text := '';
  EditQuiz2.Text := '';
  EditAnswer2.Text := '';
  EditEMail.Text := '';
  //EditAccount.SetFocus;
  ShowModal;
end;

procedure TFrmNewAccount.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmNewAccount.ButtonOKClick(Sender: TObject);
var
  ue: TUserEntry;
  ua: TUserEntryAdd;
  nRandomCode: Integer;
begin
  if GetTickCount - dwOKTick < 5000 then begin
    Application.MessageBox('请稍候再点确定！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  if CheckUserEntrys then begin
    FillChar(ue, SizeOf(TUserEntry), #0);
    FillChar(ua, SizeOf(TUserEntryAdd), #0);
    ue.sAccount := LowerCase(EditAccount.Text);
    ue.sPassword := EditPassword.Text;
    ue.sUserName := EditYourName.Text;
    ue.sSSNo := '650101-1455111';
    ue.sQuiz := EditQuiz1.Text;
    ue.sAnswer := Trim(EditAnswer1.Text);
    ue.sPhone := '';
    //ue.sPhone := EditPhone.Text;
    ue.sEMail := Trim(EditEMail.Text);
    ua.sQuiz2 := EditQuiz2.Text;
    ua.sAnswer2 := Trim(EditAnswer2.Text);
    ua.sBirthDay := EditBirthDay.Text;
    //ua.sMobilePhone := EditMobPhone.Text;
    ua.sMobilePhone := '';
    NewIdRetryUE := ue;
    NewIdRetryUE.sAccount := '';
    NewIdRetryUE.sPassword := '';
    NewIdRetryAdd := ua;
    nRandomCode := 0;//Str_ToInt(Trim(EditRandomCode.Text), 0);
    frmMain.SendUpdateAccount(ue, ua, nRandomCode);
    ButtonOK.Enabled := False;
    dwOKTick := GetTickCount();
  end;
end;

end.

