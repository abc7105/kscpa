unit KS16;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  registry, TlHelp32, lxyjm,
  Dialogs, StdCtrls, Buttons, Menus, ComCtrls, ExtCtrls,
  shareunit,
  StrUtils, ComObj, ActiveX, mshtml, DateUtils, math, perlregex, urlmon,
  DB, ADODB, OleCtrls, SHDocVw, ShellApi, ImgList, AppEvnts, utmlist,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  ucommunit, bsSkinCtrls, ToolWin;
const
  NOSIZETAG = -10000;

type
  Tfmks16 = class(TForm)
    menu1: TMainMenu;
    N1: TMenuItem;
    Splitter1: TSplitter;
    pnlAnswer: TPanel;
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N7: TMenuItem;
    TB3: TADOTable;
    pnlmain: TPanel;
    RichEdit1: TRichEdit;
    WebBrowser1: TWebBrowser;
    ImageList1: TImageList;
    Button3: TButton;
    Timer1: TTimer;
    pnl_nagi: TPanel;
    ApplicationEvents1: TApplicationEvents;
    op1: TOpenDialog;
    tb1: TADOTable;
    Memo1: TMemo;
    Panel6: TPanel;
    WebBrowser4: TWebBrowser;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    BitBtn6: TBitBtn;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    IdHTTP1: TIdHTTP;
    pnl1: TPanel;
    Button12: TButton;
    pnl_myans: TPanel;
    RichEditANS: TRichEdit;
    pnl_myObjective_questions: TPanel;
    Label1: TLabel;
    wbANSWER: TWebBrowser;
    tlb1: TToolBar;
    btn4: TToolButton;
    btn5: TToolButton;
    btn6: TToolButton;
    btn8: TToolButton;
    btn9: TToolButton;
    btn10: TToolButton;
    btn11: TToolButton;
    btn1: TToolButton;
    btn2: TToolButton;
    btn13: TToolButton;
    btn14: TToolButton;
    edtAnswer: TEdit;
    btn7: TBitBtn;
    btn12: TBitBtn;
    btn15: TBitBtn;
    btn16: TBitBtn;
    btn17: TBitBtn;
    btn18: TBitBtn;
    btn19: TBitBtn;
    btn20: TBitBtn;
    pnl3: TPanel;
    lblTmCount: TLabel;
    pnl4: TPanel;
    pnl2: TPanel;
    lblTmName: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure opendb;
    procedure zeroform;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure jumppage;
    procedure N4Click(Sender: TObject);
    function isreg: boolean;
    procedure N7Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn6Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure WMSize(var message: TWMSize); message WM_SIZE;
    procedure FormDestroy(Sender: TObject);
    procedure hotykey(var msg: TMessage); message WM_HOTKEY;
    function getbj(): integer;
    function gethtml(): string;
    function sortans(ABCD: string; ans: string): string;
    procedure Button12Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

    function getpa(str: string): double;
    function getps(str: string): double;
    function geti(str: string): double;
    function getyy(str: string): double;
    function getpstr(str: string): string;
    procedure FormDeactivate(Sender: TObject);
    procedure RichEdit3KeyPress(Sender: TObject; var Key: Char);
    function GetCaretPosEx: TPoint;
    function calctext(str: string): string;
    procedure ApplicationEvents1Deactivate(Sender: TObject);
    procedure ApplicationEvents1Activate(Sender: TObject);
    function getkf(str: string): double;
    function LastPos(SearchStr, Str: string): Integer;
    procedure getarecord(str: string; TMTSid: integer);
    function DownloadFile(Source, Dest: string): Boolean;
    procedure WebBrowser4DocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure CheckParentProc;
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure writeHTML(WebInfo: TWebBrowser; text: string);
    procedure getver();
    procedure N14Click(Sender: TObject);
    procedure btn10Click(Sender: TObject);
    procedure btn11Click(Sender: TObject);
    procedure btn9Click(Sender: TObject);
    procedure btn8Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn14Click(Sender: TObject);
    procedure btn13Click(Sender: TObject);
    procedure Ansdwerclick(Sender: TObject);
    procedure donothing;
    procedure edtAnswerChange(Sender: TObject);
    procedure RichEditANSExit(Sender: TObject);
    procedure recordchange();
    //    procedure processdb;
    //    function ProcessCmdKey(var msg: Message; keyData: Keys): boolean; override;
  private
    procedure subMenuClick(sender: Tobject);
    procedure IEMessageHandler(var Msg: TMsg; var Handled: Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmks16: Tfmks16;
  dybz: boolean;
  sqlstring: string;
  HotKeyId: array[0..20] of Integer;
  pubkm, pubzj: string;
  oldsql: string;
  sj: tdatetime;
  id, id2: Integer;
  beginbz: boolean;
  richstr: string;
  myjm: tlxyjm;

  atmlist: TMLIST;

implementation

uses DAT, SmpExprCalc, UnitHardInfo, Crc32, md5, fmdy,
  fmbjb, selectRND, regnew, ImportTM, utm;

{$R *.dfm}

procedure Tfmks16.FormCreate(Sender: TObject);
var
  i: Integer;
  // aform: tfmreg;
  x1, x2, x3, x4: string;

begin

  lblTmCount.Caption := '';
  lblTmName.Caption := '';
  mainpath := ExtractFilePath(Application.ExeName);
  pnlmain.width := (Screen.width div 2 + 100);
  mydb.CON1.Connected := True;
  atmlist := TMLIST.CREATE(mydb.con1);

  mydb.qrytmp.Connection := mydb.CON1;
  mydb.qrytmp.Close;
  mydb.qrytmp.SQL.Add('select top  1 * from mysysinfo  ');
  mydb.qrytmp.Open;
  if mydb.qrytmp.RecordCount < 1 then
  begin
    showmessage('安装不正确，请与开发人员联系！');
    exit;
  end;

  mydb.qrytmp.First;
  LoadParamFromFile(StringReplace(Application.EXEName, '.EXE', '.ini',
    [rfReplaceAll, rfIgnoreCase]));
  pubzj := mysys.zj;
  pubkm := mysys.km;

  regkey := mydb.qrytmp.fieldbyname('regkey').AsString;
  outfile := mysys.pwd;
  strver := mydb.qrytmp.fieldbyname('strver').AsString;
  webpage := mydb.qrytmp.fieldbyname('webpage').AsString;

  x1 := 'abc' + trim(mysys.pwd) + 'ks2011';
  x2 := 'lxy' + trim(mysys.pwd) + 'ks2011';
  x3 := 'lhh' + trim(mysys.pwd) + 'ks2022';
  x4 := 'zl+' + trim(mysys.pwd) + 'ks2031';

  myjm := tlxyjm.create(x1, x2, x3, x4);

  CheckParentProc;
  panel6.Left := -1000;

  memo1.Visible := false;

  beginbz := true;
  opendb;
  zeroform;
  //注册
//  label6.Caption := '';
//  edit3.Clear;
  for i := Low(HotKeyId) to High(HotKeyId) do
    HotKeyId[i] := GlobalAddAtom(PChar(IntToStr(i))); //热键命名可随意
  RegisterHotKey(Handle, HotKeyId[11], MOD_ALT, 65); //PageUp
  RegisterHotKey(Handle, HotKeyId[12], MOD_ALT, 66); //PageUp
  RegisterHotKey(Handle, HotKeyId[13], MOD_ALT, 67); //PageUp
  RegisterHotKey(Handle, HotKeyId[14], MOD_ALT, 68); //PageUp
  RegisterHotKey(Handle, HotKeyId[15], MOD_ALT, 69); //PageUp
  RegisterHotKey(Handle, HotKeyId[16], MOD_ALT, 49); //PageUp
  RegisterHotKey(Handle, HotKeyId[17], MOD_ALT, 50); //PageUp
  RegisterHotKey(Handle, HotKeyId[18], MOD_ALT, 88); //PageUp         X
  RegisterHotKey(Handle, HotKeyId[19], MOD_ALT, 86); //PageUp
  RegisterHotKey(Handle, HotKeyId[5], 0, VK_PRIOR); //PageUp
  RegisterHotKey(Handle, HotKeyId[6], 0, VK_NEXT);
  RegisterHotKey(Handle, HotKeyId[7], 0, VK_escape); //PageDown
  RegisterHotKey(Handle, HotKeyId[2], MOD_CONTROL, VK_RETURN); //Ctrl+Enter
  RegisterHotKey(Handle, HotKeyId[3], MOD_CONTROL, VK_back);
  //  临时

  if upperCASE(copy(trim(mysys.tmid), 1, 6)) = 'SELECT' then
  begin
    mydb.qrytm.Close;
    mydb.qrytm.SQL.Clear;
    mydb.qrytm.SQL.add(mysys.tmid);
    sqlstring := mydb.qrytm.SQL.Text;
    mydb.qrytm.Open;
    mydb.qrytm.first;

    //    disptm();
  end;

  n10.Checked := mysys.isafterpage;
  n12.Checked := mysys.ispoint;
  n13.Checked := mysys.isautoans;
  n9.Checked := mysys.isautodisp;

  statusbar1.panels[1].Text := formatdatetime('yyyy-mm-dd hh:mm', now);
  // getver;
  Application.OnMessage := IEMessageHandler;
  beginbz := false;
  // webbrowser1.Navigate('http://lxy7105.web004.host888.net/');
  atmlist.GETLISTfrom_zj((pubkm), (pubzj));
  atmlist.TQuestionWeb := WebBrowser1;
  atmlist.TanswerWEB := WBANSWER;
  atmlist.tshortanswerEdit := EdtAnswer;
  atmlist.tLongAnswerRichEdit := Richeditans;
  atmlist.lbltmcount := lblTmCount;
  atmlist.lbltmname := lblTmName;
  atmlist.CURRENT;

end;

procedure Tfmks16.opendb;
var
  submenu: TmenuItem;
  asubmenu: TmenuItem;
  bsubmenu: tmenuitem;

  i, j, k, m: integer;
  kmdm: integer;
  sqlstr: string;
  dm: string;
  regbz: boolean;
  subkm: integer;
begin
  if myjm.check1 then
    regbz := true
  else
    regbz := false;

  mydb.qrykm.close;
  mydb.qrykm.sql.clear;
  mydb.qrykm.sql.add('select * from km');
  mydb.qrykm.open;
  mydb.qrykm.first;

  i := 1;
  //  Tmainmenu(menu1).Items.Clear;
  mydb.qrykm.first;

  while not mydb.qrykm.eof do
  begin
    //   k := 0;
    submenu := Tmenuitem.Create(self);
    submenu.Name := 'main_a' + trim(mydb.qrykm.fieldbyname('id').asstring);

    submenu.ImageIndex := -1;
    submenu.RadioItem := true;
    submenu.Caption := ' ' + trim(mydb.qrykm.fieldbyname('name').asstring) +
      '';

    submenu.Tag := 100 + mydb.qrykm.fieldbyname('id').asinteger;
    subkm := mydb.qrykm.fieldbyname('id').asinteger;
    Tmainmenu(menu1).Items.Add(submenu);

    mydb.qryzj.close;
    mydb.qryzj.sql.clear;
    sqlstr := 'select * from zj where km=''' +
      trim(mydb.qrykm.fieldbyname('id').asstring) + ''' order by id';
    mydb.qryzj.sql.add(sqlstr);
    mydb.qryzj.open;
    m := 0;
    while not mydb.qryzj.eof do
    begin
      m := m + 1;
      bsubmenu := Tmenuitem.Create(self);
      bsubmenu.Name := 'zjmenu_' + trim(inttostr(i)) + 'b' + trim(inttostr(m));
      bsubmenu.ImageIndex := -1;
      bsubmenu.RadioItem := true;
      bsubmenu.Tag := mydb.qryzj.fieldbyname('id').AsInteger;
      bsubmenu.Caption := trim(mydb.qryzj.fieldbyname('name').asstring);
      if mydb.qryzj.fieldbyname('isdo').AsBoolean = true then
        bsubmenu.Checked := true;

      if not ((trim(mydb.qryzj.fieldbyname('name').asstring) = '模拟试题') or
        (trim(mydb.qryzj.fieldbyname('name').asstring) = '历年考题')) then
      begin
        bsubmenu.OnClick := submenuclick; //菜單按鍵事件
      end;

      if not ((trim(mydb.qryzj.fieldbyname('name').asstring) = '模拟试题') or
        (trim(mydb.qryzj.fieldbyname('name').asstring) = '历年考题')) then
      begin

        //==如果是正式版本   含自用或正式
        if regbz then
          bsubmenu.Enabled := true
        else if m < ONLYLIST then
          bsubmenu.ImageIndex := 0
        else if (m > 2) or (subkm > ONLYLIST) then
          bsubmenu.Enabled := false;

        submenu.Add(bsubmenu);
        //以上是增加章节菜单

        if (trim(mydb.qryzj.fieldbyname('name').asstring) = '模拟试题') or
          (trim(mydb.qryzj.fieldbyname('name').asstring) = '历年考题') then
        begin
          mydb.qrytmts.close;
          mydb.qrytmts.sql.clear;
          dm := trim(mydb.qryzj.fieldbyname('id').asstring);

          sqlstr := 'select * from tmts where (km=''' +
            trim(mydb.qrykm.fieldbyname('id').asstring);
          sqlstr := sqlstr + ''') and (zjid=''' + dm + ''') ';
          mydb.QRYTMTS.SQL.Add(sqlstr);
          mydb.qrytmts.open;

          j := 1;
          while not mydb.qrytmts.eof do
          begin
            asubmenu := Tmenuitem.Create(self);
            asubmenu.Name := 'ts_' + trim(inttostr(i)) + trim(inttostr(m)) +
              trim(inttostr(j));
            asubmenu.OnClick := submenuclick; //菜單按鍵事件
            asubmenu.ImageIndex := -1;
            asubmenu.RadioItem := true;
            if (trim(mydb.qryzj.fieldbyname('name').asstring) = '模拟试题') then
            begin
              asubmenu.Caption := '第' + inttostr(j) + '套 ' +
                trim(mydb.qrytmts.fieldbyname('name').asstring);
              if mydb.qrytmts.fieldbyname('isdo').AsBoolean then

                asubmenu.Checked := true;
            end
            else
            begin

              asubmenu.Caption :=
                trim(mydb.qrytmts.fieldbyname('name').asstring);
              if mydb.qrytmts.fieldbyname('isdo').AsBoolean then
                asubmenu.Checked := true;
            end;

            asubmenu.Tag := mydb.qrytmts.fieldbyname('ts').asinteger;

            bsubmenu.Add(asubmenu);
            mydb.qrytmts.next;
            j := j + 1;
          end;
        end;

      end;

      mydb.qryzj.next;
      // k := k + 1;
    end;
    i := i + 1;
    mydb.qrykm.next;
  end;
end;

procedure Tfmks16.subMenuClick(sender: Tobject);
//菜單點擊事件的過程，在創建菜單時把它加進
var
  aa, bb: integer;
  km, zj, strx, stry: string;
begin
  with sender as tmenuitem do
  begin
    bb := tmenuitem(tmenuitem(sender).Parent).tag;
    if (bb > 100) and (bb <= 200) then //如果是章节
    begin
      if tmenuitem(sender).Caption = '全部重点' then
      begin
        aa := tmenuitem(sender).tag;
        mydb.qrytm.Close;
        mydb.qrytm.SQL.Clear;
        strx := inttostr(bb - 100);
        stry := rightstr('000' + trim(inttostr(aa)), 3);

        mydb.qrytm.SQL.add('select * from tm where  (isbz ) and  tmts in (select ts as tmts from tmts where km=''' + strx + ''' and isdo )  order by sxh2 desc');
        mydb.qrytm.Open;
        mydb.qrytm.first;

        //    label1.Caption := tmenuitem(sender).Parent.Caption + ' >>> ' +
    //          tmenuitem(sender).Caption;
        mysys.tmid := mydb.qrytm.SQL.text;

        mysys.km := strx;
        mysys.zj := stry;
        //        mysys.tmtitle := label1.Caption;
        saveParamtoFile(ExtractFilePath(Application.EXEName) + 'kjks.ini');
      end
      else
      begin
        aa := tmenuitem(sender).tag;

        strx := inttostr(bb - 100);
        stry := rightstr('000' + trim(inttostr(aa)), 3);

        atmlist.GETLISTfrom_zj(strx, stry);
        atmlist.CURRENT;

        lblTmName.Caption := tmenuitem(sender).Parent.Caption + ' >>> ' +
          tmenuitem(sender).Caption;
        mysys.tmid := mydb.qrytm.SQL.text;

        mysys.km := strx;
        mysys.zj := stry;
        //        mysys.tmtitle := label1.Caption;
        saveParamtoFile(ExtractFilePath(Application.EXEName) + 'kjks.ini');

      end;

    end
    else
    begin //如果是模拟或考题
      aa := tmenuitem(sender).tag;
      mydb.qrytm.Close;
      mydb.qrytm.SQL.Clear;
      mydb.qrytm.SQL.add('select * from tm where  tmts=' + trim(inttostr(aa)) +
        ' order by sxh');
      mydb.qrytm.Open;
      mydb.qrytm.first;
      mysys.tmid := mydb.qrytm.SQL.text;

      mysys.km := '0';
      mysys.zj := '000';
    end;
  end;

  pubzj := mysys.zj;
  pubkm := mysys.km;

  sqlstring := mydb.qrytm.SQL.Text;


end;

procedure Tfmks16.zeroform;
begin
  panel2.Caption := '';
  if trim(mysys.tmtitle) = '' then
  begin
    richedit1.Clear;
  end;
end;

procedure Tfmks16.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 34) then
  begin
    btn2.Click;
  end;

  if (key = 33) then
  begin
    btn1.Click;
  end;

end;

procedure Tfmks16.jumppage;
begin
  if mydb.qrytm.Active = false then
    exit;

  if mydb.qrytm.Eof then
    exit;

 // saveans;
  mydb.qrytm.Next;
end;

procedure Tfmks16.N4Click(Sender: TObject);
var
  aform: tfmreg;
begin
  aform := tfmreg.create(nil);
  try
    aform.ShowModal;
  except
    aform.close;
    aform.free;
  end;
end;

function Tfmks16.isreg: boolean;
var
  userserial: string;
  reg: TRegistry;
  str1, str2: string;
begin
  result := false;
  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  userserial := '';
  if reg.OpenKey(regkey, True) then
  begin
    str2 := uppercase(reg.ReadString('sn'));
  end;

  reg.closekey;
  reg.free;
  if str2 = '' then
  begin
    result := false;
    exit;
  end;

  str1 := pchar(GetIdeSerialNumber);
  str1 := uppercase(copy(MD5Print(md5.MD5String(trim(str1) + jmstring)), 1,
    10));
  str1 := uppercase(crc32.GetCrc32Str(str1 + jmtmpstr, 8));
  if md5.MD5Match(md5.MD5String(str1), md5.MD5String(str2)) then
  begin
    result := true;
  end
end;

procedure Tfmks16.N7Click(Sender: TObject);
var
  aform: TfmImportTM;
begin
  aform := TfmImportTM.create(nil);
  try
    aform.showmodal;
  finally
    aform.free
  end;
end;

procedure Tfmks16.FormShow(Sender: TObject);
var
  i: Integer;
begin
  Left := 0;
  Width := Screen.Width;
  Top := 0;
  Height := Screen.Height - 20;

  PostMessage(self.Handle, WM_SYSCOMMAND, SC_MAXIMIZE, 0); //最大化
  //

end;

procedure Tfmks16.FormResize(Sender: TObject);
begin
  if windowstate = wsmaximized then
    top := 0;
end;

procedure Tfmks16.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
  //  saveParamtoFile(ExtractFilePath(Application.EXEName) + 'kjks.ini');
end;

procedure Tfmks16.BitBtn6Click(Sender: TObject);
var
  allts, dots, errts, okts: integer;
  per: double;
  bk: tbookmark;
  xtmts: integer;
  azjid: string;
  akmid: string;
begin
  //
  mydb.qrytm.Requery;
  mydb.qrytm.first;

  if mydb.qrytm.RecordCount < 1 then
  begin
    showmessage('没有选择试题，不能评分');
    exit;
  end;

  allts := 0;
  errts := 0;
  bk := mydb.QRYTM.GetBookmark;
  mydb.qrytm.DisableControls;
  mydb.qrytm.First;
  xtmts := mydb.qrytm.FieldByName('tmts').AsInteger;
  dots := 0;
  while not mydb.qrytm.Eof do
  begin
    if mydb.qrytm.FieldByName('xans').AsString <> '' then
    begin
      if mydb.qrytm.FieldByName('xmyans').AsString <> '' then
        dots := dots + 1;
      allts := allts + 1;
      if uppercase(trim(mydb.qrytm.FieldByName('xans').asstring)) <>
        uppercase(trim(mydb.qrytm.FieldByName('xmyans').asstring)) then
      begin
        errts := errts + 1;
        mydb.qrytmp.close;
        MYDB.QRYTMP.SQL.CLEAR;
        mydb.qrytmp.SQL.Add('update tm set isbz=true where id=:id');
        mydb.qrytmp.Parameters.ParamByName('id').Value :=
          mydb.qrytm.FieldByName('id').asstring;
        mydb.qrytmp.ExecSQL;
      end;
    end;
    mydb.qrytm.Next;
  end;
  if dots > 10 then
  begin
    mydb.qrytmp.close;
    MYDB.QRYTMP.SQL.CLEAR;
    mydb.qrytmp.SQL.Add('update tmts set isdo=:isdo where id=:id');
    mydb.qrytmp.Parameters.ParamByName('id').Value := xtmts;
    mydb.qrytmp.Parameters.ParamByName('isdo').Value := true;
    mydb.qrytmp.ExecSQL;

    mydb.qrytmp.close;
    MYDB.QRYTMP.SQL.CLEAR;
    mydb.qrytmp.SQL.Add('select km,zjid from  tmts where id=:id');
    mydb.qrytmp.Parameters.ParamByName('id').Value := xtmts;
    mydb.qrytmp.Open;

    azjid := mydb.qrytmp.fieldbyname('zjid').AsString;
    akmid := mydb.qrytmp.fieldbyname('km').AsString;
    mydb.qrytmp.close;
    MYDB.QRYTMP.SQL.CLEAR;
    mydb.qrytmp.SQL.Add('update zj set isdo=true where id=:id  and km=:km');
    mydb.qrytmp.Parameters.ParamByName('id').Value := azjid;
    mydb.qrytmp.Parameters.ParamByName('km').Value := akmid;
    mydb.qrytmp.ExecSQL;
  end;
  mydb.qrytm.GotoBookmark(bk);
  mydb.qrytm.EnableControls;
  okts := allts - errts;
  per := int(okts / allts * 10000) / 100;
  showmessage(
    '客观题总数：' + inttostr(allts) + '   ' +
    '    错误数：' + inttostr(errts) + chr(13) +
    '    正确数：' + inttostr(okts) + '   ' +
    '    正确率：' + sysutils.FormatFloat('0.00', per) + '％');
end;

procedure Tfmks16.SpeedButton1Click(Sender: TObject);

var
  aform: tformdy;
begin
  if (mydb.qrytm.Active = false) then
  begin
    showmessage('没有选定题目套数，无法打印');
    exit;
  end;
  if mydb.qrytm.RecordCount < 1 then
  begin
    showmessage('没有选定题目套数，无法打印');
    exit;
  end;

  aform := tformdy.create(self);
  try
    aform.ADOQuery1.SQL.Add(mydb.qrytm.SQL.Text);
    aform.getlist;
    aform.showmodal;
  finally
    aform.free;
  end;
end;

procedure Tfmks16.SpeedButton2Click(Sender: TObject);
var
  str1: string;
  str: TStringStream;
begin
  memo1.Clear;
  // richedit3.Clear;

  memo1.Lines.Add('<html>');
  memo1.Lines.Add('<head>');
  memo1.Lines.Add('<body>');
  memo1.Lines.Add('  <style type="text/css">');
  memo1.Lines.Add('<!--');
  memo1.Lines.Add('.xy {  ');
  memo1.Lines.Add('	font-family: "楷体_GB2312";');
  memo1.Lines.Add('	font-size: 14px;');
  memo1.Lines.Add('	font-weight: bold;');
  memo1.Lines.Add('}');
  memo1.Lines.Add('--> ');
  memo1.Lines.Add('</style>');
  memo1.Lines.Add('</head>    ');
  memo1.Lines.Add('<body class="xy">');
  memo1.lines.Add(mysys.tmtitle + '<br />');
  str := TStringStream.Create(mydb.qrytm.fieldbyname('title').AsString);
  richedit1.Lines.LoadFromStream(STR);
  memo1.Lines.Add(richedit1.text);

  richedit1.Lines.Clear;
  str := TStringStream.Create(mydb.qrytm.fieldbyname('ans').AsString);
  richedit1.Lines.LoadFromStream(STR);
  memo1.Lines.Add(richedit1.text);

  memo1.Lines.Add('</body>');
  memo1.Lines.Add('<head>');
  memo1.Lines.SaveToFile(ExtractFilePath(Application.ExeName) + 'dy.htm');

  // webbrowser3.Navigate(extractfilepath(application.exename) + 'dy.htm');
   //  WebBrowser3.Execwb(7, 1);

end;

procedure Tfmks16.N5Click(Sender: TObject);
var
  str: string;
begin
  str := ExtractFilePath(Application.ExeName) + 'help.html';
  ShellExecute(0, 'open', PChar(str), nil, nil, SW_SHOW);
end;

procedure Tfmks16.WMSize(var message: TWMSize);
var
  H: HWND;
begin
  if Tag <> NOSIZETAG then
  begin
    if (message.SizeType = SIZE_MINIMIZED) or (message.SizeType = SIZE_RESTORED)
      then
    begin
      H := SendMessage(self.Handle, WM_MDIGETACTIVE, 0, 0);
      SHOWWINDOW(Handle, SW_MAXIMIZE);
      SendMessage(self.Handle, WM_MDIACTIVATE, Word(H), 0);
    end
    else
      inherited;
  end;
end;

procedure Tfmks16.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  //注销热键
  for i := Low(HotKeyId) to High(HotKeyId) do
  begin
    UnRegisterHotKey(handle, HotKeyId[i]);
    GlobalDeleteAtom(HotKeyId[i]);
  end;
end;

procedure Tfmks16.hotykey(var msg: TMessage);
var
  i: integer;
begin
  if self.active = false then
  begin
    for i := Low(HotKeyId) to High(HotKeyId) do
    begin
      UnRegisterHotKey(handle, HotKeyId[i]);
      GlobalDeleteAtom(HotKeyId[i]);
    end;
    exit;
  end
  else
  begin
    RegisterHotKey(Handle, HotKeyId[11], MOD_ALT, 65); //PageUp
    RegisterHotKey(Handle, HotKeyId[12], MOD_ALT, 66); //PageUp
    RegisterHotKey(Handle, HotKeyId[13], MOD_ALT, 67); //PageUp
    RegisterHotKey(Handle, HotKeyId[14], MOD_ALT, 68); //PageUp
    RegisterHotKey(Handle, HotKeyId[15], MOD_ALT, 69); //PageUp
    RegisterHotKey(Handle, HotKeyId[16], MOD_ALT, 49); //PageUp
    RegisterHotKey(Handle, HotKeyId[17], MOD_ALT, 50); //PageUp

    RegisterHotKey(Handle, HotKeyId[18], MOD_ALT, 88); //PageUp         X
    RegisterHotKey(Handle, HotKeyId[19], MOD_ALT, 86); //PageUp

    RegisterHotKey(Handle, HotKeyId[5], 0, VK_PRIOR); //PageUp
    RegisterHotKey(Handle, HotKeyId[6], 0, VK_NEXT);
    RegisterHotKey(Handle, HotKeyId[7], 0, VK_escape); //PageDown
    RegisterHotKey(Handle, HotKeyId[2], MOD_CONTROL, VK_RETURN); //Ctrl+Enter
    RegisterHotKey(Handle, HotKeyId[3], MOD_CONTROL, VK_back);

  end;

  if (msg.LParamLo = MOD_ALT) and (Msg.LParamHi = 65) then
  begin
    //  BITBTN7.Click;
  end;

  if (msg.LParamLo = MOD_ALT) and (Msg.LParamHi = 66) then
  begin
    //  BITBTN8.Click;
  end;

  if (msg.LParamLo = MOD_ALT) and (Msg.LParamHi = 67) then
  begin
    //   BITBTN9.Click;
  end;
  if (msg.LParamLo = MOD_ALT) and (Msg.LParamHi = 68) then
  begin
    //    BITBTN10.Click;
  end;

  if (msg.LParamLo = MOD_ALT) and (Msg.LParamHi = 88) then
  begin
    //    BITBTN13.Click;
  end;

  if (msg.LParamLo = MOD_ALT) and (Msg.LParamHi = 86) then
  begin
    //    BITBTN12.Click;
  end;

  if (msg.LParamLo = MOD_ALT) and (Msg.LParamHi = 69) then
  begin
    //    BITBTN11.Click;
  end;

  if Msg.LParamHi = 34 then
    btn2.click;

  if Msg.LParamHi = 33 then
    btn1.click;

  if (msg.LParamHi = vk_escape) then
  begin

    //    richedit3.SetFocus;
    //    richedit3.SetFocus;
    exit;
  end;

  if (msg.LParamLo = 2) and (Msg.LParamHi = 13) then
  begin
    //  edit3.Font.Color := clred;
   //   webbrowser2.Navigate(extractfilepath(application.exename) + 'tmp2.htm')
  end;
  //

  if (msg.LParamLo = 2) and (Msg.LParamHi = 8) then
  begin
    //    if length(richstr) < 1 then
    //    begin
    //      richstr := richedit3.Text;
    //      richedit3.Clear;
    //    end
    //    else
    //    begin
    //      richedit3.Text := richedit3.Text + chr(13) + richstr;
    //      richstr := '';
    //    end;
  end;
end;

function Tfmks16.getbj: integer;
var
  zjid: string;
  aa, bb: integer;
begin
  result := -1;
  try
    aa := pos('km=''', mysys.tmid);
    zjid := copy(mysys.tmid, aa + 4, 1);
    mydb.qrytmp.close;
    mydb.qrytmp.SQL.Clear;
    mydb.qrytmp.SQL.Add('select id from tmts where km=:km and zjid=:zj');
    mydb.qrytmp.Parameters.ParamByName('km').Value := zjid;
    mydb.qrytmp.Parameters.ParamByName('zj').Value := '098';
    mydb.qrytmp.open;
    if mydb.qrytmp.RecordCount > 0 then
    begin
      result := mydb.qrytmp.fieldbyname('id').asinteger;
    end;
  except
  end;

end;

procedure Tfmks16.IEMessageHandler(var Msg: TMsg; var Handled: Boolean);
const
  StdKeys = [VK_TAB, VK_RETURN]; { 标准键 }
  ExtKeys = [VK_DELETE, VK_BACK, VK_LEFT, VK_RIGHT]; { 扩展键 }
  fExtended = $01000000; { 扩展键标志 }
begin
  Handled := False;
  with Msg do
    if ((Message >= WM_KEYFIRST) and (Message <= WM_KEYLAST)) and
      ((wParam in StdKeys) or (GetKeyState(VK_CONTROL) < 0) or
      (wParam in ExtKeys) and ((lParam and fExtended) = fExtended)) then
      try
        if IsChild(webbrowser1.Handle, hWnd) then
          { 处理所有的浏览器相关消息 }
        begin
          with webbrowser1.Application as IOleInPlaceActiveObject do
            Handled := TranslateAccelerator(Msg) = S_OK;
          if not Handled then
          begin
            Handled := True;
            TranslateMessage(Msg);
            DispatchMessage(Msg);
          end;
        end;
      except
      end;
end; // IEMessageHandler

function Tfmks16.gethtml: string;
var
  doc: Variant;
  str: string;
  len1, len2: integer;
begin
  //
  result := '';
  webbrowser1.ExecWB(OLECMDID_SAVE, OLECMDEXECOPT_DONTPROMPTUSER);
  doc := webbrowser1.Document;
  str := doc.body.innerhtml;
  LEN1 := pos('<BODY', UPPERCASE(STR));
  len2 := pos('</BODY>', UPPERCASE(STR));
  try
    result := lowercase(copy(str, LEN1, LENGTH(STR) - LEN1 - len2));
  except
  end;
end;

function Tfmks16.sortans(ABCD, ans: string): string;
var
  I, LEN1: INTEGER;
  str, str1, stra: string;
begin
  //
  stra := uppercase(trim(abcd));
  str := uppercase(trim(ANS));
  LEN1 := LENGTH(str);
  for i := 1 to len1 do
  begin
    str1 := copy(str, i, 1);
    if stra = str1 then
    begin
      result := ans;
      exit;
    end
    else if stra < str1 then
    begin
      result := stringreplace(str, str1, stra + str1, []);
      exit;
    end
  end;
  result := str + stra;
end;

procedure Tfmks16.Button12Click(Sender: TObject);
begin
  timer1.Enabled := true;
  sj := strtodatetime('2009-01-01 0:0:0');
end;

procedure Tfmks16.Timer1Timer(Sender: TObject);
begin
  sj := incsecond(sj);
  statusbar1.panels[1].Text := formatdatetime('yyyy-mm-dd hh:mm', now);
  statusbar1.panels[2].Text := '做题已用时:' + formatdatetime('hh:nn:ss', sj);
end;

function Tfmks16.getyy(str: string): double;
var
  pos1, pos2: integer;
  calc: TSmpExprCalc;
  strx: string;
begin
  calc := TSmpExprCalc.Create(TRUE);
  pos1 := pos(',', str);
  pos2 := pos(')', str);
  try
    strx := copy(str, pos1 + 1, pos2 - pos1 - 1);
    calc.Expression := strx;
    calc.FormatStr := '%f';
    result := calc.value;

  except
    result := 0;
  end;
end;

function Tfmks16.getpS(str: string): double;
var
  xx, yy: double;
begin
  //
  xx := geti(str);
  yy := getyy(str);
  result := 1 / power((1 + xx), yy);
end;

function Tfmks16.getpA(str: string): double;
var
  x, y, z: double;
begin
  //
  x := geti(str);
  y := getyy(str);
  z := power((1 + x), y);
  z := 1 / z;
  z := 1 - z;
  z := z / x;
  result := z;
end;

function Tfmks16.geti(str: string): double;
var
  pos1, pos2: integer;
begin
  pos1 := pos('(', str);
  pos2 := pos(',', str);
  try
    result := strtofloat(trim(copy(str, pos1 + 1, pos2 - pos1 - 1))) / 100;
  except
    result := 0;
  end;
end;

function Tfmks16.getpstr(str: string): string;
var
  str1, STR2: string;
  bz: boolean;
  i: integer;
begin
  //
  bz := false;
  str1 := '';
  for i := 1 to length(str) do
  begin
    if bz then
    begin
      str1 := str1 + str[i];
      if (str[i] = ')') then
      begin
        bz := false;
        break;
      end;
    end;

    if (str[i] = 'p') or (str[i] = 'P') then
    begin
      bz := true;
      str1 := str1 + str[i];
    end;

  end;

  str1 := trim(str1);
  if copy(uppercase(str1), 1, 2) = 'PA' then
    STR2 := FLOATTOSTR(ROUND(GETPA(STR1) * 10000) / 10000)
  else if copy(uppercase(str1), 1, 2) = 'PS' then
    STR2 := FLOATTOSTR(ROUND(GETPS(STR1) * 10000) / 10000)
  else if copy(uppercase(str1), 1, 2) = 'PW' then
    STR2 := FLOATTOSTR(ROUND(GETKF(STR1) * 10000) / 10000);

  RESULT := stringreplace(str, STR1, STR2, [])
end;

procedure Tfmks16.FormDeactivate(Sender: TObject);
var
  i: Integer;
begin
  //注销热键
  for i := Low(HotKeyId) to High(HotKeyId) do
  begin
    UnRegisterHotKey(handle, HotKeyId[i]);
    GlobalDeleteAtom(HotKeyId[i]);
  end;
end;

procedure Tfmks16.RichEdit3KeyPress(Sender: TObject; var Key: Char);
var
  str1: string;
  aline: integer;
  str2, str3: string;
  p1: integer;

begin
  //
  if key = #13 then
  begin
    //
    //    aline := GetCaretPosEx.x;
    ////    str1 := richedit3.Lines[aline];
    //    str3 := '';
    //    if pos(copy(str1, 1, 1), '+-*/') > 0 then
    //    begin
    //      try
    //        str3 := richedit3.Lines[aline - 1];
    //        p1 := lastpos('=', str3);
    //        str3 := copy(str3, p1 + 1, length(str3) - p1);
    //      except
    //      end;
    //    end;

    //    str1 := str3 + str1;
    //    if pos(uppercase(copy(str1, 1, 1)), '-(P0123456789') > 0 then
    //    begin
    //      if pos('=', str1) > 0 then
    //        str1 := copy(str1, 1, pos('=', str1) - 1);
    //      str2 := calctext(str1);
    //      if trim(str2) <> '' then
    //        richedit3.Lines[aline] := str1 + '=' + str2;
    //    end;
  end;

end;

function Tfmks16.GetCaretPosEx: TPoint;
var
  APos: TPoint;
begin
  //
  //  APos.X := richedit3.Perform(EM_LINEFROMCHAR, RichEdIT3.SelStart, 0);
  //  result := apos;
end;

function Tfmks16.calctext(str: string): string;
var
  calc: TSmpExprCalc;
  str1: string;
  cc: string;
begin
  result := '';

  calc := TSmpExprCalc.Create(TRUE);
  try
    try
      str1 := str;
      str1 := stringreplace(str1, ' ', '', [rfReplaceAll]);
      str1 := stringreplace(str1, '（', '(', [rfReplaceAll]);
      str1 := stringreplace(str1, '）', ')', [rfReplaceAll]);
      str1 := stringreplace(str1, '、', '/', [rfReplaceAll]);
      str1 := stringreplace(str1, '，', '', [rfReplaceAll]);

      while pos('P', uppercase(str1)) > 0 do
        STR1 := getpstr(STR1);

      calc.Expression := str1;
      calc.FormatStr := '%f';
      result := floattostr(round(calc.value * 10000) / 10000);
    except

    end;
  finally
    calc.Free;
  end;

end;

procedure Tfmks16.ApplicationEvents1Deactivate(Sender: TObject);
var
  i: Integer;
begin
  //注销热键
  for i := Low(HotKeyId) to High(HotKeyId) do
  begin
    UnRegisterHotKey(handle, HotKeyId[i]);
    GlobalDeleteAtom(HotKeyId[i]);
  end;
end;

procedure Tfmks16.ApplicationEvents1Activate(Sender: TObject);
var
  i: integer;
begin
  //
  for i := Low(HotKeyId) to High(HotKeyId) do
    HotKeyId[i] := GlobalAddAtom(PChar(IntToStr(i))); //热键命名可随意

  RegisterHotKey(Handle, HotKeyId[11], MOD_ALT, 65); //PageUp
  RegisterHotKey(Handle, HotKeyId[12], MOD_ALT, 66); //PageUp
  RegisterHotKey(Handle, HotKeyId[13], MOD_ALT, 67); //PageUp
  RegisterHotKey(Handle, HotKeyId[14], MOD_ALT, 68); //PageUp
  RegisterHotKey(Handle, HotKeyId[15], MOD_ALT, 69); //PageUp
  RegisterHotKey(Handle, HotKeyId[16], MOD_ALT, 49); //PageUp
  RegisterHotKey(Handle, HotKeyId[17], MOD_ALT, 50); //PageUp

  RegisterHotKey(Handle, HotKeyId[18], MOD_ALT, 89); //PageUp         X
  RegisterHotKey(Handle, HotKeyId[19], MOD_ALT, 87); //PageUp

  RegisterHotKey(Handle, HotKeyId[5], 0, VK_PRIOR); //PageUp
  RegisterHotKey(Handle, HotKeyId[6], 0, VK_NEXT);
  RegisterHotKey(Handle, HotKeyId[7], 0, VK_escape); //PageDown
  RegisterHotKey(Handle, HotKeyId[2], MOD_CONTROL, VK_RETURN); //Ctrl+Enter
  RegisterHotKey(Handle, HotKeyId[3], MOD_CONTROL, VK_back);
end;

function Tfmks16.getkf(str: string): double;
var
  x, y, z: double;
begin
  //
  x := geti(str);
  y := getyy(str);
  z := power(x * 100, y);
  result := z;
end;

function Tfmks16.LastPos(SearchStr, Str: string): Integer;
var
  i: Integer;
  TempStr: string;
begin
  Result := Pos(SearchStr, Str);
  if Result = 0 then
    Exit;
  if (Length(Str) > 0) and (Length(SearchStr) > 0) then
  begin
    for i := Length(Str) + Length(SearchStr) - 1 downto Result do
    begin
      TempStr := Copy(Str, i, Length(Str));
      if Pos(SearchStr, TempStr) > 0 then
      begin
        Result := i;
        break;
      end;
    end;
  end;
end;

procedure Tfmks16.WebBrowser4DocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
var

  str, yy: string;

  txtmemo: string;
  doc: Variant;
  len1, len2: integer;
begin

  doc := webbrowser4.Document;
  str := LowerCase(doc.body.innerhtml);
  LEN1 := pos(lowerCASE('id=m_blog'), (STR)) + 37;
  str := Copy(str, len1, length(str));
  len2 := pos(lowerCASE('class=opt'), (STR)); // id=blogOpt>
  try
    txtmemo := copy(str, 1, len2 - 5);
  except
  end;
  memo1.Clear;
  memo1.Lines.Add('<html>');
  memo1.Lines.Add('    <style type="text/css">');
  memo1.Lines.Add('<!--');
  memo1.Lines.Add('.maina {');
  memo1.Lines.Add('	font-family: "宋体";'); //         楷体_GB2312
  memo1.Lines.Add('	font-size: 12px;');
  memo1.Lines.Add('	line-height: 22px;');
  memo1.Lines.Add('      	margin:0px;');
  memo1.Lines.Add('padding:0px;');
  memo1.Lines.Add('	background-color: #ffffff;');

  memo1.Lines.Add('	text-align: left; ');
  memo1.Lines.Add('	color: #000000;');
  memo1.Lines.Add('}               ');

  memo1.Lines.Add('.maina p{');
  memo1.Lines.Add('	font-family: "宋体";');
  memo1.Lines.Add('	font-size: 12px;');
  memo1.Lines.Add('	line-height: 22px;');
  memo1.Lines.Add('      	margin:0px;');
  memo1.Lines.Add('padding:0px;');
  memo1.Lines.Add('	background-color: #ffffff;');
  memo1.Lines.Add('}               ');

  memo1.Lines.Add('.p{');
  memo1.Lines.Add('	font-family: "宋体";');
  memo1.Lines.Add('	font-size: 12px;');
  memo1.Lines.Add('	line-height: 22px;');
  memo1.Lines.Add('      	margin:0px;');
  memo1.Lines.Add('padding:0px;');
  memo1.Lines.Add('	background-color: #ffffff;');
  memo1.Lines.Add('}               ');

  memo1.Lines.Add('-->          ');
  memo1.Lines.Add('</style>  ');
  memo1.Lines.Add('</head>');
  memo1.Lines.Add('<body class="maina">  ');
  memo1.Lines.Add(txtmemo);
  memo1.Lines.Add('</body>');
  memo1.Lines.Add('</html>');
  memo1.Lines.SaveToFile(ExtractFilePath(Application.ExeName) + 'ver.htm');
  webbrowser1.silent := true;
  webbrowser1.Navigate(extractfilepath(application.exename) + 'ver.htm');
end;

function Tfmks16.DownloadFile(Source, Dest: string): Boolean;
begin
  try
    Result := UrlDownloadToFile(nil, PChar(source), PChar(Dest), 0, nil) = 0;
  except
    Result := False;
  end;
end;

procedure Tfmks16.getarecord(str: string; TMTSid: integer);
var
  r2: TPerlRegEx;
  ZZ: string;
  i: integer;
  tit, ans, xans: string;
  inid, sxh: string;
begin
  r2 := TPerlRegEx.Create(nil); //建立
  r2.Subject := str;
  r2.RegEx := '阳1([\s\S]+?)(1阳)';
  r2.Match;
  i := 1;
  while r2.FoundMatch do
  begin
    zz := r2.SubExpressions[1];
    if i = 1 then
      inid := zz
    else if i = 2 then
      sxh := zz
    else if i = 3 then
      tit := zz
    else if i = 4 then
      ans := zz
    else if i = 5 then
      xans := zz;
    inc(i);
    r2.MatchAgain;
  end;

  //===查询是否存在该题
  if not (trim(inid) = '9999') then
  begin
    mydb.qrytmp.Close;
    mydb.qrytmp.SQL.Clear;
    mydb.qrytmp.SQL.Add('select * from tm where inid=:inid');
    MYDB.qrytmp.Parameters.ParamByName('inid').Value := inid;
    mydb.qrytmp.open;

    if mydb.qrytmp.RecordCount > 0 then
    begin
      mydb.qrytmp.Close;
      mydb.qrytmp.SQL.Clear;
      mydb.qrytmp.SQL.Add('update tm set sxh=:sxh,title=:title,ans=:ans where inid=:inid');
      MYDB.qrytmp.Parameters.ParamByName('inid').Value := trim(inid);
      MYDB.qrytmp.Parameters.ParamByName('sxh').Value := trim(sxh);
      MYDB.qrytmp.Parameters.ParamByName('title').Value := tit;
      MYDB.qrytmp.Parameters.ParamByName('ans').Value := ans;
      mydb.qrytmp.ExecSQL;
    end
    else
    begin
      mydb.qrytmp.Close;
      mydb.qrytmp.SQL.Clear;
      mydb.qrytmp.SQL.Add('insert into tm(inid,sxh,title,ans,xans,tmts)');
      mydb.qrytmp.SQL.Add('values(:inid,:sxh,:title,:ans,:xans,:tmts)');
      MYDB.qrytmp.Parameters.ParamByName('inid').Value := trim(inid);
      MYDB.qrytmp.Parameters.ParamByName('sxh').Value := trim(sxh);
      MYDB.qrytmp.Parameters.ParamByName('title').Value := tit;
      MYDB.qrytmp.Parameters.ParamByName('ans').Value := ans;
      MYDB.qrytmp.Parameters.ParamByName('xans').Value := xans;
      MYDB.qrytmp.Parameters.ParamByName('tmts').Value := tmtsid;
      mydb.qrytmp.ExecSQL;
    end;
  end
  else
  begin
    mydb.qrytmp.Close;
    mydb.qrytmp.SQL.Clear;
    mydb.qrytmp.SQL.Add('insert into tm(inid,sxh,title,ans,xans,tmts)');
    mydb.qrytmp.SQL.Add('values(:inid,:sxh,:title,:ans,:xans,:tmts)');
    MYDB.qrytmp.Parameters.ParamByName('inid').Value := 0;
    MYDB.qrytmp.Parameters.ParamByName('sxh').Value := trim(sxh);
    MYDB.qrytmp.Parameters.ParamByName('title').Value := tit;
    MYDB.qrytmp.Parameters.ParamByName('ans').Value := ans;
    MYDB.qrytmp.Parameters.ParamByName('xans').Value := xans;
    MYDB.qrytmp.Parameters.ParamByName('tmts').Value := tmtsid;
    mydb.qrytmp.ExecSQL;
  end;
end;

procedure Tfmks16.CheckParentProc;
var //检查自己的进程的父进程
  pn: tprocessentry32;
  shandle: thandle;
  h, explproc, parentproc: hwnd;
  found: boolean;
  buffer: array[0..1023] of char;
  path: string;
begin
  h := 0;
  explproc := 0;
  parentproc := 0;
  //得到windows的目录
//  setstring(path, buffer);
  SetString(Path, Buffer, GetWindowsDirectory(Buffer, Sizeof(Buffer) - 1));
  getwindowsdirectory(buffer, sizeof(buffer) - 1);
  path := uppercase(path) + '\explorer.exe'; //得到explorer的路径
  //得到所有进程的列表快照
  sHandle := CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);

  found := process32first(shandle, pn); //查找进程
  while found do //遍历所有进程
  begin
    if pn.szexefile = paramstr(0) then //自己的进程
    begin
      parentproc := pn.th32parentprocessid; //得到父进程的进程id
      //父进程的句柄

      h := openprocess(process_all_access, true, pn.th32parentprocessid);
    end
    else if uppercase(pn.szexefile) = path then
      explproc := pn.th32processid; //ex plorer的pid
    found := process32next(shandle, pn); //查找下一个
  end;
  //父进程不是explorer，是调试器……

  if ParentProc <> ExplProc then
  begin
    TerminateProcess(H, 0);
    while 1 <> 1 do
      Application.MessageBox('', '', MB_OK + MB_ICONSTOP);
  end;
end;

procedure Tfmks16.N9Click(Sender: TObject);
begin
  n9.Checked := not n9.Checked;

  if n9.Checked then
  begin
    //   edit3.Font.Color := clred;
     //  webbrowser2.Navigate(extractfilepath(application.exename) + 'tmp2.htm')
  end
  else
  begin
    //   edit3.Font.Color := clwhite;
    //   webbrowser2.Navigate(extractfilepath(application.exename) + 'blank.htm');
  end;
  mysys.isautodisp := n9.Checked;
  saveParamtoFile(ExtractFilePath(Application.EXEName) + 'kjks.ini');

end;

procedure Tfmks16.N10Click(Sender: TObject);
begin
  n10.Checked := not n10.Checked;
  if beginbz then
    exit;
  mysys.isafterpage := n10.Checked;
  saveParamtoFile(ExtractFilePath(Application.EXEName) + 'kjks.ini');

end;

procedure Tfmks16.N13Click(Sender: TObject);
begin
  n13.Checked := not n13.Checked;
  if beginbz then
    exit;
  mysys.isautoans := n13.Checked;
  saveParamtoFile(ExtractFilePath(Application.EXEName) + 'kjks.ini');
  // dispthisans;
end;

procedure Tfmks16.Button2Click(Sender: TObject);
var
  aform: tfmreg;
begin
  aform := tfmreg.create(nil);
  try
    aform.ShowModal;
  except
    aform.close;
    aform.free;
  end;
end;

procedure Tfmks16.Button14Click(Sender: TObject);
begin
  getver;
end;

procedure Tfmks16.writeHTML(WebInfo: TWebBrowser; text: string);
var
  HTMLDoc: IHTMLDocument2;
  v: Variant;
begin
  WebInfo.Navigate('about:blank ', EmptyParam, EmptyParam, EmptyParam,
    EmptyParam);
  while WebInfo.ReadyState <> READYSTATE_COMPLETE do
  begin
    Application.ProcessMessages;
    Sleep(0);
  end;
  if Assigned(WebInfo.Document) then
  begin
    HTMLDoc := WebInfo.Document as IHTMLDocument2;
    v := VarArrayCreate([0, 0], varVariant);
    v[0] := text; //
    HTMLDoc.clear;
    HTMLDoc.Write(PSafeArray(TVarData(v).VArray));
    HTMLDoc.Close;
    v := Unassigned;
  end;
end;

procedure Tfmks16.getver;
var
  str, txtmemo: string;
  len1, len2: integer;
begin
  try
    str := ''; // idhttp1.Get(webpage);
    LEN1 := pos(lowerCASE('id=m_blog'), (STR)) + 37 + 13;
    str := Copy(str, len1, length(str));
    len2 := pos(lowerCASE('class=opt'), (STR)); // id=blogOpt>
    try
      txtmemo := copy(str, 1, len2 - 4);
    except
    end;
  except
    txtmemo := '没有连接网络，无法显示最近更新' + chr(13) + chr(13) +
      '最近详情，请访问：http://hi.baidu.com/lxschool/home';

  end;
  memo1.Clear;
  memo1.Lines.Add('<html>');
  memo1.Lines.Add('    <style type="text/css">');
  memo1.Lines.Add('<!--');
  memo1.Lines.Add('.maina {');
  memo1.Lines.Add('	font-family: "宋体";'); //         楷体_GB2312
  memo1.Lines.Add('	font-size: 12px;');
  memo1.Lines.Add('	line-height: 22px;');
  memo1.Lines.Add('      	margin:0px;');
  memo1.Lines.Add('        text-align: left;');

  memo1.Lines.Add('padding:0px;');
  memo1.Lines.Add('	background-color: #ffffff;');

  memo1.Lines.Add('	text-align: left; ');
  memo1.Lines.Add('	color: #000000;');
  memo1.Lines.Add('}               ');

  memo1.Lines.Add('.maina p{');
  memo1.Lines.Add('	font-family: "宋体";');
  memo1.Lines.Add('	font-size: 12px;');
  memo1.Lines.Add('	line-height: 22px;');
  memo1.Lines.Add('      	margin:0px;');
  memo1.Lines.Add('padding:0px;');
  memo1.Lines.Add('	background-color: #ffffff;');
  memo1.Lines.Add('}               ');

  memo1.Lines.Add('.p{');
  memo1.Lines.Add('	font-family: "宋体";');
  memo1.Lines.Add('	font-size: 12px;');
  memo1.Lines.Add('	line-height: 22px;');
  memo1.Lines.Add('      	margin:0px;');
  memo1.Lines.Add('padding:0px;');
  memo1.Lines.Add('	background-color: #ffffff;');
  memo1.Lines.Add('}               ');

  memo1.Lines.Add('  #cent {              ');
  memo1.Lines.Add('	text-align: LEFT;             ');
  memo1.Lines.Add('	width:100% ;          ');
  memo1.Lines.Add('}               ');

  memo1.Lines.Add('-->          ');
  memo1.Lines.Add('</style>  ');
  memo1.Lines.Add('</head>');
  memo1.Lines.Add('<body class="maina">  ');
  memo1.Lines.Add('<div id=cent>  ');

  Memo1.Lines.Add('<p><b>操作提示：在主窗口中直接点【下一题】开始答题！</b></p>');
  memo1.Lines.Add(StringReplace(txtmemo, 'table',
    'table  align="LEFT" bordercolor="#0000FF"  ', [rfreplaceall]));
  memo1.Lines.Add('</div> ');
  memo1.Lines.Add('</body>');
  memo1.Lines.Add('</html>');

  memo1.Lines.SaveToFile(ExtractFilePath(Application.ExeName) + 'ver.htm');
  webbrowser1.silent := true;
  webbrowser1.Navigate(extractfilepath(application.exename) + 'ver.htm');

end;

procedure Tfmks16.N14Click(Sender: TObject);
begin
  getver;
end;

procedure Tfmks16.btn10Click(Sender: TObject);
begin
  recordchange;
  atmlist.FIRST;
end;

procedure Tfmks16.btn11Click(Sender: TObject);
begin
  recordchange;
  atmlist.LAST;
end;

procedure Tfmks16.btn9Click(Sender: TObject);
begin
  recordchange;
  atmlist.PRIOR;
end;

procedure Tfmks16.btn8Click(Sender: TObject);
begin
  recordchange;
  atmlist.NEXT;
end;

procedure Tfmks16.btn1Click(Sender: TObject);
begin
  atmlist.current_isimportant := not atmlist.tCurrentTMREC.isimportant;
  if atmlist.tCurrentTMREC.isimportant then
    ShowMessage('当前题已设为重点题')
  else
    ShowMessage('当前题已取消设为重点题');

end;

procedure Tfmks16.btn14Click(Sender: TObject);
var
  aform: tformbjb;
begin
  //
  try

    aform := tformbjb.Create(nil);
    aform.Showmodal;
  finally
    aform.Free;
    aform := nil;
  end;

end;

procedure Tfmks16.btn13Click(Sender: TObject);
var
  aform: TFMSELECTrnd;
begin

  aform := TFMSELECTrnd.create(self);
  try
    aform.showmodal;
    mydb.qrytm.close;
    MYDB.QRYTM.SQL.CLEAR;
    mydb.qrytm.SQL.Add('select * from tmtmp');
    mydb.qrytm.Open;
    mydb.qrytm.first;
    mysys.tmtitle := '随机抽题练习题';
    //   label1.Caption := mysys.tmtitle;
  finally
    aform.free;
  end;
end;

procedure Tfmks16.Ansdwerclick(Sender: TObject);
var
  STRanswer: string;
begin
  STRanswer := UpperCase(Trim(edtAnswer.Text));
  if pos(tbitbtn(sender).caption, STRanswer) > 0 then
    Donothing
  else if tbitbtn(sender).caption = '~' then
    edtAnswer.Clear
  else if pos(tbitbtn(sender).caption, edtAnswer.Text) < 1 then
    if atmlist.tCurrentTMREC.TMTYPE = TMTYPE_ONESELECT then
      edtAnswer.Text := tbitbtn(sender).caption
    else if atmlist.tCurrentTMREC.TMTYPE = TMTYPE_judgment then
      edtAnswer.Text := tbitbtn(sender).caption
    else
      edtAnswer.Text := sortans(tbitbtn(sender).caption, edtAnswer.Text);
end;

procedure Tfmks16.donothing;
begin
  //
  ;
end;

procedure Tfmks16.edtAnswerChange(Sender: TObject);
begin
  atmlist.current_myshortans := edtAnswer.Text;
end;

procedure Tfmks16.RichEditANSExit(Sender: TObject);
begin
  recordchange;
end;

procedure Tfmks16.recordchange;
begin
  atmlist.current_mylongans := RichEditANS.Text;
end;

end.

