object formbjb: Tformbjb
  Left = 320
  Top = 75
  Anchors = [akLeft, akTop, akRight, akBottom]
  AutoScroll = False
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  Caption = #25105#30340#31508#35760#26412
  ClientHeight = 563
  ClientWidth = 848
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PrintScale = poNone
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 848
    Height = 49
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 0
    object Button1: TButton
      Left = 488
      Top = 8
      Width = 75
      Height = 25
      Caption = #20445#23384
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 16
      Top = 8
      Width = 75
      Height = 25
      Caption = #21152#37325#28857
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 88
      Top = 8
      Width = 75
      Height = 25
      Caption = #21462#28040#37325#28857
      TabOrder = 2
      OnClick = Button3Click
    end
    object BitBtn1: TBitBtn
      Left = 160
      Top = 8
      Width = 49
      Height = 25
      Caption = '|<<'
      TabOrder = 3
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 208
      Top = 8
      Width = 49
      Height = 25
      Caption = '<'
      TabOrder = 4
      OnClick = BitBtn2Click
    end
    object BitBtn3: TBitBtn
      Left = 256
      Top = 8
      Width = 49
      Height = 25
      Caption = '>'
      TabOrder = 5
      OnClick = BitBtn3Click
    end
    object BitBtn4: TBitBtn
      Left = 304
      Top = 8
      Width = 49
      Height = 25
      Caption = '>>|'
      TabOrder = 6
      OnClick = BitBtn4Click
    end
    object BitBtn5: TBitBtn
      Left = 344
      Top = 8
      Width = 75
      Height = 25
      Caption = #26032#22686' '
      TabOrder = 7
      OnClick = BitBtn5Click
    end
    object BitBtn6: TBitBtn
      Left = 416
      Top = 8
      Width = 75
      Height = 25
      Caption = #21024#38500' '
      TabOrder = 8
      OnClick = BitBtn6Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 49
    Width = 848
    Height = 514
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 1
    object WebBrowser1: TWebBrowser
      Left = 1
      Top = 1
      Width = 846
      Height = 512
      Align = alClient
      TabOrder = 0
      ControlData = {
        4C00000070570000EB3400000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
    object Memo1: TMemo
      Left = 160
      Top = 64
      Width = 289
      Height = 169
      Lines.Strings = (
        'Memo1')
      TabOrder = 1
    end
    object RichEdit1: TRichEdit
      Left = 464
      Top = 80
      Width = 185
      Height = 89
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        'RichEdit1')
      ParentFont = False
      TabOrder = 2
    end
  end
  object qrytmp: TADOQuery
    Connection = mydb.CON1
    Parameters = <>
    Left = 584
    Top = 24
  end
end
