unit WelCome;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, StdCtrls, ComCtrls, ExtCtrls;

type
  TWebPanel = class(TPanel)
  public
    WebBrowser: TWebBrowser;
  end;

  TfrmWelCome = class(TForm)
    Timer: TTimer;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    nOldX: Integer;
    nOldY: Integer;
    function NewWebBrowser: TWebPanel;
    procedure WebBrowserNewWindow2(Sender: TObject;
      var ppDisp: IDispatch; var Cancel: WordBool);
  public
    procedure Navigate(const sUrl: string);
    procedure Open(); overload;
    procedure Open(sHomePage: string); overload;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WmNCHitTest(var Msg: TWMNCHitTest); message wm_NcHitTest;
  end;


var
  frmWelCome: TfrmWelCome;
  g_sUrl: string;
implementation
uses PlugCommon;
{$R *.dfm}
var
  WebBrowsers: array of TWebPanel;

procedure TfrmWelCome.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  //Params.Style := Params.Style xor ws_caption xor ws_popup;
  Params.Style := WS_THICKFRAME or WS_TILEDWINDOW { or WS_POPUP or WS_BORDER};
end;

procedure TfrmWelCome.WmNCHitTest(var Msg: TWMNCHitTest);
const v = 10; //border width
var p: TPoint;
begin
  inherited;
  p := Point(Msg.XPos, Msg.YPos);
  p := ScreenToClient(p);
  if PtInRect(Rect(0, 0, v, v), p) then
    Msg.Result := HTTOPLEFT
  else if PtInRect(Rect(Width - v, Height - v, Width, Height), p) then
    Msg.Result := HTBOTTOMRIGHT
  else if PtInRect(Rect(Width - v, 0, Width, v), p) then
    Msg.Result := HTTOPRIGHT
  else if PtInRect(Rect(0, Height - v, v, Height), p) then
    Msg.Result := HTBOTTOMLEFT
  else if PtInRect(Rect(v, 0, Width - v, v), p) then
    Msg.Result := HTTOP
  else if PtInRect(Rect(0, v, v, Height - v), p) then
    Msg.Result := HTLEFT
  else if PtInRect(Rect(Width - v, v, Width, Height - v), p) then
    Msg.Result := HTRIGHT
  else if PtInRect(Rect(v, Height - v, Width - v, Height), p) then
    Msg.Result := HTBOTTOM;
end;

procedure TfrmWelCome.Open();
begin
  g_sUrl := 'http://Www.makegm.com';
  Navigate(g_sUrl);
end;

procedure TfrmWelCome.Open(sHomePage: string);
begin
  g_sUrl := sHomePage;
  Navigate(g_sUrl);
end;

procedure TfrmWelCome.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  g_PlugInfo.KeyDown(Key, Shift);
end;

procedure TfrmWelCome.FormKeyPress(Sender: TObject; var Key: Char);
begin
  g_PlugInfo.KeyPress(Key);
end;

function TfrmWelCome.NewWebBrowser: TWebPanel;
var
  Panel: TWebPanel;
begin
  Panel := TWebPanel.Create(Self);
  Panel.Parent := Self;
  Panel.Color := clBlack;
  Panel.Ctl3D := False;
  Panel.Align := alClient;
  Panel.Visible := False;
  Panel.WebBrowser := TWebBrowser.Create(Self);
  Panel.WebBrowser.OnNewWindow2 := WebBrowserNewWindow2;
  TControl(Panel.WebBrowser).Parent := Panel;

  Panel.WebBrowser.Align := alClient;
  Panel.WebBrowser.Visible := True;
  Panel.Visible := True;

  Result := Panel;
end;

procedure TfrmWelCome.WebBrowserNewWindow2(Sender: TObject;
  var ppDisp: IDispatch; var Cancel: WordBool);
var
  I: Integer;
  Panel: TWebPanel;
begin
  Panel := NewWebBrowser;
  ppDisp := Panel.WebBrowser.Application;
  for I := 0 to Length(WebBrowsers) - 1 do
    WebBrowsers[I].Visible := False;
  SetLength(WebBrowsers, Length(WebBrowsers) + 1);
  WebBrowsers[Length(WebBrowsers) - 1] := Panel;
end;

procedure TfrmWelCome.Navigate(const sUrl: string);
var
  I: Integer;
  Panel: TWebPanel;
begin
  for I := 0 to Length(WebBrowsers) - 1 do begin
    WebBrowsers[I].WebBrowser.Free;
    WebBrowsers[I].Free;
  end;
  SetLength(WebBrowsers, 0);
  Panel := NewWebBrowser;
  SetLength(WebBrowsers, Length(WebBrowsers) + 1);
  WebBrowsers[Length(WebBrowsers) - 1] := Panel;
  Panel.WebBrowser.Navigate(sUrl);
  Show;
end;

procedure TfrmWelCome.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I: Integer;
begin
  Action := caHide;
  for I := 0 to Length(WebBrowsers) - 1 do begin
    WebBrowsers[I].WebBrowser.Free;
    WebBrowsers[I].Free;
  end;
  SetLength(WebBrowsers, 0);
end;

end.

