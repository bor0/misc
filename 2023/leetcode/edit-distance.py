import math

class Solution:
    # In recursion bruteforce, each tree contains 3 subtrees. Many overlapping scenarios
    def minDistanceBrute(self, word1, word2):
        if not word1: return len(word2)
        if not word2: return len(word1)
        if word1[0] == word2[0]: return self.minDistanceBrute(word1[1:], word2[1:])

        return 1 + min(self.minDistanceBrute(word1[1:], word2), # removal
                        self.minDistanceBrute(word1[1:], word2[1:]), # replacement
                        self.minDistanceBrute(word1, word2[1:])) # addition

    # Better than minDistanceBrute, but still overlapping
    def minDistanceBetterRecursion(self, word1, word2):
        q = [(word1, word2, 0)]
        minimum = math.inf

        while q:
            (word1, word2, value) = q.pop()

            if not word1:
                minimum = min(minimum, len(word2) + value)
            elif not word2:
                minimum = min(minimum, len(word1) + value)
            elif word1[0] == word2[0]:
                q.append((word1[1:], word2[1:], value))
            else:
                q.append((word1[1:], word2,   value + 1)) # removal
                q.append((word1[1:], word2[1:], value + 1)) # replacement
                q.append((word1,   word2[1:], value + 1)) # addition
                #print(q)
                #quit()

        print(q)

        return minimum 

    def minDistanceMemo(self, word1, word2):
        memo = {}
        # Helper function for recursion
        def minDistanceHelper(w1, w2):
            if not w1:
                return len(w2)
            elif not w2:
                return len(w1)
            elif (w1, w2) in memo:
                return memo[(w1, w2)]
            elif w1[0] == w2[0]:
                result = minDistanceHelper(w1[1:], w2[1:])
            else:
                remove = 1 + minDistanceHelper(w1[1:], w2)
                replace = 1 + minDistanceHelper(w1[1:], w2[1:])
                add = 1 + minDistanceHelper(w1, w2[1:])
                result = min(remove, replace, add)

            memo[(w1, w2)] = result
            return result

        return minDistanceHelper(word1, word2)

    # Dynamic Prog
    def minDistance(self, word1, word2):
        """
  word1= ABCXYZ
 word2= D0123456
        E1......
        F2......
         3......
        """
        dp = [ [ 0 for _ in range(len(word2) + 1)] for _ in range(len(word1) + 1) ]

        if word1 == word2: return 0
        if not word1: return len(word2)
        if not word2: return len(word1)

        for i in range(len(word1) + 1): dp[i][0] = i
        for j in range(len(word2) + 1): dp[0][j] = j
        #print(dp)
        for i in range(1, len(word1) + 1):
            for j in range(1, len(word2) + 1):
                if word1[i-1] == word2[j-1]: # equal char
                    dp[i][j] = dp[i-1][j-1]
                else:
                    dp[i][j] = 1 + min( dp[i-1][j], # removal
                                    dp[i-1][j-1],   # replacement
                                    dp[i][j-1],     # addition
                    )
        #print(dp)

        return dp[-1][-1]
