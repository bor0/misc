#include <stdio.h>

// written Aug.19.2006 by Bor0

int shr(char *a, int b) {

for (b;b>=0;b--) {
a[b+1] = a[b];
}
a[0] = '0';

return 0;

}

int balancestrings(char *a, char *b) {
int sza,szb,i,x;

sza=strlen(a);
szb=strlen(b);

if (sza>szb) {
x=szb;
for (i=0;i<sza-szb;i++) {
shr(b, x);
x++;
}
return sza;
} else if (sza<szb) {
x=sza;
for (i=0;i<szb-sza;i++) {
shr(a, x);
x++;
}
return szb;
}

return 0;

}

int sub(char *c, char *a, char *b, int len) {
int i,x,z;

x=0;

for (i=len;i>=0;i--) {

z = (a[i] - b[i]);

if (z == 0 && x == 0) {
c[i] = '0';
continue;
}

if (x == 1) { //borrow
z--;
x=0;
}

if (z < 0 && i != 0) {
z += 10;
x=1;
}

c[i] = z+48;

}

return x;

}

int add(char *c, char *a, char *b, int len) {
int i,x,z;

x=0;

for (i=len;i>=0;i--) {

z = (a[i] + b[i]) - 96;

if (x == 1) { //carry
z++;
x=0;
}

if (z >= 10) {
z -= 10;
x=1;
}

c[i] = z+48;

}

return x;

}

int main() {

char a[128000];
char b[128000];
char c[128000];

int len;
int x;

scanf("%s", &a);
scanf("%s", &b);

len = balancestrings(a,b);

/*if (len != 0) {
x = add(c,a,b,len);
c[len] = 0;
} else {
len = strlen(a);
x = add(c,a,b,len);
c[len] = 0;
}

if (x) {
printf("%c", '1');
}

*/
if (len != 0) {
x = sub(c,a,b,len);
c[len] = 0;
} else {
len = strlen(a);
x = sub(c,a,b,len);
c[len] = 0;
}

if (x) printf("Subtration may not be correct, a>b.\n");

printf("%s\n", c);

return 0;

}
