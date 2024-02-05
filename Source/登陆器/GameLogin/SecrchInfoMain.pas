unit SecrchInfoMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLabel, ExtCtrls, RzButton, StrUtils, ShlObj, ActiveX,
  Mask;

type
  TSecrchObject = class
  private
    function GetDirectory: string;
    function GetSecrchSuccess: Boolean;
  public
    constructor Create();
    destructor Destroy; override;
    procedure Start();
    procedure Stop();
  published
    property Directory: string read GetDirectory;
    property SecrchSuccess: Boolean read GetSecrchSuccess;
  end;

  TSecrchFrm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    SecrchInfoLabel: TRzLabel;
    Label3: TLabel;
    Label4: TLabel;
    EditPath: TEdit;
    RzButtonSelDir: TButton;
    Label5: TLabel;
    ButtonClose: TButton;
    ToolButtonSearch: TRzToolButton;
    procedure SearchMirClient();
    procedure StopButtonClick(Sender: TObject);
    procedure RzToolButtonSearchClick(Sender: TObject);
    procedure RzButtonSelDirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
function CheckMirDir(DirName: string): Boolean;

var
  SecrchFrm: TSecrchFrm;
  boStopSearch: Boolean = False;
  boSearchFinish: Boolean = False;
  boSecrchSuccess: Boolean = False;
  sSearchDirectory: string = '';
implementation

{$R *.dfm}
function SelectDirCB(Wnd: Hwnd; uMsg: UINT; LPARAM, lpData: LPARAM): Integer stdcall;
begin
  if (uMsg = BFFM_INITIALIZED) and (lpData <> 0) then
    SendMessage(Wnd, BFFM_SETSELECTION, Integer(True), lpData);
  Result := 0;
end;

function SelectDirectory(const Caption: string; const Root: WideString;
  var Directory: string; Owner: THandle): Boolean;
var
  WindowList: Pointer;
  BrowseInfo: TBrowseInfo;
  Buffer: PChar;
  RootItemIDList, ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
  IDesktopFolder: IShellFolder;
  Eaten, Flags: LongWord;
begin
  Result := False;
  if not DirectoryExists(Directory) then
    Directory := '';
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then begin
    Buffer := ShellMalloc.Alloc(MAX_PATH);
    try
      RootItemIDList := nil;
      if Root <> '' then begin
        SHGetDesktopFolder(IDesktopFolder);
        IDesktopFolder.ParseDisplayName(Application.Handle, nil,
          POleStr(Root), Eaten, RootItemIDList, Flags);
      end;
      with BrowseInfo do begin
        hwndOwner := Owner;
        pidlRoot := RootItemIDList;
        pszDisplayName := Buffer;
        lpszTitle := PChar(Caption);
        ulFlags := BIF_RETURNONLYFSDIRS;
        if Directory <> '' then begin
          lpfn := SelectDirCB;
          LPARAM := Integer(PChar(Directory));
        end;
      end;
      WindowList := DisableTaskWindows(0);
      try
        ItemIDList := ShBrowseForFolder(BrowseInfo);
      finally
        EnableTaskWindows(WindowList);
      end;
      Result := ItemIDList <> nil;
      if Result then begin
        ShGetPathFromIDList(ItemIDList, Buffer);
        ShellMalloc.Free(ItemIDList);
        Directory := Buffer;
      end;
    finally
      ShellMalloc.Free(Buffer);
    end;
  end;
end;

function AddString(s: string): string;
begin
  Result := s;
  if s[Length(s)] <> '\' then Result := s + '\';
end;

function ReadMessage(MessageText: string; LengCount: Integer): string;
var
  I, CopyCout: Integer;
  Str: string;
begin
  if Length(MessageText) <= LengCount then begin
    Result := MessageText;
    Exit;
  end;
  if Length(MessageText) > LengCount then begin
    CopyCout := (Length(MessageText) div LengCount) + 1;
    for I := 1 to CopyCout do begin
      if I = 1 then begin
        Str := Str + MidStr(MessageText, 1, LengCount) + #13;
      end else begin
        if I = CopyCout then begin
          Str := Str + MidStr(MessageText, (I * LengCount) + 1, Length(MessageText) - (I * LengCount)) + #13;
          Break;
        end;
      end;
      Str := Str + MidStr(MessageText, (I * LengCount) + 1, LengCount) + #13;
    end;
    Result := Str;
  end;
end;

//获取当前的硬盘所有的盘符
procedure GetdriveName(var sList: TStringList);
var
  I, dtype: Integer;
  c: string;
begin
  for I := 65 to 90 do begin
    c := Chr(I) + ':\';
    dtype := GetDriveType(PChar(c));
    if (not ((dtype = 0) or (dtype = 1))) and (dtype = drive_fixed) then {//过滤光驱}  begin
      sList.Add(c);
    end;
  end;
end;

function DoSearchFile(Path: string; var Files: TStringList): Boolean;
var
  Info: TSearchRec;
  s01: string;
  procedure ProcessAFile(FileName: string);
  begin
   {if Assigned(PnlPanel) then
     PnlPanel.Caption := FileName;
   Label2.Caption := FileName;}
  end;
  function IsDir: Boolean;
  begin
    with Info do
      Result := (Name <> '.') and (Name <> '..') and ((Attr and faDirectory) = faDirectory);
  end;
  function IsFile: Boolean;
  begin
    Result := not ((Info.Attr and faDirectory) = faDirectory);
  end;
begin
  try
    Result := False;
    if FindFirst(Path + '*.*', faAnyFile, Info) = 0 then begin
      if IsDir then begin
        s01 := Path + Info.Name;
        if s01[Length(s01)] <> '\' then s01 := s01 + '\';
        Files.Add(s01);
      end;
      while True do begin
        if boSecrchSuccess then Break;
        if boStopSearch then Break;
        s01 := Path + Info.Name;
        if s01[Length(s01)] <> '\' then s01 := s01 + '\';
        if IsDir then Files.Add(s01);
        Application.ProcessMessages;
        if FindNext(Info) <> 0 then Break;
      end;
    end;
    Result := True;
  finally
    FindClose(Info);
  end;
end;

procedure TSecrchFrm.SearchMirClient();
var
  I, II: Integer;
  sList, sTempList, List01, List02: TStringList;
begin
  boSearchFinish := True;
  sList := TStringList.Create;
  sTempList := TStringList.Create;
  List01 := TStringList.Create;
  List02 := TStringList.Create;
  GetdriveName(sList);
  for I := 0 to sList.Count - 1 do begin
    Application.ProcessMessages;
    if boSecrchSuccess then Break;
    if boStopSearch then Break;
    SecrchInfoLabel.Caption := '正在搜索：' + sList.Strings[I];
    if CheckMirDir(sList.Strings[I]) then begin
      sSearchDirectory := sList.Strings[I];
      boSecrchSuccess := True;
      Break;
    end;
    if DoSearchFile(sList.Strings[I], sTempList) then begin
      if boSecrchSuccess then Break;
      if boStopSearch then Break;
      for II := 0 to sTempList.Count - 1 do begin
        SecrchInfoLabel.Caption := '正在搜索：' + sTempList.Strings[II];
        if CheckMirDir(sTempList.Strings[II]) then begin
          sSearchDirectory := sTempList.Strings[II];
          boSecrchSuccess := True;
          Break;
        end;
      end;
    end;
  end;
  List01.AddStrings(sTempList);
  if (not boSecrchSuccess) and (not boStopSearch) then begin
    I := 0;
    while True do begin //从C盘到最后一个盘反复搜索
      if boSecrchSuccess then Break;
      if boStopSearch then Break;
      Application.ProcessMessages;
      if List01.Count <= 0 then Break;
      sTempList.Clear;
      if DoSearchFile(List01.Strings[I], sTempList) then begin
        if boSecrchSuccess then Break;
        if boStopSearch then Break;
        List02.AddStrings(sTempList);
        for II := 0 to sTempList.Count - 1 do begin
          if boSecrchSuccess then Break;
          if boStopSearch then Break;
          SecrchInfoLabel.Caption := '正在搜索：' + sTempList.Strings[II];
          if CheckMirDir(sTempList.Strings[II]) then begin
            sSearchDirectory := sTempList.Strings[II];
            boSecrchSuccess := True;
            Break;
          end;
        end;
      end;
      Inc(I);
      if I > List01.Count - 1 then begin
        List01.Clear;
        List01.AddStrings(List02);
        List02.Clear;
        I := 0;
      end;
    end;
  end;
  sList.Free;
  sTempList.Free;
  List01.Free;
  List02.Free;
  boSearchFinish := False;
end;

function CheckMirDir(DirName: string): Boolean;
begin
  if (not DirectoryExists(DirName + 'Data')) or
    (not DirectoryExists(DirName + 'Map')) or
    (not DirectoryExists(DirName + 'Wav')) then
    Result := False else Result := True;
end;

procedure TSecrchFrm.StopButtonClick(Sender: TObject);
begin
  boStopSearch := True;
  Sleep(100);
  Close;
end;

procedure TSecrchFrm.RzToolButtonSearchClick(Sender: TObject);
begin
  if boSearchFinish then Exit;
  RzButtonSelDir.Enabled := False;
  SearchMirClient();
  RzButtonSelDir.Enabled := True;
  SleepEx(2000, False);
  Close;
end;

procedure TSecrchFrm.RzButtonSelDirClick(Sender: TObject);
var
  sNewDir: string;
begin
  sNewDir := EditPath.Text;
  if SelectDirectory('浏览文件夹', '', sNewDir, Handle) then begin
    EditPath.Text := sNewDir;
    sSearchDirectory := sNewDir;
    if sSearchDirectory[Length(sSearchDirectory)] <> '\' then sSearchDirectory := sSearchDirectory + '\';
    boSecrchSuccess := True;
    Close;
  end;
end;

procedure TSecrchFrm.FormCreate(Sender: TObject);
begin
  boStopSearch := False;
  boSecrchSuccess := False;
  //boSearchFinish:=FALSE;
end;

procedure TSecrchFrm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 // boStopSearch := True;
end;

constructor TSecrchObject.Create();
begin

end;

destructor TSecrchObject.Destroy;
begin
  if SecrchFrm <> nil then SecrchFrm.Close;
end;

function TSecrchObject.GetDirectory: string;
begin
  Result := sSearchDirectory;
end;

function TSecrchObject.GetSecrchSuccess: Boolean;
begin
  Result := boSecrchSuccess;
end;

procedure TSecrchObject.Start();
begin
  SecrchFrm := TSecrchFrm.Create(nil);
  SecrchFrm.ShowModal;
  FreeAndNil(SecrchFrm);
end;

procedure TSecrchObject.Stop();
begin
  boStopSearch := True;
end;

end.
