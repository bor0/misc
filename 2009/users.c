// Boro Sitnikovski 02.09.2009

#include <stdio.h>

char user[12][30] = { 0 };
int i;

void adduser(char *name) {

	for (i=0;i<11;i++) if (user[i][0] == '\0') {
		strcpy(user[i], name);
		break;
	}

	return;
}

void deluser(char *name) {

	for (i=0;i<11;i++) if (!strcmp(name, user[i])) {
		for (i;i<11;i++) strcpy(user[i], user[i+1]);
		break;
	}

	return;
}

void listusers() {

	printf("0) You (Host).\n");
	for (i=0;i<11;i++) printf("%d) %s\n", i+1, user[i]);

	return;
}

void workout(char *str) { // funkcijava e katastrofa!! ama raboti

	/*
	[00:00:00] [System Message] <-cpu-BoRO>[Ping:|]  has joined your game!.
	[00:00:00] [System Message] <-cpu-BoRO>  has left your game!(4).
	[00:00:00] [System Message] <-cpu-BoRO>  has left your game!(20).
	*/

	int x;

	if (!strncmp(str+11, "[System Message]", 16)) {

		i=29; //uf... posle System Message sleduva nickot

		x=strlen(str)-1;
		str[x] = '\0'; //terminiraj ja tockata+1 (dvete recenici zavrsuvaat so tocka)

		if (str[28] != '<') return; //proverka na <
		while (str[i++] != '>') if (str[i] == '\0') return; str[i-1] = '\0'; //i > (megu niv e imeto)

		if (!strcmp(str+x-22, "has joined your game!.")) adduser(str+29); //self join
		else if (!strncmp(str+x-23, "has left your game!", 19)) deluser(str+29); //self leave
		else if (!strncmp(str+x-24, "has left your game!", 19)) deluser(str+29); //leave if kicked

	}

	return;

}

int main() {
	char str[256]; FILE *pFile;

	printf("Garena Users Listing by BoR0 v1.0\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n");

	pFile = fopen("garena.txt", "r");

	if (!pFile) {
		printf("Error: Can't open Garena.txt\n");
		system("pause");
		return 0;
	}

	while (!feof(pFile)) {
		i=0;
		while ((str[i++] = fgetc(pFile)) != '\n' && !feof(pFile) && i<255);

		if (i<50) continue;

		if (str[i-1] == '\r') str[i-1] = '\0';
		else str[i] = '\0';

		workout(str);
	}

	fclose(pFile);

	listusers();

	system("pause");

	return 0;
}
