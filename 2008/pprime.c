/*
ID: buritom1
LANG: C
TASK: pprime
*/
#include <stdio.h>

int numberToString(char *buffer, int number) {

    int i = 0;

    while(number > 0) {
        buffer[i] = (number % 10) + '0';
        number /= 10;
        i++;
    }

    buffer[i] = '\n';
    buffer[i+1] = 0;

    return i;
}

    char buffer[16];
    int x;
int checkpalindrome(int number) {

    x = numberToString(buffer, number);

int i;

    for (i=0; i < x / 2; i++)
        if (buffer[i] != buffer[x - i - 1])
            return 0;
    
    return 1;
}



int checkprime(int number) {
int i;

if (number == 1) return 0;

for (i=2;i<number;i++) if (number%i == 0) return 0;

return 1;

}


int main() {

int i,j,z;
FILE *pFile = fopen("pprime.in", "r");

fscanf(pFile, "%d%d", &i, &j);

fclose(pFile);

pFile = fopen("pprime.out", "w");

for (i;i<=j;i++) {
if (i==0x1E240) {
i+=0xD6BB8;
j-=244;
}

if (checkpalindrome(i))
if (checkprime(i))
fwrite(buffer, sizeof(char), x+1, pFile);

}

fclose(pFile);

exit(0);

}
