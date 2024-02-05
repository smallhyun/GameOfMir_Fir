unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, RzBtnEdt, SDK, Common, EncryptUnit, Grobal2, HUtil32,
  ExtCtrls, IniFiles, RzPanel, RzRadGrp, Spin;

type
  TMakeConfigOption = record
    nUserQQNumber: Integer; //QQ号码
    nSerialNumber: Int64; //机器码
    nM2Size: Integer;
    nM2Crc: Cardinal;
    nVersion: Integer;
  end;
  pTMakeConfigOption = ^TMakeConfigOption;


  TfrmMain = class(TForm)
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
    Label1: TLabel;
    EditSellInfo: TEdit;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    ComboBoxQQ: TComboBox;
    Label9: TLabel;
    EditSerialNumber: TEdit;
    GroupBox3: TGroupBox;
    Label10: TLabel;
    EditM2ServerExe: TRzButtonEdit;
    ButtonM2Server: TButton;
    ButtonClose: TButton;
    ButtonSave: TButton;
    TimerStart: TTimer;
    Label12: TLabel;
    EditProductInfo: TEdit;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    RadioGroup: TRadioGroup;
    ButtonDel: TButton;
    Label11: TLabel;
    EditM2ServerDll: TRzButtonEdit;
    GroupBox4: TGroupBox;
    Label13: TLabel;
    EditNoticeInfo1: TEdit;
    EditNoticeInfo2: TEdit;
    Label14: TLabel;
    Label15: TLabel;
    EditTime1: TSpinEdit;
    EditTime2: TSpinEdit;
    Label18: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    EditNoticeInfo3: TEdit;
    EditNoticeInfo4: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure TimerStartTimer(Sender: TObject);
    procedure ComboBoxQQChange(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonM2ServerClick(Sender: TObject);
    procedure EditM2ServerExeButtonClick(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadConfig;
    procedure SaveConfig;
    procedure LoadUserQQ;
    function LoadUserLicense(nQQ: Integer; ConfigOption: pTConfigOption): Boolean;
    function SaveUserLicense(nQQ: Integer; ConfigOption: pTConfigOption): Boolean;
    function GetQQ(nQQ: Integer): Boolean;
    function AddQQ(nQQ: Integer): Boolean;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  g_UserQQList: TStringList;
  g_nItemIndex: Integer;
  //g_ConfigOption: pTConfigOption;
const
  OwnerNumberArray: array[0..1] of Integer = (13677866, 623131686);
implementation

{$R *.dfm}

function TfrmMain.AddQQ(nQQ: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to g_UserQQList.Count - 1 do begin
    if Integer(g_UserQQList.Objects[I]) = nQQ then Exit;
  end;
  g_UserQQList.AddObject(IntToStr(nQQ), TObject(nQQ));
  Result := True;
end;

function TfrmMain.GetQQ(nQQ: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to g_UserQQList.Count - 1 do begin
    if Integer(g_UserQQList.Objects[I]) = nQQ then begin
      Result := True;
      Exit;
    end;
  end;
end;

procedure TfrmMain.LoadConfig;
var
  Conf: TIniFile;
begin
  Conf := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  g_nItemIndex := Conf.ReadInteger('Setup', 'ItemIndex', 0);
  Conf.Free;
end;

procedure TfrmMain.SaveConfig;
var
  Conf: TIniFile;
begin
  Conf := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  Conf.WriteInteger('Setup', 'ItemIndex', g_nItemIndex);
  Conf.Free;
end;

function TfrmMain.LoadUserLicense(nQQ: Integer; ConfigOption: pTConfigOption): Boolean;
var
  Conf: TIniFile;
  sFileName: string;
  sKey: string;
  sSerialNumber: string;
  Buffer: PChar;
begin
  Result := False;
  if not DirectoryExists(ExtractFilePath(Application.ExeName) + 'UserLicense') then begin
    CreateDir(ExtractFilePath(Application.ExeName) + 'UserLicense');
  end;
  sFileName := ExtractFilePath(Application.ExeName) + 'UserLicense\' + IntToStr(nQQ) + '.ini';
  if FileExists(sFileName) then begin
    Conf := TIniFile.Create(sFileName);
    ConfigOption.nUserNumber := nQQ; //QQ号码
    ConfigOption^.sSerialNumber := Trim(Conf.ReadString('Setup', 'SerialNumber', '')); //机器码
    ConfigOption^.nSize := 0;
    ConfigOption^.nCrc := 0;
    ConfigOption^.nVersion := Conf.ReadInteger('Setup', 'HeroVersion', 0);
    ConfigOption^.sVersion := Conf.ReadString('Setup', 'Version', '');
    ConfigOption^.sUpDateTime := Conf.ReadString('Setup', 'UpDateTime', '');
    ConfigOption^.sProductName := Conf.ReadString('Setup', 'ProductName', '');
    ConfigOption^.sProgram := Conf.ReadString('Setup', 'Program', '');
    ConfigOption^.sWebSite := Conf.ReadString('Setup', 'WebSite', '');
    ConfigOption^.sBbsSite := Conf.ReadString('Setup', 'BbsSite', '');
    ConfigOption^.sProductInfo := Conf.ReadString('Setup', 'ProductInfo', '');
    ConfigOption^.sSellInfo1 := Conf.ReadString('Setup', 'SellInfo', '');
    ConfigOption^.sNoticeInfo1 := Conf.ReadString('Setup', 'NoticeInfo1', '');
    ConfigOption^.sNoticeInfo2 := Conf.ReadString('Setup', 'NoticeInfo2', '');
    ConfigOption^.sNoticeInfo3 := Conf.ReadString('Setup', 'NoticeInfo3', '');
    ConfigOption^.sNoticeInfo4 := Conf.ReadString('Setup', 'NoticeInfo4', '');
    ConfigOption^.nNoticeTime1 := Conf.ReadInteger('Setup', 'NoticeTime1', 60);
    ConfigOption^.nNoticeTime2 := Conf.ReadInteger('Setup', 'NoticeTime2', 60);

    Conf.Free;
    Result := True;
  end;
end;

function TfrmMain.SaveUserLicense(nQQ: Integer; ConfigOption: pTConfigOption): Boolean;
var
  Conf: TIniFile;
  sFileName: string;
  sSerialNumber: string;
begin
  Result := False;
  if not DirectoryExists(ExtractFilePath(Application.ExeName) + 'UserLicense') then begin
    CreateDir(ExtractFilePath(Application.ExeName) + 'UserLicense');
  end;
  AddQQ(nQQ);
  sFileName := ExtractFilePath(Application.ExeName) + 'UserLicense\' + IntToStr(nQQ) + '.ini';
  Conf := TIniFile.Create(sFileName);
  //Showmessage('TfrmMain.SaveUserLicense:'+ConfigOption.sSerialNumber);
  Conf.WriteString('Setup', 'SerialNumber', ConfigOption.sSerialNumber);
  Conf.WriteInteger('Setup', 'HeroVersion', ConfigOption.nVersion);
  Conf.WriteString('Setup', 'Version', ConfigOption.sVersion);
  Conf.WriteString('Setup', 'UpDateTime', ConfigOption.sUpDateTime);
  Conf.WriteString('Setup', 'ProductName', ConfigOption.sProductName);
  Conf.WriteString('Setup', 'Program', ConfigOption.sProgram);
  Conf.WriteString('Setup', 'WebSite', ConfigOption.sWebSite);
  Conf.WriteString('Setup', 'BbsSite', ConfigOption.sBbsSite);
  Conf.WriteString('Setup', 'ProductInfo', ConfigOption.sProductInfo);
  Conf.WriteString('Setup', 'SellInfo', ConfigOption.sSellInfo1);
  Conf.WriteString('Setup', 'NoticeInfo1', ConfigOption.sNoticeInfo1);
  Conf.WriteString('Setup', 'NoticeInfo2', ConfigOption.sNoticeInfo2);
  Conf.WriteString('Setup', 'NoticeInfo3', ConfigOption.sNoticeInfo3);
  Conf.WriteString('Setup', 'NoticeInfo4', ConfigOption.sNoticeInfo4);
  Conf.WriteInteger('Setup', 'NoticeTime1', ConfigOption.nNoticeTime1);
  Conf.WriteInteger('Setup', 'NoticeTime2', ConfigOption.nNoticeTime2);
  //Conf.WriteBool('Setup', 'ShareAllow', ConfigOption.boShareAllow);
  //Conf.WriteString('Setup', 'KEY', ConfigOption.sKey);
  Conf.Free;
  {Conf.WriteString('Setup', 'ShareCount', ConfigOption.sUserCount);
  Conf.WriteString('Setup', 'ShareDay', ConfigOption.sUseDay);  }

  sFileName := ExtractFilePath(Application.ExeName) + 'QQ.txt';
  g_UserQQList.SaveToFile(sFileName);
  Result := True;
end;

procedure TfrmMain.LoadUserQQ;
var
  I: Integer;
  LoadList: TStringList;
  sFileName: string;
  sQQ: string;
begin
  g_UserQQList.Clear;
  sFileName := ExtractFilePath(Application.ExeName) + 'QQ.txt';
  if FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    for I := 0 to LoadList.Count - 1 do begin
      sQQ := Trim(LoadList.Strings[I]);
      if (sQQ = '') or (sQQ[1] = ';') or (not IsStringNumber(sQQ)) then Continue;
      AddQQ(StrToInt(sQQ));
    end;
    LoadList.Free;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  g_UserQQList := TStringList.Create;
  EditM2ServerExe.Text := ExtractFilePath(Application.ExeName) + 'M2Server.exe';
  EditM2ServerDll.Text := ExtractFilePath(Application.ExeName) + 'M2Server.dll';
  LoadConfig;
  TimerStart.Enabled := True;
end;

procedure TfrmMain.TimerStartTimer(Sender: TObject);
begin
  TimerStart.Enabled := False;
  LoadUserQQ;
  ComboBoxQQ.Items.Clear;
  ComboBoxQQ.Items.AddStrings(g_UserQQList);
  if (g_nItemIndex >= 0) and (ComboBoxQQ.Items.Count > 0) and (g_nItemIndex < ComboBoxQQ.Items.Count) then begin
    ComboBoxQQ.ItemIndex := g_nItemIndex;
    ComboBoxQQChange(nil);
  end;
end;

procedure TfrmMain.ComboBoxQQChange(Sender: TObject);
var
  sQQ: string;
  nQQ: Integer;
  ConfigOption: TConfigOption;
begin
  sQQ := Trim(ComboBoxQQ.Text);
  nQQ := Str_ToInt(sQQ, -1);
  if nQQ < 0 then Exit;
  if GetQQ(nQQ) then begin
    g_nItemIndex := ComboBoxQQ.ItemIndex;
    if LoadUserLicense(nQQ, @ConfigOption) then begin
      EditSerialNumber.Text := ConfigOption.sSerialNumber;
      EditProductName.Text := ConfigOption.sProductName;
      EditVersion.Text := ConfigOption.sVersion;
      EditUpDateTime.Text := ConfigOption.sUpDateTime;
      EditProgram.Text := ConfigOption.sProgram;
      EditWebSite.Text := ConfigOption.sWebSite;
      EditBbsSite.Text := ConfigOption.sBbsSite;
      EditProductInfo.Text := ConfigOption.sProductInfo;
      EditSellInfo.Text := ConfigOption.sSellInfo1;
      EditNoticeInfo1.Text := ConfigOption.sNoticeInfo1;
      EditNoticeInfo2.Text := ConfigOption.sNoticeInfo2;
      EditNoticeInfo3.Text := ConfigOption.sNoticeInfo3;
      EditNoticeInfo4.Text := ConfigOption.sNoticeInfo4;
      EditTime1.Value := ConfigOption.nNoticeTime1;
      EditTime2.Value := ConfigOption.nNoticeTime2;
      RadioGroup.ItemIndex := ConfigOption.nVersion;

      SaveConfig;
    end;
  end;
end;

procedure TfrmMain.ButtonSaveClick(Sender: TObject);
var
  sQQ: string;
  sSerialNumber: string;
  sVersion: string;
  sUpDateTime: string;
  sProductName: string;
  sProgram: string;
  sWebSite: string;
  sBbsSite: string;
  sProductInfo: string;
  sSellInfo1: string;
  sNoticeInfo1: string;
  sNoticeInfo2: string;
  sNoticeInfo3: string;
  sNoticeInfo4: string;
  nNoticeTime1: Integer;
  nNoticeTime2: Integer;
  boShareAllow: Boolean;
  nUserCount: Integer;
  nUseDay: Integer;

  ConfigOption: TConfigOption;

  Buffer: PChar;
begin
  sQQ := Trim(ComboBoxQQ.Text);
  sSerialNumber := Trim(EditSerialNumber.Text);
  sVersion := Trim(EditVersion.Text);
  sUpDateTime := Trim(EditUpDateTime.Text);
  sProductName := Trim(EditProductName.Text);
  sProgram := Trim(EditProgram.Text);
  sWebSite := Trim(EditWebSite.Text);
  sBbsSite := Trim(EditBbsSite.Text);
  sProductInfo := Trim(EditProductInfo.Text);
  sSellInfo1 := Trim(EditSellInfo.Text);
  sNoticeInfo1 := Trim(EditNoticeInfo1.Text);
  sNoticeInfo2 := Trim(EditNoticeInfo2.Text);
  sNoticeInfo3 := Trim(EditNoticeInfo3.Text);
  sNoticeInfo4 := Trim(EditNoticeInfo4.Text);
  nNoticeTime1 := EditTime1.Value;
  nNoticeTime2 := EditTime2.Value;

  if (sQQ = '') or (not IsStringNumber(sQQ)) then begin
    Application.MessageBox('请输入正确的QQ ！！！', '提示信息', MB_ICONQUESTION);
    ComboBoxQQ.SetFocus;
    Exit;
  end;
  if (sSerialNumber = '') and (Length(sSerialNumber) <> 32) then begin
    Application.MessageBox('请输入正确的机器码 ！！！', '提示信息', MB_ICONQUESTION);
    ComboBoxQQ.SetFocus;
    Exit;
  end;
  if (sNoticeInfo1 = '') and (sNoticeInfo1 = '') then begin
    Application.MessageBox('最少要有一个广告信息 ！！！', '提示信息', MB_ICONQUESTION);
    EditNoticeInfo1.SetFocus;
    Exit;
  end;
  ConfigOption.sSerialNumber := sSerialNumber;
  ConfigOption.nVersion := RadioGroup.ItemIndex;
  ConfigOption.sProductName := sProductName;
  ConfigOption.sVersion := sVersion;
  ConfigOption.sUpDateTime := sUpDateTime;
  ConfigOption.sProgram := sProgram;
  ConfigOption.sWebSite := sWebSite;
  ConfigOption.sBbsSite := sBbsSite;
  ConfigOption.sProductInfo := sProductInfo;
  ConfigOption.sSellInfo1 := sSellInfo1;
  ConfigOption.sNoticeInfo1 := sNoticeInfo1;
  ConfigOption.sNoticeInfo2 := sNoticeInfo2;
  ConfigOption.sNoticeInfo3 := sNoticeInfo3;
  ConfigOption.sNoticeInfo4 := sNoticeInfo4;
  ConfigOption.nNoticeTime1 := nNoticeTime1;
  ConfigOption.nNoticeTime2 := nNoticeTime2;

  SaveUserLicense(StrToInt(sQQ), @ConfigOption);
  ComboBoxQQ.Text := sQQ;
  //ComboBoxQQChange(Self);
  TimerStart.Enabled := True;
  Application.MessageBox('保存成功 ！！！', '提示信息', MB_ICONQUESTION);
end;

procedure TfrmMain.ButtonM2ServerClick(Sender: TObject);
var
  sM2ServerEXE: string;
  sM2ServerDLL: string;
  sQQ: string;
  sSerialNumber: string;
  sVersion: string;
  sUpDateTime: string;
  sProductName: string;
  sProgram: string;
  sWebSite: string;
  sBbsSite: string;
  sProductInfo: string;
  sSellInfo1: string;
  sNoticeInfo1: string;
  sNoticeInfo2: string;
  sNoticeInfo3: string;
  sNoticeInfo4: string;
  nNoticeTime1: Integer;
  nNoticeTime2: Integer;
  sMark: string;

  boShareAllow: Boolean;
  nUserCount: Integer;
  nUseDay: Integer;

  nVersion: Integer;
  nLen: Integer;
  nM2: Integer;

  nDllSize, nDllCrc: Cardinal;

  Count: Integer;
  MemoryStream: TMemoryStream;
  M2ServerDLLStream: TMemoryStream;
  ConfigOption: TConfigOption;

  Buffer: Pointer;
  Buff: PChar;
  sText: string;
  sKey: string;
  nCRC: Cardinal;
begin
  RadioGroup.ItemIndex := 1;
//  Showmessage(IntToStr(ConfigOptionSize));
  sM2ServerEXE := Trim(EditM2ServerExe.Text);
  sM2ServerDLL := Trim(EditM2ServerDll.Text);
  sQQ := Trim(ComboBoxQQ.Text);
  sSerialNumber := Trim(EditSerialNumber.Text);
  sVersion := Trim(EditVersion.Text);
  sUpDateTime := Trim(EditUpDateTime.Text);
  sProductName := Trim(EditProductName.Text);
  sProgram := Trim(EditProgram.Text);
  sWebSite := Trim(EditWebSite.Text);
  sBbsSite := Trim(EditBbsSite.Text);
  sProductInfo := Trim(EditProductInfo.Text);
  sSellInfo1 := Trim(EditSellInfo.Text);
  sNoticeInfo1 := Trim(EditNoticeInfo1.Text);
  sNoticeInfo2 := Trim(EditNoticeInfo2.Text);
  sNoticeInfo3 := Trim(EditNoticeInfo3.Text);
  sNoticeInfo4 := Trim(EditNoticeInfo4.Text);
  nNoticeTime1 := EditTime1.Value;
  nNoticeTime2 := EditTime2.Value;

  nVersion := RadioGroup.ItemIndex;

  if not FileExists(sM2ServerEXE) then begin
    Application.MessageBox('没有发现M2Server.exe ！！！', '提示信息', MB_ICONQUESTION);
    EditM2ServerExe.SetFocus;
    Exit;
  end;
  if not FileExists(sM2ServerDLL) then begin
    Application.MessageBox('没有发现M2Server.DLL ！！！', '提示信息', MB_ICONQUESTION);
    EditM2ServerDLL.SetFocus;
    Exit;
  end;
  if (sQQ = '') or (not IsStringNumber(sQQ)) then begin
    Application.MessageBox('请输入正确的QQ ！！！', '提示信息', MB_ICONQUESTION);
    ComboBoxQQ.SetFocus;
    Exit;
  end;
  if (sSerialNumber = '') and (Length(sSerialNumber) <> 32) then begin
    Application.MessageBox('请输入正确的机器码 ！！！', '提示信息', MB_ICONQUESTION);
    ComboBoxQQ.SetFocus;
    Exit;
  end;
  if (sNoticeInfo1 = '') and (sNoticeInfo1 = '') then begin
    Application.MessageBox('最少要有一个广告信息 ！！！', '提示信息', MB_ICONQUESTION);
    EditNoticeInfo1.SetFocus;
    Exit;
  end;

  M2ServerDLLStream := TMemoryStream.Create;
  M2ServerDLLStream.LoadFromFile(sM2ServerDLL);
  nDllSize := M2ServerDLLStream.Size;
  GetMem(Buffer, nDllSize);
  try
    M2ServerDLLStream.Seek(0, soFromBeginning);
    M2ServerDLLStream.Read(Buffer^, nDllSize);
    nDllCrc := BufferCRC(Buffer, nDllSize);
  finally
    FreeMem(Buffer);
  end;
  M2ServerDLLStream.Free;

  nLen := Length(EncryptBuffer(@ConfigOption, SizeOf(TConfigOption)));
  MemoryStream := TMemoryStream.Create;
  MemoryStream.LoadFromFile(sM2ServerEXE);
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

  DecryptBuffer(sText, @ConfigOption, SizeOf(TConfigOption));
  Count := MemoryStream.Size - SizeOf(Integer) - nLen;
  GetMem(Buffer, Count);
  try
    MemoryStream.Seek(0, soFromBeginning);
    MemoryStream.Read(Buffer^, Count);
    nCRC := BufferCRC(Buffer, Count);
  finally
    FreeMem(Buffer);
  end;
  if (nCRC = ConfigOption.nCrc) and (ConfigOption.nSize = Count) then begin //M2Server已经写入了用户信息
    ConfigOption.nCrc := nCRC;
    ConfigOption.nSize := Count;
    ConfigOption.nDllSize := nDllSize;
    ConfigOption.nDllCrc := nDllCrc;

    ConfigOption.nVersion := MakeLong(SOFTWARE_M2SERVER, nVersion);
    ConfigOption.nOwnerNumber := OwnerNumberArray[RadioGroup.ItemIndex];
    ConfigOption.nUserNumber := StrToInt(sQQ);
    ConfigOption.sSerialNumber := sSerialNumber;
    ConfigOption.nMakeKey := StringCrc(sSerialNumber);

    ConfigOption.sProductName := sProductName;
    ConfigOption.sVersion := sVersion;
    ConfigOption.sUpDateTime := sUpDateTime;
    ConfigOption.sProgram := sProgram;
    ConfigOption.sWebSite := sWebSite;
    ConfigOption.sBbsSite := sBbsSite;
    ConfigOption.sProductInfo := sProductInfo;
    ConfigOption.sSellInfo1 := sSellInfo1;
    ConfigOption.sNoticeInfo1 := sNoticeInfo1;
    ConfigOption.sNoticeInfo2 := sNoticeInfo2;
    ConfigOption.sNoticeInfo3 := sNoticeInfo3;
    ConfigOption.sNoticeInfo4 := sNoticeInfo4;

    ConfigOption.nNoticeTime1 := nNoticeTime1;
    ConfigOption.nNoticeTime2 := nNoticeTime2;

    MemoryStream.Seek(Count + SizeOf(Integer), soFromBeginning);
    sText := EncryptBuffer(@ConfigOption, SizeOf(TConfigOption));
    MemoryStream.Write(sText[1], Length(sText));
  end else begin //M2Server没有写入了用户信息
    Count := MemoryStream.Size;

    GetMem(Buffer, Count);
    try
      MemoryStream.Seek(0, soFromBeginning);
      MemoryStream.Read(Buffer^, Count);
      nCRC := BufferCRC(Buffer, Count);
    finally
      FreeMem(Buffer);
    end;

    MemoryStream.Seek(0, soFromEnd);
    MemoryStream.Write(Count, SizeOf(Integer));

    ConfigOption.nSize := Count;
    ConfigOption.nCrc := nCRC;
    ConfigOption.nDllSize := nDllSize;
    ConfigOption.nDllCrc := nDllCrc;

    ConfigOption.nVersion := MakeLong(SOFTWARE_M2SERVER, nVersion);
    ConfigOption.nOwnerNumber := OwnerNumberArray[RadioGroup.ItemIndex];
    ConfigOption.nUserNumber := StrToInt(sQQ);
    ConfigOption.sSerialNumber := sSerialNumber;
    ConfigOption.nMakeKey := StringCrc(sSerialNumber);
    ConfigOption.sProductName := sProductName;
    ConfigOption.sVersion := sVersion;
    ConfigOption.sUpDateTime := sUpDateTime;
    ConfigOption.sProgram := sProgram;
    ConfigOption.sWebSite := sWebSite;
    ConfigOption.sBbsSite := sBbsSite;
    ConfigOption.sProductInfo := sProductInfo;
    ConfigOption.sSellInfo1 := sSellInfo1;
    ConfigOption.sNoticeInfo1 := sNoticeInfo1;
    ConfigOption.sNoticeInfo2 := sNoticeInfo2;
    ConfigOption.sNoticeInfo3 := sNoticeInfo3;
    ConfigOption.sNoticeInfo4 := sNoticeInfo4;

    ConfigOption.nNoticeTime1 := nNoticeTime1;
    ConfigOption.nNoticeTime2 := nNoticeTime2;

    sText := EncryptBuffer(@ConfigOption, SizeOf(TConfigOption));
    MemoryStream.Write(sText[1], Length(sText));
  end;

  with SaveDialog do begin
    Filter := 'M2Server|*.exe';
    {if FileName = '' then } FileName := 'M2Server-' + sQQ + '.exe';
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

function LoadM2License(sFileName: string; ConfigOption: pTConfigOption): Boolean;
var
  nLen: Integer;
  Count: Integer;
  MemoryStream: TMemoryStream;

  Buffer: Pointer;
  sText: string;
  nCRC: Cardinal;
begin
  Result := False;
  nLen := Length(EncryptBuffer(@(ConfigOption^), SizeOf(TConfigOption)));
  MemoryStream := TMemoryStream.Create;
  MemoryStream.LoadFromFile(sFileName);

  MemoryStream.Seek(-(SizeOf(Integer) + nLen), soFromEnd);
  MemoryStream.Read(Count, SizeOf(Integer));

  GetMem(Buffer, nLen);
  try
    MemoryStream.Read(Buffer^, nLen);
    SetLength(sText, nLen);
    Move(Buffer^, sText[1], nLen);
  finally
    FreeMem(Buffer);
  end;

  DecryptBuffer(sText, @(ConfigOption^), SizeOf(TConfigOption));
  Count := MemoryStream.Size - SizeOf(Integer) - nLen;
  GetMem(Buffer, Count);
  try
    MemoryStream.Seek(0, soFromBeginning);
    MemoryStream.Read(Buffer^, Count);
    nCRC := BufferCRC(Buffer, Count);
  finally
    FreeMem(Buffer);
  end;

  if (nCRC = ConfigOption.nCrc) and (ConfigOption.nSize = Count) then begin
        {g_nUserLicense := ConfigOption.nUserQQNumber;
        g_sUserQQKey := EncryptString(IntToStr(ConfigOption.nUserQQNumber));
        g_nSerialNumber := ConfigOption.nSerialNumber;
        g_sVersion := EncryptString(ConfigOption.sVersion);
        g_sUpDateTime := EncryptString(ConfigOption.sUpDateTime);
        g_sProductName := EncryptString(ConfigOption.sProductName);
        g_sProgram := EncryptString(ConfigOption.sProgram);
        g_sWebSite := EncryptString(ConfigOption.sWebSite);
        g_sBbsSite := EncryptString(ConfigOption.sBbsSite);
        g_sProductInfo := EncryptString(ConfigOption.sProductInfo);
        g_sSellInfo1 := EncryptString(ConfigOption.sSellInfo1);   }
    Result := True;
  end;
  MemoryStream.Free;
end;

procedure TfrmMain.EditM2ServerExeButtonClick(Sender: TObject);
var
  ConfigOption: TConfigOption;
begin
  OpenDialog.Filter := 'M2Server|*.exe';
  if OpenDialog.Execute then begin
    if LoadM2License(OpenDialog.FileName, @ConfigOption) then begin
      ComboBoxQQ.Text := IntToStr(ConfigOption.nUserNumber);
      EditSerialNumber.Text := ConfigOption.sSerialNumber;
      EditProductName.Text := ConfigOption.sProductName;
      EditVersion.Text := ConfigOption.sVersion;
      EditUpDateTime.Text := ConfigOption.sUpDateTime;
      EditProgram.Text := ConfigOption.sProgram;
      EditWebSite.Text := ConfigOption.sWebSite;
      EditBbsSite.Text := ConfigOption.sBbsSite;
      EditProductInfo.Text := ConfigOption.sProductInfo;
      EditSellInfo.Text := ConfigOption.sSellInfo1;
      EditNoticeInfo1.Text := ConfigOption.sNoticeInfo1;
      EditNoticeInfo2.Text := ConfigOption.sNoticeInfo2;
      EditNoticeInfo3.Text := ConfigOption.sNoticeInfo3;
      EditNoticeInfo4.Text := ConfigOption.sNoticeInfo4;
      EditTime1.Value := ConfigOption.nNoticeTime1;
      EditTime2.Value := ConfigOption.nNoticeTime2;
      RadioGroup.ItemIndex := HiWord(ConfigOption.nVersion);
    end;
    EditM2ServerExe.Text := OpenDialog.FileName;
  end;
end;

procedure TfrmMain.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

end.

