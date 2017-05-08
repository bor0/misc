#https://www.hackerrank.com/challenges/sam-and-substrings
# Enter your code here. Read input from STDIN. Print output to STDOUT
"""
      123
     /   \
    12   23
   / \   / \
  1    2    3
        \
       need to memo
       repeatable

recurse + memo
"""

""" works but timeouts """
def go_naive(inp):
  inp = str(inp)
  ub = len(inp) + 1
  s = 0
  r = (10 ** 9) + 7
  for i in range(0, ub):
    for j in range(i + 1, ub):
      s = (s + int(inp[i:j])) % r

  return s

def go_smart(inp):
  inp = int(inp)
  s = 0
  count = inp

  # chop number from the right to the left
  while count != 0:
    r = (10 ** 9) + 7
    print("<- including ", count)
    s = (s + count) % r

    if count != inp and count / 10 != 0:
      print("<- including ", count%10)
      s = (s + (count%10)) % r # also include this digit in-between (not start and not end)

    count = count / 10

  print('--')

  i = 1
  count = inp
  while (count % i) != inp:
    print("-> including ", count%i)
    s = (s + (count % i)) % r
    i = i * 10

  return s

inp = raw_input()
print(go_smart(inp))

