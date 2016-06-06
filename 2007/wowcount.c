/*
 970 dmg/29,38% (2938/10000) crit = 625 hit/1094 crit (762,7922)
1050 dmg/26,58% (2658/10000) crit = 654 hit/1146 crit (784,7736)
1078 dmg/24,71% (2471/10000) crit = 665 hit/1164 crit (788,3029)
*/

#include <stdio.h>

int main() {
int crit, i, x;
double damage;

srand(time(NULL));

damage = 0;

for (i=0;i<10000000;i++) {
if (rand()%10000 <= 2471) damage += 1164;
else damage += 665;
} damage/=10000000; printf("I: %f \
( 970 dmg/29,38% crit = 625 hit/1094 crit )\n", damage);

damage=0;

for (i=0;i<10000000;i++) {
if (rand()%10000 <= 2658) damage += 1146;
else damage += 654;
} damage/=10000000; printf("II: %f \
( 1050 dmg/26,58% crit = 654 hit/1146 crit )\n", damage);

damage=0;

for (i=0;i<10000000;i++) {
if (rand()%10000 <= 2938) damage += 1094;
else damage += 625;
} damage/=10000000; printf("III: %f \
( 1078 dmg/24,71% crit = 665 hit/1164 crit )\n", damage);

return 0;

}
