#include <stdio.h>

int main() {
char string[] = "stringhere";
int i,k;

k=sizeof(string);
char buffer[k*2];

for (i=0;i<k;i++) {
buffer[i*2] = string[i];
buffer[i*2 + 1] = ' ';
}

printf("%s\n", buffer);

return 0;

}
