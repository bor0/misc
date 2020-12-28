// Napisana od Boro Sitnikovski
// 23.03.2009 Vezba II

#include <iostream>

using namespace std;

class Student {
public:
char ime[64];
char prezime[64];
int d,m,g;

Student(char *ime = "", char *prezime = "", int d=0, int m=0, int g=0) {
strcpy(this->ime, ime);
strcpy(this->prezime, prezime);
this->d = d; this->m = m; this->g = g;
}

int PresmetajGodini(int d, int m, int g) {
int godina=0;
godina = g - this->g;
if (this->m > m) return godina-1;
else if (this->m == m) return godina;
else return godina+1;
}
};

int main() {
int d,m,g;

Student a;
cout << "Vnesi ime: ";
cin >> a.ime;
cout << "Vnesi prezime: ";
cin >> a.prezime;
cout << "Vnesi datum na raganje (DD MM YYYY): ";
cin >> a.d >> a.m >> a.g;

cout << "Vnesi denesen datum (DD MM YYYY): ";
cin >> d >> m >> g;

cout << a.PresmetajGodini(d, m, g) << endl;

return 0;
}
