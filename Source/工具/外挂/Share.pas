unit Share;

interface
uses
  Classes,
  SysUtils,
  windows,
  Messages,
  Grobal,
  CShare,
  Grobal2;
type
  TItemType = (i_HPMPDurg, i_Weapon, i_Dress, i_Helmet, i_Jewelry, i_Other);
  TDBHeader = Integer;

  TBindClientItem = record
    btItemType: Byte;
    sItemName: string;
    sBindItemName: string;
  end;
  pTBindClientItem = ^TBindClientItem;

  TShowItem = record
    sItemName: string[14];
    ItemType: TItemType;
    boShowName: Boolean;
    boPickup: Boolean;
    boMovePick: Boolean;
    boHintMsg: Boolean;
    boHide: Boolean; //隐藏物品，不显示出来
  end;
  pTShowItem = ^TShowItem;

  TShowBoss = record
    sBossName: string[14];
    boShowName: Boolean;
    boHintMsg: Boolean;
    //btColor: Byte;
  end;
  pTShowBoss = ^TShowBoss;

  THintBoss = record
    boHint: Boolean;
    Actor: TObject;
  end;
  pTHintBoss = ^THintBoss;

  THintItem = record
    boHint: Boolean;
    DropItem: pTDropItem;
  end;
  pTHintItem = ^THintItem;

  {===================================TGList===================================}

  TGList = class(TList)
  private
    CriticalSection: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
    procedure Up(Item: Pointer);
    procedure Down(Item: Pointer);
  end;

  {=================================TGStringList================================}
  TGStringList = class(TStringList)
  private
    CriticalSection: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
    procedure Up(AObject: TObject);
    procedure Down(AObject: TObject);
  end;

type
  TConfig = record
    boHumUseHP: Boolean;
    boHumUseMP: Boolean;
    boHeroUseHP: Boolean;
    boHeroUseMP: Boolean;
    nHumMinHP: Integer;
    nHumMinMP: Integer;
    nHeroMinHP: Integer;
    nHeroMinMP: Integer;
    nHumHPTime: Integer;
    nHumMPTime: Integer;
    nHeroHPTime: Integer;
    nHeroMPTime: Integer;

    boHumUseHP1: Boolean;
    boHumUseMP1: Boolean;
    boHeroUseHP1: Boolean;
    boHeroUseMP1: Boolean;
    nHumMinHP1: Integer;
    nHumMinMP1: Integer;
    nHeroMinHP1: Integer;
    nHeroMinMP1: Integer;
    nHumHPTime1: Integer;
    nHumMPTime1: Integer;
    nHeroHPTime1: Integer;
    nHeroMPTime1: Integer;

    nHumEatHPItem: Integer;
    nHumEatMPItem: Integer;
    nHumEatHPItem1: Integer;
    nHumEatMPItem1: Integer;

    nHeroEatHPItem: Integer;
    nHeroEatMPItem: Integer;
    nHeroEatHPItem1: Integer;
    nHeroEatMPItem1: Integer;

    boUseFlyItem: Boolean;
    boUseReturnItem: Boolean;
    boNoRedReturn: Boolean;

    nUseflyItemMinHP: Integer;
    nExitGameMinHP: Integer;
    nUseReturnItemMinHP: Integer;

    boHeroTakeback: Boolean;
    nTakeBackHeroMinHP: Integer;

    boCreateGroupKey: Boolean;
    boHumStateKey: Boolean;
    boGetHumBagItems: Boolean;
    boRecallHeroKey: Boolean;
    boHeroGroupKey: Boolean;
    boHeroTargetKey: Boolean;
    boHeroGuardKey: Boolean;
    boHeroStateKey: Boolean;
    boHumGetBagItemsKey: Boolean;

    nCreateGroupKey: Integer;
    nHumStateKey: Integer;
    nGetHumBagItems: Integer;
    nRecallHeroKey: Integer;
    nHeroGroupKey: Integer;
    nHeroTargetKey: Integer;
    nHeroGuardKey: Integer;
    nHeroStateKey: Integer;
    nHumGetBagItemsKey: Integer;

    nShowOptionKey: Integer;

    sMoveCmd: string;
    dwMoveTime: Integer;

    boHumUseMagic: Boolean;
    boHeroUseMagic: Boolean;
    nHumMagicIndex: Integer;
    nHeroMagicIndex: Integer;
    nHumUseMagicTime: Integer;
    nHeroUseMagicTime: Integer;

    boHeroStateChange: Boolean;
    nHeroStateChangeIndex: Integer;

    boAutoAnswer: Boolean;
    sAnswerMsg: string;
    boAutoSay: Boolean;
    nAutoSayTime: Integer;

    boAutoQueryBagItem: Boolean;
    nAutoQueryBagItemTime: Integer;

    boFastEatItem: Boolean;

    boFilterShowItem: Boolean;
    boMagicLock: Boolean;

    boAutoUseItem:Boolean;
    sAutoUseItem: string;
    nAutoUseItem:Integer;
  end;
  pTConfig = ^TConfig;


  TFileItemDB = class
    m_Header: TDBHeader;
    m_DeleteList: TList;
    m_ShowItemList: TList;
    m_HintItemList: TList;
    m_sDBFileName: string;
    m_FileStream: TFileStream;
    m_boLoadOK: Boolean;
  private

  public
    constructor Create();
    destructor Destroy; override;
    function Find(sItemName: string): pTShowItem;
    procedure Get(ItemType: TItemType; var ItemList: TList);
    function Add(ShowItem: pTShowItem): Boolean;
    procedure AddHint(DropItem: pTDropItem);
    procedure Hint(); overload;
    procedure Hint(DropItem: pTDropItem); overload;
    procedure Delete(sItemName: string);
    procedure LoadList(const sFileName: string);
    procedure SaveToFile();
  end;
  TFileBossDB = class
    m_Header: TDBHeader;
    m_DeleteList: TList;
    m_ShowBossList: TList;
    m_HintBossList: TList;
    m_sDBFileName: string;
    m_FileStream: TFileStream;
    m_boLoadOK: Boolean;
  private

  public
    constructor Create();
    destructor Destroy; override;
    function Find(sBossName: string): pTShowBoss;
    function Add(ShowBoss: pTShowBoss): Boolean;
    procedure AddHintActor(Actor: TObject);
    procedure Hint(); overload;
    procedure Hint(Actor: TObject); overload;
    procedure Delete(sBossName: string);
    procedure LoadList(const sFileName: string);
    procedure SaveToFile();
  end;

const
  c_Black = 0;
  c_White = 255;
  c_Red = 249;
  c_Green = 2;
  c_Lime = 250;
  c_Yellow = 251;
  c_Blue = 252;
  c_Fuchsia = 253;
{$IF USERVERSION = 0}
  g_sCaption = '飞尔世界'; //
  g_nCaption = 90728695;
  g_sHintMsg = '6sOOK3Pap+sRUww1NDoA4nJi0uCCQv9jCEMSPU5qkqJdBU2bDSXDWJokDxtumW6q2P1zWA8NiPc='; //欢迎使用飞尔世界外挂，http://Www.CqFir.Net！！！
  g_nHintMsg = 17439053;
{$IFEND}

{$IF USERVERSION = 1}
  g_sCaption = '89945英雄合击外挂'; //
  g_nCaption = 156800914;
  g_sHintMsg = 'uXxJh+wq36wC2E9k6YrG1jsRQEDzxvAcSga5e45Scw3806rXYGt3vWYmnttAmv3dsxm3k2wShswZIw6QOQ=='; //欢迎使用89945英雄合击外挂，http://www.89945.com！！！
  g_nHintMsg = 112713085;
{$IFEND}

{$IF USERVERSION = 2}
  g_sCaption = 'SF138英雄合击外挂'; //
  g_nCaption = 3993426;
  g_sHintMsg = 'OK1QSboyc0QGIkqq0eeERiH3PagbJ58sTeIGs8KeslRBQ96xrLzcvfqi2q6rSZSXZGzpsuwI6pbt11SdnQ=='; //欢迎使用Sf138无敌合击外挂，http://Www.Sf138.Com！！！
  g_nHintMsg = 22624845;
{$IFEND}

{$IF USERVERSION = 3}
  g_sCaption = '找变态合击外挂尽在www.sf898.com'; //
  g_nCaption = 112394077;
  g_sHintMsg = 'lhn39lD6olAS6avYZHv8rSOghEVdLomtsDvzzDOREMxXkm2AisGYuFAPqkQlNRUm3kfliGk='; //欢迎使用飞速英雄合击外挂，www.sf898.com！！！
  g_nHintMsg = 204687741;
{$IFEND}

{$IF USERVERSION = 4}
  g_sCaption = '及时雨英雄外挂'; //
  g_nCaption = 43620290;
  g_sHintMsg = '14O5uRePggNUVRCfJCR8Ez4oxkxlly3EU5qFpwgWurPA8ipud3JkQzJEAEvN814S2OPF'; //欢迎使用及时雨英雄外挂，www.17113.com！！！
  g_nHintMsg = 248928726;
{$IFEND}

{$IF USERVERSION = 5}
  g_sCaption = '一滴血英雄合击外挂'; //
  g_nCaption = 28030162;
  g_sHintMsg = 'ahfAkowllfAlB5FyxOXEJ3zaNXGJ41ovkEjaLiLZ4KhYV03MPUrjDQq6P7YjC9mA1J9VpGVwBQ=='; //欢迎使用一滴血英雄合击外挂，www.941ss.com！！！
  g_nHintMsg = 81226605;
{$IFEND}

{$IF USERVERSION = 6}
  g_sCaption = '零血不死合击外挂'; //
  g_nCaption = 5882530;
  g_sHintMsg = 'y7kEyVjJWO4Gtq6R9OY0eaWla4f/PhFmr0cXbk5aQd6T1gm62auzaagMMQAPLTyApmkZOQ=='; //欢迎使用零血不死合击外挂，www.941ss.com！！！
  g_nHintMsg = 267091421;
{$IFEND}

{$IF USERVERSION = 7}
  g_sCaption = '好传奇合击外挂'; //
  g_nCaption = 91022450;
  g_sHintMsg = 'apuN0CZVmjM0Lu2NrS5rzGVWfccSGSlwidWVSop7CbSBeROkFURViehxiB38EzbQ9AVCOJXZrm7vyQ=='; //欢迎使用零血不死合击外挂，www.941ss.com！！！
  g_nHintMsg = 97783373;
{$IFEND}

{$IF USERVERSION = 10}
  g_sCaption = '飞尔世界'; //
  g_nCaption = 90728695;
  g_sHintMsg = 'd88H+tDvhY7+MTHSvJ2kKtWZRgeHrEjNuybEcdtxlIuuSRTCed8xd98FuNSVpvzOnabQSsqDdoc='; //欢迎使用飞尔世界外挂，http://www.941yx.com！！！
  g_nHintMsg = 260418797;
{$IFEND}
var
  g_dwDizzyDelayStart: LongWord;
  g_dwDizzyDelayTime: Integer = 1000;
  g_boAttackSlow: Boolean = True;
  g_boMoveSlow: Boolean = True;
  g_nItemSpeed: Integer = 1;
  g_boMapMoving: Boolean;
  g_boServerChanging: Boolean;

function GetNextDirection(sx, sY, dx, dy: Integer): Byte;
function GetBack(dir: Integer): Integer;
procedure GetBackPosition(sx, sY, dir: Integer; var NewX, NewY: Integer);
procedure GetFrontPosition(sx, sY, dir: Integer; var NewX, NewY: Integer); overload;
procedure GetFrontPosition(sx, sY, dir, nFlag: Integer; var NewX, NewY: Integer); overload;
function GetJobName(nJob: Integer): string;
function GetSexName(nSex: Integer): string;
function BooleanToStr(boBool: Boolean): string;
function GetItemType(ItemType: TItemType): string;
function GetActorDir(nX, nY: Integer): string;

implementation
uses Common, ObjActor;

function GetNextDirection(sx, sY, dx, dy: Integer): Byte;
var
  flagx, flagy: Integer;
begin
  Result := DR_DOWN;
  if sx < dx then flagx := 1
  else if sx = dx then flagx := 0
  else flagx := -1;
  if abs(sY - dy) > 2
    then if (sx >= dx - 1) and (sx <= dx + 1) then flagx := 0;

  if sY < dy then flagy := 1
  else if sY = dy then flagy := 0
  else flagy := -1;
  if abs(sx - dx) > 2 then if (sY > dy - 1) and (sY <= dy + 1) then flagy := 0;

  if (flagx = 0) and (flagy = -1) then Result := DR_UP;
  if (flagx = 1) and (flagy = -1) then Result := DR_UPRIGHT;
  if (flagx = 1) and (flagy = 0) then Result := DR_RIGHT;
  if (flagx = 1) and (flagy = 1) then Result := DR_DOWNRIGHT;
  if (flagx = 0) and (flagy = 1) then Result := DR_DOWN;
  if (flagx = -1) and (flagy = 1) then Result := DR_DOWNLEFT;
  if (flagx = -1) and (flagy = 0) then Result := DR_LEFT;
  if (flagx = -1) and (flagy = -1) then Result := DR_UPLEFT;
end;

function GetBack(dir: Integer): Integer;
begin
  Result := DR_UP;
  case dir of
    DR_UP: Result := DR_DOWN;
    DR_DOWN: Result := DR_UP;
    DR_LEFT: Result := DR_RIGHT;
    DR_RIGHT: Result := DR_LEFT;
    DR_UPLEFT: Result := DR_DOWNRIGHT;
    DR_UPRIGHT: Result := DR_DOWNLEFT;
    DR_DOWNLEFT: Result := DR_UPRIGHT;
    DR_DOWNRIGHT: Result := DR_UPLEFT;
  end;
end;

procedure GetBackPosition(sx, sY, dir: Integer; var NewX, NewY: Integer);
begin
  NewX := sx;
  NewY := sY;
  case dir of
    DR_UP: NewY := NewY + 1;
    DR_DOWN: NewY := NewY - 1;
    DR_LEFT: NewX := NewX + 1;
    DR_RIGHT: NewX := NewX - 1;
    DR_UPLEFT: begin
        NewX := NewX + 1;
        NewY := NewY + 1;
      end;
    DR_UPRIGHT: begin
        NewX := NewX - 1;
        NewY := NewY + 1;
      end;
    DR_DOWNLEFT: begin
        NewX := NewX + 1;
        NewY := NewY - 1;
      end;
    DR_DOWNRIGHT: begin
        NewX := NewX - 1;
        NewY := NewY - 1;
      end;
  end;
end;

procedure GetFrontPosition(sx, sY, dir: Integer; var NewX, NewY: Integer);
begin
  NewX := sx;
  NewY := sY;
  case dir of
    DR_UP: NewY := NewY - 1;
    DR_DOWN: NewY := NewY + 1;
    DR_LEFT: NewX := NewX - 1;
    DR_RIGHT: NewX := NewX + 1;
    DR_UPLEFT: begin
        NewX := NewX - 1;
        NewY := NewY - 1;
      end;
    DR_UPRIGHT: begin
        NewX := NewX + 1;
        NewY := NewY - 1;
      end;
    DR_DOWNLEFT: begin
        NewX := NewX - 1;
        NewY := NewY + 1;
      end;
    DR_DOWNRIGHT: begin
        NewX := NewX + 1;
        NewY := NewY + 1;
      end;
  end;
end;

procedure GetFrontPosition(sx, sY, dir, nFlag: Integer; var NewX, NewY: Integer);
begin
  NewX := sx;
  NewY := sY;
  case dir of
    DR_UP: NewY := NewY - nFlag;
    DR_DOWN: NewY := NewY + nFlag;
    DR_LEFT: NewX := NewX - nFlag;
    DR_RIGHT: NewX := NewX + nFlag;
    DR_UPLEFT: begin
        NewX := NewX - nFlag;
        NewY := NewY - nFlag;
      end;
    DR_UPRIGHT: begin
        NewX := NewX + nFlag;
        NewY := NewY - nFlag;
      end;
    DR_DOWNLEFT: begin
        NewX := NewX - nFlag;
        NewY := NewY + nFlag;
      end;
    DR_DOWNRIGHT: begin
        NewX := NewX + nFlag;
        NewY := NewY + nFlag;
      end;
  end;
end;

//取得职业名称
//0 武士
//1 魔法师
//2 道士

function GetJobName(nJob: Integer): string;
begin
  Result := '';
  case nJob of
    0: Result := '战士';
    1: Result := '法师';
    2: Result := '道士';
  else
    begin
      Result := '未知';
    end;
  end;
end;

function GetSexName(nSex: Integer): string;
begin
  case nSex of
    0: Result := '男';
    1: Result := '女';
  end;
end;

function BooleanToStr(boBool: Boolean): string;
begin
  if boBool then Result := '√' else Result := '';
end;

function GetItemType(ItemType: TItemType): string;
begin
  case ItemType of
    i_HPMPDurg: Result := '药品';
    i_Weapon: Result := '武器';
    i_Dress: Result := '衣服';
    i_Helmet: Result := '头盔';
    i_Jewelry: Result := '首饰';
    i_Other: Result := '其它';
  end;
end;

function GetActorDir(nX, nY: Integer): string;
var
  ndir: Integer;
begin
  ndir := GetNextDirection(GameEngine.m_MySelf.m_nCurrX, GameEngine.m_MySelf.m_nCurrY, nX, nY);
  case ndir of
    DR_UP: Result := '↑';
    DR_UPRIGHT: Result := '↗';
    DR_RIGHT: Result := '→';
    DR_DOWNRIGHT: Result := '↘';
    DR_DOWN: Result := '↓';
    DR_DOWNLEFT: Result := '↙';
    DR_LEFT: Result := '←';
    DR_UPLEFT: Result := '↖';
  end;
end;

function GetActorDir2(nX, nY: Integer): string;
var
  ndir: Integer;
begin
  ndir := GetNextDirection(GameEngine.m_MySelf.m_nCurrX, GameEngine.m_MySelf.m_nCurrY, nX, nY);
  case ndir of
    DR_UP: Result := '上';
    DR_UPRIGHT: Result := '右上';
    DR_RIGHT: Result := '右';
    DR_DOWNRIGHT: Result := '右下';
    DR_DOWN: Result := '下';
    DR_DOWNLEFT: Result := '左下';
    DR_LEFT: Result := '左';
    DR_UPLEFT: Result := '左上';
  end;
end;

constructor TFileBossDB.Create();
begin
  m_sDBFileName := '';
  m_Header := 0;
  m_ShowBossList := TList.Create;
  m_HintBossList := TList.Create;
  m_DeleteList := TList.Create;
  m_FileStream := nil;
  m_boLoadOK := False;
end;

destructor TFileBossDB.Destroy;
var
  I: Integer;
begin
  for I := 0 to m_ShowBossList.Count - 1 do begin
    if m_ShowBossList.Items[I] <> nil then
      Dispose(m_ShowBossList.Items[I]);
  end;
  for I := 0 to m_HintBossList.Count - 1 do begin
    Dispose(m_HintBossList.Items[I]);
  end;
  m_ShowBossList.Free;
  m_HintBossList.Free;
  m_DeleteList.Free;
  if m_FileStream <> nil then m_FileStream.Free;

  inherited;
end;

procedure TFileBossDB.LoadList(const sFileName: string);
var
  nIndex: Integer;
  DBHeader: TDBHeader;
  DBRecord: pTShowBoss;
begin
  for nIndex := 0 to m_ShowBossList.Count - 1 do begin
    Dispose(m_ShowBossList.Items[nIndex]);
  end;
  m_ShowBossList.Clear;
  m_sDBFileName := sFileName;
  if m_FileStream = nil then begin
    FileSetAttr(m_sDBFileName, 0);
    try
      if FileExists(m_sDBFileName) then begin
        m_FileStream := TFileStream.Create(m_sDBFileName, fmOpenReadWrite or fmShareDenyNone);
      end else begin
        m_FileStream := TFileStream.Create(m_sDBFileName, fmOpenReadWrite or fmShareDenyNone or fmCreate);
      end;
      m_boLoadOK := True;
    except
      Exit;
    end;
  end;

  if m_boLoadOK then begin
    try
      m_FileStream.Seek(0, soBeginning);
      m_FileStream.Read(DBHeader, SizeOf(TDBHeader));
      for nIndex := 0 to DBHeader - 1 do begin
        New(DBRecord);
        FillChar(DBRecord^, SizeOf(TShowBoss), #0);
        if m_FileStream.Read(DBRecord^, SizeOf(TShowBoss)) = 0 then begin
          Dispose(DBRecord);
          break;
        end;
        m_ShowBossList.Add(DBRecord);
      end;
    except

    end;
  end;
end;

procedure TFileBossDB.SaveToFile();
var
  DBRecord: pTShowBoss;
  ShowBoss: TShowBoss;
  I: Integer;
begin
  //if FileExists(m_sDBFileName) then DeleteFile(PChar(m_sDBFileName));
  if not m_boLoadOK then Exit;
  try
    m_FileStream.Seek(0, soBeginning);
    m_Header := m_ShowBossList.Count;
    m_FileStream.Write(m_Header, SizeOf(TDBHeader));
    for I := 0 to m_ShowBossList.Count - 1 do begin
      DBRecord := pTShowBoss(m_ShowBossList.Items[I]);
      if m_FileStream.Write(DBRecord^, SizeOf(TShowBoss)) = 0 then begin
        break;
      end;
    end;
    m_FileStream.Size := SizeOf(TShowBoss) * m_Header + SizeOf(TDBHeader);
  except

  end;
end;

procedure TFileBossDB.Delete(sBossName: string);
var
  DBRecord: pTShowBoss;
  I: Integer;
begin
  for I := 0 to m_ShowBossList.Count - 1 do begin
    if m_ShowBossList.Items[I] <> nil then begin
      DBRecord := pTShowBoss(m_ShowBossList.Items[I]);
      if CompareText(DBRecord.sBossName, sBossName) = 0 then begin
        m_ShowBossList.Delete(I);
        Dispose(DBRecord);
        Break;
      end;
    end;
  end;
end;

function TFileBossDB.Add(ShowBoss: pTShowBoss): Boolean;
var
  Index: Integer;
begin
  Result := False;
  if Find(ShowBoss.sBossName) <> nil then Exit;
  m_ShowBossList.Add(ShowBoss);
  Result := True;
end;

function TFileBossDB.Find(sBossName: string): pTShowBoss;
var
  DBRecord: pTShowBoss;
  I: Integer;
begin
  Result := nil;
  for I := 0 to m_ShowBossList.Count - 1 do begin
    if m_ShowBossList.Items[I] <> nil then begin
      DBRecord := pTShowBoss(m_ShowBossList.Items[I]);
      if CompareText(DBRecord.sBossName, sBossName) = 0 then begin
        Result := DBRecord;
        Break;
      end;
    end;
  end;
end;

procedure TFileBossDB.AddHintActor(Actor: TObject);
var
  I: Integer;
  HintBoss: pTHintBoss;
begin
  for I := 0 to m_HintBossList.Count - 1 do begin
    if Actor = pTHintBoss(m_HintBossList.Items[I]).Actor then Exit;
  end;
  New(HintBoss);
  HintBoss.boHint := False;
  HintBoss.Actor := Actor;
  m_HintBossList.Add(HintBoss);
end;


procedure TFileBossDB.Hint(Actor: TObject);
var
  I: Integer;
  HintBoss: pTHintBoss;
  ndir, nCurrX, nCurrY, nX, nY: Integer;
  sHint, sName, sPosition: string;
  ShowBoss: pTShowBoss;
begin
  sName := TActor(Actor).m_sUserName;
  ShowBoss := Find(sName);
  if (ShowBoss <> nil) and ShowBoss.boHintMsg then begin
    nX := TActor(HintBoss.Actor).m_nCurrX;
    nY := TActor(HintBoss.Actor).m_nCurrY;
    nCurrX := GameEngine.m_MySelf.m_nCurrX;
    nCurrY := GameEngine.m_MySelf.m_nCurrY;
    sHint := '[' + sName + ']已经出现，方位:' + { GetActorDir2(nX, nY) + } GetActorDir(nX, nY) + '，坐标:(' + Format('%d,%d', [nX, nY]) + ').';
    GameEngine.AddChatBoardString(sHint, c_Yellow, c_Red);
  end;
end;


procedure TFileBossDB.Hint();
  function IsValidActor(Actor: TObject): Boolean;
  var
    I: Integer;
    ActorList: TList;
  begin
    Result := False;
    for I := 0 to GameEngine.m_ActorList.Count - 1 do begin
      if (GameEngine.m_ActorList.Items[I] = Actor) then begin
        Result := True;
        Break;
      end;
    end;
  end;
var
  I: Integer;
  HintBoss: pTHintBoss;
  Actor: TActor;
  ndir, nCurrX, nCurrY, nX, nY: Integer;
  sHint, sName, sPosition: string;
  ShowBoss: pTShowBoss;
begin
  for I := m_HintBossList.Count - 1 downto 0 do begin
    HintBoss := pTHintBoss(m_HintBossList.Items[I]);
    if not GameEngine.IsValidActor(TActor(HintBoss.Actor)) then begin
    //if not IsValidActor(HintBoss.Actor) then begin
      m_HintBossList.Delete(I);
      Dispose(HintBoss);
      Continue;
    end;
    if not HintBoss.boHint then begin
      HintBoss.boHint := True;
      sName := TActor(HintBoss.Actor).m_sUserName;
      ShowBoss := Find(sName);
      if (ShowBoss <> nil) and ShowBoss.boHintMsg then begin
        nX := TActor(HintBoss.Actor).m_nCurrX;
        nY := TActor(HintBoss.Actor).m_nCurrY;
        nCurrX := GameEngine.m_MySelf.m_nCurrX;
        nCurrY := GameEngine.m_MySelf.m_nCurrY;
        sHint := '[' + sName + ']已经出现，方位:' + { GetActorDir2(nX, nY) + } GetActorDir(nX, nY) + '，坐标:(' + Format('%d,%d', [nX, nY]) + ').';
        GameEngine.AddChatBoardString(sHint, c_Yellow, c_Red);
      end;
    end;
  end;
end;

constructor TFileItemDB.Create();
begin
  m_sDBFileName := '';
  m_Header := 0;
  m_ShowItemList := TList.Create;
  m_HintItemList := TList.Create;
  m_FileStream := nil;
  m_boLoadOK := False;
end;

destructor TFileItemDB.Destroy;
var
  I: Integer;
begin
  for I := 0 to m_ShowItemList.Count - 1 do begin
    Dispose(m_ShowItemList.Items[I]);
  end;
  m_ShowItemList.Free;
  for I := 0 to m_HintItemList.Count - 1 do begin
    Dispose(m_HintItemList.Items[I]);
  end;
  m_HintItemList.Free;
  if m_FileStream <> nil then m_FileStream.Free;

  inherited;
end;

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

procedure TFileItemDB.LoadList(const sFileName: string);
var
  nIndex: Integer;
  DBHeader: TDBHeader;
  DBRecord: pTShowItem;
begin
  for nIndex := 0 to m_ShowItemList.Count - 1 do begin
    Dispose(m_ShowItemList.Items[nIndex]);
  end;
  m_ShowItemList.Clear;

  m_sDBFileName := sFileName;
  if m_FileStream = nil then begin
    FileSetAttr(m_sDBFileName, 0);
    try
      if FileExists(m_sDBFileName) then begin
        m_FileStream := TFileStream.Create(m_sDBFileName, fmOpenReadWrite or fmShareDenyNone);
      end else begin
        m_FileStream := TFileStream.Create(m_sDBFileName, fmOpenReadWrite or fmShareDenyNone or fmCreate);
      end;
      m_boLoadOK := True;
    except
      Exit;
    end;
  end;

  if m_boLoadOK then begin
    try
      m_FileStream.Seek(0, soBeginning);
      m_FileStream.Read(DBHeader, SizeOf(TDBHeader));
      for nIndex := 0 to DBHeader - 1 do begin
        New(DBRecord);
        FillChar(DBRecord^, SizeOf(TShowItem), #0);
        if m_FileStream.Read(DBRecord^, SizeOf(TShowItem)) = 0 then begin
          Dispose(DBRecord);
          break;
        end;
        m_ShowItemList.Add(DBRecord);
      end;
    except

    end;
  end;
end;

procedure TFileItemDB.SaveToFile();
var
  DBRecord: pTShowItem;
  ShowItem: TShowItem;
  I: Integer;
begin
  //if FileExists(m_sDBFileName) then DeleteFile(PChar(m_sDBFileName));
  if not m_boLoadOK then Exit;
  try
    m_FileStream.Seek(0, soBeginning);
    m_Header := m_ShowItemList.Count;
    m_FileStream.Write(m_Header, SizeOf(TDBHeader));
    for I := 0 to m_ShowItemList.Count - 1 do begin
      DBRecord := pTShowItem(m_ShowItemList.Items[I]);
      if m_FileStream.Write(DBRecord^, SizeOf(TShowItem)) = 0 then begin
        break;
      end;
    end;
    m_FileStream.Size := SizeOf(TShowItem) * m_Header + SizeOf(TDBHeader);
  except

  end;
end;

procedure TFileItemDB.Delete(sItemName: string);
var
  DBRecord: pTShowItem;
  I: Integer;
begin
  for I := 0 to m_ShowItemList.Count - 1 do begin
    if m_ShowItemList.Items[I] <> nil then begin
      DBRecord := pTShowItem(m_ShowItemList.Items[I]);
      if CompareText(DBRecord.sItemName, sItemName) = 0 then begin
        m_ShowItemList.Delete(I);
        Dispose(DBRecord);
        Break;
      end;
    end;
  end;
end;

procedure TFileItemDB.Get(ItemType: TItemType; var ItemList: TList);
var
  DBRecord: pTShowItem;
  I: Integer;
begin
  if ItemList = nil then Exit;
  for I := 0 to m_ShowItemList.Count - 1 do begin
    if m_ShowItemList.Items[I] <> nil then begin
      DBRecord := pTShowItem(m_ShowItemList.Items[I]);
      if DBRecord.ItemType = ItemType then begin
        ItemList.Add(DBRecord);
      end;
    end;
  end;
end;

function TFileItemDB.Add(ShowItem: pTShowItem): Boolean;
var
  Index: Integer;
begin
  Result := False;
  if Find(ShowItem.sItemName) <> nil then Exit;
  m_ShowItemList.Add(ShowItem);
  Result := True;
end;

function TFileItemDB.Find(sItemName: string): pTShowItem;
var
  DBRecord: pTShowItem;
  I: Integer;
begin
  Result := nil;
  for I := 0 to m_ShowItemList.Count - 1 do begin
    if m_ShowItemList.Items[I] <> nil then begin
      DBRecord := pTShowItem(m_ShowItemList.Items[I]);
      if CompareText(DBRecord.sItemName, sItemName) = 0 then begin
        Result := DBRecord;
        Break;
      end;
    end;
  end;
end;

procedure TFileItemDB.AddHint(DropItem: pTDropItem);
var
  I: Integer;
  HintItem: pTHintItem;
begin
  for I := 0 to m_HintItemList.Count - 1 do begin
    if pTHintItem(m_HintItemList.Items[I]).DropItem = DropItem then Exit;
  end;
  {if (abs(HintItem.DropItem.X - GameEngine.m_MySelf.m_nCurrX) < 12) and
    (abs(HintItem.DropItem.Y - GameEngine.m_MySelf.m_nCurrY) < 12) then begin   }
  New(HintItem);
  HintItem.boHint := False;
  HintItem.DropItem := DropItem;
  m_HintItemList.Add(HintItem);
  //end;
end;


procedure TFileItemDB.Hint(DropItem: pTDropItem);
var
  Actor: TActor;
  ndir, nCurrX, nCurrY, nX, nY: Integer;
  sHint, sPosition: string;
  ShowItem: pTShowItem;
begin
  ShowItem := Find(DropItem.Name);
  if (ShowItem <> nil) and ShowItem.boHintMsg then begin
    nX := DropItem.X;
    nY := DropItem.Y;
    nCurrX := GameEngine.m_MySelf.m_nCurrX;
    nCurrX := GameEngine.m_MySelf.m_nCurrY;
    sHint := '发现[' + DropItem.Name + ']，方位:' + {GetActorDir2(nX, nY) + } GetActorDir(nX, nY) + '，坐标:(' + Format('%d,%d', [nX, nY]) + ').';
    GameEngine.AddChatBoardString(sHint, c_Yellow, c_Blue);
  end;
end;

procedure TFileItemDB.Hint();
  function IsValidItem(DropItem: pTDropItem): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := 0 to GameEngine.m_DropedItemList.Count - 1 do begin
      if pTDropItem(GameEngine.m_DropedItemList.Items[I]) = DropItem then begin
        Result := True;
        Exit;
      end;
    end;
  end;
var
  I: Integer;
  HintItem: pTHintItem;
  Actor: TActor;
  ndir, nCurrX, nCurrY, nX, nY: Integer;
  sHint, sName, sPosition: string;
  ShowItem: pTShowItem;
begin
  try
    for I := m_HintItemList.Count - 1 downto 0 do begin
      HintItem := pTHintItem(m_HintItemList.Items[I]);
      if (not IsValidItem(HintItem.DropItem)) { or (abs(HintItem.DropItem.X - GameEngine.m_MySelf.m_nCurrX) >= 12) or
        (abs(HintItem.DropItem.Y - GameEngine.m_MySelf.m_nCurrY) >= 12) }then begin
        m_HintItemList.Delete(I);
        Dispose(HintItem);
        Continue;
      end;
      if not HintItem.boHint then begin
        HintItem.boHint := True;
        sName := HintItem.DropItem.Name;
        ShowItem := Find(sName);
        if (ShowItem <> nil) and ShowItem.boHintMsg then begin
          nX := HintItem.DropItem.X;
          nY := HintItem.DropItem.Y;
          nCurrX := GameEngine.m_MySelf.m_nCurrX;
          nCurrX := GameEngine.m_MySelf.m_nCurrY;
          sHint := '发现[' + sName + ']，方位:' + {GetActorDir2(nX, nY) + } GetActorDir(nX, nY) + '，坐标:(' + Format('%d,%d', [nX, nY]) + ').';
          GameEngine.AddChatBoardString(sHint, c_Yellow, c_Blue);
        end;
      end;
    end;
  except

  end;
end;


{ TGList }

constructor TGList.Create;
begin
  inherited;
  InitializeCriticalSection(CriticalSection);
end;

destructor TGList.Destroy;
begin
  DeleteCriticalSection(CriticalSection);
  inherited;
end;

procedure TGList.Lock;
begin
  EnterCriticalSection(CriticalSection);
end;

procedure TGList.UnLock;
begin
  LeaveCriticalSection(CriticalSection);
end;

procedure TGList.Up(Item: Pointer);
var
  nIndex: Integer;
begin
  if Count <= 1 then Exit;
  nIndex := IndexOf(Item);
  if nIndex >= 0 then begin
    if (nIndex - 1 >= 0) and (nIndex - 1 < Count) then begin
      Delete(nIndex);
      Dec(nIndex);
      Insert(nIndex, Item);
    end;
  end;
end;

procedure TGList.Down(Item: Pointer);
var
  nIndex: Integer;
begin
  if Count <= 1 then Exit;
  nIndex := IndexOf(Item);
  if nIndex >= 0 then begin
    if (nIndex + 1 >= 0) and (nIndex + 1 < Count) then begin
      Delete(nIndex);
      Inc(nIndex);
      Insert(nIndex, Item);
    end;
  end;
end;
{ TGStringList }

constructor TGStringList.Create;
begin
  inherited;
  InitializeCriticalSection(CriticalSection);
end;

destructor TGStringList.Destroy;
begin
  DeleteCriticalSection(CriticalSection);
  inherited;
end;

procedure TGStringList.Lock;
begin
  EnterCriticalSection(CriticalSection);
end;

procedure TGStringList.UnLock;
begin
  LeaveCriticalSection(CriticalSection);
end;

procedure TGStringList.Up(AObject: TObject);
var
  nIndex: Integer;
  s: string;
begin
  if Count <= 1 then Exit;
  nIndex := IndexOfObject(AObject);
  if nIndex >= 0 then begin
    if (nIndex - 1 >= 0) and (nIndex - 1 < Count) then begin
      s := Strings[nIndex];
      Delete(nIndex);
      Dec(nIndex);
      InsertObject(nIndex, s, AObject);
    end;
  end;
end;

procedure TGStringList.Down(AObject: TObject);
var
  nIndex: Integer;
  s: string;
begin
  if Count <= 1 then Exit;
  nIndex := IndexOfObject(AObject);
  if nIndex >= 0 then begin
    if (nIndex + 1 >= 0) and (nIndex + 1 < Count) then begin
      s := Strings[nIndex];
      Delete(nIndex);
      Inc(nIndex);
      InsertObject(nIndex, s, AObject);
    end;
  end;
end;

end.

