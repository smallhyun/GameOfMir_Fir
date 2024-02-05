unit IPMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Spin, StdCtrls, CShare;

type
  TfrmIP = class(TForm)
    EditIP: TEdit;
    Button1: TButton;
    Button2: TButton;
    SpinEditIP: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmIP: TfrmIP;

implementation

{$R *.dfm}

procedure TfrmIP.Button1Click(Sender: TObject);
begin
  EditIP.Text := MakeIntToIP(SpinEditIP.Value);
end;

procedure TfrmIP.Button2Click(Sender: TObject);
begin
  SpinEditIP.Value := MakeIPToInt(EditIP.Text);
end;

end.

