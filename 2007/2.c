#include <stdio.h>

int main() {
int x,y,tocki,brojac;

printf("Kolku tocki? ");
scanf("%d", &tocki);

brojac=0;

while (tocki) {
printf("Vnesi x, y: ");
scanf("%d%d", &x, &y);

if (x>0 && y>0) brojac++;
tocki--;
}

printf("Vkupno %d tocki lezat vo vtoriot kvadrant.\n", brojac);

return 0;

}
