#include <stdio.h>

int bukvi[26];

int main() {
    int i;
    char buffer[512];
    printf("Vnesi recenica: ");
    fgets(buffer, 511, stdin);

    for (i=0; buffer[i] != '\0' && buffer[i] != '\n' && buffer[i] != '\r'; i++) {
        char c = tolower(buffer[i]) - 'a';
        if (bukvi[c]) {
            printf("NOK\n");
            return 0;
        }
        bukvi[c] = 1;
    }

    printf("OK\n");

    return 1;
}
