unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Base64;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    Edit3: TEdit;
    Edit4: TEdit;
    Memo1: TMemo;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses DesEncryptor;
{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Temp: string;
  Encryptor: TDesEncryptor;
  L: Integer;
  Printable: string;
begin
  Encryptor := TDesEncryptor.Create;
  try
    Encryptor.SetKey('00000');
    Temp := Edit1.Text;
//加密
    L := Length(Temp);
    SetLength(Temp, Encryptor.GetMaxEncodeSize(Length(Temp)));
    L := Encryptor.EncodeMem(Temp[1], L);
    SetLength(Temp, L);
//显示密文（因为密文不是ASCII码，要转换一下才能显示）
    {SetLength(Printable, L * 2);
    BinToHex(PChar(Temp), PChar(Printable), L);    }
    Edit2.Text := Base64EncodeStr(Temp);
//解密
    {L := Length(Temp);
    SetLength(Temp, Encryptor.GetMaxDecodeSize(L));
    L := Encryptor.DecodeMem(Temp[1], L);
    SetLength(Temp, L);
    Edit1.Text := Temp;}
  finally
    Encryptor.Free;
  end;
  Edit3.Text := Base64EncodeStr(Edit1.Text);
end;

{begin
  Encryptor := TDesEncryptor.Create;
  //Edit2.Text := EncryptString(Edit1.Text, '1234');
  //Edit2.Text := Base64EncodeStr(Edit1.Text);
end;  }

procedure TForm1.Button2Click(Sender: TObject);
var
  Temp: string;
  Encryptor: TDesEncryptor;
  L: Integer;
  Printable: string;
begin
  Encryptor := TDesEncryptor.Create;
  try
    Encryptor.SetKey('00000');
    Temp := Base64DecodeStr(Edit2.Text);
//解密
    L := Length(Temp);
    SetLength(Temp, Encryptor.GetMaxDecodeSize(L));
    L := Encryptor.DecodeMem(Temp[1], L);
    SetLength(Temp, L);
    Edit1.Text := Temp;
  finally
    Encryptor.Free;
  end;
end;
{begin
  //Edit1.Text := DecryptString(Edit2.Text, '1234');
  //Edit1.Text := Base64DecodeStr(Edit2.Text);
end; }

procedure TForm1.Button3Click(Sender: TObject);
var
  Temp: string;
  Encryptor: TDesEncryptor;
  I, L: Integer;
  Printable: string;
  List:TStringList;
begin
  List:=TStringList.Create;
  for I := 1 to 10000 do begin
    Encryptor := TDesEncryptor.Create;
    try
      Encryptor.SetKey('00000');
      Temp := Edit1.Text;
//加密
      L := Length(Temp);
      SetLength(Temp, Encryptor.GetMaxEncodeSize(Length(Temp)));
      L := Encryptor.EncodeMem(Temp[1], L);
      SetLength(Temp, L);
//显示密文（因为密文不是ASCII码，要转换一下才能显示）
    {SetLength(Printable, L * 2);
    BinToHex(PChar(Temp), PChar(Printable), L);    }
      Edit2.Text := Base64EncodeStr(Temp);
//解密
    {L := Length(Temp);
    SetLength(Temp, Encryptor.GetMaxDecodeSize(L));
    L := Encryptor.DecodeMem(Temp[1], L);
    SetLength(Temp, L);
    Edit1.Text := Temp;}
    finally
      Encryptor.Free;
    end;
    List.Add(Edit2.Text);

    Encryptor := TDesEncryptor.Create;
    try
      Encryptor.SetKey('00000');
      Temp := Base64DecodeStr(Edit2.Text);
//解密
      L := Length(Temp);
      SetLength(Temp, Encryptor.GetMaxDecodeSize(L));
      L := Encryptor.DecodeMem(Temp[1], L);
      SetLength(Temp, L);
      Edit1.Text := Temp;
    finally
      Encryptor.Free;
    end;
    List.Add(Edit1.Text);
  end;
  Memo1.Lines.AddStrings(List);
  List.Free;
end;

end.

