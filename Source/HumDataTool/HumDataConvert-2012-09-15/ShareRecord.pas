unit ShareRecord;

interface
uses
  Windows, Classes, Controls;
const
  ACCOUNTLEN = 30;
  MAXPATHLEN = 255;
  DIRPATHLEN = 80;
  MAPNAMELEN = 16;
  ACTORNAMELEN = 14;
  DEFBLOCKSIZE = 16;
  BUFFERSIZE = 10000;
  DATA_BUFSIZE2 = 16348; //8192;
  DATA_BUFSIZE = 8192; //8192;
  GROUPMAX = 11;
  BAGGOLD = 5000000;
  BODYLUCKUNIT = 10;
  MAX_STATUS_ATTRIBUTE = 12;
type
  TValue = array[0..13] of Byte;
  TValueA = array[0..1] of Byte;
  TNewStatus = (sNone, sBlind, sConfusion); //失明 混乱 状态]
  
  TOAbility = packed record  //Size = 40
    Level: LongInt; //0x198  //0x34  0x00
    AC: Word;
    MAC: Word;
    DC: Word;
    MC: Word;
    SC: Word;
    HP: LongInt; //0x1A4  //0x40  0x0C
    MP: LongInt; //0x1A6  //0x42  0x0E
    MaxHP: LongInt; //0x1A8  //0x44  0x10
    MaxMP: LongInt; //0x1AA  //0x46  0x12
    btReserved1: Byte;
    btReserved2: Byte;
    btReserved3: Byte;
    btReserved4: Byte;
    Exp: LongWord;
    MaxExp: LongWord;
    Weight: Word;
    MaxWeight: Word; //背包
    WearWeight: Byte;
    MaxWearWeight: Byte; //负重
    HandWeight: Byte;
    MaxHandWeight: Byte; //腕力
  end;
  pTOAbility = ^TOAbility;

  TNakedAbility = packed record //Size 20
    DC: word;
    MC: word;
    SC: word;
    AC: word;
    MAC: word;
    HP: word;
    MP: word;
    Hit: word;
    Speed: word;
    X2: word;
  end;
  pTNakedAbility = ^TNakedAbility;

  THumMagic = record
    wMagIdx: word;
    btLevel: Byte;
    btKey: Byte;
    nTranPoint: Integer; //当前持久值
  end;
  pTHumMagic = ^THumMagic;


  TUserItem = packed record
    MakeIndex: Integer;
    wIndex: Word; //物品id
    Dura: Word; //当前持久值
    DuraMax: Word; //最大持久值
    btValue: TValue; //array[0..13] of Byte;

    AddValue: TValue; //12=装备发光(1,2,3)
    AddPoint: TValue; //1=新属性类型(1=物理伤害减少 2=魔法伤害减少 3=忽视目标防御 4=所有伤害反射 5=增加攻击伤害) 2=新属性值
                      //3=物理防御增强 4=魔法防御增强 5=物理攻击增强 6=魔法攻击增强 7=道术攻击增强 8=增加进入失明状态 9=增加进入混乱状态 10=减少进入失明状态 11=减少进入混乱状态 12=移动加速 13=攻击加速
    btColor: Byte;
    btValue2: array[0..12] of Byte;
    MaxDate: TDateTime;
  end;
  pTUserItem = ^TUserItem;

  TRecordHeader = packed record //Size 12
    boDeleted: Boolean;
    nSelectID: Byte;
    boIsHero: Boolean;
    bt2: Byte;
    dCreateDate: TDateTime; //创建时间
    sName: string[15]; //0x15  //角色名称   28
  end;
  pTRecordHeader = ^TRecordHeader;

  TUnKnow = array[0..35] of Byte;

  TAddByte = array[0..16] of Byte;


  TOQuestFlag = array[0..127] of Byte;
  TQuestFlag = array[0..128 * 2 - 1] of Byte;

  TStatusTime = array[0..MAX_STATUS_ATTRIBUTE - 1] of Word;


  TOHumAddItems = array[9..12] of TUserItem;

  THumItems = array[0..8] of TUserItem;
  THumAddItems = array[9..15] of TUserItem;
  TBagItems = array[0..45] of TUserItem;
  TStorageItems = array[0..45] of TUserItem;
  THumMagics = array[0..29] of THumMagic;
  THumanUseItems = array[0..12] of TUserItem;


  pTHumItems = ^THumItems;
  pTBagItems = ^TBagItems;
  pTStorageItems = ^TStorageItems;
  pTHumAddItems = ^THumAddItems;
  pTHumMagics = ^THumMagics;
  pTOHumAddItems = ^TOHumAddItems;

  TOHumData = packed record //Size = 3164
    sChrName: string[ACTORNAMELEN];
    sCurMap: string[MAPNAMELEN];
    wCurX: Word;
    wCurY: Word;
    btDir: Byte;
    btHair: Byte;
    btSex: Byte;
    btJob: Byte;
    nGold: Integer;
    Abil: TOAbility; //+40
    wStatusTimeArr: TStatusTime; //+24
    sHomeMap: string[MAPNAMELEN];
    wHomeX: Word;
    wHomeY: Word;
    sDearName: string[ACTORNAMELEN];
    sMasterName: string[ACTORNAMELEN];
    boMaster: Boolean;
    btCreditPoint: Integer;
    btDivorce: Byte; //是否结婚
    btMarryCount: Byte; //结婚次数
    sStoragePwd: string[7];
    btReLevel: Byte;
    boOnHorse: Boolean;
    BonusAbil: TNakedAbility; //+20
    nBonusPoint: Integer;
    nGameGold: Integer;
    nGamePoint: Integer;
    nGameDiamond: Integer; //金刚石
    nGameGird: Integer; //灵符
    nGameGlory: Integer; //荣誉
    nPayMentPoint: Integer; //充值点
    nPKPOINT: Integer;
    btAllowGroup: Byte;
    btF9: Byte;
    btAttatckMode: Byte;
    btIncHealth: Byte;
    btIncSpell: Byte;
    btIncHealing: Byte;
    btFightZoneDieCount: Byte;
    sAccount: string[ACCOUNTLEN];
    btEE: Byte;
    btEF: Byte;
    boLockLogon: Boolean;
    wContribution: Word;
    nHungerStatus: Integer;
    boAllowGuildReCall: Boolean; //  是否允许行会合一
    wGroupRcallTime: Word; //队传送时间
    dBodyLuck: Double; //幸运度  8
    boAllowGroupReCall: Boolean; // 是否允许天地合一
    nEXPRATE: Integer; //经验倍数
    nExpTime: Integer; //经验倍数时间
    btLastOutStatus: Byte; //2006-01-12增加 退出状态 1为死亡退出
    wMasterCount: Word; //出师徒弟数
    boHasHero: Boolean; //是否有英雄
    boIsHero: Boolean; //是否是英雄
    btStatus: Byte; //状态
    sHeroChrName: string[ACTORNAMELEN];
    nGrudge: Integer;
    QuestFlag: TOQuestFlag; //脚本变量
    NewStatus: TNewStatus; //1失明 2混乱 状态
    wStatusDelayTime: Word; //失明混乱时间
    AddByte: TAddByte;
    HumItems: THumItems; //9格装备 衣服  武器  蜡烛 头盔 项链 手镯 手镯 戒指 戒指
    BagItems: TBagItems; //包裹装备
    HumMagics: THumMagics; //魔法
    StorageItems: TStorageItems; //仓库物品
    HumAddItems: TOHumAddItems; //新增4格 护身符 腰带 鞋子 宝石
  end;
  pTOHumData = ^TOHumData;

  THumData = packed record //Size = 3164
    sChrName: string[ACTORNAMELEN];
    sCurMap: string[MAPNAMELEN];
    wCurX: Word;
    wCurY: Word;
    btDir: Byte;
    btHair: Byte;
    btSex: Byte;
    btJob: Byte;
    nGold: Integer;
    Abil: TOAbility; //+40
    wStatusTimeArr: TStatusTime; //+24
    sHomeMap: string[MAPNAMELEN];
    wHomeX: Word;
    wHomeY: Word;
    sDearName: string[ACTORNAMELEN];
    sMasterName: string[ACTORNAMELEN];
    boMaster: Boolean;
    btCreditPoint: Integer;
    btDivorce: Byte; //是否结婚
    btMarryCount: Byte; //结婚次数
    sStoragePwd: string[7];
    btReLevel: Byte;
    boOnHorse: Boolean;
    BonusAbil: TNakedAbility; //+20
    nBonusPoint: Integer;
    nGameGold: Integer;
    nGamePoint: Integer;
    nGameDiamond: Integer; //金刚石
    nGameGird: Integer; //灵符
    nGameGlory: Integer; //荣誉
    nPayMentPoint: Integer; //充值点
    nPKPOINT: Integer;
    btAllowGroup: Byte;
    btF9: Byte;
    btAttatckMode: Byte;
    btIncHealth: Byte;
    btIncSpell: Byte;
    btIncHealing: Byte;
    btFightZoneDieCount: Byte;
    sAccount: string[ACCOUNTLEN];
    btEE: Byte;
    btEF: Byte;
    boLockLogon: Boolean;
    wContribution: Word;
    nHungerStatus: Integer;
    boAllowGuildReCall: Boolean; //  是否允许行会合一
    wGroupRcallTime: Word; //队传送时间
    dBodyLuck: Double; //幸运度  8
    boAllowGroupReCall: Boolean; // 是否允许天地合一
    nEXPRATE: Integer; //经验倍数
    nExpTime: Integer; //经验倍数时间
    btLastOutStatus: Byte; //2006-01-12增加 退出状态 1为死亡退出
    wMasterCount: Word; //出师徒弟数
    boHasHero: Boolean; //是否有英雄
    boIsHero: Boolean; //是否是英雄
    btStatus: Byte; //状态
    sHeroChrName: string[ACTORNAMELEN];
    nGrudge: Integer;
    QuestFlag: TQuestFlag; //脚本变量
    NewStatus: TNewStatus; //1失明 2混乱 状态
    wStatusDelayTime: Word; //失明混乱时间
    AddByte: TAddByte;
    HumItems: THumItems; //9格装备 衣服  武器  蜡烛 头盔 项链 手镯 手镯 戒指 戒指
    BagItems: TBagItems; //包裹装备
    HumMagics: THumMagics; //魔法
    StorageItems: TStorageItems; //仓库物品
    HumAddItems: THumAddItems; //新增4格 护身符 腰带 鞋子 宝石
  end;
  pTHumData = ^THumData;

  THumDataInfo = packed record //Size 3164
    Header: TRecordHeader;
    Data: THumData;
  end;
  pTHumDataInfo = ^THumDataInfo;

  TOHumDataInfo = packed record //Size 3164
    Header: TRecordHeader;
    Data: TOHumData;
  end;
  pTOHumDataInfo = ^TOHumDataInfo;
implementation

end.

