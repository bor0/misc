#include <stdio.h>

#define INTERVAL_start -10
#define INTERVAL_end	10
#define LIMIT_rate	0.001
#define LIMIT_exp	cos(sin(a))

int main() {
float a,max,min;
int first=0;

for (a=INTERVAL_start;a<INTERVAL_end;a+=LIMIT_rate) {

if (isnan(LIMIT_exp) == 0) {
if (!first) {max=LIMIT_exp;min=max;first++;}
else if (LIMIT_exp > max) max = LIMIT_exp;
else if (LIMIT_exp < min) min = LIMIT_exp;
}

}

printf("Maximum of the function: %f\nMinimum of the function: %f\n", max, min);
return 0;

}
