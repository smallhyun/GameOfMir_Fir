unit RawImages;
//---------------------------------------------------------------------------
// RawImages.pas                                                  Version 1.0
//                                                 Modified: January 19, 2004
//
// Implements and maintains raw-image data, aligned to 64-bit boundaries.
//---------------------------------------------------------------------------
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS"
// basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
// License for the specific language governing rights and limitations
// under the License.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Types, Classes, SysUtils, Graphics, AsphyreDef;

//---------------------------------------------------------------------------
type
 TRawImage = class
 private
  MemPtr : Pointer;
  DataPtr: Pointer;
  FWidth : Integer;
  FHeight: Integer;
  FBits  : Pointer;
  FPitch : Integer;
  FSafePx: Integer;
  FBytesPerUnit: Integer;
  AllocatedSize: Integer;
  DataSize     : Integer;

  function GetScanline(Num: Integer): Pointer;
  procedure SetSafePx(const Value: Integer);
  procedure SetBytesPerUnit(const Value: Integer);
  function GetScanCount(): Integer;
  function GetScanPtr(Num: Integer): Pointer;
  function GetAddress: TSRAddress;
 public
  property Width : Integer read FWidth;
  property Height: Integer read FHeight;

  property SafePx: Integer read FSafePx write SetSafePx;
  property BytesPerUnit: Integer read FBytesPerUnit write SetBytesPerUnit;

  property Bits  : Pointer read FBits;
  property Pitch : Integer read FPitch;
  property Scanline[Num: Integer]: Pointer read GetScanline;

  property ScanCount: Integer read GetScanCount;
  property ScanPtr[Num: Integer]: Pointer read GetScanPtr;

  property Address: TSRAddress read GetAddress;

  procedure Allocate(AWidth, AHeight: Integer);
  procedure Release();

  procedure Clear(const Value: Byte);

  // creates an exact copy of specified image (including SafePx, etc.)
  procedure AssignFrom(Source: TRawImage);

  // copies the contents of the specified image
  procedure CopyFrom(Source: TRawImage);

  procedure LoadFromBmp(Bitmap: TBitmap);
  procedure SaveToBmp(Bitmap: TBitmap);

  constructor Create();
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
 TRawImages = class
 private
  Data: array of TRawImage;

  function GetCount(): Integer;
  function GetItem(Num: Integer): TRawImage;
 public
  property Items[Num: Integer]: TRawImage read GetItem; default;
  property Count: Integer read GetCount;

  function Add(): Integer;
  procedure Remove(Num: Integer);
  procedure Clear();

  function IndexOf(Image: TRawImage): Integer;

  constructor Create();
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
constructor TRawImage.Create();
begin
 inherited;

 FWidth := 0;
 FHeight:= 0;
 MemPtr := nil;
 DataPtr:= nil;
 AllocatedSize:= 0;
 FBits  := nil;
 FPitch := 0;

 FBytesPerUnit:= 4;
 FSafePx      := 2;
end;

//---------------------------------------------------------------------------
destructor TRawImage.Destroy();
begin
 Release();

 inherited;
end;

//---------------------------------------------------------------------------
procedure TRawImage.SetBytesPerUnit(const Value: Integer);
begin
 if (MemPtr = nil) then
  begin
   FBytesPerUnit:= Value;
   if (FBytesPerUnit < 1) then FBytesPerUnit:= 1;
  end;
end;

//---------------------------------------------------------------------------
procedure TRawImage.SetSafePx(const Value: Integer);
begin
 if (MemPtr = nil) then
  begin
   FSafePx:= Value;
   if (FSafePx < 0) then FSafePx:= 0;
  end;
end;

//---------------------------------------------------------------------------
procedure TRawImage.Allocate(AWidth, AHeight: Integer);
begin
 Release();

 // make sure sizes are coherent
 if (AWidth < 1) then AWidth  := 1;
 if (AHeight < 1) then AHeight:= 1;

 // calculate the buffer's pitch
 FPitch:= (AWidth + (FSafePx * 2)) * FBytesPerUnit;

 // calculate the size of new buffer
 DataSize:= (FPitch * (AHeight + (FSafePx * 2)));
 AllocatedSize:= 8 + DataSize;

 // allocate memory for new bufer
 MemPtr:= AllocMem(AllocatedSize);

 // align data pointer to quad-word boundary
 DataPtr:= MemPtr;
 Inc(Integer(DataPtr), 8 - (Integer(DataPtr) and $07));

 // point Bits to the first real pixel
 FBits:= Pointer(Integer(DataPtr) + (SafePx * FPitch));

 // set new parameters
 FWidth := AWidth;
 FHeight:= AHeight;
end;

//---------------------------------------------------------------------------
procedure TRawImage.Release();
begin
 if (MemPtr <> nil) then FreeMem(MemPtr);

 FWidth := 0;
 FHeight:= 0;
 MemPtr := nil;
 DataPtr:= nil;
 AllocatedSize:= 0;
 FBits  := nil;
 FPitch := 0;
end;

//---------------------------------------------------------------------------
function TRawImage.GetScanline(Num: Integer): Pointer;
begin
 Result:= Pointer(Integer(FBits) + (FPitch * Num) + (FSafePx * FBytesPerUnit));
end;

//---------------------------------------------------------------------------
procedure TRawImage.Clear(const Value: Byte);
begin
 FillChar(DataPtr^, DataSize, Value);
end;

//---------------------------------------------------------------------------
function TRawImage.GetScanCount(): Integer;
begin
 Result:= FHeight + (FSafePx * 2);
end;

//---------------------------------------------------------------------------
function TRawImage.GetScanPtr(Num: Integer): Pointer;
begin
 Result:= Pointer(Integer(DataPtr) + (FPitch * Num));
end;

//---------------------------------------------------------------------------
function TRawImage.GetAddress(): TSRAddress;
begin
 Result.Bits  := GetScanline(0);
 Result.Pitch := FPitch;
 Result.Width := FWidth;
 Result.Height:= FHeight;
end;

//---------------------------------------------------------------------------
procedure TRawImage.AssignFrom(Source: TRawImage);
var
 j: Integer;
begin
 if (MemPtr = nil)or(FWidth <> Source.Width)or(FHeight <> Source.Height)or
  (FSafePx <> Source.SafePx)or(FBytesPerUnit <> Source.BytesPerUnit) then
  begin
   Release();

   FSafePx      := Source.SafePx;
   FBytesPerUnit:= Source.BytesPerUnit;
   Allocate(Source.Width, Source.Height);
  end;

 for j:= 0 to Source.ScanCount - 1 do
  Move(Source.ScanPtr[j]^, ScanPtr[j]^, Source.Pitch);
end;

//---------------------------------------------------------------------------
procedure TRawImage.CopyFrom(Source: TRawImage);
var
 j: Integer;
begin
 if (MemPtr = nil)or(FWidth <> Source.Width)or(FHeight <> Source.Height)or
  (FBytesPerUnit <> Source.BytesPerUnit) then
  begin
   Release();

   FBytesPerUnit:= Source.BytesPerUnit;
   Allocate(Source.Width, Source.Height);
  end;

 for j:= 0 to FHeight - 1 do
  Move(Source.Scanline[j]^, Scanline[j]^, FWidth * FBytesPerUnit);
end;

//---------------------------------------------------------------------------
procedure TRawImage.LoadFromBmp(Bitmap: TBitmap);
var
 i: Integer;
begin
 if (Bitmap.PixelFormat <> pf32bit) then Bitmap.PixelFormat:= pf32bit;
 FBytesPerUnit:= 4;

 Allocate(Bitmap.Width, Bitmap.Height);

 for i:= 0 to FHeight - 1 do
  Move(Bitmap.Scanline[i]^, Scanline[i]^, FWidth * FBytesPerUnit);
end;

//---------------------------------------------------------------------------
procedure TRawImage.SaveToBmp(Bitmap: TBitmap);
var
 i: Integer;
begin
 if (FBytesPerUnit <> 4)or(MemPtr = nil) then Exit;

 if (Bitmap.PixelFormat <> pf32bit) then Bitmap.PixelFormat:= pf32bit;
 if (Bitmap.Width <> FWidth) then Bitmap.Width:= FWidth;
 if (Bitmap.Height <> FHeight) then Bitmap.Height:= FHeight;

 for i:= 0 to FHeight - 1 do
  Move(Scanline[i]^, Bitmap.Scanline[i]^, FWidth * FBytesPerUnit);
end;

//---------------------------------------------------------------------------
// TRawImages
//
// This class implements and maintains a list of TRawImage classes.
//---------------------------------------------------------------------------
constructor TRawImages.Create();
begin
 inherited;

 SetLength(Data, 0);
end;

//---------------------------------------------------------------------------
destructor TRawImages.Destroy();
begin
 Clear();

 inherited;
end;

//---------------------------------------------------------------------------
function TRawImages.GetCount(): Integer;
begin
 Result:= Length(Data);
end;

//---------------------------------------------------------------------------
function TRawImages.GetItem(Num: Integer): TRawImage;
begin
 if (Num < 0)or(Num >= Length(Data)) then
  begin
   Result:= nil;
   Exit;
  end;

 Result:= Data[Num];
end;

//---------------------------------------------------------------------------
function TRawImages.Add(): Integer;
var
 Index: Integer;
begin
 Index:= Length(Data);
 SetLength(Data, Index + 1);

 Data[Index]:= TRawImage.Create();

 Result:= Index;
end;

//---------------------------------------------------------------------------
procedure TRawImages.Remove(Num: Integer);
var
 i: Integer;
begin
 if (Num < 0)or(Num >= Length(Data)) then Exit;

 Data[Num].Free();
 for i:= Num to Length(Data) - 2 do
  Data[i]:= Data[i + 1];

 SetLength(Data, Length(Data) - 1);
end;

//---------------------------------------------------------------------------
procedure TRawImages.Clear();
var
 i: Integer;
begin
 for i:= 0 to Length(Data) - 1 do
  if (Data[i] <> nil) then
   begin
    Data[i].Free();
    Data[i]:= nil;
   end;

 SetLength(Data, 0);   
end;

//---------------------------------------------------------------------------
function TRawImages.IndexOf(Image: TRawImage): Integer;
var
 i: Integer;
begin
 for i:= 0 to Length(Data) - 1 do
  if (Data[i] = Image) then
   begin
    Result:= i;
    Exit;
   end;

 Result:= -1;   
end;

//---------------------------------------------------------------------------
end.
