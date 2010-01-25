unit BMSearch;

(* -------------------------------------------------------------------

����� ������ ������� Boyer-Moore.

��� - ���� �� ����� ������� ���������� ������ ������.
See a description in:

R. Boyer � S. Moore.
������� �������� ������ ������.
Communications of the ACM 20, 1977, �������� 762-772
------------------------------------------------------------------- *)

interface

type
{$IFDEF WINDOWS}

  size_t = Word;
{$ELSE}

  size_t = LongInt;
{$ENDIF}

type

  TTranslationTable = array[char] of char; { ������� �������� }

  TSearchBM = class(TObject)
  private
    FTranslate: TTranslationTable; { ������� �������� }
    FJumpTable: array[char] of Byte; { ������� ��������� }
    FShift_1: integer;
    FPattern: pchar;
    FPatternLen: size_t;

  public
    procedure Prepare(Pattern: pchar; PatternLen: size_t; IgnoreCase: Boolean);
    procedure PrepareStr(const Pattern: string; IgnoreCase: Boolean);

    function Search(Text: pchar; TextLen: size_t): pchar;
    function Pos(const S: string): integer;
  end;

implementation

uses SysUtils;

(* -------------------------------------------------------------------

���������� ������� ������� ��������
------------------------------------------------------------------- *)

procedure CreateTranslationTable(var T: TTranslationTable; IgnoreCase: Boolean);
var

  c: char;
begin

  for c := #0 to #255 do
    T[c] := c;

  if not IgnoreCase then
    exit;

  for c := 'a' to 'z' do
    T[c] := UpCase(c);

  { ��������� ��� ������ ������� � �� ������������ �������� �������� }

  T['�'] := 'A';
  T['�'] := 'A';
  T['�'] := 'A';
  T['�'] := 'A';

  T['�'] := 'A';
  T['�'] := 'A';
  T['�'] := 'A';
  T['�'] := 'A';

  T['�'] := 'E';
  T['�'] := 'E';
  T['�'] := 'E';
  T['�'] := 'E';

  T['�'] := 'E';
  T['�'] := 'E';
  T['�'] := 'E';
  T['�'] := 'E';

  T['�'] := 'I';
  T['�'] := 'I';
  T['�'] := 'I';
  T['�'] := 'I';

  T['�'] := 'I';
  T['�'] := 'I';
  T['�'] := 'I';
  T['�'] := 'I';

  T['�'] := 'O';
  T['�'] := 'O';
  T['�'] := 'O';
  T['�'] := 'O';

  T['�'] := 'O';
  T['�'] := 'O';
  T['�'] := 'O';
  T['�'] := 'O';

  T['�'] := 'U';
  T['�'] := 'U';
  T['�'] := 'U';
  T['�'] := 'U';

  T['�'] := 'U';
  T['�'] := 'U';
  T['�'] := 'U';
  T['�'] := 'U';

  T['�'] := '�';
end;

(* -------------------------------------------------------------------

���������� ������� ���������
------------------------------------------------------------------- *)

procedure TSearchBM.Prepare(Pattern: pchar; PatternLen: size_t;

  IgnoreCase: Boolean);
var

  i: integer;
  c, lastc: char;
begin

  FPattern := Pattern;
  FPatternLen := PatternLen;

  if FPatternLen < 1 then
    FPatternLen := strlen(FPattern);

  { ������ �������� ���������� �� ������ �� 256 �������� }

  if FPatternLen > 256 then
    exit;

  { 1. ���������� ������� �������� }

  CreateTranslationTable(FTranslate, IgnoreCase);

  { 2. ���������� ������� ��������� }

  for c := #0 to #255 do
    FJumpTable[c] := FPatternLen;

  for i := FPatternLen - 1 downto 0 do
  begin
    c := FTranslate[FPattern[i]];
    if FJumpTable[c] >= FPatternLen - 1 then
      FJumpTable[c] := FPatternLen - 1 - i;
  end;

  FShift_1 := FPatternLen - 1;
  lastc := FTranslate[Pattern[FPatternLen - 1]];

  for i := FPatternLen - 2 downto 0 do
    if FTranslate[FPattern[i]] = lastc then
    begin
      FShift_1 := FPatternLen - 1 - i;
      break;
    end;

  if FShift_1 = 0 then
    FShift_1 := 1;
end;

procedure TSearchBM.PrepareStr(const Pattern: string; IgnoreCase: Boolean);
var

  str: pchar;
begin

  if Pattern <> '' then
  begin
{$IFDEF Windows}

    str := @Pattern[1];
{$ELSE}

    str := pchar(Pattern);
{$ENDIF}

    Prepare(str, Length(Pattern), IgnoreCase);
  end;
end;

{ ����� ���������� ������� & �������� ������ ������ }

function TSearchBM.Search(Text: pchar; TextLen: size_t): pchar;
var

  shift, m1, j: integer;
  jumps: size_t;
begin

  result := nil;
  if FPatternLen > 256 then
    exit;

  if TextLen < 1 then
    TextLen := strlen(Text);

  m1 := FPatternLen - 1;
  shift := 0;
  jumps := 0;

  { ����� ���������� ������� }

  while jumps <= TextLen do
  begin
    Inc(Text, shift);
    shift := FJumpTable[FTranslate[Text^]];
    while shift <> 0 do
    begin
      Inc(jumps, shift);
      if jumps > TextLen then
        exit;

      Inc(Text, shift);
      shift := FJumpTable[FTranslate[Text^]];
    end;

    { ���������� ������ ������ FPatternLen - 1 �������� }

    if jumps >= m1 then
    begin
      j := 0;
      while FTranslate[FPattern[m1 - j]] = FTranslate[(Text - j)^] do
      begin
        Inc(j);
        if j = FPatternLen then
        begin
          result := Text - m1;
          exit;
        end;
      end;
    end;

    shift := FShift_1;
    Inc(jumps, shift);
  end;
end;

function TSearchBM.Pos(const S: string): integer;
var

  str, p: pchar;
begin

  result := 0;
  if S <> '' then
  begin
{$IFDEF Windows}

    str := @S[1];
{$ELSE}

    str := pchar(S);
{$ENDIF}

    p := Search(str, Length(S));
    if p <> nil then
      result := 1 + p - str;
  end;
end;

end.