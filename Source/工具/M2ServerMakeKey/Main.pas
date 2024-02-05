unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin;

type
  TUserInfo = record
    DomainName: string;
    Key: string; //机器码
  end;
  pTUserInfo = ^TUserInfo;

  TFrmMain = class(TForm)
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label2: TLabel;
    EditDays: TSpinEdit;
    RadioGroupUserMode: TRadioGroup;
    RadioGroupLicDay: TRadioGroup;
    ButtonOK: TButton;
    ButtonExit: TButton;
    ComboBoxDomainName: TComboBox;
    MemoKey: TMemo;
    ButtonSave: TButton;
    ButtonDel: TButton;
    LabelDate: TLabel;
    Timer: TTimer;
    SaveDialog: TSaveDialog;
    procedure RadioGroupUserModeClick(Sender: TObject);
    procedure RadioGroupLicDayClick(Sender: TObject);

    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonDelClick(Sender: TObject);
    procedure ButtonExitClick(Sender: TObject);
    procedure EditDaysChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ButtonOKClick(Sender: TObject);
  private
    { Private declarations }

    procedure TimerTimer(Sender: TObject);
    procedure ComboBoxDomainNameChange(Sender: TObject);

    procedure LoadList;
    procedure UnLoadList;
    procedure SaveToFile;
    procedure Delete(DomainName: string);
    procedure Add(DomainName, Key: string);
    function Find(DomainName: string): pTUserInfo;

  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;
  g_UserList: TStringList;
implementation
uses EncryptUnit, HUtil32, Common, MSI_CPU, MSI_Storage, MSI_Machine, MD5EncodeStr;
var
  g_StartOK: PBoolean;
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

//_____________________________________________________________________//

function GetDate(D: TDate): string;
var
  Year, Mon, Day: Word;
  sMon: string;
  sDay: string;
begin
  DecodeDate(D, Year, Mon, Day);
  if Mon < 10 then sMon := '0' + IntToStr(Mon)
  else sMon := IntToStr(Mon);
  if Day < 10 then sDay := '0' + IntToStr(Day)
  else sDay := IntToStr(Day);
  Result := IntToStr(Year) + '年' + sMon + '月' + sDay + '日';
end;

procedure TFrmMain.LoadList;
var
  I: Integer;
  LoadList: TStringList;
  sFileName: string;
  UserInfo: pTUserInfo;
  sLineText: string;
  sDomainName: string;
  sKey: string; //机器码
begin
  if g_UserList <> nil then begin
    UnLoadList;
  end;
  g_UserList := TStringList.Create;

  sFileName := ExtractFilePath(Application.ExeName) + 'MakeKey.txt';
  if FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    for I := 0 to LoadList.Count - 1 do begin
      sLineText := Trim(LoadList.Strings[I]);
      if (sLineText = '') or (sLineText[1] = ';') then Continue;
      sLineText := GetValidStr3(sLineText, sDomainName, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sKey, [' ', #9]);
      sDomainName := Trim(sDomainName);
      sKey := Trim(sKey);
      New(UserInfo);
      UserInfo.DomainName := Trim(sDomainName);
      UserInfo.Key := Trim(sKey);
      g_UserList.AddObject(sDomainName, TObject(UserInfo));
    end;
    LoadList.Free;
    ComboBoxDomainName.Clear;
    ComboBoxDomainName.Items.AddStrings(g_UserList);
  end;
end;

procedure TFrmMain.UnLoadList;
var
  I: Integer;
begin
  if g_UserList <> nil then begin
    for I := 0 to g_UserList.Count - 1 do begin
      Dispose(pTUserInfo(g_UserList.Objects[I]));
    end;
    FreeAndNil(g_UserList);
  end;
end;

procedure TFrmMain.SaveToFile;
var
  I: Integer;
  SaveList: TStringList;
  sFileName: string;
  sLineText: string;
  UserInfo: pTUserInfo;
begin
  if g_UserList <> nil then begin
    SaveList := TStringList.Create;
    for I := 0 to g_UserList.Count - 1 do begin
      UserInfo := pTUserInfo(g_UserList.Objects[I]);
      sLineText := UserInfo.DomainName + #9 + UserInfo.Key;
      SaveList.Add(sLineText);
    end;
    sFileName := ExtractFilePath(Application.ExeName) + 'MakeKey.txt';
    try
      SaveList.SaveToFile(sFileName);
    except

    end;
    SaveList.Free;
  end;
end;

procedure TFrmMain.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;
  LoadList;
end;

procedure TFrmMain.ButtonDelClick(Sender: TObject);
var
  sSerialNumber: string;
begin
  sSerialNumber := Trim(ComboBoxDomainName.Text);
  Delete(sSerialNumber);
end;

procedure TFrmMain.ButtonExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.ButtonOKClick(Sender: TObject);
var
  dwWaitTick: Longword;
  OptionSize: PInteger;
  Count: PInteger;
  MemoryStream: TMemoryStream;
  MakeRegInfo: pTMakeRegInfo;
  MakeInfo: pTMakeInfo;
  Buffer: PChar;
  sOption: string;
  sBuffer: string;
  nCRC: PCardinal;
  boVersion: PBoolean;
  sSerialNumber: string;
  sDomainName, sInPutDomainName: string;

  nMode: Integer;
  nDays: Integer;
  nUserCount: Integer;
  DomainNameFile: pTDomainNameFile;

  I: Integer;
  nVersion: Word;
  boUnlimited: Boolean;
  SaveList: TStringList;
const
  s00 = 'emStUbRdiv9E';
  s03 = 'HY5wqvah0wRO';
  s32 = '6gTfQVzk9snwOQ==';
begin
  if not g_StartOK^ then Exit;
  boUnlimited := RadioGroupUserMode.ItemIndex = 1;
  nDays := EditDays.Value;

  sInPutDomainName := Trim(ComboBoxDomainName.Text);
  if Pos('.', sInPutDomainName) = StrToInt(DecryptString(s00)) then begin
    Application.MessageBox('请输入正确的域名！！！', '提示信息', MB_ICONQUESTION);
    ComboBoxDomainName.SetFocus;
    Exit;
  end;

  if boUnlimited then nDays := High(Word);

  if (nDays <= StrToInt(DecryptString(s00))) then begin
    Application.MessageBox('请输入注册天数！！！', '提示信息', MB_ICONQUESTION);
    EditDays.SetFocus;
    Exit;
  end;

  ButtonOK.Enabled := False;

  dwWaitTick := GetTickCount;
  while True do begin
    Application.ProcessMessages;
    if GetTickCount - dwWaitTick > 500 then break;
  end;

  New(OptionSize);
  New(Count);
  New(nCRC);
  New(MakeInfo);
  New(MakeRegInfo);
  MemoryStream := TMemoryStream.Create;
  try
    OptionSize^ := Length(EncryptBuffer(@MakeRegInfo^, SizeOf(TMakeRegInfo)));
    MemoryStream.LoadFromFile(Application.ExeName);

    MemoryStream.Seek(-(SizeOf(Integer) + OptionSize^), soFromEnd);
    MemoryStream.Read(Count^, SizeOf(Integer));

    GetMem(Buffer, OptionSize^);
    try
      MemoryStream.Read(Buffer^, OptionSize^);
      SetLength(sOption, OptionSize^);
      Move(Buffer^, sOption[1], OptionSize^);
    finally
      FreeMem(Buffer);
    end;

    GetMem(Buffer, Count^);
    try
      MemoryStream.Seek(0, soFromBeginning);
      MemoryStream.Read(Buffer^, Count^);
      nCRC^ := BufferCRC(Buffer, Count^);
    finally
      FreeMem(Buffer);
    end;

    DecryptBuffer(sOption, @MakeRegInfo^, SizeOf(TMakeRegInfo));
    DecryptBuffer(MakeRegInfo.sBuffer, @MakeInfo^, SizeOf(TMakeInfo));
    sSerialNumber := GetSerialNumber(MakeInfo.nUserNumber, MakeInfo.nVersion);
    //boVersion^ := Boolean((abs(ConfigOption.nOwnerNumber - ConfigOption.nUserNumber)));
    if (Count^ = MakeInfo.nSize) and
      (nCRC^ = MakeInfo.nCrc) and
      (StringCrc(MakeRegInfo.sBuffer) = MakeRegInfo.nBuffer) and
      (MakeInfo.nSerialNumber = StringCrc(MakeRegInfo.sSerialNumber)) and
      (MakeInfo.nSerialNumber = StringCrc(sSerialNumber))
      then begin
      New(DomainNameFile);
      FillChar(DomainNameFile^, SizeOf(TDomainNameFile), 0);

      DomainNameFile.nOwnerNumber := MakeInfo.nOwnerNumber +
        (LoWord(MakeInfo.nVersion) - SOFTWARE_M2SERVER_MAKEKEY) +
        (Count^ - MakeInfo.nSize) +
        (nCRC^ - MakeInfo.nCrc) +
        (StringCrc(MakeRegInfo.sBuffer) - MakeRegInfo.nBuffer) +
        (MakeInfo.nSerialNumber - StringCrc(MakeRegInfo.sSerialNumber)) +
        (MakeInfo.nSerialNumber - StringCrc(sSerialNumber));

      DomainNameFile.nUserNumber := MakeInfo.nUserNumber +
        (LoWord(MakeInfo.nVersion) - SOFTWARE_M2SERVER_MAKEKEY) +
        (Count^ - MakeInfo.nSize) +
        (nCRC^ - MakeInfo.nCrc) +
        (StringCrc(MakeRegInfo.sBuffer) - MakeRegInfo.nBuffer) +
        (MakeInfo.nSerialNumber - StringCrc(MakeRegInfo.sSerialNumber)) +
        (MakeInfo.nSerialNumber - StringCrc(sSerialNumber));


      DomainNameFile.sDomainName := sInPutDomainName;
      DomainNameFile.nDomainName := StringCrc(sInPutDomainName) +
        (LoWord(MakeInfo.nVersion) - SOFTWARE_M2SERVER_MAKEKEY) +
        (Count^ - MakeInfo.nSize) +
        (nCRC^ - MakeInfo.nCrc) +
        (StringCrc(MakeRegInfo.sBuffer) - MakeRegInfo.nBuffer) +
        (MakeInfo.nSerialNumber - StringCrc(MakeRegInfo.sSerialNumber)) +
        (MakeInfo.nSerialNumber - StringCrc(sSerialNumber));

      DomainNameFile.boUnlimited := boUnlimited;
      DomainNameFile.MinDate := Date;
      DomainNameFile.MaxDate := Date + nDays;

      DomainNameFile.nVersion := MakeLong(SOFTWARE_M2SERVER, HiWord(MakeInfo.nVersion)) +
        (LoWord(MakeInfo.nVersion) - SOFTWARE_M2SERVER_MAKEKEY) +
        (Count^ - MakeInfo.nSize) +
        (nCRC^ - MakeInfo.nCrc) +
        (StringCrc(MakeRegInfo.sBuffer) - MakeRegInfo.nBuffer) +
        (MakeInfo.nSerialNumber - StringCrc(MakeRegInfo.sSerialNumber)) +
        (MakeInfo.nSerialNumber - StringCrc(sSerialNumber));

      DomainNameFile.DomainNameArray[0] := DomainNameFile.sDomainName;

      for I := 0 to 1 do
        DomainNameFile.nArr1[I] := Random(High(Integer));
      for I := 0 to 1 do
        DomainNameFile.nArr2[I] := Random(High(Integer));
      for I := 0 to 1 do
        DomainNameFile.nArr3[I] := Random(High(Integer));
      for I := 0 to 1 do
        DomainNameFile.nArr4[I] := Random(High(Integer));
      for I := 0 to 1 do
        DomainNameFile.nArr5[I] := Random(High(Integer));
      for I := 0 to 1 do
        DomainNameFile.nArr6[I] := Random(High(Integer));
      for I := 0 to 1 do
        DomainNameFile.nArr7[I] := Random(High(Integer));
      for I := 0 to 1 do
        DomainNameFile.nArr8[I] := Random(High(Integer));
      for I := 0 to 1 do
        DomainNameFile.nArr9[I] := Random(High(Integer));

      MemoKey.Lines.Text := EncryptBuffer(@DomainNameFile^, SizeOf(TDomainNameFile));

      with SaveDialog do begin
        if FileName = '' then FileName := 'DomainName';
    //FileName := ExtractFilePath(FileName) + ExtractFileNameOnly(FileName) + '.exe';
        if Execute and (FileName <> '') then begin
          if ExtractFileExt(FileName) <> '.key' then
            FileName := ExtractFilePath(FileName) + ExtractFileNameOnly(FileName) + '.key';
          SaveList := TStringList.Create;
          try
            sBuffer := Trim(MemoKey.Lines.Text);
            while True do begin
              if Length(sBuffer) >= 50 then begin
                SaveList.Add(Copy(sBuffer, 1, 50));
                sBuffer := Copy(sBuffer, 50 + 1, Length(sBuffer));
              end else begin
                if sBuffer <> '' then
                  SaveList.Add(sBuffer);
                break;
              end;
            end;
            SaveList.SaveToFile(FileName);
            //MemoKey.Lines.SaveToFile(FileName);
            Application.MessageBox('创建成功 ！！！', '提示信息', MB_ICONQUESTION);
          except
            on e: Exception do begin
              Application.MessageBox(PChar(e.Message), '错误信息', MB_ICONERROR);
            end;
          end;
          SaveList.Free;
        end;
      end;

      Dispose(DomainNameFile);

      Dispose(OptionSize);
      Dispose(Count);
      Dispose(nCRC);
      Dispose(MakeInfo);
      Dispose(MakeRegInfo);
      MemoryStream.Free;

      ButtonOK.Enabled := True;
      Exit;
    end;
  except

  end;
  Dispose(OptionSize);
  Dispose(Count);
  Dispose(nCRC);
  Dispose(MakeInfo);
  Dispose(MakeRegInfo);
  MemoryStream.Free;
  Application.Terminate;
end;

procedure TFrmMain.ButtonSaveClick(Sender: TObject);
var
  I: Integer;
  sDomainName, sKey: string;
begin
  sDomainName := Trim(ComboBoxDomainName.Text);
  sKey := '';
  for I := 0 to MemoKey.Lines.Count - 1 do
    sKey := sKey + Trim(MemoKey.Lines.Strings[I]);
  //sKey := Trim(MemoKey.Lines.Text);
  if Pos('.', sDomainName) = 0 then begin
    Application.MessageBox('请输入正确的域名！！！', '提示信息', MB_ICONQUESTION);
    ComboBoxDomainName.SetFocus;
    Exit;
  end;
  //Showmessage(IntToStr(Length(sKey)));
  if sKey = '' then begin
    Application.MessageBox('请输入正确的注册码！！！', '提示信息', MB_ICONQUESTION);
    MemoKey.SetFocus;
    Exit;
  end;
  Add(sDomainName, sKey);
end;

procedure TFrmMain.ComboBoxDomainNameChange(Sender: TObject);
var
  sDomainName: string;
  UserInfo: pTUserInfo;
  DomainNameFile: pTDomainNameFile;
begin
  if not g_StartOK^ then Exit;

  sDomainName := Trim(ComboBoxDomainName.Text);
  UserInfo := Find(sDomainName);
  if UserInfo <> nil then begin
    New(DomainNameFile);
    DecryptBuffer(UserInfo.Key, @DomainNameFile^, SizeOf(TDomainNameFile));
    if (DomainNameFile.nDomainName = StringCrc(sDomainName)) then begin
      if DomainNameFile.boUnlimited then
        RadioGroupUserMode.ItemIndex := 1
      else
        RadioGroupUserMode.ItemIndex := 0;
      EditDays.Value := GetDayCount(DomainNameFile.MaxDate, DomainNameFile.MinDate);
      MemoKey.Lines.Text := UserInfo.Key;
      LabelDate.Caption := '注册日期: ' + GetDate(DomainNameFile.MinDate) + '至' + GetDate(DomainNameFile.MaxDate);
    end;
    Dispose(DomainNameFile);
  end;
end;

procedure TFrmMain.Add(DomainName, Key: string);
var
  I, ItemIndex: Integer;
  UserInfo: pTUserInfo;
begin
  ItemIndex := ComboBoxDomainName.ItemIndex;
  if g_UserList <> nil then begin
    for I := 0 to g_UserList.Count - 1 do begin
      if CompareText(DomainName, g_UserList.Strings[I]) = 0 then begin
        Application.MessageBox('该域名已经存在！！！', '提示信息', MB_ICONQUESTION);
        Exit;
      end;
    end;
    New(UserInfo);
    UserInfo.DomainName := DomainName;
    UserInfo.Key := Key;
    g_UserList.AddObject(DomainName, TObject(UserInfo));
    ComboBoxDomainName.Items.AddObject(DomainName, TObject(UserInfo));
    SaveToFile;
    Application.MessageBox('保存成功！！！', '提示信息', MB_ICONQUESTION);
    {ComboBoxSerialNumber.Clear;
    ComboBoxSerialNumber.Items.AddStrings(g_UserList);
    if (ItemIndex >= 0) and (ItemIndex < ComboBoxSerialNumber.Items.Count) then begin
      ComboBoxSerialNumber.ItemIndex := ItemIndex;
    end; }
  end;
end;

procedure TFrmMain.Delete(DomainName: string);
var
  I, II: Integer;
begin
  if g_UserList <> nil then begin
    for I := 0 to g_UserList.Count - 1 do begin
      if CompareText(DomainName, g_UserList.Strings[I]) = 0 then begin
        for II := 0 to ComboBoxDomainName.Items.Count - 1 do begin
          if ComboBoxDomainName.Items.Objects[II] = g_UserList.Objects[I] then begin
            ComboBoxDomainName.Items.Delete(II);
            break;
          end;
        end;
        Dispose(pTUserInfo(g_UserList.Objects[I]));
        g_UserList.Delete(I);
        SaveToFile;
        Application.MessageBox('删除完成！！！', '提示信息', MB_ICONQUESTION);
        break;
      end;
    end;
  end;
end;

procedure TFrmMain.EditDaysChange(Sender: TObject);
begin
  case RadioGroupUserMode.ItemIndex of
    //0: LabelDate.Caption := '注册日期: ' + GetDate(Date) + '至' + GetDate(Date + EditDays.Value);
    1: LabelDate.Caption := '注册日期: 无限期';
  else LabelDate.Caption := '注册日期: ' + GetDate(Date) + '至' + GetDate(Date + EditDays.Value);
  end;
end;

function TFrmMain.Find(DomainName: string): pTUserInfo;
var
  I: Integer;
begin
  Result := nil;
  if g_UserList <> nil then begin
    for I := 0 to g_UserList.Count - 1 do begin
      if CompareText(DomainName, g_UserList.Strings[I]) = 0 then begin
        Result := pTUserInfo(g_UserList.Objects[I]);
        break;
      end;
    end;
  end;
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Dispose(g_StartOK);
  UnLoadList;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  OptionSize: PInteger;
  Count: PInteger;
  MemoryStream: TMemoryStream;
  MakeRegInfo: pTMakeRegInfo;
  MakeInfo: pTMakeInfo;
  Buffer: Pointer;
  sOption: string;
  nCRC: PCardinal;
  boVersion: PBoolean;
  sSerialNumber: string;
  List: TStringList;
begin
  Application.ShowMainForm := False;
  Randomize;

  New(OptionSize);
  New(Count);
  New(nCRC);
  New(MakeInfo);
  New(MakeRegInfo);
  MemoryStream := TMemoryStream.Create;
  try
    OptionSize^ := Length(EncryptBuffer(@MakeRegInfo^, SizeOf(TMakeRegInfo)));
    MemoryStream.LoadFromFile(Application.ExeName);

    MemoryStream.Seek(-(SizeOf(Integer) + OptionSize^), soFromEnd);
    MemoryStream.Read(Count^, SizeOf(Integer));

    GetMem(Buffer, OptionSize^);
    try
      MemoryStream.Seek(-OptionSize^, soFromEnd);
      MemoryStream.Read(Buffer^, OptionSize^);
      SetLength(sOption, OptionSize^);
      Move(Buffer^, sOption[1], OptionSize^);
    finally
      FreeMem(Buffer);
    end;

    GetMem(Buffer, Count^);
    try
      MemoryStream.Seek(0, soFromBeginning);
      MemoryStream.Read(Buffer^, Count^);
      nCRC^ := BufferCRC(Buffer, Count^);
    finally
      FreeMem(Buffer);
    end;

    DecryptBuffer(sOption, @MakeRegInfo^, SizeOf(TMakeRegInfo));
    DecryptBuffer(MakeRegInfo.sBuffer, @MakeInfo^, SizeOf(TMakeInfo));
    sSerialNumber := GetSerialNumber(MakeInfo.nUserNumber, MakeInfo.nVersion);
    //boVersion^ := Boolean((abs(ConfigOption.nOwnerNumber - ConfigOption.nUserNumber)));
    if (Count^ = MakeInfo.nSize) and
      (nCRC^ = MakeInfo.nCrc) and
      (StringCrc(MakeRegInfo.sBuffer) = MakeRegInfo.nBuffer) and
      (MakeInfo.nSerialNumber = StringCrc(MakeRegInfo.sSerialNumber)) and
      (MakeInfo.nSerialNumber = StringCrc(sSerialNumber)) and
      (LoWord(MakeInfo.nVersion) = SOFTWARE_M2SERVER_MAKEKEY)
      then begin
     { List:=TStringList.Create;
      List.Add('MakeInfo.nVersion:'+IntToStr(MakeInfo.nVersion));
      List.Add('MakeInfo.nOwnerNumber:'+IntToStr(MakeInfo.nOwnerNumber));
      List.Add('MakeInfo.nUserNumber:'+IntToStr(MakeInfo.nUserNumber));
      List.Add('MakeInfo.nSerialNumber:'+IntToStr(MakeInfo.nSerialNumber));
      List.SaveToFile('List.txt');  }
      New(g_StartOK);
      g_StartOK^ := True;
      Application.ShowMainForm := True;
      Dispose(MakeRegInfo);
      Dispose(MakeInfo);
      Dispose(OptionSize);
      Dispose(Count);
      Dispose(nCRC);
      MemoryStream.Free;
      Timer.OnTimer := TimerTimer;
      ButtonOK.OnClick := ButtonOKClick;
      ComboBoxDomainName.OnChange := ComboBoxDomainNameChange;
      RadioGroupUserMode.ItemIndex := -1;
      RadioGroupLicDay.ItemIndex := -1;
      RadioGroupUserMode.ItemIndex := 0;
      RadioGroupLicDay.ItemIndex := 0;
      Timer.Enabled := True;
      Exit;
    end;
  except
    {Dispose(OptionSize);
    Dispose(Count);
    Dispose(nCRC);
    MemoryStream.Free;
    Application.Terminate;
    Exit;   }
  end;
  Dispose(MakeRegInfo);
  Dispose(MakeInfo);
  Dispose(OptionSize);
  Dispose(Count);
  Dispose(nCRC);
  MemoryStream.Free;
  Application.Terminate;
end;

procedure TFrmMain.RadioGroupLicDayClick(Sender: TObject);
var
  nDay: Integer;
begin
  case RadioGroupLicDay.ItemIndex of
    0: nDay := 30;
    1: nDay := 365 div 2;
    2: nDay := 365;
  end;
  EditDays.Value := GetDayCount(Date + nDay, Now);
end;

procedure TFrmMain.RadioGroupUserModeClick(Sender: TObject);
begin
  case RadioGroupUserMode.ItemIndex of
   { 0: begin
        LabelDate.Caption := '注册日期: ' + GetDate(Date) + '至' + GetDate(Date + EditDays.Value);
        RadioGroupLicDay.Enabled := True;
      end; }
    1: begin
        LabelDate.Caption := '注册日期: 无限期';
        RadioGroupLicDay.Enabled := False;
      end;
  else begin
      LabelDate.Caption := '注册日期: ' + GetDate(Date) + '至' + GetDate(Date + EditDays.Value);
      RadioGroupLicDay.Enabled := True;
    end;
  end;
end;

end.

