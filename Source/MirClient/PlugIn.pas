unit PlugIn;

interface
uses
  Windows, Classes, SysUtils, Graphics, Controls, Dialogs, Forms, Grids, Textures, Actor, {DrawScrn, }
  FState, Grobal2, GameImages, DWinCtl, IntroScn, SoundUtil, Share, MShare;

type
  PTObject = ^TObject;

  TShortString = packed record
    btLen: Byte;
    Strings: array[0..High(Byte) - 1] of Char;
  end;
  PTShortString = ^TShortString;

  TServerName = procedure(ShortString: PTShortString); stdcall;
  TSetName = procedure(SelChrName: PAnsiChar); stdcall;

  TOpenHomePage = procedure(HomePage: PAnsiChar); stdcall;


  TSetActiveControl = procedure(Control: TWinControl); stdcall;

  TInitialize = procedure; stdcall;
  TKeyDown = function(Key: Word; Shift: TShiftState): Boolean; stdcall;
  TKeyPress = function(Key: Char): Boolean; stdcall;


  TPlayer = procedure(FileName: PAnsiChar; boShow, boPlay: Boolean); stdcall;
  TPlayerVisible = function: PBoolean; stdcall;

  TSetPlayerAlign = procedure(Align: TAlign); stdcall;
  TSetPlayerParent = procedure(Parent: TWinControl); stdcall;
  TSetPlayerUrl = procedure(AUrl: PAnsiChar); stdcall;

  TStopPlay = procedure(FileName: PAnsiChar); stdcall;
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

    Config: pTConfig;
    ServerName: TServerName;
    SelChrName: TServerName;
    SetSelChrName: TSetName;

    FullScreen: PBoolean;

    ServerConfig: pTServerConfig;
  end;
  pTPlugInfo = ^TPlugInfo;

  TInit = procedure(PlugInfo: pTPlugInfo); stdcall;


  TPlugFileInfo = record
    Module: THandle;
    DllName: string;
    sDesc: string;
  end;
  pTPlugFileInfo = ^TPlugFileInfo;

  TPlugInManage = class
    PlugList: TStringList;
    PlugFileList: TStringList;
  private
    function GetPlug(Module: THandle; sPlugLibFileName: string): Boolean;
  public
    constructor Create();
    destructor Destroy; override;
    procedure LoadPlugIn();
    procedure UnLoadPlugIn();
  end;

  TClientData = record
    PreviousHandle: THandle;
    RunCounter: Integer;
    RunConnt: Integer;
    Handle: array[0..4] of THandle;
    Hooked: array[0..4] of Boolean;
    PlugInfo: array[0..4] of pTPlugInfo;
  end;
  pTClientData = ^TClientData;

procedure PlugInitialize(PlugInfo: pTPlugInfo);
var
  g_PlugInfo: TPlugInfo;
  PlugInManage: TPlugInManage;
  g_ClientData: pTClientData;
implementation
uses ClMain;

constructor TPlugInManage.Create();
begin
  PlugList := TStringList.Create();
  PlugFileList := TStringList.Create();
end;

destructor TPlugInManage.Destroy;
begin
  UnLoadPlugIn();
  PlugList.Free;
  PlugFileList.Free;
  inherited;
end;

function TPlugInManage.GetPlug(Module: THandle; sPlugLibFileName: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to PlugList.Count - 1 do begin
    if (Module = pTPlugFileInfo(PlugList.Objects[I]).Module) or (Comparetext(pTPlugFileInfo(PlugList.Objects[I]).DllName, sPlugLibFileName) = 0) then begin
      Result := True;
      Break;
    end;
  end;
end;

procedure TPlugInManage.LoadPlugIn();
  function DoSearchFile(Path, FType: string; var Files: tstringlist): Boolean;
  var
    Info: TSearchRec;
    s01: string;
    procedure ProcessAFile(FileName: string);
    begin
   {if Assigned(PnlPanel) then
     PnlPanel.Caption := FileName;
   Label2.Caption := FileName;}
    end;
    function IsDir: Boolean;
    begin
      with Info do
        Result := (Name <> '.') and (Name <> '..') and ((Attr and faDirectory) = faDirectory);
    end;
    function IsFile: Boolean;
    begin
      Result := (not ((Info.Attr and faDirectory) = faDirectory)) and ((ExtractFileExt(Info.Name) = '.*') or (CompareText(ExtractFileExt(Info.Name), FType) = 0));
    end;
  begin
    try
    //Files.Clear;
      Result := False;
      if FindFirst(Path + '*.*', faAnyFile, Info) = 0 then begin
     { if IsFile then begin
        s01 := Path + Info.Name;
        Files.Add(s01);
      end; }
        while True do begin
          if IsFile then begin
            s01 := Path + Info.Name;
            Files.Add(s01);
          end;
          Application.ProcessMessages;
          if FindNext(Info) <> 0 then Break;
        end;
      end;
      Result := True;
    finally
      FindClose(Info);
    end;
  end;
var
  I: Integer;
  Init: TInit;
  sPath: string;
  sPlugListFileName: string;
  sPlugLibFileName: string;
  Module: THandle;
  StringList: TStringlist;
  PlugFileInfo: pTPlugFileInfo;
begin
  PlugInitialize(@g_PlugInfo);
  {sPath := ExtractFilePath(Application.ExeName) + 'PlugIn\';
  StringList := TStringlist.Create;
  DoSearchFile(sPath, '.*', StringList); }
  sPlugListFileName := ExtractFilePath(ParamStr(0)) + 'PlugList.txt';

  //Showmessage(PlugFileList.Text);
  if FileExists(sPlugListFileName) then begin
    StringList := TStringlist.Create;
    StringList.LoadFromFile(sPlugListFileName);

    for I := 0 to StringList.Count - 1 do
      PlugFileList.Add(StringList.Strings[I]);

    StringList.Free;
  end;
  //Showmessage(PlugFileList.Text);
  // Showmessage(PlugFileList.Text);
  for I := 0 to PlugFileList.Count - 1 do begin
    sPlugLibFileName := ExtractFilePath(ParamStr(0)) + PlugFileList.Strings[I];
    if FileExists(sPlugLibFileName) then begin
      Module := LoadLibrary(PChar(sPlugLibFileName));
      if Module > 32 then begin
        if GetPlug(Module, sPlugLibFileName) then begin
          FreeLibrary(Module);
          Continue;
        end;
        New(PlugFileInfo);
        PlugFileInfo.Module := Module;
        PlugFileInfo.DllName := sPlugLibFileName;
        Init := GetProcAddress(Module, 'Init');
        if Assigned(@Init) then begin

          Init(@g_PlugInfo);
          PlugList.AddObject('', TObject(PlugFileInfo));
        end else FreeLibrary(Module);
      end else FreeLibrary(Module);
    end;
  end;
end;

procedure TPlugInManage.UnLoadPlugIn();
var
  I: Integer;
  PlugFileInfo: pTPlugFileInfo;
  UnInit: procedure(); stdcall;
begin
  for I := 0 to PlugList.Count - 1 do begin
    PlugFileInfo := pTPlugFileInfo(PlugList.Objects[I]);
    UnInit := GetProcAddress(PlugFileInfo.Module, 'UnInit');
    if @UnInit <> nil then begin
      UnInit();
    end;
    FreeLibrary(PlugFileInfo.Module);
    Dispose(PlugFileInfo);
  end;
  PlugList.Clear;
end;


function _KeyDown(Key: Word; Shift: TShiftState): Boolean; stdcall;
var
  nKey: Word;
begin
  nKey := Key;
    frmMain.FormKeyDown(nil, nKey, Shift);
end;

function _KeyPress(Key: Char): Boolean; stdcall;
var
  nKey: Char;
begin
  nKey := Key;
    frmMain.FormKeyPress(nil, nKey);
end;

procedure _ServerName(ShortString: PTShortString); stdcall;
begin
  ShortString.btLen := Length(g_sServerName);
  Move(g_sServerName[1], ShortString.Strings, ShortString.btLen);
end;

procedure _SelChrName(ShortString: PTShortString); stdcall;
begin
  ShortString.btLen := Length(g_sSelChrName);
  Move(g_sServerName[1], ShortString.Strings, ShortString.btLen);
end;

procedure _SetSelChrName(Name: PAnsiChar); stdcall;
begin
  g_sSelChrName := Name;
end;


procedure _Account(ShortString: PTShortString); stdcall;
begin
  ShortString.btLen := Length(frmMain.LoginID);
  if frmMain.LoginID <> '' then
    Move(frmMain.LoginID[1], ShortString.Strings, ShortString.btLen);
end;

procedure _PassWord(ShortString: PTShortString); stdcall;
begin
  ShortString.btLen := Length(frmMain.LoginPasswd);
  if frmMain.LoginPasswd <> '' then
    Move(frmMain.LoginPasswd[1], ShortString.Strings, ShortString.btLen);
end;


procedure PlugInitialize(PlugInfo: pTPlugInfo);
begin
  PlugInfo.HookInitialize := nil;
  PlugInfo.HookInitializeEnd := nil;
  PlugInfo.HookFinalize := nil;
  PlugInfo.HookKeyDown := nil;
  PlugInfo.HookKeyPress := nil;


  PlugInfo.Account := _Account;
  PlugInfo.PassWord := _PassWord;

  PlugInfo.OpenHomePage := nil;
  with PlugInfo.MediaPlayer do begin
    //WindowsMediaPlayer := frmMain.WindowsMediaPlayer;
    Player := nil;
    Visible := nil;
    Play := nil;
    Stop := nil;
    Pause := nil;
    StopPlay := nil;
    Url := nil;
  end;

  PlugInfo.FullScreen := @g_boFullScreen;
  PlugInfo.KeyDown := _KeyDown;
  PlugInfo.KeyPress := _KeyPress;

  PlugInfo.Config := @g_Config;
  PlugInfo.ServerName := _ServerName;
  PlugInfo.SelChrName := _SelChrName;
  PlugInfo.SetSelChrName := _SetSelChrName;
  PlugInfo.ServerConfig := @g_ServerConfig;
end;



initialization


finalization

end.

