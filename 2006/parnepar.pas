{Programa PARNEPAR napisana od Sitnikovski Boro na 03/03/2006}
{D.S.U. "Koco Racin" - Skopje}

program PARNEPAR;
var

fajl,x1:string;
v,n:text;
x2,brojac:integer;
label kraj;

begin

assign(v, 'PARNEPAR.IN');
reset(v);

assign(n, 'PARNEPAR.OUT');
rewrite(n);

readln(v, x1);

if (SeekEof(v)) then begin
{WriteLn('Nizata treba da e pogolema ili ednakva na 1');}
goto kraj;
end;

readln(v, x1);

if (SeekEof(v)) then begin
{WriteLn('Nizata treba da e pogolema ili ednakva na 1');}
goto kraj;
end;

while not Eof(v) do begin
brojac:=brojac+1;
readln(v, x2);
end;

if brojac>=10001 then begin
{WriteLn('Nizata treba da e pomala ili ednakva na 10000');}
goto kraj;
end;

if brojac<>x1 then begin
{WriteLn('Pomalce elementi najdeni od vnesenoto');}
goto kraj;
end;

reset(v);
readln(v, x1);
readln(v, x2);

if (x1 = 'P') or (x1 = 'p') then begin

while not Eof(v) do begin
readln(v,x2);

if (x2 mod 2 = 0) then WriteLn(n, x2);
end;

end;


if (x1 = 'N') or (x1 = 'n') then begin

while not Eof(v) do begin
readln(v, x2);

if (x2 mod 2 <> 0) then WriteLn(n, x2);
end;

end;


kraj:close(v);
close(n);

ReadLn; {za pauza}

end.
