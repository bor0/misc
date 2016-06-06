#include <stdio.h>

struct a {
int x;
struct a *ab;
};


int main() {
int (*m)();
//different from int *(main)();
void *woohoo;
struct a pew;
struct a *pewp;

m = &main;

int *test = (int *)&pew;
pew.x = 29;
printf("%d\n", *test);

pew.ab = &pew;
pewp = &pew;
(*pewp).x = 8;
pewp->ab->x = 8;
(*(*pewp).ab).x = 8;

woohoo = m;
woohoo = &pew;

*(int*)woohoo = 8;
printf("%d\n", pewp->ab->x);

char *whoa = (char *)&pew;
*whoa = 'A';

printf("%d\n", pew.x);

return 0;
}