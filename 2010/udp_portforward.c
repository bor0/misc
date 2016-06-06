#include <stdio.h>
#include <stdlib.h>
#include <winsock.h>

#pragma comment(lib, "wsock32.lib")

int main(int argc, char *argv[]) {
	char buf[65535];
	SOCKET os;
	struct sockaddr_in a, sa, da;
	WSADATA w;

	if (argc!=5) {
		printf("Usage: %s our-ip our-port send-to-ip send-to-port\n",argv[0]);
		exit(1);
	}

	if (WSAStartup(0x0101, &w) != 0) {
		printf("Could not open Windows connection.\n");
		exit(1);
	}

	os=socket(PF_INET,SOCK_DGRAM,IPPROTO_IP);

	a.sin_family=AF_INET;
	a.sin_addr.s_addr=inet_addr(argv[1]);
	a.sin_port=htons((u_short)atoi(argv[2]));

	if(bind(os,(struct sockaddr *)&a,sizeof(a)) == -1) {
		printf("Can't bind our address (%s:%s)\n", argv[1], argv[2]);
		exit(1);
	}

	a.sin_addr.s_addr=inet_addr(argv[3]);
	a.sin_port=htons((u_short)atoi(argv[4]));

	da.sin_addr.s_addr=0;

	while(1) {
		int sn=sizeof(sa);
		int n=recvfrom(os,buf,sizeof(buf),0,(struct sockaddr *)&sa,&sn);
		if(n<=0) continue;

		if (da.sin_addr.s_addr && sa.sin_addr.s_addr==a.sin_addr.s_addr && sa.sin_port==a.sin_port) {
			sendto(os,buf,n,0,(struct sockaddr *)&da,sizeof(da));
		} else {
			sendto(os,buf,n,0,(struct sockaddr *)&a,sizeof(a));
			da=sa;
		}
	}
}

