import socket, sys, re, random, threading, time

max_threads = 500
to = 10.0
conn_repeat = 5

proxylist = set()

try:
	if sys.argv[1] == '?':
		print("Parametri: python telefoni.py [max_threads(int)] [timeout(float)] [conn_repeat(int)]")
		raise
except IndexError:
	pass
except:
	sys.exit()

try:
	max_threads = int(sys.argv[2])
	to = float(sys.argv[3])
	conn_repeat = int(sys.argv[4])
except:
	pass

totalcount = 0
success = 0

t = int(input("Vnesi max id: "))

startup = time.time()

class Thread(threading.Thread):
	def __init__(self, host, port, connrep=1, to=10.0):
		global t
		self.host = host
		self.port = port
		self.connrep = connrep
		self.to = to
		self.rand = round(random.random()*100)%t
		if (self.rand == 0): self.rand = t
		self.web = "http://www.telefoni.com.mk/reviews.php?id=" + str(self.rand)
		threading.Thread.__init__(self)

	def GoHunt(self):
		data = b"GET " + bytes(str(self.web), "ascii") + b"\n\n"

		socket.setdefaulttimeout(self.to)
		client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		client_socket.settimeout(self.to)
		client_socket.connect((self.host, self.port))
		client_socket.send(data)
		x = "BoR0"
		m = ""
		p = 0

		while True:
			x = client_socket.recv(8192)
			if not x: break
			p = 1
			x = str(x, "ascii", "ignore")
			m = m + x

		client_socket.close()
		if (p == 0): return 0
		p = m.find("<title>") + len("<title>")
		q = m.find("</title>")

		#promenlivite potrebni za ga.js
		utmdt = m[p:q] #title
		utmn = str(round(random.random()*2147483647)) #prv random
		utmhid = str(round(random.random()*2147483647)) #vtor random
		
		self.web = "http://www.google-analytics.com/ga.js" #ua gugl!
		data = b"GET " + bytes(str(self.web), "ascii") + b"\n\n"
		client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		client_socket.settimeout(self.to)
		client_socket.connect((self.host, self.port))
		client_socket.send(data)

		p = 0
		while True:
			x = client_socket.recv(8192)
			if not x: break
			p = 1

		client_socket.close()
		if (p == 0): return 0
		
		self.web = "http://www.google-analytics.com/__utm.gif?utmwv=4.8.9&utmn="+utmn+"&utmhn=www.telefoni.com.mk&utmcs=UTF-8&utmsr=1440x900&utmsc=24-bit&utmul=en-gb&utmje=1&utmfl=10.2%20r152&utmdt="+utmdt+"&utmhid="+utmhid+"&utmr=-&utmp=%2Freviews.php%3Fid%3D"+str(self.rand)+"&utmac=UA-21706455-1&utmcc=__utma%3D237993861.1911533574.1300908973.1300908973.1300908973.1%3B%2B__utmz%3D237993861.1300908973.1.1.utmcsr%3D(direct)%7Cutmccn%3D(direct)%7Cutmcmd%3D(none)%3B&utmu=q"
		
		data = b"GET " + bytes(str(self.web), "ascii") + b"\n\n"
		client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		client_socket.settimeout(self.to)
		client_socket.connect((self.host, self.port))
		client_socket.send(data)
		m = ""

		while True:
			x = client_socket.recv(8192)
			if not x: break
			m = m + str(x, "ascii", "ignore")
			if (m.find("image/gif") != -1):
				client_socket.close()
				return 1

		client_socket.close()
		return 0

	def run(self):
		global success, proxylist

		while (self.connrep != 0):
			try:
				p = self.GoHunt()
			except:
				p = 0
			if (p == 1):
				proxylist.add(self.host + " " + str(self.port) + "\n")
				print(self.host + ":" + str(self.port), "- Uspesno (click)")
				success = success + 1
				break

			self.connrep = self.connrep - 1

try:
	f = open("proxy.txt")
except:
	print("Fajlot proxy.txt ne e najden.  Mi treba proxy lista!")
	sys.exit()

print("Inicijalizirano.  Procesiram...")

while 1:
	host = f.readline().replace("\t", " ").split(" ")
	if host == [""]: break
	try:
		while 1: host.remove("")
	except:
		pass
	if host == ['\n']: continue
	port = int(host[1])
	host = host[0]
	Thread(host, port, conn_repeat, to).start()
	totalcount = totalcount + 1
	while threading.active_count() == max_threads: time.sleep(0.5)

f.close()
while threading.active_count() != 1: time.sleep(0.5)

if len(proxylist) != 0:
	f = open("proxy.latest.txt", "w")
	f.writelines(list(proxylist))
	f.close()
	print("Proxy listata e update-uvana.  Noviot fajl e proxy.latest.txt")

print("Gotovo! Uspesni obidi", str(success) + ". Vkupno vreme pominato", str(int(time.time()-startup)), "sekundi.")
