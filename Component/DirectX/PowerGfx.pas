unit PowerGfx;
//---------------------------------------------------------------------------
// PowerDraw - device generalization                     Revised: 12-Feb-2005
// Written by Yuriy Kotsarenko (lifepower@mail333.com)            Version 1.0
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
 Types, Classes, AsphyreDef, AsphyreDev, AsphyreDev2, AsphyreDev3, AsphyreDevGDI,
 AsphyreImg, AsphyreFonts, VTDb3;

//---------------------------------------------------------------------------
type
 TRenderingMode = (rmDirect3D, rmSoftware, rmSoftGDI);
//---------------------------------------------------------------------------
 TPowerDraw = class(TComponent)
 private
  // currently active device
  FDevice  : TAsphyreDevice;
  // rendering mode (defines which device to use)
  FMode    : TRenderingMode;
  // DirectDraw / Software device
  FDevice2 : TAsphyreDevice2;
  // Direct3D device
  FDevice3 : TAsphyreDevice3;
  // GDI / Software device
  FDeviceGDI : TAsphyreDeviceGDI;

  // Device Parameters
  FVSync        : Boolean;
  FWindowed     : Boolean;
  FRefreshRate  : Integer;
  FHeight       : Integer;
  FWidth        : Integer;
  FBBufferCount : Integer;
  FBitDepth     : TBitDepth;

  // Device Events
  FOnInitDevice: TDeviceInitEvent;
  FOnInitialize: TDeviceInitEvent;
  FOnFinalize: TNotifyEvent;
  FOnDeviceLost: TNotifyEvent;
  FOnDoneDevice: TNotifyEvent;
  FDeviceActive: Boolean;
  FInitialized: Boolean;

  FFonts : TAsphyreFonts;
  FImages: TAsphyreImages;

  procedure SetMode(const Value: TRenderingMode);
  procedure SetBBufferCount(const Value: Integer);
  procedure SetBitDepth(const Value: TBitDepth);
  procedure SetHeight(const Value: Integer);
  procedure SetRefreshRate(const Value: Integer);
  procedure SetVSync(const Value: Boolean);
  procedure SetWidth(const Value: Integer);
  procedure SetWindowed(const Value: Boolean);
  procedure SetFonts(const Value: TAsphyreFonts);
  procedure SetImages(const Value: TAsphyreImages);
 protected
  procedure DevInitialize(Sender: TObject; var ExitCode: Integer); virtual;
  procedure DevFinalize(Sender: TObject); virtual;
  procedure DevInitDevice(Sender: TObject; var ExitCode: Integer); virtual;
  procedure DevDoneDevice(Sender: TObject); virtual;
  procedure DevDeviceLost(Sender: TObject); virtual;

  procedure Notification(AComponent: TComponent; Operation: TOperation); override;
 public
  property Initialized : Boolean read FInitialized;
  property DeviceActive: Boolean read FDeviceActive;
  property Device : TAsphyreDevice read FDevice;

  function Initialize(): Integer;
  function Finalize(): Integer;
  function InitDevice(): Integer;
  function DoneDevice(): Integer;

  constructor Create(AOwner: TComponent); override;
 published
  property Mode   : TRenderingMode read FMode write SetMode;
  property Images : TAsphyreImages read FImages write SetImages;
  property Fonts  : TAsphyreFonts read FFonts write SetFonts;

  // Device Paramters
  property Width          : Integer read FWidth write SetWidth;
  property Height         : Integer read FHeight write SetHeight;
  property Windowed       : Boolean read FWindowed write SetWindowed;
  property VSync          : Boolean read FVSync write SetVSync;
  property RefreshRate    : Integer read FRefreshRate write SetRefreshRate;
  property BitDepth       : TBitDepth read FBitDepth write SetBitDepth;
  property BackBufferCount: Integer read FBBufferCount write SetBBufferCount;

  // Device Events
  property OnInitialize   : TDeviceInitEvent read FOnInitialize write FOnInitialize;
  property OnFinalize     : TNotifyEvent read FOnFinalize write FOnFinalize;
  property OnInitDevice   : TDeviceInitEvent read FOnInitDevice write FOnInitDevice;
  property OnDoneDevice   : TNotifyEvent read FOnDoneDevice write FOnDoneDevice;
  property OnDeviceLost   : TNotifyEvent read FOnDeviceLost write FOnDeviceLost;
 end;


//---------------------------------------------------------------------------
implementation
uses
 SysUtils, Forms;

//---------------------------------------------------------------------------
constructor TPowerDraw.Create(AOwner: TComponent);
var
 Index: Integer;
begin
 inherited;

 // initial flags
 FInitialized := False;
 FDeviceActive:= False;

 if (not (AOwner is TForm)) then
  raise Exception.Create('This component must be dropped onto the form!');

 // setup Device2
 FDevice2:= TAsphyreDevice2.Create(Self);
 FDevice2.MainForm:= TForm(AOwner);
 FDevice2.OnInitialize:= DevInitialize;
 FDevice2.OnFinalize  := DevFinalize;
 FDevice2.OnInitDevice:= DevInitDevice;
 FDevice2.OnDoneDevice:= DevDoneDevice;
 FDevice2.OnDeviceLost:= DevDeviceLost;

 // setup Device3
 FDevice3:= TAsphyreDevice3.Create(Self);
 FDevice3.MainForm:= TForm(AOwner);
 FDevice3.OnInitialize:= DevInitialize;
 FDevice3.OnFinalize  := DevFinalize;
 FDevice3.OnInitDevice:= DevInitDevice;
 FDevice3.OnDoneDevice:= DevDoneDevice;
 FDevice3.OnDeviceLost:= DevDeviceLost;

 // setup DeviceGDI
 FDeviceGDI:= TAsphyreDeviceGDI.Create(Self);
 FDeviceGDI.MainForm:= TForm(AOwner);
 FDeviceGDI.OnInitialize:= DevInitialize;
 FDeviceGDI.OnFinalize  := DevFinalize;
 FDeviceGDI.OnInitDevice:= DevInitDevice;
 FDeviceGDI.OnDoneDevice:= DevDoneDevice;

 // default mode: Direct3D
 Mode:= rmDirect3D;

 // set default device parameters
 VSync          := False;
 Windowed       := True;
 RefreshRate    := 0;
 Width          := 640;
 Height         := 480;
 BackBufferCount:= 1;
 BitDepth       := bdDefault;

 // no initial events
 FOnInitDevice := nil;
 FOnInitialize := nil;
 FOnFinalize   := nil;
 FOnDeviceLost := nil;
 FOnDoneDevice := nil;

 FImages := nil;
 FFonts  := nil;

 // search for existing images or fonts
 if (csDesigning in ComponentState)and(Assigned(AOwner)) then
  for Index:= 0 to AOwner.ComponentCount - 1 do
   begin
    if (AOwner.Components[Index] is TAsphyreImages) then
     Images:= TAsphyreImages(AOwner.Components[Index]);

    if (AOwner.Components[Index] is TAsphyreFonts) then
     Fonts:= TAsphyreFonts(AOwner.Components[Index]);
   end;
end;

//---------------------------------------------------------------------------
procedure TPowerDraw.Notification(AComponent: TComponent; Operation: TOperation);
begin
 inherited;

 case Operation of
  opInsert:
   begin
    if (AComponent is TAsphyreImages)and(not Assigned(Images)) then
     Images:= TAsphyreImages(AComponent);

    if (AComponent is TAsphyreFonts)and(not Assigned(Fonts)) then
     Fonts:= TAsphyreFonts(AComponent);
   end;

  opRemove:
   begin
    if (AComponent is TAsphyreImages)and(AComponent = Images) then FImages:= nil;
    if (AComponent is TAsphyreFonts)and(AComponent = Fonts) then FFonts:= nil;
   end;
 end;
end;

//---------------------------------------------------------------------------
procedure TPowerDraw.SetBBufferCount(const Value: Integer);
begin
 FBBufferCount:= Value;
 FDevice2.BackBufferCount:= Value;
 FDevice3.BackBufferCount:= Value;
 FDeviceGDI.BackBufferCount:= Value;
end;

//---------------------------------------------------------------------------
procedure TPowerDraw.SetBitDepth(const Value: TBitDepth);
begin
 FBitDepth:= Value;
 FDevice2.BitDepth:= Value;
 FDevice3.BitDepth:= Value;
 FDeviceGDI.BitDepth:= Value;
end;

//---------------------------------------------------------------------------
procedure TPowerDraw.SetWidth(const Value: Integer);
begin
 FWidth:= Value;
 FDevice2.Width:= Value;
 FDevice3.Width:= Value;
 FDeviceGDI.Width:= Value;
end;

//---------------------------------------------------------------------------
procedure TPowerDraw.SetHeight(const Value: Integer);
begin
 FHeight:= Value;
 FDevice2.Height:= Value;
 FDevice3.Height:= Value;
 FDeviceGDI.Height:= Value;
end;

//---------------------------------------------------------------------------
procedure TPowerDraw.SetRefreshRate(const Value: Integer);
begin
 FRefreshRate:= Value;
 FDevice2.RefreshRate:= Value;
 FDevice3.RefreshRate:= Value;
 FDeviceGDI.RefreshRate:= Value;
end;

//---------------------------------------------------------------------------
procedure TPowerDraw.SetVSync(const Value: Boolean);
begin
 FVSync:= Value;
 FDevice2.VSync:= Value;
 FDevice3.VSync:= Value;
 FDeviceGDI.VSync:= Value;
end;

//---------------------------------------------------------------------------
procedure TPowerDraw.SetWindowed(const Value: Boolean);
begin
 FWindowed:= Value;
 FDevice2.Windowed:= Value;
 FDevice3.Windowed:= Value;
 FDeviceGDI.Windowed:= Value;
end;

//---------------------------------------------------------------------------
procedure TPowerDraw.SetMode(const Value: TRenderingMode);
var
 BeenActive, BeenInit: Boolean;
 Res: Integer;
begin
 // 1. save previous state
 BeenInit  := FInitialized;
 BeenActive:= FDeviceActive;

 // 2. finalize all initialized devices
 if (FInitialized) then Finalize();

 // 3. change the state
 FMode:= Value;
 case FMode of
  rmDirect3D: FDevice:= FDevice3;
  rmSoftGDI : FDevice:= FDeviceGDI;
  else FDevice:= FDevice2;
 end;

 // 4. update images and/or fonts
 if (csDesigning in ComponentState) then
  begin
   if (Assigned(FImages)) then FImages.Device:= nil;
   if (Assigned(FFonts)) then FFonts.Device:= nil;
  end else
  begin
   if (Assigned(FImages)) then FImages.Device:= FDevice;
   if (Assigned(FFonts)) then FFonts.Device:= FDevice;
  end;

 // 5. restore to previous state
 if (BeenInit) then
  begin
   Res:= Initialize();
   if (Res = errNone)and(BeenActive) then Res:= InitDevice();

   if (Res <> errNone) then
    begin
     Finalize();
     raise Exception.Create(ErrorString(Res));
    end;
  end;
end;

//---------------------------------------------------------------------------
procedure TPowerDraw.DevInitialize(Sender: TObject; var ExitCode: Integer);
begin
 if (Assigned(FOnInitialize)) then
  FOnInitialize(Sender, ExitCode);
end;

//---------------------------------------------------------------------------
procedure TPowerDraw.DevFinalize(Sender: TObject);
begin
 if (Assigned(FOnFinalize)) then
  FOnFinalize(Sender);
end;

//---------------------------------------------------------------------------
procedure TPowerDraw.DevInitDevice(Sender: TObject; var ExitCode: Integer);
begin
 if (Assigned(FOnInitDevice)) then
  FOnInitDevice(Sender, ExitCode);
end;

//---------------------------------------------------------------------------
procedure TPowerDraw.DevDoneDevice(Sender: TObject);
begin
 if (Assigned(FOnDoneDevice)) then
  FOnDoneDevice(Sender);
end;

//---------------------------------------------------------------------------
procedure TPowerDraw.DevDeviceLost(Sender: TObject);
begin
 if (Assigned(FOnDeviceLost)) then
  FOnDeviceLost(Sender);
end;

//---------------------------------------------------------------------------
function TPowerDraw.Initialize(): Integer;
begin
 Result:= FDevice.Initialize();
 FInitialized:= (Result = errNone);
end;

//---------------------------------------------------------------------------
function TPowerDraw.Finalize(): Integer;
begin
 Result:= FDevice.Finalize();
 FInitialized:= False;
end;

//---------------------------------------------------------------------------
function TPowerDraw.InitDevice(): Integer;
begin
 Result:= FDevice.InitDevice();
 FDeviceActive:= (Result = errNone);
end;

//---------------------------------------------------------------------------
function TPowerDraw.DoneDevice(): Integer;
begin
 Result:= FDevice.DoneDevice();
 FDeviceActive:= False;
end;

//---------------------------------------------------------------------------
procedure TPowerDraw.SetFonts(const Value: TAsphyreFonts);
begin
 FFonts:= Value;
 if (Assigned(FFonts))and(not (csDesigning in ComponentState)) then FFonts.Device:= FDevice;
end;

//---------------------------------------------------------------------------
procedure TPowerDraw.SetImages(const Value: TAsphyreImages);
begin
 FImages:= Value;
 if (Assigned(FImages))and(not (csDesigning in ComponentState)) then FImages.Device:= FDevice;
end;

//---------------------------------------------------------------------------
end.

