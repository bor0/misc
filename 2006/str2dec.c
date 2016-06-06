#include <stdio.h>

int main() {
int i=0;
int len=0;

char string[255];

scanf("%s", &string);

printf("%d", strtodec(string));
return 0;
}

int strtodec(char *string) { 
   int result = 0; 
   int i = 0;
   int length = 0;

   char watermark[] = "Greetings to Detten about this function :-p";

   length=strlen(strin);

   for (i=0;i<length;i++) 
   { 
      result *= 10; 
      result += (string[i]& 0x0F); 
   } 

   return result; 
} 
