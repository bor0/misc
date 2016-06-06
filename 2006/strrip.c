#include <stdio.h> 
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <signal.h>

void disconnected();
void usage();
void handle_sigtrap();
void addr_initialize();

FILE *pFile=0;
int sd=0;

main (int argc, char *argv[]) {
int i, error, z, port;
struct sockaddr_in server_addr;
char bufferboot[512];
unsigned char ch[512];
char bootup[] = "GET /%s HTTP/1.0\r\nHost: 127.0.0.1\r\nUser-Agent: WinampMPEG/5.0\r\nAccept: \
*/*\r\nIcy-MetaData:0\r\nConnection: close\r\n\r\n";

printf(" Stream ripper v1.1 by BoR0\n");
if(argc<6) usage();

port = atoi(argv[2]);
sprintf(bufferboot, bootup, argv[3]);

signal(SIGPIPE, handle_sigtrap);
signal(SIGINT, handle_sigtrap);

addr_initialize(&server_addr, port, inet_addr(argv[1]));

reconnect: sd = socket(AF_INET, SOCK_STREAM, 0);
error = connect(sd, (struct sockaddr *) &server_addr, sizeof(server_addr));

if (error == 0) {
printf("Fetching!\n");
pFile = fopen(argv[4], "wb");
send(sd, bufferboot, strlen(bufferboot), 0);

z = 8020;

while(z<0 || z!=0) {
z = recv(sd, ch, 511, 0);
fwrite(ch, sizeof(char), z, pFile);
}

disconnected();

} else {
printf("Error!\n");
}

if (argv[5][0]=='1') {
printf("Reconnecting...\n");
goto reconnect;
}

}

void addr_initialize (struct sockaddr_in *address, int port, long IPaddr) {
address -> sin_family = AF_INET;
address -> sin_port = htons((u_short)port);
address -> sin_addr.s_addr = IPaddr;
}

void usage() {
printf("\nusage: ./streamripper <ip> <port> <additional> <output> <reconnect on \
disconnection>\nexample: ./streamripper 127.0.0.1 80 stream/1003 /usr/home/mp3/techno.mp3 1\n");
exit(0);
}

void handle_sigtrap (int signal) {
disconnected();
exit(0);
}

void disconnected() {

printf("Disconnected.\n");
fclose(pFile);
close(sd);

}
