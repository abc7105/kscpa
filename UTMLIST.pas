unit UTMLIST;

interface
uses utm, SysUtils, Classes, forms, DB, ADODB, mshtml, SHDocVw, StdCtrls,
  ComCtrls,
  Dialogs;

type
  RECshorttm = record
    id: longint;
    xans: string;
    xmyans: string;
    iserror: Boolean;
    istb: Boolean; //ÖØµã;
  end;

type
  TMLIST = class
  private
    ATM: tm;
    id: integer;
    orderID: LongInt;
    QRYLIST: TADOQUERY;
    QRYTMP: TADOQUERY;
    QuestionWeb: TWebBrowser;
    answerWEB: TWEBBROWSER;
    answerlbl: TLabel;
    rowcount: LongInt;
    SHORTTM: array of RECshorttm;
    procedure SETansEdit(const Value: TWEBBROWSER);
    procedure SETQuestionWeb(VALUE: TWebBrowser);
    procedure SETanslabel(const Value: TLabel);
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
    property TQuestionWeb: TWebBrowser write SETQuestionWeb;
    property tanswerWEB: TWEBBROWSER write SETansEdit;
    property tanswerlbl: TLabel write SETanslabel;
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

  atm := tm.create(qrytmp);

  if qrylist.Active then
    if qrylist.RecordCount > 0 then
    begin
      id := QRYLIST.fieldbyname('id').AsInteger;
      atm.ID := id;
      ORDERID := 1;
    end;

end;

procedure TMLIST.CURRENT;
begin
  if QRYLIST.RecordCount < 1 then
    exit;
  ATM.ID := QRYLIST.FIELDBYNAME('ID').AsInteger;

  ATM.titletoWEB(QuestionWeb);
  ATM.ANStoWEB(answerWEB);
  ATM.ShortAnswerToLABEL(answerlbl);
  rowcount := 0;
end;

procedure TMLIST.FIRST;
begin
  if QRYLIST.RecordCount < 1 then
    exit;

  QRYLIST.First;
  ATM.ID := QRYLIST.FIELDBYNAME('ID').AsInteger;
  ATM.titletoWEB(QuestionWeb);
  ATM.ANStoWEB(answerWEB);
  ATM.ShortAnswerToLABEL(answerlbl);

end;

procedure TMLIST.GETLISTfrom_zj(kmid, zjid: string);
begin

  qrylist.close;
  qrylist.sql.clear;
  qrylist.sql.add(' select * from tm where  tmts in (select ts as tmts from tmts where km=:kmid  and zjid=:zjid) order by sxh');
  qrylist.Parameters.ParamByName('kmid').Value := kmid;
  qrylist.Parameters.ParamByName('zjid').Value := zjid;
  QRYLIST.Open;
  rowcount := QRYLIST.RecordCount;

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

procedure TMLIST.LAST;
begin
  if QRYLIST.RecordCount < 1 then
    exit;
  QRYLIST.LAST;
  ATM.ID := QRYLIST.FIELDBYNAME('ID').AsInteger;
  ATM.titletoWEB(QuestionWeb);
  ATM.ANStoWEB(answerWEB);
  ATM.ShortAnswerToLABEL(answerlbl);

end;

procedure TMLIST.NEXT;
begin
  if QRYLIST.RecordCount < 1 then
    exit;

  if not QRYLIST.Eof then
  begin
    QRYLIST.NEXT;
    ATM.ID := QRYLIST.FIELDBYNAME('ID').AsInteger;
    ATM.titletoWEB(QuestionWeb);
    ATM.ANStoWEB(answerWEB);
    ATM.ShortAnswerToLABEL(answerlbl);
  end;

end;

procedure TMLIST.PRIOR;
begin

  if QRYLIST.RecordCount < 1 then
    exit;
  if not QRYLIST.BOF then
  begin
    QRYLIST.Prior;
    ATM.ID := QRYLIST.FIELDBYNAME('ID').AsInteger;
    ATM.titletoWEB(QuestionWeb);
    ATM.ANStoWEB(answerWEB);
    ATM.ShortAnswerToLABEL(answerlbl);
  end;
end;

procedure TMLIST.SETansEdit(const Value: TWEBBROWSER);
begin
  answerWEB := VALUE;
end;

procedure TMLIST.SETanslabel(const Value: TLabel);
begin
  answerlbl := Value;
end;

procedure TMLIST.SETQuestionWeb(VALUE: TWebBrowser);
begin
  //
  QuestionWeb := VALUE;
end;

end.

