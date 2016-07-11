object fmImportTM: TfmImportTM
  Left = 50
  Top = 272
  Width = 1059
  Height = 558
  Caption = 'fmImportTM'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 1043
    Height = 68
    Align = alTop
    Caption = 'pnl1'
    TabOrder = 0
    object btn1: TButton
      Left = 199
      Top = 10
      Width = 164
      Height = 44
      Caption = #23548#20837
      TabOrder = 0
      OnClick = btn1Click
    end
    object btn2: TButton
      Left = 19
      Top = 9
      Width = 164
      Height = 44
      Caption = #36873#23450#23548#20837#25991#20214
      TabOrder = 1
      OnClick = btn2Click
    end
    object btn3: TButton
      Left = 886
      Top = 15
      Width = 75
      Height = 25
      Caption = 'btn3'
      TabOrder = 2
    end
  end
  object pnl2: TPanel
    Left = 0
    Top = 68
    Width = 1043
    Height = 452
    Align = alClient
    Caption = 'pnl2'
    TabOrder = 1
    object pnl3: TPanel
      Left = 1
      Top = 1
      Width = 646
      Height = 450
      Align = alClient
      Caption = 'pnl3'
      TabOrder = 0
      object pnl5: TPanel
        Left = 1
        Top = 1
        Width = 644
        Height = 61
        Align = alTop
        TabOrder = 0
        object lbl1: TLabel
          Left = 10
          Top = 14
          Width = 654
          Height = 36
          AutoSize = False
          Caption = #36873#25321#23548#20837#25991#20214#21518#65292#35831#30830#23450#35201#23548#20837#25991#20214#30340#31185#30446#19982#31456#33410
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
      object ejungrid1: TEjunDataGrid
        Left = 1
        Top = 62
        Width = 644
        Height = 387
        ColCount = 4
        DefaultColWidth = 73
        Selection.AlphaBlend = False
        Selection.TransparentColor = False
        Selection.DisableDrag = False
        Selection.HideBorder = False
        Align = alClient
        DataColumns = <
          item
            Width = 432
            Style.BgColor = clWindow
            Style.HorzAlign = haGeneral
            Style.VertAlign = vaCenter
            Style.Options = []
            Visible = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            UseColumnFont = False
          end
          item
            Width = 84
            Style.BgColor = clWindow
            Style.HorzAlign = haGeneral
            Style.VertAlign = vaCenter
            Style.Options = []
            Visible = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            UseColumnFont = False
          end
          item
            Width = 80
            Style.BgColor = clWindow
            Style.HorzAlign = haGeneral
            Style.VertAlign = vaCenter
            Style.Options = []
            Visible = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            UseColumnFont = False
          end>
        PopupMenu = ejungrid1.DefaultPopupMenu
        TabOrder = 1
        TabStop = True
        GridLineColor = 15062992
        GridData = {
          090810000006050000000000000000000000000031004800F5FFFFFF00000100
          4D0053002000530061006E007300200053006500720069006600000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          E0004C0000000000FFFFFF1FFFFFFF1FFFFFFF1FFFFFFF1FFFFFFF1FFFFFFF1F
          FFFFFF1FFFFFFF1FFFFFFF1FFFFFFF1F00000000000000000000000100000000
          00000000050000FF080000FF00000000E0004C0000000000FFFFFF1FFFFFFF1F
          FFFFFF1FFFFFFF1FFFFFFF1FFFFFFF1FFFFFFF1FFFFFFF1FFFFFFF1FFFFFFF1F
          0000000000000000000000010000000000000000050000FF080000FF00000014
          850017000000000000000845006A0075006E0047007200690064001E04040000
          0000000A000000090810000007100000000000000000000000000000020E0001
          0000000400000001000300000005203100666666666666294066666666666629
          4066666666666629406666666666662940666666666666294066666666666629
          40000A2031000101000000FFFFFFFF01000000FFFFFFFF000000000000000000
          000000000000000000000000000000000000000000000009202A000900640001
          000000000000000200080000000000000035403333333333B33D400000000000
          00000008007D000C000000000058020000000000007D000C0001000100501901
          00000000007D000C0002000200EC040100000000007D000C0003000300B00401
          000000000008021400000000000400FF000000000080010000FFFF0000E50002
          0000000A00000000000000}
      end
    end
    object pnl4: TPanel
      Left = 647
      Top = 1
      Width = 395
      Height = 450
      Align = alRight
      Caption = 'pnl4'
      TabOrder = 1
      object EjunDBGrid1: TEjunDBGrid
        Left = 1
        Top = 61
        Width = 393
        Height = 388
        Options = [goRangeSelect, goRowSelect, goRowSizing, goColSizing, goUnequalRowHeight, goFixedRowShowNo, goFixedColShowNo, goAlwaysShowSelection]
        OptionsEx = [goxStringGrid, goxSupportFormula, goxAutoCalculate]
        ColCount = 4
        DefaultColWidth = 73
        Selection.AlphaBlend = False
        Selection.TransparentColor = False
        Selection.DisableDrag = False
        Selection.HideBorder = False
        AllowEdit = False
        Align = alClient
        FooterRowCount = 0
        DataColumns = <
          item
            Width = 73
            Style.BgColor = clWindow
            Style.HorzAlign = haGeneral
            Style.VertAlign = vaCenter
            Style.Options = []
            Visible = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            UseColumnFont = False
          end
          item
            Width = 73
            Style.BgColor = clWindow
            Style.HorzAlign = haGeneral
            Style.VertAlign = vaCenter
            Style.Options = []
            Visible = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            UseColumnFont = False
          end
          item
            Width = 73
            Style.BgColor = clWindow
            Style.HorzAlign = haGeneral
            Style.VertAlign = vaCenter
            Style.Options = []
            Visible = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            UseColumnFont = False
          end>
        TabOrder = 0
        TabStop = True
        PopupMenu = EjunDBGrid1.DefaultPopupMenu
        OnDblClick = EjunDBGrid1DblClick
        GridData = {
          090810000006050000000000000000000000000031004800F5FFFFFF00000100
          4D0053002000530061006E007300200053006500720069006600000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          E0004C0000000000FFFFFF1FFFFFFF1FFFFFFF1FFFFFFF1FFFFFFF1FFFFFFF1F
          FFFFFF1FFFFFFF1FFFFFFF1FFFFFFF1F00000000000000000000000100000000
          00000000050000FF080000FF00000000E0004C0000000000FFFFFF1FFFFFFF1F
          FFFFFF1FFFFFFF1FFFFFFF1FFFFFFF1FFFFFFF1FFFFFFF1FFFFFFF1FFFFFFF1F
          0000000000000000000000010000000000000000050000FF080000FF00000014
          850017000000000000000845006A0075006E0047007200690064001E04040000
          0000000A000000090810000007100000000000000000000000000000020E0001
          0000000400000001000300000005203100666666666666294066666666666629
          4066666666666629406666666666662940666666666666294066666666666629
          40000A2031000101000000FFFFFFFF01000000FFFFFFFF000000000000000000
          000000000000000000000000000000000000000000000009202A000900640001
          000000000000000200080000000000000035403333333333B33D400000000000
          00000008007D000C000000000058020000000000007D000C0001000300470401
          000000000008021400000000000400FF000000000080010000FFFF0000E50002
          0000000A00000000000000}
      end
      object pnl6: TPanel
        Left = 1
        Top = 1
        Width = 393
        Height = 60
        Align = alTop
        Caption = 'pnl6'
        TabOrder = 1
        object lbl2: TLabel
          Left = 6
          Top = 12
          Width = 312
          Height = 36
          AutoSize = False
          Caption = #21452#20987#21487#23558#31185#30446#31456#33410#21152#20837#24038#34920
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
    end
  end
  object dlgOpen1: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 807
    Top = 413
  end
  object EjunLicense1: TEjunLicense
    KeyID = 'y7ERk-Tyquk-RTV1G9Gh-fGdp'
    ProductID = 'B201008101065'
    UserID = #21525#21521#38451
    Left = 601
    Top = 42
  end
end
