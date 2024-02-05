program GameLogin;

uses
  FastMM4,
  Windows,
  Messages,
  Forms,
  Main in 'Main.pas' {frmMain},
  Grobal2 in '..\..\Common\Grobal2.pas',
  HUtil32 in '..\..\Common\HUtil32.pas',
  LNewAccount in 'LNewAccount.pas' {frmNewAccount},
  LChgPassword in 'LChgPassword.pas' {frmChangePassword},
  LGetBackPassword in 'LGetBackPassword.pas' {frmGetBackPassword},
  GameShare in 'GameShare.pas',
  LEditGame in 'LEditGame.pas' {frmEditGame},
  LUpgrade in 'LUpgrade.pas' {frmUpgradeDownload},
  MD5EncodeStr in '..\..\Common\MD5EncodeStr.pas',
  CheckPrevious in 'CheckPrevious.pas',
  EncryptUnit in '..\..\Common\EncryptUnit.pas',
  GameImages in '..\..\工具\ImageViewer\GameImages.pas',
  MirShare in '..\..\工具\ImageViewer\MirShare.pas',
  dlltools in '..\..\Common\dlltools.pas';

{$R *.res}

begin
  if not CheckPrevious.RestoreIfRunning(Application.Handle, 1) then begin
    Application.Initialize;
    Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmNewAccount, frmNewAccount);
  Application.CreateForm(TfrmChangePassword, frmChangePassword);
  Application.CreateForm(TfrmGetBackPassword, frmGetBackPassword);
  Application.Run;
  end;
end.

