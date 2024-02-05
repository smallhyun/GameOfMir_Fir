unit Grobal;

interface
uses
  windows, Classes, Grobal2;
const
  MAXBAGITEMCL = 46;

  BLUE_SEND_1050 = 1050; //召唤英雄
  BLUE_SEND_1051 = 1051; //英雄退出

  BLUE_SEND_1061 = 1061; //淬炼装备

  BLUE_SEND_1080 = 1080; //用钥匙打开宝箱
  BLUE_SEND_1081 = 1081; //开始转宝箱 Ident: 1081 Recog: 2 Param: 0 Tag: 0 Series: 0
  BLUE_SEND_1082 = 1082; //双击获取宝箱选择的物品

  BLUE_SEND_1107 = 1107; //法师英雄是否持续开盾
  BLUE_SEND_1100 = 1100; //主人包裹物品放到英雄包裹
  BLUE_SEND_1101 = 1101; //英雄包裹物品放到主人包裹

  BLUE_SEND_1102 = 1102; //英雄穿装备
  BLUE_SEND_1103 = 1103; //英雄脱装备
  BLUE_SEND_1104 = 1104; //英雄吃药

  BLUE_SEND_1105 = 1105; //锁定//Ident: 1105 Recog: 260806992 Param: 0 Tag: 32 Series: 0   Recog= 锁定对象   Param=X  Tag=Y
  BLUE_SEND_1106 = 1106; //英雄扔物品
  BLUE_SEND_1108 = 1108; //合击

  //BLUE_READ_656 = 656;
  //BLUE_READ_657 = 657; //Ident: 657 Recog: 759418336 Param: 0 Tag: 32 Series: 0
  BLUE_READ_817 = 817; //主人包裹物品放到英雄包裹成功
  BLUE_READ_818 = 818; //主人包裹物品放到英雄包裹失败

  BLUE_READ_819 = 819; //英雄包裹物品放到主人包裹成功
  BLUE_READ_820 = 820; //英雄包裹物品放到主人包裹失败

  BLUE_READ_896 = 896; //获取英雄 TMessageBodyWL 产生英雄退出效果
  BLUE_READ_897 = 897; //获取英雄 TMessageBodyWL 产生英雄登陆效果
  BLUE_READ_898 = 898; //获取英雄忠诚  10001(忠00.00%)
  BLUE_READ_899 = 899; //获取英雄信息
  BLUE_READ_900 = 900; //获取英雄Abil
  BLUE_READ_901 = 901; //英雄SUBABILITY
  BLUE_READ_902 = 902; //获取英雄包裹     Tag:包裹物品数量 2 Series: 包裹物品总数量10
  BLUE_READ_903 = 903; //获取英雄身上装备
  BLUE_READ_904 = 904; //获取英雄魔法
  BLUE_READ_905 = 905; //英雄 Ident: 905 Recog: 738569296 Param: 0 Tag: 0 Series: 1   AddItem
  BLUE_READ_906 = 906; //英雄 Ident: 906 Recog: 738569296 Param: 0 Tag: 0 Series: 1   delItem
  BLUE_READ_907 = 907; //英雄穿装备OK Ident: 907 Recog: 742933632 Param: 0 Tag: 0 Series: 0
  BLUE_READ_908 = 908; //英雄穿装备FAIL

  BLUE_READ_909 = 909; //英雄脱装备OK
  BLUE_READ_910 = 910; //英雄脱装备FAIL
  BLUE_READ_911 = 911; //英雄吃药OK
  BLUE_READ_912 = 912; //英雄吃药FAIL
  BLUE_READ_913 = 913; //英雄增加魔法
  BLUE_READ_914 = 914; //英雄删除魔法

  BLUE_READ_916 = 916; //英雄怒值改变 Ident: 916 Recog: 5 Param: 2 Tag: 102 Series: 0
  BLUE_READ_918 = 918; // 英雄退出OK
  BLUE_READ_919 = 919; //英雄物品持久改变
  BLUE_READ_920 = 920; //英雄扔物品OK
  BLUE_READ_921 = 921; //英雄扔物品FAIL

  BLUE_READ_923 = 923; //英雄怒值改变 Ident: 923 Recog: 52 Param: 0 Tag: 200 Series: 0 Recog= 当前值 Tag=最大值
  BLUE_READ_950 = 950; //获取宝箱的9件装备成功 OK
  BLUE_READ_951 = 951; //获取宝箱的9件装备失败 Fail Ident: 951 Recog: 3 Param: 0 Tag: 0 Series: 0  Recog= 3 打开宝箱失败，包裹没有预留6个空格
  BLUE_READ_953 = 953; //获取宝箱选择的物品OK Ident: 953 Recog: 1 Param: 0 Tag: 0 Series: 0  Recog=1 OK Recog=0 Fail

  //CM_SAY @RestHero 改变英雄状态

  CM_IGE_2008 = 2008;

  CM_IGE_5000 = 5000; //召唤英雄      Recog: 0; Ident: 5000; Param: 0; Tag: 0; Series: 0; Param1: 2;
  SM_IGE_5001 = 5001; //召唤英雄成功      Recog: 226218672; Ident: 5001; Param: 0; Tag: 0; Series: 0; Param1: 0;
  CM_IGE_5002 = 5002; //退出英雄      Recog: 0; Ident: 5002; Param: 0; Tag: 0; Series: 0; Param1: 2;

  SM_IGE_5004 = 5004; //英雄登陆效果Recog: 226218672; Ident: 5004; Param: 319; Tag: 360; Series: 1; Param1: 0; TMessageBodyW.Param1: 257; TMessageBodyW.Param1: 263;
  SM_IGE_5005 = 5005; //英雄退出 Recog: 226218672; Ident: 5005; Param: 0; Tag: 0; Series: 0; Param1: 0;

  CM_IGE_5006 = 5006; //改变英雄状态  Recog: 226218672; Ident: 5006; Param: 0; Tag: 0; Series: 0; Param1: 2;
  CM_IGE_5007 = 5007; //英雄锁定  Recog: 226218672; Ident: 5007; Param: 343; Tag: 363; Series: 0; Param1: 2;
  CM_IGE_5008 = 5008; //英雄守护  Recog: 0; Ident: 5008; Param: 343; Tag: 363; Series: 0; Param1: 2;


  CM_IGE_5009 = 5009; //英雄穿装备      Recog: 226218672; Ident: 5009; Param: 0; Tag: 0; Series: 0; Param1: 2;
  CM_IGE_5010 = 5010; //英雄脱装备      Recog: 226218672; Ident: 5010; Param: 0; Tag: 0; Series: 0; Param1: 2;
  SM_IGE_5015 = 5015; //英雄穿装备OK    Recog: 226218672; Ident: 5015; Param: 0; Tag: 0; Series: 0; Param1: 0;
  SM_IGE_5016 = 5016; //英雄穿装备FAIL  Recog: -2; Ident: 5016; Param: 0; Tag: 0; Series: 0; Param1: 0;
  SM_IGE_5017 = 5017; //英雄脱装备OK    Recog: 226218672; Ident: 5017; Param: 0; Tag: 0; Series: 0; Param1: 0;
  SM_IGE_5018 = 5018; //英雄脱装备FAIL  Recog: 226218672; Ident: 5018; Param: 0; Tag: 0; Series: 0; Param1: 0;


  CM_IGE_5031 = 5031; //可能是查询英雄包裹    Recog: 0; Ident: 5031; Param: 0; Tag: 0; Series: 0; Param1: 2;

  SM_IGE_5032 = 5032; //英雄装备 Recog: 0; Ident: 5032; Param: 0; Tag: 0; Series: 0; Param1: 0;
  SM_IGE_5033 = 5033; //英雄包裹 Recog: 196763812; Ident: 5033; Param: 0; Tag: 0; Series: 2; Param1: 0;

  SM_IGE_5034 = 5034; //ADD英雄包裹 Recog: 196763812; Ident: 5034; Param: 0; Tag: 0; Series: 1; Param1: 0;
  SM_IGE_5035 = 5035; //DEL英雄包裹 Recog: 196763812; Ident: 5035; Param: 0; Tag: 0; Series: 1; Param1: 0;

  SM_IGE_5038 = 5038; //Recog: 0; Ident: 5038; Param: 0; Tag: 0; Series: 0; Param1: 0;

  SM_IGE_5030 = 5030; //英雄包裹数量 Recog: 10; Ident: 5030; Param: 0; Tag: 0; Series: 0; Param1: 0;

  SM_IGE_5040 = 5040; //英雄SM_ABILITY Recog: 1; Ident: 5040; Param: 0; Tag: 0; Series: 0; Param1: 0;
  SM_IGE_5041 = 5041; //英雄SM_SUBABILITY Recog: 1; Ident: 5041; Param: 3857; Tag: 0; Series: 0; Param1: 0;
  SM_IGE_5042 = 5042; //英雄未知 Recog: 12（背包重量）; Ident: 5042; Param: 14（穿戴重量）; Tag: 40（腕力）; Series: 0; Param1: 0;

  CM_IGE_5043 = 5043; //英雄使用物品     Recog: 0; Ident: 5043; Param: 0; Tag: 0; Series: 0; Param1: 2;
  SM_IGE_5044 = 5044; //英雄使用物品OK   Recog: 0; Ident: 5044; Param: 0; Tag: 0; Series: 0; Param1: 0;
  SM_IGE_5045 = 5045; //英雄使用物品FAIL Recog: 0; Ident: 5045; Param: 0; Tag: 0; Series: 0; Param1: 0;

  SM_IGE_5047 = 5047; //英雄使用物品FAIL Recog: 9510; Ident: 5047; Param: 12; Tag: 10000; Series: 0; Param1: 0;

  SM_IGE_5049 = 5049; //英雄升级 Recog: 16329; Ident: 5049; Param: 100（等级）; Tag: 0; Series: 0; Param1: 0;

  SM_IGE_10055 = 10055; //英雄SM_HEALTHSPELLCHANGED Recog: 1; Ident: 10055; Param: 5(HP); Tag: 0(MP); Series: 37(MAXHP); Param1: 0;

  SM_IGE_10059 = 10059; //英雄SM_HEALTHSPELLCHANGED Recog: 229463448; Ident: 10059; Param: 0; Tag: 361(MAXMP); Series: 6807(MAXHP); Param1: 0;

  SM_IGE_20012 = 20012; //英雄未知 Recog: 226218672; Ident: 20012; Param: 0; Tag: 0; Series: 0; Param1: 0;  82170/3333000

  SM_IGE_20021 = 20021; //英雄退出效果 Recog: 226218672; Ident: 20021; Param: 43128; Tag: 0; Series: 0; Param1: 0;


//5001到达后开始发送5031

//F^dlH?<lGo<lH?<kHnxuH_<lJ?<qHODkH<  **0000/0000/3/920080512/0

  SM_IGE_20024 = 20024; //Recog: 228442876; Ident: 20024; Param: 20038; Tag: 0; Series: 0; Param1: 0;

  SM_IGE_20098 = 20098; //Recog: 0; Ident: 20098; Param: 0; Tag: 0; Series: 0; Param1: 0;
  SM_IGE_20099 = 20099; //Recog: 0; Ident: 20099; Param: 0; Tag: 0; Series: 0; Param1: 3;
  CM_IGE_20097 = 20097; //Recog: 0; Ident: 20099; Param: 0; Tag: 0; Series: 0; Param1: 3;

  CM_IGE_5013 = 5013; //英雄包裹物品放到主体包裹    Recog: 0; Ident: 5013; Param: 253; Tag: 0; Series: 0; Param1: 3;
  CM_IGE_5014 = 5014; //主体包裹物品放到英雄包裹    Recog: 0; Ident: 5014; Param: 0; Tag: 0; Series: 0; Param1: 3;

  SM_IGE_5025 = 5025; //英雄包裹物品放到主体包裹OK  Recog: 0; Ident: 5025; Param: 0; Tag: 0; Series: 0; Param1: 0;
  SM_IGE_5026 = 5026; //英雄包裹物品放到主体包裹FAIL  Recog: -3; Ident: 5025; Param: 0; Tag: 0; Series: 0; Param1: 0;

  SM_IGE_5027 = 5027; //主体包裹物品放到英雄包裹OK  Recog: 0; Ident: 5027; Param: 0; Tag: 0; Series: 0; Param1: 0;
  SM_IGE_5028 = 5028; //主体包裹物品放到英雄包裹FAIL  Recog: -3; Ident: 5027; Param: 0; Tag: 0; Series: 0; Param1: 0;
  CM_IGE_5052 = 5052; //英雄仍物品      Recog: 226218672（装备MAKEIDEX）; Ident: 5052; Param: 0; Tag: 0; Series: 0; Param1: 3;
  SM_IGE_5053 = 5053; //英雄仍物品OK    Recog: 226218672（装备MAKEIDEX）; Ident: 5053; Param: 0; Tag: 0; Series: 0; Param1: 0;
  SM_IGE_5054 = 5054; //英雄仍物品FAIL  Recog: 226218672（装备MAKEIDEX）; Ident: 5054; Param: 0; Tag: 0; Series: 0; Param1: 0;
type
  TDefaultMessage_IGE = record
    Recog: Integer;
    Ident: Word;
    Param: Word;
    Tag: Word;
    Series: Word;
    Param1: Integer;
  end;
  pTDefaultMessage_IGE = ^TDefaultMessage_IGE;

  TUpdateItem_BLUE = record //BLUE升级装备
    MakeIndex: Integer;
    ItemName: string[14];
  end;
  pTUpdateItem_BLUE = ^TUpdateItem_BLUE;
  TUpdateItemArray_BLUE = array[0..2] of TUpdateItem_BLUE;
  TBoxItemArray_BLUE = array[0..1] of TUpdateItem_BLUE;

  TOCharDesc = record
    feature: Integer;
    Status: Integer;
  end;

  TStdItem_IGE = packed record
    Name: string[14];
    StdMode: Byte;
    Shape: Byte;
    Weight: Byte;
    AniCount: Byte;
    Source: ShortInt;
    Reserved: Byte;
    NeedIdentify: Byte;
    Looks: Word;
    DuraMax: Word;
    Reserved1: Word;
    AC: Integer;
    MAC: Integer;
    DC: Integer;
    MC: Integer;
    SC: Integer;
    Need: Integer;
    NeedLevel: Integer;
    Price: Integer;
    n: Integer;
  end;
  pTStdItem_IGE = ^TStdItem_IGE;

  TStdItem_BLUE = packed record //OK
    Name: string[14];
    StdMode: BYTE;
    Shape: BYTE;
    Weight: BYTE;
    AniCount: BYTE;
    Source: ShortInt;
    Reserved: BYTE;
    NeedIdentify: BYTE;
    Looks: Word;
    DuraMax: Word;
    AC: Word;
    MAC: Word;
    DC: Word;
    MC: Word;
    SC: Word;
    Need: BYTE;
    NeedLevel: BYTE;
    w26: Word;
    Price: Integer;
  end;
  pTStdItem_BLUE = ^TStdItem_BLUE;

  TClientItem_BLUE = record //OK
    s: TStdItem_BLUE;
    MakeIndex: Integer;
    Dura: Word;
    DuraMax: Word;
  end;
  pTClientItem_BLUE = ^TClientItem_BLUE;

  TClientItem_IGE = record //OK
    s: TStdItem_IGE;
    MakeIndex: Integer;
    Dura: Word;
    DuraMax: Word;
  end;
  pTClientItem_IGE = ^TClientItem_IGE;


  TUserEatItems = record
    boHero: Boolean;
    boAuto: Boolean;
    boSend: Boolean;
    boBind: Boolean;
    nIndex: Integer;
    dwEatTime: LongWord;
    IGE: TClientItem_IGE;
    BLUE: TClientItem_BLUE;
  end;
  pTUserEatItems = ^TUserEatItems;

  TAbility_IGE = packed record //OK    //Size 40
    Level: Word; //0x198  //0x34  0x00
    AC: Integer; //0x19A  //0x36  0x02
    MAC: Integer; //0x19C  //0x38  0x04
    DC: Integer; //0x19E  //0x3A  0x06
    MC: Integer; //0x1A0  //0x3C  0x08
    SC: Integer; //0x1A2  //0x3E  0x0A
    HP: Word; //0x1A4  //0x40  0x0C
    MP: Word; //0x1A6  //0x42  0x0E
    MaxHP: Word; //0x1A8  //0x44  0x10
    MaxMP: Word; //0x1AA  //0x46  0x12
    Exp: LongWord; //0x1B0  //0x4C 0x18
    MaxExp: LongWord; //0x1B4  //0x50 0x1C
    Weight: Word; //0x1B8   //0x54 0x20
    MaxWeight: Word; //0x1BA   //0x56 0x22  背包
    WearWeight: Word; //0x1BC   //0x58 0x24
    MaxWearWeight: Word; //0x1BD   //0x59 0x25  负重
    HandWeight: Word; //0x1BE   //0x5A 0x26
    MaxHandWeight: Word; //0x1BF   //0x5B 0x27  腕力
  end;
  pTAbility_IGE = ^TAbility_IGE;

  TAbility_BLUE = packed record
    Level: Word;
    AC: Word;
    MAC: Word;
    DC: Word;
    MC: Word;
    SC: Word;
    HP: Word;
    MP: Word;
    MaxHP: Word;
    MaxMP: Word;
    btReserved1: BYTE;
    btReserved2: BYTE;
    btReserved3: BYTE;
    btReserved4: BYTE;
    Exp: LongWORD;
    MaxExp: LongWORD;
    Weight: Word;
    MaxWeight: Word; //背包
    WearWeight: BYTE;
    MaxWearWeight: BYTE; //负重
    HandWeight: BYTE;
    MaxHandWeight: BYTE; //腕力
  end;
  pTAbility_BLUE = ^TAbility_BLUE;

  TUserItem_BLUE = packed record
    MakeIndex: Integer;
    wIndex: Word; //物品id
    Dura: Word; //当前持久值
    DuraMax: Word; //最大持久值
    btValue: TValue; //array[0..13] of Byte;
  end;
  pTUserItem_BLUE = ^TUserItem_BLUE;

  TUserItem_IGE = packed record
    MakeIndex: Integer;
    wIndex: Word; //物品id
    Dura: Word; //当前持久值
    DuraMax: Word; //最大持久值
    btValue: TValue; //array[0..13] of Byte;
  end;
  pTUserItem_IGE = ^TUserItem_IGE;

  TUserStateInfo_BLUE = packed record //OK
    feature: Integer;
    UserName: string[15]; // 15
    GuildName: string[14]; //14
    GuildRankName: string[16]; //15
    NAMECOLOR: Word;
    UseItems: array[0..8] of TClientItem_BLUE;
  end;

  TUserStateInfo_IGE = record
    feature: Integer;
    UserName: string[ACTORNAMELEN];
    NAMECOLOR: Integer;
    GuildName: string[ACTORNAMELEN];
    GuildRankName: string[16];
    UseItems: array[0..12] of TClientItem_IGE;
  end;
  pTUserStateInfo_IGE = ^TUserStateInfo_IGE;

  //  [药品] [武器][衣服][头盔][首饰][其它]

  TBindClientItem = record
    btItemType: BYTE;
    sItemName: string;
    sBindItemName: string;
  end;
  pTBindClientItem = ^TBindClientItem;


  TMapWalkXY = record
    nWalkStep: Integer;
    nMonCount: Integer;
    nX: Integer;
    nY: Integer;
  end;
  pTMapWalkXY = ^TMapWalkXY;


  TShowBoss = record
    sBossName: string[14];
    boShowName: Boolean;
    boHintMsg: Boolean;
    //btColor: Byte;
  end;
  pTShowBoss = ^TShowBoss;


  TMovingItem_IGE = record
    Index: Integer;
    Item: TClientItem_IGE;
    Owner: TObject;
  end;
  pTMovingItem_IGE = ^TMovingItem_IGE;

  TMovingItem_BLUE = record
    Index: Integer;
    Item: TClientItem_BLUE;
    Owner: TObject;
  end;
  pTMovingItem_BLUE = ^TMovingItem_BLUE;


  TUseItems_IGE = array[0..12] of TClientItem_IGE;
  TItemArr_IGE = array[0..46 - 1] of TClientItem_IGE;
  THeroItemArr_IGE = array[0..46 - 1 - 6] of TClientItem_IGE;
  TUpgradeItemArr_IGE = array[0..2] of TClientItem_IGE;

  pTUseItems_IGE = ^TUseItems_IGE;
  pTItemArr_IGE = ^TItemArr_IGE;
  pTHeroItemArr_IGE = ^THeroItemArr_IGE;


  TUseItems_BLUE = array[0..12] of TClientItem_BLUE;
  TItemArr_BLUE = array[0..46 - 1] of TClientItem_BLUE;
  THeroItemArr_BLUE = array[0..46 - 1 - 6] of TClientItem_BLUE;
  TUpgradeItemArr_BLUE = array[0..2] of TClientItem_BLUE;

  pTUseItems_BLUE = ^TUseItems_BLUE;
  pTItemArr_BLUE = ^TItemArr_BLUE;
  pTHeroItemArr_BLUE = ^THeroItemArr_BLUE;



  {TUpgradeItem = record
    sName: string[30];
    nMakeIndex: Integer;
  end;

  TClientUpgradeItem = array[0..2] of TUpgradeItem;

  TUpgradeItemIndexs = array[0..2] of Integer;
  TUpgradeItemNames = array[0..2] of string[20];
  pTUpgradeItemIndexs = ^TUpgradeItemIndexs;

  TUpgradeClientItem = record
    UpgradeItemIndexs: TUpgradeItemIndexs;
    UpgradeItemNames: TUpgradeItemNames;
  end;
  pTUpgradeClientItem = ^TUpgradeClientItem;


  THintItem = record
    boHint: Boolean;
    DropItem: pTDropItem;
  end;
  pTHintItem = ^THintItem;
    }

  THero_BLUE = record
    UnByte: array[0..16] of BYTE;
  end;
  pTHero_BLUE = ^THero_BLUE;


{function APPRfeature(cfeature: Integer): Word;
function RACEfeature(cfeature: Integer): BYTE;
function HAIRfeature(cfeature: Integer): BYTE;
function DRESSfeature(cfeature: Integer): BYTE;
function WEAPONfeature(cfeature: Integer): BYTE;
function Horsefeature(cfeature: Integer): BYTE;
function Effectfeature(cfeature: Integer): BYTE;
function MakeHumanFeature(btRaceImg, btDress, btWeapon, btHair: BYTE): Integer;
function MakeMonsterFeature(btRaceImg, btWeapon: BYTE; wAppr: Word): Integer;}
implementation
{function WEAPONfeature(cfeature: Integer): BYTE;
begin
  Result := HiByte(cfeature);
end;
function DRESSfeature(cfeature: Integer): BYTE;
begin
  Result := HiByte(HiWord(cfeature));
end;
function APPRfeature(cfeature: Integer): Word;
begin
  Result := HiWord(cfeature);
end;
function HAIRfeature(cfeature: Integer): BYTE;
begin
  Result := HiWord(cfeature);
end;

function RACEfeature(cfeature: Integer): BYTE;
begin
  Result := cfeature;
end;

function Horsefeature(cfeature: Integer): BYTE;
begin
  Result := LoByte(LoWord(cfeature));
end;
function Effectfeature(cfeature: Integer): BYTE;
begin
  Result := HiByte(LoWord(cfeature));
end;

function MakeHumanFeature(btRaceImg, btDress, btWeapon, btHair: BYTE): Integer;
begin
  Result := MakeLong(MakeWord(btRaceImg, btWeapon), MakeWord(btHair, btDress));
end;
function MakeMonsterFeature(btRaceImg, btWeapon: BYTE; wAppr: Word): Integer;
begin
  Result := MakeLong(MakeWord(btRaceImg, btWeapon), wAppr);
end;}
end.

