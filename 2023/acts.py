def calc(acts):

  new_acts = []

  for i in range(len(acts)-1, 0, -1):
    new_list = []
    for k in range(len(acts[i])):
      new_list.append( acts[i][k] - acts[i - 1][k] )

    new_acts.append(new_list)

  new_acts.append(acts[0])

  new_acts.reverse()

  return new_acts

acts = [
  [61, 30, 22, 11],
  [95, 48, 39, 41],
  [134, 88, 53, 49],
  [156, 97, 63, 55],
  [179, 114, 70, 59] ]

print(calc(acts))
