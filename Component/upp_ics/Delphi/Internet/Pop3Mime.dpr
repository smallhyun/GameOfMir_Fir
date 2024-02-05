program Pop3Mime;

uses
  Forms,
  POP3MIM1 in 'POP3MIM1.PAS' {MimeDecodeForm};

{$R *.RES}

begin
  Application.CreateForm(TMimeDecodeForm, MimeDecodeForm);
  Application.Run;
end.
