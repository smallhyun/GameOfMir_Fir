program GetSerialNumber;

uses
  Forms,
  snMain in 'snMain.pas' {FrmMain},
  EncryptUnit in '..\..\Common\EncryptUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  //Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
