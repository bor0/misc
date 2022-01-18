# Sort wordlist by letter frequency
with open('sgb-words.txt') as f:
  words = list(filter(lambda x: x, f.read().split('\n')))

def get_word_freq(word, freq):
  return sum([ freq[letter] for letter in word])

freq = {}

for word in words:
  for letter in word:
    freq[letter] = freq.get(letter, 0) + 1

words.sort(reverse = True, key = lambda word: get_word_freq(word, freq))

for word in words:
  print(word)
