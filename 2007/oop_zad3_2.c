// Napisana od Boro Sitnikovski
// 23.03.2009 Vezba II

#include <stdio.h>

class Kvadar {

public:

class Teme {
public: int x, y, z;
};


Teme T[3];

int Kvadar_plostina() {
return 2 * (T[1].x - T[0].x) * (T[1].y - T[0].y) + 2 * (T[1].x - T[0].x) * (T[2].z - T[1].z) + \
2 * (T[1].y - T[0].y) * (T[2].z - T[1].z);
}

int Kvadar_volumen() {
return (T[1].x - T[0].x) * (T[1].y - T[0].y) * (T[2].z - T[1].z);
}

};

int main() {

Kvadar a;

printf("Vnesi (x,y,z) soodvetno za T1: ");
scanf("%d%d%d", &a.T[0].x, &a.T[0].y, &a.T[0].z);

printf("Vnesi (x,y,z) soodvetno za T2: ");
scanf("%d%d%d", &a.T[1].x, &a.T[1].y, &a.T[1].z);

printf("Vnesi (x,y,z) soodvetno za T3: ");
scanf("%d%d%d", &a.T[2].x, &a.T[2].y, &a.T[2].z);

printf("Plostina: %d\nVolumen: %d\n", a.Kvadar_plostina(), a.Kvadar_volumen());

return 0;
}
