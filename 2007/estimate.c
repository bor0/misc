#include <stdio.h>

//28.05.2007 SITNIKOVSKI BORO

#define FUNC sqrt(3*x)

/* Int(sqrt(3x)dx)
u = 3x
du = 3dx
Int(1/3sqrt(u)du)
1/3 Int(u^(1/2)du)
(1/3)/(3/2) u^(3/2)
2/9 (3x)^(3/2)

2/9(3*7)^(3/2) - 2/9(3*3)^(3/2) = 15.38535324 for [3, 7]
*/

int main() {
float sum,x,b,c;

printf("Enter two numbers that will be the segment [a,b]\n");
scanf("%f%f", &x, &b);

if (b < x) {
printf("Error: b must be larger.\n");
return 0;
}

printf("Enter step (the smaller the more accurate) example: 0.001: ");
scanf("%f", &c);

if (c<0) {
printf("Error: c must be larger than 0.\n");
return 0;
}

sum = 0;

for (x;x<=b;x+=c) sum+=FUNC;

sum *= c;

printf("Rough estimation: %f\n", sum);

return 0;

}
