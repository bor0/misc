#include <stdio.h>
#include <math.h>

int main() {

float a,b,c=0;

float discriminant=0;
float temp=0;

printf("Quadrat equation calculator by BoR0\n-----------------------------------\n\
Example: ax^2+bx+c=0\n--------------------\nEnter value for a: ");

scanf("%f", &a);
printf("Enter value for b: ");
scanf("%f", &b);
printf("Enter value for c: ");
scanf("%f", &c);

discriminant = (b*b)-(4*a*c);

if (discriminant <= 0) {
printf("Discriminant receives a negative value, can't take SQRT of that. Exiting...\n");
return 0;
}

printf("\nDiscriminant D = b^2-4*a*c = %f\n\nQuadratic Equation \
Formula: (-b +/- sqrt(D)) / 2a", discriminant);

discriminant = sqrt(discriminant);

b *= -1;

a*=2;

printf("\n\n%f +/- %f / %f\n", b, discriminant, a);

temp = (b+discriminant);
temp /= a;
printf("\nx1=%f", temp);

temp = (b-discriminant);
temp /= a;
printf("\nx2=%f\n", temp);

printf("\nAll done.\n");

return 0;

}
