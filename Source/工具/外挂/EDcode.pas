unit EDcode;

interface

uses
  windows, SysUtils, Classes, HUtil32;
type
  TKeyByte = array[0..999] of BYTE;
  TDesMode = (dmEncry, dmDecry);

function Base64EncodeStr(const Value: string): string;
function Base64DecodeStr(const Value: string): string;
function Base64Encode(pInput: Pointer; pOutput: Pointer; Size: Longint): Longint;
function Base64Decode(pInput: Pointer; pOutput: Pointer; Size: Longint): Longint;

function _EncryStr(Str, Key: string): string;
function _DecryStr(Str, Key: string): string;
function _EncryStrHex(Str, Key: string): string;
function _DecryStrHex(StrHex, Key: string): string;

function Chinese2UniCode(AiChinese: string): Integer;
function GetUniCode(Msg: string): Integer;
function Encode(Src: string; var Dest: string): Boolean;
function Decode(Src: string; var Dest: string): Boolean;
function _DecryptString(Src: string): string;
function _EncryptString(Src: string): string;
function _EncryptBuffer(Buf: PChar; bufsize: Integer): string;
function _DecryptBuffer(Src: string; Buf: PChar; bufsize: Integer): Boolean;
implementation
const
  B64: array[0..63] of BYTE = (65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80,
    81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108,
    109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 48, 49, 50, 51, 52, 53,
    54, 55, 56, 57, 43, 47);
  Key: array[0..2, 0..7] of BYTE = (($FF, $FE, $FF, $FE, $FF, $FE, $FF, $FF), ($FF, $FE, $FF, $FE, $FF, $FE, $FF, $FF), ($FF, $FE, $FF, $FE, $FF, $FE, $FF, $FF));

  BitIP: array[0..63] of BYTE = //≥ı º÷µ÷√IP
  (57, 49, 41, 33, 25, 17, 9, 1,
    59, 51, 43, 35, 27, 19, 11, 3,
    61, 53, 45, 37, 29, 21, 13, 5,
    63, 55, 47, 39, 31, 23, 15, 7,
    56, 48, 40, 32, 24, 16, 8, 0,
    58, 50, 42, 34, 26, 18, 10, 2,
    60, 52, 44, 36, 28, 20, 12, 4,
    62, 54, 46, 38, 30, 22, 14, 6);

  BitCP: array[0..63] of BYTE = //ƒÊ≥ı º÷√IP-1
  (39, 7, 47, 15, 55, 23, 63, 31,
    38, 6, 46, 14, 54, 22, 62, 30,
    37, 5, 45, 13, 53, 21, 61, 29,
    36, 4, 44, 12, 52, 20, 60, 28,
    35, 3, 43, 11, 51, 19, 59, 27,
    34, 2, 42, 10, 50, 18, 58, 26,
    33, 1, 41, 9, 49, 17, 57, 25,
    32, 0, 40, 8, 48, 16, 56, 24);

  BitExp: array[0..47] of Integer = // Œª—°‘Ò∫Ø ˝E
  (31, 0, 1, 2, 3, 4, 3, 4, 5, 6, 7, 8, 7, 8, 9, 10,
    11, 12, 11, 12, 13, 14, 15, 16, 15, 16, 17, 18, 19, 20, 19, 20,
    21, 22, 23, 24, 23, 24, 25, 26, 27, 28, 27, 28, 29, 30, 31, 0);

  BitPM: array[0..31] of BYTE = //÷√ªª∫Ø ˝P
  (15, 6, 19, 20, 28, 11, 27, 16, 0, 14, 22, 25, 4, 17, 30, 9,
    1, 7, 23, 13, 31, 26, 2, 8, 18, 12, 29, 5, 21, 10, 3, 24);

  sBox: array[0..7] of array[0..63] of BYTE = //S∫–
  ((14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7,
    0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8,
    4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0,
    15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13),

    (15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10,
    3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5,
    0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15,
    13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9),

    (10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8,
    13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1,
    13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7,
    1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12),

    (7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15,
    13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9,
    10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4,
    3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14),

    (2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9,
    14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6,
    4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14,
    11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3),

    (12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11,
    10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8,
    9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6,
    4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13),

    (4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1,
    13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6,
    1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2,
    6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12),

    (13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7,
    1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2,
    7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8,
    2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11));

  BitPMC1: array[0..55] of BYTE = //—°‘Ò÷√ªªPC-1
  (56, 48, 40, 32, 24, 16, 8,
    0, 57, 49, 41, 33, 25, 17,
    9, 1, 58, 50, 42, 34, 26,
    18, 10, 2, 59, 51, 43, 35,
    62, 54, 46, 38, 30, 22, 14,
    6, 61, 53, 45, 37, 29, 21,
    13, 5, 60, 52, 44, 36, 28,
    20, 12, 4, 27, 19, 11, 3);

  BitPMC2: array[0..47] of BYTE = //—°‘Ò÷√ªªPC-2
  (13, 16, 10, 23, 0, 4,
    2, 27, 14, 5, 20, 9,
    22, 18, 11, 3, 25, 7,
    15, 6, 26, 19, 12, 1,
    40, 51, 30, 36, 46, 54,
    29, 39, 50, 44, 32, 47,
    43, 48, 38, 55, 33, 52,
    45, 41, 49, 35, 28, 31);

var
  subKey: array[0..15] of TKeyByte;

function Chinese2UniCode(AiChinese: string): Integer;
var
  Ch, cl: string[2];
  a: array[1..2] of char;
begin
  StringToWideChar(Copy(AiChinese, 1, 2), @(a[1]), 2);
  Ch := IntToHex(Integer(a[2]), 2);
  cl := IntToHex(Integer(a[1]), 2);
  Result := StrToInt('$' + Ch + cl);
end;

function GetUniCode(Msg: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 1 to Length(Msg) do begin
    Result := Result + Chinese2UniCode(Msg[I]) * I;
  end;
end;

function ReverseString(const AText: string): string;
var
  I: Integer;
  P: PChar;
begin
  SetLength(Result, Length(AText));
  P := PChar(Result);
  for I := Length(AText) downto 1 do
  begin
    P^ := AText[I];
    Inc(P);
  end;
end;

function _DecryptString(Src: string): string;
begin
  if not Decode(Src, Result) then Result := '';
end;

function _EncryptString(Src: string): string;
begin
  if not Encode(Src, Result) then Result := '';
end;

function _EncryptBuffer(Buf: PChar; bufsize: Integer): string;
var
  Src: string;
begin
  SetLength(Src, bufsize + 1);
  Move(Buf^, Src[1], bufsize + 1);
  Result := _EncryptString(Src);
end;

function _DecryptBuffer(Src: string; Buf: PChar; bufsize: Integer): Boolean;
var
  Dest: string;
begin
  Result := False;
  if Decode(Src, Dest) then begin
    if Dest <> '' then begin
      Move(Dest[1], Buf^, bufsize);
      Result := True;
    end;
  end;
end;

function Encode(Src: string; var Dest: string): Boolean;
var
  sDest, sEncodeStr: string;
  I, nIndex1, nIndex2, nLen: Integer;
begin
  Result := False;
  Dest := '';
  try
    if Src <> '' then begin
      sDest := Base64EncodeStr(ReverseString(Src));
      sDest := ReverseString(_EncryStrHex(sDest, IntToStr(718846558)));
      nLen := Length(sDest);
      nIndex1 := 1;
      nIndex2 := nLen div 2 + 1;
      SetLength(sEncodeStr, nLen);
      for I := 1 to nLen do begin //∞¥’’∆Ê≈º≈≈¡–
        if (I <> 1) and (I mod 2 = 0) then begin
          sEncodeStr[nIndex1] := sDest[I];
          Inc(nIndex1);
        end else begin
          sEncodeStr[nIndex2] := sDest[I];
          Inc(nIndex2);
        end;
      end;

      Dest := ReverseString(sEncodeStr);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

function Decode(Src: string; var Dest: string): Boolean;
var
  I, nIndex1, nIndex2, nLen: Integer;
  sDest, sDecodeStr: string;
begin
  Result := False;
  try
    Dest := '';
    sDest := ReverseString(Src);
    if sDest <> '' then begin
      nLen := Length(sDest);
      nIndex1 := 1;
      nIndex2 := nLen div 2 + 1;

      SetLength(sDecodeStr, nLen);
      for I := 1 to nLen do begin //∞¥’’∆Ê≈º≈≈¡–
        if (I <> 1) and (I mod 2 = 0) then begin
          sDecodeStr[I] := sDest[nIndex1];
          Inc(nIndex1);
        end else begin
          sDecodeStr[I] := sDest[nIndex2];
          Inc(nIndex2);
        end;
      end;

      sDest := ReverseString(sDecodeStr);
      try
        sDest := _DecryStrHex(sDest, IntToStr(718846558));
      except
        Exit;
      end;

      Dest := ReverseString(Base64DecodeStr(sDest));
      Result := True;
    end;
  except
    Result := False;
  end;
end;

function CalcFileCRC(sFileName: string): Integer;
var
  I: Integer;
  nFileHandle: Integer;
  nFileSize, nBuffSize: Integer;
  Buffer: PChar;
  Int: ^Integer;
  nCrc: Integer;
begin
  Result := 0;
  if not FileExists(sFileName) then Exit;
  nFileHandle := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
  if nFileHandle = 0 then
    Exit;
  nFileSize := FileSeek(nFileHandle, 0, 2);
  nBuffSize := (nFileSize div 4) * 4;
  GetMem(Buffer, nBuffSize);
  FillChar(Buffer^, nBuffSize, 0);
  FileSeek(nFileHandle, 0, 0);
  FileRead(nFileHandle, Buffer^, nBuffSize);
  FileClose(nFileHandle);
  Int := Pointer(Buffer);
  nCrc := 0;
  Exception.Create(IntToStr(SizeOf(Integer)));
  for I := 0 to nBuffSize div 4 - 1 do begin
    nCrc := nCrc xor Int^;
    Int := Pointer(Integer(Int) + 4);
  end;
  FreeMem(Buffer);
  Result := nCrc;
end;

function CalcBufferCRC(Buffer: PChar; nSize: Integer): Integer;
var
  I: Integer;
  Int: ^Integer;
  nCrc: Integer;
begin
  Int := Pointer(Buffer);
  nCrc := 0;
  for I := 0 to nSize div 4 - 1 do begin
    nCrc := nCrc xor Int^;
    Int := Pointer(Integer(Int) + 4);
  end;
  Result := nCrc;
end;

function Base64Encode(pInput: Pointer; pOutput: Pointer; Size: Longint): Longint;
var
  I, iptr, optr: Integer;
  Input, Output: PByteArray;
begin
  Input := PByteArray(pInput); Output := PByteArray(pOutput);
  iptr := 0; optr := 0;
  for I := 1 to (Size div 3) do begin
    Output^[optr + 0] := B64[Input^[iptr] shr 2];
    Output^[optr + 1] := B64[((Input^[iptr] and 3) shl 4) + (Input^[iptr + 1] shr 4)];
    Output^[optr + 2] := B64[((Input^[iptr + 1] and 15) shl 2) + (Input^[iptr + 2] shr 6)];
    Output^[optr + 3] := B64[Input^[iptr + 2] and 63];
    Inc(optr, 4); Inc(iptr, 3);
  end;
  case (Size mod 3) of
    1: begin
        Output^[optr + 0] := B64[Input^[iptr] shr 2];
        Output^[optr + 1] := B64[(Input^[iptr] and 3) shl 4];
        Output^[optr + 2] := BYTE('=');
        Output^[optr + 3] := BYTE('=');
      end;
    2: begin
        Output^[optr + 0] := B64[Input^[iptr] shr 2];
        Output^[optr + 1] := B64[((Input^[iptr] and 3) shl 4) + (Input^[iptr + 1] shr 4)];
        Output^[optr + 2] := B64[(Input^[iptr + 1] and 15) shl 2];
        Output^[optr + 3] := BYTE('=');
      end;
  end;
  Result := ((Size + 2) div 3) * 4;
end;

function Base64EncodeStr(const Value: string): string;
begin
  SetLength(Result, ((Length(Value) + 2) div 3) * 4);
  Base64Encode(@Value[1], @Result[1], Length(Value));
end;

function Base64Decode(pInput: Pointer; pOutput: Pointer; Size: Longint): Longint;
var
  I, j, iptr, optr: Integer;
  temp: array[0..3] of BYTE;
  Input, Output: PByteArray;
begin
  Input := PByteArray(pInput); Output := PByteArray(pOutput);
  iptr := 0; optr := 0;
  Result := 0;
  for I := 1 to (Size div 4) do begin
    for j := 0 to 3 do begin
      case Input^[iptr] of
        65..90: temp[j] := Input^[iptr] - Ord('A');
        97..122: temp[j] := Input^[iptr] - Ord('a') + 26;
        48..57: temp[j] := Input^[iptr] - Ord('0') + 52;
        43: temp[j] := 62;
        47: temp[j] := 63;
        61: temp[j] := $FF;
      end;
      Inc(iptr);
    end;
    Output^[optr] := (temp[0] shl 2) or (temp[1] shr 4);
    Result := optr + 1;
    if (temp[2] <> $FF) and (temp[3] = $FF) then begin
      Output^[optr + 1] := (temp[1] shl 4) or (temp[2] shr 2);
      Result := optr + 2;
      Inc(optr)
    end
    else if (temp[2] <> $FF) then begin
      Output^[optr + 1] := (temp[1] shl 4) or (temp[2] shr 2);
      Output^[optr + 2] := (temp[2] shl 6) or temp[3];
      Result := optr + 3;
      Inc(optr, 2);
    end;
    Inc(optr);
  end;
end;

function Base64DecodeStr(const Value: string): string;
begin
  SetLength(Result, (Length(Value) div 4) * 3);
  SetLength(Result, Base64Decode(@Value[1], @Result[1], Length(Value)));
end;

{------------------------------------------------------------------------------}
procedure initPermutation(var inData: array of BYTE);
var
  newData: array[0..7] of BYTE;
  I: Integer;
begin
  FillChar(newData, 8, 0);
  for I := 0 to 63 do
    if (inData[BitIP[I] shr 3] and (1 shl (7 - (BitIP[I] and $07)))) <> 0 then
      newData[I shr 3] := newData[I shr 3] or (1 shl (7 - (I and $07)));
  for I := 0 to 7 do inData[I] := newData[I];
end;

procedure conversePermutation(var inData: array of BYTE);
var
  newData: array[0..7] of BYTE;
  I: Integer;
begin
  FillChar(newData, 8, 0);
  for I := 0 to 63 do
    if (inData[BitCP[I] shr 3] and (1 shl (7 - (BitCP[I] and $07)))) <> 0 then
      newData[I shr 3] := newData[I shr 3] or (1 shl (7 - (I and $07)));
  for I := 0 to 7 do inData[I] := newData[I];
end;

procedure Expand(inData: array of BYTE; var outData: array of BYTE);
var
  I: Integer;
begin
  FillChar(outData, 6, 0);
  for I := 0 to 47 do
    if (inData[BitExp[I] shr 3] and (1 shl (7 - (BitExp[I] and $07)))) <> 0 then
      outData[I shr 3] := outData[I shr 3] or (1 shl (7 - (I and $07)));
end;

procedure permutation(var inData: array of BYTE);
var
  newData: array[0..3] of BYTE;
  I: Integer;
begin
  FillChar(newData, 4, 0);
  for I := 0 to 31 do
    if (inData[BitPM[I] shr 3] and (1 shl (7 - (BitPM[I] and $07)))) <> 0 then
      newData[I shr 3] := newData[I shr 3] or (1 shl (7 - (I and $07)));
  for I := 0 to 3 do inData[I] := newData[I];
end;

function si(s, inByte: BYTE): BYTE;
var
  c: BYTE;
begin
  c := (inByte and $20) or ((inByte and $1E) shr 1) or
    ((inByte and $01) shl 4);
  Result := (sBox[s][c] and $0F);
end;

procedure permutationChoose1(inData: array of BYTE;
  var outData: array of BYTE);
var
  I: Integer;
begin
  FillChar(outData, 7, 0);
  for I := 0 to 55 do
    if (inData[BitPMC1[I] shr 3] and (1 shl (7 - (BitPMC1[I] and $07)))) <> 0 then
      outData[I shr 3] := outData[I shr 3] or (1 shl (7 - (I and $07)));
end;

procedure permutationChoose2(inData: array of BYTE;
  var outData: array of BYTE);
var
  I: Integer;
begin
  FillChar(outData, 6, 0);
  for I := 0 to 47 do
    if (inData[BitPMC2[I] shr 3] and (1 shl (7 - (BitPMC2[I] and $07)))) <> 0 then
      outData[I shr 3] := outData[I shr 3] or (1 shl (7 - (I and $07)));
end;

procedure cycleMove(var inData: array of BYTE; bitMove: BYTE);
var
  I: Integer;
begin
  for I := 0 to bitMove - 1 do begin
    inData[0] := (inData[0] shl 1) or (inData[1] shr 7);
    inData[1] := (inData[1] shl 1) or (inData[2] shr 7);
    inData[2] := (inData[2] shl 1) or (inData[3] shr 7);
    inData[3] := (inData[3] shl 1) or ((inData[0] and $10) shr 4);
    inData[0] := (inData[0] and $0F);
  end;
end;

procedure makeKey(inKey: array of BYTE; var outKey: array of TKeyByte);
const
  bitDisplace: array[0..15] of BYTE =
  (1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1);
var
  outData56: array[0..6] of BYTE;
  key28l: array[0..3] of BYTE;
  key28r: array[0..3] of BYTE;
  key56o: array[0..6] of BYTE;
  I: Integer;
begin
  permutationChoose1(inKey, outData56);

  key28l[0] := outData56[0] shr 4;
  key28l[1] := (outData56[0] shl 4) or (outData56[1] shr 4);
  key28l[2] := (outData56[1] shl 4) or (outData56[2] shr 4);
  key28l[3] := (outData56[2] shl 4) or (outData56[3] shr 4);
  key28r[0] := outData56[3] and $0F;
  key28r[1] := outData56[4];
  key28r[2] := outData56[5];
  key28r[3] := outData56[6];

  for I := 0 to 15 do begin
    cycleMove(key28l, bitDisplace[I]);
    cycleMove(key28r, bitDisplace[I]);
    key56o[0] := (key28l[0] shl 4) or (key28l[1] shr 4);
    key56o[1] := (key28l[1] shl 4) or (key28l[2] shr 4);
    key56o[2] := (key28l[2] shl 4) or (key28l[3] shr 4);
    key56o[3] := (key28l[3] shl 4) or (key28r[0]);
    key56o[4] := key28r[1];
    key56o[5] := key28r[2];
    key56o[6] := key28r[3];
    permutationChoose2(key56o, outKey[I]);
  end;
end;

procedure Encry(inData, subKey: array of BYTE;
  var outData: array of BYTE);
var
  outBuf: array[0..5] of BYTE;
  Buf: array[0..7] of BYTE;
  I: Integer;
begin
  Expand(inData, outBuf);
  for I := 0 to 5 do outBuf[I] := outBuf[I] xor subKey[I];
  Buf[0] := outBuf[0] shr 2;
  Buf[1] := ((outBuf[0] and $03) shl 4) or (outBuf[1] shr 4);
  Buf[2] := ((outBuf[1] and $0F) shl 2) or (outBuf[2] shr 6);
  Buf[3] := outBuf[2] and $3F;
  Buf[4] := outBuf[3] shr 2;
  Buf[5] := ((outBuf[3] and $03) shl 4) or (outBuf[4] shr 4);
  Buf[6] := ((outBuf[4] and $0F) shl 2) or (outBuf[5] shr 6);
  Buf[7] := outBuf[5] and $3F;
  for I := 0 to 7 do Buf[I] := si(I, Buf[I]);
  for I := 0 to 3 do outBuf[I] := (Buf[I * 2] shl 4) or Buf[I * 2 + 1];
  permutation(outBuf);
  for I := 0 to 3 do outData[I] := outBuf[I];
end;

procedure desData(desMode: TDesMode;
  inData: array of BYTE; var outData: array of BYTE);
// inData, outData ∂ºŒ™8Bytes£¨∑Ò‘Ú≥ˆ¥Ì
var
  I, j: Integer;
  temp, Buf: array[0..3] of BYTE;
begin
  for I := 0 to 7 do outData[I] := inData[I];
  initPermutation(outData);
  if desMode = dmEncry then begin
    for I := 0 to 15 do begin
      for j := 0 to 3 do temp[j] := outData[j]; //temp = Ln
      for j := 0 to 3 do outData[j] := outData[j + 4]; //Ln+1 = Rn
      Encry(outData, subKey[I], Buf); //Rn ==Kn==> buf
      for j := 0 to 3 do outData[j + 4] := temp[j] xor Buf[j]; //Rn+1 = Ln^buf
    end;

    for j := 0 to 3 do temp[j] := outData[j + 4];
    for j := 0 to 3 do outData[j + 4] := outData[j];
    for j := 0 to 3 do outData[j] := temp[j];
  end
  else if desMode = dmDecry then begin
    for I := 15 downto 0 do begin
      for j := 0 to 3 do temp[j] := outData[j];
      for j := 0 to 3 do outData[j] := outData[j + 4];
      Encry(outData, subKey[I], Buf);
      for j := 0 to 3 do outData[j + 4] := temp[j] xor Buf[j];
    end;
    for j := 0 to 3 do temp[j] := outData[j + 4];
    for j := 0 to 3 do outData[j + 4] := outData[j];
    for j := 0 to 3 do outData[j] := temp[j];
  end;
  conversePermutation(outData);
end;

//////////////////////////////////////////////////////////////

function _EncryStr(Str, Key: string): string;
var
  StrByte, OutByte, KeyByte: array[0..7] of BYTE;
  StrResult: string;
  I, j: Integer;
begin
  {if (Length(Str) > 0) and (Ord(Str[Length(Str)]) = 0) then
    raise Exception.Create('Error: the last char is NULL char.'); }
  if Length(Key) < 8 then
    while Length(Key) < 8 do Key := Key + Chr(0);
  while Length(Str) mod 8 <> 0 do Str := Str + Chr(0);

  for j := 0 to 7 do KeyByte[j] := Ord(Key[j + 1]);
  makeKey(KeyByte, subKey);

  StrResult := '';

  for I := 0 to Length(Str) div 8 - 1 do begin
    for j := 0 to 7 do
      StrByte[j] := Ord(Str[I * 8 + j + 1]);
    desData(dmEncry, StrByte, OutByte);
    for j := 0 to 7 do
      StrResult := StrResult + Chr(OutByte[j]);
  end;

  Result := StrResult;
end;

function _DecryStr(Str, Key: string): string;
var
  StrByte, OutByte, KeyByte: array[0..7] of BYTE;
  StrResult: string;
  I, j: Integer;
begin
  if Length(Key) < 8 then
    while Length(Key) < 8 do Key := Key + Chr(0);

  for j := 0 to 7 do KeyByte[j] := Ord(Key[j + 1]);
  makeKey(KeyByte, subKey);

  StrResult := '';

  for I := 0 to Length(Str) div 8 - 1 do begin
    for j := 0 to 7 do StrByte[j] := Ord(Str[I * 8 + j + 1]);
    desData(dmDecry, StrByte, OutByte);
    for j := 0 to 7 do
      StrResult := StrResult + Chr(OutByte[j]);
  end;
  while (Length(StrResult) > 0) and
    (Ord(StrResult[Length(StrResult)]) = 0) do
    Delete(StrResult, Length(StrResult), 1);
  Result := StrResult;
end;

///////////////////////////////////////////////////////////

function _EncryStrHex(Str, Key: string): string;
var
  StrResult, TempResult, temp: string;
  I: Integer;
begin
  TempResult := _EncryStr(Str, Key);
  StrResult := '';
  for I := 0 to Length(TempResult) - 1 do begin
    temp := Format('%x', [Ord(TempResult[I + 1])]);
    if Length(temp) = 1 then temp := '0' + temp;
    StrResult := StrResult + temp;
  end;
  Result := StrResult;
end;

function _DecryStrHex(StrHex, Key: string): string;
  function HexToInt(Hex: string): Integer;
  var
    I, Res: Integer;
    Ch: char;
  begin
    Res := 0;
    for I := 0 to Length(Hex) - 1 do begin
      Ch := Hex[I + 1];
      if (Ch >= '0') and (Ch <= '9') then
        Res := Res * 16 + Ord(Ch) - Ord('0')
      else if (Ch >= 'A') and (Ch <= 'F') then
        Res := Res * 16 + Ord(Ch) - Ord('A') + 10
      else if (Ch >= 'a') and (Ch <= 'f') then
        Res := Res * 16 + Ord(Ch) - Ord('a') + 10
      else raise Exception.Create('Error: not a Hex String');
    end;
    Result := Res;
  end;

var
  Str, temp: string;
  I: Integer;
begin
  Str := '';
  for I := 0 to Length(StrHex) div 2 - 1 do begin
    temp := Copy(StrHex, I * 2 + 1, 2);
    Str := Str + Chr(HexToInt(temp));
  end;
  Result := _DecryStr(Str, Key);
end;
initialization
  begin
    Randomize;
  end;


finalization
  begin

  end;

end.

