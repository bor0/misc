// Napisana od Boro Sitnikovski, 07.09.2009

#include <stdio.h>

struct produkti {
	int hours;
	float rez1, rez2;
};

int main() {

	int brprodukti, i, x1, x2, x3;
	struct produkti **prod;

	printf("FarmVille Calc v1.0 by BoR0\n-=-=-=-=-=-=-=-=-=-=-=-=-=-\nHow many products: ");
	scanf("%d", &brprodukti);

	if (brprodukti <= 0) return 0;

	prod = malloc(sizeof(struct produkti *) * brprodukti);

	if (!prod) return 0;

	printf("\nFor every product there has to be entered exactly 4 integers.\nThis program is used for farms only.\n\
If you'd like to calculate the gains for something other than\nfarms, enter '-1' for the Coins (Buy) field.\n\n");

	for (i=0;i<brprodukti;i++) {

		prod[i] = malloc(sizeof(struct produkti));

		printf("(%d) Enter: Coins (Sell for), Hours (Harvest in), XP gain, Coins (Buy)\n", i+1);
		scanf("%d%d%d%d", &x1, &prod[i]->hours, &x2, &x3);

		if (prod[i]->hours == 0) {
			prod[i]->rez1 = 0;
			prod[i]->rez2 = 0;
		} else {
			prod[i]->rez1 = (float)(x1 - x3 - 15)/prod[i]->hours;
			prod[i]->rez2 = (float)(x2 + 1)/prod[i]->hours;
			if (x3 == -1) {
				prod[i]->rez2 -= 1.0/prod[i]->hours;
				prod[i]->rez1 += (float)(x3 + 15)/prod[i]->hours;
			}
		}
	}

	for (x1=x2=i=0,printf("\n");i<brprodukti;i++) {
		if (prod[i]->rez1 > prod[x1]->rez1) x1 = i;
		if (prod[i]->rez2 > prod[x2]->rez2) x2 = i;
		printf("(%d) %.2f Gold/h, %.2f XP/h\n", i+1, prod[i]->rez1, prod[i]->rez2);
	}

	for (i=0;i<brprodukti;i++) {
		if (prod[i]->rez1 == prod[x1]->rez1 && prod[i]->rez2 > prod[x1]->rez2) x1 = i;
		if (prod[i]->rez2 == prod[x2]->rez2 && prod[i]->rez1 > prod[x2]->rez1) x2 = i;
	}

	printf("\nThe product %d has most Gold/h gains (%.2f * %d = %.2f)\nThe product %d has most XP/h gains (%.2f * %d = %.2f)\n",\
	x1+1, prod[x1]->rez1, prod[x1]->hours, (float)prod[x1]->rez1*prod[x1]->hours, x2+1, prod[x2]->rez2, prod[x2]->hours, (float)prod[x2]->rez2*prod[x2]->hours);

	for (i=1,x1=0;i<brprodukti;i++) {
		if (prod[i]->rez1/prod[i]->rez2 > prod[i]->rez1/prod[i]->rez2) x1 = i;
		free(prod[i]);
	}

	free(prod);

	printf("The product %d has the best Gold/XP ratio.\n", x1+1);

	system("pause");

	return 0;

}
