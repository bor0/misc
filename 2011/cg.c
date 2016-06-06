////////////////////////////////////////////
// Color Game by Boro Sitnikovski 04.08.2011
//

#include <stdio.h>
#include <time.h>

#define START 1000

int main() {
	int cg_played, cg_amount;
	int cg_rand, cg_playmoney=0, cg_gametype=3, cg_boja1=5, cg_boja2=5;
	FILE *f;

	f = fopen("cg.txt", "r");

	if (f == NULL) {
		cg_played = 1; cg_amount = START;
		f = fopen("cg.txt", "w");
		fprintf(f, "%d %d", cg_amount, cg_played);
	}
	else {
		fscanf(f, "%d%d", &cg_amount, &cg_played);
	}

	fclose(f);

	printf("[Igra br. %d] Momentalno imas raspolozlivi %d denari. [Obrt %d]\n", cg_played, cg_amount, cg_amount-START);

	if (cg_amount < 20) {
		printf("Nemozes da igras.\n");
		system("pause");
		return 0;
	}

	while (cg_playmoney > cg_amount || cg_playmoney < 20) {
		printf("Vnesi na kolku denari sakas da igras: ");
		scanf("%d", &cg_playmoney);
	}

	while (cg_gametype != 1 && cg_gametype != 2) {
		printf("Vnesi na kolku boi ke igras (1 ili 2): ");
		scanf("%d", &cg_gametype);
	}

	printf("1. CRVENA; 2. ZOLTA; 3. ZELENA; 4. PLAVA.\n");

	while (cg_boja1 != 1 && cg_boja1 != 2 && cg_boja1 != 3 && cg_boja1 != 4) {
		printf("Vnesi prva boja koja sakas da ja igras: ");
		scanf("%d", &cg_boja1);
	}

	if (cg_gametype == 2) while ((cg_boja2 != 1 && cg_boja2 != 2 && cg_boja2 != 3 && cg_boja2 != 4) || cg_boja2 == cg_boja1) {
			printf("Vnesi vtora boja koja sakas da ja igras: ");
			scanf("%d", &cg_boja2);
	}

	printf("------------------------------------------------\n");

	cg_rand = (time(NULL)%4) + 1;

	switch (cg_rand) {
		case 1:	printf("Se padna CRVENA boja. "); break;
		case 2: printf("Se padna ZOLTA boja. "); break;
		case 3: printf("Se padna ZELENA boja. "); break;
		case 4: printf("Se padna PLAVA boja. "); break;
	}

	cg_amount -= cg_playmoney;

	if (cg_boja1 == cg_rand || cg_boja2 == cg_rand) {
		if (cg_gametype == 2) cg_playmoney *= 2;
		else cg_playmoney *= 4;
		printf("Dobitnik si na %d denari.\n", cg_playmoney);
		cg_amount += cg_playmoney;
	}
	else {
		printf("Izgubi %d denari.\n", cg_playmoney);
	}

	f = fopen("cg.txt", "w");
	fprintf(f, "%d %d", cg_amount, cg_played+1);
	fclose(f);

	system("pause");
	return 0;
}
