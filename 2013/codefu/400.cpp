#include <string>
#include <vector>
#include <stdio.h>
using namespace std;

class BitCleanup
{
	public:

	int stringsize;
	string first, second;
	string calc(int x, int y, char bit) {
		if (x == stringsize && y == stringsize) return "";

		string tmp;
		char invertbit = (bit == '1') ? '0' : '1';

		if (first[x] == bit && x <= stringsize) {
			tmp = calc(x+1, y, invertbit);
			if (std::string::npos == tmp.find("3")) return '1' + tmp;
		}

		if (second[y] == bit && y <= stringsize) {
			tmp = calc(x, y+1, invertbit);
			if (std::string::npos == tmp.find("3")) return '2' + tmp;
		}

		return "3";
	}

	string cleanBits(string firstArray, string secondArray) {
		stringsize = firstArray.size();
		first = firstArray;
		second = secondArray;
		return calc(0, 0, '1');
	}
};

int main() {
BitCleanup x;
printf("%s\n", x.cleanBits("001110", "101100").c_str());
}