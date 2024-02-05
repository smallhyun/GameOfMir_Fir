program MakeGameLogin;

uses
  FastMM4,
  Forms,
  Main in 'Main.pas' {frmMain},
  HUtil32 in '..\..\..\Common\HUtil32.pas',
  EncryptUnit in '..\..\..\Common\EncryptUnit.pas',
  Share in 'Share.pas',
  GameLogin in 'GameLogin.pas' {FrmGameLogin},
  LoadFromDB in 'LoadFromDB.pas' {FrmLoadFromDB},
  Objects in 'Objects.pas' {ObjectsDlg};

{$R *.res}

begin
  Application.Initialize;
  //Application.MainFormOnTaskBar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TFrmLoadFromDB, FrmLoadFromDB);
  Application.CreateForm(TFrmGameLogin, FrmGameLogin);
  Application.CreateForm(TObjectsDlg, ObjectsDlg);
  Application.Run;
end.

