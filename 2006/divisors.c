#include <stdio.h>

int d(int number) {
int i=1;
int temp = 0;

for (i=1;i<number+1;i++) { //+1 to divide the number itself

if ((number%i) == 0) {
        printf("%d\n", i);
        temp+=i;
}

}

return temp;
}

int main() {
int i=0;
printf("Show all divisors by BoR0\nInput number: ");

scanf("%d", &i);

i = d(i);

printf("Sigma(n) == sum(d(n)) = %d\n", i);

return 0;

}
