program IP;

uses
  Forms,
  IPMain in 'IPMain.pas' {frmIP};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmIP, frmIP);
  Application.Run;
end.
