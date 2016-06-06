#include <setjmp.h>
#include <stdio.h>

#pragma region exception handling
#include <stdlib.h>
#define try if ((exception = setjmp(state)) == 0)
#define catch(exception) else switch(exception)
#define throw(exception) longjmp(state, exception)
int exception;
jmp_buf state;
enum { SOME_EXCEPTION = 1, DIVISION_BY_ZERO = 2 };
#pragma endregion

int main() {

	int a,b;

	printf("Enter a and b: ");
	scanf("%d%d", &a, &b);

	try {
		if (b == 0) throw(DIVISION_BY_ZERO);
		printf("The division result of a and b is: %f\n", (float)a/b);
	}
	catch (exception) {
		case SOME_EXCEPTION:						// catch SOME_EXCEPTION
			puts("Exception: SOME_EXCEPTION");
			break;
		case DIVISION_BY_ZERO:						// catch DIVISION_BY_ZERO
			puts("Exception: DIVISION_BY_ZERO");
			break;
		default:									// catch ...
			puts("Some strange exception");
	}
	return EXIT_SUCCESS;
}