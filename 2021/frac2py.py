import math

# To execute a program:
# python frac2py.py | python
#
# To see the program's code:
# python frac2py.py

# Get prime factors
def prime_factors(n):
  factors = []
  while n % 2 == 0:
      factors.append(2)
      n = n / 2

  for i in range(3,int(math.sqrt(n))+1,2):
      while n % i == 0:
          factors.append(i)
          n = int(n / i)

  if n > 2:
      factors.append(n)

  return factors

# Get first k primes
def get_primes(k):
  primes = []
  n = 2
  while len(primes) != k:
    for i in range(2, n):
      if n % i == 0:
        break
    else:
      primes.append(n)

    n += 1

  return primes

def get_program(memory_size, data_in, program):
  primes = get_primes(memory_size)

  # Map naturals to primes (memory locations)
  primes = dict(zip(primes, range(0, len(primes))))
  data = [0]*memory_size

  # Increase the memory locations according to the input
  for loc in list(map(lambda x: primes[x] + 1, prime_factors(data_in))):
    data[loc] += 1
  
  s = 'data = ' + str(data) + '\n'
  s += 'print(data)\n\n'
  s += 'while True:\n'

  for (i, j) in program:
    # Work out the numerator
    if i == 1: i_registers = [0]
    else:
      # Get its prime factors
      i_factors = prime_factors(i)
      # Map them to the primes (memory locations)
      i_registers = list(map(lambda x: primes[x] + 1, i_factors))
  
    # Work out the denominator
    if j == 1: j_registers = [0]
    else:
      # Get its prime factors
      j_factors = prime_factors(j)
      # Map them to the primes (memory locations)
      j_registers = list(map(lambda x: primes[x] + 1, j_factors))
  
    # Count the values' frequency. The pair represents location -> value.
    # For example, [2, 2, 3] -> {(2, 2), (3, 1)}
    i_data = set([(v, i_registers.count(v)) for v in i_registers])
    j_data = set([(v, j_registers.count(v)) for v in j_registers])

    conditionals = list(map(lambda kv: "data[%d] >= %d" % (kv[0], kv[1]), j_data))
    conditionals = " and ".join(conditionals)

    s += '  if %s:\n' % conditionals
    for (loc, val) in j_data : s += '    data[%d] -= %d\n' % (loc, val)
    for (loc, val) in i_data : s += '    data[%d] += %d\n' % (loc, val)
    s += '    continue\n'
  
  s += '  break\n\n'
  s += 'print(data)'

  return s

"""
Parse filename. Input syntax:
Memory size (int)
Input data (int)
Fractions, one per line, space separated.

E.g.:
100
60
3 2
"""
def parse_input(file):
  with open(file) as f:
    L = list(filter(lambda x: x, f.read().split("\n")))
  
  memory_size = int(L[0])
  data_in = int(L[1])
  program = map(lambda x: (int(x.split(' ')[0]), int(x.split(' ')[1])), L[2:])

  return (memory_size, data_in, program)

(memory_size, data_in, program) = parse_input('input')

print(get_program(memory_size, data_in, program))
