unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask, RzEdit, RzBtnEdt;

type
  TUserInfo = record
    SerialNumber: string;
    QQ: Integer;
    SoftWare: Integer;
    Version: Integer;
    Date: string;
  end;
  pTUserInfo = ^TUserInfo;

  TFrmMain = class(TForm)
    GroupBox3: TGroupBox;
    Label11: TLabel;
    EditMakeKey: TRzButtonEdit;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label9: TLabel;
    ComboBoxQQ: TComboBox;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    TimerStart: TTimer;
    RadioGroup: TRadioGroup;
    ButtonMakeKey: TButton;
    ButtonSave: TButton;
    ButtonClose: TButton;
    ButtonDel: TButton;
    ComboBoxSerialNumber: TComboBox;
    LabelDate: TLabel;
    RadioGroup1: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure TimerStartTimer(Sender: TObject);
    procedure ButtonMakeKeyClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonDelClick(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure EditMakeKeyButtonClick(Sender: TObject);
    procedure ComboBoxQQChange(Sender: TObject);
    procedure ComboBoxSerialNumberChange(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    { Private declarations }
    procedure LoadList;
    procedure UnLoadList;
    procedure SaveToFile;
    procedure Add(sSerialNumber: string; nQQ, nSoftWare, nVersion: Integer);
    procedure Delete(sSerialNumber: string); overload;
    procedure Delete(nQQ: Integer); overload;
    procedure RefUserList;
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;
  g_SerialNumberList: TStringList;
  g_UserQQList: TStringList;
  g_nItemIndex: Integer;
  //g_ConfigOption: pTConfigOption;
const
  OwnerNumberArray: array[0..1] of Integer = (13677866, 623131686);
implementation
uses EncryptUnit, HUtil32, Common, MSI_CPU, MSI_Storage, MSI_Machine, MD5EncodeStr;
{$R *.dfm}

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
  sSerialNumber: string;
  sQQ: string;
  sKey: string; //机器码
  sSoftWare: string;
  sVersion: string;
  sDate: string;
begin
  if g_SerialNumberList <> nil then begin
    UnLoadList;
  end;
  g_SerialNumberList := TStringList.Create;
  g_UserQQList := TStringList.Create;

  sFileName := ExtractFilePath(Application.ExeName) + 'MakeKeyProcessor.txt';
  if FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    for I := 0 to LoadList.Count - 1 do begin
      sLineText := Trim(LoadList.Strings[I]);
      if (sLineText = '') or (sLineText[1] = ';') then Continue;
      sLineText := GetValidStr3(sLineText, sSerialNumber, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sQQ, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sSoftWare, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sVersion, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sDate, [' ', #9]);

      New(UserInfo);
      UserInfo.SerialNumber := sSerialNumber;
      UserInfo.QQ := StrToInt(sQQ);
      UserInfo.SoftWare := Str_ToInt(sSoftWare, -1);
      UserInfo.Version := Str_ToInt(sVersion, -1);
      UserInfo.Date := sDate;
      g_SerialNumberList.AddObject(sSerialNumber, TObject(UserInfo));
      g_UserQQList.AddObject(sQQ, TObject(UserInfo));
    end;
    LoadList.Free;
    RefUserList;
  end;
end;

procedure TFrmMain.RadioGroup1Click(Sender: TObject);
begin
  RadioGroup.Enabled := RadioGroup1.ItemIndex = 0;
  if not RadioGroup.Enabled then RadioGroup.ItemIndex := 0;
end;

procedure TFrmMain.RefUserList;
var
  ItemIndex: Integer;
begin
  ItemIndex := ComboBoxSerialNumber.ItemIndex;
  ComboBoxSerialNumber.Clear;
  ComboBoxSerialNumber.Items.AddStrings(g_SerialNumberList);
  if (ItemIndex >= 0) and (ItemIndex < ComboBoxSerialNumber.Items.Count) then
    ComboBoxSerialNumber.ItemIndex := ItemIndex;

  ItemIndex := ComboBoxQQ.ItemIndex;
  ComboBoxQQ.Clear;
  ComboBoxQQ.Items.AddStrings(g_UserQQList);
  if (ItemIndex >= 0) and (ItemIndex < ComboBoxQQ.Items.Count) then
    ComboBoxQQ.ItemIndex := ItemIndex;
end;

procedure TFrmMain.Add(sSerialNumber: string; nQQ, nSoftWare, nVersion: Integer);
var
  I, ItemIndex: Integer;
  UserInfo: pTUserInfo;
begin
  ItemIndex := ComboBoxSerialNumber.ItemIndex;
  if g_SerialNumberList <> nil then begin
    for I := 0 to g_SerialNumberList.Count - 1 do begin
      if CompareText(sSerialNumber, g_SerialNumberList.Strings[I]) = 0 then begin
        Application.MessageBox('该机器码已经存在 ！！！', '提示信息', MB_ICONQUESTION);
        Exit;
      end;
    end;
    New(UserInfo);
    UserInfo.SerialNumber := sSerialNumber;
    UserInfo.QQ := nQQ;
    UserInfo.SoftWare := nSoftWare;
    UserInfo.Version := nVersion;
    UserInfo.Date := GetDate(Date);

    g_SerialNumberList.AddObject(sSerialNumber, TObject(UserInfo));
    g_UserQQList.AddObject(IntToStr(nQQ), TObject(UserInfo));
    ComboBoxSerialNumber.Items.AddObject(sSerialNumber, TObject(UserInfo));
    ComboBoxQQ.Items.AddObject(IntToStr(nQQ), TObject(UserInfo));
    SaveToFile;
    Application.MessageBox('保存成功 ！！！', '提示信息', MB_ICONQUESTION);
  end;
end;

procedure TFrmMain.Delete(nQQ: Integer);
var
  I, II: Integer;
begin
  if g_UserQQList <> nil then begin
    for I := g_UserQQList.Count - 1 downto 0 do begin
      if pTUserInfo(g_UserQQList.Objects[I]).QQ = nQQ then begin
        for II := g_SerialNumberList.Count - 1 downto 0 do begin
          if g_SerialNumberList.Objects[II] = g_UserQQList.Objects[I] then begin
            g_SerialNumberList.Delete(II);
            break;
          end;
        end;
        Dispose(pTUserInfo(g_UserQQList.Objects[I]));
        g_UserQQList.Delete(I);
        SaveToFile;
        RefUserList;
        break;
      end;
    end;
  end;
end;

procedure TFrmMain.Delete(sSerialNumber: string);
var
  I, II: Integer;
begin
  if g_SerialNumberList <> nil then begin
    for I := 0 to g_SerialNumberList.Count - 1 do begin
      if CompareText(sSerialNumber, g_SerialNumberList.Strings[I]) = 0 then begin
        for II := 0 to g_UserQQList.Count - 1 do begin
          if g_SerialNumberList.Objects[I] = g_UserQQList.Objects[II] then begin
            g_UserQQList.Delete(II);
            break;
          end;
        end;
        Dispose(pTUserInfo(g_SerialNumberList.Objects[I]));
        g_SerialNumberList.Delete(I);
        SaveToFile;
        RefUserList;
        Application.MessageBox('删除成功 ！！！', '提示信息', MB_ICONQUESTION);
        break;
      end;
    end;
  end;
end;

procedure TFrmMain.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.ButtonDelClick(Sender: TObject);
var
  sSerialNumber: string;
begin
  sSerialNumber := Trim(ComboBoxSerialNumber.Text);
  if (sSerialNumber = '') and (Length(sSerialNumber) <> 32) then begin
    Application.MessageBox('请输入正确的机器码 ！！！', '提示信息', MB_ICONQUESTION);
    ComboBoxSerialNumber.SetFocus;
    Exit;
  end;
  Delete(sSerialNumber);
end;

procedure TFrmMain.ButtonMakeKeyClick(Sender: TObject);
var
  sMakeKey: string;
  sQQ: string;
  sSerialNumber: string;

  nLen: Integer;

  Count: Integer;
  MemoryStream: TMemoryStream;
  MakeInfo: TMakeInfo;
  MakeRegInfo: TMakeRegInfo;

  Buffer: Pointer;
  sText: string;

  nCRC: Cardinal;
  nSize: Integer;

  nSoftWare: Word;
  nVersion: Word;
begin
  sMakeKey := Trim(EditMakeKey.Text);
  sQQ := Trim(ComboBoxQQ.Text);
  sSerialNumber := Trim(ComboBoxSerialNumber.Text);
  nSoftWare := RadioGroup1.ItemIndex;
  nVersion := RadioGroup.ItemIndex;
  if nSoftWare = 1 then nVersion := 0;
  
  if not FileExists(sMakeKey) then begin
    Application.MessageBox('没有发现MakeKey.exe ！！！', '提示信息', MB_ICONQUESTION);
    ComboBoxSerialNumber.SetFocus;
    Exit;
  end;
  if nSoftWare < 0 then begin
    Application.MessageBox('请选择正确的软件类型！！！', '提示信息', MB_ICONQUESTION);
    RadioGroup1.SetFocus;
    Exit;
  end;
  if nVersion < 0 then begin
    Application.MessageBox('请选择正确的版本类型！！！', '提示信息', MB_ICONQUESTION);
    RadioGroup1.SetFocus;
    Exit;
  end;
  if (sQQ = '') or (not IsStringNumber(sQQ)) then begin
    Application.MessageBox('请输入正确的QQ ！！！', '提示信息', MB_ICONQUESTION);
    ComboBoxQQ.SetFocus;
    Exit;
  end;

  if (sSerialNumber = '') and (Length(sSerialNumber) <> 32) then begin
    Application.MessageBox('请输入正确的机器码 ！！！', '提示信息', MB_ICONQUESTION);
    ComboBoxSerialNumber.SetFocus;
    Exit;
  end;

  nLen := Length(EncryptBuffer(@MakeRegInfo, SizeOf(TMakeRegInfo)));

  MemoryStream := TMemoryStream.Create;
  MemoryStream.LoadFromFile(sMakeKey);
  MemoryStream.Seek(-(SizeOf(Integer) + nLen), soFromEnd);
  MemoryStream.Read(Count, SizeOf(Integer));

  GetMem(Buffer, nLen);
  try
    MemoryStream.Seek(-nLen, soFromEnd);
    MemoryStream.Read(Buffer^, nLen);
    SetLength(sText, nLen);
    Move(Buffer^, sText[1], nLen);
  finally
    FreeMem(Buffer);
  end;

  DecryptBuffer(sText, @MakeRegInfo, SizeOf(TMakeRegInfo));
  DecryptBuffer(MakeRegInfo.sBuffer, @MakeInfo, SizeOf(TMakeInfo));
  if (MakeRegInfo.sSerialNumber <> '') and (MakeRegInfo.sBuffer <> '') and
    (MakeRegInfo.nBuffer = StringCrc(MakeRegInfo.sBuffer)) and (MakeInfo.nSize = Count) then begin //MakeKey已经写入了用户信息
    Count := MemoryStream.Size - SizeOf(Integer) - nLen;

    GetMem(Buffer, Count);
    try
      MemoryStream.Seek(0, soFromBeginning);
      MemoryStream.Read(Buffer^, Count);
      nCRC := BufferCRC(Buffer, Count);
    finally
      FreeMem(Buffer);
    end;
    MakeInfo.nOwnerNumber := OwnerNumberArray[RadioGroup.ItemIndex];
    MakeInfo.nUserNumber := StrToInt(sQQ);
    MakeInfo.nSerialNumber := StringCrc(sSerialNumber);
    MakeInfo.nSize := Count;
    MakeInfo.nCrc := nCRC;
    MakeInfo.nVersion := MakeLong(nSoftWare, nVersion);
    MakeInfo.dDate := Date;
    MakeRegInfo.sBuffer := EncryptBuffer(@MakeInfo, SizeOf(TMakeInfo));
    MakeRegInfo.sSerialNumber := sSerialNumber;
    MakeRegInfo.nBuffer := StringCrc(MakeRegInfo.sBuffer);

    MemoryStream.Seek(Count + SizeOf(Integer), soFromBeginning);
    sText := EncryptBuffer(@MakeRegInfo, SizeOf(TMakeRegInfo));
    MemoryStream.Write(sText[1], Length(sText));

  end else begin //MakeKey没有写入了用户信息
    MemoryStream.Seek(0, soFromEnd);
    Count := MemoryStream.Size;

    GetMem(Buffer, Count);
    try
      MemoryStream.Seek(0, soFromBeginning);
      MemoryStream.Read(Buffer^, Count);
      nCRC := BufferCRC(Buffer, Count);
    finally
      FreeMem(Buffer);
    end;

    MakeInfo.nOwnerNumber := OwnerNumberArray[RadioGroup.ItemIndex];
    MakeInfo.nUserNumber := StrToInt(sQQ);
    MakeInfo.nSerialNumber := StringCrc(sSerialNumber);
    MakeInfo.nSize := Count;
    MakeInfo.nCrc := nCRC;
    MakeInfo.nVersion := MakeLong(nSoftWare, nVersion);
    MakeInfo.dDate := Date;
    MakeRegInfo.sBuffer := EncryptBuffer(@MakeInfo, SizeOf(TMakeInfo));
    MakeRegInfo.sSerialNumber := sSerialNumber;
    MakeRegInfo.nBuffer := StringCrc(MakeRegInfo.sBuffer);
    sText := EncryptBuffer(@MakeRegInfo, SizeOf(TMakeRegInfo));

    MemoryStream.Seek(0, soFromEnd);
    MemoryStream.Write(Count, SizeOf(Integer));
    MemoryStream.Write(sText[1], Length(sText));
  end;

  with SaveDialog do begin
    Filter := 'MakeKey|*.exe';
    {if FileName = '' then }FileName := 'MakeKey-' + sQQ + '.exe';
    //FileName := ExtractFilePath(FileName) + ExtractFileNameOnly(FileName) + '.exe';
    if Execute and (FileName <> '') then begin
      if ExtractFileExt(FileName) <> '.exe' then
        FileName := ExtractFilePath(FileName) + ExtractFileNameOnly(FileName) + '.exe';
      try
        MemoryStream.SaveToFile(FileName);
        Application.MessageBox('配制成功 ！！！', '提示信息', MB_ICONQUESTION);
      except
        on e: Exception do begin
          Application.MessageBox(PChar(e.Message), '错误信息', MB_ICONERROR);
        end;
      end;
    end;
  end;
  MemoryStream.Free;
end;

procedure TFrmMain.ButtonSaveClick(Sender: TObject);
var
  sQQ: string;
  sSerialNumber: string;
begin
  sQQ := Trim(ComboBoxQQ.Text);
  sSerialNumber := Trim(ComboBoxSerialNumber.Text);

  if (sQQ = '') or (not IsStringNumber(sQQ)) then begin
    Application.MessageBox('请输入正确的QQ ！！！', '提示信息', MB_ICONQUESTION);
    ComboBoxQQ.SetFocus;
    Exit;
  end;

  if (sSerialNumber = '') and (Length(sSerialNumber) <> 32) then begin
    Application.MessageBox('请输入正确的机器码 ！！！', '提示信息', MB_ICONQUESTION);
    ComboBoxSerialNumber.SetFocus;
    Exit;
  end;
  Add(sSerialNumber, StrToInt(sQQ), RadioGroup1.ItemIndex, RadioGroup.ItemIndex);
end;

procedure TFrmMain.ComboBoxQQChange(Sender: TObject);
var
  I, II: Integer;
  sQQ: string;
  nQQ: Integer;
  SerialNumberChange: TNotifyEvent;
begin
  sQQ := Trim(ComboBoxQQ.Text);
  if (sQQ <> '') and (IsStringNumber(sQQ)) then begin
    nQQ := StrToInt(sQQ);
    SerialNumberChange := ComboBoxSerialNumber.OnChange;
    ComboBoxSerialNumber.OnChange := nil;
    for I := 0 to ComboBoxQQ.Items.Count - 1 do begin
      if pTUserInfo(ComboBoxQQ.Items.Objects[I]).QQ = nQQ then begin
        for II := 0 to ComboBoxSerialNumber.Items.Count - 1 do begin
          if ComboBoxSerialNumber.Items.Objects[II] = ComboBoxQQ.Items.Objects[I] then begin
            ComboBoxSerialNumber.ItemIndex := II;
            break;
          end;
        end;
        RadioGroup.ItemIndex := pTUserInfo(ComboBoxQQ.Items.Objects[I]).Version;
        RadioGroup1.ItemIndex := pTUserInfo(ComboBoxQQ.Items.Objects[I]).SoftWare;
        LabelDate.Caption := '注册日期: ' + pTUserInfo(ComboBoxQQ.Items.Objects[I]).Date;
        ComboBoxQQ.ItemIndex := I;
        break;
      end;
    end;
    ComboBoxSerialNumber.OnChange := SerialNumberChange;
  end;
end;

procedure TFrmMain.ComboBoxSerialNumberChange(Sender: TObject);
var
  I, II: Integer;
  sSerialNumber: string;
  QQChange: TNotifyEvent;
begin
  sSerialNumber := Trim(ComboBoxSerialNumber.Text);
  if (Length(sSerialNumber) = 32) then begin
    QQChange := ComboBoxQQ.OnChange;
    ComboBoxQQ.OnChange := nil;
    for I := 0 to ComboBoxSerialNumber.Items.Count - 1 do begin
      if ComboBoxSerialNumber.Items.Strings[I] = sSerialNumber then begin
        for II := 0 to ComboBoxQQ.Items.Count - 1 do begin
          if ComboBoxQQ.Items.Objects[II] = ComboBoxSerialNumber.Items.Objects[I] then begin
            ComboBoxQQ.ItemIndex := II;
            break;
          end;
        end;
        RadioGroup.ItemIndex := pTUserInfo(ComboBoxSerialNumber.Items.Objects[I]).Version;
        RadioGroup1.ItemIndex := pTUserInfo(ComboBoxSerialNumber.Items.Objects[I]).SoftWare;
        ComboBoxSerialNumber.ItemIndex := I;
        LabelDate.Caption := '注册日期: ' + pTUserInfo(ComboBoxSerialNumber.Items.Objects[I]).Date;
        break;
      end;
    end;
    ComboBoxQQ.OnChange := QQChange;
  end;
end;

procedure TFrmMain.EditMakeKeyButtonClick(Sender: TObject);
var
  sMakeKey: string;
  sQQ: string;
  sSerialNumber: string;

  nLen: Integer;

  Count: Integer;
  MemoryStream: TMemoryStream;
  MakeInfo: TMakeInfo;
  MakeRegInfo: TMakeRegInfo;

  Buffer: Pointer;
  sText: string;

  nCRC: Cardinal;
  nSize: Integer;
begin
  OpenDialog.Filter := 'MakeKey|*.exe';
  if OpenDialog.Execute then begin
    EditMakeKey.Text := OpenDialog.FileName;
    sMakeKey := Trim(EditMakeKey.Text);

    MemoryStream := TMemoryStream.Create;
    try
      nLen := Length(EncryptBuffer(@MakeRegInfo, SizeOf(TMakeRegInfo)));
      MemoryStream.LoadFromFile(sMakeKey);
      MemoryStream.Seek(-(SizeOf(Integer) + nLen), soFromEnd);
      MemoryStream.Read(Count, SizeOf(Integer));

      GetMem(Buffer, nLen);
      try
        MemoryStream.Seek(-nLen, soFromEnd);
        MemoryStream.Read(Buffer^, nLen);
        SetLength(sText, nLen);
        Move(Buffer^, sText[1], nLen);
      finally
        FreeMem(Buffer);
      end;

      DecryptBuffer(sText, @MakeRegInfo, SizeOf(TMakeRegInfo));
      if MakeRegInfo.nBuffer = StringCrc(MakeRegInfo.sBuffer) then begin //MakeKey已经写入了用户信息
        DecryptBuffer(MakeRegInfo.sBuffer, @MakeInfo, SizeOf(TMakeInfo));
        ComboBoxQQ.Text := IntToStr(MakeInfo.nUserNumber);
        ComboBoxSerialNumber.Text := MakeRegInfo.sSerialNumber;
        RadioGroup1.ItemIndex := LoWord(MakeInfo.nVersion);
        RadioGroup.ItemIndex := HiWord(MakeInfo.nVersion);
        LabelDate.Caption := '注册日期: ' + GetDate(MakeInfo.dDate);
      end;
    except

    end;
  end;
end;

procedure TFrmMain.UnLoadList;
var
  I: Integer;
begin
  if g_SerialNumberList <> nil then begin
    for I := 0 to g_SerialNumberList.Count - 1 do begin
      Dispose(pTUserInfo(g_SerialNumberList.Objects[I]));
    end;
    FreeAndNil(g_SerialNumberList);
    FreeAndNil(g_UserQQList);
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
  if g_SerialNumberList <> nil then begin
    SaveList := TStringList.Create;
    for I := 0 to g_SerialNumberList.Count - 1 do begin
      UserInfo := pTUserInfo(g_SerialNumberList.Objects[I]);
      sLineText := UserInfo.SerialNumber + #9 + IntToStr(UserInfo.QQ) + #9 + IntToStr(UserInfo.SoftWare) + #9 + IntToStr(UserInfo.Version) + #9 + UserInfo.Date;
      SaveList.Add(sLineText);
    end;
    sFileName := ExtractFilePath(Application.ExeName) + 'MakeKeyProcessor.txt';
    try
      SaveList.SaveToFile(sFileName);
    except

    end;
    SaveList.Free;
  end;
end;

procedure TFrmMain.TimerStartTimer(Sender: TObject);
begin
  TimerStart.Enabled := False;
  LoadList;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  EditMakeKey.Text := ExtractFilePath(Application.ExeName) + 'MakeKey.exe';
  TimerStart.Enabled := True;
end;

end.

