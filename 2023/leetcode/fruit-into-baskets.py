#O(n^2)
def calc_brute(fruits):
  maks = 0
  for i in range(0, len(fruits)):
    maks = max(maks, calc_brute_index(fruits, i))

  return maks

def calc_brute_index(fruits, index):
  items = []

  for i in range(index, len(fruits)):
    if fruits[i] not in items: items.append(fruits[i])
    if len(items) > 2: return i - index

  return i - index + 1 # plus one for the last element

#O(n+k) - k is the distance from right to left pointer, can be treated as constant so O(n)
def calc(fruits):
  left_pointer = 0
  maks = 0
  current_window = {} # sliding window

  for right_pointer in range(len(fruits)):
    cur_fruit = fruits[right_pointer]

    if cur_fruit not in current_window:
      current_window[cur_fruit] = 0

    # increase count for current fruit in the window
    current_window[cur_fruit] += 1

    # validate current window - at most two elements
    while len(current_window) > 2:
      leftest_fruit = fruits[left_pointer]
      current_window[leftest_fruit] -= 1
      if current_window[leftest_fruit] == 0: del current_window[leftest_fruit]
      left_pointer += 1

    maks = max(maks, right_pointer - left_pointer + 1)

  return maks

      #1    #2    #?
l1 = [1, 1, 2, 2, 4]
      #--------#
            #-----#
print(calc(l1), calc_brute(l1), 4)

      #1    #2       #?
l2 = [1, 1, 2, 2, 1, 4]
      #-----------#
                  #---#
print(calc(l2), calc_brute(l2), 5)

      #1    #2          #?
l3 = [1, 1, 2, 1, 1, 4]
     #------------#
                  #-----#
print(calc(l3), calc_brute(l3), 5)

      #1    #2    #?
l4 = [1, 1, 2, 2, 4, 4, 4, 4, 4]
      #--------#
            #-----------------#
print(calc(l4), calc_brute(l4), 7)

      #1    #2       !
l5 = [1, 1, 2, 2, 1, 4, 5, 5, 5, 5, 5, 5]
      #-----------#
                     #-----------------#
print(calc(l5), calc_brute(l5), 7)

      #1    #2       !
l6 = [1, 1, 2, 2, 1, 5, 5, 5, 5, 5, 5, 5]
      #-----------#
                  #--------------------#
print(calc(l6), calc_brute(l6), 8)

l7 = [1,0,1,0,1,0,1]
      #-----------#
print(calc(l7), calc_brute(l7), 7)

l8 = [1,0,1,0,1,0,3,3,3,3,3,3,0]
      #---------#
                #-------------#
print(calc(l8), calc_brute(l8), 8)

l9 = [1,0,1,0,1,0,0,3,3,3,3,3,3,0]
      #-----------#
                #---------------#
print(calc(l9), calc_brute(l9), 9)
