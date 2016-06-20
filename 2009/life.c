//done by BoR0, 01.03.2006
//fixed 31.08.2009 (also made vreme.php)

#include <stdio.h>

unsigned char month[] = { 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };

int d,d2,m,m2,y,y2;
int pmd,x;
int days=0;

int main() {

printf("Input the date when you were born (DD MM YYYY): ");
scanf("%d%d%d", &d, &m, &y);

printf("Input today's date (DD MM YYYY): ");
scanf("%d%d%d", &d2, &m2, &y2);

if (m>12 || m2>12) {
	printf("ERROR: A year cannot have more than 12 months!\n");
	return 0;
}

if ((y2<=y) && (m2<=m) && (d2<=d)) {
	printf("ERROR: You cant be born after today's date!\n");
	return 0;
}

for (pmd=1;pmd<13;pmd++) if ((m2==pmd && d2>month[pmd]) || (m==pmd && d>month[pmd])) {
	printf("ERROR: This month hasn't that much days!\n");
	return 0;
}

while ((y2!=y) || (d2!=d) || (m2!=m)) {

	days++;

	printf("%d,%d,%d\n%d,%d,%d\n----------\n", d,m,y,d2,m2,y2);

	if ((m==12) && (d==31)) {
		d=1; m=1; y++;
	}
	else if ((m==2) && (d==28)) {
		if (((y%4==0) && (y%100 != 0)) || (y%400 == 0)) {
			days++; printf("%d,%d,%d\n%d,%d,%d\n----------\n", d+1,m,y,d2,m2,y2);
		}
		d=1; m++;
	}
	else for (pmd=12;pmd>0;pmd--)
		if ((m==pmd) && (d==month[pmd])) {
			d=1; m++;
			break;
		} else if ((m==pmd) && (d<=month[pmd])) {
			d++;
			break;
		}

}

printf("In your life you lived %d days.\n", days);

return 0;

}