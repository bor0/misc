{Programa PIN napisana od Sitnikovski Boro na 10/03/2006}
{D.S.U. "Koco Racin" - Skopje}

{Mozebi ke bese podobro i polesno da rabotev so string array,
 no sepak se odluciv da rabotam so integers. ;-)}

program PIN;

var

v,n:text;

x1,x2,brojac:integer;

a1,a2,a3,a4:integer;
b1,b2,b3,b4:integer;

pogodicif:integer;

label kraj;

begin

assign(v, 'PIN.IN');
reset(v);

assign(n, 'PIN.OUT');
rewrite(n);

readln(v, a1);
readln(v, x1); {odma na vtora linija}

if (SeekEof(v)) then begin
{writeln(n, '1<n<1000');}
goto kraj;
end;

while not Eof(v) do begin
brojac:=brojac+1;
readln(v, x1);
end;

if brojac>=1001 then begin
{writeln(n, '1<n<1000');}
goto kraj;
end;

reset(v);
readln(v, a1);
readln(v, x1);

if brojac<>x1 then begin
{writeln(n, 'pomalce pinovi najdeni od vnesenoto');}
goto kraj;
end;

a2:=(a1 mod 1000) div 100;
a3:=(a1 mod 100) div 10;
a4:=(a1 mod 100) mod 10;
a1:=a1 div 1000;

while (x1<>x2) do begin

pogodicif:=0;
brojac:=0;

readln(v, b1);

b2:=(b1 mod 1000) div 100;
b3:=(b1 mod 100) div 10;
b4:=(b1 mod 100) mod 10;
b1:=b1 div 1000;

if (a1 = b1) then begin
pogodicif:=pogodicif+1;
brojac:=brojac+1;
end;
if (a2 = b1) then pogodicif:=pogodicif+1;
if (a3 = b1) then pogodicif:=pogodicif+1;
if (a4 = b1) then pogodicif:=pogodicif+1;

if (a1 = b2) then pogodicif:=pogodicif+1;
if (a2 = b2) then begin
pogodicif:=pogodicif+1;
brojac:=brojac+1;
end;
if (a3 = b2) then pogodicif:=pogodicif+1;
if (a4 = b2) then pogodicif:=pogodicif+1;

if (a1 = b3) then pogodicif:=pogodicif+1;
if (a2 = b3) then pogodicif:=pogodicif+1;
if (a3 = b3) then begin
pogodicif:=pogodicif+1;
brojac:=brojac+1;
end;
if (a4 = b3) then pogodicif:=pogodicif+1;

if (a1 = b4) then pogodicif:=pogodicif+1;
if (a2 = b4) then pogodicif:=pogodicif+1;
if (a3 = b4) then pogodicif:=pogodicif+1;
if (a4 = b4) then begin
pogodicif:=pogodicif+1;
brojac:=brojac+1;
end;

writeln(n, 'Imate pogodeno ', pogodicif, ' cifri od koi ', brojac, ' se na svoeto mesto.');

x2:=x2+1;

end;

kraj:
close(v);
close(n);

end.
