with open('input') as f:
  L = f.read().split('\n\n')
  template = L[0]
  rules    = list(filter(lambda x: x, L[1].split('\n')))
  rules    = dict(map(lambda x: (x.split(' -> ')[0], x.split(' -> ')[1]), rules))

def step(template, rules):
  ret = []
  for i in range(0, len(template) - 1):
    pair = template[i:i+2]
    if pair in rules:
      if ret == []: ret.append(template[i])
      ret.append(rules[pair] + template[i+1])

  return ''.join(ret)

def count_freq(template):
  all_freq = {}
    
  for i in template:
      if i in all_freq:
          all_freq[i] += 1
      else:
          all_freq[i] = 1

  return all_freq

for i in range(0, 10):
  template = step(template, rules)

vals = count_freq(template).values()
print(max(vals) - min(vals))
