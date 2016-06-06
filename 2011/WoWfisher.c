// WoWFisher by Boro Sitnikovski
// Development time: 17.10.2011 - 24.10.2011

// Percentage increase from 52.38% to 76.74% (26.10.2011)

#include <windows.h>

#pragma comment(lib, "gdi32.lib")
#pragma comment(lib, "user32.lib")

#define WF_FishHookMatrix 20
#define WF_RedChannelMultiplication 9

#define WF_CounterStart 10
#define WF_CheckSumStart 20

#define WF_CursorHookWhite 101
#define WF_CursorHookBlack 155

#define WF_FishingCount 5

#define WF_iDec 3
#define WF_jDec 10

#define WF_WaitForSplash_ms 17000

#define WF_VerticalMinimum 64

#define BitmapPixel(b, x, y)	((b)->pixels[(y) * (b)->nWidth + (x)])
#define BITMAPPixel(b, x, y, sWidth)	bits[(y) * sWidth + (x)]

//#define DEBUG

typedef struct _BITMAPCAPTURE {
	HBITMAP hbm;
	LPDWORD pixels;
	int nWidth;
	int nHeight;
} BITMAPCAPTURE;

enum retval { WF_NOHWND = 0, WF_NOHOOK, WF_SUCCESS };

#ifdef DEBUG
HDC desktopdebug;
#endif

BOOL UpdateCapture(HWND hWnd, BITMAPCAPTURE *bmpCapture) {
	BOOL bResult = FALSE;
	HDC hdcScreen = GetDC(hWnd);
	HDC hdcCapture = CreateCompatibleDC(NULL);

	if (hdcCapture) {
		HBITMAP hbmOld = (HBITMAP)SelectObject(hdcCapture, bmpCapture->hbm);
		if (hbmOld) {
			if(BitBlt(hdcCapture, 0, 0, bmpCapture->nWidth, bmpCapture->nHeight, hdcScreen, 0, 0, SRCCOPY)) bResult = TRUE;
			SelectObject(hdcCapture, hbmOld);
		}
	}

	DeleteDC(hdcCapture);
	ReleaseDC(hWnd, hdcScreen);

	return bResult;
}

BOOL CaptureScreen(HWND hWnd, BITMAPCAPTURE *bmpCapture) {
	BOOL bResult = FALSE;
	HDC hdcCapture, hdcScreen = GetDC(hWnd);
	LPBYTE lpCapture;
	int nWidth = GetSystemMetrics(SM_CXVIRTUALSCREEN),
	nHeight = GetSystemMetrics(SM_CYVIRTUALSCREEN);
	BITMAPINFO bmiCapture = { sizeof(BITMAPINFOHEADER), nWidth, -nHeight, 1, 32, BI_RGB, 0, 0, 0, 0, 0 };

	if (!bmpCapture) return bResult;

	ZeroMemory(bmpCapture, sizeof(BITMAPCAPTURE));
	 
	hdcCapture = CreateCompatibleDC(NULL);
	 
	bmpCapture->hbm = CreateDIBSection(hdcScreen, &bmiCapture, DIB_RGB_COLORS, (LPVOID *)&lpCapture, NULL, 0);

	bmpCapture->pixels = (LPDWORD)lpCapture;
	bmpCapture->nWidth = nWidth;
	bmpCapture->nHeight = nHeight;

	return UpdateCapture(hWnd, bmpCapture);
}

int CheckForSplash(BITMAPCAPTURE *grab, int i, int j) {
	int x, y, color, sR=0, sG=0, sB=0, sum;
	unsigned char R, G, B;

	for (x = i; x < (WF_FishHookMatrix+i); x++)
	for (y = j; y < (WF_FishHookMatrix+j); y++) {
		color = BitmapPixel(grab, x, y);

		R = color>>16;
		#ifdef DEBUG
		G = (color<<16)>>24;
		B = (char)color;

		SetPixel(laserdesktop, 300+x, 300+y, RGB(R,G,B));*/
		#endif
		sR += R;
		/*sG += G;
		sB += B;*/
	}

	//sum = sR + sG + sB;

	return sR;

}

COLORREF getColor(BITMAPCAPTURE *grab, int i, int j) {
	DWORD color = BitmapPixel(grab, i, j);
	char R = color>>16, G=(color<<16)>>24, B=(char)color;
	/*if (R > G && R > B) return RGB(R, G, B);
	if (B > R && B > G) return RGB(R, G, B)
	if (G > B && G > R) return RGB(R, G, B)
	return RGB(0,0,0);*/
	return RGB(R, G, B);
}

int Init() {

	#pragma region Initialize parameters
	HWND hWnd;
	BITMAPCAPTURE bmpCapture;
	DWORD init;
	int i, j, sw=0, counter=0, prev=0, current=0, sum=0;
	HDC desktop;
	// attempt to find window
	hWnd = FindWindow(0, "World of Warcraft");
	desktop = GetDC(hWnd);

	// if an error has occured
	if (hWnd == 0) {
		// exit the application
		return WF_NOHWND;
	}

	#pragma endregion

	#pragma region Step 1 - Initialize fishing
	// press '1' (FISHING)

	PostMessage(hWnd, WM_KEYDOWN, 0x31, 0);

	init = GetTickCount();

	// unpress '1'
	PostMessage(hWnd, WM_KEYUP, 0x31, 0);
	#pragma endregion

	#pragma region Step 2 - Locate the fishing trap
	for (i=0;i<324 && sw != 1;i+=11)
	for (j=WF_VerticalMinimum;j<WF_VerticalMinimum + 64;j+=11) {
		SetCursorPos(i, j);
		Sleep(33);
		if (CheckForHookCursor(desktop) == TRUE) {
			sw = 1;
			break;
		}
	}

	if (sw != 1) return WF_NOHOOK;

	i -= 11;
	#pragma endregion

	#pragma region Step 3 - Make a cycle around the fishing trap coordinates and check for new animations
	counter = 0;
	CaptureScreen(hWnd, &bmpCapture);

	while (GetTickCount() - init < WF_WaitForSplash_ms) {
		int tmp;
		Sleep(70);
		tmp = CheckForSplash(&bmpCapture, i - WF_iDec - WF_FishHookMatrix/2, j - WF_jDec - WF_FishHookMatrix/2);
		#ifdef DEBUG
		printf("%d: %d ", GetTickCount() - init, prev);
		#endif
		current = prev - tmp;
		prev = tmp;
		if (current < 0) current *= -1;
		#ifdef DEBUG
		printf("= %d ", current);
		#endif
		if (counter > WF_CounterStart) {
			sum += current;
			#ifdef DEBUG
			printf("(avg thus far %d)", sum/counter);
			#endif
			if (counter > WF_CheckSumStart && current > (sum/counter)*WF_RedChannelMultiplication) {
				#ifdef DEBUG
				putchar('\n');
				#endif
				break;
			}
		}
		#ifdef DEBUG
		putchar('\n');
		#endif

		counter++;
		UpdateCapture(hWnd, &bmpCapture);
	}
	DeleteObject(bmpCapture.hbm);
	#pragma endregion

	#pragma region Step 4 - Animation event, grab the fish!
	SetCursorPos(i, j);
	mouse_event(MOUSEEVENTF_RIGHTDOWN, 0, 0, 0, 0);
	mouse_event(MOUSEEVENTF_RIGHTUP, 0, 0, 0, 0);
	mouse_event(MOUSEEVENTF_RIGHTDOWN, 0, 0, 0, 0);
	mouse_event(MOUSEEVENTF_RIGHTUP, 0, 0, 0, 0);
	#pragma endregion

	return WF_SUCCESS;
}

BOOL CheckForHookCursor(HDC dc) {
	CURSORINFO cursorInfo = { 0 };
	int i, j, b = WF_CursorHookBlack, w = WF_CursorHookWhite;
	cursorInfo.cbSize = sizeof(cursorInfo);

	if (GetCursorInfo(&cursorInfo)) {
		byte* bits[1000];
		ICONINFO ii = {0};
		POINT pp = cursorInfo.ptScreenPos;
		int p = GetIconInfo(cursorInfo.hCursor, &ii);
		int counter = 0, rv;
		HDC memDC = CreateCompatibleDC(dc);
		BITMAPINFO bmi;

		memset(&bmi, 0, sizeof(BITMAPINFO)); 
		bmi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
		bmi.bmiHeader.biWidth = 16;
		bmi.bmiHeader.biHeight = 16;
		bmi.bmiHeader.biBitCount = 32;
		bmi.bmiHeader.biPlanes = 1;
		bmi.bmiHeader.biCompression = BI_RGB;
		bmi.bmiHeader.biSizeImage = 0;
		bmi.bmiHeader.biXPelsPerMeter = 0;
		bmi.bmiHeader.biYPelsPerMeter = 0;
		bmi.bmiHeader.biClrUsed	= 0;
		bmi.bmiHeader.biClrImportant = 0;
		GetDIBits(memDC, ii.hbmMask, 0, bmi.bmiHeader.biHeight, (void**)&bits, &bmi, DIB_RGB_COLORS);

		for (i=0;i<16;i++)
		for (j=0;j<16;j++) {
			DWORD c = (DWORD)BITMAPPixel(bmi, i, j, 16);
			if (c == 0x00) b--;
			else if (c = 0xFF) w--;
		}

		DeleteDC(memDC);

		if (w == 0 && b == 0) return TRUE;
	}

	return FALSE;

}

int main() {
	int i = WF_FishingCount;
	#ifdef DEBUG
	desktopdebug = GetDC(0);
	#endif
	while (i != 0) {
		/*if (Init() != WF_SUCCESS) break;
		i--;*/
		Init();
		Sleep(3000);
	}
	return 0;
}