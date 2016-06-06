// bruteforcer for
// Find all positive integer pairs (a,n) such that
//  (((a+1)^n - a^n) / n)   is an integer.

#include <stdio.h>

int main() {
int a=0; int n=0; float x=0;

for (a=0;a<65536;a++) {

	for (n=1;n<100;n++) {
		x=(pow((a+1), n) - pow(a, n))/n;
		if (fmod(x, 1) == 0.0) printf("Valid solution: a=%d;n=%d\n", a,n);
	}

}

return 0;

}
