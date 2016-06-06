#include <stdio.h>
#include <time.h>

int isleap(int year) {
return ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0));
}

int main() {
	int month[] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
	const char *den[] = { "Pon", "Vto", "Sre", "Cet", "Pet", "Sab", "Ned" };
	struct tm *t1; time_t timestruct;

	int granica;
	int bor0_d; int bor0_m;
	int bor0_a; int bor0_y;
	time(&timestruct); t1 = localtime (&timestruct);

	bor0_a = t1->tm_mday; bor0_m = t1->tm_mon;
	bor0_y = t1->tm_year+1900; bor0_d = t1->tm_wday;
	
	granica = bor0_y+100;
	
	while (bor0_y != granica) {

		bor0_d++; bor0_d%=7; bor0_a++;

		if (bor0_a > month[bor0_m]) {
			bor0_a = 1;
			bor0_m++;
			if (bor0_m > 11) {
				bor0_m=0; bor0_y++;
				if (isleap(bor0_y)) {
					month[1]=29;
					printf("Upcoming is leap!\n");
				}
				else month[1]=28;
				putchar('\n');
			}
		}

		if (((bor0_m+1 == 4)&&(bor0_a == 9)) || ((bor0_m+1 == 9)&&(bor0_a == 24)) || ((bor0_m+1 == 10)&&(bor0_a == 29)) || ((bor0_m+1 == 9)&&(bor0_a == 8)))
		printf("%02d/%02d/%d (%s)\n", bor0_a, bor0_m+1, bor0_y, den[bor0_d]);
	}
	return 0;
}