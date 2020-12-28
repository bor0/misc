#include <stdio.h>
// SITNIKOVSKI BORO 28.04.2007
char *smsbor0(char a) {
char bukva[] = { ' ', '.', ',', '1', 'A', 'B', 'C', '2', 'D',\
'E', 'F', '3', 'G', 'H', 'I', '4', 'J', 'K', 'L', '5', 'M', 'N',\
'O', '6', 'P', 'Q', 'R', 'S', '7', 'T', 'U', 'V', '8', 'W', 'X',\
'Y', 'Z', '9' };

char *bukvi[] = { "1", "11", "111", "1111", "2", "22", "222",\
"2222", "3", "33", "333", "3333", "4", "44", "444", "4444", "5",\
"55", "555", "5555", "6", "66", "666", "6666", "7", "77", "777",\
"7777", "77777", "8", "88", "888", "8888", "9", "99", "999",\
"9999", "99999" };

int i;

for (i=0;i<=37;i++) if (a == bukva[i]) return bukvi[i];

return 0;

}

int main() {

char str; int y; char *point;
FILE *pFile = fopen("sms.in", "r");FILE *qFile = fopen("sms.out", "w");
y=1;

while (fscanf(pFile, "%c", &str) != -1) {
point = smsbor0(str);
if (!point) break;
if (!y) fprintf(qFile, " ");
fprintf(qFile, "%s", point);
y=0;
}

fprintf(qFile, "\n");
fclose(qFile);
fclose(pFile);
return 0;

}


