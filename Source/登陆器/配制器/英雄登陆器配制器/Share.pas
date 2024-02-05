unit Share;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls;
const
  BmpStr = 'ZgUdXCE4oqvo06sBtsDh9rrAytvL';
type
  TDomainNameArray = array[0..5 - 1] of string[50];
  TDomainNameFile = record
    nArr1: array[0..1] of Integer;
    nOwnerNumber: Integer; //QQ号码
    nArr2: array[0..1] of Integer;
    nUserNumber: Integer; //QQ号码
    nArr3: array[0..1] of Integer;
    sDomainName: string[50];
    nArr4: array[0..1] of Integer;
    nDomainName: Cardinal;
    nArr5: array[0..1] of Integer;
    DomainNameArray: TDomainNameArray;
    nArr6: array[0..1] of Integer;
    MinDate: TDateTime;
    nArr7: array[0..1] of Integer;
    MaxDate: TDateTime;
    nArr8: array[0..1] of Integer;
    boUnlimited: Boolean;
    nArr9: array[0..1] of Integer;
    nVersion: Integer;
  end;

  TLoadMode = (lmUseWil, lmUseFir, lmAutoWil, lmAutoFir);
  TPlugConfig = record
    Pos: Integer;
    Size: Integer;
    Name: string[20];
  end;
  pTPlugConfig = ^TPlugConfig;
  TPlugConfigs = array[0..10 - 1] of TPlugConfig;

  TConfig = record
    sUlrName: string[100];
    sHomePage: string[100];
    sConfigAddress: string[100];
    sGameAddress: string[100];
    nSize: Cardinal;
    nClientPos: Integer;
    nClientSize: Integer;
    PlugConfig: TPlugConfigs;
    Buffer: array[0..568 - 1] of Char;
  end;
  pTConfig = ^TConfig;


  TClientConfig = record
    nSize: Integer;
    nCrc: Cardinal;
    nConfigSize: Integer;

    nDataOffSet: Integer;
    nDataSize: Integer;

    nBackBmpOffSet: Integer;
    nBackBmpSize: Integer;

    nBindItemOffSet: Integer;
    nBindItemSize: Integer;

    nShowItemOffSet: Integer;
    nShowItemSize: Integer;

    nItemDescOffSet: Integer;
    nItemDescSize: Integer;

    btMainInterface: Byte;
    btChatMode: Byte;
    boShowFullScreen: Boolean;

    btItemColor: Byte;

    sPassword: string[50];

    WEffectImg: TLoadMode;
    WDragonImg: TLoadMode;
    WMainImages: TLoadMode;
    WMain2Images: TLoadMode;
    WMain3Images: TLoadMode;
    WChrSelImages: TLoadMode;
    WMMapImages: TLoadMode;
    WHumWingImages: TLoadMode;
    WHum1WingImages: TLoadMode;
    WHum2WingImages: TLoadMode;
    WBagItemImages: TLoadMode;
    WStateItemImages: TLoadMode;
    WDnItemImages: TLoadMode;
    WHumImgImages: TLoadMode;
    WHairImgImages: TLoadMode;
    WHair2ImgImages: TLoadMode;
    WWeaponImages: TLoadMode;
    WMagIconImages: TLoadMode;
    WNpcImgImages: TLoadMode;
    WFirNpcImgImages: TLoadMode;
    WMagicImages: TLoadMode;
    WMagic2Images: TLoadMode;
    WMagic3Images: TLoadMode;
    WMagic4Images: TLoadMode;
    WMagic5Images: TLoadMode;
    WMagic6Images: TLoadMode;
    WHorseImages: TLoadMode;
    WHumHorseImages: TLoadMode;
    WHairHorseImages: TLoadMode;
    WMonImages: array[0..30] of TLoadMode;

    sDomainName: string[255];
    nDomainName: Cardinal;

    sCheckProcessesUrl: string[100];
    PlugArr: array[0..10 - 1] of string[20];


  end;
  pTClientConfig = ^TClientConfig;

  {TClientConfig = record
    nSize: Integer;
    nCrc: Integer;
    btMainInterface: Byte;
    boArr: array[0..10 - 1] of Boolean;
    nArr: array[0..10 - 1] of Integer;
    sCheckProcessesUrl: string[100];
    PlugArr: array[0..10 - 1] of string[20];
  end; }

  {TBindItem = record
    btItemType: Byte;
    sItemName: string[14];
    sBindItemName: string[14];
  end;
  pTBindItem = ^TBindItem; }

  TComponentConfig = record
    Visible: Boolean;
    Left: Integer;
    Top: Integer;
    Width: Integer;
    Height: Integer;
  end;
  pTComponentConfig = ^TComponentConfig;

  TComponentImage = record
    UpSize: Integer;
    HotSize: Integer;
    DownSize: Integer;
    Disabled: Integer;
  end;
  pTComponentImage = ^TComponentImage;

  TComponentConfigs = array[0..16 - 1] of TComponentConfig;
  TComponentImages = array[0..13 - 1] of TComponentImage;


  TGameLoginConfig = record
    ComponentConfigs: TComponentConfigs;
    ComponentImages: TComponentImages;
    Transparent: Boolean;
    LabelConnectColor: TColor;
    LabelConnectingColor: TColor;
    LabelDisconnectColor: TColor;
    ViewFColor: TColor;
    ViewBColor: TColor;
  end;
  pTGameLoginConfig = ^TGameLoginConfig;



  TGameLoginLocalConfig = record
    sTitle: string[30];
    ComponentConfigs: TComponentConfigs;
    ComponentImages: TComponentImages;
    Transparent: Boolean;
    LabelConnectColor: TColor;
    LabelConnectingColor: TColor;
    LabelDisconnectColor: TColor;
    ViewFColor: TColor;
    ViewBColor: TColor;
  end;
  pTGameLoginLocalConfig = ^TGameLoginLocalConfig;

  TFilterItemType = (i_Other, i_HPMPDurg, i_Dress, i_Weapon, i_Jewelry, i_Decoration, i_Decorate, i_All);

  //[其它] [药品] [武器][衣服][头盔][首饰]

{
其他类
药品类
服装类
武器类
首饰类
饰品类
装饰类
}
  TFilterItem = record
    ItemType: TFilterItemType;
    sItemName: string[14];
    boHintMsg: Boolean;
    boPickup: Boolean;
    boShowName: Boolean;
    //boSpecial: Boolean;
    //btColor: Byte;
  end;
  pTFilterItem = ^TFilterItem;

  TItemDesc = record
    Name: string;
    Desc: string;
  end;
  pTItemDesc = ^TItemDesc;
var
  g_ComponentList: TList;
  g_LabelConnectColor: TColor = clLime;
  g_LabelConnectingColor: TColor = clFuchsia;
  g_LabelDisconnectColor: TColor = clYellow;
  g_ViewFColor: TColor = $004080FF;
  g_ViewBColor: TColor = clBlack;
  g_boTransparent: Boolean = False;
  g_ComponentVisibles: array[0..16 - 1] of Boolean;

  g_UnbindItemList: TList;
  g_FilterItemList: TList;
  g_ItemDescList: TList;
  g_sDomainNameFileName: string;

  ColorTable: array[0..255] of TRGBQuad;
  ColorArray: array[0..1023] of byte = (
    $00, $00, $00, $00, $00, $00, $80, $00, $00, $80, $00, $00, $00, $80, $80, $00,
    $80, $00, $00, $00, $80, $00, $80, $00, $80, $80, $00, $00, $C0, $C0, $C0, $00,
    $97, $80, $55, $00, $C8, $B9, $9D, $00, $73, $73, $7B, $00, $29, $29, $2D, $00,
    $52, $52, $5A, $00, $5A, $5A, $63, $00, $39, $39, $42, $00, $18, $18, $1D, $00,
    $10, $10, $18, $00, $18, $18, $29, $00, $08, $08, $10, $00, $71, $79, $F2, $00,
    $5F, $67, $E1, $00, $5A, $5A, $FF, $00, $31, $31, $FF, $00, $52, $5A, $D6, $00,
    $00, $10, $94, $00, $18, $29, $94, $00, $00, $08, $39, $00, $00, $10, $73, $00,
    $00, $18, $B5, $00, $52, $63, $BD, $00, $10, $18, $42, $00, $99, $AA, $FF, $00,
    $00, $10, $5A, $00, $29, $39, $73, $00, $31, $4A, $A5, $00, $73, $7B, $94, $00,
    $31, $52, $BD, $00, $10, $21, $52, $00, $18, $31, $7B, $00, $10, $18, $2D, $00,
    $31, $4A, $8C, $00, $00, $29, $94, $00, $00, $31, $BD, $00, $52, $73, $C6, $00,
    $18, $31, $6B, $00, $42, $6B, $C6, $00, $00, $4A, $CE, $00, $39, $63, $A5, $00,
    $18, $31, $5A, $00, $00, $10, $2A, $00, $00, $08, $15, $00, $00, $18, $3A, $00,
    $00, $00, $08, $00, $00, $00, $29, $00, $00, $00, $4A, $00, $00, $00, $9D, $00,
    $00, $00, $DC, $00, $00, $00, $DE, $00, $00, $00, $FB, $00, $52, $73, $9C, $00,
    $4A, $6B, $94, $00, $29, $4A, $73, $00, $18, $31, $52, $00, $18, $4A, $8C, $00,
    $11, $44, $88, $00, $00, $21, $4A, $00, $10, $18, $21, $00, $5A, $94, $D6, $00,
    $21, $6B, $C6, $00, $00, $6B, $EF, $00, $00, $77, $FF, $00, $84, $94, $A5, $00,
    $21, $31, $42, $00, $08, $10, $18, $00, $08, $18, $29, $00, $00, $10, $21, $00,
    $18, $29, $39, $00, $39, $63, $8C, $00, $10, $29, $42, $00, $18, $42, $6B, $00,
    $18, $4A, $7B, $00, $00, $4A, $94, $00, $7B, $84, $8C, $00, $5A, $63, $6B, $00,
    $39, $42, $4A, $00, $18, $21, $29, $00, $29, $39, $46, $00, $94, $A5, $B5, $00,
    $5A, $6B, $7B, $00, $94, $B1, $CE, $00, $73, $8C, $A5, $00, $5A, $73, $8C, $00,
    $73, $94, $B5, $00, $73, $A5, $D6, $00, $4A, $A5, $EF, $00, $8C, $C6, $EF, $00,
    $42, $63, $7B, $00, $39, $56, $6B, $00, $5A, $94, $BD, $00, $00, $39, $63, $00,
    $AD, $C6, $D6, $00, $29, $42, $52, $00, $18, $63, $94, $00, $AD, $D6, $EF, $00,
    $63, $8C, $A5, $00, $4A, $5A, $63, $00, $7B, $A5, $BD, $00, $18, $42, $5A, $00,
    $31, $8C, $BD, $00, $29, $31, $35, $00, $63, $84, $94, $00, $4A, $6B, $7B, $00,
    $5A, $8C, $A5, $00, $29, $4A, $5A, $00, $39, $7B, $9C, $00, $10, $31, $42, $00,
    $21, $AD, $EF, $00, $00, $10, $18, $00, $00, $21, $29, $00, $00, $6B, $9C, $00,
    $5A, $84, $94, $00, $18, $42, $52, $00, $29, $5A, $6B, $00, $21, $63, $7B, $00,
    $21, $7B, $9C, $00, $00, $A5, $DE, $00, $39, $52, $5A, $00, $10, $29, $31, $00,
    $7B, $BD, $CE, $00, $39, $5A, $63, $00, $4A, $84, $94, $00, $29, $A5, $C6, $00,
    $18, $9C, $10, $00, $4A, $8C, $42, $00, $42, $8C, $31, $00, $29, $94, $10, $00,
    $10, $18, $08, $00, $18, $18, $08, $00, $10, $29, $08, $00, $29, $42, $18, $00,
    $AD, $B5, $A5, $00, $73, $73, $6B, $00, $29, $29, $18, $00, $4A, $42, $18, $00,
    $4A, $42, $31, $00, $DE, $C6, $63, $00, $FF, $DD, $44, $00, $EF, $D6, $8C, $00,
    $39, $6B, $73, $00, $39, $DE, $F7, $00, $8C, $EF, $F7, $00, $00, $E7, $F7, $00,
    $5A, $6B, $6B, $00, $A5, $8C, $5A, $00, $EF, $B5, $39, $00, $CE, $9C, $4A, $00,
    $B5, $84, $31, $00, $6B, $52, $31, $00, $D6, $DE, $DE, $00, $B5, $BD, $BD, $00,
    $84, $8C, $8C, $00, $DE, $F7, $F7, $00, $18, $08, $00, $00, $39, $18, $08, $00,
    $29, $10, $08, $00, $00, $18, $08, $00, $00, $29, $08, $00, $A5, $52, $00, $00,
    $DE, $7B, $00, $00, $4A, $29, $10, $00, $6B, $39, $10, $00, $8C, $52, $10, $00,
    $A5, $5A, $21, $00, $5A, $31, $10, $00, $84, $42, $10, $00, $84, $52, $31, $00,
    $31, $21, $18, $00, $7B, $5A, $4A, $00, $A5, $6B, $52, $00, $63, $39, $29, $00,
    $DE, $4A, $10, $00, $21, $29, $29, $00, $39, $4A, $4A, $00, $18, $29, $29, $00,
    $29, $4A, $4A, $00, $42, $7B, $7B, $00, $4A, $9C, $9C, $00, $29, $5A, $5A, $00,
    $14, $42, $42, $00, $00, $39, $39, $00, $00, $59, $59, $00, $2C, $35, $CA, $00,
    $21, $73, $6B, $00, $00, $31, $29, $00, $10, $39, $31, $00, $18, $39, $31, $00,
    $00, $4A, $42, $00, $18, $63, $52, $00, $29, $73, $5A, $00, $18, $4A, $31, $00,
    $00, $21, $18, $00, $00, $31, $18, $00, $10, $39, $18, $00, $4A, $84, $63, $00,
    $4A, $BD, $6B, $00, $4A, $B5, $63, $00, $4A, $BD, $63, $00, $4A, $9C, $5A, $00,
    $39, $8C, $4A, $00, $4A, $C6, $63, $00, $4A, $D6, $63, $00, $4A, $84, $52, $00,
    $29, $73, $31, $00, $5A, $C6, $63, $00, $4A, $BD, $52, $00, $00, $FF, $10, $00,
    $18, $29, $18, $00, $4A, $88, $4A, $00, $4A, $E7, $4A, $00, $00, $5A, $00, $00,
    $00, $88, $00, $00, $00, $94, $00, $00, $00, $DE, $00, $00, $00, $EE, $00, $00,
    $00, $FB, $00, $00, $94, $5A, $4A, $00, $B5, $73, $63, $00, $D6, $8C, $7B, $00,
    $D6, $7B, $6B, $00, $FF, $88, $77, $00, $CE, $C6, $C6, $00, $9C, $94, $94, $00,
    $C6, $94, $9C, $00, $39, $31, $31, $00, $84, $18, $29, $00, $84, $00, $18, $00,
    $52, $42, $4A, $00, $7B, $42, $52, $00, $73, $5A, $63, $00, $F7, $B5, $CE, $00,
    $9C, $7B, $8C, $00, $CC, $22, $77, $00, $FF, $AA, $DD, $00, $2A, $B4, $F0, $00,
    $9F, $00, $DF, $00, $B3, $17, $E3, $00, $F0, $FB, $FF, $00, $A4, $A0, $A0, $00,
    $80, $80, $80, $00, $00, $00, $FF, $00, $00, $FF, $00, $00, $00, $FF, $FF, $00,
    $FF, $00, $00, $00, $FF, $00, $FF, $00, $FF, $FF, $00, $00, $FF, $FF, $FF, $00
    );
implementation

initialization
  begin
    Move(ColorArray, ColorTable, SizeOf(ColorArray));
    g_ComponentList := TList.Create;
  end;

finalization
  begin
    g_ComponentList.Free;
  end;

end.

