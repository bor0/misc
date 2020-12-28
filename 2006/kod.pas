{Programa KOD napisana od Sitnikovski Boro na 17/03/2006}
{D.S.U. "Koco Racin" - Skopje}

program kod;
var
v,n:text;
x1,brojac:integer;
dolzina:integer;
temp:char;
stringce:string[255];
label kraj;
label krajloop;

function ProveriDuplikat(borozver:string):integer;

{ Ovaa funkcija e PEKOL! Mi trebaa odprilika 30 minuti
  da ja sortiram ^^. Kako i da e, mislam deka treba da
  raboti. =) }

var
x,y:integer;
x2,suma:integer;
begin
y:=Length(borozver)+1;
x:=1;
while (x<>y) do begin
temp:=borozver[x];
x2:=1;
suma:=0;
while (x2<>y) do begin
if (temp=borozver[x2]) then suma:=suma+1;
x2:=x2+1;
end;
if (suma>=2) then begin
ProveriDuplikat:=0;
Exit;
end;
x:=x+1;
end;
ProveriDuplikat:=1;
end;

{POCETOK}{POCETOK}{POCETOK}{POCETOK}

begin

assign(v, 'KOD.IN');
reset(v);

assign(n, 'KOD.OUT');
rewrite(n);

readln(v, x1);

if (SeekEof(v)) then begin
{WriteLn('Nizata treba da e pogolema ili ednakva na 1');}
goto kraj;
end;

while not Eof(v) do begin
brojac:=brojac+1;
readln(v, x1);
end;

if brojac>=1001 then begin
{WriteLn(n, 'Nizata treba da e pomala ili ednakva na 1000');}
goto kraj;
end;

reset(v);
readln(v, x1);

if x1<>brojac then begin
{WriteLn(n, 'Pomalce linii najdeni od dadenoto.);}
goto kraj;
end;

brojac:=0;

while (brojac<>x1) do begin

readln(v, dolzina, temp, stringce);

if (dolzina <> Length(stringce)) then begin
WriteLn(n, 'NE');
goto krajloop;
end;

if (dolzina>=251) then begin
WriteLn(n, 'NE');
goto krajloop;
end;

if (ProveriDuplikat(stringce) = 0) then begin
WriteLn(n, 'NE');
end else
WriteLn(n, 'DA');

krajloop:
brojac:=brojac+1;
end;

kraj:
close(v);
close(n);
end.