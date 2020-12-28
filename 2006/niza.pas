{Programa NIZA napisana od Sitnikovski Boro na 10/03/2006}
{D.S.U. "Koco Racin" - Skopje}

program NIZA;

var
v,n:text;
x1,x2,brojac,i:integer;
label kraj,dosta;

begin

assign(v, 'NIZA.IN');
reset(v);

assign(n, 'NIZA.OUT');
rewrite(n);

readln(v, x1);

if (SeekEof(v)) then begin
{writeln(n, '1<n<10000');}
goto kraj;
end;

while not Eof(v) do begin
brojac:=brojac+1;
readln(v, x1);
end;

if brojac>=10001 then begin
{writeln(n, '1<n<10000');}
goto kraj;
end;

reset(v);
readln(v, x1);

if brojac<>x1 then begin
{writeln(n, 'pomalce kukji najdeni od vnesenoto');}
goto kraj;
end;

brojac:=1;

readln(v, x2);

{glaven algoritam ovde}

while (x1<>x2) do begin

if (x2<x1) then begin
brojac:=0;
goto dosta;
end;

readln(v, brojac);

x2:=x2+brojac;
x1:=x1+1;

end;

dosta:
if (brojac=0) then begin
WriteLn(n, 'ne');
end
else begin
WriteLn(n, 'da');
end;

kraj:
close(v);
close(n);

end.
