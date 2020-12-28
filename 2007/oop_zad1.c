// Napisana od Boro Sitnikovski
// 23.03.2009 Vezba I

#include <stdio.h>

struct Teme {
int x, y, z;
};

struct Kvadar {
struct Teme T[3];
};

int Kvadar_plostina(struct Kvadar a) {
return 2 * (a.T[1].x - a.T[0].x) * (a.T[1].y - a.T[0].y) + 2 * (a.T[1].x - a.T[0].x) * (a.T[2].z - a.T[1].z) + \
2 * (a.T[1].y - a.T[0].y) * (a.T[2].z - a.T[1].z);
}

int Kvadar_volumen(struct Kvadar a) {
return (a.T[1].x - a.T[0].x) * (a.T[1].y - a.T[0].y) * (a.T[2].z - a.T[1].z);
}

main() {

struct Kvadar a;

printf("Vnesi (x,y,z) soodvetno za T1: ");
scanf("%d%d%d", &a.T[0].x, &a.T[0].y, &a.T[0].z);

printf("Vnesi (x,y,z) soodvetno za T2: ");
scanf("%d%d%d", &a.T[1].x, &a.T[1].y, &a.T[1].z);

printf("Vnesi (x,y,z) soodvetno za T3: ");
scanf("%d%d%d", &a.T[2].x, &a.T[2].y, &a.T[2].z);

printf("Plostina: %d\nVolumen: %d\n", Kvadar_plostina(a), Kvadar_volumen(a));

return;
}
