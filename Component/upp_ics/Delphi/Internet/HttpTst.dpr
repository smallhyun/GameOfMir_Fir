program HttpTst;

uses
  Forms,
  HttpTst1 in 'HttpTst1.pas' {HttpTestForm};

{$R *.RES}

begin
{$IFNDEF VER80}
  Application.CreateForm(THttpTestForm, HttpTestForm);
  {$ENDIF}
  Application.Run;
end.
