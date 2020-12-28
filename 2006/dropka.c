#include <stdio.h>
#include <math.h>

int ix,l,m=0;
float j,xx=0;

FILE *output = 0;
FILE *pFile = 0;

int main() {
int x,y,i,q=0;
int a,b,c,d=0;
char buffer[128];
char tempbuff[64];

pFile = fopen("dropka.in", "r");
output = fopen("dropka.out", "w+");

if (ferror(pFile)) return 0;

fread(buffer, sizeof(char), 2, pFile);

x=buffer[0]-48;

if (x>=10) return 0;

y = fread(buffer, sizeof(char), 127, pFile);
buffer[y]=0;

for (q=0;;q++) {
if ((buffer[q] == '1') || (buffer[q] == '2') || (buffer[q] == '3')) break;
if ((buffer[q] == '4') || (buffer[q] == '5') || (buffer[q] == '6') || (buffer[q] == '7')) break;
if ((buffer[q] == '8') || (buffer[q] == '9') || (buffer[q] == '0')) break;
}

for (i=0;;i++) if ((buffer[i] == 32) || (buffer[i] == 9)) break;
buffer[i]=0;
a=pretvori(buffer+q, x);
i++; q=i;

for (q;;q++) if ((buffer[q] == 32) || (buffer[q] == 9)) break;
buffer[q]=0;
b=pretvori(buffer+i, x);
q++; i=q;

for (i;;i++) if ((buffer[i] == 32) || (buffer[i] == 9)) break;
buffer[i]=0;
c=pretvori(buffer+q, x);
i++; q=i;

for (q;;q++) if ((buffer[q] == 10) || (buffer[q] == 9)) break;
buffer[q]=0;
d=pretvori(buffer+i, x);

if ((a == 80200208) || (b == 80200208) || (c == 80200208) || (d == 80200208)) return 0;

j=a;
j/=b;

xx=c;
xx/=d;

j+=xx;

for (x=1;;x++) {
xx=j*x;
if (!fmod(xx, 1)) break;
}

y=xx;

sprintf(buffer, "%d/%d", y, x);

fwrite(buffer, sizeof(char), strlen(buffer), output); //upisi!

fclose(pFile);
fclose(output);

return 0;

}


int pretvori(char *broj, int k) {

l=0;
m=0;

if (k>=10) {
fwrite("GRESKA", sizeof(char), 6, output); //upisi!
//printf("Greska: 1<=n<=9\n");
fclose(pFile);
fclose(output);
return 80200208;
}

k--;

j=strlen(broj);

for (ix=0;ix<j;ix++) {
broj[ix]-=48;
if (broj[ix] > k) {
fwrite("GRESKA", sizeof(char), 6, output); //upisi!
//printf("Greska: pogresni brojki za ovoj sistem\n");
fclose(pFile);
fclose(output);
return 80200208;
}
}

k++;

for (j;;j--,m++) {

xx=pow(k, j-1);
ix=xx*broj[m];
l+=ix;

if (j==1) break;

}

return l;
}

