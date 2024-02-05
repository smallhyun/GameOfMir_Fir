program EDcodeData;

uses
  Forms,
  Main in 'Main.pas' {FrmMain},
  EncryptUnit in '..\..\..\Common\EncryptUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
