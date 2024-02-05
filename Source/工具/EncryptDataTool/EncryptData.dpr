program EncryptData;

uses
  Forms,
  Main in 'Main.pas' {FrmMain},
  CompressUnit in '..\..\Common\CompressUnit.pas',
  ZLibEx in '..\..\Common\ZLibEx.pas',
  uDragFromShell in '..\..\Common\uDragFromShell.pas',
  PlugShare in 'PlugShare.pas',
  EncryptUnit in '..\..\Common\EncryptUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
