program MakeCqfir;

uses
  Forms,
  MakeMain in 'MakeMain.pas' {FrmMain},
  HUtil32 in '..\..\Common\HUtil32.pas',
  CShare in 'CShare.pas',
  EncryptUnit in '..\..\Common\EncryptUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  //Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
