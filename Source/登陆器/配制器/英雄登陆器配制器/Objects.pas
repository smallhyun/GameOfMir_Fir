unit Objects;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvComponentBase, JvInspector, JvExControls, JvComponent, ExtCtrls,
  StdCtrls, Magnetic, RzBmpBtn;

type
  TObjectsDlg = class(TForm)
    JvInspector: TJvInspector;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure JvInspectorDataValueChanged(Sender: TObject;
      Data: TJvCustomInspectorData);
    procedure FormActivate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    procedure WndProc(var Msg_: TMessage); override;
    procedure Open;
  end;
var
  ObjectsDlg: TObjectsDlg;
implementation
uses TypInfo, JvInspExtraEditors, GameLogin, Share;
{$R *.dfm}
var
  MagneticWndProc: TSubClass_Proc;
  MagneticAddWindow: Boolean;
// procedure to subclass form's window procedure for magnetic effect.

procedure TObjectsDlg.WndProc(var Msg_: TMessage);
var
  Handled: boolean;
begin
  if not Assigned(MagneticWndProc) then
  begin
    inherited WndProc(Msg_);
    exit;
  end;

  if (Msg_.Msg = WM_SYSCOMMAND) or (Msg_.Msg = WM_ENTERSIZEMOVE) or (Msg_.Msg = WM_EXITSIZEMOVE) or
    (Msg_.Msg = WM_WINDOWPOSCHANGED) or (Msg_.Msg = WM_COMMAND) then
  begin
    inherited WndProc(Msg_);
    MagneticWndProc(Self.Handle, Msg_.Msg, Msg_, Handled);
  end else if (Msg_.Msg = WM_MOVING) or (Msg_.Msg = WM_SIZING) then
  begin
    MagneticWndProc(Self.Handle, Msg_.Msg, Msg_, Handled);
    if not Handled then
      inherited WndProc(Msg_);

  end else
    inherited WndProc(Msg_);
end;

procedure TObjectsDlg.FormCreate(Sender: TObject);
var
  I: Integer;
  BmpButton: TRzBmpButton;
  MainInspCat, InspCat: TJvInspectorCustomCategoryItem;
  NewItem: TJvCustomInspectorItem;
begin
  MagneticAddWindow := False;
{-------------------------------------------------------------------------------}
  JvInspector.Clear;
  InspCat := TJvInspectorCustomCategoryItem.Create(JvInspector.Root, nil);
  InspCat.DisplayName := '界面';
  TJvInspectorPropData.New(InspCat, FrmGameLogin.Image, 'Picture');

  //TJvInspectorVarData.New(InspCat, '图片', TypeInfo(TPicture), @FrmGameLogin.Image.Picture);

{-------------------------------------------------------------------------------}
  InspCat := TJvInspectorCustomCategoryItem.Create(JvInspector.Root, nil);
  InspCat.DisplayName := '浏览器';
  TJvInspectorPropData.New(InspCat, FrmGameLogin.WebBrowser, 'Left');
  TJvInspectorPropData.New(InspCat, FrmGameLogin.WebBrowser, 'Top');
  TJvInspectorPropData.New(InspCat, FrmGameLogin.WebBrowser, 'Width');
  TJvInspectorPropData.New(InspCat, FrmGameLogin.WebBrowser, 'Height');
  {
  TJvInspectorVarData.New(InspCat, 'Left', TypeInfo(Integer), @FrmGameLogin.WebBrowser.Left);
  TJvInspectorVarData.New(InspCat, 'Top', TypeInfo(Integer), @FrmGameLogin.WebBrowser.Top);
  TJvInspectorVarData.New(InspCat, 'Width', TypeInfo(Integer), @FrmGameLogin.WebBrowser.Width);
  TJvInspectorVarData.New(InspCat, 'Height', TypeInfo(Integer), @FrmGameLogin.WebBrowser.Height);
  }
  //TJvInspectorVarData.New(InspCat, 'Visible', TypeInfo(Boolean), @FrmGameLogin.WebBrowser.Visible);
{-------------------------------------------------------------------------------}

  InspCat := TJvInspectorCustomCategoryItem.Create(JvInspector.Root, nil);
  InspCat.DisplayName := '游戏列表';
  TJvInspectorPropData.New(InspCat, FrmGameLogin.TreeView, 'Left');
  TJvInspectorPropData.New(InspCat, FrmGameLogin.TreeView, 'Top');
  TJvInspectorPropData.New(InspCat, FrmGameLogin.TreeView, 'Width');
  TJvInspectorPropData.New(InspCat, FrmGameLogin.TreeView, 'Height');
  {
  TJvInspectorVarData.New(InspCat, 'Left', TypeInfo(Integer), @FrmGameLogin.TreeView.Left);
  TJvInspectorVarData.New(InspCat, 'Top', TypeInfo(Integer), @FrmGameLogin.TreeView.Top);
  TJvInspectorVarData.New(InspCat, 'Width', TypeInfo(Integer), @FrmGameLogin.TreeView.Width);
  TJvInspectorVarData.New(InspCat, 'Height', TypeInfo(Integer), @FrmGameLogin.TreeView.Height);
  }
  TJvInspectorVarData.New(InspCat, 'Visible', TypeInfo(Boolean), @g_ComponentVisibles[FrmGameLogin.TreeView.Tag]);
  TJvInspectorVarData.New(InspCat, 'Color', TypeInfo(TColor), @g_ViewBColor); //@g_ViewBColor
  TJvInspectorVarData.New(InspCat, 'FontColor', TypeInfo(TColor), @g_ViewFColor);

{-------------------------------------------------------------------------------}
  InspCat := TJvInspectorCustomCategoryItem.Create(JvInspector.Root, nil);
  InspCat.DisplayName := '分辨率选择';
  TJvInspectorPropData.New(InspCat, FrmGameLogin.ComboBox, 'Left');
  TJvInspectorPropData.New(InspCat, FrmGameLogin.ComboBox, 'Top');
  TJvInspectorPropData.New(InspCat, FrmGameLogin.ComboBox, 'Width');

  //TJvInspectorVarData.New(InspCat, 'Left', TypeInfo(Integer), ControlLeft(FrmGameLogin.ComboBox));
  //TJvInspectorVarData.New(InspCat, 'Top', TypeInfo(Integer), @FrmGameLogin.ComboBox.Top);
  //TJvInspectorVarData.New(InspCat, 'Width', TypeInfo(Integer), @FrmGameLogin.ComboBox.Width);

{-------------------------------------------------------------------------------}
  InspCat := TJvInspectorCustomCategoryItem.Create(JvInspector.Root, nil);
  InspCat.DisplayName := '连接信息';
{  TJvInspectorVarData.New(InspCat, 'Left', TypeInfo(Integer), @FrmGameLogin.LabelStatus.Left);
  TJvInspectorVarData.New(InspCat, 'Top', TypeInfo(Integer), @FrmGameLogin.LabelStatus.Top);
  TJvInspectorVarData.New(InspCat, 'Width', TypeInfo(Integer), @FrmGameLogin.LabelStatus.Width);
   }
  TJvInspectorPropData.New(InspCat, FrmGameLogin.LabelStatus, 'Left');
  TJvInspectorPropData.New(InspCat, FrmGameLogin.LabelStatus, 'Top');
  TJvInspectorPropData.New(InspCat, FrmGameLogin.LabelStatus, 'Width');


  TJvInspectorVarData.New(InspCat, 'Visible', TypeInfo(Boolean), @g_ComponentVisibles[FrmGameLogin.LabelStatus.Tag]);
  TJvInspectorVarData.New(InspCat, 'ConnectColor', TypeInfo(TColor), @g_LabelConnectColor);
  TJvInspectorVarData.New(InspCat, 'ConnectingColor', TypeInfo(TColor), @g_LabelConnectingColor);
  TJvInspectorVarData.New(InspCat, 'DisconnectColor', TypeInfo(TColor), @g_LabelDisconnectColor);

{-------------------------------------------------------------------------------}
  MainInspCat := TJvInspectorCustomCategoryItem.Create(JvInspector.Root, nil);
  MainInspCat.DisplayName := '按钮';
  for I := 0 to g_ComponentList.Count - 1 do begin
    if TWinControl(g_ComponentList.Items[I]) is TRzBmpButton then begin
      BmpButton := TRzBmpButton(g_ComponentList.Items[I]);
      InspCat := TJvInspectorCustomCategoryItem.Create(MainInspCat, nil);
      InspCat.DisplayName := BmpButton.Caption;
      BmpButton.Caption := '';
      TJvInspectorPropData.New(InspCat, BmpButton, 'Left');
      TJvInspectorPropData.New(InspCat, BmpButton, 'Top');
 // TJvInspectorPropData.New(InspCat, FrmGameLogin.LabelStatus, 'Width');
      {
      TJvInspectorVarData.New(InspCat, 'Left', TypeInfo(Integer), @BmpButton.Left);
      TJvInspectorVarData.New(InspCat, 'Top', TypeInfo(Integer), @BmpButton.Top);
      TJvInspectorVarData.New(InspCat, 'Width', TypeInfo(Integer), @BmpButton.Width);
      }
      TJvInspectorVarData.New(InspCat, 'Visible', TypeInfo(Boolean), @g_ComponentVisibles[BmpButton.Tag]);

      TJvInspectorVarData.New(InspCat, 'Up', TypeInfo(TBitmap), @BmpButton.Bitmaps.Up);
      TJvInspectorVarData.New(InspCat, 'Hot', TypeInfo(TBitmap), @BmpButton.Bitmaps.Hot);
      TJvInspectorVarData.New(InspCat, 'Down', TypeInfo(TBitmap), @BmpButton.Bitmaps.Down);
      TJvInspectorVarData.New(InspCat, 'Disabled', TypeInfo(TBitmap), @BmpButton.Bitmaps.Disabled);
    end;
  end;
end;

procedure TObjectsDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
end;

procedure TObjectsDlg.Open;
begin
  if not Assigned(MagneticWndProc) then
    if Assigned(MagneticWnd) and (not MagneticAddWindow) then begin
      MagneticAddWindow := True;
      MagneticWnd.AddWindow(Self.Handle, FrmGameLogin.Handle, MagneticWndProc);
    end;
  Show;
end;

procedure TObjectsDlg.FormDestroy(Sender: TObject);
begin
  if Assigned(MagneticWnd) then
    MagneticWnd.RemoveWindow(Self.Handle);
end;

procedure TObjectsDlg.JvInspectorDataValueChanged(Sender: TObject;
  Data: TJvCustomInspectorData);
begin
  //if Data is TJvInspectorPropData then
   // TWinControl(TJvInspectorPropData(Data).Instance).SetFocus;
 { if Data is TJvInspectorPropData then begin
    if TJvInspectorPropData(Data).Instance = FrmGameLogin.TreeView then begin
      FrmGameLogin.TreeView.Color := g_ViewBColor;
      FrmGameLogin.TreeView.Font.Color := g_ViewFColor;
    end else
      if TJvInspectorPropData(Data).Instance = FrmGameLogin.LabelStatus then begin
      FrmGameLogin.LabelStatus.Font.Color := g_LabelConnectColor;
    end;
 // Showmessage(TJvInspectorPropData(Data).Instance.ClassName)
  end;}
end;

procedure TObjectsDlg.FormActivate(Sender: TObject);
begin
  //FrmGameLogin.SizeControl.Enabled:=False;
end;

initialization
  TJvInspectorAlignItem.RegisterAsDefaultItem;
  TJvInspectorAnchorsItem.RegisterAsDefaultItem;
  TJvInspectorColorItem.RegisterAsDefaultItem;
  TJvInspectorTImageIndexItem.RegisterAsDefaultItem;

end.

