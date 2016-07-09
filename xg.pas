unit xg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, DB, ADODB;

const
  NOSIZETAG = -10000;
type
  Tfmxg = class(TForm)
    Panel1: TPanel;
    BitBtn3: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn4: TBitBtn;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Panel2: TPanel;
    Memo1: TMemo;
    Panel3: TPanel;
    Memo2: TMemo;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    qryxg: TADOQuery;
    Edit1: TEdit;
    Label1: TLabel;
    Panel4: TPanel;
    Label2: TLabel;
    Panel5: TPanel;
    Label3: TLabel;
    BitBtn7: TBitBtn;
    Label4: TLabel;
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure disptm;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure saveadd();
    procedure savemodify;
    procedure BitBtn7Click(Sender: TObject);
    procedure WMSize(var message: TWMSize);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmxg: Tfmxg;
  isnew: boolean;

implementation

uses DAT;

{$R *.dfm}

procedure Tfmxg.BitBtn3Click(Sender: TObject);
begin
  isnew := false;
  if mydb.qrytm.Active = false then
    exit;
  if mydb.qrytm.bof then
    exit;

  mydb.qrytm.first;
  disptm;
end;

procedure Tfmxg.BitBtn1Click(Sender: TObject);
begin
  isnew := false;
  if mydb.qrytm.Active = false then
    exit;
  if mydb.qrytm.bof then
    exit;


  mydb.qrytm.Prior;
  disptm;
end;

procedure Tfmxg.BitBtn2Click(Sender: TObject);
begin
  isnew := false;
  if mydb.qrytm.Active = false then
    exit;

  if mydb.qrytm.Eof then
    exit;


  mydb.qrytm.Next;
  disptm;
end;

procedure Tfmxg.BitBtn4Click(Sender: TObject);
begin
  isnew := false;
  if mydb.qrytm.Active = false then
    exit;
  if mydb.qrytm.Eof then
    exit;


  mydb.qrytm.last;
  disptm;
end;

procedure Tfmxg.disptm;
begin
  mydb.qrytmp.close;
  mydb.qrytmp.SQL.Clear;
  mydb.qrytmp.SQL.Add('select * from tm');
  mydb.qrytmp.SQL.Add('where id=:id');
  mydb.qrytmp.Parameters.ParamByName('id').Value := mydb.qrytm.fieldbyname('id').asinteger;
  mydb.QRYtmp.open;
  memo1.text := mydb.qrytmp.fieldbyname('title').AsString;
  memo2.text := mydb.qrytmp.fieldbyname('ans').AsString;
  EDIT1.Text := mydb.qrytmp.fieldbyname('Xans').AsString;
  label4.Caption := '总' + inttostr(mydb.qrytm.RecordCount) + '题,当前' + inttostr(mydb.qrytm.RecNo) + '题';
end;

procedure Tfmxg.FormCreate(Sender: TObject);
begin
  panel1.Caption := '';
  panel4.Caption := '';
  panel5.Caption := '';
  EDIT1.Clear;
  memo1.Clear;
  memo2.Clear;
  disptm;
  isnew := false;
end;

procedure Tfmxg.BitBtn6Click(Sender: TObject);
begin
  isnew := true;
  memo1.Clear;
  memo2.Clear;
end;

procedure Tfmxg.BitBtn5Click(Sender: TObject);
begin
  if (trim(memo1.Text) = '') and (trim(memo2.Text) = '') then
  begin
    showmessage('请先填好题目与答案后再保存');
    exit;
  end;
  if isnew then
    saveadd
  else
    savemodify;
end;

procedure Tfmxg.saveadd;
begin
  mydb.qrytm.First;
  qryxg.Close;
  qryxg.SQL.Clear;
  qryxg.SQL.Add('insert into tm (title,ans,xans,tmts)');
  qryxg.SQL.Add('values (:title,:ans,:xans,:tmts)');
  qryxg.Parameters.ParamByName('title').Value := memo1.Text;
  qryxg.Parameters.ParamByName('ans').Value := memo2.Text;
  qryxg.Parameters.ParamByName('xans').Value := uppercase(edit1.text);
  qryxg.Parameters.ParamByName('tmts').Value := mydb.qrytm.fieldbyname('TMTS').asinteger;
  qryxg.execsql;
  showmessage('该题已加入成功加入题库');
  MYDB.qrytm.CLOSE;
  mydb.qrytm.Open;
  disptm;

end;

procedure Tfmxg.savemodify;
begin
//
  qryxg.Close;
  qryxg.SQL.Clear;
  qryxg.SQL.Add('update tm set title=:title,ans=:ans,xans=:xans');
  qryxg.SQL.Add('where id=:id');
  qryxg.Parameters.ParamByName('title').Value := memo1.Text;
  qryxg.Parameters.ParamByName('ans').Value := memo2.Text;
  qryxg.Parameters.ParamByName('xans').Value := uppercase(edit1.text);
  qryxg.Parameters.ParamByName('id').Value := mydb.qrytm.fieldbyname('id').asinteger;
  qryxg.execsql;
  disptm;
end;

procedure Tfmxg.BitBtn7Click(Sender: TObject);
begin
  if Application.MessageBox(pchar('是否真的删除该题'), pchar('删除'), MB_OKCANCEL + MB_ICONQUESTION) = idOK then
  begin
    qryxg.Close;
    qryxg.SQL.Clear;
    qryxg.SQL.Add('delete from  tm ');
    qryxg.SQL.Add('where id=:id');
    qryxg.Parameters.ParamByName('id').Value := mydb.qrytm.fieldbyname('id').asinteger;
    qryxg.execsql;
  end;
  showmessage('该题已从提示框中删除!');
  MYDB.qrytm.CLOSE;
  mydb.qrytm.Open;
  disptm;

end;

procedure Tfmxg.WMSize(var message: TWMSize);
var
  H: HWND;
begin
  if Tag <> NOSIZETAG then
  begin
    if (message.SizeType = SIZE_MINIMIZED) or (message.SizeType = SIZE_RESTORED) then
    begin
      H := SendMessage(self.Handle, WM_MDIGETACTIVE, 0, 0);
      SHOWWINDOW(Handle, SW_MAXIMIZE);
      SendMessage(self.Handle, WM_MDIACTIVATE, Word(H), 0);
    end
    else
      inherited;
  end;
end;

procedure Tfmxg.FormShow(Sender: TObject);
begin
  Left := 0; Width := Screen.Width;
  Top := 0; Height := Screen.Height - 20;

  PostMessage(self.Handle, WM_SYSCOMMAND, SC_MAXIMIZE, 0); //最大化
end;

end.

