//pascaltri gfx
// written by bor0

#define STRICT
#define WIN32_LEAN_AND_MEAN

#include <windows.h>

#define maxata 256


int tehpascal(int *moo, int members) {

int i=0;

moo[0] = 1;

for (i=members-1;i>0;i--) moo[i]+=moo[i-1];

moo[members-1] = 1;

return 0;

}


int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
	int moo[maxata];
	int i=0;
	int z=0;
	HDC boro=GetDC(0);
		
	MessageBox(0, "Code fully written by BoR0. I must thank Dawai for the triangle's angle (ooh eisbaer).", "Pascal 
Triangle", MB_OK+MB_ICONINFORMATION);
	
	for (i=0;i<maxata;i++) {
			tehpascal(moo, i);
			for (z=0;z<=i;z++) {
				if ( (moo[z]%2) == 0 ) {
					SetPixel(boro, (maxata+z)+300 - i/2, i+300, 0x00FFFFFF);
				} else {
					SetPixel(boro, (maxata+z)+300 - i/2, i+300, 0);
				}
			}
		}

	return 0;
}

