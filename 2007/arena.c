#include <stdio.h>

int main() {
float rating;

printf("Enter your rating: ");
scanf("%f", &rating);

if (rating <= 1500) rating = 0.22 * rating + 14;
else rating = 1511.26/(1 + 1639.28 * exp(-0.00412*rating));

if (rating < 0) rating = 0;

printf("2v2: %.f\n3v3: %.f\n5v5: %.f\n", rating*0.76, rating*0.88, rating);

return 0;

}
