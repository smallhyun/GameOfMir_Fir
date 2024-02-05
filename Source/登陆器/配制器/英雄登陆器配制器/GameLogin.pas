unit GameLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, RzBmpBtn, ComCtrls, OleCtrls, SHDocVw,
  Menus, ExtDlgs, HUtil32, Share, RzForms, SizerControl, Magnetic;

type
  TFrmGameLogin = class(TForm)
    RzBmpButtonUpgrade: TRzBmpButton;
    RzBmpButtonStart: TRzBmpButton;
    RzBmpButtonNewAccount: TRzBmpButton;
    RzBmpButtonMin: TRzBmpButton;
    RzBmpButtonHomePage: TRzBmpButton;
    RzBmpButtonGetBakPassWord: TRzBmpButton;
    RzBmpButtonFullScreenStart: TRzBmpButton;
    RzBmpButtonExitGame: TRzBmpButton;
    RzBmpButtonEditGameList: TRzBmpButton;
    RzBmpButtonClose: TRzBmpButton;
    RzBmpButtonChgPassWord: TRzBmpButton;
    PopupMenu: TPopupMenu;
    MenuUP: TMenuItem;
    MenuHot: TMenuItem;
    MenuDown: TMenuItem;
    MenuDisabled: TMenuItem;
    MenuVisible: TMenuItem;
    RzBmpButtonAutoLogin: TRzBmpButton;
    OpenPictureDialog: TOpenPictureDialog;
    TreeView: TTreeView;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    PopupMenu1: TPopupMenu;
    MenuLabelVisible: TMenuItem;
    MenuLabelFColor: TMenuItem;
    PopupMenu2: TPopupMenu;
    MenuViewVisible: TMenuItem;
    MenuViewFColor: TMenuItem;
    MenuViewBColor: TMenuItem;
    ColorDialog: TColorDialog;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    Image: TRzFormShape;
    Label1: TLabel;
    LabelStatus: TLabel;
    SizeControl: TSizeControl;
    PopupMenu3: TPopupMenu;
    MenuMain: TMenuItem;
    MenuLoadConfig: TMenuItem;
    MenuSaveConfig: TMenuItem;
    N8: TMenuItem;
    MenoClose: TMenuItem;
    MenuTransparent: TMenuItem;
    N3: TMenuItem;
    N1: TMenuItem;
    ComboBox: TComboBox;
    WebBrowser: TMemo;
    procedure ImageDblClick(Sender: TObject);
    procedure MenuMainClick(Sender: TObject);
    procedure Resizer1ControlMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MenuUPClick(Sender: TObject);
    procedure MenuHotClick(Sender: TObject);
    procedure MenuDownClick(Sender: TObject);
    procedure MenuDisabledClick(Sender: TObject);
    procedure MenuVisibleClick(Sender: TObject);
    procedure Resizer1ControlMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure MenuLoadConfigClick(Sender: TObject);
    procedure MenuSaveConfigClick(Sender: TObject);
    procedure MenuLabelVisibleClick(Sender: TObject);
    procedure Resizer13ControlMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MenuLabelFColorClick(Sender: TObject);
    procedure MenuViewFColorClick(Sender: TObject);
    procedure MenuViewBColorClick(Sender: TObject);
    procedure MenuViewVisibleClick(Sender: TObject);
    procedure Resizer14ControlMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure Label1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SizeControlTargetChanging(Sender: TObject;
      NewTarget: TControl; var IsValidTarget: Boolean);
    procedure MenoCloseClick(Sender: TObject);
    procedure MenuTransparentClick(Sender: TObject);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure TreeViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SizeControlResized(Sender: TObject; ControlRect: TRect);
    procedure SizeControlMoved(Sender: TObject; ControlRect: TRect);
    procedure FormPaint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    procedure SaveSkinToFile(FileName: string);
  public
    procedure WMEnterSizeMove(var Msg: TMessage); message WM_ENTERSIZEMOVE;
    procedure WMSizing(var Msg: TMessage); message WM_SIZING;
    procedure WMMoving(var Msg: TMessage); message WM_MOVING;
    procedure WMExitSizeMove(var Msg: TMessage); message WM_EXITSIZEMOVE;
    procedure WMSysCommand(var Msg: TMessage); message WM_SYSCOMMAND;
    procedure WMCommand(var Msg: TMessage); message WM_COMMAND;
    procedure Open;
  end;

var
  FrmGameLogin: TFrmGameLogin;
  SelBmpButton: TRzBmpButton;
implementation

uses Objects;
{$R *.dfm}
var
  MagneticWndProc: TSubClass_Proc;
  dummyHandled: Boolean;
  MagneticAddWindow: Boolean;

procedure TFrmGameLogin.WMEnterSizeMove(var Msg: TMessage);
begin
  inherited;

  if Assigned(MagneticWndProc) then
    MagneticWndProc(Self.Handle, WM_ENTERSIZEMOVE, Msg, dummyHandled);
end;

procedure TFrmGameLogin.WMSizing(var Msg: TMessage);
var
  bHandled: Boolean;
begin
  if not Assigned(MagneticWndProc) then
    inherited
  else
    if MagneticWndProc(Self.Handle, WM_SIZING, Msg, bHandled) then
    if not bHandled then
      inherited;
end;

procedure TFrmGameLogin.WMMoving(var Msg: TMessage);
var
  bHandled: Boolean;
begin
  if not Assigned(MagneticWndProc) then
    inherited
  else
    if MagneticWndProc(Self.Handle, WM_MOVING, Msg, bHandled) then
    if not bHandled then
      inherited;
end;

procedure TFrmGameLogin.WMExitSizeMove(var Msg: TMessage);
begin
  inherited;

  if Assigned(MagneticWndProc) then
    MagneticWndProc(Self.Handle, WM_EXITSIZEMOVE, Msg, dummyHandled);
end;

procedure TFrmGameLogin.WMSysCommand(var Msg: TMessage);
begin
  inherited;

  if Assigned(MagneticWndProc) then
    MagneticWndProc(Self.Handle, WM_SYSCOMMAND, Msg, dummyHandled);
end;

procedure TFrmGameLogin.WMCommand(var Msg: TMessage);
begin
  inherited;

  if Assigned(MagneticWndProc) then
    MagneticWndProc(Self.Handle, WM_COMMAND, Msg, dummyHandled);
end;

//------------------ end of Custom Message Handling procedures -------------------


// procedure to subclass ChildForms window procedure for magnetic effect.

function SubFormWindowProc(Wnd: HWND; Msg, wParam, lParam: Integer): Integer; stdcall;
var
  Handled: boolean;
  Message_: TMessage;
  OrgWndProc: Integer;
begin
  Result := 0;

  if not Assigned(MagneticWndProc) then
  begin
    Result := CallWindowProc(Pointer(OrgWndProc), Wnd, Msg, wParam, lParam);
    exit;
  end;

  OrgWndProc := GetWindowLong(Wnd, GWL_USERDATA);
  if (OrgWndProc = 0) then
    exit;

  Message_.WParam := wParam;
  Message_.LParam := lParam;
  Message_.Result := 0;

  if (Msg = WM_SYSCOMMAND) or (Msg = WM_ENTERSIZEMOVE) or (Msg = WM_EXITSIZEMOVE) or
    (Msg = WM_WINDOWPOSCHANGED) or (Msg = WM_COMMAND) then
  begin
    Result := CallWindowProc(Pointer(OrgWndProc), Wnd, Msg, wParam, lParam);
    MagneticWndProc(Wnd, Msg, Message_, dummyHandled);
  end else if (Msg = WM_MOVING) or (Msg = WM_SIZING) then
  begin
    MagneticWndProc(Wnd, Msg, Message_, Handled);
    if Handled then
    begin
      Result := Message_.Result;
      exit;
    end else
      Result := CallWindowProc(Pointer(OrgWndProc), Wnd, Msg, wParam, lParam);
  end else if (Msg = WM_DESTROY) then
  begin
    if Assigned(MagneticWnd) then
      MagneticWnd.RemoveWindow(Wnd);
    Result := CallWindowProc(Pointer(OrgWndProc), Wnd, Msg, wParam, lParam);
  end else
    Result := CallWindowProc(Pointer(OrgWndProc), Wnd, Msg, wParam, lParam);
end;

procedure TFrmGameLogin.ImageDblClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmGameLogin.MenuMainClick(Sender: TObject);
var
  ext: string;
  I: Integer;
  Picture: TJpegImage;
  Bitmap: TBitmap;
begin
  if OpenPictureDialog.Execute and (OpenPictureDialog.FileName <> '') then begin

    ext := ExtractFileExt(OpenPictureDialog.FileName);
    if (SameText(ext, '.jpg')) or (SameText(ext, '.jpeg')) then begin
      Picture := TJpegImage.Create;
      Picture.LoadFromFile(OpenPictureDialog.FileName);
      FrmGameLogin.ClientHeight := Picture.Height;
      FrmGameLogin.ClientWidth := Picture.Width;
      Image.Picture.Bitmap.Assign(Picture);
      //g_Bitmap.Assign(Image.Picture.Bitmap);
      //Image.Transparent := True;
     { Image.Picture.Bitmap.TransparentColor := clBlack;
      Image.Picture.Bitmap.Transparent := True;}
      Image.Transparent := g_boTransparent;
      if g_boTransparent then
        Image.RecreateRegion;
      Picture.Free;
    end else
      if (SameText(ext, '.bmp')) then begin
      Bitmap := TBitmap.Create;
      Bitmap.LoadFromFile(OpenPictureDialog.FileName);
      Bitmap.TransparentColor := clBlack;
      Bitmap.Transparent := True;
      FrmGameLogin.ClientHeight := Bitmap.Height;
      FrmGameLogin.ClientWidth := Bitmap.Width;
      Image.Picture.Bitmap.Assign(Bitmap);
      //g_Bitmap.Assign(Image.Picture.Bitmap);
      //Image.Transparent := True;
     { Image.Picture.Bitmap.TransparentColor := clRed;
      Image.Picture.Bitmap.Transparent := True;  }
      Image.Transparent := g_boTransparent;
      if g_boTransparent then
        Image.RecreateRegion;
      Bitmap.Free;
    end;
    {
    if TreeView.Left + TreeView.Width <= 0 then TreeView.Left := 0;
    if WebBrowser.Left + WebBrowser.Width <= 0 then WebBrowser.Left := 0;
    if LabelStatus.Left + LabelStatus.Width <= 0 then LabelStatus.Left := 0;
    if RzBmpButtonAutoLogin.Left + RzBmpButtonAutoLogin.Width <= 0 then RzBmpButtonAutoLogin.Left := 0;
    if RzBmpButtonChgPassWord.Left + RzBmpButtonChgPassWord.Width <= 0 then RzBmpButtonChgPassWord.Left := 0;
    if RzBmpButtonClose.Left + RzBmpButtonClose.Width <= 0 then RzBmpButtonClose.Left := 0;
    if RzBmpButtonEditGameList.Left + RzBmpButtonEditGameList.Width <= 0 then RzBmpButtonEditGameList.Left := 0;
    if RzBmpButtonExitGame.Left + RzBmpButtonExitGame.Width <= 0 then RzBmpButtonExitGame.Left := 0;

    if RzBmpButtonFullScreenStart.Left + RzBmpButtonFullScreenStart.Width <= 0 then RzBmpButtonFullScreenStart.Left := 0;
    if RzBmpButtonGetBakPassWord.Left + RzBmpButtonGetBakPassWord.Width <= 0 then RzBmpButtonGetBakPassWord.Left := 0;
    if RzBmpButtonHomePage.Left + RzBmpButtonHomePage.Width <= 0 then RzBmpButtonHomePage.Left := 0;
    if RzBmpButtonMin.Left + RzBmpButtonMin.Width <= 0 then RzBmpButtonMin.Left := 0;
    if RzBmpButtonNewAccount.Left + RzBmpButtonNewAccount.Width <= 0 then RzBmpButtonNewAccount.Left := 0;
    if RzBmpButtonStart.Left + RzBmpButtonStart.Width <= 0 then RzBmpButtonStart.Left := 0;
    if RzBmpButtonUpgrade.Left + RzBmpButtonUpgrade.Width <= 0 then RzBmpButtonUpgrade.Left := 0;


    if TreeView.Top + TreeView.Height <= 0 then TreeView.Top := 0;
    if WebBrowser.Top + WebBrowser.Height <= 0 then WebBrowser.Top := 0;
    if LabelStatus.Top + LabelStatus.Height <= 0 then LabelStatus.Top := 0;
    if RzBmpButtonAutoLogin.Top + RzBmpButtonAutoLogin.Height <= 0 then RzBmpButtonAutoLogin.Top := 0;
    if RzBmpButtonChgPassWord.Top + RzBmpButtonChgPassWord.Height <= 0 then RzBmpButtonChgPassWord.Top := 0;
    if RzBmpButtonClose.Top + RzBmpButtonClose.Height <= 0 then RzBmpButtonClose.Top := 0;
    if RzBmpButtonEditGameList.Top + RzBmpButtonEditGameList.Height <= 0 then RzBmpButtonEditGameList.Top := 0;
    if RzBmpButtonExitGame.Top + RzBmpButtonExitGame.Height <= 0 then RzBmpButtonExitGame.Top := 0;

    if RzBmpButtonFullScreenStart.Top + RzBmpButtonFullScreenStart.Height <= 0 then RzBmpButtonFullScreenStart.Top := 0;
    if RzBmpButtonGetBakPassWord.Top + RzBmpButtonGetBakPassWord.Height <= 0 then RzBmpButtonGetBakPassWord.Top := 0;
    if RzBmpButtonHomePage.Top + RzBmpButtonHomePage.Height <= 0 then RzBmpButtonHomePage.Top := 0;
    if RzBmpButtonMin.Top + RzBmpButtonMin.Height <= 0 then RzBmpButtonMin.Top := 0;
    if RzBmpButtonNewAccount.Top + RzBmpButtonNewAccount.Height <= 0 then RzBmpButtonNewAccount.Top := 0;
    if RzBmpButtonStart.Top + RzBmpButtonStart.Height <= 0 then RzBmpButtonStart.Top := 0;
    if RzBmpButtonUpgrade.Top + RzBmpButtonUpgrade.Height <= 0 then RzBmpButtonUpgrade.Top := 0;


    if TreeView.Top <= Height then TreeView.Top := Height - TreeView.Height;
    if WebBrowser.Top <= Height then WebBrowser.Top := Height - WebBrowser.Height;
    if LabelStatus.Top <= Height then LabelStatus.Top := Height - LabelStatus.Height;
    if RzBmpButtonAutoLogin.Top <= Height then RzBmpButtonAutoLogin.Top := Height - +RzBmpButtonAutoLogin.Height;
    if RzBmpButtonChgPassWord.Top <= Height then RzBmpButtonChgPassWord.Top := Height - RzBmpButtonChgPassWord.Height;
    if RzBmpButtonClose.Top <= Height then RzBmpButtonClose.Top := Height - RzBmpButtonClose.Height;
    if RzBmpButtonEditGameList.Top <= Height then RzBmpButtonEditGameList.Top := Height - RzBmpButtonEditGameList.Height;
    if RzBmpButtonExitGame.Top <= Height then RzBmpButtonExitGame.Top := Height - RzBmpButtonExitGame.Height;

    if RzBmpButtonFullScreenStart.Top <= Height then RzBmpButtonFullScreenStart.Top := Height - RzBmpButtonFullScreenStart.Height;
    if RzBmpButtonGetBakPassWord.Top <= Height then RzBmpButtonGetBakPassWord.Top := Height - RzBmpButtonGetBakPassWord.Height;
    if RzBmpButtonHomePage.Top <= Height then RzBmpButtonHomePage.Top := Height - RzBmpButtonHomePage.Height;
    if RzBmpButtonMin.Top <= Height then RzBmpButtonMin.Top := Height - RzBmpButtonMin.Height;
    if RzBmpButtonNewAccount.Top <= Height then RzBmpButtonNewAccount.Top := Height - RzBmpButtonNewAccount.Height;
    if RzBmpButtonStart.Top <= Height then RzBmpButtonStart.Top := Height - RzBmpButtonStart.Height;
    if RzBmpButtonUpgrade.Top <= Height then RzBmpButtonUpgrade.Top := Height - RzBmpButtonUpgrade.Height;
    }

    for I := 1 to g_ComponentList.Count - 1 do begin
          {TWinControl(g_ComponentList.Items[I + 1]).Left := GameLoginConfig.ComponentConfigs[I].Left;
          TWinControl(g_ComponentList.Items[I + 1]).Top := GameLoginConfig.ComponentConfigs[I].Top;
          TWinControl(g_ComponentList.Items[I + 1]).Width := GameLoginConfig.ComponentConfigs[I].Width;
          TWinControl(g_ComponentList.Items[I + 1]).Height := GameLoginConfig.ComponentConfigs[I].Height;
          TWinControl(g_ComponentList.Items[I + 1]).Visible := GameLoginConfig.ComponentConfigs[I].Visible;}
      TWinControl(g_ComponentList.Items[I]).ParentWindow := FrmGameLogin.Handle;
      with TWinControl(g_ComponentList.Items[I]) do
        SetBounds(Left, Top, Width, Height);
    end;
  end;
end;

procedure TFrmGameLogin.Resizer1ControlMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //SelBmpButton := TRzBmpButton(Sender);
end;

procedure TFrmGameLogin.MenuUPClick(Sender: TObject);
begin
  if SelBmpButton <> nil then begin
    if OpenPictureDialog.Execute and (OpenPictureDialog.FileName <> '') then begin
      SelBmpButton.Bitmaps.Up.LoadFromFile(OpenPictureDialog.FileName);
      SelBmpButton.Refresh;
    end;
  end;
end;

procedure TFrmGameLogin.MenuHotClick(Sender: TObject);
begin
  if SelBmpButton <> nil then begin
    if OpenPictureDialog.Execute and (OpenPictureDialog.FileName <> '') then begin
      SelBmpButton.Bitmaps.Hot.LoadFromFile(OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrmGameLogin.MenuDownClick(Sender: TObject);
begin
  if SelBmpButton <> nil then begin
    if OpenPictureDialog.Execute and (OpenPictureDialog.FileName <> '') then begin
      SelBmpButton.Bitmaps.Down.LoadFromFile(OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrmGameLogin.MenuDisabledClick(Sender: TObject);
begin
  if SelBmpButton <> nil then begin
    if OpenPictureDialog.Execute and (OpenPictureDialog.FileName <> '') then begin
      SelBmpButton.Bitmaps.Disabled.LoadFromFile(OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrmGameLogin.MenuVisibleClick(Sender: TObject);
begin
  if SelBmpButton <> nil then begin
    MenuVisible.Checked := not MenuVisible.Checked;
    g_ComponentVisibles[SelBmpButton.Tag] := MenuVisible.Checked;
    //SelBmpButton.Visible := MenuVisible.Checked;
  end;
end;

procedure TFrmGameLogin.Resizer1ControlMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if SelBmpButton <> nil then begin
    MenuVisible.Checked := SelBmpButton.Visible;
  end;
end;

procedure TFrmGameLogin.SaveSkinToFile(FileName: string);
var
  I, nLen: Integer;
  GameLoginConfig: TGameLoginLocalConfig;
  Picture: TImage;
  Bitmap: TBitmap;
  Jpe: TJpegImage;
  FileStream: TMemoryStream;
  MemoryStream: TMemoryStream;
  GameLogin: TMemoryStream;
  Buffer: Pointer;
  BmpButton: TRzBmpButton;
  BufferList: TList;
  SizeList: TList;
begin
  if FileName <> '' then begin
    FillChar(GameLoginConfig, SizeOf(TGameLoginLocalConfig), 0);
    GameLoginConfig.sTitle := '飞尔世界登陆器配制文件';
    for I := 1 to g_ComponentList.Count - 1 do begin
      GameLoginConfig.ComponentConfigs[I - 1].Left := TWinControl(g_ComponentList.Items[I]).Left;
      GameLoginConfig.ComponentConfigs[I - 1].Top := TWinControl(g_ComponentList.Items[I]).Top;
      GameLoginConfig.ComponentConfigs[I - 1].Width := TWinControl(g_ComponentList.Items[I]).Width;
      GameLoginConfig.ComponentConfigs[I - 1].Height := TWinControl(g_ComponentList.Items[I]).Height;
      GameLoginConfig.ComponentConfigs[I - 1].Visible := g_ComponentVisibles[TWinControl(g_ComponentList.Items[I]).Tag]; //TWinControl(g_ComponentList.Items[I]).Visible;
    end;
    BufferList := TList.Create;
    SizeList := TList.Create;
    FileStream := TMemoryStream.Create;
    GameLogin := TMemoryStream.Create;

    Picture := TImage(g_ComponentList.Items[0]);

    //Image.Picture.Bitmap.SaveToStream(FileStream);
   { Jpe := TJpegImage.Create;
    Jpe.Assign(Picture.Picture);
    Jpe.SaveToStream(FileStream);
  //FileStream.SaveToFile('FileStream.jpeg');
    Jpe.Free; }
    Picture.Picture.Bitmap.SaveToStream(FileStream);

    GetMem(Buffer, FileStream.Size);
    FileStream.Seek(0, soFromBeginning);
    FileStream.Read(Buffer^, FileStream.Size);

    GameLoginConfig.ComponentImages[0].UpSize := FileStream.Size;
    GameLoginConfig.ComponentImages[0].HotSize := 0;
    GameLoginConfig.ComponentImages[0].DownSize := 0;
    GameLoginConfig.ComponentImages[0].Disabled := 0;

    BufferList.Add(Buffer);
    SizeList.Add(Pointer(FileStream.Size));

    for I := 1 to g_ComponentList.Count - 5 do begin
      if not (TComponent(g_ComponentList.Items[I]) is TRzBmpButton) then Continue;
      BmpButton := TRzBmpButton(g_ComponentList.Items[I]);
      if not BmpButton.Visible then begin
        GameLoginConfig.ComponentImages[I].UpSize := 0;
        GameLoginConfig.ComponentImages[I].HotSize := 0;
        GameLoginConfig.ComponentImages[I].DownSize := 0;
        GameLoginConfig.ComponentImages[I].Disabled := 0;
        Continue;
      end;
      if (BmpButton.Bitmaps <> nil) and (BmpButton.Bitmaps.Up <> nil) and (BmpButton.Bitmaps.Up.Width > 0) and (BmpButton.Bitmaps.Up.Height > 0) then begin
        FileStream.Clear;
        BmpButton.Bitmaps.Up.SaveToStream(FileStream);

        GetMem(Buffer, FileStream.Size);
        FileStream.Seek(0, soFromBeginning);
        FileStream.Read(Buffer^, FileStream.Size);

        BufferList.Add(Buffer);
        SizeList.Add(Pointer(FileStream.Size));
        GameLoginConfig.ComponentImages[I].UpSize := FileStream.Size;
      end else begin
        GameLoginConfig.ComponentImages[I].UpSize := 0;
      end;

      if (BmpButton.Bitmaps <> nil) and (BmpButton.Bitmaps.Hot <> nil) and (BmpButton.Bitmaps.Hot.Width > 0) and (BmpButton.Bitmaps.Hot.Height > 0) then begin
        FileStream.Clear;
        BmpButton.Bitmaps.Hot.SaveToStream(FileStream);
        GetMem(Buffer, FileStream.Size);
        FileStream.Seek(0, soFromBeginning);
        FileStream.Read(Buffer^, FileStream.Size);
        BufferList.Add(Buffer);
        SizeList.Add(Pointer(FileStream.Size));
        GameLoginConfig.ComponentImages[I].HotSize := FileStream.Size;
      end else begin
        GameLoginConfig.ComponentImages[I].HotSize := 0;
      end;

      if (BmpButton.Bitmaps <> nil) and (BmpButton.Bitmaps.Down <> nil) and (BmpButton.Bitmaps.Down.Width > 0) and (BmpButton.Bitmaps.Down.Height > 0) then begin
        FileStream.Clear;
        BmpButton.Bitmaps.Down.SaveToStream(FileStream);
        GetMem(Buffer, FileStream.Size);
        FileStream.Seek(0, soFromBeginning);
        FileStream.Read(Buffer^, FileStream.Size);
        BufferList.Add(Buffer);
        SizeList.Add(Pointer(FileStream.Size));
        GameLoginConfig.ComponentImages[I].DownSize := FileStream.Size;
      end else begin
        GameLoginConfig.ComponentImages[I].DownSize := 0;
      end;

      if (BmpButton.Bitmaps <> nil) and (BmpButton.Bitmaps.Disabled <> nil) and (BmpButton.Bitmaps.Disabled.Width > 0) and (BmpButton.Bitmaps.Disabled.Height > 0) then begin
        FileStream.Clear;
        BmpButton.Bitmaps.Disabled.SaveToStream(FileStream);
        GetMem(Buffer, FileStream.Size);
        FileStream.Seek(0, soFromBeginning);
        FileStream.Read(Buffer^, FileStream.Size);
        BufferList.Add(Buffer);
        SizeList.Add(Pointer(FileStream.Size));
        GameLoginConfig.ComponentImages[I].Disabled := FileStream.Size;
      end else begin
        GameLoginConfig.ComponentImages[I].Disabled := 0;
      end;
    end;
    GameLoginConfig.Transparent := g_boTransparent;

    GameLoginConfig.LabelConnectColor := g_LabelConnectColor;
    GameLoginConfig.LabelConnectingColor := g_LabelConnectingColor;
    GameLoginConfig.LabelDisconnectColor := g_LabelDisconnectColor;

    GameLoginConfig.ViewFColor := g_ViewFColor;
    GameLoginConfig.ViewBColor := g_ViewBColor;

    try
      GameLogin.Write(GameLoginConfig, SizeOf(TGameLoginLocalConfig));
      for I := 0 to BufferList.Count - 1 do begin
        Buffer := BufferList.Items[I];
        nLen := Integer(SizeList.Items[I]);
        GameLogin.Write(Buffer^, nLen);
        FreeMem(Buffer);
      end;

      BufferList.Free;
      SizeList.Free;
      FileStream.Free;

      //if ExtractFileExt(FileName) <> '.Skin' then
      //  FileName := ExtractFilePath(FileName) + ExtractFileNameOnly(FileName) + '.Skin';

      GameLogin.SaveToFile(FileName);

      //Application.MessageBox('配制信息已保存 ！！！', '提示信息', MB_ICONQUESTION);
    except
      on e: Exception do begin
        Application.MessageBox(PChar(e.Message), '错误信息', MB_ICONERROR);
      end;
    end;
    GameLogin.Free;
  end;
end;


procedure TFrmGameLogin.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  MagneticWnd := TMagnetic.Create;
  MagneticAddWindow := False;
  {Image.RecreateRegion;
  Resizer1.ResizeControl := RzBmpButtonAutoLogin;
  Resizer2.ResizeControl := RzBmpButtonChgPassWord;
  Resizer3.ResizeControl := RzBmpButtonClose;
  Resizer4.ResizeControl := RzBmpButtonEditGameList;
  Resizer5.ResizeControl := RzBmpButtonExitGame;
  Resizer6.ResizeControl := RzBmpButtonFullScreenStart;
  Resizer7.ResizeControl := RzBmpButtonGetBakPassWord;
  Resizer8.ResizeControl := RzBmpButtonHomePage;
  Resizer9.ResizeControl := RzBmpButtonMin;
  Resizer10.ResizeControl := RzBmpButtonNewAccount;
  Resizer11.ResizeControl := RzBmpButtonStart;
  Resizer12.ResizeControl := RzBmpButtonUpgrade;
  Resizer13.ResizeControl := LabelStatus;
  Resizer14.ResizeControl := TreeView;
  Resizer15.ResizeControl := WebBrowser;  }
  g_ComponentList.Add(Image);
  g_ComponentList.Add(RzBmpButtonFullScreenStart);
  g_ComponentList.Add(RzBmpButtonEditGameList);
  g_ComponentList.Add(RzBmpButtonHomePage);
  g_ComponentList.Add(RzBmpButtonAutoLogin);
  g_ComponentList.Add(RzBmpButtonUpgrade);
  g_ComponentList.Add(RzBmpButtonStart);
  g_ComponentList.Add(RzBmpButtonNewAccount);
  g_ComponentList.Add(RzBmpButtonGetBakPassWord);
  g_ComponentList.Add(RzBmpButtonChgPassWord);
  g_ComponentList.Add(RzBmpButtonExitGame);
  g_ComponentList.Add(RzBmpButtonMin);
  g_ComponentList.Add(RzBmpButtonClose);
  g_ComponentList.Add(TreeView);
  g_ComponentList.Add(WebBrowser);
  g_ComponentList.Add(LabelStatus);
  g_ComponentList.Add(ComboBox);
  for I := 0 to Length(g_ComponentVisibles) - 1 do
    g_ComponentVisibles[I] := True;
  {Image.Picture.Bitmap.Transparent := True;
  Image.Picture.Bitmap.TransparentColor := clBlack;}

  {g_Bitmap := TBitmap.Create;
  g_Bitmap.Assign(Image.Picture.Bitmap);  }
  SaveSkinToFile('GameLogin.skin');
  if g_boTransparent then
    Image.RecreateRegion;
end;

procedure TFrmGameLogin.MenuLoadConfigClick(Sender: TObject);
var
  I, nLen: Integer;
  GameLoginConfig: TGameLoginLocalConfig;
  //Image: TImage;
  Bitmap: TBitmap;
  Jpe: TJpegImage;
  FileStream: TMemoryStream;
  MemoryStream: TMemoryStream;
  Buffer: Pointer;
  //list: TStringList;
begin
  if OpenDialog.Execute then begin
    //list := TStringList.Create;
    FileStream := TMemoryStream.Create;
    FileStream.LoadFromFile(OpenDialog.FileName);
    FileStream.Seek(0, soFromBeginning);
    FileStream.Read(GameLoginConfig, SizeOf(TGameLoginLocalConfig));
    //TWinControl(g_ComponentList.Items[I + 1]).
    if GameLoginConfig.sTitle = '飞尔世界登陆器配制文件' then begin
     { for I := 0 to Length(GameLoginConfig.ComponentConfigs) - 1 do begin
        TWinControl(g_ComponentList.Items[I + 1]).Left := GameLoginConfig.ComponentConfigs[I].Left;
        TWinControl(g_ComponentList.Items[I + 1]).Top := GameLoginConfig.ComponentConfigs[I].Top;
        TWinControl(g_ComponentList.Items[I + 1]).Width := GameLoginConfig.ComponentConfigs[I].Width;
        TWinControl(g_ComponentList.Items[I + 1]).Height := GameLoginConfig.ComponentConfigs[I].Height;
        TWinControl(g_ComponentList.Items[I + 1]).Visible := GameLoginConfig.ComponentConfigs[I].Visible;
        with GameLoginConfig.ComponentConfigs[I] do
          TWinControl(g_ComponentList.Items[I + 1]).SetBounds(Left, Top, Width, Height);
      end;}
      g_boTransparent := GameLoginConfig.Transparent;
      g_ViewBColor := GameLoginConfig.ViewBColor;
      g_ViewFColor := GameLoginConfig.ViewFColor;

      g_LabelConnectColor := GameLoginConfig.LabelConnectColor;
      g_LabelConnectingColor := GameLoginConfig.LabelConnectingColor;
      g_LabelDisconnectColor := GameLoginConfig.LabelDisconnectColor;

      if GameLoginConfig.ComponentImages[0].UpSize > 0 then begin
        GetMem(Buffer, GameLoginConfig.ComponentImages[0].UpSize);
        FileStream.Read(Buffer^, GameLoginConfig.ComponentImages[0].UpSize);
        MemoryStream := TMemoryStream.Create;
        MemoryStream.Write(Buffer^, GameLoginConfig.ComponentImages[0].UpSize);
        MemoryStream.Position := 0;
        FreeMem(Buffer);

        Bitmap := TBitmap.Create;
        Bitmap.LoadFromStream(MemoryStream);
        ClientHeight := Bitmap.Height;
        ClientWidth := Bitmap.Width;
        Bitmap.Free;
        MemoryStream.Position := 0;
        Image.Picture.Bitmap.LoadFromStream(MemoryStream);
        //g_Bitmap.Assign(Image.Picture.Bitmap);
        {Image.Picture.Bitmap.TransparentColor := clBlack;
        Image.Picture.Bitmap.Transparent := True;  }

        Image.Transparent := g_boTransparent;
        if g_boTransparent then
          Image.RecreateRegion;
        MemoryStream.Free;
      end;

      for I := 1 to Length(GameLoginConfig.ComponentImages) - 1 do begin
        //g_ComponentVisibles[TRzBmpButton(g_ComponentList.Items[I]).Tag] := TRzBmpButton(g_ComponentList.Items[I]).Visible;
        if not TRzBmpButton(g_ComponentList.Items[I]).Visible then Continue;
        if GameLoginConfig.ComponentImages[I].UpSize > 0 then begin
          GetMem(Buffer, GameLoginConfig.ComponentImages[I].UpSize);

          FileStream.Read(Buffer^, GameLoginConfig.ComponentImages[I].UpSize);

          MemoryStream := TMemoryStream.Create;
          MemoryStream.Write(Buffer^, GameLoginConfig.ComponentImages[I].UpSize);
          MemoryStream.Position := 0;

          TRzBmpButton(g_ComponentList.Items[I]).Bitmaps.Up.LoadFromStream(MemoryStream);

          MemoryStream.Free;
          FreeMem(Buffer);

        end;
        if GameLoginConfig.ComponentImages[I].HotSize > 0 then begin
          GetMem(Buffer, GameLoginConfig.ComponentImages[I].HotSize);

          FileStream.Read(Buffer^, GameLoginConfig.ComponentImages[I].HotSize);

          MemoryStream := TMemoryStream.Create;
          MemoryStream.Write(Buffer^, GameLoginConfig.ComponentImages[I].HotSize);
          MemoryStream.Position := 0;

          TRzBmpButton(g_ComponentList.Items[I]).Bitmaps.Hot.LoadFromStream(MemoryStream);

          MemoryStream.Free;
          FreeMem(Buffer);
        end;
        if GameLoginConfig.ComponentImages[I].DownSize > 0 then begin
          GetMem(Buffer, GameLoginConfig.ComponentImages[I].DownSize);

          FileStream.Read(Buffer^, GameLoginConfig.ComponentImages[I].DownSize);

          MemoryStream := TMemoryStream.Create;
          MemoryStream.Write(Buffer^, GameLoginConfig.ComponentImages[I].DownSize);
          MemoryStream.Position := 0;

          TRzBmpButton(g_ComponentList.Items[I]).Bitmaps.Down.LoadFromStream(MemoryStream);

          MemoryStream.Free;
          FreeMem(Buffer);
        end;
        if GameLoginConfig.ComponentImages[I].Disabled > 0 then begin
          GetMem(Buffer, GameLoginConfig.ComponentImages[I].Disabled);

          FileStream.Read(Buffer^, GameLoginConfig.ComponentImages[I].Disabled);

          MemoryStream := TMemoryStream.Create;
          MemoryStream.Write(Buffer^, GameLoginConfig.ComponentImages[I].Disabled);
          MemoryStream.Position := 0;

          TRzBmpButton(g_ComponentList.Items[I]).Bitmaps.Disabled.LoadFromStream(MemoryStream);

          MemoryStream.Free;
          FreeMem(Buffer);
        end;
      end;

      for I := 0 to Length(GameLoginConfig.ComponentConfigs) - 1 do begin
        TWinControl(g_ComponentList.Items[I + 1]).Left := GameLoginConfig.ComponentConfigs[I].Left;
        TWinControl(g_ComponentList.Items[I + 1]).Top := GameLoginConfig.ComponentConfigs[I].Top;
        TWinControl(g_ComponentList.Items[I + 1]).Width := GameLoginConfig.ComponentConfigs[I].Width;
        TWinControl(g_ComponentList.Items[I + 1]).Height := GameLoginConfig.ComponentConfigs[I].Height;
        //TWinControl(g_ComponentList.Items[I + 1]).Visible := GameLoginConfig.ComponentConfigs[I].Visible;
        TWinControl(g_ComponentList.Items[I + 1]).ParentWindow := FrmGameLogin.Handle;

        with GameLoginConfig.ComponentConfigs[I] do
          TWinControl(g_ComponentList.Items[I + 1]).SetBounds(Left, Top, Width, Height);

        SizeControl.Target := TWinControl(g_ComponentList.Items[I + 1]);
      end;
      for I := 1 to g_ComponentList.Count - 1 do begin
        g_ComponentVisibles[TWinControl(g_ComponentList.Items[I]).Tag] := GameLoginConfig.ComponentConfigs[I - 1].Visible; //TWinControl(g_ComponentList.Items[I]).Visible;
      end;

      Self.Left := Round((Screen.Width - (Self.Width + ObjectsDlg.Width)) / 2);
      Self.Top := Round((Screen.Height - Self.Height) / 2);
      ObjectsDlg.Left := Self.Left + Self.Width;
      ObjectsDlg.Top := Top;
      ObjectsDlg.Open;
      ObjectsDlg.JvInspector.Refresh;

      Application.MessageBox('配制文件导入成功 ！！！', '提示信息', MB_ICONQUESTION);
    end else begin
      Application.MessageBox('请选择正确的登陆器配制文件 ！！！', '提示信息', MB_ICONQUESTION);
    end;
    FileStream.Free;
  end;
end;

procedure TFrmGameLogin.MenuSaveConfigClick(Sender: TObject);
var
  I, nLen: Integer;
  GameLoginConfig: TGameLoginLocalConfig;
  Picture: TImage;
  Bitmap: TBitmap;
  Jpe: TJpegImage;
  FileStream: TMemoryStream;
  MemoryStream: TMemoryStream;
  GameLogin: TMemoryStream;
  Buffer: Pointer;
  BmpButton: TRzBmpButton;
  BufferList: TList;
  SizeList: TList;
begin
  if SaveDialog.Execute then begin
    FillChar(GameLoginConfig, SizeOf(TGameLoginLocalConfig), 0);
    GameLoginConfig.sTitle := '飞尔世界登陆器配制文件';
    for I := 1 to g_ComponentList.Count - 1 do begin
      GameLoginConfig.ComponentConfigs[I - 1].Left := TWinControl(g_ComponentList.Items[I]).Left;
      GameLoginConfig.ComponentConfigs[I - 1].Top := TWinControl(g_ComponentList.Items[I]).Top;
      GameLoginConfig.ComponentConfigs[I - 1].Width := TWinControl(g_ComponentList.Items[I]).Width;
      GameLoginConfig.ComponentConfigs[I - 1].Height := TWinControl(g_ComponentList.Items[I]).Height;
      GameLoginConfig.ComponentConfigs[I - 1].Visible := g_ComponentVisibles[TWinControl(g_ComponentList.Items[I]).Tag]; //TWinControl(g_ComponentList.Items[I]).Visible;
    end;
    BufferList := TList.Create;
    SizeList := TList.Create;
    FileStream := TMemoryStream.Create;
    GameLogin := TMemoryStream.Create;

    Picture := TImage(g_ComponentList.Items[0]);

    //Image.Picture.Bitmap.SaveToStream(FileStream);
   { Jpe := TJpegImage.Create;
    Jpe.Assign(Picture.Picture);
    Jpe.SaveToStream(FileStream);
  //FileStream.SaveToFile('FileStream.jpeg');
    Jpe.Free; }
    Picture.Picture.Bitmap.SaveToStream(FileStream);

    GetMem(Buffer, FileStream.Size);
    FileStream.Seek(0, soFromBeginning);
    FileStream.Read(Buffer^, FileStream.Size);

    GameLoginConfig.ComponentImages[0].UpSize := FileStream.Size;
    GameLoginConfig.ComponentImages[0].HotSize := 0;
    GameLoginConfig.ComponentImages[0].DownSize := 0;
    GameLoginConfig.ComponentImages[0].Disabled := 0;

    BufferList.Add(Buffer);
    SizeList.Add(Pointer(FileStream.Size));

    for I := 1 to g_ComponentList.Count - 4 do begin
      BmpButton := TRzBmpButton(g_ComponentList.Items[I]);
      if not BmpButton.Visible then begin
        GameLoginConfig.ComponentImages[I].UpSize := 0;
        GameLoginConfig.ComponentImages[I].HotSize := 0;
        GameLoginConfig.ComponentImages[I].DownSize := 0;
        GameLoginConfig.ComponentImages[I].Disabled := 0;
        Continue;
      end;
      if (BmpButton.Bitmaps <> nil) and (BmpButton.Bitmaps.Up <> nil) and (BmpButton.Bitmaps.Up.Width > 0) and (BmpButton.Bitmaps.Up.Height > 0) then begin
        FileStream.Clear;
        BmpButton.Bitmaps.Up.SaveToStream(FileStream);

        GetMem(Buffer, FileStream.Size);
        FileStream.Seek(0, soFromBeginning);
        FileStream.Read(Buffer^, FileStream.Size);

        BufferList.Add(Buffer);
        SizeList.Add(Pointer(FileStream.Size));
        GameLoginConfig.ComponentImages[I].UpSize := FileStream.Size;
      end else begin
        GameLoginConfig.ComponentImages[I].UpSize := 0;
      end;

      if (BmpButton.Bitmaps <> nil) and (BmpButton.Bitmaps.Hot <> nil) and (BmpButton.Bitmaps.Hot.Width > 0) and (BmpButton.Bitmaps.Hot.Height > 0) then begin
        FileStream.Clear;
        BmpButton.Bitmaps.Hot.SaveToStream(FileStream);
        GetMem(Buffer, FileStream.Size);
        FileStream.Seek(0, soFromBeginning);
        FileStream.Read(Buffer^, FileStream.Size);
        BufferList.Add(Buffer);
        SizeList.Add(Pointer(FileStream.Size));
        GameLoginConfig.ComponentImages[I].HotSize := FileStream.Size;
      end else begin
        GameLoginConfig.ComponentImages[I].HotSize := 0;
      end;

      if (BmpButton.Bitmaps <> nil) and (BmpButton.Bitmaps.Down <> nil) and (BmpButton.Bitmaps.Down.Width > 0) and (BmpButton.Bitmaps.Down.Height > 0) then begin
        FileStream.Clear;
        BmpButton.Bitmaps.Down.SaveToStream(FileStream);
        GetMem(Buffer, FileStream.Size);
        FileStream.Seek(0, soFromBeginning);
        FileStream.Read(Buffer^, FileStream.Size);
        BufferList.Add(Buffer);
        SizeList.Add(Pointer(FileStream.Size));
        GameLoginConfig.ComponentImages[I].DownSize := FileStream.Size;
      end else begin
        GameLoginConfig.ComponentImages[I].DownSize := 0;
      end;

      if (BmpButton.Bitmaps <> nil) and (BmpButton.Bitmaps.Disabled <> nil) and (BmpButton.Bitmaps.Disabled.Width > 0) and (BmpButton.Bitmaps.Disabled.Height > 0) then begin
        FileStream.Clear;
        BmpButton.Bitmaps.Disabled.SaveToStream(FileStream);
        GetMem(Buffer, FileStream.Size);
        FileStream.Seek(0, soFromBeginning);
        FileStream.Read(Buffer^, FileStream.Size);
        BufferList.Add(Buffer);
        SizeList.Add(Pointer(FileStream.Size));
        GameLoginConfig.ComponentImages[I].Disabled := FileStream.Size;
      end else begin
        GameLoginConfig.ComponentImages[I].Disabled := 0;
      end;
    end;
    GameLoginConfig.Transparent := g_boTransparent;

    GameLoginConfig.LabelConnectColor := g_LabelConnectColor;
    GameLoginConfig.LabelConnectingColor := g_LabelConnectingColor;
    GameLoginConfig.LabelDisconnectColor := g_LabelDisconnectColor;

    GameLoginConfig.ViewFColor := g_ViewFColor;
    GameLoginConfig.ViewBColor := g_ViewBColor;

    try
      GameLogin.Write(GameLoginConfig, SizeOf(TGameLoginLocalConfig));
      for I := 0 to BufferList.Count - 1 do begin
        Buffer := BufferList.Items[I];
        nLen := Integer(SizeList.Items[I]);
        GameLogin.Write(Buffer^, nLen);
        FreeMem(Buffer);
      end;

      BufferList.Free;
      SizeList.Free;
      FileStream.Free;

      if ExtractFileExt(SaveDialog.FileName) <> '.Skin' then
        SaveDialog.FileName := ExtractFilePath(SaveDialog.FileName) + ExtractFileNameOnly(SaveDialog.FileName) + '.Skin';

      GameLogin.SaveToFile(SaveDialog.FileName);

      Application.MessageBox('配制信息已保存 ！！！', '提示信息', MB_ICONQUESTION);
    except
      on e: Exception do begin
        Application.MessageBox(PChar(e.Message), '错误信息', MB_ICONERROR);
      end;
    end;
    GameLogin.Free;
  end;
end;

procedure TFrmGameLogin.MenuLabelVisibleClick(Sender: TObject);
begin
  MenuLabelVisible.Checked := not MenuLabelVisible.Checked;
  g_ComponentVisibles[LabelStatus.Tag] := MenuLabelVisible.Checked;
  //LabelStatus.Visible := not LabelStatus.Visible;
end;

procedure TFrmGameLogin.Resizer13ControlMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MenuLabelVisible.Checked := LabelStatus.Visible;
end;

procedure TFrmGameLogin.MenuLabelFColorClick(Sender: TObject);
begin
  ColorDialog.Color := g_LabelConnectingColor;
  if ColorDialog.Execute then begin
    g_LabelConnectingColor := ColorDialog.Color;
  end;
end;

procedure TFrmGameLogin.MenuViewFColorClick(Sender: TObject);
begin
  ColorDialog.Color := g_ViewFColor;
  if ColorDialog.Execute then begin
    g_ViewFColor := ColorDialog.Color;
  end;
end;

procedure TFrmGameLogin.MenuViewBColorClick(Sender: TObject);
begin
  ColorDialog.Color := g_ViewBColor;
  if ColorDialog.Execute then begin
    g_ViewBColor := ColorDialog.Color;
  end;
end;

procedure TFrmGameLogin.MenuViewVisibleClick(Sender: TObject);
begin
  MenuViewVisible.Checked := not MenuViewVisible.Checked;
  g_ComponentVisibles[TreeView.Tag] := MenuViewVisible.Checked;
  //TreeView.Visible := not TreeView.Visible;
end;

procedure TFrmGameLogin.Resizer14ControlMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MenuViewVisible.Checked := TreeView.Visible;
end;

procedure TFrmGameLogin.N4Click(Sender: TObject);
begin
  ColorDialog.Color := g_LabelConnectColor;
  if ColorDialog.Execute then begin
    g_LabelConnectColor := ColorDialog.Color;
  end;
end;

procedure TFrmGameLogin.N5Click(Sender: TObject);
begin
  ColorDialog.Color := g_LabelDisconnectColor;
  if ColorDialog.Execute then begin
    g_LabelDisconnectColor := ColorDialog.Color;
  end;
end;

procedure TFrmGameLogin.Label1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;

procedure TFrmGameLogin.SizeControlTargetChanging(Sender: TObject;
  NewTarget: TControl; var IsValidTarget: Boolean);
begin
  SizeControl.PopupMenu := nil;
  if (NewTarget = Label1) or (NewTarget = Image) then IsValidTarget := False
  else begin
    if NewTarget is TRzBmpButton then begin
      SelBmpButton := TRzBmpButton(NewTarget);
      SizeControl.PopupMenu := PopupMenu;
      MenuVisible.Checked := g_ComponentVisibles[SelBmpButton.Tag];
    end;
    if NewTarget = LabelStatus then begin
      SizeControl.PopupMenu := PopupMenu1;
      MenuLabelVisible.Checked := g_ComponentVisibles[LabelStatus.Tag];
    end;
    if NewTarget = TreeView then begin
      SizeControl.PopupMenu := PopupMenu2;
      MenuViewVisible.Checked := g_ComponentVisibles[TreeView.Tag];
    end;
  end;
end;

procedure TFrmGameLogin.MenoCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmGameLogin.MenuTransparentClick(Sender: TObject);
begin
  g_boTransparent := not g_boTransparent;
  MenuTransparent.Checked := g_boTransparent;
  Image.Transparent := g_boTransparent;
  if g_boTransparent then
    Image.RecreateRegion;
  //if g_boTransparent then Image.RecreateRegion else Image.Picture.Bitmap.Assign(g_Bitmap);
end;

procedure TFrmGameLogin.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MenuTransparent.Checked := g_boTransparent;
end;

procedure TFrmGameLogin.FormDestroy(Sender: TObject);
begin
  MagneticWnd.Free;
end;

procedure TFrmGameLogin.PopupMenuPopup(Sender: TObject);
begin
  if (SizeControl.Target = Label1) or (SizeControl.Target = Image) or (SizeControl.Target = ComboBox) then SelBmpButton := nil
  else SelBmpButton := TRzBmpButton(SizeControl.Target)
end;

procedure TFrmGameLogin.TreeViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    SizeControl.Target := TControl(Sender);
end;

procedure TFrmGameLogin.Open;
begin
  if Assigned(MagneticWnd) and (not MagneticAddWindow) then begin
    MagneticAddWindow := True;
    // Set Snap width
    MagneticWnd.SnapWidth := 15;
    // Register main window as a serviced window of TMagnetic Class
    MagneticWnd.AddWindow(Self.Handle, 0, MagneticWndProc);
  end;
  Show;
  Self.Left := Round((Screen.Width - (Self.Width + ObjectsDlg.Width)) / 2);
  Self.Top := Round((Screen.Height - Self.Height) / 2);
  ObjectsDlg.Left := Self.Left + Self.Width;
  ObjectsDlg.Top := Top;
  ObjectsDlg.Open;
end;

procedure TFrmGameLogin.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caHide;
  ObjectsDlg.Close;
end;

procedure TFrmGameLogin.SizeControlResized(Sender: TObject;
  ControlRect: TRect);
begin
  ObjectsDlg.JvInspector.Refresh;
end;

procedure TFrmGameLogin.SizeControlMoved(Sender: TObject;
  ControlRect: TRect);
begin
  ObjectsDlg.JvInspector.Refresh;
end;

procedure TFrmGameLogin.FormPaint(Sender: TObject);
begin
 // if GetForegroundWindow <> Handle then
  //  SizeControl.Target
    //SizeControl.Enabled := GetForegroundWindow = Handle;
end;

procedure TFrmGameLogin.FormActivate(Sender: TObject);
begin
 // FrmGameLogin.SizeControl.Enabled:=True;
end;

end.

