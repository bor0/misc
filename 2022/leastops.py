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
