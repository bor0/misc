// Napisana od Boro Sitnikovski
// 27.04.2009 Vezba V

#include <iostream>

using namespace std;

class Polinom {
public: 
float *a; int len;

Polinom(float *b=0, int c=0) {
len = c;
a = new float [len];

if (c != 0 && b != 0)
for (int i=0;i<len;i++) a[i] = b[i];
}

~Polinom() {
if (len > 0) delete [] a;
}

Polinom (const Polinom &a) {

len = a.len;
this->a = new float [len];

for (int i=0;i<a.len;i++)
this->a[i] = a.a[i];

}

Polinom operator+ (Polinom &a) {
int b;

if (len>a.len) b = len;
else b = a.len;

float *c = new float [b];

for (int i=0;i<b;i++)
c[i] = a.a[i] + this->a[i];

Polinom k(c,b);
delete [] c;

return k;

}

Polinom operator- (Polinom &a) {
int b;

if (len>a.len) b = len;
else b = a.len;

float *c = new float [b];

for (int i=0;i<b;i++)
c[i] = this->a[i] - a.a[i];

Polinom k(c,b);
delete [] c;

return k;

}

Polinom operator* (Polinom &a) {
int b;

if (len>a.len) b = len;
else b = a.len;

float *c = new float [b];

for (int i=0;i<b;i++)
c[i] = this->a[i] * a.a[i];

Polinom k(c,b);
delete [] c;

return k;

}

Polinom & operator= (const Polinom &a) {
int b;

if (len>a.len) b = len;
else b = a.len;

for (int i=0;i<b;i++) this->a[i] = a.a[i];

return *this;

}

friend ostream & operator<<(ostream & out, Polinom & p);
friend istream & operator>>(istream & in, Polinom & p);

};

ostream & operator<<(ostream & out, Polinom & p) {
cout << " { ";
for (int i=0;i<p.len;i++) cout << p.a[i] << ", ";
cout << "} " << endl;
}

istream & operator>>(istream & in, Polinom & p) {
for (int i=0;i<p.len;i++) cin >> p.a[i];
}

int main() {
float a[] = { 3 };
float b[] = { 4, 2.7, 3.0 };

Polinom m(a, 1), n(b, 3), k;

cin >> m;
cout << "M = " << m << endl;
cin >> n;
cout << "N = " << n << endl;
Polinom o = m;
cout << "O = " << o << endl;
k=o;
cout << "K = " << k << endl;
o = m+n;
cout << "M+N = " << o << endl;
o = m-n;
cout << "M-N = " << o << endl;
o = m*n;
cout << "M*N = " << o << endl;

return 0;

}
