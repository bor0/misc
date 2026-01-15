// zlibtest.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#define SIZE 1024
#pragma comment(lib, "..\\zlib\\lib\\zlib.lib")

using namespace std;

int _tmain(int argc, _TCHAR* argv[]) {

	char buff[SIZE], *tmp;
	int avg=0,avg2=0,tmpOutLen;
	FILE *i, *o;

	fopen_s(&i, "in.txt", "rb"); fopen_s(&o, "out.txt", "wb");

	while (!feof(i)) {

		tmpOutLen = SIZE;
		avg += fread(buff, sizeof(char), SIZE, i);

		tmp = (char *)malloc(SIZE);
		compress((Bytef *)tmp, (uLongf *)&tmpOutLen, (const Bytef *)buff, SIZE);
		fwrite(tmp, sizeof(char), tmpOutLen, o);
		free(tmp);

		avg2 += tmpOutLen;

	}

	fclose(o); fclose(i);

	printf("Done! Size of uncompressed data is %d - Compression ratio is %.2f%%\n", avg, avg2/(float)avg*100);
	system("pause");

	return 0;
}
