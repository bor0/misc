#include <stdio.h>

#define ISP1     "MT-Net"
//#define IPISP1   "62.162.176.1" // za na 250
#define IPISP1   "192.168.1.250" // za na 252

#define ISP2     "Mol"
//#define IPISP2   "192.168.1.252" // za na 250
#define IPISP2   "212.110.77.209" // za na 252

int main() {

int x;
long lSize;

printf("Gateway changer v1.0 by BoR0\n----------------------------\n");

system("netstat -rn | grep " IPISP1 " | grep default > /tmp/gateway");

FILE *pFile = fopen( "/tmp/gateway", "r" );

fseek(pFile, 0, SEEK_END);
lSize = ftell(pFile);
rewind (pFile);

system("rm /tmp/gateway");

if (!lSize) {
        printf("Linijata e momentalno na " ISP2 "!\n");
} else {
        printf("Linijata e momentalno na " ISP1 "!\n");
}

printf("Odberi gateway za da prebacis:\n1. " ISP1 "\n2. " ISP2 "\nIzbor: ");
scanf("%d", &x);

if (x==1) {
        system("route change default " IPISP1 " | grep bor0");
        printf("Gateway-ot e smenet na " ISP1 "!\n");
} else if (x==2) {
        system("route change default " IPISP2 " | grep bor0");
        printf("Gateway-ot e smenet na " ISP2 "!\n");
} else {
        printf("Ne odbra niso!\n");
}

sleep(5);
return 0;

}

