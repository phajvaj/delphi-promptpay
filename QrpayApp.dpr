program QrpayApp;

uses
  Vcl.Forms,
  FormQrPay in 'FormQrPay.pas' {Form32},
  promptpay_qr in 'promptpay_qr.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm32, Form32);
  Application.Run;
end.
