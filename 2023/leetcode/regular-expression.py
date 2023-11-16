# Haskell version was very easy to write and worked on the first time.
# This is based on that one

def match(s, p, pr = False):
    if not s and not p:
        return True

    if s: x, xs = s[0], s[1:]
    if p: y, ys = p[0], p[1:]

    if p and y == '.' and ys and ys[0] and ys[0] == '*':
        if pr: print("1", s, p)
        return any(match(s[i:], ys[1:]) for i in range(len(s) + 1))
    elif p and ys and ys[0] and ys[0] == '*':
        if not s: s = ''
        if pr: print("2", s, p)
        k = 0
        while y * k == s[:k]: k += 1
        return any(match(s[i:], ys[1:]) for i in range(k))
    elif s and p and y == '.':
        if pr: print("3", s, p)
        return match(xs, ys)
    elif s and p and x == y:
        if pr: print("4", s, p)
        if pr: print(xs,ys)
        return match(xs, ys)
    
    return False

examplePairs = [
  ("abc", "abc"),
  ("abc", "a.c"),
  ("abc", ".*c"),
  ("abc", "a*bc"),
  ("", ".*"),
  ("abc", ""),
  ("", ""),
  ("abcd", "a.d"),
  ("a1b2c3", "a.b.c"),
  ("xy", ".."),
  ("aaab", "a*b"),
  ("ab", ".."),
  ("abcd", "a.*d"),
  ("aaaaaa", "aaa*"),
  ("xyz", "...*"),
  ("abc", "abc*"),
  ("abcde", "a.*e"),
  ("xyxxy", "x.*y.*x"),
  ("a.b.c", "a.b.c"),
  ("123*", "123*"),
  ("aab", "aab"),
  ("aaabbb", "ab"),
  ("abc", "ABC"),
  ("AbC", "aBc"),
  ("aaaabbbbcccc", "abc*"),
  ("aab", "c*a*b"),
  ("mississippi", "mis*is*ip*."),
  ("mississippi", "mis*is*p*."),
  ("aaa", "ab*a"),
  ("a", "ab*"),
  ("a", ".*..a*"),
]

for (s, p) in examplePairs:
  print("%s, %s = %s" % (s, p, match(s, p)))
