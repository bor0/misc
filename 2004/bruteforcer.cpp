#include <windows.h>
#include <winsock.h>

// The code is a bit messy, but I think it will work as it is ;)

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nShowCmd) {
	char compare[2048] = "Connection: Keep-Alive\r\nTransfer-Encoding: chunked\r\nContent-Type: text/xml\r\n\r\n22d\r\n<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n<!DOCTYPE online_lyrics_database PUBLIC \"-//winlyrics.com//DTD search 1.0//EN\" \"search.dtd\">\r\n<?xml-stylesheet type=\"text/xsd\" href=\"search.xsd\"?>\r\n<?xml-stylesheet type=\"text/xsl\" href=\"search.xsl\"?>\r\n\r\n<online_lyrics_database>\r\n<query><id>126147</id>\n\t<songs number=\"1\">\n\t\t<song id=\"126147\"><title>Punk Rock Song</title><album id=\"1907\">The Gray Race</album><artist id=\"949\">Bad Religion</artist>\n\t\t\t<lyrics>Please purchase a legal copy of WinLyrics.</lyrics>\n\t\t</song>\n\t</songs>\n</query>\r\n</online_lyrics_database>\r\n0\r\n\r";
	char finalcompare[2048];
	char received[2048];
	char sendthis[2048];
	char cookie[64];
	int loopdel=0;
	int length=0;
	WSADATA wsaData;
	SOCKET theSocket;
	int nRet, bytesrec = 0;
	const int PORT = 80;
	SOCKADDR_IN saServer;
	LPHOSTENT lpHostEntry;
	WSAStartup(MAKEWORD(2, 0), &wsaData);

	int i=0;
	lpHostEntry = gethostbyname("www.winlyrics.com");

	theSocket = socket(AF_INET,SOCK_STREAM,0);
	saServer.sin_family = AF_INET;
	saServer.sin_addr = *((LPIN_ADDR)*lpHostEntry->h_addr_list);
	saServer.sin_port = htons(PORT);

	nRet = connect(theSocket, (LPSOCKADDR)&saServer, sizeof(struct sockaddr));
	
	for (i=555555555;i>1;i--) {

		wsprintf(sendthis, "GET //search.php?ir=1&id=126147&cc=47&rn=%d&progver=2.47%%20HTTP/1.0%%20Accept:%%20*/*%%20User-Agent:%%20Mozilla/4.0%%20(compatible;%%20MSIE%%206.0;%%20Windows%%20NT%%205.1 HTTP/1.1\nAccept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, */*\nAccept-Language: mk\nUser-Agent: Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)\nHost: www.winlyrics.com\nConnection: Keep-Alive\n\n", i);

		send(theSocket, sendthis, strlen(sendthis), 0);

		back:
		bytesrec=0;
		bytesrec = recv(theSocket, received, sizeof(received), 0);
		if (bytesrec==0) goto back;
		
		lstrcpyn(finalcompare, received, bytesrec);
		length = strlen(finalcompare);

		for (loopdel=0;loopdel<length;i++) {
			if (finalcompare[loopdel]=='C' && finalcompare[loopdel+1]=='o' && finalcompare[loopdel+2]=='n' && finalcompare[loopdel+3]=='n' && finalcompare[loopdel+4]=='e' && finalcompare[loopdel+5]=='c' && finalcompare[loopdel+6]=='t' && finalcompare[loopdel+7]=='i' && finalcompare[loopdel+8]=='o' && finalcompare[loopdel+9]=='n' && finalcompare[loopdel+10]==':' && finalcompare[loopdel+11]==' ' && finalcompare[loopdel+12]=='K' && finalcompare[loopdel+13]=='e' && finalcompare[loopdel+14]=='e' && finalcompare[loopdel+15]=='p' && finalcompare[loopdel+16]=='-' && finalcompare[loopdel+17]=='A' && finalcompare[loopdel+18]=='l' && finalcompare[loopdel+19]=='i' && finalcompare[loopdel+20]=='v' && finalcompare[loopdel+21]=='e') break;
			strcpy(finalcompare, finalcompare+1);
		}
		
		if (strcmp(finalcompare, compare) != 0) {
			wsprintf(cookie, "rn working number: %d", i);
			MessageBox(0, cookie, "Found a valid number!", 0);

			/* DEBUGGING PART

			HANDLE hFile=0;
			DWORD byteswritten=0;
			hFile = CreateFile("C:\\brFreal.txt", GENERIC_WRITE, FILE_SHARE_READ, 0, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
			WriteFile(hFile, compare, strlen(compare), &byteswritten, 0);
			CloseHandle(hFile);
			hFile = CreateFile("C:\\brFfake.txt", GENERIC_WRITE, FILE_SHARE_READ, 0, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
			WriteFile(hFile, finalcompare, strlen(finalcompare), &byteswritten, 0);
			CloseHandle(hFile);
			MessageBox(0,finalcompare,0,0);
			MessageBox(0,compare,0,0);
			
			END DEBUGGING PART */
		}

		// lets clean them.
		finalcompare[0]=0;
		sendthis[0]=0;
		received[0]=0;
		cookie[0]=0;
		bytesrec=0;
		length=0;
		loopdel=0;
		length=0;

	}

	closesocket(theSocket);
	WSACleanup();
	return 0;
}
