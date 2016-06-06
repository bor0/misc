#include <stdio.h>

int tue(char *file, char *user, char *key, int uniqueID, int mode);
int atoi(const char *s);
int strlen(const char *s);
int strcat(char * s1, const char * s2);
char *strcpy(char * s1, const char * s2);

FILE *iFile = 0;
FILE *oFile = 0;

int length;
char mybuffer[2];
char myfile[256];


int tue(char *file, char *user, char *key, int uniqueID, int mode) {

	int x,i;

	printf("starting encryption...\n\nparameters:\nfile[%s]\nuser[%s]\nkey[%s]\nid[%d]\n\n", file, user, key, uniqueID);

	iFile = fopen(file, "rb");

	if (iFile == 0) {
		printf("error: cannot open file!\n");
		return 0;
	}

	strcpy(myfile, file);
	strcat(myfile, ".tuE");

	oFile = fopen(myfile, "wb+");

	if (oFile == 0) {
		printf("error: cannot create output file, check privileges!\n");
		fclose(iFile);
		return 0;
	}

	printf("working....\n");

	x = 0; i = 0;

	while (1) {
		fread(mybuffer, sizeof(char), 1, iFile);
		if (feof(iFile) != 0) break;

		if (x>length) x=0;

		i^=user[x]+key[x];

		if (mode == 0) {
			mybuffer[0] += (user[x] ^ key[x]);
		} else {
			mybuffer[0] -= (user[x] ^ key[x]);
		}

		fwrite(mybuffer, sizeof(char), 1, oFile);

		x++;
	}

	i += 'B' + 'o' + 'R' + '0';

	fclose(iFile);
	fclose(oFile);

	if (mode == 0) {
		printf("\nfile succesfully encrypted! your unique ID is %d\nyou MUST remember your \
ID otherwise you won't be able to decrypt this file.\nencrypted file is %s.\n", i, myfile);
	} else {
		if (uniqueID != i) {
			printf("unique ID does not match. error in decryption.\n");
			remove(myfile);
		} else {
			printf("file succesfully decrypted! decrypted file is %s.\n", myfile);
		}
	}

	return 0;
}

int main(int argc, char *argv[]) {
	printf("the ultimate Encrypter v1.0 by BoR0\n-----------------------------------\n");

	if (argc<6) {
		printf("Usage: tuE.exe <filename.ext> <user> <key> <uniqueID> <E/D>\n");
		return 0;
	}

	//Filename:	argv[1]
	//Username:	argv[2]
	//Key:		argv[3]
	//ID:		argv[4]
	//E/D:		argv[5]

	length = strlen(argv[2]);

	if (strlen(argv[3]) != length) {
		printf("error: user and key must have the same length of bytes!\n");
		return 0;
	}

	length--;

	if (argv[5][0] == 'E' || argv[5][0] == 'e') {
		tue(argv[1], argv[2], argv[3], atoi(argv[4]), 0);
	} else if (argv[5][0] == 'D' || argv[5][0] == 'd') {
		tue(argv[1], argv[2], argv[3], atoi(argv[4]), 1);
	} else {
		printf("Usage: tuE.exe <filename.ext> <user> <key> <uniqueID> <E/D>\n");
		return 0;
	}

	return 0;

}
