/* qsort example */
#include <stdio.h>
#include <stdlib.h>

int values[] = { 40, 10, 100, 90, 20, 25 };

int compare (const void * a, const void * b)
{
a=1;
printf("%p\n", a);
}

int main ()
{
  int n;
compare(0,0);
return 0;
 // qsort (values, 6, sizeof(int), compare);
  for (n=0; n<6; n++)
     printf ("%d ",values[n]);
  return 0;
}