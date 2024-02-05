unit Wis;

interface
uses
  Windows, Classes, Graphics, SysUtils, Controls, DIB, Textures, GameImages, MapFiles;
type
  TWisFileHeaderInfo = packed record
    nTitle: Integer; //04 $41534957 = WISA
    VerFlag: Integer; //01
    Reserve1: Integer; //00
    DateTime: TDateTime;
    Reserve2: Integer;
    Reserve3: Integer;
    CopyRight: string[20];
    aTemp1: array[1..107] of Char;
    nHeaderEncrypt: Integer; //0XA0
    nHeaderLen: Integer; //0XA4
    nImageCount: Integer; //0XA8
    nHeaderData: Integer; //0XAC

    aTemp2: array[1..$200 - $AC] of Char;
  end;
  PWisFileHeaderInfo = ^TWisFileHeaderInfo;

  TWisHeader = packed record
    OffSet: Integer;
    Length: Integer;
    temp3: Integer;
  end;
  PTWisHeader = ^TWisHeader;
  TWisFileHeaderArray = array of TWisHeader;

  TImgInfo = packed record
    btEncr0: Byte; //0X00
    btEncr1: Byte; //0X01
    bt2: Byte; //0X02
    bt3: Byte; //0X03
    wW: Smallint; //0X04
    wH: Smallint; //0X06
    wPx: Smallint; //0X08
    wPy: Smallint; //0X0A
  end;
  PTImgInfo = ^TImgInfo;

  TWisImages = class(TGameImages)
  private
    FIndexOffset: Integer;
    FileHeader: TWisFileHeaderInfo;
    FileStream: TFileStream; //TMapStream; //
    IndexArray: TWisFileHeaderArray;
    function Decode(ASrc: PByte; DIB: TDIB; ASrcSize: Integer): Integer;
    function DecodeWis(ASrc, ADst: PByte; ASrcSize, ADstSize: Integer): Boolean;
    function LoadIndex: Boolean;
    function GetDIB(Index: Integer): TDIB;
    function Get(Index: Integer; var PX, PY: Smallint): TDIB;
    procedure LoadDxImage(WisHeader: PTWisHeader; DXImage: pTDXImage);
  protected
    function GetCachedSurface(Index: Integer): TTexture; override;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Initialize; override;
    procedure Finalize; override;
    function GetCachedImage(Index: Integer; var PX, PY: Integer): TTexture; override;
    property Items[Index: Integer]: TDIB read GetDIB;
  end;

implementation
uses Math; //, MShare;    , Share


function SGL_RLE8_Decode(ASrc, ADst: PByte; ASrcSize,
  ADstSize: Integer): Boolean;
var
  L, I: Byte;
begin
  while (ASrcSize > 0) and (ADstSize > 0) do begin
    if (PByte(ASrc)^ and $80) = 0 then begin //0..127
      L := ASrc^;
      Inc(ASrc);
      Dec(ASrcSize, 2);
      if L > ADstSize then L := ADstSize;
      Dec(ADstSize, L);
      for I := 1 to L do
      begin
        ADst^ := ASrc^;
        Inc(ADst);
      end;
      Inc(ASrc);
    end else begin
      L := PByte(ASrc)^ and $7F;
      Inc(PByte(ASrc));
      Dec(ASrcSize, L + 1);
      if L > ADstSize then L := ADstSize;
      Dec(ADstSize, L);
      for I := 1 to L do begin
        ADst^ := ASrc^;
        Inc(ADst);
        Inc(ASrc);
      end;
    end;
  end;
  Result := True;
end;

function TWisImages.Decode(ASrc: PByte; DIB: TDIB; ASrcSize: Integer): Integer;
var
  V, Len, Len1, I: Byte;
  ADstSize: Integer;
  boSkip: Boolean;
  X, Y: Integer;

  function WritePixel(Color: Byte): Boolean;
  var
    Row: PByteArray;
  begin
    if X = DIB.Height then begin
      Result := True;
      Exit;
    end;
    Row := DIB.ScanLine[X];
    Row[Y] := Color;
    Y := Y + 1;
    Result := False;
    if Y = DIB.Width then begin
      Y := 0;
      X := X + 1;
      Result := True;
    end;
  end;
begin
  Result := 0;
  Len := 0;
  Len1 := 0;
  X := 0;
  Y := 0;
  ADstSize := 0;
  boSkip := False;
  while ADstSize < ASrcSize do begin
    if not boSkip then begin
      V := ASrc^;
      Inc(PByte(ASrc));
      Inc(Result);
    end;
    if (V = 0) and (Len <= 0) then begin
      V := ASrc^;
      Len := V;
      Inc(PByte(ASrc));
      Inc(Result);
      boSkip := True;
    end;
    if boSkip then begin
      if Len <> 0 then begin
        Inc(ADstSize, Len);
        Inc(Result, Len);
        //Move(ASrc^, ADst^, Len);
        for I := 1 to Len do begin
          WritePixel(ASrc^);
          Inc(PByte(ASrc));
        end;
        //Inc(PByte(ASrc), Len);
        //Inc(PByte(ADst), Len);
        Len := 0;
      end else begin
        boSkip := False;
      end;
    end else begin
      Len1 := V;
      Inc(Result);
      Inc(ADstSize, Len1);
      for I := 1 to Len1 do begin
        WritePixel(ASrc^);
        //ADst^ := ASrc^;
        //Inc(PByte(ADst));
      end;
      Inc(PByte(ASrc));
      Len1 := 0;
    end;
  end;
end;

function TWisImages.DecodeWis(ASrc, ADst: PByte; ASrcSize,
  ADstSize: Integer): Boolean;
var
  V, Len, L, I: Byte;
  boSkip: Boolean;
begin
  Result := False;
  boSkip := False;
  Len := 0;
  L := 0;
  while (ASrcSize > 0) and (ADstSize > 0) do begin
    if not boSkip then begin
      V := ASrc^;
      Dec(ASrcSize);
      Inc(PByte(ASrc));
    end;
    if (V = 0) and (Len <= 0) then begin
      V := ASrc^;
      Len := V;
      Dec(ASrcSize);
      Inc(PByte(ASrc));
      boSkip := True;
    end;
    if boSkip then begin
      if Len <> 0 then begin
        Dec(ADstSize, Len);
        Dec(ASrcSize, Len);
        Move(ASrc^, ADst^, Len);
        Inc(PByte(ADst), Len);
        Inc(PByte(ASrc), Len);
      end else begin
        boSkip := False;
      end;
      Len := 0;
    end else begin
      L := V;
      Dec(ASrcSize);
      Dec(ADstSize, L);
      V := ASrc^;
      Inc(PByte(ASrc));
      for I := 1 to L do begin
        ADst^ := V;
        Inc(ADst);
      end;
      L := 0;
    end;
  end;

  Result := True;
end;

constructor TWisImages.Create();
begin
  inherited;
  FileStream := nil;
  IndexArray := nil;
end;

destructor TWisImages.Destroy;
begin
  inherited;
end;

procedure TWisImages.Initialize;
begin
  if not Initialized then begin
    if FileExists(FileName) then begin
      //FileStream := TMapStream.Create(FileName);
      //FileStream.Active := True;

      if LoadIndex then begin
        FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
        //if FileStream = nil then
          //FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
        //FileStream.Read(FileHeader, SizeOf(TWisFileHeaderInfo));
        m_ImgArr := AllocMem(SizeOf(TDXImage) * ImageCount);
        Initialized := True;
      end;
    end;
  end;
end;

procedure TWisImages.Finalize;
var
  I: Integer;
begin
  Initialized := False;
  IndexList.Clear;
  ImageCount := 0;
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
    FreeMem(m_ImgArr);
  end;

  m_ImgArr := nil;
  IndexArray := nil;

  if FileStream <> nil then
    FreeAndNil(FileStream);
end;

function TWisImages.LoadIndex: Boolean;
  function DecPointer(P: Pointer; Size: Integer): Pointer;
  begin
    Result := Pointer(Integer(P) - Size);
  end;
var
  iFileOffset, nIndex, nIndexOffset: Integer;

  WisHeader: pTWisHeader;
  WisIndexArray: TWisFileHeaderArray;
  MapStream: TMapStream;
begin
  Result := False;

  MapStream := TMapStream.Create;
  if MapStream.LoadFromFile(FileName) then begin
    iFileOffset := 512;
    nIndexOffset := MapStream.Size;
    WisHeader := Pointer(Integer(MapStream.Memory) + MapStream.Size);
    while True do begin
      if nIndexOffset > iFileOffset then begin
        Dec(nIndexOffset, SizeOf(TWisHeader));
        WisHeader := DecPointer(WisHeader, SizeOf(TWisHeader));
        if (WisHeader.OffSet >= iFileOffset) and (WisHeader.Length >= 1) then begin
          SetLength(WisIndexArray, Length(WisIndexArray) + 1);
          WisIndexArray[Length(WisIndexArray) - 1] := WisHeader^;
          if (WisHeader.OffSet <= iFileOffset) then begin
            FIndexOffset := nIndexOffset;
            break;
          end;
        end else break;
      end else begin
        FIndexOffset := nIndexOffset;
        break;
      end;
    end;
  {
  MapStream := TMapStream.Create(FileName);
  MapStream.Active := True;

  iFileOffset := 512;
  nIndexOffset := MapStream.Size;
  WisHeader := Pointer(Integer(MapStream.Memory) + MapStream.Size);
  while True do begin
    if nIndexOffset > iFileOffset then begin
      Dec(nIndexOffset, SizeOf(TWisHeader));
      WisHeader := DecPointer(WisHeader, SizeOf(TWisHeader));
      if (WisHeader.OffSet >= iFileOffset) and (WisHeader.Length >= 1) then begin
        SetLength(WisIndexArray, Length(WisIndexArray) + 1);
        WisIndexArray[Length(WisIndexArray) - 1] := WisHeader^;
        if (WisHeader.OffSet <= iFileOffset) then begin
          FIndexOffset := nIndexOffset;
          break;
        end;
      end else break;
    end else begin
      FIndexOffset := nIndexOffset;
      break;
    end;
  end;
  MapStream.Free;
  }

    SetLength(IndexArray, Length(WisIndexArray));
    for nIndex := 0 to Length(WisIndexArray) - 1 do begin
      IndexArray[nIndex] := WisIndexArray[Length(WisIndexArray) - nIndex - 1];
    end;
    ImageCount := Length(IndexArray);

    Result := True;
  end;
  MapStream.Free;
end;

function TWisImages.GetCachedImage(Index: Integer; var PX, PY: Integer): TTexture;
begin
  Result := nil;
  m_dwUseCheckTick := GetTickCount;
  if (Index >= 0) and (Index < ImageCount) then begin
    if GetTickCount - m_dwMemChecktTick > 10000 then begin
      m_dwMemChecktTick := GetTickCount;
      FreeOldMemorys(Index);
    end;
    if m_ImgArr[Index].Texture = nil then begin
      IndexList.Add(Pointer(Index));
      LoadDxImage(@IndexArray[Index], @m_ImgArr[Index]);
      PX := m_ImgArr[Index].nPx;
      PY := m_ImgArr[Index].nPy;
      Result := m_ImgArr[Index].Texture;
    end else begin
      m_ImgArr[Index].dwLatestTime := GetTickCount;
      PX := m_ImgArr[Index].nPx;
      PY := m_ImgArr[Index].nPy;
      Result := m_ImgArr[Index].Texture;
    end;
  end;
end;

function TWisImages.GetCachedSurface(Index: Integer): TTexture;
begin
  Result := nil;
  m_dwUseCheckTick := GetTickCount;
  if (Index >= 0) and (Index < ImageCount) then begin
    if GetTickCount - m_dwMemChecktTick > 10000 then begin
      m_dwMemChecktTick := GetTickCount;
      FreeOldMemorys(Index);
    end;
    if m_ImgArr[Index].Texture = nil then begin
      IndexList.Add(Pointer(Index));
      LoadDxImage(@IndexArray[Index], @m_ImgArr[Index]);
      Result := m_ImgArr[Index].Texture;
    end else begin
      m_ImgArr[Index].dwLatestTime := GetTickCount;
      Result := m_ImgArr[Index].Texture;
    end;
  end;
end;

function WidthBytes(w: integer): integer;
begin
  Result := (((w * 8) + 31) div 32) * 4;
end;

procedure TWisImages.LoadDxImage(WisHeader: PTWisHeader; DXImage: pTDXImage);
var
  I, J, nError: Integer;
  ImgInfo: TImgInfo;

  S, D: Pointer;

  SrcP: PByte;
  DesP: PByte;
  nSize: Integer;
  RGB: TRGBQuad;
begin
  try
    nError := 0;
    FileStream.Position := WisHeader.OffSet;
    nError := 1;
    FileStream.Read(ImgInfo, SizeOf(ImgInfo));
    nError := 2;
    nSize := ImgInfo.wW * ImgInfo.wH;
    nError := 3;
    if (nSize > 0) and (nSize < 999999) then begin
      DXImage.Texture := TTexture.Create;
      DXImage.nPx := ImgInfo.wPx;
      DXImage.nPy := ImgInfo.wPy;
      DXImage.dwLatestTime := GetTickCount;
      nError := 4;
      DXImage.Texture.SetSize(WidthBytes(ImgInfo.wW), ImgInfo.wH);
      nError := 5;
      if ImgInfo.btEncr0 = 1 then begin
        nError := 6;
        GetMem(S, WisHeader.Length);
        nError := 7;
        GetMem(D, nSize);
        nError := 8;
        SrcP := S;
        DesP := D;
        FileStream.Read(SrcP^, WisHeader.Length);
        nError := 9;
        DecodeWis(SrcP, DesP, WisHeader.Length, nSize);
        nError := 10;
        FreeMem(S);
        nError := 11;
        S := D;
        nError := 12;
        for I := 0 to DXImage.Texture.Height - 1 do begin //256色数据转换成16位数据
          SrcP := PByte(Integer(S) + I * ImgInfo.wW);
          DesP := PByte(Integer(DXImage.Texture.PBits) + I * DXImage.Texture.Pitch); //(DXImage.Texture.Height - 1 - I)
          for J := 0 to ImgInfo.wW - 1 do begin
            PWord(DesP)^ := ColorTable_565[SrcP^];
            {RGB := MainPalette[SrcP^];
            if Integer(RGB) = 0 then begin
              PWord(DesP)^ := 0;
            end else begin
              //PWord(DesP)^ := RGBColors[RGB.rgbRed, RGB.rgbGreen, RGB.rgbBlue];
              PWord(DesP)^ := Word((Max(RGB.rgbRed and $F8, 8) shl 8) or (Max(RGB.rgbGreen and $FC, 8) shl 3) or (Max(RGB.rgbBlue and $F8, 8) shr 3)); //565格式
            end; }
            Inc(SrcP);
            Inc(DesP, 2);
          end;
        end;
        nError := 13;
        FreeMem(S);
        nError := 14;
      end else begin
        nError := 15;
        GetMem(S, nSize);
        nError := 16;
        FileStream.Read(S^, nSize);
        nError := 17;
        for I := 0 to DXImage.Texture.Height - 1 do begin //256色数据转换成16位数据
          SrcP := PByte(Integer(S) + I * ImgInfo.wW);
          DesP := PByte(Integer(DXImage.Texture.PBits) + I * DXImage.Texture.Pitch); //(DXImage.Texture.Height - 1 - I)
          for J := 0 to ImgInfo.wW - 1 do begin
            PWord(DesP)^ := ColorTable_565[SrcP^];

           { RGB := MainPalette[SrcP^];
            if Integer(RGB) = 0 then begin
              PWord(DesP)^ := 0;
            end else begin
              //PWord(DesP)^ := RGBColors[RGB.rgbRed, RGB.rgbGreen, RGB.rgbBlue];
              PWord(DesP)^ := Word((Max(RGB.rgbRed and $F8, 8) shl 8) or (Max(RGB.rgbGreen and $FC, 8) shl 3) or (Max(RGB.rgbBlue and $F8, 8) shr 3)); //565格式
            end;}
            Inc(SrcP);
            Inc(DesP, 2);
          end;
        end;
        nError := 18;
        FreeMem(S);
        nError := 19;
      end;
    end else begin
      DXImage.Texture := TTexture.Create;
      DXImage.Texture.SetSize(1, 1);
      DXImage.Texture.Fill(0);
      DXImage.nPx := 0;
      DXImage.nPy := 0;
    end;
  except
    //DebugOutStr('TWisImages.LoadDxImage:' + IntToStr(nError));
  end;
end;

function TWisImages.GetDIB(Index: Integer): TDIB;
var
  I, nError: Integer;
  ImgInfo: TImgInfo;
  S, D: Pointer;
  SrcP: PByte;
  DesP: PByte;
  nSize: Integer;
  lsDIB: TDIB;
begin
  lsDIB := nil;
  Result := nil;
  try
    if (Index >= 0) and (Index < ImageCount) then begin
      FileStream.Position := IndexArray[Index].OffSet;
      FileStream.Read(ImgInfo, SizeOf(ImgInfo));

      nSize := ImgInfo.wW * ImgInfo.wH;
      if (nSize > 0) and (nSize < 999999) then begin
        lsDIB := TDIB.Create;
        lsDIB.BitCount := 8;
        lsDIB.ColorTable := MainPalette;
        lsDIB.UpdatePalette;

        lsDIB.Width := WidthBytes(ImgInfo.wW);
        lsDIB.Height := ImgInfo.wH;

        lsDIB.Canvas.Brush.Color := clblack;
        lsDIB.Canvas.FillRect(lsDIB.Canvas.ClipRect);
        if ImgInfo.btEncr0 = 1 then begin
          nError := 6;
          GetMem(S, IndexArray[Index].Length);
          nError := 7;
          GetMem(D, nSize);
          nError := 8;
          SrcP := S;
          DesP := D;
          FileStream.Read(SrcP^, IndexArray[Index].Length);
          nError := 9;
          DecodeWis(SrcP, DesP, IndexArray[Index].Length, nSize);
          nError := 10;
          FreeMem(S);
          nError := 11;
          S := D;
          for I := 0 to lsDIB.Height - 1 do begin
            SrcP := PByte(Integer(S) + I * ImgInfo.wW);
            DesP := PByte(Integer(lsDIB.PBits) + (lsDIB.Height - 1 - I) * lsDIB.WidthBytes);
            Move(SrcP^, DesP^, lsDIB.Width);
          end;
          FreeMem(S);

        end else begin
          for I := 0 to lsDIB.Height - 1 do begin
            SrcP := PByte(Integer(lsDIB.PBits) + (lsDIB.Height - 1 - I) * lsDIB.WidthBytes);
            FileStream.Read(SrcP^, ImgInfo.wW);
          end;
        end;
        Result := lsDIB;
      end else Result := nil;
    end else Result := nil;
  except
    Result := nil;
    if lsDIB <> nil then
      lsDIB.Free;
  end;
end;

function TWisImages.Get(Index: Integer; var PX, PY: Smallint): TDIB;
var
  I, nError: Integer;
  ImgInfo: TImgInfo;
  S, D: Pointer;
  SrcP: PByte;
  DesP: PByte;
  nSize: Integer;
  lsDIB: TDIB;
begin
  lsDIB := nil;
  Result := nil;
  try
    if (Index >= 0) and (Index < ImageCount) then begin
      FileStream.Position := IndexArray[Index].OffSet;
      FileStream.Read(ImgInfo, SizeOf(ImgInfo));
      PX := ImgInfo.wPx;
      PY := ImgInfo.wPy;
      nSize := ImgInfo.wW * ImgInfo.wH;
      if (nSize > 0) and (nSize < 999999) then begin
        lsDIB := TDIB.Create;
        lsDIB.BitCount := 8;
        lsDIB.ColorTable := MainPalette;
        lsDIB.UpdatePalette;

        lsDIB.Width := WidthBytes(ImgInfo.wW);
        lsDIB.Height := ImgInfo.wH;

        lsDIB.Canvas.Brush.Color := clblack;
        lsDIB.Canvas.FillRect(lsDIB.Canvas.ClipRect);
        if ImgInfo.btEncr0 = 1 then begin
          nError := 6;
          GetMem(S, IndexArray[Index].Length);
          nError := 7;
          GetMem(D, nSize);
          nError := 8;
          SrcP := S;
          DesP := D;
          FileStream.Read(SrcP^, IndexArray[Index].Length);
          nError := 9;
          DecodeWis(SrcP, DesP, IndexArray[Index].Length, nSize);
          nError := 10;
          FreeMem(S);
          nError := 11;
          S := D;
          for I := 0 to lsDIB.Height - 1 do begin
            SrcP := PByte(Integer(S) + I * ImgInfo.wW);
            DesP := PByte(Integer(lsDIB.PBits) + (lsDIB.Height - 1 - I) * lsDIB.WidthBytes);
            Move(SrcP^, DesP^, lsDIB.Width);
          end;
          FreeMem(S);

        end else begin
          for I := 0 to lsDIB.Height - 1 do begin
            SrcP := PByte(Integer(lsDIB.PBits) + (lsDIB.Height - 1 - I) * lsDIB.WidthBytes);
            FileStream.Read(SrcP^, ImgInfo.wW);
          end;
        end;
        Result := lsDIB;
      end else Result := nil;
    end else Result := nil;
  except
    Result := nil;
    if lsDIB <> nil then
      lsDIB.Free;
  end;
end;

end.
