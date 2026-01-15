#include <stdio.h>
#include <winsock.h>

//http://www.slatkaaukcija.w.mk/Fpoll/poll.php

// Socket timeout
int i, timeout, max_threads, conn_repeat, pause;

#pragma comment(lib, "wsock32.lib")

typedef struct MyData {
	struct MyData *next;
    char ip[16];
    char port[6];
} MYDATA, *PMYDATA;

DWORD WINAPI thread_function(LPVOID lpParam) { 
	PMYDATA pDataArray = (PMYDATA)lpParam;
	int x = conn_repeat;
	
	check_proxy(pDataArray->ip, pDataArray->port);
	i--;
	free(lpParam);
    return 0; 
}

int check_proxy(char *host, char *port) {
	SOCKET sd;
	int j;
	struct sockaddr_in server_addr;
	char bootup[] = "POST http://www.slatkaaukcija.w.mk/Fpoll/poll.php HTTP/1.1\r\n\
Host: www.slatkaaukcija.w.mk\r\n\
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101026 Firefox/3.6.12 ( .NET CLR 3.5.30729; .NET4.0E)\r\n\
Accept: text/html,application/xhtml+xml,application/xml;q=0.9;*/*;q=0.8\r\n\
Accept-Language: en-us,en;q=0.5\r\n\
Accept-Encoding: gzip,deflate\r\n\
Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7\r\n\
Keep-Alive: 115\r\n\
Proxy-Connection: keep-alive\r\n\
Referer: http://www.slatkaaukcija.w.mk/Fpoll/poll.php\r\n\
Content-Type: application/x-www-form-urlencoded\r\n\
Content-Length: 47\r\n\r\n\
vote=4&refer=..%2Fmk_studenti.php&submit=Zapisi\r\n\r\n";


	fd_set fds;
	struct timeval to;
	u_long iMode = 1;

	// Configure socket parameters
	server_addr.sin_family = AF_INET;
	server_addr.sin_port = htons((u_short)atoi(port));
	server_addr.sin_addr.s_addr = inet_addr(host);

	// Activate the socket
	if ((sd = socket(AF_INET, SOCK_STREAM, 0)) == -1) return -1;

	// Set non-blocking mode
	FD_ZERO(&fds);
	FD_SET(sd, &fds);
	if (ioctlsocket(sd, FIONBIO, &iMode) == -1) return -1;
	to.tv_sec = timeout;
	to.tv_usec = 0;

	// Connect
	connect(sd, (struct sockaddr *)&server_addr, sizeof(server_addr));

	// Wait on availability to send for 'timeout' milliseconds
	j = select(sizeof(fds)*8, NULL, &fds, NULL, &to);

	if (j == -1 || j == 0) {
		closesocket(sd);
		return 0;
	}

	// Send once available
	send(sd, bootup, strlen(bootup), 0);

	j = time(NULL);

	while((time(NULL)-j) < timeout) {
		Sleep(pause);
		// Read
		if (recv(sd, bootup, 16, 0) == -1) continue;
		break;
	}
	printf("SENT TO %s:%s\n", host, port);
	closesocket(sd);
	return 0;
}

int main(int argc, char *argv[]) {

	FILE *t = fopen("proxylist.txt", "r");
	char tmp[6];
	WSADATA wsaData;
	HANDLE id;
	PMYDATA host;

	printf("Multi-threaded Proxy Scanner by Boro Sitnikovski\n------------------------------------------------\n");

	if (t == NULL) {
		printf("Can not open \"proxylist.txt\".  Exiting...\n");
		return 0;
	}
	
	if (argc != 5) {
		printf("Usage: %s <timeout(int)> <max_threads(int)> <conn_repeat(int)> <pause(int)>\nAll parameters are in milliseconds.  Example: %s 5000 500 5 20\n",\
		argv[0], argv[0]);
		fclose(t);
		return 0;
	}
	
	timeout = atoi(argv[1]);
	max_threads = atoi(argv[2]);
	conn_repeat = atoi(argv[3]);
	pause = atoi(argv[4]);

	if (timeout <= 0 || max_threads <= 0 || conn_repeat <= 0 || pause < 0) {
		printf("Invalid parameters in the file.  Exiting...\n");
		fclose(t);
		return 0;
	}

	i=0;
	WSAStartup(MAKEWORD(2, 2), &wsaData);

	while (!feof(t)) {
		if (i > max_threads) {
			Sleep(timeout);
			continue;
		}
		host = (PMYDATA)malloc(sizeof(MYDATA));
		fscanf(t, "%15s %5s", &host->ip, &host->port);
		while (fgetc(t) != '\n' && !feof(t));

		CreateThread(NULL, 0, thread_function, (LPVOID)host, 0, (LPDWORD)&id);
		i++;
	}
	
	fclose(t);
	// ((B + D + Z)*3)*10 :)
	Sleep(timeout+6720);
	WSACleanup();
	
	printf("Done\n");

	return 0;
}
