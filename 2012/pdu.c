///////////////////////////////////////
// AT Interfejs za prakjanje SMS poraki
//
// Boro Sitnikovski, 22.02.2012

#include <windows.h>
#include <stdio.h>

#pragma comment(lib, "user32.lib")

HANDLE hCom;
unsigned char buffer[65536];
int smsclength;

char* flip(char *in) {
	int i, j, k=0;
	char *s;
	j = strlen(in);

	if (j%2 != 0) {
		char *t;
		j += 2;
		t = (char *)malloc((j + 1)*sizeof(char));
		strcpy(t, in);
		t[j-2] = 'F';
		t[j-1] = '\0';
		in = t;
		k = 1;
	}
	s = (char *)malloc((j+1)*sizeof(char));
	for (i=0;i<j;i+=2) {
		s[i] = in[i+1];
		s[i+1] = in[i];
	}
	
	if (k == 1) {
		free(in);
		s[j-1] = '\0';
	} else s[j] = '\0';
	return s;
}

char *parsemessage(char *msg) {
	int i, j;
	char *parsedmsg, tmp[3];
	j = strlen(msg);
	parsedmsg = (char *)malloc((j*2+1)*sizeof(char));
	for (i=0;i<j;i++) {
		sprintf(tmp, "%X", msg[i]);
		strcpy(parsedmsg+(2*i), tmp);
	}
	return parsedmsg;
}

char *encodePDU(char *callcenter, char *receiver, char *msg) {
	char *pduencoded, *parsedmsg;
	int receiverlength;

	callcenter = flip(callcenter);
	receiver = flip(receiver);

	smsclength = strlen(callcenter)/2 + 1; // + 1 for type of address (0x91)
	receiverlength = strlen(receiver);
	if (receiver[receiverlength-2] == 'F') {
		receiverlength--;
	}

	parsedmsg = parsemessage(msg);
	pduencoded = (char *)malloc((strlen(callcenter) + strlen(receiver) + strlen(msg)*2 + 32)*sizeof(char));

	sprintf(pduencoded, "%.2d%.2X%s%.2X%.2X%.2X%.2X%s%.2X%.2X%.2X%.2X%s", \
		smsclength,			// length of SMSC information
		0x91,				// type of address of SMSC (91 international format)
		callcenter,			// callcenter number
		0x11,				// ?
		0x00,				// ?
		receiverlength,		// length of phone number
		0x91,				// type of address of Receiver (91 international format)
		receiver,			// receiver number
		0x00,				// protocol identifier
		0x04,				// data encoding scheme (8-bit)
		0xAA,				// timestamp, AA = 4 days
		strlen(msg),		// length of msg
		parsedmsg);			// msg

	free(parsedmsg);
	free(callcenter);
	free(receiver);
	return pduencoded;
}

int contains(char *a, char *b) {
	int i = strlen(a), j = strlen(b), l;
	if (i < j) {
		char *p = a;
		int k = i;
		i = j;
		j = k;
		a = b;
		b = p;
	}
	for (l=0;l<i;l++) if (strncmp(a+l, b, j) == 0) return 1;

	return 0;
}

char *commsend(unsigned char *msg, int wait) {
	unsigned int tmp;
	WriteFile(hCom, msg, strlen(msg), &tmp, NULL);
	Sleep(wait);
	ReadFile(hCom, buffer, 1024, &tmp, NULL);
	return buffer;
}

void trimlastchars(char *str) {
	int i, j = strlen(str);
	if (str[j-1] == '\r' || str[j-1] == '\n') str[j-1] = '\0';
	if (str[j-2] == '\r' || str[j-2] == '\n') str[j-2] = '\0';
}

int main(int argc, char **argv) {
	DCB dcb;
	COMMTIMEOUTS cto;
	BOOL fSuccess;
	FILE *inFile;
	char InCommPort[255], InServiceNumber[255], InReceiverNumber[255], InMessage[255];
	char *x;

	inFile = fopen("pdu.in", "r");
	if (!inFile) {
		printf("ERROR: Cannot open pdu.in\n");
		return 0;
	}
	
	if (fgets(InCommPort, 255, inFile) == NULL || \
	fgets(InServiceNumber, 255, inFile) == NULL || \
	fgets(InReceiverNumber, 255, inFile) == NULL || \
	fgets(InMessage, 255, inFile) == NULL) {
		printf("ERROR: Insufficient information in pdu.in");
		fclose(inFile);
		return 0;
	}
	
	trimlastchars(InCommPort);
	trimlastchars(InServiceNumber);
	trimlastchars(InReceiverNumber);
	trimlastchars(InMessage);

	hCom = CreateFile(InCommPort,
	GENERIC_READ | GENERIC_WRITE,
	FILE_SHARE_READ | FILE_SHARE_WRITE, // must be opened with exclusive-access
	NULL, // no security attributes
	OPEN_EXISTING, // must use OPEN_EXISTING
	0, // not overlapped I/O
	NULL // hTemplate must be NULL for comm devices
	);
	
	if (hCom == INVALID_HANDLE_VALUE) {
		// Handle the error.
		printf("ERROR: CreateFile failed (%d)\n", GetLastError());
		return 2;
	}

	// Build on the current configuration, and skip setting the size
	// of the input and output buffers with SetupComm.

	fSuccess = GetCommState(hCom, &dcb);

	if (!fSuccess) {
		// Handle the error.
		printf("ERROR: GetCommState failed (%d)\n", GetLastError());
		return 3;
	}

	// Fill in DCB: 9,600 bps, 8 data bits, no parity, and 1 stop bit.

	dcb.BaudRate = CBR_9600; // set the baud rate
	dcb.ByteSize = 8; // data size, xmit, and rcv
	dcb.Parity = NOPARITY; // no parity bit
	dcb.StopBits = ONESTOPBIT; // one stop bit

	fSuccess = SetCommState(hCom, &dcb);

	if (!fSuccess) {
		// Handle the error.
		printf("ERROR: SetCommState failed (%d)\n", GetLastError());
		return 4;
	}

	fSuccess = GetCommTimeouts(hCom, &cto);

	if (!fSuccess) {
		// Handle the error.
		printf("ERROR: GetCommTimeouts failed (%d)\n", GetLastError());
		return 5;
	}

	cto.ReadTotalTimeoutConstant = 500; // 500 ms

	fSuccess = SetCommTimeouts(hCom, &cto);

	if (!fSuccess) {
		// Handle the error.
		printf("ERROR: SetCommTimeouts failed with error (%d)\n", GetLastError());
		return 6;
	}
	
	x = commsend("AT\r", 100);

	if (contains(x, "OK")) {
		x = commsend("AT+CPIN?\r", 100);
		if (contains(x, "+CPIN: READY")) {
			x = commsend("AT+CMGF=0\r", 100); // Activate PDU mode (1 is for Text mode)
			if (contains(x, "OK")) {
				int PDUlen;
				char *PDUmsg = encodePDU(InServiceNumber, InReceiverNumber, InMessage);
				PDUlen = strlen(PDUmsg)/2 - smsclength - 1;
				sprintf(buffer, "AT+CMGS=%d\r", PDUlen);
				x = commsend(buffer, 100);
				if (contains(x, ">")) {
					sprintf(buffer, "%s%c", PDUmsg, 0x1A);
					x = commsend(buffer, 5000);
					if (contains(x, "OK")) {
						printf("Message sent!");
					} else {
						printf("Error sending message (1)");
					}
				} else printf("Error sending message (2)");
				free(PDUmsg);
			} else {
				printf("Error activating PDU mode.");
			}
		} else {
			int pin;
			printf("Please enter the PIN number: ");
			scanf("%d", &pin);
			sprintf(buffer, "AT+CPIN=\"%d\"\r", pin);
			x = commsend(buffer, 100);
			if (!contains(x, "+CPIN: READY")) printf("Wrong pin number.");
		}
	}

	CloseHandle(hCom);
	return 1;
}