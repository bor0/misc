#include <stdio.h>

// a silly try for large integer addition/subtraction
//written by bor0 04.07.2006

void add(char *buffer, int x) {

int z;

buffer[x]++;

for (z=x;z>=0;z--) {

if (buffer[z] >= '9'+1 && z != 0) {
buffer[z] = '0';
buffer[z-1]++;
} else break;
}

return;

}


void sub(char *buffer, int x) {

int z;

buffer[x]--;

for (z=x;z>=0;z--) {

if (buffer[z] <= '0'-1 && z != 0) {
buffer[z] = '9';
buffer[z-1]--;
} else break;
}

return;

}


int main() {
int x,i=0;
char mystring[] = "000004294967295";
x=strlen(mystring);x--;
printf("%s\n", mystring);
system("date");
for (i=0;i<0xFFFFFFFF;i++) add(mystring,x);
printf("Addition:\n%s\n", mystring);
system("date");

return 0;

}
