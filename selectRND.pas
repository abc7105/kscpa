unit selectRND;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, DB, ADODB, GridsEh, DBGridEh;

type
  TfmselectRND = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    ADOTable1: TADOTable;
    DataSource1: TDataSource;
    Button1: TButton;
    DBGridEh1: TDBGridEh;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DBGridEh1DblClick(Sender: TObject);
    function edt2int(str: string): integer;
    procedure sorttmtmp();
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmselectRND: TfmselectRND;

implementation

uses DAT, shareunit;

{$R *.dfm}

procedure TfmselectRND.FormCreate(Sender: TObject);
begin
  edit1.Text := '15';
  edit2.Text := '10';
  edit3.Text := '10';
  edit4.Text := '4';

  dbgrideh1.Columns[1].FieldName := 'name';
  dbgrideh1.Columns[0].FieldName := 'id';
  dbgrideh1.Columns[2].FieldName := 'isuse';

  dbgrideh1.Columns[1].Title.caption := '科目名称';
  dbgrideh1.Columns[0].Title.caption := '编码';
  dbgrideh1.Columns[2].Title.caption := '是否抽题';

  dbgrideh1.Columns[1].Width := 120;
  dbgrideh1.Columns[0].Width := 50;
  dbgrideh1.Columns[2].Width := 70;
  adotable1.TableName := 'km';
  adotable1.Open;
end;

procedure TfmselectRND.Button1Click(Sender: TObject);
var
  ts: integer;
  sjs, r, i: integer;
begin
  Randomize;
  try
    mydb.qrytmp.close;
    MYDB.QRYTMP.SQL.CLEAR;
    mydb.qrytmp.SQL.Add('    create table selecttm(id long);');
    //   mydb.qrytmp.ExecSQL;
  except
  end;

  ts := edt2int(edit1.Text);
  sjs := random(ts);

  mydb.qrytmp.close;
  MYDB.QRYTMP.SQL.CLEAR;
  mydb.qrytmp.SQL.Add('  delete from selecttm');
  mydb.qrytmp.ExecSQL;
  Randomize;
  r := Random(100);
  if ts > 0 then
  begin
    mydb.qrytmp.close;
    MYDB.QRYTMP.SQL.CLEAR;
    mydb.qrytmp.SQL.Add('insert into selecttm ');

    mydb.qrytmp.SQL.Add('select top ' + inttostr(ts) + '  id  from abcd where ');
    mydb.qrytmp.SQL.Add('len(xans)=1 and (xans<>"×") and (xans<>"√") and  ');
    if not checkbox1.Checked then
      mydb.qrytmp.SQL.Add('tmts in (select tmts.ts as tmts from tmts,km where tmts.km=km.id and km.isuse )')
    else
      mydb.qrytmp.SQL.Add('tmts in (select tmts.ts as tmts from tmts,km where tmts.km=km.id and km.isuse and (tmts.zjid="998" or  tmts.zjid="999"))');
    mydb.qrytmp.SQL.Add('order by rnd(' + inttostr(r) + '-id)  asc');

    mydb.qrytmp.execsql;
  end;

  ts := edt2int(edit2.Text);
  r := Random(100);
  if ts > 0 then
  begin
    mydb.qrytmp.close;
    MYDB.QRYTMP.SQL.CLEAR;
    mydb.qrytmp.SQL.Add('insert into selecttm ');
    mydb.qrytmp.SQL.Add('select top ' + inttostr(ts) + '  id  from tm where ');
    mydb.qrytmp.SQL.Add('len(xans)>1 and (xans<>"×") and (xans<>"√") and  ');
    if not checkbox1.Checked then
      mydb.qrytmp.SQL.Add('tmts in (select tmts.ts as tmts from tmts,km where tmts.km=km.id and km.isuse)')
    else
      mydb.qrytmp.SQL.Add('tmts in (select tmts.ts as tmts from tmts,km where tmts.km=km.id and km.isuse and (tmts.zjid="998" or  tmts.zjid="999")) ');
    mydb.qrytmp.SQL.Add(' order by rnd(' + inttostr(r) + '-id)  asc');
    mydb.qrytmp.execsql;

  end;

  ts := edt2int(edit3.Text);
  r := Random(100);
  if ts > 0 then
  begin
    mydb.qrytmp.close;
    MYDB.QRYTMP.SQL.CLEAR;
    mydb.qrytmp.SQL.Add('insert into selecttm ');
    mydb.qrytmp.SQL.Add('select top ' + inttostr(ts) + '  id  from tm where ');
    mydb.qrytmp.SQL.Add('len(xans)>0 and ((xans="×") or (xans="√")) and  ');
    if not checkbox1.Checked then
      mydb.qrytmp.SQL.Add('tmts in (select tmts.ts as tmts from tmts,km where tmts.km=km.id and km.isuse) ')
    else
      mydb.qrytmp.SQL.Add('tmts in (select tmts.ts as tmts from tmts,km where tmts.km=km.id and km.isuse and (tmts.zjid="998" or  tmts.zjid="999")) ');
    mydb.qrytmp.SQL.Add(' order by rnd(' + inttostr(r) + '-id)  asc');
    mydb.qrytmp.execsql;
  end;

  ts := edt2int(edit4.Text);
  r := Random(100);
  if ts > 0 then
  begin
    mydb.qrytmp.close;
    MYDB.QRYTMP.SQL.CLEAR;
    mydb.qrytmp.SQL.Add('insert into selecttm ');
    mydb.qrytmp.SQL.Add('select top ' + inttostr(ts) + '  id  from tm where ');
    mydb.qrytmp.SQL.Add('len(xans)<1 and len(ans)>0 and  ');
    if not checkbox1.Checked then
      mydb.qrytmp.SQL.Add('tmts in (select tmts.ts as tmts from tmts,km where tmts.km=km.id and km.isuse) ')
    else
      mydb.qrytmp.SQL.Add('tmts in (select tmts.ts as tmts from tmts,km where tmts.km=km.id and km.isuse and (tmts.zjid="998" or  tmts.zjid="999")) ');
    mydb.qrytmp.SQL.Add(' order by rnd(' + inttostr(r) + '-id)  asc');

    mydb.qrytmp.execsql;
  end;

  mydb.qrytmp.close;
  MYDB.QRYTMP.SQL.CLEAR;
  mydb.qrytmp.SQL.Add('delete from tmtmp');
  mydb.qrytmp.ExecSQL;

  MYDB.QRYTMp.SQL.CLEAR;
  mydb.QRYTMp.SQL.Add('insert into tmtmp ');
  mydb.QRYTMp.SQL.Add('select tm.*  from tm,selecttm where ');
  mydb.QRYTMp.SQL.Add('tm.id= selecttm.id order by selecttm.sxh ');
  mydb.QRYTMp.ExecSQL;

  sorttmtmp;
  close;
end;

procedure TfmselectRND.DBGridEh1DblClick(Sender: TObject);
begin
  adotable1.Edit;
  adotable1.FieldByName('isuse').AsBoolean := not adotable1.FieldByName('isuse').AsBoolean;
  adotable1.Post;
end;

function TfmselectRND.edt2int(str: string): integer;
begin
  result := 0;
  try
    result := strtoint(str);
  except
    result := 0;
    exit;
  end;
end;

procedure TfmselectRND.sorttmtmp;
var

  str1, str2, STR3, STRTMP, STRX: string;
  len1, len2, pos1, pos2: integer;
  I: INTEGER;
  x1, x2, x3, x4, kk: integer;
  adotable1: TADOTABLE;
begin

  ADOTABLE1 := TADOTABLE.Create(nil);
  ADOTABLE1.Connection := MYDB.CON1;
  ADOTABLE1.TableName := 'TMTMP';
  with ADOTABLE1 do
  begin
    Open;
    i := 1;
    adotable1.First;
    while not eof do
    begin
      str1 := trim(adotable1.fieldbyname('title').asstring);
      len1 := pos('】', str1);
      Pos1 := Length(str1);
      if (len1 >= 1) then
        str1 := copy(str1, len1 + 2, pos1 - len1 + 1 - 2);


      STR3 := trim(adotable1.fieldbyname('ANS').asstring);
      pos2 := Length(STR3);
      len2 := pos('】', str3);
      if len2 > 0 then
        str3 := copy(str3, len2 + 2, pos2 - len2 + 1 - 2);

      kk := i;

      str1 := '(' + inttostr(kk) + ').' + str1;

      if pos2 > 0 then
        str3 := '(' + inttostr(kk) + ').' + str3;


      if LENGTH(STR1) > 0 then
      begin
        ADOTABLE1.Edit;
        adotable1.fieldbyname('TITLE').AsString := str1;
        adotable1.fieldbyname('ans').AsString := str3;
        ADOTABLE1.Post;
      end;
      adotable1.Next;

      inc(i);
    end;
    CLOSE;
    FREE;
  end;
end;
end.

