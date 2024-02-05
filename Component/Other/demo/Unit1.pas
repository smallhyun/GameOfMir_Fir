unit Unit1;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, HTTPGet;

type
  TForm1 = class(TForm)
    ProgressBar: TProgressBar;
    Panel1: TPanel;
    Image: TImage;
    HTTPGetPicture: THTTPGet;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label3: TLabel;
    Bevel1: TBevel;
    GroupBox1: TGroupBox;
    URLEdit: TEdit;
    Label2: TLabel;
    Label4: TLabel;
    FileNameEdit: TEdit;
    Button3: TButton;
    HTTPGetString: THTTPGet;
    HTTPGetFile: THTTPGet;
    UseCacheBox: TCheckBox;
    Button4: TButton;
    procedure HTTPGetPictureDoneFile(Sender: TObject; FileName: String; FileSize: Integer);
    procedure HTTPGetPictureError(Sender: TObject);
    procedure HTTPGetPictureProgress(Sender: TObject; TotalSize, Readed: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure HTTPGetStringDoneString(Sender: TObject; Result: String);
    procedure Button3Click(Sender: TObject);
    procedure HTTPGetFileDoneFile(Sender: TObject; FileName: String; FileSize: Integer);
    procedure UseCacheBoxClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure HTTPGetFileDoneStream(Sender: TObject;
      Stream: TMemoryStream);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.HTTPGetPictureDoneFile(Sender: TObject; FileName: String; FileSize: Integer);
begin
  Image.Picture.LoadFromFile(FileName);
  ProgressBar.Position := 0;
end;

procedure TForm1.HTTPGetPictureError(Sender: TObject);
begin
  ShowMessage('Error');
end;

procedure TForm1.HTTPGetPictureProgress(Sender: TObject; TotalSize,
  Readed: Integer);
begin
  ProgressBar.Max := TotalSize;
  ProgressBar.Position := Readed;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  HTTPGetPicture.GetFile;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  HTTPGetString.GetString;
end;

procedure TForm1.HTTPGetStringDoneString(Sender: TObject; Result: String);
begin
  ShowMessage(Result);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  HTTPGetFile.URL := URLEdit.Text;
  HTTPGetFile.FileName := FileNameEdit.Text;
  HTTPGetFile.GetFile;
end;

procedure TForm1.HTTPGetFileDoneFile(Sender: TObject; FileName: String; FileSize: Integer);
begin
  ShowMessage('File stored to: ' + FileName + #13#10 +
              'File size: ' + IntToStr(FileSize) + ' bytes');
end;

procedure TForm1.UseCacheBoxClick(Sender: TObject);
begin
  HTTPGetFile.UseCache := UseCacheBox.Checked;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  HTTPGetFile.URL := URLEdit.Text;
  HTTPGetFile.GetStream;
end;

procedure TForm1.HTTPGetFileDoneStream(Sender: TObject;
  Stream: TMemoryStream);
begin
  ShowMessage('HTTPGetFileDoneStreamo: ' +
              'File size: ' + IntToStr(Stream.Size) + ' bytes');
  Stream.SaveToFile('CqFir.rar');
end;

end.
