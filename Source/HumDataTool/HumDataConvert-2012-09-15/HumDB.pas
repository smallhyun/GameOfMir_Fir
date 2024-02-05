unit HumDB;

interface
uses
  Windows, Classes, SysUtils, Forms, IniFiles, Share, ShareRecord;
resourcestring
  sDBHeaderDesc = '飞尔世界数据库文件 2012/09/15';
  sDBIdxHeaderDesc = '飞尔世界数据库文件 2012/09/15';
const
  MAX_STATUS_ATTRIBUTE = 12;
  MAXPATHLEN = 255;
  DIRPATHLEN = 80;
  MapNameLen = 16;
  ActorNameLen = 14;
type
  TDBHeader = packed record //Size 124
    sDesc: string[$23]; //0x00    36
    n24: Integer; //0x24
    n28: Integer; //0x28
    n2C: Integer; //0x2C
    n30: Integer; //0x30
    n34: Integer; //0x34
    n38: Integer; //0x38
    n3C: Integer; //0x3C
    n40: Integer; //0x40
    n44: Integer; //0x44
    n48: Integer; //0x48
    n4C: Integer; //0x4C
    n50: Integer; //0x50
    n54: Integer; //0x54
    n58: Integer; //0x58
    nLastIndex: Integer; //0x5C
    dLastDate: TDateTime; //0x60
    nHumCount: Integer; //0x68
    n6C: Integer; //0x6C
    n70: Integer; //0x70
    dUpdateDate: TDateTime; //0x74
  end;
  pTDBHeader = ^TDBHeader;

  TIdxHeader = packed record //Size 124
    sDesc: string[39]; //0x00
    n2C: Integer; //0x2C
    n30: Integer; //0x30
    n34: Integer; //0x34
    n38: Integer; //0x38
    n3C: Integer; //0x3C
    n40: Integer; //0x40
    n44: Integer; //0x44
    n48: Integer; //0x48
    n4C: Integer; //0x4C
    n50: Integer; //0x50
    n54: Integer; //0x54
    n58: Integer; //0x58
    n5C: Integer; //0x5C
    n60: Integer; //0x60  95
    n70: Integer; //0x70  99
    nQuickCount: Integer; //0x74  100
    nHumCount: Integer; //0x78
    nDeleteCount: Integer; //0x7C
    nLastIndex: Integer; //0x80
    dUpdateDate: TDateTime; //0x84
  end;
  pTIdxHeader = ^TIdxHeader;

  TIdxRecord = record
    sChrName: string[15];
    nIndex: Integer;
  end;
  pTIdxRecord = ^TIdxRecord;

  TFileDB = class(TConvertData)
    m_Header: TDBHeader;
    m_MirCharNameList: TQuickList;
    m_NewMirCharNameList: TQuickList;
  private
    function Open(): Boolean;
    function OpenEx(): Boolean;
    procedure Close();
  public
    constructor Create(sFileName: string); override;
    destructor Destroy; override;
    procedure Load; override;
    procedure UnLoad; override;
    procedure Convert(); override;
    procedure SaveToFile(sFileName: string); override;
  end;

implementation

uses HUtil32, Main;

{ TFileDB }

constructor TFileDB.Create(sFileName: string);
begin
  inherited Create(sFileName);
  m_MirCharNameList := TQuickList.Create;
  m_NewMirCharNameList := TQuickList.Create;
end;

destructor TFileDB.Destroy;
begin
  UnLoad();
  m_MirCharNameList.Free;
  m_NewMirCharNameList.Free;
  inherited;
end;

procedure TFileDB.UnLoad();
var
  I: Integer;
begin
  for I := 0 to m_MirCharNameList.Count - 1 do begin
    Dispose(pTOHumDataInfo(m_MirCharNameList.Objects[I]));
  end;
  m_MirCharNameList.Clear;

  for I := 0 to m_NewMirCharNameList.Count - 1 do begin
    Dispose(pTHumDataInfo(m_NewMirCharNameList.Objects[I]));
  end;
  m_NewMirCharNameList.Clear;
end;

procedure TFileDB.Load();
var
  nIndex, nIdx: Integer;
  DBHeader: TDBHeader;
  RecordHeader: TRecordHeader;

  PHumanRCD: pTOHumDataInfo;
  HumanRCD: TOHumDataInfo;
  //DeleteList: TStringList;
begin
  m_nCount := 0;
  m_nPercent := 0;
  //if not m_boConvert then Exit;
  ProcessMessage(Format(sLondData, [g_sFileNames]));
  //DeleteList := TStringList.Create;
  try
    if OpenEx then begin
      FileSeek(m_nFileHandle, 0, 0);
      if FileRead(m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then begin
        m_nCount := DBHeader.nHumCount;
        if m_ProgressBar <> nil then begin
          m_ProgressBar.Max := m_nCount;
          m_ProgressBar.Min := 0;
        end;
        for nIndex := 0 to DBHeader.nHumCount - 1 do begin
          if g_boClose then Break;
          if m_ProgressBar <> nil then m_ProgressBar.Position := nIndex + 1;

          FillChar(HumanRCD, SizeOf(TOHumDataInfo), #0);

          if FileSeek(m_nFileHandle, nIndex * SizeOf(TOHumDataInfo) + SizeOf(TDBHeader), 0) = -1 then begin
            Break;
          end;

          if FileRead(m_nFileHandle, HumanRCD, SizeOf(TOHumDataInfo)) <> SizeOf(TOHumDataInfo) then begin
            Break;
          end;

          if (HumanRCD.Header.sName = '') or HumanRCD.Header.boDeleted then begin
              //DeleteList.Add('Account:' + OHeroHumanRCD.Data.sAccount + ' Name:' + OHeroHumanRCD.Header.sName + ' ChrName:' + OHeroHumanRCD.Data.sChrName);
            Continue;
          end;
            //DeleteList.Add('Account:' + HumanRCD.Data.sAccount + ' Name:' + HumanRCD.Header.sName + ' ChrName:' + HumanRCD.Data.sChrName);
          New(PHumanRCD);
          PHumanRCD^ := HumanRCD;
          m_MirCharNameList.AddObject(PHumanRCD.Data.sChrName, TObject(PHumanRCD));

          Application.ProcessMessages;
          if Application.Terminated then begin
            Close;
            Exit;
          end;
        end;
      end;
    end;
  finally
    Close();
  end;
  ProcessMessage('正在排序，请稍候...');
  m_MirCharNameList.SortString(0, m_MirCharNameList.Count - 1);
  //DeleteList.SaveToFile('Mir.txt');
  //DeleteList.Free;
  //m_MirCharNameList.SaveToFile('Mir.txt');
end;

function TFileDB.Open: Boolean;
begin
  if FileExists(m_sDBFileName) then begin
    m_nFileHandle := FileOpen(m_sDBFileName, fmOpenReadWrite or fmShareDenyNone);
    if m_nFileHandle > 0 then
      FileRead(m_nFileHandle, m_Header, SizeOf(TDBHeader));
  end else begin
    m_nFileHandle := FileCreate(m_sDBFileName);
    if m_nFileHandle > 0 then begin
      m_Header.sDesc := sDBHeaderDesc;
      m_Header.nHumCount := 0;
      m_Header.n6C := 0;
      FileWrite(m_nFileHandle, m_Header, SizeOf(TDBHeader));
    end;
  end;
  if m_nFileHandle > 0 then Result := True
  else Result := False;
end;

procedure TFileDB.Close;
begin
  FileClose(m_nFileHandle);
end;

function TFileDB.OpenEx: Boolean;
var
  DBHeader: TDBHeader;
begin
  m_nFileHandle := FileOpen(m_sDBFileName, fmOpenReadWrite or fmShareDenyNone);
  if m_nFileHandle > 0 then begin
    Result := True;
    if FileRead(m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then
      m_Header := DBHeader;
  end else Result := False;
end;

procedure TFileDB.Convert();
var
  I, II: Integer;
  HumanRCD: pTHumDataInfo;
  OHumanRCD: pTOHumDataInfo;
begin
  ProcessMessage(Format(sConvertData, [g_sFileNames]));

  m_nPercent := 0;
  m_nCount := m_MirCharNameList.Count;
  if m_ProgressBar <> nil then begin
    m_ProgressBar.Max := m_nCount;
    m_ProgressBar.Min := 0;
  end;
  for I := 0 to m_MirCharNameList.Count - 1 do begin
    OHumanRCD := pTOHumDataInfo(m_MirCharNameList.Objects[I]);
    New(HumanRCD);
    FillChar(HumanRCD^, SizeOf(THumDataInfo), #0);
    HumanRCD.Header := OHumanRCD.Header;

    Move(OHumanRCD.Data, HumanRCD.Data,
      SizeOf(TOHumData) - SizeOf(TOHumAddItems) - SizeOf(TStorageItems) - SizeOf(THumMagics) - SizeOf(TBagItems) - SizeOf(THumItems) - SizeOf(TAddByte) - SizeOf(Word) - SizeOf(TNewStatus) - SizeOf(TOQuestFlag));

    Move(OHumanRCD.Data.QuestFlag, HumanRCD.Data.QuestFlag, SizeOf(TOQuestFlag));

    HumanRCD.Data.NewStatus := OHumanRCD.Data.NewStatus; //1失明 2混乱 状态
    HumanRCD.Data.wStatusDelayTime := OHumanRCD.Data.wStatusDelayTime; //失明混乱时间
    HumanRCD.Data.AddByte := OHumanRCD.Data.AddByte;
    HumanRCD.Data.HumItems := OHumanRCD.Data.HumItems; //9格装备 衣服  武器  蜡烛 头盔 项链 手镯 手镯 戒指 戒指
    HumanRCD.Data.BagItems := OHumanRCD.Data.BagItems; //包裹装备
    HumanRCD.Data.HumMagics := OHumanRCD.Data.HumMagics; //魔法
    HumanRCD.Data.StorageItems := OHumanRCD.Data.StorageItems; //仓库物品
    Move(OHumanRCD.Data.HumAddItems, HumanRCD.Data.HumAddItems, SizeOf(TOHumAddItems));

    for II := Low(HumanRCD.Data.HumItems) to High(HumanRCD.Data.HumItems) do
      HumanRCD.Data.HumItems[II].btColor := 251;

    for II := Low(HumanRCD.Data.BagItems) to High(HumanRCD.Data.BagItems) do
      HumanRCD.Data.BagItems[II].btColor := 251;

    for II := Low(HumanRCD.Data.StorageItems) to High(HumanRCD.Data.StorageItems) do
      HumanRCD.Data.StorageItems[II].btColor := 251;

    for II := Low(HumanRCD.Data.HumAddItems) to High(HumanRCD.Data.HumAddItems) do
      HumanRCD.Data.HumAddItems[II].btColor := 251;

    m_NewMirCharNameList.AddObject(m_MirCharNameList.Strings[I], TObject(HumanRCD));
    if m_ProgressBar <> nil then m_ProgressBar.Position := I + 1;
  end;
end;

procedure TFileDB.SaveToFile(sFileName: string);
var
  I: Integer;
  HumanRCD: pTHumDataInfo;
  sOldDBFileName: string;
begin
  if not m_boConvert then Exit;
  //m_NewMirCharNameList.SaveToFile('NewMir.txt');
  ProcessMessage(Format(sSaveToFile, [g_sFileNames]));
  sOldDBFileName := m_sDBFileName;
  try
    m_sDBFileName := sFileName;

    m_nPercent := 0;
    m_nCount := 0;
    if FileExists(m_sDBFileName) then DeleteFile(m_sDBFileName);
    try
      if Open then begin
        m_nCount := m_NewMirCharNameList.Count;
        m_Header.nHumCount := m_NewMirCharNameList.Count;
        FileSeek(m_nFileHandle, 0, 0);
        FileWrite(m_nFileHandle, m_Header, SizeOf(TDBHeader));
        if m_ProgressBar <> nil then begin
          m_ProgressBar.Max := m_nCount;
          m_ProgressBar.Min := 0;
        end;
        for I := 0 to m_NewMirCharNameList.Count - 1 do begin
          if g_boClose then Break;
          HumanRCD := pTHumDataInfo(m_NewMirCharNameList.Objects[I]);
          FileWrite(m_nFileHandle, HumanRCD^, SizeOf(THumDataInfo));
          if Application.Terminated then begin
            Close;
            Exit;
          end;
          if m_ProgressBar <> nil then m_ProgressBar.Position := I + 1;
        end;
      end;
    finally
      Close();
    end;

  finally
    m_sDBFileName := sOldDBFileName;
  end;
end;

end.

