#include <stdio.h>

int proveridup(char *moo) {

int x,y,suma,loop=0;
char tempa;

x=strlen(moo);

suma=0;

for (loop=0; loop<x; loop++) {

tempa=moo[loop];

for (y=0;y<x;y++) if (tempa==moo[y]) suma++;

suma--;

if (suma!=0) return 0;

}

return 1;

}

int main() {
char string[] = "ruse";

printf("%d\n", proveridup(string));

return 1;
}
