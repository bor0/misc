unsigned int gcd(unsigned int m, unsigned int n)
{
	while(1){
		if((m %= n) == 0) return n;
		if((n %= m) == 0) return m;
	}
}


int main() {
printf("%d\n", gcd(-27, 8));
return 0;
}
