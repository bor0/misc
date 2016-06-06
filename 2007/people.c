// Written by Bor0, 03.02.2007

/* 100 people are standing in a line and they are required to count off in fives as 'one, two, three, four, five, one, 
two three, four, five' and so on from the first person in the line. Anyone who counts 5 is out. Those remaining repeat 
this procedure until only 4 remain. What was the original position in the line of the last person to leave? */

#include <stdio.h>

int people[100];
int counter = 100;

int main() {
int i;
int p=1;

for (i=0;i<=99;i++) people[i] = i+1;

while (counter != 4) {

printf("=========================\n");
for (i=1;i<=100;i++,p++) {
if (people[i-1] == 0) {
p--;
continue;
}
else if (p%5 == 0) {
printf("Human no. %d leaves.\n", people[i-1]);
people[i-1] = 0; counter--;
}
else printf("Human no. %d stays.\n", people[i-1]);
}
printf("=========================\n");

}

return 0;

}
