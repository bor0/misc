//17.10.2009, Boro Sitnikovski
// Double-linked non-circular list
// Dvojno-verizna ne kruzna lista

#include <stdio.h>
#define Alociraj (struct Lista *)malloc(sizeof(struct Lista))

struct Lista {

	struct Lista *prev, *next;
	int info;

};

struct Lista* Lista_init(int n) {

	int i=0; struct Lista *a=0, *b=0, *c=0;

	if (n < 1) return 0;

	for (i;i<n;i++) {
		c = b;
		b = Alociraj;
		if (!a) a = b;
		(*b).prev = c; (*b).next = 0;
		if (c) (*c).next = b;
	}

	return a;

}

void Lista_free(struct Lista *a) {

	if ((*a).next) Lista_free((*a).next);
	free(a);

}

void Lista_scan(struct Lista *a) {

	while (a) {
		scanf("%d", &(*a).info);
		a = (*a).next;
	}

}

void Lista_print(struct Lista *a) {

	while (a) {
		printf("%d\n", (*a).info);
		a = (*a).next;
	}

}

int Lista_add(struct Lista *a, int n, int info) {

	int i=0; struct Lista *c;

	if (n < 1) return 0;

	while (i != n) {
		a = (*a).next;
		i++;
	}

	if (!(c = Alociraj)) return 0;

	(*c).prev = (*a).prev;
	(*c).next = a;
	(*c).info = info;

	(*a).prev = (*(*a).prev).next = c;

	return 1;

}

int Lista_del(struct Lista *a, int n) {

	int i=0; struct Lista *b;

	if (n < 1) return 0;

	while (i != n) {
		if (!a) return 0;
		a = (*a).next;
		i++;
	}

	b = (*a).next;

	(*(*a).prev).next = (*a).next;
	if (b) (*b).prev = (*a).prev;

	free(a);
	return 1;
}

struct Lista* Lista_find(struct Lista *a, int info) {

	while (a) {
		if ((*a).info == info) return a;
		a = (*a).next;
	}

	return 0;
}

int Lista_change(struct Lista *a, int n, int info) {

	int i=0;

	while (i != n) {
		a = (*a).next;
		if (!a) return 0;
		i++;
	}

	(*a).info = info;
	return 1;

}

int Lista_memorija(struct Lista *a) {

	int i=0;

	while (a) {
		i += sizeof(struct Lista);
		a = (*a).next;
	}

	return i;
}


int main() {
	struct Lista *start;

	start = Lista_init(3);
	Lista_scan(start);
	Lista_print(start);
	printf("----\n");
	Lista_add(start, 1, 50);
	Lista_print(start);
	printf("----\n");
	Lista_del(start, 1);
		Lista_print(start);
	printf("----\n");



	Lista_free(start);
	return 0;

}