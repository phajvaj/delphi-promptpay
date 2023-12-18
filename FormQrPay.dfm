object Form32: TForm32
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'App Gen Promptpay Qrcode'
  ClientHeight = 235
  ClientWidth = 601
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    601
    235)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 17
    Width = 11
    Height = 13
    Caption = 'ID'
  end
  object Label2: TLabel
    Left = 8
    Top = 44
    Width = 37
    Height = 13
    Caption = 'Amount'
  end
  object PaintBox1: TPaintBox
    Left = 358
    Top = 17
    Width = 235
    Height = 213
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clHighlight
    ParentColor = False
    OnPaint = PaintBox1Paint
  end
  object Edit1: TEdit
    Left = 51
    Top = 14
    Width = 178
    Height = 21
    TabOrder = 0
    Text = '0801321434'
    TextHint = 'ID Card / Phone'
  end
  object Edit2: TEdit
    Left = 51
    Top = 41
    Width = 178
    Height = 21
    TabOrder = 1
    Text = '5'
    TextHint = 'Amount Bath'
  end
  object Button1: TButton
    Left = 240
    Top = 12
    Width = 101
    Height = 50
    Caption = 'Gen Code'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 68
    Width = 333
    Height = 162
    TabOrder = 3
  end
end
