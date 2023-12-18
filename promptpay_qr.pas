unit promptpay_qr;

interface
uses System.RegularExpressions, System.SysUtils, System.StrUtils, System.Classes;


const ID_PAYLOAD_FORMAT = '00';
const ID_POI_METHOD = '01';
const ID_MERCHANT_INFORMATION_BOT = '29';
const ID_TRANSACTION_CURRENCY = '53';
const ID_TRANSACTION_AMOUNT = '54';
const ID_COUNTRY_CODE = '58';
const ID_CRC = '63';

const PAYLOAD_FORMAT_EMV_QRCPS_MERCHANT_PRESENTED_MODE = '01';
const POI_METHOD_STATIC = '11';
const POI_METHOD_DYNAMIC = '12';
const MERCHANT_INFORMATION_TEMPLATE_ID_GUID = '00';
const BOT_ID_MERCHANT_PHONE_NUMBER = '01';
const BOT_ID_MERCHANT_TAX_ID = '02';
const BOT_ID_MERCHANT_EWALLET_ID = '03';
const GUID_PROMPTPAY = 'A000000677010111';
const TRANSACTION_CURRENCY_THB = '764';
const COUNTRY_CODE_TH = 'TH';

function generatePayload(target, amount: string): string;
function f (id, value: string): string;
function sanitizeTarget (id: string): string;
function serialize (xs: array of string): string;
function formatTarget (id:string):string;
function formatCrc (crcValue: string): string;
function formatAmount (amount: string): string;
function getCRC16(Buffer:String):Cardinal;

implementation


function generatePayload(target, amount: string): string;
var
  targetType, dataToCrc, POI, _amount: string;
  data: array of string;
begin
  target := sanitizeTarget(target);

  if Length(target) >= 15 then
    targetType := BOT_ID_MERCHANT_EWALLET_ID
  else if Length(target) >= 13 then
    targetType := BOT_ID_MERCHANT_TAX_ID
  else
    targetType := BOT_ID_MERCHANT_PHONE_NUMBER;

  _amount := '';
  POI := POI_METHOD_STATIC;
  if (amount <> '') then begin
    POI := POI_METHOD_DYNAMIC;
    _amount := f(ID_TRANSACTION_AMOUNT, formatAmount(amount));
  end;

  data := [
    f(ID_PAYLOAD_FORMAT, PAYLOAD_FORMAT_EMV_QRCPS_MERCHANT_PRESENTED_MODE),
    f(ID_POI_METHOD, POI),
    f(ID_MERCHANT_INFORMATION_BOT, serialize([
      f(MERCHANT_INFORMATION_TEMPLATE_ID_GUID, GUID_PROMPTPAY),
      f(targetType, formatTarget(target))
    ])),
    f(ID_COUNTRY_CODE, COUNTRY_CODE_TH),
    f(ID_TRANSACTION_CURRENCY, TRANSACTION_CURRENCY_THB)
  ];

  if _amount <> '' then
  data := data + [_amount];
    //data[Length(data) + 1] := _amount;

  dataToCrc := serialize(data) + ID_CRC + '04';

  data := data + [f(ID_CRC, formatCrc(getCRC16(dataToCrc).ToHexString))];

  Result := serialize(data);
end;
 {
  target = sanitizeTarget(target)

  var amount = options.amount
  var targetType = (
    target.length >= 15 ? (
      BOT_ID_MERCHANT_EWALLET_ID
    ) : target.length >= 13 ? (
      BOT_ID_MERCHANT_TAX_ID
    ) : (
      BOT_ID_MERCHANT_PHONE_NUMBER
    )
  )

  var data = [
    f(ID_PAYLOAD_FORMAT, PAYLOAD_FORMAT_EMV_QRCPS_MERCHANT_PRESENTED_MODE),
    f(ID_POI_METHOD, amount ? POI_METHOD_DYNAMIC : POI_METHOD_STATIC),
    f(ID_MERCHANT_INFORMATION_BOT, serialize([
      f(MERCHANT_INFORMATION_TEMPLATE_ID_GUID, GUID_PROMPTPAY),
      f(targetType, formatTarget(target))
    ])),
    f(ID_COUNTRY_CODE, COUNTRY_CODE_TH),
    f(ID_TRANSACTION_CURRENCY, TRANSACTION_CURRENCY_THB),
    amount && f(ID_TRANSACTION_AMOUNT, formatAmount(amount))
  ]
  var dataToCrc = serialize(data) + ID_CRC + '04'
  data.push(f(ID_CRC, formatCrc(crc.crc16xmodem(dataToCrc, 0xffff))))
  return serialize(data)
}

function f (id, value: string): string;
var
  txt: string;
begin
  txt := '00' + inttostr(Length(value));
  Result := id + RightStr(txt, 2) + value;
end;
{
  return [ id, ('00' + value.length).slice(-2), value ].join('')
}

function serialize (xs: array of string): string;
var
  t: string;
begin
  for t in xs do
    Result := Result + t;

end;
{
  return xs.filter(function (x) [return x ] ).join('')
}

function sanitizeTarget (id: string): string;
begin
  Result := TRegEx.Replace(id, '[^0-9]', '')
end;
{
  return id.replace(/[^0-9]/g, '')
}

function formatTarget (id:string):string;
var
  numbers: string;
begin
  numbers := sanitizeTarget(id);
  if Length(numbers) >= 13 then
    Result := numbers
  else begin
    numbers := TRegEx.Replace(numbers, '^0', '66');
    Result := numbers.PadLeft(13, '0');
  end;

end;
{
  const numbers = sanitizeTarget(id)
  if (numbers.length >= 13) return numbers
  return ('0000000000000' + numbers.replace(/^0/, '66')).slice(-13)
}

function formatAmount (amount: string): string;
begin
  Result := Format('%.2f', [StrToFloat(amount)]);
end;
{
  return amount.toFixed(2)
}

function formatCrc (crcValue: string): string;
var
  txt: string;
begin
  txt := UpperCase(crcValue);
  Result := RightStr(txt, 4);
end;
{
  return ('0000' + crcValue.toString(16).toUpperCase()).slice(-4)
}

function getCRC16(Buffer:String):Cardinal;
const
  polynomial = $1021;
var
  i,j: Integer;
begin
Result:= $FFFF;;
  for i:=1 to Length(Buffer) do begin
  Result:=Result xor (ord(buffer[i]) shl 8);
  for j:=0 to 7 do begin
    if (Result and $8000)<>0 then Result:=(Result shl 1) xor polynomial
    else Result:=Result shl 1;
    end;
  end;
Result:=Result and $ffff;
end;

end.
