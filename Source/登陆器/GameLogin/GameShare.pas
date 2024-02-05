unit GameShare;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, ComCtrls,
  IniFiles, StdCtrls, SecrchInfoMain, NPCDialog, NPCMain, Dialogs, MemoryIniFiles, Forms;
const
  GAME_PASSWORD = #0#0#0#0#0#0;
  CLIENTVERSION = 0;

  WM_SENDPROCMSG = 10000;
  TESTVERSION = 0;

  GL_QUIT = 100;
  GL_FILTERMODULE = 101;

  CM_Initialize = 1000;
  CM_Finalize = 1001;
  CM_QUIT = 1100;
type
  TDomainNameArray = array[0..5 - 1] of string[50];
  TDomainNameFile = record
    nArr1: array[0..1] of Integer;
    nOwnerNumber: Integer; //QQ号码
    nArr2: array[0..1] of Integer;
    nUserNumber: Integer; //QQ号码
    nArr3: array[0..1] of Integer;
    sDomainName: string[50];
    nArr4: array[0..1] of Integer;
    nDomainName: Cardinal;
    nArr5: array[0..1] of Integer;
    DomainNameArray: TDomainNameArray;
    nArr6: array[0..1] of Integer;
    MinDate: TDateTime;
    nArr7: array[0..1] of Integer;
    MaxDate: TDateTime;
    nArr8: array[0..1] of Integer;
    boUnlimited: Boolean;
    nArr9: array[0..1] of Integer;
    nVersion: Integer;
  end;

  TPlugConfig = record
    Pos: Integer;
    Size: Integer;
    Name: string[20];
  end;
  pTPlugConfig = ^TPlugConfig;

  TConfig = record
    sUlrName: string[100];
    sHomePage: string[100];
    sConfigAddress: string[100];
    sGameAddress: string[100];
    nSize: Integer;
    nClientPos: Integer;
    nClientSize: Integer;
    PlugConfig: array[0..10 - 1] of TPlugConfig;
    Buffer: array[0..568 - 1] of Char;
  end;
  pTConfig = ^TConfig;


  TComponentConfig = record
    Visible: Boolean;
    Left: Integer;
    Top: Integer;
    Width: Integer;
    Height: Integer;
  end;
  pTComponentConfig = ^TComponentConfig;

  TComponentImage = record
    UpSize: Integer;
    HotSize: Integer;
    DownSize: Integer;
    Disabled: Integer;
  end;
  pTComponentImage = ^TComponentImage;

  TComponentConfigs = array[0..16 - 1] of TComponentConfig;
  TComponentImages = array[0..13 - 1] of TComponentImage;

  TGameLoginConfig = record
    ComponentConfigs: TComponentConfigs;
    ComponentImages: TComponentImages;
    Transparent: Boolean;
    LabelConnectColor: TColor;
    LabelConnectingColor: TColor;
    LabelDisconnectColor: TColor;
    ViewFColor: TColor;
    ViewBColor: TColor;
  end;
  pTGameLoginConfig = ^TGameLoginConfig;

  TMirServer = record
    sServerName: string[30];
    sServeraddr: string[30];
    nServerPort: Integer;
    boFullScreen: Boolean;
    nScreenWidth: Integer;
    nScreenHegiht: Integer;
    nClientCrc: Cardinal;
    nLoginCrc: Integer;
  end;
  pTMirServer = ^TMirServer;

  TGameZone = class
  private
    FOwner: TGameZone;
    //FShowName: string;
    FCaption: string;
    FServerName: string;
    FGameHost: string;
    FGameIPaddr: string;
    FGameIPPort: string;
    FServerPort: Integer;
    FHomePage: string;
    FNoticeUrl: string;
    FExpand: Boolean;
    FEncrypt: Boolean;
    FGameList: TStringList;
    FFileAttr: Integer;
    FConnected: Boolean;
    procedure UnLoad();
    function GetGameZone(Index: Integer): TGameZone;
    function GetCount: Integer;
  public
    m_sFileName: string;
    m_sNoticeUrl: string;
    m_nIndex: string;
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromFile(const FileName: string);
    procedure LoadFromList(const GameList: TStringList);
    procedure SaveToFile(const FileName: string);
    procedure BeginUpdate(const FileName: string);
    procedure EndUpdate(const FileName: string);
    function Add(const sCaption: string): TGameZone;
    procedure AddChild(const sCaption: string; GameZone: TGameZone);
    procedure Delete(GameZone: TGameZone); overload;
    procedure Delete(Index: Integer); overload;
    procedure DeleteChild(GameZone: TGameZone);
    function IndexOf(const sCaption: string): Integer;
    function Find(const sCaption: string): Boolean;
    procedure Clear;
    property Owner: TGameZone read FOwner write FOwner;
    property Strings: TStringList read FGameList;
    property Items[Index: Integer]: TGameZone read GetGameZone;
    property Count: Integer read GetCount;
    //property ShowName: string read FShowName write FShowName;
    property Caption: string read FCaption write FCaption;
    property ServerName: string read FServerName write FServerName;
    property GameHost: string read FGameHost write FGameHost;
    property GameIPaddr: string read FGameIPaddr write FGameIPaddr;
    property ServerPort: Integer read FServerPort write FServerPort;
    property GameIPPort: string read FGameIPPort write FGameIPPort;
    property HomePage: string read FHomePage write FHomePage;
    property NoticeUrl: string read FNoticeUrl write FNoticeUrl;

    property Expand: Boolean read FExpand write FExpand;
    property Encrypt: Boolean read FEncrypt write FEncrypt;
    property Connected: Boolean read FConnected write FConnected;
  end;

var
  btCode: Byte = 1;
  boBusy: Boolean = False;
  sBufferStr: string = '';
  sSocStr: string = '';
  sMakeNewAccount: string = '';
  g_boClientSocketConnect: Boolean = False;

  //g_sSelfFileName: string;
  //g_sSelfFilePath: string;
  //g_sDownSelfFileName: string;

  ConnectRes: TResourceStream;
  ConnectingRes: TResourceStream;
  DisconnectRes: TResourceStream;

  sClientConnect: string = '服务器状态良好...';
  sClientConnecting: string = '正在测试服务器状态...';
  sClientDisconnect: string = '服务器连接失败...';

  g_nWebHeiht: Integer = 335;
  g_nGameListBoxHeight: Integer = 328;

  //g_SecrchObject: TSecrchObject;
  g_MessageDlg: TMessageDlg;
  g_NpcDlg: TNpcDlg;
  g_GameList: TGameZone;
  g_LocalGameList: TGameZone;
  g_AllGameList: TGameZone;
  g_SelGameZone: TGameZone;

  g_sDownAddress: string;
  //sDownFileName: string;

  g_boStopDown: Boolean;
  //g_boClose: Boolean;

  g_boFullScreen: Boolean = True;

  g_sRandomCode: string;

  g_CreateUlrName: string;
  g_sHomePage: string;
  g_sRemoteConfigAddress: string;
  g_sGameRemoteAddress: string;

  g_sProgamFile: string = 'MirClient.Dat';
  g_sClientFile: string = 'FirClient.dll';
  g_sGameListFileName: string = '.\Cqfir.Dat';
  g_sLocalGameListFileName: string = '.\LocalCqfir.Dat';
  g_sConfigFileName: string = '.\Update.txt';



  //g_MainImageConfig: TComponentConfig;
  g_FullScreenStartConfig: TComponentConfig;
  g_ButtonEditGameListConfig: TComponentConfig;
  g_ButtonHomePageConfig: TComponentConfig;
  g_ButtonAutoLoginConfig: TComponentConfig;
  g_ButtonUpgradeConfig: TComponentConfig;
  g_ButtonStartConfig: TComponentConfig;
  g_ButtonNewAccountConfig: TComponentConfig;
  g_ButtonGetBakPassWordConfig: TComponentConfig;
  g_ButtonChgPassWordConfig: TComponentConfig;
  g_ButtonExitGameConfig: TComponentConfig;
  g_ButtonMinConfig: TComponentConfig;
  g_ButtonCloseConfig: TComponentConfig;
  g_TreeView: TComponentConfig;
  g_WebBrowser: TComponentConfig;
  g_LabelStatus: TComponentConfig;


  g_ComponentConfigs: TComponentConfigs;

  g_boReadSkin: Boolean = False;

 { g_MainImageImage: TComponentImage;
  g_FullScreenStartImage: TComponentImage;
  g_ButtonEditGameListImage: TComponentImage;
  g_ButtonHomePageImage: TComponentImage;
  g_ButtonAutoLoginImage: TComponentImage;
  g_ButtonUpgradeImage: TComponentImage;
  g_ButtonStartImage: TComponentImage;
  g_ButtonNewAccountImage: TComponentImage;
  g_ButtonGetBakPassWordImage: TComponentImage;
  g_ButtonChgPassWordImage: TComponentImage;
  g_ButtonExitGameImage: TComponentImage;
  g_ButtonMinImage: TComponentImage;
  g_ButtonCloseImage: TComponentImage;   }


  g_GameLoginConfig: TGameLoginConfig; //TComponentImages;
  g_ComponentList: TList;
  g_Buffer: Pointer;

  g_PlugList: TStringList;


  g_sMirPath: string = '';
  g_ClientHandleList: TList;
  g_boClose: Boolean = False;
  g_sUpgradeFileName: string = 'Update.dat';

  g_sSelfFileName: string;
  g_sSelfFilePath: string;
  g_sUpgradeSelfFileName: string;
  g_sUpgradeSelfFullName: string;
  g_sUpgradeSelfFilePath: string;
  g_boNeedUpgradeSelf: Boolean = False;

  g_SearchList: TStringList;
  g_LegendPathList: TStringList;
  g_DomainNameBuffer: PChar;
procedure SendProgramMsg(DesForm: THandle; wIdent: Word; sSendMsg: string);
procedure DebugOutStr(Msg: string);
implementation
uses HUtil32, EncryptUnit;

procedure DebugOutStr(Msg: string);
var
  flname: string;
  fhandle: TextFile;
begin
  //if not boOutbugStr then Exit;
  flname := ExtractFileName(Application.ExeName) + '_Debug.txt'; //+ '.\!debug.txt';
  if FileExists(flname) then begin
    AssignFile(fhandle, flname);
    Append(fhandle);
  end else begin
    AssignFile(fhandle, flname);
    Rewrite(fhandle);
  end;
  Writeln(fhandle, TimeToStr(Time) + ' ' + Msg);
  CloseFile(fhandle);
end;

procedure SendProgramMsg(DesForm: THandle; wIdent: Word; sSendMsg: string);
var
  SendData: TCopyDataStruct;
  nParam: Integer;
begin
  nParam := MakeLong(0, wIdent);
  SendData.cbData := Length(sSendMsg) + 1;
  GetMem(SendData.lpData, SendData.cbData);
  StrCopy(SendData.lpData, PChar(sSendMsg));
  SendMessage(DesForm, WM_COPYDATA, nParam, Cardinal(@SendData));
  FreeMem(SendData.lpData);
end;


constructor TGameZone.Create();
begin
  inherited;
  FOwner := nil;
  FConnected := False;
  FGameList := TStringList.Create;
end;

destructor TGameZone.Destroy;
begin
  UnLoad();
  FGameList.Free;
  inherited;
end;

function TGameZone.GetGameZone(Index: Integer): TGameZone;
begin
  Result := TGameZone(FGameList.Objects[Index]);
end;

function TGameZone.GetCount: Integer;
begin
  Result := FGameList.Count;
end;

procedure TGameZone.Clear;
begin
  FGameList.Clear;
end;

function TGameZone.IndexOf(const sCaption: string): Integer;
var
  I: Integer;
  GameZone: TGameZone;
begin
  Result := -1;
  for I := 0 to Count - 1 do begin
    GameZone := Items[I];
    if CompareText(sCaption, GameZone.Caption) = 0 then begin
      Result := I;
      Exit;
    end;
    //if Result >= 0 then Exit;
    //Result := GameZone.IndexOf(sCaption);
  end;
end;

function TGameZone.Find(const sCaption: string): Boolean;
var
  I: Integer;
  GameZone: TGameZone;
begin
  Result := False;
  for I := 0 to Count - 1 do begin
    GameZone := Items[I];
    if CompareText(sCaption, GameZone.Caption) = 0 then begin
      Result := True;
      Exit;
    end;
    if Result then Exit;
    Result := GameZone.Find(sCaption);
  end;
end;

procedure TGameZone.LoadFromList(const GameList: TStringList);
var
  I, II: Integer;
  Ini: TMemoryIniFile;
  GameZone: TGameZone;
  GameOwner: TGameZone;
  ServerCount: Integer;
begin
  Ini := TMemoryIniFile.Create(GameList);
  for I := 0 to Ini.Sections.Count - 1 do begin
    if Ini.Sections.Strings[I] = '' then Continue;
    GameOwner := Add(Ini.Sections.Strings[I]);
    ServerCount := Ini.ReadInteger(I, 'ServerCount', 0);
    if ServerCount > 0 then begin
      for II := 0 to ServerCount - 1 do begin
        GameZone := TGameZone.Create;
        GameZone.Owner := GameOwner;
        GameZone.ServerName := Ini.ReadString(I, 'ServerName' + IntToStr(II), '');
        GameZone.Caption := Ini.ReadString(I, 'Caption' + IntToStr(II), '');
        GameZone.GameHost := Ini.ReadString(I, 'Serveraddr' + IntToStr(II), '');
        GameZone.GameIPaddr := '';
        GameZone.GameIPPort := Ini.ReadString(I, 'ServerPort' + IntToStr(II), '');
        if (GameZone.ServerName = '') or (GameZone.GameHost = '') or (GameZone.GameIPPort = '') then begin
          GameZone.Free;
          Continue;
        end;
        GameZone.HomePage := Ini.ReadString(I, 'HomePage' + IntToStr(II), '');
        GameZone.NoticeUrl := Ini.ReadString(I, 'Notice' + IntToStr(II), '');
        GameZone.Expand := Ini.ReadBool(I, 'Expand' + IntToStr(II), False);
        GameZone.Encrypt := Ini.ReadBool(I, 'Encrypt' + IntToStr(II), False);

        GameZone.Owner.AddChild(GameZone.Caption, GameZone);
      //Showmessage(GameZone.Caption);
      end;
    end;
  end;
  Ini.Free;
  //FileSetAttr(FileName, nAttr);
end;

procedure TGameZone.LoadFromFile(const FileName: string);
var
  I, II: Integer;
  Ini: TIniFile;
  Sections: TStringList;
  GameZone: TGameZone;
  GameOwner: TGameZone;
  nAttr: Integer;
  ServerCount: Integer;
begin
 { nAttr := FileGetAttr(FileName);
  FileSetAttr(FileName, 0); }
  Sections := TStringList.Create;
  Ini := TIniFile.Create(FileName);
  Ini.ReadSections(Sections);
  for I := 0 to Sections.Count - 1 do begin
    if Sections.Strings[I] = '' then Continue;
    GameOwner := Add(Sections.Strings[I]);
    ServerCount := Ini.ReadInteger(Sections.Strings[I], 'ServerCount', 0);
    if ServerCount > 0 then begin
      for II := 0 to ServerCount - 1 do begin
        GameZone := TGameZone.Create;
        GameZone.Owner := GameOwner;
        GameZone.ServerName := Ini.ReadString(Sections.Strings[I], 'ServerName' + IntToStr(II), '');
        GameZone.Caption := Ini.ReadString(Sections.Strings[I], 'Caption' + IntToStr(II), '');
        GameZone.GameHost := Ini.ReadString(Sections.Strings[I], 'Serveraddr' + IntToStr(II), '');
        GameZone.GameIPaddr := '';
        GameZone.GameIPPort := Ini.ReadString(Sections.Strings[I], 'ServerPort' + IntToStr(II), '');
        if (GameZone.ServerName = '') or (GameZone.GameHost = '') or (GameZone.GameIPPort = '') then begin
          GameZone.Free;
          Continue;
        end;
        GameZone.HomePage := Ini.ReadString(Sections.Strings[I], 'HomePage' + IntToStr(II), '');
        GameZone.NoticeUrl := Ini.ReadString(Sections.Strings[I], 'Notice' + IntToStr(II), '');
        GameZone.Expand := Ini.ReadBool(Sections.Strings[I], 'Expand' + IntToStr(II), False);
        GameZone.Encrypt := Ini.ReadBool(Sections.Strings[I], 'Encrypt' + IntToStr(II), False);

        GameZone.Owner.AddChild(GameZone.Caption, GameZone);
      //Showmessage(GameZone.Caption);
      end;
    end;
  end;
  Sections.Free;
  Ini.Free;
  //FileSetAttr(FileName, nAttr);
end;

procedure TGameZone.UnLoad();
var
  I: Integer;
begin
  for I := 0 to FGameList.Count - 1 do begin
    TGameZone(FGameList.Objects[I]).UnLoad;
    TGameZone(FGameList.Objects[I]).Free;
  end;
  FGameList.Clear;
end;

procedure TGameZone.BeginUpdate(const FileName: string);
begin
  FFileAttr := FileGetAttr(FileName);
  FileSetAttr(FileName, 0);
  DeleteFile(FileName);
end;

procedure TGameZone.EndUpdate(const FileName: string);
begin
  FileSetAttr(FileName, FFileAttr);
end;

procedure TGameZone.SaveToFile(const FileName: string);
var
  I, II: Integer;
  Ini: TIniFile;
  GameZone: TGameZone;
  ChildGameZone: TGameZone;
  //nAttr: Integer;
begin
  Ini := TIniFile.Create(FileName);
  for I := 0 to Count - 1 do begin
    GameZone := Items[I];
    if GameZone.Count > 0 then begin
      Ini.WriteInteger(GameZone.Caption, 'ServerCount', GameZone.Count);
      for II := 0 to GameZone.Count - 1 do begin
        ChildGameZone := GameZone.Items[II];
        Ini.WriteString(GameZone.Caption, 'Caption' + IntToStr(II), ChildGameZone.Caption);
        Ini.WriteString(GameZone.Caption, 'ServerName' + IntToStr(II), ChildGameZone.ServerName);
        Ini.WriteString(GameZone.Caption, 'Serveraddr' + IntToStr(II), ChildGameZone.GameHost);
        Ini.WriteString(GameZone.Caption, 'ServerPort' + IntToStr(II), ChildGameZone.GameIPPort);
        Ini.WriteString(GameZone.Caption, 'Notice' + IntToStr(II), ChildGameZone.NoticeUrl);
        Ini.WriteString(GameZone.Caption, 'HomePage' + IntToStr(II), ChildGameZone.HomePage);
        Ini.WriteBool(GameZone.Caption, 'Expand' + IntToStr(II), ChildGameZone.Expand);
        Ini.WriteBool(GameZone.Caption, 'Encrypt' + IntToStr(II), ChildGameZone.Encrypt);
        ChildGameZone.SaveToFile(FileName);
      end;
    end;
  end;
  Ini.Free;
end;

procedure TGameZone.AddChild(const sCaption: string; GameZone: TGameZone);
begin
  FGameList.AddObject(sCaption, TObject(GameZone));
end;

function TGameZone.Add(const sCaption: string): TGameZone;
var
  I, Index: Integer;
begin
  Index := IndexOf(sCaption);
  if Index < 0 then begin
    Result := TGameZone.Create;
    Result.Caption := sCaption;
    AddChild(sCaption, Result);
  end else begin
    Result := Items[Index];
  end;
end;

procedure TGameZone.Delete(GameZone: TGameZone);
var
  Index: Integer;
begin
  Index := IndexOf(GameZone.Caption);
  if Index >= 0 then begin
    Items[Index].Free;
    Delete(Index);
  end;
end;

procedure TGameZone.Delete(Index: Integer);
begin
  FGameList.Delete(Index);
end;

procedure TGameZone.DeleteChild(GameZone: TGameZone);
var
  Index: Integer;
begin
  for Index := 0 to Count - 1 do begin
    if Items[Index] = GameZone then begin
      Items[Index].Free;
      Delete(Index);
      Exit;
    end;
    Items[Index].DeleteChild(GameZone);
  end;
end;

end.

