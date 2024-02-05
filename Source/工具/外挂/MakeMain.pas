unit MakeMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, EncryptUnit, HUtil32, CShare, Mask, RzEdit, RzBtnEdt,
  ComCtrls;

type
  TFrmMain = class(TForm)
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    EditLinkName: TEdit;
    EditCaption: TEdit;
    EditHomePage: TEdit;
    ButtonOK: TButton;
    ButtonClose: TButton;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    EditCqfirDllFile: TRzButtonEdit;
    EditHookDllFile: TRzButtonEdit;
    EditCqfirFile: TRzButtonEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    EditHost: TEdit;
    ListBoxHosts: TListBox;
    RzButtonAddHost: TButton;
    RzButtonDelHost: TButton;
    Memo: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure ButtonOpenCqfirDllFileClick(Sender: TObject);
    procedure ButtonOpenHookDllFileClick(Sender: TObject);
    procedure ButtonOpenClick(Sender: TObject);
    procedure ListBoxHostsClick(Sender: TObject);
    procedure RzButtonAddHostClick(Sender: TObject);
    procedure RzButtonDelHostClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

procedure TFrmMain.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.ButtonOKClick(Sender: TObject);
var
  sCqfirDllFile, sHookDllFile, sCqfirFile, sLinkName, sHomePage, sCaption, sCqfirData, sHost: string;
  CqfirFile: TMemoryStream;
  CqfirDllFile: TMemoryStream;
  HookDllFile: TMemoryStream;

  CqfirData: TCqfirData;
  I, nSize, nCqfirData: Integer;
  nCqfirDllFile: Integer;
  nHookDllFile: Integer;
  nCqfirFileCrc: Integer;
  nCqfirDllFileCrc: Integer;
  nHookDllFileCrc: Integer;
  Buffer: Pointer;
begin
  sCqfirFile := Trim(EditCqfirFile.Text);
  sCqfirDllFile := Trim(EditCqfirDllFile.Text);
  sHookDllFile := Trim(EditHookDllFile.Text);
  sHomePage := Trim(EditHomePage.Text);
  sCaption := Trim(EditCaption.Text);
  sLinkName := Trim(EditLinkName.Text);
  if not FileExists(sCqfirDllFile) then begin
    Application.MessageBox('请选择正确的Cqfir.dll ！！！', '提示信息', MB_ICONQUESTION);
    EditCqfirDllFile.SetFocus;
    Exit;
  end;
  if not FileExists(sHookDllFile) then begin
    Application.MessageBox('请选择正确的Hook.dll ！！！', '提示信息', MB_ICONQUESTION);
    EditHookDllFile.SetFocus;
    Exit;
  end;

  if not FileExists(sCqfirFile) then begin
    Application.MessageBox('请选择正确的外挂文件 ！！！', '提示信息', MB_ICONQUESTION);
    EditCqfirFile.SetFocus;
    Exit;
  end;
  if sHomePage = '' then begin
    Application.MessageBox('请输入官方网站地址 ！！！', '提示信息', MB_ICONQUESTION);
    EditHomePage.SetFocus;
    Exit;
  end;
  if sCaption = '' then begin
    Application.MessageBox('请输入外挂标题 ！！！', '提示信息', MB_ICONQUESTION);
    EditCaption.SetFocus;
    Exit;
  end;
  if sLinkName = '' then begin
    Application.MessageBox('请输入快捷方式 ！！！', '提示信息', MB_ICONQUESTION);
    EditLinkName.SetFocus;
    Exit;
  end;
  ButtonOK.Enabled := False;

  sCqfirData := EncryptBuffer(@CqfirData, SizeOf(TCqfirData));
  nCqfirData := Length(sCqfirData);

  CqfirDllFile := TMemoryStream.Create;
  HookDllFile := TMemoryStream.Create;

  CqfirDllFile.LoadFromFile(sCqfirDllFile);
  HookDllFile.LoadFromFile(sHookDllFile);

  nCqfirDllFile := CqfirDllFile.Size;
  nHookDllFile := HookDllFile.Size;

  GetMem(Buffer, nCqfirDllFile);
  try
    CqfirDllFile.Seek(0, soFromBeginning);
    CqfirDllFile.Read(Buffer^, nCqfirDllFile);
    nCqfirDllFileCrc := CalcBufferCRC(Buffer, nCqfirDllFile);
  finally
    FreeMem(Buffer);
  end;

  GetMem(Buffer, nHookDllFile);
  try
    HookDllFile.Seek(0, soFromBeginning);
    HookDllFile.Read(Buffer^, nHookDllFile);
    nHookDllFileCrc := CalcBufferCRC(Buffer, nHookDllFile);
  finally
    FreeMem(Buffer);
  end;

  CqfirFile := TMemoryStream.Create;
  CqfirFile.LoadFromFile(sCqfirFile);

  CqfirFile.Seek(-SizeOf(Integer), soFromEnd);
  CqfirFile.Read(nSize, SizeOf(Integer));

  if nSize = CqfirFile.Size then begin
    GetMem(Buffer, nCqfirData);
    try
      SetLength(sCqfirData, nCqfirData);
      CqfirFile.Seek(-(SizeOf(Integer) + nCqfirData), soFromEnd);
      CqfirFile.Read(Buffer^, nCqfirData);
      Move(Buffer^, sCqfirData[1], nCqfirData);
    finally
      FreeMem(Buffer);
    end;

    DecryptBuffer(sCqfirData, @CqfirData, SizeOf(TCqfirData));
    nSize := CqfirFile.Size - SizeOf(Integer) - nCqfirData - CqfirData.nCqfirSize - CqfirData.nHookSize;
    GetMem(Buffer, nSize);
    try
      CqfirFile.Seek(0, soFromBeginning);
      CqfirFile.Read(Buffer^, nSize);
      CqfirFile.Clear;
      CqfirFile.Seek(0, soFromBeginning);
      CqfirFile.Write(Buffer^, nSize);
    finally
      FreeMem(Buffer);
    end;
  end;

  nSize := CqfirFile.Size;
  GetMem(Buffer, nSize);
  try
    CqfirFile.Seek(0, soFromBeginning);
    CqfirFile.Read(Buffer^, nSize);
    nCqfirFileCrc := CalcBufferCRC(Buffer, nSize);
  finally
    FreeMem(Buffer);
  end;

  CqfirData.LinkName := EncryptString(sLinkName);
  CqfirData.nLinkName := HashPJW(CqfirData.LinkName);
  CqfirData.Caption := sCaption;
  CqfirData.nCaption := HashPJW(CqfirData.Caption);
  CqfirData.Address := EncryptString(sHomePage);
  CqfirData.nAddress := HashPJW(CqfirData.Address);
  CqfirData.nSelfCrc := nCqfirFileCrc;
  CqfirData.nCqfirCrc := nCqfirDllFileCrc;
  CqfirData.nHookCrc := nHookDllFileCrc;
  CqfirData.nSelfSize := CqfirFile.Size;
  CqfirData.nCqfirSize := nCqfirDllFile;
  CqfirData.nHookSize := nHookDllFile;

  FillChar(CqfirData.Hosts, SizeOf(TShortStrings), #0);

  for I := 0 to ListBoxHosts.Items.Count - 1 do begin
    sHost := ListBoxHosts.Items.Strings[I];
    if sHost <> '' then begin
      //sHost := EncryptString(sHost);
      CqfirData.Hosts[I] := sHost;
      //Move(sHost[1], CqfirData.Hosts[I].Text, SizeOf(TTitle));
    end;
  end;

  FillChar(CqfirData.JumpText, SizeOf(CqfirData.JumpText), #0);

  for I := 0 to Memo.Lines.Count - 1 do begin
    if I > 9 then break;
    sHost := Memo.Lines.Strings[I];
    if sHost <> '' then begin
      //sHost := EncryptString(sHost);
      CqfirData.JumpText[I] := sHost;
      //Move(sHost[1], CqfirData.Hosts[I].Text, SizeOf(TTitle));
    end;
  end;

  try
    Memo.Lines.SaveToFile('.\JumpText.txt');
  except

  end;

//===============================写入Cqfir.dll==================================
  GetMem(Buffer, CqfirData.nCqfirSize);
  try
    CqfirDllFile.Seek(0, soFromBeginning);
    CqfirDllFile.Read(Buffer^, CqfirData.nCqfirSize);
    CqfirFile.Seek(0, soFromEnd);
    CqfirFile.Write(Buffer^, CqfirData.nCqfirSize);
  finally
    FreeMem(Buffer);
  end;

//===============================写入Hook.dll===================================
  GetMem(Buffer, CqfirData.nHookSize);
  try
    HookDllFile.Seek(0, soFromBeginning);
    HookDllFile.Read(Buffer^, CqfirData.nHookSize);
    CqfirFile.Seek(0, soFromEnd);
    CqfirFile.Write(Buffer^, CqfirData.nHookSize);
  finally
    FreeMem(Buffer);
  end;
//=========================写入配制信息TCqfirData===============================
  sCqfirData := EncryptBuffer(@CqfirData, SizeOf(TCqfirData));
  CqfirFile.Seek(0, soFromEnd);
  CqfirFile.Write(sCqfirData[1], nCqfirData);
//===============================写入总大小=====================================
  nSize := CqfirFile.Size + SizeOf(Integer);
  CqfirFile.Write(nSize, SizeOf(Integer));
//===================================写入完成===================================

  with SaveDialog do begin
    if FileName = '' then FileName := 'CqFir';
    //FileName := ExtractFilePath(FileName) + ExtractFileNameOnly(FileName) + '.exe';
    if Execute and (FileName <> '') then begin
      if ExtractFileExt(FileName) <> '.exe' then
        FileName := ExtractFilePath(FileName) + ExtractFileNameOnly(FileName) + '.exe';
      try
        CqfirFile.SaveToFile(FileName);
        Application.MessageBox('配制成功 ！！！', '提示信息', MB_ICONQUESTION);
      except
        on e: Exception do begin
          Application.MessageBox(PChar(e.Message), '错误信息', MB_ICONERROR);
        end;
      end;
    end;
  end;
  CqfirFile.Free;
  CqfirDllFile.Free;
  HookDllFile.Free;

  ButtonOK.Enabled := True;
end;

procedure TFrmMain.ButtonOpenClick(Sender: TObject);
var
  sCqfirFile, sCqfirData: string;
  CqfirFile: TMemoryStream;
  CqfirData: TCqfirData;
  I, nSize, nCqfirData: Integer;
  Buffer: Pointer;
begin
  OpenDialog.Filter := 'CqFirSupPort|*.exe';
  if OpenDialog.Execute then begin
    EditCqfirFile.Text := OpenDialog.FileName;

    sCqfirFile := Trim(EditCqfirFile.Text);

    sCqfirData := EncryptBuffer(@CqfirData, SizeOf(TCqfirData));
    nCqfirData := Length(sCqfirData);

    CqfirFile := TMemoryStream.Create;
    CqfirFile.LoadFromFile(sCqfirFile);

    CqfirFile.Seek(-SizeOf(Integer), soFromEnd);
    CqfirFile.Read(nSize, SizeOf(Integer));

    if nSize = CqfirFile.Size then begin
      GetMem(Buffer, nCqfirData);
      try
        SetLength(sCqfirData, nCqfirData);
        CqfirFile.Seek(-(SizeOf(Integer) + nCqfirData), soFromEnd);
        CqfirFile.Read(Buffer^, nCqfirData);
        Move(Buffer^, sCqfirData[1], nCqfirData);
      finally
        FreeMem(Buffer);
      end;

      DecryptBuffer(sCqfirData, @CqfirData, SizeOf(TCqfirData));
      ListBoxHosts.Items.Clear;
      Memo.Lines.Clear;
      EditHomePage.Text := DecryptString(CqfirData.Address);
      EditCaption.Text := CqfirData.Caption;
      EditLinkName.Text := DecryptString(CqfirData.LinkName);
      for I := 0 to Length(CqfirData.Hosts) - 1 do begin
        ListBoxHosts.Items.Add(CqfirData.Hosts[I]);
      end;
      for I := 0 to Length(CqfirData.JumpText) - 1 do begin
        Memo.Lines.Add(CqfirData.JumpText[I]);
      end;
    end;
    CqfirFile.Free;
  end;
end;

procedure TFrmMain.ButtonOpenCqfirDllFileClick(Sender: TObject);
begin
  OpenDialog.Filter := 'CqFir|*.dll';
  if OpenDialog.Execute then begin
    EditCqfirDllFile.Text := OpenDialog.FileName;
  end;
end;

procedure TFrmMain.ButtonOpenHookDllFileClick(Sender: TObject);
begin
  OpenDialog.Filter := 'Hook|*.dll';
  if OpenDialog.Execute then begin
    EditHookDllFile.Text := OpenDialog.FileName;
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
  EditCqfirFile.Text := ExtractFilePath(Application.ExeName) + 'CqFirSupPort.exe';
  EditCqfirDllFile.Text := ExtractFilePath(Application.ExeName) + 'CqFir.dll';
  EditHookDllFile.Text := ExtractFilePath(Application.ExeName) + 'Hook.dll';
  try
    Memo.Lines.LoadFromFile('.\JumpText.htm');
  except

  end;
  try
    ListBoxHosts.Items.LoadFromFile('.\Hosts.TXT');
  except

  end;
end;

procedure TFrmMain.ListBoxHostsClick(Sender: TObject);
begin
  if ListBoxHosts.ItemIndex >= 0 then
    EditHost.Text := ListBoxHosts.Items.Strings[ListBoxHosts.ItemIndex]
  else EditHost.Text := '';
end;

procedure TFrmMain.RzButtonAddHostClick(Sender: TObject);
var
  I: Integer;
  sHost: string;
begin
  sHost := Trim(EditHost.Text);
  if sHost = '' then begin
    Application.MessageBox('请输入过滤网站 ！！！', '提示信息', MB_ICONQUESTION);
    EditHost.SetFocus;
    Exit;
  end;
  if ListBoxHosts.Items.Count > 5 then begin
    Application.MessageBox('最多只能过滤5个网站 ！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  for I := 0 to ListBoxHosts.Items.Count - 1 do begin
    if CompareText(ListBoxHosts.Items.Strings[I], sHost) = 0 then begin
      Application.MessageBox('该网站已经存在 ！！！', '提示信息', MB_ICONQUESTION);
      Exit;
    end;
  end;
  ListBoxHosts.Items.Add(sHost);
  try
    ListBoxHosts.Items.SaveToFile('.\Hosts.TXT');
  except

  end;
end;

procedure TFrmMain.RzButtonDelHostClick(Sender: TObject);
begin
  ListBoxHosts.DeleteSelected;
  try
    ListBoxHosts.Items.SaveToFile('.\Hosts.TXT');
  except

  end;
end;

end.

