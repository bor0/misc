#include <stdio.h>

void shift_niza(int array[], int length, int place) {
int i;

for (i=0;i<length-place+1;i++) array[length-i] = array[length-i-1];

array[place-1]=0;

return;

}

int main() {
int niza[10] = { 1, 2, 3, 4 };

printf("Pred:\n");
printf("%d %d %d %d %d\n", niza[0],niza[1],niza[2],niza[3],niza[4]);

shift_niza(niza, 4, 3);

printf("Posle:\n");
printf("%d %d %d %d %d\n", niza[0],niza[1],niza[2],niza[3],niza[4]);

return 0;

}
