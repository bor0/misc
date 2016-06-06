#include <stdio.h>
#include "psid.h"

typedef unsigned short word;
typedef unsigned long dword;

struct PSID_header {
dword	psid;
word	version;
word	dataOffset;
word	loadAddr;
word	initAddr;
word	playAddr;
word	songs;
word	startSong;
dword	speed;
char	name[32];
char	author[32];
char	copyright[32];
word	flags;
dword	reserved;
};

struct PSID_header PSID;

int main() {
FILE *pFile;
int i;

PSID.psid = 0x44495350;
PSID.version = 0x0200;
PSID.dataOffset = 0x7C00;
PSID.loadAddr = 0;
PSID.initAddr = 0x0D80; //?
PSID.playAddr = 0x1380; //?
PSID.songs = 0x0100;
PSID.startSong = 0x0100;
PSID.speed = 0;
strcpy(PSID.name, "Rob Hewbard");
strcpy(PSID.author, "Sigma7");
strcpy(PSID.copyright, "BoR0 test sid etc");
PSID.flags = 0x1400;
PSID.reserved = 0;

pFile = fopen("file.sid", "wb");

fwrite(&PSID.psid, sizeof(dword), 1, pFile);
fwrite(&PSID.version, sizeof(word), 1, pFile);
fwrite(&PSID.dataOffset, sizeof(word), 1, pFile);
fwrite(&PSID.loadAddr, sizeof(word), 1, pFile);
fwrite(&PSID.initAddr, sizeof(word), 1, pFile);
fwrite(&PSID.playAddr, sizeof(word), 1, pFile);
fwrite(&PSID.songs, sizeof(word), 1, pFile);
fwrite(&PSID.startSong, sizeof(word), 1, pFile);
fwrite(&PSID.speed, sizeof(dword), 1, pFile);
fwrite(&PSID.name, sizeof(char), 32, pFile);
fwrite(&PSID.author, sizeof(char), 32, pFile);
fwrite(&PSID.copyright, sizeof(char), 32, pFile);
fwrite(&PSID.flags, sizeof(word), 1, pFile);
fwrite(&PSID.reserved, sizeof(dword), 1, pFile);
fwrite(psid_data, sizeof(psid_data), 1, pFile);

fclose(pFile);

return 0;
}
