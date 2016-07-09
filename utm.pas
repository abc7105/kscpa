unit utm;

interface

uses SysUtils, Classes, forms, DB, ADODB, mshtml, SHDocVw, StdCtrls, ComCtrls;

type
  tmrec = record
    id: integer;
    title: string;
    answer: string;
    shortanswer: string;
    myanswer: string;
    ISerr: Boolean;
    isimportant: Boolean;
  end;

  tm = class
  private
    ftmrec: tmrec;
    fID: Integer;
    qrytmp: TADOQuery;
    fdispanswer: Boolean;
    function GETtmrec: tmrec;
    function GETID: INTEGER;
    procedure queryid(id: Integer);
    procedure SETID(const Value: INTEGER);
  published
    property atmrec: tmrec read GETtmrec;
    property ID: INTEGER read GETID write SETID;
    property dispanswer: Boolean read fdispanswer write fdispanswer;
    procedure CLEAR;

  public
    constructor create(qrycx: tadoquery);
    procedure titletoWEB(WEB: TWEBBROWSER);
    procedure ANStoWEB(WEB: TWEBBROWSER);
    //     procedure ANSWERtoWEB(WEB: TWEBBROWSER);
    procedure ShortAnswerToLABEL(LBL: TLABEL);
    function TMTYPE(): string;

  end;

implementation

uses
  ucommunit;

{ tm }

procedure tm.CLEAR;
begin
  //
  ftmrec.id := 0;
  ftmrec.title := '';
  ftmrec.answer := '';
  ftmrec.shortanswer := '';
  ftmrec.myanswer := '';
  ftmrec.ISerr := FALSE;
  ftmrec.isimportant := False;
end;

constructor tm.create(qrycx: tadoquery);
begin
  //
  qrytmp := qrycx;
  fdispanswer := True;

end;

function tm.GETID: INTEGER;
begin
  //
  result := FID;
end;

procedure tm.queryid(id: Integer);
begin
  //
  qrytmp.close;
  qrytmp.sql.Clear;
  qrytmp.SQL.Add('select * from tm where id=:id');
  qrytmp.Parameters.ParamByName('id').Value := id;
  qrytmp.Open;

  if qrytmp.RecordCount > 0 then
  begin

    ftmrec.title := qrytmp.fieldbyname('title').asstring;
    ftmrec.answer := qrytmp.fieldbyname('ans').asstring;
    ftmrec.shortanswer := qrytmp.fieldbyname('xans').asstring;
  end
  else
  begin
    CLEAR;

  end;

end;

function tm.GETtmrec: tmrec;
begin
  //
  result := ftmrec;
end;

procedure tm.SETID(const Value: INTEGER);
begin
  //
  fid := Value;
  queryid(fID);
end;

procedure tm.ShortAnswerToLABEL(LBL: TLABEL);
begin
  LBL.Caption := ftmrec.shortanswer;
end;

procedure tm.titletoWEB(WEB: TWEBBROWSER);
var
  f: Textfile;
begin
  if fileExists(extractfilepath(application.exename) + 'tmp.htm') then
    DeleteFile(extractfilepath(application.exename) + 'tmp.htm');
  {���ļ��Ƿ����,�ھ̈́h��}
  AssignFile(F, extractfilepath(application.exename) + 'tmp.htm');
  {���ļ�������� F ����}
  ReWrite(F); {����һ���µ��ļ�������Ϊ ek.txt}

  Writeln(F, '<html>');
  Writeln(F, '    <style type="text/css">');
  Writeln(F, '<!--');
  Writeln(F, '.main {');
  Writeln(F, '	font-family: "����";'); //         ����_GB2312
  Writeln(F, '	font-size: 20px;');
  Writeln(F, '	line-height: 25px;');
  Writeln(F, '      	margin:0px;');
  Writeln(F, 'padding:0px;');
  Writeln(F, '	background-color: #ffffff;');
  Writeln(F, '	text-align: left; ');
  Writeln(F, '	color: #000000;');
  Writeln(F, '}               ');
  Writeln(F, '.main p{');
  Writeln(F, '	font-family: "����";');
  Writeln(F, '	font-size: 20px;');
  Writeln(F, '	line-height: 22px;');
  Writeln(F, '      	margin:0px;');
  Writeln(F, 'padding:0px;');
  Writeln(F, '	background-color: #ffffff;');
  Writeln(F, '}               ');
  Writeln(F, '-->          ');
  Writeln(F, '</style>  ');
  Writeln(F, '</head>');
  Writeln(F, '<body class="main">  ');
  //==
  Writeln(F, TMTYPE);
  Writeln(F, FTMREC.TITLE);
  //  if fdispanswer then
  //  begin
  //    Writeln(F, '=======================��=======================');
  //    Writeln(F, '</br>');
  //    Writeln(F, FTMREC.answer);
  //  end;
    //===

  Writeln(F, '</body>');
  Writeln(F, '<head>');

  Closefile(F); {�ر��ļ� F}
  WEB.Navigate(extractfilepath(application.exename) + 'tmp.htm');
end;

function tm.TMTYPE: string;
begin
  //
  RESULT := '';
  if length(trim(ftmrec.SHORTANSWER)) < 1 then
    RESULT := ''
  else if (trim(ftmrec.SHORTANSWER) = '��') or
    (trim(ftmrec.SHORTANSWER) = '��') then
    RESULT := '�ж���'
  else if length(trim(ftmrec.SHORTANSWER)) = 1 then
    RESULT := '��ѡ��'
  else if length(trim(ftmrec.SHORTANSWER)) > 1 then
    RESULT := '��ѡ��'
  else if length(trim(ftmrec.SHORTANSWER)) < 1 then
    RESULT := '�����ۺ���';
end;

procedure tm.ANStoWEB(WEB: TWEBBROWSER);
var
  f: Textfile;
begin
  if fileExists(extractfilepath(application.exename) + 'tmpb.htm') then
    DeleteFile(extractfilepath(application.exename) + 'tmpB.htm');
  {���ļ��Ƿ����,�ھ̈́h��}
  AssignFile(F, extractfilepath(application.exename) + 'tmpB.htm');
  {���ļ�������� F ����}
  ReWrite(F); {����һ���µ��ļ�������Ϊ ek.txt}

  Writeln(F, '<html>');
  Writeln(F, '    <style type="text/css">');
  Writeln(F, '<!--');
  Writeln(F, '.main {');
  Writeln(F, '	font-family: "����";'); //         ����_GB2312
  Writeln(F, '	font-size: 20px;');
  Writeln(F, '	line-height: 25px;');
  Writeln(F, '      	margin:0px;');
  Writeln(F, 'padding:0px;');
  Writeln(F, '	background-color: #ffffff;');
  Writeln(F, '	text-align: left; ');
  Writeln(F, '	color: #000000;');
  Writeln(F, '}               ');
  Writeln(F, '.main p{');
  Writeln(F, '	font-family: "����";');
  Writeln(F, '	font-size: 20px;');
  Writeln(F, '	line-height: 22px;');
  Writeln(F, '      	margin:0px;');
  Writeln(F, 'padding:0px;');
  Writeln(F, '	background-color: #ffffff;');
  Writeln(F, '}               ');
  Writeln(F, '-->          ');
  Writeln(F, '</style>  ');
  Writeln(F, '</head>');
  Writeln(F, '<body class="main">  ');
  //==
  Writeln(F, TMTYPE);
   Writeln(F, FTMREC.answer);
  Writeln(F, '</body>');
  Writeln(F, '<head>');

  Closefile(F);
  WEB.Navigate(extractfilepath(application.exename) + 'tmpB.htm');
end;

end.

