unit GameLoginConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzRadChk, StdCtrls, Mask, RzEdit, RzBtnEdt, RzLabel, ExtCtrls,
  RzPanel, RzButton, GameLogin;

type
  TFrmGameLoginConfig = class(TForm)
    ButtonOK: TRzButton;
    RzButtonClose: TRzButton;
    RzGroupBox2: TRzGroupBox;
    RzLabel2: TRzLabel;
    RzLabel3: TRzLabel;
    RzLabel4: TRzLabel;
    RzLabel5: TRzLabel;
    RzButtonEditUp: TRzButtonEdit;
    RzButtonEditHot: TRzButtonEdit;
    RzButtonEditDown: TRzButtonEdit;
    RzButtonEditDisabled: TRzButtonEdit;
    RzCheckBoxVisible: TRzCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Open;
  end;

var
  FrmGameLoginConfig: TFrmGameLoginConfig;

implementation
var
  SelWinControl: TControl;
{$R *.dfm}

procedure TFrmGameLoginConfig.Open;
begin

end;

end.

