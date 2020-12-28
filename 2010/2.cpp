#include <iostream>
#include <string>
#include <vector>
using namespace std;

class NumberRotation {
	public:

	unsigned int RotirajDesno(unsigned int N) {
		return ((N >> 1) | (N << (31)));
	}
	
	int findbits(unsigned int N) {
		int c=0;
		while (N != 0) { c++; N = N >> 1; }
		return c+1;
	}
	
	int count(unsigned int N) {
		int i,p,newnumber = findbits(N);
		
		for (i=0;i<newnumber;i++) {
			p = N;
			N = RotirajDesno(N);
			if (p == N) break;
		}
		

		printf("OK %d\n", i-1);
		return 0;
	}
};