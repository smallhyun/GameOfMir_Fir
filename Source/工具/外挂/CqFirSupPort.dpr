program CqFirSupPort;

uses
  FastMM4,
  Forms,
  Main in 'Main.pas' {FrmMain},
  HUtil32 in '..\..\Common\HUtil32.pas',
  MD5EncodeStr in '..\..\Common\MD5EncodeStr.pas',
  CShare in 'CShare.pas',
  IECache in '..\..\Component\EmbeddedWB_D2005\IECache.pas';

{$R *.res}

begin
  if not RestoreIfRunning(Application.Handle) then begin
    Application.Initialize;
    //Application.MainFormOnTaskbar := True;
    Application.CreateForm(TFrmMain, FrmMain);
    Application.Run;
  end;
end.

