unit fmbjb;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, OleCtrls, SHDocVw, StdCtrls, mshtml, ActiveX,
  DB, ADODB, Buttons, ComCtrls;

type
  Tformbjb = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    WebBrowser1: TWebBrowser;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    qrytmp: TADOQuery;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    RichEdit1: TRichEdit;
    procedure FormCreate(Sender: TObject);

    procedure dispbjb;
    function getbj: integer;
    procedure IEMessageHandler(var Msg: TMsg; var
      Handled: Boolean);
    procedure Button1Click(Sender: TObject);
    function gethtml: string;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure openbj;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    function gettmts: integer;
    procedure BitBtn6Click(Sender: TObject);
  private
    { Private declarations }
  public
    km: string;
    { Public declarations }
  end;

var
  formbjb: Tformbjb;

implementation

uses DAT, shareunit;

{$R *.dfm}

procedure Tformbjb.dispbjb;
var
  str1, str2: string;
  str: TStringStream;
begin

  memo1.Clear;
  memo1.Lines.Add('<html>');
  memo1.Lines.Add('    <style type="text/css">');
  memo1.Lines.Add('<!--');
  memo1.Lines.Add('.main {');
  memo1.Lines.Add('	font-family: "宋体";'); //         楷体_GB2312
  memo1.Lines.Add('	font-size: 20px;');
  memo1.Lines.Add('	line-height: 25px;');
  memo1.Lines.Add('      	margin:0px;');
  memo1.Lines.Add('padding:0px;');
  memo1.Lines.Add('	background-color: #ffffff;');

  memo1.Lines.Add('	text-align: left; ');
  memo1.Lines.Add('	color: #000000;');
  memo1.Lines.Add('}               ');

  memo1.Lines.Add('.main p{');
  memo1.Lines.Add('	font-family: "宋体";');
  memo1.Lines.Add('	font-size: 20px;');
  memo1.Lines.Add('	line-height: 22px;');
  memo1.Lines.Add('      	margin:0px;');
  memo1.Lines.Add('padding:0px;');
  memo1.Lines.Add('	background-color: #ffffff;');
  memo1.Lines.Add('}               ');

  memo1.Lines.Add('-->          ');
  memo1.Lines.Add('</style>  ');
  memo1.Lines.Add('</head>');
  memo1.Lines.Add('<body class="main">  ');

  str := TStringStream.Create(qrytmp.fieldbyname('title').AsString);

  richedit1.Lines.LoadFromStream(STR);
  memo1.Lines.Add(richedit1.text);
  memo1.Lines.Add('</body>');
  memo1.Lines.Add('<head>');
  try
    memo1.Lines.SaveToFile(ExtractFilePath(Application.ExeName) + 'tmpbj.htm');
    webbrowser1.Navigate(extractfilepath(application.exename) + 'tmpbj.htm');
  except
  end;

  while webbrowser1.busy do
    Application.ProcessMessages;
  (webbrowser1.Document as IHTMLDocument2).designMode := 'On';

end;

procedure Tformbjb.FormCreate(Sender: TObject);
begin
  PANEL1.Caption := '';
  richedit1.Visible := false;
  memo1.Visible := false;
  Application.OnMessage := IEMessageHandler;
  openbj;
end;

procedure Tformbjb.IEMessageHandler(var Msg: TMsg; var
  Handled: Boolean);
const
  StdKeys = [VK_TAB, VK_RETURN]; { 标准键 }
  ExtKeys = [VK_DELETE, VK_BACK, VK_LEFT, VK_RIGHT]; { 扩展键
  }
  fExtended = $01000000; { 扩展键标志 }
begin
  Handled := False;
  with Msg do
    if ((Message >= WM_KEYFIRST) and (Message <= WM_KEYLAST))
      and
      ((wParam in StdKeys) or (GetKeyState(VK_CONTROL) < 0) or
      (wParam in ExtKeys) and ((lParam and fExtended) =
      fExtended)) then
    try
      if IsChild(webbrowser1.Handle, hWnd) then
        { 处理所有的浏览器相关消息 }
      begin
        with webbrowser1.Application as
          IOleInPlaceActiveObject do
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

function Tformbjb.getbj: integer;
var
  aa, bb: integer;
begin
  result := -1;
  try
    QRYTMP.close;
    QRYTMP.SQL.Clear;
    QRYTMP.SQL.Add('select id from tmts where km=:km and zjid=:zj');
    QRYTMP.Parameters.ParamByName('km').Value := km;
    QRYTMP.Parameters.ParamByName('zj').Value := '098';
    QRYTMP.open;
    if QRYTMP.RecordCount > 0 then
    begin
      result := QRYTMP.fieldbyname('id').asinteger;
    end;
  except
  end;
end;

procedure Tformbjb.Button1Click(Sender: TObject);
var
  str: string;
  aa: integer;
begin
  try
    if qrytmp.Active = false then
      exit;
    if qrytmp.RecordCount < 1 then
      exit;
    QRYTMP.close;
    QRYTMP.SQL.Clear;
    QRYTMP.SQL.Add('update tm set title=:title ');
    QRYTMP.SQL.Add('where id=:id');

    QRYTMP.Parameters.ParamByName('title').Value := gethtml;
    QRYTMP.Parameters.ParamByName('id').Value :=
      qrytmp.fieldbyname('id').asinteger;
    QRYTMP.ExecSQL;
  except

  end;

  aa := qrytmp.fieldbyname('id').asinteger;
  qrytmp.Requery();
  qrytmp.locate('id', aa, []);

  showmessage('已记下笔记');
end;

function Tformbjb.gethtml: string;
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

procedure Tformbjb.Button2Click(Sender: TObject);
begin
  with webbrowser1.Document as IHTMLDocument2 do
  begin
    execCommand('ForeColor', False, 'white');
    execCommand('Bold', False, 1);
    execCommand('FontSize', False, 5);
    execCommand('BackColor', False, 'red');

    webbrowser1.ExecWB(OLECMDID_SAVE, OLECMDEXECOPT_DONTPROMPTUSER);
  end;
end;

procedure Tformbjb.Button3Click(Sender: TObject);
begin
  with webbrowser1.Document as IHTMLDocument2 do
  begin
    execCommand('ForeColor', False, 'black');
    execCommand('Bold', False, 1);
    execCommand('FontSize', False, 3);
    execCommand('BackColor', False, 'white');
    webbrowser1.ExecWB(OLECMDID_SAVE, OLECMDEXECOPT_DONTPROMPTUSER);
  end;
end;

procedure Tformbjb.openbj;
begin
  km := amykm;
  qrytmp.Close;
  qrytmp.SQL.Clear;
  qrytmp.SQL.add('select * from tm where  tmts in (select id as tmts from tmts where km=''' + km + '''' + ' and zjid=''' + '098' + ''') order by id');
  qrytmp.Open;
  qrytmp.first;
  dispbjb;
end;

procedure Tformbjb.BitBtn2Click(Sender: TObject);
begin
  if qrytmp.Active = false then
    exit;
  if qrytmp.bof then
    exit;

  qrytmp.Prior;
  dispbjb;
end;

procedure Tformbjb.BitBtn3Click(Sender: TObject);
begin
  if qrytmp.Active = false then
    exit;
  if qrytmp.eof then
    exit;

  qrytmp.next;
  dispbjb;
end;

procedure Tformbjb.BitBtn1Click(Sender: TObject);
begin
  qrytmp.first;
  dispbjb;
end;

procedure Tformbjb.BitBtn4Click(Sender: TObject);
begin
  qrytmp.last;
  dispbjb;
end;

procedure Tformbjb.BitBtn5Click(Sender: TObject);
var
  tmts: integer;
  table1: tadotable;
  mytmid: integer;
  str: string;
begin
  //
  tmts := gettmts;
  table1 := tadotable.Create(nil);
  table1.Connection := QRYTMP.Connection;
  table1.TableName := 'tm';
  try
    table1.open;
    table1.Append;
    table1.FieldByName('tmts').AsInteger := tmts;
    str := '==' + formatdatetime('yyyy-mm-dd hh:nn', now) + '==';
    table1.FieldByName('title').Asstring := str;

    table1.Post;
    mytmid := table1.FieldByName('id').AsInteger;

    qrytmp.Requery();

    qrytmp.Locate('id', mytmid, []);
    dispbjb;
  except
  end;
end;

function Tformbjb.gettmts: integer;
begin
  //
  result := -1;
  try
    QRYTMP.close;
    QRYTMP.SQL.Clear;
    QRYTMP.SQL.Add('select tmts from tm ');
    QRYTMP.SQL.Add('where id=:id');
    QRYTMP.Parameters.ParamByName('id').Value :=
      qrytmp.fieldbyname('id').asinteger;
    QRYTMP.Open;
    result := QRYTMP.fieldbyname('tmts').AsInteger;

  except
    result := -1;
  end;
end;

procedure Tformbjb.BitBtn6Click(Sender: TObject);
var
  str: string;
  aa: integer;
begin
  try
    if qrytmp.Active = false then
      exit;
    if qrytmp.RecordCount < 1 then
      exit;
    QRYTMP.close;
    QRYTMP.SQL.Clear;
    QRYTMP.SQL.Add('delete from tm ');
    QRYTMP.SQL.Add('where id=:id');
    QRYTMP.Parameters.ParamByName('id').Value :=
      qrytmp.fieldbyname('id').asinteger;
    QRYTMP.ExecSQL;
  except

  end;

  if not qrytmp.eof then
  begin
    qrytmp.Prior;
    aa := qrytmp.fieldbyname('id').asinteger;
    qrytmp.Requery();
    qrytmp.locate('id', aa, []);
  end
  else
  begin
    qrytmp.Requery();
    qrytmp.First;
  end;


  showmessage('已删除');
end;

end.
