#include <stdio.h>

// written by BoR0
// 14/06/2007

int main() {
char niza[20];
char bukvi[26] = {0};
int i, a;

scanf("%s", &niza);
printf("Sega rabotam na nizata %s\n\n", niza);

i=0; a=0;

while (niza[i] != 0) {

if (bukvi[niza[i]-97] == 1) { //se povtori bukva
printf("Razlika najdov od %d do %d (%d)\n", a, i-1, i-a);
for (a=0;a<26;a++) bukvi[a] = 0; //initialize everything back to 0
a=i; continue;
}

bukvi[niza[i]-97] = 1;
i++;
}

if (a != i-1) printf("Razlika najdov od %d do %d (%d)\n", a, i-1, i-a);

return 0;

}
