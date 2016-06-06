#include <stdio.h>

int main() {
int a,b,c,d,e,f;

f=0;

/*

Frlame dve kocki. Kolkava e verojatnosta da padne isti broj od dvete kocki ?

#1,1#;(1,2);(1,3);(1,4);(1,5);(1,6);
(2,1);#2,2#;(2,3);(2,4);(2,5);(2,6);
(3,1);(3,2);#3,3#;(3,4);(3,5);(3,6);
(4,1);(4,2);(4,3);#4,4#;(4,5);(4,6);
(5,1);(5,2);(5,3);(5,4);#5,5#;(5,6);
(6,1);(6,2);(6,3);(6,4);(6,5);#6,6#;

So dve kocki 6 od 36 frlanja.

*/

for (a=0;a<6;a++) for (b=0;b<6;b++) // vidi kolku moznosti ima
for (c=0;c<6;c++) for (d=0;d<6;d++) // so frlanje na cetiri kocki
for (e=0;e<6;e++) if ((a==b) && (b==c) && (c==d) && (d==e)) f++;

// 6^5=7776

printf("%d/7776\n", f);

return 0;

}
