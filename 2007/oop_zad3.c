// Napisana od Boro Sitnikovski
// 23.03.2009 Vezba I

#include <stdio.h>

#define max 100

struct Rakometar {
char Ime[60];
char Prezime[60];
int Pozicija, Broj;
};

int Sortiraj(struct Rakometar a[], int Rakometari) {
struct Rakometar pomosna; int i,j;
for (i=0;i<Rakometari;i++)
for (j=0;j<Rakometari;j++)
if (a[i].Broj>a[j].Broj) {
pomosna = a[j];
a[j] = a[i];
a[i] = pomosna;
}

return 0;
}

main() {
struct Rakometar Rakometar[max];
int i,j;
i=0;
/*printf("Vnesi ime, prezime, pozicija, broj za rakometar %d: ", i+1);
scanf("%s%s", &Rakometar[i].Ime, &Rakometar[i].Prezime);
scanf("%d%d", &Rakometar[i].Pozicija, &Rakometar[i].Broj);
Sortiraj(Rakometar);
printf("%d\n", Rakometar[i].Pozicija);*/


printf("Kolku rakometari: ");
scanf("%d", &j);

for (i=0;i<j;i++) {
printf("Vnesi ime, prezime, pozicija, broj za rakometar %d: ", i+1);
scanf("%s%s", &Rakometar[i].Ime, &Rakometar[i].Prezime);
scanf("%d%d", &Rakometar[i].Pozicija, &Rakometar[i].Broj);
}

Sortiraj(Rakometar, j);

for (i=0;i<j;i++)
printf("%s %s %d %d\n", Rakometar[i].Ime, Rakometar[i].Prezime, Rakometar[i].Pozicija, Rakometar[i].Broj);


return;
}
