/*
# BSI 22.04.2013

FRACTRAN is a Turing-complete esoteric programming language invented by the mathematician John Conway.
A FRACTRAN program is an ordered list of positive fractions together with an initial positive integer input n.
The program is run by updating the integer n as follows:

1.    for the first fraction f in the list for which nf is an integer, replace n by nf
2.    repeat this rule until no fraction in the list produces an integer when multiplied by n, then halt.

*/

#include <stdio.h>
#include <malloc.h>
#include <math.h>

int parse_fractran(int input, int *array, int len) {
	int i = 0;
	double tmp;

	while (i < len) {
		tmp = input * array[2*i] / (float)array[2*i+1];
		if (ceilf(tmp) == tmp) {
			input = tmp;
			i = 0;
			continue;
		}
		i++;
	}

	return input;
}

int main() {
	int input, fracts, *array, i;
	printf("Enter input: ");
	scanf("%d", &input);
	printf("Enter number of fractions: ");
	scanf("%d", &fracts);
	array = (int *)malloc(sizeof(int) * fracts * 2);
	for (i = 0; i < fracts; i++) {
		printf("Enter 2 space separated numbers for fraction no. %d: ", i + 1);
		scanf("%d%d", &array[2*i], &array[2*i+1]);
	}
	printf("-> %d\n", parse_fractran(input, array, fracts));
	free(array);
	return 0;
}