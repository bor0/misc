class RebelAllianceComm:
 def countFrequencies(a,A,k,m):
  L = {}
  while A not in L:
   L[A] = 1
   A = A*k%m
  return len(L)