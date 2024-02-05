unit Resizer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus;

const
  GRIDDEFAULT = 4;

type
  TResizer = class;
  TMover = class;

  TMovingEvent = procedure(Sender: TResizer; var NewLeft, NewTop: integer) of object;
  TSizingEvent = procedure(Sender: TResizer; var NewLeft, NewTop, NewWidth, NewHeight: integer) of object;

  TResizer = class(TComponent)
  protected
    FActive: boolean;
    FControl: TControl;
    Sizers: TList;
    GroupMovers: TList;
    FGroup: TWinControl;
    FGridX: integer;
    FGridY: integer;
    FOnSized: TNotifyEvent;
    FOnSizing: TSizingEvent;
    FOnMoved: TNotifyEvent;
    FOnMoving: TMovingEvent;

    FOnMouseDown: TMouseEvent;
    FOnMouseMove: TMouseMoveEvent;
    FOnMouseUp: TMouseEvent;
    FOnClick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;

    Sizing: boolean;
    Moving: boolean;
    OrigSize: TRect;
    NewSize: TRect;
    DownX: integer;
    DownY: integer;
    FAllowSize: boolean;
    FAllowMove: boolean;
    FKeepIn: boolean;
    FHotTrack: boolean;
    OneMover: TMover;
    CurMover: TMover;
    FPopupMenu: TPopupMenu;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetActive(b: boolean);
    procedure SetControl(c: TControl);
    procedure SetGroup(p: TWinControl);
    procedure CreateSizers;
    procedure CheckSizers;
    procedure ShowSizers;
    procedure HideSizers;
    procedure SizerDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SizerUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SizerMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure MoverDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MoverUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MoverMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Click(Sender: TObject);
    procedure DblClick(Sender: TObject);


    procedure DrawSizeRect(Rect: TRect);
    procedure Calc_Size_Rect(SizerNum, dx, dy: integer);
    procedure DoSizingEvent;
    procedure Calc_Move_Rect(dx, dy: integer);
    procedure DoMovingEvent;
    procedure Constrain_Size;
    procedure Constrain_Move;
    procedure MoverKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DoSizeMove(var Key: Word; Shift: TShiftState; dx, dy: integer);
    procedure CreateGroupMovers;
    procedure CreateOneMover(m: TMover; c: TControl);
    function FindMoverByBuddy(c: TControl): TMover;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Front;
  published
    property Active: boolean read FActive write SetActive default True;
    property ResizeControl: TControl read FControl write SetControl;
    property ResizeGroup: TWinControl read FGroup write SetGroup;
    property GridX: integer read FGridX write FGridX default GRIDDEFAULT;
    property GridY: integer read FGridY write FGridY default GRIDDEFAULT;
    property OnSized: TNotifyEvent read FOnSized write FOnSized;
    property OnSizing: TSizingEvent read FOnSizing write FOnSizing;
    property OnMoved: TNotifyEvent read FOnMoved write FOnMoved;
    property OnMoving: TMovingEvent read FOnMoving write FOnMoving;

    property OnControlClick: TNotifyEvent read FOnClick write FOnClick;
    property OnControlDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnControlMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnControlMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnControlMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
    property PopupMenu: TPopupMenu read FPopupMenu write FPopupMenu;
    property AllowSize: boolean read FAllowSize write FAllowSize default True;
    property AllowMove: boolean read FAllowMove write FAllowMove default True;
    property KeepInParent: boolean read FKeepIn write FKeepIn default True;
    property HotTrack: boolean read FHotTrack write FHotTrack;
  end;

  TInvisWin = class(TPanel) // This could also derive from TPanel
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMDLGCode(var Message: TMessage); message WM_GETDLGCODE;

  public
    property OnKeyDown;
  end;

  TMover = class(TInvisWin)
  protected
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMNCLButtonDown(var Message: TWMNCLButtonDown); message WM_NCLBUTTONDOWN;
    procedure WMRButtonDown(var Message: TWMRButtonDown); message WM_RBUTTONDOWN;
    procedure WMMButtonDown(var Message: TWMMButtonDown); message WM_MBUTTONDOWN;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMRButtonDblClk(var Message: TWMRButtonDblClk); message WM_RBUTTONDBLCLK;
    procedure WMMButtonDblClk(var Message: TWMMButtonDblClk); message WM_MBUTTONDBLCLK;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMRButtonUp(var Message: TWMRButtonUp); message WM_RBUTTONUP;
    procedure WMMButtonUp(var Message: TWMMButtonUp); message WM_MBUTTONUP;
  public
    Buddy: TControl;
    Resizer: TResizer;
    procedure Show;
  end;


procedure Register;

implementation

const
  SIZE = 6;
  HALFSIZE = SIZE div 2;

type
  TSizer = class(TPanel)
  end;

procedure Register;
begin
  RegisterComponents('Samples', [TResizer]);
end;


// *****************************************************************
// TInvisWin

procedure TInvisWin.WndProc(var Message: TMessage);
var
  ps: TPaintStruct;
begin
  case Message.Msg of
    WM_ERASEBKGND: Message.Result := 1;
    WM_PAINT: begin
        BeginPaint(Handle, ps);
        EndPaint(Handle, ps);
        Message.Result := 1;
      end;
  else
    inherited WndProc(Message);
  end;
end;

procedure TInvisWin.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_TRANSPARENT;
end;

procedure TInvisWin.WMDLGCode(var Message: TMessage);
begin
  Message.Result := DLGC_WANTARROWS or DLGC_WANTALLKEYS;
end;



// *****************************************************************
// TMover

procedure TMover.Show;
begin
  Assert(Buddy <> nil);
  BoundsRect := Buddy.BoundsRect;
  Parent := Buddy.Parent;
  Visible := True;
  BringToFront;
end;

procedure TMover.WMLButtonDown(var Message: TWMLButtonDown);
begin
  inherited;
end;

procedure TMover.WMNCLButtonDown(var Message: TWMNCLButtonDown);
begin
  inherited;
end;

procedure TMover.WMRButtonDown(var Message: TWMRButtonDown);
begin
  inherited;
end;

procedure TMover.WMMButtonDown(var Message: TWMMButtonDown);
begin
  inherited;
end;

procedure TMover.WMLButtonDblClk(var Message: TWMLButtonDblClk);
{var
  Pos: Integer;
  Key: integer;}
begin
  inherited;
 { if Buddy is TWinControl then begin
    Pos := (Message.YPos shl 16) + Message.XPos;
    Key := Message.Keys;
    SendMessage(TWinControl(Buddy).Handle, Message.Msg, Key, Pos);
  end; }
end;

procedure TMover.WMRButtonDblClk(var Message: TWMRButtonDblClk);
{var
  Pos: Integer;
  Key: integer;}
begin
  inherited;
 { if Buddy is TWinControl then begin
    Pos := (Message.YPos shl 16) + Message.XPos;
    Key := Message.Keys;
    SendMessage(TWinControl(Buddy).Handle, Message.Msg, Key, Pos);
  end;}
end;

procedure TMover.WMMButtonDblClk(var Message: TWMMButtonDblClk);
{var
  Pos: Integer;
  Key: integer;}
begin
  inherited;
{  if Buddy is TWinControl then begin
    Pos := (Message.YPos shl 16) + Message.XPos;
    Key := Message.Keys;
    SendMessage(TWinControl(Buddy).Handle, Message.Msg, Key, Pos);
  end; }
end;

procedure TMover.WMMouseMove(var Message: TWMMouseMove);
{var
  Pos: Integer;
  Key: integer; }
begin
  inherited;
{  if Buddy is TWinControl then begin
    Pos := (Message.YPos shl 16) + Message.XPos;
    Key := Message.Keys;
    SendMessage(TWinControl(Buddy).Handle, Message.Msg, Key, Pos);
  end;}
end;

procedure TMover.WMLButtonUp(var Message: TWMLButtonUp);
{var
  Pos: Integer;
  Key: integer;  }
begin
  inherited;
 { if Buddy is TWinControl then begin
    Pos := (Message.YPos shl 16) + Message.XPos;
    Key := Message.Keys;
    SendMessage(TWinControl(Buddy).Handle, Message.Msg, Key, Pos);
  end;  }
end;

procedure TMover.WMRButtonUp(var Message: TWMRButtonUp);
{var
  Pos: Integer;
  Key: integer;}
begin
  inherited;
{  if Buddy is TWinControl then begin
    Pos := (Message.YPos shl 16) + Message.XPos;
    Key := Message.Keys;
    SendMessage(TWinControl(Buddy).Handle, Message.Msg, Key, Pos);
  end;}
end;

procedure TMover.WMMButtonUp(var Message: TWMMButtonUp);
{var
  Pos: Integer;
  Key: integer;}
begin
  inherited;
{  if Buddy is TWinControl then begin
    Pos := (Message.YPos shl 16) + Message.XPos;
    Key := Message.Keys;
    SendMessage(TWinControl(Buddy).Handle, Message.Msg, Key, Pos);
  end;   }
end;

// *****************************************************************
// TResizer

constructor TResizer.Create(AOwner: TComponent);
begin
  inherited;
  FActive := True;
  FKeepIn := True;
  FGridX := GRIDDEFAULT;
  FGridY := GRIDDEFAULT;
  FAllowSize := True;
  FAllowMove := True;
  GroupMovers := TList.Create;
  Sizers := TList.Create;

  OneMover := TMover.Create(Self);
  CreateOneMover(OneMover, nil);

  CreateSizers;
  FOnMouseDown := nil;
  FOnMouseMove := nil;
  FOnMouseUp := nil;
  FPopupMenu := nil;
end;

destructor TResizer.Destroy;
begin
  GroupMovers.Free;
  Sizers.Free;
  Sizers := nil;
  inherited;
end;

procedure TResizer.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if csDestroying in ComponentState then exit;
  if (AComponent = ResizeControl) and (Operation = opRemove) then
    ResizeControl := nil;
end;

procedure TResizer.SetActive(b: boolean);
begin
  if b <> FActive then begin
    FActive := b;
    CheckSizers;
  end;
end;

procedure TResizer.SetControl(c: TControl);
begin
  if c <> FControl then begin

    if c <> nil then begin
      if ResizeGroup <> nil then begin
        Assert(c.Parent = ResizeGroup, 'ResizeControl is not in ResizeGroup!');
        CurMover := FindMoverByBuddy(c);
      end else begin
        CurMover := OneMover;
        CurMover.Buddy := c;
      end;
      CurMover.Show;
    end;

    FControl := c;
    CheckSizers;
  end;
end;

procedure TResizer.SetGroup(p: TWinControl);
begin
  if p <> FGroup then begin
    FGroup := p;
    CreateGroupMovers;
  end;
end;

procedure TResizer.CreateGroupMovers;
var
  i: integer;
  m: TMover;
  c: TControl;
begin
  if csDesigning in ComponentState then exit;

  // Clear out the old Movers
  for i := 0 to GroupMovers.Count - 1 do
    TObject(GroupMovers[i]).Free;
  GroupMovers.Clear;

  if ResizeGroup <> nil then begin
    for i := 0 to ResizeGroup.ControlCount - 1 do begin
      c := ResizeGroup.Controls[i];
      if (c is TMover) or (c is TSizer) then continue;

      m := TMover.Create(Self);
      CreateOneMover(m, c);
      GroupMovers.Add(m);
      m.Show;
    end;
  end;
end;

procedure TResizer.CreateSizers;
var
  i: integer;
  p: TSizer;
begin
  if csDesigning in ComponentState then exit;

  for i := 0 to 7 do begin
    p := TSizer.Create(Self);
    Sizers.Add(p);

    p.BevelOuter := bvNone;
    p.Width := SIZE;
    p.Height := SIZE;
    p.Color := clBlack;
    p.Caption := '';
    p.Tag := i;
    p.OnMouseDown := SizerDown;
    p.OnMouseUp := SizerUp;
    p.OnMouseMove := SizerMove;

    p.TabStop := False;

    case i of
      0, 7: p.Cursor := crSizeNWSE;
      2, 5: p.Cursor := crSizeNESW;
      1, 6: p.Cursor := crSizeNS;
      3, 4: p.Cursor := crSizeWE;
    end;
  end;
end;

procedure TResizer.CreateOneMover(m: TMover; c: TControl);
begin
  m.OnMouseDown := MoverDown;
  m.OnMouseUp := MoverUp;
  m.OnMouseMove := MoverMove;
  m.OnClick := Click;
  m.OnDblClick := DblClick;
  m.TabStop := True;
  m.OnKeyDown := MoverKeyDown;
  m.Buddy := c;
  m.Resizer := Self;
end;

procedure TResizer.Front;
begin
  if (ResizeControl <> nil) and Active and (not (csDesigning in ComponentState)) then
    ShowSizers
  else
    HideSizers;
end;

procedure TResizer.CheckSizers;
begin
  if (ResizeControl <> nil) and Active and (not (csDesigning in ComponentState)) then
    ShowSizers
  else
    HideSizers;
end;

procedure TResizer.ShowSizers;
var
  i: integer;
  p: TPanel;
  c: TControl;
begin
  c := ResizeControl;
  Assert(c <> nil);

  for i := 0 to 7 do begin
    p := TPanel(Sizers[i]);
    case i of
      0, 1, 2: p.Top := c.Top - HALFSIZE;
      3, 4: p.Top := c.Top + c.Height div 2 - HALFSIZE;
      5, 6, 7: p.Top := c.Top + c.Height - HALFSIZE;
    end;

    case i of
      0, 3, 5: p.Left := c.Left - HALFSIZE;
      1, 6: p.Left := c.Left + c.Width div 2 - HALFSIZE;
      2, 4, 7: p.Left := c.Left + c.Width - HALFSIZE;
    end;
  end;

  Assert(CurMover <> nil);
  CurMover.Show;

  for i := 0 to Sizers.Count - 1 do begin
    p := TPanel(Sizers[i]);
    p.Parent := c.Parent;
    p.Visible := True;
    p.BringToFront;
  end;

  if CurMover.HandleAllocated and CurMover.CanFocus then
    CurMover.SetFocus;
end;

procedure TResizer.HideSizers;
var
  i: integer;
  p: TPanel;
begin
  for i := 0 to Sizers.Count - 1 do begin
    p := TPanel(Sizers[i]);
    p.Visible := False;
    p.Update;
  end;
  OneMover.Visible := False;
end;

procedure TResizer.SizerDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //if Assigned(FOnMouseDown) then FOnMouseDown(ResizeControl, Button, Shift, X, Y);
  Sizing := True;
  DownX := X;
  DownY := Y;
  HideSizers;
  ResizeControl.Parent.Update;
  ResizeControl.Update;
  OrigSize := ResizeControl.BoundsRect;
  NewSize := OrigSize;
  DrawSizeRect(NewSize);
end;

procedure DoSwap(DoSwap: boolean; var a, b: integer);
var
  t: integer;
begin
  if DoSwap then begin
    t := a;
    a := b;
    b := t;
  end;
end;

procedure TResizer.SizerUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if NewSize.Right < NewSize.Left then
    DoSwap(True, NewSize.Right, NewSize.Left);
  if NewSize.Bottom < NewSize.Top then
    DoSwap(True, NewSize.Bottom, NewSize.Top);

  Sizing := False;
  DrawSizeRect(NewSize);
  ResizeControl.Invalidate;
  ResizeControl.BoundsRect := NewSize;
  ShowSizers;
  if Assigned(OnSized) then OnSized(Self);
end;

procedure TResizer.SizerMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if Sizing then begin
    DrawSizeRect(NewSize);

    if AllowSize then begin
      Calc_Size_Rect((Sender as TSizer).Tag, X - DownX, Y - DownY);
      DoSizingEvent;
    end;

    DrawSizeRect(NewSize);
    if HotTrack then ResizeControl.BoundsRect := NewSize;
  end;
end;

procedure TResizer.DoSizingEvent;
var
  tmpWid, tmpHgt: integer;
begin
  tmpWid := NewSize.Right - NewSize.Left;
  tmpHgt := NewSize.Bottom - NewSize.Top;
  if Assigned(OnSizing) then
    OnSizing(Self, NewSize.Left, NewSize.Top, tmpWid, tmpHgt);
  NewSize.Right := NewSize.Left + tmpWid;
  NewSize.Bottom := NewSize.Top + tmpHgt;
end;

procedure GetNonClientOffset(h: THandle; var nx, ny: integer);
var
  p: TPoint;
  R: TRect;
begin
  p := Point(0, 0);
  Windows.ClientToScreen(h, p);
  Windows.GetWindowRect(h, R);
  nx := p.x - R.Left;
  ny := p.y - R.Top;
end;

procedure TResizer.DrawSizeRect(Rect: TRect);
var
  h: THandle;
  dc: THandle;
  c: TCanvas;
  nx, ny: integer;
  OldPen: TPen;
  OldBrush: TBrush;
begin
  if HotTrack then exit;

  h := (ResizeControl.Parent as TWinControl).Handle;
  GetNonClientOffset(h, nx, ny);
  dc := GetWindowDC(h);
  try
    c := TCanvas.Create;
    c.Handle := dc;

    OldPen := TPen.Create;
    OldPen.Assign(c.Pen);
    OldBrush := TBrush.Create;
    OldBrush.Assign(c.Brush);

    c.Pen.Width := 2;
    c.Pen.Mode := pmXOR;
    c.Pen.Color := clWhite;
    c.Brush.Style := bsClear;
    c.Rectangle(Rect.Left + nx, Rect.Top + ny, Rect.Right + nx, Rect.Bottom + ny);

    c.Pen.Assign(OldPen);
    OldPen.Free;
    c.Brush.Assign(OldBrush);
    OldBrush.Free;

    c.Handle := 0;
    c.Free;
  finally
    ReleaseDC(h, dc);
  end;
end;

procedure TResizer.Calc_Size_Rect(SizerNum, dx, dy: integer);
begin
  dx := (dx div GridX) * GridX;
  dy := (dy div GridY) * GridY;

  case SizerNum of
    0, 1, 2: NewSize.Top := OrigSize.Top + dy;
    5, 6, 7: NewSize.Bottom := OrigSize.Bottom + dy;
  end;

  case SizerNum of
    0, 3, 5: NewSize.Left := OrigSize.Left + dx;
    2, 4, 7: NewSize.Right := OrigSize.Right + dx;
  end;

  if KeepInParent then Constrain_Size;
end;

procedure TResizer.Click(Sender: TObject);
begin
  if Assigned(FOnClick) then FOnClick(ResizeControl);
end;

procedure TResizer.DblClick(Sender: TObject);
begin
  if Assigned(FOnDblClick) then FOnDblClick(ResizeControl);
end;

procedure TResizer.MoverDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnMouseDown) then FOnMouseDown(ResizeControl, Button, Shift, X, Y);
  if Button = mbLeft then begin
    CurMover := Sender as TMover;
    FControl := CurMover.Buddy;
    Assert(FControl <> nil);
    FControl.BringToFront;
    CurMover.BringToFront;

    Moving := True;
    DownX := X;
    DownY := Y;
    HideSizers;
    ResizeControl.Parent.Update;
    ResizeControl.Update;
    OrigSize := ResizeControl.BoundsRect;
    NewSize := OrigSize;
    DrawSizeRect(NewSize);
  end;
end;

procedure TResizer.MoverUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pt: Tpoint;
begin
  if Assigned(FOnMouseUp) then
    FOnMouseUp(ResizeControl, Button, Shift, X, Y);
  if Button = mbRight then begin
    if Assigned(FPopupMenu) then begin
      GetCursorPos(pt);
      FPopupMenu.Popup(pt.X, pt.Y);
    end;
  end;
  if Button = mbLeft then begin
    Moving := False;
    ResizeControl.BoundsRect := NewSize;
    CurMover.Invalidate;
    ResizeControl.Refresh;
    DrawSizeRect(NewSize);
    ShowSizers;
    if Assigned(OnMoved) then OnMoved(Self);
  end;
end;

procedure TResizer.Calc_Move_Rect(dx, dy: integer);
begin
  NewSize := OrigSize;
  dx := (dx div GridX) * GridX;
  dy := (dy div GridY) * GridY;
  OffsetRect(NewSize, dx, dy);
  if KeepInParent then Constrain_Move;
end;

procedure TResizer.DoMovingEvent;
var
  tmpWid, tmpHgt: integer;
begin
  tmpWid := NewSize.Right - NewSize.Left;
  tmpHgt := NewSize.Bottom - NewSize.Top;
  if Assigned(OnMoving) then
    OnMoving(Self, NewSize.Left, NewSize.Top);
  NewSize.Right := NewSize.Left + tmpWid;
  NewSize.Bottom := NewSize.Top + tmpHgt;
end;

procedure TResizer.MoverMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  dx, dy: integer;
begin
  if Assigned(FOnMouseMove) then FOnMouseMove(ResizeControl, Shift, X, Y);
  if Moving then begin
    DrawSizeRect(NewSize);
    if AllowMove then begin
      dx := X - DownX;
      dy := Y - DownY;
      Calc_Move_Rect(dx, dy);
      DoMovingEvent;
    end;
    DrawSizeRect(NewSize);
    if HotTrack then ResizeControl.BoundsRect := NewSize;
  end;
end;

procedure TResizer.Constrain_Size;
var
  p: TWinControl;
begin
  p := ResizeControl.Parent;

  with NewSize do begin
    if Left < 0 then Left := 0;
    if Top < 0 then Top := 0;
    if Right > p.ClientWidth then Right := p.ClientWidth;
    if Bottom > p.ClientHeight then Bottom := p.ClientHeight;

    if Right < Left + GridX then Right := Left + GridX;
    if Bottom < Top + GridY then Bottom := Top + GridY;
  end;
end;

procedure TResizer.Constrain_Move;
begin
  if NewSize.Left < 0 then
    OffsetRect(NewSize, -NewSize.Left, 0);

  if NewSize.Top < 0 then
    OffsetRect(NewSize, 0, -NewSize.Top);

  if NewSize.Right > ResizeControl.Parent.ClientWidth then
    OffsetRect(NewSize, ResizeControl.Parent.ClientWidth - NewSize.Right, 0);

  if NewSize.Bottom > ResizeControl.Parent.ClientHeight then
    OffsetRect(NewSize, 0, ResizeControl.Parent.ClientHeight - NewSize.Bottom);
end;

procedure TResizer.MoverKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Active then begin
    case Key of
      VK_LEFT: DoSizeMove(Key, Shift, -GridX, 0);
      VK_RIGHT: DoSizeMove(Key, Shift, GridX, 0);
      VK_UP: DoSizeMove(Key, Shift, 0, -GridY);
      VK_DOWN: DoSizeMove(Key, Shift, 0, GridY);
    end;
  end;
end;

procedure TResizer.DoSizeMove(var Key: Word; Shift: TShiftState; dx, dy: integer);
begin
  if (ssCtrl in Shift) or (ssShift in Shift) then begin
    Key := 0;

    NewSize := ResizeControl.BoundsRect;

    if (ssCtrl in Shift) and AllowMove then begin
      OffsetRect(NewSize, dx, dy);
      if KeepInParent then Constrain_Move;
      DoMovingEvent;
    end;

    if (ssShift in Shift) and AllowSize then begin
      NewSize.Right := NewSize.Right + dx;
      NewSize.Bottom := NewSize.Bottom + dy;
      if KeepInParent then Constrain_Size;
      DoSizingEvent;
    end;

    ResizeControl.BoundsRect := NewSize;
    ShowSizers;
  end;
end;

function TResizer.FindMoverByBuddy(c: TControl): TMover;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to GroupMovers.Count - 1 do
    if TMover(GroupMovers[i]).Buddy = c then
      Result := GroupMovers[i];
  Assert(Result <> nil);
end;

end.

