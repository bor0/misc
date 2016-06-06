#include <stdio.h>

#define max 30

/* Pascals triangle
 *
 * This program prints out pascals triangle.
 *
 * written on 15/05/2006
 *
 * learned this today at school and got an idea to write it as
 * a program. written in 5 mins, ok? :-)
 *
 * Bor0
 *
 */

/* masm32 example of pascal();

pascaltri PROC pointer:DWORD, members:DWORD

mov eax, members
mov ecx, 4
mul ecx
add eax, 4
push eax
mov ecx, pointer

mov dword ptr [ecx], 1

@@:
mov edx, dword ptr [ecx+eax-4]
add dword ptr [ecx+eax], edx

sub eax, 4
test eax, eax
jg @B

pop eax
mov dword ptr [ecx+eax], 1

ret

pascaltri ENDP

*/

int pascal(int *moo, int members) {

int i=0;

moo[0] = 1;

for (i=members-1;i>0;i--) moo[i]+=moo[i-1];

moo[members-1] = 1;

return 0;

}

int main() {

int i=0;
int x=0;
int z=0;

int moo[max];

printf("How many members do you want? (maximum is defined %d in program) ", max);
scanf("%d", &z);

if (z>30) {
printf("Sorry value you entered is higher than max.\n");
return 0;
}

/* here starts main loop */
for (i=1;i<=z;i++) {
pascal(moo, i);

// enable for aligning
//for (x=0;x<z-i;x++) printf(" ");

for (x=0;x<i;x++) printf("%d ", moo[x]);

// if you enable this, enable aligning too nice gfx =)
// make sure you disable previous line
//for (x=0;x<i;x++) printf("%d ", moo[x]%2);

printf("\n");

}
/* here ends main loop */

return 0;

}

