#define WIN32_LEAN_AND_MEAN						/* speed up compilations */
#include <winsock.h>
#include <windows.h>

typedef struct {
	unsigned char Ttl;							// Time To Live
	unsigned char Tos;							// Type Of Service
	unsigned char Flags;						// IP header flags
	unsigned char OptionsSize;					// Size in bytes of options data
	unsigned char *OptionsData;					// Pointer to options data
} IP_OPTION_INFORMATION, * PIP_OPTION_INFORMATION;

typedef struct {
	unsigned long Address;						// Replying address
	unsigned long Status;						// Reply status
	unsigned long RoundTripTime;				// RTT in milliseconds
	unsigned short DataSize;					// Echo data size
	unsigned short Reserved;					// Reserved for system use
	void *Data;									// Pointer to the echo data
	IP_OPTION_INFORMATION Options;				// Reply options
} IP_ECHO_REPLY, * PIP_ECHO_REPLY;

HANDLE (WINAPI *pIcmpCreateFile)(VOID);
BOOL (WINAPI *pIcmpCloseHandle)(HANDLE);
DWORD (WINAPI *pIcmpSendEcho)(HANDLE,DWORD,LPVOID,WORD,PIP_OPTION_INFORMATION,LPVOID,DWORD,DWORD);

int threadcount = 0;
int alivecount = 0;
HANDLE hIP;
char acPingBuffer[64];
PIP_ECHO_REPLY pIpe;

DWORD WINAPI thread_function(LPVOID lpParam) { 
	unsigned long host = (unsigned long)lpParam;
	DWORD dwStatus = pIcmpSendEcho(hIP, host/* *((DWORD*)phe->h_addr_list[0]) */, acPingBuffer, sizeof(acPingBuffer), NULL, pIpe, sizeof(IP_ECHO_REPLY) + sizeof(acPingBuffer), 5000);
	if (dwStatus != 0) alivecount++;
	threadcount--;
    return 0; 
}

int message(char *str) {
	HANDLE stdout = GetStdHandle(STD_OUTPUT_HANDLE);
	unsigned long cChars;
	WriteConsole(stdout, str, lstrlen(str), &cChars, NULL);
	WSACleanup();
	return -1;
}

int main(int argc, char* argv[]) {
	WSADATA wsaData;
	int ipcount = 1;
	int threadlimit = 100;
	unsigned long ip;
	DWORD id;

	message("Mass Pinger v1.0  by Boro Sitnikovski\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\nUsed as ARP filler in the MAC Spoof package.\n");

	if (WSAStartup(MAKEWORD(1, 1), &wsaData) != 0) return -1;

	// Check for correct command-line args
	if (argc < 2) return message("usage: ping <host> [ip addresses to scan to] [thread count]");
	if (argc > 2) {
		ipcount = atoi(argv[2]);
		if (ipcount < 1) return message("Invalid ip count supplied.");
	}

	ip = inet_addr(argv[1]);
	if (ip == -1) return message("Invalid IP supplied.");

	if (argc > 3) {
		threadlimit = atoi(argv[3]);
		if (threadlimit < 1) return message("Invalid thread limit supplied.");
	}

	// Load the ICMP.DLL
	HINSTANCE hIcmp = LoadLibrary("ICMP.DLL");
	if (hIcmp == 0) return message("Unable to locate ICMP.DLL!");

	// Look up an IP address for the given host name

	// Get handles to the functions inside ICMP.DLL that we'll need
	pIcmpCreateFile = (HANDLE (WINAPI *)(VOID))GetProcAddress(hIcmp, "IcmpCreateFile");
	pIcmpCloseHandle = (BOOL (WINAPI *)(HANDLE))GetProcAddress(hIcmp, "IcmpCloseHandle");
	pIcmpSendEcho = (DWORD (WINAPI *)(HANDLE,DWORD,LPVOID,WORD,PIP_OPTION_INFORMATION,LPVOID,DWORD,DWORD))GetProcAddress(hIcmp, "IcmpSendEcho");

	if ((pIcmpCreateFile == 0) || (pIcmpCloseHandle == 0) || (pIcmpSendEcho == 0)) return message("Failed to get proc addr for function.");

	// Open the ping service
	hIP = pIcmpCreateFile();
	if (hIP == INVALID_HANDLE_VALUE) return message("Unable to open ping service.");

	// Build ping packet
	memset(acPingBuffer, '\xAA', sizeof(acPingBuffer));
	pIpe = (PIP_ECHO_REPLY)GlobalAlloc(GMEM_FIXED | GMEM_ZEROINIT, sizeof(IP_ECHO_REPLY) + sizeof(acPingBuffer));
	if (pIpe == 0) return message("Failed to allocate global ping packet buffer.");
	pIpe->Data = acPingBuffer;
	pIpe->DataSize = sizeof(acPingBuffer);

	message("Please wait, processing...\n");
	// Send the ping packet
	while (ipcount--) {
		CreateThread(NULL, 0, thread_function, (LPVOID)ip, 0, (LPDWORD)&id);
		_asm {
			mov eax, dword ptr [ip]
			bswap eax;
			inc eax;
			bswap eax;
			mov dword ptr [ip], eax
		}
		threadcount++;
		while (threadcount >= threadlimit) Sleep(50);
	}

	while (threadcount != 0) Sleep(50);

	// Shut down...
	GlobalFree(pIpe);
	FreeLibrary(hIcmp);

	WSACleanup();
	return 0;
}
