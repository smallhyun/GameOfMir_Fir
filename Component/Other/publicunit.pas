unit PublicUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, Graphics,
  StdCtrls,Forms;

  Function GetMaxValue(const Int1,int2:integer):integer;
  FUnction GetMinValue(const Int1,int2:integer):integer;
  //复制背景.
  procedure DrawParentImage(Control: TControl; Dest: TCanvas);
  //取灰度颜色
  function GetGrayest(Const ACanvas: TCanvas; clr: TColor; Value: integer): TColor;
  //调低颜色亮度
  function GetDark(Const ACanvas:TCanvas;Clr:TColor;Value:integer):TColor;
  //调低颜色亮度
  Function GetBright(ACanvas: TCanvas; clr: TColor; Value: integer): TColor;
  //颜色反转:
  Function GetChanged(const ACanvas:TCanvas;Clr:TColor):TColor;
  //画透明 BitMap 到 canvas 上面
  procedure DrawTransBitmap(const SourceBitMap:TBitmap;GoalCanvas:TCanvas;const TransColor:TColor;Dest,Source:TRECT);
  //从一个 canvas 上面透明一个颜色并将结果画到另一个canvas 上
  procedure DrawTransCanvas(const SourceCanvas:TCanvas;GoalCanvas:TCanvas;const TransColor:TColor;Dest,Source:TRECT);
  //取一个透明颜色值:
  Function GetTransColor(const aBitMap:TBitMap):TColor;
implementation

Function GetMaxValue(const Int1,int2:integer):integer;
begin
  result := int1;
  if int1 < int2 then
    result := int2;
end;

Function GetMinValue(const Int1,int2:integer):integer;
begin
  result := int1;
  if int1 > int2 then
    result := int2;
end;

Function GetChanged(const ACanvas:TCanvas;Clr:TColor):TColor;
var
  r,g,b:integer;
begin
  clr := ColorToRGB(clr);
  r := Clr and $000000FF;
  g := (Clr and $0000FF00) shr 8;
  b := (Clr and $00FF0000) shr 16;
  r := 255 - r;
  g := 255 - g;
  b := 255 - b;
  Result := Windows.GetNearestColor(ACanvas.Handle, RGB(r, g, b));
end;

procedure DrawTransCanvas(const SourceCanvas:TCanvas;GoalCanvas:TCanvas;const TransColor:TColor;Dest,Source:TRECT);
var
  i,j:integer;
  C:TColor;
begin
  for i := dest.Left to dest.Right do
    for j := dest.Top to dest.Bottom do
    begin
      c := SourceCanvas.Pixels[i,j];
      if (c  = TransColor) or (i + Source.Left > Source.Right) or (j + Source.Top > Source.Bottom) then continue;
      GoalCanvas.Pixels[i + Source.left,j + Source.top] := c;
    end;
end;

procedure DrawTransBitmap(const SourceBitMap:TBitmap;GoalCanvas:TCanvas;const TransColor:TColor;Dest,Source:TRECT);
var
  i,j:integer;
  C:TColor;
begin
  for i := dest.Left to dest.Right do
    for j := dest.Top to dest.Bottom do
    begin
      c := SourceBitMap.Canvas.Pixels[i,j];
      if (c  = TransColor) or (i + Source.Left > Source.Right) or (j + Source.Top > Source.Bottom) then continue;
      GoalCanvas.Pixels[i + Source.left,j + Source.top] := c;
    end;
end;

function GetBright(ACanvas: TCanvas; clr: TColor; Value: integer): TColor;
var
  r, g, b: integer;
begin
  if Value > 100 then Value := 100;
  clr := ColorToRGB(clr);
  r := Clr and $000000FF;
  g := (Clr and $0000FF00) shr 8;
  b := (Clr and $00FF0000) shr 16;
  r := r + Round((255 - r) * (value / 100));
  g := g + Round((255 - g) * (value / 100));
  b := b + Round((255 - b) * (value / 100));
  Result := Windows.GetNearestColor(ACanvas.Handle, RGB(r, g, b));
end;


function GetDark(Const ACanvas:TCanvas;Clr:TColor;Value:integer):TColor;
var
  r,g,b:integer;
begin
  if Value > 100 then Value := 100
    else if Value < 0 then Value := 0;
  r := GetRValue(clr);
  g := GetGValue(clr);
  b := GetBValue(clr);
  r := r - r * Value div 100;
  g := g - g * Value div 100;
  b := b - b * Value div 100;
  if r < 0 then r := 0;
  if g < 0 then g := 0;
  if B < 0 then b := 0;
  Result := Windows.GetNearestColor(ACanvas.Handle, RGB(r, g, b));
end;
function GetGrayest(Const ACanvas: TCanvas; clr: TColor; Value: integer): TColor;
var
  r, g, b, avg: integer;
begin
  if Value > 100 then Value := 100;
  clr := ColorToRGB(clr);
  r := Clr and $000000FF;
  g := (Clr and $0000FF00) shr 8;
  b := (Clr and $00FF0000) shr 16;
  Avg := (r + g + b) div 3;
  Avg := Avg + Value;
  if Avg > 240 then Avg := 240;
  Result := Windows.GetNearestColor(ACanvas.Handle, RGB(Avg, avg, avg));
end;


procedure DrawParentImage(Control: TControl; Dest: TCanvas);
var
  SaveIndex: Integer;
  DC: HDC;
  Position: TPoint;
begin
  with Control do
  begin
    if Parent = nil then
      Exit;
    DC := Dest.Handle;
    SaveIndex := SaveDC(DC);
    {$IFDEF DFS_COMPILER_2}
    GetViewportOrgEx(DC, @Position);
    {$ELSE}
    GetViewportOrgEx(DC, Position);
    {$ENDIF}
    SetViewportOrgEx(DC, Position.X - Left, Position.Y - Top, nil);
    IntersectClipRect(DC, 0, 0, Parent.ClientWidth, Parent.ClientHeight);
    Parent.Perform(WM_ERASEBKGND, DC, 0);
    Parent.Perform(WM_PAINT, DC, 0);
    RestoreDC(DC, SaveIndex);
  end;
end;

Function GetTransColor(const aBitMap:TBitMap):TColor;
var
  i,j:integer;
  l,t,r,b:TColor;
begin
  l := aBitmap.Canvas.Pixels[0,abitmap.height div 2];
  t := abitmap.Canvas.Pixels[abitmap.width div 2,0];
  r := abitmap.Canvas.Pixels[abitmap.width - 1,abitmap.height div 2];
  b := abitmap.Canvas.Pixels[abitmap.width div 2,abitmap.height -1];
  result := b;
  for i := 0 to 3 do
  begin
    j := 0;
    case i of
      0:
      begin
        if l = t then inc(j);
        if l = r then inc(j);
        if l = b then inc(j);
        if l > 2 then
        begin
          result := l;
          break;
        end;
      end;
      1:
      begin
        if t = l then inc(j);
        if t = r then inc(j);
        if t = b then inc(j);
        if t > 2 then
        begin
          result := t;
          break;
        end;
      end;
      2:
      begin
        if r = t then inc(j);
        if r = l then inc(j);
        if r = b then inc(j);
        if l > 2 then
        begin
          result := r;
          break;
        end;
      end;
      3:
      begin
        if b = t then inc(j);
        if b = r then inc(j);
        if b = l then inc(j);
        if l > 2 then
        begin
          result := b;
          break;
        end;
      end;
    end;
  end;
end;


end.
