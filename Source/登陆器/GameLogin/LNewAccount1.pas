unit LNewAccount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grobal2, RzButton, Main,Mask;

type
  TfrmNewAccount = class(TForm)
    Label14: TLabel;
    LabelStatus: TLabel;
    GroupBox: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label16: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label7: TLabel;
    Label13: TLabel;
    EditAccount: TEdit;
    EditPassword: TEdit;
    EditConfirm: TEdit;
    EditYourName: TEdit;
    EditBirthDay: TEdit;
    EditRandomCode: TEdit;
    EditQuiz1: TEdit;
    EditAnswer1: TEdit;
    EditQuiz2: TEdit;
    EditAnswer2: TEdit;
    EditEMail: TEdit;
    LabelRandomCode: TLabel;
    MemoHelp: TMemo;
    Label11: TLabel;
    Label12: TLabel;
    Label15: TLabel;
    EditPhone: TEdit;
    EditMobPhone: TEdit;
    ButtonOK: TButton;
    procedure EditEnter(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormPaint(Sender: TObject);
  private
    function CheckUserEntrys(): Boolean;
    function NewIdCheckBirthDay(): Boolean;
    { Private declarations }

  public
    procedure Open();
    { Public declarations }
  end;

var
  frmNewAccount: TfrmNewAccount;
  NewIdRetryUE: TUserEntry;
  NewIdRetryAdd: TUserEntryAdd;
implementation

uses HUtil32, GameShare;
var
  dwOKTick: LongWord;

{$R *.dfm}

function TfrmNewAccount.CheckUserEntrys: Boolean;
begin
  Result := False;
  EditAccount.Text := Trim(EditAccount.Text);
  EditQuiz1.Text := Trim(EditQuiz1.Text);
  EditYourName.Text := Trim(EditYourName.Text);
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
  if not IsStringNumber(EditRandomCode.Text) then begin
    EditRandomCode.SetFocus;
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
  if Length(EditYourName.Text) < 1 then begin
    EditYourName.SetFocus;
    Exit;
  end;
  Result := True;
end;

procedure TfrmNewAccount.EditEnter(Sender: TObject);
begin
  if Sender = EditAccount then begin
    MemoHelp.Clear;
    MemoHelp.Lines.Add('您的帐号名称可以包括：');
    MemoHelp.Lines.Add('字符、数字的组合。');
    MemoHelp.Lines.Add('帐号名称长度必须为4或以上。');
    MemoHelp.Lines.Add('登陆帐号并游戏中的人物名称。');
    MemoHelp.Lines.Add('请仔细输入创建帐号所需信息。');
    MemoHelp.Lines.Add('您的登陆帐号可以登陆游戏');
    MemoHelp.Lines.Add('及我们网站，以取得一些相关信息。');
    MemoHelp.Lines.Add('');
    MemoHelp.Lines.Add('建议您的登陆帐号不要与游戏中的角');
    MemoHelp.Lines.Add('色名相同，');
    MemoHelp.Lines.Add('以确保你的密码不会被爆力破解。');
    Exit;
  end;
  if Sender = EditPassword then begin
    MemoHelp.Clear;
    MemoHelp.Lines.Add('您的密码可以是字符及数字的组合，');
    MemoHelp.Lines.Add('但密码长度必须至少4位。');
    MemoHelp.Lines.Add('建议您的密码内容不要过于简单，');
    MemoHelp.Lines.Add('以防被人猜到。');
    MemoHelp.Lines.Add('请记住您输入的密码，如果丢失密码');
    MemoHelp.Lines.Add('将无法登录游戏。');
  end;
  if Sender = EditConfirm then begin
    MemoHelp.Clear;
    MemoHelp.Lines.Add('再次输入密码');
    MemoHelp.Lines.Add('以确认。');
  end;
  if Sender = EditYourName then begin
    MemoHelp.Clear;
    MemoHelp.Lines.Add('请输入您的全名.');
  end;
 { if Sender = EditSSNo then begin
    MemoHelp.Clear;
    MemoHelp.Lines.Add('请输入你的身份证号');
    MemoHelp.Lines.Add('例如： 720101-146720');
  end; }
  if Sender = EditBirthDay then begin
    MemoHelp.Clear;
    MemoHelp.Lines.Add('请输入您的生日');
    MemoHelp.Lines.Add('例如：1977/10/15');
  end;
  if Sender = EditQuiz1 then begin
    MemoHelp.Clear;
    MemoHelp.Lines.Add('请输入第一个密码提示问题');
    MemoHelp.Lines.Add('这个提示将用于密码丢失后找');
    MemoHelp.Lines.Add('回密码用。');
    MemoHelp.Lines.Add('');
  end;
  if Sender = EditAnswer1 then begin
    MemoHelp.Clear;
    MemoHelp.Lines.Add('请输入上面问题的');
    MemoHelp.Lines.Add('答案。');
    MemoHelp.Lines.Add('');
  end;
  if Sender = EditQuiz2 then begin
    MemoHelp.Clear;
    MemoHelp.Lines.Add('请输入第二个密码提示问题');
    MemoHelp.Lines.Add('这个提示将用于密码丢失后找');
    MemoHelp.Lines.Add('回密码用。');
    MemoHelp.Lines.Add('');
  end;
  if Sender = EditAnswer2 then begin
    MemoHelp.Clear;
    MemoHelp.Lines.Add('请输入上面问题的');
    MemoHelp.Lines.Add('答案。');
    MemoHelp.Lines.Add('');
  end;
  if Sender = EditPhone then begin
    MemoHelp.Clear;
    MemoHelp.Lines.Add('请输入您的电话');
    MemoHelp.Lines.Add('号码。');
    MemoHelp.Lines.Add('');
  end;
  if Sender = EditMobPhone then begin
    MemoHelp.Clear;
    MemoHelp.Lines.Add('请输入您的手机号码。');
    MemoHelp.Lines.Add('');
  end;
  if Sender = EditEMail then begin
    MemoHelp.Clear;
    MemoHelp.Lines.Add('请输入您的邮件地址。您的邮件将被');
    MemoHelp.Lines.Add('接收最近更新的一些信息');
    MemoHelp.Lines.Add('');
  end;
  if Sender = EditRandomCode then begin
    MemoHelp.Clear;
    MemoHelp.Lines.Add('请输入右边的验证码');
    MemoHelp.Lines.Add('');
  end;
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

procedure TfrmNewAccount.ButtonOKClick(Sender: TObject);
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
    ue.sPhone := EditPhone.Text;
    ue.sEMail := Trim(EditEMail.Text);
    ua.sQuiz2 := EditQuiz2.Text;
    ua.sAnswer2 := Trim(EditAnswer2.Text);
    ua.sBirthDay := EditBirthDay.Text;
    ua.sMobilePhone := EditMobPhone.Text;
    NewIdRetryUE := ue;
    NewIdRetryUE.sAccount := '';
    NewIdRetryUE.sPassword := '';
    NewIdRetryAdd := ua;
    nRandomCode := Str_ToInt(Trim(EditRandomCode.Text), 0);
    frmMain.SendUpdateAccount(ue, ua, nRandomCode);
    ButtonOK.Enabled := False;
    dwOKTick := GetTickCount();
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
  EditPhone.Text := '';
  EditMobPhone.Text := '';
  EditRandomCode.Text := '';
  OnPaint := FormPaint;
  //LabelRandomCode.Caption := g_sRandomCode;
  ShowModal;
end;

procedure TfrmNewAccount.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  g_sRandomCode := '0';
end;

procedure TfrmNewAccount.FormPaint(Sender: TObject);
begin
  frmMain.Image.Refresh;
end;

end.
