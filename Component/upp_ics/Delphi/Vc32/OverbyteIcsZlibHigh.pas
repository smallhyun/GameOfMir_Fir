{*_* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       Angus Robertson, Magenta Systems Ltd
Creation:     15 December 2005
Version:      6.00
Description:  High level functions for ZLIB compression and decompression
Credit:       Based on work by Gabriel Corneanu <gabrielcorneanu(AT)yahoo.com>
              Derived from original sources by Bob Dellaca and Cosmin Truta.
              ZLIB is Copyright (C) 1995-2005 Jean-loup Gailly and Mark Adler
EMail:        francois.piette@overbyte.be      http://www.overbyte.be
Support:      Use the mailing list twsocket@elists.org
              Follow "support" link at http://www.overbyte.be for subscription.
Legal issues: Copyright (C) 2004-2006 by François PIETTE
              Rue de Grady 24, 4053 Embourg, Belgium. Fax: +32-4-365.74.56
              <francois.piette@overbyte.be>

              This software is provided 'as-is', without any express or
              implied warranty.  In no event will the author be held liable
              for any  damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.

              4. You must register this software by sending a picture postcard
                 to the author. Use a nice stamp and mention your name, street
                 address, EMail address and any comment you like to say.

History:
Mar 26, 2006 V6.00 F. Piette started new version 6


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit OverbyteIcsZlibHigh;

interface

{$R-}
{$Q-}
{$I OverbyteIcsDefs.inc}
{$I OverbyteIcsZlib.inc}

uses
    SysUtils, Classes,
{$IFDEF USE_ZLIB_OBJ}
    OverbyteIcsZLibObj;             {interface to access ZLIB C OBJ files}
{$ELSE}
    IcsZLibDll;                     {interface to access zLib1.dll}
{$ENDIF}


const
  WindowSize = 1 shl MAX_WBITS;

type
  PZBack = ^TZBack;
  TZBack = record
    InStream  : TStream;
    OutStream : TStream;
    InMem     : PChar; //direct memory access
    InMemSize : integer;
    ReadBuf   : array[word] of char;
    Window    : array[0..WindowSize] of char;
    MainObj   : TObject; // Angus
  end;

type
  EZlibError = class(Exception);
  ECompressionError = class(EZlibError);
  EDecompressionError = class(EZlibError);

  TCompressionLevel = (clNone, clFastest, clDefault, clMax);

const
  Levels: array [TCompressionLevel] of ShortInt =
    (Z_NO_COMPRESSION, Z_BEST_SPEED, Z_DEFAULT_COMPRESSION, Z_BEST_COMPRESSION);

function ZlibGetDllLoaded: boolean ;
function ZlibGetVersionDll: string ;
function ZlibCCheck(code: Integer): Integer;
function ZlibDCheck(code: Integer): Integer;
procedure ZlibDecompressStream(InStream, OutStream: TStream);
procedure ZlibCompressStreamEx(InStream, OutStream: TStream; Level:
     TCompressionLevel; StreamType : TZStreamType; UseDirectOut: boolean);
function ZlibCheckInitInflateStream (var strm: TZStreamRec;
                                    gzheader: gz_headerp): TZStreamType;
function Strm_in_func(BackObj: PZBack; var buf: PByte): Integer; cdecl;
function Strm_out_func(BackObj: PZBack; buf: PByte; size: Integer): Integer; cdecl;
function DMAOfStream(AStream: TStream; out Available: integer): Pointer;


implementation

function ZlibGetDllLoaded: boolean ;
begin
    result := ZlibDllLoaded ;
end ;

function ZlibGetVersionDll: string ;
begin
    result := zlibVersionDll ;
end ;

function ZlibCCheck(code: Integer): Integer;
begin
  Result := code;
  if code < 0 then
    raise ECompressionError.Create('error' + IntToStr (code));  //!! angus added code
end;

function ZlibDCheck(code: Integer): Integer;
begin
  Result := code;
  if code < 0 then
    raise EDecompressionError.Create('error ' + IntToStr (code));  //!! angus added code
end;

function DMAOfStream(AStream: TStream; out Available: integer): Pointer;
begin
  if AStream.inheritsFrom(TCustomMemoryStream) then
    Result := TCustomMemoryStream(AStream).Memory
  else if AStream.inheritsFrom(TStringStream) then
    Result := Pointer(TStringStream(AStream).DataString)
  else
    Result := nil;
  if Result <> nil then
  begin
    //what if integer overflow?
    Available := AStream.Size - AStream.Position;
    Inc(Integer(Result), AStream.Position);
  end
  else Available := 0;
end;

function CanResizeDMAStream(AStream: TStream): boolean;
begin
  Result := AStream.inheritsFrom(TMemoryStream) or
            AStream.inheritsFrom(TStringStream);
end;

//tries to get the stream info
//strm.next_in and available_in needs enough data!
//strm should not contain an initialized inflate

function ZlibCheckInitInflateStream (var strm: TZStreamRec;
                                    gzheader: gz_headerp): TZStreamType;
var
  InitBuf: PChar;
  InitIn : integer;

  function TryStreamType(AStreamType: TZStreamType): boolean;
  begin
    ZlibDCheck(inflateInitEx(strm, AStreamType));

    if (AStreamType = zsGZip) and (gzheader <> nil) then
                  ZlibDCheck(inflateGetHeader(strm, gzheader^));

    Result := inflate(strm, Z_BLOCK) = Z_OK;
    ZlibDCheck(inflateEnd(strm));

    if Result then exit;
    //rollback
    strm.next_in  := InitBuf;
    strm.avail_in := InitIn;
  end;

begin
  if strm.next_out = nil then
    //needed for reading, but not used
    strm.next_out := strm.next_in;

  try
    InitBuf := strm.next_in;
    InitIn  := strm.avail_in;
    for Result := zsZLib to zsGZip do
      if TryStreamType(Result) then exit;
    Result := zsRaw;
  finally

  end;
end;

function Strm_in_func(BackObj: PZBack; var buf: PByte): Integer; cdecl;
var
  S : TStream;
begin
  S := BackObj.InStream; //help optimizations
  if BackObj.InMem <> nil then
  begin
    //direct memory access if available!
    buf := Pointer(BackObj.InMem);
    //what if integer overflow?
    Result := S.Size - S.Position;
    S.Seek(Result, soFromCurrent);
  end
  else
  begin
    buf    := @BackObj.ReadBuf;
    Result := S.Read(buf^, SizeOf(BackObj.ReadBuf));
  end;
end;

function Strm_out_func(BackObj: PZBack; buf: PByte; size: Integer): Integer; cdecl;
begin
  Result := BackObj.OutStream.Write(buf^, size) - size;
end;

procedure ZlibDecompressStream(InStream, OutStream: TStream);
var
  strm   : z_stream;
  BackObj: PZBack;
begin
  FillChar(strm, sizeof(strm), 0);
  GetMem(BackObj, SizeOf(BackObj^));
  try
    //direct memory access if possible!
    BackObj.InMem := DMAOfStream(InStream, BackObj.InMemSize);

    BackObj.InStream  := InStream;
    BackObj.OutStream := OutStream;

    //use our own function for reading
    strm.avail_in := Strm_in_func(BackObj, PByte(strm.next_in));
    strm.next_out := @BackObj.Window;
    strm.avail_out := 0;

    ZlibCheckInitInflateStream(strm, nil);

    strm.next_out := nil;
    strm.avail_out := 0;
    ZlibDCheck(inflateBackInit(strm, MAX_WBITS, BackObj.Window));
    try
      ZlibDCheck(inflateBack(strm, @Strm_in_func, BackObj, @Strm_out_func, BackObj));
      //seek back when unused data
      InStream.Seek(-strm.avail_in, soFromCurrent);
      //now trailer can be checked
    finally
      ZlibDCheck(inflateBackEnd(strm));
    end;
  finally
    FreeMem(BackObj);
  end;
end;

type
  TMemStreamHack = class(TMemoryStream);

function ExpandStream(AStream: TStream; const ACapacity : Int64): boolean;
begin
  Result := true;
  AStream.Size := ACapacity;
  if AStream.InheritsFrom(TMemoryStream) then
    AStream.Size := TMemStreamHack(AStream).Capacity;
end;

procedure ZlibCompressStreamEx(InStream, OutStream: TStream; Level:
     TCompressionLevel; StreamType : TZStreamType; UseDirectOut: boolean);
const
  //64 KB buffer
  BufSize = 65536;
var
  strm   : z_stream;
  InBuf, OutBuf : PChar;
  UseInBuf, UseOutBuf : boolean;
  LastOutCount : integer;
  Finished : boolean;

  procedure WriteOut;
  begin
    if UseOutBuf then
    begin
      if LastOutCount > 0 then OutStream.Write(OutBuf^, LastOutCount - strm.avail_out);
      strm.avail_out := BufSize;
      strm.next_out  := OutBuf;
    end
    else
    begin
      if (strm.avail_out = 0) then ExpandStream(OutStream, OutStream.Size + BufSize);
      OutStream.Seek(LastOutCount - strm.avail_out, soFromCurrent);
      strm.next_out  := DMAOfStream(OutStream, strm.avail_out);
      //because we can't really know how much resize is increasing!
    end;
    LastOutCount := strm.avail_out;
  end;

begin
  FillChar(strm, sizeof(strm), 0);

  InBuf          := nil;
  OutBuf         := nil;
  LastOutCount   := 0;

  strm.next_in   := DMAOfStream(InStream, strm.avail_in);
  UseInBuf := strm.next_in = nil;

  if UseInBuf then
    GetMem(InBuf, BufSize);

  UseOutBuf := not (UseDirectOut and CanResizeDMAStream(OutStream));
  if UseOutBuf then GetMem(OutBuf, BufSize);

  ZlibCCheck(deflateInitEx(strm, Levels[level], StreamType));
  try
    repeat
      if strm.avail_in = 0 then
      begin
        if UseInBuf then
        begin
          strm.avail_in := InStream.Read(InBuf^, BufSize);
          strm.next_in  := InBuf;
        end;
        if strm.avail_in = 0 then break;
      end;
      if strm.avail_out = 0 then WriteOut;

      ZlibCCheck(deflate(strm, Z_NO_FLUSH));
    until false;

    repeat
      if strm.avail_out = 0 then WriteOut;
      Finished := ZlibCCheck(deflate(strm, Z_FINISH)) = Z_STREAM_END;
      WriteOut;
    until Finished;

    if not UseOutBuf then
    begin
      //truncate when using direct output
      OutStream.Size := OutStream.Position;
    end;

    //adjust position of the input stream
    if UseInBuf then
      //seek back when unused data
      InStream.Seek(-strm.avail_in, soFromCurrent)
    else
      //simple seek
      InStream.Seek(strm.total_in, soFromCurrent);

    ZlibCCheck(deflateEnd(strm));
  finally
    if InBuf <> nil then FreeMem(InBuf);
    if OutBuf <> nil then FreeMem(OutBuf);
  end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

end.
