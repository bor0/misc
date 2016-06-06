def differentiate(func, x, h):
	h = 1/h
	return (func(x+h)-func(x))/h

def integrate(func, a, b, n):
	dx = (b-a)/n
	sum = 0
	for i in range(1, n):
		sum = sum + func(a+i*dx)
	return sum * dx

x = integrate(lambda x: x, 1, 5, 10000000)
print(x)