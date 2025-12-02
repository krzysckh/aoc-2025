{ -*- mode: pascal; pascal-indent-level: 2; compile-command: "fpc -o2 2.pas && ./2" -*- }
program day2;

{$mode objfpc}

uses
  Sysutils, Strutils, Types, Math;

type
  TRange = record
             beginning : int64; {from-to / begin-end is impossible because keywords}
             exodus    : int64;
           end;
function MakeRange(s : string) : TRange;
var
  arr : TStringDynArray;
  res : TRange;
begin
  arr := SplitString(s, '-');
  val(arr[0], res.beginning);
  val(arr[1], res.exodus);
  MakeRange := res;
end;

function IsOk(n : int64; i : int64) : boolean;
var
  v    : int64;
  chk  : int64;
begin
  v   := 10**i;
  chk := n mod v;

  if chk <> 0 then
    if floor(log10(chk)) <> i-1 then exit(true);

  while n <> 0 do
    begin
      if (n mod v) <> chk then exit(true);
      n := n div v;
    end;
  IsOk := false;
end;

var
  i      : int64;
  j      : int64;
  f      : TextFile;
  s      : array[0..6400] of char;
  it     : string;
  ranges : array of TRange;
  r      : TRange;
  p1     : int64;
  p2     : int64;
label
  next;
begin
  AssignFile(f, 'input');
  reset(f);
  readln(f, s);
  i := 0;
  p1 := 0;
  p2 := 0;
  for it in SplitString(s, ',') do
    begin
      insert(MakeRange(it), ranges, i);
      i := i + 1
    end;

  for r in ranges do
    for i := r.beginning to r.exodus do
    begin
      if i < 10 then goto next;
      if (floor(log10(i)) mod 2 = 1) and not IsOk(i, (floor(log10(i))+1) div 2) then
        p1 := p1 + i;

      for j := 1 to max(floor(log10(i))-1, 1) do
      begin
        if not IsOk(i, j) then
        begin
          p2 := p2 + i;
          goto next;
        end;
      end;
      next:
    end;

  writeln('p1: ', p1);
  writeln('p2: ', p2);
end.
