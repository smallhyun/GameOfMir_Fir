unit DesEncryptor;

interface

uses
  Classes, SysUtils, Unit1;

type
  EDesError = class(Exception)
  end;

  TDesEncryptor = class
  private
    KeyData: array[0..15] of array[0..47] of Byte;
    Key: string;
    procedure MakeKeyData;
  public
    function GetMaxEncodeSize(DataSize: Integer): Integer;
//计算对DataSize字节的明文加密后密文的最大长度
    function GetMaxDecodeSize(DataSize: Integer): Integer;
//计算对DataSize字节的密文解密后明文的最大长度
    function EncodeMem(var Data; DataSize: Integer): Integer;
//对Data中DataSize字节的数据加密，密文存放在Data中，返回回值为密文长度。
    function DecodeMem(var Data; DataSize: Integer): Integer;
//对Data中的DataSize字节的数据解密，明文存放在Data中，返回值为明文长度。
    procedure EncodeVar(var Data: OleVariant);
//对Data加密,Data应为Variant Array of Byte类型,密文存放在Data中，
//Data的元素个数将发生变化，因此不能是被锁住的。。
    procedure DecodeVar(var Data: OleVariant);
//对Data加密,Data应为Variant Array of Byte类型,密文存放在Data中，
//Data的元素个数将发生变化，因此不能是被锁住的。。
    procedure Encode(const InStream, OutStream: TStream);
//对InStream中的内容加密，密文存入OutStream中。InStream和OutStream可以是同一对象。
    procedure Decode(const InStream, OutStream: TStream);
//对InStream中的内容加密，密文存入OutStream中。InStream和OutStream可以是同一对象。
    procedure SetKey(theKey: string);
{ Protected declarations }
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation


uses DesUtil, Windows, Variants, Sha;

type
  TByteAry = array[0..32767] of Byte;
  PByteAry = ^TByteAry;
  TByteVarAry = array of Byte;
  PByteVarAry = ^TByteVarAry;

//resourcestring
//  SErrorDesBadcryptograph = '密文已被损坏，无法解密。';

function FindByteBack(Pattern: Byte; const Data; DataSize: Integer): Integer; assembler;
asm
    PUSH EDI;
    LEA EDI, [EDX + ECX - 1];
    STD;
    CMP ECX, 1;
    REPNE SCASB;
    MOV EAX, ECX;
    CLD;
    JE @FOUND;
    MOV EAX, -1;
    @FOUND:
    POP EDI;
end;

procedure TDesEncryptor.SetKey(theKey: string);
begin
  Key := theKey;
  MakeKeyData;
end;

procedure TDesEncryptor.DecodeVar(var Data: OleVariant);
var
  DataBits: array[0..63] of Byte;
  Level: Integer;
  ptrData: PByteArray;
  I, DataSize, NewDataSize: Integer;
begin
  Level := 16;
  DataSize := VarArrayHighBound(Data, 1) - VarArrayLowBound(Data, 1) + 1;
  if DataSize mod 8 <> 0 then
  begin
    DataSize := (DataSize div 8) * 8;
    VarArrayRedim(Data, DataSize + VarArrayLowBound(Data, 1) - 1);
  end;
  ptrData := VarArrayLock(Data);
  try
    I := 0;
    while (I < DataSize) do
    begin
      GetBits(ptrData^[I], DataBits, 8);
      UNDES(DataBits, KeyData[0], Level);
      SetBits(DataBits, ptrData^[I], 8);
      Inc(I, 8);
    end;
    NewDataSize := FindByteBack($FF, PtrData[0], DataSize);
  finally
    VarArrayUnlock(Data);
  end;
  //if NewDataSize < 0 then
    //raise EDesError.CreateRes(@SErrorDesBadcryptograph);
  if NewDataSize >= 0 then
    VarArrayRedim(Data, NewDataSize + VarArrayLowBound(Data, 1) - 1);
end;

procedure TDesEncryptor.EncodeVar(var Data: OleVariant);
var
  DataBits: array[0..63] of Byte;
  Level: Integer;
  ptrData: PByteArray;
  I, DataSize, OldDataSize: Integer;
begin
  Level := 16;
  DataSize := VarArrayHighBound(Data, 1) - VarArrayLowBound(Data, 1) + 1;
  OldDataSize := DataSize;
  DataSize := (DataSize div 8 + 1) * 8;
  VarArrayRedim(Data, DataSize - VarArrayLowBound(Data, 1) - 1);
  ptrData := VarArrayLock(Data);
  try
    ptrData[OldDataSize] := $FF;
    for I := OldDataSize + 1 to DataSize - 1 do
      ptrData[I] := Random(255);
    I := 0;
    while (I < DataSize) do
    begin
      GetBits(ptrData^[I], DataBits, 8);
      DES(DataBits, KeyData[0], Level);
      SetBits(DataBits, ptrData^[I], 8);
      Inc(I, 8);
    end;
  finally
    VarArrayUnlock(Data);
  end;
end;

procedure TDesEncryptor.Decode(const InStream, OutStream: TStream);
const
  BlockSize = 1024;
  bBlockSize = BlockSize * 8;
var
  DataBits: array[0..63] of Byte;
  Data: array[0..BlockSize - 1, 0..7] of Byte;
  Level: Integer;
  InSize, Progress, ReadPos, WritePos, SizeOfHoleBlock: Int64;
  LastBlockSize, ProgressInBlock: Integer;
begin
  Level := 16;

  InSize := InStream.Size;
  InStream.Position := 0;
  OutStream.Position := 0;

  Progress := 0;
  ReadPos := 0;
  WritePos := 0;

  SizeOfHoleBlock := ((InSize - 1) div BlockSize) * BlockSize;

  while Progress < SizeOfHoleBlock do
  begin
    InStream.Position := ReadPos;
    InStream.Read(Data[0, 0], bBlockSize);

    for ProgressInBlock := 0 to BlockSize - 1 do
    begin
      GetBits(Data[ProgressInBlock, 0], DataBits, 8);
      UNDES(DataBits, KeyData[0], Level);
      SetBits(DataBits, Data[ProgressInBlock, 0], 8);
    end;
    OutStream.Position := WritePos;
    OutStream.Write(Data[0, 0], bBlockSize);

    Inc(ReadPos, bBlockSize);
    Inc(WritePos, bBlockSize);
    Inc(Progress, bBlocksize);
  end;

  InSize := InSize - SizeOfHoleBlock;

  InStream.Position := ReadPos;
  InStream.Read(Data, InSize);

  LastBlockSize := InSize div 8;
  InSize := LastBlockSize * 8;

  for ProgressInBlock := 0 to LastBlockSize - 1 do
  begin
    GetBits(Data[ProgressInBlock, 0], DataBits, 8);
    UNDES(DataBits, KeyData[0], Level);
    SetBits(DataBits, Data[ProgressInBlock, 0], 8);
  end;

  InSize := FindByteBack($FF, Data, InSize);
  //if InSize < 0 then
   // raise EDesError.CreateRes(@SErrorDesBadcryptograph);

  if InSize >= 0 then begin
    OutStream.Position := WritePos;
    OutStream.Write(Data[0, 0], InSize);
    OutStream.Size := OutStream.Position;
  end;
end;

procedure TDesEncryptor.Encode(const InStream, OutStream: TStream);
const
  BlockSize = 1024;
  bBlockSize = BlockSize * 8;
var
  DataBits: array[0..63] of Byte;
  Data: array[0..BlockSize - 1, 0..7] of Byte;
  Level: Integer;
  InSize, Progress, ReadPos, WritePos, SizeOfHoleBlock: Int64;
  LastBlockSize, ProgressInBlock: Integer;
  I: Integer;
begin
  Level := 16;

  InSize := InStream.Size;
  InStream.Position := 0;
  OutStream.Position := 0;

  Progress := 0;
  ReadPos := 0;
  WritePos := 0;

  SizeOfHoleBlock := InSize - InSize mod bBlockSize;

  while Progress < SizeOfHoleBlock do
  begin
    InStream.Position := ReadPos;
    InStream.Read(Data[0, 0], bBlockSize);

    for ProgressInBlock := 0 to BlockSize - 1 do
    begin
      GetBits(Data[ProgressInBlock, 0], DataBits, 8);
      DES(DataBits, KeyData[0], Level);
      SetBits(DataBits, Data[ProgressInBlock, 0], 8);
    end;

    OutStream.Position := WritePos;
    OutStream.Write(Data[0, 0], bBlockSize);

    Inc(ReadPos, bBlockSize);
    Inc(WritePos, bBlockSize);
    Inc(Progress, bBlocksize);
  end;

  InSize := InSize mod bBlockSize;
  InStream.Position := ReadPos;
  InStream.Read(Data, InSize);

  LastBlockSize := InSize div 8 + 1;

  PByteAry(@Data)^[InSize] := $FF;
  for I := InSize + 1 to LastBlockSize * 8 - 1 do
    PByteAry(@Data)^[I] := Random(255);

  for ProgressInBlock := 0 to LastBlockSize - 1 do
  begin
    GetBits(Data[ProgressInBlock, 0], DataBits, 8);
    DES(DataBits, KeyData[0], Level);
    SetBits(DataBits, Data[ProgressInBlock, 0], 8);
  end;
  OutStream.Position := WritePos;
  OutStream.Write(Data[0, 0], LastBlockSize * 8);
  OutStream.Size := SizeOfHoleBlock + LastBlockSize * 8;
end;

procedure TDesEncryptor.MakeKeyData;
{const
  KeySuffixes: array[0..5] of string =
  ('dsafsda',
    'rerwawe',
    '32522asf',
    ',.[[]-\',
    '`2304-`',
    'va[0e324');}
var
  PackedKeyData: array[0..95] of Byte;
  Temp: string;
  I: Integer;
begin
 { for I := 0 to 5 do
  begin
    Temp := Key + KeySuffixes[I];
    MD5Code(Temp[1], PackedKeyData[I * 16], Length(Temp));
  end;   }
  FillChar(PackedKeyData, SizeOf(PackedKeyData), 0);
  FillChar(KeyData, SizeOf(KeyData), 0);
  ShaFinal(Key, PackedKeyData);
  //ShaFinal(Key, PackedKeyData[20]);
  //ShaFinal(Key, PackedKeyData[40]);
  //ShaFinal(Key, PackedKeyData[60]);
  Move(PackedKeyData, PackedKeyData[20], 20);
  Move(PackedKeyData, PackedKeyData[40], 20);
  Move(PackedKeyData, PackedKeyData[60], 20);
  Move(PackedKeyData, PackedKeyData[80], 16);
  {for I:=0 to 19 do begin
    Form1.Memo1.Lines.Add(IntToStr(PackedKeyData[I]));
  end; }
  //ShaFinal(Key, PackedKeyData[80]);
  for I := 0 to 15 do
    GetBits(PackedKeyData[I * 6], KeyData[I], 6);
end;

destructor TDesEncryptor.Destroy;
begin
  inherited;
end;

constructor TDesEncryptor.Create;
begin
  inherited Create;
  SetKey('')
end;

function TDesEncryptor.DecodeMem(var Data; DataSize: Integer): Integer;
var
  DataBits: array[0..63] of Byte;
  Level: Integer;
  ptrData: PByteArray;
  I: Integer;
begin
  Level := 16;

  if DataSize mod 8 <> 0 then
  begin
    DataSize := (DataSize div 8) * 8;
  end;
  ptrData := @Data;
  I := 0;
  while (I < DataSize) do
  begin
    GetBits(ptrData^[I], DataBits, 8);
    UNDES(DataBits, KeyData[0], Level);
    SetBits(DataBits, ptrData^[I], 8);
    Inc(I, 8);
  end;
  Result := FindByteBack($FF, Data, DataSize);
  //if Result < 0 then
    //raise EDesError.CreateRes(@SErrorDesBadcryptograph);
end;

function TDesEncryptor.EncodeMem(var Data; DataSize: Integer): Integer;
var
  DataBits: array[0..63] of Byte;
  Level: Integer;
  ptrData: PByteArray;
  I, OldDataSize: Integer;
begin
  Level := 16;
  OldDataSize := DataSize;
  DataSize := (DataSize div 8 + 1) * 8;
  ptrData := @Data;
  PtrData[OldDataSize] := $FF;
  for I := OldDataSize + 1 to DataSize - 1 do
    PtrData[I] := Random(255);

  I := 0;
  while (I < DataSize) do
  begin
    GetBits(ptrData^[I], DataBits, 8);
    DES(DataBits, KeyData[0], Level);
    SetBits(DataBits, ptrData^[I], 8);
    Inc(I, 8);
  end;
  Result := DataSize;
end;

function TDesEncryptor.GetMaxDecodeSize(DataSize: Integer): Integer;
begin
  Result := DataSize;
end;

function TDesEncryptor.GetMaxEncodeSize(DataSize: Integer): Integer;
begin
  Result := ((DataSize + 1) div 8 + 1) * 8;
end;

initialization
  Randomize;


end.

