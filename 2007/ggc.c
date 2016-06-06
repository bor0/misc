#include <stdio.h>
#include <windows.h>

unsigned char hack1[] = { 'W', 0, '3', 0, 'X', 0, \
'M', 0, 'a', 0, 'p', 0, 'H', 0, 'a', 0, 'c', 0, 'k' };

unsigned char hack2[] = { 'W', 0, '3', 0, 'X', 0, \
'V', 0, 'i', 0, 's', 0, 'i', 0, 'o', 0, 'n', 0, 'H' };

unsigned char hack3[] = { 'W', 0, '3', 0, 'X', 0, \
'S', 0, 't', 0, 'a', 0, 't', 0, 'H', 0, 'a', 0, 'c' };

unsigned char hack4[] = { 'T', 0, 'h', 0, 'u', 0, \
'n', 0, 'd', 0, 'e', 0, 'r', 0, 'R', 0, 'T', 0, '6' };

unsigned char tohack[] = { 'B', 0, 'o', 0, 'R', 0, '0', 0, 0 };

int fc(char *a, char *b) {

	int i;

	for (i=0;i<19;i++) if (a[i] != b[i]) return 0;

	return 1;

}

int main() {

	char tempbuffer[32];
	char prefix[] = "success: found %s protection at offset [%x].\nattempting to remove...\n";
	char errorpatch[] = "there was an error due to patching..\n\n";
	char success[] = "successfully patched!\n\n";

	FILE *pFile;
	int i,h1,h2,h3,h4;

	printf("ggc hack protection remover by bor0\n\
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n\n");

	pFile = fopen("ggclient.exe", "rb+");

	if (!pFile) {
		printf("error: unable to open ggclient.exe.\n");
		goto end;
	}

	printf("searching.. please wait\n");

	i=0; h1=0; h2=0; h3=0; h4=0;

	while (!feof(pFile)) {

		if (h1 != 0 && h2 != 0 && h3 != 0 && h4 != 0) break;

		fread(tempbuffer, 1, 19, pFile);

		if (fc(tempbuffer, hack1) && h1 == 0) {
			printf(prefix, "w3xmaphack", i); fseek(pFile, i, SEEK_SET);
			if (fwrite(tohack, 1, 9, pFile) == 9) { printf(success); i+=18; h1 = 1; }
			else { printf(errorpatch); h1 = 2; }
		}
		else if (fc(tempbuffer, hack2) && h2 == 0) {
			printf(prefix, "w3xvisionhack", i); fseek(pFile, i, SEEK_SET);
			if (fwrite(tohack, 1, 9, pFile) == 9) { printf(success); i+=18; h2 = 1; }
			else { printf(errorpatch); h2 = 2; }
		}
		else if (fc(tempbuffer, hack3) && h3 == 0) {
			printf(prefix, "w3xstathack", i); fseek(pFile, i, SEEK_SET);
			if (fwrite(tohack, 1, 9, pFile) == 9) { printf(success); i+=18; h3 = 1; }
			else { printf(errorpatch); h3 = 2; }
		}
		else if (fc(tempbuffer, hack4) && h4 == 0) {
			printf(prefix, "w3xclasscheck", i); fseek(pFile, i, SEEK_SET);
			if (fwrite(tohack, 1, 9, pFile) == 9) { printf(success); i+=18; h4 = 1; }
			else { printf(errorpatch); h4 = 2; }
		}

		fseek(pFile, ++i, SEEK_SET);

	}

	fclose(pFile);

	printf("done.\n");

	end:
	system("pause");

	return 0;

}