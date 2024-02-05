unit NpcMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CMain, ExtCtrls;

type
  TNpcDlg = class

  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Show(nRecogID: Integer; sData: string);
    procedure Close;
  published
    //property InputString: string read FInputString write FInputString;
  end;

  TNpcLabel = class(TLabel)
  private
    m_nColorPosition: Integer;
  public
    m_sClickString: string;
    m_ColorList: TList;
    m_nRecogId: Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Run;
    procedure AddColor(btColor: Byte);
  end;

  TfrmNpc = class(TForm)
    Timer: TTimer;
    procedure LabelClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
    function CreateLabel(nX, nY, nRecogID: Integer; FColor: TColor; sData: string; boClick: Boolean): TNpcLabel;
  public
    { Public declarations }
    procedure Open(nRecogID: Integer; sData: string);
  end;
procedure FreeLabelList();
var
  frmNpc: TfrmNpc;
  LabelList: TList;
implementation
uses HUtil32, Share;
{$R *.dfm}
constructor TNpcDlg.Create(AOwner: TComponent);
begin
  LabelList := TList.Create;
  frmNpc := TfrmNpc.Create(AOwner);
end;

destructor TNpcDlg.Destroy;
var
  I: Integer;
begin
  for I := 0 to LabelList.Count - 1 do begin
    TNpcLabel(LabelList.Items[I]).Free;
  end;
  LabelList.Free;
end;

procedure FreeLabelList();
var
  I: Integer;
begin
  for I := 0 to LabelList.Count - 1 do begin
    TNpcLabel(LabelList.Items[I]).Free;
  end;
  LabelList.Free;
end;

procedure TNpcDlg.Show(nRecogID: Integer; sData: string);
begin
  frmNpc.Close;
  frmNpc.Open(nRecogID, sData);
end;

procedure TNpcDlg.Close;
begin
  frmNpc.Close;
end;

constructor TNpcLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  m_nColorPosition := -1;
  m_nRecogId := -1;
  m_sClickString := '';
  m_ColorList := TList.Create;
end;

destructor TNpcLabel.Destroy;
begin
  m_ColorList.Free;
  inherited;
end;

procedure TNpcLabel.AddColor(btColor: Byte);
begin
  m_ColorList.Add(Pointer(btColor));
end;

procedure TNpcLabel.Run;
begin
  if m_ColorList.Count > 0 then begin
    if (m_nColorPosition >= 0) and (m_nColorPosition < m_ColorList.Count) then begin
      Font.Color := frmCMain.GetRGB(Integer(m_ColorList.Items[m_nColorPosition]));
      Inc(m_nColorPosition);
    end else begin
      m_nColorPosition := 0;
    end;
  end;
end;

procedure TfrmNpc.LabelClick(Sender: TObject);
begin
  frmCMain.SendMerchantDlgSelect(TNpcLabel(Sender).m_nRecogId, TNpcLabel(Sender).m_sClickString);
end;

function TfrmNpc.CreateLabel(nX, nY, nRecogID: Integer; FColor: TColor; sData: string; boClick: Boolean): TNpcLabel;
var
  NpcLabel: TNpcLabel;
begin
  NpcLabel := TNpcLabel.Create(Self.Owner);
  LabelList.Add(NpcLabel);
  NpcLabel.Parent := Self;
  NpcLabel.Caption := sData;
  NpcLabel.Left := nX;
  NpcLabel.top := nY;
  NpcLabel.Font.Color := FColor;
  //NPCLabel.Font.Size := 10;
  NpcLabel.m_nRecogId := nRecogID;
  NpcLabel.Transparent := True;
  if boClick then begin
    NpcLabel.OnClick := LabelClick;
    NpcLabel.Cursor := crHandPoint;
  end;
  Result := NpcLabel;
end;

procedure TfrmNpc.Open(nRecogID: Integer; sData: string);
var
  Str, data, fdata, cmdstr, cmdmsg, cmdparam: string;
  lx, ly, sx: Integer;
  drawcenter: Boolean;
  nLength: Integer;
  btColor: Byte;
  UseColor: TColor;
  sColor: string;
  sNPCName: string;
  TempList: TStringList;
  I: Integer;
  NpcLabel: TNpcLabel;
  NpcLabelCmd: TNpcLabel;
  nPos: Integer;
  nAddY: Integer;
begin
  try
    for I := 0 to LabelList.Count - 1 do begin
      TNpcLabel(LabelList.Items[I]).Free;
    end;
    LabelList.Clear;

    Str := sData;
    Str := GetValidStr3(Str, sNPCName, ['/']);
    Caption := sNPCName;
    UseColor := clRed;
    lx := 20;
    ly := 15;
    drawcenter := False;
    TempList := TStringList.Create;
    NpcLabel := nil;
    NpcLabelCmd := nil;
    while True do begin
      if Str = '' then Break;
      Str := GetValidStr3(Str, data, ['\']);
      if data <> '' then begin
        sx := 0;
        fdata := '';
        while (Pos('<', data) > 0) and (Pos('>', data) > 0) and (data <> '') do begin
          if data[1] <> '<' then begin
            data := '<' + GetValidStr3(data, fdata, ['<']);
          end;
          data := ArrestStringEx(data, '<', '>', cmdstr);
          if cmdstr <> '' then begin
            cmdparam := GetValidStr3(cmdstr, cmdstr, ['/']); //cmdparam :
          end else begin
            Continue;
          end;
          if fdata <> '' then begin
            NpcLabel := CreateLabel(lx + sx, ly, nRecogID, clWhite, fdata, False);
            sx := sx + NpcLabel.Canvas.TextWidth(fdata);
          end;
          if (Length(cmdparam) > 0) and (cmdparam[1] <> '@') then begin
            nLength := CompareText(cmdparam, 'FCOLOR=');
            if (nLength > 0) and (Length(cmdparam) > Length('FCOLOR=')) then begin
              sColor := Copy(cmdparam, Length('FCOLOR=') + 1, nLength);
              btColor := Str_ToInt(sColor, 100);
              UseColor := frmCMain.GetRGB(btColor);
              cmdparam := '';
            end else
              nLength := CompareText(cmdparam, 'AUTOCOLOR='); //2007-2-28 Mars增加自动变色NPC字体
            if (nLength >= 0) and (Length(cmdparam) >= Length('AUTOCOLOR=')) then begin
              sColor := Copy(cmdparam, Length('AUTOCOLOR=') + 1, nLength);
              if Pos(',', sColor) > 0 then begin
                TempList.Clear;
                ExtractStrings([','], [], PChar(sColor), TempList);
              end;
              cmdparam := '';
            end else begin

            end;
          end;
          if (Length(cmdparam) > 0) and (cmdparam[1] = '@') then begin
            NpcLabelCmd := CreateLabel(lx + sx, ly, nRecogID, clYellow, cmdstr, True);
            NpcLabelCmd.Font.Style := NpcLabelCmd.Font.Style + [fsUnderline];
          end else begin
            NpcLabelCmd := CreateLabel(lx + sx, ly, nRecogID, UseColor, cmdstr, False);
            if TempList.Count > 0 then begin
              for I := 0 to TempList.Count - 1 do begin
                NpcLabelCmd.AddColor(Str_ToInt(TempList.Strings[I], 100));
              end;
              TempList.Clear;
            end;
          end;
          sx := sx + NpcLabelCmd.Canvas.TextWidth(cmdstr);
          NpcLabelCmd.m_sClickString := cmdparam;
        end; // while (Pos('<', data) > 0)
        if data <> '' then begin
          NpcLabel := CreateLabel(lx + sx, ly, nRecogID, clWhite, data, False);
        end;
        Inc(ly, 12);
      end else Inc(ly, 12);
    end;
    TempList.Free;
  except
    Timer.Enabled := False;
  end;
  Timer.Enabled := True;
  Show;
  //Timer.Enabled := FALSE;
end;

procedure TfrmNpc.TimerTimer(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to LabelList.Count - 1 do begin
    TNpcLabel(LabelList.Items[I]).Run;
  end;
end;

end.

