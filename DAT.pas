unit DAT;

interface

uses
  SysUtils, Classes, ADODB, DB, forms, Dialogs;

type
  Tmydb = class(TDataModule)
    DSTM: TDataSource;
    CON1: TADOConnection;
    QRYTMTS: TADOQuery;
    DSTMTS: TDataSource;
    QRYKM: TADOQuery;
    qrytm: TADOQuery;
    qrytmp: TADOQuery;
    qryzj: TADOQuery;
    dszj: TDataSource;
    dskm: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  mydb: Tmydb;

implementation

uses shareunit;

{$R *.dfm}

procedure Tmydb.DataModuleCreate(Sender: TObject);
var
  filename, ininame: string;
  ausername, apassword: string;
begin
  try
    ininame := StringReplace(Application.EXEName, '.EXE', '.ini', [rfReplaceAll, rfIgnoreCase]);
    LoadParamFromFile(ininame);
    ausername := 'admin';
  //  apassword := '690414710529zj';
    if Pos('unlimit', LowerCase(Application.EXEName)) > 0 then
      apassword := '690414710529' + lowercase(trim(mysys.pwd))
    else
      apassword := '690414710529' + lowercase(trim(mysys.pwd));
    filename := ExtractFilePath(Application.EXEName) + lowercase(trim(mysys.pwd)) + 'tm.mdb';

    con1.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;' +
      'User ID=' + AUserName + ';' +
      'Jet OLEDB:Database Password=' + APassword + ';' +
      'Data Source=' + filename + ';' +
      'Mode=ReadWrite;' +
      'Extended Properties="";';
    con1.Connected := true;
  except
    ShowMessage('数据库连结出错，退出系统');
    Application.Terminate;
  end;
end;

end.

