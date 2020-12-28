// Napisana od Boro Sitnikovski
// 23.03.2009 Vezba I

#include <stdio.h>

#define maxstd 100

struct Student; struct Nasoka; struct Fakultet;

struct Student {
char Ime[60];
char Prezime[60];
char Indeks[10];
struct Nasoka *a;
};

struct Nasoka {
char Ime[60];
char Institut[60];
char Tip[60];
struct Fakultet *a;
};

struct Fakultet {
char Ime[60];
char Mesto[60];
};

int nekojafja(struct Student a[], int x) {
int i;

for (i=0;i<x;i++)
printf("%s %s - %s\n", a[i].Ime, a[i].Prezime, a[i].a->a->Mesto);

return 0;
}

main() {
struct Student a[maxstd];
struct Nasoka b[maxstd];
struct Fakultet c[maxstd];
int i,j;
printf("Kolku studenti: ");
scanf("%d", &j);

for (i=0;i<j;i++) {
printf("Vnesi informacii za student br. %d\n\n", i+1);

a[i].a = &b[i];
b[i].a = &c[i];

printf("Vnesi ime i prezime i br na indeks na studentot: ");
scanf("%s%s%s", &a[i].Ime, &a[i].Prezime, &a[i].Indeks);

printf("Vnesi ime na nasoka, ime na institut i tip na studii (akademski/profesionalni): ");
scanf("%s%s%s", &b[i].Ime, &b[i].Institut, &b[i].Tip);

printf("Vnesi ime na fakultet i mesto: ");
scanf("%s%s", &c[i].Ime, &c[i].Mesto);

}

nekojafja(a, j);

return;
}
