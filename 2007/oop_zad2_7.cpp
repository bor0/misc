// Napisana od Boro Sitnikovski
// 18.05.2009 Vezba VII

#include <iostream>

using namespace std;

class NumberGenerator {

public:
int stepenuvaj(int a, int b) { //a^b
int c = 1;
for (int i=0;i<b;i++) c*=a;
return c;
}

int stepen;

NumberGenerator(int stepen) {
this->stepen = stepen;
}

void popolni(int *a, int b, int c, int d) {
for (int i=c;i<=d;i++) *(a+i) = stepenuvaj(b++, stepen);
}


};

class LinearGenerator : public NumberGenerator { public: LinearGenerator():NumberGenerator(1) {} };
class KvadratGenerator : public NumberGenerator { public: KvadratGenerator():NumberGenerator(2) {} };
class KubGenerator : public NumberGenerator {
public:

int *e, *f, brojac;

KubGenerator():NumberGenerator(3) { brojac = 0; }
~KubGenerator() { delete [] e; }
friend ostream &operator <<(ostream &out, KubGenerator &c);

void popolni(int *a, int b, int c, int d) {
int i,x;

for (int i=c;i<=d;i++) {
a[i] = stepenuvaj(b++, stepen);
f = new int [brojac+1];
for (x=0;x<brojac;x++) f[x] = e[x];
f[x] = a[i];
if (brojac) delete [] e; e = f;
brojac++;
}

}

};

ostream &operator <<(ostream &out, KubGenerator &c) {
for (int i=0;i<c.brojac;i++) cout << c.e[i] << " "; cout << "end.";
}

int main() {
int pole[5];
for (int i=0; i<5; i++) pole[i]=0;
for (int i=0; i<5; i++) cout<<"pole["<<i<<"]="<<pole[i]<<endl;
NumberGenerator gn(2);
gn.popolni(pole, 3, 1, 3);
for (int i=0; i<5; i++) cout<<"pole["<<i<<"]="<<pole[i]<<endl;
LinearGenerator lnGen;
lnGen.popolni(pole, 5, 0, 2);
for (int i=0; i<5; i++) cout<<"pole["<<i<<"]="<<pole[i]<<endl;
KvadratGenerator kvGen;
kvGen.popolni(pole, 10, 3, 4);
for (int i=0; i<5; i++) cout<<"pole["<<i<<"]="<<pole[i]<<endl;
cout << "--------" << endl;
KubGenerator kbGen;

kbGen.popolni(pole, 3, 0, 3);
kbGen.popolni(pole, 2, 1, 2);
kbGen.popolni(pole, 6, 3, 4);

for (int i=0; i<5; i++) cout<<"pole["<<i<<"]="<<pole[i]<<endl;
cout <<kbGen<<endl;
return 0;

}
