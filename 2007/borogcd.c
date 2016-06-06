#include <stdio.h>

int borogcd(int a, int b) {
int x,i,temp;

if (a>b) x=b;
else x=a;

for (i=1;i<=x;i++)
if ((a%i) == (b%i) && (b%i) == 0)
temp=i;

return temp;

}

int main() {
int a,b;
printf("Enter two numbers: ");
scanf("%d", &a);
scanf("%d", &b);

printf("%d\n", borogcd(a,b));

return 0;

}
