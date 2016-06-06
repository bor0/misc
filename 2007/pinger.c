#include <stdio.h>

#define MAX_PC 17

char *ipaddresses[] = { "192.168.1.17", "192.168.1.2", "192.168.1.12", 
"192.168.1.3", "192.168.1.4", "192.168.1.23", "192.168.1.10", 
"192.168.1.11", "192.168.1.7", "192.168.1.19", "192.168.1.20", 
"192.168.1.9", "192.168.1.5", "192.168.1.26", "192.168.1.27", 
"192.168.1.6", "192.168.1.8" };

int main() {
int i,t; long lSize;
FILE *pFile; char ping[64];

t=0;

for (i=0;i<MAX_PC;i++) {

remove("boro.txt");

sprintf(ping, "ping -t 1 -c 1 %s > boro.txt", ipaddresses[i]);
system(ping);

pFile = fopen("boro.txt", "r");
fseek(pFile, 0, SEEK_END);
lSize = ftell(pFile);
fclose(pFile);

printf("[%d]: is ", i+1);
if (lSize == 143 || lSize == 146 || lSize == 149) printf("OFFLINE.");
else { printf("ONLINE.", i+1); t++; }
printf("\n");

}

remove("boro.txt");
printf("%d online, %d offline.\n", t, MAX_PC-t);

sleep(15);

return 0;

}
