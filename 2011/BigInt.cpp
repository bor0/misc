#include <iostream>

// TODO: Implement negative numbers, rework the functions that are not implemented

using namespace std;

class BigInt {
	char *Number;
	BigInt *Remainder;
	unsigned int size;
	int i, j;

	char Index(int index) {
		if (index >= size) return '\0';
		return Number[index];
	}

	void StringCopy(char *dest, const char *src) {
		while(*dest++ = *src++);
	}

	void Increase() {
		i = size-1;

		while (i>=0) {
			if (Number[i] == '9') Number[i] = '0';
			else { Number[i]++;	break; }
			i--;
		}

		if (Number[0] == '0') {
			size++;
			char *tmp = new char[size+1];
			tmp[0] = '1';
			StringCopy(tmp+1, Number);
			delete Number;
			Number = tmp;
		}
	}

	void Add(char *a) {
		bool overflow = false, needscopy = false;
		char *t, *u;
		i=0;
		while (a[i] != '\0') i++;

		j = size;

		if (i > j) {
			t = new char[i+1];
			u = Number;
			size = i;
			StringCopy(t, a);
			t[i] = '\0';
			needscopy = true;
		} else {
			t = Number;
			u = a;
			j = i;
			i = size;
		}

		i--; j--;

		while (i>=0 && j>=0) {
			t[i] += u[j] - '0';
			if (overflow) {
				t[i]++;
				overflow = false;
			}
			if (t[i] > '9') {
				t[i] -= 10;
				overflow = true;
			}
			i--; j--;
		}

		while (overflow && i>=0) {
			if (t[i+1] > '9') t[i+1] -= '9';
			else if (t[i+1] < '0') t[i+1] += '0'-1;

			t[i]++;
			overflow = false;
			if (t[i] > '9') {
				overflow = true;
				t[i]-='9';
			}
			i--;
		}

		if (overflow) {
			size++;
			u = new char[size+1];
			u[size] = '\0';
			u[0] = '1';
			StringCopy(u+1, t);
			u[1] = '0';
			delete t;
			t = u;
			needscopy = true;
		}

		if (needscopy) delete Number;
		Number = t;
	}

	// ???Not Implemented
	void Multiply(char *a) {

	}

	void Decrease() {
		i = size-1;
		if (Number[0] == '0' && size == 1) return;

		while (i>=0) {
			if (Number[i] == '0') Number[i] = '9';
			else { Number[i]--; break; }
			i--;
		}

		if (Number[0] == '0' && size != 1) {
			size--;
			char *tmp = new char[size+1];
			StringCopy(tmp, Number+1);
			delete Number;
			Number = tmp;
		}
	}

	// ???Not Implemented
	void Sub(char *a) {

	}

	// Needs Testing
	void Divide(char *a) {
		BigInt t(a), u("0"), v(Number);

		if (Remainder) {
			delete Remainder;
			Remainder = new BigInt("0");
		}

		while (v > t) {
			v -= t;
			u++;
		}

		Remainder->Number = v.Number;
		Number = u.Number;
		size = u.size;
	}

public:

	BigInt(char *a) {
		size=0;

		while (a[size] != '\0') size++;
		for (i=0;i<size;i++) if (a[i] != '0') break;

		if (i == size) {
			Number = new char[2];
			Number[0] = a[0];
			Number[1] = '\0';
			size = 1;
			return;
		}

		Number = new char[size-i+1];
		for (i,j=0;i<size;i++) if (a[i] > '9' || a[i] < '0') continue;
		else Number[j++] = a[i];
		Number[j] = '\0';
		size = j;
	}

	BigInt(const BigInt &a) {
		size = a.size;
		Number = new char[size+1];
		for (i=0;i<size;i++) if (a.Number[i] > '9' || a.Number[i] < '0') Number[i] = '0';
		else Number[i] = a.Number[i];
		Number[size] = '\0';
	}

	~BigInt() {
		delete Number;
		if (Remainder) delete Remainder;
	}

	unsigned int Length() {
		size=0;
		while (Number[size] != '\0') size++;
		return size;
	}

	/*
	 * Operators
	 */

	// Prefix increase
	char *operator++() {
		Increase();
		return Number;
	}

	// Postfix increase
	char *operator++(int) {
		char *tmp;
		tmp = new char[size+1];
		for (i=0;i<size;i++) tmp[i] = Number[i];
		tmp[size] = '\0';
		Increase();
		return tmp;
	}

	// Addition
	char *operator+=(char *a) {
		Add(a);
		return Number;
	}

	// Addition
	char *operator+(char *a) {
		BigInt t(Number);
		t.Add(a);
		return t.Number;
	}

	// Addition with another BigInt
	char *operator+=(BigInt &a) {
		Add(a.Number);
		return Number;
	}

	// Addition with another BigInt
	char *operator+(BigInt &a) {
		BigInt t(a);
		t.Add(Number);
		return t.Number;
	}

	// Multiplication
	char *operator*=(char *a) {
		Multiply(a);
		return Number;
	}

	// Multiplication
	char *operator*(char *a) {
		BigInt t(Number);
		t.Multiply(a);
		return Number;
	}

	// Multiplication with another BigInt
	char *operator*=(BigInt &a) {
		Multiply(a.Number);
		return Number;
	}

	// Multiplication with another BigInt
	char *operator*(BigInt &a) {
		BigInt t(a);
		t.Multiply(Number);
		return t.Number;
	}

	// Prefix decrease
	char *operator--() {
		Decrease();
		return Number;
	}

	// Postfix decrease
	char *operator--(int) {
		char *tmp;
		tmp = new char[size+1];
		for (i=0;i<size;i++) tmp[i] = Number[i];
		tmp[size] = '\0';
		Decrease();
		return tmp;
	}

	// Subtraction
	char *operator-=(char *a) {
		Sub(a);
		return Number;
	}

	// Subtraction
	char *operator-(char *a) {
		BigInt t(Number);
		t.Sub(a);
		return t.Number;
	}

	// Subtraction with another BigInt
	char *operator-=(BigInt &a) {
		Sub(a.Number);
		return Number;
	}

	// Subtraction with another BigInt
	char *operator-(BigInt &a) {
		BigInt t(Number);
		t.Sub(a.Number);
		return t.Number;
	}

	// Division
	char *operator/=(char *a) {
		Divide(a);
		return Number;
	}

	// Division
	char *operator/(char *a) {
		BigInt t(Number);
		t.Divide(a);
		return t.Number;
	}

	// Division with another BigInt
	char *operator/=(BigInt &a) {
		Divide(a.Number);
		return Number;
	}

	// Division with another BigInt
	char *operator/(BigInt &a) {
		BigInt t(Number);
		t.Divide(a.Number);
		return t.Number;
	}

	// Logical greater than
	bool operator>(BigInt &a) {
		if (a.size < size) return true;
		else if (a.size > size) return false;
		else
		for (i=0;i<size;i++)
			if (a.Number[i] > Number[i]) return true;
			else return false;
	}

	// Logical greater or equal to
	bool operator>=(BigInt &a) {
		if (a.size < size) return true;
		else if (a.size > size) return false;
		else
		for (i=0;i<size;i++)
			if (a.Number[i] > Number[i]) return true;
			else if (a.Number[i] < Number[i]) return false;
		return true;
	}

	// Logical lower than
	bool operator<(BigInt &a) {
		if (a.size > size) return true;
		else if (a.size < size) return false;
		else
		for (i=0;i<size;i++)
			if (a.Number[i] < Number[i]) return true;
			else return false;
	}

	// Logical lower or equal to
	bool operator<=(BigInt &a) {
		if (a.size > size) return true;
		else if (a.size < size) return false;
		else
		for (i=0;i<size;i++)
			if (a.Number[i] < Number[i]) return true;
			else if (a.Number[i] > Number[i]) return false;
		return true;
	}

	// Logical equal with a constant string
	bool operator==(BigInt &a) {
		if (a.size != size) return 0;
		for (i=0;i<size;i++) if (a.Number[i] != Number[i]) return 0;
		return 1;
	}

	// Logical equal with another BigInt
	bool operator==(char *a) {
		j=0;
		while (a[j] != '\0') j++;

		if (j != size) return 0;
		for (i=0;i<size;i++) if (a[i] != Number[i]) return 0;
		return 1;
	}

	// Assignment operator with a constant string
	char *operator=(char *a) {
		size=0;
		while (a[size] != '\0') size++;

		delete Number;

		for (i=0;i<size;i++) if (a[i] != '0') break;

		if (i == size) {
			Number = new char[2];
			Number[0] = a[0];
			Number[1] = '\0';
			size = 1;
			return Number;
		}

		Number = new char[size-i+1];
		for (i,j=0;i<size;i++) if (a[i] > '9' || a[i] < '0') continue;
		else Number[j++] = a[i];
		Number[j] = '\0';
		size = j;
		return Number;
	}

	// Assignment operator with another BigInt
	char *operator=(BigInt &a) {
		delete Number;
		size = a.size;
		Number = new char[size+1];
		for (i=0;i<size;i++) Number[i] = a.Number[i];
		Number[size] = '\0';
		return Number;
	}

	// Index operator
	char operator[](int index) {
		return Index(index);
	}

	// Stream operators
	friend ostream &operator<<(ostream &o, BigInt &j) { return (o << j.Number); }
	friend istream &operator>>(istream &i, BigInt &j) { i >> j.Number; j.Length(); return i; }

};

int main() {
char p = 0;
BigInt x("0");

for (int i=1;i<1000000;i++) {
x++;
cout << x << ") " << int(p++) << endl;
}

return 0;
}