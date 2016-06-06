#include <stdio.h>

float knuth(float a, float n, float b) {
if (n == 1) return pow(a,b);
else if (b == 0) return 1;
else return knuth(a, n-1, knuth(a, n, b-1));

return 0;
}

int main() {
float a,b,c;

scanf("%f%f%f", &a,&b,&c);

printf("%f\n", knuth(a,b,c));

return 0;

}
