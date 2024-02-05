unit UserManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, RzLabel, ExtCtrls, RzPanel, RzDlgBtn,
  RzRadChk, RzButton, RzSpnEdt;

type
  TfrmUserManage = class(TForm)
    EditUserLiense: TEdit;
    RzLabel1: TLabel;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    CheckBoxCheckNoticeUrl: TCheckBox;
    CheckBoxWriteHosts: TCheckBox;
    Label2: TLabel;
    EditHostsAddress: TEdit;
    CheckBoxWriteUrlEntry: TCheckBox;
    RzGroupBox1: TRzGroupBox;
    RzEditMD5: TRzEdit;
    RzRadioButtonCompulsiveUpdata: TRzRadioButton;
    RzRadioButtonHintUpData: TRzRadioButton;
    RzCheckBoxAllowUpData: TRzCheckBox;
    RzLabel2: TRzLabel;
    RzLabel3: TRzLabel;
    RzEditUpdataAddr: TRzEdit;
    RzGroupBox2: TRzGroupBox;
    RzEditHomePage: TRzEdit;
    RzCheckBoxOpenPage1: TRzCheckBox;
    RzLabel4: TRzLabel;
    RzEditOpenPage1: TRzEdit;
    RzCheckBoxOpenPage2: TRzCheckBox;
    RzEditOpenPage2: TRzEdit;
    RzEditClosePage1: TRzEdit;
    RzEditClosePage2: TRzEdit;
    RzCheckBoxClosePage1: TRzCheckBox;
    RzCheckBoxClosePage2: TRzCheckBox;
    RzGroupBox3: TRzGroupBox;
    RzLabel5: TRzLabel;
    RzEditSayMessage1: TRzEdit;
    RzEditSayMessage2: TRzEdit;
    RzLabel6: TRzLabel;
    RzLabel7: TRzLabel;
    RzSpinEditSayMessageTime: TRzSpinEdit;
    CheckBoxCheckOpenPage: TCheckBox;
    CheckBoxCheckConnectPage: TCheckBox;
    CheckBoxUseServerUpgrade: TCheckBox;
    RzLabel8: TRzLabel;
    EditUpgradeFileName: TEdit;
    ButtonRefUpgrade: TButton;
    CheckBoxCheckParent: TCheckBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox10: TCheckBox;
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure CheckBoxUseServerUpgradeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmUserManage: TfrmUserManage;

implementation

{$R *.dfm}

procedure TfrmUserManage.ButtonCancelClick(Sender: TObject);
begin
  //ModalResult := ButtonOK.ModalResult;
  Close;
end;

procedure TfrmUserManage.ButtonOKClick(Sender: TObject);
begin
 // ModalResult := 10;
  ButtonOK.ModalResult := mrOk;
  Close;
end;

procedure TfrmUserManage.CheckBoxUseServerUpgradeClick(Sender: TObject);
begin
  RzEditMD5.Enabled := not CheckBoxUseServerUpgrade.Checked;
  RzEditUpdataAddr.Enabled := not CheckBoxUseServerUpgrade.Checked;
end;

procedure TfrmUserManage.FormCreate(Sender: TObject);
begin
  RzSpinEditSayMessageTime.Max:=0;
end;

end.

