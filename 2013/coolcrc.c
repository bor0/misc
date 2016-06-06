#include <stdio.h>
#include <string.h>
#include <malloc.h>

char *MakeCRC(char *BitString, char *Polynomial) {
    char *Res, *CRC;
    int i, j, k;
    char DoInvert;

    j = strlen(Polynomial) - 1;

    Res = (char *)malloc(sizeof(char) * (j + 1));
    CRC = (char *)malloc(sizeof(char) * j);

    for (i=0; i<j; ++i) CRC[i] = 0;

    for (i=0; i<strlen(BitString); ++i)
    {
        DoInvert = ('1'==BitString[i]) ^ CRC[j-1];

        for (k=j-1;k>0;k--) {
            CRC[k] = CRC[k-1];
            if (Polynomial[j - k] == '1') CRC[k] ^= DoInvert;
        }

        CRC[0] = DoInvert;
    }

    for (i=0; i<j; ++i) Res[j-i-1] = CRC[i] ? '1' : '0';
    Res[j] = 0;
    free(CRC);

    return Res;
}

int main() {
    char Data[1024*1024], Polynomial[1024*1024], *Result;
    int i = 0;

    scanf("%s%s", Data, Polynomial);

    Result = MakeCRC(Data, Polynomial);

    //printf("CRC of [%s] is [%s] with P=[%s]\n", Data, Result, Polynomial);

    while (Result[i] == '0') i++;

    printf("%s\n", Result+i);

    free(Result);

    return 0;
}
