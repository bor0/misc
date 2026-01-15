import time;

def carrot(*a):
	print("Mi dade", len(a), "morkovi. Eve im gi iminjata:")
	for i in range(len(a)):
		print(a[i])

def isprime(x):
	for i in range(2,x):
		if (x%i == 0): return False
	return True

def factor(x):

	if x == 1 or x == 0: return [x]

	i = 2
	signum = False
	L = []
	x = abs(x)

	while True:
		if x%i == 0:
			L.append(i)
			x = int(x/i)
			i = 1
		elif i > x:
			break
		i = i + 1
	return L

carrot("zaki", "boro", "diksi")
y = int(input("Enter a number: "))

for i in range(0, y):
	x = factor(i)
	print("Number",i,"factorized is:",end=" ")
	print(1, end=" ")
	for p in range(len(x)):
		print("*",x[p],end=" ")
	print("")

while True:
	i = input("Would you like to start the counter? [y/n]: ")
	if i in ['y', 'ye', 'yes', 'd', 'da']:
		break
	elif i in ['n', 'no', 'nop', 'nope', 'ne']:
		quit()

begin = time.time()

for i in range(1, y, 2):
	if (len(factor(i))) == 1:
		print(i, "is prime")

end = time.time() - begin

begin2 = time.time()

for i in range(1, y, 2):
	if (isprime(i)):
		print(i, "is prime")

end2 = time.time() - begin2

#try:
#	print(float(y/end), end=" ")
#except:
#	print(0, end=" ")
#print("entries per second. Total time", end)

print("Algo I", end, "\nAlgo II", end2, end="")
try:
	print("\nRatio", str(end/end2)[:4], end="")
except:
	pass
print()