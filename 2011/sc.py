import subprocess, urllib.request as urllib

def parseTitle(s):
	prefix = '","title":"'
	locS = s.find(prefix)
	s = s[locS + len(prefix):]
	locE = s.find('","')
	return s[:locE]

def parseURL(s):
	prefix = '","streamUrl":"'
	locS = s.find(prefix)
	s = s[locS + len(prefix):]
	locE = s.find('","')
	return s[:locE]

u = urllib.urlopen(input("Enter soundcloud webpage: "))
s = str(u.read())
u.close()

title = parseTitle(s).replace("\\", "")
url = parseURL(s).replace("\\", "")

print(title)
print(url)

f = open(title + ".mp3", 'wb')

u = urllib.urlopen(url)

print("Initiating download...")

block_sz = 8192
length = 0

while True:
	buffer = u.read(block_sz)
	if not buffer:
		break

	length = length + len(buffer)
	f.write(buffer)

u.close()

print("Downloaded " + str(length) + " bytes (" + str(length/1048576)[:4] + "MB).")