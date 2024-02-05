unit Internet;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw;
type
  TInternet_Server = class(TWebBrowser)

  end;
  procedure Register;
implementation
procedure Register;
begin
  RegisterComponents('Internet', [TInternet_Server]);
end;

end.
