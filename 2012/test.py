#My results for the test arrays that Ester posted are:

#Array0.txt low [64] Array0.txt high [60] Array0.txt median [55]
#Array1.txt low [253] Array1.txt high [253] Array1.txt median [66]
#Array2.txt low [1596] Array2.txt high [1596] Array2.txt median [228]
#Array3.txt low [576] Array3.txt high [669] Array3.txt median [636]
#Array4.txt low [237] Array4.txt high [235] Array4.txt median [172]
#Array5.txt low [252] Array5.txt high [185] Array5.txt median [186]
#Array6.txt low [236] Array6.txt high [258] Array6.txt median [177]
#Array7.txt low [213] Array7.txt high [199] Array7.txt median [180]
#Array8.txt low [231] Array8.txt high [206] Array8.txt median [192]
#Array9.txt low [282] Array9.txt high [310] Array9.txt median [214]
#Array10.txt low [191] Array10.txt high [232] Array10.txt median [206]


def Partition(L, p, start, end): 	# O(n) + const
	def SwapList(L, index1, index2):
		tmp = L[index1]
		L[index1] = L[index2]
		L[index2] = tmp

	pivotValue = L[p]				# save pivot value
	k = start						# start variable
	SwapList(L, p, end) 			# move pivot to end

	for i in range(start, end):		# iterate from start to end
		if L[i] < pivotValue:		# if the current value is smaller than pivot value
			SwapList(L, i, k)		# swap it with starting position
			k = k + 1				# increase starting position

	SwapList(L, end, k)				# move pivot back

	return k						# return new start, how about end?

def QuickSort(L, start, end):		# T(n) = aT(n/2) + O(n) + const (?)
	def ChoosePivot(L, n):
		return 0
	
	length = end - start
	if (length < 3): return 0
	count = end - start
	p = ChoosePivot(L, len(L))
	print(length)
	split = Partition(L, start, start, end-1)
	count += QuickSort(L, start, split)
	count += QuickSort(L, split+1, end)
	return count

#p = [3,8,2,5,1,4,7,6,234,124,25,623,2]
#QuickSort(p, 0, len(p))
#print(p)
#quit()
p = open("Array1.txt", "r")
L = []
for line in p:
	line = line.replace("\r","").replace("\n", "")
	L.append(int(line))
p.close()
#L = [1,2,5,3]
print(L)
count = QuickSort(L, 0, len(L))
print(L)
print(count)