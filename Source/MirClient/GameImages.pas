unit GameImages;

interface
uses
  Windows, Classes, Graphics, SysUtils, DIB, Textures, HUtil32; //SDK,
type
  TDXImage = record
    nPx: SmallInt;
    nPy: SmallInt;
    Bitmap: TBitmap;
    Texture: TTexture;
    dwLatestTime: longword;
  end;
  pTDxImage = ^TDXImage;

  TLibType = (ltUseCache, ltLoadBmp, ltLoadBmpFile, ltLoadMemory);
  TDxImageArr = array[0..MaxListSize div 4] of TDXImage;
  PTDxImageArr = ^TDxImageArr;

  TGameImages = class(TObject)
    m_dwFreeMemCheckTick: longword;
    m_dwUseCheckTick: longword;
    m_dwMemChecktTick: longword;
    m_nProcIdx: Integer;
  private
    FFileName: string; //0x24
    FImageCount: Integer; //0x28

    FAppr: Word;
    FBitCount: Byte;
    FInitialized: Boolean;
    FLibType: TLibType;
  protected
    function GetCachedSurface(Index: Integer): TTexture; virtual;
    function GetCachedBitmap(Index: Integer): TBitmap; virtual;
  public
    IndexList: TList;
    m_ImgArr: PTDxImageArr;
    constructor Create(); virtual;
    destructor Destroy; override;
    procedure FreeOldMemorys(Index: Integer); overload;
    procedure FreeOldMemorys; overload;
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    procedure ClearCache; virtual;

    function GetCachedImage(Index: Integer; var px, py: Integer): TTexture; virtual;
    function GetBitmap(Index: Integer; var PX, PY: Integer): TBitmap; virtual;

    procedure StretchBlt(Index: Integer; DC: HDC; X, Y: Integer; var Width, Height: Integer; ROP: Cardinal);
    procedure DrawZoom(paper: TCanvas; X, Y, Index: Integer; Zoom: Real);
    procedure DrawZoomEx(paper: TCanvas; X, Y, Index: Integer; Zoom: Real; leftzero: Boolean); overload;
    procedure DrawZoomEx(ABitmap: TBitmap; DC: HDC; X, Y, Width, Height: Integer); overload;
    property Images[Index: Integer]: TTexture read GetCachedSurface;
    property Bitmaps[Index: Integer]: TBitmap read GetCachedBitmap;
    property FileName: string read FFileName write FFileName;
    property ImageCount: Integer read FImageCount write FImageCount;
    property Appr: Word read FAppr write FAppr;
    property BitCount: byte read FBitCount write FBitCount;
    property Initialized: Boolean read FInitialized write FInitialized;
    property LibType: TLibType read FLibType write FLibType;
  end;
var
  MainPalette: TRGBQuads;
  ColorTable_565: array[0..255] of Word;
  ColorTableBright_565: array[0..High(Word)] of Word;
  ColorTableGray_565: array[0..High(Word)] of Word;

  ColorTableRed_565: array[0..High(Word)] of Word;
  ColorTableGreen_565: array[0..High(Word)] of Word;
  ColorTableBlue_565: array[0..High(Word)] of Word;
  ColorTableYellow_565: array[0..High(Word)] of Word;
  ColorTableFuchsia_565: array[0..High(Word)] of Word;
implementation
uses MShare;

constructor TGameImages.Create();
begin
  FLibType := ltUseCache;
  FInitialized := False;
  FBitCount := 8;
  FImageCount := 0;
  FAppr := 0;
  m_ImgArr := nil;
  IndexList := TList.Create;
  m_dwUseCheckTick := GetTickCount;
  m_dwMemChecktTick := GetTickCount;
  m_nProcIdx := 0;
end;

destructor TGameImages.Destroy;
begin
  Finalize;
  IndexList.Free;
  inherited;
end;

procedure TGameImages.Initialize;
begin

end;

procedure TGameImages.Finalize;
begin

end;

procedure TGameImages.ClearCache;
var
  I: Integer;
begin
  m_nProcIdx := 0;
  IndexList.Clear;
  if m_ImgArr <> nil then begin
    for I := 0 to ImageCount - 1 do begin
      if m_ImgArr[I].Texture <> nil then begin
        m_ImgArr[I].Texture.Free;
        m_ImgArr[I].Texture := nil;
      end;
      if m_ImgArr[I].Bitmap <> nil then begin
        m_ImgArr[I].Bitmap.Free;
        m_ImgArr[I].Bitmap := nil;
      end;
    end;
  end;

end;

function TGameImages.GetCachedSurface(Index: Integer): TTexture;
begin
  Result := nil;
end;

function TGameImages.GetCachedImage(Index: Integer; var px, py: Integer): TTexture;
begin
  Result := nil;
end;

function TGameImages.GetBitmap(Index: Integer; var PX, PY: Integer): TBitmap;
begin
  Result := nil;
end;

function TGameImages.GetCachedBitmap(Index: Integer): TBitmap;
begin
  Result := nil;
end;

procedure TGameImages.FreeOldMemorys(Index: Integer);
var
  nIdx, nIndex, nCount: Integer;
  dwTimeTick: longword;
  boCheckTimeLimit: Boolean;
begin
  dwTimeTick := GetTickCount;
  if m_ImgArr <> nil then begin
    nIdx := m_nProcIdx;
    boCheckTimeLimit := False;
    while True do begin
      if IndexList.Count <= nIdx then Break;
      nIndex := Integer(IndexList.Items[nIdx]);

      if (Index <> nIndex) and (nIndex >= 0) and (nIndex < FImageCount) then begin
        if (m_ImgArr[nIndex].Texture = nil) then begin
          IndexList.Delete(nIdx);
          Continue;
        end;

        if (m_ImgArr[nIndex].Texture <> nil) and (GetTickCount - m_ImgArr[nIndex].dwLatestTime > 60 * 1000 * 2) then begin
          IndexList.Delete(nIdx);
          try
            FreeAndNil(m_ImgArr[nIndex].Texture);
          except
            DebugOutStr('TGameImages::FreeOldMemorys1');
          end;
          Continue;
        end;
      end;

      Inc(nIdx);
      if (GetTickCount - dwTimeTick) > 10 then begin
        boCheckTimeLimit := True;
        m_nProcIdx := nIdx;
        Break;
      end;
    end;
    if not boCheckTimeLimit then m_nProcIdx := 0;
  end;
end;

procedure TGameImages.FreeOldMemorys();
var
  nIndex: Integer;
  dwTimeTick: longword;
  nIdx: Integer;
  boCheckTimeLimit: Boolean;
begin
  dwTimeTick := GetTickCount;
  if m_ImgArr <> nil then begin
    //if (GetTickCount - m_dwFreeMemCheckTick > 1 * 1000) then begin
     // m_dwFreeMemCheckTick := GetTickCount;

    dwTimeTick := GetTickCount;
    nIdx := m_nProcIdx;
    boCheckTimeLimit := False;
    while True do begin
      if IndexList.Count <= nIdx then Break;
      nIndex := Integer(IndexList.Items[nIdx]);
      if (nIndex >= 0) and (nIndex < ImageCount) then begin
        if (m_ImgArr[nIndex].Texture = nil) then begin
          IndexList.Delete(nIdx);
          Continue;
        end;

        if (m_ImgArr[nIndex].Texture <> nil) and (GetTickCount - m_ImgArr[nIndex].dwLatestTime > 60 * 1000 * 2) then begin
          IndexList.Delete(nIdx);
          try
            FreeAndNil(m_ImgArr[nIndex].Texture);
          except
            DebugOutStr('TGameImages::FreeOldMemorys2');
          end;
          Continue;
        end;
      end;
      Inc(nIdx);
      if (GetTickCount - dwTimeTick) > 10 then begin
        boCheckTimeLimit := True;
        m_nProcIdx := nIdx;
        Break;
      end;
    end;
    if not boCheckTimeLimit then m_nProcIdx := 0;
  end;
end;

procedure TGameImages.StretchBlt(Index: Integer; DC: HDC; X, Y: Integer; var Width, Height: Integer; ROP: Cardinal);
var
  ABitmap: TBitmap;
begin
  ABitmap := Bitmaps[Index];
  if ABitmap <> nil then begin
  // 缩放方式将 DIB Bits 写到设备环境
    if (ABitmap.Width > Width) or (ABitmap.Height > Height) then begin
      if ABitmap.Width > ABitmap.Height then begin
        Height := Round(Height * ABitmap.Height / ABitmap.Width);
      end else begin
        Width := Round(Width * ABitmap.Width / ABitmap.Height);
      end;
    end else begin
      Height := ABitmap.Height;
      Width := ABitmap.Width;
    end;
    DrawZoomEx(ABitmap, DC, X, Y, Width, Height);
  end;
end;

procedure TGameImages.DrawZoom(paper: TCanvas; X, Y, Index: Integer; Zoom: Real);
var
  rc: TRect;
  bmp: TBitmap;
begin
  bmp := Bitmaps[Index];
  if bmp <> nil then begin
    rc.Left := X;
    rc.Top := Y;
    rc.Right := X + Round(bmp.Width * Zoom);
    rc.Bottom := Y + Round(bmp.Height * Zoom);
    if (rc.Right > rc.Left) and (rc.Bottom > rc.Top) then begin
      paper.StretchDraw(rc, bmp);
    end;
  end;
end;

procedure TGameImages.DrawZoomEx(ABitmap: TBitmap; DC: HDC; X, Y, Width, Height: Integer);
var
  rc: TRect;
  bmp, bmp2: TBitmap;
begin
  //bmp := ABitmap;
  bmp := TBitmap.Create;
  bmp.Width := ABitmap.Width;
  bmp.Height := ABitmap.Height;
  bmp.Canvas.Draw(0, 0, ABitmap);
  //bmp.Assign(ABitmap);

  bmp2 := TBitmap.Create;
  bmp2.Width := Width;
  bmp2.Height := Height;
  rc.Left := X;
  rc.Top := Y;
  rc.Right := X + Width;
  rc.Bottom := Y + Height;

  if (rc.Right > rc.Left) and (rc.Bottom > rc.Top) then begin
    bmp2.Canvas.StretchDraw(Rect(0, 0, bmp2.Width, bmp2.Height), bmp);
    SpliteBitmap(DC, X, Y, bmp2, $0)
  end;

  bmp.Free;
  bmp2.Free;
end;

procedure TGameImages.DrawZoomEx(paper: TCanvas; X, Y, Index: Integer; Zoom: Real; leftzero: Boolean);
var
  nX, nY: integer;
  SrcP, DesP: Pointer;
  rc: TRect;
  bmp, bmp2: TBitmap;
begin
  bmp := Bitmaps[Index];
  if bmp <> nil then begin
    bmp2 := TBitmap.Create;
    bmp2.Width := Round(bmp.Width * Zoom);
    bmp2.Height := Round(bmp.Height * Zoom);
    bmp2.PixelFormat := pf32bit;
    rc.Left := X;
    rc.Top := Y;
    rc.Right := X + Round(bmp.Width * Zoom);
    rc.Bottom := Y + Round(bmp.Height * Zoom);

    if (rc.Right > rc.Left) and (rc.Bottom > rc.Top) then begin
      bmp2.Canvas.StretchDraw(Rect(0, 0, bmp2.Width, bmp2.Height), bmp);
      if leftzero then begin
        SpliteBitmap(paper.handle, X, Y, bmp2, $0)
      end else begin
        SpliteBitmap(paper.handle, X, Y - bmp2.Height, bmp2, $0);
      end;
    end;
    bmp2.Free;
  end;
end;
var
  ColorArray: array[0..1023] of Byte = (
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

procedure BuildColor();
var
  I: Integer;
  pal1, pal2: TRGBQuad;
  r, G, b, n: Byte;
begin
  Move(ColorArray, MainPalette, SizeOf(ColorArray));
  for I := 0 to Length(ColorTable_565) - 1 do begin
    if Integer(MainPalette[I]) = 0 then
      ColorTable_565[I] := 0
    else
      ColorTable_565[I] := Word((_Max(MainPalette[I].rgbRed and $F8, 8) shl 8) or (_Max(MainPalette[I].rgbGreen and $FC, 8) shl 3) or (_Max(MainPalette[I].rgbBlue and $F8, 8) shr 3)); //565格式
  end;

  ColorTableBright_565[0] := 0;
  ColorTableGray_565[0] := 0;

  ColorTableRed_565[0] := 0;
  ColorTableGreen_565[0] := 0;
  ColorTableBlue_565[0] := 0;
  ColorTableYellow_565[0] := 0;
  ColorTableFuchsia_565[0] := 0;

  for I := 1 to High(Word) do begin
    pal1.rgbRed := I and $F800 shr 8;
    pal1.rgbGreen := I and $07E0 shr 3;
    pal1.rgbBlue := I and $001F shl 3;

    n := Round((pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) / 3);
    pal2.rgbRed := n;
    pal2.rgbGreen := n;
    pal2.rgbBlue := n;
    ColorTableGray_565[I] := Word((_Max(pal2.rgbRed and $F8, 8) shl 8) or (_Max(pal2.rgbGreen and $FC, 8) shl 3) or (_Max(pal2.rgbBlue and $F8, 8) shr 3)); //565格式

    pal2.rgbRed := _MIN(Round(pal1.rgbRed * 1.3), 255);
    pal2.rgbGreen := _MIN(Round(pal1.rgbGreen * 1.3), 255);
    pal2.rgbBlue := _MIN(Round(pal1.rgbBlue * 1.3), 255);
    ColorTableBright_565[I] := Word((_Max(pal2.rgbRed and $F8, 8) shl 8) or (_Max(pal2.rgbGreen and $FC, 8) shl 3) or (_Max(pal2.rgbBlue and $F8, 8) shr 3)); //565格式

    ColorTableRed_565[I] := _MAX(Word(pal1.rgbRed and $F8 shl 8), $0800);


    r := 0;
    G := Word(_MAX(Round((pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) / 3), $20)); //max处理见蓝色的注释
    b := 0;
    //ColorTableGreen_565[I] := Word((r and $F8 shl 8) or (G and $FC shl 3) or (b and $F8 shr 3));
    ColorTableGreen_565[I] := G and $FC shl 3;

    r := 0;
    G := 0;
    b := Word(_MAX(Round((pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) / 3), $08)); //0x08是最小的颜色值，如果不这样处理，可能会变成黑色，就是透明了
    ColorTableBlue_565[I] := Word((r and $F8 shl 8) or (G and $FC shl 3) or (b and $F8 shr 3));

    r := Word(Round((pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) / 3));
    G := r;
    b := 0;
    ColorTableYellow_565[I] := Word((r and $F8 shl 8) or (G and $FC shl 3) or (b and $F8 shr 3));

    r := Word(Round((pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) / 3));
    G := 0;
    b := r;
    ColorTableFuchsia_565[I] := _MAX(Word((r and $F8 shl 8) or (b and $F8 shr 3)), $0801);
  end;
end;

initialization
  BuildColor();
end.

