{*_* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       François PIETTE
Description:  TBuffer is an object wich buffers data in a single dynamically
              allocated memory block. It is a kind of FIFO wich manages
              characters in blocks of various sizes.
Creation:     April 1996
Version:      6.00c
EMail:        francois.piette@overbyte.be  http://www.overbyte.be
Support:      Use the mailing list twsocket@elists.org
              Follow "support" link at http://www.overbyte.be for subscription.
Legal issues: Copyright (C) 1996-2006 by François PIETTE
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

Updates:
Mar 06, 1998  V2.00 Added a property and a parameter for the create method
              to select the buffer size. Using a 0 value will make the object
              use the default 1514 bytes (the largest size for an ethernet
              packet).
Jul 08, 1998  V2.01 Adadpted for Delphi 4
Jan 19, 2003  V5.00 First pre-release for ICS-SSL. New major version number.
              Skipped version numbers to mach wsocket.pas major version number.
Apr 17, 2004  V6.00 New major release started. Move all platform and runtime
              dependencies to separate units. New base component for handling
              component with window handle.
Jan 26, 2004  V5.01 Use ICSDEFS.INC and reordered uses clause for FPC
              compatibility.
May 23, 2005  V6.00b Added BufUsed property.
Mar 25, 2006  V6.00c Fixed TBuffer.Write to correctly use the offset. Thanks
              to Frans van Daalen <ics@hedaal.nl> for providing a test case.


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit OverbyteIcsWSockBuf;

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

interface

uses
  OverbyteIcsTypes;

const
  WSockBufVersion    = 600;
  CopyRight : String = ' TWSockBuf (c) 1996-2006 Francois Piette V6.00c ';

type
{$IFDEF CLR}
  TWSocketData = TBytes;
{$ENDIF}
{$IFDEF WIN32}
  TWSocketData = type Pointer;
{$ENDIF}

  TBuffer = class(TObject)
    Buf      : TWSocketData;
    FBufSize : Integer;
    WrCount  : Integer;
    RdCount  : Integer;
    function GetBufUsed : Integer;
  public
    constructor Create(nSize : Integer); virtual;
    destructor  Destroy; override;
    function    Write(const Data : TWSocketData; Len : Integer) : Integer; overload;
    function    Write(const Data : TWSocketData; Offset : Integer; Len : Integer) : Integer; overload;
    function    Read(out Data : TWSocketData; Len : Integer) : Integer;
    function    Peek(var Len : Integer) : TWSocketData; overload;
    function    Peek(out Data : TWSocketData) : Integer; overload; 
    function    Remove(Len : Integer) : Integer;
    procedure   SetBufSize(newSize : Integer);
    property    BufSize : Integer read FBufSize write SetBufSize;
    property    BufUsed : Integer read GetBufUsed;
  end;

implementation


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TBuffer.Create(nSize : Integer);
begin
    inherited Create;
    WrCount  := 0;
    RdCount  := 0;
    BufSize := nSize;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TBuffer.Destroy;
begin
{$IFDEF WIN32}
    if Assigned(Buf) then
        FreeMem(Buf, FBufSize);
{$ENDIF}
    inherited Destroy;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TBuffer.SetBufSize(newSize : Integer);
{$IFDEF WIN32}
var
    newBuf : TWSocketData;
{$ENDIF}
begin
    if newSize <= 0 then
        newSize := 1514;

    if newSize = FBufSize then
        Exit;

{$IFDEF CLR}
    FBufSize := newSize;
    SetLength(Buf, FBufSize);
{$ENDIF}
{$IFDEF WIN32}
    if WrCount = RdCount then begin
        { Buffer is empty }
        if Assigned(Buf) then
            FreeMem(Buf, FBufSize);
        FBufSize := newSize;
        GetMem(Buf, FBufSize);
    end
    else begin
        { Buffer contains data }
        GetMem(newBuf, newSize);
        Move(Buf^, newBuf^, WrCount);
        if Assigned(Buf) then
            FreeMem(Buf, FBufSize);
        FBufSize := newSize;
        Buf      := newBuf;
    end;
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TBuffer.Write(const Data : TWSocketData; Len : Integer) : Integer;
begin
    Result := Write(Data, 0, Len);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TBuffer.Write(const Data: TWSocketData; Offset, Len: Integer): Integer;
var
    Remaining : Integer;
    Copied    : Integer;
{$IFDEF CLR}
    I         : Integer;
{$ENDIF}
begin
    Remaining := FBufSize - WrCount;
    if Remaining <= 0 then
        Result := 0
    else begin
        if Len <= Remaining then
            Copied := Len
        else
            Copied := Remaining;
{$IFDEF CLR}
        for I := 0 to Copied - 1 do
            Buf[WrCount + I] := Data[Offset + I];
{$ENDIF}
{$IFDEF WIN32}
        Move((PChar(Data) + Offset)^, (PChar(Buf) + WrCount)^, Copied);
{$ENDIF}
        WrCount := WrCount + Copied;
        Result  := Copied;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TBuffer.Read(out Data : TWSocketData; Len : Integer) : Integer;
var
    Remaining : Integer;
    Copied    : Integer;
{$IFDEF CLR}
    I         : Integer;
{$ENDIF}
begin
    Remaining := WrCount - RdCount;
    if Remaining <= 0 then
        Result := 0
    else begin
        if Len <= Remaining then
            Copied := Len
        else
            Copied := Remaining;
{$IFDEF CLR}
        for I := 0 to Copied - 1 do
            Data[I] := Buf[RdCount + I];
{$ENDIF}
{$IFDEF WIN32}
        Move((PChar(Buf) + RdCount)^, Data^, Copied);
{$ENDIF}
        RdCount := RdCount + Copied;

        if RdCount = WrCount then begin
            RdCount := 0;
            WrCount := 0;
        end;

        Result := Copied;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TBuffer.Peek(var Len : Integer) : TWSocketData;
var
    Remaining : Integer;
{$IFDEF CLR}
    I         : Integer;
{$ENDIF}
begin
    Remaining := WrCount - RdCount;
    if Remaining <= 0 then begin
        Len    := 0;
        Result := nil;
    end
    else begin
        Len    := Remaining;
{$IFDEF CLR}
        SetLength(Result, Len);
        for I := 0 to Len - 1 do
            Result[I] := Buf[I];
{$ENDIF}
{$IFDEF WIN32}
        Result := Pointer(PChar(Buf) + RdCount);
{$ENDIF}
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF WIN32}
function TBuffer.Peek(out Data: TWSocketData): Integer;
var
    Remaining : Integer;
begin
    Remaining := WrCount - RdCount;
    if Remaining <= 0 then begin
        Result := 0;
    end
    else begin
        Data := Pointer(PChar(Buf) + RdCount);
        Result := Remaining;
    end;
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF CLR}
function TBuffer.Peek(out Data: TWSocketData): Integer;
var
    Remaining : Integer;
    I         : Integer;
begin
    Remaining := WrCount - RdCount;
    if Remaining <= 0 then begin
        SetLength(Data, 0);
        Result := 0;
    end
    else begin
        // With .NET, we must copy the data
        SetLength(Data, Remaining);
        for I := 0 to Remaining - 1 do
            Data[I] := Buf[RdCount + I];
        Result := Remaining;
    end;
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TBuffer.Remove(Len : Integer) : Integer;
var
    Remaining : Integer;
    Removed   : Integer;
begin
    Remaining := WrCount - RdCount;
    if Remaining <= 0 then
        Result := 0
    else begin
        if Len < Remaining then
            Removed := Len
        else
            Removed := Remaining;
        RdCount := RdCount + Removed;

        if RdCount = WrCount then begin
            RdCount := 0;
            WrCount := 0;
        end;

        Result := Removed;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TBuffer.GetBufUsed: Integer;
begin
    Result := WrCount - RdCount;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

end.

