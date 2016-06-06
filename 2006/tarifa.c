#include <stdio.h>

struct thetime {
int hour;
int minutes;
};

struct thetime counterfrom;
struct thetime counterto;

int timecount(struct thetime* from, struct thetime* to) {

int z=0;

while (from->hour != to->hour) {

if (from->hour == 24) from->hour = 0;

if (from->minutes == 59) {
from->hour++;
from->minutes = 0;
} else from->minutes++;

z++;

}

z += to->minutes - from->minutes;

return z;

}

int main() {

float a;
float b;
int c;

printf("Kolku denari se tarifira eden saat: ");
scanf("%f", &a);

a /= 60;

printf("Koga e pocnat korisnikot: ");
scanf("%d%d", &counterfrom.hour, &counterfrom.minutes);

printf("Koga e zavrsen korisnikot: ");
scanf("%d%d", &counterto.hour, &counterto.minutes);

c = timecount(&counterfrom, &counterto);

b = c*a;

printf("Korisnikot ima da plati %.2f denari\n", b);

printf("24 casa se tarifira %.2f denari\n", 1440*a);

return 0;

}
