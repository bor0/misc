#include <stdio.h>

// reference: http://stackoverflow.com/questions/1635827/how-would-one-implement-lazy-evaluation-in-c

typedef struct s_generator {
	int current;
	int (*func)(int);
} generator;

int next(generator* gen) {
	int result = gen->current;
	gen->current = (gen->func)(gen->current);
	return result;
}
 
int next_multiple(int current) {
	return 2 + current;
}

int main() {
	generator multiples_of_2 = { 0, next_multiple };
	int i;

	for (i = 0; i < 5; i++) {
		// eval next
		next(&multiples_of_2);
		printf("%d\n", multiples_of_2.current);
	} 
	return 0;
}
