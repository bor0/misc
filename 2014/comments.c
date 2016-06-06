// comments.c: Strip comments // and /* */ from source files
#include <stdio.h>

/*
 * Main entry
 */
int main() {
    int c, s, b_c = 0, n_l = 0;

    while ((c = getchar()) != EOF) {
        if (n_l) {
            if (c == '\n') n_l = 0;
            continue;
        }

        if ((s = getchar()) == EOF) {
            putchar(c);
            break;
        }

        if (b_c) {
            if (c == '*' && s == '/') b_c = 0;
        } else {
            if (c == '/' && s == '*') b_c = 1;
            else if (c == '/' && s == '/') n_l = 1;
            else {
                putchar(c);
                putchar(s);
            }
        }
    }
    return 0;
}
