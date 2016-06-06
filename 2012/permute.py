import math
class BiggestFactor:
 s = set()

 def isprime(_self_, n):
  if n == 2:
   return 1
  if n % 2 == 0:
   return 0

  max = n**0.5+1
  i = 3

  while i <= max:
   if n % i == 0:
    return 0
   i+=2

  return 1

 def factor(_self_,n):  
  fact=[1,n]  
  check=2  
  rootn=math.sqrt(n)  
  while check<rootn:  
   if n%check==0:  
    _self_.s.add(check)  
    _self_.s.add(n/check)  
   check+=1  
   if rootn==check:  
    _self_.s.add(check)  

 def permute(_self_, L, string=""):
  if (string != ""):
   _self_.factor(int(string))
  
  for e in L:
   p = L[:]
   p.remove(e)
   _self_.permute(p, str(string) + str(e))

 def prime(_self_,digits):
  _self_.permute(digits)
  print("OK")
  _self_.s = sorted(_self_.s, reverse=True)
  print("OK")
  for e in _self_.s:
   e = int(e)
   if (_self_.isprime(e)): return e

x = BiggestFactor()
y = x.prime([3,4,5,6,7,8,9])
print(y)