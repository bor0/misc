#include <stdio.h>
 
main(int argc, char *argv[]) {
char niza[1024];
int acb=0, aacd=0, aabc=0, x=0, i;
FILE *dat;
 
if((dat=fopen(argv[1],"r"))==NULL) {
  fprintf(stderr,"Can't open %s",argv[1]);
  return(-1);
}
 
while(!feof(dat)) niza[x++] = fgetc(dat);
fclose(dat);

for (i=0;i<x;i++)
if (niza[i] == 'a' && niza[i+1] == 'c' && niza[i+2] == 'b') acb++;
else if (niza[i] == 'a' && niza[i+1] == 'a' && niza[i+2] == 'c' && niza[i+3] == 'd') aacd++;
else if (niza[i] == 'a' && niza[i+1] == 'a' && niza[i+2] == 'b' && niza[i+3] == 'c') aabc++;

printf("Number of appearances \"acb\" = %d, \"aacd\" = %d, \"aabc\" = %d.\n",acb,aacd,aabc);
return(0);
}

