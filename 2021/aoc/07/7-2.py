with open('input') as f:
    L = f.read().replace("\n","").split(',')

L = [ int(x) for x in L ]

def calc_fuel(el1, el2):
    d = abs(el1 - el2)
    return d + int(d*(d-1)/2)

sums = [ sum( [ calc_fuel(el1, el2) for el2 in L if el1 != el2 ] ) for el1 in L ]
print(min(sums))
