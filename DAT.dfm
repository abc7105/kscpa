object mydb: Tmydb
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 334
  Top = 5
  Height = 723
  Width = 1032
  object DSTM: TDataSource
    Left = 96
    Top = 32
  end
  object CON1: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Password=690414710529abc;Data S' +
      'ource=F:\_delphi60prog\NEWKS\tm.mdb;Persist Security Info=True'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 32
    Top = 32
  end
  object QRYTMTS: TADOQuery
    Connection = CON1
    Parameters = <>
    Left = 296
    Top = 24
  end
  object DSTMTS: TDataSource
    Left = 368
    Top = 16
  end
  object QRYKM: TADOQuery
    Connection = CON1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from km')
    Left = 272
    Top = 208
  end
  object qrytm: TADOQuery
    Connection = CON1
    Parameters = <>
    Left = 152
    Top = 24
  end
  object qrytmp: TADOQuery
    Connection = CON1
    Parameters = <>
    Left = 40
    Top = 104
  end
  object qryzj: TADOQuery
    Connection = CON1
    Parameters = <>
    Left = 128
    Top = 216
  end
  object dszj: TDataSource
    DataSet = qryzj
    Left = 168
    Top = 216
  end
  object dskm: TDataSource
    DataSet = QRYKM
    Left = 312
    Top = 208
  end
end
