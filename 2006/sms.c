/*
 * Resenie za vtorata zadaca od informatickiot natprevar na PMF
 *
 * Napisano od Boro Sitnikovski na 04/03/2006
 * D.S.U. "Koco Racin" - Skopje
 *
 * Mozebi ne izgleda najdobro, no sepak raboti! ;-)
 *
 */ 

#include <stdio.h>

int proveriklik(char c) {

//  ADGJMPTW0
if ((c == 'A') || (c == 'a') || (c == 'D') || (c == 'd') || (c == 'G') || (c == 'g')) return 1;
if ((c == 'J') || (c == 'j') || (c == 'M') || (c == 'm') || (c == 'P') || (c == 'p')) return 1;
if ((c == 'T') || (c == 't') || (c == 'W') || (c == 'w') || (c == '0') || (c == ' ')) return 1;

// BEHKNQUX.1
if ((c == 'B') || (c == 'b') || (c == 'E') || (c == 'e') || (c == 'H') || (c == 'h')) return 2;
if ((c == 'K') || (c == 'k') || (c == 'N') || (c == 'n') || (c == 'Q') || (c == 'q')) return 2;
if ((c == 'U') || (c == 'u') || (c == 'X') || (c == 'x') || (c == '.') || (c == '1')) return 2;

// VY,LORCFI
if ((c == 'V') || (c == 'v') || (c == 'Y') || (c == 'y') || (c == ',')) return 3;
if ((c == 'L') || (c == 'l') || (c == 'O') || (c == 'o') || (c == 'R') || (c == 'r')) return 3;
if ((c == 'C') || (c == 'c') || (c == 'F') || (c == 'f') || (c == 'I') || (c == 'i')) return 3;

// 234568SZ?
if ((c == '2') || (c == '3') || (c == '4') || (c == '5') || (c == '6') || (c == '8')) return 4;
if ((c == 'S') || (c == 's') || (c == 'Z') || (c == 'z') || (c == '?')) return 4;

// 97!
if ((c == '9') || (c == '7') || (c == '!')) return 5;

return 0;

}

int main() {

char buffer[8];

int i,x;
int temp=0;
FILE *pFile = fopen( "sms.in", "r" );

if (ferror(pFile)) {
printf("Greska, nemozam da procitam od sms.in\n");
return 0;
}

//kreiraj fajl, procitaj prvi 5 bukvi
x=fread(buffer, sizeof(char), 5, pFile);

//transformiraj gi pette bukvi vo integer
x=atoi(buffer);

//pak vrati gi vo buffer, za da napravime strlen()
//za da vidime kolku brojki se procitani...
sprintf(buffer, "%d", x);

//i potoa da se prefrlime na pointer na nizata posle brojceto
fseek(pFile, strlen(buffer)+1, SEEK_SET); //+1 zaradi null-terminator ;-)

if ((x>=10001) || (x<=0)) {
printf("Greska, nizata treba da e izmegu 1 i 10000.\n");
goto kraj;
}

for (i=0;i<x;i++) { //od 0 do x (najden na prvata linija vo sms.in)

fread(buffer, sizeof(char), 1, pFile); //procitaj tuka

temp += proveriklik(buffer[0]); //zacuvaj rezultati vo temp varijabla

// if (proveriklik(buffer[0] == 0) printf("Prekinav na %d, nepoddrzan karakter!\n", i);

//printf("%d - %c\n", temp, buffer[0]); // nekoj vid na debug =)

}

FILE *output = fopen("sms.out", "w+"); //kreiraj output fajl (overwrite)

for (i=0;i<8;i++) buffer[i]=0; //iscisti go buffer =)

sprintf(buffer, "%d", temp); //transformiraj od integer vo string

x=strlen(buffer); //vidi kolku bukvi se potrebni za write

fwrite(buffer, sizeof(char), x, output); //upisi!

fclose(output); //cistenje...

kraj:
fclose(pFile); //cistenje...

return 0;

}
