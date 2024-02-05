unit OptionMain;

interface

uses
  windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Common, Grobal, Grobal2, EncryptUnit, StdCtrls, JSocket,
  ComCtrls, Spin, ClFunc, CShare, Share, Buttons, ObjActor;

type
  TfrmOption = class(TForm)
    Timer: TTimer;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    ListViewProtectItem: TListView;
    Label16: TLabel;
    Label4: TLabel;
    ButtonProtectAddItem: TButton;
    ButtonProtectChgItem: TButton;
    ButtonProtectDelItem: TButton;
    ButtonProtectSaveItem: TButton;
    Button3: TButton;
    Label6: TLabel;
    Label10: TLabel;
    Button4: TButton;
    PageControl2: TPageControl;
    TabSheet2: TTabSheet;
    TabSheet7: TTabSheet;
    Memo1: TMemo;
    Memo2: TMemo;
    CheckBoxHumUseHP: TCheckBox;
    EditHumMinHP: TSpinEdit;
    EditHumHPTime: TSpinEdit;
    CheckBoxHumUseMP: TCheckBox;
    EditHumMinMP: TSpinEdit;
    EditHumMPTime: TSpinEdit;
    CheckBoxUseFlyItem: TCheckBox;
    EditUseflyItemMinHP: TSpinEdit;
    CheckBoxExitGame: TCheckBox;
    EditExitGameMinHP: TSpinEdit;
    CheckBoxUseReturnItem: TCheckBox;
    EditUseReturnItemMinHP: TSpinEdit;
    CheckBoxNoRedReturn: TCheckBox;
    CheckBoxCreateGroupKey: TCheckBox;
    ComboBoxCreateGroupKey: TComboBox;
    Button2: TButton;
    ButtonHumOptionSave: TButton;
    TabSheet5: TTabSheet;
    CheckBoxHeroUseHP: TCheckBox;
    EditHeroMinHP: TSpinEdit;
    EditHeroHPTime: TSpinEdit;
    CheckBoxHeroUseMP: TCheckBox;
    EditHeroMinMP: TSpinEdit;
    EditHeroMPTime: TSpinEdit;
    CheckBoxHeroTakeback: TCheckBox;
    EditTakeBackHeroMinHP: TSpinEdit;
    CheckBoxRecallHero: TCheckBox;
    CheckBoxGroupMagic: TCheckBox;
    ComboBoxRecallHero: TComboBox;
    ComboBoxGroupMagic: TComboBox;
    ComboBoxTarget: TComboBox;
    ComboBoxGuard: TComboBox;
    ComboBoxChangeState: TComboBox;
    CheckBoxTarget: TCheckBox;
    CheckBoxGuard: TCheckBox;
    ButtonHeroOptionSave: TButton;
    CheckBoxHumUseHP1: TCheckBox;
    CheckBoxHumUseMP1: TCheckBox;
    EditHumMinHP1: TSpinEdit;
    EditHumMinMP1: TSpinEdit;
    EditHumHPTime1: TSpinEdit;
    EditHumMPTime1: TSpinEdit;
    CheckBoxHeroUseHP1: TCheckBox;
    CheckBoxHeroUseMP1: TCheckBox;
    EditHeroMinHP1: TSpinEdit;
    EditHeroMinMP1: TSpinEdit;
    EditHeroHPTime1: TSpinEdit;
    EditHeroMPTime1: TSpinEdit;
    ComboBoxHumEatHPItem: TComboBox;
    ComboBoxHumEatMPItem: TComboBox;
    ComboBoxHumEatHPItem1: TComboBox;
    ComboBoxHumEatMPItem1: TComboBox;
    ComboBoxHeroEatHPItem: TComboBox;
    ComboBoxHeroEatMPItem: TComboBox;
    ComboBoxHeroEatHPItem1: TComboBox;
    ComboBoxHeroEatMPItem1: TComboBox;
    Button1: TButton;
    Button5: TButton;
    TabSheet6: TTabSheet;
    TabSheet8: TTabSheet;
    ListViewBossList: TListView;
    CheckHintBossXY: TCheckBox;
    EditBossMonName: TEdit;
    ButtonAddBossMon: TButton;
    ButtonDelBossMon: TButton;
    ButtonSaveBossMon: TSpeedButton;
    ComboBoxItemType: TComboBox;
    ListViewItemList: TListView;
    CheckPickUpItem: TCheckBox;
    CheckItemHint: TCheckBox;
    EditItemName: TEdit;
    ButtonDelItem: TButton;
    ButtonAddItem: TButton;
    ButtonSaveItems: TSpeedButton;
    CheckBoxChangeState: TCheckBox;
    CheckBoxHumChangeState: TCheckBox;
    ComboBoxHumChangeState: TComboBox;
    TabSheet9: TTabSheet;
    ComboBoxGetHumBagItems: TComboBox;
    Timer1: TTimer;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    GroupBox: TGroupBox;
    RadioButtonHP: TRadioButton;
    RadioButtonMP: TRadioButton;
    RadioButtonHMP: TRadioButton;
    RadioButtonOther: TRadioButton;
    CheckBoxMovePick: TCheckBox;
    Label7: TLabel;
    EditMoveCmd: TEdit;
    TabSheet10: TTabSheet;
    Label8: TLabel;
    ButtonMapFilterDel: TButton;
    ButtonMapFilterAdd: TButton;
    EditMapFilter: TEdit;
    GroupBox1: TGroupBox;
    ListBoxMapFilter: TListBox;
    ButtonMapFilterSave: TButton;
    StatusBar: TStatusBar;
    Label9: TLabel;
    EditMoveTime: TSpinEdit;
    EditProtectItemName: TComboBox;
    EditProtectUnbindItemName: TComboBox;
    CheckBoxGetHumBagItems: TCheckBox;
    CheckBoxHumUseMagic: TCheckBox;
    ComboBoxHumMagic: TComboBox;
    EditHumUseMagicTime: TSpinEdit;
    Label1: TLabel;
    CheckBoxHeroStateChange: TCheckBox;
    ComboBoxHeroStateChange: TComboBox;
    ButtonBaseSave: TButton;
    TabSheet11: TTabSheet;
    CheckBoxAutoAnswer: TCheckBox;
    AutoAnswerMsg: TComboBox;
    CheckboxAutoSay: TCheckBox;
    Label12: TLabel;
    EditSayMsgTime: TSpinEdit;
    Label13: TLabel;
    ButtonAddSayMsg: TButton;
    EditSayMsg: TEdit;
    ButtonDelSayMsg: TButton;
    ButtonSaveSayMsg: TButton;
    ListBoxSayMsg: TListBox;
    CheckBoxAutoQueryBagItem: TCheckBox;
    EditAutoQueryBagItem: TSpinEdit;
    Label11: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    CheckBoxFastEatItem: TCheckBox;
    TabSheet12: TTabSheet;
    MemoFilterItem: TMemo;
    ButtonSaveFilterItem: TButton;
    CheckBoxFilterItem: TCheckBox;
    TabSheet13: TTabSheet;
    CheckBoxMagicLock: TCheckBox;
    ListBoxMagicLock: TListBox;
    ComboBoxMagicLock: TComboBox;
    ButtonAddMagicLock: TButton;
    ButtonSaveMagicLock: TButton;
    ButtonDelMagicLock: TButton;
    CheckBoxAutoUseItem: TCheckBox;
    ComboBoxAutoUseItem: TComboBox;
    EditAutoUseItem: TSpinEdit;
    Label14: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button3Click(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonProtectAddItemClick(Sender: TObject);
    procedure ButtonProtectChgItemClick(Sender: TObject);
    procedure ButtonProtectDelItemClick(Sender: TObject);
    procedure ButtonProtectSaveItemClick(Sender: TObject);
    procedure ListViewProtectItemClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CheckBoxHumUseHPClick(Sender: TObject);
    procedure CheckBoxHumUseMPClick(Sender: TObject);
    procedure EditHumMinHPChange(Sender: TObject);
    procedure EditHumMinMPChange(Sender: TObject);
    procedure EditHumHPTimeChange(Sender: TObject);
    procedure EditHumMPTimeChange(Sender: TObject);
    procedure EditHeroMinHPChange(Sender: TObject);
    procedure EditHeroMinMPChange(Sender: TObject);
    procedure EditHeroHPTimeChange(Sender: TObject);
    procedure EditHeroMPTimeChange(Sender: TObject);
    procedure CheckBoxUseFlyItemClick(Sender: TObject);
    procedure CheckBoxUseReturnItemClick(Sender: TObject);
    procedure CheckBoxHeroTakebackClick(Sender: TObject);
    procedure EditTakeBackHeroMinHPChange(Sender: TObject);
    procedure CheckBoxRecallHeroClick(Sender: TObject);
    procedure CheckBoxGroupMagicClick(Sender: TObject);
    procedure CheckBoxTargetClick(Sender: TObject);
    procedure CheckBoxGuardClick(Sender: TObject);
    procedure CheckBoxChangeStateClick(Sender: TObject);
    procedure ComboBoxRecallHeroChange(Sender: TObject);
    procedure ButtonHumOptionSaveClick(Sender: TObject);
    procedure CheckBoxHeroUseHPClick(Sender: TObject);
    procedure CheckBoxHeroUseMPClick(Sender: TObject);
    procedure EditUseflyItemMinHPChange(Sender: TObject);
    procedure EditUseReturnItemMinHPChange(Sender: TObject);
    procedure CheckBoxCreateGroupKeyClick(Sender: TObject);
    procedure CheckBoxHumUseHP1Click(Sender: TObject);
    procedure CheckBoxHumUseMP1Click(Sender: TObject);
    procedure EditHumMinHP1Change(Sender: TObject);
    procedure EditHumMinMP1Change(Sender: TObject);
    procedure EditHumHPTime1Change(Sender: TObject);
    procedure EditHumMPTime1Change(Sender: TObject);
    procedure CheckBoxHeroUseHP1Click(Sender: TObject);
    procedure EditHeroHPTime1Change(Sender: TObject);
    procedure EditHeroMPTime1Change(Sender: TObject);
    procedure ComboBoxHumEatHPItemChange(Sender: TObject);
    procedure ComboBoxHeroEatHPItemChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure EditHeroMinHP1Change(Sender: TObject);
    procedure CheckBoxHeroUseMP1Click(Sender: TObject);
    procedure EditHeroMinMP1Change(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListViewBossListClick(Sender: TObject);
    procedure ButtonAddBossMonClick(Sender: TObject);
    procedure ButtonDelBossMonClick(Sender: TObject);
    procedure ButtonSaveBossMonClick(Sender: TObject);
    procedure ListViewItemListClick(Sender: TObject);
    procedure ButtonDelItemClick(Sender: TObject);
    procedure ButtonAddItemClick(Sender: TObject);
    procedure ButtonSaveItemsClick(Sender: TObject);
    procedure CheckItemHintClick(Sender: TObject);
    procedure CheckHintBossXYClick(Sender: TObject);
    procedure CheckBoxHumChangeStateClick(Sender: TObject);
    procedure ComboBoxItemTypeSelect(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ButtonMapFilterDelClick(Sender: TObject);
    procedure ButtonMapFilterAddClick(Sender: TObject);
    procedure ButtonMapFilterSaveClick(Sender: TObject);
    procedure ListBoxMapFilterClick(Sender: TObject);
    procedure EditHumHPTimeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ListBoxMapFilterMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure EditMoveCmdMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure EditMoveTimeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CheckBoxGetHumBagItemsClick(Sender: TObject);
    procedure CheckBoxHumUseMagicClick(Sender: TObject);
    procedure ComboBoxHumMagicSelect(Sender: TObject);
    procedure EditHumUseMagicTimeChange(Sender: TObject);
    procedure CheckBoxHeroStateChangeClick(Sender: TObject);
    procedure ButtonBaseSaveClick(Sender: TObject);
    procedure ComboBoxHeroStateChangeSelect(Sender: TObject);
    procedure CheckBoxAutoAnswerClick(Sender: TObject);
    procedure CheckboxAutoSayClick(Sender: TObject);
    procedure ButtonAddSayMsgClick(Sender: TObject);
    procedure ButtonDelSayMsgClick(Sender: TObject);
    procedure EditSayMsgTimeChange(Sender: TObject);
    procedure ButtonSaveSayMsgClick(Sender: TObject);
    procedure CheckBoxAutoQueryBagItemClick(Sender: TObject);
    procedure EditAutoQueryBagItemChange(Sender: TObject);
    procedure CheckBoxFastEatItemClick(Sender: TObject);
    procedure ButtonSaveFilterItemClick(Sender: TObject);
    procedure CheckBoxFilterItemClick(Sender: TObject);
    procedure MemoFilterItemMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure MemoFilterItemChange(Sender: TObject);
    procedure PageControlMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CheckBoxMagicLockClick(Sender: TObject);
    procedure ButtonAddMagicLockClick(Sender: TObject);
    procedure ButtonSaveMagicLockClick(Sender: TObject);
    procedure ListBoxMagicLockMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ButtonDelMagicLockClick(Sender: TObject);
    procedure CheckBoxAutoUseItemClick(Sender: TObject);
    procedure EditAutoUseItemChange(Sender: TObject);
    procedure ComboBoxAutoUseItemSelect(Sender: TObject);
  private
    { Private declarations }
    function GetItemAttr: Integer;
    procedure SetItemAttr(Attr: Integer);
    procedure RefListViewProtectItem;
    procedure RefKey();
    procedure RefConfig();
    procedure RefEatItem();
    procedure AddItemToView(ShowItem: pTShowItem);
    procedure AddItemToBossView(ShowBoss: pTShowBoss);
  public
    { Public declarations }
    MainHwnd: Hwnd;
    Actor: TObject;
    //procedure Createparams(var Params: TCreateParams); override;
  end;

var
  frmOption: TfrmOption;
  SelShowItem: pTShowItem;
  SelShowBoss: pTShowBoss;

implementation

{$R *.dfm}
{procedure TfrmOption.Createparams(var Params: TCreateParams);
begin
  inherited Createparams(Params);
  with Params do begin
    EXStyle := EXStyle or WS_EX_TOPMOST or WS_EX_ACCEPTFILES; // or WS_EX_ACCEPTFILES    or WS_DLGFRAME
    WndParent := GetDesktopWindow; //关键一行，用SetParent都不行！！
  end;
end;}


procedure TfrmOption.AddItemToView(ShowItem: pTShowItem);
var
  ListItem: TListItem;
begin
  ListViewItemList.Items.BeginUpdate;
  try
    ListItem := ListViewItemList.Items.Add;
    ListItem.Caption := ShowItem.sItemName;
    ListItem.SubItems.AddObject(BooleanToStr(ShowItem.boPickup), TObject(ShowItem));
    ListItem.SubItems.Add(BooleanToStr(ShowItem.boHintMsg));
  finally
    ListViewItemList.Items.EndUpdate;
  end;
end;

procedure TfrmOption.AddItemToBossView(ShowBoss: pTShowBoss);
var
  ListItem: TListItem;
begin
  ListViewBossList.Items.BeginUpdate;
  try
    ListItem := ListViewBossList.Items.Add;
    ListItem.Caption := ShowBoss.sBossName;
    ListItem.SubItems.AddObject(BooleanToStr(ShowBoss.boHintMsg), TObject(ShowBoss));
  finally
    ListViewBossList.Items.EndUpdate;
  end;
end;

procedure TfrmOption.Button2Click(Sender: TObject);
var
  DefMsg: TDefaultMessage;
begin

  DefMsg := MakeDefaultMsg(SM_EAT_OK, 0, 0, 0, 0);
  GameSocket.SendSocket(EncodeMessage(DefMsg));
  //GameSocket.m_boWriteSockText := not GameSocket.m_boWriteSockText;
  //Label5.Caption := IntToStr(GameEngine.m_EatItemFailList.Count);
end;

procedure TfrmOption.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caNone;
  frmOption.Visible := False;
end;

procedure TfrmOption.Button3Click(Sender: TObject);
begin
  {Label6.Caption := GameEngine.m_MyHero.m_sDescUserName + ' ' + GameEngine.m_MyHero.m_sUserName;
  Label10.Caption := 'Level:' + IntToStr(GameEngine.HeroLevel) + #13;
  Label10.Caption := Label10.Caption + 'HP:' + IntToStr(GameEngine.HeroHP) + #13;
  Label10.Caption := Label10.Caption + 'MaxHP:' + IntToStr(GameEngine.HeroMaxHP) + #13;
  Label10.Caption := Label10.Caption + 'MP:' + IntToStr(GameEngine.HeroMP) + #13;
  Label10.Caption := Label10.Caption + 'MaxMP:' + IntToStr(GameEngine.HeroMaxMP) + #13; }

  Label6.Caption := GameEngine.m_MySelf.m_sDescUserName + ' ' + GameEngine.m_MySelf.m_sUserName;
  Label10.Caption := 'Level:' + IntToStr(GameEngine.HumLevel) + #13;
  Label10.Caption := Label10.Caption + 'HP:' + IntToStr(GameEngine.HumHP) + #13;
  Label10.Caption := Label10.Caption + 'MaxHP:' + IntToStr(GameEngine.HumMaxHP) + #13;
  Label10.Caption := Label10.Caption + 'MP:' + IntToStr(GameEngine.HumMP) + #13;
  Label10.Caption := Label10.Caption + 'MaxMP:' + IntToStr(GameEngine.HumMaxMP) + #13;
end;

procedure TfrmOption.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;
  MainHwnd := GetForegroundWindow;
end;

procedure TfrmOption.FormShow(Sender: TObject);
var
  I, II: Integer;
  ListItem: TListItem;
  ShowItem: pTShowItem;
  ShowBoss: pTShowBoss;
  Magic: pTClientMagic;
begin
  if GameEngine.m_btVersion = 0 then begin
    StatusBar.Panels[1].Text := 'BLUE';
  end else begin
    StatusBar.Panels[1].Text := 'IGE';
  end;


  ListViewItemList.Items.Clear;
  ListViewItemList.Items.BeginUpdate;
  try
    for I := 0 to GameEngine.m_ShowItemList.m_ShowItemList.Count - 1 do begin
      //AddItemToView(pTShowItem(GameEngine.m_ShowItemList.m_ShowItemList.Items[I]));
      ShowItem := pTShowItem(GameEngine.m_ShowItemList.m_ShowItemList.Items[I]);
      ListItem := ListViewItemList.Items.Add;
      ListItem.Caption := ShowItem.sItemName;
      ListItem.SubItems.AddObject(BooleanToStr(ShowItem.boPickup), TObject(ShowItem));
      ListItem.SubItems.Add(BooleanToStr(ShowItem.boHintMsg));
      ListItem.SubItems.Add(BooleanToStr(ShowItem.boMovePick));
    end;
  finally
    ListViewItemList.Items.EndUpdate;
  end;

  ListViewBossList.Items.Clear;
  ListViewBossList.Items.BeginUpdate;
  try
    for I := 0 to GameEngine.m_ShowBossList.m_ShowBossList.Count - 1 do begin
      //AddItemToBossView(pTShowBoss(GameEngine.m_ShowBossList.m_ShowBossList.Items[I]));
      ShowBoss := pTShowBoss(GameEngine.m_ShowBossList.m_ShowBossList.Items[I]);
      ListItem := ListViewBossList.Items.Add;
      ListItem.Caption := ShowBoss.sBossName;
      ListItem.SubItems.AddObject(BooleanToStr(ShowBoss.boHintMsg), TObject(ShowBoss));
    end;
  finally
    ListViewBossList.Items.EndUpdate;
  end;
  EditMapFilter.Text := GameEngine.m_sMapTitle;

  ComboBoxAutoUseItem.Clear;
  EditProtectItemName.Clear;
  EditProtectUnbindItemName.Clear;

  case GameEngine.m_btVersion of
    0: begin
        for I := Low(GameEngine.m_ItemArr_BLUE) to High(GameEngine.m_ItemArr_BLUE) do begin
          if GameEngine.m_ItemArr_BLUE[I].s.Name <> '' then begin
            EditProtectItemName.Items.Add(GameEngine.m_ItemArr_BLUE[I].s.Name);
            EditProtectUnbindItemName.Items.Add(GameEngine.m_ItemArr_BLUE[I].s.Name);
            ComboBoxAutoUseItem.Items.Add(GameEngine.m_ItemArr_BLUE[I].s.Name);
          end;
        end;

        EditProtectUnbindItemName.Items.Add('');
        EditProtectItemName.Items.Add('');
        for I := Low(GameEngine.m_HeroUseItems_BLUE) to High(GameEngine.m_HeroUseItems_BLUE) do begin
          if GameEngine.m_HeroUseItems_BLUE[I].s.Name <> '' then begin
            EditProtectItemName.Items.Add(GameEngine.m_HeroUseItems_BLUE[I].s.Name);
            EditProtectUnbindItemName.Items.Add(GameEngine.m_HeroUseItems_BLUE[I].s.Name);
          end;
        end;
      end;
    1: begin
        for I := Low(GameEngine.m_ItemArr_IGE) to High(GameEngine.m_ItemArr_IGE) do begin
          if GameEngine.m_ItemArr_IGE[I].s.Name <> '' then begin
            EditProtectItemName.Items.Add(GameEngine.m_ItemArr_IGE[I].s.Name);
            EditProtectUnbindItemName.Items.Add(GameEngine.m_ItemArr_IGE[I].s.Name);
            ComboBoxAutoUseItem.Items.Add(GameEngine.m_ItemArr_IGE[I].s.Name);
          end;
        end;

        EditProtectUnbindItemName.Items.Add('');
        EditProtectItemName.Items.Add('');
        for I := Low(GameEngine.m_HeroUseItems_IGE) to High(GameEngine.m_HeroUseItems_IGE) do begin
          if GameEngine.m_HeroUseItems_IGE[I].s.Name <> '' then begin
            EditProtectItemName.Items.Add(GameEngine.m_HeroUseItems_IGE[I].s.Name);
            EditProtectUnbindItemName.Items.Add(GameEngine.m_HeroUseItems_IGE[I].s.Name);
          end;
        end;
      end;
  end;
  ComboBoxMagicLock.Items.Clear;
  for I := 0 to GameEngine.m_MagicList.Count - 1 do begin
    Magic := GameEngine.m_MagicList.Items[I];
    ComboBoxMagicLock.Items.Add(Magic.Def.sMagicName);
  end;

  if Actor <> GameEngine.m_MySelf then begin
    Actor := GameEngine.m_MySelf;

    RefListViewProtectItem;
    RefKey();
    RefConfig();

    ButtonProtectChgItem.Enabled := False;
    ButtonProtectDelItem.Enabled := False;
    ButtonProtectSaveItem.Enabled := False;
    ButtonHumOptionSave.Enabled := False;
    ButtonHeroOptionSave.Enabled := False;
    ButtonBaseSave.Enabled := False;
    ButtonSaveSayMsg.Enabled := False;
    ButtonSaveFilterItem.Enabled := False;

    ButtonSaveMagicLock.Enabled := False;
  end;

  Timer.Enabled := True;
end;

procedure TfrmOption.RefKey();
var
  I: Integer;
begin
  ComboBoxRecallHero.Items.Add('');
  for I := 0 to Length(KeyName) - 1 do begin
    ComboBoxRecallHero.Items.Add(KeyName[I]);
  end;
  ComboBoxCreateGroupKey.Items.AddStrings(ComboBoxRecallHero.Items);
  ComboBoxGroupMagic.Items.AddStrings(ComboBoxRecallHero.Items);
  ComboBoxTarget.Items.AddStrings(ComboBoxRecallHero.Items);
  ComboBoxGuard.Items.AddStrings(ComboBoxRecallHero.Items);
  ComboBoxChangeState.Items.AddStrings(ComboBoxRecallHero.Items);
  ComboBoxHumChangeState.Items.AddStrings(ComboBoxRecallHero.Items);
  ComboBoxGetHumBagItems.Items.AddStrings(ComboBoxRecallHero.Items);
end;

procedure TfrmOption.RefEatItem();
var
  I: Integer;
  BindItem: pTBindClientItem;
begin
  ComboBoxHumEatHPItem.Clear;
  ComboBoxHumEatMPItem.Clear;
  ComboBoxHumEatHPItem1.Clear;
  ComboBoxHumEatMPItem1.Clear;
  ComboBoxHeroEatHPItem.Clear;
  ComboBoxHeroEatMPItem.Clear;
  ComboBoxHeroEatHPItem1.Clear;
  ComboBoxHeroEatMPItem1.Clear;
  for I := 0 to GameEngine.m_UnbindItemList.Count - 1 do begin
    BindItem := GameEngine.m_UnbindItemList.Items[I];
    ComboBoxHumEatHPItem.Items.Add(BindItem.sItemName);
    ComboBoxHumEatMPItem.Items.Add(BindItem.sItemName);
    ComboBoxHumEatHPItem1.Items.Add(BindItem.sItemName);
    ComboBoxHumEatMPItem1.Items.Add(BindItem.sItemName);
    ComboBoxHeroEatHPItem.Items.Add(BindItem.sItemName);
    ComboBoxHeroEatMPItem.Items.Add(BindItem.sItemName);
    ComboBoxHeroEatHPItem1.Items.Add(BindItem.sItemName);
    ComboBoxHeroEatMPItem1.Items.Add(BindItem.sItemName);
  end;
  if GameEngine.Config.nHumEatHPItem < 0 then GameEngine.Config.nHumEatHPItem := 2;
  if GameEngine.Config.nHumEatHPItem > GameEngine.m_UnbindItemList.Count - 1 then GameEngine.Config.nHumEatHPItem := GameEngine.m_UnbindItemList.Count - 1;

  if GameEngine.Config.nHumEatMPItem < 0 then GameEngine.Config.nHumEatMPItem := 3;
  if GameEngine.Config.nHumEatMPItem > GameEngine.m_UnbindItemList.Count - 1 then GameEngine.Config.nHumEatHPItem := GameEngine.m_UnbindItemList.Count - 1;

  if GameEngine.Config.nHumEatHPItem1 < 0 then GameEngine.Config.nHumEatHPItem1 := 4;
  if GameEngine.Config.nHumEatHPItem1 > GameEngine.m_UnbindItemList.Count - 1 then GameEngine.Config.nHumEatHPItem := GameEngine.m_UnbindItemList.Count - 1;

  if GameEngine.Config.nHumEatMPItem1 < 0 then GameEngine.Config.nHumEatMPItem1 := 5;
  if GameEngine.Config.nHumEatMPItem1 > GameEngine.m_UnbindItemList.Count - 1 then GameEngine.Config.nHumEatHPItem := GameEngine.m_UnbindItemList.Count - 1;

  if GameEngine.Config.nHeroEatHPItem < 0 then GameEngine.Config.nHeroEatHPItem := 2;
  if GameEngine.Config.nHeroEatHPItem > GameEngine.m_UnbindItemList.Count - 1 then GameEngine.Config.nHeroEatHPItem := GameEngine.m_UnbindItemList.Count - 1;

  if GameEngine.Config.nHeroEatMPItem < 0 then GameEngine.Config.nHeroEatMPItem := 3;
  if GameEngine.Config.nHeroEatMPItem > GameEngine.m_UnbindItemList.Count - 1 then GameEngine.Config.nHeroEatHPItem := GameEngine.m_UnbindItemList.Count - 1;

  if GameEngine.Config.nHeroEatHPItem1 < 0 then GameEngine.Config.nHeroEatHPItem1 := 4;
  if GameEngine.Config.nHeroEatHPItem1 > GameEngine.m_UnbindItemList.Count - 1 then GameEngine.Config.nHeroEatHPItem := GameEngine.m_UnbindItemList.Count - 1;

  if GameEngine.Config.nHeroEatMPItem1 < 0 then GameEngine.Config.nHeroEatMPItem1 := 5;
  if GameEngine.Config.nHeroEatMPItem1 > GameEngine.m_UnbindItemList.Count - 1 then GameEngine.Config.nHeroEatHPItem := GameEngine.m_UnbindItemList.Count - 1;

  ComboBoxHumEatHPItem.ItemIndex := GameEngine.Config.nHumEatHPItem;
  ComboBoxHumEatMPItem.ItemIndex := GameEngine.Config.nHumEatMPItem;
  ComboBoxHumEatHPItem1.ItemIndex := GameEngine.Config.nHumEatHPItem1;
  ComboBoxHumEatMPItem1.ItemIndex := GameEngine.Config.nHumEatMPItem1;

  ComboBoxHeroEatHPItem.ItemIndex := GameEngine.Config.nHeroEatHPItem;
  ComboBoxHeroEatMPItem.ItemIndex := GameEngine.Config.nHeroEatMPItem;
  ComboBoxHeroEatHPItem1.ItemIndex := GameEngine.Config.nHeroEatHPItem1;
  ComboBoxHeroEatMPItem1.ItemIndex := GameEngine.Config.nHeroEatMPItem1;
end;

procedure TfrmOption.RefConfig();
var
  I: Integer;
begin
  RefEatItem();
  CheckBoxHumUseHP.Checked := GameEngine.Config.boHumUseHP;
  CheckBoxHumUseMP.Checked := GameEngine.Config.boHumUseMP;
  CheckBoxHeroUseHP.Checked := GameEngine.Config.boHeroUseHP;
  CheckBoxHeroUseMP.Checked := GameEngine.Config.boHeroUseMP;


  CheckBoxHumUseHP1.Checked := GameEngine.Config.boHumUseHP1;
  CheckBoxHumUseMP1.Checked := GameEngine.Config.boHumUseMP1;
  CheckBoxHeroUseHP1.Checked := GameEngine.Config.boHeroUseHP1;
  CheckBoxHeroUseMP1.Checked := GameEngine.Config.boHeroUseMP1;

  CheckBoxHumChangeState.Checked := GameEngine.Config.boHumStateKey;
  CheckBoxCreateGroupKey.Checked := GameEngine.Config.boCreateGroupKey;
  CheckBoxHeroTakeback.Checked := GameEngine.Config.boHeroTakeback;
  CheckBoxRecallHero.Checked := GameEngine.Config.boRecallHeroKey;
  CheckBoxGroupMagic.Checked := GameEngine.Config.boHeroGroupKey;
  CheckBoxTarget.Checked := GameEngine.Config.boHeroTargetKey;
  CheckBoxGuard.Checked := GameEngine.Config.boHeroGuardKey;
  CheckBoxChangeState.Checked := GameEngine.Config.boHeroStateKey;

  CheckBoxUseFlyItem.Checked := GameEngine.Config.boUseFlyItem;
  CheckBoxUseReturnItem.Checked := GameEngine.Config.boUseReturnItem;

  CheckBoxGetHumBagItems.Checked := GameEngine.Config.boGetHumBagItems;


  EditHumMinHP.Value := GameEngine.Config.nHumMinHP;
  EditHumMinMP.Value := GameEngine.Config.nHumMinMP;
  EditHumHPTime.Value := GameEngine.Config.nHumHPTime;
  EditHumMPTime.Value := GameEngine.Config.nHumMPTime;

  EditHeroMinHP.Value := GameEngine.Config.nHeroMinHP;
  EditHeroMinMP.Value := GameEngine.Config.nHeroMinMP;
  EditHeroHPTime.Value := GameEngine.Config.nHeroHPTime;
  EditHeroMPTime.Value := GameEngine.Config.nHeroMPTime;


  EditHumMinHP1.Value := GameEngine.Config.nHumMinHP1;
  EditHumMinMP1.Value := GameEngine.Config.nHumMinMP1;
  EditHumHPTime1.Value := GameEngine.Config.nHumHPTime1;
  EditHumMPTime1.Value := GameEngine.Config.nHumMPTime1;

  EditHeroMinHP1.Value := GameEngine.Config.nHeroMinHP1;
  EditHeroMinMP1.Value := GameEngine.Config.nHeroMinMP1;
  EditHeroHPTime1.Value := GameEngine.Config.nHeroHPTime1;
  EditHeroMPTime1.Value := GameEngine.Config.nHeroMPTime1;

  EditUseflyItemMinHP.Value := GameEngine.Config.nUseflyItemMinHP;
  EditUseReturnItemMinHP.Value := GameEngine.Config.nUseReturnItemMinHP;

  EditTakeBackHeroMinHP.Value := GameEngine.Config.nTakeBackHeroMinHP;
  ComboBoxRecallHero.ItemIndex := GameEngine.Config.nRecallHeroKey;
  ComboBoxGroupMagic.ItemIndex := GameEngine.Config.nHeroGroupKey;
  ComboBoxTarget.ItemIndex := GameEngine.Config.nHeroTargetKey;
  ComboBoxGuard.ItemIndex := GameEngine.Config.nHeroGuardKey;
  ComboBoxChangeState.ItemIndex := GameEngine.Config.nHeroStateKey;
  ComboBoxCreateGroupKey.ItemIndex := GameEngine.Config.nCreateGroupKey;
  ComboBoxHumChangeState.ItemIndex := GameEngine.Config.nHumStateKey;
  ComboBoxGetHumBagItems.ItemIndex := GameEngine.Config.nGetHumBagItems;
  EditMoveCmd.Text := GameEngine.Config.sMoveCmd;

  CheckBoxHeroStateChange.Checked := GameEngine.Config.boHeroStateChange;
  ComboBoxHeroStateChange.ItemIndex := GameEngine.Config.nHeroStateChangeIndex;


  CheckBoxAutoAnswer.Checked := GameEngine.Config.boAutoAnswer;
  AutoAnswerMsg.Text := GameEngine.Config.sAnswerMsg;

  CheckBoxAutoSay.Checked := GameEngine.Config.boAutoSay;
  EditSayMsgTime.Value := GameEngine.Config.nAutoSayTime;

  CheckBoxAutoQueryBagItem.Checked := GameEngine.Config.boAutoQueryBagItem;
  EditAutoQueryBagItem.Value := GameEngine.Config.nAutoQueryBagItemTime;

  CheckBoxFastEatItem.Checked := GameEngine.Config.boFastEatItem;


  CheckBoxFilterItem.Checked := GameEngine.Config.boFilterShowItem;

  CheckBoxMagicLock.Checked := GameEngine.Config.boMagicLock;

  CheckBoxAutoUseItem.Checked := GameEngine.Config.boAutoUseItem;
  EditAutoUseItem.Value := GameEngine.Config.nAutoUseItem;

  ComboBoxAutoUseItem.Text := GameEngine.Config.sAutoUseItem;

  if GameEngine.Config.sAutoUseItem <> '' then begin

    {for I := 0 to ComboBoxAutoUseItem.Items.Count - 1 do begin
      if CompareText(ComboBoxAutoUseItem.Items.Strings[1], GameEngine.Config.sAutoUseItem) = 0 then begin
        ComboBoxAutoUseItem.ItemIndex := I;
        break;
      end;
    end; }
  end;


  ListBoxSayMsg.Items.Clear;
  ListBoxSayMsg.Items.AddStrings(GameEngine.m_SayMsgList);
  AutoAnswerMsg.Items.Clear;
  AutoAnswerMsg.Items.AddStrings(GameEngine.m_SayMsgList);

  ListBoxMapFilter.Clear;
  ListBoxMapFilter.Items.AddStrings(GameEngine.m_MapFilterList);

  MemoFilterItem.Lines.Clear;
  MemoFilterItem.Lines.AddStrings(GameEngine.m_ItemFilterList);

  ListBoxMagicLock.Items.Clear;
  ListBoxMagicLock.Items.AddStrings(GameEngine.m_MagicLockList);


  EditMapFilter.Text := GameEngine.m_sMapTitle;




end;

procedure TfrmOption.FormCreate(Sender: TObject);
  function IsMainHwnd(MainHwnd: Hwnd): string;
  var
    I: Integer;
  begin
    Result := '';
    for I := 0 to 10 do begin
      //if FormData.MainHwnd[I] > 0 then SendOutStr('FormData.MainHwnd[I]:' + IntToStr(I) + ':' + IntToStr(FormData.MainHwnd[I]));
      if (g_DataEngine.Data.MainHwnd[I] = MainHwnd) then begin

        Result := g_DataEngine.Data.Title[I];
        Break;
      end;
    end;
  end;
var
  I: Integer;
begin
  Actor := nil;
  //Caption := IsMainHwnd(GetForegroundWindow);
  //if GameEngine.m_MySelf <> nil then
  Caption := IsMainHwnd(GetForegroundWindow) + '-' + GameEngine.m_MySelf.m_sUserName;

  //Caption := g_sCaption;
  PageControl.ActivePageIndex := 0;

  for I := 0 to 5 do begin
    ComboBoxItemType.Items.AddObject(GetItemType(TItemType(I)), TObject(TItemType(I)));
  end;
  ComboBoxItemType.ItemIndex := 0;
end;

function GetBindItemType(btType: Byte): string;
begin
  Result := '';
  case btType of
    0: Result := 'HP';
    1: Result := 'MP';
    2: Result := 'HPMP';
    3: Result := '其他';
  end;
end;

procedure TfrmOption.RefListViewProtectItem;
var
  I: Integer;
  ListItem: TListItem;
  BindItem: pTBindClientItem;
begin
  ListViewProtectItem.Items.Clear;

  GameEngine.m_UnbindItemList.Lock;
  try
    for I := 0 to GameEngine.m_UnbindItemList.Count - 1 do begin
      ListItem := ListViewProtectItem.Items.Add;
      BindItem := pTBindClientItem(GameEngine.m_UnbindItemList.Items[I]);
      ListItem.Caption := GetBindItemType(BindItem.btItemType);
      ListItem.SubItems.AddObject(BindItem.sItemName, TObject(BindItem));
      ListItem.Data := BindItem;
      ListItem.SubItems.Add(BindItem.sBindItemName);
    end;
  finally
    GameEngine.m_UnbindItemList.UnLock;
  end;
end;

function TfrmOption.GetItemAttr: Integer;
begin
  Result := 0;
  if RadioButtonHP.Checked then Result := 0
  else if RadioButtonMP.Checked then Result := 1
  else if RadioButtonHMP.Checked then Result := 2
  else if RadioButtonOther.Checked then Result := 3;
end;

procedure TfrmOption.SetItemAttr(Attr: Integer);
begin
  case Attr of
    0: RadioButtonHP.Checked := True;
    1: RadioButtonMP.Checked := True;
    2: RadioButtonHMP.Checked := True;
    3: RadioButtonOther.Checked := True;
  end;
end;

procedure TfrmOption.ButtonProtectAddItemClick(Sender: TObject);
var
  ListItem: TListItem;
  BindItem: pTBindClientItem;
  sItemName, sBindItemName: string;
  nType: Integer;
begin
  sItemName := EditProtectItemName.Text;
  sBindItemName := EditProtectUnbindItemName.Text;
  nType := GetItemAttr;

  if sItemName = '' then begin
    GameEngine.AddChatBoardString('[失败]请输入物品名称！！！', c_Yellow, c_Red);
    Exit;
  end;
  if sBindItemName = '' then begin
    GameEngine.AddChatBoardString('[失败]请输入物品包名称！！！', c_Yellow, c_Red);
    Exit;
  end;

  if GameEngine.FindBindItemName(sBindItemName) <> '' then begin
    GameEngine.AddChatBoardString('[失败]此物品已经添加！！！', c_Yellow, c_Red);
    Exit;
  end;
  if GameEngine.FindUnBindItemName(sItemName) <> '' then begin
    GameEngine.AddChatBoardString('[失败]此物品已经添加！！！', c_Yellow, c_Red);
    Exit;
  end;

  New(BindItem);
  BindItem.btItemType := nType;
  BindItem.sItemName := sItemName;
  BindItem.sBindItemName := sBindItemName;
  GameEngine.m_UnbindItemList.Add(BindItem);
  RefListViewProtectItem;
  RefEatItem;
  ButtonProtectSaveItem.Enabled := True;
end;

procedure TfrmOption.ButtonProtectChgItemClick(Sender: TObject);
var
  ListItem: TListItem;
  BindItem: pTBindClientItem;
  sItemName, sBindItemName: string;
  nType: Integer;
begin
  sItemName := EditProtectItemName.Text;
  sBindItemName := EditProtectUnbindItemName.Text;
  nType := GetItemAttr;
  ListItem := ListViewProtectItem.Selected;
  if ListItem = nil then Exit;
  BindItem := pTBindClientItem(ListItem.Data);
  if BindItem = nil then Exit;
  BindItem.btItemType := nType;
  BindItem.sItemName := sItemName;
  BindItem.sBindItemName := sBindItemName;
  RefListViewProtectItem;
  RefEatItem;
  ButtonProtectChgItem.Enabled := False;
  ButtonProtectSaveItem.Enabled := True;
end;

procedure TfrmOption.ButtonProtectDelItemClick(Sender: TObject);
var
  ListItem: TListItem;
  BindItem: pTBindClientItem;
begin
  ListItem := ListViewProtectItem.Selected;
  if ListItem = nil then Exit;
  BindItem := pTBindClientItem(ListItem.SubItems.Objects[0]);
  if BindItem = nil then Exit;
  GameEngine.DeleteBindItem(BindItem);

  RefListViewProtectItem;
  RefEatItem;
  ButtonProtectDelItem.Enabled := False;
  ButtonProtectSaveItem.Enabled := True;
end;

procedure TfrmOption.ButtonProtectSaveItemClick(Sender: TObject);
begin
  GameEngine.SaveBindItemList;
  ButtonProtectSaveItem.Enabled := False;
end;

procedure TfrmOption.ListViewProtectItemClick(Sender: TObject);
var
  ListItem: TListItem;
  BindItem: pTBindClientItem;
begin
  ButtonProtectChgItem.Enabled := False;
  ButtonProtectDelItem.Enabled := False;
  ListItem := ListViewProtectItem.Selected;
  if ListItem = nil then Exit;
  BindItem := pTBindClientItem(ListItem.Data);
  if BindItem = nil then Exit;
  SetItemAttr(BindItem.btItemType);
  EditProtectItemName.Text := BindItem.sItemName;
  EditProtectUnbindItemName.Text := BindItem.sBindItemName;
  ButtonProtectChgItem.Enabled := True;
  ButtonProtectDelItem.Enabled := True;
end;

procedure TfrmOption.Button4Click(Sender: TObject);
var
  I: Integer;
begin
  Memo1.Lines.Clear;
  Memo1.Lines.Add(GameEngine.m_sServerName);
  case GameEngine.m_btVersion of
    0: begin
        for I := 0 to Length(GameEngine.m_HeroItemArr_BLUE) - 1 do begin
          if GameEngine.m_HeroItemArr_BLUE[I].s.Name <> '' then begin
            Memo1.Lines.Add(IntToStr(I) + ' ' + GameEngine.m_HeroItemArr_BLUE[I].s.Name + ' ' + IntToStr(GameEngine.m_HeroItemArr_BLUE[I].MakeIndex));
          end;
        end;
        Memo2.Lines.Clear;
        for I := 0 to Length(GameEngine.m_ItemArr_BLUE) - 1 do begin
          if GameEngine.m_ItemArr_BLUE[I].s.Name <> '' then begin
            Memo2.Lines.Add(IntToStr(I) + ' ' + GameEngine.m_ItemArr_BLUE[I].s.Name + ' ' + IntToStr(GameEngine.m_ItemArr_BLUE[I].MakeIndex));
          end;
        end;
      end;
    1: begin
        for I := 0 to Length(GameEngine.m_HeroItemArr_IGE) - 1 do begin
          if GameEngine.m_HeroItemArr_IGE[I].s.Name <> '' then begin
            Memo1.Lines.Add(IntToStr(I) + ' ' + GameEngine.m_HeroItemArr_IGE[I].s.Name + ' ' + IntToStr(GameEngine.m_HeroItemArr_IGE[I].MakeIndex));
          end;
        end;
        Memo2.Lines.Clear;
        for I := 0 to Length(GameEngine.m_ItemArr_IGE) - 1 do begin
          if GameEngine.m_ItemArr_IGE[I].s.Name <> '' then begin
            Memo2.Lines.Add(IntToStr(I) + ' ' + GameEngine.m_ItemArr_IGE[I].s.Name + ' ' + IntToStr(GameEngine.m_ItemArr_IGE[I].MakeIndex));
          end;
        end;
      end;
  end;
end;

procedure TfrmOption.CheckBoxHumUseHPClick(Sender: TObject);
begin
  EditHumMinHP.Enabled := CheckBoxHumUseHP.Checked;
  EditHumHPTime.Enabled := CheckBoxHumUseHP.Checked;
  ComboBoxHumEatHPItem.Enabled := CheckBoxHumUseHP.Checked;
  GameEngine.Config.boHumUseHP := CheckBoxHumUseHP.Checked;
  //GameEngine.TimerHumEatHP.Enabled := GameEngine.Config.boHumUseHP;
  ButtonHumOptionSave.Enabled := True;
end;

procedure TfrmOption.CheckBoxHumUseMPClick(Sender: TObject);
begin
  EditHumMinMP.Enabled := CheckBoxHumUseMP.Checked;
  EditHumMPTime.Enabled := CheckBoxHumUseMP.Checked;
  ComboBoxHumEatMPItem.Enabled := CheckBoxHumUseMP.Checked;
  GameEngine.Config.boHumUseMP := CheckBoxHumUseMP.Checked;
  //GameEngine.TimerHumEatMP.Enabled := GameEngine.Config.boHumUseMP;
  ButtonHumOptionSave.Enabled := True;
end;

procedure TfrmOption.CheckBoxMagicLockClick(Sender: TObject);
begin
  GameEngine.Config.boMagicLock := CheckBoxMagicLock.Checked;
  ButtonSaveMagicLock.Enabled := True;
end;

procedure TfrmOption.EditHumMinHPChange(Sender: TObject);
begin
  GameEngine.Config.nHumMinHP := EditHumMinHP.Value;
  ButtonHumOptionSave.Enabled := True;
end;

procedure TfrmOption.EditHumMinMPChange(Sender: TObject);
begin
  GameEngine.Config.nHumMinMP := EditHumMinMP.Value;
  ButtonHumOptionSave.Enabled := True;
end;

procedure TfrmOption.EditHumHPTimeChange(Sender: TObject);
begin
  GameEngine.Config.nHumHPTime := EditHumHPTime.Value;
  ButtonHumOptionSave.Enabled := True;
end;

procedure TfrmOption.EditHumHPTimeMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  StatusBar.Panels[0].Text := '喝药速度,单位毫秒';
end;

procedure TfrmOption.EditHumMPTimeChange(Sender: TObject);
begin
  GameEngine.Config.nHumMPTime := EditHumMPTime.Value;
  ButtonHumOptionSave.Enabled := True;
end;

procedure TfrmOption.EditHumUseMagicTimeChange(Sender: TObject);
begin
  GameEngine.Config.nHumUseMagicTime := EditHumUseMagicTime.Value;
end;

procedure TfrmOption.EditMoveCmdMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  StatusBar.Panels[0].Text := '传送戒指命令,默认@Move';
end;

procedure TfrmOption.EditMoveTimeMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  StatusBar.Panels[0].Text := '传送命令使用间隔单位秒,默认5秒';
end;

procedure TfrmOption.EditSayMsgTimeChange(Sender: TObject);
begin
  GameEngine.Config.nAutoSayTime := EditSayMsgTime.Value;
end;

procedure TfrmOption.EditHeroMinHPChange(Sender: TObject);
begin
  GameEngine.Config.nHeroMinHP := EditHeroMinHP.Value;
  ButtonHeroOptionSave.Enabled := True;
end;

procedure TfrmOption.EditHeroMinMPChange(Sender: TObject);
begin
  GameEngine.Config.nHeroMinMP := EditHeroMinMP.Value;
  ButtonHeroOptionSave.Enabled := True;
end;

procedure TfrmOption.EditHeroHPTimeChange(Sender: TObject);
begin
  GameEngine.Config.nHeroHPTime := EditHeroHPTime.Value;
  ButtonHeroOptionSave.Enabled := True;
end;

procedure TfrmOption.EditHeroMPTimeChange(Sender: TObject);
begin
  GameEngine.Config.nHeroMPTime := EditHeroMPTime.Value;
  ButtonHeroOptionSave.Enabled := True;
end;

procedure TfrmOption.CheckBoxUseFlyItemClick(Sender: TObject);
begin
  EditUseflyItemMinHP.Enabled := CheckBoxUseFlyItem.Checked;
  GameEngine.Config.boUseFlyItem := CheckBoxUseFlyItem.Checked;
  ButtonHumOptionSave.Enabled := True;
end;

procedure TfrmOption.CheckBoxUseReturnItemClick(Sender: TObject);
begin
  EditUseReturnItemMinHP.Enabled := CheckBoxUseReturnItem.Checked;
  GameEngine.Config.boUseReturnItem := CheckBoxUseReturnItem.Checked;
  ButtonHumOptionSave.Enabled := True;
end;

procedure TfrmOption.CheckBoxHeroStateChangeClick(Sender: TObject);
var
  DefMsg: TDefaultMessage;
  DefMsg_IGE: TDefaultMessage_IGE;
  nState: Integer;
begin
  GameEngine.Config.boHeroStateChange := CheckBoxHeroStateChange.Checked;
  //GameEngine.Config.nHeroStateChangeIndex := ComboBoxHeroStateChange.ItemIndex;
  ButtonBaseSave.Enabled := True;
  if (GameEngine.m_MyHero <> nil) then begin
    if GameEngine.Config.boHeroStateChange and (GameEngine.Config.nHeroStateChangeIndex in [0..4]) then begin
      case GameEngine.Config.nHeroStateChangeIndex of
        0: nState := $04000000;
        1: nState := $08000000;
        2: nState := $40000000;
        3: nState := $20000000;
        4: nState := $80000000;
      end;
    end else begin
      if not GameEngine.Config.boHeroStateChange then nState := $00000000;
    end;
    if GameEngine.m_btVersion = 0 then begin
      DefMsg.Param := LoWord(nState);
      DefMsg.Tag := HiWord(nState);
      DefMsg := MakeDefaultMsg(SM_CHARSTATUSCHANGED, GameEngine.m_MyHero.m_nRecogId, DefMsg.Param, DefMsg.Tag, GameEngine.m_MyHero.m_nHitSpeed);

      GameSocket.SendToClient(EncodeMessage(DefMsg));
    end else begin
      DefMsg_IGE.Param := LoWord(nState);
      DefMsg_IGE.Tag := HiWord(nState);
      DefMsg_IGE := GameEngine.MakeDefaultMsg_IGE(SM_CHARSTATUSCHANGED, GameEngine.m_MyHero.m_nRecogId, DefMsg.Param, DefMsg.Tag, GameEngine.m_MyHero.m_nHitSpeed);

      GameSocket.SendToClient(GameEngine.EncodeMessage_IGE(DefMsg_IGE));
    end;
  end;
end;

procedure TfrmOption.CheckBoxHeroTakebackClick(Sender: TObject);
begin
  EditTakeBackHeroMinHP.Enabled := CheckBoxHeroTakeback.Checked;
  GameEngine.Config.boHeroTakeback := CheckBoxHeroTakeback.Checked;
  ButtonHeroOptionSave.Enabled := True;
end;

procedure TfrmOption.EditTakeBackHeroMinHPChange(Sender: TObject);
begin
  GameEngine.Config.nTakeBackHeroMinHP := EditTakeBackHeroMinHP.Value;
  ButtonHeroOptionSave.Enabled := True;
end;

procedure TfrmOption.CheckBoxRecallHeroClick(Sender: TObject);
begin
  ComboBoxRecallHero.Enabled := CheckBoxRecallHero.Checked;
  GameEngine.Config.boRecallHeroKey := CheckBoxRecallHero.Checked;
  ButtonHeroOptionSave.Enabled := True;
end;

procedure TfrmOption.CheckBoxGetHumBagItemsClick(Sender: TObject);
begin
  ComboBoxGetHumBagItems.Enabled := CheckBoxGetHumBagItems.Checked;
  GameEngine.Config.boGetHumBagItems := CheckBoxGetHumBagItems.Checked;
  ButtonHumOptionSave.Enabled := True;
end;

procedure TfrmOption.CheckBoxGroupMagicClick(Sender: TObject);
begin
  ComboBoxGroupMagic.Enabled := CheckBoxGroupMagic.Checked;
  GameEngine.Config.boHeroGroupKey := CheckBoxGroupMagic.Checked;
  ButtonHeroOptionSave.Enabled := True;
end;

procedure TfrmOption.CheckBoxTargetClick(Sender: TObject);
begin
  ComboBoxTarget.Enabled := CheckBoxTarget.Checked;
  GameEngine.Config.boHeroTargetKey := CheckBoxTarget.Checked;
  ButtonHeroOptionSave.Enabled := True;
end;

procedure TfrmOption.CheckBoxGuardClick(Sender: TObject);
begin
  ComboBoxGuard.Enabled := CheckBoxGuard.Checked;
  GameEngine.Config.boHeroGuardKey := CheckBoxGuard.Checked;
  ButtonHeroOptionSave.Enabled := True;
end;

procedure TfrmOption.CheckBoxAutoAnswerClick(Sender: TObject);
begin
  GameEngine.Config.boAutoAnswer := CheckBoxAutoAnswer.Checked;
  GameEngine.Config.sAnswerMsg := AutoAnswerMsg.Text;
end;

procedure TfrmOption.CheckBoxAutoQueryBagItemClick(Sender: TObject);
begin
  GameEngine.Config.boAutoQueryBagItem := CheckBoxAutoQueryBagItem.Checked;
  ButtonBaseSave.Enabled := True;
end;

procedure TfrmOption.CheckboxAutoSayClick(Sender: TObject);
begin
  GameEngine.Config.boAutoSay := CheckBoxAutoSay.Checked;
  GameEngine.Config.nAutoSayTime := EditSayMsgTime.Value;
end;

procedure TfrmOption.CheckBoxChangeStateClick(Sender: TObject);
begin
  ComboBoxChangeState.Enabled := CheckBoxChangeState.Checked;
  GameEngine.Config.boHeroStateKey := CheckBoxChangeState.Checked;
  ButtonHeroOptionSave.Enabled := True;
end;

procedure TfrmOption.ComboBoxRecallHeroChange(Sender: TObject);
var
  ItemIndex: Integer;
begin
  GameEngine.Config.nShowOptionKey := g_DataEngine.Data.ShowOptionIndex;
  ItemIndex := TComboBox(Sender).ItemIndex;
  if Sender = ComboBoxRecallHero then begin
    if ItemIndex > 0 then begin
      if (GameEngine.Config.nCreateGroupKey = ItemIndex) or
        (GameEngine.Config.nHeroGroupKey = ItemIndex) or
        (GameEngine.Config.nHeroTargetKey = ItemIndex) or
        (GameEngine.Config.nHeroGuardKey = ItemIndex) or
        (GameEngine.Config.nHumStateKey = ItemIndex) or
        (GameEngine.Config.nShowOptionKey = ItemIndex) or
        (GameEngine.Config.nGetHumBagItems = ItemIndex) or
        (GameEngine.Config.nHeroStateKey = ItemIndex) then begin
        TComboBox(Sender).ItemIndex := GameEngine.Config.nRecallHeroKey;
        Exit;
      end;
    end;
    GameEngine.Config.nRecallHeroKey := ItemIndex;
  end else
    if Sender = ComboBoxGroupMagic then begin
    if ItemIndex > 0 then begin
      if (GameEngine.Config.nCreateGroupKey = ItemIndex) or
        (GameEngine.Config.nRecallHeroKey = ItemIndex) or
        (GameEngine.Config.nHeroTargetKey = ItemIndex) or
        (GameEngine.Config.nHeroGuardKey = ItemIndex) or
        (GameEngine.Config.nHumStateKey = ItemIndex) or
        (GameEngine.Config.nShowOptionKey = ItemIndex) or
        (GameEngine.Config.nGetHumBagItems = ItemIndex) or
        (GameEngine.Config.nHeroStateKey = ItemIndex) then begin
        TComboBox(Sender).ItemIndex := GameEngine.Config.nHeroGroupKey;
        Exit;
      end;
    end;
    GameEngine.Config.nHeroGroupKey := ItemIndex;
  end else
    if Sender = ComboBoxTarget then begin
    if ItemIndex > 0 then begin
      if (GameEngine.Config.nCreateGroupKey = ItemIndex) or
        (GameEngine.Config.nRecallHeroKey = ItemIndex) or
        (GameEngine.Config.nHeroGroupKey = ItemIndex) or
        (GameEngine.Config.nHeroGuardKey = ItemIndex) or
        (GameEngine.Config.nHumStateKey = ItemIndex) or
        (GameEngine.Config.nShowOptionKey = ItemIndex) or
        (GameEngine.Config.nGetHumBagItems = ItemIndex) or
        (GameEngine.Config.nHeroStateKey = ItemIndex) then begin
        TComboBox(Sender).ItemIndex := GameEngine.Config.nHeroTargetKey;
        Exit;
      end;
    end;
    GameEngine.Config.nHeroTargetKey := ItemIndex;
  end else
    if Sender = ComboBoxGuard then begin
    if ItemIndex > 0 then begin
      if (GameEngine.Config.nCreateGroupKey = ItemIndex) or
        (GameEngine.Config.nRecallHeroKey = ItemIndex) or
        (GameEngine.Config.nHeroGroupKey = ItemIndex) or
        (GameEngine.Config.nHeroTargetKey = ItemIndex) or
        (GameEngine.Config.nHumStateKey = ItemIndex) or
        (GameEngine.Config.nShowOptionKey = ItemIndex) or
        (GameEngine.Config.nGetHumBagItems = ItemIndex) or
        (GameEngine.Config.nHeroStateKey = ItemIndex) then begin
        TComboBox(Sender).ItemIndex := GameEngine.Config.nHeroGuardKey;
        Exit;
      end;
    end;
    GameEngine.Config.nHeroGuardKey := ItemIndex;
  end else
    if Sender = ComboBoxChangeState then begin
    if ItemIndex > 0 then begin
      if (GameEngine.Config.nCreateGroupKey = ItemIndex) or
        (GameEngine.Config.nRecallHeroKey = ItemIndex) or
        (GameEngine.Config.nHeroGroupKey = ItemIndex) or
        (GameEngine.Config.nHeroTargetKey = ItemIndex) or
        (GameEngine.Config.nHumStateKey = ItemIndex) or
        (GameEngine.Config.nShowOptionKey = ItemIndex) or
        (GameEngine.Config.nGetHumBagItems = ItemIndex) or
        (GameEngine.Config.nHeroGuardKey = ItemIndex) then begin
        TComboBox(Sender).ItemIndex := GameEngine.Config.nHeroStateKey;
        Exit;
      end;
    end;
    GameEngine.Config.nHeroStateKey := ItemIndex;
  end else
    if Sender = ComboBoxCreateGroupKey then begin
    if ItemIndex > 0 then begin
      if (GameEngine.Config.nHeroStateKey = ItemIndex) or
        (GameEngine.Config.nRecallHeroKey = ItemIndex) or
        (GameEngine.Config.nHeroGroupKey = ItemIndex) or
        (GameEngine.Config.nHeroTargetKey = ItemIndex) or
        (GameEngine.Config.nHumStateKey = ItemIndex) or
        (GameEngine.Config.nShowOptionKey = ItemIndex) or
        (GameEngine.Config.nGetHumBagItems = ItemIndex) or
        (GameEngine.Config.nHeroGuardKey = ItemIndex) then begin
        TComboBox(Sender).ItemIndex := GameEngine.Config.nCreateGroupKey;
        Exit;
      end;
    end;
    GameEngine.Config.nCreateGroupKey := ItemIndex;
  end else
    if Sender = ComboBoxHumChangeState then begin
    if ItemIndex > 0 then begin
      if (GameEngine.Config.nCreateGroupKey = ItemIndex) or
        (GameEngine.Config.nHeroStateKey = ItemIndex) or
        (GameEngine.Config.nRecallHeroKey = ItemIndex) or
        (GameEngine.Config.nHeroGroupKey = ItemIndex) or
        (GameEngine.Config.nHeroTargetKey = ItemIndex) or
        (GameEngine.Config.nShowOptionKey = ItemIndex) or
        (GameEngine.Config.nGetHumBagItems = ItemIndex) or
        (GameEngine.Config.nHeroGuardKey = ItemIndex) then begin
        TComboBox(Sender).ItemIndex := GameEngine.Config.nHumStateKey;
        Exit;
      end;
    end;
    GameEngine.Config.nHumStateKey := ItemIndex;
  end else
    if Sender = ComboBoxGetHumBagItems then begin
    if ItemIndex > 0 then begin
      if (GameEngine.Config.nCreateGroupKey = ItemIndex) or
        (GameEngine.Config.nHeroStateKey = ItemIndex) or
        (GameEngine.Config.nRecallHeroKey = ItemIndex) or
        (GameEngine.Config.nHeroGroupKey = ItemIndex) or
        (GameEngine.Config.nHeroTargetKey = ItemIndex) or
        (GameEngine.Config.nHumStateKey = ItemIndex) or
        (GameEngine.Config.nShowOptionKey = ItemIndex) or
        (GameEngine.Config.nHeroGuardKey = ItemIndex) then begin
        TComboBox(Sender).ItemIndex := GameEngine.Config.nGetHumBagItems;
        Exit;
      end;
    end;
    GameEngine.Config.nGetHumBagItems := ItemIndex;
  end;
  ButtonHumOptionSave.Enabled := True;
  ButtonHeroOptionSave.Enabled := True;
end;

procedure TfrmOption.ButtonHumOptionSaveClick(Sender: TObject);
begin
  GameEngine.SaveConfig('');
  //ComboBoxShowOption.Items.SaveToFile('Key.txt');
  ButtonHumOptionSave.Enabled := False;
  ButtonHeroOptionSave.Enabled := False;
end;

procedure TfrmOption.ButtonMapFilterAddClick(Sender: TObject);
var
  I: Integer;
  sMapName: string;
begin
  sMapName := EditMapFilter.Text;
  if sMapName = '' then begin
    GameEngine.AddChatBoardString('请输入地图名称！！！', c_White, c_Red);
    Exit;
  end;
  for I := 0 to GameEngine.m_MapFilterList.Count - 1 do begin
    if Comparetext(sMapName, GameEngine.m_MapFilterList.Strings[I]) = 0 then begin
      GameEngine.AddChatBoardString('该地图已经存在！！！', c_White, c_Red);
      Exit;
    end;
  end;
  GameEngine.m_MapFilterList.Add(sMapName);
  ListBoxMapFilter.Items.Add(sMapName);
end;

procedure TfrmOption.ButtonMapFilterDelClick(Sender: TObject);
{var
  I:Integer; }
begin
  ListBoxMapFilter.DeleteSelected;
  GameEngine.m_MapFilterList.Clear;
  GameEngine.m_MapFilterList.AddStrings(ListBoxMapFilter.Items);
  {for I := 0 to GameEngine.m_MapFilterList.Count - 1 do  begin

  end;
  }
end;

procedure TfrmOption.ButtonMapFilterSaveClick(Sender: TObject);
begin
  GameEngine.SaveConfig('');
end;

procedure TfrmOption.CheckBoxHeroUseHPClick(Sender: TObject);
begin
  EditHeroMinHP.Enabled := CheckBoxHeroUseHP.Checked;
  EditHeroHPTime.Enabled := CheckBoxHeroUseHP.Checked;
  ComboBoxHeroEatHPItem.Enabled := CheckBoxHeroUseHP.Checked;
  GameEngine.Config.boHeroUseHP := CheckBoxHeroUseHP.Checked;
  //GameEngine.TimerHeroEatHP.Enabled := GameEngine.Config.boHeroUseHP;
  ButtonHeroOptionSave.Enabled := True;
end;

procedure TfrmOption.CheckBoxHeroUseMPClick(Sender: TObject);
begin
  EditHeroMinMP.Enabled := CheckBoxHeroUseMP.Checked;
  EditHeroMPTime.Enabled := CheckBoxHeroUseMP.Checked;
  ComboBoxHeroEatMPItem.Enabled := CheckBoxHeroUseMP.Checked;
  GameEngine.Config.boHeroUseMP := CheckBoxHeroUseMP.Checked;
  //GameEngine.TimerHeroEatMP.Enabled := GameEngine.Config.boHeroUseMP;
  ButtonHeroOptionSave.Enabled := True;
end;

procedure TfrmOption.EditUseflyItemMinHPChange(Sender: TObject);
begin
  GameEngine.Config.nUseflyItemMinHP := EditUseflyItemMinHP.Value;
  ButtonHumOptionSave.Enabled := True;
end;

procedure TfrmOption.EditUseReturnItemMinHPChange(Sender: TObject);
begin
  GameEngine.Config.nUseReturnItemMinHP := EditUseReturnItemMinHP.Value;
  ButtonHumOptionSave.Enabled := True;
end;

procedure TfrmOption.CheckBoxCreateGroupKeyClick(Sender: TObject);
begin
  ComboBoxCreateGroupKey.Enabled := CheckBoxCreateGroupKey.Checked;
  GameEngine.Config.boCreateGroupKey := CheckBoxCreateGroupKey.Checked;
  ButtonHumOptionSave.Enabled := True;
end;

procedure TfrmOption.CheckBoxFastEatItemClick(Sender: TObject);
begin
  GameEngine.Config.boFastEatItem := CheckBoxFastEatItem.Checked;
  ButtonBaseSave.Enabled := True;
end;

procedure TfrmOption.CheckBoxHumUseHP1Click(Sender: TObject);
begin
  EditHumMinHP1.Enabled := CheckBoxHumUseHP1.Checked;
  EditHumHPTime1.Enabled := CheckBoxHumUseHP1.Checked;
  ComboBoxHumEatHPItem1.Enabled := CheckBoxHumUseHP1.Checked;
  GameEngine.Config.boHumUseHP1 := CheckBoxHumUseHP1.Checked;
  //GameEngine.TimerHumEatHP1.Enabled := GameEngine.Config.boHumUseHP1;
  ButtonHumOptionSave.Enabled := True;
end;

procedure TfrmOption.CheckBoxHumUseMagicClick(Sender: TObject);
begin
  GameEngine.Config.boHumUseMagic := CheckBoxHumUseMagic.Checked;
  GameEngine.Config.nHumUseMagicTime := EditHumUseMagicTime.Value;
end;

procedure TfrmOption.CheckBoxHumUseMP1Click(Sender: TObject);
begin
  EditHumMinMP1.Enabled := CheckBoxHumUseMP1.Checked;
  EditHumMPTime1.Enabled := CheckBoxHumUseMP1.Checked;
  ComboBoxHumEatMPItem1.Enabled := CheckBoxHumUseMP1.Checked;
  GameEngine.Config.boHumUseMP1 := CheckBoxHumUseMP1.Checked;
  //GameEngine.TimerHumEatMP1.Enabled := GameEngine.Config.boHumUseMP1;
  ButtonHumOptionSave.Enabled := True;
end;

procedure TfrmOption.EditHumMinHP1Change(Sender: TObject);
begin
  GameEngine.Config.nHumMinHP1 := EditHumMinHP1.Value;
  ButtonHumOptionSave.Enabled := True;
end;

procedure TfrmOption.EditHumMinMP1Change(Sender: TObject);
begin
  GameEngine.Config.nHumMinMP1 := EditHumMinMP1.Value;
  ButtonHumOptionSave.Enabled := True;
end;

procedure TfrmOption.EditHumHPTime1Change(Sender: TObject);
begin
  GameEngine.Config.nHumHPTime1 := EditHumHPTime1.Value;
  ButtonHumOptionSave.Enabled := True;
end;

procedure TfrmOption.EditHumMPTime1Change(Sender: TObject);
begin
  GameEngine.Config.nHumMPTime1 := EditHumMPTime1.Value;
  ButtonHumOptionSave.Enabled := True;
end;

procedure TfrmOption.CheckBoxHeroUseHP1Click(Sender: TObject);
begin
  EditHeroMinHP1.Enabled := CheckBoxHeroUseHP1.Checked;
  EditHeroHPTime1.Enabled := CheckBoxHeroUseHP1.Checked;
  ComboBoxHeroEatHPItem1.Enabled := CheckBoxHeroUseHP1.Checked;
  GameEngine.Config.boHeroUseHP1 := CheckBoxHeroUseHP1.Checked;
  //GameEngine.TimerHeroEatHP1.Enabled := GameEngine.Config.boHeroUseHP1;
  ButtonHeroOptionSave.Enabled := True;
end;

procedure TfrmOption.EditAutoQueryBagItemChange(Sender: TObject);
begin
  GameEngine.Config.nAutoQueryBagItemTime := EditAutoQueryBagItem.Value;
  ButtonBaseSave.Enabled := True;
end;

procedure TfrmOption.EditHeroHPTime1Change(Sender: TObject);
begin
  GameEngine.Config.nHeroHPTime1 := EditHeroHPTime1.Value;
  ButtonHeroOptionSave.Enabled := True;
end;

procedure TfrmOption.EditHeroMPTime1Change(Sender: TObject);
begin
  GameEngine.Config.nHeroMPTime1 := EditHeroMPTime1.Value;
  ButtonHeroOptionSave.Enabled := True;
end;

procedure TfrmOption.ComboBoxHumEatHPItemChange(Sender: TObject);
var
  ItemIndex: Integer;
begin
  ItemIndex := TComboBox(Sender).ItemIndex;
  if Sender = ComboBoxHumEatHPItem then begin
    GameEngine.Config.nHumEatHPItem := ItemIndex;
  end else
    if Sender = ComboBoxHumEatMPItem then begin
    GameEngine.Config.nHumEatMPItem := ItemIndex;
  end else
    if Sender = ComboBoxHumEatHPItem1 then begin
    GameEngine.Config.nHumEatHPItem1 := ItemIndex;
  end else
    if Sender = ComboBoxHumEatMPItem1 then begin
    GameEngine.Config.nHumEatMPItem1 := ItemIndex;
  end;
  ButtonHumOptionSave.Enabled := True;
end;

procedure TfrmOption.ComboBoxHumMagicSelect(Sender: TObject);
begin
  GameEngine.Config.nHumMagicIndex := ComboBoxHumMagic.ItemIndex;
  GameEngine.Config.nHumUseMagicTime := EditHumUseMagicTime.Value;
end;

procedure TfrmOption.ComboBoxHeroEatHPItemChange(Sender: TObject);
var
  ItemIndex: Integer;
begin
  ItemIndex := TComboBox(Sender).ItemIndex;
  if Sender = ComboBoxHeroEatHPItem then begin
    GameEngine.Config.nHeroEatHPItem := ItemIndex;
  end else
    if Sender = ComboBoxHeroEatMPItem then begin
    GameEngine.Config.nHeroEatMPItem := ItemIndex;
  end else
    if Sender = ComboBoxHeroEatHPItem1 then begin
    GameEngine.Config.nHeroEatHPItem1 := ItemIndex;
  end else
    if Sender = ComboBoxHeroEatMPItem1 then begin
    GameEngine.Config.nHeroEatMPItem1 := ItemIndex;
  end;
  ButtonHeroOptionSave.Enabled := True;
end;

procedure TfrmOption.ComboBoxHeroStateChangeSelect(Sender: TObject);
var
  DefMsg: TDefaultMessage;
  DefMsg_IGE: TDefaultMessage_IGE;
  nState: Integer;
begin
  //GameEngine.Config.boHeroStateChange := CheckBoxHeroStateChange.Checked;
  GameEngine.Config.nHeroStateChangeIndex := ComboBoxHeroStateChange.ItemIndex;
  ButtonBaseSave.Enabled := True;
  if (GameEngine.m_MyHero <> nil) and GameEngine.Config.boHeroStateChange and (GameEngine.Config.nHeroStateChangeIndex in [0..4]) then begin
    case GameEngine.Config.nHeroStateChangeIndex of
      0: nState := $04000000;
      1: nState := $08000000;
      2: nState := $40000000;
      3: nState := $20000000;
      4: nState := $80000000;
    end;
    if GameEngine.m_btVersion = 0 then begin
      DefMsg.Param := LoWord(nState);
      DefMsg.Tag := HiWord(nState);
      DefMsg := MakeDefaultMsg(SM_CHARSTATUSCHANGED, GameEngine.m_MyHero.m_nRecogId, DefMsg.Param, DefMsg.Tag, GameEngine.m_MyHero.m_nHitSpeed);
      GameSocket.SendToClient(EncodeMessage(DefMsg));
    end else begin
      DefMsg_IGE.Param := LoWord(nState);
      DefMsg_IGE.Tag := HiWord(nState);
      DefMsg_IGE := GameEngine.MakeDefaultMsg_IGE(SM_CHARSTATUSCHANGED, GameEngine.m_MyHero.m_nRecogId, DefMsg.Param, DefMsg.Tag, GameEngine.m_MyHero.m_nHitSpeed);
      GameSocket.SendToClient(GameEngine.EncodeMessage_IGE(DefMsg_IGE));
    end;
  end;
end;

procedure TfrmOption.Button1Click(Sender: TObject);
begin
  {Memo1.Lines.Add('ActiveConnections:' + IntToStr(GameSocket.ServerSocket.Socket.ActiveConnections));

  if GameSocket.ServerSocket.Socket.ActiveConnections > 0 then begin
    if GameSocket.m_Socket = GameSocket.ServerSocket.Socket.Connections[0] then
      Memo1.Lines.Add('m_Socket =')
    else Memo1.Lines.Add('m_Socket <>');
  end;
  Memo1.Lines.Add('ClientConnected:' + IntToStr(Integer(GameSocket.ClientConnected)));}
end;

procedure TfrmOption.Button5Click(Sender: TObject);
var
  dmsg: TDefaultMessage;
begin
  dmsg := MakeDefaultMsg(SM_EAT_OK, 0, 0, 0, 0);
  Memo1.Lines.Add('SM_EAT_OK' + EncodeMessage(dmsg));
  dmsg := MakeDefaultMsg(SM_EAT_FAIL, 0, 0, 0, 0);
  Memo1.Lines.Add('SM_EAT_FAIL' + EncodeMessage(dmsg));
end;

procedure TfrmOption.EditHeroMinHP1Change(Sender: TObject);
begin
  GameEngine.Config.nHeroMinHP1 := EditHeroMinHP1.Value;
  ButtonHeroOptionSave.Enabled := True;
end;

procedure TfrmOption.CheckBoxHeroUseMP1Click(Sender: TObject);
begin
  EditHeroMinMP1.Enabled := CheckBoxHeroUseMP1.Checked;
  EditHeroMPTime1.Enabled := CheckBoxHeroUseMP1.Checked;
  ComboBoxHeroEatMPItem1.Enabled := CheckBoxHeroUseMP1.Checked;
  GameEngine.Config.boHeroUseMP1 := CheckBoxHeroUseMP1.Checked;
  //GameEngine.TimerHeroEatMP1.Enabled := GameEngine.Config.boHeroUseMP1;
  ButtonHeroOptionSave.Enabled := True;
end;

procedure TfrmOption.EditHeroMinMP1Change(Sender: TObject);
begin
  GameEngine.Config.nHeroMinMP1 := EditHeroMinMP1.Value;
  ButtonHeroOptionSave.Enabled := True;
end;

procedure TfrmOption.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GameEngine.KeyDown(MainHwnd, Key);
end;

procedure TfrmOption.ListBoxMagicLockMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  StatusBar.Panels[0].Text := '可以锁定的魔法列表';
end;

procedure TfrmOption.ListBoxMapFilterClick(Sender: TObject);
begin
  if ListBoxMapFilter.ItemIndex >= 0 then
    EditMapFilter.Text := ListBoxMapFilter.Items.Strings[ListBoxMapFilter.ItemIndex];
end;

procedure TfrmOption.ListBoxMapFilterMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  StatusBar.Panels[0].Text := '禁止自动吃药地图列表';
end;

procedure TfrmOption.ListViewBossListClick(Sender: TObject);
var
  ListItem: TListItem;
  ShowBoss: pTShowBoss;
begin
  //if ListViewBossList.ItemIndex >= 0 then begin
  try
    ListItem := ListViewBossList.Selected;
    //ListItem := ListViewBossList.Items.Item[ListViewBossList.ItemIndex];
    if ListItem <> nil then begin
    //ShowMessage('ListItem <> nil:' + ListItem.Caption);
      ShowBoss := GameEngine.m_ShowBossList.Find(ListItem.Caption);
    //ShowBoss := pTShowBoss(ListItem.SubItems.Objects[0]);
      if ShowBoss <> nil then begin
      //ShowMessage('ShowBoss <> nil:' + ShowBoss.sBossName);
        CheckHintBossXY.Checked := ShowBoss.boHintMsg;
        EditBossMonName.Text := ShowBoss.sBossName;
      end;
    end;
  except

  end;
  //end;
end;

procedure TfrmOption.ButtonAddBossMonClick(Sender: TObject);
var
  I: Integer;
  ListItem: TListItem;
  ShowBoss: pTShowBoss;
  sShowBoss: string;
  //FColor: TColor;
begin
  sShowBoss := EditBossMonName.Text;
  if sShowBoss = '' then begin
    GameEngine.AddChatBoardString('请输入怪物名称！！！', c_White, c_Red);
    Exit;
  end;
  New(ShowBoss);
  ShowBoss.sBossName := sShowBoss;
  //ShowBoss.boShowName := CheckBossMonName.Checked;
  ShowBoss.boHintMsg := CheckHintBossXY.Checked;
  //ShowBoss.btColor := EditBossMonNameColor.Value;
  if GameEngine.m_ShowBossList.Add(ShowBoss) then begin
    AddItemToBossView(ShowBoss);
    GameEngine.AddChatBoardString('添加成功！！！', c_White, c_Red);
  end else begin
    for I := 0 to ListViewBossList.Items.Count - 1 do begin
      ListItem := ListViewBossList.Items.Item[I];
      if ListItem.Caption = sShowBoss then begin
        ListViewBossList.ItemIndex := I;
        //ListViewBossList.Selected := ListItem;
        Break;
      end;
    end;
    Dispose(ShowBoss);
    GameEngine.AddChatBoardString('[失败]此怪物已经添加！！！', c_White, c_Red);
  end;
end;

procedure TfrmOption.ButtonDelBossMonClick(Sender: TObject);
var
  ListItem: TListItem;
begin
  ListItem := ListViewBossList.Selected;
  if ListItem <> nil then begin
    GameEngine.m_ShowBossList.Delete(ListItem.Caption);
    ListViewBossList.DeleteSelected;
    GameEngine.AddChatBoardString('删除成功！！！', c_White, c_Red);
  end;
end;

procedure TfrmOption.ButtonSaveBossMonClick(Sender: TObject);
begin
  ButtonSaveBossMon.Enabled := False;
  GameEngine.SaveShowBossList;
  ButtonSaveBossMon.Enabled := True;
  GameEngine.AddChatBoardString('保存成功！！！', c_White, c_Red);
end;

procedure TfrmOption.ListViewItemListClick(Sender: TObject);
var
  ListItem: TListItem;
  ShowItem: pTShowItem;
begin
  try
    ListItem := ListViewItemList.Selected;
    if ListItem <> nil then begin
      ShowItem := GameEngine.m_ShowItemList.Find(ListItem.Caption);
    //ShowItem := pTShowItem(ListItem.SubItems.Objects[0]);
      if ShowItem <> nil then begin
        CheckPickUpItem.Checked := ShowItem.boPickup;
        CheckItemHint.Checked := ShowItem.boHintMsg;
        CheckBoxMovePick.Checked := ShowItem.boMovePick;
        EditItemName.Text := ShowItem.sItemName;
      end;
    end;
  except

  end;
end;

procedure TfrmOption.ButtonDelItemClick(Sender: TObject);
var
  ListItem: TListItem;
begin
  ListItem := ListViewItemList.Selected;
  if ListItem <> nil then begin
    GameEngine.m_ShowItemList.Delete(ListItem.Caption);
    ListViewItemList.DeleteSelected;
    GameEngine.AddChatBoardString('删除成功！！！', c_White, c_Red);
  end;
end;

procedure TfrmOption.ButtonDelMagicLockClick(Sender: TObject);
begin
  ListBoxMagicLock.DeleteSelected;
  GameEngine.m_MagicLockList.Clear;
  GameEngine.m_MagicLockList.AddStrings(ListBoxMagicLock.Items);
  ButtonSaveMagicLock.Enabled := True;
end;

procedure TfrmOption.ButtonDelSayMsgClick(Sender: TObject);
var
  sMsg: string;
begin
  if (ListBoxSayMsg.ItemIndex >= 0) and (ListBoxSayMsg.ItemIndex < ListBoxSayMsg.Items.Count) then begin
    sMsg := ListBoxSayMsg.Items.strings[ListBoxSayMsg.ItemIndex];
    if GameEngine.DelSayMsg(sMsg) then begin
      GameEngine.AddChatBoardString('删除成功！！！', c_White, c_Red);
      ListBoxSayMsg.Clear;
      ListBoxSayMsg.Items.AddStrings(GameEngine.m_SayMsgList);
      AutoAnswerMsg.Items.Clear;
      AutoAnswerMsg.Items.AddStrings(GameEngine.m_SayMsgList);
      ButtonSaveSayMsg.Enabled := True;
    end;
  end;
end;

procedure TfrmOption.ButtonAddItemClick(Sender: TObject);
var
  I: Integer;
  ListItem: TListItem;
  ShowItem: pTShowItem;
  sItemName: string;
begin
  sItemName := EditItemName.Text;
  if sItemName = '' then begin
    GameEngine.AddChatBoardString('请输入物品名称！！！', c_White, c_Red);
    Exit;
  end;
  New(ShowItem);
  ShowItem.sItemName := sItemName;
  ShowItem.ItemType := TItemType(ComboBoxItemType.Items.Objects[ComboBoxItemType.ItemIndex]);
  //ShowItem.boShowName := CheckShowItemName.Checked;
  ShowItem.boPickup := CheckPickUpItem.Checked;
  ShowItem.boHintMsg := CheckItemHint.Checked;
  ShowItem.boMovePick := CheckBoxMovePick.Checked;
  //ShowItem.boSpecial := CheckItemHint2.Checked;
  //ShowItem.btColor := EditItemNameColor.Value;
  if GameEngine.m_ShowItemList.Add(ShowItem) then begin
    AddItemToView(ShowItem);
    GameEngine.AddChatBoardString('添加成功！！！', c_White, c_Red);
  end else begin
    Dispose(ShowItem);
    GameEngine.AddChatBoardString('[失败]此物品已经添加！！！', c_White, c_Red);
    ShowItem := GameEngine.m_ShowItemList.Find(sItemName);
    if ShowItem <> nil then begin
      ComboBoxItemType.ItemIndex := Integer(ShowItem.ItemType);
      ComboBoxItemTypeSelect(Self);
      for I := 0 to ListViewItemList.Items.Count - 1 do begin
        ListItem := ListViewItemList.Items.Item[I];
        if ListItem.Caption = sItemName then begin
          //ListViewItemList.Selected := ListItem;
          ListViewItemList.ItemIndex := I;
          Break;
        end;
      end;
    end;
  end;
end;

procedure TfrmOption.ButtonAddMagicLockClick(Sender: TObject);
begin
  if GameEngine.GetMagicLock(ComboBoxMagicLock.Text) then begin
    GameEngine.AddChatBoardString('已经存在！！！', c_White, c_Red);
    Exit;
  end;
  GameEngine.m_MagicLockList.Add(ComboBoxMagicLock.Text);
  ListBoxMagicLock.Items.Clear;
  ListBoxMagicLock.Items.AddStrings(GameEngine.m_MagicLockList);
end;

procedure TfrmOption.ButtonAddSayMsgClick(Sender: TObject);
var
  sMsg: string;
begin
  sMsg := EditSayMsg.Text;
  if GameEngine.GetSayMsg(sMsg) then begin
    GameEngine.AddChatBoardString('已经存在！！！', c_White, c_Red);
    Exit;
  end;
  GameEngine.m_SayMsgList.Add(sMsg);
  GameEngine.AddChatBoardString('添加成功！！！', c_White, c_Red);
  ListBoxSayMsg.Items.Clear;
  ListBoxSayMsg.Items.AddStrings(GameEngine.m_SayMsgList);
  AutoAnswerMsg.Items.Clear;
  AutoAnswerMsg.Items.AddStrings(GameEngine.m_SayMsgList);
  ButtonSaveSayMsg.Enabled := True;
end;

procedure TfrmOption.ButtonBaseSaveClick(Sender: TObject);
begin
  GameEngine.SaveConfig('');
  ButtonBaseSave.Enabled := False;
end;

procedure TfrmOption.ButtonSaveItemsClick(Sender: TObject);
begin
  GameEngine.Config.sMoveCmd := EditMoveCmd.Text;
  GameEngine.Config.dwMoveTime := EditMoveTime.Value;
  GameEngine.SaveConfig('');
  ButtonSaveItems.Enabled := False;
  GameEngine.SaveShowItemList;
  ButtonSaveItems.Enabled := True;
  GameEngine.AddChatBoardString('保存成功！！！', c_White, c_Red);
end;

procedure TfrmOption.ButtonSaveMagicLockClick(Sender: TObject);
begin
  GameEngine.SaveConfig('');
  ButtonSaveMagicLock.Enabled := False;
end;

procedure TfrmOption.ButtonSaveSayMsgClick(Sender: TObject);
begin
  GameEngine.SaveConfig('');
  ButtonSaveSayMsg.Enabled := False;
end;

procedure TfrmOption.CheckItemHintClick(Sender: TObject);
var
  ListItem: TListItem;
  ShowItem: pTShowItem;
begin
  try
    ListItem := ListViewItemList.Selected;
    if ListItem <> nil then begin
      ShowItem := GameEngine.m_ShowItemList.Find(ListItem.Caption);
      //ShowItem := pTShowItem(ListItem.SubItems.Objects[0]);
      if ShowItem <> nil then begin
        if Sender = CheckPickUpItem then begin
          ShowItem.boPickup := CheckPickUpItem.Checked;
        end else
          if Sender = CheckItemHint then begin
          ShowItem.boHintMsg := CheckItemHint.Checked;
        end else
          if Sender = CheckBoxMovePick then begin
          ShowItem.boMovePick := CheckBoxMovePick.Checked;
        end;
        ListItem.SubItems.Strings[0] := BooleanToStr(ShowItem.boPickup);
        ListItem.SubItems.Strings[1] := BooleanToStr(ShowItem.boHintMsg);
        ListItem.SubItems.Strings[2] := BooleanToStr(ShowItem.boMovePick);
      end;
    end;
  except

  end;
end;

procedure TfrmOption.CheckHintBossXYClick(Sender: TObject);
var
  ListItem: TListItem;
  ShowBoss: pTShowBoss;
begin
  try
    ListItem := ListViewBossList.Selected;
    if ListItem <> nil then begin
      ShowBoss := GameEngine.m_ShowBossList.Find(ListItem.Caption);
      if ShowBoss <> nil then begin
      //ShowBoss := pTShowBoss(ListItem.SubItems.Objects[0]);
        ShowBoss.boHintMsg := CheckHintBossXY.Checked;
        ListItem.SubItems.Strings[0] := BooleanToStr(ShowBoss.boHintMsg);
      end;
    end;
  except

  end;
end;

procedure TfrmOption.CheckBoxHumChangeStateClick(Sender: TObject);
begin
  ComboBoxHumChangeState.Enabled := CheckBoxHumChangeState.Checked;
  GameEngine.Config.boHumStateKey := CheckBoxHumChangeState.Checked;
  ButtonHumOptionSave.Enabled := True;
end;

procedure TfrmOption.ComboBoxItemTypeSelect(Sender: TObject);
var
  I: Integer;
  ItemList: TList;
begin
  ListViewItemList.Items.Clear;
  ItemList := TList.Create;
  GameEngine.m_ShowItemList.Get(TItemType(ComboBoxItemType.Items.Objects[ComboBoxItemType.ItemIndex]), ItemList);
  for I := 0 to ItemList.Count - 1 do begin
    AddItemToView(pTShowItem(ItemList.Items[I]));
  end;
  ItemList.Free;
end;

procedure TfrmOption.Timer1Timer(Sender: TObject);
var
  I: Integer;
  Actor: TActor;
begin
  if GameEngine.m_MySelf <> nil then begin
    Label2.Caption := Format('人物 HP:%d/%d' + #10#13 + '     MP:%d/%d', [GameEngine.HumHP, GameEngine.HumMaxHP, GameEngine.HumMP, GameEngine.HumMaxMP]);
  end;
  if GameEngine.m_MyHero <> nil then begin
    Label3.Caption := Format('英雄 HP:%d/%d' + #10#13 + '     MP:%d/%d', [GameEngine.HeroHP, GameEngine.HeroMaxHP, GameEngine.HeroMP, GameEngine.HeroMaxMP]);
  end;
 { Memo3.Lines.Clear;
  for I := 0 to GameEngine.m_ActorList.Count - 1 do begin
    Actor := TActor(GameEngine.m_ActorList.Items[I]);
    Memo3.Lines.Add(Format('%s %d %d', [Actor.m_sUserName, Actor.m_nCurrX, Actor.m_nCurrY]));
  end; }
end;

procedure TfrmOption.ButtonSaveFilterItemClick(Sender: TObject);
var
  I: Integer;
begin
  GameEngine.m_ItemFilterList.Clear;
  GameEngine.m_ItemFilterList.AddStrings(MemoFilterItem.Lines);
  for I := GameEngine.m_ItemFilterList.Count - 1 downto 0 do begin
    if GameEngine.m_ItemFilterList.Strings[I] = '' then begin
      GameEngine.m_ItemFilterList.Delete(I);
      Continue;
    end;
  end;

  GameEngine.SaveConfig('');
  ButtonSaveFilterItem.Enabled := False;
end;

procedure TfrmOption.CheckBoxFilterItemClick(Sender: TObject);
begin
  GameEngine.Config.boFilterShowItem := CheckBoxFilterItem.Checked;
  ButtonSaveFilterItem.Enabled := True;
end;

procedure TfrmOption.MemoFilterItemChange(Sender: TObject);
begin
  ButtonSaveFilterItem.Enabled := True;
end;

procedure TfrmOption.MemoFilterItemMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  StatusBar.Panels[0].Text := '加入过滤列表中的物品，不会在地面显示';
end;

procedure TfrmOption.PageControlMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  StatusBar.Panels[0].Text := '';
end;

procedure TfrmOption.CheckBoxAutoUseItemClick(Sender: TObject);
begin
  GameEngine.Config.boAutoUseItem := CheckBoxAutoUseItem.Checked;
  ButtonBaseSave.Enabled := True;
end;

procedure TfrmOption.EditAutoUseItemChange(Sender: TObject);
begin
  GameEngine.Config.nAutoUseItem := EditAutoUseItem.Value;
  ButtonBaseSave.Enabled := True;
end;

procedure TfrmOption.ComboBoxAutoUseItemSelect(Sender: TObject);
begin
  GameEngine.Config.sAutoUseItem := ComboBoxAutoUseItem.Text;
  ButtonBaseSave.Enabled := True;
end;

end.

