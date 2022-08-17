import functools

def hash1(i):
  return functools.reduce(lambda a, b: ord(b)%10 + a, i, 0)

def hash2(i):
  return functools.reduce(lambda a, b: ord(b)%10 * a, i, 1)

def calc_bloom(i, hashes, bloom = {}):
  for h in hashes:
    bloom[h(i)] = 1

  return bloom

def in_bloom(i, hashes, bloom):
  probably_present = True
  for h in hashes:
    if h(i) not in bloom or bloom[h(i)] != 1: probably_present = False

  return probably_present

def printer(i, hashes, bloom):
  if in_bloom(i, hashes, bloom): print('"%s" probably present in bloom' % i)
  else: print('"%s" definitely not present in bloom' % i)

bloom = calc_bloom("hello", [hash1, hash2], {})

printer("hello", [hash1, hash2], bloom)
printer("heeey", [hash1, hash2], bloom)
