#include <iostream>
using namespace std;

//max returns the maximum of the two elements
template <typename T>
T maxBoro(T a, T b) {
	return a > b ? a : b;
}

//
template <class T>
class Any2Int {
	public:
	int value;
	Any2Int(T a) {
		value = (int)a;
	}
};

int main() {
	Any2Int<double> test = 5.4; Any2Int<char> test2 = 'H';
	cout << test.value << " " << test2.value << endl;
	cout << "maxBoro(10, 15) = " << maxBoro(10, 15) << endl;
	cout << "maxBoro('k', 's') = " << maxBoro('k', 's') << endl;
	cout << "maxBoro(10.1, 15.2) = " << maxBoro(10.1, 15.2) << endl;
	return 0;
}


/*
#include <iostream>
using namespace std;

// class template:
template <class T>
class mycontainer {
	T element;
	public:
	mycontainer (T arg) {element=arg;}
	T increase () {return ++element;}
};

// class template specialization:
template <>
class mycontainer <char> {
	char element;
	public:
	mycontainer (char arg) {element=arg;}
	char uppercase () {
		if ((element>='a')&&(element<='z'))
			element+='A'-'a';
		return element;
	}
};

int main () {
	mycontainer<int> myint (7);
	mycontainer<char> mychar ('j');
	cout << myint.increase() << endl;
	cout << mychar.uppercase() << endl;
	return 0;
}
*/