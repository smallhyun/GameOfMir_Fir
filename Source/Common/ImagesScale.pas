unit ImagesScale;

interface
type
  // 插值方式: 缺省(线性插值)，临近，线性，双立方
  TInterpolateMode = (imDefault, imNear, imBilinear, imBicubic);
  TInterpolateProc = procedure;

  TImageData = packed record
    Width: LongWord; // 图像宽度
    Height: LongWord; // 图像高度
    Stride: LongWord; // 图像扫描线字节长度
    Scan0: Pointer; // 图像数据地址
  end;
  // 缩放图像，Alpha不透明度，IpMode插值方式
procedure ImageScale(var Dest: TImageData; const Source: TImageData;
  Alpha: Single = 1.0; IpMode: TInterpolateMode = imDefault); //overload;
  // Source分别按比例ScaleX和ScaleY缩放到Dest的(x,y)坐标，其它参数同上
{procedure ImageScale(var Dest: TImageData; x, y: Integer;
  const Source: TImageData; ScaleX, ScaleY: Single;
  Alpha: Single = 1.0; IpMode: TInterpolateMode = imDefault); overload;
  // TGraphic对象缩放到Dest
{procedure ImageScale(var Dest: TImageData; const Source: TGraphic;
  Alpha: Single = 1.0; IpMode: TInterpolateMode = imDefault); overload;
{procedure ImageScale(var Dest: TImageData; x, y: Integer;
  const Source: TGraphic; ScaleX, ScaleY: Single;
  Alpha: Single = 1.0; IpMode: TInterpolateMode = imDefault); overload;
procedure ImageScale(var Dest: TImageData; const Source: TGpBitmap;
  Alpha: Single = 1.0; IpMode: TInterpolateMode = imDefault); overload;
procedure ImageScale(var Dest: TImageData; x, y: Integer;
  const Source: TGpBitmap; ScaleX, ScaleY: Single;
  Alpha: Single = 1.0; IpMode: TInterpolateMode = imDefault); overload; }


// 浮点数版，Source四周的边界分别扩展了3
implementation
var
  BicubicTable: Pointer;
  BicubicSlope: Single;
  BilinearTable: Pointer;

(*****************************************************************************
* typedef UINT ARGB                                                          *
* ARGB GetBilinearColor(int x(*256), int y(*256), void* Scan0, UINT Stride)  *
*                                                                            *
* int x0 = x / 256                                                           *
* int y0 = y / 256                                                           *
* BYTE *pScan0 = Scan0 + y0 * Stride + y0 * 4                                *
* BYTE c[4][4]                                                               *
* c[0] = *pScan0                 // (x0, y0)                                 *
* c[1] = *(pScan0 + Stride)      // (x0, y0+1)                               *
* c[2] = *(pScan0 + 4)           // (x0+1, y0)                               *
* c[3] = *(PScan0 + Stride + 4)  // (x0+1, y0+1)                             *
* int u = x & 0xff                                                           *
* int v = y & 0xff                                                           *
* int m0 = (255-v) * (255-u)                                                 *
* int m1 = v * (255-u)                                                       *
* int m2 = (255-v) * u                                                       *
* int m3 = v * u                                                             *
* BYTE ARGB[4]                                                               *
* for (int i = 0; i < 4; i ++)                                               *
*   ARGB[i] = (c[0][i]*m0 + c[1][i]*m1 + c[2][i]*m2 + c[3][i]*m3) / 65536    *
 *****************************************************************************)

procedure GetBilinearColor;
asm
    and       edx, 255
    and       ecx, 255
    mov       eax, BilinearTable
    movq      mm0, [esi]       // mm0 = C2(x+1, y)  C0(x, y)
    movq      mm1, mm0
    add       esi, [ebx].TImageData.Stride
                               // [esi] = C3(x+1, y+1) C1(x, y+1)
    punpcklbw mm0, [esi]       // mm0 = A1 A0 R1 R0 G1 G0 B1 B0
    punpckhbw mm1, [esi]       // mm1 = A3 A2 R3 R2 G3 G2 B3 B2
    movq      mm2, mm0
    movq      mm3, mm1
    punpcklbw mm0, mm7         // mm0 = 00 G1 00 G0 00 B1 00 B0
    punpcklbw mm1, mm7         // mm1 = 00 G3 00 G2 00 B3 00 B2
    punpckhbw mm2, mm7         // mm2 = 00 A1 00 A0 00 R1 00 R0
    punpckhbw mm3, mm7         // mm3 = 00 A3 00 A2 00 R3 00 R2
    movq      mm4, [eax+edx*8]
    pmullw    mm4, [eax+ecx*8+256*8]
    psrlw     mm4, 1           // 先除以2，否则后面的word有符号乘法会扩展符号位
    movq      mm5, mm4
    punpckldq mm4, mm4         // mm4 = 00 m1 00 m0 00 m1 00 m0
    punpckhdq mm5, mm5         // mm5 = 00 m3 00 m2 00 m3 00 m2
    pmaddwd   mm0, mm4         // mm0 = G1*m1+G0*m0 B1*m1+B0*m0
    pmaddwd   mm1, mm5         // mm1 = G3*m3+G2*m2 B3*m3+B2*m2
    pmaddwd   mm2, mm4         // mm2 = A1*m1+A0*m0 R1*m1+R0*m0
    pmaddwd   mm3, mm5         // mm3 = A3*m3+A2*m2 R3*m3+R2*m2
    paddd     mm0, mm1         // mm0 = G3n+G2n+G1n+G0n B3n+B2n+B1n+B0n
    paddd     mm2, mm3         // mm2 = A2n+A2n+A1n+A0n R3n+R2n+R1n+R0n
    psrld     mm0, 15          // mm0 = Gn/0x8000    Bn/0x8000
    psrld     mm2, 15          // mm2 = An/0x8000    Rn/0x8000
    packssdw  mm0, mm2         // mm0 = 00 An 00 Rn 00 Gn 00 Bn
    packuswb  mm0, mm0         // mm0 = An Rn Gn Bn An Rn Gn Bn
end;

procedure GetNearColor;
asm
    movd      mm0, [esi]
end;

procedure GetBicubicColor;

  procedure SumBicubic;
  asm
    movd      mm1, [esi]
    movd      mm2, [esi+4]
    movd      mm3, [esi+8]
    movd      mm4, [esi+12]
    punpcklbw mm1, mm7
    punpcklbw mm2, mm7
    punpcklbw mm3, mm7
    punpcklbw mm4, mm7
    psllw     mm1, 7
    psllw     mm2, 7
    psllw     mm3, 7
    psllw     mm4, 7
    pmulhw    mm1, [edi+edx+256*8]
    pmulhw    mm2, [edi+edx]
    pmulhw    mm3, [edi+eax+256*8]
    pmulhw    mm4, [edi+eax+512*8]
    paddsw    mm1, mm2
    paddsw    mm3, mm4
    paddsw    mm1, mm3
    pmulhw    mm1, mm5
    paddsw    mm0, mm1
    add       esi, [ebx].TImageData.Stride
  end;

asm
    push      edi
    mov       edi, BicubicTable// edi = int64 uvTable  (item * 16384)
    and       edx, 255         // u = x & 255
    shl       edx, 3           // edx = u * 8
    mov       eax, edx         // eax = -edx
    neg       eax
    and       ecx, 255         // v = y & 255
    shl       ecx, 3           // ecx = v * 8
    pxor      mm0, mm0
    movq      mm5, [edi+ecx+256*8]
    call      SumBicubic
    movq      mm5, [edi+ecx]
    call      SumBicubic
    neg       ecx
    movq      mm5, [edi+ecx+256*8]
    call      SumBicubic
    movq      mm5, [edi+ecx+512*8]
    call      SumBicubic
    paddw     mm0, mm6         // argb += 4
    psraw     mm0, 3           // argb /= 8
    packuswb  mm0, mm0
    pop   edi
end;

function GetInterpolateProc(IpMode: TInterpolateMode; var Proc: TInterpolateProc): Integer;
begin
  case IpMode of
    imNear:
      begin
        Result := 1;
        Proc := GetNearColor;
      end;
    imBicubic:
      begin
        Result := 4;
        Proc := GetBicubicColor;
      end
  else
    begin
      Result := 2;
      Proc := GetBilinearColor;
    end;
  end;
end;

procedure doScale(var Dest: TImageData; const Source: TImageData;
  Alpha: Single; IpMode: TInterpolateMode);
var
  x, y, Width, Height: Integer;
  xDelta, yDelta: Integer;
  Radius, dstOffset: Integer;
  alphaI: Integer;
  src: TImageData;
  colorProc: TInterpolateProc;
asm
    push        esi
    push        edi
    push        ebx
    mov         alphaI, 256
    fild        dword ptr alphaI
    fmul        dword ptr Alpha
    fistp       dword ptr alphaI// alphaI = alpha * 256.0
    fwait
    mov         edi, eax        // edi = deat
    mov         ebx, edx        // ebx = source
    mov         eax, ecx
    lea         edx, colorProc
    call        GetInterpolateProc
    mov         esi, eax
    lea         ecx, src        // src = GetExpandData(source, radius, 0xffffffff)
    push        ecx
    mov         ecx, -1
    mov         edx, eax
    mov         eax, ebx
    call        GetExpandData
    shl         esi, 7          // esi = radius * 128
    mov         eax, [ebx].TImageData.Width
    shl         eax, 8
    xor         edx, edx
    idiv        [edi].TImageData.Width
    mov         xDelta, eax     // xDelta = source.Width * 256 / dest.Width
    mov         edx, eax
    add         eax, esi
    mov         x, eax          // x = xDelta + Radius * 128
    imul        edx, [edi].TImageData.Width
    add         eax, edx
    mov         Width, eax      // width = xDelta * dest.Width + x
    mov         eax, [ebx].TImageData.Height
    shl         eax, 8
    xor         edx, edx
    idiv        [edi].TImageData.Height
    mov         yDelta, eax     // yDelta = source.Height * 256 / dest.Height
    add         esi, eax
    mov         y, esi          // y = yDelta + Radius * 128
    imul        eax, [edi].TImageData.Height
    add         eax, esi
    mov         Height, eax     // height = yDelta * dest.Height + y
    pxor        mm7, mm7
    mov         ecx, 04040404h
    movd        mm6, ecx
    punpcklbw   mm6, mm7
    mov         eax, edi
    lea         edx, src
    push        edx
    call        SetScaleRegs32
    mov         dstOffset, ebx
    pop         ebx             // ebx = src
    mov         ecx, y
    cmp         alphaI, 256
    jae         @@yLoopB        // if (alpha >= 256) alphaScale else alphaBlendScale

@@yLoopA:                       // for (; y < Height;  y ++){
    mov         esi, ecx        // {
    sar         esi, 8          //   esi = source.Scan0 + y / 256 * source.Stride
    imul        esi, [ebx].TImageData.Stride
    add         esi, [ebx].TImageData.Scan0
    mov           edx, x          //   for (; x < Width; x ++){
@@xLoopA:                       //   {
    push        esi
    push        edx
    push        ecx
    mov         eax, edx
    sar         eax, 8
    shl         eax, 2
    add         esi, eax        //     esi += (x / 256 * 4)
    call        colorProc       //     mm0 = GetColor(src, esi, x, y)
    movd        eax, mm0        //     eax = ((mm0 >> 24) * alpha) >> 8
    shr         eax, 24
    imul        eax, alphaI
    shr         eax, 8
    movd        mm1, [edi]      //     mm1 = *(ARGB*)edi
    punpcklbw   mm0, mm7
    punpcklbw   mm1, mm7
    psubw       mm0, mm1
    pmullw      mm0, qword ptr ArgbTable[eax*8]
    psllw       mm1, 8
    paddw       mm0, mm1
    psrlw       mm0, 8
    packuswb    mm0, mm7        //     *(ARGB*)edi = ((mm0 - mm1) * ArgbTable[eax] +
    movd        [edi], mm0      //       mm1 * 256) / 256
    add         edi, 4          //     edi += 4
    pop         ecx
    pop         edx
    pop         esi
    add         edx, xDelta       //     x0 += xDelta
    cmp         edx, Width
    jl          @@xLoopA        //   }
    add         edi, dstOffset  //   edi += dstOffset
    add         ecx, yDelta       //   y0 += yDelta
    cmp         ecx, Height
    jl          @@yLoopA        // }
    jmp         @@Exit

@@yLoopB:                       // for (; y < Height;  y ++){
    mov         esi, ecx        // {
    sar         esi, 8          //   esi = source.Scan0 + y / 256 * source.Stride
    imul        esi, [ebx].TImageData.Stride
    add         esi, [ebx].TImageData.Scan0
    mov         edx, x          //   for (; x < Width; x ++){
@@xLoopB:                       //   {
    push        esi
    push        edx
    push        ecx
    mov         eax, edx
    sar         eax, 8
    shl         eax, 2
    add         esi, eax        //     esi += (x / 256 * 4)
    call        colorProc       //     mm0 = colorProc(src, esi, x, y)
    movd        eax, mm0        //     eax = mm0 >> 24
    shr         eax, 24
    movd        mm1, [edi]      //     mm1 = *(ARGB*)edi
    punpcklbw   mm0, mm7
    punpcklbw   mm1, mm7
    psubw       mm0, mm1
    pmullw      mm0, qword ptr ArgbTable[eax*8]
    psllw       mm1, 8
    paddw       mm0, mm1
    psrlw       mm0, 8
    packuswb    mm0, mm7        //     *(ARGB*)edi = ((mm0 - mm1) * ArgbTable[eax] +
    movd        [edi], mm0      //       mm1 * 256) / 256
    add         edi, 4          //     edi += 4
    pop         ecx
    pop         edx
    pop         esi
    add         edx, xDelta       //     x0 += xDelta
    cmp         edx, Width
    jl          @@xLoopB        //   }
    add         edi, dstOffset  //   edi += dstOffset
    add         ecx, yDelta       //   y0 += yDelta
    cmp         ecx, Height
    jl          @@yLoopB        // }

@@Exit:
    emms
    mov         eax, ebx
    call        FreeImageData
    pop         ebx
    pop         edi
    pop         esi
end;

procedure ImageScale(var Dest: TImageData; const Source: TImageData;
  Alpha: Single; IpMode: TInterpolateMode);
begin
  if ImageEmpty(Dest) or ImageEmpty(Source) then Exit;
  DoScale(Dest, Source, Alpha, IpMode);
end;
{
procedure ImageScale(var Dest: TImageData; x, y: Integer;
  const Source: TImageData; ScaleX, ScaleY: Single;
  Alpha: Single; IpMode: TInterpolateMode);
var
  src, dst: TImageData;
begin
  if ImageEmpty(Source) then Exit;
  dst := GetSubImageData(Dest, x, y, Round(Source.Width * ScaleX),
    Round(Source.Height * ScaleY));
  if dst.Scan0 = nil then Exit;
  if x < 0 then x := -Round(x / ScaleX) else x := 0;
  if y < 0 then y := -Round(y / ScaleY) else y := 0;
  src := GetSubData(Source, x, y, GetInfinity(dst.Width / ScaleX),
    GetInfinity(dst.Height / ScaleY));
  DoScale(dst, src, Alpha, IpMode);
end;

procedure ImageScale(var Dest: TImageData; const Source: TGraphic;
  Alpha: Single; IpMode: TInterpolateMode);
var
  src: TImageData;
begin
  src := GetImageData(Source);
  DoScale(Dest, src, Alpha, IpMode);
  FreeImageData(src);
end;

procedure ImageScale(var Dest: TImageData; x, y: Integer;
  const Source: TGraphic; ScaleX, ScaleY: Single;
  Alpha: Single; IpMode: TInterpolateMode);
var
  src: TImageData;
begin
  src := GetImageData(Source);
  ImageScale(Dest, x, y, src, ScaleX, ScaleY, Alpha, IpMode);
  FreeImageData(src);
end;

procedure ImageScale(var Dest: TImageData; const Source: TGpBitmap;
  Alpha: Single; IpMode: TInterpolateMode);
var
  src: TImageData;
begin
  src := GetImageData(Source);
  ImageScale(Dest, src, Alpha, IpMode);
  FreeImageData(src);
end;

procedure ImageScale(var Dest: TImageData; x, y: Integer; const Source: TGpBitmap;
  ScaleX, ScaleY: Single; Alpha: Single; IpMode: TInterpolateMode);
var
  src: TImageData;
begin
  src := GetImageData(Source);
  ImageScale(Dest, x, y, src, ScaleX, ScaleY, Alpha, IpMode);
  FreeImageData(src);
end; }


// 浮点数版，Source四周的边界分别扩展了3

procedure BicubicScale(Source, Dest: TImageData);
const A = -0.75; // 0.0 < BicuBicSlope <= 2.0

  function BicubicFunc(x: double): double;
  var
    x2, x3: double;
  begin
    if x < 0 then x := -x;
    x2 := x * x;
    x3 := x2 * x;
    if x <= 1 then
      Result := (A + 2) * x3 - (A + 3) * x2 + 1
    else if x <= 2 then
      Result := A * x3 - (5 * A) * x2 + (8 * A) * x - (4 * A)
    else Result := 0;
  end;

  function Bicubic(fx, fy: double): TRGBQuad;
  var
    x, y, x0, y0: Integer;
    fu, fv: double;
    pixel: array[0..3, 0..3] of PRGBQuad;
    afu, afv, aARGB, sARGB: array[0..3] of double;
    i, j: Integer;
  begin
    x0 := Trunc(floor(fx));
    y0 := Trunc(floor(fy));
    fu := fx - x0;
    fv := fy - y0;
    for i := 0 to 3 do
    begin
      for j := 0 to 3 do
      begin
        x := x0 - 1 + j;
        y := y0 - 1 + i;
        pixel[i, j] := PRGBQuad(LongWord(Source.Scan0) + y * Source.Stride + x shl 2);
      end;
      sARGB[i] := 0;
    end;
    afu[0] := BicubicFunc(1 + fu);
    afu[1] := BicubicFunc(fu);
    afu[2] := BicubicFunc(1 - fu);
    afu[3] := BicubicFunc(2 - fu);
    afv[0] := BicubicFunc(1 + fv);
    afv[1] := BicubicFunc(fv);
    afv[2] := BicubicFunc(1 - fv);
    afv[3] := BicubicFunc(2 - fv);
    for i := 0 to 3 do
    begin
      for j := 0 to 3 do
        aARGB[j] := 0;
      for j := 0 to 3 do
      begin
        aARGB[3] := aARGB[3] + afu[j] * pixel[i, j]^.rgbReserved;
        aARGB[2] := aARGB[2] + afu[j] * pixel[i, j]^.rgbRed;
        aARGB[1] := aARGB[1] + afu[j] * pixel[i, j]^.rgbGreen;
        aARGB[0] := aARGB[0] + afu[j] * pixel[i, j]^.rgbBlue;
      end;
      sARGB[3] := sARGB[3] + aARGB[3] * afv[i];
      sARGB[2] := sARGB[2] + aARGB[2] * afv[i];
      sARGB[1] := sARGB[1] + aARGB[1] * afv[i];
      sARGB[0] := sARGB[0] + aARGB[0] * afv[i];
    end;
    Result.rgbBlue := Max(0, Min(255, Round(sARGB[0])));
    Result.rgbGreen := Max(0, Min(255, Round(sARGB[1])));
    Result.rgbRed := Max(0, Min(255, Round(sARGB[2])));
    Result.rgbReserved := Max(0, Min(255, Round(sARGB[3])));
  end;
var
  x, y: Integer;
  fx, fy: double;
  Offset: LongWord;
  p: PLongWord; //PRGBQuad;
begin
  Offset := Dest.Stride - Dest.Width shl 2;
  p := PLongWord(Dest.Scan0);
  for y := 0 to Dest.Height - 1 do
  begin
    fy := (y + 0.4999999) * Source.Height / Dest.Height - 0.5;
    for x := 0 to Dest.Width - 1 do
    begin
      fx := (x + 0.4999999) * Source.Width / Dest.Width - 0.5;
      P^ := LongWord(Bicubic(fx, fy));
      Inc(p);
    end;
    Inc(LongWord(p), Offset);
  end;
end;


const InterpolationRadius = 3;
var
  BicubicUVTable: array[0..512] of Integer;

procedure InitBicubicUVTable;
const A = -0.75;

  function BicubicFunc(x: double): double;
  var
    x2, x3: double;
  begin
    if x < 0 then x := -x;
    x2 := x * x;
    x3 := x2 * x;
    if x <= 1 then
      Result := (A + 2) * x3 - (A + 3) * x2 + 1
    else if x <= 2 then
      Result := A * x3 - (5 * A) * x2 + (8 * A) * x - (4 * A)
    else Result := 0;
  end;
var
  I: Integer;
begin
  for I := 0 to 512 do
    BicubicUVTable[I] := Round(256 * BicubicFunc(I * (1.0 / 256)));
end;

// 定点数版，Source四周的边界分别扩展了3

procedure BicubicScale(Source, Dest: TImageData);

  function Bicubic(x, y: Integer): TRGBQuad;
  var
    x0, y0, u, v: Integer;
    pixel: PRGBQuad;
    au, av, aARGB, sARGB: array[0..3] of Integer;
    i, j: Integer;
  begin
    u := x and 255;
    v := y and 255;
    pixel := PRGBQuad(LongWord(Source.Scan0) + (y div 256 - 1) * Source.Stride + ((x div 256 - 1) shl 2));
    for i := 0 to 3 do
      sARGB[i] := 0;
    au[0] := BicubicUVTable[256 + u];
    au[1] := BicubicUVTable[u];
    au[2] := BicubicUVTable[256 - u];
    au[3] := BicubicUVTable[512 - u];
    av[0] := BicubicUVTable[256 + v];
    av[1] := BicubicUVTable[v];
    av[2] := BicubicUVTable[256 - v];
    av[3] := BicubicUVTable[512 - v];
    for i := 0 to 3 do
    begin
      for j := 0 to 3 do
        aARGB[j] := 0;
      for j := 0 to 3 do
      begin
        aARGB[3] := aARGB[3] + au[j] * pixel^.rgbReserved;
        aARGB[2] := aARGB[2] + au[j] * pixel^.rgbRed;
        aARGB[1] := aARGB[1] + au[j] * pixel^.rgbGreen;
        aARGB[0] := aARGB[0] + au[j] * pixel^.rgbBlue;
        Inc(LongWord(pixel), 4);
      end;
      sARGB[3] := sARGB[3] + aARGB[3] * av[i];
      sARGB[2] := sARGB[2] + aARGB[2] * av[i];
      sARGB[1] := sARGB[1] + aARGB[1] * av[i];
      sARGB[0] := sARGB[0] + aARGB[0] * av[i];
      Inc(LongWord(pixel), Source.Stride - 16);
    end;
    Result.rgbBlue := Max(0, Min(255, sARGB[0] div 65536));
    Result.rgbGreen := Max(0, Min(255, sARGB[1] div 65536));
    Result.rgbRed := Max(0, Min(255, sARGB[2] div 65536));
    Result.rgbReserved := Max(0, Min(255, sARGB[3] div 65536));
  end;

var
  x, x0, y, xDelta, yDelta: Integer;
  w, h: Integer;
  Offset: LongWord;
  p: PLongWord;
begin
  InitBicubicUVTable;
  p := PLongWord(Dest.Scan0);
  Offset := Dest.Stride - Dest.Width shl 2;
  yDelta := ((Source.Height - InterpolationRadius * 2) * 256) div Dest.Height;
  xDelta := ((Source.Width - InterpolationRadius * 2) * 256) div Dest.Width;
  y := (yDelta shr 1) - $80 + $200;
  x0 := (xDelta shr 1) - $80 + $200;
  h := Dest.Height * yDelta + y;
  w := Dest.Width * xDelta + x0;
  while y < h do
  begin
    x := x0;
    while x < w do
    begin
      P^ := LongWord(Bicubic(x, y));
      Inc(x, xDelta);
      Inc(p);
    end;
    Inc(y, yDelta);
    Inc(LongWord(p), Offset);
  end;
end;

procedure InitBilinearTable;
begin
  BilinearTable := GlobalAllocPtr(GMEM_MOVEABLE, 256 * 2 * 8);
  asm
    push      esi
    mov       esi, BilinearTable
    xor       ecx, ecx
  @SumLoop:
    mov       edx, ecx
        and         edx, 255         // u(v) = x & 0xff
    mov       eax, 100h
    sub       eax, edx
    jnz       @@1
    dec       edx
    jmp       @@2
  @@1:
    test      edx, edx
    jnz       @@2
    dec       eax
  @@2:
    shl       edx, 16
    or        edx, eax         // edx = 00 u(v) 00 ff-u(v)
    movd      mm0, edx
    movd      mm1, edx
    punpcklwd mm0, mm0         // mm0 = 00  u 00  u 00 ff-u 00 ff-u
    punpckldq mm1, mm1         // mm1 = 00  v 00 ff-v 00  v 00 ff-v
    movq      [esi], mm0
    movq      [esi + 8], mm1
    add       esi, 16
    inc       ecx
    cmp       ecx, 256
    jl        @SumLoop
    emms
    pop       esi
  end;
end;

initialization
  begin
    InitBilinearTable;
    BicubicTable := GlobalAllocPtr(GMEM_MOVEABLE, (512 + 1) * 8);
    SetBicubicSlope(-0.75);
  end;
finalization
  begin
    GlobalFreePtr(BicubicTable);
    GlobalFreePtr(BilinearTable);
  end;

end.

