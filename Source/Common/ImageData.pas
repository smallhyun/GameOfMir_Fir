unit ImageData;

interface
uses
  Windows, SysUtils, Classes, Graphics;

const
  EIDErrorSourceMust = 'Source image data must be %d-bit pixel format.';
  EIDErrorDestMust = 'The target image data must be %d-bit pixel format.';
  EIDErrorColorTable = 'The lack of %d-bit image data corresponding color table.';
  EIDErrorOutOfMemory = 'Scan line image memory allocation failed.';
  EIDErrorNotSupport = 'Does not support the pixel format images.';
  EIDErrorEmptyData = 'Empty image data structure.';
  EIDErrorParam = 'Wrong image data structure or parameter.';

type
  EImageDataError = Exception;

  // 256色灰度统计数组，每个元素表示该下标对应的颜色个数
  TGrayArray = array[0..255] of LongWord;
  // 灰度统计结构
  TGrayStatData = packed record
    Grays: TGrayArray; // 灰度数组
    Total: int64; // 总的灰度值
    Count: LongWord; // 总的像素点数
    MaxGray: LongWord; // 像素点最多的灰度值
    MinGray: LongWord; // 像素点最少的灰度值
    Average: LongWord; // 平均灰度值(Total / Count)
  end;
  PGrayStatData = ^TGrayStatData;

  // 与GDI+ TBitmapData兼容的图像数据结构
  TImageData = packed record
    Width: Integer; // 像素宽度
    Height: Integer; // 像素高度
    Stride: Integer; // 扫描宽度
    PixelFormat: LongWord; // GDI+像素格式
    Scan0: Pointer; // 扫描行首地址
    case Integer of
      0: (LockMode: byte; // GDI+锁数据方式
        notuse: Byte;
        InvertLine: Boolean; // 是否倒置的扫描线
        AllocScan: Boolean); // 是否分配图像数据内存
      1: (Reserved: UINT); // 保留
  end;
  PImageData = ^TImageData;

  PARGBQuad = ^TARGBQuad;
  TARGBQuad = packed record
    Blue: Byte;
    Green: Byte;
    Red: Byte;
    Alpha: Byte;
  end;

  // 获取图像数据结构。InvertLine图像是否倒置的扫描线
function GetImageData(Width, Height, Stride: Integer; Scan0: Pointer;
  format: TPixelFormat = pf32bit; InvertLine: Boolean = False): TImageData; overload;
  // 获取新的图像数据结构，必须用FreeImageData释放
function GetImageData(Width, Height: Integer; format: TPixelFormat = pf32bit): TImageData; overload;
  // 获取TBitmap类型的图像数据结构，像素格式范围pf1Bit - pf32Bit
function GetBitmapData(Bitmap: TBitmap): TImageData;
{$IF RTLVersion >= 17.00}inline; {$IFEND}
  // 获取Hbitmap的图像数据结构，PixelBits像素位数。用FreeImageData释放。
//  function GetHBitmapData(DC: HDC; Bitmap: HBitmap; PixelBits: Integer = 32): TImageData;
  // 如果Data分配了扫描线内存，释放扫描线内存
procedure FreeImageData(var Data: TImageData);

  // 根据图像数据结构Data填充并返回Windows位图信息的文件头
function GetBitmapInfoHeader(const Data: TImageData): TBitmapInfoHeader;
  // 获取DC裁剪矩形ClipRect，并根据dstRect调整ClipRect和dstRect，ClipRect非空返回True.
  // 说明：dstRect和ClipRect的Right和Bottom分别为宽度和高度
function GetDCClipBox(DC: HDC; var dstRect, ClipRect: TRect): Boolean;
  // 按Data大小和pbi信息获取DC从x,y坐标处的图像数据到Data.Scan0(内部使用)
procedure GetDCImageData(DC: HDC; x, y: Integer; var Data: TImageData; pbi: TBitmapInfo);
  // 将Data图像数据按pbi信息转换后传输到DC的x, y坐标处(内部使用)
procedure BitBltImageData(DC: HDC; x, y: Integer; const Data: TImageData; pbi: TBitmapInfo);

  // 交换Colors数组内的Red与Blue
procedure SwapColors(Colors: PRGBQuad; Count: Integer);
  // 为BASM拷贝过程设置寄存器(内部使用)
  // in  eax = Dest, edx = Source
  // out esi = source.Scan0, eax = source.Offset
  //     edi = dest.Scan0, ebx = dest.Offset,
  //     ecx = min Width, edx = min Height
procedure SetCopyRegs(Dest, Source: TImageData);

  // --> st floay value
  // <-- eax int value
function _Infinity: Integer;
function GetInfinity(X: double): Integer;


  // 拷贝Source到32位Dest。如果是8位或者4位Source，必须要有相应的颜色表Colors
procedure ImageCopyFrom(var Dest: TImageData; const Source: TImageData; Colors: PRGBQuad = nil);
  // 拷贝32位Source到32 or 24位Dest。
procedure ImageCopyTo(var Dest: TImageData; const Source: TImageData);

  // 获取Graphic的图像数据。必须用FreeImageData释放数据结构
function GetImageData(Graphic: TGraphic): TImageData; overload;
  // 获取Bitmap的图像数据。如果isBinding=False，复制Bitmap数据，
  // 用FreeImageData释放数据结构，否则，Bitmap转换为32位后直接操作扫描线
function GetImageData(Bitmap: TBitmap; isBinding: Boolean): TImageData; overload;

  // 锁定Bitmap并返回图像数据结构，直接操作Bitmap扫描线，必须用GpBitmapUnLockData解锁
function GpBitmapLockData(Bitmap: TGpBitmap): TImageData;
  // 对锁定Bitmap的图像数据结构Data解锁
procedure GpBitmapUnLockData(Bitmap: TGpBitmap; var Data: TImageData);
  // 获取Bitmap图像数据结构，如果FreeBitmap=True，释放Bitmap。
  // 必须用FreeImageData释放返回值
function GetImageData(Bitmap: TGpBitmap;
  FreeBitmap: Boolean = False): TImageData; overload;

  // 图像数据转换为TBitmap。ImitationColor转换为16位以下时是否仿色
  // 如果图像有Alpha信息同时背景色ColorBackground<>0，填充背景
function ImageDataToBitmap(Data: TImageData; PixelFormat: TPixelFormat = pf24Bit;
  ImitationColor: Boolean = False; ColorBackground: TColor = 0): TBitmap;
  // 图像数据拷贝到TGraphic。其余参数同上
procedure ImageDataAssignTo(Data: TImageData; Graphic: TGraphic;
  ImitationColor: Boolean = False; ColorBackground: TColor = 0); overload;

  // 图像数据转换Bitmap。ImitationColor转换为16位以下时是否仿色，
  // 如果图像有Alpha信息同时背景色ColorBackground<>0，填充背景
function ImageDataToGpBitmap(Data: TImageData; PixelFormat: TPixelFormat = pf24bppRGB;
  ImitationColor: Boolean = False; ColorBackground: TARGB = 0): TGpBitmap;
  // 图像数据拷贝到Bitmap。其余参数同上
procedure ImageDataAssignTo(Data: TImageData; Bitmap: TGpBitmap;
  ImitationColor: Boolean; ColorBackground: TARGB = 0); overload;
implementation

function GetImageData(Width, Height, Stride: Integer;
  Scan0: Pointer; format: TPixelFormat; InvertLine: Boolean): TImageData;
const
  BitCounts: array[pf1bit..pf32bit] of Byte = (1, 4, 8, 16, 16, 24, 32);
begin
  if (format < pf1bit) or (format > pf32bit) then
    raise EImageDataError.Create(EIDErrorNotSupport);
  Result.Width := Width;
  Result.Height := Height;
  Result.Scan0 := Scan0;
  Result.Reserved := 0;
  Result.InvertLine := InvertLine;
  Result.PixelFormat := BitCounts[format];
  if Stride = 0 then
    Result.Stride := ((Width * Result.PixelFormat + 31) and $FFFFFFE0) shr 3
  else
    Result.Stride := Stride;
  Result.PixelFormat := Result.PixelFormat shl 8;
  if format = pf15bit then
    Result.PixelFormat := Result.PixelFormat or 5;
end;

function GetImageData(Width, Height: Integer; format: TPixelFormat): TImageData;
begin
  Result := GetImageData(Width, Height, 0, nil, format);
  Result.Scan0 := GlobalAllocPtr(GHND, Height * Result.Stride);
  if Result.Scan0 = nil then
    raise EOutOfMemory.Create(EIDErrorOutOfMemory);
  Result.AllocScan := True;
end;

function GetBitmapData(Bitmap: TBitmap): TImageData;
begin
  with Bitmap do
    Result := GetImageData(Width, Height, 0, ScanLine[Height - 1], PixelFormat, True);
end;

procedure FreeImageData(var Data: TImageData);
begin
  if Data.AllocScan and (Data.Scan0 <> nil) then
    GlobalFreePtr(Data.Scan0);
  Data.Scan0 := nil;
  Data.Reserved := Data.Reserved and $FF;
end;

function GetBitmapInfoHeader(const Data: TImageData): TBitmapInfoHeader;
begin
  Result.biSize := Sizeof(TBitmapInfoHeader);
  Result.biWidth := Data.Width;
  Result.biHeight := Data.Height;
  Result.biPlanes := 1;
  Result.biBitCount := (Data.PixelFormat shr 8) and $FF;
  Result.biCompression := BI_RGB;
end;

procedure GetDCImageData(DC: HDC; x, y: Integer; var Data: TImageData; pbi: TBitmapInfo);
var
  saveBitmap, Bitmap: HBITMAP;
  memDC: HDC;
begin
  Bitmap := CreateCompatibleBitmap(DC, Data.Width, Data.Height);
  try
    memDC := CreateCompatibleDC(DC);
    saveBitmap := SelectObject(memDC, Bitmap);
    try
      BitBlt(memDC, 0, 0, Data.Width, Data.Height, DC, x, y, SRCCOPY);
    finally
      SelectObject(memDC, saveBitmap);
      DeleteDC(memDC);
    end;
    GetDIBits(DC, bitmap, 0, Data.Height, Data.Scan0, pbi, DIB_RGB_COLORS);
  finally
    DeleteObject(Bitmap);
  end;
end;

procedure BitBltImageData(DC: HDC; x, y: Integer; const Data: TImageData; pbi: TBitmapInfo);
var
  saveBitmap, Bitmap: HBITMAP;
  memDC: HDC;
begin
  Bitmap := CreateDIBItmap(DC, pbi.bmiHeader, CBM_INIT, Data.Scan0, pbi, DIB_RGB_COLORS);
  memDC := CreateCompatibleDC(DC);
  saveBitmap := SelectObject(memDC, Bitmap);
  try
    BitBlt(DC, x, y, Data.Width, Data.Height, memDC, 0, 0, SRCCOPY);
  finally
    SelectObject(memDC, saveBitmap);
    DeleteDC(memDC);
    DeleteObject(Bitmap);
  end;
end;

function GetDCClipBox(DC: HDC; var dstRect, ClipRect: TRect): Boolean;
var
  w, h: Integer;
begin
  Result := False;
  if GetClipBox(DC, ClipRect) <= NULLREGION then
    Exit;
  w := dstRect.Right;
  if dstRect.Left < 0 then
  begin
    Inc(w, dstRect.Left);
    ClipRect.Left := 0;
  end
  else
  begin
    ClipRect.Left := dstRect.Left;
    dstRect.Left := 0;
  end;
  if w + ClipRect.Left > ClipRect.Right then
    w := ClipRect.Right - ClipRect.Left;
  if w <= 0 then Exit;
  h := dstRect.Bottom;
  if dstRect.Top < 0 then
  begin
    Inc(h, dstRect.Top);
    ClipRect.Top := 0;
  end
  else
  begin
    ClipRect.Top := dstRect.Top;
    dstRect.Top := 0;
  end;
  if h + ClipRect.Top > ClipRect.Bottom then
    h := ClipRect.Bottom - ClipRect.Top;
  if h <= 0 then Exit;
  ClipRect.Right := w;
  ClipRect.Bottom := h;
  Result := True;
end;

procedure SetCopyRegs(Dest, Source: TImageData);
asm
    mov     edi, [edx].TImageData.Width
    cmp     edi, [eax].TImageData.Width
    jbe     @@1
    mov     edi, [eax].TImageData.Width
@@1:
    push    edi                 // ecx = width = min(source.Width, dest.Width)
    movzx   ecx, byte ptr [edx].TImageData.PixelFormat[1]
    imul    ecx, edi
    add     ecx, 7
    shr     ecx, 3
    mov     ebx, [edx].TImageData.Stride
    sub     ebx, ecx
    push    ebx                 // eax = srcOffset = source.Stride - ((PixelBits * width + 7) >> 3)
    mov     esi, [edx].TImageData.Scan0 // esi = source.Scan0
    movzx   ecx, byte ptr [eax].TImageData.PixelFormat[1]
    imul    ecx, edi
    add     ecx, 7
    shr     ecx, 3
    mov     ebx, [eax].TImageData.Stride
    sub     ebx, ecx            // ebx = dstOffset = dest.Stride - ((PixelBits * width + 7) >> 3)
    mov     edi, [eax].TImageData.Scan0 // edi = dest.Scan0
    mov     cl, [edx].TImageData.InvertLine
    mov     edx, [edx].TImageData.Height// edx = height = min(source.Height, dest.Height)
    cmp     edx, [eax].TImageData.Height
    jbe     @@2
    mov     edx, [eax].TImageData.Height
@@2:
    cmp     cl, [eax].TImageData.InvertLine
    je      @@3
    mov     ecx, [eax].TImageData.Stride
    mov     eax, [eax].TImageData.Height// if (dest.InvertLine != source.InvertLine)
    dec     eax                         // {
    imul    eax, ecx                    //   edi += ((dest.Height - 1) * dest.Stride)
    add     edi, eax
    shl     ecx, 1                      //   ebx -= (dest.Stride * 2)
    sub     ebx, ecx                    // }
@@3:
    pop     eax
    pop     ecx
end;

procedure SwapColors(Colors: PRGBQuad; Count: Integer);
asm
    mov     ecx, eax
@@Loop:
    dec     edx
    js      @@Exit
    mov     eax, [ecx+edx*4]
    bswap   eax
    shr     eax, 8
    mov     [ecx+edx*4], eax
    jmp     @@Loop
@@Exit:
end;

function _Infinity: Integer;
asm
    sub     esp, 8
    fstcw   word ptr [esp]
    fstcw   word ptr [esp+2]
    fwait
    or      word ptr [esp+2], 0b00h
    fldcw   word ptr [esp+2]
    fistp   dword ptr [esp+4]
    fwait
    fldcw   word ptr [esp]
    pop     eax
    pop     eax
end;

function GetInfinity(X: double): Integer;
asm
    fld     qword ptr X
    call    _Infinity
end;



代码实现：

procedure ImageCopyFrom(var Dest: TImageData; const Source: TImageData; Colors: PRGBQuad);

  procedure SetBit1Pixel;
  asm
    mov     bl, [esi]
    mov     bh, 80h
@@pixelLoop1:
    test    bl, bh
    jz      @@pb1
    mov     eax, 0ffffffffh
    jmp     @@pb2
@@pb1:
    mov     eax, 0ff000000h
@@pb2:
    stosd
    shr     bh, 1
    loop    @@pixelLoop1
    inc     esi
  end;

var
  pixelBits, dstOffset, srcOffset, tmp: Integer;
begin
  if ImageEmpty(Dest) then
    raise EImageDataError.CreateFmt(EIDErrorDestMust, [32]);
  if (Source.Scan0 = nil) or (Source.Width <= 0) or (Source.Height <= 0) then
    raise EImageDataError.Create(EIDErrorNotSupport);
  tmp := Source.PixelFormat;
  PixelBits := (tmp shr 8) and $FF;
  if ((PixelBits = 4) or (PixelBits = 8)) and (Colors = nil) then
    raise EImageDataError.CreateFmt(EIDErrorColorTable, [PixelBits]);
  asm
    push    esi
    push    edi
    push    ebx
    mov     eax, Dest
    mov     edx, Source
    call    SetCopyRegs
    mov     dstOffset, ebx
    mov     srcOffset, eax
    mov     eax, pixelBits
    cmp     eax, 32
    je      @@cpyBit32
    cmp     eax, 24
    je      @@cpyBit24
    cmp     eax, 16
    je      @@cpyBit16
    cmp     eax, 8
    je      @@cpyBit8
    cmp     eax, 4
    je      @@cpyBit4
//    cmp     eax, 1
//    je      @@cpyBit1

@@cpyBit1:
    mov     eax, 7
    and     eax, ecx
    mov     tmp, eax
    shr     ecx, 3
@@yLoop1:
    push    ecx
    jecxz   @@1_1
@@xLoop1:
    push    ecx
    mov     ecx, 8
    call    SetBit1Pixel
    pop     ecx
    loop    @@xLoop1
@@1_1:
    mov     ecx, tmp
    jecxz   @@1_2
    call    SetBit1Pixel
@@1_2:
    pop     ecx
    add     esi, srcOffset
    add     edi, dstOffset
    dec     edx
    jnz     @@yLoop1
    jmp     @@subReturn

@@cpyBit4:
    mov     tmp, ecx
    shr     ecx, 1
    mov     ebx, colors
@@yLoop4:
    push    ecx
@@xLoop4:
    dec     ecx
    js      @@4_1
    movzx   eax, byte ptr [esi]
    push    eax
    shr     eax, 4
    mov     eax, [ebx+eax*4]
    or      eax, 0ff000000h
    stosd
    pop     eax
    and     eax, 0fh
    mov     eax, [ebx+eax*4]
    or      eax, 0ff000000h
    stosd
    inc     esi
    jmp     @@xLoop4
@@4_1:
    test    tmp, 1
    jz      @@4_2
    movzx   eax, byte ptr [esi]
    shr     eax, 4
    mov     eax, [ebx + eax * 4]
    or      eax, 0ff000000h
    stosd
    inc     esi
@@4_2:
    pop     ecx
    add     esi, srcOffset
    add     edi, dstOffset
    dec     edx
    jnz     @@yLoop4
    jmp     @@subReturn

@@cpyBit8:
    mov     ebx, colors
@@yLoop8:
    push    ecx
@@xLoop8:
    movzx   eax, byte ptr [esi]
    mov     eax, [ebx+eax*4]
    or      eax, 0ff000000h
    stosd
    inc     esi
    loop    @@xLoop8
    pop     ecx
    add     esi, srcOffset
    add     edi, dstOffset
    dec     edx
    jnz     @@yLoop8
    jmp     @@subReturn

@@cpyBit16:
    mov     ebx, ecx
    mov     ecx, 0fc06h         // 565
    cmp     byte ptr tmp, 5
    jne     @@yLoop16
    mov     ecx, 0f805h         // 555
@@yLoop16:
    push    ebx
@@xLoop16:
    lodsw
    shl     eax, 3
    stosb
    shr     eax, cl
    and     al, ch
    stosb
    shr     eax, 5
    and     al, 0f8h
    or      ax, 0ff00h
    stosw
    dec     ebx
    jnz     @@xLoop16
    pop     ebx
    add     esi, srcOffset
    add     edi, dstOffset
    dec     edx
    jnz     @@yLoop16
    jmp     @@subReturn

@@cpyBit24:
    mov     eax, 0ffh
@@yLoop24:
    push    ecx
@@xLoop24:
    movsw
    movsb
    stosb
    loop    @@xLoop24
    pop     ecx
    add     esi, srcOffset
    add     edi, ebx
    dec     edx
    jnz     @@yLoop24
    jmp     @@subReturn

@@cpyBit32:
@@yLoop32:
    mov     eax, srcOffset
    push    ecx
    rep     movsd
    pop     ecx
    add     esi, eax
    add     edi, ebx
    dec     edx
    jnz     @@yLoop32
@@subReturn:
    pop     ebx
    pop     edi
    pop     esi
  end;
end;

procedure ImageCopyTo(var Dest: TImageData; const Source: TImageData);
var
  PixelBits: Integer;
begin
  if ImageEmpty(Source) then
    raise EImageDataError.CreateFmt(EIDErrorSourceMust, [32]);
  PixelBits := (Dest.PixelFormat shr 8) and $FF;
  if (Dest.Scan0 = nil) or (Dest.Width <= 0) or (Dest.Height <= 0) or (PixelBits < 24) then
    raise EImageDataError.Create(EIDErrorNotSupport);
  asm
    push    esi
    push    edi
    push    ebx
    mov     eax, Dest
    mov     edx, Source
    call    SetCopyRegs
    cmp     PixelBits, 24
    je      @@cpyBit24
@@yLoop32:
    push    ecx
    rep     movsd
    pop     ecx
    add     esi, eax
    add     edi, ebx
    dec     edx
    jnz     @@yLoop32
    jmp     @@Exit
@@cpyBit24:
@yLoop24:
    push      ecx
@xLoop24:
    movsw
    movsb
    inc       esi
    loop      @xLoop24
    pop       ecx
    add       esi, eax
    add       edi, ebx
    dec       edx
    jnz       @yLoop24
@@Exit:
    pop       ebx
    pop       edi
    pop       esi
  end;
end;

procedure FillAlpha(Data: TImageData);
asm
    mov       edx, [eax].TImageData.Scan0
    mov       ecx, [eax].TImageData.Width
    imul      ecx, [eax].TImageData.Height
    mov       eax, 0ff000000h
  @PixelLoop:
    or        [edx], eax
    add       edx, 4
    loop      @PixelLoop
end;

function GetImageData(Graphic: TGraphic): TImageData;
var
  tmp: TBitmap;
  Data: TImageData;
  Pal: HPalette;
  Colors: array[Byte] of TRGBQuad;
  Count: Integer;
begin
  if Graphic is TBitmap then
    tmp := Graphic as TBitmap
  else
  begin
    tmp := TBitmap.Create;
    tmp.Assign(Graphic);
  end;
  try
    if (tmp.PixelFormat = pf8bit) or (tmp.PixelFormat = pf4bit) then
    begin
      Pal := tmp.Palette;
      Count := GetPaletteEntries(Pal, 0, 256, Colors);
      DeleteObject(Pal);
      SwapColors(@Colors, Count);
    end;
    Data := GetBitmapData(tmp);
    Result := GetImageData(Data.Width, Data.Height);
    ImageCopyFrom(Result, Data, @Colors);
  finally
    if tmp <> Graphic then
      tmp.Free;
  end;
end;

function GetImageData(Bitmap: TBitmap; isBinding: Boolean): TImageData;
var
  IsFill: Boolean;
begin
  if not isBinding then
    Result := GetImageData(Bitmap)
  else
  begin
    IsFill := Bitmap.PixelFormat <> pf32Bit;
    Bitmap.PixelFormat := pf32Bit;
    Result := GetImageData(Bitmap.Width, Bitmap.Height, 0,
      Bitmap.ScanLine[Bitmap.Height - 1], pf32bit, True);
    if IsFill then FillAlpha(Result);
  end;
end;

function GetImageData(Bitmap: TGpBitmap; FreeBitmap: Boolean): TImageData;
var
  Data: TBitmapData;
begin
  Result := GetImageData(Bitmap.Width, Bitmap.Height);
  Data.Stride := Result.Stride;
  Data.Scan0 := Result.Scan0;
  Data := Bitmap.LockBits(GpRect(0, 0, Result.Width, Result.Height),
    [imRead, imUserInputBuf], pf32bppARGB);
  Bitmap.UnlockBits(Data);
  if FreeBitmap then
    Bitmap.Free;
end;

function GetLockData(Bitmap: TGpBitmap; Format: Gdiplus.TPixelFormat): TImageData;
begin
  if Format = pfNone then
    Format := Bitmap.PixelFormat;
  if Format > pf32bppARGB then
    Format := pf32bppARGB;
  TBitmapData(Result) := Bitmap.LockBits(GpRect(0, 0, Bitmap.Width, Bitmap.Height),
    [imRead, imWrite], Format);
end;

function GpBitmapLockData(Bitmap: TGpBitmap): TImageData;
begin
  Result := GetLockData(Bitmap, pf32bppARGB);
end;

procedure GpBitmapUnLockData(Bitmap: TGpBitmap; var Data: TImageData);
var
  LockMode: TImageLockModes;
begin
  LockMode := [imRead, imWrite];
  if Data.LockMode = Byte(LockMode) then
  begin
    Bitmap.UnlockBits(TBitmapData(Data));
    Data.Scan0 := nil;
    Data.Reserved := 0;
  end;
end;
type
  TIndexData = class(TIndexImage) end;

procedure ImageDataAssignTo(Data: TImageData; Graphic: TGraphic;
  ImitationColor: Boolean; ColorBackground: TColor);
var
  tmp: TBitmap;
  src, dst: TImageData;
  IdxData: TIndexData;
  Grays: TGrayStatData;
begin
  if ImageEmpty(Data) or not Assigned(Graphic) then
    raise EImageDataError.Create(EIDErrorEmptyData);
  if Graphic is TBitmap then
    tmp := Graphic as TBitmap
  else
  begin
    tmp := TBitmap.Create;
    tmp.Assign(Graphic);
  end;
  try
    if not (tmp.PixelFormat in [pf1Bit..pf16Bit]) then
    begin
      if tmp.Empty then
      begin
        tmp.Width := Data.Width;
        tmp.Height := Data.Height;
      end;
      dst := GetBitmapData(tmp);
      ImageCopyTo(dst, Data);
    end
    else
    begin
      IdxData := TIndexData.Create;
      try
        if ColorBackground <> 0 then
        begin
          src := GetImageData(Data.Width, Data.Height);
          ImageCopyTo(src, Data);
        end
        else
        begin
          src := Data;
          src.AllocScan := False;
        end;
        IdxData.SourceData := src;
        if ColorBackground <> 0 then
        begin
          SwapColors(@ColorBackground, 1);
          IdxData.FillBackground(ColorBackground);
        end;
        IdxData.IndexFormat := TIndexFormat(Integer(tmp.PixelFormat) - 1);
        IdxData.Dithering := ImitationColor;
        if IdxData.IndexFormat = if1Bit then
        begin
          ImageGrayStat(src, Grays);
          IdxData.MonochromeThreshold := Grays.Average;
        end;
        if IdxData.IndexFormat <= if8Bit then
          tmp.Palette := IdxData.Palette;
        if tmp.Empty then
        begin
          tmp.Width := Data.Width;
          tmp.Height := Data.Height;
        end;
        dst := GetBitmapData(tmp);
        IdxData.CreateIndexImageData(dst);
      finally
        IdxData.Free;
      end;
    end;
    if not (Graphic is TBitmap) then
      Graphic.Assign(tmp);
  finally
    if not (Graphic is TBitmap) then
      tmp.Free;
  end;
end;

function ImageDataToBitmap(Data: TImageData; PixelFormat: TPixelFormat;
  ImitationColor: Boolean; ColorBackground: TColor): TBitmap;
begin
  Result := TBitmap.Create;
  Result.PixelFormat := PixelFormat;
  ImageDataAssignTo(Data, Result, ImitationColor, ColorBackground);
end;

type
  TIndexData = class(TGpIndexBitmap) end;

procedure ImageDataAssignTo(Data: TImageData; Bitmap: TGpBitmap;
  ImitationColor: Boolean; ColorBackground: TARGB);
var
  src, dst: TImageData;
  IdxData: TIndexData;
  Grays: TGrayStatData;
  Bits: Integer;
begin
  if ImageEmpty(Data) or (Bitmap = nil) then
    raise EImageDataError.Create(EIDErrorEmptyData);
  dst := GetLockData(Bitmap, pfNone);
  try
    Bits := (dst.PixelFormat shr 8) and $FF;
    if Bits < 24 then
    begin
      IdxData := TIndexData.Create;
      try
        if ColorBackground <> 0 then
        begin
          src := GetImageData(dst.Width, dst.Height);
          ImageCopyTo(src, Data);
        end
        else
        begin
          src := Data;
          src.AllocScan := False;
        end;
        IdxData.SourceData := src;
        if ColorBackground <> 0 then
          IdxData.FillBackground(ColorBackground);
        IdxData.IndexFormat := TIndexFormat(Bits shr 2);
        IdxData.Dithering := ImitationColor;
        if IdxData.IndexFormat = if1Bit then
        begin
          ImageGrayStat(src, Grays);
          IdxData.MonochromeThreshold := Grays.Average;
        end;
        if IdxData.IndexFormat <= if8Bit then
          Bitmap.Palette := IdxData.GetPalette;
        IdxData.CreateIndexImageData(dst);
      finally
        IdxData.Free;
      end
    end
    else ImageCopyTo(dst, Data);
  finally
    GpBitmapUnLockData(Bitmap, dst);
  end;
end;

function ImageDataToGpBitmap(Data: TImageData; PixelFormat: Gdiplus.TPixelFormat;
  ImitationColor: Boolean; ColorBackground: TARGB): TGpBitmap;
begin
  if ImageEmpty(Data) then
    raise EImageDataError.Create(EIDErrorEmptyData);
  Result := TGpBitmap.Create(Data.Width, Data.Height, PixelFormat);
  ImageDataAssignTo(Data, Result, ImitationColor, ColorBackground);
end;

type
  TImageAbort = function(Data: Pointer): BOOL; stdcall;

var
  AbortSubSize: Integer = 256;

function ImageSetAbortBlockSize(Size: Integer): Integer;
begin
  Result := AbortSubSize;
  if Size > 0 then
    AbortSubSize := Size;
end;

function ExecuteProc(var Dest: TImageData; const Source: TImageData;
  ImageProc: Pointer; Args: array of const): Boolean;
var
  Proc: Pointer;
asm
    push    esi
    push    edi
    push    ebx
    mov     Proc, ecx
    mov     ecx, Args-4
    inc     ecx
    jecxz   @@1
    mov     ebx, Args           //     param = Args
@@paramLoop:
    push    dword ptr [ebx]     //     for (i = args; i > 0; i --, param -= 4)
    add     ebx, 8              //       push(param)
    loop    @@paramLoop
@@1:
    call  SetCopyRegs32
    call  Proc
    mov   eax, True
    pop   ebx
    pop   edi
    pop   esi
end;

function ExecuteAbort(var Dest: TImageData; const Source: TImageData;
  AbortProc: Pointer; Args: array of const;
  Callback: TImageAbort; CallbackData: Pointer): Boolean;
var
  width, height, w, size: Integer;
  wBytes, dhBytes, shBytes: Integer;
  dstScan0, srcScan0: Pointer;
  dstOffset, srcOffset: Integer;
  argCount: Integer;
  Proc: Pointer;
asm
    push    esi
    push    edi
    push    ebx
    mov     Proc, ecx
    mov     ecx, [eax].TImageData.Width
    cmp     ecx, [edx].TImageData.Width
    jbe     @@1
    mov     ecx, [edx].TImageData.Width
@@1:
    mov     width, ecx          // width = Min(source.width, dest.width)
    mov     ecx, [eax].TImageData.Height
    cmp     ecx, [edx].TImageData.Height
    jbe     @@2
    mov     ecx, [edx].TImageData.Height
@@2:
    mov     height, ecx         // height = Min(source.height, dest.height)
    mov     ecx, AbortSubSize
    mov     size, ecx           // size = @AbortSubSize
    shl     ecx, 2
    mov     wBytes, ecx         // wBytes = size * 4
    mov     ebx, [edx].TImageData.Scan0
    mov     srcScan0, ebx       // srcScan0 = source.Scan0
    mov     ebx, [edx].TImageData.Stride
    mov     edi, size
    imul    edi, ebx
    mov     shBytes, edi        // shBytes = size * source.Stride
    sub     ebx, ecx
    mov     srcOffset, ebx      // srcOffset = source.Stride - wBytes
    mov     edi, [eax].TImageData.Scan0// dstScan0 = dest.Scan0
    mov     ebx, [eax].TImageData.Stride
    mov     esi, size
    imul    esi, ebx            // dhBytes = size * dest.Stride
    sub     ebx, ecx            // dstOffset = dest.Stride - wBytes
    mov     cl, [eax].TImageData.InvertLine
    cmp     cl, [edx].TImageData.InvertLine
    je      @@3
    mov     ecx, [eax].TImageData.Stride
    mov     eax, [eax].TImageData.Height
    dec     eax                 // if (dest.InvertLine != source.InvertLine)
    imul    eax, ecx            // {
    add     edi, eax            //   dstScan0 += ((height - 1) * dest.Stride
    shl     ecx, 1              //   dstOffset -= (dest.Stride * 2)
    sub     ebx, ecx            //   dhBytes = -dhBytes
    neg     esi                 // }
@@3:
    mov     dstScan0, edi       // edi = dstScan0
    mov     dstOffset, ebx
    mov     dhBytes, esi
    mov     esi, srcScan0       // esi = srcScan0
    mov     eax, Args-4
    inc     eax
    mov     argCount, eax
@@hLoop:
    mov     edx, size           // for (; height > 0; height -= size)
    cmp     edx, height         // {
    jbe     @@4                 //   edx = size (sub height)
    mov     edx, height         //   if (edx > height) edx = height
@@4:
    mov     eax, width          //   for (w = width; w > 0; w -= size)
    mov     w, eax              //   {
@@wLoop:
    push    edx
    push    esi
    push    edi
    mov     ecx, argCount
    jecxz   @@5
    mov     ebx, Args           //     param = Args
@@paramLoop:
    push    dword ptr [ebx]     //     for (i = args; i > 0; i --, param -= 4)
    add     ebx, 8              //       push(param)
    loop    @@paramLoop
@@5:
    mov     ecx, size           //     ecx = size (sub width)
    mov     ebx, dstOffset      //     ebx = dstOffset
    mov     eax, srcOffset      //     eax = srcOffset
    cmp     ecx, w
    jbe     @@6
    sub     ecx, w              //     if (ecx > w)
    shl     ecx, 2              //     {
    add     ebx, ecx            //       ebx += ((ecx - w) * 4)
    add     eax, ecx            //       eax += ((ecx - w) * 4)
    mov     ecx, w              //       ecx = w
@@6:                            //     }
    call    Proc                //     AbotrProc(...)
    push    CallbackData
    call    Callback            //     if (callback(callbackData))
    test    eax, eax            //       return
    jz      @@7
    add     esp, 12
    jmp     @@Abort
@@7:
    pop     edi
    pop     esi
    pop     edx
    add     esi, wBytes         //     esi += wBytes
    add     edi, wBytes         //     edi += wBytes
    mov     eax, w
    sub     eax, size
    mov     w, eax
    jg      @@wLoop             //   }
    mov     eax, height
    sub     eax, size
    jle     @@Exit
    mov     height, eax
    mov     esi, srcScan0       //   srcScan0 += shBytes
    add     esi, shBytes        //   esi = srcScan0
    mov     srcScan0, esi
    mov     edi, dstScan0       //   dstScan0 += dhBytes
    add     edi, dhBytes        //   edi = dstScan0
    mov     dstScan0, edi
    jmp     @@hLoop             // }
@@Abort:
    xor     eax, eax
    jmp     @@End
@@Exit:
    mov     eax, True
@@End:
    pop     ebx
    pop     edi
    pop     esi
end;

end.

