#include <stdio.h>
#include <time.h>


//     int tm_sec;    /* seconds after the minute (0 to 61) */
//     int tm_min;    /* minutes after the hour (0 to 59) */
//     int tm_hour;   /* hours since midnight (0 to 23) */
//     int tm_mday;   /* day of the month (1 to 31) */
//     int tm_mon;    /* months since January (0 to 11) */
//     int tm_year;   /* years since 1900 */
//     int tm_wday;   /* days since Sunday (0 to 6 Sunday=0) */
//     int tm_yday;   /* days since January 1 (0 to 365) */
//     int tm_isdst;  /* Daylight Savings Time */


int main() {

struct tm *t1;
time_t marce;

time ( &marce ); //ucitaj sistemski time
t1 = localtime ( &marce ); //vnesi informacii vo struktura

printf("Denes e %d/%d/%d\n", t1->tm_mday, t1->tm_mon, t1->tm_year + 1900);

return 0;

}
