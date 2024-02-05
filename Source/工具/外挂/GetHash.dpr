program GetHash;

uses
  Forms,
  HashMain in 'HashMain.pas' {FrmMain},
  EncryptUnit in '..\..\Common\EncryptUnit.pas',
  MD5EncodeStr in '..\..\Common\MD5EncodeStr.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
