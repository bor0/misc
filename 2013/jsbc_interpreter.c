#include <stdio.h>

void parsechar(FILE *u, char c) {
    switch (c) {
        case 1:
            fputc('[', u);
            break;
        case 2:
            fputc(']', u);
            break;
        case 3:
            fputc('(', u);
            break;
        case 4:
            fputc(')', u);
            break;
        case 5:
            fputc('+', u);
            break;
        case 6:
            fputc('!', u);
            break;
        default:
            break;
    }
}

int main(int argc, char **argv) {
    FILE *t, *u;
    char tag[5] = {0};
    char c;

    if (argc != 2) {
        printf("Usage: %s <filename.jsbc>\n", argv[0]);
        return 0;
    }

    t = fopen(argv[1], "r");

    if (t == NULL) {
        printf("ERROR: Could not open %s\n", argv[1]);
        return 0;
    }

    fscanf(t, "%4s", tag);

    if (strcmp(tag, "JSBC") != 0) {
        printf("ERROR: Not a valid JSBC file\n");
        fclose(t);
        return 0;
    }

    u = fopen("tmp.js", "w+");

    if (u == NULL) {
        printf("ERROR: Cannot create temporary output file\n");
        fclose(t);
        return 0;
    }

    while ((c = fgetc(t)) != -1) {
        parsechar(u, (c & 0xF0) >> 4);
        parsechar(u, c & 0x0F);
    }

    fclose(t);
    fclose(u);

    system("node tmp.js");

    unlink("tmp.js");

    return 1;
}