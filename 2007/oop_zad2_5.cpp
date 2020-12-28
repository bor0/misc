// Napisana od Boro Sitnikovski
// 27.04.2009 Vezba V

#include <iostream>

using namespace std;

class Ispit {
public:

char imeispit[20];
int krediti;
int ocenka;

Ispit(char *ime="", int kredit=0, int ocena=0) {
ocenka = ocena; krediti = kredit; strcpy(imeispit, ime);
}

};

class Student {

public:

Ispit *a,*b;
char imeprezime[50];
char nasoka[4];
int brojispiti;

Student(char *ime, char *nasokka) {
strcpy(imeprezime, ime);
strcpy(nasoka, nasokka);
brojispiti = 0;
}

Student &operator +=(const Ispit &c) {
int i;

b = new Ispit [brojispiti+1];
for (i=0;i<brojispiti;i++) b[i] = a[i];
b[i] = c;
if (brojispiti) delete [] a;
a = b;
brojispiti++;

return *this;

}

bool operator ==(Student &a) {
if (!strcmp(a.nasoka, nasoka)) return 1;
else return 0;
}

};

void details(Student &a) {
int x=0,y=0;

for (int i=0;i<a.brojispiti;i++) {
x+=a.a[i].ocenka;
y+=a.a[i].krediti;
}

cout << "Ime i prezime: " << a.imeprezime << endl;
cout << "Broj na polozeni ispiti: " << a.brojispiti << endl;
cout << "Vkupen broj na krediti: " << y << endl;
if (a.brojispiti != 0) cout << "Prosecna ocenka: " << x/(a.brojispiti) << endl;
}

int main() {
Student a("Boro", "IKI");

Ispit b("SP", 15, 10);
Ispit c("OOP", 30, 30);

details(a);

cout << "------" << endl;
a += b;
details(a);

cout << "------" << endl;
a += c;
details(a);

return 0;
}
