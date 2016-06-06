#include <iostream>

using namespace std;

template <class T>
class Stack {
	T *stack;
	int elements;

	public:

	Stack(T value) {
		elements = 1;
		stack = new T;
		*stack = value;
	}

	Stack() {
		elements = 0;
	}

	~Stack() {
		if (elements == 1) delete stack;
		else if (elements > 1) delete [] stack;
	}

	void Push(T value) {
		T *temp;
		temp = new T [elements+1];
		for (T i=0;i<elements;i++) temp[i+1] = stack[i];
		temp[0] = value;
		if (elements == 1) delete stack;
		else if (elements > 1) delete [] stack;
		stack = temp;
		elements++;
	}

	T Pop() {
		T *temp, value;

		if (Underflow()) return -1;
		else if (elements == 1) {
			value = *stack;
			delete stack;
		} else {
			temp = new T [elements-1];
			for (T i=0;i<elements-1;i++) temp[i] = stack[i+1];
			value = stack[0];
			delete [] stack;
			stack = temp;
		}

		elements--;
		return value;

	}

	bool Underflow() {
		return (elements <= 0);
	}

	void Display() {
		if (Underflow()) {
			cout << "The stack has no more elements." << endl;
		} else {
			cout << "Displaying stack (" << elements << " elements)" << endl;
			for (T i=0;i<elements;i++) cout << "Element " << i+1 << ": " << stack[i] << endl;
		}
	}
};

int main(void) {
	Stack<int> Datum;
	Stack<char> Tekst;

	Datum.Push(0); Datum.Push(1); Datum.Push(0); Datum.Push(2);
	Datum.Push(6); Datum.Push(0); Datum.Push(3); Datum.Push(2);

	Datum.Display();

	while (!Datum.Underflow()) cout << Datum.Pop();
	cout << endl;

	Datum.Display();
	
	cout << "Now representing char stack:" << endl;

	Tekst.Push('t'); Tekst.Push('s'); Tekst.Push('e'); Tekst.Push('T');
	Tekst.Push('r'); Tekst.Push('a'); Tekst.Push('h'); Tekst.Push('C');

	Tekst.Display();

	while (!Tekst.Underflow()) cout << Tekst.Pop();
	cout << endl;
	
	Tekst.Display();

	return 0;
}