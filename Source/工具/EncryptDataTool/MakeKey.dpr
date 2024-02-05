program MakeKey;

uses
  Forms,
  MakeKeyUnitl in 'MakeKeyUnitl.pas' {FrmMakeKey},
  PlugShare in 'PlugShare.pas',
  EncryptUnit in '..\..\Common\EncryptUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMakeKey, FrmMakeKey);
  Application.Run;
end.
