program ThrdSrvV3;

uses
  Forms,
  ThrdSrvV3_1 in 'ThrdSrvV3_1.pas' {ThrdSrvForm};

{$R *.RES}

begin
  Application.CreateForm(TThrdSrvForm, ThrdSrvForm);
  Application.Run;
end.
