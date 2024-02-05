program EDoceTool;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  EncryptUnit in '..\..\Common\EncryptUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
