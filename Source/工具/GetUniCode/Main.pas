unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, EncryptUnit;

type
  TFrmGetUniCode = class(TForm)
    EditKey: TEdit;
    Edit1: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmGetUniCode: TFrmGetUniCode;

implementation

{$R *.dfm}
procedure TFrmGetUniCode.Button1Click(Sender: TObject);
begin
  Edit1.Text := IntToStr(StringCrc(EditKey.Text));
end;

end.

