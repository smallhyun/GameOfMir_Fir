unit LUpgrade;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, ShellApi, HttpProt, WinInet,
  IdTCPClient, IdHTTP, StdCtrls, ComCtrls, ExtCtrls, MD5EncodeStr, VCLUnZip, EncryptUnit,
  jpeg, RzBmpBtn, HTTPGet, DIB;
type
  TUpgradeStep = (uGetGameList, uGetUpgrade, uStartUpgrade, uStartInOne, uNoNewSoft, uOver, uClose);
  TFileType = (ftBase, ftSelf, ftZip, ftRar, ft7z);
  TDownLoadStep = (dDownLoad, dMoveFile, dUnZipFile, dInOne);

  TDownLoadFile = class
  private
    FFileType: TFileType;
    FFileName: string;
    FFilePath: string;
    FFullName: string;

    FUrl: string;
    FMD5: string;
    FFinish: Boolean;
    FDownLoadCount: Integer;
    FStop: Boolean;
    IdHTTPDownLoad: THttpCli;
    VCLUnZip: TVCLUnZip;
    FWorkCountMax: Integer;
    FWorkCountCur: Integer;
    FDownLoadStep: TDownLoadStep;
    procedure MoveFile(LoadFromFile, SaveToFile: string);
    procedure HttpDownLoad(aURL, aFile: string; bResume: Boolean);
    function UnZipFile(Source, sDestDir: string): Boolean; //解压文件

    procedure IdHTTPDownLoadDocBegin(Sender: TObject);
    procedure IdHTTPDownLoadDocData(Sender: TObject; Buffer: Pointer; len: Integer);
    procedure IdHTTPDownLoadDocEnd(Sender: TObject);

    procedure VCLUnZipFilePercentDone(Sender: TObject; Percent: Integer);
    procedure VCLUnZipTotalPercentDone(Sender: TObject; Percent: Integer);
    procedure VCLUnZipStartUnZipInfo(Sender: TObject; NumFiles: Integer;
      TotalBytes: Comp; var StopNow: Boolean);
    procedure VCLUnZipStartUnZip(Sender: TObject; FileIndex: Integer;
      var fname: string; var Skip: Boolean);
  public
    constructor Create();
    destructor Destroy; override;
    procedure DownLoad;
    procedure Stop;
    procedure SaveFinished(sMsg: string);
    property FileType: TFileType read FFileType write FFileType;
    property FileName: string read FFileName write FFileName;
    property FilePath: string read FFilePath write FFilePath;
    property FullName: string read FFullName write FFullName;
    property Url: string read FUrl write FUrl;
    property MD5: string read FMD5 write FMD5;
    property Step: TDownLoadStep read FDownLoadStep;
    property Finish: Boolean read FFinish; // write FFinish;
    property DownLoadCount: Integer read FDownLoadCount;
    property WorkCountMax: Integer read FWorkCountMax write FWorkCountMax;
    property WorkCountCur: Integer read FWorkCountCur write FWorkCountCur;
  end;

  TDownLoads = class(TThread)
  private
    FFileType: TFileType;
    FFileName: string;
    FFileList: TList;
    FFinishList: TStringList;
    FConfigFileList: TStringList;
    procedure LoadFromDirectory(sDirectory: string);
    procedure GetGameList();
    procedure GetUpgrade();
    function IsUpgrade(MD5: string): Boolean;
    function GetCount: Integer;
    procedure StartUpgrade();

    procedure StartInOne();

    procedure Run();
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
    property Count: Integer read GetCount;
    procedure Stop;
  end;


  TfrmUpgradeDownload = class(TForm)
    Timer: TTimer;
    ButtonStop: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabelStatus: TLabel;
    ProgressBarCurDownload: TProgressBar;
    ProgressBarAll: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ButtonStopClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }

  public
    procedure Open();
    { Public declarations }
  end;

var
  frmUpgradeDownload: TfrmUpgradeDownload;
  DownLoads: TDownLoads;
  CriticalSection: TRTLCriticalSection;
  sStatusText: string;
  UpgradeStep: TUpgradeStep;
  CurDownLoadFile: TDownLoadFile;
  DownFileIdx: Integer;

implementation

uses HUtil32, GameShare, Main, GameImages;

{$R *.dfm}

function GetImageFileVersion(const FileName: string): TImageType;
var
  Header: TWMImageHeader;
  NewHeader: TNewWilHeader;
  s: Pchar;
  str: string;
  IndexFile: string;
  Stream: TFileStream;
  boG3: Boolean;
  nG3Sign: DWORD;
  mCount: DWORD;
  fBegin: DWORD;
  mfSize: DWORD;
begin
  if Comparetext(ExtractFileExt(FileName), '.Data') = 0 then begin
    Result := t_Fir;
  end else
    if Comparetext(ExtractFileExt(FileName), '.Wis') = 0 then begin
    Result := t_Wis;
  end else
    if Comparetext(ExtractFileExt(FileName), '.Wil') = 0 then begin
    Result := t_Wil;
    IndexFile := ExtractFilePath(FileName) + ExtractFileNameOnly(FileName) + '.WIX';
    if FileExists(IndexFile) then begin
      Stream := TFileStream.Create(IndexFile, fmOpenReadWrite or fmShareDenyNone);
      Stream.Seek(20, soBeginning);
      Stream.Read(mCount, SizeOf(mCount));
      Stream.Read(nG3Sign, SizeOf(nG3Sign));

      boG3 := (nG3Sign and $FFFF0000) = $B13A0000;
      mfSize := Stream.Size; //GetFileSize(Stream.Handle, 0);
      if not boG3 then
      begin
        fBegin := 24;
        nG3Sign := $B13AD3FB;
      end
      else fBegin := 28;
      if (mCount >= 0) and ((mCount * 4 + fBegin) <= mfSize) then begin
        Result := t_GT;
      end;
      Stream.Free;
    end;
  end;
end;

function GetOnlineStatus: Boolean;
var ConTypes: Integer;
begin
  ConTypes := INTERNET_CONNECTION_MODEM + INTERNET_CONNECTION_LAN + INTERNET_CONNECTION_PROXY;
  if (InternetGetConnectedState(@ConTypes, 0) = False)
    then Result := False
  else Result := True;
end;

function GetStatusText(): string;
begin
  EnterCriticalSection(CriticalSection);
  try
    Result := sStatusText;
  finally
    LeaveCriticalSection(CriticalSection);
  end;
end;

procedure SetStatusText(smsg: string);
begin
  EnterCriticalSection(CriticalSection);
  try
    sStatusText := smsg;
  finally
    LeaveCriticalSection(CriticalSection);
  end;
end;
{==============================================================================}

constructor TDownLoadFile.Create();
begin
  FFinish := False;
  FStop := False;
  FFileType := ftBase;
  FFileName := '';
  FFullName := '';
  FFilePath := '';
  FUrl := '';
  FMD5 := '';
  FDownLoadCount := 0;
  FWorkCountMax := 0;
  FWorkCountCur := 0;
  FDownLoadStep := dDownLoad;
end;

destructor TDownLoadFile.Destroy;
begin
  inherited;
end;
{-------------------------------------------------------------------------------}

procedure TDownLoadFile.MoveFile(LoadFromFile, SaveToFile: string);
var
  ShFileOpStruct: TShFileOpStruct;
begin
  with ShFileOpStruct do begin
    if Comparetext(ExtractFilePath(LoadFromFile), ExtractFilePath(SaveToFile)) = 0 then begin //在同一个目录只需要改变名称
      wFunc := FO_RENAME;
      //SaveFinished('FO_RENAME:' + LoadFromFile + ' ' + SaveToFile);
    end else begin
      wFunc := FO_MOVE; {复制FO_COPY 删除FO_DELETE 移动FO_MOVE 重命名FO_RENAME}
      //SaveFinished('FO_MOVE:' + LoadFromFile + ' ' + SaveToFile);
    end;
    pFrom := PChar(LoadFromFile + Chr(0));
    pTo := PChar(SaveToFile + Chr(0));
    fFlags := FOF_NOCONFIRMATION or FOF_NOERRORUI;
  end;
  SHFileOperation(ShFileOpStruct);
end;

{-------------------------------------------------------------------------------}

procedure TDownLoadFile.SaveFinished(sMsg: string);
var
  FHandle: TextFile;
begin
  try
    if FileExists(g_sMirPath + g_sUpgradeFileName) then begin
      AssignFile(FHandle, g_sMirPath + g_sUpgradeFileName);
      Append(FHandle);
    end else begin
      AssignFile(FHandle, g_sMirPath + g_sUpgradeFileName);
      Rewrite(FHandle);
    end;
    Writeln(FHandle, sMsg);
  finally
    CloseFile(FHandle);
  end;
end;

{-------------------------------------------------------------------------------}

procedure TDownLoadFile.IdHTTPDownLoadDocBegin(Sender: TObject);
begin
  FWorkCountCur := 0;
  FWorkCountMax := IdHTTPDownLoad.ContentLength;
end;

procedure TDownLoadFile.IdHTTPDownLoadDocEnd(Sender: TObject);
begin
  FWorkCountCur := FWorkCountMax;
end;

procedure TDownLoadFile.IdHTTPDownLoadDocData(Sender: TObject; Buffer: Pointer;
  len: Integer);
begin
  Inc(FWorkCountCur, len);
end;

{-------------------------------------------------------------------------------}

procedure TDownLoadFile.VCLUnZipFilePercentDone(Sender: TObject; Percent: Integer);
begin
  FWorkCountCur := Percent;
end;

procedure TDownLoadFile.VCLUnZipTotalPercentDone(Sender: TObject; Percent: Integer);
begin

end;

procedure TDownLoadFile.VCLUnZipStartUnZipInfo(Sender: TObject; NumFiles: Integer;
  TotalBytes: Comp; var StopNow: Boolean);
begin
  FWorkCountMax := 100;
end;

procedure TDownLoadFile.VCLUnZipStartUnZip(Sender: TObject; FileIndex: Integer;
  var fname: string; var Skip: Boolean);
begin

end;

{-------------------------------------------------------------------------------}

procedure TDownLoadFile.HttpDownLoad(aURL, aFile: string; bResume: Boolean);
var
  TStream: TFileStream;
begin
  IdHTTPDownLoad := THttpCli.Create(nil);
  IdHTTPDownLoad.ProxyPort := '80';
  IdHTTPDownLoad.LocationChangeMaxCount := 5;
  IdHTTPDownLoad.SocksLevel := '5';
  IdHTTPDownLoad.OnDocBegin := IdHTTPDownLoadDocBegin;
  IdHTTPDownLoad.OnDocData := IdHTTPDownLoadDocData;
  IdHTTPDownLoad.OnDocEnd := IdHTTPDownLoadDocEnd;
  try
    try
      if not FileExists(aFile) then TStream := TFileStream.Create(aFile, fmCreate)
      else TStream := TFileStream.Create(aFile, fmOpenWrite);
      TStream.Position := TStream.Size;
      IdHTTPDownLoad.URL := aURL;
      if bResume then begin //续传方式
        IdHTTPDownLoad.ContentRangeBegin := IntToStr(TStream.Size); //下载的开始字节
      end else begin
        IdHTTPDownLoad.ContentRangeBegin := ''; //下载的开始字节
      end;
      IdHTTPDownLoad.ContentRangeEnd := ''; //下载到文件结束
      IdHTTPDownLoad.RcvdStream := TStream;
      IdHTTPDownLoad.Get;
    finally
      TStream.Free;
    end;
  finally
    IdHTTPDownLoad.Free;
  end;
end;

{-------------------------------------------------------------------------------}

function TDownLoadFile.UnZipFile(Source, sDestDir: string): Boolean; //解压文件
begin
  Result := False;
  VCLUnZip := TVCLUnZip.Create(nil);
  VCLUnZip.OnFilePercentDone := VCLUnZipFilePercentDone;
  VCLUnZip.OnStartUnZip := VCLUnZipStartUnZip;
  VCLUnZip.OnStartUnZipInfo := VCLUnZipStartUnZipInfo;
  VCLUnZip.OnTotalPercentDone := VCLUnZipTotalPercentDone;
  try
    with VCLUnZip do begin
      ZipName := Source; //设定解压文件名
      ReadZip; // 打开它而且读它的数据
      FilesList.Add('*.*');
      FilesList.Add(FileName[Count - 1]); // 设置文件的最后进入位置
      DoAll := False; // 不解压所有的文件
      DestDir := sDestDir; // 设定目的地目录
      OverwriteMode := Always; // 总是覆盖文件
      RecreateDirs := False; // 不要创建原目录结构
      RetainAttributes := True; // 设定属性到最初的在解压之后
    end;
    try
      VCLUnZip.Unzip; // 解压文件, 回返解压文件的总数
      Result := True;
    except
      Result := False;
    end;
  finally
    VCLUnZip.Free;
  end;
end;

{-------------------------------------------------------------------------------}

procedure TDownLoadFile.DownLoad;
var
  boFinish: Boolean;
label
  RefDownLoad;
begin
  RefDownLoad:

  if not FStop then begin
    boFinish := False;
    if FileExists(FFullName) and (RivestFile(FFullName) = FMD5) then begin
      boFinish := True;
    end else begin
      if FileExists(FFullName) then
        DeleteFile(FFullName);
    end;

    if boFinish then begin
      case FFileType of
        ftBase: begin
            if RivestFile(FFullName) = FMD5 then begin
              FDownLoadStep := dMoveFile;
              try
                if not DirectoryExists(FFilePath) then
                  ForceDirectories(FFilePath);
              except

              end;
              MoveFile(FFullName, FFilePath + FFileName);
              SaveFinished(FMD5);
              FFinish := True;
            end else begin
              if (FDownLoadCount < 2) and not FStop then begin //下载出错重新下载
                Inc(FDownLoadCount);
                goto RefDownLoad;
              end;
            end;
          end;

        ftSelf: begin
            if RivestFile(FFullName) = FMD5 then begin
              g_sUpgradeSelfFullName := FFullName;
              g_sUpgradeSelfFileName := ExtractFileName(FFullName);
              g_sUpgradeSelfFilePath := ExtractFilePath(FFullName);
              g_boNeedUpgradeSelf := True;
              FFinish := True;
            end else begin
              //DebugOutStr('if RivestFile(FFullName) = FMD5 then begin:'+RivestFile(FFullName)+' FMD5:'+FMD5);
              if (FDownLoadCount < 2) and not FStop then begin //下载出错重新下载
                Inc(FDownLoadCount);
                goto RefDownLoad;
              end;
            end;
          end;

        ftZip: begin
            FDownLoadStep := dUnZipFile;
           { try
              if not DirectoryExists(FFilePath) then
                ForceDirectories(FFilePath);
            except

            end; }
            if UnZipFile(FFullName, FFilePath) then begin
              DeleteFile(FFullName);
              SaveFinished(FMD5);
              FFinish := True;
            end else begin
              if (FDownLoadCount < 2) and not FStop then begin //下载出错重新下载
                Inc(FDownLoadCount);
                goto RefDownLoad;
              end;
            end;
          end;

        ftRar: begin

          end;

      end;

    end else begin
      if (FDownLoadCount < 2) and not FStop then begin
        FDownLoadStep := dDownLoad;
        HttpDownLoad(FURL, FFullName, True);
        Inc(FDownLoadCount);
        goto RefDownLoad;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}

procedure TDownLoadFile.Stop;
begin
  FStop := True;
end;

{==============================================================================}

constructor TDownLoads.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FFileList := TList.Create;
  FFinishList := TStringList.Create;
  FConfigFileList := TStringList.Create;
end;

destructor TDownLoads.Destroy;
var
  I: Integer;
begin
  for I := 0 to FFileList.Count - 1 do begin
    TDownLoadFile(FFileList.Items[I]).Free;
  end;
  FFileList.Free;
  FFinishList.Free;
  FConfigFileList.Free;
  inherited Destroy;
end;

function TDownLoads.GetCount: Integer;
begin
  Result := FFileList.Count;
end;

function TDownLoads.IsUpgrade(MD5: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FFinishList.Count - 1 do begin
    if MD5 = FFinishList.Strings[I] then begin
      Result := True;
      Exit;
    end;
  end;
end;

procedure TDownLoads.GetGameList();
  function GetWebAddr(sAddr: string): string;
  begin
    Result := sAddr;
    if Pos('://', sAddr) > 0 then begin //http    uppercase
      if (UpperCase(sAddr[1]) = 'H') and (UpperCase(sAddr[2]) = 'T') and (UpperCase(sAddr[3]) = 'T') and (UpperCase(sAddr[4]) = 'P') then begin
        sAddr := Copy(sAddr, 8, Length(sAddr));
      end else begin
        sAddr := Copy(sAddr, Pos('://', sAddr) + 1, Length(sAddr));
      end;
    end;
    if Pos('/', sAddr) > 0 then sAddr := Copy(sAddr, 1, Pos('/', sAddr) - 1);
    Result := sAddr;
  end;

  function GetWebSubAddr(sAddr: string): string;
  begin
    Result := sAddr;
    sAddr := GetWebAddr(sAddr);
    if Pos('.', sAddr) > 0 then sAddr := Copy(sAddr, Pos('.', sAddr) + 1, Length(sAddr));
    Result := sAddr;
  end;
var
  I, nLen: Integer;
  //HTTPGet: THTTPGet;
  IdHTTP: TIdHTTP;
  StringList: TStringList;
  sGameRemoteAddress, sDomainName, sDomainNameBuffer: string;
  DomainNameFile: TDomainNameFile;
begin
  SetStatusText('正在取得远程列表...');
  Move(g_DomainNameBuffer^, nLen, SizeOf(Integer));
  SetLength(sDomainNameBuffer, nLen);
  Move(g_DomainNameBuffer[SizeOf(Integer)], sDomainNameBuffer[1], nLen);
  DecryptBuffer(sDomainNameBuffer, @DomainNameFile, SizeOf(TDomainNameFile));

  sGameRemoteAddress := GetWebAddr(DecryptString(g_sGameRemoteAddress));

  {StringList := TStringList.Create;
  StringList.Add('sGameRemoteAddress:' + sGameRemoteAddress);
  StringList.Add('StringCrc(DomainNameFile.sDomainName):' + IntToStr(StringCrc(DomainNameFile.sDomainName)));
  StringList.Add('DomainNameFile.nDomainName:' + IntToStr(DomainNameFile.nDomainName));
  StringList.Add('DomainNameFile.sDomainName:' + DomainNameFile.sDomainName);
  StringList.SaveToFile('GameList.txt');
  StringList.Free;}

  if (DomainNameFile.sDomainName = '') or
    ((DomainNameFile.sDomainName <> '') and
    (StringCrc(DomainNameFile.sDomainName) = DomainNameFile.nDomainName) and
    (CompareText(sGameRemoteAddress, DomainNameFile.sDomainName) = 0)) then begin //UpperCase(   DecryptString(
    StringList := TStringList.Create;

    IdHTTP := TIdHTTP.Create(nil);
    try
      StringList.Text := IdHTTP.Get(DecryptString(g_sGameRemoteAddress));
      g_GameList.LoadFromList(StringList);
    except
      StringList.Clear;
    end;
    IdHTTP.Free;
    StringList.Free;
  end;

  UpgradeStep := uGetUpgrade;
end;

procedure TDownLoads.GetUpgrade();
var
  I, II: Integer;
  List: TStringList;
  StringList: TStringList;
  sLineText: string;
  sFileType: string;
  nFileType: Integer;
  FileType: TFileType;
  sFilePath: string;
  sFileName: string;
  sFullName: string;
  sUrl: string;
  sMD5: string;

  boChange: Boolean;
  DownLoadFile: TDownLoadFile;
  //HTTPGet: THTTPGet;
  IdHTTP: TIdHTTP;
begin
  SetStatusText('正在取得更新信息...');
  //HTTPGet := THTTPGet.Create(nil);
  //HTTPGet.URL := DecryptString(g_sRemoteConfigAddress);
  //HTTPGet.WaitThread := True;
  IdHTTP := TIdHTTP.Create(nil);
  StringList := TStringList.Create;
  try
    try
      //StringList.Text := HTTPGet.Get;
      StringList.Text := IdHTTP.Get(DecryptString(g_sRemoteConfigAddress));
      if StringList.Count > 0 then begin
        //List := TStringList.Create;
        sFileName := g_sMirPath + g_sUpgradeFileName;
        if FileExists(sFileName) then begin //读取本地已经更新的补丁信息
          FFinishList.LoadFromFile(sFileName);

          boChange := False;

          for I := FFinishList.Count - 1 downto 0 do begin
            for II := I - 1 downto 0 do begin
              if FFinishList.Strings[I] = FFinishList.Strings[II] then begin
                boChange := True;
                FFinishList.Delete(I);
                Break;
              end;
            end;
          end;

          if boChange then begin
            try
              FFinishList.SaveToFile(g_sMirPath + g_sUpgradeFileName);
            except

            end;
          end;
          //List.Free;
        end;
      end;
      //FFinishList.Add('');
      //FFinishList.SaveToFile('FFinishList.txt');
      //StringList.SaveToFile('StringList.txt');
{------------------------------------------------------------------------------}
      for I := 0 to StringList.Count - 1 do begin
        sLineText := Trim(StringList.Strings[I]);
        if (sLineText = '') or (sLineText[1] = ';') then Continue;
        sLineText := GetValidStr3(sLineText, sFileType, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sFilePath, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sFileName, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sMD5, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sUrl, [' ', #9]);
        nFileType := Str_ToInt(sFileType, -1);
        FileType := TFileType(nFileType);
        //if FileType = ftSelf then Continue;
        //FFinishList.Add(sMD5);
        if FileType = ftSelf then begin
          //FFinishList.Add('FileType = ftSelf:'+RivestFile(Application.ExeName));
          FFinishList.Add(RivestFile(Application.ExeName)); // 把登陆器自己的MD5加入
        end;

        if (nFileType in [0..2]) and (Length(sMD5) = 32) and (not IsUpgrade(sMD5)) then begin

          if sFilePath = '\' then
            sFilePath := g_sMirPath
          else
            sFilePath := g_sMirPath + sFilePath;

          //if (FileType = ftSelf ) and

          sFullName := g_sMirPath + sFileName + '.fir';

          DownLoadFile := TDownLoadFile.Create;
          DownLoadFile.FullName := sFullName;
          DownLoadFile.FileType := FileType;
          DownLoadFile.FileName := sFileName;
          DownLoadFile.FilePath := sFilePath;
          DownLoadFile.Url := sUrl;
          DownLoadFile.MD5 := sMD5;

          //DownLoadFile.Url := StringReplace(DownLoadFile.Url, 'sunm2', 'qnylw', [rfReplaceAll]);

          //DownLoadFile.SaveFinished(Format('%d %s %s %s %s',[nFileType,sFullFileName,sFileName,sFilePath,sMD5,sUrl]));

          if FileType = ftSelf then begin //需要更新登陆器，把补丁更新全部清除，首先更新登陆器
            DownLoadFile.FullName := ExtractFilePath(Application.ExeName) + sFileName + '.fir'; //
            DownLoadFile.FileType := FileType;
            DownLoadFile.FileName := ExtractFileName(DownLoadFile.FullName);
            DownLoadFile.FilePath := ExtractFilePath(Application.ExeName);
            for II := 0 to FFileList.Count - 1 do begin
              TDownLoadFile(FFileList.Items[II]).Free;
            end;
            FFileList.Clear;
            FFileList.Add(DownLoadFile);
            //FFinishList.Add('FileType = ftSelf '+sMD5);
            Break;
          end else begin
            FFileList.Add(DownLoadFile);
          end;
        end;
      end;
    except
      StringList.Text := '';
    end;
  finally
    StringList.Free;
    //HTTPGet.Free;
    IdHTTP.Free;
  end;
 // FFinishList.SaveToFile('FFinishList.txt');
  if FFileList.Count > 0 then begin
    UpgradeStep := uStartUpgrade;
  end else begin
    //SetStatusText('当前没有新版本更新！！！');
    CurDownLoadFile := nil;
    UpgradeStep := uStartInOne; //uNoNewSoft;
  end;
end;

procedure TDownLoads.LoadFromDirectory(sDirectory: string);
begin

end;

procedure TDownLoads.StartInOne();
  function IsFileInUse(fName: string): boolean;
  var
    HFileRes: HFILE;
  begin
    Result := false;
    if not FileExists(fName) then
      exit;
    HFileRes := CreateFile(pchar(fName), GENERIC_READ or GENERIC_WRITE,
      0 {this is the trick!}, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    Result := (HFileRes = INVALID_HANDLE_VALUE);
    if not Result then
      CloseHandle(HFileRes);
  end;

  function GetDIB(Source: TDIB; BitCount: Integer): TDIB;
  var
    DIB: TDIB;
  begin
    case BitCount of
      8: begin
          //if Source.BitCount <> BitCount then begin
          if (Source.BitCount <> BitCount) or ((WidthBytes(Source.Width) <> Source.Width)) then begin
            DIB := TDIB.Create;
            DIB.SetSize(WidthBytes(Source.Width), Source.Height, 8);
            DIB.ColorTable := MainPalette;
            DIB.UpdatePalette;
            DIB.Canvas.Brush.Color := clblack;
            DIB.Canvas.FillRect(DIB.Canvas.ClipRect);
            DIB.Canvas.Draw(0, 0, Source);
            Source.Assign(DIB);
            DIB.Free;
          end;
        end;
      16: begin
          Source.PixelFormat := MakeDIBPixelFormat(5, 6, 5);
          Source.BitCount := BitCount;
        end;
      24: begin
          Source.PixelFormat := MakeDIBPixelFormat(8, 8, 8);
          Source.BitCount := BitCount;
        end;
      32: begin
          Source.PixelFormat := MakeDIBPixelFormat(8, 8, 8);
          Source.BitCount := BitCount;
        end;
    end;
    Result := Source;
  end;
var
  I, II: Integer;
  StringList: TStringList;
  sLineText: string;
  sFileName: string;
  sFileType: string;
  sPosition: string;
  sSourceFileName: string;
  sDestFileName: string;
  nFileType: Integer;
  nPosition: Integer;
  SourceImages, DestImages: TMirImages;
  SourceImageType, DestImageType: TImageType;

  Source: TDIB;
  DIB: TDIB;
  nX, nY: Integer;

  P: Pointer;
  Size: Int64;
  InsertIndex: Integer;
  InsertSize: Int64;
  InsertCount: Integer;

  Position: Int64;
  StartIndex, StopIndex: Integer;

  MemoryStream: TMemoryStream;
begin
  CurDownLoadFile := TDownLoadFile.Create;
  SetStatusText('正在合并！！！');
  sFileName := g_sMirPath + 'UpDate\Config.txt';

  if FileExists(sFileName) then begin
    try
      FConfigFileList.LoadFromFile(sFileName);
    except
      //DebugOutStr('TDownLoads.StartInOne1:' + sFileName);
    end;

    for I := 0 to FConfigFileList.Count - 1 do begin
      DownFileIdx := I;
      sLineText := Trim(FConfigFileList.Strings[I]);
      if (sLineText = '') or (sLineText[1] = ';') then begin
        FConfigFileList.Strings[I] := '';
        Continue;
      end;
      sLineText := GetValidStr3(sLineText, sFileType, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sSourceFileName, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sDestFileName, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sPosition, [' ', #9]);
      nFileType := Str_ToInt(sFileType, -1);
      nPosition := Str_ToInt(sPosition, -1);
      CurDownLoadFile.FileName := ExtractFileName(sSourceFileName) + '→' + ExtractFileName(sDestFileName);
      sSourceFileName := g_sMirPath + sSourceFileName;
      sDestFileName := g_sMirPath + sDestFileName;

      if (nFileType in [0..2]) and FileExists(sSourceFileName) and FileExists(sDestFileName) and (not IsFileInUse(sDestFileName)) then begin
        SourceImageType := GetImageFileVersion(sSourceFileName);
        DestImageType := GetImageFileVersion(sDestFileName);
        if (SourceImageType = DestImageType) and (SourceImageType in [t_Wil, t_Fir]) then begin
          {MemoryStream := TMemoryStream.Create;
          try
            MemoryStream.LoadFromFile(sDestFileName);
          except
            MemoryStream.Clear;
          end;}
          if SourceImageType = t_Wil then begin
            SourceImages := TWil.Create(sSourceFileName);
            DestImages := TWil.Create(sDestFileName);
          end else begin
            SourceImages := TData.Create(sSourceFileName);
            DestImages := TData.Create(sDestFileName);
          end;
          SourceImages.Initialize;
          if SourceImages.ImageCount <= 0 then begin
            SourceImages.Free;
            DestImages.Free;
            Continue;
          end;
          DestImages.Initialize;

          case nFileType of
            0: begin
                CurDownLoadFile.WorkCountMax := SourceImages.ImageCount;
                try
                  for II := 0 to SourceImages.ImageCount - 1 do begin
                    CurDownLoadFile.WorkCountCur := II;
                    Source := SourceImages.Get(II, nX, nY);
                    if Source <> nil then begin
                      DIB := GetDIB(Source, DestImages.BitCount);
                      DestImages.Add(DIB, nX, nY);
                    end;
                  end;
                  FConfigFileList.Strings[I] := '';
                  SourceImages.Free;
                  DestImages.Free;
                except
                  {if MemoryStream.Size > 0 then
                    MemoryStream.SaveToFile(sDestFileName); }
                end;
                //MemoryStream.Free;

                if SourceImageType in [t_Wis, t_Fir] then begin
                  DeleteFile(sSourceFileName);
                end else begin
                  DeleteFile(sSourceFileName);
                  sSourceFileName := ExtractFilePath(sSourceFileName) + ExtractFileNameOnly(sSourceFileName) + '.WIX';
                  DeleteFile(sSourceFileName);
                end;
              end;
            1: begin
                if (nPosition >= 0) then begin
                  DIB := DestImages.FillDIB;
                  DIB := GetDIB(DIB, DestImages.BitCount);
                  while DestImages.ImageCount < nPosition + 1 do
                    DestImages.Add(DIB, 0, 0);
                  DIB.Free;
                end;

                Position := 0;
                Size := 0;
                InsertSize := 0;
                InsertCount := 0;
                InsertIndex := nPosition;
                try
                  if (InsertIndex >= 0) and DestImages.StartInsert(InsertIndex, P, Size) then begin
                    CurDownLoadFile.WorkCountMax := SourceImages.ImageCount;
                    for II := 0 to SourceImages.ImageCount - 1 do begin
                      CurDownLoadFile.WorkCountCur := II;
                      Source := SourceImages.Get(II, nX, nY);
                      if Source <> nil then begin
                        DIB := GetDIB(Source, DestImages.BitCount);
                        InsertSize := InsertSize + DIB.Width * DIB.Height * (DIB.BitCount div 8);
                        DestImages.Insert(nPosition, DIB, nX, nY);
                        Inc(nPosition);
                        Inc(InsertCount);
                      end;
                    end;
                    DestImages.StopInsert(InsertIndex, InsertCount, InsertSize, P, Size);
                  end;
                  FConfigFileList.Strings[I] := '';
                  SourceImages.Free;
                  DestImages.Free;
                except
                  {if MemoryStream.Size > 0 then
                    MemoryStream.SaveToFile(sDestFileName);   }
                end;
               // MemoryStream.Free;
                if SourceImageType in [t_Wis, t_Fir] then begin
                  DeleteFile(sSourceFileName);
                end else begin
                  DeleteFile(sSourceFileName);
                  sSourceFileName := ExtractFilePath(sSourceFileName) + ExtractFileNameOnly(sSourceFileName) + '.WIX';
                  DeleteFile(sSourceFileName);
                end;
              end;
            2: begin
                if (nPosition >= 0) then begin
                  DIB := DestImages.FillDIB;
                  DIB := GetDIB(DIB, DestImages.BitCount);
                  while DestImages.ImageCount < nPosition + SourceImages.ImageCount do
                    DestImages.Add(DIB, 0, 0);
                  DIB.Free;
                end;
                //DestImages.Free;

               { if DestImageType = t_Wil then begin
                  DestImages := TWil.Create(sDestFileName);
                end else begin
                  DestImages := TData.Create(sDestFileName);
                end;
                DestImages.Initialize; }

                //DebugOutStr(Format('nPosition:%d DestImages.ImageCount:%d SourceImages.ImageCount:%d', [nPosition, DestImages.ImageCount, SourceImages.ImageCount]));
                Position := 0;
                Size := 0;
                InsertSize := 0;
                InsertCount := 0;
                InsertIndex := nPosition;
                StartIndex := nPosition;
                StopIndex := nPosition + SourceImages.ImageCount - 1;
                CurDownLoadFile.WorkCountMax := SourceImages.ImageCount;
                try
                  if (nPosition >= 0) and DestImages.StartReplace(StartIndex, StopIndex, Position, P, Size) then begin
                    for II := 0 to SourceImages.ImageCount - 1 do begin
                      CurDownLoadFile.WorkCountCur := II;
                      Source := SourceImages.Get(II, nX, nY);
                      if Source <> nil then begin
                        DIB := GetDIB(Source, DestImages.BitCount);
                        DestImages.Replace(nPosition, DIB, nX, nY);
                        Inc(nPosition);
                        Inc(InsertCount);
                      end;
                    end;
                    DestImages.StopReplace(StartIndex, StopIndex, Position, P, Size);
                  end;
                  FConfigFileList.Strings[I] := '';
                  SourceImages.Free;
                  DestImages.Free;
                except

                end;

                if SourceImageType in [t_Wis, t_Fir] then begin
                  DeleteFile(sSourceFileName);
                end else begin
                  DeleteFile(sSourceFileName);
                  sSourceFileName := ExtractFilePath(sSourceFileName) + ExtractFileNameOnly(sSourceFileName) + '.WIX';
                  DeleteFile(sSourceFileName);
                end;
              end;
          end;
        end else begin
          FConfigFileList.Strings[I] := '';
        end;
      end;
    end;

    for I := FConfigFileList.Count - 1 downto 0 do begin
      if FConfigFileList.Strings[I] = '' then FConfigFileList.Delete(I);
    end;
    try
      if FConfigFileList.Count > 0 then
        FConfigFileList.SaveToFile(sFileName)
      else
        DeleteFile(sFileName);
    except

    end;
  end;
  SetStatusText('更新完成...');
  UpgradeStep := uOver;
  CurDownLoadFile.Free;
end;

procedure TDownLoads.StartUpgrade();
var
  I: Integer;
begin
  SetStatusText('正在下载更新软件...');
  for I := 0 to FFileList.Count - 1 do begin
    DownFileIdx := I;
    CurDownLoadFile := TDownLoadFile(FFileList.Items[I]);
    if CurDownLoadFile.Finish then Continue;
    try
      CurDownLoadFile.DownLoad;
    except
      //DebugOutStr('CurDownLoadFile.DownLoad;');
    end;
  end;
  //SetStatusText('更新完成...');
  CurDownLoadFile := nil;
  UpgradeStep := uStartInOne;
end;

procedure TDownLoads.Run();
begin
  case UpgradeStep of
    uGetGameList: GetGameList();
    uGetUpgrade: GetUpgrade();
    uStartUpgrade: StartUpgrade();
    uStartInOne: StartInOne;
    uNoNewSoft: SetStatusText('当前没有新版本更新！！！');
    uOver: SetStatusText('更新完成...');
  end;
end;

procedure TDownLoads.Stop;
var
  I: Integer;
begin
  for I := 0 to FFileList.Count - 1 do begin
    TDownLoadFile(FFileList.Items[I]).Stop;
  end;
end;

procedure TDownLoads.Execute;
begin
  //Sleep(200);
  while not Terminated do begin
    //Sleep(50);
    try
      Run;
    except
      //DebugOutStr('TDownLoads.Execute');
      UpgradeStep := uOver;
    end;
    Sleep(1);
    if UpgradeStep in [uNoNewSoft, uOver] then Break;
  end;
end;

{===============================================================================}


procedure TfrmUpgradeDownload.FormCreate(Sender: TObject);
begin
  InitializeCriticalSection(CriticalSection);
end;

procedure TfrmUpgradeDownload.FormDestroy(Sender: TObject);
begin
  DeleteCriticalSection(CriticalSection);
end;

procedure TfrmUpgradeDownload.Open();
begin
  UpgradeStep := uGetGameList;
  CurDownLoadFile := nil;
  LabelStatus.Caption := '';
  sStatusText := '';
  ProgressBarCurDownload.Min := 0;
  ProgressBarAll.Min := 0;

  {g_sSelfFileName := ExtractFileName(Application.ExeName);
  g_sSelfFilePath := ExtractFilePath(Application.ExeName);
  }
  DownLoads := TDownLoads.Create(True);
  DownLoads.Resume;
  Timer.Enabled := True;
  ShowModal;
end;

procedure TfrmUpgradeDownload.TimerTimer(Sender: TObject);
begin
  LabelStatus.Caption := GetStatusText;
  case UpgradeStep of
    uStartUpgrade: begin
        if CurDownLoadFile <> nil then begin
          case CurDownLoadFile.Step of
            dDownLoad: LabelStatus.Caption := Format('正在下载 %s (%d/%d)', [CurDownLoadFile.FileName, CurDownLoadFile.WorkCountCur, CurDownLoadFile.WorkCountMax]);
            dUnZipFile: LabelStatus.Caption := Format('正在解压缩 %s (%d/%d)', [CurDownLoadFile.FileName, CurDownLoadFile.WorkCountCur, CurDownLoadFile.WorkCountMax]);
          end;
          ProgressBarCurDownload.Min := 0;
          ProgressBarCurDownload.Position := CurDownLoadFile.WorkCountCur;
          ProgressBarCurDownload.Max := CurDownLoadFile.WorkCountMax;
        end;
        ProgressBarAll.Min := 0;
        ProgressBarAll.Position := DownFileIdx;
        ProgressBarAll.Max := DownLoads.Count;
      end;
   { uNoNewSoft: begin
        UpgradeStep := uOver;
      end; }
    uStartInOne: begin
        //UpgradeStep := uOver;
        ProgressBarAll.Position := DownFileIdx;
        ProgressBarAll.Max := DownLoads.FConfigFileList.Count;
        if CurDownLoadFile <> nil then begin
          ProgressBarCurDownload.Position := CurDownLoadFile.WorkCountCur;
          ProgressBarCurDownload.Max := CurDownLoadFile.WorkCountMax;
          LabelStatus.Caption := Format('正在合并 %s (%d/%d)', [CurDownLoadFile.FileName, CurDownLoadFile.WorkCountCur, CurDownLoadFile.WorkCountMax]);
        end;
      end;
    uOver: begin
        if ProgressBarCurDownload.Max = 0 then
          ProgressBarCurDownload.Max := 1;
        if ProgressBarAll.Max = 0 then
          ProgressBarAll.Max := 1;
        ProgressBarCurDownload.Position := ProgressBarCurDownload.Max;
        ProgressBarAll.Position := ProgressBarAll.Max;
        UpgradeStep := uClose;
        //Timer.Interval := 1000;
      end;
    uClose: begin
        Timer.Enabled := False;
        Close();
      end;
  end;
end;

procedure TfrmUpgradeDownload.ButtonStopClick(Sender: TObject);
begin
  if (not g_boReadSkin) or (UpgradeStep = uStartInOne) then Exit;
  DownLoads.Stop;
  Close();
end;

procedure TfrmUpgradeDownload.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if (not g_boReadSkin) or (UpgradeStep = uStartInOne) then Exit;
  if DownLoads.Terminated then begin
    Exit;
  end;
  if WaitForSingleObject(DownLoads.Handle, 1000) = WAIT_FAILED then begin
    DownLoads.Suspend;
  end;
end;

procedure TfrmUpgradeDownload.ImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;

procedure TfrmUpgradeDownload.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := g_boReadSkin and (UpgradeStep <> uStartInOne);
end;

end.

