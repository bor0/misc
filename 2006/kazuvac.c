#include <stdio.h>

int main() {
int i, lugje, counter, posleden;
int z;

FILE *pFile = fopen("kazuvaci.in", "r");
fscanf(pFile, "%d", &lugje);

int covek[lugje]; int kazano[lugje];

for (i=0;i<lugje;i++) fscanf(pFile, "%d", &covek[i]);

fclose(pFile);

for (i=0;i<lugje;i++) {
for (z=0;z<lugje;z++) kazano[z]=0;

posleden = covek[i] - 1; counter = 0;

while (1) {
if (kazano[posleden] == 1 || i == posleden || posleden > lugje) break;
kazano[posleden] = 1; posleden = covek[posleden] - 1;
counter++;
}

printf("Od %d doznaa %d\n", i+1, counter);
}

return 0;

}
