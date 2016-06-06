k = [34, 18, 21, 50] 
v = [100, 200, 300, 400]

L = []

for x in range(0, len(k)):
	L.append([k[x], v[x]])

print(L)
list.sort(L)
print(L)