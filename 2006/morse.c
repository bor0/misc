#include <stdio.h>

/*
 * On every page I looked for morse code the codes were different,
 * my program is based on the codes that are found on the webpage:
 *
 * http://morsecode.scphillips.com/morse.html
 *
 *
 * CODES NOTE:
 *
 * To indicate that a mistake has been made and for the receiver to
 * delete the last word send ........ (eight dots).
 *
 *
 * Program done by Bor0, 09.04.2006
 *
 */


char *morse[] = { ".-", "-...", "-.-.", "-..", ".", "..-.",
"--.", "....", "..", ".---", "-.-", ".-..", "--", "-.", "---",
".--.", "--.-", ".-.", "...", "-", "..-", "...-", ".--", "-..-",
"-.--", "--..", "-----", ".----", "..---", "...--", "....-", ".....",
"-....", "--...", "---..", "----.", ".-.-.-", "--..--", "---...",
"..--..", ".----.", "-....-", "-..-.", ".-..-.", ".--.-.", "-...-" };

char morse2[] = { "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,:?'-/\"@=" };

int z=0;

int morsetotext(char *buffer) {

for (z=0;z<=45;z++) if (strcmp(buffer, morse[z]) == 0) return morse2[z];

return 0;

}

int texttomorse(char a, char *buffer) {

for (z=0;z<=45;z++) {
if (a == morse2[z]) {
strcpy(buffer, morse[z]);
return 1;
}
}

for (z=0;z<=26;z++) {
if (a == morse2[z]+32) {
strcpy(buffer, morse[z]);
return 1;
}
}

return 0;

}

int main() {
char buffer[512]; char buffer2[8];
int i=0;int j=0;int k=0;

printf("Morse encoder/decoder v1.0 by Bor0\n\n Enter option:\n 1) Encode\n 2) Decode\n\n Option: ");
fgets(buffer, 2, stdin);
printf("\n");
rewind(stdin);

if (buffer[i] == '1') {
printf("Enter morse string (ENCODE):\n");
fgets(buffer, 511, stdin);
k=strlen(buffer);

buffer[k-1] = '\0';

for (i=0;i<k-1;i++) if (!(texttomorse(buffer[i], buffer2))) {
if (buffer[i] == ' ') continue;
printf("Wrong character, only a-Z 0-9 . , : ? ' - / \" @ = allowed!\n");
return 0;
}

for (i=0;i<k-1;i++) {
if (buffer[i] == ' ') continue;
texttomorse(buffer[i], buffer2);
printf("%s ", buffer2);
}

printf("\n");
} else if (buffer[i] == '2') {
printf("Enter morse string (DECODE):\n");

fgets(buffer, 511, stdin);
k=strlen(buffer);

buffer[k-1] = '\0';

for (i=0;i<k-1;i++) {

if (buffer[i] != '-' && buffer[i] != '.' && buffer[i] != ' ') {
printf("Wrong character, only dots and hyphens allowed \
(separate words with spaces).\n");
return 0;
}

if (buffer[i] == ' ') {
buffer[i]=0;
printf("%c", morsetotext(buffer+j));
j=i+1;
}

}

printf("%c\n", morsetotext(buffer+j));
}
else {
printf("Invalid option.  Exiting ...\n");
}

return 0;

}

