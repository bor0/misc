#include <stdio.h>

int proverizbor(char *a) {
int k=strlen(a);
int i;

for (i=0;i<k;i++)
if (((a[i]>='A' && a[i]<='Z') || (a[i]>='a' && a[i]<='z')) == 0) return 0;

return 1;
}

int main(int argc, char *argv[]) {
char c; int i,k,brojac,redovi,zbor;
char niza[80], temp[80];
i=0;redovi=0;zbor=0;

FILE *dat;
if ((dat=fopen(argv[1], "r")) == NULL) {
fprintf(stderr, "Ne mozam da ja otvoram datotekata %s", argv[1]);
return (-1);
}

while((c=fgetc(dat))!=EOF)
if (c != 13 && c != 10) niza[i++] = c;
else {
brojac=0;
niza[i] = ' '; niza[++i]=0;

for (k=0;k<i;k++) {

if (niza[k] == ' ') {
niza[k]=0;
strcpy(temp, niza+brojac);
printf("Zbor %s (%d)\n", temp, proverizbor(temp));
if (proverizbor(temp) == 1) zbor++;
niza[k]=' '; brojac=k+1;
}

}

if (zbor <= 10) redovi++;

zbor=0;
i=0;
}

printf("Vkupno takvi redovi ima %d\n", redovi);

return (0);
}
