unit addtm;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, DB, ADODB, Grids, DBGrids,
  AdvCombo, Lucombo, dblucomb, DBCtrls, perlregex, IdGlobal, StrUtils,
  Mask, ZcGridClasses, ZcUniClass, ZJGrid, ZcDataGrid, ShellAPI,
  ZcGridStyle, ZcCalcExpress, ZcFormulas, sDialogs, sBitBtn, ZcDBGrids,
  sLabel, sSpeedButton, ExtCtrls, sPanel, sPageControl,
  ExtDlgs, GridsEh, DBGridEh, sListBox; //  AdvMemo,
const
  TMMDB = 'cpatm.mdb';
  testMDB = 'testtm.mdb';

  START_ANSWER_MARK = -1;
  START_ZJ_MARK = -2; //章节开始标志
  START_TEXT_ONLY_MARK = 0;

type
  Code_KM_ZJ = record
    FILENAME: string;
    tmname: string;
    KM: string;
    ZJ: string;
  end;

type
  textfile_km_zj_code = class
  private
    str_filename_km_zj: string;
    akmzj_code: Code_KM_ZJ;
    FILENAME: string;
    procedure splitter_dmmc;
    procedure merge_dmmc();
    procedure setFILENAME(const Value: string);
    procedure Set_kmzj_code(const Value: Code_KM_ZJ);
    procedure DmToHtmlfile;
    procedure DMfromHTML;
  public
    constructor create();
    destructor DESTRORY();
    function current_km_zj_code: Code_KM_ZJ;
  published
    property AFILENAME: string read FILENAME write setFILENAME;
    property kmzj_code: Code_KM_ZJ read akmzj_code write Set_kmzj_code;
  end;

type
  mytm = record
    title: string;
    ans: string;
    sxh: integer;
    ising: boolean;
    filename: string;
    km: string;
    zj: string;
    tsname: string;
    tmtsid: integer;
    ts: Integer;
  end;

  taddtm = class
  private
    r: TPerlRegEx;
    qrytmp: tadoquery;
    IMPORT_TABLE: TADOTable;
    textlines, imglist, FILELIST: TStringS;
    TMCON: TADOConnection;
    atm: mytm;
    QRY_ZJ: TADOQUERY;
  private
    procedure openmdb();
    procedure cleartm();
    procedure From_ONE_HTMLFILE(htmfile: string);
    function MAINPATH: string;
    procedure CreateTable();
    procedure CloseTable();
    procedure ExecSQL(SQLTEXT: string);
    procedure OpenSQL(SQLTEXT: string);
    procedure format_TitleAndANS();
    procedure AnsToABCD();
    procedure TITLE_SPLITTERTO_TitleAndAns;
    function SbctoDbc(s: string): string;
    function getabc(strabc: string): string;
    function JPGCount(): LongInt;
    function html_jpg_list(afilename, str: string): string;
    procedure tmsaveok;
    procedure tmsavetodb();
    procedure tmsavetotmts();
    procedure tmupdatedb;
    function clearHTMLBZ(str1: string): string;
    function gettitlename(str: string): string;
    function getfilename(str: string): string;
    function isalpha(mystr: string): integer;
    function inctm(str: string): string;
    function getimgname(str: string): string;
    function getrightstr(str: string; n: integer): string;
    function getextname(str: string): string;
    function LastPos(SearchStr, Str: string): Integer;
    function textfromfile(afile: string): string;
    procedure WriteToTEST(ASTR: string);
    procedure WriteToTestBEGIN();
    procedure WriteToTestOPEN();
    procedure SendToZJDBF();
    procedure SendTokmDBF();
    function splitstring(src, dec: string): TStringList;
  published
    property AFILELIST: TStringS read FILELIST write FILELIST;
  public
    procedure From_ALL_HTMLFILE;
    function getLISTqry(): TADOQuery;
    constructor create();
    destructor Destroy();
  end;

implementation

{ taddtm }

function taddtm.getabc(strabc: string): string;
var
  stra, strm, strb, laststr: string;
  start: boolean;
  i, k: integer;
  xx: widestring;
  aa: string;
begin
  xx := 'abcdABCD ';
  result := '';
  stra := copy(trim(strabc), 1, 25);
  stra := stringReplace(stra, ' ', '', [rfReplaceAll]);
  stra := stringReplace(stra, '、', '', [rfReplaceAll]);
  aa := strm;
  i := 1;
  if pos('√', stra) > 0 then
  begin
    result := '√';
    exit;
  end;

  if pos('×', stra) > 0 then
  begin
    result := '×';
    exit;
  end;

  try
    laststr := '';
    start := false;

    k := 1;
    i := 1;
    while i <= 25 do
    begin
      strb := Copy(stra, i, 1);
      i := i + 1;
      if start then
      begin
        if pos(strb, 'abcdABCDeE') > 0 then
        begin
          laststr := laststr + strb;
          k := k + 1;
        end
        else
        begin

          result := laststr;
          exit;
        end;
      end;

      if not start then
        if pos(strb, 'abcdABCDEe  ') > 0 then
        begin
          start := true;
          laststr := laststr + strb;
          k := k + 1;
        end;
    end;

  except
  end;
  if length(laststr) < 1 then
  begin
    if pos('错', stra) > 0 then
    begin
      result := '×';
      exit;
    end;
    if pos('对', stra) > 0 then
    begin
      result := '√';
      exit;
    end;
  end;

  result := laststr;
end;

function taddtm.SbctoDbc(s: string): string;
var
  nlength, i: integer;
  str, ctmp, c1, c2: string;
  {
 在windows中，中文和全角字符都占两个字节，
 并且使用了ascii　chart  2  (codes  128 - 255 )。
全角字符的第一个字节总是被置为163，
 而第二个字节则是相同半角字符码加上128（不包括空格）。
 如半角a为65，则全角a则是163（第一个字节）、 193 （第二个字节， 128 + 65 ）。
 而对于中文来讲，它的第一个字节被置为大于163，（
 如 ' 阿 ' 为: 176   162 ）,我们可以在检测到中文时不进行转换。
}
begin
  nlength := length(s);
  if (nlength = 0) then
    exit;
  str := '';
  setlength(ctmp, nlength + 1);
  ctmp := s;
  i := 1;
  while (i <= nlength) do
  begin
    c1 := ctmp[i];
    c2 := ctmp[i + 1];
    if (c1 = #163) then // 如果是全角字符
    begin
      str := str + chr(ord(c2[1]) - 128);
      inc(i, 2);
      continue;
    end;
    if (c1 > #163) then // 如果是汉字
    begin
      str := str + c1;
      str := str + c2;
      inc(i, 2);
      continue;
    end;
    if (c1 = #161) and (c2 = #161) then // 如果是全角空格
    begin
      str := str + '   ';
      inc(i, 2);
      continue;
    end;
    str := str + c1;
    inc(i);
  end;
  result := str;
end;

procedure taddtm.AnsToABCD;
var
  strtt: string;
  i: integer;
  strcc: tstringstream;
  pos1, len1: integer;
  StrTitle: string;
  lastid: integer;
  r: TPerlRegEx;
  str2, StrAns, STRTMP, STRX: string;
  len2, pos2: integer;
begin
  //
  r := TPerlRegEx.Create(nil);

  import_table.Open;

  i := 1;
  import_table.First;
  while not import_table.eof do
  begin

    TITLE_SPLITTERTO_TitleAndAns;

    if ((trim(import_table.fieldbyname('ans').AsString) <> '') and
      (length(trim(import_table.fieldbyname('ans').AsString)) > 0)) then
    begin

      strtt := copy(import_table.fieldbyname('ans').AsString, 1, 80);

      if pos('<table', strtt) > 0 then
        strtt := copy(strtt, 1, pos('<table', strtt) - 1);
      if pos('解析', strtt) > 0 then
        strtt := copy(strtt, 1, pos('解析', strtt) - 1);

      strtt := StringReplace(strtt, ' ', '', [rfReplaceAll, rfIgnoreCase]);
      //    showmessage(strtt);
      strtt := StringReplace(strtt, '【正确答案】', '', [rfReplaceAll,
        rfIgnoreCase]);
      strtt := StringReplace(strtt, '正确', '', [rfReplaceAll,
        rfIgnoreCase]);
      strtt := StringReplace(strtt, '【', '', [rfReplaceAll,
        rfIgnoreCase]);
      strtt := StringReplace(strtt, '】', '', [rfReplaceAll,
        rfIgnoreCase]);

      strtt := StringReplace(strtt, '加入我的收藏夹', '', [rfReplaceAll,
        rfIgnoreCase]);
      strtt := StringReplace(strtt, '<br>', '', [rfReplaceAll,
        rfIgnoreCase]);
      strtt := StringReplace(strtt, '</br>', '', [rfReplaceAll,
        rfIgnoreCase]);
      strtt := StringReplace(strtt, '&nbsp', '', [rfReplaceAll,
        rfIgnoreCase]);
      strtt := StringReplace(strtt, '&nbsp', '', [rfReplaceAll,
        rfIgnoreCase]);
      strtt := StringReplace(strtt, '<br', '', [rfReplaceAll,
        rfIgnoreCase]);
      strtt := StringReplace(strtt, ',', '', [rfReplaceAll, rfIgnoreCase]);
      strtt := SbctoDbc(strtt);

      import_table.edit;
      strtt := trim(uppercase(getabc(strtt)));
      import_table.fieldbyname('xans').AsString := strtt;
      import_table.post;

      //============
      StrTitle := trim(import_table.fieldbyname('title').asstring);
      StrAns := trim(import_table.fieldbyname('ANS').asstring);

      if trim(import_table.fieldbyname('xans').asstring) = '' then
      begin
        r.Subject := StrTitle; //这是要替换的源字符串
        r.RegEx := '（[一二三四五六七八九十123456789]）';
        //这是表达式, 在这里是准备替换掉的子串
        R.Match;
        while r.FOUNDMatch do
        begin
          STRTMP := r.MatchedExpression;
          STRX := STRTMP;
          STRTMP := STRINGREPLACE(STRTMP, '（', '', []);
          STRTMP := STRINGREPLACE(STRTMP, '）', '', []);

          r.RegEx := STRX;
          r.Replacement := '</BR>' + '(' + STRTMP + ')'; //要替换成的新串
          r.ReplaceAll; //执行全部替换

          r.RegEx := '（[一二三四五六七八九十123456789]?）';
          //这是表达式, 在这里是准备替换掉的子串
          R.Match;
        end;
        StrTitle := R.Subject;
      end;

      pos1 := pos('=======', StrTitle);
      if pos1 > 0 then
        StrTitle := copy(StrTitle, 1, pos1 - 1);

      StrTitle := stringreplace(StrTitle,
        '题目位置：2009年"梦想成真"系列辅导书《应试指南·税法》（老考生版） >> 第',
        '', [rfIgnoreCase]);
      StrTitle := stringreplace(StrTitle, 'A.', '</BR>A.', [rfIgnoreCase]);
      StrTitle := stringreplace(StrTitle, 'B.', '</BR>B.', [rfIgnoreCase]);
      StrTitle := stringreplace(StrTitle, 'C.', '</BR>C.', [rfIgnoreCase]);
      StrTitle := stringreplace(StrTitle, 'D.', '</BR>D.', [rfIgnoreCase]);
      StrTitle := stringreplace(StrTitle, 'A．', '</BR>A.', [rfIgnoreCase]);
      StrTitle := stringreplace(StrTitle, 'B．', '</BR>B.', [rfIgnoreCase]);
      StrTitle := stringreplace(StrTitle, 'C．', '</BR>C.', [rfIgnoreCase]);
      StrTitle := stringreplace(StrTitle, 'D．', '</BR>D.', [rfIgnoreCase]);
      StrTitle := stringreplace(StrTitle, 'A、', '</BR>A.', [rfIgnoreCase]);
      StrTitle := stringreplace(StrTitle, 'B、', '</BR>B.', [rfIgnoreCase]);
      StrTitle := stringreplace(StrTitle, 'C、', '</BR>C.', [rfIgnoreCase]);
      StrTitle := stringreplace(StrTitle, 'D、', '</BR>D.', [rfIgnoreCase]);

      StrTitle := stringreplace(StrTitle, '<BR>', '</BR>', [rfIgnoreCase,
        rfReplaceAll]);
      StrTitle := stringreplace(StrTitle, '</BR></BR>', '</BR>', [rfIgnoreCase,
        rfReplaceAll]);

      StrTitle := stringreplace(StrTitle, '二、多项选择题', '', [rfIgnoreCase]);
      StrTitle := stringreplace(StrTitle, '第二大题多项选择题', '',
        [rfIgnoreCase]);
      StrTitle := stringreplace(StrTitle, '第三大题判断题', '', [rfIgnoreCase]);
      StrTitle := stringreplace(StrTitle, '三、判断题', '', [rfIgnoreCase]);
      StrTitle := stringreplace(StrTitle, '四、计算题', '', [rfIgnoreCase]);
      StrTitle := stringreplace(StrTitle, '第四大题计算题', '', [rfIgnoreCase]);
      StrTitle := stringreplace(StrTitle, '===', '', [rfIgnoreCase]);

      StrTitle := stringreplace(StrTitle, '第二大题', '', [rfIgnoreCase]);
      StrTitle := stringreplace(StrTitle, '第三大题', '', [rfIgnoreCase]);
      StrTitle := stringreplace(StrTitle, '第四大题', '', [rfIgnoreCase]);

      StrTitle := stringreplace(StrTitle, '判断题', '', [rfIgnoreCase]);
      StrTitle := stringreplace(StrTitle, '多项选择题', '', [rfIgnoreCase]);
      StrTitle := stringreplace(StrTitle, '计算题', '', [rfIgnoreCase]);

      StrAns := stringreplace(StrAns, '<BR>', '</BR>', [rfIgnoreCase,
        rfReplaceAll]);
      StrAns := stringreplace(StrAns, '</BR></BR>', '</BR>', [rfIgnoreCase,
        rfReplaceAll]);
      StrAns := stringreplace(StrAns, '<p></BR>', '</BR>', [rfIgnoreCase,
        rfReplaceAll]);

      StrAns := stringreplace(StrAns, '二、多项选择题', '', [rfIgnoreCase]);
      StrAns := stringreplace(StrAns, '第二大题多项选择题', '', [rfIgnoreCase]);
      StrAns := stringreplace(StrAns, '第三大题判断题', '', [rfIgnoreCase]);
      StrAns := stringreplace(StrAns, '三、判断题', '', [rfIgnoreCase]);
      StrAns := stringreplace(StrAns, '四、计算题', '', [rfIgnoreCase]);
      StrAns := stringreplace(StrAns, '第四大题计算题', '', [rfIgnoreCase]);
      StrAns := stringreplace(StrAns, '===', '', [rfIgnoreCase]);

      StrAns := stringreplace(StrAns, '第二大题', '', [rfIgnoreCase]);
      StrAns := stringreplace(StrAns, '第三大题', '', [rfIgnoreCase]);
      StrAns := stringreplace(StrAns, '第四大题', '', [rfIgnoreCase]);

      StrAns := stringreplace(StrAns, '判断题', '', [rfIgnoreCase]);
      StrAns := stringreplace(StrAns, '多项选择题', '', [rfIgnoreCase]);
      StrAns := stringreplace(StrAns, '计算题', '', [rfIgnoreCase]);

      //将答案编号后的安符全去掉
      len1 := pos('【答疑编号', StrAns);
      if len1 > 0 then
        StrAns := copy(StrAns, 1, len1 - 1);

      //将括号)换成）并换行
      r.Subject := StrAns; //这是要替换的源字符串
      r.RegEx := '（[一二三四五六七八九十123456789]）';
      //这是表达式, 在这里是准备替换掉的子串
      R.Match;
      while r.FOUNDMatch do
      begin
        STRTMP := r.MatchedExpression;
        STRX := STRTMP;

        STRTMP := STRINGREPLACE(STRTMP, '（', '', []);
        STRTMP := STRINGREPLACE(STRTMP, '）', '', []);

        r.RegEx := STRX;
        r.Replacement := '</br>' + '(' + STRTMP + ')'; //要替换成的新串
        r.ReplaceAll; //执行全部替换

        r.RegEx := '（[一二三四五六七八九十123456789]?）';
        //这是表达式, 在这里是准备替换掉的子串
        R.Match;
      end;

      //将答案解析换成另外几个字
      StrAns := R.Subject;
      StrAns := stringreplace(StrAns, '【答案解析】', '</BR>(分析) ',
        [rfIgnoreCase]);
      StrAns := stringreplace(StrAns, '【正确答案】', '</BR>(答案) ',
        [rfIgnoreCase]);
      StrAns := stringreplace(StrAns, '解析', '</BR>(分析) ', [rfIgnoreCase]);

      if LENGTH(StrTitle) > 0 then
      begin
        try
          import_table.Edit;
          import_table.fieldbyname('TITLE').AsString := StrTitle;
          import_table.fieldbyname('ans').AsString := StrAns;
          import_table.Post;
        except
        end;
      end;
    end;

    import_table.next;
    i := I + 1;
  end;
end;

procedure taddtm.cleartm;
begin
  //
  ExecSQL('delete  from tm');
  ExecSQL('delete  from tmts');
end;

procedure taddtm.CloseTable;
begin
  try
    qrytmp.Close;
    qrytmp.Free;
    QRYTMP := nil;
  except
    ShowMessage('关闭QRYTMP时出错！请开发人员检查 ');
  end;

  try
    IMPORT_TABLE.Close;
    IMPORT_TABLE.Free;
    IMPORT_TABLE := nil;
  except
    ShowMessage('关闭IMPORT_TABLE时出错！请开发人员检查 ');
  end;

  try
    QRY_ZJ.Close;
    QRY_ZJ.Free;
    QRY_ZJ := nil;
  except
    ShowMessage('关闭IMPORT_TABLE时出错！请开发人员检查 ');
  end;

  try
    TMCON.Close;
    TMCON.Free;
    TMCON := nil;
  except
    ShowMessage('关闭tmcon时出错！请开发人员检查 ');
  end;
end;

constructor taddtm.create;
begin
  //
  openmdb;

  CreateTable;
  imglist := TStringList.Create;
  FILELIST := TStringList.Create;
  textlines := TStringList.Create;

end;

procedure taddtm.CreateTable;
begin
  //
  try
    qrytmp := TADOQuery.Create(nil);
    qrytmp.Connection := TMCON;
  except
  end;

  try
    IMPORT_TABLE := TADOTable.Create(nil);
    IMPORT_TABLE.Connection := TMCON;
  except
  end;
  try
    QRY_ZJ := TADOQUERY.CREATE(nil);
    QRY_ZJ.Connection := TMCON;
  except
  end;
end;

procedure taddtm.ExecSQL(SQLTEXT: string);
begin
  try
    qrytmp.Close;
    qrytmp.SQL.Clear;
    qrytmp.SQL.Add(SQLTEXT);
    qrytmp.ExecSQL;
  except
    ShowMessage('在执行下列SQL查询时失败，请开发人员检查！');
    Exit;
  end;

end;

procedure taddtm.format_TitleAndANS;
var
  i: integer;
  str1: string;
  r: TPerlRegEx;
begin
  //
  r := TPerlRegEx.Create(nil);

  import_table.Open;
  import_table.first;
  i := 1;
  while not import_table.eof do
  begin
    import_table.Edit;
    //==========  处理标题
    str1 := trim(import_table.fieldbyname('title').asstring);
    str1 := stringreplace(str1, '<br>', '<BR>', [rfIgnoreCase,
      rfReplaceAll]);
    str1 := stringreplace(str1, '&nbsp;', '', [rfIgnoreCase,
      rfReplaceAll]);
    str1 := stringreplace(str1, '& nbsp;', '', [rfIgnoreCase,
      rfReplaceAll]);
    str1 := stringreplace(str1, 'nbsp;nbsp;', 'nbsp;', [rfIgnoreCase,
      rfReplaceAll]);
    str1 := stringreplace(str1, #13#10, '', [rfIgnoreCase,
      rfReplaceAll]);
    str1 := stringreplace(str1, #10#13, '', [rfIgnoreCase,
      rfReplaceAll]);
    str1 := stringreplace(str1, #10, '', [rfIgnoreCase,
      rfReplaceAll]);
    str1 := stringreplace(str1, #13, '', [rfIgnoreCase,
      rfReplaceAll]);
    str1 := stringreplace(str1, '<BR/>', '</BR>', [rfIgnoreCase,
      rfReplaceAll]);
    str1 := stringreplace(str1, '</BR> ', '</BR>', [rfIgnoreCase,
      rfReplaceAll]);
    str1 := stringreplace(str1, '</BR> ' + chr(13), '</BR>', [rfIgnoreCase,
      rfReplaceAll]);
    str1 := stringreplace(str1, '</BR> ', '</BR>', [rfIgnoreCase,
      rfReplaceAll]);
    str1 := stringreplace(str1, '】<BR/>', '】', [rfIgnoreCase,
      rfReplaceAll]);
    str1 := stringreplace(str1, '】</BR>', '】', [rfIgnoreCase,
      rfReplaceAll]);
    str1 := stringreplace(str1, '】 </BR>', '】', [rfIgnoreCase,
      rfReplaceAll]);
    str1 := stringreplace(str1, '】 <BR/>', '】', [rfIgnoreCase,
      rfReplaceAll]);
    STR1 := stringreplace(str1, '</BR></BR>', '</BR>', [rfIgnoreCase,
      rfReplaceAll]);
    STR1 := stringreplace(str1, '</BR> </BR>', '</BR>', [rfIgnoreCase,
      rfReplaceAll]);
    STR1 := stringreplace(str1, '</BR> </BR>', '</BR>', [rfIgnoreCase,
      rfReplaceAll]);

    STR1 := stringreplace(str1, '</BR>' + chr(10) + chr(13) + '</BR>', '</BR>',
      [rfIgnoreCase, rfReplaceAll]);

    STR1 := stringreplace(str1, '</BR>' + chr(13) + chr(10) + '</BR>', '</BR>',
      [rfIgnoreCase, rfReplaceAll]);

    STR1 := stringreplace(str1, '<BR/><BR/>', '<BR/>',
      [rfIgnoreCase, rfReplaceAll]);

    STR1 := stringreplace(str1, '<BR/><BR/>', '<BR/>',
      [rfIgnoreCase, rfReplaceAll]);

    import_table.fieldbyname('TITLE').AsString := str1;

    //==========  处理答案
    str1 := trim(import_table.fieldbyname('ans').asstring);

    str1 := stringreplace(str1, '&nbsp;', '', [rfIgnoreCase,
      rfReplaceAll]);
    str1 := stringreplace(str1, '& nbsp;', '', [rfIgnoreCase,
      rfReplaceAll]);
    str1 := stringreplace(str1, 'nbsp;nbsp;', 'nbsp;', [rfIgnoreCase,
      rfReplaceAll]);

    str1 := stringreplace(str1, #13#10, '', [rfIgnoreCase,
      rfReplaceAll]);
    str1 := stringreplace(str1, #10#13, '', [rfIgnoreCase,
      rfReplaceAll]);
    str1 := stringreplace(str1, #10, '', [rfIgnoreCase,
      rfReplaceAll]);
    str1 := stringreplace(str1, #13, '', [rfIgnoreCase,
      rfReplaceAll]);

    STR1 := stringreplace(str1, '<BR>', '<BR/>', [rfIgnoreCase,
      rfReplaceAll]);
    STR1 := stringreplace(str1, '</BR>', '<BR/>', [rfIgnoreCase,
      rfReplaceAll]);
    str1 := stringreplace(str1, '】<BR/>', '】', [rfIgnoreCase,
      rfReplaceAll]);

    STR1 := stringreplace(str1, '</BR>' + chr(10) + chr(13) + '</BR>', '</BR>',
      [rfIgnoreCase, rfReplaceAll]);

    STR1 := stringreplace(str1, '</BR>' + chr(13) + chr(10) + '</BR>', '</BR>',
      [rfIgnoreCase, rfReplaceAll]);

    STR1 := stringreplace(str1, '<BR/><BR/>', '<BR/>',
      [rfIgnoreCase, rfReplaceAll]);

    STR1 := stringreplace(str1, '<BR/><BR/>', '<BR/>',
      [rfIgnoreCase, rfReplaceAll]);

    import_table.fieldbyname('ans').AsString := str1;
    import_table.Post;

    import_table.Next;
  end;

end;

procedure taddtm.From_ALL_HTMLFILE;
var
  r: TPerlRegEx;
  strall, str2: string;
  i: integer;
  str_reg, str, yy: string;
  LEN1: INTEGER;
  strf: tstringstream;
  imglist: tstrings;
  k: integer;
  lastwjm: string;
  strcc: tstringstream;
  ifileno, currentrecord: integer;
  ausername, apassword, filename: string;
  sourcebz: Boolean;

begin
  cleartm;
  sourcebz := false;
  atm.km := ' ';
  atm.zj := ' ';

  for ifileno := 0 to FILELIST.Count - 1 do
  begin

    lastwjm := FILELIST[ifileno];

    strall := textfromfile(FILELIST[ifileno]);
    str := lowercase(copy(strall, LEN1, LENGTH(STRALL) - LEN1));

    str := clearhtmlbz(str);

    //==============================================================================
    // 更改HTM文件中的图片链接，并将图片复制到相应地方
    //==============================================================================

    if Pos('test.mdb', TMCON.ConnectionString) < 0 then
    begin
      html_jpg_list(FILELIST[ifileno], str);
    end;

    //==============================================================================
   // 更改HTM文件中的图片链接，并将图片复制到相应地方   结束
   //==============================================================================

    try
      From_ONE_HTMLFILE(lastwjm);
    except
      showmessage(lastwjm + '出错！');
      exit;
    end;

  end;

  import_table.close;
  import_table.TableName := 'tm';
  import_table.open;
  if Pos('test.mdb', TMCON.ConnectionString) > 0 then
  begin
    import_table.First;
    while not import_table.Eof do
    begin

      if Copy(Trim(import_table.fieldbyname('title').AsString), 3, 1) <> '+'
        then
        if Copy(Trim(import_table.fieldbyname('title').AsString), 1, 4) <>
          Copy(Trim(import_table.fieldbyname('ans').AsString), 1, 4) then
        begin
          import_table.Edit;
          import_table.FieldByName('myans').AsString := '不对';
          import_table.Post;
        end;
      import_table.Next;
    end;
  end;

  anstoABCD;
  format_TitleAndANS;
  format_TitleAndANS;

  import_table.Close;
  import_table.Open;

  qrytmp.Close;
  qrytmp.sql.clear;
  qrytmp.SQL.Add('delete from tm where sxh=1');
  qrytmp.ExecSQL;

  ShowMessage('已输入数据' + inttostr(import_table.RecordCount));

end;

procedure taddtm.from_ONE_HTMLFILE(htmfile: string);
var
  str, lastrow, startstr, row, selectstr: string;
  StartMark: integer;
  AnswerMark: boolean;
  i, ordernum, j: integer;
  isintable: boolean;
  onesl: integer;
  // order1, order2: integer;
  atmts: integer;
  zjcount: integer; //章节号      计数
  title, zjid, km: string;

  acode: textfile_km_zj_code;

begin
  tmcon.BeginTrans;

  acode := textfile_km_zj_code.create;
  acode.AFILENAME := htmfile;

  atm.tsname := acode.akmzj_code.tmname;
  atm.km := acode.akmzj_code.KM;
  atm.zj := acode.akmzj_code.zj;

  str := textfromfile(htmfile);
  lastrow := '';
  i := 0;

  while trim(textlines[i]) = '' do
    i := i + 1;
  atm.tsname := gettitlename(Trim(textlines[i]));
  atm.filename := htmfile;
  tmsavetotmts;

  selectstr := '';
  I := 0;
  AnswerMark := false;
  ordernum := 1;
  isintable := false;
  zjcount := 1;
  while i <= textlines.Count - 1 do
  begin

    row := clearHTMLBZ(textlines[i]);
    startstr := copy(trim(row), 0, 10);
    try
      StartMark := isalpha(startstr);
    except
      showmessage(startstr);
    end;

    if StartMark = START_ANSWER_MARK then
    begin
      atm.sxh := ordernum;
      atm.title := selectstr;
      tmsavetodb;
      selectstr := row + chr(13);
      AnswerMark := true; //开始答案的标记
      i := i + 1;
      row := textlines[i];
      startstr := copy(trim(row), 0, 10);
      StartMark := isalpha(startstr);
      ordernum := 1;
    end;

    if pos('<table', trim(row)) > 0 then
      isintable := true;
    if pos('</table', trim(row)) > 0 then
      isintable := false;

    if isintable then
      StartMark := START_TEXT_ONLY_MARK
    else
    begin
      startstr := copy(trim(row), 0, 10);
      StartMark := isalpha(startstr);
      if StartMark = 1 then
        onesl := onesl + 1;
    end;

    //如果不是数字开头，则只增加行数,是一般行则增加SELECTSTR中去
    if (StartMark = START_TEXT_ONLY_MARK) then
    begin
      if (Length(trim(row)) > 8) then
        selectstr := selectstr + row + chr(13)
      else
        selectstr := selectstr + row;
    end;

    if (StartMark > 0) or (i = textlines.Count - 1) then
      //   //如果是数字开头     或者最后一行数据
    begin
      if not AnswerMark then //页面题目部分
      begin
        atm.sxh := ordernum;
        atm.title := selectstr;
        tmsavetodb;
      end
      else
      begin //答案部分
        atm.ans := selectstr;
        atm.sxh := ordernum;
        tmupdatedb;
      end;
      selectstr := row + chr(13);
      ordernum := ordernum + 1;
    end;

    i := i + 1;
  end;

  TMCON.CommitTrans;
  //  ShowMessage('ok');

end;

function taddtm.MAINPATH: string;
begin
  try
    RESULT := ExtractFilePath(Application.ExeName);
  except
    RESULT := '';
  end;
end;

procedure taddtm.openmdb;
var
  AUSERNAME, APASSWORD: string;
begin
  try
    ausername := 'admin';
    apassword := '690414710529cpa';
    tmcon := TADOConnection.Create(nil);
    TMCON.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;' +
      'User ID=' + AUserName + ';' +
      'Jet OLEDB:Database Password=' + APassword + ';' +
      'Data Source=' + MAINPATH + TMMDB + ';' +
      'Mode=ReadWrite;' +
      'Extended Properties="";';
    TMCON.LoginPrompt := false;
    TMCON.Connected := true;
  except
  end;
end;

procedure taddtm.OpenSQL(SQLTEXT: string);
begin
  try
    qrytmp.Close;
    qrytmp.SQL.Clear;
    qrytmp.SQL.Add(SQLTEXT);
    qrytmp.open;
  except
    ShowMessage('在打开下列SQL查询时失败，请开发人员检查！');
    Exit;
  end;
end;

procedure taddtm.TITLE_SPLITTERTO_TitleAndAns;
var
  STRTITLEall: string;
  midpos, titlelen: integer;
begin
  if (pos('答案', import_table.fieldbyname('title').AsString) > 0)
    and (length(trim(import_table.fieldbyname('ans').AsString)) < 1) then
  begin
    STRTITLEall := import_table.fieldbyname('title').AsString;
    midpos := pos('答案', STRTITLEall);
    titlelen := length(STRTITLEall);

    import_table.edit;
    import_table.fieldbyname('title').AsString := copy(STRTITLEall, 1, midpos -
      1);
    import_table.fieldbyname('ans').AsString := copy(STRTITLEall, midpos,
      titlelen - midpos + 1);
    import_table.post;
  end;
  //
end;

destructor taddtm.Destroy;
begin
  CloseTable;
end;

procedure taddtm.tmsaveok;
begin

  tmcon.CommitTrans;
end;

procedure taddtm.tmsavetodb;
begin
  qrytmp.Close;
  qrytmp.SQL.Clear;
  qrytmp.SQL.Add('insert into tm(title,sxh,tmts)');
  qrytmp.SQL.Add('values(:title,:sxh,:tmts)');
  qrytmp.Parameters.ParamByName('title').Value := atm.title;
  qrytmp.Parameters.ParamByName('sxh').Value := atm.sxh;
  qrytmp.Parameters.ParamByName('tmts').Value := atm.ts;
  qrytmp.ExecSQL;
end;

procedure taddtm.tmsavetotmts;
begin
  try
    if not FileExists(atm.filename) then
      exit;
    qrytmp.close;
    qrytmp.SQL.Clear;
    qrytmp.SQL.Add('select max(ts) as tmtsid from tmts');
    qrytmp.open;
    if qrytmp.RecordCount > 0 then
      if trim(qrytmp.fieldbyname('tmtsid').asstring) <> '' then
        atm.tmtsid := qrytmp.fieldbyname('tmtsid').asinteger + 1
      else
        atm.tmtsid := 1;

    qrytmp.Close;
    qrytmp.SQL.Clear;
    qrytmp.SQL.Add('insert into tmts(ID,name,km,zjid,filename,sj)');
    qrytmp.SQL.Add('values(:id,:name,:km,:zjid,:filename,:sj)'); //  :id,
    qrytmp.Parameters.ParamByName('id').Value := atm.tmtsid;
    qrytmp.Parameters.ParamByName('name').Value := atm.filename;
    qrytmp.Parameters.ParamByName('km').Value := atm.km; //edtkm.atext;
    qrytmp.Parameters.ParamByName('zjid').Value := atm.zj; //edtzj.atfext;
    qrytmp.Parameters.ParamByName('filename').Value := atm.tsname;
    // atm.filename;
    qrytmp.Parameters.ParamByName('sj').Value := now; //edtzj.atext;
    qrytmp.ExecSQL;

    qrytmp.close;
    qrytmp.SQL.Clear;
    qrytmp.SQL.Add('select ts   from tmts  where id=:id');
    qrytmp.Parameters.ParamByName('id').Value := atm.tmtsid;
    qrytmp.open;

    if qrytmp.RecordCount > 0 then
      atm.ts := qrytmp.fieldbyname('ts').asinteger;

  except
  end;
end;

procedure taddtm.tmupdatedb;
begin
  qrytmp.Close;
  qrytmp.SQL.Clear;
  qrytmp.SQL.Add('update tm set ans=:ans');
  qrytmp.SQL.Add('where sxh=:sxh and tmts=:tmts');
  qrytmp.Parameters.ParamByName('ans').Value := atm.ans;
  qrytmp.Parameters.ParamByName('sxh').Value := atm.sxh;
  qrytmp.Parameters.ParamByName('tmts').Value := atm.ts;
  qrytmp.ExecSQL;
end;

function taddtm.JPGCount: LongInt;
begin
  result := 1;
  try
    OpenSQL('select * from bmpsl');
    result := qrytmp.fieldbyname('bmpcount').AsInteger;
  except
  end;
end;

function taddtm.html_jpg_list(afilename, str: string): string;
var
  str2: string;
  i: integer;
  k: LongInt;
begin
  k := JPGCount;

  r := TPerlRegEx.Create(nil);
  imglist := tstringlist.create();

  r.Subject := str;
  r.RegEx := '<img([\s\S]+?)>';
  r.Match;

  imglist.Clear;
  while r.FoundMatch do
  begin
    str2 := r.SubExpressions[1];
    imglist.Add(getimgname(str2));
    r.MatchAgain;
  end;
  for i := 0 to imglist.Count - 1 do
  begin
    str := r.Subject;
    r.Subject := str; //这是要替换的源字符串
    r.RegEx := imglist[i]; //这是表达式, 在这里是准备替换掉的子串
    str2 := getrightstr('0000000' + trim(inttostr(k)), 7) + '.' +
      getextname(imglist[i]);
    r.Replacement := 'img\\' + str2; //要替换成的新串
    r.ReplaceAll; //执行全部替换
    try
      copyfileto(extractfilepath(afilename) + imglist[i],
        extractfilepath(application.exename) + 'img\' +
        str2);
    except
    end;
    str := r.Subject;
    imglist.Add(str2);
    k := k + 1;
  end;
  str := r.subject;

  qrytmp.Close;
  qrytmp.SQL.Clear;
  qrytmp.SQL.Add('update  bmpsl set bmpcount=:bmpsl where id=1');
  qrytmp.Parameters.ParamByName('bmpsl').Value := k + 1;
  qrytmp.execsql;
end;

function taddtm.clearHTMLBZ(str1: string): string;
var
  r: TPerlRegEx;
  str: string;
begin
  r := TPerlRegEx.Create(nil);
  r.Subject := str1; //这是要替换的源字符串
  r.RegEx := '<td'; //这是表达式, 在这里是准备替换掉的子串
  r.Replacement := '!!td'; //要替换成的新串
  r.ReplaceAll; //执行全部替换

  str := r.Subject;
  r.Subject := str; //这是要替换的源字符串
  r.RegEx := '<tr'; //这是表达式, 在这里是准备替换掉的子串
  r.Replacement := '!!tr'; //要替换成的新串
  r.ReplaceAll; //执行全部替换
  str := r.Subject;

  r.Subject := str; //这是要替换的源字符串
  r.RegEx := '<table'; //这是表达式, 在这里是准备替换掉的子串
  r.Replacement := '!!table'; //要替换成的新串
  r.ReplaceAll; //执行全部替换
  str := r.Subject;

  r.Subject := str; //这是要替换的源字符串
  r.RegEx := '<img'; //这是表达式, 在这里是准备替换掉的子串
  r.Replacement := '!!img'; //要替换成的新串
  r.ReplaceAll; //执行全部替换
  str := r.Subject;

  r.Subject := str; //这是要替换的源字符串
  r.RegEx := '<br'; //这是表达式, 在这里是准备替换掉的子串
  r.Replacement := '!!br'; //要替换成的新串
  r.ReplaceAll; //执行全部替换
  str := r.Subject;

  r.Subject := str; //这是要替换的源字符串
  r.RegEx := '</p'; //这是表达式, 在这里是准备替换掉的子串
  r.Replacement := '!!br'; //要替换成的新串
  r.ReplaceAll; //执行全部替换
  str := r.Subject;
  //=============
  r.Subject := str; //这是要替换的源字符串
  r.RegEx := '</td'; //这是表达式, 在这里是准备替换掉的子串
  r.Replacement := '!!/td'; //要替换成的新串
  r.ReplaceAll; //执行全部替换

  str := r.Subject;
  r.Subject := str; //这是要替换的源字符串
  r.RegEx := '</tr'; //这是表达式, 在这里是准备替换掉的子串
  r.Replacement := '!!/tr'; //要替换成的新串
  r.ReplaceAll; //执行全部替换
  str := r.Subject;

  r.Subject := str; //这是要替换的源字符串
  r.RegEx := '</table'; //这是表达式, 在这里是准备替换掉的子串
  r.Replacement := '!!/table'; //要替换成的新串
  r.ReplaceAll; //执行全部替换
  str := r.Subject;

  r.Subject := str; //这是要替换的源字符串
  r.RegEx := 'topsage.com'; //这是表达式, 在这里是准备替换掉的子串
  r.Replacement := '         '; //要替换成的新串
  r.ReplaceAll; //执行全部替换
  str := r.Subject;

  r.Subject := str; //这是要替换的源字符串
  r.RegEx := 'topsage'; //这是表达式, 在这里是准备替换掉的子串
  r.Replacement := '         '; //要替换成的新串
  r.ReplaceAll; //执行全部替换
  str := r.Subject;
  //========

  r.Subject := str; //这是要替换的源字符串
  r.RegEx := '<v:imagedata'; //这是表达式, 在这里是准备替换掉的子串
  r.Replacement := '!!v:imagedata'; //要替换成的新串
  r.ReplaceAll; //执行全部替换

  str := r.Subject;
  r.Subject := str; //这是要替换的源字符串
  r.RegEx := '<([\s\S]+?)>';
  r.Replacement := ''; //要替换成的新串
  r.ReplaceAll; //执行全部替换
  str := r.Subject;

  r.Subject := str; //这是要替换的源字符串
  r.RegEx := '!!td'; //这是表达式, 在这里是准备替换掉的子串
  r.Replacement := '<td'; //要替换成的新串
  r.ReplaceAll; //执行全部替换

  str := r.Subject;
  r.Subject := str; //这是要替换的源字符串
  r.RegEx := '!!tr'; //这是表达式, 在这里是准备替换掉的子串
  r.Replacement := '<tr'; //要替换成的新串
  r.ReplaceAll; //执行全部替换
  str := r.Subject;

  r.Subject := str; //这是要替换的源字符串
  r.RegEx := '!!table'; //这是表达式, 在这里是准备替换掉的子串
  r.Replacement := '<table'; //要替换成的新串
  r.ReplaceAll; //执行全部替换
  str := r.Subject;

  r.Subject := str; //这是要替换的源字符串
  r.RegEx := '!!img'; //这是表达式, 在这里是准备替换掉的子串
  r.Replacement := '<img'; //要替换成的新串
  r.ReplaceAll; //执行全部替换
  str := r.Subject;

  r.Subject := str; //这是要替换的源字符串
  r.RegEx := '!!br'; //这是表达式, 在这里是准备替换掉的子串
  r.Replacement := '<br'; //要替换成的新串
  r.ReplaceAll; //执行全部替换
  str := r.Subject;

  //=============
  r.Subject := str; //这是要替换的源字符串
  r.RegEx := '!!/td'; //这是表达式, 在这里是准备替换掉的子串
  r.Replacement := '</td'; //要替换成的新串
  r.ReplaceAll; //执行全部替换

  str := r.Subject;
  r.Subject := str; //这是要替换的源字符串
  r.RegEx := '!!/tr'; //这是表达式, 在这里是准备替换掉的子串
  r.Replacement := '</tr'; //要替换成的新串
  r.ReplaceAll; //执行全部替换
  str := r.Subject;

  r.Subject := str; //这是要替换的源字符串
  r.RegEx := '!!/table'; //这是表达式, 在这里是准备替换掉的子串
  r.Replacement := '</table'; //要替换成的新串
  r.ReplaceAll; //执行全部替换
  str := r.Subject;

  //========

  r.Subject := str; //这是要替换的源字符串
  r.RegEx := '　'; //这是表达式, 在这里是准备替换掉的子串
  r.Replacement := ' '; //要替换成的新串
  r.ReplaceAll; //执行全部替换
  str := r.Subject;

  r.Subject := str; //这是要替换的源字符串
  r.RegEx := '!!v:imagedata'; //这是表达式, 在这里是准备替换掉的子串
  r.Replacement := '<v:imagedata'; //要替换成的新串
  r.ReplaceAll; //执行全部替换
  str := r.Subject;
  result := str;
end;

function taddtm.gettitlename(str: string): string;
var
  pos1: integer;
  len1: Integer;
begin
  //
  result := str;

  pos1 := pos('=', str);
  if pos1 > 0 then

  begin
    len1 := Length(str) - pos1;
    result := Trim(copy(str, pos1 + 1, len1));
  end;
end;

function taddtm.getfilename(str: string): string;
var
  pos1, len1: integer;
begin
  //
  result := '';
  pos1 := lastpos('\', str);
  len1 := length(str);
  try
    result := copy(str, pos1 + 1, len1 - pos1 + 1);
  except
  end;
end;

function taddtm.isalpha(mystr: string): integer;
var
  i: integer;
  strx: string;
  strb: string;
  pos1: integer;
begin
  result := 0;
  try
    if Trim(MYSTR) = '' then
      EXIT;

    if Copy(Trim(mystr), 1, 2) = '【' then
    begin
      strx := stringreplace(mystr, '.', '', [rfreplaceall]);
      strx := stringreplace(strx, '．', '', [rfreplaceall]);
      pos1 := Pos('】', strx);

      if Copy(Trim(strx), 3, 2) = '==' then
        Result := -1
      else if Copy(Trim(strx), 3, 2) = '++' then
        Result := -2
      else
      begin
        try
          if pos1 > 0 then
            result := StrToInt(Copy(Trim(strx), 3, pos1 - 3));
        except
          //        ShowMessage(strx);
          exit;
        end;
      end;
    end;
  except
  end;
end;

function taddtm.inctm(str: string): string;
var
  ii: integer;
begin
  //
  result := '';
  try
    if str = '' then
      ii := 0
    else
    begin
      ii := StrToInt(str);
      ii := ii + 1;
    end;
    result := rightstr('000' + Trim(inttostr(ii)), 3);
  except
  end;

end;

function taddtm.getimgname(str: string): string;
var
  pos1, len1: integer;
  str1, str2: string;
begin
  //
  str2 := '';
  pos1 := pos('src', str);
  len1 := length(str);
  str1 := copy(str, pos1 + 5, len1 - pos1);
  pos1 := pos('"', str1);
  str2 := copy(str1, 1, pos1 - 1);
  result := str2;
end;

function taddtm.getrightstr(str: string; n: integer): string;
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

function taddtm.getextname(str: string): string;
var
  pos1, len1: integer;
begin
  //
  result := '';
  pos1 := lastpos('.', str);
  len1 := length(str);
  try
    result := copy(str, pos1 + 1, len1 - pos1 + 1);
  except
  end;
end;

function taddtm.LastPos(SearchStr, Str: string): Integer;
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

function taddtm.textfromfile(afile: string): string;
var
  txt: TextFile;
  stext, s: string;
  path: string;
  len1: Integer;
begin
  try
    if not FileExists(AFILE) then
      EXIT;
    textlines.Clear;
    AssignFile(txt, afile);
    Reset(txt);
    stext := '';
    while not Eof(txt) do
    begin
      Readln(txt, s);
      stext := stext + chr(10) + chr(13) + s;
    end;
    CloseFile(txt);
    result := stext;
  except
  end;

  LEN1 := pos('<BODY', UPPERCASE(stext));
  stext := lowercase(copy(stext, LEN1, LENGTH(stext) - LEN1));

  stext := clearHTMLBZ(stext);
  try
    AssignFile(txt, afile);
    Rewrite(txt);
    Writeln(txt, stext);
    CloseFile(txt);
  except
  end;

  try
    textlines.Clear;
    AssignFile(txt, afile);
    Reset(txt);
    stext := '';
    while not Eof(txt) do
    begin
      Readln(txt, s);
      stext := stext + s;
      textlines.Add(s);
    end;
    CloseFile(txt);
    result := stext;
  except
  end;

end;

procedure taddtm.WriteToTEST(ASTR: string);
var
  txt: TextFile;
begin
  try
    AssignFile(txt, MAINPATH + 'TEST.TXT');
    Append(txt);
    Writeln(txt, ASTR);
    CloseFile(txt);
  except
  end;
end;

procedure taddtm.WriteToTestBEGIN;
var
  txt: TextFile;
begin
  try
    AssignFile(txt, MAINPATH + 'TEST.TXT');
    Rewrite(txt);
    Writeln(txt, ' ');
    CloseFile(txt);
  except
  end;

end;

procedure taddtm.WriteToTestOPEN;
begin
  ShellExecute(0, 'open', PChar(MAINPATH + 'TEST.TXT'), nil, nil, SW_SHOW);
end;

procedure taddtm.SendTokmDBF;
var
  txt: TextFile;
  s: string;
  path: string;
  len1: Integer;
  strKM: TSTrINGLIST;
  sqltext: string;
begin
  try
    textlines.Clear;
    strKM := tstringlist.create;
    AssignFile(txt, mainpath + 'km.txt');
    Reset(txt);
    while not Eof(txt) do
    begin
      Readln(txt, s);
      strkm := splitstring(s, '#');
      if strkm[0] = 'km' then
      begin
        sqltext := 'insert into km(id,name) values(''' + strkm[1] + ''',''' +
          strkm[2] + ''')';
        execsql(sqltext);
      end;
    end;
    CloseFile(txt);
  except
  end;

end;

function taddtm.splitstring(src, dec: string): TStringList;
var
  i: integer;
  str: string;
begin
  result := TStringList.Create;
  repeat
    i := pos(dec, src);
    str := copy(src, 1, i - 1);
    if (str = '') and (i > 0) then
    begin
      delete(src, 1, length(dec));
      continue;
    end;
    if i > 0 then
    begin
      result.Add(str);
      delete(src, 1, i + length(dec) - 1);
    end;
  until i <= 0;
  if src <> '' then
    result.Add(src);
end;

procedure taddtm.SendToZJDBF;
begin
  //
end;

function taddtm.getLISTqry: TADOQuery;
//
begin
  QRY_ZJ.close;
  QRY_ZJ.sql.clear;
  QRY_ZJ.sql.add(' select * from zj  order by xh');
  QRY_ZJ.Open;
  result := QRY_ZJ;
end;
{ textfile_km_zj_code }

constructor textfile_km_zj_code.create;
begin
  //
end;

function textfile_km_zj_code.current_km_zj_code: Code_KM_ZJ;
begin
  result := akmzj_code;
end;

destructor textfile_km_zj_code.DESTRORY;
begin
  //
end;

procedure textfile_km_zj_code.DMfromHTML;
var
  txt: TextFile;
  stext, s: string;
  path: string;
  len1: Integer;
begin
  try

    if not FileExists(kmzj_code.filename) then
    begin
      EXIT;
    end;

    AssignFile(txt, filename);
    Reset(txt);
    stext := '';
    while not Eof(txt) do
    begin
      Readln(txt, s);
      if Trim(s) <> '' then
        BREAK;
    end;
    CloseFile(txt);

    str_filename_km_zj := s;
    splitter_dmmc;
  except
  end;
end;

procedure textfile_km_zj_code.DmToHtmlfile;
var
  FB: TStringList;
  I: Integer;
  S: string;
  txt: TextFile;
  ipos: Integer;
begin
  try
    if not FileExists(kmzj_code.filename) then
    begin
      EXIT;
    end;

    FB := TStringList.Create;
    AssignFile(txt, kmzj_code.filename);
    Reset(txt);
    S := '';
    while not Eof(txt) do
    begin
      Readln(txt, s);
      if Trim(s) <> '' then
        fB.Add(S);
    end;
    CloseFile(txt);

    ipos := Pos('】', fB[0]);
    fB[0] := '【【' + akmzj_code.tmname + '#' + akmzj_code.KM + '#'
      + akmzj_code.zj + '】】' + copy(fB[0], ipos + 1, Length(FB[0]));

    fB.SaveToFile(kmzj_code.filename);
    FB.FREE;

  except
  end;
end;

procedure textfile_km_zj_code.merge_dmmc;
begin
  str_filename_km_zj := '【【' + akmzj_code.tmname + '#' + akmzj_code.KM + '#'
    + akmzj_code.zj + '】】';
end;

procedure textfile_km_zj_code.setFILENAME(const Value: string);
begin
  FILENAME := Value;
  akmzj_code.FILENAME := Value;
  DMfromHTML;
end;

procedure textfile_km_zj_code.Set_kmzj_code(const Value: Code_KM_ZJ);
begin
  akmzj_code := Value;
  DmToHtmlfile;
end;

procedure textfile_km_zj_code.splitter_dmmc;
var
  ipos: integer;
  strtmp: string;
begin
  ipos := Pos('#', str_filename_km_zj);
  akmzj_code.tmname := Copy(str_filename_km_zj, 5, ipos - 5);
  strtmp := Trim(Copy(str_filename_km_zj, ipos + 1,
    Length(str_filename_km_zj)));

  ipos := Pos('#', strtmp);
  akmzj_code.ZJ := Copy(strtmp, 1, ipos - 1);
  strtmp := Trim(Copy(strtmp, ipos + 1,
    Length(strtmp)));

  ipos := Pos('】', strtmp);
  akmzj_code.KM := Copy(strtmp, 1, ipos - 1);
end;

end.
