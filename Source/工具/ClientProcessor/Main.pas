unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, RzBtnEdt, ZLib;

type
  TClientOption = record
    nSize: Cardinal;
    nCrc: Cardinal;
    sClosePage1: string[100];
    sClosePage2: string[100];
    boArr: array[0..10 - 1] of Boolean;
    nArr: array[0..10 - 1] of Integer;
  end;
  pTClientOption = ^TClientOption;

  TFrmMain = class(TForm)
    GroupBox3: TGroupBox;
    Label11: TLabel;
    EditMirClient: TRzButtonEdit;
    GroupBox: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    EditNoticeInfo1: TEdit;
    EditNoticeInfo2: TEdit;
    ButtonOK: TButton;
    ButtonClose: TButton;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure EditMirClientButtonClick(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation
uses HUtil32, EncryptUnit;
{$R *.dfm}

procedure TFrmMain.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.ButtonOKClick(Sender: TObject);
var
  sMirClient: string;
  MemoryStream: TMemoryStream;
  ClientOption: TClientOption;

  OutBuf: Pointer;
  OutBytes: Integer;

  nSize: Integer;
  nCrc: Cardinal;
  Buffer: Pointer;
  sBuffer: string;
  nBuffer: Cardinal;

  sNoticeInfo1: string;
  sNoticeInfo2: string;
begin
  sMirClient := Trim(EditMirClient.Text);
  sNoticeInfo1 := Trim(EditNoticeInfo1.Text);
  sNoticeInfo2 := Trim(EditNoticeInfo2.Text);
  if not FileExists(sMirClient) then begin
    Application.MessageBox('没有发现MirClient.exe ！！！', '提示信息', MB_ICONQUESTION);
    EditMirClient.SetFocus;
    Exit;
  end;

  {if (sNoticeInfo1 = '') and (sNoticeInfo1 = '') then begin
    Application.MessageBox('最少要有一个广告信息 ！！！', '提示信息', MB_ICONQUESTION);
    EditNoticeInfo1.SetFocus;
    Exit;
  end;}

  MemoryStream := TMemoryStream.Create;
  MemoryStream.LoadFromFile(sMirClient);
  FillChar(ClientOption, SizeOf(TClientOption), #0);

  ClientOption.sClosePage1 := sNoticeInfo1;
  ClientOption.sClosePage2 := sNoticeInfo2;
  ClientOption.nSize := MemoryStream.Size;

  nSize := MemoryStream.Size;
  GetMem(Buffer, nSize);
  try
    MemoryStream.Seek(0, soFromBeginning);
    MemoryStream.Read(Buffer^, nSize);
    nCRC := BufferCRC(Buffer, nSize);
  finally
    FreeMem(Buffer);
  end;
  ClientOption.nCrc := nCRC;

  sBuffer := EncryptBuffer(@ClientOption, SizeOf(TClientOption));
  nBuffer := Length(sBuffer);
  MemoryStream.Seek(0, soFromEnd);
  MemoryStream.Write(sBuffer[1], nBuffer);

//压缩
  {GetMem(Buffer, MemoryStream.Size);
  try
    MemoryStream.Seek(0, soFromBeginning);
    MemoryStream.Read(Buffer^, MemoryStream.Size);
    CompressBuf(Buffer, MemoryStream.Size, OutBuf, OutBytes);
    MemoryStream.Size := OutBytes;
    MemoryStream.Seek(0, soFromBeginning);
    MemoryStream.Write(OutBuf^, OutBytes);
    FreeMem(OutBuf);
  finally
    FreeMem(Buffer);
  end; }

  with SaveDialog do begin
    Filter := 'MirClient|*.exe';
    {if FileName = '' then }FileName := 'MirClient.exe';
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

procedure TFrmMain.EditMirClientButtonClick(Sender: TObject);
var
  MemoryStream: TMemoryStream;
  ClientOption: TClientOption;
  nSize: PInteger;
  nCrc: PCardinal;
  Buffer: Pointer;
  sBuffer: string;
  nBuffer: Integer;

  OutBuf: Pointer;
  OutBytes: Integer;
begin
  OpenDialog.Filter := 'M2Server|*.exe';
  if OpenDialog.Execute then begin
    EditMirClient.Text := OpenDialog.FileName;
    MemoryStream := TMemoryStream.Create;
    MemoryStream.LoadFromFile(Application.ExeName);

    {
    GetMem(Buffer, MemoryStream.Size);
    try
      MemoryStream.Seek(0, soFromBeginning);
      MemoryStream.Read(Buffer^, MemoryStream.Size);
      DecompressBuf(Buffer, MemoryStream.Size, 0, OutBuf, OutBytes);
      MemoryStream.Size := OutBytes;
      MemoryStream.Seek(0, soFromBeginning);
      MemoryStream.Write(OutBuf^, OutBytes);
      FreeMem(OutBuf);
    finally
      FreeMem(Buffer);
    end;
    }

    nBuffer := Length(EncryptBuffer(@ClientOption, SizeOf(TClientOption)));
    MemoryStream.Seek(-nBuffer, soFromEnd);
    SetLength(sBuffer, nBuffer);
    MemoryStream.Read(sBuffer[1], nBuffer);
    DecryptBuffer(sBuffer, @ClientOption, SizeOf(TClientOption));

    New(nSize);
    New(nCrc);
    nSize^ := MemoryStream.Size - nBuffer;
    GetMem(Buffer, nSize^);
    try
      MemoryStream.Seek(0, soFromBeginning);
      MemoryStream.Read(Buffer^, nSize^);
      nCRC^ := BufferCRC(Buffer, nSize^);
    finally
      FreeMem(Buffer);
    end;
    if (ClientOption.nSize = nSize^) and (ClientOption.nCrc = nCrc^) then begin
      EditNoticeInfo1.Text := ClientOption.sClosePage1;
      EditNoticeInfo2.Text := ClientOption.sClosePage2;
    end;
    Dispose(nSize);
    Dispose(nCrc);
    MemoryStream.Free;
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  EditMirClient.Text := ExtractFilePath(Application.ExeName) + 'MirClient.exe';
end;

end.

