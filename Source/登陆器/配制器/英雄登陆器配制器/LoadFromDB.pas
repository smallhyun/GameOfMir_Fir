unit LoadFromDB;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, RzLabel, ExtCtrls, RzPanel, RzDlgBtn;

type
  TFrmLoadFromDB = class(TForm)
    DialogButtons: TRzDialogButtons;
    RzLabel1: TRzLabel;
    EditDBName: TRzEdit;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Open;
  end;

var
  FrmLoadFromDB: TFrmLoadFromDB;

implementation

{$R *.dfm}

procedure TFrmLoadFromDB.Open;
begin
  ShowModal;
end;

end.
