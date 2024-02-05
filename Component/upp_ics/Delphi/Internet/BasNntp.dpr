program BasNntp;

uses
  Forms,
  BasNntp1 in 'BasNntp1.pas' {BasicNntpForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TBasicNntpForm, BasicNntpForm);
  Application.Run;
end.
