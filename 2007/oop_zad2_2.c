// Napisana od Boro Sitnikovski
// 23.03.2009 Vezba II

#include <iostream>

using namespace std;

class Smetka {
private:
char ime[64];
double sostojba;
public:
Smetka(char *ime, double sostojba) {
strncpy(this->ime, ime, 63);
this->sostojba = sostojba;
}

int staviNaSmetka(double a) {
sostojba+=a;
}

int podigniOdSmetka(double a) {
if (a>sostojba) return 0;
sostojba-=a;
}

char *getIme() {
return this->ime;
}

double getSostojba() {
return this->sostojba;
}

};

int main() {
int x; double d; char i[30];
cout << "Vnesi go imeto na korisnikot na smetkata: "; cin >> i;
cout << "Vnesi ja pocetnata suma na smetkata: "; cin >> d;
Smetka s(i, d);

cout << "1. Dodavanje pari na smetka" << endl;
cout << "2. Podiganje pari od smetka" << endl;
cout << "0. Kraj" << endl;

while (1) {
cout << ">";
cin >>x;
if (x == 0) break;
else {
cout << "Vnesi suma: ";
cin >> d;
if (x == 1) s.staviNaSmetka(d);
else if (x == 2) {
if (s.podigniOdSmetka(d) == 0) {
cout << "Nemate dovolno pari na smetkata" << endl;
continue;
}
}
cout << "Korisnikot " << s.getIme() << " na smetkata ima " << s.getSostojba() << " denari." << endl;
}
}
return 0;
}
