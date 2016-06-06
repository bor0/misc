#include <stdio.h>
#include <math.h>

#define T int

void dec2binstr(T x) {
	char a[33];
	T c = 1, i;
	for (i=sizeof(T)*8-1;i>=0;i--,c<<=1) a[i] = (x&c)?'1':'0'; a[sizeof(T)*8] = 0;
	for (i=0;i<sizeof(T)*8;i++) if (a[i] != '0') break;
	printf("%s\n", a+i);
}

int main() {
dec2binstr(400);
}