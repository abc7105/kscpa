unit fmdy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GridsEh, DBGridEh, DB, ADODB, StdCtrls, Grids, BaseGrid,
  ComCtrls, ExtCtrls, Printers, richedit, TlHelp32,
  OleCtrls, SHDocVw, Wordxp, ComObj, OleServer, ShlObj, Word2000;
                        
type
  Tformdy = class(TForm)
    dsdy: TDataSource;
    ADOQuery1: TADOQuery;
    Button1: TButton;
    CheckBox2: TCheckBox;
    Memo1: TMemo;
    GroupBox1: TGroupBox;
    advs1: TStringGrid;
    Panel1: TPanel;
    Button2: TButton;
    Button3: TButton;
    FontDialog1: TFontDialog;
    Button5: TButton;
    Label1: TLabel;
    Panel2: TPanel;
    WebBrowser1: TWebBrowser;
    Button4: TButton;
    WordDocument1: TWordDocument;
    WordApplication1: TWordApplication;
    SaveDialog1: TSaveDialog;
    CheckBox1: TCheckBox;
    Button6: TButton;
    CheckBox3: TCheckBox;
    Button7: TButton;
    procedure Button1Click(Sender: TObject);
    procedure advs1DblClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure dy();
    procedure FormCreate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FontDialog1Close(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure onlydy;
    procedure selectdy;
    procedure CheckBox2Click(Sender: TObject);
    procedure WebBrowser1NewWindow2(Sender: TObject; var ppDisp: IDispatch;
      var Cancel: WordBool);
    procedure WebBrowser1NavigateComplete2(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure Button4Click(Sender: TObject);
    function getdocname(str: string): string;
    procedure Button6Click(Sender: TObject);
    function getrightstr(str: string; n: integer): string;
    function gethtmlname(): string;
    function getdocfilename: string;
    procedure SysDelay(aMs: Longint);
    function FindProcessByFileName(FineName: string): Boolean;
    procedure Button7Click(Sender: TObject);
  private
    function GetSpecialFolderDir(const folderid: integer): string;
    { Private declarations }
  public
    procedure getlist;

    { Public declarations }
  end;

var
  formdy: Tformdy;
  FWord: Variant;
  FDoc: Variant;
  htmlname: string;
implementation
uses DAT, shareunit;

{$R *.dfm}

{ Tformdy }

procedure Tformdy.Button1Click(Sender: TObject);
begin
  memo1.Clear;
  selectdy();

  if memo1.GetTextLen = 0 then
    exit;
  // dy;

end;

procedure Tformdy.advs1DblClick(Sender: TObject);
begin
  if advs1.col = 3 then
    if trim(advs1.Cells[advs1.Col, advs1.row]) = '' then
      advs1.Cells[3, advs1.row] := '√'
    else
      advs1.Cells[3, advs1.row] := '';
end;

procedure Tformdy.Button2Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to adoquery1.RecordCount - 1 do
    advs1.Cells[3, i + 1] := '√'
end;

procedure Tformdy.Button3Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to adoquery1.RecordCount - 1 do
    advs1.Cells[3, i + 1] := ''
end;

procedure Tformdy.getlist;
var
  I: integer;
  strcc: string;
begin
  adoquery1.open;
  advs1.RowCount := adoquery1.recordcount + 1;
  advs1.ColCount := 4;
  advs1.ColWidths[0] := 60;
  advs1.ColWidths[1] := 500;
  advs1.ColWidths[2] := 60;
  advs1.ColWidths[3] := 80;

  advs1.Cells[0, 0] := '题号';
  advs1.Cells[1, 0] := '题目';
  advs1.Cells[2, 0] := '是否大题';
  advs1.Cells[3, 0] := '是否打印';

  adoquery1.First;
  i := 0;
  while not adoquery1.eof do
  begin
    advs1.Cells[0, i + 1] := adoquery1.fieldbyname('id').AsString;
    advs1.Cells[1, i + 1] := adoquery1.fieldbyname('title').AsString;
    if (length(trim(adoquery1.fieldbyname('ans').AsString)) > 20)
      and (trim(adoquery1.fieldbyname('xans').AsString) = '') then
      advs1.Cells[2, i + 1] := '大题';
    i := i + 1;
    adoquery1.Next;
  end;

end;

procedure Tformdy.dy;
begin
  htmlname := gethtmlname;
  memo1.Lines.SaveToFile(htmlname);
  memo1.Visible := true;
end;

procedure Tformdy.FormCreate(Sender: TObject);
var
  MyFontStyle: TFontStyles;

  i: integer;
begin

  panel2.Left := -700;
  fontdialog1.font.size := 12;
  fontdialog1.font.Name := '楷体_GB2312';
  label1.Caption := '字体:' + inttostr(fontdialog1.Font.Size);
  checkbox2.Checked := mysys.isafterdy;
  checkbox1.Checked := true;
  checkbox3.Checked := true;
end;

procedure Tformdy.Button5Click(Sender: TObject);
begin
  fontdialog1.Execute;
  label1.Caption := '字体:8' + ' 粗体';
end;

procedure Tformdy.FontDialog1Close(Sender: TObject);
begin
  label1.Caption := '字体:' + inttostr(fontdialog1.Font.Size);
  if fsBold in fontdialog1.Font.Style then
    label1.Caption := label1.Caption + '     粗体'
  else
    label1.Caption := label1.Caption + '     正常粗';
end;

procedure Tformdy.onlydy;
begin
  if memo1.GetTextLen = 0 then
    exit;
  dy;
end;

procedure Tformdy.FormShow(Sender: TObject);
begin
  groupbox1.Visible := true;
  //self.Height := 567;
  button1.Caption := '打印选中记录';
  button2.Click;
end;

procedure Tformdy.CheckBox2Click(Sender: TObject);
begin
  mysys.isafterdy := checkbox2.Checked;
  saveParamtoFile(ExtractFilePath(Application.EXEName) + 'kjks.ini');
end;

procedure Tformdy.selectdy;
var
  i: integer;
  strcc: string;
begin

  memo1.Lines.Add('<html>');
  memo1.Lines.Add('<head>');
  memo1.Lines.Add('<body>');
  memo1.Lines.Add('  <style type="text/css">');
  memo1.Lines.Add('<!--');
  memo1.Lines.Add('.xy {  ');
  memo1.Lines.Add('	font-family: "楷体_GB2312";');
  memo1.Lines.Add('	font-size: 16px;');
  memo1.Lines.Add('');
  memo1.Lines.Add('}');
  memo1.Lines.Add('--> ');
  memo1.Lines.Add('</style>');
  memo1.Lines.Add('</head>    ');
  memo1.Lines.Add('<body class="xy">');
  //  memo1.lines.Add(mysys.tmtitle + '<br />');
    // memo1.Lines.Add('=======' + mysys.tmtitle + '=========');
  adoquery1.First;
  if mysys.isafterdy then
  begin //随题打印答案
    adoquery1.First;
    for i := 1 to advs1.rowcount do
    begin
      if trim(advs1.Cells[3, i]) = '√' then
      begin
        memo1.Lines.Add('<br/>');
        strcc := adoquery1.fieldbyname('title').AsString ;//+ '<br/>';
        strcc := stringreplace(strcc, '</br>', '<br/>', [rfReplaceAll,
          rfIgnoreCase]);
        memo1.Lines.Add(strcc);
        if checkbox3.Checked then
        begin
          strcc := adoquery1.fieldbyname('ans').AsString + '<br/>';
          strcc := stringreplace(strcc, '</br>', '<br/>', [rfReplaceAll,
            rfIgnoreCase]);
          memo1.Lines.Add(strcc);
        end;

        if trim(advs1.Cells[2, i]) = '大题' then
        begin
          memo1.Lines.Add('<br/>');

        end;
      end;
      adoquery1.Next;
    end;
  end
  else
  begin
    //后打印答案
    for i := 1 to advs1.rowcount do
    begin
      memo1.Lines.Add('<br/>');
      if trim(advs1.Cells[3, i]) = '√' then
      begin
        strcc := adoquery1.fieldbyname('title').AsString;// + '<br/>';
        strcc := stringreplace(strcc, '</br>', '<br/>', [rfReplaceAll,
          rfIgnoreCase]);
        memo1.Lines.Add(strcc);
        if trim(advs1.Cells[2, i]) = '大题' then
        begin
          memo1.Lines.Add('<br/>');
        end;
      end;
      adoquery1.Next;
    end;
    if checkbox3.Checked then
    begin
      adoquery1.First;
      memo1.lines.Add('==答案部分===');
      for i := 1 to advs1.rowcount do
      begin
        if trim(advs1.Cells[3, i]) = '√' then
        begin
          strcc := adoquery1.fieldbyname('ans').AsString ;//+ '<br/>';
          strcc := stringreplace(strcc, '</br>', '<br/>', [rfReplaceAll,
            rfIgnoreCase]);
          memo1.Lines.Add(strcc);
        end;
        if trim(advs1.Cells[2, i]) = '大题' then
        begin
          memo1.Lines.Add('<br/>');
        end;

        adoquery1.Next;
      end;
    end;
  end;
  memo1.Lines.Add('</body>');
  memo1.Lines.Add('<head>');
  htmlname := gethtmlname();
  memo1.Lines.SaveToFile(htmlname);

  if checkbox1.Checked then
    button4.Click
  else
    webbrowser1.Navigate(htmlname);
end;

procedure Tformdy.WebBrowser1NewWindow2(Sender: TObject;
  var ppDisp: IDispatch; var Cancel: WordBool);
begin
  WebBrowser1.Execwb(7, 1);
end;

procedure Tformdy.WebBrowser1NavigateComplete2(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  WebBrowser1.Execwb(7, 1);
end;

procedure Tformdy.Button4Click(Sender: TObject);
var
  V: Variant;
  Template, NewTemplate, DocumentType, Visible: OleVariant;
  itemIndex: OleVariant;
  fileName: Olevariant;
  NoPrompt, OriginalFormat: OleVariant;
  RouteDocument, SaveChanges: OleVariant;
  i: integer;
  strcc: string;
  fpage, pagea: olevariant;
  Indx: OleVariant;
  mmm, nnn, aaa: OleVariant;
  CM, CM1: OleVariant;
  OleWord: Variant;
  OleDoc: Variant;
  ModuleNm: string;
  PrevWindow: HWND;
begin
  FileName := getdocfilename();

  try

  except
  end;

  try
    FWord := CreateOleObject('Word.Application');
    FWord.Visible := false;
  except
    ShowMessage('创建word对象失败！');
    Exit;
  end;

  try
    fdoc := fword.documents.open(htmlname);
  except
    exit;
  end;

  FDoc.SaveAs(filename);
  fdoc.close;
  try
    fdoc := fword.documents.open(filename);
  except
    exit;
  end;
  fWord.DisplayAlerts := False;
  begin
    FWord.ActiveDocument.PageSetup.TopMargin := 1 / 0.035;
    FWord.ActiveDocument.PageSetup.BottomMargin := 2 / 0.035;
    FWord.ActiveDocument.PageSetup.LeftMargin := 1.5 / 0.035;
    FWord.ActiveDocument.PageSetup.RightMargin := 1 / 0.035;
    FWord.ActiveDocument.PageSetup.Orientation := 0;
    FWord.ActiveDocument.PageSetup.HeaderDistance := 1 / 0.035;
    FWord.ActiveDocument.PageSetup.FooterDistance := 1.5 / 0.035;
  end;
  fdoc.ActiveWindow.ActivePane.View.Type := wdPrintView;

  {
  // FDoc := FWord.Documents.Add;
         strcc := adoquery1.fieldbyname('ans').AsString + chr(13);
         strcc := stringreplace(strcc, '<br>', chr(13) + chr(10), [rfReplaceAll,
           rfIgnoreCase]);
         strcc := stringreplace(strcc, '</br>', chr(13) + chr(10), [rfReplaceAll
           , rfIgnoreCase]);
         FWord.Selection.TypeText(strcc);
         FWord.Selection.TypeParagraph;

   }
   //保存文档

  //------------------------

{  fpage := true;
  pagea := wdAlignPageNumberCenter;
  fWord.activedocument.sections.item(1).Footers.item(1).PageNumbers.Add(pagea,
    fpage);   }

  //---------
  mmm := wdLine;
  nnn := 1;
  aaa := wdFieldPage;
  fdoc.ActiveWindow.ActivePane.View.SeekView :=
    wdSeekCurrentPageHeader;
  fdoc.activewindow.Selection.Move(mmm, nnn);
  fdoc.activewindow.Selection.ParagraphFormat.Alignment :=
    wdAlignParagraphCenter;
  fdoc.activewindow.activepane.selection.insertafter(
    mysys.tmtitle + '     ');

  fdoc.activewindow.Selection.InsertAfter('第');
  mmm := wdCharacter;
  fdoc.activewindow.Selection.Move(mmm, nnn);
  fdoc.activewindow.Selection.Fields.Add(fdoc.activewindow.Selection.Range, aaa,
    mmm, nnn);
  aaa := wdFieldNumPages;
  fdoc.activewindow.Selection.InsertAfter('页/第');
  fdoc.activewindow.Selection.Move(mmm, nnn);
  fdoc.activewindow.Selection.Fields.Add(fdoc.activewindow.Selection.Range, aaa,
    mmm, nnn);
  fdoc.activewindow.Selection.InsertAfter('页');

  //结束编辑
  fdoc.ActiveWindow.ActivePane.View.SeekView := wdSeekMainDocument;
  //----------

  Indx := wdStyleHeader;
  FWord.Application.ActiveDocument.Styles.Item(Indx).ParagraphFormat.
    Borders.Item(wdBorderLeft).LineStyle := wdLineStyleNone;
  FWord.Application.ActiveDocument.Styles.Item(Indx).ParagraphFormat.borders.Item(wdBorderRight).LineStyle := wdLineStyleNone;
  FWord.Application.ActiveDocument.Styles.Item(Indx).ParagraphFormat.borders.Item(wdBorderTop).LineStyle := wdLineStyleNone;
  FWord.Application.ActiveDocument.Styles.Item(Indx).ParagraphFormat.borders.Item(wdBorderBottom).LineStyle := wdLineStyleNone;
  //-------------
  Indx := wdStyleHeader;
  begin
    FWord.Application.ActiveDocument.Styles.Item(Indx).ParagraphFormat.Borders.Item(wdBorderLeft).LineStyle := wdLineStyleNone;
    FWord.Application.ActiveDocument.Styles.Item(Indx).ParagraphFormat.Borders.Item(wdBorderRight).LineStyle := wdLineStyleNone;
    FWord.Application.ActiveDocument.Styles.Item(Indx).ParagraphFormat.Borders.Item(wdBorderTop).LineStyle := wdLineStyleNone;

    // 增加页眉下边框横线，设置其他边框横线以此类推
    FWord.Application.ActiveDocument.Styles.Item(Indx).ParagraphFormat.Borders.Item(wdBorderBottom).LineStyle := wdLineStyleSingle;
    FWord.Application.ActiveDocument.Styles.Item(Indx).ParagraphFormat.Borders.Item(wdBorderBottom).LineWidth := wdLineWidth050pt;
    FWord.Application.ActiveDocument.Styles.Item(Indx).ParagraphFormat.Borders.Item(wdBorderBottom).Color := wdColorBlue;
    //
  end;
  // fDoc.template.saved := false;
  FDoc.Save;

  FWord.Visible := true;

  //fword.Quit(WdDoNotSaveChanges);
//  FWord := Unassigned;

  MessageDlg('日志内容导出成功！保存为' + fileName, mtInformation, [mbOK], 0);
  //关闭窗体
end;

function Tformdy.getdocname(str: string): string;
var
  len1: integer;
begin
  result := '';
  len1 := pos('.', str);
  try
    if len1 > 0 then
      result := copy(str, 1, len1 - 1) + '.doc'
    else
      result := trim(str) + '.doc';
  except
  end;
end;

procedure Tformdy.Button6Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to adoquery1.RecordCount - 1 do
    if trim(advs1.Cells[2, i + 1]) = '大题' then
      advs1.Cells[3, i + 1] := '√'
end;

function Tformdy.getrightstr(str: string; n: integer): string;
var
  len1: integer;
begin
  //
  result := '';
  try
    len1 := length(str);
    result := copy(str, len1 - n + 1, n);
  except
    result := '';
  end;
end;

function Tformdy.GetSpecialFolderDir(const folderid: integer): string;
var
  pidl: pItemIDList;
  buffer: array[0..255] of char;
begin
  //取指定的文件夹项目表
  SHGetSpecialFolderLocation(application.Handle, folderid, pidl);
  SHGetPathFromIDList(pidl, buffer); //转换成文件系统的路径
  Result := strpas(buffer);
end;

function Tformdy.gethtmlname: string;
begin
  Randomize;
  result := ExtractFilePath(Application.EXEName) + getrightstr('00000000' +
    trim(inttostr(random(10000))), 7) + '.htm';
end;

function Tformdy.getdocfilename: string;
begin
  Randomize;
  result := ExtractFilePath(Application.EXEName) + 'ddy.doc'
    //   + getrightstr('00000000' +
//    trim(inttostr(random(10000))), 7) + '.htm';
end;

function Tformdy.FindProcessByFileName(FineName: string): Boolean;
var
  Snap: THandle;
  RB: Boolean;
  PE: TProcessEntry32;
  iProcessID: Integer;
  processHandle: THandle;
begin
  if Trim(ExtractFileName(FineName)) = '' then
    Exit;
  Result := False;
  Snap := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Snap = 0 then
    Exit;
  try
    PE.dwSize := SizeOf(TProcessEntry32);
    RB := Process32First(Snap, PE);
    while RB do
    begin
      if (PE.szExeFile = ExtractFileName(Trim(FineName))) then
      begin
        iProcessID := PE.th32ProcessID;
        if iProcessID <> 0 then
        begin
          {   Get   the   process   handle   }
          processHandle := OpenProcess(PROCESS_TERMINATE or
            PROCESS_QUERY_INFORMATION,
            False, iProcessID);
          if processHandle <> 0 then
          begin
            Result := True;
          end;
        end;
      end;
      PE.dwSize := SizeOf(TProcessEntry32);
      RB := Process32Next(snap, PE);
    end;
  finally
    CloseHandle(Snap);
  end;
end;
//aMs毫秒

procedure Tformdy.SysDelay(aMs: Longint);
var
  TickCount: Cardinal;
begin
  TickCount := GetTickCount;
  while GetTickCount - TickCount < aMs do
    Application.ProcessMessages;
end;

procedure Tformdy.Button7Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to adoquery1.RecordCount - 1 do
    if trim(advs1.Cells[2, i + 1]) = '大题' then
      advs1.Cells[3, i + 1] := ''
end;

end.

