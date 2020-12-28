/*
ID: buritom1
LANG: C
TASK: ride
*/
#include <stdio.h>

int checkride(char *buffer1, char *buffer2) {
int a,x,y;

a=strlen(buffer1); a--;
x=1;

for (a;a>=0;a--) x*=buffer1[a]-64;

a=strlen(buffer2); a--;
y=1;

for (a;a>=0;a--) y*=buffer2[a]-64;

if (x%47==y%47) return 1; //GO!

return 0; //STAY!

}

int main() {
char buffer1[8];
char buffer2[8];
char go[] = "GO\n";
char stay[] = "STAY\n";

FILE *pFile = fopen("ride.in", "r");

fscanf(pFile, "%s%s", buffer1, buffer2);

fclose(pFile);

pFile = fopen("ride.out", "w");

if (checkride(buffer1,buffer2)==1) {
fwrite(go, sizeof(char), strlen(go), pFile);
} else {
fwrite(stay, sizeof(char), strlen(stay), pFile);
}

fclose(pFile);

exit(0);

}

