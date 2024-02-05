program MakePlayer;

uses
  Forms,
  Main in 'Main.pas' {FrmMain},
  ClientObject in 'ClientObject.pas',
  Share in 'Share.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.

