unit GameEngn;

interface
uses
  windows, Messages, SysUtils, Classes, Graphics, Controls, ExtCtrls, HUtil32, Dialogs,
  WinSock, Forms, EncryptUnit, ObjActor, Grobal, Grobal2, JSocket, IniFiles, ClFunc,
  CShare, Share, APIHook;
type
  TConnectionStep = (cnsLogin, cnsSelChr, cnsPlay);

  TGameSocket = class
    m_ConnectionStep: TConnectionStep;
    m_UserCriticalSection: TRTLCriticalSection;
    m_SocketCriticalSection: TRTLCriticalSection;
    m_btCode: Byte;
    m_sSockText: string;
    m_sBufferText: string;
    WinSend: TSockProc;
    m_dwReviceTick: LongWord;
  private
    FSendText: string;
    FReviceText: string;
    FSocket: TSocket;

    FReviceTick: LongWord;
  public
    constructor Create();
    destructor Destroy; override;

    procedure Read(var Buf; var nLen: Integer);
    procedure Send(var Buf; var nLen: Integer);
    procedure Lock;
    procedure UnLock;
    procedure SocketLock;
    procedure SocketUnLock;

    function SendToServer(const Text: string): Integer;
    function SendToClient(const Text: string): Integer;
    procedure SendClientMessage(Msg, Recog, param, tag, series: Integer);
    procedure SendSocket(sendstr: string);
    property Socket: TSocket read FSocket write FSocket;
    property SendText: string read FSendText write FSendText;
    property ReviceText: string read FReviceText write FReviceText;
  end;

  TGameEngine = class(TThread) //DecodeMessagePacket
    m_UserCriticalSection: TRTLCriticalSection;
    m_boSendRunLogin: Boolean;
    Timer: TTimer;
    TimerRun: TTimer;

    TimerUseItem: TTimer;
    m_dwHumUseMagicTick: LongWord;
    m_dwHeroUseMagicTick: LongWord;
    m_dwAutoSayMsgTick: LongWord;
    m_dwAutoQueryBagItemTick: LongWord;

    m_sCharStatusChange: string;
    m_sTurn: string;
    m_sWalk: string;
    m_sBackStep: string;
    m_sRush: string;
    m_sRushKung: string;
    m_sRun: string;
    m_sHorseRun: string;
    m_sDigup: string;
    m_sAlive: string;
    m_UserEatItemList: TStringList;


    m_sEatOK: string;
    m_sEatFail: string;

    m_sHeroEatOK: string;
    m_sHeroEatFail: string;

    Config: TConfig;
    m_UseItemEvent: array[0..4 - 1] of TNotifyEvent;
    m_HeroUseItemEvent: array[0..2 - 1] of TNotifyEvent;

    m_UnbindItemList: TGList;
    m_boUserLogin: Boolean;
    m_dwCheckTick: LongWord;
    m_nCheckIndex: Integer;
    m_dwSayMessageTick: LongWord;
    m_nSayMessageIndex: Integer;
    m_Real: Real;
    m_boSoftClose: Boolean;
    m_dwSendTick: LongWord;

    m_btSelAutoEatItem: Byte;
    m_btHeroSelAutoEatItem: Byte;

    m_dwKeyDownTick: LongWord;
    m_dwOpenFormTick: LongWord;
    m_boLoadConfig: Boolean;
    m_dwLoadConfigTick: LongWord;


    m_btVersion: Byte;
    m_sSockText: string;
    m_sBufferText: string;

    m_sSendSockText: string;
    m_sSendBufferText: string;

    m_sServerName: string;
    m_sAccount: string;
    m_sChrName: string;

    m_sMapTitle: string;
    m_sMapName: string;

    m_nSessionID: Integer;
    m_nClientVersion: Integer;

    m_nCodeMsgSize: Integer;

    m_MySelf: TActor;
    m_MyHero: TActor;
    m_TargetCret: TActor;
    m_FocusCret: TActor;
    m_MagicTarget: TActor;

    m_SoftClose: Boolean;
    m_boLogin: Boolean;
    m_DropItems: TList;
    m_DropedItemList: TList;
    m_ActorList: TList;
    m_FreeActorList: TList;
    m_MagicList: TList;
    m_ChangeFaceReadyList: TList;
    m_HeroMagicList: TList;

    m_nMaxBagCount: Integer;


    m_sGameGoldName: string;
    m_sGamePointName: string;
    m_boMapMoving: Boolean;

  //NPC 相关
    m_sCurMerchantName: string;
    m_sCurMerchantSay: string;
    m_nCurMerchantFace: Integer;
    m_nCurMerchant: Integer;
    m_nMDlgX: Integer;
    m_nMDlgY: Integer;
    m_dwChangeGroupModeTick: LongWord;
    m_dwDealActionTick: LongWord;
    m_dwQueryMsgTick: LongWord;
    m_nDupSelection: Integer;

    m_boAllowGroup: Boolean;

  //人物信息相关
    m_nBonusPoint: Integer;
    m_BonusTick: TNakedAbility;
    m_BonusAbil: TNakedAbility;
    m_NakedAbil: TNakedAbility;
    m_BonusAbilChg: TNakedAbility;

    m_nMySpeedPoint: Integer; //敏捷
    m_nMyHitPoint: Integer; //准确
    m_nMyAntiPoison: Integer; //魔法躲避
    m_nMyPoisonRecover: Integer; //中毒恢复
    m_nMyHealthRecover: Integer; //体力恢复
    m_nMySpellRecover: Integer; //魔法恢复
    m_nMyAntiMagic: Integer; //魔法躲避
    m_nMyHungryState: Integer; //饥饿状态
    m_wAvailIDDay: Word;
    m_wAvailIDHour: Word;
    m_wAvailIPDay: Word;
    m_wAvailIPHour: Word;

    m_nMyHeroSpeedPoint: Integer; //敏捷
    m_nMyHeroHitPoint: Integer; //准确
    m_nMyHeroAntiPoison: Integer; //魔法躲避
    m_nMyHeroPoisonRecover: Integer; //中毒恢复
    m_nMyHeroHealthRecover: Integer; //体力恢复
    m_nMyHeroSpellRecover: Integer; //魔法恢复
    m_nMyHeroAntiMagic: Integer; //魔法躲避
    m_nMyHeroHungryState: Integer; //饥饿状态



    m_UseItems_IGE: TUseItems_IGE;
    m_ItemArr_IGE: TItemArr_IGE;
    m_HeroUseItems_IGE: TUseItems_IGE;
    m_HeroItemArr_IGE: THeroItemArr_IGE;

    {m_EatingItem_IGE: TClientItem_IGE;
    m_HeroEatingItem_IGE: TClientItem_IGE; }
  //买卖相关
    m_SellDlgItem_IGE: TClientItem_IGE;
    m_SellDlgItemSellWait_IGE: TClientItem_IGE;
    m_DealDlgItem_IGE: TClientItem_IGE;


    m_UseItems_BLUE: TUseItems_BLUE;
    m_ItemArr_BLUE: TItemArr_BLUE;
    m_HeroUseItems_BLUE: TUseItems_BLUE;
    m_HeroItemArr_BLUE: THeroItemArr_BLUE;

    {m_EatingItem_BLUE: TClientItem_BLUE;
    m_HeroEatingItem_BLUE: TClientItem_BLUE; }


    m_EatingItem: TUserEatItems;
    m_HeroEatingItem: TUserEatItems;

    m_EatingItem2: TUserEatItems;
    m_HeroEatingItem2: TUserEatItems;
  //买卖相关
    m_SellDlgItem_BLUE: TClientItem_BLUE;
    m_SellDlgItemSellWait_BLUE: TClientItem_BLUE;
    m_DealDlgItem_BLUE: TClientItem_BLUE;

    m_boQueryPrice: Boolean;
    m_dwQueryPriceTime: LongWord;
    m_sSellPriceStr: string;

  //交易相关
    m_DealItems_IGE: array[0..9] of TClientItem_IGE;
    m_DealRemoteItems_IGE: array[0..19] of TClientItem_IGE;

  //交易相关
    m_DealItems_BLUE: array[0..9] of TClientItem_BLUE;
    m_DealRemoteItems_BLUE: array[0..19] of TClientItem_BLUE;

    m_nDealGold: Integer;
    m_nDealRemoteGold: Integer;
    m_boDealEnd: Boolean;
    m_sDealWho: string; //交易对方名字

    m_MouseItem_IGE: TClientItem_IGE;
    m_MouseStateItem_IGE: TClientItem_IGE;
    m_MouseUserStateItem_IGE: TClientItem_IGE;
    m_MouseHeroItem_IGE: TClientItem_IGE;
    m_MouseHeroStateItem_IGE: TClientItem_IGE;
    m_MouseHeroUserStateItem_IGE: TClientItem_IGE;
    m_MouseFindUserItem_IGE: TClientItem_IGE;
    m_MovingItem_IGE: TMovingItem_IGE;
    m_WaitingUseItem_IGE: TMovingItem_IGE;
    m_WaitingHeroUseItem_IGE: TMovingItem_IGE;

    m_MouseItem_BLUE: TClientItem_BLUE;
    m_MouseStateItem_BLUE: TClientItem_BLUE;
    m_MouseUserStateItem_BLUE: TClientItem_BLUE;
    m_MouseHeroItem_BLUE: TClientItem_BLUE;
    m_MouseHeroStateItem_BLUE: TClientItem_BLUE;
    m_MouseHeroUserStateItem_BLUE: TClientItem_BLUE;
    m_MouseFindUserItem_BLUE: TClientItem_BLUE;
    m_MovingItem_BLUE: TMovingItem_BLUE;
    m_WaitingUseItem_BLUE: TMovingItem_BLUE;
    m_WaitingHeroUseItem_BLUE: TMovingItem_BLUE;


    m_OpenBoxingItemWait_BLUE: array[0..1] of TClientItem_BLUE;

    m_OpenBoxingItem_IGE: TClientItem_IGE;

    m_UpgradeItemsWait_BLUE: array[0..2] of TClientItem_BLUE;
    m_UpgradeItemsWait_IGE: array[0..2] of TClientItem_IGE;
    m_ClientMagic: TClientMagic; //合击魔法


    m_FocusItem: pTDropItem;

    m_btItemMoving: Byte; //物品移动状态
    m_boItemMoving: Boolean; //正在移动物品

    m_nFirDragonPoint: Integer;
    m_nMaxFirDragonPoint: Integer;

    m_boGetBags: Boolean;

    m_boUseFlyItem: Boolean;
    m_boUseReturnItem: Boolean;

    m_dwUseFlyItemTick: LongWord;
    m_dwUseReturnItemTick: LongWord;

    m_boRecallBackHero: Boolean;

    m_dwHumEatHPTick: LongWord;
    m_dwHumEatMPTick: LongWord;
    m_dwHeroEatHPTick: LongWord;
    m_dwHeroEatMPTick: LongWord;

    m_dwHumEatHPTick1: LongWord;
    m_dwHumEatMPTick1: LongWord;
    m_dwHeroEatHPTick1: LongWord;
    m_dwHeroEatMPTick1: LongWord;

    m_dwRecallBackHero: LongWord;
    m_dwHintRecallBackHero: LongWord;

    m_dwEatItemTime: LongWord;
    m_dwEatTime: LongWord;

    m_dwHeroEatItemTime: LongWord;
    m_dwHeroEatTime: LongWord;
    //m_dwCurrentEatTime: LongWord;
    //m_CurrentItem_BLUE: TClientItem_BLUE;
    //m_CurrentItem_IGE: TClientItem_IGE;
    m_GroupMembers: TStringList;

    m_dwHintMonTick: LongWord;
    m_dwHintItemTick: LongWord;
    m_dwMovePickItemTick: LongWord;
    m_ShowItemList: TFileItemDB;
    m_ShowBossList: TFileBossDB;

    m_SayList: TStringList;
    m_SayActor: TActor;

    m_nNewX: Integer;
    m_nNewY: Integer;
    m_nNewDir: Integer;
    m_nMoveMsg: Integer;

    m_EatItemFailList: TList;
    m_MapFilterList: TStringList;
    m_SayMsgList: TStringList;
    FCheckCode: Integer;

    m_ItemFilterList: TStringList;
    m_boQueryHumBagItems: Boolean;
    m_dwQueryHumBagItems: LongWord;
    m_MagicLock: pTClientMagic;
    m_MagicLockList: TStringList;

    m_dwMoveTime: LongWord;
    m_nMoveStepCount: Integer;
    ActionFailLock: Boolean;
    ActionFailLockTime: LongWord;

    ActionLock: Boolean;
    ActionLockTime: LongWord;
    LastHitTick: LongWord;
    m_nTargetX: Integer;
    m_nTargetY: Integer;

    m_sEncryptServerName: string;

    m_dwAutoItemTick: LongWord;
  private
    function IsFilterItem(sItemName: string): Boolean;
    function SendUserEatItemList: Boolean;
    procedure AddUserEatItemList(sMsg: string; UserEatItems: pTUserEatItems);
    function GetEnabled: Boolean;
    procedure SetEnabled(Value: Boolean);
    procedure ClientGetMessage(DefMsg: TDefaultMessage; sData: string);
    procedure ClientGetMsg(sData: string);

    procedure ClearUserEatItemList;
    procedure ClearMagicList;
    procedure ClearHeroMagicList;
    procedure ClearActorList;
    procedure ClearFreeActorList;
    procedure ClearDropItems;
    procedure ClearDropedItemList;
    procedure ClearEatItemFailList;


    procedure ClientGetReconnect(sBody: string);
    procedure ClientGetUserLogin(DefMsg: TDefaultMessage; sData: string);
    procedure ClientGetNewMap(DefMsg: TDefaultMessage; sData: string);

    procedure ClientObjTakeOnOK(DefMsg: TDefaultMessage);
    procedure ClientObjTakeOnFail();
    procedure ClientObjTakeOffOK(DefMsg: TDefaultMessage);
    procedure ClientObjTakeOffFail();
    procedure ClientObjWeigthChanged(DefMsg: TDefaultMessage);
    procedure ClientObjGoldChanged(DefMsg: TDefaultMessage);
    procedure ClientObjCleanObjects();
    procedure ClientObjEatOK();
    procedure ClientObjEatFail();

    procedure ClientObjChangeFace(DefMsg: TDefaultMessage; sData: string);

    procedure ClientObjHit(DefMsg: TDefaultMessage; sData: string);

    procedure ClientGetObjTurn(DefMsg: TDefaultMessage; sData: string);
    procedure ClientGetBackStep(DefMsg: TDefaultMessage; sData: string);
    procedure ClientSpaceMoveHide(DefMsg: TDefaultMessage);
    procedure ClientSpaceMoveShow(DefMsg: TDefaultMessage; sData: string);
    procedure ClientObjWalk(DefMsg: TDefaultMessage; sData: string);
    procedure ClientObjRun(DefMsg: TDefaultMessage; sData: string);
    procedure ClientLampChangeDura(DefMsg: TDefaultMessage);
    procedure ClientObjMoveFail(DefMsg: TDefaultMessage; sData: string);

    procedure ClientObjFlyAxe(DefMsg: TDefaultMessage; sData: string);
    procedure ClientObjDeath(DefMsg: TDefaultMessage; sData: string);
    procedure ClientObjSkeLeton(DefMsg: TDefaultMessage; sData: string);
    procedure ClientObjAbility(DefMsg: TDefaultMessage; sData: string);
    procedure ClientObjSubAbility(DefMsg: TDefaultMessage);

    procedure ClientObjWinExp(DefMsg: TDefaultMessage);
    procedure ClientObjLevelUp(DefMsg: TDefaultMessage);
    procedure ClientObjHealthSpellChanged(DefMsg: TDefaultMessage);
    procedure ClientObjStruck(DefMsg: TDefaultMessage; sData: string);
    procedure ClientObjInstanceOpenHealth(DefMsg: TDefaultMessage);

    procedure ClientGetUserName(DefMsg: TDefaultMessage; sData: string);
    procedure ClientObjChangeNameColor(DefMsg: TDefaultMessage);
    procedure ClientObjHide(DefMsg: TDefaultMessage);
    procedure ClientObjDigUp(DefMsg: TDefaultMessage; sData: string);
    procedure ClientObjDigDown(DefMsg: TDefaultMessage);
    procedure ClientGetMapDescription(Msg: TDefaultMessage; sBody: string);
    procedure ClientGetGameGoldName(Msg: TDefaultMessage; sBody: string);
    procedure ClientGetAdjustBonus(bonus: Integer; body: string);
    procedure ClientGetAddItem(body: string);
    procedure ClientGetUpdateItem(body: string);
    procedure ClientGetUpdateItem2(body: string);
    procedure ClientGetDelItem(body: string);
    procedure ClientGetDelItems(body: string);
    procedure ClientGetBagItmes(DefMsg: TDefaultMessage; body: string);
    procedure ClientGetDropItemFail(iname: string; sindex: Integer);
    procedure ClientGetHeroDropItemFail(iname: string; sindex: Integer);
    procedure ClientGetShowItem(DefMsg: TDefaultMessage; sData: string);
    procedure ClientGetHideItem(DefMsg: TDefaultMessage);
    procedure ClientGetSendAddUseItems(body: string);
    procedure ClientGetSenduseItems(body: string);
    procedure ClientGetAddMagic(body: string);
    procedure ClientGetDelMagic(magid: Integer);
    procedure ClientGetMyMagics(body: string);
    procedure ClientGetMagicLvExp(magid, maglv, magtrain: Integer);
    procedure ClientGetDuraChange(uidx, newdura, newduramax: Integer);
    procedure ClientOutofConnection();

    procedure ClientGetStartPlay(sData: string);
    procedure ClientGetReceiveChrs(sData: string);

    procedure ClientObjSellItemOK(nGold: Integer);
    procedure ClientObjSellItemFail();
    procedure ClientObjStorageOK(DefMsg: TDefaultMessage);
    procedure ClientObjTakeBackStorageItemOK(DefMsg: TDefaultMessage);
    procedure ClientObjDealMenu(sData: string);
    procedure ClientObjDealCancel();
    procedure ClientObjDealAddItemOK();
    procedure ClientObjDealDelItemOK();
    procedure ClientObjDealDelItemFail();
    procedure ClientObjDealChgGoldOK(DefMsg: TDefaultMessage);
    procedure ClientObjDealChgGoldFail(DefMsg: TDefaultMessage);
    procedure ClientObjDealRemotChgGold(DefMsg: TDefaultMessage);
    procedure ClientObjSellSellOffItemOK();
    procedure ClientObjSellSellOffItemFail(nFailCode: Integer);
    procedure ClientObjOpenBoxOK();
    procedure ClientObjOpenBoxFail();

    procedure ClientObjChangeItemOK(sData: string);
    procedure ClientObjChangeItemFail(nFailCode: Integer);
    procedure ClientObjUpgradeItemOK(sData: string);
    procedure ClientObjUpgradeItemFail(nFailCode: Integer; sData: string);


    procedure ClientObjRecallHero(DefMsg: TDefaultMessage;
      sData: string);
    procedure ClientObjCreateHero(DefMsg: TDefaultMessage;
      sData: string);
    procedure ClientObjHeroDeath(DefMsg: TDefaultMessage);
    procedure ClientObjHeroLogOut(DefMsg: TDefaultMessage);
    procedure ClientObjHeroAbility(DefMsg: TDefaultMessage;
      sData: string);
    procedure ClientObjHeroSubAbility(DefMsg: TDefaultMessage);
    procedure ClientObjFireDragonPoint(DefMsg: TDefaultMessage);
    procedure ClientObjHeroTakeOnOK(DefMsg: TDefaultMessage);
    procedure ClientObjHeroTakeOnFail();
    procedure ClientObjHeroTakeOffOK(DefMsg: TDefaultMessage);
    procedure ClientObjHeroTakeOffFail();
    procedure ClientObjTakeOffHeroBagOK(DefMsg: TDefaultMessage);
    procedure ClientObjTakeOffHeroBagFail();
    procedure ClientObjTakeOffMasterBagOK(DefMsg: TDefaultMessage);
    procedure ClientObjTakeOffMasterBagFail();
    procedure ClientObjToMasterBagOK();
    procedure ClientObjToMasterBagFail();
    procedure ClientObjToHeroBagOK();
    procedure ClientObjToHeroBagFail();
    procedure ClientObjHeroBagCount(DefMsg: TDefaultMessage);
    procedure ClientObjHeroWeigthChanged(DefMsg: TDefaultMessage);

    procedure ClientGetHeroUpdateItem(body: string);
    procedure ClientGetHeroDelItem(body: string);
    procedure ClientGetHeroDelItems(body: string);
    procedure ClientGetHeroBagItmes(DefMsg: TDefaultMessage; body: string);
    procedure ClientGetHeroAddItem(body: string);

    procedure ClientGetSendHerouseItems(body: string); //英雄装备
    procedure ClientGetHeroAddMagic(body: string);
    procedure ClientGetHeroDelMagic(magid: Integer);
    procedure ClientGetMyHeroMagics(body: string);
    procedure ClientGetSendHeroAddUseItems(body: string);

    procedure ClientObjHeroEatOK();
    procedure ClientObjHeroEatFail();
    procedure ClientObjHeroWinExp(DefMsg: TDefaultMessage);
    procedure ClientObjHeroLevelUp(DefMsg: TDefaultMessage);
    procedure ClientObjRepaiFireDragon(DefMsg: TDefaultMessage);
    procedure ClientGetHeroDuraChange(uidx, newdura, newduramax: Integer);

    procedure ClientObjHeroLogIn(DefMsg: TDefaultMessage; sData: string);

    procedure ClientObjGroupModeChanged(nOpen: Integer);
    procedure ClientObjCreateGroupOK();
    procedure ClientObjCreateGroupFail(nFailCode: Integer);
    procedure ClientObjGroupAddManFail(nFailCode: Integer);
    procedure ClientObjGroupDelManFail(nFailCode: Integer);


    procedure ClientGetGroupMembers(bodystr: string);


    function IsGroupMember(uname: string): Boolean;
    procedure SendAddGroupMember(withwho: string);
    procedure SendDelGroupMember(withwho: string);
    procedure SendCreateGroup(withwho: string);
    procedure SendGroupMode(onoff: Boolean);

    procedure SendHeroDropItem(nMakeIndex: Integer; sItemName: string);
    procedure SendDropItem(nMakeIndex: Integer; sItemName: string);

    procedure SendTakeOnItem(btWhere: Byte; nMakeIndex: Integer; sItemName: string);
    procedure SendTakeOffItem(btWhere: Byte; nMakeIndex: Integer; sItemName: string);
    procedure SendItemToMasterBag(btWhere: Byte; nMakeIndex: Integer; sItemName: string);
    procedure SendItemToHeroBag(btWhere: Byte; nMakeIndex: Integer; sItemName: string);
    procedure SendHeroTakeOnItem(btWhere: Byte; nMakeIndex: Integer; sItemName: string);
    procedure SendHeroTakeOffItem(btWhere: Byte; nMakeIndex: Integer; sItemName: string);

    procedure SendRepairFirDragon(nType: Byte; nMakeIndex: Integer; sItemName: string; var sMsg: string);

    procedure SendEat(nMakeIndex: Integer; sItemName: string; var sMsg: string);
    procedure SendHeroEat(nMakeIndex: Integer; sItemName: string; var sMsg: string);

    procedure SendSellItem(nMakeIndex: Integer; sItemName: string);
    procedure SendSellOffItem(nMakeIndex: Integer; sItemName: string);
    procedure SendStorageItem(nMakeIndex: Integer; sItemName: string);

    procedure SendAddDealItem(sData: string);
    procedure SendDelDealItem(sData: string);
    procedure SendUpgradeItem(sData: string);
    procedure SendOpenBox(nMakeIndex: Integer; sItemName: string);
    procedure SendOpenBox_BLUE(sData: string);
    procedure SendWalk(nIndex, nX, nY, nDir: Integer);


    function GetHumLevel: Integer;
    function GetHeroLevel: Integer;

    function GetHumHP: Integer;
    function GetHeroHP: Integer;

    function GetHumMaxHP: Integer;
    function GetHeroMaxHP: Integer;

    function GetHumMP: Integer;
    function GetHeroMP: Integer;

    function GetHumMaxMP: Integer;
    function GetHeroMaxMP: Integer;

    function GetEating: Boolean;
    function GetHeroEating: Boolean;

    function GetEatItemFailCount(sItemName: string; nMakeIndex: Integer): Integer;
    function GetEatItemFail(sItemName: string; nMakeIndex: Integer): Boolean;
    function GetEatItemFailA(sItemName: string; nMakeIndex: Integer): Boolean;
    procedure AddEatItemFail(sItemName: string; nMakeIndex: Integer);
    procedure DelEatItemFail(sItemName: string; nMakeIndex: Integer);
    procedure ClearEatItemFail();

    function FindHumItemIndex(Index: Integer): Integer;
    function FindHeroItemIndex(Index: Integer): Integer;
    procedure Check;
    procedure AutoUseMagic;
    procedure AutoSayMsg;
    procedure AutoRunGame;
    procedure HintBossMon;
    procedure HintSuperItem;
    function CreateUserDirectory: string;

    function GetMagicByKey(Key: Char): pTClientMagic;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
    procedure OnTime(Sender: TObject);
    procedure OnTimeRun(Sender: TObject);

    function GetSayMsg(sMsg: string): Boolean;
    function DelSayMsg(sMsg: string): Boolean;
    function GetMagicLock(sName: string): Boolean;

    procedure ClearAll;

    procedure Lock;
    procedure UnLock;
    procedure AddFreeDeleteActor(Actor: TActor);
    procedure FreeDeleteActor;
    procedure Run;
    procedure DecodeMessagePacket(var sDataBlock: string);
    procedure DecodeSendMessagePacket(var sDataBlock: string);
    function DecodePacket(var sData: string): Boolean;
    function DecodeSendPacket(var sData: string): Boolean;

    procedure Savebags(flname: string; pbuf: PByte);
    procedure Loadbags(flname: string; pbuf: PByte);
    procedure ClearBag;
    function AddItemBag_IGE(cu: TClientItem_IGE): Boolean;
    function UpdateItemBag_IGE(cu: TClientItem_IGE): Boolean;
    function UpdateItemBag2_IGE(cu: TClientItem_IGE): Boolean;

    function AddItemBag_BLUE(cu: TClientItem_BLUE): Boolean;
    function UpdateItemBag_BLUE(cu: TClientItem_BLUE): Boolean;
    function UpdateItemBag2_BLUE(cu: TClientItem_BLUE): Boolean;

    function DelItemBag(iname: string; iindex: Integer): Boolean;
    procedure ArrangeItemBag;
    procedure ClearHeroBag;
    function AddHeroItemBag_IGE(cu: TClientItem_IGE): Boolean;
    function AddHeroItemBag_BLUE(cu: TClientItem_BLUE): Boolean;
    function UpdateHeroItemBag_IGE(cu: TClientItem_IGE): Boolean;
    function UpdateHeroItemBag_BLUE(cu: TClientItem_BLUE): Boolean;

    function DelHeroItemBag(iname: string; iindex: Integer): Boolean;
    procedure ArrangeHeroItemBag;

    procedure ClearDate;
    procedure ClearHeroDate;
    procedure ClearUserDate;

    procedure MoveDealItemToBag;

    procedure AddChangeFace(recogid: Integer);
    procedure DelChangeFace(recogid: Integer);
    function IsChangingFace(recogid: Integer): Boolean;

    function FindActor(id: Integer): TActor; overload;
    function FindActor(sName: string): TActor; overload;
    function FindActorXY(X, Y: Integer): TActor;
    function FindTargetXYCount(nX, nY, nRange: Integer): Integer;
    function IsValidActor(Actor: TActor): Boolean;
    function NewActor(chrid: Integer;
      cx: Word; //x
      cy: Word; //y
      cdir: Word;
      cfeature: Integer; //race, hair, dress, weapon
      cstate: Integer): TActor;
    procedure ActorDied(Actor: TObject);
    procedure SetActorDrawLevel(Actor: TObject; Level: Integer);
    procedure ClearActors;
    function DeleteActor(id: Integer): TActor;
    procedure DelActor(Actor: TObject);
    function ServerAcceptNextAction: Boolean;
    function CanNextAction: Boolean;
    function CanNextHit: Boolean;
    procedure ActionFailed;
    function IsUnLockAction(Action, adir: Integer): Boolean;











    procedure AddDropItem_IGE(ci: TClientItem_IGE);
    procedure AddDropItem_BLUE(ci: TClientItem_BLUE);

    function GetDropItem_BLUE(iname: string; MakeIndex: Integer): pTClientItem_BLUE;
    function GetDropItem_IGE(iname: string; MakeIndex: Integer): pTClientItem_IGE;

    procedure AddDealItem_IGE(ci: TClientItem_IGE);
    procedure AddDealItem_BLUE(ci: TClientItem_BLUE);

    procedure DelDealItem_IGE(ci: TClientItem_IGE);
    procedure DelDealItem_BLUE(ci: TClientItem_BLUE);

    procedure AddDealRemoteItem_IGE(ci: TClientItem_IGE);
    procedure AddDealRemoteItem_BLUE(ci: TClientItem_BLUE);

    procedure DelDealRemoteItem_BLUE(ci: TClientItem_BLUE);
    procedure DelDealRemoteItem_IGE(ci: TClientItem_IGE);

    procedure DelDropItem(iname: string; MakeIndex: Integer);

    procedure ClearDropItem;
    procedure ScreenXYfromMCXY(cx, cy: Integer; var sx, sY: Integer);
    procedure CXYfromMouseXY(mx, my: Integer; var ccx, ccy: Integer);
    function GetDropItems(X, Y: Integer; var inames: string): pTDropItem;
    procedure GetXYDropItemsList(nX, nY: Integer; var ItemList: TList);
    function GetXYDropItems(nX, nY: Integer): pTDropItem;

    procedure SendMsg(ident, chrid, X, Y, cdir, feature, State: Integer; Str: string);

    procedure AddChatBoardString(const Text: string; FColor, BColor: Byte);
    procedure SendSay(const Text: string);
    procedure SendPickup;
    procedure SendReCallHero();



    procedure LoadBindItemList;
    procedure UnLoadBindItemList;
    procedure SaveBindItemList;
    function FindBindItemName(sItemName: string): string; overload;
    function FindBindItemName(btType: Integer): string; overload;
    function FindBindItemName(btType: Integer; sItemName: string): string; overload;
    function FindUnBindItemName(sItemName: string): string; overload;
    function FindUnBindItemName(btType: Integer): string; overload;
    function FindUnBindItemName(btType: Integer; sItemName: string): string; overload;
    procedure DeleteBindItem(BindItem: pTBindClientItem);
    procedure LoadConfig(sUserName: string);
    procedure SaveConfig(sUserName: string);
    procedure LoadShowItemList;
    procedure LoadShowBossList;
    procedure SaveShowItemList;
    procedure SaveShowBossList;

    function BagItemCount: Integer;
    function HeroBagItemCount: Integer;

    function FindItemArrItemName(btType: Byte): Integer; overload;
    function FindItemArrItemName(sItemName: string): Integer; overload;

    function FindItemArrBindItemName(btType: Byte): Integer; overload;
    function FindItemArrBindItemName(sItemName: string): Integer; overload;

    function FindHeroItemArrItemName(btType: Byte): Integer; overload;
    function FindHeroItemArrItemName(sItemName: string): Integer; overload;

    function FindHeroItemArrBindItemName(btType: Byte): Integer; overload;
    function FindHeroItemArrBindItemName(sItemName: string): Integer; overload;


    function AutoEatItem(idx: Integer): Boolean;
    function AutoHeroEatItem(idx: Integer): Boolean;

    procedure AutoUseItem(Sender: TObject);
    procedure AutoEatHPItem(Sender: TObject);
    procedure AutoEatMPItem(Sender: TObject);
    procedure AutoHeroEatHPItem(Sender: TObject);
    procedure AutoHeroEatMPItem(Sender: TObject);
    procedure UseFlyItem(Sender: TObject);
    procedure Return(Sender: TObject);



    procedure AutoRecallBackHero;
    procedure RecallHero;
    procedure ChangeHeroState;
    procedure QueryHumBagItems; //查询包裹

    procedure KeyDown(MainHwnd: Hwnd; Key: Word);
    procedure SendKeyEvent(Key1, Key2: Byte); overload;
    procedure SendKeyEvent(Key: Byte); overload;

    function MakeDefaultMsg_IGE(wIdent: Word; nRecog: Integer; wParam, wTag, wSeries: Word): TDefaultMessage_IGE;
    function EncodeMessage_IGE(sMsg: TDefaultMessage_IGE): string;
    function DecodeMessage_IGE(Str: string): TDefaultMessage_IGE;

    property HumLevel: Integer read GetHumLevel;
    property HeroLevel: Integer read GetHeroLevel;
    property HumHP: Integer read GetHumHP;
    property HeroHP: Integer read GetHeroHP;
    property HumMaxHP: Integer read GetHumMaxHP;
    property HeroMaxHP: Integer read GetHeroMaxHP;
    property HumMP: Integer read GetHumMP;
    property HeroMP: Integer read GetHeroMP;
    property HumMaxMP: Integer read GetHumMaxMP;
    property HeroMaxMP: Integer read GetHeroMaxMP;
    property Enabled: Boolean read GetEnabled write SetEnabled;
  end;


implementation
uses Common, OptionMain;

function TGameEngine.DecodeMessage_IGE(Str: string): TDefaultMessage_IGE;
var
  EncBuf: array[0..BUFFERSIZE - 1] of Char;
  Msg: TDefaultMessage_IGE;
begin
  Decode6BitBuf(PChar(Str), @EncBuf, Length(Str), 100);
  Move(EncBuf, Msg, SizeOf(TDefaultMessage_IGE));
  Result := Msg;
end;

function TGameEngine.EncodeMessage_IGE(sMsg: TDefaultMessage_IGE): string;
var
  EncBuf, TempBuf: array[0..BUFFERSIZE - 1] of Char;
begin
  Move(sMsg, TempBuf, SizeOf(TDefaultMessage_IGE));
  Encode6BitBuf(@TempBuf, @EncBuf, SizeOf(TDefaultMessage_IGE), SizeOf(EncBuf));
  Result := StrPas(EncBuf);
end;

function TGameEngine.MakeDefaultMsg_IGE(wIdent: Word; nRecog: Integer; wParam, wTag, wSeries: Word): TDefaultMessage_IGE;
begin
  Result.Recog := nRecog;
  Result.Ident := wIdent;
  Result.Param := wParam;
  Result.Tag := wTag;
  Result.Series := wSeries;
  Result.Param1 := m_nSessionID;
end;

constructor TGameEngine.Create(CreateSuspended: Boolean);
begin
  inherited;
  InitializeCriticalSection(m_UserCriticalSection);
  Timer := TTimer.Create(nil);
  TimerRun := TTimer.Create(nil);
  TimerUseItem := TTimer.Create(nil);

  m_sServerName := '飞儿世界';
  m_sSockText := '';
  m_sBufferText := '';

  m_sSendSockText := '';
  m_sSendBufferText := '';

  m_btVersion := 0;
  m_MySelf := nil;
  m_MyHero := nil;
  m_TargetCret := nil;
  m_FocusCret := nil;
  m_MagicTarget := nil;
  m_SoftClose := False;
  m_boLogin := False;
  m_boMapMoving := False;

  m_boGetBags := False;

  m_ActorList := TList.Create;
  m_FreeActorList := TList.Create;
  m_DropedItemList := TList.Create;
  m_DropItems := TList.Create;
  m_ChangeFaceReadyList := TList.Create;
  m_MagicList := TList.Create;
  m_HeroMagicList := TList.Create;
  m_GroupMembers := TStringList.Create;
  m_SayList := TStringList.Create;
  m_EatItemFailList := TList.Create;
  m_MapFilterList := TStringList.Create;
  m_SayMsgList := TStringList.Create;
  m_UserEatItemList := TStringList.Create;
  m_ItemFilterList := TStringList.Create;
  ClearAll;

  m_UseItemEvent[0] := AutoEatHPItem;
  m_UseItemEvent[1] := AutoEatMPItem;
  m_UseItemEvent[2] := Return;
  m_UseItemEvent[3] := UseFlyItem;

  m_HeroUseItemEvent[0] := AutoHeroEatHPItem;
  m_HeroUseItemEvent[1] := AutoHeroEatMPItem;


  m_sEncryptServerName := '';
  FillChar(Config, SizeOf(TConfig), #0);

  m_boUseFlyItem := False;
  m_boUseReturnItem := False;
  m_boSendRunLogin := False;
  m_boUserLogin := False;

  FCheckCode := 0;

  m_boSoftClose := False;
  m_nCheckIndex := 0;
  m_dwCheckTick := GetTickCount;

  m_ShowItemList := TFileItemDB.Create();
  m_ShowBossList := TFileBossDB.Create();
  m_MagicLock := nil;
  m_MagicLockList := TStringList.Create;


  m_btVersion := 0;

  Timer.Interval := 1;
  Timer.OnTimer := OnTime;
  Timer.Enabled := True;

  TimerRun.Interval := 100;
  TimerRun.OnTimer := OnTimeRun;
  TimerRun.Enabled := True;

  TimerUseItem.Enabled := False;
  TimerUseItem.Interval := 1;
  TimerUseItem.OnTimer := AutoUseItem;
end;

destructor TGameEngine.Destroy;
begin
  ClearAll;
  Timer.Free;
  TimerRun.Free;
  TimerUseItem.Free;

  m_ActorList.Free;
  m_FreeActorList.Free;
  m_DropedItemList.Free;
  m_DropItems.Free;
  m_ChangeFaceReadyList.Free;
  m_MagicList.Free;
  m_HeroMagicList.Free;
  m_GroupMembers.Free;
  UnLoadBindItemList;
  m_ShowItemList.Free;
  m_ShowBossList.Free;
  m_SayList.Free;
  m_EatItemFailList.Free;
  m_MapFilterList.Free;
  m_SayMsgList.Free;
  m_UserEatItemList.Free;
  m_ItemFilterList.Free;
  m_MagicLockList.Free;
  DeleteCriticalSection(m_UserCriticalSection);
  inherited;
end;

function TGameEngine.GetEnabled: Boolean;
begin
  Result := TimerUseItem.Enabled;
end;

procedure TGameEngine.SetEnabled(Value: Boolean);
begin
  TimerUseItem.Enabled := Value;
end;

function TGameEngine.SendUserEatItemList: Boolean;
var
  UserEatItems: pTUserEatItems;
  //Msg: TDefaultMessage;
  sSend: string;
begin
  Result := False;
  if m_UserEatItemList.Count > 0 then begin
    Result := True;
    if Config.boFastEatItem then begin //双重喝药
      if m_btVersion = 0 then begin
        UserEatItems := pTUserEatItems(m_UserEatItemList.Objects[0]);
        if UserEatItems.boHero then begin
          if (m_HeroEatingItem.BLUE.s.Name <> '') and (GetTickCount - m_HeroEatingItem.dwEatTime > 5 * 1000) then begin
            m_HeroEatingItem.BLUE.s.Name := '';
          end;
          if (m_HeroEatingItem2.BLUE.s.Name <> '') and (GetTickCount - m_HeroEatingItem2.dwEatTime > 5 * 1000) then begin
            m_HeroEatingItem2.BLUE.s.Name := '';
          end;

          if (m_HeroEatingItem.BLUE.s.Name = '') then begin
            m_HeroEatingItem := UserEatItems^;
            if (m_HeroEatingItem2.BLUE.s.Name = '') then
              m_HeroEatingItem.nIndex := 0
            else
              m_HeroEatingItem.nIndex := 1;

            m_dwHeroEatTime := GetTickCount;
            m_dwEatItemTime := GetTickCount;
            m_HeroEatingItem.dwEatTime := GetTickCount;
            sSend := m_UserEatItemList.Strings[0];
            m_UserEatItemList.Delete(0);
            GameSocket.SendSocket(sSend);
            Dispose(UserEatItems);
          end else
            if (m_HeroEatingItem2.BLUE.s.Name = '') then begin
            m_HeroEatingItem2 := UserEatItems^;
            if (m_HeroEatingItem.BLUE.s.Name = '') then
              m_HeroEatingItem2.nIndex := 0
            else
              m_HeroEatingItem2.nIndex := 1;
            m_dwHeroEatTime := GetTickCount;
            m_dwEatItemTime := GetTickCount;
            m_HeroEatingItem2.dwEatTime := GetTickCount;
            sSend := m_UserEatItemList.Strings[0];
            m_UserEatItemList.Delete(0);
            GameSocket.SendSocket(sSend);
            Dispose(UserEatItems);
          end;
        end else begin
          if (m_EatingItem.BLUE.s.Name <> '') and (GetTickCount - m_EatingItem.dwEatTime > 5 * 1000) then begin
            m_EatingItem.BLUE.s.Name := '';
          end;
          if (m_EatingItem2.BLUE.s.Name <> '') and (GetTickCount - m_EatingItem2.dwEatTime > 5 * 1000) then begin
            m_EatingItem2.BLUE.s.Name := '';
          end;
          if (m_EatingItem.BLUE.s.Name = '') then begin
            m_EatingItem := UserEatItems^;
            if (m_EatingItem2.BLUE.s.Name = '') then
              m_EatingItem.nIndex := 0
            else
              m_EatingItem.nIndex := 1;

            m_dwEatTime := GetTickCount;
            m_dwEatItemTime := GetTickCount;
            m_EatingItem.dwEatTime := GetTickCount;
            sSend := m_UserEatItemList.Strings[0];
            m_UserEatItemList.Delete(0);
            GameSocket.SendSocket(sSend);
            Dispose(UserEatItems);
          end else
            if (m_EatingItem2.BLUE.s.Name = '') then begin
            m_EatingItem2 := UserEatItems^;
            if (m_EatingItem.BLUE.s.Name = '') then
              m_EatingItem2.nIndex := 0
            else
              m_EatingItem2.nIndex := 1;
            m_dwEatTime := GetTickCount;
            m_dwEatItemTime := GetTickCount;
            m_EatingItem2.dwEatTime := GetTickCount;
            sSend := m_UserEatItemList.Strings[0];
            m_UserEatItemList.Delete(0);
            GameSocket.SendSocket(sSend);
            Dispose(UserEatItems);
          end;
        end;
      //SendOutStr('SendUserEatItemList:'+sSend+' '+m_EatingItem_BLUE.s.Name+' '+IntToStr(m_EatingItem_BLUE.MakeIndex)));
      end else begin
        UserEatItems := pTUserEatItems(m_UserEatItemList.Objects[0]);
        if UserEatItems.boHero then begin
          if (m_HeroEatingItem.IGE.s.Name <> '') and (GetTickCount - m_HeroEatingItem.dwEatTime > 5 * 1000) then begin
            m_HeroEatingItem.IGE.s.Name := '';
          end;
          if (m_HeroEatingItem2.IGE.s.Name <> '') and (GetTickCount - m_HeroEatingItem2.dwEatTime > 5 * 1000) then begin
            m_HeroEatingItem2.IGE.s.Name := '';
          end;
          if (m_HeroEatingItem.IGE.s.Name = '') then begin
            m_HeroEatingItem := UserEatItems^;
            if (m_HeroEatingItem2.IGE.s.Name = '') then
              m_HeroEatingItem.nIndex := 0
            else
              m_HeroEatingItem.nIndex := 1;
            m_HeroEatingItem.dwEatTime := GetTickCount;
            m_dwHeroEatTime := GetTickCount;
            m_dwEatItemTime := GetTickCount;
            sSend := m_UserEatItemList.Strings[0];
            m_UserEatItemList.Delete(0);
            GameSocket.SendSocket(sSend);
            Dispose(UserEatItems);
          end else
            if (m_HeroEatingItem2.IGE.s.Name = '') then begin
            m_HeroEatingItem2 := UserEatItems^;
            if (m_HeroEatingItem.IGE.s.Name = '') then
              m_HeroEatingItem2.nIndex := 0
            else
              m_HeroEatingItem2.nIndex := 1;
            m_HeroEatingItem2.dwEatTime := GetTickCount;
            m_dwHeroEatTime := GetTickCount;
            m_dwEatItemTime := GetTickCount;
            sSend := m_UserEatItemList.Strings[0];
            m_UserEatItemList.Delete(0);
            GameSocket.SendSocket(sSend);
            Dispose(UserEatItems);
          end;
        end else begin
          if (m_EatingItem.IGE.s.Name <> '') and (GetTickCount - m_EatingItem.dwEatTime > 5 * 1000) then begin
            m_EatingItem.IGE.s.Name := '';
          end;
          if (m_EatingItem2.IGE.s.Name <> '') and (GetTickCount - m_EatingItem2.dwEatTime > 5 * 1000) then begin
            m_EatingItem2.IGE.s.Name := '';
          end;
          if (m_EatingItem.IGE.s.Name = '') then begin
            m_EatingItem := UserEatItems^;
            if (m_EatingItem2.IGE.s.Name = '') then
              m_EatingItem.nIndex := 0
            else
              m_EatingItem.nIndex := 1;
            m_EatingItem.dwEatTime := GetTickCount;
            m_dwEatTime := GetTickCount;
            m_dwEatItemTime := GetTickCount;
            sSend := m_UserEatItemList.Strings[0];
            m_UserEatItemList.Delete(0);
            GameSocket.SendSocket(sSend);
            Dispose(UserEatItems);
          end else
            if (m_EatingItem2.IGE.s.Name = '') then begin
            m_EatingItem2 := UserEatItems^;
            if (m_EatingItem.IGE.s.Name = '') then
              m_EatingItem2.nIndex := 0
            else
              m_EatingItem2.nIndex := 1;
            m_EatingItem2.dwEatTime := GetTickCount;
            m_dwEatTime := GetTickCount;
            m_dwEatItemTime := GetTickCount;
            sSend := m_UserEatItemList.Strings[0];
            m_UserEatItemList.Delete(0);
            GameSocket.SendSocket(sSend);
            Dispose(UserEatItems);
          end;
        end;
      end;
    end else begin
//==============================================================================
      if m_btVersion = 0 then begin
        UserEatItems := pTUserEatItems(m_UserEatItemList.Objects[0]);
        if UserEatItems.boHero then begin
          if (m_HeroEatingItem.BLUE.s.Name <> '') and (GetTickCount - m_HeroEatingItem.dwEatTime > 5 * 1000) then begin
            m_HeroEatingItem.BLUE.s.Name := '';
          end;
          if (m_HeroEatingItem2.BLUE.s.Name <> '') and (GetTickCount - m_HeroEatingItem2.dwEatTime > 5 * 1000) then begin
            m_HeroEatingItem2.BLUE.s.Name := '';
          end;
          if (m_HeroEatingItem.BLUE.s.Name = '') and (m_HeroEatingItem2.BLUE.s.Name = '') then begin
            m_HeroEatingItem := UserEatItems^;
            m_HeroEatingItem.nIndex := 0;
            m_dwHeroEatTime := GetTickCount;
            m_dwEatItemTime := GetTickCount;
            m_HeroEatingItem.dwEatTime := GetTickCount;
            sSend := m_UserEatItemList.Strings[0];
            m_UserEatItemList.Delete(0);
            GameSocket.SendSocket(sSend);
            Dispose(UserEatItems);
          end;
        end else begin
          if (m_EatingItem.BLUE.s.Name <> '') and (GetTickCount - m_EatingItem.dwEatTime > 5 * 1000) then begin
            m_EatingItem.BLUE.s.Name := '';
          end;
          if (m_EatingItem2.BLUE.s.Name <> '') and (GetTickCount - m_EatingItem2.dwEatTime > 5 * 1000) then begin
            m_EatingItem2.BLUE.s.Name := '';
          end;
          if (m_EatingItem.BLUE.s.Name = '') and (m_EatingItem2.BLUE.s.Name = '') then begin
            m_EatingItem := UserEatItems^;
            m_EatingItem.nIndex := 0;
            m_dwEatTime := GetTickCount;
            m_dwEatItemTime := GetTickCount;
            m_EatingItem.dwEatTime := GetTickCount;
            sSend := m_UserEatItemList.Strings[0];
            m_UserEatItemList.Delete(0);
            GameSocket.SendSocket(sSend);
            Dispose(UserEatItems);
          end;
        end;
      //SendOutStr('SendUserEatItemList:'+sSend+' '+m_EatingItem_BLUE.s.Name+' '+IntToStr(m_EatingItem_BLUE.MakeIndex)));
      end else begin
        UserEatItems := pTUserEatItems(m_UserEatItemList.Objects[0]);
        if UserEatItems.boHero then begin
          if (m_HeroEatingItem.IGE.s.Name <> '') and (GetTickCount - m_HeroEatingItem.dwEatTime > 5 * 1000) then begin
            m_HeroEatingItem.IGE.s.Name := '';
          end;
          if (m_HeroEatingItem2.IGE.s.Name <> '') and (GetTickCount - m_HeroEatingItem2.dwEatTime > 5 * 1000) then begin
            m_HeroEatingItem2.IGE.s.Name := '';
          end;
          if (m_HeroEatingItem.IGE.s.Name = '') and (m_HeroEatingItem2.IGE.s.Name = '') then begin
            m_HeroEatingItem := UserEatItems^;
            m_HeroEatingItem.nIndex := 0;
            m_HeroEatingItem.dwEatTime := GetTickCount;
            m_dwHeroEatTime := GetTickCount;
            m_dwEatItemTime := GetTickCount;
            sSend := m_UserEatItemList.Strings[0];
            m_UserEatItemList.Delete(0);
            GameSocket.SendSocket(sSend);
            Dispose(UserEatItems);
          end;
        end else begin
          if (m_EatingItem.IGE.s.Name <> '') and (GetTickCount - m_EatingItem.dwEatTime > 5 * 1000) then begin
            m_EatingItem.IGE.s.Name := '';
          end;
          if (m_EatingItem2.IGE.s.Name <> '') and (GetTickCount - m_EatingItem2.dwEatTime > 5 * 1000) then begin
            m_EatingItem2.IGE.s.Name := '';
          end;
          if (m_EatingItem.IGE.s.Name = '') and (m_EatingItem2.IGE.s.Name = '') then begin
            m_EatingItem := UserEatItems^;
            m_EatingItem.nIndex := 0;
            m_EatingItem.dwEatTime := GetTickCount;
            m_dwEatTime := GetTickCount;
            m_dwEatItemTime := GetTickCount;
            sSend := m_UserEatItemList.Strings[0];
            m_UserEatItemList.Delete(0);
            GameSocket.SendSocket(sSend);
            Dispose(UserEatItems);
          end;
        end;
      end;
    end;
  end;
end;

procedure TGameEngine.AddUserEatItemList(sMsg: string; UserEatItems: pTUserEatItems);
var
  EatItems: pTUserEatItems;
begin
  New(EatItems);
  EatItems^ := UserEatItems^;
  m_UserEatItemList.AddObject(sMsg, TObject(EatItems));
end;

procedure TGameEngine.AddFreeDeleteActor(Actor: TActor);
var
  I: Integer;
begin
  for I := 0 to m_FreeActorList.Count - 1 do begin
    if TActor(m_FreeActorList[I]) = Actor then Exit;
  end;
  m_FreeActorList.Add(Actor);
end;


procedure TGameEngine.FreeDeleteActor;
var
  I: Integer;
  timertime: LongWord;
begin
  for I := m_FreeActorList.Count - 1 downto 0 do begin
    if GetTickCount - TActor(m_FreeActorList[I]).m_dwDeleteTime > 1000 * 60 then begin
      if TActor(m_FreeActorList[I]) = m_MyHero then m_MyHero := nil;
      TActor(m_FreeActorList[I]).Free;
      m_FreeActorList.Delete(I);
    end;
  end;
end;

function TGameEngine.CreateUserDirectory: string;
var
  sUserDirectory: string;
begin
  Result := '';
  if m_MySelf <> nil then begin
    sUserDirectory := ExtractFilePath(ParamStr(0)) + 'Config\';
    if not DirectoryExists(sUserDirectory) then begin
      CreateDir(sUserDirectory);
    end;
    sUserDirectory := sUserDirectory + m_MySelf.m_sUserName + '\';
    if not DirectoryExists(sUserDirectory) then begin
      CreateDir(sUserDirectory);
    end;
    Result := sUserDirectory;
  end;
end;

procedure TGameEngine.LoadBindItemList;
var
  I: Integer;
  LoadList: TStringList;
  sFileName: string;
  BindItem: pTBindClientItem;
  sLineText, sType, sItemName, sBindItemName: string;
  nType: Integer;
begin
  UnLoadBindItemList;
  m_UnbindItemList := TGList.Create;
  sFileName := CreateUserDirectory + 'BindItemList.Dat';

  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    try
      LoadList.LoadFromFile(sFileName);
    except
      LoadList.Clear;
    end;
  end else begin
    LoadList.Add('0' + #9 + '金创药(中量)' + #9 + '金创药(中)包');
    LoadList.Add('1' + #9 + '魔法药(中量)' + #9 + '魔法药(中)包');
    LoadList.Add('0' + #9 + '强效金创药' + #9 + '超级金创药');
    LoadList.Add('1' + #9 + '强效魔法药' + #9 + '超级魔法药');
    LoadList.Add('2' + #9 + '疗伤药' + #9 + '疗伤药包');
    LoadList.Add('2' + #9 + '万年雪霜' + #9 + '雪霜包');
    LoadList.Add('2' + #9 + '太阳水' + #9 + '太阳水');
    LoadList.Add('2' + #9 + '强效太阳水' + #9 + '强效太阳水');
    LoadList.SaveToFile(sFileName);
  end;
  for I := 0 to LoadList.Count - 1 do begin
    sLineText := Trim(LoadList.Strings[I]);
    if sLineText = '' then Continue;
    if (sLineText <> '') and (sLineText[1] = ';') then Continue;
    sLineText := GetValidStr3(sLineText, sType, [' ', #9]);
    sLineText := GetValidStr3(sLineText, sItemName, [' ', #9]);
    sLineText := GetValidStr3(sLineText, sBindItemName, [' ', #9]);
    nType := Str_ToInt(sType, -1);
    if (nType in [0..3]) and (sItemName <> '') and (sBindItemName <> '') then begin
      New(BindItem);
      BindItem.btItemType := nType;
      BindItem.sItemName := sItemName;
      BindItem.sBindItemName := sBindItemName;
      m_UnbindItemList.Add(BindItem);
    end;
  end;
  LoadList.Free;
end;

procedure TGameEngine.UnLoadBindItemList;
var
  I: Integer;
begin
  if m_UnbindItemList = nil then Exit;
  m_UnbindItemList.Lock;
  try
    for I := 0 to m_UnbindItemList.Count - 1 do begin
      Dispose(pTBindClientItem(m_UnbindItemList.Items[I]));
    end;
  finally
    m_UnbindItemList.UnLock;
  end;
  m_UnbindItemList.Free;
  m_UnbindItemList := nil;
end;

procedure TGameEngine.SaveBindItemList;
var
  I: Integer;
  SaveList: TStringList;
  sFileName: string;
  BindItem: pTBindClientItem;
begin
  if m_UnbindItemList = nil then Exit;
  SaveList := TStringList.Create;
  m_UnbindItemList.Lock;
  try
    for I := 0 to m_UnbindItemList.Count - 1 do begin
      BindItem := pTBindClientItem(m_UnbindItemList.Items[I]);
      SaveList.Add(IntToStr(BindItem.btItemType) + #9 + BindItem.sItemName + #9 + BindItem.sBindItemName);
    end;
  finally
    m_UnbindItemList.UnLock;
  end;
  sFileName := CreateUserDirectory + 'BindItemList.Dat';
  SaveList.SaveToFile(sFileName);
  SaveList.Free;
end;

procedure TGameEngine.DeleteBindItem(BindItem: pTBindClientItem);
var
  I: Integer;
begin
  if m_UnbindItemList = nil then Exit;
  m_UnbindItemList.Lock;
  try
    for I := m_UnbindItemList.Count - 1 downto 0 do begin
      if m_UnbindItemList.Items[I] = BindItem then begin
        Dispose(pTBindClientItem(m_UnbindItemList.Items[I]));
        m_UnbindItemList.Delete(I);
        Break;
      end;
    end;
  finally
    m_UnbindItemList.UnLock;
  end;
end;

function TGameEngine.FindBindItemName(btType: Integer): string;
var
  I: Integer;
begin
  Result := '';
  if m_UnbindItemList = nil then Exit;
  m_UnbindItemList.Lock;
  try
    for I := 0 to m_UnbindItemList.Count - 1 do begin
      if pTBindClientItem(m_UnbindItemList.Items[I]).btItemType = btType then begin
        Result := pTBindClientItem(m_UnbindItemList.Items[I]).sBindItemName;
        Break;
      end;
    end;
  finally
    m_UnbindItemList.UnLock;
  end;
end;

function TGameEngine.FindBindItemName(sItemName: string): string;
var
  I: Integer;
begin
  Result := '';
  if m_UnbindItemList = nil then Exit;
  m_UnbindItemList.Lock;
  try
    for I := 0 to m_UnbindItemList.Count - 1 do begin
      if CompareText(pTBindClientItem(m_UnbindItemList.Items[I]).sItemName, sItemName) = 0 then begin
        Result := pTBindClientItem(m_UnbindItemList.Items[I]).sBindItemName;
        Break;
      end;
    end;
  finally
    m_UnbindItemList.UnLock;
  end;
end;

function TGameEngine.FindBindItemName(btType: Integer; sItemName: string): string;
var
  I: Integer;
begin
  Result := '';
  if m_UnbindItemList = nil then Exit;
  m_UnbindItemList.Lock;
  try
    for I := 0 to m_UnbindItemList.Count - 1 do begin
      if (pTBindClientItem(m_UnbindItemList.Items[I]).btItemType = btType) and
        (CompareText(pTBindClientItem(m_UnbindItemList.Items[I]).sItemName, sItemName) = 0) then begin
        Result := pTBindClientItem(m_UnbindItemList.Items[I]).sBindItemName;
        Break;
      end;
    end;
  finally
    m_UnbindItemList.UnLock;
  end;
end;

function TGameEngine.FindUnBindItemName(btType: Integer): string;
var
  I: Integer;
begin
  Result := '';
  if m_UnbindItemList = nil then Exit;
  m_UnbindItemList.Lock;
  try
    for I := 0 to m_UnbindItemList.Count - 1 do begin
      if pTBindClientItem(m_UnbindItemList.Items[I]).btItemType = btType then begin
        Result := pTBindClientItem(m_UnbindItemList.Items[I]).sItemName;
        Break;
      end;
    end;
  finally
    m_UnbindItemList.UnLock;
  end;
end;

function TGameEngine.FindUnBindItemName(btType: Integer; sItemName: string): string;
var
  I: Integer;
begin
  Result := '';
  if m_UnbindItemList = nil then Exit;
  m_UnbindItemList.Lock;
  try
    for I := 0 to m_UnbindItemList.Count - 1 do begin
      if (pTBindClientItem(m_UnbindItemList.Items[I]).btItemType = btType) and
        (CompareText(pTBindClientItem(m_UnbindItemList.Items[I]).sItemName, sItemName) = 0) then begin
        Result := pTBindClientItem(m_UnbindItemList.Items[I]).sItemName;
        Break;
      end;
    end;
  finally
    m_UnbindItemList.UnLock;
  end;
end;

function TGameEngine.FindUnBindItemName(sItemName: string): string;
var
  I: Integer;
begin
  Result := '';
  if m_UnbindItemList = nil then Exit;
  m_UnbindItemList.Lock;
  try
    for I := 0 to m_UnbindItemList.Count - 1 do begin
      if CompareText(pTBindClientItem(m_UnbindItemList.Items[I]).sItemName, sItemName) = 0 then begin
        Result := pTBindClientItem(m_UnbindItemList.Items[I]).sItemName;
        Break;
      end;
    end;
  finally
    m_UnbindItemList.UnLock;
  end;
end;

{----------------------------------------------------------}

function TGameEngine.BagItemCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  case m_btVersion of
    0:
      for I := Low(m_ItemArr_BLUE) to High(m_ItemArr_BLUE) do begin
        if m_ItemArr_BLUE[I].s.Name <> '' then Inc(Result)
      end;
    1:
      for I := Low(m_ItemArr_IGE) to High(m_ItemArr_IGE) do begin
        if m_ItemArr_IGE[I].s.Name <> '' then Inc(Result)
      end;
  end;
end;

function TGameEngine.HeroBagItemCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  case m_btVersion of
    0:
      for I := Low(m_HeroItemArr_BLUE) to High(m_HeroItemArr_BLUE) do begin
        if m_HeroItemArr_BLUE[I].s.Name <> '' then Inc(Result)
      end;
    1:
      for I := Low(m_HeroItemArr_IGE) to High(m_HeroItemArr_IGE) do begin
        if m_HeroItemArr_IGE[I].s.Name <> '' then Inc(Result)
      end;
  end;
end;


function TGameEngine.FindItemArrItemName(btType: Byte): Integer;
var
  I: Integer;
begin
  Result := -1;
  case m_btVersion of
    0:
      for I := Low(m_ItemArr_BLUE) to High(m_ItemArr_BLUE) do begin
        if m_ItemArr_BLUE[I].s.Name <> '' then begin
          if FindUnBindItemName(btType, m_ItemArr_BLUE[I].s.Name) <> '' then begin
            Result := I;
            Break;
          end;
        end;
      end;
    1:
      for I := Low(m_ItemArr_IGE) to High(m_ItemArr_IGE) do begin
        if m_ItemArr_IGE[I].s.Name <> '' then begin
          if FindUnBindItemName(btType, m_ItemArr_IGE[I].s.Name) <> '' then begin
            Result := I;
            Break;
          end;
        end;
      end;
  end;
end;

function TGameEngine.FindItemArrItemName(sItemName: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  case m_btVersion of
    0: if FindUnBindItemName(sItemName) <> '' then begin
        for I := Low(m_ItemArr_BLUE) to High(m_ItemArr_BLUE) do begin
          if m_ItemArr_BLUE[I].s.Name <> '' then begin
            if m_ItemArr_BLUE[I].s.Name = sItemName then begin
              Result := I;
              Break;
            end;
          end;
        end;
      end;
    1: if FindUnBindItemName(sItemName) <> '' then begin
        for I := Low(m_ItemArr_IGE) to High(m_ItemArr_IGE) do begin
          if m_ItemArr_IGE[I].s.Name <> '' then begin
            if m_ItemArr_IGE[I].s.Name = sItemName then begin
              Result := I;
              Break;
            end;
          end;
        end;
      end;
  end;
end;


function TGameEngine.FindItemArrBindItemName(btType: Byte): Integer;
var
  I: Integer;
begin
  Result := -1;
  case m_btVersion of
    0:
      for I := Low(m_ItemArr_BLUE) to High(m_ItemArr_BLUE) do begin
        if m_ItemArr_BLUE[I].s.Name <> '' then begin
          if FindBindItemName(btType, m_ItemArr_BLUE[I].s.Name) <> '' then begin
            Result := I;
            Break;
          end;
        end;
      end;
    1:
      for I := Low(m_ItemArr_IGE) to High(m_ItemArr_IGE) do begin
        if m_ItemArr_IGE[I].s.Name <> '' then begin
          if FindBindItemName(btType, m_ItemArr_IGE[I].s.Name) <> '' then begin
            Result := I;
            Break;
          end;
        end;
      end;
  end;
end;

function TGameEngine.FindItemArrBindItemName(sItemName: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  case m_btVersion of
    0:
      for I := Low(m_ItemArr_BLUE) + 6 to High(m_ItemArr_BLUE) do begin
        if m_ItemArr_BLUE[I].s.Name <> '' then begin
          if CompareText(FindBindItemName(sItemName), m_ItemArr_BLUE[I].s.Name) = 0 then begin
            Result := I;
            Break;
          end;
        end;
      end;
    1:
      for I := Low(m_ItemArr_IGE) + 6 to High(m_ItemArr_IGE) do begin
        if m_ItemArr_IGE[I].s.Name <> '' then begin
          if CompareText(FindBindItemName(sItemName), m_ItemArr_IGE[I].s.Name) = 0 then begin
            Result := I;
            Break;
          end;
        end;
      end;
  end;
end;

function TGameEngine.FindHeroItemArrItemName(btType: Byte): Integer;
var
  I: Integer;
begin
  Result := -1;
  case m_btVersion of
    0:
      for I := Low(m_HeroItemArr_BLUE) to High(m_HeroItemArr_BLUE) do begin
        if m_HeroItemArr_BLUE[I].s.Name <> '' then begin
          if FindUnBindItemName(btType, m_HeroItemArr_BLUE[I].s.Name) <> '' then begin
            Result := I;
            Break;
          end;
        end;
      end;
    1:
      for I := Low(m_HeroItemArr_IGE) to High(m_HeroItemArr_IGE) do begin
        if m_HeroItemArr_IGE[I].s.Name <> '' then begin
          if FindUnBindItemName(btType, m_HeroItemArr_IGE[I].s.Name) <> '' then begin
            Result := I;
            Break;
          end;
        end;
      end;
  end;
end;

function TGameEngine.FindHeroItemArrItemName(sItemName: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  case m_btVersion of
    0: begin
        if FindUnBindItemName(sItemName) <> '' then begin
          for I := Low(m_HeroItemArr_BLUE) to High(m_HeroItemArr_BLUE) do begin
            if m_HeroItemArr_BLUE[I].s.Name <> '' then begin
              if CompareText(sItemName, m_HeroItemArr_BLUE[I].s.Name) = 0 then begin
                Result := I;
                Break;
              end;
            end;
          end;
        end;
      end;
    1: begin
        if FindUnBindItemName(sItemName) <> '' then begin
          for I := Low(m_HeroItemArr_IGE) to High(m_HeroItemArr_IGE) do begin
            if m_HeroItemArr_IGE[I].s.Name <> '' then begin
              if CompareText(sItemName, m_HeroItemArr_IGE[I].s.Name) = 0 then begin
                Result := I;
                Break;
              end;
            end;
          end;
        end;
      end;
  end;
end;


function TGameEngine.FindHeroItemArrBindItemName(btType: Byte): Integer;
var
  I: Integer;
begin
  Result := -1;
  case m_btVersion of
    0:
      for I := Low(m_HeroItemArr_BLUE) to High(m_HeroItemArr_BLUE) do begin
        if m_HeroItemArr_BLUE[I].s.Name <> '' then begin
          if (FindBindItemName(btType, m_HeroItemArr_BLUE[I].s.Name) <> '') and (m_HeroItemArr_BLUE[I].s.AniCount > 0) and
            ((m_HeroItemArr_BLUE[I].s.AniCount = btType + 1) or ((btType >= 2) and (m_HeroItemArr_BLUE[I].s.AniCount = 2))) then begin
            Result := I;
            Break;
          end;
        end;
      end;
    1:
      for I := Low(m_HeroItemArr_IGE) to High(m_HeroItemArr_IGE) do begin
        if m_HeroItemArr_IGE[I].s.Name <> '' then begin
          if FindBindItemName(btType, m_HeroItemArr_IGE[I].s.Name) <> '' then begin
            Result := I;
            Break;
          end;
        end;
      end;
  end;
end;

function TGameEngine.FindHeroItemArrBindItemName(sItemName: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  case m_btVersion of
    0:
      for I := Low(m_HeroItemArr_BLUE) to High(m_HeroItemArr_BLUE) do begin
        if m_HeroItemArr_BLUE[I].s.Name <> '' then begin
          if (CompareText(FindBindItemName(sItemName), m_HeroItemArr_BLUE[I].s.Name) = 0) and
            (m_HeroItemArr_BLUE[I].s.AniCount > 0) then begin
            Result := I;
            Break;
          end;
        end;
      end;
    1:
      for I := Low(m_HeroItemArr_IGE) to High(m_HeroItemArr_IGE) do begin
        if m_HeroItemArr_IGE[I].s.Name <> '' then begin
          if CompareText(FindBindItemName(sItemName), m_HeroItemArr_IGE[I].s.Name) = 0 then begin
            Result := I;
            Break;
          end;
        end;
      end;
  end;
end;

//自动吃药

function TGameEngine.AutoEatItem(idx: Integer): Boolean;
var
  sName: string;
  Msg: TDefaultMessage;
  Msg_IGE: TDefaultMessage_IGE;
  MakeIndex: Integer;
begin
  Result := False;
  if idx in [0..46 - 1] then begin
    if Config.boFastEatItem then begin //双重喝药
      case m_btVersion of
        0: begin
            if (m_EatingItem.BLUE.s.Name <> '') and (GetTickCount - m_EatingItem.dwEatTime > 5 * 1000) then begin
              m_EatingItem.BLUE.s.Name := '';
            end;
            if (m_EatingItem2.BLUE.s.Name <> '') and (GetTickCount - m_EatingItem2.dwEatTime > 5 * 1000) then begin
              m_EatingItem2.BLUE.s.Name := '';
            end;
            if (m_EatingItem.BLUE.s.Name = '') or (m_EatingItem2.BLUE.s.Name = '') then begin
              if (m_ItemArr_BLUE[idx].s.Name <> '') and ((m_ItemArr_BLUE[idx].s.StdMode <= 3) or (m_ItemArr_BLUE[idx].s.StdMode = 31)) then begin
                m_dwEatTime := GetTickCount;
                m_dwEatItemTime := GetTickCount;

                if (m_EatingItem.BLUE.s.Name = '') then begin
                  m_EatingItem.BLUE := m_ItemArr_BLUE[idx];
                  m_EatingItem.boBind := m_ItemArr_BLUE[idx].s.StdMode = 31;
                  if m_EatingItem2.BLUE.s.Name = '' then
                    m_EatingItem.nIndex := 0
                  else
                    m_EatingItem.nIndex := 1;
                  m_EatingItem.boHero := False;
                  m_EatingItem.boAuto := True;
                  m_EatingItem.boSend := False;
                  m_EatingItem.dwEatTime := GetTickCount;
                  sName := m_EatingItem.BLUE.s.Name;
                  MakeIndex := m_EatingItem.BLUE.MakeIndex;
                end else
                  if (m_EatingItem2.BLUE.s.Name = '') then begin
                  m_EatingItem2.BLUE := m_ItemArr_BLUE[idx];
                  m_EatingItem2.boBind := m_ItemArr_BLUE[idx].s.StdMode = 31;
                  if m_EatingItem.BLUE.s.Name = '' then
                    m_EatingItem2.nIndex := 0
                  else
                    m_EatingItem2.nIndex := 1;
                  m_EatingItem2.boHero := False;
                  m_EatingItem2.boAuto := True;
                  m_EatingItem2.boSend := False;
                  m_EatingItem2.dwEatTime := GetTickCount;
                  sName := m_EatingItem2.BLUE.s.Name;
                  MakeIndex := m_EatingItem2.BLUE.MakeIndex;
                end;

                m_ItemArr_BLUE[idx].s.Name := '';

                Msg := MakeDefaultMsg(CM_EAT, MakeIndex, 0, 0, 0);
                GameSocket.SendSocket(EncodeMessage(Msg) {+ EncodeString(sName)});
                Result := True;
              end;
            end;
          end;
        1: begin
            if (m_EatingItem.IGE.s.Name <> '') and (GetTickCount - m_EatingItem.dwEatTime > 5 * 1000) then begin
              m_EatingItem.IGE.s.Name := '';
            end;
            if (m_EatingItem2.IGE.s.Name <> '') and (GetTickCount - m_EatingItem2.dwEatTime > 5 * 1000) then begin
              m_EatingItem2.IGE.s.Name := '';
            end;
            if (m_EatingItem.IGE.s.Name = '') or (m_EatingItem2.IGE.s.Name = '') then begin
              if (m_ItemArr_IGE[idx].s.Name <> '') and ((m_ItemArr_IGE[idx].s.StdMode <= 3) or (m_ItemArr_IGE[idx].s.StdMode = 31)) then begin
                m_dwEatTime := GetTickCount;
                m_dwEatItemTime := GetTickCount;

                if (m_EatingItem.IGE.s.Name = '') then begin
                  m_EatingItem.IGE := m_ItemArr_IGE[idx];
                  m_EatingItem.boBind := m_ItemArr_IGE[idx].s.StdMode = 31;
                  if m_EatingItem2.IGE.s.Name = '' then
                    m_EatingItem.nIndex := 0
                  else
                    m_EatingItem.nIndex := 1;
                  m_EatingItem.boHero := False;
                  m_EatingItem.boAuto := True;
                  m_EatingItem.boSend := False;
                  m_EatingItem.dwEatTime := GetTickCount;
                  sName := m_EatingItem.IGE.s.Name;
                  MakeIndex := m_EatingItem.IGE.MakeIndex;
                end else
                  if (m_EatingItem2.IGE.s.Name = '') then begin
                  m_EatingItem2.IGE := m_ItemArr_IGE[idx];
                  m_EatingItem2.boBind := m_ItemArr_IGE[idx].s.StdMode = 31;
                  if m_EatingItem.IGE.s.Name = '' then
                    m_EatingItem2.nIndex := 0
                  else
                    m_EatingItem2.nIndex := 1;
                  m_EatingItem2.boHero := False;
                  m_EatingItem2.boAuto := True;
                  m_EatingItem2.boSend := False;
                  m_EatingItem2.dwEatTime := GetTickCount;
                  sName := m_EatingItem2.IGE.s.Name;
                  MakeIndex := m_EatingItem2.IGE.MakeIndex;
                end;

                m_ItemArr_IGE[idx].s.Name := '';

                Msg_IGE := MakeDefaultMsg_IGE(CM_EAT, MakeIndex, 0, 0, 0);
                GameSocket.SendSocket(EncodeMessage_IGE(Msg_IGE) + EncodeString(sName));
                Result := True;
              end;
            end;
          end;
      end;
    end else begin
      case m_btVersion of
        0: begin
            if (m_EatingItem.BLUE.s.Name <> '') and (GetTickCount - m_EatingItem.dwEatTime > 5 * 1000) then begin
              m_EatingItem.BLUE.s.Name := '';
            end;
            if (m_EatingItem2.BLUE.s.Name <> '') and (GetTickCount - m_EatingItem2.dwEatTime > 5 * 1000) then begin
              m_EatingItem2.BLUE.s.Name := '';
            end;
            if (m_EatingItem.BLUE.s.Name = '') and (m_EatingItem2.BLUE.s.Name = '') then begin
              if (m_ItemArr_BLUE[idx].s.Name <> '') and ((m_ItemArr_BLUE[idx].s.StdMode <= 3) or (m_ItemArr_BLUE[idx].s.StdMode = 31)) then begin
                m_dwEatTime := GetTickCount;
                m_dwEatItemTime := GetTickCount;
                m_EatingItem.BLUE := m_ItemArr_BLUE[idx];
                m_EatingItem.boBind := m_ItemArr_BLUE[idx].s.StdMode = 31;
                m_EatingItem.nIndex := 0;
                m_EatingItem.boHero := False;
                m_EatingItem.boAuto := True;
                m_EatingItem.boSend := False;
                m_EatingItem.dwEatTime := GetTickCount;
                sName := m_EatingItem.BLUE.s.Name;
                MakeIndex := m_EatingItem.BLUE.MakeIndex;
                m_ItemArr_BLUE[idx].s.Name := '';
                Msg := MakeDefaultMsg(CM_EAT, MakeIndex, 0, 0, 0);
                GameSocket.SendSocket(EncodeMessage(Msg) { + EncodeString(sName)});
                Result := True;
              end;
            end;
          end;
        1: begin
            if (m_EatingItem.IGE.s.Name <> '') and (GetTickCount - m_EatingItem.dwEatTime > 5 * 1000) then begin
              m_EatingItem.IGE.s.Name := '';
            end;
            if (m_EatingItem2.IGE.s.Name <> '') and (GetTickCount - m_EatingItem2.dwEatTime > 5 * 1000) then begin
              m_EatingItem2.IGE.s.Name := '';
            end;
            if (m_EatingItem.IGE.s.Name = '') and (m_EatingItem2.IGE.s.Name = '') then begin
              if (m_ItemArr_IGE[idx].s.Name <> '') and ((m_ItemArr_IGE[idx].s.StdMode <= 3) or (m_ItemArr_IGE[idx].s.StdMode = 31)) then begin
                m_dwEatTime := GetTickCount;
                m_dwEatItemTime := GetTickCount;
                m_EatingItem.IGE := m_ItemArr_IGE[idx];
                m_EatingItem.boBind := m_ItemArr_IGE[idx].s.StdMode = 31;
                m_EatingItem.nIndex := 0;
                m_EatingItem.boHero := False;
                m_EatingItem.boAuto := True;
                m_EatingItem.boSend := False;
                m_EatingItem.dwEatTime := GetTickCount;
                sName := m_EatingItem.IGE.s.Name;
                MakeIndex := m_EatingItem.IGE.MakeIndex;
                m_ItemArr_IGE[idx].s.Name := '';
                Msg_IGE := MakeDefaultMsg_IGE(CM_EAT, MakeIndex, 0, 0, 0);
                GameSocket.SendSocket(EncodeMessage_IGE(Msg_IGE) + EncodeString(sName));
                Result := True;
              end;
            end;
          end;
      end;
    end;
  end;
end;

//自动吃药

function TGameEngine.AutoHeroEatItem(idx: Integer): Boolean;
var
  sName: string;
  Msg: TDefaultMessage;
  Msg_IGE: TDefaultMessage_IGE;
  MakeIndex: Integer;
begin
  Result := False;
  if idx in [0..40 - 1] then begin
    if Config.boFastEatItem then begin //双重喝药
      case m_btVersion of
        0: begin
            if (m_HeroEatingItem.BLUE.s.Name <> '') and (GetTickCount - m_HeroEatingItem.dwEatTime > 5 * 1000) then begin
              m_HeroEatingItem.BLUE.s.Name := '';
            end;
            if (m_HeroEatingItem2.BLUE.s.Name <> '') and (GetTickCount - m_HeroEatingItem2.dwEatTime > 5 * 1000) then begin
              m_HeroEatingItem2.BLUE.s.Name := '';
            end;
            if (m_HeroEatingItem.BLUE.s.Name = '') or (m_HeroEatingItem2.BLUE.s.Name = '') then begin
              if (m_HeroItemArr_BLUE[idx].s.Name <> '') and ((m_HeroItemArr_BLUE[idx].s.StdMode <= 3) or (m_HeroItemArr_BLUE[idx].s.StdMode = 31)) then begin
                m_dwHeroEatTime := GetTickCount;
                m_dwEatItemTime := GetTickCount;

                if (m_HeroEatingItem.BLUE.s.Name = '') then begin
                  m_HeroEatingItem.BLUE := m_HeroItemArr_BLUE[idx];
                  m_HeroEatingItem.boBind := m_HeroItemArr_BLUE[idx].s.StdMode = 31;
                  if m_HeroEatingItem2.BLUE.s.Name = '' then
                    m_HeroEatingItem.nIndex := 0
                  else
                    m_HeroEatingItem.nIndex := 1;
                  m_HeroEatingItem.boHero := True;
                  m_HeroEatingItem.boAuto := True;
                  m_HeroEatingItem.boSend := False;
                  m_HeroEatingItem.dwEatTime := GetTickCount;
                  sName := m_HeroEatingItem.BLUE.s.Name;
                  MakeIndex := m_HeroEatingItem.BLUE.MakeIndex;
                end else
                  if (m_HeroEatingItem2.BLUE.s.Name = '') then begin
                  m_HeroEatingItem2.BLUE := m_HeroItemArr_BLUE[idx];
                  m_HeroEatingItem2.boBind := m_HeroItemArr_BLUE[idx].s.StdMode = 31;
                  if m_HeroEatingItem.BLUE.s.Name = '' then
                    m_HeroEatingItem2.nIndex := 0
                  else
                    m_HeroEatingItem2.nIndex := 1;
                  m_HeroEatingItem2.boHero := True;
                  m_HeroEatingItem2.boAuto := True;
                  m_HeroEatingItem2.boSend := False;
                  m_HeroEatingItem2.dwEatTime := GetTickCount;
                  sName := m_HeroEatingItem2.BLUE.s.Name;
                  MakeIndex := m_HeroEatingItem2.BLUE.MakeIndex;
                end;

                m_HeroItemArr_BLUE[idx].s.Name := '';

                Msg := MakeDefaultMsg(BLUE_SEND_1104, MakeIndex, 0, 0, 0);
                GameSocket.SendSocket(EncodeMessage(Msg) { + EncodeString(sName)});
                Result := True;
              end;
            end;
          end;
        1: begin
            if (m_HeroEatingItem.IGE.s.Name <> '') and (GetTickCount - m_HeroEatingItem.dwEatTime > 5 * 1000) then begin
              m_HeroEatingItem.IGE.s.Name := '';
            end;
            if (m_HeroEatingItem2.IGE.s.Name <> '') and (GetTickCount - m_HeroEatingItem2.dwEatTime > 5 * 1000) then begin
              m_HeroEatingItem2.IGE.s.Name := '';
            end;
            if (m_HeroEatingItem.IGE.s.Name = '') or (m_HeroEatingItem2.IGE.s.Name = '') then begin
              if (m_HeroItemArr_IGE[idx].s.Name <> '') and ((m_HeroItemArr_IGE[idx].s.StdMode <= 3) or (m_HeroItemArr_IGE[idx].s.StdMode = 31)) then begin
                m_dwHeroEatTime := GetTickCount;
                m_dwEatItemTime := GetTickCount;

                if (m_HeroEatingItem.IGE.s.Name = '') then begin
                  m_HeroEatingItem.IGE := m_HeroItemArr_IGE[idx];
                  m_HeroEatingItem.boBind := m_HeroItemArr_IGE[idx].s.StdMode = 31;
                  if m_HeroEatingItem2.IGE.s.Name = '' then
                    m_HeroEatingItem.nIndex := 0
                  else
                    m_HeroEatingItem.nIndex := 1;
                  m_HeroEatingItem.boHero := True;
                  m_HeroEatingItem.boAuto := True;
                  m_HeroEatingItem.boSend := False;
                  m_HeroEatingItem.dwEatTime := GetTickCount;
                  sName := m_HeroEatingItem.IGE.s.Name;
                  MakeIndex := m_HeroEatingItem.IGE.MakeIndex;
                end else
                  if (m_HeroEatingItem2.IGE.s.Name = '') then begin
                  m_HeroEatingItem2.IGE := m_HeroItemArr_IGE[idx];
                  m_HeroEatingItem2.boBind := m_HeroItemArr_IGE[idx].s.StdMode = 31;
                  if m_HeroEatingItem.IGE.s.Name = '' then
                    m_HeroEatingItem2.nIndex := 0
                  else
                    m_HeroEatingItem2.nIndex := 1;
                  m_HeroEatingItem2.boHero := True;
                  m_HeroEatingItem2.boAuto := True;
                  m_HeroEatingItem2.boSend := False;
                  m_HeroEatingItem2.dwEatTime := GetTickCount;
                  sName := m_HeroEatingItem2.IGE.s.Name;
                  MakeIndex := m_HeroEatingItem2.IGE.MakeIndex;
                end;

                m_HeroItemArr_IGE[idx].s.Name := '';

                Msg_IGE := MakeDefaultMsg_IGE(CM_IGE_5043, MakeIndex, 0, 0, 0);
                GameSocket.SendSocket(EncodeMessage_IGE(Msg_IGE) + EncodeString(sName));
                Result := True;
              end;
            end;
          end;
      end;
    end else begin
      case m_btVersion of
        0: begin
            if (m_HeroEatingItem.BLUE.s.Name <> '') and (GetTickCount - m_HeroEatingItem.dwEatTime > 5 * 1000) then begin
              m_HeroEatingItem.BLUE.s.Name := '';
            end;
            if (m_HeroEatingItem2.BLUE.s.Name <> '') and (GetTickCount - m_HeroEatingItem2.dwEatTime > 5 * 1000) then begin
              m_HeroEatingItem2.BLUE.s.Name := '';
            end;
            if (m_HeroEatingItem.BLUE.s.Name = '') and (m_HeroEatingItem2.BLUE.s.Name = '') then begin
              if (m_HeroItemArr_BLUE[idx].s.Name <> '') and ((m_HeroItemArr_BLUE[idx].s.StdMode <= 3) or (m_HeroItemArr_BLUE[idx].s.StdMode = 31)) then begin
                m_dwHeroEatTime := GetTickCount;
                m_dwEatItemTime := GetTickCount;
                m_HeroEatingItem.BLUE := m_HeroItemArr_BLUE[idx];
                m_HeroEatingItem.boBind := m_HeroItemArr_BLUE[idx].s.StdMode = 31;
                m_HeroEatingItem.nIndex := 0;
                m_HeroEatingItem.boHero := True;
                m_HeroEatingItem.boAuto := True;
                m_HeroEatingItem.boSend := False;
                m_HeroEatingItem.dwEatTime := GetTickCount;
                sName := m_HeroEatingItem.BLUE.s.Name;
                MakeIndex := m_HeroEatingItem.BLUE.MakeIndex;
                m_HeroItemArr_BLUE[idx].s.Name := '';
                Msg := MakeDefaultMsg(BLUE_SEND_1104, MakeIndex, 0, 0, 0);
                GameSocket.SendSocket(EncodeMessage(Msg) { + EncodeString(sName)});
                Result := True;
              end;
            end;
          end;
        1: begin
            if (m_HeroEatingItem.IGE.s.Name <> '') and (GetTickCount - m_HeroEatingItem.dwEatTime > 5 * 1000) then begin
              m_HeroEatingItem.IGE.s.Name := '';
            end;
            if (m_HeroEatingItem2.IGE.s.Name <> '') and (GetTickCount - m_HeroEatingItem2.dwEatTime > 5 * 1000) then begin
              m_HeroEatingItem2.IGE.s.Name := '';
            end;
            if (m_HeroEatingItem.IGE.s.Name = '') and (m_HeroEatingItem2.IGE.s.Name = '') then begin
              if (m_HeroItemArr_IGE[idx].s.Name <> '') and ((m_HeroItemArr_IGE[idx].s.StdMode <= 3) or (m_HeroItemArr_IGE[idx].s.StdMode = 31)) then begin
                m_dwHeroEatTime := GetTickCount;
                m_dwEatItemTime := GetTickCount;
                m_HeroEatingItem.IGE := m_HeroItemArr_IGE[idx];
                m_HeroEatingItem.boBind := m_HeroItemArr_IGE[idx].s.StdMode = 31;
                m_HeroEatingItem.nIndex := 0;
                m_HeroEatingItem.boHero := True;
                m_HeroEatingItem.boAuto := True;
                m_HeroEatingItem.boSend := False;
                m_HeroEatingItem.dwEatTime := GetTickCount;
                sName := m_HeroEatingItem.IGE.s.Name;
                MakeIndex := m_HeroEatingItem.IGE.MakeIndex;
                m_HeroItemArr_IGE[idx].s.Name := '';
                Msg_IGE := MakeDefaultMsg_IGE(CM_IGE_5043, MakeIndex, 0, 0, 0);
                GameSocket.SendSocket(EncodeMessage_IGE(Msg_IGE) + EncodeString(sName));
                Result := True;
              end;
            end;
          end;
      end;
    end;
  end;
end;

function TGameEngine.GetEating: Boolean;
begin
  Result := False;
  if FCheckCode <> 0 then Exit;
  if Config.boFastEatItem then begin //双重喝药
    case m_btVersion of
      0: begin
          if (m_EatingItem.BLUE.s.Name <> '') and (GetTickCount - m_EatingItem.dwEatTime > 5 * 1000) then begin
            m_EatingItem.BLUE.s.Name := '';
          end;
          if (m_EatingItem2.BLUE.s.Name <> '') and (GetTickCount - m_EatingItem2.dwEatTime > 5 * 1000) then begin
            m_EatingItem2.BLUE.s.Name := '';
          end;
          if (m_EatingItem.BLUE.s.Name = '') and (m_EatingItem2.BLUE.s.Name = '') then Result := True
          else if (m_EatingItem.BLUE.s.Name = '') and (m_EatingItem2.BLUE.s.Name <> '') and (not m_EatingItem2.boBind) then Result := True
          else if (m_EatingItem.BLUE.s.Name <> '') and (m_EatingItem2.BLUE.s.Name = '') and (not m_EatingItem.boBind) then Result := True;
        //Result := (m_EatingItem.BLUE.s.Name = '') or (m_EatingItem2.BLUE.s.Name = '');
        end;
      1: begin
          if (m_EatingItem.IGE.s.Name <> '') and (GetTickCount - m_EatingItem.dwEatTime > 5 * 1000) then begin
            m_EatingItem.IGE.s.Name := '';
          end;
          if (m_EatingItem2.IGE.s.Name <> '') and (GetTickCount - m_EatingItem2.dwEatTime > 5 * 1000) then begin
            m_EatingItem2.IGE.s.Name := '';
          end;
          if (m_EatingItem.IGE.s.Name = '') and (m_EatingItem2.IGE.s.Name = '') then Result := True
          else if (m_EatingItem.IGE.s.Name = '') and (m_EatingItem2.IGE.s.Name <> '') and (not m_EatingItem2.boBind) then Result := True
          else if (m_EatingItem.IGE.s.Name <> '') and (m_EatingItem2.IGE.s.Name = '') and (not m_EatingItem.boBind) then Result := True;
        //Result := (m_EatingItem.IGE.s.Name = '') or (m_EatingItem2.IGE.s.Name = '') { and (GetTickCount - m_dwEatItemTime > 100)};
        end;
    end;
  end else begin
    case m_btVersion of
      0: begin
          if (m_EatingItem.BLUE.s.Name <> '') and (GetTickCount - m_EatingItem.dwEatTime > 5 * 1000) then begin
            m_EatingItem.BLUE.s.Name := '';
          end;
          if (m_EatingItem2.BLUE.s.Name <> '') and (GetTickCount - m_EatingItem2.dwEatTime > 5 * 1000) then begin
            m_EatingItem2.BLUE.s.Name := '';
          end;
          if (m_EatingItem.BLUE.s.Name = '') and (m_EatingItem2.BLUE.s.Name = '') then Result := True;
        end;
      1: begin
          if (m_EatingItem.IGE.s.Name <> '') and (GetTickCount - m_EatingItem.dwEatTime > 5 * 1000) then begin
            m_EatingItem.IGE.s.Name := '';
          end;
          if (m_EatingItem2.IGE.s.Name <> '') and (GetTickCount - m_EatingItem2.dwEatTime > 5 * 1000) then begin
            m_EatingItem2.IGE.s.Name := '';
          end;
          if (m_EatingItem.IGE.s.Name = '') and (m_EatingItem2.IGE.s.Name = '') then Result := True;
        end;
    end;
  end;
end;

function TGameEngine.GetHeroEating: Boolean;
begin
  Result := False;
  if FCheckCode <> 0 then Exit;
  if Config.boFastEatItem then begin //双重喝药
    case m_btVersion of
      0: begin
          if (m_HeroEatingItem.BLUE.s.Name <> '') and (GetTickCount - m_HeroEatingItem.dwEatTime > 5 * 1000) then begin
            m_HeroEatingItem.BLUE.s.Name := '';
          end;
          if (m_HeroEatingItem2.BLUE.s.Name <> '') and (GetTickCount - m_HeroEatingItem2.dwEatTime > 5 * 1000) then begin
            m_HeroEatingItem2.BLUE.s.Name := '';
          end;
          if (m_HeroEatingItem.BLUE.s.Name = '') and (m_HeroEatingItem2.BLUE.s.Name = '') then Result := True
          else if (m_HeroEatingItem.BLUE.s.Name = '') and (m_HeroEatingItem2.BLUE.s.Name <> '') and (not m_HeroEatingItem2.boBind) then Result := True
          else if (m_HeroEatingItem.BLUE.s.Name <> '') and (m_HeroEatingItem2.BLUE.s.Name = '') and (not m_HeroEatingItem.boBind) then Result := True;
        //Result := (m_HeroEatingItem.BLUE.s.Name = '') or (m_HeroEatingItem2.BLUE.s.Name = '');
        end;
      1: begin
          if (m_HeroEatingItem.IGE.s.Name <> '') and (GetTickCount - m_HeroEatingItem.dwEatTime > 5 * 1000) then begin
            m_HeroEatingItem.IGE.s.Name := '';
          end;
          if (m_HeroEatingItem2.IGE.s.Name <> '') and (GetTickCount - m_HeroEatingItem2.dwEatTime > 5 * 1000) then begin
            m_HeroEatingItem2.IGE.s.Name := '';
          end;
          if (m_HeroEatingItem.IGE.s.Name = '') and (m_HeroEatingItem2.IGE.s.Name = '') then Result := True
          else if (m_HeroEatingItem.IGE.s.Name = '') and (m_HeroEatingItem2.IGE.s.Name <> '') and (not m_HeroEatingItem2.boBind) then Result := True
          else if (m_HeroEatingItem.IGE.s.Name <> '') and (m_HeroEatingItem2.IGE.s.Name = '') and (not m_HeroEatingItem.boBind) then Result := True;
        //Result := (m_HeroEatingItem.IGE.s.Name = '') or (m_HeroEatingItem2.IGE.s.Name = '') { and (GetTickCount - m_dwEatItemTime > 100)};
        end;
    end;
  end else begin
    case m_btVersion of
      0: begin
          if (m_HeroEatingItem.BLUE.s.Name <> '') and (GetTickCount - m_HeroEatingItem.dwEatTime > 5 * 1000) then begin
            m_HeroEatingItem.BLUE.s.Name := '';
          end;
          if (m_HeroEatingItem2.BLUE.s.Name <> '') and (GetTickCount - m_HeroEatingItem2.dwEatTime > 5 * 1000) then begin
            m_HeroEatingItem2.BLUE.s.Name := '';
          end;
          if (m_HeroEatingItem.BLUE.s.Name = '') and (m_HeroEatingItem2.BLUE.s.Name = '') then Result := True
        end;
      1: begin
          if (m_HeroEatingItem.IGE.s.Name <> '') and (GetTickCount - m_HeroEatingItem.dwEatTime > 5 * 1000) then begin
            m_HeroEatingItem.IGE.s.Name := '';
          end;
          if (m_HeroEatingItem2.IGE.s.Name <> '') and (GetTickCount - m_HeroEatingItem2.dwEatTime > 5 * 1000) then begin
            m_HeroEatingItem2.IGE.s.Name := '';
          end;
          if (m_HeroEatingItem.IGE.s.Name = '') and (m_HeroEatingItem2.IGE.s.Name = '') then Result := True;
        end;
    end;
  end;
end;

function TGameEngine.GetEatItemFailCount(sItemName: string; nMakeIndex: Integer): Integer;
var
  I: Integer;
  EatItemFail: pTEatItemFail;
begin
  Result := 0;
  if sItemName = '' then Exit;
  for I := 0 to m_EatItemFailList.Count - 1 do begin
    EatItemFail := pTEatItemFail(m_EatItemFailList.Items[I]);
    if (CompareText(EatItemFail.Name, sItemName) = 0) and (EatItemFail.MakeIndex = nMakeIndex) then begin
      Result := EatItemFail.FailCount;
      Exit;
    end;
  end;
end;

function TGameEngine.GetEatItemFail(sItemName: string; nMakeIndex: Integer): Boolean;
var
  I: Integer;
  EatItemFail: pTEatItemFail;
begin
  Result := False;
  if sItemName = '' then Exit;
  for I := 0 to m_EatItemFailList.Count - 1 do begin
    EatItemFail := pTEatItemFail(m_EatItemFailList.Items[I]);
    if (CompareText(EatItemFail.Name, sItemName) = 0) and (EatItemFail.MakeIndex = nMakeIndex) then begin
      if GetTickCount - EatItemFail.dwEatTime >= 1000 * 3 then begin
        Result := True;
      end;
      Exit;
    end;
  end;
end;

function TGameEngine.GetEatItemFailA(sItemName: string; nMakeIndex: Integer): Boolean;
var
  I: Integer;
  EatItemFail: pTEatItemFail;
begin
  Result := False;
  if sItemName = '' then Exit;
  for I := 0 to m_EatItemFailList.Count - 1 do begin
    EatItemFail := pTEatItemFail(m_EatItemFailList.Items[I]);
    if (CompareText(EatItemFail.Name, sItemName) = 0) and (EatItemFail.MakeIndex = nMakeIndex) then begin
      if GetTickCount - EatItemFail.dwEatTime >= 1000 * 5 then begin
        Result := True;
      end;
      Exit;
    end;
  end;
end;

procedure TGameEngine.AddEatItemFail(sItemName: string; nMakeIndex: Integer);
var
  I: Integer;
  EatItemFail: pTEatItemFail;
begin
  if sItemName = '' then Exit;
  for I := 0 to m_EatItemFailList.Count - 1 do begin
    EatItemFail := pTEatItemFail(m_EatItemFailList.Items[I]);
    if (CompareText(EatItemFail.Name, sItemName) = 0) and (EatItemFail.MakeIndex = nMakeIndex) then begin
      Inc(EatItemFail.FailCount);
      Exit;
    end;
  end;
  New(EatItemFail);
  EatItemFail.Name := sItemName;
  EatItemFail.MakeIndex := nMakeIndex;
  EatItemFail.FailCount := 1;
  EatItemFail.dwEatTime := GetTickCount;
  m_EatItemFailList.Add(EatItemFail);
end;

procedure TGameEngine.DelEatItemFail(sItemName: string; nMakeIndex: Integer);
var
  I: Integer;
  EatItemFail: pTEatItemFail;
begin
  if sItemName = '' then Exit;
  for I := m_EatItemFailList.Count - 1 downto 0 do begin
    EatItemFail := pTEatItemFail(m_EatItemFailList.Items[I]);
    if (CompareText(EatItemFail.Name, sItemName) = 0) and (EatItemFail.MakeIndex = nMakeIndex) then begin
      m_EatItemFailList.Delete(I);
      Dispose(EatItemFail);
      Exit;
    end;
  end;
end;

procedure TGameEngine.ClearEatItemFail();
var
  I: Integer;
  EatItemFail: pTEatItemFail;
begin
  for I := 0 to m_EatItemFailList.Count - 1 do begin
    EatItemFail := pTEatItemFail(m_EatItemFailList.Items[I]);
    Dispose(EatItemFail);
  end;
  m_EatItemFailList.Clear;
end;

function TGameEngine.FindHumItemIndex(Index: Integer): Integer;
var
  I: Integer;
  BindItem: pTBindClientItem;
begin
  Result := -1;
  if (Index >= 0) and (Index < m_UnbindItemList.Count) then begin
    BindItem := m_UnbindItemList.Items[Index];
    case m_btVersion of
      0: begin
          for I := Low(m_ItemArr_BLUE) + 6 to High(m_ItemArr_BLUE) do begin
            if m_ItemArr_BLUE[I].s.Name <> '' then begin
              if CompareText(BindItem.sItemName, m_ItemArr_BLUE[I].s.Name) = 0 then begin
                {if GetEatItemFailCount(m_ItemArr_BLUE[I].s.Name, m_ItemArr_BLUE[I].MakeIndex) >= 3 then begin
                  //DelEatItemFail(m_ItemArr_BLUE[I].s.Name, m_ItemArr_BLUE[I].MakeIndex);
                  m_ItemArr_BLUE[I].s.Name := '';
                  Continue;
                end;}
                Result := I;
                Exit;
              end;
            end;
          end;
          if BagItemCount <= 40 then begin
            for I := Low(m_ItemArr_BLUE) to High(m_ItemArr_BLUE) do begin
              if m_ItemArr_BLUE[I].s.Name <> '' then begin
                if CompareText(BindItem.sBindItemName, m_ItemArr_BLUE[I].s.Name) = 0 then begin
                  {if GetEatItemFailCount(m_ItemArr_BLUE[I].s.Name, m_ItemArr_BLUE[I].MakeIndex) >= 3 then begin
                    //DelEatItemFail(m_ItemArr_BLUE[I].s.Name, m_ItemArr_BLUE[I].MakeIndex);
                    m_ItemArr_BLUE[I].s.Name := '';
                    Continue;
                  end;}
                  Result := I;
                  Exit;
                end;
              end;
            end;
          end;
          for I := Low(m_ItemArr_BLUE) to High(m_ItemArr_BLUE) do begin
            if m_ItemArr_BLUE[I].s.Name <> '' then begin
              if CompareText(BindItem.sItemName, m_ItemArr_BLUE[I].s.Name) = 0 then begin
                {if GetEatItemFailCount(m_ItemArr_BLUE[I].s.Name, m_ItemArr_BLUE[I].MakeIndex) >= 3 then begin
                  //DelEatItemFail(m_ItemArr_BLUE[I].s.Name, m_ItemArr_BLUE[I].MakeIndex);
                  m_ItemArr_BLUE[I].s.Name := '';
                  Continue;
                end;}
                Result := I;
                Exit;
              end;
            end;
          end;
        end;
      1: begin
          for I := Low(m_ItemArr_IGE) + 6 to High(m_ItemArr_IGE) do begin
            if m_ItemArr_IGE[I].s.Name <> '' then begin
              if CompareText(BindItem.sItemName, m_ItemArr_IGE[I].s.Name) = 0 then begin
                {if GetEatItemFailCount(m_ItemArr_IGE[I].s.Name, m_ItemArr_IGE[I].MakeIndex) >= 3 then begin
                  //DelEatItemFail(m_ItemArr_IGE[I].s.Name, m_ItemArr_IGE[I].MakeIndex);
                  m_ItemArr_IGE[I].s.Name := '';
                  Continue;
                end;}
                Result := I;
                Exit;
              end;
            end;
          end;
          if BagItemCount <= 40 then begin
            for I := Low(m_ItemArr_IGE) to High(m_ItemArr_IGE) do begin
              if m_ItemArr_IGE[I].s.Name <> '' then begin
                if CompareText(BindItem.sBindItemName, m_ItemArr_IGE[I].s.Name) = 0 then begin
                  {if GetEatItemFailCount(m_ItemArr_IGE[I].s.Name, m_ItemArr_IGE[I].MakeIndex) >= 3 then begin
                    //DelEatItemFail(m_ItemArr_IGE[I].s.Name, m_ItemArr_IGE[I].MakeIndex);
                    m_ItemArr_IGE[I].s.Name := '';
                    Continue;
                  end;}
                  Result := I;
                  Exit;
                end;
              end;
            end;
          end;
          for I := Low(m_ItemArr_IGE) to High(m_ItemArr_IGE) do begin
            if m_ItemArr_IGE[I].s.Name <> '' then begin
              if CompareText(BindItem.sItemName, m_ItemArr_IGE[I].s.Name) = 0 then begin
                {if GetEatItemFailCount(m_ItemArr_IGE[I].s.Name, m_ItemArr_IGE[I].MakeIndex) >= 3 then begin
                  //DelEatItemFail(m_ItemArr_IGE[I].s.Name, m_ItemArr_IGE[I].MakeIndex);
                  m_ItemArr_IGE[I].s.Name := '';
                  Continue;
                end;}
                Result := I;
                Exit;
              end;
            end;
          end;
        end;
    end;
  end;
end;

function TGameEngine.FindHeroItemIndex(Index: Integer): Integer;
var
  I: Integer;
  BindItem: pTBindClientItem;
begin
  Result := -1;
  if (Index >= 0) and (Index < m_UnbindItemList.Count) then begin
    BindItem := m_UnbindItemList.Items[Index];
    case m_btVersion of
      0: begin
          for I := Low(m_HeroItemArr_BLUE) to High(m_HeroItemArr_BLUE) do begin
            if m_HeroItemArr_BLUE[I].s.Name <> '' then begin
              if CompareText(BindItem.sItemName, m_HeroItemArr_BLUE[I].s.Name) = 0 then begin
                {if GetEatItemFailCount(m_HeroItemArr_BLUE[I].s.Name, m_HeroItemArr_BLUE[I].MakeIndex) >= 3 then begin
                  //DelEatItemFail(m_HeroItemArr_BLUE[I].s.Name, m_HeroItemArr_BLUE[I].MakeIndex);
                  m_HeroItemArr_BLUE[I].s.Name := '';
                  Continue;
                end;}
                Result := I;
                Exit;
              end;
            end;
          end;
          if m_nMaxBagCount - HeroBagItemCount >= 6 then begin
            for I := Low(m_HeroItemArr_BLUE) to High(m_HeroItemArr_BLUE) do begin
              if m_HeroItemArr_BLUE[I].s.Name <> '' then begin
                if (CompareText(BindItem.sBindItemName, m_HeroItemArr_BLUE[I].s.Name) = 0) and (((m_HeroItemArr_BLUE[I].s.AniCount = BindItem.btItemType + 1) or ((BindItem.btItemType >= 2) and (m_HeroItemArr_BLUE[I].s.AniCount = 2)))) then begin
                  {if GetEatItemFailCount(m_HeroItemArr_BLUE[I].s.Name, m_HeroItemArr_BLUE[I].MakeIndex) >= 3 then begin
                    //DelEatItemFail(m_HeroItemArr_BLUE[I].s.Name, m_HeroItemArr_BLUE[I].MakeIndex);
                    m_HeroItemArr_BLUE[I].s.Name := '';
                    Continue;
                  end;}
                  Result := I;
                  Exit;
                end;
              end;
            end;
          end;
        end;
      1: begin
          for I := Low(m_HeroItemArr_IGE) to High(m_HeroItemArr_IGE) do begin
            if m_HeroItemArr_IGE[I].s.Name <> '' then begin
              if CompareText(BindItem.sItemName, m_HeroItemArr_IGE[I].s.Name) = 0 then begin
                {if GetEatItemFailCount(m_HeroItemArr_IGE[I].s.Name, m_HeroItemArr_IGE[I].MakeIndex) >= 3 then begin
                  //DelEatItemFail(m_HeroItemArr_IGE[I].s.Name, m_HeroItemArr_IGE[I].MakeIndex);
                  m_HeroItemArr_IGE[I].s.Name := '';
                  Continue;
                end;}
                Result := I;
                Exit;
              end;
            end;
          end;
          if m_nMaxBagCount - HeroBagItemCount >= 6 then begin
            for I := Low(m_HeroItemArr_IGE) to High(m_HeroItemArr_IGE) do begin
              if m_HeroItemArr_IGE[I].s.Name <> '' then begin
                if CompareText(BindItem.sBindItemName, m_HeroItemArr_IGE[I].s.Name) = 0 then begin
                  {if GetEatItemFailCount(m_HeroItemArr_IGE[I].s.Name, m_HeroItemArr_IGE[I].MakeIndex) >= 3 then begin
                    //DelEatItemFail(m_HeroItemArr_IGE[I].s.Name, m_HeroItemArr_IGE[I].MakeIndex);
                    m_HeroItemArr_IGE[I].s.Name := '';
                    Continue;
                  end;}
                  Result := I;
                  Exit;
                end;
              end;
            end;
          end;
        end;
    end;
  end;
end;

procedure TGameEngine.AutoEatHPItem(Sender: TObject);
var
  nIndex: Integer;
  function EatHPItem(Flag: Boolean): Boolean;
  begin
    Result := False;
    if Config.boHumUseHP then begin
      if (GetTickCount - m_dwHumEatHPTick > Config.nHumHPTime) and (Flag or (HumHP < Config.nHumMinHP)) then begin
        nIndex := FindHumItemIndex(Config.nHumEatHPItem);
        if nIndex >= 0 then begin
          m_dwHumEatHPTick := GetTickCount;
          Result := AutoEatItem(nIndex);
        end;
      end;
    end;
  end;

  function EatHPItem1(Flag: Boolean): Boolean;
  begin
    if Config.boHumUseHP1 then begin
      if (GetTickCount - m_dwHumEatHPTick1 > Config.nHumHPTime1) and (Flag or (HumHP < Config.nHumMinHP1)) then begin
        nIndex := FindHumItemIndex(Config.nHumEatHPItem1);
        if nIndex >= 0 then begin
          m_dwHumEatHPTick1 := GetTickCount;
          Result := AutoEatItem(nIndex);
          //AddChatBoardString('TGameEngine.AutoEatHPItem EatHPItem1', c_White, c_Fuchsia);
        end;
      end;
    end;
  end;
begin
  if FCheckCode <> 0 then Exit;
  if GetEatIng and (m_MySelf <> nil) and (not m_MySelf.m_boDeath) and (HumHP > 0) then begin
    if Config.boHumUseHP and Config.boHumUseHP1 then begin
      if Config.nHumMinHP1 < Config.nHumMinHP then begin
        if (HumHP < Config.nHumMinHP1) then begin
          if not EatHPItem1(False) then
            if not EatHPItem(False) then
              {if not EatHPItem1(True) then
                if not EatHPItem(True) then }
        end else begin
          if not EatHPItem(False) then
            if not EatHPItem1(False) then
             { if not EatHPItem(True) then
                if not EatHPItem1(True) then   }
        end;
      end else begin
        if (HumHP < Config.nHumMinHP) then begin
          if not EatHPItem(False) then
            if not EatHPItem1(False) then
             { if not EatHPItem(True) then
                if not EatHPItem1(True) then    }
        end else begin
          if not EatHPItem1(False) then
            if not EatHPItem(False) then
              {if not EatHPItem1(True) then
                if not EatHPItem(True) then   }
        end;
      end;
    end else
      if Config.boHumUseHP and (not Config.boHumUseHP1) then begin
      EatHPItem(False);
    end else
      if (not Config.boHumUseHP) and Config.boHumUseHP1 then begin
      EatHPItem1(False);
    end;
  end;
end;

procedure TGameEngine.AutoEatMPItem(Sender: TObject);
var
  I: Integer;
  nIndex: Integer;
  function EatMPItem(Flag: Boolean): Boolean;
  begin
    Result := False;
    if Config.boHumUseMP then begin
      if (GetTickCount - m_dwHumEatMPTick > Config.nHumMPTime) and (Flag or (HumMP < Config.nHumMinMP)) then begin
        nIndex := FindHumItemIndex(Config.nHumEatMPItem);
        if nIndex >= 0 then begin
          m_dwHumEatMPTick := GetTickCount;
          Result := AutoEatItem(nIndex);
        end;
      end;
    end;
  end;

  function EatMPItem1(Flag: Boolean): Boolean;
  begin
    Result := False;
    if Config.boHumUseMP1 then begin
      if (GetTickCount - m_dwHumEatMPTick1 > Config.nHumMPTime1) and (Flag or (HumMP < Config.nHumMinMP1)) then begin
        nIndex := FindHumItemIndex(Config.nHumEatMPItem1);
        if nIndex >= 0 then begin
          m_dwHumEatMPTick1 := GetTickCount;
          Result := AutoEatItem(nIndex);
        end;
      end;
    end;
  end;

begin
  if FCheckCode <> 0 then Exit;
  if GetEatIng and (m_MySelf <> nil) and (not m_MySelf.m_boDeath) and (HumMP > 0) then begin
    if Config.boHumUseMP and Config.boHumUseMP1 then begin
      if Config.nHumMinMP1 < Config.nHumMinMP then begin
        if (HumMP < Config.nHumMinMP1) then begin
          if not EatMPItem1(False) then
            if not EatMPItem(False) then
              {if not EatMPItem1(True) then
                if not EatMPItem(True) then   }
        end else begin
          if not EatMPItem(False) then
            if not EatMPItem1(False) then
              {if not EatMPItem(True) then
                if not EatMPItem1(True) then }
        end;
      end else begin
        if (HumMP < Config.nHumMinMP) then begin
          if not EatMPItem(False) then
            if not EatMPItem1(False) then
              {if not EatMPItem(True) then
                if not EatMPItem1(True) then  }
        end else begin
          if not EatMPItem1(False) then
            if not EatMPItem(False) then
              {if not EatMPItem1(True) then
                if not EatMPItem(True) then }
        end;
      end;
    end else
      if Config.boHumUseMP and (not Config.boHumUseMP1) then begin
      EatMPItem(False);
    end else
      if (not Config.boHumUseMP) and Config.boHumUseMP1 then begin
      EatMPItem1(False);
    end;
  end;
end;

procedure TGameEngine.AutoHeroEatHPItem(Sender: TObject);
var
  nIndex: Integer;

  function EatHPItem(Flag: Boolean): Boolean;
  begin
    Result := False;
    if Config.boHeroUseHP then begin
      if (GetTickCount - m_dwHeroEatHPTick > Config.nHeroHPTime) and (Flag or (HeroHP < Config.nHeroMinHP)) then begin
        nIndex := FindHeroItemIndex(Config.nHeroEatHPItem);
        if nIndex >= 0 then begin
          m_dwHeroEatHPTick := GetTickCount;
          Result := AutoHeroEatItem(nIndex);
        end;
      end;
    end;
  end;

  function EatHPItem1(Flag: Boolean): Boolean;
  begin
    Result := False;
    if Config.boHeroUseHP1 then begin
      if (GetTickCount - m_dwHeroEatHPTick1 > Config.nHeroHPTime1) and (Flag or (HeroHP < Config.nHeroMinHP1)) then begin
        nIndex := FindHeroItemIndex(Config.nHeroEatHPItem1);
        if nIndex >= 0 then begin
          m_dwHeroEatHPTick1 := GetTickCount;
          Result := AutoHeroEatItem(nIndex);
        end;
      end;
    end;
  end;

begin
  if FCheckCode <> 0 then Exit;
  if GetHeroEatIng and (m_MyHero <> nil) and (not m_MyHero.m_boDeath) and (HeroHP > 0) then begin
    if Config.boHeroUseHP and Config.boHeroUseHP1 then begin
      if Config.nHeroMinHP1 < Config.nHeroMinHP then begin
        if (HeroHP < Config.nHeroMinHP1) then begin
          if not EatHPItem1(False) then
            if not EatHPItem(False) then
              {if not EatHPItem1(True) then
                if not EatHPItem(True) then }
        end else begin
          if not EatHPItem(False) then
            if not EatHPItem1(False) then
             { if not EatHPItem(True) then
                if not EatHPItem1(True) then }
        end;
      end else begin
        if (HeroHP < Config.nHeroMinHP) then begin
          if not EatHPItem(False) then
            if not EatHPItem1(False) then
              {if not EatHPItem(True) then
                if not EatHPItem1(True) then }
        end else begin
          if not EatHPItem1(False) then
            if not EatHPItem(False) then
              {if not EatHPItem1(True) then
                if not EatHPItem(True) then   }
        end;
      end;
    end else
      if Config.boHeroUseHP and (not Config.boHeroUseHP1) then begin
      EatHPItem(False);
    end else
      if (not Config.boHeroUseHP) and Config.boHeroUseHP1 then begin
      EatHPItem1(False);
    end;
  end;
end;

procedure TGameEngine.AutoHeroEatMPItem(Sender: TObject);
var
  nIndex: Integer;

  function EatMPItem(Flag: Boolean): Boolean;
  begin
    Result := False;
    if Config.boHeroUseMP then begin
      if (GetTickCount - m_dwHeroEatMPTick > Config.nHeroMPTime) and (Flag or (HeroMP < Config.nHeroMinMP)) then begin
        nIndex := FindHeroItemIndex(Config.nHeroEatMPItem);
        if nIndex >= 0 then begin
          m_dwHeroEatMPTick := GetTickCount;
          Result := AutoHeroEatItem(nIndex);
        end;
      end;
    end;
  end;

  function EatMPItem1(Flag: Boolean): Boolean;
  begin
    Result := False;
    if Config.boHeroUseMP1 then begin
      if (GetTickCount - m_dwHeroEatMPTick1 > Config.nHeroMPTime1) and (Flag or (HeroMP < Config.nHeroMinMP1)) then begin
        nIndex := FindHeroItemIndex(Config.nHeroEatMPItem1);
        if nIndex >= 0 then begin
          m_dwHeroEatMPTick1 := GetTickCount;
          Result := AutoHeroEatItem(nIndex);
        end;
      end;
    end;
  end;

begin
  if FCheckCode <> 0 then Exit;
  if GetHeroEatIng and (m_MyHero <> nil) and (not m_MyHero.m_boDeath) and (HeroMP > 0) then begin
    if Config.boHeroUseMP and Config.boHeroUseMP1 then begin
      if Config.nHeroMinMP1 < Config.nHeroMinMP then begin
        if (HeroMP < Config.nHeroMinMP1) then begin
          if not EatMPItem1(False) then
            if not EatMPItem(False) then
             { if not EatMPItem1(True) then
                if not EatMPItem(True) then  }
        end else begin
          if not EatMPItem(False) then
            if not EatMPItem1(False) then
            {  if not EatMPItem(True) then
                if not EatMPItem1(True) then   }
        end;
      end else begin
        if (HeroMP < Config.nHeroMinMP) then begin
          if not EatMPItem(False) then
            if not EatMPItem1(False) then
             { if not EatMPItem(True) then
                if not EatMPItem1(True) then  }
        end else begin
          if not EatMPItem1(False) then
            if not EatMPItem(False) then
           {   if not EatMPItem1(True) then
                if not EatMPItem(True) then   }
        end;
      end;
    end else
      if Config.boHeroUseMP and (not Config.boHeroUseMP1) then begin
      EatMPItem(False);
    end else
      if (not Config.boHeroUseMP) and Config.boHeroUseMP1 then begin
      EatMPItem1(False);
    end;
  end;
end;

procedure TGameEngine.UseFlyItem(Sender: TObject);
var
  nIndex: Integer;
  nHumHP: Integer;
begin
  if FCheckCode <> 0 then Exit;
  if GetEatIng and Config.boUseFlyItem and (m_MySelf <> nil) and (not m_MySelf.m_boDeath) then begin
    nHumHP := HumHP;
    if (nHumHP > 0) and (nHumHP <= Config.nUseflyItemMinHP) and (not m_boUseFlyItem) then begin
      case m_btVersion of
        0:
          for nIndex := Low(m_ItemArr_BLUE) to High(m_ItemArr_BLUE) do begin
            if m_ItemArr_BLUE[nIndex].s.Name <> '' then begin
              if (CompareText('随机传送卷', m_ItemArr_BLUE[nIndex].s.Name) = 0) or
                (CompareText('地牢传送卷', m_ItemArr_BLUE[nIndex].s.Name) = 0) or
                (CompareText('随机石', m_ItemArr_BLUE[nIndex].s.Name) = 0) or
                (CompareText('随机传送石', m_ItemArr_BLUE[nIndex].s.Name) = 0) then begin
                if AutoEatItem(nIndex) then begin
                  m_dwUseFlyItemTick := GetTickCount + 1000 * 60 * 3;
                  m_boUseFlyItem := True;
                  AddChatBoardString('血量过低，自动使用' + m_ItemArr_BLUE[nIndex].s.Name + '。', c_Yellow, c_Red);
                end;
                Break;
              end;
            end;
          end;
        1:
          for nIndex := Low(m_ItemArr_IGE) to High(m_ItemArr_IGE) do begin
            if m_ItemArr_IGE[nIndex].s.Name <> '' then begin
              if (CompareText('随机传送卷', m_ItemArr_IGE[nIndex].s.Name) = 0) or
                (CompareText('地牢传送卷', m_ItemArr_IGE[nIndex].s.Name) = 0) or
                (CompareText('随机石', m_ItemArr_IGE[nIndex].s.Name) = 0) or
                (CompareText('随机传送石', m_ItemArr_IGE[nIndex].s.Name) = 0) then begin
                if AutoEatItem(nIndex) then begin
                  m_dwUseFlyItemTick := GetTickCount + 1000 * 60 * 3;
                  m_boUseFlyItem := True;
                  AddChatBoardString('血量过低，自动使用' + m_ItemArr_IGE[nIndex].s.Name + '。', c_Yellow, c_Red);
                end;
                Break;
              end;
            end;
          end;
      end;
    end else begin
      if m_boUseFlyItem and (GetTickCount > m_dwUseFlyItemTick) then begin
        m_dwUseFlyItemTick := GetTickCount;
        m_boUseFlyItem := False;
      end;
    end;
  end;
end;

procedure TGameEngine.Return(Sender: TObject); //回城
var
  nIndex: Integer;
  nHumHP: Integer;
begin
  if FCheckCode <> 0 then Exit;
  if GetEatIng and Config.boUseReturnItem and (m_MySelf <> nil) and (not m_MySelf.m_boDeath) then begin
    nHumHP := HumHP;
    if (nHumHP > 0) and (nHumHP <= Config.nUseReturnItemMinHP) and (not m_boUseReturnItem) then begin
      case m_btVersion of
        0:
          for nIndex := Low(m_ItemArr_BLUE) to High(m_ItemArr_BLUE) do begin
            if m_ItemArr_BLUE[nIndex].s.Name <> '' then begin
              if (CompareText('回城卷', m_ItemArr_BLUE[nIndex].s.Name) = 0) or
                (CompareText('盟重传送石', m_ItemArr_BLUE[nIndex].s.Name) = 0) or
                (CompareText('回城石', m_ItemArr_BLUE[nIndex].s.Name) = 0) then begin
                if AutoEatItem(nIndex) then begin
                  m_dwUseReturnItemTick := GetTickCount + 1000 * 30;
                  m_boUseReturnItem := True;
                  AddChatBoardString('血量过低，自动使用' + m_ItemArr_BLUE[nIndex].s.Name + '。', c_Yellow, c_Red);
                end;
                Break;
              end;
            end;
          end;
        1:
          for nIndex := Low(m_ItemArr_IGE) to High(m_ItemArr_IGE) do begin
            if m_ItemArr_IGE[nIndex].s.Name <> '' then begin
              if (CompareText('回城卷', m_ItemArr_IGE[nIndex].s.Name) = 0) or
                (CompareText('盟重传送石', m_ItemArr_IGE[nIndex].s.Name) = 0) or
                (CompareText('回城石', m_ItemArr_IGE[nIndex].s.Name) = 0) then begin
                if AutoEatItem(nIndex) then begin
                  m_dwUseReturnItemTick := GetTickCount + 1000 * 30;
                  m_boUseReturnItem := True;
                  AddChatBoardString('血量过低，自动使用' + m_ItemArr_IGE[nIndex].s.Name + '！', c_Yellow, c_Red);
                end;
                Break;
              end;
            end;
          end;
      end;
    end else begin
      if m_boUseReturnItem and (GetTickCount > m_dwUseReturnItemTick) then begin
        m_dwUseReturnItemTick := GetTickCount;
        m_boUseReturnItem := False;
      end;
    end;
  end;
end;

procedure TGameEngine.AutoRecallBackHero; //召回英雄
var
  Msg: TDefaultMessage;
  Msg_IGE: TDefaultMessage_IGE;
begin
  if FCheckCode <> 0 then Exit;
  if Config.boHeroTakeback and (m_MyHero <> nil) and (not m_MyHero.m_boDeath) then begin
    if (HeroHP > 0) and (HeroHP <= Config.nTakeBackHeroMinHP) and (not m_boRecallBackHero) then begin
      m_dwHintRecallBackHero := GetTickCount;
      AddChatBoardString('英雄血量过低,自动召回。', c_Yellow, c_Red);
      case m_btVersion of
        0: begin
              //SendOutStr('GetTickCount1:' + IntToStr(GetTickCount) + ' TGameEngine.AutoRecallBackHero:' + IntToStr(m_dwRecallBackHero));
            m_dwRecallBackHero := GetTickCount + 1000 * 30;
              //SendOutStr('GetTickCount2:' + IntToStr(GetTickCount) + ' TGameEngine.AutoRecallBackHero:' + IntToStr(m_dwRecallBackHero));
            Msg := MakeDefaultMsg(BLUE_SEND_1051, m_MyHero.m_nRecogId, 0, 0, 0);
            GameSocket.SendSocket(EncodeMessage(Msg));
            //m_MyHero := nil;
            m_boRecallBackHero := True;
          end;
        1: begin
            if (m_MySelf <> nil) then begin
              m_dwRecallBackHero := GetTickCount + 1000 * 30;
              Msg_IGE := MakeDefaultMsg_IGE(CM_IGE_5002, m_MySelf.m_nRecogId, 0, 0, 0);
              GameSocket.SendSocket(EncodeMessage_IGE(Msg_IGE));
              //m_MyHero := nil;
              m_boRecallBackHero := True;
            end;
          end;
      end;
    end else begin
      if m_boRecallBackHero then begin
        if (GetTickCount > m_dwRecallBackHero) then begin
        //SendOutStr('GetTickCount:' + IntToStr(GetTickCount) + ' TGameEngine.AutoRecallBackHero:' + IntToStr(m_dwRecallBackHero));
          m_dwRecallBackHero := GetTickCount;
          m_boRecallBackHero := False;
        end else begin
          if (m_MyHero <> nil) and (not m_MyHero.m_boDeath) and (HeroHP > 0) and (HeroHP <= Config.nTakeBackHeroMinHP) and (GetTickCount - m_dwHintRecallBackHero > 1000 * 5) then begin
            m_dwHintRecallBackHero := GetTickCount;
            AddChatBoardString('英雄血量过低 [' + IntToStr((m_dwRecallBackHero - GetTickCount) div 1000) + '] 秒后，自动召回。', c_Yellow, c_Red);
          end;
        end; //SendOutStr('GetTickCount1:' + IntToStr(GetTickCount) + ' TGameEngine.AutoRecallBackHero:' + IntToStr(m_dwRecallBackHero));
      end;
    end;
  end;
end;

procedure TGameEngine.RecallHero; //召回英雄
var
  Msg: TDefaultMessage;
  Msg_IGE: TDefaultMessage_IGE;
begin
  if FCheckCode <> 0 then Exit;
  if (m_MySelf = nil) { or (m_MyHero = nil)} then Exit;
  case m_btVersion of
    0: begin
        if (m_MyHero = nil) then begin
          Msg := MakeDefaultMsg(BLUE_SEND_1050, m_MySelf.m_nRecogId, 0, 0, 0);
        end else begin
          Msg := MakeDefaultMsg(BLUE_SEND_1051, m_MyHero.m_nRecogId, 0, 0, 0);
        end;
        GameSocket.SendSocket(EncodeMessage(Msg));
      end;
    1: begin
        if (m_MyHero = nil) then begin
          Msg_IGE := MakeDefaultMsg_IGE(CM_IGE_5000, 0, 0, 0, 0);
          //AddChatBoardString('英雄血量过低 [' + IntToStr((m_dwRecallBackHero - GetTickCount) div 1000) + '] 秒后，自动召回。', c_Yellow, c_Red);
        end else begin
          Msg_IGE := MakeDefaultMsg_IGE(CM_IGE_5002, 0, 0, 0, 0);
        end;
        GameSocket.SendSocket(EncodeMessage_IGE(Msg_IGE));
      end;
  end;
end;

procedure TGameEngine.ChangeHeroState; //改变英雄状态
var
  Msg: TDefaultMessage;
  Msg_IGE: TDefaultMessage_IGE;
begin
  if FCheckCode <> 0 then Exit;
  if (m_MyHero <> nil) and (not m_MyHero.m_boDeath) then begin
    case m_btVersion of
      0: begin
          Msg := MakeDefaultMsg(CM_SAY, 0, 0, 0, 0);
          GameSocket.SendSocket(EncodeMessage(Msg) + EncodeString('@RestHero'));
        end;
      1: begin
          Msg_IGE := MakeDefaultMsg_IGE(CM_IGE_5006, 0, 0, 0, 0);
          GameSocket.SendSocket(EncodeMessage_IGE(Msg_IGE));
        end;
    end;
  end;
end;

procedure TGameEngine.QueryHumBagItems; //查询包裹
//var
  //Msg: TDefaultMessage;
begin
  //Showmessage('TGameEngine.QueryHumBagItems1');
  if FCheckCode <> 0 then Exit;
  //Showmessage('TGameEngine.QueryHumBagItems2');
  if (m_MySelf <> nil) and (not m_MySelf.m_boDeath) then begin
    //Showmessage('TGameEngine.QueryHumBagItems3');
    //Msg := MakeDefaultMsg(CM_QUERYBAGITEMS, 0, 0, 0, 0);
    //GameSocket.SendSocket(EncodeMessage(Msg));
    GameSocket.SendClientMessage(CM_QUERYBAGITEMS, 0, 0, 0, 0);
  end;
end;


//发送虚拟按键

procedure TGameEngine.SendKeyEvent(Key1, Key2: Byte);
//var k, x: integer;
begin
  if FCheckCode <> 0 then Exit;
  {
  keybd_event(VK_MENU, 0, 0, 0);
  keybd_event(Ord('S'), 0, 0, 0);
  keybd_event(Ord('S'), 0, KEYEVENTF_KEYUP, 0);
  keybd_event(VK_MENU, 0, KEYEVENTF_KEYUP, 0);
  }

  keybd_event(Key1, MapVirtualKey(Key1, 0), 0, 0); //Control key down
  //keybd_event(VK_MENU, MapVirtualKey(VK_MENU, 0), KEYEVENTF_EXTENDEDKEY, 0); // Alt down
  keybd_event(Key2, MapVirtualKey(Key2, 0), KEYEVENTF_EXTENDEDKEY, 0); // down arrow key down
  keybd_event(Key1, MapVirtualKey(Key1, 0), KEYEVENTF_KEYUP, 0); //Control arrow key up
  //keybd_event(VK_MENU, MapVirtualKey(VK_MENU, 0), KEYEVENTF_KEYUP, 0); //Alt key up
  keybd_event(Key2, MapVirtualKey(Key2, 0), KEYEVENTF_KEYUP, 0); //Down key up

  {keybd_event(Key, MapVirtualKey(Key, 0), 0, 0);
  Sleep(10);
  keybd_event(Key, MapVirtualKey(Key, 0), KEYEVENTF_KEYUP, 0);}
end;

procedure TGameEngine.SendKeyEvent(Key: Byte);
begin
  if FCheckCode <> 0 then Exit;
  keybd_event(Key, MapVirtualKey(Key, 0), KEYEVENTF_EXTENDEDKEY, 0); // down arrow key down
  keybd_event(Key, MapVirtualKey(Key, 0), KEYEVENTF_KEYUP, 0); //Down key up
end;

procedure TGameEngine.KeyDown(MainHwnd: Hwnd; Key: Word);
  function IsMainHwnd(MainHwnd: Hwnd): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := 0 to 10 do begin
      //if FormData.MainHwnd[I] > 0 then SendOutStr('FormData.MainHwnd[I]:' + IntToStr(I) + ':' + IntToStr(FormData.MainHwnd[I]));
      if (g_DataEngine.Data.MainHwnd[I] = MainHwnd) then begin
        Result := True;
        Break;
      end;
    end;
  end;

  function GetMainHwnd(sTitle: string): Hwnd;
  var
    I: Integer;
  begin
    Result := 0;
    for I := 0 to 10 do begin
      //if FormData.MainHwnd[I] > 0 then SendOutStr('FormData.MainHwnd[I]:' + IntToStr(I) + ':' + IntToStr(FormData.MainHwnd[I]));
      if CompareText(g_DataEngine.Data.Title[I], sTitle) = 0 then begin
        Result := g_DataEngine.Data.MainHwnd[I];
        Break;
      end;
    end;
  end;
var
  IsMirHwnd: Boolean;

begin
  if FCheckCode <> 0 then Exit;
  if GetTickCount - m_dwKeyDownTick < 200 then Exit;
  m_dwKeyDownTick := GetTickCount;
  Config.nShowOptionKey := g_DataEngine.Data.ShowOptionIndex;
  if (Config.nShowOptionKey > 0) and (Config.nShowOptionKey - 1 <= Length(KeyValue) - 1) and (KeyValue[Config.nShowOptionKey - 1] = Key) then begin
    IsMirHwnd := IsMainHwnd(MainHwnd);
    if m_boUserLogin then begin
      if IsMirHwnd then begin
        if frmOption = nil then begin
          frmOption := TfrmOption.Create(nil);
          frmOption.ParentWindow := MainHwnd;
          frmOption.Left := 5;
          frmOption.Top := 5;
        end;
      end;
      //if GetTickCount - GameEngine.m_dwOpenFormTick > 500 then begin
      if frmOption <> nil then begin
        if frmOption.Visible then begin
          if (frmOption.MainHwnd = MainHwnd) or IsMirHwnd then begin
              //GameEngine.m_dwOpenFormTick := GetTickCount;
            frmOption.Visible := False;
          end;
        end else begin
          if IsMirHwnd then begin
              //GameEngine.m_dwOpenFormTick := GetTickCount;
            frmOption.Visible := True;
          end;
        end;
      end;
      //end;
    end;
    //Exit;
  end;

  if Config.boCreateGroupKey then begin
    if (Config.nCreateGroupKey > 0) and (Config.nCreateGroupKey - 1 <= Length(KeyValue) - 1) then begin
      if KeyValue[Config.nCreateGroupKey - 1] = Key then begin
        case m_btVersion of
          0: SendKeyEvent(VK_MENU, Ord('W'));
          1: SendKeyEvent(VK_Control, Ord('G'));
        end;
      end;
    end;
  end;

  if Config.boRecallHeroKey then begin
    if (Config.nRecallHeroKey > 0) and (Config.nRecallHeroKey - 1 <= Length(KeyValue) - 1) then begin
      if KeyValue[Config.nRecallHeroKey - 1] = Key then begin
        RecallHero;
        //SendOutStr('RecallHero');
      end;
    end;
  end;
  if Config.boHeroGroupKey then begin
    if (Config.nHeroGroupKey > 0) and (Config.nHeroGroupKey - 1 <= Length(KeyValue) - 1) then begin
      if KeyValue[Config.nHeroGroupKey - 1] = Key then begin
        SendKeyEvent(VK_Control, Ord('S'));
      end;
    end;
  end;
  if Config.boHeroTargetKey then begin
    if (Config.nHeroTargetKey > 0) and (Config.nHeroTargetKey - 1 <= Length(KeyValue) - 1) then begin
      if KeyValue[Config.nHeroTargetKey - 1] = Key then begin
        SendKeyEvent(VK_Control, Ord('W'));
      end;
    end;
  end;
  if Config.boHeroGuardKey then begin
    if (Config.nHeroGuardKey > 0) and (Config.nHeroGuardKey - 1 <= Length(KeyValue) - 1) then begin
      if KeyValue[Config.nHeroGuardKey - 1] = Key then begin
        SendKeyEvent(VK_Control, Ord('Q'));
      end;
    end;
  end;
  if Config.boHeroStateKey then begin
    if (Config.nHeroStateKey > 0) and (Config.nHeroStateKey - 1 <= Length(KeyValue) - 1) then begin
      if KeyValue[Config.nHeroStateKey - 1] = Key then begin
        SendKeyEvent(VK_Control, Ord('E'));
      end;
    end;
  end;
  if Config.boHumStateKey then begin
    if (Config.nHumStateKey > 0) and (Config.nHumStateKey - 1 <= Length(KeyValue) - 1) then begin
      if KeyValue[Config.nHumStateKey - 1] = Key then begin
        SendKeyEvent(VK_Control, Ord('H'));
      end;
    end;
  end;
  if Config.boGetHumBagItems then begin
    if (Config.nGetHumBagItems > 0) and (Config.nGetHumBagItems - 1 <= Length(KeyValue) - 1) then begin
      if KeyValue[Config.nGetHumBagItems - 1] = Key then begin
        GameEngine.AddChatBoardString('开始刷新包裹...', c_White, c_Fuchsia);
        m_dwQueryHumBagItems := GetTickCount;
        m_boQueryHumBagItems := True;
        QueryHumBagItems;
        //SendKeyEvent(VK_Control, Ord('H'));
      end;
    end;
  end;

  if Config.boMagicLock then begin //魔法锁定
    m_MagicLock := GetMagicByKey(Char((Key - VK_F1) + Byte('1')));
    //SendOutStr('Config.boMagicLock');
    if (m_MagicLock <> nil) and (not GetMagicLock(m_MagicLock.Def.sMagicName)) then
      m_MagicLock := nil;
  end else m_MagicLock := nil;
end;

procedure TGameEngine.LoadShowItemList;
begin
  m_ShowItemList.LoadList(CreateUserDirectory + 'ItemList.dat');
end;

procedure TGameEngine.LoadShowBossList;
begin
  m_ShowBossList.LoadList(CreateUserDirectory + 'BossList.dat');
end;

procedure TGameEngine.SaveShowItemList;
begin
  m_ShowItemList.SaveToFile;
end;

procedure TGameEngine.SaveShowBossList;
begin
  m_ShowBossList.SaveToFile;
end;

procedure TGameEngine.LoadConfig(sUserName: string);
var
  ConInI: TIniFile;
  sFileName: string;
  sClasses: string;
  sUserDirectory: string;
begin
  if (m_MySelf <> nil) {and (m_sServerName <> '') } then begin
    sUserDirectory := CreateUserDirectory;
    LoadBindItemList;
    LoadShowItemList;
    LoadShowBossList;
    try
      if FileExists(sUserDirectory + 'MapFilterList.txt') then begin
        m_MapFilterList.LoadFromFile(sUserDirectory + 'MapFilterList.txt');
      end;
    except

    end;
    try
      if FileExists(sUserDirectory + 'SayMsgList.txt') then begin
        m_SayMsgList.LoadFromFile(sUserDirectory + 'SayMsgList.txt');
      end;
    except

    end;
    try
      if FileExists(sUserDirectory + 'ItemFilterList.txt') then begin
        m_ItemFilterList.LoadFromFile(sUserDirectory + 'ItemFilterList.txt');
      end else begin
        m_ItemFilterList.Add('鹿肉');
        m_ItemFilterList.Add('铁剑');
        m_ItemFilterList.Add('火把');
        m_ItemFilterList.Add('干肉');
        m_ItemFilterList.Add('凝霜');
        m_ItemFilterList.Add('青铜斧');
        m_ItemFilterList.Add('匕首');
        m_ItemFilterList.Add('井中月');
        m_ItemFilterList.Add('银蛇');
        m_ItemFilterList.Add('海魂');
        m_ItemFilterList.Add('修罗');
        m_ItemFilterList.Add('炼狱');
        m_ItemFilterList.Add('凌风');
        m_ItemFilterList.Add('破魂');
        m_ItemFilterList.Add('斩马刀');
        m_ItemFilterList.Add('食人树叶');
        m_ItemFilterList.Add('毒蜘蛛牙齿');
        m_ItemFilterList.Add('食人树果实');
        m_ItemFilterList.Add('蛆卵');
        m_ItemFilterList.Add('灰色药粉(少量)');
        m_ItemFilterList.Add('黄色药粉(少量)');
        m_ItemFilterList.Add('古铜戒指');
        m_ItemFilterList.Add('青铜头盔');
        m_ItemFilterList.Add('金项链');
        m_ItemFilterList.Add('铁手镯');
        m_ItemFilterList.Add('乌木剑');
        m_ItemFilterList.Add('八荒');
        m_ItemFilterList.Add('鸡肉');
        m_ItemFilterList.Add('玻璃戒指');
        m_ItemFilterList.Add('牛角戒指');
        m_ItemFilterList.Add('蓝色水晶戒指');
        m_ItemFilterList.Add('六角戒指');
        m_ItemFilterList.Add('黑檀项链');
        m_ItemFilterList.Add('黑色水晶项链');
        m_ItemFilterList.Add('魔法头盔');
        m_ItemFilterList.Add('皮制手套');
        m_ItemFilterList.Add('坚固手套');
        m_ItemFilterList.Add('钢手镯');
        m_ItemFilterList.Add('生铁戒指');
        m_ItemFilterList.Add('金戒指');
        m_ItemFilterList.Add('灯笼项链');
        m_ItemFilterList.Add('白色虎齿项链');
        m_ItemFilterList.Add('魅力戒指');
        m_ItemFilterList.Add('道德戒指');
        m_ItemFilterList.Add('白金项链');
        m_ItemFilterList.Add('降妖除魔戒指');
        m_ItemFilterList.Add('躲避手链');
        m_ItemFilterList.Add('祈福项链');
        m_ItemFilterList.Add('传统项链');
        m_ItemFilterList.Add('小手镯');
        m_ItemFilterList.Add('银手镯');
        m_ItemFilterList.Add('大手镯');
        m_ItemFilterList.Add('鹤嘴锄');
        m_ItemFilterList.Add('金创药');
        m_ItemFilterList.Add('魔法药(中量)');
        m_ItemFilterList.Add('黑色水晶戒指');
        m_ItemFilterList.Add('魔鬼项链');
        m_ItemFilterList.Add('珊瑚戒指');
        m_ItemFilterList.Add('蓝翡翠项链');
        m_ItemFilterList.Add('蛇眼戒指');
        m_ItemFilterList.Add('琥珀项链');
        m_ItemFilterList.SaveToFile(sUserDirectory + 'ItemFilterList.txt');
      end;
    except

    end;

    try
      if FileExists(sUserDirectory + 'MagicLockList.txt') then begin
        m_MagicLockList.LoadFromFile(sUserDirectory + 'MagicLockList.txt');
      end else begin
        m_MagicLockList.Add('火球术');
        m_MagicLockList.Add('大火球');
        m_MagicLockList.Add('施毒术');
        m_MagicLockList.Add('雷电术');
        m_MagicLockList.Add('灵魂火符');
        m_MagicLockList.Add('爆裂火焰');
        m_MagicLockList.Add('冰咆哮');
        m_MagicLockList.Add('群体雷电术');
        m_MagicLockList.Add('群体施毒术');
        m_MagicLockList.Add('彻地钉');
        m_MagicLockList.Add('灭天火');
        m_MagicLockList.SaveToFile(sUserDirectory + 'MagicLockList.txt');
      end;
    except

    end;

    //sFileName := 'Config\' + m_sServerName + '.' + m_MySelf.m_sUserName + '.INI';
    sFileName := sUserDirectory + 'Config.INI';
    sClasses := 'Hum';

    ConInI := TIniFile.Create(sFileName);

    //Config.nShowOptionKey := ConInI.ReadInteger(sClasses, 'ShowOptionKey', 63);

    Config.boHumUseHP := ConInI.ReadBool(sClasses, 'GetUseHP', False);
    Config.boHumUseMP := ConInI.ReadBool(sClasses, 'GetUseMP', False);
    Config.nHumMinHP := ConInI.ReadInteger(sClasses, 'MinHP', 0);
    Config.nHumMinMP := ConInI.ReadInteger(sClasses, 'MinMP', 0);
    Config.nHumHPTime := ConInI.ReadInteger(sClasses, 'UseHPTime', 1000);
    Config.nHumMPTime := ConInI.ReadInteger(sClasses, 'UseMPTime', 1000);

    Config.boHumUseHP1 := ConInI.ReadBool(sClasses, 'GetUseHP1', False);
    Config.boHumUseMP1 := ConInI.ReadBool(sClasses, 'GetUseMP1', False);
    Config.nHumMinHP1 := ConInI.ReadInteger(sClasses, 'MinHP1', 0);
    Config.nHumMinMP1 := ConInI.ReadInteger(sClasses, 'MinMP1', 0);
    Config.nHumHPTime1 := ConInI.ReadInteger(sClasses, 'UseHPTime1', 1000);
    Config.nHumMPTime1 := ConInI.ReadInteger(sClasses, 'UseMPTime1', 1000);

    Config.nHumEatHPItem := ConInI.ReadInteger(sClasses, 'EatHPItem', 2);
    Config.nHumEatMPItem := ConInI.ReadInteger(sClasses, 'EatMPItem', 3);
    Config.nHumEatHPItem1 := ConInI.ReadInteger(sClasses, 'EatHPItem1', 4);
    Config.nHumEatMPItem1 := ConInI.ReadInteger(sClasses, 'EatMPItem1', 5);


    Config.boUseFlyItem := ConInI.ReadBool(sClasses, 'GetUseFlyItem', False);
    Config.boUseReturnItem := ConInI.ReadBool(sClasses, 'GetUseReturnItem', False);

    Config.nUseflyItemMinHP := ConInI.ReadInteger(sClasses, 'UseflyItemMinHP', 0);
    Config.nUseReturnItemMinHP := ConInI.ReadInteger(sClasses, 'UseReturnItemMinMP', 0);


    Config.nCreateGroupKey := ConInI.ReadInteger(sClasses, 'CreateGroupKey', 0);
    Config.boCreateGroupKey := ConInI.ReadBool(sClasses, 'GetCreateGroupKey', False);

    Config.boHumStateKey := ConInI.ReadBool(sClasses, 'GetHumStateKey', False);
    Config.nHumStateKey := ConInI.ReadInteger(sClasses, 'HumStateKey', 0);

    Config.boGetHumBagItems := ConInI.ReadBool(sClasses, 'GetHumGetBagItems', False);
    Config.nGetHumBagItems := ConInI.ReadInteger(sClasses, 'HumGetBagItems', 0);


    Config.sMoveCmd := ConInI.ReadString(sClasses, 'MoveCmd', '@Move');
    Config.dwMoveTime := ConInI.ReadInteger(sClasses, 'MoveTime', 5);


    Config.boHeroStateChange := ConInI.ReadBool(sClasses, 'GetHeroStateChange', False);
    Config.nHeroStateChangeIndex := ConInI.ReadInteger(sClasses, 'HeroStateChangeIndex', 0);

    Config.boAutoQueryBagItem := ConInI.ReadBool(sClasses, 'GetAutoQueryBagItem', False);
    Config.nAutoQueryBagItemTime := ConInI.ReadInteger(sClasses, 'AutoQueryBagItemTime', 1);

    Config.boFastEatItem := ConInI.ReadBool(sClasses, 'GetFastEatItem', False);
    Config.boFilterShowItem := ConInI.ReadBool(sClasses, 'GetFilterShowItem', False);
    Config.boMagicLock := ConInI.ReadBool(sClasses, 'GetMagicLock', False);


    Config.boAutoUseItem := ConInI.ReadBool(sClasses, 'GetAutoUseItem', False);
    Config.sAutoUseItem := ConInI.ReadString(sClasses, 'AutoUseItemName', '');
    Config.nAutoUseItem := ConInI.ReadInteger(sClasses, 'AutoUseItemTime', 0);

    sClasses := 'Hero';
    Config.boHeroUseHP := ConInI.ReadBool(sClasses, 'GetUseHP', False);
    Config.boHeroUseMP := ConInI.ReadBool(sClasses, 'GetUseMP', False);
    Config.nHeroMinHP := ConInI.ReadInteger(sClasses, 'MinHP', 0);
    Config.nHeroMinMP := ConInI.ReadInteger(sClasses, 'MinMP', 0);
    Config.nHeroHPTime := ConInI.ReadInteger(sClasses, 'UseHPTime', 1000);
    Config.nHeroMPTime := ConInI.ReadInteger(sClasses, 'UseMPTime', 1000);

    Config.boHeroUseHP1 := ConInI.ReadBool(sClasses, 'GetUseHP1', False);
    Config.boHeroUseMP1 := ConInI.ReadBool(sClasses, 'GetUseMP1', False);
    Config.nHeroMinHP1 := ConInI.ReadInteger(sClasses, 'MinHP1', 0);
    Config.nHeroMinMP1 := ConInI.ReadInteger(sClasses, 'MinMP1', 0);
    Config.nHeroHPTime1 := ConInI.ReadInteger(sClasses, 'UseHPTime1', 1000);
    Config.nHeroMPTime1 := ConInI.ReadInteger(sClasses, 'UseMPTime1', 1000);


    Config.nHeroEatHPItem := ConInI.ReadInteger(sClasses, 'EatHPItem', 2);
    Config.nHeroEatMPItem := ConInI.ReadInteger(sClasses, 'EatMPItem', 3);
    Config.nHeroEatHPItem1 := ConInI.ReadInteger(sClasses, 'EatHPItem1', 4);
    Config.nHeroEatMPItem1 := ConInI.ReadInteger(sClasses, 'EatMPItem1', 5);


    Config.boHeroTakeback := ConInI.ReadBool(sClasses, 'GetTakeback', False);
    Config.nTakeBackHeroMinHP := ConInI.ReadInteger(sClasses, 'TakebackMinHP', 0);

    Config.boRecallHeroKey := ConInI.ReadBool(sClasses, 'GetRecallHeroKey', False);
    Config.boHeroGroupKey := ConInI.ReadBool(sClasses, 'GetHeroGroupKey', False);
    Config.boHeroTargetKey := ConInI.ReadBool(sClasses, 'GetHeroTargetKey', False);
    Config.boHeroGuardKey := ConInI.ReadBool(sClasses, 'GetHeroGuardKe', False);
    Config.boHeroStateKey := ConInI.ReadBool(sClasses, 'GetHeroStateKey', False);


    Config.nRecallHeroKey := ConInI.ReadInteger(sClasses, 'RecallHeroKey', 0);
    Config.nHeroGroupKey := ConInI.ReadInteger(sClasses, 'HeroGroupKey', 0);
    Config.nHeroTargetKey := ConInI.ReadInteger(sClasses, 'HeroTargetKey', 0);
    Config.nHeroGuardKey := ConInI.ReadInteger(sClasses, 'HeroGuardKey', 0);
    Config.nHeroStateKey := ConInI.ReadInteger(sClasses, 'HeroStateKey', 0);
    ConInI.Free;
  end;
end;

procedure TGameEngine.SaveConfig(sUserName: string);
var
  ConInI: TIniFile;
  sFileName: string;
  sClasses: string;
  sUserDirectory: string;
begin
  if (m_MySelf <> nil) {and (m_sServerName <> '')} then begin
    sUserDirectory := CreateUserDirectory;
    try
      m_MapFilterList.SaveToFile(sUserDirectory + 'MapFilterList.txt');
    except

    end;
    try
      m_SayMsgList.SaveToFile(sUserDirectory + 'SayMsgList.txt');
    except

    end;
    try
      m_ItemFilterList.SaveToFile(sUserDirectory + 'ItemFilterList.txt');
    except

    end;
    try
      m_MagicLockList.SaveToFile(sUserDirectory + 'MagicLockList.txt');
    except

    end;

    //sFileName := 'Config\' + m_sServerName + '.' + m_MySelf.m_sUserName + '.INI';
    sFileName := sUserDirectory + 'Config.INI';
    ConInI := TIniFile.Create(sFileName);
    sClasses := 'Hum';
    //ConInI.WriteInteger(sClasses, 'ShowOptionKey', Config.nShowOptionKey);

    ConInI.WriteBool(sClasses, 'GetUseHP', Config.boHumUseHP);
    ConInI.WriteBool(sClasses, 'GetUseMP', Config.boHumUseMP);
    ConInI.WriteInteger(sClasses, 'MinHP', Config.nHumMinHP);
    ConInI.WriteInteger(sClasses, 'MinMP', Config.nHumMinMP);
    ConInI.WriteInteger(sClasses, 'UseHPTime', Config.nHumHPTime);
    ConInI.WriteInteger(sClasses, 'UseMPTime', Config.nHumMPTime);

    ConInI.WriteBool(sClasses, 'GetUseHP1', Config.boHumUseHP1);
    ConInI.WriteBool(sClasses, 'GetUseMP1', Config.boHumUseMP1);
    ConInI.WriteInteger(sClasses, 'MinHP1', Config.nHumMinHP1);
    ConInI.WriteInteger(sClasses, 'MinMP1', Config.nHumMinMP1);
    ConInI.WriteInteger(sClasses, 'UseHPTime1', Config.nHumHPTime1);
    ConInI.WriteInteger(sClasses, 'UseMPTime1', Config.nHumMPTime1);

    ConInI.WriteInteger(sClasses, 'EatHPItem', Config.nHumEatHPItem);
    ConInI.WriteInteger(sClasses, 'EatMPItem', Config.nHumEatMPItem);
    ConInI.WriteInteger(sClasses, 'EatHPItem1', Config.nHumEatHPItem1);
    ConInI.WriteInteger(sClasses, 'EatMPItem1', Config.nHumEatMPItem1);

    ConInI.WriteBool(sClasses, 'GetUseFlyItem', Config.boUseFlyItem);
    ConInI.WriteBool(sClasses, 'GetUseReturnItem', Config.boUseReturnItem);

    ConInI.WriteInteger(sClasses, 'UseflyItemMinHP', Config.nUseflyItemMinHP);
    ConInI.WriteInteger(sClasses, 'UseReturnItemMinMP', Config.nUseReturnItemMinHP);

    ConInI.WriteBool(sClasses, 'GetHumStateKey', Config.boHumStateKey);
    ConInI.WriteInteger(sClasses, 'HumStateKey', Config.nHumStateKey);

    ConInI.WriteBool(sClasses, 'GetHumGetBagItems', Config.boGetHumBagItems);
    ConInI.WriteInteger(sClasses, 'HumGetBagItems', Config.nGetHumBagItems);

    ConInI.WriteBool(sClasses, 'GetCreateGroupKey', Config.boCreateGroupKey);
    ConInI.WriteInteger(sClasses, 'CreateGroupKey', Config.nCreateGroupKey);

    ConInI.Writestring(sClasses, 'MoveCmd', Config.sMoveCmd);
    ConInI.WriteInteger(sClasses, 'MoveTime', Config.dwMoveTime);

    ConInI.WriteBool(sClasses, 'GetHeroStateChange', Config.boHeroStateChange);
    ConInI.WriteInteger(sClasses, 'HeroStateChangeIndex', Config.nHeroStateChangeIndex);

    ConInI.WriteBool(sClasses, 'GetAutoQueryBagItem', Config.boAutoQueryBagItem);
    ConInI.WriteInteger(sClasses, 'AutoQueryBagItemTime', Config.nAutoQueryBagItemTime);
    ConInI.WriteBool(sClasses, 'GetFastEatItem', Config.boFastEatItem);
    ConInI.WriteBool(sClasses, 'GetFilterShowItem', Config.boFilterShowItem);
    ConInI.WriteBool(sClasses, 'GetMagicLock', Config.boMagicLock);

    ConInI.WriteBool(sClasses, 'GetAutoUseItem', Config.boAutoUseItem);
    ConInI.WriteString(sClasses, 'AutoUseItemName', Config.sAutoUseItem);
    ConInI.WriteInteger(sClasses, 'AutoUseItemTime', Config.nAutoUseItem);



    sClasses := 'Hero';
    ConInI.WriteBool(sClasses, 'GetUseHP', Config.boHeroUseHP);
    ConInI.WriteBool(sClasses, 'GetUseMP', Config.boHeroUseMP);
    ConInI.WriteInteger(sClasses, 'MinHP', Config.nHeroMinHP);
    ConInI.WriteInteger(sClasses, 'MinMP', Config.nHeroMinMP);
    ConInI.WriteInteger(sClasses, 'UseHPTime', Config.nHeroHPTime);
    ConInI.WriteInteger(sClasses, 'UseMPTime', Config.nHeroMPTime);

    ConInI.WriteBool(sClasses, 'GetUseHP1', Config.boHeroUseHP1);
    ConInI.WriteBool(sClasses, 'GetUseMP1', Config.boHeroUseMP1);
    ConInI.WriteInteger(sClasses, 'MinHP1', Config.nHeroMinHP1);
    ConInI.WriteInteger(sClasses, 'MinMP1', Config.nHeroMinMP1);
    ConInI.WriteInteger(sClasses, 'UseHPTime1', Config.nHeroHPTime1);
    ConInI.WriteInteger(sClasses, 'UseMPTime1', Config.nHeroMPTime1);


    ConInI.WriteInteger(sClasses, 'EatHPItem', Config.nHeroEatHPItem);
    ConInI.WriteInteger(sClasses, 'EatMPItem', Config.nHeroEatMPItem);
    ConInI.WriteInteger(sClasses, 'EatHPItem1', Config.nHeroEatHPItem1);
    ConInI.WriteInteger(sClasses, 'EatMPItem1', Config.nHeroEatMPItem1);


    ConInI.WriteBool(sClasses, 'GetTakeback', Config.boHeroTakeback);
    ConInI.WriteInteger(sClasses, 'TakebackMinHP', Config.nTakeBackHeroMinHP);

    ConInI.WriteBool(sClasses, 'GetRecallHeroKey', Config.boRecallHeroKey);
    ConInI.WriteBool(sClasses, 'GetHeroGroupKey', Config.boHeroGroupKey);
    ConInI.WriteBool(sClasses, 'GetHeroTargetKey', Config.boHeroTargetKey);
    ConInI.WriteBool(sClasses, 'GetHeroGuardKe', Config.boHeroGuardKey);
    ConInI.WriteBool(sClasses, 'GetHeroStateKey', Config.boHeroStateKey);

    ConInI.WriteInteger(sClasses, 'RecallHeroKey', Config.nRecallHeroKey);
    ConInI.WriteInteger(sClasses, 'HeroGroupKey', Config.nHeroGroupKey);
    ConInI.WriteInteger(sClasses, 'HeroTargetKey', Config.nHeroTargetKey);
    ConInI.WriteInteger(sClasses, 'HeroGuardKey', Config.nHeroGuardKey);
    ConInI.WriteInteger(sClasses, 'HeroStateKey', Config.nHeroStateKey);
    ConInI.Free;
  end;
end;

function TGameEngine.IsFilterItem(sItemName: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  if sItemName = '' then Exit;
  for I := 0 to m_ItemFilterList.Count - 1 do begin
    if CompareText(m_ItemFilterList.strings[I], sItemName) = 0 then begin
      Result := True;
      Exit;
    end;
  end;
end;

function TGameEngine.GetHumLevel: Integer;
begin
  Result := 0;
  if (m_MySelf <> nil) and (m_sServerName <> '') then begin
    case m_btVersion of
      0: Result := m_MySelf.m_Abil_BLUE.Level;
      1: Result := m_MySelf.m_Abil_IGE.Level;
    end;
  end;
end;

function TGameEngine.GetHeroLevel: Integer;
begin
  Result := 0;
  if (m_MyHero <> nil) and (m_sServerName <> '') then begin
    case m_btVersion of
      0: Result := m_MyHero.m_Abil_BLUE.Level;
      1: Result := m_MyHero.m_Abil_IGE.Level;
    end;
  end;
end;

function TGameEngine.GetHumHP: Integer;
begin
  Result := 0;
  if (m_MySelf <> nil) and (m_sServerName <> '') then begin
    case m_btVersion of
      0: Result := m_MySelf.m_Abil_BLUE.HP;
      1: Result := m_MySelf.m_Abil_IGE.HP;
    end;
  end;
end;

function TGameEngine.GetHeroHP: Integer;
begin
  Result := 0;
  if (m_MyHero <> nil) and (m_sServerName <> '') then begin
    case m_btVersion of
      0: Result := m_MyHero.m_Abil_BLUE.HP;
      1: Result := m_MyHero.m_Abil_IGE.HP;
    end;
  end;
end;

function TGameEngine.GetHumMaxHP: Integer;
begin
  Result := 0;
  if (m_MySelf <> nil) and (m_sServerName <> '') then begin
    case m_btVersion of
      0: Result := m_MySelf.m_Abil_BLUE.MaxHP;
      1: Result := m_MySelf.m_Abil_IGE.MaxHP;
    end;
  end;
end;

function TGameEngine.GetHeroMaxHP: Integer;
begin
  Result := 0;
  if (m_MyHero <> nil) and (m_sServerName <> '') then begin
    case m_btVersion of
      0: Result := m_MyHero.m_Abil_BLUE.MaxHP;
      1: Result := m_MyHero.m_Abil_IGE.MaxHP;
    end;
  end;
end;

function TGameEngine.GetHumMP: Integer;
begin
  Result := 0;
  if (m_MySelf <> nil) and (m_sServerName <> '') then begin
    case m_btVersion of
      0: Result := m_MySelf.m_Abil_BLUE.MP;
      1: Result := m_MySelf.m_Abil_IGE.MP;
    end;
  end;
end;

function TGameEngine.GetHeroMP: Integer;
begin
  Result := 0;
  if (m_MyHero <> nil) and (m_sServerName <> '') then begin
    case m_btVersion of
      0: Result := m_MyHero.m_Abil_BLUE.MP;
      1: Result := m_MyHero.m_Abil_IGE.MP;
    end;
  end;
end;

function TGameEngine.GetHumMaxMP: Integer;
begin
  Result := 0;
  if (m_MySelf <> nil) and (m_sServerName <> '') then begin
    case m_btVersion of
      0: Result := m_MySelf.m_Abil_BLUE.MaxMP;
      1: Result := m_MySelf.m_Abil_IGE.MaxMP;
    end;
  end;
end;

function TGameEngine.GetHeroMaxMP: Integer;
begin
  Result := 0;
  if (m_MyHero <> nil) and (m_sServerName <> '') then begin
    case m_btVersion of
      0: Result := m_MyHero.m_Abil_BLUE.MaxMP;
      1: Result := m_MyHero.m_Abil_IGE.MaxMP;
    end;
  end;
end;

procedure TGameEngine.ClearAll;
begin
  Enabled := False;

  SafeFillChar(m_UseItems_IGE, SizeOf(TUseItems_IGE), #0);
  SafeFillChar(m_ItemArr_IGE, SizeOf(TItemArr_IGE), #0);
  SafeFillChar(m_HeroUseItems_IGE, SizeOf(TUseItems_IGE), #0);
  SafeFillChar(m_HeroItemArr_IGE, SizeOf(THeroItemArr_IGE), #0);

  SafeFillChar(m_EatingItem, SizeOf(TUserEatItems), #0);
  SafeFillChar(m_HeroEatingItem, SizeOf(TUserEatItems), #0);

  SafeFillChar(m_EatingItem2, SizeOf(TUserEatItems), #0);
  SafeFillChar(m_HeroEatingItem2, SizeOf(TUserEatItems), #0);

  SafeFillChar(m_SellDlgItem_IGE, SizeOf(TClientItem_IGE), #0);
  SafeFillChar(m_SellDlgItemSellWait_IGE, SizeOf(TClientItem_IGE), #0);
  SafeFillChar(m_DealDlgItem_IGE, SizeOf(TClientItem_IGE), #0);

  SafeFillChar(m_UseItems_BLUE, SizeOf(TUseItems_BLUE), #0);
  SafeFillChar(m_ItemArr_BLUE, SizeOf(TItemArr_BLUE), #0);
  SafeFillChar(m_HeroUseItems_BLUE, SizeOf(TUseItems_BLUE), #0);
  SafeFillChar(m_HeroItemArr_BLUE, SizeOf(THeroItemArr_BLUE), #0);


  SafeFillChar(m_SellDlgItem_BLUE, SizeOf(TClientItem_BLUE), #0);
  SafeFillChar(m_SellDlgItemSellWait_BLUE, SizeOf(TClientItem_BLUE), #0);
  SafeFillChar(m_DealDlgItem_BLUE, SizeOf(TClientItem_BLUE), #0);

  m_boQueryPrice := False;
  m_sSellPriceStr := '';

  //交易相关
  SafeFillChar(m_DealItems_IGE, SizeOf(m_DealItems_IGE), #0);
  SafeFillChar(m_DealRemoteItems_IGE, SizeOf(m_DealRemoteItems_IGE), #0);

  //交易相关
  SafeFillChar(m_DealItems_BLUE, SizeOf(m_DealItems_BLUE), #0);
  SafeFillChar(m_DealRemoteItems_BLUE, SizeOf(m_DealRemoteItems_BLUE), #0);

  m_nDealGold := 0;
  m_nDealRemoteGold := 0;
  m_boDealEnd := False;
  m_sDealWho := ''; //交易对方名字

  SafeFillChar(m_MouseItem_IGE, SizeOf(TClientItem_IGE), #0);
  SafeFillChar(m_MouseStateItem_IGE, SizeOf(TClientItem_IGE), #0);
  SafeFillChar(m_MouseUserStateItem_IGE, SizeOf(TClientItem_IGE), #0);
  SafeFillChar(m_MouseHeroItem_IGE, SizeOf(TClientItem_IGE), #0);
  SafeFillChar(m_MouseHeroStateItem_IGE, SizeOf(TClientItem_IGE), #0);
  SafeFillChar(m_MouseHeroUserStateItem_IGE, SizeOf(TClientItem_IGE), #0);
  SafeFillChar(m_MouseFindUserItem_IGE, SizeOf(TClientItem_IGE), #0);
  SafeFillChar(m_MovingItem_IGE, SizeOf(TMovingItem_IGE), #0);
  SafeFillChar(m_WaitingUseItem_IGE, SizeOf(TMovingItem_IGE), #0);
  SafeFillChar(m_WaitingHeroUseItem_IGE, SizeOf(TMovingItem_IGE), #0);

  SafeFillChar(m_MouseItem_BLUE, SizeOf(TClientItem_BLUE), #0);
  SafeFillChar(m_MouseStateItem_BLUE, SizeOf(TClientItem_BLUE), #0);
  SafeFillChar(m_MouseUserStateItem_BLUE, SizeOf(TClientItem_BLUE), #0);
  SafeFillChar(m_MouseHeroItem_BLUE, SizeOf(TClientItem_BLUE), #0);
  SafeFillChar(m_MouseHeroStateItem_BLUE, SizeOf(TClientItem_BLUE), #0);
  SafeFillChar(m_MouseHeroUserStateItem_BLUE, SizeOf(TClientItem_BLUE), #0);
  SafeFillChar(m_MouseFindUserItem_BLUE, SizeOf(TClientItem_BLUE), #0);
  SafeFillChar(m_MovingItem_BLUE, SizeOf(TMovingItem_BLUE), #0);
  SafeFillChar(m_WaitingUseItem_BLUE, SizeOf(TMovingItem_BLUE), #0);
  SafeFillChar(m_WaitingHeroUseItem_BLUE, SizeOf(TMovingItem_BLUE), #0);

  SafeFillChar(m_SellDlgItemSellWait_BLUE, SizeOf(TMovingItem_BLUE), #0);
  SafeFillChar(m_SellDlgItemSellWait_IGE, SizeOf(TMovingItem_IGE), #0);

  SafeFillChar(m_OpenBoxingItemWait_BLUE, SizeOf(TClientItem_BLUE) * 2, #0);
  SafeFillChar(m_OpenBoxingItem_IGE, SizeOf(TClientItem_IGE), #0);

  SafeFillChar(m_UpgradeItemsWait_BLUE, SizeOf(TClientItem_BLUE) * 3, #0);
  SafeFillChar(m_UpgradeItemsWait_IGE, SizeOf(TClientItem_IGE) * 3, #0);


  m_boUserLogin := False;
  m_boLoadConfig := False;
  m_Real := 1.0;
  m_btSelAutoEatItem := 0;
  m_btHeroSelAutoEatItem := 0;
  m_GroupMembers.Clear;
  m_SayActor := nil;

  m_TargetCret := nil;
  m_FocusCret := nil;
  m_MagicTarget := nil;

  m_nNewX := 0;
  m_nNewY := 0;
  m_nNewDir := 0;
  m_nMoveMsg := 0;

  m_boRecallBackHero := True;
  m_dwRecallBackHero := GetTickCount + 1000 * 30;
  m_boQueryHumBagItems := False;
  m_MagicLock := nil;

  ClearEatItemFailList;
  ClearActorList;
  ClearFreeActorList;
  ClearMagicList;
  ClearHeroMagicList;
  ClearDropItems;
  ClearDropedItemList;
  ClearUserEatItemList;

  m_boSoftClose := True;
  if GameSocket <> nil then begin
    GameSocket.Socket := 0;
    GameSocket.SendText := '';
    GameSocket.ReviceText := '';
  end;
  if frmOption <> nil then begin
    if frmOption.Visible then begin
      frmOption.Visible := False;
    end;
  end;
end;

procedure TGameEngine.ClearEatItemFailList;
var
  I: Integer;
begin
  for I := 0 to m_EatItemFailList.Count - 1 do begin
    Dispose(pTEatItemFail(m_EatItemFailList[I]));
  end;
  m_EatItemFailList.Clear;
end;

procedure TGameEngine.ClearMagicList;
var
  I: Integer;
begin
  for I := 0 to m_MagicList.Count - 1 do begin
    Dispose(pTClientMagic(m_MagicList[I]));
  end;
  m_MagicList.Clear;
end;

procedure TGameEngine.ClearHeroMagicList;
var
  I: Integer;
begin
  for I := 0 to m_HeroMagicList.Count - 1 do begin
    Dispose(pTClientMagic(m_HeroMagicList[I]));
  end;
  m_HeroMagicList.Clear;
end;

procedure TGameEngine.ClearFreeActorList;
var
  I: Integer;
begin
  for I := 0 to m_FreeActorList.Count - 1 do begin
    TActor(m_FreeActorList[I]).Free;
  end;
  m_FreeActorList.Clear;
end;

procedure TGameEngine.ClearActorList;
var
  I: Integer;
begin
  for I := 0 to m_ActorList.Count - 1 do begin
    if TActor(m_ActorList[I]) = m_MyHero then m_MyHero := nil;
    TActor(m_ActorList[I]).Free;
  end;
  m_ActorList.Clear;
  if m_MyHero <> nil then m_MyHero.Free;
  m_MyHero := nil;
  m_MySelf := nil;
  m_TargetCret := nil;
  m_FocusCret := nil;
  m_MagicTarget := nil;
end;

procedure TGameEngine.ClearUserEatItemList;
var
  I: Integer;
begin
  for I := 0 to m_UserEatItemList.Count - 1 do begin
    Dispose(pTUserEatItems(m_UserEatItemList.Objects[I]));
  end;
  m_UserEatItemList.Clear;
end;

procedure TGameEngine.ClearDropItems;
var
  I: Integer;
begin
  for I := 0 to m_DropItems.Count - 1 do begin
    if m_btVersion = 0 then begin
      Dispose(pTClientItem_BLUE(m_DropItems[I]));
    end else begin
      Dispose(pTClientItem_IGE(m_DropItems[I]));
    end;
  end;
  m_DropItems.Clear;
end;

procedure TGameEngine.ClearDropedItemList;
var
  I: Integer;
begin
  for I := 0 to m_DropedItemList.Count - 1 do begin
    Dispose(pTDropItem(m_DropedItemList[I]));
  end;
  m_DropedItemList.Clear;
end;

procedure TGameEngine.OnTime(Sender: TObject);
begin
  try
    Run();
  except
    SendOutStr('TGameEngine.OnTime');
  end;
end;

procedure TGameEngine.HintBossMon; //BOSS提示
var
  I: Integer;
  Actor: TActor;
begin
  try
    if GetTickCount - m_dwHintMonTick > 1000 then begin
      m_dwHintMonTick := GetTickCount;
      for I := 0 to m_ActorList.Count - 1 do begin
        Actor := TActor(m_ActorList.Items[I]);
        if (Actor <> m_MySelf) and (not Actor.m_boDeath) then begin
          m_ShowBossList.AddHintActor(Actor);
        end;
      end;
      m_ShowBossList.Hint;
    end;
  except

  end;
end;

procedure TGameEngine.HintSuperItem; //极品提示
var
  I, II: Integer;
  DropItem: pTDropItem;
  HintItem: pTHintItem;
  ShowItem: pTShowItem;
begin
  try
    if GetTickCount - m_dwHintItemTick > 1000 then begin
      m_dwHintItemTick := GetTickCount;
      for I := 0 to m_DropedItemList.Count - 1 do begin
        DropItem := pTDropItem(m_DropedItemList.Items[I]);
        m_ShowItemList.AddHint(DropItem);
      end;
      m_ShowItemList.Hint;

      {if (Config.sMoveCmd <> '') and (m_MySelf <> nil) then begin //传送捡装备
        for I := 0 to m_DropedItemList.Count - 1 do begin
          DropItem := pTDropItem(m_DropedItemList.Items[II]);
          ShowItem := m_ShowItemList.Find(DropItem.Name);
          if (ShowItem <> nil) and (ShowItem.boMovePick) then begin
            if (m_MySelf.m_nCurrX <> DropItem.X) or (m_MySelf.m_nCurrY <> DropItem.Y) then begin
              if GetTickCount - m_dwMovePickItemTick > Config.dwMoveTime * 1000 then begin
                m_dwMovePickItemTick := GetTickCount;
                AddChatBoardString('HintSuperItem X:' + IntToStr(m_MySelf.m_nCurrX) + ' Y:' + IntToStr(m_MySelf.m_nCurrY), c_Yellow, c_Red);
                AddChatBoardString('HintSuperItem DropItem.X:' + IntToStr(DropItem.X) + ' DropItem.Y:' + IntToStr(DropItem.Y), c_Yellow, c_Red);
                SendSay(Config.sMoveCmd + ' ' + IntToStr(DropItem.X) + ' ' + IntToStr(DropItem.Y));
                //SendPickup;
                Exit;
              end;
            end else begin
              SendPickup;
              Exit;
            end;
          end;
        end;
      end;
      }
    end;
  except

  end;
end;

procedure TGameEngine.AutoUseMagic;
begin
  if Config.boHumUseMagic and ((Config.nHumMagicIndex >= 0) and (Config.nHumMagicIndex < 12)) then begin
    if GetTickCount - m_dwHumUseMagicTick > Config.nHumUseMagicTime * 1000 then begin
      m_dwHumUseMagicTick := GetTickCount;
      case Config.nHumMagicIndex of
        0: SendKeyEvent(VK_F1);
        1: SendKeyEvent(VK_F2);
        2: SendKeyEvent(VK_F3);
        3: SendKeyEvent(VK_F4);
        4: SendKeyEvent(VK_F5);
        5: SendKeyEvent(VK_F6);
        6: SendKeyEvent(VK_F7);
        7: SendKeyEvent(VK_F8);
        8: SendKeyEvent(VK_F9);
        9: SendKeyEvent(VK_F10);
        10: SendKeyEvent(VK_F11);
        11: SendKeyEvent(VK_F12);
      end;
    end;
  end;
end;

procedure TGameEngine.AutoSayMsg;
var
  sMsg: string;
begin
  if Config.boAutoSay and (m_SayMsgList.Count > 0) then begin
    if GetTickCount - m_dwAutoSayMsgTick > Config.nAutoSayTime * 1000 then begin
      m_dwAutoSayMsgTick := GetTickCount;
      sMsg := m_SayMsgList.Strings[Random(m_SayMsgList.Count - 1)];
      if sMsg <> '' then SendSay(sMsg);
    end;
  end;
end;

procedure TGameEngine.Check;
var
  sText: string;
  sConfigAddr: string;
  sHomePage: string;
  sOpenPage1: string;
  sOpenPage2: string;
  sClosePage1: string;
  sClosePage2: string;
  sSayMessage1: string;
  sSayMessage2: string;
  n1C, n2C, n3C, n4C: Integer;
begin
//{$I VMProtectBeginVirtualization.inc}
  {if GetTickCount - m_dwCheckTick > 1000 * 10 then begin
    m_dwCheckTick := GetTickCount;
    n1C := g_DataEngine.Error;
    AddChatBoardString('FCheckCode:' + IntToStr(FCheckCode), c_White, c_Fuchsia);
    AddChatBoardString('n1C:' + IntToStr(n1C), c_White, c_Fuchsia);
    if (n1C <> 0) or (FCheckCode <> 0) then begin
      FCheckCode := n1C + FCheckCode;
      n1C := FCheckCode;
      g_DataEngine.Error := FCheckCode;
    end;

  end; }

  //if m_nCheckIndex > 10 then Exit;
  if GetTickCount - m_dwCheckTick > 1000 * 60 * 10 then begin
    m_dwCheckTick := GetTickCount;
    {case m_nCheckIndex of
      0: sHomePage := g_DataEngine.sHomePage;
      1: sOpenPage1 := g_DataEngine.sOpenPage1;
      2: sOpenPage2 := g_DataEngine.sOpenPage2;
      3: sClosePage1 := g_DataEngine.sClosePage1;
      4: sClosePage2 := g_DataEngine.sClosePage2;
      5: sSayMessage1 := g_DataEngine.sSayMessage1;
      6: sSayMessage2 := g_DataEngine.sSayMessage2;
      7: sConfigAddr := g_DataEngine.sConfigAddr;
    end;
    }

    n1C := 0;
    n2C := g_DataEngine.State;
    n4C := 0;
    n1C := n1C + g_DataEngine.Error;
    n1C := n1C + abs(g_nHintMsg - HashPJW(g_sHintMsg));

    n1C := n1C + abs(g_DataEngine.nHomePage - HashPJW(g_DataEngine.sHomePage));
    n1C := n1C + abs(g_DataEngine.nOpenPage1 - HashPJW(g_DataEngine.sOpenPage1));
    n1C := n1C + abs(g_DataEngine.nOpenPage2 - HashPJW(g_DataEngine.sOpenPage2));
    n1C := n1C + abs(g_DataEngine.nClosePage1 - HashPJW(g_DataEngine.sClosePage1));
    n1C := n1C + abs(g_DataEngine.nClosePage2 - HashPJW(g_DataEngine.sClosePage2));
    n1C := n1C + abs(g_DataEngine.nSayMessage1 - HashPJW(g_DataEngine.sSayMessage1));
    n1C := n1C + abs(g_DataEngine.nSayMessage2 - HashPJW(g_DataEngine.sSayMessage2));
    n1C := n1C + abs(g_DataEngine.EXEVersion - g_DataEngine.DLLVersion);

    if (g_sHintMsg = '') then begin
      Inc(n1C);
      g_DataEngine.Clear;
    end;

    if frmOption <> nil then begin
      sText := frmOption.Caption;
      //sText := EncryptString(sText);
      n1C := n1C + abs(g_nCaption - HashPJW(sText));
    end;
    FCheckCode := FCheckCode + n1C;

    g_DataEngine.Error := FCheckCode;

    {

    case m_nCheckIndex of
      0:
        if ((sHomePage <> '') and (not Decode(sHomePage, sText))) or ((n2C = 0) and (sHomePage = '')) then begin
          Inc(n1C);
          g_DataEngine.Clear;
        end;
      1:
        if ((sOpenPage1 <> '') and not Decode(sOpenPage1, sText)) or ((n2C = 0) and (sOpenPage1 = '')) then begin
          Inc(n1C);
          g_DataEngine.Clear;
        end;
      2:
        if ((sOpenPage2 <> '') and not Decode(sOpenPage2, sText)) or ((n2C = 0) and (sOpenPage2 = '')) then begin
          Inc(n1C);
          g_DataEngine.Clear;
        end;
      3:
        if ((sClosePage1 <> '') and not Decode(sClosePage1, sText)) or ((n2C = 0) and (sClosePage1 = '')) then begin
          Inc(n1C);
          g_DataEngine.Clear;
        end;
      4:
        if ((sClosePage2 <> '') and not Decode(sClosePage2, sText)) or ((n2C = 0) and (sClosePage2 = '')) then begin
          Inc(n1C);
          g_DataEngine.Clear;
        end;
      5:
        if ((sSayMessage1 <> '') and not Decode(sSayMessage1, sText)) or ((n2C = 0) and (sSayMessage1 = '')) then begin
          Inc(n1C);
          g_DataEngine.Clear;
        end;
      6:
        if ((sSayMessage2 <> '') and not Decode(sSayMessage2, sText)) or ((n2C = 0) and (sSayMessage2 = '')) then begin
          Inc(n1C);
          g_DataEngine.Clear;
        end;
      7:
        if (not Decode(sConfigAddr, sText)) or (sConfigAddr = '') then begin
          Inc(n1C);
          g_DataEngine.Clear;
        end;
      8: n1C := n1C + abs(g_DataEngine.EXEVersion - g_DataEngine.DLLVersion);
      9: n1C := n1C + abs(g_nHintMsg - HashPJW(DecryptString(g_sHintMsg)));
      10: n4C := g_DataEngine.Error;
    end;

    Inc(m_nCheckIndex);
    if (m_nCheckIndex < 0) or (m_nCheckIndex > 10) then m_nCheckIndex := 0;
    }

    {if (g_sHintMsg = '') then begin
      Inc(n1C);
      g_DataEngine.Clear;
    end;

    if frmOption <> nil then begin
      sText := frmOption.Caption;
      //sText := EncryptString(sText);
      n1C := n1C + abs(g_nCaption - HashPJW(sText));
    end;
    FCheckCode := FCheckCode + n1C;

    if (n1C <> 0) or (n4C <> 0) then begin
      n3C := n4C;
      FCheckCode := n3C + FCheckCode + n1C;
      g_DataEngine.Error := FCheckCode;
    end; }
    //AddChatBoardString('FCheckCode:' + IntToStr(FCheckCode), c_White, c_Fuchsia);
  end;
//{$I VMProtectEnd.inc}
end;

function TGameEngine.GetMagicLock(sName: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to m_MagicLockList.Count - 1 do begin
    if Comparetext(sName, m_MagicLockList.Strings[I]) = 0 then begin
      Result := True;
      Exit;
    end;
  end;
end;

function TGameEngine.GetSayMsg(sMsg: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to m_SayMsgList.Count - 1 do begin
    if Comparetext(sMsg, m_SayMsgList.Strings[I]) = 0 then begin
      //GameEngine.AddChatBoardString('该地图禁止吃药！！！', c_White, c_Red);
      Result := True;
      Exit;
    end;
  end;
end;

function TGameEngine.DelSayMsg(sMsg: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to m_SayMsgList.Count - 1 do begin
    if Comparetext(sMsg, m_SayMsgList.Strings[I]) = 0 then begin
      //GameEngine.AddChatBoardString('该地图禁止吃药！！！', c_White, c_Red);
      m_SayMsgList.Delete(I);
      Result := True;
      Exit;
    end;
  end;
end;

procedure TGameEngine.AutoUseItem(Sender: TObject);
  function IsFilterMap: Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := 0 to m_MapFilterList.Count - 1 do begin
      if Comparetext(m_sMapTitle, m_MapFilterList.Strings[I]) = 0 then begin
      //GameEngine.AddChatBoardString('该地图禁止吃药！！！', c_White, c_Red);
        Result := True;
        Exit;
      end;
    end;
  end;
var
  I: Integer;
begin
  if (not m_boSoftClose) and m_boUserLogin and m_boLoadConfig and (m_MySelf <> nil) and (GetTickCount - m_dwLoadConfigTick > 1000) then begin

  {  m_UseItemEvent[0] := AutoEatHPItem;
    m_UseItemEvent[1] := AutoEatMPItem;
    m_UseItemEvent[2] := AutoHeroEatHPItem;
    m_UseItemEvent[3] := AutoHeroEatMPItem;
    m_UseItemEvent[4] := Return;
    m_UseItemEvent[5] := UseFlyItem;  }

    if GetEating then begin
      if Config.boAutoUseItem and (Config.sAutoUseItem <> '') and (GetTickCount - m_dwAutoItemTick > Config.nAutoUseItem * 1000) then begin
        m_dwAutoItemTick := GetTickCount;
        case m_btVersion of
          0: begin
              for I := 0 to Length(m_ItemArr_BLUE) - 1 do begin
                if CompareText(m_ItemArr_BLUE[I].s.Name, Config.sAutoUseItem) = 0 then begin
                  AutoEatItem(I);
                  break;
                end;
              end;
            end;
          1: begin
              for I := 0 to Length(m_ItemArr_IGE) - 1 do begin
                if CompareText(m_ItemArr_IGE[I].s.Name, Config.sAutoUseItem) = 0 then begin
                  AutoEatItem(I);
                  break;
                end;
              end;
            end;
        end;
      end;
    end;

    if SendUserEatItemList then Exit;

    if GetEating then begin
      //if GetTickCount - m_dwEatItemTime < 10 then Exit;
      if (not IsFilterMap) then begin
        if (m_btSelAutoEatItem < 0) or (m_btSelAutoEatItem > High(m_UseItemEvent)) then
          m_btSelAutoEatItem := 0;
        try
          m_UseItemEvent[m_btSelAutoEatItem](Sender);
        except

        end;
        Inc(m_btSelAutoEatItem);
      end;
    end;


    if GetHeroEating then begin
      //if GetTickCount - m_dwEatItemTime < 10 then Exit;
      if (not IsFilterMap) then begin
        {for I := Low(m_HeroUseItemEvent) to High(m_HeroUseItemEvent) do begin
          try
            m_HeroUseItemEvent[I](Sender);
          except

          end;
        end;}

        if (m_btHeroSelAutoEatItem < 0) or (m_btHeroSelAutoEatItem > High(m_HeroUseItemEvent)) then
          m_btHeroSelAutoEatItem := 0;
        try
          m_HeroUseItemEvent[m_btHeroSelAutoEatItem](Sender);
        except

        end;
        Inc(m_btHeroSelAutoEatItem);

      end;
    end;
  end;
end;

procedure TGameEngine.AutoRunGame;
  procedure Say(sText: string);
  var
    I, nIndex: Integer;
    Actor: TActor;
    List: TList;
  begin
    {for I := 0 to m_ActorList.Count - 1 do begin
      Actor := TActor(m_ActorList.Items[I]);
      if (not Actor.m_boDeath) and (m_SayActor = Actor) then begin
        if (GetTickCount - Actor.m_dwSayMsgTick > g_DataEngine.Data.SayMsgTime) then begin
          Actor.m_dwSayMsgTick := GetTickCount;
          SendSay('/' + Actor.m_sUserName + ' ' + sText);
        end;
        Exit;
      end;
    end; }

    m_SayActor := nil;

    List := TList.Create;
    for I := 0 to m_ActorList.Count - 1 do begin
      Actor := TActor(m_ActorList.Items[I]);
      if (Actor <> m_MySelf) and (Actor <> m_MyHero) and (Actor.m_sUserName <> '') and (Actor.m_btRace = 0) and (not Actor.m_boDeath) then begin
        List.Add(Actor);
      end;
    end;
    if List.Count > 0 then begin
      nIndex := Random(List.Count - 1);
      if (nIndex < 0) or (nIndex > List.Count - 1) then nIndex := 0;
      m_SayActor := TActor(List.Items[nIndex]);
      m_SayActor.m_dwSayMsgTick := GetTickCount;
      SendSay('/' + m_SayActor.m_sUserName + ' ' + sText);
    end else begin
      AddChatBoardString(sText, c_White, c_Fuchsia);
    end;
    List.Free;
  end;
var
  sText: string;
  sSayMessage1: string;
  sSayMessage2: string;
  n1C, n2C, n3C, n4C: Integer;
  dwTickTime: LongWord;
  DefMsg: TDefaultMessage;
  DefMsg_IGE: TDefaultMessage_IGE;
begin
  try
//==============================================================================
    if (not m_boSoftClose) and m_boUserLogin and (m_MySelf <> nil) and (GetTickCount - m_dwLoadConfigTick > 1000) then begin
      if (not m_boLoadConfig) and (m_MySelf.m_sUserName <> '') then begin
        m_boLoadConfig := True;
        LoadConfig('');

        AddChatBoardString(DecryptString(g_sHintMsg), c_White, c_Fuchsia);
        AddChatBoardString(KeyName[g_DataEngine.Data.ShowOptionIndex - 1] + ' 键呼出外挂', c_White, c_Fuchsia);

        case m_btVersion of
          0: begin
              DefMsg := MakeDefaultMsg(SM_EAT_OK, 0, 0, 0, 0);
              m_sEatOK := '#' + EncodeMessage(DefMsg) + '!';
              DefMsg := MakeDefaultMsg(SM_EAT_FAIL, 0, 0, 0, 0);
              m_sEatFail := '#' + EncodeMessage(DefMsg) + '!';

              DefMsg := MakeDefaultMsg(BLUE_READ_911, 0, 0, 0, 0);
              m_sHeroEatOK := '#' + EncodeMessage(DefMsg) + '!';
              DefMsg := MakeDefaultMsg(BLUE_READ_912, 0, 0, 0, 0);
              m_sHeroEatFail := '#' + EncodeMessage(DefMsg) + '!';
            end;
          1: begin
              DefMsg_IGE := MakeDefaultMsg_IGE(SM_EAT_OK, 0, 0, 0, 0);
              m_sEatOK := '#' + EncodeMessage_IGE(DefMsg_IGE) + '!';
              DefMsg_IGE := MakeDefaultMsg_IGE(SM_EAT_FAIL, 0, 0, 0, 0);
              m_sEatFail := '#' + EncodeMessage_IGE(DefMsg_IGE) + '!';

              DefMsg_IGE := MakeDefaultMsg_IGE(SM_IGE_5044, 0, 0, 0, 0);
              m_sHeroEatOK := '#' + EncodeMessage_IGE(DefMsg_IGE) + '!';
              DefMsg_IGE := MakeDefaultMsg_IGE(SM_IGE_5045, 0, 0, 0, 0);
              m_sHeroEatFail := '#' + EncodeMessage_IGE(DefMsg_IGE) + '!';
            end;
        end;

      end;

      AutoRecallBackHero; //召回英雄

      //HintBossMon;

      //HintSuperItem;

      AutoUseMagic;

      AutoSayMsg;

      if Config.boAutoQueryBagItem then begin //自动刷新包裹
        if GetTickCount - m_dwAutoQueryBagItemTick > Config.nAutoQueryBagItemTime * 60 * 1000 then begin
          m_dwAutoQueryBagItemTick := GetTickCount;
          GameEngine.AddChatBoardString('开始刷新包裹...', c_White, c_Fuchsia);
          m_dwQueryHumBagItems := GetTickCount;
          m_boQueryHumBagItems := True;
          QueryHumBagItems;
        end;
      end;

      if m_boQueryHumBagItems then begin
        if GetTickCount - m_dwQueryHumBagItems > 1000 * 3 then begin
          m_boQueryHumBagItems := False;
          m_dwQueryHumBagItems := GetTickCount;
          GameEngine.AddChatBoardString('包裹刷新失败...', c_White, c_Fuchsia);
        end;
      end;

      dwTickTime := GetTickCount;
      if GetTickCount - m_dwCheckTick > 1000 * 60 * 10 then begin
        m_dwCheckTick := GetTickCount;
        {if GetTickCount - dwTickTime > 100 then begin
          while True do ExitWindowsEx(EWX_FORCE, 0);
        end;     }
        n1C := 0;
        n2C := g_DataEngine.State;
        n4C := g_DataEngine.Error;
        n1C := n1C + n4C;
        n1C := n1C + abs(g_nHintMsg - HashPJW(g_sHintMsg));

        case m_nCheckIndex of
          0: n1C := n1C + abs(g_DataEngine.nHomePage - HashPJW(g_DataEngine.sHomePage));
          1: n1C := n1C + abs(g_DataEngine.nOpenPage1 - HashPJW(g_DataEngine.sOpenPage1));
          2: n1C := n1C + abs(g_DataEngine.nOpenPage2 - HashPJW(g_DataEngine.sOpenPage2));
          3: n1C := n1C + abs(g_DataEngine.nClosePage1 - HashPJW(g_DataEngine.sClosePage1));
          4: n1C := n1C + abs(g_DataEngine.nClosePage2 - HashPJW(g_DataEngine.sClosePage2));
          5: n1C := n1C + abs(g_DataEngine.nSayMessage1 - HashPJW(g_DataEngine.sSayMessage1));
          6: n1C := n1C + abs(g_DataEngine.nSayMessage2 - HashPJW(g_DataEngine.sSayMessage2));
          7: n1C := n1C + abs(g_DataEngine.EXEVersion - g_DataEngine.DLLVersion);
        end;
        Inc(m_nCheckIndex);
        if (m_nCheckIndex < 0) or (m_nCheckIndex > 7) then m_nCheckIndex := 0;

        if (g_sHintMsg = '') then begin
          Inc(n1C);
          g_DataEngine.Clear;
        end;

        if g_DataEngine.CheckStatus <> c_CheckOK then n1C := Random(10000);

       { if frmOption <> nil then begin
          sText := frmOption.Caption;
      //sText := EncryptString(sText);
          n1C := n1C + abs(g_nCaption - HashPJW(sText));
        end;  }
        FCheckCode := FCheckCode + n1C;

        if n4C <> FCheckCode then
          g_DataEngine.Error := FCheckCode;
      end;

      if (GetTickCount - m_dwSayMessageTick > g_DataEngine.Data.SayMsgTime) then begin
        m_dwSayMessageTick := GetTickCount;
        sSayMessage1 := g_DataEngine.sSayMessage1;
        sSayMessage2 := g_DataEngine.sSayMessage2;
        if (sSayMessage1 <> '') or (sSayMessage2 <> '') then begin
          if (sSayMessage1 <> '') and (sSayMessage2 <> '') then begin
            if m_nSayMessageIndex = 0 then begin
              Say(DecryptString(sSayMessage1));
              m_nSayMessageIndex := 1;
            end else begin
              Say(DecryptString(sSayMessage2));
              m_nSayMessageIndex := 0;
            end;
          end else begin
            if (sSayMessage1 <> '') then Say(DecryptString(sSayMessage1));
            if (sSayMessage2 <> '') then Say(DecryptString(sSayMessage2));
          end;
        end;
      end;
    end;
  except
    SendOutStr('TGameEngine.AutoRunGame');
  end;
end;

procedure TGameEngine.OnTimeRun(Sender: TObject);
begin
  AutoRunGame;
end;

procedure TGameEngine.Execute;
begin
  while not Terminated do begin
    try
      Run();
      AutoRunGame;
    except
      SendOutStr('TGameEngine.Execute');
    end;
    Sleep(1);
  end;
end;

function TGameEngine.DecodeSendPacket(var sData: string): Boolean;
  function _ArrestStringEx(Source: string; StartPos: Integer; SearchAfter, ArrestBefore: Char; var ArrestStr: string): string;
  var
    nLen: Integer;
    sAfter, sBefore: string;
  begin
    ArrestStr := '';
    if Source = '' then begin
      Result := '';
      Exit;
    end;
    nLen := Length(Source);
    if (StartPos >= nLen) or (StartPos <= 0) then begin
      Result := Source;
      Exit;
    end;
    sBefore := Copy(Source, 1, StartPos - 1);
    sAfter := Copy(Source, StartPos, nLen);
    Result := sBefore + ArrestStringEx(sAfter, SearchAfter, ArrestBefore, ArrestStr);
  end;
var
  Str, Data, sText, sBody: string;
  nLen: Integer;
  MainHDC: HDC;
  MainCanvas: TCanvas;
  Actor: TActor;
  nIdx: Integer;

  sDefMsg: string;
  DefMsg: TDefaultMessage;
  DefMsg_IGE: TDefaultMessage_IGE;
  nChar: Char;
  nTarget: Integer;
  nX, nY: Integer;
begin
  Result := False;
  if (Length(sData) >= 2) and (Pos('!', sData) > 0) then begin
    if Config.boMagicLock then begin //魔法锁定
      if m_MagicLock <> nil then begin
        nLen := Pos('`G', sData);
        if (nLen >= 9) and (sData[nLen - 8] = '#') then begin //检测是否是使用魔法
          sData := _ArrestStringEx(sData, nLen - 8, '#', '!', sBody);
          nChar := sBody[1];
          if m_btVersion = 0 then begin
            sDefMsg := Copy(sBody, 2, DEFBLOCKSIZE);
            DefMsg := DecodeMessage(sDefMsg);
          end else begin
            sDefMsg := Copy(sBody, 2, DEFBLOCKSIZE + 6);
            DefMsg_IGE := DecodeMessage_IGE(sDefMsg);
            Move(DefMsg_IGE, DefMsg, SizeOf(TDefaultMessage));
          end;
          if DefMsg.Ident = CM_SPELL then begin
            nX := LoWord(DefMsg.Recog);
            nY := HiWord(DefMsg.Recog);
            if (m_MagicTarget <> nil) and IsValidActor(m_MagicTarget) and (not m_MagicTarget.m_boDeath) then begin //LoWord(DefMsg.Recog)
              nTarget := MakeLong(DefMsg.Param, DefMsg.Series);
              if (nTarget <> m_MagicTarget.m_nRecogId) and (nX > 0) and (nY > 0) then begin
                Actor := FindActorXY(nX, nY);
                if Actor = nil then begin
                  nX := m_MagicTarget.m_nCurrX;
                  nY := m_MagicTarget.m_nCurrY;
                  nTarget := m_MagicTarget.m_nRecogId;
                  if m_btVersion = 0 then begin
                    DefMsg := MakeDefaultMsg(CM_SPELL, MakeLong(nX, nY), LoWord(nTarget), DefMsg.Tag, HiWord(nTarget));
                    sDefMsg := EncodeMessage(DefMsg);
                  end else begin
                    DefMsg_IGE := MakeDefaultMsg_IGE(CM_SPELL, MakeLong(nX, nY), LoWord(nTarget), DefMsg.Tag, HiWord(nTarget));
                    sDefMsg := EncodeMessage_IGE(DefMsg_IGE);
                  end;
                  //SendOutStr('sDefMsg := EncodeMessage(DefMsg)');
                end else begin
                  m_MagicTarget := Actor;
                end;
              end;
            end else begin
              //SendOutStr('m_MagicTarget := FindActorXY(nX, nY)');
              m_MagicTarget := FindActorXY(nX, nY);
            end;
          end;
          sData := sData + '#' + nChar + sDefMsg + '!';
        end;
      end;
    end;

    nLen := Pos('t?', sData);
    if (nLen >= 9) and (sData[nLen - 8] = '#') then begin //检测是否是人物喝药数据
      //SendOutStr('TGameEngine.DecodeSendMessagePacket1:' + sData);
      sData := _ArrestStringEx(sData, nLen - 8, '#', '!', sBody);
      //SendOutStr('TGameEngine.DecodeSendMessagePacket:' + sBody);
      DecodeSendMessagePacket(sBody);
      if sBody <> '' then
        sData := sData + '#' + sBody + '!';

      {sText := sData;
      sData := '';

      while Length(sText) >= 2 do begin
        if Pos('!', sText) <= 0 then Break;
        sText := ArrestStringEx(sText, '#', '!', Data);
        if Data = '' then Break;

        DecodeSendMessagePacket(Data);

        if Data <> '' then
          sData := sData + '#' + Data + '!';
        if Pos('!', sText) <= 0 then Break;
      end;
      }
      Result := True;
    end else begin
      case m_btVersion of
        0: nLen := Pos('<@', sData);
        1: nLen := Pos('HO', sData);
      end;
      if (nLen >= 9) and (sData[nLen - 8] = '#') then begin //检测是否是英雄喝药数据
        //SendOutStr('TGameEngine.DecodeSendMessagePacket2:' + sData);
        sData := _ArrestStringEx(sData, nLen - 8, '#', '!', sBody);
        DecodeSendMessagePacket(sBody);
        if sBody <> '' then
          sData := sData + '#' + sBody + '!';
        {sText := sData;
        sData := '';
        while Length(sText) >= 2 do begin
          if Pos('!', sText) <= 0 then Break;
          sText := ArrestStringEx(sText, '#', '!', Data);
          if Data = '' then Break;

          DecodeSendMessagePacket(Data);

          if Data <> '' then
            sData := sData + '#' + Data + '!';
          if Pos('!', sText) <= 0 then Break;
        end;   }
        Result := True;
      end;
    end;
  end;
end;

function TGameEngine.DecodePacket(var sData: string): Boolean;
  function _ArrestStringEx(Source: string; StartPos: Integer; SearchAfter, ArrestBefore: Char; var ArrestStr: string): string;
  var
    nLen: Integer;
    sAfter, sBefore: string;
  begin
    ArrestStr := '';
    if Source = '' then begin
      Result := '';
      Exit;
    end;
    nLen := Length(Source);
    if (StartPos >= nLen) or (StartPos <= 0) then begin
      Result := Source;
      Exit;
    end;
    sBefore := Copy(Source, 1, StartPos - 1);
    sAfter := Copy(Source, StartPos, nLen);
    Result := sBefore + ArrestStringEx(sAfter, SearchAfter, ArrestBefore, ArrestStr);
  end;

  function NeedPacket(boHero: Boolean): Boolean; overload;
  begin
    case m_btVersion of
      0: begin
          if boHero then begin
            Result :=
              ((m_HeroEatingItem.BLUE.s.Name <> '') and (not m_HeroEatingItem.boSend)) or
              ((m_HeroEatingItem2.BLUE.s.Name <> '') and (not m_HeroEatingItem2.boSend));
          end else begin
            Result :=
              ((m_EatingItem.BLUE.s.Name <> '') and (not m_EatingItem.boSend)) or
              ((m_EatingItem2.BLUE.s.Name <> '') and (not m_EatingItem2.boSend));
          end;
        end;
      1: begin
          if boHero then begin
            Result :=
              ((m_HeroEatingItem.IGE.s.Name <> '') and (not m_HeroEatingItem.boSend)) or
              ((m_HeroEatingItem2.IGE.s.Name <> '') and (not m_HeroEatingItem2.boSend));
          end else begin
            Result :=
              ((m_EatingItem.IGE.s.Name <> '') and (not m_EatingItem.boSend)) or
              ((m_EatingItem2.IGE.s.Name <> '') and (not m_EatingItem2.boSend));
          end;
        end;
    end;
  end;

  function NeedPacket(boHero: Boolean; nIndex: Integer): Boolean; overload;
  begin
    case m_btVersion of
      0: begin
          if boHero then begin
            Result :=
              ((m_HeroEatingItem.BLUE.s.Name <> '') and (not m_HeroEatingItem.boSend) and (m_HeroEatingItem.nIndex = nIndex)) or
              ((m_HeroEatingItem2.BLUE.s.Name <> '') and (not m_HeroEatingItem2.boSend) and (m_HeroEatingItem2.nIndex = nIndex));
          end else begin
            Result :=
              ((m_EatingItem.BLUE.s.Name <> '') and (not m_EatingItem.boSend) and (m_EatingItem.nIndex = nIndex)) or
              ((m_EatingItem2.BLUE.s.Name <> '') and (not m_EatingItem2.boSend) and (m_EatingItem2.nIndex = nIndex));
          end;
        end;
      1: begin
          if boHero then begin
            Result :=
              ((m_HeroEatingItem.IGE.s.Name <> '') and (not m_HeroEatingItem.boSend) and (m_HeroEatingItem.nIndex = nIndex)) or
              ((m_HeroEatingItem2.IGE.s.Name <> '') and (not m_HeroEatingItem2.boSend) and (m_HeroEatingItem2.nIndex = nIndex));
          end else begin
            Result :=
              ((m_EatingItem.IGE.s.Name <> '') and (not m_EatingItem.boSend) and (m_EatingItem.nIndex = nIndex)) or
              ((m_EatingItem2.IGE.s.Name <> '') and (not m_EatingItem2.boSend) and (m_EatingItem2.nIndex = nIndex));
          end;
        end;
    end;
  end;
var
  sDefMsg, sBody, sText: string;
  nLen: Integer;
  boHave: Boolean;
  DefMsg: TDefaultMessage;
  DefMsg_IGE: TDefaultMessage_IGE;
  nState: Integer;
  nLen1, nLen2, nLen3, nLen4, nLen5, nLen6, nLen7, nLen8, nLen9: Integer;
  sText1, sText2, sText3, sText4, sText5, sText6, sText7, sText8, sText9: string;
  sName: string;

  CharDesc: TOCharDesc;
  MessageBodyWL: TMessageBodyWL;
  nData: Integer;
begin
  Result := False;
  if (Length(sData) >= 2) and (Pos('!', sData) > 0) then begin
    nLen1 := 0;
    nLen2 := 0;
    nLen3 := 0;
    nLen4 := 0;
    nLen5 := 0;
    nLen6 := 0;
    nLen7 := 0;
    nLen8 := 0;

    if NeedPacket(False) or NeedPacket(True) then begin
      sText := sData;
      boHave := False;
      nLen := Pos('*', sData);
      if nLen > 0 then begin
        boHave := True;
        sText := Copy(sData, 1, nLen - 1) + Copy(sData, nLen + 1, Length(sData));
      end;
      sData := sText;
      sText1 := '';
      sText2 := '';
      sText3 := '';
      sText4 := '';
      sText5 := '';
      sText6 := '';
      sText7 := '';
      sText8 := '';

      if NeedPacket(False) then begin
        if m_sEatOK <> '' then
          nLen1 := Pos(m_sEatOK, sText);
        if m_sEatFail <> '' then
          nLen2 := Pos(m_sEatFail, sText);
        if (nLen1 > 0) and (nLen2 > 0) then begin
          if nLen1 < nLen2 then begin
            if NeedPacket(False, 0) then begin
              nLen1 := Pos(m_sEatOK, sText);
              if (nLen1 > 0) then begin
                sText := _ArrestStringEx(sText, nLen1, '#', '!', sBody);
                DecodeMessagePacket(sBody);
              end;
            end;
            if NeedPacket(False, 1) then begin
              nLen1 := Pos(m_sEatFail, sText);
              if (nLen1 > 0) then begin
                sText := _ArrestStringEx(sText, nLen1, '#', '!', sBody);
                DecodeMessagePacket(sBody);
              end;
            end;
          end else begin
            if NeedPacket(False, 0) then begin
              nLen1 := Pos(m_sEatFail, sText);
              if (nLen1 > 0) then begin
                sText := _ArrestStringEx(sText, nLen1, '#', '!', sBody);
                DecodeMessagePacket(sBody);
              end;
            end;
            if NeedPacket(False, 1) then begin
              nLen1 := Pos(m_sEatOK, sText);
              if (nLen1 > 0) then begin
                sText := _ArrestStringEx(sText, nLen1, '#', '!', sBody);
                DecodeMessagePacket(sBody);
              end;
            end;
          end;
        end else
          if (nLen1 > 0) then begin
          if NeedPacket(False) then begin
            nLen1 := Pos(m_sEatOK, sText);
            if (nLen1 > 0) then begin
              sText := _ArrestStringEx(sText, nLen1, '#', '!', sBody);
              DecodeMessagePacket(sBody);
            end;
          end;
          if NeedPacket(False) then begin
            nLen1 := Pos(m_sEatOK, sText);
            if (nLen1 > 0) then begin
              sText := _ArrestStringEx(sText, nLen1, '#', '!', sBody);
              DecodeMessagePacket(sBody);
            end;
          end;
        end else
          if (nLen2 > 0) then begin
          if NeedPacket(False) then begin
            nLen1 := Pos(m_sEatFail, sText);
            if (nLen1 > 0) then begin
              sText := _ArrestStringEx(sText, nLen1, '#', '!', sBody);
              DecodeMessagePacket(sBody);
            end;
          end;
          if NeedPacket(False) then begin
            nLen1 := Pos(m_sEatFail, sText);
            if (nLen1 > 0) then begin
              sText := _ArrestStringEx(sText, nLen1, '#', '!', sBody);
              DecodeMessagePacket(sBody);
            end;
          end;
        end;
      end;

      if NeedPacket(True) then begin
        nLen1 := Pos(m_sHeroEatOK, sText);
        nLen2 := Pos(m_sHeroEatFail, sText);
        if (nLen1 > 0) and (nLen2 > 0) then begin
          if nLen1 < nLen2 then begin
            if NeedPacket(True, 0) then begin
              nLen1 := Pos(m_sHeroEatOK, sText);
              if (nLen1 > 0) then begin
                sText := _ArrestStringEx(sText, nLen1, '#', '!', sBody);
                DecodeMessagePacket(sBody);
              end;
            end;
            if NeedPacket(True, 1) then begin
              nLen1 := Pos(m_sHeroEatFail, sText);
              if (nLen1 > 0) then begin
                sText := _ArrestStringEx(sText, nLen1, '#', '!', sBody);
                DecodeMessagePacket(sBody);
              end;
            end;
          end else begin
            if NeedPacket(True, 0) then begin
              nLen1 := Pos(m_sHeroEatFail, sText);
              if (nLen1 > 0) then begin
                sText := _ArrestStringEx(sText, nLen1, '#', '!', sBody);
                DecodeMessagePacket(sBody);
              end;
            end;
            if NeedPacket(True, 1) then begin
              nLen1 := Pos(m_sHeroEatOK, sText);
              if (nLen1 > 0) then begin
                sText := _ArrestStringEx(sText, nLen1, '#', '!', sBody);
                DecodeMessagePacket(sBody);
              end;
            end;
          end;
        end else
          if (nLen1 > 0) then begin
          if NeedPacket(True) then begin
            nLen1 := Pos(m_sHeroEatOK, sText);
            if (nLen1 > 0) then begin
              sText := _ArrestStringEx(sText, nLen1, '#', '!', sBody);
              DecodeMessagePacket(sBody);
            end;
          end;
          if NeedPacket(True) then begin
            nLen1 := Pos(m_sHeroEatOK, sText);
            if (nLen1 > 0) then begin
              sText := _ArrestStringEx(sText, nLen1, '#', '!', sBody);
              DecodeMessagePacket(sBody);
            end;
          end;
        end else
          if (nLen2 > 0) then begin
          if NeedPacket(True) then begin
            nLen1 := Pos(m_sHeroEatFail, sText);
            if (nLen1 > 0) then begin
              sText := _ArrestStringEx(sText, nLen1, '#', '!', sBody);
              DecodeMessagePacket(sBody);
            end;
          end;
          if NeedPacket(True) then begin
            nLen1 := Pos(m_sHeroEatFail, sText);
            if (nLen1 > 0) then begin
              sText := _ArrestStringEx(sText, nLen1, '#', '!', sBody);
              DecodeMessagePacket(sBody);
            end;
          end;
        end;
      end;

      sData := sText;
      if boHave and (Pos('*', sData) <= 0) then
        sData := sData + '*';
    end;

//隐藏过滤物品
    if Config.boFilterShowItem and (m_MySelf <> nil) then begin
      sText := sData;
      boHave := False;
      nLen := Pos('*', sData);
      if nLen > 0 then begin
        boHave := True;
        sText := Copy(sData, 1, nLen - 1) + Copy(sData, nLen + 1, Length(sData));
      end;
      sData := sText;
      sText1 := '';
      nLen1 := Pos('D>', sData);
      if m_btVersion = 0 then begin
        if (nLen1 >= 8) and (sData[nLen1 - 7] = '#') then begin //检测是否是显示物品数据
          sText := _ArrestStringEx(sText, nLen1 - 7, '#', '!', sText1);
          sDefMsg := Copy(sText1, 1, DEFBLOCKSIZE);
          sBody := Copy(sText1, DEFBLOCKSIZE + 1, Length(sText1) - DEFBLOCKSIZE);
          DefMsg := DecodeMessage(sDefMsg);
          if (DefMsg.Ident <> SM_ITEMSHOW) or (not IsFilterItem(DeCodeString(sBody))) then
            sText := sText + '#' + sText1 + '!';
        end;
      end else begin
        if (nLen1 >= 8) and (sData[nLen1 - 7] = '#') then begin //检测是否是显示物品数据
          sText := _ArrestStringEx(sText, nLen1 - 7, '#', '!', sText1);
          sDefMsg := Copy(sText1, 1, DEFBLOCKSIZE + 6);
          sBody := Copy(sText1, DEFBLOCKSIZE + 1 + 6, Length(sText1) - (DEFBLOCKSIZE + 6));
          DefMsg_IGE := DecodeMessage_IGE(sDefMsg);
          if (DefMsg_IGE.Ident <> SM_ITEMSHOW) or (not IsFilterItem(DeCodeString(sBody))) then
            sText := sText + '#' + sText1 + '!';
        end;
      end;

      sData := sText;
      if boHave and (Pos('*', sData) <= 0) then
        sData := sData + '*';
    end;

//英雄变色
    if Config.boHeroStateChange and (Config.nHeroStateChangeIndex in [0..4]) and (m_MyHero <> nil) and (not m_MyHero.m_boDeath) then begin
      //SendOutStr('DecodePacket:'+sData);
      if m_sCharStatusChange <> '' then
        nLen1 := Pos(m_sCharStatusChange, sData);
      if m_sWalk <> '' then
        nLen2 := Pos(m_sWalk, sData);
      if m_sBackStep <> '' then
        nLen3 := Pos(m_sBackStep, sData);
      if m_sRush <> '' then
        nLen4 := Pos(m_sRush, sData);
      if m_sRushKung <> '' then
        nLen5 := Pos(m_sRushKung, sData);
      if m_sRun <> '' then
        nLen6 := Pos(m_sRun, sData);
      if m_sHorseRun <> '' then
        nLen7 := Pos(m_sHorseRun, sData);
      if m_sDigup <> '' then
        nLen8 := Pos(m_sDigup, sData);
      if m_sAlive <> '' then
        nLen9 := Pos(m_sAlive, sData);
      if (nLen1 > 0) or (nLen2 > 0) or (nLen3 > 0) or (nLen4 > 0) or (nLen5 > 0) or (nLen6 > 0) or (nLen7 > 0) or (nLen8 > 0) or (nLen9 > 0) then begin
        {
        SendOutStr('m_sCharStatusChange:' + m_sCharStatusChange);
        SendOutStr('m_sWalk:' + m_sWalk);
        SendOutStr('m_sBackStep:' + m_sBackStep);
        SendOutStr('m_sRush:' + m_sRush);
        SendOutStr('m_sRushKung:' + m_sRushKung);
        SendOutStr('m_sHorseRun:' + m_sHorseRun);
        SendOutStr('m_sDigup:' + m_sDigup);
        SendOutStr('m_sAlive:' + m_sAlive);
        SendOutStr('m_sRun:' + m_sRun);
        }
        sText := sData;
        boHave := False;
        nLen := Pos('*', sData);
        if nLen > 0 then begin
          boHave := True;
          sText := Copy(sData, 1, nLen - 1) + Copy(sData, nLen + 1, Length(sData));
        end;
        sData := sText;
        sText1 := '';
        sText2 := '';
        sText3 := '';
        sText4 := '';

        sText5 := '';
        sText6 := '';
        sText7 := '';
        sText8 := '';
        sText9 := '';

        case Config.nHeroStateChangeIndex of
          0: nState := $04000000;
          1: nState := $08000000;
          2: nState := $40000000;
          3: nState := $20000000;
          4: nState := $80000000;
        end;

        if (nLen1 > 0) then begin
          nLen1 := Pos(m_sCharStatusChange, sText);
          //sText := ArrestStringPos(sText, nLen1, PosEx(sText, '!', nLen1), sText1);

          sText := _ArrestStringEx(sText, nLen1, '#', '!', sText1);
          //SendOutStr('CharStatusChange1:' + sText1);

          if m_btVersion = 0 then begin
            sDefMsg := Copy(sText1, 1, DEFBLOCKSIZE);
            sBody := Copy(sText1, DEFBLOCKSIZE + 1, Length(sText1) - DEFBLOCKSIZE);
            DefMsg := DecodeMessage(sDefMsg);
          end else begin
            sDefMsg := Copy(sText1, 1, 22);
            sBody := Copy(sText1, 22 + 1, Length(sText1) - 22);
            DefMsg_IGE := DecodeMessage_IGE(sDefMsg);
            Move(DefMsg_IGE, DefMsg, SizeOf(TDefaultMessage));
          end;

          if DefMsg.Ident = SM_CHARSTATUSCHANGED then begin
            //DecodeMessagePacket(sText1);
            if m_btVersion = 0 then begin
              DefMsg.Param := LoWord(nState);
              DefMsg.Tag := HiWord(nState);
              DefMsg := MakeDefaultMsg(DefMsg.Ident, DefMsg.Recog, DefMsg.Param, DefMsg.Tag, DefMsg.Series);
              sText1 := '#' + EncodeMessage(DefMsg) + '!';
            end else begin
              DefMsg_IGE.Param := LoWord(nState);
              DefMsg_IGE.Tag := HiWord(nState);
              DefMsg_IGE := MakeDefaultMsg_IGE(DefMsg.Ident, DefMsg.Recog, DefMsg.Param, DefMsg.Tag, DefMsg.Series);
              sText1 := '#' + EncodeMessage_IGE(DefMsg_IGE) + '!';
            end;
            //SendOutStr('CharStatusChange2:' + sText1);
          end;
        end;

        if (nLen2 > 0) then begin

          sName := '';
          nLen2 := Pos(m_sWalk, sText);

          sText := _ArrestStringEx(sText, nLen2, '#', '!', sText2);
          //SendOutStr('SM_WALK1:' + sText2);

          if m_btVersion = 0 then begin
            sDefMsg := Copy(sText2, 1, DEFBLOCKSIZE);
            sBody := Copy(sText2, DEFBLOCKSIZE + 1, Length(sText2) - DEFBLOCKSIZE);
            DefMsg := DecodeMessage(sDefMsg);
          end else begin
            sDefMsg := Copy(sText2, 1, 22);
            sBody := Copy(sText2, 22 + 1, Length(sText2) - 22);
            DefMsg_IGE := DecodeMessage_IGE(sDefMsg);
            Move(DefMsg_IGE, DefMsg, SizeOf(TDefaultMessage));
          end;

          //sDefMsg := Copy(sText2, 1, DEFBLOCKSIZE);
          //sBody := Copy(sText2, DEFBLOCKSIZE + 1, Length(sText2) - DEFBLOCKSIZE);

          nData := Length(sBody);
          if nData > m_nCodeMsgSize then begin
            sName := Copy(sBody, m_nCodeMsgSize + 1, nData - m_nCodeMsgSize);
          end;

          //DefMsg := DecodeMessage(sDefMsg);
          if DefMsg.Ident = SM_WALK then begin
            //DecodeMessagePacket(sText2);

            DecodeBuffer(sBody, @CharDesc, SizeOf(TOCharDesc));
            CharDesc.Status := nState;
            sText2 := '#' + sDefMsg + EncodeBuffer(@CharDesc, SizeOf(TOCharDesc)) + sName + '!';
            //SendOutStr('SM_WALK2:' + sText2);
          end;
        end;

        if (nLen3 > 0) then begin
          sName := '';
          nLen3 := Pos(m_sBackStep, sText);

          sText := _ArrestStringEx(sText, nLen3, '#', '!', sText3);


          if m_btVersion = 0 then begin
            sDefMsg := Copy(sText3, 1, DEFBLOCKSIZE);
            sBody := Copy(sText3, DEFBLOCKSIZE + 1, Length(sText3) - DEFBLOCKSIZE);
            DefMsg := DecodeMessage(sDefMsg);
          end else begin
            sDefMsg := Copy(sText3, 1, 22);
            sBody := Copy(sText3, 22 + 1, Length(sText3) - 22);
            DefMsg_IGE := DecodeMessage_IGE(sDefMsg);
            Move(DefMsg_IGE, DefMsg, SizeOf(TDefaultMessage));
          end;

          {sDefMsg := Copy(sText3, 1, DEFBLOCKSIZE);
          sBody := Copy(sText3, DEFBLOCKSIZE + 1, Length(sText3) - DEFBLOCKSIZE); }

          nData := Length(sBody);
          if nData > m_nCodeMsgSize then begin
            sName := Copy(sBody, m_nCodeMsgSize + 1, nData - m_nCodeMsgSize);
          end;
          //DefMsg := DecodeMessage(sDefMsg);
          if DefMsg.Ident = SM_BACKSTEP then begin
            //DecodeMessagePacket(sText3);
            DecodeBuffer(sBody, @CharDesc, SizeOf(TOCharDesc));
            CharDesc.Status := nState;
            sText3 := '#' + sDefMsg + EncodeBuffer(@CharDesc, SizeOf(TOCharDesc)) + sName + '!';
          end;
        end;

        if (nLen4 > 0) then begin
          sName := '';
          nLen4 := Pos(m_sRush, sText);

          sText := _ArrestStringEx(sText, nLen4, '#', '!', sText4);

          if m_btVersion = 0 then begin
            sDefMsg := Copy(sText4, 1, DEFBLOCKSIZE);
            sBody := Copy(sText4, DEFBLOCKSIZE + 1, Length(sText4) - DEFBLOCKSIZE);
            DefMsg := DecodeMessage(sDefMsg);
          end else begin
            sDefMsg := Copy(sText4, 1, 22);
            sBody := Copy(sText4, 22 + 1, Length(sText4) - 22);
            DefMsg_IGE := DecodeMessage_IGE(sDefMsg);
            Move(DefMsg_IGE, DefMsg, SizeOf(TDefaultMessage));
          end;

          {sDefMsg := Copy(sText4, 1, DEFBLOCKSIZE);
          sBody := Copy(sText4, DEFBLOCKSIZE + 1, Length(sText4) - DEFBLOCKSIZE);
                }
          nData := Length(sBody);
          if nData > m_nCodeMsgSize then begin
            sName := Copy(sBody, m_nCodeMsgSize + 1, nData - m_nCodeMsgSize);
            {sBody := DecodeString(sBody);
            sColor := GetValidStr3(sBody, sBody, ['/']); }
          end;
          //DefMsg := DecodeMessage(sDefMsg);
          if DefMsg.Ident = SM_RUSH then begin
            DecodeBuffer(sBody, @CharDesc, SizeOf(TOCharDesc));
            CharDesc.Status := nState;
            sText4 := '#' + sDefMsg + EncodeBuffer(@CharDesc, SizeOf(TOCharDesc)) + sName + '!';
          end;
        end;

        if (nLen5 > 0) then begin
          sName := '';
          nLen5 := Pos(m_sRushKung, sText);

          sText := _ArrestStringEx(sText, nLen5, '#', '!', sText5);
          {sDefMsg := Copy(sText5, 1, DEFBLOCKSIZE);
          sBody := Copy(sText5, DEFBLOCKSIZE + 1, Length(sText5) - DEFBLOCKSIZE);
            }
          if m_btVersion = 0 then begin
            sDefMsg := Copy(sText5, 1, DEFBLOCKSIZE);
            sBody := Copy(sText5, DEFBLOCKSIZE + 1, Length(sText5) - DEFBLOCKSIZE);
            DefMsg := DecodeMessage(sDefMsg);
          end else begin
            sDefMsg := Copy(sText5, 1, DEFBLOCKSIZE + 6);
            sBody := Copy(sText5, DEFBLOCKSIZE + 6 + 1, Length(sText5) - (DEFBLOCKSIZE + 6));
            DefMsg_IGE := DecodeMessage_IGE(sDefMsg);
            Move(DefMsg_IGE, DefMsg, SizeOf(TDefaultMessage));
          end;

          nData := Length(sBody);
          if nData > m_nCodeMsgSize then begin
            sName := Copy(sBody, m_nCodeMsgSize + 1, nData - m_nCodeMsgSize);
          end;
          //DefMsg := DecodeMessage(sDefMsg);
          if DefMsg.Ident = SM_RUSHKUNG then begin
            //DecodeMessagePacket(sText5);
            DecodeBuffer(sBody, @CharDesc, SizeOf(TOCharDesc));
            CharDesc.Status := nState;
            sText5 := '#' + sDefMsg + EncodeBuffer(@CharDesc, SizeOf(TOCharDesc)) + sName + '!';
          end;
        end;

        if (nLen6 > 0) then begin
          //SendOutStr('SM_RUN1:' + sText6);
          sName := '';
          nLen6 := Pos(m_sRun, sText);

          sText := _ArrestStringEx(sText, nLen6, '#', '!', sText6);
          {sDefMsg := Copy(sText6, 1, DEFBLOCKSIZE);
          sBody := Copy(sText6, DEFBLOCKSIZE + 1, Length(sText6) - DEFBLOCKSIZE);}

          if m_btVersion = 0 then begin
            sDefMsg := Copy(sText6, 1, DEFBLOCKSIZE);
            sBody := Copy(sText6, DEFBLOCKSIZE + 1, Length(sText6) - DEFBLOCKSIZE);
            DefMsg := DecodeMessage(sDefMsg);
          end else begin
            sDefMsg := Copy(sText6, 1, 22);
            sBody := Copy(sText6, 22 + 1, Length(sText6) - 22);
            DefMsg_IGE := DecodeMessage_IGE(sDefMsg);
            Move(DefMsg_IGE, DefMsg, SizeOf(TDefaultMessage));
          end;

          nData := Length(sBody);
          if nData > m_nCodeMsgSize then begin
            sName := Copy(sBody, m_nCodeMsgSize + 1, nData - m_nCodeMsgSize);
            {sBody := DecodeString(sBody);
            sColor := GetValidStr3(sBody, sBody, ['/']); }
          end;
          //DefMsg := DecodeMessage(sDefMsg);
          if DefMsg.Ident = SM_RUN then begin
            DecodeBuffer(sBody, @CharDesc, SizeOf(TOCharDesc));
            CharDesc.Status := nState;
            sText6 := '#' + sDefMsg + EncodeBuffer(@CharDesc, SizeOf(TOCharDesc)) + sName + '!';
           // SendOutStr('SM_RUN2:' + sText6);
          end;
        end;

        if (nLen7 > 0) then begin
          sName := '';
          nLen7 := Pos(m_sHorseRun, sText);

          sText := _ArrestStringEx(sText, nLen7, '#', '!', sText7);
          {sDefMsg := Copy(sText7, 1, DEFBLOCKSIZE);
          sBody := Copy(sText7, DEFBLOCKSIZE + 1, Length(sText7) - DEFBLOCKSIZE);  }
          if m_btVersion = 0 then begin
            sDefMsg := Copy(sText7, 1, DEFBLOCKSIZE);
            sBody := Copy(sText7, DEFBLOCKSIZE + 1, Length(sText7) - DEFBLOCKSIZE);
            DefMsg := DecodeMessage(sDefMsg);
          end else begin
            sDefMsg := Copy(sText7, 1, 22);
            sBody := Copy(sText7, 22 + 1, Length(sText7) - 22);
            DefMsg_IGE := DecodeMessage_IGE(sDefMsg);
            Move(DefMsg_IGE, DefMsg, SizeOf(TDefaultMessage));
          end;

          nData := Length(sBody);
          if nData > m_nCodeMsgSize then begin
            sName := Copy(sBody, m_nCodeMsgSize + 1, nData - m_nCodeMsgSize);
            {sBody := DecodeString(sBody);
            sColor := GetValidStr3(sBody, sBody, ['/']); }
          end;
          //DefMsg := DecodeMessage(sDefMsg);
          if DefMsg.Ident = SM_HORSERUN then begin
            DecodeBuffer(sBody, @CharDesc, SizeOf(TOCharDesc));
            CharDesc.Status := nState;
            sText7 := '#' + sDefMsg + EncodeBuffer(@CharDesc, SizeOf(TOCharDesc)) + sName + '!';
          end;
        end;

        if (nLen8 > 0) then begin
          sName := '';
          nLen8 := Pos(m_sDigup, sText);

          sText := _ArrestStringEx(sText, nLen8, '#', '!', sText8);
         { sDefMsg := Copy(sText8, 1, DEFBLOCKSIZE);
          sBody := Copy(sText8, DEFBLOCKSIZE + 1, Length(sText8) - DEFBLOCKSIZE);
          }
          if m_btVersion = 0 then begin
            sDefMsg := Copy(sText8, 1, DEFBLOCKSIZE);
            sBody := Copy(sText8, DEFBLOCKSIZE + 1, Length(sText8) - DEFBLOCKSIZE);
            DefMsg := DecodeMessage(sDefMsg);
          end else begin
            sDefMsg := Copy(sText8, 1, 22);
            sBody := Copy(sText8, 22 + 1, Length(sText8) - 22);
            DefMsg_IGE := DecodeMessage_IGE(sDefMsg);
            Move(DefMsg_IGE, DefMsg, SizeOf(TDefaultMessage));
          end;
          //DefMsg := DecodeMessage(sDefMsg);
          if DefMsg.Ident = SM_DIGUP then begin
            //DecodeMessagePacket(sText8);
            DecodeBuffer(sBody, @MessageBodyWL, SizeOf(TMessageBodyWL));
            MessageBodyWL.lParam2 := nState;
            sText8 := '#' + sDefMsg + EncodeBuffer(@MessageBodyWL, SizeOf(TMessageBodyWL)) + '!';
          end;
        end;

        if (nLen9 > 0) then begin
          sName := '';
          nLen9 := Pos(m_sAlive, sText);
          sText := _ArrestStringEx(sText, nLen9, '#', '!', sText9);
          {sDefMsg := Copy(sText9, 1, DEFBLOCKSIZE);
          sBody := Copy(sText9, DEFBLOCKSIZE + 1, Length(sText9) - DEFBLOCKSIZE);
               }
          if m_btVersion = 0 then begin
            sDefMsg := Copy(sText9, 1, DEFBLOCKSIZE);
            sBody := Copy(sText9, DEFBLOCKSIZE + 1, Length(sText9) - DEFBLOCKSIZE);
            DefMsg := DecodeMessage(sDefMsg);
          end else begin
            sDefMsg := Copy(sText9, 1, 22);
            sBody := Copy(sText9, 22 + 1, Length(sText9) - 22);
            DefMsg_IGE := DecodeMessage_IGE(sDefMsg);
            Move(DefMsg_IGE, DefMsg, SizeOf(TDefaultMessage));
          end;

          nData := Length(sBody);
          if nData > m_nCodeMsgSize then begin
            sName := Copy(sBody, m_nCodeMsgSize + 1, nData - m_nCodeMsgSize);
            {sBody := DecodeString(sBody);
            sColor := GetValidStr3(sBody, sBody, ['/']); }
          end;
          //DefMsg := DecodeMessage(sDefMsg);
          if DefMsg.Ident = SM_HORSERUN then begin
            DecodeBuffer(sBody, @CharDesc, SizeOf(TOCharDesc));
            CharDesc.Status := nState;
            sText9 := '#' + sDefMsg + EncodeBuffer(@CharDesc, SizeOf(TOCharDesc)) + sName + '!';
          end;
        end;
        sData := sText + sText1 + sText2 + sText3 + sText4 + sText5 + sText6 + sText7 + sText8 + sText9;

        if boHave and (Pos('*', sData) <= 0) then
          sData := sData + '*';
      end;
    end;
  end;
end;

procedure TGameEngine.Run;
var
  Str, Data: string;
  len, I, n, mcnt: Integer;
  MainHDC: HDC;
  MainCanvas: TCanvas;
  Actor: TActor;
  nIdx: Integer;
  movetick: Boolean;
begin
  EnterCriticalSection(m_UserCriticalSection);
  try
    m_sSendBufferText := m_sSendBufferText + m_sSendSockText;
    m_sSendSockText := '';
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;

  while Length(m_sSendBufferText) >= 2 do begin
    if Pos('!', m_sSendBufferText) <= 0 then Break;
    m_sSendBufferText := ArrestStringEx(m_sSendBufferText, '#', '!', Data);
    if Data = '' then Break;
    DecodeSendMessagePacket(Data);
    if Pos('!', m_sSendBufferText) <= 0 then Break;
  end;

  EnterCriticalSection(m_UserCriticalSection);
  try
    m_sBufferText := m_sBufferText + m_sSockText;
    m_sSockText := '';
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;

  while Length(m_sBufferText) >= 2 do begin
    if Pos('!', m_sBufferText) <= 0 then Break;
    m_sBufferText := ArrestStringEx(m_sBufferText, '#', '!', Data);
    if Data = '' then Break;
    DecodeMessagePacket(Data);
    if Pos('!', m_sBufferText) <= 0 then Break;
  end;

  try
   { movetick := False;
    if GetTickCount - m_dwMoveTime >= 100 then begin
      m_dwMoveTime := GetTickCount;
      movetick := True;
    end;  }
    nIdx := 0;
    while True do begin
      if nIdx >= m_ActorList.Count then Break;
      Actor := TActor(m_ActorList.Items[nIdx]);
      Actor.ProcMsg;
      Actor.ProcHurryMsg;
      if Actor.m_nWaitForRecogId <> 0 then begin
        if Actor.IsIdle then begin
          DelChangeFace(Actor.m_nWaitForRecogId);
          NewActor(Actor.m_nWaitForRecogId, Actor.m_nCurrX, Actor.m_nCurrY, Actor.m_btDir, Actor.m_nWaitForFeature, Actor.m_nWaitForStatus);
          Actor.m_nWaitForRecogId := 0;
          Actor.m_boDelActor := True;
        end;
      end;
      if Actor.m_boDelActor then begin
        m_ActorList.Delete(nIdx);
        AddFreeDeleteActor(Actor);
        //m_FreeActorList.Add(Actor);
        if m_TargetCret = Actor then m_TargetCret := nil;
        if m_FocusCret = Actor then m_FocusCret := nil;
        if m_MagicTarget = Actor then m_MagicTarget := nil;
      end else Inc(nIdx);
    end;
    FreeDeleteActor;
    ClearDropItem;
  except
    SendOutStr('TGameEngine.Run');
  end;
  if (GameSocket.Socket <> 0) and (GetTickCount - GameSocket.m_dwReviceTick > 100) then begin
    GameSocket.m_dwReviceTick := GetTickCount;
    if GameSocket.ReviceText <> '' then begin
      SendMessage(g_HSocketHwnd, g_CM_SOCKETMESSAGE, GameSocket.Socket, MakeLong($01, 0));
    end;
  end;
end;

procedure TGameEngine.Lock;
begin
  EnterCriticalSection(m_UserCriticalSection);
end;

procedure TGameEngine.UnLock;
begin
  LeaveCriticalSection(m_UserCriticalSection);
end;

procedure TGameEngine.ClientGetReconnect(sBody: string);
begin

end;

procedure TGameEngine.ClientGetUserLogin(DefMsg: TDefaultMessage;
  sData: string);
var
  MsgWL: TMessageBodyWL;
begin
  if FCheckCode <> 0 then Exit;
  m_dwCheckTick := GetTickCount;
  DecodeBuffer(sData, @MsgWL, SizeOf(TMessageBodyWL));
  SendMsg(DefMsg.ident, DefMsg.Recog, DefMsg.param {x}, DefMsg.tag {y}, DefMsg.series {dir}, MsgWL.lParam1 {desc.Feature}, MsgWL.lParam2 {desc.Status}, '');
  //m_boUserLogin := True;

  {
  SendClientMessage(CM_QUERYBAGITEMS, 0, 0, 0, 0);
  SendClientMessage(CM_GETREGINFO, CSocket.Socket.Handle, 0, 0, 0);
  }
  if LoByte(Loword(MsgWL.lTag1)) = 1 then m_boAllowGroup := True
  else m_boAllowGroup := False;

 // g_boServerChanging := False;}
end;

procedure TGameEngine.ClientGetNewMap(DefMsg: TDefaultMessage; sData: string);
var
  sText: string;
begin
  m_sMapTitle := '';
  sText := DecodeString(sData);
  //g_sMapName := sText;
  SendMsg(DefMsg.ident, 0,
    DefMsg.param {x},
    DefMsg.tag {y},
    DefMsg.series {darkness},
    0, 0,
    sText {mapname});
end;

procedure TGameEngine.ClientGetObjTurn(DefMsg: TDefaultMessage;
  sData: string);
var
  sBody2: string;
  sBody: string;
  sColor: string;

  CharDesc: TOCharDesc;

  feature: Integer;
  Status: Integer;
  Actor: TActor;
  nData: Integer;
begin
  sBody := '';
  nData := Length(sData);
  if nData > m_nCodeMsgSize then begin
    sBody := Copy(sData, m_nCodeMsgSize + 1, nData - m_nCodeMsgSize);
    sBody := DecodeString(sBody);
    sColor := GetValidStr3(sBody, sBody, ['/']);
  end;
  if nData >= m_nCodeMsgSize then begin
    DecodeBuffer(sData, @CharDesc, SizeOf(TOCharDesc));
    feature := CharDesc.feature;
    Status := CharDesc.Status;

    SendMsg(DefMsg.ident,
      DefMsg.Recog,
      DefMsg.param {x},
      DefMsg.tag {y},
      DefMsg.series {dir + light},
      feature,
      Status,
      '');
    if sBody <> '' then begin
      Actor := FindActor(DefMsg.Recog);
      if Actor <> nil then begin
        Actor.m_sDescUserName := GetValidStr3(sBody, Actor.m_sUserName, ['\']);
      //Actor.UserName := sBody;    SM_TURN

        Actor.m_nNameColor := GetRGB(Str_ToInt(sColor, 0));
      end;
    end;
  end;
end;

procedure TGameEngine.ClientGetBackStep(DefMsg: TDefaultMessage;
  sData: string);
var
  sBody2: string;
  sBody: string;
  sColor: string;
  CharDesc: TOCharDesc;

  feature: Integer;
  Status: Integer;
  Actor: TActor;
  nData: Integer;
begin
  sBody := '';
  nData := Length(sData);
  if nData > m_nCodeMsgSize then begin
    sBody := Copy(sData, m_nCodeMsgSize + 1, nData - m_nCodeMsgSize);
    sBody := DecodeString(sBody);
    sColor := GetValidStr3(sBody, sBody, ['/']);
  end;
  if nData >= m_nCodeMsgSize then begin
    DecodeBuffer(sData, @CharDesc, SizeOf(TOCharDesc));
    feature := CharDesc.feature;
    Status := CharDesc.Status;

    SendMsg(DefMsg.ident,
      DefMsg.Recog,
      DefMsg.param {x},
      DefMsg.tag {y},
      DefMsg.series {dir + light},
      feature,
      Status,
      '');
    if sBody <> '' then begin
      Actor := FindActor(DefMsg.Recog);
      if Actor <> nil then begin
        Actor.m_sDescUserName := GetValidStr3(sBody, Actor.m_sUserName, ['\']);
      //Actor.UserName := sBody;
        Actor.m_nNameColor := GetRGB(Str_ToInt(sColor, 0));
      end;
    end;
  end;
end;

procedure TGameEngine.ClientSpaceMoveHide(DefMsg: TDefaultMessage);
begin
  if DefMsg.Recog <> m_MySelf.m_nRecogId then begin
    SendMsg(DefMsg.ident, DefMsg.Recog, DefMsg.param {x}, DefMsg.tag {y}, 0, 0, 0, '')
  end;
end;

procedure TGameEngine.ClientSpaceMoveShow(DefMsg: TDefaultMessage;
  sData: string);
var
  sBody2: string;
  sBody: string;
  sColor: string;
  CharDesc: TOCharDesc;

  feature: Integer;
  Status: Integer;
  Actor: TActor;
  nData: Integer;
begin
  sBody := '';
  nData := Length(sData);
  if nData > m_nCodeMsgSize then begin
    sBody := Copy(sData, m_nCodeMsgSize + 1, nData - m_nCodeMsgSize);
    sBody := DecodeString(sBody);
    sColor := GetValidStr3(sBody, sBody, ['/']);
  end;
  if nData >= m_nCodeMsgSize then begin
    DecodeBuffer(sData, @CharDesc, SizeOf(TOCharDesc));
    feature := CharDesc.feature;
    Status := CharDesc.Status;

    if DefMsg.Recog <> m_MySelf.m_nRecogId then begin
      NewActor(DefMsg.Recog, DefMsg.param, DefMsg.tag, DefMsg.series, feature, Status);

    end;
    SendMsg(DefMsg.ident,
      DefMsg.Recog,
      DefMsg.param {x},
      DefMsg.tag {y},
      DefMsg.series {dir + light},
      feature,
      Status,
      '');
    if sBody <> '' then begin
      Actor := FindActor(DefMsg.Recog);
      if Actor <> nil then begin
        Actor.m_sDescUserName := GetValidStr3(sBody, Actor.m_sUserName, ['\']);
        Actor.m_nNameColor := GetRGB(Str_ToInt(sColor, 0));

        if (m_MySelf <> nil) and (Actor <> nil) and (not Actor.m_boDeath) then
          m_ShowBossList.Hint(Actor);
      end;
    end;
  end;
end;

procedure TGameEngine.ClientObjWalk(DefMsg: TDefaultMessage;
  sData: string);
var
  CharDesc: TOCharDesc;
  feature: Integer;
  Status: Integer;
begin
  //SendOutStr('Length(sData):'+IntToStr(Length(sData)));
  if Length(sData) >= m_nCodeMsgSize then begin
    DecodeBuffer(sData, @CharDesc, SizeOf(TOCharDesc));
    feature := CharDesc.feature;
    Status := CharDesc.Status;

    if (DefMsg.Recog <> m_MySelf.m_nRecogId) or (DefMsg.ident = SM_RUSH) or (DefMsg.ident = SM_RUSHKUNG) then
      SendMsg(DefMsg.ident, DefMsg.Recog,
        DefMsg.param {x},
        DefMsg.tag {y},
        DefMsg.series {dir+light},
        feature,
        Status, '');
        //AddChatBoardString(m_sUserName + ' X:' + IntToStr(m_nCurrX) + ' Y:' + IntToStr(m_nCurrY), 255, 253);
    //if DefMsg.ident = SM_RUSH then m_dwLatestRushRushTick := GetTickCount;
  end;
end;

procedure TGameEngine.ClientObjRun(DefMsg: TDefaultMessage;
  sData: string);
var
  CharDesc: TOCharDesc;
  feature: Integer;
  Status: Integer;
begin
  if Length(sData) >= m_nCodeMsgSize then begin
    DecodeBuffer(sData, @CharDesc, SizeOf(TOCharDesc));
    feature := CharDesc.feature;
    Status := CharDesc.Status;
    if DefMsg.Recog <> m_MySelf.m_nRecogId then
      SendMsg(DefMsg.ident, DefMsg.Recog,
        DefMsg.param {x},
        DefMsg.tag {y},
        DefMsg.series {dir+light},
        feature,
        Status, '');
  end;
end;

procedure TGameEngine.ClientLampChangeDura(DefMsg: TDefaultMessage);
begin
  case m_btVersion of
    0: if m_UseItems_BLUE[U_RIGHTHAND].s.Name <> '' then begin
        m_UseItems_BLUE[U_RIGHTHAND].Dura := DefMsg.Recog;
      end;
    1: if m_UseItems_IGE[U_RIGHTHAND].s.Name <> '' then begin
        m_UseItems_IGE[U_RIGHTHAND].Dura := DefMsg.Recog;
      end;
  end;
end;

procedure TGameEngine.ClientObjMoveFail(DefMsg: TDefaultMessage;
  sData: string);
var
  CharDesc: TOCharDesc;

  feature: Integer;
  Status: Integer;
begin
  if Length(sData) >= m_nCodeMsgSize then begin

    DecodeBuffer(sData, @CharDesc, SizeOf(TOCharDesc));
    feature := CharDesc.feature;
    Status := CharDesc.Status;

    if DefMsg.Recog <> m_MySelf.m_nRecogId then
      SendMsg(SM_TURN, DefMsg.Recog,
        DefMsg.param {x},
        DefMsg.tag {y},
        DefMsg.series {dir+light},
        feature,
        Status, '');
  end;
end;

procedure TGameEngine.ClientObjTakeOnOK(DefMsg: TDefaultMessage);
begin
  if m_MySelf <> nil then begin
    m_MySelf.m_nFeature := DefMsg.Recog;
    m_MySelf.FeatureChanged;
  end;
  case m_btVersion of
    0: begin
        if m_WaitingUseItem_BLUE.Index in [0..12] then
          m_UseItems_BLUE[m_WaitingUseItem_BLUE.Index] := m_WaitingUseItem_BLUE.Item;
        m_WaitingUseItem_BLUE.Item.s.Name := '';
      end;
    1: begin
        if m_WaitingUseItem_IGE.Index in [0..12] then
          m_UseItems_IGE[m_WaitingUseItem_IGE.Index] := m_WaitingUseItem_IGE.Item;
        m_WaitingUseItem_IGE.Item.s.Name := '';
      end;
  end;
end;

procedure TGameEngine.ClientObjTakeOnFail();
begin
  case m_btVersion of
    0: begin
        AddItemBag_BLUE(m_WaitingUseItem_BLUE.Item);
        m_WaitingUseItem_BLUE.Item.s.Name := '';
      end;
    1: begin
        AddItemBag_IGE(m_WaitingUseItem_IGE.Item);
        m_WaitingUseItem_IGE.Item.s.Name := '';
      end;
  end;
end;

procedure TGameEngine.ClientObjTakeOffOK(DefMsg: TDefaultMessage);
begin
  if m_MySelf <> nil then begin
    m_MySelf.m_nFeature := DefMsg.Recog;
    m_MySelf.FeatureChanged;
  end;
  case m_btVersion of
    0: begin
        m_WaitingUseItem_BLUE.Item.s.Name := '';
      end;
    1: begin
        m_WaitingUseItem_IGE.Item.s.Name := '';
      end;
  end;
end;

procedure TGameEngine.ClientObjTakeOffFail();
var
  nIndex: Integer;
begin
  case m_btVersion of
    0: begin
        if m_WaitingUseItem_BLUE.Index < 0 then begin
          nIndex := -(m_WaitingUseItem_BLUE.Index + 1);
          m_UseItems_BLUE[nIndex] := m_WaitingUseItem_BLUE.Item;
        end;
        m_WaitingUseItem_BLUE.Item.s.Name := '';
      end;
    1: begin
        if m_WaitingUseItem_IGE.Index < 0 then begin
          nIndex := -(m_WaitingUseItem_IGE.Index + 1);
          m_UseItems_IGE[nIndex] := m_WaitingUseItem_IGE.Item;
        end;
        m_WaitingUseItem_IGE.Item.s.Name := '';
      end;
  end;
end;

procedure TGameEngine.ClientObjWeigthChanged(DefMsg: TDefaultMessage);
begin
  if m_MySelf <> nil then begin
    case m_btVersion of
      0: begin
          m_MySelf.m_Abil_BLUE.Weight := DefMsg.Recog;
          m_MySelf.m_Abil_BLUE.WearWeight := DefMsg.param;
          m_MySelf.m_Abil_BLUE.HandWeight := DefMsg.tag;
        end;
      1: begin
          m_MySelf.m_Abil_IGE.Weight := DefMsg.Recog;
          m_MySelf.m_Abil_IGE.WearWeight := DefMsg.param;
          m_MySelf.m_Abil_IGE.HandWeight := DefMsg.tag;
        end;
    end;
  end;
end;

procedure TGameEngine.ClientObjGoldChanged(DefMsg: TDefaultMessage);
begin
  if m_MySelf <> nil then begin
    if DefMsg.Recog > m_MySelf.m_nGold then begin
    //DScreen.AddSysMsg(IntToStr(DefMsg.Recog - m_MySelf.m_nGold) + ' ' + m_sGoldName + ' 被发现.', 30, 40, clAqua);
    end;
    m_MySelf.m_nGold := DefMsg.Recog;
    m_MySelf.m_nGameGold := MakeLong(DefMsg.param, DefMsg.tag);
  end;
end;

procedure TGameEngine.ClientObjCleanObjects();
begin
  ClearActors;
  m_boMapMoving := True;
end;

procedure TGameEngine.ClientObjEatOK();
var
  Msg: TDefaultMessage;
  Msg_IGE: TDefaultMessage_IGE;
begin //吃物品成功
  if m_MySelf = nil then Exit;
  //SendOutStr('TGameEngine.ClientObjEatOK();');
  case m_btVersion of
    0: begin
        if (m_EatingItem.BLUE.s.Name <> '') and (m_EatingItem2.BLUE.s.Name <> '') then begin
          if m_EatingItem.nIndex = 0 then begin
            if not m_EatingItem.boSend then begin
              Msg := MakeDefaultMsg(SM_DELITEMS, m_MySelf.m_nRecogId, 0, 0, 1);
              GameSocket.SendToClient(EncodeMessage(Msg) + EncodeString(m_EatingItem.BLUE.s.Name + '/' + IntToStr(m_EatingItem.BLUE.MakeIndex)));
            end;
            DelItemBag(m_EatingItem.BLUE.s.Name, m_EatingItem.BLUE.MakeIndex);
            DelHeroItemBag(m_EatingItem.BLUE.s.Name, m_EatingItem.BLUE.MakeIndex);
            m_EatingItem.BLUE.s.Name := '';
          end else begin
            if not m_EatingItem2.boSend then begin
              Msg := MakeDefaultMsg(SM_DELITEMS, m_MySelf.m_nRecogId, 0, 0, 1);
              GameSocket.SendToClient(EncodeMessage(Msg) + EncodeString(m_EatingItem2.BLUE.s.Name + '/' + IntToStr(m_EatingItem2.BLUE.MakeIndex)));
            end;
            DelItemBag(m_EatingItem2.BLUE.s.Name, m_EatingItem2.BLUE.MakeIndex);
            DelHeroItemBag(m_EatingItem2.BLUE.s.Name, m_EatingItem2.BLUE.MakeIndex);
            m_EatingItem2.BLUE.s.Name := '';
          end;
        end else
          if (m_EatingItem.BLUE.s.Name <> '') and (m_EatingItem2.BLUE.s.Name = '') then begin
          if not m_EatingItem.boSend then begin
            Msg := MakeDefaultMsg(SM_DELITEMS, m_MySelf.m_nRecogId, 0, 0, 1);
            GameSocket.SendToClient(EncodeMessage(Msg) + EncodeString(m_EatingItem.BLUE.s.Name + '/' + IntToStr(m_EatingItem.BLUE.MakeIndex)));
          end;

          DelItemBag(m_EatingItem.BLUE.s.Name, m_EatingItem.BLUE.MakeIndex);
          DelHeroItemBag(m_EatingItem.BLUE.s.Name, m_EatingItem.BLUE.MakeIndex);
          m_EatingItem.BLUE.s.Name := '';
        end else
          if (m_EatingItem.BLUE.s.Name = '') and (m_EatingItem2.BLUE.s.Name <> '') then begin
          if not m_EatingItem2.boSend then begin
            Msg := MakeDefaultMsg(SM_DELITEMS, m_MySelf.m_nRecogId, 0, 0, 1);
            GameSocket.SendToClient(EncodeMessage(Msg) + EncodeString(m_EatingItem2.BLUE.s.Name + '/' + IntToStr(m_EatingItem2.BLUE.MakeIndex)));
          end;
          DelItemBag(m_EatingItem2.BLUE.s.Name, m_EatingItem2.BLUE.MakeIndex);
          DelHeroItemBag(m_EatingItem2.BLUE.s.Name, m_EatingItem2.BLUE.MakeIndex);
          m_EatingItem2.BLUE.s.Name := '';
        end;
      end;
    1: begin
        if (m_EatingItem.IGE.s.Name <> '') and (m_EatingItem2.IGE.s.Name <> '') then begin
          if m_EatingItem.nIndex = 0 then begin
            if not m_EatingItem.boSend then begin
              Msg_IGE := MakeDefaultMsg_IGE(SM_DELITEMS, m_MySelf.m_nRecogId, 0, 0, 1);
              GameSocket.SendToClient(EncodeMessage_IGE(Msg_IGE) + EncodeString(m_EatingItem.IGE.s.Name + '/' + IntToStr(m_EatingItem.IGE.MakeIndex)));
            end;
            DelItemBag(m_EatingItem.IGE.s.Name, m_EatingItem.IGE.MakeIndex);
            DelHeroItemBag(m_EatingItem.IGE.s.Name, m_EatingItem.IGE.MakeIndex);
            m_EatingItem.IGE.s.Name := '';
          end else begin
            if not m_EatingItem2.boSend then begin
              Msg_IGE := MakeDefaultMsg_IGE(SM_DELITEMS, m_MySelf.m_nRecogId, 0, 0, 1);
              GameSocket.SendToClient(EncodeMessage_IGE(Msg_IGE) + EncodeString(m_EatingItem2.IGE.s.Name + '/' + IntToStr(m_EatingItem2.IGE.MakeIndex)));
            end;
            DelItemBag(m_EatingItem2.IGE.s.Name, m_EatingItem2.IGE.MakeIndex);
            DelHeroItemBag(m_EatingItem2.IGE.s.Name, m_EatingItem2.IGE.MakeIndex);
            m_EatingItem2.IGE.s.Name := '';
          end;
        end else
          if (m_EatingItem.IGE.s.Name <> '') and (m_EatingItem2.IGE.s.Name = '') then begin
          if not m_EatingItem.boSend then begin
            Msg_IGE := MakeDefaultMsg_IGE(SM_DELITEMS, m_MySelf.m_nRecogId, 0, 0, 1);
            GameSocket.SendToClient(EncodeMessage_IGE(Msg_IGE) + EncodeString(m_EatingItem.IGE.s.Name + '/' + IntToStr(m_EatingItem.IGE.MakeIndex)));
          end;
          DelItemBag(m_EatingItem.IGE.s.Name, m_EatingItem.IGE.MakeIndex);
          DelHeroItemBag(m_EatingItem.IGE.s.Name, m_EatingItem.IGE.MakeIndex);
          m_EatingItem.IGE.s.Name := '';
        end else
          if (m_EatingItem.IGE.s.Name = '') and (m_EatingItem2.IGE.s.Name <> '') then begin
          if not m_EatingItem2.boSend then begin
            Msg_IGE := MakeDefaultMsg_IGE(SM_DELITEMS, m_MySelf.m_nRecogId, 0, 0, 1);
            GameSocket.SendToClient(EncodeMessage_IGE(Msg_IGE) + EncodeString(m_EatingItem2.IGE.s.Name + '/' + IntToStr(m_EatingItem2.IGE.MakeIndex)));
          end;
          DelItemBag(m_EatingItem2.IGE.s.Name, m_EatingItem2.IGE.MakeIndex);
          DelHeroItemBag(m_EatingItem2.IGE.s.Name, m_EatingItem2.IGE.MakeIndex);
          m_EatingItem2.IGE.s.Name := '';
        end;
      end;
  end;
  ArrangeItemBag;
end;

procedure TGameEngine.ClientObjEatFail();
begin //吃物品失败
  //SendOutStr('TGameEngine.ClientObjEatFail();');
  case m_btVersion of
    0: begin
        if (m_EatingItem.BLUE.s.Name <> '') and (m_EatingItem2.BLUE.s.Name <> '') then begin
          if m_EatingItem.nIndex = 0 then begin
            AddItemBag_BLUE(m_EatingItem.BLUE);
            m_EatingItem.BLUE.s.Name := '';
          end else begin
            AddItemBag_BLUE(m_EatingItem2.BLUE);
            m_EatingItem2.BLUE.s.Name := '';
          end;
        end else
          if (m_EatingItem.BLUE.s.Name <> '') and (m_EatingItem2.BLUE.s.Name = '') then begin
          AddItemBag_BLUE(m_EatingItem.BLUE);
          m_EatingItem.BLUE.s.Name := '';
        end else
          if (m_EatingItem.BLUE.s.Name = '') and (m_EatingItem2.BLUE.s.Name <> '') then begin
          AddItemBag_BLUE(m_EatingItem2.BLUE);
          m_EatingItem2.BLUE.s.Name := '';
        end;
      end;
    1: begin
        if (m_EatingItem.IGE.s.Name <> '') and (m_EatingItem2.IGE.s.Name <> '') then begin
          if m_EatingItem.nIndex = 0 then begin
            AddItemBag_IGE(m_EatingItem.IGE);
            m_EatingItem.IGE.s.Name := '';
          end else begin
            AddItemBag_IGE(m_EatingItem2.IGE);
            m_EatingItem2.IGE.s.Name := '';
          end;
        end else
          if (m_EatingItem.IGE.s.Name <> '') and (m_EatingItem2.IGE.s.Name = '') then begin
          AddItemBag_IGE(m_EatingItem.IGE);
          m_EatingItem.IGE.s.Name := '';
        end else
          if (m_EatingItem.IGE.s.Name = '') and (m_EatingItem2.IGE.s.Name <> '') then begin
          AddItemBag_IGE(m_EatingItem2.IGE);
          m_EatingItem2.IGE.s.Name := '';
        end;
      end;
  end;
end;

procedure TGameEngine.ClientObjHeroEatOK();
var
  Msg: TDefaultMessage;
  Msg_IGE: TDefaultMessage_IGE;
begin //英雄吃物品成功
  //SendOutStr('TGameEngine.ClientObjHeroEatOK();');
  if m_MyHero <> nil then begin
    case m_btVersion of
      0: begin
          if (m_HeroEatingItem.BLUE.s.Name <> '') and (m_HeroEatingItem2.BLUE.s.Name <> '') then begin
            if m_HeroEatingItem.nIndex = 0 then begin
              if not m_HeroEatingItem.boSend then begin
                Msg := MakeDefaultMsg(BLUE_READ_906, m_MyHero.m_nRecogId, 0, 0, 1);
                GameSocket.SendToClient(EncodeMessage(Msg) + EncodeBuffer(@m_HeroEatingItem.BLUE, SizeOf(TClientItem_BLUE)));
              end;
              DelItemBag(m_HeroEatingItem.BLUE.s.Name, m_HeroEatingItem.BLUE.MakeIndex);
              DelHeroItemBag(m_HeroEatingItem.BLUE.s.Name, m_HeroEatingItem.BLUE.MakeIndex);
              m_HeroEatingItem.BLUE.s.Name := '';
            end else begin
              if not m_HeroEatingItem2.boSend then begin
                Msg := MakeDefaultMsg(BLUE_READ_906, m_MyHero.m_nRecogId, 0, 0, 1);
                GameSocket.SendToClient(EncodeMessage(Msg) + EncodeBuffer(@m_HeroEatingItem2.BLUE, SizeOf(TClientItem_BLUE)));
              end;
              DelItemBag(m_HeroEatingItem2.BLUE.s.Name, m_HeroEatingItem2.BLUE.MakeIndex);
              DelHeroItemBag(m_HeroEatingItem2.BLUE.s.Name, m_HeroEatingItem2.BLUE.MakeIndex);
              m_HeroEatingItem2.BLUE.s.Name := '';
            end;
          end else
            if (m_HeroEatingItem.BLUE.s.Name <> '') and (m_HeroEatingItem2.BLUE.s.Name = '') then begin
            if not m_HeroEatingItem.boSend then begin
              Msg := MakeDefaultMsg(BLUE_READ_906, m_MyHero.m_nRecogId, 0, 0, 1);
              GameSocket.SendToClient(EncodeMessage(Msg) + EncodeBuffer(@m_HeroEatingItem.BLUE, SizeOf(TClientItem_BLUE)));
            end;
            DelItemBag(m_HeroEatingItem.BLUE.s.Name, m_HeroEatingItem.BLUE.MakeIndex);
            DelHeroItemBag(m_HeroEatingItem.BLUE.s.Name, m_HeroEatingItem.BLUE.MakeIndex);
            m_HeroEatingItem.BLUE.s.Name := '';
          end else
            if (m_HeroEatingItem.BLUE.s.Name = '') and (m_HeroEatingItem2.BLUE.s.Name <> '') then begin
            if not m_HeroEatingItem2.boSend then begin
              Msg := MakeDefaultMsg(BLUE_READ_906, m_MyHero.m_nRecogId, 0, 0, 1);
              GameSocket.SendToClient(EncodeMessage(Msg) + EncodeBuffer(@m_HeroEatingItem2.BLUE, SizeOf(TClientItem_BLUE)));
            end;
            DelItemBag(m_HeroEatingItem2.BLUE.s.Name, m_HeroEatingItem2.BLUE.MakeIndex);
            DelHeroItemBag(m_HeroEatingItem2.BLUE.s.Name, m_HeroEatingItem2.BLUE.MakeIndex);
            m_HeroEatingItem2.BLUE.s.Name := '';
          end;
        end;
      1: begin
          if (m_HeroEatingItem.IGE.s.Name <> '') and (m_HeroEatingItem2.IGE.s.Name <> '') then begin
            if m_HeroEatingItem.nIndex = 0 then begin
              if not m_HeroEatingItem.boSend then begin
                Msg_IGE := MakeDefaultMsg_IGE(SM_IGE_5035, m_MyHero.m_nRecogId, 0, 0, 1);
                GameSocket.SendToClient(EncodeMessage_IGE(Msg_IGE) + EncodeBuffer(@m_HeroEatingItem.IGE, SizeOf(TClientItem_IGE)));
              end;
              DelItemBag(m_HeroEatingItem.IGE.s.Name, m_HeroEatingItem.IGE.MakeIndex);
              DelHeroItemBag(m_HeroEatingItem.IGE.s.Name, m_HeroEatingItem.IGE.MakeIndex);
              m_HeroEatingItem.IGE.s.Name := '';
            end else begin
              if not m_HeroEatingItem2.boSend then begin
                Msg_IGE := MakeDefaultMsg_IGE(SM_IGE_5035, m_MyHero.m_nRecogId, 0, 0, 1);
                GameSocket.SendToClient(EncodeMessage_IGE(Msg_IGE) + EncodeBuffer(@m_HeroEatingItem2.IGE, SizeOf(TClientItem_IGE)));
              end;
              DelItemBag(m_HeroEatingItem2.IGE.s.Name, m_HeroEatingItem2.IGE.MakeIndex);
              DelHeroItemBag(m_HeroEatingItem2.IGE.s.Name, m_HeroEatingItem2.IGE.MakeIndex);
              m_HeroEatingItem2.IGE.s.Name := '';
            end;
          end else
            if (m_HeroEatingItem.IGE.s.Name <> '') and (m_HeroEatingItem2.IGE.s.Name = '') then begin
            if not m_HeroEatingItem.boSend then begin
              Msg_IGE := MakeDefaultMsg_IGE(SM_IGE_5035, m_MyHero.m_nRecogId, 0, 0, 1);
              GameSocket.SendToClient(EncodeMessage_IGE(Msg_IGE) + EncodeBuffer(@m_HeroEatingItem.IGE, SizeOf(TClientItem_IGE)));
            end;
            DelItemBag(m_HeroEatingItem.IGE.s.Name, m_HeroEatingItem.IGE.MakeIndex);
            DelHeroItemBag(m_HeroEatingItem.IGE.s.Name, m_HeroEatingItem.IGE.MakeIndex);
            m_HeroEatingItem.IGE.s.Name := '';
          end else
            if (m_HeroEatingItem.IGE.s.Name = '') and (m_HeroEatingItem2.IGE.s.Name <> '') then begin
            if not m_HeroEatingItem2.boSend then begin
              Msg_IGE := MakeDefaultMsg_IGE(SM_IGE_5035, m_MyHero.m_nRecogId, 0, 0, 1);
              GameSocket.SendToClient(EncodeMessage_IGE(Msg_IGE) + EncodeBuffer(@m_HeroEatingItem2.IGE, SizeOf(TClientItem_IGE)));
            end;
            DelItemBag(m_HeroEatingItem2.IGE.s.Name, m_HeroEatingItem2.IGE.MakeIndex);
            DelHeroItemBag(m_HeroEatingItem2.IGE.s.Name, m_HeroEatingItem2.IGE.MakeIndex);
            m_HeroEatingItem2.IGE.s.Name := '';
          end;
        end;
    end;
    ArrangeHeroItemBag;
  end;
end;

procedure TGameEngine.ClientObjHeroEatFail();
begin //英雄吃物品失败
  case m_btVersion of
    0: begin
        if (m_HeroEatingItem.BLUE.s.Name <> '') and (m_HeroEatingItem2.BLUE.s.Name <> '') then begin
          if m_HeroEatingItem.nIndex = 0 then begin
            AddHeroItemBag_BLUE(m_HeroEatingItem.BLUE);
            m_HeroEatingItem.BLUE.s.Name := '';
          end else begin
            AddHeroItemBag_BLUE(m_HeroEatingItem2.BLUE);
            m_HeroEatingItem2.BLUE.s.Name := '';
          end;
        end else
          if (m_HeroEatingItem.BLUE.s.Name <> '') and (m_HeroEatingItem2.BLUE.s.Name = '') then begin
          AddHeroItemBag_BLUE(m_HeroEatingItem.BLUE);
          m_HeroEatingItem.BLUE.s.Name := '';
        end else
          if (m_HeroEatingItem.BLUE.s.Name = '') and (m_HeroEatingItem2.BLUE.s.Name <> '') then begin
          AddHeroItemBag_BLUE(m_HeroEatingItem2.BLUE);
          m_HeroEatingItem2.BLUE.s.Name := '';
        end;
      end;
    1: begin
        if (m_HeroEatingItem.IGE.s.Name <> '') and (m_HeroEatingItem2.IGE.s.Name <> '') then begin
          if m_HeroEatingItem.nIndex = 0 then begin
            AddHeroItemBag_IGE(m_HeroEatingItem.IGE);
            m_HeroEatingItem.IGE.s.Name := '';
          end else begin
            AddHeroItemBag_IGE(m_HeroEatingItem2.IGE);
            m_HeroEatingItem2.IGE.s.Name := '';
          end;
        end else
          if (m_HeroEatingItem.IGE.s.Name <> '') and (m_HeroEatingItem2.IGE.s.Name = '') then begin
          AddHeroItemBag_IGE(m_HeroEatingItem.IGE);
          m_HeroEatingItem.IGE.s.Name := '';
        end else
          if (m_HeroEatingItem.IGE.s.Name = '') and (m_HeroEatingItem2.IGE.s.Name <> '') then begin
          AddHeroItemBag_IGE(m_HeroEatingItem2.IGE);
          m_HeroEatingItem2.IGE.s.Name := '';
        end;
      end;
  end;
end;

procedure TGameEngine.ClientObjHit(DefMsg: TDefaultMessage;
  sData: string);
var
  Actor: TActor;
begin
  //if m_MySelf = nil then Exit;
  if DefMsg.Recog <> m_MySelf.m_nRecogId then begin
    Actor := FindActor(DefMsg.Recog);
    if Actor <> nil then begin
      Actor.SendMsg(DefMsg.ident,
        DefMsg.param {x},
        DefMsg.tag {y},
        DefMsg.series {dir},
        0, 0, '',
        0);
      if DefMsg.ident = SM_HEAVYHIT then begin
        if sData <> '' then
          //Actor.m_boDigFragment := True;
      end;
    end;
  end;
end;

procedure TGameEngine.ClientObjFlyAxe(DefMsg: TDefaultMessage;
  sData: string);
var
  MessageBodyW: TMessageBodyW;
  Actor: TActor;
begin
  Actor := FindActor(DefMsg.Recog);
  if Actor <> nil then begin
    DecodeBuffer(sData, @MessageBodyW, SizeOf(TMessageBodyW));
    Actor.SendMsg(DefMsg.ident,
      DefMsg.param {x},
      DefMsg.tag {y},
      DefMsg.series {dir},
      0, 0, '',
      0);
    Actor.m_nTargetX := MessageBodyW.Param1; //x
    Actor.m_nTargetY := MessageBodyW.Param2; //y
    Actor.m_nTargetRecog := MakeLong(MessageBodyW.Tag1, MessageBodyW.Tag2);
  end;
end;

procedure TGameEngine.ClientObjDeath(DefMsg: TDefaultMessage;
  sData: string);
var
  Actor: TActor;
  CharDesc: TOCharDesc;
  feature: Integer;
  Status: Integer;
begin
  if Length(sData) >= m_nCodeMsgSize then begin
    DecodeBuffer(sData, @CharDesc, SizeOf(TOCharDesc));
    feature := CharDesc.feature;
    Status := CharDesc.Status;
    Actor := FindActor(DefMsg.Recog);
    if Actor <> nil then begin
      Actor.SendMsg(DefMsg.ident,
        DefMsg.param {x}, DefMsg.tag {y}, DefMsg.series {damage},
        feature, Status, '',
        0);
      case m_btVersion of
        0: Actor.m_Abil_BLUE.HP := 0;
        1: Actor.m_Abil_IGE.HP := 0;
      end;
    end else begin
      SendMsg(SM_DEATH, DefMsg.Recog, DefMsg.param {x}, DefMsg.tag {y}, DefMsg.series {damage}, feature, Status, '');
    end;
  end;
end;

procedure TGameEngine.ClientObjSkeLeton(DefMsg: TDefaultMessage;
  sData: string);
var
  CharDesc: TOCharDesc;
  feature: Integer;
  Status: Integer;
begin
  if Length(sData) >= m_nCodeMsgSize then begin
    DecodeBuffer(sData, @CharDesc, SizeOf(TOCharDesc));
    feature := CharDesc.feature;
    Status := CharDesc.Status;
    SendMsg(DefMsg.ident, DefMsg.Recog, DefMsg.param {HP}, DefMsg.tag {maxHP}, DefMsg.series {damage}, feature, Status, '');
  end;
end;

procedure TGameEngine.ClientObjAbility(DefMsg: TDefaultMessage;
  sData: string);
begin
  if m_MySelf <> nil then begin
    m_MySelf.m_nGold := DefMsg.Recog;
    m_MySelf.m_btJob := DefMsg.param;
    m_MySelf.m_nGameGold := MakeLong(DefMsg.tag, DefMsg.series);

    case m_btVersion of
      0: DecodeBuffer(sData, @m_MySelf.m_Abil_BLUE, SizeOf(TAbility_BLUE));
      1: DecodeBuffer(sData, @m_MySelf.m_Abil_IGE, SizeOf(TAbility_IGE));
    end;
    {
    SendOutStr('Ability:' + sData);
    SendOutStr('Ability Length:' + IntToStr(Length(sData)));
    SendOutStr('EncodeBuffer Ability:' + EncodeBuffer(@m_MySelf.m_Abil_BLUE, SizeOf(TAbility_BLUE)));
    SendOutStr('EncodeBuffer Ability Length:' + IntToStr(Length(EncodeBuffer(@m_MySelf.m_Abil_BLUE, SizeOf(TAbility_BLUE)))));
    }
    //DecodeBuffer(sData, @m_MySelf.m_Abil, SizeOf(TAbility));
  end;
end;

procedure TGameEngine.ClientObjSubAbility(DefMsg: TDefaultMessage);
begin
  m_nMyHitPoint := LoByte(DefMsg.param);
  m_nMySpeedPoint := HiByte(DefMsg.param);
  m_nMyAntiPoison := LoByte(DefMsg.tag);
  m_nMyPoisonRecover := HiByte(DefMsg.tag);
  m_nMyHealthRecover := LoByte(DefMsg.series);
  m_nMySpellRecover := HiByte(DefMsg.series);
  m_nMyAntiMagic := LoByte(LongWord(DefMsg.Recog));
end;

procedure TGameEngine.ClientObjWinExp(DefMsg: TDefaultMessage);
begin
  if m_MySelf <> nil then begin
    case m_btVersion of
      0: m_MySelf.m_Abil_BLUE.Exp := DefMsg.Recog;
      1: m_MySelf.m_Abil_IGE.Exp := DefMsg.Recog;
    end;
  end;
  //DScreen.AddSysMsg('已获得 ' + IntToStr(LongWord(MakeLong(DefMsg.param, DefMsg.tag))) + ' 点经验值。', SCREENWIDTH - 150, 40, clLime);
end;

procedure TGameEngine.ClientObjLevelUp(DefMsg: TDefaultMessage);
begin
  if m_MySelf <> nil then begin
    case m_btVersion of
      0: m_MySelf.m_Abil_BLUE.Level := DefMsg.param;
      1: m_MySelf.m_Abil_IGE.Level := MakeLong(DefMsg.param, DefMsg.Tag);
    end;
    m_MySelf.SendMsg(SM_LEVELUP, m_MySelf.m_nRecogId, m_MySelf.m_nCurrX {X}, m_MySelf.m_nCurrY {Y}, m_MySelf.m_btDir {d}, 0, '', 0);
  end;
  //DScreen.AddSysMsg('升级！', 30, 40, clAqua);
end;

procedure TGameEngine.ClientObjHealthSpellChanged(DefMsg: TDefaultMessage);
var
  Actor: TActor;
begin
  Actor := FindActor(DefMsg.Recog);
  case m_btVersion of
    0: begin
        if Actor <> nil then begin
          Actor.m_Abil_BLUE.HP := DefMsg.param;
          Actor.m_Abil_BLUE.MP := DefMsg.tag;
          Actor.m_Abil_BLUE.MaxHP := DefMsg.series;
        end else begin
          if (m_MyHero <> nil) and (m_MyHero.m_nRecogId = DefMsg.Recog) then begin
            m_MyHero.m_Abil_BLUE.HP := DefMsg.param;
            m_MyHero.m_Abil_BLUE.MP := DefMsg.tag;
            m_MyHero.m_Abil_BLUE.MaxHP := DefMsg.series;
          end;
        end;
      end;
    1: begin
        if Actor <> nil then begin
          Actor.m_Abil_IGE.HP := DefMsg.param;
          Actor.m_Abil_IGE.MP := DefMsg.tag;
          Actor.m_Abil_IGE.MaxHP := DefMsg.series;
        end else begin
          if (m_MyHero <> nil) and (m_MyHero.m_nRecogId = DefMsg.Recog) then begin
            m_MyHero.m_Abil_IGE.HP := DefMsg.param;
            m_MyHero.m_Abil_IGE.MP := DefMsg.tag;
            m_MyHero.m_Abil_IGE.MaxHP := DefMsg.series;
          end;
        end;
      end;
  end;
end;

procedure TGameEngine.ClientObjStruck(DefMsg: TDefaultMessage;
  sData: string);
var
  MessageBodyWL: TMessageBodyWL;
  Actor: TActor;
begin
  Actor := FindActor(DefMsg.Recog);
  if Actor <> nil then begin
    DecodeBuffer(sData, @MessageBodyWL, SizeOf(TMessageBodyWL));
    if Actor = m_MySelf then begin
      if m_MySelf.m_nNameColor = 249 then
    end else begin
     { if Actor.CanCancelAction then
        Actor.CancelAction;   }
    end;

   { if Actor = m_MySelf then begin
      if not m_Config.boStable then begin
        Actor.UpdateMsg(SM_STRUCK, MessageBodyWL.lTag2, 0,
          DefMsg.series , MessageBodyWL.lParam1, MessageBodyWL.lParam2,
          '', MessageBodyWL.lTag1);
      end;
    end else begin
      Actor.UpdateMsg(SM_STRUCK, MessageBodyWL.lTag2, 0,
        DefMsg.series , MessageBodyWL.lParam1, MessageBodyWL.lParam2,
        '', MessageBodyWL.lTag1);
    end; }
    case m_btVersion of
      0: begin
          Actor.m_Abil_BLUE.HP := DefMsg.param;
          Actor.m_Abil_BLUE.MaxHP := DefMsg.tag;
        end;
      1: begin
          Actor.m_Abil_IGE.HP := DefMsg.param;
          Actor.m_Abil_IGE.MaxHP := DefMsg.tag;
        end;
    end;
  end;
end;

procedure TGameEngine.ClientObjChangeFace(DefMsg: TDefaultMessage;
  sData: string);
var
  CharDesc: TOCharDesc;
  feature: Integer;
  Status: Integer;
  Actor: TActor;
begin
  Actor := FindActor(DefMsg.Recog);
  if Actor <> nil then begin
    DecodeBuffer(sData, @CharDesc, SizeOf(TOCharDesc));
    feature := CharDesc.feature;
    Status := CharDesc.Status;
    Actor.m_nWaitForRecogId := MakeLong(DefMsg.param, DefMsg.tag);
    Actor.m_nWaitForFeature := feature;
    Actor.m_nWaitForStatus := Status;
    AddChangeFace(Actor.m_nWaitForRecogId);
  end;
end;

{procedure TGameEngine.ClientObjOpenHealth(DefMsg: TDefaultMessage);
var
  Actor: TActor;
begin
  Actor := FindActor(DefMsg.Recog);
  if Actor <> nil then begin
    if Actor <> m_MySelf then begin
      Actor.m_Abil.HP := DefMsg.param;
      Actor.m_Abil.MaxHP := DefMsg.tag;
    end;
    Actor.m_boOpenHealth := True;
  end;
end;}

procedure TGameEngine.ClientObjInstanceOpenHealth(DefMsg: TDefaultMessage);
var
  Actor: TActor;
begin
  Actor := FindActor(DefMsg.Recog);
  if Actor <> nil then begin
    case m_btVersion of
      0: begin
          Actor.m_Abil_BLUE.HP := DefMsg.param;
          Actor.m_Abil_BLUE.MaxHP := DefMsg.tag;
        end;
      1: begin
          Actor.m_Abil_IGE.HP := DefMsg.param;
          Actor.m_Abil_IGE.MaxHP := DefMsg.tag;
        end;
    end;
  end;
end;

procedure TGameEngine.ClientGetUserName(DefMsg: TDefaultMessage;
  sData: string);
var
  Actor: TActor;
  sUserName: string;
begin
  Actor := FindActor(DefMsg.Recog);
  if Actor <> nil then begin
    sUserName := DecodeString(sData);
    Actor.m_sDescUserName := GetValidStr3(sUserName, Actor.m_sUserName, ['\']);
    Actor.m_nNameColor := GetRGB(DefMsg.param);
  end;
end;

procedure TGameEngine.ClientObjChangeNameColor(DefMsg: TDefaultMessage);
var
  Actor: TActor;
begin
  Actor := FindActor(DefMsg.Recog);
  if Actor <> nil then begin
    Actor.m_nNameColor := GetRGB(DefMsg.param);
  end;
end;

procedure TGameEngine.ClientObjHide(DefMsg: TDefaultMessage);
begin
  if (m_MySelf <> nil) and (m_MySelf.m_nRecogId <> DefMsg.Recog) then begin
    SendMsg(SM_HIDE, DefMsg.Recog, DefMsg.param {x}, DefMsg.tag {y}, 0, 0, 0, '');
  end;
end;

procedure TGameEngine.ClientObjDigUp(DefMsg: TDefaultMessage;
  sData: string);
var
  MessageBodyWL: TMessageBodyWL;
  Actor: TActor;
begin
  DecodeBuffer(sData, @MessageBodyWL, SizeOf(TMessageBodyWL));
  Actor := FindActor(DefMsg.Recog);
  if Actor = nil then begin
    Actor := NewActor(DefMsg.Recog, DefMsg.param, DefMsg.tag, DefMsg.series, MessageBodyWL.lParam1, MessageBodyWL.lParam2);
    if (m_MySelf <> nil) and (Actor <> nil) and (not Actor.m_boDeath) then
      m_ShowBossList.Hint(Actor);
  end;
  if Actor <> nil then begin

    //Actor.m_nCurrentEvent := MessageBodyWL.lTag1;
    Actor.SendMsg(DefMsg.ident,
      DefMsg.param {x},
      DefMsg.tag {y},
      DefMsg.series {dir + light},
      MessageBodyWL.lParam1,
      MessageBodyWL.lParam2, '', 0);
  end;
end;

procedure TGameEngine.ClientObjHeroLogIn(DefMsg: TDefaultMessage;
  sData: string);
var
  MessageBodyWL: TMessageBodyWL;
  Actor: TActor;
begin
  m_dwRecallBackHero := GetTickCount + 1000 * 30;
  DecodeBuffer(sData, @MessageBodyWL, SizeOf(TMessageBodyWL));
  Actor := FindActor(DefMsg.Recog);
  if Actor = nil then begin
    Actor := NewActor(DefMsg.Recog, DefMsg.param, DefMsg.tag, DefMsg.series, MessageBodyWL.lParam1, MessageBodyWL.lParam2);
    if (m_MySelf <> nil) and (Actor <> nil) and (not Actor.m_boDeath) then
      m_ShowBossList.Hint(Actor);
  end;
  if Actor <> nil then begin
    if m_MyHero = nil then m_MyHero := Actor;
    //Actor.m_nCurrentEvent := MessageBodyWL.lTag1;
    Actor.SendMsg(DefMsg.ident,
      DefMsg.param {x},
      DefMsg.tag {y},
      DefMsg.series {dir + light},
      MessageBodyWL.lParam1,
      MessageBodyWL.lParam2, '', 0);
  end;
end;

procedure TGameEngine.ClientObjDigDown(DefMsg: TDefaultMessage);
begin
  SendMsg(DefMsg.ident, DefMsg.Recog, DefMsg.param {x}, DefMsg.tag {y}, 0, 0, 0, '');
end;

procedure TGameEngine.ClientGetMapDescription(Msg: TDefaultMessage; sBody: string);
var
  sTitle: string;
  sMapMusic: string;
begin
  sBody := DecodeString(sBody);
  sBody := GetValidStr3(sBody, sTitle, [#13]);
  sBody := GetValidStr3(sBody, sMapMusic, ['|']);
  if m_sMapTitle <> sTitle then begin
    m_sMapTitle := sTitle;
  end;
end;

procedure TGameEngine.ClientGetGameGoldName(Msg: TDefaultMessage; sBody: string);
var
  sData: string;
begin
  if sBody <> '' then begin
    sBody := DecodeString(sBody);
    sBody := GetValidStr3(sBody, sData, [#13]);
    m_sGameGoldName := sData;
    m_sGamePointName := sBody;
  end;
  if m_MySelf <> nil then begin
    m_MySelf.m_nGameGold := Msg.Recog;
    m_MySelf.m_nGamePoint := MakeLong(Msg.param, Msg.tag);
  end;
end;

procedure TGameEngine.ClientGetAdjustBonus(bonus: Integer; body: string);
var
  str1, str2, str3: string;
  sMsg: string;
begin
  m_nBonusPoint := bonus;
  sMsg := body;
  sMsg := GetValidStr3(sMsg, str1, ['/']);
  str3 := GetValidStr3(sMsg, str2, ['/']);
  DecodeBuffer(str1, @m_BonusTick, SizeOf(TNakedAbility));
  DecodeBuffer(str2, @m_BonusAbil, SizeOf(TNakedAbility));
  DecodeBuffer(str3, @m_NakedAbil, SizeOf(TNakedAbility));
  FillChar(m_BonusAbilChg, SizeOf(TNakedAbility), #0);
end;

procedure TGameEngine.ClientGetAddItem(body: string);
var
  ClientItem_BLUE: TClientItem_BLUE;
  ClientItem_IGE: TClientItem_IGE;
begin
  if body <> '' then begin
    case m_btVersion of
      0: begin
          DecodeBuffer(body, @ClientItem_BLUE, SizeOf(TClientItem_BLUE));
          AddItemBag_BLUE(ClientItem_BLUE);
        end;
      1: begin
          DecodeBuffer(body, @ClientItem_IGE, SizeOf(TClientItem_IGE));
          AddItemBag_IGE(ClientItem_IGE);
        end;
    end;
    //DScreen.AddSysMsg(cu.S.Name + ' 被发现.', 30, 40, clAqua);
  end;
end;

procedure TGameEngine.ClientGetUpdateItem(body: string);
var
  I: Integer;
  ClientItem_BLUE: TClientItem_BLUE;
  ClientItem_IGE: TClientItem_IGE;
begin
  if body <> '' then begin
    case m_btVersion of
      0: begin
          DecodeBuffer(body, @ClientItem_BLUE, SizeOf(TClientItem_BLUE));
          UpdateItemBag_BLUE(ClientItem_BLUE);
          for I := Low(m_UseItems_BLUE) to High(m_UseItems_BLUE) do begin
            if (m_UseItems_BLUE[I].s.Name = ClientItem_BLUE.s.Name) and (m_UseItems_BLUE[I].MakeIndex = ClientItem_BLUE.MakeIndex) then begin
              m_UseItems_BLUE[I] := ClientItem_BLUE;
              //DelEatItemFail(ClientItem_BLUE.s.Name, ClientItem_BLUE.MakeIndex);
            end;
          end;
        end;
      1: begin
          DecodeBuffer(body, @ClientItem_IGE, SizeOf(TClientItem_IGE));
          UpdateItemBag_IGE(ClientItem_IGE);
          for I := Low(m_UseItems_IGE) to High(m_UseItems_IGE) do begin
            if (m_UseItems_IGE[I].s.Name = ClientItem_IGE.s.Name) and (m_UseItems_IGE[I].MakeIndex = ClientItem_IGE.MakeIndex) then begin
              m_UseItems_IGE[I] := ClientItem_IGE;
              //DelEatItemFail(ClientItem_IGE.s.Name, ClientItem_IGE.MakeIndex);
            end;
          end;
        end;
    end;
  end;
end;

procedure TGameEngine.ClientGetUpdateItem2(body: string);
var
  I: Integer;
  ClientItem_BLUE: TClientItem_BLUE;
  ClientItem_IGE: TClientItem_IGE;
begin
  if body <> '' then begin
    case m_btVersion of
      0: begin
        {  DecodeBuffer(body, @ClientItem_BLUE, SizeOf(TClientItem_BLUE));
          UpdateItemBag2_BLUE(ClientItem_BLUE);
          for I := Low(m_UseItems_BLUE) to High(m_UseItems_BLUE) do begin
            if (m_UseItems_BLUE[I].s.Name = ClientItem_BLUE.s.Name) and (m_UseItems_BLUE[I].MakeIndex = ClientItem_BLUE.MakeIndex) then begin
              m_UseItems_BLUE[I] := ClientItem_BLUE;
            end;
          end; }
        end;
      1: begin
          DecodeBuffer(body, @ClientItem_IGE, SizeOf(TClientItem_IGE));
          UpdateItemBag2_IGE(ClientItem_IGE);
          for I := Low(m_UseItems_IGE) to High(m_UseItems_IGE) do begin
            if {(m_UseItems_IGE[I].s.Name = ClientItem_IGE.s.Name) and }(m_UseItems_IGE[I].MakeIndex = ClientItem_IGE.MakeIndex) then begin
              m_UseItems_IGE[I] := ClientItem_IGE;
            end;
          end;
        end;
    end;
  end;
end;

procedure TGameEngine.ClientGetDelItem(body: string);
var
  I: Integer;
  ClientItem_BLUE: TClientItem_BLUE;
  ClientItem_IGE: TClientItem_IGE;
begin
  if body <> '' then begin
    case m_btVersion of
      0: begin
          DecodeBuffer(body, @ClientItem_BLUE, SizeOf(TClientItem_BLUE));

          DelItemBag(ClientItem_BLUE.s.Name, ClientItem_BLUE.MakeIndex);
          //DelEatItemFail(ClientItem_BLUE.s.Name, ClientItem_BLUE.MakeIndex);
          if (m_EatingItem.BLUE.s.Name = ClientItem_BLUE.s.Name) and
            (m_EatingItem.BLUE.MakeIndex = ClientItem_BLUE.MakeIndex) then begin
            m_EatingItem.BLUE.s.Name := '';
          end;
          if (m_HeroEatingItem.BLUE.s.Name = ClientItem_BLUE.s.Name) and
            (m_HeroEatingItem.BLUE.MakeIndex = ClientItem_BLUE.MakeIndex) then begin
            m_HeroEatingItem.BLUE.s.Name := '';
          end;

          if (m_EatingItem2.BLUE.s.Name = ClientItem_BLUE.s.Name) and
            (m_EatingItem2.BLUE.MakeIndex = ClientItem_BLUE.MakeIndex) then begin
            m_EatingItem2.BLUE.s.Name := '';
          end;
          if (m_HeroEatingItem2.BLUE.s.Name = ClientItem_BLUE.s.Name) and
            (m_HeroEatingItem2.BLUE.MakeIndex = ClientItem_BLUE.MakeIndex) then begin
            m_HeroEatingItem2.BLUE.s.Name := '';
          end;

          for I := Low(m_UseItems_BLUE) to High(m_UseItems_BLUE) do begin
            if (m_UseItems_BLUE[I].s.Name = ClientItem_BLUE.s.Name) and (m_UseItems_BLUE[I].MakeIndex = ClientItem_BLUE.MakeIndex) then begin
              //m_UseItems_BLUE[I] := ClientItem_BLUE;
              m_UseItems_BLUE[I].s.Name := '';
            end;
          end;
        end;
      1: begin
          DecodeBuffer(body, @ClientItem_IGE, SizeOf(TClientItem_IGE));
          DelItemBag(ClientItem_IGE.s.Name, ClientItem_IGE.MakeIndex);
          //DelEatItemFail(ClientItem_IGE.s.Name, ClientItem_IGE.MakeIndex);
          if (m_EatingItem.IGE.s.Name = ClientItem_IGE.s.Name) and
            (m_EatingItem.IGE.MakeIndex = ClientItem_IGE.MakeIndex) then begin
            m_EatingItem.IGE.s.Name := '';
          end;
          if (m_HeroEatingItem.IGE.s.Name = ClientItem_IGE.s.Name) and
            (m_HeroEatingItem.IGE.MakeIndex = ClientItem_IGE.MakeIndex) then begin
            m_HeroEatingItem.IGE.s.Name := '';
          end;

          if (m_EatingItem2.IGE.s.Name = ClientItem_IGE.s.Name) and
            (m_EatingItem2.IGE.MakeIndex = ClientItem_IGE.MakeIndex) then begin
            m_EatingItem2.IGE.s.Name := '';
          end;
          if (m_HeroEatingItem2.IGE.s.Name = ClientItem_IGE.s.Name) and
            (m_HeroEatingItem2.IGE.MakeIndex = ClientItem_IGE.MakeIndex) then begin
            m_HeroEatingItem2.IGE.s.Name := '';
          end;

          for I := Low(m_UseItems_IGE) to High(m_UseItems_IGE) do begin
            if (m_UseItems_IGE[I].s.Name = ClientItem_IGE.s.Name) and (m_UseItems_IGE[I].MakeIndex = ClientItem_IGE.MakeIndex) then begin
              //m_UseItems_IGE[I] := ClientItem_IGE;
              m_UseItems_IGE[I].s.Name := '';
            end;
          end;
        end;
    end;
  end;
end;

procedure TGameEngine.ClientGetDelItems(body: string);
var
  I, iindex: Integer;
  Str, iname: string;
  sMsg: string;
begin
  sMsg := DecodeString(body);
  while sMsg <> '' do begin
    sMsg := GetValidStr3(sMsg, iname, ['/']);
    sMsg := GetValidStr3(sMsg, Str, ['/']);
    if (iname <> '') and (Str <> '') then begin
      iindex := Str_ToInt(Str, 0);
      DelItemBag(iname, iindex);
      //DelEatItemFail(iname, iindex);
      case m_btVersion of
        0: begin
            if (m_EatingItem.BLUE.s.Name = iname) and
              (m_EatingItem.BLUE.MakeIndex = iindex) then begin
              m_EatingItem.BLUE.s.Name := '';
            end;
            if (m_HeroEatingItem.BLUE.s.Name = iname) and
              (m_HeroEatingItem.BLUE.MakeIndex = iindex) then begin
              m_HeroEatingItem.BLUE.s.Name := '';
            end;

            if (m_EatingItem2.BLUE.s.Name = iname) and
              (m_EatingItem2.BLUE.MakeIndex = iindex) then begin
              m_EatingItem2.BLUE.s.Name := '';
            end;
            if (m_HeroEatingItem2.BLUE.s.Name = iname) and
              (m_HeroEatingItem2.BLUE.MakeIndex = iindex) then begin
              m_HeroEatingItem2.BLUE.s.Name := '';
            end;
            for I := Low(m_UseItems_BLUE) to High(m_UseItems_BLUE) do begin
              if (m_UseItems_BLUE[I].s.Name = iname) and (m_UseItems_BLUE[I].MakeIndex = iindex) then begin
                m_UseItems_BLUE[I].s.Name := '';
              end;
            end;
          end;
        1: begin
            if (m_EatingItem.IGE.s.Name = iname) and
              (m_EatingItem.IGE.MakeIndex = iindex) then begin
              m_EatingItem.IGE.s.Name := '';
            end;
            if (m_HeroEatingItem.IGE.s.Name = iname) and
              (m_HeroEatingItem.IGE.MakeIndex = iindex) then begin
              m_HeroEatingItem.IGE.s.Name := '';
            end;
            if (m_EatingItem2.IGE.s.Name = iname) and
              (m_EatingItem2.IGE.MakeIndex = iindex) then begin
              m_EatingItem2.IGE.s.Name := '';
            end;
            if (m_HeroEatingItem2.IGE.s.Name = iname) and
              (m_HeroEatingItem2.IGE.MakeIndex = iindex) then begin
              m_HeroEatingItem2.IGE.s.Name := '';
            end;
            for I := Low(m_UseItems_IGE) to High(m_UseItems_IGE) do begin
              if (m_UseItems_IGE[I].s.Name = iname) and (m_UseItems_IGE[I].MakeIndex = iindex) then begin
                m_UseItems_IGE[I].s.Name := '';
              end;
            end;
          end;
      end;
    end else Break;
  end;
end;

procedure TGameEngine.ClientGetBagItmes(DefMsg: TDefaultMessage; body: string);
var
  Str: string;
  sMsg: string;
  ClientItem_IGE: TClientItem_IGE;
  ClientItem_BLUE: TClientItem_BLUE;
begin
 // if m_btVersion = 0 then begin
  SafeFillChar(m_ItemArr_BLUE, SizeOf(TClientItem_BLUE) * MAXBAGITEMCL, #0);
  SafeFillChar(m_EatingItem, SizeOf(TUserEatItems), #0);
  SafeFillChar(m_EatingItem2, SizeOf(TUserEatItems), #0);
  ClearEatItemFailList;
  {end else begin
    if DefMsg.param = 0 then begin
      SafeFillChar(m_ItemArr_IGE, SizeOf(TClientItem_IGE) * MAXBAGITEMCL, #0);
      SafeFillChar(m_EatingItem, SizeOf(TUserEatItems), #0);
      SafeFillChar(m_EatingItem2, SizeOf(TUserEatItems), #0);
      ClearEatItemFailList;
    end;
  end;}
  //Showmessage('TGameEngine.ClientGetBagItmes');
  sMsg := body;
  while True do begin
    if sMsg = '' then Break;
    sMsg := GetValidStr3(sMsg, Str, ['/']);
    if Str <> '' then begin
      case m_btVersion of //Length = 70
        0: begin
            DecodeBuffer(Str, @ClientItem_BLUE, SizeOf(TClientItem_BLUE));
            AddItemBag_BLUE(ClientItem_BLUE);
          end;
        1: begin
            DecodeBuffer(Str, @ClientItem_IGE, SizeOf(TClientItem_IGE));
            AddItemBag_IGE(ClientItem_IGE);
          end;
      end;
      //AddItemBag(cu);
        {SendOutStr(Str);
        SendOutStr('');
        SendOutStr('EncodeBuffer TClientItem:' + EncodeBuffer(@cu, SizeOf(TClientItem)));
        SendOutStr('EncodeBuffer ToClientItem:' + EncodeBuffer(@cu, SizeOf(ToClientItem)));
        SendOutStr('');
        SendOutStr('Length:' + IntToStr(Length(Str)));
        SendOutStr('');
        SendOutStr('SizeOf(TClientItem):' + IntToStr(SizeOf(TClientItem)));
        SendOutStr('');
        SendOutStr('Name:' + cu.S.Name);
        SendOutStr('');
        SendOutStr('MakeIndex:' + IntToStr(cu.MakeIndex));
        SendOutStr('');
        SendOutStr('Dura:' + IntToStr(cu.Dura));
        SendOutStr('');
        SendOutStr('DuraMax:' + IntToStr(cu.DuraMax));
        SendOutStr('');
        SendOutStr('StdMode:' + IntToStr(cu.S.StdMode));
        SendOutStr('');
        SendOutStr('cu.S.DuraMax:' + IntToStr(cu.S.DuraMax));
        SendOutStr('');
        SendOutStr('cu.S.Need:' + IntToStr(cu.S.Need));
        SendOutStr('');
        SendOutStr('Weight:' + IntToStr(cu.S.Weight));
        SendOutStr('');
        SendOutStr('Looks:' + IntToStr(cu.S.Looks));
        SendOutStr('');
        SendOutStr('NeedLevel:' + IntToStr(cu.S.NeedLevel));   }
    end else Break;
  end;
  if m_boQueryHumBagItems then begin
    m_boQueryHumBagItems := False;
    GameEngine.AddChatBoardString('包裹刷新成功...', c_White, c_Fuchsia);
  end;
end;

procedure TGameEngine.ClientGetDropItemFail(iname: string; sindex: Integer);
var
  ClientItem_BLUE: pTClientItem_BLUE;
  ClientItem_IGE: pTClientItem_IGE;
begin
  case m_btVersion of
    0: begin
        ClientItem_BLUE := GetDropItem_BLUE(iname, sindex);
        if ClientItem_BLUE <> nil then begin
          AddItemBag_BLUE(ClientItem_BLUE^);
        end;
        DelDropItem(iname, sindex);
      end;
    1: begin
        ClientItem_IGE := GetDropItem_IGE(iname, sindex);
        if ClientItem_IGE <> nil then begin
          AddItemBag_IGE(ClientItem_IGE^);
        end;
        DelDropItem(iname, sindex);
      end;
  end;
end;

procedure TGameEngine.ClientGetHeroDropItemFail(iname: string; sindex: Integer);
var
  ClientItem_BLUE: pTClientItem_BLUE;
  ClientItem_IGE: pTClientItem_IGE;
begin
  case m_btVersion of
    0: begin
        ClientItem_BLUE := GetDropItem_BLUE(iname, sindex);
        if ClientItem_BLUE <> nil then begin
          AddHeroItemBag_BLUE(ClientItem_BLUE^);
        end;
        DelDropItem(iname, sindex);
      end;
    1: begin
        ClientItem_IGE := GetDropItem_IGE(iname, sindex);
        if ClientItem_IGE <> nil then begin
          AddHeroItemBag_IGE(ClientItem_IGE^);
        end;
        DelDropItem(iname, sindex);
      end;
  end;
end;

procedure TGameEngine.ClientGetShowItem(DefMsg: TDefaultMessage;
  sData: string);
var
  I: Integer;
  DropItem: pTDropItem;
  ShowItem: pTShowItem;
begin
  for I := 0 to m_DropedItemList.Count - 1 do begin
    if pTDropItem(m_DropedItemList[I]).id = DefMsg.Recog then
      Exit;
  end;
  New(DropItem);
  DropItem.id := DefMsg.Recog;
  DropItem.X := DefMsg.param;
  DropItem.Y := DefMsg.tag;
  DropItem.Looks := DefMsg.series;
  DropItem.Name := DecodeString(sData);
  DropItem.FlashTime := GetTickCount - LongWord(Random(3000));
  DropItem.BoFlash := False;
  m_DropedItemList.Add(DropItem);
  m_ShowItemList.Hint(DropItem);

  if (Config.sMoveCmd <> '') and (m_MySelf <> nil) then begin //传送捡装备
    ShowItem := m_ShowItemList.Find(DropItem.Name);
    if (ShowItem <> nil) and (ShowItem.boMovePick) then begin
      if (m_MySelf.m_nCurrX <> DropItem.X) or (m_MySelf.m_nCurrY <> DropItem.Y) then begin
        if GetTickCount - m_dwMovePickItemTick > Config.dwMoveTime * 1000 then begin
          m_dwMovePickItemTick := GetTickCount;
        //SendSay('m_MySelf.m_nCurrX:'+IntToStr(m_MySelf.m_nCurrX)+' m_MySelf.m_nCurrY:'+IntToStr(m_MySelf.m_nCurrY));
        //SendSay('DropItem.X:'+IntToStr(DropItem.X)+' DropItem.Y:'+IntToStr(DropItem.Y));
        {AddChatBoardString('ClientGetShowItem X:' + IntToStr(m_MySelf.m_nCurrX) + ' Y:' + IntToStr(m_MySelf.m_nCurrY), c_Yellow, c_Red);
        AddChatBoardString('ClientGetShowItem DropItem.X:' + IntToStr(DropItem.X) + ' DropItem.Y:' + IntToStr(DropItem.Y), c_Yellow, c_Red);}
        //SendPickup;
          SendSay(Config.sMoveCmd + ' ' + IntToStr(DropItem.X) + ' ' + IntToStr(DropItem.Y));
        end;
      end else begin
        SendPickup;
      end;
    end;
  end;
end;

procedure TGameEngine.ClientGetHideItem(DefMsg: TDefaultMessage);
var
  I: Integer;
  DropItem: pTDropItem;
begin
  for I := m_DropedItemList.Count - 1 downto 0 do begin
    DropItem := m_DropedItemList.Items[I];
    if DropItem <> nil then begin
      if DropItem.id = DefMsg.Recog then begin
        m_DropedItemList.Delete(I);
        Dispose(DropItem);
        Break;
      end;
    end;
  end;
end;

procedure TGameEngine.ClientGetSendAddUseItems(body: string);
var
  Index: Integer;
  Str, Data, sMsg: string;
  ClientItem_BLUE: TClientItem_BLUE;
  ClientItem_IGE: TClientItem_IGE;
begin
  sMsg := body;
  while True do begin
    if sMsg = '' then Break;
    sMsg := GetValidStr3(sMsg, Str, ['/']);
    sMsg := GetValidStr3(sMsg, Data, ['/']);
    Index := Str_ToInt(Str, -1);
    if Index in [9..12] then begin

      case m_btVersion of
        0: begin
            DecodeBuffer(Data, @ClientItem_BLUE, SizeOf(TClientItem_BLUE));
            m_UseItems_BLUE[Index] := ClientItem_BLUE;
          end;
        1: begin
            DecodeBuffer(Data, @ClientItem_IGE, SizeOf(TClientItem_IGE));
            m_UseItems_IGE[Index] := ClientItem_IGE;
          end;
      end;
    end;
  end;
end;

procedure TGameEngine.ClientGetSenduseItems(body: string);
var
  Index: Integer;
  Str, Data, sMsg: string;
  ClientItem_BLUE: TClientItem_BLUE;
  ClientItem_IGE: TClientItem_IGE;
begin
  case m_btVersion of
    0: SafeFillChar(m_UseItems_BLUE, SizeOf(TClientItem_BLUE) * 13, #0);
    1: SafeFillChar(m_UseItems_IGE, SizeOf(TClientItem_IGE) * 13, #0);
  end;
  sMsg := body;
  while True do begin
    if sMsg = '' then Break;
    sMsg := GetValidStr3(sMsg, Str, ['/']);
    sMsg := GetValidStr3(sMsg, Data, ['/']);
    Index := Str_ToInt(Str, -1);
    if Index in [0..12] then begin

      case m_btVersion of
        0: begin
            DecodeBuffer(Data, @ClientItem_BLUE, SizeOf(TClientItem_BLUE));
            m_UseItems_BLUE[Index] := ClientItem_BLUE;
          end;
        1: begin
            DecodeBuffer(Data, @ClientItem_IGE, SizeOf(TClientItem_IGE));
            m_UseItems_IGE[Index] := ClientItem_IGE;
          end;
      end;
    end;
  end;
end;

procedure TGameEngine.ClientGetAddMagic(body: string);
var
  pcm: pTClientMagic;
begin
  New(pcm);
  DecodeBuffer(body, @(pcm^), SizeOf(TClientMagic));
  m_MagicList.Add(pcm);
end;

procedure TGameEngine.ClientGetDelMagic(magid: Integer);
var
  I: Integer;
begin
  for I := m_MagicList.Count - 1 downto 0 do begin
    if pTClientMagic(m_MagicList.Items[I]).Def.wMagicId = magid then begin
      Dispose(pTClientMagic(m_MagicList.Items[I]));
      m_MagicList.Delete(I);
      Break;
    end;
  end;
end;

procedure TGameEngine.ClientGetMyMagics(body: string);
var
  I: Integer;
  Data, sMsg: string;
  pcm: pTClientMagic;
begin
  for I := 0 to m_MagicList.Count - 1 do
    Dispose(pTClientMagic(m_MagicList[I]));
  m_MagicList.Clear;
  sMsg := body;
  while True do begin
    if sMsg = '' then Break;
    sMsg := GetValidStr3(sMsg, Data, ['/']);
    if Data <> '' then begin
      New(pcm);
      DecodeBuffer(Data, @(pcm^), SizeOf(TClientMagic));
      if pcm.Def.sMagicName <> '' then begin
        m_MagicList.Add(pcm);
      end else begin
        Dispose(pcm);
      end;
    end else Break;
  end;
end;

procedure TGameEngine.ClientGetMagicLvExp(magid, maglv, magtrain: Integer);
var
  I: Integer;
begin
  for I := 0 to m_MagicList.Count - 1 do begin
    if pTClientMagic(m_MagicList.Items[I]).Def.wMagicId = magid then begin
      pTClientMagic(m_MagicList.Items[I]).Level := maglv;
      pTClientMagic(m_MagicList.Items[I]).CurTrain := magtrain;
      Break;
    end;
  end;
end;

function TGameEngine.GetMagicByKey(Key: Char): pTClientMagic;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to m_MagicList.Count - 1 do begin
    if pTClientMagic(m_MagicList.Items[I]).Key = Key then begin
      Result := pTClientMagic(m_MagicList.Items[I]);
      Break;
    end;
  end;
end;

procedure TGameEngine.ClientGetDuraChange(uidx, newdura, newduramax: Integer);
begin
  if uidx in [0..12] then begin
    case m_btVersion of
      0: if m_UseItems_BLUE[uidx].s.Name <> '' then begin
          m_UseItems_BLUE[uidx].Dura := newdura;
          m_UseItems_BLUE[uidx].DuraMax := newduramax;
        end;
      1: if m_UseItems_IGE[uidx].s.Name <> '' then begin
          m_UseItems_IGE[uidx].Dura := newdura;
          m_UseItems_IGE[uidx].DuraMax := newduramax;
        end;
    end;
  end;
end;

procedure TGameEngine.ClientGetStartPlay(sData: string);
var
  Str, addr, sport: string;
begin
  {
  Str := DecodeString(body);
  sport := GetValidStr3(Str, g_sRunServerAddr, ['/']);
  g_nRunServerPort := Str_ToInt(sport, 0);
  }
  GameSocket.m_ConnectionStep := cnsPlay;
end;

procedure TGameEngine.ClientGetReceiveChrs(sData: string);
begin
  GameSocket.m_ConnectionStep := cnsSelChr;
end;

procedure TGameEngine.ClientObjSellItemOK(nGold: Integer);
begin
  if (m_MySelf <> nil) then m_MySelf.m_nGold := nGold;
  case m_btVersion of
    0: m_SellDlgItemSellWait_BLUE.s.Name := '';
    1: m_SellDlgItemSellWait_IGE.s.Name := '';
  end;
end;

procedure TGameEngine.ClientObjSellItemFail();
begin
  case m_btVersion of
    0: begin
        if m_SellDlgItemSellWait_BLUE.s.Name <> '' then begin
          AddItemBag_BLUE(m_SellDlgItemSellWait_BLUE);
        end;
        m_SellDlgItemSellWait_BLUE.s.Name := '';
      end;
    1: begin
        if m_SellDlgItemSellWait_IGE.s.Name <> '' then begin
          AddItemBag_IGE(m_SellDlgItemSellWait_IGE);
        end;
        m_SellDlgItemSellWait_IGE.s.Name := '';
      end;
  end;
end;

procedure TGameEngine.ClientObjStorageOK(DefMsg: TDefaultMessage);
begin
  if DefMsg.ident <> SM_STORAGE_OK then begin
    if DefMsg.ident = SM_STORAGE_FULL then begin
      //FrmDlg.DMessageDlg('您的个人仓库已经满了，不能再保管任何东西了.', [mbOk]);
    end else begin
      //FrmDlg.DMessageDlg('您不能寄存物品.', [mbOk]);
    end;
    ClientObjSellItemFail();
  end;
  case m_btVersion of
    0: m_SellDlgItemSellWait_BLUE.s.Name := '';
    1: m_SellDlgItemSellWait_IGE.s.Name := '';
  end;
end;

procedure TGameEngine.ClientObjTakeBackStorageItemOK(DefMsg: TDefaultMessage);
begin
  //FrmDlg.LastestClickTime := GetTickCount;
  if DefMsg.ident <> SM_TAKEBACKSTORAGEITEM_OK then begin
    if DefMsg.ident = SM_TAKEBACKSTORAGEITEM_FULLBAG then begin
      //FrmDlg.DMessageDlg('您无法携带更多物品了.', [mbOk]);
    end else begin
      //FrmDlg.DMessageDlg('您无法取回物品.', [mbOk]);
    end;
  end else begin
    //FrmDlg.DelStorageItem(DefMsg.Recog);
  end;
end;


procedure TGameEngine.ClientObjDealMenu(sData: string);
begin
  m_sDealWho := DecodeString(sData);
end;

procedure TGameEngine.ClientObjDealCancel();
begin
  MoveDealItemToBag;
  ClientObjDealAddItemOK();
  if (m_nDealGold > 0) and (m_MySelf <> nil) then begin
    m_MySelf.m_nGold := m_MySelf.m_nGold + m_nDealGold;
    m_nDealGold := 0;
  end;
end;

procedure TGameEngine.ClientObjDealAddItemOK();
begin
  case m_btVersion of
    0: begin
        if m_DealDlgItem_BLUE.s.Name <> '' then begin
          AddDealItem_BLUE(m_DealDlgItem_BLUE);
          m_DealDlgItem_BLUE.s.Name := '';
        end;
      end;
    1: begin
        if m_DealDlgItem_IGE.s.Name <> '' then begin
          AddDealItem_IGE(m_DealDlgItem_IGE);
          m_DealDlgItem_IGE.s.Name := '';
        end;
      end;
  end;
end;

procedure TGameEngine.ClientObjDealDelItemOK();
begin
  case m_btVersion of
    0: m_DealDlgItem_BLUE.s.Name := '';
    1: m_DealDlgItem_IGE.s.Name := '';
  end;
end;

procedure TGameEngine.ClientObjDealDelItemFail();
begin
  case m_btVersion of
    0: begin
        if m_DealDlgItem_BLUE.s.Name <> '' then begin
          DelItemBag(m_DealDlgItem_BLUE.s.Name, m_DealDlgItem_BLUE.MakeIndex);
          AddDealItem_BLUE(m_DealDlgItem_BLUE);
          m_DealDlgItem_BLUE.s.Name := '';
        end;
      end;
    1: begin
        if m_DealDlgItem_IGE.s.Name <> '' then begin
          DelItemBag(m_DealDlgItem_IGE.s.Name, m_DealDlgItem_IGE.MakeIndex);
          AddDealItem_IGE(m_DealDlgItem_IGE);
          m_DealDlgItem_IGE.s.Name := '';
        end;
      end;
  end;
end;

procedure TGameEngine.ClientObjDealChgGoldOK(DefMsg: TDefaultMessage);
begin
  m_nDealGold := DefMsg.Recog;
  if m_MySelf <> nil then
    m_MySelf.m_nGold := MakeLong(DefMsg.param, DefMsg.tag);
end;

procedure TGameEngine.ClientObjDealChgGoldFail(DefMsg: TDefaultMessage);
begin
  m_nDealGold := DefMsg.Recog;
  if m_MySelf <> nil then
    m_MySelf.m_nGold := MakeLong(DefMsg.param, DefMsg.tag);
end;

procedure TGameEngine.ClientObjDealRemotChgGold(DefMsg: TDefaultMessage);
begin
  m_nDealRemoteGold := DefMsg.Recog;
end;

procedure TGameEngine.ClientObjSellSellOffItemOK();
begin
  case m_btVersion of
    0: m_SellDlgItemSellWait_BLUE.s.Name := '';
    1: m_SellDlgItemSellWait_IGE.s.Name := '';
  end;
end;

procedure TGameEngine.ClientObjSellSellOffItemFail(nFailCode: Integer);
begin
  case m_btVersion of
    0: AddItemBag_BLUE(m_SellDlgItemSellWait_BLUE);
    1: AddItemBag_IGE(m_SellDlgItemSellWait_IGE);
  end;
  ClientObjSellSellOffItemOK();
end;

procedure TGameEngine.ClientObjOpenBoxOK();
begin
  case m_btVersion of
    0: SafeFillChar(m_OpenBoxingItemWait_BLUE, SizeOf(m_OpenBoxingItemWait_BLUE), #0);
    1: m_OpenBoxingItem_IGE.s.Name := '';
  end;
end;

procedure TGameEngine.ClientObjOpenBoxFail();
var
  I: Integer;
begin
  case m_btVersion of
    0: for I := 0 to 1 do begin
        if m_OpenBoxingItemWait_BLUE[I].s.Name <> '' then begin
          AddItemBag_BLUE(m_OpenBoxingItemWait_BLUE[I]);
        end;
      end;
    1: if m_OpenBoxingItem_IGE.s.Name <> '' then begin
        AddItemBag_IGE(m_OpenBoxingItem_IGE);
      end;
  end;
  ClientObjOpenBoxOK();
end;

procedure TGameEngine.ClientObjChangeItemOK(sData: string);
var
  Item: TClientItem_IGE;
begin
  if sData <> '' then begin
    DecodeBuffer(sData, @Item, SizeOf(TClientItem_IGE));
    AddItemBag_IGE(Item);
  end else begin
    AddItemBag_IGE(m_SellDlgItem_IGE);
  end;
  m_sSellPriceStr := '';
  m_SellDlgItem_IGE.s.Name := '';
  m_SellDlgItemSellWait_IGE.s.Name := '';
        //g_MySelf.m_nGameGold := Msg.Recog;
  //FrmDlg.DMessageDlg('TfrmMain.ClientObjChangeItemOK！！！', [mbOk]);
end;

procedure TGameEngine.ClientObjChangeItemFail(nFailCode: Integer);
begin
  AddItemBag_IGE(m_SellDlgItem_IGE);
  m_sSellPriceStr := '';
  m_SellDlgItemSellWait_IGE.s.Name := '';
  m_SellDlgItem_IGE.s.Name := '';
  {case nFailCode of
    -1, -4: FrmDlg.DMessageDlg('[失败]此物品不允许寄售！！！', [mbOk]);
    -3: FrmDlg.DMessageDlg('[失败]你寄售的物品已经超过最大限制！！！', [mbOk]);
  else FrmDlg.DMessageDlg('[失败]未知错误！！！', [mbOk]);
  end;}
end;

procedure TGameEngine.ClientObjUpgradeItemOK(sData: string);
begin
  if sData <> '' then begin
    DecodeBuffer(sData, @m_UpgradeItemsWait_IGE[0], SizeOf(TClientItem_IGE));
    AddItemBag_IGE(m_UpgradeItemsWait_IGE[0]);
  end;
  m_UpgradeItemsWait_IGE[0].s.Name := '';
  m_UpgradeItemsWait_IGE[1].s.Name := '';
  m_UpgradeItemsWait_IGE[2].s.Name := '';
end;

procedure TGameEngine.ClientObjUpgradeItemFail(nFailCode: Integer;
  sData: string);
var
  I: Integer;
begin
  case nFailCode of
    0: begin
        for I := 0 to Length(m_UpgradeItemsWait_IGE) - 1 do begin
          AddItemBag_IGE(m_UpgradeItemsWait_IGE[I]);
        end;
        //DScreen.AddChatBoardString('装备升级失败！', clWhite, clRed);
      end;
    -1: begin
        //DScreen.AddChatBoardString('装备升级失败，装备已破碎！', clWhite, clRed);
      end;
    -2: begin
        if sData <> '' then begin
          DecodeBuffer(sData, @m_UpgradeItemsWait_IGE[0], SizeOf(TClientItem_IGE));
          AddItemBag_IGE(m_UpgradeItemsWait_IGE[0]);
        end;
      end;
  end;
  m_UpgradeItemsWait_IGE[0].s.Name := '';
  m_UpgradeItemsWait_IGE[1].s.Name := '';
  m_UpgradeItemsWait_IGE[2].s.Name := '';
end;

procedure TGameEngine.ClientObjRecallHero(DefMsg: TDefaultMessage;
  sData: string);
var
  Actor: TActor;
  CharDesc: TOCharDesc;
  feature: Integer;
  Status: Integer;
  Msg: TDefaultMessage;
  Msg_IGE: TDefaultMessage_IGE;
begin
  m_dwRecallBackHero := GetTickCount + 1000 * 30;
  Actor := FindActor(DefMsg.Recog);
  if Actor <> nil then begin
    if m_MyHero = nil then m_MyHero := Actor;
  end else begin
    DecodeBuffer(sData, @CharDesc, SizeOf(TOCharDesc));
    feature := CharDesc.feature;
    Status := CharDesc.Status;

    Actor := NewActor(DefMsg.Recog, DefMsg.param {X}, DefMsg.tag {Y}, DefMsg.series {d}, feature, Status);
    if Actor <> nil then begin
      if m_MyHero = nil then m_MyHero := Actor;
      if (m_MySelf <> nil) and (Actor <> nil) and (not Actor.m_boDeath) then
        m_ShowBossList.Hint(Actor);
    end;
  end;
  if m_MyHero <> nil then begin //生成英雄状态改变的数据包

    if m_btVersion = 0 then begin
      Msg := MakeDefaultMsg(SM_CHARSTATUSCHANGED, DefMsg.Recog, 0, 0, 0);
      m_sCharStatusChange := EncodeMessage(Msg);
      m_sCharStatusChange := '#' + Copy(m_sCharStatusChange, 1, 8);

      Msg := MakeDefaultMsg(SM_TURN, DefMsg.Recog, 0, 0, 0);
      m_sTurn := EncodeMessage(Msg);
      m_sTurn := '#' + Copy(m_sTurn, 1, 8);

      Msg := MakeDefaultMsg(SM_WALK, DefMsg.Recog, 0, 0, 0);
      m_sWalk := EncodeMessage(Msg);
      m_sWalk := '#' + Copy(m_sWalk, 1, 8);

      Msg := MakeDefaultMsg(SM_BACKSTEP, DefMsg.Recog, 0, 0, 0);
      m_sBackStep := EncodeMessage(Msg);
      m_sBackStep := '#' + Copy(m_sBackStep, 1, 8);

      Msg := MakeDefaultMsg(SM_RUSH, DefMsg.Recog, 0, 0, 0);
      m_sRush := EncodeMessage(Msg);
      m_sRush := '#' + Copy(m_sRush, 1, 8);

      Msg := MakeDefaultMsg(SM_RUSHKUNG, DefMsg.Recog, 0, 0, 0);
      m_sRushKung := EncodeMessage(Msg);
      m_sRushKung := '#' + Copy(m_sRushKung, 1, 8);

      Msg := MakeDefaultMsg(SM_RUN, DefMsg.Recog, 0, 0, 0);
      m_sRun := EncodeMessage(Msg);
      m_sRun := '#' + Copy(m_sRun, 1, 8);

      Msg := MakeDefaultMsg(SM_HORSERUN, DefMsg.Recog, 0, 0, 0);
      m_sHorseRun := EncodeMessage(Msg);
      m_sHorseRun := '#' + Copy(m_sHorseRun, 1, 8);

      Msg := MakeDefaultMsg(SM_DIGUP, DefMsg.Recog, 0, 0, 0);
      m_sDigup := EncodeMessage(Msg);
      m_sDigup := '#' + Copy(m_sDigup, 1, 8);

      Msg := MakeDefaultMsg(SM_ALIVE, DefMsg.Recog, 0, 0, 0);
      m_sAlive := EncodeMessage(Msg);
      m_sAlive := '#' + Copy(m_sAlive, 1, 8);
    end else begin
      Msg_IGE := MakeDefaultMsg_IGE(SM_CHARSTATUSCHANGED, DefMsg.Recog, 0, 0, 0);
      m_sCharStatusChange := EncodeMessage_IGE(Msg_IGE);
      m_sCharStatusChange := '#' + Copy(m_sCharStatusChange, 1, 8);

      Msg_IGE := MakeDefaultMsg_IGE(SM_TURN, DefMsg.Recog, 0, 0, 0);
      m_sTurn := EncodeMessage_IGE(Msg_IGE);
      m_sTurn := '#' + Copy(m_sTurn, 1, 8);

      Msg_IGE := MakeDefaultMsg_IGE(SM_WALK, DefMsg.Recog, 0, 0, 0);
      m_sWalk := EncodeMessage_IGE(Msg_IGE);
      m_sWalk := '#' + Copy(m_sWalk, 1, 8);

      Msg_IGE := MakeDefaultMsg_IGE(SM_BACKSTEP, DefMsg.Recog, 0, 0, 0);
      m_sBackStep := EncodeMessage_IGE(Msg_IGE);
      m_sBackStep := '#' + Copy(m_sBackStep, 1, 8);

      Msg_IGE := MakeDefaultMsg_IGE(SM_RUSH, DefMsg.Recog, 0, 0, 0);
      m_sRush := EncodeMessage_IGE(Msg_IGE);
      m_sRush := '#' + Copy(m_sRush, 1, 8);

      Msg_IGE := MakeDefaultMsg_IGE(SM_RUSHKUNG, DefMsg.Recog, 0, 0, 0);
      m_sRushKung := EncodeMessage_IGE(Msg_IGE);
      m_sRushKung := '#' + Copy(m_sRushKung, 1, 8);

      Msg_IGE := MakeDefaultMsg_IGE(SM_RUN, DefMsg.Recog, 0, 0, 0);
      m_sRun := EncodeMessage_IGE(Msg_IGE);
      m_sRun := '#' + Copy(m_sRun, 1, 8);

      Msg_IGE := MakeDefaultMsg_IGE(SM_HORSERUN, DefMsg.Recog, 0, 0, 0);
      m_sHorseRun := EncodeMessage_IGE(Msg_IGE);
      m_sHorseRun := '#' + Copy(m_sHorseRun, 1, 8);

      Msg_IGE := MakeDefaultMsg_IGE(SM_DIGUP, DefMsg.Recog, 0, 0, 0);
      m_sDigup := EncodeMessage_IGE(Msg_IGE);
      m_sDigup := '#' + Copy(m_sDigup, 1, 8);

      Msg_IGE := MakeDefaultMsg_IGE(SM_ALIVE, DefMsg.Recog, 0, 0, 0);
      m_sAlive := EncodeMessage_IGE(Msg_IGE);
      m_sAlive := '#' + Copy(m_sAlive, 1, 8);

      //SendOutStr('TGameEngine.ClientObjRecallHero');
    end;
  end;
end;

procedure TGameEngine.ClientObjCreateHero(DefMsg: TDefaultMessage;
  sData: string);
var
  MessageBodyWL: TMessageBodyWL;
  MessageBodyW: TMessageBodyW;

  Actor: TActor;
  Msg: TDefaultMessage;
  Msg_IGE: TDefaultMessage_IGE;
begin
  m_dwRecallBackHero := GetTickCount + 1000 * 30;
  DecodeBuffer(sData, @MessageBodyWL, SizeOf(TMessageBodyWL));
  Actor := FindActor(DefMsg.Recog);
  if Actor = nil then begin
    Actor := NewActor(DefMsg.Recog, DefMsg.param, DefMsg.tag, DefMsg.series, MessageBodyWL.lParam1, MessageBodyWL.lParam2);
    if (m_MySelf <> nil) and (Actor <> nil) and (not Actor.m_boDeath) then
      m_ShowBossList.Hint(Actor);
  end;
  if Actor <> nil then begin
    if m_MyHero = nil then m_MyHero := Actor;
    //Actor.m_nCurrentEvent := MessageBodyWL.lTag1;
    Actor.SendMsg(DefMsg.ident,
      DefMsg.param {x},
      DefMsg.tag {y},
      DefMsg.series {dir + light},
      MessageBodyWL.lParam1,
      MessageBodyWL.lParam2, '', 0);
  end;
  if m_MyHero <> nil then begin //生成英雄状态改变的数据包
    if m_btVersion = 0 then begin
      Msg := MakeDefaultMsg(SM_CHARSTATUSCHANGED, DefMsg.Recog, 0, 0, 0);
      m_sCharStatusChange := EncodeMessage(Msg);
      m_sCharStatusChange := '#' + Copy(m_sCharStatusChange, 1, 8);

      Msg := MakeDefaultMsg(SM_TURN, DefMsg.Recog, 0, 0, 0);
      m_sTurn := EncodeMessage(Msg);
      m_sTurn := '#' + Copy(m_sTurn, 1, 8);

      Msg := MakeDefaultMsg(SM_WALK, DefMsg.Recog, 0, 0, 0);
      m_sWalk := EncodeMessage(Msg);
      m_sWalk := '#' + Copy(m_sWalk, 1, 8);

      Msg := MakeDefaultMsg(SM_BACKSTEP, DefMsg.Recog, 0, 0, 0);
      m_sBackStep := EncodeMessage(Msg);
      m_sBackStep := '#' + Copy(m_sBackStep, 1, 8);

      Msg := MakeDefaultMsg(SM_RUSH, DefMsg.Recog, 0, 0, 0);
      m_sRush := EncodeMessage(Msg);
      m_sRush := '#' + Copy(m_sRush, 1, 8);

      Msg := MakeDefaultMsg(SM_RUSHKUNG, DefMsg.Recog, 0, 0, 0);
      m_sRushKung := EncodeMessage(Msg);
      m_sRushKung := '#' + Copy(m_sRushKung, 1, 8);

      Msg := MakeDefaultMsg(SM_RUN, DefMsg.Recog, 0, 0, 0);
      m_sRun := EncodeMessage(Msg);
      m_sRun := '#' + Copy(m_sRun, 1, 8);

      Msg := MakeDefaultMsg(SM_HORSERUN, DefMsg.Recog, 0, 0, 0);
      m_sHorseRun := EncodeMessage(Msg);
      m_sHorseRun := '#' + Copy(m_sHorseRun, 1, 8);

      Msg := MakeDefaultMsg(SM_DIGUP, DefMsg.Recog, 0, 0, 0);
      m_sDigup := EncodeMessage(Msg);
      m_sDigup := '#' + Copy(m_sDigup, 1, 8);

      Msg := MakeDefaultMsg(SM_ALIVE, DefMsg.Recog, 0, 0, 0);
      m_sAlive := EncodeMessage(Msg);
      m_sAlive := '#' + Copy(m_sAlive, 1, 8);
    end else begin
      Msg_IGE := MakeDefaultMsg_IGE(SM_CHARSTATUSCHANGED, DefMsg.Recog, 0, 0, 0);
      m_sCharStatusChange := EncodeMessage_IGE(Msg_IGE);
      m_sCharStatusChange := '#' + Copy(m_sCharStatusChange, 1, 8);

      Msg_IGE := MakeDefaultMsg_IGE(SM_TURN, DefMsg.Recog, 0, 0, 0);
      m_sTurn := EncodeMessage_IGE(Msg_IGE);
      m_sTurn := '#' + Copy(m_sTurn, 1, 8);

      Msg_IGE := MakeDefaultMsg_IGE(SM_WALK, DefMsg.Recog, 0, 0, 0);
      m_sWalk := EncodeMessage_IGE(Msg_IGE);
      m_sWalk := '#' + Copy(m_sWalk, 1, 8);

      Msg_IGE := MakeDefaultMsg_IGE(SM_BACKSTEP, DefMsg.Recog, 0, 0, 0);
      m_sBackStep := EncodeMessage_IGE(Msg_IGE);
      m_sBackStep := '#' + Copy(m_sBackStep, 1, 8);

      Msg_IGE := MakeDefaultMsg_IGE(SM_RUSH, DefMsg.Recog, 0, 0, 0);
      m_sRush := EncodeMessage_IGE(Msg_IGE);
      m_sRush := '#' + Copy(m_sRush, 1, 8);

      Msg_IGE := MakeDefaultMsg_IGE(SM_RUSHKUNG, DefMsg.Recog, 0, 0, 0);
      m_sRushKung := EncodeMessage_IGE(Msg_IGE);
      m_sRushKung := '#' + Copy(m_sRushKung, 1, 8);

      Msg_IGE := MakeDefaultMsg_IGE(SM_RUN, DefMsg.Recog, 0, 0, 0);
      m_sRun := EncodeMessage_IGE(Msg_IGE);
      m_sRun := '#' + Copy(m_sRun, 1, 8);

      Msg_IGE := MakeDefaultMsg_IGE(SM_HORSERUN, DefMsg.Recog, 0, 0, 0);
      m_sHorseRun := EncodeMessage_IGE(Msg_IGE);
      m_sHorseRun := '#' + Copy(m_sHorseRun, 1, 8);

      Msg_IGE := MakeDefaultMsg_IGE(SM_DIGUP, DefMsg.Recog, 0, 0, 0);
      m_sDigup := EncodeMessage_IGE(Msg_IGE);
      m_sDigup := '#' + Copy(m_sDigup, 1, 8);

      Msg_IGE := MakeDefaultMsg_IGE(SM_ALIVE, DefMsg.Recog, 0, 0, 0);
      m_sAlive := EncodeMessage_IGE(Msg_IGE);
      m_sAlive := '#' + Copy(m_sAlive, 1, 8);
      //SendOutStr('TGameEngine.ClientObjCreateHero');
    end;
  end;
end;

procedure TGameEngine.ClientObjHeroDeath(DefMsg: TDefaultMessage);
var
  Actor: TActor;
begin //英雄死亡
  m_dwRecallBackHero := GetTickCount + 1000 * 30;
  m_dwHintRecallBackHero := GetTickCount;
  ArrangeHeroItemBag;
  if m_MyHero <> nil then begin
    m_MyHero.m_boDeath := True;
    Actor := FindActor(DefMsg.Recog);
    if Actor = nil then begin
      case m_btVersion of
        0: begin
            m_MyHero.m_Abil_BLUE.HP := 0;
          end;
        1: begin
            m_MyHero.m_Abil_IGE.HP := 0;
          end;
      end;
    end;
  end;
end;

procedure TGameEngine.ClientObjHeroLogOut(DefMsg: TDefaultMessage);
var
  Actor: TActor;
begin //英雄退出
  ArrangeHeroItemBag;
  m_dwRecallBackHero := GetTickCount + 1000 * 30;
  Actor := FindActor(DefMsg.Recog);
  if Actor <> nil then begin
    //Actor.SendMsg(SM_HEROLOGOUT, DefMsg.Recog, DefMsg.param {X}, DefMsg.tag {Y}, DefMsg.series {d}, 0, '', 0);
    if m_MyHero = Actor then begin
      DelActor(Actor);
      m_MyHero := nil;
      ClearHeroDate;
    end;
  end else begin
    if (m_MyHero <> nil) and (m_MyHero.m_nRecogId = DefMsg.Recog) then begin
      AddFreeDeleteActor(m_MyHero);
      m_MyHero := nil;
    end;
  end;
  m_MyHero := nil;
end;

procedure TGameEngine.ClientObjHeroAbility(DefMsg: TDefaultMessage;
  sData: string);
begin
  if m_MyHero <> nil then begin
    case m_btVersion of
      0: DecodeBuffer(sData, @m_MyHero.m_Abil_BLUE, SizeOf(TAbility_BLUE));
      1: DecodeBuffer(sData, @m_MyHero.m_Abil_IGE, SizeOf(TAbility_IGE));
    end;
    m_MyHero.m_btJob := LoByte(DefMsg.param);
  end;
end;

procedure TGameEngine.ClientObjHeroSubAbility(DefMsg: TDefaultMessage);
begin
  m_nMyHeroHitPoint := LoByte(DefMsg.param);
  m_nMyHeroSpeedPoint := HiByte(DefMsg.param);
  m_nMyHeroAntiPoison := LoByte(DefMsg.tag);
  m_nMyHeroPoisonRecover := HiByte(DefMsg.tag);
  m_nMyHeroHealthRecover := LoByte(DefMsg.series);
  m_nMyHeroSpellRecover := HiByte(DefMsg.series);
  m_nMyHeroAntiMagic := LoByte(LongWord(DefMsg.Recog));
end;

procedure TGameEngine.ClientObjFireDragonPoint(DefMsg: TDefaultMessage);
begin
  case m_btVersion of
    0: m_nMaxFirDragonPoint := DefMsg.tag;
    1: m_nMaxFirDragonPoint := DefMsg.param;
  end;
  m_nFirDragonPoint := DefMsg.Recog;
end;

procedure TGameEngine.ClientObjHeroTakeOnOK(DefMsg: TDefaultMessage);
begin
  if m_MyHero <> nil then begin
    m_MyHero.m_nFeature := DefMsg.Recog;
    m_MyHero.FeatureChanged;
  end;
  case m_btVersion of
    0: begin
        if m_WaitingUseItem_BLUE.Index in [0..12] then
          m_HeroUseItems_BLUE[m_WaitingUseItem_BLUE.Index] := m_WaitingUseItem_BLUE.Item;
        m_WaitingUseItem_BLUE.Item.s.Name := '';
      end;
    1: begin
        if m_WaitingUseItem_IGE.Index in [0..12] then
          m_HeroUseItems_IGE[m_WaitingUseItem_IGE.Index] := m_WaitingUseItem_IGE.Item;
        m_WaitingUseItem_IGE.Item.s.Name := '';
      end;
  end;
end;

procedure TGameEngine.ClientObjHeroTakeOnFail();
begin
  case m_btVersion of
    0: begin
        AddHeroItemBag_BLUE(m_WaitingUseItem_BLUE.Item);
        m_WaitingUseItem_BLUE.Item.s.Name := '';
      end;
    1: begin
        AddHeroItemBag_IGE(m_WaitingUseItem_IGE.Item);
        m_WaitingUseItem_IGE.Item.s.Name := '';
      end;
  end;
end;

procedure TGameEngine.ClientObjHeroTakeOffOK(DefMsg: TDefaultMessage);
begin
  if m_MyHero <> nil then begin
    m_MyHero.m_nFeature := DefMsg.Recog;
    m_MyHero.FeatureChanged;
  end;
  case m_btVersion of
    0: m_WaitingUseItem_BLUE.Item.s.Name := '';
    1: m_WaitingUseItem_IGE.Item.s.Name := '';
  end;
end;

procedure TGameEngine.ClientObjHeroTakeOffFail();
var
  nIndex: Integer;
begin
  case m_btVersion of
    0: begin
        if m_WaitingUseItem_BLUE.Index < 0 then begin
          nIndex := -(m_WaitingUseItem_BLUE.Index + 1);
          m_HeroUseItems_BLUE[nIndex] := m_WaitingUseItem_BLUE.Item;
        end;
        m_WaitingUseItem_BLUE.Item.s.Name := '';
      end;
    1: begin
        if m_WaitingUseItem_IGE.Index < 0 then begin
          nIndex := -(m_WaitingUseItem_IGE.Index + 1);
          m_HeroUseItems_IGE[nIndex] := m_WaitingUseItem_IGE.Item;
        end;
        m_WaitingUseItem_IGE.Item.s.Name := '';
      end;
  end;
end;

procedure TGameEngine.ClientObjTakeOffHeroBagOK(DefMsg: TDefaultMessage);
begin
  if m_MySelf <> nil then begin
    m_MySelf.m_nFeature := DefMsg.Recog;
    m_MySelf.FeatureChanged;
  end;
  case m_btVersion of
    0: m_WaitingUseItem_BLUE.Item.s.Name := '';
    1: m_WaitingUseItem_IGE.Item.s.Name := '';
  end;
end;

procedure TGameEngine.ClientObjTakeOffHeroBagFail();
var
  nIndex: Integer;
begin
  case m_btVersion of
    0: begin
        if m_WaitingUseItem_BLUE.Index < 0 then begin
          nIndex := -(m_WaitingUseItem_BLUE.Index + 1);
          m_UseItems_BLUE[nIndex] := m_WaitingUseItem_BLUE.Item;
        end;
        m_WaitingUseItem_BLUE.Item.s.Name := '';
      end;
    1: begin
        if m_WaitingUseItem_IGE.Index < 0 then begin
          nIndex := -(m_WaitingUseItem_IGE.Index + 1);
          m_UseItems_IGE[nIndex] := m_WaitingUseItem_IGE.Item;
        end;
        m_WaitingUseItem_IGE.Item.s.Name := '';
      end;
  end;
end;

procedure TGameEngine.ClientObjTakeOffMasterBagOK(DefMsg: TDefaultMessage);
begin
  if m_MyHero <> nil then begin
    m_MyHero.m_nFeature := DefMsg.Recog;
    m_MyHero.FeatureChanged;
  end;
  case m_btVersion of
    0: m_WaitingUseItem_BLUE.Item.s.Name := '';
    1: m_WaitingUseItem_IGE.Item.s.Name := '';
  end;
end;

procedure TGameEngine.ClientObjTakeOffMasterBagFail();
begin
  ClientObjHeroTakeOffFail();
end;

procedure TGameEngine.ClientObjToMasterBagOK();
begin //英雄包裹到主人包裹成功
  case m_btVersion of
    0: begin
        if m_WaitingUseItem_BLUE.Item.s.Name <> '' then begin
          AddItemBag_BLUE(m_WaitingUseItem_BLUE.Item);
        end;
        m_WaitingUseItem_BLUE.Item.s.Name := '';
      end;
    1: begin
        if m_WaitingUseItem_IGE.Item.s.Name <> '' then begin
          AddItemBag_IGE(m_WaitingUseItem_IGE.Item);
        end;
        m_WaitingUseItem_IGE.Item.s.Name := '';
      end;
  end;
end;

procedure TGameEngine.ClientObjToMasterBagFail();
begin //英雄包裹到主人包裹失败
  case m_btVersion of
    0: begin
        if m_WaitingUseItem_BLUE.Item.s.Name <> '' then begin
          AddHeroItemBag_BLUE(m_WaitingUseItem_BLUE.Item);
        end;
        m_WaitingUseItem_BLUE.Item.s.Name := '';
      end;
    1: begin
        if m_WaitingUseItem_IGE.Item.s.Name <> '' then begin
          AddHeroItemBag_IGE(m_WaitingUseItem_IGE.Item);
        end;
        m_WaitingUseItem_IGE.Item.s.Name := '';
      end;
  end;
end;

procedure TGameEngine.ClientObjToHeroBagOK();
begin //主人包裹到英雄包裹
  case m_btVersion of
    0: begin
        if m_WaitingUseItem_BLUE.Item.s.Name <> '' then begin
          AddHeroItemBag_BLUE(m_WaitingUseItem_BLUE.Item);
        end;
        m_WaitingUseItem_BLUE.Item.s.Name := '';
      end;
    1: begin
        if m_WaitingUseItem_IGE.Item.s.Name <> '' then begin
          AddItemBag_IGE(m_WaitingUseItem_IGE.Item);
        end;
        m_WaitingUseItem_IGE.Item.s.Name := '';
      end;
  end;
end;

procedure TGameEngine.ClientObjToHeroBagFail();
begin //主人包裹到英雄包裹
  case m_btVersion of
    0: begin
        if m_WaitingUseItem_BLUE.Item.s.Name <> '' then begin
          AddItemBag_BLUE(m_WaitingUseItem_BLUE.Item);
        end;
        m_WaitingUseItem_BLUE.Item.s.Name := '';
      end;
    1: begin
        if m_WaitingUseItem_IGE.Item.s.Name <> '' then begin
          AddItemBag_IGE(m_WaitingUseItem_IGE.Item);
        end;
        m_WaitingUseItem_IGE.Item.s.Name := '';
      end;
  end;
end;

procedure TGameEngine.ClientObjHeroBagCount(DefMsg: TDefaultMessage);
begin
  {if m_MyHero <> nil then begin
    m_MyHero.m_nBagItemCount := DefMsg.Recog;
  end;}
  m_nMaxBagCount := DefMsg.Recog;
end;

procedure TGameEngine.ClientObjHeroWeigthChanged(DefMsg: TDefaultMessage);
begin
  case m_btVersion of
    0: begin
        if m_MyHero <> nil then begin
          m_MyHero.m_Abil_BLUE.Weight := DefMsg.Recog;
          m_MyHero.m_Abil_BLUE.WearWeight := DefMsg.param;
          m_MyHero.m_Abil_BLUE.HandWeight := DefMsg.tag;
        end;
      end;
    1: begin
        if m_MyHero <> nil then begin
          m_MyHero.m_Abil_IGE.Weight := DefMsg.Recog;
          m_MyHero.m_Abil_IGE.WearWeight := DefMsg.param;
          m_MyHero.m_Abil_IGE.HandWeight := DefMsg.tag;
        end;
      end;
  end;
end;

procedure TGameEngine.ClientGetHeroUpdateItem(body: string);
var
  I: Integer;
  ClientItem_BLUE: TClientItem_BLUE;
  ClientItem_IGE: TClientItem_IGE;
begin
  if body <> '' then begin
    case m_btVersion of
      0: begin
          DecodeBuffer(body, @ClientItem_BLUE, SizeOf(ClientItem_BLUE));
          UpdateHeroItemBag_BLUE(ClientItem_BLUE);

          for I := Low(m_HeroUseItems_BLUE) to High(m_HeroUseItems_BLUE) do begin
            if (m_HeroUseItems_BLUE[I].s.Name = ClientItem_BLUE.s.Name) and (m_HeroUseItems_BLUE[I].MakeIndex = ClientItem_BLUE.MakeIndex) then begin
              m_HeroUseItems_BLUE[I] := ClientItem_BLUE;
            end;
          end;
        end;
      1: begin
          DecodeBuffer(body, @ClientItem_IGE, SizeOf(ClientItem_IGE));
          UpdateHeroItemBag_IGE(ClientItem_IGE);
          for I := Low(m_HeroUseItems_IGE) to High(m_HeroUseItems_IGE) do begin
            if (m_HeroUseItems_IGE[I].s.Name = ClientItem_IGE.s.Name) and (m_HeroUseItems_IGE[I].MakeIndex = ClientItem_IGE.MakeIndex) then begin
              m_HeroUseItems_IGE[I] := ClientItem_IGE;
            end;
          end;
        end;
    end;
  end;
  ArrangeHeroItemBag;
end;

procedure TGameEngine.ClientGetHeroDelItem(body: string);
var
  I: Integer;
  ClientItem_BLUE: TClientItem_BLUE;
  ClientItem_IGE: TClientItem_IGE;
begin
  if body <> '' then begin
    case m_btVersion of
      0: begin
          DecodeBuffer(body, @ClientItem_BLUE, SizeOf(ClientItem_BLUE));
          //UpdateHeroItemBag_BLUE(ClientItem_BLUE);
          if (m_EatingItem.BLUE.s.Name = ClientItem_BLUE.s.Name) and
            (m_EatingItem.BLUE.MakeIndex = ClientItem_BLUE.MakeIndex) then begin
            m_EatingItem.BLUE.s.Name := '';
          end;
          if (m_HeroEatingItem.BLUE.s.Name = ClientItem_BLUE.s.Name) and
            (m_HeroEatingItem.BLUE.MakeIndex = ClientItem_BLUE.MakeIndex) then begin
            m_HeroEatingItem.BLUE.s.Name := '';
          end;
          DelHeroItemBag(ClientItem_BLUE.s.Name, ClientItem_BLUE.MakeIndex);

          for I := Low(m_HeroUseItems_BLUE) to High(m_HeroUseItems_BLUE) do begin
            if (m_HeroUseItems_BLUE[I].s.Name = ClientItem_BLUE.s.Name) and (m_HeroUseItems_BLUE[I].MakeIndex = ClientItem_BLUE.MakeIndex) then begin
              m_HeroUseItems_BLUE[I].s.Name := '';
            end;
          end;
        end;
      1: begin
          DecodeBuffer(body, @ClientItem_IGE, SizeOf(ClientItem_IGE));
          //UpdateHeroItemBag_IGE(ClientItem_IGE);
          DelHeroItemBag(ClientItem_IGE.s.Name, ClientItem_IGE.MakeIndex);

          if (m_EatingItem.IGE.s.Name = ClientItem_IGE.s.Name) and
            (m_EatingItem.IGE.MakeIndex = ClientItem_IGE.MakeIndex) then begin
            m_EatingItem.IGE.s.Name := '';
          end;
          if (m_HeroEatingItem.IGE.s.Name = ClientItem_IGE.s.Name) and
            (m_HeroEatingItem.IGE.MakeIndex = ClientItem_IGE.MakeIndex) then begin
            m_HeroEatingItem.IGE.s.Name := '';
          end;

          for I := Low(m_HeroUseItems_IGE) to High(m_HeroUseItems_IGE) do begin
            if (m_HeroUseItems_IGE[I].s.Name = ClientItem_IGE.s.Name) and (m_HeroUseItems_IGE[I].MakeIndex = ClientItem_IGE.MakeIndex) then begin
              m_HeroUseItems_IGE[I].s.Name := '';
            end;
          end;
        end;
    end;
  end;
  ArrangeHeroItemBag;
end;

procedure TGameEngine.ClientGetHeroDelItems(body: string);
var
  I, iindex: Integer;
  Str, iname, sMsg: string;
begin
  sMsg := DecodeString(body);
  while sMsg <> '' do begin
    sMsg := GetValidStr3(sMsg, iname, ['/']);
    sMsg := GetValidStr3(sMsg, Str, ['/']);
    if (iname <> '') and (Str <> '') then begin
      iindex := Str_ToInt(Str, 0);
      DelHeroItemBag(iname, iindex);
      case m_btVersion of
        0: begin

            if (m_EatingItem.BLUE.s.Name = iname) and
              (m_EatingItem.BLUE.MakeIndex = iindex) then begin
              m_EatingItem.BLUE.s.Name := '';
            end;
            if (m_HeroEatingItem.BLUE.s.Name = iname) and
              (m_HeroEatingItem.BLUE.MakeIndex = iindex) then begin
              m_HeroEatingItem.BLUE.s.Name := '';
            end;

            for I := Low(m_HeroUseItems_BLUE) to High(m_HeroUseItems_BLUE) do begin
              if (m_HeroUseItems_BLUE[I].s.Name = iname) and (m_HeroUseItems_BLUE[I].MakeIndex = iindex) then begin
                m_HeroUseItems_BLUE[I].s.Name := '';
              end;
            end;
          end;
        1: begin
            if (m_EatingItem.IGE.s.Name = iname) and
              (m_EatingItem.IGE.MakeIndex = iindex) then begin
              m_EatingItem.IGE.s.Name := '';
            end;
            if (m_HeroEatingItem.IGE.s.Name = iname) and
              (m_HeroEatingItem.IGE.MakeIndex = iindex) then begin
              m_HeroEatingItem.IGE.s.Name := '';
            end;
            for I := Low(m_HeroUseItems_IGE) to High(m_HeroUseItems_IGE) do begin
              if (m_HeroUseItems_IGE[I].s.Name = iname) and (m_HeroUseItems_IGE[I].MakeIndex = iindex) then begin
                m_HeroUseItems_IGE[I].s.Name := '';
              end;
            end;
          end;
      end;
    end else Break;
  end;
  ArrangeHeroItemBag;
end;

procedure TGameEngine.ClientGetHeroBagItmes(DefMsg: TDefaultMessage; body: string);
var
  sData, Str: string;
  ClientItem_BLUE: TClientItem_BLUE;
  ClientItem_IGE: TClientItem_IGE;
begin
  sData := body;
  if m_btVersion = 0 then begin
    SafeFillChar(m_HeroItemArr_BLUE, SizeOf(TClientItem_BLUE) * MAXHEROBAGITEM, #0);
    ClearEatItemFailList;
  end else begin
    if DefMsg.param = 0 then begin
      SafeFillChar(m_HeroItemArr_IGE, SizeOf(TClientItem_IGE) * MAXHEROBAGITEM, #0);
      ClearEatItemFailList;
    end;
  end;
  while True do begin
    if sData = '' then Break;
    sData := GetValidStr3(sData, Str, ['/']);
    if Str <> '' then begin
      case m_btVersion of
        0: begin
            DecodeBuffer(Str, @ClientItem_BLUE, SizeOf(TClientItem_BLUE));
            AddHeroItemBag_BLUE(ClientItem_BLUE);
            m_nMaxBagCount := DefMsg.series;
          end;
        1: begin
            DecodeBuffer(Str, @ClientItem_IGE, SizeOf(TClientItem_IGE));
            AddHeroItemBag_IGE(ClientItem_IGE);
          end;
      end;
    end;
  end;
  ArrangeHeroItemBag;
end;

//英雄相关

procedure TGameEngine.ClientGetHeroAddItem(body: string);
var
  ClientItem_BLUE: TClientItem_BLUE;
  ClientItem_IGE: TClientItem_IGE;
begin
  if body <> '' then begin
    case m_btVersion of
      0: begin
          DecodeBuffer(body, @ClientItem_BLUE, SizeOf(TClientItem_BLUE));
          AddHeroItemBag_BLUE(ClientItem_BLUE);
        end;
      1: begin
          DecodeBuffer(body, @ClientItem_IGE, SizeOf(TClientItem_IGE));
          AddHeroItemBag_IGE(ClientItem_IGE);
        end;
    end;
    //DScreen.AddSysMsg('英雄包裹 ' + cu.S.Name + ' 被发现.', 30, 40, clAqua);
  end;
end;

procedure TGameEngine.ClientGetSendHerouseItems(body: string); //英雄装备
var
  Index: Integer;
  Str, Data, sMsg: string;
  ClientItem_BLUE: TClientItem_BLUE;
  ClientItem_IGE: TClientItem_IGE;
begin
  case m_btVersion of
    0: SafeFillChar(m_HeroUseItems_BLUE, SizeOf(TClientItem_BLUE) * High(m_HeroUseItems_BLUE), #0);
    1: SafeFillChar(m_HeroUseItems_IGE, SizeOf(TClientItem_IGE) * High(m_HeroUseItems_IGE), #0);
  end;
  sMsg := body;
  while True do begin
    if sMsg = '' then Break;
    sMsg := GetValidStr3(sMsg, Str, ['/']);
    sMsg := GetValidStr3(sMsg, Data, ['/']);
    Index := Str_ToInt(Str, -1);
    if Index in [0..12] then begin
      if Data <> '' then begin
        case m_btVersion of
          0: begin
              DecodeBuffer(Data, @ClientItem_BLUE, SizeOf(TClientItem_BLUE));
              m_HeroUseItems_BLUE[Index] := ClientItem_BLUE;
            end;
          1: begin
              DecodeBuffer(Data, @ClientItem_IGE, SizeOf(TClientItem_IGE));
              m_HeroUseItems_IGE[Index] := ClientItem_IGE;
            end;
        end;
      end;
    end;
  end;
end;

procedure TGameEngine.ClientGetHeroAddMagic(body: string);
var
  pcm: pTClientMagic;
begin
  if body <> '' then begin
    New(pcm);
    DecodeBuffer(body, @(pcm^), SizeOf(TClientMagic));
    if pcm.Def.sMagicName <> '' then begin
      m_HeroMagicList.Add(pcm);
    end else begin
      Dispose(pcm);
    end;
  end;
end;

procedure TGameEngine.ClientGetHeroDelMagic(magid: Integer);
var
  I: Integer;
begin
  for I := m_HeroMagicList.Count - 1 downto 0 do begin
    if pTClientMagic(m_HeroMagicList[I]).Def.wMagicId = magid then begin
      Dispose(pTClientMagic(m_HeroMagicList[I]));
      m_HeroMagicList.Delete(I);
      Break;
    end;
  end;
end;

procedure TGameEngine.ClientGetMyHeroMagics(body: string);
var
  I: Integer;
  Data, sMsg: string;
  pcm: pTClientMagic;
begin
  for I := 0 to m_HeroMagicList.Count - 1 do begin
    Dispose(pTClientMagic(m_HeroMagicList[I]));
  end;
  m_HeroMagicList.Clear;
  sMsg := body;
  while True do begin
    if sMsg = '' then Break;
    sMsg := GetValidStr3(sMsg, Data, ['/']);
    if Data <> '' then begin
      New(pcm);
      DecodeBuffer(Data, @(pcm^), SizeOf(TClientMagic));
      if pcm.Def.sMagicName <> '' then begin
        m_HeroMagicList.Add(pcm);
      end else begin
        Dispose(pcm);
      end;
    end else Break;
  end;
end;

procedure TGameEngine.ClientGetSendHeroAddUseItems(body: string);
var
  Index: Integer;
  Str, Data, sMsg: string;
  ClientItem_BLUE: TClientItem_BLUE;
  ClientItem_IGE: TClientItem_IGE;
begin
  sMsg := body;
  while True do begin
    if sMsg = '' then Break;
    sMsg := GetValidStr3(sMsg, Str, ['/']);
    sMsg := GetValidStr3(sMsg, Data, ['/']);
    Index := Str_ToInt(Str, -1);
    if Index in [9..12] then begin
      case m_btVersion of
        0: begin
            DecodeBuffer(Data, @ClientItem_BLUE, SizeOf(TClientItem_BLUE));
            m_HeroUseItems_BLUE[Index] := ClientItem_BLUE;
          end;
        1: begin
            DecodeBuffer(Data, @ClientItem_IGE, SizeOf(TClientItem_IGE));
            m_HeroUseItems_IGE[Index] := ClientItem_IGE;
          end;
      end;
    end;
  end;
end;

procedure TGameEngine.ClientObjHeroWinExp(DefMsg: TDefaultMessage);
begin
  if m_MyHero <> nil then begin
    case m_btVersion of
      0: m_MyHero.m_Abil_BLUE.Exp := DefMsg.Recog;
      1: m_MyHero.m_Abil_IGE.Exp := DefMsg.Recog;
    end;
    //DScreen.AddSysMsg('英雄已获得 ' + IntToStr(LongWORD(MakeLong(DefMsg.param, DefMsg.tag))) + ' 点经验值。', SCREENWIDTH - 150, 40, clLime); //SCREENWIDTH - 100, 40, clGreen);
  end;
end;

procedure TGameEngine.ClientObjHeroLevelUp(DefMsg: TDefaultMessage);
begin
  if m_MyHero <> nil then begin
    case m_btVersion of
      0: m_MyHero.m_Abil_BLUE.Level := DefMsg.param;
      1: m_MyHero.m_Abil_IGE.Level := MakeLong(DefMsg.param, DefMsg.Tag);
    end;
    //m_MyHero.SendMsg(SM_LEVELUP, m_MyHero.m_nRecogId, m_MyHero.m_nCurrX {X}, m_MyHero.m_nCurrY {Y}, m_MyHero.m_btDir {d}, 0, '', 0);
    //DScreen.AddSysMsg('英雄升级！', 30, 40, clAqua);
  end;
end;

procedure TGameEngine.ClientObjRepaiFireDragon(DefMsg: TDefaultMessage);
begin
  case m_btVersion of
   { 0: begin
        AddHeroItemBag_BLUE(m_HeroEatingItem_BLUE);
        m_HeroEatingItem_BLUE.s.Name := '';
      end;}
    1: begin
        case DefMsg.Recog of
          2: AddItemBag_IGE(m_EatingItem.IGE);
          4: AddHeroItemBag_IGE(m_HeroEatingItem.IGE);
        end;
        m_EatingItem.IGE.s.Name := '';
      end;
  end;
end;

procedure TGameEngine.ClientGetHeroDuraChange(uidx, newdura, newduramax: Integer);
begin
  if uidx in [0..12] then begin
    case m_btVersion of
      0: begin
          if m_HeroUseItems_BLUE[uidx].s.Name <> '' then begin
            m_HeroUseItems_BLUE[uidx].Dura := newdura;
            m_HeroUseItems_BLUE[uidx].DuraMax := newduramax;
          end;
        end;
      1: begin
          if m_HeroUseItems_IGE[uidx].s.Name <> '' then begin
            m_HeroUseItems_IGE[uidx].Dura := newdura;
            m_HeroUseItems_IGE[uidx].DuraMax := newduramax;
          end;
        end;
    end;
  end;
end;

procedure TGameEngine.ClientObjGroupModeChanged(nOpen: Integer);
begin
  if nOpen > 0 then m_boAllowGroup := True
  else m_boAllowGroup := False;
  m_dwChangeGroupModeTick := GetTickCount;
end;

procedure TGameEngine.ClientObjCreateGroupOK();
begin
  m_dwChangeGroupModeTick := GetTickCount;
  m_boAllowGroup := True;
        {GroupMembers.Add (Myself.UserName);
        GroupMembers.Add (DecodeString(body));}
end;

procedure TGameEngine.ClientObjCreateGroupFail(nFailCode: Integer);
begin
  {m_dwChangeGroupModeTick := GetTickCount;
  case nFailCode of
    -1: FrmDlg.DMessageDlg('编组还未成立或者你还不够等级创建！', [mbOk]);
    -2: FrmDlg.DMessageDlg('输入的人物名称不正确！', [mbOk]);
    -3: FrmDlg.DMessageDlg('您想邀请加入编组的人已经加入了其它组！', [mbOk]);
    -4: FrmDlg.DMessageDlg('对方不允许编组！', [mbOk]);
  end;}
end;

procedure TGameEngine.ClientObjGroupAddManFail(nFailCode: Integer);
begin
  {m_dwChangeGroupModeTick := GetTickCount;
  case nFailCode of
    -1: FrmDlg.DMessageDlg('编组还未成立或者你还不够等级创建！', [mbOk]);
    -2: FrmDlg.DMessageDlg('输入的人物名称不正确！', [mbOk]);
    -3: FrmDlg.DMessageDlg('已经加入编组！', [mbOk]);
    -4: FrmDlg.DMessageDlg('对方不允许编组！', [mbOk]);
    -5: FrmDlg.DMessageDlg('您想邀请加入编组的人已经加入了其它组！', [mbOk]);
  end;}
end;

procedure TGameEngine.ClientObjGroupDelManFail(nFailCode: Integer);
begin
  {m_dwChangeGroupModeTick := GetTickCount;
  case nFailCode of
    -1: FrmDlg.DMessageDlg('编组还未成立或者您还不够等级创建。', [mbOk]);
    -2: FrmDlg.DMessageDlg('输入的人物名称不正确！', [mbOk]);
    -3: FrmDlg.DMessageDlg('此人不在本组中！', [mbOk]);
  end;}
end;

procedure TGameEngine.ClientGetGroupMembers(bodystr: string);
var
  memb, sMsg: string;
begin
  m_GroupMembers.Clear;
  sMsg := bodystr;
  while True do begin
    if sMsg = '' then Break;
    sMsg := GetValidStr3(sMsg, memb, ['/']);
    if memb <> '' then
      m_GroupMembers.Add(memb)
    else Break;
  end;
end;

function TGameEngine.IsGroupMember(uname: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to m_GroupMembers.Count - 1 do begin
    if m_GroupMembers[I] = uname then begin
      Result := True;
      Break;
    end;
  end;
end;

procedure TGameEngine.SendAddGroupMember(withwho: string);
var
  Msg: TDefaultMessage;
  Msg_IGE: TDefaultMessage_IGE;
begin
  if withwho <> '' then begin
    if m_btVersion = 0 then begin
      Msg := MakeDefaultMsg(CM_ADDGROUPMEMBER, 0, 0, 0, 0);
      GameSocket.SendSocket(EncodeMessage(Msg) + EncodeString(withwho));
    end else begin
      Msg_IGE := MakeDefaultMsg_IGE(CM_ADDGROUPMEMBER, 0, 0, 0, 0);
      GameSocket.SendSocket(EncodeMessage_IGE(Msg_IGE) + EncodeString(withwho));
    end;
  end;
end;

procedure TGameEngine.SendDelGroupMember(withwho: string);
var
  Msg: TDefaultMessage;
  Msg_IGE: TDefaultMessage_IGE;
begin
  if withwho <> '' then begin
    if m_btVersion = 0 then begin
      Msg := MakeDefaultMsg(CM_DELGROUPMEMBER, 0, 0, 0, 0);
      GameSocket.SendSocket(EncodeMessage(Msg) + EncodeString(withwho));
    end else begin
      Msg_IGE := MakeDefaultMsg_IGE(CM_DELGROUPMEMBER, 0, 0, 0, 0);
      GameSocket.SendSocket(EncodeMessage_IGE(Msg_IGE) + EncodeString(withwho));
    end;
  end;
end;

procedure TGameEngine.SendCreateGroup(withwho: string);
var
  Msg: TDefaultMessage;
  Msg_IGE: TDefaultMessage_IGE;
begin
  if withwho <> '' then begin
    if m_btVersion = 0 then begin
      Msg := MakeDefaultMsg(CM_CREATEGROUP, 0, 0, 0, 0);
      GameSocket.SendSocket(EncodeMessage(Msg) + EncodeString(withwho));
    end else begin
      Msg_IGE := MakeDefaultMsg_IGE(CM_DELGROUPMEMBER, 0, 0, 0, 0);
      GameSocket.SendSocket(EncodeMessage_IGE(Msg_IGE) + EncodeString(withwho));
    end;
  end;
end;

procedure TGameEngine.SendGroupMode(onoff: Boolean);
var
  Msg: TDefaultMessage;
  Msg_IGE: TDefaultMessage_IGE;
begin
  if m_btVersion = 0 then begin
    if onoff then
      Msg := MakeDefaultMsg(CM_GROUPMODE, 0, 1, 0, 0) //on
    else Msg := MakeDefaultMsg(CM_GROUPMODE, 0, 0, 0, 0); //off
    GameSocket.SendSocket(EncodeMessage(Msg));
  end else begin
    if onoff then
      Msg_IGE := MakeDefaultMsg_IGE(CM_GROUPMODE, 0, 1, 0, 0) //on
    else Msg_IGE := MakeDefaultMsg_IGE(CM_GROUPMODE, 0, 0, 0, 0); //off
    GameSocket.SendSocket(EncodeMessage_IGE(Msg_IGE));
  end;
end;

procedure TGameEngine.SendHeroDropItem(nMakeIndex: Integer; sItemName: string);
var
  I: Integer;
begin
  case m_btVersion of
    0: begin
        for I := 0 to Length(m_HeroItemArr_BLUE) - 1 do begin
          if (m_HeroItemArr_BLUE[I].s.Name = sItemName) and (m_HeroItemArr_BLUE[I].MakeIndex = nMakeIndex) then begin
            //m_WaitingUseItem_BLUE.Item := m_ItemArr_BLUE[I];
            //GameEngine.AddChatBoardString('sItemName:'+sItemName, c_Yellow, c_Red);
            AddDropItem_BLUE(m_ItemArr_BLUE[I]);
            m_HeroItemArr_BLUE[I].s.Name := '';
            Exit;
          end;
        end;
      end;
    1: begin
        for I := 0 to Length(m_HeroItemArr_IGE) - 1 do begin
          if (m_HeroItemArr_IGE[I].s.Name = sItemName) and (m_HeroItemArr_IGE[I].MakeIndex = nMakeIndex) then begin
            //m_WaitingUseItem_IGE.Item := m_HeroItemArr_IGE[I];
            AddDropItem_IGE(m_HeroItemArr_IGE[I]);
            m_HeroItemArr_IGE[I].s.Name := '';
            Exit;
          end;
        end;
      end;
  end;
end;

procedure TGameEngine.SendDropItem(nMakeIndex: Integer; sItemName: string);
var
  I: Integer;
begin
  case m_btVersion of
    0: begin
        for I := 0 to Length(m_ItemArr_BLUE) - 1 do begin
          if (m_ItemArr_BLUE[I].s.Name = sItemName) and (m_ItemArr_BLUE[I].MakeIndex = nMakeIndex) then begin
            //m_WaitingUseItem_BLUE.Item := m_ItemArr_BLUE[I];
            //GameEngine.AddChatBoardString('sItemName:'+sItemName, c_Yellow, c_Red);
            AddDropItem_BLUE(m_ItemArr_BLUE[I]);
            m_ItemArr_BLUE[I].s.Name := '';
            Exit;
          end;
        end;
      end;
    1: begin
        for I := 0 to Length(m_ItemArr_IGE) - 1 do begin
          if (m_ItemArr_IGE[I].s.Name = sItemName) and (m_ItemArr_IGE[I].MakeIndex = nMakeIndex) then begin
            //m_WaitingUseItem_IGE.Item := m_ItemArr_IGE[I];
            AddDropItem_IGE(m_ItemArr_IGE[I]);
            m_ItemArr_IGE[I].s.Name := '';
            Exit;
          end;
        end;
      end;
  end;
end;

procedure TGameEngine.SendTakeOnItem(btWhere: Byte; nMakeIndex: Integer; sItemName: string);
var
  I: Integer;
begin
  case m_btVersion of
    0: begin
        for I := 0 to Length(m_ItemArr_BLUE) - 1 do begin
          if (m_ItemArr_BLUE[I].s.Name = sItemName) and (m_ItemArr_BLUE[I].MakeIndex = nMakeIndex) then begin
            m_WaitingUseItem_BLUE.Index := btWhere;
            m_WaitingUseItem_BLUE.Item := m_ItemArr_BLUE[I];
            m_ItemArr_BLUE[I].s.Name := '';
            Exit;
          end;
        end;
      end;
    1: begin
        for I := 0 to Length(m_ItemArr_IGE) - 1 do begin
          if (m_ItemArr_IGE[I].s.Name = sItemName) and (m_ItemArr_IGE[I].MakeIndex = nMakeIndex) then begin
            m_WaitingUseItem_IGE.Index := btWhere;
            m_WaitingUseItem_IGE.Item := m_ItemArr_IGE[I];
            m_ItemArr_IGE[I].s.Name := '';
            Exit;
          end;
        end;
      end;
  end;
end;

procedure TGameEngine.SendTakeOffItem(btWhere: Byte; nMakeIndex: Integer; sItemName: string);
begin
  case m_btVersion of
    0: begin
        if (btWhere >= 0) and (btWhere < Length(m_UseItems_BLUE)) then begin
          if (m_UseItems_BLUE[btWhere].s.Name = sItemName) and (m_UseItems_BLUE[btWhere].MakeIndex = nMakeIndex) then begin
            m_WaitingUseItem_BLUE.Index := btWhere;
            m_WaitingUseItem_BLUE.Item := m_UseItems_BLUE[btWhere];
            m_UseItems_BLUE[btWhere].s.Name := '';
            Exit;
          end;
        end;
      end;
    1: begin
        if (btWhere >= 0) and (btWhere < Length(m_UseItems_IGE)) then begin
          if (m_UseItems_IGE[btWhere].s.Name = sItemName) and (m_UseItems_IGE[btWhere].MakeIndex = nMakeIndex) then begin
            m_WaitingUseItem_IGE.Index := btWhere;
            m_WaitingUseItem_IGE.Item := m_UseItems_IGE[btWhere];
            m_UseItems_IGE[btWhere].s.Name := '';
            Exit;
          end;
        end;
      end;
  end;
end;

procedure TGameEngine.SendItemToMasterBag(btWhere: Byte; nMakeIndex: Integer; sItemName: string);
var
  I: Integer;
begin
  case m_btVersion of
    0: begin
        for I := 0 to Length(m_HeroItemArr_BLUE) - 1 do begin
          if (m_HeroItemArr_BLUE[I].s.Name = sItemName) and (m_HeroItemArr_BLUE[I].MakeIndex = nMakeIndex) then begin
            m_WaitingUseItem_BLUE.Index := btWhere;
            m_WaitingUseItem_BLUE.Item := m_HeroItemArr_BLUE[I];
            m_HeroItemArr_BLUE[I].s.Name := '';
            Exit;
          end;
        end;
      end;
    1: begin
        for I := 0 to Length(m_HeroItemArr_IGE) - 1 do begin
          if (m_HeroItemArr_IGE[I].s.Name = sItemName) and (m_HeroItemArr_IGE[I].MakeIndex = nMakeIndex) then begin
            m_WaitingUseItem_IGE.Index := btWhere;
            m_WaitingUseItem_IGE.Item := m_HeroItemArr_IGE[I];
            m_HeroItemArr_IGE[I].s.Name := '';
            Exit;
          end;
        end;
      end;
  end;
end;

procedure TGameEngine.SendItemToHeroBag(btWhere: Byte; nMakeIndex: Integer; sItemName: string);
var
  I: Integer;
begin
  case m_btVersion of
    0: begin
        for I := 0 to Length(m_ItemArr_BLUE) - 1 do begin
          if (m_ItemArr_BLUE[I].s.Name = sItemName) and (m_ItemArr_BLUE[I].MakeIndex = nMakeIndex) then begin
            m_WaitingUseItem_BLUE.Index := btWhere;
            m_WaitingUseItem_BLUE.Item := m_ItemArr_BLUE[I];
            m_ItemArr_BLUE[I].s.Name := '';
            Exit;
          end;
        end;
      end;
    1: begin
        for I := 0 to Length(m_ItemArr_IGE) - 1 do begin
          if (m_ItemArr_IGE[I].s.Name = sItemName) and (m_ItemArr_IGE[I].MakeIndex = nMakeIndex) then begin
            m_WaitingUseItem_IGE.Index := btWhere;
            m_WaitingUseItem_IGE.Item := m_ItemArr_IGE[I];
            m_ItemArr_IGE[I].s.Name := '';
            Exit;
          end;
        end;
      end;
  end;
end;

//英雄

procedure TGameEngine.SendHeroTakeOnItem(btWhere: Byte; nMakeIndex: Integer; sItemName: string);
var
  I: Integer;
begin
  case m_btVersion of
    0: begin
        for I := 0 to Length(m_HeroItemArr_BLUE) - 1 do begin
          if (m_HeroItemArr_BLUE[I].s.Name = sItemName) and (m_HeroItemArr_BLUE[I].MakeIndex = nMakeIndex) then begin
            m_WaitingUseItem_BLUE.Index := btWhere;
            m_WaitingUseItem_BLUE.Item := m_HeroItemArr_BLUE[I];
            m_HeroItemArr_BLUE[I].s.Name := '';
            Exit;
          end;
        end;
      end;
    1: begin
        for I := 0 to Length(m_HeroItemArr_IGE) - 1 do begin
          if (m_HeroItemArr_IGE[I].s.Name = sItemName) and (m_HeroItemArr_IGE[I].MakeIndex = nMakeIndex) then begin
            m_WaitingUseItem_IGE.Index := btWhere;
            m_WaitingUseItem_IGE.Item := m_HeroItemArr_IGE[I];
            m_HeroItemArr_IGE[I].s.Name := '';
            Exit;
          end;
        end;
      end;
  end;
end;

procedure TGameEngine.SendHeroTakeOffItem(btWhere: Byte; nMakeIndex: Integer; sItemName: string);
begin
  case m_btVersion of
    0: begin
        if (btWhere >= 0) and (btWhere < Length(m_HeroUseItems_BLUE)) then begin
          if (m_HeroUseItems_BLUE[btWhere].s.Name = sItemName) and (m_HeroUseItems_BLUE[btWhere].MakeIndex = nMakeIndex) then begin
            m_WaitingUseItem_BLUE.Index := btWhere;
            m_WaitingUseItem_BLUE.Item := m_HeroUseItems_BLUE[btWhere];
            m_HeroUseItems_BLUE[btWhere].s.Name := '';
            Exit;
          end;
        end;
      end;
    1: begin
        if (btWhere >= 0) and (btWhere < Length(m_HeroUseItems_IGE)) then begin
          if (m_HeroUseItems_IGE[btWhere].s.Name = sItemName) and (m_HeroUseItems_IGE[btWhere].MakeIndex = nMakeIndex) then begin
            m_WaitingUseItem_IGE.Index := btWhere;
            m_WaitingUseItem_IGE.Item := m_HeroUseItems_IGE[btWhere];
            m_HeroUseItems_IGE[btWhere].s.Name := '';
            Exit;
          end;
        end;
      end;
  end;
end;

//修理火龙之心

procedure TGameEngine.SendRepairFirDragon(nType: Byte; nMakeIndex: Integer; sItemName: string; var sMsg: string);
var
  I: Integer;
  Msg: TDefaultMessage;
  Msg_IGE: TDefaultMessage_IGE;
  sData: string;
  EatingItem: TUserEatItems;
begin
  case m_btVersion of
    0: begin
        if (m_EatingItem.BLUE.s.Name <> '') and (GetTickCount - m_EatingItem.dwEatTime > 5 * 1000) then begin
          m_EatingItem.BLUE.s.Name := '';
        end;
        if (m_EatingItem2.BLUE.s.Name <> '') and (GetTickCount - m_EatingItem2.dwEatTime > 5 * 1000) then begin
          m_EatingItem2.BLUE.s.Name := '';
        end;
        if (m_EatingItem.BLUE.s.Name <> '') or (m_EatingItem2.BLUE.s.Name <> '') then begin
          if (m_EatingItem.BLUE.s.Name <> '') and (m_EatingItem.BLUE.MakeIndex = nMakeIndex) then begin
            m_EatingItem.boSend := True;
            sMsg := '';
            Exit;
          end;
          if (m_EatingItem2.BLUE.s.Name <> '') and (m_EatingItem2.BLUE.MakeIndex = nMakeIndex) then begin
            m_EatingItem2.boSend := True;
            sMsg := '';
            Exit;
          end;
          for I := 0 to Length(m_HeroItemArr_BLUE) - 1 do begin
            if (((sItemName <> '') and (m_HeroItemArr_BLUE[I].s.Name = sItemName)) or ((sItemName = '') and (m_HeroItemArr_BLUE[I].s.Name <> ''))) and (m_HeroItemArr_BLUE[I].MakeIndex = nMakeIndex) then begin
              Msg := MakeDefaultMsg(BLUE_SEND_1104, nMakeIndex, 0, 0, 0);
              sData := EncodeMessage(Msg) { + EncodeString(sItemName)};
              EatingItem.boHero := True;
              EatingItem.boAuto := False;
              EatingItem.boSend := True;
              EatingItem.boBind := m_HeroItemArr_BLUE[I].s.StdMode = 31;
              EatingItem.nIndex := 0;
              EatingItem.BLUE := m_HeroItemArr_BLUE[I];
              AddUserEatItemList(sData, @EatingItem);
              m_HeroItemArr_BLUE[I].s.Name := '';
              break;
            end;
          end;
          sMsg := '';
          Exit;
        end;
        for I := 0 to Length(m_HeroItemArr_BLUE) - 1 do begin
          if (((sItemName <> '') and (m_HeroItemArr_BLUE[I].s.Name = sItemName)) or ((sItemName = '') and (m_HeroItemArr_BLUE[I].s.Name <> ''))) and (m_HeroItemArr_BLUE[I].MakeIndex = nMakeIndex) then begin
          //if (m_HeroItemArr_BLUE[I].s.Name = sItemName) and (m_HeroItemArr_BLUE[I].MakeIndex = nMakeIndex) then begin
            m_HeroEatingItem.BLUE := m_HeroItemArr_BLUE[I];
            m_HeroEatingItem.boHero := True;
            m_HeroEatingItem.boAuto := False;
            m_HeroEatingItem.boSend := True;
            m_HeroEatingItem.boBind := m_HeroItemArr_BLUE[I].s.StdMode = 31;
            m_HeroEatingItem.nIndex := 0;
            m_HeroItemArr_BLUE[I].s.Name := '';
            m_dwHeroEatTime := GetTickCount;
            m_dwEatItemTime := GetTickCount;
            Exit;
          end;
        end;
      end;
    1: begin
        if (m_HeroEatingItem.IGE.s.Name <> '') and (GetTickCount - m_HeroEatingItem2.dwEatTime > 5 * 1000) then begin
          m_HeroEatingItem.IGE.s.Name := '';
        end;
        if (m_HeroEatingItem2.IGE.s.Name <> '') and (GetTickCount - m_HeroEatingItem2.dwEatTime > 5 * 1000) then begin
          m_HeroEatingItem2.IGE.s.Name := '';
        end;
        if (m_HeroEatingItem.IGE.s.Name <> '') or (m_HeroEatingItem2.IGE.s.Name <> '') then begin
          if (m_HeroEatingItem.IGE.s.Name <> '') and (m_HeroEatingItem.IGE.MakeIndex = nMakeIndex) then begin
            m_HeroEatingItem.boSend := True;
            sMsg := '';
            Exit;
          end;
          if (m_HeroEatingItem2.IGE.s.Name <> '') and (m_HeroEatingItem2.IGE.MakeIndex = nMakeIndex) then begin
            m_HeroEatingItem2.boSend := True;
            sMsg := '';
            Exit;
          end;
          for I := 0 to Length(m_HeroItemArr_IGE) - 1 do begin
            if (((sItemName <> '') and (m_HeroItemArr_IGE[I].s.Name = sItemName)) or ((sItemName = '') and (m_HeroItemArr_IGE[I].s.Name <> ''))) and (m_HeroItemArr_IGE[I].MakeIndex = nMakeIndex) then begin
              Msg_IGE := MakeDefaultMsg_IGE(CM_REPAIRFIRDRAGON, nMakeIndex, nType, 0, 0);
              sData := EncodeMessage_IGE(Msg_IGE) + EncodeString(sItemName);
              EatingItem.boHero := True;
              EatingItem.boAuto := False;
              EatingItem.boSend := True;
              EatingItem.boBind := m_HeroItemArr_BLUE[I].s.StdMode = 31;
              EatingItem.nIndex := 0;
              EatingItem.IGE := m_HeroItemArr_IGE[I];
              AddUserEatItemList(sData, @EatingItem);
              m_HeroItemArr_IGE[I].s.Name := '';
              break;
            end;
          end;
          sMsg := '';
          Exit;
        end;
        for I := 0 to Length(m_HeroItemArr_IGE) - 1 do begin
          if (m_HeroItemArr_IGE[I].s.Name = sItemName) and (m_HeroItemArr_IGE[I].MakeIndex = nMakeIndex) then begin
            m_HeroEatingItem.IGE := m_HeroItemArr_IGE[I];
            m_HeroEatingItem.boHero := True;
            m_HeroEatingItem.boAuto := False;
            m_HeroEatingItem.boSend := True;
            m_HeroEatingItem.boBind := m_HeroItemArr_BLUE[I].s.StdMode = 31;
            m_HeroEatingItem.nIndex := 0;
            m_HeroItemArr_IGE[I].s.Name := '';
            m_dwHeroEatTime := GetTickCount;
            m_dwEatItemTime := GetTickCount;
            Exit;
          end;
        end;
      end;
  end;
end;

//吃东西

procedure TGameEngine.SendEat(nMakeIndex: Integer; sItemName: string; var sMsg: string);
var
  I: Integer;
  Msg: TDefaultMessage;
  Msg_IGE: TDefaultMessage_IGE;
  sData: string;
  EatingItem: TUserEatItems;
begin
  case m_btVersion of
    0: begin
        if (m_EatingItem.BLUE.s.Name <> '') and (GetTickCount - m_EatingItem.dwEatTime > 5 * 1000) then begin
          m_EatingItem.BLUE.s.Name := '';
        end;
        if (m_EatingItem2.BLUE.s.Name <> '') and (GetTickCount - m_EatingItem2.dwEatTime > 5 * 1000) then begin
          m_EatingItem2.BLUE.s.Name := '';
        end;
        if (m_EatingItem.BLUE.s.Name <> '') or (m_EatingItem2.BLUE.s.Name <> '') then begin
          if (m_EatingItem.BLUE.s.Name <> '') and (m_EatingItem.BLUE.MakeIndex = nMakeIndex) then begin
            m_EatingItem.boSend := True;
            sMsg := '';
            Exit;
          end;
          if (m_EatingItem2.BLUE.s.Name <> '') and (m_EatingItem2.BLUE.MakeIndex = nMakeIndex) then begin
            m_EatingItem2.boSend := True;
            sMsg := '';
            Exit;
          end;
          for I := 0 to Length(m_ItemArr_BLUE) - 1 do begin
            if (m_ItemArr_BLUE[I].s.Name <> '') and (m_ItemArr_BLUE[I].MakeIndex = nMakeIndex) then begin
              Msg := MakeDefaultMsg(CM_EAT, nMakeIndex, 0, 0, 0);
              sData := EncodeMessage(Msg) {+ EncodeString(sItemName)};
              EatingItem.boHero := False;
              EatingItem.boAuto := False;
              EatingItem.boSend := True;
              EatingItem.boBind := m_ItemArr_BLUE[I].s.StdMode = 31;
              EatingItem.nIndex := 0;
              EatingItem.BLUE := m_ItemArr_BLUE[I];
              AddUserEatItemList(sData, @EatingItem);
              m_ItemArr_BLUE[I].s.Name := '';
              break;
            end;
          end;
          sMsg := '';
          Exit;
        end;
        for I := 0 to Length(m_ItemArr_BLUE) - 1 do begin
          if (m_ItemArr_BLUE[I].s.Name <> '') and (m_ItemArr_BLUE[I].MakeIndex = nMakeIndex) then begin
            m_EatingItem.BLUE := m_ItemArr_BLUE[I];
            m_EatingItem.boHero := False;
            m_EatingItem.boAuto := False;
            m_EatingItem.boSend := True;
            m_EatingItem.boBind := m_ItemArr_BLUE[I].s.StdMode = 31;
            m_EatingItem.nIndex := 0;
            m_EatingItem.dwEatTime := GetTickCount;
            m_ItemArr_BLUE[I].s.Name := '';
            m_dwEatTime := GetTickCount;
            m_dwEatItemTime := GetTickCount;
            Exit;
          end;
        end;
      end;
    1: begin
        if (m_EatingItem.IGE.s.Name <> '') and (GetTickCount - m_EatingItem.dwEatTime > 5 * 1000) then begin
          m_EatingItem.IGE.s.Name := '';
        end;
        if (m_EatingItem2.IGE.s.Name <> '') and (GetTickCount - m_EatingItem2.dwEatTime > 5 * 1000) then begin
          m_EatingItem2.IGE.s.Name := '';
        end;
        if (m_EatingItem.IGE.s.Name <> '') or (m_EatingItem2.IGE.s.Name <> '') then begin
          if (m_EatingItem.IGE.s.Name <> '') and (m_EatingItem.IGE.MakeIndex = nMakeIndex) then begin
            m_EatingItem.boSend := True;
            sMsg := '';
            Exit;
          end;
          if (m_EatingItem2.IGE.s.Name <> '') and (m_EatingItem2.IGE.MakeIndex = nMakeIndex) then begin
            m_EatingItem2.boSend := True;
            sMsg := '';
            Exit;
          end;
          for I := 0 to Length(m_ItemArr_IGE) - 1 do begin
            if (((sItemName <> '') and (m_ItemArr_IGE[I].s.Name = sItemName)) or ((sItemName = '') and (m_ItemArr_IGE[I].s.Name <> ''))) and (m_ItemArr_IGE[I].MakeIndex = nMakeIndex) then begin
              Msg_IGE := MakeDefaultMsg_IGE(CM_EAT, nMakeIndex, 0, 0, 0);
              sData := EncodeMessage_IGE(Msg_IGE) + EncodeString(sItemName);
              EatingItem.boHero := False;
              EatingItem.boAuto := False;
              EatingItem.boSend := True;
              EatingItem.boBind := m_ItemArr_IGE[I].s.StdMode = 31;
              EatingItem.nIndex := 0;
              EatingItem.IGE := m_ItemArr_IGE[I];
              AddUserEatItemList(sData, @EatingItem);
              m_ItemArr_IGE[I].s.Name := '';
              break;
            end;
          end;
          sMsg := '';
          Exit;
        end;
        for I := 0 to Length(m_ItemArr_IGE) - 1 do begin
          if (m_ItemArr_IGE[I].s.Name = sItemName) and (m_ItemArr_IGE[I].MakeIndex = nMakeIndex) then begin
            m_EatingItem.IGE := m_ItemArr_IGE[I];
            m_EatingItem.boHero := False;
            m_EatingItem.boAuto := False;
            m_EatingItem.boSend := True;
            m_EatingItem.boBind := m_ItemArr_IGE[I].s.StdMode = 31;
            m_EatingItem.nIndex := 0;

            m_ItemArr_IGE[I].s.Name := '';
            m_EatingItem.dwEatTime := GetTickCount;
            m_dwEatTime := GetTickCount;
            m_dwEatItemTime := GetTickCount;
            Exit;
          end;
        end;

      end;
  end;
end;

//英雄吃东西

procedure TGameEngine.SendHeroEat(nMakeIndex: Integer; sItemName: string; var sMsg: string);
var
  I: Integer;
  Msg: TDefaultMessage;
  Msg_IGE: TDefaultMessage_IGE;
  sData: string;
  EatingItem: TUserEatItems;
begin
  case m_btVersion of
    0: begin
        if (m_HeroEatingItem.BLUE.s.Name <> '') and (GetTickCount - m_HeroEatingItem.dwEatTime > 5 * 1000) then begin
          m_HeroEatingItem.BLUE.s.Name := '';
        end;
        if (m_HeroEatingItem2.BLUE.s.Name <> '') and (GetTickCount - m_HeroEatingItem2.dwEatTime > 5 * 1000) then begin
          m_HeroEatingItem2.BLUE.s.Name := '';
        end;
        if (m_HeroEatingItem.BLUE.s.Name <> '') or (m_HeroEatingItem2.BLUE.s.Name <> '') then begin
          if (m_HeroEatingItem.BLUE.s.Name <> '') and (m_HeroEatingItem.BLUE.MakeIndex = nMakeIndex) then begin
            m_HeroEatingItem.boSend := True;
            sMsg := '';
            Exit;
          end;
          if (m_HeroEatingItem2.BLUE.s.Name <> '') and (m_HeroEatingItem2.BLUE.MakeIndex = nMakeIndex) then begin
            m_HeroEatingItem2.boSend := True;
            sMsg := '';
            Exit;
          end;
          for I := 0 to Length(m_HeroItemArr_BLUE) - 1 do begin
            if (m_HeroItemArr_BLUE[I].s.Name <> '') and (m_HeroItemArr_BLUE[I].MakeIndex = nMakeIndex) then begin
              Msg := MakeDefaultMsg(BLUE_SEND_1104, nMakeIndex, 0, 0, 0);
              sData := EncodeMessage(Msg) {+ EncodeString(sItemName)};
              EatingItem.boHero := True;
              EatingItem.boAuto := False;
              EatingItem.boSend := True;
              EatingItem.boBind := m_HeroItemArr_BLUE[I].s.StdMode = 31;
              EatingItem.nIndex := 0;
              EatingItem.BLUE := m_HeroItemArr_BLUE[I];
              AddUserEatItemList(sData, @EatingItem);
              m_HeroItemArr_BLUE[I].s.Name := '';
              break;
            end;
          end;
          sMsg := '';
          Exit;
        end;
        for I := 0 to Length(m_HeroItemArr_BLUE) - 1 do begin
          if (m_HeroItemArr_BLUE[I].s.Name <> '') and (m_HeroItemArr_BLUE[I].MakeIndex = nMakeIndex) then begin
            m_HeroEatingItem.BLUE := m_HeroItemArr_BLUE[I];
            m_HeroEatingItem.boHero := True;
            m_HeroEatingItem.boAuto := False;
            m_HeroEatingItem.boSend := True;
            m_HeroEatingItem.boBind := m_HeroItemArr_BLUE[I].s.StdMode = 31;
            m_HeroEatingItem.nIndex := 0;
            m_HeroItemArr_BLUE[I].s.Name := '';
            m_HeroEatingItem.dwEatTime := GetTickCount;
            m_dwHeroEatTime := GetTickCount;
            m_dwEatItemTime := GetTickCount;
            Exit;
          end;
        end;
      end;
    1: begin
        if (m_HeroEatingItem.IGE.s.Name <> '') and (GetTickCount - m_HeroEatingItem2.dwEatTime > 5 * 1000) then begin
          m_HeroEatingItem.IGE.s.Name := '';
        end;
        if (m_HeroEatingItem2.IGE.s.Name <> '') and (GetTickCount - m_HeroEatingItem2.dwEatTime > 5 * 1000) then begin
          m_HeroEatingItem2.IGE.s.Name := '';
        end;
        if (m_HeroEatingItem.IGE.s.Name <> '') or (m_HeroEatingItem2.IGE.s.Name <> '') then begin
          if (m_HeroEatingItem.IGE.s.Name <> '') and (m_HeroEatingItem.IGE.MakeIndex = nMakeIndex) then begin
            m_HeroEatingItem.boSend := True;
            sMsg := '';
            Exit;
          end;
          if (m_HeroEatingItem2.IGE.s.Name <> '') and (m_HeroEatingItem2.IGE.MakeIndex = nMakeIndex) then begin
            m_HeroEatingItem2.boSend := True;
            sMsg := '';
            Exit;
          end;
          for I := 0 to Length(m_HeroItemArr_IGE) - 1 do begin
            if (((sItemName <> '') and (m_HeroItemArr_IGE[I].s.Name = sItemName)) or ((sItemName = '') and (m_HeroItemArr_IGE[I].s.Name <> ''))) and (m_HeroItemArr_IGE[I].MakeIndex = nMakeIndex) then begin
              Msg_IGE := MakeDefaultMsg_IGE(CM_IGE_5043, nMakeIndex, 0, 0, 0);
              sData := EncodeMessage_IGE(Msg_IGE) + EncodeString(sItemName);
              EatingItem.boHero := True;
              EatingItem.boAuto := False;
              EatingItem.boSend := True;
              EatingItem.boBind := m_HeroItemArr_BLUE[I].s.StdMode = 31;
              EatingItem.nIndex := 0;
              EatingItem.IGE := m_HeroItemArr_IGE[I];
              AddUserEatItemList(sData, @EatingItem);
              m_HeroItemArr_IGE[I].s.Name := '';
              break;
            end;
          end;
          sMsg := '';
          Exit;
        end;
        for I := 0 to Length(m_HeroItemArr_IGE) - 1 do begin
          if (m_HeroItemArr_IGE[I].s.Name = sItemName) and (m_HeroItemArr_IGE[I].MakeIndex = nMakeIndex) then begin
            m_HeroEatingItem.IGE := m_HeroItemArr_IGE[I];
            m_HeroEatingItem.boHero := True;
            m_HeroEatingItem.boAuto := False;
            m_HeroEatingItem.boSend := True;
            m_HeroEatingItem.boBind := m_HeroItemArr_BLUE[I].s.StdMode = 31;
            m_HeroEatingItem.nIndex := 0;
            m_HeroItemArr_IGE[I].s.Name := '';
            m_HeroEatingItem.dwEatTime := GetTickCount;
            m_dwHeroEatTime := GetTickCount;
            m_dwEatItemTime := GetTickCount;
            Exit;
          end;
        end;
      end;
  end;
end;

//发送要出售的物品

procedure TGameEngine.SendSellItem(nMakeIndex: Integer; sItemName: string);
var
  I: Integer;
begin
  case m_btVersion of
    0: begin
        for I := 0 to Length(m_ItemArr_BLUE) - 1 do begin
          if (m_ItemArr_BLUE[I].s.Name = sItemName) and (m_ItemArr_BLUE[I].MakeIndex = nMakeIndex) then begin
            m_SellDlgItemSellWait_BLUE := m_ItemArr_BLUE[I];
            m_ItemArr_BLUE[I].s.Name := '';
            Exit;
          end;
        end;
      end;
    1: begin
        for I := 0 to Length(m_ItemArr_IGE) - 1 do begin
          if (m_ItemArr_IGE[I].s.Name = sItemName) and (m_ItemArr_IGE[I].MakeIndex = nMakeIndex) then begin
            m_SellDlgItemSellWait_IGE := m_ItemArr_IGE[I];
            m_ItemArr_IGE[I].s.Name := '';
            Exit;
          end;
        end;
      end;
  end;
end;

//发送要出售的寄售物品

procedure TGameEngine.SendSellOffItem(nMakeIndex: Integer; sItemName: string);
var
  I: Integer;
begin
  for I := 0 to Length(m_ItemArr_IGE) - 1 do begin
    if (m_ItemArr_IGE[I].s.Name = sItemName) and (m_ItemArr_IGE[I].MakeIndex = nMakeIndex) then begin
      m_SellDlgItemSellWait_IGE := m_ItemArr_IGE[I];
      m_ItemArr_IGE[I].s.Name := '';
      Exit;
    end;
  end;
end;

//发送要存放的物品

procedure TGameEngine.SendStorageItem(nMakeIndex: Integer; sItemName: string);
var
  I: Integer;
begin
  case m_btVersion of
    0: begin
        for I := 0 to Length(m_ItemArr_BLUE) - 1 do begin
          if (m_ItemArr_BLUE[I].s.Name = sItemName) and (m_ItemArr_BLUE[I].MakeIndex = nMakeIndex) then begin
            m_SellDlgItemSellWait_BLUE := m_ItemArr_BLUE[I];
            m_ItemArr_BLUE[I].s.Name := '';
            Exit;
          end;
        end;
      end;
    1: begin
        for I := 0 to Length(m_ItemArr_IGE) - 1 do begin
          if (m_ItemArr_IGE[I].s.Name = sItemName) and (m_ItemArr_IGE[I].MakeIndex = nMakeIndex) then begin
            m_SellDlgItemSellWait_IGE := m_ItemArr_IGE[I];
            m_ItemArr_IGE[I].s.Name := '';
            Exit;
          end;
        end;
      end;
  end;
end;

procedure TGameEngine.SendAddDealItem(sData: string);
var
  I: Integer;
  ClientItem_BLUE: TClientItem_BLUE;
  ClientItem_IGE: TClientItem_IGE;
begin
  case m_btVersion of
    0: begin
        DecodeBuffer(sData, @ClientItem_BLUE, SizeOf(TClientItem_BLUE));
        for I := 0 to Length(m_ItemArr_BLUE) - 1 do begin
          if (m_ItemArr_BLUE[I].s.Name = ClientItem_BLUE.s.Name) and (m_ItemArr_BLUE[I].MakeIndex = ClientItem_BLUE.MakeIndex) then begin
            m_DealDlgItem_BLUE := m_ItemArr_BLUE[I];
            m_ItemArr_BLUE[I].s.Name := '';
            Exit;
          end;
        end;
      end;
    1: begin
        DecodeBuffer(sData, @ClientItem_IGE, SizeOf(TClientItem_IGE));
        for I := 0 to Length(m_ItemArr_IGE) - 1 do begin
          if (m_ItemArr_IGE[I].s.Name = ClientItem_IGE.s.Name) and (m_ItemArr_IGE[I].MakeIndex = ClientItem_IGE.MakeIndex) then begin
            m_DealDlgItem_IGE := m_ItemArr_IGE[I];
            m_ItemArr_IGE[I].s.Name := '';
            Exit;
          end;
        end;
      end;
  end;
end;

procedure TGameEngine.SendDelDealItem(sData: string);
var
  I: Integer;
  ClientItem_BLUE: TClientItem_BLUE;
  ClientItem_IGE: TClientItem_IGE;
begin
  case m_btVersion of
    0: begin
        DecodeBuffer(sData, @ClientItem_BLUE, SizeOf(TClientItem_BLUE));
        DelDealItem_BLUE(ClientItem_BLUE);
       { for I := 0 to Length(m_ItemArr_BLUE) - 1 do begin
          if (m_ItemArr_BLUE[I].s.Name = ClientItem_BLUE.s.Name) and (m_ItemArr_BLUE[I].MakeIndex = ClientItem_BLUE.MakeIndex) then begin
            m_DealDlgItem_BLUE := m_ItemArr_BLUE[I];
            m_ItemArr_BLUE[I].s.Name := '';
            Exit;
          end;
        end; }
      end;
    1: begin
        DecodeBuffer(sData, @ClientItem_IGE, SizeOf(TClientItem_IGE));
        DelDealItem_IGE(ClientItem_IGE);
        {for I := 0 to Length(m_ItemArr_IGE) - 1 do begin
          if (m_ItemArr_IGE[I].s.Name = ClientItem_IGE.s.Name) and (m_ItemArr_IGE[I].MakeIndex = ClientItem_IGE.MakeIndex) then begin
            m_DealDlgItem_IGE := m_ItemArr_IGE[I];
            m_ItemArr_IGE[I].s.Name := '';
            Exit;
          end;
        end;}
      end;
  end;
end;

procedure TGameEngine.SendUpgradeItem(sData: string);
var
  I, II: Integer;
  UpgradeItemIndexs: TUpgradeItemIndexs;
  UpdateItemArray_BLUE: TUpdateItemArray_BLUE;
begin
  case m_btVersion of
    0: begin
        DecodeBuffer(sData, @UpdateItemArray_BLUE, SizeOf(TUpdateItemArray_BLUE));
        for I := 0 to Length(UpdateItemArray_BLUE) - 1 do begin
          for II := 0 to Length(m_ItemArr_BLUE) - 1 do begin
            if (m_ItemArr_BLUE[II].s.Name = UpdateItemArray_BLUE[I].ItemName) and (m_ItemArr_BLUE[II].MakeIndex = UpdateItemArray_BLUE[I].MakeIndex) then begin
              m_UpgradeItemsWait_BLUE[I] := m_ItemArr_BLUE[II];
              m_ItemArr_BLUE[II].s.Name := '';
              Break;
            end;
          end;
        end;
      end;
    1: begin
        DecodeBuffer(sData, @UpgradeItemIndexs, SizeOf(TUpgradeItemIndexs));
        for I := 0 to Length(UpgradeItemIndexs) - 1 do begin
          for II := 0 to Length(m_ItemArr_IGE) - 1 do begin
            if (m_ItemArr_IGE[II].MakeIndex = UpgradeItemIndexs[I]) then begin
              m_UpgradeItemsWait_IGE[I] := m_ItemArr_IGE[II];
              m_ItemArr_IGE[II].s.Name := '';
              Break;
            end;
          end;
        end;
      end;
  end;
end;

procedure TGameEngine.SendOpenBox(nMakeIndex: Integer; sItemName: string);
var
  I: Integer;
begin
  for I := 0 to Length(m_ItemArr_IGE) - 1 do begin
    if (m_ItemArr_IGE[I].s.Name = sItemName) and (m_ItemArr_IGE[I].MakeIndex = nMakeIndex) then begin
      m_OpenBoxingItem_IGE := m_ItemArr_IGE[I];
      m_ItemArr_IGE[I].s.Name := '';
      Exit;
    end;
  end;
end;

procedure TGameEngine.SendOpenBox_BLUE(sData: string);
var
  I, II: Integer;
  BoxItemArray_BLUE: TBoxItemArray_BLUE;
begin
  DecodeBuffer(sData, @BoxItemArray_BLUE, SizeOf(TBoxItemArray_BLUE));
  for I := 0 to 1 do begin
    for II := 0 to Length(m_ItemArr_BLUE) - 1 do begin
      if (m_ItemArr_BLUE[II].s.Name = BoxItemArray_BLUE[I].ItemName) and (m_ItemArr_BLUE[II].MakeIndex = BoxItemArray_BLUE[I].MakeIndex) then begin
        m_OpenBoxingItemWait_BLUE[I] := m_ItemArr_BLUE[II];
        m_ItemArr_BLUE[II].s.Name := '';
        Break;
      end;
    end;
  end;
end;

procedure TGameEngine.SendWalk(nIndex, nX, nY, nDir: Integer);
begin
  if m_nMoveMsg > 0 then Exit;
  m_nMoveMsg := nIndex;
  m_nNewX := nX;
  m_nNewY := nY;
  m_nNewDir := nDir;
  case nIndex of
    CM_HORSERUN: ;
    CM_TURN: ;
    CM_WALK: ;
    CM_RUN: ;
  end;
end;

procedure TGameEngine.DecodeSendMessagePacket(var sDataBlock: string);
  function GetCertification(sMsg: string; var sAccount: string; var sChrName: string;
    var nSessionID: Integer; var nClientVersion: Integer;
    var boFlag: Boolean; var boFirVersion: Boolean): Boolean;
  var
    sData: string;
    sCodeStr, sXor, sClientVersion: string;
    sIdx: string;
    nXor1, nXor2: Int64;
//resourcestring
  //sExceptionMsg = '[Exception] TRunSocket::DoClientCertification -> GetCertification';
  begin
    Result := False;
    try
      sData := sMsg;
      //if (Length(sData) > 2) and (sData[1] = '*') and (sData[2] = '*') then begin
      sData := Copy(sData, 3, Length(sData) - 2);
      sData := GetValidStr3(sData, sAccount, ['/']);
      sData := GetValidStr3(sData, sChrName, ['/']);
      sData := GetValidStr3(sData, sCodeStr, ['/']);
      sData := GetValidStr3(sData, sXor, ['/']);
      sData := GetValidStr3(sData, sClientVersion, ['/']);
      sIdx := sData;
      nXor1 := Str_ToInt(sCodeStr, 0);
      nXor2 := Str_ToInt(sXor, 0);
     { if nXor1 xor $3EB2C5CC = nXor2 xor $54B163FD then begin //英雄登陆器
        boFirVersion := True;
        nSessionID := nXor1 xor $3EB2C5CC;
        if sIdx = '0' then begin
          boFlag := True;
        end else begin
          boFlag := False;
        end;
        if (sAccount <> '') and (sChrName <> '')  then begin
          nClientVersion := Str_ToInt(sClientVersion, 0); ;
          Result := True;
        end;
      end else begin //普通登陆器 }
      boFirVersion := False;
      nSessionID := Str_ToInt(sCodeStr, 0);
      if sIdx = '0' then begin
        boFlag := True;
      end else begin
        boFlag := False;
      end;
      if (sAccount <> '') and (sChrName <> '') {and (nSessionID >= 2)} then begin
        nClientVersion := Str_ToInt(sXor, 0);

        Result := True;
      end;
     // end;
      //end;
    except
    //MainOutMessage(sExceptionMsg);
    end;
  end;
var
  sData: string;
  sTagStr: string;
  sDefMsg: string;
  sBody: string;
  DefMsg: TDefaultMessage;
  DefMsg_IGE: TDefaultMessage_IGE;
  nCode: Integer;
  boFlag, boFirVersion: Boolean;
begin
  if sDataBlock = '' then Exit;

  if sDataBlock[1] = '+' then begin
    //sData := Copy(sDataBlock, 2, Length(sDataBlock) - 1);
    //sData := GetValidStr3(sData, sTagStr, ['/']);
    //ClientGetMsg(sTagStr);
    //GameSocket.m_sSockText := '';
    Exit;
  end;
  nCode := 1;
  if m_btVersion = 0 then begin
    if Length(sDataBlock) < DEFBLOCKSIZE + 1 then begin
   { if sDataBlock[1] = '=' then begin
      sData := Copy(sDataBlock, 2, Length(sDataBlock) - 1);
      if sData = 'DIG' then begin
        if g_MySelf <> nil then
          g_MySelf.m_boDigFragment := True;
      end;
    end;  }
      Exit;
    end;
  end else begin
    if Length(sDataBlock) < DEFBLOCKSIZE + 7 then begin
   { if sDataBlock[1] = '=' then begin
      sData := Copy(sDataBlock, 2, Length(sDataBlock) - 1);
      if sData = 'DIG' then begin
        if g_MySelf <> nil then
          g_MySelf.m_boDigFragment := True;
      end;
    end;  }
      Exit;
    end;
  end;
  if (not m_boSendRunLogin) and (m_sServerName <> '') then begin
    sDefMsg := Copy(sDataBlock, 2, Length(sDataBlock));
    sBody := DecodeString(sDefMsg);
    //SendOutStr('sBody:' + sBody);
    if (Length(sBody) > 2) and (sBody[1] = '*') and (sBody[2] = '*') then begin
     // SendOutStr('sBody:' + sBody);
      //SendOutStr('(Length(sBody) > 2) and (sBody[1] = *) and (sBody[2] = *)');
      m_boSendRunLogin := GetCertification(sBody,
        m_sAccount,
        m_sChrName,
        m_nSessionID,
        m_nClientVersion,
        boFlag, boFirVersion);
      //SendOutStr('m_nClientVersion:' + IntToStr(m_nClientVersion) + ' m_nSessionID:' + IntToStr(m_nSessionID));
      Exit;
    end;
  end;

  if m_btVersion = 0 then begin
    sDefMsg := Copy(sDataBlock, 2, DEFBLOCKSIZE);
    sBody := Copy(sDataBlock, DEFBLOCKSIZE + 2, Length(sDataBlock) - DEFBLOCKSIZE);
    DefMsg := DecodeMessage(sDefMsg);
  end else begin
    sDefMsg := Copy(sDataBlock, 2, 22);
    sBody := Copy(sDataBlock, 24, Length(sDataBlock) - 22);
    DefMsg_IGE := DecodeMessage_IGE(sDefMsg);
    Move(DefMsg_IGE, DefMsg, SizeOf(TDefaultMessage));
  end;

  //sDefMsg := Copy(sDataBlock, 2, DEFBLOCKSIZE);
  //sBody := Copy(sDataBlock, DEFBLOCKSIZE + 2, Length(sDataBlock) - DEFBLOCKSIZE - 1);
  //DefMsg := DecodeMessage(sDefMsg);
  case DefMsg.ident of
    CM_SOFTCLOSE: ClearAll;
    CM_IGE_2008: begin
        m_btVersion := 1;
      end;
    CM_SELECTSERVER: begin
        if m_btVersion = 0 then begin
          m_nCodeMsgSize := GetCodeMsgSize(SizeOf(TOCharDesc) * 4 / 3);
        end else begin
          m_nCodeMsgSize := GetCodeMsgSize(SizeOf(TOCharDesc) * 4 / 3);
        end;
        //m_sEncryptServerName := sDataBlock;
        m_sServerName := DecodeString(sBody); //
        //if m_btVersion = 1 then
         // m_sServerName := Copy(m_sServerName, 1, Pos('/', m_sServerName) - 1);
        //SendOutStr('m_sServerName:' + m_sServerName + ' m_btVersion:' + IntToStr(m_btVersion) + ' m_nCodeMsgSize:' + IntToStr(m_nCodeMsgSize) + ' sBody:' + sBody + ' sDataBlock:' + sDataBlock);
      end;
    CM_SAY: ; //showmessage('CM_SAY');

   { CM_SPELL: begin
        m_dwSendTick := GetTickCount;
        GameSocket.SendToClient('+GOOD/' + IntToStr(GetTickCount));
      end; }

    CM_DROPITEM: SendDropItem(DefMsg.Recog, DecodeString(sBody));
    CM_TAKEONITEM: SendTakeOnItem(DefMsg.param, DefMsg.Recog, DecodeString(sBody));
    CM_TAKEOFFITEM: SendTakeOffItem(DefMsg.param, DefMsg.Recog, DecodeString(sBody));
    //CM_REPAIRFIRDRAGON: SendRepairFirDragon(DefMsg.param, DefMsg.Recog, DecodeString(sBody), sDataBlock);
    CM_EAT: SendEat(DefMsg.Recog, DecodeString(sBody), sDataBlock);

    CM_USERSELLITEM: SendSellItem(MakeLong(DefMsg.param, DefMsg.tag), DecodeString(sBody)); //发送要出售的物品
    CM_SENDSELLOFFITEM: SendSellOffItem(MakeLong(DefMsg.param, DefMsg.tag), DecodeString(sBody)); //发送要出售的寄售物品
    CM_USERSTORAGEITEM: SendStorageItem(MakeLong(DefMsg.param, DefMsg.tag), DecodeString(sBody)); //发送要存放的物品
    CM_DROPGOLD: ;
    //CM_DEALTRY: ; //发送请求交易
    CM_DEALADDITEM: SendAddDealItem(sBody); //发送要交易的物品
    CM_DEALDELITEM: SendDelDealItem(sBody); //发送要删除交易的物品
    CM_DEALEND: ; //交易结束
    //CM_SENDCHANGEITEM: SendChangeItem(MakeLong(DefMsg.param, DefMsg.tag), DecodeString(sBody)); //发送要修改的物品
    CM_SENDUPGRADEITEM: SendUpgradeItem(sBody); //发送要升级的装备
    CM_OPENITEMBOX: SendOpenBox(DefMsg.Recog, DecodeString(sBody)); //打开宝箱

    CM_GETBACKPASSWORD: ; //密码找回
    CM_QUERYUSERNAME: ;
    CM_PICKUP: ;
    CM_BUTCH: ;
    CM_MAGICKEYCHANGE: ;
    CM_1005: ;
    CM_CLICKNPC: ;
    CM_MERCHANTDLGSELECT: ;
    CM_MERCHANTQUERYSELLPRICE: ;
    CM_USERBUYITEM: ;
    CM_USERGETDETAILITEM: ;
    CM_LOGINNOTICEOK: ;
    CM_GROUPMODE: ;
    CM_CREATEGROUP: ;
    CM_USERREPAIRITEM: ;
    CM_MERCHANTQUERYREPAIRCOST: ;
    CM_DEALTRY: ;
    CM_USERTAKEBACKSTORAGEITEM: ;
    CM_WANTMINIMAP: ;
    CM_USERMAKEDRUGITEM: ;
    CM_OPENGUILDDLG: ;
    CM_GUILDHOME: ;
    CM_GUILDMEMBERLIST: ;
    CM_GUILDADDMEMBER: ;
    CM_GUILDDELMEMBER: ;
    CM_GUILDUPDATENOTICE: ;
    CM_GUILDUPDATERANKINFO: ;
    CM_ADJUST_BONUS: ;
    CM_SPEEDHACKUSER: ; //??
    CM_PASSWORD: ;
    CM_CHGPASSWORD: ; //?
    CM_SETPASSWORD: ; //?
    CM_THROW,
      CM_HIT,
      CM_HEAVYHIT,
      CM_BIGHIT,
      CM_SITDOWN,
      CM_POWERHIT,
      CM_LONGHIT,

    CM_WIDEHIT, //半月
      CM_FIREHIT, //烈火
      CM_CRSHIT, //抱月刀
      CM_TWNHIT, //狂风斩

    CM_PHHIT, //破魂斩

    CM_40HIT,
      CM_41HIT,
      CM_42HIT,
      CM_43HIT,

    CM_KTHIT,

    CM_60HIT: ; { begin
        m_dwSendTick := GetTickCount;
        GameSocket.SendToClient('+GOOD/' + IntToStr(GetTickCount));
      end;}

    CM_HORSERUN,
      CM_TURN,
      CM_WALK,
      CM_RUN: SendWalk(DefMsg.ident, Loword(DefMsg.Recog), HiWord(DefMsg.Recog), DefMsg.tag);

    //CM_STARTSTORE: SendStartStore(sBody); //开始摆摊
    //CM_STOPSTORE: ; //停止摆摊


    //CM_RECALLHERO: if m_MyHero = nil then m_dwRecallBackHero := GetTickCount + 1000 * 60 * 3; //召唤英雄
    //BLUE_SEND_1050: if m_MyHero = nil then m_dwRecallBackHero := GetTickCount + 1000 * 60 * 3; //召唤英雄



    BLUE_SEND_1061: SendUpgradeItem(sBody); //淬炼装备
    BLUE_SEND_1080: SendOpenBox_BLUE(sBody);
    BLUE_SEND_1107: ;
    BLUE_SEND_1100, CM_IGE_5014: SendItemToHeroBag(DefMsg.param, DefMsg.Recog, DecodeString(sBody)); //主人包裹物品放到英雄包裹
    BLUE_SEND_1101, CM_IGE_5013: SendItemToMasterBag(DefMsg.param, DefMsg.Recog, DecodeString(sBody)); //英雄包裹物品放到主人包裹

    BLUE_SEND_1102, CM_IGE_5009: SendHeroTakeOnItem(DefMsg.param, DefMsg.Recog, DecodeString(sBody)); //英雄穿装备
    BLUE_SEND_1103, CM_IGE_5010: SendHeroTakeOffItem(DefMsg.param, DefMsg.Recog, DecodeString(sBody)); //英雄脱装备
    BLUE_SEND_1104, CM_IGE_5043: SendHeroEat(DefMsg.Recog, DecodeString(sBody), sDataBlock); //英雄吃药
    //BLUE_SEND_1105: ; //锁定
    BLUE_SEND_1106, CM_IGE_5052: SendHeroDropItem(DefMsg.Recog, DecodeString(sBody)); //英雄扔物品
    BLUE_SEND_1108: ; //合击
  {else begin
      m_dwSendTick := GetTickCount;
      GameSocket.SendToClient('+GOOD/' + IntToStr(GetTickCount));
    end;}
  end;
  //SendOutStr('Send DefMsg.ident:' + IntToStr(DefMsg.ident) + ' DefMsg.Recog:' + IntToStr(DefMsg.Recog) + ' ' + sBody);
end;


procedure TGameEngine.ClientGetMsg(sData: string);
begin
  {if sData = 'PWR' then g_boNextTimePowerHit := True; //打开攻杀
  if sData = 'LNG' then g_boCanLongHit := True; //打开刺杀
  if sData = 'ULNG' then g_boCanLongHit := False; //关闭刺杀
  if sData = 'WID' then g_boCanWideHit := True; //打开半月
  if sData = 'UWID' then g_boCanWideHit := False; //关闭半月
  if sData = 'CRS' then g_boCanCrsHit := True; //打开双龙    抱月刀法
  if sData = 'UCRS' then g_boCanCrsHit := False; //关闭双龙  抱月刀法
  if sData = 'TWN' then g_boCanTwnHit := True; //打开狂风斩
  if sData = 'UTWN' then g_boCanTwnHit := False; //关闭狂风斩
  if sData = 'STN' then g_boCanStnHit := True; //打开狂风斩;
  if sData = 'USTN' then g_boCanStnHit := False;
  if sData = 'FIR' then begin
    g_boNextTimeFireHit := True; //打开烈火
    g_dwLatestFireHitTick := GetTickCount;
    g_dwAutoFireTick := GetTickCount;
  end;
  if sData = 'KTZ' then begin
    g_boNextTimeKTZHit := True; //打开开天斩
    g_dwLatestKTZHitTick := GetTickCount;
    g_dwAutoKTZTick := GetTickCount;
    //DebugOutStr('打开开天斩');
  end;
  if sData = 'CID' then begin
    g_boNextTimePKJHit := True; //打开破空剑
    g_dwLatestPKJHitTick := GetTickCount;
    g_dwAutoPKJTick := GetTickCount;
    //DebugOutStr('打开破空剑');
  end;
  if sData = 'ZRJF' then begin
    g_boNextTimeZRJFHit := True; //逐日剑法
    g_dwLatestZRJFHitTick := GetTickCount;
    g_dwAutoZRJFTick := GetTickCount;
    //DebugOutStr('逐日剑法');
  end;
  if sData = 'UFIR' then g_boNextTimeFireHit := False; //关闭烈火
  if sData = 'UKTZ' then g_boNextTimeKTZHit := False; //关闭开天斩
  if sData = 'UCID' then g_boNextTimePKJHit := False; //关闭破空剑
  if sData = 'UZRJF' then g_boNextTimeZRJFHit := False; //关闭破空剑

  if sData = 'GOOD' then begin
    ActionLock := False;
    Inc(g_nReceiveCount);
  end;
  if sData = 'FAIL' then begin
    ActionFailed;
    ActionLock := False;
    Inc(g_nReceiveCount);
  end;}
  if sData = 'GOOD' then begin
    case m_nMoveMsg of
      CM_HORSERUN: begin
          GetNextHorseRunXY(m_nNewDir, m_MySelf.m_nCurrX, m_MySelf.m_nCurrY);
    {m_MySelf.m_nCurrX := m_nNewX;
    m_MySelf.m_nCurrY := m_nNewY;  }
          m_MySelf.m_btDir := m_nNewDir;
        end;
      CM_TURN: begin
          m_MySelf.m_btDir := m_nNewDir;
        end;
      CM_WALK: begin
          m_MySelf.m_btDir := m_nNewDir;
          GetNextPosXY(m_nNewDir, m_MySelf.m_nCurrX, m_MySelf.m_nCurrY);
        end;
      CM_RUN: begin
          m_MySelf.m_btDir := m_nNewDir;
          GetNextRunXY(m_nNewDir, m_MySelf.m_nCurrX, m_MySelf.m_nCurrY);
        end;
    end;
      //AddChatBoardString('X:' + IntToStr(m_MySelf.m_nCurrX) + ' Y:' + IntToStr(m_MySelf.m_nCurrY), c_Yellow, c_Red);
    m_nMoveMsg := 0;
  end;
  if sData = 'FAIL' then begin
    m_nMoveMsg := 0;
  end;
end;

procedure TGameEngine.ClientGetMessage(DefMsg: TDefaultMessage; sData: string);
var
  sCharName, sMsg: string;
begin
  sMsg := DecodeString(sData);
  if DefMsg.Ident = SM_WHISPER then begin
    if Config.boAutoAnswer then begin
      if (Config.sAnswerMsg <> '') and (Pos('=>', sMsg) > 0) then begin
        sCharName := Copy(sMsg, 1, Pos('=>', sMsg) - 1);
        SendSay('/' + sCharName + ' ' + Config.sAnswerMsg);
      end;
    end;
  end;
end;

procedure TGameEngine.DecodeMessagePacket(var sDataBlock: string);
var
  sData: string;
  sTagStr: string;
  sDefMsg: string;
  sBody: string;
  DefMsg: TDefaultMessage;
  DefMsg_IGE: TDefaultMessage_IGE;
  nCode: Integer;
begin
  nCode := 0;
  if sDataBlock[1] = '+' then begin
    sData := Copy(sDataBlock, 2, Length(sDataBlock) - 1);
    sData := GetValidStr3(sData, sTagStr, ['/']);
    ClientGetMsg(sTagStr);
    //GameSocket.m_sSockText := '';
    Exit;
  end;
  nCode := 1;
  if m_btVersion = 0 then begin
    if Length(sDataBlock) < DEFBLOCKSIZE then begin
   { if sDataBlock[1] = '=' then begin
      sData := Copy(sDataBlock, 2, Length(sDataBlock) - 1);
      if sData = 'DIG' then begin
        if g_MySelf <> nil then
          g_MySelf.m_boDigFragment := True;
      end;
    end;  }
      Exit;
    end;
  end else begin
    if Length(sDataBlock) < DEFBLOCKSIZE + 6 then begin
   { if sDataBlock[1] = '=' then begin
      sData := Copy(sDataBlock, 2, Length(sDataBlock) - 1);
      if sData = 'DIG' then begin
        if g_MySelf <> nil then
          g_MySelf.m_boDigFragment := True;
      end;
    end;  }
      Exit;
    end;
  end;

  if m_btVersion = 0 then begin
    sDefMsg := Copy(sDataBlock, 1, DEFBLOCKSIZE);
    sBody := Copy(sDataBlock, DEFBLOCKSIZE + 1, Length(sDataBlock) - DEFBLOCKSIZE);
    DefMsg := DecodeMessage(sDefMsg);
  end else begin
    sDefMsg := Copy(sDataBlock, 1, 22);
    sBody := Copy(sDataBlock, 22 + 1, Length(sDataBlock) - 22);
    DefMsg_IGE := DecodeMessage_IGE(sDefMsg);
    Move(DefMsg_IGE, DefMsg, SizeOf(TDefaultMessage));
  end;


  {if GameSocket.m_boWriteSockText then begin
    SendOutStr('DecodeMessagePacket: Ident: ' + IntToStr(DefMsg.ident) +
      ' Recog: ' + IntToStr(DefMsg.Recog) +
      ' Param: ' + IntToStr(DefMsg.param) +
      ' Tag: ' + IntToStr(DefMsg.tag) +
      ' Series: ' + IntToStr(DefMsg.series) +
      #13#10#9 + 'sBody: ' + sBody);
  end;}

  case DefMsg.ident of
    SM_QUERYCHR: ClientGetReceiveChrs(sBody);
    SM_STARTPLAY: ClientGetStartPlay(sBody);

    //SM_VERSION_FAIL: ClientVersionFail();
    SM_NEWMAP: ClientGetNewMap(DefMsg, sBody);
    SM_LOGON: ClientGetUserLogin(DefMsg, sBody);
    SM_RECONNECT: ClientGetReconnect(sBody);
    SM_TIMECHECK_MSG: ;
    //SM_AREASTATE: ClientGetAreaState(DefMsg.Recog);
    SM_MAPDESCRIPTION: ClientGetMapDescription(DefMsg, sBody);
    SM_PASSOK_SELECTSERVER: begin

      end;
    SM_SELECTSERVER_OK: begin
        if m_btVersion = 0 then begin
          m_nCodeMsgSize := GetCodeMsgSize(SizeOf(TOCharDesc) * 4 / 3);
        end else begin
          m_nCodeMsgSize := GetCodeMsgSize(SizeOf(TOCharDesc) * 4 / 3);
        end;
        //SendOutStr('SM_SELECTSERVER_OK:' + m_sServerName + ' m_btVersion:' + IntToStr(m_btVersion));
      end;
  end;

  if m_MySelf = nil then Exit;
  case DefMsg.ident of
    SM_GAMEGOLDNAME: ClientGetGameGoldName(DefMsg, sBody);
    SM_ADJUST_BONUS: ClientGetAdjustBonus(DefMsg.Recog, sBody);
    //SM_MYSTATUS: ClientGetMyStatus(DefMsg);
    SM_TURN: ClientGetObjTurn(DefMsg, sBody);
    SM_BACKSTEP: ClientGetBackStep(DefMsg, sBody);
    SM_SPACEMOVE_HIDE,
      SM_SPACEMOVE_HIDE2: ClientSpaceMoveHide(DefMsg);
    SM_SPACEMOVE_SHOW,
      SM_SPACEMOVE_SHOW2: ClientSpaceMoveShow(DefMsg, sBody);
    SM_WALK, SM_RUSH, SM_RUSHKUNG: ClientObjWalk(DefMsg, sBody);
    SM_RUN, SM_HORSERUN: ClientObjRun(DefMsg, sBody);

    SM_LAMPCHANGEDURA: ClientLampChangeDura(DefMsg);
    SM_MOVEFAIL: ClientObjMoveFail(DefMsg, sBody);
    SM_BUTCH,
      SM_SITDOWN: ; //ClientObjButch(DefMsg, sBody);
    SM_HIT,
      SM_HEAVYHIT,
      SM_POWERHIT,
      SM_LONGHIT,
      SM_WIDEHIT,
      SM_BIGHIT,
      SM_FIREHIT,
      SM_CRSHIT,
      SM_TWINHIT,
      SM_KTHIT,
      SM_PKHIT: ClientObjHit(DefMsg, sBody);
    SM_FLYAXE: ClientObjFlyAxe(DefMsg, sBody);
    {
    SM_SPELL: ClientObjSpell(DefMsg, sBody);
    SM_MAGICFIRE: ClientObjMagicFire(DefMsg, sBody);
    SM_MAGICFIRE_FAIL: ClientObjMagicFireFail(DefMsg);
    SM_USEGROUPSPELL: ClientObjGroupSpell(DefMsg);
    }

    SM_OUTOFCONNECTION: ClientOutofConnection();
    SM_DEATH,
      SM_NOWDEATH: ClientObjDeath(DefMsg, sBody);
    SM_SKELETON,
      SM_ALIVE: ClientObjSkeLeton(DefMsg, sBody);
    SM_ABILITY: ClientObjAbility(DefMsg, sBody);
    SM_SUBABILITY: ClientObjSubAbility(DefMsg);

    SM_WINEXP: ClientObjWinExp(DefMsg);
    SM_LEVELUP: ClientObjLevelUp(DefMsg);
    SM_HEALTHSPELLCHANGED: ClientObjHealthSpellChanged(DefMsg);
    SM_STRUCK: ClientObjStruck(DefMsg, sBody);
    SM_CHANGEFACE: ClientObjChangeFace(DefMsg, sBody);

    SM_INSTANCEHEALGUAGE: ClientObjInstanceOpenHealth(DefMsg);


    SM_GROUPMESSAGE,
      SM_GUILDMESSAGE,
      SM_WHISPER,
      SM_CRY,
      SM_SYSMESSAGE,
      SM_HEAR,
      SM_MOVEMESSAGE: ClientGetMessage(DefMsg, sBody);


    SM_USERNAME: ClientGetUserName(DefMsg, sBody);
    SM_CHANGENAMECOLOR: ClientObjChangeNameColor(DefMsg);
    SM_HIDE,
      SM_GHOST,
      SM_DISAPPEAR: ClientObjHide(DefMsg);
    SM_DIGUP: ClientObjDigUp(DefMsg, sBody);
    SM_DIGDOWN: ClientObjDigDown(DefMsg);
    {SM_SHOWEVENT: ClientGetShowEvent(DefMsg, sBody);
    SM_HIDEEVENT: ClientGetHideEvent(DefMsg); }
    SM_ADDITEM: ClientGetAddItem(sBody);
    SM_BAGITEMS: ClientGetBagItmes(DefMsg, sBody);
    SM_UPDATEITEM: ClientGetUpdateItem(sBody);
    SM_UPDATEITEM2: ClientGetUpdateItem2(sBody);
    SM_DELITEM: ClientGetDelItem(sBody);
    SM_DELITEMS: ClientGetDelItems(sBody);
    SM_DROPITEM_SUCCESS: DelDropItem(DecodeString(sBody), DefMsg.Recog);
    SM_DROPITEM_FAIL: ClientGetDropItemFail(DecodeString(sBody), DefMsg.Recog);
    SM_ITEMSHOW: ClientGetShowItem(DefMsg, sBody);
    SM_ITEMHIDE: ClientGetHideItem(DefMsg);

    {==================================英雄相关=================================}
    (*SM_RECALLHERO: ClientObjRecallHero(DefMsg, sBody);
    SM_CREATEHERO: ClientObjCreateHero(DefMsg, sBody);
    SM_HERODEATH: ClientObjHeroDeath(DefMsg);
    SM_HEROLOGOUT: ClientObjHeroLogOut(DefMsg);
    SM_HEROABILITY: ClientObjHeroAbility(DefMsg, sBody);
    SM_HEROSUBABILITY: ClientObjHeroSubAbility(DefMsg);
    SM_IGEDRAGONPOINT: ClientObjFireDragonPoint(DefMsg);
    SM_HEROBAGITEMS: ClientGetHeroBagItmes(DefMsg, sBody);
    SM_HEROADDITEM: ClientGetHeroAddItem(sBody);
    SM_HERODELITEM: ClientGetHeroDelItem(sBody);
    SM_HERODELITEMS: ClientGetHeroDelItems(sBody);
    SM_HEROUPDATEITEM: ClientGetHeroUpdateItem(sBody);
    SM_HEROADDMAGIC: ClientGetHeroAddMagic(sBody);
    SM_HEROSENDMYMAGIC: ClientGetMyHeroMagics(sBody);
    SM_HERODELMAGIC: ClientGetHeroDelMagic(DefMsg.Recog);
    SM_HEROCHANGEITEM: ClientGetHeroChangeItem(sBody);
    SM_HEROTAKEON_OK: ClientObjHeroTakeOnOK(DefMsg);
    SM_HEROTAKEON_FAIL: ClientObjHeroTakeOnFail();
    SM_HEROTAKEOFF_OK: ClientObjHeroTakeOffOK(DefMsg);
    SM_HEROTAKEOFF_FAIL: ClientObjHeroTakeOffFail();
    SM_TAKEOFFTOHEROBAG_OK: ClientObjTakeOffHeroBagOK(DefMsg);
    SM_TAKEOFFTOHEROBAG_FAIL: ClientObjTakeOffHeroBagFail();
    SM_TAKEOFFTOMASTERBAG_OK: ClientObjTakeOffMasterBagOK(DefMsg);
    SM_TAKEOFFTOMASTERBAG_FAIL: ClientObjTakeOffMasterBagFail();
    SM_SENDITEMTOMASTERBAG_OK: ClientObjToMasterBagOK();
    SM_SENDITEMTOMASTERBAG_FAIL: ClientObjToMasterBagFail();
    SM_SENDITEMTOHEROBAG_OK: ClientObjToMasterBagOK();
    SM_SENDITEMTOHEROBAG_FAIL: ClientObjToHeroBagFail();
    SM_SENDHEROUSEITEMS: ClientGetSendHerouseItems(sBody);
    SM_QUERYHEROBAGCOUNT: ClientObjHeroBagCount(DefMsg);
    SM_HEROWEIGHTCHANGED: ClientObjHeroWeigthChanged(DefMsg);
    SM_HEROEAT_OK: ClientObjHeroEatOK();
    SM_HEROEAT_FAIL: ClientObjHeroEatFail();
    //SM_HEROMAGIC_LVEXP: ClientGetHeroMagicLvExp(DefMsg.Recog {magid}, DefMsg.param {lv}, MakeLong(DefMsg.tag, DefMsg.series));
SM_HERODURACHANGE: ClientGetHeroDuraChange(DefMsg.param {useitem index}, DefMsg.Recog, MakeLong(DefMsg.tag, DefMsg.series));
SM_HEROWINEXP: ClientObjHeroWinExp(DefMsg);
SM_HEROLEVELUP: ClientObjHeroLevelUp(DefMsg);
SM_HERODROPITEM_SUCCESS: DelDropItem(DecodeString(sBody), DefMsg.Recog);
SM_HERODROPITEM_FAIL: ClientGetHeroDropItemFail(DecodeString(sBody), DefMsg.Recog);
SM_REPAIRFIRDRAGON_OK: m_WaitingUseItem_IGE.Item.s.Name := '';
SM_REPAIRFIRDRAGON_FAIL: ClientObjRepaiFireDragon(DefMsg); *)

    {==================================英雄相关====================================}
    SM_TAKEON_OK: ClientObjTakeOnOK(DefMsg);
    SM_TAKEON_FAIL: ClientObjTakeOnFail();
    SM_TAKEOFF_OK: ClientObjTakeOffOK(DefMsg);
    SM_TAKEOFF_FAIL: ClientObjTakeOffFail();
    SM_EXCHGTAKEON_OK: ;
    SM_EXCHGTAKEON_FAIL: ;
    SM_SENDUSEITEMS: ClientGetSenduseItems(sBody);
    //SM_WEIGHTCHANGED: ClientObjWeigthChanged(DefMsg);
    SM_GOLDCHANGED: ClientObjGoldChanged(DefMsg);
    SM_FEATURECHANGED: SendMsg(DefMsg.ident, DefMsg.Recog, 0, 0, 0, MakeLong(DefMsg.param, DefMsg.tag), MakeLong(DefMsg.series, 0), '');
    SM_CHARSTATUSCHANGED: SendMsg(DefMsg.ident, DefMsg.Recog, 0, 0, 0, MakeLong(DefMsg.param, DefMsg.tag), DefMsg.series, '');
    SM_CLEAROBJECTS: ClientObjCleanObjects();
    SM_EAT_OK: ClientObjEatOK();
    SM_EAT_FAIL: ClientObjEatFail();
    SM_ADDMAGIC: ClientGetAddMagic(sBody);
    SM_SENDMYMAGIC: ClientGetMyMagics(sBody);
    SM_DELMAGIC: ClientGetDelMagic(DefMsg.Recog);
    SM_MAGIC_LVEXP: ClientGetMagicLvExp(DefMsg.Recog {magid}, DefMsg.param {lv}, MakeLong(DefMsg.tag, DefMsg.series));
    SM_DURACHANGE: ClientGetDuraChange(DefMsg.param {useitem index}, DefMsg.Recog, MakeLong(DefMsg.tag, DefMsg.series));
    //SM_MERCHANTSAY: ClientGetMerchantSay(DefMsg.Recog, DefMsg.param, DecodeString(sBody));
    //SM_MERCHANTDLGCLOSE: ClientObjCloseMDlg();
    //SM_SENDGOODSLIST: ClientGetSendGoodsList(DefMsg.Recog, DefMsg.param, sBody);
    //SM_SENDUSERMAKEDRUGITEMLIST: ClientGetSendMakeDrugList(DefMsg.Recog, sBody);
    //SM_SENDUSERSELL: ClientGetSendUserSell(DefMsg.Recog);
    //SM_SENDUSERREPAIR: ClientGetSendUserRepair(DefMsg.Recog);
    //SM_SENDBUYPRICE: ClientObjBuyPrice(DefMsg.Recog);
    SM_USERSELLITEM_OK: ClientObjSellItemOK(DefMsg.Recog);
    SM_USERSELLITEM_FAIL: ClientObjSellItemFail();
    //SM_SENDREPAIRCOST: ClientObjRepairCost(DefMsg.Recog);
    //SM_USERREPAIRITEM_OK: ClientObjRepairItemOK(DefMsg);
    //SM_USERREPAIRITEM_FAIL: ClientObjRepairItemFail();
    SM_STORAGE_OK,
      SM_STORAGE_FULL,
      SM_STORAGE_FAIL: ClientObjStorageOK(DefMsg);
    //SM_SAVEITEMLIST: ClientGetSaveItemList(DefMsg.Recog, DefMsg.param, sBody);
    SM_TAKEBACKSTORAGEITEM_OK,
      SM_TAKEBACKSTORAGEITEM_FAIL,
      SM_TAKEBACKSTORAGEITEM_FULLBAG: ClientObjTakeBackStorageItemOK(DefMsg);
    //SM_BUYITEM_SUCCESS: ClientObjBuyItemSuccess(DefMsg);
    //SM_BUYITEM_FAIL: ClientObjBuyItemFail(DefMsg.Recog);
    //SM_MAKEDRUG_SUCCESS: ClientObjMakeDrugOK(DefMsg.Recog);
    //SM_MAKEDRUG_FAIL: ClientObjMakeDrugFail(DefMsg.Recog);
    //SM_716: DrawEffectHum(DefMsg.series {type}, DefMsg.param {x}, DefMsg.tag {y});
    //SM_SENDDETAILGOODSLIST: ClientGetSendDetailGoodsList(DefMsg.Recog, DefMsg.param, DefMsg.tag, sBody);

    //SM_SENDNOTICE: ClientGetSendNotice(sBody);
    //SM_GROUPMODECHANGED: ClientObjGroupModeChanged(DefMsg.param);
    //SM_CREATEGROUP_OK: ClientObjCreateGroupOK();
    //SM_CREATEGROUP_FAIL: ClientObjCreateGroupFail(DefMsg.Recog);
    {SM_GROUPADDMEM_OK: g_dwChangeGroupModeTick := GetTickCount;
    SM_GROUPADDMEM_FAIL: ClientObjGroupAddManFail(DefMsg.Recog);
    SM_GROUPDELMEM_OK: g_dwChangeGroupModeTick := GetTickCount;
    SM_GROUPDELMEM_FAIL: ClientObjGroupDelManFail(DefMsg.Recog);
    SM_GROUPCANCEL: g_GroupMembers.Clear;
    SM_GROUPMEMBERS: ClientGetGroupMembers(DecodeString(sBody));
    SM_OPENGUILDDLG: ClientGetOpenGuildDlg(sBody);
    SM_SENDGUILDMEMBERLIST: ClientGetSendGuildMemberList(sBody);
    SM_OPENGUILDDLG_FAIL: ClientObjOpenGuildDlgFail();
    }
    //SM_DEALTRY_FAIL: ClientObjDealtryFail();
    SM_GROUPMODECHANGED: ClientObjGroupModeChanged(DefMsg.param);
    SM_CREATEGROUP_OK: ClientObjCreateGroupOK();
    SM_CREATEGROUP_FAIL: ClientObjCreateGroupFail(DefMsg.Recog);
    SM_GROUPADDMEM_OK: ; //g_dwChangeGroupModeTick := GetTickCount;
    SM_GROUPADDMEM_FAIL: ClientObjGroupAddManFail(DefMsg.Recog);
    SM_GROUPDELMEM_FAIL: ClientObjGroupDelManFail(DefMsg.Recog);
    SM_GROUPCANCEL: m_GroupMembers.Clear;
    SM_GROUPMEMBERS: ClientGetGroupMembers(DecodeString(sBody));

    SM_DEALMENU: ClientObjDealMenu(sBody);
    SM_DEALCANCEL: ClientObjDealCancel();
    SM_DEALADDITEM_OK,
      SM_DEALADDITEM_FAIL: ClientObjDealAddItemOK();
    SM_DEALDELITEM_OK: ClientObjDealDelItemOK();
    SM_DEALDELITEM_FAIL: ClientObjDealDelItemFail();
    //SM_DEALREMOTEADDITEM: ClientGetDealRemoteAddItem(sBody);
    //SM_DEALREMOTEDELITEM: ClientGetDealRemoteDelItem(sBody);
    SM_DEALCHGGOLD_OK: ClientObjDealChgGoldOK(DefMsg);
    SM_DEALCHGGOLD_FAIL: ClientObjDealChgGoldFail(DefMsg);
    SM_DEALREMOTECHGGOLD: ClientObjDealRemotChgGold(DefMsg);
    SM_DEALSUCCESS: ;

    //SM_SENDUSERSELLOFFITEM_OK: ClientObjSellSellOffItemOK(); //寄售物品成功
    //SM_SENDUSERSELLOFFITEM_FAIL: ClientObjSellSellOffItemFail(DefMsg.Recog); //寄售物品失败

    //SM_SHOWITEMBOX: ClientObjShowBox(DefMsg.Recog);
    SM_OPENITEMBOX_OK: ClientObjOpenBoxOK();
    SM_OPENITEMBOX_FAIL: ClientObjOpenBoxFail();
    //SM_GETSELBOXITEMNUM: ClientObjGetBoxIndex(DefMsg.Recog);

    //SM_GETBACKITEMBOX_OK: ClientObjGetBackBoxOK(); //取回宝箱成功
    //SM_GETBACKITEMBOX_FAIL: ; //取回宝箱失败

    //SM_OPENBOOK: ClientObjOpenBook(DefMsg.Recog, DefMsg.param);
    //SM_SENDCHANGEITEM: ClientGetSendUserChangeItem(DefMsg.Recog);
    SM_SENDCHANGEITEM_OK: ClientObjChangeItemOK(sBody);
    SM_SENDCHANGEITEM_FAIL: ClientObjChangeItemFail(DefMsg.Recog);

    SM_SENDUPGRADEITEM_OK: ClientObjUpgradeItemOK(sBody);
    SM_SENDUPGRADEITEM_FAIL: ClientObjUpgradeItemFail(DefMsg.Recog, sBody);




    BLUE_READ_817, SM_IGE_5027: ClientObjToHeroBagOK(); //主人包裹物品放到英雄包裹成功
    BLUE_READ_818, SM_IGE_5028: ClientObjToHeroBagFail(); //主人包裹物品放到英雄包裹失败

    BLUE_READ_819, SM_IGE_5025: ClientObjToMasterBagOK(); //英雄包裹物品放到主人包裹成功
    BLUE_READ_820, SM_IGE_5026: ClientObjToMasterBagFail(); //英雄包裹物品放到主人包裹失败
    BLUE_READ_896: ; //英雄退出效果
    BLUE_READ_897: ; //英雄登陆效果
    BLUE_READ_898: ; //获取英雄忠诚  10001(忠00.00%)
    BLUE_READ_899, SM_IGE_5004: ClientObjCreateHero(DefMsg, sBody); //创建英雄
    BLUE_READ_900, SM_IGE_5040: ClientObjHeroAbility(DefMsg, sBody); //获取英雄Abil
    BLUE_READ_901, SM_IGE_5041: ClientObjHeroSubAbility(DefMsg); //英雄脱装备 SUBABILITY
    BLUE_READ_902, SM_IGE_5033: ClientGetHeroBagItmes(DefMsg, sBody); //获取英雄包裹     Tag:包裹物品数量 2 Series: 包裹物品总数量10
    BLUE_READ_903, SM_IGE_5032: ClientGetSendHerouseItems(sBody); //获取英雄身上装备
    BLUE_READ_904: ClientGetMyHeroMagics(sBody); //获取英雄魔法
    BLUE_READ_905, SM_IGE_5034: ClientGetHeroAddItem(sBody); //英雄 Ident: 905 Recog: 738569296 Param: 0 Tag: 0 Series: 1   AddItem
    BLUE_READ_906, SM_IGE_5035: ClientGetHeroDelItem(sBody); //英雄 Ident: 906 Recog: 738569296 Param: 0 Tag: 0 Series: 1   delItem
    BLUE_READ_907, SM_IGE_5015: ClientObjHeroTakeOnOK(DefMsg); //英雄穿装备OK Ident: 907 Recog: 742933632 Param: 0 Tag: 0 Series: 0
    BLUE_READ_908, SM_IGE_5016: ClientObjHeroTakeOnFail(); //英雄穿装备FAIL

    BLUE_READ_909, SM_IGE_5017: ClientObjHeroTakeOffOK(DefMsg); //英雄脱装备OK
    BLUE_READ_910, SM_IGE_5018: ClientObjHeroTakeOffFail(); //英雄脱装备FAIL
    BLUE_READ_911, SM_IGE_5044: ClientObjHeroEatOK(); //英雄吃药OK
    BLUE_READ_912, SM_IGE_5045: ClientObjHeroEatFail(); //英雄吃药FAIL
    BLUE_READ_913: ClientGetHeroAddMagic(sBody);
    BLUE_READ_914: ClientGetHeroDelMagic(DefMsg.Recog);

    BLUE_READ_916: ClientObjFireDragonPoint(DefMsg); //英雄怒值改变
    BLUE_READ_918, SM_IGE_5005: ClientObjHeroLogOut(DefMsg); //英雄退出
    BLUE_READ_919: ClientGetHeroDuraChange(DefMsg.param {useitem index}, DefMsg.Recog, MakeLong(DefMsg.tag, DefMsg.series)); //英雄物品持久改变
    BLUE_READ_920, SM_IGE_5053: DelDropItem(DecodeString(sBody), DefMsg.Recog); //英雄扔物品OK
    BLUE_READ_921, SM_IGE_5054: ClientGetHeroDropItemFail(DecodeString(sBody), DefMsg.Recog); //英雄扔物品FAIL
    BLUE_READ_923: ClientObjFireDragonPoint(DefMsg); //英雄怒值改变 Ident: 923 Recog: 52 Param: 0 Tag: 200 Series: 0 Recog= 当前值 Tag=最大值
    BLUE_READ_950: ClientObjOpenBoxOK(); //获取宝箱的9件装备成功 OK
    BLUE_READ_951: ClientObjOpenBoxFail(); //获取宝箱的9件装备失败 Fail Ident: 951 Recog: 3 Param: 0 Tag: 0 Series: 0  Recog= 3 打开宝箱失败，包裹没有预留6个空格
    BLUE_READ_953: ; //获取宝箱选择的物品OK Ident: 953 Recog: 1 Param: 0 Tag: 0 Series: 0  Recog=1 OK Recog=0 Fail

    SM_IGE_5030: m_nMaxBagCount := DefMsg.Recog;
  end;
  //SendOutStr('Read DefMsg.ident:' + IntToStr(DefMsg.ident) + ' DefMsg.Recog:' + IntToStr(DefMsg.Recog) + ' ' + sBody);
end;

procedure TGameEngine.ClientOutofConnection();
begin

end;

procedure TGameEngine.Savebags(flname: string; pbuf: PByte);
begin

end;

procedure TGameEngine.Loadbags(flname: string; pbuf: PByte);
begin

end;

procedure TGameEngine.ClearHeroBag;
var
  I: Integer;
begin
  for I := Low(m_HeroItemArr_IGE) to High(m_HeroItemArr_IGE) do
    m_HeroItemArr_IGE[I].s.Name := '';

  for I := Low(m_HeroItemArr_BLUE) to High(m_HeroItemArr_BLUE) do
    m_HeroItemArr_BLUE[I].s.Name := '';
end;

function TGameEngine.AddHeroItemBag_IGE(cu: TClientItem_IGE): Boolean;
var
  I: Integer;
  boFind: Boolean;
begin
  Result := False;
  boFind := False;
  if cu.s.Name <> '' then begin
    for I := Low(m_HeroItemArr_IGE) to High(m_HeroItemArr_IGE) do begin
      if (m_HeroItemArr_IGE[I].MakeIndex = cu.MakeIndex) and (m_HeroItemArr_IGE[I].s.Name = cu.s.Name) then begin
        boFind := True;
        Break;
      end;
    end;
  end;
  //if cu.S.Name = '' then Exit;
  if (cu.s.Name <> '') and not boFind then begin
    for I := Low(m_HeroItemArr_IGE) to High(m_HeroItemArr_IGE) do begin
      if m_HeroItemArr_IGE[I].s.Name = '' then begin
        m_HeroItemArr_IGE[I] := cu;
        Result := True;
        Break;
      end;
    end;
  end;
  ArrangeHeroItemBag;
end;

function TGameEngine.AddHeroItemBag_BLUE(cu: TClientItem_BLUE): Boolean;
var
  I: Integer;
  boFind: Boolean;
begin
  Result := False;
  boFind := False;
  if cu.s.Name <> '' then begin
    for I := Low(m_HeroItemArr_BLUE) to High(m_HeroItemArr_BLUE) do begin
      if (m_HeroItemArr_BLUE[I].MakeIndex = cu.MakeIndex) and (m_HeroItemArr_BLUE[I].s.Name = cu.s.Name) then begin
        boFind := True;
        Break;
      end;
    end;
  end;
  //if cu.S.Name = '' then Exit;
  if (cu.s.Name <> '') and not boFind then begin
    for I := Low(m_HeroItemArr_BLUE) to High(m_HeroItemArr_BLUE) do begin
      if m_HeroItemArr_BLUE[I].s.Name = '' then begin
        m_HeroItemArr_BLUE[I] := cu;
        Result := True;
        Break;
      end;
    end;
  end;
  ArrangeHeroItemBag;
end;

function TGameEngine.UpdateHeroItemBag_BLUE(cu: TClientItem_BLUE): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := High(m_HeroItemArr_BLUE) downto Low(m_HeroItemArr_BLUE) do begin
    if (m_HeroItemArr_BLUE[I].s.Name = cu.s.Name) and (m_HeroItemArr_BLUE[I].MakeIndex = cu.MakeIndex) then begin
      m_HeroItemArr_BLUE[I] := cu;
      Result := True;
      Break;
    end;
  end;
end;

function TGameEngine.UpdateHeroItemBag_IGE(cu: TClientItem_IGE): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := High(m_HeroItemArr_IGE) downto Low(m_HeroItemArr_IGE) do begin
    if (m_HeroItemArr_IGE[I].s.Name = cu.s.Name) and (m_HeroItemArr_IGE[I].MakeIndex = cu.MakeIndex) then begin
      m_HeroItemArr_IGE[I] := cu;
      Result := True;
      Break;
    end;
  end;
end;

function TGameEngine.DelHeroItemBag(iname: string; iindex: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  if iname = '' then Exit;
  case m_btVersion of
    0: begin
        for I := High(m_HeroItemArr_BLUE) downto Low(m_HeroItemArr_BLUE) do begin
          if (m_HeroItemArr_BLUE[I].s.Name = iname) and (m_HeroItemArr_BLUE[I].MakeIndex = iindex) then begin
            SafeFillChar(m_HeroItemArr_BLUE[I], SizeOf(TClientItem_BLUE), #0);
            Result := True;
            Break;
          end;
        end;
      end;
    1: begin
        for I := High(m_HeroItemArr_IGE) downto Low(m_HeroItemArr_IGE) do begin
          if (m_HeroItemArr_IGE[I].s.Name = iname) and (m_HeroItemArr_IGE[I].MakeIndex = iindex) then begin
            SafeFillChar(m_HeroItemArr_IGE[I], SizeOf(TClientItem_IGE), #0);
            Result := True;
            Break;
          end;
        end;
      end;
  end;
  ArrangeHeroItemBag;
end;

procedure TGameEngine.ArrangeHeroItemBag;
var
  I, k: Integer;
begin
  case m_btVersion of
    0: begin
        for I := Low(m_HeroItemArr_BLUE) to High(m_HeroItemArr_BLUE) do begin
          if m_HeroItemArr_BLUE[I].s.Name <> '' then begin
            for k := I + 1 to High(m_HeroItemArr_BLUE) - 1 do begin //检测复制物品
              if (m_HeroItemArr_BLUE[I].s.Name = m_HeroItemArr_BLUE[k].s.Name) and (m_HeroItemArr_BLUE[I].MakeIndex = m_HeroItemArr_BLUE[k].MakeIndex) then begin
                SafeFillChar(m_HeroItemArr_BLUE[k], SizeOf(TClientItem_BLUE), #0);
              end;
            end;
     { for k := Low(m_HeroUseItems_BLUE) to High(m_HeroUseItems_BLUE) do begin
        if (m_HeroItemArr_BLUE[I].S.Name = m_HeroUseItems_BLUE[k].S.Name) and (m_HeroItemArr_BLUE[I].MakeIndex = m_HeroUseItems_BLUE[k].MakeIndex) then begin
          SafeFillChar(m_HeroItemArr_BLUE[k], SizeOf(TClientItem), #0);
        end;
      end; }
            if (m_HeroItemArr_BLUE[I].s.Name = m_MovingItem_BLUE.Item.s.Name) and (m_HeroItemArr_BLUE[I].MakeIndex = m_MovingItem_BLUE.Item.MakeIndex) then begin
              m_MovingItem_BLUE.Index := 0;
              m_MovingItem_BLUE.Item.s.Name := '';
            end;
          end;
        end;

        for I := Low(m_HeroUseItems_BLUE) to High(m_HeroUseItems_BLUE) do begin
          if m_HeroUseItems_BLUE[I].s.Name <> '' then begin
            for k := I + 1 to High(m_HeroUseItems_BLUE) - 1 do begin //检测复制物品
              if (m_HeroUseItems_BLUE[I].s.Name = m_HeroUseItems_BLUE[k].s.Name) and (m_HeroUseItems_BLUE[I].MakeIndex = m_HeroUseItems_BLUE[k].MakeIndex) then begin
                SafeFillChar(m_HeroUseItems_BLUE[k], SizeOf(TClientItem_BLUE), #0);
              end;
            end;
            if (m_HeroUseItems_BLUE[I].s.Name = m_MovingItem_BLUE.Item.s.Name) and (m_HeroUseItems_BLUE[I].MakeIndex = m_MovingItem_BLUE.Item.MakeIndex) then begin
              m_MovingItem_BLUE.Index := 0;
              m_MovingItem_BLUE.Item.s.Name := '';
            end;
          end;
        end;

        for I := Low(m_HeroItemArr_BLUE) to High(m_HeroItemArr_BLUE) do begin
          if m_HeroItemArr_BLUE[I].s.Name <> '' then begin
            for k := Low(m_ItemArr_BLUE) to High(m_ItemArr_BLUE) do begin //检测复制物品
              if (m_HeroItemArr_BLUE[I].s.Name = m_ItemArr_BLUE[k].s.Name) and (m_HeroItemArr_BLUE[I].MakeIndex = m_ItemArr_BLUE[k].MakeIndex) then begin
                SafeFillChar(m_HeroItemArr_BLUE[I], SizeOf(TClientItem_BLUE), #0);
              end;
            end;
      {for k := Low(m_UseItems_BLUE) to High(m_UseItems_BLUE) do begin
        if (m_HeroItemArr_BLUE[I].S.Name = m_UseItems_BLUE[k].S.Name) and (m_HeroItemArr_BLUE[I].MakeIndex = m_UseItems_BLUE[k].MakeIndex) then begin
          SafeFillChar(m_HeroItemArr_BLUE[I], SizeOf(TClientItem), #0);
        end;
      end;}
          end;
        end;
        for I := Low(m_HeroUseItems_BLUE) to High(m_HeroUseItems_BLUE) do begin
          if m_HeroUseItems_BLUE[I].s.Name <> '' then begin
            for k := Low(m_ItemArr_BLUE) to High(m_ItemArr_BLUE) do begin //检测复制物品
              if (m_HeroUseItems_BLUE[I].s.Name = m_ItemArr_BLUE[k].s.Name) and (m_HeroUseItems_BLUE[I].MakeIndex = m_ItemArr_BLUE[k].MakeIndex) then begin
                SafeFillChar(m_HeroUseItems_BLUE[I], SizeOf(TClientItem_BLUE), #0);
              end;
            end;
            for k := Low(m_UseItems_BLUE) to High(m_UseItems_BLUE) do begin
              if (m_HeroUseItems_BLUE[I].s.Name = m_UseItems_BLUE[k].s.Name) and (m_HeroUseItems_BLUE[I].MakeIndex = m_UseItems_BLUE[k].MakeIndex) then begin
                SafeFillChar(m_HeroUseItems_BLUE[I], SizeOf(TClientItem_BLUE), #0);
              end;
            end;
          end;
        end;
      end;
    1: begin
        for I := Low(m_HeroItemArr_IGE) to High(m_HeroItemArr_IGE) do begin
          if m_HeroItemArr_IGE[I].s.Name <> '' then begin
            for k := I + 1 to High(m_HeroItemArr_IGE) - 1 do begin //检测复制物品
              if (m_HeroItemArr_IGE[I].s.Name = m_HeroItemArr_IGE[k].s.Name) and (m_HeroItemArr_IGE[I].MakeIndex = m_HeroItemArr_IGE[k].MakeIndex) then begin
                SafeFillChar(m_HeroItemArr_IGE[k], SizeOf(TClientItem_IGE), #0);
              end;
            end;
     { for k := Low(m_HeroUseItems_IGE) to High(m_HeroUseItems_IGE) do begin
        if (m_HeroItemArr_IGE[I].S.Name = m_HeroUseItems_IGE[k].S.Name) and (m_HeroItemArr_IGE[I].MakeIndex = m_HeroUseItems_IGE[k].MakeIndex) then begin
          SafeFillChar(m_HeroItemArr_IGE[k], SizeOf(TClientItem_IGE), #0);
        end;
      end; }
            if (m_HeroItemArr_IGE[I].s.Name = m_MovingItem_IGE.Item.s.Name) and (m_HeroItemArr_IGE[I].MakeIndex = m_MovingItem_IGE.Item.MakeIndex) then begin
              m_MovingItem_IGE.Index := 0;
              m_MovingItem_IGE.Item.s.Name := '';
            end;
          end;
        end;

        for I := Low(m_HeroUseItems_IGE) to High(m_HeroUseItems_IGE) do begin
          if m_HeroUseItems_IGE[I].s.Name <> '' then begin
            for k := I + 1 to High(m_HeroUseItems_IGE) - 1 do begin //检测复制物品
              if (m_HeroUseItems_IGE[I].s.Name = m_HeroUseItems_IGE[k].s.Name) and (m_HeroUseItems_IGE[I].MakeIndex = m_HeroUseItems_IGE[k].MakeIndex) then begin
                SafeFillChar(m_HeroUseItems_IGE[k], SizeOf(TClientItem_IGE), #0);
              end;
            end;
            if (m_HeroUseItems_IGE[I].s.Name = m_MovingItem_IGE.Item.s.Name) and (m_HeroUseItems_IGE[I].MakeIndex = m_MovingItem_IGE.Item.MakeIndex) then begin
              m_MovingItem_IGE.Index := 0;
              m_MovingItem_IGE.Item.s.Name := '';
            end;
          end;
        end;

        for I := Low(m_HeroItemArr_IGE) to High(m_HeroItemArr_IGE) do begin
          if m_HeroItemArr_IGE[I].s.Name <> '' then begin
            for k := Low(m_ItemArr_IGE) to High(m_ItemArr_IGE) do begin //检测复制物品
              if (m_HeroItemArr_IGE[I].s.Name = m_ItemArr_IGE[k].s.Name) and (m_HeroItemArr_IGE[I].MakeIndex = m_ItemArr_IGE[k].MakeIndex) then begin
                SafeFillChar(m_HeroItemArr_IGE[I], SizeOf(TClientItem_IGE), #0);
              end;
            end;
      {for k := Low(m_UseItems_IGE) to High(m_UseItems_IGE) do begin
        if (m_HeroItemArr_IGE[I].S.Name = m_UseItems_IGE[k].S.Name) and (m_HeroItemArr_IGE[I].MakeIndex = m_UseItems_IGE[k].MakeIndex) then begin
          SafeFillChar(m_HeroItemArr_IGE[I], SizeOf(TClientItem_IGE), #0);
        end;
      end;}
          end;
        end;
        for I := Low(m_HeroUseItems_IGE) to High(m_HeroUseItems_IGE) do begin
          if m_HeroUseItems_IGE[I].s.Name <> '' then begin
            for k := Low(m_ItemArr_IGE) to High(m_ItemArr_IGE) do begin //检测复制物品
              if (m_HeroUseItems_IGE[I].s.Name = m_ItemArr_IGE[k].s.Name) and (m_HeroUseItems_IGE[I].MakeIndex = m_ItemArr_IGE[k].MakeIndex) then begin
                SafeFillChar(m_HeroUseItems_IGE[I], SizeOf(TClientItem_IGE), #0);
              end;
            end;
            for k := Low(m_UseItems_IGE) to High(m_UseItems_IGE) do begin
              if (m_HeroUseItems_IGE[I].s.Name = m_UseItems_IGE[k].s.Name) and (m_HeroUseItems_IGE[I].MakeIndex = m_UseItems_IGE[k].MakeIndex) then begin
                SafeFillChar(m_HeroUseItems_IGE[I], SizeOf(TClientItem_IGE), #0);
              end;
            end;
          end;
        end;
      end;
  end;
end;

procedure TGameEngine.ClearUserDate;
var
  I: Integer;
begin
  for I := Low(m_ItemArr_IGE) to High(m_ItemArr_IGE) do
    m_ItemArr_IGE[I].s.Name := '';
  for I := Low(m_UseItems_IGE) to High(m_UseItems_IGE) do
    m_UseItems_IGE[I].s.Name := '';

  for I := Low(m_ItemArr_BLUE) to High(m_ItemArr_BLUE) do
    m_ItemArr_BLUE[I].s.Name := '';
  for I := Low(m_UseItems_BLUE) to High(m_UseItems_BLUE) do
    m_UseItems_BLUE[I].s.Name := '';
end;

procedure TGameEngine.ClearDate;
begin

end;

procedure TGameEngine.ClearHeroDate;
var
  I: Integer;
begin
  for I := Low(m_HeroItemArr_BLUE) to High(m_HeroItemArr_BLUE) do
    m_HeroItemArr_BLUE[I].s.Name := '';

  for I := Low(m_HeroUseItems_BLUE) to High(m_HeroUseItems_BLUE) do
    m_HeroUseItems_BLUE[I].s.Name := '';

  for I := Low(m_HeroItemArr_IGE) to High(m_HeroItemArr_IGE) do
    m_HeroItemArr_IGE[I].s.Name := '';

  for I := Low(m_HeroUseItems_IGE) to High(m_HeroUseItems_IGE) do
    m_HeroUseItems_IGE[I].s.Name := '';

  m_nFirDragonPoint := 0;
  m_nMaxFirDragonPoint := 0;
end;

procedure TGameEngine.ClearBag;
var
  I: Integer;
begin
  for I := Low(m_ItemArr_IGE) to High(m_ItemArr_IGE) do
    m_ItemArr_IGE[I].s.Name := '';
  for I := Low(m_HeroItemArr_IGE) to High(m_HeroItemArr_IGE) do
    m_HeroItemArr_IGE[I].s.Name := '';

  for I := Low(m_ItemArr_BLUE) to High(m_ItemArr_BLUE) do
    m_ItemArr_BLUE[I].s.Name := '';
  for I := Low(m_HeroItemArr_BLUE) to High(m_HeroItemArr_BLUE) do
    m_HeroItemArr_BLUE[I].s.Name := '';
end;

function TGameEngine.AddItemBag_BLUE(cu: TClientItem_BLUE): Boolean;
var
  I: Integer;
  boFind: Boolean;
begin
  Result := False;
  boFind := False;
  if cu.s.Name = '' then Exit;
  for I := Low(m_ItemArr_BLUE) to High(m_ItemArr_BLUE) do begin
    if (m_ItemArr_BLUE[I].MakeIndex = cu.MakeIndex) and (m_ItemArr_BLUE[I].s.Name = cu.s.Name) then begin
      m_ItemArr_BLUE[I] := cu;
      boFind := True;
      Break;
    end;
  end;
  if (cu.s.StdMode <= 3) and not boFind then begin
    for I := 0 to 5 do
      if m_ItemArr_BLUE[I].s.Name = '' then begin
        m_ItemArr_BLUE[I] := cu;
        Result := True;
        boFind := True;
      end;
  end;
  if not boFind then begin
    for I := 6 to High(m_ItemArr_BLUE) do begin
      if m_ItemArr_BLUE[I].s.Name = '' then begin
        m_ItemArr_BLUE[I] := cu;
        Result := True;
        Break;
      end;
    end;
  end;
  ArrangeItemBag;
end;

function TGameEngine.UpdateItemBag_BLUE(cu: TClientItem_BLUE): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := High(m_ItemArr_BLUE) downto Low(m_ItemArr_BLUE) do begin
    if (m_ItemArr_BLUE[I].s.Name = cu.s.Name) and (m_ItemArr_BLUE[I].MakeIndex = cu.MakeIndex) then begin
      m_ItemArr_BLUE[I] := cu;
      Result := True;
      Break;
    end;
  end;
end;

function TGameEngine.UpdateItemBag2_BLUE(cu: TClientItem_BLUE): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := High(m_ItemArr_BLUE) downto Low(m_ItemArr_BLUE) do begin
    if {(m_ItemArr_BLUE[I].S.Name = cu.S.Name) and }(m_ItemArr_BLUE[I].MakeIndex = cu.MakeIndex) then begin
      m_ItemArr_BLUE[I] := cu;
      Result := True;
      Break;
    end;
  end;
end;

function TGameEngine.AddItemBag_IGE(cu: TClientItem_IGE): Boolean;
var
  I: Integer;
  boFind: Boolean;
begin
  Result := False;
  boFind := False;
  if cu.s.Name = '' then Exit;
  for I := Low(m_ItemArr_IGE) to High(m_ItemArr_IGE) do begin
    if (m_ItemArr_IGE[I].MakeIndex = cu.MakeIndex) and (m_ItemArr_IGE[I].s.Name = cu.s.Name) then begin
      m_ItemArr_IGE[I] := cu;
      boFind := True;
      Break;
    end;
  end;
  if (cu.s.StdMode <= 3) and not boFind then begin
    for I := 0 to 5 do
      if m_ItemArr_IGE[I].s.Name = '' then begin
        m_ItemArr_IGE[I] := cu;
        Result := True;
        boFind := True;
      end;
  end;
  if not boFind then begin
    for I := 6 to High(m_ItemArr_IGE) do begin
      if m_ItemArr_IGE[I].s.Name = '' then begin
        m_ItemArr_IGE[I] := cu;
        Result := True;
        Break;
      end;
    end;
  end;
  ArrangeItemBag;
end;

function TGameEngine.UpdateItemBag_IGE(cu: TClientItem_IGE): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := High(m_ItemArr_IGE) downto Low(m_ItemArr_IGE) do begin
    if (m_ItemArr_IGE[I].s.Name = cu.s.Name) and (m_ItemArr_IGE[I].MakeIndex = cu.MakeIndex) then begin
      m_ItemArr_IGE[I] := cu;
      Result := True;
      Break;
    end;
  end;
end;

function TGameEngine.UpdateItemBag2_IGE(cu: TClientItem_IGE): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := High(m_ItemArr_IGE) downto Low(m_ItemArr_IGE) do begin
    if {(m_ItemArr_IGE[I].S.Name = cu.S.Name) and }(m_ItemArr_IGE[I].MakeIndex = cu.MakeIndex) then begin
      m_ItemArr_IGE[I] := cu;
      Result := True;
      Break;
    end;
  end;
end;

function TGameEngine.DelItemBag(iname: string; iindex: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  if iname = '' then Exit;
  case m_btVersion of
    0: begin
        for I := High(m_ItemArr_BLUE) downto Low(m_ItemArr_BLUE) do begin
          if (m_ItemArr_BLUE[I].s.Name = iname) and (m_ItemArr_BLUE[I].MakeIndex = iindex) then begin
            m_ItemArr_BLUE[I].s.Name := '';
            //SafeFillChar(m_ItemArr_BLUE[I], SizeOf(TClientItem_BLUE), #0);
            Result := True;
            Break;
          end;
        end;
      end;
    1: begin
        for I := High(m_ItemArr_IGE) downto Low(m_ItemArr_IGE) do begin
          if (m_ItemArr_IGE[I].s.Name = iname) and (m_ItemArr_IGE[I].MakeIndex = iindex) then begin
            m_ItemArr_IGE[I].s.Name := '';
            //SafeFillChar(m_ItemArr_IGE[I], SizeOf(TClientItem_IGE), #0);
            Result := True;
            Break;
          end;
        end;
      end;
  end;
  ArrangeItemBag;
end;

procedure TGameEngine.ArrangeItemBag;
var
  I, k: Integer;
begin
  case m_btVersion of
    0: begin
        for I := Low(m_ItemArr_BLUE) to High(m_ItemArr_BLUE) do begin
          if m_ItemArr_BLUE[I].s.Name <> '' then begin
            for k := I + 1 to High(m_ItemArr_BLUE) - 1 do begin
              if (m_ItemArr_BLUE[I].s.Name = m_ItemArr_BLUE[k].s.Name) and (m_ItemArr_BLUE[I].MakeIndex = m_ItemArr_BLUE[k].MakeIndex) then begin
                m_ItemArr_BLUE[k].s.Name := '';
                //SafeFillChar(m_ItemArr_BLUE[k], SizeOf(TClientItem_BLUE), #0);
              end;
            end;
            if (m_ItemArr_BLUE[I].s.Name = m_MovingItem_BLUE.Item.s.Name) and (m_ItemArr_BLUE[I].MakeIndex = m_MovingItem_BLUE.Item.MakeIndex) then begin
              m_MovingItem_BLUE.Index := 0;
              m_MovingItem_BLUE.Item.s.Name := '';
            end;
          end;
        end;

        for I := Low(m_UseItems_BLUE) to High(m_UseItems_BLUE) do begin
          if m_UseItems_BLUE[I].s.Name <> '' then begin
            for k := I + 1 to High(m_UseItems_BLUE) - 1 do begin //检测复制物品
              if (m_UseItems_BLUE[I].s.Name = m_UseItems_BLUE[k].s.Name) and (m_UseItems_BLUE[I].MakeIndex = m_UseItems_BLUE[k].MakeIndex) then begin
                m_ItemArr_BLUE[I].s.Name := '';
                //SafeFillChar(m_UseItems_BLUE[k], SizeOf(TClientItem_BLUE), #0);
              end;
            end;
            if (m_UseItems_BLUE[I].s.Name = m_MovingItem_BLUE.Item.s.Name) and (m_UseItems_BLUE[I].MakeIndex = m_MovingItem_BLUE.Item.MakeIndex) then begin
              m_MovingItem_BLUE.Index := 0;
              m_MovingItem_BLUE.Item.s.Name := '';
            end;
          end;
        end;

        if m_MyHero <> nil then begin
          for I := Low(m_ItemArr_BLUE) to High(m_ItemArr_BLUE) do begin
            if m_ItemArr_BLUE[I].s.Name <> '' then begin
              for k := Low(m_HeroItemArr_BLUE) to High(m_HeroItemArr_BLUE) do begin //检测复制物品
                if (m_ItemArr_BLUE[I].s.Name = m_HeroItemArr_BLUE[k].s.Name) and (m_ItemArr_BLUE[I].MakeIndex = m_HeroItemArr_BLUE[k].MakeIndex) then begin
                  m_ItemArr_BLUE[I].s.Name := '';
                  //SafeFillChar(m_ItemArr_BLUE[I], SizeOf(TClientItem_BLUE), #0);
                end;
              end;
        {for k := Low(m_HeroUseItems_BLUE) to High(m_HeroUseItems_BLUE) do begin
          if (m_ItemArr_BLUE[I].S.Name = m_HeroUseItems_BLUE[k].S.Name) and (m_ItemArr_BLUE[I].MakeIndex = m_HeroUseItems_BLUE[k].MakeIndex) then begin
            SafeFillChar(m_ItemArr_BLUE[I], SizeOf(TClientItem_BLUE), #0);
          end;
        end;}
            end;
          end;
          for I := Low(m_UseItems_BLUE) to High(m_UseItems_BLUE) do begin
            if m_UseItems_BLUE[I].s.Name <> '' then begin
              for k := Low(m_HeroItemArr_BLUE) to High(m_HeroItemArr_BLUE) do begin //检测复制物品
                if (m_UseItems_BLUE[I].s.Name = m_HeroItemArr_BLUE[k].s.Name) and (m_UseItems_BLUE[I].MakeIndex = m_HeroItemArr_BLUE[k].MakeIndex) then begin
                  m_ItemArr_BLUE[I].s.Name := '';
                  //SafeFillChar(m_UseItems_BLUE[I], SizeOf(TClientItem_BLUE), #0);
                end;
              end;
              for k := Low(m_HeroUseItems_BLUE) to High(m_HeroUseItems_BLUE) do begin
                if (m_UseItems_BLUE[I].s.Name = m_HeroUseItems_BLUE[k].s.Name) and (m_UseItems_BLUE[I].MakeIndex = m_HeroUseItems_BLUE[k].MakeIndex) then begin
                  m_ItemArr_BLUE[I].s.Name := '';
                  //SafeFillChar(m_UseItems_BLUE[I], SizeOf(TClientItem_BLUE), #0);
                end;
              end;
            end;
          end;
        end;
      end;
    1: begin
        for I := Low(m_ItemArr_IGE) to High(m_ItemArr_IGE) do begin
          if m_ItemArr_IGE[I].s.Name <> '' then begin
            for k := I + 1 to High(m_ItemArr_IGE) - 1 do begin
              if (m_ItemArr_IGE[I].s.Name = m_ItemArr_IGE[k].s.Name) and (m_ItemArr_IGE[I].MakeIndex = m_ItemArr_IGE[k].MakeIndex) then begin
                SafeFillChar(m_ItemArr_IGE[k], SizeOf(TClientItem_IGE), #0);
              end;
            end;
            if (m_ItemArr_IGE[I].s.Name = m_MovingItem_IGE.Item.s.Name) and (m_ItemArr_IGE[I].MakeIndex = m_MovingItem_IGE.Item.MakeIndex) then begin
              m_MovingItem_IGE.Index := 0;
              m_MovingItem_IGE.Item.s.Name := '';
            end;
          end;
        end;

        for I := Low(m_UseItems_IGE) to High(m_UseItems_IGE) do begin
          if m_UseItems_IGE[I].s.Name <> '' then begin
            for k := I + 1 to High(m_UseItems_IGE) - 1 do begin //检测复制物品
              if (m_UseItems_IGE[I].s.Name = m_UseItems_IGE[k].s.Name) and (m_UseItems_IGE[I].MakeIndex = m_UseItems_IGE[k].MakeIndex) then begin
                SafeFillChar(m_UseItems_IGE[k], SizeOf(TClientItem_IGE), #0);
              end;
            end;
            if (m_UseItems_IGE[I].s.Name = m_MovingItem_IGE.Item.s.Name) and (m_UseItems_IGE[I].MakeIndex = m_MovingItem_IGE.Item.MakeIndex) then begin
              m_MovingItem_IGE.Index := 0;
              m_MovingItem_IGE.Item.s.Name := '';
            end;
          end;
        end;

        if m_MyHero <> nil then begin
          for I := Low(m_ItemArr_IGE) to High(m_ItemArr_IGE) do begin
            if m_ItemArr_IGE[I].s.Name <> '' then begin
              for k := Low(m_HeroItemArr_IGE) to High(m_HeroItemArr_IGE) do begin //检测复制物品
                if (m_ItemArr_IGE[I].s.Name = m_HeroItemArr_IGE[k].s.Name) and (m_ItemArr_IGE[I].MakeIndex = m_HeroItemArr_IGE[k].MakeIndex) then begin
                  SafeFillChar(m_ItemArr_IGE[I], SizeOf(TClientItem_IGE), #0);
                end;
              end;

            end;
          end;
          for I := Low(m_UseItems_IGE) to High(m_UseItems_IGE) do begin
            if m_UseItems_IGE[I].s.Name <> '' then begin
              for k := Low(m_HeroItemArr_IGE) to High(m_HeroItemArr_IGE) do begin //检测复制物品
                if (m_UseItems_IGE[I].s.Name = m_HeroItemArr_IGE[k].s.Name) and (m_UseItems_IGE[I].MakeIndex = m_HeroItemArr_IGE[k].MakeIndex) then begin
                  SafeFillChar(m_UseItems_IGE[I], SizeOf(TClientItem_IGE), #0);
                end;
              end;
              for k := Low(m_HeroUseItems_IGE) to High(m_HeroUseItems_IGE) do begin
                if (m_UseItems_IGE[I].s.Name = m_HeroUseItems_IGE[k].s.Name) and (m_UseItems_IGE[I].MakeIndex = m_HeroUseItems_IGE[k].MakeIndex) then begin
                  SafeFillChar(m_UseItems_IGE[I], SizeOf(TClientItem_IGE), #0);
                end;
              end;
            end;
          end;
        end;
      end;
  end;
end;


{----------------------------------------------------------}
{----------------------------------------------------------}

procedure TGameEngine.MoveDealItemToBag;
var
  I: Integer;
begin
  case m_btVersion of
    0: begin
        for I := 0 to 10 - 1 do begin
          if m_DealItems_BLUE[I].s.Name <> '' then
            AddItemBag_BLUE(m_DealItems_BLUE[I]);
        end;
        SafeFillChar(m_DealItems_BLUE, SizeOf(TClientItem_BLUE) * 10, #0);
      end;
    1: begin
        for I := 0 to 10 - 1 do begin
          if m_DealItems_IGE[I].s.Name <> '' then
            AddItemBag_IGE(m_DealItems_IGE[I]);
        end;
        SafeFillChar(m_DealItems_IGE, SizeOf(TClientItem_IGE) * 10, #0);
      end;
  end;
end;

procedure TGameEngine.AddDealItem_BLUE(ci: TClientItem_BLUE);
var
  I: Integer;
begin
  for I := 0 to 10 - 1 do begin
    if m_DealItems_BLUE[I].s.Name = '' then begin
      m_DealItems_BLUE[I] := ci;
      Break;
    end;
  end;
end;

procedure TGameEngine.DelDealItem_BLUE(ci: TClientItem_BLUE);
var
  I: Integer;
begin
  for I := 0 to 10 - 1 do begin
    if (m_DealItems_BLUE[I].s.Name = ci.s.Name) and (m_DealItems_BLUE[I].MakeIndex = ci.MakeIndex) then begin
      SafeFillChar(m_DealItems_BLUE[I], SizeOf(TClientItem_BLUE), #0);
      Break;
    end;
  end;
end;

procedure TGameEngine.AddDealRemoteItem_BLUE(ci: TClientItem_BLUE);
var
  I: Integer;
begin
  for I := 0 to 20 - 1 do begin
    if m_DealRemoteItems_BLUE[I].s.Name = '' then begin
      m_DealRemoteItems_BLUE[I] := ci;
      Break;
    end;
  end;
end;

procedure TGameEngine.DelDealRemoteItem_BLUE(ci: TClientItem_BLUE);
var
  I: Integer;
begin
  for I := 0 to 20 - 1 do begin
    if (m_DealRemoteItems_BLUE[I].s.Name = ci.s.Name) and (m_DealRemoteItems_BLUE[I].MakeIndex = ci.MakeIndex) then begin
      SafeFillChar(m_DealRemoteItems_BLUE[I], SizeOf(TClientItem_BLUE), #0);
      Break;
    end;
  end;
end;

procedure TGameEngine.AddDealItem_IGE(ci: TClientItem_IGE);
var
  I: Integer;
begin
  for I := 0 to 10 - 1 do begin
    if m_DealItems_IGE[I].s.Name = '' then begin
      m_DealItems_IGE[I] := ci;
      Break;
    end;
  end;
end;

procedure TGameEngine.DelDealItem_IGE(ci: TClientItem_IGE);
var
  I: Integer;
begin
  for I := 0 to 10 - 1 do begin
    if (m_DealItems_IGE[I].s.Name = ci.s.Name) and (m_DealItems_IGE[I].MakeIndex = ci.MakeIndex) then begin
      SafeFillChar(m_DealItems_IGE[I], SizeOf(TClientItem_IGE), #0);
      Break;
    end;
  end;
end;

procedure TGameEngine.AddDealRemoteItem_IGE(ci: TClientItem_IGE);
var
  I: Integer;
begin
  for I := 0 to 20 - 1 do begin
    if m_DealRemoteItems_IGE[I].s.Name = '' then begin
      m_DealRemoteItems_IGE[I] := ci;
      Break;
    end;
  end;
end;

procedure TGameEngine.DelDealRemoteItem_IGE(ci: TClientItem_IGE);
var
  I: Integer;
begin
  for I := 0 to 20 - 1 do begin
    if (m_DealRemoteItems_IGE[I].s.Name = ci.s.Name) and (m_DealRemoteItems_IGE[I].MakeIndex = ci.MakeIndex) then begin
      SafeFillChar(m_DealRemoteItems_IGE[I], SizeOf(TClientItem_IGE), #0);
      Break;
    end;
  end;
end;

procedure TGameEngine.AddChangeFace(recogid: Integer);
begin
  m_ChangeFaceReadyList.Add(Pointer(recogid));
end;

procedure TGameEngine.DelChangeFace(recogid: Integer);
var
  I: Integer;
begin
  for I := m_ChangeFaceReadyList.Count - 1 downto 0 do begin
    if Integer(m_ChangeFaceReadyList[I]) = recogid then begin
      m_ChangeFaceReadyList.Delete(I);
      Break;
    end;
  end;
end;

function TGameEngine.IsChangingFace(recogid: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to m_ChangeFaceReadyList.Count - 1 do begin
    if Integer(m_ChangeFaceReadyList[I]) = recogid then begin
      Result := True;
      Break;
    end;
  end;
end;


{------------------------ Actor ------------------------}

function TGameEngine.FindActor(id: Integer): TActor;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to m_ActorList.Count - 1 do begin
    if TActor(m_ActorList[I]).m_nRecogId = id then begin
      Result := TActor(m_ActorList[I]);
      Break;
    end;
  end;
end;

function TGameEngine.FindActor(sName: string): TActor;
var
  I: Integer;
  Actor: TActor;
begin
  Result := nil;
  for I := 0 to m_ActorList.Count - 1 do begin
    Actor := TActor(m_ActorList[I]);
    if CompareText(Actor.m_sUserName, sName) = 0 then begin
      Result := Actor;
      Break;
    end;
  end;
end;

function TGameEngine.FindActorXY(X, Y: Integer): TActor;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to m_ActorList.Count - 1 do begin
    if (TActor(m_ActorList[I]).m_nCurrX = X) and (TActor(m_ActorList[I]).m_nCurrY = Y) then begin
      Result := TActor(m_ActorList[I]);
      if not Result.m_boDeath and Result.m_boVisible and Result.m_boHoldPlace then
        Break;
    end;
  end;
end;

function TGameEngine.FindTargetXYCount(nX, nY, nRange: Integer): Integer;
var
  Actor: TActor;
  I, nC, n10: Integer;
begin
  Result := 0;
  n10 := nRange;
  for I := 0 to m_ActorList.Count - 1 do begin
    Actor := TActor(m_ActorList[I]);
    if Actor <> nil then begin
      if not Actor.m_boDeath then begin
        if (Actor.m_btRace > RCC_USERHUMAN) and (Actor.m_btRace <> RCC_MERCHANT) then begin
          nC := abs(nX - Actor.m_nCurrX) + abs(nY - Actor.m_nCurrY);
          if nC <= n10 then begin
            Inc(Result);
          end;
        end;
      end;
    end;
  end;
end;

function TGameEngine.IsValidActor(Actor: TActor): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to m_ActorList.Count - 1 do begin
    if TActor(m_ActorList[I]) = Actor then begin
      Result := True;
      Break;
    end;
  end;
end;

function TGameEngine.NewActor(chrid: Integer;
  cx: Word; //x
  cy: Word; //y
  cdir: Word;
  cfeature: Integer; //race, hair, dress, weapon
  cstate: Integer): TActor;
var
  I: Integer;
  Actor: TActor;
begin
  Result := nil;
  for I := 0 to m_ActorList.Count - 1 do begin
    if TActor(m_ActorList[I]).m_nRecogId = chrid then begin
      Result := TActor(m_ActorList[I]);
      Exit;
    end;
  end;
  if (m_MyHero <> nil) and (m_MyHero.m_nRecogId = chrid) then begin //Mars
    with m_MyHero do begin
      m_nRecogId := chrid;
      m_nCurrX := cx;
      m_nCurrY := cy;
      m_nRx := m_nCurrX;
      m_nRy := m_nCurrY;
      m_btDir := cdir;
      m_nFeature := cfeature;
      m_btRace := RACEfeature(cfeature);
      m_btHair := HAIRfeature(cfeature);
      m_btDress := DRESSfeature(cfeature);
      m_btWeapon := WEAPONfeature(cfeature);
      m_wAppearance := APPRfeature(cfeature);

      if m_btRace = 0 then begin
        m_btSex := m_btDress mod 2;
      end else begin
        m_btSex := 0;
      end;
      m_nState := cstate;
    end;
    m_ActorList.Add(m_MyHero);
    Result := m_MyHero;
    Exit;
  end;
  if IsChangingFace(chrid) then Exit;
  //
  Actor := TActor.Create;

  with Actor do begin
    m_nRecogId := chrid;
    m_nCurrX := cx;
    m_nCurrY := cy;
    m_nRx := m_nCurrX;
    m_nRy := m_nCurrY;
    m_btDir := cdir;
    m_nFeature := cfeature;
    m_btRace := RACEfeature(cfeature); //changefeature啊 乐阑锭父
    m_btHair := HAIRfeature(cfeature); //函版等促.
    m_btDress := DRESSfeature(cfeature);
    m_btWeapon := WEAPONfeature(cfeature);
    m_wAppearance := APPRfeature(cfeature);
    //      Horse:=Horsefeature(cfeature);
    //      Effect:=Effectfeature(cfeature);
    if m_btRace = 0 then begin
      m_btSex := m_btDress mod 2; //0:巢磊 1:咯磊
      //DScreen.AddChatBoardString ('Actor.m_btHair ' +IntToStr(HAIRfeature(cfeature)), clGreen, clWhite);
    end else begin
      m_btSex := 0;
    end;
    m_nState := cstate;
  end;
  m_ActorList.Add(Actor);
  Result := Actor;
end;

procedure TGameEngine.ActorDied(Actor: TObject);
var
  I: Integer;
  flag: Boolean;
begin
  for I := 0 to m_ActorList.Count - 1 do begin
    if m_ActorList[I] = Actor then begin
      m_ActorList.Delete(I);
      Break;
    end;
  end;
  flag := False;
  for I := 0 to m_ActorList.Count - 1 do begin
    if not TActor(m_ActorList[I]).m_boDeath then begin
      m_ActorList.Insert(I, Actor);
      flag := True;
      Break;
    end;
  end;
  if not flag then m_ActorList.Add(Actor);
end;

procedure TGameEngine.SetActorDrawLevel(Actor: TObject; Level: Integer);
var
  I: Integer;
begin
  if Level = 0 then begin
    for I := 0 to m_ActorList.Count - 1 do
      if m_ActorList[I] = Actor then begin
        m_ActorList.Delete(I);
        m_ActorList.Insert(0, Actor);
        Break;
      end;
  end;
end;

procedure TGameEngine.ClearActors;
var
  I: Integer;
begin
  for I := m_ActorList.Count - 1 downto 0 do begin
    if TActor(m_ActorList[I]) <> m_MySelf then begin
      if TActor(m_ActorList[I]) = m_MyHero then begin
        m_ActorList.Delete(I);
      end else begin
        TActor(m_ActorList[I]).Free;
        m_ActorList.Delete(I);
      end;
    end;
  end;
  m_TargetCret := nil;
  m_FocusCret := nil;
  m_MagicTarget := nil;
end;

function TGameEngine.DeleteActor(id: Integer): TActor;
var
  I: Integer;
  Actor: TActor;
begin
  Result := nil;
  I := 0;
  while True do begin
    if I >= m_ActorList.Count then Break;
    Actor := TActor(m_ActorList[I]);
    if (Actor.m_nRecogId = id) then begin
      if m_TargetCret = Actor then m_TargetCret := nil;
      if m_FocusCret = Actor then m_FocusCret := nil;
      if m_MagicTarget = Actor then m_MagicTarget := nil;
      if (m_MyHero <> nil) and (m_MyHero = Actor) then begin
        m_ActorList.Delete(I);
      end else begin
        Actor.m_dwDeleteTime := GetTickCount;
        m_ActorList.Delete(I);
        //m_FreeActorList.Add(Actor);
        AddFreeDeleteActor(Actor);
      end;
      Break;
    end else Inc(I);
  end;
end;

procedure TGameEngine.DelActor(Actor: TObject);
var
  I: Integer;
begin
  for I := m_ActorList.Count - 1 downto 0 do begin
    if m_ActorList[I] = Actor then begin
      TActor(m_ActorList[I]).m_dwDeleteTime := GetTickCount;
      //m_FreeActorList.Add(m_ActorList[I]);
      AddFreeDeleteActor(m_ActorList[I]);
      m_ActorList.Delete(I);
      Break;
    end;
  end;
end;

function TGameEngine.ServerAcceptNextAction: Boolean;
begin
  Result := True;
  //若服务器未响应动作命令，则10秒后自动解锁
  if ActionLock then begin
    if GetTickCount - ActionLockTime > 10 * 1000 then begin
      ActionLock := False;
    end;
    Result := False;
  end;
end;

{function  TfrmMain.CanNextAction: Boolean;
begin
   if (g_MySelf.IsIdle) and
      (g_MySelf.m_nState and $04000000 = 0) and
      (GetTickCount - g_dwDizzyDelayStart > g_dwDizzyDelayTime)
   then begin
      Result := TRUE;
   end else
      Result := FALSE;
end;}

function TGameEngine.CanNextAction: Boolean; {//是否被麻痹}
begin
  if (m_MySelf.IsIdle) and (m_MySelf.m_nState and $04000000 = 0) and (GetTickCount - g_dwDizzyDelayStart > g_dwDizzyDelayTime) then begin
    Result := True;
  end else Result := False;
end;
//是否可以攻击，控制攻击速度

function TGameEngine.CanNextHit: Boolean;
var
  NextHitTime, LevelFastTime, dwHitTime: Integer;
begin
  LevelFastTime := _MIN(370, (HumLevel * 14));
  LevelFastTime := _MIN(800, LevelFastTime + m_MySelf.m_nHitSpeed * g_nItemSpeed);

  dwHitTime := 1400;

  if g_boAttackSlow then
    NextHitTime := dwHitTime {1400} - LevelFastTime + 1500 //腕力超过时，减慢攻击速度
  else NextHitTime := dwHitTime {1400} - LevelFastTime;

  if NextHitTime < 0 then NextHitTime := 0;

  if GetTickCount - LastHitTick > LongWord(NextHitTime) then begin
    LastHitTick := GetTickCount;
    Result := True;
  end else Result := False;
end;

procedure TGameEngine.ActionFailed;
begin
  m_nTargetX := -1;
  m_nTargetY := -1;
  ActionFailLock := True;
  ActionFailLockTime := GetTickCount();
  m_MySelf.MoveFail;
end;

function TGameEngine.IsUnLockAction(Action, adir: Integer): Boolean;
begin
  if ActionFailLock then begin //如果操作被锁定，则在指定时间后解锁
    if GetTickCount() - ActionFailLockTime > 1000 then ActionFailLock := False;
  end;
  if (ActionFailLock) or (g_boMapMoving) or (g_boServerChanging) then begin
    Result := False;
  end else Result := True;
end;

{----------------------------------------------------------}



procedure TGameEngine.AddDropItem_IGE(ci: TClientItem_IGE);
var
  pc: pTClientItem_IGE;
begin
  New(pc);
  pc^ := ci;
  m_DropItems.Add(pc);
end;

procedure TGameEngine.AddDropItem_BLUE(ci: TClientItem_BLUE);
var
  pc: pTClientItem_BLUE;
begin
  New(pc);
  pc^ := ci;
  m_DropItems.Add(pc);
end;

function TGameEngine.GetDropItem_BLUE(iname: string; MakeIndex: Integer): pTClientItem_BLUE;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to m_DropItems.Count - 1 do begin
    if (pTClientItem_BLUE(m_DropItems.Items[I]).s.Name = iname) and (pTClientItem_BLUE(m_DropItems.Items[I]).MakeIndex = MakeIndex) then begin
      Result := pTClientItem_BLUE(m_DropItems.Items[I]);
      Break;
    end;
  end;
end;

function TGameEngine.GetDropItem_IGE(iname: string; MakeIndex: Integer): pTClientItem_IGE;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to m_DropItems.Count - 1 do begin
    if (pTClientItem_IGE(m_DropItems.Items[I]).s.Name = iname) and (pTClientItem_IGE(m_DropItems.Items[I]).MakeIndex = MakeIndex) then begin
      Result := pTClientItem_IGE(m_DropItems.Items[I]);
      Break;
    end;
  end;
end;


procedure TGameEngine.DelDropItem(iname: string; MakeIndex: Integer);
var
  I: Integer;
begin
  case m_btVersion of
    0: begin
        for I := 0 to m_DropItems.Count - 1 do begin
          if (pTClientItem_BLUE(m_DropItems.Items[I]).s.Name = iname) and (pTClientItem_BLUE(m_DropItems.Items[I]).MakeIndex = MakeIndex) then begin
            Dispose(pTClientItem_BLUE(m_DropItems.Items[I]));
            m_DropItems.Delete(I);
            Break;
          end;
        end;
      end;
    1: begin
        for I := 0 to m_DropItems.Count - 1 do begin
          if (pTClientItem_IGE(m_DropItems.Items[I]).s.Name = iname) and (pTClientItem_IGE(m_DropItems.Items[I]).MakeIndex = MakeIndex) then begin
            Dispose(pTClientItem_IGE(m_DropItems.Items[I]));
            m_DropItems.Delete(I);
            Break;
          end;
        end;
      end;
  end;
end;

procedure TGameEngine.ClearDropItem;
var
  I: Integer;
  DropItem: pTDropItem;
begin
  if m_MySelf <> nil then begin
    for I := m_DropedItemList.Count - 1 downto 0 do begin
      DropItem := m_DropedItemList.Items[I];
      if DropItem = nil then begin
        m_DropedItemList.Delete(I);
        Continue;
      end;
      if (abs(DropItem.X - m_MySelf.m_nCurrX) > 30) and (abs(DropItem.Y - m_MySelf.m_nCurrY) > 30) then begin
        m_DropedItemList.Delete(I);
        Dispose(DropItem);
      end;
    end;
  end;
end;

//cx, cy地图座标转换成幕座标 sx, sY

procedure TGameEngine.ScreenXYfromMCXY(cx, cy: Integer; var sx, sY: Integer);
begin
  if m_MySelf = nil then Exit;
  sx := (cx - m_MySelf.m_nRx) * UNITX + 364 + UNITX div 2 - m_MySelf.m_nShiftX;
  sY := (cy - m_MySelf.m_nRy) * UNITY + 192 + UNITY div 2 - m_MySelf.m_nShiftY;
end;

//屏幕座标 mx, my转换成ccx, ccy地图座标

procedure TGameEngine.CXYfromMouseXY(mx, my: Integer; var ccx, ccy: Integer);
begin
  if m_MySelf = nil then Exit;
  ccx := Round((mx - 364 + m_MySelf.m_nShiftX - UNITX) / UNITX) + m_MySelf.m_nRx;
  ccy := Round((my - 192 + m_MySelf.m_nShiftY - UNITY) / UNITY) + m_MySelf.m_nRy;
end;


//取得指定座标地面物品
// x,y 为屏幕座标

function TGameEngine.GetDropItems(X, Y: Integer; var inames: string): pTDropItem;
var
  k, I, ccx, ccy, ssx, ssy, dx, dy: Integer;
  DropItem: pTDropItem;
  c: Byte;
begin
  Result := nil;
  CXYfromMouseXY(X, Y, ccx, ccy);
  ScreenXYfromMCXY(ccx, ccy, ssx, ssy);
  dx := X - ssx;
  dy := Y - ssy;
  inames := '';
  for I := 0 to m_DropedItemList.Count - 1 do begin
    DropItem := pTDropItem(m_DropedItemList[I]);
    if (DropItem.X = ccx) and (DropItem.Y = ccy) then begin
      {dx := (X - ssx) + (S.Width div 2) - 3;
      dy := (Y - ssy) + (S.Height div 2);
      }
      if Result = nil then Result := DropItem;
      inames := inames + DropItem.Name + '\';
        //break;
    end;
  end;
end;

procedure TGameEngine.GetXYDropItemsList(nX, nY: Integer; var ItemList: TList);
var
  I: Integer;
  DropItem: pTDropItem;
begin
  for I := 0 to m_DropedItemList.Count - 1 do begin
    DropItem := m_DropedItemList[I];
    if (DropItem.X = nX) and (DropItem.Y = nY) then begin
      ItemList.Add(DropItem);
    end;
  end;
end;

function TGameEngine.GetXYDropItems(nX, nY: Integer): pTDropItem;
var
  I: Integer;
  DropItem: pTDropItem;
begin
  Result := nil;
  for I := 0 to m_DropedItemList.Count - 1 do begin
    DropItem := m_DropedItemList[I];
    if (DropItem.X = nX) and (DropItem.Y = nY) then begin
      Result := DropItem;
      Break;
    end;
  end;
end;

procedure TGameEngine.SendMsg(ident, chrid, X, Y, cdir, feature, State: Integer; Str: string);
var
  Actor: TActor;
begin
  case ident of
    SM_CHANGEMAP,
      SM_NEWMAP: begin
        if (ident = SM_NEWMAP) and (m_MySelf <> nil) then begin
          m_MySelf.m_nCurrX := X;
          m_MySelf.m_nCurrY := Y;
          m_MySelf.m_nRx := X;
          m_MySelf.m_nRy := Y;
          DelActor(m_MySelf);
        end;
      end;

    SM_LOGON: begin
        Actor := FindActor(chrid);
        if Actor = nil then begin
          Actor := NewActor(chrid, X, Y, LoByte(cdir), feature, State);
          cdir := LoByte(cdir);
          //Actor.SendMsg(SM_TURN, X, Y, cdir, feature, State, '', 0);
        end;
        if m_MySelf <> nil then begin
          m_MySelf := nil;
        end;
        m_MySelf := Actor;
        m_dwLoadConfigTick := GetTickCount;
        m_boUserLogin := True;
        m_boSoftClose := False;
        {m_dwUseFlyItemTick := GetTickCount + 1000 * 60 * 3;
        m_boUseFlyItem := True;

        m_dwUseReturnItemTick := GetTickCount + 1000 * 60 * 3;
        m_boUseReturnItem := True; }

        m_dwRecallBackHero := GetTickCount + 1000 * 30;
        m_boRecallBackHero := True;

        Enabled := True;

        //SendOutStr('m_boUserLogin := True');
      end;

    SM_HIDE: begin
        Actor := FindActor(chrid);
        if Actor <> nil then begin
          if Actor.m_boDelActionAfterFinished then begin
            Exit;
          end;
          if Actor.m_nWaitForRecogId <> 0 then begin
            Exit;
          end;
        end;
        DeleteActor(chrid);
      end;
  else begin
      Actor := FindActor(chrid);
      if (ident = SM_TURN) or (ident = SM_RUN) or (ident = SM_HORSERUN) or (ident = SM_WALK) or
        (ident = SM_BACKSTEP) or
        (ident = SM_DEATH) or (ident = SM_SKELETON) or
        (ident = SM_DIGUP) or (ident = SM_ALIVE) or (ident = BLUE_READ_899) or (ident = SM_IGE_5004) then begin
        if Actor = nil then
          Actor := NewActor(chrid, X, Y, LoByte(cdir), feature, State);
        if Actor <> nil then begin
          cdir := LoByte(cdir);
          if ident = SM_SKELETON then begin
            Actor.m_boDeath := True;
            Actor.m_boSkeleton := True;
          end;
          if (m_MySelf <> nil) and (Actor <> nil) and (not Actor.m_boDeath) then
            m_ShowBossList.Hint(Actor);
        end;
      end;
      if Actor = nil then Exit;
      case ident of
        SM_FEATURECHANGED: begin
          end;
        SM_CHARSTATUSCHANGED: begin
            Actor.m_nState := feature;
            Actor.m_nHitSpeed := State;
          end;
      else begin
          if ident = SM_TURN then begin
            if Str <> '' then
              Actor.m_sUserName := Str;
          end;
          //AddChatBoardString(Actor.m_sUserName + ' Actor.X:' + IntToStr(Actor.m_nCurrX) + ' Actor.Y:' + IntToStr(Actor.m_nCurrY), 255, 253);
          Actor.SendMsg(ident, X, Y, cdir, feature, State, '', 0);
        end;
      end;
    end;
  end;
end;

procedure TGameEngine.AddChatBoardString(const Text: string; FColor, BColor: Byte);
var
  DefMsg: TDefaultMessage;
  DefMsg_IGE: TDefaultMessage_IGE;
begin
  if m_btVersion = 0 then begin
    DefMsg := MakeDefaultMsg(SM_SYSMESSAGE, 0, MakeWord(FColor, BColor), 0, 0);
    GameSocket.SendToClient(EncodeMessage(DefMsg) + EncodeString(Text));
  end else begin
    DefMsg_IGE := MakeDefaultMsg_IGE(SM_SYSMESSAGE, 0, MakeWord(FColor, BColor), 0, 0);
    GameSocket.SendToClient(EncodeMessage_IGE(DefMsg_IGE) + EncodeString(Text));
  end;
end;

procedure TGameEngine.SendSay(const Text: string);
var
  Msg: TDefaultMessage;
  DefMsg_IGE: TDefaultMessage_IGE;
begin
  if m_btVersion = 0 then begin
    Msg := MakeDefaultMsg(CM_SAY, 0, 0, 0, 0);
    GameSocket.SendSocket(EncodeMessage(Msg) + EncodeString(Text));
  end else begin
    DefMsg_IGE := MakeDefaultMsg_IGE(CM_SAY, 0, 0, 0, 0);
    GameSocket.SendToClient(EncodeMessage_IGE(DefMsg_IGE) + EncodeString(Text));
  end;
end;

procedure TGameEngine.SendPickup;
var
  Msg: TDefaultMessage;
  DefMsg_IGE: TDefaultMessage_IGE;
begin
  if m_btVersion = 0 then begin
    Msg := MakeDefaultMsg(CM_PICKUP, 0, m_MySelf.m_nCurrX, m_MySelf.m_nCurrY, 0);
    GameSocket.SendSocket(EncodeMessage(Msg));
  end else begin
    DefMsg_IGE := MakeDefaultMsg_IGE(CM_PICKUP, 0, m_MySelf.m_nCurrX, m_MySelf.m_nCurrY, 0);
    GameSocket.SendToClient(EncodeMessage_IGE(DefMsg_IGE));
  end;
end;

procedure TGameEngine.SendReCallHero();
var
  Msg: TDefaultMessage;
  Msg_IGE: TDefaultMessage_IGE;
begin
  case m_btVersion of
    0: begin
        if m_MySelf <> nil then begin
          Msg := MakeDefaultMsg(BLUE_SEND_1050, m_MySelf.m_nRecogId, 0, 0, 0);
          GameSocket.SendSocket(EncodeMessage(Msg));
        end;
      end;
    1: begin
        if m_MySelf <> nil then begin
          Msg_IGE := MakeDefaultMsg_IGE(CM_IGE_5000, m_MySelf.m_nRecogId, 0, 0, 0);
          GameSocket.SendSocket(EncodeMessage_IGE(Msg_IGE));
        end;
      end;
  end;
end;

constructor TGameSocket.Create();
begin
  InitializeCriticalSection(m_UserCriticalSection);
  InitializeCriticalSection(m_SocketCriticalSection);

  m_btCode := 0;
  FSocket := 0;
  FReviceText := '';
  m_sSockText := '';
  m_sBufferText := '';
  m_dwReviceTick := GetTickCount;
  WinSend := nil;
end;

destructor TGameSocket.Destroy;
begin
  FSocket := 0;
  FReviceText := '';
  m_sSockText := '';
  m_sBufferText := '';

  DeleteCriticalSection(m_UserCriticalSection);
  DeleteCriticalSection(m_SocketCriticalSection);
  inherited;
end;

procedure TGameSocket.SendSocket(sendstr: string); //Socket: TCustomWinSocket
begin
  SendToServer('#' + IntToStr(m_btCode) + sendstr + '!');
  Inc(m_btCode);
  if m_btCode >= 10 then m_btCode := 1;
end;

procedure TGameSocket.SendClientMessage(Msg, Recog, param, tag, series: Integer);
var
  dmsg: TDefaultMessage;
  Msg_IGE: TDefaultMessage_IGE;
begin
  if GameEngine.m_btVersion = 0 then begin
    dmsg := MakeDefaultMsg(Msg, Recog, param, tag, series);
    SendSocket(EncodeMessage(dmsg));
  end else begin
    Msg_IGE := GameEngine.MakeDefaultMsg_IGE(Msg, Recog, param, tag, series);
    SendSocket(GameEngine.EncodeMessage_IGE(Msg_IGE));
  end;
end;

function TGameSocket.SendToServer(const Text: string): Integer;
var
  dwSize: cardinal;
begin
  Result := 0;
  if (FSocket <> 0) and (@WinSend <> nil) then begin
    if Integer(@WinSend) = Integer(@OldSend) then begin
      WriteProcessMemory(ProcessHandle, ApiAddress[1], @OldProc[1], 8, dwSize);
      Result := WinSend(FSocket, Pointer(Text)^, Length(Text), 0);
      JmpCode.Address := @MySend;
      WriteProcessMemory(ProcessHandle, ApiAddress[1], @JmpCode, 8, dwSize);
    end else begin
      WriteProcessMemory(ProcessHandle, ApiAddress[5], @OldProc[5], 8, dwSize);
      Result := WinSend(FSocket, Pointer(Text)^, Length(Text), 0);
      JmpCode.Address := @MySend2;
      WriteProcessMemory(ProcessHandle, ApiAddress[5], @JmpCode, 8, dwSize);
    end;
    //SendOutStr('TGameSocket.SendToServer:'+Text);
  end;
end;

function TGameSocket.SendToClient(const Text: string): Integer;
begin
  Result := 0;
  if FSocket <> 0 then begin
    FReviceText := FReviceText + '#' + Text + '!';
    SendMessage(g_HSocketHwnd, g_CM_SOCKETMESSAGE, FSocket, MakeLong($01, 0));
    //SendOutStr('TGameSocket.SendToClient:' + IntToStr(g_CM_SOCKETMESSAGE) + ' CM_SOCKETMESSAGE:' + IntToStr(CM_SOCKETMESSAGE));
  end;
end;

procedure TGameSocket.Lock;
begin
  EnterCriticalSection(m_UserCriticalSection);
end;

procedure TGameSocket.UnLock;
begin
  LeaveCriticalSection(m_UserCriticalSection);
end;

procedure TGameSocket.SocketLock;
begin
  EnterCriticalSection(m_SocketCriticalSection);
end;

procedure TGameSocket.SocketUnLock;
begin
  LeaveCriticalSection(m_SocketCriticalSection);
end;

procedure TGameSocket.Send(var Buf; var nLen: Integer);
var
  I: Integer;
  dwSize: cardinal;
  sCode, sData, sData2: string;
  nPos: Integer;

  boPos: Boolean;
  boAdd: Boolean;
begin
  if nLen > 0 then begin
    //FSendText := '';
    try
      SetLength(sData, nLen);
      Move(Pointer(@Buf)^, sData[1], nLen);
    //Move(Pointer(Buf)^, sData[1], nLen);
      //
{$IF TESTMODE = 1}
      //SendOutStr('Send:' + sData);
{$IFEND}
      GameEngine.DecodeSendPacket(sData);

      boPos := False;
      for I := 1 to Length(sData) do begin //更改发送序号
        if sData[I] = '#' then begin
          boPos := True;
          Continue;
        end;
        if boPos then begin
          boPos := False;
          case sData[I] of
            '0'..'9': begin
                sCode := IntToStr(m_btCode + GameEngine.FCheckCode);
                sData[I] := sCode[1];
                Inc(m_btCode);
                if m_btCode >= 10 then m_btCode := 1;
              end;
          end;
        end;
      end;

      FSendText := FSendText + sData;
      nLen := Length(FSendText);

      GameEngine.Lock;
      try
        GameEngine.m_sSendSockText := GameEngine.m_sSendSockText + sData;
      finally
        GameEngine.UnLock;
      end;
    except
      SendOutStr('Send Error:' + sData);
    end;
    //SendOutStr('Send:' + sData);
  end;
end;

procedure TGameSocket.Read(var Buf; var nLen: Integer);
var
  nPos, nLength, nError: Integer;
  sData, sData2: string;
begin
  //FReviceTick := GetTickCount;
  if nLen > 0 then begin
    try
      nError := 0;
      SetLength(sData, nLen);
      nError := 1;
      Move(Pointer(@Buf)^, sData[1], nLen);
      sData2 := sData;
      nError := 2;
{$IF TESTMODE = 1}
      SendOutStr('Read1:' + sData);
{$IFEND}
      GameEngine.DecodePacket(sData);
      //SendOutStr('Read2:' + sData);
      nError := 3;
      nError := 4;
      nError := 5;
      if CompareText(sData2, sData) <> 0 then begin
        FillChar(Pointer(@Buf)^, nLen, #0);
        nLen := Length(sData);
        if sData <> '' then begin
          nError := 6;
          Move(sData[1], Pointer(@Buf)^, nLen);
          nError := 7;
        end;
      end;

      while Pos('*', sData) > 0 do begin
        Delete(sData, Pos('*', sData), 1);
      end;

      if sData <> '' then begin
        GameEngine.Lock;
        try
          GameEngine.m_sSockText := GameEngine.m_sSockText + sData;
        finally
          GameEngine.UnLock;
        end;
      end;
    except
      SendOutStr('Read Error:' + sData + ' Error:' + IntToStr(nError));
    end;
  end;

end;

end.

