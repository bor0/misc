#include <stdio.h>

typedef enum {false=0, true} bool;

int main() {
char c;
bool p = false;
bool amp = false;
bool printed = false;
FILE *t = fopen("test.html", "r");
if (!t) return 0;

while (!feof(t)) {
	c = fgetc(t);
	if (c == '\r' || c == '\n') c = ' ';
	if (c == '>') p = false;
	else if (p) continue;
	else if (c == '<') p = true;
	else if (c == ';') amp = false;
	else if (amp) continue;
	else if (c == '&') amp = true;
	else if (printed && c != ' ') { printed = false; putchar(c); }
	else if (c == ' ' && printed == false) { putchar(' '); printed = true; }
	else if (isdigit(c) || isalpha(c)) putchar(c);
}

fclose(t);
return 0;
}