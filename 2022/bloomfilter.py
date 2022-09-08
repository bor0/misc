import functools

def hash1(i):
  return functools.reduce(lambda a, b: ord(b)%10 + a, i, 0)

def hash2(i):
  return functools.reduce(lambda a, b: ord(b)%10 * a, i, 1)

def calc_bloom(i, hashes, bloom = set()):
  for h in hashes:
    h_bin = bin(h(i))[2:]
    for index in range(0, len(h_bin)):
      if h_bin[index] == '1': bloom.add(index)

  return bloom

def prob_in_bloom(i, hashes, bloom):
  for h in hashes:
    if h(i) in bloom: return False

  return True

def printer(i, hashes, bloom):
  if prob_in_bloom(i, hashes, bloom): print('"%s" probably present in bloom' % i)
  else: print('"%s" definitely not present in bloom' % i)

bloom = calc_bloom("hello", [hash1, hash2])

printer("hello", [hash1, hash2], bloom)
printer("helloo", [hash1, hash2], bloom)
printer("heeey", [hash1, hash2], bloom)
