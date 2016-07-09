unit lxyjm;

interface

uses Windows, SysUtils, registry
  ;

type tlxyjm = class
  private
    jmstra: string;
    jmtmp1, jmtmp2, jmtmp3: string;
    fsn1, fsn2, fsn3: string;
    REGKEY: string;
    diskserial: string;
    fusersn: string;
    FCHK1: Boolean;
    FCHK3: Boolean;
    FCHK2: Boolean;
    fregsn: string;
    fuserdiskserial: string;

    function jm1(disksn: string): string;
    function jm2(disksn: string): string;
    function jm3(disksn: string): string;


  published
    property usersn: string read fusersn write fusersn;
    property chk1: Boolean read FCHK1;
    property chk2: Boolean read FCHK2;
    property chk3: Boolean read FCHK3;
    property userdiskserial: string read fuserdiskserial write fuserdiskserial;

  public

    constructor create(aa, bb, cc, dd: string);
    function check1(): Boolean;
    function check2(): Boolean;
    function check3(): Boolean;
    function serialA(): string;
    function serialB(): string;
    function geneserial_thispc(): string;
    function geneserial_otherpc(): string;
    function TOKH(JQM: string): string;
    procedure writeToReg();
    procedure CHECK();
  end;

implementation

uses
  UnitHardInfo, Crc32, md5;



{ tlxyjm }

procedure tlxyjm.CHECK;
begin
//
  FCHK1 := check1();
  FCHK2 := check2();
  FCHK3 := check3();
end;

function tlxyjm.check1(): Boolean;
var S1, S2: string;
  reg: TRegistry;
begin

  RESULT := FALSE;


  S2 := uppercase(crc32.GetCrc32Str(diskserial + jmtmp1, 12));
  S2 := UpperCase(Copy(uppercase(crc32.GetCrc32Str(S2 + jmtmp1, 12)), 1, 8));

  if md5.MD5Match(md5.MD5String(fsn1), md5.MD5String(s2)) then
    RESULT := TRUE;

end;

function tlxyjm.check2(): Boolean;
var S1, S2: string;

begin
  RESULT := FALSE;

  S2 := uppercase(crc32.GetCrc32Str(diskserial + jmtmp2, 12));
  S2 := UpperCase(Copy(uppercase(crc32.GetCrc32Str(S2 + jmtmp2, 12)), 1, 8));

  if md5.MD5Match(md5.MD5String(fsn2), md5.MD5String(s2)) then
    RESULT := TRUE;

end;

function tlxyjm.check3(): Boolean;
var S1, S2: string;
  reg: TRegistry;
begin
//
  RESULT := FALSE;

  S2 := uppercase(crc32.GetCrc32Str(diskserial + jmtmp3, 12));
  S2 := UpperCase(Copy(uppercase(crc32.GetCrc32Str(S2 + jmtmp3, 12)), 1, 8));

  if md5.MD5Match(md5.MD5String(fsn3), md5.MD5String(s2)) then
    RESULT := TRUE;

end;



constructor tlxyjm.CREATE(aa, bb, cc, dd: string);
var
  reg: TRegistry;
begin

  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  if reg.OpenKey(regkey, True) then
  begin
    fregsn := reg.READstring('SN');
  end;

{$IFDEF _ProVersion}
 //正式版本********
  jmstra := aa;
  jmtmp1 := bb;
  jmtmp2 := cc;
  jmtmp3 := dd;

  //正式版本*********

{$ELSE}
  //是否编译成限制版本*********

  //是否编译成限制版本*********
  jmstra := dd;
  jmtmp1 := cc;
  jmtmp2 := bb;
  jmtmp3 := aa;
{$ENDIF}
  //是否编译成限制版本*********

  //是否编译成限制版本*********



  diskserial := GetIdeSerialNumber;
  if Trim(diskserial) = '' then
    diskserial := GetCPUInfo;

  diskserial := uppercase(copy(MD5Print(md5.MD5String(trim(diskserial) + jmstra)), 1,
    12));

  fsn1 := Copy(fregsn, 1, 8);
  fsn2 := Copy(fregsn, 9, 8);
  fsn3 := Copy(fregsn, 17, 8);

end;



function tlxyjm.geneserial_otherpc: string;
var xx1, xx2, xx3: string;
begin

  RESULT := JM1(fuserdiskserial) + JM2(fuserdiskserial) + JM3(fuserdiskserial);
end;

function tlxyjm.geneserial_thispc: string;
var xx1, xx2, xx3: string;
begin

  RESULT := JM1(diskserial) + JM2(diskserial) + JM3(diskserial);
end;

function tlxyjm.jm1(disksn: string): string;
var s1: string;
begin

  result := '';

  S1 := uppercase(crc32.GetCrc32Str(disksn + jmtmp1, 12));
  result := UpperCase(Copy(uppercase(crc32.GetCrc32Str(S1 + jmtmp1, 12)), 1, 8));
end;

function tlxyjm.jm2(disksn: string): string;
var s1: string;
begin
  result := '';
  S1 := uppercase(crc32.GetCrc32Str(disksn + jmtmp2, 12));
  result := UpperCase(Copy(uppercase(crc32.GetCrc32Str(S1 + jmtmp2, 12)), 1, 8));
end;

function tlxyjm.jm3(disksn: string): string;
var s1: string;
begin
  result := '';
  S1 := uppercase(crc32.GetCrc32Str(disksn + jmtmp3, 12));
  result := UpperCase(Copy(uppercase(crc32.GetCrc32Str(S1 + jmtmp3, 12)), 1, 8));
end;

function tlxyjm.serialA: string;
begin
  //
  RESULT := diskserial;
end;

function tlxyjm.serialB: string;
var
  reg: TRegistry;
  S1, S2, S3: string;
begin
  RESULT := '';
  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  if reg.OpenKey(regkey, True) then
  begin
    S1 := reg.READstring('SN');
    RESULT := S1;
  end;
end;

function tlxyjm.TOKH(JQM: string): string;
var S1, S2: string;
begin
//
  RESULT := '';
  S1 := uppercase(crc32.GetCrc32Str(JQM + jmtmp1, 12));
  S1 := UpperCase(Copy(uppercase(crc32.GetCrc32Str(S1 + jmtmp1, 12)), 1, 8));
  S2 := S1;
  S1 := uppercase(crc32.GetCrc32Str(JQM + jmtmp2, 12));
  S1 := UpperCase(Copy(uppercase(crc32.GetCrc32Str(S1 + jmtmp2, 12)), 1, 8));
  S2 := S2 + S1;
  S1 := uppercase(crc32.GetCrc32Str(JQM + jmtmp3, 12));
  S1 := UpperCase(Copy(uppercase(crc32.GetCrc32Str(S1 + jmtmp3, 12)), 1, 8));
  S2 := S2 + S1;
  RESULT := S2;
end;

procedure tlxyjm.writeToReg();
var
  reg: TRegistry;
begin
  if Trim(fusersn) = '' then exit;

  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  if reg.OpenKey(regkey, True) then
  begin
    reg.writestring('SN', fusersn);
  end
  else
  begin
    reg.CreateKey(regkey);
    if reg.OpenKey(regkey, True) then
    begin
      reg.writestring('SN', fusersn);
    end
  end;
end;

end.

