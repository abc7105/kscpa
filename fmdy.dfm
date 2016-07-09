object formdy: Tformdy
  Left = 230
  Top = 47
  Width = 886
  Height = 637
  Caption = #25171#21360
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    00CCCCC00000000000000000000000000CCCCC00000000000000000099000000
    CCCCCC00000099900000000999900000CCCCC00000099999000000099990000C
    CCCC00000009999900000099999000CCCCC00099000099999000009999000CCC
    CCC0099990009999999999999900CCCCCC00099990009999999999999900CCCC
    C000099990000999999999999000CCCC00000999900009999999999990000CC0
    0000099990000099999099999000000000000999900000999990999900000000
    0000099990000009999999990000000000000999999999099999999900000009
    9999999999999990999999900000009999999999999999999999999000000099
    9999999999999999099999000000099999999999990099999099990000000999
    9000999999000999900990000000099990009999990099999000000000000999
    9000999999009999900000000000099990009999999999990000000000000999
    9000099999999999000000000000099990000099999999900000000000000999
    9000000099999900000000000000099999000000000000000000000000000999
    9990000000000000000999900000009999999999999999999999999900000009
    9999999999999999999999990000000099999999999999999999999000000000
    099999999999999999990000000000000000000000000000000000000000FC1F
    FFFFF83FFFF3F03F1FE1F07E0FE1E0FE0FC1C1CF07C381870003038700030787
    80070F8780079F87C107FF87C10FFF87E00FFF80200FE000101FC000001FC000
    083F8003043F8703867F870307FF870307FF87000FFF87800FFF87C01FFF87F0
    3FFF83FFFFFF81FFFE1FC000000FE000000FF000001FF80000FFFFFFFFFF}
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 256
    Top = 27
    Width = 121
    Height = 16
    AutoSize = False
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Button1: TButton
    Left = 384
    Top = 21
    Width = 113
    Height = 33
    Caption = #25171#21360
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #26032#23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object CheckBox2: TCheckBox
    Left = 24
    Top = 27
    Width = 105
    Height = 16
    Caption = #31572#26696#38543#39064#25171#21360
    TabOrder = 1
    OnClick = CheckBox2Click
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 72
    Width = 833
    Height = 460
    Caption = #36873#25321#25171#21360
    TabOrder = 3
    object advs1: TStringGrid
      Left = 2
      Top = 56
      Width = 829
      Height = 402
      Align = alClient
      FixedCols = 0
      TabOrder = 0
      OnDblClick = advs1DblClick
    end
    object Panel1: TPanel
      Left = 2
      Top = 15
      Width = 829
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object Button2: TButton
        Left = 16
        Top = 8
        Width = 75
        Height = 25
        Caption = #20840#36873
        TabOrder = 0
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 96
        Top = 8
        Width = 57
        Height = 25
        Caption = #20840#19981#36873
        TabOrder = 1
        OnClick = Button3Click
      end
      object Button6: TButton
        Left = 160
        Top = 8
        Width = 75
        Height = 25
        Caption = #21482#36873#22823#39064
        TabOrder = 2
        OnClick = Button6Click
      end
      object Button7: TButton
        Left = 240
        Top = 8
        Width = 75
        Height = 25
        Caption = #19981#36873#22823#39064
        TabOrder = 3
        OnClick = Button7Click
      end
    end
  end
  object Button5: TButton
    Left = 368
    Top = 0
    Width = 75
    Height = 25
    Caption = #35774#32622#23383#20307
    TabOrder = 4
    Visible = False
    OnClick = Button5Click
  end
  object Memo1: TMemo
    Left = 160
    Top = 216
    Width = 425
    Height = 337
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#20116#31508#36755#20837#27861
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 2
    Visible = False
  end
  object Panel2: TPanel
    Left = 552
    Top = 144
    Width = 385
    Height = 185
    Caption = 'Panel2'
    TabOrder = 5
    object WebBrowser1: TWebBrowser
      Left = 32
      Top = 16
      Width = 300
      Height = 150
      TabOrder = 0
      OnNewWindow2 = WebBrowser1NewWindow2
      OnNavigateComplete2 = WebBrowser1NavigateComplete2
      ControlData = {
        4C000000021F0000810F00000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object Button4: TButton
    Left = 520
    Top = 24
    Width = 75
    Height = 25
    Caption = #29983#25104'word'#25991#26723
    TabOrder = 6
    Visible = False
    OnClick = Button4Click
  end
  object CheckBox1: TCheckBox
    Left = 240
    Top = 27
    Width = 97
    Height = 16
    Caption = #21033#29992'word'#25171#21360
    TabOrder = 7
  end
  object CheckBox3: TCheckBox
    Left = 136
    Top = 27
    Width = 81
    Height = 16
    Caption = #25171#21360#31572#26696
    TabOrder = 8
  end
  object dsdy: TDataSource
    DataSet = ADOQuery1
    Left = 296
    Top = 376
  end
  object ADOQuery1: TADOQuery
    Connection = mydb.CON1
    Parameters = <>
    Left = 360
    Top = 376
  end
  object FontDialog1: TFontDialog
    OnClose = FontDialog1Close
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 384
    Top = 61
  end
  object WordDocument1: TWordDocument
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    Left = 536
    Top = 91
  end
  object WordApplication1: TWordApplication
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    AutoQuit = False
    Left = 416
    Top = 107
  end
  object SaveDialog1: TSaveDialog
    Left = 464
    Top = 48
  end
end
