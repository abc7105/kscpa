unit utm;

interface

uses SysUtils, Classes, forms, DB, ADODB, mshtml, SHDocVw, StdCtrls, ComCtrls,
  dialogs;

const
  TMTYPE_ONESELECT = 1;
  TMTYPE_MULTISELECT = 2;
  TMTYPE_judgment = 3;
  TMTYPE_OTHER = 4;

type
  WholeTmRec = record
    id: longint;
    title: string;
    answer: string;
    shortanswer: string;
    myshortanswer: string;
    myanswer: string;
    ISerr: Boolean;
    isimportant: Boolean;
    TMTYPE: Integer;
  end;

  OpenOneTM = class
  private
    fWholeTmRec: WholeTmRec;
    fID: Integer;
    qrytmp: TADOQuery;
    function GETID: INTEGER;
    procedure queryid(const xid: Integer);
    procedure SETID(const Value: INTEGER);
    procedure setWholeTmRec(const Value: WholeTmRec);

  published
    property aWholeTmRec: WholeTmRec read fWholeTmRec write setWholeTmRec;
    property ID: INTEGER read GETID write SETID;
    procedure CLEAR;
  public
    constructor create(qrycx: tadoquery);
    procedure titletoWEB(WEB: TWEBBROWSER);
    procedure ANStoWEB(WEB: TWEBBROWSER);
    procedure ShortAnswerToedit(edt: Tedit);
    procedure LongAnsToRichedit(edt: Trichedit);
    procedure Update_MyShortAnswer();
    procedure Update_Mylonganswer;
    procedure Update_Isimportant();
    function TMTYPE(): INTEGER;
    function tmtype_chinese: string;
  end;

implementation

uses
  ucommunit;

{ tm }

procedure OpenOneTM.CLEAR;
begin
  //
  fWholeTmRec.id := 0;
  fWholeTmRec.title := '';
  fWholeTmRec.answer := '';
  fWholeTmRec.shortanswer := '';
  fWholeTmRec.myanswer := '';
  fWholeTmRec.myshortanswer := '';
  fWholeTmRec.ISerr := FALSE;
  fWholeTmRec.isimportant := False;
  fWholeTmRec.TMTYPE := 4;
end;

constructor OpenOneTM.create(qrycx: tadoquery);
begin
  //
  qrytmp := qrycx;
end;

function OpenOneTM.GETID: INTEGER;
begin
  //
  result := FID;
end;

procedure OpenOneTM.queryid(const xid: Integer);
begin
  //
  qrytmp.close;
  qrytmp.sql.Clear;
  qrytmp.SQL.Add('select * from tm where id=:id');
  //  qrytmp.Parameters.Clear;
  qrytmp.Parameters.ParamByName('id').Value := xid;
  qrytmp.Open;

  if qrytmp.RecordCount > 0 then
  begin
    CLEAR;

    fWholeTmRec.id := xid;
    fWholeTmRec.title := qrytmp.fieldbyname('title').asstring;
    fWholeTmRec.answer := qrytmp.fieldbyname('ans').asstring;
    fWholeTmRec.shortanswer := qrytmp.fieldbyname('xans').asstring;
    fWholeTmRec.myanswer := qrytmp.fieldbyname('myans').asstring;
    fWholeTmRec.myshortanswer := qrytmp.fieldbyname('xmyans').asstring;
    fWholeTmRec.ISerr := qrytmp.fieldbyname('iserr').asboolean;
    fWholeTmRec.isimportant := qrytmp.fieldbyname('istb').asboolean;
    fWholeTmRec.TMTYPE := TMTYPE;

  //    showmessage(IntToStr(fWholeTmRec.id) + '    ' + fWholeTmRec.title);
  end
  else
  begin
    CLEAR;
  end;

end;

procedure OpenOneTM.SETID(const Value: INTEGER);
begin
  //
  fid := Value;
  queryid(fID);
end;

procedure OpenOneTM.ShortAnswerToedit(edt: Tedit);
begin
  edt.text := fWholeTmRec.myshortanswer;
end;

procedure OpenOneTM.titletoWEB(WEB: TWEBBROWSER);
var
  f: Textfile;
begin
  if fileExists(extractfilepath(application.exename) + 'tmp.htm') then
    DeleteFile(extractfilepath(application.exename) + 'tmp.htm');
  {看文件是否存在,在就刪除}
  AssignFile(F, extractfilepath(application.exename) + 'tmp.htm');
  {将文件名与变量 F 关联}
  ReWrite(F); {创建一个新的文件并命名为 ek.txt}

  Writeln(F, '<html>');
  Writeln(F, '    <style type="text/css">');
  Writeln(F, '<!--');
  Writeln(F, '.main {');
  Writeln(F, '	font-family: "宋体";'); //         楷体_GB2312
  Writeln(F, '	font-size: 16px;');
  Writeln(F, '	line-height: 25px;');
  Writeln(F, '      	margin:0px;');
  Writeln(F, 'padding:6px;');

  Writeln(F, '	background-color: #ffffff;');
  Writeln(F, '	text-align: left; ');
  Writeln(F, '	color: #000000;');
  Writeln(F, '}               ');
  Writeln(F, '.main p{');
  Writeln(F, '	font-family: "宋体";');
  Writeln(F, '	font-size: 16px;');
  Writeln(F, '	line-height: 22px;');
  Writeln(F, '      	margin:0px;');
  Writeln(F, 'padding:0px;');
  Writeln(F, '}               ');
  Writeln(F, '.p2{');
  Writeln(F, '	font-family: "宋体";');
  Writeln(F, '	font-size: 16px;');
  Writeln(F, '	line-height: 22px;');
  Writeln(F, '      	margin:0px;');
  Writeln(F, 'padding:0px;');
  Writeln(F, '	background-color: #ff0000;');
  Writeln(F, '}               ');

  Writeln(F, '}               ');
  Writeln(F, '-->          ');
  Writeln(F, '</style>  ');
  Writeln(F, '</head>');
  Writeln(F, '<body class="main">  ');
  //==
  if fWholeTmRec.isimportant then
    Writeln(F, '<span class="p2">【重点】 </span>');
  Writeln(F, tmtype_chinese);
  Writeln(F, FWholeTmRec.TITLE);

  Writeln(F, '</body>');
  Writeln(F, '<head>');

  Closefile(F); {关闭文件 F}
  WEB.Navigate(extractfilepath(application.exename) + 'tmp.htm');

end;

function OpenOneTM.TMTYPE: INTEGER;
begin
  //
  RESULT := 4;
  if Pos(trim(fWholeTmRec.SHORTANSWER), '×√×') > 0 then
    RESULT := TMTYPE_judgment
  else if length(trim(fWholeTmRec.SHORTANSWER)) = 1 then
    RESULT := TMTYPE_ONESELECT
  else if length(trim(fWholeTmRec.SHORTANSWER)) > 1 then
    RESULT := TMTYPE_MULTISELECT
  else
    RESULT := TMTYPE_OTHER;
end;

procedure OpenOneTM.ANStoWEB(WEB: TWEBBROWSER);
var
  f: Textfile;
begin
  if fileExists(extractfilepath(application.exename) + 'tmpb.htm') then
    DeleteFile(extractfilepath(application.exename) + 'tmpB.htm');
  {看文件是否存在,在就刪除}
  AssignFile(F, extractfilepath(application.exename) + 'tmpB.htm');
  {将文件名与变量 F 关联}
  ReWrite(F); {创建一个新的文件并命名为 ek.txt}

  Writeln(F, '<html>');
  Writeln(F, '    <style type="text/css">');
  Writeln(F, '<!--');
  Writeln(F, '.main {');
  Writeln(F, '	font-family: "宋体";'); //         楷体_GB2312
  Writeln(F, '	font-size: 16px;');
  Writeln(F, '	line-height: 25px;');
  Writeln(F, '      	margin:0px;');
  Writeln(F, 'padding:6px;');
  Writeln(F, '	background-color: #ffffff;');
  Writeln(F, '	text-align: left; ');
  Writeln(F, '	color: #000000;');
  Writeln(F, '}               ');
  Writeln(F, '.main p{');
  Writeln(F, '	font-family: "宋体";');
  Writeln(F, '	font-size: 16px;');
  Writeln(F, '	line-height: 22px;');
  Writeln(F, '      	margin:0px;');
  Writeln(F, 'padding:0px;');
  Writeln(F, '	background-color: #ffffff;');
  Writeln(F, '}               ');

  Writeln(F, '-->          ');
  Writeln(F, '</style>  ');
  Writeln(F, '</head>');
  Writeln(F, '<body class="main">  ');

  Writeln(F, tmtype_chinese);

  Writeln(F, FWholeTmRec.answer);
  Writeln(F, '</body>');
  Writeln(F, '<head>');

  Closefile(F);
  WEB.Navigate(extractfilepath(application.exename) + 'tmpB.htm');
end;

procedure OpenOneTM.Update_Isimportant;
begin
  //
  qrytmp.close;
  qrytmp.sql.Clear;
  qrytmp.SQL.Add('update tm set istb=:istb where id=:id');
  qrytmp.Parameters.ParamByName('id').Value := aWholeTmRec.id;
  qrytmp.Parameters.ParamByName('istb').Value := aWholeTmRec.isimportant;
  qrytmp.ExecSQL;
end;

procedure OpenOneTM.Update_MyShortAnswer;
begin
  qrytmp.close;
  qrytmp.sql.Clear;
  qrytmp.SQL.Add('update tm set xmyans=:xmyans,iserr=:iserr where id=:id');
  qrytmp.Parameters.ParamByName('id').Value := aWholeTmRec.id;
  qrytmp.Parameters.ParamByName('iserr').Value := aWholeTmRec.ISerr;
  qrytmp.Parameters.ParamByName('xmyans').Value := aWholeTmRec.myshortanswer;
  qrytmp.ExecSQL;
end;

procedure OpenOneTM.Update_Mylonganswer;
begin
  qrytmp.close;
  qrytmp.sql.Clear;
  qrytmp.SQL.Add('update tm set myans=:myans where id=:id');
  qrytmp.Parameters.ParamByName('id').Value := aWholeTmRec.id;
  qrytmp.Parameters.ParamByName('myans').Value := aWholeTmRec.myanswer;
  qrytmp.ExecSQL;
end;

procedure OpenOneTM.setWholeTmRec(const Value: WholeTmRec);
begin
  fWholeTmRec := Value;
end;

function OpenOneTM.tmtype_chinese: string;
begin
  //
  if FWholeTmRec.TMTYPE = TMTYPE_judgment then
    result := '判断题'
  else if FWholeTmRec.TMTYPE = TMTYPE_ONESELECT then
    result := '单选题'
  else if FWholeTmRec.TMTYPE = TMTYPE_MULTISELECT then
    result := '多选题'
  else
    result := '主观题';

end;

procedure OpenOneTM.LongAnsToRichedit(edt: Trichedit);
begin
  //
  edt.Clear;
  edt.Lines.Add(fWholeTmRec.myanswer);
end;

end.

