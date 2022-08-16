def calc2(s):
    x=set()
    for i in range(1,10):
        for j in range(1,10):
            if i==j: continue
            elif i+j != s: continue
            x.add(i)
            x.add(j)
    return x

def calc3(s):
    x=set()
    for i in range(1,10):
        for j in range(1,10):
            for k in range(1,10):
                if i==j or i==k or j==k: continue
                elif i+j+k != s: continue
                x.add(i)
                x.add(j)
                x.add(k)
    return x

def calc4(s):
    x=set()
    for i in range(1,10):
        for j in range(1,10):
            for k in range(1,10):
                for l in range(1,10):
                    if i==j or i==k or i==l or j==k or j==l or k==l: continue
                    elif i+j+k+l != s: continue
                    x.add(i)
                    x.add(j)
                    x.add(k)
                    x.add(l)
    return x

def calc(n, s, acc=set([])):
    L = set()
    for i in set(range(1, 10)).difference(acc):
        if n > 1: L = L.union(calc(n-1, s - i, acc.union([i])))
        elif s - i == 0: L.add(i) # n == 1

    return L

for s in range(1, 6+7+8+9 + 1): # up to 4 largest numbers
    assert(calc(2, s) == calc2(s))
    assert(calc(3, s) == calc3(s))
    assert(calc(4, s) == calc4(s))
