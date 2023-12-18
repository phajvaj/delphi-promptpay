unit FormQrPay;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DelphiZXingQRCode,
  Vcl.ExtCtrls;

type
  TForm32 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    PaintBox1: TPaintBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
  private
    QRCodeBitmap: TBitmap;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form32: TForm32;

implementation

{$R *.dfm}

uses promptpay_qr;

procedure TForm32.Button1Click(Sender: TObject);
var
  QRCode: TDelphiZXingQRCode;
  Row, Column: Integer;
  qrTxt: string;
begin
  qrTxt := generatePayload(Edit1.Text, Edit2.Text);
  Memo1.Lines.Add(qrTxt);

  QRCode := TDelphiZXingQRCode.Create;
  try
    QRCode.Data := qrTxt;
    QRCode.Encoding := TQRCodeEncoding(4);
    QRCode.QuietZone := 3;
    QRCodeBitmap.SetSize(QRCode.Rows, QRCode.Columns);
    for Row := 0 to QRCode.Rows - 1 do
    begin
      for Column := 0 to QRCode.Columns - 1 do
      begin
        if (QRCode.IsBlack[Row, Column]) then
        begin
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clBlack;
        end else
        begin
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clWhite;
        end;
      end;
    end;
  finally
    QRCode.Free;
  end;
  PaintBox1.Repaint;
  {qrTxt := '00020101021229370016A000000677010111011300668013214345802TH530376454045.006304';
  Memo1.Lines.Add(getCRC16(qrTxt).ToHexString);

  qrTxt := '0801321434';
  Memo1.Lines.Add(formatTarget(qrTxt));}

end;

procedure TForm32.FormCreate(Sender: TObject);
begin
  QRCodeBitmap := TBitmap.Create;
end;

procedure TForm32.FormDestroy(Sender: TObject);
begin
  QRCodeBitmap.Free;
end;

procedure TForm32.PaintBox1Paint(Sender: TObject);
var
  Scale: Double;
begin
  PaintBox1.Canvas.Brush.Color := clWhite;
  PaintBox1.Canvas.FillRect(Rect(0, 0, PaintBox1.Width, PaintBox1.Height));
  if ((QRCodeBitmap.Width > 0) and (QRCodeBitmap.Height > 0)) then
  begin
    if (PaintBox1.Width < PaintBox1.Height) then
    begin
      Scale := PaintBox1.Width / QRCodeBitmap.Width;
    end else
    begin
      Scale := PaintBox1.Height / QRCodeBitmap.Height;
    end;
    PaintBox1.Canvas.StretchDraw(Rect(0, 0, Trunc(Scale * QRCodeBitmap.Width), Trunc(Scale * QRCodeBitmap.Height)), QRCodeBitmap);
  end;
end;

end.
