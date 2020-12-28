// Blog napisana od Boro Sitnikovski
// 04.05.2009 Vezba IV

#include <iostream>

using namespace std;

class Napis {
public:

class Komentar {
public:
char *imeavtor, *email, *sodrzina; int popolnet;
};

char *naslov, *sodrzina; Komentar *a; int brojkomentari;

int DodadiKomentar(Komentar &k) {
int x=0;

for (int i=0; i<brojkomentari; i++) if (a[i].popolnet == 0) {
x = i;
break;
}

if (x == 0) {
Komentar *b = new Komentar [brojkomentari+3];
for (int i=0; i<brojkomentari; i++) b[i] = a[i];
delete [] a;
a = b;
x = brojkomentari+1;
}

a[x] = k;

return 0;
}

Komentar &operator [](int i) {
return a[i];
}

friend ostream & operator<<(ostream & out, Rgb & p);

};

ostream & operator<<(ostream & out, Napis & p) {
cout << p.naslov << endl << "------------------" << endl << p.sodrzina << endl << "------------------" << endl;
cout << "Komentari: (" << p.brojkomentari << ")" << endl << "++++++++++++++++++";
for (int i=0;i<p.brojkomentari;i++)
};


int main () {
return 0;
}

