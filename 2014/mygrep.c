#include <stdio.h>
#include <string.h>
#include <errno.h>

#define MAX_LINE 1024000

char *program_name;

int contains(char *str, int str_len, char *substr, int substr_len) {
    int k, len = str_len - substr_len + 1;

    if (len > 0) {
        for (k = 0; k < len; k++) {
            if (!strncmp(substr, str+k, substr_len)) return 1;
        }
    }

    return 0;
}

void parse_file(char *filename, char *substr, int substr_len) {
    char buf[MAX_LINE];
    int line_count = 0;
    char *str_display, separator[2] = {'\0', '\0'};

    FILE *t;

    if (filename == NULL) {
        filename = "";
        separator[0] = '\0';
        t = stdin;
    } else {
        separator[0] = ':';
        t = fopen(filename, "r");
    }

    if (!t) {
        printf("%s: %s: %s\n", program_name, filename, strerror(errno));
        return;
    }

    while (fgets(buf, sizeof buf, t) != NULL) {
        line_count++;
        if (contains(buf, strlen(buf), substr, substr_len)) printf("%s%s%d:%s", filename, separator, line_count, buf);
    }

    fclose(t);
}

int main(int argc, char **argv) {
    FILE *t;
    int substr_len;

    program_name = argv[0];

    if (argc < 2) {
        printf("Usage: %s MATCH [FILE...]\n", program_name);
        return 0;
    }

    substr_len = strlen(argv[1]);

    if (argc == 2) {
        parse_file(NULL, argv[1], substr_len);
    } else {
        int i = 2;
        while (argv[i] != NULL) {
            parse_file(argv[i], argv[1], substr_len);
            i++;
        }
    }

    return 1;
}