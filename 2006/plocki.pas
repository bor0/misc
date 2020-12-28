{Programa PLOCKI napisana od Sitnikovski Boro na 17/03/2006}
{D.S.U. "Koco Racin" - Skopje}

program plocki;
var
abc:array[1..6400] of integer;
i,j,suma:integer;
y1,y2,y3,y4:integer;
v,n:text;
label kraj;
begin

assign(v, 'plocki.in');
reset(v);

assign(n, 'plocki.out');
rewrite(n);

readln(v, j);
i:=0;

if (SeekEof(v)) then begin
{writeln(n, '1<=n<=80');}
goto kraj;
end;

while not Eof(v) do begin
i:=i+1;
readln(v, j);
end;

if i>=81 then begin
{writeln(n, '1<=n<=80');}
goto kraj;
end;

reset(v);
readln(v, j);

if i<>j then begin
{writeln(n, 'pomalce matrici najdeni od vnesenoto');}
goto kraj;
end;

suma:=0;

for i := 1 to j*j do read(v, abc[i]);

for i := 1 to (j-1)*(j-1)+j-2 do begin
if (i mod j = 0) then i:=i+1;

y1:=abc[i]; y2:=abc[i+1]; y3:=abc[i+j]; y4:=abc[i+j+1];

if (y1=0) and (y2=1) and (y3=5) and (y4=11) then suma:=suma+1;
if (y1=0) and (y2=1) and (y3=11) and (y4=5) then suma:=suma+1;
if (y1=0) and (y2=5) and (y3=1) and (y4=11) then suma:=suma+1;
if (y1=0) and (y2=5) and (y3=11) and (y4=1) then suma:=suma+1;
if (y1=0) and (y2=11) and (y3=5) and (y4=1) then suma:=suma+1;
if (y1=0) and (y2=11) and (y3=1) and (y4=5) then suma:=suma+1;
if (y1=1) and (y2=0) and (y3=5) and (y4=11) then suma:=suma+1;
if (y1=1) and (y2=0) and (y3=11) and (y4=5) then suma:=suma+1;
if (y1=1) and (y2=5) and (y3=0) and (y4=11) then suma:=suma+1;
if (y1=1) and (y2=5) and (y3=11) and (y4=0) then suma:=suma+1;
if (y1=1) and (y2=11) and (y3=5) and (y4=0) then suma:=suma+1;
if (y1=1) and (y2=11) and (y3=0) and (y4=5) then suma:=suma+1;
if (y1=5) and (y2=0) and (y3=1) and (y4=11) then suma:=suma+1;
if (y1=5) and (y2=0) and (y3=11) and (y4=1) then suma:=suma+1;
if (y1=5) and (y2=11) and (y3=0) and (y4=1) then suma:=suma+1;
if (y1=5) and (y2=11) and (y3=1) and (y4=0) then suma:=suma+1;
if (y1=5) and (y2=1) and (y3=11) and (y4=1) then suma:=suma+1;
if (y1=5) and (y2=1) and (y3=1) and (y4=11) then suma:=suma+1;
if (y1=11) and (y2=0) and (y3=1) and (y4=5) then suma:=suma+1;
if (y1=11) and (y2=0) and (y3=5) and (y4=1) then suma:=suma+1;
if (y1=11) and (y2=1) and (y3=0) and (y4=5) then suma:=suma+1;
if (y1=11) and (y2=1) and (y3=5) and (y4=0) then suma:=suma+1;
if (y1=11) and (y2=5) and (y3=1) and (y4=0) then suma:=suma+1;
if (y1=11) and (y2=5) and (y3=0) and (y4=1) then suma:=suma+1;
end;

Writeln(n, suma);

kraj:
close(v);
close(n);

end.