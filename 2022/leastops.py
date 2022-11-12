# given ops +1,-1,:2 find least number of ops to get to 1
def calc(n):
    # base cases
    if n == 0 or n == 1: return 0
    if n == 3: return 2

    # greedily divide by 2
    if n % 2 == 0: return 1 + calc(n//2)

    # count number of incs/decs to figure which of n+1 and n-1 has most divisions
    incs, decs = 0, 0
    k = n+1
    while (k//2) % 2 == 0: (incs, k) = (incs+1, k//2)
    k = n-1
    while (k//2) % 2 == 0: (decs, k) = (decs+1, k//2)

    if incs > decs: return 1 + calc(n+1)
    else: return 1 + calc(n-1)

def calc_iter(n):
    s = 0
    # base cases
    while True:
        if n == 0 or n == 1: return 0+s
        if n == 3: return 2+s

        # greedily divide by 2
        if n % 2 == 0:
            s += 1
            n//=2
            continue

        # count number of incs/decs to figure which of n+1 and n-1 has most divisions
        incs, decs = 0, 0
        k = n+1
        while (k//2) % 2 == 0: (incs, k) = (incs+1, k//2)
        k = n-1
        while (k//2) % 2 == 0: (decs, k) = (decs+1, k//2)

        if incs > decs:
            s += 1
            n = n+1
        else:
            s += 1
            n = n-1

def calc_iter_faster(n):
    s = 0
    # base cases
    while True:
        if n == 0 or n == 1: return 0+s
        if n == 3: return 2+s

        # greedily divide by 2
        if n & 1 == 0:
            s += 1
            n>>=1
            continue

        # count number of incs/decs to figure which of n+1 and n-1 has most divisions
        incs, decs = 0, 0
        j = n+1
        while j & 1 == 0: (incs, j) = (incs+1, j>>1)
        k = n-1
        while k & 1 == 0: (decs, k) = (decs+1, k>>1)

        if k > j:
            s += 1 + incs # one for +1 and other for divs
            n = j
        else:
            s += 1 + decs # one for -1 and other for divs
            n = k
