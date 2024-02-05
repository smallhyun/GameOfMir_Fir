unit Share;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, ComCtrls,
  IniFiles, StdCtrls, Dialogs;
const
  GAME_PASSWORD = #0#0#0#0#0#0;
type
  TGameZone = class
  private
    FOwner: TGameZone;
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
    procedure SaveToFile(const FileName: string);
    procedure BeginUpdate(const FileName: string);
    procedure EndUpdate(const FileName: string);
    function Add(const sCaption: string): TGameZone;
    procedure AddChild(const sCaption: string; GameZone: TGameZone);
    procedure InsertChild(Index: Integer; const sCaption: string; GameZone: TGameZone);
    procedure Delete(GameZone: TGameZone); overload;
    procedure Delete(Index: Integer); overload;
    procedure DeleteChild(GameZone: TGameZone);
    function IndexOf(const sCaption: string): Integer;
    function Find(const sServerName: string): Boolean;
    function FindCaption(const sCaption: string): Boolean;
    procedure Clear;
    property Owner: TGameZone read FOwner write FOwner;
    property Strings: TStringList read FGameList;
    property Items[Index: Integer]: TGameZone read GetGameZone;
    property Count: Integer read GetCount;
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
  end;
var
  g_GameList: TGameZone;
  g_sGameList: string;
implementation
uses EncryptUnit;

constructor TGameZone.Create();
begin
  inherited;
  FOwner := nil;
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
    //Result := GameZone.IndexOf(ShowName);
  end;
end;

function TGameZone.Find(const sServerName: string): Boolean;
var
  I: Integer;
  GameZone: TGameZone;
begin
  Result := False;
  for I := 0 to Count - 1 do begin
    GameZone := Items[I];
    if CompareText(sServerName, GameZone.ServerName) = 0 then begin
      Result := True;
      Exit;
    end;
    if Result then Exit;
    Result := GameZone.Find(sServerName);
  end;
end;

function TGameZone.FindCaption(const sCaption: string): Boolean;
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
    Result := GameZone.FindCaption(sCaption);
  end;
end;

procedure TGameZone.LoadFromFile(const FileName: string);
var
  I, II: Integer;
  Ini: TIniFile;
  Sections: TStringList;
  GameZone: TGameZone;
  GameOwner: TGameZone;
  ServerCount: Integer;
begin
  Sections := TStringList.Create;
  Ini := TIniFile.Create(FileName);
  Ini.ReadSections(Sections);
  for I := 0 to Sections.Count - 1 do begin
    if Sections.Strings[I] = '' then Continue;
    ServerCount := Ini.ReadInteger(Sections.Strings[I], 'ServerCount', 0);
    if ServerCount > 0 then begin
      GameOwner := Add(Sections.Strings[I]);
      if GameOwner = nil then Continue;
      //Showmessage(Sections.Strings[I]);
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

        if GameZone.Encrypt then begin
          //Showmessage(GameZone.GameHost);
          GameZone.GameHost := DecryptString256(GameZone.GameHost, GAME_PASSWORD);
          GameZone.GameIPPort := DecryptString256(GameZone.GameIPPort, GAME_PASSWORD);
        end;

        GameZone.Owner.AddChild(GameZone.Caption, GameZone);
      end;
    end;
  end;
  Sections.Free;
  Ini.Free;
end;

procedure TGameZone.UnLoad();
var
  I: Integer;
begin
  for I := 0 to FGameList.Count - 1 do begin
    TGameZone(FGameList.Objects[I]).Free;
  end;
  FGameList.Clear;
end;

procedure TGameZone.BeginUpdate(const FileName: string);
begin
  //FFileAttr := FileGetAttr(FileName);
  //FileSetAttr(FileName, 0);
  DeleteFile(FileName);
end;

procedure TGameZone.EndUpdate(const FileName: string);
begin
  //FileSetAttr(FileName, FFileAttr);
end;

procedure TGameZone.SaveToFile(const FileName: string);
var
  I, II: Integer;
  Ini: TIniFile;
  GameZone: TGameZone;
  ChildGameZone: TGameZone;
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
        if ChildGameZone.Encrypt then begin
          //Showmessage(EncryptString256(ChildGameZone.GameHost, IntToStr(GAME_PASSWORD)));
          Ini.WriteString(GameZone.Caption, 'Serveraddr' + IntToStr(II), EncryptString256(ChildGameZone.GameHost, GAME_PASSWORD));
          Ini.WriteString(GameZone.Caption, 'ServerPort' + IntToStr(II), EncryptString256(ChildGameZone.GameIPPort, GAME_PASSWORD));
        end else begin
          Ini.WriteString(GameZone.Caption, 'Serveraddr' + IntToStr(II), ChildGameZone.GameHost);
          Ini.WriteString(GameZone.Caption, 'ServerPort' + IntToStr(II), ChildGameZone.GameIPPort);
        end;
        Ini.WriteString(GameZone.Caption, 'Notice' + IntToStr(II), ChildGameZone.NoticeUrl);
        Ini.WriteString(GameZone.Caption, 'HomePage' + IntToStr(II), ChildGameZone.HomePage);
        Ini.WriteBool(GameZone.Caption, 'Expand' + IntToStr(II), ChildGameZone.Expand);
        Ini.WriteBool(GameZone.Caption, 'Encrypt' + IntToStr(II), ChildGameZone.Encrypt);
      //ChildGameZone.SaveToFile(FileName);
      end;
    end;
  end;
  Ini.Free;
end;

procedure TGameZone.InsertChild(Index: Integer; const sCaption: string; GameZone: TGameZone);
begin
  FGameList.InsertObject(Index, sCaption, TObject(GameZone));
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

