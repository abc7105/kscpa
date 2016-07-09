unit shareunit;

interface
uses SysUtils, IniFiles, StrUtils;
type
  Tmysys = record
    isafterpage: boolean;
    isautodisp: boolean;
    isautoans: boolean;
    ispoint: boolean;
    tmts: integer;
    tmid: string;
    tmtitle: string;
    isafterdy: boolean;
    km: string;
    zj: string;

    pwd: string;

  end;
var
  mysys: Tmysys;
  amykm: string;

  strver: string;
  jmstring: string;
  regkey: string;
  jmtmpstr: string;
  outfile: string;
  webpage: string;
  pubver: boolean; //是否公用版本，如是，则不管是否注册，均不能显示下列菜单
  is_unlimit: boolean; //是否无限制
const
  Encrypt_Const = $3412;
  ONLYLIST = 5; //未注册版本最多只能显示个数


procedure SaveParamToFile(const AFileName: TFileName);
procedure LoadParamFromFile(const AFileName: TFileName);
function FindLastPos(subStr, sourStr: string): integer;
function Encrypt(const S: string; Key: Word): string;
function Decrypt(const S: string; Key: Word): string;
function getimgname(str: string): string;
implementation

function getimgname(str: string): string;
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

function TransChar(AChar: Char): Integer;
begin
  if ((Achar >= '0') and (Achar <= '9')) then
    result := Ord(AChar) - Ord('0')
  else
    Result := 10 + Ord(AChar) - Ord('A');
end;

function StrToHex(AStr: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(AStr) do
  begin
    Result := Result + Format('%2x', [Byte(AStr[I])]);
  end;
  I := Pos(' ', Result);
  while I <> 0 do
  begin
    Result[I] := '0';
    I := Pos(' ', Result);
  end;
end;

function HexToStr(AStr: string): string;
var
  I: Integer;
  Charvalue: Word;
begin
  Result := '';
  for I := 1 to Trunc(Length(Astr) / 2) do
  begin
    Result := Result + ' ';
    Charvalue := TransChar(AStr[2 * I - 1]) * 16 + TransChar(AStr[2 * I]);
    Result[I] := Char(Charvalue);
  end;
end;

function Encrypt(const S: string; Key: Word): string;
var
  I: Integer;
begin
  Result := S;
  for I := 1 to Length(S) do
  begin
    Result[I] := char(byte(S[I]) xor (Key shr 8));
    Key := (byte(Result[I]) + Key) * $C1 + $C2;
    if Result[I] = Chr(0) then
      Result[I] := S[I];
  end;
  Result := StrToHex(Result);
end;

function Decrypt(const S: string; Key: Word): string;
var
  I: Integer;
  S1: string;
begin
  S1 := HexToStr(S);
  Result := S1;
  for I := 1 to Length(S1) do
  begin
    if char(byte(S1[I]) xor (Key shr 8)) = Chr(0) then
    begin
      Result[I] := S1[I];
      Key := (byte(Chr(0)) + Key) * $C1 + $C2; //±Ｖ¤Key的正取ば浴　
    end
    else
    begin
      Result[I] := char(byte(S1[I]) xor (Key shr 8));
      Key := (byte(S1[I]) + Key) * $C1 + $C2;
    end;
  end;
end;

function FindLastPos(subStr, sourStr: string): integer;
begin
  subStr := ReverseString(subStr);
  sourStr := ReverseString(sourStr);
  Result := length(sourStr) - Pos(subStr, sourStr) + 1;
end;

procedure SaveParamToFile(const AFileName: TFileName);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(AFileName);
  Ini.WriteBool('mysys', 'isafterpage', mysys.isafterpage);
  Ini.WriteBool('mysys', 'isautodisp', mysys.isautodisp);
  Ini.WriteBool('mysys', 'isautoans', mysys.isautoans);
  Ini.WriteBool('mysys', 'ispoint', mysys.ispoint);
  Ini.WriteString('mysys', 'tmid', Encrypt(mysys.tmid, 71));
  Ini.WriteString('mysys', 'tmtitle', mysys.tmtitle);
  Ini.WriteBool('mysys', 'isafterdy', mysys.isafterdy);
  Ini.WriteString('mysys', 'km', mysys.km);
  Ini.WriteString('mysys', 'zj', mysys.zj);
  ini.WriteInteger('mysys', 'tmts', mysys.tmts);
  ini.Writestring('mysys', 'pwd', mysys.pwd);
  Ini.Free;
end;

procedure LoadParamFromFile(const AFileName: TFileName);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(AFileName);
  if not fileexists(afilename) then
  begin
    mysys.isafterpage := false;
    mysys.isautodisp := false;
    mysys.isautoans := false;
    mysys.ispoint := false;
    mysys.tmid := '';
    mysys.tmtitle := '';
    mysys.isafterdy := false;
    mysys.tmts := 0;
    mysys.km := '1';
    mysys.zj := '001';
    mysys.pwd := 'CPA';
    SaveParamToFile(afilename);
  end
  else
  begin
    mysys.isafterpage := Ini.ReadBool('mysys', 'isafterpage', False);
    mysys.isautodisp := Ini.ReadBool('mysys', 'isautodisp', False);
    mysys.isautoans := Ini.ReadBool('mysys', 'isautoans', False);
    mysys.ispoint := Ini.ReadBool('mysys', 'ispoint', False);
    mysys.tmid := decrypt(Ini.ReadString('mysys', 'tmid', ''), 71);
    mysys.tmtitle := Ini.ReadString('mysys', 'tmtitle', '');
    mysys.isafterdy := Ini.ReadBool('mysys', 'isafterdy', False);
    mysys.km := Ini.ReadString('mysys', 'km', '');
    mysys.zj := Ini.ReadString('mysys', 'zj', '');
    mysys.pwd := Ini.ReadString('mysys', 'pwd', '');
    mysys.tmts := ini.ReadInteger('mysys', 'tmts', 0)
  end;
  Ini.Free;

end;


end.

