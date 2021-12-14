with open('input') as f:
  L = f.read().split('\n\n')
  template = L[0]
  rules    = list(filter(lambda x: x, L[1].split('\n')))
  rules    = dict(map(lambda x: (x.split(' -> ')[0], x.split(' -> ')[1]), rules))

def get_letters_from_template(template):
  return {v : template.count(v) for v in template}

def get_pairs_from_template(template):
  pairs = [ template[i] + template[i+1] for i in range(0, len(template) - 1) ]
  return {v : pairs.count(v) for v in pairs}

def get_letters_from_pairs(pairs, rules, letters):
  new_letters = map(lambda pair: (rules[pair], pairs[pair]), pairs)

  letters = dict(letters)

  for (letter, count) in new_letters:
    if letter in letters: letters[letter] += count
    else: letters[letter] = count

  return letters

def get_pairs_from_pairs(pairs, rules):
  new_pairs = map(lambda pair: (pair[0] + rules[pair], rules[pair] + pair[1], pairs[pair]), pairs)

  ret = {}
  for (pair1, pair2, count) in new_pairs:
    if not pair1 in ret: ret[pair1] = 0
    if not pair2 in ret: ret[pair2] = 0
    ret[pair1] += count
    ret[pair2] += count

  return ret

def step(template, rules, count):
  assert count > 0
  # First step
  pairs = get_pairs_from_template(template)
  letters = get_letters_from_template(template)

  print(letters)
  # Subsequent steps
  for i in range(0, count):
    letters = get_letters_from_pairs(pairs, rules, letters)
    pairs   = get_pairs_from_pairs(pairs, rules)

  return letters

letters = step(template, rules, 40)
letters = letters.values()
print(max(letters) - min(letters))
