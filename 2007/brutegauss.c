#include <stdio.h>

int main() {
int x,y,z;
int a,b;
int i[12];
int c = 0;

printf("Solver of:\n");
printf("Ax + By + Cz = D\n");
printf("Ex + Fy + Gz = H\n");
printf("Ix + Jy + Kz = L\n");

for (x=0;x<12;x++) {
printf("Enter %c: ", x+65);
scanf("%d", &i[x]);
}

printf("Enter starting range: ");
scanf("%d", &a);
printf("Enter ending range: ");
scanf("%d", &b);

printf("Please wait, working...\n");

for (x=a;x<=b;x++)
for (y=a;y<=b;y++)
for (z=a;z<=b;z++)
if (((i[0]*x + i[1]*y + i[2]*z) == i[3]) &&\
   ((i[4]*x + i[5]*y + i[6]*z) == i[7]) &&\
   ((i[8]*x + i[9]*y + i[10]*z) == i[11]))
printf("%d: (x:y:z) = (%d, %d, %d)\n", ++c, x, y, z);

if (!c) {
printf("The system has no solutions in the segment [%d, %d]\n", a, b);
} else {
printf("Total solutions found: %d.\n", c);
}

printf("Done!\n");

return 0;

}
