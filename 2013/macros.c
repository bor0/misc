#include <stdio.h>

#define def(x, y) y def_ ## x(int z) {\
    printf("[Function: " #x ", Returns: " #y "] %d\n", z);\
}

#define BORO BOROYO

#define STR(x)   #x
#define SHOW_DEFINE(x) printf("%s = %s\n", #x, STR(x))


int main() {
    def(test, int);
    def_test(3);
    def(test2, char);
    def_test2(3);
    SHOW_DEFINE(BORO);
    return 0;
}

