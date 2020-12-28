#include <cmath>
#include <cstdio>
#include <vector>
#include <iostream>
#include <algorithm>
using namespace std;

int calculate_piles(int n, vector<int> &S, int piles = 1) {
	int count = 0;

	cout << "Called " << n << " with pile count of " << piles << endl;

	for (int i = 0; i < S.size(); i++) {
		if (n % S[i] == 0 && n != S[i]) {
			cout << "Dividing by " << S[i] << endl;
			count += calculate_piles( n / S[i], S, S[i] );
			n /= S[i];
			count++;
			i = 0;
		}
	}

	return count;
}

int main() {
	int q;
	cin >> q;

	while (q) {
		int n, lenS;
		vector<int> S;

		cin >> n;
		cin >> lenS;

		while (lenS) {
			int tmp;
			cin >> tmp;
			S.push_back(tmp);
			lenS--;
		}

		cout << calculate_piles(n, S) << endl;

		q--;
	}

	return 0;
}
