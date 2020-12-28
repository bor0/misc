class PlasticNumbers:
 def countSets(_self_,number):

  number = str(number)
  digits = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

  for i in range(0, len(number)):

    digit = number[i]

    if (digit == '6' or digit == '9'):
      if (digits[6] > digits[9]):
        digits[9] += 1
      else:
        digits[6] += 1

    else:
      digits[int(digit)] += 1

  max = digits[0]

  for i in range (1, 10):
    if (digits[i] > max): max = digits[i]

  return max