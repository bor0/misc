#include <stdio.h>

typedef int StackType;

typedef struct Stack {
	StackType data;
	struct Stack *prev;
} Stack, *Stackp;

Stackp StackTop = 0;

int StackPop() {
	Stackp Prev;
	if (!StackTop) return -1;
	Prev = (*StackTop).prev;
	free(StackTop);
	StackTop = Prev;
	return 1;
}

void StackPush(StackType a) {
	Stackp temp;
	temp = (Stackp)malloc(sizeof(Stack));
	(*temp).prev = StackTop;
	(*temp).data = a;
	StackTop = temp;
}

Stackp StackTopP() {
	if (!StackTop) return (Stackp)-1;
	return StackTop;
}

StackType StackTopI() {
	if (!StackTop) return -1;
	return (*StackTop).data;
}


int main() {
	int i,n,x; StackType temp;

	printf("How many pushes do you need? ");
	scanf("%d", &n);

	for (i=0;i<n;i++) {
		printf("Enter integer no. %d: ", i+1);
		scanf("%d", &x);
		StackPush((StackType)x);
		printf("Pushed.\n");
	}

	while (1) {
		temp = StackTopI();
		if (StackPop() == -1) break;
		printf("Popping... %d\n", temp);
	}

	printf("Reached underflow.\n");

	return 0;
}