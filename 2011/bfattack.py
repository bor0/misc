import array

def BruteForce(string):
	y = len(string) - 1
	string = bytes(str.lower(string.decode("ascii")), "ascii")

	while 1:
		func(string.decode("ascii"))
		while chr(string[y]) != 'z':
			a = array.array('B',string)
			a[y] = a[y] + 1
			string = a.tostring()
			func(string.decode("ascii"))
		a = array.array('B',string)
		a[y] = ord('a')
		p=-1
		for i in reversed(range(0, y)):
			if (chr(a[i]) != 'z'): p = i; break
			a[i] = ord('a')
		if (p == -1): return
		a[p] = a[p] + 1
		string = a.tostring()
	return

def func(x):
	#do something smart here
	print(x)

x = b"AaAa"
BruteForce(x)
