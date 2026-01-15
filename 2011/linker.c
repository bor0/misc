#include <stdio.h>
#include "include/sqlite3.h"

#pragma comment(lib, "lib/sqlite3.lib")

static int callback(void *NotUsed, int argc, char **argv, char **azColName) {
	printf("(%s) %s [%s]\n", argv[0], argv[1], argv[2]);
	return 0;
}

int main() {
	sqlite3 *db;
	int rc = sqlite3_open("db/linker.db", &db);
	char pick = '1';
	char *zErrMsg;
	char buff[64];
	char parsed[sizeof(buff) + 64];
	int i;

	if (rc) {
		fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
		return 0;
	}

	while (pick == '1' || pick == '2' || pick == '3' || pick == '4') {
		printf("Please select an option:\n1) Add a new entry.\n2) Receive an entry.\n3) *Delete an entry.\n4) List the last ID.\n");
		zErrMsg = 0;
		pick = getch();
			switch (pick) {
				case '1':
					i = 0;
					printf("Please enter a URL: ");
					scanf("%64s", buff);
					if ((strncmp(buff, "http://", 7) != 0) &&
					(strncmp(buff, "https://", 8) != 0) &&
					(strncmp(buff, "ftp://", 6) != 0)) {
						if (strncmp(buff, "www.", 4) == 0) for (i=4;i<strlen(buff);i++) if (buff[i] == '.') {
							i = -1;
							break;
						}
					}
					else i = -1;
					if (i != -1) {
						printf("That url is not valid.\n");
						break;
					}
					sprintf(parsed, "INSERT INTO LINKER (data, timeEnter) VALUES ('%s', DATE())", buff);
					rc = sqlite3_exec(db, parsed, callback, 0, &zErrMsg);
					if (rc != SQLITE_OK) {
						fprintf(stderr, "SQL error: %s\n", zErrMsg);
						sqlite3_free(zErrMsg);
						pick = 0;
					}
					break;
				case '2':
						printf("Please enter an ID: ");
						scanf("%15s", buff);
						sprintf(parsed, "SELECT * FROM LINKER WHERE ID = %s", buff);
					    rc = sqlite3_exec(db, parsed, callback, 0, &zErrMsg);
						if (rc != SQLITE_OK) {
							fprintf(stderr, "SQL error: %s\n", zErrMsg);
							sqlite3_free(zErrMsg);
							pick = 0;
						}
					break;
				case '3':
						printf("Please enter an ID: ");
						scanf("%15s", buff);
						sprintf(parsed, "DELETE FROM LINKER WHERE ID = %s", buff);
					    rc = sqlite3_exec(db, parsed, callback, 0, &zErrMsg);
						if (rc != SQLITE_OK) {
							fprintf(stderr, "SQL error: %s\n", zErrMsg);
							sqlite3_free(zErrMsg);
							pick = 0;
						}
					break;
				case '4':
					    rc = sqlite3_exec(db, "SELECT * FROM LINKER WHERE ID = (SELECT MAX(ID) FROM LINKER)", callback, 0, &zErrMsg);
						if (rc != SQLITE_OK) {
							fprintf(stderr, "SQL error: %s\n", zErrMsg);
							sqlite3_free(zErrMsg);
							pick = 0;
						}
					break;
				default:
					break;
		}
		putchar('\n');
	}

	sqlite3_close(db);
	return 0;
}