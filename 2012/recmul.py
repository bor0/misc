# Recursive multiplication (nesto podobro od n^2, imeno n^
# BSI 12.03.2012

def mul(x, y, lx=None, ly=None):

	# Check if it's init
	if (lx == None or ly == None):
		lx = int(len(str(x))/2)
		ly = int(len(str(y))/2)

	# Check if reached until number of size 1
	if lx == 1 or ly == 1 or x < 10 or y < 10: return x*y

	# Initialize parameters s.t. x = dx1 + dx2 and y = dy1 + dy2
	a, b, c, d = int(str(x)[:lx]), int(str(x)[lx:]), int(str(y)[:ly]), int(str(y)[:ly])

	ac = mul(a, c)
	bd = mul(b, d)
	abcd = mul(a+b, c+d)

	return 10**(lx*2) * ac + 10**(lx)(abcd - ac - bd) + bd

x = mul(123, 555050)
print(x)
