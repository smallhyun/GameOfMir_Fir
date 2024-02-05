unit ItemEvent;

interface
uses
  Windows, Classes, SysUtils, SyncObjs, ObjBase, Grobal2, SDK, HUtil32, Dialogs;
type
  TItemObject = class(TBaseObject)
    m_wLooks: Word;
    m_btAniCount: Byte;
    m_btReserved: Byte;
    m_nCount: Integer;
    m_OfActorObject: TObject;
    m_DropActorObject: TObject;
    m_dwCanPickUpTick: LongWord;
    m_UserItem: TUserItem;
    m_sName: string[30];

    m_PEnvir: TObject;
    m_boGhost: Boolean; //0x2FC
    m_dwGhostTick: LongWord; //0x300
    m_dwRunTick: LongWord; //0x300
  private

  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run();
    procedure MakeGhost;
  end;

  TItemManager = class(TObject)

  private
    FList: TList;
    FFreeList: TList;
    FProcIDx: Integer;
    function GetItemCount: Integer;
  public
    constructor Create();
    destructor Destroy; override;
    procedure Run();
    procedure AddItem(ItemObject: TItemObject);
    function FindItem(Envir: TObject; ItemObject: TItemObject): TItemObject; overload;
    function FindItem(Envir: TObject; nX, nY: Integer): TItemObject; overload;
    function FindItem(Envir: TObject; nX, nY: Integer; ItemObject: TItemObject): TItemObject; overload;
    function FindItem(Envir: TObject; nX, nY, nRange: Integer; List: TList): Integer; overload;
    property ItemCount: Integer read GetItemCount;
  end;
implementation
uses ObjActor, Envir, M2Share;

constructor TItemObject.Create();
begin
  inherited;
  m_ObjType := t_Item;
  m_sName := '';

  m_wLooks := 0;
  m_btAniCount := 0;
  m_btReserved := 0;
  m_nCount := 0;
  m_OfActorObject := nil;
  m_DropActorObject := nil;
  m_dwCanPickUpTick := 0;

  m_PEnvir := nil;
  m_boGhost := False;
  m_dwGhostTick := 0;
  m_dwRunTick := GetTickCount;
  FillChar(m_UserItem, SizeOf(TUserItem), #0);
end;

destructor TItemObject.Destroy;
begin
  if m_PEnvir <> nil then begin
    TEnvirnoment(m_PEnvir).DeleteFromMap(m_nMapX, m_nMapY, Self);
    m_PEnvir := nil;
  end;
  //g_TestList.Add('Handle:'+IntToStr(Integer(Self))+' TItemObject.Destroy');
  inherited;
end;

procedure TItemObject.Run();
begin
  if not m_boGhost then begin
    if (((GetTickCount - m_dwAddTime) > g_Config.dwClearDropOnFloorItemTime {60 * 60 * 1000}) or
      (m_UserItem.AddValue[0] = 1) and (GetDayCount(m_UserItem.MaxDate, Now) <= 0)) then begin //删除到期装备
      m_boGhost := True;
      m_dwGhostTick := GetTickCount;
    end;
  end;

  if not m_boGhost then begin
    if (m_OfActorObject <> nil) or (m_DropActorObject <> nil) then begin
      if (GetTickCount - m_dwCanPickUpTick) > g_Config.dwFloorItemCanPickUpTime {2 * 60 * 1000} then begin
        m_OfActorObject := nil;
        m_DropActorObject := nil;
      end else begin
        if TActorObject(m_OfActorObject) <> nil then begin
          if TActorObject(m_OfActorObject).m_boGhost then m_OfActorObject := nil;
        end;
        if TActorObject(m_DropActorObject) <> nil then begin
          if TActorObject(m_DropActorObject).m_boGhost then m_DropActorObject := nil;
        end;
      end;
    end;
  end else begin
    if m_PEnvir <> nil then begin
      TEnvirnoment(m_PEnvir).DeleteFromMap(m_nMapX, m_nMapY, Self);
      m_PEnvir := nil;
    end;
  end;
end;

procedure TItemObject.MakeGhost;
begin
  m_boGhost := True;
  m_dwGhostTick := GetTickCount;
  //m_PEnvir := nil;
end;
//------------------------------------------------------------------------------

constructor TItemManager.Create();
begin
  inherited;
  FList := TList.Create;
  FFreeList := TList.Create;
  FProcIDx := 0;
  g_ItemList := FList;
  g_FreeItemList := FFreeList;
  //MainOutMessage('TItemManager.Create');
  //showmessage('TItemManager.Create');
end;

destructor TItemManager.Destroy;
var
  I: Integer;
begin
  //MainOutMessage('TItemManager.Destroy');
  for I := 0 to FList.Count - 1 do begin
    TItemObject(FList.Items[I]).Free;
  end;
  FList.Free;

  for I := 0 to FFreeList.Count - 1 do begin
    TItemObject(FFreeList.Items[I]).Free;
  end;
  FFreeList.Free;

  inherited;
end;

function TItemManager.GetItemCount: Integer;
begin
  Result := FList.Count;
end;

procedure TItemManager.AddItem(ItemObject: TItemObject);
begin
  //MainOutMessage('TItemManager.AddItem');
  FList.Add(ItemObject);
end;

function TItemManager.FindItem(Envir: TObject; ItemObject: TItemObject): TItemObject;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FList.Count - 1 do begin
    if (not TItemObject(FList.Items[I]).m_boGhost) and (TItemObject(FList.Items[I]).m_PEnvir = Envir) and (TItemObject(FList.Items[I]) = ItemObject) then begin
      Result := TItemObject(FList.Items[I]);
      Break;
    end;
  end;
end;

function TItemManager.FindItem(Envir: TObject; nX, nY: Integer): TItemObject;
var
  I: Integer;
  ItemObject: TItemObject;
begin
  Result := nil;
  for I := 0 to FList.Count - 1 do begin
    ItemObject := TItemObject(FList.Items[I]);
    if (not ItemObject.m_boGhost) and (ItemObject.m_PEnvir = Envir) and
      (ItemObject.m_nMapX = nX) and
      (ItemObject.m_nMapY = nY) then begin
      Result := ItemObject;
      Break;
    end;
  end;
end;

function TItemManager.FindItem(Envir: TObject; nX, nY: Integer; ItemObject: TItemObject): TItemObject;
var
  I: Integer;
  AItemObject: TItemObject;
begin
  Result := nil;
  for I := 0 to FList.Count - 1 do begin
    AItemObject := TItemObject(FList.Items[I]);
    if (not AItemObject.m_boGhost) and (AItemObject.m_PEnvir = Envir) and (AItemObject = ItemObject) and
      (ItemObject.m_nMapX = nX) and
      (ItemObject.m_nMapY = nY) then begin
      Result := ItemObject;
      Break;
    end;
  end;
end;

function TItemManager.FindItem(Envir: TObject; nX, nY, nRange: Integer; List: TList): Integer;
var
  I, nCount: Integer;
  ItemObject: TItemObject;
begin
  Result := 0;
  nCount := 0;
  for I := 0 to FList.Count - 1 do begin
    ItemObject := TItemObject(FList.Items[I]);
    if (not ItemObject.m_boGhost) and (ItemObject.m_PEnvir = Envir) and
      (abs(ItemObject.m_nMapX - nX) <= nRange) and
      (abs(ItemObject.m_nMapY - nY) <= nRange) then begin
      Inc(nCount);
      if List <> nil then List.Add(ItemObject);
    end;
  end;
  Result := nCount;
end;

procedure TItemManager.Run();
var
  I, nIdx, nError: Integer;
  ItemObject: TItemObject;
  dwCurTick, dwCheckTime: LongWord;
  boCheckTimeLimit: Boolean;
resourcestring
  sExceptionMsg1 = '[Exception] TItemManager::Run';
  sExceptionMsg2 = '[Exception] TItemManager::Run Free';
begin
  try
    nError := 0;
    boCheckTimeLimit := False;
    dwCheckTime := GetTickCount();
    dwCurTick := GetTickCount();
    nError := 1;
    nIdx := FProcIDx;
    nError := 2;

    nError := 3;
    while True do begin
      nError := 3;
      if FList.Count <= nIdx then Break;
      nError := 4;
      ItemObject := TItemObject(FList.Items[nIdx]);
      nError := 5;
      if (not ItemObject.m_boGhost) and ((GetTickCount - ItemObject.m_dwRunTick) > 250) then begin
        nError := 6;
        //MainOutMessage('ItemObject.Run');
        ItemObject.m_dwRunTick := GetTickCount();
        nError := 7;
        ItemObject.Run();
      end;
      nError := 8;
      if ItemObject.m_boGhost then begin
        nError := 9;
        //MainOutMessage('FFreeList.Add');
        FFreeList.Add(ItemObject);
        FList.Delete(nIdx);
        nError := 10;
        Continue;
      end;
      nError := 11;
      Inc(nIdx);
      nError := 12;
      if (GetTickCount - dwCheckTime) > 10 then begin
        boCheckTimeLimit := True;
        FProcIDx := nIdx;
        Break;
      end;
      nError := 13;
    end; //while True do begin}
    if not boCheckTimeLimit then FProcIDx := 0;
  except
    MainOutMessage(sExceptionMsg1 + ' ' + IntToStr(nError));
  end;

  try
    nError := 14;
    for I := 0 to FFreeList.Count - 1 do begin
      nError := 15;
      ItemObject := TItemObject(FFreeList.Items[I]);
      nError := 16;
      if (GetTickCount - ItemObject.m_dwGhostTick) > 5 * 60 * 1000 then begin
        nError := 17;
        //MainOutMessage('FFreeList.Delete');
        FFreeList.Delete(I);
        nError := 18;
        ItemObject.Free;
        nError := 19;
        break;
      end;
      nError := 20;
    end;
  except
    MainOutMessage(sExceptionMsg2 + ' ' + IntToStr(nError));
  end;
end;

end.
