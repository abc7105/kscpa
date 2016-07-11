unit UTMLIST;

interface
uses utm, SysUtils, Classes, forms, DB, ADODB, mshtml, SHDocVw, StdCtrls,
  ComCtrls, StrUtils,
  Dialogs;

type
  RECshorttm = record
    id: longint;
    xans: string;
    xmyans: string;
    iserror: Boolean;
    istb: Boolean; //重点;
  end;

type
  TMLIST = class
  private
    ATM: OpenOneTM;
    FCXNAME: string;
    CurrentTMREC: WholeTmRec;
    id: integer;
    orderID: LongInt;
    QRYLIST: TADOQUERY;
    QRYTMP: TADOQUERY;
    QuestionWeb: TWebBrowser;
    answerWEB: TWEBBROWSER;
    shortanswerEdit: tedit;
    rowcount: LongInt;
    LongAnswerRichEdit: trichedit;
    SHORTTM: array of RECshorttm;
    flbltmcount: TLabel;
    flbltmname: TLabel;
    procedure setAnsWeb(const Value: TWEBBROWSER);
    procedure SETQuestionWeb(VALUE: TWebBrowser);
    procedure setAnsEdit(const Value: tedit);
    procedure SETMyLongAns(const Value: string);
    procedure SETMyshortans(const Value: string);
    procedure SETisimportant(const Value: boolean);
    procedure setLONGAnsRichEdit(const Value: tRICHedit);
    procedure setlbltmcount(const Value: TLabel);
    procedure setlbltmname(const Value: TLabel);
    procedure GETCXNAME();
  public
    procedure NEXT();
    procedure PRIOR();
    procedure FIRST;
    procedure LAST();
    procedure CURRENT();
    constructor CREATE(CON: TADOCONNECTION);
    procedure GETLISTfrom_zj(kmid, zjid: string);
    procedure GetShorttm();

  published
    property current_myshortans: string write SETMyshortans;
    property current_mylongans: string write SETMyLongAns;
    property current_isimportant: boolean write SETisimportant;
    property tCurrentTMREC: WholeTmRec read CurrentTMREC;

    property TQuestionWeb: TWebBrowser write SETQuestionWeb;
    property tanswerWEB: TWEBBROWSER write setAnsWeb;
    property tshortanswerEdit: tedit write setAnsEdit;
    property tLongAnswerRichEdit: tRICHedit write setLONGAnsRichEdit;
    property lbltmname: TLabel write setlbltmname;
    property lbltmcount: TLabel write setlbltmcount;
  end;

implementation

{ TMLIST }

constructor TMLIST.CREATE(CON: TADOCONNECTION);
begin
  //
  QRYLIST := TADOQUERY.CREATE(nil);
  QRYLIST.Connection := CON;

  QRYTMP := TADOQUERY.CREATE(nil);
  QRYTMP.Connection := CON;

  atm := OpenOneTM.create(qrytmp);
  rowcount := 0;

  if qrylist.Active then
    if qrylist.RecordCount > 0 then
    begin
      id := QRYLIST.fieldbyname('id').AsInteger;
      GETCXNAME;
      CURRENT;
    end;

end;

procedure TMLIST.CURRENT;
begin
  if QRYLIST.RecordCount < 1 then
    exit;

  ATM.ID := QRYLIST.FIELDBYNAME('ID').AsInteger;
  //  id := atm.id;

  CurrentTMREC := ATM.aWholeTmRec;
  ATM.titletoWEB(QuestionWeb);
  ATM.ANStoWEB(answerWEB);
  ATM.ShortAnswerToedit(shortanswerEdit);
  ATM.LongAnsToRichedit(LongAnswerRichEdit);
  Flbltmcount.caption := ' 第 ' + trim(IntToStr(QRYLIST.RecNo)) + '题 /  总' +
    trim(IntToStr(QRYLIST.RecordCount)) + ' 题';
  flbltmname.caption := fcxname;

end;

procedure TMLIST.GETLISTfrom_zj(kmid, zjid: string);
begin

  qrylist.close;
  qrylist.sql.clear;
  qrylist.sql.add(' select * from tm where  tmts in (select ts as tmts from tmts where km=:kmid  and zjid=:zjid) order by sxh');
  qrylist.Parameters.ParamByName('kmid').Value := rightstr('00' + kmid, 2);
  qrylist.Parameters.ParamByName('zjid').Value := rightstr('000' + zjid, 3);
  QRYLIST.Open;
  rowcount := QRYLIST.RecordCount;

  //  章节号得知章节名
  QRYTMP.Close;
  QRYTMP.SQL.Clear;
  QRYTMP.SQL.Add('SELECT zj.name as zjname,km.name  as kmname from km,zj where zj.km=km.id and zj.km=:kmid and zj.id=:zjid ');
  QRYTMP.Parameters.ParamByName('zjid').Value := rightstr('000' + zjid, 3);
  QRYTMP.Parameters.ParamByName('kmid').Value := rightstr('00' + kmid, 2);
  QRYTMP.Open;

  if QRYTMP.RecordCount < 1 then
    exit;

  FCXNAME := Trim(QRYTMP.fieldbyname('kmname').asstring) + '>>' +
    Trim(QRYTMP.fieldbyname('zjname').asstring)

end;

procedure TMLIST.GetShorttm;
var
  i: integer;
begin
  //
  SetLength(SHORTTM, rowcount);
  for i := 1 to rowcount do
  begin
    SHORTTM[i - 1].id := QRYLIST.fieldbyname('id').AsInteger;
    SHORTTM[i - 1].xans := QRYLIST.fieldbyname('xans').asstring;
    SHORTTM[i - 1].xmyans := QRYLIST.fieldbyname('xmyans').asstring;
    SHORTTM[i - 1].iserror := QRYLIST.fieldbyname('iserror').AsBoolean;
    SHORTTM[i - 1].istb := QRYLIST.fieldbyname('istb').AsBoolean;
  end;
end;

procedure TMLIST.FIRST;
begin
  if QRYLIST.RecordCount < 1 then
    exit;

  QRYLIST.First;
  CURRENT;

end;

procedure TMLIST.LAST;
begin
  if QRYLIST.RecordCount < 1 then
    exit;
  QRYLIST.LAST;
  CURRENT;

end;

procedure TMLIST.NEXT;
begin
  if QRYLIST.RecordCount < 1 then
    exit;

  if not QRYLIST.Eof then
  begin
    QRYLIST.NEXT;
    CURRENT;
  end;

end;

procedure TMLIST.PRIOR;
begin
  if QRYLIST.RecordCount < 1 then
    exit;

  if not QRYLIST.BOF then
  begin
    QRYLIST.Prior;
    CURRENT;
  end;
end;

procedure TMLIST.setAnsWeb(const Value: TWEBBROWSER);
begin
  answerWEB := VALUE;
end;

procedure TMLIST.setAnsEdit(const Value: tedit);
begin
  shortanswerEdit := Value;
end;

procedure TMLIST.SETisimportant(const Value: boolean);
begin
  CurrentTMREC.isimportant := Value;
  ATM.aWholeTmRec := CurrentTMREC;
  ATM.Update_Isimportant;
  ATM.titletoWEB(QuestionWeb);
end;

procedure TMLIST.SETMyLongAns(const Value: string);
begin
  CurrentTMREC.myanswer := Value;
  ATM.aWholeTmRec := CurrentTMREC;
  ATM.Update_Mylonganswer;
end;

procedure TMLIST.SETMyshortans(const Value: string);
begin
  CurrentTMREC.myshortanswer := Value;
  ATM.aWholeTmRec := CurrentTMREC;
  ATM.Update_MyShortAnswer;
end;

procedure TMLIST.SETQuestionWeb(VALUE: TWebBrowser);
begin
  //
  QuestionWeb := VALUE;

end;

procedure TMLIST.setLONGAnsRichEdit(const Value: tRICHedit);
begin
  LongAnswerRichEdit := Value;

end;

procedure TMLIST.setlbltmcount(const Value: TLabel);
begin
  flbltmcount := value;
end;

procedure TMLIST.setlbltmname(const Value: TLabel);
begin
  flbltmname := value;
end;

procedure TMLIST.GETCXNAME;
var
  str_zj, str_km: string;
begin
  QRYTMP.SQL.Clear;
  QRYTMP.SQL.Add('SELECT tmts.km as kmid ,tmts.zjid  as zjid from tmts,tm where tmts.ts=tm.tmts  and tm.id=:id ');
  QRYTMP.Parameters.ParamByName('id').Value := id;
  QRYTMP.Open;

  if QRYTMP.RecordCount < 1 then
    exit;

  str_zj := QRYTMP.fieldbyname('zjid').AsString;
  str_km := QRYTMP.fieldbyname('kmid').AsString;

  QRYTMP.Close;
  QRYTMP.SQL.Clear;
  QRYTMP.SQL.Add('SELECT zj.name as zjname,km.name  as kmname from km,zj where zj.km=km.id and zj.km=:kmid and zj.id=:zjid ');
  QRYTMP.Parameters.ParamByName('zjid').Value := rightstr('000' + str_zj, 3);
  QRYTMP.Parameters.ParamByName('kmid').Value := rightstr('00' + str_km, 2);
  QRYTMP.Open;

  if QRYTMP.RecordCount < 1 then
    exit;

  FCXNAME := Trim(QRYTMP.fieldbyname('kmname').asstring) + '>>' +
    Trim(QRYTMP.fieldbyname('zjname').asstring)

end;

end.

