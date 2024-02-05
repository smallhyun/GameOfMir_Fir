unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EncryptUnit, StdCtrls, Spin;
const
  MAXPATHLEN = 255;
  DIRPATHLEN = 80;
  MAPNAMELEN = 16;
  ACTORNAMELEN = 14;
  DEFBLOCKSIZE = 22;
  BUFFERSIZE = 10000;
  DATA_BUFSIZE2 = 16348; //8192;
  DATA_BUFSIZE = 8192; //8192;
  GROUPMAX = 11;
  BAGGOLD = 5000000;
  BODYLUCKUNIT = 10;
  MAX_STATUS_ATTRIBUTE = 12;

  DR_UP = 0;
  DR_UPRIGHT = 1;
  DR_RIGHT = 2;
  DR_DOWNRIGHT = 3;
  DR_DOWN = 4;
  DR_DOWNLEFT = 5;
  DR_LEFT = 6;
  DR_UPLEFT = 7;
type
  TDefaultMessage = record
    Recog: Integer;
    Ident: Word;
    Param: Word;
    Tag: Word;
    Series: Word;

    Param1: Integer;
  end;
  pTDefaultMessage = ^TDefaultMessage;

  TMessageBodyW = record
    Param1: Word;
    Param2: Word;
    Tag1: Word;
    Tag2: Word;
  end;

  TMessageBodyWL = record
    lParam1: Integer;
    lParam2: Integer;
    lTag1: Integer;
    lTag2: Integer;
  end;

  TCharDesc = record
    feature: Integer;
    Status: Integer;
  end;

  TValue = array[0..13] of Byte;
  TValueA = array[0..1] of Byte;

  TStdItem = packed record
    Name: string[14];
    StdMode: Byte;
    Shape: Byte;
    Weight: Byte;
    AniCount: Byte;
    Source: ShortInt;
    Reserved: Byte;
    NeedIdentify: Byte;
    Looks: Word;
    DuraMax: Word;
    Reserved1: Word;
    AC: Integer;
    MAC: Integer;
    DC: Integer;
    MC: Integer;
    SC: Integer;
    Need: Integer;
    NeedLevel: Integer;
    Price: Integer;
    n: Integer;
  end;
  pTStdItem = ^TStdItem;

  TOStdItem = packed record //OK
    Name: string[14];
    StdMode: Byte;
    Shape: Byte;
    Weight: Byte;
    AniCount: Byte;
    Source: ShortInt;
    Reserved: Byte;
    NeedIdentify: Byte;
    Looks: Word;
    DuraMax: Word;
    AC: Word;
    MAC: Word;
    DC: Word;
    MC: Word;
    SC: Word;
    Need: Byte;
    NeedLevel: Byte;
    w26: Word;
    Price: Integer;
  end;
  pTOStdItem = ^TOStdItem;

  TOClientItem = record //OK
    s: TOStdItem;
    MakeIndex: Integer;
    Dura: Word;
    DuraMax: Word;
  end;
  pTOClientItem = ^TOClientItem;

  TClientItem = record //OK
    s: TStdItem;
    MakeIndex: Integer;
    Dura: Word;
    DuraMax: Word;
  end;
  pTClientItem = ^TClientItem;

  TMagic = record
    wMagicId: Word;
    sMagicName: string[12];
    btEffectType: Byte;
    btEffect: Byte;
    bt11: Byte;
    wSpell: Word;
    wPower: Word;
    TrainLevel: array[0..3] of Byte;
    w02: Word;
    MaxTrain: array[0..3] of Integer;
    btTrainLv: Byte;
    btJob: Byte;
    wMagicIdx: Word;
    dwDelayTime: LongWord;
    btDefSpell: Byte;
    btDefPower: Byte;
    wMaxPower: Word;
    btDefMaxPower: Byte;
    sDescr: string[18];
  end;
  pTMagic = ^TMagic;

  TClientMagic = record //84
    Key: Char;
    Level: Byte;
    CurTrain: Integer;
    Def: TMagic;
  end;
  PTClientMagic = ^TClientMagic;

  TNakedAbility = packed record //Size 20
    DC: Word;
    MC: Word;
    SC: Word;
    AC: Word;
    MAC: Word;
    HP: Word;
    MP: Word;
    Hit: Word;
    Speed: Word;
    X2: Word;
  end;
  pTNakedAbility = ^TNakedAbility;

  TAbility = packed record //OK    //Size 40
    Level: Word; //0x198  //0x34  0x00

    AC: Integer; //0x19A  //0x36  0x02
    MAC: Integer; //0x19C  //0x38  0x04
    DC: Integer; //0x19E  //0x3A  0x06
    MC: Integer; //0x1A0  //0x3C  0x08
    SC: Integer; //0x1A2  //0x3E  0x0A

    HP: Word; //0x1A4  //0x40  0x0C
    MP: Word; //0x1A6  //0x42  0x0E
    MaxHP: Word; //0x1A8  //0x44  0x10
    MaxMP: Word; //0x1AA  //0x46  0x12

    Exp: LongWord; //0x1B0  //0x4C 0x18
    MaxExp: LongWord; //0x1B4  //0x50 0x1C
    Weight: Word; //0x1B8   //0x54 0x20
    MaxWeight: Word; //0x1BA   //0x56 0x22  背包
    WearWeight: Word; //0x1BC   //0x58 0x24
    MaxWearWeight: Word; //0x1BD   //0x59 0x25  负重
    HandWeight: Word; //0x1BE   //0x5A 0x26
    MaxHandWeight: Word; //0x1BF   //0x5B 0x27  腕力
    //b:array [0..13] of Byte;
  end;
  pTAbility = ^TAbility;

  TOAbility = packed record
    Level: Word; //0x198  //0x34  0x00
    AC: Word;
    MAC: Word;
    DC: Word;
    MC: Word;
    SC: Word;

    HP: Word; //0x1A4  //0x40  0x0C
    MP: Word; //0x1A6  //0x42  0x0E
    MaxHP: Word; //0x1A8  //0x44  0x10
    MaxMP: Word; //0x1AA  //0x46  0x12

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

  TUserItem = packed record
    MakeIndex: Integer;
    wIndex: Word; //物品id
    Dura: Word; //当前持久值
    DuraMax: Word; //最大持久值
    btValue: TValue; //array[0..13] of Byte;
  end;
  pTUserItem = ^TUserItem;

  TUserStateInfo = record
    Feature: Integer;
    UserName: string[ACTORNAMELEN];
    NAMECOLOR: Integer;
    GuildName: string[ACTORNAMELEN];
    GuildRankName: string[16];
    UseItems: array[0..12] of TClientItem;
  end;
  pTUserStateInfo = ^TUserStateInfo;

  TOUserStateInfo = packed record //OK
    feature: Integer;
    UserName: string[15]; // 15
    GuildName: string[14]; //14
    GuildRankName: string[16]; //15
    NAMECOLOR: Word;
    UseItems: array[0..8] of TOClientItem;
  end;



  TFrmMain = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    EditIdent: TEdit;
    EditRecog: TEdit;
    EditParam: TEdit;
    EditTag: TEdit;
    EditSeries: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    EditParam1: TEdit;
    EditParam2: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    EditTag2: TEdit;
    EditTag1: TEdit;
    GroupBox3: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    EditlParam1: TEdit;
    EditlParam2: TEdit;
    EditlTag2: TEdit;
    EditlTag1: TEdit;
    GroupBox4: TGroupBox;
    Label16: TLabel;
    Label17: TLabel;
    Editfeature: TEdit;
    EditStatus: TEdit;
    GroupBox5: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    EditMakeIndex: TEdit;
    EditDura: TEdit;
    EditDuraMax: TEdit;
    EditName: TEdit;
    EditStdMode: TEdit;
    Label23: TLabel;
    EditShape: TEdit;
    GroupBox6: TGroupBox;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    EditOMakeIndex: TEdit;
    EditODura: TEdit;
    EditODuraMax: TEdit;
    EditOName: TEdit;
    EditOStdMode: TEdit;
    EditOShape: TEdit;
    GroupBox7: TGroupBox;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    EditKey: TEdit;
    EditLevel: TEdit;
    EditCurTrain: TEdit;
    EditwMagicId: TEdit;
    EditsMagicName: TEdit;
    GroupBox8: TGroupBox;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Edit_Abi_Level: TEdit;
    Edit_Abi_AC: TEdit;
    Edit_Abi_MAC: TEdit;
    Edit_Abi_DC: TEdit;
    Edit_Abi_MC: TEdit;
    Edit_Abi_SC: TEdit;
    Label41: TLabel;
    Edit_Abi_HP: TEdit;
    Label42: TLabel;
    Edit_Abi_MP: TEdit;
    Label43: TLabel;
    Edit_Abi_MAXHP: TEdit;
    Label44: TLabel;
    Edit_Abi_MAXMP: TEdit;
    Label45: TLabel;
    Edit_Abi_Exp: TEdit;
    Label46: TLabel;
    Edit_Abi_MaxExp: TEdit;
    Label47: TLabel;
    Edit_Abi_Weight: TEdit;
    Label48: TLabel;
    Edit_Abi_MaxWeight: TEdit;
    Label49: TLabel;
    Edit_Abi_WearWeight: TEdit;
    Label50: TLabel;
    Edit_Abi_MaxWearWeight: TEdit;
    Label51: TLabel;
    Edit_Abi_HandWeight: TEdit;
    Label52: TLabel;
    Edit_Abi_MaxHandWeight: TEdit;
    GroupBox9: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Edit_OAbi_Level: TEdit;
    Edit_OAbi_AC: TEdit;
    Edit_OAbi_MAC: TEdit;
    Edit_OAbi_DC: TEdit;
    Edit_OAbi_MC: TEdit;
    Edit_OAbi_SC: TEdit;
    Edit_OAbi_HP: TEdit;
    Edit_OAbi_MP: TEdit;
    Edit_OAbi_MAXHP: TEdit;
    Edit_OAbi_MAXMP: TEdit;
    Edit_OAbi_Exp: TEdit;
    Edit_OAbi_MaxExp: TEdit;
    Edit_OAbi_Weight: TEdit;
    Edit_OAbi_MaxWeight: TEdit;
    Edit_OAbi_WearWeight: TEdit;
    Edit_OAbi_MaxWearWeight: TEdit;
    Edit_OAbi_HandWeight: TEdit;
    Edit_OAbi_MaxHandWeight: TEdit;
    CheckBox1: TCheckBox;
    Button1: TButton;
    GroupBox10: TGroupBox;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Button2: TButton;
    Button3: TButton;
    EditDefMsg_Param1: TEdit;
    Label69: TLabel;
    EditDefMsg_Param2: TEdit;
    Label80: TLabel;
    Label81: TLabel;
    EditDefMsg_Param3: TEdit;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    procedure Button1Click(Sender: TObject);
    procedure GroupBox5Click(Sender: TObject);
    procedure GroupBox6Click(Sender: TObject);
    procedure GroupBox7Click(Sender: TObject);
    procedure GroupBox8Click(Sender: TObject);
    procedure GroupBox9Click(Sender: TObject);
    procedure GroupBox10Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure GroupBox1DblClick(Sender: TObject);
    procedure GroupBox2DblClick(Sender: TObject);
    procedure GroupBox3DblClick(Sender: TObject);
    procedure GroupBox4DblClick(Sender: TObject);
  private
    { Private declarations }
    procedure ClearEditValue;
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

function GetCodeMsgSize(X: Double): Integer;
begin
  if Int(X) < X then Result := Trunc(X) + 1
  else Result := Trunc(X)
end;
//GetCodeMsgSize(SizeOf(TMessageBodyWL) * 4 / 3)

procedure TFrmMain.ClearEditValue;
var
  I, II: Integer;
  GroupBox: TGroupBox;
begin
  Edit2.Text := '';
  for I := 0 to Self.ControlCount - 1 do begin
    if Self.Controls[I] is TGroupBox then begin
      GroupBox := TGroupBox(Self.Controls[I]);
      for II := 0 to GroupBox.ControlCount - 1 do begin
        if GroupBox.Controls[II] is TEdit then begin
          TEdit(GroupBox.Controls[II]).Text := '';
        end;
      end;
    end;
  end;
end;

procedure TFrmMain.Button1Click(Sender: TObject);
var
  sMsg: string;
  Source: string;
  DefMsg: TDefaultMessage;
  MessageBodyW: TMessageBodyW;
  MessageBodyWL: TMessageBodyWL;
  CharDesc: TCharDesc;
  ClientItem: TClientItem;
  OClientItem: TOClientItem;
  ClientMagic: TClientMagic;
  Ability: TAbility;
  OAbility: TAbility;
begin
  ClearEditValue;
  sMsg := '';
  Source := Trim(Edit1.Text);
  if Source = '' then Exit;
  if Source[1] = '#' then
    Source := Copy(Source, 2, Length(Source) - 1);
  if Source[Length(Source)] = '!' then
    Source := Copy(Source, 1, Length(Source) - 1);

  sMsg := Copy(Source, 1, DEFBLOCKSIZE);
  if CheckBox1.Checked then begin
    Source := Copy(Source, DEFBLOCKSIZE + 1, Length(Source));
  end;
  Edit2.Text := DeCodeString(Source);

  if sMsg <> '' then begin
    DecodeBuffer(sMsg, @DefMsg, SizeOf(TDefaultMessage));
    //DefMsg := DecodeMessage(sMsg);
    EditIdent.Text := IntToStr(DefMsg.Ident);
    EditRecog.Text := IntToStr(DefMsg.Recog);
    EditParam.Text := IntToStr(DefMsg.Param);
    EditTag.Text := IntToStr(DefMsg.Tag);
    EditSeries.Text := IntToStr(DefMsg.Series);
    EditDefMsg_Param1.Text := IntToStr(DefMsg.Param1);
    //EditDefMsg_Param2.Text := IntToStr(DefMsg.Param2);
    //EditDefMsg_Param3.Text := IntToStr(MakeLong(DefMsg.Param1, DefMsg.Param2));
  end;

  if GetCodeMsgSize(SizeOf(TMessageBodyW) * 4 / 3) <= Length(Source) then begin
    DecodeBuffer(Source, @MessageBodyW, SizeOf(TMessageBodyW));
    EditParam1.Text := IntToStr(MessageBodyW.Param1);
    EditParam2.Text := IntToStr(MessageBodyW.Param2);
    EditTag1.Text := IntToStr(MessageBodyW.Tag1);
    EditTag2.Text := IntToStr(MessageBodyW.Tag2);
  end;

  if GetCodeMsgSize(SizeOf(TMessageBodyWL) * 4 / 3) <= Length(Source) then begin
    DecodeBuffer(Source, @MessageBodyWL, SizeOf(TMessageBodyWL));
    EditlParam1.Text := IntToStr(MessageBodyWL.lParam1);
    EditlParam2.Text := IntToStr(MessageBodyWL.lParam2);
    EditlTag1.Text := IntToStr(MessageBodyWL.lTag1);
    EditlTag2.Text := IntToStr(MessageBodyWL.lTag2);
  end;

  if GetCodeMsgSize(SizeOf(TCharDesc) * 4 / 3) <= Length(Source) then begin
    DecodeBuffer(Source, @CharDesc, SizeOf(TCharDesc));
    Editfeature.Text := IntToStr(CharDesc.feature);
    EditStatus.Text := IntToStr(CharDesc.Status);
  end;

  if GetCodeMsgSize(SizeOf(TClientItem) * 4 / 3) <= Length(Source) then begin
    DecodeBuffer(Source, @ClientItem, SizeOf(TClientItem));
    EditMakeIndex.Text := IntToStr(ClientItem.MakeIndex);
    EditDura.Text := IntToStr(ClientItem.Dura);
    EditDuraMax.Text := IntToStr(ClientItem.DuraMax);
    EditName.Text := ClientItem.s.Name;
    EditStdMode.Text := IntToStr(ClientItem.s.StdMode);
    EditShape.Text := IntToStr(ClientItem.s.Shape);
  end;

  if GetCodeMsgSize(SizeOf(TOClientItem) * 4 / 3) <= Length(Source) then begin
    DecodeBuffer(Source, @OClientItem, SizeOf(TOClientItem));
    EditOMakeIndex.Text := IntToStr(OClientItem.MakeIndex);
    EditODura.Text := IntToStr(OClientItem.Dura);
    EditODuraMax.Text := IntToStr(OClientItem.DuraMax);
    EditOName.Text := OClientItem.s.Name;
    EditOStdMode.Text := IntToStr(OClientItem.s.StdMode);
    EditOShape.Text := IntToStr(OClientItem.s.Shape);
  end;

  if GetCodeMsgSize(SizeOf(TClientMagic) * 4 / 3) <= Length(Source) then begin
    DecodeBuffer(Source, @ClientMagic, SizeOf(TClientMagic));
    EditKey.Text := ClientMagic.Key;
    EditLevel.Text := IntToStr(ClientMagic.Level);
    EditCurTrain.Text := IntToStr(ClientMagic.CurTrain);
    EditwMagicId.Text := IntToStr(ClientMagic.Def.wMagicId);
    EditsMagicName.Text := ClientMagic.Def.sMagicName;
  end;

  if GetCodeMsgSize(SizeOf(TAbility) * 4 / 3) <= Length(Source) then begin
    DecodeBuffer(Source, @Ability, SizeOf(TAbility));
    Edit_Abi_Level.Text := IntToStr(Ability.Level);
    Edit_Abi_AC.Text := IntToStr(Ability.AC);
    Edit_Abi_MAC.Text := IntToStr(Ability.MAC);
    Edit_Abi_DC.Text := IntToStr(Ability.DC);
    Edit_Abi_MC.Text := IntToStr(Ability.MC);
    Edit_Abi_SC.Text := IntToStr(Ability.SC);
    Edit_Abi_HP.Text := IntToStr(Ability.HP);
    Edit_Abi_MP.Text := IntToStr(Ability.MP);
    Edit_Abi_MaxHP.Text := IntToStr(Ability.MaxHP);
    Edit_Abi_MaxMP.Text := IntToStr(Ability.MaxMP);
    Edit_Abi_Exp.Text := IntToStr(Ability.Exp);
    Edit_Abi_MaxExp.Text := IntToStr(Ability.MaxExp);
    Edit_Abi_Weight.Text := IntToStr(Ability.Weight);
    Edit_Abi_MaxWeight.Text := IntToStr(Ability.MaxWeight);
    Edit_Abi_WearWeight.Text := IntToStr(Ability.WearWeight);
    Edit_Abi_MaxWearWeight.Text := IntToStr(Ability.MaxWearWeight);
    Edit_Abi_HandWeight.Text := IntToStr(Ability.HandWeight);
    Edit_Abi_MaxHandWeight.Text := IntToStr(Ability.MaxHandWeight);
  end;

  if GetCodeMsgSize(SizeOf(TOAbility) * 4 / 3) <= Length(Source) then begin
    DecodeBuffer(Source, @OAbility, SizeOf(TOAbility));
    Edit_OAbi_Level.Text := IntToStr(OAbility.Level);
    Edit_OAbi_AC.Text := IntToStr(OAbility.AC);
    Edit_OAbi_MAC.Text := IntToStr(OAbility.MAC);
    Edit_OAbi_DC.Text := IntToStr(OAbility.DC);
    Edit_OAbi_MC.Text := IntToStr(OAbility.MC);
    Edit_OAbi_SC.Text := IntToStr(OAbility.SC);
    Edit_OAbi_HP.Text := IntToStr(OAbility.HP);
    Edit_OAbi_MP.Text := IntToStr(OAbility.MP);
    Edit_OAbi_MaxHP.Text := IntToStr(OAbility.MaxHP);
    Edit_OAbi_MaxMP.Text := IntToStr(OAbility.MaxMP);
    Edit_OAbi_Exp.Text := IntToStr(OAbility.Exp);
    Edit_OAbi_MaxExp.Text := IntToStr(OAbility.MaxExp);
    Edit_OAbi_Weight.Text := IntToStr(OAbility.Weight);
    Edit_OAbi_MaxWeight.Text := IntToStr(OAbility.MaxWeight);
    Edit_OAbi_WearWeight.Text := IntToStr(OAbility.WearWeight);
    Edit_OAbi_MaxWearWeight.Text := IntToStr(OAbility.MaxWearWeight);
    Edit_OAbi_HandWeight.Text := IntToStr(OAbility.HandWeight);
    Edit_OAbi_MaxHandWeight.Text := IntToStr(OAbility.MaxHandWeight);
  end;
end;

procedure TFrmMain.GroupBox5Click(Sender: TObject);
begin
  Showmessage(IntToStr(GetCodeMsgSize(SizeOf(TClientItem) * 4 / 3)));
end;

procedure TFrmMain.GroupBox6Click(Sender: TObject);
begin
  Showmessage(IntToStr(GetCodeMsgSize(SizeOf(TOClientItem) * 4 / 3)));
end;

procedure TFrmMain.GroupBox7Click(Sender: TObject);
begin
  Showmessage(IntToStr(GetCodeMsgSize(SizeOf(TClientMagic) * 4 / 3)));
end;

procedure TFrmMain.GroupBox8Click(Sender: TObject);
begin
  Showmessage(IntToStr(GetCodeMsgSize(SizeOf(TAbility) * 4 / 3)));
end;

procedure TFrmMain.GroupBox9Click(Sender: TObject);
begin
  Showmessage(IntToStr(GetCodeMsgSize(SizeOf(TOAbility) * 4 / 3)));
end;

procedure TFrmMain.GroupBox10Click(Sender: TObject);
begin
  Showmessage(IntToStr(GetCodeMsgSize(SizeOf(TNakedAbility) * 4 / 3)));
end;

procedure TFrmMain.Button2Click(Sender: TObject);
begin
  Showmessage(IntToStr(GetCodeMsgSize(Length(Edit1.Text) * 3 / 4)));
end;

procedure TFrmMain.Button3Click(Sender: TObject);
var
  DefaultMessage: TDefaultMessage;
begin
  Edit1.Text := EncodeBuffer(@DefaultMessage, SizeOf(TDefaultMessage));
  Showmessage(IntToStr(Length(Edit1.Text)));
end;

procedure TFrmMain.Button4Click(Sender: TObject);
begin
  SpinEdit1.Value := MakeLong(SpinEdit2.Value, SpinEdit3.Value);
end;

procedure TFrmMain.Button6Click(Sender: TObject);
begin
  SpinEdit1.Value := MakeWord(SpinEdit2.Value, SpinEdit3.Value);
end;

procedure TFrmMain.Button5Click(Sender: TObject);
begin
  SpinEdit2.Value := LoWord(SpinEdit1.Value);
  SpinEdit3.Value := HiWord(SpinEdit1.Value);
end;

procedure TFrmMain.Button7Click(Sender: TObject);
begin
  SpinEdit2.Value := LoByte(SpinEdit1.Value);
  SpinEdit3.Value := HiByte(SpinEdit1.Value);
end;

procedure TFrmMain.Button8Click(Sender: TObject);
var
  DefMsg: TDefaultMessage;
begin
  DefMsg.Recog := StrToIntDef(EditRecog.Text, 0);
  DefMsg.Ident := StrToIntDef(EditIdent.Text, 0);
  DefMsg.Param := StrToIntDef(EditParam.Text, 0);
  DefMsg.Tag := StrToIntDef(EditTag.Text, 0);
  DefMsg.Series := StrToIntDef(EditSeries.Text, 0);
  DefMsg.Param1 := StrToIntDef(EditDefMsg_Param1.Text, 0);
  Edit1.Text := EncodeBuffer(@DefMsg, SizeOf(TDefaultMessage));
end;

procedure TFrmMain.GroupBox1DblClick(Sender: TObject);
begin
  Showmessage(IntToStr(GetCodeMsgSize(SizeOf(TDefaultMessage) * 4 / 3)));
end;

procedure TFrmMain.GroupBox2DblClick(Sender: TObject);
begin
  Showmessage(IntToStr(GetCodeMsgSize(SizeOf(TMessageBodyW) * 4 / 3)));
end;

procedure TFrmMain.GroupBox3DblClick(Sender: TObject);
begin
  Showmessage(IntToStr(GetCodeMsgSize(SizeOf(TMessageBodyWL) * 4 / 3)));
end;

procedure TFrmMain.GroupBox4DblClick(Sender: TObject);
begin
  Showmessage(IntToStr(GetCodeMsgSize(SizeOf(TCharDesc) * 4 / 3)));
end;

end.

