with open('input') as f:
    L = f.read().replace("\n","").split(',')

L = [ int(x) for x in L ]

def additi(x):
    return int(x*(x-1)/2)

mini = float('inf')
for el1 in L:
    suma=0
    for el2 in L:
        if el1 == el2: continue
        suma += abs(el1 - el2) + additi(abs(el1-el2))
    mini = min(suma, mini)

print(mini)
