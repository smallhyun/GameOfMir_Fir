unit dlltools;

interface

uses Windows, Classes, Sysutils, imagehlp;

type
  TDLLExportCallback = function(const name: string; ordinal: Integer;
    address: Pointer): Boolean of object;
{ Note: address is a RVA here, not a usable virtual address! }
  DLLToolsError = class(Exception);
procedure ListDLLFunctions(DLLName: string; List: TStrings);
procedure ListDLLExports(const filename: string; List: TStrings; boLowerCase: Boolean = True);

procedure DumpExportDirectory(const ExportDirectory: TImageExportDirectory;
  lines: TStrings; const Image: LoadedImage);
function RVAToPchar(rva: DWORD; const Image: LoadedImage): PChar;
function RVAToPointer(rva: DWORD; const Image: LoadedImage): Pointer;
function IsDll(FileName: string): Boolean;
function IsPE(FileName: string): Boolean;
implementation

resourcestring
  eDLLNotFound =
    'ListDLLExports: DLL %s does not exist!';

procedure ListDLLFunctions(DLLName: string; List: TStrings);
type
  chararr = array[0..$FFFFFF] of char;
var
  h: THandle;
  i, fc: integer;
  st: string;
  arr: pointer;
  ImageDebugInformation: PImageDebugInformation;
begin
  List.Clear;
  DLLName := ExpandFileName(DLLName);
  if FileExists(DLLName) then begin
    h := CreateFile(PChar(DLLName),
      GENERIC_READ,
      FILE_SHARE_READ or FILE_SHARE_WRITE,
      nil,
      OPEN_EXISTING,
      FILE_ATTRIBUTE_NORMAL,
      0);
    if h <> INVALID_HANDLE_VALUE then
    try
      ImageDebugInformation := MapDebugInformation(h, PAnsiChar(DLLName), nil, 0);
      if ImageDebugInformation <> nil then
      try
        arr := ImageDebugInformation^.ExportedNames;
        fc := 0;
        for i := 0 to ImageDebugInformation^.ExportedNamesSize - 1 do
          if chararr(arr^)[i] = #0 then
          begin
            st := PAnsiChar(@chararr(arr^)[fc]);
            if length(st) > 0 then List.Add(st);
            if (i > 0) and (chararr(arr^)[i - 1] = #0) then Break;
            fc := i + 1;
          end;
      finally
        UnmapDebugInformation(ImageDebugInformation);
      end;
    finally
      CloseHandle(h);
    end;
  end;
end;

{function IsDll(FileName: string): Boolean;
var
  hFile: THandle;
  Mem: TMemoryStream;
  DosHeader: PImageDosHeader;
  NtHeader: PImageNtHeaders;
begin
  Result := False;
  if FileExists(filename) then begin
    Mem := TMemoryStream.Create;
    try
      Mem.LoadFromFile(FileName);
    except
      Mem.Free;
      Exit;
    end;
    DosHeader := PImageDosHeader(Mem.Memory);
    NtHeader := PImageNtHeaders(PChar(DosHeader) + DosHeader^._lfanew);
    Result := ((NtHeader^.FileHeader.Characteristics and IMAGE_FILE_DLL) = IMAGE_FILE_DLL);

    Mem.Free;
  end;
end;}

function IsDll(FileName: string): Boolean;
var
  hFile: THandle;
  Stream: TFileStream;
  DosHeader: TImageDosHeader;
  NtHeader: TImageNtHeaders;
begin
  Result := False;
  Stream := nil;
  if FileExists(filename) then begin
    try
      Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
    except
      if Stream <> nil then
        Stream.Free;
      Exit;
    end;
    Stream.Read(DosHeader, SizeOf(TImageDosHeader));
    Stream.Seek(SizeOf(TImageDosHeader) + DosHeader._lfanew, soBeginning);
    Stream.Read(NtHeader, SizeOf(TImageNtHeaders));
    Result := ((NtHeader.FileHeader.Characteristics and IMAGE_FILE_DLL) = IMAGE_FILE_DLL);
    Stream.Free;
  end;
end;

function IsPE(FileName: string): Boolean;
var
  hFile: THandle;
  Stream: TFileStream;
  DosHeader: TImageDosHeader;
  NtHeader: TImageNtHeaders;
begin
  Result := False;
  Stream := nil;
  if FileExists(filename) then begin
    try
      Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
    except
      if Stream <> nil then
        Stream.Free;
      Exit;
    end;
    Stream.Read(DosHeader, SizeOf(TImageDosHeader));

    if (DosHeader.e_magic = IMAGE_DOS_SIGNATURE) and (DosHeader._lfanew < Stream.Size) then begin
      Stream.Seek(SizeOf(TImageDosHeader) + DosHeader._lfanew, soBeginning);
      Stream.Read(NtHeader, SizeOf(TImageNtHeaders));
      Result := NtHeader.Signature = IMAGE_NT_SIGNATURE;
    end;
    Stream.Free;
  end;
end;
{+----------------------------------------------------------------------
| Procedure EnumExports
|
| Parameters :
| ExportDirectory: IMAGE_EXPORT_DIRECTORY record to enumerate
| image : LOADED_IMAGE record for the DLL the export directory belongs
| to.
| callback : callback function to hand the found exports to, must not be
Nil
| Description:
| The export directory of a PE image contains three RVAs that point at
tables
| which describe the exported functions. The first is an array of RVAs
that
| refer to the exported function names, these we translate to PChars to
| get the exported name. The second array is an array of Word that
contains
| the export ordinal for the matching entry in the names array. The
ordinal
| is biased, that is we have to add the ExportDirectory.Base value to it
to
| get the actual export ordinal. The biased ordinal serves as index for
the
| third array, which is an array of RVAs that give the position of the
| function code in the image. We don't translate these RVAs since the DLL
| is not relocated since we load it via MapAndLoad. The function array is
| usually much larger than the names array, since the ordinals for the
| exported functions do not have to be in sequence, there can be (and
| frequently are) gaps in the sequence, for which the matching entries in
the
| function RVA array are garbage.
| Error Conditions: none
| Created: 9.1.2000 by P. Below
+----------------------------------------------------------------------}

procedure EnumExports(const ExportDirectory: TImageExportDirectory;
  const image: LoadedImage;
  List: TStrings; boLowerCase: Boolean = True);
type
  TDWordArray = array[0..$FFFFF] of DWORD;
var
  i: Cardinal;
  pNameRVAs, pFunctionRVas: ^TDWordArray;
  pOrdinals: ^TWordArray;
  name: string;
  address: Pointer;
  ordinal: Word;
begin { EnumExports }
  pNameRVAs :=
    RVAToPointer(DWORD(ExportDirectory.AddressOfNames), image);
  pFunctionRVAs :=
    RVAToPointer(DWORD(ExportDirectory.AddressOfFunctions), image);
  pOrdinals :=
    RVAToPointer(DWORD(ExportDirectory.AddressOfNameOrdinals), image);
  for i := 0 to Pred(ExportDirectory.NumberOfNames) do begin
    name := RVAToPChar(pNameRVAs^[i], image);
    ordinal := pOrdinals^[i];
    address := Pointer(pFunctionRVAs^[ordinal]);
    if boLowerCase then
      List.AddObject(LowerCase(name), TObject(address))
    else
      List.AddObject(name, TObject(address))
    //if not callback(name, ordinal + ExportDirectory.Base, address) then
    //  Exit;
  end; { For }
end; { EnumExports }

{+----------------------------------------------------------------------
| Procedure ListDLLExports
|
| Parameters :
| filename : full pathname of DLL to examine
| callback : callback to hand the found exports to, must not be Nil
| Description:
| Loads the passed DLL using the LoadImage function, finds the exported
| names table and reads it. Each found entry is handed to the callback
| for further processing, until no more entries remain or the callback
| returns false. Note that the address passed to the callback for a
exported
| function is an RVA, so not identical to the address the function would
| have in a properly loaded and relocated DLL!
| Error Conditions:
| Exceptions are raised if
| - the passed DLL does not exist or could not be loaded
| - no callback was passed (only if assertions are on)
| - an API function failed
| Created: 9.1.2000 by P. Below
+----------------------------------------------------------------------}

procedure ListDLLExports(const filename: string; List: TStrings; boLowerCase: Boolean);
var
  imageinfo: LoadedImage;
  pExportDirectory: PImageExportDirectory;
  dirsize: Cardinal;
begin { ListDLLExports }
  List.Clear;
  try
    if MapAndLoad(PAnsiChar(filename), nil, @imageinfo, true, true) then begin
      try
        pExportDirectory :=
          ImageDirectoryEntryToData(
          imageinfo.MappedAddress, false,
          IMAGE_DIRECTORY_ENTRY_EXPORT, dirsize);

        if pExportDirectory = nil then
      //RaiseLastWin32Error
        else
          EnumExports(pExportDirectory^, imageinfo, List);
      finally
        UnMapAndLoad(@imageinfo);
      end;
    end;
  except

  end;
end; { ListDLLExports }

{+----------------------------------------------------------------------
| Procedure DumpExportDirectory
|
| Parameters :
| ExportDirectory: a IMAGE_EXPORT_DIRECTORY record
| lines : a TStrings descendend to put the info into, must not be Nil
| Description:
| Dumps the fields of the passed structure to the passed strings
descendent
| as strings.
| Error Conditions:
| will raise an exception if lines is Nil and assertions are enabled.
| Created: 9.1.2000 by P. Below
+----------------------------------------------------------------------}

procedure DumpExportDirectory(const ExportDirectory: TImageExportDirectory;
  lines: TStrings; const Image: LoadedImage);
begin { DumpExportDirectory }
  Assert(Assigned(lines));

  lines.add('Dump of IMAGE_EXPORT_DIRECTORY');
  lines.add(format('Characteristics: %d',
    [ExportDirectory.Characteristics]));
  lines.add(format('TimeDateStamp: %d',
    [ExportDirectory.TimeDateStamp]));
  lines.add(format('Version: %d.%d',
    [ExportDirectory.MajorVersion,
    ExportDirectory.MinorVersion]));
  lines.add(format('Name (RVA): %x',
    [ExportDirectory.Name]));
  lines.add(format('Name (translated): %s',
    [RVAToPchar(ExportDirectory.name, Image)]));
  lines.add(format('Base: %d',
    [ExportDirectory.Base]));
  lines.add(format('NumberOfFunctions: %d',
    [ExportDirectory.NumberOfFunctions]));
  lines.add(format('NumberOfNames: %d',
    [ExportDirectory.NumberOfNames]));
  lines.add(format('AddressOfFunctions (RVA): %p',
    [Pointer(ExportDirectory.AddressOfFunctions)]));
  lines.add(format('AddressOfNames (RVA): %p',
    [Pointer(ExportDirectory.AddressOfNames)]));
  lines.add(format('AddressOfNameOrdinals (RVA): %p',
    [Pointer(ExportDirectory.AddressOfNameOrdinals)]));
end; { DumpExportDirectory }

{+----------------------------------------------------------------------
| Function RVAToPointer
|
| Parameters :
| rva : a relative virtual address to translate
| Image : LOADED_IMAGE structure for the image the RVA relates to
| Returns : translated address
| Description:
| Uses the ImageRVAToVA function to translate the RVA to a virtual
| address.
| Error Conditions:
| Will raise an exception if the translation failed
| Created: 9.1.2000 by P. Below
+----------------------------------------------------------------------}

function RVAToPointer(rva: DWORD; const Image: LoadedImage): Pointer;
var
  pDummy: PImageSectionHeader;
begin { RVAToPchar }
  pDummy := nil;
  Result :=
    ImageRvaToVa(Image.FileHeader, Image.MappedAddress, rva,
    pDummy);
  if Result = nil then
    //RaiseLastWin32Error;
end; { RVAToPointer }

{+----------------------------------------------------------------------
| Function RVAToPchar
|
| Parameters :
| rva : a relative virtual address to translate
| Image : LOADED_IMAGE structure for the image the RVA relates to
| Returns : translated address
| Description:
| Uses the RVAToPointer function to translate the RVA to a virtual
| address. Note that we do not check that the address does indeed point
| to a zero-terminated string!
| Error Conditions:
| Will raise an exception if the translation failed
| Created: 9.1.2000 by P. Below
+----------------------------------------------------------------------}

function RVAToPchar(rva: DWORD; const Image: LoadedImage): PChar;
begin { RVAToPchar }
  Result := RVAToPointer(rva, image);
end; { RVAToPchar }

end.

