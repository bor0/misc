/*
ID: buritom1
LANG: C
TASK: friday
*/
#include <stdio.h>

int days[7];
int z = 0;

#define bor0_January 1
#define bor0_February 2
#define bor0_March 3
#define bor0_April 4
#define bor0_May 5
#define bor0_June 6
#define bor0_July 7
#define bor0_August 8
#define bor0_September 9
#define bor0_October 10
#define bor0_November 11
#define bor0_December 12

struct thetime {
int bor0_year;
int bor0_day;
int bor0_month;
};

struct thetime friday;

int increase_day() {
int februaryleap;

///////////////////////////////////////////////////
if (friday.bor0_month == bor0_January) {
if (friday.bor0_day == 31) {
friday.bor0_month++;
friday.bor0_day = 1;
} else friday.bor0_day++;
}
///////////////////////////////////////////////////
else if (friday.bor0_month == bor0_February) {
if (friday.bor0_year % 100 == 0 && friday.bor0_year % 400 == 0) februaryleap = 29; //century
else if (friday.bor0_year % 100 != 0 && friday.bor0_year % 4 == 0) februaryleap = 29;
else februaryleap = 28;

if (friday.bor0_day == februaryleap) {
friday.bor0_month++;
friday.bor0_day = 1;
} else friday.bor0_day++;
}
///////////////////////////////////////////////////
else if (friday.bor0_month == bor0_March) {
if (friday.bor0_day == 31) {
friday.bor0_month++;
friday.bor0_day = 1;
} else friday.bor0_day++;
}

///////////////////////////////////////////////////
else if (friday.bor0_month == bor0_April) {
if (friday.bor0_day == 30) {
friday.bor0_month++;
friday.bor0_day = 1;
} else friday.bor0_day++;
}
///////////////////////////////////////////////////
else if (friday.bor0_month == bor0_May) {
if (friday.bor0_day == 31) {
friday.bor0_month++;
friday.bor0_day = 1;
} else friday.bor0_day++;
}
///////////////////////////////////////////////////
else if (friday.bor0_month == bor0_June) {
if (friday.bor0_day == 30) {
friday.bor0_month++;
friday.bor0_day = 1;
} else friday.bor0_day++;
}
///////////////////////////////////////////////////
else if (friday.bor0_month == bor0_July) {
if (friday.bor0_day == 31) {
friday.bor0_month++;
friday.bor0_day = 1;
} else friday.bor0_day++;
}
///////////////////////////////////////////////////
else if (friday.bor0_month == bor0_August) {
if (friday.bor0_day == 31) {
friday.bor0_month++;
friday.bor0_day = 1;
} else friday.bor0_day++;
}
///////////////////////////////////////////////////
else if (friday.bor0_month == bor0_September) {
if (friday.bor0_day == 30) {
friday.bor0_month++;
friday.bor0_day = 1;
} else friday.bor0_day++;
}
///////////////////////////////////////////////////
else if (friday.bor0_month == bor0_October) {
if (friday.bor0_day == 31) {
friday.bor0_month++;
friday.bor0_day = 1;
} else friday.bor0_day++;
}
///////////////////////////////////////////////////
else if (friday.bor0_month == bor0_November) {
if (friday.bor0_day == 30) {
friday.bor0_month++;
friday.bor0_day = 1;
} else friday.bor0_day++;
}
///////////////////////////////////////////////////
else if (friday.bor0_month == bor0_December) {
if (friday.bor0_day == 31) {
friday.bor0_month = bor0_January;
friday.bor0_day = 1;
friday.bor0_year++;
} else friday.bor0_day++;
}
///////////////////////////////////////////////////

return z++;

}

int main() {
int n;
int i;
friday.bor0_year = 1900;
friday.bor0_day = 1;
friday.bor0_month = bor0_January;

FILE *pFile = fopen("friday.in", "r");
fscanf(pFile, "%d", &n);
fclose(pFile);

while ((friday.bor0_year != (1899+n)) || (friday.bor0_day != 31) || (friday.bor0_month != bor0_December)) {
increase_day();
if (friday.bor0_day == 13) days[z%7]++;
}

pFile = fopen("friday.out", "w");

fprintf(pFile, "%d %d %d %d %d %d %d\n", days[5], days[6],\
days[0], days[1], days[2], days[3], days[4]);

fclose(pFile);

return 0;

}

