unit AboutUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFrmAbout = class(TForm)
    ButtonOK: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    EditProductName: TEdit;
    EditVersion: TEdit;
    EditUpDateTime: TEdit;
    EditProgram: TEdit;
    EditWebSite: TEdit;
    EditBbsSite: TEdit;
    procedure ButtonOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Open();
  end;

var
  FrmAbout: TFrmAbout;

implementation
uses M2Share, Common, EncryptUnit;
{$R *.dfm}

procedure TFrmAbout.Open();
var
  Buffer: Pointer;
  sText: string;
begin
  EditUpDateTime.Text := '';
  EditProductName.Text := '';
  EditProgram.Text := '';
  EditWebSite.Text := ''; ;
  EditBbsSite.Text := '';
  EditVersion.Text := '';

  EditUpDateTime.ReadOnly := True;
  EditProductName.ReadOnly := True;
  EditProgram.ReadOnly := True;
  EditWebSite.ReadOnly := True;
  EditBbsSite.ReadOnly := True;
  EditVersion.ReadOnly := True;
  EditUpDateTime.Text := sProductName;
  EditProductName.Text := sProductName;
  EditProgram.Text := sProgram;
  EditWebSite.Text := sWebSite;
  EditBbsSite.Text := sBbsSite;
  EditVersion.Text := sVersion;

  ShowModal;
end;

procedure TFrmAbout.ButtonOKClick(Sender: TObject);
begin
  Close;
end;

end.
