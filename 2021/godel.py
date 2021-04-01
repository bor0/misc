from functools import reduce

def str_to_intlist(s):
  L     = []
  L[:0] = s

  return L

def intlist_to_ord(L):
  return list(map(lambda x: ord(x) - ord('a') + 1, L))

def gen_primes():
    D = {}
    q = 2

    while True:
        if q not in D:
            yield q
            D[q * q] = [q]
        else:
            for p in D[q]:
                D.setdefault(p + q, []).append(p)
            del D[q]

        q += 1

def string_to_number(s):
  L = str_to_intlist(s)
  L = intlist_to_ord(L)

  p = gen_primes()
  L = list(map(lambda x: next(p) ** x, L))

  product = reduce(lambda x, y: x * y, L)

  return product

print(string_to_number('hello'))
print(string_to_number('there'))
