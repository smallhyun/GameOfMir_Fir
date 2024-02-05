program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  CShare in 'CShare.pas',
  EncryptUnit in '..\..\Common\EncryptUnit.pas',
  IECache in '..\..\Component\EmbeddedWB_D2005\IECache.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
