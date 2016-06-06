#include <stdio.h>

// Lista na C operatori
// Razlika pomegju scanf(" ") i scanf("%")

/*

In the C and C++ programming languages, the comma operator (represented by the token ,)
is a binary operator that evaluates its first operand and discards the result, and then
evaluates the second operand and returns this value (and type). The comma operator has
the lowest precedence of any C operator, and acts as a sequence point.

The use of the comma token as an operator is distinct from its use in function calls and
definitions, variable declarations, enum declarations, and similar constructs, where it
acts as a separator.

In this example, the differing behavior between the second and third lines is due to the
comma operator having lower precedence than assignment.

int a=1, b=2, c=3, i;   // comma acts as separator in this line, not as an operator
i = (a, b);             // stores b into i                                ... a=1, b=2, c=3, i=2
i = a, b;               // stores a into i. Equivalent to (i = a), b;     ... a=1, b=2, c=3, i=1
i = (a += 2, a + b);    // increases a by 2, then stores a+b = 3+2 into i ... a=3, b=2, c=3, i=5
i = a += 2, a + b;      // increases a by 2, then stores a = 5 into i     ... a=5, b=2, c=3, i=5
i = a, b, c;            // stores a into i                                ... a=5, b=2, c=3, i=5
i = (a, b, c);          // stores c into i                                ... a=5, b=2, c=3, i=3
*/

// ctype.h i limits.h

// for (A;B;C,D,E) => redosledot e CDE od levo kon desno

// int *a => a[0] == *a
// char a[] = "Hello" => &a[0] = a

// char, short int, int, long int, long long int, float, double, long double

struct Kandidat {
       char ime[20];;
       int godini;
} Kandidati = {"Boro Sitnikovski", 23};

int testirajstruktura(struct Kandidat *t) {
    printf("%d\n", t->godini);
    printf("%d\n", t[0].godini);
    printf("%d\n", (*t).godini);
}

int main() {
    int x,y,z,*p=(int *)0xFFFF;
    
    printf("Adresa na x e %d\n", &x);

    printf("Vnesi vrednost na x: ");
    scanf("%d", &x);

    printf("Vnesi adresa i broj za promena: ");
    scanf("%d%d", &y, &z);

    p = (int *)y;

    *(int *)y = z; // identicni komandi
    *p = z; // identicni komandi
    
    printf("x ima vrednost %d\n", x);

    system("pause");
    
    return 0;
}
