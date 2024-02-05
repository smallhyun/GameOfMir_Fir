unit PlugCommon;

interface
uses
  Windows, Classes, SysUtils,Controls;

type
  TClientConfig = record
    btMainInterface: Byte; //0仿盛大 1仿征途 2仿外传
    btChatMode: Byte;
    boChangeSpeed: Boolean; //是否变速

    boCanRunHuman: Boolean; //穿人
    boCanRunMon: Boolean; //穿NPC
    boCanRunNpc: Boolean; //穿怪
    boCanStartRun: Boolean; //是否允许免助跑
    boParalyCanRun: Boolean; //麻痹是否可以跑
    boParalyCanWalk: Boolean; //麻痹是否可以走
    boParalyCanHit: Boolean; //麻痹是否可以攻击
    boParalyCanSpell: Boolean; //麻痹是否可以魔法


    //外挂功能变量结束
    boMoveSlow: Boolean; //负重 行动慢
    boAttackSlow: Boolean; //攻击减慢
    boStable: Boolean; //稳如泰山

    btActorLableColor: Byte;
    nStruckChgColor: Integer; //攻击变色

    dwMoveTime: LongWord;
    dwMagicPKDelayTime: LongWord;
    dwSpellTime: LongWord;
    dwHitTime: LongWord;
    dwStepMoveTime: LongWord;
    btHearMsgFColor: Byte; //喊话字体颜色


    //boShowFullScreen: Boolean;

//==================================
    boShowActorLable: Boolean;
    boHideBlueLable: Boolean;
    boShowNumberLable: Boolean; //数字显示
    boShowJobAndLevel: Boolean; //等级和职业
    boShowUserName: Boolean;
    boShowMonName: Boolean;
    boShowItemName: Boolean;
    boShowMoveLable: Boolean;
    boShowGreenHint: Boolean;
    boBGSound: Boolean; //背景音乐
    boItemHint: Boolean;
    boMagicLock: Boolean; //魔法锁定
    boOrderItem: Boolean;
    boOnlyShowCharName: Boolean;
    boPickUpItemAll: Boolean;
    boCloseGroup: Boolean;
    boDuraWarning: Boolean;
    boNotNeedShift: Boolean;
    boAutoHorse: Boolean;
    boCompareItem: Boolean;
//==================================
    boAutoHideMode: Boolean;
    dwAutoHideModeTick: LongWord;
    nAutoHideModeTime: Integer;

    boAutoUseMagic: Boolean;
    nAutoUseMagicIdx: Integer;
    dwAutoUseMagicTick: LongWord;
    nAutoUseMagicTime: Integer;


    boSmartLongHit: Boolean;
    boSmartWideHit: Boolean;
    boSmartFireHit: Boolean;
    boSmartSwordHit: Boolean;
    boSmartCrsHit: Boolean;
    boSmartZrjfHit: Boolean;
    boSmartKaitHit: Boolean;
    boSmartPokHit: Boolean;
    boSmartShield: Boolean;
    boSmartWjzq: Boolean;

    boStruckShield: Boolean;

    dwSmartWjzqTick: LongWord;

    boSmartPosLongHit: Boolean; //隔位刺杀
    boSmartWalkLongHit: Boolean; //走位刺杀
//==================================
    boChangeSign: Boolean;
    boChangePoison: Boolean;
    nPoisonIndex: Integer;
//==================================
    boUseHotkey: Boolean;
    nSerieSkill: Integer;
    nHeroCallHero: Integer;
    nHeroSetTarget: Integer;
    nHeroUnionHit: Integer;
    nHeroSetAttackState: Integer;
    nHeroSetGuard: Integer;
    nSwitchAttackMode: Integer;
    nSwitchMiniMap: Integer;
//=================================
    boHeroControlStatus: Boolean;
//=================================
    boRenewHumHPIsAuto1: Boolean;
    boRenewHumMPIsAuto1: Boolean;

    nRenewHumHPIndex1: Integer;
    nRenewHumMPIndex1: Integer;

    nRenewHumHPTime1: Integer;
    nRenewHumHPPercent1: Integer;

    nRenewHumMPTime1: Integer;
    nRenewHumMPPercent1: Integer;



    boRenewHumHPIsAuto2: Boolean;
    boRenewHumMPIsAuto2: Boolean;

    nRenewHumHPIndex2: Integer;
    nRenewHumMPIndex2: Integer;

    nRenewHumHPTime2: Integer;
    nRenewHumHPPercent2: Integer;

    nRenewHumMPTime2: Integer;
    nRenewHumMPPercent2: Integer;


//=================================

    boRenewHeroHPIsAuto1: Boolean;
    boRenewHeroMPIsAuto1: Boolean;

    nRenewHeroHPIndex1: Integer;
    nRenewHeroMPIndex1: Integer;

    nRenewHeroHPTime1: Integer;
    nRenewHeroHPPercent1: Integer;

    nRenewHeroMPTime1: Integer;
    nRenewHeroMPPercent1: Integer;


    boRenewHeroHPIsAuto2: Boolean;
    boRenewHeroMPIsAuto2: Boolean;

    nRenewHeroHPIndex2: Integer;
    nRenewHeroMPIndex2: Integer;

    nRenewHeroHPTime2: Integer;
    nRenewHeroHPPercent2: Integer;

    nRenewHeroMPTime2: Integer;
    nRenewHeroMPPercent2: Integer;



    boRenewCloseIsAuto: Boolean;
    nRenewCloseTime: Integer;
    nRenewClosePercent: Integer;

    boRenewBookIsAuto: Boolean;
    nRenewBookTime: Integer;
    nRenewBookPercent: Integer;
    nRenewBookNowBookIndex: Integer;
    sRenewBookNowBookItem: string;

    boRenewChangeSignIsAuto: Boolean;
    boRenewChangePoisonIsAuto: Boolean;
    nRenewPoisonIndex: Integer;

    boRenewHeroLogOutIsAuto: Boolean;
    nRenewHeroLogOutTime: Integer;
    nRenewHeroLogOutPercent: Integer;
//==============================================================================
    boGuaji: Boolean;
  end;
  pTClientConfig = ^TClientConfig;

  TServerConfig = record
    btShowClientItemStyle: Byte;
    boAllowItemAddValue: Boolean;
    boAllowItemTime: Boolean;
    boAllowItemAddPoint: Boolean;
    boCheckSpeedHack: Boolean;
    nGreenNumber: Integer;
    boRUNHUMAN: Boolean;
    boRUNMON: Boolean;
    boRunNpc: Boolean;
    boChgSpeed: Boolean;
    nFireDelayTime: Integer;
    nKTZDelayTime: Integer;
    nPKJDelayTime: Integer;
    nSkill50DelayTime: Integer;
    nZRJFDelayTime: Integer;
    nMaxLevel: LongInt;
  end;
  pTServerConfig = ^TServerConfig;

  TShortString = packed record
    btLen: Byte;
    Strings: array[0..High(Byte) - 1] of Char;
  end;
  PTShortString = ^TShortString;

  TServerName = procedure(ShortString: PTShortString); stdcall;
  TSetName = procedure(SelChrName: PChar); stdcall;

  TOpenHomePage = procedure(HomePage: PChar); stdcall;


  TSetActiveControl = procedure(Control: TWinControl); stdcall;

  TInitialize = procedure; stdcall;
  TKeyDown = function(Key: Word; Shift: TShiftState): Boolean; stdcall;
  TKeyPress = function(Key: Char): Boolean; stdcall;


  TPlayer = procedure(FileName: PChar; boShow, boPlay: Boolean); stdcall;
  TPlayerVisible = function: PBoolean; stdcall;

  TSetPlayerUrl = procedure(AUrl: PChar); stdcall;

  TStopPlay = procedure(FileName: PChar); stdcall;
  TMediaPlayer = record
    WindowsMediaPlayer: TWinControl;
    Player: TPlayer;
    Visible: TPlayerVisible;
    Play: TInitialize;
    Stop: TInitialize;
    Pause: TInitialize;
    StopPlay: TStopPlay;
    Url: TSetPlayerUrl;
  end;

  TPlugInfo = record
    AppHandle: THandle;
    HookInitialize: TInitialize;
    HookInitializeEnd: TInitialize;
    HookFinalize: TInitialize;
    HookKeyDown: TKeyDown;
    HookKeyPress: TKeyPress;
    Account: TServerName;
    PassWord: TServerName;

    OpenHomePage: TOpenHomePage;
    MediaPlayer: TMediaPlayer;

    KeyDown: TKeyDown;
    KeyPress: TKeyPress;

    Config: pTClientConfig;
    ServerName: TServerName;
    SelChrName: TServerName;
    SetSelChrName: TSetName;

    FullScreen: PBoolean;

    ServerConfig: pTServerConfig;
  end;
  pTPlugInfo = ^TPlugInfo;



  TDLLData = record
    HookMsg: THandle;
    MsgHooked: Boolean;
    Handle: THandle;
    Index: Integer;
  end;
  pTDLLData = ^TDLLData;

  TClientData = record
    PreviousHandle: THandle;
    RunCounter: Integer;
    RunConnt: Integer;
    Handle: array[0..4] of THandle;
    Hooked: array[0..4] of Boolean;
    PlugInfo: array[0..4] of pTPlugInfo;
  end;
  pTClientData = ^TClientData;

procedure ShortStringToPChar(S: PTShortString; pszDest: PChar);
function ShortStringToString(S: PTShortString): string;
var
  g_PlugInfo: pTPlugInfo;
  g_ClientData: pTClientData;
  g_DLLData: pTDLLData;
implementation

function ShortStringToString(S: PTShortString): string;
begin
  Result := '';
  if S.btLen > 0 then begin
    SetLength(Result, S.btLen + 1);
    Move(S.Strings, Result[1], S.btLen);
    Result[S.btLen + 1] := #0;
  end;
end;

procedure ShortStringToPChar(S: PTShortString; pszDest: PChar);
begin
  Move(S.Strings, pszDest^, S.btLen);
  pszDest[S.btLen] := #0;
end;

end.

