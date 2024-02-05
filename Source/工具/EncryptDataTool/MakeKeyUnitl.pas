unit MakeKeyUnitl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, EncryptUnit, PlugShare;

type
  TSystemInitialize = procedure(Config: pTSystemConfig); stdcall;
  TGetRegistryInfo = procedure(RegistryInfo: pTRegistryConfig); stdcall;
  TGetRegistryKey = procedure(RegistryConfig: pTRegistryConfig; Key: PChar); stdcall;

  TFrmMakeKey = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EditSerialNumber: TEdit;
    EditRegistryNumber: TEdit;
    ButtonCancel: TButton;
    ButtonOK: TButton;
    procedure ButtonOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMakeKey: TFrmMakeKey;

implementation
var
  Module: THandle;
  SystemInitialize: TSystemInitialize;
  GetRegistryKey: TGetRegistryKey;
{$R *.dfm}

procedure TFrmMakeKey.ButtonOKClick(Sender: TObject);
var
  sFileName, sSerialNumber: string;
  RegistryConfig: TRegistryConfig;
  SystemConfig: TSystemConfig;
  Key: array[0..1024 - 1] of Char;
  Buffer: PChar;
  InData: Pointer;
begin
  sSerialNumber := Trim(EditSerialNumber.Text);
  if Length(sSerialNumber) = 32 then begin
    FillChar(RegistryConfig, SizeOf(TRegistryConfig), #0);
    FillChar(SystemConfig, SizeOf(TSystemConfig), #0);
    FillChar(Key, 1024, #0);
    SystemConfig.nOwner := CalcFileCRC(Application.ExeName);
    SystemConfig.nUserNumber := 123456789;
    SystemConfig.nVersion := 8888;
    SystemConfig.nMyRootKey := HKEY_CURRENT_USER;
    SystemConfig.cMySubKey := '\Software\EncryptData\';
    SystemConfig.cKey := 'Key';

    RegistryConfig.nOwnerNumber := SystemConfig.nOwner;
    RegistryConfig.nUserNumber := SystemConfig.nUserNumber;
    RegistryConfig.nVersion := SystemConfig.nVersion;
    RegistryConfig.RegistryStatus := r_Forever;
    Buffer := @RegistryConfig.SerialNumber;
    Move(sSerialNumber[1], RegistryConfig.SerialNumber, Length(sSerialNumber));

    InData := Pointer(Integer(@RegistryConfig) + 4);
    RegistryConfig.nCRC := CalcBufferCRC(InData, SizeOf(TRegistryConfig) - 4);

    sFileName := ExtractFilePath(Application.ExeName) + 'RegistrySystem.dll'; ;
    if FileExists(sFileName) then begin
      Module := LoadLibrary(PChar(sFileName)); //FreeLibrary
      if Module > 32 then begin
        SystemInitialize := GetProcAddress(Module, Pointer(HiWord(0) or LoWord(1)));//:= GetProcAddress(Module, 'SystemInitialize');
        GetRegistryKey := GetProcAddress(Module, Pointer(HiWord(0) or LoWord(3))); //GetProcAddress(Module, 'GetRegistryKey');

        if (@SystemInitialize <> nil) and (@GetRegistryKey <> nil) then begin
          SystemInitialize(@SystemConfig);
          GetRegistryKey(@RegistryConfig, @Key);
          EditRegistryNumber.Text := Key;
        end;
      end;
      FreeLibrary(Module);
    end;
  end;
end;

end.

