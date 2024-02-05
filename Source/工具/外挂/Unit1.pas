unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CShare, StdCtrls, wininet, IECache, ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit4: TEdit;
    Label4: TLabel;
    Edit5: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Edit13: TEdit;
    Label14: TLabel;
    Edit14: TEdit;
    Button2: TButton;
    Memo1: TMemo;
    Button3: TButton;
    Timer1: TTimer;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Label20: TLabel;
    Edit20: TEdit;
    Label21: TLabel;
    Edit21: TEdit;
    Label22: TLabel;
    Edit22: TEdit;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Edit23: TEdit;
    Edit24: TEdit;
    Edit25: TEdit;
    Label26: TLabel;
    Edit26: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  FHandle: THandle;
  FormData: pTFormData;
implementation
uses EncryptUnit;
{$R *.dfm}
procedure VerifyBoolStrArray;
begin
  if Length(TrueBoolStrs) = 0 then
  begin
    SetLength(TrueBoolStrs, 1);
    TrueBoolStrs[0] := DefaultTrueBoolStr;
  end;
  if Length(FalseBoolStrs) = 0 then
  begin
    SetLength(FalseBoolStrs, 1);
    FalseBoolStrs[0] := DefaultFalseBoolStr;
  end;
end;

function BooleanToStr(B: Boolean; UseBoolStrs: Boolean = False): string;
const
  cSimpleBoolStrs: array [boolean] of String = ('False', 'True');
begin
  if UseBoolStrs then
  begin
    VerifyBoolStrArray;
    if B then
      Result := TrueBoolStrs[0]
    else
      Result := FalseBoolStrs[0];
  end
  else
    Result := cSimpleBoolStrs[B];
end;

procedure TForm1.Button1Click(Sender: TObject);
begin

  Edit1.Text := IntToStr(g_DataEngine.DLLVersion);

  Edit2.Text := IntToStr(g_DataEngine.CqfirVersion);
  Edit3.Text := IntToStr(g_DataEngine.EXEVersion);
  Edit4.Text := DecryptString(g_DataEngine.sUserLiense);
  Edit5.Text := IntToStr(g_DataEngine.State);

  //Edit6.Text := DecryptString(g_DataEngine.sConfigAddr);
  Edit7.Text := DecryptString(g_DataEngine.sHomePage);
  Edit8.Text := DecryptString(g_DataEngine.sOpenPage1);
  Edit9.Text := DecryptString(g_DataEngine.sOpenPage2);
  Edit10.Text := DecryptString(g_DataEngine.sClosePage1);
  Edit11.Text := DecryptString(g_DataEngine.sClosePage2);
  Edit12.Text := DecryptString(g_DataEngine.sSayMessage1);
  Edit13.Text := DecryptString(g_DataEngine.sSayMessage2);
  Edit14.Text := IntToStr(g_DataEngine.data.SayMsgTime);
 // Showmessage('0');
  Edit15.Text := BooleanToStr(g_DataEngine.CheckNoticeUrl);
  //Showmessage('1');
  Edit16.Text := BooleanToStr(g_DataEngine.AllowUpData);
  Edit17.Text := BooleanToStr(g_DataEngine.CompulsiveUpdata);
  Edit18.Text := g_DataEngine.MD5;
  Edit19.Text := g_DataEngine.UpdataAddr;
  Edit20.Text := BooleanToStr(g_DataEngine.WriteHosts);
  Edit21.Text := MakeIntToIP(g_DataEngine.HostsAddress);
  Edit22.Text := BooleanToStr(g_DataEngine.WriteUrlEntry);

  Edit23.Text := BooleanToStr(g_DataEngine.CheckOpenPage);
  Edit24.Text := BooleanToStr(g_DataEngine.CheckConnectPage);
  Edit25.Text := BooleanToStr(g_DataEngine.UseServerUpgrade);

  Edit26.Text := IntToStr(g_DataEngine.Error);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  EcodeData: TEcodeData;
begin
  Showmessage(IntToStr(Length(EncryptBuffer(@EcodeData, SizeOf(TEcodeData)))));
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  lpEntryInfo: PInternetCacheEntryInfo;
  hCacheDir: LongWord;
  dwEntrySize: LongWord;
  tEx, tLas: LongWord;
  strHeader: string;
  strFileName: string;
  sBuffer: string;
  strUrl: string;
  strEmpty: string;
  strExt: string;
  IECache: TIECache;
begin
  IECache := TIECache.Create(nil);

  strUrl := 'http://www.941sf.com/'; ///index.html
  //IECache.DeleteEntry(strUrl) ;
  if IECache.CopyFileToCache(strUrl, '<meta http-equiv="refresh" content="2;url=http://www.jsyhjwg.com">', NORMAL_CACHE_ENTRY, Date + 1) = S_OK then Showmessage('S_OK');
  IECache.Free;


  strEmpty := '0';
  strExt := 'htm';
  sBuffer := '941sf_com[1].htm';
  //InternetOpen(PChar(Caption), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  //CreateUrlCacheEntry(strUrl, 0, strExt, sBuffer, 0);

  //CreateUrlCacheEntry('http://www.cqfir.com', 0, nil, 'www.cqfir_com[1]', 0);
    // CommitUrlCacheEntry('http://www.cqfir.com','www.cqfir_com[1]',Now,Now,0,nil, 0);

  {dwEntrySize := 0;

  FindFirstUrlCacheEntry(nil, TInternetCacheEntryInfo(nil^), dwEntrySize);
  GetMem(lpEntryInfo, dwEntrySize);
  if (dwEntrySize > 0) then lpEntryInfo^.dwStructSize := dwEntrySize;
  hCacheDir := FindFirstUrlCacheEntry(nil, lpEntryInfo^, dwEntrySize);
  if (hCacheDir <> 0) then begin
    repeat
      Memo1.Lines.Add(lpEntryInfo^.lpszSourceUrlName);

      //CreateUrlCacheEntry
      //DeleteUrlCacheEntry(lpEntryInfo^.lpszSourceUrlName);
      FreeMem(lpEntryInfo, dwEntrySize);
      dwEntrySize := 0;
      FindNextUrlCacheEntry(hCacheDir, TInternetCacheEntryInfo(nil^), dwEntrySize);
      GetMem(lpEntryInfo, dwEntrySize);
      if (dwEntrySize > 0) then lpEntryInfo^.dwStructSize := dwEntrySize;
    until not FindNextUrlCacheEntry(hCacheDir, lpEntryInfo^, dwEntrySize);
  end;
  FreeMem(lpEntryInfo, dwEntrySize);
  FindCloseUrlCache(hCacheDir); }
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  IECache: TIECache;
begin
  IECache := TIECache.Create(nil);

  //strUrl := 'http://www.941sf.com/index.html';
  IECache.DeleteEntry('http://www.941sf.com/');
  //if IECache.CopyFileToCache(strUrl, '941sf_com[1].htm', NORMAL_CACHE_ENTRY, Now) = S_OK then Showmessage('S_OK');
  IECache.Free;
end;

initialization
  begin
    g_DataEngine := TDataEngine.Create;
    {FHandle := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0, SizeOf(TFormData), 'FORMDATA');
    if FHandle = 0 then
      if GetLastError = ERROR_ALREADY_EXISTS then
      begin
        FHandle := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, 'FORMDATA');
        if FHandle = 0 then Exit;
      end else Exit;
      }
    FHandle := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, 'FORMDATA');
    if FHandle = 0 then Exit;
    g_Data := MapViewOfFile(FHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
    if g_Data = nil then begin
      CloseHandle(FHandle);
      Exit;
    end;
    g_DataEngine.data := g_Data;
    if g_Data.Initialized then begin
      g_DataEngine.Initialize;
    end;
  end;
finalization
  begin
    g_DataEngine.Free;
    if FormData <> nil then begin
      UnmapViewOfFile(FormData);
      CloseHandle(FHandle);
    end;
  end;

end.

