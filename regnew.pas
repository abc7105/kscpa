unit regnew;

interface

uses
  Classes, Controls, Forms, SysUtils,
  StdCtrls, lxyjm, Dialogs, bsSkinCtrls
;

type
  Tfmreg = class(TForm)
    lbl1: TLabel;
    lbl2: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    Button2: TbsSkinSpeedButton;
    Button5: TbsSkinSpeedButton;
    edt1: TEdit;
    edt2: TEdit;
    lblok: TLabel;
    lblerr: TLabel;
    lbl10: TbsSkinLinkLabel;
    lbl12: TLabel;
    lbl9: TLabel;
    lbl11: TbsSkinLinkLabel;
    bsSkinLinkLabel1: TbsSkinLinkLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  published
    procedure disperr(bok: Boolean);

  end;

var
  fmreg: Tfmreg;
  sj: integer;
  myjm: tlxyjm;


implementation

uses
  shareunit;



{$R *.dfm}

procedure Tfmreg.FormCreate(Sender: TObject);
var x1, x2, x3, x4: string;
begin
  x1 := 'abc' + trim(mysys.pwd) + 'ks2011';
  x2 := 'lxy' + trim(mysys.pwd) + 'ks2011';
  x3 := 'lhh' + trim(mysys.pwd) + 'ks2022';
  x4 := 'zl+' + trim(mysys.pwd) + 'ks2031';

  myjm := tlxyjm.create(x1, x2, x3, x4);
  edt1.Text := myjm.serialA;
  edt2.Text := myjm.serialB;
  if myjm.check1 then lblerr.Visible := false;
end;

procedure Tfmreg.Button2Click(Sender: TObject);
begin
 //
  myjm.usersn := edt2.Text;
  myjm.writeToReg;
  showmessage('请关闭本程序后，再重新打开确认注册是否成功。');
end;

procedure Tfmreg.Button5Click(Sender: TObject);
begin
  close;
end;

procedure Tfmreg.disperr(bok: Boolean);
begin
  lblerr.Visible := not bok;
end;

end.

