unit Option;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLstBox, ExtCtrls, RzPanel, RzRadGrp, RzButton, IniFiles, Share;

type
  TFrmOption = class(TForm)
    RzGroupBox1: TRzGroupBox;
    RzListBox: TRzListBox;
    RzRadioGroup: TRzRadioGroup;
    RzButtonSaveOption: TRzButton;
    RzButtonLoadOption: TRzButton;
    RzButtonBackOption: TRzButton;
    procedure RzListBoxClick(Sender: TObject);
    procedure RzRadioGroupClick(Sender: TObject);
    procedure RzButtonBackOptionClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RzButtonLoadOptionClick(Sender: TObject);
    procedure RzButtonSaveOptionClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadOption;
    procedure SaveOption;
  public
    { Public declarations }
    procedure RefOption(Config: pTClientConfig);
  end;

var
  FrmOption: TFrmOption;

implementation
{$R *.dfm}

procedure TFrmOption.RefOption(Config: pTClientConfig);
var
  I: Integer;
begin
  Config.WEffectImg := TLoadMode(RzListBox.Items.Objects[0]);
  Config.WDragonImg := TLoadMode(RzListBox.Items.Objects[1]);
  Config.WMainImages := TLoadMode(RzListBox.Items.Objects[2]);
  Config.WMain2Images := TLoadMode(RzListBox.Items.Objects[3]);
  Config.WMain3Images := TLoadMode(RzListBox.Items.Objects[4]);
  Config.WChrSelImages := TLoadMode(RzListBox.Items.Objects[5]);
  Config.WMMapImages := TLoadMode(RzListBox.Items.Objects[6]);
  Config.WHumWingImages := TLoadMode(RzListBox.Items.Objects[7]);
  Config.WHum1WingImages := TLoadMode(RzListBox.Items.Objects[8]);
  Config.WHum2WingImages := TLoadMode(RzListBox.Items.Objects[9]);
  Config.WBagItemImages := TLoadMode(RzListBox.Items.Objects[10]);
  Config.WStateItemImages := TLoadMode(RzListBox.Items.Objects[1]);
  Config.WDnItemImages := TLoadMode(RzListBox.Items.Objects[12]);
  Config.WHumImgImages := TLoadMode(RzListBox.Items.Objects[13]);
  Config.WHairImgImages := TLoadMode(RzListBox.Items.Objects[14]);
  Config.WHair2ImgImages := TLoadMode(RzListBox.Items.Objects[15]);
  Config.WWeaponImages := TLoadMode(RzListBox.Items.Objects[16]);
  Config.WMagIconImages := TLoadMode(RzListBox.Items.Objects[17]);
  Config.WNpcImgImages := TLoadMode(RzListBox.Items.Objects[18]);
  Config.WMagicImages := TLoadMode(RzListBox.Items.Objects[19]);
  Config.WMagic2Images := TLoadMode(RzListBox.Items.Objects[20]);
  Config.WMagic3Images := TLoadMode(RzListBox.Items.Objects[21]);
  Config.WMagic4Images := TLoadMode(RzListBox.Items.Objects[22]);
  Config.WMagic5Images := TLoadMode(RzListBox.Items.Objects[23]);
  Config.WMagic6Images := TLoadMode(RzListBox.Items.Objects[24]);
  Config.WHorseImages := TLoadMode(RzListBox.Items.Objects[25]);
  Config.WHumHorseImages := TLoadMode(RzListBox.Items.Objects[26]);
  Config.WHairHorseImages := TLoadMode(RzListBox.Items.Objects[27]);
  for I := 0 to 29 do
    Config.WMonImages[I] := TLoadMode(RzListBox.Items.Objects[I + 28]);
end;

procedure TFrmOption.LoadOption;
var
  I: Integer;
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Data.ini');
  for I := 0 to RzListBox.Items.Count - 1 do begin
    RzListBox.Items.Objects[I] := TObject(IniFile.ReadInteger('Mode', IntToStr(I), 0));
  end;
  IniFile.Free;
end;

procedure TFrmOption.SaveOption;
var
  I: Integer;
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Data.ini');
  for I := 0 to RzListBox.Items.Count - 1 do begin
    IniFile.WriteInteger('Mode', IntToStr(I), Integer(RzListBox.Items.Objects[I]));
  end;
  IniFile.Free;
end;

procedure TFrmOption.RzListBoxClick(Sender: TObject);
begin
  RzRadioGroup.ItemIndex := Integer(RzListBox.Items.Objects[RzListBox.ItemIndex]);
  RzRadioGroup.Caption := RzListBox.Items.Strings[RzListBox.ItemIndex];
end;

procedure TFrmOption.RzRadioGroupClick(Sender: TObject);
begin
  if RzListBox.ItemIndex >= 0 then begin
    RzListBox.Items.Objects[RzListBox.ItemIndex] := TObject(RzRadioGroup.ItemIndex);
    RzButtonSaveOption.Enabled := True;
  end;
end;

procedure TFrmOption.RzButtonBackOptionClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to RzListBox.Items.Count - 1 do
    RzListBox.Items.Objects[I] := nil;
  RzButtonSaveOption.Enabled := True;
end;

procedure TFrmOption.FormCreate(Sender: TObject);
begin
  LoadOption;
end;

procedure TFrmOption.RzButtonLoadOptionClick(Sender: TObject);
begin
  LoadOption;
end;

procedure TFrmOption.RzButtonSaveOptionClick(Sender: TObject);
begin
  RzButtonSaveOption.Enabled := False;
  SaveOption;
end;

end.

