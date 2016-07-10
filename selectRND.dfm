object fmselectRND: TfmselectRND
  Left = 514
  Top = 205
  Width = 591
  Height = 359
  Caption = #38543#26426#25277#39064
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 40
    Width = 24
    Height = 13
    Caption = #21333#36873
  end
  object Label2: TLabel
    Left = 48
    Top = 80
    Width = 24
    Height = 13
    Caption = #22810#36873
  end
  object Label3: TLabel
    Left = 48
    Top = 112
    Width = 24
    Height = 13
    Caption = #21028#26029
  end
  object Label4: TLabel
    Left = 24
    Top = 144
    Width = 48
    Height = 13
    Caption = #35745#31639#32508#21512
  end
  object Label6: TLabel
    Left = 184
    Top = 40
    Width = 12
    Height = 13
    Caption = #39064
  end
  object Label7: TLabel
    Left = 184
    Top = 80
    Width = 12
    Height = 13
    Caption = #39064
  end
  object Label8: TLabel
    Left = 184
    Top = 112
    Width = 12
    Height = 13
    Caption = #39064
  end
  object Label9: TLabel
    Left = 184
    Top = 144
    Width = 12
    Height = 13
    Caption = #39064
  end
  object Edit1: TEdit
    Left = 96
    Top = 40
    Width = 80
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#20116#31508#36755#20837#27861
    TabOrder = 0
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 96
    Top = 80
    Width = 80
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#20116#31508#36755#20837#27861
    TabOrder = 1
    Text = 'Edit2'
  end
  object Edit3: TEdit
    Left = 96
    Top = 112
    Width = 80
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#20116#31508#36755#20837#27861
    TabOrder = 2
    Text = 'Edit3'
  end
  object Edit4: TEdit
    Left = 96
    Top = 144
    Width = 80
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#20116#31508#36755#20837#27861
    TabOrder = 3
    Text = 'Edit4'
  end
  object Button1: TButton
    Left = 32
    Top = 232
    Width = 89
    Height = 25
    Caption = #24320#22987#25277#39064
    TabOrder = 4
    OnClick = Button1Click
  end
  object DBGridEh1: TDBGridEh
    Left = 240
    Top = 40
    Width = 313
    Height = 161
    DataSource = DataSource1
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'MS Sans Serif'
    FooterFont.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#20116#31508#36755#20837#27861
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 5
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = DBGridEh1DblClick
    Columns = <
      item
        EditButtons = <>
        Footers = <>
      end
      item
        EditButtons = <>
        Footers = <>
      end
      item
        EditButtons = <>
        Footers = <>
      end>
  end
  object CheckBox1: TCheckBox
    Left = 240
    Top = 232
    Width = 185
    Height = 17
    Caption = #21482#26597#27169#25311#19982#21382#24180#32771#39064
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object ADOTable1: TADOTable
    Connection = mydb.CON1
    Left = 528
    Top = 8
  end
  object DataSource1: TDataSource
    DataSet = ADOTable1
    Left = 440
    Top = 8
  end
end
