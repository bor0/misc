program coords;
var A,B,C,x,y:real;
begin

write('A(x1,y1): ');
readln(x,y);
A:=sqrt((x*x)+(y*y));

write('B(x2,y2): ');
readln(x,y);
B:=sqrt((x*x)+(y*y));

write('C(x3,y3): ');
readln(x,y);
C:=sqrt((x*x)+(y*y));

writeln('A=',A:1:2,' B=',B:1:2, ' C=',C:1:2);

if A>B then if A>C then
writeln('Najodalecena tocka A so vrednost: ', A:1:2);
if B>A then if B>C then
writeln('Najodalecena tocka B so vrednost: ', B:1:2);
if C>A then if C>B then
writeln('Najodalecena tocka C so vrednost: ', C:1:2);

end.
