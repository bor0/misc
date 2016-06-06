#include <stdio.h>
#include <windows.h>

int ismac(char *str) {
	if (strlen(str) != 17 || str[2] != '-' || str[5] != '-' || str[8] != '-' || str[11] != '-' || str[14] != '-') return 0;
	if (strcmp(str, "00-e0-4c-4c-34-77") == 0) return 0;
	if (strcmp(str, "00-22-68-6f-25-63") == 0) return 0;
	return 1;
}

int main() {
	char buffer[MAX_PATH];
	STARTUPINFO si;
	PROCESS_INFORMATION pi;
	FILE *i;

	printf("ARP MAC Addresses Lister by Sitnikovski Boro 04.09.2010\n-------------------------------------------------------\n");

	memset(&si, 0, sizeof(si));
	memset(&pi, 0, sizeof(pi));
	si.cb = sizeof(si);
	GetWindowsDirectory(buffer, MAX_PATH);
	lstrcat(buffer, "\\system32\\cmd.exe");

	if (!CreateProcessA(buffer, "/c arp -a > arptemp.txt", NULL, NULL, FALSE, NORMAL_PRIORITY_CLASS, NULL, NULL, &si, &pi)) goto end;

	WaitForSingleObject(pi.hProcess, INFINITE);
	CloseHandle(pi.hProcess);
	CloseHandle(pi.hThread);

	i = fopen("arptemp.txt", "r");
	if (!i) goto end;

	while (!feof(i)) {
		fscanf(i, "%s", &buffer);
		if (ismac(buffer)) printf("%s\n", buffer);
	}

	fclose(i);

	memset(&si, 0, sizeof(si));
	memset(&pi, 0, sizeof(pi));
	si.cb = sizeof(si);
	GetWindowsDirectory(buffer, MAX_PATH);
	lstrcat(buffer, "\\system32\\cmd.exe");

	CreateProcessA(buffer, "/c del arptemp.txt", NULL, NULL, FALSE, NORMAL_PRIORITY_CLASS, NULL, NULL, &si, &pi);

	printf("End of ARP List.\n");

	system("pause");

	end:
	return 0;
}