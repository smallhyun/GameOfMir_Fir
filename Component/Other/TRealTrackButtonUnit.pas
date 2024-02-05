{
 Design By Ruralist At 2005.9.11
 E-Mail:acathayboy@yahoo.com.cn
 Web:Http://www.Xease.net
}
unit TRealTrackButtonUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, Graphics,
  StdCtrls,Forms,PublicUnit;

const
  C_DisabledColor = $D1D0CE;
  C_DefaultColor = $00DFDFDF;
  C_DefaultBorderColor = clGray;
  C_DrawRoundFlag = 3;
  C_DefaultFlagColor = $8F9A7C;
  C_ActiveColor = $0027D8A3;
  C_ActiveFlagColor = $0000785C;
  C_MinHeight = 15;
  C_MinWidth = 15;
type
  TTrackButtonStyle = (tbsRoundNess,tbsSquareNess);

  TRealTrackButton = class(TGraphicControl)
  private
    FVertical:Boolean;
    FParentname: TWinControl;
    FValue,   //保存供客户端调用的数
    FPosition,//底层中保存的一个偏移的Value变量,FValue 通过调用它得到自己的结果
    FMaxValue,//客户端设定的最大值
    FMinValue,//客户端设定的最小值
    FPercent, //保存控制位置所占百分比
    FOldX,
    FOldY,    //临时用于保存鼠标拖拉过程的偏移量
    FMinPos,
    FMaxPos,  //设定客户端的拖拉空间(象素)
    FControlSize,
    FPelsPos:integer; //当前象素
    FMouseInControl,
    FShowFlag,
    FActive:boolean;  //是否正在拖拉过程//控制状态是否垂直
    FStyle:TTrackButtonStyle;//界面风格
    FBorderColor,
    FFlagColor,              //界面中心的小图像的默认彩色
    FActiveFlagColor,  //界面中心的小图像的活动彩色
    FActiveColor: TColor;
    FOnChange:TNotifyEvent;
    procedure SetParentName(Value: TWinControl);
    procedure SetVertical(value:Boolean);
    procedure SetShowFlag(Value:Boolean);
    procedure SaveValue;
    procedure SetValue(Value:Integer);
    procedure SetPosition(Value:Integer);
    procedure SetMaxValue(Value:Integer);
    procedure SetMinValue(Value:Integer);
    procedure SetPelsPos(value:integer);
    procedure SetMinPos(Value:integer);
    procedure SetMaxPos(Value:integer);
    procedure SetStyle(Style:TTrackButtonStyle);
    procedure SetBorderColor(Value:TColor);
    procedure SetFlagColor(Value:Tcolor);
    procedure setActiveFlagColor(value:Tcolor);
    procedure SetActiveColor(Value:TColor);
    procedure OffsetPels(value:Integer);
    procedure UpdateControlSize;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  protected
    procedure SetPercent(Value:Integer);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
  public
    property ControlSize: integer Read FControlSize;
    procedure SetDefaultStateForPelsDistance;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Canvas;
  published
    property MaxPos: integer read FMaxPos Write SetMaxPos;
    property MinPos: integer read FMinPos Write SetMinPos;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property ShowFlag: Boolean read FShowFlag write SetShowFlag Default True;
    property FlagColor: TColor read FFlagColor Write SetFlagColor Default C_DefaultFlagColor;
    property Style: TTrackButtonStyle read FStyle Write SetStyle Default tbsRoundNess;
    property Vertical:Boolean Read FVertical write SetVertical default false;
    property ParentName: TWinControl read FParentname write SetParentName;
    property MaxValue: Integer read FMaxValue Write SetMaxValue Default 100;
    property MinValue: integer read FMinValue Write SetMinValue Default 0;
    property ActiveColor: TColor read FActiveColor write SetActiveColor default C_ActiveColor;
    property ActiveFlagColor:TColor read FActiveFlagColor write SetActiveFlagColor Default C_ActiveFlagColor;
    property BorderColor:TColor read FBorderColor write SetBorderColor Default C_DefaultBorderColor;
    property Value: integer read FValue write SetValue default 50;
    Property Percent: integer read FPercent write SetPercent default 50;
    property Action;
    property Color;
    property Enabled;
    property Hint;
    property ParentColor default True;
    property PopupMenu;
    property ShowHint default false;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
end;

procedure Register;

implementation

{ TRealTrackButton }

procedure Register;
begin
  RegisterComponents('RealStyle', [TRealTrackButton]);
end;

procedure TRealTrackButton.SetActiveColor(Value: TColor);
begin
  FActiveColor := Value;
  Invalidate;
end;

constructor TRealTrackButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMaxPos := 100;
  FMinPos := 1;
  SetParent(TWinControl(aowner)); //方便调试,临时使用
  FParentName:=Parent;
  ShowHint := False;
  Color := C_DefaultColor;
  FBorderColor := C_DefaultBorderColor;
  FFlagColor := C_DefaultFlagColor;
  FActiveColor := C_ActiveColor;
  FActiveFlagColor := C_ActiveFlagColor;
  FStyle := tbsRoundNess;
  FShowFlag := True;
  top := 2;
  left := 2;
  Height := C_MinHeight;
  Width := C_MinWidth;
  SetDefaultStateForPelsDistance;
  FMaxValue := 100;
  FMinValue := 0;
  FPercent := 50;
  ControlStyle := ControlStyle +[csOpaque, csParentBackground];
  SaveValue;
end;

destructor TRealTrackButton.Destroy;
begin
  inherited Destroy;
end;

procedure TRealTrackButton.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button,shift,x,y);
  if Button = mbLeft then
  begin
    UpdateControlSize;
    FActive := true;
    FOldX := X - MinPos;
    FOldY := Y + FMinPos;
    SetFocus(parent.Handle);
    Invalidate;
  end;
end;

procedure TRealTrackButton.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button,shift,x,y);
  if Button = mbLeft then
  begin
    FActive := false;
    if Assigned(FOnChange) then FOnChange(self);
    Invalidate;
  end;
  if (Button = mbLeft) and (FParentName <> nil) then SendMessage(FParentName.Handle,WM_LBUTTONUP,0,0);
end;

procedure TRealTrackButton.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(shift,x,y);
  if FActive then
  begin
    if not FVertical then
    begin
      if FOldX < X then
        OffsetPels(FPelsPos + X -FOldX)
      else OffsetPels(FPelsPos - (FOldX - X));
    end
    else                               
    begin
      if FOldY < Y then
        OffsetPels(FPelsPos - Y + FOldY)
      else OffsetPels(FPelsPos + (FOldY - Y));
    end;
  end;
end;

procedure TRealTrackButton.SetBorderColor(Value: TColor);
begin
  FBorderColor := Value;
  Invalidate;
end;

procedure TRealTrackButton.SetFlagColor(Value: Tcolor);
begin
  FFlagColor := Value;
  Invalidate;
end;


procedure TRealTrackButton.SetParentName(Value: TWinControl);
begin
  if Value.Handle <> 0 then
  begin
    FParentName:=Value;
    SetParent(Value);
    SetValue(FValue);
  end;
end;                  

procedure TRealTrackButton.SetMaxPos(Value: integer);
begin
  if Value = FMaxPos then Exit
  else
    if Value <= FMinPos then raise exception.Create('Error Code: FMaxPos <= FMinPos,最大距离的值不应该小于或等于最小距离的值');
  FMaxPos := Value;
  SetValue(FValue);
  Invalidate;
end;

procedure TRealTrackButton.SetMinPos(Value: integer);
begin
  if Value = FMinPos then Exit
  else
    if Value >= FMaxPos then raise exception.Create('Error Code: FMinPos >= FMaxPos,最小距离的值不应该大于或等于最大距离的值');
  FMinPos := Value;
  SetValue(FValue);
  Invalidate;
end;

procedure TRealTrackButton.SetStyle(Style:TTrackButtonStyle);
begin
  FStyle := Style;
  Invalidate;
end;

procedure TRealTrackButton.SetVertical(value: Boolean);
begin
  FVertical := Value;
  SetValue(FValue);
  Invalidate;
end;

procedure TRealTrackButton.SetPercent(Value: Integer);
var
  Pos:integer;
  PosCount:integer;
begin
  if Value < 0 then Value := 0
    else If Value > 100 then Value := 100;
  PosCount := FMaxPos - FMinPos - FControlSize;
  if PosCount < 0 then PosCount := 0;
  pos := round(PosCount * Value / 100);
  OffsetPels(pos + FminPos);
  FPercent := Value;
end;

procedure TRealTrackButton.OffsetPels(value: Integer);
var
  PelsCount,
  ValueCount:Double;
  aPercent:Double;
begin
  if Value > FMaxPos - FControlSize then Value := FMaxPos - FControlSize;  //此处关键
  if Value < FMinPos then Value := FMinPos;

  PelsCount := FMaxPos - FMinPos - FControlSize;  //此处关键
  ValueCount := FMaxValue - FMinValue;

  aPercent := (value - FMinPos)  / PelsCount;  //此处关键
  if FPosition <>  round(ValueCount * aPercent) then
  begin
    FPosition := round(ValueCount * aPercent);
    if Assigned(FOnChange) then FOnChange(self);
  end;
  SaveValue;
  SetPelsPos(round(FPosition / ValueCount * PelsCount));
end;

procedure TRealTrackButton.SetPelsPos(value: integer);
begin
  if Value > FMaxPos{ - FControlSize} then Value := FMaxPos{ - FControlSize};
  if Value < 0 then Value := 0;
  if Not FVertical then
  begin
    left := Value + FMinPos;
  end                          
  else top := parent.Height - (Value + FMinPos + Height) ;

  FPelsPos := Value;
  FPercent := round(FPosition / (FMaxValue - FMinValue) * 100);
end;

procedure TRealTrackButton.Paint;
var
  aRect:TRect;
  int,int2:integer;
  aleft,atop:integer;
  BrightColor:TColor;                        
begin
  inherited;
  aRect := ClientRect;
  canvas.Lock;
  try
    With Canvas do
    begin
      //初始化:
      if FActive then
        Brush.Color := FActiveColor
      else Brush.Color := Color;
      Pen.Color := FBorderColor;
      pen.Style := psSolid;
      BrightColor := GetBright(canvas,Brush.Color,5);
      if width = height then
      begin
        int := width;
        aleft := 0;
        atop := 0;
      end
      else
        begin
          if width > height then
          begin
            int := height;
            aleft := (width - height) div 2;
            atop := 0;
          end
          else
          begin
            int := width;
            aleft := 0;
            atop := (height - width) div 2;
          end;
        end;
      case FStyle of
        tbsRoundNess:
        begin
          Ellipse(aleft,atop,int + aleft,int + atop);

          pen.Style := psClear;
          brush.Color := BrightColor;
          ellipse(Round(aleft + int * 1 / 10),Trunc(atop + int * 1 / 10),round(aleft + int * 9 / 10),round(atop + int * 9 / 10));
          brush.Color := GetBright(canvas,BrightColor,3) ;
          ellipse(Round(aleft + int * 1 / 10),Trunc(atop + int * 1 / 10),round(aleft + int * 8 / 10),round(atop + int * 8 / 10));
          brush.Color := GetBright(canvas,BrightColor,6) ;
          ellipse(round(aleft + int * 1 / 10),Trunc(atop + int * 1 / 10),round(aleft + int * 7 / 10),round(atop + int * 7 / 10));
          brush.Color := GetBright(canvas,BrightColor,10) ;
          ellipse(round(aleft + int * 2 / 10),Trunc(atop + int * 2 / 10),round(aleft + int * 5 / 10),round(atop + int * 5 / 10));
          brush.Color := GetBright(canvas,BrightColor,13) ;
          ellipse(round(aleft + int * 3 / 10),Trunc(atop + int * 3 / 10),round(aleft + int * 3 / 10),round(atop + int * 3 / 10));
          brush.Color := GetBright(canvas,BrightColor,15) ;
          ellipse(round(aleft + int * 4 / 10),Trunc(atop + int * 4 / 10),round(aleft + int * 3 / 10),round(atop + int * 3 / 10));

        end;
        tbsSquareNess:
        begin
          RoundRect(aRect.Left,aRect.Top,aRect.Right,aRect.Bottom,3,3);
          pen.Style := psClear;
          brush.Color := BrightColor;
          RoundRect(width div 5,height div 5,width - width div 5,height - height div 5,3,3);
          brush.Color := GetBright(canvas,BrightColor,5) ;
          RoundRect(width div 3,height div 3,width - width div 3,height - height div 3,3,3);
        end;
      end;

      if FShowFlag and (FActive or FMouseInControl) then
      begin
        pen.Style := psSolid;
        if FActive then Pen.Color := FActiveFlagColor
          else Pen.Color := FFlagColor;
        case FStyle of
          tbsRoundNess:
          begin
            if not FVertical then
            begin
              int2 := int div 2;
              MoveTo(aleft + int div 2,atop + int div 4 + 1);
              lineTo(aleft + int div 2,atop + int div 4 + Int2 + 1);
            end
            else
            begin
              int2 := int div 2;
              MoveTo(aleft + int div 4 +1 ,atop + int div 2);
              lineTo(aleft + int div 4 + int2 + 1,atop + int div 2);
            end;
          end;
          tbsSquareNess:
          begin
            if not FVertical then
            begin
              int2 := height div 2;
              MoveTo(width div 2,height div 4 + 1);
              lineTo(width div 2,height div 4 + Int2 + 1);
            end
            else
            begin
              int2 := width div 2;
              MoveTo(width div 4 +1 ,height div 2);
              lineTo(width div 4 + int2 + 1,height div 2);
            end;
          end;
        end;
      end;
    end;
  finally  canvas.Unlock; end;
end;

procedure TRealTrackButton.SetMaxValue(Value: Integer);
begin
  if Value = FMaxValue then Exit
  else
    if Value <= FMinValue then
      raise Exception.Create('ErrorCode:MaxValue <= MinValue'#13'最大值不应该小于或等于最小值.');
  FMaxValue := Value;
  setValue(FValue);
end;

procedure TRealTrackButton.SetMinValue(Value: Integer);
begin
  if Value = FMinValue then Exit
  else
    if Value >= FMaxValue then
      raise Exception.Create('ErrorCode: MinValue >= MaxValue'#13'最小值不应该大于或等于最大值.');
  FMinValue := Value;
  setValue(FValue);
end;

procedure TRealTrackButton.SetPosition(Value: Integer);
var
  Int:integer;
  Int2:integer;
begin
  if Value > (FMaxValue - FMinValue) then Value :=  (FMaxValue - FMinValue)
    else if Value < FMinValue then Value := FMinValue;
  Int2 := Value;
  int := FMaxValue - FMinValue;
  SetPercent(round(value / int  * 100));
  FPosition := Int2;
  SaveValue;
end;

procedure TRealTrackButton.setActiveFlagColor(value: Tcolor);
begin
  FActiveFlagColor := Value;
  Invalidate;
end;

procedure TRealTrackButton.SaveValue;
begin
  FValue := FPosition + FMinValue;
end;

procedure TRealTrackButton.SetValue(Value: Integer);
var
  Int:integer;
begin
  UpdateControlSize;
  if Value < FMinValue then Value := FMinValue
    else if Value > FMaxValue then Value := FMaxValue;
  int := Value - FMinValue;
  Setposition(int);
end;

procedure TRealTrackButton.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  FMouseInControl := true;
  invalidate;
end;

procedure TRealTrackButton.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FMouseInControl := false;
  invalidate;
end;

procedure TRealTrackButton.SetDefaultStateForPelsDistance;
begin
  if not FVertical then
  begin
    FMinPos :=  1 ;
    FMaxPos := Parent.Width - 2;
  end
  else
  begin
    FMinPos := 1;
    FMaxPos := Parent.height - 2;
  end;
  UpdateControlSize;
end;

procedure TRealTrackButton.UpdateControlSize;
begin
  if not FVertical then
    FControlSize := Width
  else FControlSize := Height;
end;

procedure TRealTrackButton.SetShowFlag(Value: Boolean);
begin
  FShowFlag := Value;
  Invalidate;
end;


end.
