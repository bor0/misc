#include <stdio.h>

#define eprintf(format, ...) fprintf(stderr, format, __VA_ARGS__)

int main() {
eprintf("%s", "test");
}