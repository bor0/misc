// display every odd two-numbered number when divided by 11 gives 3 as a remainder

#include <stdio.h>
#include <math.h>

int main() {
float i,temp=0;

	for (i=0;i<99;i++) {
		temp=i;

		if (fmod(temp,11)==3 && fmod(temp,2)!= 0) { // check for remainder and odd number
			temp/=11;
			printf("%f divided by 11 -> %f\n", i, temp);
		}

	}

return 0;

}

