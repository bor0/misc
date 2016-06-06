#include <stdio.h>

/* http://www.milaadesign.com/wizardy.html <- wtf

[16:55] <BoR0> you see
[16:55] <BoR0> the table with signs changes everytime
[16:55] <BoR0> and each number +9 has the same sign

*/


int main() {

int i;

printf("This is how the functions should look like for every number you pick:\n");

for (i=10;i<=99;i++) printf("f(%d) -> %d\n", i, (i - ( (i%10) + (i/10) ) ) );

return 0;

}
