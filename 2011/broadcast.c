#include <stdio.h>

int main() {

struct ip_addr {
unsigned char ip[4];
} ip = {0}, subnet = {0}, broadcast;

int i;

printf("Enter IP address: ");
scanf("%3d.%3d.%3d.%3d", &ip.ip[0], &ip.ip[1], &ip.ip[2], &ip.ip[3]);

printf("Enter Subnet: ");
scanf("%3d.%3d.%3d.%3d", &subnet.ip[0], &subnet.ip[1], &subnet.ip[2], &subnet.ip[3]);

for (i=0;i<4;i++) broadcast.ip[i] = ip.ip[i] | (~subnet.ip[i]);

printf("Broadcast IP is: %d.%d.%d.%d\n", broadcast.ip[0], broadcast.ip[1], broadcast.ip[2], broadcast.ip[3]);

return 0;

}