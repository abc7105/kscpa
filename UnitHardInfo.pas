unit UnitHardInfo;
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, NB30, WinSock, Registry;

const
  ID_BIT = $200000; // EFLAGS ID bit

type
  TCPUID = array[1..4] of Longint;
  TVendor = array[0..11] of char;

function IsCPUID_Available: Boolean; register; //判断CPU序列号是否可用函数
function GetCPUID: TCPUID; assembler; register; //获取CPU序列号函数
function GetCPUVendor: TVendor; assembler; register; //获取CPU生产厂家函数
function GetCPUInfo: string; //CPU序列号(格式化成字符串)
function GetCPUSpeed: Double; //获取CPU速度函数
function GetDisplayFrequency: Integer; //获取显示器刷新率
function GetMemoryTotalSize: DWORD; //获取内存总量
function Getmac: string;
function GetHostName: string;
function NameToIP(Name: string): string;
function GetDiskSize: string;
function GetCPUName: string;
function GetIdeSerialNumber(): PChar; stdcall;

type
  PASTAT = ^TASTAT;
  TASTAT = record
    adapter: TAdapterStatus;
    name_buf: TNameBuffer;
  end;

implementation



function IsCPUID_Available: Boolean; register;
asm
    PUSHFD {direct access to flags no possible, only via stack}
    POP EAX {flags to EAX}
    MOV EDX,EAX {save current flags}
    XOR EAX,ID_BIT {not ID bit}
    PUSH EAX {onto stack}
    POPFD {from stack to flags, with not ID bit}
    PUSHFD {back to stack}
    POP EAX {get back to EAX}
    XOR EAX,EDX {check if ID bit affected}
    JZ @exit {no, CPUID not availavle}
    MOV AL,True {Result=True}
    @exit:
end;



function GetCPUID: TCPUID; assembler; register;
asm
    PUSH    EBX         {Save affected register}
    PUSH    EDI
    MOV     EDI,EAX     {@Resukt}
    MOV     EAX,1
    DW      $A20F       {CPUID Command}
    STOSD                {CPUID[1]}
    MOV     EAX,EBX
    STOSD               {CPUID[2]}
    MOV     EAX,ECX
    STOSD               {CPUID[3]}
    MOV     EAX,EDX
    STOSD               {CPUID[4]}
    POP     EDI         {Restore registers}
    POP     EBX
end;

function GetCPUVendor: TVendor; assembler; register;
  //获取CPU生产厂家函数
  //调用方法:EDIT.TEXT:='Current CPU Vendor:'+GetCPUVendor;
asm
      PUSH EBX {Save affected register}
      PUSH EDI
      MOV EDI,EAX {@Result (TVendor)}
      MOV EAX,0
      DW $A20F {CPUID Command}
      MOV EAX,EBX
      XCHG EBX,ECX {save ECX result}
      MOV ECX,4
      @1:
      STOSB
      SHR EAX,8
      LOOP @1
      MOV EAX,EDX
      MOV ECX,4
      @2:
      STOSB
      SHR EAX,8
      LOOP @2
      MOV EAX,EBX
      MOV ECX,4
      @3:
      STOSB
      SHR EAX,8
      LOOP @3
      POP EDI {Restore registers}
      POP EBX
end;

function GetCPUInfo: string;
var
  CPUID: TCPUID;
  I: Integer;
  S: TVendor;
begin
  for I := Low(CPUID) to High(CPUID) do CPUID[I] := -1;
  if IsCPUID_Available then
  begin
    CPUID := GetCPUID;
    S := GetCPUVendor;
    Result := IntToHex(CPUID[1], 8)
      + '-' + IntToHex(CPUID[2], 8)
      + '-' + IntToHex(CPUID[3], 8)
      + '-' + IntToHex(CPUID[4], 8);
  end
  else Result := 'CPUID not available';
end;


function GetCPUSpeed: Double;
 //获取CPU速率函数
 //调用方法:EDIT.TEXT:='Current CPU Speed:'+floattostr(GetCPUSpeed)+'MHz';
const
  DelayTime = 500; // 时间单位是毫秒
var
  TimerHi, TimerLo: DWORD;
  PriorityClass, Priority: Integer;
begin
  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
  Sleep(10);
  asm
        dw 310Fh // rdtsc
        mov TimerLo, eax
        mov TimerHi, edx
  end;
  Sleep(DelayTime);
  asm
        dw 310Fh // rdtsc
        sub eax, TimerLo
        sbb edx, TimerHi
        mov TimerLo, eax
        mov TimerHi, edx
  end;

  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);
  Result := TimerLo / (1000.0 * DelayTime);
end;

function GetDisplayFrequency: Integer;
 // 这个函数返回的显示刷新率是以Hz为单位的
 //调用方法:EDIT.TEXT:='Current DisplayFrequency:'+inttostr(GetDisplayFrequency)+' Hz';
var
  DeviceMode: TDeviceMode;
begin
  EnumDisplaySettings(nil, Cardinal(-1), DeviceMode);
  Result := DeviceMode.dmDisplayFrequency;
end;


function GetMemoryTotalSize: DWORD; //获取内存总量
var
  msMemory: TMemoryStatus;
  iPhysicsMemoryTotalSize: DWORD;
begin
  msMemory.dwLength := SizeOf(msMemory);
  GlobalMemoryStatus(msMemory);
  iPhysicsMemoryTotalSize := msMemory.dwTotalPhys;
  Result := iPhysicsMemoryTotalSize;
end;
//
//  type
//      PASTAT =^TASTAT;
//      TASTAT = record
//          adapter:TAdapterStatus;
//          name_buf:TNameBuffer;
//  end;


function Getmac: string;
var
  ncb: TNCB;
  s: string;
  adapt: TASTAT;
  lanaEnum: TLanaEnum;
  i, j, m: integer;
  strPart, strMac: string;
begin
  FillChar(ncb, SizeOf(TNCB), 0);
  ncb.ncb_command := Char(NCBEnum);
  ncb.ncb_buffer := PChar(@lanaEnum);
  ncb.ncb_length := SizeOf(TLanaEnum);
  s := Netbios(@ncb);
  for i := 0 to integer(lanaEnum.length) - 1 do
  begin
    FillChar(ncb, SizeOf(TNCB), 0);
    ncb.ncb_command := Char(NCBReset);
    ncb.ncb_lana_num := lanaEnum.lana[i];
    Netbios(@ncb);
    Netbios(@ncb);
    FillChar(ncb, SizeOf(TNCB), 0);
    ncb.ncb_command := Chr(NCBAstat);
    ncb.ncb_lana_num := lanaEnum.lana[i];
    ncb.ncb_callname := '*';
    ncb.ncb_buffer := PChar(@adapt);
    ncb.ncb_length := SizeOf(TASTAT);
    m := 0;
    if (Win32Platform = VER_PLATFORM_WIN32_NT) then
      m := 1;
    if m = 1 then
    begin
      if Netbios(@ncb) = Chr(0) then
        strMac := '';
      for j := 0 to 5 do
      begin
        strPart := IntToHex(integer(adapt.adapter.adapter_address[j]), 2);
        strMac := strMac + strPart + '-';
      end;
      SetLength(strMac, Length(strMac) - 1);
    end;
    if m = 0 then
      if Netbios(@ncb) <> Chr(0) then
      begin
        strMac := '';
        for j := 0 to 5 do
        begin
          strPart := IntToHex(integer(adapt.adapter.adapter_address[j]), 2);
          strMac := strMac + strPart + '-';
        end;
        SetLength(strMac, Length(strMac) - 1);
      end;
  end;
  result := strmac;
end;

function GetHostName: string;
var
  ComputerName: array[0..MAX_COMPUTERNAME_LENGTH + 1] of char;
  Size: Cardinal;
begin
  result := '';
  Size := MAX_COMPUTERNAME_LENGTH + 1;
  GetComputerName(ComputerName, Size);
  Result := StrPas(ComputerName);
end;

function NameToIP(Name: string): string;
var
  WSAData: TWSAData;
  HostEnt: PHostEnt;
begin
  result := '';
  WSAStartup(2, WSAData);
  HostEnt := GetHostByName(PChar(Name));
  if HostEnt <> nil then
  begin
    with HostEnt^ do
      result := Format('%d.%d.%d.%d', [Byte(h_addr^[0]), Byte(h_addr^[1]), Byte(h_addr^[2]), Byte(h_addr^[3])]);
  end;
  WSACleanup;
end;


function GetDiskSize: string;
var Available, Total, Free: Int64;
  AvailableT, TotalT: real;
  Drive: Char;
const GB = 1024 * 1024 * 1024;

begin
  AvailableT := 0;
  TotalT := 0;
  for Drive := 'C' to 'Z' do
    if GetDriveType(Pchar(Drive + ':\')) = DRIVE_FIXED then
    begin
      GetDiskFreeSpaceEx(PChar(Drive + ':\'), Available, Total, @Free);
      AvailableT := AvailableT + Available;
      TotalT := TotalT + Total;
    end;
  Result := Format('%.2fGB', [TotalT / GB]);

end;

function GetCPUName: string;
var
  myreg: TRegistry;
  CPUInfo: string;
begin
  myreg := TRegistry.Create;
  myreg.RootKey := HKEY_LOCAL_MACHINE;
  if myreg.OpenKey('Hardware\Description\System\CentralProcessor\0', true) then begin
    if myreg.ValueExists('ProcessorNameString') then begin
      CPUInfo := myreg.ReadString('ProcessorNameString');
      myreg.CloseKey;
    end else CPUInfo := 'UnKnow';
  end;
  Result := CPUInfo;
end;

function GetIdeSerialNumber: pchar; //获取硬盘的出厂系列号；
const IDENTIFY_BUFFER_SIZE = 512;
type
  TIDERegs = packed record
    bFeaturesReg: BYTE;
    bSectorCountReg: BYTE;
    bSectorNumberReg: BYTE;
    bCylLowReg: BYTE;
    bCylHighReg: BYTE;
    bDriveHeadReg: BYTE;
    bCommandReg: BYTE;
    bReserved: BYTE;
  end;
  TSendCmdInParams = packed record
    cBufferSize: DWORD;
    irDriveRegs: TIDERegs;
    bDriveNumber: BYTE;
    bReserved: array[0..2] of Byte;
    dwReserved: array[0..3] of DWORD;
    bBuffer: array[0..0] of Byte;
  end;
  TIdSector = packed record
    wGenConfig: Word;
    wNumCyls: Word;
    wReserved: Word;
    wNumHeads: Word;
    wBytesPerTrack: Word;
    wBytesPerSector: Word;
    wSectorsPerTrack: Word;
    wVendorUnique: array[0..2] of Word;
    sSerialNumber: array[0..19] of CHAR;
    wBufferType: Word;
    wBufferSize: Word;
    wECCSize: Word;
    sFirmwareRev: array[0..7] of Char;
    sModelNumber: array[0..39] of Char;
    wMoreVendorUnique: Word;
    wDoubleWordIO: Word;
    wCapabilities: Word;
    wReserved1: Word;
    wPIOTiming: Word;
    wDMATiming: Word;
    wBS: Word;
    wNumCurrentCyls: Word;
    wNumCurrentHeads: Word;
    wNumCurrentSectorsPerTrack: Word;
    ulCurrentSectorCapacity: DWORD;
    wMultSectorStuff: Word;
    ulTotalAddressableSectors: DWORD;
    wSingleWordDMA: Word;
    wMultiWordDMA: Word;
    bReserved: array[0..127] of BYTE;
  end;
  PIdSector = ^TIdSector;
  TDriverStatus = packed record
    bDriverError: Byte;
    bIDEStatus: Byte;
    bReserved: array[0..1] of Byte;
    dwReserved: array[0..1] of DWORD;
  end;
  TSendCmdOutParams = packed record
    cBufferSize: DWORD;
    DriverStatus: TDriverStatus;
    bBuffer: array[0..0] of BYTE;
  end;
var
  hDevice: Thandle;
  cbBytesReturned: DWORD;
  SCIP: TSendCmdInParams;
  aIdOutCmd: array[0..(SizeOf(TSendCmdOutParams) + IDENTIFY_BUFFER_SIZE - 1) - 1] of Byte;
  IdOutCmd: TSendCmdOutParams absolute aIdOutCmd;
  procedure ChangeByteOrder(var Data; Size: Integer);
  var
    ptr: Pchar;
    i: Integer;
    c: Char;
  begin
    ptr := @Data;
    for I := 0 to (Size shr 1) - 1 do begin
      c := ptr^;
      ptr^ := (ptr + 1)^;
      (ptr + 1)^ := c;
      Inc(ptr, 2);
    end;
  end;
begin
  Result := '';
  if SysUtils.Win32Platform = VER_PLATFORM_WIN32_NT then begin //   Windows   NT,   Windows   2000
    hDevice := CreateFile('\\.\PhysicalDrive0', GENERIC_READ or GENERIC_WRITE,
      FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
  end else //   Version   Windows   95   OSR2,   Windows   98
    hDevice := CreateFile('\\.\SMARTVSD', 0, 0, nil, CREATE_NEW, 0, 0);
  if hDevice = INVALID_HANDLE_VALUE then Exit;
  try
    FillChar(SCIP, SizeOf(TSendCmdInParams) - 1, #0);
    FillChar(aIdOutCmd, SizeOf(aIdOutCmd), #0);
    cbBytesReturned := 0;
    with SCIP do begin
      cBufferSize := IDENTIFY_BUFFER_SIZE;
      with irDriveRegs do begin
        bSectorCountReg := 1;
        bSectorNumberReg := 1;
        bDriveHeadReg := $A0;
        bCommandReg := $EC;
      end;
    end;
    if not DeviceIoControl(hDevice, $0007C088, @SCIP, SizeOf(TSendCmdInParams) - 1,
      @aIdOutCmd, SizeOf(aIdOutCmd), cbBytesReturned, nil) then Exit;
  finally
    CloseHandle(hDevice);
  end;
  with PIdSector(@IdOutCmd.bBuffer)^ do begin
    ChangeByteOrder(sSerialNumber, SizeOf(sSerialNumber));
    (Pchar(@sSerialNumber) + SizeOf(sSerialNumber))^ := #0;
    Result := Pchar(@sSerialNumber);
  end;
end;

end.

