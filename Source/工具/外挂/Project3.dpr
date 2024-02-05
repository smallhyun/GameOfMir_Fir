program Project3;

uses
  Forms,
  Unit3 in 'Unit3.pas' {Form1},
  Unit4 in 'Unit4.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
