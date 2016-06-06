import os,re,threading,sys

i=0

class Thread(threading.Thread):
	def __init__(self, host, count=4):
		self.host = host
		self.count = count
		threading.Thread.__init__(self)

	def run(self):
		lifeline = re.compile("Received = (\d)")
		pingresult = os.popen("ping -n " + str(self.count) + " " + self.host).readlines()
		try:
			x = re.findall(lifeline,pingresult[12])
		except:
			return 0.0
		if float(x[0])/self.count != 0:
			global i
			i=i+1
			print(str(i) + ": " + self.host + " is alive.")
		#print(self.host + ": " + str(float(x[0])/4.0))

p = ""

try:
	p = sys.argv[1]
except:
	pass

for x in (range(255)):
	Thread("192.168.0." + str(x), 1).start()

while threading.active_count() != 1: pass
print("Total alive " + str(i) + " out of 255 hosts.")