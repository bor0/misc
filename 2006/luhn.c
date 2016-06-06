/*\
 *
 * Credit Card Check using the Luhn formula
 *
 * if success it returns 0, otherwise fails
 *
 *
 * written by BoR0, January 2006
 *
\*/

int checkcc(char *ccnum_digits) {

char ccnum_evendigit[16];
int sum=0; int j=0; int i=0;

for (i=0;i<8;i++,j+=2) {
ccnum_evendigit[i] = ccnum_digits[j]-48;
if (2*ccnum_evendigit[i] > 9) sum-=9;
sum += 2*ccnum_evendigit[i];
}

for (i=1;i<16;i+=2) sum += ccnum_digits[i]-48;

return ((sum / 10 + 1) * 10 - sum)%10;

}
