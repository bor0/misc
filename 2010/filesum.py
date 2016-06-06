import sys
sum = 0
f = open(sys.argv[1])

while f:
	x = f.readline()
	if len(x) == 0:
		break
	sum = sum + int(x)

f.close()
print("Total is " + str(sum))