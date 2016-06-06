
//  written by bor0 01.sept.2006

#include <stdio.h>

#define MAX_INT   128
#define MAX_SIGNS 64
#define MAX_EXPR  512

float str2float(char *, int);
int doet(char);
int strlen(char *);


int i,x;
char buffer[MAX_EXPR];

float numbers[MAX_INT];
char sign[MAX_SIGNS];
int p=0;


float str2float(char *string, int length) {

float result=0;

int point=0;
float temp;
double c=1;
int z;


for (z=0;z<length;z++) {

if (point) {
if (string[z] == ' ') continue;
if (string[z] < 48 || string[z] > 57) return 0;
c*=10;
temp = (string[z]&0x0F); temp/=c;
result += temp;

continue;
}

if (string[z] == '.' || string[z] == ',') { point=1; continue; }
if (string[z] == ' ') continue;
if (string[z] < 48 || string[z] > 57) return 0;

result *= 10;
result += (string[z]&0x0F);

}

return result;

}


int lastspot=0;
int doet(char b) {

buffer[i] = 0;
numbers[p] = str2float(buffer+lastspot, strlen(buffer+lastspot));
sign[p++] = b;
buffer[i] = b;
lastspot=i+1;
return 0;
}


int main() {

float z;

fgets(buffer, MAX_EXPR, stdin);

x = strlen(buffer);

buffer[x-1] = 0;

for (i=0;i<x;i++) {

if (buffer[i] == '+') doet('+');
else if (buffer[i] == '-') doet('-');
else if (buffer[i] == '*') doet('*');
else if (buffer[i] == '/') doet('/');

}

doet('\\');

z=numbers[0];

for (i=0;i<p;i++) {
if (sign[i] == '+') z+=numbers[i+1];
else if (sign[i] == '-') z-=numbers[i+1];
else if (sign[i] == '*') z*=numbers[i+1];
else if (sign[i] == '/') z/=numbers[i+1];
}

printf("%.2f\n", z);

return 0;

}
