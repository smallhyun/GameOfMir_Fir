program Project2;

uses
  Forms,
  Unit2 in 'Unit2.pas' {Form1},
  CShare in 'CShare.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
