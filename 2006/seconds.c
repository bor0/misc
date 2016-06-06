#include <stdio.h>

int main() {

int y=0;
int w=0;
int d=0;
int h=0;
int m=0;
int s=0;

printf("Enter numbar: ");
scanf("%d", &s);

for (s;s>=60;s-=60) m++;
for (m;m>=60;m-=60) h++;
for (h;h>=24;h-=24) d++;
for (d;d>=7;d-=7) w++;
for (w;w>=52;w-=52) y++;

printf("%dy, %dw, %dd, %dh, %dm, %ds\n", y, w, d, h, m, s);

return 0;
}
