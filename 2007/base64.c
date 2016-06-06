#include <stdio.h>

/*
Base 64 File Encoder/Decoder
written by BoR0 (20.may.2007)
Updated on 07.june.2007 (Fix on 20.june)
inspirated by Doctor :)
*/

char b64_table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/.";

int b64_bordecode(char *texttodecode, char *output, int x) {

int i,t;
int place[6];

for (i=0;i<x;i++) {
for (t=0;t<=64;t++) if (texttodecode[i] == b64_table[t]) break;
if (t == 64) return 0;
if (texttodecode[i] == '=') {place[i] = 8020; break;}
else place[i] = t;
}

place[i]=8020;

for (i=0,t=0;i<x;i+=4,t+=3) {
if (place[i] == 8020 || place[i+1] == 8020) break;
output[t] = (place[i] << 2) + (place[i+1] >> 4);
if (place[i+2] == 8020) break;
output[t+1] = (place[i+1] << 4) + (place[i+2] >> 2);
if (place[i+3] == 8020) break;
output[t+2] = (place[i+2] << 6) + place[i+3];
}

return 1;

}

//each encoding increases the size of data by 4/3
int b64_borencode(char *texttoencode, char *output, int x) {

int i,t;

for (i=0,t=0;i<x;t+=4) {
output[t] = b64_table[((unsigned char)texttoencode[i] >> 2)]; i++;
output[t+1] = b64_table[((unsigned char)texttoencode[i] >> 4) + (((unsigned char)texttoencode[i-1] & 3) << 4)];
if (i>=x) break; i++;
output[t+2] = b64_table[(((unsigned char)texttoencode[i-1] & 15) << 2) + ((unsigned char)texttoencode[i] >> 6)];
if (i+1>x) break; i++;
output[t+3] = b64_table[((unsigned char)texttoencode[i-1] & 63)];
}

return 1;

}

int main() {
char buffer1[5]; char buffer2[5];
int i,x; char a;

FILE *pFile = fopen("boro.in", "rb"); FILE *qFile = fopen("boro.out", "wb");
FILE *rFile = fopen("boro.b64", "rb");

if (!pFile || !qFile) {
printf("ERROR: There was an error opening one of the files.\n");
return 0;
}

if (!rFile) {
printf("No .b64 file found. Using default base64 table.\n");
} else {
i = fread(b64_table, 1, 64, rFile);
if (i != 64) {
printf("ERROR: Invalid size found in .b64 file.\n");
goto dead;
}
for (i=0;i<63;i++) for (x=0;x<64;x++)
if (b64_table[i] == b64_table[x] && i != x) {
printf("ERROR: Duplicate character found in .b64 table.\n");
goto dead;
}
printf("Using base64 table read from boro.b64\n");
}

printf("Should I encode (0) or decode (1) the file boro.in? (0/1) ");
scanf("%c", &a);

if (a == '0') {
printf("Now encoding, this may take a while depending on file size. Please wait..\n");
while (1) {
i = fread(buffer1, 1, 3, pFile);
if (feof(pFile) != 0) {
b64_borencode(buffer1, buffer2, i+1);
if (i > 0) fwrite(buffer2, 1, i+1, qFile);
break;
}
b64_borencode(buffer1, buffer2, i);
fwrite(buffer2, 1, 4, qFile);
}
printf("Successfully encoded file!\n");
}
else if (a == '1') {
printf("Now decoding, this may take a while depending on file size. Please wait..\n");
while (1) {
i = fread(buffer1, 1, 4, pFile);
if (feof(pFile) != 0) {
b64_bordecode(buffer1, buffer2, i+1);
if (i > 0) fwrite(buffer2, 1, i-1, qFile);
break;
}
if (!b64_bordecode(buffer1, buffer2, i)) {
printf("ERROR: invalid character(s) found!\n");
goto dead;
}
fwrite(buffer2, 1, 3, qFile);
}
printf("Successfully decoded file!\n");
}
else printf("ERROR: Wrong value!\n");

dead:
fclose(qFile);
fclose(pFile);

return 0;

}
