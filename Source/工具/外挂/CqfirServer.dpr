program CqfirServer;

uses
  Forms,
  Cqfir in 'Cqfir.pas' {FrmMain},
  SShare in 'SShare.pas',
  CShare in 'CShare.pas',
  Grobal2 in '..\..\Common\Grobal2.pas',
  SDK in '..\..\Common\SDK.pas',
  UserManage in 'UserManage.pas' {frmUserManage},
  HUtil32 in '..\..\Common\HUtil32.pas',
  EncryptUnit in '..\..\Common\EncryptUnit.pas',
  QQWry in 'QQWry.pas';

{$R *.res}

begin
  Application.Initialize;
  //Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TfrmUserManage, frmUserManage);
  Application.Run;
end.
