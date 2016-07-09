{************************************************
2005.06.21 by kiukiubot@yahoo.com.cn
  + property FormatStr, LastError, AsInteger, AsString
  * refector properties
  * misc modifications
2005.06.17 1st ed by kiukiubot@yahoo.com.cn
  + build Component
  + parts ported from zhangjunrest@sina.com 's work
  + added 4 properties
  + added Create to set 'FCanRaiseError := FALSE;'
  . for smaller memery occupation, change
    TSmpExprCalc = class(TComponent)
    to
    TSmpExprCalc = class(TObject)
    and remove both decl 'n impl of procedure Register;

** Usage ****************************************
  . a typical usage is:
    var
      calc: TSmpExprCalc;
    ...
      calc := TSmpExprCalc.Create;
      try
        // CanRaiseError MUST be set before Text
        calc.CanRaiseError := TRUE;
        // On Setting 'Text' property, the Result calc'd
        calc.Expression := '(3+7/2)*5-1';
        if calc.processed then
          Edit1.Text := Format('%f',[calc.Value]);
      finally
        calc.free;
      end;
  . a brief example will be like:
  	var
      calc: TSmpExprCalc;
    ...
      calc := TSmpExprCalc.Create;
      calc.Expression := '(3+7/2)*5-1';
      Edit1.Text := Format('%f',[calc.Value]);
      calc.free;
  . or, use it as a function:
      n := calc.do_Calc('3+3');
************************************************}
unit SmpExprCalc;

interface

uses
  SysUtils, Classes;

type
  TExprErrorType = (eeExprOver,eeExprBadExp,eeExprUnknown);
const
  ExprErrorMsg: array[eeExprOver..eeExprUnknown] of pchar
  =(
    'Expression Overflow.',
    'Invalid Expression.',
    'Unknown Error :(.'
  );

type
  TSmpExprCalc = class(TComponent)
  private
    FIsErr: boolean;
    FToken: char;
    FExprStr: string; // internal used expr
    FCurPos, FInStrLen: integer;
    FExpression: string;  // stores input expression
    FValue: extended;
    FCanRaiseError: boolean;
    FFormatStr: string;

    FLastErrorType: TExprErrorType;
    FLastErrorMsg: string;
    FLastErrorPos: integer;

    function GetAsString: string;
    procedure SetFormatStr(const Value: string);
    function GetAsInteger: integer;
    procedure SetCanRaiseError(const Value: boolean);
    procedure SetExpression(const AStr: string);
    function Term: Extended;
    function Factor: Extended;
    function exp: Extended;
    function FindNum: Extended;
    function GetNextChar: char;
    function GetProcessed: boolean;
    procedure RaiseError(AErrType: TExprErrorType);
    procedure Match(AExpectedToken: Char);
    procedure Pre(var AStr:string);
  protected
    //
  public
    constructor Create; overload;
    constructor Create(aRaiseError: boolean); overload;
    function Do_Calc(AStr:string):Extended;
    property Processed: boolean read GetProcessed;
    property Value: extended read FValue;
    property AsInteger: integer read GetAsInteger;
    property AsString: string read GetAsString;
    property LastErrorType: TExprErrorType read FLastErrorType;
    property LastErrorMsg: string read FLastErrorMsg;
    property LastErrorPos: integer read FLastErrorPos;
  published
    property CanRaiseError: boolean read FCanRaiseError write SetCanRaiseError;
    property FormatStr: string read FFormatStr write SetFormatStr;
    property Expression: string read FExpression write SetExpression;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TSmpExprCalc]);
end;

{ TSmpExprCalc }

constructor TSmpExprCalc.Create;
begin
  inherited Create(nil);
  FCanRaiseError := FALSE;
end;

constructor TSmpExprCalc.Create(aRaiseError: boolean);
begin
  inherited Create(nil);
  FCanRaiseError := aRaiseError;
end;

function TSmpExprCalc.Do_Calc(AStr: string): Extended;
begin
  // direct call of Do_Calc may left FExpression not initialized
  // ref SetExpression
  FExpression := AStr;
  Pre(AStr);
  FCurPos := 0;
  FIsErr := FALSE;
  FExprStr := AStr;
  FInStrLen := length(AStr);
  FToken := GetNextChar;
  Result := exp;
  if FCurPos <> FInStrLen then
    RaiseError(eeExprOver);
end;

procedure TSmpExprCalc.RaiseError(AErrType: TExprErrorType);
begin
  FIsErr := TRUE;

  FLastErrorMsg := ExprErrorMsg[AErrType];
  FLastErrorType := AErrType;
  FLastErrorPos := FCurPos;

  if FCanRaiseError then
    raise Exception.CreateFmt('Expression: %s invalid at position %d!',[FExprStr,FCurPos]);
end;

function TSmpExprCalc.exp: Extended;
var
  temp: Extended;
begin
  if not FIsErr then
  begin
    temp := Term;
    while FToken in ['+','-'] do
    case (FToken) of
      '+':
        begin
          Match('+');
          temp := temp + Term;
        end;
      '-':
        begin
          Match('-');
          temp := temp - Term;
        end;
    end; //case
    Result := temp;
  end;
end;

function TSmpExprCalc.Factor: Extended;
var
  temp: Extended;
begin
  if not FIsErr then
    if FToken = '(' then
    begin
      Match('(');
      temp := exp;
      Match(')');
    end
    else if (FToken in ['0'..'9']) then
    begin
      temp := FindNum;
    end
    else
      RaiseError(eeExprBadExp);
  Result := temp;
end;

function TSmpExprCalc.FindNum: Extended;
var
  s: string;
begin
  if not FIsErr then
  begin
    s := FToken;
    FToken := GetNextChar;
    while FToken in ['0'..'9'] do
    begin
      s := s + FToken;
      FToken := GetNextChar;
    end; // END WHILE
    if FToken = '.' then
    begin
      s := s + '.';
      FToken := GetNextChar;
      while FToken in ['0'..'9'] do
      begin
        s := s + FToken;
        FToken := GetNextChar;
      end;
    end; // END IF '.'
    Result := StrToFloat(s);
    if FToken='%' then
    begin
      Match('%');
      Result := Result/100;
      FToken := GetNextChar;
    end; // END IF '%'
  end; // END IF NOT ERR
end;

function TSmpExprCalc.GetNextChar: char;
begin
  if FCurPos = FInStrLen then
    Result:=#0
  else begin
    inc(FCurPos);
    Result := FExprStr[FCurPos];
  end;
end;

procedure TSmpExprCalc.Match(AExpectedToken: Char);
begin
  if FToken= AExpectedToken then
    FToken := GetNextChar
  else FIsErr := TRUE;
end;

procedure TSmpExprCalc.Pre(var AStr: string);
var
  len, i: integer;
  temp: string;
begin
    AStr := trim(AStr);
    AStr := StringReplace(AStr, ')(', ')*(', [rfReplaceAll]);
    len := length(AStr);
    temp := AStr;
    for i := 1 to len-2 do
    begin
      if ((AStr[i] in ['0'..'9','.']) and (AStr[i+1] = '(')) then
        insert('*',temp,i+1);
    end;
    AStr := temp;
    len := length(AStr);
    for i := 1 to len-1 do
    begin
      if ((AStr[i] = ')') and (AStr[i+1] in ['0'..'9','.'])) then
        insert('*',temp,i+1);
    end;
    AStr := temp;
    len := length(AStr);
    for i := len-1 downto 1 do
    begin
      if (AStr[i] in ['+','-','*','/']) then
      begin
        if (AStr[i-1] in ['+','-','*','/']) then
        begin
           delete(temp,i-1,1) ;
        end;
      end;
    end; // END FOR
    AStr := temp;
end;

function TSmpExprCalc.Term: Extended;
var temp:Extended;
begin
  if not FIsErr then
  begin
    temp := Factor;
    while FToken in ['*','/'] do
    case (FToken) of
      '*':
        begin
          Match('*');
          temp := temp*Factor;
        end;
      '/':
        begin
          Match('/');
          temp := temp/Factor;
        end;
    end; //case
    result := temp;
  end;
end;

{ routines for properties }

function TSmpExprCalc.GetProcessed: boolean;
begin
  Result := not FIsErr;
end;

procedure TSmpExprCalc.SetCanRaiseError(const Value: boolean);
begin
  FCanRaiseError := Value;
end;

procedure TSmpExprCalc.SetExpression(const AStr: string);
begin
  FExpression := AStr;
  FValue := Do_Calc(FExpression);
end;

function TSmpExprCalc.GetAsInteger: integer;
begin
  Result := Round(FValue);
end;

procedure TSmpExprCalc.SetFormatStr(const Value: string);
begin
  { TODO : check validation }
  FFormatStr := Value;
end;

function TSmpExprCalc.GetAsString: string;
begin
  if FFormatStr = '' then FFormatStr := '%f';
  Result := Format(FFormatStr,[FValue]);
end;

end.
