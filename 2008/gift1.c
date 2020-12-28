/*
ID: buritom1
LANG: C
TASK: gift1
*/
#include <stdio.h>

int main() {

char friend[10][16];
char tempone[16];
int friendmoney[10];
int i,z,x,y;
int x1,x2;

FILE *pFile = fopen("gift1.in", "r");
fscanf(pFile, "%d", &i);

for (z=0;z<i;z++) {
fscanf(pFile, "%s", friend[z]);
friendmoney[z]=0;
}


for (z=0;z<i;z++) {

fscanf(pFile, "%s", tempone);
fscanf(pFile, "%d%d", &x1,&x2);

if (x1==0) continue;

for (y=0;y<i;y++) if (strcmp(tempone, friend[y]) == 0) break;

friendmoney[y]-=x1;
friendmoney[y]+=x1%x2;

x1/=x2;

for (x=0;x<x2;x++) {

fscanf(pFile, "%s", tempone);

for (y=0;y<i;y++) if (strcmp(tempone, friend[y]) == 0) break;

friendmoney[y]+=x1;
}

}

fclose(pFile);

pFile = fopen("gift1.out", "w");

for (x=0;x<i;x++) fprintf(pFile, "%s %d\n", friend[x], friendmoney[x]);

fclose(pFile);

exit(0);

}
