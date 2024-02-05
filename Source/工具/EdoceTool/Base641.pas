unit Base64;

interface

uses SysUtils, Classes;

//---------------------------------------------------------------------------
function EncodeBase64(Source, Dest: Pointer; Size: Integer): Integer;
function DecodeBase64(Source, Dest: Pointer; Size: Integer): Integer;
function Base64EncodeStr(Source: string): string;
function Base64DecodeStr(Source: string): string;

implementation

const
  Base64_Chars: array[0..63] of Char = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  Base64_Bytes: array[0..79] of Byte = (
    62, 0, 0, 0, 63, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,
    0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7,
    8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
    23, 24, 25, 0, 0, 0, 0, 0, 0, 26, 27, 28, 29, 30, 31,
    32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46,
    47, 48, 49, 50, 51
    );

function EncodeBase64(Source, Dest: Pointer; Size: Integer): Integer;
asm
  push  ebp
  push  esi
  push  edi
  push  ebx
  mov   esi, eax         // esi = Source
  mov   edi, edx         // edi = Buf
  mov   eax, ecx
  cdq
  mov   ecx, 3
  div   ecx
  mov   ecx, eax
  test  edx, edx         // edx = SourceSize % 3
  jz    @@1
  inc   eax              // eax = (SourceSize + 2) / 3
@@1:
  push  eax
  push  edx
  lea   ebp, Base64_Chars// ebp = Base64_Chars
  jecxz @@3
  cld                    // for (ecx = SourceSize / 3; ecx > 0; ecx --)
@Loop1:                  // {
  mov   edx, [esi]       //   edx = *(DWORD* )esi
  add   esi, 3           //   esi += 3
  bswap edx              //   bswap(edx)
  shr   edx, 8           //   edx >>= 8
  mov   ebx, edi         //   ebx = edi
  add   edi, 4           //   edi += 4
@Loop3:                  //   while (ebx != edi)
  dec   edi              //   {
  mov   eax, edx         //     *--edi = (BYTE)Base64_Chars[edx & 63]
  and   eax, 63
  movzx eax, byte ptr [ebp + eax]
  mov   [edi], al
  shr   edx, 6           //     edx >= 6
  cmp   ebx, edi
  jne   @Loop3           //   }
  add   edi, 4           //   edi += 4
  loop  @Loop1           // }
@@3:
  pop   ecx              // if (SourceSize % 3 == 0)
  jecxz @end             //   return
  push  ecx
  mov   eax, ecx
  mov   ebx, 0ffffffffh  // ebx = ~(-1 >> ((SourceSize % 3) * 8))
  shl   ecx, 3
  shl   ebx, cl
  not   ebx
  mov   edx, [esi]       // edx = *(DWORD* )esi & ebx
  and   edx, ebx
  bswap edx              // bswap(edx)
  mov   ecx, eax
  inc   ecx
@Loop4:                  // for (ecx = SourceSize % 3 + 1; ecx > 0; ecx --)
  rol   edx, 6           // {
  mov   eax, edx         //   edx <<<= 6
  and   eax, 63          //   *edi ++ = Base64_Chars[edx & 63]
  movzx eax, [ebp + eax]
  stosb
  loop  @Loop4           // }
  pop   ecx              // for (ecx = 3 - (SourceSize % 3); ecx > 0; ecx --)
  xor   ecx, 3
  mov   al, 61
  rep   stosb            //   *edi++ = '='
@end:
  pop   eax
  shl   eax, 2           // return (SourceSize + 2) / 3 * 4
  pop   ebx
  pop   edi
  pop   esi
  pop   ebp
end;
//---------------------------------------------------------------------------

function Base64DecodeBufSize(const Source; Size: Integer): Integer;
asm
  push  edi
  mov   edi, eax    // edi = Source + Size - 1
  add   edi, edx
  mov   eax, edx    // eax = Size / 4 * 3
  shr   edx, 2
  shr   eax, 1
  add   eax, edx
  mov   edx, eax
  jz    @@2
@@1:
  dec   edi
  cmp   byte ptr [edi], 61
  jne   @@2         // if ([edi] == '=')
  dec   eax         //   eax --
  jmp   @@1
@@2:
  pop   edi         // return eax: BufSize; edx: SourceSize / 4 * 3
end;

function DecodeBase64(Source, Dest: Pointer; Size: Integer): Integer;
asm
  push  ebp
  push  esi
  push  edi
  push  ebx
  mov   esi, eax       // esi = Source
  mov   edi, edx       // edi = Buf
  mov   edx, ecx
  call  Base64DecodeBufSize
  push  eax            // eax = Base64DecodeBufSize(Source, SourceSize)  // return value
  add   eax, edi       // eax += edi
  lea   ebp, Base64_Bytes
  cld
  shr   ecx, 2
  jecxz @end
  push  eax
  mov   ebx, ecx       // for (ebx = SourceSize / 4; ebx > 0; ebx --; edi += 3)
@Loop1:                // {
  mov   ecx, 4
  xor   eax, eax       //   for (ecx = 4, eax = 0; ecx > 0; ecx --)
@Loop2:                //   {
  movzx edx, byte ptr [esi]
  inc   esi            //      edx = *esi ++
  sub   edx, 43        //      dl -= 43
  shl   eax, 6         //      eax <<= 6
  or    al, [ebp + edx]//      al |= Base64_Bytes[edx]
  loop  @Loop2         //   }
  cmp   ebx, 1         //   if (ebx == 1) break
  jz    @@2
  bswap eax            //   bswap(eax)
  shr   eax, 8         //   eax >>= 8
  mov   [edi], ax      //   *edi = ax
  shr   eax, 16        //   eax >>= 16
  mov   [edi + 2], al  //   *(edi + 2) = al
  add   edi, 3         //
  dec   ebx
  jnz   @Loop1         // }
@@2:
  pop   ecx            // for (ecx = Buf + BufSize, eax <<= 8; edi != ecx;)
  shl   eax, 8         // {
@Loop4:
  cmp   edi, ecx
  je    @end
  rol   eax, 8         //   eax <<<= 8
  stosb                //   *edi ++ = al
  jmp   @Loop4         // }
@end:
  pop   eax            // return eax
  pop   ebx
  pop   edi
  pop   esi
  pop   ebp
end;
//---------------------------------------------------------------------------

function Base64EncodeStr(Source: string): string;
begin
  SetLength(Result, ((Length(Source) + 2) div 3) * 4);
  EncodeBase64(@Source[1], @Result[1], Length(Source));
end;

//---------------------------------------------------------------------------

function Base64DecodeStr(Source: string): string;
begin
  SetLength(Result, (Length(Source) div 4) * 3);
  SetLength(Result, DecodeBase64(@Source[1], @Result[1], Length(Source)));
end;
//---------------------------------------------------------------------------

end.

