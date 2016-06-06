#include <stdio.h>

int main() {
int i;
float temp;

srand(time(NULL));

for (i=1;i<100000;i++) {
temp*=(i-1);
temp+=rand()%2;
temp/=i;
}

printf("%f\n", temp);

return 0;

}
