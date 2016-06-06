#include <iostream>
#include <math.h>

using namespace std;

class A {
	float x, y;

	public:

	A(float x=0, float y=0) {
		this->x = x; this->y = y;
	}

	A operator+(A &a) {
		return A(x+a.x, y+a.y);
	}

	A operator-(A &a) {
		return A(x-a.x, y-a.y);
	}

	A operator*(A &a) {
		return A(x*a.x, y*a.y);
	}

	A operator/(A &a) {
		if (a.x == 0 || a.y == 0) {
			cout << "Vnimanie! Delenje so nula! Nikakvi promeni ne bea napraveni vrz vektorite." << endl;
			return A(x, y);
		}
	return A(x/a.x, y/a.y);
	}

	bool operator>(A &a) {
		if (sqrt(x*x + y*y) > sqrt(a.x*a.x + a.y*a.y)) return 1;
		else return 0;
	}

	bool operator<(A &a) {
		if (sqrt(x*x + y*y) < sqrt(a.x*a.x + a.y*a.y)) return 1;
		else return 0;
	}

	bool operator==(A &a) {
		if (a.x == x && a.y == y) return 1;
		else return 0;
	}

	void operator=(const A &a) {
		x = a.x; y = a.y;
	}

	friend istream &operator>>(istream &i, A &a);
	friend ostream &operator<<(ostream &o, A &a);

};

istream &operator>>(istream &i, A &a) {
	cout << "x = "; cin >> a.x;
	cout << "y = "; cin >> a.y;
}

ostream &operator<<(ostream &o, A &a) {
	cout << "x = " << a.x << ", y = " << a.y;
}


int main() {

	int i,x,y,z,c;

	cout << "Vnesi kolku vektori sakas da kreiras: "; cin >> x;

	if (x<=0) return 0;
	A *a = new A[x];

	for (i=0;i<x;i++) {
		cout << "Inicijaliziraj go vektorot broj " << i+1 << endl;
		cin >> a[i];
	}

	cout << "Menadziranje na vektori" << endl << "-----------------------" << endl;

	while (1) {
		cout << "0. Pogledaj gi site vektori i nivnite vrednosti" << endl \
		     << "1. Promeni (reinicijaliziraj) nekoj od vektorite" << endl \
		     << "2. Soberi 2 specificni vektori" << endl \
		     << "3. Odzemi 2 specificni vektori" << endl \
		     << "4. Pomnozi 2 specificni vektori" << endl \
		     << "5. Podeli 2 specificni vektori" << endl \
		     << "6. Proveri pogolemost na 2 specificni vektori" << endl \
		     << "7. Proveri pomalost na 2 specificni vektori" << endl \
		     << "8. Sporedi dali 2 vektori se identicni" << endl \
		     << "9. Dodeluvanje vrednost od eden vektor na drug" << endl \
		     << "10. Izlez" << endl << "> "; cin >> i;

		if (i == 0) {
			for (c=0;c<x;c++)
			cout << "Vektor so reden broj " << c+1 << " = { " << a[c] << " }; " << endl;
			continue;
		} else if (i == 1) {
			cout << "Vnesi reden broj za vektorot: "; cin >> y;
			if (y-1 > x) {
				cout << "Greska, vektorot so dadeniot reden broj ne postoi." << endl;
				continue;
			} else {
				cin >> a[y-1];
				continue;
			}
		} else if (i >= 10) break;

		cout << "Vnesi go redniot broj na prviot vektor: "; cin >> y;
		cout << "Vnesi go redniot broj na vtoriot vektor: "; cin >> z;
		y-=1; z-=1;

		if (y > x || z > x) {
			cout << "Greska, vektorot so dadeniot reden broj ne postoi." << endl;
			continue;
		}

		if (i == 2) {
			a[y] = a[y] + a[z];
			cout << "Rezultat: " << a[y] << " - zacuvan vo prviot vektor." << endl;
		}
		else if (i == 3) {
			a[y] = a[y] - a[z];
			cout << "Rezultat: " << a[y] << " - zacuvan vo prviot vektor." << endl;
		}
		else if (i == 4) {
			a[y] = a[y] * a[z];
			cout << "Rezultat: " << a[y] << " - zacuvan vo prviot vektor." << endl;
		}
		else if (i == 5) {
			a[y] = a[y] / a[z];
			cout << "Rezultat: " << a[y] << " - zacuvan vo prviot vektor." << endl;
		}
		else if (i == 6) cout << "Rezultat: " << (a[y] > a[z]) << endl;
		else if (i == 7) cout << "Rezultat: " << (a[y] < a[z]) << endl;
		else if (i == 8) cout << "Rezultat: " << (a[y] == a[z]) << endl;
		else if (i == 9) {
			a[y] = a[z];
			cout << "Rezultat: Vektorot so reden broj " << y << " e identicen so " << z << "." << endl;
		}
	}

	delete [] a;

	return 0;

}
