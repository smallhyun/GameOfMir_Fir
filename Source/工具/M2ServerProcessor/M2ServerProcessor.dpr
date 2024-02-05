program M2ServerProcessor;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  SDK in '..\..\Common\SDK.pas',
  Common in '..\..\Common\Common.pas',
  Grobal2 in '..\..\Common\Grobal2.pas',
  HUtil32 in '..\..\Common\HUtil32.pas',
  EncryptUnit in '..\..\Common\EncryptUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  //Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
