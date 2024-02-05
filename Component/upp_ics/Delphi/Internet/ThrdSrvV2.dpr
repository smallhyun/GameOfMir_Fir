program ThrdSrvV2;

uses
  Forms,
  ThrdSrvV2_1 in 'ThrdSrvV2_1.pas' {TcpSrvForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TTcpSrvForm, TcpSrvForm);
  Application.Run;
end.
