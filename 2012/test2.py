import random
total = 0
def _doquicksort(values, left, right):
	global total
	"""Quick sort"""
	def partition(values, left, right, pivotidx):
		global total
		"""In place paritioning from left to right using the element at
		pivotidx as the pivot. Returns the new pivot position."""
 
		pivot = values[pivotidx]
		# swap pivot and the last element
		values[right], values[pivotidx] = values[pivotidx], values[right]
 
		storeidx = left
		for idx in range(left, right):
			if values[idx] < pivot:
				values[idx], values[storeidx] = values[storeidx], values[idx]
				storeidx += 1
		# move pivot to the proper place
		values[storeidx], values[right] = values[right], values[storeidx]
		return storeidx
 
	length = right - left
	if (length < 1): return
	total += length
	pivotidx = partition(values, left, right, left)
	_doquicksort(values, left, pivotidx-1)
	_doquicksort(values, pivotidx+1, right)
 
	return values
 
def quicksort(mylist):
	return _doquicksort(mylist, 0, len(mylist) - 1)

p = open("Array0.txt", "r")
L = []
for line in p:
	line = line.replace("\r","").replace("\n", "")
	L.append(int(line))
p.close()
#L = [1,2,5,3]
print(L)
print(total)
quicksort(L)
print(L)
print(total)
