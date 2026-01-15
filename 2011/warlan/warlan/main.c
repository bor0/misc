#include <windows.h>
#include <winsock.h>
#include <stdio.h>

char *application[] = {
	"Warlan v1.0 by BoR0\n-------------------\n\nEnter IP, DESTPORT, SRCPORT respectively: ",
	"\nPlease wait, initiating winsock...\n",
	"WSAStartup() success.\n",
	"[ERROR] WSAStartup() failed!\n",
	"Please wait, trying to connect() to destination...\n",
	"Successfully connected to destination IP!\n",
	"[ERROR] connect() failed. Could not connect to destination IP!\n",
	"Please wait, trying to bind() TCP on port '%d'..\n",
	"Successfully called bind()\n",
	"[ERROR] bind() failed. Could not bind - need more system resources!\n",
	"Initiating UDP client socket, please wait...\n",
	"Successfully called UDP client socket()\n",
	"[ERROR] UDP client socket() failed!\n",
	"Initiating UDP server socket, please wait...\n",
	"Successfully called UDP server socket()\n",
	"[ERROR] UDP server bind() failed!\n",
	"[ERROR] CreateThread() failed!\n",
	"Successfully connected!\n\nShould the game not appear in the list, you may need\nto restart both Warcraft III and Warlan.", //17
	"[ERROR] ioctlsocket() failed!\n"
};

char DEST[16];
char buffer[2048];

int DESTPORT, SRCPORT;

HANDLE hThread, hThread2;

static WSADATA wsadata;
static SOCKET tcpServer, tcpSocket, udpServer, udpSocket, connected;
SOCKADDR_IN tcp, tcp2, udp, udp2, client;


int destroyall(void) {

	closesocket(tcpSocket); closesocket(tcpServer); closesocket(udpSocket); closesocket(udpServer); closesocket(connected);
	CloseHandle(hThread); CloseHandle(hThread2);
	WSACleanup();

	return 0;

}

DWORD WINAPI servertoclient(LPVOID lpParameter) {

	u_long x = 1;

	if (ioctlsocket(connected, FIONBIO, &x) == SOCKET_ERROR) {
		printf(application[18]);
		system("pause");
		destroyall();
		exit(0);
	}

	while(1) {

		ioctlsocket(connected, FIONREAD, &x);
		recv(connected, buffer, x, 0);
		if (WSAGetLastError() != WSAEWOULDBLOCK)
		send(tcpSocket, buffer, x, 0);
		Sleep(20);

	}

	closesocket(tcpSocket); closesocket(tcpServer); closesocket(udpSocket); closesocket(udpServer);
	CloseHandle(hThread); CloseHandle(hThread2);
	WSACleanup();

	return 0;

}

DWORD WINAPI clienttoserver(LPVOID lpParameter) {

	u_long x = 1; // ))
	int size = sizeof(tcp);

	pewlaser:
	connected = accept(tcpServer, (struct sockaddr *)&client, &size);
	if (connected == INVALID_SOCKET) goto pewlaser;

	if (CreateThread(0, 0, &servertoclient, 0, 0, (LPDWORD)hThread2) == 0) {
		printf(application[16]);
		system("pause");
		destroyall();
		exit(0);
	}

	if (ioctlsocket(tcpSocket, FIONBIO, &x) == SOCKET_ERROR) {
		printf(application[18]);
		system("pause");
		destroyall();
		exit(0);
	}
	
	while(1) {

		ioctlsocket(tcpSocket, FIONREAD, &x);
		recv(tcpSocket, buffer, x, 0);
		if (WSAGetLastError() != WSAEWOULDBLOCK)
		send(connected, buffer, x, 0);

		Sleep(20);

	}

	return 0;

}


int main(int argc, char *argv[]) {

	unsigned char request[] = { 0xF7, 0x32, 0x10, 0x00, 0x02, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00 };
	int x, laserbeam;
	int size = sizeof(udp);

	printf(application[0]);
	scanf("%s%d%d", &DEST, &DESTPORT, &SRCPORT);

	printf(application[1]);
	
	begin:
	if (WSAStartup(0x101, &wsadata) == 0) {
		printf(application[2]);
	} else {
		printf(application[3]);
		system("pause");
		return 0;
	}

	printf(application[4]);
	
	tcpSocket = socket(AF_INET,SOCK_STREAM, IPPROTO_IP);
	tcp2.sin_family = AF_INET;
	tcp2.sin_addr = *((LPIN_ADDR)*gethostbyname(DEST)->h_addr_list);
	tcp2.sin_port = htons(DESTPORT);
	if (connect(tcpSocket, (LPSOCKADDR)&tcp2, sizeof(struct sockaddr)) == SOCKET_ERROR) {
		printf(application[6]);
		WSACleanup();
		system("pause");
		return 0;
	} else printf(application[5]);

	printf(application[7], DESTPORT);

	tcpServer = socket(AF_INET,SOCK_STREAM,IPPROTO_IP);
	tcp.sin_family = AF_INET;
	tcp.sin_addr.s_addr = htonl(INADDR_ANY);
	tcp.sin_port = htons(DESTPORT);
	if (bind(tcpServer,(struct sockaddr*) &tcp, sizeof(tcp)) == SOCKET_ERROR || listen(tcpServer, 5) == SOCKET_ERROR) {
		printf(application[9]);
		closesocket(tcpSocket);
		closesocket(tcpServer);
		WSACleanup();
		system("pause");
		return 0;
	} else printf(application[8]);

	printf(application[10]);

	udpSocket = socket(AF_INET,SOCK_DGRAM,IPPROTO_IP);

	if (udpSocket == INVALID_SOCKET) {
		printf(application[12]);
		goto end;
	} else printf(application[11]);

	udp.sin_family = AF_INET;
	udp.sin_port = htons(DESTPORT);

	printf(application[13]);

	udpServer = socket(AF_INET,SOCK_DGRAM,IPPROTO_IP);
	udp2.sin_addr.s_addr = INADDR_ANY;
	udp2.sin_port = htons(SRCPORT);
	udp2.sin_family = AF_INET;
	if (bind(udpServer, (struct sockaddr *)&udp2, sizeof(struct sockaddr)) == SOCKET_ERROR) {
		printf(application[15]);
		goto end;
	} else printf(application[14]);

	x = 0;

	if (CreateThread(0, 0, &clienttoserver, 0, 0, (LPDWORD)hThread) == 0) {
		printf(application[16]);
		goto end;
	}

	printf(application[17]);

	while(1) { 

		if (x == 0) { // inicijalizacija
			udp.sin_addr.s_addr = inet_addr("127.0.0.1");
			sendto(udpSocket, (const char*)request, 16, 0, (struct sockaddr *)&udp, sizeof(struct sockaddr_in));
			request[4]++; request[4]%=10;
			udp.sin_addr.s_addr = inet_addr(DEST);
			sendto(udpSocket, (const char*)request, 16, 0, (struct sockaddr *)&udp, sizeof(struct sockaddr_in));
		} else if (x == 1) { // komunikacija :p
			udp.sin_addr.s_addr = inet_addr(DEST);
			sendto(udpSocket, (const char*)buffer, 16, 0, (struct sockaddr *)&udp, sizeof(struct sockaddr_in));
			request[4] = buffer[12]; request[4]%=10;
			udp.sin_addr.s_addr = inet_addr(DEST);
			sendto(udpSocket, (const char*)request, 16, 0, (struct sockaddr *)&udp, sizeof(struct sockaddr_in));
			request[4]++; request[4]%=10;
			udp.sin_addr.s_addr = inet_addr("127.0.0.1");
			sendto(udpSocket, (const char*)request, 16, 0, (struct sockaddr *)&udp, sizeof(struct sockaddr_in));
		} else if (x == 2) { // dobi data, igrata stavi ja u lista
			udp.sin_addr.s_addr = inet_addr("127.0.0.1");
			sendto(udpSocket, buffer, laserbeam, 0, (struct sockaddr *)&udp, sizeof(struct sockaddr_in));
		}

		laserbeam = recvfrom(udpSocket, buffer, 2048, 0, (struct sockaddr *)&udp, &size);

		if (laserbeam > 16) x = 2;
		else if (laserbeam == 16) x = 1;

		Sleep(50);

	}

	end:
	system("pause");
	destroyall();

	return 0;

}

