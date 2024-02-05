unit Share;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, HUtil32, SDK;
var
  g_MainLogMsgList: TGStringList;
  g_boShowLogMsg: Boolean = True;
procedure MainOutMessage(Msg: string);
implementation

procedure MainOutMessage(Msg: string);
begin
  if g_boShowLogMsg then begin
    g_MainLogMsgList.Lock;
    try
      g_MainLogMsgList.Add(DateTimeToStr(Now) + ' ' + Msg);
    finally
      g_MainLogMsgList.UnLock;
    end;
  end;
end;

initialization
  begin
    g_MainLogMsgList := TGStringList.Create;
  end;

finalization
  begin
    g_MainLogMsgList.Free;
  end;

end.

