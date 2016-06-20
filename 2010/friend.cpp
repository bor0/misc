#include <iostream>

using namespace std;

class Cake;
class Boro;

int readmoney(Cake);

class Cake {
	friend int readmoney(Cake A);
	friend class Boro;

	private:
		int money;
	public:
		Cake() {
			money = 1337;
		}
};

class Boro {
	public:
		Boro() {}
		int readmoney(Cake A) {
			return A.money;
		}
};

int readmoney(Cake A) {
	return A.money;
}

int main() {
//friend Cake A;
cout << '3';
return 0;
}