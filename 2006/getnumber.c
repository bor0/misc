/* This program shows you the lowest
 * divisor and dividend of a given number.
 *
 * Example: mynumber=1.5;
 *          y=3, x=2; because 3/2=1.5;
 *
 * I wrote this program for a school task :)
 *
 * written by Bor0,  26.03.2006
 *
 */

#include <stdio.h>
#include <math.h>

int main() {

int x,y=0;
float z=0;
float mynumber=1.5;

for (x=1;;x++) {
z=mynumber*x;
if (!fmod(z, 1)) break;
}

y=z;

printf("%d/%d\n", y, x);

return 0;

}

