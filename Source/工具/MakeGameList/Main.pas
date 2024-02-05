unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Share, ExtCtrls, EncryptUnit;

type
  TFrmMain = class(TForm)
    TreeView: TTreeView;
    GroupBox: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    EditServerName: TEdit;
    EditGameAddr: TEdit;
    EditGamePort: TEdit;
    EditNotice: TEdit;
    ButtonGameAdd: TButton;
    ButtonGameDel: TButton;
    ButtonGameSave: TButton;
    EditAbil: TEdit;
    ButtonChg: TButton;
    Label6: TLabel;
    EditHomePage: TEdit;
    CheckBoxEncrypt: TCheckBox;
    CheckBoxExpand: TCheckBox;
    Timer: TTimer;
    Label7: TLabel;
    EditCaption: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ButtonGameAddClick(Sender: TObject);
    procedure ButtonGameDelClick(Sender: TObject);
    procedure ButtonGameSaveClick(Sender: TObject);
    procedure ButtonChgClick(Sender: TObject);
    procedure TreeViewClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    SelGameZone: TGameZone;
    procedure LoadListToBox();
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation
uses HUtil32;
{$R *.dfm}

procedure TFrmMain.ButtonChgClick(Sender: TObject);
var
  sShowName, sCaption, sServerName, sGameIPaddr, sGamePort, sHomePage: string;
  nGamePort: Integer;
  GameZone: TGameZone;
begin
  if SelGameZone = nil then Exit;
  GameZone := SelGameZone;
  sShowName := Trim(EditAbil.Text);
  sCaption := Trim(EditCaption.Text);
  sServerName := Trim(EditServerName.Text);
  sGameIPaddr := Trim(EditGameAddr.Text);
  sGamePort := Trim(EditGamePort.Text);
  nGamePort := Str_ToInt(sGamePort, -1);
  sHomePage := Trim(EditHomePage.Text);
  if sServerName = '' then begin
    Application.MessageBox('服务器名称，输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditServerName.SetFocus;
    Exit;
  end;
  if sCaption = '' then begin
    Application.MessageBox('显示名称，输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditCaption.SetFocus;
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
  GameZone.Expand := CheckBoxExpand.Checked;
  GameZone.Encrypt := CheckBoxEncrypt.Checked;
  //GameZone.Owner := g_GameList.Add(sShowName);
  //GameZone.Owner.AddChild(GameZone.ServerName, GameZone);
  LoadListToBox();
end;

procedure TFrmMain.ButtonGameAddClick(Sender: TObject);
var
  sShowName, sCaption, sServerName, sGameIPaddr, sGamePort, sHomePage: string;
  nGamePort: Integer;
  GameZone: TGameZone;
begin
  sShowName := Trim(EditAbil.Text);
  sCaption := Trim(EditCaption.Text);
  sServerName := Trim(EditServerName.Text);
  sGameIPaddr := Trim(EditGameAddr.Text);
  sGamePort := Trim(EditGamePort.Text);
  nGamePort := Str_ToInt(sGamePort, -1);
  sHomePage := Trim(EditHomePage.Text);
  if sServerName = '' then begin
    Application.MessageBox('服务器名称，输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditServerName.SetFocus;
    Exit;
  end;
  if sCaption = '' then begin
    Application.MessageBox('显示名称，输入不正确！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    EditCaption.SetFocus;
    Exit;
  end;
  if g_GameList.FindCaption(sCaption) then begin
    Application.MessageBox('该游戏区已经存在！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
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
  if sShowName = '' then sShowName := '飞尔专区';
  GameZone.Caption := sCaption;
  GameZone.ServerName := sServerName;
  GameZone.GameHost := sGameIPaddr;
  GameZone.HomePage := sHomePage;
  GameZone.GameIPaddr := sGameIPaddr;
  GameZone.GameIPPort := sGamePort;
  GameZone.NoticeUrl := Trim(EditNotice.Text);
  GameZone.Expand := CheckBoxExpand.Checked;
  GameZone.Encrypt := CheckBoxEncrypt.Checked;

  GameZone.Owner := g_GameList.Add(sShowName);
  GameZone.Owner.InsertChild(0, GameZone.Caption, GameZone);
  LoadListToBox();
end;

procedure TFrmMain.ButtonGameDelClick(Sender: TObject);
var
  nIndex: Integer;
  TreeNode: TTreeNode;
begin
  if SelGameZone = nil then Exit;
  if Application.MessageBox('是否确认删除此游戏？',
    '提示信息',
    MB_YESNO + MB_ICONQUESTION) <> IDYES then Exit;

  g_GameList.DeleteChild(SelGameZone);
  LoadListToBox();
end;

procedure TFrmMain.ButtonGameSaveClick(Sender: TObject);
begin
  g_GameList.BeginUpdate(g_sGameList);
  g_GameList.SaveToFile(g_sGameList);
  g_GameList.EndUpdate(g_sGameList);
  LoadListToBox();
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  g_GameList.Free;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  SelGameZone := nil;
  g_GameList := TGameZone.Create;
  g_sGameList := ExtractFilePath(ParamStr(0)) + 'GameList.txt';
  Timer.Enabled := True;
end;

procedure TfrmMain.LoadListToBox();
var
  I, II: Integer;
  GameZone: TGameZone;
  ChildGameZone: TGameZone;
  TreeNode: TTreeNode;
  ChildTreeNode: TTreeNode;
begin
  TreeView.Items.Clear;
  for I := 0 to g_GameList.Count - 1 do begin
    GameZone := g_GameList.Items[I];
    if GameZone.Count > 0 then begin
      TreeNode := TreeView.Items.AddObject(nil, GameZone.Caption, GameZone);
      TreeNode.HasChildren := True;
      //TreeNode.EndEdit(False);
      for II := 0 to GameZone.Count - 1 do begin
        ChildGameZone := GameZone.Items[II];
        ChildTreeNode := TreeView.Items.AddChildObject(TreeNode, ChildGameZone.Caption, ChildGameZone);
        //TreeNode.Expand(ChildGameZone.Expand);
        //ChildTreeNode.EndEdit(False);
      end;
      ChildTreeNode.Expand(ChildGameZone.Expand);
    end;
  end;
end;

procedure TFrmMain.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;
  g_GameList.LoadFromFile(g_sGameList);
  LoadListToBox();
end;

procedure TFrmMain.TreeViewClick(Sender: TObject);
var
  TreeNode: TTreeNode;
begin
  SelGameZone := nil;
  TreeNode := TreeView.Selected;
  if (TreeNode = nil) or (TreeNode.Parent = nil) then begin
    //Showmessage('TreeNode.Parent = nil');
    Exit;
  end;
  SelGameZone := TGameZone(TreeNode.Data);
  EditCaption.Text := SelGameZone.Caption;
  EditGameAddr.Text := SelGameZone.GameHost;
  EditGamePort.Text := SelGameZone.GameIPPort;

  EditServerName.Text := SelGameZone.ServerName;
  EditNotice.Text := SelGameZone.NoticeUrl;
  EditAbil.Text := SelGameZone.Owner.Caption;

  CheckBoxEncrypt.Checked := SelGameZone.Encrypt;
  CheckBoxExpand.Checked := SelGameZone.Expand;
end;

end.

