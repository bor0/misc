#include <stdio.h>
#include <math.h>

/*

Why stopping at sqrt is enough:

Property:
a, b, n non-negative integers and a*b == n and a <= b
then
a <= sqrt(n) <= b

Proof:
Case 1: a == sqrt(n)
if a == sqrt(n) then b == sqrt(n)

Case 2: a != sqrt(n)
if a < sqrt(n) then
a*b < sqrt(n)*b, but since a*b == n, then
n < sqrt(n)*b, implies
sqrt(n) < b, in other words
b > sqrt(n)

Assume a > sqrt(n). Then using similar logic to above,
we arrive at b < sqrt(n). This implies that b < a.
This is a contradiction of a <= b.

There are no other cases to consider.

Thus, we have shown a*b == n and a <= b implies
a <= sqrt(n) and b >= sqrt(n)
for non-negative integers a, b and n.

QED.


*/


int prost(int x) {
    int i;
    for (i=2;i<=sqrt(x);i++) {
//    for (i=2;i*i<=x;i++) {
        if (x%i == 0) return 0;
    }
    return 1;
}

int main() {
    int i;
    
    for (i=0;i<100;i++)
        if (prost(i)) printf("%d e prost broj\n", i);

    system("pause");
    return 0;
}
