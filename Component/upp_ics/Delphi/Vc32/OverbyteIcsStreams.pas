{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       Arno Garrels <arno.garrels@gmx.de>
Creation:     Oct 25, 2005
Description:  Fast streams for ICS tested on D5 and D7.
Version:      6.00
Legal issues: Copyright (C) 2005 by Arno Garrels, Berlin, Germany,
              contact: <arno.garrels@gmx.de>
              
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

History:
Jan 05, 2006 V1.01 F. Piette added missing resourcestring for Delphi 6
Mar 26, 2006 V6.00 F. Piette started new version 6


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit OverbyteIcsStreams;

interface
{$Q-}           { Disable overflow checking           }
{$B-}           { Enable partial boolean evaluation   }
{$T-}           { Untyped pointers                    }
{$X+}           { Enable extended syntax              }
{$I OverbyteIcsDefs.inc}
{$IFDEF DELPHI6_UP}
    {$WARN SYMBOL_PLATFORM   OFF}
    {$WARN SYMBOL_LIBRARY    OFF}
    {$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}
{$IFNDEF VER80}   { Not for Delphi 1                    }
    {$H+}         { Use long strings                    }
    {$J+}         { Allow typed constant to be modified }
{$ENDIF}
{$IFDEF BCB3_UP}
    {$ObjExportAll On}
{$ENDIF}

uses
    Windows, SysUtils, Classes,
{$IFDEF COMPILER6_UP}
    RTLConsts
{$ELSE}
    Consts
{$ENDIF};

{$IFDEF DELPHI6}
resourcestring
  SFCreateErrorEx = 'Cannot create file "%s". %s';
  SFOpenErrorEx   = 'Cannot open file "%s". %s';
{$ENDIF}

const
    DEFAULT_BUFSIZE = 4096;
    MIN_BUFSIZE     = 512;
    MAX_BUFSIZE     = 1024 * 64;

type
    BigInt = {$IFDEF DELPHI6_UP} Int64 {$ELSE} Longint {$ENDIF};
    TBufferedFileStream = class(TStream)
    private
        FHandle     : Longint;
        FFileSize   : BigInt;
        FFileOffset : BigInt;
        FBuf        : PChar;
        FBufSize    : Longint;
        FBufCount   : Longint;
        FBufPos     : Longint;
        FDirty      : Boolean;

    protected
        procedure   SetSize(NewSize: Longint); override;
{$IFDEF DELPHI6_UP}
        procedure   SetSize(const NewSize: Int64); override;
{$ENDIF}
        function    GetFileSize: BigInt;
        procedure   Init(BufSize: Longint);
        procedure   ReadFromFile;
        procedure   WriteToFile;
    public
        constructor Create(const FileName: string; Mode: Word; BufferSize: LongInt);{$IFDEF DELPHI6_UP} overload; {$ENDIF}
{$IFDEF DELPHI6_UP}
        constructor Create(const FileName: string; Mode: Word; Rights: Cardinal; BufferSize: LongInt); overload;
{$ENDIF}
        destructor  Destroy; override;

        procedure   Flush;
        function    Read(var Buffer; Count: Longint): Longint; override;

        function    Seek(Offset: Longint; Origin: Word): Longint; override;
{$IFDEF DELPHI6_UP}
        function    Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
{$ENDIF}
        function    Write(const Buffer; Count: Longint): Longint; override;
        property    FastSize : BigInt read FFileSize;
    end;


implementation

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Min(IntOne, IntTwo: BigInt): BigInt;
begin
    if IntOne > IntTwo then
        Result := IntTwo
    else
        Result := IntOne;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TBufferedFileStream.Init(BufSize: Longint);
begin
    FBufSize := BufSize;
    if FBufSize < MIN_BUFSIZE then
        FBufsize := MIN_BUFSIZE
    else
    if FBufSize > MAX_BUFSIZE then
        FBufSize := MAX_BUFSIZE
    else
    if (FBufSize mod MIN_BUFSIZE) <> 0 then
        FBufSize := DEFAULT_BUFSIZE;
    GetMem(FBuf, FBufSize);
    FFileSize   := GetFileSize;
    FBufCount   := 0;
    FFileOffset := 0;
    FBufPos     := 0;
    FDirty      := False;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TBufferedFileStream.Create(const FileName: string; Mode: Word;
    BufferSize: LongInt);
begin
{$IFDEF DELPHI6_UP}
    Create(Filename, Mode, 0, BufferSize);
{$ELSE}
    inherited Create;
    FHandle := -1;
    FBuf    := nil;
    if Mode = fmCreate then
    begin
        FHandle := FileCreate(FileName);
        if FHandle < 0 then
            raise EFCreateError.CreateFmt(SFCreateError, [FileName]);
    end else
    begin
        FHandle := FileOpen(FileName, Mode);
        if FHandle < 0 then
            raise EFOpenError.CreateFmt(SFOpenError, [FileName]);
    end;
    Init(BufferSize);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF DELPHI6_UP}
constructor TBufferedFileStream.Create(const FileName : string; Mode: Word;
    Rights: Cardinal; BufferSize: LongInt);
begin
    inherited Create;
    FHandle := -1;
    FBuf    := nil;
    if Mode = fmCreate then
    begin
        FHandle := FileCreate(FileName, Rights);
        if FHandle < 0 then
            raise EFCreateError.CreateResFmt(@SFCreateErrorEx,
                                             [ExpandFileName(FileName),
                                             SysErrorMessage(GetLastError)]);
    end
    else begin
        FHandle := FileOpen(FileName, Mode);
        if FHandle < 0 then
            raise EFOpenError.CreateResFmt(@SFOpenErrorEx,
                                           [ExpandFileName(FileName),
                                           SysErrorMessage(GetLastError)]);
    end;
    Init(BufferSize);
end;
{$ENDIF}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TBufferedFileStream.Destroy;
begin
    if (FHandle >= 0) then
    begin
        if FDirty then
            WriteToFile;
        FileClose(FHandle);
    end;
    if FBuf <> nil then
        FreeMem(FBuf, FBufSize);
    inherited Destroy;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TBufferedFileStream.GetFileSize: BigInt;
var
    OldPos : BigInt;
begin
    OldPos := FileSeek(FHandle,
                      {$IFDEF DELPHI6_UP}Int64(0){$ELSE} 0 {$ENDIF},
                      soFromCurrent);
    Result := FileSeek(FHandle,
                      {$IFDEF DELPHI6_UP}Int64(0){$ELSE}0{$ENDIF},
                      soFromEnd);
    FileSeek(FHandle, OldPos, soFromBeginning);
    if Result < 0 then
        raise Exception.Create('Cannot determine correct file size');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TBufferedFileStream.ReadFromFile;
var
    NewPos : BigInt;
begin
    NewPos := FileSeek(FHandle, FFileOffset, soFromBeginning);
    if (NewPos <> FFileOffset) then
        raise Exception.Create('Seek before read from file failed');
    FBufCount := FileRead(FHandle, FBuf^, FBufSize);
    if FBufCount = -1 then
        FBufCount := 0;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TBufferedFileStream.WriteToFile;
var
    NewPos : BigInt;
    BytesWritten : Longint;
begin
    NewPos := FileSeek(FHandle, FFileOffset, soFromBeginning);
    if (NewPos <> FFileOffset) then
        raise Exception.Create('Seek before write to file failed');
    BytesWritten := FileWrite(FHandle, FBuf^, FBufCount);
    if (BytesWritten <> FBufCount) then
        raise Exception.Create('Could not write to file');
    FDirty := False;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TBufferedFileStream.Flush;
begin
    if FDirty and (FHandle >= 0) and (FBuf <> nil) then
        WriteToFile;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TBufferedFileStream.Read(var Buffer; Count: Longint): Longint;
var
    Remaining   : Longint;
    Copied      : Longint;
    DestPos     : Longint;
begin
    Result := 0;
    if FHandle < 0 then Exit;
    Remaining := Min(Count, FFileSize - (FFileOffset + FBufPos));
    Result := Remaining;
    if (Remaining > 0) then
    begin
        if (FBufCount = 0) then
            ReadFromFile;
        Copied := Min(Remaining, FBufCount - FBufPos);
        Move(FBuf[FBufPos], TByteArray(Buffer)[0], Copied);
        Inc(FBufPos, Copied);
        Dec(Remaining, Copied);
        DestPos := 0;
        while Remaining > 0 do
        begin
            if FDirty then
                WriteToFile;
            FBufPos := 0;
            Inc(FFileOffset, FBufSize);
            ReadFromFile;
            Inc(DestPos, Copied);
            Copied := Min(Remaining, FBufCount - FBufPos);
            Move(FBuf[FBufPos], TByteArray(Buffer)[DestPos], Copied);
            Inc(FBufPos, Copied);
            Dec(Remaining, Copied);
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TBufferedFileStream.Write(const Buffer; Count: Longint): Longint;
var
    Remaining : Longint;
    Copied    : Longint;
    DestPos   : Longint;
begin
    Result := 0;
    if FHandle < 0 then Exit;
    Remaining := Count;
    Result := Remaining;
    if (Remaining > 0) then
    begin
        if (FBufCount = 0) and ((FFileOffset + FBufPos) <= FFileSize) then
            ReadFromFile;
        Copied := Min(Remaining, FBufSize - FBufPos);
        Move(PChar(Buffer), FBuf[FBufPos], Copied);
        FDirty := True;
        Inc(FBufPos, Copied);
        if (FBufCount < FBufPos) then
        begin
            FBufCount := FBufPos;
            FFileSize := FFileOffset + FBufPos;
        end;
        Dec(Remaining, Copied);
        DestPos := 0;
        while Remaining > 0 do
        begin
            WriteToFile;
            FBufPos := 0;
            Inc(FFileOffset, FBufSize);
            if (FFileOffset < FFileSize) then
                ReadFromFile
            else
                FBufCount := 0;
            Inc(DestPos, Copied);
            Copied := Min(Remaining, FBufSize - FBufPos);
            Move(TByteArray(Buffer)[DestPos], FBuf[0], Copied);
            FDirty := True;
            Inc(FBufPos, Copied);
            if (FBufCount < FBufPos) then
            begin
                FBufCount := FBufPos;
                FFileSize := FFileOffset + FBufPos;
            end;
            Dec(Remaining, Copied);
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TBufferedFileStream.Seek(Offset: Longint; Origin: Word): Longint;
{$IFNDEF DELPHI6_UP}
var
    NewPos    : Longint;
    NewOffset : Longint;
{$ENDIF}
begin
{$IFDEF DELPHI6_UP}
    Result := Seek(Int64(Offset), TSeekOrigin(Origin));
{$ELSE}
    Result := 0;
    if FHandle < 0 then Exit;
    if (Offset = 0) and (Origin = soFromCurrent) then
    begin
        Result := FFileOffset + FBufPos;
        Exit;
    end;

    case Origin of
        soFromBeginning : NewPos := Offset;
        soFromCurrent   : NewPos := (FFileOffset + FBufPos) + Offset;
        soFromEnd       : NewPos := FFileSize + Offset;
      else
        raise Exception.Create('Invalid seek origin');
    end;

    if (NewPos < 0) then
        NewPos := 0
    else
    if (NewPos > FFileSize) then
        FFileSize := FileSeek(FHandle, NewPos - FFileSize, soFromEnd);

    NewOffset := (NewPos div FBufSize) * FBufSize;

    if (NewOffset <> FFileOffset) then
    begin
        if FDirty then
            WriteToFile;
        FFileOffset := NewOffset;
        FBufCount := 0;
    end;
    FBufPos := NewPos - FFileOffset;
    Result  := NewPos;
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF DELPHI6_UP}
function TBufferedFileStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
var
    NewPos        : BigInt;
    NewFileOffset : BigInt;
begin
    Result := 0;
    if FHandle < 0 then Exit;

    if (Offset = 0) and (Origin = soCurrent) then
    begin
        Result := FFileOffset + FBufPos;
        Exit;
    end;

    case Origin of
        soBeginning : NewPos := Offset;
        soCurrent   : NewPos := (FFileOffset + FBufPos) + Offset;
        soEnd       : NewPos := FFileSize + Offset;
      else
        raise Exception.Create('Invalid seek origin');
    end;

    if (NewPos < 0) then
        NewPos := 0
    else
    if (NewPos > FFileSize) then
        FFileSize := FileSeek(FHandle, NewPos - FFileSize, soFromEnd);

    NewFileOffset := (NewPos div FBufSize) * FBufSize;

    if (NewFileOffset <> FFileOffset) then
    begin
        if FDirty then
            WriteToFile;
        FFileOffset := NewFileOffset;
        FBufCount := 0;
    end;
    FBufPos := NewPos - FFileOffset;
    Result  := NewPos;
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TBufferedFileStream.SetSize(NewSize: Integer);
begin
{$IFDEF DELPHI6_UP}
    SetSize(Int64(NewSize));
{$ELSE}
    if FHandle < 0 then Exit;
    Seek(NewSize, soFromBeginning);
    if NewSize < FFileSize then
        FFileSize := FileSeek(FHandle, NewSize, soFromBeginning);
    if not SetEndOfFile(FHandle) then
        RaiseLastWin32Error;
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF DELPHI6_UP}
procedure TBufferedFileStream.SetSize(const NewSize: Int64);
begin
    if FHandle < 0 then Exit;
    Seek(NewSize, soFromBeginning);
    if NewSize < FFileSize then
        FFileSize := FileSeek(FHandle, NewSize, soFromBeginning);
{$IFDEF MSWINDOWS}
    if not SetEndOfFile(FHandle) then
        RaiseLastOSError;
{$ELSE}
    if ftruncate(FHandle, Position) = -1 then
        raise EStreamError(sStreamSetSize);
{$ENDIF}
end;
{$ENDIF}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
end.
