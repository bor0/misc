#include <stdio.h>

// SITNIKOVSKI BORO 28.04.2007

#define instrukcija temp[0]

int main() {
int x,y; char strana;
char temp[4];

FILE *pFile = fopen("robot.in", "r");
FILE *qFile = fopen("robot.out", "w");

fscanf(pFile, "%d%d%s", &x, &y, &temp);

strana = temp[0];

while(fscanf(pFile, "%s", &temp) != -1) {

/*     S
     /   \
    Z     I
     \   /
       J     */

if (instrukcija == 'L') { //90 stepeni nalevo
	if (strana == 'S') strana = 'Z';
	else if (strana == 'Z') strana = 'J';
	else if (strana == 'J') strana = 'I';
	else if (strana == 'I') strana = 'S';
}

else if (instrukcija == 'D') { //90 stepeni nadesno
	if (strana == 'S') strana = 'I';
	else if (strana == 'I') strana = 'J';
	else if (strana == 'J') strana = 'Z';
	else if (strana == 'Z') strana = 'S';
}

else if (instrukcija == 'P') { //napred
	if (strana == 'S') y++;
	else if (strana == 'J') y--;
	else if (strana == 'I') x++;
	else if (strana == 'Z') x--;
}

//printf("Current location: (%d, %d) side %c\n", x, y, strana);

}

fprintf(qFile, "%d %d %c\n", x, y, strana);

fclose(pFile);
fclose(qFile);

return 0;

}
