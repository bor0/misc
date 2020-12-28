###########################################
max = 0
maxa = 0
maxb = 0

def checkprimes(a,b):
	global max, maxa, maxb
	def prime(x):
		if x==2:
			return True
		if x<2 or x%2 == 0:
			return False
		for i in range(3, int(x**0.5)+1, 2):
			if (x%i == 0): return False
		return True

	x = 0
	while True:
		x = x+1
		if prime(x*x + a*x + b) == False: break
	if (x > max):
		max = x
		maxa = a
		maxb = b
	return

for a in range(-1000, 1000):
	for b in range(-1000, 1000):
		checkprimes(a,b)
print(max,maxa,maxb)
###########################################
def circprime(x):
	def prime(x):
		if x==2:
			return True
		if x<2 or x%2 == 0:
			return False
		for i in range(3, int(x**0.5)+1, 2):
			if (x%i == 0): return False
		return True
	t = len(str(x))
	for i in range(0, t):
		p = int(x/10)
		p = p + 10**(t-1) * (x%10)
		x = p
		if (prime(x) == False): return False
	return True

sum=0
for i in range(1, 1000000):
	print("Testing", i)
	if (circprime(i)): sum=sum+1
print(sum)
###########################################
def test(x):
	def pentagonal(p):
		p = (1/2 + (1/4 + 6*x)**0.5)/3
		if (p != int(p)): return False
		return True
	def hexagonal(h):
		h = (1 + (1 + 8*x)**0.5)/4
		if (h != int(h)): return False
		return True
	if (pentagonal(x) == False): return False
	return hexagonal(x)

y = 286
p = int((y*y + y)/2)

for i in range(y, 10000000000):
	print("Testing", y)
	if test(p):
		print("Valid", y, p)
		quit()
	y = y+1
	p = p+y
###########################################
import sys

def sum(x): # 1001x1001 spiral
	def innersum(x):
		if (x == 1): return 1
		return 4*x*x - 6*x + 6 + sum(x-2)
	if x%2 == 0: return 0
	else: return innersum(x)

sys.setrecursionlimit(10000)
print(sum(1001))

def palindrome(x):
	t = bin(x)[2:]
	u = str(x)
	if (t == t[::-1] and u == u[::-1]): return True
	return False

sum=0
for x in range(1, 1000000):
	if palindrome(x):
		sum=sum+x
		print(x, bin(x)[2:])

print(sum)
###########################################