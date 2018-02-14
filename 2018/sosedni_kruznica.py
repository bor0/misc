# Dali broevite 1 do 11 moze da se naredat
# vo kruznica taka sto sekoj broj e deliv so
# razlikata od sosedite?
import itertools

def calc(l):
    ll = []
    for i in range(len(l)):
        if i == 0:
            diff = l[len(l) - 1] - l[i + 1]
        elif i == len(l) - 1:
            diff = l[i - 1] - l[0]
        else:
            diff = l[i - 1] - l[i + 1]

        diff = abs(diff)

        if diff == 0 or l[i] % diff != 0:
            return False

    return True

stuff = range(1, 12)
for p in itertools.permutations(stuff, len(stuff)):
    if calc(p):
        print(p)
        quit()
