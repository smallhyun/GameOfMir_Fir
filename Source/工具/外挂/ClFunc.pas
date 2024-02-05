unit ClFunc;

interface

uses
  windows, Messages, SysUtils, Classes, Graphics, Controls,
  Grobal, Grobal2, ExtCtrls, HUtil32;

const
  DR_0 = 0;
  DR_1 = 1;
  DR_2 = 2;
  DR_3 = 3;
  DR_4 = 4;
  DR_5 = 5;
  DR_6 = 6;
  DR_7 = 7;
  DR_8 = 8;
  DR_9 = 9;
  DR_10 = 10;
  DR_11 = 11;
  DR_12 = 12;
  DR_13 = 13;
  DR_14 = 14;
  DR_15 = 15;

 { TDynamicObject = record //¹Ù´Ú¿¡ ÈçÀû
    X: Integer; //Ä³¸¯ ÁÂÇ¥°è
    Y: Integer;
    px: Integer; //shiftx ,y
    py: Integer;
    dsurface: TDirectDrawSurface;
  end;
  PTDynamicObject = ^TDynamicObject;   }
function fmstr(Str: string; len: Integer): string;
function GetGoldStr(gold: Integer): string;




function GetDistance(sx, sY, dx, dy: Integer): Integer;
procedure GetNextPosXY(dir: BYTE; var X, Y: Integer);
procedure GetNextRunXY(dir: BYTE; var X, Y: Integer);
procedure GetNextHorseRunXY(dir: BYTE; var X, Y: Integer);
function GetNextDirection(sx, sY, dx, dy: Integer): BYTE;
function GetBack(dir: Integer): Integer;
procedure GetBackPosition(sx, sY, dir: Integer; var NewX, NewY: Integer);
procedure GetFrontPosition(sx, sY, dir: Integer; var NewX, NewY: Integer); OVERLOAD;
procedure GetFrontPosition(sx, sY, dir, nFlag: Integer; var NewX, NewY: Integer); OVERLOAD;
function GetFlyDirection(sx, sY, ttx, tty: Integer): Integer;
function GetFlyDirection16(sx, sY, ttx, tty: Integer): Integer;
function PrivDir(ndir: Integer): Integer;
function NextDir(ndir: Integer): Integer;
function GetTakeOnPosition(smode: Integer): Integer;
function IsKeyPressed(Key: BYTE): Boolean;
function KeyResult(lp: Integer; wp: Integer): string;
function GetKeyValue(Index: Integer): Integer;

const //65-90 'A'..'Z'
  KeyName: array[0..71] of string = (
    'Esc', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '-', '=', 'Backspace', 'Tab',
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S',
    'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'CapsLock', 'LeftShift', 'LeftCtrl', 'LeftAlt', 'RightShift', 'RightCtrl', 'RightAlt',
    'Insert', 'Delete', 'Home', 'End', 'PageUp', 'PageDown', '¡ü', '¡ý', '¡û', '¡ú', '*', '~');

  KeyValue: array[0..71] of Integer = (
    VK_ESCAPE, VK_F1, VK_F2, VK_F3, VK_F4, VK_F5, VK_F6, VK_F7, VK_F8, VK_F9,
    VK_F10, VK_F11, VK_F12, 48, 49, 50, 51, 52, 53, 54,
    55, 56, 57, 189, 187, VK_BACK, VK_TAB, 65, 66, 67,
    68, 69, 70, 71, 72, 73, 74, 75, 76, 77,
    78, 79, 80, 81, 82, 83, 84, 85, 86, 87,
    88, 89, 90, 20, VK_LSHIFT, VK_LCONTROL, VK_LMENU, VK_RSHIFT, VK_RCONTROL, VK_RMENU, VK_INSERT,
    VK_DELETE, VK_HOME, VK_END, VK_PRIOR, VK_NEXT, VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT, VK_MULTIPLY, 192);

implementation
function GetKeyValue(Index: Integer): Integer;
begin
  Result := -1;
  if (Index >= 0) and (Index < Length(KeyValue)) then
    Result := KeyValue[Index];
end;

function KeyResult(lp: Integer; wp: Integer): string;
begin
  Result := '';
  case lp of
    10688: Result := '`';
    561: Result := '1';
    818: Result := '2';
    1075: Result := '3';
    1332: Result := '4';
    1589: Result := '5';
    1846: Result := '6';
    2103: Result := '7';
    2360: Result := '8';
    2617: Result := '9';
    2864: Result := '0';
    3261: Result := '-';
    3515: Result := '=';
    4177: Result := 'Q';
    4439: Result := 'W';
    4677: Result := 'E';
    4946: Result := 'R';
    5204: Result := 'T';
    5465: Result := 'Y';
    5717: Result := 'U';
    5961: Result := 'I';
    6223: Result := 'O';
    6480: Result := 'P';
    6875: Result := '[';
    7133: Result := ']';
    11228: Result := '\';
    7745: Result := 'A';
    8019: Result := 'S';
    8260: Result := 'D';
    8518: Result := 'F';
    8775: Result := 'G';
    9032: Result := 'H';
    9290: Result := 'J';
    9547: Result := 'K';
    9804: Result := 'L';
    10170: Result := ';';
    10462: Result := '''';
    11354: Result := 'Z';
    11608: Result := 'X';
    11843: Result := 'C';
    12118: Result := 'V';
    12354: Result := 'B';
    12622: Result := 'N';
    12877: Result := 'M';
    13244: Result := ',';
    13502: Result := '.';
    13759: Result := '/';
    13840: Result := 'ÓÒShift';
    14624: Result := 'Space';
    283: Result := 'Esc';
    15216: Result := 'F1';
    15473: Result := 'F2';
    15730: Result := 'F3';
    15987: Result := 'F4';
    16244: Result := 'F5';
    16501: Result := 'F6';
    16758: Result := 'F7';
    17015: Result := 'F8';
    17272: Result := 'F9';
    17529: Result := 'F10]';
    22394: Result := 'F11]';
    22651: Result := 'F12]';
    10768: Result := 'LShift]';
    14868: Result := 'CapsLock]';
    3592: Result := 'Backspace]';
    3849: Result := '[Tab]';
    7441:
      if wp > 30000 then
        Result := '[RCtrl]'
      else
        Result := '[LCtrl]';
    13679: Result := '[Num/]';
    17808: Result := '[NumLock]';
    300: Result := '[PrintScreen]';
    18065: Result := '[ScrollLock]';
    17683: Result := '[Pause]';
    21088: Result := '[Num0]';
    21358: Result := '[Num.]';
    20321: Result := '[Num1]';
    20578: Result := '[Num2]';
    20835: Result := '[Num3]';
    19300: Result := '[Num4]';
    19557: Result := '[Num5]';
    19814: Result := '[Num6]';
    18279: Result := '[Num7]';
    18536: Result := '[Num8]';
    18793: Result := '[Num9]';
    19468: Result := '[*5*]';
    14186: Result := '[Num *]';
    19053: Result := '[Num -]';
    20075: Result := '[Num +]';
    21037: Result := '[Insert]';
    21294: Result := '[Delete]';
    18212: Result := '[Home]';
    20259: Result := '[End]';
    18721: Result := '[PageUp]';
    20770: Result := '[PageDown]';
    18470: Result := '[UP]';
    20520: Result := '[DOWN]';
    19237: Result := '[LEFT]';
    19751: Result := '[RIGHT]';
    7181: Result := '[Enter]';
  end;
end;


function fmstr(Str: string; len: Integer): string;
var I: Integer;
begin
  try
    Result := Str + ' ';
    for I := 1 to len - Length(Str) - 1 do
      Result := Result + ' ';
  except
    Result := Str + ' ';
  end;
end;

function GetGoldStr(gold: Integer): string;
var
  I, n: Integer;
  Str: string;
begin
  Str := IntToStr(gold);
  n := 0;
  Result := '';
  for I := Length(Str) downto 1 do begin
    if n = 3 then begin
      Result := Str[I] + ',' + Result;
      n := 1;
    end else begin
      Result := Str[I] + Result;
      Inc(n);
    end;
  end;
end;


{----------------------------------------------------------}

function GetDistance(sx, sY, dx, dy: Integer): Integer;
begin
  Result := _MAX(abs(sx - dx), abs(sY - dy));
end;

procedure GetNextPosXY(dir: BYTE; var X, Y: Integer);
begin
  case dir of
    DR_UP: begin
        X := X; Y := Y - 1; end;
    DR_UPRIGHT: begin
        X := X + 1; Y := Y - 1; end;
    DR_RIGHT: begin
        X := X + 1; Y := Y; end;
    DR_DOWNRIGHT: begin
        X := X + 1; Y := Y + 1; end;
    DR_DOWN: begin
        X := X; Y := Y + 1; end;
    DR_DOWNLEFT: begin
        X := X - 1; Y := Y + 1; end;
    DR_LEFT: begin
        X := X - 1; Y := Y; end;
    DR_UPLEFT: begin
        X := X - 1; Y := Y - 1; end;
  end;
end;

procedure GetNextRunXY(dir: BYTE; var X, Y: Integer);
begin
  case dir of
    DR_UP: begin
        X := X; Y := Y - 2; end;
    DR_UPRIGHT: begin
        X := X + 2; Y := Y - 2; end;
    DR_RIGHT: begin
        X := X + 2; Y := Y; end;
    DR_DOWNRIGHT: begin
        X := X + 2; Y := Y + 2; end;
    DR_DOWN: begin
        X := X; Y := Y + 2; end;
    DR_DOWNLEFT: begin
        X := X - 2; Y := Y + 2; end;
    DR_LEFT: begin
        X := X - 2; Y := Y; end;
    DR_UPLEFT: begin
        X := X - 2; Y := Y - 2; end;
  end;
end;

procedure GetNextHorseRunXY(dir: BYTE; var X, Y: Integer);
begin
  case dir of
    DR_UP: begin
        X := X; Y := Y - 3; end;
    DR_UPRIGHT: begin
        X := X + 3; Y := Y - 3; end;
    DR_RIGHT: begin
        X := X + 3; Y := Y; end;
    DR_DOWNRIGHT: begin
        X := X + 3; Y := Y + 3; end;
    DR_DOWN: begin
        X := X; Y := Y + 3; end;
    DR_DOWNLEFT: begin
        X := X - 3; Y := Y + 3; end;
    DR_LEFT: begin
        X := X - 3; Y := Y; end;
    DR_UPLEFT: begin
        X := X - 3; Y := Y - 3; end;
  end;
end;

function GetNextDirection(sx, sY, dx, dy: Integer): BYTE;
var
  flagx, flagy: Integer;
begin
  Result := DR_DOWN;
  if sx < dx then flagx := 1
  else if sx = dx then flagx := 0
  else flagx := -1;
  if abs(sY - dy) > 2
    then if (sx >= dx - 1) and (sx <= dx + 1) then flagx := 0;

  if sY < dy then flagy := 1
  else if sY = dy then flagy := 0
  else flagy := -1;
  if abs(sx - dx) > 2 then if (sY > dy - 1) and (sY <= dy + 1) then flagy := 0;

  if (flagx = 0) and (flagy = -1) then Result := DR_UP;
  if (flagx = 1) and (flagy = -1) then Result := DR_UPRIGHT;
  if (flagx = 1) and (flagy = 0) then Result := DR_RIGHT;
  if (flagx = 1) and (flagy = 1) then Result := DR_DOWNRIGHT;
  if (flagx = 0) and (flagy = 1) then Result := DR_DOWN;
  if (flagx = -1) and (flagy = 1) then Result := DR_DOWNLEFT;
  if (flagx = -1) and (flagy = 0) then Result := DR_LEFT;
  if (flagx = -1) and (flagy = -1) then Result := DR_UPLEFT;
end;

function GetBack(dir: Integer): Integer;
begin
  Result := DR_UP;
  case dir of
    DR_UP: Result := DR_DOWN;
    DR_DOWN: Result := DR_UP;
    DR_LEFT: Result := DR_RIGHT;
    DR_RIGHT: Result := DR_LEFT;
    DR_UPLEFT: Result := DR_DOWNRIGHT;
    DR_UPRIGHT: Result := DR_DOWNLEFT;
    DR_DOWNLEFT: Result := DR_UPRIGHT;
    DR_DOWNRIGHT: Result := DR_UPLEFT;
  end;
end;

procedure GetBackPosition(sx, sY, dir: Integer; var NewX, NewY: Integer);
begin
  NewX := sx;
  NewY := sY;
  case dir of
    DR_UP: NewY := NewY + 1;
    DR_DOWN: NewY := NewY - 1;
    DR_LEFT: NewX := NewX + 1;
    DR_RIGHT: NewX := NewX - 1;
    DR_UPLEFT: begin
        NewX := NewX + 1;
        NewY := NewY + 1;
      end;
    DR_UPRIGHT: begin
        NewX := NewX - 1;
        NewY := NewY + 1;
      end;
    DR_DOWNLEFT: begin
        NewX := NewX + 1;
        NewY := NewY - 1;
      end;
    DR_DOWNRIGHT: begin
        NewX := NewX - 1;
        NewY := NewY - 1;
      end;
  end;
end;

procedure GetFrontPosition(sx, sY, dir: Integer; var NewX, NewY: Integer);
begin
  NewX := sx;
  NewY := sY;
  case dir of
    DR_UP: NewY := NewY - 1;
    DR_DOWN: NewY := NewY + 1;
    DR_LEFT: NewX := NewX - 1;
    DR_RIGHT: NewX := NewX + 1;
    DR_UPLEFT: begin
        NewX := NewX - 1;
        NewY := NewY - 1;
      end;
    DR_UPRIGHT: begin
        NewX := NewX + 1;
        NewY := NewY - 1;
      end;
    DR_DOWNLEFT: begin
        NewX := NewX - 1;
        NewY := NewY + 1;
      end;
    DR_DOWNRIGHT: begin
        NewX := NewX + 1;
        NewY := NewY + 1;
      end;
  end;
end;

procedure GetFrontPosition(sx, sY, dir, nFlag: Integer; var NewX, NewY: Integer);
begin
  NewX := sx;
  NewY := sY;
  case dir of
    DR_UP: NewY := NewY - nFlag;
    DR_DOWN: NewY := NewY + nFlag;
    DR_LEFT: NewX := NewX - nFlag;
    DR_RIGHT: NewX := NewX + nFlag;
    DR_UPLEFT: begin
        NewX := NewX - nFlag;
        NewY := NewY - nFlag;
      end;
    DR_UPRIGHT: begin
        NewX := NewX + nFlag;
        NewY := NewY - nFlag;
      end;
    DR_DOWNLEFT: begin
        NewX := NewX - nFlag;
        NewY := NewY + nFlag;
      end;
    DR_DOWNRIGHT: begin
        NewX := NewX + nFlag;
        NewY := NewY + nFlag;
      end;
  end;
end;

function GetFlyDirection(sx, sY, ttx, tty: Integer): Integer;
var
  fx, fy: Real;
begin
  fx := ttx - sx;
  fy := tty - sY;
  sx := 0;
  sY := 0;
  Result := DR_DOWN;
  if fx = 0 then begin
    if fy < 0 then Result := DR_UP
    else Result := DR_DOWN;
    Exit;
  end;
  if fy = 0 then begin
    if fx < 0 then Result := DR_LEFT
    else Result := DR_RIGHT;
    Exit;
  end;
  if (fx > 0) and (fy < 0) then begin
    if - fy > fx * 2.5 then Result := DR_UP
    else if - fy < fx / 3 then Result := DR_RIGHT
    else Result := DR_UPRIGHT;
  end;
  if (fx > 0) and (fy > 0) then begin
    if fy < fx / 3 then Result := DR_RIGHT
    else if fy > fx * 2.5 then Result := DR_DOWN
    else Result := DR_DOWNRIGHT;
  end;
  if (fx < 0) and (fy > 0) then begin
    if fy < -fx / 3 then Result := DR_LEFT
    else if fy > -fx * 2.5 then Result := DR_DOWN
    else Result := DR_DOWNLEFT;
  end;
  if (fx < 0) and (fy < 0) then begin
    if - fy > -fx * 2.5 then Result := DR_UP
    else if - fy < -fx / 3 then Result := DR_LEFT
    else Result := DR_UPLEFT;
  end;
end;

function GetFlyDirection16(sx, sY, ttx, tty: Integer): Integer;
var
  fx, fy: Real;
begin
  fx := ttx - sx;
  fy := tty - sY;
  sx := 0;
  sY := 0;
  Result := 0;
  if fx = 0 then begin
    if fy < 0 then Result := 0
    else Result := 8;
    Exit;
  end;
  if fy = 0 then begin
    if fx < 0 then Result := 12
    else Result := 4;
    Exit;
  end;
  if (fx > 0) and (fy < 0) then begin
    Result := 4;
    if - fy > fx / 4 then Result := 3;
    if - fy > fx / 1.9 then Result := 2;
    if - fy > fx * 1.4 then Result := 1;
    if - fy > fx * 4 then Result := 0;
  end;
  if (fx > 0) and (fy > 0) then begin
    Result := 4;
    if fy > fx / 4 then Result := 5;
    if fy > fx / 1.9 then Result := 6;
    if fy > fx * 1.4 then Result := 7;
    if fy > fx * 4 then Result := 8;
  end;
  if (fx < 0) and (fy > 0) then begin
    Result := 12;
    if fy > -fx / 4 then Result := 11;
    if fy > -fx / 1.9 then Result := 10;
    if fy > -fx * 1.4 then Result := 9;
    if fy > -fx * 4 then Result := 8;
  end;
  if (fx < 0) and (fy < 0) then begin
    Result := 12;
    if - fy > -fx / 4 then Result := 13;
    if - fy > -fx / 1.9 then Result := 14;
    if - fy > -fx * 1.4 then Result := 15;
    if - fy > -fx * 4 then Result := 0;
  end;
end;

function PrivDir(ndir: Integer): Integer;
begin
  if ndir - 1 < 0 then Result := 7
  else Result := ndir - 1;
end;

function NextDir(ndir: Integer): Integer;
begin
  if ndir + 1 > 7 then Result := 0
  else Result := ndir + 1;
end;

{procedure BoldTextOut(Surface: TDirectDrawSurface; X, Y, FColor, Bcolor: Integer; Str: string); //Êä³ö¶¶¶¯¼Ó´Ö
begin
  with Surface do begin
    Canvas.Font.Color := Bcolor;
    Canvas.TextOut(X - 1, Y, Str);
    Canvas.TextOut(X + 1, Y, Str);
    Canvas.TextOut(X, Y - 1, Str);
    Canvas.TextOut(X, Y + 1, Str);
    Canvas.Font.Color := FColor;
    Canvas.TextOut(X, Y, Str);
  end;
end;

procedure BoldTextOut(Surface: TDirectDrawSurface; Rect: TRect; X, Y, FColor, Bcolor: Integer; Str: string);
var
  rc1, rc2, rc3, rc4: TRect;
begin
  with Surface do begin
    Canvas.Brush.Style := bsClear;
    Canvas.Font.Color := Bcolor;
    rc1 := Rect;
    rc2 := Rect;
    rc3 := Rect;
    rc4 := Rect;

    Dec(rc1.Left);
    Dec(rc1.Right);

    Inc(rc2.Left);
    Inc(rc2.Right);

    Dec(rc3.Top);
    Dec(rc3.Bottom);

    Inc(rc4.Top);
    Inc(rc4.Bottom);

    Canvas.TextRect(rc1, X + 1, Y, Str);
    Canvas.TextRect(rc2, X - 1, Y, Str);
    Canvas.TextRect(rc3, X, Y - 1, Str);
    Canvas.TextRect(rc4, X, Y + 1, Str);

    Canvas.Font.Color := FColor;
    Canvas.TextRect(Rect, X, Y, Str);
  end;
end;    }

function GetTakeOnPosition(smode: Integer): Integer;
begin
  Result := -1;
  {
  case smode of //StdMode
     5, 6: //ÎäÆ÷
        Result := U_WEAPON;
     10, 11:
        Result := U_DRESS;
     15,16:
        Result := U_HELMET;
     19,20,21:
        Result := U_NECKLACE;
     22,23:
        Result := U_RINGL;
     24,26:
        Result := U_ARMRINGR;
     25:
        Result := U_ARMRINGL;
     30:
        Result := U_RIGHTHAND;
  end;
  }
  case smode of //StdMode
    5, 6: Result := U_WEAPON; //ÎäÆ÷
    10, 11: Result := U_DRESS;
    15, 16: Result := U_HELMET;
    19, 20, 21: Result := U_NECKLACE;
    22, 23: Result := U_RINGL;
    24, 26: Result := U_ARMRINGR;
    30, 28, 29: Result := U_RIGHTHAND;
    25, 51: Result := U_BUJUK; //·û
    52, 62: Result := U_BOOTS; //Ð¬
    7, 53, 63: Result := U_CHARM; //±¦Ê¯
    54, 64: Result := U_BELT; //Ñü´ø
  end;
end;

function IsKeyPressed(Key: BYTE): Boolean;
var
  KeyValue: TKeyBoardState;
begin
  Result := False;
  FillChar(KeyValue, SizeOf(TKeyBoardState), #0);
  if GetKeyboardState(KeyValue) then
    if (KeyValue[Key] and $80) <> 0 then
      Result := True;
end;


initialization

finalization


end.

