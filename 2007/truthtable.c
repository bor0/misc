// construct a truthtable for the statement: (p or q) and (q or r) <=> (p and q) or (r and p)
// 2^n 

#define exp (((p || q) && (q || r)) == ((p && q) || (r && p)))

#include <stdio.h>

int main() {
int p,q,r;

printf("| p | q | r | Result\n");
printf("====================\n");
for (p=1;p!=-1;--p)
for (q=1;q!=-1;--q)
for (r=1;r!=-1;--r) {
printf("| %d | %d | %d | ", p, q, r);
printf("%d\n", exp);

}

return 0;
}
