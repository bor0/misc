"""
# BSI 22.04.2013

FRACTRAN is a Turing-complete esoteric programming language invented by the mathematician John Conway.
A FRACTRAN program is an ordered list of positive fractions together with an initial positive integer input n.
The program is run by updating the integer n as follows:

1.    for the first fraction f in the list for which nf is an integer, replace n by nf
2.    repeat this rule until no fraction in the list produces an integer when multiplied by n, then halt.

"""

primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131]

def i2m(number):
	def _get_memory(prime):
		for i in range(0, len(primes)):
			if (primes[i] == prime): return i
		return -1

	L = [0] * len(primes)
	tmp = number
	i = 2
	while (i != number):
		if (tmp % i == 0):
			tmp /= i
			L[_get_memory(i)] += 1
			i -= 1
		i += 1
	return L

def m2i(L):
	prod = 1
	for i in range(0, len(L)):
		if (L[i] == 0): continue
		prod *= primes[i] ** L[i]
	return prod

def parse_fractran(input, f):
	i = 0
	while i < len(f):
		tmp = input * (f[i][0] / float(f[i][1]))

		if tmp.is_integer():
			input = tmp
			i = 0
			continue
		i += 1

	return int(input)

def parse_detailed_fractran(input, f):
	print("in: " + str(input))
	print(i2m(input))
	output = parse_fractran(input, f)
	print("out: " + str(output))
	print(i2m(output))


input = 72 # 2^3 3^2
f = [[455, 33], [11, 13], [1, 11], [3, 7], [11, 2], [1, 3]] # multiplication of 2 and 3
parse_detailed_fractran(input, f)

input = 72 # 2^3 3^2
f = [[3, 2]] # addition of 2 and 3
parse_detailed_fractran(input, f)