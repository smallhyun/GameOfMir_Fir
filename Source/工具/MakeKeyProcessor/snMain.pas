unit snMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFrmMain = class(TForm)
    RadioGroup: TRadioGroup;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    EditQQ: TEdit;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    EditSerialNumber: TEdit;
    ButtonOK: TButton;
    ButtonClose: TButton;
    RadioGroup1: TRadioGroup;
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation
uses EncryptUnit, HUtil32, Common, MSI_CPU, MSI_Storage, MSI_Machine, MD5EncodeStr;
{$R *.dfm}
//_____________________________________________________________________//

function GetSerialNumber(nUserNumber, nVersion: Integer): string;
  function GetBIOS: string;
  var
    BIOS: TBIOS;
  begin
    BIOS := TBIOS.Create;
    try
      BIOS.GetInfo;
      Result := Trim(BIOS.Copyright + #13 + BIOS.Date + #13 + BIOS.Name + #13 + BIOS.ExtendedInfo);
    except
      Result := '';
    end;
    BIOS.Free;
  end;

  function GetDiskSerialNumber: string;
  var
    Storage: TStorage;
  begin
    Storage := TStorage.Create;
    try
      Storage.GetInfo;
      if Storage.DeviceCount > 0 then begin
        Result := Trim(Storage.Devices[0].SerialNumber);
      end;
    except
      Result := '';
    end;
    Storage.Free;
  end;

  function GetCPUSerialNumber: string;
  var
    CurrProc: THandle;
    ProcessAffinityOld: Cardinal;
    ProcessAffinity: Cardinal;
    SystemAffinity: Cardinal;
    CPU: TCPU;
  begin
    CurrProc := GetCurrentProcess;
    try
      if GetProcessAffinityMask(CurrProc, ProcessAffinityOld, SystemAffinity) then begin
        ProcessAffinity := $1 shr 0; //this sets the process to only run on CPU 0  //第一个cpu的第一个
                              //for CPU 1 only use 2 and for CPUs 1 & 2 use 3
        SetProcessAffinityMask(CurrProc, ProcessAffinity);

        CPU := TCPU.Create;
        try
          CPU.GetInfo();
          Result := Trim(CPU.SerialNumber);
        except
          Result := '';
        end;
        CPU.Free;
      end;
    finally
    //恢复默认
      SetProcessAffinityMask(CurrProc, ProcessAffinityOld);
    end;
  end;
begin
  Result := RivestStr(IntToStr(StringCrc(RivestStr(GetBIOS) +
    RivestStr(GetCPUSerialNumber) +
    RivestStr(GetDiskSerialNumber)) +
    nUserNumber + nVersion + (nUserNumber * nVersion)));
end;

procedure TFrmMain.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.ButtonOKClick(Sender: TObject);
var
  sQQ: string;
  dwWaitTick: Longword;
  nUserNumber: Integer;
  nVersion: Word;
  nSoftware: Word;
begin
  sQQ := Trim(EditQQ.Text);
  nVersion := RadioGroup.ItemIndex;
  nSoftware := RadioGroup1.ItemIndex;
  if nSoftware = 1 then nVersion := 0;

  if (sQQ = '') or (not IsStringNumber(sQQ)) then begin
    Application.MessageBox('请输入正确的QQ ！！！', '提示信息', MB_ICONQUESTION);
    EditQQ.SetFocus;
    Exit;
  end;
  ButtonOK.Enabled := False;
  dwWaitTick := GetTickCount;
  nUserNumber := StrToInt(sQQ);
  while True do begin
    Application.ProcessMessages;
    if GetTickCount - dwWaitTick > 1000 * 1 then break;
  end;
  EditSerialNumber.Text := GetSerialNumber(nUserNumber, MakeLong(nSoftware, nVersion));
  ButtonOK.Enabled := True;
end;

procedure TFrmMain.RadioGroup1Click(Sender: TObject);
begin
  RadioGroup.Enabled := RadioGroup1.ItemIndex = 0;
  if not RadioGroup.Enabled then RadioGroup.ItemIndex := 0;
end;

end.

