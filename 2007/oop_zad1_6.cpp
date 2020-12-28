// Napisana od Boro Sitnikovski
// 11.05.2009 Vezba VI

#include <iostream>

class Employee {
public:
char ime[50];
int platanacas;

int pay(int obrabotenicasevi) {
return platanacas * obrabotenicasevi;
}
};

class Manager: public Employee {
public:
int isplaten;
int pay(int obrabotenicasevi) {
if (!isplaten) return platanacas * obrabotenicasevi;
else return platanacas;
}
};

int main() {
return 0;
}
