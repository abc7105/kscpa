unit UTMLIST;

interface
uses utm, SysUtils, Classes, forms, DB, ADODB, mshtml, SHDocVw, StdCtrls,
  ComCtrls,
  Dialogs;

type
  TMLIST = class
  private
    ATM: tm;
    id: integer;
    orderID: LongInt;
    QRYLIST: TADOQUERY;

    QRYTMP: TADOQUERY;
    WEBMEMO: TWebBrowser;
    answerWEB: TWEBBROWSER;
    answerlbl: TLabel;
    procedure SETansEdit(const Value: TWEBBROWSER);
    procedure SETWEBMEMO(VALUE: TWebBrowser);
    procedure SETanslabel(const Value: TLabel);
  public
    procedure NEXT();
    procedure PRIOR();
    procedure FIRST;
    procedure LAST();
    procedure CURRENT();
    constructor CREATE(CON: TADOCONNECTION);
    procedure GETLISTfrom_zj(kmid, zjid: string);


  published
    property TWEBMEMO: TWebBrowser write SETWEBMEMO;
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

  // QRY_ZJ


  //  GETLIST;
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
  ATM.titletoWEB(WEBMEMO);
end;

procedure TMLIST.FIRST;
begin
  if QRYLIST.RecordCount < 1 then
    exit;

  QRYLIST.First;
  ATM.ID := QRYLIST.FIELDBYNAME('ID').AsInteger;
  ATM.titletoWEB(WEBMEMO);
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
  //showmessage(inttostr(qrylist.recordcount))

end;



procedure TMLIST.LAST;
begin
  if QRYLIST.RecordCount < 1 then
    exit;
  QRYLIST.LAST;
  ATM.ID := QRYLIST.FIELDBYNAME('ID').AsInteger;
  ATM.titletoWEB(WEBMEMO);
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
    ATM.titletoWEB(WEBMEMO);
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
    ATM.titletoWEB(WEBMEMO);
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

procedure TMLIST.SETWEBMEMO(VALUE: TWebBrowser);
begin
  //
  WEBMEMO := VALUE;
end;

end.

