"""
Start with (
   (
Then branch with ( or )
   (
  / \
 (   )
Do this recursively
   (
  / \
 (   )
/ \ / \
.........
We also need to keep track of:
- Opened parenthesis - so that we finitely construct for `n`
- Closed parenthesis - so that we balance the string

    (,1,1
   /     \
 (,0,2  ),0,0
 /   \
[]  ),0,1
       \
      ),0,0

The pair of (open, closed) gives us the base condition
"""
def generate(n):
    vals = []
    q = [(n - 1, 1, ['('])]

    while q:
        (to_open, to_close, s) = q.pop()
        if to_open == 0 and to_close == 0: vals.append("".join(s))
        if to_open > 0: q.append( ( to_open - 1, to_close + 1, s + ['('] ) )
        if to_close > 0: q.append( ( to_open, to_close - 1, s + [')'] ) )

    return vals
