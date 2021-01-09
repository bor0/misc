#include <stdio.h>

int main(int argc, char **argv) {
    FILE *t, *u;
    char c;
    int byte = 0, remainder = 0;

    if (argc != 2) {
        printf("Usage: %s <filename.jsf>", argv[0]);
        return 0;
    }

    t = fopen(argv[1], "r");

    if (t == NULL) {
        printf("ERROR: Could not open %s\n", argv[1]);
        return 0;
    }

    u = fopen("out.jsbc", "w+");

    if (u == NULL) {
        printf("ERROR: Could not create output file\n");
        fclose(t);
        return 0;
    }

    fprintf(u, "JSBC", u);

    while ((c = fgetc(t)) != -1) {
        byte <<= 4;

        switch (c) {
            case '[':
                byte |= 1;
                break;
            case ']':
                byte |= 2;
                break;
            case '(':
                byte |= 3;
                break;
            case ')':
                byte |= 4;
                break;
            case '+':
                byte |= 5;
                break;
            case '!':
                byte |= 6;
                break;
            default:
                byte >>= 4;
                continue;
        }

        if (remainder) {
            fputc(byte, u);
            remainder = byte = 0;
        } else {
            remainder = 1;
        }
    }

    if (remainder) {
        fputc(byte, u);
    } 

    fclose(t);
    fclose(u);

    return 1;
}