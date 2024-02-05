unit Wzl;

interface
uses
  Windows, Classes, Graphics, SysUtils, Controls, MapFiles, Textures, GameImages, DIB;
type
  TWzlImageHeader = record
    Title: string[40]; //'WEMADE Entertainment inc.'
    ImageCount: Integer;
    ColorCount: Integer;
    PaletteSize: Integer;
    VerFlag: Integer;
    Flag: Integer;
  end;
  PTWzlImageHeader = ^TWzlImageHeader;

  TWzlImageInfo = record
    bt1: Byte; //bt1=3 8位 bt1=5 16位
    bt2: Byte;
    bt3: Byte;
    bt4: Byte;
    nWidth: SmallInt;
    nHeight: SmallInt;
    px: SmallInt;
    py: SmallInt;
    Length: Integer;
  end;
  PTWzlImageInfo = ^TWzlImageInfo;

  TWzlIndexHeader = record
    Title: string[40]; //'WEMADE Entertainment inc.'
    IndexCount: Integer;
  end;
  PTWzlIndexHeader = ^TWzlIndexHeader;

  pTWzlImages = ^TWzlImages;
  TWzlImages = class(TGameImages)
  private
    FHeader: TWzlImageHeader;
    procedure LoadIndex(sIdxFile: string);
    procedure LoadDxImage(Position: Integer; DXImage: pTDXImage);
  protected
    function GetCachedSurface(Index: Integer): TTexture; override;
  public
    m_IndexList: TList;
    m_FileStream: TFileStream; //TMapStream; //TFileStream;
    //MainPalette: TRGBQuads;

    constructor Create(); override;
    destructor Destroy; override;
    procedure Initialize; override;
    procedure Finalize; override;
    function GetCachedImage(Index: Integer; var PX, PY: Integer): TTexture; override;
  end;
implementation
uses zlibex, Math;

function ExtractFilePath(const FileName: string): string;
var
  I: integer;
begin
  I := LastDelimiter(PathDelim + DriveDelim, FileName);
  Result := Copy(FileName, 1, I);
end;

function ExtractFileNameOnly(const fname: string): string;
var
  extpos: integer;
  ext, fn: string;
begin
  ext := ExtractFileExt(fname);
  fn := ExtractFileName(fname);
  if ext <> '' then begin
    extpos := Pos(ext, fn);
    Result := Copy(fn, 1, extpos - 1);
  end else
    Result := fn;
end;

procedure TextOutStr(Msg: string);
var
  flname: string;
  fhandle: TextFile;
begin
  flname := '.\Text.txt';
  if FileExists(flname) then begin
    AssignFile(fhandle, flname);
    Append(fhandle);
  end else begin
    AssignFile(fhandle, flname);
    Rewrite(fhandle);
  end;
  Writeln(fhandle, TimeToStr(Time) + ' ' + Msg);
  CloseFile(fhandle);
end;

constructor TWzlImages.Create();
begin
  inherited Create;
  m_FileStream := nil;
  m_IndexList := TList.Create;
end;

destructor TWzlImages.Destroy;
begin
  m_IndexList.Free;
  inherited;
end;

procedure TWzlImages.Initialize;
var
  idxfile, sFileName, sFileExt: string;
begin
  if not Initialized then begin
    if FileExists(FileName) then begin

      m_FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);

      m_FileStream.Read(FHeader, SizeOf(TWzlImageHeader));

      ImageCount := FHeader.ImageCount;

      m_ImgArr := AllocMem(SizeOf(TDXImage) * ImageCount);

      idxfile := ExtractFilePath(FileName) + ExtractFileNameOnly(FileName) + '.WZX';

      LoadIndex(idxfile);
      Initialized := True;
    end;
  end;
end;

procedure TWzlImages.Finalize;
var
  I: Integer;
begin
  Initialized := False;
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
    FreeMem(m_ImgArr);
  end;
  m_ImgArr := nil;
  ImageCount := 0;
  if m_FileStream <> nil then
    FreeAndNil(m_FileStream);
end;

procedure TWzlImages.LoadIndex(sIdxFile: string);
var
  FHandle, I, Value: integer;
  Header: TWzlIndexHeader;
  PValue: PInteger;
begin
  m_IndexList.Clear;
  if FileExists(sIdxFile) then begin
    FHandle := FileOpen(sIdxFile, fmOpenRead or fmShareDenyNone);
    if FHandle > 0 then begin
      FileRead(FHandle, Header, SizeOf(TWzlIndexHeader));

      GetMem(PValue, 4 * Header.IndexCount);
      FileRead(FHandle, PValue^, 4 * Header.IndexCount);
      for I := 0 to Header.IndexCount - 1 do begin
        Value := PInteger(Integer(PValue) + 4 * I)^;
        m_IndexList.Add(Pointer(Value));
      end;
      FreeMem(PValue);
      FileClose(FHandle);
    end;
  end;
end;

procedure TWzlImages.LoadDxImage(Position: Integer; DXImage: pTDXImage);
var
  I, J: Integer;
  SrcP: PByte;
  DesP: Pointer;

  ImageInfo: TWzlImageInfo;

  nSize: Integer; //nWidth, nHeight,d

  Source: TDIB;
  NewSource: TDIB;

  FileData: Pointer;
  FileSize: Integer;

  InBuf: Pointer;

  OutBuf: Pointer;
  OutBytes: Integer;
begin
  if (Position < m_FileStream.Size) and (DXImage.Texture = nil) then begin
    if Position = 0 then begin //需要更新资源
      DXImage.dwLatestTime := GetTickCount;
      DXImage.nPx := 0;
      DXImage.nPy := 0;
      DXImage.Texture := TTexture.Create;
      DXImage.Texture.SetSize(1, 1);
      // DebugOutStr('TWzlImages::LoadDxImage1 '+FileName);
      Exit;
    end;

    m_FileStream.Position := Position;
    m_FileStream.Read(ImageInfo, SizeOf(TWzlImageInfo));

    if (ImageInfo.nWidth * ImageInfo.nHeight <= 0) then begin //空图片
      DXImage.dwLatestTime := GetTickCount;
      DXImage.nPx := ImageInfo.px;
      DXImage.nPy := ImageInfo.py;
      DXImage.Texture := TTexture.Create;
      DXImage.Texture.SetSize(1, 1);
     // DebugOutStr('TWzlImages::LoadDxImage2 '+FileName);
      Exit;
    end;

    DXImage.dwLatestTime := GetTickCount;
    DXImage.nPx := ImageInfo.px;
    DXImage.nPy := ImageInfo.py;

    //nHeight := ImageInfo.nHeight;

    Source := TDIB.Create;
    if ImageInfo.bt1 = 3 then begin
        //nWidth := WidthBytes(ImageInfo.nWidth);
     // nWidth := ImageInfo.nWidth;
      nSize := ImageInfo.nWidth * ImageInfo.nHeight;
      Move(MainPalette, Source.ColorTable, SizeOf(MainPalette));
      Source.UpdatePalette;
      Source.SetSize(ImageInfo.nWidth, ImageInfo.nHeight, 8);
    end else begin
      //nWidth := ImageInfo.nWidth;
      nSize := ImageInfo.nWidth * ImageInfo.nHeight * 2; //ImageInfo.nWidth
      Source.PixelFormat := MakeDIBPixelFormat(5, 6, 5);
      Source.SetSize(ImageInfo.nWidth, ImageInfo.nHeight, 16);
    end;
    Source.Canvas.Brush.Color := clBlack;
    Source.Canvas.FillRect(Source.Canvas.ClipRect);

    if ImageInfo.Length > 0 then begin //压缩的数据
      GetMem(InBuf, ImageInfo.Length);

      m_FileStream.Read(InBuf^, ImageInfo.Length);

      try
        DecompressBuf(InBuf, ImageInfo.Length, nSize, OutBuf, OutBytes);
      except
      end;
      if (OutBuf <> nil) and (OutBytes > 0) then begin
        Move(OutBuf^, Source.PBits^, OutBytes);
        FreeMem(OutBuf);
      end;
      FreeMem(InBuf);
    end else begin      //未压缩的数据
      m_FileStream.Read(Source.PBits^, nSize);
    end;
    DXImage.Texture := TTexture.Create;
    DXImage.Texture.SetSize(Source.Width, Source.Height);
    if Source.BitCount = 8 then begin
      for I := 0 to DXImage.Texture.Height - 1 do begin //256色数据转换成16位数据
        DesP := DXImage.Texture.ScanLine[I];
        SrcP := Source.ScanLine[I];
        for J := 0 to DXImage.Texture.Width - 1 do begin
          PWord(DesP)^ := ColorTable_565[SrcP^];
          Inc(SrcP);
          Inc(PWord(DesP));
        end;
      end;
    end else begin
      for I := 0 to DXImage.Texture.Height - 1 do begin
        DesP := DXImage.Texture.ScanLine[I];
        SrcP := Source.ScanLine[I];
        Move(SrcP^, DesP^, DXImage.Texture.Pitch);
      end;
    end;
    //Source.SaveToFile(IntToStr(Position) + '.bmp');
    Source.Free;

    if DXImage.Texture = nil then begin
      DXImage.dwLatestTime := GetTickCount;
      DXImage.nPx := ImageInfo.px;
      DXImage.nPy := ImageInfo.py;
      DXImage.Texture := TTexture.Create;
      DXImage.Texture.SetSize(1, 1);
    end;
  end;
end;

function TWzlImages.GetCachedSurface(Index: Integer): TTexture;
var
  nPosition: Integer;
  nErrCode: Integer;
begin
  Result := nil;
  try
    nErrCode := 0;
    if (Index >= 0) and (Index < ImageCount) and (m_FileStream <> nil) and (Initialized) then begin

      if GetTickCount - m_dwMemChecktTick > 1000 * 5 then begin
        m_dwMemChecktTick := GetTickCount;
        FreeOldMemorys(Index);
      end;

      nErrCode := 4;
      if m_ImgArr[Index].Texture = nil then begin
        nErrCode := 5;
        IndexList.Add(Pointer(Index));
        nErrCode := 6;
        nPosition := Integer(m_IndexList[Index]);
        nErrCode := 7;

        LoadDxImage(nPosition, @m_ImgArr[Index]);

        nErrCode := 8;
        m_ImgArr[Index].dwLatestTime := GetTickCount;
        Result := m_ImgArr[Index].Texture;
      end else begin
        m_ImgArr[Index].dwLatestTime := GetTickCount;
        Result := m_ImgArr[Index].Texture;
      end;
    end;
  except
    Result := nil;
      //DebugOutStr('TWilImages.GetCachedSurface Index: ' + IntToStr(Index) + ' Error Code: ' + IntToStr(nErrCode));
  end;
end;

function TWzlImages.GetCachedImage(Index: Integer; var PX, PY: Integer): TTexture;
var
  nPosition: integer;
  nErrCode: integer;
  Name: string;
begin
  Result := nil;
  try
    nErrCode := 0;
    if (Index >= 0) and (Index < ImageCount) and (m_FileStream <> nil) and (Initialized) then begin
      nErrCode := 1;
      if GetTickCount - m_dwMemChecktTick > 1000 * 5 then begin
        m_dwMemChecktTick := GetTickCount;
        nErrCode := 2;
        FreeOldMemorys(Index);
        nErrCode := 3;
      end;
      nErrCode := 4;
      if m_ImgArr[Index].Texture = nil then begin
        nErrCode := 5;
        IndexList.Add(Pointer(Index));
        nErrCode := 6;
        nPosition := Integer(m_IndexList[Index]);
        nErrCode := 7;
        if LibType = ltUseCache then begin
          LoadDxImage(nPosition, @m_ImgArr[Index]);
        end else begin
          //LoadDxBitmap(nPosition, @m_ImgArr[Index]);
        end;
        nErrCode := 8;
        m_ImgArr[Index].dwLatestTime := GetTickCount;
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
  except
    Result := nil;
  end;
end;

end.

