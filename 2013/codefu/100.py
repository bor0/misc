class SplitVowels:
 def split(_self_,sentence):
  vowels = ['A', 'E', 'I', 'O', 'U', 'Y', 'a', 'e', 'i', 'o', 'u', 'y']
  words = sentence.split(' ')
  computedwords = []
  for x in words:
    if len(x) > 1:
      vwls = ''
      notvwls = ''
      for i in range(0, len(x)):
        if (x[i] in vowels):
          vwls += x[i]
        else:
          notvwls += x[i]
      computedwords.append(notvwls + vwls)
    else:
      computedwords.append(x)

  return ' '.join(computedwords)