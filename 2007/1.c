#include <stdio.h>

int greska(char *a) {
printf("Studentot ne dobiva stipendija: %s\n", a);
return 0;
}

int main() {
float prosek; int godina; char stipendija[10];

printf("Vnesi prosek: ");
scanf("%f", &prosek);

if (prosek<8.5) return greska("Nevaliden prosek.");

printf("Vnesi godina: ");
scanf("%d", &godina);

if (godina<2 && godina>4) return greska("Nevalidna godina.");

printf("Dali studentot prima drug vid na stipendija? (D/N) ");
scanf("%s", &stipendija);

if (stipendija[0] == 'D' || stipendija[0] == 'd')
return greska("Ne smee da dobiva drug vid stipendija.");

printf("Studentot dobiva drzavna stipendija.\n");

return 0;

}
