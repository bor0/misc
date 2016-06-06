#include <stdio.h>

/* Sitnikovski Boro, 04.06.2007
 Note: a is coprime to b if gcd(a,b) == 1
 or if they don't share no same divisor. */

float borogcd(float a, float b) {
float x,i;

if (a>b) x=b;
else x=a;

for (i=x;i>=1;i--)
if (fmod(a, i) == fmod(b, i) && fmod(b, i) == 0)
return i;

return 0;

}

int main() {
float p,q,n,phi,e,d;

printf("Enter prime number p: ");
scanf("%f", &p);

printf("Enter prime number q: ");
scanf("%f", &q);

n = p*q; phi = (p-1)*(q-1);

pickprime:
printf("Pick a co-prime to Phi (%.f): ", phi);
scanf("%f", &e);

if (borogcd(e,phi) != 1) {
printf("This is not a co-prime to Phi.\n");
goto pickprime;
}

d=1;
while(d++) if (fmod(d*e, phi) == 1) break;

printf("Public key: n=%.f, e=%.f\nExample of encryption: encrypt(X) := mod(X^%.f, %.f) (X<=%.f)\n", n, e, e, n, n);
printf("Private key: n=%.f, d=%.f\nExample of decryption: decrypt(Y) := mod(Y^%.f, %.f) (Y<=%.f)\n", n, d, d, n, n);

return 0;

}
