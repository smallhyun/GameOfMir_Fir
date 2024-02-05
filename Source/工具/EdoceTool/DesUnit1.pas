unit DesUnit;

interface
uses
  Classes, Sysutils;
procedure Encrypt(const Indata; var Outdata; const Key: string);
procedure Decrypt(const Indata; var Outdata; const Key: string);
function EncryptString(const Str, Key: string): string;
function DecryptString(const Str, Key: string): string;
implementation
uses Base64, Sha;
{$R-}{$Q-}
{$I des.inc}

var
  IV, Chain, Temp: Pbytearray; { Storage for the chaining information     }
  BS: longint; { The block size in bytes for internal use }


procedure hperm_op(var a, t: dword; n, m: dword);
begin
  t := ((a shl (16 - n)) xor a) and m;
  a := a xor t xor (t shr (16 - n));
end;

procedure perm_op(var a, b, t: dword; n, m: dword);
begin
  t := ((a shr n) xor b) and m;
  b := b xor t;
  a := a xor (t shl n);
end;

procedure DoInit(KeyB: PByteArray; KeyData: PDWordArray);
var
  c, d, t, s, t2, i: dword;
begin
  c := KeyB^[0] or (KeyB^[1] shl 8) or (KeyB^[2] shl 16) or (KeyB^[3] shl 24);
  d := KeyB^[4] or (KeyB^[5] shl 8) or (KeyB^[6] shl 16) or (KeyB^[7] shl 24);
  perm_op(d, c, t, 4, $0F0F0F0F);
  hperm_op(c, t, dword(-2), $CCCC0000);
  hperm_op(d, t, dword(-2), $CCCC0000);
  perm_op(d, c, t, 1, $55555555);
  perm_op(c, d, t, 8, $00FF00FF);
  perm_op(d, c, t, 1, $55555555);
  d := ((d and $FF) shl 16) or (d and $FF00) or ((d and $FF0000) shr 16) or
    ((c and $F0000000) shr 4);
  c := c and $FFFFFFF;
  for i := 0 to 15 do
  begin
    if shifts2[i] <> 0 then
    begin
      c := ((c shr 2) or (c shl 26));
      d := ((d shr 2) or (d shl 26));
    end
    else
    begin
      c := ((c shr 1) or (c shl 27));
      d := ((d shr 1) or (d shl 27));
    end;
    c := c and $FFFFFFF;
    d := d and $FFFFFFF;
    s := des_skb[0, c and $3F] or
      des_skb[1, ((c shr 6) and $03) or ((c shr 7) and $3C)] or
      des_skb[2, ((c shr 13) and $0F) or ((c shr 14) and $30)] or
      des_skb[3, ((c shr 20) and $01) or ((c shr 21) and $06) or ((c shr 22) and $38)];
    t := des_skb[4, d and $3F] or
      des_skb[5, ((d shr 7) and $03) or ((d shr 8) and $3C)] or
      des_skb[6, (d shr 15) and $3F] or
      des_skb[7, ((d shr 21) and $0F) or ((d shr 22) and $30)];
    t2 := ((t shl 16) or (s and $FFFF));
    KeyData^[(i shl 1)] := ((t2 shl 2) or (t2 shr 30));
    t2 := ((s shr 16) or (t and $FFFF0000));
    KeyData^[(i shl 1) + 1] := ((t2 shl 6) or (t2 shr 26));
  end;
end;

procedure EncryptBlock(const InData; var OutData; KeyData: PDWordArray);
var
  l, r, t, u: dword;
  i: longint;
begin
  r := PDword(@InData)^;
  l := PDword(dword(@InData) + 4)^;
  t := ((l shr 4) xor r) and $0F0F0F0F;
  r := r xor t;
  l := l xor (t shl 4);
  t := ((r shr 16) xor l) and $0000FFFF;
  l := l xor t;
  r := r xor (t shl 16);
  t := ((l shr 2) xor r) and $33333333;
  r := r xor t;
  l := l xor (t shl 2);
  t := ((r shr 8) xor l) and $00FF00FF;
  l := l xor t;
  r := r xor (t shl 8);
  t := ((l shr 1) xor r) and $55555555;
  r := r xor t;
  l := l xor (t shl 1);
  r := (r shr 29) or (r shl 3);
  l := (l shr 29) or (l shl 3);
  i := 0;
  while i < 32 do
  begin
    u := r xor KeyData^[i];
    t := r xor KeyData^[i + 1];
    t := (t shr 4) or (t shl 28);
    l := l xor des_SPtrans[0, (u shr 2) and $3F] xor
      des_SPtrans[2, (u shr 10) and $3F] xor
      des_SPtrans[4, (u shr 18) and $3F] xor
      des_SPtrans[6, (u shr 26) and $3F] xor
      des_SPtrans[1, (t shr 2) and $3F] xor
      des_SPtrans[3, (t shr 10) and $3F] xor
      des_SPtrans[5, (t shr 18) and $3F] xor
      des_SPtrans[7, (t shr 26) and $3F];
    u := l xor KeyData^[i + 2];
    t := l xor KeyData^[i + 3];
    t := (t shr 4) or (t shl 28);
    r := r xor des_SPtrans[0, (u shr 2) and $3F] xor
      des_SPtrans[2, (u shr 10) and $3F] xor
      des_SPtrans[4, (u shr 18) and $3F] xor
      des_SPtrans[6, (u shr 26) and $3F] xor
      des_SPtrans[1, (t shr 2) and $3F] xor
      des_SPtrans[3, (t shr 10) and $3F] xor
      des_SPtrans[5, (t shr 18) and $3F] xor
      des_SPtrans[7, (t shr 26) and $3F];
    u := r xor KeyData^[i + 4];
    t := r xor KeyData^[i + 5];
    t := (t shr 4) or (t shl 28);
    l := l xor des_SPtrans[0, (u shr 2) and $3F] xor
      des_SPtrans[2, (u shr 10) and $3F] xor
      des_SPtrans[4, (u shr 18) and $3F] xor
      des_SPtrans[6, (u shr 26) and $3F] xor
      des_SPtrans[1, (t shr 2) and $3F] xor
      des_SPtrans[3, (t shr 10) and $3F] xor
      des_SPtrans[5, (t shr 18) and $3F] xor
      des_SPtrans[7, (t shr 26) and $3F];
    u := l xor KeyData^[i + 6];
    t := l xor KeyData^[i + 7];
    t := (t shr 4) or (t shl 28);
    r := r xor des_SPtrans[0, (u shr 2) and $3F] xor
      des_SPtrans[2, (u shr 10) and $3F] xor
      des_SPtrans[4, (u shr 18) and $3F] xor
      des_SPtrans[6, (u shr 26) and $3F] xor
      des_SPtrans[1, (t shr 2) and $3F] xor
      des_SPtrans[3, (t shr 10) and $3F] xor
      des_SPtrans[5, (t shr 18) and $3F] xor
      des_SPtrans[7, (t shr 26) and $3F];
    Inc(i, 8);
  end;
  r := (r shr 3) or (r shl 29);
  l := (l shr 3) or (l shl 29);
  t := ((r shr 1) xor l) and $55555555;
  l := l xor t;
  r := r xor (t shl 1);
  t := ((l shr 8) xor r) and $00FF00FF;
  r := r xor t;
  l := l xor (t shl 8);
  t := ((r shr 2) xor l) and $33333333;
  l := l xor t;
  r := r xor (t shl 2);
  t := ((l shr 16) xor r) and $0000FFFF;
  r := r xor t;
  l := l xor (t shl 16);
  t := ((r shr 4) xor l) and $0F0F0F0F;
  l := l xor t;
  r := r xor (t shl 4);
  PDword(@OutData)^ := l;
  PDword(dword(@OutData) + 4)^ := r;
end;

procedure DecryptBlock(const InData; var OutData; KeyData: PDWordArray);
var
  l, r, t, u: dword;
  i: longint;
begin
  r := PDword(@InData)^;
  l := PDword(dword(@InData) + 4)^;
  t := ((l shr 4) xor r) and $0F0F0F0F;
  r := r xor t;
  l := l xor (t shl 4);
  t := ((r shr 16) xor l) and $0000FFFF;
  l := l xor t;
  r := r xor (t shl 16);
  t := ((l shr 2) xor r) and $33333333;
  r := r xor t;
  l := l xor (t shl 2);
  t := ((r shr 8) xor l) and $00FF00FF;
  l := l xor t;
  r := r xor (t shl 8);
  t := ((l shr 1) xor r) and $55555555;
  r := r xor t;
  l := l xor (t shl 1);
  r := (r shr 29) or (r shl 3);
  l := (l shr 29) or (l shl 3);
  i := 30;
  while i > 0 do
  begin
    u := r xor KeyData^[i];
    t := r xor KeyData^[i + 1];
    t := (t shr 4) or (t shl 28);
    l := l xor des_SPtrans[0, (u shr 2) and $3F] xor
      des_SPtrans[2, (u shr 10) and $3F] xor
      des_SPtrans[4, (u shr 18) and $3F] xor
      des_SPtrans[6, (u shr 26) and $3F] xor
      des_SPtrans[1, (t shr 2) and $3F] xor
      des_SPtrans[3, (t shr 10) and $3F] xor
      des_SPtrans[5, (t shr 18) and $3F] xor
      des_SPtrans[7, (t shr 26) and $3F];
    u := l xor KeyData^[i - 2];
    t := l xor KeyData^[i - 1];
    t := (t shr 4) or (t shl 28);
    r := r xor des_SPtrans[0, (u shr 2) and $3F] xor
      des_SPtrans[2, (u shr 10) and $3F] xor
      des_SPtrans[4, (u shr 18) and $3F] xor
      des_SPtrans[6, (u shr 26) and $3F] xor
      des_SPtrans[1, (t shr 2) and $3F] xor
      des_SPtrans[3, (t shr 10) and $3F] xor
      des_SPtrans[5, (t shr 18) and $3F] xor
      des_SPtrans[7, (t shr 26) and $3F];
    u := r xor KeyData^[i - 4];
    t := r xor KeyData^[i - 3];
    t := (t shr 4) or (t shl 28);
    l := l xor des_SPtrans[0, (u shr 2) and $3F] xor
      des_SPtrans[2, (u shr 10) and $3F] xor
      des_SPtrans[4, (u shr 18) and $3F] xor
      des_SPtrans[6, (u shr 26) and $3F] xor
      des_SPtrans[1, (t shr 2) and $3F] xor
      des_SPtrans[3, (t shr 10) and $3F] xor
      des_SPtrans[5, (t shr 18) and $3F] xor
      des_SPtrans[7, (t shr 26) and $3F];
    u := l xor KeyData^[i - 6];
    t := l xor KeyData^[i - 5];
    t := (t shr 4) or (t shl 28);
    r := r xor des_SPtrans[0, (u shr 2) and $3F] xor
      des_SPtrans[2, (u shr 10) and $3F] xor
      des_SPtrans[4, (u shr 18) and $3F] xor
      des_SPtrans[6, (u shr 26) and $3F] xor
      des_SPtrans[1, (t shr 2) and $3F] xor
      des_SPtrans[3, (t shr 10) and $3F] xor
      des_SPtrans[5, (t shr 18) and $3F] xor
      des_SPtrans[7, (t shr 26) and $3F];
    Dec(i, 8);
  end;
  r := (r shr 3) or (r shl 29);
  l := (l shr 3) or (l shl 29);
  t := ((r shr 1) xor l) and $55555555;
  l := l xor t;
  r := r xor (t shl 1);
  t := ((l shr 8) xor r) and $00FF00FF;
  r := r xor t;
  l := l xor (t shl 8);
  t := ((r shr 2) xor l) and $33333333;
  l := l xor t;
  r := r xor (t shl 2);
  t := ((l shr 16) xor r) and $0000FFFF;
  r := r xor t;
  l := l xor (t shl 16);
  t := ((r shr 4) xor l) and $0F0F0F0F;
  l := l xor t;
  r := r xor (t shl 4);
  PDword(@OutData)^ := l;
  PDword(dword(@OutData) + 4)^ := r;
end;

procedure Encrypt(const Indata; var Outdata; const Key: string);
var
  //Size: longint;
  KeyB: array[0..7] of byte;
  Digest: array[0..19] of byte;
  KeyData: array[0..31] of dword;
begin
  //Size := 64;
  FillChar(KeyData, Sizeof(KeyData), 0);
  FillChar(KeyB, Sizeof(KeyB), 0);
  ShaFinal(Key, Digest);

  Move(Digest, KeyB, 8);
  DoInit(@KeyB, @KeyData);
  EncryptBlock(InData, OutData, @KeyData);
end;

procedure Decrypt(const Indata; var Outdata; const Key: string);
var
  //Size: longint;
  KeyB: array[0..7] of byte;
  Digest: array[0..19] of byte;
  KeyData: array[0..31] of dword;
begin
  //Size := 64;
  FillChar(KeyData, Sizeof(KeyData), 0);
  FillChar(KeyB, Sizeof(KeyB), 0);
  ShaFinal(Key, Digest);

  Move(Digest, KeyB, 8);
  DoInit(@KeyB, @KeyData);

  DecryptBlock(InData, OutData, @KeyData);
end;

function EncryptString(const Str, Key: string): string;
begin
  SetLength(Result, Length(Str));
  Encrypt(Str[1], Result[1], Key);
  Result := Base64EncodeStr(Result);
end;

function DecryptString(const Str, Key: string): string;
begin
  Result := Base64DecodeStr(Str);
  Decrypt(Result[1], Result[1], Key);
end;

end.

