/*
This file is part of Mandelbrot Example.

Mandelbrot Example is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Mandelbrot Example is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mandelbrot Example. If not, see <http://www.gnu.org/licenses/>.

*/

#include "main.h"

void putpixel(int x, int y, int color) {

	unsigned int *ptr = (unsigned int*)screen->pixels;
	int lineoffset = y * (screen->pitch / 4);
	ptr[lineoffset + x] = color;

}

void render() {

	// Lock if you must
	if (SDL_MUSTLOCK(screen) && SDL_LockSurface(screen) < 0) {
		return;
	}

	for (unsigned int y=0; y<height; ++y)
	{
		double c_im = MaxIm - y*Im_factor;
		for (unsigned int x=0; x<width; ++x)
		{
			double c_re = MinRe + x*Re_factor;

			double Z_re = c_re, Z_im = c_im;
			bool isInside = true;
			for (unsigned int n=0; n<MaxIterations; ++n)
			{
				double Z_re2 = Z_re*Z_re, Z_im2 = Z_im*Z_im;
				if(Z_re2 + Z_im2 > 4)
				{
					isInside = false;
					break;
				}
				Z_im = 2*Z_re*Z_im + c_im;
				Z_re = Z_re2 - Z_im2 + c_re;
			}
			if (isInside) {
				putpixel(x, y, 0x0000FF);
			} else {
				//putpixel(x, y, 0xFF0000);
			}
		}
	}

	// Unlock if needed
	if (SDL_MUSTLOCK(screen)) {
		SDL_UnlockSurface(screen);
	}

	// Tell SDL to update the whole screen
	SDL_UpdateRect(screen, 0, 0, width, height);

}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nShowCmd) {

	SDL_Init(SDL_INIT_EVERYTHING);

	screen = SDL_SetVideoMode(width, height, 32, SDL_SWSURFACE);

	if (screen == NULL) {
		MessageBoxA(0, "Failed to create SDL screen.", projectTitle, MB_ICONERROR);
		return 0;
	}

	bool done = false;

	SDL_WM_SetCaption(projectTitle, NULL);

	while (!done) {
		while (SDL_PollEvent(&event)) {
			switch (event.type) {
			case SDL_QUIT:
				done=true;
				break;
			/*case SDL_KEYDOWN:
				break;*/
			}
		}

		render();
	}

	SDL_FreeSurface(screen);
	SDL_Quit();
	return 0;

}

