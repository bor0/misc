from os.path import exists
from collections import Counter

if not exists('sgb-words.txt'):
  quit("Google for 'sgb-words.txt' and download it in the same cwd as this script.")

with open('sgb-words.txt') as f:
  words = list(filter(lambda x: x, f.read().split('\n')))

def all_chars_unique(string):
  freq = Counter(string)
  return len(freq) == len(string)

# A best starting word is one that does not have any repeated chars and contains as many vowels as possible
def find_best(words):
  words = list(filter(all_chars_unique, words))
  words = { len([c for c in w if c in "aeiou"]) : w for w in words}
  return words[max(words)]

def update_words(words, word, data):
  (exists, dark) = ([], set())

  for i in range(0, len(data)):
    letter = word[i]
    if data[i] == 'G':
      words = [ w for w in words if w[i] == letter ]
      exists.append(letter)
    elif data[i] == 'O':
      words = [ w for w in words if w[i] != letter and letter in w ]
      exists.append(letter)
    elif data[i] == 'D':
      dark.add(letter)

  exists = Counter(exists)

  for letter in dark:
    if letter not in exists:
      words = [ w for w in words if not letter in w ]
    else:
      words = [ w for w in words if w.count(letter) == exists[letter] ] # letter exists exactly such times

  return words

"""
def update_words_functional(words, word, data):
  processed = list(zip(word, data, range(0, len(data))))

  words = [ word for word in words if all(word[i] == c for (c, d, i) in processed if d == 'G') ] # Process Green
  words = [ word for word in words if all(word[i] != c and c in word for (c, d, i) in processed if d == 'O') ] # Process Orange

  exists = [ c for (c, d, i) in processed if d == 'G' or d == 'O' ] # Letter exists if it's either Green or Orange
  dark   = [ c for (c, d, i) in processed if d == 'D' ] # Dark letters don't exist

  words = [ word for word in words if not any(c in word for c in dark if not c in exists) ] # Process Dark

  return words
"""

word = find_best(words)

while True:
  print("Enter the following word in Wordle: " + word)
  data = input("Enter string value from Wordle (G=Green, O=Orange, D=Dark), or S to skip: ").upper()

  if data == 'S': words = [ w for w in words if w != word ]
  else: words = update_words(words, word, data)

  if len(words) == 1: quit("Solution: " + words[0])
  elif len(words) == 0: quit("No solution found.")

  word = words[0]
