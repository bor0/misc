// RGB napisana od Boro Sitnikovski
// 04.05.2009 Vezba IV

#include <iostream>

using namespace std;

class Rgb {
friend ostream &operator <<(ostream &output, const Rgb &a);
friend istream &operator >>(istream &input, Rgb &a);

private:
int red, green, blue;

public:

Rgb(int red=0, int green=0, int blue=0) {
if (red<=255) this->red = red;
if (green<=255) this->green = green;
if (blue<=255) this->blue = blue;
}

~Rgb() { }

int Dominantna() {
if (red>=green && red>=blue) return red;
else if (green>=red && green>=blue) return green;
else if (blue>=red && red>=blue) return blue;
return 0;
}

Rgb operator +(const Rgb &a) {
if ((a.red + red) <= 255 && (a.green + green) <= 255 && (a.blue + blue) <= 255) {
return Rgb(red+a.red, green+a.green, blue+a.blue);
}
}

Rgb operator -(const Rgb &a) {
if ((red >= a.red) && (green >= a.green) && (blue >= a.blue)) {
return Rgb(red-a.red, green-a.green, blue-a.blue);
}
}

Rgb &operator ++() {
if ((red<255) && (green<255) && (blue<255)) {
red++; green++; blue++;
}
return *this;
}

Rgb operator ++(int) {
if ((red<255) && (green<255) && (blue<255)) {
Rgb n(*this);
red++; green++; blue++;
return n;
}
}

Rgb &operator --() {
if ((red>0) && (green>0) && (blue>0)) {
red--; green--; blue--;
}
return *this;
}

Rgb operator --(int) {
if ((red>0) && (green>0) && (blue>0)) {
Rgb n(*this);
red--; green--; blue--;
return n;
}
}

bool operator >(const Rgb &a) {
if ((a.red > red) && (a.green > green) && (a.blue > blue)) return 1;
else return 0;
}

bool operator <(const Rgb &a) {
if ((a.red < red) && (a.green < green) && (a.blue < blue)) return 1;
else return 0;
}

bool operator ==(const Rgb &a) {
if ((a.red == red) && (a.green == green) && (a.blue == blue)) return 1;
else return 0;
}

bool operator !=(const Rgb &a) {
if ((a.red != red) && (a.green != green) && (a.blue != blue)) return 1;
else return 0;
}

};

ostream &operator <<(ostream &output, const Rgb &a) {
return output << "Crvena: " << a.red << " Zelena: " << a.green << " Sina: " << a.blue << endl;
}

istream &operator >>(istream &input, Rgb &a) {
return input >> a.red >> a.green >> a.blue;
}

main() {
Rgb a(1,2,3), b(2,3,4), c;

cin >> c;

c = a+b;
cout << c;

c = b - a;

return 0;
}
