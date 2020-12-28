// Napisana od Boro Sitnikovski
// 11.05.2009 Vezba VI

#include <iostream>

using namespace std;

class Pravoagolnik {
private:

int a,b;

public:

Pravoagolnik(int a=0, int b=0) {
this->a = a; this->b = b;
}

~Pravoagolnik() {
cout << "Ovoj objekt e unisten" << endl;
}

int set(int a, int b) {
this->a = a; this->b = b;
}

int geta() {
return a;
}
int getb() {
return b;
}

void seta(int a) {
this->a = a;
}
void setb(int b) {
this->b = b;
}
int plostina() {
return 2*a + 2*b;
}

Pravoagolnik operator +(Pravoagolnik &c) {
return Pravoagolnik(a+c.a, b+c.b);
}

bool operator ==(Pravoagolnik &c) {
if (a == c.a && b == c.b) return 1;
else return 0;
}

friend istream operator >>(istream &in, Pravoagolnik &c);
friend ostream operator <<(ostream &out, Pravoagolnik &c);
};

class Kvadar : public Pravoagolnik {
private:
int c;

public:

Kvadar(int a=0, int b=0, int c=0):Pravoagolnik(a,b) {
this->c = c;
}

int setc(int c) {
this->c = c;
}

int getc() {
return c;
}

int volumen() {
return geta()*getb()*c;
}

Kvadar operator +(Kvadar &d) {
return Kvadar(geta()+d.geta(), getb()+d.getb(), getc()+d.getc());
}

bool operator ==(Kvadar &d) {
if (geta() == d.geta() && getb() == d.getb() && getc() == d.getc()) return 1;
else return 0;
}

friend istream operator >>(istream &in, Kvadar &d);
friend ostream operator <<(ostream &out, Kvadar &d);
};

istream operator >>(istream &in, Pravoagolnik &c) {
cin >> c.a >> c.b;
}

ostream operator <<(ostream &out, Pravoagolnik &c) {
cout << "a = " << c.a << "; b = " << c.b << endl;
}

istream operator >>(istream &in, Kvadar &d) {
int a,b,c;
cin >> a >> b >> c;
d.seta(a);d.setb(b);d.setc(c);
}

ostream operator <<(ostream &out, Kvadar &d) {
cout << "a = " << d.geta() << "; b = " << d.getb() << "; c = " << d.getc() << endl;
}


int main() {
Pravoagolnik a(1,2), b(3,4);

a = a + b;

cout << a;

return 0;
}
