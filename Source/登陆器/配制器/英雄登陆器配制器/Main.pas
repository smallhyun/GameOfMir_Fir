unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, RzLabel, RzButton, StdCtrls, Mask, RzEdit,
  RzBtnEdt, OleCtrls, SHDocVw, EncryptUnit, HUtil32, RzRadGrp, RzStatus, RzBmpBtn, Jpeg, Share,
  RzRadChk, IniFiles, RzLstBox, RzTabs, ComCtrls, RzListVw, RzCmboBx,
  uDragFromShell, MD5EncodeStr, DBTables, Grobal2, Spin, Grids, RzGrids;

type
  TfrmMain = class(TForm)
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    TimerStart: TTimer;
    RzPageControl: TRzPageControl;
    TabSheet1: TRzTabSheet;
    TabSheet2: TRzTabSheet;
    RzGroupBox1: TRzGroupBox;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    RzLabel8: TRzLabel;
    RzLabel9: TRzLabel;
    EditGameLoginFile: TRzButtonEdit;
    EditMirClientFile: TRzButtonEdit;
    EditDataFile: TRzButtonEdit;
    EditBackImage: TRzButtonEdit;
    RzGroupBox3: TRzGroupBox;
    ListBox: TListBox;
    RzGroupBox2: TRzGroupBox;
    RzLabel3: TRzLabel;
    RzLabel4: TRzLabel;
    RzLabel5: TRzLabel;
    RzLabel6: TRzLabel;
    RzLabel7: TRzLabel;
    RzLabel11: TRzLabel;
    EditName: TRzEdit;
    EditHomePage: TRzEdit;
    EditGameList: TRzEdit;
    EditConfig: TRzEdit;
    RadioGroup: TRzRadioGroup;
    EditCheckProcesses: TRzEdit;
    RzButtonGameLoginOption: TRzButton;
    RzCheckBoxShowFullScreen: TRzCheckBox;
    ButtonOK: TRzButton;
    RzButtonSaveConfig: TRzButton;
    ButtonClose: TRzButton;
    TabSheet3: TRzTabSheet;
    TabSheet4: TRzTabSheet;
    RzListBox: TRzListBox;
    RzRadioGroup: TRzRadioGroup;
    RzButtonBackOption: TRzButton;
    RzButtonLoadOption: TRzButton;
    RzButtonSaveOption: TRzButton;
    ListViewBindItem: TRzListView;
    RzRadioGroupItemType: TRzRadioGroup;
    RzLabel10: TRzLabel;
    EditItemName: TRzEdit;
    EditBindItemName: TRzEdit;
    RzLabel12: TRzLabel;
    ButtonBindAdd: TRzButton;
    ButtonBindDel: TRzButton;
    ButtonBindSave: TRzButton;
    ButtonBindChg: TRzButton;
    ListViewFilterItem: TRzListView;
    EditFilterItemName: TRzEdit;
    RzLabel13: TRzLabel;
    ButtonFilterAdd: TRzButton;
    ButtonFilterChg: TRzButton;
    ButtonFilterDel: TRzButton;
    ButtonFilterSave: TRzButton;
    RzLabel14: TRzLabel;
    RzComboBoxItemFilter: TRzComboBox;
    RzCheckGroupItemFilter: TRzCheckGroup;
    TabSheet6: TRzTabSheet;
    MemoUpgrade: TMemo;
    RadioGroup1: TRadioGroup;
    Label11: TLabel;
    Label13: TLabel;
    LabelMD5: TLabel;
    Label14: TLabel;
    EditMD5: TEdit;
    EditDownLoadAddr: TEdit;
    ComboBox: TComboBox;
    EditFileName: TEdit;
    ButtonUpgradeSave: TButton;
    ButtonUpgradeLoad: TButton;
    ButtonUpgradeCreate: TButton;
    ButtonUpgradeOpen: TButton;
    ButtonUpgradeAdd: TButton;
    Label12: TLabel;
    RzButtonFromDB: TRzButton;
    RzStatusBar: TRzStatusBar;
    RzStatusPane1: TRzStatusPane;
    ProgressBar: TProgressBar;
    EditItemNameColor: TSpinEdit;
    Label3: TLabel;
    LabelItemNameColor: TLabel;
    TabSheet7: TRzTabSheet;
    RzLabel20: TRzLabel;
    EditItemDescName: TRzEdit;
    ButtonItemDescFromDB: TRzButton;
    ButtonItemDescAdd: TRzButton;
    ButtonItemDescChg: TRzButton;
    ButtonItemDescDel: TRzButton;
    ButtonItemDescSave: TRzButton;
    RzLabel21: TRzLabel;
    EditItemDesc: TRzEdit;
    ListViewItemDesc: TRzListView;
    ButtonDelNotDescItem: TRzButton;
    Label1: TLabel;
    EditPassword: TRzEdit;
    procedure ButtonOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure EditGameLoginFileButtonClick(Sender: TObject);
    procedure EditMirClientFileButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RzButtonGameLoginOptionClick(Sender: TObject);
    procedure TimerStartTimer(Sender: TObject);
    procedure RzButtonSaveConfigClick(Sender: TObject);
    procedure EditDataFileButtonClick(Sender: TObject);
    procedure EditBackImageButtonClick(Sender: TObject);
    procedure RzListBoxClick(Sender: TObject);
    procedure RzRadioGroupClick(Sender: TObject);
    procedure RzButtonBackOptionClick(Sender: TObject);
    procedure RzButtonLoadOptionClick(Sender: TObject);
    procedure RzButtonSaveOptionClick(Sender: TObject);
    procedure ListViewBindItemClick(Sender: TObject);
    procedure ButtonBindAddClick(Sender: TObject);
    procedure ButtonBindChgClick(Sender: TObject);
    procedure ButtonBindDelClick(Sender: TObject);
    procedure ButtonBindSaveClick(Sender: TObject);
    procedure ButtonFilterAddClick(Sender: TObject);
    procedure ButtonFilterChgClick(Sender: TObject);
    procedure ButtonFilterDelClick(Sender: TObject);
    procedure ButtonFilterSaveClick(Sender: TObject);
    procedure ListViewFilterItemClick(Sender: TObject);
    procedure RzComboBoxItemFilterChange(Sender: TObject);
    procedure ButtonUpgradeAddClick(Sender: TObject);
    procedure ButtonUpgradeOpenClick(Sender: TObject);
    procedure ButtonUpgradeCreateClick(Sender: TObject);
    procedure ButtonUpgradeLoadClick(Sender: TObject);
    procedure ButtonUpgradeSaveClick(Sender: TObject);
    procedure RzButtonFromDBClick(Sender: TObject);
    procedure EditItemNameColorChange(Sender: TObject);
    procedure ButtonItemDescFromDBClick(Sender: TObject);
    procedure ButtonItemDescSaveClick(Sender: TObject);
    procedure ButtonItemDescAddClick(Sender: TObject);
    procedure ButtonItemDescChgClick(Sender: TObject);
    procedure ButtonItemDescDelClick(Sender: TObject);
    procedure ButtonDelNotDescItemClick(Sender: TObject);
    procedure ListViewItemDescClick(Sender: TObject);
  private
    { Private declarations }
    DragFromShell: TDragFromShell;
    procedure DropFiles(Sender: Tobject; Filename: string);
    procedure LoadConfig;
    procedure SaveConfig;
    procedure RefOption(Config: pTClientConfig);
    procedure RefListViewBindItem;
    procedure SetItemAttr(Attr: Integer);
    function GetItemAttr: Integer;
    procedure RefListViewFilterItem(ItemType: TFilterItemType);
    procedure RefListViewItemDesc;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  g_nPercent: Integer;
  g_nCount: Integer;
  g_PlugList: TStringList;
implementation

uses GameLogin, ZLibEx, LoadFromDB, Objects;

{$R *.dfm}

function GetRGB(c256: Byte): Integer;
begin
  Result := RGB(ColorTable[c256].rgbRed,
    ColorTable[c256].rgbGreen,
    ColorTable[c256].rgbBlue);
end;

procedure UnLoadFilterItemList;
var
  I: Integer;
begin
  if g_FilterItemList = nil then Exit;
  for I := 0 to g_FilterItemList.Count - 1 do begin
    Dispose(pTFilterItem(g_FilterItemList.Items[I]));
  end;
  FreeAndNil(g_FilterItemList);
end;

procedure LoadFilterItemList;
var
  I: Integer;
  LoadList: TStringList;
  sFileName: string;
  FilterItem: pTFilterItem;
  sLineText, sItemType, sItemName, sHint, sPick, sShow: string;
  nType: Integer;
begin
  UnLoadFilterItemList;
  g_FilterItemList := TList.Create;
  sFileName := ExtractFilePath(Application.ExeName) + 'FilterItemList.txt';

  LoadList := TStringList.Create;
  {if FileExists(sFileName) then begin
    try
      LoadList.LoadFromFile(sFileName);
    except
      LoadList.Clear;
    end;
  end else begin
    LoadList.Add('0' + #9 + '金创药(中量)' + #9 + '金创药(中)包');
    LoadList.Add('1' + #9 + '魔法药(中量)' + #9 + '魔法药(中)包');
    LoadList.Add('0' + #9 + '强效金创药' + #9 + '超级金创药');
    LoadList.Add('1' + #9 + '强效魔法药' + #9 + '超级魔法药');
    LoadList.Add('2' + #9 + '太阳水' + #9 + '太阳水');
    LoadList.Add('2' + #9 + '强效太阳水' + #9 + '强效太阳水');
    LoadList.Add('2' + #9 + '疗伤药' + #9 + '疗伤药包');
    LoadList.Add('2' + #9 + '万年雪霜' + #9 + '雪霜包');
    LoadList.SaveToFile(sFileName);
  end;}
  if FileExists(sFileName) then begin
    try
      LoadList.LoadFromFile(sFileName);
    except
      LoadList.Clear;
    end;
    for I := 0 to LoadList.Count - 1 do begin
      sLineText := Trim(LoadList.Strings[I]);
      if sLineText = '' then Continue;
      if (sLineText <> '') and (sLineText[1] = ';') then Continue;
      sLineText := GetValidStr3(sLineText, sItemType, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sItemName, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sHint, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sPick, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sShow, [' ', #9]);
      nType := Str_ToInt(sItemType, -1);
      if (nType in [0..6]) and (sItemName <> '') then begin
        New(FilterItem);
        FilterItem.ItemType := TFilterItemType(nType);
        FilterItem.sItemName := sItemName;
        FilterItem.boHintMsg := sHint = '1';
        FilterItem.boPickup := sPick = '1';
        FilterItem.boShowName := sShow = '1';
        g_FilterItemList.Add(FilterItem);
      end;
    end;
  end;
  LoadList.Free;
end;

procedure SaveFilterItemList;
var
  I: Integer;
  SaveList: TStringList;
  sFileName: string;
  FilterItem: pTFilterItem;
begin
  if g_FilterItemList = nil then Exit;
  SaveList := TStringList.Create;
  for I := 0 to g_FilterItemList.Count - 1 do begin
    FilterItem := pTFilterItem(g_FilterItemList.Items[I]);
    SaveList.Add(IntToStr(Integer(FilterItem.ItemType)) + #9 + FilterItem.sItemName + #9 +
      IntToStr(BoolToInt(FilterItem.boHintMsg)) + #9 + IntToStr(BoolToInt(FilterItem.boPickup)) + #9 + IntToStr(BoolToInt(FilterItem.boShowName)));
  end;
  sFileName := ExtractFilePath(Application.ExeName) + 'FilterItemList.txt';
  //sFileName := CreateUserDirectory + 'FilterItemList.Dat';
  SaveList.SaveToFile(sFileName);
  SaveList.Free;
end;

function GetFilterItemListText: string;
var
  I: Integer;
  SaveList: TStringList;
  FilterItem: pTFilterItem;
begin
  Result := '';
  if g_FilterItemList = nil then Exit;
  SaveList := TStringList.Create;
  for I := 0 to g_FilterItemList.Count - 1 do begin
    FilterItem := pTFilterItem(g_FilterItemList.Items[I]);
    SaveList.Add(IntToStr(Integer(FilterItem.ItemType)) + #9 + FilterItem.sItemName + #9 +
      IntToStr(BoolToInt(FilterItem.boHintMsg)) + #9 + IntToStr(BoolToInt(FilterItem.boPickup)) + #9 + IntToStr(BoolToInt(FilterItem.boShowName)));
  end;
  Result := SaveList.Text;
  SaveList.Free;
end;

function FindFilterItemName(sItemName: string): string;
var
  I: Integer;
begin
  Result := '';
  if g_FilterItemList = nil then Exit;
  for I := 0 to g_FilterItemList.Count - 1 do begin
    if CompareText(pTFilterItem(g_FilterItemList.Items[I]).sItemName, sItemName) = 0 then begin
      Result := pTFilterItem(g_FilterItemList.Items[I]).sItemName;
      Break;
    end;
  end;
end;

{-------------------------------------------------------------------------------}

procedure UnLoadItemDescList;
var
  I: Integer;
begin
  if g_ItemDescList = nil then Exit;
  for I := 0 to g_ItemDescList.Count - 1 do begin
    Dispose(pTItemDesc(g_ItemDescList.Items[I]));
  end;
  FreeAndNil(g_ItemDescList);
end;

procedure LoadItemDescList;
var
  I: Integer;
  LoadList: TStringList;
  sFileName: string;
  ItemDesc: pTItemDesc;
  sLineText, sItemName: string;
begin
  UnLoadItemDescList;
  g_ItemDescList := TList.Create;
  sFileName := ExtractFilePath(Application.ExeName) + 'ItemDescList.txt';

  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    try
      LoadList.LoadFromFile(sFileName);
    except
      LoadList.Clear;
    end;
    for I := 0 to LoadList.Count - 1 do begin
      sLineText := Trim(LoadList.Strings[I]);
      if sLineText = '' then Continue;
      if (sLineText <> '') and (sLineText[1] = ';') then Continue;
      sLineText := GetValidStr3(sLineText, sItemName, ['=', #9]);
      if (sItemName <> '') then begin
        New(ItemDesc);
        ItemDesc.Name := sItemName;
        ItemDesc.Desc := sLineText;
        g_ItemDescList.Add(ItemDesc);
      end;
    end;
  end;
  LoadList.Free;
end;

procedure SaveItemDescList;
var
  I: Integer;
  SaveList: TStringList;
  sFileName: string;
  ItemDesc: pTItemDesc;
begin
  if g_ItemDescList = nil then Exit;
  SaveList := TStringList.Create;
  for I := 0 to g_ItemDescList.Count - 1 do begin
    ItemDesc := pTItemDesc(g_ItemDescList.Items[I]);
    SaveList.Add(ItemDesc.Name + '=' + ItemDesc.Desc);
  end;
  sFileName := ExtractFilePath(Application.ExeName) + 'ItemDescList.txt';
  //sFileName := CreateUserDirectory + 'ItemDescList.Dat';
  SaveList.SaveToFile(sFileName);
  SaveList.Free;
end;

function GetItemDescListText: string;
var
  I: Integer;
  SaveList: TStringList;
  ItemDesc: pTItemDesc;
begin
  Result := '';
  if g_ItemDescList = nil then Exit;
  SaveList := TStringList.Create;
  for I := 0 to g_ItemDescList.Count - 1 do begin
    ItemDesc := pTItemDesc(g_ItemDescList.Items[I]);
    SaveList.Add(ItemDesc.Name + '=' + ItemDesc.Desc);
  end;
  Result := SaveList.Text;
  SaveList.Free;
end;

function FindItemDesc(sItemName: string): string;
var
  I: Integer;
begin
  Result := '';
  if g_ItemDescList = nil then Exit;
  for I := 0 to g_ItemDescList.Count - 1 do begin
    if CompareText(pTItemDesc(g_ItemDescList.Items[I]).Name, sItemName) = 0 then begin
      Result := pTItemDesc(g_ItemDescList.Items[I]).Desc;
      Break;
    end;
  end;
end;

function FindItemDescName(sItemName: string): string;
var
  I: Integer;
begin
  Result := '';
  if g_ItemDescList = nil then Exit;
  for I := 0 to g_ItemDescList.Count - 1 do begin
    if CompareText(pTItemDesc(g_ItemDescList.Items[I]).Name, sItemName) = 0 then begin
      Result := pTItemDesc(g_ItemDescList.Items[I]).Name;
      Break;
    end;
  end;
end;
{-------------------------------------------------------------------------------}

procedure UnLoadBindItemList;
var
  I: Integer;
begin
  if g_UnbindItemList = nil then Exit;
  for I := 0 to g_UnbindItemList.Count - 1 do begin
    Dispose(pTBindItem(g_UnbindItemList.Items[I]));
  end;
  FreeAndNil(g_UnbindItemList);
end;

procedure LoadBindItemList;
var
  I: Integer;
  LoadList: TStringList;
  sFileName: string;
  BindItem: pTBindItemFile;
  sLineText, sType, sItemName, sBindItemName: string;
  nType: Integer;
begin
  UnLoadBindItemList;
  g_UnbindItemList := TList.Create;
  sFileName := ExtractFilePath(Application.ExeName) + 'BindItemList.txt';

  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    try
      LoadList.LoadFromFile(sFileName);
    except
      LoadList.Clear;
    end;
  end else begin
    LoadList.Add('0' + #9 + '金创药(中量)' + #9 + '金创药(中)包');
    LoadList.Add('1' + #9 + '魔法药(中量)' + #9 + '魔法药(中)包');
    LoadList.Add('0' + #9 + '强效金创药' + #9 + '超级金创药');
    LoadList.Add('1' + #9 + '强效魔法药' + #9 + '超级魔法药');
    LoadList.Add('2' + #9 + '太阳水' + #9 + '太阳水');
    LoadList.Add('2' + #9 + '强效太阳水' + #9 + '强效太阳水');
    LoadList.Add('2' + #9 + '疗伤药' + #9 + '疗伤药包');
    LoadList.Add('2' + #9 + '万年雪霜' + #9 + '雪霜包');
    LoadList.SaveToFile(sFileName);
  end;
  for I := 0 to LoadList.Count - 1 do begin
    sLineText := Trim(LoadList.Strings[I]);
    if sLineText = '' then Continue;
    if (sLineText <> '') and (sLineText[1] = ';') then Continue;
    sLineText := GetValidStr3(sLineText, sType, [' ', #9]);
    sLineText := GetValidStr3(sLineText, sItemName, [' ', #9]);
    sLineText := GetValidStr3(sLineText, sBindItemName, [' ', #9]);
    nType := Str_ToInt(sType, -1);
    if (nType in [0..3]) and (sItemName <> '') and (sBindItemName <> '') then begin
      New(BindItem);
      BindItem.btItemType := nType;
      BindItem.sItemName := sItemName;
      BindItem.sBindItemName := sBindItemName;
      g_UnbindItemList.Add(BindItem);
    end;
  end;
  LoadList.Free;
end;

procedure SaveBindItemList;
var
  I: Integer;
  SaveList: TStringList;
  sFileName: string;
  BindItem: pTBindItemFile;
begin
  if g_UnbindItemList = nil then Exit;
  SaveList := TStringList.Create;
  for I := 0 to g_UnbindItemList.Count - 1 do begin
    BindItem := pTBindItemFile(g_UnbindItemList.Items[I]);
    SaveList.Add(IntToStr(BindItem.btItemType) + #9 + BindItem.sItemName + #9 + BindItem.sBindItemName);
  end;
  sFileName := ExtractFilePath(Application.ExeName) + 'BindItemList.txt';
  //sFileName := CreateUserDirectory + 'BindItemList.Dat';
  SaveList.SaveToFile(sFileName);
  SaveList.Free;
end;

function GetBindItemListText: string;
var
  I: Integer;
  SaveList: TStringList;
  BindItem: pTBindItemFile;
begin
  Result := '';
  if g_UnbindItemList = nil then Exit;
  SaveList := TStringList.Create;
  for I := 0 to g_UnbindItemList.Count - 1 do begin
    BindItem := pTBindItemFile(g_UnbindItemList.Items[I]);
    SaveList.Add(IntToStr(BindItem.btItemType) + #9 + BindItem.sItemName + #9 + BindItem.sBindItemName);
  end;
  Result := SaveList.Text;
  SaveList.Free;
end;

function FindBindItemName(sItemName: string): string;
var
  I: Integer;
begin
  Result := '';
  if g_UnbindItemList = nil then Exit;
  for I := 0 to g_UnbindItemList.Count - 1 do begin
    if CompareText(pTBindItemFile(g_UnbindItemList.Items[I]).sItemName, sItemName) = 0 then begin
      Result := pTBindItemFile(g_UnbindItemList.Items[I]).sBindItemName;
      Break;
    end;
  end;
end;

function FindUnBindItemName(sItemName: string): string;
var
  I: Integer;
begin
  Result := '';
  if g_UnbindItemList = nil then Exit;
  for I := 0 to g_UnbindItemList.Count - 1 do begin
    if CompareText(pTBindItemFile(g_UnbindItemList.Items[I]).sItemName, sItemName) = 0 then begin
      Result := pTBindItemFile(g_UnbindItemList.Items[I]).sItemName;
      Break;
    end;
  end;
end;

function GetFilterItemType(ItemType: TFilterItemType): string;
begin
  case ItemType of
    i_Other: Result := '其它类';
    i_HPMPDurg: Result := '药品类';
    i_Dress: Result := '服装类';
    i_Weapon: Result := '武器类';
    i_Jewelry: Result := '首饰类';
    i_Decoration: Result := '饰品类';
    i_Decorate: Result := '装饰类';
  end;
end;

function GetBindItemType(btType: Byte): string;
begin
  Result := '';
  case btType of
    0: Result := 'HP';
    1: Result := 'MP';
    2: Result := 'HPMP';
    3: Result := '特殊药品';
  end;
end;

procedure TFrmMain.RefListViewBindItem;
var
  I: Integer;
  ListItem: TListItem;
  BindItem: pTBindItemFile;
begin
  ListViewBindItem.Items.Clear;

  for I := 0 to g_UnbindItemList.Count - 1 do begin
    ListItem := ListViewBindItem.Items.Add;
    BindItem := pTBindItemFile(g_UnbindItemList.Items[I]);

    ListItem.Caption := GetBindItemType(BindItem.btItemType);
    ListItem.SubItems.AddObject(BindItem.sItemName, TObject(BindItem));
    ListItem.Data := BindItem;
    ListItem.SubItems.Add(BindItem.sBindItemName);
  end;
end;

procedure TFrmMain.RefListViewFilterItem(ItemType: TFilterItemType);
var
  I: Integer;
  ListItem: TListItem;
  FilterItem: pTFilterItem;
begin
  ListViewFilterItem.Clear;
  for I := 0 to g_FilterItemList.Count - 1 do begin
    FilterItem := pTFilterItem(g_FilterItemList.Items[I]);
    if (ItemType = i_All) or (FilterItem.ItemType = ItemType) then begin
      ListItem := ListViewFilterItem.Items.Add;
      ListItem.Caption := GetFilterItemType(FilterItem.ItemType);
      ListItem.SubItems.AddObject(FilterItem.sItemName, TObject(FilterItem));
      ListItem.Data := FilterItem;
      ListItem.SubItems.Add(BooleanToStr(FilterItem.boHintMsg));
      ListItem.SubItems.Add(BooleanToStr(FilterItem.boPickup));
      ListItem.SubItems.Add(BooleanToStr(FilterItem.boShowName));
    end;
  end;
end;

procedure TFrmMain.RefListViewItemDesc;
var
  I: Integer;
  ListItem: TListItem;
  ItemDesc: pTItemDesc;
begin
  ListViewItemDesc.Items.Clear;
  for I := 0 to g_ItemDescList.Count - 1 do begin
    ItemDesc := pTItemDesc(g_ItemDescList.Items[I]);
    ListItem := ListViewItemDesc.Items.Add;
    ListItem.Caption := ItemDesc.Name;
    ListItem.SubItems.AddObject(ItemDesc.Desc, TObject(ItemDesc));
    ListItem.Data := ItemDesc;
  end;
end;

function TFrmMain.GetItemAttr: Integer;
begin
  Result := RzRadioGroupItemType.ItemIndex;
  {if RadioButtonHP.Checked then Result := 0
  else if RadioButtonMP.Checked then Result := 1
  else if RadioButtonHMP.Checked then Result := 2
  else if RadioButtonOther.Checked then Result := 3;}
end;

procedure TFrmMain.SetItemAttr(Attr: Integer);
begin
  RzRadioGroupItemType.ItemIndex := Attr;
  {case Attr of
    0: RadioButtonHP.Checked := True;
    1: RadioButtonMP.Checked := True;
    2: RadioButtonHMP.Checked := True;
    3: RadioButtonOther.Checked := True;
  end; }
end;

procedure TfrmMain.RefOption(Config: pTClientConfig);
var
  I: Integer;
begin
  Config.WEffectImg := TLoadMode(RzListBox.Items.Objects[0]);
  Config.WDragonImg := TLoadMode(RzListBox.Items.Objects[1]);
  Config.WMainImages := TLoadMode(RzListBox.Items.Objects[2]);
  Config.WMain2Images := TLoadMode(RzListBox.Items.Objects[3]);
  Config.WMain3Images := TLoadMode(RzListBox.Items.Objects[4]);
  Config.WChrSelImages := TLoadMode(RzListBox.Items.Objects[5]);
  Config.WMMapImages := TLoadMode(RzListBox.Items.Objects[6]);
  Config.WHumWingImages := TLoadMode(RzListBox.Items.Objects[7]);
  Config.WHum1WingImages := TLoadMode(RzListBox.Items.Objects[8]);
  Config.WHum2WingImages := TLoadMode(RzListBox.Items.Objects[9]);
  Config.WBagItemImages := TLoadMode(RzListBox.Items.Objects[10]);
  Config.WStateItemImages := TLoadMode(RzListBox.Items.Objects[1]);
  Config.WDnItemImages := TLoadMode(RzListBox.Items.Objects[12]);
  Config.WHumImgImages := TLoadMode(RzListBox.Items.Objects[13]);
  Config.WHairImgImages := TLoadMode(RzListBox.Items.Objects[14]);
  Config.WHair2ImgImages := TLoadMode(RzListBox.Items.Objects[15]);
  Config.WWeaponImages := TLoadMode(RzListBox.Items.Objects[16]);
  Config.WMagIconImages := TLoadMode(RzListBox.Items.Objects[17]);
  Config.WNpcImgImages := TLoadMode(RzListBox.Items.Objects[18]);
  Config.WFirNpcImgImages := TLoadMode(RzListBox.Items.Objects[19]);
  Config.WMagicImages := TLoadMode(RzListBox.Items.Objects[20]);
  Config.WMagic2Images := TLoadMode(RzListBox.Items.Objects[21]);
  Config.WMagic3Images := TLoadMode(RzListBox.Items.Objects[22]);
  Config.WMagic4Images := TLoadMode(RzListBox.Items.Objects[23]);
  Config.WMagic5Images := TLoadMode(RzListBox.Items.Objects[24]);
  Config.WMagic6Images := TLoadMode(RzListBox.Items.Objects[25]);
  Config.WHorseImages := TLoadMode(RzListBox.Items.Objects[26]);
  Config.WHumHorseImages := TLoadMode(RzListBox.Items.Objects[27]);
  Config.WHairHorseImages := TLoadMode(RzListBox.Items.Objects[28]);
  for I := 0 to 29 do
    Config.WMonImages[I] := TLoadMode(RzListBox.Items.Objects[I + 29]);
end;

procedure TfrmMain.LoadConfig;
var
  I: Integer;
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Make.ini');
  EditName.Text := IniFile.ReadString('Config', 'UrlName', EditName.Text);
  EditHomePage.Text := IniFile.ReadString('Config', 'HomePage', EditHomePage.Text);
  EditGameList.Text := IniFile.ReadString('Config', 'GameList', EditGameList.Text);
  EditConfig.Text := IniFile.ReadString('Config', 'UpDate', EditConfig.Text);
  EditCheckProcesses.Text := IniFile.ReadString('Config', 'CheckProcesses', EditCheckProcesses.Text);
  RadioGroup.ItemIndex := IniFile.ReadInteger('Config', 'Version', RadioGroup.ItemIndex);
  RzCheckBoxShowFullScreen.Checked := IniFile.ReadBool('Config', 'ShowFullScreen', RzCheckBoxShowFullScreen.Checked);
  EditItemNameColor.Value := IniFile.ReadInteger('Config', 'ItemColor', EditItemNameColor.Value);
  EditPassword.Text := IniFile.ReadString('Config', 'Password', EditPassword.Text);
  {EditDamageItemName1.Text := IniFile.ReadString('Config', 'DamageItemName1', EditDamageItemName1.Text);
  EditDamageItemName2.Text := IniFile.ReadString('Config', 'DamageItemName2', EditDamageItemName2.Text);
  EditDamageItemName3.Text := IniFile.ReadString('Config', 'DamageItemName3', EditDamageItemName3.Text);
  EditDamageItemName4.Text := IniFile.ReadString('Config', 'DamageItemName4', EditDamageItemName4.Text);  }
  for I := 0 to RzListBox.Items.Count - 1 do begin
    if I = 19 then
      RzListBox.Items.Objects[I] := TObject(IniFile.ReadInteger('Mode', IntToStr(I), 1))
    else
      RzListBox.Items.Objects[I] := TObject(IniFile.ReadInteger('Mode', IntToStr(I), 0));
  end;

  IniFile.Free;
end;

procedure TfrmMain.SaveConfig;
var
  I: Integer;
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Make.ini');
  IniFile.WriteString('Config', 'UrlName', EditName.Text);
  IniFile.WriteString('Config', 'HomePage', EditHomePage.Text);
  IniFile.WriteString('Config', 'GameList', EditGameList.Text);
  IniFile.WriteString('Config', 'UpDate', EditConfig.Text);
  IniFile.WriteString('Config', 'CheckProcesses', EditCheckProcesses.Text);
  IniFile.WriteInteger('Config', 'Version', RadioGroup.ItemIndex);
  IniFile.WriteBool('Config', 'ShowFullScreen', RzCheckBoxShowFullScreen.Checked);
  IniFile.WriteInteger('Config', 'ItemColor', EditItemNameColor.Value);
  IniFile.WriteString('Config', 'Password', EditPassword.Text);
  for I := 0 to RzListBox.Items.Count - 1 do begin
    IniFile.WriteInteger('Mode', IntToStr(I), Integer(RzListBox.Items.Objects[I]));
  end;

  IniFile.Free;
end;

procedure TfrmMain.ButtonOKClick(Sender: TObject);
var
  sGameLoginFile, sMirClientFile, sName, sHomePage, sGameList, sConfig, sProcesses: string;
  sDataFile, sImageFile: string;
  GameLogin: TMemoryStream;
  MirClient: TMemoryStream;

  PlugClient: TMemoryStream;



  DataFile: TMemoryStream;
  ImageFile: TMemoryStream;

  DomainNameList: TStringList;
  DomainNameFile: TDomainNameFile;

  Config: TConfig;
  Buffer: Pointer;
  //OutBuf: Pointer;
  //OutBytes: Integer;

  Count1, Count2: Integer;
  nGameLogin: Integer;
  ClientConfig: TClientConfig;
  nSize: PInteger;
  nCrc: PCardinal;
  sBuffer: string;
  nBuffer: Integer;
  nPos: Integer;
  I: Integer;

  GameLoginConfig: TGameLoginConfig;

  Image: TImage;
  Bitmap: TBitmap;
  Jpeg: TJpegImage;
  FileStream: TMemoryStream;

  nLen: Integer;
  BufferList: TList;
  SizeList: TList;
  BmpButton: TRzBmpButton;

  List: TStringList;

  OutBuf: Pointer;
  OutBytes: Integer;
  Bmp: TBitMap;
  boFindDomainName: PBoolean;

  sPassword: string;
begin
  {Bmp := TBitMap.Create;
  Bmp.Canvas.Font.Color := clRed;
  Bmp.Canvas.Font.Size := 42;
  Bmp.Canvas.Font.Name := '楷体_GB2312';
  Bmp.Canvas.Font.Style := [fsBold];

  Bmp.Canvas.Brush.Color := clWhite;
  Bmp.Height := Bmp.Canvas.TextHeight('0') + 2;
  Bmp.Width := Bmp.Canvas.TextWidth('就是要舒服 WWW.941SF.COM') + 2;
  Bmp.Canvas.TextOut(1, 1, '就是要舒服 WWW.941SF.COM');
  Bmp.SaveToFile('Bmp.Bmp');
  Bmp.Free; }

  //Showmessage(IntToStr(Length(EncryptBuffer(@DomainNameFile, SizeOf(TDomainNameFile)))));
   { if FrmGameLogin = nil then begin
    Application.MessageBox('请先配制登陆器界面 ！！！', '提示信息', MB_ICONQUESTION);
    EditGameLoginFile.SetFocus;
    Exit;
  end;  }
  New(boFindDomainName);
  sGameLoginFile := Trim(EditGameLoginFile.Text);
  sMirClientFile := Trim(EditMirClientFile.Text);
  sDataFile := Trim(EditDataFile.Text);
  sImageFile := Trim(EditBackImage.Text);
  sName := Trim(EditName.Text);
  sHomePage := Trim(EditHomePage.Text);
  sGameList := Trim(EditGameList.Text);
  sConfig := Trim(EditConfig.Text);
  sProcesses := Trim(EditCheckProcesses.Text);
  sPassword := EditPassword.Text;
  if sPassword = '' then sPassword := '123456';
  FillChar(Config, SizeOf(TConfig), #0);
  FillChar(ClientConfig, SizeOf(TClientConfig), #0);

  boFindDomainName^ := False;
  FillChar(DomainNameFile, SizeOf(TDomainNameFile), #0);
  if FileExists(g_sDomainNameFileName) then begin //读取注册域名
    sBuffer := '';
    DomainNameList := TStringList.Create;
    try
      DomainNameList.LoadFromFile(g_sDomainNameFileName);
    except

    end;
    for I := 0 to DomainNameList.Count - 1 do begin
      sBuffer := sBuffer + Trim(DomainNameList[I]);
    end;
    DomainNameList.Free;
    DecryptBuffer(sBuffer, @DomainNameFile, SizeOf(TDomainNameFile));

    if (DomainNameFile.sDomainName <> '') and (StringCrc(DomainNameFile.sDomainName) = DomainNameFile.nDomainName) and
      (DomainNameFile.boUnlimited or ((Date <= DomainNameFile.MaxDate) and (Date >= DomainNameFile.MinDate))) then begin
      boFindDomainName^ := True;
    //ImageFile.LoadFromFile(sImageFile);
    end else begin
      SafeFillChar(DomainNameFile, SizeOf(TDomainNameFile), #0);

    //DomainNameFile.sDomainName := '';
   // DomainNameFile.nDomainName := 0;
   // FillChar(DomainNameFile.DomainNameArray, SizeOf(TDomainNameArray), #0);

    {Bmp := TBitMap.Create;
    Bmp.Canvas.Font.Color := clRed;
    Bmp.Canvas.Font.Size := 42;
    Bmp.Canvas.Font.Name := '楷体_GB2312';
    Bmp.Canvas.Font.Style := [fsBold];

    Bmp.Canvas.Brush.Color := clWhite;
    Bmp.Height := Bmp.Canvas.TextHeight('0') + 2;
    Bmp.Width := Bmp.Canvas.TextWidth(DecryptString(BmpStr)) + 2;
    Bmp.Canvas.TextOut(1, 1, DecryptString(BmpStr));

    Bmp.SaveToStream(ImageFile);
    Bmp.Free;  }
    end;
  end;

  ClientConfig.sDomainName := EncryptString(DomainNameFile.sDomainName);
  ClientConfig.nDomainName := StringCrc(ClientConfig.sDomainName);
  ClientConfig.sPassword := sPassword;

  if not FileExists(sGameLoginFile) then begin
    Dispose(boFindDomainName);
    Application.MessageBox('请选择正确的GameLogin文件 ！！！', '提示信息', MB_ICONQUESTION);
    EditGameLoginFile.SetFocus;
    Exit;
  end;
  if not FileExists(sMirClientFile) then begin
    Dispose(boFindDomainName);
    Application.MessageBox('请选择正确的MirClient文件 ！！！', '提示信息', MB_ICONQUESTION);
    EditMirClientFile.SetFocus;
    Exit;
  end;
  if not FileExists(sDataFile) then begin
    Dispose(boFindDomainName);
    Application.MessageBox('请选择正确的界面文件 ！！！', '提示信息', MB_ICONQUESTION);
    EditDataFile.SetFocus;
    Exit;
  end;
  if boFindDomainName^ and (not FileExists(sImageFile)) then begin
    Dispose(boFindDomainName);
    Application.MessageBox('请选择正确的背景图片 ！！！', '提示信息', MB_ICONQUESTION);
    EditBackImage.Enabled := True;
    EditBackImage.SetFocus;
    Exit;
  end;
  if sName = '' then begin
    Dispose(boFindDomainName);
    Application.MessageBox('请输入快捷方式名称 ！！！', '提示信息', MB_ICONQUESTION);
    EditName.SetFocus;
    Exit;
  end;
  if sHomePage = '' then begin
    Dispose(boFindDomainName);
    Application.MessageBox('请输入官方网站地址 ！！！', '提示信息', MB_ICONQUESTION);
    EditHomePage.SetFocus;
    Exit;
  end;
  if sGameList = '' then begin
    Dispose(boFindDomainName);
    Application.MessageBox('请输入远程列表地址 ！！！', '提示信息', MB_ICONQUESTION);
    EditGameList.SetFocus;
    Exit;
  end;
  if sConfig = '' then begin
    Dispose(boFindDomainName);
    Application.MessageBox('请输入配制文件地址 ！！！', '提示信息', MB_ICONQUESTION);
    EditConfig.SetFocus;
    Exit;
  end;

  ButtonOK.Enabled := False;
  ProgressBar.Position := 0;
  ProgressBar.Max := 13;

  GameLogin := TMemoryStream.Create;
  MirClient := TMemoryStream.Create;

  DataFile := TMemoryStream.Create;
  ImageFile := TMemoryStream.Create;

  GameLogin.LoadFromFile(sGameLoginFile);
  MirClient.LoadFromFile(sMirClientFile);
  DataFile.LoadFromFile(sDataFile);

  if boFindDomainName^ then begin
    ImageFile.LoadFromFile(sImageFile);
  end else begin
    SafeFillChar(DomainNameFile, SizeOf(TDomainNameFile), #0);

    //DomainNameFile.sDomainName := '';
   // DomainNameFile.nDomainName := 0;
   // FillChar(DomainNameFile.DomainNameArray, SizeOf(TDomainNameArray), #0);

    Bmp := TBitMap.Create;
    Bmp.Canvas.Font.Color := clRed;
    Bmp.Canvas.Font.Size := 42;
    Bmp.Canvas.Font.Name := '楷体_GB2312';
    Bmp.Canvas.Font.Style := [fsBold];

    Bmp.Canvas.Brush.Color := clWhite;
    Bmp.Height := Bmp.Canvas.TextHeight('0') + 2;
    Bmp.Width := Bmp.Canvas.TextWidth(DecryptString(BmpStr)) + 2;
    Bmp.Canvas.TextOut(1, 1, DecryptString(BmpStr));

    Bmp.SaveToStream(ImageFile);
    Bmp.Free;
  end;

  Dispose(boFindDomainName);
//======================================MirClient===============================
  ProgressBar.Position := ProgressBar.Position + 1;
  New(nSize);
  New(nCrc);

  nSize^ := MirClient.Size;
  GetMem(Buffer, nSize^);
  try
    MirClient.Seek(0, soFromBeginning);
    MirClient.Read(Buffer^, nSize^);
    nCRC^ := BufferCRC(Buffer, nSize^);
  finally
    FreeMem(Buffer);
  end;
  ClientConfig.nSize := MirClient.Size;
  ClientConfig.nCrc := nCrc^;
  ClientConfig.btMainInterface := RadioGroup.ItemIndex;
  ClientConfig.btItemColor := EditItemNameColor.Value;
  ClientConfig.boShowFullScreen := RzCheckBoxShowFullScreen.Checked;

  ClientConfig.sCheckProcessesUrl := sProcesses;
  //Showmessage(IntToStr(ClientConfig.nSize)+' ClientConfig.nCrc:'+IntToStr(ClientConfig.nCrc));
  Self.RefOption(@ClientConfig);

  for I := 0 to g_PlugList.Count - 1 do begin
    if I > 9 then break;
    if not FileExists(ExtractFilePath(ParamStr(0)) + g_PlugList.Strings[I]) then begin
      ClientConfig.PlugArr[I] := '';
    end else begin
      ClientConfig.PlugArr[I] := g_PlugList.Strings[I];
    end;
  end;
{------------------------------------------------------------------------------}
  ProgressBar.Position := ProgressBar.Position + 1;
  ClientConfig.nDataOffSet := MirClient.Size;
  if DataFile.Size > 0 then begin
    GetMem(Buffer, DataFile.Size);
    try
      DataFile.Seek(0, soFromBeginning);
      DataFile.Read(Buffer^, DataFile.Size);
      CompressBuf(Buffer, DataFile.Size, OutBuf, OutBytes);
      ClientConfig.nDataSize := OutBytes;
      MirClient.Seek(0, soFromEnd);
      MirClient.Write(OutBuf^, OutBytes);
      FreeMem(OutBuf);
    finally
      FreeMem(Buffer);
    end;
  end;
{------------------------------------------------------------------------------}
  ProgressBar.Position := ProgressBar.Position + 1;
  ClientConfig.nBackBmpOffSet := MirClient.Size;

  if ImageFile.Size > 0 then begin
    GetMem(Buffer, ImageFile.Size);
    try
      ImageFile.Seek(0, soFromBeginning);
      ImageFile.Read(Buffer^, ImageFile.Size);
      CompressBuf(Buffer, ImageFile.Size, OutBuf, OutBytes);
      ClientConfig.nBackBmpSize := OutBytes;
      MirClient.Seek(0, soFromEnd);
      MirClient.Write(OutBuf^, OutBytes);
      FreeMem(OutBuf);
    finally
      FreeMem(Buffer);
    end;
  end;
{------------------------------------------------------------------------------}
  ProgressBar.Position := ProgressBar.Position + 1;
  ClientConfig.nBindItemOffSet := MirClient.Size;

  sBuffer := GetBindItemListText;

  if sBuffer <> '' then begin
    CompressBuf(@sBuffer[1], Length(sBuffer), OutBuf, OutBytes);
    ClientConfig.nBindItemSize := OutBytes;
    MirClient.Seek(0, soFromEnd);
    MirClient.Write(OutBuf^, OutBytes);
    FreeMem(OutBuf);
  end;

{------------------------------------------------------------------------------}
  ProgressBar.Position := ProgressBar.Position + 1;
  ClientConfig.nShowItemOffSet := MirClient.Size;

  sBuffer := GetFilterItemListText;

  if sBuffer <> '' then begin
    CompressBuf(@sBuffer[1], Length(sBuffer), OutBuf, OutBytes);
    ClientConfig.nShowItemSize := OutBytes;
    MirClient.Seek(0, soFromEnd);
    MirClient.Write(OutBuf^, OutBytes);
    FreeMem(OutBuf);
  end;

{------------------------------------------------------------------------------}
  ProgressBar.Position := ProgressBar.Position + 1;
  ClientConfig.nItemDescOffSet := MirClient.Size;

  sBuffer := GetItemDescListText;

  if sBuffer <> '' then begin
    CompressBuf(@sBuffer[1], Length(sBuffer), OutBuf, OutBytes);
    ClientConfig.nItemDescSize := OutBytes;
    MirClient.Seek(0, soFromEnd);
    MirClient.Write(OutBuf^, OutBytes);
    FreeMem(OutBuf);
  end;
{------------------------------------------------------------------------------}

  sBuffer := EncryptBuffer(@ClientConfig, SizeOf(TClientConfig));
  nBuffer := Length(sBuffer);
  MirClient.Seek(0, soFromEnd);
  MirClient.Write(sBuffer[1], nBuffer);

//======================================GameLogin===============================
//---------------------------------写入MirClient--------------------------------
  ProgressBar.Position := ProgressBar.Position + 1;
  Config.nClientPos := GameLogin.Size;
  GetMem(Buffer, MirClient.Size);
  try
    MirClient.Seek(0, soFromBeginning);
    MirClient.Read(Buffer^, MirClient.Size);
    GameLogin.Seek(0, soFromEnd);
    GameLogin.Write(Buffer^, MirClient.Size);
  finally
    FreeMem(Buffer);
  end;
//---------------------------------写入插件--------------------------------
  ProgressBar.Position := ProgressBar.Position + 1;
  nSize^ := GameLogin.Size;
  for I := 0 to g_PlugList.Count - 1 do begin
    if I > 9 then break;
    if not FileExists(ExtractFilePath(ParamStr(0)) + g_PlugList.Strings[I]) then begin
      Config.PlugConfig[I].Pos := -1;
      Config.PlugConfig[I].Size := -1;
      Config.PlugConfig[I].Name := '';
    end else begin

      PlugClient := TMemoryStream.Create;
      PlugClient.LoadFromFile(ExtractFilePath(ParamStr(0)) + g_PlugList.Strings[I]);
      Config.PlugConfig[I].Pos := nSize^;
      Config.PlugConfig[I].Size := PlugClient.Size;
      Config.PlugConfig[I].Name := g_PlugList.Strings[I];

      nSize^ := nSize^ + PlugClient.Size;
      GetMem(Buffer, PlugClient.Size);
      try
        PlugClient.Seek(0, soFromBeginning);
        PlugClient.Read(Buffer^, PlugClient.Size);
        GameLogin.Seek(0, soFromEnd);
        GameLogin.Write(Buffer^, PlugClient.Size);
      finally
        FreeMem(Buffer);
      end;
      PlugClient.Free;
    end;
  end;
//------------------------------------------------------------------------------
  ProgressBar.Position := ProgressBar.Position + 1;

  Config.sUlrName := sName;
  Config.sHomePage := sHomePage;
  Config.sConfigAddress := sConfig;
  Config.sGameAddress := sGameList;
  Config.nClientSize := MirClient.Size;
  Config.nSize := GameLogin.Size;
  sBuffer := EncryptBuffer(@DomainNameFile, SizeOf(TDomainNameFile));
  Move(sBuffer[1], Config.Buffer, SizeOf(Config.Buffer));

 { sBuffer := EncryptBuffer(@Config, SizeOf(TConfig));
  nBuffer := Length(sBuffer);
  GameLogin.Seek(0, soFromEnd);
  GameLogin.Write(sBuffer[1], nBuffer);
  }

  Buffer := @Config;
  CompressBuf(Buffer, SizeOf(TConfig), OutBuf, OutBytes);
  Buffer := OutBuf;
  GameLogin.Seek(0, soFromEnd);
  GameLogin.Write(Buffer^, OutBytes);
  GameLogin.Write(OutBytes, SizeOf(Integer));
  FreeMem(Buffer);


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
  ProgressBar.Position := ProgressBar.Position + 1;
  FillChar(GameLoginConfig, SizeOf(TGameLoginConfig), 0);

  g_ComponentVisibles[14] := True;

  for I := 1 to g_ComponentList.Count - 1 do begin
    GameLoginConfig.ComponentConfigs[I - 1].Left := TWinControl(g_ComponentList.Items[I]).Left;
    GameLoginConfig.ComponentConfigs[I - 1].Top := TWinControl(g_ComponentList.Items[I]).Top;
    GameLoginConfig.ComponentConfigs[I - 1].Width := TWinControl(g_ComponentList.Items[I]).Width;
    GameLoginConfig.ComponentConfigs[I - 1].Height := TWinControl(g_ComponentList.Items[I]).Height;
    GameLoginConfig.ComponentConfigs[I - 1].Visible := g_ComponentVisibles[TWinControl(g_ComponentList.Items[I]).Tag];
  end;

  for I := 0 to Length(GameLoginConfig.ComponentImages) - 1 do begin
    GameLoginConfig.ComponentImages[I].UpSize := 0;
    GameLoginConfig.ComponentImages[I].HotSize := 0;
    GameLoginConfig.ComponentImages[I].DownSize := 0;
    GameLoginConfig.ComponentImages[I].Disabled := 0;
  end;

  BufferList := TList.Create;
  SizeList := TList.Create;
  FileStream := TMemoryStream.Create;

  Image := TImage(g_ComponentList.Items[0]);
  Image.Picture.Bitmap.SaveToStream(FileStream);


  GetMem(Buffer, FileStream.Size);
  FileStream.Seek(0, soFromBeginning);
  FileStream.Read(Buffer^, FileStream.Size);
  CompressBuf(Buffer, FileStream.Size, OutBuf, OutBytes);
  FreeMem(Buffer);
  Buffer := OutBuf;

  GameLoginConfig.ComponentImages[0].UpSize := OutBytes; //FileStream.Size; //OutBytes; //
  GameLoginConfig.ComponentImages[0].HotSize := 0;
  GameLoginConfig.ComponentImages[0].DownSize := 0;
  GameLoginConfig.ComponentImages[0].Disabled := 0;

  BufferList.Add(Buffer);
  SizeList.Add(Pointer(OutBytes));

  ProgressBar.Position := ProgressBar.Position + 1;
  for I := 1 to g_ComponentList.Count - 5 do begin
    if not (TComponent(g_ComponentList.Items[I]) is TRzBmpButton) then Continue;
    BmpButton := TRzBmpButton(g_ComponentList.Items[I]);
    if not g_ComponentVisibles[BmpButton.Tag] then Continue;
    if (BmpButton.Bitmaps.Up <> nil) and (BmpButton.Bitmaps.Up.Width > 0) and (BmpButton.Bitmaps.Up.Height > 0) then begin
      FileStream.Clear;
      FileStream.Seek(0, soFromBeginning);
      BmpButton.Bitmaps.Up.SaveToStream(FileStream);

      nBuffer := FileStream.Size;
      GetMem(Buffer, nBuffer);
      FileStream.Seek(0, soFromBeginning);
      FileStream.Read(Buffer^, nBuffer);

      BufferList.Add(Buffer);
      SizeList.Add(Pointer(nBuffer));

      GameLoginConfig.ComponentImages[I].UpSize := nBuffer;
    end;

    if (BmpButton.Bitmaps.Hot <> nil) and (BmpButton.Bitmaps.Hot.Width > 0) and (BmpButton.Bitmaps.Hot.Height > 0) then begin
      FileStream.Clear;
      FileStream.Seek(0, soFromBeginning);
      BmpButton.Bitmaps.Hot.SaveToStream(FileStream);

      nBuffer := FileStream.Size;
      GetMem(Buffer, nBuffer);
      FileStream.Seek(0, soFromBeginning);
      FileStream.Read(Buffer^, nBuffer);

      BufferList.Add(Buffer);
      SizeList.Add(Pointer(nBuffer));

      GameLoginConfig.ComponentImages[I].HotSize := nBuffer;
    end;

    if (BmpButton.Bitmaps.Down <> nil) and (BmpButton.Bitmaps.Down.Width > 0) and (BmpButton.Bitmaps.Down.Height > 0) then begin
      FileStream.Clear;
      FileStream.Seek(0, soFromBeginning);
      BmpButton.Bitmaps.Down.SaveToStream(FileStream);

      nBuffer := FileStream.Size;
      GetMem(Buffer, nBuffer);
      FileStream.Seek(0, soFromBeginning);
      FileStream.Read(Buffer^, nBuffer);

      BufferList.Add(Buffer);
      SizeList.Add(Pointer(nBuffer));

      GameLoginConfig.ComponentImages[I].DownSize := nBuffer;
    end;

    if (BmpButton.Bitmaps.Disabled <> nil) and (BmpButton.Bitmaps.Disabled.Width > 0) and (BmpButton.Bitmaps.Disabled.Height > 0) then begin
      FileStream.Clear;
      FileStream.Seek(0, soFromBeginning);
      BmpButton.Bitmaps.Disabled.SaveToStream(FileStream);

      nBuffer := FileStream.Size;
      GetMem(Buffer, nBuffer);
      FileStream.Seek(0, soFromBeginning);
      FileStream.Read(Buffer^, nBuffer);

      BufferList.Add(Buffer);
      SizeList.Add(Pointer(nBuffer));

      GameLoginConfig.ComponentImages[I].Disabled := nBuffer;
    end;
  end;
  ProgressBar.Position := ProgressBar.Position + 1;

  GameLoginConfig.Transparent := g_boTransparent;
  GameLoginConfig.LabelConnectColor := g_LabelConnectColor;
  GameLoginConfig.LabelConnectingColor := g_LabelConnectingColor;
  GameLoginConfig.LabelDisconnectColor := g_LabelDisconnectColor;

  GameLoginConfig.ViewFColor := g_ViewFColor;
  GameLoginConfig.ViewBColor := g_ViewBColor;

  GameLogin.Seek(0, soFromEnd);
  for I := 0 to BufferList.Count - 1 do begin
    Buffer := BufferList.Items[I];
    nLen := Integer(SizeList.Items[I]);
    if nLen > 0 then begin
      GameLogin.Seek(0, soFromEnd);
      GameLogin.Write(Buffer^, nLen);
    end;
    FreeMem(Buffer);
  end;
  GameLogin.Seek(0, soFromEnd);
  GameLogin.Write(GameLoginConfig, SizeOf(TGameLoginConfig));

  ProgressBar.Position := ProgressBar.Position + 1;
  BufferList.Free;
  SizeList.Free;
  FileStream.Free;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

  with SaveDialog do begin
    if FileName = '' then FileName := '飞尔真彩登陆器';
    //FileName := ExtractFilePath(FileName) + ExtractFileNameOnly(FileName) + '.exe';
    if Execute and (FileName <> '') then begin
      if ExtractFileExt(FileName) <> '.exe' then
        FileName := ExtractFilePath(FileName) + ExtractFileNameOnly(FileName) + '.exe';

      try
        GameLogin.SaveToFile(FileName);
        Application.MessageBox('配制成功 ！！！', '提示信息', MB_ICONQUESTION);
      except
        on e: Exception do begin
          Application.MessageBox(PChar(e.Message), '错误信息', MB_ICONERROR);
        end;
      end;
    end;
  end;

  Dispose(nSize);
  Dispose(nCrc);

  MirClient.Free;
  GameLogin.Free;
  DataFile.Free;
  ImageFile.Free;
  ButtonOK.Enabled := True;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  I: Integer;
  sBuffer, sPlugFileName: string;
  boFindDomainName: Boolean;
  DomainNameFile: TDomainNameFile;
  DomainNameList: TStringList;
begin
  RzPageControl.ActivePageIndex := 0;

  ProgressBar.Parent := RzStatusBar;
  ProgressBar.Align := alClient;
  g_sDomainNameFileName := ExtractFilePath(Application.ExeName) + 'DomainName.key';
  DragFromShell := TDragFromShell.Create(self);
  DragFromShell.OnShellDragDrop := DropFiles;
  MemoUpgrade.Lines.Clear;
  MemoUpgrade.Lines.Add(';文件类型(0=普通文件 1=登陆器 2=ZIP压缩文件)' + #9 + '目录' + #9 + '文件名称' + #9 + 'MD5值' + #9 + '下载地址');

  sPlugFileName := '.\PlugList.txt';
  g_PlugList := TStringList.Create;
  if FileExists(sPlugFileName) then begin
    g_PlugList.LoadFromFile(sPlugFileName);
  end else begin
    g_PlugList.Add('WebBrowser.dll');
    g_PlugList.Add('MediaPlayer.dll');
    g_PlugList.SaveToFile(sPlugFileName);
  end;
  ListBox.Items.AddStrings(g_PlugList);
  EditGameLoginFile.Text := ExtractFilePath(Application.ExeName) + 'GameLogin.exe';
  EditMirClientFile.Text := ExtractFilePath(Application.ExeName) + 'MirClient.exe';
  EditDataFile.Text := ExtractFilePath(Application.ExeName) + '界面.Data';
  EditBackImage.Text := ExtractFilePath(Application.ExeName) + '背景.bmp';
  EditBackImage.Enabled := FileExists(g_sDomainNameFileName);

  FillChar(DomainNameFile, SizeOf(TDomainNameFile), #0);
  if FileExists(g_sDomainNameFileName) then begin //读取注册域名
    sBuffer := '';
    DomainNameList := TStringList.Create;
    try
      DomainNameList.LoadFromFile(g_sDomainNameFileName);
    except

    end;
    for I := 0 to DomainNameList.Count - 1 do begin
      sBuffer := sBuffer + Trim(DomainNameList[I]);
    end;
    DomainNameList.Free;
    DecryptBuffer(sBuffer, @DomainNameFile, SizeOf(TDomainNameFile));
  end;

  if (DomainNameFile.sDomainName <> '') and (StringCrc(DomainNameFile.sDomainName) = DomainNameFile.nDomainName) and
    (DomainNameFile.boUnlimited or ((Date <= DomainNameFile.MaxDate) and (Date >= DomainNameFile.MinDate))) then begin
    EditBackImage.Enabled := True;
    if DomainNameFile.boUnlimited then begin
      RzStatusPane1.Caption := '绑定域名:' + DomainNameFile.sDomainName + ' 无限期';
    end else begin
      RzStatusPane1.Caption := '绑定域名:' + DomainNameFile.sDomainName + ' 期限:' + DateToStr(DomainNameFile.MaxDate);
    end;
  end else begin
    EditBackImage.Enabled := False;
    RzStatusPane1.Caption := '未绑定';
  end;
  TimerStart.Enabled := True;
end;

procedure TfrmMain.DropFiles(Sender: Tobject; Filename: string);
var
  sSaveDirectory: string;
begin
  SendMessage(Application.MainForm.Handle, FCP_FILEOPEN, 0, Integer(Filename));
  if DirectoryExists(Filename) then Exit;
  RzPageControl.ActivePageIndex := 5;
  //这里是拖放文件的具体处理代码
  EditMD5.Text := RivestFile(Filename);
  EditFileName.Text := ExtractFileName(Filename);
  //EditMD5.SetFocus;
  //EditMD5.SelectAll;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  g_PlugList.Free;
  UnLoadBindItemList;
  UnLoadItemDescList;
end;

procedure TfrmMain.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.EditGameLoginFileButtonClick(Sender: TObject);
begin
  OpenDialog.Filter := 'GameLogin|*.exe';
  if OpenDialog.Execute then begin
    EditGameLoginFile.Text := OpenDialog.FileName;
  end;
end;

procedure TfrmMain.EditMirClientFileButtonClick(Sender: TObject);
begin
  OpenDialog.Filter := 'MirClient|*.exe';
  if OpenDialog.Execute then begin
    EditMirClientFile.Text := OpenDialog.FileName;
  end;
end;

procedure TfrmMain.RzButtonGameLoginOptionClick(Sender: TObject);
begin
 // FrmGameLogin := TObjectsDlg.Create(Self);
  FrmGameLogin.Open;
end;

procedure TfrmMain.TimerStartTimer(Sender: TObject);
begin
  TimerStart.Enabled := False;
  LoadConfig;
  LoadBindItemList;

  RefListViewBindItem;

  LoadFilterItemList;
  RefListViewFilterItem(i_All);

  LoadItemDescList;
  RefListViewItemDesc;
end;


procedure TfrmMain.RzButtonSaveConfigClick(Sender: TObject);
begin
  SaveConfig;
  Application.MessageBox('配制信息保存成功 ！！！', '提示信息', MB_ICONQUESTION);
end;

procedure TfrmMain.EditDataFileButtonClick(Sender: TObject);
begin
  OpenDialog.Filter := '*.*|*.Data';
  if OpenDialog.Execute then begin
    EditDataFile.Text := OpenDialog.FileName;
  end;
end;

procedure TfrmMain.EditBackImageButtonClick(Sender: TObject);
begin
  OpenDialog.Filter := '*.*|*.Bmp';
  if OpenDialog.Execute then begin
    EditBackImage.Text := OpenDialog.FileName;
  end;
end;

procedure TfrmMain.RzListBoxClick(Sender: TObject);
begin
  RzRadioGroup.ItemIndex := Integer(RzListBox.Items.Objects[RzListBox.ItemIndex]);
  RzRadioGroup.Caption := RzListBox.Items.Strings[RzListBox.ItemIndex];
end;

procedure TfrmMain.RzRadioGroupClick(Sender: TObject);
begin
  if RzListBox.ItemIndex >= 0 then begin
    RzListBox.Items.Objects[RzListBox.ItemIndex] := TObject(RzRadioGroup.ItemIndex);
    RzButtonSaveOption.Enabled := True;
  end;
end;

procedure TfrmMain.RzButtonBackOptionClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to RzListBox.Items.Count - 1 do
    RzListBox.Items.Objects[I] := nil;
  RzListBox.Items.Objects[19] := TObject(1);
  RzButtonSaveOption.Enabled := True;
  Application.MessageBox('已经恢复到默认配制 ！！！', '提示信息', MB_ICONQUESTION);
end;

procedure TfrmMain.RzButtonLoadOptionClick(Sender: TObject);
begin
  LoadConfig;
  Application.MessageBox('读取配制成功 ！！！', '提示信息', MB_ICONQUESTION);
end;

procedure TfrmMain.RzButtonSaveOptionClick(Sender: TObject);
begin
  RzButtonSaveOption.Enabled := False;
  SaveConfig;
end;

procedure TfrmMain.ListViewBindItemClick(Sender: TObject);
var
  ListItem: TListItem;
  BindItem: pTBindItemFile;
begin
  ButtonBindChg.Enabled := False;
  ButtonBindDel.Enabled := False;
  ListItem := ListViewBindItem.Selected;
  if ListItem = nil then Exit;
  BindItem := pTBindItemFile(ListItem.SubItems.Objects[0]);
  if BindItem = nil then Exit;
  SetItemAttr(BindItem.btItemType);
  EditItemName.Text := BindItem.sItemName;
  EditBindItemName.Text := BindItem.sBindItemName;
  ButtonBindChg.Enabled := True;
  ButtonBindDel.Enabled := True;
end;

procedure TfrmMain.ButtonBindAddClick(Sender: TObject);
var
  ListItem: TListItem;
  BindItem: pTBindItemFile;
  sItemName, sBindItemName: string;
  nType: Integer;
begin
  sItemName := EditItemName.Text;
  sBindItemName := EditBindItemName.Text;
  nType := GetItemAttr;

  if sItemName = '' then begin
    Application.MessageBox('请输入物品名称！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  if sBindItemName = '' then begin
    Application.MessageBox('请输入物品包名称！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;

  if FindBindItemName(sBindItemName) <> '' then begin
    Application.MessageBox('此物品包已经添加！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  if FindUnBindItemName(sItemName) <> '' then begin
    Application.MessageBox('此物品已经添加！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;

  New(BindItem);
  BindItem.btItemType := nType;
  BindItem.sItemName := sItemName;
  BindItem.sBindItemName := sBindItemName;
  g_UnbindItemList.Add(BindItem);
  RefListViewbindItem;
  ButtonBindSave.Enabled := True;
end;

procedure TfrmMain.ButtonBindChgClick(Sender: TObject);
var
  ListItem: TListItem;
  BindItem: pTBindItemFile;
  sItemName, sBindItemName: string;
  nType: Integer;
begin
  sItemName := EditItemName.Text;
  sBindItemName := EditBindItemName.Text;
  nType := GetItemAttr;
  ListItem := ListViewBindItem.Selected;
  if ListItem = nil then Exit;
  BindItem := pTBindItemFile(ListItem.SubItems.Objects[0]);
  if BindItem = nil then Exit;
  BindItem.btItemType := nType;
  BindItem.sItemName := sItemName;
  BindItem.sBindItemName := sBindItemName;
  RefListViewBindItem;
  ButtonBindChg.Enabled := False;
  ButtonBindSave.Enabled := True;
end;

procedure TfrmMain.ButtonBindDelClick(Sender: TObject);
var
  I: Integer;
  ListItem: TListItem;
  BindItem: pTBindItemFile;
begin
  ListItem := ListViewBindItem.Selected;
  if ListItem = nil then Exit;
  BindItem := pTBindItemFile(ListItem.SubItems.Objects[0]);
  if BindItem = nil then Exit;
  for I := 0 to g_UnbindItemList.Count - 1 do begin
    if g_UnbindItemList.Items[I] = BindItem then begin
      Dispose(pTBindItemFile(g_UnbindItemList.Items[I]));
      g_UnbindItemList.Delete(I);
      Break;
    end;
  end;
  RefListViewBindItem;
  ButtonBindDel.Enabled := False;
  ButtonBindSave.Enabled := True;
end;

procedure TfrmMain.ButtonBindSaveClick(Sender: TObject);
begin
  SaveBindItemList;
  ButtonBindSave.Enabled := False;
end;

procedure TfrmMain.ButtonFilterAddClick(Sender: TObject);
var
  ListItem: TListItem;
  FilterItem: pTFilterItem;
  sItemName: string;
  nType: Integer;
begin
  sItemName := EditFilterItemName.Text;
  nType := RzComboBoxItemFilter.ItemIndex;

  if sItemName = '' then begin
    Application.MessageBox('请输入物品名称！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  if FindFilterItemName(sItemName) <> '' then begin
    Application.MessageBox('此物品已经添加！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  if nType <= 0 then begin
    Application.MessageBox('请选择物品类型！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;

  New(FilterItem);
  FilterItem.ItemType := TFilterItemType(nType - 1);
  FilterItem.sItemName := sItemName;
  FilterItem.boHintMsg := RzCheckGroupItemFilter.ItemChecked[0];
  FilterItem.boPickup := RzCheckGroupItemFilter.ItemChecked[1];
  FilterItem.boShowName := RzCheckGroupItemFilter.ItemChecked[2];
  g_FilterItemList.Add(FilterItem);
  RefListViewFilterItem(FilterItem.ItemType);
  ButtonFilterSave.Enabled := True;
end;

procedure TfrmMain.ButtonFilterChgClick(Sender: TObject);
var
  ListItem: TListItem;
  FilterItem: pTFilterItem;
  sItemName: string;
  nType: Integer;
begin
  sItemName := EditFilterItemName.Text;
  nType := RzComboBoxItemFilter.ItemIndex;
  if sItemName = '' then begin
    Application.MessageBox('请输入物品名称！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  if nType <= 0 then begin
    Application.MessageBox('请选择物品类型！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  ListItem := ListViewFilterItem.Selected;
  if ListItem = nil then Exit;
  FilterItem := pTFilterItem(ListItem.SubItems.Objects[0]);
  if FilterItem = nil then Exit;
  FilterItem.ItemType := TFilterItemType(nType - 1);
  FilterItem.sItemName := sItemName;
  FilterItem.boHintMsg := RzCheckGroupItemFilter.ItemChecked[0];
  FilterItem.boPickup := RzCheckGroupItemFilter.ItemChecked[1];
  FilterItem.boShowName := RzCheckGroupItemFilter.ItemChecked[2];
  RefListViewFilterItem(FilterItem.ItemType);
  ButtonFilterChg.Enabled := False;
  ButtonFilterSave.Enabled := True;
end;

procedure TfrmMain.ButtonFilterDelClick(Sender: TObject);
var
  I: Integer;
  ListItem: TListItem;
  FilterItem: pTFilterItem;
begin
  ListItem := ListViewFilterItem.Selected;
  if ListItem = nil then Exit;
  FilterItem := pTFilterItem(ListItem.SubItems.Objects[0]);
  if FilterItem = nil then Exit;
  for I := 0 to g_FilterItemList.Count - 1 do begin
    if g_FilterItemList.Items[I] = FilterItem then begin
      Dispose(pTFilterItem(g_FilterItemList.Items[I]));
      g_FilterItemList.Delete(I);
      Break;
    end;
  end;
  RefListViewFilterItem(TFilterItemType(RzComboBoxItemFilter.ItemIndex - 1));
  ButtonFilterDel.Enabled := False;
  ButtonFilterSave.Enabled := True;
end;

procedure TfrmMain.ButtonFilterSaveClick(Sender: TObject);
begin
  SaveFilterItemList;
  ButtonFilterSave.Enabled := False;
end;

procedure TfrmMain.ListViewFilterItemClick(Sender: TObject);
var
  ListItem: TListItem;
  FilterItem: pTFilterItem;
begin
  ButtonFilterChg.Enabled := False;
  ButtonFilterDel.Enabled := False;
  ListItem := ListViewFilterItem.Selected;
  if ListItem = nil then Exit;
  FilterItem := pTFilterItem(ListItem.SubItems.Objects[0]);
  if FilterItem = nil then Exit;
  RzComboBoxItemFilter.ItemIndex := Integer(FilterItem.ItemType) + 1;
  RzCheckGroupItemFilter.ItemChecked[0] := FilterItem.boHintMsg;
  RzCheckGroupItemFilter.ItemChecked[1] := FilterItem.boPickup;
  RzCheckGroupItemFilter.ItemChecked[2] := FilterItem.boShowName;
  EditFilterItemName.Text := FilterItem.sItemName;
  ButtonFilterChg.Enabled := True;
  ButtonFilterDel.Enabled := True;
end;

procedure TfrmMain.RzComboBoxItemFilterChange(Sender: TObject);
begin
  if RzComboBoxItemFilter.ItemIndex <= 0 then begin
    RefListViewFilterItem(i_All);
  end else begin
    RefListViewFilterItem(TFilterItemType(RzComboBoxItemFilter.ItemIndex - 1));
  end;
end;

procedure TfrmMain.ButtonUpgradeAddClick(Sender: TObject);
var
  sFileName: string;
  sFilePath: string;
  sDownLoad: string;
  sLineText: string;
  sMD5: string;
begin
  sFileName := Trim(EditFileName.Text);
  sDownLoad := Trim(EditDownLoadAddr.Text);
  sMD5 := EditMD5.Text;
  if ComboBox.ItemIndex < 0 then begin
    Application.MessageBox('请选择存放目录 ！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  if sFileName = '' then begin
    Application.MessageBox('请输入文件名称 ！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  if sDownLoad = '' then begin
    Application.MessageBox('请输入下载地址 ！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  sFilePath := ComboBox.Text;
  if ComboBox.ItemIndex = 4 then sFilePath := '\';
  sLineText := IntToStr(RadioGroup1.ItemIndex) + #9 + sFilePath + #9 + sFileName + #9 + sMD5 + #9 + sDownLoad;
  MemoUpgrade.Lines.Add(sLineText);
end;

procedure TfrmMain.ButtonUpgradeOpenClick(Sender: TObject);
begin
  OpenDialog.Filter := '*.*|*.*';
  if OpenDialog.Execute then begin
    EditMD5.Text := RivestFile(OpenDialog.FileName);
    //LabelFileName.Caption := OpenDialog.FileName;
    EditFileName.Text := ExtractFileName(OpenDialog.FileName);
    EditMD5.SetFocus;
    EditMD5.SelectAll;
  end;
end;

procedure TfrmMain.ButtonUpgradeCreateClick(Sender: TObject);
begin
  MemoUpgrade.Lines.SaveToFile(ExtractFilePath(ParamStr(0)) + 'Upgrade.txt');
  Application.MessageBox('游戏列表已生成 ！！！' + #10#13 +
    '请复制目录下的 Upgrade.txt 传到你的网站目录下即可', '提示信息', MB_ICONQUESTION);
end;

procedure TfrmMain.ButtonUpgradeLoadClick(Sender: TObject);
begin
  OpenDialog.Filter := '*.txt|*.txt';
  if OpenDialog.Execute then begin
    MemoUpgrade.Lines.LoadFromFile(OpenDialog.FileName);
  end;
end;

procedure TfrmMain.ButtonUpgradeSaveClick(Sender: TObject);
begin
  MemoUpgrade.Lines.SaveToFile(ExtractFilePath(ParamStr(0)) + '更新补丁记录.txt');
  Application.MessageBox('游戏更新列表保存成功 ！！！', '提示信息', MB_ICONQUESTION);
end;

procedure TfrmMain.RzButtonFromDBClick(Sender: TObject);
  function GetItemType(StdMode: Integer): TFilterItemType;
  begin
    case StdMode of
      0..2: Result := i_HPMPDurg;
      10, 11: Result := i_Dress;
      5, 6: Result := i_Weapon;
      28, 29, 30: Result := i_Decorate;
      19, 20, 21: Result := i_Jewelry;
      15: Result := i_Jewelry;
      24, 26: Result := i_Jewelry;
      22, 23: Result := i_Jewelry;
      25, 51: Result := i_Decoration;
      54, 64: Result := i_Decorate;
      52, 62: Result := i_Decorate;
      53, 63: Result := i_Decorate;
    else Result := i_Other;
    end;
  end;
var
  I: Integer;
  nStdMode: Integer;
  Query: TQuery;
  sItemName: string;
  ItemType: TFilterItemType;
  FilterItem: pTFilterItem;
resourcestring
  sSQLString = 'select * from StdItems';
begin
  //CoInitialize(nil);
  FrmLoadFromDB.Open;
  if FrmLoadFromDB.ModalResult = mrYes then begin
    Query := TQuery.Create(nil);
    Query.DatabaseName := FrmLoadFromDB.EditDBName.Text;
    Query.SQL.Clear;
    Query.SQL.Add(sSQLString);
    try
      Query.Open;
    finally
      //Exit;
    end;
    if Query.RecordCount > 0 then begin
      for I := 0 to g_FilterItemList.Count - 1 do begin
        Dispose(pTFilterItem(g_FilterItemList.Items[I]));
      end;
      g_FilterItemList.Clear;
      try
        for I := 0 to Query.RecordCount - 1 do begin
          nStdMode := Query.FieldByName('StdMode').AsInteger;
          sItemName := Query.FieldByName('Name').AsString;
          ItemType := GetItemType(nStdMode);
          New(FilterItem);
          FilterItem.ItemType := ItemType;
          FilterItem.sItemName := sItemName;
          FilterItem.boHintMsg := RzCheckGroupItemFilter.ItemChecked[0];
          FilterItem.boPickup := RzCheckGroupItemFilter.ItemChecked[1];
          FilterItem.boShowName := RzCheckGroupItemFilter.ItemChecked[2];
          g_FilterItemList.Add(FilterItem);
          Query.Next;
        end;
      finally
        Query.Close;
      end;
      RefListViewFilterItem(i_All);
      ButtonFilterSave.Enabled := True;
    end;
    Query.Free;
  end;
 // CoUnInitialize;
end;


procedure TfrmMain.EditItemNameColorChange(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditItemNameColor.Value;
  LabelItemNameColor.Color := GetRGB(btColor);
end;

procedure TfrmMain.ButtonItemDescFromDBClick(Sender: TObject);
var
  I: Integer;
  nStdMode: Integer;
  Query: TQuery;
  sItemName: string;
  ItemDesc: pTItemDesc;
resourcestring
  sSQLString = 'select * from StdItems';
begin
  //CoInitialize(nil);
  FrmLoadFromDB.Open;
  if FrmLoadFromDB.ModalResult = mrYes then begin
    Query := TQuery.Create(nil);
    Query.DatabaseName := FrmLoadFromDB.EditDBName.Text;
    Query.SQL.Clear;
    Query.SQL.Add(sSQLString);
    try
      Query.Open;
    finally
      //Exit;
    end;

    if Query.RecordCount > 0 then begin
      for I := 0 to g_ItemDescList.Count - 1 do begin
        Dispose(pTItemDesc(g_ItemDescList.Items[I]));
      end;
      g_ItemDescList.Clear;
      try
        for I := 0 to Query.RecordCount - 1 do begin
          sItemName := Query.FieldByName('Name').AsString;
          New(ItemDesc);
          ItemDesc.Name := sItemName;
          ItemDesc.Desc := '';
          g_ItemDescList.Add(ItemDesc);
          Query.Next;
        end;
      finally
        Query.Close;
      end;

      RefListViewItemDesc;

      ButtonItemDescSave.Enabled := True;
    end;
    Query.Free;
  end;
end;

procedure TfrmMain.ButtonItemDescSaveClick(Sender: TObject);
begin
  SaveItemDescList;
  ButtonItemDescSave.Enabled := False;
end;

procedure TfrmMain.ButtonItemDescAddClick(Sender: TObject);
var
  ListItem: TListItem;
  ItemDesc: pTItemDesc;
  sItemName: string;
  nType: Integer;
begin
  sItemName := EditItemDescName.Text;

  if sItemName = '' then begin
    Application.MessageBox('请输入物品名称！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  if FindItemDescName(sItemName) <> '' then begin
    Application.MessageBox('此物品已经添加！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;

  New(ItemDesc);
  ItemDesc.Name := sItemName;
  ItemDesc.Desc := EditItemDesc.Text;
  g_ItemDescList.Add(ItemDesc);
  RefListViewItemDesc();
  ButtonItemDescSave.Enabled := True;
end;

procedure TfrmMain.ButtonItemDescChgClick(Sender: TObject);
var
  ListItem: TListItem;
  ItemDesc: pTItemDesc;
  sItemName: string;
begin
  sItemName := EditItemDescName.Text;
  if sItemName = '' then begin
    Application.MessageBox('请输入物品名称！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  ListItem := ListViewItemDesc.Selected;
  if ListItem = nil then Exit;
  ItemDesc := pTItemDesc(ListItem.SubItems.Objects[0]);
  if ItemDesc = nil then Exit;

  ItemDesc.Desc := EditItemDesc.Text;
  RefListViewItemDesc();
  ButtonItemDescChg.Enabled := False;
  ButtonItemDescSave.Enabled := True;
end;

procedure TfrmMain.ButtonItemDescDelClick(Sender: TObject);
var
  I: Integer;
  ListItem: TListItem;
  ItemDesc: pTItemDesc;
begin
  ListItem := ListViewItemDesc.Selected;
  if ListItem = nil then Exit;
  ItemDesc := pTItemDesc(ListItem.SubItems.Objects[0]);
  if ItemDesc = nil then Exit;
  for I := 0 to g_ItemDescList.Count - 1 do begin
    if g_ItemDescList.Items[I] = ItemDesc then begin
      Dispose(pTItemDesc(g_ItemDescList.Items[I]));
      g_ItemDescList.Delete(I);
      Break;
    end;
  end;
  RefListViewItemDesc();
  ButtonItemDescDel.Enabled := False;
  ButtonItemDescSave.Enabled := True;
end;

procedure TfrmMain.ButtonDelNotDescItemClick(Sender: TObject);
var
  I: Integer;
  ListItem: TListItem;
  ItemDesc: pTItemDesc;
begin
  ListItem := ListViewItemDesc.Selected;
  if ListItem = nil then Exit;
  ItemDesc := pTItemDesc(ListItem.SubItems.Objects[0]);
  if ItemDesc = nil then Exit;
  for I := g_ItemDescList.Count - 1 downto 0 do begin
    ItemDesc := g_ItemDescList.Items[I];
    if ItemDesc.Desc = '' then begin
      Dispose(ItemDesc);
      g_ItemDescList.Delete(I);
    end;
  end;
  RefListViewItemDesc();
  ButtonItemDescSave.Enabled := True;
end;

procedure TfrmMain.ListViewItemDescClick(Sender: TObject);
var
  ListItem: TListItem;
  ItemDesc: pTItemDesc;
begin
  ButtonItemDescChg.Enabled := False;
  ButtonItemDescDel.Enabled := False;
  ListItem := ListViewItemDesc.Selected;
  if ListItem = nil then Exit;
  ItemDesc := pTItemDesc(ListItem.SubItems.Objects[0]);
  if ItemDesc = nil then Exit;
  EditItemDescName.Text := ItemDesc.Name;
  EditItemDesc.Text := ItemDesc.Desc;
  ButtonItemDescChg.Enabled := True;
  ButtonItemDescDel.Enabled := True;
end;

end.

