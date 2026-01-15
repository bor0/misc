#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <winsock.h>

static LRESULT CALLBACK MainDlgProc(HWND, UINT, WPARAM, LPARAM);
static HANDLE ghInstance;
int sendit(char *a);

char buffer[128];
char temp[8];
char pratena[] = "Porakata e uspesno pratena!\nSega ke logiraat.";
char problemce[] = "Imase nekoj problem vo prakanjeto.";
char communicator[] = "Communicator";
int i;

static WSADATA wsadata;
SOCKADDR_IN saServer;
LPHOSTENT lpHostEntry;
static SOCKET theSocket;

int sendit(char *a) {

	lpHostEntry = gethostbyname(a);
	theSocket = socket(AF_INET,SOCK_STREAM,0);
	saServer.sin_family = AF_INET;
	saServer.sin_addr = *((LPIN_ADDR)*lpHostEntry->h_addr_list);
	saServer.sin_port = htons(1337);

	connect(theSocket, (LPSOCKADDR)&saServer, sizeof(struct sockaddr));
	send(theSocket, buffer, strlen(buffer), 0);

	return recv(theSocket, temp, 1, 0);
}

int PASCAL WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpszCmdLine, int nCmdShow) {
	WNDCLASSEX wcx;
    
	ghInstance = hInstance;

	wcx.cbSize = sizeof(wcx);
	if (!GetClassInfoEx(NULL, MAKEINTRESOURCE(32770), &wcx)) return 0;

	wcx.hInstance = hInstance;
	wcx.hIcon = LoadIcon(hInstance, MAKEINTRESOURCE(101));
	wcx.lpszClassName = "communicatorClass";
	if (!RegisterClassEx(&wcx)) return 0;

	return DialogBox(hInstance, MAKEINTRESOURCE(100), NULL, (DLGPROC)MainDlgProc);
}


static LRESULT CALLBACK MainDlgProc(HWND hwndDlg, UINT uMsg, WPARAM wParam, LPARAM lParam) {

	switch (uMsg) {

		case WM_INITDIALOG:

			WSAStartup(0x101, &wsadata);

			return TRUE;

		case WM_COMMAND:

			if (LOWORD(wParam) == 4002) {
				if (GetDlgItemText(hwndDlg, 4001, buffer, 127) == 0) return TRUE;

				SetDlgItemText(hwndDlg, 4003, "Porakata se praka... pocekaj");
				SendMessage(hwndDlg, WM_SYSCOMMAND, SC_MINIMIZE, 0);
				MessageBox(hwndDlg, "Otkako ke stisnes na OK pocekaj malce\n\nAko ne se pojavi nisto vo\nslednite 30 sekundi zvoni doma!", communicator, MB_OK+MB_ICONINFORMATION+MB_TOPMOST);

				if (sendit("192.168.1.187") != SOCKET_ERROR) { //BoR0
					closesocket(theSocket);
					SetDlgItemText(hwndDlg, 4003, pratena+28);
					MessageBox(hwndDlg, pratena, communicator, MB_OK+MB_ICONINFORMATION+MB_TOPMOST);
					SendMessage(hwndDlg, WM_SYSCOMMAND, SC_RESTORE, 0);
				} else {
					SetDlgItemText(hwndDlg, 4003, problemce);
					MessageBox(hwndDlg, problemce, communicator, MB_OK+MB_ICONERROR+MB_TOPMOST);
					SendMessage(hwndDlg, WM_SYSCOMMAND, SC_RESTORE, 0);
				}


			}

			return TRUE;

		break;

		case WM_CLOSE:
			WSACleanup();
			EndDialog(hwndDlg, 0);
			return TRUE;
		}

		return FALSE;

}
