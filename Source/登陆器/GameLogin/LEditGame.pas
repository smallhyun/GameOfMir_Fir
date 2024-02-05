unit LEditGame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GameShare, RzButton, Main, Mask, ComCtrls, RzBmpBtn,
  jpeg, ExtCtrls;

type
  TfrmEditGame = class(TForm)
    Image: TImage;
    ButtonGameAdd: TRzBmpButton;
    ButtonGameDel: TRzBmpButton;
    ButtonGameSave: TRzBmpButton;
    ButtonGameClose: TRzBmpButton;
    EditServerName: TEdit;
    EditGameAddr: TEdit;
    EditGamePort: TEdit;
    EditNotice: TEdit;
    ButtonGameChange: TRzBmpButton;
    EditAbil: TEdit;
    TreeView: TTreeView;
    procedure ButtonGameAddClick(Sender: TObject);
    procedure ButtonGameDelClick(Sender: TObject);
    procedure ButtonGameSaveClick(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ButtonGameCloseClick(Sender: TObject);
    procedure ButtonGameChangeClick(Sender: TObject);
    procedure TreeViewClick(Sender: TObject);
  private
    SelGameZone: TGameZone;
    { Private declarations }
    procedure LoadListToBox();
  public
    procedure Open();

    { Public declarations }
  end;

var
  frmEditGame: TfrmEditGame;

implementation

uses HUtil32;

{$R *.dfm}

procedure TfrmEditGame.LoadListToBox();
var
  I, II: Integer;
  GameZone: TGameZone;
  ChildGameZone: TGameZone;
  TreeNode: TTreeNode;
  ChildTreeNode: TTreeNode;
begin
  TreeView.Items.Clear;
  for I := 0 to g_LocalGameList.Count - 1 do begin
    GameZone := g_LocalGameList.Items[I];
    if GameZone.Count > 0 then begin
      TreeNode := TreeView.Items.AddObject(nil, GameZone.Caption, GameZone);
      TreeNode.HasChildren := True;
      //TreeNode.EndEdit(False);
      for II := 0 to GameZone.Count - 1 do begin
        ChildGameZone := GameZone.Items[II];
        ChildTreeNode := TreeView.Items.AddChildObject(TreeNode, ChildGameZone.Caption, ChildGameZone);
        //ChildTreeNode.EndEdit(False);
      end;
      ChildTreeNode.Expand(ChildGameZone.Expand);
    end;
  end;
end;

procedure TfrmEditGame.Open();
begin
  SelGameZone := nil;
  EditServerName.Text := '';
  EditGameAddr.Text := '';
  EditGamePort.Text := '7000';
  EditNotice.Text := 'http://';
  EditAbil.Text := '普通区';
  LoadListToBox();
  ShowModal;
end;

procedure TfrmEditGame.ButtonGameAddClick(Sender: TObject);
var
  sShowName, sServerName, sGameIPaddr, sGamePort: string;
  nGamePort: Integer;
  GameZone: TGameZone;

begin
  sShowName := Trim(EditAbil.Text);
  sServerName := Trim(EditServerName.Text);
  sGameIPaddr := Trim(EditGameAddr.Text);
  sGamePort := Trim(EditGamePort.Text);
  nGamePort := Str_ToInt(sGamePort, -1);

  if sServerName = '' then begin
    Application.MessageBox('服务器名称，输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditServerName.SetFocus;
    Exit;
  end;

  if g_LocalGameList.Find(sServerName) or g_GameList.Find(sServerName) then begin
    Application.MessageBox('该服务器已经存在！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditServerName.SetFocus;
    Exit;
  end;

  if sGameIPaddr = '' then begin
    Application.MessageBox('服务器地址，输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditGameAddr.SetFocus;
    Exit;
  end;
  if (nGamePort < 0) or (nGamePort > 65535) then begin
    Application.MessageBox('服务器端口，输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditGamePort.SetFocus;
    Exit;
  end;

  GameZone := TGameZone.Create;
  if sShowName = '' then sShowName := '普通区';
  GameZone.Caption := sServerName;
  GameZone.ServerName := sServerName;
  GameZone.GameHost := sGameIPaddr;
  GameZone.GameIPaddr := sGameIPaddr;
  GameZone.GameIPPort := sGamePort;
  GameZone.NoticeUrl := Trim(EditNotice.Text);
  GameZone.Expand := False;
  GameZone.Encrypt := False;
  GameZone.Owner := g_LocalGameList.Add(sShowName);
  GameZone.Owner.AddChild(GameZone.Caption, GameZone);
  LoadListToBox();
end;

procedure TfrmEditGame.ButtonGameDelClick(Sender: TObject);
var
  nIndex: Integer;
  TreeNode: TTreeNode;
begin
  if SelGameZone = nil then Exit;
  if Application.MessageBox('是否确认删除此游戏？',
    '提示信息',
    MB_YESNO + MB_ICONQUESTION) <> IDYES then Exit;

  g_LocalGameList.DeleteChild(SelGameZone);
  LoadListToBox();
end;

procedure TfrmEditGame.ButtonGameSaveClick(Sender: TObject);
begin
  g_LocalGameList.BeginUpdate(g_sLocalGameListFileName);
  g_LocalGameList.SaveToFile(g_sLocalGameListFileName);
  g_LocalGameList.EndUpdate(g_sLocalGameListFileName);
  frmMain.LoadListToBox();
end;

procedure TfrmEditGame.ImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;

procedure TfrmEditGame.ButtonGameCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEditGame.ButtonGameChangeClick(Sender: TObject);
var
  sShowName,sCaption, sServerName, sGameIPaddr, sGamePort, sHomePage: string;
  nGamePort: Integer;
  GameZone: TGameZone;
begin
  if SelGameZone = nil then Exit;
  GameZone := SelGameZone;
  sShowName := Trim(EditAbil.Text);

  sServerName := Trim(EditServerName.Text);
  sCaption := sServerName;

  sGameIPaddr := Trim(EditGameAddr.Text);
  sGamePort := Trim(EditGamePort.Text);
  nGamePort := Str_ToInt(sGamePort, -1);

  if sServerName = '' then begin
    Application.MessageBox('服务器名称，输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditServerName.SetFocus;
    Exit;
  end;

  if (GameZone.ServerName <> sServerName) and g_GameList.Find(sServerName) then begin
    Application.MessageBox('该服务器已经存在！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditServerName.SetFocus;
    Exit;
  end;

  if sGameIPaddr = '' then begin
    Application.MessageBox('服务器地址，输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditGameAddr.SetFocus;
    Exit;
  end;
  if (nGamePort < 0) or (nGamePort > 65535) then begin
    Application.MessageBox('服务器端口，输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditGamePort.SetFocus;
    Exit;
  end;

  //if sShowName = '' then sShowName := '飞尔专区';
  //g_GameList.DeleteChild(SelGameZone);
  //GameZone := TGameZone.Create;
  //GameZone.ShowName := sServerName;
  GameZone.Caption := sCaption;
  GameZone.ServerName := sServerName;
  GameZone.GameHost := sGameIPaddr;
  GameZone.HomePage := sHomePage;
  GameZone.GameIPaddr := sGameIPaddr;
  GameZone.GameIPPort := sGamePort;
  GameZone.NoticeUrl := Trim(EditNotice.Text);
  GameZone.Expand := False;
  GameZone.Encrypt := False;
  //GameZone.Owner := g_GameList.Add(sShowName);
  //GameZone.Owner.AddChild(GameZone.ServerName, GameZone);
  LoadListToBox();
end;


procedure TfrmEditGame.TreeViewClick(Sender: TObject);
var
  TreeNode: TTreeNode;
begin
  SelGameZone := nil;
  TreeNode := TreeView.Selected;
  if TreeNode.Parent = nil then begin
    //Showmessage('TreeNode.Parent = nil');
    Exit;
  end;
  SelGameZone := TGameZone(TreeNode.Data);
  EditServerName.Text := SelGameZone.ServerName;
  EditGameAddr.Text := SelGameZone.GameHost;
  EditGamePort.Text := SelGameZone.GameIPPort;
  EditNotice.Text := SelGameZone.NoticeUrl;
  EditAbil.Text := SelGameZone.Owner.Caption;
end;

end.

