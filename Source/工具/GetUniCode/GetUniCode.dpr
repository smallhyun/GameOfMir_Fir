program GetUniCode;

uses
  Forms,
  Main in 'Main.pas' {FrmGetUniCode},
  EncryptUnit in '..\..\Common\EncryptUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmGetUniCode, FrmGetUniCode);
  Application.Run;
end.
