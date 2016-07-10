program EXAM;

uses
  Forms,
  DAT in 'DAT.pas' {mydb: TDataModule},
  SmpExprCalc in 'SmpExprCalc.pas',
  UnitHardInfo in 'UnitHardInfo.pas',
  md5 in 'md5.pas',
  Crc32 in 'Crc32.pas',
  shareunit in 'shareunit.pas',
  xg in 'xg.pas' {fmxg},
  fmdy in 'fmdy.pas' {formdy},
  fmbjb in 'fmbjb.pas' {formbjb},
  selectRND in 'selectRND.pas' {fmselectRND},
  regnew in 'regnew.pas' {fmreg},
  lxyjm in 'lxyjm.pas',
  utm in 'utm.pas',
  UTMLIST in 'UTMLIST.pas',
  KS16 in '..\xyword\KS16.pas' {fmks16},
  KSFORM in '..\xyword\KSFORM.pas' {fmks},
  addtm in 'addtm.pas',
  ImportTM in 'ImportTM.pas' {fmImportTM},
  ucommunit in 'ucommunit.pas',
  contact in 'contact.pas' {Form5};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '×¢»á¿¼ÊÔÏµÍ³';
  Application.CreateForm(Tmydb, mydb);
  Application.CreateForm(Tfmks16, fmks16);
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
