#include <stdio.h>

typedef struct person {
	char ime[20];
	char prezime[20];
} person;

int main() {
	char tmp[sizeof(person)];
	person *x = (person *)tmp;

	strcpy(x->ime, "Boro");
	strcpy(x->prezime, "Sitnikovski");

	printf("%s, %s\n", x->ime, x->prezime);

	*(char *)x = 'G';
	printf("%s, %s\n", x->ime, x->prezime);

	*(char *)x->ime = 'Z';
	printf("%s, %s\n", x->ime, x->prezime);

	*(char *)&(*x).ime = 'T';
	printf("%s, %s\n", x->ime, x->prezime);

	return 0;
}