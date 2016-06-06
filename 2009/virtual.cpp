#include <iostream>

using namespace std;

class A {
public:
virtual int test() {
cout << "test" << endl;
}
};

class B : public A {
public:
int test() {
cout << "test2" << endl;
}
};

int main() {
A *a;

a = new A;
(*a).test();
delete a;

a = new B;
(*a).test();
delete a;

return 0;
}
