unit NpcDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, RzLabel, ExtCtrls, RzPanel, RzDlgBtn, CMain;

type
  TMessageDlg = class

  private
    FInputString: string;
    FMerchant: Integer;
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    function MessageDlg(sShowStr: string; DlgButtons: TMsgDlgButtons): TModalResult;
    procedure Close;
  published
    property InputString: string read FInputString write FInputString;
    property Merchant: Integer read FMerchant write FMerchant;
  end;

  TfrmNpcDialog = class(TForm)
    DialogButtons: TRzDialogButtons;
    LabelMsg: TRzLabel;
    EditText: TRzEdit;
    procedure DialogButtonsClickCancel(Sender: TObject);
    procedure DialogButtonsClickOk(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNpcDialog: TfrmNpcDialog;
implementation
uses Grobal2, EncryptUnit, GameShare;
{$R *.dfm}
constructor TMessageDlg.Create(AOwner: TComponent);
begin
  frmNpcDialog := TfrmNpcDialog.Create(AOwner);
end;

destructor TMessageDlg.Destroy;
begin

end;

procedure TMessageDlg.Close;
begin
  frmNpcDialog.Close;
end;

function TMessageDlg.MessageDlg(sShowStr: string; DlgButtons: TMsgDlgButtons): TModalResult;
begin
  frmNpcDialog.Close;
  FInputString := '';

  frmNpcDialog.LabelMsg.Caption := sShowStr;
  if mbCancel in DlgButtons then begin
    frmNpcDialog.DialogButtons.BtnOK.Visible := True;
  end;
  if mbYes in DlgButtons then begin
    frmNpcDialog.DialogButtons.BtnOK.Visible := True;
    frmNpcDialog.DialogButtons.BtnCancel.Visible := True;
  end;
  if mbOK in DlgButtons then begin
    frmNpcDialog.DialogButtons.BtnOK.Visible := True;
    frmNpcDialog.EditText.Visible := True;
  end;

  frmNpcDialog.Show;
  FInputString := frmNpcDialog.EditText.Text;
  Result := frmNpcDialog.DialogButtons.ModalResultOk;
end;

procedure TfrmNpcDialog.DialogButtonsClickCancel(Sender: TObject);
begin
  Close;
end;

procedure TfrmNpcDialog.DialogButtonsClickOk(Sender: TObject);
var
  Msg: TDefaultMessage;
  param: string;
begin
  if EditText.Visible then begin
    Msg := MakeDefaultMsg(CM_MERCHANTDLGSELECT, g_MessageDlg.merchant, 0, 0, 0);
    frmCMain.SendSocket(EncodeMessage(Msg) + EncodeString(g_MessageDlg.InputString + #13 + Trim(EditText.Text)));
  end;
  Close;
end;

end.

