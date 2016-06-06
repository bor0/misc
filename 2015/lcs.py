def subsequences(string):
    L = []

    if string == '': return []

    for i in range(0, len(string)):
        ss = subsequences(string[:i] + string[i + 1:])
        for s in ss:
            if s not in L: L.append(s)

    if string not in L: L.append(string)

    return L

def lcs(s1, s2):
    ss1, ss2 = subsequences(s1), subsequences(s2)

    item = ''
    maxlen = 0

    for i in ss1:
        if i in ss2 and len(i) >= maxlen:
            item, maxlen = i, len(i)

    return item

def diff(new, lcs):
    return "..."

orig = str(raw_input("Input original: "))
new  = str(raw_input("Input new: "))
lcs  = lcs(orig, new)
diff = diff(new, lcs)

print("ORIG = %s\nNEW  = %s\nLCS  = %s\nDIFF = %s" % (orig, new, lcs, diff))
