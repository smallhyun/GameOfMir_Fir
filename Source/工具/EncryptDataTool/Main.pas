unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLabel, Mask, RzEdit, RzBtnEdt, ExtCtrls, RzPanel,
  RzRadGrp, RzButton, DIB, ComCtrls, PlugShare, uDragFromShell, EncryptUnit;

type
  TStartProc = procedure;

  TDataHeader = record //新定义的Data文件头
    Title: string[40];
    Size: DWORD;
    ImageCount: DWORD;
    IndexOffSet: LongWord;
    BitCount: Word;
    Compression: Word;
  end;
  pTDataHeader = ^TDataHeader;

  TDataImageInfo = record //新定义Data图片信息
    nWidth: Smallint;
    nHeight: Smallint;
    Px: Smallint;
    Py: SmallInt;
    nSize: Integer; //数据大小
  end;
  pTDataImageInfo = ^TDataImageInfo;


  TIntArray = array of Integer;
  PTIntArray = ^TIntArray;

  TDataImage = record //新定义Data图片信息
    nWidth: SmallInt;
    nHeight: SmallInt;
    px: SmallInt;
    py: SmallInt;
    nSize: Integer; //数据大小
    PBits: PByte;
  end;
  pTDataImage = ^TDataImage;

  TDataImageArray = array of TDataImage;
  pTDataImageArray = ^TDataImageArray;

  TSystemInitialize = procedure(Config: pTSystemConfig); stdcall;
  TGetRegistryInfo = procedure(RegistryInfo: pTRegistryConfig); stdcall;
  TGetRegistryKey = procedure(RegistryConfig: pTRegistryConfig; Key: PChar); stdcall;

  TDataFile = class
    m_DataHeader: TDataHeader; //文件头
  private
    UserCriticalSection: TRTLCriticalSection;
    FFileName: string; //文件名
    FOnInitialize: TStartProc;
    FImageCount: Integer;
    FDataType: Integer;

    FFileHandle: Integer;
    FLoadFromFile: Boolean;
    FDataHeader: TDataHeader; //文件头
    //FIndexArray: TIntArray; //索引
    FDataImageInfo: TDataImageInfo;
    //FIntegerArray: PTIntArray;
    m_FileStream: TFileStream;
    m_EncryptFileStream: TFileStream;
    //m_FileList: TList;
    FCompression: Byte;
    FIsDataFile: Boolean;
    FIndexList: TList;
  protected
    procedure Lock;
    procedure UnLock;
  public
    constructor Create(const AFileName: string);
    destructor Destroy; override;
    procedure Initialize;
    procedure Finalize;
    procedure SaveToFile(const sFileName: string);
    procedure Compression;

    property DataHeader: TDataHeader read FDataHeader write FDataHeader;
    property FileName: string read FFileName write FFileName;
    property ImageCount: Integer read FImageCount write FImageCount;
    property DataType: Integer read FDataType write FDataType;
    property OnInitialize: TStartProc read FOnInitialize write FOnInitialize;
    property CompType: Byte read FCompression write FCompression;
    property IsDataFile: Boolean read FIsDataFile write FIsDataFile;
  end;

  TFrmMain = class(TForm)
    EditDataFile: TRzButtonEdit;
    RzLabel1: TRzLabel;
    ButtonStart: TRzButton;
    RadioGroup: TRzRadioGroup;
    ButtonClose: TRzButton;
    ProgressBar: TProgressBar;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    RzURLLabel1: TRzURLLabel;
    procedure FormCreate(Sender: TObject);
    procedure EditDataFileButtonClick(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    //procedure ButtonStartCompress(Sender: TObject); stdcall;
  private
    { Private declarations }
    DragFromShell: TDragFromShell;
    procedure DropFiles(Sender: Tobject; Filename: string);
  public
    { Public declarations }
  end;
procedure Progress;
var
  FrmMain: TFrmMain;
  DataFile: TDataFile;
  StartCompress: Boolean;
  RegistryConfig: pTRegistryConfig;
procedure ButtonStartCompress; stdcall;
implementation
uses CompressUnit, ZLIBEX;
const
  g_sTitle = '飞尔世界真彩图片资源文件 2010/02/25 http://www.cqfir.net';
var
  Module: THandle;
  SystemInitialize: TSystemInitialize;
  GetRegistryInfo: TGetRegistryInfo;
{$R *.dfm}

procedure UnCompressRle16(const InData: Pointer; InSize: LongInt; out OutData: Pointer; out OutSize: LongInt);
//function UnCompressRle(dbuf, sbuf: PByte; sbuflen: Integer): Integer;
var
  I, J, K, a: integer;
  wsbuf, wdbuf: PWordArray;
begin
  wsbuf := PWordArray(InData);
  wdbuf := PWordArray(OutData);
  J := 0;
  I := 0;
  while I < InSize div 2 do begin
    if (wsbuf[I] = $AAAA) then begin
      for K := 0 to wsbuf[I + 2] - 1 do begin
        wdbuf[J] := wsbuf[I + 1];
        Inc(J);
      end;
      Inc(I, 2);
    end else begin
      wdbuf[J] := wsbuf[I];
      Inc(J);
    end;
    Inc(I);
  end;
  OutSize := J * 2;
end;

procedure CompressRle16(const InData: Pointer; InSize: LongInt; out OutData: Pointer; out OutSize: LongInt);
 //RLE 又叫 Run Length Encoding 压缩
var
  I, J, K: integer;
  wsbuf, wdbuf: PWordArray;
  repeatCount: integer;
  repeatWord: word;
begin
  wsbuf := PWordArray(InData);
  wdbuf := PWordArray(OutData);
  repeatCount := 0;
  repeatWord := 0;
  J := 0;
  for I := 0 to InSize div 2 - 1 do begin
    if (wsbuf[I] = repeatWord) and (repeatCount < 60000) then Inc(repeatCount)
    else begin
      if (repeatCount > 3) then begin
        wdbuf[J] := $AAAA;
        Inc(J);
        wdbuf[J] := repeatWord;
        Inc(J);
        wdbuf[J] := repeatCount;
        Inc(J);
      end else
        if (repeatCount > 0) then begin
        for K := 0 to repeatCount - 1 do begin
          wdbuf[J] := repeatWord;
          Inc(J);
        end;
      end;
      repeatWord := wsbuf[I];
      repeatCount := 1;
    end;
    if (I = InSize div 2 - 1) then begin
      if (repeatCount > 3) then begin
        wdbuf[J] := $AAAA;
        Inc(J);
        wdbuf[J] := repeatWord;
        Inc(J);
        wdbuf[J] := repeatCount;
        Inc(J);
      end else
        if (repeatCount > 0) and (repeatWord = $AAAA) then begin
        wdbuf[J] := $AAAA;
        Inc(J);
        wdbuf[J] := repeatWord;
        Inc(J);
        wdbuf[J] := repeatCount;
        Inc(J);
      end else
        if (repeatCount > 0) then begin
        for K := 0 to repeatCount - 1 do begin
          wdbuf[J] := repeatWord;
          Inc(J);
        end;
      end;
    end;
  end;
  OutSize := J * 2;
end;

procedure UnCompressRle32(const InData: Pointer; InSize: LongInt; out OutData: Pointer; out OutSize: LongInt);
//function UnCompressRle(dbuf, sbuf: PByte; sbuflen: Integer): Integer;
var
  I, J, K, a: Integer;
  wsbuf, wdbuf: PIntegerArray;
begin
  wsbuf := PIntegerArray(InData);
  wdbuf := PIntegerArray(OutData);
  J := 0;
  I := 0;
  while I < InSize div 4 do begin
    if (wsbuf[I] = -2) then begin
      for K := 0 to wsbuf[I + 2] - 1 do begin
        wdbuf[J] := wsbuf[I + 1];
        Inc(J);
      end;
      Inc(I, 2);
    end else begin
      wdbuf[J] := wsbuf[I];
      Inc(J);
    end;
    Inc(I);
  end;
  OutSize := J * 4;
end;

procedure CompressRle32(const InData: Pointer; InSize: LongInt; out OutData: Pointer; out OutSize: LongInt);
 //RLE 又叫 Run Length Encoding 压缩
var
  I, J, K: integer;
  wsbuf, wdbuf: PIntegerArray;
  RepeatCount: Integer;
  RepeatWord: Integer;
begin
  wsbuf := PIntegerArray(InData);
  wdbuf := PIntegerArray(OutData);
  RepeatCount := 0;
  RepeatWord := 0;
  J := 0;
  for I := 0 to InSize div 4 - 1 do begin
    if (wsbuf[I] = RepeatWord) {and (repeatCount < 60000)} then Inc(RepeatCount)

    else begin
      if (RepeatCount > 3) then begin
        wdbuf[J] := -2;
        Inc(J);
        wdbuf[J] := RepeatWord;
        Inc(J);
        wdbuf[J] := RepeatCount;
        Inc(J);
      end else
        if (RepeatCount > 0) then begin
        for K := 0 to RepeatCount - 1 do begin
          wdbuf[J] := RepeatWord;
          Inc(J);
        end;
      end;
      RepeatWord := wsbuf[I];
      RepeatCount := 1;
    end;
    if (I = InSize div 4 - 1) then begin
      if (RepeatCount > 3) then begin
        wdbuf[J] := -2;
        Inc(J);
        wdbuf[J] := RepeatWord;
        Inc(J);
        wdbuf[J] := RepeatCount;
        Inc(J);
      end else
        if (RepeatCount > 0) and (RepeatWord = -2) then begin
        wdbuf[J] := -2;
        Inc(J);
        wdbuf[J] := RepeatWord;
        Inc(J);
        wdbuf[J] := RepeatCount;
        Inc(J);
      end else
        if (RepeatCount > 0) then begin
        for K := 0 to RepeatCount - 1 do begin
          wdbuf[J] := RepeatWord;
          Inc(J);
        end;
      end;
    end;
  end;
  OutSize := J * 4;
end;

//=====================================压缩=====================================

function Comp(Compress: Integer; const InData: Pointer; InSize: LongInt; out OutData: Pointer): Integer;
begin
  case Compress of
    0: begin
        Move(InData^, OutData^, InSize);
        Result := InSize;
      end;
    1: begin
        CompressRle16(InData, InSize, OutData, Result);
      end;
    2: begin
        CompressBufZ(InData, InSize, OutData, Result);
      end;
    3: begin
        CompressBufferL(InData, InSize, OutData, Result);
      end;
    //4: CompBufferL(InData, InSize, OutData, Result);
  end;
end;

//====================================解压缩====================================

function UnComp(Compress: Integer; const InData: Pointer; InSize: LongInt; out OutData: Pointer): Integer;
begin
  case Compress of
    0: begin
        Move(InData^, OutData^, InSize);
        Result := InSize;
      end;
    1: begin
        UnCompressRle16(InData, InSize, OutData, Result);
      end;
    2: begin
        DecompressBufZ(InData, InSize, 0, OutData, Result);
      end;
    3: begin
        UnCompressBufferL(InData, InSize, OutData, Result);
      end;
    //4: UnCompBufferL(InData, InSize, OutData, Result);
  end;
end;

constructor TDataFile.Create(const AFileName: string);
begin
  InitializeCriticalSection(UserCriticalSection);
  FFileName := AFileName;
  FCompression := 0;
  FLoadFromFile := False;
  FIsDataFile := False;
  m_FileStream := nil;
  m_EncryptFileStream := nil;
  FIndexList := TList.Create;
end;

destructor TDataFile.Destroy;
begin
  Finalize;
  FIndexList.Free;
  if m_FileStream <> nil then
    m_FileStream.Free;
  if m_EncryptFileStream <> nil then
    m_EncryptFileStream.Free;
  DeleteCriticalSection(UserCriticalSection);
  inherited;
end;

procedure TDataFile.Lock;
begin
  EnterCriticalSection(UserCriticalSection);
end;

procedure TDataFile.UnLock;
begin
  LeaveCriticalSection(UserCriticalSection);
end;

procedure TDataFile.Initialize;
var
  I, Value: Integer;
  PValue: PInteger;
begin
  if FileExists(FileName) then begin
    FileSetAttr(FileName, 0);
    m_FileStream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone);
    m_FileStream.Read(FDataHeader, SizeOf(TDataHeader));
    FImageCount := FDataHeader.ImageCount;
    FCompression := FDataHeader.Compression;
    if FDataHeader.IndexOffSet = 0 then
      FDataHeader.IndexOffSet := SizeOf(TDataHeader);
    FIsDataFile := Pos('飞尔世界真彩图片资源文件', FDataHeader.Title) > 0;
  end else begin
    m_FileStream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone or fmCreate);
    FDataHeader.Title := g_sTitle;
    FDataHeader.Size := SizeOf(TDataHeader);
    FDataHeader.ImageCount := 0;
    FDataHeader.IndexOffSet := SizeOf(TDataHeader);
    FDataHeader.BitCount := 16;
    FDataHeader.Compression := 0;
    m_FileStream.Write(FDataHeader, SizeOf(TDataHeader));
    FImageCount := FDataHeader.ImageCount;
  end;
  if FIsDataFile then begin
    if FDataHeader.ImageCount > 0 then begin
      FIndexList.Clear;
      m_FileStream.Position := FDataHeader.IndexOffSet;
      GetMem(PValue, ImageCount * SizeOf(Integer));
      m_FileStream.Read(PValue^, FDataHeader.ImageCount * SizeOf(Integer));
      for I := 0 to FDataHeader.ImageCount - 1 do begin
        Value := PInteger(Integer(PValue) + SizeOf(Integer) * I)^;
        FIndexList.Add(Pointer(Value));
      end;
      FreeMem(PValue);
    end;
  end;
end;

procedure TDataFile.SaveToFile(const sFileName: string);
begin
  if m_EncryptFileStream <> nil then
    FreeAndNiL(m_EncryptFileStream);
  if FileExists(sFileName) then begin
    FileSetAttr(sFileName, 0);
    m_EncryptFileStream := TFileStream.Create(sFileName, fmOpenReadWrite or fmShareDenyNone);
  end else begin
    m_EncryptFileStream := TFileStream.Create(sFileName, fmOpenReadWrite or fmShareDenyNone or fmCreate);
  end;
  m_EncryptFileStream.Size := SizeOf(TDataHeader);
end;

procedure TDataFile.Compression;
var
  I: Integer;
  IndexList: PInteger;

  ImageInfo: TDataImageInfo;
  InData: Pointer;
  OutData: Pointer;
begin
  GetMem(IndexList, SizeOf(Integer) * FIndexList.Count);
  m_EncryptFileStream.Position := SizeOf(TDataHeader);
  for I := 0 to FIndexList.Count - 1 do begin
    Application.ProcessMessages;
    if Assigned(OnInitialize) then TStartProc(OnInitialize);
    PInteger(Integer(IndexList) + SizeOf(Integer) * I)^ := m_EncryptFileStream.Position;
    m_FileStream.Position := Integer(FIndexList.Items[I]);
    m_FileStream.Read(ImageInfo, SizeOf(TDataImageInfo));
    GetMem(InData, ImageInfo.nSize);
    m_FileStream.Read(InData^, ImageInfo.nSize);
    if (ImageInfo.nWidth * ImageInfo.nHeight > 4) then begin
      GetMem(OutData, ImageInfo.nWidth * ImageInfo.nHeight * 3);
      ImageInfo.nSize := Comp(FCompression, InData, ImageInfo.nSize, OutData);
      m_EncryptFileStream.Write(ImageInfo, SizeOf(TDataImageInfo));
      m_EncryptFileStream.Write(OutData^, ImageInfo.nSize);
      FreeMem(OutData);
    end else begin
      m_EncryptFileStream.Write(ImageInfo, SizeOf(TDataImageInfo));
      m_EncryptFileStream.Write(InData^, ImageInfo.nSize);
    end;
    FreeMem(InData);
  end;
  FDataHeader.IndexOffSet := m_EncryptFileStream.Position;
  FDataHeader.Compression := FCompression;
  m_EncryptFileStream.Write(IndexList^, SizeOf(Integer) * FIndexList.Count);
  m_EncryptFileStream.Seek(0, soBeginning);
  m_EncryptFileStream.Write(FDataHeader, SizeOf(TDataHeader));

  FreeMem(IndexList);
  FreeAndNiL(m_EncryptFileStream);
end;

procedure TDataFile.Finalize;
begin

end;

procedure Progress;
begin
  FrmMain.ProgressBar.Position := FrmMain.ProgressBar.Position + 1;
  FrmMain.Caption := Format('飞尔世界Data资源压缩工具 (%d/%d)', [FrmMain.ProgressBar.Position, FrmMain.ProgressBar.Max]);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  sFileName: string;
  Buffer: Pointer;
  SystemConfig: TSystemConfig;
begin
  Application.ShowMainForm := False;
  DragFromShell := TDragFromShell.Create(self);
  DragFromShell.OnShellDragDrop := DropFiles;
  DataFile := nil;
  StartCompress := False;

  New(RegistryConfig);
  FillChar(RegistryConfig^, SizeOf(TRegistryConfig), #0);
  FillChar(SystemConfig, SizeOf(TSystemConfig), #0);
  SystemConfig.nOwner := CalcFileCRC(Application.ExeName);
  SystemConfig.nUserNumber := 123456789;
  SystemConfig.nVersion := 8888;
  SystemConfig.nMyRootKey := HKEY_CURRENT_USER;
  SystemConfig.cMySubKey := '\Software\EncryptData\';
  SystemConfig.cKey := 'Key';
  SystemConfig.RegistryControl := ButtonStartCompress;

  sFileName := ExtractFilePath(Application.ExeName) + 'RegistrySystem.dll'; ;
  if FileExists(sFileName) then begin
    Module := LoadLibrary(PChar(sFileName)); //FreeLibrary
    if Module > 32 then begin
      //Showmessage('ok1');
      SystemInitialize := GetProcAddress(Module, Pointer(HiWord(0) or LoWord(1))); //:= GetProcAddress(Module, 'SystemInitialize');
      GetRegistryInfo := GetProcAddress(Module, Pointer(HiWord(0) or LoWord(2))); //:= GetProcAddress(Module, 'GetRegistryInfo');
      if (@SystemInitialize <> nil) and (@GetRegistryInfo <> nil) then begin
        SystemInitialize(@SystemConfig);
        GetRegistryInfo(RegistryConfig);
        Buffer := Pointer(Integer(RegistryConfig) + 4);
        if CalcBufferCRC(Buffer, SizeOf(TRegistryConfig) - 4) = RegistryConfig.nCRC then begin
          case RegistryConfig.RegistryStatus of
            r_Share: Application.Terminate;
            r_Number: if RegistryConfig.RegistryCount <= 0 then Application.Terminate else Application.ShowMainForm := True;
            r_Date: if Date > RegistryConfig.RegistryDate then Application.Terminate else Application.ShowMainForm := True;
            r_Forever: Application.ShowMainForm := True;
          end;
        end else Application.Terminate; //Showmessage('ok');
      end else Application.Terminate;
    end else Application.Terminate;
  end else Application.Terminate;
end;

procedure TFrmMain.EditDataFileButtonClick(Sender: TObject);
begin
  if OpenDialog.Execute then begin
    if DataFile <> nil then FreeAndNil(DataFile);
    EditDataFile.Text := OpenDialog.FileName;
    DataFile := TDataFile.Create(OpenDialog.FileName);
    DataFile.Initialize;
    if not DataFile.IsDataFile then begin
      FreeAndNil(DataFile);
      Application.MessageBox('该文件不是飞尔世界真彩资源文件 ！！！', '提示信息', MB_ICONQUESTION);
      Exit;
    end;
    if DataFile.CompType > 0 then begin
      FreeAndNil(DataFile);
      Application.MessageBox('该文件已经压缩 ！！！', '提示信息', MB_ICONQUESTION);
    end;
  end;
end;

function ExtractFilePath(const FileName: string): string;
var
  I: integer;
begin
  I := LastDelimiter(PathDelim + DriveDelim, FileName);
  Result := Copy(FileName, 1, I);
end;

function ExtractFileNameOnly(const fname: string): string;
var
  extpos: integer;
  ext, fn: string;
begin
  ext := ExtractFileExt(fname);
  fn := ExtractFileName(fname);
  if ext <> '' then begin
    extpos := Pos(ext, fn);
    Result := Copy(fn, 1, extpos - 1);
  end else
    Result := fn;
end;

procedure ButtonStartCompress; stdcall;
begin
  if DataFile = nil then begin
    Application.MessageBox('请选择一个Data文件 ！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  if StartCompress then Exit;
  StartCompress := True;
  with FrmMain do begin
    ButtonStart.Enabled := False;
    ButtonClose.Enabled := False;
    DataFile.CompType := RadioGroup.ItemIndex + 1;

    with SaveDialog do begin
      FileName := ExtractFilePath(DataFile.FileName) + ExtractFileNameOnly(DataFile.FileName) + '_Encrypt.Data';
      if Execute and (FileName <> '') then begin
        DataFile.SaveToFile(FileName);
      end else begin
        //FreeAndNil(DataFile);
        ButtonStart.Enabled := True;
        ButtonClose.Enabled := True;
        StartCompress := False;
        Exit;
      end;
    end;
    FrmMain.Caption := '飞尔世界Data资源压缩工具';
    try
      DataFile.OnInitialize := Progress;
      ProgressBar.Position := 0;
      ProgressBar.Min := 0;
      ProgressBar.Max := DataFile.ImageCount;
      DataFile.Compression;

      Application.MessageBox('压缩成功 ！！！', '提示信息', MB_ICONQUESTION);
    finally
      ButtonStart.Enabled := True;
      ButtonClose.Enabled := True;
      StartCompress := False;
    end;
  end;
end;

procedure TFrmMain.ButtonStartClick(Sender: TObject);
begin
  if Assigned(RegistryConfig.RegistrySuccess) then begin
    RegistryConfig.RegistrySuccess;
  end;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  if DataFile <> nil then FreeAndNil(DataFile);
end;

procedure TFrmMain.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeLibrary(Module);
  Dispose(RegistryConfig);
  DragFromShell.Free;
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not StartCompress;
end;

procedure TFrmMain.DropFiles(Sender: Tobject; Filename: string);
begin
  SendMessage(Application.MainForm.Handle, FCP_FILEOPEN, 0, Integer(Filename));
  if DirectoryExists(Filename) or StartCompress then Exit;
  //这里是拖放文件的具体处理代码
  if DataFile <> nil then FreeAndNil(DataFile);
  EditDataFile.Text := FileName;
  DataFile := TDataFile.Create(FileName);
  DataFile.Initialize;
  if not DataFile.IsDataFile then begin
    FreeAndNil(DataFile);
    Application.MessageBox('该文件不是飞尔世界真彩资源文件 ！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  if DataFile.CompType > 0 then begin
    FreeAndNil(DataFile);
    Application.MessageBox('该文件已经压缩 ！！！', '提示信息', MB_ICONQUESTION);
  end;
end;

end.

